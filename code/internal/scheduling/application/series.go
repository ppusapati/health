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

// Recurring series and the waitlist (SRS-SCH-013, SRS-SCH-006).

// BookSeriesInput books a recurring course (SRS-SCH-013).
type BookSeriesInput struct {
	PatientID    string
	ResourceID   string
	StartsAt     time.Time
	VisitType    domain.VisitType
	IntervalDays int
	Occurrences  int
	Reason       string
}

// BookSeriesResult carries the course and what could be booked.
type BookSeriesResult struct {
	Series domain.Series
	Booked []*domain.Appointment
	// Unavailable lists the occurrences whose slot was gone. Reported rather
	// than refused: a twelve-week course where week seven is full is eleven
	// appointments the patient should keep, and a clinic that refused the whole
	// course would make staff book them one at a time instead.
	Unavailable []time.Time
}

// BookSeries books a recurring course of appointments.
//
// Partial success is the design. Refusing the whole course because one week is
// full would mean a physiotherapy referral fails on a single busy Tuesday, and
// the workaround — booking twelve appointments by hand — is where the mistakes
// come from.
func (s *Service) BookSeries(ctx context.Context, in BookSeriesInput) (BookSeriesResult, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return BookSeriesResult{}, rpcerr.Unauthenticated("AUTH_NO_SESSION",
			"authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermAppointmentBook,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermAppointmentBook, "series", in.PatientID, decision.Reason)
		return BookSeriesResult{}, rpcerr.PermissionDenied("SCH_BOOK_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	var result BookSeriesResult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		resource, err := s.resources.Get(ctx, scope, in.ResourceID)
		if err != nil {
			return err
		}
		if !resource.Bookable() {
			return scheduleError(domain.ErrNotBookable{
				Kind: "resource", ID: resource.ID, Why: "the resource is not active",
			})
		}

		accepts, err := s.patients.AcceptsRoutineScheduling(ctx, scope, in.PatientID)
		if err != nil {
			return err
		}
		if !accepts {
			return rpcerr.FailedPrecondition("SCH_PATIENT_NOT_SCHEDULABLE",
				"this patient's record does not accept routine appointments")
		}

		course, err := domain.NewSeries(s.ids.NewID(), scope.TenantID(), in.PatientID,
			resource.ID, in.VisitType, in.IntervalDays, in.Occurrences,
			in.StartsAt, session.SubjectID, now)
		if err != nil {
			return scheduleError(err)
		}
		if err := s.series.Insert(ctx, scope, course); err != nil {
			return err
		}

		location, err := time.LoadLocation(resource.TimeZone)
		if err != nil {
			return rpcerr.Internal("SCH_TIMEZONE_INVALID",
				"the resource has an unloadable time zone")
		}

		for i, at := range course.OccurrenceTimes(location) {
			slot, err := s.resolveSlot(ctx, scope, BookAppointmentInput{
				ResourceID: resource.ID, StartsAt: at, VisitType: in.VisitType,
			}, now)
			if err != nil {
				// No slot in the roster, or it is blocked. The rest of the
				// course still stands.
				result.Unavailable = append(result.Unavailable, at)
				continue
			}

			slotID, err := s.slots.ClaimCapacity(ctx, scope, slot, s.ids.NewID(), now)
			if errors.Is(err, ports.ErrSlotFull) {
				result.Unavailable = append(result.Unavailable, at)
				continue
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
			appointment.SeriesID = course.ID
			appointment.Occurrence = i + 1

			if err := s.appointments.Insert(ctx, scope, appointment); err != nil {
				return err
			}
			if err := s.emitAppointmentEvent(ctx, session, EventAppointmentBooked,
				appointment, now, map[string]any{
					"series_id": course.ID, "occurrence": i + 1,
				}); err != nil {
				return err
			}
			result.Booked = append(result.Booked, appointment)
		}

		if len(result.Booked) == 0 {
			// Nothing could be booked at all. Rolling back is right: a series
			// row with no appointments is a course nobody is on, and leaving it
			// would put an empty course in front of staff to clean up.
			return rpcerr.FailedPrecondition("SCH_SERIES_UNAVAILABLE",
				"no occurrence of this course could be booked")
		}

		payload, err := json.Marshal(map[string]any{
			"series_id": course.ID, "patient_id": course.PatientID,
			"resource_id": course.ResourceID, "booked": len(result.Booked),
			"requested": course.Occurrences,
		})
		if err != nil {
			return rpcerr.Internal("SCH_EVENT_ENCODE_FAILED", "could not encode event").WithCause(err)
		}
		if err := s.appendEvent(ctx, session, EventAppointmentSeriesCreated,
			course.ID, payload, now); err != nil {
			return err
		}

		result.Series = course
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermAppointmentBook,
			ResourceType: "series", ResourceID: course.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "course booked",
		}, now)
	})
	if err != nil {
		return BookSeriesResult{}, mapConflict(err)
	}
	return result, nil
}

