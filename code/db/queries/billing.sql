-- Billing, tariffs and patient revenue (SRS-BIL).
--
-- Every statement is scoped by tenant_id as well as by the caller's verified
-- TenantScope, so a missing scope is a query that returns nothing rather than
-- one that returns somebody else's financial records.
--
-- Note what is absent: there is no UPDATE and no DELETE against
-- billing.ledger_entry, and no UPDATE that touches an issued invoice's lines.
-- Those absences are the mechanism behind SRS-BIL-010 and SRS-BIL-012 — a
-- correction is another row, and the balance is the sum of what is there.

-- name: UpsertServiceItem :exec
INSERT INTO billing.service_item (
    tenant_id, code, description, department, revenue_account,
    tax_code, tax_rate_bp, tax_inclusive,
    effective_from, effective_to, updated_by, updated_at
) VALUES (
    @tenant_id, @code, @description, @department, @revenue_account,
    @tax_code, @tax_rate_bp, @tax_inclusive,
    @effective_from, sqlc.narg('effective_to')::timestamptz,
    @updated_by, @updated_at
);

-- name: CloseServiceVersion :execrows
-- Ends the current version so a new one can begin, which is how a price change
-- is published: the old version stays readable and a March invoice still
-- resolves what March charged.
UPDATE billing.service_item
SET effective_to = @effective_to, updated_by = @updated_by, updated_at = @updated_at
WHERE tenant_id = @tenant_id AND code = @code AND effective_to IS NULL;

-- name: ListServiceVersions :many
SELECT * FROM billing.service_item
WHERE tenant_id = @tenant_id AND code = @code
ORDER BY effective_from DESC;

-- name: ListServiceItems :many
SELECT * FROM billing.service_item
WHERE tenant_id = @tenant_id
ORDER BY code, effective_from DESC
LIMIT @row_limit;

-- name: UpsertTariffLine :exec
INSERT INTO billing.tariff_line (
    tariff_line_id, tenant_id, contract_id, name,
    payer_id, customer_id, facility_id, room_class, service_code,
    price_minor, currency, priority,
    effective_from, effective_to, updated_by, updated_at
) VALUES (
    @tariff_line_id, @tenant_id, @contract_id, @name,
    @payer_id, @customer_id, @facility_id, @room_class, @service_code,
    @price_minor, @currency, @priority,
    @effective_from, sqlc.narg('effective_to')::timestamptz,
    @updated_by, @updated_at
)
ON CONFLICT (tariff_line_id)
DO UPDATE SET
    name = EXCLUDED.name,
    price_minor = EXCLUDED.price_minor,
    priority = EXCLUDED.priority,
    effective_to = EXCLUDED.effective_to,
    updated_by = EXCLUDED.updated_by,
    updated_at = EXCLUDED.updated_at;

-- name: ListTariffLinesForService :many
-- Everything that could price this service, including the contracts whose
-- service axis is empty: a query keyed only on the service code would miss the
-- standard list price, which is the one most charges resolve to.
SELECT * FROM billing.tariff_line
WHERE tenant_id = @tenant_id
  AND (service_code = '' OR service_code = @service_code)
ORDER BY tariff_line_id;

-- name: ListTariffLines :many
SELECT * FROM billing.tariff_line
WHERE tenant_id = @tenant_id
ORDER BY contract_id, tariff_line_id
LIMIT @row_limit;

-- name: UpsertPackage :exec
INSERT INTO billing.package (
    tenant_id, code, name, price_minor, currency, room_class,
    inclusions, exclusions, carve_outs,
    effective_from, effective_to, updated_by, updated_at
) VALUES (
    @tenant_id, @code, @name, @price_minor, @currency, @room_class,
    @inclusions, @exclusions, @carve_outs,
    @effective_from, sqlc.narg('effective_to')::timestamptz,
    @updated_by, @updated_at
);

-- name: GetPackage :one
SELECT * FROM billing.package
WHERE tenant_id = @tenant_id AND code = @code
  AND effective_from <= @at
  AND (effective_to IS NULL OR effective_to > @at);

-- name: ListPackages :many
SELECT * FROM billing.package
WHERE tenant_id = @tenant_id
ORDER BY code, effective_from DESC
LIMIT @row_limit;

