package postgres_test

import (
	"context"
	"encoding/json"
	"sync"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	secpostgres "github.com/ppusapati/health/code/internal/security/adapters/postgres"
	"github.com/ppusapati/health/code/internal/security/domain"
)

var at = time.Date(2026, 9, 11, 9, 0, 0, 0, time.UTC)

type fixture struct {
	pool   *pgxpool.Pool
	repo   *secpostgres.Repository
	scope  authctx.TenantScope
	tenant string
}

func newFixture(t *testing.T) fixture {
	t.Helper()

	pool := pgtest.New(t)
	tenant := uuid.NewString()
	scope := authctx.NewSession(authctx.Session{SubjectID: "admin", TenantID: tenant}).TenantScope()

	return fixture{
		pool:  pool,
		repo:  secpostgres.New(pgtx.NewManager(pool)),
		scope: scope, tenant: tenant,
	}
}

func event() domain.SecurityEvent {
	return domain.SecurityEvent{
		EventID:       uuid.NewString(),
		Class:         domain.ClassPrivilegeChange,
		Severity:      domain.SeverityHigh,
		ActorID:       "admin-1",
		ResourceType:  "role",
		ResourceID:    "tenant_admin",
		Outcome:       domain.OutcomeSuccess,
		Detail:        json.RawMessage(`{"added":"organization.facility.create"}`),
		CorrelationID: uuid.NewString(),
		OccurredAt:    at,
	}
}

func TestChainIsBuiltAndVerifies(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	for i := 0; i < 5; i++ {
		if _, err := f.repo.Append(ctx, f.scope, event()); err != nil {
			t.Fatalf("Append %d: %v", i, err)
		}
	}

	chain, err := f.repo.List(ctx, f.scope)
	if err != nil {
		t.Fatalf("List: %v", err)
	}
	if len(chain) != 5 {
		t.Fatalf("chain length = %d", len(chain))
	}

	if result := domain.VerifyChain(chain); !result.Verified {
		t.Fatalf("persisted chain failed verification: %+v", result)
	}
}

// The point of the chain: an operator editing history is detected.
func TestEditingARowBreaksVerification(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	for i := 0; i < 3; i++ {
		if _, err := f.repo.Append(ctx, f.scope, event()); err != nil {
			t.Fatalf("Append: %v", err)
		}
	}

	// Direct SQL, bypassing the application entirely — exactly the threat.
	if _, err := f.pool.Exec(ctx,
		`UPDATE security_platform.security_event SET severity = 'info'
		  WHERE tenant_id = $1 AND sequence = 2`, f.tenant); err != nil {
		t.Fatalf("tamper: %v", err)
	}

	chain, err := f.repo.List(ctx, f.scope)
	if err != nil {
		t.Fatalf("List: %v", err)
	}

	result := domain.VerifyChain(chain)
	if result.Verified {
		t.Fatal("a tampered chain verified")
	}
	if result.BrokenAtSequence != 2 {
		t.Fatalf("BrokenAtSequence = %d, want 2", result.BrokenAtSequence)
	}
}

// Deleting a row is the other obvious tamper.
func TestDeletingARowBreaksVerification(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	for i := 0; i < 4; i++ {
		if _, err := f.repo.Append(ctx, f.scope, event()); err != nil {
			t.Fatalf("Append: %v", err)
		}
	}

	if _, err := f.pool.Exec(ctx,
		`DELETE FROM security_platform.security_event WHERE tenant_id = $1 AND sequence = 2`,
		f.tenant); err != nil {
		t.Fatalf("delete: %v", err)
	}

	chain, _ := f.repo.List(ctx, f.scope)
	if domain.VerifyChain(chain).Verified {
		t.Fatal("a chain with a deleted row verified")
	}
}

// Concurrent appends must not both claim a sequence. Sequence allocation and
// insert happen in one transaction precisely for this.
func TestConcurrentAppendsProduceAValidChain(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	const writers = 8
	var wg sync.WaitGroup
	errs := make(chan error, writers)

	for i := 0; i < writers; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			if _, err := f.repo.Append(ctx, f.scope, event()); err != nil {
				errs <- err
			}
		}()
	}
	wg.Wait()
	close(errs)

	// Some writers may lose the race and error; that is acceptable. What is not
	// acceptable is a chain that fails to verify.
	var failed int
	for range errs {
		failed++
	}

	chain, err := f.repo.List(ctx, f.scope)
	if err != nil {
		t.Fatalf("List: %v", err)
	}
	if len(chain) != writers-failed {
		t.Fatalf("chain has %d events, %d writers failed", len(chain), failed)
	}

	if result := domain.VerifyChain(chain); !result.Verified {
		t.Fatalf("concurrent appends produced an invalid chain: %+v", result)
	}
}

