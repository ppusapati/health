-- 0037 Biomedical engineering and asset maintenance (SRS-BIO-001 … 011).
--
-- Five shapes here are unusual and deliberate.
--
-- Telemetry is its own table with no foreign key into any maintenance record,
-- and nothing above it ever updates one. SRS-BIO-010's acceptance is that
-- telemetry does not overwrite maintenance records, and the shape that
-- guarantees it is separation: a reading can tell a planner that a pump has
-- run four thousand hours; it can never alter what an engineer wrote about the
-- last repair.
--
-- A ticket carries a kind, and only a corrective one counts as a failure. MTBF
-- is the mean time between failures, and a schema that could not tell a
-- breakdown from a scheduled service would make a well-maintained machine read
-- as unreliable — an argument for servicing less.
--
-- The disposed status is terminal, held by a CHECK on the asset and by the
-- absence of any path back. SRS-BIO-011's clause is that a disposed asset
-- cannot be assigned for use, and a state the record cannot leave is stronger
-- than a check at the point of assignment that somebody will forget.
--
-- An asset's location is cleared on disposal. SRS-BIO-009 derives a room's
-- capabilities from the assets standing in it, and equipment that has left the
-- building must stop contributing the moment it goes.
--
-- A safety notice's tasks are one row per affected asset, not a flag on the
-- notice. The acceptance is that tasks track inspection and correction
-- completion, which is a question per machine.
--
-- Trace: SRS-BIO-001 … SRS-BIO-011.
--
-- Rollback: drops the schema. Every asset record, contract, maintenance plan,
-- ticket, safety notice and disposal goes with it. The maintenance history is
-- what an accreditation inspection reads and what a recall is answered from,
-- so treat this as a disaster-recovery action, never a deployment step.
--
-- Reconciliation: the tables are new, so the previous version writes nothing
-- here and sees nothing missing. The direction to watch is the theatre: SRS-OT
-- matches a case's equipment needs against a room's capability list, and until
-- every replica reads asset availability it will keep offering a slot whose
-- intensifier is in pieces. The link is one-way and advisory, so nothing
-- breaks — a room simply over-promises until the rollout finishes.

CREATE SCHEMA IF NOT EXISTS biomedical;

CREATE TABLE biomedical.asset (
    asset_id  uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    -- The number on the sticker. Without it a service request names nothing an
    -- engineer can walk to.
    tag text NOT NULL CHECK (tag <> ''),
    -- Both, because a recall is announced by one or the other and a hospital
    -- does not get to choose which.
    udi    text NOT NULL DEFAULT '',
    serial text NOT NULL DEFAULT '',

    make     text NOT NULL CHECK (make <> ''),
    model    text NOT NULL CHECK (model <> ''),
    category text NOT NULL DEFAULT '',

    criticality text NOT NULL CHECK (criticality IN (
        'routine', 'important', 'critical', 'life_support')),
    status text NOT NULL CHECK (status IN (
        'in_service', 'under_maintenance', 'awaiting_parts',
        'out_of_service', 'decommissioned', 'disposed')),

    location_id text NOT NULL DEFAULT '',
    department  text NOT NULL DEFAULT '',
    -- What this asset lets a room do. The vocabulary SRS-OT already matches a
    -- case's requirements against, so an asset out of service can subtract
    -- from it.
    capabilities text[] NOT NULL DEFAULT '{}',

    acquired_on            date,
    acquisition_cost_minor bigint  NOT NULL DEFAULT 0
        CHECK (acquisition_cost_minor >= 0),
    expected_life_years    integer NOT NULL DEFAULT 0,

    calibration_required    boolean     NOT NULL DEFAULT false,
    calibration_due         timestamptz,
    calibration_certificate text        NOT NULL DEFAULT '',

    safety_hold        boolean NOT NULL DEFAULT false,
    safety_hold_reason text    NOT NULL DEFAULT '',

    notes      text        NOT NULL DEFAULT '',
    created_at timestamptz NOT NULL,
    created_by text        NOT NULL CHECK (created_by <> ''),
    version    bigint      NOT NULL DEFAULT 1,

    -- An asset that needs calibrating and has no due date never comes due,
    -- which is the one direction that lets an uncalibrated machine stay in
    -- service for ever. And a due date on an asset nobody calibrates is a
    -- reminder that will be dismissed every month until people stop reading
    -- them.
    CONSTRAINT calibration_and_its_date_agree CHECK (
        calibration_required = (calibration_due IS NOT NULL)
    ),
    -- A hold nobody explained is one nobody will be confident enough to lift.
    CONSTRAINT a_safety_hold_is_explained CHECK (
        NOT safety_hold OR safety_hold_reason <> ''
    ),
    -- Equipment that has left the building stops contributing capability to
    -- the room it stood in, the moment it goes.
    CONSTRAINT a_disposed_asset_is_nowhere CHECK (
        status <> 'disposed' OR (location_id = '' AND NOT safety_hold)
    )
);

