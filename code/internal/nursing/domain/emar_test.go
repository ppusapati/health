package domain_test

import (
	"errors"
	"testing"

	"github.com/ppusapati/health/code/internal/nursing/domain"
)

func paracetamol() domain.Coding {
	return domain.Coding{
		System: "http://snomed.info/sct", Version: "2024-03",
		Code: "387517004", Display: "Paracetamol",
	}
}

func verifiedOrder() domain.MedicationOrder {
	return domain.MedicationOrder{
		OrderID: "order-1", PatientID: "patient-1", EncounterID: "encounter-1",
		Medication: paracetamol(),
		Dose:       domain.Quantity{Value: 1000, Unit: "mg"},
		Route:      "oral", Frequency: "qds",
		Status: domain.OrderActive, Verified: true,
		VerifiedBy: "pharmacist-1", VerifiedAt: at(7, 0),
		StartsAt: at(8, 0),
	}
}

func goodScan() domain.Verification {
	return domain.Verification{
		Performed: true, PatientScanned: "patient-1",
		MedicationScanned: "387517004", ScannedAt: at(9, 0),
	}
}

func giveDose(t *testing.T, order domain.MedicationOrder,
	scan domain.Verification, override string) (*domain.Administration, error) {

	t.Helper()
	return domain.NewAdministration("admin-1", "tenant-1",
		domain.NewAdministrationInput{
			Order: order, ScheduledAt: at(9, 0),
			GivenDose: domain.Quantity{Value: 1000, Unit: "mg"},
			GivenAt:   at(9, 5), Route: "oral",
			Outcome: domain.Administered, Verification: scan,
			OverrideReason: override,
		}, domain.DefaultAdministrationPolicy(), "nurse-1", at(9, 6))
}

// SRS-NUR-007: only active, pharmacist-verified orders produce doses.
func TestAnUnverifiedOrderProducesNoAdministrationTask(t *testing.T) {
	order := verifiedOrder()
	order.Verified = false

	if order.Administrable(at(9, 0)) {
		t.Fatal("an unverified order is administrable")
	}
	if _, err := giveDose(t, order, goodScan(), ""); !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("a dose was given against an unverified order: %v", err)
	}
}

func TestAHeldOrderProducesNoAdministrationTask(t *testing.T) {
	order := verifiedOrder()
	order.Status = domain.OrderHeld
	if order.Administrable(at(9, 0)) {
		t.Fatal("a held order is administrable")
	}
}

// An order that has not started or has finished produces nothing either.
func TestAnOrderOutsideItsDatesProducesNoTask(t *testing.T) {
	order := verifiedOrder()
	order.StartsAt = at(12, 0)
	if order.Administrable(at(9, 0)) {
		t.Fatal("an order that has not started yet is administrable")
	}

	order = verifiedOrder()
	order.EndsAt = at(8, 30)
	if order.Administrable(at(9, 0)) {
		t.Fatal("a finished order is administrable")
	}
}

// SRS-NUR-009: the MAR retains scheduled versus actual.
func TestTheMARKeepsTheScheduledDoseAsWellAsTheOneGiven(t *testing.T) {
	admin, err := domain.NewAdministration("admin-1", "tenant-1",
		domain.NewAdministrationInput{
			Order: verifiedOrder(), ScheduledAt: at(9, 0),
			GivenDose: domain.Quantity{Value: 500, Unit: "mg"},
			GivenAt:   at(11, 30), Route: "oral",
			Outcome: domain.Administered, Verification: goodScan(),
		}, domain.DefaultAdministrationPolicy(), "nurse-1", at(11, 31))
	if err != nil {
		t.Fatalf("NewAdministration: %v", err)
	}

	if admin.ScheduledDose.Value != 1000 {
		t.Fatalf("the scheduled dose was overwritten: %v", admin.ScheduledDose)
	}
	if admin.GivenDose.Value != 500 {
		t.Fatalf("the dose given is %v, want 500", admin.GivenDose)
	}
	if !admin.ScheduledAt.Equal(at(9, 0)) || !admin.GivenAt.Equal(at(11, 30)) {
		t.Fatal("the scheduled and actual times are not both retained")
	}
	// Without both, "was it late" is unanswerable.
	if !admin.Late(domain.DefaultAdministrationPolicy()) {
		t.Fatal("a dose given two and a half hours late is not reported late")
	}
	variance, ok := admin.Variance()
	if !ok || variance != -500 {
		t.Fatalf("variance is %v (ok=%v), want -500", variance, ok)
	}
}

