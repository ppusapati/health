package postgres_test

import (
	"context"
	"errors"
	"sync"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/security/domain"
)

func grant(tenant string, ttl time.Duration) domain.EmergencyGrant {
	g, err := domain.NewEmergencyGrant(
		uuid.NewString(), tenant, "dr-singh", "fac-1", "INC-2026-0412",
		"unconscious patient admitted from another facility", uuid.NewString(),
		[]string{"clinical.read"}, []string{"clinical.read", "clinical.write"},
		ttl, false, at)
	if err != nil {
		panic(err)
	}
	return g
}

func TestEmergencyGrantRoundTrip(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	g := grant(f.tenant, time.Hour)

	if err := f.repo.InsertGrant(ctx, f.scope, g); err != nil {
		t.Fatalf("InsertGrant: %v", err)
	}

	got, err := f.repo.GetGrant(ctx, f.scope, g.ID)
	if err != nil {
		t.Fatalf("GetGrant: %v", err)
	}
	if got.IncidentRef != g.IncidentRef || got.SubjectID != g.SubjectID {
		t.Fatalf("round trip lost fields: %+v", got)
	}
	if len(got.Permissions) != 1 || got.Permissions[0] != "clinical.read" {
		t.Fatalf("permissions lost: %v", got.Permissions)
	}
	if got.Status != domain.EmergencyActive {
		t.Fatalf("want active, got %s", got.Status)
	}
	if !got.ExpiresAt.Equal(g.ExpiresAt) {
		t.Fatalf("expiry moved: %s vs %s", got.ExpiresAt, g.ExpiresAt)
	}
}

// The bounded TTL is only a bound if a subject cannot hold two grants at once.
// The check lives in a partial unique index rather than in Go, so two
// concurrent activations cannot both observe "no active grant".
func TestConcurrentActivationsCannotStack(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	const attempts = 8
	var wg sync.WaitGroup
	results := make([]error, attempts)
	start := make(chan struct{})

	for i := range attempts {
		wg.Add(1)
		go func() {
			defer wg.Done()
			<-start
			results[i] = f.repo.InsertGrant(ctx, f.scope, grant(f.tenant, time.Hour))
		}()
	}
	close(start)
	wg.Wait()

	var succeeded, refused int
	for _, err := range results {
		switch {
		case err == nil:
			succeeded++
		case errors.Is(err, domain.ErrGrantAlreadyActive):
			refused++
		default:
			t.Fatalf("unexpected error: %v", err)
		}
	}
	if succeeded != 1 {
		t.Fatalf("want exactly one activation to succeed, got %d", succeeded)
	}
	if refused != attempts-1 {
		t.Fatalf("want %d refusals, got %d", attempts-1, refused)
	}
}

// A closed grant frees the subject to declare a second, genuinely separate
// emergency. The index is partial for exactly this reason.
func TestClosingAGrantAllowsTheNextEmergency(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	first := grant(f.tenant, time.Hour)

	if err := f.repo.InsertGrant(ctx, f.scope, first); err != nil {
		t.Fatalf("InsertGrant: %v", err)
	}
	if err := f.repo.CloseGrant(ctx, f.scope, first.ID, at.Add(20*time.Minute)); err != nil {
		t.Fatalf("CloseGrant: %v", err)
	}
	if err := f.repo.InsertGrant(ctx, f.scope, grant(f.tenant, time.Hour)); err != nil {
		t.Fatalf("second activation after close: %v", err)
	}
}

// Access is recorded once per resource. A clinician re-reading the same record
// must not inflate the list the reviewer reads.
func TestRecordAccessIsDeduplicatedAndBoundedByExpiry(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	g := grant(f.tenant, time.Hour)
	if err := f.repo.InsertGrant(ctx, f.scope, g); err != nil {
		t.Fatalf("InsertGrant: %v", err)
	}

	during := at.Add(10 * time.Minute)
	for _, ref := range []string{"patient/p1", "patient/p1", "patient/p2"} {
		if err := f.repo.RecordAccess(ctx, f.scope, g.ID, ref, during); err != nil {
			t.Fatalf("RecordAccess(%s): %v", ref, err)
		}
	}
	got, err := f.repo.GetGrant(ctx, f.scope, g.ID)
	if err != nil {
		t.Fatalf("GetGrant: %v", err)
	}
	if len(got.AccessedResources) != 2 {
		t.Fatalf("want 2 distinct resources, got %v", got.AccessedResources)
	}

	// Past the window the statement refuses, even though the sweeper has not
	// run and the row still says 'active'. That is the property: the bound is
	// the clock, not a background job's schedule.
	err = f.repo.RecordAccess(ctx, f.scope, g.ID, "patient/p3", at.Add(2*time.Hour))
	if !errors.Is(err, domain.ErrGrantNotActive) {
		t.Fatalf("want ErrGrantNotActive past expiry, got %v", err)
	}
}

