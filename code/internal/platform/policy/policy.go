// Package policy is the platform's RBAC + ABAC decision point.
//
// Authorization is evaluated inside the application layer, never inferred from
// menu visibility (SRS-IAM-003, Wave-0 spec §8). Every rule here is deny-by-
// default: Evaluate starts from "denied" and only an explicit grant flips it.
//
// Trace: SRS-IAM-003, SRS-IAM-004, SRS-IAM-013, SRS-PLT-020, SRS-SEC-011.
package policy

import "github.com/ppusapati/health/code/internal/platform/authctx"

// Effect describes the tenant's ability to accept writes. A suspended tenant is
// readable but not writable (SRS-PLT-020).
type TenantMode string

const (
	TenantModeReadWrite TenantMode = "read_write"
	TenantModeReadOnly  TenantMode = "read_only"
	TenantModeNoAccess  TenantMode = "no_access"
)

// Request is the set of attributes the decision is made over.
type Request struct {
	// Permission is the bounded-context action, e.g.
	// "organization.facility.create".
	Permission string

	// Mutating marks state-changing actions, which a read-only tenant refuses.
	Mutating bool

	// ResourceTenantID is the tenant that owns the target resource. Empty means
	// the action does not address an existing resource — a create, say.
	//
	// Because empty is a legitimate value, a caller that forgets to populate it
	// for an action that DOES address a resource would skip the cross-tenant
	// check. Set RequireResourceTenant to make that a denial instead.
	ResourceTenantID string

	// RequireResourceTenant asserts that this action addresses an existing
	// resource, so an empty ResourceTenantID is a programming error rather than
	// a legitimate "no resource yet".
	RequireResourceTenant bool

	// ResourceFacilityID, with RequireFacilityMatch, constrains the action to
	// the caller's active facility.
	ResourceFacilityID   string
	RequireFacilityMatch bool

	// RequiredPurpose, when set, demands a matching purpose-of-use.
	RequiredPurpose authctx.PurposeOfUse

	// TenantMode is the current lifecycle posture of the caller's tenant.
	TenantMode TenantMode
}

// Decision is the outcome. Reason is a stable code, never prose.
type Decision struct {
	Allowed bool
	Reason  string
}

// Stable denial reason codes.
const (
	ReasonAllowed              = "ALLOWED"
	ReasonPermissionNotGranted = "PERMISSION_NOT_GRANTED"
	ReasonCrossTenantDenied    = "CROSS_TENANT_DENIED"
	ReasonFacilityScopeDenied  = "FACILITY_SCOPE_DENIED"
	// ReasonResourceScopeMissing means the caller declared that this action
	// addresses a resource but supplied no owning tenant. Denying is the only
	// safe reading: the alternative is skipping the cross-tenant check.
	ReasonResourceScopeMissing = "RESOURCE_SCOPE_MISSING"
	// ReasonFacilityScopeMissing is the facility equivalent.
	ReasonFacilityScopeMissing = "FACILITY_SCOPE_MISSING"
	ReasonPurposeMismatch      = "PURPOSE_OF_USE_MISMATCH"
	ReasonTenantReadOnly       = "TENANT_READ_ONLY"
	ReasonTenantNoAccess       = "TENANT_NO_ACCESS"
)

func deny(reason string) Decision { return Decision{Allowed: false, Reason: reason} }

// Evaluate applies the rules in escalating order of specificity. The order
// matters for diagnosis: a caller with no permission at all should learn that
// before it learns anything about the resource's existence.
func Evaluate(s authctx.Session, r Request) Decision {
	switch r.TenantMode {
	case TenantModeNoAccess:
		return deny(ReasonTenantNoAccess)
	case TenantModeReadOnly:
		if r.Mutating {
			return deny(ReasonTenantReadOnly)
		}
	}

	if !s.HasPermission(r.Permission) {
		return deny(ReasonPermissionNotGranted)
	}

	// SRS-IAM-013: the resource's tenant must equal the authenticated tenant.
	// A request body can never widen this, because ResourceTenantID is read
	// from persisted state, not from the wire.
	if r.RequireResourceTenant && r.ResourceTenantID == "" {
		return deny(ReasonResourceScopeMissing)
	}
	if r.ResourceTenantID != "" && r.ResourceTenantID != s.TenantID {
		return deny(ReasonCrossTenantDenied)
	}

	if r.RequireFacilityMatch {
		if r.ResourceFacilityID == "" {
			return deny(ReasonFacilityScopeMissing)
		}
		if r.ResourceFacilityID != s.ActiveFacilityID {
			return deny(ReasonFacilityScopeDenied)
		}
	}

	if r.RequiredPurpose != authctx.PurposeUnspecified && s.Purpose != r.RequiredPurpose {
		return deny(ReasonPurposeMismatch)
	}

	return Decision{Allowed: true, Reason: ReasonAllowed}
}
