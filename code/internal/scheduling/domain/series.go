package domain

import (
	"fmt"
	"strings"
	"time"
)

// Recurring appointments and therapy series (SRS-SCH-013).
//
// The acceptance criterion is the whole design: "series changes can affect one
// occurrence or future occurrences". A physiotherapy course is twelve
// appointments; the patient asks to move next Tuesday, or asks to move every
// remaining Tuesday, and those are different requests. A model that could only
// do one of them forces staff to do the other by hand, twelve times, and the
// eleventh is the one they get wrong.
//
// Past occurrences are never touched by either. They happened.

// SeriesScope says how far a change to a series reaches.
type SeriesScope string

const (
	// ScopeThisOccurrence changes one appointment and leaves the series alone.
	ScopeThisOccurrence SeriesScope = "this_occurrence"
	// ScopeFutureOccurrences changes this one and every later one. Never
	// earlier ones: a course half completed is half a fact.
	ScopeFutureOccurrences SeriesScope = "future_occurrences"
)

var knownSeriesScopes = map[SeriesScope]bool{
	ScopeThisOccurrence: true, ScopeFutureOccurrences: true,
}

// MaxSeriesOccurrences bounds a series.
//
// Fifty-two is a weekly appointment for a year. Longer than that is a standing
// arrangement rather than a course, and generating it in one transaction would
// lock a year of a clinician's diary against every other booking.
const MaxSeriesOccurrences = 52

// Series is a recurring course of appointments.
type Series struct {
	ID         string
	TenantID   string
	PatientID  string
	ResourceID string
	VisitType  VisitType
	// IntervalDays between occurrences. Seven for a weekly course, which is
	// most of them.
	IntervalDays int
	Occurrences  int
	// StartsAt is the first occurrence's instant.
	StartsAt  time.Time
	CreatedBy string
	CreatedAt time.Time
	// Cancelled marks a series abandoned part-way. The appointments already
	// attended stay: a course stopped after four sessions is four sessions of
	// treatment, not none.
	Cancelled bool
}

// NewSeries validates and constructs a recurring course.
func NewSeries(id, tenantID, patientID, resourceID string, visitType VisitType,
	intervalDays, occurrences int, startsAt time.Time, createdBy string,
	now time.Time) (Series, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Series{}, fmt.Errorf("%w: series id is required", ErrInvalidAppointment)
	case strings.TrimSpace(patientID) == "":
		return Series{}, fmt.Errorf("%w: a series needs a patient", ErrInvalidAppointment)
	case intervalDays < 1 || intervalDays > 90:
		// Daily at the shortest; anything beyond a quarter between sessions is
		// not a course, it is two separate referrals.
		return Series{}, fmt.Errorf("%w: an interval of %d days is not a course",
			ErrInvalidAppointment, intervalDays)
	case occurrences < 2:
		// One appointment is not a series, and creating a series for it would
		// put a patient's single visit behind a bulk-edit screen.
		return Series{}, fmt.Errorf("%w: a series needs at least two occurrences",
			ErrInvalidAppointment)
	case occurrences > MaxSeriesOccurrences:
		return Series{}, fmt.Errorf("%w: a series may have at most %d occurrences",
			ErrInvalidAppointment, MaxSeriesOccurrences)
	case startsAt.IsZero():
		return Series{}, fmt.Errorf("%w: a series needs a start", ErrInvalidAppointment)
	case strings.TrimSpace(createdBy) == "":
		return Series{}, fmt.Errorf("%w: a series must record who created it",
			ErrInvalidAppointment)
	}

	return Series{
		ID: id, TenantID: tenantID, PatientID: patientID, ResourceID: resourceID,
		VisitType: visitType, IntervalDays: intervalDays, Occurrences: occurrences,
		StartsAt: startsAt.UTC(), CreatedBy: createdBy, CreatedAt: now.UTC(),
	}, nil
}

// OccurrenceTimes returns the instants a series falls on.
//
// Computed by adding days to the first occurrence rather than by adding a
// duration, so a course crossing a daylight-saving boundary stays at the same
// local time. A patient told "every Tuesday at ten" does not expect the eighth
// session at nine.
func (s Series) OccurrenceTimes(location *time.Location) []time.Time {
	local := s.StartsAt.In(location)
	out := make([]time.Time, 0, s.Occurrences)
	for i := 0; i < s.Occurrences; i++ {
		out = append(out, local.AddDate(0, 0, i*s.IntervalDays).UTC())
	}
	return out
}

// ValidateScope rejects an unknown change scope.
func ValidateScope(scope SeriesScope) error {
	if !knownSeriesScopes[scope] {
		return fmt.Errorf("%w: unknown series scope %q", ErrInvalidAppointment, scope)
	}
	return nil
}

