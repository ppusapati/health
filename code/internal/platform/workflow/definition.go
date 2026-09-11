// Package workflow is the Wave-0 durable workflow evaluation harness.
//
// SCOPE: this is the proof of concept ADR-006 asks for. It exists to produce
// the evidence that ADR requires — a long-running reference workflow exercising
// versioning, durable timers, human tasks, retry with backoff, idempotent
// signals and compensation — so the engine selection can be made against
// observed behaviour rather than a feature matrix.
//
// It does NOT claim the Wave-7 families SRS-BPM-DEF, SRS-BPM-RUN or
// SRS-BPM-TASK. When the engine is chosen, the durable store here is expected
// to be replaced; what should survive is the Definition/Step contract and the
// guarantees the tests pin down.
//
// Two rules from the Domain, Data, API, Event & Security Architecture
// Specification §9 shape everything here:
//
//   - The workflow coordinates; the source domain service stays authoritative
//     for its own state. Steps call services, they do not write domain tables.
//   - Compensation is an explicit reverse command, never a database rollback:
//     by the time a later step fails, the earlier transaction is long committed.
package workflow

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"time"
)

// StepKind distinguishes how the engine advances past a step.
type StepKind string

const (
	// StepService runs code and advances immediately on success.
	StepService StepKind = "service"
	// StepHumanTask creates a task and waits for a signal.
	StepHumanTask StepKind = "human_task"
	// StepTimer waits for a durable timer.
	StepTimer StepKind = "timer"
)

// State is the mutable workflow payload handed to each step.
//
// It is deliberately small: a workflow carries correlation and decisions, not
// copies of domain aggregates. Holding a snapshot of a patient or an invoice
// here would make the workflow a second source of truth.
type State struct {
	InstanceID     string
	TenantID       string
	CorrelationKey string
	Data           map[string]any
}

// Get reads a value from the workflow payload.
func (s *State) Get(key string) (any, bool) {
	v, ok := s.Data[key]
	return v, ok
}

// Set writes a value into the workflow payload.
func (s *State) Set(key string, value any) {
	if s.Data == nil {
		s.Data = map[string]any{}
	}
	s.Data[key] = value
}

// Action is the work a step performs.
type Action func(ctx context.Context, state *State) error

// Retryable marks an error as worth another attempt. Errors that are not
// Retryable fail the step immediately: retrying a validation failure just burns
// the budget before compensating.
type Retryable struct{ Err error }

func (r Retryable) Error() string { return r.Err.Error() }
func (r Retryable) Unwrap() error { return r.Err }

// IsRetryable reports whether an error was marked Retryable.
func IsRetryable(err error) bool {
	var r Retryable
	return errors.As(err, &r)
}

// Step is one node of a workflow definition.
type Step struct {
	Name string
	Kind StepKind

	// Action runs for StepService steps.
	Action Action

	// Compensate undoes this step when it, or a later step, fails.
	//
	// It must be idempotent: the engine runs it for the failed step too, since
	// a step that errored may still have applied part of its effect. A step
	// with no Compensate is treated as having nothing to undo, which must be a
	// deliberate choice rather than an oversight.
	Compensate Action

	// MaxAttempts bounds retries for StepService. Zero means one attempt.
	MaxAttempts int
	// Backoff is the delay before the next attempt; it is multiplied by the
	// attempt number, giving linear backoff that is easy to reason about in
	// tests and predictable under load.
	Backoff time.Duration

	// AssignedRole and SLA apply to StepHumanTask.
	AssignedRole string
	SLA          time.Duration

	// Delay applies to StepTimer.
	Delay time.Duration

	// SignalName is the signal that releases a StepHumanTask.
	SignalName string
}

// Definition is a versioned workflow.
//
// A running instance is pinned to the version it started on. Publishing v2 must
// not change what an in-flight v1 instance does — that is the single property
// that makes it safe to deploy a workflow change on a Tuesday afternoon.
type Definition struct {
	Name    string
	Version int
	Steps   []Step
}

