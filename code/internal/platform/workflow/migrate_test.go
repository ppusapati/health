package workflow_test

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/platform/workflow"
)

// Version migration is the half of versioning that pinning does not cover.
// Pinning makes a deploy safe; migration is what an operator does when a
// long-lived instance is pinned to the version containing the bug.

// patchedDefinition is simpleDefinition with an extra step inserted BEFORE the
// human task. Its whole purpose is that the step indices no longer line up: in
// v1 "await_go" is index 0, here it is index 1. An instance migrated by index
// would resume on "precheck" and run it a second time.
func patchedDefinition(version int, rec *recorder) workflow.Definition {
	return workflow.Definition{
		Name:    "versioned",
		Version: version,
		Steps: []workflow.Step{
			{
				Name: "precheck",
				Kind: workflow.StepService,
				Action: func(_ context.Context, s *workflow.State) error {
					rec.record("precheck:v" + itoa(version))
					s.Set("prechecked", true)
					return nil
				},
			},
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
					rec.record("finish:v" + itoa(version))
					s.Set("finished_by_version", version)
					return nil
				},
			},
		},
	}
}

// completeTaskFor completes the open human task belonging to one instance.
func (f fixture) completeTaskFor(t *testing.T, instanceID, signal string) {
	t.Helper()
	tasks, err := f.engine.ListOpenTasks(context.Background(), f.tenantID)
	if err != nil {
		t.Fatalf("ListOpenTasks: %v", err)
	}
	for _, task := range tasks {
		if task.InstanceID == instanceID {
			if _, err := f.engine.CompleteTask(context.Background(), f.tenantID, task.ID, "op-1", signal); err != nil {
				t.Fatalf("CompleteTask: %v", err)
			}
			return
		}
	}
	t.Fatalf("no open task for instance %s", instanceID)
}

// The register's own acceptance evidence for ADR-006: a running instance is
// upgraded to a new definition version and finishes on it.
func TestMigratingAWaitingInstanceResumesOnTheNewVersion(t *testing.T) {
	rec := &recorder{}
	f := newFixture(t, simpleDefinition(1, rec))
	ctx := context.Background()

	instance, err := f.engine.Start(ctx, f.tenantID, "versioned", "corr-1", nil)
	if err != nil {
		t.Fatalf("Start: %v", err)
	}
	f.runToQuiescence(t, 5)

	if err := f.registry.Register(patchedDefinition(2, rec)); err != nil {
		t.Fatalf("register v2: %v", err)
	}

	migrated, err := f.engine.Migrate(ctx, f.tenantID, instance.ID, 2)
	if err != nil {
		t.Fatalf("Migrate: %v", err)
	}
	if migrated.DefinitionVersion != 2 {
		t.Fatalf("version = %d after migration, want 2", migrated.DefinitionVersion)
	}
	// Resumed by name: "await_go" is index 1 in v2, not the index 0 it held in
	// v1. Carrying the index across would have put the instance on "precheck".
	if migrated.StepIndex != 1 {
		t.Fatalf("step index = %d, want 1 (await_go's position in v2)", migrated.StepIndex)
	}
	if migrated.CurrentStep != "await_go" {
		t.Fatalf("current step = %q, want await_go", migrated.CurrentStep)
	}

	f.completeTaskFor(t, instance.ID, "go")
	f.runToQuiescence(t, 5)

	final, err := f.engine.Get(ctx, f.tenantID, instance.ID)
	if err != nil {
		t.Fatalf("Get: %v", err)
	}
	if final.Status != workflow.StatusCompleted {
		t.Fatalf("status = %s, want completed", final.Status)
	}
	if final.State["finished_by_version"] != float64(2) && final.State["finished_by_version"] != 2 {
		t.Fatalf("finished on version %v, want 2", final.State["finished_by_version"])
	}

	// The step that v2 added before the current position must NOT run: the
	// instance is past that point, and re-running a precheck is at best
	// duplicate work and at worst a duplicate side effect.
	for _, call := range rec.snapshot() {
		if call == "precheck:v2" {
			t.Fatalf("migration re-ran a step the instance had already passed: %v", rec.snapshot())
		}
	}
}

