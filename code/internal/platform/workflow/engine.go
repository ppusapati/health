package workflow

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Instance status values, mirroring the CHECK constraint on the table.
const (
	StatusRunning        = "running"
	StatusAwaitingSignal = "awaiting_signal"
	StatusAwaitingTimer  = "awaiting_timer"
	StatusCompleted      = "completed"
	StatusFailed         = "failed"
	StatusCompensating   = "compensating"
	StatusCompensated    = "compensated"
	StatusCancelled      = "cancelled"
)

// History event types.
const (
	EventStarted         = "started"
	EventStepStarted     = "step_started"
	EventStepCompleted   = "step_completed"
	EventStepFailed      = "step_failed"
	EventStepRetrying    = "step_retrying"
	EventTimerScheduled  = "timer_scheduled"
	EventTimerFired      = "timer_fired"
	EventTaskCreated     = "task_created"
	EventSignalReceived  = "signal_received"
	EventSignalIgnored   = "signal_ignored"
	EventCompensating    = "compensating"
	EventStepCompensated = "step_compensated"
	EventCompleted       = "completed"
	EventCompensated     = "compensated"
	EventFailed          = "failed"
)

// Clock supplies time, injected so tests can advance it deterministically
// rather than sleeping.
type Clock interface{ Now() time.Time }

// IDGenerator mints instance, timer and task identifiers.
type IDGenerator interface{ NewID() string }

// Engine advances durable workflow instances.
//
// It is tick-driven: Advance claims runnable instances and steps them forward.
// A background loop calls it on an interval in production; tests call it
// directly, which makes every assertion about retries, timers and compensation
// deterministic.
type Engine struct {
	tx       *pgtx.Manager
	registry *Registry
	clock    Clock
	ids      IDGenerator
}

// NewEngine constructs an Engine.
func NewEngine(tx *pgtx.Manager, registry *Registry, clock Clock, ids IDGenerator) *Engine {
	return &Engine{tx: tx, registry: registry, clock: clock, ids: ids}
}

func (e *Engine) queries(ctx context.Context) *sqlcgen.Queries {
	return sqlcgen.New(e.tx.Querier(ctx))
}

func timestamptz(t time.Time) pgtype.Timestamptz {
	return pgtype.Timestamptz{Time: t.UTC(), Valid: true}
}

// Instance is the caller-visible view of a running workflow.
type Instance struct {
	ID                string
	TenantID          string
	DefinitionName    string
	DefinitionVersion int
	CorrelationKey    string
	Status            string
	CurrentStep       string
	StepIndex         int
	Attempts          int
	State             map[string]any
	LastError         string
	Version           int64
}

// Start begins a new instance on the latest registered definition version.
//
// It is idempotent on (tenant, definition, correlation key): a retried caller
// gets the existing instance back rather than forking a second one. Duplicate
// starts are the normal consequence of at-least-once delivery upstream, so the
// engine has to absorb them.
func (e *Engine) Start(ctx context.Context, tenantID, definitionName, correlationKey string, input map[string]any) (Instance, error) {
	definition, err := e.registry.Latest(definitionName)
	if err != nil {
		return Instance{}, err
	}

	tenantUUID, err := uuid.Parse(tenantID)
	if err != nil {
		return Instance{}, rpcerr.Internal("WF_TENANT_INVALID", "tenant_id must be a UUID").WithCause(err)
	}

	var result Instance
	err = e.tx.WithinTx(ctx, func(ctx context.Context) error {
		q := e.queries(ctx)

		existing, findErr := q.FindWorkflowInstanceByCorrelation(ctx, sqlcgen.FindWorkflowInstanceByCorrelationParams{
			TenantID:       tenantUUID,
			DefinitionName: definitionName,
			CorrelationKey: correlationKey,
		})
		if findErr == nil {
			result = instanceFromRow(existing)
			return nil
		}
		if !errors.Is(findErr, pgx.ErrNoRows) {
			return findErr
		}

		now := e.clock.Now()
		instanceID := e.ids.NewID()
		instanceUUID, parseErr := uuid.Parse(instanceID)
		if parseErr != nil {
			return rpcerr.Internal("WF_ID_INVALID", "instance_id must be a UUID").WithCause(parseErr)
		}

		state := input
		if state == nil {
			state = map[string]any{}
		}
		encoded, encErr := json.Marshal(state)
		if encErr != nil {
			return rpcerr.Internal("WF_STATE_ENCODE_FAILED", "could not encode workflow state").WithCause(encErr)
		}

		if insErr := q.InsertWorkflowInstance(ctx, sqlcgen.InsertWorkflowInstanceParams{
			InstanceID:        instanceUUID,
			TenantID:          tenantUUID,
			DefinitionName:    definition.Name,
			DefinitionVersion: int32(definition.Version),
			CorrelationKey:    correlationKey,
			Status:            StatusRunning,
			CurrentStep:       definition.Steps[0].Name,
			StepIndex:         0,
			State:             encoded,
			CreatedAt:         timestamptz(now),
			UpdatedAt:         timestamptz(now),
		}); insErr != nil {
			return insErr
		}

		if histErr := e.appendHistory(ctx, instanceUUID, tenantUUID, EventStarted, "", 0,
			map[string]any{"definition": definition.Name, "version": definition.Version}, now); histErr != nil {
			return histErr
		}

		result = Instance{
			ID:                instanceID,
			TenantID:          tenantID,
			DefinitionName:    definition.Name,
			DefinitionVersion: definition.Version,
			CorrelationKey:    correlationKey,
			Status:            StatusRunning,
			CurrentStep:       definition.Steps[0].Name,
			State:             state,
			Version:           1,
		}
		return nil
	})
	if err != nil {
		return Instance{}, err
	}
	return result, nil
}

