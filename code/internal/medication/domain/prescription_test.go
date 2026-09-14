package domain_test

import (
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/medication/domain"
)

var ward = mustLoad("Asia/Kolkata")

func mustLoad(name string) *time.Location {
	loc, err := time.LoadLocation(name)
	if err != nil {
		panic(err)
	}
	return loc
}

func at(y int, m time.Month, d, h, min int) time.Time {
	return time.Date(y, m, d, h, min, 0, 0, time.UTC)
}

func amoxicillin() domain.Coding {
	return domain.Coding{System: "rxnorm", Code: "723", Display: "Amoxicillin"}
}

func simpleInput() domain.NewPrescriptionInput {
	return domain.NewPrescriptionInput{
		PatientID: "p1", EncounterID: "e1", FacilityID: "f1",
		PrescriberID: "dr-rao",
		Ingredient:   amoxicillin(),
		Route:        "oral",
		Indication:   "chest infection",
		Segments: []domain.DoseSegment{{
			Sequence: 1,
			Dose:     domain.Quantity{Value: 500, Unit: "mg"},
			Timing: domain.Timing{
				FrequencyText: "three times daily",
				TimesOfDay:    []int32{6 * 60, 14 * 60, 22 * 60},
			},
		}},
		StartsAt: at(2026, time.March, 2, 4, 0),
		Stop:     domain.StopCondition{Kind: domain.StopAfterDoses, Doses: 15},
	}
}

func newLive(t *testing.T, in domain.NewPrescriptionInput) *domain.Prescription {
	t.Helper()
	p, err := domain.NewPrescription("rx1", "t1", in, at(2026, time.March, 2, 3, 0))
	if err != nil {
		t.Fatalf("NewPrescription: %v", err)
	}
	if err := p.Prescribe(at(2026, time.March, 2, 3, 0)); err != nil {
		t.Fatalf("Prescribe: %v", err)
	}
	return p
}

// SRS-MED-001: the prescription is machine-readable and human-readable, and the
// sentence is composed from the structure so the two cannot disagree.
func TestAPrescriptionReadsAsASentenceComposedFromItsStructure(t *testing.T) {
	p := newLive(t, simpleInput())

	got := p.Describe()
	for _, want := range []string{"Amoxicillin", "500 mg", "oral",
		"for 15 doses", "for chest infection"} {
		if !strings.Contains(got, want) {
			t.Errorf("Describe() = %q, missing %q", got, want)
		}
	}
}

func TestAPrescriptionNeedsAPatientAnEncounterARouteAndADose(t *testing.T) {
	cases := map[string]func(*domain.NewPrescriptionInput){
		"patient":   func(in *domain.NewPrescriptionInput) { in.PatientID = "" },
		"encounter": func(in *domain.NewPrescriptionInput) { in.EncounterID = "" },
		"route":     func(in *domain.NewPrescriptionInput) { in.Route = "" },
		"dose":      func(in *domain.NewPrescriptionInput) { in.Segments = nil },
		"prescriber": func(in *domain.NewPrescriptionInput) {
			in.PrescriberID = ""
		},
	}
	for name, break_ := range cases {
		t.Run(name, func(t *testing.T) {
			in := simpleInput()
			break_(&in)
			if _, err := domain.NewPrescription("rx1", "t1", in,
				at(2026, time.March, 2, 3, 0)); !errors.Is(err, domain.ErrInvalidPrescription) {
				t.Fatalf("missing %s accepted: %v", name, err)
			}
		})
	}
}

// The prescriber is answerable; whoever typed it is a separate fact.
func TestAPrescriptionKeepsThePrescriberAndTheTypistApart(t *testing.T) {
	in := simpleInput()
	in.EnteredByID = "nurse-mary"
	p := newLive(t, in)

	if p.PrescriberID != "dr-rao" || p.EnteredByID != "nurse-mary" {
		t.Fatalf("prescriber = %q, entered by = %q", p.PrescriberID, p.EnteredByID)
	}
}

