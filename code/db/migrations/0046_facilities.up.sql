-- 0046 Facilities engineering operations (SRS-FAC-001 … 011).
--
-- Trace: SRS-FAC-001 … SRS-FAC-011. SRS-FAC-012's escalation matrix is
-- platform_escalation's and is not repeated here.
--
-- Four composite foreign keys carry a denormalised column, which is the
-- unusual shape in this file and is deliberate every time. A CHECK constraint
-- can only see the row it is on, so a rule that depends on a fact in another
-- table is not expressible as a CHECK unless the fact is copied onto the row.
-- Copying invites drift, and the composite foreign key is what removes it: the
-- copy must match the original or the row cannot exist, and ON UPDATE CASCADE
-- rewrites every copy when the original changes.
--
--   work_order carries class_requires_permit and class_requires_loto beside
--   class_code, held to work_class (code, requires_permit, requires_loto). The
--   rule it buys is SRS-FAC-010's acceptance: an unsafe work class cannot
--   close without its permit-to-work and lockout-tagout references. The
--   cascade means a hospital that marks a class unsafe after an incident
--   cannot leave already-closed orders of that class sitting without
--   paperwork — the update fails instead, which is the honest outcome.
--
--   task carries schedule_kind and schedule_requires_evidence, held to
--   schedule (id, kind, requires_evidence). SRS-FAC-003 asks that evidence be
--   reportable; this makes it unwritable-without, so the report cannot be
--   wrong. A statutory inspection additionally cannot be marked done without a
--   certificate and an expiry, and cannot be waived at all.
--
--   outage_area carries outage_system and outage_state, held to outage
--   (id, system, state). With the cascade, an outage taking effect rewrites
--   its own area rows, which is what makes the partial unique index below
--   possible: two shutdowns of one system cannot be in effect over one
--   department at once. Without the copy that rule lives in whichever client
--   remembers to check.
--
--   vendor_visit carries work_requires_permit, held to work_order
--   (id, class_requires_permit), so a contractor doing permit work must have a
--   recorded site induction. Contractors are the people least likely to know
--   the building and most likely to be the ones isolating something.
--
-- Two tables are append-only and are registered with FIT-08: meter_reading and
-- runtime_reading. A consumption series or an hour-counter history that can be
-- edited is one that agrees with whatever the last service claimed, and both
-- are evidence behind decisions somebody will later be asked to justify.
--
-- Rollback: drops the schema. Every asset, work order, permit, inspection,
-- reading, alarm, deficiency and contractor visit goes with it. There is no
-- partial rollback because the composite keys above mean the tables cannot be
-- dropped independently, and because a facilities history with its permits
-- removed is worse than none.
--
-- Reconciliation: the tables are new, so the previous version of the service
-- writes nothing here and there is nothing to reconcile on the way in. On the
-- way back out, the platform_escalation notices raised against facilities
-- subjects survive the drop and point at subject ids that no longer resolve;
-- they are closed by the escalation sweep rather than deleted, which leaves
-- the record of who was told intact.

CREATE SCHEMA IF NOT EXISTS facilities;

-- ------------------------------------------------- work classes (SRS-FAC-010)

CREATE TABLE facilities.work_class (
    tenant_id       uuid        NOT NULL,
    code            text        NOT NULL,
    name            text        NOT NULL,
    requires_permit boolean     NOT NULL DEFAULT false,
    requires_loto   boolean     NOT NULL DEFAULT false,
    active          boolean     NOT NULL DEFAULT true,
    note            text        NOT NULL DEFAULT '',
    created_at      timestamptz NOT NULL DEFAULT now(),

    PRIMARY KEY (tenant_id, code),

    CONSTRAINT a_work_class_names_itself
        CHECK (code <> '' AND name <> ''),
    -- A class somebody marked unsafe without saying why is one the next
    -- person to review the list will quietly unmark.
    CONSTRAINT an_unsafe_class_says_why
        CHECK (NOT (requires_permit OR requires_loto) OR note <> ''),

    -- The target of work_order's composite key. A plain unique index rather
    -- than anything clever: the primary key already covers (tenant_id, code),
    -- and this adds the two flags so the referencing row must agree with them.
    CONSTRAINT work_class_safety_key
        UNIQUE (tenant_id, code, requires_permit, requires_loto)
);

-- ------------------------------------------------------- assets (SRS-FAC-001)

