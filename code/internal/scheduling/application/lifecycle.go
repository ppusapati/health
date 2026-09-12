package application

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/scheduling/domain"
	"github.com/ppusapati/health/code/internal/scheduling/ports"
)

// Reschedule, cancel, series and waitlist (SRS-SCH-005, SRS-SCH-006,
// SRS-SCH-013, SRS-SCH-015).

const (
	// EventAppointmentSeriesCreated is emitted once for a whole course, so a
	// downstream projection does not see twelve unrelated bookings.
	EventAppointmentSeriesCreated = "appointment.series_created"
	// EventWaitlistOffered is emitted when an earlier slot is offered. The
	// notification service reads it (SRS-SCH-012).
	EventWaitlistOffered = "appointment.waitlist_offered"
)

// CancelAppointmentInput cancels a booking under the facility's policy.
type CancelAppointmentInput struct {
	AppointmentID string
	Reason        string
}

// CancelAppointmentResult reports what the policy made of the cancellation.
type CancelAppointmentResult struct {
	Appointment *domain.Appointment
	Outcome     domain.CancellationOutcome
}

// CancelAppointment releases the slot and records the notice given
// (SRS-SCH-005).
//
// The outcome is captured at the moment of the decision rather than computed
// when somebody disputes it, so a policy changed in March cannot retroactively
// make a February cancellation late. This system never charges anybody: it
// records whether the notice period was met and leaves the fee to SRS-BIL.
func (s *Service) CancelAppointment(ctx context.Context, in CancelAppointmentInput) (
	CancelAppointmentResult, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return CancelAppointmentResult{}, rpcerr.Unauthenticated("AUTH_NO_SESSION",
			"authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermAppointmentBook,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermAppointmentBook, "appointment",
			in.AppointmentID, decision.Reason)
		return CancelAppointmentResult{}, rpcerr.PermissionDenied("SCH_CANCEL_DENIED",
			decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	var result CancelAppointmentResult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		appointment, err := s.appointments.Get(ctx, scope, in.AppointmentID)
		if err != nil {
			return err
		}

		cancellationPolicy, _, err := s.policies.Resolve(ctx, scope, appointment.FacilityID)
		if err != nil {
			return err
		}

		before := appointment.Version
		outcome, err := appointment.Cancel(cancellationPolicy, session.SubjectID, in.Reason, now)
		if err != nil {
			return scheduleError(err)
		}

		change := appointment.History[len(appointment.History)-1]
		if err := s.appointments.SetStatus(ctx, scope, appointment, change, before); err != nil {
			return err
		}

		// The slot goes back. A cancelled appointment that kept its capacity
		// would leave a morning of phantom bookings nobody can fill.
		if err := s.slots.ReleaseCapacity(ctx, scope, appointment.SlotID, now); err != nil {
			return err
		}

		if err := s.policies.RecordOutcome(ctx, scope, appointment.ID(), "cancellation",
			outcome, session.SubjectID, in.Reason, now); err != nil {
			return err
		}

		if err := s.emitAppointmentEvent(ctx, session, EventAppointmentCancelled,
			appointment, now, map[string]any{
				// Whether the notice was met, never what it costs: pricing is
				// SRS-BIL's, and an event carrying a fee would be this context
				// making a claim it cannot support.
				"timely":     outcome.Timely,
				"chargeable": outcome.Chargeable,
			}); err != nil {
			return err
		}

		result = CancelAppointmentResult{Appointment: appointment, Outcome: outcome}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermAppointmentBook,
			ResourceType: "appointment", ResourceID: appointment.ID(),
			Outcome: audit.OutcomeSuccess,
			Reason:  "cancelled: " + in.Reason,
		}, now)
	})
	if err != nil {
		return CancelAppointmentResult{}, mapConflict(err)
	}
	return result, nil
}

// RescheduleAppointmentInput moves a booking to a new slot.
type RescheduleAppointmentInput struct {
	AppointmentID string
	ResourceID    string
	StartsAt      time.Time
	VisitType     domain.VisitType
	Reason        string
	Override      bool
}

// RescheduleAppointmentResult carries the new booking and the old one.
type RescheduleAppointmentResult struct {
	Appointment *domain.Appointment
	// PreviousID is the booking this replaced. SRS-SCH-005 requires the
	// original to retain its status history, so it is cancelled rather than
	// edited, and the chain is what ties them together.
	PreviousID string
	Outcome    domain.CancellationOutcome
}