// CancelSeriesInput abandons a course, in whole or from a point.
type CancelSeriesInput struct {
	SeriesID string
	// FromAppointmentID names the occurrence a future-occurrences change pivots
	// on. Empty with ScopeFutureOccurrences means every remaining occurrence.
	FromAppointmentID string
	Scope             domain.SeriesScope
	Reason            string
}

// CancelSeriesResult reports what was cancelled.
type CancelSeriesResult struct {
	Cancelled []string
}

// CancelSeries cancels one occurrence or every future one (SRS-SCH-013).
//
// Past occurrences are never touched by either scope. A course stopped after
// four sessions is four sessions of treatment, and a bulk cancellation that
// rewrote them would be rewriting the record of care that was given.
func (s *Service) CancelSeries(ctx context.Context, in CancelSeriesInput) (
	CancelSeriesResult, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return CancelSeriesResult{}, rpcerr.Unauthenticated("AUTH_NO_SESSION",
			"authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermAppointmentBook,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermAppointmentBook, "series", in.SeriesID, decision.Reason)
		return CancelSeriesResult{}, rpcerr.PermissionDenied("SCH_CANCEL_DENIED", decision.Reason)
	}

	if err := domain.ValidateScope(in.Scope); err != nil {
		return CancelSeriesResult{}, scheduleError(err)
	}
	if in.Reason == "" {
		return CancelSeriesResult{}, rpcerr.Invalid("SCH_REASON_REQUIRED",
			"cancelling needs a reason")
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	var result CancelSeriesResult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		occurrences, err := s.series.Appointments(ctx, scope, in.SeriesID)
		if err != nil {
			return err
		}
		if len(occurrences) == 0 {
			return rpcerr.NotFound("SCH_SERIES_NOT_FOUND", "no such course")
		}

		pivot := occurrences[0]
		if in.FromAppointmentID != "" {
			var found bool
			for _, o := range occurrences {
				if o.ID() == in.FromAppointmentID {
					pivot, found = o, true
					break
				}
			}
			if !found {
				return rpcerr.NotFound("SCH_OCCURRENCE_NOT_FOUND",
					"that occurrence is not part of this course")
			}
		}

		facilityPolicy, err := s.policies.Resolve(ctx, scope, pivot.FacilityID)
		if err != nil {
			return err
		}

		for _, occurrence := range occurrences {
			if !occurrence.AffectedBy(in.Scope, pivot, now) {
				continue
			}

			before := occurrence.Version
			outcome, err := occurrence.Cancel(facilityPolicy.Cancellation, session.SubjectID,
				in.Reason, now)
			if err != nil {
				return scheduleError(err)
			}
			change := occurrence.History[len(occurrence.History)-1]
			if err := s.appointments.SetStatus(ctx, scope, occurrence, change, before); err != nil {
				return err
			}
			if err := s.slots.ReleaseCapacity(ctx, scope, occurrence.SlotID, now); err != nil {
				return err
			}
			if err := s.policies.RecordOutcome(ctx, scope, occurrence.ID(), "cancellation",
				outcome, session.SubjectID, in.Reason, now); err != nil {
				return err
			}
			if err := s.emitAppointmentEvent(ctx, session, EventAppointmentCancelled,
				occurrence, now, map[string]any{
					"series_id": in.SeriesID, "timely": outcome.Timely,
				}); err != nil {
				return err
			}
			result.Cancelled = append(result.Cancelled, occurrence.ID())
		}

		if in.Scope == domain.ScopeFutureOccurrences && in.FromAppointmentID == "" {
			// The whole remaining course is off. Marking the series itself
			// stops it being extended later.
			if err := s.series.Cancel(ctx, scope, in.SeriesID); err != nil {
				return err
			}
		}

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermAppointmentBook,
			ResourceType: "series", ResourceID: in.SeriesID,
			Outcome: audit.OutcomeSuccess,
			Reason:  string(in.Scope) + ": " + in.Reason,
		}, now)
	})
	if err != nil {
		return CancelSeriesResult{}, mapConflict(err)
	}
	return result, nil
}

