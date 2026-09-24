package application

import (
	"context"
	"fmt"

	"github.com/ppusapati/health/code/internal/facilities/domain"
	"github.com/ppusapati/health/code/internal/facilities/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
)

// RaiseWorkInput opens a facilities work order (SRS-FAC-002).
type RaiseWorkInput struct {
	Number       string
	FacilityID   string
	AssetID      string
	System       string
	LocationID   string
	LocationNote string
	Fault        string
	Impact       string
	Priority     string
	ClassCode    string
	// OwnerTeam overrides the configured routing. Empty means route from
	// the system, which is what every caller from the wire does: the
	// proto has no field for it, so a ward cannot hand its own ticket to
	// a team of its choosing.
	//
	// The alarm path sets it, because an alarm rule names who the
	// resulting work goes to and a rule whose team is ignored is
	// configuration that looks like it is doing something.
	OwnerTeam string
}

// RaiseWork opens a work order (SRS-FAC-002).
//
// The owner and the SLA are both resolved here rather than asked for, which
// is the acceptance: a ward reporting a leak does not know which team owns
// plumbing and should not have to.
func (s *Service) RaiseWork(ctx context.Context, in RaiseWorkInput) (
	domain.WorkOrder, error) {

	session, scope, err := s.authorize(ctx, PermWorkRaise)
	if err != nil {
		return domain.WorkOrder{}, err
	}
	now := s.clock.Now()

	var out domain.WorkOrder
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		order, err := s.raiseWithin(ctx, session, scope, in, now)
		if err != nil {
			return err
		}
		out = order
		return nil
	})
	if err != nil {
		return domain.WorkOrder{}, err
	}
	return out, nil
}

// raiseWithin opens a work order inside an open transaction.
//
// Shared with the alarm path, so a ticket raised from a gateway event goes
// through the same routing, the same SLA and the same escalation as one a
// ward telephoned in. Two paths would be two sets of rules, and the
// automated one would be the weaker.
func (s *Service) raiseWithin(ctx context.Context, session authctx.Session,
	scope authctx.TenantScope, in RaiseWorkInput, now timeNow) (
	domain.WorkOrder, error) {

	class, err := s.classes.WorkClass(ctx, scope, in.ClassCode)
	if err != nil {
		return domain.WorkOrder{}, err
	}

	system := domain.System(in.System)
	var criticality domain.Criticality
	if in.AssetID != "" {
		asset, err := s.assets.Asset(ctx, scope, in.AssetID)
		if err != nil {
			return domain.WorkOrder{}, err
		}
		// The asset knows its own system and how critical it is. Taking
		// the system from the caller would let a ticket about the
		// oxygen manifold be filed as plumbing and escalate to nobody.
		system = asset.System
		criticality = asset.Criticality
	}

	number := in.Number
	if number == "" {
		number = "WO-" + s.ids.NewID()
	}

	owner := in.OwnerTeam
	if owner == "" {
		owner = s.config.team(system)
	}

	order, err := domain.Raise(s.ids.NewID(), session.TenantID,
		domain.RaiseInput{
			Number: number, FacilityID: in.FacilityID,
			AssetID: in.AssetID, System: system,
			LocationID: in.LocationID, LocationNote: in.LocationNote,
			Fault: in.Fault, Impact: in.Impact,
			Priority: domain.Priority(in.Priority),
			Class:    class, OwnerTeam: owner,
		}, s.config.slaPolicy(), session.SubjectID, now)
	if err != nil {
		return domain.WorkOrder{}, facilitiesError(err)
	}
	if err := s.work.InsertWorkOrder(ctx, scope, order); err != nil {
		return domain.WorkOrder{}, err
	}

	if err := s.appendAudit(ctx, session, audit.Record{
		Action:       "facilities.work_order.raised",
		ResourceType: "facilities.work_order", ResourceID: order.ID,
		Outcome: audit.OutcomeSuccess,
		Context: auditContext(map[string]string{
			"number": order.Number, "system": string(order.System),
			"priority": string(order.Priority),
			"class":    order.ClassCode, "owner_team": order.OwnerTeam,
		}),
	}, now); err != nil {
		return domain.WorkOrder{}, err
	}
	if err := s.appendEvent(ctx, session, EventWorkRaised,
		"facilities.work_order", order.ID, map[string]any{
			"system":      string(order.System),
			"priority":    string(order.Priority),
			"facility_id": order.FacilityID,
		}, now); err != nil {
		return domain.WorkOrder{}, err
	}

	if err := s.escalateIfCritical(ctx, session, scope, order,
		criticality, now); err != nil {
		return domain.WorkOrder{}, err
	}
	return order, nil
}

