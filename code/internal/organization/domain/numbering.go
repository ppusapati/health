package domain

import (
	"errors"
	"fmt"
	"strconv"
	"strings"
	"time"
)

// Tenant numbering sequences (SRS-PLT-014).
//
// MRNs, encounter numbers, invoice and receipt numbers. The requirement's
// verification is "sequences are atomic and collision-free under concurrency",
// which is a property of the statement that issues them rather than of
// anything here — see IssueTenantNumber in db/queries. What lives in the
// domain is the formatting, and the rules about what a number may look like.
//
// The formatting matters more than it appears. A number that is printed on a
// wristband, quoted on the phone and typed back in by a clerk has to survive
// that round trip, so the format is fixed at the sequence rather than chosen
// per call: two callers formatting the same counter differently would produce
// two spellings of one identifier, and nobody could tell they were the same.

// NumberScope names a kind of document number.
type NumberScope string

const (
	ScopeMRN       NumberScope = "mrn"
	ScopeEncounter NumberScope = "encounter"
	ScopeInvoice   NumberScope = "invoice"
	ScopeReceipt   NumberScope = "receipt"
)

// NumberSequence is the configuration of one counter.
type NumberSequence struct {
	ID       string
	TenantID string
	Scope    NumberScope
	// FacilityID empty means one counter for the whole tenant. Hospitals
	// commonly want MRNs that say which site registered the patient, which is
	// a per-facility counter.
	FacilityID string
	Prefix     string
	// PadWidth zero-pads the numeric part. Zero means no padding.
	PadWidth int32
	// NextValue is what the next call will issue, not the last issued. Storing
	// "next" removes the off-by-one at the boundary between an unused and a
	// used sequence.
	NextValue int64
	// PeriodKey resets numbering: "2026", "2026-04", or empty for never. It is
	// stored rather than derived so a tenant on a fiscal year that is not the
	// calendar year needs no special-case code.
	PeriodKey string
	CreatedAt time.Time
	UpdatedAt time.Time
}

// ErrInvalidSequence reports a sequence configuration that must not be stored.
var ErrInvalidSequence = errors.New("organization: invalid number sequence")

// MaxPadWidth bounds the zero padding. Twenty digits is already past what a
// bigint can produce; the limit exists so a typo cannot generate a number
// nothing downstream can store.
const MaxPadWidth = 20

// NewNumberSequence validates and constructs a sequence.
func NewNumberSequence(id, tenantID, facilityID string, scope NumberScope,
	prefix string, padWidth int32, start int64, periodKey string, now time.Time) (NumberSequence, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return NumberSequence{}, fmt.Errorf("%w: id is required", ErrInvalidSequence)
	case strings.TrimSpace(tenantID) == "":
		return NumberSequence{}, fmt.Errorf("%w: tenant is required", ErrInvalidSequence)
	case strings.TrimSpace(string(scope)) == "":
		return NumberSequence{}, fmt.Errorf("%w: scope is required", ErrInvalidSequence)
	case start <= 0:
		// Starting at zero would make the first issued number 0, which reads
		// as "unset" everywhere it is printed.
		return NumberSequence{}, fmt.Errorf("%w: start must be positive", ErrInvalidSequence)
	case padWidth < 0 || padWidth > MaxPadWidth:
		return NumberSequence{}, fmt.Errorf("%w: pad width must be between 0 and %d",
			ErrInvalidSequence, MaxPadWidth)
	case strings.ContainsAny(prefix, " \t\n"):
		// A prefix with whitespace produces identifiers that do not survive
		// being read aloud, written down and typed back.
		return NumberSequence{}, fmt.Errorf("%w: prefix must not contain whitespace", ErrInvalidSequence)
	}

	return NumberSequence{
		ID: id, TenantID: tenantID, FacilityID: facilityID, Scope: scope,
		Prefix: prefix, PadWidth: padWidth, NextValue: start, PeriodKey: periodKey,
		CreatedAt: now.UTC(), UpdatedAt: now.UTC(),
	}, nil
}

// Format renders an issued counter value as the document number.
func Format(prefix string, padWidth int32, value int64) string {
	digits := strconv.FormatInt(value, 10)
	if padWidth > 0 && int32(len(digits)) < padWidth {
		digits = strings.Repeat("0", int(padWidth)-len(digits)) + digits
	}
	return prefix + digits
}

// Format renders a value under this sequence's configuration.
func (s NumberSequence) Format(value int64) string { return Format(s.Prefix, s.PadWidth, value) }

// PeriodKeyFor derives the reset key for an instant under a reset policy.
//
// The instant must be interpreted in the tenant's own timezone, not UTC: a
// hospital in Kolkata issuing an invoice at 02:00 local on 1 April is in the
// new fiscal year, and UTC would still say 31 March. That is why this takes a
// location rather than assuming one.
func PeriodKeyFor(policy string, at time.Time, loc *time.Location) (string, error) {
	if loc == nil {
		return "", fmt.Errorf("%w: a location is required to decide which period an instant falls in",
			ErrInvalidSequence)
	}
	local := at.In(loc)
	switch policy {
	case "", "never":
		return "", nil
	case "yearly":
		return local.Format("2006"), nil
	case "monthly":
		return local.Format("2006-01"), nil
	case "daily":
		return local.Format("2006-01-02"), nil
	default:
		return "", fmt.Errorf("%w: unknown reset policy %q", ErrInvalidSequence, policy)
	}
}
