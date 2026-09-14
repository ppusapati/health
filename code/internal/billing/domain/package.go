package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Package and bundle pricing (SRS-BIL-004).
//
// The acceptance criterion is the design: "package consumption ledger explains
// billed/not billed items". A package that only recorded what it absorbed would
// leave a patient unable to see why the third scan was charged when the first
// two were not, and that conversation happens at every discharge desk. So every
// service inside the package's scope produces a consumption entry — covered or
// not — carrying the reason.
//
// Four mechanisms, and they are genuinely different things rather than four
// names for a list:
//
//   - an inclusion is covered up to its cap,
//   - an exclusion is named as never covered, so the patient is told before
//     admission rather than at discharge,
//   - a cap is the quantity an inclusion covers, beyond which the excess is
//     billed rather than the whole line,
//   - a carve-out is a service billed separately *at a stated price*, which is
//     how implants and high-cost drugs are actually contracted.

// PackageInclusion is a service a package covers (SRS-BIL-004).
type PackageInclusion struct {
	ServiceCode string
	// Quantity is the cap. Zero means unlimited within the package, which is a
	// real contract — "all nursing care" — and is why it is not defaulted to
	// one.
	Quantity int32
}

// PackageCarveOut is a service billed separately at a stated price
// (SRS-BIL-004).
//
// A price rather than a flag, because that is how they are contracted: an
// implant is "at cost plus 10%", and a carve-out with no price would fall back
// to the standard tariff, which is not what either side agreed.
type PackageCarveOut struct {
	ServiceCode string
	Price       Money
	Note        string
}

// Package is a bundle at a fixed price (SRS-BIL-004).
type Package struct {
	TenantID string
	Code     string
	Name     string
	Price    Money

	Inclusions []PackageInclusion
	// Exclusions are named so a patient is told before admission rather than at
	// discharge. Listed explicitly rather than implied by absence from the
	// inclusions, because "we did not think about this" and "this is not
	// covered" are different answers and only one of them is a contract.
	Exclusions []string
	CarveOuts  []PackageCarveOut

	// RoomClass bounds the package where the price assumes one — a maternity
	// package in a suite is not the same product as one in a general ward.
	RoomClass string

	EffectiveFrom time.Time
	EffectiveTo   time.Time

	UpdatedBy string
	UpdatedAt time.Time
}

// Validate rejects a package that could not be applied.
func (p Package) Validate() error {
	switch {
	case strings.TrimSpace(p.Code) == "":
		return invalidf("a package needs a code")
	case strings.TrimSpace(p.Name) == "":
		return invalidf("a package needs a name")
	case len(p.Inclusions) == 0:
		// A package that covers nothing is a price with no product.
		return invalidf("a package needs at least one inclusion")
	case p.EffectiveFrom.IsZero():
		return invalidf("a package needs an effective date")
	case !p.EffectiveTo.IsZero() && !p.EffectiveTo.After(p.EffectiveFrom):
		return invalidf("a package cannot end before it begins")
	}
	if err := p.Price.Validate(); err != nil {
		return err
	}
	if p.Price.Minor < 0 {
		return invalidf("a package price cannot be negative")
	}

	seen := map[string]bool{}
	for _, inclusion := range p.Inclusions {
		if strings.TrimSpace(inclusion.ServiceCode) == "" {
			return invalidf("an inclusion needs a service code")
		}
		key := strings.ToLower(inclusion.ServiceCode)
		if seen[key] {
			// Two caps on one service is two answers to "how many are
			// covered", and whichever the engine reads first is arbitrary.
			return invalidf("service %q is included twice", inclusion.ServiceCode)
		}
		seen[key] = true
		if inclusion.Quantity < 0 {
			return invalidf("an inclusion cap cannot be negative")
		}
	}
	for _, excluded := range p.Exclusions {
		if seen[strings.ToLower(strings.TrimSpace(excluded))] {
			// Both included and excluded. Whichever way the engine resolved it,
			// one of the two statements the hospital made to the patient would
			// be false.
			return invalidf("service %q is both included and excluded", excluded)
		}
	}
	for _, carveOut := range p.CarveOuts {
		if strings.TrimSpace(carveOut.ServiceCode) == "" {
			return invalidf("a carve-out needs a service code")
		}
		if err := carveOut.Price.Validate(); err != nil {
			return err
		}
	}
	return nil
}

// ActiveAt reports whether the package was in force at a moment.
func (p Package) ActiveAt(at time.Time) bool {
	at = at.UTC()
	if at.Before(p.EffectiveFrom.UTC()) {
		return false
	}
	return p.EffectiveTo.IsZero() || at.Before(p.EffectiveTo.UTC())
}

// CoverageOutcome is what a package did with one charge (SRS-BIL-004).
type CoverageOutcome string

const (
	// CoverageIncluded means the package absorbed it: nothing further to pay.
	CoverageIncluded CoverageOutcome = "included"
	// CoverageOverCap means the inclusion's quantity was already used, so this
	// one is billed. The excess rather than the whole line, which is what a cap
	// means.
	CoverageOverCap CoverageOutcome = "over_cap"
	// CoverageExcluded means the package names it as not covered.
	CoverageExcluded CoverageOutcome = "excluded"
	// CoverageCarveOut means it is billed separately at the contracted price.
	CoverageCarveOut CoverageOutcome = "carve_out"
	// CoverageOutsidePackage means the package says nothing about it, so the
	// standard tariff applies. Recorded rather than left silent: "we did not
	// contract for this" is the answer to a question a patient asks.
	CoverageOutsidePackage CoverageOutcome = "outside_package"
)

