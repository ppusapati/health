-- 0023 Orders and CPOE: the common order framework, order sets, favourites,
-- duplicate rules and downstream acknowledgement (SRS-ORD).
--
-- One table for nine order types, which is SRS-ORD-001's real content.
-- Everything downstream — a laboratory, a radiology department, a pharmacy, a
-- kitchen — receives an order, and if each type had its own table then every
-- cross-cutting rule (the state machine, the duplicate check, the audit trail,
-- the event contract) would be written nine times and would drift eight ways.
--
-- Two constraints carry most of the weight.
--
-- SRS-ORD-006's "without database coupling" means the performing contexts do
-- not read this schema. They receive a dispatch on the bus and reply with an
-- acknowledgement, and the acknowledgement's delivery identifier is unique per
-- order and service — an at-least-once bus redelivers, and applying a
-- redelivered acknowledgement twice would move an order twice and emit two
-- events.
--
-- SRS-ORD-004's "cancellation after execution is rejected or converted" means a
-- requester's cancellation of an executing order is a request recorded against
-- the order rather than a status the requester sets. The order stays in the
-- state the performing service put it in, because showing it as cancelled while
-- a laboratory is still running the test would tell the ward the wrong thing.
--
-- Trace: SRS-ORD-001 (common framework), SRS-ORD-002 (validation),
--   SRS-ORD-003 (order sets with provenance), SRS-ORD-004 (modify/cancel by
--   execution status), SRS-ORD-005 (state machine), SRS-ORD-006 (routing with
--   idempotent acknowledgement), SRS-ORD-007 (required indication),
--   SRS-ORD-008 (structured timing), SRS-ORD-009 (duplicate rules),
--   SRS-ORD-010 (audit), SRS-ORD-011 (events), SRS-ORD-012 (favourites).
-- Rollback: drops the whole schema. Every order in flight is lost with it, and
--   the performing services hold only what they were dispatched — a laboratory
--   knows it has a specimen and not who asked for it. Export before dropping
--   and treat a rollback here as a disaster-recovery event.
-- Reconciliation: none for the forward direction; the schema is new. The
--   previous version writes nothing here during the rollout window because it
--   does not know these tables exist.

CREATE SCHEMA IF NOT EXISTS orders;

