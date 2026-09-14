// Package postgres is the order context's persistence adapter.
//
// It is the only package permitted to issue SQL against the orders schema
// (FIT-02). Every method takes an authctx.TenantScope, so the tenant predicate
// is always present and always comes from verified credentials (FIT-03).
//
// Note what is absent: the performing contexts do not appear here. SRS-ORD-006
// requires routing "without database coupling", so a laboratory receives a
// dispatch on the bus and never reads this schema — which is what lets the two
// be released independently.
package postgres

import (
	"context"
	"encoding/json"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/ppusapati/health/code/internal/orders/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Repository implements the order repository ports.
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
		return uuid.UUID{}, rpcerr.Internal("ORD_NO_TENANT_SCOPE",
			"a repository call needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("ORD_TENANT_ID_INVALID",
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
func mustUUID(value string) (uuid.UUID, error) {
	parsed, err := uuid.Parse(value)
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("ORD_ID_INVALID",
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

// notFound is the refusal a caller outside the tenant receives.
//
// NOT_FOUND rather than PERMISSION_DENIED: a probe must not be able to confirm
// that an identifier exists in somebody else's tenant.
func notFound() error {
	return rpcerr.NotFound("ORD_NOT_FOUND", "no such order")
}

// conflict reports a guarded update that matched no row.
//
// Every guarded UPDATE here carries the record's own precondition as well as
// its version — an order must still be a draft, a cancellation must not already
// be pending — so a zero row count means either that somebody else got there
// first or that the precondition no longer holds. The caller cannot tell them
// apart and does not need to: the remedy is the same.
func conflict() error { return ports.ErrVersionConflict }

func toJSON(v any) ([]byte, error) {
	raw, err := json.Marshal(v)
	if err != nil {
		return nil, rpcerr.Internal("ORD_ENCODE_FAILED",
			"an order record could not be encoded").WithCause(err)
	}
	return raw, nil
}

func fromJSON(raw []byte, into any) error {
	if len(raw) == 0 {
		return nil
	}
	if err := json.Unmarshal(raw, into); err != nil {
		return rpcerr.Internal("ORD_DECODE_FAILED",
			"a stored order record could not be decoded").WithCause(err)
	}
	return nil
}

func orEmptyInt32(in []int32) []int32 {
	if in == nil {
		return []int32{}
	}
	return in
}

func orEmptyUUID(in []uuid.UUID) []uuid.UUID {
	if in == nil {
		return []uuid.UUID{}
	}
	return in
}