// Two different units is a question, not a variance.
func TestAVarianceAcrossUnitsIsNotReported(t *testing.T) {
	admin, err := domain.NewAdministration("admin-1", "tenant-1",
		domain.NewAdministrationInput{
			Order: verifiedOrder(), ScheduledAt: at(9, 0),
			GivenDose: domain.Quantity{Value: 1, Unit: "g"},
			GivenAt:   at(9, 5), Route: "oral",
			Outcome: domain.Administered, Verification: goodScan(),
		}, domain.DefaultAdministrationPolicy(), "nurse-1", at(9, 6))
	if err != nil {
		t.Fatalf("NewAdministration: %v", err)
	}
	if _, ok := admin.Variance(); ok {
		t.Fatal("a variance was computed across two different units")
	}
}

// SRS-NUR-008: a mismatch prevents completion.
func TestAWrongWristbandStopsTheAdministration(t *testing.T) {
	scan := goodScan()
	scan.PatientScanned = "patient-2"

	_, err := giveDose(t, verifiedOrder(), scan, "")
	var failure domain.ErrVerificationFailed
	if !errors.As(err, &failure) {
		t.Fatalf("a wrong wristband was accepted: %v", err)
	}
	if !failure.PatientMismatch {
		t.Fatal("the refusal does not say the patient did not match")
	}
	if failure.MedicationMismatch {
		t.Fatal("the refusal claims the medication did not match, and it did")
	}
	// The nurse is told there is a way forward rather than discovering it by
	// trying.
	if !failure.Overridable {
		t.Fatal("the refusal does not say an override is possible")
	}
}

func TestTheWrongProductStopsTheAdministration(t *testing.T) {
	scan := goodScan()
	scan.MedicationScanned = "123456"

	_, err := giveDose(t, verifiedOrder(), scan, "")
	var failure domain.ErrVerificationFailed
	if !errors.As(err, &failure) {
		t.Fatalf("the wrong product was accepted: %v", err)
	}
	if !failure.MedicationMismatch || failure.PatientMismatch {
		t.Fatalf("the refusal misdescribes what failed: %+v", failure)
	}
}

// Not scanning at all is a failure of the check, not an absence of it.
func TestNotScanningIsItselfAFailedCheck(t *testing.T) {
	_, err := giveDose(t, verifiedOrder(), domain.Verification{}, "")
	var failure domain.ErrVerificationFailed
	if !errors.As(err, &failure) {
		t.Fatalf("an unscanned administration was accepted: %v", err)
	}
	if !failure.NotScanned {
		t.Fatal("the refusal does not say nothing was scanned")
	}
}

// SRS-NUR-008: an override is allowed, documented, and stored.
func TestAnOverrideIsStoredWithWhatItOverrode(t *testing.T) {
	scan := goodScan()
	scan.MedicationScanned = "123456"

	admin, err := giveDose(t, verifiedOrder(), scan,
		"pharmacy relabelled the pack; checked against the chart with the ward pharmacist")
	if err != nil {
		t.Fatalf("a documented override was refused: %v", err)
	}
	if admin.Override == nil {
		t.Fatal("the override was not recorded on the administration")
	}
	if !admin.Override.MedicationMismatch {
		t.Fatal("the stored override does not say what failed")
	}
	if admin.Override.PatientMismatch {
		t.Fatal("the stored override claims the patient failed, and it did not")
	}
	// Captured at the time: the pack gets relabelled, the report must still
	// show what the nurse was looking at.
	if admin.Override.By != "nurse-1" {
		t.Fatalf("the override names %q", admin.Override.By)
	}
}

func TestAnOverrideNeedsASubstantiveReason(t *testing.T) {
	scan := goodScan()
	scan.PatientScanned = "patient-2"

	if _, err := giveDose(t, verifiedOrder(), scan, "urgent"); !errors.Is(
		err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a one-word override reason was accepted: %v", err)
	}
}

