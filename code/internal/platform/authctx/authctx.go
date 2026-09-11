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

// Session is the resolved authorization context for one request.
type Session struct {
	SubjectID        string
	TenantID         string
	ActiveFacilityID string
	Roles            []string
	Permissions      []string
	Purpose          PurposeOfUse
	BreakGlass       bool

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
