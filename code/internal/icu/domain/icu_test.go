package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/icu/domain"
)

var at = time.Date(2026, 9, 17, 8, 0, 0, 0, time.UTC)

func episode(t *testing.T) domain.Episode {
	t.Helper()
	e, err := domain.NewEpisode("ep-1", "tenant-1", domain.NewEpisodeInput{
		EncounterID: "enc-1", PatientID: "pat-1", FacilityID: "fac-1",
		UnitID: "icu-general", BedID: "bed-4", Source: domain.AdmissionWard,
		ResponsibleTeam: "icu_team", AdmittedAt: at,
	}, "doctor-1", at)
	if err != nil {
		t.Fatalf("NewEpisode: %v", err)
	}
	return e
}

// SRS-ICU-001. Where the patient came from is a quality measure in its own
// right: an unplanned ward admission is a deterioration somebody may have
// missed, and a post-operative bed is a plan. A system that let the field go
// unset would report a unit that never deteriorates anybody.
func TestAnAdmissionSaysWhereThePatientCameFrom(t *testing.T) {
	_, err := domain.NewEpisode("ep-1", "tenant-1", domain.NewEpisodeInput{
		EncounterID: "enc-1", PatientID: "pat-1", UnitID: "icu", BedID: "bed-1",
	}, "doctor-1", at)
	if err == nil {
		t.Fatal("an admission with no source was accepted")
	}
	if !errors.Is(err, domain.ErrInvalidEpisode) {
		t.Fatalf("error = %v, want an invalid-episode refusal", err)
	}
}

// A transfer between units names the episode it continues. Without it the
// second stay looks short and the first looks like a patient who improved.
func TestATransferNamesTheEpisodeItContinues(t *testing.T) {
	_, err := domain.NewEpisode("ep-2", "tenant-1", domain.NewEpisodeInput{
		EncounterID: "enc-1", PatientID: "pat-1", UnitID: "icu-cardiac",
		BedID: "bed-2", Source: domain.AdmissionOtherICU,
	}, "doctor-1", at)
	if err == nil {
		t.Fatal("a transfer with no provenance was accepted")
	}

	ok, err := domain.NewEpisode("ep-2", "tenant-1", domain.NewEpisodeInput{
		EncounterID: "enc-1", PatientID: "pat-1", UnitID: "icu-cardiac",
		BedID: "bed-2", Source: domain.AdmissionOtherICU, TransferredFrom: "ep-1",
	}, "doctor-1", at)
	if err != nil {
		t.Fatalf("NewEpisode with provenance: %v", err)
	}
	if ok.TransferredFrom != "ep-1" {
		t.Fatalf("TransferredFrom = %q", ok.TransferredFrom)
	}
}

// SRS-ICU-016: every outstanding handover requirement at once. A nurse told
// one missing thing at a time makes four attempts while a bed is needed.
func TestATransferReportsEveryOutstandingHandoverAtOnce(t *testing.T) {
	e := episode(t)

	outstanding, err := e.Discharge(domain.OutcomeWard, "", domain.HandoverEvidence{},
		at.Add(48*time.Hour))
	if err != nil {
		t.Fatalf("Discharge: %v", err)
	}
	if len(outstanding) != 4 {
		t.Fatalf("%d outstanding requirements, want 4: %v", len(outstanding), outstanding)
	}
	if e.Status == domain.EpisodeClosed {
		t.Fatal("the episode closed with nothing handed over")
	}

	outstanding, err = e.Discharge(domain.OutcomeWard, "step down", domain.HandoverEvidence{
		MedicationsReconciled: true, DevicesListed: true,
		TasksHandedOver: true, SummaryWritten: true,
	}, at.Add(48*time.Hour))
	if err != nil {
		t.Fatalf("Discharge with evidence: %v", err)
	}
	if len(outstanding) != 0 {
		t.Fatalf("still outstanding: %v", outstanding)
	}
	if e.Status != domain.EpisodeClosed {
		t.Fatalf("status = %q after a complete handover", e.Status)
	}
}

// A death is not gated on paperwork. A unit that could not record one until
// four checklists were complete would record it late, and the time of death is
// the one timestamp nobody may reconstruct.
func TestADeathIsNotGatedOnHandoverPaperwork(t *testing.T) {
	e := episode(t)

	outstanding, err := e.Discharge(domain.OutcomeDeath, "asystole, no ROSC",
		domain.HandoverEvidence{}, at.Add(6*time.Hour))
	if err != nil {
		t.Fatalf("Discharge: %v", err)
	}
	if len(outstanding) != 0 {
		t.Fatalf("a death was blocked on handover: %v", outstanding)
	}
	if e.Status != domain.EpisodeClosed {
		t.Fatal("the death did not close the episode")
	}
}

// The discharge delay is the number that explains a full unit better than its
// admissions do, and a second declaration must not restart its clock.
func TestDeclaringReadyIsIdempotent(t *testing.T) {
	e := episode(t)

	if err := e.DeclareReady(at.Add(20 * time.Hour)); err != nil {
		t.Fatalf("DeclareReady: %v", err)
	}
	first := e.ReadyAt
	if err := e.DeclareReady(at.Add(30 * time.Hour)); err != nil {
		t.Fatalf("DeclareReady (second): %v", err)
	}
	if !e.ReadyAt.Equal(first) {
		t.Fatalf("ReadyAt moved from %v to %v; the clock restarted", first, e.ReadyAt)
	}

	if _, err := e.Discharge(domain.OutcomeWard, "step down", domain.HandoverEvidence{
		MedicationsReconciled: true, DevicesListed: true,
		TasksHandedOver: true, SummaryWritten: true,
	}, at.Add(31*time.Hour)); err != nil {
		t.Fatalf("Discharge: %v", err)
	}
	delay, ok := e.DischargeDelay()
	if !ok || delay != 11*time.Hour {
		t.Fatalf("discharge delay = %v (%v), want 11h", delay, ok)
	}
}

