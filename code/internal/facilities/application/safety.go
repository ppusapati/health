package application

import (
	"context"
	"fmt"

	"github.com/ppusapati/health/code/internal/facilities/domain"
	"github.com/ppusapati/health/code/internal/facilities/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
)

// RaiseDeficiencyInput records a fire or life-safety finding (SRS-FAC-008).
type RaiseDeficiencyInput struct {
	TaskID       string
	AssetID      string
	FacilityID   string
	LocationID   string
	LocationNote string
	System       string
	Severity     string
	Finding      string
	Standard     string
	DueAt        string
	// WorkOrderID is the work raised to fix it. Left empty for a critical
	// finding, the service raises one: a critical deficiency that is only
	// a note is one nobody is assigned to, and making the inspector fill
	// in a second form is how that happens.
	WorkOrderID string
	// ClassCode shapes the work order raised for a critical finding.
	ClassCode string
	Priority  string
}

// RaisedDeficiency is a finding and the work raised for it.
type RaisedDeficiency struct {
	Deficiency domain.Deficiency
	WorkOrder  domain.WorkOrder
	RaisedWork bool
}

// RaiseDeficiency records a fire or life-safety finding (SRS-FAC-008).
func (s *Service) RaiseDeficiency(ctx context.Context,
	in RaiseDeficiencyInput) (RaisedDeficiency, error) {

	session, scope, err := s.authorize(ctx, PermSafetyRaise)
	if err != nil {
		return RaisedDeficiency{}, err
	}
	now := s.clock.Now()

	dueAt, err := parseTime(in.DueAt)
	if err != nil {
		return RaisedDeficiency{}, err
	}

	var out RaisedDeficiency
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		workOrderID := in.WorkOrderID
		severity := domain.Severity(in.Severity)

		if severity == domain.SeverityCritical && workOrderID == "" {
			class := in.ClassCode
			if class == "" {
				class = "general"
			}
			priority := in.Priority
			if priority == "" {
				priority = string(domain.PriorityUrgent)
			}
			order, err := s.raiseWithin(ctx, session, scope,
				RaiseWorkInput{
					FacilityID:   in.FacilityID,
					AssetID:      in.AssetID,
					System:       in.System,
					LocationID:   in.LocationID,
					LocationNote: in.LocationNote,
					Fault:        in.Finding,
					Impact: fmt.Sprintf(
						"critical life-safety deficiency against %s",
						standardOrSystem(in.Standard, in.System)),
					Priority: priority, ClassCode: class,
				}, now)
			if err != nil {
				return err
			}
			out.WorkOrder, out.RaisedWork = order, true
			workOrderID = order.ID
		}

		deficiency, err := domain.RaiseDeficiency(s.ids.NewID(),
			session.TenantID, domain.RaiseDeficiencyInput{
				TaskID: in.TaskID, AssetID: in.AssetID,
				FacilityID:   in.FacilityID,
				LocationID:   in.LocationID,
				LocationNote: in.LocationNote,
				System:       domain.System(in.System),
				Severity:     severity,
				Finding:      in.Finding, Standard: in.Standard,
				DueAt: dueAt, WorkOrderID: workOrderID,
			}, session.SubjectID, now)
		if err != nil {
			return facilitiesError(err)
		}
		if err := s.deficiencies.InsertDeficiency(ctx, scope,
			deficiency); err != nil {
			return err
		}
		out.Deficiency = deficiency

		if err := s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.deficiency.raised",
			ResourceType: "facilities.deficiency",
			ResourceID:   deficiency.ID,
			Outcome:      audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"severity":      string(deficiency.Severity),
				"system":        string(deficiency.System),
				"standard":      deficiency.Standard,
				"work_order_id": deficiency.WorkOrderID,
			}),
			Reason: deficiency.Finding,
		}, now); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventDeficiencyRaised,
			"facilities.deficiency", deficiency.ID, map[string]any{
				"severity":    string(deficiency.Severity),
				"system":      string(deficiency.System),
				"facility_id": deficiency.FacilityID,
			}, now); err != nil {
			return err
		}

		if deficiency.Severity != domain.SeverityCritical {
			return nil
		}
		// A critical life-safety finding is told to somebody now. The
		// alternative is that it waits on a screen until the next
		// inspection, which is how a blocked stairwell stays blocked.
		return s.escalate(ctx, session, scope, ports.Notice{
			Kind:       EscalationFireSafety,
			Subject:    deficiency.ID,
			FacilityID: deficiency.FacilityID,
			Summary: fmt.Sprintf("critical %s deficiency: %s",
				deficiency.System, deficiency.Finding),
		}, now)
	})
	if err != nil {
		return RaisedDeficiency{}, err
	}
	return out, nil
}

