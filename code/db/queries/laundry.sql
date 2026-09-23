-- Laundry and linen (SRS-LND-001 … 007).
--
-- Every statement is tenant-scoped in its WHERE clause. The adapter cannot be
-- called without authctx.TenantScope and the scope's tenant is what lands in
-- @tenant_id, so a cross-tenant read is not a thing a caller can ask for
-- (ADR-0001, FIT-03).
--
-- There is no UPDATE or DELETE against laundry.tracked_movement. A custody
-- trail somebody can edit says whatever the last person to touch it wanted
-- (FIT-08).
--
-- There is no UPDATE that edits an approved par level's lines, and none that
-- edits an issue's lines. A par edited in place changes what last month's
-- shortfall was measured against; a delivery note corrected after the fact is
-- a balance nobody can reconcile. Both are superseded rather than amended.

-- name: InsertLinenItem :exec
INSERT INTO laundry.linen_item (
    item_id, tenant_id, code, name, category, unit_weight_g,
    replacement_cost_minor, tracked, active, created_at, created_by, version
) VALUES (
    @item_id, @tenant_id, @code, @name, @category, @unit_weight_g,
    @replacement_cost_minor, @tracked, @active, @created_at, @created_by,
    @version
);

-- name: GetLinenItem :one
SELECT * FROM laundry.linen_item
WHERE tenant_id = @tenant_id AND item_id = @item_id;

-- name: GetLinenItemByCode :one
SELECT * FROM laundry.linen_item
WHERE tenant_id = @tenant_id AND lower(code) = lower(@code::text);

-- name: UpdateLinenItem :execrows
UPDATE laundry.linen_item
SET name = @name, active = @active, version = version + 1
WHERE tenant_id = @tenant_id AND item_id = @item_id
  AND version = @expected_version;

-- name: ListLinenItems :many
SELECT * FROM laundry.linen_item
WHERE tenant_id = @tenant_id
  AND (@category::text = '' OR category = @category)
  AND (NOT @tracked_only::boolean OR tracked)
  AND (NOT @active_only::boolean OR active)
ORDER BY category, code
LIMIT @page_limit OFFSET @page_offset;

-- name: InsertParLevel :exec
INSERT INTO laundry.par_level (
    par_id, tenant_id, unit_id, unit_name, facility_id, revision, approved,
    approved_by, approved_at, effective_from, superseded_at, created_at,
    created_by, version
) VALUES (
    @par_id, @tenant_id, @unit_id, @unit_name, @facility_id, @revision,
    @approved, @approved_by, @approved_at, @effective_from, @superseded_at,
    @created_at, @created_by, @version
);

-- name: InsertParLine :exec
INSERT INTO laundry.par_line (
    par_id, item_code, quantity, reorder_at, position
) VALUES (@par_id, @item_code, @quantity, @reorder_at, @position);

-- name: GetParLevel :one
SELECT * FROM laundry.par_level
WHERE tenant_id = @tenant_id AND par_id = @par_id;

-- name: ListParLines :many
SELECT * FROM laundry.par_line
WHERE par_id = ANY(@par_ids::uuid[])
ORDER BY par_id, position, item_code;

-- name: ApproveParLevel :execrows
UPDATE laundry.par_level
SET approved = true, approved_by = @approved_by, approved_at = @approved_at,
    effective_from = @effective_from, version = version + 1
WHERE tenant_id = @tenant_id AND par_id = @par_id
  AND version = @expected_version;

-- name: SupersedeParLevel :execrows
UPDATE laundry.par_level
SET superseded_at = @superseded_at, version = version + 1
WHERE tenant_id = @tenant_id AND par_id = @par_id
  AND superseded_at IS NULL;

-- name: ListParLevels :many
SELECT * FROM laundry.par_level
WHERE tenant_id = @tenant_id
  AND (@facility_id::text = '' OR facility_id = @facility_id)
  AND (@unit_id::text = '' OR lower(unit_id) = lower(@unit_id))
  AND (NOT @live_only::boolean OR (
        approved
        AND effective_from IS NOT NULL AND effective_from <= @at
        AND (superseded_at IS NULL OR superseded_at > @at)))
ORDER BY unit_id, revision DESC
LIMIT @page_limit OFFSET @page_offset;

-- name: ListParRevisions :many
SELECT * FROM laundry.par_level
WHERE tenant_id = @tenant_id AND lower(unit_id) = lower(@unit_id::text)
ORDER BY revision DESC;

-- name: InsertWashBatch :exec
INSERT INTO laundry.wash_batch (
    batch_id, tenant_id, reference, facility_id, machine_id, cycle,
    infected, weight_g, state, outcome, peak_temperature_c, hold_minutes,
    rewash_batch_id, rewash_of_batch_id, started_at, started_by,
    completed_at, completed_by, created_at, created_by, version
) VALUES (
    @batch_id, @tenant_id, @reference, @facility_id, @machine_id, @cycle,
    @infected, @weight_g, @state, @outcome, @peak_temperature_c,
    @hold_minutes, @rewash_batch_id, @rewash_of_batch_id, @started_at,
    @started_by, @completed_at, @completed_by, @created_at, @created_by,
    @version
);

