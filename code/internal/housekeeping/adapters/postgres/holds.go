package postgres

import (
	"context"

	"github.com/google/uuid"

	"github.com/ppusapati/health/code/internal/housekeeping/domain"
	"github.com/ppusapati/health/code/internal/housekeeping/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Bed cleaning holds (SRS-HKP-003).
//
// There is no delete and no way to set a hold back to open. A hold that could
// be reopened is a bed whose history says it was cleaned twice, and the
// turnaround report is derived from exactly those timestamps.

var _ ports.HoldRepository = (*Repository)(nil)

// InsertHold implements ports.HoldRepository.
func (r *Repository) InsertHold(ctx context.Context,
	scope authctx.TenantScope, h domain.BedHold) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(h.ID)
	if err != nil {
		return notFound()
	}
	taskID, err := uuid.Parse(h.TaskID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertBedHold(ctx, sqlcgen.InsertBedHoldParams{
		HoldID: id, TenantID: tenantID, BedID: h.BedID,
		LocationCode: h.LocationCode, FacilityID: h.FacilityID,
		Zone: h.Zone, TaskID: taskID, EncounterID: h.EncounterID,
		State:    string(h.State),
		PlacedAt: stamp(h.PlacedAt), PlacedBy: h.PlacedBy,
		ReleasedAt: stamp(h.ReleasedAt), ReleasedBy: h.ReleasedBy,
		OverriddenAt: stamp(h.OverriddenAt), OverriddenBy: h.OverriddenBy,
		OverrideReason: h.OverrideReason, Version: h.Version,
	})
}

// Hold implements ports.HoldRepository.
func (r *Repository) Hold(ctx context.Context, scope authctx.TenantScope,
	holdID string) (domain.BedHold, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.BedHold{}, err
	}
	id, err := uuid.Parse(holdID)
	if err != nil {
		return domain.BedHold{}, notFound()
	}

	row, err := r.queries(ctx).GetBedHold(ctx, sqlcgen.GetBedHoldParams{
		TenantID: tenantID, HoldID: id,
	})
	if isNoRows(err) {
		return domain.BedHold{}, notFound()
	}
	if err != nil {
		return domain.BedHold{}, err
	}
	return holdFrom(row), nil
}

// UpdateHold implements ports.HoldRepository.
func (r *Repository) UpdateHold(ctx context.Context,
	scope authctx.TenantScope, h domain.BedHold,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(h.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateBedHold(ctx, sqlcgen.UpdateBedHoldParams{
		State:      string(h.State),
		ReleasedAt: stamp(h.ReleasedAt), ReleasedBy: h.ReleasedBy,
		OverriddenAt: stamp(h.OverriddenAt), OverriddenBy: h.OverriddenBy,
		OverrideReason: h.OverrideReason,
		TenantID:       tenantID, HoldID: id,
		ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// OpenHoldForBed implements ports.HoldRepository.
func (r *Repository) OpenHoldForBed(ctx context.Context,
	scope authctx.TenantScope, bedID string) (domain.BedHold, bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.BedHold{}, false, err
	}
	row, err := r.queries(ctx).GetOpenBedHold(ctx,
		sqlcgen.GetOpenBedHoldParams{TenantID: tenantID, BedID: bedID})
	if isNoRows(err) {
		return domain.BedHold{}, false, nil
	}
	if err != nil {
		return domain.BedHold{}, false, err
	}
	return holdFrom(row), true, nil
}

// HoldForTask implements ports.HoldRepository.
func (r *Repository) HoldForTask(ctx context.Context,
	scope authctx.TenantScope, taskID string) (domain.BedHold, bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.BedHold{}, false, err
	}
	id, err := uuid.Parse(taskID)
	if err != nil {
		return domain.BedHold{}, false, notFound()
	}

	row, err := r.queries(ctx).GetBedHoldForTask(ctx,
		sqlcgen.GetBedHoldForTaskParams{TenantID: tenantID, TaskID: id})
	if isNoRows(err) {
		return domain.BedHold{}, false, nil
	}
	if err != nil {
		return domain.BedHold{}, false, err
	}
	return holdFrom(row), true, nil
}

// Holds implements ports.HoldRepository.
func (r *Repository) Holds(ctx context.Context, scope authctx.TenantScope,
	f ports.HoldFilter) ([]domain.BedHold, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	limit, offset := page(f.Limit, f.Offset)
	from, to := window(f.From, f.To)

	rows, err := r.queries(ctx).ListBedHolds(ctx, sqlcgen.ListBedHoldsParams{
		TenantID: tenantID, FacilityID: f.FacilityID, Zone: f.Zone,
		BedID: f.BedID, OpenOnly: f.OpenOnly,
		FromTime: stamp(from), ToTime: stamp(to),
		PageLimit: limit, PageOffset: offset,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.BedHold, 0, len(rows))
	for _, row := range rows {
		out = append(out, holdFrom(row))
	}
	return out, nil
}

func holdFrom(row sqlcgen.HousekeepingBedHold) domain.BedHold {
	return domain.BedHold{
		ID: row.HoldID.String(), TenantID: row.TenantID.String(),
		BedID: row.BedID, LocationCode: row.LocationCode,
		FacilityID: row.FacilityID, Zone: row.Zone,
		TaskID: row.TaskID.String(), EncounterID: row.EncounterID,
		State:    domain.HoldState(row.State),
		PlacedAt: timeOf(row.PlacedAt), PlacedBy: row.PlacedBy,
		ReleasedAt: timeOf(row.ReleasedAt), ReleasedBy: row.ReleasedBy,
		OverriddenAt:   timeOf(row.OverriddenAt),
		OverriddenBy:   row.OverriddenBy,
		OverrideReason: row.OverrideReason,
		Version:        row.Version,
	}
}
