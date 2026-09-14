package domain_test

import (
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/billing/domain"
)

func service(code, description string, rate domain.BasisPoints,
	inclusive bool) domain.ServiceItem {

	return domain.ServiceItem{
		Code: code, Description: description,
		Department: "Radiology", RevenueAccount: "4200",
		TaxCode: "GST18", TaxRate: rate, TaxInclusive: inclusive,
		EffectiveFrom: day(2025, time.January, 1),
	}
}

func pricing(minor int64) domain.PricingResult {
	return domain.PricingResult{
		Price: inr(minor), ContractID: "STD", Contract: "Standard list",
	}
}

func chargeInput(item domain.ServiceItem, quantity int32) domain.NewChargeInput {
	return domain.NewChargeInput{
		PatientID: "p1", EncounterID: "e1", FacilityID: "f1", AccountID: "acc1",
		Service: item, Quantity: quantity, Pricing: pricing(100000),
		Origin:     domain.OriginClinicalEvent,
		Source:     domain.SourceReference{System: "orders", ID: "ord-1", Detail: "ORD-000123"},
		OccurredAt: day(2026, time.March, 2),
	}
}

func newCharge(t *testing.T, in domain.NewChargeInput) *domain.Charge {
	t.Helper()
	c, err := domain.NewCharge("chg1", "t1", in, day(2026, time.March, 3))
	if err != nil {
		t.Fatalf("NewCharge: %v", err)
	}
	return c
}

// SRS-BIL-003: every charge carries its provenance.
func TestAChargeCarriesWhereItCameFrom(t *testing.T) {
	c := newCharge(t, chargeInput(service("XR-CHEST", "Chest X-ray", 1800, false), 1))

	if c.Source.System != "orders" || c.Source.ID != "ord-1" {
		t.Fatalf("source = %+v", c.Source)
	}
	if c.Source.Detail != "ORD-000123" {
		t.Fatal("the source does not carry a reference a biller can follow")
	}
	if c.Pricing.ContractID != "STD" {
		t.Fatal("the charge does not record which tariff priced it")
	}
	// The service version's values are copied on, not referenced.
	if c.Description != "Chest X-ray" || c.RevenueAccount != "4200" {
		t.Fatalf("the service version was not snapshotted: %+v", c)
	}
}

// An automatic charge with no source reference has an empty idempotency key, so
// two deliveries of one event would become two charges.
func TestAnAutomaticChargeNeedsASourceReference(t *testing.T) {
	in := chargeInput(service("XR-CHEST", "Chest X-ray", 1800, false), 1)
	in.Source = domain.SourceReference{}
	if _, err := domain.NewCharge("chg1", "t1", in,
		day(2026, time.March, 3)); !errors.Is(err, domain.ErrInvalid) {
		t.Fatalf("a sourceless automatic charge was accepted: %v", err)
	}
}

// SRS-BIL-003: a manual charge is the path round every automated control, so it
// names who took it and why.
func TestAManualChargeNeedsAnAuthorAndAReason(t *testing.T) {
	base := chargeInput(service("XR-CHEST", "Chest X-ray", 1800, false), 1)
	base.Origin = domain.OriginManual
	base.Source = domain.SourceReference{}

	for name, break_ := range map[string]func(*domain.NewChargeInput){
		"no author": func(in *domain.NewChargeInput) {
			in.Reason = "billed at the desk"
		},
		"no reason": func(in *domain.NewChargeInput) {
			in.EnteredBy = "biller-1"
		},
	} {
		t.Run(name, func(t *testing.T) {
			in := base
			break_(&in)
			if _, err := domain.NewCharge("chg1", "t1", in,
				day(2026, time.March, 3)); !errors.Is(err, domain.ErrInvalid) {
				t.Fatalf("%s accepted: %v", name, err)
			}
		})
	}

	in := base
	in.EnteredBy, in.Reason = "biller-1", "billed at the desk"
	if _, err := domain.NewCharge("chg1", "t1", in, day(2026, time.March, 3)); err != nil {
		t.Fatalf("a complete manual charge was refused: %v", err)
	}
}

// The idempotency key is the source pair, so two deliveries of one event
// collide.
func TestTheIdempotencyKeyIsTheSourcePair(t *testing.T) {
	a := domain.SourceReference{System: "orders", ID: "ord-1"}
	b := domain.SourceReference{System: "Orders", ID: "ord-1"}
	c := domain.SourceReference{System: "nursing", ID: "ord-1"}

	if a.Key() != b.Key() {
		t.Fatal("the key is case-sensitive on the system name")
	}
	if a.Key() == c.Key() {
		t.Fatal("two contexts' identifiers collide into one key")
	}
}

// Tax on a charge quoted exclusive of tax.
func TestTaxIsAddedToAnExclusivePrice(t *testing.T) {
	c := newCharge(t, chargeInput(service("XR-CHEST", "Chest X-ray", 1800, false), 2))

	if got := c.Net(); got.Minor != 200000 {
		t.Fatalf("net = %d, want two at 1000.00", got.Minor)
	}
	if got := c.Tax(); got.Minor != 36000 {
		t.Fatalf("tax = %d, want 18%% of 2000.00", got.Minor)
	}
	if got := c.Total(); got.Minor != 236000 {
		t.Fatalf("total = %d", got.Minor)
	}
}

