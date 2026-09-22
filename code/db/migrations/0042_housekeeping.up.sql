-- 0042 Housekeeping and environmental services (SRS-HKP-001 … 008).
--
-- Trace: SRS-HKP-001 … SRS-HKP-008.
--
-- Four shapes here are unusual and deliberate.
--
-- A bed's cleaning hold is a row with three states, not a boolean and a note.
-- housekeeping.bed_hold is open, released or overridden, and an override is
-- its own state rather than a release with a reason beside it. The two are
-- different facts: one is a bed that was cleaned, the other is a bed that went
-- back into service uncleaned because the hospital was full. A schema that
-- merged them would let a turnaround report say the hospital cleaned every
-- bed, and SRS-HKP-003's acceptance — unavailable until completion or
-- override — is exactly the distinction it would lose. A partial unique index
-- allows one open hold per bed, because two open holds is a bed released once
-- and still dirty.
--
-- A cleaning task carries its own copy of the standard it was raised under:
-- the risk class, the SLA that produced its due time, the scan code and the
-- checklist items, in housekeeping.task_checklist_item. It does not point at
-- housekeeping.cleanable_location. SRS-HKP-001's acceptance is that schedules
-- derive from the active configuration, and the corollary is that a
-- configuration edited afterwards must not change what a completed clean was
-- judged against. The location master is versioned by (code, revision) and
-- effective-dated for the same reason, and a CHECK refuses a standard
-- approved by its own author: one person writing and approving a cleaning
-- standard is one person deciding how often a theatre is cleaned and what
-- counts as cleaning it.
--
-- A spill task cannot be un-restricted. housekeeping.cleaning_task has a
-- CHECK that a row of kind 'spill' has restricted set, so the restricted
-- category SRS-HKP-006 asks for is a property of the row rather than a flag an
-- operator can clear. The circumstances of a spill are often about a patient,
-- and a biohazard task on the general worklist says which bay and when.
--
-- A location scan has nowhere to record authority. housekeeping.location_scan
-- names the authenticated person who made it and whether the code matched, and
-- nothing else; there is no column a task state could be advanced from and no
-- table a scan alone writes to. SRS-HKP-007 is explicit that a scan does not
-- replace user authentication, and the way to mean it is to have nowhere to
-- put the thing that would. A mismatch is stored as a mismatch rather than
-- rejected: somebody scanned the wrong door or the label on this one is
-- wrong, and both are findings.
--
-- Rollback: drops the schema. Every cleaning standard, cleaning task and its
-- checklist answers, location scan and bed hold goes with it. A hospital that
-- rolls this back loses the record of which beds are held pending a terminal
-- clean, which is the one thing a ward must not guess at: the next patient
-- goes into whichever bed the board says is free. Treat it as a
-- disaster-recovery action, never a deployment step, and take the held-bed
-- list on paper first.
--
-- Reconciliation: the tables are new, so the previous version writes nothing
-- here and sees nothing missing.

CREATE SCHEMA IF NOT EXISTS housekeeping;

