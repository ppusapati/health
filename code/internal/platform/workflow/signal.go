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

// SignalResult describes what a signal did.
type SignalResult struct {
	// Accepted is false when the signal was a duplicate or arrived for a step
	// the instance is not waiting on.
	Accepted bool
	// Reason is a stable code when the signal was not accepted.
	Reason string
}

// Stable signal rejection reasons.
const (
	ReasonDuplicateSignal = "DUPLICATE_SIGNAL"
	ReasonNotAwaiting     = "INSTANCE_NOT_AWAITING_SIGNAL"
	ReasonWrongStep       = "SIGNAL_FOR_DIFFERENT_STEP"
)

// Signal delivers an external event to a waiting instance.
//
// Signals arrive at least once, late, and sometimes out of order (Domain/Data
// spec §9). Three defences apply, in order:
//
//  1. signalKey is a primary key, so redelivery is a no-op;
//  2. an instance not awaiting a signal ignores it rather than jumping state;
//  3. a signal naming a step the instance has moved past is ignored.
//
// All three record history, so an operator can see that a signal arrived and
// why nothing happened.
func (e *Engine) Signal(ctx context.Context, tenantID, instanceID, signalKey, signalName string, payload map[string]any) (SignalResult, error) {
	tenantUUID, instanceUUID, err := parseTenantAndInstance(tenantID, instanceID)
	if err != nil {
		return SignalResult{}, err
	}

	var result SignalResult
	err = e.tx.WithinTx(ctx, func(ctx context.Context) error {
		var deliverErr error
		result, deliverErr = e.deliverSignal(ctx, tenantUUID, instanceUUID, signalKey, signalName, payload)
		return deliverErr
	})
	if err != nil {
		return SignalResult{}, err
	}
	return result, nil
}

