package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/clinical/domain"
)

func devAt(hour, minute int) time.Time {
	return time.Date(2026, time.September, 17, hour, minute, 0, 0, time.UTC)
}

func reading(t *testing.T, source domain.SourceKind) domain.Observation {
	t.Helper()
	in := domain.NewObservationInput{
		PatientID: "p1", EncounterID: "e1",
		Code:           domain.Coding{System: "http://loinc.org", Code: "59408-5", Display: "SpO2"},
		Value:          domain.Quantity{Value: 60, Unit: "%"},
		Interpretation: domain.InterpretationUnknown,
		Status:         domain.ObservationFinal,
		EffectiveAt:    devAt(9, 0),
		Source:         source,
	}
	if source == domain.SourceDevice {
		in.Device = domain.DeviceSource{
			DeviceID: "monitor-7", Channel: "SpO2", Quality: "searching",
			ObservedAt: devAt(9, 0), ReceivedAt: devAt(9, 0),
		}
	}
	observation, err := domain.NewObservation("o1", "t1", in, "nurse-1", devAt(9, 0))
	if err != nil {
		t.Fatalf("NewObservation: %v", err)
	}
	return observation
}

func TestADeviceReadingStartsUnvalidated(t *testing.T) {
	// The rule the whole file exists for. A saturation probe off a finger
	// reads 60%, and a chart that absorbed that as fact would carry it into
	// every trend and every score.
	observation := reading(t, domain.SourceDevice)
	if observation.Validation != domain.ValidationPending {
		t.Fatalf("validation %q, want pending", observation.Validation)
	}
	if observation.Validated() {
		t.Fatal("a fresh device reading reported itself validated")
	}
	if !observation.Provisional() {
		t.Fatal("a fresh device reading is not provisional")
	}
}

func TestATypedMeasurementNeedsNoConfirmation(t *testing.T) {
	// The human was the instrument. Asking a nurse to confirm what they just
	// typed teaches them to confirm without reading.
	observation := reading(t, domain.SourceManual)
	if observation.Validation != domain.ValidationNotRequired {
		t.Fatalf("validation %q, want not_required", observation.Validation)
	}
	if !observation.Validated() {
		t.Fatal("a typed measurement is not validated")
	}
}

func TestAnObservationWithNoStatedSourceIsTreatedAsTyped(t *testing.T) {
	// Every path written before this field existed passes nothing, and every
	// one of them is a person at a keyboard. Defaulting the other way would
	// make the entire Wave-1 chart provisional overnight.
	in := domain.NewObservationInput{
		PatientID: "p1", EncounterID: "e1",
		Code:           domain.Coding{System: "s", Code: "c", Display: "d"},
		Interpretation: domain.InterpretationUnknown,
		Status:         domain.ObservationFinal,
	}
	observation, err := domain.NewObservation("o1", "t1", in, "nurse-1", devAt(9, 0))
	if err != nil {
		t.Fatalf("NewObservation: %v", err)
	}
	if observation.Source != domain.SourceManual || !observation.Validated() {
		t.Fatalf("source %q validation %q", observation.Source, observation.Validation)
	}
}

func TestADeviceReadingMustNameItsDevice(t *testing.T) {
	// A run of implausible values almost always means one device, and a
	// reading that cannot name its own is one nobody can trace to the probe.
	in := domain.NewObservationInput{
		PatientID: "p1", EncounterID: "e1",
		Code:           domain.Coding{System: "s", Code: "c", Display: "d"},
		Interpretation: domain.InterpretationUnknown,
		Status:         domain.ObservationFinal,
		Source:         domain.SourceDevice,
	}
	if _, err := domain.NewObservation("o1", "t1", in, "nurse-1", devAt(9, 0)); err == nil {
		t.Fatal("a device reading with no device was accepted")
	}
}

func TestOnlyANamedClinicianTurnsAReadingIntoAChartValue(t *testing.T) {
	observation := reading(t, domain.SourceDevice)

	if err := observation.Confirm("  ", devAt(9, 5)); !errors.Is(err, domain.ErrInvalidDocument) {
		t.Fatal("an anonymous confirmation was accepted")
	}
	if err := observation.Confirm("doctor-1", devAt(9, 5)); err != nil {
		t.Fatalf("confirm: %v", err)
	}
	if !observation.Validated() {
		t.Fatal("a confirmed reading is not validated")
	}
	if observation.ValidatedBy != "doctor-1" {
		t.Fatalf("confirmed by %q", observation.ValidatedBy)
	}
	if observation.Provisional() {
		t.Fatal("a confirmed reading is still provisional")
	}
}

func TestRejectingAReadingNeedsAReasonAndKeepsIt(t *testing.T) {
	// "Artefact" with no reason cannot be told from a mis-click, and the
	// reasons are how a failing probe gets found.
	observation := reading(t, domain.SourceDevice)
	if err := observation.Reject("nurse-1", "", devAt(9, 5)); err == nil {
		t.Fatal("a reading was rejected with no reason")
	}
	if err := observation.Reject("nurse-1", "probe off the finger", devAt(9, 5)); err != nil {
		t.Fatalf("reject: %v", err)
	}
	if observation.Validated() {
		t.Fatal("a rejected reading counts as validated")
	}
	if observation.ValidationNote != "probe off the finger" {
		t.Fatalf("the reason was not kept: %q", observation.ValidationNote)
	}
}

