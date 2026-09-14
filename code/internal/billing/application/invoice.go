package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/billing/domain"
	"github.com/ppusapati/health/code/internal/billing/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Number sequences (SRS-PLT-014).
const (
	sequenceInvoice = "invoice"
	sequenceReceipt = "receipt"
)

// RaiseInvoiceInput builds a document from the charge ledger (SRS-BIL-005,
// SRS-BIL-006).
type RaiseInvoiceInput struct {
	AccountID string
	Kind      domain.DocumentKind
	// Discount is the concession to apply, where there is one (SRS-BIL-007).
	Discount *domain.Discount
	// Liability is the split after adjudication (SRS-BIL-014). Empty makes the
	// patient liable for the whole amount, recorded explicitly at issue.
	Liability []domain.LiabilityShare
	Notes     string
	// Issue finalises it in the same call. A draft left behind whenever a
	// client crashed between two calls is a draft somebody has to clean up, and
	// SRS-BIL-013's close check would block on it.
	Issue bool
}

// RaiseInvoice builds a document from an account's billable charges
// (SRS-BIL-005, SRS-BIL-006, SRS-BIL-007, SRS-BIL-014).
//
// The lines are a snapshot taken here rather than a join resolved at read time,
// which is what makes SRS-BIL-006's immutability real: a charge voided next week
// does not restate what this document said, because the document does not read
// the charge any more. Issuing it marks its charges invoiced in the same
// transaction, so a document can never exist naming charges still on the
// unbilled worklist.
func (s *Service) RaiseInvoice(ctx context.Context, in RaiseInvoiceInput) (
	*domain.Invoice, error) {

	session, scope, err := s.authorize(ctx, PermInvoiceIssue, "invoice",
		in.AccountID, true)
	if err != nil {
		return nil, err
	}

	account, err := s.requireOpenAccount(ctx, scope, in.AccountID)
	if err != nil {
		return nil, err
	}
	if s.numbers == nil {
		return nil, rpcerr.Internal("BIL_NO_NUMBER_SEQUENCE",
			"this deployment cannot issue invoice numbers")
	}

	kind := in.Kind
	if kind == "" {
		kind = domain.KindFinal
	}

	charges, err := s.charges.ByStatus(ctx, scope, account.ID, domain.ChargePosted)
	if err != nil {
		return nil, err
	}
	if len(charges) > MaxChargesPerInvoice {
		charges = charges[:MaxChargesPerInvoice]
	}

	policySet, err := s.policies.Policy(ctx, scope)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()
	var invoice *domain.Invoice

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		number, err := s.numbers.Issue(ctx, scope, sequenceInvoice, now)
		if err != nil {
			return err
		}

		invoice, err = domain.NewInvoice(s.ids.NewID(), session.TenantID, number,
			kind, account.PatientID, account.EncounterID, account.FacilityID,
			account.ID, session.SubjectID, now)
		if err != nil {
			return billingError(err)
		}
		invoice.PayerID, invoice.CustomerID = account.PayerID, account.CustomerID
		invoice.Notes = in.Notes

		if err := invoice.AddCharges(charges); err != nil {
			return billingError(err)
		}
		if in.Discount != nil {
			if err := s.applyDiscount(ctx, session, invoice, *in.Discount,
				policySet, now); err != nil {
				return err
			}
		}
		if len(in.Liability) > 0 {
			if err := invoice.SetLiability(in.Liability); err != nil {
				return billingError(err)
			}
		}

		if err := s.invoices.Insert(ctx, scope, invoice); err != nil {
			return err
		}
		if !in.Issue {
			return s.appendAudit(ctx, session, audit.Record{
				Action: "bil.invoice.issue", ResourceType: "invoice",
				ResourceID: invoice.ID, Outcome: audit.OutcomeSuccess,
				Reason: "drafted " + invoice.Number,
			}, now)
		}
		return s.issue(ctx, session, scope, invoice, charges, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return invoice, nil
}

// applyDiscount checks a concession against the applier's limit (SRS-BIL-007).
//
// A discount inside the limit goes on with the applier's name; one beyond it
// needs somebody holding the approval permission, and the approval names them.
// A limit a person can approve for themselves is not a limit, so the approver
// is checked against a permission the applier's role does not carry.
func (s *Service) applyDiscount(ctx context.Context, session authctx.Session,
	invoice *domain.Invoice, d domain.Discount, policySet ports.Policy,
	now time.Time) error {

	if !session.HasPermission(PermDiscountApply) {
		s.auditDenied(ctx, session, PermDiscountApply, "invoice", invoice.ID,
			"a concession needs "+PermDiscountApply)
		return rpcerr.PermissionDenied("BIL_DISCOUNT_DENIED",
			"applying a concession needs "+PermDiscountApply)
	}
	d.AppliedBy = session.SubjectID

	if !withinAnyLimit(d, invoice.Subtotal, session.Roles, policySet) {
		// Beyond what this role may give on its own. SRS-BIL-007's "over-limit
		// request routes for approval", which here means the approval must have
		// already been obtained and named.
		if d.ApprovedBy == "" {
			return rpcerr.FailedPrecondition("BIL_DISCOUNT_OVER_LIMIT",
				"that concession is beyond this role's limit and needs approval")
		}
		if !session.HasPermission(PermDiscountApprove) &&
			d.ApprovedBy == session.SubjectID {
			// Self-approval by somebody without the authority. Recorded as a
			// denial rather than silently dropped, because an attempt is the
			// thing a governance report wants to see.
			s.auditDenied(ctx, session, PermDiscountApprove, "invoice", invoice.ID,
				"an over-limit concession was self-approved")
			return rpcerr.PermissionDenied("BIL_APPROVAL_DENIED",
				"an over-limit concession must be approved by somebody holding "+
					PermDiscountApprove)
		}
	}

	if err := invoice.ApplyDiscount(d, now); err != nil {
		return billingError(err)
	}
	return nil
}

// withinAnyLimit reports whether any of the caller's roles permits a discount.
//
// Any rather than all: a person who is both a billing clerk and a billing
// manager gives concessions with the manager's authority, which is what
// carrying the role means.
func withinAnyLimit(d domain.Discount, subtotal domain.Money, roles []string,
	policySet ports.Policy) bool {

	for _, role := range roles {
		limit, ok := policySet.DiscountLimits[role]
		if !ok {
			continue
		}
		if limit.Within(d, subtotal) {
			return true
		}
	}
	return false
}

// issue finalises a document and marks its charges invoiced (SRS-BIL-006).
//
// One transaction, so a document can never exist naming charges the unbilled
// worklist still reports, and a charge can never be marked invoiced against a
// document that was not written.
func (s *Service) issue(ctx context.Context, session authctx.Session,
	scope authctx.TenantScope, invoice *domain.Invoice, charges []*domain.Charge,
	now time.Time) error {

	expectedVersion := invoice.RowVersion
	if err := invoice.Issue(session.SubjectID, now); err != nil {
		return billingError(err)
	}
	if err := s.invoices.Issue(ctx, scope, invoice, expectedVersion); err != nil {
		return err
	}

	for _, charge := range charges {
		if charge.Covered {
			continue
		}
		chargeVersion, chargeStatus := charge.Version, charge.Status
		if err := charge.MarkInvoiced(invoice.ID); err != nil {
			return billingError(err)
		}
		if err := s.charges.UpdateStatus(ctx, scope, charge, chargeVersion,
			chargeStatus); err != nil {
			return err
		}
	}

	// The document posts to the ledger. A credit note posts negative, which is
	// what makes the balance come out right without anybody consulting a
	// direction flag.
	if invoice.Kind.Payable() {
		if err := s.ledger.Append(ctx, scope, domain.LedgerEntry{
			ID: s.ids.NewID(), TenantID: session.TenantID,
			AccountID: invoice.AccountID, PatientID: invoice.PatientID,
			EncounterID: invoice.EncounterID, FacilityID: invoice.FacilityID,
			Kind: domain.EntryInvoice, Amount: invoice.SignedTotal(),
			InvoiceID:  invoice.ID,
			RecordedBy: session.SubjectID,
			OccurredAt: now, RecordedAt: now,
		}); err != nil {
			return err
		}
	}

	if err := s.appendEvent(ctx, session, EventInvoiceFinalized, "invoice",
		invoice.ID, invoiceEventPayload(invoice), now); err != nil {
		return err
	}
	return s.appendAudit(ctx, session, audit.Record{
		Action: "bil.invoice.issue", ResourceType: "invoice",
		ResourceID: invoice.ID, Outcome: audit.OutcomeSuccess,
		Reason: "issued " + invoice.Number + " for " + invoice.Total.String(),
	}, now)
}

// invoiceEventPayload is what invoice.finalized carries (SRS-BIL-016).
func invoiceEventPayload(i *domain.Invoice) map[string]any {
	parties := make([]string, 0, len(i.Liability))
	for _, share := range i.Liability {
		parties = append(parties, string(share.Party))
	}
	return map[string]any{
		"invoice_id": i.ID, "number": i.Number, "kind": string(i.Kind),
		"account_id": i.AccountID, "patient_id": i.PatientID,
		"encounter_id": i.EncounterID, "facility_id": i.FacilityID,
		"subtotal_minor": i.Subtotal.Minor, "discount_minor": i.Discount.Minor,
		"tax_minor": i.Tax.Minor, "total_minor": i.Total.Minor,
		"currency": i.Total.Currency, "line_count": len(i.Lines),
		"responsible_parties": parties,
	}
}

// CorrectInvoiceInput raises the note that corrects an issued document
// (SRS-BIL-010).
type CorrectInvoiceInput struct {
	InvoiceID string
	Kind      domain.DocumentKind
	Lines     []domain.InvoiceLine
	Reason    string
}

// CorrectInvoice raises a credit or debit note against an issued document
// (SRS-BIL-010).
//
// A new document rather than an edit. The patient is holding a copy of the
// original, and a system that can quietly change what a document said is a
// system whose documents prove nothing.
func (s *Service) CorrectInvoice(ctx context.Context, in CorrectInvoiceInput) (
	*domain.Invoice, error) {

	session, scope, err := s.authorize(ctx, PermInvoiceIssue, "invoice",
		in.InvoiceID, true)
	if err != nil {
		return nil, err
	}
	if s.numbers == nil {
		return nil, rpcerr.Internal("BIL_NO_NUMBER_SEQUENCE",
			"this deployment cannot issue invoice numbers")
	}

	original, err := s.invoices.Get(ctx, scope, in.InvoiceID)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()
	var note *domain.Invoice

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		number, err := s.numbers.Issue(ctx, scope, sequenceInvoice, now)
		if err != nil {
			return err
		}

		note, err = original.Correct(s.ids.NewID(), number, in.Kind, in.Lines,
			in.Reason, session.SubjectID, now)
		if err != nil {
			return billingError(err)
		}
		if err := s.invoices.Insert(ctx, scope, note); err != nil {
			return err
		}
		return s.issue(ctx, session, scope, note, nil, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return note, nil
}

// Invoice reads one document.
func (s *Service) Invoice(ctx context.Context, invoiceID string) (
	*domain.Invoice, error) {

	session, scope, err := s.authorize(ctx, PermBillingRead, "invoice",
		invoiceID, false)
	if err != nil {
		return nil, err
	}
	invoice, err := s.invoices.Get(ctx, scope, invoiceID)
	if err != nil {
		return nil, err
	}
	// Reads of a bill are audited: what a patient was treated for is often
	// readable from what they were charged for.
	_ = s.appendAudit(ctx, session, audit.Record{
		Action: "bil.account.read", ResourceType: "invoice",
		ResourceID: invoice.ID, Outcome: audit.OutcomeSuccess,
	}, s.clock.Now())
	return invoice, nil
}

// Invoices lists an account's documents.
func (s *Service) Invoices(ctx context.Context, accountID string, limit int32) (
	[]*domain.Invoice, error) {

	_, scope, err := s.authorize(ctx, PermBillingRead, "invoice", accountID, false)
	if err != nil {
		return nil, err
	}
	return s.invoices.ForAccount(ctx, scope, accountID, clampPageSize(limit))
}
