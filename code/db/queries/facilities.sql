-- Facilities engineering (SRS-FAC-001 … 011).
--
-- Query names carry a Facilities prefix wherever the bare name would collide
-- with another context's: sqlc's namespace is the whole of db/queries, so
-- "InsertAsset" would be ambiguous against biomedical's.

-- name: UpsertFacilitiesWorkClass :one
INSERT INTO facilities.work_class (
    tenant_id, code, name, requires_permit, requires_loto, active, note
) VALUES (@tenant_id, @code, @name, @requires_permit, @requires_loto,
          @active, @note)
ON CONFLICT (tenant_id, code) DO UPDATE SET
    name = EXCLUDED.name,
    requires_permit = EXCLUDED.requires_permit,
    requires_loto = EXCLUDED.requires_loto,
    active = EXCLUDED.active,
    note = EXCLUDED.note
RETURNING *;

-- name: GetFacilitiesWorkClass :one
SELECT * FROM facilities.work_class
WHERE tenant_id = @tenant_id AND code = @code;

-- name: ListFacilitiesWorkClasses :many
SELECT * FROM facilities.work_class
WHERE tenant_id = @tenant_id
ORDER BY code;

-- name: InsertFacilitiesAsset :one
INSERT INTO facilities.asset (
    id, tenant_id, tag, name, system, criticality, parent_id, facility_id,
    location_id, location_note, status, status_reason, status_at,
    manufacturer, model, serial_number, commissioned_at, created_at,
    created_by, version
) VALUES (
    @id, @tenant_id, @tag, @name, @system, @criticality,
    NULLIF(@parent_id::text, '')::uuid, NULLIF(@facility_id::text, '')::uuid,
    NULLIF(@location_id::text, '')::uuid, @location_note, @status,
    @status_reason, @status_at, @manufacturer, @model, @serial_number,
    NULLIF(@commissioned_at::text, '')::timestamptz, @created_at,
    @created_by, 1
)
RETURNING *;

-- name: GetFacilitiesAsset :one
SELECT * FROM facilities.asset
WHERE tenant_id = @tenant_id AND id = @id;

-- name: GetFacilitiesAssetByTag :one
SELECT * FROM facilities.asset
WHERE tenant_id = @tenant_id AND tag = @tag
  AND status <> 'decommissioned';

-- name: SetFacilitiesAssetStatus :one
UPDATE facilities.asset
SET status = @status, status_reason = @status_reason, status_at = @status_at,
    version = version + 1
WHERE tenant_id = @tenant_id AND id = @id
  AND version = @expected_version
RETURNING *;

-- name: SetFacilitiesAssetRuntime :one
UPDATE facilities.asset
SET runtime_hours = @runtime_hours, runtime_at = @runtime_at,
    version = version + 1
WHERE tenant_id = @tenant_id AND id = @id
  AND version = @expected_version
RETURNING *;

-- name: ListFacilitiesAssets :many
SELECT * FROM facilities.asset
WHERE tenant_id = @tenant_id
  -- The zero UUID is not NULL, so an "IS NULL" test on an optional filter
  -- never fires and the filter silently applies to every call.
  AND (@facility_id::text = '' OR facility_id = @facility_id::uuid)
  AND (@system::text = '' OR system = @system::text)
  AND (@status::text = '' OR status = @status::text)
  AND (@parent_id::text = '' OR parent_id = @parent_id::uuid)
ORDER BY tag
LIMIT @row_limit;

-- name: InsertFacilitiesWorkOrder :one
INSERT INTO facilities.work_order (
    id, tenant_id, number, facility_id, asset_id, system, location_id,
    location_note, fault, impact, priority, class_code,
    class_requires_permit, class_requires_loto, owner_team, owner_user_id,
    state, raised_at, raised_by, respond_by, resolve_by, created_at, version
) VALUES (
    @id, @tenant_id, @number, NULLIF(@facility_id::text, '')::uuid,
    NULLIF(@asset_id::text, '')::uuid, @system,
    NULLIF(@location_id::text, '')::uuid, @location_note, @fault, @impact,
    @priority, @class_code, @class_requires_permit, @class_requires_loto,
    @owner_team, @owner_user_id, @state, @raised_at, @raised_by,
    @respond_by, @resolve_by, @created_at, 1
)
RETURNING *;

-- name: GetFacilitiesWorkOrder :one
SELECT * FROM facilities.work_order
WHERE tenant_id = @tenant_id AND id = @id;

