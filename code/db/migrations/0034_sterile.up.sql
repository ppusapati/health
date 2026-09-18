-- 0034 Sterile services / CSSD (SRS-CSSD-001 … 012).
--
-- Five shapes here are unusual and deliberate.
--
-- A tray set is versioned rather than updated, with a partial unique index
-- holding "at most one current version per code". A pack assembled last month
-- was checked against the list as it was then, and overwriting the list makes
-- every historical pack unauditable against the only thing that could audit
-- it. The run row carries the version it was assembled against, not a foreign
-- key to whatever is current.
--
-- A run's stage is a text column with a CHECK, and the ordering rule lives in
-- the domain rather than in SQL. A CHECK cannot see the previous row, so a
-- constraint here could only restate the vocabulary; what it does enforce is
-- that a skipped stage names an authoriser and a reason, and that the two
-- unskippable stages are never marked skipped.
--
-- A pack's expiry is NOT NULL once it has been sterilised. A missing expiry
-- reads as "never expires" to every query that filters on it, which is the one
-- direction that lets an out-of-date pack reach a patient (SRS-CSSD-008).
--
-- The cycle's release is separate from its result, under a CHECK that a
-- released load names who released it. A cycle that passed is not a cycle that
-- was cleared: the biological indicator may still be incubating, and
-- SRS-CSSD-007's clause is that a failed or uncleared load cannot be
-- distributed.
--
-- An issue row's used_case_id is what SRS-CSSD-010's case trace runs along,
-- and a CHECK requires it once the pack is marked used. A pack opened for
-- nobody is a pack that drops out of every infection investigation.
--
-- Trace: SRS-CSSD-001 … SRS-CSSD-012.
--
-- Rollback: drops the schema. Every instrument record, packing list version,
-- reprocessing run, sterilizer cycle, indicator result and issue goes with it.
-- The cycle record is what an infection investigation runs along and what a
-- recall is announced by. Treat as a disaster-recovery action, never a
-- deployment step.
--
-- Reconciliation: the tables are new, so the previous version writes nothing
-- here and sees nothing missing. The direction to watch is the theatre: a tray
-- opened for a case names a cycle id (SRS-OT-012), and during the rollout an
-- old replica will happily accept one this schema has no row for. The link is
-- one-way and unenforced across contexts by design, so nothing breaks — the
-- case trace simply reports a gap until every replica is new.

CREATE SCHEMA IF NOT EXISTS sterile;

CREATE TABLE sterile.instrument (
    instrument_id uuid PRIMARY KEY,
    tenant_id     uuid NOT NULL,

    -- The catalogue code, which is what a packing list names. Without it an
    -- instrument cannot be checked against the list it belongs on.
    code    text NOT NULL CHECK (code <> ''),
    display text NOT NULL DEFAULT '',
    -- Identifies one physical instrument where the department tracks them
    -- singly. Empty for an item counted in bulk, which is not a gap:
    -- SRS-CSSD-012's lifecycle history is only possible for the ones that
    -- have one.
    serial_number text NOT NULL DEFAULT '',

    status text NOT NULL CHECK (status IN (
        'in_service', 'in_repair', 'missing', 'retired')),
    location text NOT NULL DEFAULT '',

    acquired_on date,
    retired_on  timestamptz,
    notes       text NOT NULL DEFAULT '',

    created_at timestamptz NOT NULL,
    created_by text        NOT NULL CHECK (created_by <> ''),
    version    bigint      NOT NULL DEFAULT 1,

    CONSTRAINT a_retired_instrument_has_a_date CHECK (
        status <> 'retired' OR retired_on IS NOT NULL
    )
);

-- A serial number identifies one physical object, so it cannot be reused while
-- another instrument holds it. Bulk items have no serial and are excluded.
CREATE UNIQUE INDEX instrument_serial_idx
    ON sterile.instrument (tenant_id, serial_number)
    WHERE serial_number <> '';
CREATE INDEX instrument_code_idx ON sterile.instrument (tenant_id, code);
-- The lifecycle worklist: what is away, missing or retired.
CREATE INDEX instrument_out_of_service_idx
    ON sterile.instrument (tenant_id, status)
    WHERE status <> 'in_service';

