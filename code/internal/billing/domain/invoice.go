package domain

import (
	"sort"
	"strings"
	"time"
)

// Estimates, invoices, discounts and corrections
// (SRS-BIL-005, SRS-BIL-006, SRS-BIL-007, SRS-BIL-010, SRS-BIL-014).
//
// The rule that shapes all of it is SRS-BIL-010: a finalised invoice is never
// edited. Not because editing is technically hard, but because the patient is
// holding a copy of it — and a system that can quietly change what a document
// said is a system whose documents prove nothing. A correction is a new
// document that references the old one, which is what every finance department
// already does and what every auditor expects to find.
//
// SRS-BIL-006's "immutable line snapshot and calculation details" is the same
// rule one level down. The lines are copied onto the invoice rather than joined
// to the charges, so a charge voided next week does not restate last week's
// invoice, and the totals are stored rather than summed on read, so a rounding
// rule changed in a future release does not change what the document says.

// DocumentKind distinguishes the financial documents (SRS-BIL-005,
// SRS-BIL-006, SRS-BIL-010).
type DocumentKind string

const (
	// KindEstimate is a quote. Never a demand for payment, and labelled so.
	KindEstimate DocumentKind = "estimate"
	// KindInterim is a running bill on an open account — the one a long-stay
	// patient's family is shown weekly. Supersedable, which is why it is a
	// separate kind rather than a draft final.
	KindInterim DocumentKind = "interim"
	KindFinal   DocumentKind = "final"
	// KindCredit reduces what is owed. SRS-BIL-010's correction workflow.
	KindCredit DocumentKind = "credit_note"
	// KindDebit increases it — an undercharge found after finalising.
	KindDebit DocumentKind = "debit_note"
)

var knownKinds = map[DocumentKind]bool{
	KindEstimate: true, KindInterim: true, KindFinal: true,
	KindCredit: true, KindDebit: true,
}

// Payable reports a document that creates a balance.
//
// An estimate never does, which is the whole of SRS-BIL-005's "labelled
// non-final": a quote that posted to the ledger would be a bill, whatever it
// was called.
func (k DocumentKind) Payable() bool {
	return k == KindInterim || k == KindFinal || k == KindDebit || k == KindCredit
}

// Immutable reports a document that may never be edited (SRS-BIL-010).
func (k DocumentKind) Immutable() bool {
	return k == KindFinal || k == KindCredit || k == KindDebit
}

// InvoiceStatus is where a document stands.
type InvoiceStatus string

const (
	InvoiceDraft InvoiceStatus = "draft"
	// InvoiceIssued is final and out. Nothing about it changes again.
	InvoiceIssued InvoiceStatus = "issued"
	// InvoiceSuperseded is an interim bill replaced by a later one. Kept,
	// because somebody was shown it.
	InvoiceSuperseded InvoiceStatus = "superseded"
	// InvoiceCancelled is a draft abandoned before issue.
	InvoiceCancelled InvoiceStatus = "cancelled"
)

var knownInvoiceStatuses = map[InvoiceStatus]bool{
	InvoiceDraft: true, InvoiceIssued: true,
	InvoiceSuperseded: true, InvoiceCancelled: true,
}

// LiabilityParty is who owes a share (SRS-BIL-014).
type LiabilityParty string

const (
	LiabilityPatient   LiabilityParty = "patient"
	LiabilityPayer     LiabilityParty = "payer"
	LiabilityCorporate LiabilityParty = "corporate"
	// LiabilityScheme is a government or charitable scheme, which is neither an
	// insurer nor an employer and settles on different terms from both.
	LiabilityScheme LiabilityParty = "scheme"
)

var knownParties = map[LiabilityParty]bool{
	LiabilityPatient: true, LiabilityPayer: true,
	LiabilityCorporate: true, LiabilityScheme: true,
}

