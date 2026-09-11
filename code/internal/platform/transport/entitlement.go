package transport

import (
	"context"
	"strings"

	"connectrpc.com/connect"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Module entitlement enforcement (SRS-PLT-011).
//
// The verification clause is the whole design: "disabled module routes/RPCs
// are unavailable even if the URL is called directly". That rules out the
// usual implementation, which is hiding the menu item and trusting the
// front-end — a disabled module then remains fully callable by anyone who
// knows the procedure name, which for a generated client is everyone.
//
// So the check runs here, in an interceptor, before any handler. A module that
// is off is off at the wire.
//
// It must run after authentication: the decision depends on the caller's
// tenant and active facility, which do not exist until a credential has been
// verified. An unauthenticated request is left alone and refused by the
// authentication interceptor instead, so the two failures stay distinguishable
// — "you are not signed in" and "your hospital did not buy this" are different
// problems with different fixes.

// EntitlementChecker answers whether a module is available to a caller.
//
// Deliberately not the organization service itself: the platform transport
// package cannot depend on a bounded context without inverting the dependency
// direction the fitness tests hold (FIT-01). The composition root supplies an
// implementation.
type EntitlementChecker interface {
	// ModuleEnabled reports whether a module is available, and a stable reason
	// code when it is not.
	ModuleEnabled(ctx context.Context, session authctx.Session, module string) (bool, string, error)
}

// ModuleResolver maps an RPC procedure to the module that owns it.
//
// A function rather than a map so the composition root can express whatever
// convention the programme settles on, and so a procedure with no module —
// health checks, the identity service itself — can return "" and be exempt.
type ModuleResolver func(procedure string) string

// ModuleForProcedure derives a module name from a Connect procedure path.
//
// Connect procedures look like "/healthcare.organization.v1.OrganizationService/CreateFacility".
// The proto package's second segment is the bounded context, which is also the
// module: "organization", "scheduling", "billing". Deriving rather than
// configuring means a new RPC is covered the moment it exists — the opposite
// of a registry somebody has to remember to update, which is how an
// unprotected endpoint ships.
func ModuleForProcedure(procedure string) string {
	trimmed := strings.TrimPrefix(procedure, "/")
	service, _, found := strings.Cut(trimmed, "/")
	if !found {
		return ""
	}
	parts := strings.Split(service, ".")
	// healthcare.<module>.<version>.<Service>
	if len(parts) < 4 || parts[0] != "healthcare" {
		return ""
	}
	return parts[1]
}

// alwaysAvailableModules are never gated.
//
// Gating these would be a lockout rather than a control: a tenant whose
// entitlement data is wrong could not sign in to fix it, and a liveness probe
// would fail for a commercial reason, taking the pods down.
//
// organization is on the list for a sharper reason than the others. It is the
// module that configures entitlements, so gating it is a bootstrap paradox:
// granting a tenant their first entitlement is itself an organization call,
// and a newly provisioned tenant has no rows yet. It is also not a sellable
// module — every tenant needs tenants, facilities and org units to exist at
// all. Entitlements gate the clinical and commercial modules built on top of
// this substrate, not the substrate.
//
// Adding to this list makes a module unsellable, so it is a product decision
// as much as a technical one.
var alwaysAvailableModules = map[string]bool{
	"platform_api":    true, // health and readiness probes
	"identity_access": true, // sign-in, session context
	"organization":    true, // tenant, facility and entitlement configuration
	"common":          true, // shared types; carries no procedures of its own
}

// NewEntitlementInterceptor refuses calls into modules a tenant does not have.
//
// It must be installed AFTER the authentication interceptor.
func NewEntitlementInterceptor(checker EntitlementChecker, resolve ModuleResolver) connect.UnaryInterceptorFunc {
	if resolve == nil {
		resolve = ModuleForProcedure
	}

	return func(next connect.UnaryFunc) connect.UnaryFunc {
		return func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
			module := resolve(req.Spec().Procedure)
			if module == "" || alwaysAvailableModules[module] {
				return next(ctx, req)
			}

			session, err := authctx.FromContext(ctx)
			if err != nil {
				// Unauthenticated: not this interceptor's refusal to make. The
				// authentication interceptor will reject it with the right
				// error, and answering here would conflate two different
				// problems.
				return next(ctx, req)
			}

			enabled, reason, err := checker.ModuleEnabled(ctx, session, module)
			if err != nil {
				return nil, ToConnect(
					rpcerr.Internal("PLT_ENTITLEMENT_CHECK_FAILED",
						"could not determine module entitlement").WithCause(err),
					session.CorrelationID)
			}
			if !enabled {
				// PERMISSION_DENIED with a distinct code, not NOT_FOUND. A
				// disabled module is not a secret — the tenant's own
				// administrator needs to see that it is off and why, so they
				// can buy or enable it — and pretending the endpoint does not
				// exist would send them to support instead.
				return nil, ToConnect(
					rpcerr.PermissionDenied("PLT_MODULE_NOT_ENTITLED", reason),
					session.CorrelationID)
			}

			return next(ctx, req)
		}
	}
}
