package domain_test

import (
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

var now = time.Date(2026, 9, 11, 10, 0, 0, 0, time.UTC)

func newTenant(t *testing.T) *domain.Tenant {
	t.Helper()
	tn, err := domain.NewTenant("tenant-a", "Apollo Group", "in", "en-IN", "Asia/Kolkata", now)
	if err != nil {
		t.Fatalf("NewTenant: %v", err)
	}
	return tn
}

func TestNewTenantStartsProvisioning(t *testing.T) {
	tn := newTenant(t)
	if tn.Status != domain.TenantProvisioning {
		t.Fatalf("Status = %q, want provisioning", tn.Status)
	}
	if tn.Version != 1 {
		t.Fatalf("Version = %d, want 1", tn.Version)
	}
	// Jurisdiction is normalised so "in" and "IN" cannot become two tenants
	// with divergent country rules.
	if tn.LegalJurisdiction != "IN" {
		t.Fatalf("LegalJurisdiction = %q, want IN", tn.LegalJurisdiction)
	}
}

func TestNewTenantCollectsAllViolationsAtOnce(t *testing.T) {
	_, err := domain.NewTenant("", "", "india", "", "Mars/Olympus", now)
	e, ok := rpcerr.As(err)
	if !ok {
		t.Fatalf("want platform error, got %v", err)
	}
	if e.Category != rpcerr.CategoryInvalidArgument {
		t.Fatalf("Category = %q", e.Category)
	}
	// Returning every violation in one response saves the caller a round trip
	// per field.
	fields := map[string]bool{}
	for _, v := range e.Violations {
		fields[v.Field] = true
	}
	for _, want := range []string{"tenant_id", "display_name", "legal_jurisdiction", "default_locale", "time_zone"} {
		if !fields[want] {
			t.Errorf("missing violation for %q (got %v)", want, e.Violations)
		}
	}
}

func TestUnknownTimeZoneRejected(t *testing.T) {
	_, err := domain.NewTenant("tenant-a", "Apollo", "IN", "en-IN", "Not/AZone", now)
	e, ok := rpcerr.As(err)
	if !ok {
		t.Fatalf("want platform error, got %v", err)
	}
	if len(e.Violations) != 1 || e.Violations[0].Reason != "UNKNOWN_IANA_ZONE" {
		t.Fatalf("violations = %v", e.Violations)
	}
}

func TestTenantLifecycleHappyPath(t *testing.T) {
	tn := newTenant(t)
	for _, next := range []domain.TenantStatus{
		domain.TenantActive, domain.TenantSuspended, domain.TenantActive,
		domain.TenantOffboarding, domain.TenantTerminated,
	} {
		if err := tn.TransitionTo(next, now); err != nil {
			t.Fatalf("transition to %q: %v", next, err)
		}
	}
	if tn.Version != 6 {
		t.Fatalf("Version = %d, want 6 after five transitions", tn.Version)
	}
}

func TestTerminatedTenantIsTerminal(t *testing.T) {
	tn := newTenant(t)
	mustTransition(t, tn, domain.TenantActive)
	mustTransition(t, tn, domain.TenantOffboarding)
	mustTransition(t, tn, domain.TenantTerminated)

	err := tn.TransitionTo(domain.TenantActive, now)
	e, ok := rpcerr.As(err)
	if !ok || e.Category != rpcerr.CategoryFailedPrecondition {
		t.Fatalf("reviving a terminated tenant must fail precondition, got %v", err)
	}
}

// Skipping provisioning would let a half-built tenant accept clinical data.
func TestProvisioningCannotJumpToSuspended(t *testing.T) {
	tn := newTenant(t)
	if err := tn.TransitionTo(domain.TenantSuspended, now); err == nil {
		t.Fatal("provisioning -> suspended must be rejected")
	}
}

func TestWriteAndReadPostureByStatus(t *testing.T) {
	tn := newTenant(t)
	if tn.AcceptsWrites() {
		t.Fatal("provisioning tenant must not accept writes")
	}

	mustTransition(t, tn, domain.TenantActive)
	if !tn.AcceptsWrites() || !tn.IsAccessible() {
		t.Fatal("active tenant must be readable and writable")
	}

	mustTransition(t, tn, domain.TenantSuspended)
	if tn.AcceptsWrites() {
		t.Fatal("suspended tenant must refuse writes")
	}
	if !tn.IsAccessible() {
		t.Fatal("suspended tenant must remain readable (SRS-PLT-020)")
	}

	mustTransition(t, tn, domain.TenantOffboarding)
	mustTransition(t, tn, domain.TenantTerminated)
	if tn.IsAccessible() {
		t.Fatal("terminated tenant must not be accessible")
	}
}

func mustTransition(t *testing.T, tn *domain.Tenant, next domain.TenantStatus) {
	t.Helper()
	if err := tn.TransitionTo(next, now); err != nil {
		t.Fatalf("transition to %q: %v", next, err)
	}
}