-- name: UpdateFacilitiesWorkOrder :one
UPDATE facilities.work_order
SET state = @state,
    owner_team = @owner_team,
    owner_user_id = @owner_user_id,
    responded_at = NULLIF(@responded_at::text, '')::timestamptz,
    started_at = NULLIF(@started_at::text, '')::timestamptz,
    resolved_at = NULLIF(@resolved_at::text, '')::timestamptz,
    closed_at = NULLIF(@closed_at::text, '')::timestamptz,
    closed_by = @closed_by,
    permit_ref = @permit_ref,
    permit_issued_by = @permit_issued_by,
    loto_ref = @loto_ref,
    loto_applied_by = @loto_applied_by,
    completion_note = @completion_note,
    root_cause = @root_cause,
    downtime_minutes = @downtime_minutes,
    hold_reason = @hold_reason,
    cancel_reason = @cancel_reason,
    version = version + 1
WHERE tenant_id = @tenant_id AND id = @id
  AND version = @expected_version
RETURNING *;

-- name: ListFacilitiesWorkOrders :many
SELECT * FROM facilities.work_order
WHERE tenant_id = @tenant_id
  AND (@facility_id::text = '' OR facility_id = @facility_id::uuid)
  AND (@asset_id::text = '' OR asset_id = @asset_id::uuid)
  AND (@system::text = '' OR system = @system::text)
  AND (@state::text = '' OR state = @state::text)
  AND (NOT @open_only::boolean
       OR state NOT IN ('closed', 'cancelled'))
  AND raised_at >= @raised_from
  AND raised_at <= @raised_to
ORDER BY raised_at DESC
LIMIT @row_limit;

-- name: InsertFacilitiesSchedule :one
INSERT INTO facilities.schedule (
    id, tenant_id, asset_id, facility_id, title, kind, trigger_kind,
    interval_days, interval_runtime_hours, authority, requires_evidence,
    work_class_code, grace_days, active, created_at, created_by, version
) VALUES (
    @id, @tenant_id, NULLIF(@asset_id::text, '')::uuid,
    NULLIF(@facility_id::text, '')::uuid, @title, @kind, @trigger_kind,
    @interval_days, @interval_runtime_hours, @authority, @requires_evidence,
    @work_class_code, @grace_days, @active, @created_at, @created_by, 1
)
RETURNING *;

-- name: GetFacilitiesSchedule :one
SELECT * FROM facilities.schedule
WHERE tenant_id = @tenant_id AND id = @id;

-- name: SetFacilitiesScheduleDone :one
UPDATE facilities.schedule
SET last_done_at = @last_done_at, last_done_hours = @last_done_hours,
    version = version + 1
WHERE tenant_id = @tenant_id AND id = @id
  AND version = @expected_version
RETURNING *;

-- name: ListFacilitiesSchedules :many
SELECT * FROM facilities.schedule
WHERE tenant_id = @tenant_id
  AND (@asset_id::text = '' OR asset_id = @asset_id::uuid)
  AND (@facility_id::text = '' OR facility_id = @facility_id::uuid)
  AND (@kind::text = '' OR kind = @kind::text)
  AND (NOT @active_only::boolean OR active)
ORDER BY title
LIMIT @row_limit;

-- name: InsertFacilitiesTask :one
INSERT INTO facilities.task (
    id, tenant_id, schedule_id, asset_id, facility_id, title,
    schedule_kind, schedule_requires_evidence, due_at, due_runtime_hours,
    triggered_by, state, created_at, version
) VALUES (
    @id, @tenant_id, @schedule_id, NULLIF(@asset_id::text, '')::uuid,
    NULLIF(@facility_id::text, '')::uuid, @title, @schedule_kind,
    @schedule_requires_evidence, NULLIF(@due_at::text, '')::timestamptz,
    @due_runtime_hours, @triggered_by, @state, @created_at, 1
)
RETURNING *;

-- name: GetFacilitiesTask :one
SELECT * FROM facilities.task
WHERE tenant_id = @tenant_id AND id = @id;

-- name: UpdateFacilitiesTask :one
UPDATE facilities.task
SET state = @state,
    done_at = NULLIF(@done_at::text, '')::timestamptz,
    done_by = @done_by,
    findings = @findings,
    evidence_ref = @evidence_ref,
    certificate_ref = @certificate_ref,
    certificate_expires_at =
        NULLIF(@certificate_expires_at::text, '')::timestamptz,
    waived_reason = @waived_reason,
    work_order_id = NULLIF(@work_order_id::text, '')::uuid,
    version = version + 1
WHERE tenant_id = @tenant_id AND id = @id
  AND version = @expected_version
RETURNING *;

