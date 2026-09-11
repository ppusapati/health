package workflow_test

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/platform/workflow"
)

// simpleDefinition is a two-step workflow parameterised by version, used to
// prove that publishing a new version leaves running instances alone.
func simpleDefinition(version int, rec *recorder) workflow.Definition {
	return workflow.Definition{
		Name:    "versioned",
		Version: version,
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
					rec.record("finish:v" + itoa(version))
					s.Set("finished_by_version", version)
					return nil
				},
			},
		},
	}
}

func itoa(v int) string {
	if v == 0 {
		return "0"
	}
	digits := ""
	for v > 0 {
		digits = string(rune('0'+v%10)) + digits
		v /= 10
	}
	return digits
}

// The property that makes it safe to deploy a workflow change while instances
// are in flight: a running instance stays on the version it started.
func TestRunningInstanceStaysPinnedToItsVersion(t *testing.T) {
	rec := &recorder{}
	f := newFixture(t, simpleDefinition(1, rec))
	ctx := context.Background()

	instance, err := f.engine.Start(ctx, f.tenantID, "versioned", "corr-1", nil)
	if err != nil {
		t.Fatalf("Start: %v", err)
	}
	if instance.DefinitionVersion != 1 {
		t.Fatalf("started on version %d", instance.DefinitionVersion)
	}

	f.runToQuiescence(t, 5)

	// v2 is published while the instance waits on its human task.
	if err := f.registry.Register(simpleDefinition(2, rec)); err != nil {
		t.Fatalf("register v2: %v", err)
	}

	// A new instance picks up v2 …
	fresh, err := f.engine.Start(ctx, f.tenantID, "versioned", "corr-2", nil)
	if err != nil {
		t.Fatalf("Start second: %v", err)
	}
	if fresh.DefinitionVersion != 2 {
		t.Fatalf("new instance started on version %d, want 2", fresh.DefinitionVersion)
	}

	// … while the in-flight one finishes on v1.
	tasks, err := f.engine.ListOpenTasks(ctx, f.tenantID)
	if err != nil {
		t.Fatalf("ListOpenTasks: %v", err)
	}
	for _, task := range tasks {
		if task.InstanceID == instance.ID {
			if _, err := f.engine.CompleteTask(ctx, f.tenantID, task.ID, "op-1", "go"); err != nil {
				t.Fatalf("CompleteTask: %v", err)
			}
		}
	}
	f.runToQuiescence(t, 5)

	final, err := f.engine.Get(ctx, f.tenantID, instance.ID)
	if err != nil {
		t.Fatalf("Get: %v", err)
	}
	if final.DefinitionVersion != 1 {
		t.Fatalf("instance drifted to version %d", final.DefinitionVersion)
	}
	if final.State["finished_by_version"] != float64(1) && final.State["finished_by_version"] != 1 {
		t.Fatalf("instance ran v%v's step body", final.State["finished_by_version"])
	}
}

// Re-registering a published version would change behaviour underneath
// in-flight instances, so it is refused.
func TestRegisteringTheSameVersionTwiceIsRefused(t *testing.T) {
	rec := &recorder{}
	registry := workflow.NewRegistry()

	if err := registry.Register(simpleDefinition(1, rec)); err != nil {
		t.Fatalf("first register: %v", err)
	}
	if err := registry.Register(simpleDefinition(1, rec)); !errors.Is(err, workflow.ErrInvalidDefinition) {
		t.Fatalf("re-registering v1 was allowed: %v", err)
	}
}

// An instance pinned to a version nobody registered must fail loudly rather
// than silently upgrading itself to the latest.
func TestUnknownPinnedVersionFailsLoudly(t *testing.T) {
	rec := &recorder{}
	f := newFixture(t, simpleDefinition(1, rec))
	ctx := context.Background()

	instance, err := f.engine.Start(ctx, f.tenantID, "versioned", "corr-1", nil)
	if err != nil {
		t.Fatalf("Start: %v", err)
	}

	if _, err := f.pool.Exec(ctx,
		`UPDATE platform_workflow.instance SET definition_version = 99 WHERE instance_id = $1`,
		instance.ID); err != nil {
		t.Fatalf("repoint version: %v", err)
	}

	if _, err := f.engine.Tick(ctx, 10); !errors.Is(err, workflow.ErrDefinitionNotFound) {
		t.Fatalf("tick error = %v, want ErrDefinitionNotFound", err)
	}
}

func TestDefinitionValidationRejectsBrokenWorkflows(t *testing.T) {
	valid := func() workflow.Definition {
		return workflow.Definition{
			Name: "x", Version: 1,
			Steps: []workflow.Step{{
				Name: "s", Kind: workflow.StepService,
				Action: func(context.Context, *workflow.State) error { return nil },
			}},
		}
	}

	cases := map[string]func(*workflow.Definition){
		"no name":                func(d *workflow.Definition) { d.Name = "" },
		"zero version":           func(d *workflow.Definition) { d.Version = 0 },
		"no steps":               func(d *workflow.Definition) { d.Steps = nil },
		"unnamed step":           func(d *workflow.Definition) { d.Steps[0].Name = "" },
		"duplicate step":         func(d *workflow.Definition) { d.Steps = append(d.Steps, d.Steps[0]) },
		"service without action": func(d *workflow.Definition) { d.Steps[0].Action = nil },
		"unknown kind":           func(d *workflow.Definition) { d.Steps[0].Kind = workflow.StepKind("magic") },
		"human task without role": func(d *workflow.Definition) {
			d.Steps[0] = workflow.Step{Name: "t", Kind: workflow.StepHumanTask, SLA: time.Hour, SignalName: "go"}
		},
		"human task without sla": func(d *workflow.Definition) {
			d.Steps[0] = workflow.Step{Name: "t", Kind: workflow.StepHumanTask, AssignedRole: "r", SignalName: "go"}
		},
		"human task without signal": func(d *workflow.Definition) {
			d.Steps[0] = workflow.Step{Name: "t", Kind: workflow.StepHumanTask, AssignedRole: "r", SLA: time.Hour}
		},
		"timer without delay": func(d *workflow.Definition) {
			d.Steps[0] = workflow.Step{Name: "t", Kind: workflow.StepTimer}
		},
	}

	for name, mutate := range cases {
		t.Run(name, func(t *testing.T) {
			d := valid()
			mutate(&d)
			if err := d.Validate(); !errors.Is(err, workflow.ErrInvalidDefinition) {
				t.Fatalf("invalid definition accepted: %v", err)
			}
		})
	}

	if err := valid().Validate(); err != nil {
		t.Fatalf("valid definition rejected: %v", err)
	}
}