// A running stay has no length. Returning the elapsed time would put a number
// in a report that changes every time it is run.
func TestLengthOfStayIsFalseWhileTheEpisodeIsOpen(t *testing.T) {
	e := episode(t)
	if _, ok := e.LengthOfStay(); ok {
		t.Fatal("an open episode reported a length of stay")
	}
}

// Half-open bed-day counting. A patient discharged at 08:00 did not occupy the
// bed for the rest of the day, and one admitted and discharged the same day
// did occupy it. Getting this wrong reports an occupancy above 100%.
func TestBedOccupancyIsHalfOpen(t *testing.T) {
	e := episode(t)
	if _, err := e.Discharge(domain.OutcomeWard, "", domain.HandoverEvidence{
		MedicationsReconciled: true, DevicesListed: true,
		TasksHandedOver: true, SummaryWritten: true,
	}, at.Add(2*time.Hour)); err != nil {
		t.Fatalf("Discharge: %v", err)
	}

	if !e.OccupiedOn(at) {
		t.Fatal("a same-day stay occupied no bed")
	}
	if e.OccupiedOn(at.Add(24 * time.Hour)) {
		t.Fatal("a discharged patient occupied a bed the next day")
	}
	if e.OccupiedOn(at.Add(-24 * time.Hour)) {
		t.Fatal("a patient occupied a bed the day before admission")
	}
}

// SRS-ICU-002's "unit-normalized". A temperature silently read as Celsius when
// the monitor sent Fahrenheit is a fever that is not there.
func TestFahrenheitIsNormalisedToCelsius(t *testing.T) {
	o, err := domain.NewObservation("obs-1", "tenant-1", domain.NewObservationInput{
		EpisodeID: "ep-1", Code: "8310-5", Display: "Body temperature",
		Dimension: "temperature", Value: 100.4, Unit: "F", ObservedAt: at,
	}, "nurse-1", at)
	if err != nil {
		t.Fatalf("NewObservation: %v", err)
	}
	if !o.Normalised {
		t.Fatal("a Fahrenheit temperature was not normalised")
	}
	if diff := o.Value - 38.0; diff > 0.001 || diff < -0.001 {
		t.Fatalf("value = %v Cel, want 38", o.Value)
	}
	if o.Unit != "Cel" {
		t.Fatalf("unit = %q, want Cel", o.Unit)
	}
	// What the device actually sent survives, because a conversion is a
	// transformation and a chart that cannot show the original cannot be
	// audited against it.
	if o.RawValue != 100.4 || o.RawUnit != "F" {
		t.Fatalf("raw = %v %q, want 100.4 F", o.RawValue, o.RawUnit)
	}
}

// An unknown unit is stored as it arrived and marked un-normalised. A number
// in the wrong unit that looks right is worse than one that is visibly
// unconverted.
func TestAnUnknownUnitIsNotGuessedAt(t *testing.T) {
	o, err := domain.NewObservation("obs-2", "tenant-1", domain.NewObservationInput{
		EpisodeID: "ep-1", Code: "8310-5", Dimension: "temperature",
		Value: 311, Unit: "K", ObservedAt: at,
	}, "nurse-1", at)
	if err != nil {
		t.Fatalf("NewObservation: %v", err)
	}
	if o.Normalised {
		t.Fatal("kelvin was silently converted")
	}
	if o.Value != 311 || o.Unit != "K" {
		t.Fatalf("value = %v %q, want it stored as it arrived", o.Value, o.Unit)
	}
}

// A NaN in a flowsheet propagates into every total and every score computed
// from it, and arrives at the bedside as a blank rather than as an error.
func TestANaNIsNotAMeasurement(t *testing.T) {
	nan := func() float64 { var zero float64; return zero / zero }()
	if _, err := domain.NewObservation("obs-3", "tenant-1", domain.NewObservationInput{
		EpisodeID: "ep-1", Code: "8867-4", Dimension: "fraction",
		Value: nan, Unit: "%",
	}, "nurse-1", at); err == nil {
		t.Fatal("NaN was accepted as a measurement")
	}
}

// SRS-ICU-003. The whole point of the distinction is being able to say which
// machine, so a device reading from no device is a manual entry claiming
// otherwise.
func TestADeviceReadingNamesItsDevice(t *testing.T) {
	if _, err := domain.NewObservation("obs-4", "tenant-1", domain.NewObservationInput{
		EpisodeID: "ep-1", Code: "8867-4", Value: 88, Unit: "%",
		Source: domain.SourceDevice,
	}, "", at); err == nil {
		t.Fatal("a device reading with no device was accepted")
	}
}

// SRS-ICU-003 and SRS-ICU-009 together: a device reading starts pending and is
// invisible to a score until a named clinician confirms it.
func TestADeviceReadingIsNotChartableUntilConfirmed(t *testing.T) {
	o, err := domain.NewObservation("obs-5", "tenant-1", domain.NewObservationInput{
		EpisodeID: "ep-1", Code: "8867-4", Dimension: "fraction",
		Value: 60, Unit: "%", Source: domain.SourceDevice,
		Device: domain.DeviceSource{DeviceID: "mon-3", MeasuredAt: at},
	}, "", at)
	if err != nil {
		t.Fatalf("NewObservation: %v", err)
	}
	if o.Validation != domain.ValidationPending {
		t.Fatalf("validation = %q on a fresh device reading", o.Validation)
	}
	if o.Chartable() {
		t.Fatal("an unconfirmed device reading is chartable")
	}

	if err := o.Confirm("nurse-1", "probe repositioned, reading real", at); err != nil {
		t.Fatalf("Confirm: %v", err)
	}
	if !o.Chartable() {
		t.Fatal("a confirmed reading is not chartable")
	}
}

