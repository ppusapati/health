package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/scheduling/domain"
)

func appointmentAt(t *testing.T, startsAt time.Time) *domain.Appointment {
	t.Helper()

	s := slot()
	s.StartsAt = startsAt
	s.EndsAt = startsAt.Add(15 * time.Minute)

	a, err := domain.NewAppointment("a-1", "t-1", "p-1", s, "clerk-1", "review",
		startsAt.AddDate(0, 0, -7))
	if err != nil {
		t.Fatalf("NewAppointment: %v", err)
	}
	return a
}

// A hospital charging for a late cancellation is making a claim about what the
// patient agreed to, and the claim has to be checkable afterwards.
func TestACancellationRecordsTheNoticeGivenAndRequired(t *testing.T) {
	startsAt := time.Date(2026, time.March, 10, 9, 0, 0, 0, time.UTC)
	a := appointmentAt(t, startsAt)

	policy := domain.DefaultCancellationPolicy()
	// 23 hours' notice against a 24-hour policy: late by an hour.
	outcome, err := a.Cancel(policy, "clerk-1", "patient called",
		startsAt.Add(-23*time.Hour))
	if err != nil {
		t.Fatalf("Cancel: %v", err)
	}

	if outcome.Timely {
		t.Fatal("23 hours' notice against a 24-hour policy was recorded as timely")
	}
	if outcome.NoticeGiven != 23*time.Hour {
		t.Fatalf("notice given = %v, want 23h", outcome.NoticeGiven)
	}
	if outcome.NoticeRequired != 24*time.Hour {
		t.Fatalf("notice required = %v, want 24h — the policy in force at the "+
			"moment of the decision", outcome.NoticeRequired)
	}
	if a.Status != domain.StatusCancelled {
		t.Fatalf("status = %q, want cancelled", a.Status)
	}
}

// Timely means no referral to billing, whatever the policy charges.
func TestATimelyCancellationIsNotChargeable(t *testing.T) {
	startsAt := time.Date(2026, time.March, 10, 9, 0, 0, 0, time.UTC)
	a := appointmentAt(t, startsAt)

	policy := domain.DefaultCancellationPolicy()
	policy.ChargeableWhenLate = true

	outcome, err := a.Cancel(policy, "clerk-1", "patient called",
		startsAt.Add(-48*time.Hour))
	if err != nil {
		t.Fatalf("Cancel: %v", err)
	}
	if !outcome.Timely || outcome.Chargeable {
		t.Fatalf("two days' notice was treated as late or chargeable: %+v", outcome)
	}
}

// A default that charged would bill patients on the strength of a setting
// nobody chose.
func TestTheDefaultPolicyChargesNothing(t *testing.T) {
	startsAt := time.Date(2026, time.March, 10, 9, 0, 0, 0, time.UTC)
	a := appointmentAt(t, startsAt)

	outcome, err := a.Cancel(domain.DefaultCancellationPolicy(), "clerk-1",
		"did not call", startsAt.Add(-time.Minute))
	if err != nil {
		t.Fatalf("Cancel: %v", err)
	}
	if outcome.Timely {
		t.Fatal("a cancellation a minute before was timely")
	}
	if outcome.Chargeable {
		t.Fatal("the default policy referred a late cancellation to billing")
	}
}

// A completed appointment has happened; cancelling it would rewrite what took
// place.
func TestACompletedAppointmentCannotBeCancelled(t *testing.T) {
	startsAt := time.Date(2026, time.March, 10, 9, 0, 0, 0, time.UTC)
	a := appointmentAt(t, startsAt)

	now := startsAt
	for _, next := range []domain.Status{
		domain.StatusArrived, domain.StatusWaitingClinician,
		domain.StatusInConsultation, domain.StatusCompleted,
	} {
		if err := a.Transition(next, "clerk-1", "", false, now); err != nil {
			t.Fatalf("transition to %s: %v", next, err)
		}
	}

	if _, err := a.Cancel(domain.DefaultCancellationPolicy(), "clerk-1",
		"changed my mind", now); err == nil {
		t.Fatal("a completed appointment was cancelled")
	}
}

// Cancelling needs a reason for the same reason the transition does: it can
// cost the patient money and follows them into an attendance record.
func TestCancellingNeedsAReason(t *testing.T) {
	startsAt := time.Date(2026, time.March, 10, 9, 0, 0, 0, time.UTC)
	a := appointmentAt(t, startsAt)

	if _, err := a.Cancel(domain.DefaultCancellationPolicy(), "clerk-1", "",
		startsAt.Add(-48*time.Hour)); err == nil {
		t.Fatal("an appointment was cancelled with no reason")
	}
}

