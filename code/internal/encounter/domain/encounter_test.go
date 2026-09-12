package domain_test

import (
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/encounter/domain"
)

// The encounter container (SRS-ENC-001 … SRS-ENC-012).

func at(y int, m time.Month, d, h int) time.Time {
	return time.Date(y, m, d, h, 0, 0, 0, time.UTC)
}

func newEncounter(t *testing.T, class domain.Class, now time.Time) *domain.Encounter {
	t.Helper()

	e, err := domain.NewEncounter("e-1", "t-1", domain.NewEncounterInput{
		PatientID: "p-1", FacilityID: "f-1", Class: class,
		AttendingProviderID: "doctor-1", Reason: "chest pain",
	}, "clerk-1", now)
	if err != nil {
		t.Fatalf("NewEncounter: %v", err)
	}
	return e
}

// SRS-ENC-001: an encounter is linked to patient, facility, class, attending
// provider and reason.
func TestAnEncounterNeedsAPatientAFacilityAndAResponsibleClinician(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	cases := map[string]domain.NewEncounterInput{
		"no patient": {
			FacilityID: "f-1", Class: domain.ClassOutpatient, AttendingProviderID: "doctor-1",
		},
		"no facility": {
			PatientID: "p-1", Class: domain.ClassOutpatient, AttendingProviderID: "doctor-1",
		},
		"unknown class": {
			PatientID: "p-1", FacilityID: "f-1", Class: "corridor",
			AttendingProviderID: "doctor-1",
		},
		"no attending provider": {
			PatientID: "p-1", FacilityID: "f-1", Class: domain.ClassOutpatient,
		},
	}

	for name, in := range cases {
		t.Run(name, func(t *testing.T) {
			if _, err := domain.NewEncounter("e-1", "t-1", in, "clerk-1", now); err == nil {
				t.Fatalf("an encounter with %s was accepted", name)
			}
		})
	}
}

// A walk-in for an X-ray has no consultation, so inventing an attending
// clinician would put a name against a decision that person never made.
func TestADiagnosticOnlyVisitNeedsNoAttendingClinician(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	if _, err := domain.NewEncounter("e-1", "t-1", domain.NewEncounterInput{
		PatientID: "p-1", FacilityID: "f-1", Class: domain.ClassDiagnosticOnly,
		Reason: "chest x-ray",
	}, "clerk-1", now); err != nil {
		t.Fatalf("a diagnostic-only encounter was refused for having no clinician: %v", err)
	}
}

// SRS-ENC-003: the encounter's own times, independent of any appointment.
func TestAnEncounterKeepsItsOwnClinicalTimes(t *testing.T) {
	now := at(2026, time.March, 3, 9)
	e := newEncounter(t, domain.ClassOutpatient, now)

	// Booked for 09:00, actually seen at 10:30, out at 11:15.
	seen := at(2026, time.March, 3, 10).Add(30 * time.Minute)
	if err := e.Start(seen, "doctor-1", at(2026, time.March, 3, 11)); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if !e.StartedAt.Equal(seen) {
		t.Fatalf("started at %v, want the time the patient was actually seen", e.StartedAt)
	}

	out := at(2026, time.March, 3, 11).Add(15 * time.Minute)
	if err := e.End(out, "doctor-1", at(2026, time.March, 3, 12)); err != nil {
		t.Fatalf("End: %v", err)
	}

	duration, known := e.Duration()
	if !known || duration != 45*time.Minute {
		t.Fatalf("duration = %v (known %v), want 45m", duration, known)
	}
}

// A start time in the future sorts to the end of every chronological view for
// as long as it stands.
func TestAnEncounterCannotStartInTheFuture(t *testing.T) {
	now := at(2026, time.March, 3, 9)
	e := newEncounter(t, domain.ClassOutpatient, now)

	if err := e.Start(at(2026, time.March, 4, 9), "doctor-1", now); err == nil {
		t.Fatal("an encounter was started in the future")
	}
}

func TestAnEncounterCannotEndBeforeItStarted(t *testing.T) {
	now := at(2026, time.March, 3, 9)
	e := newEncounter(t, domain.ClassOutpatient, now)

	if err := e.Start(now, "doctor-1", now); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if err := e.End(at(2026, time.March, 3, 8), "doctor-1", now); err == nil {
		t.Fatal("an encounter ended before it started")
	}
}