func TestATypistDefaultsToThePrescriber(t *testing.T) {
	p := newLive(t, simpleInput())
	if p.EnteredByID != "dr-rao" {
		t.Fatalf("entered by = %q, want the prescriber", p.EnteredByID)
	}
}

// SRS-MED-001: a schedule is expanded in the ward's own clock.
func TestThreeTimesDailyLandsOnTheWardsClockNotUTC(t *testing.T) {
	p := newLive(t, simpleInput())

	doses := p.Schedule(at(2026, time.March, 2, 0, 0), at(2026, time.March, 3, 0, 0), ward)
	if len(doses) == 0 {
		t.Fatal("no doses scheduled")
	}
	for _, d := range doses {
		local := d.ScheduledAt.In(ward)
		minutes := int32(local.Hour()*60 + local.Minute())
		if minutes != 6*60 && minutes != 14*60 && minutes != 22*60 {
			t.Fatalf("dose at %s on the ward, want 06:00, 14:00 or 22:00", local.Format("15:04"))
		}
	}
}

// SRS-MED-001: a course bounded by a count stops after that many doses.
func TestACourseStopsAfterItsCountOfDoses(t *testing.T) {
	p := newLive(t, simpleInput())

	doses := p.Schedule(at(2026, time.March, 1, 0, 0), at(2026, time.April, 1, 0, 0), ward)
	if len(doses) != 15 {
		t.Fatalf("got %d doses, want the 15 the course was written for", len(doses))
	}
}

// SRS-MED-009: a taper is explicit segments, and each day gets its own dose.
func TestATaperGivesEachSegmentsOwnDose(t *testing.T) {
	in := simpleInput()
	in.Ingredient = domain.Coding{System: "rxnorm", Code: "8640", Display: "Prednisolone"}
	in.Stop = domain.StopCondition{Kind: domain.StopNone}
	in.Segments = []domain.DoseSegment{
		{
			Sequence: 1, Dose: domain.Quantity{Value: 30, Unit: "mg"},
			Timing:   domain.Timing{TimesOfDay: []int32{8 * 60}},
			StartsAt: at(2026, time.March, 2, 0, 0),
			EndsAt:   at(2026, time.March, 5, 0, 0),
		},
		{
			Sequence: 2, Dose: domain.Quantity{Value: 20, Unit: "mg"},
			Timing:   domain.Timing{TimesOfDay: []int32{8 * 60}},
			StartsAt: at(2026, time.March, 5, 0, 0),
			EndsAt:   at(2026, time.March, 8, 0, 0),
		},
		{
			Sequence: 3, Dose: domain.Quantity{Value: 10, Unit: "mg"},
			Timing:   domain.Timing{TimesOfDay: []int32{8 * 60}},
			StartsAt: at(2026, time.March, 8, 0, 0),
			EndsAt:   at(2026, time.March, 11, 0, 0),
		},
	}
	in.StartsAt = at(2026, time.March, 2, 0, 0)
	p := newLive(t, in)

	doses := p.Schedule(at(2026, time.March, 1, 0, 0), at(2026, time.March, 20, 0, 0), ward)
	byDose := map[float64]int{}
	for _, d := range doses {
		byDose[d.Segment.Dose.Value]++
	}
	for _, want := range []float64{30, 20, 10} {
		if byDose[want] == 0 {
			t.Fatalf("no dose of %g mg in the taper; got %v", want, byDose)
		}
	}
	// The last 10 mg dose must come after the last 30 mg one, or the taper is
	// being applied in the wrong order.
	var last30, first10 time.Time
	for _, d := range doses {
		switch d.Segment.Dose.Value {
		case 30:
			last30 = d.ScheduledAt
		case 10:
			if first10.IsZero() {
				first10 = d.ScheduledAt
			}
		}
	}
	if !first10.After(last30) {
		t.Fatalf("the 10 mg step at %s does not follow the 30 mg step at %s", first10, last30)
	}
}

