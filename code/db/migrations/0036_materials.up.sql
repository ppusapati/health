-- 0036 Materials, procurement and inventory (SRS-MAT-001 … 016).
--
-- Six shapes here are unusual and deliberate.
--
-- The stock ledger is double-entry and append-only. A movement names a source
-- bucket and a destination bucket, where a bucket is a location and a status,
-- and a CHECK requires at least one of them to be inside the hospital and the
-- two to differ. There is no on-hand column anywhere: SRS-MAT-007's acceptance
-- is that on-hand is derivable from immutable movements, and a maintained
-- total is a second answer that will eventually disagree with the first. The
-- balances a query reads come from a view over this table.
--
-- In-transit is a stock status rather than a flag on a transfer, so a transfer
-- is two movements through a third bucket. SRS-MAT-010 asks that source and
-- destination balances reconcile; written this way they reconcile at every
-- moment rather than only once the transfer closes, and a carton that never
-- arrives stays visible in transit instead of vanishing from both stores.
--
-- Purchase orders are versioned rather than updated, with a partial unique
-- index holding "at most one live revision per order chain". A supplier
-- delivers against the revision they were sent: a quantity changed in place
-- makes a correct delivery look short with nothing to show who was right.
--
-- The approval chain is its own append-only table with a unique (requisition,
-- level). SRS-MAT-002's acceptance is that approval history is immutable, and
-- an approval that can be updated is indistinguishable from one never given.
-- There is no update or delete path to it.
--
-- A count's expected quantity is stored on the line rather than recomputed at
-- approval. Recomputing would compare the shelf against a balance that has
-- moved since the counter walked it, and the variance would be somebody else's
-- issue.
--
-- Consignment ownership lives on the lot, with a CHECK that consignment stock
-- names the supplier that owns it. Stock nobody owns cannot raise the
-- liability its consumption is supposed to raise (SRS-MAT-016).
--
-- Trace: SRS-MAT-001 … SRS-MAT-016.
--
-- Rollback: drops the schema. Every item, supplier, order, receipt, stock
-- movement, count and liability goes with it. The movement table is the only
-- record of what the hospital holds — there is no balance to fall back on —
-- so treat this as a disaster-recovery action, never a deployment step.
--
-- Reconciliation: the tables are new, so the previous version writes nothing
-- here and sees nothing missing. The direction to watch is consumption: the
-- theatre records what it used (SRS-OT-010) and the pharmacy dispenses
-- (SRS-MED-011), neither of which decrements this ledger yet. That seam is
-- named in the status document rather than half-wired here.

CREATE SCHEMA IF NOT EXISTS materials;

CREATE TABLE materials.item (
    item_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    code     text NOT NULL CHECK (code <> ''),
    display  text NOT NULL DEFAULT '',
    category text NOT NULL DEFAULT '',
    -- One unit throughout the ledger. Purchasing in boxes and issuing in
    -- pieces is real, so the conversion is a pack size on the order line
    -- rather than an implication here.
    uom text NOT NULL CHECK (uom <> ''),

    tracking text NOT NULL CHECK (tracking IN ('quantity', 'batch', 'serial')),
    policy   text NOT NULL CHECK (policy IN ('fefo', 'fifo', 'serial')),

    perishable         boolean NOT NULL DEFAULT false,
    inspect_on_receipt boolean NOT NULL DEFAULT false,
    consignable        boolean NOT NULL DEFAULT false,
    active             boolean NOT NULL DEFAULT true,

    created_at timestamptz NOT NULL,
    created_by text        NOT NULL CHECK (created_by <> ''),
    version    bigint      NOT NULL DEFAULT 1,

    -- An expiry belongs to a lot. An item counted in bulk has no lot to hang
    -- one on, so "perishable" there would be a promise nothing could keep.
    CONSTRAINT a_perishable_item_is_tracked CHECK (
        NOT perishable OR tracking <> 'quantity'
    ),
    -- Earliest-received-first on an expiring item throws away stock that was
    -- in date while somebody used a newer box.
    CONSTRAINT a_perishable_item_is_picked_by_expiry CHECK (
        NOT perishable OR policy <> 'fifo'
    )
);

CREATE UNIQUE INDEX item_code_idx ON materials.item (tenant_id, code);
CREATE INDEX item_category_idx ON materials.item (tenant_id, category);