// RescheduleAppointment moves a booking (SRS-SCH-005).
//
// A new appointment chained to the old one rather than an edit in place. The
// original must retain its status history — a patient disputing an attendance
// record needs to see that the 9th was moved rather than that it silently
// became the 16th — and the new slot has to be claimed atomically like any
// other booking.
func (s *Service) RescheduleAppointment(ctx context.Context, in RescheduleAppointmentInput) (
	RescheduleAppointmentResult, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return RescheduleAppointmentResult{}, rpcerr.Unauthenticated("AUTH_NO_SESSION",
			"authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermAppointmentBook,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermAppointmentBook, "appointment",
			in.AppointmentID, decision.Reason)
		return RescheduleAppointmentResult{}, rpcerr.PermissionDenied("SCH_RESCHEDULE_DENIED",
			decision.Reason)
	}
	if in.Override && !session.HasPermission(PermScheduleOverride) {
		return RescheduleAppointmentResult{}, rpcerr.PermissionDenied("SCH_OVERRIDE_DENIED",
			"booking into a blocked period needs the override permission")
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	var result RescheduleAppointmentResult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		original, err := s.appointments.Get(ctx, scope, in.AppointmentID)
		if err != nil {
			return err
		}
		if original.Status.Terminal() {
			return scheduleError(domain.ErrInvalidTransition{
				From: original.Status, To: domain.StatusScheduled,
			})
		}

		cancellationPolicy, _, err := s.policies.Resolve(ctx, scope, original.FacilityID)
		if err != nil {
			return err
		}
		if cancellationPolicy.MaxReschedules > 0 &&
			original.RescheduleCount >= cancellationPolicy.MaxReschedules {
			// A booking moved eleven times is a patient who is not coming, and
			// each move cost a slot somebody else could have used.
			return rpcerr.FailedPrecondition("SCH_RESCHEDULE_LIMIT",
				"this appointment has been moved as many times as the policy allows")
		}

		outcome := cancellationPolicy.AssessReschedule(original.StartsAt, now)

		// The new slot first. If it cannot be claimed, the patient keeps the
		// appointment they had — which is far better than losing it to a move
		// that then failed.
		slot, err := s.resolveSlot(ctx, scope, BookAppointmentInput{
			ResourceID: in.ResourceID, StartsAt: in.StartsAt,
			VisitType: in.VisitType, Override: in.Override,
		}, now)
		if err != nil {
			return err
		}
		slotID, err := s.slots.ClaimCapacity(ctx, scope, slot, s.ids.NewID(), now)
		if errors.Is(err, ports.ErrSlotFull) {
			return rpcerr.FailedPrecondition("SCH_SLOT_FULL", "that slot is fully booked")
		}
		if err != nil {
			return err
		}

		moved, err := domain.NewAppointment(s.ids.NewID(), scope.TenantID(),
			original.PatientID, slot, session.SubjectID, original.Reason, now)
		if err != nil {
			return scheduleError(err)
		}
		moved.SlotID = slotID
		moved.RescheduledFromID = original.ID()
		moved.RescheduleCount = original.RescheduleCount + 1
		moved.SeriesID, moved.Occurrence = original.SeriesID, original.Occurrence
		moved.JoinURL = original.JoinURL

		if err := s.appointments.Insert(ctx, scope, moved); err != nil {
			return err
		}

		// Now retire the original. Cancelled rather than deleted: SRS-SCH-005
		// requires the original to retain its status history.
		before := original.Version
		if err := original.Transition(domain.StatusCancelled, session.SubjectID,
			"rescheduled to "+moved.StartsAt.Format(time.RFC3339), false, now); err != nil {
			return scheduleError(err)
		}
		change := original.History[len(original.History)-1]
		if err := s.appointments.SetStatus(ctx, scope, original, change, before); err != nil {
			return err
		}
		if err := s.slots.ReleaseCapacity(ctx, scope, original.SlotID, now); err != nil {
			return err
		}

		if err := s.policies.RecordOutcome(ctx, scope, original.ID(), "reschedule",
			outcome, session.SubjectID, in.Reason, now); err != nil {
			return err
		}

		if err := s.emitAppointmentEvent(ctx, session, EventAppointmentRescheduled,
			moved, now, map[string]any{
				"rescheduled_from_id": original.ID(),
				"timely":              outcome.Timely,
			}); err != nil {
			return err
		}

		result = RescheduleAppointmentResult{
			Appointment: moved, PreviousID: original.ID(), Outcome: outcome,
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermAppointmentBook,
			ResourceType: "appointment", ResourceID: moved.ID(),
			Outcome: audit.OutcomeSuccess,
			Reason:  "rescheduled from " + original.ID(),
		}, now)
	})
	if err != nil {
		return RescheduleAppointmentResult{}, mapConflict(err)
	}
	return result, nil
}

// SetSchedulingPolicyInput configures cancellation and teleconsult rules.
type SetSchedulingPolicyInput struct {
	FacilityID   string
	Cancellation domain.CancellationPolicy
	Teleconsult  domain.TeleconsultPolicy
}

// SetSchedulingPolicy configures the rules in force (SRS-SCH-005, SRS-SCH-015).
func (s *Service) SetSchedulingPolicy(ctx context.Context, in SetSchedulingPolicyInput) error {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermScheduleConfigure,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermScheduleConfigure, "policy", in.FacilityID, decision.Reason)
		return rpcerr.PermissionDenied("SCH_CONFIGURE_DENIED", decision.Reason)
	}

	if err := in.Cancellation.Validate(); err != nil {
		return scheduleError(err)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.policies.Set(ctx, scope, in.FacilityID,
			in.Cancellation, in.Teleconsult, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermScheduleConfigure,
			ResourceType: "policy", ResourceID: in.FacilityID,
			Outcome: audit.OutcomeSuccess, Reason: "scheduling policy set",
		}, now)
	})
}
