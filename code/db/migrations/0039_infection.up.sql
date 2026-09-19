-- 0039 Infection prevention and control (SRS-IPC-001 … 010).
--
-- Seven shapes here are unusual and deliberate.
--
-- A surveillance case holds its derived onset classification and any override
-- in separate columns. One column would be simpler and would also make every
-- reclassification invisible — and reclassifying a healthcare-associated
-- infection as community-acquired does not move it between reports, it
-- removes it from the rate. The override columns carry a mandatory reason and
-- a named reviewer, and the case freezes the surveillance window it was
-- classified under so a definition change cannot silently re-judge history.
--
-- Device-day denominators are one row per device per location per day, with a
-- unique index saying so. Two rows for a day would double a denominator and
-- halve every rate that reads it, and SRS-IPC-002's acceptance is that rates
-- are reproducible. device_days <= patient_days is a CHECK because more
-- devices than patients is a counting mistake that produces a utilisation
-- ratio above one that nobody can explain.
--
-- infection.hygiene_observation has no column naming the person observed.
-- Not a nullable one, not an optional one: SRS-IPC-006 requires reports
-- aggregate "without exposing unnecessary identity", and a column that does
-- not exist is a column a future screen cannot start populating. The observer
-- is named — an audit's quality depends on who did it — and the observed
-- never are.
--
-- infection.exposure carries restricted boolean NOT NULL DEFAULT true with a
-- CHECK that it is true. An occupational exposure record is health
-- information about a member of staff held by their employer, with a source
-- patient's serology in it. An unrestricted row is not a configuration
-- choice; it is a mistake, so it cannot be written.
--
-- infection.stewardship_review has no column that a medication order is
-- written from. SRS-IPC-008's acceptance is that a review appears in the
-- worklist "without autonomous medication change", and the structural version
-- of that is a table with nothing to change a prescription with: an order
-- reference the reviewer opens, advice, and the prescriber's recorded
-- response. responded_by <> reviewed_by is a CHECK, because acceptance rate
-- is the one number a stewardship programme is judged on and a programme that
-- can close its own advice as accepted writes that number itself.
--
-- Alert rules, stewardship rules and environmental limits are all versioned
-- by (code, revision) rather than edited in place, and every alert, review and
-- result pins the revision it was judged under. A limit loosened after a bad
-- quarter would otherwise turn past failures into passes and the water would
-- look as though it had improved.
--
-- One rule is deliberately NOT in the database: a failing environmental
-- sample closing only through a verified corrective action, and a corrective
-- action verified only by a repeat of the same point taken after the work.
-- Both are cross-row rules over three tables, which a CHECK cannot express
-- and a trigger would express badly — the domain enforces them and the
-- repository tests assert the domain is the only path. What the database does
-- hold is that a verified action names its repeat sample and its verifier, so
-- a row claiming verification with nothing behind it cannot be written.
--
-- Trace: SRS-IPC-001 … SRS-IPC-010.
--
-- Rollback: drops the schema. Every surveillance case, device-day count,
-- isolation, alert, outbreak, hand hygiene observation, occupational exposure
-- and its follow-up tasks, stewardship review and environmental result goes
-- with it. The exposure records are staff health records with statutory
-- follow-up attached. Treat this as a disaster-recovery action, never a
-- deployment step.
--
-- Reconciliation: the tables are new, so the previous version writes nothing
-- here and sees nothing missing.

CREATE SCHEMA IF NOT EXISTS infection;

