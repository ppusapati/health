package postgres

import (
	"context"
	"time"

	"github.com/google/uuid"

	"github.com/ppusapati/health/code/internal/materials/domain"
	"github.com/ppusapati/health/code/internal/materials/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// LedgerRepo implements ports.LedgerRepository (SRS-MAT-007).
//
// Append and read. There is deliberately no update and no delete on this type:
// a movement is a statement about something that happened, and a ledger whose
// past can be rewritten cannot support a recall, a variance investigation or
// an audit. A mistake is corrected by a compensating movement.
type LedgerRepo struct{ *Repository }

var _ ports.LedgerRepository = LedgerRepo{}

// AppendMovement writes one movement.
func (r LedgerRepo) AppendMovement(ctx context.Context,
	scope authctx.TenantScope, m domain.Movement) error {

	return r.AppendMovements(ctx, scope, []domain.Movement{m})
}

// AppendMovements writes several in one call.
//
// A transfer, a six-line receipt and a count's adjustments are each one event.
// Splitting them across calls would let half of one land, and a ledger holding
// the out-half of a transfer without its in-half has lost the stock.
func (r LedgerRepo) AppendMovements(ctx context.Context,
	scope authctx.TenantScope, movements []domain.Movement) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}

	queries := r.queries(ctx)
	for _, m := range movements {
		movementID, err := uuid.Parse(m.ID)
		if err != nil {
			return notFound()
		}
		itemID, err := uuid.Parse(m.ItemID)
		if err != nil {
			return notFound()
		}
		lotID, err := uuid.Parse(m.LotID)
		if err != nil {
			return notFound()
		}

		if err := queries.InsertMovement(ctx, sqlcgen.InsertMovementParams{
			MovementID: movementID, TenantID: tenantID,
			ItemID: itemID, LotID: lotID,
			FromLocation: m.From.LocationID, FromStatus: string(m.From.Status),
			ToLocation: m.To.LocationID, ToStatus: string(m.To.Status),
			Quantity: int32(m.Quantity), Kind: string(m.Kind),
			Reference: m.Reference, Reason: m.Reason,
			CostCentre:  m.CostCentre,
			PatientID:   optionalUUID(m.PatientID),
			EncounterID: optionalUUID(m.EncounterID),
			OccurredAt:  stamp(m.OccurredAt), RecordedBy: m.RecordedBy,
		}); err != nil {
			return err
		}
	}
	return nil
}