// JoinWaitlistInput adds a patient to the list for an earlier slot.
type JoinWaitlistInput struct {
	PatientID     string
	ResourceID    string
	FacilityID    string
	OrgUnitID     string
	VisitType     domain.VisitType
	NotBefore     time.Time
	NotAfter      time.Time
	AppointmentID string
}

// JoinWaitlist adds a patient to the waitlist (SRS-SCH-006).
func (s *Service) JoinWaitlist(ctx context.Context, in JoinWaitlistInput) (
	domain.WaitlistEntry, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.WaitlistEntry{}, rpcerr.Unauthenticated("AUTH_NO_SESSION",
			"authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermAppointmentBook,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermAppointmentBook, "waitlist", in.PatientID, decision.Reason)
		return domain.WaitlistEntry{}, rpcerr.PermissionDenied("SCH_WAITLIST_DENIED",
			decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	var created domain.WaitlistEntry
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		entry, err := domain.NewWaitlistEntry(s.ids.NewID(), scope.TenantID(), in.PatientID,
			in.ResourceID, in.FacilityID, in.OrgUnitID, in.VisitType,
			in.NotBefore, in.NotAfter, in.AppointmentID, session.SubjectID, now)
		if err != nil {
			return scheduleError(err)
		}
		if err := s.waitlist.Insert(ctx, scope, entry); err != nil {
			return err
		}

		created = entry
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermAppointmentBook,
			ResourceType: "waitlist", ResourceID: entry.ID,
			Outcome: audit.OutcomeSuccess, Reason: "joined the waitlist",
		}, now)
	})
	if err != nil {
		return domain.WaitlistEntry{}, mapConflict(err)
	}
	return created, nil
}

// OfferWaitlistSlotInput offers a freed slot to somebody waiting.
type OfferWaitlistSlotInput struct {
	WaitlistID string
	ResourceID string
	StartsAt   time.Time
	VisitType  domain.VisitType
	// ValidFor is how long the offer stands. Zero takes the default.
	ValidFor time.Duration
}

// OfferWaitlistSlot holds a slot for a waiting patient until the offer expires
// (SRS-SCH-006).
//
// The slot is deliberately NOT claimed. An offer is a promise, and a promise
// that consumed capacity would leave the clinic holding a slot for somebody who
// has stopped reading their messages — capacity nobody can use and nobody can
// see is gone. The claim happens when the patient accepts, through the ordinary
// atomic path, which is also what stops two accepted offers producing two
// bookings for one slot.
func (s *Service) OfferWaitlistSlot(ctx context.Context, in OfferWaitlistSlotInput) (
	domain.WaitlistEntry, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.WaitlistEntry{}, rpcerr.Unauthenticated("AUTH_NO_SESSION",
			"authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermAppointmentBook,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermAppointmentBook, "waitlist", in.WaitlistID, decision.Reason)
		return domain.WaitlistEntry{}, rpcerr.PermissionDenied("SCH_WAITLIST_DENIED",
			decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	var offered domain.WaitlistEntry
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		entry, err := s.waitlist.Get(ctx, scope, in.WaitlistID)
		if err != nil {
			return err
		}

		slot, err := s.resolveSlot(ctx, scope, BookAppointmentInput{
			ResourceID: in.ResourceID, StartsAt: in.StartsAt, VisitType: in.VisitType,
		}, now)
		if err != nil {
			return err
		}

		// What the patient already holds, so an offer is never a downgrade.
		var currentAt time.Time
		if entry.AppointmentID != "" {
			current, err := s.appointments.Get(ctx, scope, entry.AppointmentID)
			if err != nil {
				return err
			}
			currentAt = current.StartsAt
		}
		if !entry.Accepts(slot, currentAt) {
			return rpcerr.FailedPrecondition("SCH_OFFER_NOT_SUITABLE",
				"that slot is not one this patient is waiting for")
		}

		expected := entry.Status
		if err := entry.Offer(slot, in.ValidFor, now); err != nil {
			return scheduleError(err)
		}
		if err := s.waitlist.Update(ctx, scope, entry, expected); err != nil {
			return err
		}

		payload, err := json.Marshal(map[string]any{
			"waitlist_id": entry.ID, "patient_id": entry.PatientID,
			"slot_at":    entry.OfferedSlotAt.Format(time.RFC3339),
			"expires_at": entry.OfferExpiresAt.Format(time.RFC3339),
		})
		if err != nil {
			return rpcerr.Internal("SCH_EVENT_ENCODE_FAILED", "could not encode event").WithCause(err)
		}
		if err := s.appendEvent(ctx, session, EventWaitlistOffered, entry.ID, payload, now); err != nil {
			return err
		}

		if err := s.notifyWaitlistOffer(ctx, session, entry, now); err != nil {
			return err
		}

		offered = entry
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermAppointmentBook,
			ResourceType: "waitlist", ResourceID: entry.ID,
			Outcome: audit.OutcomeSuccess, Reason: "slot offered",
		}, now)
	})
	if err != nil {
		return domain.WaitlistEntry{}, mapConflict(err)
	}
	return offered, nil
}

