package workflow_test

import (
	"context"
	"errors"
	"sync"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/workflow"
)

// testClock is advanced explicitly. Nothing in these tests sleeps: a workflow
// test that depends on wall-clock timing is flaky by construction.
type testClock struct {
	mu  sync.Mutex
	now time.Time
}

func (c *testClock) Now() time.Time {
	c.mu.Lock()
	defer c.mu.Unlock()
	return c.now
}

func (c *testClock) Advance(d time.Duration) {
	c.mu.Lock()
	defer c.mu.Unlock()
	c.now = c.now.Add(d)
}

type uuidGen struct{}

func (uuidGen) NewID() string { return uuid.NewString() }

// recorder captures which steps ran, in order, so a test can assert the path
// taken rather than only the final status.
type recorder struct {
	mu    sync.Mutex
	calls []string
}

func (r *recorder) record(name string) {
	r.mu.Lock()
	defer r.mu.Unlock()
	r.calls = append(r.calls, name)
}

func (r *recorder) snapshot() []string {
	r.mu.Lock()
	defer r.mu.Unlock()
	return append([]string(nil), r.calls...)
}

type fixture struct {
	pool     *pgxpool.Pool
	engine   *workflow.Engine
	registry *workflow.Registry
	clock    *testClock
	tenantID string
	rec      *recorder
}

func newFixture(t *testing.T, definitions ...workflow.Definition) fixture {
	t.Helper()

	pool := pgtest.New(t)
	registry := workflow.NewRegistry()
	for _, d := range definitions {
		if err := registry.Register(d); err != nil {
			t.Fatalf("register %s v%d: %v", d.Name, d.Version, err)
		}
	}

	clock := &testClock{now: time.Date(2026, 9, 11, 9, 0, 0, 0, time.UTC)}
	engine := workflow.NewEngine(pgtx.NewManager(pool), registry, clock, uuidGen{})

	return fixture{
		pool: pool, engine: engine, registry: registry,
		clock: clock, tenantID: uuid.NewString(), rec: &recorder{},
	}
}

// runToQuiescence ticks until nothing advances or the budget is spent. The
// budget is what turns an engine bug into a failed assertion instead of a hung
// test.
func (f fixture) runToQuiescence(t *testing.T, maxTicks int) {
	t.Helper()
	for i := 0; i < maxTicks; i++ {
		advanced, err := f.engine.Tick(context.Background(), 10)
		if err != nil {
			t.Fatalf("tick %d: %v", i, err)
		}
		if advanced == 0 {
			return
		}
	}
	t.Fatalf("workflow did not settle within %d ticks", maxTicks)
}

// onboardingDefinition is the reference long-running workflow ADR-006 asks for.
// It is deliberately non-clinical: tenant onboarding exercises every engine
// feature without inventing Wave-1 clinical scope.
func onboardingDefinition(rec *recorder, provision workflow.Action) workflow.Definition {
	return workflow.Definition{
		Name:    "tenant_onboarding",
		Version: 1,
		Steps: []workflow.Step{
			{
				Name: "validate",
				Kind: workflow.StepService,
				Action: func(_ context.Context, s *workflow.State) error {
					rec.record("validate")
					s.Set("validated", true)
					return nil
				},
				Compensate: func(_ context.Context, _ *workflow.State) error {
					rec.record("compensate:validate")
					return nil
				},
			},
			{
				Name:         "await_approval",
				Kind:         workflow.StepHumanTask,
				AssignedRole: "platform_operator",
				SLA:          48 * time.Hour,
				SignalName:   "onboarding_approved",
			},
			{
				Name:        "provision_facility",
				Kind:        workflow.StepService,
				Action:      provision,
				MaxAttempts: 3,
				Backoff:     time.Minute,
				Compensate: func(_ context.Context, _ *workflow.State) error {
					rec.record("compensate:provision_facility")
					return nil
				},
			},
			{
				Name: "activate",
				Kind: workflow.StepService,
				Action: func(_ context.Context, s *workflow.State) error {
					rec.record("activate")
					s.Set("activated", true)
					return nil
				},
			},
		},
	}
}

func succeedingProvision(rec *recorder) workflow.Action {
	return func(_ context.Context, s *workflow.State) error {
		rec.record("provision_facility")
		s.Set("facility_id", "facility-1")
		return nil
	}
}