// LiabilityShare is one party's portion of an invoice (SRS-BIL-014).
//
// Each share carries its own provenance, which is the acceptance criterion:
// "each balance has responsible party and provenance". A patient asking why
// they owe ₹4,000 of a ₹40,000 bill needs the answer, and "the adjudication
// said so" is only an answer if the adjudication is named.
type LiabilityShare struct {
	Party LiabilityParty
	// PartyID is the insurer, employer or scheme. Empty for the patient, who is
	// identified by the invoice.
	PartyID string
	Amount  Money
	// Basis is how the share was arrived at — "policy covers 90% up to
	// ₹500,000", "co-payment per scheme rules", "adjudication ADJ-2026-114".
	Basis string
	// AdjudicationRef points at the payer's decision where there was one.
	AdjudicationRef string
}

// Validate rejects a share nobody could account for.
func (s LiabilityShare) Validate() error {
	if !knownParties[s.Party] {
		return invalidf("unknown responsible party %q", s.Party)
	}
	if s.Party != LiabilityPatient && strings.TrimSpace(s.PartyID) == "" {
		return invalidf("a %s share must name the %s", s.Party, s.Party)
	}
	if strings.TrimSpace(s.Basis) == "" {
		// A share with no stated basis is a number a patient cannot challenge
		// and a payer cannot reconcile.
		return invalidf("a liability share must say how it was arrived at")
	}
	return s.Amount.Validate()
}

// InvoiceLine is one line of a document (SRS-BIL-006).
//
// A snapshot, not a reference. Every value a reader needs is copied on at issue
// time, so the document says the same thing in five years as it did on the day
// — whatever has happened to the charge master, the tariff or the charge.
type InvoiceLine struct {
	Sequence int32
	// ChargeID points back for audit. The line does not depend on it.
	ChargeID    string
	ServiceCode string
	Description string
	Department  string
	Quantity    int32
	UnitPrice   Money
	// Net, Tax and Total are stored rather than computed on read, which is what
	// "calculation details" means: a rounding rule changed in a future release
	// must not change what this document says.
	Net      Money
	TaxCode  string
	TaxRate  BasisPoints
	Tax      Money
	Discount Money
	Total    Money
	// PackageCode and CoverageNote explain a line a package touched
	// (SRS-BIL-004).
	PackageCode  string
	CoverageNote string
}

// Discount is a concession applied to a document (SRS-BIL-007).
type Discount struct {
	// Rate or Amount, never both: a discount expressed two ways is two numbers
	// that disagree the first time the subtotal changes.
	Rate   BasisPoints
	Amount Money
	Reason string
	// AppliedBy is who applied it, and ApprovedBy whoever authorised it beyond
	// their limit. Both, because the control SRS-BIL-007 asks for is the
	// distinction: a biller giving 5% within their limit and a manager
	// approving 40% are different events.
	AppliedBy  string
	ApprovedBy string
	AppliedAt  time.Time
	// ApprovalRef points at the approval workflow's record where one was
	// needed.
	ApprovalRef string
}

// Validate rejects a discount that could not be defended.
func (d Discount) Validate() error {
	hasRate := d.Rate != 0
	hasAmount := d.Amount.Minor != 0
	switch {
	case hasRate == hasAmount:
		return invalidf("a discount is either a rate or an amount, not both or neither")
	case strings.TrimSpace(d.Reason) == "":
		// A discount with no reason is money given away that nobody can
		// account for, which is the single commonest revenue leak in a
		// hospital.
		return invalidf("a discount needs a reason")
	case strings.TrimSpace(d.AppliedBy) == "":
		return invalidf("a discount needs the person applying it")
	}
	if hasRate {
		return d.Rate.Validate()
	}
	if d.Amount.Minor < 0 {
		return invalidf("a discount amount cannot be negative")
	}
	return d.Amount.Validate()
}

// Compute resolves a discount to an amount against a subtotal.
func (d Discount) Compute(subtotal Money) Money {
	if d.Rate != 0 {
		return d.Rate.Apply(subtotal)
	}
	return Money{Minor: d.Amount.Minor, Currency: subtotal.Currency}
}

// DiscountLimit is what a role may give without approval (SRS-BIL-007).
type DiscountLimit struct {
	// MaxRate is the largest percentage. Zero means none may be given.
	MaxRate BasisPoints
	// MaxAmount caps the absolute concession, because 5% of a
	// half-million-rupee bill is not a small decision even though the rate is.
	MaxAmount Money
}

