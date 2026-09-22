-- Housekeeping and environmental services (SRS-HKP-001 … 008).
--
-- Every statement is tenant-scoped in its WHERE clause. The adapter cannot be
-- called without authctx.TenantScope and the scope's tenant is what lands in
-- @tenant_id, so a cross-tenant read is not a thing a caller can ask for
-- (ADR-0001, FIT-03).
--
-- There is no UPDATE or DELETE against housekeeping.location_scan. A scan is
-- evidence about a moment somebody was in a room, and evidence that can be
-- edited afterwards is not evidence (FIT-08).
--
-- There is no UPDATE that edits an approved cleaning standard's checklist,
-- risk class or frequency either. A standard is superseded and a new revision
-- approved, because the audit question is always what the standard said at
-- the time.

-- name: InsertCleanableLocation :exec
INSERT INTO housekeeping.cleanable_location (
    location_id, tenant_id, code, name, revision, facility_id, zone, bed_id,
    risk_class, routine_every_hours, routine_sla_minutes,
    terminal_sla_minutes, scan_code, approved, approved_by, approved_at,
    effective_from, superseded_at, created_at, created_by, version
) VALUES (
    @location_id, @tenant_id, @code, @name, @revision, @facility_id, @zone,
    @bed_id, @risk_class, @routine_every_hours, @routine_sla_minutes,
    @terminal_sla_minutes, @scan_code, @approved, @approved_by, @approved_at,
    @effective_from, @superseded_at, @created_at, @created_by, @version
);

-- name: InsertLocationChecklistItem :exec
INSERT INTO housekeeping.location_checklist_item (
    location_id, item_code, label, required, position
) VALUES (@location_id, @item_code, @label, @required, @position);

-- name: GetCleanableLocation :one
SELECT * FROM housekeeping.cleanable_location
WHERE tenant_id = @tenant_id AND location_id = @location_id;

-- name: ListLocationChecklistItems :many
SELECT * FROM housekeeping.location_checklist_item
WHERE location_id = ANY(@location_ids::uuid[])
ORDER BY location_id, position, item_code;

-- name: ApproveCleanableLocation :execrows
UPDATE housekeeping.cleanable_location
SET approved = true, approved_by = @approved_by, approved_at = @approved_at,
    effective_from = @effective_from, version = version + 1
WHERE tenant_id = @tenant_id AND location_id = @location_id
  AND version = @expected_version;

-- name: SupersedeCleanableLocation :execrows
UPDATE housekeeping.cleanable_location
SET superseded_at = @superseded_at, version = version + 1
WHERE tenant_id = @tenant_id AND location_id = @location_id
  AND superseded_at IS NULL;

-- name: ListCleanableLocations :many
SELECT * FROM housekeeping.cleanable_location
WHERE tenant_id = @tenant_id
  AND (@facility_id::text = '' OR facility_id = @facility_id)
  AND (@zone::text = '' OR zone = @zone)
  AND (@risk_class::text = '' OR risk_class = @risk_class)
  AND (NOT @live_only::boolean OR (
        approved
        AND effective_from IS NOT NULL AND effective_from <= @at
        AND (superseded_at IS NULL OR superseded_at > @at)))
ORDER BY code, revision DESC
LIMIT @page_limit OFFSET @page_offset;

-- name: ListLocationRevisions :many
SELECT * FROM housekeeping.cleanable_location
WHERE tenant_id = @tenant_id AND lower(code) = lower(@code::text)
ORDER BY revision DESC;

-- name: InsertCleaningTask :exec
INSERT INTO housekeeping.cleaning_task (
    task_id, tenant_id, kind, location_code, location_name, facility_id,
    zone, bed_id, risk_class, location_revision, scan_code, restricted,
    incident_ref, detail, assignee_id, due_by, state, started_at, started_by,
    completed_at, completed_by, verified_at, verified_by, verify_note,
    cancel_reason, escalated_at, raised_at, raised_by, version
) VALUES (
    @task_id, @tenant_id, @kind, @location_code, @location_name,
    @facility_id, @zone, @bed_id, @risk_class, @location_revision,
    @scan_code, @restricted, @incident_ref, @detail, @assignee_id, @due_by,
    @state, @started_at, @started_by, @completed_at, @completed_by,
    @verified_at, @verified_by, @verify_note, @cancel_reason, @escalated_at,
    @raised_at, @raised_by, @version
);

-- name: InsertTaskChecklistItem :exec
INSERT INTO housekeeping.task_checklist_item (
    task_id, item_code, label, required, position, answered, done, exception
) VALUES (
    @task_id, @item_code, @label, @required, @position, @answered, @done,
    @exception
);

-- name: AnswerTaskChecklistItem :execrows
UPDATE housekeeping.task_checklist_item
SET answered = @answered, done = @done, exception = @exception
WHERE task_id = @task_id AND item_code = @item_code;

-- name: ListTaskChecklistItems :many
SELECT * FROM housekeeping.task_checklist_item
WHERE task_id = ANY(@task_ids::uuid[])
ORDER BY task_id, position, item_code;

