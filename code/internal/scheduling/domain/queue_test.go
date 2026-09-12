package domain_test

import (
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/scheduling/domain"
)

func checkIn(token string, priority domain.Priority, reason string) domain.CheckIn {
	return domain.CheckIn{
		Token: token, ArrivalMode: domain.ArrivalScheduled,
		By: "clerk-1", Priority: priority, PriorityReason: reason,
	}
}

// SRS-SCH-007: check-in records the timestamp and arrival mode, and issues a
// token the patient can be called by.
func TestCheckingInIssuesATokenAndRecordsArrival(t *testing.T) {
	a := booking(t)
	now := day(2026, time.March, 3)

	if err := a.CheckIn(checkIn("A12", domain.PriorityStandard, ""), now); err != nil {
		t.Fatalf("CheckIn: %v", err)
	}

	if a.Status != domain.StatusArrived {
		t.Fatalf("status = %q, want arrived", a.Status)
	}
	if a.Token != "A12" {
		t.Fatalf("token = %q, want the one issued", a.Token)
	}
	if a.CheckedInAt == nil {
		t.Fatal("no check-in timestamp was recorded")
	}
	if a.ArrivalMode != domain.ArrivalScheduled {
		t.Fatalf("arrival mode = %q, want it recorded", a.ArrivalMode)
	}
}

// A waiting room needs something a person can hear across a noisy space.
func TestCheckingInNeedsAToken(t *testing.T) {
	a := booking(t)
	if err := a.CheckIn(checkIn("", domain.PriorityStandard, ""),
		day(2026, time.March, 3)); err == nil {
		t.Fatal("a patient was checked in with nothing to call them by")
	}
}

// A patient put ahead of the queue without a stated reason is indistinguishable
// from queue-jumping, and the people waiting can see the board.
func TestANonStandardPriorityNeedsAReasonAtTheDoor(t *testing.T) {
	a := booking(t)
	if err := a.CheckIn(checkIn("A12", domain.PriorityUrgent, ""),
		day(2026, time.March, 3)); err == nil {
		t.Fatal("a patient was given priority at check-in with no reason")
	}
	if err := a.CheckIn(checkIn("A12", domain.PriorityUrgent, "chest pain"),
		day(2026, time.March, 3)); err != nil {
		t.Fatalf("a stated reason was refused: %v", err)
	}
}

// Checking in twice is a clerk clicking the wrong row.
func TestAPatientCannotCheckInTwice(t *testing.T) {
	a := booking(t)
	now := day(2026, time.March, 3)

	if err := a.CheckIn(checkIn("A12", domain.PriorityStandard, ""), now); err != nil {
		t.Fatalf("CheckIn: %v", err)
	}
	if err := a.CheckIn(checkIn("A13", domain.PriorityStandard, ""), now); err == nil {
		t.Fatal("a patient was checked in twice, taking a second token")
	}
}

// SRS-SCH-011: reprioritisation needs a medical reason, and the reason is
// carried where queue users can see it.
func TestReprioritisingNeedsAReasonAndKeepsIt(t *testing.T) {
	a := booking(t)
	now := day(2026, time.March, 3)

	if err := a.CheckIn(checkIn("A12", domain.PriorityStandard, ""), now); err != nil {
		t.Fatalf("CheckIn: %v", err)
	}

	if err := a.Reprioritise(domain.PriorityVeryUrgent, "doctor-1", "", now); err == nil {
		t.Fatal("a patient was moved up the queue with no reason")
	}
	if err := a.Reprioritise(domain.PriorityVeryUrgent, "doctor-1",
		"deteriorating observations", now); err != nil {
		t.Fatalf("Reprioritise: %v", err)
	}
	if a.Priority != domain.PriorityVeryUrgent {
		t.Fatalf("priority = %q, want very urgent", a.Priority)
	}
	if a.PriorityReason != "deteriorating observations" {
		t.Fatalf("the reason was not kept where queue users can see it: %q", a.PriorityReason)
	}
}

