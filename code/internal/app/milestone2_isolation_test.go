package app_test

import (
	"bytes"
	"context"
	"errors"
	"testing"

	"connectrpc.com/connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	orgpostgres "github.com/ppusapati/health/code/internal/organization/adapters/postgres"
	"github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/organization/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/blobstore"
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

// The object store is inside the isolation boundary, not beside it.
//
// Gate A2 carried the qualifier "object store is not yet in the stack" from
// Wave 0, when it was true. Sprint 6 put one there (SRS-DAT-007), and an
// object store is precisely where a tenant boundary gets quietly lost: the
// bytes live outside PostgreSQL, so none of the row-level scoping the rest of
// A2 proves applies to them. A scanned consent form, a wound photograph and a
// signature are all PHI that the database never sees.
//
// These exercise the vault the application was actually built with, reached
// through h.blobs, rather than a second vault configured the same way.
func TestCrossTenantBlobReadIsNotFound(t *testing.T) {
	h := newHarness(t)
	fx := setupTwoTenants(t, h)
	ctx := context.Background()

	scopeA := blobScope(fx.tenantA)
	scopeB := blobScope(fx.tenantB)

	consent := []byte("tenant A signed consent form")
	object, err := h.blobs.Put(ctx, scopeA, blobstore.ClassClinicalAttachment,
		"application/pdf", consent)
	if err != nil {
		t.Fatalf("tenant A Put: %v", err)
	}

	// Tenant B holding tenant A's exact reference — the leaked-row case, which
	// is the only way B ever learns a reference at all.
	if _, err := h.blobs.Get(ctx, scopeB, object.Reference); err == nil {
		t.Fatal("object store served another tenant's content")
	} else if !errors.Is(err, blobstore.ErrNotFound) {
		// Not found rather than forbidden: a reference that answers
		// "forbidden" has confirmed it exists, which is the fact the probe
		// wanted. Same reasoning as NOT_FOUND over the RPC boundary above.
		t.Fatalf("cross-tenant read: want ErrNotFound, got %v", err)
	}

	got, err := h.blobs.Get(ctx, scopeA, object.Reference)
	if err != nil {
		t.Fatalf("owning tenant denied its own object: %v", err)
	}
	if !bytes.Equal(got, consent) {
		t.Fatal("owning tenant got back content it did not store")
	}
}

// A cross-tenant delete is worse than a cross-tenant read: the read leaks,
// the delete destroys. Tested separately because Get and Delete are separate
// entry points and a tenant check on one is not a tenant check on the other.
func TestCrossTenantBlobDeleteDoesNothing(t *testing.T) {
	h := newHarness(t)
	fx := setupTwoTenants(t, h)
	ctx := context.Background()

	scopeA := blobScope(fx.tenantA)
	scopeB := blobScope(fx.tenantB)

	image := []byte("tenant A wound photograph")
	object, err := h.blobs.Put(ctx, scopeA, blobstore.ClassWoundImage, "image/jpeg", image)
	if err != nil {
		t.Fatalf("tenant A Put: %v", err)
	}

	// Delete is idempotent by design, so "no error" would be the answer for an
	// object that was already gone. What matters is the effect, asserted
	// below: A's object is still there.
	if err := h.blobs.Delete(ctx, scopeB, object.Reference); err == nil {
		t.Fatal("object store accepted a delete of another tenant's content")
	} else if !errors.Is(err, blobstore.ErrNotFound) {
		t.Fatalf("cross-tenant delete: want ErrNotFound, got %v", err)
	}

	got, err := h.blobs.Get(ctx, scopeA, object.Reference)
	if err != nil {
		t.Fatalf("tenant A's object did not survive tenant B's delete: %v", err)
	}
	if !bytes.Equal(got, image) {
		t.Fatal("tenant A's content changed under tenant B's delete")
	}
}

// Two tenants storing byte-identical content must not end up sharing one
// object.
//
// This is the failure mode that content-addressed storage invites: key on the
// digest, notice that the same bytes are already stored, and "deduplicate".
// Then one tenant withdrawing consent deletes the other tenant's document, and
// a tenant can confirm another tenant holds a particular file by storing it
// and watching the write get skipped. The tenant is the first path segment
// here precisely so that identical content is two objects.
func TestIdenticalContentInTwoTenantsIsTwoObjects(t *testing.T) {
	h := newHarness(t)
	fx := setupTwoTenants(t, h)
	ctx := context.Background()

	scopeA := blobScope(fx.tenantA)
	scopeB := blobScope(fx.tenantB)

	// A blank consent form both hospitals print from the same template: the
	// realistic way two tenants come to hold identical bytes.
	form := []byte("MINISTRY OF HEALTH :: CONSENT FORM 2B :: (blank)")

	objectA, err := h.blobs.Put(ctx, scopeA, blobstore.ClassClinicalAttachment,
		"application/pdf", form)
	if err != nil {
		t.Fatalf("tenant A Put: %v", err)
	}
	objectB, err := h.blobs.Put(ctx, scopeB, blobstore.ClassClinicalAttachment,
		"application/pdf", form)
	if err != nil {
		t.Fatalf("tenant B Put: %v", err)
	}

	if objectA.Digest != objectB.Digest {
		t.Fatal("identical content hashed differently; the digests should match")
	}

	// The references differ, but that alone proves nothing: every Put mints a
	// fresh object id, so two uploads of the same bytes into the SAME tenant
	// differ too. What has to be true is where the bytes landed — each under
	// its own tenant's prefix, which is what lets a bucket policy grant access
	// per tenant as defence in depth behind this check.
	refA, err := blobstore.ParseReference(objectA.Reference)
	if err != nil {
		t.Fatalf("parse tenant A reference: %v", err)
	}
	refB, err := blobstore.ParseReference(objectB.Reference)
	if err != nil {
		t.Fatalf("parse tenant B reference: %v", err)
	}
	if refA.TenantID != fx.tenantA {
		t.Fatalf("tenant A's object is stored under %q, not %q", refA.TenantID, fx.tenantA)
	}
	if refB.TenantID != fx.tenantB {
		t.Fatalf("tenant B's object is stored under %q, not %q", refB.TenantID, fx.tenantB)
	}

	// The destructive half: A withdraws consent, B still has its copy.
	if err := h.blobs.Delete(ctx, scopeA, objectA.Reference); err != nil {
		t.Fatalf("tenant A Delete: %v", err)
	}
	got, err := h.blobs.Get(ctx, scopeB, objectB.Reference)
	if err != nil {
		t.Fatalf("tenant B's copy was destroyed by tenant A's delete: %v", err)
	}
	if !bytes.Equal(got, form) {
		t.Fatal("tenant B's copy changed when tenant A deleted theirs")
	}
}

// An empty TenantScope must fail closed at the object store the same way it
// does at the repository, rather than writing to a tenant-less prefix that
// every tenant can then read.
func TestZeroTenantScopeIsRefusedByTheObjectStore(t *testing.T) {
	h := newHarness(t)
	ctx := context.Background()

	var zero authctx.TenantScope

	if _, err := h.blobs.Put(ctx, zero, blobstore.ClassSignature, "image/png",
		[]byte("a signature")); err == nil {
		t.Fatal("zero scope was accepted by Put")
	}
	if _, err := h.blobs.Get(ctx, zero, "filesystem/t/signature/o/d"); err == nil {
		t.Fatal("zero scope was accepted by Get")
	}
	if err := h.blobs.Delete(ctx, zero, "filesystem/t/signature/o/d"); err == nil {
		t.Fatal("zero scope was accepted by Delete")
	}
}

// blobScope builds the tenant scope the object store is called with. The
// subject is an attacker's by name: every caller here is reaching for content
// stored by somebody else.
func blobScope(tenantID string) authctx.TenantScope {
	return authctx.NewSession(authctx.Session{
		SubjectID: "attacker", TenantID: tenantID,
	}).TenantScope()
}