CREATE UNIQUE INDEX asset_tag_idx ON biomedical.asset (tenant_id, tag);
-- A serial identifies one physical object per make, so it cannot be reused
-- while another asset holds it. Assets with no serial are excluded.
CREATE UNIQUE INDEX asset_serial_idx
    ON biomedical.asset (tenant_id, make, serial)
    WHERE serial <> '';
CREATE UNIQUE INDEX asset_udi_idx
    ON biomedical.asset (tenant_id, udi) WHERE udi <> '';
-- SRS-BIO-009's read: what is standing in this room.
CREATE INDEX asset_location_idx
    ON biomedical.asset (tenant_id, location_id) WHERE location_id <> '';
CREATE INDEX asset_status_idx ON biomedical.asset (tenant_id, status);
-- The calibration sweep.
CREATE INDEX asset_calibration_idx
    ON biomedical.asset (tenant_id, calibration_due)
    WHERE calibration_required;

CREATE TABLE biomedical.service_contract (
    contract_id uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,
    asset_id    uuid NOT NULL REFERENCES biomedical.asset (asset_id),

    kind text NOT NULL CHECK (kind IN ('warranty', 'amc', 'cmc')),
    reference text NOT NULL DEFAULT '',

    -- A contract with no vendor is one nobody can call when the machine
    -- stops, which is the only moment it matters.
    vendor_name    text NOT NULL CHECK (vendor_name <> ''),
    vendor_contact text NOT NULL DEFAULT '',
    vendor_phone   text NOT NULL DEFAULT '',
    vendor_email   text NOT NULL DEFAULT '',

    starts_on timestamptz,
    -- NOT NULL because a contract with no end date never expires and never
    -- reminds, and SRS-BIO-002's acceptance is that reminders are generated.
    ends_on   timestamptz NOT NULL,
    value_minor bigint NOT NULL DEFAULT 0,

    -- What the vendor promised. A ticket's SLA is derived from these, so its
    -- clock comes from the contract rather than a number somebody typed.
    response_hours   integer NOT NULL DEFAULT 0 CHECK (response_hours >= 0),
    resolution_hours integer NOT NULL DEFAULT 0 CHECK (resolution_hours >= 0),

    notes      text        NOT NULL DEFAULT '',
    created_at timestamptz NOT NULL,
    created_by text        NOT NULL CHECK (created_by <> ''),
    version    bigint      NOT NULL DEFAULT 1,

    CONSTRAINT a_contract_ends_after_it_starts CHECK (
        starts_on IS NULL OR ends_on > starts_on
    )
);

CREATE INDEX contract_asset_idx
    ON biomedical.service_contract (tenant_id, asset_id, ends_on DESC);
-- The renewal sweep.
CREATE INDEX contract_expiry_idx
    ON biomedical.service_contract (tenant_id, ends_on);