// A rejected artefact stays in the record. One that vanished would leave a gap
// in the trend and no sign that anybody looked.
func TestARejectedReadingStaysAndNeedsAReason(t *testing.T) {
	o, err := domain.NewObservation("obs-6", "tenant-1", domain.NewObservationInput{
		EpisodeID: "ep-1", Code: "8867-4", Dimension: "fraction",
		Value: 60, Unit: "%", Source: domain.SourceDevice,
		Device: domain.DeviceSource{DeviceID: "mon-3", MeasuredAt: at},
	}, "", at)
	if err != nil {
		t.Fatalf("NewObservation: %v", err)
	}
	if err := o.Reject("nurse-1", "", at); err == nil {
		t.Fatal("a reading was rejected with no reason")
	}
	if err := o.Reject("nurse-1", "probe off the finger", at); err != nil {
		t.Fatalf("Reject: %v", err)
	}
	if o.Chartable() {
		t.Fatal("a rejected reading is chartable")
	}
	if o.ValidationNote != "probe off the finger" {
		t.Fatalf("note = %q", o.ValidationNote)
	}
}

// SRS-ICU-012's "stale feeds are visibly marked". A feed with no clock reading
// is one nothing is coming from, and treating it as fresh is how a dashboard
// shows an hour-old blood pressure as current.
func TestAFeedWithNoClockIsStale(t *testing.T) {
	quiet := domain.DeviceSource{DeviceID: "mon-3"}
	if !quiet.Stale(at, domain.DefaultStaleAfter) {
		t.Fatal("a device with no measurement time is not stale")
	}

	fresh := domain.DeviceSource{DeviceID: "mon-3", MeasuredAt: at.Add(-30 * time.Second)}
	if fresh.Stale(at, domain.DefaultStaleAfter) {
		t.Fatal("a feed 30 seconds old is stale")
	}

	// No device at all is a manual entry, which is never stale: a nurse
	// writing a number an hour ago wrote it an hour ago on purpose.
	manual := domain.DeviceSource{}
	if manual.Stale(at, domain.DefaultStaleAfter) {
		t.Fatal("a manual entry was marked as a stale feed")
	}
}

// SRS-ICU-007. A correction is versioned, and the totals are recomputed from
// the live entries rather than adjusted in place — so a correction cannot
// leave a running total that no set of entries adds up to.
func TestAFluidBalanceRecalculatesAfterACorrection(t *testing.T) {
	entries := []domain.BalanceEntry{
		mustEntry(t, "b-1", domain.NewBalanceEntryInput{
			EpisodeID: "ep-1", Direction: domain.BalanceIntake, Route: "iv",
			Volume: 1, Unit: "L", OccurredAt: at,
		}),
		mustEntry(t, "b-2", domain.NewBalanceEntryInput{
			EpisodeID: "ep-1", Direction: domain.BalanceOutput, Route: "urine",
			Volume: 350, Unit: "mL", OccurredAt: at.Add(30 * time.Minute),
		}),
	}

	totals := domain.Totals(entries, at, at.Add(time.Hour))
	if totals.IntakeML != 1000 || totals.OutputML != 350 || totals.NetML != 650 {
		t.Fatalf("totals = %+v, want 1000 in / 350 out / 650 net", totals)
	}

	// The litre was actually 500 mL. The original entry is superseded, not
	// edited.
	entries[0].SupersededBy = "b-3"
	entries = append(entries, mustEntry(t, "b-3", domain.NewBalanceEntryInput{
		EpisodeID: "ep-1", Direction: domain.BalanceIntake, Route: "iv",
		Volume: 500, Unit: "mL", OccurredAt: at,
		Corrects: "b-1", CorrectionReason: "bag was 500 mL, not a litre",
	}))

	corrected := domain.Totals(entries, at, at.Add(time.Hour))
	if corrected.IntakeML != 500 || corrected.NetML != 150 {
		t.Fatalf("corrected totals = %+v, want 500 in / 150 net", corrected)
	}
	if corrected.Corrections != 1 {
		t.Fatalf("corrections = %d, want 1", corrected.Corrections)
	}
	// The superseded entry is still in the slice. The record keeps it.
	if len(entries) != 3 {
		t.Fatalf("%d entries, want the original kept", len(entries))
	}
}

// An unexplained correction to a fluid balance is the one a review asks about.
func TestACorrectionNeedsAReason(t *testing.T) {
	_, err := domain.NewBalanceEntry("b-4", "tenant-1", domain.NewBalanceEntryInput{
		EpisodeID: "ep-1", Direction: domain.BalanceIntake, Route: "iv",
		Volume: 500, Unit: "mL", Corrects: "b-1",
	}, "nurse-1", at)
	if err == nil {
		t.Fatal("an unexplained correction was accepted")
	}
}

func mustEntry(t *testing.T, id string, in domain.NewBalanceEntryInput) domain.BalanceEntry {
	t.Helper()
	e, err := domain.NewBalanceEntry(id, "tenant-1", in, "nurse-1", at)
	if err != nil {
		t.Fatalf("NewBalanceEntry(%s): %v", id, err)
	}
	return e
}

