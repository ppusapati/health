package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/billing/domain"
	"github.com/ppusapati/health/code/internal/billing/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Ledger persists account movements (SRS-BIL-008, SRS-BIL-009, SRS-BIL-012).
//
// Append and read, and nothing else. There is no Update and no Delete on this
// type because there is no such query, which is what makes SRS-BIL-012's
// "balance derives from ledger" true rather than aspirational: the sum of what
// is there is the whole of the answer.
type Ledger struct{ *Repository }

// NewLedger constructs the adapter.
func NewLedger(r *Repository) Ledger { return Ledger{r} }

var _ ports.LedgerRepository = Ledger{}

// Append stores a movement (SRS-BIL-008).
//
// Returns ErrAlreadyRecorded where the idempotency key has already been used on
// this account. The INSERT carries ON CONFLICT DO NOTHING and this reads back
// the row that is there, so a retried payment submission takes money once.
func (l Ledger) Append(ctx context.Context, scope authctx.TenantScope,
	e domain.LedgerEntry) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(e.ID)
	if err != nil {
		return err
	}
	accountID, err := lookupUUID(e.AccountID)
	if err != nil {
		return err
	}
	patientID, err := lookupUUID(e.PatientID)
	if err != nil {
		return err
	}
	encounterID, err := lookupUUID(e.EncounterID)
	if err != nil {
		return err
	}
	facilityID, err := lookupUUID(e.FacilityID)
	if err != nil {
		return err
	}
	invoiceID, err := optionalUUID(e.InvoiceID)
	if err != nil {
		return err
	}
	paymentID, err := optionalUUID(e.PaymentID)
	if err != nil {
		return err
	}
	refundOf, err := optionalUUID(e.RefundOfPaymentID)
	if err != nil {
		return err
	}
	shiftID, err := optionalUUID(e.ShiftID)
	if err != nil {
		return err
	}

	if err := l.queries(ctx).InsertLedgerEntry(ctx, sqlcgen.InsertLedgerEntryParams{
		EntryID: id, TenantID: tenantID, AccountID: accountID,
		PatientID: patientID, EncounterID: encounterID, FacilityID: facilityID,
		Kind: string(e.Kind), AmountMinor: e.Amount.Minor,
		Currency:  e.Amount.Currency,
		InvoiceID: invoiceID, PaymentID: paymentID, RefundOfPaymentID: refundOf,
		Method: string(e.Method), ProviderRef: e.ProviderRef,
		ReceiptNumber: e.ReceiptNumber, ShiftID: shiftID,
		IdempotencyKey: e.IdempotencyKey,
		Reason:         e.Reason, RecordedBy: e.RecordedBy, ApprovedBy: e.ApprovedBy,
		OccurredAt: timestamptz(e.OccurredAt), RecordedAt: timestamptz(e.RecordedAt),
	}); err != nil {
		return err
	}

	if e.IdempotencyKey == "" {
		return nil
	}
	stored, err := l.ByIdempotencyKey(ctx, scope, e.AccountID, e.IdempotencyKey)
	if err != nil {
		return err
	}
	if stored.ID != e.ID {
		return ports.ErrAlreadyRecorded
	}
	return nil
}

// Entries reads an account's ledger (SRS-BIL-012).
func (l Ledger) Entries(ctx context.Context, scope authctx.TenantScope,
	accountID string) ([]domain.LedgerEntry, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(accountID)
	if err != nil {
		return nil, err
	}

	rows, err := l.queries(ctx).ListLedgerEntries(ctx, sqlcgen.ListLedgerEntriesParams{
		TenantID: tenantID, AccountID: id,
	})
	if err != nil {
		return nil, err
	}
	return ledgerEntries(rows), nil
}

// ByIdempotencyKey reads the entry a retried submission already produced.
func (l Ledger) ByIdempotencyKey(ctx context.Context, scope authctx.TenantScope,
	accountID, key string) (domain.LedgerEntry, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.LedgerEntry{}, err
	}
	id, err := lookupUUID(accountID)
	if err != nil {
		return domain.LedgerEntry{}, err
	}

	row, err := l.queries(ctx).GetLedgerEntryByIdempotencyKey(ctx,
		sqlcgen.GetLedgerEntryByIdempotencyKeyParams{
			TenantID: tenantID, AccountID: id, IdempotencyKey: key,
		})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return domain.LedgerEntry{}, notFound()
		}
		return domain.LedgerEntry{}, err
	}
	return ledgerEntryFromRow(row), nil
}

