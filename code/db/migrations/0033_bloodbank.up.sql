-- 0033 Blood bank and transfusion medicine (SRS-BLD-001 … 017).
--
-- Five shapes here are unusual and deliberate.
--
-- A component's status defaults to 'quarantined'. SRS-BLD-004 is explicit that
-- an unreleased component cannot be allocated, and a default of 'available'
-- would mean a row inserted by any path that forgot to say otherwise was
-- issuable. The safe state is the one you get for free.
--
-- Group columns are NOT NULL with a CHECK against the real values and no
-- 'unknown' member. A component whose group is not known cannot be allocated
-- to anybody, so it has no business being in this table; the patient side
-- carries its own group on the sample, where unknown is meaningful and is
-- represented by the absence of a sample row rather than by a value.
--
-- An issue row carries either a reservation or an emergency authorisation,
-- under a CHECK. That is SRS-BLD-009 and SRS-BLD-016 in one constraint: a unit
-- leaves the bank because it was crossmatched for somebody, or because a named
-- senior clinician said so and gave a reason. There is no third way out.
--
-- A transfusion episode carries the issue it came from, and the unique index
-- on (tenant_id, component_id) where the episode is not stopped means one unit
-- is transfused once. A second episode against the same unit is not a second
-- transfusion; it is the same one recorded twice, and the two would disagree.
--
-- A reaction names the component, NOT NULL. The investigation's first job is
-- to find the other components made from the same donation, and a reaction
-- recorded against a patient alone cannot.
--
-- One known duplication, named rather than hidden. SRS-NUR-014 built a
-- transfusion record in Wave 1 (nursing.transfusion and
-- nursing.transfusion_observation) before this context existed. It records the
-- same clinical event from the ward's side: a unit number, a bedside check, a
-- set of observations, a reaction.
--
-- Two records of one transfusion will disagree, which is the defect this
-- codebase spends most of its constraints preventing. bloodbank.episode is the
-- one that should survive, because it is the only one that links to the issue,
-- the component and the collection, and therefore the only one a look-back can
-- run along: asked "who else received blood from this donation", the nursing
-- table cannot answer.
--
-- Resolving it means changing a Wave-1 contract, which is not this migration's
-- to do. Until then: a deployment entitled to the bloodbank module records
-- transfusions here, and the nursing table is the ward chart's view of the
-- same event. See docs/engineering/wave-2-status.md, SRS-BLD section.
--
-- Trace: SRS-BLD-001 … SRS-BLD-017.
--
-- Rollback: drops the schema. Every donor record, deferral, test result,
-- inventory row, crossmatch, issue, transfusion and reaction goes with it. A
-- transfusion record is read in a coroner's court and a deferral record is what
-- keeps an infected donation out of the supply. Treat as a disaster-recovery
-- action, never a deployment step.
--
-- Reconciliation: the tables are new, so the previous version writes nothing
-- here and sees nothing missing. The direction to watch is the patient: a
-- transfusion recorded by the new version is invisible to the old one, so a
-- chart served by an old replica during the rollout shows a patient who was
-- not transfused. A display gap during the rollout window, closing when every
-- replica is new.

CREATE SCHEMA IF NOT EXISTS bloodbank;

CREATE TABLE bloodbank.donor (
    donor_id  uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    -- Unique within the configured scope (SRS-BLD-001). Scoped to the tenant
    -- here; a deployment that numbers donors per facility adds the facility to
    -- the key rather than relaxing it.
    donor_number text NOT NULL CHECK (donor_number <> ''),
    -- Set for a donor who is also a patient here: the autologous and
    -- directed-donation cases. Null for a volunteer who is not.
    patient_id uuid,

    display_name  text NOT NULL CHECK (display_name <> ''),
    birth_date    date,
    contact_phone text NOT NULL DEFAULT '',

    -- The donor's group may be unknown until the first donation is tested,
    -- which is why these are nullable here and not on the component.
    abo text CHECK (abo IN ('A', 'B', 'AB', 'O')),
    rhd text CHECK (rhd IN ('positive', 'negative')),

    deferral       text CHECK (deferral IN ('temporary', 'permanent')),
    deferral_code  text        NOT NULL DEFAULT '',
    deferral_note  text        NOT NULL DEFAULT '',
    deferred_at    timestamptz,
    deferred_by    text        NOT NULL DEFAULT '',
    deferred_until timestamptz,

    registered_at timestamptz NOT NULL,
    registered_by text        NOT NULL CHECK (registered_by <> ''),
    version       bigint      NOT NULL DEFAULT 1,

    -- A temporary deferral with no end date is a permanent one nobody meant to
    -- make, and the donor is lost. A permanent one with an end date is a
    -- temporary one somebody mis-filed.
    CONSTRAINT a_deferral_says_how_long CHECK (
        deferral IS NULL
        OR (deferral = 'temporary' AND deferred_until IS NOT NULL)
        OR (deferral = 'permanent' AND deferred_until IS NULL)
    ),
    CONSTRAINT a_deferral_is_coded CHECK (
        deferral IS NULL OR deferral_code <> ''
    ),
    UNIQUE (tenant_id, donor_number)
);