func TestExpireSweepIsIdempotent(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	g := grant(f.tenant, time.Hour)
	if err := f.repo.InsertGrant(ctx, f.scope, g); err != nil {
		t.Fatalf("InsertGrant: %v", err)
	}

	swept, err := f.repo.ExpireGrants(ctx, at.Add(2*time.Hour))
	if err != nil {
		t.Fatalf("ExpireGrants: %v", err)
	}
	if swept != 1 {
		t.Fatalf("want 1 grant swept, got %d", swept)
	}
	first, err := f.repo.GetGrant(ctx, f.scope, g.ID)
	if err != nil {
		t.Fatalf("GetGrant: %v", err)
	}

	// The sweeper is at-least-once, so a second pass must not move closed_at.
	if _, err := f.repo.ExpireGrants(ctx, at.Add(3*time.Hour)); err != nil {
		t.Fatalf("second sweep: %v", err)
	}
	second, err := f.repo.GetGrant(ctx, f.scope, g.ID)
	if err != nil {
		t.Fatalf("GetGrant: %v", err)
	}
	if !first.ClosedAt.Equal(second.ClosedAt) {
		t.Fatalf("second sweep moved ClosedAt from %s to %s", first.ClosedAt, second.ClosedAt)
	}
}

// Self-review is refused by the statement, not only by the domain, so a caller
// that reached the store directly still cannot sign off its own access.
func TestSelfReviewIsRefusedByTheDatabase(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	g := grant(f.tenant, time.Hour)
	if err := f.repo.InsertGrant(ctx, f.scope, g); err != nil {
		t.Fatalf("InsertGrant: %v", err)
	}
	if err := f.repo.CloseGrant(ctx, f.scope, g.ID, at.Add(time.Minute)); err != nil {
		t.Fatalf("CloseGrant: %v", err)
	}

	g.Status = domain.EmergencyReviewed
	g.ReviewedBy = g.SubjectID // the activator
	g.ReviewedAt = at.Add(time.Hour)
	g.ReviewNote = "nothing to see here"
	if err := f.repo.ReviewGrant(ctx, f.scope, g, at.Add(time.Hour)); err == nil {
		t.Fatal("the database accepted a self-review")
	}

	g.ReviewedBy = "chief-medical-officer"
	g.ReviewNote = "access matched the incident"
	if err := f.repo.ReviewGrant(ctx, f.scope, g, at.Add(time.Hour)); err != nil {
		t.Fatalf("ReviewGrant: %v", err)
	}
	got, err := f.repo.GetGrant(ctx, f.scope, g.ID)
	if err != nil {
		t.Fatalf("GetGrant: %v", err)
	}
	if got.Status != domain.EmergencyReviewed || got.ReviewedBy != "chief-medical-officer" {
		t.Fatalf("review not recorded: %+v", got)
	}
}

// Tenant isolation, at the repository layer: tenant B must not see, use or
// review tenant A's grant, and a cross-tenant read is NOT_FOUND rather than
// a denial that would confirm the id exists.
func TestEmergencyGrantIsTenantScoped(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	g := grant(f.tenant, time.Hour)
	if err := f.repo.InsertGrant(ctx, f.scope, g); err != nil {
		t.Fatalf("InsertGrant: %v", err)
	}

	other := authctx.NewSession(authctx.Session{
		SubjectID: "intruder", TenantID: uuid.NewString(),
	}).TenantScope()

	if _, err := f.repo.GetGrant(ctx, other, g.ID); err == nil {
		t.Fatal("tenant B read tenant A's emergency grant")
	}
	if err := f.repo.RecordAccess(ctx, other, g.ID, "patient/p1", at.Add(time.Minute)); err == nil {
		t.Fatal("tenant B recorded access against tenant A's grant")
	}
	if err := f.repo.CloseGrant(ctx, other, g.ID, at.Add(time.Minute)); err == nil {
		t.Fatal("tenant B closed tenant A's grant")
	}

	// And tenant A's grant is untouched by all of that.
	got, err := f.repo.GetGrant(ctx, f.scope, g.ID)
	if err != nil {
		t.Fatalf("GetGrant: %v", err)
	}
	if got.Status != domain.EmergencyActive || len(got.AccessedResources) != 0 {
		t.Fatalf("tenant A's grant was modified: %+v", got)
	}
}

