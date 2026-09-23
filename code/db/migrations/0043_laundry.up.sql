-- 0043 Laundry and linen (SRS-LND-001 … 007).
--
-- Trace: SRS-LND-001 … SRS-LND-007.
--
-- Three shapes here are unusual and deliberate, and two of them are composite
-- foreign keys carrying a denormalised column. That is not a modelling
-- accident: it is how a rule that spans two rows becomes something the
-- database refuses rather than something the application remembers.
--
-- Linen cannot be issued from a wash that did not pass. laundry.linen_issue
-- carries batch_state beside batch_id, with a composite foreign key onto
-- laundry.wash_batch (batch_id, state) ON UPDATE CASCADE and a CHECK that the
-- state is 'passed'. A wash that failed produces linen that looks exactly
-- like clean linen and is not, and the ward it reaches cannot tell by
-- looking. The cascade is the point: the denormalised column cannot go stale,
-- and a later attempt to move a batch out of 'passed' fails against the CHECK
-- rather than silently leaving issued linen attached to a failed wash.
--
-- Infected linen cannot enter an ordinary cycle. laundry.collection carries
-- batch_cycle beside batch_id, with the same shape of composite foreign key
-- onto (batch_id, cycle) and a CHECK that a collection of soil class
-- 'infected' is either unbatched or in a barrier cycle. A standard programme
-- does not dissolve the water-soluble inner bag and does not reach
-- disinfection temperature; the load comes out contaminated and
-- indistinguishable from clean, and the people who sort it afterwards are the
-- ones who find out. laundry.wash_batch carries the same rule from its own
-- side: a batch marked as carrying infected linen must be a barrier cycle.
--
-- And a tag can only be attached to something the master calls tracked.
-- laundry.tracked_item carries item_tracked with a composite foreign key onto
-- laundry.linen_item (tenant_id, code, tracked). SRS-LND-007 is about
-- high-value linen and uniforms; a custody trail for one sheet out of four
-- thousand reads as a system that lost the other three thousand nine hundred
-- and ninety-nine.
--
-- Rollback: drops the schema. Every linen item and par level, every soiled
-- collection and its chain to the wash that took it, every batch outcome and
-- exception, every issue, every write-off and every tracked item's custody
-- trail goes with it. A hospital that rolls this back loses the record of
-- which wash a ward's linen came out of, which is the one thing that has to
-- be answerable when a batch turns out to have failed. Treat it as a
-- disaster-recovery action, never a deployment step, and take the day's
-- batch sheet on paper first.
--
-- Reconciliation: the tables are new, so the previous version writes nothing
-- here and sees nothing missing.

CREATE SCHEMA IF NOT EXISTS laundry;

-- Linen item master (SRS-LND-001).
CREATE TABLE laundry.linen_item (
    item_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    code text NOT NULL CHECK (code <> ''),
    name text NOT NULL DEFAULT '',
    category text NOT NULL CHECK (
        category IN ('bedding', 'patient', 'theatre', 'uniform', 'other')),

    -- The dry weight of one piece, used to reconcile a declared count
    -- against a weighed bag. Zero means nobody has weighed one, and the
    -- reconciliation reports unanswerable rather than a variance of
    -- everything.
    unit_weight_g integer NOT NULL DEFAULT 0 CHECK (unit_weight_g >= 0),
    -- Minor units. A linen budget in rupees and paise is not a
    -- floating-point problem.
    replacement_cost_minor integer NOT NULL DEFAULT 0
        CHECK (replacement_cost_minor >= 0),
    -- Carries an RFID or barcode tag (SRS-LND-007). See the composite key
    -- from laundry.tracked_item below.
    tracked boolean NOT NULL DEFAULT false,

    active boolean NOT NULL DEFAULT true,

    created_at timestamptz NOT NULL DEFAULT now(),
    created_by text        NOT NULL DEFAULT '',
    version    bigint      NOT NULL DEFAULT 1,

    -- Backs the composite key a tracked item is registered through. A plain
    -- unique rather than the case-insensitive one below, because a
    -- functional index cannot be referenced.
    UNIQUE (tenant_id, code, tracked),
    UNIQUE (tenant_id, code)
);

-- Two items differing only in case is two pars for one thing.
CREATE UNIQUE INDEX linen_item_code_idx
    ON laundry.linen_item (tenant_id, lower(code));

CREATE INDEX linen_item_category_idx
    ON laundry.linen_item (tenant_id, category) WHERE active;