CREATE TABLE materials.supplier (
    supplier_id uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,

    code    text NOT NULL CHECK (code <> ''),
    display text NOT NULL CHECK (display <> ''),
    -- Gates who may be quoted and who may be ordered from. An unapproved
    -- supplier is not one a hospital buys from, which is what SRS-MAT-003's
    -- "approved suppliers" means when it is enforced rather than assumed.
    approved boolean NOT NULL DEFAULT false,

    contact_email      text   NOT NULL DEFAULT '',
    contact_phone      text   NOT NULL DEFAULT '',
    payment_terms_days integer NOT NULL DEFAULT 0,
    currency           text   NOT NULL DEFAULT 'INR',

    created_at timestamptz NOT NULL,
    created_by text        NOT NULL CHECK (created_by <> ''),
    version    bigint      NOT NULL DEFAULT 1
);

CREATE UNIQUE INDEX supplier_code_idx ON materials.supplier (tenant_id, code);

CREATE TABLE materials.lot (
    lot_id    uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,
    item_id   uuid NOT NULL REFERENCES materials.item (item_id),

    -- The manufacturer's batch or the serial. Empty only for an item counted
    -- in bulk, where the lot carries ownership and the received date and no
    -- identity.
    code        text        NOT NULL DEFAULT '',
    expiry      timestamptz,
    received_at timestamptz NOT NULL,

    ownership   text NOT NULL DEFAULT 'hospital'
        CHECK (ownership IN ('hospital', 'consignment')),
    supplier_id uuid REFERENCES materials.supplier (supplier_id),

    blocked        boolean     NOT NULL DEFAULT false,
    blocked_reason text        NOT NULL DEFAULT '',
    blocked_at     timestamptz,
    blocked_by     text        NOT NULL DEFAULT '',

    created_at timestamptz NOT NULL,
    version    bigint      NOT NULL DEFAULT 1,

    -- Consignment stock that names no owner cannot raise the liability its
    -- consumption is supposed to raise.
    CONSTRAINT consignment_names_its_owner CHECK (
        ownership <> 'consignment' OR supplier_id IS NOT NULL
    ),
    -- A block nobody explained is one nobody will ever be confident enough
    -- to lift.
    CONSTRAINT a_block_is_explained CHECK (
        NOT blocked OR (blocked_reason <> '' AND blocked_by <> '')
    )
);

CREATE UNIQUE INDEX lot_code_idx
    ON materials.lot (tenant_id, item_id, code)
    WHERE code <> '';
CREATE INDEX lot_item_idx ON materials.lot (tenant_id, item_id);
-- The recall worklist.
CREATE INDEX lot_blocked_idx ON materials.lot (tenant_id, blocked)
    WHERE blocked;
-- The expiry sweep.
CREATE INDEX lot_expiry_idx ON materials.lot (tenant_id, expiry)
    WHERE expiry IS NOT NULL;

-- The stock ledger (SRS-MAT-007). Append-only: no UPDATE and no DELETE path
-- exists anywhere above this, and FIT-08 holds that.
CREATE TABLE materials.movement (
    movement_id uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,

    item_id uuid NOT NULL REFERENCES materials.item (item_id),
    lot_id  uuid NOT NULL REFERENCES materials.lot (lot_id),

    -- An empty location is outside the hospital: the supplier a receipt came
    -- from, the patient a consumable went into.
    from_location text NOT NULL DEFAULT '',
    from_status   text NOT NULL DEFAULT ''
        CHECK (from_status IN ('', 'quarantine', 'available', 'in_transit', 'rejected')),
    to_location text NOT NULL DEFAULT '',
    to_status   text NOT NULL DEFAULT ''
        CHECK (to_status IN ('', 'quarantine', 'available', 'in_transit', 'rejected')),

    -- Always positive. The direction is the buckets' job; a signed quantity
    -- would give every sum two ways to be wrong.
    quantity integer NOT NULL CHECK (quantity > 0),

    kind text NOT NULL CHECK (kind IN (
        'receipt', 'accept', 'reject', 'issue', 'return',
        'transfer_out', 'transfer_in', 'adjustment', 'consumption', 'disposal')),
    reference text NOT NULL DEFAULT '',
    reason    text NOT NULL DEFAULT '',

    cost_centre  text NOT NULL DEFAULT '',
    patient_id   uuid,
    encounter_id uuid,

    occurred_at timestamptz NOT NULL,
    recorded_by text        NOT NULL CHECK (recorded_by <> ''),

    -- A location and a status travel together: a bucket with one and not the
    -- other is half an address, and every balance built on it is wrong.
    CONSTRAINT a_bucket_has_both_halves CHECK (
        (from_location = '') = (from_status = '')
        AND (to_location = '') = (to_status = '')
    ),
    -- Both sides outside changes no balance anywhere: a row that looks like
    -- stock moving and is not.
    CONSTRAINT a_movement_touches_the_hospital CHECK (
        from_location <> '' OR to_location <> ''
    ),
    -- Same bucket to same bucket nets to nothing and would let somebody
    -- record activity that never happened.
    CONSTRAINT a_movement_goes_somewhere_else CHECK (
        from_location <> to_location OR from_status <> to_status
    )
);

