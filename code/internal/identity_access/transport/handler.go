// Package transport exposes the identity context over ConnectRPC.
package transport

import (
	"context"
	"strings"

	"connectrpc.com/connect"
	identityv1 "github.com/ppusapati/health/code/gen/go/healthcare/identity_access/v1"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
)

// TenantModeResolver reports a tenant's lifecycle posture.
//
// Declared here, by the consumer, and satisfied by the organization context at
// the composition root. Without it this handler cannot know that a tenant is
// suspended, and would answer "allowed" for a mutating action the real call
// refuses (Blueprint §5: contexts collaborate through interfaces, not imports).
type TenantModeResolver interface {
	TenantMode(ctx context.Context, tenantID string) (policy.TenantMode, error)
}

// Handler serves healthcare.identity_access.v1.IdentityService.
type Handler struct {
	tenants TenantModeResolver
}

// NewHandler constructs the handler.
func NewHandler(tenants TenantModeResolver) *Handler { return &Handler{tenants: tenants} }

// mutatingSuffixes name the actions that change state.
//
// Derived from the permission name because the request does not say whether the
// action mutates. The naming convention is enforced by the permission catalogue,
// and an unrecognised suffix is treated as mutating — the conservative default.
var readOnlySuffixes = []string{".read", ".list", ".search", ".get"}

func isMutating(permission string) bool {
	for _, suffix := range readOnlySuffixes {
		if strings.HasSuffix(permission, suffix) {
			return false
		}
	}
	return true
}

var purposeToProto = map[authctx.PurposeOfUse]identityv1.PurposeOfUse{
	authctx.PurposeTreatment:  identityv1.PurposeOfUse_PURPOSE_OF_USE_TREATMENT,
	authctx.PurposePayment:    identityv1.PurposeOfUse_PURPOSE_OF_USE_PAYMENT,
	authctx.PurposeOperations: identityv1.PurposeOfUse_PURPOSE_OF_USE_OPERATIONS,
	authctx.PurposeSupport:    identityv1.PurposeOfUse_PURPOSE_OF_USE_SUPPORT,
	authctx.PurposeResearch:   identityv1.PurposeOfUse_PURPOSE_OF_USE_RESEARCH,
}

// GetSessionContext returns the caller's resolved authorization context so the
// UI can render appropriately. This is presentation input only: the server
// re-evaluates every action regardless of what the UI chose to show
// (SRS-IAM-003, SRS-WEB-001).
func (h *Handler) GetSessionContext(
	ctx context.Context,
	_ *connect.Request[identityv1.GetSessionContextRequest],
) (*connect.Response[identityv1.GetSessionContextResponse], error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return nil, platformtransport.ToConnect(
			rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required"),
			platformtransport.CorrelationIDFromContext(ctx))
	}

	return connect.NewResponse(&identityv1.GetSessionContextResponse{
		Session: &identityv1.SessionContext{
			SubjectId:        session.SubjectID,
			TenantId:         session.TenantID,
			ActiveFacilityId: session.ActiveFacilityID,
			Roles:            session.Roles,
			Permissions:      session.Permissions,
			PurposeOfUse:     purposeToProto[session.Purpose],
			BreakGlassActive: session.BreakGlass,
		},
	}), nil
}

// EvaluateAccess answers an authorization question using the same engine the
// application layer uses, so a UI probe and the real call can never disagree.
func (h *Handler) EvaluateAccess(
	ctx context.Context,
	req *connect.Request[identityv1.EvaluateAccessRequest],
) (*connect.Response[identityv1.EvaluateAccessResponse], error) {
	session, err := authctx.FromContext(ctx)
	if err != nil {
		return nil, platformtransport.ToConnect(
			rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required"),
			platformtransport.CorrelationIDFromContext(ctx))
	}

	// The real tenant posture, not an assumption: a suspended tenant must
	// produce the same answer here as it does on the call itself.
	mode, err := h.tenants.TenantMode(ctx, session.TenantID)
	if err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}

	permission := req.Msg.GetPermission()
	decision := policy.Evaluate(session, policy.Request{
		Permission:           permission,
		Mutating:             isMutating(permission),
		ResourceFacilityID:   req.Msg.GetFacilityId(),
		RequireFacilityMatch: req.Msg.GetFacilityId() != "",
		TenantMode:           mode,
	})

	return connect.NewResponse(&identityv1.EvaluateAccessResponse{
		Allowed: decision.Allowed,
		Reason:  decision.Reason,
	}), nil
}