// Get returns one instance.
func (e *Engine) Get(ctx context.Context, tenantID, instanceID string) (Instance, error) {
	tenantUUID, err := uuid.Parse(tenantID)
	if err != nil {
		return Instance{}, rpcerr.NotFound("WF_INSTANCE_NOT_FOUND", "workflow instance not found")
	}
	instanceUUID, err := uuid.Parse(instanceID)
	if err != nil {
		return Instance{}, rpcerr.NotFound("WF_INSTANCE_NOT_FOUND", "workflow instance not found")
	}

	row, err := e.queries(ctx).GetWorkflowInstance(ctx, sqlcgen.GetWorkflowInstanceParams{
		TenantID:   tenantUUID,
		InstanceID: instanceUUID,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return Instance{}, rpcerr.NotFound("WF_INSTANCE_NOT_FOUND", "workflow instance not found")
	}
	if err != nil {
		return Instance{}, err
	}
	return instanceFromRow(row), nil
}

// appendHistory writes one execution-history row.
func (e *Engine) appendHistory(ctx context.Context, instanceID, tenantID uuid.UUID,
	eventType, step string, attempt int, detail map[string]any, at time.Time) error {

	q := e.queries(ctx)

	sequence, err := q.NextHistorySequence(ctx, instanceID)
	if err != nil {
		return err
	}

	encoded, err := json.Marshal(detail)
	if err != nil {
		return rpcerr.Internal("WF_HISTORY_ENCODE_FAILED", "could not encode history detail").WithCause(err)
	}

	return q.InsertWorkflowHistory(ctx, sqlcgen.InsertWorkflowHistoryParams{
		InstanceID: instanceID,
		TenantID:   tenantID,
		Sequence:   int32(sequence),
		EventType:  eventType,
		Step:       step,
		Attempt:    int32(attempt),
		Detail:     encoded,
		OccurredAt: timestamptz(at),
	})
}

func instanceFromRow(r sqlcgen.PlatformWorkflowInstance) Instance {
	state := map[string]any{}
	_ = json.Unmarshal(r.State, &state)

	return Instance{
		ID:                r.InstanceID.String(),
		TenantID:          r.TenantID.String(),
		DefinitionName:    r.DefinitionName,
		DefinitionVersion: int(r.DefinitionVersion),
		CorrelationKey:    r.CorrelationKey,
		Status:            r.Status,
		CurrentStep:       r.CurrentStep,
		StepIndex:         int(r.StepIndex),
		Attempts:          int(r.Attempts),
		State:             state,
		LastError:         r.LastError,
		Version:           r.Version,
	}
}

// ErrConcurrentUpdate reports that another engine replica advanced the instance
// first. The caller retries on the next tick rather than forcing the write.
var ErrConcurrentUpdate = errors.New("workflow: instance changed concurrently")

// persist writes the instance back under optimistic concurrency.
func (e *Engine) persist(ctx context.Context, in Instance, at time.Time) error {
	instanceUUID, err := uuid.Parse(in.ID)
	if err != nil {
		return rpcerr.Internal("WF_ID_INVALID", "instance_id must be a UUID").WithCause(err)
	}

	encoded, err := json.Marshal(in.State)
	if err != nil {
		return rpcerr.Internal("WF_STATE_ENCODE_FAILED", "could not encode workflow state").WithCause(err)
	}

	rows, err := e.queries(ctx).UpdateWorkflowInstance(ctx, sqlcgen.UpdateWorkflowInstanceParams{
		Status:          in.Status,
		CurrentStep:     in.CurrentStep,
		StepIndex:       int32(in.StepIndex),
		Attempts:        int32(in.Attempts),
		State:           encoded,
		LastError:       in.LastError,
		UpdatedAt:       timestamptz(at),
		InstanceID:      instanceUUID,
		ExpectedVersion: in.Version,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return fmt.Errorf("%w: %s at version %d", ErrConcurrentUpdate, in.ID, in.Version)
	}
	return nil
}
