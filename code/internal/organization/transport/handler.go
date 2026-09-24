// Package transport exposes the organization use cases over ConnectRPC.
//
// Handlers translate wire messages to and from application inputs and do
// nothing else: no validation beyond shape, no authorization, no persistence
// (SRS-API-006).
package transport

import (
	"context"

	"connectrpc.com/connect"
	commonv1 "github.com/ppusapati/health/code/gen/go/healthcare/common/v1"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/internal/organization/application"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
)

// Handler serves healthcare.organization.v1.OrganizationService.
type Handler struct {
	svc *application.Service
	// masterData is the port bundle CreateOrgUnit takes. It is a parameter of
	// that use case rather than a field of the service, so the handler carries
	// it; a zero bundle means this deployment wires no master data and the
	// ward call says so rather than panicking.
	masterData application.MasterDataPorts
}

// NewHandler constructs the handler.
func NewHandler(svc *application.Service) *Handler { return &Handler{svc: svc} }

// NewHandlerWithMasterData constructs a handler that can also commission the
// org-unit hierarchy a room hangs from (SRS-PLT-005, SRS-PLT-006).
func NewHandlerWithMasterData(svc *application.Service,
	md application.MasterDataPorts) *Handler {
	return &Handler{svc: svc, masterData: md}
}

// CreateTenant implements SRS-PLT-001.
func (h *Handler) CreateTenant(
	ctx context.Context,
	req *connect.Request[organizationv1.CreateTenantRequest],
) (*connect.Response[organizationv1.CreateTenantResponse], error) {
	msg := req.Msg
	tenant, err := h.svc.CreateTenant(ctx, application.CreateTenantInput{
		DisplayName:       msg.GetDisplayName(),
		LegalJurisdiction: msg.GetLegalJurisdiction(),
		DefaultLocale:     msg.GetDefaultLocale(),
		TimeZone:          msg.GetTimeZone(),
	})
	if err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}
	return connect.NewResponse(&organizationv1.CreateTenantResponse{
		Tenant: tenantToProto(tenant),
	}), nil
}

// GetTenant implements SRS-PLT-001.
func (h *Handler) GetTenant(
	ctx context.Context,
	req *connect.Request[organizationv1.GetTenantRequest],
) (*connect.Response[organizationv1.GetTenantResponse], error) {
	tenant, err := h.svc.GetTenant(ctx, req.Msg.GetTenantId())
	if err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}
	return connect.NewResponse(&organizationv1.GetTenantResponse{
		Tenant: tenantToProto(tenant),
	}), nil
}

// CreateFacility implements SRS-PLT-004.
//
// Note what is absent: the request carries no tenant_id, so there is nothing
// for a caller to tamper with. Tenant comes from the verified session.
func (h *Handler) CreateFacility(
	ctx context.Context,
	req *connect.Request[organizationv1.CreateFacilityRequest],
) (*connect.Response[organizationv1.CreateFacilityResponse], error) {
	msg := req.Msg
	facility, err := h.svc.CreateFacility(ctx, application.CreateFacilityInput{
		Code:        msg.GetCode(),
		DisplayName: msg.GetDisplayName(),
		Type:        facilityTypeFromProto(msg.GetType()),
		TimeZone:    msg.GetTimeZone(),
	})
	if err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}
	return connect.NewResponse(&organizationv1.CreateFacilityResponse{
		Facility: facilityToProto(facility),
	}), nil
}

// GetFacility implements SRS-PLT-004.
func (h *Handler) GetFacility(
	ctx context.Context,
	req *connect.Request[organizationv1.GetFacilityRequest],
) (*connect.Response[organizationv1.GetFacilityResponse], error) {
	facility, err := h.svc.GetFacility(ctx, req.Msg.GetFacilityId())
	if err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}
	return connect.NewResponse(&organizationv1.GetFacilityResponse{
		Facility: facilityToProto(facility),
	}), nil
}

// ListFacilities implements SRS-PLT-004 with server-side keyset paging
// (SRS-WEB-005).
func (h *Handler) ListFacilities(
	ctx context.Context,
	req *connect.Request[organizationv1.ListFacilitiesRequest],
) (*connect.Response[organizationv1.ListFacilitiesResponse], error) {
	msg := req.Msg

	in := application.ListFacilitiesInput{
		Status: facilityStatusFromProto(msg.GetStatus()),
	}
	if page := msg.GetPage(); page != nil {
		in.PageSize = page.GetPageSize()
		in.PageToken = page.GetPageToken()
	}

	facilities, next, err := h.svc.ListFacilities(ctx, in)
	if err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}

	out := make([]*organizationv1.Facility, 0, len(facilities))
	for _, f := range facilities {
		out = append(out, facilityToProto(f))
	}
	return connect.NewResponse(&organizationv1.ListFacilitiesResponse{
		Facilities: out,
		Page:       &commonv1.PageResponse{NextPageToken: next},
	}), nil
}