// SRS-ENC-006: invalid state changes are rejected.
func TestAnEncounterRefusesAnImpossibleStateChange(t *testing.T) {
	now := at(2026, time.March, 3, 9)
	e := newEncounter(t, domain.ClassOutpatient, now)

	// Planned straight to closed skips the entire visit.
	if err := e.Close("doctor-1", now); err == nil {
		t.Fatal("a planned encounter was closed without ever happening")
	}
}

// Cancelled and entered-in-error mean opposite things to a report: one is a
// visit that did not take place, the other a record that was never true.
// Counting them together would tell a quality team that patients are
// cancelling when in fact clerks are misclicking.
func TestCancelledAndEnteredInErrorAreDistinct(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	cancelled := newEncounter(t, domain.ClassOutpatient, now)
	if err := cancelled.Cancel("clerk-1", "patient did not attend", now); err != nil {
		t.Fatalf("Cancel: %v", err)
	}
	if cancelled.Status != domain.StatusCancelled {
		t.Fatalf("status = %q, want cancelled", cancelled.Status)
	}

	// An encounter opened against the wrong patient is noticed later, often
	// after it has been closed.
	wrong := newEncounter(t, domain.ClassOutpatient, now)
	if err := wrong.Start(now, "doctor-1", now); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if err := wrong.End(now, "doctor-1", now); err != nil {
		t.Fatalf("End: %v", err)
	}
	if err := wrong.Close("doctor-1", now); err != nil {
		t.Fatalf("Close: %v", err)
	}
	if err := wrong.MarkEnteredInError("doctor-1", "opened against the wrong patient",
		now); err != nil {
		t.Fatalf("a closed encounter could not be marked entered-in-error: %v", err)
	}
	if wrong.Status != domain.StatusEnteredInError {
		t.Fatalf("status = %q, want entered_in_error", wrong.Status)
	}
}

// Both need a reason: they are the two states somebody asks about later.
func TestCancellingAndRetractingNeedReasons(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	e := newEncounter(t, domain.ClassOutpatient, now)
	if err := e.Cancel("clerk-1", "  ", now); err == nil {
		t.Fatal("an encounter was cancelled with no reason")
	}
	if err := e.MarkEnteredInError("clerk-1", "", now); err == nil {
		t.Fatal("an encounter was retracted with no reason")
	}
}

// SRS-ENC-009: after closure the record is amended, not rewritten.
func TestAClosedEncounterCannotBeReopened(t *testing.T) {
	now := at(2026, time.March, 3, 9)
	e := newEncounter(t, domain.ClassOutpatient, now)

	if err := e.Start(now, "doctor-1", now); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if err := e.End(now, "doctor-1", now); err != nil {
		t.Fatalf("End: %v", err)
	}
	if err := e.Close("doctor-1", now); err != nil {
		t.Fatalf("Close: %v", err)
	}

	err := e.Reopen("doctor-1", "forgot to add a note", now)
	if err == nil {
		t.Fatal("a closed encounter was reopened, so its summary can be silently rewritten")
	}
	if !strings.Contains(err.Error(), "amended") {
		t.Fatalf("the refusal does not point at the amendment route: %v", err)
	}
}

// Before closure nothing has been summarised, so continuing is simply
// continuing.
func TestAFinishedEncounterCanBeContinued(t *testing.T) {
	now := at(2026, time.March, 3, 9)
	e := newEncounter(t, domain.ClassOutpatient, now)

	if err := e.Start(now, "doctor-1", now); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if err := e.End(now, "doctor-1", now); err != nil {
		t.Fatalf("End: %v", err)
	}
	if err := e.Reopen("doctor-1", "patient returned deteriorating", now); err != nil {
		t.Fatalf("a finished encounter could not be continued: %v", err)
	}
	if e.Status != domain.StatusInProgress {
		t.Fatalf("status = %q, want in_progress", e.Status)
	}
}

