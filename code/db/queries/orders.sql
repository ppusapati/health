-- Orders and CPOE (SRS-ORD).

-- name: InsertOrder :exec
-- The order is written as it stands, status and version included, because
-- placing is one act: a draft that reached the table at version 1 and was then
-- updated to requested would be visible to a concurrent reader in a state the
-- clinician never intended.
INSERT INTO orders.clinical_order (
    order_id, tenant_id, number, order_type, patient_id, encounter_id,
    facility_id, requester_id, entered_by_id, target_service,
    code_system, code_version, code, code_display, detail,
    indication, indication_system, indication_code, indication_display,
    priority, timing_start_at, timing_end_at, timing_frequency_seconds,
    timing_count, timing_times_of_day, timing_days_of_week, timing_prn,
    timing_duration_seconds, conditional_instruction, status,
    order_set_id, order_set_version, favourite_id,
    duplicate_override_reason, duplicate_override_by, duplicate_override_at,
    duplicate_override_against,
    cancellation_requested_at, cancellation_requested_by, cancellation_reason,
    created_at, updated_at, version
) VALUES (
    @order_id, @tenant_id, @number, @order_type, @patient_id, @encounter_id,
    @facility_id, @requester_id, @entered_by_id, @target_service,
    @code_system, @code_version, @code, @code_display, @detail,
    @indication, @indication_system, @indication_code, @indication_display,
    @priority, sqlc.narg('timing_start_at')::timestamptz,
    sqlc.narg('timing_end_at')::timestamptz, @timing_frequency_seconds,
    @timing_count, @timing_times_of_day, @timing_days_of_week, @timing_prn,
    @timing_duration_seconds, @conditional_instruction, @status,
    sqlc.narg('order_set_id')::uuid, @order_set_version,
    sqlc.narg('favourite_id')::uuid,
    @duplicate_override_reason, @duplicate_override_by,
    sqlc.narg('duplicate_override_at')::timestamptz,
    @duplicate_override_against,
    sqlc.narg('cancellation_requested_at')::timestamptz,
    @cancellation_requested_by, @cancellation_reason,
    @created_at, @updated_at, @version
);

-- name: GetOrder :one
SELECT * FROM orders.clinical_order
WHERE tenant_id = @tenant_id AND order_id = @order_id;

-- name: UpdateOrderStatus :execrows
-- Guarded on the version as well as the order, so two concurrent
-- acknowledgements cannot both move it.
UPDATE orders.clinical_order
SET status = @status, updated_at = @updated_at, version = version + 1
WHERE tenant_id = @tenant_id AND order_id = @order_id
  AND version = @expected_version;

-- name: UpdateOrderDraft :execrows
-- Guarded on the order still being a draft, so SRS-ORD-005's lifecycle holds at
-- the table even for a caller that skipped the domain check.
UPDATE orders.clinical_order
SET code_system = @code_system, code_version = @code_version, code = @code,
    code_display = @code_display, detail = @detail,
    indication = @indication, indication_system = @indication_system,
    indication_code = @indication_code, indication_display = @indication_display,
    priority = @priority,
    timing_start_at = sqlc.narg('timing_start_at')::timestamptz,
    timing_end_at = sqlc.narg('timing_end_at')::timestamptz,
    timing_frequency_seconds = @timing_frequency_seconds,
    timing_count = @timing_count,
    timing_times_of_day = @timing_times_of_day,
    timing_days_of_week = @timing_days_of_week,
    timing_prn = @timing_prn,
    timing_duration_seconds = @timing_duration_seconds,
    conditional_instruction = @conditional_instruction,
    updated_at = @updated_at, version = version + 1
WHERE tenant_id = @tenant_id AND order_id = @order_id
  AND status = 'draft' AND version = @expected_version;

-- name: RequestOrderCancellation :execrows
-- SRS-ORD-004's corrective workflow. Guarded on the order still executing and
-- on no request already standing: the order does not change state, because a
-- request is not an outcome.
UPDATE orders.clinical_order
SET cancellation_requested_at = @cancellation_requested_at,
    cancellation_requested_by = @cancellation_requested_by,
    cancellation_reason = @cancellation_reason,
    updated_at = @updated_at, version = version + 1
WHERE tenant_id = @tenant_id AND order_id = @order_id
  AND cancellation_requested_at IS NULL
  AND status IN ('in_progress')
  AND version = @expected_version;

-- name: RecordDuplicateOverride :execrows
UPDATE orders.clinical_order
SET duplicate_override_reason = @duplicate_override_reason,
    duplicate_override_by = @duplicate_override_by,
    duplicate_override_at = @duplicate_override_at,
    duplicate_override_against = @duplicate_override_against,
    updated_at = @updated_at, version = version + 1