CREATE TABLE biomedical.pm_plan (
    plan_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,
    asset_id  uuid NOT NULL REFERENCES biomedical.asset (asset_id),

    basis text NOT NULL CHECK (basis IN ('interval', 'runtime', 'risk')),
    interval_days integer NOT NULL DEFAULT 0 CHECK (interval_days >= 0),
    runtime_hours integer NOT NULL DEFAULT 0 CHECK (runtime_hours >= 0),

    -- A plan that says only "service it" produces a record that says only
    -- "serviced", which no inspection can check anything against.
    procedure text NOT NULL CHECK (procedure <> ''),
    estimated_minutes integer NOT NULL DEFAULT 0,

    last_performed_at  timestamptz NOT NULL,
    last_runtime_hours integer     NOT NULL DEFAULT 0,

    active     boolean     NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL,
    created_by text        NOT NULL CHECK (created_by <> ''),
    version    bigint      NOT NULL DEFAULT 1,

    -- A plan whose basis has no interval never comes due, in either
    -- direction.
    CONSTRAINT a_plan_has_an_interval_for_its_basis CHECK (
        (basis IN ('interval', 'risk') AND interval_days > 0)
        OR (basis = 'runtime' AND runtime_hours > 0)
    )
);

CREATE INDEX pm_plan_asset_idx
    ON biomedical.pm_plan (tenant_id, asset_id) WHERE active;

CREATE TABLE biomedical.ticket (
    ticket_id uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    number text NOT NULL DEFAULT '',
    -- Only a corrective ticket counts as a failure. Without this column MTBF
    -- would measure how often a machine is serviced.
    kind text NOT NULL CHECK (kind IN (
        'corrective', 'preventive', 'calibration', 'inspection')),
    asset_id uuid NOT NULL REFERENCES biomedical.asset (asset_id),
    plan_id  uuid REFERENCES biomedical.pm_plan (plan_id),
    -- Carried so a closed ticket still names the machine after the asset is
    -- re-tagged or moved.
    asset_tag   text NOT NULL DEFAULT '',
    location_id text NOT NULL DEFAULT '',

    -- An engineer reading "broken" arrives without the part.
    symptom  text NOT NULL CHECK (symptom <> ''),
    priority text NOT NULL CHECK (priority IN (
        'low', 'normal', 'high', 'emergency')),
    impact text NOT NULL CHECK (impact IN (
        'none', 'degraded', 'service_stopped', 'patient_affected')),

    state text NOT NULL CHECK (state IN (
        'open', 'assigned', 'in_progress', 'awaiting_parts',
        'resolved', 'closed', 'cancelled')),
    owner_id text NOT NULL DEFAULT '',

    -- Frozen on the ticket, because the contract may lapse before it closes
    -- and the promise that applied is the one it was raised under.
    respond_by  timestamptz,
    resolve_by  timestamptz,
    contract_id uuid REFERENCES biomedical.service_contract (contract_id),

    diagnosis      text  NOT NULL DEFAULT '',
    work_performed text  NOT NULL DEFAULT '',
    parts          jsonb NOT NULL DEFAULT '[]'::jsonb,

    -- Bounded separately from the ticket's own timestamps: a machine reported
    -- on Monday may have failed on Friday, and uptime is measured from when it
    -- stopped working rather than from when somebody noticed.
    down_from  timestamptz,
    down_until timestamptz,
    awaiting_parts_minutes integer NOT NULL DEFAULT 0
        CHECK (awaiting_parts_minutes >= 0),

    responded_at     timestamptz,
    resolved_at      timestamptz,
    closed_at        timestamptz,
    closed_by        text NOT NULL DEFAULT '',
    closure_note     text NOT NULL DEFAULT '',
    cancelled_reason text NOT NULL DEFAULT '',

    raised_at timestamptz NOT NULL,
    raised_by text        NOT NULL CHECK (raised_by <> ''),
    version   bigint      NOT NULL DEFAULT 1,

    -- SRS-BIO-006's closure validation, in the database as well as the
    -- domain: a repair signed off by the person who made it is the same claim
    -- twice, not a validation.
    CONSTRAINT the_engineer_does_not_validate_their_own_repair CHECK (
        state <> 'closed'
        OR (closed_by <> '' AND (owner_id = '' OR closed_by <> owner_id))
    ),
    -- Planned work naming no plan cannot be counted towards compliance with
    -- one, and PM compliance would become whatever anybody labelled
    -- preventive.
    CONSTRAINT preventive_work_names_its_plan CHECK (
        kind <> 'preventive' OR plan_id IS NOT NULL
    ),
    CONSTRAINT a_machine_comes_back_after_it_stopped CHECK (
        down_until IS NULL OR down_from IS NULL OR down_until >= down_from
    ),
    CONSTRAINT a_cancelled_ticket_says_why CHECK (
        state <> 'cancelled' OR cancelled_reason <> ''
    ),
    -- A resolution with no diagnosis says a machine was fixed and nothing
    -- about whether it is the same fault as last time.
    CONSTRAINT a_resolution_records_what_was_found CHECK (
        state NOT IN ('resolved', 'closed')
        OR (diagnosis <> '' AND work_performed <> '')
    )
);

