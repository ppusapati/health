package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/nursing/domain"
)

func at(hour, minute int) time.Time {
	return time.Date(2026, 3, 12, hour, minute, 0, 0, time.UTC)
}

func pulse() domain.Coding {
	return domain.Coding{
		System: "http://loinc.org", Version: "2.76",
		Code: "8867-4", Display: "Heart rate",
	}
}

func chartEntry(t *testing.T, observed, recorded time.Time,
	reason string) (*domain.FlowsheetEntry, error) {

	t.Helper()
	return domain.NewFlowsheetEntry("entry-1", "tenant-1",
		domain.NewFlowsheetEntryInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			Code:       pulse(),
			Value:      domain.Quantity{Value: 88, Unit: "/min"},
			ObservedAt: observed, Source: domain.SourceManual,
			LateEntryReason: reason,
		}, "nurse-1", recorded)
}

// SRS-NUR-003: the observation time is the bedside time, not the typing time.
func TestAnObservationRecordsWhenItWasTakenNotWhenItWasTyped(t *testing.T) {
	entry, err := chartEntry(t, at(6, 0), at(6, 2), "")
	if err != nil {
		t.Fatalf("NewFlowsheetEntry: %v", err)
	}
	if !entry.ObservedAt.Equal(at(6, 0)) {
		t.Fatalf("observed at %s, want 06:00", entry.ObservedAt)
	}
	if !entry.RecordedAt.Equal(at(6, 2)) {
		t.Fatalf("recorded at %s, want 06:02", entry.RecordedAt)
	}
}

// SRS-NUR-003: a late entry is identified as late.
func TestACatchUpEntryIsMarkedLate(t *testing.T) {
	onTime, err := chartEntry(t, at(6, 0), at(6, 10), "")
	if err != nil {
		t.Fatalf("NewFlowsheetEntry: %v", err)
	}
	if onTime.IsLate() {
		t.Fatal("an entry charted ten minutes later is marked late")
	}

	late, err := chartEntry(t, at(6, 0), at(8, 40), "ward round; charted at the end")
	if err != nil {
		t.Fatalf("NewFlowsheetEntry: %v", err)
	}
	if !late.IsLate() {
		t.Fatal("an entry charted two hours and forty minutes later is not marked late")
	}
	if late.Delay() != 2*time.Hour+40*time.Minute {
		t.Fatalf("delay is %s, want 2h40m", late.Delay())
	}
}

// A late entry with no explanation is refused: the flag without the reason
// says a record is weak without saying why.
func TestALateEntryMustSayWhyItIsLate(t *testing.T) {
	_, err := chartEntry(t, at(6, 0), at(8, 40), "")
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a late entry with no reason was accepted: %v", err)
	}
}

// The observation time is not optional, because defaulting it is the failure
// SRS-NUR-003 exists to prevent and it fails silently.
func TestAnObservationNeedsTheTimeItWasTaken(t *testing.T) {
	_, err := chartEntry(t, time.Time{}, at(8, 40), "")
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("an entry with no observation time was accepted: %v", err)
	}
}

func TestAnObservationCannotHaveBeenTakenInTheFuture(t *testing.T) {
	_, err := chartEntry(t, at(9, 0), at(8, 0), "")
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a future observation was accepted: %v", err)
	}
}

func TestAChartedNumberNeedsItsUnit(t *testing.T) {
	_, err := domain.NewFlowsheetEntry("entry-1", "tenant-1",
		domain.NewFlowsheetEntryInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			Code: pulse(), Value: domain.Quantity{Value: 88},
			ObservedAt: at(6, 0), Source: domain.SourceManual,
		}, "nurse-1", at(6, 1))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a unitless measurement was accepted: %v", err)
	}
}

