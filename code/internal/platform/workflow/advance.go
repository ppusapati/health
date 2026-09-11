package workflow

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// DefaultBatchSize bounds one tick so a large backlog is worked through in
// steady increments.
const DefaultBatchSize = 50

// Tick performs one engine cycle: fire due timers, expire overdue human tasks,
// then advance every runnable instance by one step.
//
// Ordering matters. Timers must fire before instances are claimed, or an
// instance whose timer came due in this cycle would wait a whole extra tick.
func (e *Engine) Tick(ctx context.Context, batchSize int32) (advanced int, err error) {
	if batchSize <= 0 {
		batchSize = DefaultBatchSize
	}
	now := e.clock.Now()

	if err := e.fireDueTimers(ctx, now, batchSize); err != nil {
		return 0, err
	}
	if err := e.expireOverdueTasks(ctx, now); err != nil {
		return 0, err
	}

	// Two passes, and the split is load-bearing.
	//
	// The first pass only builds a candidate list. It cannot also do the work,
	// because the row locks it takes are released when its transaction commits
	// — so a second replica would claim the same instances and run the same
	// steps. The optimistic version predicate would reject the loser's write,
	// but by then the step body has already executed, and a side effect is not
	// something a rolled-back transaction takes back.
	//
	// The second pass therefore re-locks each instance individually and holds
	// that lock across the step. A candidate another replica already has is
	// skipped rather than waited for.
	var candidates []uuid.UUID
	if err := e.tx.WithinTx(ctx, func(ctx context.Context) error {
		rows, err := e.queries(ctx).ClaimRunnableInstances(ctx, batchSize)
		if err != nil {
			return err
		}
		for _, row := range rows {
			candidates = append(candidates, row.InstanceID)
		}
		return nil
	}); err != nil {
		return 0, err
	}

	for _, id := range candidates {
		// Each instance advances in its own transaction: one failing workflow
		// must not roll back the progress of every other workflow in the batch.
		var ran bool
		stepErr := e.tx.WithinTx(ctx, func(ctx context.Context) error {
			row, err := e.queries(ctx).LockWorkflowInstance(ctx, id)
			if errors.Is(err, pgx.ErrNoRows) {
				// Another replica holds it, or it left the runnable set
				// between the two passes. Either way it is not ours.
				return nil
			}
			if err != nil {
				return err
			}
			ran = true
			// The freshly locked row, not the candidate snapshot: the instance
			// may have moved on since the first pass read it.
			return e.advanceOne(ctx, instanceFromRow(row), now)
		})
		if stepErr != nil {
			// A concurrency conflict simply means another replica got there
			// first; it is not an error worth failing the tick over.
			if errors.Is(stepErr, ErrConcurrentUpdate) {
				continue
			}
			return advanced, stepErr
		}
		if ran {
			advanced++
		}
	}
	return advanced, nil
}

// fireDueTimers releases instances whose timer has come due.
func (e *Engine) fireDueTimers(ctx context.Context, now time.Time, batchSize int32) error {
	return e.tx.WithinTx(ctx, func(ctx context.Context) error {
		q := e.queries(ctx)

		timers, err := q.ClaimDueTimers(ctx, sqlcgen.ClaimDueTimersParams{
			Now:       timestamptz(now),
			PageLimit: batchSize,
		})
		if err != nil {
			return err
		}

		for _, timer := range timers {
			if err := q.MarkTimerFired(ctx, sqlcgen.MarkTimerFiredParams{
				TimerID: timer.TimerID,
				FiredAt: timestamptz(now),
			}); err != nil {
				return err
			}

			row, err := q.GetWorkflowInstance(ctx, sqlcgen.GetWorkflowInstanceParams{
				TenantID:   timer.TenantID,
				InstanceID: timer.InstanceID,
			})
			if err != nil {
				return err
			}
			instance := instanceFromRow(row)

			// Only a timer the instance is actually waiting on releases it. A
			// stale retry timer for a step that has since moved on must not
			// resurrect a completed or compensating instance.
			if instance.Status != StatusAwaitingTimer || instance.CurrentStep != timer.Step {
				continue
			}

			if err := e.appendHistory(ctx, timer.InstanceID, timer.TenantID,
				EventTimerFired, timer.Step, instance.Attempts, nil, now); err != nil {
				return err
			}

			instance.Status = StatusRunning
			if err := e.persist(ctx, instance, now); err != nil {
				return err
			}
		}
		return nil
	})
}

