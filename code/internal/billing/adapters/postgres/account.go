package postgres

import (
	"context"
	"errors"

	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/billing/domain"
	"github.com/ppusapati/health/code/internal/billing/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Accounts persists financial accounts (SRS-BIL-013).
type Accounts struct{ *Repository }

// NewAccounts constructs the adapter.
func NewAccounts(r *Repository) Accounts { return Accounts{r} }

var _ ports.AccountRepository = Accounts{}

// Insert opens an account.
func (a Accounts) Insert(ctx context.Context, scope authctx.TenantScope,
	acc *domain.Account) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(acc.ID)
	if err != nil {
		return err
	}
	patientID, err := lookupUUID(acc.PatientID)
	if err != nil {
		return err
	}
	encounterID, err := lookupUUID(acc.EncounterID)
	if err != nil {
		return err
	}
	facilityID, err := lookupUUID(acc.FacilityID)
	if err != nil {
		return err
	}

	return a.queries(ctx).InsertAccount(ctx, sqlcgen.InsertAccountParams{
		AccountID: id, TenantID: tenantID,
		PatientID: patientID, EncounterID: encounterID, FacilityID: facilityID,
		Currency: acc.Currency,
		PayerID:  acc.PayerID, CustomerID: acc.CustomerID,
		RoomClass: acc.RoomClass, PackageCode: acc.PackageCode,
		Status:    string(acc.Status),
		CreatedAt: timestamptz(acc.CreatedAt), UpdatedAt: timestamptz(acc.UpdatedAt),
		Version: acc.Version,
	})
}

// Get reads one account.
func (a Accounts) Get(ctx context.Context, scope authctx.TenantScope,
	accountID string) (*domain.Account, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(accountID)
	if err != nil {
		return nil, err
	}

	row, err := a.queries(ctx).GetAccount(ctx, sqlcgen.GetAccountParams{
		TenantID: tenantID, AccountID: id,
	})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, notFound()
		}
		return nil, err
	}
	return accountFromRow(row), nil
}

// ForEncounter reads a visit's account.
func (a Accounts) ForEncounter(ctx context.Context, scope authctx.TenantScope,
	encounterID string) (*domain.Account, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(encounterID)
	if err != nil {
		return nil, err
	}

	row, err := a.queries(ctx).GetAccountForEncounter(ctx,
		sqlcgen.GetAccountForEncounterParams{TenantID: tenantID, EncounterID: id})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, notFound()
		}
		return nil, err
	}
	return accountFromRow(row), nil
}

func accountFromRow(row sqlcgen.BillingAccount) *domain.Account {
	return &domain.Account{
		ID: row.AccountID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID.String(), EncounterID: row.EncounterID.String(),
		FacilityID: row.FacilityID.String(), Currency: row.Currency,
		PayerID: row.PayerID, CustomerID: row.CustomerID,
		RoomClass: row.RoomClass, PackageCode: row.PackageCode,
		Status:   domain.AccountStatus(row.Status),
		ClosedBy: row.ClosedBy, ClosedAt: timeOrZero(row.ClosedAt),
		CreatedAt: timeOrZero(row.CreatedAt), UpdatedAt: timeOrZero(row.UpdatedAt),
		Version: row.Version,
	}
}

// UpdateCoverage records the payer, room class and package an account bills
// under.
func (a Accounts) UpdateCoverage(ctx context.Context, scope authctx.TenantScope,
	acc *domain.Account, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(acc.ID)
	if err != nil {
		return err
	}

	affected, err := a.queries(ctx).UpdateAccountCoverage(ctx,
		sqlcgen.UpdateAccountCoverageParams{
			PayerID: acc.PayerID, CustomerID: acc.CustomerID,
			RoomClass: acc.RoomClass, PackageCode: acc.PackageCode,
			UpdatedAt: timestamptz(acc.UpdatedAt), Version: acc.Version,
			TenantID: tenantID, AccountID: id, ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if affected == 0 {
		return conflict()
	}
	return nil
}

// Close settles an account (SRS-BIL-013).
func (a Accounts) Close(ctx context.Context, scope authctx.TenantScope,
	acc *domain.Account, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(acc.ID)
	if err != nil {
		return err
	}

	affected, err := a.queries(ctx).CloseAccount(ctx, sqlcgen.CloseAccountParams{
		ClosedBy: acc.ClosedBy, ClosedAt: timestamptz(acc.ClosedAt),
		UpdatedAt: timestamptz(acc.UpdatedAt), Version: acc.Version,
		TenantID: tenantID, AccountID: id, ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if affected == 0 {
		return conflict()
	}
	return nil
}
