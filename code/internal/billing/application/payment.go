package application

import (
	"context"
	"errors"

	"github.com/ppusapati/health/code/internal/billing/domain"
	"github.com/ppusapati/health/code/internal/billing/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// ReceivePaymentInput takes money (SRS-BIL-008).
type ReceivePaymentInput struct {
	AccountID string
	Amount    domain.Money
	Method    domain.PaymentMethod
	// ProviderRef is the gateway's or bank's own identifier — the thing a
	// reconciliation is done against. Never a card number.
	ProviderRef string
	// InvoiceID allocates the payment to a document where the payer named one.
	InvoiceID string
	ShiftID   string
	// IdempotencyKey makes a retried submission one payment. Supplied by the
	// caller, because only the caller knows that its second attempt is the same
	// attempt.
	IdempotencyKey string
	// Deposit marks an advance taken before care rather than a payment against
	// a bill (SRS-BIL-012).
	Deposit bool
	Reason  string
}

// PaymentResult is what receiving money returns.
type PaymentResult struct {
	Entry domain.LedgerEntry
	// AlreadyReceived marks a retried submission: the entry that came back is
	// the one that was already there, and no money moved twice.
	AlreadyReceived bool
	Balance         domain.Money
}

// ReceivePayment takes money and allocates it (SRS-BIL-008, SRS-BIL-012).
//
// Idempotent on the caller's key, enforced by a unique index rather than a
// check: two submissions of one payment can be in flight at the same moment,
// and a check-then-insert would take the money twice. The receipt number comes
// from the platform's sequence, which is what the requirement means by
// "receipt number atomic" — a gap in a receipt series is a question an auditor
// asks, and "the transaction rolled back" is not an answer they accept.
func (s *Service) ReceivePayment(ctx context.Context, in ReceivePaymentInput) (
	PaymentResult, error) {

	session, scope, err := s.authorize(ctx, PermPaymentReceive, "payment",
		in.AccountID, true)
	if err != nil {
		return PaymentResult{}, err
	}

	account, err := s.requireOpenAccount(ctx, scope, in.AccountID)
	if err != nil {
		return PaymentResult{}, err
	}
	if s.numbers == nil {
		return PaymentResult{}, rpcerr.Internal("BIL_NO_NUMBER_SEQUENCE",
			"this deployment cannot issue receipt numbers")
	}

	// Already received? Answer with what is there rather than taking the money
	// again.
	if in.IdempotencyKey != "" {
		existing, err := s.ledger.ByIdempotencyKey(ctx, scope, account.ID,
			in.IdempotencyKey)
		if err == nil {
			balance, err := s.balanceOf(ctx, scope, account.ID)
			if err != nil {
				return PaymentResult{}, err
			}
			return PaymentResult{
				Entry: existing, AlreadyReceived: true, Balance: balance,
			}, nil
		}
		if !isNotFound(err) {
			return PaymentResult{}, err
		}
	}

	kind := domain.EntryPayment
	if in.Deposit {
		kind = domain.EntryDeposit
	}

	now := s.clock.Now()
	entry := domain.LedgerEntry{
		ID: s.ids.NewID(), TenantID: session.TenantID,
		AccountID: account.ID, PatientID: account.PatientID,
		EncounterID: account.EncounterID, FacilityID: account.FacilityID,
		Kind: kind,
		// Money in reduces what is owed, so it posts negative whatever the
		// caller supplied.
		Amount:    negativeAmount(in.Amount, account.Currency),
		InvoiceID: in.InvoiceID,
		Method:    in.Method, ProviderRef: in.ProviderRef,
		ShiftID: in.ShiftID, IdempotencyKey: in.IdempotencyKey,
		Reason: in.Reason, RecordedBy: session.SubjectID,
		OccurredAt: now, RecordedAt: now,
	}
	entry.PaymentID = entry.ID
	if err := entry.Validate(); err != nil {
		return PaymentResult{}, billingError(err)
	}

	result := PaymentResult{Entry: entry}
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		receipt, err := s.numbers.Issue(ctx, scope, sequenceReceipt, now)
		if err != nil {
			return err
		}
		entry.ReceiptNumber = receipt

		if err := s.ledger.Append(ctx, scope, entry); err != nil {
			if errors.Is(err, ports.ErrAlreadyRecorded) {
				existing, lookupErr := s.ledger.ByIdempotencyKey(ctx, scope,
					account.ID, in.IdempotencyKey)
				if lookupErr != nil {
					return lookupErr
				}
				result = PaymentResult{Entry: existing, AlreadyReceived: true}
				return nil
			}
			return err
		}
		result.Entry = entry

		if err := s.appendEvent(ctx, session, EventPaymentReceived, "payment",
			entry.ID, paymentEventPayload(entry), now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "bil.payment.receive", ResourceType: "payment",
			ResourceID: entry.ID, Outcome: audit.OutcomeSuccess,
			Reason: string(entry.Method) + " " + entry.Amount.Negate().String() +
				" receipt " + entry.ReceiptNumber,
		}, now)
	})
	if err != nil {
		return PaymentResult{}, mapConflict(err)
	}

	balance, err := s.balanceOf(ctx, scope, account.ID)
	if err != nil {
		return PaymentResult{}, err
	}
	result.Balance = balance
	return result, nil
}

