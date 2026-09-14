package application

import (
	"context"

	"github.com/ppusapati/health/code/internal/billing/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// CloseAccount settles an encounter's financial record (SRS-BIL-013).
//
// The checks run against live state rather than against a flag: the uninvoiced
// charges, the held charges, the draft documents, the ledger and the patient's
// own share are all read now, so an account cannot pass because somebody set
// something earlier. A refusal lists every exception at once, which is the
// acceptance criterion and is also the only way a biller can work the list
// rather than fixing one thing and being told about the next.
func (s *Service) CloseAccount(ctx context.Context, accountID string) (
	*domain.Account, error) {

	session, scope, err := s.authorize(ctx, PermAccountClose, "account",
		accountID, true)
	if err != nil {
		return nil, err
	}

	account, err := s.accounts.Get(ctx, scope, accountID)
	if err != nil {
		return nil, err
	}
	if account.Status == domain.AccountClosed {
		return account, nil
	}

	exceptions, err := s.closeExceptions(ctx, scope, account)
	if err != nil {
		return nil, err
	}

	expectedVersion := account.Version
	now := s.clock.Now()
	if err := account.Close(session.SubjectID, exceptions, now); err != nil {
		// The refusal carries every exception, which billingError turns into
		// field violations so a client can render the list.
		s.auditDenied(ctx, session, PermAccountClose, "account", accountID,
			err.Error())
		return nil, billingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.accounts.Close(ctx, scope, account, expectedVersion); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "bil.account.close", ResourceType: "account",
			ResourceID: account.ID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return account, nil
}

// CloseReadiness reports what stands in the way without attempting the close
// (SRS-BIL-013).
//
// Its own call because a biller wants to see the list before trying: an
// exception report that only arrives as an error is one people discover by
// failing.
func (s *Service) CloseReadiness(ctx context.Context, accountID string) (
	[]domain.CloseException, error) {

	_, scope, err := s.authorize(ctx, PermBillingRead, "account", accountID, false)
	if err != nil {
		return nil, err
	}
	account, err := s.accounts.Get(ctx, scope, accountID)
	if err != nil {
		return nil, err
	}
	return s.closeExceptions(ctx, scope, account)
}

func (s *Service) closeExceptions(ctx context.Context, scope authctx.TenantScope,
	account *domain.Account) ([]domain.CloseException, error) {

	policySet, err := s.policies.Policy(ctx, scope)
	if err != nil {
		return nil, err
	}

	uninvoiced, err := s.charges.ByStatus(ctx, scope, account.ID, domain.ChargePosted)
	if err != nil {
		return nil, err
	}
	held, err := s.charges.ByStatus(ctx, scope, account.ID, domain.ChargeHeld)
	if err != nil {
		return nil, err
	}
	drafts, err := s.invoices.Drafts(ctx, scope, account.ID)
	if err != nil {
		return nil, err
	}
	entries, err := s.ledger.Entries(ctx, scope, account.ID)
	if err != nil {
		return nil, err
	}
	patientShare, err := s.patientLiability(ctx, scope, account, entries)
	if err != nil {
		return nil, err
	}

	exceptions, err := policySet.Close.CheckClose(domain.CloseInput{
		UninvoicedCharges: uninvoiced,
		HeldCharges:       held,
		DraftInvoices:     drafts,
		Entries:           entries,
		PatientLiability:  patientShare,
	})
	if err != nil {
		return nil, billingError(err)
	}
	return exceptions, nil
}

// patientLiability is what the patient themselves still owes (SRS-BIL-014).
//
// The issued documents' patient shares, less everything the patient has paid.
// Computed rather than stored because a share is a property of a document and
// a payment is a property of the ledger, and keeping a third number in step
// with both is how the three stop agreeing.
func (s *Service) patientLiability(ctx context.Context, scope authctx.TenantScope,
	account *domain.Account, entries []domain.LedgerEntry) (domain.Money, error) {

	invoices, err := s.invoices.ForAccount(ctx, scope, account.ID, MaxPageSize)
	if err != nil {
		return domain.Money{}, err
	}

	owed := domain.Money{Minor: 0, Currency: account.Currency}
	for _, invoice := range invoices {
		if invoice.Status != domain.InvoiceIssued || !invoice.Kind.Payable() {
			continue
		}
		sign := int64(1)
		if invoice.Kind == domain.KindCredit {
			sign = -1
		}
		for _, share := range invoice.Liability {
			if share.Party != domain.LiabilityPatient {
				continue
			}
			next, err := owed.Add(domain.Money{
				Minor: sign * share.Amount.Minor, Currency: share.Amount.Currency,
			})
			if err != nil {
				return domain.Money{}, err
			}
			owed = next
		}
	}

	for _, entry := range entries {
		switch entry.Kind {
		case domain.EntryPayment, domain.EntryDepositApplied, domain.EntryWriteOff:
			if entry.Method == domain.MethodPayer {
				// A settlement from an insurer pays the insurer's share, not
				// the patient's. Netting it here would show a patient as
				// settled when their co-payment is still outstanding.
				continue
			}
			next, err := owed.Add(entry.Amount)
			if err != nil {
				return domain.Money{}, err
			}
			owed = next
		case domain.EntryRefund:
			next, err := owed.Add(entry.Amount)
			if err != nil {
				return domain.Money{}, err
			}
			owed = next
		}
	}
	return owed, nil
}

// RevenueIntegrity is the worklist of what has not been billed (SRS-BIL-011).
//
// Two kinds of exception together. The charges that have not reached a bill
// this context knows about on its own; the completed services with no charge at
// all it only knows about because the caller supplies the events, since "what
// was delivered" is the clinical contexts' fact rather than billing's.
func (s *Service) RevenueIntegrity(ctx context.Context, facilityID string,
	events []domain.BillableEvent, limit int32) ([]domain.RevenueException, error) {

	_, scope, err := s.authorize(ctx, PermBillingRead, "revenue_integrity",
		facilityID, false)
	if err != nil {
		return nil, err
	}

	charges, err := s.charges.Unbilled(ctx, scope, facilityID, clampPageSize(limit))
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()
	exceptions := domain.FindChargeExceptions(charges, now)
	if len(events) > 0 {
		exceptions = append(exceptions,
			domain.FindUnbilled(events, charges, now)...)
	}
	domain.SortExceptions(exceptions)
	return exceptions, nil
}

// OpenShift starts a cashier's session (SRS-BIL-015).
func (s *Service) OpenShift(ctx context.Context, facilityID, counterID string,
	openingFloat domain.Money) (*domain.Shift, error) {

	session, scope, err := s.authorize(ctx, PermShiftManage, "shift", counterID, true)
	if err != nil {
		return nil, err
	}

	policySet, err := s.policies.Policy(ctx, scope)
	if err != nil {
		return nil, err
	}
	if openingFloat.Currency == "" {
		openingFloat.Currency = policySet.Currency
	}

	now := s.clock.Now()
	shift, err := domain.OpenShift(s.ids.NewID(), session.TenantID, facilityID,
		counterID, session.SubjectID, openingFloat, now)
	if err != nil {
		return nil, billingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.shifts.Insert(ctx, scope, shift); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "bil.shift.manage", ResourceType: "shift",
			ResourceID: shift.ID, Outcome: audit.OutcomeSuccess,
			Reason: "opened at " + counterID + " with " + openingFloat.String(),
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return shift, nil
}

// CloseShift counts a drawer (SRS-BIL-015).
//
// What the drawer should hold is computed from the ledger here rather than
// taken from the caller, so a cashier cannot make the count agree by adjusting
// the expectation. A variance within the tenant's threshold reconciles with a
// reason; anything beyond it waits for a supervisor.
func (s *Service) CloseShift(ctx context.Context, shiftID string,
	counted domain.Money, reason string) (*domain.Shift, error) {

	session, scope, err := s.authorize(ctx, PermShiftManage, "shift", shiftID, true)
	if err != nil {
		return nil, err
	}

	shift, err := s.shifts.Get(ctx, scope, shiftID)
	if err != nil {
		return nil, err
	}
	if shift.CashierID != session.SubjectID &&
		!session.HasPermission(PermShiftApprove) {
		// A cashier closes their own drawer. Somebody else closing it is a
		// supervisor taking it over, which is a different act and takes the
		// approval permission.
		return nil, rpcerr.PermissionDenied("BIL_SHIFT_NOT_YOURS",
			"that drawer belongs to another cashier")
	}

	entries, err := s.ledger.ForShift(ctx, scope, shiftID)
	if err != nil {
		return nil, err
	}
	expected, err := domain.ExpectedCashFor(shift.OpeningFloat, entries)
	if err != nil {
		return nil, billingError(err)
	}

	policySet, err := s.policies.Policy(ctx, scope)
	if err != nil {
		return nil, err
	}
	if counted.Currency == "" {
		counted.Currency = shift.OpeningFloat.Currency
	}

	expectedVersion := shift.Version
	now := s.clock.Now()
	if err := shift.Close(counted, expected, reason, policySet.Variance,
		now); err != nil {
		return nil, billingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.shifts.Close(ctx, scope, shift, expectedVersion); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "bil.shift.manage", ResourceType: "shift",
			ResourceID: shift.ID, Outcome: audit.OutcomeSuccess,
			Reason: "counted " + counted.String() + " against " + expected.String() +
				", variance " + shift.Variance.String(),
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return shift, nil
}

// ApproveShift signs off a variance beyond the threshold (SRS-BIL-015).
func (s *Service) ApproveShift(ctx context.Context, shiftID string) (
	*domain.Shift, error) {

	session, scope, err := s.authorize(ctx, PermShiftApprove, "shift", shiftID, true)
	if err != nil {
		return nil, err
	}

	shift, err := s.shifts.Get(ctx, scope, shiftID)
	if err != nil {
		return nil, err
	}

	expectedVersion := shift.Version
	now := s.clock.Now()
	if err := shift.Approve(session.SubjectID, now); err != nil {
		return nil, billingError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.shifts.Approve(ctx, scope, shift, expectedVersion); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "bil.shift.approve", ResourceType: "shift",
			ResourceID: shift.ID, Outcome: audit.OutcomeSuccess,
			Reason: "variance " + shift.Variance.String() + " approved: " +
				shift.VarianceReason,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return shift, nil
}

// Shifts lists a facility's cashier sessions.
func (s *Service) Shifts(ctx context.Context, facilityID string, limit int32) (
	[]*domain.Shift, error) {

	_, scope, err := s.authorize(ctx, PermShiftManage, "shift", facilityID, false)
	if err != nil {
		return nil, err
	}
	return s.shifts.List(ctx, scope, facilityID, clampPageSize(limit))
}