-- Surveillance cases (SRS-IPC-001).
CREATE TABLE infection.surveillance_case (
    case_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    reference    text NOT NULL DEFAULT '',
    patient_id   text NOT NULL CHECK (patient_id <> ''),
    encounter_id text NOT NULL DEFAULT '',
    facility_id  text NOT NULL DEFAULT '',
    location_id  text NOT NULL DEFAULT '',

    organism      text NOT NULL CHECK (organism <> ''),
    organism_code text NOT NULL DEFAULT '',
    site text NOT NULL CHECK (site IN (
        'ventilator_associated_pneumonia', 'central_line_bloodstream',
        'catheter_associated_urinary', 'surgical_site', 'bloodstream',
        'respiratory', 'urinary', 'skin_soft_tissue', 'gastrointestinal',
        'other')),
    multidrug_resistant boolean NOT NULL DEFAULT false,

    -- Derived from the dates by the domain. The override is a different
    -- column, always.
    onset text NOT NULL CHECK (onset IN (
        'community_acquired', 'healthcare_associated', 'indeterminate')),
    onset_override text NOT NULL DEFAULT '' CHECK (onset_override IN (
        '', 'community_acquired', 'healthcare_associated', 'indeterminate')),
    onset_override_why  text NOT NULL DEFAULT '',
    onset_overridden_by text NOT NULL DEFAULT '',

    admitted_at  timestamptz,
    onset_at     timestamptz NOT NULL,
    window_hours integer     NOT NULL,

    criteria    text NOT NULL DEFAULT '',
    reviewed_by text NOT NULL DEFAULT '',
    reviewed_at timestamptz,

    device_in_situ boolean NOT NULL DEFAULT false,
    device_days    integer NOT NULL DEFAULT 0 CHECK (device_days >= 0),

    state text NOT NULL CHECK (state IN (
        'suspected', 'confirmed', 'refuted', 'closed')),
    notes text NOT NULL DEFAULT '',

    reported_at timestamptz NOT NULL,
    reported_by text        NOT NULL CHECK (reported_by <> ''),
    closed_at   timestamptz,
    closed_by   text        NOT NULL DEFAULT '',

    version bigint NOT NULL DEFAULT 1,

    -- A reclassification with no reason and no name is a rate somebody
    -- adjusted and nobody can question.
    CONSTRAINT an_override_says_who_and_why CHECK (
        onset_override = ''
        OR (onset_override_why <> '' AND onset_overridden_by <> '')
    ),
    -- An "override" that agrees with the derivation is noise in the column
    -- that exists to show disagreement.
    CONSTRAINT an_override_differs_from_the_derivation CHECK (
        onset_override = '' OR onset_override <> onset
    ),
    -- A ventilator-associated pneumonia in a patient who was never ventilated
    -- inflates a numerator whose denominator it never entered.
    CONSTRAINT a_device_associated_case_had_the_device CHECK (
        site NOT IN ('ventilator_associated_pneumonia',
                     'central_line_bloodstream',
                     'catheter_associated_urinary')
        OR device_in_situ
    ),
    -- The first thing a surveyor asks about a rate is how the cases were
    -- counted.
    CONSTRAINT a_judged_case_retains_its_criteria CHECK (
        state NOT IN ('confirmed', 'refuted')
        OR (criteria <> '' AND reviewed_by <> '')
    ),
    -- A window of zero would classify everything as healthcare-associated and
    -- a negative one is meaningless.
    CONSTRAINT a_case_records_the_window_it_was_judged_under CHECK (
        window_hours >= 0
    )
);

CREATE UNIQUE INDEX surveillance_case_reference_idx
    ON infection.surveillance_case (tenant_id, reference)
    WHERE reference <> '';
CREATE INDEX surveillance_case_patient_idx
    ON infection.surveillance_case (tenant_id, patient_id, onset_at DESC);
CREATE INDEX surveillance_case_rate_idx
    ON infection.surveillance_case (tenant_id, site, location_id, onset_at)
    WHERE state = 'confirmed';
CREATE INDEX surveillance_case_open_idx
    ON infection.surveillance_case (tenant_id, state, onset_at DESC)
    WHERE state IN ('suspected', 'confirmed');
CREATE INDEX surveillance_case_mdro_idx
    ON infection.surveillance_case (tenant_id, organism_code, onset_at DESC)
    WHERE multidrug_resistant;

-- Device-day denominators (SRS-IPC-002).
CREATE TABLE infection.device_day_count (
    count_id  uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    facility_id text NOT NULL DEFAULT '',
    location_id text NOT NULL CHECK (location_id <> ''),
    device text NOT NULL CHECK (device IN (
        'ventilator', 'central_line', 'urinary_catheter')),

    counted_on   date    NOT NULL,
    patient_days integer NOT NULL CHECK (patient_days >= 0),
    device_days  integer NOT NULL CHECK (device_days >= 0),

    recorded_at timestamptz NOT NULL,
    recorded_by text        NOT NULL CHECK (recorded_by <> ''),

    -- More devices than patients produces a utilisation ratio above one that
    -- nobody can explain, and a denominator nobody can defend.
    CONSTRAINT device_days_do_not_exceed_patient_days CHECK (
        device_days <= patient_days
    )
);

-- One count per device per location per day. Two would double the
-- denominator and halve every rate that reads it.
CREATE UNIQUE INDEX device_day_count_unique_idx
    ON infection.device_day_count
       (tenant_id, location_id, device, counted_on);
CREATE INDEX device_day_count_period_idx
    ON infection.device_day_count (tenant_id, device, counted_on);

