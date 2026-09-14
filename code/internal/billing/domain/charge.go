package domain

import (
	"sort"
	"strings"
	"time"
)

// Charges and package consumption (SRS-BIL-003, SRS-BIL-004).
//
// SRS-BIL-003's acceptance has two halves and the second is the harder one:
// "every charge has source/provenance and cannot be silently duplicated". A
// clinical event reaching the biller twice — a bus redelivery, a retried RPC, a
// nurse tapping twice — must produce one charge. That is held by a uniqueness
// constraint on the source reference rather than by a check, because the two
// deliveries can be in flight at the same moment.
//
// SRS-BIL-004's is subtler: a package explains "billed/not billed items". A
// consumption ledger that only recorded what a package covered would leave the
// patient unable to see why the third scan was charged when the first two were
// not. So every consumption is recorded, covered or not, with the reason.

// ChargeOrigin is where a charge came from (SRS-BIL-003).
type ChargeOrigin string

const (
	// OriginClinicalEvent is a charge raised from something that happened —
	// an order completed, a dose given, a bed occupied.
	OriginClinicalEvent ChargeOrigin = "clinical_event"
	// OriginManual is a biller keying one in. Allowed, and audited harder: a
	// manual charge is the path round every automated control, so it carries
	// who entered it and why.
	OriginManual ChargeOrigin = "manual"
	// OriginRecurring is a charge a scheduled process raises — a daily bed
	// charge.
	OriginRecurring ChargeOrigin = "recurring"
)

var knownOrigins = map[ChargeOrigin]bool{
	OriginClinicalEvent: true, OriginManual: true, OriginRecurring: true,
}

// SourceReference identifies what a charge came from (SRS-BIL-003).
//
// System and identifier together, because an order identifier and a medication
// administration identifier can collide and the two are different events. This
// pair is the idempotency key: a redelivered event produces no second charge.
type SourceReference struct {
	// System is the context that raised it — "orders", "nursing", "scheduling".
	System string
	// ID is that context's own identifier for the event.
	ID string
	// Detail names the record a biller follows back — an order number a ward
	// reads down a phone. SRS-BIL-011 asks the revenue-integrity worklist to
	// "link to source record", and an opaque identifier is not a link anybody
	// can follow.
	Detail string
}

// Key is the idempotency key for a charge's source.
func (s SourceReference) Key() string {
	return strings.ToLower(strings.TrimSpace(s.System)) + "|" +
		strings.TrimSpace(s.ID)
}

// Empty reports a reference nobody filled in.
func (s SourceReference) Empty() bool {
	return strings.TrimSpace(s.System) == "" || strings.TrimSpace(s.ID) == ""
}

// ChargeStatus is where a charge stands.
type ChargeStatus string

const (
	// ChargePosted is on the ledger and billable.
	ChargePosted ChargeStatus = "posted"
	// ChargeInvoiced has been carried onto an invoice. Kept distinct from
	// posted so SRS-BIL-011's unbilled worklist is a query rather than a join
	// against every invoice line.
	ChargeInvoiced ChargeStatus = "invoiced"
	// ChargeVoided was raised in error. The row stays: SRS-BIL-010's reasoning
	// applies to charges as much as to invoices, and a charge that vanished
	// would leave an invoice total nobody can rebuild.
	ChargeVoided ChargeStatus = "voided"
	// ChargeHeld is waiting on something — a coding query, an authorisation.
	// SRS-BIL-011's "pending charge exceptions".
	ChargeHeld ChargeStatus = "held"
)

var knownChargeStatuses = map[ChargeStatus]bool{
	ChargePosted: true, ChargeInvoiced: true, ChargeVoided: true, ChargeHeld: true,
}

// Billable reports a charge that should reach an invoice.
func (s ChargeStatus) Billable() bool { return s == ChargePosted }