// Two tenants may each have an active grant for a subject with the same id.
// Subject identifiers are not globally unique, so a non-tenanted index would
// deny a legitimate emergency in one hospital because of another's.
func TestActiveGrantIndexIsPerTenant(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	if err := f.repo.InsertGrant(ctx, f.scope, grant(f.tenant, time.Hour)); err != nil {
		t.Fatalf("InsertGrant: %v", err)
	}

	otherTenant := uuid.NewString()
	otherScope := authctx.NewSession(authctx.Session{
		SubjectID: "admin", TenantID: otherTenant,
	}).TenantScope()
	if err := f.repo.InsertGrant(ctx, otherScope, grant(otherTenant, time.Hour)); err != nil {
		t.Fatalf("a second tenant's grant for the same subject id was refused: %v", err)
	}
}

func TestActiveGrantForFindsOnlyLiveGrants(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	if _, ok, err := f.repo.ActiveGrantFor(ctx, f.scope, "dr-singh"); err != nil || ok {
		t.Fatalf("want no active grant, got ok=%v err=%v", ok, err)
	}

	g := grant(f.tenant, time.Hour)
	if err := f.repo.InsertGrant(ctx, f.scope, g); err != nil {
		t.Fatalf("InsertGrant: %v", err)
	}
	found, ok, err := f.repo.ActiveGrantFor(ctx, f.scope, "dr-singh")
	if err != nil || !ok {
		t.Fatalf("want the active grant, got ok=%v err=%v", ok, err)
	}
	if found.ID != g.ID {
		t.Fatalf("wrong grant: %s", found.ID)
	}

	if err := f.repo.CloseGrant(ctx, f.scope, g.ID, at.Add(time.Minute)); err != nil {
		t.Fatalf("CloseGrant: %v", err)
	}
	if _, ok, _ := f.repo.ActiveGrantFor(ctx, f.scope, "dr-singh"); ok {
		t.Fatal("a closed grant is still reported active")
	}
}

func TestGrantsAwaitingReview(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	g := grant(f.tenant, time.Hour)
	if err := f.repo.InsertGrant(ctx, f.scope, g); err != nil {
		t.Fatalf("InsertGrant: %v", err)
	}
	// An active grant is not yet reviewable: the access is still happening.
	pending, err := f.repo.GrantsAwaitingReview(ctx, f.scope, 10)
	if err != nil {
		t.Fatalf("GrantsAwaitingReview: %v", err)
	}
	if len(pending) != 0 {
		t.Fatalf("an active grant appeared in the review queue: %v", pending)
	}

	if _, err := f.repo.ExpireGrants(ctx, at.Add(2*time.Hour)); err != nil {
		t.Fatalf("ExpireGrants: %v", err)
	}
	pending, err = f.repo.GrantsAwaitingReview(ctx, f.scope, 10)
	if err != nil {
		t.Fatalf("GrantsAwaitingReview: %v", err)
	}
	if len(pending) != 1 || pending[0].ID != g.ID {
		t.Fatalf("expired grant missing from the review queue: %v", pending)
	}
}

// A grant whose window has passed is reviewable even while the row still reads
// 'active', because the sweeper is a background job and a reviewer working
// promptly should not be told to come back later. The statement judges "ended"
// against the clock, matching RecordEmergencyAccess, which refuses on the same
// predicate.
func TestReviewDoesNotWaitForTheSweeper(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	g := grant(f.tenant, time.Hour)
	if err := f.repo.InsertGrant(ctx, f.scope, g); err != nil {
		t.Fatalf("InsertGrant: %v", err)
	}

	g.Status = domain.EmergencyReviewed
	g.ReviewedBy = "chief-medical-officer"
	g.ReviewedAt = at.Add(2 * time.Hour)
	g.ReviewNote = "access matched the incident"

	// Still inside the window: nothing to review yet.
	if err := f.repo.ReviewGrant(ctx, f.scope, g, at.Add(30*time.Minute)); err == nil {
		t.Fatal("a grant still inside its window was reviewed")
	}
	// Past it, with the row untouched by any sweep.
	if err := f.repo.ReviewGrant(ctx, f.scope, g, at.Add(2*time.Hour)); err != nil {
		t.Fatalf("ReviewGrant past expiry: %v", err)
	}
}