// A value attributed to a monitor with no monitor named cannot be checked
// against the monitor when somebody disputes it.
func TestADeviceReadingMustNameTheDevice(t *testing.T) {
	_, err := domain.NewFlowsheetEntry("entry-1", "tenant-1",
		domain.NewFlowsheetEntryInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			Code: pulse(), Value: domain.Quantity{Value: 140, Unit: "/min"},
			ObservedAt: at(6, 0), Source: domain.SourceDevice,
		}, "nurse-1", at(6, 1))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a device reading with no device was accepted: %v", err)
	}
}

func TestAChartedValueMustSayWhereItCameFrom(t *testing.T) {
	_, err := domain.NewFlowsheetEntry("entry-1", "tenant-1",
		domain.NewFlowsheetEntryInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			Code: pulse(), Value: domain.Quantity{Value: 88, Unit: "/min"},
			ObservedAt: at(6, 0),
		}, "nurse-1", at(6, 1))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("an entry with no source was accepted: %v", err)
	}
}

// The chart is a picture of the patient, so it sorts by when the observation
// was true rather than by when somebody typed it.
func TestTheFlowsheetSortsByObservationTimeNotTypingTime(t *testing.T) {
	early, err := chartEntry(t, at(6, 0), at(8, 40), "catch-up after the round")
	if err != nil {
		t.Fatalf("NewFlowsheetEntry: %v", err)
	}
	later, err := domain.NewFlowsheetEntry("entry-2", "tenant-1",
		domain.NewFlowsheetEntryInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			Code: pulse(), Value: domain.Quantity{Value: 96, Unit: "/min"},
			ObservedAt: at(8, 0), Source: domain.SourceManual,
		}, "nurse-1", at(8, 5))
	if err != nil {
		t.Fatalf("NewFlowsheetEntry: %v", err)
	}

	// Typed in the order 08:00 then 06:00.
	entries := []*domain.FlowsheetEntry{later, early}
	domain.SortFlowsheet(entries)

	if entries[0].ID != early.ID {
		t.Fatal("the 06:00 observation is not first; the chart would show the " +
			"patient improving before deteriorating")
	}
}

func fluid(t *testing.T, direction domain.FluidDirection, category string,
	volume float64, observed time.Time) *domain.FluidEntry {

	t.Helper()
	entry, err := domain.NewFluidEntry("fluid-"+category, "tenant-1",
		domain.NewFluidEntryInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			Direction: direction, Category: category,
			VolumeML: volume, ObservedAt: observed,
		}, "nurse-1", observed.Add(time.Minute))
	if err != nil {
		t.Fatalf("NewFluidEntry: %v", err)
	}
	return entry
}

// SRS-NUR-004: a running balance by category.
func TestTheFluidBalanceRunsByCategory(t *testing.T) {
	entries := []*domain.FluidEntry{
		fluid(t, domain.FluidIntake, "oral", 200, at(8, 0)),
		fluid(t, domain.FluidIntake, "intravenous", 1000, at(9, 0)),
		fluid(t, domain.FluidOutput, "urine", 750, at(10, 0)),
		fluid(t, domain.FluidOutput, "drain", 150, at(11, 0)),
	}

	balance := domain.Balance(entries, at(8, 0), at(20, 0))
	if balance.IntakeML != 1200 {
		t.Fatalf("intake is %v, want 1200", balance.IntakeML)
	}
	if balance.OutputML != 900 {
		t.Fatalf("output is %v, want 900", balance.OutputML)
	}
	if balance.NetML() != 300 {
		t.Fatalf("net is %v, want +300", balance.NetML())
	}
	// "900 ml out" is a different clinical picture when 150 of it is drain
	// loss, so the breakdown is not optional.
	if balance.ByCategory["output:drain"] != 150 {
		t.Fatalf("drain loss is %v, want 150", balance.ByCategory["output:drain"])
	}
}