WHERE tenant_id = @tenant_id AND order_id = @order_id
  AND status = 'draft' AND version = @expected_version;

-- name: ListOrdersForPatient :many
SELECT * FROM orders.clinical_order
WHERE tenant_id = @tenant_id
  AND patient_id = @patient_id
  AND (sqlc.narg('encounter_filter')::uuid IS NULL
       OR encounter_id = sqlc.narg('encounter_filter')::uuid)
  AND (@type_filter::text = '' OR order_type = @type_filter::text)
  AND (@live_only::boolean = false
       OR status NOT IN ('completed', 'cancelled', 'entered_in_error'))
ORDER BY created_at DESC
LIMIT @page_limit;

-- name: ListLiveOrdersOfType :many
-- What the duplicate check reads (SRS-ORD-009): live orders of one type for one
-- patient inside a window. A completed order is not a duplicate — the patient
-- may well need the test again.
SELECT * FROM orders.clinical_order
WHERE tenant_id = @tenant_id
  AND patient_id = @patient_id
  AND order_type = @order_type
  AND status NOT IN ('draft', 'completed', 'cancelled', 'entered_in_error')
  AND created_at >= @since
ORDER BY created_at DESC
LIMIT @page_limit;

-- name: ListOrdersForService :many
-- The performing service's worklist.
SELECT * FROM orders.clinical_order
WHERE tenant_id = @tenant_id
  AND target_service = @target_service
  AND status NOT IN ('draft', 'completed', 'cancelled', 'entered_in_error')
  AND (@facility_filter::text = '' OR facility_id::text = @facility_filter::text)
ORDER BY
    CASE priority
        WHEN 'stat' THEN 0 WHEN 'timing_critical' THEN 1
        WHEN 'urgent' THEN 2 ELSE 3
    END,
    created_at
LIMIT @page_limit;

-- Order numbers come from the platform's numbering sequence (SRS-PLT-014)
-- rather than from a counter of this context's own: the guarantee the
-- requirement already provides — atomic, collision-free under concurrency, and
-- gapless because a rolled-back transaction returns its number — is the
-- guarantee an order number needs, and a second implementation would be a
-- second set of bugs. See organization.IssueTenantNumber.

-- name: InsertOrderStatusChange :exec
INSERT INTO orders.order_status_change (
    change_id, tenant_id, order_id, from_status, to_status, changed_by,
    reason, occurred_at
) VALUES (
    @change_id, @tenant_id, @order_id, @from_status, @to_status, @changed_by,
    @reason, @occurred_at
);

-- name: ListOrderStatusChanges :many
SELECT change_id, tenant_id, order_id, from_status, to_status, changed_by,
       reason, occurred_at
FROM orders.order_status_change
WHERE tenant_id = @tenant_id AND order_id = @order_id
ORDER BY occurred_at;

-- name: InsertAcknowledgement :execrows
-- SRS-ORD-006's idempotency guard. ON CONFLICT DO NOTHING rather than a check
-- beforehand: two deliveries of one acknowledgement can be in flight at the
-- same moment, and a check-then-apply would let both through. A zero row count
-- means this delivery has already been seen.
INSERT INTO orders.order_acknowledgement (
    tenant_id, order_id, service, delivery_id, to_status, reason,
    performer_id, occurred_at, received_at, applied
) VALUES (
    @tenant_id, @order_id, @service, @delivery_id, @to_status, @reason,
    @performer_id, @occurred_at, @received_at, @applied
)
ON CONFLICT (tenant_id, order_id, service, delivery_id) DO NOTHING;

-- name: MarkAcknowledgementApplied :exec
-- Records that this delivery actually moved the order, which is what makes
-- "how often does the bus redeliver" answerable.
UPDATE orders.order_acknowledgement
SET applied = true
WHERE tenant_id = @tenant_id AND order_id = @order_id
  AND service = @service AND delivery_id = @delivery_id;

-- name: ListAcknowledgements :many
SELECT tenant_id, order_id, service, delivery_id, to_status, reason,
       performer_id, occurred_at, received_at, applied
FROM orders.order_acknowledgement
WHERE tenant_id = @tenant_id AND order_id = @order_id
ORDER BY received_at;

-- name: InsertOrderSet :exec
INSERT INTO orders.order_set (
    set_id, tenant_id, version, name, specialty, components, retired,
    created_by, created_at
) VALUES (
    @set_id, @tenant_id, @version, @name, @specialty, @components, false,
    @created_by, @created_at
);

-- name: GetOrderSet :one
SELECT set_id, tenant_id, version, name, specialty, components, retired,
       created_by, created_at
FROM orders.order_set
WHERE tenant_id = @tenant_id AND set_id = @set_id AND version = @version;