-- Isolation and precautions (SRS-IPC-003).
CREATE TABLE infection.isolation (
    isolation_id uuid PRIMARY KEY,
    tenant_id    uuid NOT NULL,

    patient_id   text NOT NULL CHECK (patient_id <> ''),
    encounter_id text NOT NULL DEFAULT '',
    facility_id  text NOT NULL DEFAULT '',
    location_id  text NOT NULL DEFAULT '',
    bed_id       text NOT NULL DEFAULT '',

    precaution text NOT NULL CHECK (precaution IN (
        'standard', 'contact', 'droplet', 'airborne', 'protective')),
    -- The clinical justification. Held here and never rendered onto a board:
    -- a board is a screen on a wall that visitors walk past, and this is a
    -- diagnosis.
    reason  text NOT NULL CHECK (reason <> ''),
    case_id uuid REFERENCES infection.surveillance_case (case_id),

    started_at timestamptz NOT NULL,
    started_by text        NOT NULL CHECK (started_by <> ''),
    -- Precautions nobody reviews outlive their reason, and a patient left in
    -- a side room after they stopped being infectious is a harm of its own.
    review_due timestamptz,

    ended_at   timestamptz,
    ended_by   text NOT NULL DEFAULT '',
    end_reason text NOT NULL DEFAULT '',

    version bigint NOT NULL DEFAULT 1,

    -- Lifting precautions is a clinical decision, and an unexplained one
    -- cannot be questioned.
    CONSTRAINT lifting_precautions_says_why CHECK (
        ended_at IS NULL OR (end_reason <> '' AND ended_by <> '')
    )
);

CREATE INDEX isolation_board_idx
    ON infection.isolation (tenant_id, location_id, precaution)
    WHERE ended_at IS NULL;
CREATE INDEX isolation_patient_idx
    ON infection.isolation (tenant_id, patient_id, started_at DESC);
CREATE INDEX isolation_review_idx
    ON infection.isolation (tenant_id, review_due)
    WHERE ended_at IS NULL AND review_due IS NOT NULL;

-- Multidrug-resistant organism alert rules (SRS-IPC-004).
CREATE TABLE infection.alert_rule (
    rule_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    code     text    NOT NULL CHECK (code <> ''),
    name     text    NOT NULL DEFAULT '',
    revision integer NOT NULL CHECK (revision > 0),

    organisms text[] NOT NULL DEFAULT '{}',
    -- A rule with no horizon alerts on everybody for ever, and staff stop
    -- reading the alerts.
    lookback_days integer NOT NULL CHECK (lookback_days > 0),
    precaution text NOT NULL CHECK (precaution IN (
        'standard', 'contact', 'droplet', 'airborne', 'protective')),
    advice text NOT NULL DEFAULT '',

    approved    boolean NOT NULL DEFAULT false,
    approved_by text    NOT NULL DEFAULT '',
    approved_at timestamptz,

    effective_from timestamptz,
    superseded_at  timestamptz,
    created_at     timestamptz NOT NULL,
    created_by     text        NOT NULL CHECK (created_by <> ''),

    -- array_length of an empty array is NULL and a CHECK that evaluates to
    -- NULL passes, so the COALESCE is load-bearing.
    CONSTRAINT a_rule_names_the_organisms_it_covers CHECK (
        COALESCE(array_length(organisms, 1), 0) > 0
    ),
    -- One person writing and approving a rule is one person deciding what
    -- every ward is told about every patient.
    CONSTRAINT a_rule_is_approved_by_somebody_else CHECK (
        NOT approved
        OR (approved_by <> '' AND approved_by <> created_by
            AND effective_from IS NOT NULL)
    )
);

CREATE UNIQUE INDEX alert_rule_revision_idx
    ON infection.alert_rule (tenant_id, code, revision);
CREATE INDEX alert_rule_live_idx
    ON infection.alert_rule (tenant_id, effective_from DESC)
    WHERE approved AND superseded_at IS NULL;

-- Alerts raised for a patient at an encounter (SRS-IPC-004).
CREATE TABLE infection.alert (
    alert_id  uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    patient_id   text NOT NULL CHECK (patient_id <> ''),
    encounter_id text NOT NULL DEFAULT '',
    facility_id  text NOT NULL DEFAULT '',

    rule_id uuid REFERENCES infection.alert_rule (rule_id),
    -- The code and revision are copied rather than only referenced: an alert
    -- from eighteen months ago has to stay explicable after the rule has been
    -- changed twice.
    rule_code     text    NOT NULL CHECK (rule_code <> ''),
    rule_revision integer NOT NULL CHECK (rule_revision > 0),

    organism         text NOT NULL DEFAULT '',
    organism_code    text NOT NULL DEFAULT '',
    last_positive_at timestamptz,

    precaution text NOT NULL CHECK (precaution IN (
        'standard', 'contact', 'droplet', 'airborne', 'protective')),
    advice text NOT NULL DEFAULT '',

    raised_at timestamptz NOT NULL,

    acknowledged_at timestamptz,
    acknowledged_by text NOT NULL DEFAULT '',

    overridden     boolean NOT NULL DEFAULT false,
    override_why   text    NOT NULL DEFAULT '',
    overridden_by  text    NOT NULL DEFAULT '',
    overridden_at  timestamptz,

    -- SRS-IPC-004's acceptance is that the override is audited. An override
    -- with no reason and no name is the alert deciding itself.
    CONSTRAINT an_overridden_alert_says_who_and_why CHECK (
        NOT overridden OR (override_why <> '' AND overridden_by <> '')
    )
);

CREATE INDEX alert_encounter_idx
    ON infection.alert (tenant_id, encounter_id, raised_at DESC);