// SRS-NUR-004: corrections use an amendment trail.
func TestCorrectingAVolumeKeepsTheOriginalAndMovesTheBalance(t *testing.T) {
	original := fluid(t, domain.FluidOutput, "urine", 750, at(10, 0))

	correction, err := original.Correct("fluid-corrected", 450,
		"misread the measuring jug", "nurse-2", at(10, 30))
	if err != nil {
		t.Fatalf("Correct: %v", err)
	}
	original.SupersededByID = correction.ID

	if correction.SupersedesID != original.ID {
		t.Fatal("the correction does not point back at what it replaced")
	}
	// The original is still readable: the shift balance that was handed over
	// was computed from it.
	if original.VolumeML != 750 {
		t.Fatalf("the original was edited to %v", original.VolumeML)
	}

	balance := domain.Balance([]*domain.FluidEntry{original, correction},
		at(8, 0), at(20, 0))
	if balance.OutputML != 450 {
		t.Fatalf("the balance counts %v; a superseded entry is still counted",
			balance.OutputML)
	}
	if balance.Counted != 1 {
		t.Fatalf("the balance counted %d entries, want 1", balance.Counted)
	}
}

func TestACorrectionNeedsASubstantiveReason(t *testing.T) {
	original := fluid(t, domain.FluidOutput, "urine", 750, at(10, 0))
	if _, err := original.Correct("fluid-2", 450, "fix", "nurse-2", at(10, 30)); !errors.Is(
		err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a one-word correction reason was accepted: %v", err)
	}
}

// A negative volume is how a balance gets corrected by a system with no
// amendment trail. This one has an amendment trail.
func TestAVolumeCannotBeNegative(t *testing.T) {
	_, err := domain.NewFluidEntry("fluid-1", "tenant-1",
		domain.NewFluidEntryInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			Direction: domain.FluidOutput, Category: "urine",
			VolumeML: -200, ObservedAt: at(10, 0),
		}, "nurse-1", at(10, 1))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a negative volume was accepted: %v", err)
	}
}

func TestAnEntryCannotBeCorrectedTwice(t *testing.T) {
	original := fluid(t, domain.FluidOutput, "urine", 750, at(10, 0))
	correction, err := original.Correct("fluid-2", 450, "misread the jug",
		"nurse-2", at(10, 30))
	if err != nil {
		t.Fatalf("Correct: %v", err)
	}
	original.SupersededByID = correction.ID

	if _, err := original.Correct("fluid-3", 500, "misread it again",
		"nurse-2", at(10, 45)); !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("a superseded entry was corrected again: %v", err)
	}
}

func TestAVoidedEntryLeavesTheBalance(t *testing.T) {
	entry := fluid(t, domain.FluidOutput, "urine", 750, at(10, 0))
	if err := entry.Void("charted against the wrong patient", "nurse-2",
		at(10, 30)); err != nil {
		t.Fatalf("Void: %v", err)
	}
	balance := domain.Balance([]*domain.FluidEntry{entry}, at(8, 0), at(20, 0))
	if balance.OutputML != 0 {
		t.Fatalf("a voided entry still counts: %v", balance.OutputML)
	}
	// It is still there to read.
	if entry.VolumeML != 750 {
		t.Fatal("voiding destroyed the entry")
	}
}

// The balance is bounded by observation time, so a late-charted 06:00 reading
// falls in the night shift's balance where it belongs.
func TestABalanceIsBoundedByObservationTime(t *testing.T) {
	night := fluid(t, domain.FluidOutput, "urine", 300, at(6, 0))
	// Recorded at 08:40, during the morning shift.
	night.RecordedAt = at(8, 40)

	morning := domain.Balance([]*domain.FluidEntry{night}, at(8, 0), at(20, 0))
	if morning.OutputML != 0 {
		t.Fatalf("a 06:00 reading fell into the morning balance: %v", morning.OutputML)
	}
	overnight := domain.Balance([]*domain.FluidEntry{night}, at(0, 0), at(8, 0))
	if overnight.OutputML != 300 {
		t.Fatalf("the 06:00 reading is missing from the night balance: %v",
			overnight.OutputML)
	}
}
