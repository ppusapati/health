package domain

import (
	"sort"
	"strings"
	"time"
)

// The account ledger: payments, refunds, deposits and closing
// (SRS-BIL-008, SRS-BIL-009, SRS-BIL-012, SRS-BIL-013).
//
// Everything financial that happens to an account is an entry, and the balance
// is their sum. SRS-BIL-012 states it outright — "balance derives from ledger
// and reconciles" — and the reason is what happens to the alternative: a stored
// balance kept in step by every writer drifts the first time one of them fails
// between its two writes, and there is nothing to reconcile against because the
// ledger was never the truth.
//
// Sign convention, stated once because every reader will want it: a positive
// entry increases what the patient owes and a negative entry reduces it. An
// invoice posts positive, a payment negative, a refund positive again. A
// balance above zero is money owed; below zero is money held on account.

// EntryKind is what a ledger entry records (SRS-BIL-012).
type EntryKind string

const (
	// EntryInvoice is a document posting its total.
	EntryInvoice EntryKind = "invoice"
	// EntryPayment is money received (SRS-BIL-008).
	EntryPayment EntryKind = "payment"
	// EntryRefund is money returned (SRS-BIL-009). A separate entry rather than
	// an edit to the payment: the requirement is explicit that the original is
	// retained, and "we never took this" and "we took it and gave it back" are
	// different statements to a tax authority.
	EntryRefund EntryKind = "refund"
	// EntryDeposit is an advance taken before care (SRS-BIL-012).
	EntryDeposit EntryKind = "deposit"
	// EntryDepositApplied consumes an advance against a bill.
	EntryDepositApplied EntryKind = "deposit_applied"
	// EntryWriteOff is a balance the hospital has decided not to pursue.
	EntryWriteOff EntryKind = "write_off"
	// EntryAdjustment is anything else, and needs a reason: an entry kind
	// nobody has to name is one every unexplained movement ends up in.
	EntryAdjustment EntryKind = "adjustment"
)

var knownEntryKinds = map[EntryKind]bool{
	EntryInvoice: true, EntryPayment: true, EntryRefund: true,
	EntryDeposit: true, EntryDepositApplied: true,
	EntryWriteOff: true, EntryAdjustment: true,
}

// PaymentMethod is how money moved (SRS-BIL-008).
type PaymentMethod string

const (
	MethodCash     PaymentMethod = "cash"
	MethodCard     PaymentMethod = "card"
	MethodUPI      PaymentMethod = "upi"
	MethodTransfer PaymentMethod = "bank_transfer"
	MethodCheque   PaymentMethod = "cheque"
	// MethodPayer is a settlement from an insurer rather than from the patient.
	MethodPayer PaymentMethod = "payer_settlement"
)

var knownMethods = map[PaymentMethod]bool{
	MethodCash: true, MethodCard: true, MethodUPI: true,
	MethodTransfer: true, MethodCheque: true, MethodPayer: true,
}

// Cash reports a method that lands in a drawer, which is what a shift
// reconciles (SRS-BIL-015).
func (m PaymentMethod) Cash() bool { return m == MethodCash }

// LedgerEntry is one movement on an account (SRS-BIL-012).
//
// Append-only. Nothing here is ever updated or deleted: a correction is another
// entry, which is the same rule SRS-BIL-010 applies to invoices and for the
// same reason.
type LedgerEntry struct {
	ID       string
	TenantID string

	AccountID   string
	PatientID   string
	EncounterID string
	FacilityID  string

	Kind EntryKind
	// Amount is signed. Positive increases what is owed.
	Amount Money

	// InvoiceID, PaymentID and RefundOfPaymentID tie the entry to what caused
	// it. Exactly the provenance SRS-BIL-012's "auditable ledger" asks for.
	InvoiceID         string
	PaymentID         string
	RefundOfPaymentID string

	// Method, ProviderRef and ReceiptNumber are set on money movements.
	// ProviderRef is the gateway's or bank's own identifier — the thing a
	// reconciliation is done against — and is deliberately not a card number or
	// any other secret (SRS-BIL-016).
	Method        PaymentMethod
	ProviderRef   string
	ReceiptNumber string

	// ShiftID ties a cash movement to the drawer it went into (SRS-BIL-015).
	ShiftID string

	// IdempotencyKey makes a retried payment one payment (SRS-BIL-008). Unique
	// per account at the table, because two submissions can be in flight at the
	// same moment and a check-then-insert would let both through.
	IdempotencyKey string

	Reason     string
	RecordedBy string
	// ApprovedBy is set where the movement needed authorisation — a refund, a
	// write-off.
	ApprovedBy string
	OccurredAt time.Time
	RecordedAt time.Time
}