// AcceptWaitlistOfferResult carries the booking the acceptance produced.
type AcceptWaitlistOfferResult struct {
	Entry       domain.WaitlistEntry
	Appointment *domain.Appointment
	// ReplacedID is the appointment the patient gave up, if any.
	ReplacedID string
}

// AcceptWaitlistOffer converts a live offer into a booking (SRS-SCH-006).
//
// When the patient already holds an appointment this is a reschedule of it, not
// a second booking — which is the "cannot create duplicate confirmed bookings"
// half of the acceptance criterion. The slot is claimed through the ordinary
// atomic path, so an offer made to two patients by mistake still produces one
// booking.
func (s *Service) AcceptWaitlistOffer(ctx context.Context, waitlistID string) (
	AcceptWaitlistOfferResult, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return AcceptWaitlistOfferResult{}, rpcerr.Unauthenticated("AUTH_NO_SESSION",
			"authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermAppointmentBook,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermAppointmentBook, "waitlist", waitlistID, decision.Reason)
		return AcceptWaitlistOfferResult{}, rpcerr.PermissionDenied("SCH_WAITLIST_DENIED",
			decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	var result AcceptWaitlistOfferResult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		entry, err := s.waitlist.Get(ctx, scope, waitlistID)
		if err != nil {
			return err
		}
		offeredAt := entry.OfferedSlotAt

		expected := entry.Status
		if err := entry.Accept(now); err != nil {
			return rpcerr.FailedPrecondition("SCH_OFFER_NOT_LIVE", err.Error())
		}
		if err := s.waitlist.Update(ctx, scope, entry, expected); err != nil {
			return err
		}

		slot, err := s.resolveSlot(ctx, scope, BookAppointmentInput{
			ResourceID: entry.ResourceID, StartsAt: offeredAt, VisitType: entry.VisitType,
		}, now)
		if err != nil {
			return err
		}
		slotID, err := s.slots.ClaimCapacity(ctx, scope, slot, s.ids.NewID(), now)
		if errors.Is(err, ports.ErrSlotFull) {
			// The offer went stale: somebody else took the slot. Refusing here
			// rather than double-booking is the whole point of claiming through
			// the ordinary path.
			return rpcerr.FailedPrecondition("SCH_SLOT_FULL",
				"that slot was taken before the offer was accepted")
		}
		if err != nil {
			return err
		}

		booked, err := domain.NewAppointment(s.ids.NewID(), scope.TenantID(),
			entry.PatientID, slot, session.SubjectID, "from the waitlist", now)
		if err != nil {
			return scheduleError(err)
		}
		booked.SlotID = slotID

		// The appointment the patient gave up. Cancelled rather than left
		// standing: two confirmed bookings is exactly what the criterion
		// forbids.
		if entry.AppointmentID != "" {
			previous, err := s.appointments.Get(ctx, scope, entry.AppointmentID)
			if err != nil {
				return err
			}
			if previous.Status != domain.StatusCancelled {
				before := previous.Version
				if err := previous.Transition(domain.StatusCancelled, session.SubjectID,
					"moved to an earlier slot from the waitlist", false, now); err != nil {
					return scheduleError(err)
				}
				change := previous.History[len(previous.History)-1]
				if err := s.appointments.SetStatus(ctx, scope, previous, change, before); err != nil {
					return err
				}
				if err := s.slots.ReleaseCapacity(ctx, scope, previous.SlotID, now); err != nil {
					return err
				}
				booked.RescheduledFromID = previous.ID()
				booked.RescheduleCount = previous.RescheduleCount + 1
				result.ReplacedID = previous.ID()
			}
		}

		if err := s.appointments.Insert(ctx, scope, booked); err != nil {
			return err
		}
		if err := s.emitAppointmentEvent(ctx, session, EventAppointmentBooked,
			booked, now, map[string]any{"from_waitlist": true}); err != nil {
			return err
		}

		result.Entry, result.Appointment = entry, booked
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermAppointmentBook,
			ResourceType: "waitlist", ResourceID: entry.ID,
			Outcome: audit.OutcomeSuccess, Reason: "offer accepted",
		}, now)
	})
	if err != nil {
		return AcceptWaitlistOfferResult{}, mapConflict(err)
	}
	return result, nil
}

