// Package postgres is the materials persistence adapter.
//
// It is the only package permitted to issue SQL against the materials schema
// (FIT-02). Every method takes an authctx.TenantScope, so the tenant predicate
// is always present and always comes from verified credentials (FIT-03).
//
// The ledger half of this adapter has no update and no delete, and there is no
// on-hand column to maintain: balances are read from materials.balance, the
// view that sums the movements. That is what makes SRS-MAT-007's "on-hand is
// derivable from immutable movements" a property of the schema rather than a
// convention somebody could break with one UPDATE.
package postgres

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"

	"github.com/ppusapati/health/code/internal/materials/domain"
	"github.com/ppusapati/health/code/internal/materials/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Repository implements the materials repository ports.
type Repository struct {
	tx *pgtx.Manager
}

// New constructs a Repository.
func New(tx *pgtx.Manager) *Repository { return &Repository{tx: tx} }

func (r *Repository) queries(ctx context.Context) *sqlcgen.Queries {
	return sqlcgen.New(r.tx.Querier(ctx))
}

func scopeTenantID(scope authctx.TenantScope) (uuid.UUID, error) {
	if scope.IsZero() {
		return uuid.UUID{}, rpcerr.Internal("MAT_NO_TENANT_SCOPE",
			"a repository call needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("MAT_TENANT_ID_INVALID",
			"tenant_id must be a UUID").WithCause(err)
	}
	return parsed, nil
}

// notFound conceals a malformed identifier as an absent one, so a probe cannot
// confirm that an id exists in another tenant by the shape of the refusal.
func notFound() error {
	return rpcerr.NotFound("MAT_NOT_FOUND", "no such materials record")
}

func stamp(t time.Time) pgtype.Timestamptz {
	if t.IsZero() {
		return pgtype.Timestamptz{}
	}
	return pgtype.Timestamptz{Time: t.UTC(), Valid: true}
}

func timeOf(t pgtype.Timestamptz) time.Time {
	if !t.Valid {
		return time.Time{}
	}
	return t.Time.UTC()
}

// optionalUUID renders an empty identifier as NULL rather than as the zero
// UUID, which would look like a real row nobody can find.
func optionalUUID(id string) pgtype.UUID {
	if id == "" {
		return pgtype.UUID{}
	}
	parsed, err := uuid.Parse(id)
	if err != nil {
		return pgtype.UUID{}
	}
	return pgtype.UUID{Bytes: parsed, Valid: true}
}

func uuidString(id pgtype.UUID) string {
	if !id.Valid {
		return ""
	}
	return uuid.UUID(id.Bytes).String()
}

func encode(value any) ([]byte, error) {
	raw, err := json.Marshal(value)
	if err != nil {
		return nil, rpcerr.Internal("MAT_ENCODE_FAILED",
			"could not encode a materials record").WithCause(err)
	}
	return raw, nil
}

func decode[T any](raw []byte, out *T) error {
	if len(raw) == 0 {
		return nil
	}
	if err := json.Unmarshal(raw, out); err != nil {
		return rpcerr.Internal("MAT_DECODE_FAILED",
			"could not decode a materials record").WithCause(err)
	}
	return nil
}

// MasterRepo implements ports.MasterRepository.
type MasterRepo struct{ *Repository }

var _ ports.MasterRepository = MasterRepo{}

// InsertItem adds an item to the master.
func (r MasterRepo) InsertItem(ctx context.Context, scope authctx.TenantScope,
	i domain.Item) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	itemID, err := uuid.Parse(i.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertMaterialsItem(ctx,
		sqlcgen.InsertMaterialsItemParams{
			ItemID: itemID, TenantID: tenantID,
			Code: i.Code, Display: i.Display, Category: i.Category,
			Uom: i.UOM, Tracking: string(i.Tracking), Policy: string(i.Policy),
			Perishable: i.Perishable, InspectOnReceipt: i.InspectOnReceipt,
			Consignable: i.Consignable, Active: i.Active,
			CreatedAt: stamp(i.CreatedAt), CreatedBy: i.CreatedBy,
		})
}

