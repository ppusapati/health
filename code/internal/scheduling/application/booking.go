package application

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/scheduling/domain"
	"github.com/ppusapati/health/code/internal/scheduling/ports"
)

// Booking (SRS-SCH-004, SRS-SCH-014, SRS-SCH-016).

// BookAppointmentInput is a request for a specific slot.
//
// The slot is named by resource, instant and visit type rather than by an
// opaque id, because slots are generated rather than stored: an id would have
// to be minted at search time and would be meaningless by the time the patient
// chose one.
type BookAppointmentInput struct {
	PatientID  string
	ResourceID string
	StartsAt   time.Time
	VisitType  domain.VisitType
	Reason     string
	// Override books into a blocked period. Requires the override permission,
	// and only works where the block said it was overridable (SRS-SCH-002).
	Override bool
}

// BookAppointment books a slot atomically (SRS-SCH-004).
//
// The whole of "prevent overbooking beyond configured capacity" lives in one
// statement inside this transaction — a guarded UPDATE that takes a row lock.
// Everything before it is a check that produces a good error message; the
// statement is what makes the guarantee true. A version that checked capacity
// and then inserted would be a race two concurrent bookings both win, and the
// way it fails is two patients in one slot, under load, not under test.
func (s *Service) BookAppointment(ctx context.Context, in BookAppointmentInput) (*domain.Appointment, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return nil, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermAppointmentBook,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermAppointmentBook, "appointment", in.PatientID, decision.Reason)
		return nil, rpcerr.PermissionDenied("SCH_BOOK_DENIED", decision.Reason)
	}

	if in.Override && !session.HasPermission(PermScheduleOverride) {
		return nil, rpcerr.PermissionDenied("SCH_OVERRIDE_DENIED",
			"booking into a blocked period needs the override permission")
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	var booked *domain.Appointment
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		slot, err := s.resolveSlot(ctx, scope, in, now)
		if err != nil {
			return err
		}

		// SRS-EMPI-008's other half. The identity context says whether the
		// patient is fit for a routine appointment; scheduling decides what to
		// do about it, and blocking is the decision for a routine booking.
		accepts, err := s.patients.AcceptsRoutineScheduling(ctx, scope, in.PatientID)
		if err != nil {
			return err
		}
		if !accepts {
			return rpcerr.FailedPrecondition("SCH_PATIENT_NOT_SCHEDULABLE",
				"this patient's record does not accept routine appointments")
		}

		// The claim. Materialises the slot row if this is its first booking and
		// takes one unit, in one call, guarded on capacity.
		slotID, err := s.slots.ClaimCapacity(ctx, scope, slot, s.ids.NewID(), now)
		if errors.Is(err, ports.ErrSlotFull) {
			return rpcerr.FailedPrecondition("SCH_SLOT_FULL",
				"that slot is fully booked")
		}
		if err != nil {
			return err
		}

		appointment, err := domain.NewAppointment(s.ids.NewID(), scope.TenantID(),
			in.PatientID, slot, session.SubjectID, in.Reason, now)
		if err != nil {
			return scheduleError(err)
		}
		appointment.SlotID = slotID

		if err := s.appointments.Insert(ctx, scope, appointment); err != nil {
			return err
		}

		if err := s.emitAppointmentEvent(ctx, session, EventAppointmentBooked,
			appointment, now, nil); err != nil {
			return err
		}

		booked = appointment
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermAppointmentBook,
			ResourceType: "appointment", ResourceID: appointment.ID(),
			Outcome: audit.OutcomeSuccess,
			// The resource and the time, never the stated reason: the reason a
			// patient gives at booking is about them, and an audit trail
			// carrying it is a second copy outside the access rules on the
			// first.
			Reason: "booked with " + appointment.ResourceID,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return booked, nil
}