-- Cleanable location master (SRS-HKP-001).
--
-- Versioned by (code, revision) and effective-dated. A standard edited in
-- place would change what a clean completed last month was judged against,
-- and the audit question is always what the standard said at the time.
CREATE TABLE housekeeping.cleanable_location (
    location_id uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,

    code     text    NOT NULL CHECK (code <> ''),
    name     text    NOT NULL DEFAULT '',
    revision integer NOT NULL
        CONSTRAINT a_location_revision_starts_at_one CHECK (revision >= 1),

    facility_id text NOT NULL DEFAULT '',
    -- Zone groups locations for the people who work them — a ward, a theatre
    -- suite, a floor.
    zone text NOT NULL DEFAULT '',
    -- Set for a location that is a bed. It is what a terminal clean holds,
    -- and it is why this context can answer whether a bed is clear.
    bed_id text NOT NULL DEFAULT '',

    -- An enum rather than a number: a hospital that could type "7" would have
    -- four wards on seven and nobody able to say what seven meant.
    risk_class text NOT NULL CHECK (
        risk_class IN ('very_high', 'high', 'moderate', 'low')),

    -- Zero means no routine schedule — a store room cleaned when somebody
    -- asks — rather than a location overdue for ever.
    routine_every_hours integer NOT NULL DEFAULT 0
        CHECK (routine_every_hours >= 0),
    routine_sla_minutes integer NOT NULL DEFAULT 0
        CHECK (routine_sla_minutes >= 0),
    -- Shorter than the routine SLA, because a bed is out of service until the
    -- terminal clean is done.
    terminal_sla_minutes integer NOT NULL DEFAULT 0
        CHECK (terminal_sla_minutes >= 0),

    -- The code on the label at the door. A task's scan is checked against it.
    scan_code text NOT NULL DEFAULT '',

    approved    boolean NOT NULL DEFAULT false,
    approved_by text    NOT NULL DEFAULT '',
    approved_at timestamptz,

    effective_from timestamptz,
    superseded_at  timestamptz,

    created_at timestamptz NOT NULL DEFAULT now(),
    created_by text        NOT NULL DEFAULT '',
    version    bigint      NOT NULL DEFAULT 1,

    -- A standard in force from no particular moment silently rejudges the
    -- cleans already done against the old one.
    CONSTRAINT an_approved_standard_says_when_it_takes_effect CHECK (
        NOT approved OR (approved_by <> '' AND approved_at IS NOT NULL
            AND effective_from IS NOT NULL)),
    -- One person writing and approving a cleaning standard is one person
    -- deciding how often a theatre is cleaned.
    CONSTRAINT the_author_of_a_standard_does_not_approve_it CHECK (
        NOT approved OR approved_by <> created_by),
    CONSTRAINT a_standard_is_superseded_after_it_takes_effect CHECK (
        superseded_at IS NULL OR effective_from IS NULL
            OR superseded_at >= effective_from)
);

-- One row per revision of a location's standard. Two rows for one revision is
-- two standards a reader picks between.
CREATE UNIQUE INDEX location_revision_idx
    ON housekeeping.cleanable_location (tenant_id, lower(code), revision);

CREATE INDEX location_zone_idx
    ON housekeeping.cleanable_location (tenant_id, facility_id, zone);

CREATE INDEX location_bed_idx
    ON housekeeping.cleanable_location (tenant_id, bed_id)
    WHERE bed_id <> '';

-- What a clean at this location has to include (SRS-HKP-002).
CREATE TABLE housekeeping.location_checklist_item (
    location_id uuid NOT NULL
        REFERENCES housekeeping.cleanable_location (location_id)
        ON DELETE CASCADE,
    item_code text    NOT NULL CHECK (item_code <> ''),
    label     text    NOT NULL DEFAULT '',
    -- An optional item is one the hospital wants counted rather than insisted
    -- on. A required one a clean cannot be completed without.
    required boolean NOT NULL DEFAULT true,
    position integer NOT NULL DEFAULT 0,

    PRIMARY KEY (location_id, item_code)
);

-- The same item twice is two answers to one question, and a completion check
-- that counts both.
CREATE UNIQUE INDEX location_checklist_item_code_idx
    ON housekeeping.location_checklist_item (location_id, lower(item_code));

