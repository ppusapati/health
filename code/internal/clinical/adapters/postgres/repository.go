// Package postgres is the clinical context's persistence adapter.
//
// It is the only package permitted to issue SQL against the clinical schema
// (FIT-02). Every method takes an authctx.TenantScope, so the tenant predicate
// is always present and always comes from verified credentials (FIT-03).
package postgres

import (
	"context"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Repository implements the encounter repository ports.
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
		return uuid.UUID{}, rpcerr.Internal("CLN_NO_TENANT_SCOPE",
			"a repository call needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("CLN_TENANT_ID_INVALID",
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

// optionalUUID renders an empty string as SQL NULL.
func optionalUUID(value string) (pgtype.UUID, error) {
	if value == "" {
		return pgtype.UUID{}, nil
	}
	parsed, err := uuid.Parse(value)
	if err != nil {
		// A caller-supplied identifier that is not a UUID cannot match a row,
		// and reporting it as not-found rather than invalid keeps a probe from
		// distinguishing "malformed" from "belongs to another tenant".
		return pgtype.UUID{}, notFound()
	}
	return pgtype.UUID{Bytes: parsed, Valid: true}, nil
}

func uuidOrEmpty(value pgtype.UUID) string {
	if !value.Valid {
		return ""
	}
	return uuid.UUID(value.Bytes).String()
}

func timeOrZero(value pgtype.Timestamptz) time.Time {
	if !value.Valid {
		return time.Time{}
	}
	return value.Time.UTC()
}

// notFound is the refusal a caller outside the tenant receives.
//
// NOT_FOUND rather than PERMISSION_DENIED, for the same reason the patient
// index does it: a probe must not be able to confirm that an identifier exists
// in somebody else's tenant.
func notFound() error {
	return rpcerr.NotFound("CLN_NOT_FOUND", "no such clinical record")
}

// orEmpty renders a nil slice as an empty one.
//
// A nil []string reaches PostgreSQL as NULL, and the columns here are NOT NULL
// with an empty-array default — which the insert overrides. The symptom is a
// constraint violation on the first encounter with no care team.
func orEmpty(in []string) []string {
	if in == nil {
		return []string{}
	}
	return in
}