// Within reports whether a discount falls inside a limit.
func (l DiscountLimit) Within(d Discount, subtotal Money) bool {
	amount := d.Compute(subtotal)
	if d.Rate != 0 && d.Rate > l.MaxRate {
		return false
	}
	if !l.MaxAmount.Zero() && amount.Minor > l.MaxAmount.Minor {
		// Both bounds apply. A rate inside the percentage limit can still be an
		// amount well beyond what the role was trusted with.
		return false
	}
	if d.Rate == 0 && l.MaxAmount.Zero() {
		// A flat discount against a limit that states only a rate: express it
		// as a rate against this subtotal and check that.
		if subtotal.Minor == 0 {
			return false
		}
		implied := BasisPoints(amount.Minor * 10000 / subtotal.Minor)
		return implied <= l.MaxRate
	}
	return true
}

// Invoice is a financial document (SRS-BIL-005, SRS-BIL-006).
type Invoice struct {
	ID       string
	TenantID string
	// Number is what the patient quotes. Issued from the platform's sequence,
	// so it is gapless and collision-free — a finance department's first
	// question about a numbering scheme.
	Number string

	Kind   DocumentKind
	Status InvoiceStatus

	PatientID   string
	EncounterID string
	FacilityID  string
	AccountID   string

	// Version is SRS-BIL-005's "versioned": an estimate re-quoted after the
	// plan changes is a new version of the same estimate, and the patient was
	// shown the old one.
	Version int32
	// SupersededBy points at the document that replaced this one.
	SupersededBy string
	// CorrectsInvoiceID points at the document a credit or debit note corrects
	// (SRS-BIL-010).
	CorrectsInvoiceID string

	Lines []InvoiceLine

	Subtotal Money
	Discount Money
	Tax      Money
	Total    Money

	Discounts []Discount
	// Liability is the split after adjudication (SRS-BIL-014). Empty means the
	// whole of it is the patient's, which is the common case and is recorded
	// explicitly at issue rather than implied.
	Liability []LiabilityShare

	// PayerID and CustomerID are what it was priced against.
	PayerID    string
	CustomerID string

	Notes string

	IssuedBy   string
	IssuedAt   time.Time
	CreatedBy  string
	CreatedAt  time.Time
	UpdatedAt  time.Time
	RowVersion int64
}

// NewInvoice starts a document in draft.
func NewInvoice(id, tenantID, number string, kind DocumentKind,
	patientID, encounterID, facilityID, accountID, createdBy string,
	now time.Time) (*Invoice, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return nil, invalidf("a document needs an identifier")
	case strings.TrimSpace(number) == "":
		return nil, invalidf("a document needs a number")
	case !knownKinds[kind]:
		return nil, invalidf("unknown document kind %q", kind)
	case strings.TrimSpace(patientID) == "":
		return nil, invalidf("a document needs a patient")
	case strings.TrimSpace(accountID) == "":
		return nil, invalidf("a document needs an account")
	case strings.TrimSpace(createdBy) == "":
		return nil, invalidf("a document needs the person raising it")
	}

	return &Invoice{
		ID: id, TenantID: tenantID, Number: number,
		Kind: kind, Status: InvoiceDraft,
		PatientID:   strings.TrimSpace(patientID),
		EncounterID: strings.TrimSpace(encounterID),
		FacilityID:  strings.TrimSpace(facilityID),
		AccountID:   strings.TrimSpace(accountID),
		Version:     1,
		CreatedBy:   strings.TrimSpace(createdBy),
		CreatedAt:   now.UTC(), UpdatedAt: now.UTC(),
		RowVersion: 1,
	}, nil
}