CREATE TABLE sterile.tray_set (
    set_id    uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    code    text NOT NULL CHECK (code <> ''),
    display text NOT NULL DEFAULT '',
    -- A tray, a peel pack and a rigid container have different handling and
    -- different expiries.
    kind text NOT NULL DEFAULT '',

    set_version integer NOT NULL CHECK (set_version >= 1),
    supersedes  uuid REFERENCES sterile.tray_set (set_id),

    -- The packing list at this version. A set with none cannot be assembled
    -- against anything, and every count after it would pass.
    items jsonb NOT NULL
        CHECK (jsonb_typeof(items) = 'array' AND jsonb_array_length(items) > 0),
    -- How long a pack of this set stays sterile. Zero means the deployment's
    -- default applies; a pack is refused at sterilisation if neither resolves.
    shelf_life_seconds bigint NOT NULL DEFAULT 0 CHECK (shelf_life_seconds >= 0),

    created_at    timestamptz NOT NULL,
    created_by    text        NOT NULL CHECK (created_by <> ''),
    superseded_at timestamptz
);

-- At most one current version per set code. Two live packing lists is two
-- answers to "what should be in this tray".
CREATE UNIQUE INDEX tray_set_current_idx
    ON sterile.tray_set (tenant_id, code)
    WHERE superseded_at IS NULL;
CREATE INDEX tray_set_history_idx
    ON sterile.tray_set (tenant_id, code, set_version);

CREATE TABLE sterile.cycle (
    cycle_id  uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    -- Without the machine a recall cannot reach the other loads it ran, and a
    -- sterilizer failing is a machine-shaped problem.
    machine     text NOT NULL CHECK (machine <> ''),
    load_number text NOT NULL CHECK (load_number <> ''),
    program     text NOT NULL DEFAULT '',

    -- What the machine reported or a technician recorded. Free-form, because
    -- sterilizers differ and a fixed schema would lose whatever this one
    -- measures.
    parameters jsonb NOT NULL DEFAULT '{}'::jsonb,
    -- A cycle whose parameters came from the machine is evidence of a
    -- different weight from one somebody typed (SRS-CSSD-006).
    source text NOT NULL CHECK (source IN ('manual', 'ingested')),

    result text NOT NULL CHECK (result IN (
        'running', 'passed', 'failed', 'aborted')),

    -- Separate from the result. A passed cycle with an unread biological
    -- indicator is a load nobody may distribute yet (SRS-CSSD-007).
    released     boolean     NOT NULL DEFAULT false,
    released_by  text        NOT NULL DEFAULT '',
    released_at  timestamptz,
    release_note text        NOT NULL DEFAULT '',

    started_at timestamptz NOT NULL,
    ended_at   timestamptz,
    started_by text        NOT NULL CHECK (started_by <> ''),
    version    bigint      NOT NULL DEFAULT 1,

    CONSTRAINT a_release_names_who_authorised_it CHECK (
        NOT released OR (released_by <> '' AND released_at IS NOT NULL)
    ),
    -- A load that never finished, or did not pass, cannot be cleared. The
    -- domain checks the indicators too; this is the half a stray UPDATE cannot
    -- get round.
    CONSTRAINT only_a_passed_load_is_released CHECK (
        NOT released OR result = 'passed'
    ),
    CONSTRAINT a_cycle_ends_after_it_starts CHECK (
        ended_at IS NULL OR ended_at >= started_at
    ),
    UNIQUE (tenant_id, machine, load_number)
);

-- The loads that have finished and not been cleared: the department's
-- outstanding list.
CREATE INDEX cycle_awaiting_release_idx
    ON sterile.cycle (tenant_id, ended_at)
    WHERE NOT released AND result = 'passed';
CREATE INDEX cycle_machine_idx ON sterile.cycle (tenant_id, machine, started_at);