func TestDoseSegmentsMustBeNumberedWithoutGaps(t *testing.T) {
	in := simpleInput()
	in.Segments = []domain.DoseSegment{
		{Sequence: 1, Dose: domain.Quantity{Value: 30, Unit: "mg"},
			Timing: domain.Timing{TimesOfDay: []int32{8 * 60}},
			EndsAt: at(2026, time.March, 5, 0, 0)},
		{Sequence: 3, Dose: domain.Quantity{Value: 10, Unit: "mg"},
			Timing:   domain.Timing{TimesOfDay: []int32{8 * 60}},
			StartsAt: at(2026, time.March, 5, 0, 0)},
	}
	if _, err := domain.NewPrescription("rx1", "t1", in,
		at(2026, time.March, 2, 3, 0)); !errors.Is(err, domain.ErrInvalidPrescription) {
		t.Fatalf("a gap in the taper was accepted: %v", err)
	}
}

func TestTaperSegmentsCannotOverlap(t *testing.T) {
	in := simpleInput()
	in.Segments = []domain.DoseSegment{
		{Sequence: 1, Dose: domain.Quantity{Value: 30, Unit: "mg"},
			Timing:   domain.Timing{TimesOfDay: []int32{8 * 60}},
			StartsAt: at(2026, time.March, 2, 0, 0),
			EndsAt:   at(2026, time.March, 6, 0, 0)},
		{Sequence: 2, Dose: domain.Quantity{Value: 10, Unit: "mg"},
			Timing:   domain.Timing{TimesOfDay: []int32{8 * 60}},
			StartsAt: at(2026, time.March, 4, 0, 0)},
	}
	if _, err := domain.NewPrescription("rx1", "t1", in,
		at(2026, time.March, 2, 3, 0)); !errors.Is(err, domain.ErrInvalidPrescription) {
		t.Fatalf("overlapping taper steps were accepted: %v", err)
	}
}

func TestADoseNeedsAUnitAndAValue(t *testing.T) {
	for name, dose := range map[string]domain.Quantity{
		"no unit":  {Value: 500},
		"no value": {Unit: "mg"},
		"negative": {Value: -5, Unit: "mg"},
	} {
		t.Run(name, func(t *testing.T) {
			in := simpleInput()
			in.Segments[0].Dose = dose
			_, err := domain.NewPrescription("rx1", "t1", in, at(2026, time.March, 2, 3, 0))
			if !errors.Is(err, domain.ErrInvalidPrescription) {
				t.Fatalf("%s accepted: %v", name, err)
			}
		})
	}
}

// SRS-MED-013: a hold stops future doses from its effective time and leaves
// everything before it exactly as it was.
func TestHoldingStopsFutureDosesFromItsEffectiveTime(t *testing.T) {
	p := newLive(t, simpleInput())

	before := p.Schedule(at(2026, time.March, 2, 0, 0), at(2026, time.March, 4, 0, 0), ward)
	if len(before) < 3 {
		t.Fatalf("expected a few doses before the hold, got %d", len(before))
	}

	effective := at(2026, time.March, 2, 12, 0)
	if err := p.Hold("dr-rao", "for theatre", effective,
		at(2026, time.March, 2, 14, 0)); err != nil {
		t.Fatalf("Hold: %v", err)
	}

	after := p.Schedule(at(2026, time.March, 2, 0, 0), at(2026, time.March, 4, 0, 0), ward)
	for _, d := range after {
		if !d.ScheduledAt.Before(effective) {
			t.Fatalf("dose at %s survived a hold effective %s", d.ScheduledAt, effective)
		}
	}
	if len(after) == 0 {
		t.Fatal("the hold removed the doses that were already due before it")
	}
}

// SRS-MED-013: the effective time is what the clinician said, not when they
// typed it.
func TestAHoldTakesEffectWhenTheClinicianSaidNotWhenItWasTyped(t *testing.T) {
	p := newLive(t, simpleInput())
	effective := at(2026, time.March, 2, 9, 0)

	if err := p.Hold("dr-rao", "for theatre", effective,
		at(2026, time.March, 2, 11, 0)); err != nil {
		t.Fatalf("Hold: %v", err)
	}
	if got := p.EffectiveStop(); !got.Equal(effective) {
		t.Fatalf("effective stop = %s, want %s", got, effective)
	}
}

