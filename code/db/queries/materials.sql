-- Materials, procurement and inventory (SRS-MAT-001 … 016).
--
-- The balance reads all go through materials.balance, the view that sums the
-- movement ledger. There is no on-hand column to read instead, which is the
-- point: one answer to "what do we hold", derived from immutable movements.

-- name: InsertMaterialsItem :exec
INSERT INTO materials.item (
    item_id, tenant_id, code, display, category, uom, tracking, policy,
    perishable, inspect_on_receipt, consignable, active, created_at, created_by
) VALUES (
    @item_id, @tenant_id, @code, @display, @category, @uom, @tracking, @policy,
    @perishable, @inspect_on_receipt, @consignable, @active, @created_at,
    @created_by
);

-- name: GetMaterialsItem :one
SELECT * FROM materials.item
WHERE tenant_id = $1 AND item_id = $2;

-- name: GetMaterialsItemByCode :one
SELECT * FROM materials.item
WHERE tenant_id = $1 AND code = $2;

-- name: UpdateMaterialsItem :execrows
UPDATE materials.item
SET display = @display, category = @category, policy = @policy,
    inspect_on_receipt = @inspect_on_receipt, consignable = @consignable,
    active = @active, version = version + 1
WHERE tenant_id = @tenant_id AND item_id = @item_id
  AND version = @expected_version;

-- name: ListMaterialsItems :many
SELECT * FROM materials.item
WHERE tenant_id = @tenant_id
  AND (@category::text = '' OR category = @category)
  AND (NOT @active_only::boolean OR active)
ORDER BY code
LIMIT @row_limit;

-- name: InsertSupplier :exec
INSERT INTO materials.supplier (
    supplier_id, tenant_id, code, display, approved, contact_email,
    contact_phone, payment_terms_days, currency, created_at, created_by
) VALUES (
    @supplier_id, @tenant_id, @code, @display, @approved, @contact_email,
    @contact_phone, @payment_terms_days, @currency, @created_at, @created_by
);

-- name: GetSupplier :one
SELECT * FROM materials.supplier
WHERE tenant_id = $1 AND supplier_id = $2;

-- name: UpdateSupplier :execrows
UPDATE materials.supplier
SET display = @display, approved = @approved, contact_email = @contact_email,
    contact_phone = @contact_phone, payment_terms_days = @payment_terms_days,
    currency = @currency, version = version + 1
WHERE tenant_id = @tenant_id AND supplier_id = @supplier_id
  AND version = @expected_version;

-- name: ListSuppliers :many
SELECT * FROM materials.supplier
WHERE tenant_id = @tenant_id
  AND (NOT @approved_only::boolean OR approved)
ORDER BY code
LIMIT @row_limit;

-- name: InsertLot :exec
INSERT INTO materials.lot (
    lot_id, tenant_id, item_id, code, expiry, received_at, ownership,
    supplier_id, created_at
) VALUES (
    @lot_id, @tenant_id, @item_id, @code, @expiry, @received_at, @ownership,
    @supplier_id, @created_at
);

-- name: GetLot :one
SELECT * FROM materials.lot
WHERE tenant_id = $1 AND lot_id = $2;

-- name: GetLotByCode :one
SELECT * FROM materials.lot
WHERE tenant_id = $1 AND item_id = $2 AND code = $3;

-- name: UpdateLotBlock :execrows
UPDATE materials.lot
SET blocked = @blocked, blocked_reason = @blocked_reason,
    blocked_at = @blocked_at, blocked_by = @blocked_by,
    version = version + 1
WHERE tenant_id = @tenant_id AND lot_id = @lot_id
  AND version = @expected_version;

-- name: ListLotsForItem :many
SELECT * FROM materials.lot
WHERE tenant_id = @tenant_id AND item_id = @item_id
ORDER BY received_at
LIMIT @row_limit;

-- The recall worklist (SRS-MAT-013).
-- name: ListBlockedLots :many
SELECT * FROM materials.lot
WHERE tenant_id = @tenant_id AND blocked
ORDER BY blocked_at DESC
LIMIT @row_limit;

-- Lots held in a location, which is what a pick recommendation reads
-- alongside the balances.
-- name: ListLotsAtLocation :many
SELECT DISTINCT l.* FROM materials.lot l
JOIN materials.balance b
  ON b.lot_id = l.lot_id AND b.tenant_id = l.tenant_id
WHERE l.tenant_id = @tenant_id AND l.item_id = @item_id
  AND b.location_id = @location_id
ORDER BY l.received_at
LIMIT @row_limit;