// Validate rejects an entry that could not be reconciled.
func (e LedgerEntry) Validate() error {
	switch {
	case strings.TrimSpace(e.ID) == "":
		return invalidf("a ledger entry needs an identifier")
	case strings.TrimSpace(e.AccountID) == "":
		return invalidf("a ledger entry needs an account")
	case !knownEntryKinds[e.Kind]:
		return invalidf("unknown ledger entry kind %q", e.Kind)
	case strings.TrimSpace(e.RecordedBy) == "":
		return invalidf("a ledger entry needs the person recording it")
	case e.Amount.Minor == 0:
		// A zero movement is not a movement. Recording one would put a row in
		// the audit trail that says nothing happened, which is noise every
		// reconciliation then has to read past.
		return invalidf("a ledger entry needs a non-zero amount")
	}
	if err := e.Amount.Validate(); err != nil {
		return err
	}

	switch e.Kind {
	case EntryPayment, EntryDeposit:
		if !knownMethods[e.Method] {
			return invalidf("a %s needs a payment method", e.Kind)
		}
		if e.Amount.Positive() {
			// Money in reduces what is owed.
			return invalidf("a %s must reduce the balance", e.Kind)
		}
		if !e.Method.Cash() && strings.TrimSpace(e.ProviderRef) == "" {
			// Cash has no reference; everything else does, and without it the
			// bank statement cannot be reconciled against the ledger.
			return invalidf("a %s payment needs the provider's reference", e.Method)
		}
	case EntryRefund:
		if strings.TrimSpace(e.RefundOfPaymentID) == "" {
			// A refund that names no original is money leaving with nothing to
			// check it against (SRS-BIL-009).
			return invalidf("a refund must reference the payment it reverses")
		}
		if strings.TrimSpace(e.ApprovedBy) == "" {
			return invalidf("a refund needs an authorisation")
		}
		if e.Amount.Negative() {
			return invalidf("a refund must increase the balance")
		}
	case EntryWriteOff:
		if strings.TrimSpace(e.ApprovedBy) == "" {
			return invalidf("a write-off needs an authorisation")
		}
		if strings.TrimSpace(e.Reason) == "" {
			return invalidf("a write-off needs a reason")
		}
	case EntryAdjustment:
		if strings.TrimSpace(e.Reason) == "" {
			return invalidf("an adjustment needs a reason")
		}
	case EntryInvoice:
		if strings.TrimSpace(e.InvoiceID) == "" {
			return invalidf("an invoice entry must name the invoice")
		}
	}
	return nil
}

// Balance is what an account owes, derived from its ledger (SRS-BIL-012).
//
// Summed rather than stored, and summed here rather than in SQL, so the same
// arithmetic produces the patient-facing figure and the reconciliation figure.
// Two implementations of one sum is two answers the first time one of them
// changes.
func Balance(entries []LedgerEntry) (Money, error) {
	total := Money{}
	for _, entry := range entries {
		next, err := total.Add(entry.Amount)
		if err != nil {
			return Money{}, err
		}
		total = next
	}
	return total, nil
}

// DepositsHeld is the advance money not yet consumed (SRS-BIL-012).
//
// Reported separately from the balance, because a patient with ₹50,000 on
// deposit and ₹30,000 billed is not the same as one with ₹20,000 of credit: the
// first has ₹20,000 they can ask for back, and a single net figure hides that.
func DepositsHeld(entries []LedgerEntry) (Money, error) {
	taken := Money{}
	applied := Money{}
	for _, entry := range entries {
		var err error
		switch entry.Kind {
		case EntryDeposit:
			taken, err = taken.Add(entry.Amount.Negate())
		case EntryDepositApplied:
			applied, err = applied.Add(entry.Amount)
		}
		if err != nil {
			return Money{}, err
		}
	}
	return taken.Sub(applied)
}

// RefundedAgainst totals what has already been refunded against one payment.
func RefundedAgainst(entries []LedgerEntry, paymentID string) (Money, error) {
	total := Money{}
	for _, entry := range entries {
		if entry.Kind != EntryRefund || entry.RefundOfPaymentID != paymentID {
			continue
		}
		next, err := total.Add(entry.Amount)
		if err != nil {
			return Money{}, err
		}
		total = next
	}
	return total, nil
}