CREATE INDEX alert_unacknowledged_idx
    ON infection.alert (tenant_id, raised_at DESC)
    WHERE acknowledged_at IS NULL AND NOT overridden;
CREATE INDEX alert_override_idx
    ON infection.alert (tenant_id, overridden_at DESC) WHERE overridden;

-- Outbreak and cluster investigations (SRS-IPC-005).
CREATE TABLE infection.outbreak (
    outbreak_id uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,

    reference text NOT NULL DEFAULT '',
    organism  text NOT NULL DEFAULT '',
    -- Membership is only defensible against a definition. An outbreak whose
    -- cases were chosen one at a time is an outbreak whose size is whatever
    -- the investigator decided.
    case_definition text NOT NULL CHECK (case_definition <> ''),

    locations   text[]      NOT NULL DEFAULT '{}',
    window_from timestamptz NOT NULL,
    window_to   timestamptz NOT NULL,

    state text NOT NULL CHECK (state IN (
        'suspected', 'declared', 'contained', 'closed', 'refuted')),
    findings         text   NOT NULL DEFAULT '',
    control_measures text[] NOT NULL DEFAULT '{}',
    action_ids       text[] NOT NULL DEFAULT '{}',

    declared_at timestamptz,
    declared_by text NOT NULL DEFAULT '',
    closed_at   timestamptz,
    closed_by   text NOT NULL DEFAULT '',
    closure_why text NOT NULL DEFAULT '',

    created_at timestamptz NOT NULL,
    created_by text        NOT NULL CHECK (created_by <> ''),
    version    bigint      NOT NULL DEFAULT 1,

    -- A cluster with no window grows for ever.
    CONSTRAINT an_investigation_has_a_window CHECK (window_to > window_from),
    -- A cluster the hospital declared, investigated and closed having changed
    -- nothing is either an investigation that found nothing — which is what
    -- "refuted" is for — or one whose conclusions went nowhere.
    CONSTRAINT a_closed_outbreak_changed_something CHECK (
        state <> 'closed'
        OR (findings <> ''
            AND (COALESCE(array_length(control_measures, 1), 0) > 0
                 OR COALESCE(array_length(action_ids, 1), 0) > 0))
    ),
    CONSTRAINT a_finished_investigation_says_why CHECK (
        state NOT IN ('closed', 'refuted')
        OR (closure_why <> '' AND closed_by <> '')
    )
);

CREATE UNIQUE INDEX outbreak_reference_idx
    ON infection.outbreak (tenant_id, reference) WHERE reference <> '';
CREATE INDEX outbreak_open_idx
    ON infection.outbreak (tenant_id, state, window_from DESC)
    WHERE state IN ('suspected', 'declared', 'contained');

CREATE TABLE infection.outbreak_member (
    membership_id uuid PRIMARY KEY,
    tenant_id     uuid NOT NULL,
    outbreak_id   uuid NOT NULL
        REFERENCES infection.outbreak (outbreak_id) ON DELETE CASCADE,
    case_id    text NOT NULL DEFAULT '',
    patient_id text NOT NULL CHECK (patient_id <> ''),

    reason text NOT NULL CHECK (reason IN (
        'meets_definition', 'epidemiological_link', 'excluded')),
    note text NOT NULL DEFAULT '',

    decided_at timestamptz NOT NULL,
    decided_by text        NOT NULL CHECK (decided_by <> ''),

    -- Adding a case that does not meet the definition and removing one that
    -- does are the two directions a cluster's size gets quietly adjusted.
    CONSTRAINT an_unusual_membership_says_why CHECK (
        reason = 'meets_definition' OR note <> ''
    )
);

CREATE INDEX outbreak_member_outbreak_idx
    ON infection.outbreak_member (tenant_id, outbreak_id);

-- Hand hygiene observation (SRS-IPC-006).
CREATE TABLE infection.hygiene_session (
    session_id uuid PRIMARY KEY,
    tenant_id  uuid NOT NULL,

    facility_id text NOT NULL DEFAULT '',
    location_id text NOT NULL CHECK (location_id <> ''),
    -- The observer is named; an audit's quality depends on who did it, and
    -- two observers who disagree by thirty points is a finding about the
    -- observers.
    observer_id text NOT NULL CHECK (observer_id <> ''),

    started_at timestamptz NOT NULL,
    ended_at   timestamptz,
    notes      text NOT NULL DEFAULT '',

    created_at timestamptz NOT NULL,
    version    bigint      NOT NULL DEFAULT 1
);

CREATE INDEX hygiene_session_location_idx
    ON infection.hygiene_session (tenant_id, location_id, started_at DESC);

