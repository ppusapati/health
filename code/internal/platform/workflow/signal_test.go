package workflow_test

import (
	"context"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/ppusapati/health/code/internal/platform/workflow"
)

func awaitDefinition(rec *recorder) workflow.Definition {
	return workflow.Definition{
		Name:    "await",
		Version: 1,
		Steps: []workflow.Step{
			{
				Name:         "await_go",
				Kind:         workflow.StepHumanTask,
				AssignedRole: "operator",
				SLA:          time.Hour,
				SignalName:   "go",
			},
			{
				Name: "finish",
				Kind: workflow.StepService,
				Action: func(_ context.Context, s *workflow.State) error {
					rec.record("finish")
					s.Set("done", true)
					return nil
				},
			},
		},
	}
}

// At-least-once delivery means the same signal arrives twice; the second must
// change nothing.
func TestDuplicateSignalIsIgnored(t *testing.T) {
	rec := &recorder{}
	f := newFixture(t, awaitDefinition(rec))
	ctx := context.Background()

	instance, _ := f.engine.Start(ctx, f.tenantID, "await", "corr-1", nil)
	f.runToQuiescence(t, 5)

	first, err := f.engine.Signal(ctx, f.tenantID, instance.ID, "sig-1", "go", map[string]any{"by": "op-1"})
	if err != nil {
		t.Fatalf("first Signal: %v", err)
	}
	if !first.Accepted {
		t.Fatalf("first signal rejected: %s", first.Reason)
	}

	second, err := f.engine.Signal(ctx, f.tenantID, instance.ID, "sig-1", "go", map[string]any{"by": "op-1"})
	if err != nil {
		t.Fatalf("second Signal: %v", err)
	}
	if second.Accepted {
		t.Fatal("redelivered signal was applied twice")
	}
	if second.Reason != workflow.ReasonDuplicateSignal {
		t.Fatalf("Reason = %q", second.Reason)
	}

	f.runToQuiescence(t, 5)

	// The step must have run exactly once.
	if calls := rec.snapshot(); len(calls) != 1 {
		t.Fatalf("finish ran %d times: %v", len(calls), calls)
	}
}

// A signal that arrives after the instance has moved on must not resurrect it.
func TestLateSignalOnACompletedInstanceIsIgnored(t *testing.T) {
	rec := &recorder{}
	f := newFixture(t, awaitDefinition(rec))
	ctx := context.Background()

	instance, _ := f.engine.Start(ctx, f.tenantID, "await", "corr-1", nil)
	f.runToQuiescence(t, 5)

	if _, err := f.engine.Signal(ctx, f.tenantID, instance.ID, "sig-1", "go", nil); err != nil {
		t.Fatalf("Signal: %v", err)
	}
	f.runToQuiescence(t, 5)

	final, _ := f.engine.Get(ctx, f.tenantID, instance.ID)
	if final.Status != workflow.StatusCompleted {
		t.Fatalf("Status = %q", final.Status)
	}

	late, err := f.engine.Signal(ctx, f.tenantID, instance.ID, "sig-late", "go", nil)
	if err != nil {
		t.Fatalf("late Signal: %v", err)
	}
	if late.Accepted || late.Reason != workflow.ReasonNotAwaiting {
		t.Fatalf("late signal accepted=%v reason=%q", late.Accepted, late.Reason)
	}

	after, _ := f.engine.Get(ctx, f.tenantID, instance.ID)
	if after.Status != workflow.StatusCompleted {
		t.Fatalf("late signal changed status to %q", after.Status)
	}
}

// A signal naming a different step must not release the current one.
func TestSignalForTheWrongStepIsIgnored(t *testing.T) {
	rec := &recorder{}
	f := newFixture(t, awaitDefinition(rec))
	ctx := context.Background()

	instance, _ := f.engine.Start(ctx, f.tenantID, "await", "corr-1", nil)
	f.runToQuiescence(t, 5)

	result, err := f.engine.Signal(ctx, f.tenantID, instance.ID, "sig-1", "some_other_signal", nil)
	if err != nil {
		t.Fatalf("Signal: %v", err)
	}
	if result.Accepted || result.Reason != workflow.ReasonWrongStep {
		t.Fatalf("accepted=%v reason=%q", result.Accepted, result.Reason)
	}

	current, _ := f.engine.Get(ctx, f.tenantID, instance.ID)
	if current.Status != workflow.StatusAwaitingSignal {
		t.Fatalf("Status = %q, want still awaiting", current.Status)
	}
}

// Every ignored signal is recorded, so an operator investigating "why didn't
// this progress?" can see the signal arrived and why it did nothing.
func TestIgnoredSignalsAppearInHistory(t *testing.T) {
	rec := &recorder{}
	f := newFixture(t, awaitDefinition(rec))
	ctx := context.Background()

	instance, _ := f.engine.Start(ctx, f.tenantID, "await", "corr-1", nil)
	f.runToQuiescence(t, 5)

	if _, err := f.engine.Signal(ctx, f.tenantID, instance.ID, "sig-1", "wrong", nil); err != nil {
		t.Fatalf("Signal: %v", err)
	}

	history, err := f.engine.History(ctx, f.tenantID, instance.ID)
	if err != nil {
		t.Fatalf("History: %v", err)
	}

	var found bool
	for _, entry := range history {
		if entry.EventType == workflow.EventSignalIgnored {
			found = true
			if entry.Detail["reason"] != workflow.ReasonWrongStep {
				t.Fatalf("history reason = %v", entry.Detail["reason"])
			}
		}
	}
	if !found {
		t.Fatalf("ignored signal missing from history: %+v", history)
	}
}