-- Unit par levels, effective-dated (SRS-LND-001).
--
-- Versioned by (unit, revision), because SRS-LND-001's acceptance says the
-- par configuration is effective-dated. A par edited in place would change
-- what last month's shortfall was measured against.
CREATE TABLE laundry.par_level (
    par_id    uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    unit_id     text NOT NULL CHECK (unit_id <> ''),
    unit_name   text NOT NULL DEFAULT '',
    facility_id text NOT NULL DEFAULT '',
    revision    integer NOT NULL
        CONSTRAINT a_par_revision_starts_at_one CHECK (revision >= 1),

    approved    boolean NOT NULL DEFAULT false,
    approved_by text    NOT NULL DEFAULT '',
    approved_at timestamptz,

    effective_from timestamptz,
    superseded_at  timestamptz,

    created_at timestamptz NOT NULL DEFAULT now(),
    created_by text        NOT NULL DEFAULT '',
    version    bigint      NOT NULL DEFAULT 1,

    CONSTRAINT an_approved_par_says_when_it_takes_effect CHECK (
        NOT approved OR (approved_by <> '' AND approved_at IS NOT NULL
            AND effective_from IS NOT NULL)),
    -- A par decides what a ward may hold and therefore what the laundry
    -- buys. One person writing and approving it is one person deciding that.
    CONSTRAINT the_author_of_a_par_does_not_approve_it CHECK (
        NOT approved OR approved_by <> created_by),
    CONSTRAINT a_par_is_superseded_after_it_takes_effect CHECK (
        superseded_at IS NULL OR effective_from IS NULL
            OR superseded_at >= effective_from)
);

CREATE UNIQUE INDEX par_revision_idx
    ON laundry.par_level (tenant_id, lower(unit_id), revision);

CREATE INDEX par_unit_idx
    ON laundry.par_level (tenant_id, facility_id, unit_id);

CREATE TABLE laundry.par_line (
    par_id uuid NOT NULL
        REFERENCES laundry.par_level (par_id) ON DELETE CASCADE,
    item_code text    NOT NULL CHECK (item_code <> ''),
    quantity  integer NOT NULL
        CONSTRAINT a_par_is_a_positive_number CHECK (quantity > 0),
    -- Zero means top up whenever the unit is below par.
    reorder_at integer NOT NULL DEFAULT 0 CHECK (reorder_at >= 0),
    position   integer NOT NULL DEFAULT 0,

    PRIMARY KEY (par_id, item_code),

    -- A reorder level above par fires on every read, so the top-up list is
    -- the whole ward every morning and nobody reads it.
    CONSTRAINT a_reorder_level_is_not_above_par CHECK (reorder_at <= quantity)
);

CREATE UNIQUE INDEX par_line_item_idx
    ON laundry.par_line (par_id, lower(item_code));

-- Wash batches (SRS-LND-003).
CREATE TABLE laundry.wash_batch (
    batch_id  uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    reference   text NOT NULL DEFAULT '',
    facility_id text NOT NULL DEFAULT '',
    -- A batch with no machine is a wash nobody can trace when the machine
    -- turns out to be the problem.
    machine_id text NOT NULL CHECK (machine_id <> ''),
    cycle      text NOT NULL CHECK (
        cycle IN ('standard', 'hot', 'barrier', 'delicate')),
    -- Set from what went in rather than chosen. See the CHECK below and the
    -- composite key from laundry.collection.
    infected boolean NOT NULL DEFAULT false,
    weight_g integer NOT NULL DEFAULT 0 CHECK (weight_g >= 0),

    state text NOT NULL CHECK (
        state IN ('loading', 'processing', 'passed', 'failed', 'rewashed')),

    outcome text NOT NULL DEFAULT '',
    -- Whole degrees. A thermal disinfection record of 71.4999 degrees is a
    -- number whose decimal is about the probe.
    peak_temperature_c integer NOT NULL DEFAULT 0
        CHECK (peak_temperature_c >= 0),
    hold_minutes integer NOT NULL DEFAULT 0 CHECK (hold_minutes >= 0),

    rewash_batch_id    uuid,
    rewash_of_batch_id uuid,

    started_at timestamptz,
    started_by text NOT NULL DEFAULT '',
    completed_at timestamptz,
    completed_by text NOT NULL DEFAULT '',

    created_at timestamptz NOT NULL DEFAULT now(),
    created_by text        NOT NULL DEFAULT '',
    version    bigint      NOT NULL DEFAULT 1,

    -- A hospital that could mark its ordinary programme as carrying
    -- infected linen would, on the night the barrier machine broke.
    CONSTRAINT a_batch_carrying_infected_linen_is_a_barrier_cycle CHECK (
        NOT infected OR cycle = 'barrier'),
    CONSTRAINT a_started_wash_says_who_started_it CHECK (
        started_at IS NULL OR started_by <> ''),
    -- SRS-LND-003's acceptance: the outcome is recorded. An outcome of
    -- nothing tells the person deciding whether to rewash or condemn the
    -- load nothing at all.
    CONSTRAINT a_completed_wash_says_how_it_went CHECK (
        state NOT IN ('passed', 'failed')
            OR (completed_at IS NOT NULL AND completed_by <> ''
                AND outcome <> '')),
    CONSTRAINT a_rewashed_batch_names_its_replacement CHECK (
        state <> 'rewashed' OR rewash_batch_id IS NOT NULL),

    -- Back the composite keys the collection and the issue are attached
    -- through. batch_id is already unique on its own; these let a child row
    -- carry the cycle or the state and have the database keep it true.
    UNIQUE (batch_id, cycle),
    UNIQUE (batch_id, state)
);

