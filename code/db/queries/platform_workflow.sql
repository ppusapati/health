-- Workflow evaluation harness queries (P0-07).

-- name: InsertWorkflowInstance :exec
INSERT INTO platform_workflow.instance (
    instance_id, tenant_id, definition_name, definition_version, correlation_key,
    status, current_step, step_index, state, created_at, updated_at, version
) VALUES (
    @instance_id, @tenant_id, @definition_name, @definition_version, @correlation_key,
    @status, @current_step, @step_index, @state, @created_at, @updated_at, 1
);

-- name: GetWorkflowInstance :one
SELECT instance_id, tenant_id, definition_name, definition_version, correlation_key,
       status, current_step, step_index, attempts, state, last_error,
       created_at, updated_at, version
FROM platform_workflow.instance
WHERE tenant_id = @tenant_id AND instance_id = @instance_id;

-- name: FindWorkflowInstanceByCorrelation :one
SELECT instance_id, tenant_id, definition_name, definition_version, correlation_key,
       status, current_step, step_index, attempts, state, last_error,
       created_at, updated_at, version
FROM platform_workflow.instance
WHERE tenant_id = @tenant_id
  AND definition_name = @definition_name
  AND correlation_key = @correlation_key;

-- name: ClaimRunnableInstances :many
-- SKIP LOCKED lets several engine replicas advance different instances
-- concurrently without one blocking another or both claiming the same row.
SELECT instance_id, tenant_id, definition_name, definition_version, correlation_key,
       status, current_step, step_index, attempts, state, last_error,
       created_at, updated_at, version
FROM platform_workflow.instance
WHERE status IN ('running', 'compensating')
ORDER BY updated_at, instance_id
LIMIT @page_limit
FOR UPDATE SKIP LOCKED;

-- name: UpdateWorkflowInstance :execrows
-- Optimistic concurrency: the write applies only if nobody else advanced the
-- instance since it was read.
--
-- The tenant predicate is defence in depth. Every caller reaches this after a
-- tenant-scoped read, but this is a tenant-owned write and every other one in
-- the codebase carries the predicate; leaving it off here would make this the
-- single exception a future caller could get wrong.
UPDATE platform_workflow.instance
SET status = @status,
    current_step = @current_step,
    step_index = @step_index,
    attempts = @attempts,
    state = @state,
    last_error = @last_error,
    updated_at = @updated_at,
    version = version + 1
WHERE instance_id = @instance_id AND tenant_id = @tenant_id AND version = @expected_version;

-- name: InsertWorkflowHistory :exec
INSERT INTO platform_workflow.history (
    instance_id, tenant_id, sequence, event_type, step, attempt, detail, occurred_at
) VALUES (
    @instance_id, @tenant_id, @sequence, @event_type, @step, @attempt, @detail, @occurred_at
);

-- name: NextHistorySequence :one
SELECT COALESCE(MAX(sequence), 0) + 1 FROM platform_workflow.history
WHERE instance_id = @instance_id;

-- name: ListWorkflowHistory :many
SELECT history_id, instance_id, tenant_id, sequence, event_type, step, attempt,
       detail, occurred_at
FROM platform_workflow.history
WHERE tenant_id = @tenant_id AND instance_id = @instance_id
ORDER BY sequence;

-- name: InsertWorkflowTimer :exec
INSERT INTO platform_workflow.timer (
    timer_id, instance_id, tenant_id, step, due_at, created_at
) VALUES (@timer_id, @instance_id, @tenant_id, @step, @due_at, @created_at);

-- name: ClaimDueTimers :many
SELECT timer_id, instance_id, tenant_id, step, due_at
FROM platform_workflow.timer
WHERE fired_at IS NULL AND due_at <= @now
ORDER BY due_at, timer_id
LIMIT @page_limit
FOR UPDATE SKIP LOCKED;

-- name: MarkTimerFired :exec
UPDATE platform_workflow.timer SET fired_at = @fired_at WHERE timer_id = @timer_id;

-- name: TryRecordSignal :execrows
-- Returns 1 the first time a signal is seen and 0 on redelivery, which is what
-- makes signals idempotent (Domain/Data spec §9).
INSERT INTO platform_workflow.signal (
    instance_id, signal_key, tenant_id, signal_name, payload, received_at
) VALUES (@instance_id, @signal_key, @tenant_id, @signal_name, @payload, @received_at)
ON CONFLICT (instance_id, signal_key) DO NOTHING;