// AffectedBy reports whether an occurrence is inside the scope of a change.
//
// Past occurrences are never affected by either scope. They happened, and a
// "move all future sessions" that rewrote last week's attendance would be
// rewriting the record of treatment that was given.
func (a *Appointment) AffectedBy(scope SeriesScope, pivot *Appointment, now time.Time) bool {
	if a.SeriesID == "" || a.SeriesID != pivot.SeriesID {
		return false
	}
	if !a.StartsAt.After(now) {
		return false
	}
	if a.Status.Terminal() {
		// A cancelled or completed occurrence is settled. Sweeping it up in a
		// bulk change would resurrect something somebody decided about.
		return false
	}

	switch scope {
	case ScopeThisOccurrence:
		return a.id == pivot.id
	case ScopeFutureOccurrences:
		return !a.StartsAt.Before(pivot.StartsAt)
	default:
		return false
	}
}

// Waitlist (SRS-SCH-006).
//
// The acceptance criterion names the failure precisely: "offer has expiry and
// cannot create duplicate confirmed bookings". Both halves are about the same
// thing — an offer is a promise of capacity, and capacity promised to somebody
// who has stopped reading their messages is capacity nobody can use.
//
// So an offer holds a slot for a stated period and then stops. It does not
// consume the slot: a held slot that a system forgot to release is worse than
// one offered twice, because the second is visible and the first is not.

// WaitlistStatus is where an entry sits.
type WaitlistStatus string

const (
	WaitlistWaiting WaitlistStatus = "waiting"
	// WaitlistOffered has been shown an earlier slot and has not answered.
	WaitlistOffered  WaitlistStatus = "offered"
	WaitlistAccepted WaitlistStatus = "accepted"
	WaitlistDeclined WaitlistStatus = "declined"
	// WaitlistExpired was offered a slot and did not answer in time.
	WaitlistExpired   WaitlistStatus = "expired"
	WaitlistWithdrawn WaitlistStatus = "withdrawn"
)

// DefaultOfferValidity is how long an unanswered offer stands.
//
// Two hours: long enough for somebody to see a message and reply, short enough
// that a slot tomorrow morning is not held all night for somebody asleep.
const DefaultOfferValidity = 2 * time.Hour

// WaitlistEntry is a patient waiting for an earlier slot.
type WaitlistEntry struct {
	ID         string
	TenantID   string
	PatientID  string
	ResourceID string
	FacilityID string
	OrgUnitID  string
	VisitType  VisitType
	// NotBefore and NotAfter bound what the patient will accept. A patient who
	// cannot come before Thursday should not be offered Wednesday.
	NotBefore time.Time
	NotAfter  time.Time
	// AppointmentID is the booking this patient already holds, if any. An
	// earlier slot accepted becomes a reschedule of it rather than a second
	// booking — which is the "cannot create duplicate confirmed bookings" half
	// of the criterion.
	AppointmentID string
	Status        WaitlistStatus

	// OfferedSlotAt and OfferExpiresAt describe the live offer.
	OfferedSlotAt  time.Time
	OfferExpiresAt time.Time

	CreatedBy string
	CreatedAt time.Time
	UpdatedAt time.Time
}

// NewWaitlistEntry validates and constructs a waitlist entry.
func NewWaitlistEntry(id, tenantID, patientID, resourceID, facilityID, orgUnitID string,
	visitType VisitType, notBefore, notAfter time.Time, appointmentID, createdBy string,
	now time.Time) (WaitlistEntry, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return WaitlistEntry{}, fmt.Errorf("%w: waitlist id is required", ErrInvalidAppointment)
	case strings.TrimSpace(patientID) == "":
		return WaitlistEntry{}, fmt.Errorf("%w: a waitlist entry needs a patient",
			ErrInvalidAppointment)
	case resourceID == "" && orgUnitID == "" && facilityID == "":
		// Waiting for nothing in particular produces an offer for anything at
		// all, which is not a service to the patient.
		return WaitlistEntry{}, fmt.Errorf("%w: a waitlist entry needs a resource, "+
			"department or facility to wait for", ErrInvalidAppointment)
	case !notAfter.IsZero() && !notBefore.IsZero() && !notAfter.After(notBefore):
		return WaitlistEntry{}, fmt.Errorf("%w: the acceptable window ends before it starts",
			ErrInvalidAppointment)
	case strings.TrimSpace(createdBy) == "":
		return WaitlistEntry{}, fmt.Errorf("%w: a waitlist entry must record who added it",
			ErrInvalidAppointment)
	}

	return WaitlistEntry{
		ID: id, TenantID: tenantID, PatientID: patientID,
		ResourceID: resourceID, FacilityID: facilityID, OrgUnitID: orgUnitID,
		VisitType: visitType, NotBefore: notBefore.UTC(), NotAfter: notAfter.UTC(),
		AppointmentID: appointmentID, Status: WaitlistWaiting,
		CreatedBy: createdBy, CreatedAt: now.UTC(), UpdatedAt: now.UTC(),
	}, nil
}

