// Package authctx carries the verified caller identity through every layer.
//
// The central design rule is that tenant scope is unforgeable. TenantScope has
// no exported fields and no public zero-value constructor, so a repository
// method that accepts a TenantScope cannot be called with a tenant ID that was
// simply read off a request body. That makes FIT-03 ("every tenant-owned
// repository method requires verified tenant scope") a compile-time property
// rather than a code-review convention.
//
// Trace: SRS-PLT-003, SRS-PLT-012, SRS-IAM-004, SRS-IAM-013, SRS-API-005.
package authctx

import (
	"context"
	"errors"
	"time"
)

// PurposeOfUse constrains what a caller may do with data it is entitled to see.
type PurposeOfUse string

const (
	PurposeUnspecified PurposeOfUse = ""
	PurposeTreatment   PurposeOfUse = "treatment"
	PurposePayment     PurposeOfUse = "payment"
	PurposeOperations  PurposeOfUse = "operations"
	PurposeSupport     PurposeOfUse = "support"
	PurposeResearch    PurposeOfUse = "research"
)

// knownPurposes is the closed set. A purpose outside it is rejected rather
// than stored: the value ends up in the audit trail and in telemetry.
var knownPurposes = map[PurposeOfUse]bool{
	PurposeTreatment:  true,
	PurposePayment:    true,
	PurposeOperations: true,
	PurposeSupport:    true,
	PurposeResearch:   true,
}

// IsKnownPurpose reports whether a purpose is a member of the closed set.
func IsKnownPurpose(p PurposeOfUse) bool { return knownPurposes[p] }

// ErrNoSession is returned when a use case runs without an authenticated
// caller. Deny-by-default: the absence of a session is never "public".
var ErrNoSession = errors.New("authctx: no authenticated session in context")

// TenantScope is proof that the tenant was resolved from verified credentials.
//
// It is deliberately not constructible outside this package: callers obtain one
// only from Session.TenantScope(), and a Session only exists once the transport
// interceptor has authenticated the request.
type TenantScope struct {
	tenantID string
}

// TenantID returns the verified tenant identifier.
func (t TenantScope) TenantID() string { return t.tenantID }

// IsZero reports whether the scope is the unusable zero value.
func (t TenantScope) IsZero() bool { return t.tenantID == "" }

// SystemScope is tenant scope for background work that has no user behind it.
//
// This is the only way to obtain a TenantScope without a Session, and it is a
// deliberate hole in the invariant above rather than an oversight. Some work
// genuinely has no caller: a timer sweeping escalations that are due, an outbox
// publisher draining events. Neither can present credentials, and neither is
// acting for a user — they are acting for the tenant whose row they found.
//
// The alternatives were worse. A background sweeper that took a plain tenant
// string would need its own set of repository methods, which is the same hole
// with more surface; a sweeper that ran only inside a request would not be a
// sweeper. What makes this safe is not that it is hard to call but that it is
// easy to find: one ugly name, greppable, and FIT-03's companion rule in
// tools/fitness fails when a package outside the background runners calls it.
//
// The rule to hold when reading a call site: this grants tenant scope, never
// permission. Everything downstream still authorizes, and a use case reached
// through here has no session — which is why it must be a mechanism, not a
// clinical decision.
func SystemScope(tenantID string) TenantScope {
	return TenantScope{tenantID: tenantID}
}

// Session is the resolved authorization context for one request.
type Session struct {
	SubjectID        string
	TenantID         string
	ActiveFacilityID string
	Roles            []string
	Permissions      []string
	Purpose          PurposeOfUse
	BreakGlass       bool

	// PermittedFacilities lists the facilities this credential may act in.
	//
	// A client may ask to narrow its active facility through a header, but only
	// to a facility named here. Empty means the credential grants no facility
	// scope at all, so any such request is refused — the absence of a claim is
	// never an unrestricted grant.
	PermittedFacilities []string

	// PermittedPurposes lists the purposes-of-use this credential may assert.
	// Same rule: empty grants nothing.
	PermittedPurposes []PurposeOfUse

	// IssuedAt is when the credential this session came from was minted.
	//
	// It is what makes revocation propagate: an account's revocation watermark
	// is compared against it on every request, so disabling a user kills the
	// sessions they already hold rather than waiting for a token to expire on
	// its own (SRS-IAM-006).
	IssuedAt time.Time

	// CorrelationID is stable across RPC, event and workflow hops.
	CorrelationID string
	// RequestID is unique to this single request.
	RequestID string
}

// NewSession builds a verified session. Only the transport authentication
// interceptor (and tests standing in for it) may call this.
func NewSession(s Session) Session { return s }

// TenantScope mints the unforgeable scope token for repository calls.
func (s Session) TenantScope() TenantScope { return TenantScope{tenantID: s.TenantID} }

// PermitsFacility reports whether the credential may act in a facility.
//
// This is the check that makes the ABAC facility gate real. Without it the
// caller simply asserts its own facility scope in a header, and
// policy.ReasonFacilityScopeDenied becomes unreachable.
func (s Session) PermitsFacility(facilityID string) bool {
	for _, f := range s.PermittedFacilities {
		if f == facilityID {
			return true
		}
	}
	return false
}

// PermitsPurpose reports whether the credential may assert a purpose-of-use.
//
// Purpose lands in the regulated audit trail, so an unchecked header would let
// a caller label a commercial bulk read as "treatment".
func (s Session) PermitsPurpose(purpose PurposeOfUse) bool {
	for _, p := range s.PermittedPurposes {
		if p == purpose {
			return true
		}
	}
	return false
}

// HasPermission reports whether the flattened permission set contains name.
func (s Session) HasPermission(name string) bool {
	for _, p := range s.Permissions {
		if p == name {
			return true
		}
	}
	return false
}

type sessionKey struct{}

// WithSession returns a context carrying the verified session.
func WithSession(ctx context.Context, s Session) context.Context {
	return context.WithValue(ctx, sessionKey{}, s)
}

// FromContext extracts the verified session, or ErrNoSession.
func FromContext(ctx context.Context) (Session, error) {
	s, ok := ctx.Value(sessionKey{}).(Session)
	if !ok || s.SubjectID == "" || s.TenantID == "" {
		return Session{}, ErrNoSession
	}
	return s, nil
}