// Nobody is in the queue until they have arrived; reprioritising a future
// booking is rearranging a diary, which is a reschedule.
func TestOnlyACheckedInPatientCanBeReprioritised(t *testing.T) {
	a := booking(t)
	if err := a.Reprioritise(domain.PriorityUrgent, "doctor-1", "unwell",
		day(2026, time.March, 3)); err == nil {
		t.Fatal("a patient who has not arrived was moved up the queue")
	}
}

// The queue is priority first, then arrival: somebody who turned up on time has
// been waiting since they turned up.
func TestTheQueueOrdersByPriorityThenArrival(t *testing.T) {
	base := day(2026, time.March, 3)

	arrived := func(id, token string, priority domain.Priority, at time.Time) *domain.Appointment {
		s := slot()
		s.StartsAt, s.EndsAt = base, base.Add(15*time.Minute)
		a, err := domain.NewAppointment(id, "t-1", "p-"+id, s, "clerk-1", "", base)
		if err != nil {
			t.Fatalf("NewAppointment: %v", err)
		}
		reason := ""
		if priority != domain.PriorityStandard {
			reason = "clinical"
		}
		c := domain.CheckIn{
			Token: token, ArrivalMode: domain.ArrivalScheduled, At: at,
			By: "clerk-1", Priority: priority, PriorityReason: reason,
		}
		if err := a.CheckIn(c, at); err != nil {
			t.Fatalf("CheckIn: %v", err)
		}
		return a
	}

	early := arrived("a-1", "A1", domain.PriorityStandard, base)
	late := arrived("a-2", "A2", domain.PriorityStandard, base.Add(30*time.Minute))
	urgent := arrived("a-3", "A3", domain.PriorityUrgent, base.Add(time.Hour))

	queue := domain.BuildQueue([]*domain.Appointment{late, early, urgent},
		domain.QueueEstimate{ServiceMinutes: 10, ActiveClinicians: 1})

	if len(queue) != 3 {
		t.Fatalf("queue has %d entries, want 3", len(queue))
	}
	if queue[0].Appointment.ID() != "a-3" {
		t.Fatalf("first in the queue is %q, want the urgent patient",
			queue[0].Appointment.ID())
	}
	if queue[1].Appointment.ID() != "a-1" {
		t.Fatalf("second is %q, want the patient who arrived first",
			queue[1].Appointment.ID())
	}
	if queue[2].Appointment.ID() != "a-2" {
		t.Fatalf("third is %q, want the later arrival", queue[2].Appointment.ID())
	}
}

// A patient who has been called in is no longer waiting.
func TestTheQueueHoldsOnlyWaitingPatients(t *testing.T) {
	base := day(2026, time.March, 3)
	a := booking(t)
	if err := a.CheckIn(checkIn("A1", domain.PriorityStandard, ""), base); err != nil {
		t.Fatalf("CheckIn: %v", err)
	}
	for _, next := range []domain.Status{
		domain.StatusWaitingClinician, domain.StatusInConsultation,
	} {
		if err := a.Transition(next, "doctor-1", "", false, base); err != nil {
			t.Fatalf("transition to %s: %v", next, err)
		}
	}

	if got := domain.BuildQueue([]*domain.Appointment{a}, domain.QueueEstimate{}); len(got) != 0 {
		t.Fatalf("a patient in consultation is still in the waiting queue: %+v", got)
	}
}