-- The ledger (SRS-MAT-007). Insert only: there is no update and no delete.
-- name: InsertMovement :exec
INSERT INTO materials.movement (
    movement_id, tenant_id, item_id, lot_id, from_location, from_status,
    to_location, to_status, quantity, kind, reference, reason, cost_centre,
    patient_id, encounter_id, occurred_at, recorded_by
) VALUES (
    @movement_id, @tenant_id, @item_id, @lot_id, @from_location, @from_status,
    @to_location, @to_status, @quantity, @kind, @reference, @reason,
    @cost_centre, @patient_id, @encounter_id, @occurred_at, @recorded_by
);

-- name: ListMovementsForItem :many
SELECT * FROM materials.movement
WHERE tenant_id = @tenant_id AND item_id = @item_id
  AND occurred_at >= @period_start AND occurred_at < @period_end
ORDER BY occurred_at
LIMIT @row_limit;

-- name: ListMovementsForLot :many
SELECT * FROM materials.movement
WHERE tenant_id = @tenant_id AND lot_id = @lot_id
ORDER BY occurred_at
LIMIT @row_limit;

-- name: ListMovementsByReference :many
SELECT * FROM materials.movement
WHERE tenant_id = @tenant_id AND reference = @reference
ORDER BY occurred_at
LIMIT @row_limit;

-- On-hand, derived (SRS-MAT-007).
-- name: ListBalancesAtLocation :many
SELECT * FROM materials.balance
WHERE tenant_id = @tenant_id AND location_id = @location_id
  AND (@item_id::text = '' OR item_id::text = @item_id)
ORDER BY item_id, lot_id, status
LIMIT @row_limit;

-- name: ListBalancesForItem :many
SELECT * FROM materials.balance
WHERE tenant_id = @tenant_id AND item_id = @item_id
ORDER BY location_id, lot_id, status
LIMIT @row_limit;

-- name: ListBalancesForLot :many
SELECT * FROM materials.balance
WHERE tenant_id = @tenant_id AND lot_id = @lot_id
ORDER BY location_id, status;

-- Available-to-promise: the status, the block and the expiry all have to pass,
-- and each fails on its own (SRS-MAT-006, SRS-MAT-013).
-- name: SumAvailable :one
SELECT COALESCE(SUM(b.quantity), 0)::bigint FROM materials.balance b
JOIN materials.lot l ON l.lot_id = b.lot_id AND l.tenant_id = b.tenant_id
WHERE b.tenant_id = @tenant_id AND b.item_id = @item_id
  AND b.location_id = @location_id AND b.status = 'available'
  AND NOT l.blocked
  AND (l.expiry IS NULL OR l.expiry > @as_of);

-- name: UpsertStockLevel :exec
INSERT INTO materials.stock_level (
    tenant_id, item_id, location_id, minimum, maximum, reorder_quantity,
    updated_at, updated_by
) VALUES (
    @tenant_id, @item_id, @location_id, @minimum, @maximum, @reorder_quantity,
    @updated_at, @updated_by
)
ON CONFLICT (tenant_id, item_id, location_id) DO UPDATE
SET minimum = EXCLUDED.minimum, maximum = EXCLUDED.maximum,
    reorder_quantity = EXCLUDED.reorder_quantity,
    updated_at = EXCLUDED.updated_at, updated_by = EXCLUDED.updated_by;

-- name: ListStockLevels :many
SELECT * FROM materials.stock_level
WHERE tenant_id = @tenant_id
  AND (@location_id::text = '' OR location_id = @location_id)
ORDER BY location_id, item_id
LIMIT @row_limit;

-- name: InsertRequisition :exec
INSERT INTO materials.requisition (
    requisition_id, tenant_id, number, facility_id, source, need_by,
    cost_centre, source_reference, lines, state, justification, raised_at,
    raised_by
) VALUES (
    @requisition_id, @tenant_id, @number, @facility_id, @source, @need_by,
    @cost_centre, @source_reference, @lines, @state, @justification,
    @raised_at, @raised_by
);

-- name: GetRequisition :one
SELECT * FROM materials.requisition
WHERE tenant_id = $1 AND requisition_id = $2;

-- name: UpdateRequisitionState :execrows
UPDATE materials.requisition
SET state = @state, version = version + 1
WHERE tenant_id = @tenant_id AND requisition_id = @requisition_id
  AND version = @expected_version;

-- name: ListRequisitions :many
SELECT * FROM materials.requisition
WHERE tenant_id = @tenant_id
  AND (@state::text = '' OR state = @state)
ORDER BY need_by, raised_at
LIMIT @row_limit;

-- The approval chain (SRS-MAT-002). Insert only.
-- name: InsertApprovalStep :exec
INSERT INTO materials.approval_step (
    approval_step_id, tenant_id, requisition_id, level, role, decision,
    decider, note, decided_at
) VALUES (
    @approval_step_id, @tenant_id, @requisition_id, @level, @role, @decision,
    @decider, @note, @decided_at
);

