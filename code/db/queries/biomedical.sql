-- Biomedical engineering and asset maintenance (SRS-BIO-001 … 011).
--
-- The telemetry queries deliberately touch no maintenance table. There is no
-- statement here that lets a reading update a ticket or a plan, which is what
-- makes SRS-BIO-010's "telemetry does not overwrite maintenance records" a
-- property of the surface rather than a convention.

-- name: InsertAsset :exec
INSERT INTO biomedical.asset (
    asset_id, tenant_id, tag, udi, serial, make, model, category,
    criticality, status, location_id, department, capabilities,
    acquired_on, acquisition_cost_minor, expected_life_years,
    calibration_required, calibration_due, calibration_certificate,
    notes, created_at, created_by
) VALUES (
    @asset_id, @tenant_id, @tag, @udi, @serial, @make, @model, @category,
    @criticality, @status, @location_id, @department, @capabilities,
    @acquired_on, @acquisition_cost_minor, @expected_life_years,
    @calibration_required, @calibration_due, @calibration_certificate,
    @notes, @created_at, @created_by
);

-- name: GetAsset :one
SELECT * FROM biomedical.asset
WHERE tenant_id = $1 AND asset_id = $2;

-- name: GetAssetByTag :one
SELECT * FROM biomedical.asset
WHERE tenant_id = $1 AND tag = $2;

-- name: UpdateAsset :execrows
UPDATE biomedical.asset
SET status = @status, location_id = @location_id, department = @department,
    capabilities = @capabilities, criticality = @criticality,
    calibration_required = @calibration_required,
    calibration_due = @calibration_due,
    calibration_certificate = @calibration_certificate,
    safety_hold = @safety_hold, safety_hold_reason = @safety_hold_reason,
    notes = @notes, version = version + 1
WHERE tenant_id = @tenant_id AND asset_id = @asset_id
  AND version = @expected_version;

-- name: ListAssets :many
SELECT * FROM biomedical.asset
WHERE tenant_id = @tenant_id
  AND (@category::text = '' OR category = @category)
  AND (@status::text = '' OR status = @status)
  AND (NOT @exclude_retired::boolean
       OR status NOT IN ('decommissioned', 'disposed'))
ORDER BY tag
LIMIT @row_limit;

-- SRS-BIO-009: what is standing in this room.
-- name: ListAssetsAtLocation :many
SELECT * FROM biomedical.asset
WHERE tenant_id = @tenant_id AND location_id = @location_id
  AND status <> 'disposed'
ORDER BY tag
LIMIT @row_limit;

-- SRS-BIO-008: the candidates a safety notice is matched against.
-- name: ListAssetsByMake :many
SELECT * FROM biomedical.asset
WHERE tenant_id = @tenant_id
  AND status <> 'disposed'
  AND (@make::text = '' OR lower(make) = lower(@make))
  AND (@udi::text = '' OR udi = @udi)
ORDER BY tag
LIMIT @row_limit;

-- name: InsertServiceContract :exec
INSERT INTO biomedical.service_contract (
    contract_id, tenant_id, asset_id, kind, reference, vendor_name,
    vendor_contact, vendor_phone, vendor_email, starts_on, ends_on,
    value_minor, response_hours, resolution_hours, notes, created_at,
    created_by
) VALUES (
    @contract_id, @tenant_id, @asset_id, @kind, @reference, @vendor_name,
    @vendor_contact, @vendor_phone, @vendor_email, @starts_on, @ends_on,
    @value_minor, @response_hours, @resolution_hours, @notes, @created_at,
    @created_by
);

-- name: GetServiceContract :one
SELECT * FROM biomedical.service_contract
WHERE tenant_id = $1 AND contract_id = $2;

-- name: ListContractsForAsset :many
SELECT * FROM biomedical.service_contract
WHERE tenant_id = @tenant_id AND asset_id = @asset_id
ORDER BY ends_on DESC;

-- The renewal sweep (SRS-BIO-002).
-- name: ListContractsExpiringBefore :many
SELECT * FROM biomedical.service_contract
WHERE tenant_id = @tenant_id AND ends_on < @horizon
ORDER BY ends_on
LIMIT @row_limit;