func TestARejectedReadingIsNotConfirmedLater(t *testing.T) {
	// A clinician who changes their mind records the reading again, so the
	// chart shows both decisions and when each was made rather than only the
	// last.
	observation := reading(t, domain.SourceDevice)
	if err := observation.Reject("nurse-1", "line being flushed", devAt(9, 5)); err != nil {
		t.Fatalf("reject: %v", err)
	}
	if err := observation.Confirm("doctor-1", devAt(9, 10)); err == nil {
		t.Fatal("a rejected reading was confirmed")
	}
}

func TestAConfirmedReadingIsNotRejectedLater(t *testing.T) {
	observation := reading(t, domain.SourceDevice)
	if err := observation.Confirm("doctor-1", devAt(9, 5)); err != nil {
		t.Fatalf("confirm: %v", err)
	}
	if err := observation.Reject("nurse-1", "changed my mind", devAt(9, 10)); err == nil {
		t.Fatal("a confirmed chart value was rejected rather than amended")
	}
}

func TestATypedValueIsNotConfirmedOrRejected(t *testing.T) {
	// Both are device operations. A typed value is corrected by amendment,
	// which keeps the original visible.
	observation := reading(t, domain.SourceManual)
	if err := observation.Confirm("doctor-1", devAt(9, 5)); err == nil {
		t.Fatal("a typed value was confirmed")
	}
	if err := observation.Reject("doctor-1", "wrong", devAt(9, 5)); err == nil {
		t.Fatal("a typed value was rejected rather than amended")
	}
}

func TestConfirmingTwiceKeepsTheFirstRecord(t *testing.T) {
	observation := reading(t, domain.SourceDevice)
	if err := observation.Confirm("doctor-1", devAt(9, 5)); err != nil {
		t.Fatalf("confirm: %v", err)
	}
	if err := observation.Confirm("doctor-2", devAt(9, 6)); err != nil {
		t.Fatalf("second confirm errored: %v", err)
	}
	if observation.ValidatedBy != "doctor-1" || !observation.ValidatedAt.Equal(devAt(9, 5)) {
		t.Fatalf("the second confirmation overwrote the first: %q at %v",
			observation.ValidatedBy, observation.ValidatedAt)
	}
}

func TestOnlyValidatedInputsReachAScore(t *testing.T) {
	// SRS-ICU-009: "calculate configured ICU scores only from explicit
	// validated inputs". A function rather than a convention, because that is
	// the kind of rule followed everywhere until the one place somebody
	// reaches for the raw list.
	typed := reading(t, domain.SourceManual)
	typed.ID = "typed"

	confirmed := reading(t, domain.SourceDevice)
	confirmed.ID = "confirmed"
	if err := confirmed.Confirm("doctor-1", devAt(9, 5)); err != nil {
		t.Fatalf("confirm: %v", err)
	}

	pending := reading(t, domain.SourceDevice)
	pending.ID = "pending"

	rejected := reading(t, domain.SourceDevice)
	rejected.ID = "rejected"
	if err := rejected.Reject("nurse-1", "probe off", devAt(9, 5)); err != nil {
		t.Fatalf("reject: %v", err)
	}

	cancelled := reading(t, domain.SourceManual)
	cancelled.ID = "cancelled"
	cancelled.Status = domain.ObservationEnteredInError

	inputs := domain.ObservationList{typed, confirmed, pending, rejected, cancelled}.
		ValidatedInputs()

	var ids []string
	for _, observation := range inputs {
		ids = append(ids, observation.ID)
	}
	if len(ids) != 2 || ids[0] != "typed" || ids[1] != "confirmed" {
		t.Fatalf("a score would be computed from %v", ids)
	}
}

func TestAnUnclassifiableSourceIsNotTrusted(t *testing.T) {
	// A stored value this build cannot classify is treated as unvalidated.
	// The dangerous direction is the other one: a reading nobody can attribute
	// feeding a score.
	if domain.KnownSourceKind("telepathy") {
		t.Fatal("an unknown source kind was accepted")
	}
	if domain.DefaultValidationFor(domain.SourceUnknown) != domain.ValidationPending {
		t.Fatal("an unknown source defaults to validated")
	}
	if domain.KnownValidation("probably_fine") {
		t.Fatal("an unknown validation state was accepted")
	}
}

func TestASilentFeedIsStaleIncludingOneWeHaveNeverHeardFrom(t *testing.T) {
	// SRS-ICU-012 asks for stale feeds to be visibly marked. A bedside monitor
	// reports every few seconds, so two minutes of silence is a disconnected
	// cable rather than a quiet patient.
	last := devAt(9, 0)
	if domain.FeedStale(last, devAt(9, 1), 0) {
		t.Fatal("a feed one minute old was called stale")
	}
	if !domain.FeedStale(last, devAt(9, 3), 0) {
		t.Fatal("a feed three minutes old was called fresh")
	}
	// "We have never heard from it" and "we have not heard lately" are the
	// same thing to a clinician deciding whether to believe a number, and the
	// dangerous reading of a zero timestamp is "fresh".
	if !domain.FeedStale(time.Time{}, devAt(9, 0), 0) {
		t.Fatal("a feed that has never reported was called fresh")
	}
}

func TestTheLagBetweenReadingAndArrivalIsKnowable(t *testing.T) {
	source := domain.DeviceSource{
		DeviceID: "monitor-7", ObservedAt: devAt(9, 0), ReceivedAt: devAt(9, 2),
	}
	lag, ok := source.Lag()
	if !ok || lag != 2*time.Minute {
		t.Fatalf("lag %v (known=%v), want two minutes", lag, ok)
	}
	if _, ok := (domain.DeviceSource{DeviceID: "m"}).Lag(); ok {
		t.Fatal("a reading with no timestamps reported a knowable lag")
	}
}