CREATE TABLE facilities.asset (
    id              uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    tag             text        NOT NULL,
    name            text        NOT NULL,
    system          text        NOT NULL,
    criticality     text        NOT NULL,
    parent_id       uuid        REFERENCES facilities.asset (id),
    facility_id     uuid,
    location_id     uuid,
    location_note   text        NOT NULL DEFAULT '',
    status          text        NOT NULL,
    status_reason   text        NOT NULL DEFAULT '',
    status_at       timestamptz NOT NULL,
    manufacturer    text        NOT NULL DEFAULT '',
    model           text        NOT NULL DEFAULT '',
    serial_number   text        NOT NULL DEFAULT '',
    commissioned_at timestamptz,
    runtime_hours   integer     NOT NULL DEFAULT 0,
    runtime_at      timestamptz,
    created_at      timestamptz NOT NULL DEFAULT now(),
    created_by      text        NOT NULL,
    version         bigint      NOT NULL DEFAULT 1,

    CONSTRAINT an_asset_carries_its_tag
        CHECK (tag <> '' AND name <> ''),
    CONSTRAINT an_asset_system_is_known
        CHECK (system IN ('electrical', 'hvac', 'plumbing', 'fire',
                          'medical_gas', 'lifts', 'water', 'effluent',
                          'power', 'other')),
    CONSTRAINT an_asset_criticality_is_known
        CHECK (criticality IN ('life', 'high', 'normal', 'low')),
    CONSTRAINT an_asset_status_is_known
        CHECK (status IN ('in_service', 'degraded', 'down',
                          'decommissioned')),
    -- SRS-FAC-001's acceptance. An asset nobody can find is one nobody
    -- maintains, and it appears on every report as plant the hospital owns
    -- and never services.
    CONSTRAINT an_asset_says_where_it_is
        CHECK (location_id IS NOT NULL OR location_note <> ''),
    -- A machine marked down for no recorded reason is one nobody can chase.
    CONSTRAINT an_out_of_service_asset_says_why
        CHECK (status = 'in_service' OR status_reason <> ''),
    CONSTRAINT an_asset_is_not_its_own_parent
        CHECK (parent_id IS NULL OR parent_id <> id),
    CONSTRAINT an_asset_names_who_registered_it
        CHECK (created_by <> ''),
    CONSTRAINT runtime_hours_are_not_negative
        CHECK (runtime_hours >= 0)
);

-- The tag is what somebody reads off the machine. Two live assets with one
-- tag is a work order raised against whichever the search returned first.
-- Decommissioned plant keeps its tag but stops competing for it, because a
-- replacement usually inherits the stencil.
CREATE UNIQUE INDEX asset_tag_idx
    ON facilities.asset (tenant_id, tag)
    WHERE status <> 'decommissioned';

CREATE INDEX asset_parent_idx ON facilities.asset (tenant_id, parent_id);
CREATE INDEX asset_system_idx ON facilities.asset (tenant_id, system, status);

-- -------------------------------------------------- work orders (SRS-FAC-002)

CREATE TABLE facilities.work_order (
    id              uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    number          text        NOT NULL,
    facility_id     uuid,
    asset_id        uuid        REFERENCES facilities.asset (id),
    system          text        NOT NULL,
    location_id     uuid,
    location_note   text        NOT NULL DEFAULT '',
    fault           text        NOT NULL,
    impact          text        NOT NULL,
    priority        text        NOT NULL,

    class_code            text    NOT NULL,
    class_requires_permit boolean NOT NULL,
    class_requires_loto   boolean NOT NULL,

    owner_team      text        NOT NULL,
    owner_user_id   text        NOT NULL DEFAULT '',

    state           text        NOT NULL,
    raised_at       timestamptz NOT NULL,
    raised_by       text        NOT NULL,
    respond_by      timestamptz NOT NULL,
    resolve_by      timestamptz NOT NULL,
    responded_at    timestamptz,
    started_at      timestamptz,
    resolved_at     timestamptz,
    closed_at       timestamptz,
    closed_by       text        NOT NULL DEFAULT '',

    permit_ref       text       NOT NULL DEFAULT '',
    permit_issued_by text       NOT NULL DEFAULT '',
    loto_ref         text       NOT NULL DEFAULT '',
    loto_applied_by  text       NOT NULL DEFAULT '',

    completion_note  text       NOT NULL DEFAULT '',
    root_cause       text       NOT NULL DEFAULT '',
    downtime_minutes integer    NOT NULL DEFAULT 0,
    hold_reason      text       NOT NULL DEFAULT '',
    cancel_reason    text       NOT NULL DEFAULT '',

    created_at      timestamptz NOT NULL DEFAULT now(),
    version         bigint      NOT NULL DEFAULT 1,

    -- The composite key described in the header. Without the two copied
    -- flags, every CHECK below that mentions them would have to be a join.
    CONSTRAINT work_order_class_fk
        FOREIGN KEY (tenant_id, class_code,
                     class_requires_permit, class_requires_loto)
        REFERENCES facilities.work_class
                   (tenant_id, code, requires_permit, requires_loto)
        ON UPDATE CASCADE,

    -- The target of vendor_visit's composite key.
    CONSTRAINT work_order_permit_key
        UNIQUE (tenant_id, id, class_requires_permit),

    CONSTRAINT a_work_order_has_a_number
        CHECK (number <> ''),
    CONSTRAINT a_work_order_says_what_is_wrong
        CHECK (fault <> ''),
    -- Without impact every ticket is urgent, because every ticket matters to
    -- whoever raised it.
    CONSTRAINT a_work_order_says_what_it_is_stopping
        CHECK (impact <> ''),
    CONSTRAINT a_work_order_says_where_the_fault_is
        CHECK (location_id IS NOT NULL OR location_note <> ''),
    CONSTRAINT a_work_order_state_is_known
        CHECK (state IN ('raised', 'assigned', 'in_progress', 'on_hold',
                         'resolved', 'closed', 'cancelled')),
    CONSTRAINT a_work_order_priority_is_known
        CHECK (priority IN ('emergency', 'urgent', 'routine', 'planned')),
    CONSTRAINT a_work_order_system_is_known
        CHECK (system IN ('electrical', 'hvac', 'plumbing', 'fire',
                          'medical_gas', 'lifts', 'water', 'effluent',
                          'power', 'other')),
    -- SRS-FAC-002's acceptance: the ticket receives an owner and an SLA.
    CONSTRAINT a_work_order_is_routed
        CHECK (owner_team <> ''),
    CONSTRAINT a_work_order_names_who_raised_it
        CHECK (raised_by <> ''),
    CONSTRAINT work_being_done_names_who_took_it
        CHECK (state IN ('raised', 'cancelled') OR owner_user_id <> ''),

    -- SRS-FAC-010's acceptance, as two rules the application cannot skip.
    CONSTRAINT permit_work_does_not_close_without_its_permit
        CHECK (state <> 'closed' OR NOT class_requires_permit
               OR permit_ref <> ''),
    CONSTRAINT permit_work_does_not_close_without_its_isolation
        CHECK (state <> 'closed' OR NOT class_requires_loto
               OR loto_ref <> ''),
    CONSTRAINT a_permit_names_who_issued_it
        CHECK (permit_ref = '' OR permit_issued_by <> ''),
    CONSTRAINT an_isolation_names_who_applied_it
        CHECK (loto_ref = '' OR loto_applied_by <> ''),

    CONSTRAINT resolved_work_says_what_was_done
        CHECK (state NOT IN ('resolved', 'closed') OR completion_note <> ''),
    CONSTRAINT a_closed_work_order_names_who_closed_it
        CHECK (state <> 'closed' OR closed_by <> ''),
    -- One pair of eyes. Otherwise the maintenance history is a list of jobs
    -- that were all completed, signed by the person who completed them.
    CONSTRAINT work_is_not_signed_off_by_whoever_did_it
        CHECK (state <> 'closed' OR closed_by <> owner_user_id),
    CONSTRAINT a_held_work_order_says_what_it_waits_for
        CHECK (state <> 'on_hold' OR hold_reason <> ''),
    CONSTRAINT a_cancelled_work_order_says_why
        CHECK (state <> 'cancelled' OR cancel_reason <> ''),
    CONSTRAINT downtime_is_not_negative
        CHECK (downtime_minutes >= 0),
    -- A resolution target inside the response target is breached the moment
    -- it is met.
    CONSTRAINT sla_targets_are_ordered
        CHECK (resolve_by >= respond_by)
);