-- name: InsertPMPlan :exec
INSERT INTO biomedical.pm_plan (
    plan_id, tenant_id, asset_id, basis, interval_days, runtime_hours,
    procedure, estimated_minutes, last_performed_at, last_runtime_hours,
    active, created_at, created_by
) VALUES (
    @plan_id, @tenant_id, @asset_id, @basis, @interval_days, @runtime_hours,
    @procedure, @estimated_minutes, @last_performed_at, @last_runtime_hours,
    @active, @created_at, @created_by
);

-- name: GetPMPlan :one
SELECT * FROM biomedical.pm_plan
WHERE tenant_id = $1 AND plan_id = $2;

-- name: UpdatePMPlan :execrows
UPDATE biomedical.pm_plan
SET interval_days = @interval_days, runtime_hours = @runtime_hours,
    procedure = @procedure, estimated_minutes = @estimated_minutes,
    last_performed_at = @last_performed_at,
    last_runtime_hours = @last_runtime_hours,
    active = @active, version = version + 1
WHERE tenant_id = @tenant_id AND plan_id = @plan_id
  AND version = @expected_version;

-- name: ListPMPlans :many
SELECT * FROM biomedical.pm_plan
WHERE tenant_id = @tenant_id
  AND (@asset_id::text = '' OR asset_id::text = @asset_id)
  AND (NOT @active_only::boolean OR active)
ORDER BY last_performed_at
LIMIT @row_limit;

-- name: InsertTicket :exec
INSERT INTO biomedical.ticket (
    ticket_id, tenant_id, number, kind, asset_id, plan_id, asset_tag,
    location_id, symptom, priority, impact, state, owner_id, respond_by,
    resolve_by, contract_id, down_from, raised_at, raised_by
) VALUES (
    @ticket_id, @tenant_id, @number, @kind, @asset_id, @plan_id, @asset_tag,
    @location_id, @symptom, @priority, @impact, @state, @owner_id,
    @respond_by, @resolve_by, @contract_id, @down_from, @raised_at, @raised_by
);

-- name: GetTicket :one
SELECT * FROM biomedical.ticket
WHERE tenant_id = $1 AND ticket_id = $2;

-- name: UpdateTicket :execrows
UPDATE biomedical.ticket
SET state = @state, owner_id = @owner_id, diagnosis = @diagnosis,
    work_performed = @work_performed, parts = @parts,
    down_until = @down_until,
    awaiting_parts_minutes = @awaiting_parts_minutes,
    responded_at = @responded_at, resolved_at = @resolved_at,
    closed_at = @closed_at, closed_by = @closed_by,
    closure_note = @closure_note, cancelled_reason = @cancelled_reason,
    version = version + 1
WHERE tenant_id = @tenant_id AND ticket_id = @ticket_id
  AND version = @expected_version;

-- name: ListTickets :many
SELECT * FROM biomedical.ticket
WHERE tenant_id = @tenant_id
  AND (@asset_id::text = '' OR asset_id::text = @asset_id)
  AND (@state::text = '' OR state = @state)
  AND (NOT @open_only::boolean OR state NOT IN ('closed', 'cancelled'))
ORDER BY raised_at DESC
LIMIT @row_limit;

-- What the reliability figures are computed over (SRS-BIO-007).
-- name: ListTicketsForAssetBetween :many
SELECT * FROM biomedical.ticket
WHERE tenant_id = @tenant_id AND asset_id = @asset_id
  AND (down_from IS NULL OR down_from < @period_end)
  AND (down_until IS NULL OR down_until >= @period_start
       OR state NOT IN ('closed', 'cancelled'))
ORDER BY raised_at
LIMIT @row_limit;

-- Planned work closed in a window, which PM compliance is counted from.
-- name: ListClosedPlannedWork :many
SELECT * FROM biomedical.ticket
WHERE tenant_id = @tenant_id AND asset_id = @asset_id
  AND kind <> 'corrective' AND state = 'closed'
  AND closed_at >= @period_start AND closed_at < @period_end
ORDER BY closed_at;

-- name: InsertSafetyNotice :exec
INSERT INTO biomedical.safety_notice (
    notice_id, tenant_id, reference, kind, issuer, summary, make, model,
    serial_from, serial_to, affected_udi, hold_affected, required_action,
    due_by, issued_on, raised_at, raised_by
) VALUES (
    @notice_id, @tenant_id, @reference, @kind, @issuer, @summary, @make,
    @model, @serial_from, @serial_to, @affected_udi, @hold_affected,
    @required_action, @due_by, @issued_on, @raised_at, @raised_by
);