// SRS-ICU-005. A rate in mL/h means nothing without the concentration, and the
// commonest infusion error is a bag made up differently from the one the pump
// was programmed for.
func TestAnInfusionRecordsWhatIsInTheBag(t *testing.T) {
	_, err := domain.StartInfusion("inf-1", "tenant-1", domain.NewInfusionInput{
		EpisodeID: "ep-1", DrugCode: "noradrenaline", DoseUnit: "mcg/kg/min",
	}, "nurse-1", at)
	if err == nil {
		t.Fatal("an infusion with no concentration was accepted")
	}
}

// "Responsible user/device source retained": a rate change attributed to
// nobody is one no review can ask about.
func TestATitrationNamesANurseOrAPump(t *testing.T) {
	infusion := mustInfusion(t)

	if err := infusion.Titrate("tit-1", domain.NewTitrationInput{
		Rate: 5, RateUnit: "mL/h", Dose: 0.1,
	}, "", at); err == nil {
		t.Fatal("an unattributed rate change was accepted")
	}

	if err := infusion.Titrate("tit-1", domain.NewTitrationInput{
		Rate: 5, RateUnit: "mL/h", Dose: 0.1, EffectiveAt: at,
	}, "nurse-1", at); err != nil {
		t.Fatalf("Titrate: %v", err)
	}
	if err := infusion.Titrate("tit-2", domain.NewTitrationInput{
		Rate: 8, RateUnit: "mL/h", Dose: 0.16, EffectiveAt: at.Add(time.Hour),
		DeviceID: "pump-9",
	}, "", at.Add(time.Hour)); err != nil {
		t.Fatalf("Titrate from a pump: %v", err)
	}

	current, ok := infusion.CurrentDose()
	if !ok || current.ID != "tit-2" {
		t.Fatalf("current dose = %+v, want the later titration", current)
	}
	if len(infusion.Titrations) != 2 {
		t.Fatalf("%d titrations retained, want 2: the dose timeline is the record",
			len(infusion.Titrations))
	}
}

func mustInfusion(t *testing.T) domain.Infusion {
	t.Helper()
	infusion, err := domain.StartInfusion("inf-1", "tenant-1", domain.NewInfusionInput{
		EpisodeID: "ep-1", DrugCode: "noradrenaline", DrugDisplay: "Noradrenaline",
		ConcentrationAmount: 4, ConcentrationUnit: "mg", ConcentrationVolume: 50,
		DoseUnit: "mcg/kg/min", WeightKg: 72, StartedAt: at,
	}, "nurse-1", at)
	if err != nil {
		t.Fatalf("StartInfusion: %v", err)
	}
	return infusion
}

// SRS-ICU-006. A device inserted two days ago and never reviewed is exactly
// what "overdue review can be derived" exists for.
func TestADeviceNeverReviewedGoesOverdue(t *testing.T) {
	device, err := domain.InsertDevice("dev-1", "tenant-1", domain.NewDeviceInput{
		EpisodeID: "ep-1", Kind: "central_line", Site: "right internal jugular",
		Lumens: 3, InsertedAt: at,
	}, "doctor-1", at)
	if err != nil {
		t.Fatalf("InsertDevice: %v", err)
	}
	if device.ReviewOverdue(at.Add(12 * time.Hour)) {
		t.Fatal("a line was overdue twelve hours after insertion")
	}
	if !device.ReviewOverdue(at.Add(25 * time.Hour)) {
		t.Fatal("a line nobody reviewed in 25 hours is not overdue")
	}

	if err := device.Review("nurse-1", at.Add(25*time.Hour)); err != nil {
		t.Fatalf("Review: %v", err)
	}
	if device.ReviewOverdue(at.Add(26 * time.Hour)) {
		t.Fatal("a reviewed line is still overdue")
	}

	// A line that is out is not overdue for review, whatever the clock says.
	if err := device.Remove("doctor-1", "no longer needed", at.Add(30*time.Hour)); err != nil {
		t.Fatalf("Remove: %v", err)
	}
	if device.ReviewOverdue(at.Add(100 * time.Hour)) {
		t.Fatal("a removed line is overdue for review")
	}
}

// SRS-ICU-017. Device days are calendar days touched, which is what every
// published definition means: a line in from 23:00 to 01:00 was in on two days.
func TestDeviceDaysCountCalendarDays(t *testing.T) {
	device, err := domain.InsertDevice("dev-2", "tenant-1", domain.NewDeviceInput{
		EpisodeID: "ep-1", Kind: "central_line", Site: "left subclavian",
		InsertedAt: time.Date(2026, 9, 17, 23, 0, 0, 0, time.UTC),
	}, "doctor-1", at)
	if err != nil {
		t.Fatalf("InsertDevice: %v", err)
	}
	if err := device.Remove("doctor-1", "removed",
		time.Date(2026, 9, 18, 1, 0, 0, 0, time.UTC)); err != nil {
		t.Fatalf("Remove: %v", err)
	}

	if days := domain.DeviceDays([]domain.InvasiveDevice{device}, "central_line", at); days != 2 {
		t.Fatalf("device days = %d, want 2", days)
	}
}