// Completing the same task twice is idempotent because the task ID is the
// signal key — the retry of a lost response cannot double-approve.
func TestCompletingATaskTwiceIsRefused(t *testing.T) {
	rec := &recorder{}
	f := newFixture(t, awaitDefinition(rec))
	ctx := context.Background()

	if _, err := f.engine.Start(ctx, f.tenantID, "await", "corr-1", nil); err != nil {
		t.Fatalf("Start: %v", err)
	}
	f.runToQuiescence(t, 5)

	tasks, _ := f.engine.ListOpenTasks(ctx, f.tenantID)
	if len(tasks) != 1 {
		t.Fatalf("tasks = %d", len(tasks))
	}

	if _, err := f.engine.CompleteTask(ctx, f.tenantID, tasks[0].ID, "op-1", "approved"); err != nil {
		t.Fatalf("first CompleteTask: %v", err)
	}
	if _, err := f.engine.CompleteTask(ctx, f.tenantID, tasks[0].ID, "op-2", "rejected"); err == nil {
		t.Fatal("second completion of the same task succeeded")
	}

	f.runToQuiescence(t, 5)
	if calls := rec.snapshot(); len(calls) != 1 {
		t.Fatalf("finish ran %d times", len(calls))
	}
}

// An overdue approval is marked expired so it surfaces on an exception queue.
// Expiry deliberately does not decide the workflow's fate: what happens to an
// unanswered approval is a business rule, not an engine default.
func TestOverdueHumanTaskExpires(t *testing.T) {
	rec := &recorder{}
	f := newFixture(t, awaitDefinition(rec))
	ctx := context.Background()

	instance, _ := f.engine.Start(ctx, f.tenantID, "await", "corr-1", nil)
	f.runToQuiescence(t, 5)

	f.clock.Advance(2 * time.Hour)
	if _, err := f.engine.Tick(ctx, 10); err != nil {
		t.Fatalf("Tick: %v", err)
	}

	open, err := f.engine.ListOpenTasks(ctx, f.tenantID)
	if err != nil {
		t.Fatalf("ListOpenTasks: %v", err)
	}
	if len(open) != 0 {
		t.Fatalf("%d tasks still open past SLA", len(open))
	}

	var status string
	if err := f.pool.QueryRow(ctx,
		`SELECT status FROM platform_workflow.human_task WHERE instance_id = $1`,
		instance.ID).Scan(&status); err != nil {
		t.Fatalf("read task: %v", err)
	}
	if status != "expired" {
		t.Fatalf("task status = %q, want expired", status)
	}

	current, _ := f.engine.Get(ctx, f.tenantID, instance.ID)
	if current.Status != workflow.StatusAwaitingSignal {
		t.Fatalf("expiry changed instance status to %q", current.Status)
	}
}

// One tenant must not be able to signal another tenant's instance.
func TestSignalIsTenantScoped(t *testing.T) {
	rec := &recorder{}
	f := newFixture(t, awaitDefinition(rec))
	ctx := context.Background()

	instance, _ := f.engine.Start(ctx, f.tenantID, "await", "corr-1", nil)
	f.runToQuiescence(t, 5)

	otherTenant := uuid.NewString()
	if _, err := f.engine.Signal(ctx, otherTenant, instance.ID, "sig-1", "go", nil); err == nil {
		t.Fatal("another tenant signalled this instance")
	}

	current, _ := f.engine.Get(ctx, f.tenantID, instance.ID)
	if current.Status != workflow.StatusAwaitingSignal {
		t.Fatalf("cross-tenant signal advanced the instance to %q", current.Status)
	}
}

// History is the visibility surface ADR-006 requires evidence for.
func TestHistoryRecordsTheWholeExecution(t *testing.T) {
	rec := &recorder{}
	f := newFixture(t, awaitDefinition(rec))
	ctx := context.Background()

	instance, _ := f.engine.Start(ctx, f.tenantID, "await", "corr-1", nil)
	f.runToQuiescence(t, 5)

	tasks, _ := f.engine.ListOpenTasks(ctx, f.tenantID)
	if _, err := f.engine.CompleteTask(ctx, f.tenantID, tasks[0].ID, "op-1", "approved"); err != nil {
		t.Fatalf("CompleteTask: %v", err)
	}
	f.runToQuiescence(t, 5)

	history, err := f.engine.History(ctx, f.tenantID, instance.ID)
	if err != nil {
		t.Fatalf("History: %v", err)
	}

	seen := map[string]bool{}
	for i, entry := range history {
		seen[entry.EventType] = true
		// Sequence must be dense and ordered, or replay cannot rely on it.
		if entry.Sequence != i+1 {
			t.Fatalf("history sequence %d at position %d", entry.Sequence, i)
		}
	}

	for _, want := range []string{
		workflow.EventStarted,
		workflow.EventTaskCreated,
		workflow.EventSignalReceived,
		workflow.EventStepCompleted,
		workflow.EventCompleted,
	} {
		if !seen[want] {
			t.Errorf("history missing %q (got %v)", want, seen)
		}
	}
}

