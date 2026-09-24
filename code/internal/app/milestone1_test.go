package app_test

import (
	"context"
	"testing"

	"connectrpc.com/connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	platformapiv1 "github.com/ppusapati/health/code/gen/go/healthcare/platform_api/v1"
	"github.com/ppusapati/health/code/internal/organization/application"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
)

// TestMilestone1_EndToEndTransaction is the Wave-0 first engineering milestone:
// one trivial but complete transaction proving the whole architecture.
//
//	SvelteKit-equivalent client
//	  -> ConnectRPC -> handler -> application -> domain
//	  -> repository -> sqlc -> PostgreSQL
//
// with an authenticated user, tenant context, authorization, audit, a database
// transaction and an outbox event. (The OpenTelemetry span and CI pipeline are
// covered separately in observability_test.go and the workflow.)
//
// Gate A1. SRS-PLT-001's verification clause: a tenant exists with a unique
// id and every child record created is scoped to it — here the facility, its
// audit record and its outbox event.
func TestMilestone1_EndToEndTransaction(t *testing.T) {
	h := newHarness(t)
	ctx := context.Background()

	tenantID := h.provisionTenant(t, "Apollo Group")
	adminToken := tenantAdminToken(tenantID)

	// --- the transaction under test -------------------------------------
	created, err := h.org.CreateFacility(ctx, as(adminToken, &organizationv1.CreateFacilityRequest{
		Code:        "main",
		DisplayName: "Main Hospital",
		Type:        organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL,
		TimeZone:    "Asia/Kolkata",
	}))
	if err != nil {
		t.Fatalf("CreateFacility: %v", err)
	}

	facility := created.Msg.GetFacility()
	if facility.GetFacilityId() == "" {
		t.Fatal("facility has no identifier")
	}
	// The tenant on the stored row came from the token, not the request body:
	// the request message has no tenant field at all.
	if facility.GetTenantId() != tenantID {
		t.Fatalf("TenantId = %q, want %q", facility.GetTenantId(), tenantID)
	}
	if facility.GetCode() != "MAIN" {
		t.Fatalf("Code = %q, want normalised MAIN", facility.GetCode())
	}
	if facility.GetStatus() != organizationv1.FacilityStatus_FACILITY_STATUS_ACTIVE {
		t.Fatalf("Status = %v", facility.GetStatus())
	}
	if facility.GetVersion() != 1 {
		t.Fatalf("Version = %d, want 1", facility.GetVersion())
	}

	// --- it is really in PostgreSQL -------------------------------------
	var storedTenant, storedCode string
	err = h.pool.QueryRow(ctx,
		`SELECT tenant_id::text, code FROM organization.facility WHERE facility_id = $1`,
		facility.GetFacilityId()).Scan(&storedTenant, &storedCode)
	if err != nil {
		t.Fatalf("read back facility row: %v", err)
	}
	if storedTenant != tenantID || storedCode != "MAIN" {
		t.Fatalf("stored row = (%s, %s)", storedTenant, storedCode)
	}

	// --- the outbox event committed with it -----------------------------
	var eventType, correlationID, actor string
	var aggregateID string
	err = h.pool.QueryRow(ctx,
		`SELECT event_type, aggregate_id, correlation_id, actor
		   FROM platform_data.outbox_event
		  WHERE tenant_id = $1 AND event_type = $2`,
		tenantID, application.EventFacilityCreated).
		Scan(&eventType, &aggregateID, &correlationID, &actor)
	if err != nil {
		t.Fatalf("read outbox event: %v", err)
	}
	if aggregateID != facility.GetFacilityId() {
		t.Fatalf("event aggregate_id = %q, want %q", aggregateID, facility.GetFacilityId())
	}
	if correlationID == "" {
		t.Fatal("event carries no correlation ID")
	}
	// Events are not yet published: the row is the durable handoff point.
	var published *string
	if err := h.pool.QueryRow(ctx,
		`SELECT published_at::text FROM platform_data.outbox_event WHERE aggregate_id = $1`,
		facility.GetFacilityId()).Scan(&published); err != nil {
		t.Fatalf("read published_at: %v", err)
	}
	if published != nil {
		t.Fatal("event was marked published before any publisher ran")
	}

	// --- and the audit record ------------------------------------------
	var auditAction, auditOutcome, auditActor string
	err = h.pool.QueryRow(ctx,
		`SELECT action, outcome, actor_id FROM platform_data.audit_record
		  WHERE tenant_id = $1 AND resource_id = $2`,
		tenantID, facility.GetFacilityId()).Scan(&auditAction, &auditOutcome, &auditActor)
	if err != nil {
		t.Fatalf("read audit record: %v", err)
	}
	if auditAction != application.PermFacilityCreate || auditOutcome != "success" {
		t.Fatalf("audit = (%s, %s)", auditAction, auditOutcome)
	}
	if auditActor == "" {
		t.Fatal("audit record has no actor")
	}

	// --- and it is readable back through the API ------------------------
	fetched, err := h.org.GetFacility(ctx, as(adminToken, &organizationv1.GetFacilityRequest{
		FacilityId: facility.GetFacilityId(),
	}))
	if err != nil {
		t.Fatalf("GetFacility: %v", err)
	}
	if fetched.Msg.GetFacility().GetDisplayName() != "Main Hospital" {
		t.Fatalf("DisplayName = %q", fetched.Msg.GetFacility().GetDisplayName())
	}
}

