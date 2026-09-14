-- 0025 Billing, tariffs and patient revenue: the charge master, tariff
-- contracts, packages, charges, invoices, the account ledger and cashier shifts
-- (SRS-BIL).
--
-- Three shapes carry the weight, and all three are about the same thing: a
-- financial record has to still say the same thing in five years.
--
-- Money is bigint minor units with the currency beside it, never numeric and
-- never float. A float cannot represent 0.10 exactly, so a hundred lines summed
-- as floats do not equal the invoice total — and an invoice that does not add up
-- is one a patient is right to dispute. Minor units because that is the
-- smallest amount that can actually be paid.
--
-- The account ledger is append-only and the balance is its sum. SRS-BIL-012
-- says "balance derives from ledger and reconciles", and the alternative — a
-- balance column every writer keeps in step — drifts the first time one of them
-- fails between its two writes, with nothing to reconcile against because the
-- ledger was never the truth. There is deliberately no UPDATE and no DELETE
-- against billing.ledger_entry anywhere in db/queries.
--
-- A finalised invoice is immutable, and its lines are a snapshot rather than a
-- join. The patient is holding a copy of it, and a system that can quietly
-- change what a document said is a system whose documents prove nothing. A
-- correction is a credit or debit note that references the original, which is
-- what every finance department already does and what every auditor expects to
-- find.
--
-- Effective dating is on the charge master, the tariffs and the packages, with
-- an exclusion constraint so exactly one version of a code is in force at a
-- time. SRS-BIL-001's acceptance is explicit — "historical invoice resolves
-- service version active at charge time" — and a price list edited in April must
-- not change what a March invoice says it charged for.
--
-- Trace: SRS-BIL-001 (charge master), SRS-BIL-002 (tariffs), SRS-BIL-003
--   (charge provenance and idempotency), SRS-BIL-004 (packages), SRS-BIL-005
--   (estimates), SRS-BIL-006 (invoices), SRS-BIL-007 (discounts), SRS-BIL-008
--   (payments), SRS-BIL-009 (refunds), SRS-BIL-010 (no destructive edit),
--   SRS-BIL-011 (revenue integrity), SRS-BIL-012 (deposits and ledger),
--   SRS-BIL-013 (account close), SRS-BIL-014 (split liability), SRS-BIL-015
--   (cashier shifts), SRS-BIL-016 (events).
-- Rollback: drops the whole schema. Every invoice, receipt and ledger entry
--   goes with it, and a hospital's books are not reconstructable from the
--   clinical record. Export before dropping and treat a rollback here as a
--   disaster-recovery event with the finance department in the room.
-- Reconciliation: none for the forward direction; the schema is new.

CREATE SCHEMA IF NOT EXISTS billing;

-- btree_gist lets an exclusion constraint mix equality on the code with overlap
-- on the date range, which is what "exactly one version in force at a time"
-- needs.
CREATE EXTENSION IF NOT EXISTS btree_gist;

-- One billable thing, versioned by its effective window (SRS-BIL-001).
CREATE TABLE billing.service_item (
    tenant_id       uuid        NOT NULL,
    -- Stable across versions. Two rows with one code and different windows are
    -- two versions of one service.
    code            text        NOT NULL CHECK (code <> ''),
    description     text        NOT NULL CHECK (description <> ''),
    -- Radiology's income is not the ward's, and a service with no department is
    -- income nobody is accountable for.
    department      text        NOT NULL CHECK (department <> ''),
    revenue_account text        NOT NULL CHECK (revenue_account <> ''),
    tax_code        text        NOT NULL DEFAULT '',
    -- Hundredths of a percent. Integer for the same reason money is: a rate
    -- held as a float produces a different total depending on the order the
    -- lines were summed in.
    tax_rate_bp     integer     NOT NULL DEFAULT 0
                        CHECK (tax_rate_bp BETWEEN 0 AND 10000),
    -- Whether the tariff price already contains the tax. Stated rather than
    -- assumed: both conventions coexist in one hospital, and guessing produces
    -- an invoice wrong by the tax on every line.
    tax_inclusive   boolean     NOT NULL DEFAULT false,

    effective_from  timestamptz NOT NULL,
    effective_to    timestamptz,
    updated_by      text        NOT NULL CHECK (updated_by <> ''),
    updated_at      timestamptz NOT NULL,

    CONSTRAINT service_version_ends_after_it_begins CHECK (
        effective_to IS NULL OR effective_to > effective_from),
    -- Exactly one version of a code in force at a time, so resolution is
    -- deterministic rather than "whichever row the planner reached first".
    CONSTRAINT service_versions_do_not_overlap EXCLUDE USING gist (
        tenant_id WITH =, code WITH =,
        tstzrange(effective_from, effective_to) WITH &&)
);

