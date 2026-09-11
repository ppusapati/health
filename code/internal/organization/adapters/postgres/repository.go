// Package postgres is the organization context's persistence adapter.
//
// It is the only package permitted to issue SQL against the organization schema
// (FIT-02). Every tenant-owned method takes an authctx.TenantScope, so the
// tenant predicate is always present and always comes from verified
// credentials (SRS-PLT-003, FIT-03).
package postgres

import (
	"context"
	"encoding/base64"
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/organization/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// uniqueViolation is the PostgreSQL SQLSTATE for a unique-constraint breach.
const uniqueViolation = "23505"

// Repository implements the organization repository ports.
type Repository struct {
	tx *pgtx.Manager
}

// New constructs a Repository.
func New(tx *pgtx.Manager) *Repository { return &Repository{tx: tx} }

func (r *Repository) queries(ctx context.Context) *sqlcgen.Queries {
	return sqlcgen.New(r.tx.Querier(ctx))
}

func timestamptz(t time.Time) pgtype.Timestamptz {
	return pgtype.Timestamptz{Time: t.UTC(), Valid: true}
}

// actorOrSystem returns the acting subject for provenance columns, falling back
// to "system" for unattended processes such as migrations and workers.
func actorOrSystem(ctx context.Context) string {
	if s, err := authctx.FromContext(ctx); err == nil {
		return s.SubjectID
	}
	return "system"
}

// Insert persists a new tenant.
func (r *Repository) Insert(ctx context.Context, t *domain.Tenant) error {
	id, err := uuid.Parse(t.ID)
	if err != nil {
		return rpcerr.Internal("ORG_TENANT_ID_INVALID", "tenant_id must be a UUID").WithCause(err)
	}
	actor := actorOrSystem(ctx)

	err = r.queries(ctx).InsertTenant(ctx, sqlcgen.InsertTenantParams{
		TenantID:          id,
		DisplayName:       t.DisplayName,
		LegalJurisdiction: t.LegalJurisdiction,
		DefaultLocale:     t.DefaultLocale,
		TimeZone:          t.TimeZone,
		Status:            string(t.Status),
		CreatedAt:         timestamptz(t.CreatedAt),
		CreatedBy:         actor,
		UpdatedAt:         timestamptz(t.UpdatedAt),
		UpdatedBy:         actor,
		Version:           t.Version,
	})
	if isUniqueViolation(err) {
		return rpcerr.AlreadyExists("ORG_TENANT_EXISTS", "tenant already exists")
	}
	return err
}

// GetByID reads a tenant.
func (r *Repository) GetByID(ctx context.Context, tenantID string) (*domain.Tenant, error) {
	id, err := uuid.Parse(tenantID)
	if err != nil {
		// A malformed ID cannot match anything; reporting not-found avoids
		// leaking whether the format is even meaningful.
		return nil, rpcerr.NotFound("ORG_TENANT_NOT_FOUND", "tenant not found")
	}

	row, err := r.queries(ctx).GetTenantByID(ctx, id)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, rpcerr.NotFound("ORG_TENANT_NOT_FOUND", "tenant not found")
	}
	if err != nil {
		return nil, err
	}

	return &domain.Tenant{
		ID:                row.TenantID.String(),
		DisplayName:       row.DisplayName,
		LegalJurisdiction: row.LegalJurisdiction,
		DefaultLocale:     row.DefaultLocale,
		TimeZone:          row.TimeZone,
		Status:            domain.TenantStatus(row.Status),
		CreatedAt:         row.CreatedAt.Time,
		UpdatedAt:         row.UpdatedAt.Time,
		Version:           row.Version,
	}, nil
}

// InsertFacility persists a new facility within the verified tenant scope.
func (r *Repository) InsertFacility(ctx context.Context, scope authctx.TenantScope, f *domain.Facility) error {
	tenantID, facilityID, err := scopedIDs(scope, f.TenantID, f.ID)
	if err != nil {
		return err
	}
	actor := actorOrSystem(ctx)

	err = r.queries(ctx).InsertFacility(ctx, sqlcgen.InsertFacilityParams{
		FacilityID:  facilityID,
		TenantID:    tenantID,
		Code:        f.Code,
		DisplayName: f.DisplayName,
		Type:        string(f.Type),
		Status:      string(f.Status),
		TimeZone:    f.TimeZone,
		CreatedAt:   timestamptz(f.CreatedAt),
		CreatedBy:   actor,
		UpdatedAt:   timestamptz(f.UpdatedAt),
		UpdatedBy:   actor,
		Version:     f.Version,
	})
	if isUniqueViolation(err) {
		return rpcerr.AlreadyExists("ORG_FACILITY_CODE_TAKEN",
			"facility code already exists in this tenant")
	}
	return err
}

// GetFacilityByID reads one facility inside the verified tenant scope.
func (r *Repository) GetFacilityByID(ctx context.Context, scope authctx.TenantScope, facilityID string) (*domain.Facility, error) {
	if scope.IsZero() {
		return nil, errNoScope()
	}
	tenantUUID, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return nil, errNoScope()
	}
	id, err := uuid.Parse(facilityID)
	if err != nil {
		return nil, rpcerr.NotFound("ORG_FACILITY_NOT_FOUND", "facility not found")
	}

	row, err := r.queries(ctx).GetFacilityByID(ctx, sqlcgen.GetFacilityByIDParams{
		TenantID:   tenantUUID,
		FacilityID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		// Another tenant's facility is indistinguishable from a nonexistent
		// one, by design (SRS-SEC-011).
		return nil, rpcerr.NotFound("ORG_FACILITY_NOT_FOUND", "facility not found")
	}
	if err != nil {
		return nil, err
	}

	return &domain.Facility{
		ID:          row.FacilityID.String(),
		TenantID:    row.TenantID.String(),
		Code:        row.Code,
		DisplayName: row.DisplayName,
		Type:        domain.FacilityType(row.Type),
		Status:      domain.FacilityStatus(row.Status),
		TimeZone:    row.TimeZone,
		CreatedAt:   row.CreatedAt.Time,
		UpdatedAt:   row.UpdatedAt.Time,
		Version:     row.Version,
	}, nil
}

