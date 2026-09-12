package application_test

import (
	"context"
	"encoding/json"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	orgpostgres "github.com/ppusapati/health/code/internal/organization/adapters/postgres"
	"github.com/ppusapati/health/code/internal/organization/application"
	"github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/store"
)

// The master-data use cases are tested against a real database. Their two
// load-bearing behaviours — refusing a second pending change and refusing
// self-approval — are enforced by database constraints, and a fake would let
// both through while reporting green.

var now = time.Date(2026, 9, 11, 10, 0, 0, 0, time.UTC)

func day(y int, m time.Month, d int) time.Time {
	return time.Date(y, m, d, 0, 0, 0, 0, time.UTC)
}

type stubClock struct{ t time.Time }

func (c *stubClock) Now() time.Time { return c.t }

type uuidGen struct{}

func (uuidGen) NewID() string { return uuid.NewString() }

type harness struct {
	svc    *application.Service
	repo   *orgpostgres.Repository
	md     application.MasterDataPorts
	cfg    application.ConfigPorts
	clock  *stubClock
	pool   *pgxpool.Pool
	tenant string
	// facility is a real UUID, not a readable placeholder. The adapter rejects
	// a non-UUID facility rather than treating it as NULL — treating it as
	// NULL would silently widen an entitlement lookup from one ward to the
	// whole tenant — so a placeholder here would be testing a shape the
	// production code never sees.
	facility string
}

func newHarness(t *testing.T) harness {
	t.Helper()
	pool := pgtest.New(t)
	tx := pgtx.NewManager(pool)
	repo := orgpostgres.New(tx)
	platformStore := store.New(tx)
	clock := &stubClock{t: now}

	tenants := orgpostgres.TenantRepo{Repository: repo}
	tenant, err := domain.NewTenant(uuid.NewString(), "Apollo Group", "IN", "en-IN", "Asia/Kolkata", now)
	if err != nil {
		t.Fatalf("NewTenant: %v", err)
	}
	if err := tenant.TransitionTo(domain.TenantActive, now); err != nil {
		t.Fatalf("activate: %v", err)
	}
	if err := tenants.Insert(context.Background(), tenant); err != nil {
		t.Fatalf("insert tenant: %v", err)
	}

	svc := application.NewService(application.Deps{
		UnitOfWork: tx, Tenants: tenants,
		Facilities: orgpostgres.FacilityRepo{Repository: repo},
		Numbers:    repo,
		Events:     platformStore,
		Audits:     store.AuditAppenderFunc(platformStore.AppendAudit),
		IDs:        uuidGen{}, Clock: clock,
	})

	return harness{
		svc: svc, repo: repo, clock: clock, pool: pool, tenant: tenant.ID,
		facility: uuid.NewString(),
		md:       application.MasterDataPorts{Units: repo, Changes: repo, Entitlements: repo},
		cfg: application.ConfigPorts{
			Numbers: repo, Calendars: repo, Labels: repo, Tenants: tenants,
		},
	}
}

func (h harness) as(subject string, perms ...string) context.Context {
	return authctx.WithSession(context.Background(), authctx.Session{
		SubjectID: subject, TenantID: h.tenant,
		ActiveFacilityID:    h.facility,
		PermittedFacilities: []string{h.facility},
		Permissions:         perms,
		CorrelationID:       uuid.NewString(),
		RequestID:           uuid.NewString(),
	})
}

func (h harness) admin() context.Context {
	return h.as("admin-1",
		application.PermUnitManage, application.PermChangePropose,
		application.PermEntitlementSet, application.PermNumberIssue,
		application.PermCalendarManage, application.PermLabelManage)
}

func categoryOf(t *testing.T, err error) rpcerr.Category {
	t.Helper()
	if err == nil {
		t.Fatal("expected an error")
	}
	e, ok := rpcerr.As(err)
	if !ok {
		t.Fatalf("not a platform error: %v", err)
	}
	return e.Category
}

// --- SRS-PLT-005 ---

func TestCreateOrgUnitAndGateActivity(t *testing.T) {
	h := newHarness(t)
	ctx := h.admin()

	unit, err := h.svc.CreateOrgUnit(ctx, h.md, application.CreateOrgUnitInput{
		Type: domain.UnitDepartment, Code: "CARD", DisplayName: "Cardiology",
		EffectiveFrom: day(2024, time.January, 1), EffectiveUntil: day(2026, time.January, 1),
	})
	if err != nil {
		t.Fatalf("CreateOrgUnit: %v", err)
	}

	// Open period: accepted.
	if err := h.svc.AuthorizeUnitActivity(ctx, h.md, unit.ID, day(2025, time.June, 1)); err != nil {
		t.Fatalf("activity during the open period was refused: %v", err)
	}
	// After closure: refused, which is SRS-PLT-005's verification clause.
	err = h.svc.AuthorizeUnitActivity(ctx, h.md, unit.ID, day(2026, time.June, 1))
	if got := categoryOf(t, err); got != rpcerr.CategoryFailedPrecondition {
		t.Fatalf("want FAILED_PRECONDITION for an inactive unit, got %v", got)
	}
}

