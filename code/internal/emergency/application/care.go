package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/emergency/domain"
	"github.com/ppusapati/health/code/internal/emergency/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Triage, the queue, pathways and the timeline.

// TriageInput is one assessment (SRS-ER-002).
type TriageInput struct {
	VisitID          string
	AcuityCode       string
	RespiratoryRate  *int
	HeartRate        *int
	SystolicBP       *int
	OxygenSaturation *int
	Temperature      *float64
	PainScore        *int
	Consciousness    string
	RedFlags         []string
	Note             string
}

// Triage records an assessment and moves the visit on (SRS-ER-002).
//
// Re-triage is the same call. A patient deteriorating in the waiting room is
// exactly who re-assessment exists for, and a separate "re-triage" operation
// would be one a department under pressure skips.
func (s *Service) Triage(ctx context.Context, in TriageInput) (domain.Triage, error) {
	session, scope, err := s.authorize(ctx, PermTriage)
	if err != nil {
		return domain.Triage{}, err
	}

	now := s.clock.Now()
	var out domain.Triage

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		visit, err := s.visits.GetVisit(ctx, scope, in.VisitID)
		if err != nil {
			return err
		}
		if !visit.Status.Open() {
			return rpcerr.FailedPrecondition("ER_VISIT_CLOSED",
				"this visit already has a disposition")
		}

		flags := make([]domain.RedFlag, 0, len(in.RedFlags))
		for _, flag := range in.RedFlags {
			flags = append(flags, domain.RedFlag(flag))
		}

		triage, err := domain.NewTriage(s.ids.NewID(), scope.TenantID(),
			domain.NewTriageInput{
				VisitID: visit.ID, Scale: s.config.scale(), AcuityCode: in.AcuityCode,
				RespiratoryRate: in.RespiratoryRate, HeartRate: in.HeartRate,
				SystolicBP: in.SystolicBP, OxygenSaturation: in.OxygenSaturation,
				Temperature: in.Temperature, PainScore: in.PainScore,
				Consciousness: in.Consciousness, RedFlags: flags, Note: in.Note,
				Mandatory: s.config.Mandatory,
			}, session.SubjectID, now)
		if err != nil {
			return emergencyError(err)
		}
		if err := s.visits.InsertTriage(ctx, scope, triage); err != nil {
			return err
		}

		// The first triage moves the visit on and stops the door-to-triage
		// clock. A re-triage does neither: the clock measures how long the
		// patient waited to be assessed, and a deteriorating patient
		// re-assessed at two hours did not wait two hours for their first.
		if visit.Status == domain.StatusArrived {
			expected := visit.Version
			visit.Status = domain.StatusTriaged
			visit.UpdatedAt = now
			if err := s.visits.UpdateVisit(ctx, scope, visit, expected); err != nil {
				return emergencyError(err)
			}

			event, err := domain.NewEvent(s.ids.NewID(), scope.TenantID(),
				domain.NewEventInput{
					VisitID: visit.ID, Kind: domain.EventTriage,
					Detail:     triage.ScaleName + " " + triage.AcuityCode,
					OccurredAt: now,
				}, session.SubjectID, now)
			if err != nil {
				return emergencyError(err)
			}
			if err := s.visits.InsertEvent(ctx, scope, event); err != nil {
				return err
			}
		}

		if err := s.appendEvent(ctx, session, EventVisitTriaged,
			"emergency_visit", visit.ID, map[string]any{
				"visit_id":    visit.ID,
				"patient_id":  visit.PatientID,
				"scale":       triage.ScaleName,
				"acuity_code": triage.AcuityCode,
				"acuity_rank": triage.AcuityRank,
				// Whether the assessment was complete travels; which fields
				// were missing does not, because that is the observation set
				// and belongs to the chart.
				"complete": triage.Complete(),
			}, now); err != nil {
			return err
		}

		out = triage
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermTriage,
			ResourceType: "emergency_visit", ResourceID: visit.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "triaged " + triage.ScaleName + " " + triage.AcuityCode,
		}, now)
	})
	if err != nil {
		return domain.Triage{}, err
	}
	return out, nil
}