// Leave is a bed concept. An outpatient who walks out has not gone on leave.
func TestOnlyAnInpatientCanGoOnLeave(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	outpatient := newEncounter(t, domain.ClassOutpatient, now)
	if err := outpatient.Start(now, "doctor-1", now); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if err := outpatient.GoOnLeave("nurse-1", "went for coffee", now); err == nil {
		t.Fatal("an outpatient went on leave")
	}

	inpatient := newEncounter(t, domain.ClassInpatient, now)
	if err := inpatient.Start(now, "doctor-1", now); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if err := inpatient.GoOnLeave("nurse-1", "home for the weekend", now); err != nil {
		t.Fatalf("an inpatient could not go on leave: %v", err)
	}
}

// Clinical content must not be written into a container that asserts the visit
// did not happen.
func TestOnlyAnOpenEncounterAcceptsClinicalContent(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	open := newEncounter(t, domain.ClassOutpatient, now)
	if err := open.Start(now, "doctor-1", now); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if !open.AcceptsClinicalContent() {
		t.Fatal("an in-progress encounter refuses clinical content")
	}

	cancelled := newEncounter(t, domain.ClassOutpatient, now)
	if err := cancelled.Cancel("clerk-1", "did not attend", now); err != nil {
		t.Fatalf("Cancel: %v", err)
	}
	if cancelled.AcceptsClinicalContent() {
		t.Fatal("a cancelled encounter accepts clinical content, so a note can " +
			"contradict its own container")
	}
}

// A status change records who made it.
func TestAStatusChangeRecordsItsAuthor(t *testing.T) {
	now := at(2026, time.March, 3, 9)
	e := newEncounter(t, domain.ClassOutpatient, now)

	if err := e.Start(now, "", now); err == nil {
		t.Fatal("an encounter was started by nobody")
	}

	if err := e.Start(now, "doctor-1", now); err != nil {
		t.Fatalf("Start: %v", err)
	}
	last := e.History[len(e.History)-1]
	if last.By != "doctor-1" || last.To != domain.StatusInProgress {
		t.Fatalf("history entry = %+v, want the start recorded against doctor-1", last)
	}
}

// A double-tapped button on a ward terminal should not produce a failure
// somebody has to interpret.
func TestRepeatingAStatusChangeIsHarmless(t *testing.T) {
	now := at(2026, time.March, 3, 9)
	e := newEncounter(t, domain.ClassOutpatient, now)

	if err := e.Start(now, "doctor-1", now); err != nil {
		t.Fatalf("Start: %v", err)
	}
	before := len(e.History)
	if err := e.Start(now, "doctor-1", now); err != nil {
		t.Fatalf("a repeated start was refused: %v", err)
	}
	if len(e.History) != before {
		t.Fatal("a repeated start wrote a second history entry")
	}
}

// An invalid transition says what it refused.
func TestAnInvalidTransitionNamesBothStates(t *testing.T) {
	now := at(2026, time.March, 3, 9)
	e := newEncounter(t, domain.ClassOutpatient, now)

	err := e.Close("doctor-1", now)
	if err == nil {
		t.Fatal("a planned encounter was closed")
	}

	var invalid domain.ErrInvalidTransition
	if errors.As(err, &invalid) {
		if invalid.From != domain.StatusPlanned {
			t.Fatalf("the refusal reports from=%q", invalid.From)
		}
		return
	}
	if !errors.Is(err, domain.ErrInvalidEncounter) {
		t.Fatalf("the refusal is neither a transition error nor a domain one: %v", err)
	}
}

// A planned admission next week must not sort below a visit from 1970.
func TestSortingPutsAPlannedEncounterInItsPlace(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	past := newEncounter(t, domain.ClassOutpatient, at(2026, time.January, 5, 9))
	if err := past.Start(at(2026, time.January, 5, 9), "doctor-1",
		at(2026, time.January, 5, 9)); err != nil {
		t.Fatalf("Start: %v", err)
	}
	planned := newEncounter(t, domain.ClassInpatient, now)

	list := []*domain.Encounter{past, planned}
	domain.SortEncounters(list)
	if list[0] != planned {
		t.Fatal("a planned encounter sorted below a visit from two months ago")
	}
}