-- name: InsertBatchException :exec
INSERT INTO laundry.batch_exception (batch_id, code, detail, position)
VALUES (@batch_id, @code, @detail, @position);

-- name: ListBatchExceptions :many
SELECT * FROM laundry.batch_exception
WHERE batch_id = ANY(@batch_ids::uuid[])
ORDER BY batch_id, position, code;

-- name: GetWashBatch :one
SELECT * FROM laundry.wash_batch
WHERE tenant_id = @tenant_id AND batch_id = @batch_id;

-- name: UpdateWashBatch :execrows
UPDATE laundry.wash_batch
SET infected = @infected, weight_g = @weight_g, state = @state,
    outcome = @outcome, peak_temperature_c = @peak_temperature_c,
    hold_minutes = @hold_minutes, rewash_batch_id = @rewash_batch_id,
    rewash_of_batch_id = @rewash_of_batch_id,
    started_at = @started_at, started_by = @started_by,
    completed_at = @completed_at, completed_by = @completed_by,
    version = version + 1
WHERE tenant_id = @tenant_id AND batch_id = @batch_id
  AND version = @expected_version;

-- name: ListWashBatches :many
SELECT * FROM laundry.wash_batch
WHERE tenant_id = @tenant_id
  AND (@facility_id::text = '' OR facility_id = @facility_id)
  AND (@machine_id::text = '' OR machine_id = @machine_id)
  AND (@cycle::text = '' OR cycle = @cycle)
  AND (cardinality(@states::text[]) = 0 OR state = ANY(@states::text[]))
  AND created_at >= @from_time AND created_at <= @to_time
ORDER BY created_at DESC, batch_id
LIMIT @page_limit OFFSET @page_offset;

-- name: InsertLinenCollection :exec
INSERT INTO laundry.collection (
    collection_id, tenant_id, unit_id, unit_name, facility_id, soil_class,
    handling, bag_count, weight_g, state, batch_id, batch_cycle,
    cancel_reason, collected_at, collected_by, version
) VALUES (
    @collection_id, @tenant_id, @unit_id, @unit_name, @facility_id,
    @soil_class, @handling, @bag_count, @weight_g, @state, @batch_id,
    @batch_cycle, @cancel_reason, @collected_at, @collected_by, @version
);

-- name: InsertCollectionLine :exec
INSERT INTO laundry.collection_line (
    collection_id, item_code, quantity, position
) VALUES (@collection_id, @item_code, @quantity, @position);

-- name: DeleteCollectionLines :exec
DELETE FROM laundry.collection_line WHERE collection_id = @collection_id;

-- name: ListCollectionLines :many
SELECT * FROM laundry.collection_line
WHERE collection_id = ANY(@collection_ids::uuid[])
ORDER BY collection_id, position, item_code;

-- name: GetLinenCollection :one
SELECT * FROM laundry.collection
WHERE tenant_id = @tenant_id AND collection_id = @collection_id;

-- name: UpdateLinenCollection :execrows
UPDATE laundry.collection
SET state = @state, batch_id = @batch_id, batch_cycle = @batch_cycle,
    cancel_reason = @cancel_reason, version = version + 1
WHERE tenant_id = @tenant_id AND collection_id = @collection_id
  AND version = @expected_version;

-- name: ListLinenCollections :many
SELECT * FROM laundry.collection
WHERE tenant_id = @tenant_id
  AND (@facility_id::text = '' OR facility_id = @facility_id)
  AND (@unit_id::text = '' OR lower(unit_id) = lower(@unit_id))
  AND (@soil_class::text = '' OR soil_class = @soil_class)
  AND (cardinality(@states::text[]) = 0 OR state = ANY(@states::text[]))
  AND (NOT @pending_only::boolean OR state = 'open')
  AND collected_at >= @from_time AND collected_at <= @to_time
ORDER BY collected_at DESC, collection_id
LIMIT @page_limit OFFSET @page_offset;

-- name: ListCollectionsForBatch :many
SELECT * FROM laundry.collection
WHERE tenant_id = @tenant_id AND batch_id = @batch_id
ORDER BY collected_at, collection_id;

-- name: InsertLinenIssue :exec
INSERT INTO laundry.linen_issue (
    issue_id, tenant_id, unit_id, unit_name, facility_id, batch_id,
    batch_state, batch_reference, issued_at, issued_by, received_at,
    received_by, version
) VALUES (
    @issue_id, @tenant_id, @unit_id, @unit_name, @facility_id, @batch_id,
    @batch_state, @batch_reference, @issued_at, @issued_by, @received_at,
    @received_by, @version
);

-- name: InsertIssueLine :exec
INSERT INTO laundry.issue_line (issue_id, item_code, quantity, position)
VALUES (@issue_id, @item_code, @quantity, @position);

-- name: ListIssueLines :many
SELECT * FROM laundry.issue_line
WHERE issue_id = ANY(@issue_ids::uuid[])
ORDER BY issue_id, position, item_code;

-- name: GetLinenIssue :one
SELECT * FROM laundry.linen_issue
WHERE tenant_id = @tenant_id AND issue_id = @issue_id;