-- name: ListFacilitiesTasks :many
SELECT * FROM facilities.task
WHERE tenant_id = @tenant_id
  AND (@schedule_id::text = '' OR schedule_id = @schedule_id::uuid)
  AND (@asset_id::text = '' OR asset_id = @asset_id::uuid)
  AND (@facility_id::text = '' OR facility_id = @facility_id::uuid)
  AND (@state::text = '' OR state = @state::text)
  AND (@kind::text = '' OR schedule_kind = @kind::text)
ORDER BY due_at NULLS LAST, created_at
LIMIT @row_limit;

-- name: InsertFacilitiesRuntimeReading :one
INSERT INTO facilities.runtime_reading (
    id, tenant_id, asset_id, hours, read_at, source, source_ref,
    recorded_by, counter_replaced, note, created_at
) VALUES (
    @id, @tenant_id, @asset_id, @hours, @read_at, @source, @source_ref,
    @recorded_by, @counter_replaced, @note, @created_at
)
RETURNING *;

-- name: LatestFacilitiesRuntimeReading :one
SELECT * FROM facilities.runtime_reading
WHERE tenant_id = @tenant_id AND asset_id = @asset_id
ORDER BY read_at DESC, created_at DESC
LIMIT 1;

-- name: ListFacilitiesRuntimeReadings :many
SELECT * FROM facilities.runtime_reading
WHERE tenant_id = @tenant_id AND asset_id = @asset_id
  AND read_at >= @read_from AND read_at <= @read_to
ORDER BY read_at
LIMIT @row_limit;

-- name: InsertFacilitiesMeter :one
INSERT INTO facilities.meter (
    id, tenant_id, code, name, utility, unit, facility_id, location_id,
    asset_id, source, source_ref, cumulative, register_max, active,
    created_at, created_by, version
) VALUES (
    @id, @tenant_id, @code, @name, @utility, @unit,
    NULLIF(@facility_id::text, '')::uuid,
    NULLIF(@location_id::text, '')::uuid,
    NULLIF(@asset_id::text, '')::uuid, @source, @source_ref, @cumulative,
    @register_max, @active, @created_at, @created_by, 1
)
RETURNING *;

-- name: GetFacilitiesMeter :one
SELECT * FROM facilities.meter
WHERE tenant_id = @tenant_id AND id = @id;

-- name: ListFacilitiesMeters :many
SELECT * FROM facilities.meter
WHERE tenant_id = @tenant_id
  AND (@facility_id::text = '' OR facility_id = @facility_id::uuid)
  AND (@utility::text = '' OR utility = @utility::text)
  AND (NOT @active_only::boolean OR active)
ORDER BY code
LIMIT @row_limit;

-- name: InsertFacilitiesMeterReading :one
INSERT INTO facilities.meter_reading (
    id, tenant_id, meter_id, value, read_at, source, source_ref,
    recorded_by, rolled_over, note, created_at
) VALUES (
    @id, @tenant_id, @meter_id, @value, @read_at, @source, @source_ref,
    @recorded_by, @rolled_over, @note, @created_at
)
RETURNING *;

-- name: ListFacilitiesMeterReadings :many
SELECT * FROM facilities.meter_reading
WHERE tenant_id = @tenant_id AND meter_id = @meter_id
  AND read_at >= @read_from AND read_at <= @read_to
ORDER BY read_at
LIMIT @row_limit;

-- name: InsertFacilitiesOutage :one
INSERT INTO facilities.outage (
    id, tenant_id, reference, facility_id, system, title, reason,
    planned_from, planned_to, state, requested_by, requested_at,
    contingency, created_at, version
) VALUES (
    @id, @tenant_id, @reference, NULLIF(@facility_id::text, '')::uuid,
    @system, @title, @reason, @planned_from, @planned_to, @state,
    @requested_by, @requested_at, @contingency, @created_at, 1
)
RETURNING *;

-- name: GetFacilitiesOutage :one
SELECT * FROM facilities.outage
WHERE tenant_id = @tenant_id AND id = @id;

-- name: UpdateFacilitiesOutage :one
-- Updating state here cascades to outage_area.outage_state through the
-- composite foreign key, which is what keeps the "one live shutdown per
-- department" index meaningful.
UPDATE facilities.outage
SET state = @state,
    approved_by = @approved_by,
    approved_at = NULLIF(@approved_at::text, '')::timestamptz,
    permit_ref = @permit_ref,
    contingency = @contingency,
    actual_from = NULLIF(@actual_from::text, '')::timestamptz,
    actual_to = NULLIF(@actual_to::text, '')::timestamptz,
    restored_by = @restored_by,
    cancel_reason = @cancel_reason,
    version = version + 1