// ExistsByCode reports whether the tenant already uses a facility code.
func (r *Repository) ExistsByCode(ctx context.Context, scope authctx.TenantScope, code string) (bool, error) {
	if scope.IsZero() {
		return false, errNoScope()
	}
	tenantUUID, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return false, errNoScope()
	}
	return r.queries(ctx).FacilityCodeExists(ctx, sqlcgen.FacilityCodeExistsParams{
		TenantID: tenantUUID,
		Code:     code,
	})
}

// ListFacilities returns one keyset page plus the cursor for the next.
func (r *Repository) ListFacilities(ctx context.Context, scope authctx.TenantScope, filter ports.FacilityFilter) ([]*domain.Facility, string, error) {
	if scope.IsZero() {
		return nil, "", errNoScope()
	}
	tenantUUID, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return nil, "", errNoScope()
	}

	params := sqlcgen.ListFacilitiesParams{
		TenantID: tenantUUID,
		// Fetch one extra row to learn whether another page exists without a
		// second COUNT query.
		PageLimit: filter.PageSize + 1,
	}
	if filter.Status != "" {
		status := string(filter.Status)
		params.Status = &status
	}
	if filter.PageToken != "" {
		at, id, err := decodeCursor(filter.PageToken)
		if err != nil {
			return nil, "", rpcerr.Invalid("ORG_PAGE_TOKEN_INVALID", "page token is not valid",
				rpcerr.FieldViolation{Field: "page_token", Reason: "MALFORMED"})
		}
		params.CursorCreatedAt = timestamptz(at)
		params.CursorID = pgtype.UUID{Bytes: id, Valid: true}
	}

	rows, err := r.queries(ctx).ListFacilities(ctx, params)
	if err != nil {
		return nil, "", err
	}

	var next string
	if len(rows) > int(filter.PageSize) {
		last := rows[filter.PageSize-1]
		next = encodeCursor(last.CreatedAt.Time, last.FacilityID)
		rows = rows[:filter.PageSize]
	}

	out := make([]*domain.Facility, 0, len(rows))
	for _, row := range rows {
		out = append(out, &domain.Facility{
			ID:          row.FacilityID.String(),
			TenantID:    row.TenantID.String(),
			Code:        row.Code,
			DisplayName: row.DisplayName,
			Type:        domain.FacilityType(row.Type),
			Status:      domain.FacilityStatus(row.Status),
			TimeZone:    row.TimeZone,
			CreatedAt:   row.CreatedAt.Time,
			UpdatedAt:   row.UpdatedAt.Time,
			Version:     row.Version,
		})
	}
	return out, next, nil
}

// scopedIDs validates that the aggregate belongs to the verified scope. A
// mismatch is a programming error, not a client error: the application layer
// must never hand the repository an aggregate from another tenant.
func scopedIDs(scope authctx.TenantScope, aggregateTenantID, aggregateID string) (uuid.UUID, uuid.UUID, error) {
	if scope.IsZero() {
		return uuid.Nil, uuid.Nil, errNoScope()
	}
	if aggregateTenantID != scope.TenantID() {
		return uuid.Nil, uuid.Nil, rpcerr.Internal("ORG_TENANT_SCOPE_MISMATCH",
			"aggregate tenant does not match verified scope")
	}
	tenantUUID, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.Nil, uuid.Nil, errNoScope()
	}
	id, err := uuid.Parse(aggregateID)
	if err != nil {
		return uuid.Nil, uuid.Nil, rpcerr.Internal("ORG_ID_INVALID", "identifier must be a UUID").WithCause(err)
	}
	return tenantUUID, id, nil
}

func errNoScope() error {
	return rpcerr.Internal("ORG_TENANT_SCOPE_MISSING", "tenant scope is required")
}

func isUniqueViolation(err error) bool {
	var pgErr *pgconn.PgError
	return errors.As(err, &pgErr) && pgErr.Code == uniqueViolation
}

// encodeCursor packs the keyset position into an opaque token. Callers must not
// parse it: the sort key is free to change.
func encodeCursor(at time.Time, id uuid.UUID) string {
	raw := fmt.Sprintf("%s|%s", at.UTC().Format(time.RFC3339Nano), id.String())
	return base64.RawURLEncoding.EncodeToString([]byte(raw))
}

func decodeCursor(token string) (time.Time, uuid.UUID, error) {
	raw, err := base64.RawURLEncoding.DecodeString(token)
	if err != nil {
		return time.Time{}, uuid.Nil, err
	}
	parts := strings.SplitN(string(raw), "|", 2)
	if len(parts) != 2 {
		return time.Time{}, uuid.Nil, errors.New("cursor: expected two parts")
	}
	at, err := time.Parse(time.RFC3339Nano, parts[0])
	if err != nil {
		return time.Time{}, uuid.Nil, err
	}
	id, err := uuid.Parse(parts[1])
	if err != nil {
		return time.Time{}, uuid.Nil, err
	}
	return at, id, nil
}