func TestCreateOrgUnitEmitsAnEvent(t *testing.T) {
	h := newHarness(t)
	unit, err := h.svc.CreateOrgUnit(h.admin(), h.md, application.CreateOrgUnitInput{
		Type: domain.UnitSpecialty, Code: "NEURO", DisplayName: "Neurology",
		EffectiveFrom: day(2026, time.January, 1),
	})
	if err != nil {
		t.Fatalf("CreateOrgUnit: %v", err)
	}

	var eventType string
	err = h.pool.QueryRow(context.Background(),
		`SELECT event_type FROM platform_data.outbox_event
		 WHERE tenant_id = $1 AND aggregate_id = $2`, h.tenant, unit.ID).Scan(&eventType)
	if err != nil {
		t.Fatalf("no outbox event for the new unit: %v", err)
	}
	if eventType != application.EventOrgUnitCreated {
		t.Fatalf("event type %q, want %q", eventType, application.EventOrgUnitCreated)
	}
}

func TestCreateOrgUnitNeedsThePermission(t *testing.T) {
	h := newHarness(t)
	_, err := h.svc.CreateOrgUnit(h.as("clerk"), h.md, application.CreateOrgUnitInput{
		Type: domain.UnitDepartment, Code: "CARD", DisplayName: "Cardiology",
		EffectiveFrom: day(2026, time.January, 1),
	})
	if got := categoryOf(t, err); got != rpcerr.CategoryPermissionDenied {
		t.Fatalf("want PERMISSION_DENIED, got %v", got)
	}
}

// --- SRS-PLT-008 and SRS-PLT-010 ---

func (h harness) propose(t *testing.T, entityID string) domain.MasterDataChange {
	t.Helper()
	c, err := h.svc.ProposeMasterDataChange(h.admin(), h.md, application.ProposeChangeInput{
		EntityType: "org_unit", EntityID: entityID,
		Proposed:      json.RawMessage(`{"display_name":"Cardiology and Vascular"}`),
		BaseVersion:   1,
		EffectiveFrom: day(2026, time.October, 1),
		Justification: "merging the vascular service into cardiology",
	})
	if err != nil {
		t.Fatalf("ProposeMasterDataChange: %v", err)
	}
	return c
}

// SRS-PLT-010: a subscriber receives an idempotent versioned event for an
// *approved* change. A proposal emits nothing, because a subscriber that acted
// on one would have to be told to undo it.
func TestOnlyApprovalEmitsAnEvent(t *testing.T) {
	h := newHarness(t)
	entityID := uuid.NewString()
	change := h.propose(t, entityID)

	countEvents := func() int {
		t.Helper()
		var n int
		err := h.pool.QueryRow(context.Background(),
			`SELECT count(*) FROM platform_data.outbox_event
			 WHERE tenant_id = $1 AND event_type = $2`,
			h.tenant, application.EventMasterDataApproved).Scan(&n)
		if err != nil {
			t.Fatalf("count events: %v", err)
		}
		return n
	}

	if countEvents() != 0 {
		t.Fatal("a pending proposal emitted an event")
	}

	checker := h.as("checker-1", application.PermChangeApprove)
	approved, err := h.svc.DecideMasterDataChange(checker, h.md, application.DecideChangeInput{
		ChangeID: change.ID, Approve: true,
		Note: "agreed with the clinical director", CurrentEntityVersion: 1,
	})
	if err != nil {
		t.Fatalf("DecideMasterDataChange: %v", err)
	}
	if approved.Status != domain.ChangeApproved {
		t.Fatalf("status %s", approved.Status)
	}
	if countEvents() != 1 {
		t.Fatal("approval emitted no event")
	}

	// The event carries the entity version, so a subscriber can discard one
	// that arrives after a newer change. Delivery is at-least-once and out of
	// order, and a cache that applies whatever came last will sometimes apply
	// the older one.
	var payload []byte
	err = h.pool.QueryRow(context.Background(),
		`SELECT payload FROM platform_data.outbox_event
		 WHERE tenant_id = $1 AND event_type = $2`,
		h.tenant, application.EventMasterDataApproved).Scan(&payload)
	if err != nil {
		t.Fatalf("read payload: %v", err)
	}
	var decoded struct {
		EntityID      string `json:"entity_id"`
		EntityVersion int64  `json:"entity_version"`
	}
	if err := json.Unmarshal(payload, &decoded); err != nil {
		t.Fatalf("decode payload: %v", err)
	}
	if decoded.EntityID != entityID {
		t.Fatalf("payload entity %q, want %q", decoded.EntityID, entityID)
	}
	if decoded.EntityVersion == 0 {
		t.Fatal("the event carries no entity version; a subscriber cannot detect a stale one")
	}
}