// SRS-ICU-009's verification clause, made executable: the stored inputs must
// still add up to the stored total.
func TestAScoreCanBeReproducedFromItsStoredInputs(t *testing.T) {
	formula := sofaLike()
	chart := domain.ObservationList{
		mustObs(t, "o-1", "platelets", 45, ""),
		mustObs(t, "o-2", "bilirubin", 90, ""),
	}

	score, err := formula.Calculate("sc-1", "tenant-1", "ep-1", chart, "doctor-1", at)
	if err != nil {
		t.Fatalf("Calculate: %v", err)
	}
	if score.Total != 5 {
		t.Fatalf("total = %d, want 5 (platelets 3 + bilirubin 2)", score.Total)
	}

	reproduced, err := formula.Reproduce(score)
	if err != nil {
		t.Fatalf("Reproduce: %v", err)
	}
	if reproduced != score.Total {
		t.Fatalf("reproduced %d, stored %d", reproduced, score.Total)
	}
}

// A score computed under one definition and compared against one computed
// under another is a trend that is an artefact of the revision.
func TestAScoreCannotBeReproducedUnderADifferentVersion(t *testing.T) {
	formula := sofaLike()
	chart := domain.ObservationList{mustObs(t, "o-1", "platelets", 45, "")}
	score, err := formula.Calculate("sc-2", "tenant-1", "ep-1", chart, "doctor-1", at)
	if err != nil {
		t.Fatalf("Calculate: %v", err)
	}

	revised := formula
	revised.Version = "2"
	if _, err := revised.Reproduce(score); err == nil {
		t.Fatal("a score was reproduced under a formula version it was not calculated under")
	}
}

// SRS-ICU-009's "only from explicit validated inputs", and the harder half of
// it: an absent component is reported missing rather than scored as normal. A
// coagulopathy that scores zero because nobody confirmed the platelet count is
// the failure this prevents.
func TestAnUnconfirmedInputMakesTheScoreIncompleteNotLower(t *testing.T) {
	formula := sofaLike()

	pending, err := domain.NewObservation("o-3", "tenant-1", domain.NewObservationInput{
		EpisodeID: "ep-1", Code: "platelets", Value: 45,
		Source: domain.SourceDevice,
		Device: domain.DeviceSource{DeviceID: "analyser-1", MeasuredAt: at},
	}, "", at)
	if err != nil {
		t.Fatalf("NewObservation: %v", err)
	}

	chart := domain.ObservationList{pending, mustObs(t, "o-4", "bilirubin", 90, "")}
	score, err := formula.Calculate("sc-3", "tenant-1", "ep-1", chart, "doctor-1", at)
	if err != nil {
		t.Fatalf("Calculate: %v", err)
	}
	if score.Complete() {
		t.Fatal("a score with an unconfirmed input reported itself complete")
	}
	if len(score.Missing) != 1 || score.Missing[0] != "coagulation" {
		t.Fatalf("missing = %v, want the coagulation component", score.Missing)
	}
	if score.Total != 2 {
		t.Fatalf("total = %d, want only the bilirubin's 2 points", score.Total)
	}
}

func sofaLike() domain.Formula {
	return domain.Formula{
		Name: "SOFA-like", Version: "1",
		Components: []domain.Component{
			{Name: "coagulation", Code: "platelets", Points: []domain.Band{
				{AtMost: 20, HasAtMost: true, Points: 4},
				{AtMost: 50, HasAtMost: true, Points: 3},
				{AtMost: 100, HasAtMost: true, Points: 2},
				{AtMost: 150, HasAtMost: true, Points: 1},
				{AtLeast: 150, HasAtLeast: true, Points: 0},
			}},
			{Name: "liver", Code: "bilirubin", Points: []domain.Band{
				{AtLeast: 204, HasAtLeast: true, Points: 4},
				{AtLeast: 102, HasAtLeast: true, Points: 3},
				{AtLeast: 33, HasAtLeast: true, Points: 2},
				{AtLeast: 20, HasAtLeast: true, Points: 1},
				{AtMost: 20, HasAtMost: true, Points: 0},
			}},
		},
	}
}

func mustObs(t *testing.T, id, code string, value float64, unit string) domain.Observation {
	t.Helper()
	o, err := domain.NewObservation(id, "tenant-1", domain.NewObservationInput{
		EpisodeID: "ep-1", Code: code, Value: value, Unit: unit, ObservedAt: at,
	}, "nurse-1", at)
	if err != nil {
		t.Fatalf("NewObservation(%s): %v", code, err)
	}
	return o
}

// SRS-ICU-010. A bundle where everything is optional reports full compliance
// and measures nothing.
func TestABundleWithNoRequiredElementIsRefused(t *testing.T) {
	def := domain.BundleDefinition{
		Kind: domain.BundleSepsis, Version: "1",
		Items: []domain.BundleItem{{Code: "lactate", Label: "Lactate"}},
	}
	if err := def.Validate(); err == nil {
		t.Fatal("a bundle with no required element was accepted")
	}
}

// Exceptions are captured rather than counted as failures. A patient on
// therapeutic anticoagulation does not get VTE prophylaxis, and recording that
// as a failure teaches the unit to stop recording.
func TestABundleExceptionIsNeitherDoneNorMissed(t *testing.T) {
	def := domain.BundleDefinition{
		Kind: domain.BundleVTE, Version: "2",
		Items: []domain.BundleItem{
			{Code: "pharmacological", Label: "Pharmacological prophylaxis", Required: true},
			{Code: "mechanical", Label: "Mechanical prophylaxis", Required: true},
		},
	}

	if _, err := domain.PerformBundle("bp-1", "tenant-1", "ep-1", def,
		[]domain.BundleResult{{Code: "pharmacological", State: domain.ItemException}},
		"nurse-1", at); err == nil {
		t.Fatal("an exception with no reason was accepted")
	}

	run, err := domain.PerformBundle("bp-1", "tenant-1", "ep-1", def, []domain.BundleResult{
		{Code: "pharmacological", State: domain.ItemException,
			Reason: "therapeutic anticoagulation"},
		{Code: "mechanical", State: domain.ItemDone},
	}, "nurse-1", at)
	if err != nil {
		t.Fatalf("PerformBundle: %v", err)
	}

	compliance := run.Score(def)
	if compliance.Excepted != 1 || compliance.Done != 1 || compliance.Missed != 0 {
		t.Fatalf("compliance = %+v", compliance)
	}
	if !compliance.Compliant {
		t.Fatal("a bundle with a reasoned exception counted as non-compliant")
	}
}

