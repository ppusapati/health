// Package application holds the billing use cases.
package application

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/billing/domain"
	"github.com/ppusapati/health/code/internal/billing/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Permissions (SRS-BIL, Wave-1 backlog "bil.*").
const (
	// PermBillingRead reads accounts, charges, invoices and the ledger.
	PermBillingRead = "bil.account.read"
	// PermChargePost raises a charge (SRS-BIL-003).
	PermChargePost = "bil.charge.post"
	// PermChargeManual keys a charge in by hand.
	//
	// Its own permission, because a manual charge is the path round every
	// automated control: the service was not necessarily delivered, the tariff
	// was not necessarily resolved from an event, and the only evidence is that
	// somebody typed it. A hospital withholds this from the desk that raises
	// four hundred automatic charges a day.
	PermChargeManual = "bil.charge.manual"
	// PermInvoiceIssue finalises a document (SRS-BIL-006).
	PermInvoiceIssue = "bil.invoice.issue"
	// PermDiscountApply gives a concession within a limit (SRS-BIL-007).
	PermDiscountApply = "bil.discount.apply"
	// PermDiscountApprove authorises one beyond a limit.
	//
	// Separate from applying, and held by somebody else: a limit a person can
	// approve for themselves is not a limit.
	PermDiscountApprove = "bil.discount.approve"
	// PermPaymentReceive takes money (SRS-BIL-008).
	PermPaymentReceive = "bil.payment.receive"
	// PermRefundIssue returns it (SRS-BIL-009).
	//
	// Its own permission and, in the default role set, a different person's: a
	// cashier who can both take and return money without a second signature is
	// the classic unmitigated cash risk.
	PermRefundIssue = "bil.refund.issue"
	// PermAccountClose settles an account (SRS-BIL-013).
	PermAccountClose = "bil.account.close"
	// PermShiftManage opens and closes a drawer (SRS-BIL-015).
	PermShiftManage = "bil.shift.manage"
	// PermShiftApprove signs off a variance beyond the threshold.
	PermShiftApprove = "bil.shift.approve"
	// PermBillingConfigure maintains the charge master, the tariffs, the
	// packages and the policy.
	PermBillingConfigure = "bil.catalogue.configure"
)

// Events (SRS-BIL-016).
//
// The requirement's four, and the qualifier on it — "without exposing
// unnecessary payment secrets" — is why the payloads carry the provider's
// reference and never a card number, an account number or an authorisation
// code. An event stream is read by more systems and under fewer controls than
// the ledger it describes.
const (
	EventChargePosted     = "charge.posted"
	EventInvoiceFinalized = "invoice.finalized"
	EventPaymentReceived  = "payment.received"
	EventRefundCompleted  = "refund.completed"
)

const (
	eventSchemaVersion = 1
	eventSource        = "billing"
)

// Service is the billing use-case façade.
type Service struct {
	uow        ports.UnitOfWork
	master     ports.MasterRepository
	accounts   ports.AccountRepository
	charges    ports.ChargeRepository
	invoices   ports.InvoiceRepository
	ledger     ports.LedgerRepository
	shifts     ports.ShiftRepository
	policies   ports.PolicyRepository
	numbers    ports.Numbers
	encounters ports.Encounters
	events     ports.EventAppender
	audits     ports.AuditAppender
	ids        ports.IDGenerator
	clock      ports.Clock
}

// Deps are the collaborators the service needs.
type Deps struct {
	UnitOfWork ports.UnitOfWork
	Master     ports.MasterRepository
	Accounts   ports.AccountRepository
	Charges    ports.ChargeRepository
	Invoices   ports.InvoiceRepository
	Ledger     ports.LedgerRepository
	Shifts     ports.ShiftRepository
	Policies   ports.PolicyRepository
	// Numbers issues invoice and receipt numbers from the platform's sequence.
	// Nil means documents cannot be issued, which the use case reports rather
	// than working round with a counter of its own.
	Numbers    ports.Numbers
	Encounters ports.Encounters
	Events     ports.EventAppender
	Audits     ports.AuditAppender
	IDs        ports.IDGenerator
	Clock      ports.Clock
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, master: d.Master, accounts: d.Accounts,
		charges: d.Charges, invoices: d.Invoices, ledger: d.Ledger,
		shifts: d.Shifts, policies: d.Policies, numbers: d.Numbers,
		encounters: d.Encounters,
		events:     d.Events, audits: d.Audits, ids: d.IDs, clock: d.Clock,
	}
}

// Limits on what one request may ask for.
const (
	DefaultPageSize = 100
	MaxPageSize     = 500
	// MaxChargesPerInvoice bounds a single document. A bill with two thousand
	// lines is one nobody reads and one transaction holds locks for as long as
	// it takes to write.
	MaxChargesPerInvoice = 1000
)