// SRS-SCH-009: the estimate is arithmetic a person can judge, and it never
// reorders the queue.
func TestTheWaitEstimateGrowsDownTheQueueAndExplainsItself(t *testing.T) {
	base := day(2026, time.March, 3)

	arrived := func(id string, at time.Time) *domain.Appointment {
		s := slot()
		s.StartsAt, s.EndsAt = base, base.Add(15*time.Minute)
		a, err := domain.NewAppointment(id, "t-1", "p-"+id, s, "clerk-1", "", base)
		if err != nil {
			t.Fatalf("NewAppointment: %v", err)
		}
		if err := a.CheckIn(domain.CheckIn{
			Token: id, ArrivalMode: domain.ArrivalScheduled, At: at,
			By: "clerk-1", Priority: domain.PriorityStandard,
		}, at); err != nil {
			t.Fatalf("CheckIn: %v", err)
		}
		return a
	}

	queue := domain.BuildQueue([]*domain.Appointment{
		arrived("a-1", base), arrived("a-2", base.Add(time.Minute)),
		arrived("a-3", base.Add(2*time.Minute)),
	}, domain.QueueEstimate{ServiceMinutes: 10, ActiveClinicians: 1})

	if queue[0].EstimatedWait != 0 {
		t.Fatalf("the patient at the front waits %v, want none", queue[0].EstimatedWait)
	}
	if queue[1].EstimatedWait != 10*time.Minute {
		t.Fatalf("the second patient waits %v, want ten minutes", queue[1].EstimatedWait)
	}
	if queue[2].EstimatedWait != 20*time.Minute {
		t.Fatalf("the third patient waits %v, want twenty minutes", queue[2].EstimatedWait)
	}
}

// Two clinicians running a list halve the wait, and an estimate that ignored
// them would be wrong by a factor of two on the busiest days.
func TestTheWaitEstimateDividesByActiveClinicians(t *testing.T) {
	one := domain.QueueEstimate{Ahead: 4, ServiceMinutes: 10, ActiveClinicians: 1}
	two := domain.QueueEstimate{Ahead: 4, ServiceMinutes: 10, ActiveClinicians: 2}

	if one.Wait() != 40*time.Minute {
		t.Fatalf("one clinician gives %v, want forty minutes", one.Wait())
	}
	if two.Wait() != 20*time.Minute {
		t.Fatalf("two clinicians give %v, want twenty minutes", two.Wait())
	}
}

// An estimate of "no wait" for a queue of nine people is worse than a rough one.
func TestTheWaitEstimateFallsBackRatherThanReportingNoWait(t *testing.T) {
	e := domain.QueueEstimate{Ahead: 4, ServiceMinutes: 0, ActiveClinicians: 0}
	if e.Wait() != time.Duration(4*domain.DefaultServiceMinutes)*time.Minute {
		t.Fatalf("wait = %v with nothing configured, want the fallback", e.Wait())
	}
}

// A clinic running twenty minutes behind is running twenty minutes behind
// whatever the diary says.
func TestTheServiceRateIsObservedFromWhatActuallyHappened(t *testing.T) {
	base := day(2026, time.March, 3)

	seen := func(id string, minutes int) *domain.Appointment {
		s := slot()
		a, err := domain.NewAppointment(id, "t-1", "p-"+id, s, "clerk-1", "", base)
		if err != nil {
			t.Fatalf("NewAppointment: %v", err)
		}
		at := base
		for _, next := range []domain.Status{
			domain.StatusArrived, domain.StatusWaitingClinician, domain.StatusInConsultation,
		} {
			if err := a.Transition(next, "doctor-1", "", false, at); err != nil {
				t.Fatalf("transition: %v", err)
			}
		}
		at = at.Add(time.Duration(minutes) * time.Minute)
		if err := a.Transition(domain.StatusCompleted, "doctor-1", "", false, at); err != nil {
			t.Fatalf("complete: %v", err)
		}
		return a
	}

	// Fewer than three observations is an anecdote.
	sparse := domain.ObserveServiceRate([]*domain.Appointment{seen("a-1", 30)})
	if sparse.Observed {
		t.Fatal("a single consultation was treated as an observed service rate")
	}
	if sparse.ServiceMinutes != domain.DefaultServiceMinutes {
		t.Fatalf("service minutes = %v with too little data, want the fallback",
			sparse.ServiceMinutes)
	}

	observed := domain.ObserveServiceRate([]*domain.Appointment{
		seen("a-1", 30), seen("a-2", 30), seen("a-3", 30),
	})
	if !observed.Observed {
		t.Fatal("three completed consultations were not enough to observe a rate")
	}
	if observed.ServiceMinutes != 30 {
		t.Fatalf("service minutes = %v, want the thirty actually taken — a clinic "+
			"running late is running late whatever the roster says",
			observed.ServiceMinutes)
	}
}