// Billed reports an outcome the patient pays for.
func (o CoverageOutcome) Billed() bool { return o != CoverageIncluded }

// Consumption is one entry in the package ledger (SRS-BIL-004).
type Consumption struct {
	TenantID    string
	AccountID   string
	PackageCode string
	ChargeID    string
	ServiceCode string
	Quantity    int32
	Outcome     CoverageOutcome
	// Explanation is the sentence at the discharge desk. Stored rather than
	// derived at display time, because the package may have been superseded by
	// the time somebody asks.
	Explanation string
	// Price is what was billed where the outcome bills. Zero where the package
	// absorbed it.
	Price      Money
	RecordedAt time.Time
}

// PackageState tracks what a package has absorbed so far.
//
// Carried rather than recomputed on every charge, because the cap is a running
// count and recomputing it from the whole ledger for each new charge is how a
// long admission gets slow. It is rebuilt from the ledger rather than stored, so
// it cannot drift from it.
type PackageState struct {
	Used map[string]int32
}

// NewPackageState rebuilds the running counts from a consumption ledger.
func NewPackageState(ledger []Consumption) PackageState {
	used := map[string]int32{}
	for _, entry := range ledger {
		if entry.Outcome != CoverageIncluded {
			// Only what the package actually absorbed counts against the cap.
			// Counting a billed excess would mean the cap consumed itself.
			continue
		}
		used[strings.ToLower(entry.ServiceCode)] += entry.Quantity
	}
	return PackageState{Used: used}
}

// Apply decides what a package does with a charge, and says why (SRS-BIL-004).
//
// Returns the consumption entry to record and whether the charge is billed. The
// charge is not mutated here: the caller records both, in one transaction, so a
// charge marked covered can never exist without the ledger entry that explains
// it.
func (p Package) Apply(state PackageState, charge *Charge, now time.Time) (
	Consumption, bool) {

	code := strings.ToLower(charge.ServiceCode)
	entry := Consumption{
		TenantID: charge.TenantID, AccountID: charge.AccountID,
		PackageCode: p.Code, ChargeID: charge.ID, ServiceCode: charge.ServiceCode,
		Quantity: charge.Quantity, RecordedAt: now.UTC(),
	}

	for _, excluded := range p.Exclusions {
		if strings.EqualFold(strings.TrimSpace(excluded), charge.ServiceCode) {
			entry.Outcome = CoverageExcluded
			entry.Explanation = fmt.Sprintf(
				"%s is excluded from the %s package and is billed separately",
				charge.Description, p.Name)
			entry.Price = charge.Total()
			return entry, true
		}
	}

	for _, carveOut := range p.CarveOuts {
		if !strings.EqualFold(carveOut.ServiceCode, charge.ServiceCode) {
			continue
		}
		entry.Outcome = CoverageCarveOut
		entry.Explanation = fmt.Sprintf(
			"%s is a carve-out of the %s package, charged at the contracted rate",
			charge.Description, p.Name)
		if note := strings.TrimSpace(carveOut.Note); note != "" {
			entry.Explanation += " (" + note + ")"
		}
		entry.Price = carveOut.Price.Times(charge.Quantity)
		return entry, true
	}

	for _, inclusion := range p.Inclusions {
		if !strings.EqualFold(inclusion.ServiceCode, charge.ServiceCode) {
			continue
		}
		if inclusion.Quantity == 0 {
			entry.Outcome = CoverageIncluded
			entry.Explanation = fmt.Sprintf("%s is covered by the %s package",
				charge.Description, p.Name)
			return entry, false
		}
		used := state.Used[code]
		if used+charge.Quantity <= inclusion.Quantity {
			entry.Outcome = CoverageIncluded
			entry.Explanation = fmt.Sprintf(
				"%s is covered by the %s package (%d of %d used)",
				charge.Description, p.Name, used+charge.Quantity, inclusion.Quantity)
			return entry, false
		}
		entry.Outcome = CoverageOverCap
		entry.Explanation = fmt.Sprintf(
			"the %s package covers %d of %s; %d already used, so this one is billed",
			p.Name, inclusion.Quantity, charge.Description, used)
		entry.Price = charge.Total()
		return entry, true
	}

	entry.Outcome = CoverageOutsidePackage
	entry.Explanation = fmt.Sprintf("%s is not part of the %s package",
		charge.Description, p.Name)
	entry.Price = charge.Total()
	return entry, true
}

// Explain renders the consumption ledger for a patient (SRS-BIL-004).
//
// Ordered by when things happened, with the covered and the billed together
// rather than in two lists: the question is "why was I charged for this when
// that was included", and two lists make the reader do the join.
func Explain(ledger []Consumption) []Consumption {
	out := append([]Consumption(nil), ledger...)
	sort.SliceStable(out, func(i, j int) bool {
		if !out[i].RecordedAt.Equal(out[j].RecordedAt) {
			return out[i].RecordedAt.Before(out[j].RecordedAt)
		}
		return out[i].ChargeID < out[j].ChargeID
	})
	return out
}
