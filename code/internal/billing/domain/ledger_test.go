package domain_test

import (
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/billing/domain"
)

func entry(kind domain.EntryKind, minor int64) domain.LedgerEntry {
	return domain.LedgerEntry{
		ID: "e-" + string(kind), TenantID: "t1", AccountID: "acc1",
		Kind: kind, Amount: inr(minor), RecordedBy: "cashier-1",
		OccurredAt: day(2026, time.March, 10), RecordedAt: day(2026, time.March, 10),
	}
}

// SRS-BIL-012: the balance derives from the ledger.
func TestTheBalanceIsTheSumOfTheLedger(t *testing.T) {
	entries := []domain.LedgerEntry{
		entry(domain.EntryInvoice, 295000),
		entry(domain.EntryPayment, -200000),
		entry(domain.EntryPayment, -50000),
	}

	balance, err := domain.Balance(entries)
	if err != nil {
		t.Fatalf("Balance: %v", err)
	}
	if balance.Minor != 45000 {
		t.Fatalf("balance = %d, want 450.00 outstanding", balance.Minor)
	}
}

// A fully paid account is zero, not "nearly zero".
func TestAFullyPaidAccountIsExactlyZero(t *testing.T) {
	var entries []domain.LedgerEntry
	for i := 0; i < 37; i++ {
		entries = append(entries, entry(domain.EntryInvoice, 3333))
	}
	entries = append(entries, entry(domain.EntryPayment, -3333*37))

	balance, err := domain.Balance(entries)
	if err != nil {
		t.Fatalf("Balance: %v", err)
	}
	if balance.Minor != 0 {
		t.Fatalf("balance = %d, want exactly zero", balance.Minor)
	}
}

// SRS-BIL-012: money held on deposit is reported apart from the balance.
func TestDepositsAreReportedApartFromTheBalance(t *testing.T) {
	entries := []domain.LedgerEntry{
		entry(domain.EntryDeposit, -5000000),
		entry(domain.EntryInvoice, 3000000),
		entry(domain.EntryDepositApplied, 3000000),
	}

	held, err := domain.DepositsHeld(entries)
	if err != nil {
		t.Fatalf("DepositsHeld: %v", err)
	}
	if held.Minor != 2000000 {
		t.Fatalf("held = %d, want 20,000.00 still on deposit", held.Minor)
	}
}

// SRS-BIL-009: a refund is bounded by what was received, less what has already
// gone back. Without that a payment can be refunded twice.
func TestAPaymentCannotBeRefundedTwice(t *testing.T) {
	payment := entry(domain.EntryPayment, -100000)
	payment.ID = "pay-1"
	payment.Method = domain.MethodCard
	payment.ProviderRef = "auth-77"

	refund := entry(domain.EntryRefund, 60000)
	refund.ID = "ref-1"
	refund.RefundOfPaymentID = "pay-1"

	entries := []domain.LedgerEntry{payment, refund}

	if err := domain.CheckRefund(entries, "pay-1", inr(40000)); err != nil {
		t.Fatalf("the remaining 400.00 was refused: %v", err)
	}

	err := domain.CheckRefund(entries, "pay-1", inr(50000))
	if !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("more than the remainder was refunded: %v", err)
	}
	if !strings.Contains(err.Error(), "400.00") {
		t.Fatalf("the refusal does not say what is left: %v", err)
	}
}

func TestARefundAgainstNoPaymentIsRefused(t *testing.T) {
	if err := domain.CheckRefund(nil, "pay-1", inr(1000)); !errors.Is(
		err, domain.ErrInvalid) {
		t.Fatalf("a refund against nothing was accepted: %v", err)
	}
}

// SRS-BIL-009: a refund names the payment it reverses and carries an
// authorisation.
func TestARefundNeedsAnOriginalAndAnAuthorisation(t *testing.T) {
	base := entry(domain.EntryRefund, 50000)
	base.RefundOfPaymentID = "pay-1"
	base.ApprovedBy = "manager-1"
	if err := base.Validate(); err != nil {
		t.Fatalf("a complete refund was refused: %v", err)
	}

	for name, break_ := range map[string]func(*domain.LedgerEntry){
		"no original":      func(e *domain.LedgerEntry) { e.RefundOfPaymentID = "" },
		"no authorisation": func(e *domain.LedgerEntry) { e.ApprovedBy = "" },
		"wrong direction":  func(e *domain.LedgerEntry) { e.Amount = inr(-50000) },
	} {
		t.Run(name, func(t *testing.T) {
			e := base
			break_(&e)
			if err := e.Validate(); !errors.Is(err, domain.ErrInvalid) {
				t.Fatalf("%s accepted: %v", name, err)
			}
		})
	}
}