WHERE tenant_id = @tenant_id AND id = @id
  AND version = @expected_version
RETURNING *;

-- name: ListFacilitiesOutages :many
SELECT * FROM facilities.outage
WHERE tenant_id = @tenant_id
  AND (@facility_id::text = '' OR facility_id = @facility_id::uuid)
  AND (@system::text = '' OR system = @system::text)
  AND (NOT @live_only::boolean
       OR state IN ('planned', 'approved', 'in_effect'))
  AND planned_from <= @window_to
  AND planned_to >= @window_from
ORDER BY planned_from
LIMIT @row_limit;

-- name: InsertFacilitiesOutageArea :one
INSERT INTO facilities.outage_area (
    id, tenant_id, outage_id, org_unit_id, name, critical,
    outage_system, outage_state, created_at, version
) VALUES (
    @id, @tenant_id, @outage_id, NULLIF(@org_unit_id::text, '')::uuid,
    @name, @critical, @outage_system, @outage_state, @created_at, 1
)
RETURNING *;

-- name: UpdateFacilitiesOutageArea :one
UPDATE facilities.outage_area
SET notified_at = NULLIF(@notified_at::text, '')::timestamptz,
    acknowledged_at = NULLIF(@acknowledged_at::text, '')::timestamptz,
    acknowledged_by = @acknowledged_by,
    objection = @objection,
    version = version + 1
WHERE tenant_id = @tenant_id AND id = @id
  AND version = @expected_version
RETURNING *;

-- name: ListFacilitiesOutageAreas :many
SELECT * FROM facilities.outage_area
WHERE tenant_id = @tenant_id AND outage_id = @outage_id
ORDER BY critical DESC, name;

-- name: InsertFacilitiesAlarm :one
INSERT INTO facilities.alarm (
    id, tenant_id, gateway_id, point_ref, external_id, asset_id,
    facility_id, system, severity, message, source, raised_at, state,
    created_at, version
) VALUES (
    @id, @tenant_id, @gateway_id, @point_ref, @external_id,
    NULLIF(@asset_id::text, '')::uuid,
    NULLIF(@facility_id::text, '')::uuid, @system, @severity, @message,
    @source, @raised_at, @state, @created_at, 1
)
RETURNING *;

-- name: GetFacilitiesAlarm :one
SELECT * FROM facilities.alarm
WHERE tenant_id = @tenant_id AND id = @id;

-- name: GetFacilitiesAlarmByEvent :one
-- The replay check. A gateway reconnecting after a network drop resends
-- everything it buffered, and this is what recognises it.
SELECT * FROM facilities.alarm
WHERE tenant_id = @tenant_id AND gateway_id = @gateway_id
  AND external_id = @external_id;

-- name: UpdateFacilitiesAlarm :one
UPDATE facilities.alarm
SET state = @state,
    cleared_at = NULLIF(@cleared_at::text, '')::timestamptz,
    acknowledged_at = NULLIF(@acknowledged_at::text, '')::timestamptz,
    acknowledged_by = @acknowledged_by,
    work_order_id = NULLIF(@work_order_id::text, '')::uuid,
    linked_at = NULLIF(@linked_at::text, '')::timestamptz,
    linked_by = @linked_by,
    version = version + 1
WHERE tenant_id = @tenant_id AND id = @id
  AND version = @expected_version
RETURNING *;

-- name: ListFacilitiesAlarms :many
SELECT * FROM facilities.alarm
WHERE tenant_id = @tenant_id
  AND (@facility_id::text = '' OR facility_id = @facility_id::uuid)
  AND (@system::text = '' OR system = @system::text)
  AND (@state::text = '' OR state = @state::text)
  AND (NOT @unanswered_only::boolean OR acknowledged_at IS NULL)
  AND raised_at >= @raised_from AND raised_at <= @raised_to
ORDER BY raised_at DESC
LIMIT @row_limit;

-- name: InsertFacilitiesAlarmRule :one
INSERT INTO facilities.alarm_rule (
    id, tenant_id, facility_id, system, min_severity, priority,
    class_code, owner_team, active, created_at, created_by
) VALUES (
    @id, @tenant_id, NULLIF(@facility_id::text, '')::uuid, @system,
    @min_severity, @priority, @class_code, @owner_team, @active,
    @created_at, @created_by
)
RETURNING *;

-- name: ListFacilitiesAlarmRules :many
SELECT * FROM facilities.alarm_rule
WHERE tenant_id = @tenant_id AND active
  AND (@system::text = '' OR system = @system::text)
