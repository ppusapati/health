package application

import (
	"context"
	"fmt"

	"github.com/ppusapati/health/code/internal/facilities/domain"
	"github.com/ppusapati/health/code/internal/facilities/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
)

// PlanOutageInput requests a utility shutdown (SRS-FAC-004).
type PlanOutageInput struct {
	Reference   string
	FacilityID  string
	System      string
	Title       string
	Reason      string
	PlannedFrom string
	PlannedTo   string
	Contingency string
	Areas       []AreaInput
}

// AreaInput is one department a shutdown reaches.
type AreaInput struct {
	OrgUnitID string
	Name      string
	Critical  bool
}

// PlannedOutage is a shutdown and the departments it reaches.
type PlannedOutage struct {
	Outage domain.Outage
	Areas  []domain.OutageArea
	// Overlapping names live shutdowns of the same system whose windows
	// cross this one. A warning rather than a refusal: two isolations of
	// one system over different wards are perfectly reasonable, and the
	// database holds the version of this rule that is not.
	Overlapping []domain.Outage
}

// PlanOutage requests a shutdown and declares who it reaches (SRS-FAC-004).
//
// The areas are declared in the same call as the outage, because the permit
// is approved against a set of consequences and adding one afterwards would
// mean it was approved against a different set.
func (s *Service) PlanOutage(ctx context.Context, in PlanOutageInput) (
	PlannedOutage, error) {

	session, scope, err := s.authorize(ctx, PermOutageRequest)
	if err != nil {
		return PlannedOutage{}, err
	}
	now := s.clock.Now()

	from, err := parseTime(in.PlannedFrom)
	if err != nil {
		return PlannedOutage{}, err
	}
	to, err := parseTime(in.PlannedTo)
	if err != nil {
		return PlannedOutage{}, err
	}

	var out PlannedOutage
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		outage, err := domain.PlanOutage(s.ids.NewID(),
			session.TenantID, domain.PlanOutageInput{
				Reference: in.Reference, FacilityID: in.FacilityID,
				System: domain.System(in.System),
				Title:  in.Title, Reason: in.Reason,
				PlannedFrom: from, PlannedTo: to,
				Contingency: in.Contingency,
			}, session.SubjectID, now)
		if err != nil {
			return facilitiesError(err)
		}
		if err := s.outages.InsertOutage(ctx, scope, outage); err != nil {
			return err
		}
		out.Outage = outage

		for _, area := range in.Areas {
			if err := s.checkOrgUnit(ctx, scope,
				area.OrgUnitID); err != nil {
				return err
			}
			row, err := domain.AddArea(s.ids.NewID(), outage,
				area.OrgUnitID, area.Name, area.Critical, now)
			if err != nil {
				return facilitiesError(err)
			}
			if err := s.outages.InsertArea(ctx, scope, row); err != nil {
				return err
			}
			out.Areas = append(out.Areas, row)
		}

		live, err := s.outages.Outages(ctx, scope, ports.OutageFilter{
			System: outage.System, LiveOnly: true,
			From: outage.PlannedFrom, To: outage.PlannedTo,
			Limit: reportPageSize,
		})
		if err != nil {
			return err
		}
		for _, other := range live {
			if outage.Overlaps(other) {
				out.Overlapping = append(out.Overlapping, other)
			}
		}

		return s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.outage.planned",
			ResourceType: "facilities.outage", ResourceID: outage.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"reference":   outage.Reference,
				"system":      string(outage.System),
				"areas":       itoa(len(out.Areas)),
				"overlapping": itoa(len(out.Overlapping)),
			}),
			Reason: outage.Reason,
		}, now)
	})
	if err != nil {
		return PlannedOutage{}, err
	}
	return out, nil
}

// ApproveOutageInput signs the shutdown permit.
type ApproveOutageInput struct {
	OutageID  string
	PermitRef string
	Version   int64
}