CREATE UNIQUE INDEX work_order_number_idx
    ON facilities.work_order (tenant_id, number);
CREATE INDEX work_order_open_idx
    ON facilities.work_order (tenant_id, state, priority, raised_at);
CREATE INDEX work_order_asset_idx
    ON facilities.work_order (tenant_id, asset_id, raised_at DESC);

-- ------------------------------ maintenance schedules (SRS-FAC-003/007)

CREATE TABLE facilities.schedule (
    id                     uuid        PRIMARY KEY,
    tenant_id              uuid        NOT NULL,
    asset_id               uuid        REFERENCES facilities.asset (id),
    facility_id            uuid,
    title                  text        NOT NULL,
    kind                   text        NOT NULL,
    trigger_kind           text        NOT NULL,
    interval_days          integer     NOT NULL DEFAULT 0,
    interval_runtime_hours integer     NOT NULL DEFAULT 0,
    authority              text        NOT NULL DEFAULT '',
    requires_evidence      boolean     NOT NULL DEFAULT false,
    work_class_code        text        NOT NULL DEFAULT '',
    grace_days             integer     NOT NULL DEFAULT 0,
    active                 boolean     NOT NULL DEFAULT true,
    last_done_at           timestamptz,
    last_done_hours        integer     NOT NULL DEFAULT 0,
    created_at             timestamptz NOT NULL,
    created_by             text        NOT NULL,
    version                bigint      NOT NULL DEFAULT 1,

    -- The target of task's composite key.
    CONSTRAINT schedule_evidence_key
        UNIQUE (tenant_id, id, kind, requires_evidence),

    CONSTRAINT a_schedule_has_a_title
        CHECK (title <> ''),
    CONSTRAINT a_schedule_kind_is_known
        CHECK (kind IN ('preventive', 'statutory')),
    CONSTRAINT a_schedule_trigger_is_known
        CHECK (trigger_kind IN ('calendar', 'runtime', 'either')),
    CONSTRAINT a_calendar_schedule_has_an_interval
        CHECK (trigger_kind = 'runtime' OR interval_days > 0),
    CONSTRAINT a_runtime_schedule_has_an_interval
        CHECK (trigger_kind = 'calendar' OR interval_runtime_hours > 0),
    -- Running hours belong to a machine. A runtime schedule against a
    -- building can never come due.
    CONSTRAINT a_runtime_schedule_names_its_asset
        CHECK (trigger_kind = 'calendar' OR asset_id IS NOT NULL),
    -- "Statutory" with nobody named is a schedule that will be deferred like
    -- any other.
    CONSTRAINT a_statutory_inspection_names_its_authority
        CHECK (kind <> 'statutory' OR authority <> ''),
    -- And one whose evidence is optional is one that will be marked done on
    -- the day the inspector did not come.
    CONSTRAINT a_statutory_inspection_is_evidenced
        CHECK (kind <> 'statutory' OR requires_evidence),
    CONSTRAINT grace_is_not_negative
        CHECK (grace_days >= 0),
    CONSTRAINT a_schedule_names_who_created_it
        CHECK (created_by <> '')
);

