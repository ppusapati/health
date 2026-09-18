-- 0031 The operating theatre (SRS-OT-001 … 017).
--
-- Like the emergency department and critical care, the theatre keeps no
-- patient of its own: a case is the perioperative detail of a Wave-1
-- encounter.
--
-- Five shapes here are unusual and deliberate.
--
-- Nothing stores a duration. Turnover, operating time, theatre occupancy and
-- on-time starts are all derived from the milestone rows, because SRS-OT-015
-- says "metrics reconcile to recorded timestamps" and a stored utilisation
-- figure is one that can disagree with the cases it came from.
--
-- A cancellation carries a coded cause as a CHECK, not a free-text field.
-- SRS-OT-005's clause is that analytics distinguish patient, clinical,
-- resource and administrative causes, and the fixes for "no bed" and "patient
-- did not attend" are different departments' work.
--
-- An operative note is versioned rather than updated. It is the document read
-- in a complaint, a claim and a coroner's court, and one whose history was
-- overwritten cannot answer what the surgeon wrote on the day.
--
-- An implant row carries a serial or a lot, enforced. A recall is traced
-- patient by patient, and an implant with neither is one nobody can find when
-- the manufacturer writes.
--
-- A tray use carries the sterilisation cycle it came out of. An infection is
-- investigated backwards from the patient, and a tray opened without its cycle
-- is the link that is missing for the case that matters.
--
-- Trace: SRS-OT-001 … SRS-OT-017.
--
-- Rollback: drops the schema. Every case, checklist, safety check, operative
-- note, implant record, specimen and tray link goes with it. The operative
-- note and the implant register are both records a hospital is required to
-- keep for years. Treat as a disaster-recovery action, never a deployment
-- step.
--
-- Reconciliation: the tables are new, so the previous version writes nothing
-- here and sees nothing missing. The direction to watch is the encounter: a
-- case created by the new version points at an encounter the old version
-- serves happily and shows no theatre detail for. A display gap during the
-- rollout window, closing when every replica is new.

CREATE SCHEMA IF NOT EXISTS theatre;

CREATE TABLE theatre.room (
    room_id     uuid        PRIMARY KEY,
    tenant_id   uuid        NOT NULL,
    facility_id text        NOT NULL DEFAULT '',
    code        text        NOT NULL CHECK (code <> ''),
    name        text        NOT NULL DEFAULT '',
    -- What the room is equipped for. Empty specialties means any: a hospital
    -- with one theatre should not have to enumerate every specialty it does.
    specialties text[]      NOT NULL DEFAULT '{}',
    equipment   text[]      NOT NULL DEFAULT '{}',
    active      boolean     NOT NULL DEFAULT true,

    UNIQUE (tenant_id, facility_id, code)
);

CREATE INDEX room_facility_idx ON theatre.room (tenant_id, facility_id);

CREATE TABLE theatre.block (
    block_id  uuid        PRIMARY KEY,
    tenant_id uuid        NOT NULL,
    room_id   uuid        NOT NULL REFERENCES theatre.room (room_id) ON DELETE CASCADE,

    -- Planned downtime is distinct from an unallocated gap, because a room
    -- that is closed is not a room somebody can be persuaded to open.
    kind text NOT NULL CHECK (kind IN ('list', 'downtime', 'emergency')),
    owner_id  text NOT NULL DEFAULT '',
    specialty text NOT NULL DEFAULT '',

    starts_at timestamptz NOT NULL,
    ends_at   timestamptz NOT NULL,
    note      text        NOT NULL DEFAULT '',

    CONSTRAINT a_block_ends_after_it_starts CHECK (ends_at > starts_at)
);

CREATE INDEX block_room_idx ON theatre.block (tenant_id, room_id, starts_at);