-- name: ListApprovalSteps :many
SELECT * FROM materials.approval_step
WHERE tenant_id = @tenant_id AND requisition_id = @requisition_id
ORDER BY level;

-- name: InsertApprovalRule :exec
INSERT INTO materials.approval_rule (
    approval_rule_id, tenant_id, minimum_value, currency, category,
    facility_id, roles, created_at, created_by
) VALUES (
    @approval_rule_id, @tenant_id, @minimum_value, @currency, @category,
    @facility_id, @roles, @created_at, @created_by
);

-- name: ListApprovalRules :many
SELECT * FROM materials.approval_rule
WHERE tenant_id = @tenant_id
ORDER BY minimum_value;

-- name: DeleteApprovalRule :execrows
DELETE FROM materials.approval_rule
WHERE tenant_id = @tenant_id AND approval_rule_id = @approval_rule_id;

-- name: InsertRFQ :exec
INSERT INTO materials.rfq (
    rfq_id, tenant_id, number, requisition_id, supplier_ids, lines, closes_at,
    issued_at, issued_by
) VALUES (
    @rfq_id, @tenant_id, @number, @requisition_id, @supplier_ids, @lines,
    @closes_at, @issued_at, @issued_by
);

-- name: GetRFQ :one
SELECT * FROM materials.rfq
WHERE tenant_id = $1 AND rfq_id = $2;

-- name: ListRFQs :many
SELECT * FROM materials.rfq
WHERE tenant_id = @tenant_id
ORDER BY issued_at DESC
LIMIT @row_limit;

-- name: InsertBid :exec
INSERT INTO materials.bid (
    bid_id, tenant_id, rfq_id, supplier_id, lines, lead_time_days,
    warranty_months, payment_terms_days, freight_minor, tax_minor, currency,
    notes, received_at, recorded_by
) VALUES (
    @bid_id, @tenant_id, @rfq_id, @supplier_id, @lines, @lead_time_days,
    @warranty_months, @payment_terms_days, @freight_minor, @tax_minor,
    @currency, @notes, @received_at, @recorded_by
);

-- name: ListBidsForRFQ :many
SELECT * FROM materials.bid
WHERE tenant_id = @tenant_id AND rfq_id = @rfq_id
ORDER BY received_at;

-- name: InsertPurchaseOrder :exec
INSERT INTO materials.purchase_order (
    purchase_order_id, tenant_id, number, facility_id, supplier_id,
    requisition_id, bid_id, revision, chain_id, supersedes, amendment_reason,
    lines, state, currency, payment_terms_days, delivery_terms,
    tolerance_over_percent, tolerance_short_percent, issued_at, issued_by,
    created_at, created_by
) VALUES (
    @purchase_order_id, @tenant_id, @number, @facility_id, @supplier_id,
    @requisition_id, @bid_id, @revision, @chain_id, @supersedes,
    @amendment_reason, @lines, @state, @currency, @payment_terms_days,
    @delivery_terms, @tolerance_over_percent, @tolerance_short_percent,
    @issued_at, @issued_by, @created_at, @created_by
);

-- name: GetPurchaseOrder :one
SELECT * FROM materials.purchase_order
WHERE tenant_id = $1 AND purchase_order_id = $2;

-- name: UpdatePurchaseOrderState :execrows
UPDATE materials.purchase_order
SET state = @state, issued_at = @issued_at, issued_by = @issued_by,
    version = version + 1
WHERE tenant_id = @tenant_id AND purchase_order_id = @purchase_order_id
  AND version = @expected_version;

-- Every revision of one order (SRS-MAT-004).
-- name: ListPurchaseOrderRevisions :many
SELECT * FROM materials.purchase_order
WHERE tenant_id = @tenant_id AND chain_id = @chain_id
ORDER BY revision;

-- name: ListPurchaseOrders :many
SELECT * FROM materials.purchase_order
WHERE tenant_id = @tenant_id
  AND (@supplier_id::text = '' OR supplier_id::text = @supplier_id)
  AND (@state::text = '' OR state = @state)
ORDER BY created_at DESC
LIMIT @row_limit;

-- Orders issued in a window, which is what a fill rate is computed over.
-- name: ListPurchaseOrdersIssuedBetween :many
SELECT * FROM materials.purchase_order
WHERE tenant_id = @tenant_id AND supplier_id = @supplier_id
  AND issued_at >= @period_start AND issued_at < @period_end
  AND state <> 'cancelled'
ORDER BY issued_at;