// The happy path: a long-running workflow that pauses for a human and resumes.
func TestReferenceWorkflowCompletesThroughHumanApproval(t *testing.T) {
	rec := &recorder{}
	f := newFixture(t, onboardingDefinition(rec, succeedingProvision(rec)))
	f.rec = rec
	ctx := context.Background()

	instance, err := f.engine.Start(ctx, f.tenantID, "tenant_onboarding", "corr-1", map[string]any{
		"jurisdiction": "IN",
	})
	if err != nil {
		t.Fatalf("Start: %v", err)
	}

	// Runs validate, then parks on the approval task.
	f.runToQuiescence(t, 10)

	current, err := f.engine.Get(ctx, f.tenantID, instance.ID)
	if err != nil {
		t.Fatalf("Get: %v", err)
	}
	if current.Status != workflow.StatusAwaitingSignal {
		t.Fatalf("Status = %q, want awaiting_signal", current.Status)
	}
	if current.CurrentStep != "await_approval" {
		t.Fatalf("CurrentStep = %q", current.CurrentStep)
	}

	tasks, err := f.engine.ListOpenTasks(ctx, f.tenantID)
	if err != nil {
		t.Fatalf("ListOpenTasks: %v", err)
	}
	if len(tasks) != 1 || tasks[0].AssignedRole != "platform_operator" {
		t.Fatalf("tasks = %+v", tasks)
	}

	result, err := f.engine.CompleteTask(ctx, f.tenantID, tasks[0].ID, "ops-1", "approved")
	if err != nil {
		t.Fatalf("CompleteTask: %v", err)
	}
	if !result.Accepted {
		t.Fatalf("approval not accepted: %s", result.Reason)
	}

	f.runToQuiescence(t, 10)

	final, err := f.engine.Get(ctx, f.tenantID, instance.ID)
	if err != nil {
		t.Fatalf("Get: %v", err)
	}
	if final.Status != workflow.StatusCompleted {
		t.Fatalf("Status = %q, want completed (last error %q)", final.Status, final.LastError)
	}
	if final.State["activated"] != true {
		t.Fatalf("state = %v", final.State)
	}
	// The approver's decision is carried into workflow state.
	if final.State["task_outcome"] != "approved" {
		t.Fatalf("approval outcome missing from state: %v", final.State)
	}

	want := []string{"validate", "provision_facility", "activate"}
	if got := rec.snapshot(); len(got) != 3 || got[0] != want[0] || got[1] != want[1] || got[2] != want[2] {
		t.Fatalf("steps ran %v, want %v", got, want)
	}
}

// Start must absorb the duplicate deliveries that at-least-once upstreams
// produce, rather than forking a second onboarding.
func TestStartIsIdempotentOnCorrelationKey(t *testing.T) {
	rec := &recorder{}
	f := newFixture(t, onboardingDefinition(rec, succeedingProvision(rec)))
	ctx := context.Background()

	first, err := f.engine.Start(ctx, f.tenantID, "tenant_onboarding", "corr-1", nil)
	if err != nil {
		t.Fatalf("first Start: %v", err)
	}
	second, err := f.engine.Start(ctx, f.tenantID, "tenant_onboarding", "corr-1", nil)
	if err != nil {
		t.Fatalf("second Start: %v", err)
	}

	if first.ID != second.ID {
		t.Fatalf("duplicate start forked a second instance: %s vs %s", first.ID, second.ID)
	}

	var count int
	if err := f.pool.QueryRow(ctx,
		`SELECT count(*) FROM platform_workflow.instance WHERE tenant_id = $1`,
		f.tenantID).Scan(&count); err != nil {
		t.Fatalf("count: %v", err)
	}
	if count != 1 {
		t.Fatalf("%d instances exist, want 1", count)
	}
}