// SRS-BIL-008: a non-cash payment carries the provider's reference, which is
// what a bank statement is reconciled against.
func TestANonCashPaymentNeedsTheProvidersReference(t *testing.T) {
	card := entry(domain.EntryPayment, -100000)
	card.Method = domain.MethodCard
	if err := card.Validate(); !errors.Is(err, domain.ErrInvalid) {
		t.Fatalf("a card payment with no reference was accepted: %v", err)
	}

	card.ProviderRef = "auth-77"
	if err := card.Validate(); err != nil {
		t.Fatalf("a referenced card payment was refused: %v", err)
	}

	cash := entry(domain.EntryPayment, -100000)
	cash.Method = domain.MethodCash
	if err := cash.Validate(); err != nil {
		t.Fatalf("a cash payment was refused for having no reference: %v", err)
	}
}

// Money in reduces what is owed. A payment recorded the wrong way round would
// double the balance rather than clear it.
func TestAPaymentMustReduceTheBalance(t *testing.T) {
	wrong := entry(domain.EntryPayment, 100000)
	wrong.Method = domain.MethodCash
	if err := wrong.Validate(); !errors.Is(err, domain.ErrInvalid) {
		t.Fatalf("a payment that increased the balance was accepted: %v", err)
	}
}

func TestAZeroMovementIsNotAMovement(t *testing.T) {
	e := entry(domain.EntryAdjustment, 0)
	e.Reason = "nothing happened"
	if err := e.Validate(); !errors.Is(err, domain.ErrInvalid) {
		t.Fatalf("a zero entry was accepted: %v", err)
	}
}

func TestAWriteOffNeedsAnAuthorisationAndAReason(t *testing.T) {
	e := entry(domain.EntryWriteOff, -50000)
	if err := e.Validate(); !errors.Is(err, domain.ErrInvalid) {
		t.Fatalf("an unauthorised write-off was accepted: %v", err)
	}
	e.ApprovedBy = "manager-1"
	if err := e.Validate(); !errors.Is(err, domain.ErrInvalid) {
		t.Fatalf("a reasonless write-off was accepted: %v", err)
	}
	e.Reason = "uncollectable after three attempts"
	if err := e.Validate(); err != nil {
		t.Fatalf("a complete write-off was refused: %v", err)
	}
}

func account(t *testing.T) *domain.Account {
	t.Helper()
	a, err := domain.NewAccount("acc1", "t1", "p1", "e1", "f1", "INR",
		day(2026, time.March, 1))
	if err != nil {
		t.Fatalf("NewAccount: %v", err)
	}
	return a
}

// SRS-BIL-013: the blocking exceptions are listed, not summarised.
func TestClosingListsEveryBlockingException(t *testing.T) {
	held := billableCharge(t, "XR-CHEST", "Chest X-ray", 100000, 1)
	_ = held.Hold("awaiting a coding query")
	uninvoiced := billableCharge(t, "CONS-OP", "Consultation", 50000, 1)

	exceptions, err := domain.DefaultClosePolicy().CheckClose(domain.CloseInput{
		UninvoicedCharges: []*domain.Charge{uninvoiced},
		HeldCharges:       []*domain.Charge{held},
		Entries: []domain.LedgerEntry{
			entry(domain.EntryInvoice, 100000),
		},
		PatientLiability: inr(100000),
	})
	if err != nil {
		t.Fatalf("CheckClose: %v", err)
	}
	if len(exceptions) != 3 {
		t.Fatalf("%d exceptions, want the uninvoiced charge, the held charge and the balance: %+v",
			len(exceptions), exceptions)
	}

	byCheck := map[domain.CloseCheck]domain.CloseException{}
	for _, exception := range exceptions {
		byCheck[exception.Check] = exception
	}
	if refs := byCheck[domain.CheckNoHeldCharges].References; len(refs) != 1 {
		t.Fatalf("the held-charge exception does not link to the charge: %+v", refs)
	}
	if byCheck[domain.CheckBalanceSettled].Amount.Minor != 100000 {
		t.Fatal("the balance exception does not carry the amount outstanding")
	}
}