-- Cleaning task (SRS-HKP-002, SRS-HKP-004, SRS-HKP-006).
--
-- Carries its own copy of the standard rather than pointing at one, so a
-- configuration changed afterwards does not change underneath the person
-- doing the work or the audit reading it later.
CREATE TABLE housekeeping.cleaning_task (
    task_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    kind text NOT NULL CHECK (
        kind IN ('routine', 'terminal', 'spill', 'deep')),

    location_code text NOT NULL CHECK (location_code <> ''),
    location_name text NOT NULL DEFAULT '',
    facility_id   text NOT NULL DEFAULT '',
    zone          text NOT NULL DEFAULT '',
    bed_id        text NOT NULL DEFAULT '',

    risk_class text NOT NULL CHECK (
        risk_class IN ('very_high', 'high', 'moderate', 'low')),
    -- Pins the configuration this task was raised under.
    location_revision integer NOT NULL CHECK (location_revision >= 1),
    scan_code         text    NOT NULL DEFAULT '',

    -- Set from the kind rather than chosen. See the CHECK below.
    restricted   boolean NOT NULL DEFAULT false,
    -- Links a spill to the incident it belongs to, in the quality context.
    -- SRS-HKP-006's acceptance is that the link is retained.
    incident_ref text NOT NULL DEFAULT '',
    detail       text NOT NULL DEFAULT '',

    assignee_id text NOT NULL DEFAULT '',
    due_by      timestamptz,

    state text NOT NULL CHECK (
        state IN ('open', 'in_progress', 'completed', 'verified',
                  'cancelled')),

    started_at timestamptz,
    started_by text NOT NULL DEFAULT '',

    completed_at timestamptz,
    completed_by text NOT NULL DEFAULT '',

    verified_at timestamptz,
    verified_by text NOT NULL DEFAULT '',
    verify_note text NOT NULL DEFAULT '',

    cancel_reason text NOT NULL DEFAULT '',

    escalated_at timestamptz,

    raised_at timestamptz NOT NULL DEFAULT now(),
    raised_by text        NOT NULL CHECK (raised_by <> ''),
    version   bigint      NOT NULL DEFAULT 1,

    -- A biohazard task with no detail sends somebody with the wrong
    -- equipment.
    CONSTRAINT a_spill_task_says_what_was_spilled CHECK (
        kind <> 'spill' OR detail <> ''),
    -- An operator who could un-restrict a biohazard task would, and the
    -- circumstances of a spill are often about a patient.
    CONSTRAINT a_spill_task_is_restricted CHECK (
        kind <> 'spill' OR restricted),
    -- A terminal clean holds a bed. Raised against a corridor it would hold
    -- nothing and look like it held something.
    CONSTRAINT a_terminal_clean_names_its_bed CHECK (
        kind <> 'terminal' OR bed_id <> ''),
    CONSTRAINT a_started_task_says_who_began_it CHECK (
        started_at IS NULL OR started_by <> ''),
    CONSTRAINT a_completed_clean_says_who_did_the_work CHECK (
        state NOT IN ('completed', 'verified')
            OR (completed_at IS NOT NULL AND completed_by <> '')),
    -- A clean signed off by the cleaner is the same claim made twice, and
    -- supervisor verification is the requirement's own word for what this is.
    CONSTRAINT a_clean_is_verified_by_somebody_else CHECK (
        state <> 'verified'
            OR (verified_at IS NOT NULL AND verified_by <> ''
                AND verified_by <> completed_by)),
    CONSTRAINT a_cancelled_task_says_why CHECK (
        state <> 'cancelled' OR cancel_reason <> '')
);

CREATE INDEX cleaning_task_worklist_idx
    ON housekeeping.cleaning_task (tenant_id, state, due_by);

CREATE INDEX cleaning_task_location_idx
    ON housekeeping.cleaning_task (tenant_id, location_code, raised_at DESC);

CREATE INDEX cleaning_task_bed_idx
    ON housekeeping.cleaning_task (tenant_id, bed_id)
    WHERE bed_id <> '';

-- The checklist as copied onto the task, and its answers (SRS-HKP-004).
CREATE TABLE housekeeping.task_checklist_item (
    task_id uuid NOT NULL
        REFERENCES housekeeping.cleaning_task (task_id) ON DELETE CASCADE,
    item_code text    NOT NULL CHECK (item_code <> ''),
    label     text    NOT NULL DEFAULT '',
    required  boolean NOT NULL DEFAULT true,
    position  integer NOT NULL DEFAULT 0,

    answered  boolean NOT NULL DEFAULT false,
    done      boolean NOT NULL DEFAULT false,
    exception text    NOT NULL DEFAULT '',

    PRIMARY KEY (task_id, item_code),

    -- An unticked box with no note is indistinguishable from one nobody
    -- looked at, and the difference is the whole of an audit.
    CONSTRAINT an_item_not_done_says_why CHECK (
        NOT answered OR done OR exception <> ''),
    -- And an unanswered item carries no answer, so a report counting done
    -- items cannot be fooled by a row nobody filled in.
    CONSTRAINT an_unanswered_item_carries_no_answer CHECK (
        answered OR (NOT done AND exception = ''))
);

