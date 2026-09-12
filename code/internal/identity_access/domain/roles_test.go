package domain_test

import (
	"slices"
	"testing"

	"github.com/ppusapati/health/code/internal/identity_access/domain"
)

// The union is exactly the two sets combined — no more, and no less.
//
// Asserted as a relation rather than as a literal list, so that granting a role
// a new permission is a decision made in the catalogue rather than a test to
// update in lockstep. What must not change is that the union invents nothing.
func TestPermissionsForUnionsRoles(t *testing.T) {
	admin := domain.PermissionsFor([]domain.Role{domain.RoleTenantAdmin})
	viewer := domain.PermissionsFor([]domain.Role{domain.RoleFacilityViewer})
	got := domain.PermissionsFor([]domain.Role{domain.RoleTenantAdmin, domain.RoleFacilityViewer})

	for _, p := range append(append([]string{}, admin...), viewer...) {
		if !slices.Contains(got, p) {
			t.Errorf("the union dropped %q", p)
		}
	}
	for _, p := range got {
		if !slices.Contains(admin, p) && !slices.Contains(viewer, p) {
			t.Errorf("the union invented %q, which neither role grants", p)
		}
	}
	if !slices.IsSorted(got) {
		t.Fatalf("PermissionsFor() = %v, which is not sorted; callers cache and compare it", got)
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
	once := domain.PermissionsFor([]domain.Role{domain.RoleTenantAdmin})
	twice := domain.PermissionsFor([]domain.Role{domain.RoleTenantAdmin, domain.RoleTenantAdmin})
	if !slices.Equal(once, twice) {
		t.Fatalf("the same role twice produced %v, want %v", twice, once)
	}
}

// Patient identity role separation (Wave 1, SRS-EMPI-005).
//
// Merging fuses two people's records into one chart. The person who created a
// duplicate at a busy registration desk is the last one who should resolve it
// unreviewed, so merge authority belongs to HIM and to nobody else.
//
// The Wave-1 backlog lists SRS-EMPI-005 under the `empi.read` permission, which
// would grant merging to every clerk who can search. Read as a transcription
// slip rather than as a requirement; this test is where that reading is
// recorded.
func TestOnlyHIMCanMergePatients(t *testing.T) {
	for _, r := range []domain.Role{
		domain.RoleRegistrationClerk, domain.RoleClinician,
		domain.RoleTenantAdmin, domain.RoleFacilityViewer, domain.RoleAuditor,
	} {
		if slices.Contains(domain.PermissionsFor([]domain.Role{r}), "empi.patient.merge") {
			t.Errorf("role %q grants empi.patient.merge", r)
		}
	}
	if !slices.Contains(domain.PermissionsFor([]domain.Role{domain.RoleHIMOfficer}), "empi.patient.merge") {
		t.Fatal("him_officer does not grant empi.patient.merge")
	}
}

// A clerk comparing duplicates sees a masked candidate: enough to confirm the
// phone number the patient just read out, not enough to use the duplicate
// screen as a staff directory (SRS-EMPI-003).
func TestARegistrationClerkCannotSeeUnmaskedRecords(t *testing.T) {
	clerk := domain.PermissionsFor([]domain.Role{domain.RoleRegistrationClerk})
	if slices.Contains(clerk, "empi.patient.read_restricted") {
		t.Fatal("registration_clerk grants empi.patient.read_restricted")
	}
	// And can still do the job.
	for _, required := range []string{"empi.patient.create", "empi.patient.read"} {
		if !slices.Contains(clerk, required) {
			t.Fatalf("registration_clerk cannot %s", required)
		}
	}
}

// Tuning how the register behaves and looking inside it are different jobs.
func TestConfiguringTheIndexDoesNotGrantReadingIt(t *testing.T) {
	admin := domain.PermissionsFor([]domain.Role{domain.RoleTenantAdmin})
	if !slices.Contains(admin, "empi.patient.configure") {
		t.Fatal("tenant_admin cannot configure the patient index")
	}
	if slices.Contains(admin, "empi.patient.read") {
		t.Fatal("tenant_admin can read patient records")
	}
}

// A clinician reads a chart to treat somebody, and administers nothing.
func TestAClinicianCannotMutateIdentity(t *testing.T) {
	for _, p := range domain.PermissionsFor([]domain.Role{domain.RoleClinician}) {
		switch p {
		case "empi.patient.create", "empi.patient.update",
			"empi.patient.manage", "empi.patient.merge":
			t.Errorf("clinician grants %q", p)
		}
	}
}