CREATE INDEX schedule_asset_idx ON facilities.schedule (tenant_id, asset_id);

CREATE TABLE facilities.task (
    id                       uuid        PRIMARY KEY,
    tenant_id                uuid        NOT NULL,
    schedule_id              uuid        NOT NULL,
    asset_id                 uuid        REFERENCES facilities.asset (id),
    facility_id              uuid,
    title                    text        NOT NULL,

    schedule_kind             text    NOT NULL,
    schedule_requires_evidence boolean NOT NULL,

    due_at                   timestamptz,
    due_runtime_hours        integer     NOT NULL DEFAULT 0,
    triggered_by             text        NOT NULL,
    state                    text        NOT NULL,
    done_at                  timestamptz,
    done_by                  text        NOT NULL DEFAULT '',
    findings                 text        NOT NULL DEFAULT '',
    evidence_ref             text        NOT NULL DEFAULT '',
    certificate_ref          text        NOT NULL DEFAULT '',
    certificate_expires_at   timestamptz,
    waived_reason            text        NOT NULL DEFAULT '',
    work_order_id            uuid        REFERENCES facilities.work_order (id),
    created_at               timestamptz NOT NULL DEFAULT now(),
    version                  bigint      NOT NULL DEFAULT 1,

    CONSTRAINT task_schedule_fk
        FOREIGN KEY (tenant_id, schedule_id,
                     schedule_kind, schedule_requires_evidence)
        REFERENCES facilities.schedule
                   (tenant_id, id, kind, requires_evidence)
        ON UPDATE CASCADE,

    CONSTRAINT a_task_state_is_known
        CHECK (state IN ('planned', 'done', 'missed', 'waived')),
    CONSTRAINT a_task_trigger_is_known
        CHECK (triggered_by IN ('calendar', 'runtime', 'either')),
    -- A task due neither on a date nor at a reading never appears on any list.
    CONSTRAINT a_task_is_due_on_a_date_or_a_reading
        CHECK (due_at IS NOT NULL OR due_runtime_hours > 0),
    CONSTRAINT a_completed_task_records_what_was_found
        CHECK (state <> 'done' OR findings <> ''),
    CONSTRAINT a_completed_task_names_who_did_it
        CHECK (state <> 'done' OR done_by <> ''),
    -- SRS-FAC-003's acceptance made unwritable-without, so the report of what
    -- is evidenced cannot be wrong.
    CONSTRAINT an_evidenced_task_closes_with_evidence
        CHECK (state <> 'done' OR NOT schedule_requires_evidence
               OR evidence_ref <> ''),
    CONSTRAINT a_statutory_inspection_closes_with_a_certificate
        CHECK (state <> 'done' OR schedule_kind <> 'statutory'
               OR (certificate_ref <> ''
                   AND certificate_expires_at IS NOT NULL)),
    -- A hospital cannot waive its own lift inspection. If it genuinely
    -- cannot happen, the schedule is what changes, with a name on it.
    CONSTRAINT a_statutory_inspection_is_not_waived
        CHECK (state <> 'waived' OR schedule_kind <> 'statutory'),
    CONSTRAINT a_waived_task_says_why
        CHECK (state <> 'waived' OR (waived_reason <> '' AND done_by <> ''))
);

-- Two planned filter changes for one AHU means somebody does it twice or
-- nobody does. One open occurrence per schedule at a time.
CREATE UNIQUE INDEX task_one_open_per_schedule_idx
    ON facilities.task (tenant_id, schedule_id)
    WHERE state = 'planned';

CREATE INDEX task_due_idx
    ON facilities.task (tenant_id, state, due_at);

-- ----------------------------------------- runtime counters (SRS-FAC-007)

-- Append-only (FIT-08). A history that can be edited agrees with whatever the
-- last service claimed.
CREATE TABLE facilities.runtime_reading (
    id               uuid        PRIMARY KEY,
    tenant_id        uuid        NOT NULL,
    asset_id         uuid        NOT NULL REFERENCES facilities.asset (id),
    hours            integer     NOT NULL,
    read_at          timestamptz NOT NULL,
    source           text        NOT NULL,
    source_ref       text        NOT NULL DEFAULT '',
    recorded_by      text        NOT NULL,
    counter_replaced boolean     NOT NULL DEFAULT false,
    note             text        NOT NULL DEFAULT '',
    created_at       timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT a_runtime_reading_is_not_negative
        CHECK (hours >= 0),
    CONSTRAINT a_runtime_source_is_known
        CHECK (source IN ('manual', 'scada', 'bms', 'ami', 'vendor',
                          'calculated')),
    -- An automated reading with no reference cannot be traced back to the
    -- gateway that produced it, which is what makes it worth more than a
    -- typed one in the first place.
    CONSTRAINT an_automated_runtime_reading_names_its_source
        CHECK (source = 'manual' OR source_ref <> ''),
    CONSTRAINT a_runtime_reading_names_who_recorded_it
        CHECK (recorded_by <> ''),
    -- The one legitimate reason a cumulative reading goes backwards.
    CONSTRAINT a_replaced_counter_says_what_happened
        CHECK (NOT counter_replaced OR note <> '')
);