CREATE INDEX donor_patient_idx ON bloodbank.donor (tenant_id, patient_id)
    WHERE patient_id IS NOT NULL;
-- The deferred list, which a screening desk reads before accepting anybody.
CREATE INDEX donor_deferred_idx ON bloodbank.donor (tenant_id, deferred_until)
    WHERE deferral IS NOT NULL;

CREATE TABLE bloodbank.screening (
    screening_id uuid NOT NULL PRIMARY KEY,
    tenant_id    uuid NOT NULL,
    donor_id     uuid NOT NULL REFERENCES bloodbank.donor (donor_id),

    -- The questionnaire as answered and the bedside measurements, kept as
    -- given rather than reduced to a verdict: the verdict is what somebody
    -- decided, and these are what the donor said and what was measured.
    answers      jsonb NOT NULL DEFAULT '{}'::jsonb,
    measurements jsonb NOT NULL DEFAULT '{}'::jsonb,

    consented    boolean NOT NULL DEFAULT false,
    consent_note text    NOT NULL DEFAULT '',

    accepted      boolean NOT NULL,
    deferral      text CHECK (deferral IN ('temporary', 'permanent')),
    deferral_code text NOT NULL DEFAULT '',

    screened_at timestamptz NOT NULL,
    screened_by text        NOT NULL CHECK (screened_by <> ''),

    -- The collection that follows an unconsented acceptance is a procedure
    -- nobody agreed to.
    CONSTRAINT an_accepted_donor_consented CHECK (NOT accepted OR consented),
    CONSTRAINT a_donor_is_accepted_or_deferred CHECK (
        NOT accepted OR deferral IS NULL
    )
);

CREATE INDEX screening_donor_idx
    ON bloodbank.screening (tenant_id, donor_id, screened_at);

CREATE TABLE bloodbank.collection (
    collection_id uuid PRIMARY KEY,
    tenant_id     uuid NOT NULL,
    donor_id      uuid NOT NULL REFERENCES bloodbank.donor (donor_id),
    -- The screening that permitted it. Required, because "a deferred donor
    -- cannot proceed" is only enforceable if the collection names the decision
    -- that let it happen.
    screening_id uuid NOT NULL REFERENCES bloodbank.screening (screening_id),

    -- Every component made from this collection inherits it as its parent.
    donation_number text NOT NULL CHECK (donation_number <> ''),
    kind            text NOT NULL DEFAULT '',
    volume_ml       integer NOT NULL CHECK (volume_ml > 0),

    abo text CHECK (abo IN ('A', 'B', 'AB', 'O')),
    rhd text CHECK (rhd IN ('positive', 'negative')),

    collected_at timestamptz NOT NULL,
    collected_by text        NOT NULL CHECK (collected_by <> ''),
    -- A donor reaction: a faint, a haematoma. The flag is what a report
    -- counts and the note is what the next screener reads.
    adverse_event boolean NOT NULL DEFAULT false,
    adverse_note  text    NOT NULL DEFAULT '',

    UNIQUE (tenant_id, donation_number)
);

CREATE INDEX collection_donor_idx
    ON bloodbank.collection (tenant_id, donor_id, collected_at);

