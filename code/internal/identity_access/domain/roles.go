// Package domain holds the identity & access context's authorization model.
//
// Roles map to permissions over bounded-context actions, not to menus
// (SRS-IAM-003). The catalogue lives in code for Wave 0 and moves to
// tenant-configurable storage in Wave 7 alongside SRS-CFG; the shape of the
// lookup is deliberately the same either way.
package domain

import "sort"

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