// A facility that has not thought about remote consultations has not decided
// which of its clinics can safely run that way.
func TestTeleconsultsAreOffByDefault(t *testing.T) {
	if err := domain.DefaultTeleconsultPolicy().CheckEligible(
		domain.VisitFollowUp, true); err == nil {
		t.Fatal("an unconfigured facility offered a teleconsult")
	}
}

// A procedure that needs the patient in the room is what the visit-type
// restriction exists for.
func TestATeleconsultPolicyCanRestrictVisitTypes(t *testing.T) {
	policy := domain.TeleconsultPolicy{
		Enabled:           true,
		AllowedVisitTypes: []domain.VisitType{domain.VisitFollowUp},
	}

	if err := policy.CheckEligible(domain.VisitFollowUp, true); err != nil {
		t.Fatalf("a permitted visit type was refused: %v", err)
	}

	err := policy.CheckEligible(domain.VisitProcedure, true)
	if err == nil {
		t.Fatal("a procedure was booked as a teleconsult against policy")
	}
	var notEligible domain.ErrTeleconsultNotEligible
	if !errors.As(err, &notEligible) {
		t.Fatalf("error = %v, want ErrTeleconsultNotEligible", err)
	}
}

// Identifying somebody over video is materially harder than at a desk, and a
// hospital may reasonably insist the first visit is in person.
func TestATeleconsultPolicyCanRequireConfirmedIdentity(t *testing.T) {
	policy := domain.TeleconsultPolicy{Enabled: true, RequireConfirmedIdentity: true}

	if err := policy.CheckEligible(domain.VisitFollowUp, false); err == nil {
		t.Fatal("an unconfirmed patient was booked a remote appointment")
	}
	if err := policy.CheckEligible(domain.VisitFollowUp, true); err != nil {
		t.Fatalf("a confirmed patient was refused: %v", err)
	}
}

func series(t *testing.T) domain.Series {
	t.Helper()

	s, err := domain.NewSeries("se-1", "t-1", "p-1", "r-1", domain.VisitFollowUp,
		7, 6, time.Date(2026, time.March, 3, 10, 0, 0, 0, time.UTC),
		"clerk-1", day(2026, time.March, 1))
	if err != nil {
		t.Fatalf("NewSeries: %v", err)
	}
	return s
}

// A patient told "every Tuesday at ten" does not expect the eighth session at
// nine.
func TestASeriesKeepsItsLocalTimeAcrossADaylightSavingChange(t *testing.T) {
	london, err := time.LoadLocation("Europe/London")
	if err != nil {
		t.Fatalf("LoadLocation: %v", err)
	}

	// Starts before the spring transition and runs past it.
	start := time.Date(2026, time.March, 24, 10, 0, 0, 0, london)
	s, err := domain.NewSeries("se-1", "t-1", "p-1", "r-1", domain.VisitFollowUp,
		7, 4, start, "clerk-1", start.AddDate(0, 0, -7))
	if err != nil {
		t.Fatalf("NewSeries: %v", err)
	}

	times := s.OccurrenceTimes(london)
	if len(times) != 4 {
		t.Fatalf("generated %d occurrences, want 4", len(times))
	}
	for i, at := range times {
		local := at.In(london)
		if local.Hour() != 10 || local.Minute() != 0 {
			t.Fatalf("occurrence %d is at %02d:%02d local, want 10:00 — the course "+
				"moved when the clocks did", i+1, local.Hour(), local.Minute())
		}
	}
}

// One appointment is not a series, and a course longer than a year is a
// standing arrangement.
func TestASeriesIsBounded(t *testing.T) {
	start := time.Date(2026, time.March, 3, 10, 0, 0, 0, time.UTC)

	if _, err := domain.NewSeries("se-1", "t-1", "p-1", "r-1", domain.VisitFollowUp,
		7, 1, start, "clerk-1", start); err == nil {
		t.Fatal("a single appointment was created as a series")
	}
	if _, err := domain.NewSeries("se-1", "t-1", "p-1", "r-1", domain.VisitFollowUp,
		7, domain.MaxSeriesOccurrences+1, start, "clerk-1", start); err == nil {
		t.Fatal("a series longer than a year was accepted")
	}
	if _, err := domain.NewSeries("se-1", "t-1", "p-1", "r-1", domain.VisitFollowUp,
		0, 6, start, "clerk-1", start); err == nil {
		t.Fatal("a series with no interval was accepted")
	}
}