CREATE TABLE theatre.case (
    case_id      uuid        PRIMARY KEY,
    tenant_id    uuid        NOT NULL,
    encounter_id uuid        NOT NULL,
    patient_id   uuid        NOT NULL,
    facility_id  text        NOT NULL DEFAULT '',

    procedure_code    text NOT NULL CHECK (procedure_code <> ''),
    procedure_display text NOT NULL DEFAULT '',
    diagnosis_code    text NOT NULL DEFAULT '',
    diagnosis_display text NOT NULL DEFAULT '',

    -- Its own column, never a word in the procedure name. Wrong-site surgery
    -- is the never-event the whole checklist exists to prevent, and "left"
    -- buried in a sentence is not something a system can check.
    laterality text NOT NULL CHECK (laterality IN (
                   '', 'not_applicable', 'left', 'right', 'bilateral')),
    site       text NOT NULL DEFAULT '',

    urgency text NOT NULL CHECK (urgency IN ('elective', 'urgent', 'emergency')),
    -- A list built from guessed durations overruns, and an overrunning list
    -- cancels the case at the end of it.
    expected_duration_seconds bigint NOT NULL DEFAULT 0,

    surgeon_id       text   NOT NULL DEFAULT '',
    team             text[] NOT NULL DEFAULT '{}',
    requirements     text[] NOT NULL DEFAULT '{}',
    anaesthesia_type text   NOT NULL DEFAULT '',
    special_notes    text   NOT NULL DEFAULT '',

    status text NOT NULL CHECK (status IN (
               'requested', 'schedulable', 'scheduled', 'ready',
               'in_theatre', 'completed', 'postponed', 'cancelled')),

    room_id         uuid REFERENCES theatre.room (room_id),
    scheduled_start timestamptz,
    scheduled_end   timestamptz,

    -- Coded, because a free-text cause produces a report nobody can act on.
    outcome text NOT NULL DEFAULT '' CHECK (outcome IN (
                '', 'patient', 'clinical', 'resource', 'administrative')),
    outcome_reason text        NOT NULL DEFAULT '',
    outcome_note   text        NOT NULL DEFAULT '',
    outcome_at     timestamptz,

    requested_by text        NOT NULL CHECK (requested_by <> ''),
    requested_at timestamptz NOT NULL,
    updated_at   timestamptz NOT NULL,
    version      bigint      NOT NULL DEFAULT 1,

    CONSTRAINT a_scheduled_case_has_a_room_and_a_slot CHECK (
        status NOT IN ('scheduled', 'ready', 'in_theatre')
        OR (room_id IS NOT NULL AND scheduled_start IS NOT NULL
            AND scheduled_end IS NOT NULL)
    ),
    CONSTRAINT a_slot_ends_after_it_starts CHECK (
        scheduled_start IS NULL OR scheduled_end IS NULL
        OR scheduled_end > scheduled_start
    ),
    CONSTRAINT a_closed_case_names_a_coded_cause CHECK (
        status NOT IN ('cancelled', 'postponed')
        OR (outcome <> '' AND outcome_reason <> '')
    )
);

CREATE INDEX case_encounter_idx ON theatre.case (tenant_id, encounter_id);
CREATE INDEX case_patient_idx ON theatre.case (tenant_id, patient_id);
-- The day's list, which is what the board and the schedule read.
CREATE INDEX case_room_day_idx
    ON theatre.case (tenant_id, room_id, scheduled_start)
    WHERE status NOT IN ('completed', 'cancelled');
-- The waiting list: cases with no slot yet.
CREATE INDEX case_waiting_idx
    ON theatre.case (tenant_id, facility_id, urgency, requested_at)
    WHERE status IN ('requested', 'schedulable', 'postponed');
-- A surgeon's own diary, for the "operating elsewhere" check.
CREATE INDEX case_surgeon_idx
    ON theatre.case (tenant_id, surgeon_id, scheduled_start)
    WHERE status NOT IN ('completed', 'cancelled');