// CheckRefund reports whether a refund may be made against a payment
// (SRS-BIL-009).
//
// Bounded by what was actually received, less what has already gone back.
// Without that check a payment can be refunded twice, which is the failure that
// turns a billing bug into a loss.
func CheckRefund(entries []LedgerEntry, paymentID string, amount Money) error {
	var original *LedgerEntry
	for i := range entries {
		if entries[i].Kind == EntryPayment && entries[i].ID == paymentID {
			original = &entries[i]
			break
		}
	}
	if original == nil {
		return invalidf("no payment %s on this account to refund", paymentID)
	}

	alreadyRefunded, err := RefundedAgainst(entries, paymentID)
	if err != nil {
		return err
	}
	received := original.Amount.Negate()
	remaining, err := received.Sub(alreadyRefunded)
	if err != nil {
		return err
	}
	if amount.Minor > remaining.Minor {
		return notAllowedf(
			"%s was received on that payment and %s already refunded; %s is left",
			received, alreadyRefunded, remaining)
	}
	return nil
}

// AccountStatus is where a financial account stands (SRS-BIL-013).
type AccountStatus string

const (
	AccountOpen AccountStatus = "open"
	// AccountClosed takes no further charges. Reached only through the
	// reconciliation checks.
	AccountClosed AccountStatus = "closed"
)

// Account is an encounter's financial record (SRS-BIL-013).
type Account struct {
	ID       string
	TenantID string

	PatientID   string
	EncounterID string
	FacilityID  string
	Currency    string

	// PayerID and CustomerID are what charges on this account are priced
	// against.
	PayerID    string
	CustomerID string
	RoomClass  string
	// PackageCode is the bundle this admission was sold under, where there is
	// one (SRS-BIL-004).
	PackageCode string

	Status   AccountStatus
	ClosedBy string
	ClosedAt time.Time

	CreatedAt time.Time
	UpdatedAt time.Time
	Version   int64
}

// NewAccount opens an encounter's financial account.
func NewAccount(id, tenantID, patientID, encounterID, facilityID, currency string,
	now time.Time) (*Account, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return nil, invalidf("an account needs an identifier")
	case strings.TrimSpace(patientID) == "":
		return nil, invalidf("an account needs a patient")
	case strings.TrimSpace(encounterID) == "":
		return nil, invalidf("an account needs an encounter")
	case !isCurrencyCode(strings.TrimSpace(currency)):
		return nil, invalidf("an account needs a three-letter ISO 4217 currency code")
	}

	return &Account{
		ID: id, TenantID: tenantID,
		PatientID:   strings.TrimSpace(patientID),
		EncounterID: strings.TrimSpace(encounterID),
		FacilityID:  strings.TrimSpace(facilityID),
		Currency:    strings.ToUpper(strings.TrimSpace(currency)),
		Status:      AccountOpen,
		CreatedAt:   now.UTC(), UpdatedAt: now.UTC(), Version: 1,
	}, nil
}

// CloseCheck is one condition an account must satisfy before closing
// (SRS-BIL-013).
type CloseCheck string

const (
	CheckAllChargesInvoiced CloseCheck = "all_charges_invoiced"
	CheckNoHeldCharges      CloseCheck = "no_held_charges"
	CheckBalanceSettled     CloseCheck = "balance_settled"
	CheckDepositsResolved   CloseCheck = "deposits_resolved"
	CheckNoDraftInvoices    CloseCheck = "no_draft_invoices"
)

// CloseException is a reason an account cannot close yet (SRS-BIL-013).
//
// Structured and enumerated, because the acceptance criterion is that "blocking
// exceptions are listed": a biller told the account "cannot be closed" has to
// go looking, and the thing they are looking for is usually one held charge out
// of four hundred.
type CloseException struct {
	Check  CloseCheck
	Detail string
	// Amount is set where the exception is an amount — what is outstanding,
	// what is held on deposit.
	Amount Money
	// References point at the records to fix.
	References []string
}

// ClosePolicy is which checks a tenant requires (SRS-BIL-013).
//
// Configurable because hospitals genuinely differ: one closes an account with a
// payer balance outstanding because the insurer settles in ninety days, another
// will not. What is not configurable is that the checks are *listed* when they
// fail.
type ClosePolicy struct {
	Required map[CloseCheck]bool
	// AllowPayerBalance closes an account whose only outstanding amount is a
	// payer's. The commonest real configuration: a hospital cannot hold every
	// insured patient's account open for three months.
	AllowPayerBalance bool
}

// DefaultClosePolicy requires everything except an unsettled payer balance.
func DefaultClosePolicy() ClosePolicy {
	return ClosePolicy{
		Required: map[CloseCheck]bool{
			CheckAllChargesInvoiced: true,
			CheckNoHeldCharges:      true,
			CheckBalanceSettled:     true,
			CheckDepositsResolved:   true,
			CheckNoDraftInvoices:    true,
		},
		AllowPayerBalance: true,
	}
}

