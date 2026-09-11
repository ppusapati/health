package transport

import (
	"context"

	"connectrpc.com/connect"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Session revocation at the request path (SRS-IAM-006).
//
// The verification clause is "disabled user cannot use existing session after
// revocation propagation target", and the word that matters is *existing*. A
// bearer token stays valid until it expires; disabling an account changes
// nothing about what is already in the user's browser. Something on the
// request path has to ask.
//
// That makes this a per-request lookup, which is the cost of the requirement.
// It is bounded by design: the answer is one instant per subject, so an
// implementation can cache it aggressively — the propagation target is how
// stale that cache may be, which is a number the deployment chooses rather
// than a property of the token.
//
// It runs after authentication, because there is no subject to ask about until
// a credential has been verified.

// SessionRevoker answers whether an already-issued session is still good.
//
// An interface here rather than a dependency on identity_access: the platform
// transport package must not import a bounded context (FIT-01), and the
// composition root supplies the implementation.
type SessionRevoker interface {
	// SessionRevoked reports whether this session must be refused, with a
	// stable reason code. An error means the lookup failed, which is distinct
	// from a revocation because the two need different responses.
	SessionRevoked(ctx context.Context, session authctx.Session) (revoked bool, reason string, err error)
}

// NewRevocationInterceptor refuses sessions that have been revoked.
//
// Install it AFTER the authentication interceptor.
func NewRevocationInterceptor(revoker SessionRevoker) connect.UnaryInterceptorFunc {
	return func(next connect.UnaryFunc) connect.UnaryFunc {
		return func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
			session, err := authctx.FromContext(ctx)
			if err != nil {
				// No session: a public procedure, or a request the
				// authentication interceptor is about to refuse. Either way,
				// not this interceptor's decision to make.
				return next(ctx, req)
			}

			revoked, reason, err := revoker.SessionRevoked(ctx, session)
			if err != nil {
				// Fail closed. The alternative — treating a lookup failure as
				// "not revoked" so the system keeps working — means a database
				// blip silently restores access for every disabled account at
				// once, which is the worst possible moment to be permissive.
				return nil, ToConnect(
					rpcerr.Unauthenticated("AUTH_REVOCATION_CHECK_FAILED",
						"could not verify session validity").WithCause(err),
					session.CorrelationID)
			}
			if revoked {
				// UNAUTHENTICATED, not PERMISSION_DENIED: the correct client
				// response is to obtain a new credential, and a client that
				// reads this as a permission problem will keep retrying with
				// the dead token.
				return nil, ToConnect(
					rpcerr.Unauthenticated("AUTH_SESSION_REVOKED", reason),
					session.CorrelationID)
			}

			return next(ctx, req)
		}
	}
}
