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

	// RoleRegistrationClerk registers patients and corrects their details at a
	// front desk (Wave-1 actor "Registration").
	RoleRegistrationClerk Role = "registration_clerk"

	// RoleHIMOfficer is health information management: the people who resolve
	// duplicate identities. The Wave-1 backlog names them "Authorized HIM", and
	// merge authority is theirs alone.
	RoleHIMOfficer Role = "him_officer"

	// RoleClinician reads patient identity in the course of care.
	RoleClinician Role = "clinician"
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
		// Configuring the demographic minimum set and the duplicate-matching
		// thresholds is tenant administration. Note what is absent: no
		// empi.patient.read. Tuning how the register behaves and looking
		// inside it are different jobs, and bundling them would put every
		// tenant admin in the patient index.
		"empi.patient.configure",
	},
	RoleFacilityViewer: {
		"organization.facility.read",
	},
	RoleAuditor: {
		"platform.audit.read",
		"organization.tenant.read",
		"organization.facility.read",
	},

	// A clerk registers, searches and corrects. Deliberately no merge: merging
	// fuses two people's records, and the person who created a duplicate at a
	// busy desk is the last one who should resolve it unreviewed.
	//
	// Also no read_restricted. A clerk comparing duplicates sees a masked
	// candidate — enough to confirm the phone number the patient just read out,
	// not enough to use the screen as a directory (SRS-EMPI-003).
	RoleRegistrationClerk: {
		"empi.patient.create",
		"empi.patient.read",
		"empi.patient.update",
		"empi.patient.manage",
		"organization.facility.read",
	},

	// HIM resolves identities. They hold merge and unrestricted read, because
	// deciding whether two records are one person needs the unmasked detail
	// that a clerk is deliberately denied.
	RoleHIMOfficer: {
		"empi.patient.read",
		"empi.patient.read_restricted",
		"empi.patient.update",
		"empi.patient.manage",
		"empi.patient.merge",
		"organization.facility.read",
	},

	// A clinician reads identity to confirm they have the right patient in
	// front of them, unmasked, and does not administer it.
	RoleClinician: {
		"empi.patient.read",
		"empi.patient.read_restricted",
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

	// Registration and HIM act on the identity record in the course of
	// delivering and administering care. Treatment because a clerk registering
	// a patient is part of that patient receiving care; payment because the
	// same desk resolves the identity an invoice is raised against.
	RoleRegistrationClerk: {authctx.PurposeTreatment, authctx.PurposePayment},
	RoleHIMOfficer:        {authctx.PurposeTreatment, authctx.PurposeOperations},
	// A clinician reads a chart to treat somebody. Nothing else.
	RoleClinician: {authctx.PurposeTreatment},
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