// Item reads one item.
func (r MasterRepo) Item(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Item, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Item{}, err
	}
	itemID, err := uuid.Parse(id)
	if err != nil {
		return domain.Item{}, notFound()
	}

	row, err := r.queries(ctx).GetMaterialsItem(ctx,
		sqlcgen.GetMaterialsItemParams{TenantID: tenantID, ItemID: itemID})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Item{}, notFound()
	}
	if err != nil {
		return domain.Item{}, err
	}
	return itemFrom(row), nil
}

// ItemByCode resolves the catalogue code.
func (r MasterRepo) ItemByCode(ctx context.Context, scope authctx.TenantScope,
	code string) (domain.Item, bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Item{}, false, err
	}

	row, err := r.queries(ctx).GetMaterialsItemByCode(ctx,
		sqlcgen.GetMaterialsItemByCodeParams{TenantID: tenantID, Code: code})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Item{}, false, nil
	}
	if err != nil {
		return domain.Item{}, false, err
	}
	return itemFrom(row), true, nil
}

// UpdateItem changes an item's configuration.
func (r MasterRepo) UpdateItem(ctx context.Context, scope authctx.TenantScope,
	i domain.Item, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	itemID, err := uuid.Parse(i.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateMaterialsItem(ctx,
		sqlcgen.UpdateMaterialsItemParams{
			TenantID: tenantID, ItemID: itemID,
			Display: i.Display, Category: i.Category, Policy: string(i.Policy),
			InspectOnReceipt: i.InspectOnReceipt, Consignable: i.Consignable,
			Active: i.Active, ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// Items lists the master.
func (r MasterRepo) Items(ctx context.Context, scope authctx.TenantScope,
	category string, activeOnly bool, limit int32) ([]domain.Item, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListMaterialsItems(ctx,
		sqlcgen.ListMaterialsItemsParams{
			TenantID: tenantID, Category: category,
			ActiveOnly: activeOnly, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Item, 0, len(rows))
	for _, row := range rows {
		out = append(out, itemFrom(row))
	}
	return out, nil
}

func itemFrom(row sqlcgen.MaterialsItem) domain.Item {
	return domain.Item{
		ID: row.ItemID.String(), TenantID: row.TenantID.String(),
		Code: row.Code, Display: row.Display, Category: row.Category,
		UOM:        row.Uom,
		Tracking:   domain.Tracking(row.Tracking),
		Policy:     domain.PickPolicy(row.Policy),
		Perishable: row.Perishable, InspectOnReceipt: row.InspectOnReceipt,
		Consignable: row.Consignable, Active: row.Active,
		CreatedAt: timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
}

// InsertSupplier registers a supplier.
func (r MasterRepo) InsertSupplier(ctx context.Context,
	scope authctx.TenantScope, s domain.Supplier) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	supplierID, err := uuid.Parse(s.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertSupplier(ctx, sqlcgen.InsertSupplierParams{
		SupplierID: supplierID, TenantID: tenantID,
		Code: s.Code, Display: s.Display, Approved: s.Approved,
		ContactEmail: s.ContactEmail, ContactPhone: s.ContactPhone,
		PaymentTermsDays: int32(s.PaymentTermsDays), Currency: s.Currency,
		CreatedAt: stamp(s.CreatedAt), CreatedBy: s.CreatedBy,
	})
}

// Supplier reads one supplier.
func (r MasterRepo) Supplier(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Supplier, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Supplier{}, err
	}
	supplierID, err := uuid.Parse(id)
	if err != nil {
		return domain.Supplier{}, notFound()
	}

	row, err := r.queries(ctx).GetSupplier(ctx, sqlcgen.GetSupplierParams{
		TenantID: tenantID, SupplierID: supplierID,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Supplier{}, notFound()
	}
	if err != nil {
		return domain.Supplier{}, err
	}
	return supplierFrom(row), nil
}

// UpdateSupplier changes a supplier's terms or approval.
func (r MasterRepo) UpdateSupplier(ctx context.Context,
	scope authctx.TenantScope, s domain.Supplier, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	supplierID, err := uuid.Parse(s.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateSupplier(ctx, sqlcgen.UpdateSupplierParams{
		TenantID: tenantID, SupplierID: supplierID,
		Display: s.Display, Approved: s.Approved,
		ContactEmail: s.ContactEmail, ContactPhone: s.ContactPhone,
		PaymentTermsDays: int32(s.PaymentTermsDays), Currency: s.Currency,
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

// Suppliers lists who the hospital buys from.
func (r MasterRepo) Suppliers(ctx context.Context, scope authctx.TenantScope,
	approvedOnly bool, limit int32) ([]domain.Supplier, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListSuppliers(ctx, sqlcgen.ListSuppliersParams{
		TenantID: tenantID, ApprovedOnly: approvedOnly, RowLimit: limit,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Supplier, 0, len(rows))
	for _, row := range rows {
		out = append(out, supplierFrom(row))
	}
	return out, nil
}

func supplierFrom(row sqlcgen.MaterialsSupplier) domain.Supplier {
	return domain.Supplier{
		ID: row.SupplierID.String(), TenantID: row.TenantID.String(),
		Code: row.Code, Display: row.Display, Approved: row.Approved,
		ContactEmail: row.ContactEmail, ContactPhone: row.ContactPhone,
		PaymentTermsDays: int(row.PaymentTermsDays), Currency: row.Currency,
		CreatedAt: timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
}

// InsertLot identifies a received quantity.
func (r MasterRepo) InsertLot(ctx context.Context, scope authctx.TenantScope,
	l domain.Lot) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	lotID, err := uuid.Parse(l.ID)
	if err != nil {
		return notFound()
	}
	itemID, err := uuid.Parse(l.ItemID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertLot(ctx, sqlcgen.InsertLotParams{
		LotID: lotID, TenantID: tenantID, ItemID: itemID,
		Code: l.Code, Expiry: stamp(l.Expiry), ReceivedAt: stamp(l.ReceivedAt),
		Ownership: string(l.Ownership), SupplierID: optionalUUID(l.SupplierID),
		CreatedAt: stamp(l.CreatedAt),
	})
}

// Lot reads one lot.
func (r MasterRepo) Lot(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.Lot, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Lot{}, err
	}
	lotID, err := uuid.Parse(id)
	if err != nil {
		return domain.Lot{}, notFound()
	}

	row, err := r.queries(ctx).GetLot(ctx, sqlcgen.GetLotParams{
		TenantID: tenantID, LotID: lotID,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Lot{}, notFound()
	}
	if err != nil {
		return domain.Lot{}, err
	}
	return lotFrom(row), nil
}

// LotByCode finds an existing batch so a second delivery joins it.
func (r MasterRepo) LotByCode(ctx context.Context, scope authctx.TenantScope,
	itemID, code string) (domain.Lot, bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Lot{}, false, err
	}
	item, err := uuid.Parse(itemID)
	if err != nil {
		return domain.Lot{}, false, notFound()
	}

	row, err := r.queries(ctx).GetLotByCode(ctx, sqlcgen.GetLotByCodeParams{
		TenantID: tenantID, ItemID: item, Code: code,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Lot{}, false, nil
	}
	if err != nil {
		return domain.Lot{}, false, err
	}
	return lotFrom(row), true, nil
}

// UpdateLotBlock raises or lifts a block.
func (r MasterRepo) UpdateLotBlock(ctx context.Context,
	scope authctx.TenantScope, l domain.Lot, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	lotID, err := uuid.Parse(l.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateLotBlock(ctx, sqlcgen.UpdateLotBlockParams{
		TenantID: tenantID, LotID: lotID,
		Blocked: l.Blocked, BlockedReason: l.BlockedReason,
		BlockedAt: stamp(l.BlockedAt), BlockedBy: l.BlockedBy,
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

// LotsForItem lists an item's lots, oldest first.
func (r MasterRepo) LotsForItem(ctx context.Context, scope authctx.TenantScope,
	itemID string, limit int32) ([]domain.Lot, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	item, err := uuid.Parse(itemID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListLotsForItem(ctx,
		sqlcgen.ListLotsForItemParams{
			TenantID: tenantID, ItemID: item, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return lotsFrom(rows), nil
}

// LotsAtLocation is what a pick reads alongside the balances.
func (r MasterRepo) LotsAtLocation(ctx context.Context,
	scope authctx.TenantScope, itemID, locationID string, limit int32) (
	[]domain.Lot, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	item, err := uuid.Parse(itemID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListLotsAtLocation(ctx,
		sqlcgen.ListLotsAtLocationParams{
			TenantID: tenantID, ItemID: item, LocationID: locationID,
			RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return lotsFrom(rows), nil
}

// BlockedLots is the recall worklist.
func (r MasterRepo) BlockedLots(ctx context.Context, scope authctx.TenantScope,
	limit int32) ([]domain.Lot, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListBlockedLots(ctx,
		sqlcgen.ListBlockedLotsParams{TenantID: tenantID, RowLimit: limit})
	if err != nil {
		return nil, err
	}
	return lotsFrom(rows), nil
}

func lotsFrom(rows []sqlcgen.MaterialsLot) []domain.Lot {
	out := make([]domain.Lot, 0, len(rows))
	for _, row := range rows {
		out = append(out, lotFrom(row))
	}
	return out
}

func lotFrom(row sqlcgen.MaterialsLot) domain.Lot {
	return domain.Lot{
		ID: row.LotID.String(), TenantID: row.TenantID.String(),
		ItemID: row.ItemID.String(), Code: row.Code,
		Expiry: timeOf(row.Expiry), ReceivedAt: timeOf(row.ReceivedAt),
		Ownership:  domain.Ownership(row.Ownership),
		SupplierID: uuidString(row.SupplierID),
		Blocked:    row.Blocked, BlockedReason: row.BlockedReason,
		BlockedAt: timeOf(row.BlockedAt), BlockedBy: row.BlockedBy,
		CreatedAt: timeOf(row.CreatedAt), Version: row.Version,
	}
}

// UpsertStockLevel sets an item's min-max policy at a location.
func (r MasterRepo) UpsertStockLevel(ctx context.Context,
	scope authctx.TenantScope, level domain.StockLevel, by string,
	at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	itemID, err := uuid.Parse(level.ItemID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).UpsertStockLevel(ctx, sqlcgen.UpsertStockLevelParams{
		TenantID: tenantID, ItemID: itemID, LocationID: level.LocationID,
		Minimum: int32(level.Minimum), Maximum: int32(level.Maximum),
		ReorderQuantity: int32(level.ReorderQuantity),
		UpdatedAt:       stamp(at), UpdatedBy: by,
	})
}

// StockLevels lists the configured policies.
func (r MasterRepo) StockLevels(ctx context.Context, scope authctx.TenantScope,
	locationID string, limit int32) ([]domain.StockLevel, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListStockLevels(ctx,
		sqlcgen.ListStockLevelsParams{
			TenantID: tenantID, LocationID: locationID, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.StockLevel, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.StockLevel{
			ItemID: row.ItemID.String(), LocationID: row.LocationID,
			Minimum: int(row.Minimum), Maximum: int(row.Maximum),
			ReorderQuantity: int(row.ReorderQuantity),
		})
	}
	return out, nil
}
