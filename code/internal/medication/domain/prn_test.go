package domain_test

import (
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/medication/domain"
)

func morphinePRN() domain.PRNConstraint {
	return domain.PRNConstraint{
		Indication:  "for breakthrough pain",
		MinInterval: 4 * time.Hour,
		MaxDoses:    4,
		Period:      24 * time.Hour,
	}
}

// SRS-MED-008: the minimum interval is enforced, and the refusal says when.
func TestAPRNDoseTooSoonIsRefusedAndSaysWhenItIsDue(t *testing.T) {
	last := at(2026, time.March, 2, 6, 0)
	err := morphinePRN().CheckPRN([]time.Time{last},
		domain.Quantity{Value: 10, Unit: "mg"}, at(2026, time.March, 2, 8, 0))

	var refusal domain.PRNRefusal
	if !errors.As(err, &refusal) {
		t.Fatalf("a dose two hours into a four-hourly minimum was allowed: %v", err)
	}
	if want := last.Add(4 * time.Hour); !refusal.NextAllowedAt.Equal(want) {
		t.Fatalf("next allowed at %s, want %s", refusal.NextAllowedAt, want)
	}
	if !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("the refusal does not carry the sentinel: %v", err)
	}
}

func TestAPRNDoseAfterTheIntervalIsAllowed(t *testing.T) {
	if err := morphinePRN().CheckPRN([]time.Time{at(2026, time.March, 2, 6, 0)},
		domain.Quantity{Value: 10, Unit: "mg"},
		at(2026, time.March, 2, 10, 0)); err != nil {
		t.Fatalf("a dose exactly at the interval was refused: %v", err)
	}
}

// SRS-MED-008: the maximum in the period is enforced.
func TestAPRNMaximumInThePeriodIsEnforced(t *testing.T) {
	given := []time.Time{
		at(2026, time.March, 2, 0, 0),
		at(2026, time.March, 2, 5, 0),
		at(2026, time.March, 2, 10, 0),
		at(2026, time.March, 2, 15, 0),
	}
	err := morphinePRN().CheckPRN(given, domain.Quantity{Value: 10, Unit: "mg"},
		at(2026, time.March, 2, 20, 0))

	var refusal domain.PRNRefusal
	if !errors.As(err, &refusal) {
		t.Fatalf("a fifth dose in 24 hours was allowed: %v", err)
	}
	if refusal.Given != 4 || refusal.Limit != 4 {
		t.Fatalf("the refusal reports %d of %d", refusal.Given, refusal.Limit)
	}
}

// The window rolls: doses that have aged out no longer count.
func TestPRNDosesThatHaveAgedOutOfThePeriodDoNotCount(t *testing.T) {
	given := []time.Time{
		at(2026, time.March, 1, 0, 0),
		at(2026, time.March, 1, 5, 0),
		at(2026, time.March, 1, 10, 0),
		at(2026, time.March, 1, 15, 0),
	}
	if err := morphinePRN().CheckPRN(given, domain.Quantity{Value: 10, Unit: "mg"},
		at(2026, time.March, 2, 20, 0)); err != nil {
		t.Fatalf("doses from more than a day ago still counted: %v", err)
	}
}

// SRS-MED-008: a total-amount ceiling, where the units are comparable.
func TestAPRNTotalAmountCeilingIsEnforced(t *testing.T) {
	paracetamolPRN := domain.PRNConstraint{
		Indication:   "for pain",
		MaxDoseTotal: domain.Quantity{Value: 4000, Unit: "mg"},
		Period:       24 * time.Hour,
	}
	given := []time.Time{
		at(2026, time.March, 2, 0, 0), at(2026, time.March, 2, 6, 0),
		at(2026, time.March, 2, 12, 0), at(2026, time.March, 2, 18, 0),
	}
	err := paracetamolPRN.CheckPRN(given, domain.Quantity{Value: 1000, Unit: "mg"},
		at(2026, time.March, 2, 22, 0))
	if !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("a fifth gram of paracetamol in a day was allowed: %v", err)
	}
}

// A ceiling in a different unit is left to the pharmacist rather than guessed.
func TestATotalCeilingInADifferentUnitIsNotGuessedAt(t *testing.T) {
	constraint := domain.PRNConstraint{
		Indication:   "for pain",
		MaxDoseTotal: domain.Quantity{Value: 4000, Unit: "mg"},
	}
	given := []time.Time{
		at(2026, time.March, 2, 0, 0), at(2026, time.March, 2, 6, 0),
		at(2026, time.March, 2, 12, 0), at(2026, time.March, 2, 18, 0),
		at(2026, time.March, 2, 20, 0), at(2026, time.March, 2, 21, 0),
	}
	if err := constraint.CheckPRN(given, domain.Quantity{Value: 2, Unit: "tablet"},
		at(2026, time.March, 2, 22, 0)); err != nil {
		t.Fatalf("tablets were converted to milligrams: %v", err)
	}
}

// SRS-MED-008: an as-needed medication needs a stated trigger.
func TestAnAsNeededMedicationNeedsAnIndication(t *testing.T) {
	in := simpleInput()
	in.Segments[0].Timing = domain.Timing{PRN: true}
	in.PRN = domain.PRNConstraint{MinInterval: 4 * time.Hour}

	if _, err := domain.NewPrescription("rx1", "t1", in,
		at(2026, time.March, 2, 3, 0)); !errors.Is(err, domain.ErrInvalidPrescription) {
		t.Fatalf("an as-needed medication with no trigger was accepted: %v", err)
	}
}

// An as-needed medication has no schedule, so it produces no due doses.
func TestAnAsNeededMedicationProducesNoScheduledDoses(t *testing.T) {
	in := simpleInput()
	in.Segments[0].Timing = domain.Timing{PRN: true}
	in.PRN = morphinePRN()
	in.Stop = domain.StopCondition{Kind: domain.StopNone}
	p := newLive(t, in)

	if doses := p.Schedule(at(2026, time.March, 2, 0, 0),
		at(2026, time.March, 5, 0, 0), ward); len(doses) != 0 {
		t.Fatalf("an as-needed medication produced %d scheduled doses", len(doses))
	}
}

func TestAnAsNeededMedicationCannotAlsoHaveASchedule(t *testing.T) {
	in := simpleInput()
	in.Segments[0].Timing = domain.Timing{PRN: true, TimesOfDay: []int32{8 * 60}}
	in.PRN = morphinePRN()

	if _, err := domain.NewPrescription("rx1", "t1", in,
		at(2026, time.March, 2, 3, 0)); !errors.Is(err, domain.ErrInvalidPrescription) {
		t.Fatalf("an as-needed medication with a schedule was accepted: %v", err)
	}
}

// SRS-MED-008: the constraints are rendered so a nurse can read them.
func TestThePRNConstraintsAppearInTheHumanReadableForm(t *testing.T) {
	in := simpleInput()
	in.Segments[0].Timing = domain.Timing{PRN: true}
	in.PRN = morphinePRN()
	in.Stop = domain.StopCondition{Kind: domain.StopNone}
	p := newLive(t, in)

	got := p.Describe()
	for _, want := range []string{"as needed", "breakthrough pain", "4h0m0s", "maximum 4"} {
		if !strings.Contains(got, want) {
			t.Errorf("Describe() = %q, missing %q", got, want)
		}
	}
}
