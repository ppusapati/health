package domain_test

import (
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/billing/domain"
)

func maternityPackage() domain.Package {
	return domain.Package{
		Code: "MAT-NORMAL", Name: "Normal delivery package",
		Price: inr(4500000),
		Inclusions: []domain.PackageInclusion{
			{ServiceCode: "BED-GEN", Quantity: 3},
			{ServiceCode: "CONS-OB"},
			{ServiceCode: "USG-OB", Quantity: 2},
		},
		Exclusions: []string{"NICU-DAY"},
		CarveOuts: []domain.PackageCarveOut{{
			ServiceCode: "BLOOD-UNIT", Price: inr(150000),
			Note: "at the blood bank's issue price",
		}},
		EffectiveFrom: day(2026, time.January, 1),
	}
}

func packagedCharge(t *testing.T, code, description string, quantity int32) *domain.Charge {
	t.Helper()
	in := chargeInput(service(code, description, 1800, false), quantity)
	in.Source = domain.SourceReference{System: "orders", ID: code + "-1"}
	return newCharge(t, in)
}

// SRS-BIL-004: the ledger explains billed and not-billed items alike.
func TestAnIncludedServiceIsAbsorbedAndSaysSo(t *testing.T) {
	p := maternityPackage()
	charge := packagedCharge(t, "CONS-OB", "Obstetric consultation", 1)

	entry, billed := p.Apply(domain.NewPackageState(nil), charge, day(2026, time.March, 3))
	if billed {
		t.Fatal("an included service was billed")
	}
	if entry.Outcome != domain.CoverageIncluded {
		t.Fatalf("outcome = %q", entry.Outcome)
	}
	if !strings.Contains(entry.Explanation, "Normal delivery package") {
		t.Fatalf("the explanation does not name the package: %q", entry.Explanation)
	}
}

// SRS-BIL-004: a cap bills the excess, not the whole line, and the explanation
// says how many were used.
func TestAQuantityCapBillsTheExcessAndSaysWhy(t *testing.T) {
	p := maternityPackage()

	ledger := []domain.Consumption{
		{ServiceCode: "BED-GEN", Quantity: 3, Outcome: domain.CoverageIncluded},
	}
	fourth := packagedCharge(t, "BED-GEN", "General ward bed day", 1)

	entry, billed := p.Apply(domain.NewPackageState(ledger), fourth,
		day(2026, time.March, 6))
	if !billed {
		t.Fatal("the fourth bed day was absorbed despite a cap of three")
	}
	if entry.Outcome != domain.CoverageOverCap {
		t.Fatalf("outcome = %q", entry.Outcome)
	}
	for _, want := range []string{"covers 3", "3 already used"} {
		if !strings.Contains(entry.Explanation, want) {
			t.Errorf("the explanation is missing %q: %q", want, entry.Explanation)
		}
	}
}

// Within the cap, nothing is billed and the running count is shown.
func TestWithinTheCapNothingIsBilled(t *testing.T) {
	p := maternityPackage()
	ledger := []domain.Consumption{
		{ServiceCode: "BED-GEN", Quantity: 1, Outcome: domain.CoverageIncluded},
	}
	second := packagedCharge(t, "BED-GEN", "General ward bed day", 1)

	entry, billed := p.Apply(domain.NewPackageState(ledger), second,
		day(2026, time.March, 4))
	if billed {
		t.Fatal("the second of three bed days was billed")
	}
	if !strings.Contains(entry.Explanation, "2 of 3 used") {
		t.Fatalf("the explanation does not show the running count: %q", entry.Explanation)
	}
}

// A billed excess must not count against the cap, or the cap would consume
// itself.
func TestABilledExcessDoesNotCountAgainstTheCap(t *testing.T) {
	ledger := []domain.Consumption{
		{ServiceCode: "USG-OB", Quantity: 1, Outcome: domain.CoverageIncluded},
		{ServiceCode: "USG-OB", Quantity: 1, Outcome: domain.CoverageOverCap},
	}
	state := domain.NewPackageState(ledger)
	if got := state.Used["usg-ob"]; got != 1 {
		t.Fatalf("the cap counted a billed excess: %d used, want 1", got)
	}
}

// SRS-BIL-004: an exclusion is named, so the patient is told before admission.
func TestAnExcludedServiceIsBilledAndNamedAsExcluded(t *testing.T) {
	p := maternityPackage()
	charge := packagedCharge(t, "NICU-DAY", "Neonatal intensive care day", 1)

	entry, billed := p.Apply(domain.NewPackageState(nil), charge, day(2026, time.March, 3))
	if !billed {
		t.Fatal("an excluded service was absorbed")
	}
	if entry.Outcome != domain.CoverageExcluded {
		t.Fatalf("outcome = %q", entry.Outcome)
	}
	if !strings.Contains(entry.Explanation, "excluded") {
		t.Fatalf("the explanation does not say it was excluded: %q", entry.Explanation)
	}
	if entry.Price.Minor == 0 {
		t.Fatal("an excluded service was recorded at no price")
	}
}