// One tenant's chain must be independent of another's.
func TestChainsAreTenantScoped(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	otherTenant := uuid.NewString()
	otherScope := authctx.NewSession(authctx.Session{SubjectID: "admin", TenantID: otherTenant}).TenantScope()

	if _, err := f.repo.Append(ctx, f.scope, event()); err != nil {
		t.Fatalf("Append: %v", err)
	}
	if _, err := f.repo.Append(ctx, otherScope, event()); err != nil {
		t.Fatalf("Append other: %v", err)
	}

	mine, _ := f.repo.List(ctx, f.scope)
	theirs, _ := f.repo.List(ctx, otherScope)

	if len(mine) != 1 || len(theirs) != 1 {
		t.Fatalf("chains leaked: %d and %d", len(mine), len(theirs))
	}
	// Both start at sequence 1: one tenant's volume does not renumber another's.
	if mine[0].Sequence != 1 || theirs[0].Sequence != 1 {
		t.Fatalf("sequences = %d, %d", mine[0].Sequence, theirs[0].Sequence)
	}
	if !domain.VerifyChain(mine).Verified || !domain.VerifyChain(theirs).Verified {
		t.Fatal("a tenant chain failed to verify")
	}
}

func TestAppendRequiresTenantScope(t *testing.T) {
	f := newFixture(t)
	var zero authctx.TenantScope

	if _, err := f.repo.Append(context.Background(), zero, event()); err == nil {
		t.Fatal("an event was appended without tenant scope")
	}
}

// SRS-DAT-009: a deletion job must be able to ask, cheaply, what is held.
func TestLegalHoldLifecycle(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	hold, err := domain.NewLegalHold(uuid.NewString(), f.tenant, "facility", "facility-1",
		"Litigation reference XYZ-2026", "legal-1", at)
	if err != nil {
		t.Fatalf("NewLegalHold: %v", err)
	}

	placed, err := f.repo.Place(ctx, f.scope, hold)
	if err != nil {
		t.Fatalf("Place: %v", err)
	}
	if !placed {
		t.Fatal("hold was not placed")
	}

	held, err := f.repo.IsHeld(ctx, f.scope, "facility", "facility-1")
	if err != nil {
		t.Fatalf("IsHeld: %v", err)
	}
	if !held {
		t.Fatal("resource not reported as held")
	}

	// A second hold on the same resource is a no-op, not a duplicate row.
	second, _ := domain.NewLegalHold(uuid.NewString(), f.tenant, "facility", "facility-1",
		"Another matter", "legal-2", at)
	placedAgain, err := f.repo.Place(ctx, f.scope, second)
	if err != nil {
		t.Fatalf("Place again: %v", err)
	}
	if placedAgain {
		t.Fatal("a duplicate active hold was created")
	}

	ids, err := f.repo.HeldResourceIDs(ctx, f.scope, "facility")
	if err != nil {
		t.Fatalf("HeldResourceIDs: %v", err)
	}
	if len(ids) != 1 || ids[0] != "facility-1" {
		t.Fatalf("held IDs = %v", ids)
	}

	released, err := f.repo.Release(ctx, f.scope, "facility", "facility-1", "legal-1", at.Add(time.Hour))
	if err != nil {
		t.Fatalf("Release: %v", err)
	}
	if !released {
		t.Fatal("hold was not released")
	}

	held, _ = f.repo.IsHeld(ctx, f.scope, "facility", "facility-1")
	if held {
		t.Fatal("resource still held after release")
	}

	// Released holds stay for audit; re-placing is allowed afterwards.
	var total int
	if err := f.pool.QueryRow(ctx,
		`SELECT count(*) FROM security_platform.legal_hold WHERE tenant_id = $1`,
		f.tenant).Scan(&total); err != nil {
		t.Fatalf("count: %v", err)
	}
	if total != 1 {
		t.Fatalf("%d hold rows, want 1 retained for audit", total)
	}
}

// Another tenant must not be able to see or lift a hold.
func TestLegalHoldIsTenantScoped(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	hold, _ := domain.NewLegalHold(uuid.NewString(), f.tenant, "facility", "facility-1",
		"Litigation XYZ", "legal-1", at)
	if _, err := f.repo.Place(ctx, f.scope, hold); err != nil {
		t.Fatalf("Place: %v", err)
	}

	otherScope := authctx.NewSession(authctx.Session{
		SubjectID: "attacker", TenantID: uuid.NewString(),
	}).TenantScope()

	held, err := f.repo.IsHeld(ctx, otherScope, "facility", "facility-1")
	if err != nil {
		t.Fatalf("IsHeld: %v", err)
	}
	if held {
		t.Fatal("another tenant sees this hold")
	}

	released, err := f.repo.Release(ctx, otherScope, "facility", "facility-1", "attacker", at)
	if err != nil {
		t.Fatalf("Release: %v", err)
	}
	if released {
		t.Fatal("another tenant released this hold")
	}
}
