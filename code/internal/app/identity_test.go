package app_test

import (
	"context"
	"testing"

	"connectrpc.com/connect"
	identityv1 "github.com/ppusapati/health/code/gen/go/healthcare/identity_access/v1"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/platform/policy"
)

func TestGetSessionContextReturnsResolvedAuthority(t *testing.T) {
	h := newHarness(t)
	tenantID := h.provisionTenant(t, "Apollo Group")

	resp, err := h.ident.GetSessionContext(context.Background(),
		as(tenantAdminToken(tenantID), &identityv1.GetSessionContextRequest{}))
	if err != nil {
		t.Fatalf("GetSessionContext: %v", err)
	}

	session := resp.Msg.GetSession()
	if session.GetTenantId() != tenantID {
		t.Fatalf("TenantId = %q", session.GetTenantId())
	}
	if len(session.GetPermissions()) == 0 {
		t.Fatal("no permissions returned")
	}
	// The context reports what the role catalogue grants, not what the caller
	// asked for.
	var sawCreate bool
	for _, p := range session.GetPermissions() {
		if p == "organization.facility.create" {
			sawCreate = true
		}
	}
	if !sawCreate {
		t.Fatalf("permissions = %v", session.GetPermissions())
	}
}

func TestGetSessionContextRequiresAuthentication(t *testing.T) {
	h := newHarness(t)

	_, err := h.ident.GetSessionContext(context.Background(),
		connect.NewRequest(&identityv1.GetSessionContextRequest{}))
	if err == nil {
		t.Fatal("unauthenticated GetSessionContext succeeded")
	}
	if got := connectCode(err); got != connect.CodeUnauthenticated {
		t.Fatalf("code = %v", got)
	}
}

func TestEvaluateAccessMatchesGrantedPermissions(t *testing.T) {
	h := newHarness(t)
	tenantID := h.provisionTenant(t, "Apollo Group")

	granted, err := h.ident.EvaluateAccess(context.Background(),
		as(tenantAdminToken(tenantID), &identityv1.EvaluateAccessRequest{
			Permission: "organization.facility.create",
		}))
	if err != nil {
		t.Fatalf("EvaluateAccess: %v", err)
	}
	if !granted.Msg.GetAllowed() {
		t.Fatalf("granted permission denied: %s", granted.Msg.GetReason())
	}

	ungranted, err := h.ident.EvaluateAccess(context.Background(),
		as(viewerToken(tenantID), &identityv1.EvaluateAccessRequest{
			Permission: "organization.facility.create",
		}))
	if err != nil {
		t.Fatalf("EvaluateAccess: %v", err)
	}
	if ungranted.Msg.GetAllowed() {
		t.Fatal("a viewer was told it may create facilities")
	}
	if ungranted.Msg.GetReason() != policy.ReasonPermissionNotGranted {
		t.Fatalf("Reason = %q", ungranted.Msg.GetReason())
	}
}

// The probe and the real call must agree. EvaluateAccess previously assumed
// every tenant was read-write, so it said "allowed" for a mutating action on a
// suspended tenant that CreateFacility then refused.
func TestEvaluateAccessAgreesWithTheRealCallOnASuspendedTenant(t *testing.T) {
	h := newHarness(t)
	ctx := context.Background()
	tenantID := h.provisionTenant(t, "Apollo Group")
	token := tenantAdminToken(tenantID)

	if _, err := h.pool.Exec(ctx,
		`UPDATE organization.tenant SET status = $1 WHERE tenant_id = $2`,
		string(domain.TenantSuspended), tenantID); err != nil {
		t.Fatalf("suspend tenant: %v", err)
	}

	probe, err := h.ident.EvaluateAccess(ctx, as(token, &identityv1.EvaluateAccessRequest{
		Permission: "organization.facility.create",
	}))
	if err != nil {
		t.Fatalf("EvaluateAccess: %v", err)
	}

	_, callErr := h.org.CreateFacility(ctx, as(token, &organizationv1.CreateFacilityRequest{
		Code:        "MAIN",
		DisplayName: "Main Hospital",
		Type:        organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL,
		TimeZone:    "Asia/Kolkata",
	}))

	if probe.Msg.GetAllowed() {
		t.Fatalf("probe said allowed but the call returned %v", callErr)
	}
	if probe.Msg.GetReason() != policy.ReasonTenantReadOnly {
		t.Fatalf("Reason = %q, want %q", probe.Msg.GetReason(), policy.ReasonTenantReadOnly)
	}
	if callErr == nil {
		t.Fatal("the real call succeeded on a suspended tenant")
	}

	// A read must still be permitted, by both.
	readProbe, err := h.ident.EvaluateAccess(ctx, as(token, &identityv1.EvaluateAccessRequest{
		Permission: "organization.facility.read",
	}))
	if err != nil {
		t.Fatalf("EvaluateAccess read: %v", err)
	}
	if !readProbe.Msg.GetAllowed() {
		t.Fatalf("read denied on a suspended tenant: %s", readProbe.Msg.GetReason())
	}
}
