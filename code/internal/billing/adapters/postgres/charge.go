package postgres

import (
	"context"
	"errors"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/billing/domain"
	"github.com/ppusapati/health/code/internal/billing/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Charges persists charges and package consumption (SRS-BIL-003, SRS-BIL-004).
type Charges struct{ *Repository }

// NewCharges constructs the adapter.
func NewCharges(r *Repository) Charges { return Charges{r} }

var _ ports.ChargeRepository = Charges{}

// Insert stores a charge (SRS-BIL-003).
//
// Returns ErrAlreadyRecorded where the source reference has already produced
// one. The INSERT carries ON CONFLICT DO NOTHING and this reads the row count,
// so a redelivered clinical event is a clean no-op rather than an error the
// consumer retries forever.
func (c Charges) Insert(ctx context.Context, scope authctx.TenantScope,
	charge *domain.Charge) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(charge.ID)
	if err != nil {
		return err
	}
	accountID, err := lookupUUID(charge.AccountID)
	if err != nil {
		return err
	}
	patientID, err := lookupUUID(charge.PatientID)
	if err != nil {
		return err
	}
	encounterID, err := lookupUUID(charge.EncounterID)
	if err != nil {
		return err
	}
	facilityID, err := lookupUUID(charge.FacilityID)
	if err != nil {
		return err
	}

	if err := c.queries(ctx).InsertCharge(ctx, sqlcgen.InsertChargeParams{
		ChargeID: id, TenantID: tenantID, AccountID: accountID,
		PatientID: patientID, EncounterID: encounterID, FacilityID: facilityID,
		ServiceCode: charge.ServiceCode, Description: charge.Description,
		Department: charge.Department, RevenueAccount: charge.RevenueAccount,
		Quantity: charge.Quantity, UnitPriceMinor: charge.UnitPrice.Minor,
		Currency:         charge.UnitPrice.Currency,
		TariffContractID: charge.Pricing.ContractID,
		TariffContract:   charge.Pricing.Contract,
		TaxCode:          charge.TaxCode,
		TaxRateBp:        int32(charge.TaxRate),
		TaxInclusive:     charge.TaxInclusive,
		Origin:           string(charge.Origin),
		SourceSystem:     charge.Source.System,
		SourceID:         charge.Source.ID,
		SourceDetail:     charge.Source.Detail,
		EnteredBy:        charge.EnteredBy,
		Reason:           charge.Reason,
		OccurredAt:       timestamptz(charge.OccurredAt),
		PostedAt:         timestamptz(charge.PostedAt),
		Status:           string(charge.Status),
		PackageCode:      charge.PackageID,
		Covered:          charge.Covered,
		CoverageNote:     charge.CoverageNote,
		Version:          charge.Version,
	}); err != nil {
		return err
	}

	// ON CONFLICT DO NOTHING swallows the duplicate, so the only way to tell is
	// to look for the row that is there. Reading it back rather than counting
	// rows, because the caller wants the existing charge rather than the news
	// that one exists.
	if charge.Source.Empty() {
		return nil
	}
	stored, err := c.BySource(ctx, scope, charge.Source)
	if err != nil {
		return err
	}
	if stored.ID != charge.ID {
		return ports.ErrAlreadyRecorded
	}
	return nil
}

// Get reads one charge.
func (c Charges) Get(ctx context.Context, scope authctx.TenantScope,
	chargeID string) (*domain.Charge, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(chargeID)
	if err != nil {
		return nil, err
	}

	row, err := c.queries(ctx).GetCharge(ctx, sqlcgen.GetChargeParams{
		TenantID: tenantID, ChargeID: id,
	})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, notFound()
		}
		return nil, err
	}
	return chargeFromRow(row), nil
}

// BySource reads the charge a clinical event already produced (SRS-BIL-003).
func (c Charges) BySource(ctx context.Context, scope authctx.TenantScope,
	source domain.SourceReference) (*domain.Charge, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	row, err := c.queries(ctx).GetChargeBySource(ctx, sqlcgen.GetChargeBySourceParams{
		TenantID: tenantID, SourceSystem: source.System, SourceID: source.ID,
	})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, notFound()
		}
		return nil, err
	}
	return chargeFromRow(row), nil
}

func chargeFromRow(row sqlcgen.BillingCharge) *domain.Charge {
	return &domain.Charge{
		ID: row.ChargeID.String(), TenantID: row.TenantID.String(),
		AccountID: row.AccountID.String(), PatientID: row.PatientID.String(),
		EncounterID: row.EncounterID.String(), FacilityID: row.FacilityID.String(),
		ServiceCode: row.ServiceCode, Description: row.Description,
		Department: row.Department, RevenueAccount: row.RevenueAccount,
		Quantity:  row.Quantity,
		UnitPrice: domain.Money{Minor: row.UnitPriceMinor, Currency: row.Currency},
		Pricing: domain.PricingResult{
			Price:      domain.Money{Minor: row.UnitPriceMinor, Currency: row.Currency},
			ContractID: row.TariffContractID, Contract: row.TariffContract,
		},
		TaxCode: row.TaxCode, TaxRate: domain.BasisPoints(row.TaxRateBp),
		TaxInclusive: row.TaxInclusive,
		Origin:       domain.ChargeOrigin(row.Origin),
		Source: domain.SourceReference{
			System: row.SourceSystem, ID: row.SourceID, Detail: row.SourceDetail,
		},
		EnteredBy: row.EnteredBy, Reason: row.Reason,
		OccurredAt: timeOrZero(row.OccurredAt), PostedAt: timeOrZero(row.PostedAt),
		Status:    domain.ChargeStatus(row.Status),
		PackageID: row.PackageCode, Covered: row.Covered,
		CoverageNote: row.CoverageNote,
		InvoiceID:    uuidOrEmpty(row.InvoiceID),
		Version:      row.Version,
	}
}