// A bundle is a bundle because the elements work together. Four-fifths of a
// sepsis bundle is not 80% of the benefit.
func TestBundleComplianceIsAllOrNothing(t *testing.T) {
	def := domain.BundleDefinition{
		Kind: domain.BundleSepsis, Version: "1",
		Items: []domain.BundleItem{
			{Code: "lactate", Required: true},
			{Code: "cultures", Required: true},
			{Code: "antibiotics", Required: true},
		},
	}
	run, err := domain.PerformBundle("bp-2", "tenant-1", "ep-1", def, []domain.BundleResult{
		{Code: "lactate", State: domain.ItemDone},
		{Code: "cultures", State: domain.ItemDone},
		{Code: "antibiotics", State: domain.ItemNotDone},
	}, "nurse-1", at)
	if err != nil {
		t.Fatalf("PerformBundle: %v", err)
	}
	compliance := run.Score(def)
	if compliance.Compliant {
		t.Fatal("two thirds of a sepsis bundle counted as compliant")
	}
	if compliance.Missed != 1 {
		t.Fatalf("missed = %d, want 1", compliance.Missed)
	}
}

// SRS-ICU-014. The restraint interval is the short one, because a restrained
// patient is who the unit is most answerable for and an interval it drifts
// past is how a restraint becomes indefinite.
func TestARestraintIsReassessedHourly(t *testing.T) {
	assessment, err := domain.RecordAssessment("as-1", "tenant-1",
		domain.NewAssessmentInput{
			EpisodeID: "ep-1", Kind: domain.AssessmentRestraint,
			Note: "bilateral mitts, agitated", PerformedAt: at,
		}, "nurse-1", at)
	if err != nil {
		t.Fatalf("RecordAssessment: %v", err)
	}
	if !assessment.NextDueAt.Equal(at.Add(time.Hour)) {
		t.Fatalf("next due %v, want one hour after", assessment.NextDueAt)
	}
	if !assessment.Overdue(at.Add(90 * time.Minute)) {
		t.Fatal("a restraint assessment 90 minutes old is not overdue")
	}
}

// A repeated assessment resets the clock: an old one does not stay overdue
// after a newer one, and a doubled one does not make the next due sooner.
func TestOnlyTheLatestAssessmentPerKindCounts(t *testing.T) {
	first, err := domain.RecordAssessment("as-1", "tenant-1", domain.NewAssessmentInput{
		EpisodeID: "ep-1", Kind: domain.AssessmentSedation, PerformedAt: at,
	}, "nurse-1", at)
	if err != nil {
		t.Fatalf("RecordAssessment: %v", err)
	}
	second, err := domain.RecordAssessment("as-2", "tenant-1", domain.NewAssessmentInput{
		EpisodeID: "ep-1", Kind: domain.AssessmentSedation,
		PerformedAt: at.Add(3 * time.Hour),
	}, "nurse-1", at.Add(3*time.Hour))
	if err != nil {
		t.Fatalf("RecordAssessment: %v", err)
	}

	due := domain.DueAssessments([]domain.Assessment{first, second}, at.Add(5*time.Hour))
	if len(due) != 0 {
		t.Fatalf("%d overdue, want none: the later assessment reset the clock", len(due))
	}
	due = domain.DueAssessments([]domain.Assessment{first, second}, at.Add(8*time.Hour))
	if len(due) != 1 {
		t.Fatalf("%d overdue, want 1", len(due))
	}
}

// SRS-ICU-008. A goal nobody owns is the one the round reads out every morning
// and nobody does.
func TestAGoalNamesWhoIsToAchieveIt(t *testing.T) {
	if _, err := domain.NewGoal("g-1", "tenant-1", domain.NewGoalInput{
		EpisodeID: "ep-1", Text: "wean sedation", Domain: "sedation",
	}, "doctor-1", at); err == nil {
		t.Fatal("an unowned goal was accepted")
	}
}

// A goal met needs no explanation. One that was not met is the entry the next
// round has to act on.
func TestAnUnmetGoalNeedsAnOutcome(t *testing.T) {
	goal, err := domain.NewGoal("g-1", "tenant-1", domain.NewGoalInput{
		EpisodeID: "ep-1", Text: "wean sedation", OwnerRole: "nursing",
	}, "doctor-1", at)
	if err != nil {
		t.Fatalf("NewGoal: %v", err)
	}
	if err := goal.Resolve(domain.GoalNotMet, "", "nurse-1", at.Add(8*time.Hour)); err == nil {
		t.Fatal("an unmet goal was closed with no explanation")
	}
	if err := goal.Resolve(domain.GoalMet, "", "nurse-1", at.Add(8*time.Hour)); err != nil {
		t.Fatalf("Resolve met: %v", err)
	}
}