func negativeAmount(m domain.Money, fallbackCurrency string) domain.Money {
	currency := m.Currency
	if currency == "" {
		currency = fallbackCurrency
	}
	minor := m.Minor
	if minor > 0 {
		minor = -minor
	}
	return domain.Money{Minor: minor, Currency: currency}
}

// paymentEventPayload is what payment.received carries (SRS-BIL-016).
//
// The requirement's qualifier — "without exposing unnecessary payment secrets"
// — decides this list: the method and the provider's reference, which is what a
// reconciliation needs, and never a card number, an account number or an
// authorisation code. A gateway reference identifies a transaction to whoever
// already holds the gateway's credentials; a card number identifies it to
// anybody.
func paymentEventPayload(e domain.LedgerEntry) map[string]any {
	received := e.Amount.Negate()
	return map[string]any{
		"payment_id": e.ID, "account_id": e.AccountID,
		"patient_id": e.PatientID, "encounter_id": e.EncounterID,
		"facility_id":  e.FacilityID,
		"amount_minor": received.Minor, "currency": received.Currency,
		"method": string(e.Method), "provider_ref": e.ProviderRef,
		"receipt_number": e.ReceiptNumber, "invoice_id": e.InvoiceID,
		"kind": string(e.Kind),
	}
}

// RefundInput returns money (SRS-BIL-009).
type RefundInput struct {
	AccountID string
	// PaymentID is the entry being reversed. Mandatory: a refund that names no
	// original is money leaving with nothing to check it against.
	PaymentID string
	Amount    domain.Money
	Reason    string
	ShiftID   string
	// ApprovedBy is the authorisation. Required by the domain, and checked here
	// against a permission the refunding cashier does not hold by default.
	ApprovedBy string
}