func standardOrSystem(standard, system string) string {
	if standard != "" {
		return standard
	}
	return system
}

// MitigateDeficiencyInput records an interim measure.
type MitigateDeficiencyInput struct {
	DeficiencyID string
	Note         string
	Version      int64
}

// MitigateDeficiency records an interim measure (SRS-FAC-008).
//
// It does not close the finding, and there is no way from here that does. A
// fire watch recorded as a fix is how a hospital ends up with a fire watch
// nobody stands down and a door nobody repairs.
func (s *Service) MitigateDeficiency(ctx context.Context,
	in MitigateDeficiencyInput) (domain.Deficiency, error) {

	session, scope, err := s.authorize(ctx, PermSafetyRaise)
	if err != nil {
		return domain.Deficiency{}, err
	}
	now := s.clock.Now()

	var out domain.Deficiency
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		deficiency, err := s.deficiencies.Deficiency(ctx, scope,
			in.DeficiencyID)
		if err != nil {
			return err
		}
		if err := deficiency.Mitigate(in.Note, session.SubjectID,
			now); err != nil {
			return facilitiesError(err)
		}
		versionSeen := expected(in.Version, deficiency.Version)
		if err := s.deficiencies.UpdateDeficiency(ctx, scope,
			deficiency,
			versionSeen); err != nil {
			return facilitiesError(err)
		}
		deficiency.Version = applied(versionSeen)
		out = deficiency
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.deficiency.mitigated",
			ResourceType: "facilities.deficiency",
			ResourceID:   deficiency.ID,
			Outcome:      audit.OutcomeSuccess,
			Reason:       deficiency.MitigationNote,
		}, now)
	})
	if err != nil {
		return domain.Deficiency{}, err
	}
	return out, nil
}

// CloseDeficiencyInput certifies a finding fixed.
type CloseDeficiencyInput struct {
	DeficiencyID string
	EvidenceRef  string
	Version      int64
}

// CloseDeficiency certifies a life-safety finding fixed (SRS-FAC-008).
func (s *Service) CloseDeficiency(ctx context.Context,
	in CloseDeficiencyInput) (domain.Deficiency, error) {

	session, scope, err := s.authorize(ctx, PermSafetyClose)
	if err != nil {
		return domain.Deficiency{}, err
	}
	now := s.clock.Now()

	var out domain.Deficiency
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		deficiency, err := s.deficiencies.Deficiency(ctx, scope,
			in.DeficiencyID)
		if err != nil {
			return err
		}
		if err := deficiency.CloseDeficiency(in.EvidenceRef,
			session.SubjectID, now); err != nil {
			return facilitiesError(err)
		}
		versionSeen := expected(in.Version, deficiency.Version)
		if err := s.deficiencies.UpdateDeficiency(ctx, scope,
			deficiency,
			versionSeen); err != nil {
			return facilitiesError(err)
		}
		deficiency.Version = applied(versionSeen)
		out = deficiency
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.deficiency.closed",
			ResourceType: "facilities.deficiency",
			ResourceID:   deficiency.ID,
			Outcome:      audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"evidence_ref": deficiency.ClosureEvidenceRef,
				"severity":     string(deficiency.Severity),
			}),
		}, now)
	})
	if err != nil {
		return domain.Deficiency{}, err
	}
	return out, nil
}

// DeficiencyFilterInput narrows a life-safety finding list.
//
// It has no time window, deliberately. See ports.DeficiencyFilter.
type DeficiencyFilterInput struct {
	FacilityID string
	TaskID     string
	Severity   string
	OpenOnly   bool
	PageSize   int32
}