CREATE TABLE bloodbank.test_result (
    test_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,
    -- On the donation, not the component: the tests are run once and every
    -- component made from it inherits the outcome.
    collection_id uuid NOT NULL
        REFERENCES bloodbank.collection (collection_id) ON DELETE CASCADE,

    code    text NOT NULL CHECK (code <> ''),
    display text NOT NULL DEFAULT '',
    -- Named for what the assay says. A screening test is reactive and a
    -- confirmatory one is positive; conflating them discards good blood.
    reactive boolean NOT NULL,
    value    text    NOT NULL DEFAULT '',
    method   text    NOT NULL DEFAULT '',

    tested_at timestamptz NOT NULL,
    tested_by text        NOT NULL CHECK (tested_by <> '')
);

CREATE INDEX test_collection_idx
    ON bloodbank.test_result (tenant_id, collection_id, code, tested_at);

CREATE TABLE bloodbank.component (
    component_id uuid PRIMARY KEY,
    tenant_id    uuid NOT NULL,

    -- The identifier on the label, which the bedside check reads aloud.
    unit_number   text NOT NULL CHECK (unit_number <> ''),
    collection_id uuid NOT NULL
        REFERENCES bloodbank.collection (collection_id),
    donor_id uuid REFERENCES bloodbank.donor (donor_id),
    -- The external supplier for a received unit.
    source text NOT NULL DEFAULT '',

    component_class text NOT NULL CHECK (component_class IN (
        'red_cells', 'plasma', 'platelets', 'cryoprecipitate', 'whole_blood')),

    -- NOT NULL with no 'unknown' member: an ungrouped unit cannot be allocated
    -- to anybody, so it has no business being here.
    abo text NOT NULL CHECK (abo IN ('A', 'B', 'AB', 'O')),
    rhd text NOT NULL CHECK (rhd IN ('positive', 'negative')),

    -- Quarantined by default. SRS-BLD-004's clause is that an unreleased
    -- component cannot be allocated, and a default of 'available' would make a
    -- forgotten status issuable.
    status text NOT NULL DEFAULT 'quarantined' CHECK (status IN (
        'quarantined', 'available', 'reserved', 'issued',
        'transfused', 'discarded', 'unsuitable')),
    discard_reason text NOT NULL DEFAULT '',

    volume_ml integer NOT NULL DEFAULT 0,
    -- Irradiated, leucodepleted, CMV-negative, washed. Matched rather than
    -- interpreted, so a deployment adds one without a code change.
    attributes text[] NOT NULL DEFAULT '{}',
    location   text   NOT NULL DEFAULT '',

    collected_at timestamptz,
    -- A missing expiry reads as "never expires" to every query that filters on
    -- it, which is the one direction that lets an out-of-date unit reach a
    -- patient.
    expires_at timestamptz NOT NULL,

    created_at timestamptz NOT NULL,
    created_by text        NOT NULL CHECK (created_by <> ''),
    version    bigint      NOT NULL DEFAULT 1,

    -- Collected from a donor here, or received from somebody who did. Neither
    -- is an unprovenanced unit.
    CONSTRAINT a_component_names_its_origin CHECK (
        donor_id IS NOT NULL OR source <> ''
    ),
    CONSTRAINT a_component_expires_after_collection CHECK (
        collected_at IS NULL OR expires_at > collected_at
    ),
    CONSTRAINT a_discard_says_why CHECK (
        status <> 'discarded' OR discard_reason <> ''
    ),
    UNIQUE (tenant_id, unit_number)
);

-- The allocation search: what is available, of this type and group, soonest to
-- expire first so the bank issues the unit that would otherwise be wasted.
CREATE INDEX component_allocatable_idx
    ON bloodbank.component (tenant_id, component_class, abo, rhd, expires_at)
    WHERE status = 'available';
CREATE INDEX component_collection_idx
    ON bloodbank.component (tenant_id, collection_id);
-- The expiry sweep and the stock report.
CREATE INDEX component_expiry_idx
    ON bloodbank.component (tenant_id, expires_at)
    WHERE status IN ('quarantined', 'available', 'reserved');