CREATE INDEX wash_batch_state_idx
    ON laundry.wash_batch (tenant_id, state, created_at DESC);

CREATE INDEX wash_batch_machine_idx
    ON laundry.wash_batch (tenant_id, machine_id, created_at DESC);

-- What went wrong in a wash (SRS-LND-003).
CREATE TABLE laundry.batch_exception (
    batch_id uuid NOT NULL
        REFERENCES laundry.wash_batch (batch_id) ON DELETE CASCADE,
    code     text    NOT NULL CHECK (code <> ''),
    detail   text    NOT NULL DEFAULT '',
    position integer NOT NULL DEFAULT 0,

    PRIMARY KEY (batch_id, code)
);

-- Soiled linen collections (SRS-LND-002, SRS-LND-005).
CREATE TABLE laundry.collection (
    collection_id uuid PRIMARY KEY,
    tenant_id     uuid NOT NULL,

    unit_id     text NOT NULL CHECK (unit_id <> ''),
    unit_name   text NOT NULL DEFAULT '',
    facility_id text NOT NULL DEFAULT '',

    -- An enum rather than a flag: "infected" is not a degree of "soiled".
    -- It decides which bag the linen goes into at the bedside, whether
    -- anybody may open it again, and which cycle it is allowed into.
    soil_class text NOT NULL CHECK (
        soil_class IN ('used', 'fouled', 'infected')),
    -- Copied from the class at collection time, so the worklist a porter
    -- reads and the cycle the machine runs cannot disagree (SRS-LND-005).
    handling text NOT NULL DEFAULT '',

    bag_count integer NOT NULL
        CONSTRAINT a_collection_is_at_least_one_bag CHECK (bag_count > 0),
    weight_g integer NOT NULL DEFAULT 0 CHECK (weight_g >= 0),

    state text NOT NULL CHECK (
        state IN ('open', 'batched', 'cancelled')),

    -- The chain SRS-LND-002 asks to be retained, and the cycle it went
    -- into, kept true by the composite key below.
    batch_id    uuid,
    batch_cycle text,

    cancel_reason text NOT NULL DEFAULT '',

    collected_at timestamptz NOT NULL DEFAULT now(),
    collected_by text        NOT NULL CHECK (collected_by <> ''),
    version      bigint      NOT NULL DEFAULT 1,

    CONSTRAINT a_batched_collection_names_its_batch CHECK (
        state <> 'batched'
            OR (batch_id IS NOT NULL AND batch_cycle IS NOT NULL)),
    CONSTRAINT an_unbatched_collection_names_no_batch CHECK (
        state = 'batched' OR (batch_id IS NULL AND batch_cycle IS NULL)),
    CONSTRAINT a_cancelled_collection_says_why CHECK (
        state <> 'cancelled' OR cancel_reason <> ''),
    -- The rule this schema exists for. A standard programme does not
    -- dissolve the inner bag and does not reach disinfection temperature.
    CONSTRAINT infected_linen_goes_into_a_barrier_cycle CHECK (
        soil_class <> 'infected' OR batch_cycle IS NULL
            OR batch_cycle = 'barrier'),

    -- ON UPDATE CASCADE so the carried cycle cannot go stale. A batch whose
    -- cycle changed under an infected load would fail the CHECK above
    -- rather than quietly becoming a standard wash.
    FOREIGN KEY (batch_id, batch_cycle)
        REFERENCES laundry.wash_batch (batch_id, cycle) ON UPDATE CASCADE
);