-- name: GetCleaningTask :one
SELECT * FROM housekeeping.cleaning_task
WHERE tenant_id = @tenant_id AND task_id = @task_id;

-- name: UpdateCleaningTask :execrows
UPDATE housekeeping.cleaning_task
SET assignee_id = @assignee_id, state = @state,
    started_at = @started_at, started_by = @started_by,
    completed_at = @completed_at, completed_by = @completed_by,
    verified_at = @verified_at, verified_by = @verified_by,
    verify_note = @verify_note, cancel_reason = @cancel_reason,
    escalated_at = @escalated_at, version = version + 1
WHERE tenant_id = @tenant_id AND task_id = @task_id
  AND version = @expected_version;

-- name: ListCleaningTasks :many
SELECT * FROM housekeeping.cleaning_task
WHERE tenant_id = @tenant_id
  AND (@facility_id::text = '' OR facility_id = @facility_id)
  AND (@zone::text = '' OR zone = @zone)
  AND (@location_code::text = '' OR location_code = @location_code)
  AND (@bed_id::text = '' OR bed_id = @bed_id)
  AND (@kind::text = '' OR kind = @kind)
  AND (@assignee_id::text = '' OR assignee_id = @assignee_id)
  AND (cardinality(@states::text[]) = 0 OR state = ANY(@states::text[]))
  AND (NOT @open_only::boolean
       OR state IN ('open', 'in_progress'))
  AND raised_at >= @from_time AND raised_at <= @to_time
ORDER BY raised_at DESC, task_id
LIMIT @page_limit OFFSET @page_offset;

-- name: ListOverdueCriticalTasks :many
SELECT * FROM housekeeping.cleaning_task
WHERE tenant_id = @tenant_id
  AND (@facility_id::text = '' OR facility_id = @facility_id)
  AND risk_class = 'very_high'
  AND state IN ('open', 'in_progress')
  AND due_by IS NOT NULL AND due_by < @at
  AND escalated_at IS NULL
ORDER BY due_by
LIMIT @page_limit;

-- name: LastCleanedByLocation :many
SELECT location_code, max(completed_at)::timestamptz AS last_cleaned_at
FROM housekeeping.cleaning_task
WHERE tenant_id = @tenant_id
  AND (@facility_id::text = '' OR facility_id = @facility_id)
  AND state IN ('completed', 'verified')
  AND completed_at IS NOT NULL
GROUP BY location_code;

-- name: AppendLocationScan :exec
INSERT INTO housekeeping.location_scan (
    scan_id, tenant_id, task_id, scanned_code, matched, scanned_by,
    scanned_at
) VALUES (
    @scan_id, @tenant_id, @task_id, @scanned_code, @matched, @scanned_by,
    @scanned_at
);

-- name: ListLocationScans :many
SELECT * FROM housekeeping.location_scan
WHERE tenant_id = @tenant_id AND task_id = ANY(@task_ids::uuid[])
ORDER BY task_id, scanned_at;

-- name: InsertBedHold :exec
INSERT INTO housekeeping.bed_hold (
    hold_id, tenant_id, bed_id, location_code, facility_id, zone, task_id,
    encounter_id, state, placed_at, placed_by, released_at, released_by,
    overridden_at, overridden_by, override_reason, version
) VALUES (
    @hold_id, @tenant_id, @bed_id, @location_code, @facility_id, @zone,
    @task_id, @encounter_id, @state, @placed_at, @placed_by, @released_at,
    @released_by, @overridden_at, @overridden_by, @override_reason, @version
);

-- name: GetBedHold :one
SELECT * FROM housekeeping.bed_hold
WHERE tenant_id = @tenant_id AND hold_id = @hold_id;

-- name: UpdateBedHold :execrows
UPDATE housekeeping.bed_hold
SET state = @state, released_at = @released_at, released_by = @released_by,
    overridden_at = @overridden_at, overridden_by = @overridden_by,
    override_reason = @override_reason, version = version + 1
WHERE tenant_id = @tenant_id AND hold_id = @hold_id
  AND version = @expected_version;

-- name: GetOpenBedHold :one
SELECT * FROM housekeeping.bed_hold
WHERE tenant_id = @tenant_id AND bed_id = @bed_id AND state = 'open';

-- name: GetBedHoldForTask :one
SELECT * FROM housekeeping.bed_hold
WHERE tenant_id = @tenant_id AND task_id = @task_id
ORDER BY placed_at DESC
LIMIT 1;

-- name: ListBedHolds :many
SELECT * FROM housekeeping.bed_hold
WHERE tenant_id = @tenant_id
  AND (@facility_id::text = '' OR facility_id = @facility_id)
  AND (@zone::text = '' OR zone = @zone)
  AND (@bed_id::text = '' OR bed_id = @bed_id)
  AND (NOT @open_only::boolean OR state = 'open')
  AND placed_at >= @from_time AND placed_at <= @to_time
ORDER BY placed_at DESC, hold_id
LIMIT @page_limit OFFSET @page_offset;
