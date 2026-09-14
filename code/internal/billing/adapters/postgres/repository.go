// Package postgres is the billing context's persistence adapter.
//
// It is the only package permitted to issue SQL against the billing schema
// (FIT-02). Every method takes an authctx.TenantScope, so the tenant predicate
// is always present and always comes from verified credentials (FIT-03).
//
// Note what is absent: nothing here updates or deletes a ledger entry, and
// nothing edits an issued invoice's lines or totals. Those absences are the
// mechanism behind SRS-BIL-010 and SRS-BIL-012 rather than a convention
// somebody has to remember.
package postgres

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/ppusapati/health/code/internal/billing/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Repository implements the billing repository ports.
type Repository struct {
	tx *pgtx.Manager
}

// New constructs a Repository.
func New(tx *pgtx.Manager) *Repository { return &Repository{tx: tx} }

func (r *Repository) queries(ctx context.Context) *sqlcgen.Queries {
	return sqlcgen.New(r.tx.Querier(ctx))
}

// scopeTenantID converts a verified scope into the tenant predicate.
func scopeTenantID(scope authctx.TenantScope) (uuid.UUID, error) {
	if scope.IsZero() {
		return uuid.UUID{}, rpcerr.Internal("BIL_NO_TENANT_SCOPE",
			"a repository call needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("BIL_TENANT_ID_INVALID",
			"tenant_id must be a UUID").WithCause(err)
	}
	return parsed, nil
}

// notFound is the refusal a caller outside the tenant receives.
//
// NOT_FOUND rather than PERMISSION_DENIED: a probe must not be able to confirm
// that an invoice number exists in somebody else's tenant.
func notFound() error {
	return rpcerr.NotFound("BIL_NOT_FOUND", "no such billing record")
}

// conflict reports a guarded update that matched no row.
//
// Every guarded UPDATE here carries the record's own precondition as well as
// its version — an invoice must still be a draft, an account must still be open,
// a shift must still be unclosed — so a zero row count means either that
// somebody else got there first or that the precondition no longer holds.
func conflict() error { return ports.ErrVersionConflict }

func timestamptz(t time.Time) pgtype.Timestamptz {
	if t.IsZero() {
		return pgtype.Timestamptz{}
	}
	return pgtype.Timestamptz{Time: t.UTC(), Valid: true}
}

func timeOrZero(value pgtype.Timestamptz) time.Time {
	if !value.Valid {
		return time.Time{}
	}
	return value.Time.UTC()
}

func mustUUID(value string) (uuid.UUID, error) {
	parsed, err := uuid.Parse(value)
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("BIL_ID_INVALID",
			"identifier must be a UUID").WithCause(err)
	}
	return parsed, nil
}

// lookupUUID parses a caller-supplied identifier.
//
// A malformed one cannot match a row, and reporting it as not-found rather than
// invalid keeps a probe from distinguishing "malformed" from "belongs to
// another tenant".
func lookupUUID(value string) (uuid.UUID, error) {
	parsed, err := uuid.Parse(value)
	if err != nil {
		return uuid.UUID{}, notFound()
	}
	return parsed, nil
}

func optionalUUID(value string) (pgtype.UUID, error) {
	if value == "" {
		return pgtype.UUID{}, nil
	}
	parsed, err := uuid.Parse(value)
	if err != nil {
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

func toJSON(v any) ([]byte, error) {
	raw, err := json.Marshal(v)
	if err != nil {
		return nil, rpcerr.Internal("BIL_ENCODE_FAILED",
			"a billing record could not be encoded").WithCause(err)
	}
	return raw, nil
}

func fromJSON(raw []byte, into any) error {
	if len(raw) == 0 {
		return nil
	}
	if err := json.Unmarshal(raw, into); err != nil {
		return rpcerr.Internal("BIL_DECODE_FAILED",
			"a stored billing record could not be decoded").WithCause(err)
	}
	return nil
}

func orEmptyString(in []string) []string {
	if in == nil {
		return []string{}
	}
	return in
}

// uniqueViolation reports a duplicate-key error against a named constraint.
//
// Used to turn the source-reference and idempotency indexes into
// ErrAlreadyRecorded, which is the right answer rather than a failure: a
// redelivered clinical event and a retried payment are both normal.
func uniqueViolation(err error, constraint string) bool {
	var pgErr *pgconn.PgError
	if !errors.As(err, &pgErr) {
		return false
	}
	return pgErr.Code == "23505" && pgErr.ConstraintName == constraint
}

// DefaultLimit bounds a list a caller did not bound.
const DefaultLimit = 200

// MaxLimit is the ceiling, so a caller cannot ask for the whole tenant.
const MaxLimit = 1000

func capLimit(limit int32) int32 {
	switch {
	case limit <= 0:
		return DefaultLimit
	case limit > MaxLimit:
		return MaxLimit
	}
	return limit
}