// deliverSignal is the shared body used by Signal and CompleteTask. It must run
// inside a transaction so the signal row, the history entry and the instance
// advance commit together.
func (e *Engine) deliverSignal(ctx context.Context, tenantUUID, instanceUUID uuid.UUID,
	signalKey, signalName string, payload map[string]any) (SignalResult, error) {

	q := e.queries(ctx)
	now := e.clock.Now()

	encoded, err := json.Marshal(payload)
	if err != nil {
		return SignalResult{}, rpcerr.Internal("WF_SIGNAL_ENCODE_FAILED",
			"could not encode signal payload").WithCause(err)
	}

	rows, err := q.TryRecordSignal(ctx, sqlcgen.TryRecordSignalParams{
		InstanceID: instanceUUID,
		SignalKey:  signalKey,
		TenantID:   tenantUUID,
		SignalName: signalName,
		Payload:    encoded,
		ReceivedAt: timestamptz(now),
	})
	if err != nil {
		return SignalResult{}, err
	}
	if rows == 0 {
		return e.ignoreSignal(ctx, instanceUUID, tenantUUID, "", signalName, ReasonDuplicateSignal, nil, now)
	}

	row, err := q.GetWorkflowInstance(ctx, sqlcgen.GetWorkflowInstanceParams{
		TenantID:   tenantUUID,
		InstanceID: instanceUUID,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return SignalResult{}, rpcerr.NotFound("WF_INSTANCE_NOT_FOUND", "workflow instance not found")
	}
	if err != nil {
		return SignalResult{}, err
	}
	instance := instanceFromRow(row)

	if instance.Status != StatusAwaitingSignal {
		return e.ignoreSignal(ctx, instanceUUID, tenantUUID, instance.CurrentStep, signalName,
			ReasonNotAwaiting, map[string]any{"status": instance.Status}, now)
	}

	definition, err := e.registry.Get(instance.DefinitionName, instance.DefinitionVersion)
	if err != nil {
		return SignalResult{}, err
	}
	if instance.StepIndex >= len(definition.Steps) {
		return SignalResult{}, rpcerr.Internal("WF_STEP_OUT_OF_RANGE", "instance step index is out of range")
	}

	step := definition.Steps[instance.StepIndex]
	if step.SignalName != signalName {
		return e.ignoreSignal(ctx, instanceUUID, tenantUUID, step.Name, signalName,
			ReasonWrongStep, map[string]any{"awaiting": step.SignalName}, now)
	}

	// The signal payload becomes part of workflow state so later steps can act
	// on the approver's decision.
	if len(payload) > 0 && instance.State == nil {
		instance.State = map[string]any{}
	}
	for key, value := range payload {
		instance.State[key] = value
	}

	instance.StepIndex++
	instance.Attempts = 0
	instance.Status = StatusRunning
	if instance.StepIndex < len(definition.Steps) {
		instance.CurrentStep = definition.Steps[instance.StepIndex].Name
	} else {
		instance.CurrentStep = ""
	}

	if err := e.appendHistory(ctx, instanceUUID, tenantUUID, EventSignalReceived, step.Name, 0,
		map[string]any{"signal": signalName}, now); err != nil {
		return SignalResult{}, err
	}
	if err := e.persist(ctx, instance, now); err != nil {
		return SignalResult{}, err
	}
	return SignalResult{Accepted: true}, nil
}

// ignoreSignal records that a signal arrived and was not acted on.
func (e *Engine) ignoreSignal(ctx context.Context, instanceUUID, tenantUUID uuid.UUID,
	step, signalName, reason string, extra map[string]any, now time.Time) (SignalResult, error) {

	detail := map[string]any{"signal": signalName, "reason": reason}
	for k, v := range extra {
		detail[k] = v
	}
	if err := e.appendHistory(ctx, instanceUUID, tenantUUID, EventSignalIgnored, step, 0, detail, now); err != nil {
		return SignalResult{}, err
	}
	return SignalResult{Accepted: false, Reason: reason}, nil
}

// HumanTask is an approval item.
type HumanTask struct {
	ID           string
	InstanceID   string
	Step         string
	AssignedRole string
	Status       string
	DueAt        time.Time
	CompletedBy  string
	Outcome      string
}

// ListOpenTasks returns the tenant's open human tasks.
func (e *Engine) ListOpenTasks(ctx context.Context, tenantID string) ([]HumanTask, error) {
	tenantUUID, err := uuid.Parse(tenantID)
	if err != nil {
		return nil, rpcerr.Internal("WF_TENANT_INVALID", "tenant_id must be a UUID").WithCause(err)
	}

	rows, err := e.queries(ctx).ListOpenHumanTasks(ctx, tenantUUID)
	if err != nil {
		return nil, err
	}

	out := make([]HumanTask, 0, len(rows))
	for _, row := range rows {
		out = append(out, HumanTask{
			ID:           row.TaskID.String(),
			InstanceID:   row.InstanceID.String(),
			Step:         row.Step,
			AssignedRole: row.AssignedRole,
			Status:       row.Status,
			DueAt:        row.DueAt.Time,
			CompletedBy:  row.CompletedBy,
			Outcome:      row.Outcome,
		})
	}
	return out, nil
}

// CompleteTask records a human decision and signals the waiting instance.
//
// The task update and the signal commit in one transaction: a completed task
// whose signal was lost would strand the workflow with nothing to show for it.
// The task ID doubles as the signal key, so completing the same task twice is
// idempotent even if the first response was lost in transit.
func (e *Engine) CompleteTask(ctx context.Context, tenantID, taskID, completedBy, outcome string) (SignalResult, error) {
	tenantUUID, err := uuid.Parse(tenantID)
	if err != nil {
		return SignalResult{}, rpcerr.NotFound("WF_TASK_NOT_FOUND", "task not found")
	}
	taskUUID, err := uuid.Parse(taskID)
	if err != nil {
		return SignalResult{}, rpcerr.NotFound("WF_TASK_NOT_FOUND", "task not found")
	}

	var result SignalResult
	err = e.tx.WithinTx(ctx, func(ctx context.Context) error {
		q := e.queries(ctx)
		now := e.clock.Now()

		task, err := q.GetHumanTask(ctx, sqlcgen.GetHumanTaskParams{
			TenantID: tenantUUID,
			TaskID:   taskUUID,
		})
		if errors.Is(err, pgx.ErrNoRows) {
			return rpcerr.NotFound("WF_TASK_NOT_FOUND", "task not found")
		}
		if err != nil {
			return err
		}

		rows, err := q.CompleteHumanTask(ctx, sqlcgen.CompleteHumanTaskParams{
			CompletedBy: completedBy,
			Outcome:     outcome,
			UpdatedAt:   timestamptz(now),
			TaskID:      taskUUID,
			TenantID:    tenantUUID,
		})
		if err != nil {
			return err
		}
		if rows == 0 {
			// Already completed, expired or cancelled. A precondition failure
			// is more honest than silently pretending it worked.
			return rpcerr.FailedPrecondition("WF_TASK_NOT_OPEN", "task is no longer open")
		}

		// The signal name comes from the definition, not from the caller: a
		// task can only release the step that created it.
		signalName, err := e.signalNameForStep(ctx, tenantUUID, task.InstanceID, task.Step)
		if err != nil {
			return err
		}

		result, err = e.deliverSignal(ctx, tenantUUID, task.InstanceID, taskUUID.String(), signalName,
			map[string]any{
				"task_outcome":      outcome,
				"task_completed_by": completedBy,
			})
		return err
	})
	if err != nil {
		return SignalResult{}, err
	}
	return result, nil
}

// signalNameForStep resolves the signal a given step of a running instance is
// waiting on, from the definition version that instance is pinned to.
func (e *Engine) signalNameForStep(ctx context.Context, tenantUUID, instanceUUID uuid.UUID, stepName string) (string, error) {
	row, err := e.queries(ctx).GetWorkflowInstance(ctx, sqlcgen.GetWorkflowInstanceParams{
		TenantID:   tenantUUID,
		InstanceID: instanceUUID,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return "", rpcerr.NotFound("WF_INSTANCE_NOT_FOUND", "workflow instance not found")
	}
	if err != nil {
		return "", err
	}

	definition, err := e.registry.Get(row.DefinitionName, int(row.DefinitionVersion))
	if err != nil {
		return "", err
	}
	for _, step := range definition.Steps {
		if step.Name == stepName {
			return step.SignalName, nil
		}
	}
	return "", rpcerr.Internal("WF_STEP_NOT_IN_DEFINITION", "task references a step that is not in the definition")
}

func parseTenantAndInstance(tenantID, instanceID string) (uuid.UUID, uuid.UUID, error) {
	tenantUUID, err := uuid.Parse(tenantID)
	if err != nil {
		return uuid.Nil, uuid.Nil, rpcerr.NotFound("WF_INSTANCE_NOT_FOUND", "workflow instance not found")
	}
	instanceUUID, err := uuid.Parse(instanceID)
	if err != nil {
		return uuid.Nil, uuid.Nil, rpcerr.NotFound("WF_INSTANCE_NOT_FOUND", "workflow instance not found")
	}
	return tenantUUID, instanceUUID, nil
}