// A step that no longer exists in the target version has no safe resume point,
// so the engine refuses rather than choosing one.
func TestMigrationIsRefusedWhenTheCurrentStepIsGone(t *testing.T) {
	rec := &recorder{}
	f := newFixture(t, simpleDefinition(1, rec))
	ctx := context.Background()

	instance, err := f.engine.Start(ctx, f.tenantID, "versioned", "corr-1", nil)
	if err != nil {
		t.Fatalf("Start: %v", err)
	}
	f.runToQuiescence(t, 5)

	// v2 drops the human task the instance is waiting on.
	if err := f.registry.Register(workflow.Definition{
		Name: "versioned", Version: 2,
		Steps: []workflow.Step{{
			Name: "finish", Kind: workflow.StepService,
			Action: func(context.Context, *workflow.State) error { return nil },
		}},
	}); err != nil {
		t.Fatalf("register v2: %v", err)
	}

	_, err = f.engine.Migrate(ctx, f.tenantID, instance.ID, 2)
	if !errors.Is(err, workflow.ErrMigrationRefused) {
		t.Fatalf("Migrate = %v, want ErrMigrationRefused", err)
	}

	after, err := f.engine.Get(ctx, f.tenantID, instance.ID)
	if err != nil {
		t.Fatalf("Get: %v", err)
	}
	if after.DefinitionVersion != 1 {
		t.Fatalf("a refused migration moved the instance to v%d", after.DefinitionVersion)
	}
}

// Same name, different kind. Resuming a human task as a service step would
// execute the approval instead of waiting for it.
func TestMigrationIsRefusedWhenTheStepChangedKind(t *testing.T) {
	rec := &recorder{}
	f := newFixture(t, simpleDefinition(1, rec))
	ctx := context.Background()

	instance, err := f.engine.Start(ctx, f.tenantID, "versioned", "corr-1", nil)
	if err != nil {
		t.Fatalf("Start: %v", err)
	}
	f.runToQuiescence(t, 5)

	if err := f.registry.Register(workflow.Definition{
		Name: "versioned", Version: 2,
		Steps: []workflow.Step{
			{
				Name: "await_go", Kind: workflow.StepService,
				Action: func(context.Context, *workflow.State) error {
					rec.record("auto_approved")
					return nil
				},
			},
			{
				Name: "finish", Kind: workflow.StepService,
				Action: func(context.Context, *workflow.State) error { return nil },
			},
		},
	}); err != nil {
		t.Fatalf("register v2: %v", err)
	}

	if _, err := f.engine.Migrate(ctx, f.tenantID, instance.ID, 2); !errors.Is(err, workflow.ErrMigrationRefused) {
		t.Fatalf("Migrate = %v, want ErrMigrationRefused", err)
	}
	for _, call := range rec.snapshot() {
		if call == "auto_approved" {
			t.Fatal("a refused migration ran the replacement step")
		}
	}
}

// A finished instance is a record of what happened. Rewriting its version
// would make that record describe steps it never executed.
func TestMigrationIsRefusedForATerminalInstance(t *testing.T) {
	rec := &recorder{}
	f := newFixture(t, simpleDefinition(1, rec))
	ctx := context.Background()

	instance, err := f.engine.Start(ctx, f.tenantID, "versioned", "corr-1", nil)
	if err != nil {
		t.Fatalf("Start: %v", err)
	}
	f.runToQuiescence(t, 5)
	f.completeTaskFor(t, instance.ID, "go")
	f.runToQuiescence(t, 5)

	if err := f.registry.Register(simpleDefinition(2, rec)); err != nil {
		t.Fatalf("register v2: %v", err)
	}

	if _, err := f.engine.Migrate(ctx, f.tenantID, instance.ID, 2); !errors.Is(err, workflow.ErrMigrationRefused) {
		t.Fatalf("Migrate = %v, want ErrMigrationRefused", err)
	}
}