-- One opportunity and what happened. There is deliberately no column naming
-- the person observed: a hand hygiene audit that names individuals becomes a
-- disciplinary instrument, and the moment it does, observed compliance goes
-- to ninety-nine per cent and stops meaning anything.
CREATE TABLE infection.hygiene_observation (
    observation_id uuid PRIMARY KEY,
    tenant_id      uuid NOT NULL,
    session_id     uuid NOT NULL
        REFERENCES infection.hygiene_session (session_id) ON DELETE CASCADE,

    discipline text NOT NULL CHECK (discipline IN (
        'doctor', 'nurse', 'allied_health', 'support_staff', 'student',
        'visitor')),
    moment text NOT NULL CHECK (moment IN (
        'before_patient_contact', 'before_aseptic_procedure',
        'after_body_fluid_exposure', 'after_patient_contact',
        'after_patient_surroundings')),
    action text NOT NULL CHECK (action IN (
        'alcohol_rub', 'soap_and_water', 'missed', 'gloves_only')),
    gloves_worn boolean NOT NULL DEFAULT false,

    observed_at timestamptz NOT NULL,

    -- Gloves worn instead of cleaning hands is its own failure and the
    -- commonest one; recording it without gloves is a contradiction.
    CONSTRAINT gloves_only_wore_gloves CHECK (
        action <> 'gloves_only' OR gloves_worn
    )
);

CREATE INDEX hygiene_observation_session_idx
    ON infection.hygiene_observation (tenant_id, session_id);
CREATE INDEX hygiene_observation_period_idx
    ON infection.hygiene_observation (tenant_id, observed_at);

-- Occupational exposure (SRS-IPC-007).
CREATE TABLE infection.exposure (
    exposure_id uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,

    reference  text NOT NULL DEFAULT '',
    staff_id   text NOT NULL CHECK (staff_id <> ''),
    discipline text NOT NULL DEFAULT '',
    facility_id text NOT NULL DEFAULT '',
    location_id text NOT NULL DEFAULT '',

    kind text NOT NULL CHECK (kind IN (
        'needlestick', 'sharps', 'mucocutaneous_splash', 'bite',
        'airborne_contact')),
    device text NOT NULL DEFAULT '',
    -- What a prevention programme reads: the same cannula on the same ward
    -- three times is a finding. Without it the hospital knows it had eleven
    -- needlesticks and nothing about why.
    circumstance text    NOT NULL CHECK (circumstance <> ''),
    deep_injury  boolean NOT NULL DEFAULT false,

    source_patient_id text    NOT NULL DEFAULT '',
    source_known      boolean NOT NULL DEFAULT false,
    source_consented  boolean NOT NULL DEFAULT false,

    -- Not a configuration choice. This is a staff health record with a source
    -- patient's serology attached, and a hospital whose exposure records are
    -- readable by the ward is one whose staff stop reporting exposures.
    restricted boolean NOT NULL DEFAULT true CHECK (restricted),

    occurred_at timestamptz NOT NULL,
    reported_at timestamptz NOT NULL,
    reported_by text        NOT NULL CHECK (reported_by <> ''),

    closed_at timestamptz,
    closed_by text NOT NULL DEFAULT '',
    outcome   text NOT NULL DEFAULT '',

    version bigint NOT NULL DEFAULT 1,

    -- Testing a source patient's blood for a member of staff's benefit is a
    -- decision with its own law, and a system that did not record the consent
    -- would make it invisible.
    CONSTRAINT a_named_source_consented CHECK (
        source_patient_id = '' OR source_consented
    ),
    CONSTRAINT a_closed_exposure_records_its_outcome CHECK (
        closed_at IS NULL OR (outcome <> '' AND closed_by <> '')
    ),
    CONSTRAINT an_exposure_precedes_its_report CHECK (
        occurred_at <= reported_at
    )
);

CREATE UNIQUE INDEX exposure_reference_idx
    ON infection.exposure (tenant_id, reference) WHERE reference <> '';
CREATE INDEX exposure_staff_idx
    ON infection.exposure (tenant_id, staff_id, occurred_at DESC);
CREATE INDEX exposure_open_idx
    ON infection.exposure (tenant_id, occurred_at DESC)
    WHERE closed_at IS NULL;
CREATE INDEX exposure_device_idx
    ON infection.exposure (tenant_id, device, occurred_at DESC)
    WHERE device <> '';

CREATE TABLE infection.exposure_task (
    task_id     uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,
    exposure_id uuid NOT NULL
        REFERENCES infection.exposure (exposure_id) ON DELETE CASCADE,

    code text NOT NULL CHECK (code <> ''),
    -- When the step stops being useful, not when somebody would like it done.
    -- Post-exposure prophylaxis started after 72 hours is prophylaxis that
    -- does not work.
    due_by timestamptz NOT NULL,

    state text NOT NULL CHECK (state IN (
        'due', 'done', 'declined', 'not_applicable')),
    outcome      text NOT NULL DEFAULT '',
    completed_at timestamptz,
    completed_by text NOT NULL DEFAULT '',

    -- A declined prophylaxis and a prophylaxis nobody offered look identical
    -- without this.
    CONSTRAINT a_finished_step_says_what_happened CHECK (
        state = 'due' OR (outcome <> '' AND completed_by <> '')
    )
);

