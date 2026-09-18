package postgres

import (
	"context"
	"errors"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/sterile/ports"
	theatreports "github.com/ppusapati/health/code/internal/theatre/ports"
)

// Cases adapts the theatre's own case repository (SRS-OT).
//
// An adapter rather than a direct call: the operation belongs to SRS-OT, and
// sterile services reads it without owning it. The link matters in one
// direction — a case trace runs from the patient back to the cycle — and it is
// the theatre that knows whether the case is real.
type Cases struct {
	schedule theatreports.ScheduleRepository
}

// NewCases constructs the adapter.
func NewCases(schedule theatreports.ScheduleRepository) Cases {
	return Cases{schedule: schedule}
}

var _ ports.Cases = Cases{}

// Exists reports a case the theatre knows.
//
// A not-found is false and no error, so the caller says so in its own words.
// Anything else propagates: treating a database failure as an unknown case
// would refuse a pack for an operation that is real, and send a technician to
// check a case number that is fine while the actual fault goes unreported.
func (c Cases) Exists(ctx context.Context, scope authctx.TenantScope,
	caseID string) (bool, error) {

	_, err := c.schedule.Case(ctx, scope, caseID)
	if err == nil {
		return true, nil
	}

	var refusal *rpcerr.Error
	if errors.As(err, &refusal) && refusal.Category == rpcerr.CategoryNotFound {
		return false, nil
	}
	return false, err
}