// escalateIfCritical pages somebody about a critical failure (SRS-FAC-006).
//
// The acceptance is that a critical gas issue receives the *highest
// configured* escalation, so the rung comes from the tenant's own matrix. A
// deployment with a six-rung gas chain gets rung six.
func (s *Service) escalateIfCritical(ctx context.Context,
	session authctx.Session, scope authctx.TenantScope,
	order domain.WorkOrder, criticality domain.Criticality,
	now timeNow) error {

	if order.Priority != domain.PriorityEmergency {
		return nil
	}
	kind := domain.EscalationKind(order.System)

	level := 0
	if s.config.EscalateCriticalGas {
		level = domain.EscalationLevel(order, criticality,
			s.topRung(ctx, scope, kind, order.FacilityID))
	}

	// The summary names the system, the number and the impact in the
	// hospital's own words. No patient, no ward census: a notice goes
	// further and under fewer controls than the record behind it.
	return s.escalate(ctx, session, scope, ports.Notice{
		Kind: kind, Subject: order.ID, FacilityID: order.FacilityID,
		Summary: fmt.Sprintf("%s emergency on %s: %s",
			order.System, order.Number, order.Impact),
		Level: level,
	}, now)
}

// AssignWorkInput gives a work order to somebody.
type AssignWorkInput struct {
	WorkOrderID string
	UserID      string
	Team        string
	Version     int64
}

// AssignWork gives a work order to a person (SRS-FAC-002).
func (s *Service) AssignWork(ctx context.Context, in AssignWorkInput) (
	domain.WorkOrder, error) {

	return s.mutateWork(ctx, PermWorkManage, in.WorkOrderID, in.Version,
		"facilities.work_order.assigned",
		func(order *domain.WorkOrder, session authctx.Session,
			now timeNow) (map[string]string, error) {

			if err := order.Assign(in.UserID, in.Team, now); err != nil {
				return nil, facilitiesError(err)
			}
			return map[string]string{"assignee": order.OwnerUserID}, nil
		})
}

// StartWorkInput begins work, with its safety paperwork.
type StartWorkInput struct {
	WorkOrderID    string
	PermitRef      string
	PermitIssuedBy string
	LOTORef        string
	LOTOAppliedBy  string
	Version        int64
}

// StartWork begins the work (SRS-FAC-002, SRS-FAC-010).
//
// Work of a class that needs a permit additionally needs PermPermit. Two
// checks rather than one, because "may do maintenance" and "may isolate an
// eleven-kilovolt panel" are different questions with different answers, and
// a hospital that conflates them has a permit system on paper only.
func (s *Service) StartWork(ctx context.Context, in StartWorkInput) (
	domain.WorkOrder, error) {

	session, scope, err := s.authorize(ctx, PermWorkManage)
	if err != nil {
		return domain.WorkOrder{}, err
	}
	now := s.clock.Now()

	var out domain.WorkOrder
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		order, err := s.work.WorkOrder(ctx, scope, in.WorkOrderID)
		if err != nil {
			return err
		}
		if order.ClassRequiresPermit || order.ClassRequiresLOTO {
			if !session.HasPermission(PermPermit) {
				return forbidden(PermPermit)
			}
		}
		if err := order.Start(in.PermitRef, in.PermitIssuedBy,
			in.LOTORef, in.LOTOAppliedBy, now); err != nil {
			return facilitiesError(err)
		}
		if err := s.work.UpdateWorkOrder(ctx, scope, order,
			expected(in.Version, order.Version)); err != nil {
			return facilitiesError(err)
		}
		out = order
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.work_order.started",
			ResourceType: "facilities.work_order", ResourceID: order.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"permit_ref": order.PermitRef,
				"loto_ref":   order.LOTORef,
				"class":      order.ClassCode,
			}),
		}, now)
	})
	if err != nil {
		return domain.WorkOrder{}, err
	}
	return out, nil
}

// HoldWorkInput parks a work order.
type HoldWorkInput struct {
	WorkOrderID string
	Reason      string
	Version     int64
}

// HoldWork parks work on something outside the team's control (SRS-FAC-002).
func (s *Service) HoldWork(ctx context.Context, in HoldWorkInput) (
	domain.WorkOrder, error) {

	return s.mutateWork(ctx, PermWorkManage, in.WorkOrderID, in.Version,
		"facilities.work_order.held",
		func(order *domain.WorkOrder, session authctx.Session,
			now timeNow) (map[string]string, error) {

			if err := order.Hold(in.Reason); err != nil {
				return nil, facilitiesError(err)
			}
			return map[string]string{"reason": order.HoldReason}, nil
		})
}

// ResolveWorkInput records work as done.
type ResolveWorkInput struct {
	WorkOrderID     string
	Note            string
	RootCause       string
	DowntimeMinutes int32
	Version         int64
}

// ResolveWork records the work as done (SRS-FAC-002, SRS-FAC-009).
func (s *Service) ResolveWork(ctx context.Context, in ResolveWorkInput) (
	domain.WorkOrder, error) {

	return s.mutateWork(ctx, PermWorkManage, in.WorkOrderID, in.Version,
		"facilities.work_order.resolved",
		func(order *domain.WorkOrder, session authctx.Session,
			now timeNow) (map[string]string, error) {

			if err := order.Resolve(in.Note, in.RootCause,
				int(in.DowntimeMinutes), now); err != nil {
				return nil, facilitiesError(err)
			}
			return map[string]string{
				"downtime_minutes": itoa(order.DowntimeMinutes),
				"root_cause":       order.RootCause,
			}, nil
		})
}

