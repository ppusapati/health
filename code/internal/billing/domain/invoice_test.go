package domain_test

import (
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/billing/domain"
)

func newInvoice(t *testing.T, kind domain.DocumentKind) *domain.Invoice {
	t.Helper()
	i, err := domain.NewInvoice("inv1", "t1", "INV-000001", kind,
		"p1", "e1", "f1", "acc1", "biller-1", day(2026, time.March, 10))
	if err != nil {
		t.Fatalf("NewInvoice: %v", err)
	}
	return i
}

func billableCharge(t *testing.T, code, description string, price int64,
	quantity int32) *domain.Charge {

	t.Helper()
	in := chargeInput(service(code, description, 1800, false), quantity)
	in.Pricing = pricing(price)
	in.Source = domain.SourceReference{System: "orders", ID: code}
	return newCharge(t, in)
}

// SRS-BIL-006: the invoice stores an immutable snapshot, so a charge changed
// afterwards does not restate what the document said.
func TestAnIssuedInvoiceDoesNotChangeWhenItsChargesDo(t *testing.T) {
	charge := billableCharge(t, "XR-CHEST", "Chest X-ray", 100000, 1)
	i := newInvoice(t, domain.KindFinal)
	if err := i.AddCharges([]*domain.Charge{charge}); err != nil {
		t.Fatalf("AddCharges: %v", err)
	}
	if err := i.Issue("biller-1", day(2026, time.March, 10)); err != nil {
		t.Fatalf("Issue: %v", err)
	}

	before := i.Total
	// The charge's description and price change afterwards; the invoice must
	// not follow.
	charge.Description = "Chest X-ray (revised)"
	charge.UnitPrice = inr(500000)

	if i.Lines[0].Description != "Chest X-ray" {
		t.Fatalf("the line followed the charge: %q", i.Lines[0].Description)
	}
	if i.Total.Minor != before.Minor {
		t.Fatalf("the total moved from %d to %d", before.Minor, i.Total.Minor)
	}
}

// SRS-BIL-006: the calculation details are on the document.
func TestTheInvoiceCarriesItsOwnArithmetic(t *testing.T) {
	i := newInvoice(t, domain.KindFinal)
	if err := i.AddCharges([]*domain.Charge{
		billableCharge(t, "XR-CHEST", "Chest X-ray", 100000, 2),
		billableCharge(t, "CONS-OP", "Consultation", 50000, 1),
	}); err != nil {
		t.Fatalf("AddCharges: %v", err)
	}

	if i.Subtotal.Minor != 250000 {
		t.Fatalf("subtotal = %d", i.Subtotal.Minor)
	}
	if i.Tax.Minor != 45000 {
		t.Fatalf("tax = %d, want 18%% of 2500.00", i.Tax.Minor)
	}
	if i.Total.Minor != 295000 {
		t.Fatalf("total = %d", i.Total.Minor)
	}
	for _, line := range i.Lines {
		if line.Net.Minor+line.Tax.Minor != line.Total.Minor {
			t.Fatalf("line %d does not add up: %+v", line.Sequence, line)
		}
	}
}

// SRS-BIL-010: a finalised invoice is never edited.
func TestAnIssuedInvoiceTakesNoMoreLinesOrDiscounts(t *testing.T) {
	i := newInvoice(t, domain.KindFinal)
	_ = i.AddCharges([]*domain.Charge{billableCharge(t, "XR-CHEST", "Chest X-ray", 100000, 1)})
	if err := i.Issue("biller-1", day(2026, time.March, 10)); err != nil {
		t.Fatalf("Issue: %v", err)
	}

	if err := i.AddCharges([]*domain.Charge{
		billableCharge(t, "CONS-OP", "Consultation", 50000, 1),
	}); !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("a line was added to an issued invoice: %v", err)
	}
	if err := i.ApplyDiscount(domain.Discount{
		Rate: 500, Reason: "goodwill", AppliedBy: "biller-1",
	}, day(2026, time.March, 11)); !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("an issued invoice was discounted: %v", err)
	}
	if err := i.Issue("biller-1", day(2026, time.March, 11)); !errors.Is(
		err, domain.ErrNotAllowed) {
		t.Fatalf("an invoice was issued twice: %v", err)
	}
}