func clampPageSize(requested int32) int32 {
	switch {
	case requested <= 0:
		return DefaultPageSize
	case requested > MaxPageSize:
		return MaxPageSize
	default:
		return requested
	}
}

// authorize is the shared preamble.
func (s *Service) authorize(ctx context.Context, permission, resourceType,
	resourceID string, mutating bool) (
	authctx.Session, authctx.TenantScope, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return authctx.Session{}, authctx.TenantScope{},
			rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: permission,
		Mutating:   mutating,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, permission, resourceType, resourceID,
			decision.Reason)
		return authctx.Session{}, authctx.TenantScope{},
			rpcerr.PermissionDenied("BIL_DENIED", decision.Reason)
	}
	return session, session.TenantScope(), nil
}

// requireOpenAccount reads an account and refuses a closed one.
//
// A closed account is the control SRS-BIL-013 exists to create: once a
// hospital's books say a visit is settled, a new charge against it would
// restate a period somebody has already reported on.
func (s *Service) requireOpenAccount(ctx context.Context, scope authctx.TenantScope,
	accountID string) (*domain.Account, error) {

	account, err := s.accounts.Get(ctx, scope, accountID)
	if err != nil {
		return nil, err
	}
	if account.Status == domain.AccountClosed {
		return nil, rpcerr.FailedPrecondition("BIL_ACCOUNT_CLOSED",
			"that account was closed on "+
				account.ClosedAt.Format("2006-01-02")+
				"; a correction goes on a credit or debit note")
	}
	return account, nil
}

// appendEvent writes to the transactional outbox.
func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateType, aggregateID string, payload map[string]any,
	now time.Time) error {

	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("BIL_EVENT_ENCODE_FAILED",
			"could not encode event").WithCause(err)
	}

	return s.events.Append(ctx, outbox.Event{
		EventID:       s.ids.NewID(),
		EventType:     eventType,
		SchemaVersion: eventSchemaVersion,
		OccurredAt:    now.UTC(),
		TenantID:      session.TenantID,
		Source:        eventSource,
		AggregateType: aggregateType,
		AggregateID:   aggregateID,
		CorrelationID: session.CorrelationID,
		CausationID:   session.RequestID,
		Actor:         session.SubjectID,
		Payload:       encoded,
	})
}

func (s *Service) appendAudit(ctx context.Context, session authctx.Session,
	r audit.Record, now time.Time) error {

	r.AuditID = s.ids.NewID()
	r.ActorID = session.SubjectID
	r.CorrelationID = session.CorrelationID
	r.RequestID = session.RequestID
	r.PurposeOfUse = string(session.Purpose)
	r.BreakGlass = session.BreakGlass
	r.OccurredAt = now.UTC()
	if r.TenantID == "" {
		r.TenantID = session.TenantID
	}
	return s.audits.Append(ctx, r)
}

func (s *Service) auditDenied(ctx context.Context, session authctx.Session,
	action, resourceType, resourceID, reason string) {

	// Best effort: a denial that cannot be recorded must not turn into a
	// different error for the caller, who is being refused either way.
	_ = s.appendAudit(ctx, session, audit.Record{
		TenantID: session.TenantID, Action: action,
		ResourceType: resourceType, ResourceID: resourceID,
		Outcome: audit.OutcomeDenied, Reason: reason,
	}, s.clock.Now())
}

// billingError maps a domain refusal onto the wire contract.
func billingError(err error) error {
	var blocked domain.BlockedClose
	if errors.As(err, &blocked) {
		// SRS-BIL-013's "blocking exceptions are listed". They travel as field
		// violations so a biller sees all of them at once and can work down the
		// list rather than fixing one and being told about the next.
		violations := make([]rpcerr.FieldViolation, 0, len(blocked.Exceptions))
		for _, exception := range blocked.Exceptions {
			violations = append(violations, rpcerr.FieldViolation{
				Field: string(exception.Check), Reason: exception.Detail,
			})
		}
		return rpcerr.FailedPrecondition("BIL_ACCOUNT_NOT_READY",
			blocked.Error()).WithViolations(violations...)
	}
	if errors.Is(err, domain.ErrNotAllowed) {
		return rpcerr.FailedPrecondition("BIL_NOT_ALLOWED", err.Error())
	}
	if errors.Is(err, domain.ErrInvalid) {
		return rpcerr.Invalid("BIL_INVALID", err.Error())
	}
	return err
}

// mapConflict turns a repository version conflict into the wire contract.
func mapConflict(err error) error {
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("BIL_VERSION_CONFLICT",
			"the record changed since it was read, or is no longer in that state")
	}
	return err
}