// MovementsForItem reads an item's ledger over a period.
func (r LedgerRepo) MovementsForItem(ctx context.Context,
	scope authctx.TenantScope, itemID string, from, to time.Time,
	limit int32) ([]domain.Movement, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	item, err := uuid.Parse(itemID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListMovementsForItem(ctx,
		sqlcgen.ListMovementsForItemParams{
			TenantID: tenantID, ItemID: item,
			PeriodStart: stamp(from), PeriodEnd: stamp(to), RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return movementsFrom(rows), nil
}

// MovementsForLot reads one lot's whole history, which is what a recall runs
// along.
func (r LedgerRepo) MovementsForLot(ctx context.Context,
	scope authctx.TenantScope, lotID string, limit int32) (
	[]domain.Movement, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	lot, err := uuid.Parse(lotID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListMovementsForLot(ctx,
		sqlcgen.ListMovementsForLotParams{
			TenantID: tenantID, LotID: lot, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return movementsFrom(rows), nil
}

// MovementsByReference reads everything one document posted.
func (r LedgerRepo) MovementsByReference(ctx context.Context,
	scope authctx.TenantScope, reference string, limit int32) (
	[]domain.Movement, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListMovementsByReference(ctx,
		sqlcgen.ListMovementsByReferenceParams{
			TenantID: tenantID, Reference: reference, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return movementsFrom(rows), nil
}

func movementsFrom(rows []sqlcgen.MaterialsMovement) []domain.Movement {
	out := make([]domain.Movement, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Movement{
			ID: row.MovementID.String(), TenantID: row.TenantID.String(),
			ItemID: row.ItemID.String(), LotID: row.LotID.String(),
			From: domain.Bucket{
				LocationID: row.FromLocation,
				Status:     domain.StockStatus(row.FromStatus),
			},
			To: domain.Bucket{
				LocationID: row.ToLocation,
				Status:     domain.StockStatus(row.ToStatus),
			},
			Quantity: int(row.Quantity), Kind: domain.MovementKind(row.Kind),
			Reference: row.Reference, Reason: row.Reason,
			CostCentre:  row.CostCentre,
			PatientID:   uuidString(row.PatientID),
			EncounterID: uuidString(row.EncounterID),
			OccurredAt:  timeOf(row.OccurredAt), RecordedBy: row.RecordedBy,
		})
	}
	return out
}

// BalancesAtLocation reads what one store holds.
//
// From materials.balance, the view that sums the ledger. There is no on-hand
// column to read instead.
func (r LedgerRepo) BalancesAtLocation(ctx context.Context,
	scope authctx.TenantScope, locationID, itemID string, limit int32) (
	[]domain.Balance, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListBalancesAtLocation(ctx,
		sqlcgen.ListBalancesAtLocationParams{
			TenantID: tenantID, LocationID: locationID,
			ItemID: itemID, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return balancesFrom(rows), nil
}

// BalancesForItem reads one item across every store.
func (r LedgerRepo) BalancesForItem(ctx context.Context,
	scope authctx.TenantScope, itemID string, limit int32) (
	[]domain.Balance, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	item, err := uuid.Parse(itemID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListBalancesForItem(ctx,
		sqlcgen.ListBalancesForItemParams{
			TenantID: tenantID, ItemID: item, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return balancesForItemFrom(rows), nil
}

// BalancesForLot reads where one lot is, which is what a recall fetches back.
func (r LedgerRepo) BalancesForLot(ctx context.Context,
	scope authctx.TenantScope, lotID string) ([]domain.Balance, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	lot, err := uuid.Parse(lotID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListBalancesForLot(ctx,
		sqlcgen.ListBalancesForLotParams{TenantID: tenantID, LotID: lot})
	if err != nil {
		return nil, err
	}
	return balancesForLotFrom(rows), nil
}

func balancesFrom(rows []sqlcgen.MaterialsBalance) []domain.Balance {
	out := make([]domain.Balance, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Balance{
			ItemID: row.ItemID.String(), LotID: row.LotID.String(),
			Bucket: domain.Bucket{
				LocationID: row.LocationID,
				Status:     domain.StockStatus(row.Status),
			},
			Quantity: int(row.Quantity),
		})
	}
	return out
}

func balancesForItemFrom(rows []sqlcgen.MaterialsBalance) []domain.Balance {
	return balancesFrom(rows)
}

func balancesForLotFrom(rows []sqlcgen.MaterialsBalance) []domain.Balance {
	return balancesFrom(rows)
}

// Available is available-to-promise, computed in SQL.
//
// The same arithmetic as domain.Available and deliberately so: a pick screen
// asking "can this store supply forty" should not pull every movement across
// the wire. The two are held together by a repository test that computes it
// both ways over the same ledger — if they ever disagree, one of them is
// offering blocked or expired stock.
func (r LedgerRepo) Available(ctx context.Context, scope authctx.TenantScope,
	itemID, locationID string, asOf time.Time) (int, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return 0, err
	}
	item, err := uuid.Parse(itemID)
	if err != nil {
		return 0, notFound()
	}

	total, err := r.queries(ctx).SumAvailable(ctx, sqlcgen.SumAvailableParams{
		TenantID: tenantID, ItemID: item, LocationID: locationID,
		AsOf: stamp(asOf),
	})
	if err != nil {
		return 0, err
	}
	return int(total), nil
}