-- name: ReceiveLinenIssue :execrows
UPDATE laundry.linen_issue
SET received_at = @received_at, received_by = @received_by,
    version = version + 1
WHERE tenant_id = @tenant_id AND issue_id = @issue_id
  AND version = @expected_version;

-- name: ListLinenIssues :many
SELECT * FROM laundry.linen_issue
WHERE tenant_id = @tenant_id
  AND (@facility_id::text = '' OR facility_id = @facility_id)
  AND (@unit_id::text = '' OR lower(unit_id) = lower(@unit_id))
  AND (@batch_id::text = '' OR batch_id::text = @batch_id)
  AND (NOT @outstanding_only::boolean OR received_at IS NULL)
  AND issued_at >= @from_time AND issued_at <= @to_time
ORDER BY issued_at DESC, issue_id
LIMIT @page_limit OFFSET @page_offset;

-- name: InsertLossRecord :exec
INSERT INTO laundry.loss_record (
    loss_id, tenant_id, unit_id, facility_id, item_code, quantity, kind,
    reason, value_minor, state, approval_required, approved_by, approved_at,
    decision_note, reported_at, reported_by, version
) VALUES (
    @loss_id, @tenant_id, @unit_id, @facility_id, @item_code, @quantity,
    @kind, @reason, @value_minor, @state, @approval_required, @approved_by,
    @approved_at, @decision_note, @reported_at, @reported_by, @version
);

-- name: GetLossRecord :one
SELECT * FROM laundry.loss_record
WHERE tenant_id = @tenant_id AND loss_id = @loss_id;

-- name: UpdateLossRecord :execrows
UPDATE laundry.loss_record
SET state = @state, approved_by = @approved_by, approved_at = @approved_at,
    decision_note = @decision_note, version = version + 1
WHERE tenant_id = @tenant_id AND loss_id = @loss_id
  AND version = @expected_version;

-- name: ListLossRecords :many
SELECT * FROM laundry.loss_record
WHERE tenant_id = @tenant_id
  AND (@facility_id::text = '' OR facility_id = @facility_id)
  AND (@unit_id::text = '' OR lower(unit_id) = lower(@unit_id))
  AND (@item_code::text = '' OR lower(item_code) = lower(@item_code))
  AND (@kind::text = '' OR kind = @kind)
  AND (cardinality(@states::text[]) = 0 OR state = ANY(@states::text[]))
  AND reported_at >= @from_time AND reported_at <= @to_time
ORDER BY reported_at DESC, loss_id
LIMIT @page_limit OFFSET @page_offset;

-- name: InsertTrackedItem :exec
INSERT INTO laundry.tracked_item (
    tracked_id, tenant_id, tag_id, tag_kind, item_code, item_tracked,
    assigned_to, facility_id, state, retired_reason, registered_at,
    registered_by, version
) VALUES (
    @tracked_id, @tenant_id, @tag_id, @tag_kind, @item_code, true,
    @assigned_to, @facility_id, @state, @retired_reason, @registered_at,
    @registered_by, @version
);

-- name: GetTrackedItem :one
SELECT * FROM laundry.tracked_item
WHERE tenant_id = @tenant_id AND tracked_id = @tracked_id;

-- name: GetTrackedItemByTag :one
SELECT * FROM laundry.tracked_item
WHERE tenant_id = @tenant_id AND lower(tag_id) = lower(@tag_id::text);

-- name: UpdateTrackedItem :execrows
UPDATE laundry.tracked_item
SET assigned_to = @assigned_to, state = @state,
    retired_reason = @retired_reason, version = version + 1
WHERE tenant_id = @tenant_id AND tracked_id = @tracked_id
  AND version = @expected_version;

-- name: ListTrackedItems :many
SELECT * FROM laundry.tracked_item
WHERE tenant_id = @tenant_id
  AND (@facility_id::text = '' OR facility_id = @facility_id)
  AND (@item_code::text = '' OR lower(item_code) = lower(@item_code))
  AND (@assigned_to::text = '' OR assigned_to = @assigned_to)
  AND (NOT @in_service_only::boolean OR state = 'in_service')
ORDER BY item_code, tag_id
LIMIT @page_limit OFFSET @page_offset;

-- name: AppendTrackedMovement :exec
INSERT INTO laundry.tracked_movement (
    movement_id, tenant_id, tracked_id, location, holder_id, note,
    recorded_by, occurred_at
) VALUES (
    @movement_id, @tenant_id, @tracked_id, @location, @holder_id, @note,
    @recorded_by, @occurred_at
);

-- name: ListTrackedMovements :many
SELECT * FROM laundry.tracked_movement
WHERE tenant_id = @tenant_id AND tracked_id = ANY(@tracked_ids::uuid[])
ORDER BY tracked_id, occurred_at;

-- name: ListCollectionsForBatches :many
SELECT collection_id, batch_id FROM laundry.collection
WHERE tenant_id = @tenant_id AND batch_id = ANY(@batch_ids::uuid[])
ORDER BY batch_id, collected_at, collection_id;