CREATE INDEX movement_item_idx
    ON materials.movement (tenant_id, item_id, occurred_at DESC);
CREATE INDEX movement_lot_idx
    ON materials.movement (tenant_id, lot_id, occurred_at DESC);
CREATE INDEX movement_reference_idx
    ON materials.movement (tenant_id, reference) WHERE reference <> '';
-- The recall path: which patients did this lot reach.
CREATE INDEX movement_patient_idx
    ON materials.movement (tenant_id, patient_id) WHERE patient_id IS NOT NULL;

-- On-hand, derived (SRS-MAT-007).
--
-- A view rather than a table, so there is exactly one answer to "what do we
-- hold". Every arrival counts positive against its bucket and every departure
-- negative against its own, and a bucket that nets to zero does not appear: a
-- bucket that emptied is not a bucket holding nothing.
CREATE VIEW materials.balance AS
SELECT tenant_id, item_id, lot_id, location_id, status, SUM(quantity) AS quantity
FROM (
    SELECT tenant_id, item_id, lot_id,
           to_location AS location_id, to_status AS status, quantity
    FROM materials.movement
    WHERE to_location <> ''
    UNION ALL
    SELECT tenant_id, item_id, lot_id,
           from_location AS location_id, from_status AS status, -quantity
    FROM materials.movement
    WHERE from_location <> ''
) AS entries
GROUP BY tenant_id, item_id, lot_id, location_id, status
HAVING SUM(quantity) <> 0;

CREATE TABLE materials.stock_level (
    tenant_id   uuid NOT NULL,
    item_id     uuid NOT NULL REFERENCES materials.item (item_id),
    location_id text NOT NULL CHECK (location_id <> ''),

    minimum          integer NOT NULL DEFAULT 0 CHECK (minimum >= 0),
    maximum          integer NOT NULL DEFAULT 0 CHECK (maximum >= 0),
    reorder_quantity integer NOT NULL DEFAULT 0 CHECK (reorder_quantity >= 0),

    updated_at timestamptz NOT NULL,
    updated_by text        NOT NULL CHECK (updated_by <> ''),

    PRIMARY KEY (tenant_id, item_id, location_id),

    -- A maximum below the minimum makes every top-up an order for a negative
    -- quantity, which rounds to nothing and silently never reorders.
    CONSTRAINT a_maximum_can_be_topped_up_to CHECK (
        maximum = 0 OR maximum >= minimum
    )
);

CREATE TABLE materials.requisition (
    requisition_id uuid PRIMARY KEY,
    tenant_id      uuid NOT NULL,

    number      text NOT NULL DEFAULT '',
    facility_id uuid,
    source      text NOT NULL CHECK (source IN (
        'manual', 'min_max', 'procedure', 'replenishment')),
    -- Without it every request is equally urgent, which means none is.
    need_by     timestamptz NOT NULL,
    -- A request no budget carries is a request nobody reviews.
    cost_centre text NOT NULL CHECK (cost_centre <> ''),
    source_reference text NOT NULL DEFAULT '',

    lines jsonb NOT NULL,
    state text  NOT NULL CHECK (state IN (
        'draft', 'pending_approval', 'approved', 'rejected', 'ordered', 'cancelled')),

    justification text NOT NULL DEFAULT '',
    raised_at     timestamptz NOT NULL,
    raised_by     text        NOT NULL CHECK (raised_by <> ''),
    version       bigint      NOT NULL DEFAULT 1
);

CREATE UNIQUE INDEX requisition_number_idx
    ON materials.requisition (tenant_id, number) WHERE number <> '';
CREATE INDEX requisition_state_idx
    ON materials.requisition (tenant_id, state, need_by);