CREATE INDEX runtime_reading_asset_idx
    ON facilities.runtime_reading (tenant_id, asset_id, read_at DESC);

-- --------------------------------- utility metering and KPIs (SRS-FAC-009)

CREATE TABLE facilities.meter (
    id           uuid        PRIMARY KEY,
    tenant_id    uuid        NOT NULL,
    code         text        NOT NULL,
    name         text        NOT NULL DEFAULT '',
    utility      text        NOT NULL,
    unit         text        NOT NULL,
    facility_id  uuid,
    location_id  uuid,
    asset_id     uuid        REFERENCES facilities.asset (id),
    source       text        NOT NULL,
    source_ref   text        NOT NULL DEFAULT '',
    cumulative   boolean     NOT NULL DEFAULT true,
    register_max integer     NOT NULL DEFAULT 0,
    active       boolean     NOT NULL DEFAULT true,
    created_at   timestamptz NOT NULL DEFAULT now(),
    created_by   text        NOT NULL,
    version      bigint      NOT NULL DEFAULT 1,

    CONSTRAINT a_meter_has_a_code
        CHECK (code <> ''),
    CONSTRAINT a_meter_utility_is_known
        CHECK (utility IN ('electricity', 'water', 'diesel', 'oxygen',
                           'lpg', 'steam', 'effluent')),
    -- A number with no unit is not a measurement.
    CONSTRAINT a_meter_declares_its_unit
        CHECK (unit <> ''),
    CONSTRAINT a_meter_source_is_known
        CHECK (source IN ('manual', 'scada', 'bms', 'ami', 'vendor',
                          'calculated')),
    CONSTRAINT an_automated_meter_names_its_source
        CHECK (source = 'manual' OR source_ref <> ''),
    CONSTRAINT a_register_maximum_is_not_negative
        CHECK (register_max >= 0),
    -- A maximum on an instantaneous meter is a rule that would fire on a
    -- perfectly good reading.
    CONSTRAINT only_a_cumulative_meter_wraps
        CHECK (register_max = 0 OR cumulative)
);

CREATE UNIQUE INDEX meter_code_idx
    ON facilities.meter (tenant_id, code)
    WHERE active;

-- Append-only (FIT-08), for the reason runtime_reading is.
CREATE TABLE facilities.meter_reading (
    id          uuid        PRIMARY KEY,
    tenant_id   uuid        NOT NULL,
    meter_id    uuid        NOT NULL REFERENCES facilities.meter (id),
    value       integer     NOT NULL,
    read_at     timestamptz NOT NULL,
    source      text        NOT NULL,
    source_ref  text        NOT NULL DEFAULT '',
    recorded_by text        NOT NULL,
    rolled_over boolean     NOT NULL DEFAULT false,
    note        text        NOT NULL DEFAULT '',
    created_at  timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT a_reading_is_not_negative
        CHECK (value >= 0),
    CONSTRAINT a_reading_source_is_known
        CHECK (source IN ('manual', 'scada', 'bms', 'ami', 'vendor',
                          'calculated')),
    -- SRS-FAC-009's acceptance: metrics retain meter and source provenance.
    -- The reading's own source rather than the meter's, because the night the
    -- gateway was down somebody read the dial.
    CONSTRAINT an_automated_reading_names_its_source
        CHECK (source = 'manual' OR source_ref <> ''),
    CONSTRAINT a_reading_names_who_recorded_it
        CHECK (recorded_by <> '')
);

CREATE INDEX meter_reading_meter_idx
    ON facilities.meter_reading (tenant_id, meter_id, read_at);

-- ----------------------------------------- planned outages (SRS-FAC-004)