// ApproveOutage signs the permit and notifies the affected departments
// (SRS-FAC-004).
//
// The notification happens here rather than in a later call, because the
// acceptance is that impacted departments receive one — and a permit signed
// today with the telling left for tomorrow is a permit signed without it.
func (s *Service) ApproveOutage(ctx context.Context,
	in ApproveOutageInput) (PlannedOutage, error) {

	session, scope, err := s.authorize(ctx, PermOutageApprove)
	if err != nil {
		return PlannedOutage{}, err
	}
	now := s.clock.Now()

	var out PlannedOutage
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		outage, err := s.outages.Outage(ctx, scope, in.OutageID)
		if err != nil {
			return err
		}
		areas, err := s.outages.Areas(ctx, scope, outage.ID)
		if err != nil {
			return err
		}
		if err := outage.Approve(areas, in.PermitRef,
			session.SubjectID, now); err != nil {
			return facilitiesError(err)
		}
		if err := s.outages.UpdateOutage(ctx, scope, outage,
			expected(in.Version, outage.Version)); err != nil {
			return facilitiesError(err)
		}

		// Re-read: approving cascaded the new state onto every area
		// row through the composite key, so the copies held here are
		// already stale.
		areas, err = s.outages.Areas(ctx, scope, outage.ID)
		if err != nil {
			return err
		}
		for i := range areas {
			if err := areas[i].Notify(now); err != nil {
				return facilitiesError(err)
			}
			if err := s.outages.UpdateArea(ctx, scope, areas[i],
				areas[i].Version); err != nil {
				return facilitiesError(err)
			}
		}

		out.Outage, out.Areas = outage, areas
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.outage.approved",
			ResourceType: "facilities.outage", ResourceID: outage.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"permit_ref": outage.PermitRef,
				"notified":   itoa(len(areas)),
			}),
		}, now)
	})
	if err != nil {
		return PlannedOutage{}, err
	}
	return out, nil
}

// AcknowledgeOutageInput records a department answering.
type AcknowledgeOutageInput struct {
	AreaID    string
	OutageID  string
	Objection string
	Version   int64
}

// AcknowledgeOutage records a department answering a shutdown notice
// (SRS-FAC-004).
func (s *Service) AcknowledgeOutage(ctx context.Context,
	in AcknowledgeOutageInput) (domain.OutageArea, error) {

	session, scope, err := s.authorize(ctx, PermOutageAcknowledge)
	if err != nil {
		return domain.OutageArea{}, err
	}
	now := s.clock.Now()

	var out domain.OutageArea
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		areas, err := s.outages.Areas(ctx, scope, in.OutageID)
		if err != nil {
			return err
		}
		for i := range areas {
			if areas[i].ID != in.AreaID {
				continue
			}
			if err := areas[i].Acknowledge(session.SubjectID,
				in.Objection, now); err != nil {
				return facilitiesError(err)
			}
			if err := s.outages.UpdateArea(ctx, scope, areas[i],
				expected(in.Version, areas[i].Version)); err != nil {
				return facilitiesError(err)
			}
			out = areas[i]
			return s.appendAudit(ctx, session, audit.Record{
				Action:       "facilities.outage.acknowledged",
				ResourceType: "facilities.outage_area",
				ResourceID:   areas[i].ID,
				Outcome:      audit.OutcomeSuccess,
				Context: auditContext(map[string]string{
					"outage_id": in.OutageID,
					"critical":  boolText(areas[i].Critical),
				}),
				Reason: areas[i].Objection,
			}, now)
		}
		return facilitiesError(fmt.Errorf(
			"%w: no area %s on this outage",
			domain.ErrInvalidFacilities, in.AreaID))
	})
	if err != nil {
		return domain.OutageArea{}, err
	}
	return out, nil
}

// StartOutageInput takes a shutdown into effect.
type StartOutageInput struct {
	OutageID string
	Version  int64
}

// StartOutage records the supply going off (SRS-FAC-004).
//
// The critical areas must have answered. "We emailed theatres" and "theatres
// know" are different facts, and only the second is safe to cut the power on.
func (s *Service) StartOutage(ctx context.Context, in StartOutageInput) (
	domain.Outage, error) {

	session, scope, err := s.authorize(ctx, PermOutageApprove)
	if err != nil {
		return domain.Outage{}, err
	}
	now := s.clock.Now()

	var out domain.Outage
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		outage, err := s.outages.Outage(ctx, scope, in.OutageID)
		if err != nil {
			return err
		}
		areas, err := s.outages.Areas(ctx, scope, outage.ID)
		if err != nil {
			return err
		}
		if err := outage.TakeEffect(areas, now); err != nil {
			return facilitiesError(err)
		}
		if err := s.outages.UpdateOutage(ctx, scope, outage,
			expected(in.Version, outage.Version)); err != nil {
			return facilitiesError(err)
		}
		out = outage
		if err := s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.outage.in_effect",
			ResourceType: "facilities.outage", ResourceID: outage.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"reference": outage.Reference,
				"areas":     itoa(len(areas)),
			}),
		}, now); err != nil {
			return err
		}
		return s.appendEvent(ctx, session, EventOutageInEffect,
			"facilities.outage", outage.ID, map[string]any{
				"system":      string(outage.System),
				"facility_id": outage.FacilityID,
			}, now)
	})
	if err != nil {
		return domain.Outage{}, err
	}
	return out, nil
}