func TestRejectionEmitsNoEvent(t *testing.T) {
	h := newHarness(t)
	change := h.propose(t, uuid.NewString())

	checker := h.as("checker-1", application.PermChangeApprove)
	rejected, err := h.svc.DecideMasterDataChange(checker, h.md, application.DecideChangeInput{
		ChangeID: change.ID, Approve: false,
		Note: "the cost centre mapping is wrong", CurrentEntityVersion: 1,
	})
	if err != nil {
		t.Fatalf("DecideMasterDataChange: %v", err)
	}
	if rejected.Status != domain.ChangeRejected {
		t.Fatalf("status %s", rejected.Status)
	}

	var n int
	if err := h.pool.QueryRow(context.Background(),
		`SELECT count(*) FROM platform_data.outbox_event WHERE tenant_id = $1 AND event_type = $2`,
		h.tenant, application.EventMasterDataApproved).Scan(&n); err != nil {
		t.Fatalf("count: %v", err)
	}
	if n != 0 {
		t.Fatal("a rejection emitted an approval event")
	}
}

func TestSelfApprovalIsRefusedThroughTheService(t *testing.T) {
	h := newHarness(t)
	change := h.propose(t, uuid.NewString())

	// admin-1 proposed it, so admin-1 cannot decide it — even holding the
	// approval permission.
	sameUser := h.as("admin-1", application.PermChangeApprove)
	_, err := h.svc.DecideMasterDataChange(sameUser, h.md, application.DecideChangeInput{
		ChangeID: change.ID, Approve: true, Note: "looks fine to me", CurrentEntityVersion: 1,
	})
	if got := categoryOf(t, err); got != rpcerr.CategoryPermissionDenied {
		t.Fatalf("want PERMISSION_DENIED for self-approval, got %v", got)
	}
}

func TestStaleProposalIsRefusedThroughTheService(t *testing.T) {
	h := newHarness(t)
	change := h.propose(t, uuid.NewString())

	checker := h.as("checker-1", application.PermChangeApprove)
	_, err := h.svc.DecideMasterDataChange(checker, h.md, application.DecideChangeInput{
		ChangeID: change.ID, Approve: true, Note: "approved",
		CurrentEntityVersion: 7, // the entity moved since the proposal
	})
	if got := categoryOf(t, err); got != rpcerr.CategoryFailedPrecondition {
		t.Fatalf("want FAILED_PRECONDITION, got %v", got)
	}
}

// --- SRS-PLT-011 ---

func TestEntitlementCheckerResolvesThroughTheStore(t *testing.T) {
	h := newHarness(t)
	ctx := h.admin()
	checker := application.EntitlementChecker{Entitlements: h.repo, Clock: h.clock}
	session, _ := authctx.FromContext(ctx)

	// Nothing configured: denied by default.
	enabled, reason, err := checker.ModuleEnabled(ctx, session, "billing")
	if err != nil {
		t.Fatalf("ModuleEnabled: %v", err)
	}
	if enabled {
		t.Fatal("an unconfigured module was enabled")
	}
	if reason != domain.ReasonNotEntitled {
		t.Fatalf("reason %q, want %q", reason, domain.ReasonNotEntitled)
	}

	if _, err := h.svc.SetEntitlement(ctx, h.md, application.SetEntitlementInput{
		Module: "billing", Enabled: true, EffectiveFrom: day(2026, time.January, 1),
	}); err != nil {
		t.Fatalf("SetEntitlement: %v", err)
	}

	enabled, _, err = checker.ModuleEnabled(ctx, session, "billing")
	if err != nil {
		t.Fatalf("ModuleEnabled: %v", err)
	}
	if !enabled {
		t.Fatal("a granted module was still denied")
	}
}