-- The approval chain (SRS-MAT-002). Append-only, and the unique (requisition,
-- level) is what makes it a chain rather than a bag: a level cannot be
-- rewritten and a gap means a step was lost.
CREATE TABLE materials.approval_step (
    approval_step_id uuid PRIMARY KEY,
    tenant_id        uuid NOT NULL,
    requisition_id   uuid NOT NULL
        REFERENCES materials.requisition (requisition_id),

    level integer NOT NULL CHECK (level >= 1),
    -- Who was required, and who actually decided. Both, because "the head of
    -- department approved it" and "somebody with their permission approved
    -- it" are different claims.
    role     text NOT NULL CHECK (role <> ''),
    decision text NOT NULL CHECK (decision IN ('approved', 'rejected')),
    decider  text NOT NULL CHECK (decider <> ''),
    note     text NOT NULL DEFAULT '',
    decided_at timestamptz NOT NULL,

    UNIQUE (tenant_id, requisition_id, level),

    -- A rejection with no reason sends the requester back to guess, and they
    -- raise it again unchanged.
    CONSTRAINT a_rejection_says_why CHECK (
        decision <> 'rejected' OR note <> ''
    )
);

CREATE TABLE materials.approval_rule (
    approval_rule_id uuid PRIMARY KEY,
    tenant_id        uuid NOT NULL,

    minimum_value bigint NOT NULL DEFAULT 0 CHECK (minimum_value >= 0),
    currency      text   NOT NULL DEFAULT '',
    category      text   NOT NULL DEFAULT '',
    facility_id   uuid,

    roles text[] NOT NULL,

    created_at timestamptz NOT NULL,
    created_by text        NOT NULL CHECK (created_by <> ''),

    -- A rule that matches and requires nobody approves every request it
    -- touches. COALESCE because array_length of an empty array is NULL, and a
    -- CHECK that evaluates to NULL passes: without it the constraint would
    -- wave through exactly the case it exists for.
    CONSTRAINT an_approval_rule_names_somebody CHECK (
        COALESCE(array_length(roles, 1), 0) >= 1
    )
);

CREATE TABLE materials.rfq (
    rfq_id    uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    number         text NOT NULL DEFAULT '',
    requisition_id uuid REFERENCES materials.requisition (requisition_id),
    supplier_ids   uuid[] NOT NULL,
    lines          jsonb  NOT NULL,
    closes_at      timestamptz,

    issued_at timestamptz NOT NULL,
    issued_by text        NOT NULL CHECK (issued_by <> ''),
    version   bigint      NOT NULL DEFAULT 1,

    CONSTRAINT an_rfq_goes_to_somebody CHECK (
        COALESCE(array_length(supplier_ids, 1), 0) >= 1
    )
);

CREATE TABLE materials.bid (
    bid_id      uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,
    rfq_id      uuid NOT NULL REFERENCES materials.rfq (rfq_id),
    supplier_id uuid NOT NULL REFERENCES materials.supplier (supplier_id),

    lines jsonb NOT NULL,

    lead_time_days     integer NOT NULL DEFAULT 0,
    warranty_months    integer NOT NULL DEFAULT 0,
    payment_terms_days integer NOT NULL DEFAULT 0,
    freight_minor      bigint  NOT NULL DEFAULT 0,
    tax_minor          bigint  NOT NULL DEFAULT 0,
    currency           text    NOT NULL DEFAULT '',

    notes       text        NOT NULL DEFAULT '',
    received_at timestamptz NOT NULL,
    recorded_by text        NOT NULL CHECK (recorded_by <> ''),

    -- One quote per supplier per round. A second is an amended quote and
    -- belongs to a second round, otherwise a comparison silently counts one
    -- supplier twice.
    UNIQUE (tenant_id, rfq_id, supplier_id)
);

