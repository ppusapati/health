// Package postgres is the facilities persistence adapter.
//
// It is the only package permitted to issue SQL against the facilities schema
// (FIT-02). Every method takes an authctx.TenantScope, so the tenant
// predicate is always present and always comes from verified credentials
// (FIT-03).
//
// There is no DELETE in this package, and there is no UPDATE against
// facilities.meter_reading or facilities.runtime_reading. A meter reading is
// what an instrument said, a runtime reading is how long a machine had run,
// and both are the evidence behind a decision — a service interval, a
// consumption figure, a bill somebody disputed. Evidence that can be edited
// after the fact is not evidence.
package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/jackc/pgx/v5/pgtype"

	"github.com/ppusapati/health/code/internal/facilities/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Repository implements the facilities repository ports.
type Repository struct {
	tx *pgtx.Manager
}

// New constructs a Repository.
func New(tx *pgtx.Manager) *Repository { return &Repository{tx: tx} }

func (r *Repository) queries(ctx context.Context) *sqlcgen.Queries {
	return sqlcgen.New(r.tx.Querier(ctx))
}

func scopeTenantID(scope authctx.TenantScope) (uuid.UUID, error) {
	if scope.IsZero() {
		return uuid.UUID{}, rpcerr.Internal("FAC_NO_TENANT_SCOPE",
			"a repository call needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return uuid.UUID{}, rpcerr.Internal("FAC_TENANT_ID_INVALID",
			"tenant_id must be a UUID").WithCause(err)
	}
	return parsed, nil
}

// notFound conceals a malformed identifier as an absent one, so a probe
// cannot confirm that an id exists in another tenant by the shape of the
// refusal.
func notFound() error {
	return rpcerr.NotFound("FAC_NOT_FOUND", "no such record")
}

func stamp(t time.Time) pgtype.Timestamptz {
	if t.IsZero() {
		return pgtype.Timestamptz{}
	}
	return pgtype.Timestamptz{Time: t.UTC(), Valid: true}
}

// stampText renders an optional timestamp for a NULLIF(@x::text, ”) column.
// An empty string is the absent case; anything else is parsed by PostgreSQL.
func stampText(t time.Time) string {
	if t.IsZero() {
		return ""
	}
	return t.UTC().Format(time.RFC3339Nano)
}

func timeOf(t pgtype.Timestamptz) time.Time {
	if !t.Valid {
		return time.Time{}
	}
	return t.Time.UTC()
}

func uuidString(id pgtype.UUID) string {
	if !id.Valid {
		return ""
	}
	return uuid.UUID(id.Bytes).String()
}

// epoch and farFuture bound an unfiltered range. A zero time.Time renders as
// a NULL timestamp and excludes every row, which reads as "this hospital has
// no plant" — an answer an estates screen must never give by accident.
var (
	epoch     = time.Date(1970, 1, 1, 0, 0, 0, 0, time.UTC)
	farFuture = time.Date(2200, 1, 1, 0, 0, 0, 0, time.UTC)
)

func window(from, to time.Time) (time.Time, time.Time) {
	if from.IsZero() {
		from = epoch
	}
	if to.IsZero() {
		to = farFuture
	}
	return from, to
}

func rows(limit int32) int32 {
	if limit <= 0 {
		return 200
	}
	return limit
}

// texts coalesces a nil slice into an empty array. A nil Go slice is written
// as NULL, which a NOT NULL column refuses and cardinality(NULL) answers NULL
// for, so the constraint that a visit names who came would never fire.
func texts(in []string) []string {
	if in == nil {
		return []string{}
	}
	return in
}

func conflict(err error) error {
	if errors.Is(err, pgx.ErrNoRows) {
		return ports.ErrVersionConflict
	}
	return err
}

func isNoRows(err error) bool { return errors.Is(err, pgx.ErrNoRows) }

// uniqueViolation turns PostgreSQL's 23505 into something a caller can act
// on, named by the index that fired. Without this an estates clerk who typed
// a tag that already exists gets an internal error, and the one thing they
// needed to know — that the tag is taken — is in a log they cannot see.
func uniqueViolation(err error) error {
	var pgErr *pgconn.PgError
	if !errors.As(err, &pgErr) || pgErr.Code != "23505" {
		return err
	}
	switch pgErr.ConstraintName {
	case "asset_tag_idx":
		return rpcerr.FailedPrecondition("FAC_TAG_IN_USE",
			"another asset already carries that tag")
	case "work_order_number_idx":
		return rpcerr.FailedPrecondition("FAC_NUMBER_IN_USE",
			"that work order number is already used")
	case "alarm_gateway_event_idx":
		// The replay case. Not a failure: the gateway resent something
		// it had already delivered, and the right answer is that the
		// alarm already exists.
		return rpcerr.FailedPrecondition("FAC_ALARM_ALREADY_SEEN",
			"this gateway event has already been recorded")
	case "meter_code_idx":
		return rpcerr.FailedPrecondition("FAC_METER_CODE_IN_USE",
			"another meter already carries that code")
	case "outage_reference_idx":
		return rpcerr.FailedPrecondition("FAC_OUTAGE_REF_IN_USE",
			"that shutdown reference is already used")
	case "task_one_open_per_schedule_idx":
		return rpcerr.FailedPrecondition("FAC_TASK_ALREADY_PLANNED",
			"this schedule already has an occurrence outstanding")
	case "outage_area_one_live_shutdown_idx":
		return rpcerr.FailedPrecondition("FAC_AREA_ALREADY_SHUT_DOWN",
			"another shutdown of this system is already in effect over that department")
	}
	return err
}

func parseID(id string) (uuid.UUID, error) {
	parsed, err := uuid.Parse(id)
	if err != nil {
		return uuid.UUID{}, notFound()
	}
	return parsed, nil
}