// Accepts reports whether a slot is one this patient would take.
func (w WaitlistEntry) Accepts(slot Slot, currentAppointmentAt time.Time) bool {
	if w.Status != WaitlistWaiting {
		return false
	}
	if w.VisitType != "" && slot.VisitType != w.VisitType {
		return false
	}
	if w.ResourceID != "" && slot.ResourceID != w.ResourceID {
		return false
	}
	if w.OrgUnitID != "" && slot.OrgUnitID != w.OrgUnitID {
		return false
	}
	if w.FacilityID != "" && slot.FacilityID != w.FacilityID {
		return false
	}
	if !w.NotBefore.IsZero() && slot.StartsAt.Before(w.NotBefore) {
		return false
	}
	if !w.NotAfter.IsZero() && !slot.StartsAt.Before(w.NotAfter) {
		return false
	}
	// The point of a waitlist is an *earlier* slot. Offering one later than the
	// appointment the patient already holds is not a service, it is a downgrade
	// somebody would have to explain.
	if !currentAppointmentAt.IsZero() && !slot.StartsAt.Before(currentAppointmentAt) {
		return false
	}
	return true
}

// Offer holds a slot for this patient until it expires.
func (w *WaitlistEntry) Offer(slot Slot, validity time.Duration, now time.Time) error {
	if w.Status != WaitlistWaiting {
		return fmt.Errorf("%w: waitlist entry %s is %s, not waiting",
			ErrInvalidAppointment, w.ID, w.Status)
	}
	if validity <= 0 {
		validity = DefaultOfferValidity
	}

	w.Status = WaitlistOffered
	w.OfferedSlotAt = slot.StartsAt.UTC()
	w.OfferExpiresAt = now.Add(validity).UTC()
	w.UpdatedAt = now.UTC()
	return nil
}

// OfferLive reports an offer that has not yet expired.
func (w WaitlistEntry) OfferLive(now time.Time) bool {
	return w.Status == WaitlistOffered && now.Before(w.OfferExpiresAt)
}

// Accept records that the patient took the offered slot.
func (w *WaitlistEntry) Accept(now time.Time) error {
	if w.Status != WaitlistOffered {
		return fmt.Errorf("%w: there is no live offer to accept", ErrInvalidAppointment)
	}
	if !w.OfferLive(now) {
		// Expired offers are refused rather than honoured late: the slot may
		// already have gone to the next person on the list, and accepting here
		// is how two patients end up holding it.
		return fmt.Errorf("%w: the offer expired at %s",
			ErrInvalidAppointment, w.OfferExpiresAt.Format(time.RFC3339))
	}
	w.Status = WaitlistAccepted
	w.UpdatedAt = now.UTC()
	return nil
}

// Decline records that the patient did not want the offered slot.
//
// Back to waiting rather than closed: somebody who cannot make Thursday is
// still waiting for something.
func (w *WaitlistEntry) Decline(now time.Time) error {
	if w.Status != WaitlistOffered {
		return fmt.Errorf("%w: there is no live offer to decline", ErrInvalidAppointment)
	}
	w.Status = WaitlistWaiting
	w.OfferedSlotAt, w.OfferExpiresAt = time.Time{}, time.Time{}
	w.UpdatedAt = now.UTC()
	return nil
}

// Expire closes an offer nobody answered, returning the entry to the list.
func (w *WaitlistEntry) Expire(now time.Time) bool {
	if w.Status != WaitlistOffered || now.Before(w.OfferExpiresAt) {
		return false
	}
	// Back to waiting rather than expired-and-done: the patient did not answer
	// one message, which is not the same as no longer wanting an appointment.
	w.Status = WaitlistWaiting
	w.OfferedSlotAt, w.OfferExpiresAt = time.Time{}, time.Time{}
	w.UpdatedAt = now.UTC()
	return true
}

// Withdraw takes a patient off the list.
func (w *WaitlistEntry) Withdraw(now time.Time) error {
	if w.Status == WaitlistAccepted {
		return fmt.Errorf("%w: this entry already produced a booking", ErrInvalidAppointment)
	}
	w.Status = WaitlistWithdrawn
	w.UpdatedAt = now.UTC()
	return nil
}
