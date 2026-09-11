package app_test

import (
	"context"
	"testing"

	"connectrpc.com/connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	orgpostgres "github.com/ppusapati/health/code/internal/organization/adapters/postgres"
	"github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/organization/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
)

// twoTenants provisions tenant A with one facility and an empty tenant B.
type twoTenants struct {
	tenantA   string
	tenantB   string
	facilityA string
	tokenA    string
	tokenB    string
}

func setupTwoTenants(t *testing.T, h *harness) twoTenants {
	t.Helper()
	ctx := context.Background()

	tenantA := h.provisionTenant(t, "Tenant A Hospitals")
	tenantB := h.provisionTenant(t, "Tenant B Hospitals")

	tokenA := tenantAdminToken(tenantA)
	tokenB := tenantAdminToken(tenantB)

	created, err := h.org.CreateFacility(ctx, as(tokenA, &organizationv1.CreateFacilityRequest{
		Code:        "MAIN",
		DisplayName: "Tenant A Main Hospital",
		Type:        organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL,
		TimeZone:    "Asia/Kolkata",
	}))
	if err != nil {
		t.Fatalf("tenant A CreateFacility: %v", err)
	}

	return twoTenants{
		tenantA:   tenantA,
		tenantB:   tenantB,
		facilityA: created.Msg.GetFacility().GetFacilityId(),
		tokenA:    tokenA,
		tokenB:    tokenB,
	}
}

// TestMilestone2_CrossTenantReadDeniedOverRPC is the second Wave-0 milestone:
//
//	Tenant A creates a record -> Tenant B attempts to access it -> DENIED
//
// Gate A2, SRS-PLT-003, SRS-IAM-013, SRS-SEC-011.
func TestMilestone2_CrossTenantReadDeniedOverRPC(t *testing.T) {
	h := newHarness(t)
	fx := setupTwoTenants(t, h)
	ctx := context.Background()

	// Tenant B holds the facility.read permission and supplies a real, valid
	// facility ID. Only the tenant differs — so this test isolates tenancy
	// from every other access control.
	_, err := h.org.GetFacility(ctx, as(fx.tokenB, &organizationv1.GetFacilityRequest{
		FacilityId: fx.facilityA,
	}))
	if err == nil {
		t.Fatal("tenant B read tenant A's facility")
	}

	// NOT_FOUND rather than PERMISSION_DENIED: a probe must not be able to
	// confirm that the identifier exists somewhere in the platform.
	if got := connectCode(err); got != connect.CodeNotFound {
		t.Fatalf("code = %v, want not_found (concealment, not refusal)", got)
	}

	// Tenant A can still read it, proving the denial is about tenancy and not
	// a broken fixture.
	if _, err := h.org.GetFacility(ctx, as(fx.tokenA, &organizationv1.GetFacilityRequest{
		FacilityId: fx.facilityA,
	})); err != nil {
		t.Fatalf("tenant A cannot read its own facility: %v", err)
	}
}

// A listing must never spill another tenant's rows.
func TestCrossTenantListReturnsNothing(t *testing.T) {
	h := newHarness(t)
	fx := setupTwoTenants(t, h)
	ctx := context.Background()

	resp, err := h.org.ListFacilities(ctx, as(fx.tokenB, &organizationv1.ListFacilitiesRequest{}))
	if err != nil {
		t.Fatalf("tenant B ListFacilities: %v", err)
	}
	if len(resp.Msg.GetFacilities()) != 0 {
		t.Fatalf("tenant B saw %d facilities", len(resp.Msg.GetFacilities()))
	}

	own, err := h.org.ListFacilities(ctx, as(fx.tokenA, &organizationv1.ListFacilitiesRequest{}))
	if err != nil {
		t.Fatalf("tenant A ListFacilities: %v", err)
	}
	if len(own.Msg.GetFacilities()) != 1 {
		t.Fatalf("tenant A saw %d facilities, want 1", len(own.Msg.GetFacilities()))
	}
}