CREATE TABLE bloodbank.request (
    request_id uuid PRIMARY KEY,
    tenant_id  uuid NOT NULL,

    patient_id   uuid NOT NULL,
    encounter_id uuid,
    facility_id  text NOT NULL DEFAULT '',

    component_class text NOT NULL CHECK (component_class IN (
        'red_cells', 'plasma', 'platelets', 'cryoprecipitate', 'whole_blood')),
    quantity integer NOT NULL CHECK (quantity > 0),
    -- The one field a utilisation review cannot be done without.
    indication text NOT NULL CHECK (indication <> ''),
    urgency    text NOT NULL CHECK (urgency IN ('routine', 'urgent', 'emergency')),
    -- Irradiated, CMV-negative. A unit that does not carry them is not a match
    -- however well the groups agree.
    requirements text[] NOT NULL DEFAULT '{}',
    required_by  timestamptz,

    status text NOT NULL CHECK (status IN ('open', 'fulfilled', 'cancelled')),

    requested_by text        NOT NULL CHECK (requested_by <> ''),
    requested_at timestamptz NOT NULL,
    version      bigint      NOT NULL DEFAULT 1
);

CREATE INDEX request_patient_idx
    ON bloodbank.request (tenant_id, patient_id, requested_at);
-- The blood bank's worklist: open requests, most urgent and soonest needed
-- first. A request with no required-by time sorts last rather than hiding.
CREATE INDEX request_worklist_idx
    ON bloodbank.request (tenant_id, urgency, required_by)
    WHERE status = 'open';

CREATE TABLE bloodbank.patient_sample (
    sample_id uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    patient_id uuid NOT NULL,
    -- The identifier on the tube. Without it a sample cannot be matched back
    -- to the draw, and "we bled the wrong patient" is unanswerable.
    sample_number text NOT NULL CHECK (sample_number <> ''),

    abo text NOT NULL CHECK (abo IN ('A', 'B', 'AB', 'O')),
    rhd text NOT NULL CHECK (rhd IN ('positive', 'negative')),

    antibody_screen_positive boolean NOT NULL DEFAULT false,
    antibody_note            text    NOT NULL DEFAULT '',
    -- The second, independently drawn sample most protocols want before a
    -- first transfusion. Recorded rather than enforced, because units differ.
    second_check boolean NOT NULL DEFAULT false,

    collected_at timestamptz NOT NULL,
    collected_by text        NOT NULL DEFAULT '',
    -- A sample older than the window cannot support a crossmatch: the patient
    -- may have been transfused since and formed new antibodies.
    expires_at timestamptz NOT NULL,
    tested_at  timestamptz NOT NULL,
    tested_by  text        NOT NULL CHECK (tested_by <> ''),

    CONSTRAINT a_sample_expires_after_collection CHECK (
        expires_at > collected_at
    ),
    UNIQUE (tenant_id, sample_number)
);

CREATE INDEX sample_patient_idx
    ON bloodbank.patient_sample (tenant_id, patient_id, expires_at);

CREATE TABLE bloodbank.reservation (
    reservation_id uuid PRIMARY KEY,
    tenant_id      uuid NOT NULL,

    component_id uuid NOT NULL REFERENCES bloodbank.component (component_id),
    request_id   uuid REFERENCES bloodbank.request (request_id),
    patient_id   uuid NOT NULL,
    sample_id    uuid REFERENCES bloodbank.patient_sample (sample_id),

    -- A serological crossmatch actually performed, as distinct from an
    -- electronic issue. False on an emergency release, which is the point.
    crossmatched    boolean NOT NULL DEFAULT false,
    crossmatch_note text    NOT NULL DEFAULT '',

    status text NOT NULL CHECK (status IN (
        'held', 'issued', 'released', 'expired')),
    -- Reservations expire because blood held for a patient who did not need it
    -- is blood the next patient could not have.
    expires_at timestamptz NOT NULL,

    reserved_at     timestamptz NOT NULL,
    reserved_by     text        NOT NULL CHECK (reserved_by <> ''),
    released_reason text        NOT NULL DEFAULT ''
);

-- One live reservation per unit. Two patients holding the same unit is the
-- allocation conflict SRS-BLD-008 names, and it is the database's to prevent
-- rather than a service's.
CREATE UNIQUE INDEX reservation_one_live_per_unit_idx
    ON bloodbank.reservation (tenant_id, component_id)
    WHERE status = 'held';
CREATE INDEX reservation_patient_idx
    ON bloodbank.reservation (tenant_id, patient_id, reserved_at);