// An unauthenticated call must not reach the application layer at all.
func TestUnauthenticatedRequestIsRejected(t *testing.T) {
	h := newHarness(t)

	_, err := h.org.ListFacilities(context.Background(),
		connect.NewRequest(&organizationv1.ListFacilitiesRequest{}))
	if err == nil {
		t.Fatal("unauthenticated request succeeded")
	}
	if got := connectCode(err); got != connect.CodeUnauthenticated {
		t.Fatalf("code = %v, want unauthenticated", got)
	}
}

// Health endpoints are the only public surface, and they must stay public so an
// orchestrator can probe a pod that has no credentials.
func TestHealthEndpointsArePublic(t *testing.T) {
	h := newHarness(t)
	ctx := context.Background()

	live, err := h.health.CheckLiveness(ctx, connect.NewRequest(&platformapiv1.CheckLivenessRequest{}))
	if err != nil {
		t.Fatalf("CheckLiveness: %v", err)
	}
	if !live.Msg.GetAlive() {
		t.Fatal("liveness reported not alive")
	}

	ready, err := h.health.CheckReadiness(ctx, connect.NewRequest(&platformapiv1.CheckReadinessRequest{}))
	if err != nil {
		t.Fatalf("CheckReadiness: %v", err)
	}
	if !ready.Msg.GetReady() || !ready.Msg.GetDependencies()["postgres"] {
		t.Fatalf("readiness = %+v", ready.Msg)
	}
}

// A rejected command must surface the stable machine code and field violations,
// not just a status (SRS-API-004).
func TestValidationFailureCarriesStructuredDetail(t *testing.T) {
	h := newHarness(t)
	tenantID := h.provisionTenant(t, "Apollo Group")

	_, err := h.org.CreateFacility(context.Background(),
		as(tenantAdminToken(tenantID), &organizationv1.CreateFacilityRequest{
			Code:        "bad code!",
			DisplayName: "",
			Type:        organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL,
			TimeZone:    "Asia/Kolkata",
		}))
	if err == nil {
		t.Fatal("invalid facility accepted")
	}
	if got := connectCode(err); got != connect.CodeInvalidArgument {
		t.Fatalf("code = %v, want invalid_argument", got)
	}

	detail := errorDetail(t, err)
	if detail == nil {
		t.Fatal("no ErrorDetail attached")
	}
	if detail.GetCode() != "ORG_FACILITY_INVALID" {
		t.Fatalf("detail code = %q", detail.GetCode())
	}
	if detail.GetCorrelationId() == "" {
		t.Fatal("detail carries no correlation ID for support")
	}

	fields := map[string]string{}
	for _, v := range detail.GetFieldViolations() {
		fields[v.GetField()] = v.GetReason()
	}
	if fields["code"] != "INVALID_FORMAT" || fields["display_name"] != "REQUIRED" {
		t.Fatalf("field violations = %v", fields)
	}
}

// A duplicate code must fail cleanly rather than creating a second facility.
func TestDuplicateFacilityCodeRejected(t *testing.T) {
	h := newHarness(t)
	ctx := context.Background()
	tenantID := h.provisionTenant(t, "Apollo Group")
	token := tenantAdminToken(tenantID)

	req := &organizationv1.CreateFacilityRequest{
		Code:        "MAIN",
		DisplayName: "Main Hospital",
		Type:        organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL,
		TimeZone:    "Asia/Kolkata",
	}
	if _, err := h.org.CreateFacility(ctx, as(token, req)); err != nil {
		t.Fatalf("first create: %v", err)
	}

	_, err := h.org.CreateFacility(ctx, as(token, req))
	if err == nil {
		t.Fatal("duplicate code accepted")
	}
	if got := connectCode(err); got != connect.CodeAlreadyExists {
		t.Fatalf("code = %v, want already_exists", got)
	}

	// The failed attempt must not have left a partial row or a stray event.
	var facilities, events int
	if err := h.pool.QueryRow(ctx,
		`SELECT (SELECT count(*) FROM organization.facility WHERE tenant_id = $1),
		        (SELECT count(*) FROM platform_data.outbox_event
		          WHERE tenant_id = $1 AND event_type = $2)`,
		tenantID, application.EventFacilityCreated).Scan(&facilities, &events); err != nil {
		t.Fatalf("count rows: %v", err)
	}
	if facilities != 1 || events != 1 {
		t.Fatalf("after rejected duplicate: %d facilities, %d events; want 1 and 1", facilities, events)
	}
}

var _ = platformtransport.HeaderCorrelationID
