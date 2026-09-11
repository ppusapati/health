package transport

import (
	"context"
	"strings"

	"connectrpc.com/connect"
	"github.com/google/uuid"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/obs"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"go.opentelemetry.io/otel/trace"
)

// Header names on the wire.
const (
	HeaderAuthorization = "Authorization"
	HeaderCorrelationID = "X-Correlation-Id"
	HeaderRequestID     = "X-Request-Id"
	HeaderIdempotency   = "Idempotency-Key"
	HeaderPurposeOfUse  = "X-Purpose-Of-Use"
	HeaderFacilityID    = "X-Facility-Id"
)

// TokenVerifier turns a bearer token into a verified session.
//
// This is the seam for the enterprise OIDC provider. ADR-008 (identity provider
// selection) is still open and is marked as blocking, so the concrete verifier
// is chosen at the composition root rather than hard-wired here.
type TokenVerifier interface {
	Verify(ctx context.Context, bearerToken string) (authctx.Session, error)
}

// PublicProcedures are reachable without authentication. The set is explicit
// and tiny: everything not named here requires a session (deny by default).
var PublicProcedures = map[string]bool{
	"/healthcare.platform_api.v1.HealthService/CheckLiveness":  true,
	"/healthcare.platform_api.v1.HealthService/CheckReadiness": true,
	"/healthcare.platform_api.v1.HealthService/GetBuildInfo":   true,
}

type correlationKey struct{}

// CorrelationIDFromContext returns the correlation ID for this request.
func CorrelationIDFromContext(ctx context.Context) string {
	id, _ := ctx.Value(correlationKey{}).(string)
	return id
}

// NewAuthInterceptor authenticates requests and populates the session context.
//
// The tenant is taken exclusively from the verified token. A tenant_id in the
// request body is ignored, which is what closes the privilege-escalation path
// in SRS-IAM-013.
func NewAuthInterceptor(verifier TokenVerifier) connect.UnaryInterceptorFunc {
	return func(next connect.UnaryFunc) connect.UnaryFunc {
		return func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
			header := req.Header()

			correlationID := firstNonEmpty(header.Get(HeaderCorrelationID), uuid.NewString())
			requestID := firstNonEmpty(header.Get(HeaderRequestID), uuid.NewString())
			ctx = context.WithValue(ctx, correlationKey{}, correlationID)

			// Carry the correlation onto the span so a trace and a support
			// ticket can be joined (SRS-API-014).
			span := trace.SpanFromContext(ctx)
			span.SetAttributes(obs.SafeAttrs{
				CorrelationID: correlationID,
				RequestID:     requestID,
				Action:        req.Spec().Procedure,
			}.SpanAttrs()...)

			if PublicProcedures[req.Spec().Procedure] {
				return withCorrelationHeader(next(ctx, req))(correlationID)
			}

			token := bearerToken(header.Get(HeaderAuthorization))
			if token == "" {
				return nil, ToConnect(
					rpcerr.Unauthenticated("AUTH_MISSING_CREDENTIALS", "authentication required"),
					correlationID)
			}

			session, err := verifier.Verify(ctx, token)
			if err != nil {
				return nil, ToConnect(err, correlationID)
			}

			session.CorrelationID = correlationID
			session.RequestID = requestID

			// The active facility and purpose-of-use are client-selected views,
			// so a header may only narrow to something the credential already
			// grants. Assigning them verbatim would let the caller satisfy the
			// ABAC facility gate by asserting its own scope, and would let it
			// write its own purpose into the regulated audit trail.
			if facility := header.Get(HeaderFacilityID); facility != "" {
				if !session.PermitsFacility(facility) {
					return nil, ToConnect(rpcerr.PermissionDenied(
						"AUTH_FACILITY_NOT_PERMITTED", "facility not permitted"), correlationID)
				}
				session.ActiveFacilityID = facility
			}
			if purpose := header.Get(HeaderPurposeOfUse); purpose != "" {
				requested := authctx.PurposeOfUse(purpose)
				// Checked against the closed set first: an unknown string must
				// not reach the audit column or a span attribute.
				if !authctx.IsKnownPurpose(requested) || !session.PermitsPurpose(requested) {
					return nil, ToConnect(rpcerr.PermissionDenied(
						"AUTH_PURPOSE_NOT_PERMITTED", "purpose of use not permitted"), correlationID)
				}
				session.Purpose = requested
			}

			span.SetAttributes(obs.SafeAttrs{
				TenantID:  session.TenantID,
				SubjectID: session.SubjectID,
			}.SpanAttrs()...)

			return withCorrelationHeader(
				next(authctx.WithSession(ctx, authctx.NewSession(session)), req))(correlationID)
		}
	}
}

// withCorrelationHeader echoes the correlation id on a successful response.
//
// A failure already carries it in the structured error detail, so before this
// a client could join a failed call to a trace and a successful one not at
// all — which is backwards, because the calls somebody investigates after the
// fact are usually the ones that returned 200 and did the wrong thing
// (SRS-API-014).
//
// Written as a curried closure so the two call sites above stay one-liners
// rather than each repeating the nil-response check.
func withCorrelationHeader(resp connect.AnyResponse, err error) func(string) (connect.AnyResponse, error) {
	return func(correlationID string) (connect.AnyResponse, error) {
		if err == nil && resp != nil {
			resp.Header().Set(HeaderCorrelationID, correlationID)
		}
		return resp, err
	}
}

// NewErrorInterceptor converts any error escaping a handler into the canonical
// wire representation. Handlers that already call ToConnect pass through
// unchanged, because a *connect.Error is left alone.
func NewErrorInterceptor() connect.UnaryInterceptorFunc {
	return func(next connect.UnaryFunc) connect.UnaryFunc {
		return func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
			resp, err := next(ctx, req)
			if err == nil {
				return resp, nil
			}
			var connectErr *connect.Error
			if ok := asConnectError(err, &connectErr); ok {
				return nil, err
			}
			return nil, ToConnect(err, CorrelationIDFromContext(ctx))
		}
	}
}

func asConnectError(err error, target **connect.Error) bool {
	ce, ok := err.(*connect.Error)
	if ok {
		*target = ce
	}
	return ok
}

func bearerToken(header string) string {
	const prefix = "Bearer "
	if len(header) > len(prefix) && strings.EqualFold(header[:len(prefix)], prefix) {
		return strings.TrimSpace(header[len(prefix):])
	}
	return ""
}

func firstNonEmpty(values ...string) string {
	for _, v := range values {
		if v != "" {
			return v
		}
	}
	return ""
}
