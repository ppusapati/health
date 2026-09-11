// Package domain holds the identity & access context's authorization model.
//
// Roles map to permissions over bounded-context actions, not to menus
// (SRS-IAM-003). The catalogue lives in code for Wave 0 and moves to
// tenant-configurable storage in Wave 7 alongside SRS-CFG; the shape of the
// lookup is deliberately the same either way.
package domain

import (
	"sort"

	"github.com/ppusapati/health/code/internal/platform/authctx"
)

// Role is a named bundle of permissions.
type Role string

const (
	// RolePlatformOperator provisions tenants. Deliberately separate from any
	// tenant-level admin role: provisioning is cross-tenant authority and must
	// not be reachable by escalating inside a tenant.
	RolePlatformOperator Role = "platform_operator"

	// RoleTenantAdmin configures one tenant's organization master data.
	RoleTenantAdmin Role = "tenant_admin"

	// RoleFacilityViewer reads organization master data.
	RoleFacilityViewer Role = "facility_viewer"

	// RoleAuditor reads audit trails and cannot mutate clinical or financial
	// records (SRS-IAM-014).
	RoleAuditor Role = "auditor"
)

// rolePermissions is the catalogue. A role absent from this table grants
// nothing, which keeps an unknown or retired role fail-closed.
var rolePermissions = map[Role][]string{
	RolePlatformOperator: {
		"organization.tenant.create",
		"organization.tenant.read",
	},
	RoleTenantAdmin: {
		"organization.tenant.read",
		"organization.facility.create",
		"organization.facility.read",
	},
	RoleFacilityViewer: {
		"organization.facility.read",
	},
	RoleAuditor: {
		"platform.audit.read",
		"organization.tenant.read",
		"organization.facility.read",
	},
}

// PermissionsFor flattens the union of permissions for the given roles,
// deduplicated and sorted so the result is stable for caching and comparison.
func PermissionsFor(roles []Role) []string {
	set := make(map[string]struct{})
	for _, r := range roles {
		for _, p := range rolePermissions[r] {
			set[p] = struct{}{}
		}
	}

	out := make([]string, 0, len(set))
	for p := range set {
		out = append(out, p)
	}
	sort.Strings(out)
	return out
}

// KnownRole reports whether a role exists in the catalogue.
func KnownRole(r Role) bool {
	_, ok := rolePermissions[r]
	return ok
}

// rolePurposes is the purpose-of-use catalogue (SRS-IAM-004, SRS-SEC-009).
//
// Deliberately separate from permissions and deliberately *not* asserted by
// the identity provider. A customer's directory says who somebody is and what
// they do; what they may use patient data *for* is this system's policy, and
// letting a provider claim a purpose would let a customer's IdP grant research
// access by adding a group.
//
// A role absent here permits no purpose, so a caller holding it can assert
// none through the X-Purpose-Of-Use header. That is the fail-closed direction:
// an unstated purpose narrows nothing and reaches nothing that requires one.
var rolePurposes = map[Role][]authctx.PurposeOfUse{
	// Operational roles act on configuration, never on a clinical record, so
	// "operations" is the only purpose that makes sense for them. Granting
	// treatment here would let a platform operator read a chart with a purpose
	// that looks clinical in the audit trail.
	RolePlatformOperator: {authctx.PurposeOperations},
	RoleTenantAdmin:      {authctx.PurposeOperations},
	RoleFacilityViewer:   {authctx.PurposeOperations},
	// An auditor reviews the trail rather than delivering care. Support rather
	// than treatment, so their reads are distinguishable in the audit trail
	// from a clinician's.
	RoleAuditor: {authctx.PurposeOperations, authctx.PurposeSupport},
}

// PurposesFor returns the purposes-of-use the given roles may assert,
// deduplicated and in a stable order.
func PurposesFor(roles []Role) []authctx.PurposeOfUse {
	set := map[authctx.PurposeOfUse]bool{}
	for _, r := range roles {
		for _, p := range rolePurposes[r] {
			set[p] = true
		}
	}

	out := make([]authctx.PurposeOfUse, 0, len(set))
	for p := range set {
		out = append(out, p)
	}
	sort.Slice(out, func(i, j int) bool { return out[i] < out[j] })
	return out
}