// Tax already inside a price quoted inclusive. The naive answer — applying the
// rate to the gross — overstates it by the tax on the tax.
func TestTaxIsExtractedFromAnInclusivePrice(t *testing.T) {
	c := newCharge(t, chargeInput(service("BED-GEN", "General ward bed day", 1800, true), 1))

	// 1000.00 inclusive of 18% is 847.46 net and 152.54 tax.
	if got := c.Tax(); got.Minor != 15254 {
		t.Fatalf("tax within = %d, want 15254", got.Minor)
	}
	if got := c.Net(); got.Minor != 84746 {
		t.Fatalf("net = %d, want 84746", got.Minor)
	}
	if got := c.Total(); got.Minor != 100000 {
		t.Fatalf("total = %d, want the inclusive price unchanged", got.Minor)
	}
	// The naive computation would have been 18% of 1000.00 = 180.00.
	if c.Tax().Minor == 18000 {
		t.Fatal("the tax was computed on the gross rather than extracted from it")
	}
}

// SRS-BIL-001: a charge cannot be raised against a service version that was not
// in force when it happened.
func TestAChargeAgainstAServiceNotYetInForceIsRefused(t *testing.T) {
	item := service("XR-CHEST", "Chest X-ray", 1800, false)
	item.EffectiveFrom = day(2026, time.June, 1)

	in := chargeInput(item, 1)
	if _, err := domain.NewCharge("chg1", "t1", in,
		day(2026, time.March, 3)); !errors.Is(err, domain.ErrInvalid) {
		t.Fatalf("a charge was raised against a service that did not exist yet: %v", err)
	}
}

// SRS-BIL-010: a charge on an issued invoice is corrected by a note, not voided.
func TestAChargeOnAnInvoiceIsCorrectedRatherThanVoided(t *testing.T) {
	c := newCharge(t, chargeInput(service("XR-CHEST", "Chest X-ray", 1800, false), 1))
	if err := c.MarkInvoiced("inv-1"); err != nil {
		t.Fatalf("MarkInvoiced: %v", err)
	}

	err := c.Void("biller-1", "raised in error", day(2026, time.March, 4))
	if !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("an invoiced charge was voided: %v", err)
	}
	if !strings.Contains(err.Error(), "credit note") {
		t.Fatalf("the refusal does not name the corrective workflow: %v", err)
	}
}

func TestVoidingAChargeNeedsAReasonAndAnAuthor(t *testing.T) {
	c := newCharge(t, chargeInput(service("XR-CHEST", "Chest X-ray", 1800, false), 1))
	if err := c.Void("biller-1", "", day(2026, time.March, 4)); !errors.Is(
		err, domain.ErrInvalid) {
		t.Fatalf("a reasonless void was accepted: %v", err)
	}
	if err := c.Void("", "raised in error", day(2026, time.March, 4)); !errors.Is(
		err, domain.ErrInvalid) {
		t.Fatalf("an anonymous void was accepted: %v", err)
	}
}

// SRS-BIL-011: a held charge is parked with a reason and can come back.
func TestAHeldChargeCarriesItsReasonAndCanBeReleased(t *testing.T) {
	c := newCharge(t, chargeInput(service("XR-CHEST", "Chest X-ray", 1800, false), 1))

	if err := c.Hold(""); !errors.Is(err, domain.ErrInvalid) {
		t.Fatalf("a reasonless hold was accepted: %v", err)
	}
	if err := c.Hold("awaiting a coding query"); err != nil {
		t.Fatalf("Hold: %v", err)
	}
	if c.Status.Billable() {
		t.Fatal("a held charge is still billable")
	}
	if err := c.Release(); err != nil {
		t.Fatalf("Release: %v", err)
	}
	if !c.Status.Billable() {
		t.Fatal("a released charge is not billable")
	}
}

func TestAVoidedChargeCannotBeInvoiced(t *testing.T) {
	c := newCharge(t, chargeInput(service("XR-CHEST", "Chest X-ray", 1800, false), 1))
	if err := c.Void("biller-1", "duplicate", day(2026, time.March, 4)); err != nil {
		t.Fatalf("Void: %v", err)
	}
	if err := c.MarkInvoiced("inv-1"); !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("a voided charge was invoiced: %v", err)
	}
}

func TestAChargeNeedsAQuantityGreaterThanZero(t *testing.T) {
	in := chargeInput(service("XR-CHEST", "Chest X-ray", 1800, false), 0)
	if _, err := domain.NewCharge("chg1", "t1", in,
		day(2026, time.March, 3)); !errors.Is(err, domain.ErrInvalid) {
		t.Fatalf("a zero-quantity charge was accepted: %v", err)
	}
}

// The charge is priced at the day of care, not the day it was keyed.
func TestAChargeIsPricedAtTheDayOfCareNotTheDayItWasKeyed(t *testing.T) {
	in := chargeInput(service("XR-CHEST", "Chest X-ray", 1800, false), 1)
	in.OccurredAt = day(2026, time.March, 2)

	c, err := domain.NewCharge("chg1", "t1", in, day(2026, time.March, 6))
	if err != nil {
		t.Fatalf("NewCharge: %v", err)
	}
	if !c.OccurredAt.Equal(day(2026, time.March, 2)) {
		t.Fatalf("occurred at %s", c.OccurredAt)
	}
	if !c.PostedAt.Equal(day(2026, time.March, 6)) {
		t.Fatalf("posted at %s", c.PostedAt)
	}
}