CREATE INDEX collection_pending_idx
    ON laundry.collection (tenant_id, state, collected_at)
    WHERE state = 'open';

CREATE INDEX collection_unit_idx
    ON laundry.collection (tenant_id, unit_id, collected_at DESC);

CREATE INDEX collection_batch_idx
    ON laundry.collection (tenant_id, batch_id) WHERE batch_id IS NOT NULL;

CREATE TABLE laundry.collection_line (
    collection_id uuid NOT NULL
        REFERENCES laundry.collection (collection_id) ON DELETE CASCADE,
    item_code text    NOT NULL CHECK (item_code <> ''),
    quantity  integer NOT NULL
        CONSTRAINT a_collected_count_is_positive CHECK (quantity > 0),
    position integer NOT NULL DEFAULT 0,

    PRIMARY KEY (collection_id, item_code)
);

CREATE UNIQUE INDEX collection_line_item_idx
    ON laundry.collection_line (collection_id, lower(item_code));

-- Clean linen issued to a unit (SRS-LND-004).
CREATE TABLE laundry.linen_issue (
    issue_id  uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    unit_id     text NOT NULL CHECK (unit_id <> ''),
    unit_name   text NOT NULL DEFAULT '',
    facility_id text NOT NULL DEFAULT '',

    batch_id        uuid NOT NULL,
    -- Carried and kept true by the composite key below.
    batch_state     text NOT NULL,
    batch_reference text NOT NULL DEFAULT '',

    issued_at timestamptz NOT NULL DEFAULT now(),
    issued_by text        NOT NULL CHECK (issued_by <> ''),

    received_at timestamptz,
    received_by text NOT NULL DEFAULT '',

    version bigint NOT NULL DEFAULT 1,

    -- The other rule this schema exists for. Linen from a wash that did not
    -- pass looks exactly like clean linen, and the ward that gets it has no
    -- way of telling.
    CONSTRAINT linen_is_issued_from_a_passed_wash CHECK (
        batch_state = 'passed'),
    -- A delivery signed for by the porter who brought it is the same claim
    -- made twice, and a ward that never got its linen has no way to say so.
    CONSTRAINT linen_is_received_by_somebody_else CHECK (
        received_at IS NULL
            OR (received_by <> '' AND received_by <> issued_by)),

    FOREIGN KEY (batch_id, batch_state)
        REFERENCES laundry.wash_batch (batch_id, state) ON UPDATE CASCADE
);

CREATE INDEX linen_issue_unit_idx
    ON laundry.linen_issue (tenant_id, unit_id, issued_at DESC);

CREATE INDEX linen_issue_batch_idx
    ON laundry.linen_issue (tenant_id, batch_id);

CREATE INDEX linen_issue_outstanding_idx
    ON laundry.linen_issue (tenant_id, issued_at)
    WHERE received_at IS NULL;

CREATE TABLE laundry.issue_line (
    issue_id uuid NOT NULL
        REFERENCES laundry.linen_issue (issue_id) ON DELETE CASCADE,
    item_code text    NOT NULL CHECK (item_code <> ''),
    quantity  integer NOT NULL
        CONSTRAINT an_issued_count_is_positive CHECK (quantity > 0),
    position integer NOT NULL DEFAULT 0,

    PRIMARY KEY (issue_id, item_code)
);

CREATE UNIQUE INDEX issue_line_item_idx
    ON laundry.issue_line (issue_id, lower(item_code));