// SRS-ICU-015. "Limited" on its own is not a ceiling anybody can act on, and
// limiting treatment with no recorded reason is the entry a review asks about.
func TestACeilingOfTreatmentSaysWhatTheLimitIs(t *testing.T) {
	if _, err := domain.RecordGoalsOfCare("gc-1", "tenant-1",
		domain.NewGoalsOfCareInput{
			EpisodeID: "ep-1", Intent: domain.IntentLimited,
			Rationale: "frailty, patient's wishes", AuthorisedBy: "consultant-1",
		}, "doctor-1", at); err == nil {
		t.Fatal("a limitation with no limits was accepted")
	}

	if _, err := domain.RecordGoalsOfCare("gc-1", "tenant-1",
		domain.NewGoalsOfCareInput{
			EpisodeID: "ep-1", Intent: domain.IntentLimited,
			Limitations: []string{"no intubation"}, AuthorisedBy: "consultant-1",
		}, "doctor-1", at); err == nil {
		t.Fatal("a limitation with no rationale was accepted")
	}

	ceiling, err := domain.RecordGoalsOfCare("gc-1", "tenant-1",
		domain.NewGoalsOfCareInput{
			EpisodeID: "ep-1", Intent: domain.IntentLimited,
			Limitations: []string{"no intubation", "ward-based care"},
			CPRStatus:   "not for CPR", Rationale: "frailty; discussed with patient",
			DiscussedWith: "patient and daughter",
			AuthorisedBy:  "consultant-1", AuthorisedRole: "intensivist",
			ReviewBy: at.Add(24 * time.Hour),
		}, "doctor-1", at)
	if err != nil {
		t.Fatalf("RecordGoalsOfCare: %v", err)
	}
	if !ceiling.Current() {
		t.Fatal("a fresh ceiling is not current")
	}
	if !ceiling.ReviewOverdue(at.Add(30 * time.Hour)) {
		t.Fatal("a ceiling past its review date is not overdue")
	}
}

// A superseded ceiling is not the current one and is still the record: a
// document a coroner reads cannot have its history overwritten.
func TestTheCurrentCeilingIsTheUnsupersededOne(t *testing.T) {
	first := mustCeiling(t, "gc-1", domain.IntentFullEscalation, at)
	second := mustCeiling(t, "gc-2", domain.IntentComfort, at.Add(12*time.Hour))
	first.SupersededBy, first.SupersededAt = second.ID, second.RecordedAt

	current, ok := domain.CurrentGoalsOfCare([]domain.GoalsOfCare{first, second})
	if !ok || current.ID != "gc-2" {
		t.Fatalf("current ceiling = %+v, want gc-2", current)
	}
	if first.Current() {
		t.Fatal("a superseded ceiling still reports itself current")
	}
}

func mustCeiling(t *testing.T, id string, intent domain.CareIntent,
	when time.Time) domain.GoalsOfCare {

	t.Helper()
	g, err := domain.RecordGoalsOfCare(id, "tenant-1", domain.NewGoalsOfCareInput{
		EpisodeID: "ep-1", Intent: intent, CPRStatus: "not for CPR",
		Rationale: "agreed with the family", AuthorisedBy: "consultant-1",
	}, "doctor-1", when)
	if err != nil {
		t.Fatalf("RecordGoalsOfCare(%s): %v", id, err)
	}
	return g
}

// SRS-ICU-012 and SRS-ICU-015 together. A viewer without the permission sees
// that a ceiling exists and not what it says — the alternative, an empty
// field, reads as "no ceiling agreed", which is the difference that gets a
// patient resuscitated against their wishes.
func TestARestrictedCeilingIsMarkedNotBlank(t *testing.T) {
	e := episode(t)
	ceiling := mustCeiling(t, "gc-1", domain.IntentComfort, at)

	restricted := domain.BuildRow(domain.DashboardInput{
		Episode: e, Ceiling: &ceiling, MayReadCeiling: false,
	}, at)
	if !restricted.CeilingRestricted {
		t.Fatal("a ceiling this viewer may not read was not marked restricted")
	}
	if restricted.CareIntent != "" || restricted.CPRStatus != "" {
		t.Fatal("the ceiling leaked to a viewer without the permission")
	}

	permitted := domain.BuildRow(domain.DashboardInput{
		Episode: e, Ceiling: &ceiling, MayReadCeiling: true,
	}, at)
	if permitted.CeilingRestricted {
		t.Fatal("a permitted viewer saw a restricted marker")
	}
	if permitted.CareIntent != domain.IntentComfort ||
		permitted.CPRStatus != "not for CPR" {
		t.Fatalf("ceiling = %q / %q for a permitted viewer",
			permitted.CareIntent, permitted.CPRStatus)
	}
}

