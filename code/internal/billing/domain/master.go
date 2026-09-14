package domain

import (
	"sort"
	"strings"
	"time"
)

// The charge master and the tariff contracts (SRS-BIL-001, SRS-BIL-002).
//
// Both are effective-dated, and both resolve as of a moment rather than as of
// now. SRS-BIL-001's acceptance is explicit: "historical invoice resolves
// service version active at charge time". A price list edited in April must not
// change what a March invoice says it charged for, and the only way to hold
// that without copying the whole master onto every line is to keep the versions
// and look up by date.

// ServiceItem is one billable thing (SRS-BIL-001).
//
// Versioned by its effective window rather than by a version number: the
// question asked of it is always "what was this on the day of the charge", and
// a number would need a second lookup to answer that.
type ServiceItem struct {
	TenantID string
	// Code is the hospital's own identifier, stable across versions. Two rows
	// with one code and different windows are two versions of one service.
	Code        string
	Description string
	// Department owns the revenue. Radiology's income is not the ward's, and a
	// service with no department is income nobody is accountable for.
	Department string
	// RevenueAccount maps to the finance system's chart of accounts
	// (SRS-BIL-001's "revenue mapping"). A string because its shape is the
	// finance system's, not this one's.
	RevenueAccount string
	// TaxCode and TaxRate are the tax attributes. The rate is stored on the
	// version rather than looked up, for the same reason the price is: a rate
	// change in April must not restate a March invoice.
	TaxCode string
	TaxRate BasisPoints
	// TaxInclusive says whether the tariff price already contains the tax.
	// Stated rather than assumed, because the two conventions coexist in one
	// hospital — a room charge quoted inclusive, a consumable quoted exclusive —
	// and guessing produces an invoice wrong by the tax on every line.
	TaxInclusive bool

	EffectiveFrom time.Time
	// EffectiveTo is zero while the version is current.
	EffectiveTo time.Time

	UpdatedBy string
	UpdatedAt time.Time
}

// Validate rejects a service that could not be charged or accounted for.
func (s ServiceItem) Validate() error {
	switch {
	case strings.TrimSpace(s.Code) == "":
		return invalidf("a service needs a code")
	case strings.TrimSpace(s.Description) == "":
		// A bare code on an invoice is an invoice a patient cannot query.
		return invalidf("a service needs a description")
	case strings.TrimSpace(s.Department) == "":
		return invalidf("a service needs the department whose revenue it is")
	case strings.TrimSpace(s.RevenueAccount) == "":
		return invalidf("a service needs a revenue account")
	case s.EffectiveFrom.IsZero():
		return invalidf("a service version needs an effective date")
	case !s.EffectiveTo.IsZero() && !s.EffectiveTo.After(s.EffectiveFrom):
		return invalidf("a service version cannot end before it begins")
	}
	return s.TaxRate.Validate()
}

// ActiveAt reports whether this version was in force at a moment.
func (s ServiceItem) ActiveAt(at time.Time) bool {
	at = at.UTC()
	if at.Before(s.EffectiveFrom.UTC()) {
		return false
	}
	return s.EffectiveTo.IsZero() || at.Before(s.EffectiveTo.UTC())
}

// ResolveService picks the version in force at a moment (SRS-BIL-001).
//
// Deterministic: exactly one version of a code may be in force at a time, which
// the schema's exclusion constraint holds, so this returns the first match
// rather than the most recently edited one. Where none matches, it says so
// instead of falling back to the current version — a charge against a service
// that did not exist yet is a charge nobody can defend, and quietly pricing it
// from today's master is how that becomes invisible.
func ResolveService(versions []ServiceItem, code string, at time.Time) (
	ServiceItem, bool) {

	for _, version := range versions {
		if !strings.EqualFold(version.Code, code) {
			continue
		}
		if version.ActiveAt(at) {
			return version, true
		}
	}
	return ServiceItem{}, false
}

// TariffScope is what a contract is negotiated against (SRS-BIL-002).
//
// All five axes are optional. A contract that names none is the hospital's
// standard list price; one that names a payer and a room class is the rate that
// insurer pays for a private room. Specificity decides which wins.
type TariffScope struct {
	// PayerID is the insurer or scheme.
	PayerID string
	// CustomerID is the corporate account, which is not the same thing: a
	// company scheme and the insurer administering it negotiate separately.
	CustomerID string
	FacilityID string
	// RoomClass is what makes a bed-day tariff: the same service costs
	// differently in a general ward and a suite.
	RoomClass string
	// ServiceCode narrows to one service. Empty means the contract's other
	// terms apply to everything not otherwise priced.
	ServiceCode string
}