// ForShift reads the movements a drawer is reconciled against (SRS-BIL-015).
func (l Ledger) ForShift(ctx context.Context, scope authctx.TenantScope,
	shiftID string) ([]domain.LedgerEntry, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := optionalUUID(shiftID)
	if err != nil {
		return nil, err
	}

	rows, err := l.queries(ctx).ListShiftEntries(ctx, sqlcgen.ListShiftEntriesParams{
		TenantID: tenantID, ShiftID: id,
	})
	if err != nil {
		return nil, err
	}
	return ledgerEntries(rows), nil
}

func ledgerEntries(rows []sqlcgen.BillingLedgerEntry) []domain.LedgerEntry {
	out := make([]domain.LedgerEntry, 0, len(rows))
	for _, row := range rows {
		out = append(out, ledgerEntryFromRow(row))
	}
	return out
}

func ledgerEntryFromRow(row sqlcgen.BillingLedgerEntry) domain.LedgerEntry {
	return domain.LedgerEntry{
		ID: row.EntryID.String(), TenantID: row.TenantID.String(),
		AccountID: row.AccountID.String(), PatientID: row.PatientID.String(),
		EncounterID: row.EncounterID.String(), FacilityID: row.FacilityID.String(),
		Kind:              domain.EntryKind(row.Kind),
		Amount:            domain.Money{Minor: row.AmountMinor, Currency: row.Currency},
		InvoiceID:         uuidOrEmpty(row.InvoiceID),
		PaymentID:         uuidOrEmpty(row.PaymentID),
		RefundOfPaymentID: uuidOrEmpty(row.RefundOfPaymentID),
		Method:            domain.PaymentMethod(row.Method),
		ProviderRef:       row.ProviderRef,
		ReceiptNumber:     row.ReceiptNumber,
		ShiftID:           uuidOrEmpty(row.ShiftID),
		IdempotencyKey:    row.IdempotencyKey,
		Reason:            row.Reason,
		RecordedBy:        row.RecordedBy, ApprovedBy: row.ApprovedBy,
		OccurredAt: timeOrZero(row.OccurredAt), RecordedAt: timeOrZero(row.RecordedAt),
	}
}

// Shifts persists cashier sessions (SRS-BIL-015).
type Shifts struct{ *Repository }

// NewShifts constructs the adapter.
func NewShifts(r *Repository) Shifts { return Shifts{r} }

var _ ports.ShiftRepository = Shifts{}

// Insert opens a shift.
func (s Shifts) Insert(ctx context.Context, scope authctx.TenantScope,
	shift *domain.Shift) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(shift.ID)
	if err != nil {
		return err
	}
	facilityID, err := lookupUUID(shift.FacilityID)
	if err != nil {
		return err
	}

	return s.queries(ctx).InsertShift(ctx, sqlcgen.InsertShiftParams{
		ShiftID: id, TenantID: tenantID, FacilityID: facilityID,
		CounterID: shift.CounterID, CashierID: shift.CashierID,
		OpeningFloatMinor: shift.OpeningFloat.Minor,
		Currency:          shift.OpeningFloat.Currency,
		OpenedAt:          timestamptz(shift.OpenedAt),
		Version:           shift.Version,
	})
}

// Get reads one shift.
func (s Shifts) Get(ctx context.Context, scope authctx.TenantScope,
	shiftID string) (*domain.Shift, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(shiftID)
	if err != nil {
		return nil, err
	}

	row, err := s.queries(ctx).GetShift(ctx, sqlcgen.GetShiftParams{
		TenantID: tenantID, ShiftID: id,
	})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, notFound()
		}
		return nil, err
	}
	return shiftFromRow(row), nil
}

// Open reads the session currently at a counter.
func (s Shifts) Open(ctx context.Context, scope authctx.TenantScope,
	facilityID, counterID string) (*domain.Shift, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(facilityID)
	if err != nil {
		return nil, err
	}

	row, err := s.queries(ctx).GetOpenShift(ctx, sqlcgen.GetOpenShiftParams{
		TenantID: tenantID, FacilityID: id, CounterID: counterID,
	})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, notFound()
		}
		return nil, err
	}
	return shiftFromRow(row), nil
}

func shiftFromRow(row sqlcgen.BillingCashierShift) *domain.Shift {
	shift := &domain.Shift{
		ID: row.ShiftID.String(), TenantID: row.TenantID.String(),
		FacilityID: row.FacilityID.String(),
		CounterID:  row.CounterID, CashierID: row.CashierID,
		OpeningFloat:   domain.Money{Minor: row.OpeningFloatMinor, Currency: row.Currency},
		OpenedAt:       timeOrZero(row.OpenedAt),
		Status:         domain.ShiftStatus(row.Status),
		VarianceReason: row.VarianceReason,
		ApprovedBy:     row.ApprovedBy, ApprovedAt: timeOrZero(row.ApprovedAt),
		ClosedAt: timeOrZero(row.ClosedAt), Version: row.Version,
	}
	if row.CountedMinor != nil {
		shift.CountedCash = domain.Money{Minor: *row.CountedMinor, Currency: row.Currency}
	}
	if row.ExpectedMinor != nil {
		shift.ExpectedCash = domain.Money{Minor: *row.ExpectedMinor, Currency: row.Currency}
	}
	if row.VarianceMinor != nil {
		shift.Variance = domain.Money{Minor: *row.VarianceMinor, Currency: row.Currency}
	}
	return shift
}

