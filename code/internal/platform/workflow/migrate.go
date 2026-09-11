package workflow

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Version migration (ADR-006).
//
// Pinning is what makes deploying a workflow change safe: publishing v2 cannot
// change what an in-flight v1 instance does. But pinning alone is not a
// complete answer, because some instances are long-lived — a tenant onboarding
// waiting on a human approval may outlive several releases — and "wait for
// every v1 instance to drain" is not a plan when a v1 instance is waiting on
// the very bug v2 fixes.
//
// So migration is an explicit operator action on one instance, never an
// implicit upgrade. Everything below is a refusal rather than a guess: the
// cases this cannot safely handle are the cases where a human has to decide.

// ErrMigrationRefused reports a migration the engine will not perform.
var ErrMigrationRefused = errors.New("workflow: migration refused")

// terminalStatuses cannot be migrated: there is nothing left to run, and
// rewriting the version would falsify the record of what actually executed.
var terminalStatuses = map[string]bool{
	StatusCompleted:   true,
	StatusFailed:      true,
	StatusCompensated: true,
	StatusCancelled:   true,
}

// EventMigrated records a version migration in the instance history.
const EventMigrated = "migrated"

// Migrate moves one in-flight instance onto another registered version of its
// definition.
//
// The instance resumes at the step with the SAME NAME in the target version,
// not the same index. Steps get inserted and removed between versions, so an
// index carried across is a silent jump to whatever now sits at that position
// — which in a clinical workflow means skipping an approval.
//
// Migrating to the version the instance is already on succeeds and changes
// nothing, so re-running an operator's migration script is safe.
func (e *Engine) Migrate(ctx context.Context, tenantID, instanceID string, targetVersion int) (Instance, error) {
	var migrated Instance

	err := e.tx.WithinTx(ctx, func(ctx context.Context) error {
		current, err := e.Get(ctx, tenantID, instanceID)
		if err != nil {
			return err
		}

		if current.DefinitionVersion == targetVersion {
			migrated = current
			return nil
		}

		target, err := e.registry.Get(current.DefinitionName, targetVersion)
		if err != nil {
			return fmt.Errorf("%w: %w", ErrMigrationRefused, err)
		}

		if err := checkMigratable(current, target); err != nil {
			return err
		}

		index, _ := target.StepIndex(current.CurrentStep)

		instanceUUID, err := uuid.Parse(current.ID)
		if err != nil {
			return err
		}
		tenantUUID, err := uuid.Parse(current.TenantID)
		if err != nil {
			return err
		}

		now := e.clock.Now()
		rows, err := e.queries(ctx).MigrateWorkflowInstance(ctx, sqlcgen.MigrateWorkflowInstanceParams{
			DefinitionVersion: int32(targetVersion),
			StepIndex:         int32(index),
			UpdatedAt:         timestamptz(now),
			InstanceID:        instanceUUID,
			TenantID:          tenantUUID,
			ExpectedVersion:   current.Version,
		})
		if err != nil {
			return err
		}
		if rows == 0 {
			// The engine advanced the instance between the read and the write.
			// Refusing is the only safe answer: the step the operator inspected
			// is not the step the instance is on any more.
			return fmt.Errorf("%w: %s changed while migrating", ErrConcurrentUpdate, current.ID)
		}

		// The retry budget is reset. It belongs to (instance, step, version),
		// and an operator migrating a failing instance is doing so precisely
		// because the old version could not get past this step; making them
		// spend the exhausted budget again would defeat the migration.
		if err := e.appendHistory(ctx, instanceUUID, tenantUUID, EventMigrated,
			current.CurrentStep, 0, map[string]any{
				"from_version": current.DefinitionVersion,
				"to_version":   targetVersion,
				"from_index":   current.StepIndex,
				"to_index":     index,
			}, now); err != nil {
			return err
		}

		migrated = current
		migrated.DefinitionVersion = targetVersion
		migrated.StepIndex = index
		migrated.Attempts = 0
		migrated.LastError = ""
		migrated.Version = current.Version + 1
		return nil
	})
	if err != nil {
		return Instance{}, err
	}
	return migrated, nil
}

// checkMigratable states every condition under which a migration is refused.
func checkMigratable(current Instance, target Definition) error {
	if terminalStatuses[current.Status] {
		return fmt.Errorf("%w: %s is %s and has nothing left to run",
			ErrMigrationRefused, current.ID, current.Status)
	}

	if current.Status == StatusCompensating {
		// Compensation walks backwards through the steps the instance actually
		// executed. Remapping mid-unwind would compensate the target version's
		// steps for work the source version's steps did.
		return fmt.Errorf("%w: %s is compensating; let it finish or cancel it",
			ErrMigrationRefused, current.ID)
	}

	index, ok := target.StepIndex(current.CurrentStep)
	if !ok {
		return fmt.Errorf("%w: %s v%d has no step %q, so there is no safe place to resume",
			ErrMigrationRefused, target.Name, target.Version, current.CurrentStep)
	}

	// The kind must match. Resuming a human task as a service step executes the
	// approval instead of waiting for it, and resuming a service step as a
	// human task waits for a signal nobody will send.
	if got, want := target.Steps[index].Kind, current.stepKind(); want != "" && got != want {
		return fmt.Errorf("%w: step %q is %s in v%d but the instance is waiting on a %s",
			ErrMigrationRefused, current.CurrentStep, got, target.Version, want)
	}
	return nil
}

// stepKind infers what the instance is currently waiting on from its status.
// Returns "" when the status does not imply a kind, in which case the name
// match is the only check that applies.
func (i Instance) stepKind() StepKind {
	switch i.Status {
	case StatusAwaitingSignal:
		return StepHumanTask
	case StatusAwaitingTimer:
		return StepTimer
	default:
		return ""
	}
}

// List returns instances for a tenant, optionally filtered by status.
//
// Operator visibility (ADR-006): a durable workflow whose state can only be
// inferred from logs is not operable.
func (e *Engine) List(ctx context.Context, tenantID, status string, limit int32) ([]Instance, error) {
	tenantUUID, err := uuid.Parse(tenantID)
	if err != nil {
		return nil, nil
	}
	if limit <= 0 {
		limit = int32(DefaultBatchSize)
	}

	var statusFilter *string
	if status != "" {
		statusFilter = &status
	}

	rows, err := e.queries(ctx).ListWorkflowInstances(ctx, sqlcgen.ListWorkflowInstancesParams{
		TenantID: tenantUUID, Status: statusFilter, PageLimit: limit,
	})
	if err != nil && !errors.Is(err, pgx.ErrNoRows) {
		return nil, err
	}
	return instancesFromRows(rows), nil
}

// Stalled returns runnable instances that have not moved since `before`.
//
// Cross-tenant on purpose: this answers "is the engine advancing anything at
// all", and a per-tenant view hides a total stall behind whichever tenant
// happens to be quiet.
func (e *Engine) Stalled(ctx context.Context, before time.Time, limit int32) ([]Instance, error) {
	if limit <= 0 {
		limit = int32(DefaultBatchSize)
	}
	rows, err := e.queries(ctx).ListStalledWorkflowInstances(ctx, sqlcgen.ListStalledWorkflowInstancesParams{
		StalledBefore: timestamptz(before), PageLimit: limit,
	})
	if err != nil && !errors.Is(err, pgx.ErrNoRows) {
		return nil, err
	}
	return instancesFromRows(rows), nil
}

func instancesFromRows(rows []sqlcgen.PlatformWorkflowInstance) []Instance {
	out := make([]Instance, 0, len(rows))
	for _, row := range rows {
		out = append(out, instanceFromRow(row))
	}
	return out
}