CREATE INDEX service_item_by_code ON billing.service_item (tenant_id, code);

-- A negotiated price (SRS-BIL-002).
CREATE TABLE billing.tariff_line (
    tariff_line_id  uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    contract_id     text        NOT NULL CHECK (contract_id <> ''),
    name            text        NOT NULL CHECK (name <> ''),

    -- The five axes. Empty means "any", which is how a standard list price is
    -- expressed; a named axis must match exactly, which is how an insurer's
    -- contract never prices a self-paying patient.
    payer_id        text        NOT NULL DEFAULT '',
    customer_id     text        NOT NULL DEFAULT '',
    facility_id     text        NOT NULL DEFAULT '',
    room_class      text        NOT NULL DEFAULT '',
    service_code    text        NOT NULL DEFAULT '',

    price_minor     bigint      NOT NULL CHECK (price_minor >= 0),
    currency        text        NOT NULL CHECK (currency ~ '^[A-Za-z]{3}$'),
    -- Breaks a tie between contracts of equal specificity. Explicit rather than
    -- "most recently created", because a resolution that depends on insertion
    -- order changes when data is migrated.
    priority        integer     NOT NULL DEFAULT 0,

    effective_from  timestamptz NOT NULL,
    effective_to    timestamptz,
    updated_by      text        NOT NULL CHECK (updated_by <> ''),
    updated_at      timestamptz NOT NULL,

    CONSTRAINT tariff_ends_after_it_begins CHECK (
        effective_to IS NULL OR effective_to > effective_from)
);

CREATE INDEX tariff_line_lookup
    ON billing.tariff_line (tenant_id, service_code, effective_from DESC);
CREATE INDEX tariff_line_by_contract
    ON billing.tariff_line (tenant_id, contract_id);

-- A bundle at a fixed price (SRS-BIL-004).
CREATE TABLE billing.package (
    tenant_id       uuid        NOT NULL,
    code            text        NOT NULL CHECK (code <> ''),
    name            text        NOT NULL CHECK (name <> ''),
    price_minor     bigint      NOT NULL CHECK (price_minor >= 0),
    currency        text        NOT NULL CHECK (currency ~ '^[A-Za-z]{3}$'),
    room_class      text        NOT NULL DEFAULT '',

    -- Inclusions, exclusions and carve-outs as JSON, because their shapes
    -- differ and each is read as a whole: a package is loaded to price one
    -- charge and never queried by its individual terms.
    inclusions      jsonb       NOT NULL DEFAULT '[]'::jsonb,
    exclusions      jsonb       NOT NULL DEFAULT '[]'::jsonb,
    carve_outs      jsonb       NOT NULL DEFAULT '[]'::jsonb,

    effective_from  timestamptz NOT NULL,
    effective_to    timestamptz,
    updated_by      text        NOT NULL CHECK (updated_by <> ''),
    updated_at      timestamptz NOT NULL,

    CONSTRAINT package_ends_after_it_begins CHECK (
        effective_to IS NULL OR effective_to > effective_from),
    CONSTRAINT package_versions_do_not_overlap EXCLUDE USING gist (
        tenant_id WITH =, code WITH =,
        tstzrange(effective_from, effective_to) WITH &&)
);