-- name: ListOrderSets :many
SELECT set_id, tenant_id, version, name, specialty, components, retired,
       created_by, created_at
FROM orders.order_set
WHERE tenant_id = @tenant_id
  AND (@include_retired::boolean = true OR retired = false)
  AND (@specialty_filter::text = '' OR specialty = @specialty_filter::text)
ORDER BY name, version
LIMIT @page_limit;

-- name: RetireOrderSet :execrows
UPDATE orders.order_set
SET retired = true
WHERE tenant_id = @tenant_id AND set_id = @set_id AND version = @version;

-- name: UpsertFavourite :exec
INSERT INTO orders.order_favourite (
    favourite_id, tenant_id, owner_id, name, order_type, code_system,
    code_version, code, code_display, detail, indication, priority,
    timing_start_at, timing_frequency_seconds, timing_count,
    timing_times_of_day, timing_days_of_week, timing_prn,
    created_at, updated_at
) VALUES (
    @favourite_id, @tenant_id, @owner_id, @name, @order_type, @code_system,
    @code_version, @code, @code_display, @detail, @indication, @priority,
    sqlc.narg('timing_start_at')::timestamptz, @timing_frequency_seconds,
    @timing_count, @timing_times_of_day, @timing_days_of_week, @timing_prn,
    @created_at, @updated_at
)
ON CONFLICT (favourite_id) DO UPDATE
SET name = EXCLUDED.name, code_system = EXCLUDED.code_system,
    code_version = EXCLUDED.code_version, code = EXCLUDED.code,
    code_display = EXCLUDED.code_display, detail = EXCLUDED.detail,
    indication = EXCLUDED.indication, priority = EXCLUDED.priority,
    timing_start_at = EXCLUDED.timing_start_at,
    timing_frequency_seconds = EXCLUDED.timing_frequency_seconds,
    timing_count = EXCLUDED.timing_count,
    timing_times_of_day = EXCLUDED.timing_times_of_day,
    timing_days_of_week = EXCLUDED.timing_days_of_week,
    timing_prn = EXCLUDED.timing_prn,
    updated_at = EXCLUDED.updated_at;

-- name: GetFavourite :one
SELECT * FROM orders.order_favourite
WHERE tenant_id = @tenant_id AND favourite_id = @favourite_id;

-- name: ListFavourites :many
-- Scoped to the owner: a favourite is never shared, because a shared shortcut
-- with no review is an order set that escaped governance (SRS-ORD-012).
SELECT * FROM orders.order_favourite
WHERE tenant_id = @tenant_id AND owner_id = @owner_id
  AND (@type_filter::text = '' OR order_type = @type_filter::text)
ORDER BY name
LIMIT @page_limit;

-- name: DeleteFavourite :execrows
DELETE FROM orders.order_favourite
WHERE tenant_id = @tenant_id AND favourite_id = @favourite_id
  AND owner_id = @owner_id;

-- name: UpsertOrderPolicy :exec
INSERT INTO orders.order_policy (
    tenant_id, order_type, indication_required, structured_timing_required,
    required_privilege, updated_by, updated_at
) VALUES (
    @tenant_id, @order_type, @indication_required, @structured_timing_required,
    @required_privilege, @updated_by, @updated_at
)
ON CONFLICT (tenant_id, order_type) DO UPDATE
SET indication_required = EXCLUDED.indication_required,
    structured_timing_required = EXCLUDED.structured_timing_required,
    required_privilege = EXCLUDED.required_privilege,
    updated_by = EXCLUDED.updated_by, updated_at = EXCLUDED.updated_at;

-- name: ListOrderPolicy :many
SELECT tenant_id, order_type, indication_required, structured_timing_required,
       required_privilege, updated_by, updated_at
FROM orders.order_policy
WHERE tenant_id = @tenant_id;

-- name: UpsertDuplicateRule :exec
INSERT INTO orders.duplicate_rule (
    tenant_id, order_type, within_seconds, same_code_only, overridable,
    updated_by, updated_at
) VALUES (
    @tenant_id, @order_type, @within_seconds, @same_code_only, @overridable,
    @updated_by, @updated_at
)
ON CONFLICT (tenant_id, order_type) DO UPDATE
SET within_seconds = EXCLUDED.within_seconds,
    same_code_only = EXCLUDED.same_code_only,
    overridable = EXCLUDED.overridable,
    updated_by = EXCLUDED.updated_by, updated_at = EXCLUDED.updated_at;

-- name: ListDuplicateRules :many
SELECT tenant_id, order_type, within_seconds, same_code_only, overridable,
       updated_by, updated_at
FROM orders.duplicate_rule
WHERE tenant_id = @tenant_id;
