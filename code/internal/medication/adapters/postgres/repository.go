// Package postgres is the medication context's persistence adapter.
//
// It is the only package permitted to issue SQL against the medication schema
// (FIT-02). Every method takes an authctx.TenantScope, so the tenant predicate
// is always present and always comes from verified credentials (FIT-03).
//
// Note what is absent: the nursing schema. The eMAR reads prescriptions through
// this context's ports rather than by joining to these tables, so the two can be
// released independently and a change to how a taper is stored does not break a
// drug round.
package postgres

import (
	"context"
	"encoding/json"
	"math/big"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/ppusapati/health/code/internal/medication/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Repository implements the medication repository ports.
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
		return uuid.UUID{}, rpcerr.Internal("MED_NO_TENANT_SCOPE",
			"a repository call needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("MED_TENANT_ID_INVALID",
			"tenant_id must be a UUID").WithCause(err)
	}
	return parsed, nil
}

// notFound is the refusal a caller outside the tenant receives.
//
// NOT_FOUND rather than PERMISSION_DENIED: a probe must not be able to confirm
// that a prescription exists in somebody else's tenant.
func notFound() error {
	return rpcerr.NotFound("MED_NOT_FOUND", "no such prescription")
}

// conflict reports a guarded update that matched no row.
//
// Every guarded UPDATE here carries the record's own precondition as well as
// its version — a prescription must still be unverified, a reconciliation must
// still have nothing pending — so a zero row count means either that somebody
// else got there first or that the precondition no longer holds. The caller
// cannot tell them apart and does not need to: the remedy is the same.
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

// mustUUID parses an identifier this context generated.
func mustUUID(value string) (uuid.UUID, error) {
	parsed, err := uuid.Parse(value)
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("MED_ID_INVALID",
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

// interval renders a Go duration for an interval column.
func interval(d time.Duration) pgtype.Interval {
	if d <= 0 {
		return pgtype.Interval{}
	}
	return pgtype.Interval{Microseconds: int64(d / time.Microsecond), Valid: true}
}

func durationOrZero(value pgtype.Interval) time.Duration {
	if !value.Valid {
		return 0
	}
	// Months and days are never written by this adapter — every interval here
	// comes from a Go duration — so reading them back through microseconds is
	// exact rather than an approximation of a calendar.
	return time.Duration(value.Microseconds) * time.Microsecond
}

// numeric renders a dose for a numeric column.
//
// Through the decimal string rather than the float, for the reason the EMPI
// adapter gives: a binary float's nearest representation of a value with
// decimal places is not that value, and a dose that came back as 4.999999 would
// be a dose nobody prescribed.
func numeric(v float64) (pgtype.Numeric, error) {
	var n pgtype.Numeric
	if err := n.Scan(big.NewFloat(v).Text('f', 4)); err != nil {
		return pgtype.Numeric{}, rpcerr.Internal("MED_DOSE_INVALID",
			"could not store the dose").WithCause(err)
	}
	return n, nil
}

func optionalNumeric(v float64) (pgtype.Numeric, error) {
	if v == 0 {
		return pgtype.Numeric{}, nil
	}
	return numeric(v)
}

func numericOrZero(n pgtype.Numeric) (float64, error) {
	if !n.Valid {
		return 0, nil
	}
	value, err := n.Float64Value()
	if err != nil {
		return 0, rpcerr.Internal("MED_DOSE_INVALID",
			"a stored dose is not a number").WithCause(err)
	}
	return value.Float64, nil
}

func toJSON(v any) ([]byte, error) {
	raw, err := json.Marshal(v)
	if err != nil {
		return nil, rpcerr.Internal("MED_ENCODE_FAILED",
			"a medication record could not be encoded").WithCause(err)
	}
	return raw, nil
}

func fromJSON(raw []byte, into any) error {
	if len(raw) == 0 {
		return nil
	}
	if err := json.Unmarshal(raw, into); err != nil {
		return rpcerr.Internal("MED_DECODE_FAILED",
			"a stored medication record could not be decoded").WithCause(err)
	}
	return nil
}

func orEmptyInt32(in []int32) []int32 {
	if in == nil {
		return []int32{}
	}
	return in
}

func orEmptyString(in []string) []string {
	if in == nil {
		return []string{}
	}
	return in
}