// expireOverdueTasks marks human tasks past their SLA.
//
// Expiry is recorded but does not itself advance the workflow: what happens to
// an unanswered approval is a business decision, not an engine default.
func (e *Engine) expireOverdueTasks(ctx context.Context, now time.Time) error {
	return e.tx.WithinTx(ctx, func(ctx context.Context) error {
		_, err := e.queries(ctx).ExpireOverdueHumanTasks(ctx, sqlcgen.ExpireOverdueHumanTasksParams{
			UpdatedAt: timestamptz(now),
			Now:       timestamptz(now),
		})
		return err
	})
}

// advanceOne moves a single instance forward by one step.
func (e *Engine) advanceOne(ctx context.Context, instance Instance, now time.Time) error {
	definition, err := e.registry.Get(instance.DefinitionName, instance.DefinitionVersion)
	if err != nil {
		// The instance is pinned to a version nobody registered. Failing loudly
		// is right: silently upgrading it to the latest version would change
		// behaviour under an in-flight workflow.
		return err
	}

	if instance.Status == StatusCompensating {
		return e.compensateOne(ctx, instance, definition, now)
	}

	if instance.StepIndex >= len(definition.Steps) {
		return e.finish(ctx, instance, StatusCompleted, EventCompleted, now)
	}

	step := definition.Steps[instance.StepIndex]
	state := &State{
		InstanceID:     instance.ID,
		TenantID:       instance.TenantID,
		CorrelationKey: instance.CorrelationKey,
		Data:           instance.State,
	}

	instanceUUID, err := uuid.Parse(instance.ID)
	if err != nil {
		return rpcerr.Internal("WF_ID_INVALID", "instance_id must be a UUID").WithCause(err)
	}
	tenantUUID, err := uuid.Parse(instance.TenantID)
	if err != nil {
		return rpcerr.Internal("WF_TENANT_INVALID", "tenant_id must be a UUID").WithCause(err)
	}

	switch step.Kind {
	case StepService:
		return e.runServiceStep(ctx, instance, definition, step, state, instanceUUID, tenantUUID, now)
	case StepTimer:
		return e.scheduleTimer(ctx, instance, step, instanceUUID, tenantUUID, now)
	case StepHumanTask:
		return e.createHumanTask(ctx, instance, step, instanceUUID, tenantUUID, now)
	default:
		return rpcerr.Internal("WF_STEP_KIND_UNKNOWN", "unknown step kind")
	}
}

// runServiceStep executes an action, retrying transient failures and falling
// back to compensation once the attempt budget is exhausted.
func (e *Engine) runServiceStep(ctx context.Context, instance Instance, definition Definition,
	step Step, state *State, instanceUUID, tenantUUID uuid.UUID, now time.Time) error {

	attempt := instance.Attempts + 1

	if err := e.appendHistory(ctx, instanceUUID, tenantUUID, EventStepStarted, step.Name, attempt, nil, now); err != nil {
		return err
	}

	actionErr := step.Action(ctx, state)
	instance.State = state.Data

	if actionErr == nil {
		if err := e.appendHistory(ctx, instanceUUID, tenantUUID, EventStepCompleted, step.Name, attempt, nil, now); err != nil {
			return err
		}
		instance.StepIndex++
		instance.Attempts = 0
		instance.LastError = ""
		if instance.StepIndex >= len(definition.Steps) {
			instance.Status = StatusCompleted
			instance.CurrentStep = ""
			if err := e.persist(ctx, instance, now); err != nil {
				return err
			}
			return e.appendHistory(ctx, instanceUUID, tenantUUID, EventCompleted, "", 0, nil, now)
		}
		instance.CurrentStep = definition.Steps[instance.StepIndex].Name
		instance.Status = StatusRunning
		return e.persist(ctx, instance, now)
	}

	maxAttempts := step.MaxAttempts
	if maxAttempts <= 0 {
		maxAttempts = 1
	}

	// Only errors explicitly marked Retryable are retried. Retrying a
	// validation failure would just burn the budget before compensating.
	canRetry := IsRetryable(actionErr) && attempt < maxAttempts

	if err := e.appendHistory(ctx, instanceUUID, tenantUUID, EventStepFailed, step.Name, attempt,
		map[string]any{"error": actionErr.Error(), "will_retry": canRetry}, now); err != nil {
		return err
	}

	instance.Attempts = attempt
	instance.LastError = actionErr.Error()

	if canRetry {
		backoff := step.Backoff * time.Duration(attempt)
		if backoff <= 0 {
			// Without a backoff the retry happens on the next tick, which is
			// still a real delay rather than a hot loop.
			instance.Status = StatusRunning
			if err := e.appendHistory(ctx, instanceUUID, tenantUUID, EventStepRetrying, step.Name, attempt, nil, now); err != nil {
				return err
			}
			return e.persist(ctx, instance, now)
		}

		if err := e.scheduleTimerRow(ctx, instanceUUID, tenantUUID, step.Name, now.Add(backoff), now); err != nil {
			return err
		}
		instance.Status = StatusAwaitingTimer
		if err := e.appendHistory(ctx, instanceUUID, tenantUUID, EventStepRetrying, step.Name, attempt,
			map[string]any{"backoff_seconds": backoff.Seconds()}, now); err != nil {
			return err
		}
		return e.persist(ctx, instance, now)
	}

	// Budget exhausted or a permanent failure: undo what has been done.
	//
	// Compensation starts at the failed step itself, not the one before it. A
	// step that returned an error may still have applied part of its effect —
	// created the row and then failed to publish, say — and the engine cannot
	// know which. Compensators are therefore required to be idempotent, and
	// running one for a step that did nothing is harmless; skipping one for a
	// step that did something leaves an orphan.
	instance.Status = StatusCompensating
	if err := e.appendHistory(ctx, instanceUUID, tenantUUID, EventCompensating, step.Name, attempt,
		map[string]any{"reason": actionErr.Error()}, now); err != nil {
		return err
	}
	return e.persist(ctx, instance, now)
}