CREATE UNIQUE INDEX exposure_task_code_idx
    ON infection.exposure_task (tenant_id, exposure_id, code);
CREATE INDEX exposure_task_due_idx
    ON infection.exposure_task (tenant_id, due_by) WHERE state = 'due';

-- Antimicrobial stewardship (SRS-IPC-008).
CREATE TABLE infection.stewardship_rule (
    rule_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    code     text    NOT NULL CHECK (code <> ''),
    name     text    NOT NULL DEFAULT '',
    revision integer NOT NULL CHECK (revision > 0),

    kind text NOT NULL CHECK (kind IN (
        'restricted_agent', 'duration', 'bug_drug_mismatch',
        'de_escalation', 'iv_to_oral', 'redundant_cover')),
    agents     text[]  NOT NULL DEFAULT '{}',
    all_agents boolean NOT NULL DEFAULT false,
    day_threshold integer NOT NULL DEFAULT 0 CHECK (day_threshold >= 0),

    -- A trigger that says only "review" gets a review that says only
    -- "continue".
    prompt text NOT NULL CHECK (prompt <> ''),

    approved    boolean NOT NULL DEFAULT false,
    approved_by text    NOT NULL DEFAULT '',
    approved_at timestamptz,

    effective_from timestamptz,
    superseded_at  timestamptz,
    created_at     timestamptz NOT NULL,
    created_by     text        NOT NULL CHECK (created_by <> ''),

    -- A rule that silently widened to everything because somebody deleted its
    -- last agent would flood the worklist, and a flooded worklist is an unread
    -- one.
    CONSTRAINT a_rule_names_its_agents_or_says_all CHECK (
        all_agents OR COALESCE(array_length(agents, 1), 0) > 0
    ),
    -- A group of one cannot be redundant with itself.
    CONSTRAINT a_redundant_cover_rule_names_a_group CHECK (
        kind <> 'redundant_cover'
        OR COALESCE(array_length(agents, 1), 0) >= 2
    ),
    CONSTRAINT a_day_based_rule_names_its_day CHECK (
        kind NOT IN ('duration', 'de_escalation', 'iv_to_oral')
        OR day_threshold > 0
    ),
    CONSTRAINT a_stewardship_rule_is_approved_by_somebody_else CHECK (
        NOT approved
        OR (approved_by <> '' AND approved_by <> created_by
            AND effective_from IS NOT NULL)
    )
);

CREATE UNIQUE INDEX stewardship_rule_revision_idx
    ON infection.stewardship_rule (tenant_id, code, revision);
CREATE INDEX stewardship_rule_live_idx
    ON infection.stewardship_rule (tenant_id, kind, effective_from DESC)
    WHERE approved AND superseded_at IS NULL;

-- One worklist entry. Nothing in this table writes to a prescription:
-- order_id is a reference the reviewer opens, and the only outcomes recorded
-- are the advice and the prescriber's answer to it.
CREATE TABLE infection.stewardship_review (
    review_id uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    patient_id   text NOT NULL CHECK (patient_id <> ''),
    encounter_id text NOT NULL DEFAULT '',
    location_id  text NOT NULL DEFAULT '',

    rule_id       uuid REFERENCES infection.stewardship_rule (rule_id),
    rule_code     text    NOT NULL CHECK (rule_code <> ''),
    rule_revision integer NOT NULL CHECK (rule_revision > 0),
    kind text NOT NULL CHECK (kind IN (
        'restricted_agent', 'duration', 'bug_drug_mismatch',
        'de_escalation', 'iv_to_oral', 'redundant_cover')),
    agent    text NOT NULL DEFAULT '',
    order_id text NOT NULL DEFAULT '',
    why      text NOT NULL DEFAULT '',

    state text NOT NULL CHECK (state IN (
        'open', 'advised', 'closed', 'withdrawn')),
    raised_at timestamptz NOT NULL,
    due_by    timestamptz,

    recommendation text NOT NULL DEFAULT '' CHECK (recommendation IN (
        '', 'continue', 'stop', 'narrow_spectrum', 'switch_to_oral',
        'change_dose', 'send_cultures', 'refer_to_infection_specialist')),
    advice      text NOT NULL DEFAULT '',
    reviewed_by text NOT NULL DEFAULT '',
    reviewed_at timestamptz,

    response text NOT NULL DEFAULT '' CHECK (response IN (
        '', 'accepted', 'declined', 'modified')),
    response_reason text NOT NULL DEFAULT '',
    responded_by    text NOT NULL DEFAULT '',
    responded_at    timestamptz,

    withdrawn_reason text NOT NULL DEFAULT '',

    version bigint NOT NULL DEFAULT 1,

    -- "Narrow spectrum" without saying to what is advice nobody can act on.
    CONSTRAINT advice_says_what_to_do CHECK (
        state NOT IN ('advised', 'closed')
        OR (recommendation <> '' AND advice <> '' AND reviewed_by <> '')
    ),
    -- The stewardship team advises and somebody with prescribing authority
    -- decides. A programme that can close its own advice as accepted writes
    -- its own acceptance rate.
    CONSTRAINT the_reviewer_does_not_answer_for_the_prescriber CHECK (
        responded_by = '' OR responded_by <> reviewed_by
    ),
    CONSTRAINT a_closed_review_records_a_response CHECK (
        state <> 'closed' OR (response <> '' AND responded_by <> '')
    ),
    -- Declining advice is a clinical decision and a legitimate one; it is not
    -- a silent one.
    CONSTRAINT advice_not_taken_says_why CHECK (
        response NOT IN ('declined', 'modified') OR response_reason <> ''
    ),
    CONSTRAINT a_withdrawn_review_says_why CHECK (
        state <> 'withdrawn' OR withdrawn_reason <> ''
    )
);