-- One request for something to be done (SRS-ORD-001).
CREATE TABLE orders.clinical_order (
    order_id        uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    -- The human-readable identifier a ward reads down a phone.
    number          text        NOT NULL CHECK (number <> ''),
    order_type      text        NOT NULL CHECK (order_type IN (
                        'laboratory', 'imaging', 'medication', 'procedure',
                        'diet', 'nursing', 'blood_product', 'referral',
                        'allied_health')),
    patient_id      uuid        NOT NULL,
    -- Every order belongs to a visit. One with no encounter cannot be billed,
    -- cannot be found on the chart, and cannot be stopped when the patient goes
    -- home.
    encounter_id    uuid        NOT NULL,
    facility_id     uuid        NOT NULL,
    -- Who is answerable, and who typed it. Not always the same person: a verbal
    -- order taken by a nurse.
    requester_id    text        NOT NULL CHECK (requester_id <> ''),
    entered_by_id   text        NOT NULL CHECK (entered_by_id <> ''),
    -- Derived from the type at placement and stored, so a routing-table change
    -- does not re-route orders already in flight.
    target_service  text        NOT NULL CHECK (target_service <> ''),

    code_system     text        NOT NULL CHECK (code_system <> ''),
    code_version    text        NOT NULL DEFAULT '',
    code            text        NOT NULL CHECK (code <> ''),
    code_display    text        NOT NULL CHECK (code_display <> ''),
    detail          text        NOT NULL DEFAULT '',
    -- SRS-ORD-007. Required by policy for the types a tenant configures, which
    -- is an application rule rather than a column constraint: the set of types
    -- is tenant-configurable and a CHECK would freeze it.
    indication      text        NOT NULL DEFAULT '',
    indication_system text      NOT NULL DEFAULT '',
    indication_code text        NOT NULL DEFAULT '',
    indication_display text     NOT NULL DEFAULT '',

    priority        text        NOT NULL CHECK (priority IN (
                        'routine', 'urgent', 'stat', 'timing_critical')),
    -- SRS-ORD-008's structured timing. Stored as a rule and expanded into
    -- explicit occurrences on the way out: a standing order has no last
    -- occurrence, so storing every one would be storing an infinite series.
    timing_start_at timestamptz,
    timing_end_at   timestamptz,
    timing_frequency_seconds bigint NOT NULL DEFAULT 0
                                CHECK (timing_frequency_seconds >= 0),
    timing_count    integer     NOT NULL DEFAULT 0 CHECK (timing_count >= 0),
    -- Minutes after midnight in the facility's zone, and days of week as
    -- 0-6 from Sunday.
    timing_times_of_day integer[] NOT NULL DEFAULT '{}',
    timing_days_of_week integer[] NOT NULL DEFAULT '{}',
    timing_prn      boolean     NOT NULL DEFAULT false,
    timing_duration_seconds bigint NOT NULL DEFAULT 0
                                CHECK (timing_duration_seconds >= 0),
    -- "If the potassium is under 3.5" — structured enough to be named, because
    -- a condition buried in an instruction is a condition nobody applies.
    conditional_instruction text NOT NULL DEFAULT '',

    status          text        NOT NULL CHECK (status IN (
                        'draft', 'requested', 'accepted', 'scheduled',
                        'in_progress', 'completed', 'cancelled',
                        'entered_in_error')),

    -- SRS-ORD-003's provenance. The version is stored, not referenced: a set
    -- edited afterwards must not restate what was ordered.
    order_set_id      uuid,
    order_set_version text      NOT NULL DEFAULT '',
    -- SRS-ORD-012. Recorded so a report can ask whether a consultant's shortcut
    -- still matches the institutional set.
    favourite_id      uuid,

    -- SRS-ORD-004's corrective workflow. A request, not a status: the order
    -- stays where the performing service put it.
    cancellation_requested_at timestamptz,
    cancellation_requested_by text NOT NULL DEFAULT '',
    cancellation_reason       text NOT NULL DEFAULT '',

    -- SRS-ORD-009. The orders that were shown are captured at the time rather
    -- than recomputed: they usually complete afterwards, and a recomputing
    -- report would show every override as having overridden nothing.
    duplicate_override_reason text   NOT NULL DEFAULT '',
    duplicate_override_by     text   NOT NULL DEFAULT '',
    duplicate_override_at     timestamptz,
    duplicate_override_against uuid[] NOT NULL DEFAULT '{}',

    created_at      timestamptz NOT NULL,
    updated_at      timestamptz NOT NULL,
    version         bigint      NOT NULL DEFAULT 1,

    -- An as-needed order with a schedule is two instructions, and the ward will
    -- follow whichever it reads first.
    CHECK (NOT timing_prn OR (timing_frequency_seconds = 0
        AND cardinality(timing_times_of_day) = 0)),
    CHECK (timing_end_at IS NULL OR timing_start_at IS NULL
        OR timing_end_at > timing_start_at),
    -- "Do it now" and "do it if" cannot both hold.
    CHECK (conditional_instruction = '' OR priority <> 'stat'),
    CHECK (cancellation_requested_at IS NULL
        OR (cancellation_requested_by <> '' AND cancellation_reason <> '')),
    CHECK (duplicate_override_reason = ''
        OR (duplicate_override_by <> '' AND duplicate_override_at IS NOT NULL
            AND cardinality(duplicate_override_against) > 0))
);

CREATE UNIQUE INDEX clinical_order_number_key
    ON orders.clinical_order (tenant_id, number);