-- An encounter's financial account (SRS-BIL-013).
CREATE TABLE billing.account (
    account_id      uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    patient_id      uuid        NOT NULL,
    encounter_id    uuid        NOT NULL,
    facility_id     uuid        NOT NULL,
    currency        text        NOT NULL CHECK (currency ~ '^[A-Za-z]{3}$'),

    payer_id        text        NOT NULL DEFAULT '',
    customer_id     text        NOT NULL DEFAULT '',
    room_class      text        NOT NULL DEFAULT '',
    package_code    text        NOT NULL DEFAULT '',

    status          text        NOT NULL CHECK (status IN ('open', 'closed')),
    closed_by       text        NOT NULL DEFAULT '',
    closed_at       timestamptz,

    created_at      timestamptz NOT NULL,
    updated_at      timestamptz NOT NULL,
    version         bigint      NOT NULL CHECK (version > 0),

    CONSTRAINT closure_is_whole CHECK (
        (status = 'open' AND closed_by = '' AND closed_at IS NULL) OR
        (status = 'closed' AND closed_by <> '' AND closed_at IS NOT NULL))
);

-- One financial account per encounter. Two would mean a patient's bill is in
-- two places and neither total is the answer.
CREATE UNIQUE INDEX account_one_per_encounter
    ON billing.account (tenant_id, encounter_id);
CREATE INDEX account_by_patient ON billing.account (tenant_id, patient_id);

-- One billable item (SRS-BIL-003).
CREATE TABLE billing.charge (
    charge_id       uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    account_id      uuid        NOT NULL REFERENCES billing.account (account_id),
    patient_id      uuid        NOT NULL,
    encounter_id    uuid        NOT NULL,
    facility_id     uuid        NOT NULL,

    service_code    text        NOT NULL CHECK (service_code <> ''),
    -- Copied from the service version in force at charge time, so a master
    -- edited afterwards does not restate what was charged (SRS-BIL-001).
    description     text        NOT NULL CHECK (description <> ''),
    department      text        NOT NULL DEFAULT '',
    revenue_account text        NOT NULL DEFAULT '',

    quantity        integer     NOT NULL CHECK (quantity > 0),
    unit_price_minor bigint     NOT NULL,
    currency        text        NOT NULL CHECK (currency ~ '^[A-Za-z]{3}$'),
    -- Which contract priced it, stored rather than recomputed: "which tariff
    -- was applied" is the first question of a payer dispute, and recomputing
    -- would answer with today's contracts.
    tariff_contract_id text     NOT NULL DEFAULT '',
    tariff_contract    text     NOT NULL DEFAULT '',

    tax_code        text        NOT NULL DEFAULT '',
    tax_rate_bp     integer     NOT NULL DEFAULT 0
                        CHECK (tax_rate_bp BETWEEN 0 AND 10000),
    tax_inclusive   boolean     NOT NULL DEFAULT false,

    origin          text        NOT NULL CHECK (origin IN (
                        'clinical_event', 'manual', 'recurring')),
    -- The context that raised it and that context's own identifier. Together
    -- they are the idempotency key.
    source_system   text        NOT NULL DEFAULT '',
    source_id       text        NOT NULL DEFAULT '',
    -- The reference a biller follows back — an order number a ward reads down a
    -- phone. SRS-BIL-011 asks the worklist to link to the source record, and an
    -- opaque identifier is not a link anybody can follow.
    source_detail   text        NOT NULL DEFAULT '',
    entered_by      text        NOT NULL DEFAULT '',
    reason          text        NOT NULL DEFAULT '',

    -- When the service was delivered, which is what the master and the tariff
    -- are resolved against. Distinct from posted_at: a charge keyed three days
    -- later is still priced at the day of care.
    occurred_at     timestamptz NOT NULL,
    posted_at       timestamptz NOT NULL,

    status          text        NOT NULL CHECK (status IN (
                        'posted', 'invoiced', 'voided', 'held')),
    package_code    text        NOT NULL DEFAULT '',
    covered         boolean     NOT NULL DEFAULT false,
    coverage_note   text        NOT NULL DEFAULT '',
    invoice_id      uuid,
    version         bigint      NOT NULL CHECK (version > 0),

    -- A manual charge is the path round every automated control, so it names
    -- who took it and why.
    CONSTRAINT a_manual_charge_is_attributable CHECK (
        origin <> 'manual' OR (entered_by <> '' AND reason <> '')),
    -- An automatic charge without a source has an empty idempotency key, and
    -- two deliveries of one event would become two charges.
    CONSTRAINT an_automatic_charge_has_a_source CHECK (
        origin = 'manual' OR (source_system <> '' AND source_id <> '')),
    CONSTRAINT an_invoiced_charge_names_its_invoice CHECK (
        status <> 'invoiced' OR invoice_id IS NOT NULL)
);