// SRS-BIL-013: a clean account closes.
func TestACleanAccountCloses(t *testing.T) {
	a := account(t)
	exceptions, err := domain.DefaultClosePolicy().CheckClose(domain.CloseInput{
		Entries: []domain.LedgerEntry{
			entry(domain.EntryInvoice, 100000),
			entry(domain.EntryPayment, -100000),
		},
	})
	if err != nil {
		t.Fatalf("CheckClose: %v", err)
	}
	if len(exceptions) != 0 {
		t.Fatalf("a settled account has %d exceptions: %+v", len(exceptions), exceptions)
	}
	if err := a.Close("biller-1", exceptions, day(2026, time.March, 20)); err != nil {
		t.Fatalf("Close: %v", err)
	}
	if a.Status != domain.AccountClosed || a.ClosedBy != "biller-1" {
		t.Fatalf("account = %+v", a)
	}
}

func TestAnAccountWithExceptionsWillNotClose(t *testing.T) {
	a := account(t)
	exceptions := []domain.CloseException{{
		Check: domain.CheckNoHeldCharges, Detail: "1 charge is held pending a query",
	}}

	err := a.Close("biller-1", exceptions, day(2026, time.March, 20))
	if !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("an account with exceptions closed: %v", err)
	}
	var blocked domain.BlockedClose
	if !errors.As(err, &blocked) || len(blocked.Exceptions) != 1 {
		t.Fatalf("the refusal does not carry the exceptions: %v", err)
	}
	if a.Status != domain.AccountOpen {
		t.Fatal("the account was closed anyway")
	}
}

// SRS-BIL-012: money the hospital is holding blocks the close, because an
// account closed over a deposit is a refund nobody will ever make.
func TestADepositStillHeldBlocksTheClose(t *testing.T) {
	exceptions, err := domain.DefaultClosePolicy().CheckClose(domain.CloseInput{
		Entries: []domain.LedgerEntry{
			entry(domain.EntryDeposit, -500000),
			entry(domain.EntryInvoice, 300000),
			entry(domain.EntryDepositApplied, 300000),
		},
	})
	if err != nil {
		t.Fatalf("CheckClose: %v", err)
	}
	var found bool
	for _, exception := range exceptions {
		if exception.Check == domain.CheckDepositsResolved {
			found = true
			if exception.Amount.Minor != 200000 {
				t.Fatalf("the exception reports %s held", exception.Amount)
			}
		}
	}
	if !found {
		t.Fatalf("an unresolved deposit did not block the close: %+v", exceptions)
	}
}

// SRS-BIL-014 meeting SRS-BIL-013: an insurer's ninety-day settlement is not a
// reason to keep a discharged patient's account open.
func TestAPayerBalanceDoesNotBlockTheCloseWherePolicyAllows(t *testing.T) {
	in := domain.CloseInput{
		Entries: []domain.LedgerEntry{
			entry(domain.EntryInvoice, 1000000),
			entry(domain.EntryPayment, -100000),
		},
		// The patient paid their 10% co-payment; the rest is the insurer's.
		PatientLiability: inr(0),
	}

	permissive, err := domain.DefaultClosePolicy().CheckClose(in)
	if err != nil {
		t.Fatalf("CheckClose: %v", err)
	}
	for _, exception := range permissive {
		if exception.Check == domain.CheckBalanceSettled {
			t.Fatalf("a payer balance blocked the close: %+v", exception)
		}
	}

	strict := domain.DefaultClosePolicy()
	strict.AllowPayerBalance = false
	blocked, err := strict.CheckClose(in)
	if err != nil {
		t.Fatalf("CheckClose: %v", err)
	}
	var found bool
	for _, exception := range blocked {
		if exception.Check == domain.CheckBalanceSettled {
			found = true
		}
	}
	if !found {
		t.Fatal("a hospital that requires full settlement was not blocked")
	}
}

func TestAnAccountNeedsAThreeLetterCurrency(t *testing.T) {
	if _, err := domain.NewAccount("acc1", "t1", "p1", "e1", "f1", "₹",
		day(2026, time.March, 1)); !errors.Is(err, domain.ErrInvalid) {
		t.Fatalf("a currency symbol was accepted: %v", err)
	}
}