-- The chart view: a patient's orders, newest first.
CREATE INDEX clinical_order_patient_idx
    ON orders.clinical_order (tenant_id, patient_id, created_at DESC);
CREATE INDEX clinical_order_encounter_idx
    ON orders.clinical_order (tenant_id, encounter_id, status);

-- The duplicate check (SRS-ORD-009) reads live orders of one type for one
-- patient inside a window.
CREATE INDEX clinical_order_duplicate_idx
    ON orders.clinical_order (tenant_id, patient_id, order_type, created_at DESC)
    WHERE status NOT IN ('completed', 'cancelled', 'entered_in_error');

-- The performing service's worklist.
CREATE INDEX clinical_order_service_idx
    ON orders.clinical_order (tenant_id, target_service, priority, created_at)
    WHERE status NOT IN ('draft', 'completed', 'cancelled', 'entered_in_error');

-- Cancellations a performing service has not yet answered (SRS-ORD-004).
CREATE INDEX clinical_order_cancellation_idx
    ON orders.clinical_order (tenant_id, target_service,
        cancellation_requested_at)
    WHERE cancellation_requested_at IS NOT NULL
        AND status NOT IN ('completed', 'cancelled', 'entered_in_error');

-- One step in an order's life (SRS-ORD-005, SRS-ORD-010).
CREATE TABLE orders.order_status_change (
    change_id     uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    order_id      uuid        NOT NULL
                              REFERENCES orders.clinical_order (order_id),
    from_status   text        NOT NULL,
    to_status     text        NOT NULL,
    -- A downstream service is a subject like any other, so an acceptance by the
    -- laboratory names the laboratory's analyser.
    changed_by    text        NOT NULL CHECK (changed_by <> ''),
    reason        text        NOT NULL DEFAULT '',
    occurred_at   timestamptz NOT NULL
);

CREATE INDEX order_status_change_idx
    ON orders.order_status_change (tenant_id, order_id, occurred_at);

-- SRS-ORD-006's idempotency, and the reason it is here rather than in the
-- application: an at-least-once bus redelivers, two deliveries of one
-- acknowledgement can be in flight at the same moment, and a check-then-apply
-- would let both through — moving the order twice and emitting two events.
CREATE TABLE orders.order_acknowledgement (
    tenant_id     uuid        NOT NULL,
    order_id      uuid        NOT NULL
                              REFERENCES orders.clinical_order (order_id),
    service       text        NOT NULL CHECK (service <> ''),
    delivery_id   text        NOT NULL CHECK (delivery_id <> ''),
    to_status     text        NOT NULL,
    reason        text        NOT NULL DEFAULT '',
    performer_id  text        NOT NULL CHECK (performer_id <> ''),
    occurred_at   timestamptz NOT NULL,
    received_at   timestamptz NOT NULL,
    -- Whether this delivery actually moved the order. A replay records itself
    -- and changes nothing, which is what makes "how often does the bus
    -- redeliver" answerable.
    applied       boolean     NOT NULL,

    PRIMARY KEY (tenant_id, order_id, service, delivery_id)
);

CREATE INDEX order_acknowledgement_order_idx
    ON orders.order_acknowledgement (tenant_id, order_id, received_at);

-- An institutional bundle of orders (SRS-ORD-003).
--
-- Never mutated in place: editing a published set would silently rewrite what
-- every order placed from it claims to have come from. A change is a new
-- version.
CREATE TABLE orders.order_set (
    set_id      uuid        NOT NULL,
    tenant_id   uuid        NOT NULL,
    version     text        NOT NULL CHECK (version <> ''),
    name        text        NOT NULL CHECK (name <> ''),
    specialty   text        NOT NULL DEFAULT '',
    -- Components as an ordered array, because a set is read whole and never
    -- queried by component, and the orders placed from it must see exactly the
    -- structure that was published.
    components  jsonb       NOT NULL,
    retired     boolean     NOT NULL DEFAULT false,
    created_by  text        NOT NULL,
    created_at  timestamptz NOT NULL,

    PRIMARY KEY (set_id, version),
    CHECK (jsonb_typeof(components) = 'array'
        AND jsonb_array_length(components) > 0)
);