// SRS-BIL-010: a correction is a credit note referencing the original.
func TestACorrectionIsACreditNoteThatNamesTheOriginal(t *testing.T) {
	i := newInvoice(t, domain.KindFinal)
	_ = i.AddCharges([]*domain.Charge{billableCharge(t, "XR-CHEST", "Chest X-ray", 100000, 1)})
	_ = i.Issue("biller-1", day(2026, time.March, 10))

	note, err := i.Correct("cn1", "CN-000001", domain.KindCredit,
		[]domain.InvoiceLine{{
			Description: "Chest X-ray charged in error",
			Quantity:    1, UnitPrice: inr(100000),
			Net: inr(100000), Tax: inr(18000), Total: inr(118000),
		}}, "the scan was cancelled before it was performed", "biller-2",
		day(2026, time.March, 12))
	if err != nil {
		t.Fatalf("Correct: %v", err)
	}

	if note.CorrectsInvoiceID != i.ID {
		t.Fatal("the credit note does not name the invoice it corrects")
	}
	if note.Notes == "" {
		t.Fatal("the credit note carries no reason")
	}
	// It reduces what is owed.
	if !note.SignedTotal().Negative() {
		t.Fatalf("a credit note posted %s, want a negative movement", note.SignedTotal())
	}
	if i.Total.Minor != 118000 {
		t.Fatal("correcting changed the original invoice")
	}
}

func TestACorrectionNeedsAReasonAndAtLeastOneLine(t *testing.T) {
	i := newInvoice(t, domain.KindFinal)
	_ = i.AddCharges([]*domain.Charge{billableCharge(t, "XR-CHEST", "Chest X-ray", 100000, 1)})
	_ = i.Issue("biller-1", day(2026, time.March, 10))

	line := domain.InvoiceLine{Description: "x", Net: inr(100), Total: inr(100)}
	if _, err := i.Correct("cn1", "CN-1", domain.KindCredit,
		[]domain.InvoiceLine{line}, "", "biller-2",
		day(2026, time.March, 12)); !errors.Is(err, domain.ErrInvalid) {
		t.Fatalf("a reasonless correction was accepted: %v", err)
	}
	if _, err := i.Correct("cn1", "CN-1", domain.KindCredit, nil, "why", "biller-2",
		day(2026, time.March, 12)); !errors.Is(err, domain.ErrInvalid) {
		t.Fatalf("an empty correction was accepted: %v", err)
	}
	if _, err := i.Correct("cn1", "CN-1", domain.KindFinal,
		[]domain.InvoiceLine{line}, "why", "biller-2",
		day(2026, time.March, 12)); !errors.Is(err, domain.ErrInvalid) {
		t.Fatalf("a correction was raised as a final invoice: %v", err)
	}
}

// A draft cannot be corrected: it is edited.
func TestADraftIsEditedRatherThanCorrected(t *testing.T) {
	i := newInvoice(t, domain.KindFinal)
	_ = i.AddCharges([]*domain.Charge{billableCharge(t, "XR-CHEST", "Chest X-ray", 100000, 1)})

	line := domain.InvoiceLine{Description: "x", Net: inr(100), Total: inr(100)}
	if _, err := i.Correct("cn1", "CN-1", domain.KindCredit,
		[]domain.InvoiceLine{line}, "why", "biller-2",
		day(2026, time.March, 12)); !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("a draft was corrected by a note: %v", err)
	}
}

// SRS-BIL-005: an estimate is labelled non-final and creates no balance.
func TestAnEstimateCreatesNoBalance(t *testing.T) {
	if domain.KindEstimate.Payable() {
		t.Fatal("an estimate is payable; it would post to the ledger as a bill")
	}
	if domain.KindEstimate.Immutable() {
		t.Fatal("an estimate is immutable; it could not be re-quoted")
	}
	for _, kind := range []domain.DocumentKind{
		domain.KindFinal, domain.KindCredit, domain.KindDebit,
	} {
		if !kind.Immutable() {
			t.Fatalf("%s is editable after issue", kind)
		}
	}
}