-- name: InsertAccount :exec
INSERT INTO billing.account (
    account_id, tenant_id, patient_id, encounter_id, facility_id, currency,
    payer_id, customer_id, room_class, package_code,
    status, closed_by, closed_at, created_at, updated_at, version
) VALUES (
    @account_id, @tenant_id, @patient_id, @encounter_id, @facility_id, @currency,
    @payer_id, @customer_id, @room_class, @package_code,
    @status, '', NULL, @created_at, @updated_at, @version
);

-- name: GetAccount :one
SELECT * FROM billing.account
WHERE tenant_id = @tenant_id AND account_id = @account_id;

-- name: GetAccountForEncounter :one
SELECT * FROM billing.account
WHERE tenant_id = @tenant_id AND encounter_id = @encounter_id;

-- name: UpdateAccountCoverage :execrows
UPDATE billing.account
SET payer_id = @payer_id, customer_id = @customer_id,
    room_class = @room_class, package_code = @package_code,
    updated_at = @updated_at, version = @version
WHERE tenant_id = @tenant_id AND account_id = @account_id
  AND version = @expected_version AND status = 'open';

-- name: CloseAccount :execrows
-- Guarded on the account still being open and on its version, so two billers
-- closing at the same moment resolve to one close.
UPDATE billing.account
SET status = 'closed', closed_by = @closed_by, closed_at = @closed_at,
    updated_at = @updated_at, version = @version
WHERE tenant_id = @tenant_id AND account_id = @account_id
  AND version = @expected_version AND status = 'open';

-- name: InsertCharge :exec
INSERT INTO billing.charge (
    charge_id, tenant_id, account_id, patient_id, encounter_id, facility_id,
    service_code, description, department, revenue_account,
    quantity, unit_price_minor, currency, tariff_contract_id, tariff_contract,
    tax_code, tax_rate_bp, tax_inclusive,
    origin, source_system, source_id, source_detail, entered_by, reason,
    occurred_at, posted_at, status, package_code, covered, coverage_note,
    invoice_id, version
) VALUES (
    @charge_id, @tenant_id, @account_id, @patient_id, @encounter_id, @facility_id,
    @service_code, @description, @department, @revenue_account,
    @quantity, @unit_price_minor, @currency, @tariff_contract_id, @tariff_contract,
    @tax_code, @tax_rate_bp, @tax_inclusive,
    @origin, @source_system, @source_id, @source_detail, @entered_by, @reason,
    @occurred_at, @posted_at, @status, @package_code, @covered, @coverage_note,
    NULL, @version
)
-- SRS-BIL-003's "cannot be silently duplicated". A redelivered event inserts
-- nothing and the caller reads the zero row count as "already charged", which is
-- the right answer rather than an error.
ON CONFLICT DO NOTHING;

-- name: GetCharge :one
SELECT * FROM billing.charge
WHERE tenant_id = @tenant_id AND charge_id = @charge_id;

-- name: GetChargeBySource :one
SELECT * FROM billing.charge
WHERE tenant_id = @tenant_id
  AND source_system = @source_system AND source_id = @source_id
  AND status <> 'voided';

-- name: ListChargesForAccount :many
SELECT * FROM billing.charge
WHERE tenant_id = @tenant_id AND account_id = @account_id
  AND (NOT @billable_only::boolean OR status = 'posted')
ORDER BY occurred_at, charge_id
LIMIT @row_limit;

-- name: ListChargesByStatus :many
SELECT * FROM billing.charge
WHERE tenant_id = @tenant_id AND account_id = @account_id AND status = @status
ORDER BY occurred_at, charge_id;

-- name: ListUnbilledCharges :many
-- The revenue-integrity worklist (SRS-BIL-011), oldest first: age is what
-- distinguishes a query from a loss.
SELECT * FROM billing.charge
WHERE tenant_id = @tenant_id
  AND facility_id = @facility_id
  AND status IN ('posted', 'held')
ORDER BY posted_at, charge_id
LIMIT @row_limit;

-- name: UpdateChargeStatus :execrows
UPDATE billing.charge
SET status = @status, reason = @reason, entered_by = @entered_by,
    invoice_id = sqlc.narg('invoice_id')::uuid, version = @version
WHERE tenant_id = @tenant_id AND charge_id = @charge_id
  AND version = @expected_version AND status = @expected_status;

-- name: UpdateChargeCoverage :execrows
UPDATE billing.charge
SET package_code = @package_code, covered = @covered,
    coverage_note = @coverage_note, version = @version
WHERE tenant_id = @tenant_id AND charge_id = @charge_id
  AND version = @expected_version AND status = 'posted';