// ErrInvalidDefinition reports a definition the engine cannot run.
var ErrInvalidDefinition = errors.New("workflow: invalid definition")

// Validate rejects definitions that would fail at runtime.
func (d Definition) Validate() error {
	if strings.TrimSpace(d.Name) == "" {
		return fmt.Errorf("%w: name is required", ErrInvalidDefinition)
	}
	if d.Version <= 0 {
		return fmt.Errorf("%w: version must be positive", ErrInvalidDefinition)
	}
	if len(d.Steps) == 0 {
		return fmt.Errorf("%w: at least one step is required", ErrInvalidDefinition)
	}

	seen := make(map[string]bool, len(d.Steps))
	for _, step := range d.Steps {
		if strings.TrimSpace(step.Name) == "" {
			return fmt.Errorf("%w: every step needs a name", ErrInvalidDefinition)
		}
		if seen[step.Name] {
			return fmt.Errorf("%w: duplicate step %q", ErrInvalidDefinition, step.Name)
		}
		seen[step.Name] = true

		switch step.Kind {
		case StepService:
			if step.Action == nil {
				return fmt.Errorf("%w: service step %q has no action", ErrInvalidDefinition, step.Name)
			}
		case StepHumanTask:
			if step.AssignedRole == "" {
				return fmt.Errorf("%w: human task %q has no assigned role", ErrInvalidDefinition, step.Name)
			}
			if step.SLA <= 0 {
				return fmt.Errorf("%w: human task %q has no SLA", ErrInvalidDefinition, step.Name)
			}
			if step.SignalName == "" {
				return fmt.Errorf("%w: human task %q has no signal name", ErrInvalidDefinition, step.Name)
			}
		case StepTimer:
			if step.Delay <= 0 {
				return fmt.Errorf("%w: timer step %q has no delay", ErrInvalidDefinition, step.Name)
			}
		default:
			return fmt.Errorf("%w: step %q has unknown kind %q", ErrInvalidDefinition, step.Name, step.Kind)
		}
	}
	return nil
}

// Registry holds every published definition version.
type Registry struct {
	byNameVersion map[string]map[int]Definition
}

// NewRegistry constructs an empty registry.
func NewRegistry() *Registry {
	return &Registry{byNameVersion: map[string]map[int]Definition{}}
}

// ErrDefinitionNotFound reports a missing name or version.
var ErrDefinitionNotFound = errors.New("workflow: definition not found")

// Register publishes a definition version.
//
// Re-registering an existing version is refused: a running instance resolves
// its steps by version at every tick, so silently swapping the body of a
// published version would change behaviour underneath in-flight work.
func (r *Registry) Register(d Definition) error {
	if err := d.Validate(); err != nil {
		return err
	}
	versions, ok := r.byNameVersion[d.Name]
	if !ok {
		versions = map[int]Definition{}
		r.byNameVersion[d.Name] = versions
	}
	if _, exists := versions[d.Version]; exists {
		return fmt.Errorf("%w: %s v%d is already registered", ErrInvalidDefinition, d.Name, d.Version)
	}
	versions[d.Version] = d
	return nil
}

// Get returns one specific version.
func (r *Registry) Get(name string, version int) (Definition, error) {
	versions, ok := r.byNameVersion[name]
	if !ok {
		return Definition{}, fmt.Errorf("%w: %s", ErrDefinitionNotFound, name)
	}
	d, ok := versions[version]
	if !ok {
		return Definition{}, fmt.Errorf("%w: %s v%d", ErrDefinitionNotFound, name, version)
	}
	return d, nil
}

// Latest returns the highest registered version, used when starting a new
// instance. Running instances never call this.
func (r *Registry) Latest(name string) (Definition, error) {
	versions, ok := r.byNameVersion[name]
	if !ok || len(versions) == 0 {
		return Definition{}, fmt.Errorf("%w: %s", ErrDefinitionNotFound, name)
	}
	best := 0
	for v := range versions {
		if v > best {
			best = v
		}
	}
	return versions[best], nil
}
