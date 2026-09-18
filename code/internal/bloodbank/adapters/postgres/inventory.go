package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/bloodbank/domain"
	"github.com/ppusapati/health/code/internal/bloodbank/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// InventoryRepo implements ports.InventoryRepository.
type InventoryRepo struct{ *Repository }

var _ ports.InventoryRepository = InventoryRepo{}

// InsertComponent brings a component into inventory.
func (r InventoryRepo) InsertComponent(ctx context.Context,
	scope authctx.TenantScope, c domain.Component) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	componentID, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}
	collectionID, err := uuid.Parse(c.CollectionID)
	if err != nil {
		return notFound()
	}
	donorID, err := optionalUUID(c.DonorID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertComponent(ctx, sqlcgen.InsertComponentParams{
		ComponentID: componentID, TenantID: tenantID,
		UnitNumber: c.UnitNumber, CollectionID: collectionID,
		DonorID: donorID, Source: c.Source,
		ComponentClass: string(c.Class),
		// NOT NULL, because an ungrouped unit cannot be allocated to anybody
		// and so has no business on the shelf.
		Abo: string(c.Group.ABO), Rhd: string(c.Group.Rh),
		Status: string(c.Status), VolumeMl: int32(c.VolumeML),
		Attributes: strings0(c.Attributes), Location: c.Location,
		CollectedAt: stamp(c.CollectedAt), ExpiresAt: stamp(c.ExpiresAt),
		CreatedAt: stamp(c.CreatedAt), CreatedBy: c.CreatedBy,
	})
}

// Component reads one unit.
func (r InventoryRepo) Component(ctx context.Context, scope authctx.TenantScope,
	componentID string) (domain.Component, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Component{}, err
	}
	id, err := uuid.Parse(componentID)
	if err != nil {
		return domain.Component{}, notFound()
	}

	row, err := r.queries(ctx).GetComponent(ctx, sqlcgen.GetComponentParams{
		TenantID: tenantID, ComponentID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Component{}, notFound()
	}
	if err != nil {
		return domain.Component{}, err
	}
	return componentFrom(row), nil
}

// ComponentByNumber reads the unit a label names, which is what a bedside scan
// has.
func (r InventoryRepo) ComponentByNumber(ctx context.Context,
	scope authctx.TenantScope, unitNumber string) (domain.Component, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Component{}, err
	}
	row, err := r.queries(ctx).GetComponentByNumber(ctx,
		sqlcgen.GetComponentByNumberParams{
			TenantID: tenantID, UnitNumber: unitNumber,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Component{}, notFound()
	}
	if err != nil {
		return domain.Component{}, err
	}
	return componentFrom(row), nil
}