// resolveSlot finds the requested slot in the roster and checks it is bookable.
//
// Regenerated rather than trusted from the request: a client that could name an
// arbitrary instant and capacity would be defining its own roster, and the
// first symptom would be appointments outside clinic hours.
func (s *Service) resolveSlot(ctx context.Context, scope authctx.TenantScope,
	in BookAppointmentInput, now time.Time) (domain.Slot, error) {

	resource, err := s.resources.Get(ctx, scope, in.ResourceID)
	if err != nil {
		return domain.Slot{}, err
	}
	if !resource.Bookable() {
		return domain.Slot{}, scheduleError(domain.ErrNotBookable{
			Kind: "resource", ID: resource.ID, Why: "the resource is not active",
		})
	}

	active, err := s.calendar.Active(ctx, scope, resource.FacilityID)
	if err != nil {
		return domain.Slot{}, err
	}
	if !active {
		return domain.Slot{}, scheduleError(domain.ErrNotBookable{
			Kind: "facility", ID: resource.FacilityID, Why: "the facility is not active",
		})
	}

	// One day either side of the requested instant, so a slot near local
	// midnight is generated whichever side of the UTC date boundary it falls.
	day := in.StartsAt.UTC().Truncate(24 * time.Hour)
	from, until := day.AddDate(0, 0, -1), day.AddDate(0, 0, 2)

	schedules, err := s.schedules.SchedulesFor(ctx, scope, []string{resource.ID},
		in.VisitType, from, until)
	if err != nil {
		return domain.Slot{}, err
	}
	exceptions, err := s.schedules.ExceptionsFor(ctx, scope, []string{resource.ID}, from, until)
	if err != nil {
		return domain.Slot{}, err
	}
	closures, err := s.calendar.ClosedDates(ctx, scope, resource.FacilityID, from, until)
	if err != nil {
		return domain.Slot{}, err
	}

	generated, err := domain.GenerateSlots(resource, schedules, exceptions, closures, from, until)
	if err != nil {
		return domain.Slot{}, scheduleError(err)
	}

	for _, slot := range generated {
		if !slot.StartsAt.Equal(in.StartsAt.UTC()) || slot.VisitType != in.VisitType {
			continue
		}
		if slot.Blocked {
			if !in.Override {
				return domain.Slot{}, rpcerr.FailedPrecondition("SCH_SLOT_BLOCKED",
					"that period is blocked: "+slot.BlockedReason)
			}
			if !slot.BlockOverridable {
				// Annual leave is not a permission question: the clinician is
				// not there, and an override that could conjure them up would
				// be a permission to book a patient in to see nobody.
				return domain.Slot{}, rpcerr.FailedPrecondition("SCH_SLOT_NOT_OVERRIDABLE",
					"that period cannot be overridden: "+slot.BlockedReason)
			}
		}
		return slot, nil
	}

	// No such slot in the roster. NOT_FOUND rather than INVALID_ARGUMENT: the
	// request was well formed, and the roster simply has nothing there — which
	// is what a client sees when it holds a search result taken before a roster
	// change.
	return domain.Slot{}, rpcerr.NotFound("SCH_SLOT_NOT_FOUND",
		"the roster has no such slot; search again")
}

// emitAppointmentEvent writes one of the SRS-SCH-016 events.
//
// The payload carries identifiers and times, never the patient's stated reason
// or anything clinical. An event stream is read by more systems, by more people
// and under fewer controls than the record it describes (SRS-API-009).
func (s *Service) emitAppointmentEvent(ctx context.Context, session authctx.Session,
	eventType string, a *domain.Appointment, now time.Time, extra map[string]any) error {

	payload := map[string]any{
		"appointment_id": a.ID(),
		"patient_id":     a.PatientID,
		"resource_id":    a.ResourceID,
		"facility_id":    a.FacilityID,
		"starts_at":      a.StartsAt.Format(time.RFC3339),
		"visit_type":     string(a.VisitType),
		"status":         string(a.Status),
		"version":        a.Version,
	}
	for k, v := range extra {
		payload[k] = v
	}

	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("SCH_EVENT_ENCODE_FAILED", "could not encode event").WithCause(err)
	}
	return s.appendEvent(ctx, session, eventType, a.ID(), encoded, now)
}

// GetAppointment reads one booking with its status history.
func (s *Service) GetAppointment(ctx context.Context, appointmentID string) (*domain.Appointment, error) {
	session, scope, err := s.authorizeRead(ctx, PermScheduleRead, "appointment", appointmentID)
	if err != nil {
		return nil, err
	}

	var out *domain.Appointment
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		a, err := s.appointments.Get(ctx, scope, appointmentID)
		if err != nil {
			return err
		}
		out = a
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermScheduleRead,
			ResourceType: "appointment", ResourceID: appointmentID,
			Outcome: audit.OutcomeSuccess,
		}, s.clock.Now())
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// ListAppointmentsInput narrows a listing.
type ListAppointmentsInput struct {
	PatientID  string
	FacilityID string
	ResourceID string
	From       time.Time
	Until      time.Time
	PageSize   int32
}

// ListAppointments serves both "what has this patient got coming up" and the
// clinic list for a day.
func (s *Service) ListAppointments(ctx context.Context, in ListAppointmentsInput) (
	[]*domain.Appointment, error) {

	session, scope, err := s.authorizeRead(ctx, PermScheduleRead, "appointment", in.PatientID)
	if err != nil {
		return nil, err
	}

	if in.PatientID == "" && in.FacilityID == "" {
		return nil, rpcerr.Invalid("SCH_LIST_UNFILTERED",
			"a listing needs a patient or a facility")
	}

	limit := clampPageSize(in.PageSize)

	var out []*domain.Appointment
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		if in.PatientID != "" {
			out, err = s.appointments.ForPatient(ctx, scope, in.PatientID, limit)
		} else {
			if in.From.IsZero() || in.Until.IsZero() {
				return rpcerr.Invalid("SCH_RANGE_REQUIRED",
					"a clinic list needs a date range")
			}
			out, err = s.appointments.ForDay(ctx, scope, in.FacilityID, in.ResourceID,
				in.From, in.Until, limit)
		}
		if err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermScheduleRead,
			ResourceType: "appointment", ResourceID: in.PatientID,
			Outcome: audit.OutcomeSuccess, Reason: "listing",
		}, s.clock.Now())
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// authorizeRead is the shared preamble for the read paths.
func (s *Service) authorizeRead(ctx context.Context, permission, resourceType, resourceID string) (
	authctx.Session, authctx.TenantScope, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return authctx.Session{}, authctx.TenantScope{},
			rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: permission,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, permission, resourceType, resourceID, decision.Reason)
		return authctx.Session{}, authctx.TenantScope{},
			rpcerr.PermissionDenied("SCH_READ_DENIED", decision.Reason)
	}
	return session, session.TenantScope(), nil
}
