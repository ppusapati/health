package authctx_test

import (
	"context"
	"errors"
	"testing"

	"github.com/ppusapati/health/code/internal/platform/authctx"
)

func TestFromContextRejectsMissingSession(t *testing.T) {
	if _, err := authctx.FromContext(context.Background()); !errors.Is(err, authctx.ErrNoSession) {
		t.Fatalf("want ErrNoSession, got %v", err)
	}
}

// A session missing a tenant must not satisfy FromContext: a half-built session
// would otherwise mint a zero TenantScope and silently widen a query.
func TestFromContextRejectsSessionWithoutTenant(t *testing.T) {
	ctx := authctx.WithSession(context.Background(), authctx.Session{SubjectID: "user-1"})
	if _, err := authctx.FromContext(ctx); !errors.Is(err, authctx.ErrNoSession) {
		t.Fatalf("want ErrNoSession for tenantless session, got %v", err)
	}
}

func TestTenantScopeCarriesVerifiedTenant(t *testing.T) {
	s := authctx.NewSession(authctx.Session{SubjectID: "user-1", TenantID: "tenant-a"})
	scope := s.TenantScope()
	if scope.IsZero() {
		t.Fatal("scope unexpectedly zero")
	}
	if got := scope.TenantID(); got != "tenant-a" {
		t.Fatalf("TenantID() = %q, want tenant-a", got)
	}
}

func TestZeroTenantScopeIsUnusable(t *testing.T) {
	var scope authctx.TenantScope
	if !scope.IsZero() {
		t.Fatal("zero value must report IsZero")
	}
}

func TestHasPermission(t *testing.T) {
	s := authctx.Session{Permissions: []string{"organization.facility.create"}}
	if !s.HasPermission("organization.facility.create") {
		t.Fatal("granted permission not found")
	}
	if s.HasPermission("organization.tenant.create") {
		t.Fatal("ungranted permission reported as granted")
	}
}
