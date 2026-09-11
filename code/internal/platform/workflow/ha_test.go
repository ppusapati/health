package workflow_test

import (
	"context"
	"fmt"
	"sync"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/workflow"
)

// HA is one of ADR-006's acceptance criteria, and the only honest way to
// evidence it is to run several engine replicas against one database and count
// side effects. "SKIP LOCKED is in the query" is an implementation detail; what
// matters is that two replicas never run the same step twice.

// countingDefinition records every step execution, so a double-advance shows up
// as a duplicate rather than as a subtle state difference.
func countingDefinition(counts *stepCounter) workflow.Definition {
	step := func(name string) workflow.Step {
		return workflow.Step{
			Name: name,
			Kind: workflow.StepService,
			Action: func(_ context.Context, s *workflow.State) error {
				counts.inc(s.InstanceID + "/" + name)
				s.Set(name, true)
				return nil
			},
		}
	}
	return workflow.Definition{
		Name: "concurrent", Version: 1,
		Steps: []workflow.Step{step("one"), step("two"), step("three")},
	}
}

type stepCounter struct {
	mu sync.Mutex
	n  map[string]int
}

func newStepCounter() *stepCounter { return &stepCounter{n: map[string]int{}} }

func (c *stepCounter) inc(key string) {
	c.mu.Lock()
	defer c.mu.Unlock()
	c.n[key]++
}

func (c *stepCounter) duplicates() map[string]int {
	c.mu.Lock()
	defer c.mu.Unlock()
	dups := map[string]int{}
	for k, v := range c.n {
		if v > 1 {
			dups[k] = v
		}
	}
	return dups
}

func (c *stepCounter) total() int {
	c.mu.Lock()
	defer c.mu.Unlock()
	return len(c.n)
}

// Several engine replicas draining the same instances must between them run
// every step exactly once. A step that runs twice is a duplicate side effect,
// which in a clinical workflow is a duplicate order.
func TestConcurrentEnginesRunEachStepExactlyOnce(t *testing.T) {
	counts := newStepCounter()

	// One fixture supplies the database and registry; the replicas are separate
	// Engine values over the same pool, which is what a multi-pod deployment is.
	f := newFixture(t, countingDefinition(counts))
	ctx := context.Background()

	const instances = 20
	for i := range instances {
		if _, err := f.engine.Start(ctx, f.tenantID, "concurrent", fmt.Sprintf("corr-%d", i), nil); err != nil {
			t.Fatalf("Start %d: %v", i, err)
		}
	}

	const replicas = 4
	engines := make([]*workflow.Engine, replicas)
	for i := range engines {
		engines[i] = workflow.NewEngine(pgtx.NewManager(f.pool), f.registry, f.clock, uuidGen{})
	}

	var wg sync.WaitGroup
	for _, engine := range engines {
		wg.Add(1)
		go func() {
			defer wg.Done()
			// Each replica ticks until the work is gone. A replica that finds
			// nothing is not finished — another may still be releasing rows —
			// so the budget rather than an empty tick ends the loop.
			for range 40 {
				if _, err := engine.Tick(ctx, 10); err != nil {
					// ErrConcurrentUpdate losing a race is expected and
					// handled inside Tick; anything reaching here is real.
					t.Errorf("tick: %v", err)
					return
				}
			}
		}()
	}
	wg.Wait()

	if dups := counts.duplicates(); len(dups) > 0 {
		t.Fatalf("steps executed more than once across replicas: %v", dups)
	}
	if got, want := counts.total(), instances*3; got != want {
		t.Fatalf("%d distinct steps executed, want %d", got, want)
	}

	completed, err := f.engine.List(ctx, f.tenantID, workflow.StatusCompleted, 100)
	if err != nil {
		t.Fatalf("List: %v", err)
	}
	if len(completed) != instances {
		t.Fatalf("%d completed instances, want %d", len(completed), instances)
	}
}

// Operator visibility (ADR-006). A durable workflow whose state can only be
// inferred from logs is not operable at 3am.
func TestListSurfacesInstancesByStatus(t *testing.T) {
	rec := &recorder{}
	f := newFixture(t, simpleDefinition(1, rec))
	ctx := context.Background()

	for i := range 3 {
		if _, err := f.engine.Start(ctx, f.tenantID, "versioned", fmt.Sprintf("corr-%d", i), nil); err != nil {
			t.Fatalf("Start: %v", err)
		}
	}
	f.runToQuiescence(t, 5)

	all, err := f.engine.List(ctx, f.tenantID, "", 100)
	if err != nil {
		t.Fatalf("List: %v", err)
	}
	if len(all) != 3 {
		t.Fatalf("List returned %d instances, want 3", len(all))
	}

	waiting, err := f.engine.List(ctx, f.tenantID, workflow.StatusAwaitingSignal, 100)
	if err != nil {
		t.Fatalf("List(awaiting_signal): %v", err)
	}
	if len(waiting) != 3 {
		t.Fatalf("%d instances awaiting a signal, want 3", len(waiting))
	}

	completed, err := f.engine.List(ctx, f.tenantID, workflow.StatusCompleted, 100)
	if err != nil {
		t.Fatalf("List(completed): %v", err)
	}
	if len(completed) != 0 {
		t.Fatalf("%d completed instances, want 0", len(completed))
	}
}

// One tenant's operator view must not include another's instances.
func TestListIsTenantScoped(t *testing.T) {
	rec := &recorder{}
	f := newFixture(t, simpleDefinition(1, rec))
	ctx := context.Background()

	if _, err := f.engine.Start(ctx, f.tenantID, "versioned", "corr-1", nil); err != nil {
		t.Fatalf("Start: %v", err)
	}

	other := newFixture(t, simpleDefinition(1, rec)).tenantID
	list, err := f.engine.List(ctx, other, "", 100)
	if err != nil {
		t.Fatalf("List: %v", err)
	}
	if len(list) != 0 {
		t.Fatalf("another tenant's view returned %d instances", len(list))
	}
}

// Stalled is the query an operator runs to find out whether the engine is
// advancing anything at all, so it must find a runnable instance nobody ticked
// and must not report one that is legitimately waiting on a human.
func TestStalledFindsInstancesThatShouldBeMovingAndAreNot(t *testing.T) {
	counts := newStepCounter()
	f := newFixture(t, countingDefinition(counts))
	ctx := context.Background()

	if _, err := f.engine.Start(ctx, f.tenantID, "concurrent", "stuck", nil); err != nil {
		t.Fatalf("Start: %v", err)
	}

	// Nothing ticks. Time passes.
	f.clock.Advance(time.Hour)

	stalled, err := f.engine.Stalled(ctx, f.clock.Now().Add(-30*time.Minute), 100)
	if err != nil {
		t.Fatalf("Stalled: %v", err)
	}
	if len(stalled) != 1 {
		t.Fatalf("%d stalled instances, want 1", len(stalled))
	}
	if stalled[0].Status != workflow.StatusRunning {
		t.Fatalf("stalled instance is %s", stalled[0].Status)
	}

	// Once it runs to a human task it is waiting, not stalled: an approval
	// nobody has given yet is the workflow working.
	f.runToQuiescence(t, 10)
	f.clock.Advance(time.Hour)

	stalled, err = f.engine.Stalled(ctx, f.clock.Now(), 100)
	if err != nil {
		t.Fatalf("Stalled: %v", err)
	}
	if len(stalled) != 0 {
		t.Fatalf("a completed instance was reported stalled: %+v", stalled)
	}
}