CREATE INDEX reservation_request_idx
    ON bloodbank.reservation (tenant_id, request_id);

CREATE TABLE bloodbank.issue (
    issue_id  uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    component_id   uuid NOT NULL REFERENCES bloodbank.component (component_id),
    reservation_id uuid REFERENCES bloodbank.reservation (reservation_id),
    patient_id     uuid NOT NULL,
    request_id     uuid REFERENCES bloodbank.request (request_id),

    -- A unit that left with no destination is one nobody can fetch back.
    destination text NOT NULL CHECK (destination <> ''),

    emergency            boolean NOT NULL DEFAULT false,
    emergency_authoriser text    NOT NULL DEFAULT '',
    emergency_reason     text    NOT NULL DEFAULT '',
    reconciled           boolean NOT NULL DEFAULT false,
    reconciled_at        timestamptz,
    reconciled_by        text    NOT NULL DEFAULT '',
    reconcile_note       text    NOT NULL DEFAULT '',

    issued_at timestamptz NOT NULL,
    issued_by text        NOT NULL CHECK (issued_by <> ''),
    issued_to text        NOT NULL DEFAULT '',
    -- Who made the final identity check at the counter (SRS-BLD-009). A system
    -- where the check is implicit is a system where it did not happen.
    checked_by text NOT NULL CHECK (checked_by <> ''),

    -- SRS-BLD-009 and SRS-BLD-016 in one constraint: a unit leaves because it
    -- was crossmatched for somebody, or because a named senior clinician said
    -- so and gave a reason. There is no third way out.
    CONSTRAINT a_unit_leaves_by_one_of_two_routes CHECK (
        (NOT emergency AND reservation_id IS NOT NULL)
        OR (emergency AND emergency_authoriser <> '' AND emergency_reason <> '')
    ),
    CONSTRAINT a_reconciliation_says_what_it_found CHECK (
        NOT reconciled
        OR (reconcile_note <> '' AND reconciled_at IS NOT NULL
            AND reconciled_by <> '')
    ),
    -- Only an emergency release is reconciled; marking an ordinary issue
    -- reconciled would make the outstanding list wrong in the safe-looking
    -- direction.
    CONSTRAINT only_an_emergency_is_reconciled CHECK (
        emergency OR NOT reconciled
    )
);

CREATE INDEX issue_component_idx ON bloodbank.issue (tenant_id, component_id);
CREATE INDEX issue_patient_idx ON bloodbank.issue (tenant_id, patient_id, issued_at);
-- The outstanding reconciliation list, which is what SRS-BLD-016's "later
-- reconciled" clause is read against.
CREATE INDEX issue_unreconciled_idx
    ON bloodbank.issue (tenant_id, issued_at)
    WHERE emergency AND NOT reconciled;

CREATE TABLE bloodbank.episode (
    episode_id uuid PRIMARY KEY,
    tenant_id  uuid NOT NULL,

    component_id uuid NOT NULL REFERENCES bloodbank.component (component_id),
    issue_id     uuid REFERENCES bloodbank.issue (issue_id),
    patient_id   uuid NOT NULL,
    encounter_id uuid,

    status text NOT NULL CHECK (status IN (
        'running', 'interrupted', 'completed', 'stopped')),

    started_at timestamptz NOT NULL,
    started_by text        NOT NULL CHECK (started_by <> ''),
    ended_at   timestamptz,
    -- What the patient actually received, which is not the unit's volume when
    -- a transfusion was stopped part-way.
    volume_given_ml integer NOT NULL DEFAULT 0,
    -- Coded on an abandoned transfusion, because a haemovigilance report
    -- counts them and has to tell a reaction from a tissued cannula.
    stop_reason text NOT NULL DEFAULT '',

    -- Both people who checked at the bedside (SRS-BLD-010). One person
    -- checking alone is the commonest root cause in every published
    -- wrong-blood incident, so the database holds the rule too.
    checked_by   text NOT NULL CHECK (checked_by <> ''),
    checked_with text NOT NULL CHECK (checked_with <> ''),

    CONSTRAINT a_bedside_check_needs_two_people CHECK (
        lower(checked_by) <> lower(checked_with)
    ),
    CONSTRAINT a_transfusion_ends_after_it_starts CHECK (
        ended_at IS NULL OR ended_at >= started_at
    ),
    CONSTRAINT an_abandoned_transfusion_says_why CHECK (
        status <> 'stopped' OR stop_reason <> ''
    )
);