// The acceptance criterion: a change affects one occurrence or every future
// one, and never a past one.
func TestASeriesChangeReachesOnlyTheScopeAsked(t *testing.T) {
	now := time.Date(2026, time.March, 10, 12, 0, 0, 0, time.UTC)

	occurrence := func(id string, at time.Time) *domain.Appointment {
		s := slot()
		s.StartsAt, s.EndsAt = at, at.Add(15*time.Minute)
		a, err := domain.NewAppointment(id, "t-1", "p-1", s, "clerk-1", "",
			now.AddDate(0, 0, -14))
		if err != nil {
			t.Fatalf("NewAppointment: %v", err)
		}
		a.SeriesID = "se-1"
		return a
	}

	past := occurrence("a-past", now.AddDate(0, 0, -7))
	pivot := occurrence("a-pivot", now.AddDate(0, 0, 7))
	later := occurrence("a-later", now.AddDate(0, 0, 14))

	if past.AffectedBy(domain.ScopeFutureOccurrences, pivot, now) {
		t.Fatal("a past occurrence was swept up by a future-occurrences change; " +
			"it records treatment that was given")
	}
	if !pivot.AffectedBy(domain.ScopeThisOccurrence, pivot, now) {
		t.Fatal("the named occurrence was not affected by a this-occurrence change")
	}
	if later.AffectedBy(domain.ScopeThisOccurrence, pivot, now) {
		t.Fatal("a later occurrence was changed by a this-occurrence request")
	}
	if !later.AffectedBy(domain.ScopeFutureOccurrences, pivot, now) {
		t.Fatal("a later occurrence was not reached by a future-occurrences change")
	}
}

// A cancelled occurrence is settled; sweeping it up would resurrect something
// somebody decided about.
func TestABulkSeriesChangeSkipsSettledOccurrences(t *testing.T) {
	now := time.Date(2026, time.March, 10, 12, 0, 0, 0, time.UTC)

	s := slot()
	s.StartsAt, s.EndsAt = now.AddDate(0, 0, 7), now.AddDate(0, 0, 7).Add(15*time.Minute)
	pivot, err := domain.NewAppointment("a-pivot", "t-1", "p-1", s, "clerk-1", "",
		now.AddDate(0, 0, -14))
	if err != nil {
		t.Fatalf("NewAppointment: %v", err)
	}
	pivot.SeriesID = "se-1"

	s.StartsAt, s.EndsAt = now.AddDate(0, 0, 14), now.AddDate(0, 0, 14).Add(15*time.Minute)
	cancelled, err := domain.NewAppointment("a-cancelled", "t-1", "p-1", s, "clerk-1", "",
		now.AddDate(0, 0, -14))
	if err != nil {
		t.Fatalf("NewAppointment: %v", err)
	}
	cancelled.SeriesID = "se-1"
	if err := cancelled.Transition(domain.StatusCancelled, "clerk-1",
		"patient away", false, now); err != nil {
		t.Fatalf("cancel: %v", err)
	}

	if cancelled.AffectedBy(domain.ScopeFutureOccurrences, pivot, now) {
		t.Fatal("a cancelled occurrence was resurrected by a bulk series change")
	}
}

func waitlistEntry(t *testing.T, currentAt time.Time) domain.WaitlistEntry {
	t.Helper()

	w, err := domain.NewWaitlistEntry("w-1", "t-1", "p-1", "r-1", "f-1", "u-1",
		domain.VisitFollowUp, time.Time{}, time.Time{}, "a-1", "clerk-1",
		day(2026, time.March, 1))
	if err != nil {
		t.Fatalf("NewWaitlistEntry: %v", err)
	}
	_ = currentAt
	return w
}

// The point of a waitlist is an earlier slot. Offering one later than the
// appointment the patient already holds is a downgrade somebody would have to
// explain.
func TestAWaitlistOnlyAcceptsAnEarlierSlot(t *testing.T) {
	current := time.Date(2026, time.April, 1, 9, 0, 0, 0, time.UTC)
	w := waitlistEntry(t, current)

	earlier := slot()
	earlier.StartsAt = current.AddDate(0, 0, -7)
	earlier.ResourceID, earlier.FacilityID, earlier.OrgUnitID = "r-1", "f-1", "u-1"

	later := earlier
	later.StartsAt = current.AddDate(0, 0, 7)

	if !w.Accepts(earlier, current) {
		t.Fatal("an earlier slot was not accepted")
	}
	if w.Accepts(later, current) {
		t.Fatal("a slot later than the appointment already held was offered")
	}
}