// compensateOne walks one step backwards, running its compensating action.
func (e *Engine) compensateOne(ctx context.Context, instance Instance, definition Definition, now time.Time) error {
	instanceUUID, err := uuid.Parse(instance.ID)
	if err != nil {
		return rpcerr.Internal("WF_ID_INVALID", "instance_id must be a UUID").WithCause(err)
	}
	tenantUUID, err := uuid.Parse(instance.TenantID)
	if err != nil {
		return rpcerr.Internal("WF_TENANT_INVALID", "tenant_id must be a UUID").WithCause(err)
	}

	if instance.StepIndex < 0 {
		instance.Status = StatusCompensated
		instance.CurrentStep = ""
		if err := e.persist(ctx, instance, now); err != nil {
			return err
		}
		return e.appendHistory(ctx, instanceUUID, tenantUUID, EventCompensated, "", 0, nil, now)
	}

	step := definition.Steps[instance.StepIndex]
	state := &State{
		InstanceID:     instance.ID,
		TenantID:       instance.TenantID,
		CorrelationKey: instance.CorrelationKey,
		Data:           instance.State,
	}

	if step.Compensate != nil {
		if err := step.Compensate(ctx, state); err != nil {
			// A failed compensation is not retried into oblivion: it needs a
			// human. Marking the instance failed puts it on an operator's
			// exception queue instead of hiding it.
			instance.Status = StatusFailed
			instance.LastError = "compensation failed: " + err.Error()
			if persistErr := e.persist(ctx, instance, now); persistErr != nil {
				return persistErr
			}
			return e.appendHistory(ctx, instanceUUID, tenantUUID, EventFailed, step.Name, 0,
				map[string]any{"error": err.Error(), "phase": "compensation"}, now)
		}
		instance.State = state.Data
		if err := e.appendHistory(ctx, instanceUUID, tenantUUID, EventStepCompensated, step.Name, 0, nil, now); err != nil {
			return err
		}
	}

	instance.StepIndex--
	instance.CurrentStep = step.Name
	return e.persist(ctx, instance, now)
}

// scheduleTimer parks the instance on a durable timer.
func (e *Engine) scheduleTimer(ctx context.Context, instance Instance, step Step,
	instanceUUID, tenantUUID uuid.UUID, now time.Time) error {

	dueAt := now.Add(step.Delay)
	if err := e.scheduleTimerRow(ctx, instanceUUID, tenantUUID, step.Name, dueAt, now); err != nil {
		return err
	}

	// The timer step itself is complete once the timer exists; when it fires,
	// the instance resumes at the following step.
	instance.StepIndex++
	instance.Status = StatusAwaitingTimer
	instance.CurrentStep = step.Name

	if err := e.appendHistory(ctx, instanceUUID, tenantUUID, EventTimerScheduled, step.Name, 0,
		map[string]any{"due_at": dueAt.UTC().Format(time.RFC3339Nano)}, now); err != nil {
		return err
	}
	return e.persist(ctx, instance, now)
}

