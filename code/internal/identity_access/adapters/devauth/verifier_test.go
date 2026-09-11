package devauth_test

import (
	"context"
	"errors"
	"slices"
	"testing"

	"github.com/ppusapati/health/code/internal/identity_access/adapters/devauth"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

func enabled(t *testing.T) *devauth.Verifier {
	t.Helper()
	v, err := devauth.New(true)
	if err != nil {
		t.Fatalf("New: %v", err)
	}
	return v
}

// The verifier must be impossible to obtain by accident.
func TestDisabledByDefault(t *testing.T) {
	if _, err := devauth.New(false); !errors.Is(err, devauth.ErrDisabled) {
		t.Fatalf("want ErrDisabled, got %v", err)
	}
}

func TestVerifyResolvesRolesToPermissions(t *testing.T) {
	s, err := enabled(t).Verify(context.Background(), "tenant-a:user-1:tenant_admin")
	if err != nil {
		t.Fatalf("Verify: %v", err)
	}
	if s.TenantID != "tenant-a" || s.SubjectID != "user-1" {
		t.Fatalf("session = %+v", s)
	}
	if !slices.Contains(s.Permissions, "organization.facility.create") {
		t.Fatalf("permissions = %v", s.Permissions)
	}
}

// A token names roles; it cannot name permissions. Otherwise a forged token
// would be a direct grant rather than a claim the catalogue interprets.
func TestUnknownRoleIsRejectedNotIgnored(t *testing.T) {
	_, err := enabled(t).Verify(context.Background(), "tenant-a:user-1:superuser")
	e, ok := rpcerr.As(err)
	if !ok || e.Category != rpcerr.CategoryUnauthenticated {
		t.Fatalf("want unauthenticated, got %v", err)
	}
}

func TestMalformedTokensRejected(t *testing.T) {
	for _, token := range []string{"", "tenant-a", "tenant-a:user-1", ":user-1:tenant_admin", "tenant-a::tenant_admin", "tenant-a:user-1:"} {
		t.Run(token, func(t *testing.T) {
			if _, err := enabled(t).Verify(context.Background(), token); err == nil {
				t.Fatalf("token %q accepted", token)
			}
		})
	}
}

// Denial messages must not tell an attacker which half of the credential was
// wrong.
func TestDenialMessagesAreUniform(t *testing.T) {
	v := enabled(t)
	var messages []string
	for _, token := range []string{"bad", "tenant-a:user-1:superuser", "tenant-a:user-1:"} {
		_, err := v.Verify(context.Background(), token)
		e, ok := rpcerr.As(err)
		if !ok {
			t.Fatalf("token %q: unexpected error %v", token, err)
		}
		messages = append(messages, e.Message)
	}
	for _, m := range messages {
		if m != "invalid credentials" {
			t.Fatalf("leaky denial message %q", m)
		}
	}
}