CREATE TABLE theatre.preop_entry (
    case_id uuid NOT NULL REFERENCES theatre.case (case_id) ON DELETE CASCADE,
    tenant_id uuid NOT NULL,
    code    text NOT NULL,

    state text NOT NULL CHECK (state IN (
              'met', 'unmet', 'waived', 'not_applicable')),
    note  text NOT NULL DEFAULT '',
    -- A waiver names who made it and in what role, because the role is what
    -- entitled them to.
    waived_by   text NOT NULL DEFAULT '',
    waived_role text NOT NULL DEFAULT '',

    recorded_by text        NOT NULL CHECK (recorded_by <> ''),
    recorded_at timestamptz NOT NULL,

    PRIMARY KEY (case_id, code),
    -- A waiver with no reason is a blocker somebody clicked past.
    CONSTRAINT a_waiver_names_a_role_and_a_reason CHECK (
        state <> 'waived' OR (waived_role <> '' AND note <> '')
    )
);

CREATE TABLE theatre.safety_check (
    check_id  uuid        PRIMARY KEY,
    tenant_id uuid        NOT NULL,
    case_id   uuid        NOT NULL REFERENCES theatre.case (case_id) ON DELETE CASCADE,

    phase text NOT NULL CHECK (phase IN ('sign_in', 'time_out', 'sign_out')),
    -- A time-out is the team stopping together. One person reading a list to
    -- themselves is the failure the "team confirmation" clause prevents.
    participants text[] NOT NULL CHECK (array_length(participants, 1) >= 2),

    performed_at timestamptz NOT NULL,
    performed_by text        NOT NULL CHECK (performed_by <> '')
);

CREATE INDEX safety_check_case_idx ON theatre.safety_check (tenant_id, case_id, phase);

CREATE TABLE theatre.safety_answer (
    check_id uuid NOT NULL
        REFERENCES theatre.safety_check (check_id) ON DELETE CASCADE,
    code      text    NOT NULL,
    confirmed boolean NOT NULL,
    -- SRS-OT-007's "missing item requires explicit exception": an unconfirmed
    -- item with no exception is a checklist completed by leaving things blank.
    exception text NOT NULL DEFAULT '',

    PRIMARY KEY (check_id, code),
    CONSTRAINT an_unconfirmed_item_has_an_exception CHECK (
        confirmed OR exception <> ''
    )
);

CREATE TABLE theatre.milestone (
    milestone_id uuid        PRIMARY KEY,
    tenant_id    uuid        NOT NULL,
    case_id      uuid        NOT NULL REFERENCES theatre.case (case_id) ON DELETE CASCADE,

    milestone text NOT NULL CHECK (milestone IN (
                  'pre_op', 'theatre_in', 'anaesthesia_start', 'incision',
                  'closure', 'theatre_out', 'pacu_in', 'pacu_out')),
    -- When the patient moved, and when somebody typed it. Separate, because a
    -- theatre list written up at the end of the day is a reconstruction and
    -- the gap is the only thing that says so.
    occurred_at timestamptz NOT NULL,
    recorded_at timestamptz NOT NULL,
    recorded_by text        NOT NULL CHECK (recorded_by <> ''),
    note        text        NOT NULL DEFAULT ''
);

CREATE INDEX milestone_case_idx ON theatre.milestone (tenant_id, case_id, occurred_at);

CREATE TABLE theatre.delay (
    delay_id  uuid        PRIMARY KEY,
    tenant_id uuid        NOT NULL,
    case_id   uuid        NOT NULL REFERENCES theatre.case (case_id) ON DELETE CASCADE,

    -- Coded, because "delay analytics are reportable without free-text-only
    -- classification" and the fixes for a late surgeon and a missing set of
    -- instruments are different departments' work.
    reason text NOT NULL CHECK (reason IN (
               'patient', 'surgeon', 'anaesthesia', 'nursing', 'equipment',
               'instruments', 'cleaning', 'bed', 'porters', 'previous_case',
               'emergency_insertion', 'other')),
    -- The department answerable. A theatre's delay report is read by the
    -- departments it names.
    dependency text    NOT NULL DEFAULT '',
    minutes    integer NOT NULL CHECK (minutes > 0),
    note       text    NOT NULL DEFAULT '',

    recorded_at timestamptz NOT NULL,
    recorded_by text        NOT NULL CHECK (recorded_by <> ''),

    CONSTRAINT other_delays_say_what_they_were CHECK (
        reason <> 'other' OR note <> ''
    )
);