// A duplicate signal key aimed at another tenant's instance must write nothing
// at all — not even a history row. The instance lookup is tenant-scoped and
// happens before any write for exactly this reason.
func TestCrossTenantDuplicateSignalWritesNothing(t *testing.T) {
	rec := &recorder{}
	f := newFixture(t, awaitDefinition(rec))
	ctx := context.Background()

	instance, _ := f.engine.Start(ctx, f.tenantID, "await", "corr-1", nil)
	f.runToQuiescence(t, 5)

	// The owner uses a signal key; the attacker then replays that key.
	if _, err := f.engine.Signal(ctx, f.tenantID, instance.ID, "sig-1", "go", nil); err != nil {
		t.Fatalf("owner Signal: %v", err)
	}

	var before int
	if err := f.pool.QueryRow(ctx,
		`SELECT count(*) FROM platform_workflow.history WHERE instance_id = $1`,
		instance.ID).Scan(&before); err != nil {
		t.Fatalf("count history: %v", err)
	}

	otherTenant := uuid.NewString()
	if _, err := f.engine.Signal(ctx, otherTenant, instance.ID, "sig-1", "go", nil); err == nil {
		t.Fatal("another tenant's duplicate signal was accepted")
	}

	var after int
	if err := f.pool.QueryRow(ctx,
		`SELECT count(*) FROM platform_workflow.history WHERE instance_id = $1`,
		instance.ID).Scan(&after); err != nil {
		t.Fatalf("count history: %v", err)
	}
	if after != before {
		t.Fatalf("a foreign tenant appended %d history rows", after-before)
	}

	var foreignSignals int
	if err := f.pool.QueryRow(ctx,
		`SELECT count(*) FROM platform_workflow.signal WHERE tenant_id = $1`,
		otherTenant).Scan(&foreignSignals); err != nil {
		t.Fatalf("count signals: %v", err)
	}
	if foreignSignals != 0 {
		t.Fatalf("a foreign tenant recorded %d signal rows", foreignSignals)
	}
}

// The StepTimer kind had no execution test: only the retry-backoff path
// exercised timers, so the declared step kind was unverified.
func TestTimerStepWaitsAndThenResumes(t *testing.T) {
	rec := &recorder{}
	definition := workflow.Definition{
		Name:    "delayed",
		Version: 1,
		Steps: []workflow.Step{
			{
				Name: "first",
				Kind: workflow.StepService,
				Action: func(_ context.Context, _ *workflow.State) error {
					rec.record("first")
					return nil
				},
			},
			{Name: "cool_off", Kind: workflow.StepTimer, Delay: 30 * time.Minute},
			{
				Name: "second",
				Kind: workflow.StepService,
				Action: func(_ context.Context, _ *workflow.State) error {
					rec.record("second")
					return nil
				},
			},
		},
	}

	f := newFixture(t, definition)
	ctx := context.Background()

	instance, err := f.engine.Start(ctx, f.tenantID, "delayed", "corr-1", nil)
	if err != nil {
		t.Fatalf("Start: %v", err)
	}

	f.runToQuiescence(t, 10)

	current, _ := f.engine.Get(ctx, f.tenantID, instance.ID)
	if current.Status != workflow.StatusAwaitingTimer {
		t.Fatalf("Status = %q, want awaiting_timer", current.Status)
	}
	if calls := rec.snapshot(); len(calls) != 1 || calls[0] != "first" {
		t.Fatalf("steps ran %v; the timer must hold the workflow", calls)
	}

	// Not yet due: ticking must not release it.
	f.clock.Advance(10 * time.Minute)
	f.runToQuiescence(t, 5)
	if len(rec.snapshot()) != 1 {
		t.Fatalf("the timer fired early: %v", rec.snapshot())
	}

	f.clock.Advance(25 * time.Minute)
	f.runToQuiescence(t, 10)

	final, _ := f.engine.Get(ctx, f.tenantID, instance.ID)
	if final.Status != workflow.StatusCompleted {
		t.Fatalf("Status = %q, want completed (last error %q)", final.Status, final.LastError)
	}
	if calls := rec.snapshot(); len(calls) != 2 || calls[1] != "second" {
		t.Fatalf("steps ran %v, want first then second", calls)
	}

	// The timer row must be marked fired, not left to fire again.
	var unfired int
	if err := f.pool.QueryRow(ctx,
		`SELECT count(*) FROM platform_workflow.timer WHERE instance_id = $1 AND fired_at IS NULL`,
		instance.ID).Scan(&unfired); err != nil {
		t.Fatalf("count timers: %v", err)
	}
	if unfired != 0 {
		t.Fatalf("%d timers left unfired", unfired)
	}
}