CREATE TABLE materials.purchase_order (
    purchase_order_id uuid PRIMARY KEY,
    tenant_id         uuid NOT NULL,

    number      text NOT NULL DEFAULT '',
    facility_id uuid,
    supplier_id uuid NOT NULL REFERENCES materials.supplier (supplier_id),
    requisition_id uuid REFERENCES materials.requisition (requisition_id),
    bid_id         uuid REFERENCES materials.bid (bid_id),

    -- Versioned, never updated in place. chain_id is the first revision's id
    -- and stays the same down the whole chain; supersedes points at the
    -- immediate predecessor so the chain also reads backwards one step at a
    -- time. Both, because they answer different questions: "every revision of
    -- this order" needs the root, and "what did this one change" needs the
    -- parent. A partial unique index on the root is what holds "at most one
    -- live revision", which a parent pointer cannot do past the second
    -- amendment.
    revision   integer NOT NULL CHECK (revision >= 1),
    chain_id   uuid    NOT NULL,
    supersedes uuid    REFERENCES materials.purchase_order (purchase_order_id),
    amendment_reason text NOT NULL DEFAULT '',

    lines jsonb NOT NULL,
    state text  NOT NULL CHECK (state IN (
        'draft', 'issued', 'partly_received', 'received', 'closed', 'cancelled')),

    currency           text    NOT NULL DEFAULT 'INR',
    payment_terms_days integer NOT NULL DEFAULT 0,
    delivery_terms     text    NOT NULL DEFAULT '',

    tolerance_over_percent  integer NOT NULL DEFAULT 0
        CHECK (tolerance_over_percent >= 0),
    tolerance_short_percent integer NOT NULL DEFAULT 0
        CHECK (tolerance_short_percent >= 0),

    issued_at  timestamptz,
    issued_by  text NOT NULL DEFAULT '',
    created_at timestamptz NOT NULL,
    created_by text        NOT NULL CHECK (created_by <> ''),
    version    bigint      NOT NULL DEFAULT 1,

    -- An amendment nobody explained is one nobody can defend when the invoice
    -- arrives.
    CONSTRAINT an_amendment_says_why CHECK (
        revision = 1 OR amendment_reason <> ''
    ),
    -- The first revision is its own chain; every later one inherits the root
    -- and names its parent. Neither half can be left out without breaking the
    -- index below or the backwards read.
    CONSTRAINT a_revision_belongs_to_its_chain CHECK (
        (revision = 1 AND chain_id = purchase_order_id AND supersedes IS NULL)
        OR (revision > 1 AND supersedes IS NOT NULL)
    ),
    CONSTRAINT an_issued_order_names_who_sent_it CHECK (
        state = 'draft' OR state = 'cancelled'
        OR (issued_at IS NOT NULL AND issued_by <> '')
    )
);

CREATE UNIQUE INDEX purchase_order_number_idx
    ON materials.purchase_order (tenant_id, number, revision)
    WHERE number <> '';
CREATE INDEX purchase_order_supplier_idx
    ON materials.purchase_order (tenant_id, supplier_id, created_at DESC);
-- Every revision of one order, which is what SRS-MAT-004's "PO version and
-- amendments retained" is read through.
CREATE INDEX purchase_order_chain_idx
    ON materials.purchase_order (tenant_id, chain_id, revision);
-- A revision number is used once per chain, so two amendments made at the
-- same moment cannot both become revision 3 and leave the history ambiguous.
CREATE UNIQUE INDEX purchase_order_revision_idx
    ON materials.purchase_order (tenant_id, chain_id, revision);
-- At most one revision of a chain is live. Without it two revisions could
-- both be issued and a supplier would be delivering against either, which is
-- precisely the failure versioning exists to prevent.
CREATE UNIQUE INDEX purchase_order_one_live_revision_idx
    ON materials.purchase_order (tenant_id, chain_id)
    WHERE state NOT IN ('cancelled', 'closed');

CREATE TABLE materials.receipt (
    receipt_id uuid PRIMARY KEY,
    tenant_id  uuid NOT NULL,

    number            text NOT NULL DEFAULT '',
    purchase_order_id uuid NOT NULL
        REFERENCES materials.purchase_order (purchase_order_id),
    -- The revision received against. A receipt that did not say would be
    -- unresolvable the moment an order was amended.
    po_revision integer NOT NULL CHECK (po_revision >= 1),
    supplier_id uuid    NOT NULL REFERENCES materials.supplier (supplier_id),
    location_id text    NOT NULL CHECK (location_id <> ''),

    delivery_note text NOT NULL DEFAULT '',
    invoice_ref   text NOT NULL DEFAULT '',

    lines jsonb NOT NULL,

    received_at timestamptz NOT NULL,
    received_by text        NOT NULL CHECK (received_by <> ''),
    version     bigint      NOT NULL DEFAULT 1
);

CREATE UNIQUE INDEX receipt_number_idx
    ON materials.receipt (tenant_id, number) WHERE number <> '';
CREATE INDEX receipt_order_idx
    ON materials.receipt (tenant_id, purchase_order_id);