// A transient failure retries with backoff and then succeeds.
func TestTransientFailureRetriesWithBackoffThenSucceeds(t *testing.T) {
	rec := &recorder{}
	var attempts int

	provision := func(_ context.Context, s *workflow.State) error {
		attempts++
		rec.record("provision_facility")
		if attempts < 3 {
			return workflow.Retryable{Err: errors.New("provisioning service unavailable")}
		}
		s.Set("facility_id", "facility-1")
		return nil
	}

	f := newFixture(t, onboardingDefinition(rec, provision))
	ctx := context.Background()

	instance, err := f.engine.Start(ctx, f.tenantID, "tenant_onboarding", "corr-1", nil)
	if err != nil {
		t.Fatalf("Start: %v", err)
	}
	f.runToQuiescence(t, 10)

	tasks, _ := f.engine.ListOpenTasks(ctx, f.tenantID)
	if _, err := f.engine.CompleteTask(ctx, f.tenantID, tasks[0].ID, "ops-1", "approved"); err != nil {
		t.Fatalf("CompleteTask: %v", err)
	}

	// Attempt 1 fails and schedules a 1-minute backoff timer.
	f.runToQuiescence(t, 10)
	current, _ := f.engine.Get(ctx, f.tenantID, instance.ID)
	if current.Status != workflow.StatusAwaitingTimer {
		t.Fatalf("after first failure Status = %q, want awaiting_timer", current.Status)
	}
	if attempts != 1 {
		t.Fatalf("attempts = %d, want 1", attempts)
	}

	// Backoff is linear, so attempt 2 waits a minute and attempt 3 waits two.
	f.clock.Advance(time.Minute)
	f.runToQuiescence(t, 10)
	if attempts != 2 {
		t.Fatalf("attempts = %d after first backoff, want 2", attempts)
	}

	f.clock.Advance(2 * time.Minute)
	f.runToQuiescence(t, 10)

	final, _ := f.engine.Get(ctx, f.tenantID, instance.ID)
	if final.Status != workflow.StatusCompleted {
		t.Fatalf("Status = %q, want completed (last error %q)", final.Status, final.LastError)
	}
	if attempts != 3 {
		t.Fatalf("attempts = %d, want 3", attempts)
	}
}

// Exhausting the attempt budget compensates in reverse, and compensation is an
// explicit reverse command — not a database rollback, which is impossible here
// because the earlier steps committed long ago.
func TestExhaustedRetriesCompensateInReverseOrder(t *testing.T) {
	rec := &recorder{}
	provision := func(_ context.Context, _ *workflow.State) error {
		rec.record("provision_facility")
		return workflow.Retryable{Err: errors.New("provisioning service down")}
	}

	f := newFixture(t, onboardingDefinition(rec, provision))
	ctx := context.Background()

	instance, err := f.engine.Start(ctx, f.tenantID, "tenant_onboarding", "corr-1", nil)
	if err != nil {
		t.Fatalf("Start: %v", err)
	}
	f.runToQuiescence(t, 10)

	tasks, _ := f.engine.ListOpenTasks(ctx, f.tenantID)
	if _, err := f.engine.CompleteTask(ctx, f.tenantID, tasks[0].ID, "ops-1", "approved"); err != nil {
		t.Fatalf("CompleteTask: %v", err)
	}

	// Three attempts, each separated by its backoff timer.
	for i := 0; i < 4; i++ {
		f.runToQuiescence(t, 10)
		f.clock.Advance(5 * time.Minute)
	}
	f.runToQuiescence(t, 10)

	final, _ := f.engine.Get(ctx, f.tenantID, instance.ID)
	if final.Status != workflow.StatusCompensated {
		t.Fatalf("Status = %q, want compensated", final.Status)
	}

	calls := rec.snapshot()
	// provision attempted three times, then compensation walks backwards:
	// provision_facility's own compensator, then validate's.
	var compensations []string
	for _, c := range calls {
		if len(c) > 11 && c[:11] == "compensate:" {
			compensations = append(compensations, c)
		}
	}
	want := []string{"compensate:provision_facility", "compensate:validate"}
	if len(compensations) != 2 || compensations[0] != want[0] || compensations[1] != want[1] {
		t.Fatalf("compensations ran %v, want %v (all calls: %v)", compensations, want, calls)
	}
}

// A permanent error must not consume the retry budget.
func TestNonRetryableErrorCompensatesImmediately(t *testing.T) {
	rec := &recorder{}
	var attempts int
	provision := func(_ context.Context, _ *workflow.State) error {
		attempts++
		rec.record("provision_facility")
		return errors.New("facility code already taken")
	}

	f := newFixture(t, onboardingDefinition(rec, provision))
	ctx := context.Background()

	instance, _ := f.engine.Start(ctx, f.tenantID, "tenant_onboarding", "corr-1", nil)
	f.runToQuiescence(t, 10)

	tasks, _ := f.engine.ListOpenTasks(ctx, f.tenantID)
	if _, err := f.engine.CompleteTask(ctx, f.tenantID, tasks[0].ID, "ops-1", "approved"); err != nil {
		t.Fatalf("CompleteTask: %v", err)
	}
	f.runToQuiescence(t, 10)

	final, _ := f.engine.Get(ctx, f.tenantID, instance.ID)
	if final.Status != workflow.StatusCompensated {
		t.Fatalf("Status = %q, want compensated", final.Status)
	}
	if attempts != 1 {
		t.Fatalf("attempts = %d, want 1 — a permanent error must not be retried", attempts)
	}
}