CREATE INDEX delay_case_idx ON theatre.delay (tenant_id, case_id);

CREATE TABLE theatre.operative_note (
    note_id   uuid        PRIMARY KEY,
    tenant_id uuid        NOT NULL,
    case_id   uuid        NOT NULL REFERENCES theatre.case (case_id) ON DELETE CASCADE,

    -- Versioned rather than updated. An amendment is a new row pointing at the
    -- one it replaces, so the chain reads forwards.
    version    integer NOT NULL CHECK (version >= 1),
    supersedes uuid    REFERENCES theatre.operative_note (note_id),

    procedure_performed text NOT NULL CHECK (procedure_performed <> ''),
    findings            text NOT NULL DEFAULT '',
    -- Structured rather than buried in the narrative, because each list is
    -- read by a different department: pathology, the implant registry and
    -- governance.
    specimen_ids  text[] NOT NULL DEFAULT '{}',
    implant_ids   text[] NOT NULL DEFAULT '{}',
    complications text[] NOT NULL DEFAULT '{}',
    -- A number rather than a phrase: "minimal" means different things to
    -- different surgeons, and the transfusion service needs a figure.
    estimated_blood_loss_ml integer NOT NULL DEFAULT 0
        CHECK (estimated_blood_loss_ml >= 0),
    post_operative_orders text NOT NULL DEFAULT '',
    narrative             text NOT NULL DEFAULT '',

    status text NOT NULL CHECK (status IN (
               'draft', 'signed', 'amended', 'superseded')),
    amendment_reason text NOT NULL DEFAULT '',

    authored_by text        NOT NULL CHECK (authored_by <> ''),
    authored_at timestamptz NOT NULL,
    signed_by   text        NOT NULL DEFAULT '',
    signed_at   timestamptz,

    CONSTRAINT a_signed_note_names_who_signed CHECK (
        status = 'draft' OR (signed_by <> '' AND signed_at IS NOT NULL)
    ),
    -- An unexplained amendment to an operative note is the entry a claim asks
    -- about.
    CONSTRAINT an_amendment_has_a_reason CHECK (
        version = 1 OR amendment_reason <> ''
    )
);

CREATE INDEX operative_note_case_idx
    ON theatre.operative_note (tenant_id, case_id, version);
-- The note in force, which is what every screen asks for.
CREATE INDEX operative_note_current_idx
    ON theatre.operative_note (tenant_id, case_id)
    WHERE status <> 'superseded';

CREATE TABLE theatre.usage (
    usage_id  uuid        PRIMARY KEY,
    tenant_id uuid        NOT NULL,
    case_id   uuid        NOT NULL REFERENCES theatre.case (case_id) ON DELETE CASCADE,

    kind      text NOT NULL CHECK (kind IN ('consumable', 'implant')),
    item_code text NOT NULL CHECK (item_code <> ''),
    item_name text NOT NULL DEFAULT '',
    lot_number    text NOT NULL DEFAULT '',
    serial_number text NOT NULL DEFAULT '',
    quantity  integer NOT NULL CHECK (quantity > 0),
    expiry_date timestamptz,

    -- "Inventory decrement and patient charge are traceable to scan", which a
    -- typed item is not: it is traceable to somebody's memory.
    scanned   boolean NOT NULL DEFAULT false,
    scan_data text    NOT NULL DEFAULT '',

    recorded_at timestamptz NOT NULL,
    recorded_by text        NOT NULL CHECK (recorded_by <> ''),

    -- A recall is traced patient by patient. An implant with neither serial
    -- nor lot is one nobody can find when the manufacturer writes, and two
    -- implants against one serial is a record that cannot be traced.
    CONSTRAINT an_implant_is_traceable CHECK (
        kind <> 'implant' OR (serial_number <> '' OR lot_number <> '')
    ),
    CONSTRAINT implants_are_recorded_one_at_a_time CHECK (
        kind <> 'implant' OR quantity = 1
    )
);

