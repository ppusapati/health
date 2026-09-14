package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/orders/domain"
	"github.com/ppusapati/health/code/internal/orders/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// CatalogueRepo persists order sets, favourites and configuration
// (SRS-ORD-003, SRS-ORD-009, SRS-ORD-012).
type CatalogueRepo struct{ *Repository }

var _ ports.CatalogueRepository = CatalogueRepo{}

// NewCatalogue constructs the catalogue adapter.
func NewCatalogue(r *Repository) CatalogueRepo { return CatalogueRepo{r} }

// InsertSet publishes a version of an order set.
func (r CatalogueRepo) InsertSet(ctx context.Context, scope authctx.TenantScope,
	s domain.OrderSet) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	setID, err := mustUUID(s.ID)
	if err != nil {
		return err
	}
	components, err := toJSON(s.Components)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertOrderSet(ctx, sqlcgen.InsertOrderSetParams{
		SetID: setID, TenantID: tenantID, Version: s.Version,
		Name: s.Name, Specialty: s.Specialty, Components: components,
		CreatedBy: s.CreatedBy, CreatedAt: timestamptz(s.CreatedAt),
	})
}

// GetSet reads one version.
func (r CatalogueRepo) GetSet(ctx context.Context, scope authctx.TenantScope,
	setID, version string) (domain.OrderSet, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.OrderSet{}, err
	}
	id, err := lookupUUID(setID)
	if err != nil {
		return domain.OrderSet{}, err
	}

	row, err := r.queries(ctx).GetOrderSet(ctx, sqlcgen.GetOrderSetParams{
		TenantID: tenantID, SetID: id, Version: version,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.OrderSet{}, notFound()
	}
	if err != nil {
		return domain.OrderSet{}, err
	}
	return setFromRow(sqlcgen.OrdersOrderSet(row))
}

// ListSets lists what a clinician may choose from.
func (r CatalogueRepo) ListSets(ctx context.Context, scope authctx.TenantScope,
	specialty string, includeRetired bool, limit int32) (
	[]domain.OrderSet, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListOrderSets(ctx, sqlcgen.ListOrderSetsParams{
		TenantID: tenantID, IncludeRetired: includeRetired,
		SpecialtyFilter: specialty, PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.OrderSet, 0, len(rows))
	for _, row := range rows {
		set, err := setFromRow(sqlcgen.OrdersOrderSet(row))
		if err != nil {
			return nil, err
		}
		out = append(out, set)
	}
	return out, nil
}

// RetireSet withdraws a version from new use.
//
// The orders already placed from it stay valid and keep pointing at it: they
// recorded what was offered at the time, which is the point of versioning
// (SRS-ORD-003).
func (r CatalogueRepo) RetireSet(ctx context.Context, scope authctx.TenantScope,
	setID, version string) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := lookupUUID(setID)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).RetireOrderSet(ctx, sqlcgen.RetireOrderSetParams{
		TenantID: tenantID, SetID: id, Version: version,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return notFound()
	}
	return nil
}

func setFromRow(row sqlcgen.OrdersOrderSet) (domain.OrderSet, error) {
	s := domain.OrderSet{
		ID: row.SetID.String(), TenantID: row.TenantID.String(),
		Version: row.Version, Name: row.Name, Specialty: row.Specialty,
		CreatedBy: row.CreatedBy, CreatedAt: timeOrZero(row.CreatedAt),
	}
	if err := fromJSON(row.Components, &s.Components); err != nil {
		return domain.OrderSet{}, err
	}
	if row.Retired {
		// What callers need is whether the set may still be used, and a
		// non-zero time says so.
		s.RetiredAt = timeOrZero(row.CreatedAt)
		if s.RetiredAt.IsZero() {
			s.RetiredAt = time.Unix(0, 0).UTC()
		}
	}
	return s, nil
}

// UpsertFavourite stores one clinician's saved order (SRS-ORD-012).
func (r CatalogueRepo) UpsertFavourite(ctx context.Context,
	scope authctx.TenantScope, f domain.Favourite) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	favouriteID, err := mustUUID(f.ID)
	if err != nil {
		return err
	}

	priority := string(f.Priority)
	if priority == "" {
		priority = string(domain.PriorityRoutine)
	}

	return r.queries(ctx).UpsertFavourite(ctx, sqlcgen.UpsertFavouriteParams{
		FavouriteID: favouriteID, TenantID: tenantID,
		OwnerID: f.OwnerID, Name: f.Name, OrderType: string(f.Type),
		CodeSystem: f.Code.System, CodeVersion: f.Code.Version,
		Code: f.Code.Code, CodeDisplay: f.Code.Display,
		Detail: f.Detail, Indication: f.Indication, Priority: priority,
		TimingStartAt:          timestamptz(f.Timing.StartAt),
		TimingFrequencySeconds: int64(f.Timing.Frequency / time.Second),
		TimingCount:            f.Timing.Count,
		TimingTimesOfDay:       orEmptyInt32(f.Timing.TimesOfDay),
		TimingDaysOfWeek:       weekdaysToInts(f.Timing.DaysOfWeek),
		TimingPrn:              f.Timing.PRN,
		CreatedAt:              timestamptz(f.CreatedAt),
		UpdatedAt:              timestamptz(f.UpdatedAt),
	})
}

// GetFavourite reads one.
func (r CatalogueRepo) GetFavourite(ctx context.Context,
	scope authctx.TenantScope, favouriteID string) (domain.Favourite, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Favourite{}, err
	}
	id, err := lookupUUID(favouriteID)
	if err != nil {
		return domain.Favourite{}, err
	}

	row, err := r.queries(ctx).GetFavourite(ctx, sqlcgen.GetFavouriteParams{
		TenantID: tenantID, FavouriteID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Favourite{}, notFound()
	}
	if err != nil {
		return domain.Favourite{}, err
	}
	return favouriteFromRow(row), nil
}