func TestHoldingAndDiscontinuingNeedAReason(t *testing.T) {
	p := newLive(t, simpleInput())
	if err := p.Hold("dr-rao", "  ", at(2026, time.March, 2, 9, 0),
		at(2026, time.March, 2, 9, 0)); !errors.Is(err, domain.ErrInvalidPrescription) {
		t.Fatalf("a reasonless hold was accepted: %v", err)
	}
	if err := p.Discontinue("dr-rao", "", at(2026, time.March, 2, 9, 0),
		at(2026, time.March, 2, 9, 0)); !errors.Is(err, domain.ErrInvalidPrescription) {
		t.Fatalf("a reasonless discontinuation was accepted: %v", err)
	}
}

// SRS-MED-013: a held drug restarts, and the restart is on the record.
func TestRestartingAHeldMedicationResumesTheSchedule(t *testing.T) {
	p := newLive(t, simpleInput())
	if err := p.Hold("dr-rao", "for theatre", at(2026, time.March, 2, 12, 0),
		at(2026, time.March, 2, 12, 0)); err != nil {
		t.Fatalf("Hold: %v", err)
	}
	if err := p.Restart("dr-rao", "back from theatre", at(2026, time.March, 3, 6, 0),
		at(2026, time.March, 3, 6, 0)); err != nil {
		t.Fatalf("Restart: %v", err)
	}

	doses := p.Schedule(at(2026, time.March, 3, 0, 0), at(2026, time.March, 5, 0, 0), ward)
	if len(doses) == 0 {
		t.Fatal("no doses after the restart")
	}
	if len(p.Changes) != 3 {
		t.Fatalf("ledger has %d entries, want prescribe, hold and restart", len(p.Changes))
	}
}

func TestOnlyAHeldMedicationCanBeRestarted(t *testing.T) {
	p := newLive(t, simpleInput())
	if err := p.Restart("dr-rao", "why", at(2026, time.March, 3, 6, 0),
		at(2026, time.March, 3, 6, 0)); !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("restarting an active medication was accepted: %v", err)
	}
}

// SRS-MED-013: a discontinued medication cannot come back.
func TestADiscontinuedMedicationCannotBeRestarted(t *testing.T) {
	p := newLive(t, simpleInput())
	if err := p.Discontinue("dr-rao", "rash", at(2026, time.March, 2, 12, 0),
		at(2026, time.March, 2, 12, 0)); err != nil {
		t.Fatalf("Discontinue: %v", err)
	}
	if err := p.Restart("dr-rao", "changed my mind", at(2026, time.March, 3, 6, 0),
		at(2026, time.March, 3, 6, 0)); !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("a discontinued medication was restarted: %v", err)
	}
}

// SRS-MED-014: the timeline is reconstructable from the ledger.
func TestTheTherapyStatusCanBeAnsweredAsOfAMoment(t *testing.T) {
	p := newLive(t, simpleInput())
	_ = p.Hold("dr-rao", "for theatre", at(2026, time.March, 5, 8, 0), at(2026, time.March, 5, 8, 0))
	_ = p.Restart("dr-rao", "back", at(2026, time.March, 6, 8, 0), at(2026, time.March, 6, 8, 0))
	_ = p.Discontinue("dr-rao", "course finished", at(2026, time.March, 9, 8, 0),
		at(2026, time.March, 9, 8, 0))

	for _, tc := range []struct {
		when time.Time
		want domain.TherapyStatus
	}{
		{at(2026, time.March, 3, 0, 0), "active"},
		{at(2026, time.March, 5, 12, 0), "held"},
		{at(2026, time.March, 7, 0, 0), "active"},
		{at(2026, time.March, 10, 0, 0), "discontinued"},
	} {
		if got := p.StatusAt(tc.when); got != tc.want {
			t.Errorf("status at %s = %q, want %q", tc.when.Format("Jan 2"), got, tc.want)
		}
	}
}