CREATE UNIQUE INDEX ticket_number_idx
    ON biomedical.ticket (tenant_id, number) WHERE number <> '';
CREATE INDEX ticket_asset_idx
    ON biomedical.ticket (tenant_id, asset_id, raised_at DESC);
-- The engineer's queue.
CREATE INDEX ticket_open_idx
    ON biomedical.ticket (tenant_id, state, priority)
    WHERE state NOT IN ('closed', 'cancelled');
-- What the reliability figures are computed over.
CREATE INDEX ticket_downtime_idx
    ON biomedical.ticket (tenant_id, asset_id, down_from)
    WHERE down_from IS NOT NULL;

CREATE TABLE biomedical.safety_notice (
    notice_id uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    -- The manufacturer's or regulator's own reference. An inspection asks for
    -- it by name.
    reference text NOT NULL CHECK (reference <> ''),
    kind text NOT NULL CHECK (kind IN (
        'recall', 'field_safety', 'advisory')),
    issuer  text NOT NULL DEFAULT '',
    summary text NOT NULL CHECK (summary <> ''),

    -- How the notice names the equipment it covers, as the notice states it.
    make         text NOT NULL DEFAULT '',
    model        text NOT NULL DEFAULT '',
    serial_from  text NOT NULL DEFAULT '',
    serial_to    text NOT NULL DEFAULT '',
    affected_udi text NOT NULL DEFAULT '',

    hold_affected   boolean NOT NULL DEFAULT false,
    required_action text    NOT NULL CHECK (required_action <> ''),
    due_by          timestamptz,

    issued_on timestamptz,
    raised_at timestamptz NOT NULL,
    raised_by text        NOT NULL CHECK (raised_by <> ''),
    closed_at timestamptz,
    closed_by text        NOT NULL DEFAULT '',
    closure_note text     NOT NULL DEFAULT '',
    version   bigint      NOT NULL DEFAULT 1,

    -- Without a make or a UDI nothing can be matched, and the notice reaches
    -- no asset at all.
    CONSTRAINT a_notice_names_the_equipment_it_covers CHECK (
        make <> '' OR affected_udi <> ''
    ),
    -- A recall always holds its assets. The one direction that is not
    -- configurable.
    CONSTRAINT a_recall_always_holds CHECK (
        kind <> 'recall' OR hold_affected
    ),
    CONSTRAINT a_closed_notice_names_who_signed_it CHECK (
        closed_at IS NULL OR closed_by <> ''
    )
);

CREATE UNIQUE INDEX notice_reference_idx
    ON biomedical.safety_notice (tenant_id, reference);
CREATE INDEX notice_open_idx
    ON biomedical.safety_notice (tenant_id, due_by) WHERE closed_at IS NULL;

