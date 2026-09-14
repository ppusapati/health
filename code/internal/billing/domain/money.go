// Package domain is the billing context's model (SRS-BIL-001 … SRS-BIL-016).
//
// Two decisions run through every file here and are worth stating once.
//
// Money is an integer count of minor units with its currency attached, never a
// float. A float cannot represent 0.10 exactly, so a hundred line items summed
// as floats do not add up to the invoice total — and an invoice that does not
// add up is one a patient is right to dispute and an auditor is right to
// reject. The currency travels with the amount for the reason the clinical
// contexts give about quantities: a number alone has eventually been rendered
// under the wrong label by every system that stored it that way.
//
// Balances are derived from an append-only ledger, never stored. SRS-BIL-012
// says "balance derives from ledger and reconciles", and the alternative — a
// balance column kept in step by every writer — is a number that drifts the
// first time one of them fails between the two writes, with nothing to
// reconcile against because the ledger was never the truth.
package domain

import (
	"errors"
	"fmt"
	"strings"
)

// ErrInvalid reports a record that must not be stored.
//
// A sentinel rather than a transport error: the domain does not know it is
// behind an RPC, and FIT-01 holds it to that.
var ErrInvalid = errors.New("billing: invalid")

// ErrNotAllowed reports a change the record's own state forbids.
var ErrNotAllowed = errors.New("billing: not allowed in this state")

func invalidf(format string, args ...any) error {
	return fmt.Errorf("%w: %s", ErrInvalid, fmt.Sprintf(format, args...))
}

func notAllowedf(format string, args ...any) error {
	return fmt.Errorf("%w: %s", ErrNotAllowed, fmt.Sprintf(format, args...))
}

// Money is an amount in minor units with its currency.
//
// Minor units — paise, cents — because that is the smallest amount that can
// actually be paid, and because integer arithmetic is exact. A tariff of
// ₹1,250.50 is 125050.
type Money struct {
	// Minor is the amount, signed. Negative is meaningful: a credit note line
	// and a refund are both negative movements, and representing them as
	// positive amounts with a direction flag means every sum has to remember
	// to consult the flag.
	Minor    int64
	Currency string
}

// Zero reports an amount nobody set.
func (m Money) Zero() bool { return m.Minor == 0 && strings.TrimSpace(m.Currency) == "" }

// Validate rejects an amount that could not be billed.
func (m Money) Validate() error {
	if strings.TrimSpace(m.Currency) == "" {
		return invalidf("an amount needs a currency")
	}
	if !isCurrencyCode(m.Currency) {
		return invalidf("a currency must be a three-letter ISO 4217 code, got %q",
			m.Currency)
	}
	return nil
}

// isCurrencyCode reports an ISO 4217 alphabetic code.
//
// Three ASCII letters, checked as bytes rather than as a length: "₹" is three
// bytes of UTF-8 and would pass a length check, which is exactly the mistake
// this exists to catch — a currency field holding a symbol instead of a code
// renders as a symbol on screen and sorts, groups and reconciles as nothing.
func isCurrencyCode(code string) bool {
	if len(code) != 3 {
		return false
	}
	for i := 0; i < 3; i++ {
		c := code[i]
		if c < 'A' || c > 'Z' {
			if c < 'a' || c > 'z' {
				return false
			}
		}
	}
	return true
}

// Add sums two amounts of the same currency.
//
// Mixed currencies are an error rather than a conversion. A rate this context
// does not hold, applied silently at a moment nobody recorded, is how a
// reconciliation becomes unexplainable.
func (m Money) Add(other Money) (Money, error) {
	if m.Zero() {
		return other, nil
	}
	if other.Zero() {
		return m, nil
	}
	if !strings.EqualFold(m.Currency, other.Currency) {
		return Money{}, invalidf("cannot add %s to %s", other.Currency, m.Currency)
	}
	return Money{Minor: m.Minor + other.Minor, Currency: m.Currency}, nil
}

// Sub subtracts an amount of the same currency.
func (m Money) Sub(other Money) (Money, error) {
	return m.Add(other.Negate())
}

// Negate flips the sign.
func (m Money) Negate() Money {
	return Money{Minor: -m.Minor, Currency: m.Currency}
}

// Times multiplies by a whole quantity.
func (m Money) Times(quantity int32) Money {
	return Money{Minor: m.Minor * int64(quantity), Currency: m.Currency}
}

// Negative reports a debit-side amount.
func (m Money) Negative() bool { return m.Minor < 0 }

// Positive reports a credit-side amount.
func (m Money) Positive() bool { return m.Minor > 0 }

// String renders an amount for a human.
func (m Money) String() string {
	sign := ""
	minor := m.Minor
	if minor < 0 {
		sign, minor = "-", -minor
	}
	return fmt.Sprintf("%s%s %d.%02d", sign, strings.ToUpper(m.Currency),
		minor/100, minor%100)
}

// Sum adds a list of amounts.
func Sum(amounts ...Money) (Money, error) {
	total := Money{}
	for _, amount := range amounts {
		next, err := total.Add(amount)
		if err != nil {
			return Money{}, err
		}
		total = next
	}
	return total, nil
}

// BasisPoints is a rate in hundredths of a percent.
//
// Integer, for the same reason money is: 18% GST is 1800 basis points, and a
// tax computed from a float rate produces a different total depending on which
// order the lines were summed in.
type BasisPoints int32

// Apply computes a rate against an amount, rounding half away from zero.
//
// Half away from zero rather than banker's rounding, because that is what
// invoices and tax authorities expect, and an engine that rounded differently
// from the payer's would produce a penny of unexplained difference on every
// reconciliation.
func (b BasisPoints) Apply(amount Money) Money {
	if b == 0 || amount.Minor == 0 {
		return Money{Minor: 0, Currency: amount.Currency}
	}

	numerator := amount.Minor * int64(b)
	const denominator = 10000
	quotient := numerator / denominator
	remainder := numerator % denominator

	if remainder*2 >= denominator {
		quotient++
	} else if remainder*2 <= -denominator {
		quotient--
	}
	return Money{Minor: quotient, Currency: amount.Currency}
}

// Percent renders a rate for display.
func (b BasisPoints) Percent() string {
	sign := ""
	value := int32(b)
	if value < 0 {
		sign, value = "-", -value
	}
	return fmt.Sprintf("%s%d.%02d%%", sign, value/100, value%100)
}

// Validate rejects a rate that could not be applied.
func (b BasisPoints) Validate() error {
	if b < 0 {
		return invalidf("a rate cannot be negative")
	}
	if b > 10000 {
		// More than 100%. A discount above the price or a tax above the amount
		// is a data-entry slip, and the one time it is deliberate it should be
		// two lines rather than one rate.
		return invalidf("a rate above 100%% must be entered as separate lines")
	}
	return nil
}
