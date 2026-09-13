// Package postgres is the nursing context's persistence adapter.
//
// It is the only package permitted to issue SQL against the nursing schema
// (FIT-02). Every method takes an authctx.TenantScope, so the tenant predicate
// is always present and always comes from verified credentials (FIT-03).
package postgres

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/ppusapati/health/code/internal/nursing/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Repository implements the nursing repository ports.
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
		return uuid.UUID{}, rpcerr.Internal("NUR_NO_TENANT_SCOPE",
			"a repository call needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("NUR_TENANT_ID_INVALID",
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

func timeOrZero(value pgtype.Timestamptz) time.Time {
	if !value.Valid {
		return time.Time{}
	}
	return value.Time.UTC()
}

// mustUUID parses an identifier this context generated.
//
// Internal rather than caller-supplied, so a parse failure is a programming
// error and not something a caller can provoke.
func mustUUID(value string) (uuid.UUID, error) {
	parsed, err := uuid.Parse(value)
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("NUR_ID_INVALID",
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

// optionalUUID renders an empty string as SQL NULL.
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

// optionalFloat renders an absent measurement as SQL NULL.
//
// Absent rather than zero: a charted value of 0 and a value nobody charted are
// different facts, and a schema that cannot tell them apart reports the second
// as the first.
func optionalFloat(value float64, present bool) *float64 {
	if !present {
		return nil
	}
	out := value
	return &out
}

// notFound is the refusal a caller outside the tenant receives.
//
// NOT_FOUND rather than PERMISSION_DENIED, for the same reason the patient
// index does it: a probe must not be able to confirm that an identifier exists
// in somebody else's tenant.
func notFound() error {
	return rpcerr.NotFound("NUR_NOT_FOUND", "no such nursing record")
}

// conflict reports a guarded update that matched no row.
//
// Every guarded UPDATE here carries the record's own precondition as well as
// its version — a task must still be pending, a handover still unacknowledged —
// so a zero row count means either that somebody else got there first or that
// the precondition no longer holds. The caller cannot tell which apart, and
// does not need to: the remedy is the same.
func conflict() error { return ports.ErrVersionConflict }

func orEmpty(in []string) []string {
	if in == nil {
		return []string{}
	}
	return in
}

// toJSON encodes a structure for a jsonb column.
func toJSON(v any) ([]byte, error) {
	raw, err := json.Marshal(v)
	if err != nil {
		return nil, rpcerr.Internal("NUR_ENCODE_FAILED",
			"a nursing record could not be encoded").WithCause(err)
	}
	return raw, nil
}

// fromJSON decodes a jsonb column.
func fromJSON(raw []byte, into any) error {
	if len(raw) == 0 {
		return nil
	}
	if err := json.Unmarshal(raw, into); err != nil {
		return rpcerr.Internal("NUR_DECODE_FAILED",
			"a stored nursing record could not be decoded").WithCause(err)
	}
	return nil
}

// uniqueViolation reports a constraint this adapter is expected to hit.
//
// SRS-NUR-018's duplicate-administration guard is a unique index, so the
// refusal arrives as a PostgreSQL error rather than as a row count. Matching on
// the constraint name rather than the SQLSTATE alone keeps an unrelated
// uniqueness failure from being reported as a duplicate dose.
func uniqueViolation(err error, constraint string) bool {
	var pgErr *pgconn.PgError
	if !errors.As(err, &pgErr) {
		return false
	}
	return pgErr.Code == "23505" && pgErr.ConstraintName == constraint
}