-- Re-evaluating a patient every hour must not raise the same review every
-- hour. A revised rule asks a new question, so the revision is in the key.
CREATE UNIQUE INDEX stewardship_review_open_idx
    ON infection.stewardship_review
       (tenant_id, encounter_id, rule_code, rule_revision, lower(agent))
    WHERE state IN ('open', 'advised');
CREATE INDEX stewardship_review_worklist_idx
    ON infection.stewardship_review (tenant_id, due_by)
    WHERE state = 'open';
CREATE INDEX stewardship_review_patient_idx
    ON infection.stewardship_review (tenant_id, patient_id, raised_at DESC);

-- Environmental surveillance (SRS-IPC-009).
CREATE TABLE infection.environmental_limit (
    limit_id  uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    code     text    NOT NULL CHECK (code <> ''),
    name     text    NOT NULL DEFAULT '',
    revision integer NOT NULL CHECK (revision > 0),

    sample_kind text NOT NULL CHECK (sample_kind IN (
        'water', 'dialysis_water', 'ice', 'air_settle_plate',
        'air_particle_count', 'surface_swab', 'endoscope_rinse',
        'ventilation_pressure')),
    -- A number without its unit is a number nobody can compare.
    unit text NOT NULL CHECK (unit <> ''),

    action_level bigint NOT NULL,
    fail_level   bigint NOT NULL,
    -- Any detection fails regardless of count: legionella in an
    -- augmented-care water supply is the case this exists for.
    detection_fails  boolean NOT NULL DEFAULT false,
    -- Inverts the comparison for the measures where low is bad: an isolation
    -- room's negative pressure, an air-change rate.
    below_is_failure boolean NOT NULL DEFAULT false,

    approved    boolean NOT NULL DEFAULT false,
    approved_by text    NOT NULL DEFAULT '',
    approved_at timestamptz,

    effective_from timestamptz,
    superseded_at  timestamptz,
    created_at     timestamptz NOT NULL,
    created_by     text        NOT NULL CHECK (created_by <> ''),

    -- The ordering has to make sense in the direction the limit runs, or a
    -- result would be a failure and an action level at once.
    CONSTRAINT the_levels_run_in_the_limits_direction CHECK (
        (below_is_failure AND fail_level <= action_level)
        OR (NOT below_is_failure AND fail_level >= action_level)
    ),
    CONSTRAINT a_limit_is_approved_by_somebody_else CHECK (
        NOT approved
        OR (approved_by <> '' AND approved_by <> created_by
            AND effective_from IS NOT NULL)
    )
);

CREATE UNIQUE INDEX environmental_limit_revision_idx
    ON infection.environmental_limit (tenant_id, code, revision);
CREATE INDEX environmental_limit_live_idx
    ON infection.environmental_limit
       (tenant_id, sample_kind, effective_from DESC)
    WHERE approved AND superseded_at IS NULL;

CREATE TABLE infection.sampling_plan (
    plan_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    code        text NOT NULL DEFAULT '',
    sample_kind text NOT NULL CHECK (sample_kind IN (
        'water', 'dialysis_water', 'ice', 'air_settle_plate',
        'air_particle_count', 'surface_swab', 'endoscope_rinse',
        'ventilation_pressure')),
    facility_id  text NOT NULL DEFAULT '',
    location_id  text NOT NULL CHECK (location_id <> ''),
    sample_point text NOT NULL CHECK (sample_point <> ''),
    -- A plan with no interval is a plan nobody can be late for.
    every_days integer NOT NULL CHECK (every_days > 0),

    active     boolean     NOT NULL DEFAULT true,
    started_at timestamptz NOT NULL,
    stopped_at timestamptz
);

CREATE UNIQUE INDEX sampling_plan_point_idx
    ON infection.sampling_plan
       (tenant_id, location_id, sample_point, sample_kind)
    WHERE active;