-- Condemned, damaged and missing linen (SRS-LND-006).
CREATE TABLE laundry.loss_record (
    loss_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    unit_id     text NOT NULL CHECK (unit_id <> ''),
    facility_id text NOT NULL DEFAULT '',
    item_code   text NOT NULL CHECK (item_code <> ''),
    quantity    integer NOT NULL
        CONSTRAINT a_loss_is_a_positive_number CHECK (quantity > 0),
    kind text NOT NULL CHECK (
        kind IN ('condemned', 'damaged', 'missing')),
    -- SRS-LND-006 asks for the loss to be reportable, and a reportable loss
    -- is one that says what happened.
    reason text NOT NULL CHECK (reason <> ''),
    -- Pinned at report time, because a price list changed in March must not
    -- restate what January's losses cost.
    value_minor integer NOT NULL DEFAULT 0 CHECK (value_minor >= 0),

    state text NOT NULL CHECK (
        state IN ('reported', 'approved', 'rejected', 'recovered')),
    approval_required boolean NOT NULL DEFAULT true,

    approved_by   text NOT NULL DEFAULT '',
    approved_at   timestamptz,
    decision_note text NOT NULL DEFAULT '',

    reported_at timestamptz NOT NULL DEFAULT now(),
    reported_by text        NOT NULL CHECK (reported_by <> ''),
    version     bigint      NOT NULL DEFAULT 1,

    -- A ward sister writing off her own ward's linen and approving it
    -- herself is the whole of why the requirement says "with approval where
    -- required".
    CONSTRAINT a_write_off_is_decided_by_somebody_else CHECK (
        state NOT IN ('approved', 'rejected')
            OR (approved_at IS NOT NULL AND approved_by <> ''
                AND approved_by <> reported_by)),
    CONSTRAINT a_refused_write_off_says_why CHECK (
        state <> 'rejected' OR decision_note <> ''),
    -- A condemned sheet does not turn up again.
    CONSTRAINT only_missing_linen_is_recovered CHECK (
        state <> 'recovered' OR kind = 'missing')
);

CREATE INDEX loss_record_unit_idx
    ON laundry.loss_record (tenant_id, unit_id, reported_at DESC);

CREATE INDEX loss_record_queue_idx
    ON laundry.loss_record (tenant_id, state, reported_at)
    WHERE state = 'reported';

-- Tagged linen and uniforms (SRS-LND-007).
CREATE TABLE laundry.tracked_item (
    tracked_id uuid PRIMARY KEY,
    tenant_id  uuid NOT NULL,

    tag_id   text NOT NULL CHECK (tag_id <> ''),
    tag_kind text NOT NULL CHECK (tag_kind IN ('rfid', 'barcode')),
    item_code text NOT NULL CHECK (item_code <> ''),
    -- Carried and kept true by the composite key below.
    item_tracked boolean NOT NULL DEFAULT true,
    -- The person a uniform belongs to. Separate from whoever currently has
    -- it: a uniform in the laundry is still that nurse's uniform.
    assigned_to text NOT NULL DEFAULT '',
    facility_id text NOT NULL DEFAULT '',

    state text NOT NULL CHECK (state IN ('in_service', 'retired')),
    retired_reason text NOT NULL DEFAULT '',

    registered_at timestamptz NOT NULL DEFAULT now(),
    registered_by text        NOT NULL CHECK (registered_by <> ''),
    version       bigint      NOT NULL DEFAULT 1,

    -- A custody trail for one sheet out of four thousand reads as a system
    -- that lost the other three thousand nine hundred and ninety-nine.
    CONSTRAINT a_tag_is_only_on_a_tracked_item CHECK (item_tracked),
    CONSTRAINT a_retired_tag_says_why CHECK (
        state <> 'retired' OR retired_reason <> ''),

    FOREIGN KEY (tenant_id, item_code, item_tracked)
        REFERENCES laundry.linen_item (tenant_id, code, tracked)
        ON UPDATE CASCADE
);

-- Two items answering to one tag is a custody trail that belongs to neither.
CREATE UNIQUE INDEX tracked_tag_idx
    ON laundry.tracked_item (tenant_id, lower(tag_id));

CREATE INDEX tracked_assigned_idx
    ON laundry.tracked_item (tenant_id, assigned_to)
    WHERE assigned_to <> '';

-- Scans of a tagged item (SRS-LND-007).
--
-- Append-only. A movement list somebody can edit is a custody trail that says
-- whatever the last person to touch it wanted, and the question a custody
-- trail answers is always asked by somebody who suspects an answer.
CREATE TABLE laundry.tracked_movement (
    movement_id uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,
    tracked_id  uuid NOT NULL
        REFERENCES laundry.tracked_item (tracked_id) ON DELETE CASCADE,

    location text NOT NULL CHECK (location <> ''),
    -- Empty for a location read, which is most of them: a portal scan at
    -- the laundry door says where, not who.
    holder_id text NOT NULL DEFAULT '',
    note      text NOT NULL DEFAULT '',
    -- A movement attributed to a reader rather than a session is a movement
    -- anybody walking past the reader can create.
    recorded_by text NOT NULL
        CONSTRAINT a_movement_names_who_recorded_it
        CHECK (recorded_by <> ''),
    occurred_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX tracked_movement_item_idx
    ON laundry.tracked_movement (tenant_id, tracked_id, occurred_at DESC);