// CloseWorkInput signs work off.
type CloseWorkInput struct {
	WorkOrderID string
	Version     int64
}

// CloseWork signs off resolved work (SRS-FAC-002).
func (s *Service) CloseWork(ctx context.Context, in CloseWorkInput) (
	domain.WorkOrder, error) {

	session, scope, err := s.authorize(ctx, PermWorkClose)
	if err != nil {
		return domain.WorkOrder{}, err
	}
	now := s.clock.Now()

	var out domain.WorkOrder
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		order, err := s.work.WorkOrder(ctx, scope, in.WorkOrderID)
		if err != nil {
			return err
		}
		if err := order.Close(session.SubjectID, now); err != nil {
			return facilitiesError(err)
		}
		if err := s.work.UpdateWorkOrder(ctx, scope, order,
			expected(in.Version, order.Version)); err != nil {
			return facilitiesError(err)
		}
		out = order
		if err := s.appendAudit(ctx, session, audit.Record{
			Action:       "facilities.work_order.closed",
			ResourceType: "facilities.work_order", ResourceID: order.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"number":           order.Number,
				"downtime_minutes": itoa(order.DowntimeMinutes),
			}),
		}, now); err != nil {
			return err
		}
		return s.appendEvent(ctx, session, EventWorkClosed,
			"facilities.work_order", order.ID, map[string]any{
				"system":           string(order.System),
				"downtime_minutes": order.DowntimeMinutes,
				"facility_id":      order.FacilityID,
			}, now)
	})
	if err != nil {
		return domain.WorkOrder{}, err
	}
	return out, nil
}

// CancelWorkInput withdraws a work order.
type CancelWorkInput struct {
	WorkOrderID string
	Reason      string
	Version     int64
}

// CancelWork withdraws a work order that should not have been raised
// (SRS-FAC-002).
func (s *Service) CancelWork(ctx context.Context, in CancelWorkInput) (
	domain.WorkOrder, error) {

	return s.mutateWork(ctx, PermWorkManage, in.WorkOrderID, in.Version,
		"facilities.work_order.cancelled",
		func(order *domain.WorkOrder, session authctx.Session,
			now timeNow) (map[string]string, error) {

			if err := order.Cancel(in.Reason, session.SubjectID,
				now); err != nil {
				return nil, facilitiesError(err)
			}
			return map[string]string{"reason": order.CancelReason}, nil
		})
}

// mutateWork is the shared read-change-write for a work order.
//
// One place that reads, applies the domain change, writes with the version
// and audits. A second copy of this shape is where a transition gets written
// without an audit entry, which is how a maintenance history acquires
// changes nobody made.
func (s *Service) mutateWork(ctx context.Context, permission, workOrderID string,
	version int64, action string,
	change func(*domain.WorkOrder, authctx.Session, timeNow) (
		map[string]string, error)) (domain.WorkOrder, error) {

	session, scope, err := s.authorize(ctx, permission)
	if err != nil {
		return domain.WorkOrder{}, err
	}
	now := s.clock.Now()

	var out domain.WorkOrder
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		order, err := s.work.WorkOrder(ctx, scope, workOrderID)
		if err != nil {
			return err
		}
		attributes, err := change(&order, session, now)
		if err != nil {
			return err
		}
		if err := s.work.UpdateWorkOrder(ctx, scope, order,
			expected(version, order.Version)); err != nil {
			return facilitiesError(err)
		}
		out = order
		return s.appendAudit(ctx, session, audit.Record{
			Action:       action,
			ResourceType: "facilities.work_order", ResourceID: order.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(attributes),
		}, now)
	})
	if err != nil {
		return domain.WorkOrder{}, err
	}
	return out, nil
}

// WorkFilterInput narrows a work order list.
type WorkFilterInput struct {
	FacilityID string
	AssetID    string
	System     string
	State      string
	OpenOnly   bool
	From       string
	To         string
	PageSize   int32
}

// ListWork reads work orders (SRS-FAC-002).
func (s *Service) ListWork(ctx context.Context, in WorkFilterInput) (
	[]domain.WorkOrder, error) {

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
	return s.work.WorkOrders(ctx, scope, ports.WorkOrderFilter{
		FacilityID: in.FacilityID, AssetID: in.AssetID,
		System: domain.System(in.System),
		State:  domain.WorkState(in.State), OpenOnly: in.OpenOnly,
		From: from, To: to, Limit: clampPageSize(in.PageSize),
	})
}

// GetWork reads one work order (SRS-FAC-002).
func (s *Service) GetWork(ctx context.Context, workOrderID string) (
	domain.WorkOrder, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.WorkOrder{}, err
	}
	return s.work.WorkOrder(ctx, scope, workOrderID)
}

// Worklist is the open-work view, worst first (SRS-FAC-002).
func (s *Service) Worklist(ctx context.Context, facilityID string) (
	[]domain.WorkOrder, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()
	open, err := s.work.WorkOrders(ctx, scope, ports.WorkOrderFilter{
		FacilityID: facilityID, OpenOnly: true, Limit: reportPageSize})
	if err != nil {
		return nil, err
	}
	return domain.OpenWork(open, now), nil
}