// A facility that turns overrides off has decided a mismatch is never given
// through, and the system must be able to hold that.
func TestAFacilityCanRefuseOverridesEntirely(t *testing.T) {
	policy := domain.DefaultAdministrationPolicy()
	policy.OverrideAllowed = false

	scan := goodScan()
	scan.PatientScanned = "patient-2"

	_, err := domain.NewAdministration("admin-1", "tenant-1",
		domain.NewAdministrationInput{
			Order: verifiedOrder(), ScheduledAt: at(9, 0),
			GivenDose: domain.Quantity{Value: 1000, Unit: "mg"},
			GivenAt:   at(9, 5), Route: "oral",
			Outcome: domain.Administered, Verification: scan,
			OverrideReason: "the scanner on this trolley has been broken all week",
		}, policy, "nurse-1", at(9, 6))
	if !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("an override was accepted where policy forbids it: %v", err)
	}
}

// A ward with no scanners turns the check off deliberately; the requirement
// says "where barcode workflow enabled".
func TestAWardWithoutScannersCanStillGiveMedication(t *testing.T) {
	policy := domain.DefaultAdministrationPolicy()
	policy.BarcodeRequired = false

	if _, err := domain.NewAdministration("admin-1", "tenant-1",
		domain.NewAdministrationInput{
			Order: verifiedOrder(), ScheduledAt: at(9, 0),
			GivenDose: domain.Quantity{Value: 1000, Unit: "mg"},
			GivenAt:   at(9, 5), Route: "oral",
			Outcome: domain.Administered,
		}, policy, "nurse-1", at(9, 6)); err != nil {
		t.Fatalf("a ward without scanners cannot chart a dose: %v", err)
	}
}

// Refusing to let a nurse record that a patient refused their tablet because
// the scanner is broken would push the record off the system.
func TestARefusalNeedsNoBarcodeButNeedsAReason(t *testing.T) {
	if _, err := domain.NewAdministration("admin-1", "tenant-1",
		domain.NewAdministrationInput{
			Order: verifiedOrder(), ScheduledAt: at(9, 0),
			Outcome: domain.Refused,
			Reason:  "patient declined; nauseated",
		}, domain.DefaultAdministrationPolicy(), "nurse-1", at(9, 6)); err != nil {
		t.Fatalf("a refusal was blocked by the barcode check: %v", err)
	}

	_, err := domain.NewAdministration("admin-1", "tenant-1",
		domain.NewAdministrationInput{
			Order: verifiedOrder(), ScheduledAt: at(9, 0),
			Outcome: domain.Refused,
		}, domain.DefaultAdministrationPolicy(), "nurse-1", at(9, 6))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a refusal with no reason was accepted: %v", err)
	}
}

// Holding is a clinical judgement somebody is answerable for; not-administered
// is a supply or order fact. They are counted differently.
func TestHoldingAndNotGivingAreDifferentFacts(t *testing.T) {
	for _, outcome := range []domain.AdministrationOutcome{
		domain.Held, domain.NotAdministered,
	} {
		if _, err := domain.NewAdministration("admin-1", "tenant-1",
			domain.NewAdministrationInput{
				Order: verifiedOrder(), ScheduledAt: at(9, 0),
				Outcome: outcome, Reason: "systolic 84",
			}, domain.DefaultAdministrationPolicy(), "nurse-1", at(9, 6)); err != nil {
			t.Fatalf("%s was refused: %v", outcome, err)
		}
	}
}

// A dose given intravenously that was ordered orally is a class of error the
// route field exists to make visible.
func TestADoseThatWasGivenNeedsItsRoute(t *testing.T) {
	_, err := domain.NewAdministration("admin-1", "tenant-1",
		domain.NewAdministrationInput{
			Order: verifiedOrder(), ScheduledAt: at(9, 0),
			GivenDose: domain.Quantity{Value: 1000, Unit: "mg"},
			GivenAt:   at(9, 5),
			Outcome:   domain.Administered, Verification: goodScan(),
		}, domain.DefaultAdministrationPolicy(), "nurse-1", at(9, 6))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a dose with no route was accepted: %v", err)
	}
}