// OverrideInput moves a patient in the queue (SRS-ER-003).
type OverrideInput struct {
	VisitID    string
	AcuityRank int
	Reason     string
}

// Override moves a patient up or down the queue (SRS-ER-003).
//
// Its own permission, because it overrules a triage nurse's assessment. The
// reason is required in both directions: moving somebody down is the decision
// argued about afterwards, and a system demanding a reason only for upgrades
// leaves the harder one unexplained.
func (s *Service) Override(ctx context.Context, in OverrideInput) error {
	session, scope, err := s.authorize(ctx, PermOverride)
	if err != nil {
		return err
	}

	now := s.clock.Now()
	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		visit, err := s.visits.GetVisit(ctx, scope, in.VisitID)
		if err != nil {
			return err
		}

		override := domain.PriorityOverride{
			Rank: in.AcuityRank, Reason: in.Reason,
			By: session.SubjectID, At: now,
		}
		if err := override.Validate(); err != nil {
			return emergencyError(err)
		}
		if err := s.visits.InsertOverride(ctx, scope, visit.ID, override); err != nil {
			return err
		}

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermOverride,
			ResourceType: "emergency_visit", ResourceID: visit.ID,
			Outcome: audit.OutcomeSuccess,
			// The reason is in the audit trail as well as the row: an override
			// is the thing a review asks about first.
			Reason: "queue override to rank " + itoa(in.AcuityRank) + ": " + in.Reason,
		}, now)
	})
}

func itoa(v int) string {
	if v == 0 {
		return "0"
	}
	digits := ""
	negative := v < 0
	if negative {
		v = -v
	}
	for v > 0 {
		digits = string(rune('0'+v%10)) + digits
		v /= 10
	}
	if negative {
		return "-" + digits
	}
	return digits
}

// ActivateInput calls a time-critical team (SRS-ER-005).
type ActivateInput struct {
	VisitID      string
	Kind         domain.PathwayKind
	Label        string
	NotifiedTeam string
}

// Activate starts a time-critical pathway and calls the team (SRS-ER-005).
//
// The activation and the call are one transaction. A pathway recorded without
// the team being called is the failure mode the requirement's "team
// notification" clause exists for — and it is the common one, because the
// activation is what the person at the keyboard can see and the call is not.
func (s *Service) Activate(ctx context.Context, in ActivateInput) (domain.Pathway, error) {
	session, scope, err := s.authorize(ctx, PermActivatePathway)
	if err != nil {
		return domain.Pathway{}, err
	}

	now := s.clock.Now()
	var out domain.Pathway

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		visit, err := s.visits.GetVisit(ctx, scope, in.VisitID)
		if err != nil {
			return err
		}
		if !visit.Status.Open() {
			return rpcerr.FailedPrecondition("ER_VISIT_CLOSED",
				"this visit already has a disposition")
		}

		pathway, err := domain.ActivatePathway(s.ids.NewID(), scope.TenantID(),
			domain.NewPathwayInput{
				VisitID: visit.ID, Kind: in.Kind, Label: in.Label,
				NotifiedTeam: in.NotifiedTeam,
			}, session.SubjectID, now)
		if err != nil {
			return emergencyError(err)
		}

		// SRS-OPSNFR-003 carries the call. A department with no chain
		// configured records the activation and calls nobody through this
		// software, which is a real arrangement rather than a defect — and
		// refusing the activation would be refusing to record a trauma call.
		if s.escalations != nil {
			noticeID, err := s.escalations.RaisePathway(ctx, scope, ports.PathwayNotice{
				PathwayID: pathway.ID, VisitID: visit.ID,
				PatientID: visit.PatientID, FacilityID: visit.FacilityID,
				Kind: string(pathway.Kind), Label: pathway.Label,
				Location: visit.Location, At: now,
			})
			if err != nil {
				return err
			}
			pathway.EscalationNoticeID = noticeID
		}

		if err := s.visits.InsertPathway(ctx, scope, pathway); err != nil {
			return err
		}

		event, err := domain.NewEvent(s.ids.NewID(), scope.TenantID(),
			domain.NewEventInput{
				VisitID: visit.ID, Kind: domain.EventPathwayActivated,
				Detail: string(pathway.Kind), OccurredAt: now,
				PathwayID: pathway.ID,
			}, session.SubjectID, now)
		if err != nil {
			return emergencyError(err)
		}
		if err := s.visits.InsertEvent(ctx, scope, event); err != nil {
			return err
		}

		if err := s.appendEvent(ctx, session, EventPathwayActivated,
			"emergency_pathway", pathway.ID, map[string]any{
				"pathway_id":   pathway.ID,
				"visit_id":     visit.ID,
				"patient_id":   visit.PatientID,
				"facility_id":  visit.FacilityID,
				"kind":         string(pathway.Kind),
				"activated_at": pathway.ActivatedAt.Format(time.RFC3339),
			}, now); err != nil {
			return err
		}

		out = pathway
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermActivatePathway,
			ResourceType: "emergency_pathway", ResourceID: pathway.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  string(pathway.Kind) + " pathway activated",
		}, now)
	})
	if err != nil {
		return domain.Pathway{}, err
	}
	return out, nil
}

