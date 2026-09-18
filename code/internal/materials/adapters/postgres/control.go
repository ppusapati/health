package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/materials/domain"
	"github.com/ppusapati/health/code/internal/materials/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// ControlRepo implements ports.ControlRepository.
type ControlRepo struct{ *Repository }

var _ ports.ControlRepository = ControlRepo{}

// InsertTransfer dispatches stock to another store.
func (r ControlRepo) InsertTransfer(ctx context.Context,
	scope authctx.TenantScope, t domain.Transfer) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	transferID, err := uuid.Parse(t.ID)
	if err != nil {
		return notFound()
	}
	lines, err := encode(t.Lines)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertTransfer(ctx, sqlcgen.InsertTransferParams{
		TransferID: transferID, TenantID: tenantID, Number: t.Number,
		FromLocation: t.FromLocation, ToLocation: t.ToLocation,
		Lines: lines, State: string(t.State), Reason: t.Reason,
		DispatchedAt: stamp(t.DispatchedAt), DispatchedBy: t.DispatchedBy,
	})
}

// Transfer reads one transfer.
func (r ControlRepo) Transfer(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Transfer, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Transfer{}, err
	}
	transferID, err := uuid.Parse(id)
	if err != nil {
		return domain.Transfer{}, notFound()
	}

	row, err := r.queries(ctx).GetTransfer(ctx, sqlcgen.GetTransferParams{
		TenantID: tenantID, TransferID: transferID,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Transfer{}, notFound()
	}
	if err != nil {
		return domain.Transfer{}, err
	}
	return transferFrom(row)
}

