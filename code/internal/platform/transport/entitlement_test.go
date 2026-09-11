package transport_test

import (
	"context"
	"testing"

	"connectrpc.com/connect"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/transport"
)

func TestModuleForProcedure(t *testing.T) {
	cases := map[string]string{
		"/healthcare.organization.v1.OrganizationService/CreateFacility": "organization",
		"/healthcare.billing.v1.BillingService/CreateInvoice":            "billing",
		"/healthcare.platform_api.v1.HealthService/CheckLiveness":        "platform_api",
		// Anything that is not one of our procedures is exempt rather than
		// guessed at: a wrong guess would deny a call for a module that does
		// not exist.
		"/grpc.health.v1.Health/Check": "",
		"/not-a-procedure":             "",
		"":                             "",
	}
	for procedure, want := range cases {
		if got := transport.ModuleForProcedure(procedure); got != want {
			t.Errorf("ModuleForProcedure(%q) = %q, want %q", procedure, got, want)
		}
	}
}

// stubChecker answers from a fixed map.
type stubChecker struct {
	enabled map[string]bool
	calls   int
	err     error
}

func (s *stubChecker) ModuleEnabled(_ context.Context, _ authctx.Session, module string) (bool, string, error) {
	s.calls++
	if s.err != nil {
		return false, "", s.err
	}
	if s.enabled[module] {
		return true, "MODULE_ENTITLED", nil
	}
	return false, "MODULE_NOT_ENTITLED", nil
}

// interceptorHarness runs one interceptor over a request with a given
// procedure and session, returning whether the handler was reached.
func interceptorHarness(t *testing.T, checker transport.EntitlementChecker,
	procedure string, session *authctx.Session) (reached bool, err error) {
	t.Helper()

	interceptor := transport.NewEntitlementInterceptor(checker, nil)
	handler := interceptor(func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
		reached = true
		return connect.NewResponse(&struct{}{}), nil
	})

	ctx := context.Background()
	if session != nil {
		ctx = authctx.WithSession(ctx, *session)
	}

	req := connect.NewRequest(&struct{}{})
	_, err = handler(ctx, &spoofedRequest{AnyRequest: req, procedure: procedure})
	return reached, err
}

// spoofedRequest overrides the procedure, which connect.NewRequest leaves
// empty outside a real client.
type spoofedRequest struct {
	connect.AnyRequest
	procedure string
}

func (r *spoofedRequest) Spec() connect.Spec {
	return connect.Spec{Procedure: r.procedure, StreamType: connect.StreamTypeUnary}
}

func session(tenant string) *authctx.Session {
	return &authctx.Session{
		SubjectID: "user-1", TenantID: tenant, ActiveFacilityID: "fac-1",
		CorrelationID: "corr-1",
	}
}

// SRS-PLT-011's verification clause: a disabled module's RPC is unavailable
// even when the URL is called directly. The front-end is not involved here at
// all — this is the wire.
func TestDisabledModuleIsUnreachableByDirectCall(t *testing.T) {
	checker := &stubChecker{enabled: map[string]bool{"scheduling": true}}

	reached, err := interceptorHarness(t, checker,
		"/healthcare.billing.v1.BillingService/CreateInvoice", session("tenant-a"))
	if reached {
		t.Fatal("the handler ran for a module the tenant does not have")
	}
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("want PermissionDenied, got %v (%v)", connect.CodeOf(err), err)
	}
}

func TestEntitledModulePassesThrough(t *testing.T) {
	checker := &stubChecker{enabled: map[string]bool{"billing": true}}

	reached, err := interceptorHarness(t, checker,
		"/healthcare.billing.v1.BillingService/CreateInvoice", session("tenant-a"))
	if err != nil {
		t.Fatalf("an entitled call was refused: %v", err)
	}
	if !reached {
		t.Fatal("the handler did not run for an entitled module")
	}
}