// ListFavourites reads one clinician's own.
//
// Scoped to the owner at the query, not filtered afterwards: a favourite is
// never shared, because a shared shortcut with no review is an order set that
// escaped governance (SRS-ORD-012).
func (r CatalogueRepo) ListFavourites(ctx context.Context,
	scope authctx.TenantScope, ownerID string, orderType domain.Type,
	limit int32) ([]domain.Favourite, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListFavourites(ctx, sqlcgen.ListFavouritesParams{
		TenantID: tenantID, OwnerID: ownerID,
		TypeFilter: string(orderType), PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Favourite, 0, len(rows))
	for _, row := range rows {
		out = append(out, favouriteFromRow(row))
	}
	return out, nil
}

// DeleteFavourite removes one, scoped to its owner.
func (r CatalogueRepo) DeleteFavourite(ctx context.Context,
	scope authctx.TenantScope, favouriteID, ownerID string) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := lookupUUID(favouriteID)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).DeleteFavourite(ctx, sqlcgen.DeleteFavouriteParams{
		TenantID: tenantID, FavouriteID: id, OwnerID: ownerID,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return notFound()
	}
	return nil
}

func favouriteFromRow(row sqlcgen.OrdersOrderFavourite) domain.Favourite {
	return domain.Favourite{
		ID: row.FavouriteID.String(), TenantID: row.TenantID.String(),
		OwnerID: row.OwnerID, Name: row.Name,
		Type: domain.Type(row.OrderType),
		Code: domain.Coding{
			System: row.CodeSystem, Version: row.CodeVersion,
			Code: row.Code, Display: row.CodeDisplay,
		},
		Detail: row.Detail, Indication: row.Indication,
		Priority: domain.Priority(row.Priority),
		Timing: domain.Timing{
			StartAt:    timeOrZero(row.TimingStartAt),
			Frequency:  time.Duration(row.TimingFrequencySeconds) * time.Second,
			Count:      row.TimingCount,
			TimesOfDay: row.TimingTimesOfDay,
			DaysOfWeek: weekdaysFromInts(row.TimingDaysOfWeek),
			PRN:        row.TimingPrn,
		},
		CreatedAt: timeOrZero(row.CreatedAt),
		UpdatedAt: timeOrZero(row.UpdatedAt),
	}
}

// SetPolicy configures what an order type requires (SRS-ORD-002, SRS-ORD-007).
func (r CatalogueRepo) SetPolicy(ctx context.Context, scope authctx.TenantScope,
	orderType domain.Type, indicationRequired, structuredTimingRequired bool,
	privilege, updatedBy string, now time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}

	return r.queries(ctx).UpsertOrderPolicy(ctx, sqlcgen.UpsertOrderPolicyParams{
		TenantID: tenantID, OrderType: string(orderType),
		IndicationRequired:       indicationRequired,
		StructuredTimingRequired: structuredTimingRequired,
		RequiredPrivilege:        privilege,
		UpdatedBy:                updatedBy, UpdatedAt: timestamptz(now),
	})
}

// Policy returns the tenant's configuration over the domain default.
//
// Merged rather than replaced: a tenant that has configured one order type gets
// the safe starting point for the other eight, because a policy table with one
// row must not mean "nothing is required anywhere".
func (r CatalogueRepo) Policy(ctx context.Context, scope authctx.TenantScope) (
	domain.Policy, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Policy{}, err
	}

	policy := domain.DefaultPolicy()
	rows, err := r.queries(ctx).ListOrderPolicy(ctx, tenantID)
	if err != nil {
		return domain.Policy{}, err
	}
	for _, row := range rows {
		orderType := domain.Type(row.OrderType)
		policy.IndicationRequired[orderType] = row.IndicationRequired
		policy.StructuredTimingRequired[orderType] = row.StructuredTimingRequired
		if row.RequiredPrivilege == "" {
			delete(policy.PrivilegedTypes, orderType)
			continue
		}
		policy.PrivilegedTypes[orderType] = row.RequiredPrivilege
	}
	return policy, nil
}

// SetDuplicateRule configures how two orders count as the same (SRS-ORD-009).
func (r CatalogueRepo) SetDuplicateRule(ctx context.Context,
	scope authctx.TenantScope, rule domain.DuplicateRule, updatedBy string,
	now time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}

	return r.queries(ctx).UpsertDuplicateRule(ctx,
		sqlcgen.UpsertDuplicateRuleParams{
			TenantID: tenantID, OrderType: string(rule.Type),
			WithinSeconds: int64(rule.Within / time.Second),
			SameCodeOnly:  rule.SameCodeOnly,
			// Default true at the table and here, deliberately: SRS-ORD-009
			// says a warning "rather than arbitrary suppression".
			Overridable: rule.Overridable,
			UpdatedBy:   updatedBy, UpdatedAt: timestamptz(now),
		})
}

// DuplicateRules returns the tenant's rules over the domain defaults.
func (r CatalogueRepo) DuplicateRules(ctx context.Context,
	scope authctx.TenantScope) (map[domain.Type]domain.DuplicateRule, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rules := domain.DefaultDuplicateRules()
	rows, err := r.queries(ctx).ListDuplicateRules(ctx, tenantID)
	if err != nil {
		return nil, err
	}
	for _, row := range rows {
		orderType := domain.Type(row.OrderType)
		rules[orderType] = domain.DuplicateRule{
			Type:         orderType,
			Within:       time.Duration(row.WithinSeconds) * time.Second,
			SameCodeOnly: row.SameCodeOnly, Overridable: row.Overridable,
		}
	}
	return rules, nil
}
