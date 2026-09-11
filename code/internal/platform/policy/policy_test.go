package policy_test

import (
	"testing"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/policy"
)

func session() authctx.Session {
	return authctx.Session{
		SubjectID:        "user-1",
		TenantID:         "tenant-a",
		ActiveFacilityID: "facility-1",
		Permissions:      []string{"organization.facility.create", "organization.facility.read"},
		Purpose:          authctx.PurposeOperations,
	}
}

func TestDenyByDefaultWithNoPermissions(t *testing.T) {
	d := policy.Evaluate(authctx.Session{TenantID: "tenant-a"}, policy.Request{
		Permission: "organization.facility.create",
		TenantMode: policy.TenantModeReadWrite,
	})
	if d.Allowed {
		t.Fatal("empty permission set must be denied")
	}
	if d.Reason != policy.ReasonPermissionNotGranted {
		t.Fatalf("Reason = %q", d.Reason)
	}
}

func TestAllowsGrantedPermission(t *testing.T) {
	d := policy.Evaluate(session(), policy.Request{
		Permission: "organization.facility.create",
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !d.Allowed {
		t.Fatalf("expected allow, got %q", d.Reason)
	}
}

// The central multi-tenancy guarantee: holding the permission is not enough if
// the resource belongs to another tenant.
func TestCrossTenantResourceIsDeniedDespitePermission(t *testing.T) {
	d := policy.Evaluate(session(), policy.Request{
		Permission:       "organization.facility.read",
		ResourceTenantID: "tenant-b",
		TenantMode:       policy.TenantModeReadWrite,
	})
	if d.Allowed {
		t.Fatal("cross-tenant access must be denied")
	}
	if d.Reason != policy.ReasonCrossTenantDenied {
		t.Fatalf("Reason = %q, want %q", d.Reason, policy.ReasonCrossTenantDenied)
	}
}

func TestSuspendedTenantRefusesWritesButAllowsReads(t *testing.T) {
	write := policy.Evaluate(session(), policy.Request{
		Permission: "organization.facility.create",
		Mutating:   true,
		TenantMode: policy.TenantModeReadOnly,
	})
	if write.Allowed || write.Reason != policy.ReasonTenantReadOnly {
		t.Fatalf("write on read-only tenant: allowed=%v reason=%q", write.Allowed, write.Reason)
	}

	read := policy.Evaluate(session(), policy.Request{
		Permission: "organization.facility.read",
		TenantMode: policy.TenantModeReadOnly,
	})
	if !read.Allowed {
		t.Fatalf("read on read-only tenant denied: %q", read.Reason)
	}
}

func TestTerminatedTenantDeniesEverything(t *testing.T) {
	d := policy.Evaluate(session(), policy.Request{
		Permission: "organization.facility.read",
		TenantMode: policy.TenantModeNoAccess,
	})
	if d.Allowed || d.Reason != policy.ReasonTenantNoAccess {
		t.Fatalf("allowed=%v reason=%q", d.Allowed, d.Reason)
	}
}

func TestFacilityScopeMismatchDenied(t *testing.T) {
	d := policy.Evaluate(session(), policy.Request{
		Permission:           "organization.facility.read",
		ResourceFacilityID:   "facility-99",
		RequireFacilityMatch: true,
		TenantMode:           policy.TenantModeReadWrite,
	})
	if d.Allowed || d.Reason != policy.ReasonFacilityScopeDenied {
		t.Fatalf("allowed=%v reason=%q", d.Allowed, d.Reason)
	}
}

func TestPurposeOfUseMismatchDenied(t *testing.T) {
	d := policy.Evaluate(session(), policy.Request{
		Permission:      "organization.facility.read",
		RequiredPurpose: authctx.PurposeTreatment,
		TenantMode:      policy.TenantModeReadWrite,
	})
	if d.Allowed || d.Reason != policy.ReasonPurposeMismatch {
		t.Fatalf("allowed=%v reason=%q", d.Allowed, d.Reason)
	}
}

// "Deny by default" and "skip the check when the attribute is empty" are in
// tension. RequireResourceTenant resolves it: a caller that declares the action
// addresses a resource but supplies no owning tenant is denied, not waved past.
func TestMissingResourceTenantIsDeniedWhenRequired(t *testing.T) {
	d := policy.Evaluate(session(), policy.Request{
		Permission:            "organization.facility.read",
		RequireResourceTenant: true,
		ResourceTenantID:      "",
		TenantMode:            policy.TenantModeReadWrite,
	})
	if d.Allowed {
		t.Fatal("an action declaring a resource, with no owning tenant, was allowed")
	}
	if d.Reason != policy.ReasonResourceScopeMissing {
		t.Fatalf("Reason = %q", d.Reason)
	}
}

// A create genuinely has no resource yet, so an empty tenant stays legitimate
// when the caller does not claim otherwise.
func TestEmptyResourceTenantStillAllowedForCreates(t *testing.T) {
	d := policy.Evaluate(session(), policy.Request{
		Permission: "organization.facility.create",
		Mutating:   true,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !d.Allowed {
		t.Fatalf("create denied: %q", d.Reason)
	}
}

// Requiring a facility match with no facility named is the same trap.
func TestMissingFacilityIsDeniedWhenMatchRequired(t *testing.T) {
	d := policy.Evaluate(session(), policy.Request{
		Permission:           "organization.facility.read",
		RequireFacilityMatch: true,
		ResourceFacilityID:   "",
		TenantMode:           policy.TenantModeReadWrite,
	})
	if d.Allowed || d.Reason != policy.ReasonFacilityScopeMissing {
		t.Fatalf("allowed=%v reason=%q", d.Allowed, d.Reason)
	}
}
