// Package transport exposes the identity context over ConnectRPC.
package transport

import (
	"context"

	"connectrpc.com/connect"
	identityv1 "github.com/ppusapati/health/code/gen/go/healthcare/identity_access/v1"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
)

// Handler serves healthcare.identity_access.v1.IdentityService.
type Handler struct{}

// NewHandler constructs the handler.
func NewHandler() *Handler { return &Handler{} }

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

	decision := policy.Evaluate(session, policy.Request{
		Permission:           req.Msg.GetPermission(),
		ResourceFacilityID:   req.Msg.GetFacilityId(),
		RequireFacilityMatch: req.Msg.GetFacilityId() != "",
		TenantMode:           policy.TenantModeReadWrite,
	})

	return connect.NewResponse(&identityv1.EvaluateAccessResponse{
		Allowed: decision.Allowed,
		Reason:  decision.Reason,
	}), nil
}