// Close counts a drawer (SRS-BIL-015).
func (s Shifts) Close(ctx context.Context, scope authctx.TenantScope,
	shift *domain.Shift, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(shift.ID)
	if err != nil {
		return err
	}

	counted, expected := shift.CountedCash.Minor, shift.ExpectedCash.Minor
	variance := shift.Variance.Minor
	affected, err := s.queries(ctx).CloseShift(ctx, sqlcgen.CloseShiftParams{
		CountedMinor: &counted, ExpectedMinor: &expected, VarianceMinor: &variance,
		VarianceReason: shift.VarianceReason, Status: string(shift.Status),
		ClosedAt: timestamptz(shift.ClosedAt), Version: shift.Version,
		TenantID: tenantID, ShiftID: id, ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if affected == 0 {
		return conflict()
	}
	return nil
}

// Approve settles a shift a supervisor has reviewed (SRS-BIL-015).
func (s Shifts) Approve(ctx context.Context, scope authctx.TenantScope,
	shift *domain.Shift, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(shift.ID)
	if err != nil {
		return err
	}

	affected, err := s.queries(ctx).ApproveShift(ctx, sqlcgen.ApproveShiftParams{
		ApprovedBy: shift.ApprovedBy, ApprovedAt: timestamptz(shift.ApprovedAt),
		Version:  shift.Version,
		TenantID: tenantID, ShiftID: id, ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if affected == 0 {
		return conflict()
	}
	return nil
}

// List reads a facility's shifts, most recent first.
func (s Shifts) List(ctx context.Context, scope authctx.TenantScope,
	facilityID string, limit int32) ([]*domain.Shift, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(facilityID)
	if err != nil {
		return nil, err
	}

	rows, err := s.queries(ctx).ListShifts(ctx, sqlcgen.ListShiftsParams{
		TenantID: tenantID, FacilityID: id, RowLimit: capLimit(limit),
	})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.Shift, 0, len(rows))
	for _, row := range rows {
		out = append(out, shiftFromRow(row))
	}
	return out, nil
}

// Policies persists the tenant's billing configuration.
type Policies struct{ *Repository }

// NewPolicies constructs the adapter.
func NewPolicies(r *Repository) Policies { return Policies{r} }

var _ ports.PolicyRepository = Policies{}

// SetPolicy records the configuration.
func (p Policies) SetPolicy(ctx context.Context, scope authctx.TenantScope,
	policy ports.Policy, updatedBy string, now time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	limits, err := toJSON(policy.DiscountLimits)
	if err != nil {
		return err
	}

	checks := make([]string, 0, len(policy.Close.Required))
	for check, required := range policy.Close.Required {
		if required {
			checks = append(checks, string(check))
		}
	}

	return p.queries(ctx).SetBillingPolicy(ctx, sqlcgen.SetBillingPolicyParams{
		TenantID: tenantID, DiscountLimits: limits,
		CloseChecks:            orEmptyString(checks),
		AllowPayerBalance:      policy.Close.AllowPayerBalance,
		VarianceThresholdMinor: policy.Variance.MaxMinor,
		Currency:               policy.Currency,
		UpdatedBy:              updatedBy, UpdatedAt: timestamptz(now),
	})
}

// Policy returns the tenant's configuration merged over the domain default.
func (p Policies) Policy(ctx context.Context, scope authctx.TenantScope) (
	ports.Policy, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return ports.Policy{}, err
	}

	row, err := p.queries(ctx).GetBillingPolicy(ctx, tenantID)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return ports.DefaultPolicy(), nil
		}
		return ports.Policy{}, err
	}

	policy := ports.DefaultPolicy()
	if err := fromJSON(row.DiscountLimits, &policy.DiscountLimits); err != nil {
		return ports.Policy{}, err
	}
	if len(row.CloseChecks) > 0 {
		required := make(map[domain.CloseCheck]bool, len(row.CloseChecks))
		for _, check := range row.CloseChecks {
			required[domain.CloseCheck(check)] = true
		}
		policy.Close.Required = required
	}
	policy.Close.AllowPayerBalance = row.AllowPayerBalance
	policy.Variance = domain.VarianceThreshold{MaxMinor: row.VarianceThresholdMinor}
	policy.Currency = row.Currency
	return policy, nil
}