-- name: InsertConsumption :exec
INSERT INTO billing.package_consumption (
    consumption_id, tenant_id, account_id, package_code, charge_id,
    service_code, quantity, outcome, explanation,
    price_minor, currency, recorded_at
) VALUES (
    @consumption_id, @tenant_id, @account_id, @package_code, @charge_id,
    @service_code, @quantity, @outcome, @explanation,
    @price_minor, @currency, @recorded_at
)
ON CONFLICT DO NOTHING;

-- name: ListConsumption :many
SELECT * FROM billing.package_consumption
WHERE tenant_id = @tenant_id AND account_id = @account_id
ORDER BY recorded_at, consumption_id;

-- name: InsertInvoice :exec
INSERT INTO billing.invoice (
    invoice_id, tenant_id, number, kind, status,
    account_id, patient_id, encounter_id, facility_id,
    document_version, superseded_by, corrects_invoice_id,
    subtotal_minor, discount_minor, tax_minor, total_minor, currency,
    discounts, liability, payer_id, customer_id, notes,
    issued_by, issued_at, created_by, created_at, updated_at, row_version
) VALUES (
    @invoice_id, @tenant_id, @number, @kind, @status,
    @account_id, @patient_id, @encounter_id, @facility_id,
    @document_version, NULL, sqlc.narg('corrects_invoice_id')::uuid,
    @subtotal_minor, @discount_minor, @tax_minor, @total_minor, @currency,
    @discounts, @liability, @payer_id, @customer_id, @notes,
    @issued_by, sqlc.narg('issued_at')::timestamptz,
    @created_by, @created_at, @updated_at, @row_version
);

-- name: InsertInvoiceLine :exec
INSERT INTO billing.invoice_line (
    tenant_id, invoice_id, sequence, charge_id,
    service_code, description, department, quantity, unit_price_minor,
    net_minor, tax_code, tax_rate_bp, tax_minor, discount_minor, total_minor,
    currency, package_code, coverage_note
) VALUES (
    @tenant_id, @invoice_id, @sequence, sqlc.narg('charge_id')::uuid,
    @service_code, @description, @department, @quantity, @unit_price_minor,
    @net_minor, @tax_code, @tax_rate_bp, @tax_minor, @discount_minor, @total_minor,
    @currency, @package_code, @coverage_note
);

-- name: GetInvoice :one
SELECT * FROM billing.invoice
WHERE tenant_id = @tenant_id AND invoice_id = @invoice_id;

-- name: ListInvoiceLines :many
SELECT * FROM billing.invoice_line
WHERE tenant_id = @tenant_id AND invoice_id = @invoice_id
ORDER BY sequence;

-- name: ListInvoicesForAccount :many
SELECT * FROM billing.invoice
WHERE tenant_id = @tenant_id AND account_id = @account_id
ORDER BY created_at DESC, number DESC
LIMIT @row_limit;

-- name: ListDraftInvoices :many
SELECT * FROM billing.invoice
WHERE tenant_id = @tenant_id AND account_id = @account_id AND status = 'draft'
ORDER BY created_at;

-- name: SupersedeInvoice :execrows
-- The only update an unissued document takes, and it applies to estimates and
-- interim bills alone. There is deliberately no statement here that edits an
-- issued invoice's totals or lines (SRS-BIL-010).
UPDATE billing.invoice
SET status = 'superseded', superseded_by = @superseded_by,
    updated_at = @updated_at, row_version = @row_version
WHERE tenant_id = @tenant_id AND invoice_id = @invoice_id
  AND row_version = @expected_version
  AND kind IN ('estimate', 'interim')
  AND status IN ('draft', 'issued');

-- name: IssueInvoice :execrows
-- Guarded on the document still being a draft, so an invoice cannot be issued
-- twice and cannot be issued after it has been superseded.
UPDATE billing.invoice
SET status = 'issued', issued_by = @issued_by, issued_at = @issued_at,
    subtotal_minor = @subtotal_minor, discount_minor = @discount_minor,
    tax_minor = @tax_minor, total_minor = @total_minor,
    discounts = @discounts, liability = @liability,
    updated_at = @updated_at, row_version = @row_version
WHERE tenant_id = @tenant_id AND invoice_id = @invoice_id
  AND row_version = @expected_version AND status = 'draft';

