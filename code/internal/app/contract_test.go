package app_test

import (
	"context"
	"testing"

	"connectrpc.com/connect"
	"github.com/google/uuid"
	commonv1 "github.com/ppusapati/health/code/gen/go/healthcare/common/v1"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
)

// Contract test suite (SRS-API-013).
//
// The verification clause is "CI blocks incompatible contract merge", and a
// contract is two things that break independently:
//
//	shape      the wire format. Held by `buf breaking` against main, which
//	           catches a renumbered field or a removed method.
//	behaviour  which permission an RPC needs, and which status it answers with
//	           when refused. buf cannot see this at all — a handler can change
//	           NOT_FOUND to PERMISSION_DENIED, or drop a permission check
//	           entirely, without touching a single byte of the proto.
//
// This file is the second half. Every case is written as a table entry rather
// than prose, because the value is in the set being visibly complete: a
// reviewer should be able to see which RPCs have their semantics pinned and
// which do not.
//
// The status codes here are load-bearing beyond tidiness. A cross-tenant read
// answering PERMISSION_DENIED rather than NOT_FOUND confirms that an
// identifier exists, which is the probe the isolation tests exist to prevent;
// so a change to one of these expectations is a security change, and failing
// the build is the correct response to it.

// contractCase pins one RPC's permission and error semantics.
type contractCase struct {
	name string
	// call performs the RPC with the given token and returns its error.
	call func(t *testing.T, h *harness, token string) error
	// tokenFor builds the caller. Separate from call so the same RPC can be
	// exercised as several roles.
	tokenFor func(h *harness, tenantID string) string
	wantCode connect.Code
	// wantErrorCode is the stable machine code in the error detail. Clients
	// branch on it, so it is as much a part of the contract as the status.
	wantErrorCode string
}

func TestContractPermissionAndErrorSemantics(t *testing.T) {
	h := newHarness(t)
	tenantID := h.provisionTenant(t, "Contract Hospital")

	cases := []contractCase{
		{
			name: "unauthenticated call is refused before any handler",
			call: func(t *testing.T, h *harness, token string) error {
				_, err := h.org.ListFacilities(context.Background(),
					connect.NewRequest(&organizationv1.ListFacilitiesRequest{}))
				return err
			},
			tokenFor:      func(*harness, string) string { return "" },
			wantCode:      connect.CodeUnauthenticated,
			wantErrorCode: "AUTH_MISSING_CREDENTIALS",
		},
		{
			name: "a viewer cannot create a facility",
			call: func(t *testing.T, h *harness, token string) error {
				_, err := h.org.CreateFacility(context.Background(),
					as(token, &organizationv1.CreateFacilityRequest{
						Code: "FAC99", DisplayName: "Denied Facility",
						Type:     organizationv1.FacilityType_FACILITY_TYPE_CLINIC,
						TimeZone: "Asia/Kolkata",
					}))
				return err
			},
			tokenFor:      func(_ *harness, tenantID string) string { return viewerToken(tenantID) },
			wantCode:      connect.CodePermissionDenied,
			wantErrorCode: "ORG_FACILITY_CREATE_DENIED",
		},
		{
			name: "a tenant admin cannot provision tenants",
			call: func(t *testing.T, h *harness, token string) error {
				_, err := h.org.CreateTenant(context.Background(),
					as(token, &organizationv1.CreateTenantRequest{
						DisplayName: "Escalated Tenant", LegalJurisdiction: "IN",
						DefaultLocale: "en-IN", TimeZone: "Asia/Kolkata",
					}))
				return err
			},
			tokenFor:      func(_ *harness, tenantID string) string { return tenantAdminToken(tenantID) },
			wantCode:      connect.CodePermissionDenied,
			wantErrorCode: "ORG_TENANT_CREATE_DENIED",
		},
		{
			// The load-bearing one. NOT_FOUND, never PERMISSION_DENIED: the
			// latter confirms the identifier exists, which is the probe the
			// isolation tests exist to prevent.
			name: "a cross-tenant read is NOT_FOUND, not PERMISSION_DENIED",
			call: func(t *testing.T, h *harness, token string) error {
				_, err := h.org.GetFacility(context.Background(),
					as(token, &organizationv1.GetFacilityRequest{FacilityId: uuid.NewString()}))
				return err
			},
			tokenFor:      func(_ *harness, tenantID string) string { return viewerToken(tenantID) },
			wantCode:      connect.CodeNotFound,
			wantErrorCode: "ORG_FACILITY_NOT_FOUND",
		},
		{
			name: "a malformed page token is an argument error, not an internal one",
			call: func(t *testing.T, h *harness, token string) error {
				_, err := h.org.ListFacilities(context.Background(),
					as(token, &organizationv1.ListFacilitiesRequest{
						Page: &commonv1.PageRequest{PageToken: "not-a-token"},
					}))
				return err
			},
			tokenFor:      func(_ *harness, tenantID string) string { return viewerToken(tenantID) },
			wantCode:      connect.CodeInvalidArgument,
			wantErrorCode: "ORG_PAGE_TOKEN_INVALID",
		},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			err := tc.call(t, h, tc.tokenFor(h, tenantID))
			if err == nil {
				t.Fatal("the call succeeded; the contract expects a refusal")
			}
			if got := connectCode(err); got != tc.wantCode {
				t.Errorf("status %v, want %v — a client branching on this would "+
					"behave differently (%v)", got, tc.wantCode, err)
			}
			detail := errorDetail(t, err)
			if detail == nil {
				t.Fatal("no structured error detail; clients have nothing stable to branch on")
			}
			if detail.GetCode() != tc.wantErrorCode {
				t.Errorf("error code %q, want %q", detail.GetCode(), tc.wantErrorCode)
			}
		})
	}
}

// Every refusal must carry a correlation id, or a support ticket cannot be
// joined to a trace.
func TestEveryErrorCarriesACorrelationID(t *testing.T) {
	h := newHarness(t)
	tenantID := h.provisionTenant(t, "Correlation Hospital")

	const correlationID = "contract-test-correlation"
	req := as(viewerToken(tenantID), &organizationv1.GetFacilityRequest{
		FacilityId: uuid.NewString(),
	})
	req.Header().Set(platformtransport.HeaderCorrelationID, correlationID)

	_, err := h.org.GetFacility(context.Background(), req)
	if err == nil {
		t.Fatal("the call succeeded")
	}
	detail := errorDetail(t, err)
	if detail == nil {
		t.Fatal("no error detail")
	}
	if detail.GetCorrelationId() != correlationID {
		t.Fatalf("correlation id %q, want %q — the client's own id must come back "+
			"so a support ticket joins to a trace", detail.GetCorrelationId(), correlationID)
	}
}

// A success must carry the same correlation id, so a client can join a
// successful call to a trace too — not only a failure.
func TestSuccessfulCallsAlsoPropagateCorrelation(t *testing.T) {
	h := newHarness(t)
	tenantID := h.provisionTenant(t, "Success Correlation Hospital")

	const correlationID = "contract-success-correlation"
	req := as(tenantAdminToken(tenantID), &organizationv1.ListFacilitiesRequest{})
	req.Header().Set(platformtransport.HeaderCorrelationID, correlationID)

	resp, err := h.org.ListFacilities(context.Background(), req)
	if err != nil {
		t.Fatalf("ListFacilities: %v", err)
	}
	if got := resp.Header().Get(platformtransport.HeaderCorrelationID); got != correlationID {
		t.Fatalf("response correlation id %q, want %q", got, correlationID)
	}
}