-- One unit is transfused once. A second episode against the same unit is the
-- same transfusion recorded twice, and the two would disagree.
CREATE UNIQUE INDEX episode_one_per_unit_idx
    ON bloodbank.episode (tenant_id, component_id);
CREATE INDEX episode_patient_idx
    ON bloodbank.episode (tenant_id, patient_id, started_at);

CREATE TABLE bloodbank.observation (
    observation_id uuid PRIMARY KEY,
    tenant_id      uuid NOT NULL,
    episode_id     uuid NOT NULL
        REFERENCES bloodbank.episode (episode_id) ON DELETE CASCADE,

    -- Where in the transfusion the set was taken. Coded, because the audit that
    -- matters is whether the fifteen-minute set exists.
    timing text  NOT NULL CHECK (timing <> ''),
    values jsonb NOT NULL DEFAULT '{}'::jsonb,
    note   text  NOT NULL DEFAULT '',

    observed_at timestamptz NOT NULL,
    observed_by text        NOT NULL CHECK (observed_by <> '')
);

CREATE INDEX observation_episode_idx
    ON bloodbank.observation (tenant_id, episode_id, observed_at);

CREATE TABLE bloodbank.reaction (
    reaction_id uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,

    episode_id uuid REFERENCES bloodbank.episode (episode_id),
    -- NOT NULL: the investigation's first job is to find the other components
    -- made from the same donation, and a reaction recorded against a patient
    -- alone cannot.
    component_id uuid NOT NULL REFERENCES bloodbank.component (component_id),
    patient_id   uuid NOT NULL,

    severity text NOT NULL CHECK (severity IN (
        'mild', 'moderate', 'severe', 'fatal')),
    -- What was seen, listed rather than classified: the classification is the
    -- investigation's conclusion and this is the report that starts it.
    features text[] NOT NULL,
    note     text   NOT NULL DEFAULT '',

    reported_at timestamptz NOT NULL,
    reported_by text        NOT NULL CHECK (reported_by <> ''),

    state text NOT NULL CHECK (state IN ('open', 'concluded')),
    classification text NOT NULL DEFAULT '',
    conclusion     text NOT NULL DEFAULT '',
    concluded_at   timestamptz,
    concluded_by   text NOT NULL DEFAULT '',
    unit_returned  boolean NOT NULL DEFAULT false,

    -- COALESCE because array_length of an empty array is NULL, and a CHECK
    -- that evaluates to NULL passes.
    CONSTRAINT a_reaction_records_what_was_seen CHECK (
        COALESCE(array_length(features, 1), 0) >= 1
    ),
    CONSTRAINT a_conclusion_is_classified CHECK (
        state <> 'concluded'
        OR (classification <> '' AND concluded_at IS NOT NULL
            AND concluded_by <> '')
    )
);

CREATE INDEX reaction_component_idx ON bloodbank.reaction (tenant_id, component_id);
CREATE INDEX reaction_patient_idx ON bloodbank.reaction (tenant_id, patient_id);
-- The open investigations, which is the haemovigilance officer's worklist.
CREATE INDEX reaction_open_idx ON bloodbank.reaction (tenant_id, reported_at)
    WHERE state = 'open';

CREATE TABLE bloodbank.stock_threshold (
    threshold_id uuid PRIMARY KEY,
    tenant_id    uuid NOT NULL,
    facility_id  text NOT NULL DEFAULT '',

    component_class text NOT NULL CHECK (component_class IN (
        'red_cells', 'plasma', 'platelets', 'cryoprecipitate', 'whole_blood')),
    abo text NOT NULL CHECK (abo IN ('A', 'B', 'AB', 'O')),
    rhd text NOT NULL CHECK (rhd IN ('positive', 'negative')),

    minimum integer NOT NULL CHECK (minimum >= 0),

    set_by text        NOT NULL CHECK (set_by <> ''),
    set_at timestamptz NOT NULL,

    UNIQUE (tenant_id, facility_id, component_class, abo, rhd)
);