-- SRS-BIL-003's "cannot be silently duplicated", held at the table rather than
-- by a check: a bus redelivery and a retried RPC can be in flight at the same
-- moment, and a check-then-insert lets both through.
CREATE UNIQUE INDEX charge_one_per_source
    ON billing.charge (tenant_id, source_system, source_id)
    WHERE source_system <> '' AND source_id <> '' AND status <> 'voided';

CREATE INDEX charge_by_account ON billing.charge (tenant_id, account_id, occurred_at);
-- The revenue-integrity worklist (SRS-BIL-011): what has not reached a bill.
CREATE INDEX charge_unbilled
    ON billing.charge (tenant_id, facility_id, posted_at)
    WHERE status IN ('posted', 'held');

-- What a package did with each charge (SRS-BIL-004).
CREATE TABLE billing.package_consumption (
    consumption_id  uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    account_id      uuid        NOT NULL REFERENCES billing.account (account_id),
    package_code    text        NOT NULL CHECK (package_code <> ''),
    charge_id       uuid        NOT NULL REFERENCES billing.charge (charge_id),
    service_code    text        NOT NULL CHECK (service_code <> ''),
    quantity        integer     NOT NULL CHECK (quantity > 0),
    outcome         text        NOT NULL CHECK (outcome IN (
                        'included', 'over_cap', 'excluded', 'carve_out',
                        'outside_package')),
    -- The sentence at the discharge desk. Stored rather than derived at display
    -- time, because the package may have been superseded by the time somebody
    -- asks.
    explanation     text        NOT NULL CHECK (explanation <> ''),
    price_minor     bigint      NOT NULL DEFAULT 0,
    currency        text        NOT NULL DEFAULT '',
    recorded_at     timestamptz NOT NULL
);

-- One entry per charge: a charge counted twice against a cap would consume the
-- package twice as fast.
CREATE UNIQUE INDEX consumption_one_per_charge
    ON billing.package_consumption (tenant_id, charge_id);
CREATE INDEX consumption_by_account
    ON billing.package_consumption (tenant_id, account_id, recorded_at);

