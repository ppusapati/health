package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
	"github.com/ppusapati/health/code/internal/security/domain"
)

// Emergency and downtime access persistence (SRS-SEC-014).

// uniqueViolation is the SQLSTATE for a unique index rejection. The partial
// index on active grants is a control, not an optimisation, so its rejection
// has to be translated into the domain's own error rather than surfacing as
// "database error".
const uniqueViolation = "23505"

func isUniqueViolation(err error) bool {
	var pgErr *pgconn.PgError
	return errors.As(err, &pgErr) && pgErr.Code == uniqueViolation
}

// InsertGrant records an activation.
//
// The concurrency story lives in the database: the partial unique index on
// (tenant_id, subject_id) WHERE status = 'active' is what refuses a second
// activation. A read-then-write in Go would let two requests both observe no
// active grant and both insert, which is precisely the stacking the TTL bound
// exists to prevent.
func (r *Repository) InsertGrant(ctx context.Context, scope authctx.TenantScope, g domain.EmergencyGrant) error {
	tenant, err := tenantUUID(scope)
	if err != nil {
		return err
	}
	grantID, err := uuid.Parse(g.ID)
	if err != nil {
		return rpcerr.Internal("SEC_GRANT_ID_INVALID", "grant_id must be a UUID").WithCause(err)
	}

	err = r.queries(ctx).InsertEmergencyGrant(ctx, sqlcgen.InsertEmergencyGrantParams{
		GrantID:       grantID,
		TenantID:      tenant,
		SubjectID:     g.SubjectID,
		FacilityID:    g.FacilityID,
		IncidentRef:   g.IncidentRef,
		Justification: g.Justification,
		Permissions:   g.Permissions,
		Status:        string(g.Status),
		ActivatedAt:   timestamptz(g.ActivatedAt),
		ExpiresAt:     timestamptz(g.ExpiresAt),
		CorrelationID: g.CorrelationID,
	})
	if isUniqueViolation(err) {
		return domain.ErrGrantAlreadyActive
	}
	return err
}