// CloseInput is the state the checks run against.
type CloseInput struct {
	UninvoicedCharges []*Charge
	HeldCharges       []*Charge
	DraftInvoices     []*Invoice
	Entries           []LedgerEntry
	// PatientLiability is what the patient themselves owes, as distinct from
	// the whole balance (SRS-BIL-014). A payer's ninety-day settlement is not a
	// reason to keep a discharged patient's account open.
	PatientLiability Money
}

// CheckClose lists everything in the way (SRS-BIL-013).
//
// Returns every exception rather than the first, for the reason every
// list-shaped refusal in this system does: a biller who fixes one and is then
// told about another stops reading.
func (p ClosePolicy) CheckClose(in CloseInput) ([]CloseException, error) {
	var out []CloseException

	if p.Required[CheckAllChargesInvoiced] && len(in.UninvoicedCharges) > 0 {
		refs := make([]string, 0, len(in.UninvoicedCharges))
		for _, charge := range in.UninvoicedCharges {
			refs = append(refs, charge.ID)
		}
		out = append(out, CloseException{
			Check: CheckAllChargesInvoiced,
			Detail: pluralise(len(in.UninvoicedCharges),
				"charge has not been invoiced", "charges have not been invoiced"),
			References: refs,
		})
	}

	if p.Required[CheckNoHeldCharges] && len(in.HeldCharges) > 0 {
		refs := make([]string, 0, len(in.HeldCharges))
		for _, charge := range in.HeldCharges {
			refs = append(refs, charge.ID)
		}
		out = append(out, CloseException{
			Check: CheckNoHeldCharges,
			Detail: pluralise(len(in.HeldCharges),
				"charge is held pending a query", "charges are held pending a query"),
			References: refs,
		})
	}

	if p.Required[CheckNoDraftInvoices] && len(in.DraftInvoices) > 0 {
		refs := make([]string, 0, len(in.DraftInvoices))
		for _, invoice := range in.DraftInvoices {
			refs = append(refs, invoice.Number)
		}
		out = append(out, CloseException{
			Check: CheckNoDraftInvoices,
			Detail: pluralise(len(in.DraftInvoices),
				"document is still in draft", "documents are still in draft"),
			References: refs,
		})
	}

	balance, err := Balance(in.Entries)
	if err != nil {
		return nil, err
	}
	if p.Required[CheckBalanceSettled] && balance.Positive() {
		owed := balance
		if p.AllowPayerBalance {
			// Only the patient's own share blocks. What an insurer owes is
			// chased through a receivables process, not by keeping a discharged
			// patient's account open for three months.
			owed = in.PatientLiability
		}
		if owed.Positive() {
			out = append(out, CloseException{
				Check:  CheckBalanceSettled,
				Detail: owed.String() + " is outstanding",
				Amount: owed,
			})
		}
	}

	if p.Required[CheckDepositsResolved] {
		held, err := DepositsHeld(in.Entries)
		if err != nil {
			return nil, err
		}
		if held.Minor > 0 {
			// Money the hospital is holding that belongs to the patient. An
			// account closed over it is a refund nobody will ever make.
			out = append(out, CloseException{
				Check:  CheckDepositsResolved,
				Detail: held.String() + " is held on deposit and must be applied or refunded",
				Amount: held,
			})
		}
	}

	sort.SliceStable(out, func(i, j int) bool { return out[i].Check < out[j].Check })
	return out, nil
}

func pluralise(n int, one, many string) string {
	if n == 1 {
		return "1 " + one
	}
	return itoa(n) + " " + many
}

func itoa(n int) string {
	if n == 0 {
		return "0"
	}
	var digits []byte
	for n > 0 {
		digits = append([]byte{byte('0' + n%10)}, digits...)
		n /= 10
	}
	return string(digits)
}

// Close settles an account (SRS-BIL-013).
func (a *Account) Close(by string, exceptions []CloseException, now time.Time) error {
	if a.Status == AccountClosed {
		return nil
	}
	if strings.TrimSpace(by) == "" {
		return invalidf("closing an account needs the person doing it")
	}
	if len(exceptions) > 0 {
		return BlockedClose{Exceptions: exceptions}
	}

	a.Status = AccountClosed
	a.ClosedBy = strings.TrimSpace(by)
	a.ClosedAt = now.UTC()
	a.UpdatedAt = now.UTC()
	a.Version++
	return nil
}

// BlockedClose lists what stands in the way (SRS-BIL-013).
type BlockedClose struct {
	Exceptions []CloseException
}

func (e BlockedClose) Error() string {
	details := make([]string, 0, len(e.Exceptions))
	for _, exception := range e.Exceptions {
		details = append(details, exception.Detail)
	}
	return "the account cannot be closed: " + strings.Join(details, "; ")
}

// Is lets errors.Is find the sentinel through a structured refusal.
func (e BlockedClose) Is(target error) bool { return target == ErrNotAllowed }
