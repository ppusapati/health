package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/billing/domain"
)

func day(y int, m time.Month, d int) time.Time {
	return time.Date(y, m, d, 0, 0, 0, 0, time.UTC)
}

func consultation(from, to time.Time, rate domain.BasisPoints) domain.ServiceItem {
	return domain.ServiceItem{
		Code: "CONS-OP", Description: "Outpatient consultation",
		Department: "General Medicine", RevenueAccount: "4100",
		TaxCode: "GST18", TaxRate: rate,
		EffectiveFrom: from, EffectiveTo: to,
	}
}

// SRS-BIL-001: a historical invoice resolves the service version that was
// active at charge time, not the current one.
func TestAChargeResolvesTheServiceVersionActiveWhenItHappened(t *testing.T) {
	versions := []domain.ServiceItem{
		consultation(day(2025, time.January, 1), day(2026, time.April, 1), 1200),
		consultation(day(2026, time.April, 1), time.Time{}, 1800),
	}

	march, ok := domain.ResolveService(versions, "CONS-OP", day(2026, time.March, 15))
	if !ok {
		t.Fatal("no service version in force in March")
	}
	if march.TaxRate != 1200 {
		t.Fatalf("March resolved a rate of %v, want the 12%% then in force", march.TaxRate)
	}

	may, ok := domain.ResolveService(versions, "CONS-OP", day(2026, time.May, 15))
	if !ok {
		t.Fatal("no service version in force in May")
	}
	if may.TaxRate != 1800 {
		t.Fatalf("May resolved a rate of %v, want 18%%", may.TaxRate)
	}
}

// A charge against a date no version covers is refused rather than priced from
// today's master.
func TestAServiceThatDidNotExistYetDoesNotResolve(t *testing.T) {
	versions := []domain.ServiceItem{
		consultation(day(2026, time.April, 1), time.Time{}, 1800),
	}
	if _, ok := domain.ResolveService(versions, "CONS-OP",
		day(2026, time.March, 15)); ok {
		t.Fatal("a service resolved before it existed")
	}
}

func TestAServiceNeedsADepartmentAndARevenueAccount(t *testing.T) {
	for name, break_ := range map[string]func(*domain.ServiceItem){
		"department":  func(s *domain.ServiceItem) { s.Department = "" },
		"revenue":     func(s *domain.ServiceItem) { s.RevenueAccount = "" },
		"description": func(s *domain.ServiceItem) { s.Description = "" },
		"code":        func(s *domain.ServiceItem) { s.Code = "" },
	} {
		t.Run(name, func(t *testing.T) {
			item := consultation(day(2026, time.January, 1), time.Time{}, 1800)
			break_(&item)
			if err := item.Validate(); !errors.Is(err, domain.ErrInvalid) {
				t.Fatalf("missing %s accepted: %v", name, err)
			}
		})
	}
}

func line(contract, name string, scope domain.TariffScope, price int64,
	priority int32) domain.TariffLine {

	return domain.TariffLine{
		ContractID: contract, Name: name, Scope: scope,
		Price: inr(price), Priority: priority,
		EffectiveFrom: day(2026, time.January, 1),
	}
}

// SRS-BIL-002: the engine resolves a deterministic applicable tariff, and the
// most specific contract wins.
func TestTheMostSpecificTariffWins(t *testing.T) {
	lines := []domain.TariffLine{
		line("STD", "Standard list", domain.TariffScope{}, 100000, 0),
		line("INS-A", "Insurer A", domain.TariffScope{PayerID: "insurer-a"}, 80000, 0),
		line("INS-A-PVT", "Insurer A, private room",
			domain.TariffScope{PayerID: "insurer-a", RoomClass: "private"}, 90000, 0),
	}

	selfPaying, ok := domain.ResolveTariff(lines, domain.PricingQuery{
		ServiceCode: "CONS-OP", At: day(2026, time.March, 1),
	})
	if !ok || selfPaying.ContractID != "STD" {
		t.Fatalf("a self-paying patient resolved %+v, want the standard list", selfPaying)
	}

	insured, ok := domain.ResolveTariff(lines, domain.PricingQuery{
		ServiceCode: "CONS-OP", PayerID: "insurer-a", At: day(2026, time.March, 1),
	})
	if !ok || insured.ContractID != "INS-A" {
		t.Fatalf("an insured patient resolved %+v, want the insurer contract", insured)
	}

	private, ok := domain.ResolveTariff(lines, domain.PricingQuery{
		ServiceCode: "CONS-OP", PayerID: "insurer-a", RoomClass: "private",
		At: day(2026, time.March, 1),
	})
	if !ok || private.ContractID != "INS-A-PVT" {
		t.Fatalf("a private room resolved %+v, want the room-class contract", private)
	}
	if private.Price.Minor != 90000 {
		t.Fatalf("price = %d", private.Price.Minor)
	}
}

