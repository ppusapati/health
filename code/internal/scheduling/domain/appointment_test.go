package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/scheduling/domain"
)

func slot() domain.Slot {
	start := time.Date(2026, time.March, 3, 9, 0, 0, 0, time.UTC)
	return domain.Slot{
		ResourceID: "r-1", FacilityID: "f-1", OrgUnitID: "u-1",
		VisitType: domain.VisitFollowUp, VisitMode: domain.ModeInPerson,
		StartsAt: start, EndsAt: start.Add(15 * time.Minute), Capacity: 1,
	}
}

func booking(t *testing.T) *domain.Appointment {
	t.Helper()

	a, err := domain.NewAppointment("a-1", "t-1", "p-1", slot(), "clerk-1",
		"follow-up", day(2026, time.March, 1))
	if err != nil {
		t.Fatalf("NewAppointment: %v", err)
	}
	return a
}

// The id is the key every downstream record points at.
func TestAnAppointmentIdCannotBeReassigned(t *testing.T) {
	a := booking(t)
	if a.ID() != "a-1" {
		t.Fatalf("ID() = %q", a.ID())
	}
	// a.id = "other" does not compile outside this package, which is the point.
	restored := domain.RestoreAppointment("a-2", *a)
	if restored.ID() != "a-2" {
		t.Fatal("RestoreAppointment did not set the identifier")
	}
}

// The ordinary path through SRS-SCH-008's states.
func TestTheOrdinaryClinicPathIsPermitted(t *testing.T) {
	a := booking(t)
	now := day(2026, time.March, 3)

	for _, next := range []domain.Status{
		domain.StatusArrived,
		domain.StatusTriaged,
		domain.StatusWaitingClinician,
		domain.StatusInConsultation,
		domain.StatusPostConsultation,
		domain.StatusCompleted,
	} {
		if err := a.Transition(next, "clerk-1", "", false, now); err != nil {
			t.Fatalf("transition to %s: %v", next, err)
		}
		now = now.Add(time.Minute)
	}
	if a.Status != domain.StatusCompleted {
		t.Fatalf("status = %q, want completed", a.Status)
	}
	// Seven entries: the booking plus six transitions. SRS-SCH-005 requires the
	// history to be retained, and a patient disputing a fee needs all of it.
	if len(a.History) != 7 {
		t.Fatalf("history has %d entries, want 7", len(a.History))
	}
}

// Triage is skipped in an outpatient clinic and mandatory in an emergency
// department, so the machine permits both.
func TestTriageIsOptional(t *testing.T) {
	a := booking(t)
	now := day(2026, time.March, 3)

	if err := a.Transition(domain.StatusArrived, "clerk-1", "", false, now); err != nil {
		t.Fatalf("arrive: %v", err)
	}
	if err := a.Transition(domain.StatusWaitingClinician, "clerk-1", "", false, now); err != nil {
		t.Fatalf("an outpatient clinic could not skip triage: %v", err)
	}
}

// The clinician stepped out for a result; the patient returns to the queue
// rather than losing their place.
func TestAConsultationCanReturnToTheQueue(t *testing.T) {
	a := booking(t)
	now := day(2026, time.March, 3)

	for _, next := range []domain.Status{
		domain.StatusArrived, domain.StatusWaitingClinician, domain.StatusInConsultation,
	} {
		if err := a.Transition(next, "clerk-1", "", false, now); err != nil {
			t.Fatalf("transition to %s: %v", next, err)
		}
	}
	if err := a.Transition(domain.StatusWaitingClinician, "doctor-1", "", false, now); err != nil {
		t.Fatalf("a consultation could not return the patient to the queue: %v", err)
	}
}

// An invalid sequence is rejected, which is the first half of SRS-SCH-008.
func TestAnInvalidSequenceIsRejected(t *testing.T) {
	a := booking(t)

	err := a.Transition(domain.StatusInConsultation, "doctor-1", "", false, day(2026, time.March, 3))
	if err == nil {
		t.Fatal("a scheduled patient went straight into consultation without arriving")
	}
	var invalid domain.ErrInvalidTransition
	if !errors.As(err, &invalid) {
		t.Fatalf("error = %v, want ErrInvalidTransition", err)
	}
	if a.Status != domain.StatusScheduled {
		t.Fatalf("a refused transition changed the status to %q", a.Status)
	}
}

