package postgres

import (
	"context"
	"errors"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
	"github.com/ppusapati/health/code/internal/security/domain"
)

// Retention class persistence (SRS-DAT-009).

// InsertClass records a retention class.
func (r *Repository) InsertClass(ctx context.Context, scope authctx.TenantScope, c domain.RetentionClass) error {
	tenant, err := tenantUUID(scope)
	if err != nil {
		return err
	}
	classID, err := uuid.Parse(c.ID)
	if err != nil {
		return rpcerr.Internal("SEC_RETENTION_ID_INVALID", "retention_class_id must be a UUID").WithCause(err)
	}

	err = r.queries(ctx).InsertRetentionClass(ctx, sqlcgen.InsertRetentionClassParams{
		RetentionClassID: classID,
		TenantID:         tenant,
		Name:             c.Name,
		DataClass:        c.DataClass,
		RetainDays:       c.RetainDays,
		ArchiveAfterDays: c.ArchiveAfterDays,
		CreatedAt:        timestamptz(c.CreatedAt),
		UpdatedAt:        timestamptz(c.UpdatedAt),
	})
	if isUniqueViolation(err) {
		return rpcerr.AlreadyExists("SEC_RETENTION_CLASS_EXISTS", "a retention class with that name already exists")
	}
	return err
}

// GetClass reads a retention class by name.
func (r *Repository) GetClass(ctx context.Context, scope authctx.TenantScope, name string) (domain.RetentionClass, error) {
	tenant, err := tenantUUID(scope)
	if err != nil {
		return domain.RetentionClass{}, err
	}

	row, err := r.queries(ctx).GetRetentionClass(ctx, sqlcgen.GetRetentionClassParams{
		TenantID: tenant, Name: name,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.RetentionClass{}, rpcerr.NotFound("SEC_RETENTION_CLASS_NOT_FOUND", "retention class not found")
	}
	if err != nil {
		return domain.RetentionClass{}, err
	}

	c := domain.RetentionClass{
		ID:        row.RetentionClassID.String(),
		TenantID:  row.TenantID.String(),
		Name:      row.Name,
		DataClass: row.DataClass,
		CreatedAt: row.CreatedAt.Time,
		UpdatedAt: row.UpdatedAt.Time,
	}
	// NULL means retain indefinitely, which the domain represents as a nil
	// pointer rather than as a sentinel number. Zero would read as "delete
	// immediately", which is the opposite of what NULL means here.
	c.RetainDays = copyDays(row.RetainDays)
	c.ArchiveAfterDays = copyDays(row.ArchiveAfterDays)
	return c, nil
}

// copyDays detaches the value from the row the driver allocated, so a caller
// holding a RetentionClass cannot be affected by anything the row is reused
// for later.
func copyDays(days *int32) *int32 {
	if days == nil {
		return nil
	}
	v := *days
	return &v
}