// A patient who cannot come before Thursday should not be offered Wednesday.
func TestAWaitlistRespectsTheAcceptableWindow(t *testing.T) {
	notBefore := time.Date(2026, time.March, 12, 0, 0, 0, 0, time.UTC)
	w, err := domain.NewWaitlistEntry("w-1", "t-1", "p-1", "r-1", "f-1", "u-1",
		domain.VisitFollowUp, notBefore, time.Time{}, "a-1", "clerk-1",
		day(2026, time.March, 1))
	if err != nil {
		t.Fatalf("NewWaitlistEntry: %v", err)
	}

	tooEarly := slot()
	tooEarly.StartsAt = notBefore.AddDate(0, 0, -1)
	tooEarly.ResourceID, tooEarly.FacilityID, tooEarly.OrgUnitID = "r-1", "f-1", "u-1"

	if w.Accepts(tooEarly, time.Date(2026, time.April, 1, 9, 0, 0, 0, time.UTC)) {
		t.Fatal("a slot before the patient's stated availability was offered")
	}
}

// SRS-SCH-006: "offer has expiry". A slot promised to somebody who has stopped
// reading their messages is capacity nobody can use.
func TestAnOfferExpires(t *testing.T) {
	now := day(2026, time.March, 10)
	w := waitlistEntry(t, time.Time{})

	offered := slot()
	offered.StartsAt = now.AddDate(0, 0, 3)

	if err := w.Offer(offered, time.Hour, now); err != nil {
		t.Fatalf("Offer: %v", err)
	}
	if !w.OfferLive(now.Add(30 * time.Minute)) {
		t.Fatal("an offer expired before its validity elapsed")
	}
	if w.OfferLive(now.Add(2 * time.Hour)) {
		t.Fatal("an offer was still live after its validity elapsed")
	}

	// Accepting late is refused: the slot may already have gone to the next
	// person, and honouring it is how two patients end up holding it.
	if err := w.Accept(now.Add(2 * time.Hour)); err == nil {
		t.Fatal("an expired offer was accepted")
	}
	if err := w.Accept(now.Add(30 * time.Minute)); err != nil {
		t.Fatalf("a live offer could not be accepted: %v", err)
	}
	if w.Status != domain.WaitlistAccepted {
		t.Fatalf("status = %q, want accepted", w.Status)
	}
}

// Not answering one message is not the same as no longer wanting an
// appointment.
func TestAnExpiredOfferReturnsThePatientToTheList(t *testing.T) {
	now := day(2026, time.March, 10)
	w := waitlistEntry(t, time.Time{})

	offered := slot()
	offered.StartsAt = now.AddDate(0, 0, 3)
	if err := w.Offer(offered, time.Hour, now); err != nil {
		t.Fatalf("Offer: %v", err)
	}

	if !w.Expire(now.Add(2 * time.Hour)) {
		t.Fatal("an elapsed offer did not expire")
	}
	if w.Status != domain.WaitlistWaiting {
		t.Fatalf("status = %q after expiry, want waiting — the patient is still "+
			"waiting for an appointment", w.Status)
	}
	if !w.OfferedSlotAt.IsZero() {
		t.Fatal("an expired offer still holds a slot")
	}
}

// Declining returns the patient to the list too: somebody who cannot make
// Thursday is still waiting for something.
func TestDecliningKeepsThePatientWaiting(t *testing.T) {
	now := day(2026, time.March, 10)
	w := waitlistEntry(t, time.Time{})

	offered := slot()
	offered.StartsAt = now.AddDate(0, 0, 3)
	if err := w.Offer(offered, time.Hour, now); err != nil {
		t.Fatalf("Offer: %v", err)
	}
	if err := w.Decline(now.Add(time.Minute)); err != nil {
		t.Fatalf("Decline: %v", err)
	}
	if w.Status != domain.WaitlistWaiting {
		t.Fatalf("status = %q after declining, want waiting", w.Status)
	}
}

// Waiting for nothing in particular produces an offer for anything at all.
func TestAWaitlistEntryNeedsSomethingToWaitFor(t *testing.T) {
	if _, err := domain.NewWaitlistEntry("w-1", "t-1", "p-1", "", "", "",
		domain.VisitFollowUp, time.Time{}, time.Time{}, "", "clerk-1",
		day(2026, time.March, 1)); err == nil {
		t.Fatal("a waitlist entry was created with nothing to wait for")
	}
}