-- Location scan (SRS-HKP-007).
--
-- Evidence that somebody was in the room, recorded against the authenticated
-- person who scanned it. Append-only, and there is no column here a task
-- state could be advanced from: a scan does not replace user authentication.
CREATE TABLE housekeeping.location_scan (
    scan_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,
    task_id   uuid NOT NULL
        REFERENCES housekeeping.cleaning_task (task_id) ON DELETE CASCADE,

    -- What came off the label, exactly as read.
    scanned_code text NOT NULL CHECK (scanned_code <> ''),
    -- A mismatch is the finding, and it is stored rather than rejected.
    matched boolean NOT NULL DEFAULT false,
    -- A scan attributed to a badge rather than a session is a scan anybody
    -- holding the badge can make.
    scanned_by text NOT NULL
        CONSTRAINT a_scan_names_the_person_who_made_it
        CHECK (scanned_by <> ''),
    scanned_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX location_scan_task_idx
    ON housekeeping.location_scan (tenant_id, task_id, scanned_at);

-- Bed cleaning hold (SRS-HKP-003).
--
-- A bed stays unavailable until the terminal clean completes or somebody
-- overrides it by name and reason. This is the rule that stops a patient
-- being put into the bed the last one died in.
CREATE TABLE housekeeping.bed_hold (
    hold_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    bed_id        text NOT NULL CHECK (bed_id <> ''),
    location_code text NOT NULL DEFAULT '',
    facility_id   text NOT NULL DEFAULT '',
    zone          text NOT NULL DEFAULT '',

    -- The terminal clean that must finish. A hold with no task behind it is a
    -- bed nobody is coming to clean.
    task_id uuid NOT NULL
        REFERENCES housekeeping.cleaning_task (task_id),
    -- The encounter whose end raised it, where there was one.
    encounter_id text NOT NULL DEFAULT '',

    state text NOT NULL CHECK (
        state IN ('open', 'released', 'overridden')),

    placed_at timestamptz NOT NULL DEFAULT now(),
    placed_by text        NOT NULL CHECK (placed_by <> ''),

    released_at timestamptz,
    released_by text NOT NULL DEFAULT '',

    overridden_at   timestamptz,
    overridden_by   text NOT NULL DEFAULT '',
    override_reason text NOT NULL DEFAULT '',

    version bigint NOT NULL DEFAULT 1,

    CONSTRAINT a_released_hold_says_who_released_it CHECK (
        state <> 'released'
            OR (released_at IS NOT NULL AND released_by <> '')),
    -- A bed going back into service uncleaned is sometimes the right call in
    -- a full hospital, and is always a decision somebody has to be able to
    -- point at afterwards.
    CONSTRAINT an_overridden_hold_says_why CHECK (
        state <> 'overridden'
            OR (overridden_at IS NOT NULL AND overridden_by <> ''
                AND override_reason <> '')),
    -- The two ways out are kept apart, so a turnaround report cannot count an
    -- override as a clean.
    CONSTRAINT a_released_hold_is_not_an_override CHECK (
        state <> 'released'
            OR (overridden_at IS NULL AND override_reason = ''))
);

-- One open hold per bed. Two is a bed released once and still dirty.
CREATE UNIQUE INDEX bed_hold_open_idx
    ON housekeeping.bed_hold (tenant_id, bed_id)
    WHERE state = 'open';

CREATE INDEX bed_hold_task_idx
    ON housekeeping.bed_hold (tenant_id, task_id);

CREATE INDEX bed_hold_placed_idx
    ON housekeeping.bed_hold (tenant_id, state, placed_at);