CREATE TABLE sterile.indicator (
    indicator_id uuid PRIMARY KEY,
    tenant_id    uuid NOT NULL,
    cycle_id     uuid NOT NULL
        REFERENCES sterile.cycle (cycle_id) ON DELETE CASCADE,

    kind text NOT NULL CHECK (kind IN ('chemical', 'biological')),
    -- A bad batch of indicators invalidates every load they cleared, and the
    -- lot is the only thing that can find them.
    lot    text    NOT NULL CHECK (lot <> ''),
    passed boolean NOT NULL,
    notes  text    NOT NULL DEFAULT '',

    read_at timestamptz NOT NULL,
    read_by text        NOT NULL CHECK (read_by <> ''),

    CONSTRAINT a_failed_indicator_records_what_was_seen CHECK (
        passed OR notes <> ''
    )
);

CREATE INDEX indicator_cycle_idx ON sterile.indicator (tenant_id, cycle_id);
-- The direction a bad-batch investigation runs: from a lot to every load it
-- cleared.
CREATE INDEX indicator_lot_idx ON sterile.indicator (tenant_id, lot, read_at);

CREATE TABLE sterile.run (
    run_id    uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    set_id uuid NOT NULL REFERENCES sterile.tray_set (set_id),
    -- The version the pack was assembled against, carried rather than joined.
    -- A revision published tomorrow must not change what this pack was checked
    -- against.
    set_version integer NOT NULL CHECK (set_version >= 1),
    set_code    text    NOT NULL CHECK (set_code <> ''),

    -- The chain of custody begins here (SRS-CSSD-002).
    source_unit    text NOT NULL CHECK (source_unit <> ''),
    source_case_id uuid,

    stage text NOT NULL CHECK (stage IN (
        'received', 'decontaminated', 'washed', 'inspected',
        'assembled', 'packaged', 'sterilised', 'released')),

    -- What arrived and what went in, against the packing list.
    received_count jsonb  NOT NULL DEFAULT '{}'::jsonb,
    packed_count   jsonb  NOT NULL DEFAULT '{}'::jsonb,
    missing        text[] NOT NULL DEFAULT '{}',
    replaced       text[] NOT NULL DEFAULT '{}',

    cycle_id uuid REFERENCES sterile.cycle (cycle_id),
    packaging_method text NOT NULL DEFAULT '',
    indicator_type   text NOT NULL DEFAULT '',

    sterilised_at timestamptz,
    expires_at    timestamptz,

    started_at timestamptz NOT NULL,
    started_by text        NOT NULL CHECK (started_by <> ''),
    version    bigint      NOT NULL DEFAULT 1,

    -- A missing expiry reads as "never expires" to every query that filters on
    -- it, which is the one direction that lets an out-of-date pack reach a
    -- patient.
    CONSTRAINT a_sterilised_pack_expires CHECK (
        sterilised_at IS NULL
        OR (expires_at IS NOT NULL AND expires_at > sterilised_at
            AND cycle_id IS NOT NULL)
    ),
    -- A released pack has been sterilised. Everything else in this department
    -- exists to make that step meaningful.
    CONSTRAINT a_released_pack_was_sterilised CHECK (
        stage <> 'released' OR sterilised_at IS NOT NULL
    )
);

CREATE INDEX run_set_idx ON sterile.run (tenant_id, set_id, started_at);
CREATE INDEX run_cycle_idx ON sterile.run (tenant_id, cycle_id);
CREATE INDEX run_source_case_idx ON sterile.run (tenant_id, source_case_id)
    WHERE source_case_id IS NOT NULL;
-- The shelf: released packs, soonest to expire first, so the department issues
-- the pack that would otherwise be wasted.
CREATE INDEX run_shelf_idx
    ON sterile.run (tenant_id, set_code, expires_at)
    WHERE stage = 'released';
-- The work in progress, which is the department's own board.
CREATE INDEX run_in_progress_idx
    ON sterile.run (tenant_id, stage, started_at)
    WHERE stage <> 'released';

