// Package crosscontext implements the facilities context's reads of other
// contexts (SRS-FAC-001, SRS-FAC-004).
//
// An adapter rather than a table. Which departments this hospital has belongs
// to the organization context, and a copy here would drift the first time
// somebody renamed a ward.
//
// Read-only, and narrow on purpose: facilities needs to know that a
// department exists, and nothing else about it. The absence is the point —
// estates cannot create a department by mistyping one into a work order.
package crosscontext

import (
	"context"
	"errors"

	"github.com/ppusapati/health/code/internal/facilities/ports"
	orgports "github.com/ppusapati/health/code/internal/organization/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// absentOrFailed classifies a lookup failure.
//
// Only a NOT_FOUND is an answer. Everything else — a dropped connection, a
// permission refusal, a timeout — is returned as the failure it is. A
// directory that is down must not read as a directory that says no: the
// first would stop an asset being registered with a message about the
// directory, and the second would stop it with a message blaming the
// department, which is the wrong thing for somebody to spend an hour on.
func absentOrFailed(err error) error {
	var refused *rpcerr.Error
	if errors.As(err, &refused) &&
		refused.Category == rpcerr.CategoryNotFound {
		return nil
	}
	return err
}

// OrgUnits adapts the organization directory (SRS-FAC-001, SRS-FAC-004).
type OrgUnits struct {
	repo orgports.FacilityRepository
}

// NewOrgUnits constructs the adapter.
func NewOrgUnits(repo orgports.FacilityRepository) OrgUnits {
	return OrgUnits{repo: repo}
}

var _ ports.OrgUnits = OrgUnits{}

// Exists implements ports.OrgUnits.
//
// Existence and nothing else. What a department does, who runs it and how
// many beds it has are the organization directory's business; an asset
// register needs to know only that the place it names is a real one.
func (o OrgUnits) Exists(ctx context.Context, scope authctx.TenantScope,
	orgUnitID string) (bool, error) {

	if o.repo == nil {
		return false, nil
	}
	found, err := o.repo.GetByID(ctx, scope, orgUnitID)
	if err != nil {
		return false, absentOrFailed(err)
	}
	return found != nil, nil
}