// StandDownInput closes an activation that was not needed.
type StandDownInput struct {
	PathwayID string
	Reason    string
}

// StandDown closes a pathway (SRS-ER-005).
func (s *Service) StandDown(ctx context.Context, in StandDownInput) error {
	session, scope, err := s.authorize(ctx, PermActivatePathway)
	if err != nil {
		return err
	}

	now := s.clock.Now()
	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if in.Reason == "" {
			// The domain says the same thing; saying it here avoids a round
			// trip to load a pathway that was never going to be stood down.
			return rpcerr.Invalid("ER_STAND_DOWN_NEEDS_REASON",
				"standing a pathway down needs a reason; a department's "+
					"false-activation rate is a quality measure")
		}
		if err := s.visits.StandDownPathway(ctx, scope, in.PathwayID,
			in.Reason, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermActivatePathway,
			ResourceType: "emergency_pathway", ResourceID: in.PathwayID,
			Outcome: audit.OutcomeSuccess, Reason: "pathway stood down: " + in.Reason,
		}, now)
	})
}

// RecordEventInput is one thing that happened (SRS-ER-008, SRS-ER-009).
type RecordEventInput struct {
	VisitID    string
	Kind       domain.EventKind
	Detail     string
	OccurredAt time.Time
	Sequence   int
	PathwayID  string
	// ProtocolID and PreOrder describe a medication given under a standing
	// order before the order existed (SRS-ER-009).
	ProtocolID string
	PreOrder   bool
}