CREATE TABLE sterile.stage_record (
    stage_record_id uuid PRIMARY KEY,
    tenant_id       uuid NOT NULL,
    run_id          uuid NOT NULL
        REFERENCES sterile.run (run_id) ON DELETE CASCADE,

    stage text NOT NULL CHECK (stage IN (
        'received', 'decontaminated', 'washed', 'inspected',
        'assembled', 'packaged', 'sterilised', 'released')),
    equipment text NOT NULL DEFAULT '',
    notes     text NOT NULL DEFAULT '',

    -- The authorised exception SRS-CSSD-003 allows. Recordable, because an
    -- exception that cannot be recorded is one that happens off the system.
    skipped            boolean NOT NULL DEFAULT false,
    skip_authorised_by text    NOT NULL DEFAULT '',
    skip_reason        text    NOT NULL DEFAULT '',

    performed_at timestamptz NOT NULL,
    performed_by text        NOT NULL CHECK (performed_by <> ''),

    -- The whole of the exception is that somebody is named. An unauthorised
    -- skip is a stage that did not happen and that nobody is answerable for.
    CONSTRAINT a_skip_is_authorised_and_explained CHECK (
        NOT skipped OR (skip_authorised_by <> '' AND skip_reason <> '')
    ),
    -- Sterilisation and release are never skipped, whoever authorises it.
    CONSTRAINT two_stages_are_never_skipped CHECK (
        NOT skipped OR stage NOT IN ('sterilised', 'released')
    ),
    -- One record per stage per run. A second is the same step recorded twice,
    -- and an audit reading the count of stages would be wrong.
    UNIQUE (run_id, stage)
);

CREATE INDEX stage_record_run_idx
    ON sterile.stage_record (tenant_id, run_id, performed_at);
-- The exceptions register, which is what a quality review reads.
CREATE INDEX stage_record_skipped_idx
    ON sterile.stage_record (tenant_id, performed_at)
    WHERE skipped;

CREATE TABLE sterile.issue (
    issue_id  uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,
    run_id    uuid NOT NULL REFERENCES sterile.run (run_id),

    set_code text NOT NULL CHECK (set_code <> ''),
    cycle_id uuid REFERENCES sterile.cycle (cycle_id),

    -- A pack with no destination is one nobody can fetch back, which is what a
    -- recall has to do.
    destination text NOT NULL CHECK (destination <> ''),
    issued_to   text NOT NULL DEFAULT '',

    state text NOT NULL CHECK (state IN ('out', 'used', 'returned', 'recalled')),
    -- What SRS-CSSD-010's case trace runs along.
    used_case_id uuid,
    return_count jsonb NOT NULL DEFAULT '{}'::jsonb,
    return_note  text  NOT NULL DEFAULT '',

    issued_at timestamptz NOT NULL,
    issued_by text        NOT NULL CHECK (issued_by <> ''),
    closed_at timestamptz,
    closed_by text        NOT NULL DEFAULT '',

    -- A pack opened for nobody drops out of every infection investigation.
    CONSTRAINT a_used_pack_names_its_case CHECK (
        state <> 'used' OR used_case_id IS NOT NULL
    )
);

CREATE INDEX issue_run_idx ON sterile.issue (tenant_id, run_id);
CREATE INDEX issue_cycle_idx ON sterile.issue (tenant_id, cycle_id);
-- The case trace: from a patient's operation back to every set it used.
CREATE INDEX issue_case_idx ON sterile.issue (tenant_id, used_case_id)
    WHERE used_case_id IS NOT NULL;
-- What is out, so a recall knows where to go.
CREATE INDEX issue_out_idx ON sterile.issue (tenant_id, destination)
    WHERE state = 'out';

CREATE TABLE sterile.recall (
    recall_id uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,
    cycle_id  uuid NOT NULL REFERENCES sterile.cycle (cycle_id),

    reason text NOT NULL CHECK (reason <> ''),
    -- The counts at the moment the recall was raised, kept because the packs
    -- move afterwards and a recall report has to say what it found.
    packs_affected integer NOT NULL DEFAULT 0,
    cases_affected integer NOT NULL DEFAULT 0,

    raised_at timestamptz NOT NULL,
    raised_by text        NOT NULL CHECK (raised_by <> ''),
    closed_at timestamptz,
    closed_by text        NOT NULL DEFAULT '',
    closing_note text     NOT NULL DEFAULT ''
);

CREATE INDEX recall_cycle_idx ON sterile.recall (tenant_id, cycle_id);
CREATE INDEX recall_open_idx ON sterile.recall (tenant_id, raised_at)
    WHERE closed_at IS NULL;