// UpdateStatus moves a unit between states.
func (r InventoryRepo) UpdateStatus(ctx context.Context,
	scope authctx.TenantScope, c domain.Component, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	componentID, err := uuid.Parse(c.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateComponentStatus(ctx,
		sqlcgen.UpdateComponentStatusParams{
			TenantID: tenantID, ComponentID: componentID,
			Status: string(c.Status), DiscardReason: string(c.DiscardReason),
			Location: c.Location, ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		// Either the row moved under us or it is not ours. Both are the same
		// answer to the caller: re-read and decide again.
		return ports.ErrVersionConflict
	}
	return nil
}

// ComponentsForCollection reads every component made from one donation.
func (r InventoryRepo) ComponentsForCollection(ctx context.Context,
	scope authctx.TenantScope, collectionID string) ([]domain.Component, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(collectionID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListComponentsForCollection(ctx,
		sqlcgen.ListComponentsForCollectionParams{
			TenantID: tenantID, CollectionID: id,
		})
	if err != nil {
		return nil, err
	}
	return componentsFrom(rows), nil
}

// Siblings runs the look-back: from one component to every other made from the
// same donation.
func (r InventoryRepo) Siblings(ctx context.Context, scope authctx.TenantScope,
	componentID string) ([]domain.Component, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(componentID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListSiblingComponents(ctx,
		sqlcgen.ListSiblingComponentsParams{
			TenantID: tenantID, ComponentID: id,
		})
	if err != nil {
		return nil, err
	}
	return componentsFrom(rows), nil
}

// Allocatable hands back candidates, soonest to expire first.
//
// Compatibility is decided by the domain, never by SQL: a WHERE clause that
// encoded the ABO table would be a second copy of it, and the two would
// diverge.
func (r InventoryRepo) Allocatable(ctx context.Context,
	scope authctx.TenantScope, class domain.ComponentClass, asOf time.Time,
	limit int32) ([]domain.Component, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListAllocatableComponents(ctx,
		sqlcgen.ListAllocatableComponentsParams{
			TenantID: tenantID, ComponentClass: string(class),
			AsOf: stamp(asOf), RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return componentsFrom(rows), nil
}

// Inventory reads everything on the shelf.
func (r InventoryRepo) Inventory(ctx context.Context, scope authctx.TenantScope,
	limit int32) ([]domain.Component, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListInventory(ctx, sqlcgen.ListInventoryParams{
		TenantID: tenantID, RowLimit: limit,
	})
	if err != nil {
		return nil, err
	}
	return componentsFrom(rows), nil
}

// CountDiscarded counts units taken out of inventory in a period.
func (r InventoryRepo) CountDiscarded(ctx context.Context,
	scope authctx.TenantScope, from, to time.Time) (int, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return 0, err
	}
	count, err := r.queries(ctx).CountDiscarded(ctx, sqlcgen.CountDiscardedParams{
		TenantID: tenantID, PeriodStart: stamp(from), PeriodEnd: stamp(to),
	})
	if err != nil {
		return 0, err
	}
	return int(count), nil
}

func componentsFrom(rows []sqlcgen.BloodbankComponent) []domain.Component {
	out := make([]domain.Component, 0, len(rows))
	for _, row := range rows {
		out = append(out, componentFrom(row))
	}
	return out
}

func componentFrom(row sqlcgen.BloodbankComponent) domain.Component {
	return domain.Component{
		ID: row.ComponentID.String(), TenantID: row.TenantID.String(),
		UnitNumber: row.UnitNumber, CollectionID: row.CollectionID.String(),
		DonorID: uuidOrEmpty(row.DonorID), Source: row.Source,
		Class:      domain.ComponentClass(row.ComponentClass),
		Group:      groupOf(row.Abo, row.Rhd),
		Status:     domain.UnitStatus(row.Status),
		VolumeML:   int(row.VolumeMl),
		Attributes: row.Attributes, Location: row.Location,
		CollectedAt: timeOf(row.CollectedAt), ExpiresAt: timeOf(row.ExpiresAt),
		CreatedAt: timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
}

// SaveThreshold sets a configured minimum for one bucket.
func (r InventoryRepo) SaveThreshold(ctx context.Context,
	scope authctx.TenantScope, facilityID string, t domain.StockThreshold,
	by string, at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	return r.queries(ctx).UpsertStockThreshold(ctx,
		sqlcgen.UpsertStockThresholdParams{
			ThresholdID: uuid.New(), TenantID: tenantID, FacilityID: facilityID,
			ComponentClass: string(t.Class),
			Abo:            string(t.Group.ABO), Rhd: string(t.Group.Rh),
			Minimum: int32(t.Minimum), SetBy: by, SetAt: stamp(at),
		})
}

// Thresholds reads the configured minimums.
func (r InventoryRepo) Thresholds(ctx context.Context, scope authctx.TenantScope,
	facilityID string) ([]domain.StockThreshold, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListStockThresholds(ctx,
		sqlcgen.ListStockThresholdsParams{
			TenantID: tenantID, FacilityID: facilityID,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.StockThreshold, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.StockThreshold{
			Class:   domain.ComponentClass(row.ComponentClass),
			Group:   groupOf(row.Abo, row.Rhd),
			Minimum: int(row.Minimum),
		})
	}
	return out, nil
}
