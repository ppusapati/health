package app_test

import (
	"context"
	"testing"

	"connectrpc.com/connect"
	identityv1 "github.com/ppusapati/health/code/gen/go/healthcare/identity_access/v1"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/internal/platform/policy"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
)

// asWithHeaders builds a request with a bearer token plus extra headers.
func asWithHeaders[T any](token string, headers map[string]string, msg *T) *connect.Request[T] {
	req := connect.NewRequest(msg)
	req.Header().Set(platformtransport.HeaderAuthorization, "Bearer "+token)
	for k, v := range headers {
		req.Header().Set(k, v)
	}
	return req
}

// A client-supplied facility header must be narrowed to what the credential
// grants, never assigned verbatim.
//
// Without this, a caller satisfies the ABAC facility gate simply by asserting
// its own scope, and policy.ReasonFacilityScopeDenied becomes unreachable for
// every remote caller.
func TestFacilityHeaderCannotAssertAnUnpermittedFacility(t *testing.T) {
	h := newHarness(t)
	tenantID := h.provisionTenant(t, "Apollo Group")

	// The token claims facility-1 only.
	token := tenantID + ":admin-1:tenant_admin:facility-1"

	_, err := h.ident.EvaluateAccess(context.Background(),
		asWithHeaders(token, map[string]string{
			platformtransport.HeaderFacilityID: "facility-999",
		}, &identityv1.EvaluateAccessRequest{
			Permission: "organization.facility.read",
			FacilityId: "facility-999",
		}))

	if err == nil {
		t.Fatal("a facility the credential does not grant was accepted")
	}
	if got := connectCode(err); got != connect.CodePermissionDenied {
		t.Fatalf("code = %v, want permission_denied", got)
	}
	if detail := errorDetail(t, err); detail == nil || detail.GetCode() != "AUTH_FACILITY_NOT_PERMITTED" {
		t.Fatalf("detail = %v", detail)
	}
}

// The claimed facility is still usable: the check narrows, it does not block.
func TestFacilityHeaderAcceptsAClaimedFacility(t *testing.T) {
	h := newHarness(t)
	tenantID := h.provisionTenant(t, "Apollo Group")
	token := tenantID + ":admin-1:tenant_admin:facility-1"

	resp, err := h.ident.EvaluateAccess(context.Background(),
		asWithHeaders(token, map[string]string{
			platformtransport.HeaderFacilityID: "facility-1",
		}, &identityv1.EvaluateAccessRequest{
			Permission: "organization.facility.read",
			FacilityId: "facility-1",
		}))
	if err != nil {
		t.Fatalf("EvaluateAccess: %v", err)
	}
	if !resp.Msg.GetAllowed() {
		t.Fatalf("claimed facility denied: %s", resp.Msg.GetReason())
	}
}

// A token with no facility claim grants no facility scope. The absence of a
// claim must never read as an unrestricted grant.
func TestTokenWithoutFacilityClaimCannotSelectAFacility(t *testing.T) {
	h := newHarness(t)
	tenantID := h.provisionTenant(t, "Apollo Group")

	_, err := h.org.ListFacilities(context.Background(),
		asWithHeaders(tenantAdminToken(tenantID), map[string]string{
			platformtransport.HeaderFacilityID: "facility-1",
		}, &organizationv1.ListFacilitiesRequest{}))

	if err == nil {
		t.Fatal("a token with no facility claim selected a facility")
	}
	if got := connectCode(err); got != connect.CodePermissionDenied {
		t.Fatalf("code = %v, want permission_denied", got)
	}
}

// Purpose-of-use lands in the regulated audit trail. An unchecked header would
// let a caller label a commercial bulk read as treatment.
func TestPurposeHeaderCannotAssertAnUnpermittedPurpose(t *testing.T) {
	h := newHarness(t)
	tenantID := h.provisionTenant(t, "Apollo Group")

	_, err := h.org.ListFacilities(context.Background(),
		asWithHeaders(tenantAdminToken(tenantID), map[string]string{
			platformtransport.HeaderPurposeOfUse: "treatment",
		}, &organizationv1.ListFacilitiesRequest{}))

	if err == nil {
		t.Fatal("an unclaimed purpose of use was accepted")
	}
	if detail := errorDetail(t, err); detail == nil || detail.GetCode() != "AUTH_PURPOSE_NOT_PERMITTED" {
		t.Fatalf("detail = %v", detail)
	}
}

// An arbitrary string must be refused before it can reach the audit column or
// a span attribute.
func TestUnknownPurposeStringIsRefused(t *testing.T) {
	h := newHarness(t)
	tenantID := h.provisionTenant(t, "Apollo Group")

	_, err := h.org.ListFacilities(context.Background(),
		asWithHeaders(tenantAdminToken(tenantID), map[string]string{
			platformtransport.HeaderPurposeOfUse: "../../not-a-purpose",
		}, &organizationv1.ListFacilitiesRequest{}))

	if err == nil {
		t.Fatal("an unknown purpose string was accepted")
	}
	if got := connectCode(err); got != connect.CodePermissionDenied {
		t.Fatalf("code = %v, want permission_denied", got)
	}
}

// The purpose the credential does grant still works.
func TestClaimedPurposeIsAccepted(t *testing.T) {
	h := newHarness(t)
	tenantID := h.provisionTenant(t, "Apollo Group")

	if _, err := h.org.ListFacilities(context.Background(),
		asWithHeaders(tenantAdminToken(tenantID), map[string]string{
			platformtransport.HeaderPurposeOfUse: "operations",
		}, &organizationv1.ListFacilitiesRequest{})); err != nil {
		t.Fatalf("claimed purpose refused: %v", err)
	}
}

// The audit trail must record the purpose the server verified, not one the
// caller asserted.
func TestAuditRecordsOnlyAVerifiedPurpose(t *testing.T) {
	h := newHarness(t)
	ctx := context.Background()
	tenantID := h.provisionTenant(t, "Apollo Group")

	if _, err := h.org.CreateFacility(ctx,
		asWithHeaders(tenantAdminToken(tenantID), map[string]string{
			platformtransport.HeaderPurposeOfUse: "operations",
		}, &organizationv1.CreateFacilityRequest{
			Code:        "MAIN",
			DisplayName: "Main Hospital",
			Type:        organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL,
			TimeZone:    "Asia/Kolkata",
		})); err != nil {
		t.Fatalf("CreateFacility: %v", err)
	}

	var purpose string
	if err := h.pool.QueryRow(ctx,
		`SELECT purpose_of_use FROM platform_data.audit_record
		  WHERE tenant_id = $1 AND outcome = 'success' LIMIT 1`,
		tenantID).Scan(&purpose); err != nil {
		t.Fatalf("read audit: %v", err)
	}
	if purpose != string(policyPurposeOperations) {
		t.Fatalf("audit purpose = %q", purpose)
	}
}

// policyPurposeOperations mirrors authctx.PurposeOperations without importing
// the package into an assertion about persisted text.
const policyPurposeOperations = "operations"

var _ = policy.ReasonFacilityScopeDenied