// UpdateTransfer closes a transfer at the destination.
func (r ControlRepo) UpdateTransfer(ctx context.Context,
	scope authctx.TenantScope, t domain.Transfer, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	transferID, err := uuid.Parse(t.ID)
	if err != nil {
		return notFound()
	}
	lines, err := encode(t.Lines)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).UpdateTransfer(ctx, sqlcgen.UpdateTransferParams{
		TenantID: tenantID, TransferID: transferID,
		Lines: lines, State: string(t.State),
		ReceivedAt: stamp(t.ReceivedAt), ReceivedBy: t.ReceivedBy,
		ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// TransfersInTransit is what is still on a trolley somewhere.
func (r ControlRepo) TransfersInTransit(ctx context.Context,
	scope authctx.TenantScope, toLocation string, limit int32) (
	[]domain.Transfer, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListTransfersInTransit(ctx,
		sqlcgen.ListTransfersInTransitParams{
			TenantID: tenantID, ToLocation: toLocation, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Transfer, 0, len(rows))
	for _, row := range rows {
		transfer, err := transferFrom(row)
		if err != nil {
			return nil, err
		}
		out = append(out, transfer)
	}
	return out, nil
}

func transferFrom(row sqlcgen.MaterialsTransfer) (domain.Transfer, error) {
	out := domain.Transfer{
		ID: row.TransferID.String(), TenantID: row.TenantID.String(),
		Number: row.Number, FromLocation: row.FromLocation,
		ToLocation: row.ToLocation, State: domain.TransferState(row.State),
		Reason:       row.Reason,
		DispatchedAt: timeOf(row.DispatchedAt), DispatchedBy: row.DispatchedBy,
		ReceivedAt: timeOf(row.ReceivedAt), ReceivedBy: row.ReceivedBy,
		Version: row.Version,
	}
	if err := decode(row.Lines, &out.Lines); err != nil {
		return domain.Transfer{}, err
	}
	return out, nil
}

// InsertCount opens a stocktake.
func (r ControlRepo) InsertCount(ctx context.Context,
	scope authctx.TenantScope, c domain.Count) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	countID, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}
	lines, err := encode(c.Lines)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertStockCount(ctx, sqlcgen.InsertStockCountParams{
		CountID: countID, TenantID: tenantID, Number: c.Number,
		LocationID: c.LocationID, Cycle: c.Cycle,
		Lines: lines, State: string(c.State),
		OpenedAt: stamp(c.OpenedAt), OpenedBy: c.OpenedBy,
	})
}

// Count reads one stocktake.
func (r ControlRepo) Count(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Count, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Count{}, err
	}
	countID, err := uuid.Parse(id)
	if err != nil {
		return domain.Count{}, notFound()
	}

	row, err := r.queries(ctx).GetStockCount(ctx, sqlcgen.GetStockCountParams{
		TenantID: tenantID, CountID: countID,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Count{}, notFound()
	}
	if err != nil {
		return domain.Count{}, err
	}
	return countFrom(row)
}

// UpdateCount records or approves a stocktake.
func (r ControlRepo) UpdateCount(ctx context.Context,
	scope authctx.TenantScope, c domain.Count, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	countID, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}
	lines, err := encode(c.Lines)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).UpdateStockCount(ctx,
		sqlcgen.UpdateStockCountParams{
			TenantID: tenantID, CountID: countID,
			Lines: lines, State: string(c.State),
			ApprovedBy: c.ApprovedBy, ApprovedAt: stamp(c.ApprovedAt),
			ApprovalNote: c.ApprovalNote,
			CountedAt:    stamp(c.CountedAt), CountedBy: c.CountedBy,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// Counts lists stocktakes, most recent first.
func (r ControlRepo) Counts(ctx context.Context, scope authctx.TenantScope,
	state string, limit int32) ([]domain.Count, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListStockCounts(ctx,
		sqlcgen.ListStockCountsParams{
			TenantID: tenantID, State: state, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Count, 0, len(rows))
	for _, row := range rows {
		count, err := countFrom(row)
		if err != nil {
			return nil, err
		}
		out = append(out, count)
	}
	return out, nil
}

func countFrom(row sqlcgen.MaterialsStockCount) (domain.Count, error) {
	out := domain.Count{
		ID: row.CountID.String(), TenantID: row.TenantID.String(),
		Number: row.Number, LocationID: row.LocationID, Cycle: row.Cycle,
		State:      domain.CountState(row.State),
		ApprovedBy: row.ApprovedBy, ApprovedAt: timeOf(row.ApprovedAt),
		ApprovalNote: row.ApprovalNote,
		OpenedAt:     timeOf(row.OpenedAt), OpenedBy: row.OpenedBy,
		CountedAt: timeOf(row.CountedAt), CountedBy: row.CountedBy,
		Version: row.Version,
	}
	if err := decode(row.Lines, &out.Lines); err != nil {
		return domain.Count{}, err
	}
	return out, nil
}

// AppendLiability records what consuming a supplier's stock owes them
// (SRS-MAT-016).
//
// Insert only, and the schema's unique (tenant, movement) means a retry cannot
// bill a supplier twice for one implant.
func (r ControlRepo) AppendLiability(ctx context.Context,
	scope authctx.TenantScope, e domain.LiabilityEvent) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	eventID, err := uuid.Parse(e.ID)
	if err != nil {
		return notFound()
	}
	lotID, err := uuid.Parse(e.LotID)
	if err != nil {
		return notFound()
	}
	itemID, err := uuid.Parse(e.ItemID)
	if err != nil {
		return notFound()
	}
	supplierID, err := uuid.Parse(e.SupplierID)
	if err != nil {
		return notFound()
	}
	movementID, err := uuid.Parse(e.MovementID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertLiabilityEvent(ctx,
		sqlcgen.InsertLiabilityEventParams{
			LiabilityEventID: eventID, TenantID: tenantID,
			LotID: lotID, ItemID: itemID, SupplierID: supplierID,
			Quantity:    int32(e.Quantity),
			PatientID:   optionalUUID(e.PatientID),
			EncounterID: optionalUUID(e.EncounterID),
			MovementID:  movementID,
			OccurredAt:  stamp(e.OccurredAt), RecordedBy: e.RecordedBy,
		})
}

// Liabilities reads what is owed to one supplier over a period.
func (r ControlRepo) Liabilities(ctx context.Context,
	scope authctx.TenantScope, supplierID string, from, to time.Time,
	limit int32) ([]domain.LiabilityEvent, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	supplier, err := uuid.Parse(supplierID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListLiabilityEvents(ctx,
		sqlcgen.ListLiabilityEventsParams{
			TenantID: tenantID, SupplierID: supplier,
			PeriodStart: stamp(from), PeriodEnd: stamp(to), RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.LiabilityEvent, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.LiabilityEvent{
			ID: row.LiabilityEventID.String(), TenantID: row.TenantID.String(),
			LotID: row.LotID.String(), ItemID: row.ItemID.String(),
			SupplierID: row.SupplierID.String(), Quantity: int(row.Quantity),
			PatientID:   uuidString(row.PatientID),
			EncounterID: uuidString(row.EncounterID),
			MovementID:  row.MovementID.String(),
			OccurredAt:  timeOf(row.OccurredAt), RecordedBy: row.RecordedBy,
		})
	}
	return out, nil
}
