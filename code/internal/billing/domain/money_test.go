package domain_test

import (
	"errors"
	"testing"

	"github.com/ppusapati/health/code/internal/billing/domain"
)

func inr(minor int64) domain.Money {
	return domain.Money{Minor: minor, Currency: "INR"}
}

// The arithmetic everything else rests on. A hundred lines of ten paise summed
// as floats do not make ten rupees; summed as integers they do, exactly.
func TestAHundredSmallAmountsSumExactly(t *testing.T) {
	total := domain.Money{}
	for i := 0; i < 100; i++ {
		next, err := total.Add(inr(10))
		if err != nil {
			t.Fatalf("Add: %v", err)
		}
		total = next
	}
	if total.Minor != 1000 {
		t.Fatalf("total = %d minor units, want exactly 1000", total.Minor)
	}
	if got := total.String(); got != "INR 10.00" {
		t.Fatalf("String() = %q", got)
	}
}

// Mixing currencies is an error, never a silent conversion at a rate nobody
// recorded.
func TestMixingCurrenciesIsRefused(t *testing.T) {
	_, err := inr(1000).Add(domain.Money{Minor: 1000, Currency: "USD"})
	if !errors.Is(err, domain.ErrInvalid) {
		t.Fatalf("adding dollars to rupees was accepted: %v", err)
	}
}

func TestAnAmountNeedsAThreeLetterCurrency(t *testing.T) {
	for name, m := range map[string]domain.Money{
		"no currency": {Minor: 100},
		"a symbol":    {Minor: 100, Currency: "₹"},
		"a name":      {Minor: 100, Currency: "rupees"},
	} {
		t.Run(name, func(t *testing.T) {
			if err := m.Validate(); !errors.Is(err, domain.ErrInvalid) {
				t.Fatalf("%s accepted: %v", name, err)
			}
		})
	}
}

// Negative amounts are first-class: a refund and a credit note are both
// negative movements, and a direction flag is a thing every sum can forget.
func TestANegativeAmountRendersWithItsSign(t *testing.T) {
	if got := inr(-125050).String(); got != "-INR 1250.50" {
		t.Fatalf("String() = %q", got)
	}
	if !inr(-1).Negative() || inr(-1).Positive() {
		t.Fatal("sign predicates disagree")
	}
}

// Tax rounds half away from zero, which is what invoices and tax authorities
// expect.
func TestARateRoundsHalfAwayFromZero(t *testing.T) {
	rate := domain.BasisPoints(1800) // 18%

	for _, tc := range []struct {
		amount int64
		want   int64
	}{
		{10000, 1800},
		// 18% of 1.05 is 0.189, which rounds to 0.19.
		{105, 19},
		// 18% of 0.25 is 0.045, exactly half a paisa, which rounds up.
		{25, 5},
		{0, 0},
	} {
		if got := rate.Apply(inr(tc.amount)); got.Minor != tc.want {
			t.Errorf("18%% of %d = %d, want %d", tc.amount, got.Minor, tc.want)
		}
	}
}

func TestARateRendersAsAPercentage(t *testing.T) {
	if got := domain.BasisPoints(1800).Percent(); got != "18.00%" {
		t.Fatalf("Percent() = %q", got)
	}
	if got := domain.BasisPoints(750).Percent(); got != "7.50%" {
		t.Fatalf("Percent() = %q", got)
	}
}

// A rate above 100% is a data-entry slip, and the one time it is deliberate it
// should be two lines.
func TestARateAboveOneHundredPercentIsRefused(t *testing.T) {
	if err := domain.BasisPoints(10001).Validate(); !errors.Is(err, domain.ErrInvalid) {
		t.Fatalf("a rate above 100%% was accepted: %v", err)
	}
	if err := domain.BasisPoints(-1).Validate(); !errors.Is(err, domain.ErrInvalid) {
		t.Fatalf("a negative rate was accepted: %v", err)
	}
}

func TestSubtractionAndMultiplicationStayExact(t *testing.T) {
	remaining, err := inr(100000).Sub(inr(33333))
	if err != nil {
		t.Fatalf("Sub: %v", err)
	}
	if remaining.Minor != 66667 {
		t.Fatalf("remaining = %d", remaining.Minor)
	}
	if got := inr(1999).Times(7); got.Minor != 13993 {
		t.Fatalf("times = %d", got.Minor)
	}
}