-- A financial document (SRS-BIL-005, SRS-BIL-006, SRS-BIL-010).
CREATE TABLE billing.invoice (
    invoice_id      uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    -- What the patient quotes. From the platform's numbering sequence, so it is
    -- gapless and collision-free.
    number          text        NOT NULL CHECK (number <> ''),
    kind            text        NOT NULL CHECK (kind IN (
                        'estimate', 'interim', 'final', 'credit_note', 'debit_note')),
    status          text        NOT NULL CHECK (status IN (
                        'draft', 'issued', 'superseded', 'cancelled')),

    account_id      uuid        NOT NULL REFERENCES billing.account (account_id),
    patient_id      uuid        NOT NULL,
    encounter_id    uuid        NOT NULL,
    facility_id     uuid        NOT NULL,

    -- SRS-BIL-005's "versioned": an estimate re-quoted after the plan changes is
    -- a new version, and the patient was shown the old one.
    document_version integer    NOT NULL DEFAULT 1 CHECK (document_version > 0),
    superseded_by   uuid,
    -- The document a credit or debit note corrects (SRS-BIL-010).
    corrects_invoice_id uuid,

    subtotal_minor  bigint      NOT NULL DEFAULT 0,
    discount_minor  bigint      NOT NULL DEFAULT 0 CHECK (discount_minor >= 0),
    tax_minor       bigint      NOT NULL DEFAULT 0,
    total_minor     bigint      NOT NULL DEFAULT 0,
    currency        text        NOT NULL CHECK (currency ~ '^[A-Za-z]{3}$'),

    -- Discounts and the liability split as JSON: both are read only with the
    -- document they belong to, and neither is queried by its parts.
    discounts       jsonb       NOT NULL DEFAULT '[]'::jsonb,
    liability       jsonb       NOT NULL DEFAULT '[]'::jsonb,

    payer_id        text        NOT NULL DEFAULT '',
    customer_id     text        NOT NULL DEFAULT '',
    notes           text        NOT NULL DEFAULT '',

    issued_by       text        NOT NULL DEFAULT '',
    issued_at       timestamptz,
    created_by      text        NOT NULL CHECK (created_by <> ''),
    created_at      timestamptz NOT NULL,
    updated_at      timestamptz NOT NULL,
    row_version     bigint      NOT NULL CHECK (row_version > 0),

    CONSTRAINT issue_is_whole CHECK (
        (status <> 'issued') OR (issued_by <> '' AND issued_at IS NOT NULL)),
    -- A discount larger than the bill would produce a negative invoice, which
    -- is a refund wearing the wrong document's name.
    CONSTRAINT a_discount_is_not_more_than_the_bill CHECK (
        discount_minor <= GREATEST(subtotal_minor, 0)),
    -- A correction names what it corrects, and nothing else does.
    CONSTRAINT only_a_note_corrects CHECK (
        (kind IN ('credit_note', 'debit_note')) OR corrects_invoice_id IS NULL)
);

CREATE UNIQUE INDEX invoice_number_unique ON billing.invoice (tenant_id, number);
CREATE INDEX invoice_by_account
    ON billing.invoice (tenant_id, account_id, created_at DESC);
-- The draft worklist, and SRS-BIL-013's close check.
CREATE INDEX invoice_drafts
    ON billing.invoice (tenant_id, account_id) WHERE status = 'draft';

-- One line of a document (SRS-BIL-006).
--
-- A snapshot, not a reference. Every value a reader needs is copied on at issue
-- time, so the document says the same thing in five years whatever has happened
-- to the charge master, the tariff or the charge.
CREATE TABLE billing.invoice_line (
    tenant_id       uuid        NOT NULL,
    invoice_id      uuid        NOT NULL
                        REFERENCES billing.invoice (invoice_id) ON DELETE CASCADE,
    sequence        integer     NOT NULL CHECK (sequence >= 1),

    -- Points back for audit. The line does not depend on it.
    charge_id       uuid,
    service_code    text        NOT NULL DEFAULT '',
    description     text        NOT NULL CHECK (description <> ''),
    department      text        NOT NULL DEFAULT '',
    quantity        integer     NOT NULL CHECK (quantity > 0),
    unit_price_minor bigint     NOT NULL,
    -- Stored rather than computed on read, which is what "calculation details"
    -- means: a rounding rule changed in a future release must not change what
    -- this document says.
    net_minor       bigint      NOT NULL,
    tax_code        text        NOT NULL DEFAULT '',
    tax_rate_bp     integer     NOT NULL DEFAULT 0,
    tax_minor       bigint      NOT NULL DEFAULT 0,
    discount_minor  bigint      NOT NULL DEFAULT 0,
    total_minor     bigint      NOT NULL,
    currency        text        NOT NULL CHECK (currency ~ '^[A-Za-z]{3}$'),
    package_code    text        NOT NULL DEFAULT '',
    coverage_note   text        NOT NULL DEFAULT '',

    PRIMARY KEY (tenant_id, invoice_id, sequence),
    CONSTRAINT a_line_adds_up CHECK (
        total_minor = net_minor + tax_minor - discount_minor)
);