// AddCharges snapshots charges onto the document (SRS-BIL-006).
//
// A snapshot rather than a join, which is what makes the document immutable in
// the way that matters: a charge voided next week does not restate what this
// invoice said, because the invoice does not read the charge any more.
func (i *Invoice) AddCharges(charges []*Charge) error {
	if i.Status != InvoiceDraft {
		return notAllowedf("a %s document cannot take more lines", i.Status)
	}

	SortCharges(charges)
	for _, charge := range charges {
		if !charge.Status.Billable() {
			return notAllowedf("charge %s is %s and cannot be invoiced",
				charge.ID, charge.Status)
		}
		if charge.Covered {
			// Absorbed by a package. It belongs on the consumption ledger, not
			// on the bill, and putting it on with a zero total would tell the
			// patient they were charged nothing for something they were in fact
			// charged for through the package price.
			continue
		}

		i.Lines = append(i.Lines, InvoiceLine{
			Sequence: int32(len(i.Lines) + 1),
			ChargeID: charge.ID, ServiceCode: charge.ServiceCode,
			Description: charge.Description, Department: charge.Department,
			Quantity: charge.Quantity, UnitPrice: charge.UnitPrice,
			Net:     charge.Net(),
			TaxCode: charge.TaxCode, TaxRate: charge.TaxRate, Tax: charge.Tax(),
			Total:        charge.Total(),
			PackageCode:  charge.PackageID,
			CoverageNote: charge.CoverageNote,
		})
	}
	return i.recompute()
}

// AddLine puts a line on directly, for a package price or a credit note.
func (i *Invoice) AddLine(line InvoiceLine) error {
	if i.Status != InvoiceDraft {
		return notAllowedf("a %s document cannot take more lines", i.Status)
	}
	line.Sequence = int32(len(i.Lines) + 1)
	i.Lines = append(i.Lines, line)
	return i.recompute()
}

// ApplyDiscount records a concession (SRS-BIL-007).
//
// The limit check is the caller's, because what a person may give is an
// authorization question and the domain does not know who is asking. What this
// enforces is that the discount is well-formed and that a document already
// issued takes none.
func (i *Invoice) ApplyDiscount(d Discount, now time.Time) error {
	if i.Status != InvoiceDraft {
		return notAllowedf("a %s document cannot be discounted", i.Status)
	}
	if err := d.Validate(); err != nil {
		return err
	}
	d.AppliedAt = now.UTC()
	i.Discounts = append(i.Discounts, d)
	return i.recompute()
}

// SetLiability records the split after adjudication (SRS-BIL-014).
func (i *Invoice) SetLiability(shares []LiabilityShare) error {
	if i.Status != InvoiceDraft {
		return notAllowedf("a %s document's liability cannot be changed", i.Status)
	}

	total := Money{}
	for _, share := range shares {
		if err := share.Validate(); err != nil {
			return err
		}
		next, err := total.Add(share.Amount)
		if err != nil {
			return err
		}
		total = next
	}
	if len(shares) > 0 && total.Minor != i.Total.Minor {
		// A split that does not add up to the bill leaves a remainder nobody
		// owes and nobody collects, which is how a receivables ledger quietly
		// stops reconciling.
		return invalidf("the split comes to %s but the document totals %s",
			total, i.Total)
	}

	i.Liability = shares
	return nil
}

// recompute rolls the lines and discounts into the totals.
func (i *Invoice) recompute() error {
	subtotal := Money{}
	tax := Money{}
	for _, line := range i.Lines {
		next, err := subtotal.Add(line.Net)
		if err != nil {
			return err
		}
		subtotal = next
		next, err = tax.Add(line.Tax)
		if err != nil {
			return err
		}
		tax = next
	}

	discount := Money{Minor: 0, Currency: subtotal.Currency}
	for _, d := range i.Discounts {
		amount := d.Compute(subtotal)
		next, err := discount.Add(amount)
		if err != nil {
			return err
		}
		discount = next
	}
	if discount.Minor > subtotal.Minor {
		// A discount larger than the bill would produce a negative invoice,
		// which is a refund wearing the wrong document's name.
		return invalidf("the discount of %s is more than the subtotal of %s",
			discount, subtotal)
	}

	i.Subtotal = subtotal
	i.Discount = discount
	i.Tax = tax
	i.Total = Money{
		Minor:    subtotal.Minor - discount.Minor + tax.Minor,
		Currency: subtotal.Currency,
	}
	return nil
}