func TestAChangeCannotBeBackdatedBehindThePreviousOne(t *testing.T) {
	p := newLive(t, simpleInput())
	if err := p.Hold("dr-rao", "for theatre", at(2026, time.March, 5, 8, 0),
		at(2026, time.March, 5, 8, 0)); err != nil {
		t.Fatalf("Hold: %v", err)
	}
	if err := p.Restart("dr-rao", "back", at(2026, time.March, 4, 8, 0),
		at(2026, time.March, 5, 9, 0)); !errors.Is(err, domain.ErrInvalidPrescription) {
		t.Fatalf("a backdated change reordered the timeline: %v", err)
	}
}

func TestRepeatingATherapyChangeIsHarmless(t *testing.T) {
	p := newLive(t, simpleInput())
	_ = p.Hold("dr-rao", "for theatre", at(2026, time.March, 5, 8, 0), at(2026, time.March, 5, 8, 0))
	before := len(p.Changes)
	if err := p.Hold("dr-rao", "for theatre", at(2026, time.March, 5, 8, 0),
		at(2026, time.March, 5, 9, 0)); err != nil {
		t.Fatalf("repeating a hold: %v", err)
	}
	if len(p.Changes) != before {
		t.Fatalf("a repeated hold appended a second ledger entry")
	}
}

// SRS-MED-007: an unverified prescription produces no administration where
// policy requires verification.
func TestAnUnverifiedPrescriptionIsNotAdministrableWherePolicyRequiresIt(t *testing.T) {
	p := newLive(t, simpleInput())
	when := at(2026, time.March, 2, 8, 0)

	if p.Administrable(when, true) {
		t.Fatal("an unverified prescription was administrable under a policy that requires verification")
	}
	if !p.Administrable(when, false) {
		t.Fatal("an unverified prescription was refused where policy does not require verification")
	}
}

// SRS-MED-007: after the effective stop time, nothing further.
func TestADiscontinuedPrescriptionIsNotAdministrableAfterItsStopTime(t *testing.T) {
	p := newLive(t, simpleInput())
	stop := at(2026, time.March, 4, 12, 0)
	if err := p.Discontinue("dr-rao", "rash", stop, stop); err != nil {
		t.Fatalf("Discontinue: %v", err)
	}

	if p.Administrable(stop.Add(time.Hour), false) {
		t.Fatal("a dose after the effective stop time was administrable")
	}
	if !p.Administrable(stop.Add(-time.Hour), false) {
		t.Fatal("a dose before the effective stop time was refused")
	}
}

// A prescription transcribed for a drug the patient came in on is live from
// when the therapy started, not from when somebody got round to typing it.
func TestATranscribedPrescriptionIsLiveFromWhenTheTherapyStarted(t *testing.T) {
	in := simpleInput()
	in.StartsAt = at(2026, time.February, 28, 6, 0)
	in.Segments[0].StartsAt = in.StartsAt

	p, err := domain.NewPrescription("rx1", "t1", in, at(2026, time.March, 2, 11, 0))
	if err != nil {
		t.Fatalf("NewPrescription: %v", err)
	}
	if err := p.Prescribe(at(2026, time.March, 2, 11, 0)); err != nil {
		t.Fatalf("Prescribe: %v", err)
	}

	if got := p.StatusAt(at(2026, time.March, 1, 0, 0)); got != domain.TherapyActive {
		t.Fatalf("status on the day before it was typed = %q, want active", got)
	}
	// And a hold backdated to the ward round is not "dated before the
	// prescription", which is what the keystroke timestamp would have made it.
	if err := p.Hold("dr-rao", "for theatre", at(2026, time.March, 2, 9, 0),
		at(2026, time.March, 2, 11, 30)); err != nil {
		t.Fatalf("a hold backdated to the ward round was refused: %v", err)
	}
}