-- One movement on an account (SRS-BIL-008, SRS-BIL-009, SRS-BIL-012).
--
-- Append-only. There is no UPDATE and no DELETE against this table anywhere in
-- db/queries, and a correction is another entry.
CREATE TABLE billing.ledger_entry (
    entry_id        uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    account_id      uuid        NOT NULL REFERENCES billing.account (account_id),
    patient_id      uuid        NOT NULL,
    encounter_id    uuid        NOT NULL,
    facility_id     uuid        NOT NULL,

    kind            text        NOT NULL CHECK (kind IN (
                        'invoice', 'payment', 'refund', 'deposit',
                        'deposit_applied', 'write_off', 'adjustment')),
    -- Signed: positive increases what the patient owes. A direction flag would
    -- be a thing every sum has to remember to consult, and the one that forgets
    -- reports a balance twice the truth.
    amount_minor    bigint      NOT NULL CHECK (amount_minor <> 0),
    currency        text        NOT NULL CHECK (currency ~ '^[A-Za-z]{3}$'),

    invoice_id      uuid,
    payment_id      uuid,
    refund_of_payment_id uuid,

    method          text        NOT NULL DEFAULT '' CHECK (method IN (
                        '', 'cash', 'card', 'upi', 'bank_transfer', 'cheque',
                        'payer_settlement')),
    -- The gateway's or bank's own identifier — the thing a reconciliation is
    -- done against. Deliberately not a card number or any other secret
    -- (SRS-BIL-016).
    provider_ref    text        NOT NULL DEFAULT '',
    receipt_number  text        NOT NULL DEFAULT '',
    shift_id        uuid,

    -- Makes a retried payment one payment (SRS-BIL-008). Unique per account at
    -- the table, because two submissions can be in flight at the same moment.
    idempotency_key text        NOT NULL DEFAULT '',

    reason          text        NOT NULL DEFAULT '',
    recorded_by     text        NOT NULL CHECK (recorded_by <> ''),
    approved_by     text        NOT NULL DEFAULT '',
    occurred_at     timestamptz NOT NULL,
    recorded_at     timestamptz NOT NULL,

    -- Money in reduces what is owed; a payment the other way round would double
    -- the balance rather than clear it.
    CONSTRAINT money_in_reduces_the_balance CHECK (
        kind NOT IN ('payment', 'deposit') OR amount_minor < 0),
    -- A refund names the payment it reverses and carries an authorisation
    -- (SRS-BIL-009).
    CONSTRAINT a_refund_names_its_original CHECK (
        kind <> 'refund' OR (refund_of_payment_id IS NOT NULL
                             AND approved_by <> '' AND amount_minor > 0)),
    CONSTRAINT a_write_off_is_authorised CHECK (
        kind <> 'write_off' OR (approved_by <> '' AND reason <> '')),
    CONSTRAINT an_adjustment_has_a_reason CHECK (
        kind <> 'adjustment' OR reason <> ''),
    -- Cash has no reference; everything else does, and without it the bank
    -- statement cannot be reconciled against the ledger.
    CONSTRAINT a_non_cash_payment_is_referenced CHECK (
        kind NOT IN ('payment', 'deposit') OR method = 'cash' OR provider_ref <> '')
);

CREATE INDEX ledger_by_account
    ON billing.ledger_entry (tenant_id, account_id, occurred_at, entry_id);