// SRS-BIL-005: an estimate is versioned, and a superseded one is kept.
func TestAnEstimateIsSupersededRatherThanOverwritten(t *testing.T) {
	e := newInvoice(t, domain.KindEstimate)
	_ = e.AddCharges([]*domain.Charge{billableCharge(t, "XR-CHEST", "Chest X-ray", 100000, 1)})

	if err := e.Supersede("est2", day(2026, time.March, 11)); err != nil {
		t.Fatalf("Supersede: %v", err)
	}
	if e.SupersededBy != "est2" {
		t.Fatal("the estimate does not point at its replacement")
	}
}

// A final invoice is corrected, never superseded: the patient holds it.
func TestAFinalInvoiceIsNotSuperseded(t *testing.T) {
	i := newInvoice(t, domain.KindFinal)
	if err := i.Supersede("inv2", day(2026, time.March, 11)); !errors.Is(
		err, domain.ErrNotAllowed) {
		t.Fatalf("a final invoice was superseded: %v", err)
	}
}

// SRS-BIL-007: a discount needs a reason and an author.
func TestADiscountNeedsAReasonAndAnAuthor(t *testing.T) {
	for name, d := range map[string]domain.Discount{
		"no reason": {Rate: 500, AppliedBy: "biller-1"},
		"no author": {Rate: 500, Reason: "goodwill"},
		"both rate and amount": {
			Rate: 500, Amount: inr(1000), Reason: "goodwill", AppliedBy: "biller-1",
		},
		"neither": {Reason: "goodwill", AppliedBy: "biller-1"},
	} {
		t.Run(name, func(t *testing.T) {
			if err := d.Validate(); !errors.Is(err, domain.ErrInvalid) {
				t.Fatalf("%s accepted: %v", name, err)
			}
		})
	}
}

// SRS-BIL-007: both bounds of a limit apply.
func TestADiscountLimitBoundsBothTheRateAndTheAmount(t *testing.T) {
	limit := domain.DiscountLimit{MaxRate: 1000, MaxAmount: inr(500000)}
	small := domain.Discount{Rate: 500, Reason: "goodwill", AppliedBy: "biller-1"}

	if !limit.Within(small, inr(100000)) {
		t.Fatal("5% of 1000.00 was outside a 10% limit")
	}
	// The same rate on a much larger bill breaches the absolute cap: 5% of
	// 500,000.00 is 25,000.00, well beyond what the role was trusted with.
	if limit.Within(small, inr(50000000)) {
		t.Fatal("a rate inside the percentage limit passed an amount far beyond it")
	}

	steep := domain.Discount{Rate: 4000, Reason: "goodwill", AppliedBy: "biller-1"}
	if limit.Within(steep, inr(100000)) {
		t.Fatal("40% passed a 10% limit")
	}
}

// A flat discount is checked against a rate-only limit by implying the rate.
func TestAFlatDiscountIsCheckedAgainstARateOnlyLimit(t *testing.T) {
	limit := domain.DiscountLimit{MaxRate: 1000}
	within := domain.Discount{Amount: inr(5000), Reason: "goodwill", AppliedBy: "b"}
	beyond := domain.Discount{Amount: inr(50000), Reason: "goodwill", AppliedBy: "b"}

	if !limit.Within(within, inr(100000)) {
		t.Fatal("50.00 off 1000.00 was refused by a 10% limit")
	}
	if limit.Within(beyond, inr(100000)) {
		t.Fatal("500.00 off 1000.00 passed a 10% limit")
	}
}

// A discount larger than the bill is a refund wearing the wrong name.
func TestADiscountCannotExceedTheSubtotal(t *testing.T) {
	i := newInvoice(t, domain.KindFinal)
	_ = i.AddCharges([]*domain.Charge{billableCharge(t, "XR-CHEST", "Chest X-ray", 100000, 1)})

	if err := i.ApplyDiscount(domain.Discount{
		Amount: inr(200000), Reason: "goodwill", AppliedBy: "biller-1",
	}, day(2026, time.March, 10)); !errors.Is(err, domain.ErrInvalid) {
		t.Fatalf("a discount larger than the bill was accepted: %v", err)
	}
}

// SRS-BIL-014: every share names a responsible party and how it was arrived at.
func TestALiabilityShareNamesItsPartyAndItsBasis(t *testing.T) {
	for name, share := range map[string]domain.LiabilityShare{
		"no basis": {Party: domain.LiabilityPayer, PartyID: "insurer-a", Amount: inr(1000)},
		"no payer": {Party: domain.LiabilityPayer, Amount: inr(1000), Basis: "policy"},
		"unknown party": {
			Party: "somebody", PartyID: "x", Amount: inr(1000), Basis: "policy",
		},
	} {
		t.Run(name, func(t *testing.T) {
			if err := share.Validate(); !errors.Is(err, domain.ErrInvalid) {
				t.Fatalf("%s accepted: %v", name, err)
			}
		})
	}
}