// ListDeficiencies reads life-safety findings (SRS-FAC-008).
func (s *Service) ListDeficiencies(ctx context.Context,
	in DeficiencyFilterInput) ([]domain.Deficiency, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.deficiencies.Deficiencies(ctx, scope, ports.DeficiencyFilter{
		FacilityID: in.FacilityID, TaskID: in.TaskID,
		Severity: domain.Severity(in.Severity), OpenOnly: in.OpenOnly,
		Limit: clampPageSize(in.PageSize),
	})
}

// OpenCriticalDeficiencies is SRS-FAC-008's acceptance as a call.
//
// Every open critical finding, unmitigated first, with no window and no
// paging beyond the report limit. A list that aged things out would let a
// hospital stop seeing the stairwell it never unblocked.
func (s *Service) OpenCriticalDeficiencies(ctx context.Context,
	facilityID string) ([]domain.Deficiency, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	all, err := s.deficiencies.Deficiencies(ctx, scope,
		ports.DeficiencyFilter{FacilityID: facilityID, OpenOnly: true,
			Limit: reportPageSize})
	if err != nil {
		return nil, err
	}
	return domain.OpenCritical(all), nil
}

// BlockingDeficiencies lists the findings that stop an inspection being
// signed off (SRS-FAC-008).
func (s *Service) BlockingDeficiencies(ctx context.Context, taskID string) (
	[]domain.Deficiency, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	found, err := s.deficiencies.Deficiencies(ctx, scope,
		ports.DeficiencyFilter{TaskID: taskID, OpenOnly: true,
			Limit: reportPageSize})
	if err != nil {
		return nil, err
	}
	return domain.Blocking(taskID, found), nil
}

// SafetyReport is the life-safety picture (SRS-FAC-008).
func (s *Service) SafetyReport(ctx context.Context, facilityID, from,
	to string) (domain.SafetyReport, error) {

	_, scope, err := s.authorize(ctx, PermReportRead)
	if err != nil {
		return domain.SafetyReport{}, err
	}
	windowFrom, err := parseTime(from)
	if err != nil {
		return domain.SafetyReport{}, err
	}
	windowTo, err := parseTime(to)
	if err != nil {
		return domain.SafetyReport{}, err
	}
	now := s.clock.Now()
	if windowTo.IsZero() {
		windowTo = now
	}

	all, err := s.deficiencies.Deficiencies(ctx, scope,
		ports.DeficiencyFilter{FacilityID: facilityID,
			Limit: reportPageSize})
	if err != nil {
		return domain.SafetyReport{}, err
	}
	return domain.SummariseSafety(all, windowFrom, windowTo, now), nil
}

// SweepOverdueDeficiencies escalates critical findings past their date
// (SRS-FAC-008).
//
// Returns how many were escalated. A report nobody opens is not a control,
// and a critical life-safety finding that went past the date somebody
// promised is exactly the thing a report will not catch in time.
func (s *Service) SweepOverdueDeficiencies(ctx context.Context,
	facilityID string) (int, error) {

	session, scope, err := s.authorize(ctx, PermSafetyRaise)
	if err != nil {
		return 0, err
	}
	now := s.clock.Now()

	escalated := 0
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		open, err := s.deficiencies.Deficiencies(ctx, scope,
			ports.DeficiencyFilter{FacilityID: facilityID,
				Severity: domain.SeverityCritical,
				OpenOnly: true, Limit: reportPageSize})
		if err != nil {
			return err
		}
		for _, d := range open {
			if d.DueAt.IsZero() {
				continue
			}
			if !now.After(d.DueAt.AddDate(0, 0,
				s.config.DeficiencyGraceDays)) {
				continue
			}
			if err := s.escalate(ctx, session, scope, ports.Notice{
				Kind:    EscalationFireSafety,
				Subject: d.ID, FacilityID: d.FacilityID,
				Summary: fmt.Sprintf(
					"critical %s deficiency overdue since %s: %s",
					d.System, d.DueAt.Format("2006-01-02"),
					d.Finding),
			}, now); err != nil {
				return err
			}
			escalated++
		}
		return nil
	})
	if err != nil {
		return 0, err
	}
	return escalated, nil
}