ORDER BY facility_id NULLS LAST, min_severity;

-- name: InsertFacilitiesDeficiency :one
INSERT INTO facilities.deficiency (
    id, tenant_id, task_id, asset_id, facility_id, location_id,
    location_note, system, severity, finding, standard, state, raised_at,
    raised_by, due_at, work_order_id, created_at, version
) VALUES (
    @id, @tenant_id, NULLIF(@task_id::text, '')::uuid,
    NULLIF(@asset_id::text, '')::uuid,
    NULLIF(@facility_id::text, '')::uuid,
    NULLIF(@location_id::text, '')::uuid, @location_note, @system,
    @severity, @finding, @standard, @state, @raised_at, @raised_by,
    NULLIF(@due_at::text, '')::timestamptz,
    NULLIF(@work_order_id::text, '')::uuid, @created_at, 1
)
RETURNING *;

-- name: GetFacilitiesDeficiency :one
SELECT * FROM facilities.deficiency
WHERE tenant_id = @tenant_id AND id = @id;

-- name: UpdateFacilitiesDeficiency :one
UPDATE facilities.deficiency
SET state = @state,
    mitigation_note = @mitigation_note,
    mitigated_at = NULLIF(@mitigated_at::text, '')::timestamptz,
    mitigated_by = @mitigated_by,
    closed_at = NULLIF(@closed_at::text, '')::timestamptz,
    closed_by = @closed_by,
    closure_evidence_ref = @closure_evidence_ref,
    version = version + 1
WHERE tenant_id = @tenant_id AND id = @id
  AND version = @expected_version
RETURNING *;

-- name: ListFacilitiesDeficiencies :many
-- No time window on purpose. SRS-FAC-008's acceptance is that open critical
-- findings remain visible until closure, and a query that aged them out
-- would let a hospital stop seeing the stairwell it never unblocked.
SELECT * FROM facilities.deficiency
WHERE tenant_id = @tenant_id
  AND (@facility_id::text = '' OR facility_id = @facility_id::uuid)
  AND (@task_id::text = '' OR task_id = @task_id::uuid)
  AND (@severity::text = '' OR severity = @severity::text)
  AND (NOT @open_only::boolean OR state <> 'closed')
ORDER BY due_at NULLS LAST, raised_at
LIMIT @row_limit;

-- name: InsertFacilitiesVendorVisit :one
INSERT INTO facilities.vendor_visit (
    id, tenant_id, vendor_name, vendor_ref, contact_name, technicians,
    facility_id, work_order_id, asset_id, task_id, work_requires_permit,
    induction_ref, purpose, state, signed_in_at, signed_in_by,
    created_at, version
) VALUES (
    @id, @tenant_id, @vendor_name, @vendor_ref, @contact_name,
    -- A nil Go slice writes as NULL, which the NOT NULL column refuses and
    -- cardinality() would answer NULL for anyway.
    COALESCE(@technicians::text[], ARRAY[]::text[]),
    NULLIF(@facility_id::text, '')::uuid,
    NULLIF(@work_order_id::text, '')::uuid,
    NULLIF(@asset_id::text, '')::uuid, NULLIF(@task_id::text, '')::uuid,
    @work_requires_permit, @induction_ref, @purpose, @state,
    @signed_in_at, @signed_in_by, @created_at, 1
)
RETURNING *;

-- name: GetFacilitiesVendorVisit :one
SELECT * FROM facilities.vendor_visit
WHERE tenant_id = @tenant_id AND id = @id;

-- name: UpdateFacilitiesVendorVisit :one
UPDATE facilities.vendor_visit
SET state = @state,
    signed_out_at = NULLIF(@signed_out_at::text, '')::timestamptz,
    signed_out_by = @signed_out_by,
    service_report_ref = @service_report_ref,
    report_summary = @report_summary,
    parts_used = COALESCE(@parts_used::text[], ARRAY[]::text[]),
    follow_up = @follow_up,
    version = version + 1
WHERE tenant_id = @tenant_id AND id = @id
  AND version = @expected_version
RETURNING *;

-- name: ListFacilitiesVendorVisits :many
SELECT * FROM facilities.vendor_visit
WHERE tenant_id = @tenant_id
  AND (@facility_id::text = '' OR facility_id = @facility_id::uuid)
  AND (@work_order_id::text = '' OR work_order_id = @work_order_id::uuid)
  AND (@asset_id::text = '' OR asset_id = @asset_id::uuid)
  AND (NOT @on_site_only::boolean OR state = 'on_site')
ORDER BY signed_in_at
LIMIT @row_limit;