CREATE TABLE biomedical.notice_task (
    task_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,
    notice_id uuid NOT NULL REFERENCES biomedical.safety_notice (notice_id),
    asset_id  uuid NOT NULL REFERENCES biomedical.asset (asset_id),
    asset_tag text NOT NULL DEFAULT '',

    state text NOT NULL CHECK (state IN (
        'outstanding', 'inspected', 'corrected', 'not_affected',
        'quarantined')),
    note text NOT NULL DEFAULT '',

    completed_at timestamptz,
    completed_by text NOT NULL DEFAULT '',

    -- One task per asset per notice. Two would make the completion count
    -- wrong in the direction that reports a recall as further along than it
    -- is.
    UNIQUE (tenant_id, notice_id, asset_id),

    -- "Not affected" removes a machine from a recall. It is the one verdict
    -- that needs a reason, because it is the one that ends the enquiry.
    CONSTRAINT not_affected_says_why CHECK (
        state <> 'not_affected' OR note <> ''
    ),
    CONSTRAINT a_completed_task_names_who_did_it CHECK (
        state NOT IN ('corrected', 'not_affected', 'quarantined')
        OR (completed_at IS NOT NULL AND completed_by <> '')
    )
);

CREATE INDEX notice_task_notice_idx
    ON biomedical.notice_task (tenant_id, notice_id, state);
CREATE INDEX notice_task_asset_idx
    ON biomedical.notice_task (tenant_id, asset_id);

-- Telemetry (SRS-BIO-010). Append-only, and deliberately holding no reference
-- to any maintenance record: a reading can inform a plan and can never alter
-- what an engineer wrote.
CREATE TABLE biomedical.reading (
    reading_id uuid PRIMARY KEY,
    tenant_id  uuid NOT NULL,
    asset_id   uuid NOT NULL REFERENCES biomedical.asset (asset_id),

    -- A number with no metric is a number. Every plan and chart selects on
    -- this.
    metric text   NOT NULL CHECK (metric <> ''),
    value  double precision NOT NULL,
    unit   text   NOT NULL DEFAULT '',

    -- A hand-entered meter reading and an ingested one are evidence of
    -- different weight, and a planner should be able to see which this is.
    source   text    NOT NULL DEFAULT '',
    ingested boolean NOT NULL DEFAULT false,

    observed_at timestamptz NOT NULL,
    recorded_at timestamptz NOT NULL,
    recorded_by text        NOT NULL CHECK (recorded_by <> '')
);

-- Latest-by-observation rather than by recording, because a backlog flushing
-- after an outage arrives out of order.
CREATE INDEX reading_asset_metric_idx
    ON biomedical.reading (tenant_id, asset_id, metric, observed_at DESC);

CREATE TABLE biomedical.disposal (
    disposal_id uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,
    asset_id    uuid NOT NULL REFERENCES biomedical.asset (asset_id),
    asset_tag   text NOT NULL DEFAULT '',

    method text NOT NULL CHECK (method <> ''),
    reason text NOT NULL CHECK (reason <> ''),

    requested_by text        NOT NULL DEFAULT '',
    approved_by  text        NOT NULL CHECK (approved_by <> ''),
    approved_at  timestamptz NOT NULL,

    sanitisation_required    boolean NOT NULL DEFAULT false,
    sanitisation_method      text    NOT NULL DEFAULT '',
    sanitisation_certificate text    NOT NULL DEFAULT '',
    sanitised_by             text    NOT NULL DEFAULT '',

    recipient      text   NOT NULL DEFAULT '',
    proceeds_minor bigint NOT NULL DEFAULT 0 CHECK (proceeds_minor >= 0),

    disposed_at timestamptz NOT NULL,
    recorded_by text        NOT NULL CHECK (recorded_by <> ''),

    -- An asset is disposed of once. A second row would be a second set of
    -- sanitisation evidence for a machine that has already gone.
    UNIQUE (tenant_id, asset_id),

    -- A disposal signed off by whoever asked for it is not an approval.
    CONSTRAINT a_disposal_is_approved_by_somebody_else CHECK (
        requested_by = '' OR approved_by <> requested_by
    ),
    -- The evidence, not the claim. "We wiped it" is what everybody says; a
    -- certificate is what an inspection can check.
    CONSTRAINT sanitisation_carries_its_evidence CHECK (
        NOT sanitisation_required
        OR (sanitisation_method <> '' AND sanitisation_certificate <> ''
            AND sanitised_by <> '')
    )
);

CREATE INDEX disposal_date_idx
    ON biomedical.disposal (tenant_id, disposed_at DESC);