// DeclineWaitlistOffer returns a patient to the list.
func (s *Service) DeclineWaitlistOffer(ctx context.Context, waitlistID string) (
	domain.WaitlistEntry, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return domain.WaitlistEntry{}, rpcerr.Unauthenticated("AUTH_NO_SESSION",
			"authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermAppointmentBook,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermAppointmentBook, "waitlist", waitlistID, decision.Reason)
		return domain.WaitlistEntry{}, rpcerr.PermissionDenied("SCH_WAITLIST_DENIED",
			decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	var declined domain.WaitlistEntry
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		entry, err := s.waitlist.Get(ctx, scope, waitlistID)
		if err != nil {
			return err
		}
		expected := entry.Status
		if err := entry.Decline(now); err != nil {
			return scheduleError(err)
		}
		if err := s.waitlist.Update(ctx, scope, entry, expected); err != nil {
			return err
		}
		declined = entry
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermAppointmentBook,
			ResourceType: "waitlist", ResourceID: entry.ID,
			Outcome: audit.OutcomeSuccess, Reason: "offer declined",
		}, now)
	})
	if err != nil {
		return domain.WaitlistEntry{}, mapConflict(err)
	}
	return declined, nil
}

// ExpireWaitlistOffers returns unanswered offers to the waiting list.
//
// Driven by a caller rather than a timer inside this service: a background loop
// here would run once per replica and each would do the same work. The sweep is
// idempotent, so running it twice is harmless.
func (s *Service) ExpireWaitlistOffers(ctx context.Context) (int64, error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return 0, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermAppointmentBook,
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermAppointmentBook, "waitlist", "", decision.Reason)
		return 0, rpcerr.PermissionDenied("SCH_WAITLIST_DENIED", decision.Reason)
	}

	scope := session.TenantScope()
	now := s.clock.Now()

	var expired int64
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		expired, err = s.waitlist.ExpireStale(ctx, scope, now)
		return err
	})
	return expired, err
}

// ListWaitlist returns the list a scheduler works when a slot frees up.
func (s *Service) ListWaitlist(ctx context.Context, resourceID string, pageSize int32) (
	[]domain.WaitlistEntry, error) {

	session, scope, err := s.authorizeRead(ctx, PermScheduleRead, "waitlist", resourceID)
	if err != nil {
		return nil, err
	}

	var out []domain.WaitlistEntry
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		found, err := s.waitlist.Open(ctx, scope, resourceID, clampPageSize(pageSize))
		if err != nil {
			return err
		}
		out = found
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermScheduleRead,
			ResourceType: "waitlist", ResourceID: resourceID,
			Outcome: audit.OutcomeSuccess, Reason: "waitlist",
		}, s.clock.Now())
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}