func charges(rows []sqlcgen.BillingCharge) []*domain.Charge {
	out := make([]*domain.Charge, 0, len(rows))
	for _, row := range rows {
		out = append(out, chargeFromRow(row))
	}
	return out
}

// ForAccount lists an account's charges.
func (c Charges) ForAccount(ctx context.Context, scope authctx.TenantScope,
	accountID string, billableOnly bool, limit int32) ([]*domain.Charge, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(accountID)
	if err != nil {
		return nil, err
	}

	rows, err := c.queries(ctx).ListChargesForAccount(ctx,
		sqlcgen.ListChargesForAccountParams{
			TenantID: tenantID, AccountID: id,
			BillableOnly: billableOnly, RowLimit: capLimit(limit),
		})
	if err != nil {
		return nil, err
	}
	return charges(rows), nil
}

// ByStatus lists an account's charges in one state.
func (c Charges) ByStatus(ctx context.Context, scope authctx.TenantScope,
	accountID string, status domain.ChargeStatus) ([]*domain.Charge, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(accountID)
	if err != nil {
		return nil, err
	}

	rows, err := c.queries(ctx).ListChargesByStatus(ctx,
		sqlcgen.ListChargesByStatusParams{
			TenantID: tenantID, AccountID: id, Status: string(status),
		})
	if err != nil {
		return nil, err
	}
	return charges(rows), nil
}

// Unbilled is the revenue-integrity worklist (SRS-BIL-011).
func (c Charges) Unbilled(ctx context.Context, scope authctx.TenantScope,
	facilityID string, limit int32) ([]*domain.Charge, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(facilityID)
	if err != nil {
		return nil, err
	}

	rows, err := c.queries(ctx).ListUnbilledCharges(ctx,
		sqlcgen.ListUnbilledChargesParams{
			TenantID: tenantID, FacilityID: id, RowLimit: capLimit(limit),
		})
	if err != nil {
		return nil, err
	}
	return charges(rows), nil
}

// UpdateStatus moves a charge, guarded on the state it came from.
func (c Charges) UpdateStatus(ctx context.Context, scope authctx.TenantScope,
	charge *domain.Charge, expectedVersion int64,
	expectedStatus domain.ChargeStatus) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(charge.ID)
	if err != nil {
		return err
	}
	invoiceID, err := optionalUUID(charge.InvoiceID)
	if err != nil {
		return err
	}

	affected, err := c.queries(ctx).UpdateChargeStatus(ctx,
		sqlcgen.UpdateChargeStatusParams{
			Status: string(charge.Status), Reason: charge.Reason,
			EnteredBy: charge.EnteredBy, InvoiceID: invoiceID,
			Version:  charge.Version,
			TenantID: tenantID, ChargeID: id,
			ExpectedVersion: expectedVersion, ExpectedStatus: string(expectedStatus),
		})
	if err != nil {
		return err
	}
	if affected == 0 {
		return conflict()
	}
	return nil
}

// UpdateCoverage records what a package did with a charge (SRS-BIL-004).
func (c Charges) UpdateCoverage(ctx context.Context, scope authctx.TenantScope,
	charge *domain.Charge, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(charge.ID)
	if err != nil {
		return err
	}

	affected, err := c.queries(ctx).UpdateChargeCoverage(ctx,
		sqlcgen.UpdateChargeCoverageParams{
			PackageCode: charge.PackageID, Covered: charge.Covered,
			CoverageNote: charge.CoverageNote, Version: charge.Version,
			TenantID: tenantID, ChargeID: id, ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if affected == 0 {
		return conflict()
	}
	return nil
}

// RecordConsumption stores one package-ledger entry (SRS-BIL-004).
func (c Charges) RecordConsumption(ctx context.Context, scope authctx.TenantScope,
	entry domain.Consumption) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	chargeID, err := lookupUUID(entry.ChargeID)
	if err != nil {
		return err
	}
	accountID, err := lookupUUID(entry.AccountID)
	if err != nil {
		return err
	}

	return c.queries(ctx).InsertConsumption(ctx, sqlcgen.InsertConsumptionParams{
		ConsumptionID: uuid.New(), TenantID: tenantID, AccountID: accountID,
		PackageCode: entry.PackageCode, ChargeID: chargeID,
		ServiceCode: entry.ServiceCode, Quantity: entry.Quantity,
		Outcome: string(entry.Outcome), Explanation: entry.Explanation,
		PriceMinor: entry.Price.Minor, Currency: entry.Price.Currency,
		RecordedAt: timestamptz(entry.RecordedAt),
	})
}

// Consumption reads the package ledger (SRS-BIL-004).
func (c Charges) Consumption(ctx context.Context, scope authctx.TenantScope,
	accountID string) ([]domain.Consumption, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(accountID)
	if err != nil {
		return nil, err
	}

	rows, err := c.queries(ctx).ListConsumption(ctx, sqlcgen.ListConsumptionParams{
		TenantID: tenantID, AccountID: id,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Consumption, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Consumption{
			TenantID: row.TenantID.String(), AccountID: row.AccountID.String(),
			PackageCode: row.PackageCode, ChargeID: row.ChargeID.String(),
			ServiceCode: row.ServiceCode, Quantity: row.Quantity,
			Outcome:     domain.CoverageOutcome(row.Outcome),
			Explanation: row.Explanation,
			Price:       domain.Money{Minor: row.PriceMinor, Currency: row.Currency},
			RecordedAt:  timeOrZero(row.RecordedAt),
		})
	}
	return out, nil
}
