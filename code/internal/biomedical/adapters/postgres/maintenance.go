package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/biomedical/domain"
	"github.com/ppusapati/health/code/internal/biomedical/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// ContractRepo implements ports.ContractRepository.
type ContractRepo struct{ *Repository }

var _ ports.ContractRepository = ContractRepo{}

// InsertContract records a warranty, AMC or CMC.
func (r ContractRepo) InsertContract(ctx context.Context,
	scope authctx.TenantScope, c domain.ServiceContract) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	contractID, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}
	assetID, err := uuid.Parse(c.AssetID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertServiceContract(ctx,
		sqlcgen.InsertServiceContractParams{
			ContractID: contractID, TenantID: tenantID, AssetID: assetID,
			Kind: string(c.Kind), Reference: c.Reference,
			VendorName: c.VendorName, VendorContact: c.VendorContact,
			VendorPhone: c.VendorPhone, VendorEmail: c.VendorEmail,
			StartsOn: stamp(c.StartsOn), EndsOn: stamp(c.EndsOn),
			ValueMinor:      c.ValueMinor,
			ResponseHours:   int32(c.ResponseHours),
			ResolutionHours: int32(c.ResolutionHours),
			Notes:           c.Notes,
			CreatedAt:       stamp(c.CreatedAt), CreatedBy: c.CreatedBy,
		})
}

// Contract reads one agreement.
func (r ContractRepo) Contract(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.ServiceContract, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.ServiceContract{}, err
	}
	contractID, err := uuid.Parse(id)
	if err != nil {
		return domain.ServiceContract{}, notFound()
	}

	row, err := r.queries(ctx).GetServiceContract(ctx,
		sqlcgen.GetServiceContractParams{
			TenantID: tenantID, ContractID: contractID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.ServiceContract{}, notFound()
	}
	if err != nil {
		return domain.ServiceContract{}, err
	}
	return contractFrom(row), nil
}

// ContractsForAsset reads every agreement on one machine.
func (r ContractRepo) ContractsForAsset(ctx context.Context,
	scope authctx.TenantScope, assetID string) (
	[]domain.ServiceContract, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(assetID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListContractsForAsset(ctx,
		sqlcgen.ListContractsForAssetParams{TenantID: tenantID, AssetID: id})
	if err != nil {
		return nil, err
	}
	return contractsFrom(rows), nil
}

// ExpiringBefore is the renewal sweep.
func (r ContractRepo) ExpiringBefore(ctx context.Context,
	scope authctx.TenantScope, horizon time.Time, limit int32) (
	[]domain.ServiceContract, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListContractsExpiringBefore(ctx,
		sqlcgen.ListContractsExpiringBeforeParams{
			TenantID: tenantID, Horizon: stamp(horizon), RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return contractsFrom(rows), nil
}

func contractsFrom(
	rows []sqlcgen.BiomedicalServiceContract) []domain.ServiceContract {

	out := make([]domain.ServiceContract, 0, len(rows))
	for _, row := range rows {
		out = append(out, contractFrom(row))
	}
	return out
}

func contractFrom(
	row sqlcgen.BiomedicalServiceContract) domain.ServiceContract {

	return domain.ServiceContract{
		ID: row.ContractID.String(), TenantID: row.TenantID.String(),
		AssetID: row.AssetID.String(), Kind: domain.ContractKind(row.Kind),
		Reference: row.Reference, VendorName: row.VendorName,
		VendorContact: row.VendorContact, VendorPhone: row.VendorPhone,
		VendorEmail: row.VendorEmail,
		StartsOn:    timeOf(row.StartsOn), EndsOn: timeOf(row.EndsOn),
		ValueMinor:      row.ValueMinor,
		ResponseHours:   int(row.ResponseHours),
		ResolutionHours: int(row.ResolutionHours),
		Notes:           row.Notes,
		CreatedAt:       timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
}

// PlanRepo implements ports.PlanRepository.
type PlanRepo struct{ *Repository }

var _ ports.PlanRepository = PlanRepo{}

// InsertPlan schedules preventive maintenance.
func (r PlanRepo) InsertPlan(ctx context.Context, scope authctx.TenantScope,
	p domain.PMPlan) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	planID, err := uuid.Parse(p.ID)
	if err != nil {
		return notFound()
	}
	assetID, err := uuid.Parse(p.AssetID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertPMPlan(ctx, sqlcgen.InsertPMPlanParams{
		PlanID: planID, TenantID: tenantID, AssetID: assetID,
		Basis: string(p.Basis), IntervalDays: int32(p.IntervalDays),
		RuntimeHours: int32(p.RuntimeHours), Procedure: p.Procedure,
		EstimatedMinutes: int32(p.EstimatedMinutes),
		LastPerformedAt:  stamp(p.LastPerformedAt),
		LastRuntimeHours: int32(p.LastRuntimeHours),
		Active:           p.Active,
		CreatedAt:        stamp(p.CreatedAt), CreatedBy: p.CreatedBy,
	})
}

// Plan reads one schedule.
func (r PlanRepo) Plan(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.PMPlan, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.PMPlan{}, err
	}
	planID, err := uuid.Parse(id)
	if err != nil {
		return domain.PMPlan{}, notFound()
	}

	row, err := r.queries(ctx).GetPMPlan(ctx, sqlcgen.GetPMPlanParams{
		TenantID: tenantID, PlanID: planID,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.PMPlan{}, notFound()
	}
	if err != nil {
		return domain.PMPlan{}, err
	}
	return planFrom(row), nil
}

// UpdatePlan records a completed service or a changed schedule.
func (r PlanRepo) UpdatePlan(ctx context.Context, scope authctx.TenantScope,
	p domain.PMPlan, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	planID, err := uuid.Parse(p.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdatePMPlan(ctx, sqlcgen.UpdatePMPlanParams{
		TenantID: tenantID, PlanID: planID,
		IntervalDays: int32(p.IntervalDays), RuntimeHours: int32(p.RuntimeHours),
		Procedure: p.Procedure, EstimatedMinutes: int32(p.EstimatedMinutes),
		LastPerformedAt:  stamp(p.LastPerformedAt),
		LastRuntimeHours: int32(p.LastRuntimeHours),
		Active:           p.Active, ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// Plans lists the schedules.
func (r PlanRepo) Plans(ctx context.Context, scope authctx.TenantScope,
	assetID string, activeOnly bool, limit int32) ([]domain.PMPlan, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListPMPlans(ctx, sqlcgen.ListPMPlansParams{
		TenantID: tenantID, AssetID: assetID, ActiveOnly: activeOnly,
		RowLimit: limit,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.PMPlan, 0, len(rows))
	for _, row := range rows {
		out = append(out, planFrom(row))
	}
	return out, nil
}

func planFrom(row sqlcgen.BiomedicalPmPlan) domain.PMPlan {
	return domain.PMPlan{
		ID: row.PlanID.String(), TenantID: row.TenantID.String(),
		AssetID: row.AssetID.String(), Basis: domain.PlanBasis(row.Basis),
		IntervalDays:     int(row.IntervalDays),
		RuntimeHours:     int(row.RuntimeHours),
		Procedure:        row.Procedure,
		EstimatedMinutes: int(row.EstimatedMinutes),
		LastPerformedAt:  timeOf(row.LastPerformedAt),
		LastRuntimeHours: int(row.LastRuntimeHours),
		Active:           row.Active,
		CreatedAt:        timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
}