CREATE TABLE facilities.outage (
    id           uuid        PRIMARY KEY,
    tenant_id    uuid        NOT NULL,
    reference    text        NOT NULL,
    facility_id  uuid,
    system       text        NOT NULL,
    title        text        NOT NULL,
    reason       text        NOT NULL,
    planned_from timestamptz NOT NULL,
    planned_to   timestamptz NOT NULL,
    actual_from  timestamptz,
    actual_to    timestamptz,
    state        text        NOT NULL,
    requested_by text        NOT NULL,
    requested_at timestamptz NOT NULL,
    approved_by  text        NOT NULL DEFAULT '',
    approved_at  timestamptz,
    permit_ref   text        NOT NULL DEFAULT '',
    contingency  text        NOT NULL DEFAULT '',
    restored_by  text        NOT NULL DEFAULT '',
    cancel_reason text       NOT NULL DEFAULT '',
    created_at   timestamptz NOT NULL DEFAULT now(),
    version      bigint      NOT NULL DEFAULT 1,

    -- The target of outage_area's composite key.
    CONSTRAINT outage_state_key
        UNIQUE (tenant_id, id, system, state),

    CONSTRAINT an_outage_has_a_reference
        CHECK (reference <> '' AND title <> ''),
    CONSTRAINT an_outage_says_why_the_supply_goes_off
        CHECK (reason <> ''),
    CONSTRAINT an_outage_system_is_known
        CHECK (system IN ('electrical', 'hvac', 'plumbing', 'fire',
                          'medical_gas', 'lifts', 'water', 'effluent',
                          'power', 'other')),
    CONSTRAINT an_outage_state_is_known
        CHECK (state IN ('planned', 'approved', 'in_effect', 'restored',
                         'cancelled')),
    CONSTRAINT an_outage_ends_after_it_starts
        CHECK (planned_to > planned_from),
    CONSTRAINT an_outage_names_who_requested_it
        CHECK (requested_by <> ''),
    CONSTRAINT an_approved_outage_names_who_approved_it
        CHECK (state IN ('planned', 'cancelled') OR approved_by <> ''),
    -- The whole value of a permit is that somebody else looked.
    CONSTRAINT an_outage_is_not_approved_by_whoever_asked_for_it
        CHECK (approved_by = '' OR approved_by <> requested_by),
    -- Taking the medical gas or the fire system off needs a permit to work
    -- behind it, not just an estates note.
    CONSTRAINT a_life_safety_shutdown_names_its_permit
        CHECK (state IN ('planned', 'cancelled')
               OR system NOT IN ('medical_gas', 'fire')
               OR permit_ref <> ''),
    CONSTRAINT an_outage_in_effect_records_when_it_started
        CHECK (state NOT IN ('in_effect', 'restored')
               OR actual_from IS NOT NULL),
    CONSTRAINT a_restored_outage_names_who_restored_it
        CHECK (state <> 'restored' OR restored_by <> ''),
    CONSTRAINT a_cancelled_outage_says_why
        CHECK (state <> 'cancelled' OR cancel_reason <> '')
);

CREATE UNIQUE INDEX outage_reference_idx
    ON facilities.outage (tenant_id, reference);

CREATE TABLE facilities.outage_area (
    id              uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    outage_id       uuid        NOT NULL,
    org_unit_id     uuid,
    name            text        NOT NULL DEFAULT '',
    critical        boolean     NOT NULL DEFAULT false,

    outage_system   text        NOT NULL,
    outage_state    text        NOT NULL,

    notified_at     timestamptz,
    acknowledged_at timestamptz,
    acknowledged_by text        NOT NULL DEFAULT '',
    objection       text        NOT NULL DEFAULT '',
    created_at      timestamptz NOT NULL DEFAULT now(),
    version         bigint      NOT NULL DEFAULT 1,

    CONSTRAINT outage_area_outage_fk
        FOREIGN KEY (tenant_id, outage_id, outage_system, outage_state)
        REFERENCES facilities.outage (tenant_id, id, system, state)
        ON UPDATE CASCADE,

    CONSTRAINT an_area_names_a_department_or_itself
        CHECK (org_unit_id IS NOT NULL OR name <> ''),
    -- An acknowledgement of a notice nobody sent is a row that makes an
    -- unnotified outage look consulted.
    CONSTRAINT an_acknowledgement_follows_a_notice
        CHECK (acknowledged_at IS NULL OR notified_at IS NOT NULL),
    CONSTRAINT an_acknowledged_area_names_who_answered
        CHECK (acknowledged_at IS NULL OR acknowledged_by <> '')
);

-- Two shutdowns of one system cannot be in effect over one department at
-- once. Only possible because outage_area carries the outage's system and
-- state, cascaded from the outage itself.
CREATE UNIQUE INDEX outage_area_one_live_shutdown_idx
    ON facilities.outage_area (tenant_id, org_unit_id, outage_system)
    WHERE outage_state = 'in_effect' AND org_unit_id IS NOT NULL;

CREATE INDEX outage_area_outage_idx
    ON facilities.outage_area (tenant_id, outage_id);

-- ------------------------------------------- SCADA alarms (SRS-FAC-005)

CREATE TABLE facilities.alarm (
    id              uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    gateway_id      text        NOT NULL,
    point_ref       text        NOT NULL,
    external_id     text        NOT NULL,
    asset_id        uuid        REFERENCES facilities.asset (id),
    facility_id     uuid,
    system          text        NOT NULL,
    severity        text        NOT NULL,
    message         text        NOT NULL,
    source          text        NOT NULL,
    raised_at       timestamptz NOT NULL,
    cleared_at      timestamptz,
    state           text        NOT NULL,
    acknowledged_at timestamptz,
    acknowledged_by text        NOT NULL DEFAULT '',
    work_order_id   uuid        REFERENCES facilities.work_order (id),
    linked_at       timestamptz,
    linked_by       text        NOT NULL DEFAULT '',
    created_at      timestamptz NOT NULL DEFAULT now(),
    version         bigint      NOT NULL DEFAULT 1,

    CONSTRAINT an_alarm_names_its_origin
        CHECK (gateway_id <> '' AND point_ref <> '' AND message <> ''),
    -- A gateway reconnecting after a network drop replays everything it
    -- buffered, and without this there is no way to recognise a replay.
    CONSTRAINT an_alarm_carries_the_gateways_event_id
        CHECK (external_id <> ''),
    CONSTRAINT an_alarm_system_is_known
        CHECK (system IN ('electrical', 'hvac', 'plumbing', 'fire',
                          'medical_gas', 'lifts', 'water', 'effluent',
                          'power', 'other')),
    CONSTRAINT an_alarm_severity_is_known
        CHECK (severity IN ('critical', 'major', 'minor', 'info')),
    CONSTRAINT an_alarm_state_is_known
        CHECK (state IN ('active', 'cleared')),
    -- Letting somebody type an alarm would put fabricated plant events into
    -- the record the command centre trusts because it came off the gateway.
    CONSTRAINT an_alarm_comes_from_plant_not_people
        CHECK (source <> 'manual'),
    CONSTRAINT an_alarm_source_is_known
        CHECK (source IN ('scada', 'bms', 'ami', 'vendor', 'calculated')),
    CONSTRAINT a_cleared_alarm_says_when
        CHECK (state <> 'cleared' OR cleared_at IS NOT NULL),
    CONSTRAINT an_acknowledged_alarm_names_who
        CHECK (acknowledged_at IS NULL OR acknowledged_by <> ''),
    CONSTRAINT a_linked_alarm_says_who_linked_it
        CHECK (work_order_id IS NULL
               OR (linked_at IS NOT NULL AND linked_by <> ''))
);