// SRS-NUR-018: the key that identifies a dose is the dose, not the submission.
func TestTheScheduledDoseKeyIsTheOrderAndTheScheduledTime(t *testing.T) {
	first, err := giveDose(t, verifiedOrder(), goodScan(), "")
	if err != nil {
		t.Fatalf("NewAdministration: %v", err)
	}
	// A second transcription of the same paper entry, by a different nurse,
	// with a different identifier and a slightly different given time.
	second, err := domain.NewAdministration("admin-2", "tenant-1",
		domain.NewAdministrationInput{
			Order: verifiedOrder(), ScheduledAt: at(9, 0),
			GivenDose: domain.Quantity{Value: 1000, Unit: "mg"},
			GivenAt:   at(9, 7), Route: "oral",
			Outcome: domain.Administered, Verification: goodScan(),
			Offline: true,
		}, domain.DefaultAdministrationPolicy(), "nurse-2", at(14, 0))
	if err != nil {
		t.Fatalf("NewAdministration: %v", err)
	}

	firstKey, ok := first.ScheduledDoseKey()
	if !ok {
		t.Fatal("a scheduled dose has no key")
	}
	secondKey, ok := second.ScheduledDoseKey()
	if !ok {
		t.Fatal("a scheduled dose has no key")
	}
	if firstKey != secondKey {
		t.Fatalf("two transcriptions of one dose produced different keys: %q and %q",
			firstKey, secondKey)
	}
}

// A PRN dose has no scheduled time and therefore no key.
func TestAPRNDoseHasNoScheduledDoseKey(t *testing.T) {
	order := verifiedOrder()
	order.PRN = true

	admin, err := domain.NewAdministration("admin-1", "tenant-1",
		domain.NewAdministrationInput{
			Order:     order,
			GivenDose: domain.Quantity{Value: 1000, Unit: "mg"},
			GivenAt:   at(9, 5), Route: "oral",
			Outcome: domain.Administered, Verification: goodScan(),
		}, domain.DefaultAdministrationPolicy(), "nurse-1", at(9, 6))
	if err != nil {
		t.Fatalf("NewAdministration: %v", err)
	}
	if _, ok := admin.ScheduledDoseKey(); ok {
		t.Fatal("a PRN dose produced a scheduled-dose key")
	}
}

// A dose given during downtime is marked as such, because a record
// reconstructed from paper hours later is weaker evidence.
func TestAnOfflineDoseIsVisibleAsOffline(t *testing.T) {
	admin, err := domain.NewAdministration("admin-1", "tenant-1",
		domain.NewAdministrationInput{
			Order: verifiedOrder(), ScheduledAt: at(9, 0),
			GivenDose: domain.Quantity{Value: 1000, Unit: "mg"},
			GivenAt:   at(9, 5), Route: "oral",
			Outcome: domain.Administered, Verification: goodScan(),
			Offline: true,
		}, domain.DefaultAdministrationPolicy(), "nurse-1", at(14, 0))
	if err != nil {
		t.Fatalf("NewAdministration: %v", err)
	}
	if !admin.RecordedOffline {
		t.Fatal("a dose transcribed from the paper chart is not marked offline")
	}
}

// A round that does not show what has been given invites the dose being given
// twice.
func TestTheRoundShowsWhatIsStillOutstanding(t *testing.T) {
	given, err := giveDose(t, verifiedOrder(), goodScan(), "")
	if err != nil {
		t.Fatalf("NewAdministration: %v", err)
	}

	done := domain.DueDose{Order: verifiedOrder(), ScheduledAt: at(9, 0), Given: given}
	waiting := domain.DueDose{Order: verifiedOrder(), ScheduledAt: at(13, 0)}

	if done.Outstanding() {
		t.Fatal("a dose that has been given shows as outstanding")
	}
	if !waiting.Outstanding() {
		t.Fatal("a dose that has not been given shows as done")
	}
	if !waiting.Overdue(domain.DefaultAdministrationPolicy(), at(15, 0)) {
		t.Fatal("a dose two hours past its window is not overdue")
	}
	if done.Overdue(domain.DefaultAdministrationPolicy(), at(15, 0)) {
		t.Fatal("a dose that was given shows as overdue")
	}
}

// A safety control that has to be switched on is a control that is off in the
// wards that most need it.
func TestTheBarcodeCheckIsOnByDefault(t *testing.T) {
	if !domain.DefaultAdministrationPolicy().BarcodeRequired {
		t.Fatal("the default policy does not require the barcode check")
	}
}