// SRS-SCH-010: a walk-in is an ordinary appointment, so every downstream
// context sees it without knowing about a second kind of record.
func TestAWalkInIsAnOrdinaryAppointment(t *testing.T) {
	now := day(2026, time.March, 3)

	a, err := domain.NewWalkIn("a-1", "t-1", "f-1", "r-1", "u-1", "p-1",
		domain.CheckIn{
			Token: "W1", ArrivalMode: domain.ArrivalWalkIn, By: "clerk-1",
			Priority: domain.PriorityStandard,
		}, "cut hand", now)
	if err != nil {
		t.Fatalf("NewWalkIn: %v", err)
	}

	if a.Status != domain.StatusArrived {
		t.Fatalf("status = %q, want arrived — a walk-in is here", a.Status)
	}
	if a.VisitType != domain.VisitWalkIn {
		t.Fatalf("visit type = %q, want walk-in", a.VisitType)
	}
	if !a.Waiting() {
		t.Fatal("a walk-in is not in the waiting queue")
	}
	if a.StartsAt.IsZero() {
		t.Fatal("a walk-in has no start, so it sorts to the epoch in every clinic list")
	}
	if a.SlotID != "" {
		t.Fatal("a walk-in claimed a rostered slot; by definition nobody set time aside")
	}
}

// Without a reason nobody triaging the queue knows why this person is here,
// which is the first thing they need.
func TestAWalkInNeedsAStatedReason(t *testing.T) {
	if _, err := domain.NewWalkIn("a-1", "t-1", "f-1", "r-1", "u-1", "p-1",
		domain.CheckIn{
			Token: "W1", ArrivalMode: domain.ArrivalWalkIn, By: "clerk-1",
			Priority: domain.PriorityStandard,
		}, "", day(2026, time.March, 3)); err == nil {
		t.Fatal("a walk-in was registered with no stated reason")
	}
}

// A typo must not promote somebody to the front of a queue.
func TestAnUnknownPrioritySortsLast(t *testing.T) {
	if domain.Priority("vip").Rank() <= domain.PriorityImmediate.Rank() {
		t.Fatal("an unrecognised priority outranks a resuscitation")
	}
}

// SRS-SCH-012: "notification delivery outcome recorded".
func TestANotificationRecordsItsOutcome(t *testing.T) {
	now := day(2026, time.March, 3)

	n, err := domain.NewNotification("n-1", "t-1", domain.ForAppointment("a-1"), "p-1",
		domain.NotifyReminder, "sms", now.Add(time.Hour), now)
	if err != nil {
		t.Fatalf("NewNotification: %v", err)
	}
	if n.Outcome != domain.DeliveryPending {
		t.Fatalf("outcome = %q on creation, want pending", n.Outcome)
	}

	if err := n.Resolve(domain.DeliveryDelivered, "", now.Add(2*time.Hour)); err != nil {
		t.Fatalf("Resolve: %v", err)
	}
	if !n.Delivered() {
		t.Fatal("a delivered notification does not report itself delivered")
	}
}

// "Failed" with no reason tells a desk nothing they can act on.
func TestAFailureOrSuppressionNeedsAReason(t *testing.T) {
	now := day(2026, time.March, 3)
	n, err := domain.NewNotification("n-1", "t-1", domain.ForAppointment("a-1"), "p-1",
		domain.NotifyBooked, "sms", time.Time{}, now)
	if err != nil {
		t.Fatalf("NewNotification: %v", err)
	}

	if err := n.Resolve(domain.DeliveryFailed, "", now); err == nil {
		t.Fatal("a failure was recorded with no reason")
	}
	if err := n.Resolve(domain.DeliverySuppressed, "", now); err == nil {
		t.Fatal("a suppression was recorded with no reason")
	}
	if err := n.Resolve(domain.DeliverySuppressed,
		"the patient has not agreed to be contacted by SMS about appointments", now); err != nil {
		t.Fatalf("a stated suppression was refused: %v", err)
	}
}