// Charge is one billable item on an account (SRS-BIL-003).
type Charge struct {
	ID       string
	TenantID string

	PatientID   string
	EncounterID string
	FacilityID  string
	// AccountID is the financial account this belongs to. An encounter has one;
	// SRS-BIL-013 closes it.
	AccountID string

	ServiceCode string
	// Description is copied from the service version in force at charge time,
	// so a master edited afterwards does not restate what was charged
	// (SRS-BIL-001).
	Description    string
	Department     string
	RevenueAccount string

	Quantity int32
	// UnitPrice is what the tariff resolved to, and Pricing says which contract
	// produced it. Both stored rather than recomputed: "which tariff was
	// applied" is the first question of a payer dispute, and recomputing would
	// answer with today's contracts.
	UnitPrice Money
	Pricing   PricingResult

	TaxCode      string
	TaxRate      BasisPoints
	TaxInclusive bool

	Origin ChargeOrigin
	Source SourceReference
	// EnteredBy is set on a manual charge. Empty on an automatic one, where the
	// source reference is the provenance.
	EnteredBy string
	// Reason explains a manual charge or a hold.
	Reason string

	// OccurredAt is when the service was delivered, which is what the master
	// and the tariff are resolved against. Distinct from PostedAt: a charge
	// keyed three days later is still priced at the day of care.
	OccurredAt time.Time
	PostedAt   time.Time

	Status ChargeStatus
	// PackageID and Covered record what a package did with this charge
	// (SRS-BIL-004).
	PackageID string
	Covered   bool
	// CoverageNote says why a charge inside a package's scope was billed
	// anyway — the quantity cap was reached, it was a named exclusion.
	CoverageNote string

	InvoiceID string
	Version   int64
}

// NewChargeInput is what raising a charge needs.
type NewChargeInput struct {
	PatientID   string
	EncounterID string
	FacilityID  string
	AccountID   string

	Service  ServiceItem
	Quantity int32
	Pricing  PricingResult

	Origin    ChargeOrigin
	Source    SourceReference
	EnteredBy string
	Reason    string

	OccurredAt time.Time
}

// NewCharge raises a charge with its provenance (SRS-BIL-003).
//
// The service version and the tariff result are passed in rather than looked up
// here, because both are resolved as of OccurredAt and the domain does not read
// tables. What this enforces is that neither is missing: a charge with no
// service version is one nobody can account for, and a charge with no tariff is
// a price somebody invented.
func NewCharge(id, tenantID string, in NewChargeInput, now time.Time) (*Charge, error) {
	switch {
	case strings.TrimSpace(id) == "":
		return nil, invalidf("a charge needs an identifier")
	case strings.TrimSpace(in.PatientID) == "":
		return nil, invalidf("a charge needs a patient")
	case strings.TrimSpace(in.AccountID) == "":
		return nil, invalidf("a charge needs an account")
	case !knownOrigins[in.Origin]:
		return nil, invalidf("unknown charge origin %q", in.Origin)
	case in.Quantity <= 0:
		return nil, invalidf("a charge needs a quantity greater than zero")
	}

	if err := in.Service.Validate(); err != nil {
		return nil, err
	}
	if err := in.Pricing.Price.Validate(); err != nil {
		return nil, err
	}

	switch in.Origin {
	case OriginManual:
		// The path round every automated control, so it names who took it and
		// why. A manual charge with no author is revenue nobody is answerable
		// for.
		if strings.TrimSpace(in.EnteredBy) == "" {
			return nil, invalidf("a manual charge needs the person entering it")
		}
		if strings.TrimSpace(in.Reason) == "" {
			return nil, invalidf("a manual charge needs a reason")
		}
	default:
		if in.Source.Empty() {
			// Without this the idempotency key is empty and two deliveries of
			// one event become two charges.
			return nil, invalidf("an automatic charge needs a source reference")
		}
	}

	occurred := in.OccurredAt
	if occurred.IsZero() {
		occurred = now
	}
	if !in.Service.ActiveAt(occurred) {
		return nil, invalidf("service %q was not in force on %s",
			in.Service.Code, occurred.UTC().Format("2006-01-02"))
	}

	return &Charge{
		ID: id, TenantID: tenantID,
		PatientID:   strings.TrimSpace(in.PatientID),
		EncounterID: strings.TrimSpace(in.EncounterID),
		FacilityID:  strings.TrimSpace(in.FacilityID),
		AccountID:   strings.TrimSpace(in.AccountID),

		ServiceCode: in.Service.Code, Description: in.Service.Description,
		Department: in.Service.Department, RevenueAccount: in.Service.RevenueAccount,

		Quantity: in.Quantity, UnitPrice: in.Pricing.Price, Pricing: in.Pricing,

		TaxCode: in.Service.TaxCode, TaxRate: in.Service.TaxRate,
		TaxInclusive: in.Service.TaxInclusive,

		Origin: in.Origin, Source: in.Source,
		EnteredBy: strings.TrimSpace(in.EnteredBy),
		Reason:    strings.TrimSpace(in.Reason),

		OccurredAt: occurred.UTC(), PostedAt: now.UTC(),
		Status: ChargePosted, Covered: false,
		Version: 1,
	}, nil
}