// Gating these would be a lockout rather than a control: a tenant whose
// entitlement data is wrong could not sign in to fix it, and a liveness probe
// would fail for a commercial reason and take the pods down.
func TestHealthAndIdentityAreNeverGated(t *testing.T) {
	checker := &stubChecker{enabled: map[string]bool{}} // nothing entitled

	for _, procedure := range []string{
		"/healthcare.platform_api.v1.HealthService/CheckLiveness",
		"/healthcare.platform_api.v1.HealthService/CheckReadiness",
		"/healthcare.identity_access.v1.IdentityService/GetSessionContext",
		// The bootstrap paradox: granting a tenant their first entitlement is
		// itself an organization call, and a new tenant has no rows yet.
		"/healthcare.organization.v1.OrganizationService/CreateTenant",
	} {
		reached, err := interceptorHarness(t, checker, procedure, session("tenant-a"))
		if err != nil {
			t.Errorf("%s was gated: %v", procedure, err)
		}
		if !reached {
			t.Errorf("%s did not reach its handler", procedure)
		}
	}
	if checker.calls != 0 {
		t.Errorf("the checker was consulted %d times for exempt procedures", checker.calls)
	}
}

// "You are not signed in" and "your hospital did not buy this" are different
// problems with different fixes, so this interceptor leaves the first to the
// authentication interceptor rather than answering it.
func TestUnauthenticatedRequestsAreLeftToTheAuthInterceptor(t *testing.T) {
	checker := &stubChecker{enabled: map[string]bool{}}

	reached, err := interceptorHarness(t, checker,
		"/healthcare.billing.v1.BillingService/CreateInvoice", nil)
	if err != nil {
		t.Fatalf("an unauthenticated request was refused here: %v", err)
	}
	if !reached {
		t.Fatal("the chain was interrupted for an unauthenticated request")
	}
	if checker.calls != 0 {
		t.Error("the checker was consulted without a session")
	}
}

// A failing entitlement lookup must not fail open. The alternative — treating
// an error as "enabled" so the system keeps working — silently sells every
// module to every tenant during a database blip.
func TestALookupFailureDeniesRatherThanFailsOpen(t *testing.T) {
	checker := &stubChecker{err: errLookup}

	reached, err := interceptorHarness(t, checker,
		"/healthcare.billing.v1.BillingService/CreateInvoice", session("tenant-a"))
	if reached {
		t.Fatal("the handler ran despite an entitlement lookup failure")
	}
	if connect.CodeOf(err) != connect.CodeInternal {
		t.Fatalf("want Internal, got %v", connect.CodeOf(err))
	}
}

var errLookup = lookupError{}

type lookupError struct{}

func (lookupError) Error() string { return "entitlement store unavailable" }

// A custom resolver lets the composition root express a different convention
// without this package knowing about it.
func TestACustomResolverIsHonoured(t *testing.T) {
	checker := &stubChecker{enabled: map[string]bool{"custom": true}}
	interceptor := transport.NewEntitlementInterceptor(checker,
		func(string) string { return "custom" })

	var reached bool
	handler := interceptor(func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
		reached = true
		return connect.NewResponse(&struct{}{}), nil
	})

	ctx := authctx.WithSession(context.Background(), *session("tenant-a"))
	req := connect.NewRequest(&struct{}{})
	if _, err := handler(ctx, &spoofedRequest{AnyRequest: req, procedure: "/anything/at/all"}); err != nil {
		t.Fatalf("the custom resolver's module was refused: %v", err)
	}
	if !reached {
		t.Fatal("the handler did not run")
	}
}

// Guard against the interceptor being silently removed from the chain: if the
// helper below stops exercising a real interceptor, every test above passes
// vacuously.
func TestHarnessActuallyRunsAnInterceptor(t *testing.T) {
	checker := &stubChecker{enabled: map[string]bool{}}
	if _, err := interceptorHarness(t, checker,
		"/healthcare.billing.v1.BillingService/CreateInvoice", session("tenant-a")); err == nil {
		t.Fatal("the harness did not run the interceptor")
	}
	if checker.calls == 0 {
		t.Fatal("the checker was never consulted; the harness is not wired")
	}
}