// Sending "your appointment is tomorrow" an hour beforehand reads as a
// different appointment.
func TestAReminderIsNotDueWhenItWouldArriveTooLate(t *testing.T) {
	policy := domain.DefaultNotificationPolicy()
	now := day(2026, time.March, 3)

	if _, due := policy.ReminderDue(now.Add(2*time.Hour), now); due {
		t.Fatal("a day-before reminder was scheduled for an appointment two hours away")
	}
	at, due := policy.ReminderDue(now.Add(72*time.Hour), now)
	if !due {
		t.Fatal("no reminder was due for an appointment three days out")
	}
	if !at.Equal(now.Add(48 * time.Hour)) {
		t.Fatalf("the reminder is due at %v, want 24 hours before the appointment", at)
	}
}

// A clinic whose patients have no phones sends nothing rather than
// accumulating failures.
func TestAFacilityCanSendNothing(t *testing.T) {
	silent := domain.NotificationPolicy{}
	for _, kind := range []domain.NotificationKind{
		domain.NotifyBooked, domain.NotifyReminder,
		domain.NotifyRescheduled, domain.NotifyCancelled,
	} {
		if silent.Sends(kind) {
			t.Errorf("a facility sending nothing still sends %q", kind)
		}
	}
}

// "Remind them at the appointment time" is not a reminder.
func TestAReminderAtZeroHoursIsNotAReminder(t *testing.T) {
	policy := domain.DefaultNotificationPolicy()
	policy.ReminderHoursBefore = 0
	if policy.Sends(domain.NotifyReminder) {
		t.Fatal("a reminder configured for zero hours before is still sent")
	}
}

// A message about neither an appointment nor an offer could not be traced back
// to the patient it concerns; one about both would be two messages.
func TestANotificationIsAboutExactlyOneThing(t *testing.T) {
	now := day(2026, time.March, 3)

	if _, err := domain.NewNotification("n-1", "t-1", domain.NotificationSubject{},
		"p-1", domain.NotifyBooked, "sms", time.Time{}, now); err == nil {
		t.Fatal("a notification about nothing was accepted")
	}

	if _, err := domain.NewNotification("n-1", "t-1", domain.NotificationSubject{
		AppointmentID: "a-1", WaitlistID: "w-1",
	}, "p-1", domain.NotifyBooked, "sms", time.Time{}, now); err == nil {
		t.Fatal("a notification about both an appointment and an offer was accepted")
	}

	offer, err := domain.NewNotification("n-1", "t-1", domain.ForWaitlistEntry("w-1"),
		"p-1", domain.NotifyWaitlistOffer, "sms", time.Time{}, now)
	if err != nil {
		t.Fatalf("an offer notification was refused: %v", err)
	}
	if offer.AppointmentID != "" {
		t.Fatal("an offer notification carries an appointment it does not have")
	}
}

// A stored kind this version does not know is a name it cannot send, and
// keeping it would let Sends answer true for something nothing handles.
func TestAnUnknownStoredNotificationKindIsDropped(t *testing.T) {
	restored := domain.NotificationPolicyFrom([]string{"booked", "carrier_pigeon"}, 12)

	if !restored.Sends(domain.NotifyBooked) {
		t.Fatal("a stored kind this version knows was dropped")
	}
	if restored.Kinds()[0] != "booked" || len(restored.Kinds()) != 1 {
		t.Fatalf("kinds = %v, want only the recognised one", restored.Kinds())
	}
	if restored.ReminderHoursBefore != 12 {
		t.Fatalf("reminder hours = %d, want 12", restored.ReminderHoursBefore)
	}
}
