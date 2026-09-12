// Package postgres is the scheduling context's persistence adapter.
//
// It is the only package permitted to issue SQL against the scheduling schema
// (FIT-02). Every method takes an authctx.TenantScope, so the tenant predicate
// is always present and always comes from verified credentials (FIT-03).
package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
	"github.com/ppusapati/health/code/internal/scheduling/domain"
	"github.com/ppusapati/health/code/internal/scheduling/ports"
)

// Repository implements the scheduling repository ports.
type Repository struct {
	tx *pgtx.Manager
}

// New constructs a Repository.
func New(tx *pgtx.Manager) *Repository { return &Repository{tx: tx} }

func (r *Repository) queries(ctx context.Context) *sqlcgen.Queries {
	return sqlcgen.New(r.tx.Querier(ctx))
}

// scopeTenantID converts a verified scope into the tenant predicate.
//
// A zero scope is a programming error rather than a caller error: the scope
// type has no constructor outside the auth package, so the only way to reach
// here with one is to have built it as a zero value.
func scopeTenantID(scope authctx.TenantScope) (uuid.UUID, error) {
	if scope.IsZero() {
		return uuid.UUID{}, rpcerr.Internal("SCH_NO_TENANT_SCOPE",
			"a repository call needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("SCH_TENANT_ID_INVALID",
			"tenant_id must be a UUID").WithCause(err)
	}
	return parsed, nil
}

func timestamptz(t time.Time) pgtype.Timestamptz {
	if t.IsZero() {
		return pgtype.Timestamptz{}
	}
	return pgtype.Timestamptz{Time: t.UTC(), Valid: true}
}

func dateOrNull(t time.Time) pgtype.Date {
	if t.IsZero() {
		return pgtype.Date{}
	}
	return pgtype.Date{Time: t.UTC(), Valid: true}
}

func date(t time.Time) pgtype.Date {
	return pgtype.Date{Time: t.UTC(), Valid: true}
}

// optionalUUID renders an empty string as SQL NULL.
func optionalUUID(value string) (pgtype.UUID, error) {
	if value == "" {
		return pgtype.UUID{}, nil
	}
	parsed, err := uuid.Parse(value)
	if err != nil {
		return pgtype.UUID{}, rpcerr.Internal("SCH_ID_INVALID", "identifier must be a UUID").WithCause(err)
	}
	return pgtype.UUID{Bytes: parsed, Valid: true}, nil
}

// notFound is the refusal a caller outside the tenant receives.
//
// NOT_FOUND rather than PERMISSION_DENIED, for the same reason the patient
// index does it: a probe must not be able to confirm that an identifier exists
// in somebody else's tenant.
func notFound() error {
	return rpcerr.NotFound("SCH_NOT_FOUND", "no such scheduling record")
}

func parseIDs(raw []string) []uuid.UUID {
	out := make([]uuid.UUID, 0, len(raw))
	for _, value := range raw {
		parsed, err := uuid.Parse(value)
		if err != nil {
			// A caller-supplied identifier that is not a UUID matches nothing;
			// skipping it keeps one bad value from failing a whole search.
			continue
		}
		out = append(out, parsed)
	}
	return out
}

// ResourceRepo persists bookable resources.
type ResourceRepo struct{ *Repository }

var _ ports.ResourceRepository = ResourceRepo{}

// Insert stores a resource.
func (r ResourceRepo) Insert(ctx context.Context, scope authctx.TenantScope, res domain.Resource) error {
	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	resourceID, err := uuid.Parse(res.ID)
	if err != nil {
		return rpcerr.Internal("SCH_RESOURCE_ID_INVALID", "resource_id must be a UUID").WithCause(err)
	}
	facilityID, err := uuid.Parse(res.FacilityID)
	if err != nil {
		return rpcerr.Internal("SCH_FACILITY_ID_INVALID", "facility_id must be a UUID").WithCause(err)
	}
	orgUnit, err := optionalUUID(res.OrgUnitID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertResource(ctx, sqlcgen.InsertResourceParams{
		ResourceID: resourceID, TenantID: tenantID, FacilityID: facilityID,
		OrgUnitID: orgUnit, ResourceType: string(res.Type),
		SubjectID: res.SubjectID, DisplayName: res.DisplayName,
		Status: string(res.Status), TimeZone: res.TimeZone,
		CreatedAt: timestamptz(res.CreatedAt), UpdatedAt: timestamptz(res.UpdatedAt),
	})
}

// Get reads one resource.
func (r ResourceRepo) Get(ctx context.Context, scope authctx.TenantScope,
	resourceID string) (domain.Resource, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Resource{}, err
	}
	id, err := uuid.Parse(resourceID)
	if err != nil {
		return domain.Resource{}, notFound()
	}

	row, err := r.queries(ctx).GetResource(ctx, sqlcgen.GetResourceParams{
		TenantID: tenantID, ResourceID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Resource{}, notFound()
	}
	if err != nil {
		return domain.Resource{}, err
	}
	return resourceFromRow(sqlcgen.SchedulingResource(row)), nil
}

// SetStatus takes a resource in or out of service.
func (r ResourceRepo) SetStatus(ctx context.Context, scope authctx.TenantScope,
	resourceID string, status domain.ResourceStatus, at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(resourceID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).SetResourceStatus(ctx, sqlcgen.SetResourceStatusParams{
		TenantID: tenantID, ResourceID: id,
		Status: string(status), UpdatedAt: timestamptz(at),
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return notFound()
	}
	return nil
}

// ForSearch returns the active resources a slot search generates from.
func (r ResourceRepo) ForSearch(ctx context.Context, scope authctx.TenantScope,
	q ports.ResourceQuery) ([]domain.Resource, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	facility, err := optionalUUID(q.FacilityID)
	if err != nil {
		return nil, err
	}
	orgUnit, err := optionalUUID(q.OrgUnitID)
	if err != nil {
		return nil, err
	}
	resource, err := optionalUUID(q.ResourceID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListResourcesForSearch(ctx, sqlcgen.ListResourcesForSearchParams{
		TenantID: tenantID, FacilityID: facility, OrgUnitID: orgUnit,
		ResourceID: resource, PageLimit: q.Limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Resource, 0, len(rows))
	for _, row := range rows {
		out = append(out, resourceFromRow(sqlcgen.SchedulingResource(row)))
	}
	return out, nil
}

func resourceFromRow(row sqlcgen.SchedulingResource) domain.Resource {
	r := domain.Resource{
		ID: row.ResourceID.String(), TenantID: row.TenantID.String(),
		FacilityID: row.FacilityID.String(),
		Type:       domain.ResourceType(row.ResourceType),
		SubjectID:  row.SubjectID, DisplayName: row.DisplayName,
		Status: domain.ResourceStatus(row.Status), TimeZone: row.TimeZone,
		CreatedAt: row.CreatedAt.Time.UTC(), UpdatedAt: row.UpdatedAt.Time.UTC(),
	}
	if row.OrgUnitID.Valid {
		r.OrgUnitID = uuid.UUID(row.OrgUnitID.Bytes).String()
	}
	return r
}