// Refund returns money against an original payment (SRS-BIL-009).
//
// The original stays exactly as it was and the refund is a separate entry:
// "we never took this" and "we took it and gave it back" are different
// statements to a patient and to a tax authority. Bounded by what was received
// less what has already gone back, because without that a payment can be
// refunded twice — the failure that turns a billing bug into a loss.
func (s *Service) Refund(ctx context.Context, in RefundInput) (
	domain.LedgerEntry, error) {

	session, scope, err := s.authorize(ctx, PermRefundIssue, "refund",
		in.PaymentID, true)
	if err != nil {
		return domain.LedgerEntry{}, err
	}

	account, err := s.requireOpenAccount(ctx, scope, in.AccountID)
	if err != nil {
		return domain.LedgerEntry{}, err
	}

	entries, err := s.ledger.Entries(ctx, scope, account.ID)
	if err != nil {
		return domain.LedgerEntry{}, err
	}

	amount := in.Amount
	if amount.Currency == "" {
		amount.Currency = account.Currency
	}
	if amount.Minor < 0 {
		amount.Minor = -amount.Minor
	}
	if err := domain.CheckRefund(entries, in.PaymentID, amount); err != nil {
		return domain.LedgerEntry{}, billingError(err)
	}

	approvedBy := in.ApprovedBy
	if approvedBy == "" && session.HasPermission(PermRefundApproveSelf()) {
		// A role that carries both the refund and the approval permission — a
		// billing manager — authorises its own refunds, which is a deliberate
		// configuration rather than an oversight. The record still names them.
		approvedBy = session.SubjectID
	}

	now := s.clock.Now()
	entry := domain.LedgerEntry{
		ID: s.ids.NewID(), TenantID: session.TenantID,
		AccountID: account.ID, PatientID: account.PatientID,
		EncounterID: account.EncounterID, FacilityID: account.FacilityID,
		Kind: domain.EntryRefund, Amount: amount,
		RefundOfPaymentID: in.PaymentID,
		ShiftID:           in.ShiftID,
		Reason:            in.Reason,
		RecordedBy:        session.SubjectID, ApprovedBy: approvedBy,
		OccurredAt: now, RecordedAt: now,
	}
	if err := entry.Validate(); err != nil {
		return domain.LedgerEntry{}, billingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.ledger.Append(ctx, scope, entry); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventRefundCompleted, "refund",
			entry.ID, refundEventPayload(entry), now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "bil.refund.issue", ResourceType: "refund",
			ResourceID: entry.ID, Outcome: audit.OutcomeSuccess,
			Reason: entry.Amount.String() + " against payment " + in.PaymentID +
				", approved by " + entry.ApprovedBy,
		}, now)
	})
	if err != nil {
		return domain.LedgerEntry{}, mapConflict(err)
	}
	return entry, nil
}

// PermRefundApproveSelf names the permission that lets a refunding role
// authorise its own refund.
//
// A function rather than a constant so the one place that reads it is obvious:
// this is the seam between "a cashier refunds with a manager's signature" and
// "a manager refunds on their own authority", and both are real configurations.
func PermRefundApproveSelf() string { return PermDiscountApprove }

// refundEventPayload is what refund.completed carries (SRS-BIL-016).
func refundEventPayload(e domain.LedgerEntry) map[string]any {
	return map[string]any{
		"refund_id": e.ID, "account_id": e.AccountID,
		"patient_id": e.PatientID, "encounter_id": e.EncounterID,
		"facility_id":  e.FacilityID,
		"amount_minor": e.Amount.Minor, "currency": e.Amount.Currency,
		"refund_of_payment_id": e.RefundOfPaymentID,
		"approved_by":          e.ApprovedBy,
	}
}

// AccountStatement is what a patient or a biller is shown (SRS-BIL-012).
type AccountStatement struct {
	Account  *domain.Account
	Entries  []domain.LedgerEntry
	Balance  domain.Money
	Deposits domain.Money
}

// Statement reads an account's ledger and derives its balance (SRS-BIL-012).
//
// Derived here rather than stored, and derived by the same arithmetic the
// reconciliation uses, so the patient-facing figure and the finance figure
// cannot disagree.
func (s *Service) Statement(ctx context.Context, accountID string) (
	AccountStatement, error) {

	session, scope, err := s.authorize(ctx, PermBillingRead, "account",
		accountID, false)
	if err != nil {
		return AccountStatement{}, err
	}

	account, err := s.accounts.Get(ctx, scope, accountID)
	if err != nil {
		return AccountStatement{}, err
	}
	entries, err := s.ledger.Entries(ctx, scope, accountID)
	if err != nil {
		return AccountStatement{}, err
	}
	balance, err := domain.Balance(entries)
	if err != nil {
		return AccountStatement{}, billingError(err)
	}
	deposits, err := domain.DepositsHeld(entries)
	if err != nil {
		return AccountStatement{}, billingError(err)
	}

	_ = s.appendAudit(ctx, session, audit.Record{
		Action: "bil.account.read", ResourceType: "account",
		ResourceID: accountID, Outcome: audit.OutcomeSuccess,
	}, s.clock.Now())

	return AccountStatement{
		Account: account, Entries: entries,
		Balance: balance, Deposits: deposits,
	}, nil
}

func (s *Service) balanceOf(ctx context.Context, scope authctx.TenantScope,
	accountID string) (domain.Money, error) {

	entries, err := s.ledger.Entries(ctx, scope, accountID)
	if err != nil {
		return domain.Money{}, err
	}
	return domain.Balance(entries)
}