-- name: InsertReceipt :exec
INSERT INTO materials.receipt (
    receipt_id, tenant_id, number, purchase_order_id, po_revision,
    supplier_id, location_id, delivery_note, invoice_ref, lines, received_at,
    received_by
) VALUES (
    @receipt_id, @tenant_id, @number, @purchase_order_id, @po_revision,
    @supplier_id, @location_id, @delivery_note, @invoice_ref, @lines,
    @received_at, @received_by
);

-- name: GetReceipt :one
SELECT * FROM materials.receipt
WHERE tenant_id = $1 AND receipt_id = $2;

-- name: ListReceiptsForOrder :many
SELECT * FROM materials.receipt
WHERE tenant_id = @tenant_id AND purchase_order_id = @purchase_order_id
ORDER BY received_at;

-- name: ListReceiptsForSupplier :many
SELECT * FROM materials.receipt
WHERE tenant_id = @tenant_id AND supplier_id = @supplier_id
  AND received_at >= @period_start AND received_at < @period_end
ORDER BY received_at
LIMIT @row_limit;

-- name: InsertTransfer :exec
INSERT INTO materials.transfer (
    transfer_id, tenant_id, number, from_location, to_location, lines, state,
    reason, dispatched_at, dispatched_by
) VALUES (
    @transfer_id, @tenant_id, @number, @from_location, @to_location, @lines,
    @state, @reason, @dispatched_at, @dispatched_by
);

-- name: GetTransfer :one
SELECT * FROM materials.transfer
WHERE tenant_id = $1 AND transfer_id = $2;

-- name: UpdateTransfer :execrows
UPDATE materials.transfer
SET lines = @lines, state = @state, received_at = @received_at,
    received_by = @received_by, version = version + 1
WHERE tenant_id = @tenant_id AND transfer_id = @transfer_id
  AND version = @expected_version;

-- What is still on a trolley somewhere (SRS-MAT-010).
-- name: ListTransfersInTransit :many
SELECT * FROM materials.transfer
WHERE tenant_id = @tenant_id AND state = 'in_transit'
  AND (@to_location::text = '' OR to_location = @to_location)
ORDER BY dispatched_at
LIMIT @row_limit;

-- name: InsertStockCount :exec
INSERT INTO materials.stock_count (
    count_id, tenant_id, number, location_id, cycle, lines, state,
    opened_at, opened_by
) VALUES (
    @count_id, @tenant_id, @number, @location_id, @cycle, @lines, @state,
    @opened_at, @opened_by
);

-- name: GetStockCount :one
SELECT * FROM materials.stock_count
WHERE tenant_id = $1 AND count_id = $2;

-- name: UpdateStockCount :execrows
UPDATE materials.stock_count
SET lines = @lines, state = @state, approved_by = @approved_by,
    approved_at = @approved_at, approval_note = @approval_note,
    counted_at = @counted_at, counted_by = @counted_by,
    version = version + 1
WHERE tenant_id = @tenant_id AND count_id = @count_id
  AND version = @expected_version;

-- name: ListStockCounts :many
SELECT * FROM materials.stock_count
WHERE tenant_id = @tenant_id
  AND (@state::text = '' OR state = @state)
ORDER BY opened_at DESC
LIMIT @row_limit;

-- name: InsertSupplierInvoice :exec
INSERT INTO materials.invoice (
    invoice_id, tenant_id, number, supplier_id, purchase_order_id, lines,
    currency, received_at, recorded_by
) VALUES (
    @invoice_id, @tenant_id, @number, @supplier_id, @purchase_order_id,
    @lines, @currency, @received_at, @recorded_by
);

-- name: GetSupplierInvoice :one
SELECT * FROM materials.invoice
WHERE tenant_id = $1 AND invoice_id = $2;

-- name: ListSupplierInvoicesForOrder :many
SELECT * FROM materials.invoice
WHERE tenant_id = @tenant_id AND purchase_order_id = @purchase_order_id
ORDER BY received_at;

-- What consuming a supplier's stock owes them (SRS-MAT-016). Insert only.
-- name: InsertLiabilityEvent :exec
INSERT INTO materials.liability_event (
    liability_event_id, tenant_id, lot_id, item_id, supplier_id, quantity,
    patient_id, encounter_id, movement_id, occurred_at, recorded_by
) VALUES (
    @liability_event_id, @tenant_id, @lot_id, @item_id, @supplier_id,
    @quantity, @patient_id, @encounter_id, @movement_id, @occurred_at,
    @recorded_by
);

-- name: ListLiabilityEvents :many
SELECT * FROM materials.liability_event
WHERE tenant_id = @tenant_id AND supplier_id = @supplier_id
  AND occurred_at >= @period_start AND occurred_at < @period_end
ORDER BY occurred_at DESC
LIMIT @row_limit;