-- A replayed buffer must not produce a second alarm.
CREATE UNIQUE INDEX alarm_gateway_event_idx
    ON facilities.alarm (tenant_id, gateway_id, external_id);

CREATE INDEX alarm_open_idx
    ON facilities.alarm (tenant_id, state, severity, raised_at DESC);

CREATE TABLE facilities.alarm_rule (
    id           uuid        PRIMARY KEY,
    tenant_id    uuid        NOT NULL,
    facility_id  uuid,
    system       text        NOT NULL,
    min_severity text        NOT NULL,
    priority     text        NOT NULL,
    class_code   text        NOT NULL,
    owner_team   text        NOT NULL,
    active       boolean     NOT NULL DEFAULT true,
    created_at   timestamptz NOT NULL DEFAULT now(),
    created_by   text        NOT NULL,

    CONSTRAINT an_alarm_rule_system_is_known
        CHECK (system IN ('electrical', 'hvac', 'plumbing', 'fire',
                          'medical_gas', 'lifts', 'water', 'effluent',
                          'power', 'other')),
    CONSTRAINT an_alarm_rule_severity_is_known
        CHECK (min_severity IN ('critical', 'major', 'minor', 'info')),
    CONSTRAINT an_alarm_rule_priority_is_known
        CHECK (priority IN ('emergency', 'urgent', 'routine', 'planned')),
    CONSTRAINT an_alarm_rule_names_its_work
        CHECK (class_code <> '' AND owner_team <> '')
);

CREATE INDEX alarm_rule_match_idx
    ON facilities.alarm_rule (tenant_id, system, active);

-- ------------------------------ fire and life-safety findings (SRS-FAC-008)

CREATE TABLE facilities.deficiency (
    id                   uuid        PRIMARY KEY,
    tenant_id            uuid        NOT NULL,
    task_id              uuid        REFERENCES facilities.task (id),
    asset_id             uuid        REFERENCES facilities.asset (id),
    facility_id          uuid,
    location_id          uuid,
    location_note        text        NOT NULL DEFAULT '',
    system               text        NOT NULL,
    severity             text        NOT NULL,
    finding              text        NOT NULL,
    standard             text        NOT NULL DEFAULT '',
    state                text        NOT NULL,
    raised_at            timestamptz NOT NULL,
    raised_by            text        NOT NULL,
    due_at               timestamptz,
    work_order_id        uuid        REFERENCES facilities.work_order (id),
    mitigation_note      text        NOT NULL DEFAULT '',
    mitigated_at         timestamptz,
    mitigated_by         text        NOT NULL DEFAULT '',
    closed_at            timestamptz,
    closed_by            text        NOT NULL DEFAULT '',
    closure_evidence_ref text        NOT NULL DEFAULT '',
    created_at           timestamptz NOT NULL DEFAULT now(),
    version              bigint      NOT NULL DEFAULT 1,

    CONSTRAINT a_deficiency_says_what_is_deficient
        CHECK (finding <> ''),
    CONSTRAINT a_deficiency_says_where_it_is
        CHECK (location_id IS NOT NULL OR location_note <> ''
               OR asset_id IS NOT NULL),
    CONSTRAINT a_deficiency_system_is_known
        CHECK (system IN ('electrical', 'hvac', 'plumbing', 'fire',
                          'medical_gas', 'lifts', 'water', 'effluent',
                          'power', 'other')),
    -- Something is either a breach or an observation, and the second one is a
    -- note on the inspection.
    CONSTRAINT a_deficiency_is_at_least_minor
        CHECK (severity IN ('critical', 'major', 'minor')),
    CONSTRAINT a_deficiency_state_is_known
        CHECK (state IN ('open', 'mitigated', 'closed')),
    CONSTRAINT a_deficiency_names_who_raised_it
        CHECK (raised_by <> ''),
    -- A critical deficiency that is only a note is one nobody is assigned to,
    -- and one with no date is one that is never late.
    CONSTRAINT a_critical_deficiency_has_work_raised
        CHECK (severity <> 'critical' OR work_order_id IS NOT NULL),
    CONSTRAINT a_critical_deficiency_has_a_date
        CHECK (severity <> 'critical' OR due_at IS NOT NULL),
    -- "Mitigated" with nothing said is a deficiency that has been downgraded
    -- rather than managed.
    CONSTRAINT a_mitigated_deficiency_says_what_is_in_place
        CHECK (state <> 'mitigated'
               OR (mitigation_note <> '' AND mitigated_by <> '')),
    CONSTRAINT a_closed_deficiency_names_who_closed_it
        CHECK (state <> 'closed' OR closed_by <> ''),
    -- SRS-FAC-008: a critical finding does not close on somebody's word, and
    -- not on the word of the person who found it.
    CONSTRAINT a_critical_deficiency_closes_with_evidence
        CHECK (state <> 'closed' OR severity <> 'critical'
               OR closure_evidence_ref <> ''),
    CONSTRAINT a_critical_deficiency_is_not_closed_by_its_finder
        CHECK (state <> 'closed' OR severity <> 'critical'
               OR closed_by <> raised_by)
);