CREATE TABLE infection.environmental_sample (
    sample_id uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    reference   text NOT NULL DEFAULT '',
    sample_kind text NOT NULL CHECK (sample_kind IN (
        'water', 'dialysis_water', 'ice', 'air_settle_plate',
        'air_particle_count', 'surface_swab', 'endoscope_rinse',
        'ventilation_pressure')),
    facility_id text NOT NULL DEFAULT '',
    -- SRS-IPC-009's acceptance is that results link to a location. A positive
    -- legionella result that names only "the hospital" tells the estates team
    -- nothing they can act on, and a ward's forty taps do not fail together.
    location_id  text NOT NULL CHECK (location_id <> ''),
    sample_point text NOT NULL CHECK (sample_point <> ''),

    plan_id      uuid REFERENCES infection.sampling_plan (plan_id),
    outbreak_id  uuid REFERENCES infection.outbreak (outbreak_id),
    repeat_of_id uuid REFERENCES infection.environmental_sample (sample_id),

    collected_at timestamptz NOT NULL,
    collected_by text        NOT NULL CHECK (collected_by <> ''),
    method       text        NOT NULL DEFAULT '',

    state text NOT NULL CHECK (state IN (
        'collected', 'resulted', 'closed')),

    lab_reference text   NOT NULL DEFAULT '',
    value         bigint NOT NULL DEFAULT 0,
    unit          text   NOT NULL DEFAULT '',
    organism      text   NOT NULL DEFAULT '',
    detected      boolean NOT NULL DEFAULT false,
    resulted_at   timestamptz,
    resulted_by   text   NOT NULL DEFAULT '',

    -- Derived from the limit by the domain, never typed. A failed water
    -- sample entered as a pass does not move between reports, it stops
    -- existing, and the ward carries on drinking it.
    outcome text NOT NULL DEFAULT '' CHECK (outcome IN (
        '', 'pass', 'action_level', 'fail', 'unassessable')),
    limit_code     text    NOT NULL DEFAULT '',
    limit_revision integer NOT NULL DEFAULT 0,

    closed_at timestamptz,
    closed_by text NOT NULL DEFAULT '',

    version bigint NOT NULL DEFAULT 1,

    CONSTRAINT a_resulted_sample_has_an_outcome CHECK (
        state = 'collected' OR (outcome <> '' AND resulted_at IS NOT NULL)
    ),
    -- A pass has to say which version of the limit passed it, or it stops
    -- being explicable the moment the limit moves.
    CONSTRAINT a_judged_result_pins_the_limit_revision CHECK (
        outcome NOT IN ('pass', 'action_level', 'fail')
        OR (limit_code <> '' AND limit_revision > 0)
    ),
    CONSTRAINT a_repeat_is_not_its_own_original CHECK (
        repeat_of_id IS NULL OR repeat_of_id <> sample_id
    )
);

CREATE INDEX environmental_sample_point_idx
    ON infection.environmental_sample
       (tenant_id, location_id, sample_point, collected_at DESC);
CREATE INDEX environmental_sample_failing_idx
    ON infection.environmental_sample (tenant_id, collected_at DESC)
    WHERE outcome IN ('action_level', 'fail', 'unassessable');
CREATE INDEX environmental_sample_plan_idx
    ON infection.environmental_sample (tenant_id, plan_id, collected_at DESC)
    WHERE plan_id IS NOT NULL;

CREATE TABLE infection.corrective_action (
    action_id uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    sample_id uuid NOT NULL
        REFERENCES infection.environmental_sample (sample_id),
    location_id text NOT NULL DEFAULT '',

    action text NOT NULL CHECK (action <> ''),
    -- An action nobody owns is an action nobody does.
    owner  text        NOT NULL CHECK (owner <> ''),
    due_by timestamptz NOT NULL,

    state text NOT NULL CHECK (state IN ('open', 'done', 'verified')),
    done_at   timestamptz,
    done_by   text NOT NULL DEFAULT '',
    done_note text NOT NULL DEFAULT '',

    repeat_sample_id uuid
        REFERENCES infection.environmental_sample (sample_id),
    verified_at timestamptz,
    verified_by text NOT NULL DEFAULT '',

    version bigint NOT NULL DEFAULT 1,

    CONSTRAINT a_done_action_says_what_was_done CHECK (
        state = 'open' OR (done_note <> '' AND done_by <> '')
    ),
    -- Verified by a repeat sample that passed, not by somebody saying the tap
    -- was flushed. Which repeat, and whether it passed, the domain decides;
    -- that there is one is held here.
    CONSTRAINT a_verified_action_names_its_repeat CHECK (
        state <> 'verified'
        OR (repeat_sample_id IS NOT NULL AND verified_by <> '')
    )
);

CREATE INDEX corrective_action_sample_idx
    ON infection.corrective_action (tenant_id, sample_id);
CREATE INDEX corrective_action_open_idx
    ON infection.corrective_action (tenant_id, due_by)
    WHERE state <> 'verified';