// A contract for one payer never prices another payer's patient.
func TestAPayersContractDoesNotPriceSomebodyElsesPatient(t *testing.T) {
	lines := []domain.TariffLine{
		line("INS-A", "Insurer A", domain.TariffScope{PayerID: "insurer-a"}, 80000, 0),
	}
	if _, ok := domain.ResolveTariff(lines, domain.PricingQuery{
		ServiceCode: "CONS-OP", PayerID: "insurer-b", At: day(2026, time.March, 1),
	}); ok {
		t.Fatal("insurer A's contract priced insurer B's patient")
	}
}

// Determinism: a tie on specificity is broken by an explicit priority, and a
// tie on both by a stable rule rather than by row order.
func TestATieIsBrokenDeterministically(t *testing.T) {
	lines := []domain.TariffLine{
		line("B", "Contract B", domain.TariffScope{PayerID: "insurer-a"}, 70000, 5),
		line("A", "Contract A", domain.TariffScope{PayerID: "insurer-a"}, 80000, 9),
	}
	q := domain.PricingQuery{
		ServiceCode: "CONS-OP", PayerID: "insurer-a", At: day(2026, time.March, 1),
	}

	first, ok := domain.ResolveTariff(lines, q)
	if !ok || first.ContractID != "A" {
		t.Fatalf("resolved %+v, want the higher-priority contract", first)
	}

	// Reversed input order, same answer.
	reversed := []domain.TariffLine{lines[1], lines[0]}
	second, _ := domain.ResolveTariff(reversed, q)
	if second.ContractID != first.ContractID {
		t.Fatalf("row order changed the answer: %q then %q",
			first.ContractID, second.ContractID)
	}

	// And with no priority to separate them, the identifier does — stably.
	equal := []domain.TariffLine{
		line("Z", "Contract Z", domain.TariffScope{PayerID: "insurer-a"}, 70000, 0),
		line("A", "Contract A", domain.TariffScope{PayerID: "insurer-a"}, 80000, 0),
	}
	for i := 0; i < 5; i++ {
		got, _ := domain.ResolveTariff(equal, q)
		if got.ContractID != "A" {
			t.Fatalf("run %d resolved %q, want a stable answer", i, got.ContractID)
		}
	}
}

// An expired contract does not price today's care.
func TestAnExpiredTariffDoesNotPriceTodaysCare(t *testing.T) {
	expired := line("OLD", "Last year", domain.TariffScope{}, 50000, 0)
	expired.EffectiveTo = day(2026, time.February, 1)

	if _, ok := domain.ResolveTariff([]domain.TariffLine{expired},
		domain.PricingQuery{ServiceCode: "CONS-OP", At: day(2026, time.March, 1)}); ok {
		t.Fatal("an expired contract priced today's care")
	}
}

// The contract that produced the price travels with it, because "which tariff
// was applied" is the first question of a payer dispute.
func TestThePriceCarriesTheContractThatProducedIt(t *testing.T) {
	lines := []domain.TariffLine{
		line("INS-A", "Insurer A master agreement 2026",
			domain.TariffScope{PayerID: "insurer-a"}, 80000, 0),
	}
	got, ok := domain.ResolveTariff(lines, domain.PricingQuery{
		ServiceCode: "CONS-OP", PayerID: "insurer-a", At: day(2026, time.March, 1),
	})
	if !ok {
		t.Fatal("nothing resolved")
	}
	if got.Contract != "Insurer A master agreement 2026" || got.ContractID != "INS-A" {
		t.Fatalf("the result does not name the contract: %+v", got)
	}
	if got.Scope.PayerID != "insurer-a" {
		t.Fatalf("the result does not carry the scope it matched on: %+v", got.Scope)
	}
}

func TestATariffPriceCannotBeNegative(t *testing.T) {
	bad := line("STD", "Standard", domain.TariffScope{}, -100, 0)
	if err := bad.Validate(); !errors.Is(err, domain.ErrInvalid) {
		t.Fatalf("a negative tariff was accepted: %v", err)
	}
}