// A facility-level denial must not be overridden by a tenant-wide grant, and
// must not leak to other wards.
func TestFacilityScopedEntitlement(t *testing.T) {
	h := newHarness(t)
	ctx := h.admin()
	checker := application.EntitlementChecker{Entitlements: h.repo, Clock: h.clock}

	if _, err := h.svc.SetEntitlement(ctx, h.md, application.SetEntitlementInput{
		Module: "scheduling", Enabled: true, EffectiveFrom: day(2026, time.January, 1),
	}); err != nil {
		t.Fatalf("SetEntitlement(tenant): %v", err)
	}

	facility := seedFacility(t, h)
	if _, err := h.svc.SetEntitlement(ctx, h.md, application.SetEntitlementInput{
		FacilityID: facility, Module: "scheduling", Enabled: false,
		EffectiveFrom: day(2026, time.January, 1),
	}); err != nil {
		t.Fatalf("SetEntitlement(facility): %v", err)
	}

	atFacility := authctx.WithSession(context.Background(), authctx.Session{
		SubjectID: "clerk", TenantID: h.tenant, ActiveFacilityID: facility,
		PermittedFacilities: []string{facility}, CorrelationID: uuid.NewString(),
	})
	session, _ := authctx.FromContext(atFacility)
	enabled, reason, err := checker.ModuleEnabled(atFacility, session, "scheduling")
	if err != nil {
		t.Fatalf("ModuleEnabled: %v", err)
	}
	if enabled {
		t.Fatal("the facility-level denial was overridden by the tenant-wide grant")
	}
	if reason != domain.ReasonModuleDisabled {
		t.Fatalf("reason %q, want %q", reason, domain.ReasonModuleDisabled)
	}

	// Elsewhere in the group it is still on.
	elsewhere, _ := authctx.FromContext(ctx)
	if enabled, _, _ := checker.ModuleEnabled(ctx, elsewhere, "scheduling"); !enabled {
		t.Fatal("one ward's denial disabled the module everywhere")
	}
}

func seedFacility(t *testing.T, h harness) string {
	t.Helper()
	fac, err := h.svc.CreateFacility(h.as("admin-1", "organization.facility.create"),
		application.CreateFacilityInput{
			Code: "FAC01", DisplayName: "Main Hospital",
			Type: domain.FacilityHospital, TimeZone: "Asia/Kolkata",
		})
	if err != nil {
		t.Fatalf("CreateFacility: %v", err)
	}
	return fac.ID
}

// --- SRS-PLT-014 ---

func TestIssueNumberThroughTheService(t *testing.T) {
	h := newHarness(t)
	ctx := h.admin()
	session, _ := authctx.FromContext(ctx)

	seq, err := domain.NewNumberSequence(uuid.NewString(), h.tenant, "",
		domain.ScopeMRN, "MRN-", 6, 1, "", now)
	if err != nil {
		t.Fatalf("NewNumberSequence: %v", err)
	}
	if err := h.repo.EnsureSequence(ctx, session.TenantScope(), seq); err != nil {
		t.Fatalf("EnsureSequence: %v", err)
	}

	first, err := h.svc.IssueNumber(ctx, h.cfg, application.IssueNumberInput{Scope: domain.ScopeMRN})
	if err != nil {
		t.Fatalf("IssueNumber: %v", err)
	}
	if first != "MRN-000001" {
		t.Fatalf("first number %s", first)
	}
	second, err := h.svc.IssueNumber(ctx, h.cfg, application.IssueNumberInput{Scope: domain.ScopeMRN})
	if err != nil {
		t.Fatalf("IssueNumber: %v", err)
	}
	if second != "MRN-000002" {
		t.Fatalf("second number %s", second)
	}
}

// The tenant's timezone decides the period, not the server's. A hospital in
// Kolkata issuing at 02:00 local on 1 April is in the new fiscal year.
func TestPeriodResetUsesTheTenantTimezone(t *testing.T) {
	h := newHarness(t)
	ctx := h.admin()
	session, _ := authctx.FromContext(ctx)

	// 2026-03-31 20:30 UTC is 2026-04-01 02:00 in Asia/Kolkata, the tenant's
	// configured zone.
	h.clock.t = time.Date(2026, 3, 31, 20, 30, 0, 0, time.UTC)

	seq, err := domain.NewNumberSequence(uuid.NewString(), h.tenant, "",
		domain.ScopeInvoice, "INV/2026-04/", 4, 1, "2026-04", h.clock.t)
	if err != nil {
		t.Fatalf("NewNumberSequence: %v", err)
	}
	if err := h.repo.EnsureSequence(ctx, session.TenantScope(), seq); err != nil {
		t.Fatalf("EnsureSequence: %v", err)
	}

	number, err := h.svc.IssueNumber(ctx, h.cfg, application.IssueNumberInput{
		Scope: domain.ScopeInvoice, ResetPolicy: "monthly",
	})
	if err != nil {
		t.Fatalf("IssueNumber: %v — the April sequence was not selected, so the "+
			"period was derived in the wrong timezone", err)
	}
	if !strings.HasPrefix(number, "INV/2026-04/") {
		t.Fatalf("number %s is not in the April series", number)
	}
}