// SRS-BIL-004: a carve-out is billed at its contracted price, not the standard
// tariff.
func TestACarveOutIsBilledAtTheContractedPrice(t *testing.T) {
	p := maternityPackage()
	charge := packagedCharge(t, "BLOOD-UNIT", "Packed red cells", 2)

	entry, billed := p.Apply(domain.NewPackageState(nil), charge, day(2026, time.March, 3))
	if !billed {
		t.Fatal("a carve-out was absorbed")
	}
	if entry.Outcome != domain.CoverageCarveOut {
		t.Fatalf("outcome = %q", entry.Outcome)
	}
	if entry.Price.Minor != 300000 {
		t.Fatalf("price = %d, want two units at the carve-out rate", entry.Price.Minor)
	}
	if !strings.Contains(entry.Explanation, "blood bank's issue price") {
		t.Fatalf("the explanation does not carry the carve-out note: %q", entry.Explanation)
	}
}

// A service the package says nothing about is recorded as such rather than
// left silent.
func TestAServiceOutsideThePackageIsRecordedAsOutsideIt(t *testing.T) {
	p := maternityPackage()
	charge := packagedCharge(t, "PHYSIO", "Physiotherapy session", 1)

	entry, billed := p.Apply(domain.NewPackageState(nil), charge, day(2026, time.March, 3))
	if !billed {
		t.Fatal("a service outside the package was absorbed")
	}
	if entry.Outcome != domain.CoverageOutsidePackage {
		t.Fatalf("outcome = %q", entry.Outcome)
	}
	if !strings.Contains(entry.Explanation, "not part of") {
		t.Fatalf("the explanation is unhelpful: %q", entry.Explanation)
	}
}

// A package that both includes and excludes a service has made two statements
// to the patient, one of which is false.
func TestAPackageCannotBothIncludeAndExcludeAService(t *testing.T) {
	p := maternityPackage()
	p.Exclusions = append(p.Exclusions, "CONS-OB")
	if err := p.Validate(); !errors.Is(err, domain.ErrInvalid) {
		t.Fatalf("a contradictory package was accepted: %v", err)
	}
}

func TestAPackageCannotCapOneServiceTwice(t *testing.T) {
	p := maternityPackage()
	p.Inclusions = append(p.Inclusions,
		domain.PackageInclusion{ServiceCode: "BED-GEN", Quantity: 5})
	if err := p.Validate(); !errors.Is(err, domain.ErrInvalid) {
		t.Fatalf("two caps on one service were accepted: %v", err)
	}
}

func TestAPackageNeedsAtLeastOneInclusion(t *testing.T) {
	p := maternityPackage()
	p.Inclusions = nil
	if err := p.Validate(); !errors.Is(err, domain.ErrInvalid) {
		t.Fatalf("a package covering nothing was accepted: %v", err)
	}
}

// An unlimited inclusion is a real contract — "all nursing care" — and is not
// defaulted to one.
func TestAnUnlimitedInclusionAbsorbsEveryOccurrence(t *testing.T) {
	p := maternityPackage()
	ledger := []domain.Consumption{
		{ServiceCode: "CONS-OB", Quantity: 9, Outcome: domain.CoverageIncluded},
	}
	tenth := packagedCharge(t, "CONS-OB", "Obstetric consultation", 1)

	_, billed := p.Apply(domain.NewPackageState(ledger), tenth, day(2026, time.March, 9))
	if billed {
		t.Fatal("an unlimited inclusion stopped absorbing")
	}
}

// SRS-BIL-004: the ledger reads in the order things happened, covered and
// billed together.
func TestTheConsumptionLedgerReadsInOrder(t *testing.T) {
	ledger := []domain.Consumption{
		{ChargeID: "c3", RecordedAt: day(2026, time.March, 6)},
		{ChargeID: "c1", RecordedAt: day(2026, time.March, 3)},
		{ChargeID: "c2", RecordedAt: day(2026, time.March, 4)},
	}
	ordered := domain.Explain(ledger)
	for i, want := range []string{"c1", "c2", "c3"} {
		if ordered[i].ChargeID != want {
			t.Fatalf("position %d is %q, want %q", i, ordered[i].ChargeID, want)
		}
	}
}