-- name: InsertLedgerEntry :exec
-- The only write against the ledger. There is no update and no delete: a
-- correction is another entry, and the balance is the sum of what is there.
INSERT INTO billing.ledger_entry (
    entry_id, tenant_id, account_id, patient_id, encounter_id, facility_id,
    kind, amount_minor, currency,
    invoice_id, payment_id, refund_of_payment_id,
    method, provider_ref, receipt_number, shift_id, idempotency_key,
    reason, recorded_by, approved_by, occurred_at, recorded_at
) VALUES (
    @entry_id, @tenant_id, @account_id, @patient_id, @encounter_id, @facility_id,
    @kind, @amount_minor, @currency,
    sqlc.narg('invoice_id')::uuid, sqlc.narg('payment_id')::uuid,
    sqlc.narg('refund_of_payment_id')::uuid,
    @method, @provider_ref, @receipt_number, sqlc.narg('shift_id')::uuid,
    @idempotency_key,
    @reason, @recorded_by, @approved_by, @occurred_at, @recorded_at
)
-- SRS-BIL-008's "payment event idempotent". A retried submission inserts
-- nothing and the caller reads the zero row count as "already received".
ON CONFLICT DO NOTHING;

-- name: ListLedgerEntries :many
SELECT * FROM billing.ledger_entry
WHERE tenant_id = @tenant_id AND account_id = @account_id
ORDER BY occurred_at, entry_id;

-- name: GetLedgerEntryByIdempotencyKey :one
SELECT * FROM billing.ledger_entry
WHERE tenant_id = @tenant_id AND account_id = @account_id
  AND idempotency_key = @idempotency_key;

-- name: ListShiftEntries :many
SELECT * FROM billing.ledger_entry
WHERE tenant_id = @tenant_id AND shift_id = @shift_id
ORDER BY occurred_at, entry_id;

-- name: InsertShift :exec
INSERT INTO billing.cashier_shift (
    shift_id, tenant_id, facility_id, counter_id, cashier_id,
    opening_float_minor, currency, opened_at, status, version
) VALUES (
    @shift_id, @tenant_id, @facility_id, @counter_id, @cashier_id,
    @opening_float_minor, @currency, @opened_at, 'open', @version
);

-- name: GetShift :one
SELECT * FROM billing.cashier_shift
WHERE tenant_id = @tenant_id AND shift_id = @shift_id;

-- name: GetOpenShift :one
SELECT * FROM billing.cashier_shift
WHERE tenant_id = @tenant_id AND facility_id = @facility_id
  AND counter_id = @counter_id AND status = 'open';

-- name: CloseShift :execrows
UPDATE billing.cashier_shift
SET counted_minor = @counted_minor, expected_minor = @expected_minor,
    variance_minor = @variance_minor, variance_reason = @variance_reason,
    status = @status, closed_at = @closed_at, version = @version
WHERE tenant_id = @tenant_id AND shift_id = @shift_id
  AND version = @expected_version AND status = 'open';

-- name: ApproveShift :execrows
UPDATE billing.cashier_shift
SET status = 'reconciled', approved_by = @approved_by, approved_at = @approved_at,
    version = @version
WHERE tenant_id = @tenant_id AND shift_id = @shift_id
  AND version = @expected_version AND status = 'pending_approval';

-- name: ListShifts :many
SELECT * FROM billing.cashier_shift
WHERE tenant_id = @tenant_id AND facility_id = @facility_id
ORDER BY opened_at DESC
LIMIT @row_limit;

-- name: SetBillingPolicy :exec
INSERT INTO billing.policy (
    tenant_id, discount_limits, close_checks, allow_payer_balance,
    variance_threshold_minor, currency, updated_by, updated_at
) VALUES (
    @tenant_id, @discount_limits, @close_checks::text[], @allow_payer_balance,
    @variance_threshold_minor, @currency, @updated_by, @updated_at
)
ON CONFLICT (tenant_id)
DO UPDATE SET
    discount_limits = EXCLUDED.discount_limits,
    close_checks = EXCLUDED.close_checks,
    allow_payer_balance = EXCLUDED.allow_payer_balance,
    variance_threshold_minor = EXCLUDED.variance_threshold_minor,
    currency = EXCLUDED.currency,
    updated_by = EXCLUDED.updated_by,
    updated_at = EXCLUDED.updated_at;

-- name: GetBillingPolicy :one
SELECT * FROM billing.policy WHERE tenant_id = @tenant_id;
