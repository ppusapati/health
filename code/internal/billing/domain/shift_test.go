package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/billing/domain"
)

func openShift(t *testing.T) *domain.Shift {
	t.Helper()
	s, err := domain.OpenShift("sh1", "t1", "f1", "counter-1", "cashier-1",
		inr(200000), day(2026, time.March, 10))
	if err != nil {
		t.Fatalf("OpenShift: %v", err)
	}
	return s
}

// SRS-BIL-015: what the drawer should hold is computed from the ledger, not
// typed in — so a cashier cannot make the count agree by adjusting the
// expectation.
func TestTheExpectedCashIsComputedFromTheLedger(t *testing.T) {
	cash := func(minor int64) domain.LedgerEntry {
		e := entry(domain.EntryPayment, minor)
		e.Method = domain.MethodCash
		return e
	}
	card := entry(domain.EntryPayment, -500000)
	card.Method = domain.MethodCard
	card.ProviderRef = "auth-1"

	expected, err := domain.ExpectedCashFor(inr(200000), []domain.LedgerEntry{
		cash(-150000), cash(-75000), card,
	})
	if err != nil {
		t.Fatalf("ExpectedCashFor: %v", err)
	}
	// The float plus the two cash payments. The card payment is not in the
	// drawer.
	if expected.Minor != 425000 {
		t.Fatalf("expected = %d, want 4250.00", expected.Minor)
	}
}

// A drawer that agrees reconciles without a supervisor.
func TestADrawerThatAgreesReconciles(t *testing.T) {
	s := openShift(t)
	if err := s.Close(inr(425000), inr(425000), "",
		domain.DefaultVarianceThreshold(), day(2026, time.March, 10)); err != nil {
		t.Fatalf("Close: %v", err)
	}
	if s.Status != domain.ShiftReconciled {
		t.Fatalf("status = %q", s.Status)
	}
	if s.Variance.Minor != 0 {
		t.Fatalf("variance = %d", s.Variance.Minor)
	}
}

// SRS-BIL-015: any variance needs a reason, not only a large one. A drawer
// short by ten rupees every day is a pattern nobody sees if it never has to be
// explained.
func TestAnyVarianceNeedsAReason(t *testing.T) {
	s := openShift(t)
	err := s.Close(inr(424900), inr(425000), "",
		domain.DefaultVarianceThreshold(), day(2026, time.March, 10))
	if !errors.Is(err, domain.ErrInvalid) {
		t.Fatalf("a one-rupee shortfall closed with no explanation: %v", err)
	}
	if s.Status != domain.ShiftOpen {
		t.Fatal("the shift closed anyway")
	}
}

// A small variance with a reason reconciles; a large one goes to a supervisor.
func TestAVarianceBeyondTheThresholdGoesToASupervisor(t *testing.T) {
	small := openShift(t)
	if err := small.Close(inr(424950), inr(425000), "a fifty-paise rounding at the desk",
		domain.DefaultVarianceThreshold(), day(2026, time.March, 10)); err != nil {
		t.Fatalf("Close: %v", err)
	}
	if small.Status != domain.ShiftReconciled {
		t.Fatalf("a small explained variance is %q, want reconciled", small.Status)
	}

	large := openShift(t)
	if err := large.Close(inr(420000), inr(425000), "a note is missing from the drawer",
		domain.DefaultVarianceThreshold(), day(2026, time.March, 10)); err != nil {
		t.Fatalf("Close: %v", err)
	}
	if large.Status != domain.ShiftPendingApproval {
		t.Fatalf("a 50.00 shortfall is %q, want pending approval", large.Status)
	}
	if large.Variance.Minor != -500000+495000 {
		t.Fatalf("variance = %d", large.Variance.Minor)
	}
}

// A cashier approving their own variance is the control absent with a record
// saying it happened.
func TestACashierCannotApproveTheirOwnVariance(t *testing.T) {
	s := openShift(t)
	_ = s.Close(inr(420000), inr(425000), "a note is missing",
		domain.DefaultVarianceThreshold(), day(2026, time.March, 10))

	if err := s.Approve("cashier-1", day(2026, time.March, 10)); !errors.Is(
		err, domain.ErrNotAllowed) {
		t.Fatalf("a cashier approved their own variance: %v", err)
	}
	if err := s.Approve("supervisor-1", day(2026, time.March, 10)); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	if s.Status != domain.ShiftReconciled || s.ApprovedBy != "supervisor-1" {
		t.Fatalf("shift = %+v", s)
	}
}

func TestAReconciledShiftNeedsNoApproval(t *testing.T) {
	s := openShift(t)
	_ = s.Close(inr(425000), inr(425000), "", domain.DefaultVarianceThreshold(),
		day(2026, time.March, 10))
	if err := s.Approve("supervisor-1", day(2026, time.March, 10)); !errors.Is(
		err, domain.ErrNotAllowed) {
		t.Fatalf("a balanced shift was sent for approval: %v", err)
	}
}