// Issue finalises a document (SRS-BIL-006, SRS-BIL-010).
//
// After this nothing about it changes. The caller writes it inside the same
// transaction that marks its charges invoiced, so a document can never exist
// referring to charges still on the unbilled worklist.
func (i *Invoice) Issue(by string, now time.Time) error {
	if i.Status != InvoiceDraft {
		return notAllowedf("this document is already %s", i.Status)
	}
	if strings.TrimSpace(by) == "" {
		return invalidf("issuing a document needs the person doing it")
	}
	if len(i.Lines) == 0 {
		return invalidf("a document with no lines cannot be issued")
	}
	if i.Kind == KindFinal && len(i.Liability) == 0 {
		// SRS-BIL-014: every balance has a responsible party. The common case —
		// the patient owes all of it — is recorded rather than implied, so a
		// receivables report never has to guess who to chase.
		i.Liability = []LiabilityShare{{
			Party: LiabilityPatient, Amount: i.Total,
			Basis: "no payer adjudication; the patient is liable for the whole amount",
		}}
	}

	i.Status = InvoiceIssued
	i.IssuedBy = strings.TrimSpace(by)
	i.IssuedAt = now.UTC()
	i.UpdatedAt = now.UTC()
	i.RowVersion++
	return nil
}

// Supersede marks an interim bill replaced by a later one.
func (i *Invoice) Supersede(byInvoiceID string, now time.Time) error {
	if i.Kind != KindInterim && i.Kind != KindEstimate {
		// A final invoice is corrected, never replaced: the patient holds it.
		return notAllowedf("a %s document is corrected rather than superseded", i.Kind)
	}
	if i.Status == InvoiceSuperseded {
		return nil
	}
	i.Status = InvoiceSuperseded
	i.SupersededBy = byInvoiceID
	i.UpdatedAt = now.UTC()
	i.RowVersion++
	return nil
}

// Correct builds the credit or debit note that corrects this document
// (SRS-BIL-010).
//
// A new document rather than an edit. The patient is holding a copy of the
// original, and a system that can quietly change what a document said is a
// system whose documents prove nothing.
func (i *Invoice) Correct(id, number string, kind DocumentKind, lines []InvoiceLine,
	reason, by string, now time.Time) (*Invoice, error) {

	if !i.Kind.Immutable() || i.Status != InvoiceIssued {
		return nil, notAllowedf(
			"only an issued final document is corrected by a note; this one is a %s %s",
			i.Status, i.Kind)
	}
	if kind != KindCredit && kind != KindDebit {
		return nil, invalidf("a correction is a credit note or a debit note, not a %s", kind)
	}
	if strings.TrimSpace(reason) == "" {
		return nil, invalidf("a correction needs a reason")
	}
	if len(lines) == 0 {
		return nil, invalidf("a correction needs at least one line")
	}

	note, err := NewInvoice(id, i.TenantID, number, kind, i.PatientID,
		i.EncounterID, i.FacilityID, i.AccountID, by, now)
	if err != nil {
		return nil, err
	}
	note.CorrectsInvoiceID = i.ID
	note.PayerID, note.CustomerID = i.PayerID, i.CustomerID
	note.Notes = reason

	for _, line := range lines {
		if err := note.AddLine(line); err != nil {
			return nil, err
		}
	}
	return note, nil
}

// SignedTotal is what a document moves on the account ledger.
//
// A credit note reduces what is owed, so it posts negative. Expressed as a sign
// on the amount rather than as a direction flag, because every sum over the
// ledger would otherwise have to remember to consult the flag — and the one
// that forgets is the one that reports a balance twice the truth.
func (i *Invoice) SignedTotal() Money {
	if i.Kind == KindCredit {
		return i.Total.Negate()
	}
	return i.Total
}

// SortInvoices orders documents oldest first.
func SortInvoices(invoices []*Invoice) {
	sort.SliceStable(invoices, func(a, b int) bool {
		if !invoices[a].CreatedAt.Equal(invoices[b].CreatedAt) {
			return invoices[a].CreatedAt.Before(invoices[b].CreatedAt)
		}
		return invoices[a].Number < invoices[b].Number
	})
}