func (e *Engine) scheduleTimerRow(ctx context.Context, instanceUUID, tenantUUID uuid.UUID,
	step string, dueAt, now time.Time) error {

	timerUUID, err := uuid.Parse(e.ids.NewID())
	if err != nil {
		return rpcerr.Internal("WF_ID_INVALID", "timer_id must be a UUID").WithCause(err)
	}
	return e.queries(ctx).InsertWorkflowTimer(ctx, sqlcgen.InsertWorkflowTimerParams{
		TimerID:    timerUUID,
		InstanceID: instanceUUID,
		TenantID:   tenantUUID,
		Step:       step,
		DueAt:      timestamptz(dueAt),
		CreatedAt:  timestamptz(now),
	})
}

// createHumanTask parks the instance awaiting an approval signal.
func (e *Engine) createHumanTask(ctx context.Context, instance Instance, step Step,
	instanceUUID, tenantUUID uuid.UUID, now time.Time) error {

	taskUUID, err := uuid.Parse(e.ids.NewID())
	if err != nil {
		return rpcerr.Internal("WF_ID_INVALID", "task_id must be a UUID").WithCause(err)
	}

	dueAt := now.Add(step.SLA)
	if err := e.queries(ctx).InsertHumanTask(ctx, sqlcgen.InsertHumanTaskParams{
		TaskID:       taskUUID,
		InstanceID:   instanceUUID,
		TenantID:     tenantUUID,
		Step:         step.Name,
		AssignedRole: step.AssignedRole,
		DueAt:        timestamptz(dueAt),
		CreatedAt:    timestamptz(now),
	}); err != nil {
		return err
	}

	instance.Status = StatusAwaitingSignal
	instance.CurrentStep = step.Name

	if err := e.appendHistory(ctx, instanceUUID, tenantUUID, EventTaskCreated, step.Name, 0,
		map[string]any{"task_id": taskUUID.String(), "role": step.AssignedRole,
			"due_at": dueAt.UTC().Format(time.RFC3339Nano)}, now); err != nil {
		return err
	}
	return e.persist(ctx, instance, now)
}

// finish marks an instance terminal.
func (e *Engine) finish(ctx context.Context, instance Instance, status, event string, now time.Time) error {
	instanceUUID, err := uuid.Parse(instance.ID)
	if err != nil {
		return rpcerr.Internal("WF_ID_INVALID", "instance_id must be a UUID").WithCause(err)
	}
	tenantUUID, err := uuid.Parse(instance.TenantID)
	if err != nil {
		return rpcerr.Internal("WF_TENANT_INVALID", "tenant_id must be a UUID").WithCause(err)
	}

	instance.Status = status
	instance.CurrentStep = ""
	if err := e.persist(ctx, instance, now); err != nil {
		return err
	}
	return e.appendHistory(ctx, instanceUUID, tenantUUID, event, "", 0, nil, now)
}

// HistoryEntry is one row of execution history.
type HistoryEntry struct {
	Sequence   int
	EventType  string
	Step       string
	Attempt    int
	Detail     map[string]any
	OccurredAt time.Time
}

// History returns the full execution history of an instance — the visibility
// surface ADR-006 requires evidence for.
func (e *Engine) History(ctx context.Context, tenantID, instanceID string) ([]HistoryEntry, error) {
	tenantUUID, err := uuid.Parse(tenantID)
	if err != nil {
		return nil, rpcerr.NotFound("WF_INSTANCE_NOT_FOUND", "workflow instance not found")
	}
	instanceUUID, err := uuid.Parse(instanceID)
	if err != nil {
		return nil, rpcerr.NotFound("WF_INSTANCE_NOT_FOUND", "workflow instance not found")
	}

	rows, err := e.queries(ctx).ListWorkflowHistory(ctx, sqlcgen.ListWorkflowHistoryParams{
		TenantID:   tenantUUID,
		InstanceID: instanceUUID,
	})
	if err != nil {
		return nil, err
	}

	out := make([]HistoryEntry, 0, len(rows))
	for _, row := range rows {
		detail := map[string]any{}
		_ = json.Unmarshal(row.Detail, &detail)
		out = append(out, HistoryEntry{
			Sequence:   int(row.Sequence),
			EventType:  row.EventType,
			Step:       row.Step,
			Attempt:    int(row.Attempt),
			Detail:     detail,
			OccurredAt: row.OccurredAt.Time,
		})
	}
	return out, nil
}