// The second half: "unless authorized correction". A machine with no escape
// hatch gets worked around, and the workaround — cancel and rebook — destroys
// the chronology the record exists to keep.
func TestACorrectionCanUndoAMistakenNoShow(t *testing.T) {
	a := booking(t)
	now := day(2026, time.March, 3)

	if err := a.Transition(domain.StatusNoShow, "clerk-1", "did not attend", false, now); err != nil {
		t.Fatalf("no-show: %v", err)
	}
	// No ordinary way back: no-show is terminal.
	if err := a.Transition(domain.StatusArrived, "clerk-1", "", false, now); err == nil {
		t.Fatal("a no-show was reversed without a correction")
	}

	if err := a.Transition(domain.StatusArrived, "supervisor-1",
		"marked against the wrong patient; this one attended", true, now); err != nil {
		t.Fatalf("an authorised correction was refused: %v", err)
	}
	if a.Status != domain.StatusArrived {
		t.Fatalf("status = %q after correction, want arrived", a.Status)
	}

	last := a.History[len(a.History)-1]
	if !last.Corrected {
		t.Fatal("the correction is not marked as one, so it reads as an ordinary transition")
	}
	if last.Reason == "" || last.By != "supervisor-1" {
		t.Fatalf("the correction does not say who made it or why: %+v", last)
	}
	// And the no-show is still in the history. That is the record a patient
	// disputing a missed-appointment fee needs.
	var sawNoShow bool
	for _, h := range a.History {
		if h.To == domain.StatusNoShow {
			sawNoShow = true
		}
	}
	if !sawNoShow {
		t.Fatal("correcting a no-show erased it from the history")
	}
}

// A correction with no reason is indistinguishable from the mistake it corrects.
func TestACorrectionNeedsAReason(t *testing.T) {
	a := booking(t)
	now := day(2026, time.March, 3)

	if err := a.Transition(domain.StatusNoShow, "clerk-1", "did not attend", false, now); err != nil {
		t.Fatalf("no-show: %v", err)
	}
	if err := a.Transition(domain.StatusArrived, "supervisor-1", "", true, now); err == nil {
		t.Fatal("a correction was made with no reason recorded")
	}
}

// Cancellation and no-show can cost the patient money and follow them into a
// clinic's attendance record.
func TestCancellingAndNoShowNeedAReason(t *testing.T) {
	for _, status := range []domain.Status{domain.StatusCancelled, domain.StatusNoShow} {
		a := booking(t)
		if err := a.Transition(status, "clerk-1", "", false, day(2026, time.March, 3)); err == nil {
			t.Errorf("moving to %s needed no reason", status)
		}
	}
}

// A double-tapped check-in button should not produce a failure a clerk has to
// interpret.
func TestRepeatingAStatusIsIdempotent(t *testing.T) {
	a := booking(t)
	now := day(2026, time.March, 3)

	if err := a.Transition(domain.StatusArrived, "clerk-1", "", false, now); err != nil {
		t.Fatalf("arrive: %v", err)
	}
	before := len(a.History)
	if err := a.Transition(domain.StatusArrived, "clerk-1", "", false, now); err != nil {
		t.Fatalf("repeating a status returned an error: %v", err)
	}
	if len(a.History) != before {
		t.Fatal("repeating a status wrote a second history entry")
	}
}

// A cancelled appointment releases its capacity; a no-show does not, because
// the slot was consumed — the patient simply did not come. Getting this
// backwards either double-books the clinic or leaves phantom bookings.
func TestOnlyCancellationReleasesCapacity(t *testing.T) {
	cancelled := booking(t)
	if err := cancelled.Transition(domain.StatusCancelled, "clerk-1", "patient called",
		false, day(2026, time.March, 3)); err != nil {
		t.Fatalf("cancel: %v", err)
	}
	if cancelled.Occupies() {
		t.Fatal("a cancelled appointment still occupies its slot, so the clinic loses it")
	}

	noShow := booking(t)
	if err := noShow.Transition(domain.StatusNoShow, "clerk-1", "did not attend",
		false, day(2026, time.March, 3)); err != nil {
		t.Fatalf("no-show: %v", err)
	}
	if !noShow.Occupies() {
		t.Fatal("a no-show released its slot; the time was consumed whether or not " +
			"the patient came")
	}
}

// A diagnosis in the diary is visible to far more people than one in the
// encounter.
func TestTheStatedReasonIsBounded(t *testing.T) {
	long := make([]byte, domain.MaxReasonLength+1)
	for i := range long {
		long[i] = 'a'
	}
	if _, err := domain.NewAppointment("a-1", "t-1", "p-1", slot(), "clerk-1",
		string(long), day(2026, time.March, 1)); err == nil {
		t.Fatal("a referral letter was pasted into the diary")
	}
}

// An appointment must say who booked it and for whom.
func TestAnAppointmentNeedsAPatientAndABooker(t *testing.T) {
	if _, err := domain.NewAppointment("a-1", "t-1", "", slot(), "clerk-1", "",
		day(2026, time.March, 1)); err == nil {
		t.Fatal("an appointment was booked for nobody")
	}
	if _, err := domain.NewAppointment("a-1", "t-1", "p-1", slot(), "", "",
		day(2026, time.March, 1)); err == nil {
		t.Fatal("an appointment was booked by nobody")
	}
}