CREATE INDEX order_set_tenant_idx
    ON orders.order_set (tenant_id, specialty, retired);

-- One clinician's saved order (SRS-ORD-012).
--
-- A separate table from order_set, not a private flag on it. An order set is
-- institutional governance — reviewed, versioned, retired by a committee — and
-- a favourite is somebody's shortcut; making the second a variant of the first
-- would put a consultant's preference inside the governance it must not bypass.
CREATE TABLE orders.order_favourite (
    favourite_id uuid       PRIMARY KEY,
    tenant_id    uuid       NOT NULL,
    -- Never shared: a shared shortcut with no review is an order set that
    -- escaped governance.
    owner_id     text       NOT NULL CHECK (owner_id <> ''),
    name         text       NOT NULL CHECK (name <> ''),
    order_type   text       NOT NULL,
    code_system  text       NOT NULL CHECK (code_system <> ''),
    code_version text       NOT NULL DEFAULT '',
    code         text       NOT NULL CHECK (code <> ''),
    code_display text       NOT NULL CHECK (code_display <> ''),
    detail       text       NOT NULL DEFAULT '',
    indication   text       NOT NULL DEFAULT '',
    priority     text       NOT NULL DEFAULT 'routine',
    timing_start_at timestamptz,
    timing_frequency_seconds bigint NOT NULL DEFAULT 0,
    timing_count integer    NOT NULL DEFAULT 0,
    timing_times_of_day integer[] NOT NULL DEFAULT '{}',
    timing_days_of_week integer[] NOT NULL DEFAULT '{}',
    timing_prn   boolean    NOT NULL DEFAULT false,
    created_at   timestamptz NOT NULL,
    updated_at   timestamptz NOT NULL
);

CREATE UNIQUE INDEX order_favourite_name_key
    ON orders.order_favourite (tenant_id, owner_id, lower(name));

CREATE INDEX order_favourite_owner_idx
    ON orders.order_favourite (tenant_id, owner_id, order_type);

-- What a tenant requires before an order may be placed
-- (SRS-ORD-002, SRS-ORD-007).
--
-- Per type, because the answer genuinely differs: an indication for a CT scan
-- is what justifies a radiation dose that a national body audits, and an
-- indication for a diet order is a field nobody fills in honestly once it is
-- mandatory. A row's absence means the domain default.
CREATE TABLE orders.order_policy (
    tenant_id            uuid  NOT NULL,
    order_type           text  NOT NULL,
    indication_required  boolean NOT NULL DEFAULT false,
    structured_timing_required boolean NOT NULL DEFAULT false,
    -- The privilege a requester needs for this type, or empty for none. The
    -- authorization check belongs to the application, which holds the session;
    -- which types are gated is stored here so the two cannot drift.
    required_privilege   text  NOT NULL DEFAULT '',
    updated_by           text  NOT NULL,
    updated_at           timestamptz NOT NULL,

    PRIMARY KEY (tenant_id, order_type)
);

-- How a tenant decides two orders are the same (SRS-ORD-009).
CREATE TABLE orders.duplicate_rule (
    tenant_id      uuid    NOT NULL,
    order_type     text    NOT NULL,
    -- Zero disables the check for this type.
    within_seconds bigint  NOT NULL DEFAULT 0 CHECK (within_seconds >= 0),
    same_code_only boolean NOT NULL DEFAULT true,
    -- Default true, and deliberately: SRS-ORD-009 says the system shows a
    -- warning "rather than arbitrary suppression", so a rule that refused
    -- outright would be the suppression the requirement forbids.
    overridable    boolean NOT NULL DEFAULT true,
    updated_by     text    NOT NULL,
    updated_at     timestamptz NOT NULL,

    PRIMARY KEY (tenant_id, order_type)
);