-- The list SRS-FAC-008's acceptance is about. Indexed on the open states so
-- that the query behind "what critical findings are outstanding" stays cheap
-- enough that nobody is tempted to age it out.
CREATE INDEX deficiency_open_critical_idx
    ON facilities.deficiency (tenant_id, severity, state, due_at)
    WHERE state <> 'closed';

CREATE INDEX deficiency_task_idx
    ON facilities.deficiency (tenant_id, task_id);

-- --------------------------------------- contractor visits (SRS-FAC-011)

CREATE TABLE facilities.vendor_visit (
    id                 uuid        PRIMARY KEY,
    tenant_id          uuid        NOT NULL,
    vendor_name        text        NOT NULL,
    vendor_ref         text        NOT NULL DEFAULT '',
    contact_name       text        NOT NULL DEFAULT '',
    technicians        text[]      NOT NULL DEFAULT '{}',
    facility_id        uuid,
    work_order_id      uuid,
    asset_id           uuid        REFERENCES facilities.asset (id),
    task_id            uuid        REFERENCES facilities.task (id),

    work_requires_permit boolean   NOT NULL DEFAULT false,
    induction_ref        text      NOT NULL DEFAULT '',

    purpose            text        NOT NULL,
    state              text        NOT NULL,
    signed_in_at       timestamptz NOT NULL,
    signed_in_by       text        NOT NULL,
    signed_out_at      timestamptz,
    signed_out_by      text        NOT NULL DEFAULT '',
    service_report_ref text        NOT NULL DEFAULT '',
    report_summary     text        NOT NULL DEFAULT '',
    parts_used         text[]      NOT NULL DEFAULT '{}',
    follow_up          text        NOT NULL DEFAULT '',
    created_at         timestamptz NOT NULL DEFAULT now(),
    version            bigint      NOT NULL DEFAULT 1,

    -- MATCH SIMPLE: with a null work_order_id the key is not checked, which
    -- is why the CHECK below insists that permit work names one.
    CONSTRAINT vendor_visit_work_order_fk
        FOREIGN KEY (tenant_id, work_order_id, work_requires_permit)
        REFERENCES facilities.work_order
                   (tenant_id, id, class_requires_permit)
        ON UPDATE CASCADE,

    CONSTRAINT a_visit_names_the_contractor
        CHECK (vendor_name <> ''),
    -- SRS-FAC-011's acceptance. A contractor who came, did something to the
    -- plant and left with no record of which plant is why a maintenance
    -- history has gaps nobody can explain when the machine fails.
    CONSTRAINT a_visit_is_linked_to_work_an_asset_or_a_task
        CHECK (work_order_id IS NOT NULL OR asset_id IS NOT NULL
               OR task_id IS NOT NULL),
    -- A visit by nobody in particular cannot be matched against the induction
    -- record, the gate log, or the roll call during an evacuation.
    CONSTRAINT a_visit_names_who_came
        CHECK (cardinality(technicians) > 0),
    CONSTRAINT a_visit_says_what_it_is_for
        CHECK (purpose <> ''),
    CONSTRAINT a_visit_state_is_known
        CHECK (state IN ('on_site', 'departed')),
    CONSTRAINT a_visit_names_who_signed_it_in
        CHECK (signed_in_by <> ''),
    -- SRS-FAC-010 reaching the people least likely to know the building.
    CONSTRAINT permit_work_names_the_contractors_induction
        CHECK (NOT work_requires_permit OR induction_ref <> ''),
    CONSTRAINT permit_work_names_its_work_order
        CHECK (NOT work_requires_permit OR work_order_id IS NOT NULL),
    -- The report is what SRS-FAC-011 asks to be kept; the summary is what
    -- appears in the asset's history, because the reference points at a PDF
    -- nobody will open.
    CONSTRAINT a_departed_visit_carries_its_service_report
        CHECK (state <> 'departed'
               OR (service_report_ref <> '' AND report_summary <> '')),
    CONSTRAINT a_departed_visit_names_who_signed_it_out
        CHECK (state <> 'departed' OR signed_out_by <> '')
);

CREATE INDEX vendor_visit_on_site_idx
    ON facilities.vendor_visit (tenant_id, state, signed_in_at);
CREATE INDEX vendor_visit_work_idx
    ON facilities.vendor_visit (tenant_id, work_order_id);
CREATE INDEX vendor_visit_asset_idx
    ON facilities.vendor_visit (tenant_id, asset_id);