// RecordEvent appends to the timeline (SRS-ER-008).
func (s *Service) RecordEvent(ctx context.Context, in RecordEventInput) (
	domain.Event, error) {

	session, scope, err := s.authorize(ctx, PermEmergencyWrite)
	if err != nil {
		return domain.Event{}, err
	}

	now := s.clock.Now()
	var out domain.Event

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		visit, err := s.visits.GetVisit(ctx, scope, in.VisitID)
		if err != nil {
			return err
		}

		event, err := domain.NewEvent(s.ids.NewID(), scope.TenantID(),
			domain.NewEventInput{
				VisitID: visit.ID, Kind: in.Kind, Detail: in.Detail,
				OccurredAt: in.OccurredAt, Sequence: in.Sequence,
				PathwayID: in.PathwayID, ProtocolID: in.ProtocolID,
				PreOrder: in.PreOrder,
			}, session.SubjectID, now)
		if err != nil {
			return emergencyError(err)
		}
		if err := s.visits.InsertEvent(ctx, scope, event); err != nil {
			return err
		}

		// A clinician taking the patient stops the door-to-doctor clock and
		// moves the visit on.
		if event.Kind == domain.EventClinicianSeen &&
			(visit.Status == domain.StatusArrived || visit.Status == domain.StatusTriaged) {
			expected := visit.Version
			visit.Status = domain.StatusInTreatment
			visit.UpdatedAt = now
			if err := s.visits.UpdateVisit(ctx, scope, visit, expected); err != nil {
				return emergencyError(err)
			}
		}

		// A drug given ahead of its order is announced, not just recorded.
		// "No silent stock/clinical gap" is the criterion, and a debt visible
		// only to somebody who opens this chart is close enough to silent.
		if event.Outstanding() {
			if err := s.appendEvent(ctx, session, EventAdministrationDue,
				"emergency_event", event.ID, map[string]any{
					"event_id":    event.ID,
					"visit_id":    visit.ID,
					"patient_id":  visit.PatientID,
					"facility_id": visit.FacilityID,
					"protocol_id": event.ProtocolID,
					"occurred_at": event.OccurredAt.Format(time.RFC3339),
				}, now); err != nil {
				return err
			}
		}

		out = event
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermEmergencyWrite,
			ResourceType: "emergency_event", ResourceID: event.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "timeline entry: " + string(event.Kind),
		}, now)
	})
	if err != nil {
		return domain.Event{}, err
	}
	return out, nil
}

// Timeline returns a visit's events and the clocks derived from them
// (SRS-ER-006, SRS-ER-008).
func (s *Service) Timeline(ctx context.Context, visitID string) (
	domain.Timeline, domain.Intervals, error) {

	_, scope, err := s.authorize(ctx, PermEmergencyRead)
	if err != nil {
		return nil, domain.Intervals{}, err
	}
	timeline, err := s.visits.Timeline(ctx, scope, visitID)
	if err != nil {
		return nil, domain.Intervals{}, err
	}
	ordered := timeline.Ordered()
	return ordered, ordered.Clocks(), nil
}

// ReconcileInput writes the order a protocol administration was owed
// (SRS-ER-009).
type ReconcileInput struct {
	EventID string
	OrderID string
}

// Reconcile discharges a pre-order administration (SRS-ER-009).
func (s *Service) Reconcile(ctx context.Context, in ReconcileInput) error {
	session, scope, err := s.authorize(ctx, PermEmergencyWrite)
	if err != nil {
		return err
	}

	now := s.clock.Now()
	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if in.OrderID == "" {
			return rpcerr.Invalid("ER_RECONCILE_NEEDS_ORDER",
				"reconciling names the order that was written")
		}
		settled, err := s.visits.ReconcileEvent(ctx, scope, in.EventID, in.OrderID)
		if err != nil {
			return err
		}
		if !settled {
			// Already reconciled, or never owed anything. Both are refusals
			// rather than silent successes: a caller told "done" for an order
			// that was not recorded would never write the real one.
			return rpcerr.FailedPrecondition("ER_NOTHING_TO_RECONCILE",
				"this administration owes no order, or somebody reconciled it first")
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermEmergencyWrite,
			ResourceType: "emergency_event", ResourceID: in.EventID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "protocol administration reconciled to order " + in.OrderID,
		}, now)
	})
}

// Outstanding is the department's reconciliation debt (SRS-ER-009).
func (s *Service) Outstanding(ctx context.Context, facilityID string, pageSize int32) (
	domain.Timeline, error) {

	_, scope, err := s.authorize(ctx, PermEmergencyRead)
	if err != nil {
		return nil, err
	}
	return s.visits.Unreconciled(ctx, scope, facilityID, clampPageSize(pageSize))
}