// An unregistered target is refused: the engine resolves steps by version at
// every tick, so pointing an instance at a version nobody published would
// wedge it on the next tick rather than at the migration.
func TestMigrationIsRefusedForAnUnknownVersion(t *testing.T) {
	rec := &recorder{}
	f := newFixture(t, simpleDefinition(1, rec))
	ctx := context.Background()

	instance, err := f.engine.Start(ctx, f.tenantID, "versioned", "corr-1", nil)
	if err != nil {
		t.Fatalf("Start: %v", err)
	}
	f.runToQuiescence(t, 5)

	if _, err := f.engine.Migrate(ctx, f.tenantID, instance.ID, 99); !errors.Is(err, workflow.ErrMigrationRefused) {
		t.Fatalf("Migrate = %v, want ErrMigrationRefused", err)
	}
}

// Re-running an operator's migration script must not fail on the instances it
// already migrated.
func TestMigratingToTheCurrentVersionIsANoOp(t *testing.T) {
	rec := &recorder{}
	f := newFixture(t, simpleDefinition(1, rec))
	ctx := context.Background()

	instance, err := f.engine.Start(ctx, f.tenantID, "versioned", "corr-1", nil)
	if err != nil {
		t.Fatalf("Start: %v", err)
	}
	f.runToQuiescence(t, 5)

	before, err := f.engine.Get(ctx, f.tenantID, instance.ID)
	if err != nil {
		t.Fatalf("Get: %v", err)
	}

	again, err := f.engine.Migrate(ctx, f.tenantID, instance.ID, 1)
	if err != nil {
		t.Fatalf("Migrate to the current version: %v", err)
	}
	if again.Version != before.Version {
		t.Fatalf("a no-op migration bumped the row version from %d to %d",
			before.Version, again.Version)
	}
	if again.CurrentStep != before.CurrentStep {
		t.Fatalf("a no-op migration moved the instance to %q", again.CurrentStep)
	}
}

// The migration is part of the execution record. An instance that finished on
// v2 having started on v1 is otherwise indistinguishable from one that started
// on v2, and the difference matters in an incident review.
func TestMigrationIsRecordedInHistory(t *testing.T) {
	rec := &recorder{}
	f := newFixture(t, simpleDefinition(1, rec))
	ctx := context.Background()

	instance, err := f.engine.Start(ctx, f.tenantID, "versioned", "corr-1", nil)
	if err != nil {
		t.Fatalf("Start: %v", err)
	}
	f.runToQuiescence(t, 5)

	if err := f.registry.Register(patchedDefinition(2, rec)); err != nil {
		t.Fatalf("register v2: %v", err)
	}
	if _, err := f.engine.Migrate(ctx, f.tenantID, instance.ID, 2); err != nil {
		t.Fatalf("Migrate: %v", err)
	}

	history, err := f.engine.History(ctx, f.tenantID, instance.ID)
	if err != nil {
		t.Fatalf("History: %v", err)
	}

	found := false
	for _, event := range history {
		if event.EventType == workflow.EventMigrated {
			found = true
			if event.Step != "await_go" {
				t.Fatalf("migration recorded against step %q", event.Step)
			}
		}
	}
	if !found {
		t.Fatalf("no migration event in history: %+v", history)
	}
}

// Migration is per instance. An operator fixing one stuck instance must not
// move its siblings.
func TestMigrationDoesNotTouchOtherInstances(t *testing.T) {
	rec := &recorder{}
	f := newFixture(t, simpleDefinition(1, rec))
	ctx := context.Background()

	first, err := f.engine.Start(ctx, f.tenantID, "versioned", "corr-1", nil)
	if err != nil {
		t.Fatalf("Start: %v", err)
	}
	second, err := f.engine.Start(ctx, f.tenantID, "versioned", "corr-2", nil)
	if err != nil {
		t.Fatalf("Start second: %v", err)
	}
	f.runToQuiescence(t, 5)

	if err := f.registry.Register(patchedDefinition(2, rec)); err != nil {
		t.Fatalf("register v2: %v", err)
	}
	if _, err := f.engine.Migrate(ctx, f.tenantID, first.ID, 2); err != nil {
		t.Fatalf("Migrate: %v", err)
	}

	other, err := f.engine.Get(ctx, f.tenantID, second.ID)
	if err != nil {
		t.Fatalf("Get: %v", err)
	}
	if other.DefinitionVersion != 1 {
		t.Fatalf("sibling instance moved to v%d", other.DefinitionVersion)
	}
}