-- name: InsertHumanTask :exec
INSERT INTO platform_workflow.human_task (
    task_id, instance_id, tenant_id, step, assigned_role, status, due_at,
    created_at, updated_at
) VALUES (
    @task_id, @instance_id, @tenant_id, @step, @assigned_role, 'open', @due_at,
    @created_at, @created_at
);

-- name: GetHumanTask :one
SELECT task_id, instance_id, tenant_id, step, assigned_role, status, due_at,
       completed_by, outcome, created_at, updated_at
FROM platform_workflow.human_task
WHERE tenant_id = @tenant_id AND task_id = @task_id;

-- name: CompleteHumanTask :execrows
UPDATE platform_workflow.human_task
SET status = 'completed', completed_by = @completed_by, outcome = @outcome,
    updated_at = @updated_at
WHERE task_id = @task_id AND tenant_id = @tenant_id AND status = 'open';

-- name: ListOpenHumanTasks :many
SELECT task_id, instance_id, tenant_id, step, assigned_role, status, due_at,
       completed_by, outcome, created_at, updated_at
FROM platform_workflow.human_task
WHERE tenant_id = @tenant_id AND status = 'open'
ORDER BY due_at, task_id;

-- name: ExpireOverdueHumanTasks :execrows
UPDATE platform_workflow.human_task
SET status = 'expired', updated_at = @updated_at
WHERE status = 'open' AND due_at <= @now;

-- name: MigrateWorkflowInstance :execrows
-- Moves a running instance onto a different definition version.
--
-- Under the same optimistic-concurrency predicate as every other instance
-- write: an operator migrating an instance while the engine is advancing it
-- must lose, not race.
--
-- The step index is supplied by the caller, which resolved it by step NAME in
-- the target definition. Carrying the old index across would resume the
-- instance at whatever step now happens to sit at that position.
UPDATE platform_workflow.instance
SET definition_version = @definition_version,
    step_index         = @step_index,
    attempts           = 0,
    last_error         = '',
    updated_at         = @updated_at,
    version            = version + 1
WHERE instance_id = @instance_id
  AND tenant_id = @tenant_id
  AND version = @expected_version;

-- name: ListWorkflowInstances :many
-- Operator visibility: what is running, and in what state.
--
-- sqlc.narg on status so one query answers both "everything for this tenant"
-- and "everything stuck awaiting a signal".
SELECT instance_id, tenant_id, definition_name, definition_version, correlation_key,
       status, current_step, step_index, attempts, state, last_error,
       created_at, updated_at, version
FROM platform_workflow.instance
WHERE tenant_id = @tenant_id
  AND (sqlc.narg('status')::text IS NULL OR status = sqlc.narg('status')::text)
ORDER BY updated_at DESC, instance_id
LIMIT @page_limit;

-- name: ListStalledWorkflowInstances :many
-- Instances that should be moving and are not.
--
-- Deliberately cross-tenant: this is the query an operator runs at 3am to find
-- out whether the engine is advancing anything at all, and scoping it to one
-- tenant would hide a total outage behind a healthy-looking tenant.
SELECT instance_id, tenant_id, definition_name, definition_version, correlation_key,
       status, current_step, step_index, attempts, state, last_error,
       created_at, updated_at, version
FROM platform_workflow.instance
WHERE status IN ('running', 'compensating')
  AND updated_at < @stalled_before
ORDER BY updated_at, instance_id
LIMIT @page_limit;

-- name: LockWorkflowInstance :one
-- Takes the row lock for the duration of a step.
--
-- This is what makes several engine replicas safe. Claiming a batch and then
-- advancing each instance in a later transaction releases the lock before the
-- step body runs, so two replicas execute the same step — the optimistic
-- version predicate then rejects the second write, but the side effect has
-- already happened, which is the half that cannot be rolled back.
--
-- SKIP LOCKED rather than a wait: if another replica holds this instance,
-- there is nothing useful to wait for, and blocking would serialise the whole
-- engine behind one slow step.
SELECT instance_id, tenant_id, definition_name, definition_version, correlation_key,
       status, current_step, step_index, attempts, state, last_error,
       created_at, updated_at, version
FROM platform_workflow.instance
WHERE instance_id = @instance_id
  AND status IN ('running', 'compensating')
FOR UPDATE SKIP LOCKED;
