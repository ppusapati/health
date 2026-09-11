package domain_test

import (
	"slices"
	"testing"

	"github.com/ppusapati/health/code/internal/identity_access/domain"
)

func TestPermissionsForUnionsRoles(t *testing.T) {
	got := domain.PermissionsFor([]domain.Role{domain.RoleTenantAdmin, domain.RoleFacilityViewer})
	want := []string{
		"organization.facility.create",
		"organization.facility.read",
		"organization.tenant.read",
	}
	if !slices.Equal(got, want) {
		t.Fatalf("PermissionsFor() = %v, want %v", got, want)
	}
}

// An unknown role must grant nothing rather than everything: a typo in a token
// should lock a user out, not let them in.
func TestUnknownRoleGrantsNothing(t *testing.T) {
	if got := domain.PermissionsFor([]domain.Role{"wizard"}); len(got) != 0 {
		t.Fatalf("unknown role granted %v", got)
	}
	if domain.KnownRole("wizard") {
		t.Fatal("KnownRole reported an unknown role as known")
	}
}

// Tenant provisioning is cross-tenant authority; no tenant-scoped role may
// reach it by accident.
func TestTenantCreateIsPlatformOperatorOnly(t *testing.T) {
	for _, r := range []domain.Role{domain.RoleTenantAdmin, domain.RoleFacilityViewer, domain.RoleAuditor} {
		if slices.Contains(domain.PermissionsFor([]domain.Role{r}), "organization.tenant.create") {
			t.Fatalf("role %q must not grant organization.tenant.create", r)
		}
	}
	if !slices.Contains(domain.PermissionsFor([]domain.Role{domain.RolePlatformOperator}), "organization.tenant.create") {
		t.Fatal("platform_operator must grant organization.tenant.create")
	}
}

// SRS-IAM-014: the auditor role is read-only.
func TestAuditorHasNoMutatingPermission(t *testing.T) {
	for _, p := range domain.PermissionsFor([]domain.Role{domain.RoleAuditor}) {
		if !slices.Contains([]string{"platform.audit.read", "organization.tenant.read", "organization.facility.read"}, p) {
			t.Fatalf("auditor unexpectedly granted %q", p)
		}
	}
}

func TestPermissionsAreDeduplicated(t *testing.T) {
	got := domain.PermissionsFor([]domain.Role{domain.RoleTenantAdmin, domain.RoleTenantAdmin})
	if len(got) != 3 {
		t.Fatalf("duplicate roles produced %v", got)
	}
}