CREATE UNIQUE INDEX ledger_idempotency
    ON billing.ledger_entry (tenant_id, account_id, idempotency_key)
    WHERE idempotency_key <> '';
CREATE UNIQUE INDEX receipt_number_unique
    ON billing.ledger_entry (tenant_id, receipt_number)
    WHERE receipt_number <> '';
-- The drawer a shift reconciles (SRS-BIL-015).
CREATE INDEX ledger_by_shift
    ON billing.ledger_entry (tenant_id, shift_id) WHERE shift_id IS NOT NULL;

-- One cashier's session at one drawer (SRS-BIL-015).
CREATE TABLE billing.cashier_shift (
    shift_id        uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    facility_id     uuid        NOT NULL,
    counter_id      text        NOT NULL CHECK (counter_id <> ''),
    cashier_id      text        NOT NULL CHECK (cashier_id <> ''),

    opening_float_minor bigint  NOT NULL CHECK (opening_float_minor >= 0),
    currency        text        NOT NULL CHECK (currency ~ '^[A-Za-z]{3}$'),
    opened_at       timestamptz NOT NULL,

    counted_minor   bigint,
    -- Computed from the ledger rather than typed, so a cashier cannot make the
    -- count agree by adjusting the expectation.
    expected_minor  bigint,
    variance_minor  bigint,
    variance_reason text        NOT NULL DEFAULT '',

    status          text        NOT NULL CHECK (status IN (
                        'open', 'reconciled', 'pending_approval')),
    approved_by     text        NOT NULL DEFAULT '',
    approved_at     timestamptz,
    closed_at       timestamptz,
    version         bigint      NOT NULL CHECK (version > 0),

    -- Any variance needs a reason, not only a large one: a drawer short by ten
    -- rupees every day is a pattern nobody sees if it never has to be
    -- explained.
    CONSTRAINT a_variance_is_explained CHECK (
        status = 'open' OR variance_minor = 0 OR variance_reason <> ''),
    -- A cashier approving their own variance is the control absent with a
    -- record saying it happened.
    CONSTRAINT a_cashier_does_not_approve_themselves CHECK (
        approved_by = '' OR lower(approved_by) <> lower(cashier_id)),
    CONSTRAINT approval_is_whole CHECK (
        (approved_by = '' AND approved_at IS NULL) OR
        (approved_by <> '' AND approved_at IS NOT NULL))
);

-- One open shift per counter. Two cashiers at one drawer is how a variance
-- becomes unattributable.
CREATE UNIQUE INDEX shift_one_open_per_counter
    ON billing.cashier_shift (tenant_id, facility_id, counter_id)
    WHERE status = 'open';
CREATE INDEX shift_by_cashier
    ON billing.cashier_shift (tenant_id, cashier_id, opened_at DESC);

-- The tenant's billing policy (SRS-BIL-007, SRS-BIL-013, SRS-BIL-015).
CREATE TABLE billing.policy (
    tenant_id       uuid        PRIMARY KEY,
    -- Discount limits per role, as JSON: the shape is a map from role to two
    -- bounds, and a column per role would need a migration for every new one.
    discount_limits jsonb       NOT NULL DEFAULT '{}'::jsonb,
    close_checks    text[]      NOT NULL DEFAULT '{}',
    -- An insurer's ninety-day settlement is not a reason to keep a discharged
    -- patient's account open (SRS-BIL-013, SRS-BIL-014).
    allow_payer_balance boolean NOT NULL DEFAULT true,
    variance_threshold_minor bigint NOT NULL DEFAULT 100
                        CHECK (variance_threshold_minor >= 0),
    currency        text        NOT NULL DEFAULT 'INR'
                        CHECK (currency ~ '^[A-Za-z]{3}$'),
    updated_by      text        NOT NULL CHECK (updated_by <> ''),
    updated_at      timestamptz NOT NULL
);