// specificity counts the axes a scope names.
//
// More specific wins, which is the deterministic rule SRS-BIL-002's acceptance
// asks for. Counting rather than ordering the axes, because a hospital that
// negotiated a payer-and-room-class rate and a facility-and-service rate has
// made two equally deliberate decisions, and the tie is broken below.
func (s TariffScope) specificity() int {
	count := 0
	for _, axis := range []string{
		s.PayerID, s.CustomerID, s.FacilityID, s.RoomClass, s.ServiceCode,
	} {
		if strings.TrimSpace(axis) != "" {
			count++
		}
	}
	return count
}

// matches reports whether a scope applies to a pricing question.
func (s TariffScope) matches(q PricingQuery) bool {
	for _, pair := range [][2]string{
		{s.PayerID, q.PayerID},
		{s.CustomerID, q.CustomerID},
		{s.FacilityID, q.FacilityID},
		{s.RoomClass, q.RoomClass},
		{s.ServiceCode, q.ServiceCode},
	} {
		// An empty axis on the contract matches anything; a named one must
		// match exactly. A contract for insurer A never prices a self-paying
		// patient, which is the whole point of scoping it.
		if strings.TrimSpace(pair[0]) == "" {
			continue
		}
		if !strings.EqualFold(pair[0], pair[1]) {
			return false
		}
	}
	return true
}

// TariffLine is one price under one contract (SRS-BIL-002).
type TariffLine struct {
	TenantID string
	// ContractID groups the lines a contract was negotiated as. Kept because
	// "which contract priced this" is the question a payer dispute starts with.
	ContractID string
	// Name is the contract as finance knows it.
	Name  string
	Scope TariffScope
	Price Money
	// Priority breaks a tie between contracts of equal specificity. Explicit
	// rather than "most recently created", because a resolution that depends on
	// insertion order is one that changes when data is migrated.
	Priority int32

	EffectiveFrom time.Time
	EffectiveTo   time.Time

	UpdatedBy string
	UpdatedAt time.Time
}

// Validate rejects a tariff line that could not be applied.
func (t TariffLine) Validate() error {
	switch {
	case strings.TrimSpace(t.ContractID) == "":
		return invalidf("a tariff line needs a contract")
	case strings.TrimSpace(t.Name) == "":
		return invalidf("a tariff contract needs a name")
	case t.EffectiveFrom.IsZero():
		return invalidf("a tariff line needs an effective date")
	case !t.EffectiveTo.IsZero() && !t.EffectiveTo.After(t.EffectiveFrom):
		return invalidf("a tariff line cannot end before it begins")
	case t.Price.Minor < 0:
		// A negative price is a discount or a credit, and both have their own
		// mechanisms with their own authorisation. A tariff that could go
		// negative would be a way round both.
		return invalidf("a tariff price cannot be negative")
	}
	return t.Price.Validate()
}

// ActiveAt reports whether this line was in force at a moment.
func (t TariffLine) ActiveAt(at time.Time) bool {
	at = at.UTC()
	if at.Before(t.EffectiveFrom.UTC()) {
		return false
	}
	return t.EffectiveTo.IsZero() || at.Before(t.EffectiveTo.UTC())
}

// PricingQuery is what the engine is asked to price (SRS-BIL-002).
type PricingQuery struct {
	ServiceCode string
	PayerID     string
	CustomerID  string
	FacilityID  string
	RoomClass   string
	At          time.Time
}

// PricingResult is the price and why (SRS-BIL-002).
//
// The contract that produced it travels with it, because "which tariff was
// applied" is the first question of every payer dispute and recomputing it
// later would answer with today's contracts rather than the day's.
type PricingResult struct {
	Price      Money
	ContractID string
	Contract   string
	Scope      TariffScope
}

// ResolveTariff picks the applicable price deterministically (SRS-BIL-002).
//
// Most specific wins; a tie on specificity is broken by the explicit priority,
// and a tie on both by the contract identifier — an arbitrary but *stable*
// rule, so the same question asked twice gets the same answer even after the
// rows have been migrated. Determinism is the acceptance criterion, and a
// resolution that depended on row order would satisfy it only until somebody
// reindexed the table.
func ResolveTariff(lines []TariffLine, q PricingQuery) (PricingResult, bool) {
	candidates := make([]TariffLine, 0, len(lines))
	for _, line := range lines {
		if !line.ActiveAt(q.At) || !line.Scope.matches(q) {
			continue
		}
		candidates = append(candidates, line)
	}
	if len(candidates) == 0 {
		return PricingResult{}, false
	}

	sort.SliceStable(candidates, func(i, j int) bool {
		a, b := candidates[i], candidates[j]
		if sa, sb := a.Scope.specificity(), b.Scope.specificity(); sa != sb {
			return sa > sb
		}
		if a.Priority != b.Priority {
			return a.Priority > b.Priority
		}
		return a.ContractID < b.ContractID
	})

	best := candidates[0]
	return PricingResult{
		Price: best.Price, ContractID: best.ContractID,
		Contract: best.Name, Scope: best.Scope,
	}, true
}