CREATE INDEX usage_case_idx ON theatre.usage (tenant_id, case_id);
-- The implant register, which is what a recall is worked from.
CREATE INDEX usage_implant_idx
    ON theatre.usage (tenant_id, item_code, serial_number)
    WHERE kind = 'implant';

CREATE TABLE theatre.specimen (
    specimen_id uuid        PRIMARY KEY,
    tenant_id   uuid        NOT NULL,
    case_id     uuid        NOT NULL REFERENCES theatre.case (case_id) ON DELETE CASCADE,
    patient_id  uuid        NOT NULL,

    label text NOT NULL CHECK (label <> ''),
    -- The site is half of every histology report, and the half that cannot be
    -- reconstructed afterwards.
    site       text NOT NULL CHECK (site <> ''),
    laterality text NOT NULL DEFAULT '',
    container  text NOT NULL DEFAULT '',
    fixative   text NOT NULL DEFAULT '',

    -- The diagnostic order this specimen was raised against. NULL means the
    -- chain has not started, which is what the outstanding list looks for: a
    -- specimen in a pot with no order is the one found in a fridge on Monday.
    order_id uuid,

    taken_at timestamptz NOT NULL,
    taken_by text        NOT NULL CHECK (taken_by <> '')
);

CREATE INDEX specimen_case_idx ON theatre.specimen (tenant_id, case_id);
CREATE INDEX specimen_unaccessioned_idx
    ON theatre.specimen (tenant_id, taken_at)
    WHERE order_id IS NULL;

CREATE TABLE theatre.tray_use (
    tray_use_id uuid        PRIMARY KEY,
    tenant_id   uuid        NOT NULL,
    case_id     uuid        NOT NULL REFERENCES theatre.case (case_id) ON DELETE CASCADE,

    tray_id   text NOT NULL CHECK (tray_id <> ''),
    tray_name text NOT NULL DEFAULT '',
    -- Without the cycle there is no chain to trace back along, which is the
    -- whole of SRS-OT-012.
    cycle_id text NOT NULL CHECK (cycle_id <> ''),

    indicator_passed boolean NOT NULL,
    indicator_note   text    NOT NULL DEFAULT '',

    opened_at timestamptz NOT NULL,
    opened_by text        NOT NULL CHECK (opened_by <> ''),

    -- A failed indicator is a governance event. Recording it without saying
    -- what was done is worse than not recording it.
    CONSTRAINT a_failed_indicator_has_a_note CHECK (
        indicator_passed OR indicator_note <> ''
    )
);

CREATE INDEX tray_use_case_idx ON theatre.tray_use (tenant_id, case_id);
-- The direction an infection investigation runs: from a cycle to the patients
-- whose cases used it.
CREATE INDEX tray_use_cycle_idx ON theatre.tray_use (tenant_id, cycle_id);

CREATE TABLE theatre.preference_card (
    card_id   uuid        PRIMARY KEY,
    tenant_id uuid        NOT NULL,

    surgeon_id     text NOT NULL CHECK (surgeon_id <> ''),
    procedure_code text NOT NULL CHECK (procedure_code <> ''),
    name           text NOT NULL DEFAULT '',

    -- Suggestions only. A card seeds a case's requirements and never
    -- constrains what is actually used: a system that refused an instrument
    -- because it was not on the card would have theatre staff editing cards
    -- mid-case.
    equipment   text[] NOT NULL DEFAULT '{}',
    consumables jsonb  NOT NULL DEFAULT '[]'::jsonb,
    trays       text[] NOT NULL DEFAULT '{}',
    notes       text   NOT NULL DEFAULT '',

    version    integer     NOT NULL DEFAULT 1,
    updated_at timestamptz NOT NULL,
    updated_by text        NOT NULL DEFAULT '',

    UNIQUE (tenant_id, surgeon_id, procedure_code)
);