// GetGrant reads one grant within the caller's tenant.
func (r *Repository) GetGrant(ctx context.Context, scope authctx.TenantScope, grantID string) (domain.EmergencyGrant, error) {
	tenant, err := tenantUUID(scope)
	if err != nil {
		return domain.EmergencyGrant{}, err
	}
	id, err := uuid.Parse(grantID)
	if err != nil {
		// A malformed identifier is NOT_FOUND rather than INVALID_ARGUMENT:
		// the two answers together would let a caller distinguish "no such
		// grant" from "not yours".
		return domain.EmergencyGrant{}, rpcerr.NotFound("SEC_GRANT_NOT_FOUND", "emergency grant not found")
	}

	row, err := r.queries(ctx).GetEmergencyGrant(ctx, sqlcgen.GetEmergencyGrantParams{
		TenantID: tenant, GrantID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.EmergencyGrant{}, rpcerr.NotFound("SEC_GRANT_NOT_FOUND", "emergency grant not found")
	}
	if err != nil {
		return domain.EmergencyGrant{}, err
	}
	return grantFromRow(row), nil
}

// ActiveGrantFor returns the subject's open grant, if any.
func (r *Repository) ActiveGrantFor(ctx context.Context, scope authctx.TenantScope, subjectID string) (domain.EmergencyGrant, bool, error) {
	tenant, err := tenantUUID(scope)
	if err != nil {
		return domain.EmergencyGrant{}, false, err
	}
	row, err := r.queries(ctx).GetActiveEmergencyGrant(ctx, sqlcgen.GetActiveEmergencyGrantParams{
		TenantID: tenant, SubjectID: subjectID,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.EmergencyGrant{}, false, nil
	}
	if err != nil {
		return domain.EmergencyGrant{}, false, err
	}
	return grantFromRow(row), true, nil
}

// RecordAccess appends a resource the grant was used to reach.
//
// The expiry predicate is in the statement rather than checked beforehand, so
// a grant that has passed its window cannot record access even if the sweeper
// has not yet marked it expired.
func (r *Repository) RecordAccess(ctx context.Context, scope authctx.TenantScope, grantID, resourceRef string, now time.Time) error {
	tenant, err := tenantUUID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(grantID)
	if err != nil {
		return rpcerr.NotFound("SEC_GRANT_NOT_FOUND", "emergency grant not found")
	}

	rows, err := r.queries(ctx).RecordEmergencyAccess(ctx, sqlcgen.RecordEmergencyAccessParams{
		ResourceRef: resourceRef, TenantID: tenant, GrantID: id, Now: timestamptz(now),
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return domain.ErrGrantNotActive
	}
	return nil
}

// CloseGrant ends an activation early.
func (r *Repository) CloseGrant(ctx context.Context, scope authctx.TenantScope, grantID string, at time.Time) error {
	tenant, err := tenantUUID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(grantID)
	if err != nil {
		return rpcerr.NotFound("SEC_GRANT_NOT_FOUND", "emergency grant not found")
	}

	rows, err := r.queries(ctx).CloseEmergencyGrant(ctx, sqlcgen.CloseEmergencyGrantParams{
		ClosedAt: timestamptz(at), TenantID: tenant, GrantID: id,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return domain.ErrGrantNotActive
	}
	return nil
}

// ExpireGrants sweeps activations whose window has closed.
//
// Deliberately untenanted: the sweeper runs for the whole deployment, and a
// per-tenant sweep would leave a quiet tenant's grants open indefinitely. It
// is the one method here that takes no scope, which is why it is not on a
// port a request handler can reach.
func (r *Repository) ExpireGrants(ctx context.Context, now time.Time) (int64, error) {
	return r.queries(ctx).ExpireEmergencyGrants(ctx, timestamptz(now))
}

// ReviewGrant records the post-hoc review.
//
// The statement refuses self-review and refuses a grant whose window has not
// closed; zero rows therefore means one of those, not a missing row, and the
// caller gets the domain error rather than a silent no-op. now is passed in
// because "ended" is judged against the clock, not against the stored status.
func (r *Repository) ReviewGrant(ctx context.Context, scope authctx.TenantScope, g domain.EmergencyGrant, now time.Time) error {
	tenant, err := tenantUUID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(g.ID)
	if err != nil {
		return rpcerr.NotFound("SEC_GRANT_NOT_FOUND", "emergency grant not found")
	}

	rows, err := r.queries(ctx).ReviewEmergencyGrant(ctx, sqlcgen.ReviewEmergencyGrantParams{
		Status:     string(g.Status),
		ReviewedBy: g.ReviewedBy,
		ReviewedAt: timestamptz(g.ReviewedAt),
		ReviewNote: g.ReviewNote,
		TenantID:   tenant,
		GrantID:    id,
		Now:        timestamptz(now),
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return rpcerr.FailedPrecondition("SEC_GRANT_NOT_REVIEWABLE",
			"grant is still active, already reviewed, or would be reviewed by its own subject")
	}
	return nil
}

// GrantsAwaitingReview lists finished grants nobody has reviewed.
func (r *Repository) GrantsAwaitingReview(ctx context.Context, scope authctx.TenantScope, limit int32) ([]domain.EmergencyGrant, error) {
	tenant, err := tenantUUID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListGrantsAwaitingReview(ctx, sqlcgen.ListGrantsAwaitingReviewParams{
		TenantID: tenant, PageSize: limit,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.EmergencyGrant, 0, len(rows))
	for _, row := range rows {
		out = append(out, grantFromRow(row))
	}
	return out, nil
}

func grantFromRow(row sqlcgen.SecurityPlatformEmergencyGrant) domain.EmergencyGrant {
	g := domain.EmergencyGrant{
		ID:                row.GrantID.String(),
		TenantID:          row.TenantID.String(),
		SubjectID:         row.SubjectID,
		FacilityID:        row.FacilityID,
		IncidentRef:       row.IncidentRef,
		Justification:     row.Justification,
		Permissions:       row.Permissions,
		Status:            domain.EmergencyGrantStatus(row.Status),
		ActivatedAt:       row.ActivatedAt.Time,
		ExpiresAt:         row.ExpiresAt.Time,
		AccessedResources: row.AccessedResources,
		ReviewedBy:        row.ReviewedBy,
		ReviewNote:        row.ReviewNote,
		CorrelationID:     row.CorrelationID,
	}
	if row.ClosedAt.Valid {
		g.ClosedAt = row.ClosedAt.Time
	}
	if row.ReviewedAt.Valid {
		g.ReviewedAt = row.ReviewedAt.Time
	}
	return g
}