-- name: GetSafetyNotice :one
SELECT * FROM biomedical.safety_notice
WHERE tenant_id = $1 AND notice_id = $2;

-- name: CloseSafetyNotice :execrows
UPDATE biomedical.safety_notice
SET closed_at = @closed_at, closed_by = @closed_by,
    closure_note = @closure_note, version = version + 1
WHERE tenant_id = @tenant_id AND notice_id = @notice_id
  AND version = @expected_version;

-- name: ListSafetyNotices :many
SELECT * FROM biomedical.safety_notice
WHERE tenant_id = @tenant_id
  AND (NOT @open_only::boolean OR closed_at IS NULL)
ORDER BY raised_at DESC
LIMIT @row_limit;

-- name: InsertNoticeTask :exec
INSERT INTO biomedical.notice_task (
    task_id, tenant_id, notice_id, asset_id, asset_tag, state, note
) VALUES (
    @task_id, @tenant_id, @notice_id, @asset_id, @asset_tag, @state, @note
);

-- name: UpdateNoticeTask :execrows
UPDATE biomedical.notice_task
SET state = @state, note = @note, completed_at = @completed_at,
    completed_by = @completed_by
WHERE tenant_id = @tenant_id AND task_id = @task_id;

-- name: GetNoticeTask :one
SELECT * FROM biomedical.notice_task
WHERE tenant_id = $1 AND task_id = $2;

-- name: ListNoticeTasks :many
SELECT * FROM biomedical.notice_task
WHERE tenant_id = @tenant_id AND notice_id = @notice_id
ORDER BY asset_tag;

-- name: ListTasksForAsset :many
SELECT * FROM biomedical.notice_task
WHERE tenant_id = @tenant_id AND asset_id = @asset_id
ORDER BY task_id;

-- Telemetry (SRS-BIO-010). Insert and read only: there is no update and no
-- delete, and nothing here reaches a maintenance table.
-- name: InsertReading :exec
INSERT INTO biomedical.reading (
    reading_id, tenant_id, asset_id, metric, value, unit, source, ingested,
    observed_at, recorded_at, recorded_by
) VALUES (
    @reading_id, @tenant_id, @asset_id, @metric, @value, @unit, @source,
    @ingested, @observed_at, @recorded_at, @recorded_by
);

-- name: ListReadings :many
SELECT * FROM biomedical.reading
WHERE tenant_id = @tenant_id AND asset_id = @asset_id
  AND (@metric::text = '' OR metric = @metric)
  AND observed_at >= @period_start AND observed_at < @period_end
ORDER BY observed_at DESC
LIMIT @row_limit;

-- The newest reading of one metric per asset, by observation rather than by
-- recording: a backlog flushing after an outage arrives out of order.
-- name: ListLatestReadings :many
SELECT DISTINCT ON (asset_id) *
FROM biomedical.reading
WHERE tenant_id = @tenant_id AND metric = @metric
ORDER BY asset_id, observed_at DESC;

-- name: InsertDisposal :exec
INSERT INTO biomedical.disposal (
    disposal_id, tenant_id, asset_id, asset_tag, method, reason,
    requested_by, approved_by, approved_at, sanitisation_required,
    sanitisation_method, sanitisation_certificate, sanitised_by, recipient,
    proceeds_minor, disposed_at, recorded_by
) VALUES (
    @disposal_id, @tenant_id, @asset_id, @asset_tag, @method, @reason,
    @requested_by, @approved_by, @approved_at, @sanitisation_required,
    @sanitisation_method, @sanitisation_certificate, @sanitised_by,
    @recipient, @proceeds_minor, @disposed_at, @recorded_by
);

-- name: GetDisposal :one
SELECT * FROM biomedical.disposal
WHERE tenant_id = $1 AND asset_id = $2;

-- name: ListDisposals :many
SELECT * FROM biomedical.disposal
WHERE tenant_id = @tenant_id
  AND disposed_at >= @period_start AND disposed_at < @period_end
ORDER BY disposed_at DESC
LIMIT @row_limit;