// Net is the charge before tax.
func (c *Charge) Net() Money {
	if c.Covered {
		// A covered charge contributes nothing to the invoice; it is on the
		// ledger so the package can explain what it absorbed.
		return Money{Minor: 0, Currency: c.UnitPrice.Currency}
	}
	gross := c.UnitPrice.Times(c.Quantity)
	if !c.TaxInclusive {
		return gross
	}
	// Quoted inclusive: the net is the gross less the tax it already contains.
	// Computed by dividing out rather than by applying the rate to the gross,
	// because 18% of an inclusive total is not the tax inside it.
	return Money{
		Minor:    gross.Minor - taxWithin(gross, c.TaxRate).Minor,
		Currency: gross.Currency,
	}
}

// Tax is the tax on the charge.
func (c *Charge) Tax() Money {
	if c.Covered {
		return Money{Minor: 0, Currency: c.UnitPrice.Currency}
	}
	gross := c.UnitPrice.Times(c.Quantity)
	if c.TaxInclusive {
		return taxWithin(gross, c.TaxRate)
	}
	return c.TaxRate.Apply(gross)
}

// Total is what the charge adds to an invoice.
func (c *Charge) Total() Money {
	net := c.Net()
	tax := c.Tax()
	return Money{Minor: net.Minor + tax.Minor, Currency: net.Currency}
}

// taxWithin extracts the tax already contained in an inclusive amount.
//
// gross * rate / (10000 + rate), rounded half away from zero. The naive
// alternative — applying the rate to the gross — overstates the tax by the tax
// on the tax, which on an 18% rate is about three per cent of every inclusive
// line.
func taxWithin(gross Money, rate BasisPoints) Money {
	if rate == 0 || gross.Minor == 0 {
		return Money{Minor: 0, Currency: gross.Currency}
	}
	numerator := gross.Minor * int64(rate)
	denominator := int64(10000) + int64(rate)
	quotient := numerator / denominator
	remainder := numerator % denominator
	if remainder*2 >= denominator {
		quotient++
	} else if remainder*2 <= -denominator {
		quotient--
	}
	return Money{Minor: quotient, Currency: gross.Currency}
}

// Void marks a charge raised in error (SRS-BIL-010).
//
// The row stays. A charge that vanished would leave an invoice total nobody can
// rebuild, and "this was never charged" and "this was charged and reversed" are
// different statements about the same patient.
func (c *Charge) Void(by, reason string, now time.Time) error {
	if strings.TrimSpace(reason) == "" {
		return invalidf("voiding a charge needs a reason")
	}
	if strings.TrimSpace(by) == "" {
		return invalidf("voiding a charge needs the person doing it")
	}
	if c.Status == ChargeInvoiced {
		// Already on a finalised invoice. Correcting it is a credit note, not a
		// void, because the invoice the patient holds says otherwise.
		return notAllowedf(
			"this charge is on invoice %s; correct it with a credit note", c.InvoiceID)
	}
	if c.Status == ChargeVoided {
		return nil
	}
	c.Status = ChargeVoided
	c.Reason = strings.TrimSpace(reason)
	c.EnteredBy = strings.TrimSpace(by)
	c.Version++
	return nil
}

// Hold parks a charge pending a query (SRS-BIL-011).
func (c *Charge) Hold(reason string) error {
	if strings.TrimSpace(reason) == "" {
		return invalidf("holding a charge needs a reason")
	}
	if c.Status != ChargePosted {
		return notAllowedf("only a posted charge can be held; this one is %s", c.Status)
	}
	c.Status = ChargeHeld
	c.Reason = strings.TrimSpace(reason)
	c.Version++
	return nil
}

// Release returns a held charge to the billable set.
func (c *Charge) Release() error {
	if c.Status != ChargeHeld {
		return notAllowedf("only a held charge can be released; this one is %s", c.Status)
	}
	c.Status = ChargePosted
	c.Version++
	return nil
}

// MarkInvoiced records that a charge reached an invoice.
func (c *Charge) MarkInvoiced(invoiceID string) error {
	if c.Status != ChargePosted {
		return notAllowedf("a %s charge cannot be invoiced", c.Status)
	}
	c.Status = ChargeInvoiced
	c.InvoiceID = invoiceID
	c.Version++
	return nil
}

// SortCharges orders a ledger for display and for invoicing, most recent last.
func SortCharges(charges []*Charge) {
	sort.SliceStable(charges, func(i, j int) bool {
		if !charges[i].OccurredAt.Equal(charges[j].OccurredAt) {
			return charges[i].OccurredAt.Before(charges[j].OccurredAt)
		}
		return charges[i].ID < charges[j].ID
	})
}