// SRS-ICU-012: every number on the board is traceable to the chart entry it
// came from, and one from a quiet feed is marked.
func TestEveryDashboardValueCarriesItsProvenance(t *testing.T) {
	e := episode(t)

	fresh, err := domain.NewObservation("o-1", "tenant-1", domain.NewObservationInput{
		EpisodeID: e.ID, Code: "heart_rate", Display: "Heart rate", Value: 96,
		Unit: "/min", Source: domain.SourceDevice,
		Device:     domain.DeviceSource{DeviceID: "mon-3", MeasuredAt: at.Add(-10 * time.Second)},
		ObservedAt: at.Add(-10 * time.Second),
	}, "", at)
	if err != nil {
		t.Fatalf("NewObservation: %v", err)
	}
	if err := fresh.Confirm("nurse-1", "", at); err != nil {
		t.Fatalf("Confirm: %v", err)
	}

	quiet, err := domain.NewObservation("o-2", "tenant-1", domain.NewObservationInput{
		EpisodeID: e.ID, Code: "systolic", Display: "Systolic", Value: 104,
		Unit: "mm[Hg]", Source: domain.SourceDevice,
		Device:     domain.DeviceSource{DeviceID: "mon-4", MeasuredAt: at.Add(-time.Hour)},
		ObservedAt: at.Add(-time.Hour),
	}, "", at)
	if err != nil {
		t.Fatalf("NewObservation: %v", err)
	}
	if err := quiet.Confirm("nurse-1", "", at); err != nil {
		t.Fatalf("Confirm: %v", err)
	}

	row := domain.BuildRow(domain.DashboardInput{
		Episode: e, Chart: domain.ObservationList{fresh, quiet},
		VitalCodes: []string{"heart_rate", "systolic"},
	}, at)

	if len(row.Vitals) != 2 {
		t.Fatalf("%d vitals on the row, want 2", len(row.Vitals))
	}
	for _, vital := range row.Vitals {
		if vital.ObservationID == "" {
			t.Fatalf("%s has no observation to open", vital.Code)
		}
	}
	if row.StaleFeeds != 1 {
		t.Fatalf("stale feeds = %d, want 1", row.StaleFeeds)
	}
	for _, vital := range row.Vitals {
		if vital.Code == "systolic" && !vital.Stale {
			t.Fatal("an hour-old blood pressure is shown as current")
		}
		if vital.Code == "heart_rate" && vital.Stale {
			t.Fatal("a ten-second-old heart rate is marked stale")
		}
	}
}

// SRS-ICU-013. The alarms this system raises are operational conditions it is
// entitled to have an opinion about, they are derived rather than stored so a
// resolved condition stops appearing, and nothing here reaches a bedside
// device.
func TestOperationalAlarmsAreDerivedAndResolveThemselves(t *testing.T) {
	e := episode(t)
	device, err := domain.InsertDevice("dev-1", "tenant-1", domain.NewDeviceInput{
		EpisodeID: e.ID, Kind: "central_line", Site: "right internal jugular",
		InsertedAt: at,
	}, "doctor-1", at)
	if err != nil {
		t.Fatalf("InsertDevice: %v", err)
	}

	later := at.Add(30 * time.Hour)
	alarms := domain.OperationalAlarms(e, []domain.InvasiveDevice{device}, nil, nil, 0, later)
	if len(alarms) != 1 || alarms[0].Kind != "device_review_overdue" {
		t.Fatalf("alarms = %+v, want one overdue device review", alarms)
	}

	// Taking the line out resolves the condition. Nobody clears an alarm.
	if err := device.Remove("doctor-1", "no longer needed", later); err != nil {
		t.Fatalf("Remove: %v", err)
	}
	if alarms := domain.OperationalAlarms(e, []domain.InvasiveDevice{device},
		nil, nil, 0, later.Add(time.Hour)); len(alarms) != 0 {
		t.Fatalf("alarms = %+v after the line came out", alarms)
	}
}

// A ventilator record is read against the gas taken at the time. The question
// at review is what the machine was doing then, not what it is doing now.
func TestVentilatorSettingsAreReadAtAnInstant(t *testing.T) {
	first, err := domain.RecordVentSetting("v-1", "tenant-1", domain.NewVentSettingInput{
		EpisodeID: "ep-1", Mode: "PRVC",
		Parameters:  map[string]float64{"fio2": 60, "peep": 8},
		EffectiveAt: at,
	}, "nurse-1", at)
	if err != nil {
		t.Fatalf("RecordVentSetting: %v", err)
	}
	second, err := domain.RecordVentSetting("v-2", "tenant-1", domain.NewVentSettingInput{
		EpisodeID: "ep-1", Mode: "PSV",
		Parameters:  map[string]float64{"fio2": 40, "peep": 5},
		EffectiveAt: at.Add(6 * time.Hour), ChangeReason: "weaning",
	}, "nurse-1", at.Add(6*time.Hour))
	if err != nil {
		t.Fatalf("RecordVentSetting: %v", err)
	}

	timeline := domain.VentTimeline{first, second}
	atGas, ok := timeline.At(at.Add(2 * time.Hour))
	if !ok || atGas.Mode != "PRVC" {
		t.Fatalf("settings at the gas = %+v, want the PRVC record", atGas)
	}
	if atGas.Parameters["fio2"] != 60 {
		t.Fatalf("FiO2 = %v, want 60", atGas.Parameters["fio2"])
	}

	// Before any record there is nothing, rather than the earliest one: a
	// ventilator's settings before it was connected are not a fact.
	if _, ok := timeline.At(at.Add(-time.Hour)); ok {
		t.Fatal("settings were reported for a time before any were recorded")
	}
}

// SRS-ICU-017. Ventilator days are counted the same way as device days.
func TestSupportDaysCountCalendarDays(t *testing.T) {
	run, err := domain.StartSupport("sup-1", "tenant-1", domain.NewSupportInput{
		EpisodeID: "ep-1", Kind: domain.SupportVentilation, Modality: "invasive",
		StartedAt: time.Date(2026, 9, 17, 22, 0, 0, 0, time.UTC),
	}, "doctor-1", at)
	if err != nil {
		t.Fatalf("StartSupport: %v", err)
	}
	if err := run.Stop("doctor-1", "extubated",
		time.Date(2026, 9, 19, 9, 0, 0, 0, time.UTC)); err != nil {
		t.Fatalf("Stop: %v", err)
	}

	days := domain.SupportDays([]domain.Support{run}, domain.SupportVentilation, at)
	if days != 3 {
		t.Fatalf("ventilator days = %d, want 3", days)
	}
	if run.Active() {
		t.Fatal("a stopped run reports itself active")
	}
}