// Two tenants may legitimately use the same facility code; uniqueness is
// per-tenant, so this must succeed rather than collide.
func TestSameFacilityCodeAllowedInDifferentTenants(t *testing.T) {
	h := newHarness(t)
	fx := setupTwoTenants(t, h)

	_, err := h.org.CreateFacility(context.Background(),
		as(fx.tokenB, &organizationv1.CreateFacilityRequest{
			Code:        "MAIN",
			DisplayName: "Tenant B Main Hospital",
			Type:        organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL,
			TimeZone:    "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("tenant B could not reuse code MAIN: %v", err)
	}
}

// Tenant scope must hold at the repository layer too, not only at the RPC
// boundary — otherwise a future in-process caller would bypass it.
func TestCrossTenantDeniedAtRepositoryLayer(t *testing.T) {
	h := newHarness(t)
	fx := setupTwoTenants(t, h)
	ctx := context.Background()

	repo := orgpostgres.FacilityRepo{Repository: orgpostgres.New(pgtx.NewManager(h.pool))}

	scopeB := authctx.NewSession(authctx.Session{
		SubjectID: "attacker", TenantID: fx.tenantB,
	}).TenantScope()

	if _, err := repo.GetByID(ctx, scopeB, fx.facilityA); err == nil {
		t.Fatal("repository returned another tenant's facility")
	}

	items, _, err := repo.List(ctx, scopeB, ports.FacilityFilter{PageSize: 50})
	if err != nil {
		t.Fatalf("List: %v", err)
	}
	if len(items) != 0 {
		t.Fatalf("repository listed %d rows for the wrong tenant", len(items))
	}

	scopeA := authctx.NewSession(authctx.Session{
		SubjectID: "admin", TenantID: fx.tenantA,
	}).TenantScope()
	if _, err := repo.GetByID(ctx, scopeA, fx.facilityA); err != nil {
		t.Fatalf("owning tenant denied at repository: %v", err)
	}
}

// An empty TenantScope must fail closed rather than degrade into an unscoped
// query that returns every tenant's rows.
func TestZeroTenantScopeIsRefusedByRepository(t *testing.T) {
	h := newHarness(t)
	_ = setupTwoTenants(t, h)
	ctx := context.Background()

	repo := orgpostgres.FacilityRepo{Repository: orgpostgres.New(pgtx.NewManager(h.pool))}

	var zero authctx.TenantScope
	if _, err := repo.GetByID(ctx, zero, "any"); err == nil {
		t.Fatal("zero scope was accepted by GetByID")
	}
	if _, _, err := repo.List(ctx, zero, ports.FacilityFilter{PageSize: 10}); err == nil {
		t.Fatal("zero scope was accepted by List")
	}
	if _, err := repo.ExistsByCode(ctx, zero, "MAIN"); err == nil {
		t.Fatal("zero scope was accepted by ExistsByCode")
	}
}

// Outbox rows carry tenant scope so downstream consumers inherit the same
// boundary rather than re-deriving it.
func TestOutboxEventsAreTenantScoped(t *testing.T) {
	h := newHarness(t)
	fx := setupTwoTenants(t, h)
	ctx := context.Background()

	var leaked int
	if err := h.pool.QueryRow(ctx,
		`SELECT count(*) FROM platform_data.outbox_event
		  WHERE tenant_id = $1 AND aggregate_id = $2`,
		fx.tenantB, fx.facilityA).Scan(&leaked); err != nil {
		t.Fatalf("query outbox: %v", err)
	}
	if leaked != 0 {
		t.Fatalf("tenant B's event stream contains %d of tenant A's aggregates", leaked)
	}

	var nullTenants int
	if err := h.pool.QueryRow(ctx,
		`SELECT count(*) FROM platform_data.outbox_event WHERE tenant_id IS NULL`).
		Scan(&nullTenants); err != nil {
		t.Fatalf("query outbox: %v", err)
	}
	if nullTenants != 0 {
		t.Fatalf("%d outbox events have no tenant scope", nullTenants)
	}
}

// Audit records are tenant-scoped for the same reason: a reviewer for tenant B
// must not see tenant A's activity.
func TestAuditRecordsAreTenantScoped(t *testing.T) {
	h := newHarness(t)
	fx := setupTwoTenants(t, h)
	ctx := context.Background()

	var count int
	if err := h.pool.QueryRow(ctx,
		`SELECT count(*) FROM platform_data.audit_record
		  WHERE tenant_id = $1 AND resource_id = $2`,
		fx.tenantB, fx.facilityA).Scan(&count); err != nil {
		t.Fatalf("query audit: %v", err)
	}
	if count != 0 {
		t.Fatalf("tenant B's audit trail contains %d of tenant A's resources", count)
	}
}

// A refused cross-tenant attempt must leave a reviewable trace; a silent denial
// is invisible to a SOC.
func TestDeniedCrossTenantAttemptIsAudited(t *testing.T) {
	h := newHarness(t)
	fx := setupTwoTenants(t, h)
	ctx := context.Background()

	// A viewer in tenant B lacks facility.create, so this is denied by policy
	// and must be recorded as such.
	_, err := h.org.CreateFacility(ctx, as(viewerToken(fx.tenantB), &organizationv1.CreateFacilityRequest{
		Code:        "SNEAK",
		DisplayName: "Unauthorised",
		Type:        organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL,
		TimeZone:    "Asia/Kolkata",
	}))
	if err == nil {
		t.Fatal("viewer created a facility")
	}
	if got := connectCode(err); got != connect.CodePermissionDenied {
		t.Fatalf("code = %v, want permission_denied", got)
	}

	var reason string
	if err := h.pool.QueryRow(ctx,
		`SELECT reason FROM platform_data.audit_record
		  WHERE tenant_id = $1 AND outcome = 'denied' ORDER BY occurred_at DESC LIMIT 1`,
		fx.tenantB).Scan(&reason); err != nil {
		t.Fatalf("denied attempt was not audited: %v", err)
	}
	if reason != "PERMISSION_NOT_GRANTED" {
		t.Fatalf("audit reason = %q", reason)
	}
}

// A suspended tenant stays readable but refuses writes (SRS-PLT-020).
func TestSuspendedTenantIsReadOnly(t *testing.T) {
	h := newHarness(t)
	fx := setupTwoTenants(t, h)
	ctx := context.Background()

	if _, err := h.pool.Exec(ctx,
		`UPDATE organization.tenant SET status = $1 WHERE tenant_id = $2`,
		string(domain.TenantSuspended), fx.tenantA); err != nil {
		t.Fatalf("suspend tenant: %v", err)
	}

	if _, err := h.org.GetFacility(ctx, as(fx.tokenA, &organizationv1.GetFacilityRequest{
		FacilityId: fx.facilityA,
	})); err != nil {
		t.Fatalf("suspended tenant must remain readable: %v", err)
	}

	_, err := h.org.CreateFacility(ctx, as(fx.tokenA, &organizationv1.CreateFacilityRequest{
		Code:        "SECOND",
		DisplayName: "Second Hospital",
		Type:        organizationv1.FacilityType_FACILITY_TYPE_CLINIC,
		TimeZone:    "Asia/Kolkata",
	}))
	if err == nil {
		t.Fatal("suspended tenant accepted a write")
	}
	if got := connectCode(err); got != connect.CodePermissionDenied {
		t.Fatalf("code = %v, want permission_denied", got)
	}
}

// A tenant-scoped admin must not be able to reach cross-tenant provisioning
// authority, however many facility permissions it holds.
func TestTenantAdminCannotProvisionTenants(t *testing.T) {
	h := newHarness(t)
	fx := setupTwoTenants(t, h)

	_, err := h.org.CreateTenant(context.Background(),
		as(fx.tokenA, &organizationv1.CreateTenantRequest{
			DisplayName:       "Rogue Tenant",
			LegalJurisdiction: "IN",
			DefaultLocale:     "en-IN",
			TimeZone:          "Asia/Kolkata",
		}))
	if err == nil {
		t.Fatal("tenant admin provisioned a tenant")
	}
	if got := connectCode(err); got != connect.CodePermissionDenied {
		t.Fatalf("code = %v, want permission_denied", got)
	}
}