// SRS-BIL-014: the split must add up to the bill.
func TestASplitThatDoesNotAddUpIsRefused(t *testing.T) {
	i := newInvoice(t, domain.KindFinal)
	_ = i.AddCharges([]*domain.Charge{billableCharge(t, "XR-CHEST", "Chest X-ray", 100000, 1)})

	err := i.SetLiability([]domain.LiabilityShare{
		{Party: domain.LiabilityPayer, PartyID: "insurer-a", Amount: inr(100000),
			Basis: "policy covers 90%", AdjudicationRef: "ADJ-1"},
	})
	if !errors.Is(err, domain.ErrInvalid) {
		t.Fatalf("a split short of the total was accepted: %v", err)
	}
	if !strings.Contains(err.Error(), "1180.00") {
		t.Fatalf("the refusal does not name the total: %v", err)
	}

	if err := i.SetLiability([]domain.LiabilityShare{
		{Party: domain.LiabilityPayer, PartyID: "insurer-a", Amount: inr(106200),
			Basis: "policy covers 90%", AdjudicationRef: "ADJ-1"},
		{Party: domain.LiabilityPatient, Amount: inr(11800),
			Basis: "10% co-payment per scheme rules"},
	}); err != nil {
		t.Fatalf("a split that adds up was refused: %v", err)
	}
}

// SRS-BIL-014: the common case is recorded explicitly rather than implied.
func TestAnInvoiceWithNoAdjudicationMakesThePatientLiableExplicitly(t *testing.T) {
	i := newInvoice(t, domain.KindFinal)
	_ = i.AddCharges([]*domain.Charge{billableCharge(t, "XR-CHEST", "Chest X-ray", 100000, 1)})
	if err := i.Issue("biller-1", day(2026, time.March, 10)); err != nil {
		t.Fatalf("Issue: %v", err)
	}

	if len(i.Liability) != 1 {
		t.Fatalf("%d shares, want one", len(i.Liability))
	}
	if i.Liability[0].Party != domain.LiabilityPatient {
		t.Fatalf("party = %q", i.Liability[0].Party)
	}
	if i.Liability[0].Amount.Minor != i.Total.Minor {
		t.Fatal("the patient's share is not the whole bill")
	}
	if i.Liability[0].Basis == "" {
		t.Fatal("the share has no stated basis")
	}
}

func TestAnEmptyInvoiceCannotBeIssued(t *testing.T) {
	i := newInvoice(t, domain.KindFinal)
	if err := i.Issue("biller-1", day(2026, time.March, 10)); !errors.Is(
		err, domain.ErrInvalid) {
		t.Fatalf("an empty invoice was issued: %v", err)
	}
}

// A charge a package absorbed does not appear on the bill.
func TestAChargeAPackageAbsorbedDoesNotAppearOnTheBill(t *testing.T) {
	covered := billableCharge(t, "BED-GEN", "General ward bed day", 100000, 1)
	covered.Covered = true
	billed := billableCharge(t, "PHYSIO", "Physiotherapy", 50000, 1)

	i := newInvoice(t, domain.KindFinal)
	if err := i.AddCharges([]*domain.Charge{covered, billed}); err != nil {
		t.Fatalf("AddCharges: %v", err)
	}
	if len(i.Lines) != 1 || i.Lines[0].ServiceCode != "PHYSIO" {
		t.Fatalf("lines = %+v, want only the billed one", i.Lines)
	}
}

// A held or voided charge cannot be invoiced.
func TestAHeldChargeCannotReachAnInvoice(t *testing.T) {
	held := billableCharge(t, "XR-CHEST", "Chest X-ray", 100000, 1)
	if err := held.Hold("awaiting a coding query"); err != nil {
		t.Fatalf("Hold: %v", err)
	}

	i := newInvoice(t, domain.KindFinal)
	if err := i.AddCharges([]*domain.Charge{held}); !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("a held charge reached an invoice: %v", err)
	}
}
