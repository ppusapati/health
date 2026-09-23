// Package crosscontext implements the laundry seams onto the contexts that
// own the facts (SRS-LND-001, SRS-LND-002).
//
// An adapter rather than a table. Which wards the hospital has belongs to the
// organisation context, and a copy here would drift the first time a ward was
// renamed or closed — leaving a par level and a balance that add up perfectly
// for somewhere nobody can go and look.
//
// Read-only, and that absence is the point: the laundry cannot create a ward.
package crosscontext

import (
	"context"
	"errors"

	"github.com/ppusapati/health/code/internal/laundry/ports"
	orgports "github.com/ppusapati/health/code/internal/organization/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Units adapts the organisation context's org-unit master (SRS-LND-001,
// SRS-LND-002).
type Units struct {
	repo orgports.OrgUnitRepository
}

// NewUnits constructs the adapter.
func NewUnits(repo orgports.OrgUnitRepository) Units {
	return Units{repo: repo}
}

var _ ports.Units = Units{}

// Exists implements ports.Units.
//
// Existence and nothing else. The laundry needs to know the ward is real, not
// what is on it.
//
// Only a NOT_FOUND is an answer. Everything else — a dropped connection, a
// permission refusal, a timeout — is returned as the failure it is, because
// the wave specification is explicit that a dependency outage must not be
// reinterpreted as a valid negative result. Swallowing one would turn "the
// organisation service is down" into "there is no such ward", and a porter
// with a trolley of infected linen would be told the ward they just came from
// does not exist.
func (u Units) Exists(ctx context.Context, scope authctx.TenantScope,
	unitID string) (bool, error) {

	if u.repo == nil {
		return false, nil
	}
	if _, err := u.repo.GetOrgUnit(ctx, scope, unitID); err != nil {
		var refused *rpcerr.Error
		if errors.As(err, &refused) &&
			refused.Category == rpcerr.CategoryNotFound {
			return false, nil
		}
		return false, err
	}
	return true, nil
}