CREATE TABLE materials.transfer (
    transfer_id uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,

    number        text NOT NULL DEFAULT '',
    from_location text NOT NULL CHECK (from_location <> ''),
    to_location   text NOT NULL CHECK (to_location <> ''),
    lines         jsonb NOT NULL,
    state         text  NOT NULL CHECK (state IN (
        'in_transit', 'received', 'cancelled')),

    reason text NOT NULL DEFAULT '',

    dispatched_at timestamptz NOT NULL,
    dispatched_by text        NOT NULL CHECK (dispatched_by <> ''),
    received_at   timestamptz,
    received_by   text        NOT NULL DEFAULT '',
    version       bigint      NOT NULL DEFAULT 1,

    -- A transfer to itself moves nothing and leaves a quantity in transit
    -- nobody is waiting for.
    CONSTRAINT a_transfer_goes_somewhere_else CHECK (
        from_location <> to_location
    ),
    CONSTRAINT a_closed_transfer_names_who_took_it CHECK (
        state <> 'received' OR (received_at IS NOT NULL AND received_by <> '')
    )
);

CREATE INDEX transfer_state_idx ON materials.transfer (tenant_id, state);
CREATE INDEX transfer_destination_idx
    ON materials.transfer (tenant_id, to_location, state);

CREATE TABLE materials.stock_count (
    count_id  uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    number      text NOT NULL DEFAULT '',
    location_id text NOT NULL CHECK (location_id <> ''),
    cycle       boolean NOT NULL DEFAULT false,

    lines jsonb NOT NULL DEFAULT '[]'::jsonb,
    state text  NOT NULL CHECK (state IN (
        'open', 'counted', 'approved', 'rejected')),

    approved_by   text        NOT NULL DEFAULT '',
    approved_at   timestamptz,
    approval_note text        NOT NULL DEFAULT '',

    opened_at  timestamptz NOT NULL,
    opened_by  text        NOT NULL CHECK (opened_by <> ''),
    counted_at timestamptz,
    counted_by text        NOT NULL DEFAULT '',
    version    bigint      NOT NULL DEFAULT 1,

    -- SRS-MAT-011's control, in the database as well as the domain: a
    -- storekeeper who could count their own store and sign off the difference
    -- can make any shortfall disappear, and the variance report is then a
    -- record of nothing.
    CONSTRAINT the_counter_does_not_approve CHECK (
        state <> 'approved' OR (approved_by <> '' AND approved_by <> counted_by)
    ),
    CONSTRAINT a_rejected_count_says_why CHECK (
        state <> 'rejected' OR approval_note <> ''
    )
);

CREATE INDEX stock_count_state_idx
    ON materials.stock_count (tenant_id, state, opened_at DESC);

CREATE TABLE materials.invoice (
    invoice_id uuid PRIMARY KEY,
    tenant_id  uuid NOT NULL,

    number            text NOT NULL DEFAULT '',
    supplier_id       uuid NOT NULL REFERENCES materials.supplier (supplier_id),
    purchase_order_id uuid REFERENCES materials.purchase_order (purchase_order_id),
    lines             jsonb NOT NULL,
    currency          text  NOT NULL DEFAULT 'INR',

    received_at timestamptz NOT NULL,
    recorded_by text        NOT NULL CHECK (recorded_by <> '')
);

CREATE UNIQUE INDEX invoice_number_idx
    ON materials.invoice (tenant_id, supplier_id, number) WHERE number <> '';

-- What consuming a supplier's stock owes them (SRS-MAT-016). Append-only:
-- a liability that can be edited is one that can be edited away.
CREATE TABLE materials.liability_event (
    liability_event_id uuid PRIMARY KEY,
    tenant_id          uuid NOT NULL,

    lot_id      uuid NOT NULL REFERENCES materials.lot (lot_id),
    item_id     uuid NOT NULL REFERENCES materials.item (item_id),
    supplier_id uuid NOT NULL REFERENCES materials.supplier (supplier_id),
    quantity    integer NOT NULL CHECK (quantity > 0),

    patient_id   uuid,
    encounter_id uuid,
    -- The movement that caused it. One liability per movement, so a retry
    -- cannot bill a supplier twice for one implant.
    movement_id uuid NOT NULL REFERENCES materials.movement (movement_id),

    occurred_at timestamptz NOT NULL,
    recorded_by text        NOT NULL CHECK (recorded_by <> ''),

    UNIQUE (tenant_id, movement_id)
);

CREATE INDEX liability_supplier_idx
    ON materials.liability_event (tenant_id, supplier_id, occurred_at DESC);