func TestAShiftNeedsACounterAndACashier(t *testing.T) {
	for name, args := range map[string][2]string{
		"no counter": {"", "cashier-1"},
		"no cashier": {"counter-1", ""},
	} {
		t.Run(name, func(t *testing.T) {
			if _, err := domain.OpenShift("sh1", "t1", "f1", args[0], args[1],
				inr(200000), day(2026, time.March, 10)); !errors.Is(
				err, domain.ErrInvalid) {
				t.Fatalf("%s accepted: %v", name, err)
			}
		})
	}
}

// SRS-BIL-011: an unbilled completed service is found by the source reference,
// which is the same key the charge's idempotency uses.
func TestACompletedServiceWithNoChargeIsOnTheWorklist(t *testing.T) {
	events := []domain.BillableEvent{
		{
			Source:      domain.SourceReference{System: "orders", ID: "ord-1", Detail: "ORD-000123"},
			ServiceCode: "XR-CHEST", PatientID: "p1", EncounterID: "e1", AccountID: "acc1",
			OccurredAt: day(2026, time.March, 1),
		},
		{
			Source:      domain.SourceReference{System: "orders", ID: "ord-2", Detail: "ORD-000124"},
			ServiceCode: "CONS-OP", PatientID: "p1", EncounterID: "e1", AccountID: "acc1",
			OccurredAt: day(2026, time.March, 5),
		},
	}

	charged := billableCharge(t, "XR-CHEST", "Chest X-ray", 100000, 1)
	charged.Source = domain.SourceReference{System: "orders", ID: "ord-1"}

	exceptions := domain.FindUnbilled(events, []*domain.Charge{charged},
		day(2026, time.March, 10))
	if len(exceptions) != 1 {
		t.Fatalf("%d exceptions, want only the uncharged consultation", len(exceptions))
	}
	if exceptions[0].Source.ID != "ord-2" {
		t.Fatalf("the wrong service is on the worklist: %+v", exceptions[0])
	}
	if exceptions[0].Source.Detail != "ORD-000124" {
		t.Fatal("the worklist item does not link to the source record")
	}
}

// A voided charge does not claim its service: the work was done and nobody is
// billing for it.
func TestAVoidedChargeLeavesItsServiceUnbilled(t *testing.T) {
	events := []domain.BillableEvent{{
		Source:      domain.SourceReference{System: "orders", ID: "ord-1"},
		ServiceCode: "XR-CHEST", AccountID: "acc1",
		OccurredAt: day(2026, time.March, 1),
	}}

	voided := billableCharge(t, "XR-CHEST", "Chest X-ray", 100000, 1)
	voided.Source = domain.SourceReference{System: "orders", ID: "ord-1"}
	if err := voided.Void("biller-1", "raised against the wrong patient",
		day(2026, time.March, 2)); err != nil {
		t.Fatalf("Void: %v", err)
	}

	if got := domain.FindUnbilled(events, []*domain.Charge{voided},
		day(2026, time.March, 10)); len(got) != 1 {
		t.Fatal("a voided charge still claimed its service")
	}
}

// SRS-BIL-011: the worklist puts the oldest first, because age is what
// distinguishes a query from a loss.
func TestTheWorklistPutsTheOldestFirst(t *testing.T) {
	recent := billableCharge(t, "CONS-OP", "Consultation", 50000, 1)
	recent.PostedAt = day(2026, time.March, 9)
	old := billableCharge(t, "XR-CHEST", "Chest X-ray", 100000, 1)
	old.PostedAt = day(2026, time.January, 5)
	_ = old.Hold("awaiting a coding query")

	exceptions := domain.FindChargeExceptions([]*domain.Charge{recent, old},
		day(2026, time.March, 10))
	if len(exceptions) != 2 {
		t.Fatalf("%d exceptions", len(exceptions))
	}
	if exceptions[0].ChargeID != old.ID {
		t.Fatalf("the January charge is not first: %+v", exceptions)
	}
	if exceptions[0].Kind != domain.ExceptionHeld {
		t.Fatalf("kind = %q, want held", exceptions[0].Kind)
	}
	if exceptions[0].Detail == "" || exceptions[0].Amount.Minor == 0 {
		t.Fatalf("the exception is not actionable: %+v", exceptions[0])
	}
}

// An invoiced charge is not an exception.
func TestAnInvoicedChargeIsNotOnTheWorklist(t *testing.T) {
	invoiced := billableCharge(t, "XR-CHEST", "Chest X-ray", 100000, 1)
	if err := invoiced.MarkInvoiced("inv-1"); err != nil {
		t.Fatalf("MarkInvoiced: %v", err)
	}
	if got := domain.FindChargeExceptions([]*domain.Charge{invoiced},
		day(2026, time.March, 10)); len(got) != 0 {
		t.Fatalf("an invoiced charge is on the worklist: %+v", got)
	}
}