// RestoreOutageInput records the supply coming back.
type RestoreOutageInput struct {
	OutageID string
	Version  int64
}

// RestoreOutage records the supply coming back (SRS-FAC-004).
func (s *Service) RestoreOutage(ctx context.Context,
	in RestoreOutageInput) (domain.Outage, error) {

	session, scope, err := s.authorize(ctx, PermOutageApprove)
	if err != nil {
		return domain.Outage{}, err
	}
	now := s.clock.Now()

	var out domain.Outage
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		outage, err := s.outages.Outage(ctx, scope, in.OutageID)
		if err != nil {
			return err
		}
		if err := outage.Restore(session.SubjectID, now); err != nil {
			return facilitiesError(err)
		}
		if err := s.outages.UpdateOutage(ctx, scope, outage,
			expected(in.Version, outage.Version)); err != nil {
			return facilitiesError(err)
		}
		out = outage
		if err := s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.outage.restored",
			ResourceType: "facilities.outage", ResourceID: outage.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"reference": outage.Reference}),
		}, now); err != nil {
			return err
		}
		return s.appendEvent(ctx, session, EventOutageRestored,
			"facilities.outage", outage.ID, map[string]any{
				"system":      string(outage.System),
				"facility_id": outage.FacilityID,
			}, now)
	})
	if err != nil {
		return domain.Outage{}, err
	}
	return out, nil
}

// CancelOutageInput withdraws a shutdown.
type CancelOutageInput struct {
	OutageID string
	Reason   string
	Version  int64
}

// CancelOutage withdraws a shutdown that will not happen (SRS-FAC-004).
func (s *Service) CancelOutage(ctx context.Context, in CancelOutageInput) (
	domain.Outage, error) {

	session, scope, err := s.authorize(ctx, PermOutageRequest)
	if err != nil {
		return domain.Outage{}, err
	}
	now := s.clock.Now()

	var out domain.Outage
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		outage, err := s.outages.Outage(ctx, scope, in.OutageID)
		if err != nil {
			return err
		}
		if err := outage.CancelOutage(in.Reason, now); err != nil {
			return facilitiesError(err)
		}
		if err := s.outages.UpdateOutage(ctx, scope, outage,
			expected(in.Version, outage.Version)); err != nil {
			return facilitiesError(err)
		}
		out = outage
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.outage.cancelled",
			ResourceType: "facilities.outage", ResourceID: outage.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  outage.CancelReason,
		}, now)
	})
	if err != nil {
		return domain.Outage{}, err
	}
	return out, nil
}

// OutageFilterInput narrows a shutdown list.
type OutageFilterInput struct {
	FacilityID string
	System     string
	LiveOnly   bool
	From       string
	To         string
	PageSize   int32
}

// ListOutages reads shutdown permits (SRS-FAC-004).
func (s *Service) ListOutages(ctx context.Context, in OutageFilterInput) (
	[]domain.Outage, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	from, err := parseTime(in.From)
	if err != nil {
		return nil, err
	}
	to, err := parseTime(in.To)
	if err != nil {
		return nil, err
	}
	return s.outages.Outages(ctx, scope, ports.OutageFilter{
		FacilityID: in.FacilityID, System: domain.System(in.System),
		LiveOnly: in.LiveOnly, From: from, To: to,
		Limit: clampPageSize(in.PageSize),
	})
}

// GetOutage reads one shutdown with the departments it reaches
// (SRS-FAC-004).
func (s *Service) GetOutage(ctx context.Context, outageID string) (
	PlannedOutage, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return PlannedOutage{}, err
	}
	outage, err := s.outages.Outage(ctx, scope, outageID)
	if err != nil {
		return PlannedOutage{}, err
	}
	areas, err := s.outages.Areas(ctx, scope, outageID)
	if err != nil {
		return PlannedOutage{}, err
	}
	return PlannedOutage{Outage: outage, Areas: areas}, nil
}
