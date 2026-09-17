-- 0030 Critical care (SRS-ICU-001 … 017).
--
-- Like the emergency department, the unit keeps no patient of its own: an ICU
-- episode is the critical-care detail of a Wave-1 encounter. What is here is
-- what only critical care has — the high-frequency flowsheet, organ support,
-- the lines in the patient, the scores, the bundles and the ceiling of
-- treatment.
--
-- Four shapes here are unusual and deliberate.
--
-- An observation stores the value twice: normalised, and as it arrived. A
-- conversion is a transformation, and a chart that cannot show what the device
-- actually sent cannot be audited against it. `normalised` is false where the
-- unit was not one the dimension defines, so a number that was not converted
-- is visibly not converted rather than quietly wrong.
--
-- A balance entry is superseded rather than updated. SRS-ICU-007's clause is
-- "late corrections are versioned; totals recalculate", and a fluid balance
-- that was silently edited is one a renal consultant cannot reason about the
-- next morning. Totals are computed from the live entries every time; nothing
-- stores a running total.
--
-- A score stores its inputs, one row each, and each names the observation it
-- read. SRS-ICU-009 requires the score to be reproducible from them, and a
-- stored total with no inputs is a claim nobody can check.
--
-- Nothing here stores an alarm state that could reach a device. SRS-ICU-013 is
-- explicit that this software's alarms are advisory and cannot suppress
-- device-native safety behaviour, so the alarm table below holds worklist
-- entries and nothing that a bedside monitor would ever read.
--
-- Trace: SRS-ICU-001 … SRS-ICU-017.
--
-- Rollback: drops the schema. Every flowsheet value, infusion titration,
-- ventilator setting, device insertion and ceiling of treatment goes with it,
-- and none of it is recoverable from the encounter it hangs off — the
-- encounter records that the patient was in critical care, not what was done
-- there. A recorded ceiling of treatment is a document a coroner reads. Treat
-- as a disaster-recovery action, never a deployment step.
--
-- Reconciliation: the tables are new, so the previous version writes nothing
-- here and sees nothing missing. The direction to watch is the encounter: an
-- episode created by the new version points at an encounter the old version
-- serves happily and shows no critical-care detail for. A display gap during
-- the rollout window rather than a correctness problem; it closes when every
-- replica is new.

CREATE SCHEMA IF NOT EXISTS icu;

CREATE TABLE icu.episode (
    episode_id   uuid        PRIMARY KEY,
    tenant_id    uuid        NOT NULL,
    encounter_id uuid        NOT NULL,
    patient_id   uuid        NOT NULL,
    facility_id  text        NOT NULL DEFAULT '',
    -- A hospital's units are its own — general, cardiac, neuro, paediatric —
    -- so an identifier rather than an enumeration.
    unit_id text NOT NULL CHECK (unit_id <> ''),
    -- Occupancy and device days are counted from the bed. An episode with
    -- none is one the unit's own numbers cannot see.
    bed_id  text NOT NULL CHECK (bed_id <> ''),

    -- Where the patient came from is a quality measure in its own right: an
    -- unplanned ward admission is a deterioration somebody may have missed,
    -- and a post-operative bed is a plan.
    source text NOT NULL CHECK (source IN (
               'emergency', 'ward', 'theatre', 'other_icu', 'external', 'direct')),
    -- The episode this one continues, for a patient moved between units. A
    -- twelve-hour stay that is the second half of a five-day one is not a
    -- twelve-hour stay.
    transferred_from uuid REFERENCES icu.episode (episode_id),

    responsible_team      text NOT NULL DEFAULT '',
    responsible_clinician text NOT NULL DEFAULT '',

    status text NOT NULL CHECK (status IN ('open', 'ready_for_transfer', 'closed')),

    admitted_at timestamptz NOT NULL,
    -- The gap between ready_at and discharged_at is the unit's discharge
    -- delay, which explains a full unit better than its admissions do.
    ready_at      timestamptz,
    discharged_at timestamptz,
    outcome       text NOT NULL DEFAULT '',
    outcome_note  text NOT NULL DEFAULT '',

    created_by text        NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL,
    version    bigint      NOT NULL DEFAULT 1,

    CONSTRAINT a_transfer_names_what_it_continues CHECK (
        source <> 'other_icu' OR transferred_from IS NOT NULL
    ),
    CONSTRAINT closed_episodes_name_an_outcome CHECK (
        status <> 'closed' OR (outcome <> '' AND discharged_at IS NOT NULL)
    ),
    CONSTRAINT discharge_follows_admission CHECK (
        discharged_at IS NULL OR discharged_at >= admitted_at
    )
);

CREATE INDEX episode_encounter_idx ON icu.episode (tenant_id, encounter_id);
CREATE INDEX episode_patient_idx ON icu.episode (tenant_id, patient_id);
-- The unit as it stands. Partial, because the dashboard is today's patients
-- and the table is every patient the unit has ever had.
CREATE INDEX episode_open_idx
    ON icu.episode (tenant_id, unit_id, admitted_at)
    WHERE status <> 'closed';

CREATE TABLE icu.observation (
    observation_id uuid        PRIMARY KEY,
    tenant_id      uuid        NOT NULL,
    episode_id     uuid        NOT NULL REFERENCES icu.episode (episode_id) ON DELETE CASCADE,

    code_system text NOT NULL DEFAULT '',
    code        text NOT NULL CHECK (code <> ''),
    display     text NOT NULL DEFAULT '',
    dimension   text NOT NULL DEFAULT '',

    -- The normalised value, and the value as it arrived beside it.
    value      double precision NOT NULL,
    unit       text             NOT NULL DEFAULT '',
    raw_value  double precision NOT NULL,
    raw_unit   text             NOT NULL DEFAULT '',
    normalised boolean          NOT NULL DEFAULT false,

    source     text NOT NULL CHECK (source IN ('manual', 'device', 'calculated', 'unknown')),
    validation text NOT NULL CHECK (validation IN (
                   'not_required', 'pending', 'confirmed', 'rejected')),

    device_id  text        NOT NULL DEFAULT '',
    device_model      text NOT NULL DEFAULT '',
    device_channel    text NOT NULL DEFAULT '',
    -- The device's own clock, which disagrees with ours. A monitor an hour out
    -- produces a trend an hour out, and a feed with no reading at all is one
    -- nothing is coming from.
    device_measured_at timestamptz,
    -- What the device said about its own reading, verbatim. Never
    -- interpreted: every vendor's quality vocabulary is its own.
    device_quality text NOT NULL DEFAULT '',

    observed_at timestamptz NOT NULL,
    recorded_at timestamptz NOT NULL,
    recorded_by text        NOT NULL DEFAULT '',

    validated_by    text NOT NULL DEFAULT '',
    validated_at    timestamptz,
    validation_note text NOT NULL DEFAULT '',

    -- The whole point of the distinction is being able to say which machine.
    CONSTRAINT a_device_reading_names_its_device CHECK (
        source <> 'device' OR device_id <> ''
    ),
    -- A value a person typed was validated by their typing it.
    CONSTRAINT only_device_readings_await_validation CHECK (
        source = 'device' OR validation = 'not_required'
    )
);

CREATE INDEX observation_episode_idx ON icu.observation (tenant_id, episode_id, observed_at);
CREATE INDEX observation_code_idx ON icu.observation (tenant_id, episode_id, code, observed_at);
-- The nurse's validation worklist. Partial, because a unit's pending readings
-- are a handful and its confirmed ones are millions.
CREATE INDEX observation_pending_idx
    ON icu.observation (tenant_id, episode_id, observed_at)
    WHERE validation = 'pending';

CREATE TABLE icu.balance_entry (
    entry_id   uuid        PRIMARY KEY,
    tenant_id  uuid        NOT NULL,
    episode_id uuid        NOT NULL REFERENCES icu.episode (episode_id) ON DELETE CASCADE,

    direction text NOT NULL CHECK (direction IN ('intake', 'output')),
    -- Two litres in is a different clinical picture from two litres of blood
    -- out, and the route is what tells them apart.
    route     text NOT NULL CHECK (route <> ''),
    volume_ml double precision NOT NULL CHECK (volume_ml >= 0),

    occurred_at timestamptz NOT NULL,
    recorded_at timestamptz NOT NULL,
    recorded_by text        NOT NULL CHECK (recorded_by <> ''),

    -- A correction supersedes rather than overwrites. Both sides are recorded
    -- so the arithmetic can be read afterwards.
    superseded_by     uuid REFERENCES icu.balance_entry (entry_id),
    corrects          uuid REFERENCES icu.balance_entry (entry_id),
    correction_reason text NOT NULL DEFAULT '',

    -- An unexplained correction to a fluid balance is the one a review asks
    -- about and the record cannot answer.
    CONSTRAINT a_correction_has_a_reason CHECK (
        corrects IS NULL OR correction_reason <> ''
    )
);

CREATE INDEX balance_episode_idx ON icu.balance_entry (tenant_id, episode_id, occurred_at);

CREATE TABLE icu.support (
    support_id uuid        PRIMARY KEY,
    tenant_id  uuid        NOT NULL,
    episode_id uuid        NOT NULL REFERENCES icu.episode (episode_id) ON DELETE CASCADE,

    kind text NOT NULL CHECK (kind IN (
             'ventilation', 'vasopressor', 'renal_replacement', 'ecmo', 'other')),
    label    text NOT NULL DEFAULT '',
    modality text NOT NULL DEFAULT '',

    -- Start and stop rather than a flag, because the question the unit is
    -- asked is "how many ventilator days" and a boolean answers "is this
    -- patient ventilated now", which nobody was asking.
    started_at timestamptz NOT NULL,
    started_by text        NOT NULL CHECK (started_by <> ''),
    stopped_at timestamptz,
    stopped_by text        NOT NULL DEFAULT '',
    stop_note  text        NOT NULL DEFAULT '',

    CONSTRAINT support_stops_after_it_starts CHECK (
        stopped_at IS NULL OR stopped_at >= started_at
    ),
    CONSTRAINT local_support_is_named CHECK (kind <> 'other' OR label <> '')
);

CREATE INDEX support_episode_idx ON icu.support (tenant_id, episode_id, started_at);
CREATE INDEX support_active_idx
    ON icu.support (tenant_id, episode_id, kind)
    WHERE stopped_at IS NULL;

CREATE TABLE icu.vent_setting (
    setting_id uuid        PRIMARY KEY,
    tenant_id  uuid        NOT NULL,
    episode_id uuid        NOT NULL REFERENCES icu.episode (episode_id) ON DELETE CASCADE,
    support_id uuid        REFERENCES icu.support (support_id) ON DELETE SET NULL,

    -- The vendor's own mode string. Every manufacturer names modes
    -- differently, and a normalised enumeration would lose the mode the
    -- machine is actually in.
    mode text NOT NULL CHECK (mode <> ''),
    -- Set parameters and measured ones side by side, because the difference
    -- between a set tidal volume and a delivered one is the clinical finding.
    parameters jsonb NOT NULL DEFAULT '{}'::jsonb,
    measured   jsonb NOT NULL DEFAULT '{}'::jsonb,
    units      jsonb NOT NULL DEFAULT '{}'::jsonb,

    device_id text NOT NULL DEFAULT '',

    effective_at  timestamptz NOT NULL,
    recorded_at   timestamptz NOT NULL,
    recorded_by   text        NOT NULL DEFAULT '',
    change_reason text        NOT NULL DEFAULT '',

    CONSTRAINT a_vent_record_names_a_nurse_or_a_device CHECK (
        recorded_by <> '' OR device_id <> ''
    )
);

CREATE INDEX vent_setting_episode_idx
    ON icu.vent_setting (tenant_id, episode_id, effective_at);

CREATE TABLE icu.infusion (
    infusion_id uuid        PRIMARY KEY,
    tenant_id   uuid        NOT NULL,
    episode_id  uuid        NOT NULL REFERENCES icu.episode (episode_id) ON DELETE CASCADE,

    -- The Wave-1 prescription is the authority; this is the record of what was
    -- actually running.
    prescription_id uuid,
    drug_code    text NOT NULL CHECK (drug_code <> ''),
    drug_display text NOT NULL DEFAULT '',

    -- What is in the bag. A rate in mL/h means nothing without it, and the
    -- commonest infusion error is a bag made up to a different concentration
    -- from the one the pump was programmed for.
    concentration_amount double precision NOT NULL CHECK (concentration_amount > 0),
    concentration_unit   text             NOT NULL DEFAULT '',
    concentration_volume double precision NOT NULL CHECK (concentration_volume > 0),

    dose_unit text NOT NULL CHECK (dose_unit <> ''),
    -- The weight the dose was calculated from, frozen at the time. A dose
    -- recomputed from a weight recorded three days later is not the dose that
    -- was given.
    weight_kg double precision NOT NULL DEFAULT 0,

    started_at timestamptz NOT NULL,
    started_by text        NOT NULL CHECK (started_by <> ''),
    stopped_at timestamptz,
    stopped_by text        NOT NULL DEFAULT ''
);

CREATE INDEX infusion_episode_idx ON icu.infusion (tenant_id, episode_id, started_at);
CREATE INDEX infusion_running_idx
    ON icu.infusion (tenant_id, episode_id)
    WHERE stopped_at IS NULL;

CREATE TABLE icu.titration (
    titration_id uuid        PRIMARY KEY,
    tenant_id    uuid        NOT NULL,
    infusion_id  uuid        NOT NULL REFERENCES icu.infusion (infusion_id) ON DELETE CASCADE,

    rate      double precision NOT NULL CHECK (rate >= 0),
    rate_unit text             NOT NULL DEFAULT '',
    -- The clinical dose the rate works out to, stored rather than recomputed:
    -- the concentration and the weight it was derived from may both change.
    dose double precision NOT NULL DEFAULT 0,

    effective_at timestamptz NOT NULL,
    recorded_at  timestamptz NOT NULL,
    recorded_by  text        NOT NULL DEFAULT '',
    device_id    text        NOT NULL DEFAULT '',
    reason       text        NOT NULL DEFAULT '',

    -- A rate change attributed to nobody is one no review can ask about.
    CONSTRAINT a_titration_names_a_nurse_or_a_pump CHECK (
        recorded_by <> '' OR device_id <> ''
    )
);

CREATE INDEX titration_infusion_idx ON icu.titration (tenant_id, infusion_id, effective_at);

CREATE TABLE icu.invasive_device (
    device_id  uuid        PRIMARY KEY,
    tenant_id  uuid        NOT NULL,
    episode_id uuid        NOT NULL REFERENCES icu.episode (episode_id) ON DELETE CASCADE,

    -- The deployment's own vocabulary. Every infection-surveillance definition
    -- names device categories differently.
    kind text NOT NULL CHECK (kind <> ''),
    -- A central line with no site is one nobody can find to remove, and site
    -- is half of every infection investigation.
    site   text    NOT NULL CHECK (site <> ''),
    lumens integer NOT NULL DEFAULT 0,

    inserted_at timestamptz NOT NULL,
    inserted_by text        NOT NULL CHECK (inserted_by <> ''),
    removed_at  timestamptz,
    removed_by  text        NOT NULL DEFAULT '',
    removal_reason text     NOT NULL DEFAULT '',

    -- The single most effective control on device-associated infection is
    -- asking daily whether the line can come out.
    review_every_seconds bigint NOT NULL DEFAULT 86400,
    last_reviewed_at     timestamptz,
    last_reviewed_by     text   NOT NULL DEFAULT '',

    CONSTRAINT device_comes_out_after_it_goes_in CHECK (
        removed_at IS NULL OR removed_at >= inserted_at
    )
);

CREATE INDEX invasive_device_episode_idx
    ON icu.invasive_device (tenant_id, episode_id, inserted_at);
-- The lines still in, which is what a review round works from.
CREATE INDEX invasive_device_in_idx
    ON icu.invasive_device (tenant_id, episode_id)
    WHERE removed_at IS NULL;

CREATE TABLE icu.score (
    score_id   uuid        PRIMARY KEY,
    tenant_id  uuid        NOT NULL,
    episode_id uuid        NOT NULL REFERENCES icu.episode (episode_id) ON DELETE CASCADE,

    -- Both, because scores are revised: one computed under one definition and
    -- compared against one computed under another is a trend that is an
    -- artefact of the revision.
    name            text NOT NULL CHECK (name <> ''),
    formula_version text NOT NULL CHECK (formula_version <> ''),

    total integer NOT NULL,
    -- The components no validated input was available for. A score with a
    -- missing component is incomplete, not lower: an absent platelet count
    -- scored as normal is how a coagulopathy scores zero.
    missing text[] NOT NULL DEFAULT '{}',

    calculated_at timestamptz NOT NULL,
    calculated_by text        NOT NULL DEFAULT ''
);

CREATE INDEX score_episode_idx ON icu.score (tenant_id, episode_id, calculated_at);

CREATE TABLE icu.score_input (
    score_id uuid NOT NULL REFERENCES icu.score (score_id) ON DELETE CASCADE,
    code     text NOT NULL,
    -- The exact chart entry, not just the value: the same number recorded
    -- twice is two observations, and a review asks which one.
    observation_id uuid             NOT NULL,
    value          double precision NOT NULL,
    unit           text             NOT NULL DEFAULT '',
    observed_at    timestamptz      NOT NULL,
    -- What this input contributed, so the arithmetic can be read without
    -- re-running the formula.
    points integer NOT NULL,

    PRIMARY KEY (score_id, code)
);

CREATE TABLE icu.bundle_performance (
    performance_id uuid        PRIMARY KEY,
    tenant_id      uuid        NOT NULL,
    episode_id     uuid        NOT NULL REFERENCES icu.episode (episode_id) ON DELETE CASCADE,

    kind text NOT NULL CHECK (kind IN (
             'sepsis', 'vte', 'delirium', 'pressure_injury', 'sedation',
             'ventilator', 'local')),
    label   text NOT NULL DEFAULT '',
    version text NOT NULL CHECK (version <> ''),

    performed_at timestamptz NOT NULL,
    performed_by text        NOT NULL CHECK (performed_by <> '')
);

CREATE INDEX bundle_episode_idx
    ON icu.bundle_performance (tenant_id, episode_id, performed_at);

CREATE TABLE icu.bundle_result (
    performance_id uuid NOT NULL
        REFERENCES icu.bundle_performance (performance_id) ON DELETE CASCADE,
    code  text NOT NULL,
    state text NOT NULL CHECK (state IN ('done', 'exception', 'not_done')),
    -- An exception with no reason is a failure wearing a better name.
    reason text NOT NULL DEFAULT '',

    PRIMARY KEY (performance_id, code),
    CONSTRAINT an_exception_has_a_reason CHECK (state <> 'exception' OR reason <> '')
);

CREATE TABLE icu.assessment (
    assessment_id uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    episode_id    uuid        NOT NULL REFERENCES icu.episode (episode_id) ON DELETE CASCADE,

    kind  text NOT NULL CHECK (kind <> ''),
    scale text NOT NULL DEFAULT '',
    score integer,
    findings jsonb NOT NULL DEFAULT '{}'::jsonb,
    note     text  NOT NULL DEFAULT '',

    performed_at timestamptz NOT NULL,
    performed_by text        NOT NULL CHECK (performed_by <> ''),
    -- Generated on write rather than by the reader, so the unit's worklist and
    -- its audit agree about when the reassessment was due.
    next_due_at timestamptz NOT NULL
);

CREATE INDEX assessment_episode_idx
    ON icu.assessment (tenant_id, episode_id, kind, performed_at);
CREATE INDEX assessment_due_idx ON icu.assessment (tenant_id, episode_id, next_due_at);

CREATE TABLE icu.round (
    round_id   uuid        PRIMARY KEY,
    tenant_id  uuid        NOT NULL,
    episode_id uuid        NOT NULL REFERENCES icu.episode (episode_id) ON DELETE CASCADE,

    -- A multidisciplinary round with no pharmacist is not a multidisciplinary
    -- round, and a unit measuring its rounds needs to see that.
    attendance text[]      NOT NULL DEFAULT '{}',
    summary    text        NOT NULL DEFAULT '',

    performed_at timestamptz NOT NULL,
    performed_by text        NOT NULL CHECK (performed_by <> '')
);

CREATE INDEX round_episode_idx ON icu.round (tenant_id, episode_id, performed_at);

CREATE TABLE icu.goal (
    goal_id    uuid        PRIMARY KEY,
    tenant_id  uuid        NOT NULL,
    episode_id uuid        NOT NULL REFERENCES icu.episode (episode_id) ON DELETE CASCADE,
    round_id   uuid        REFERENCES icu.round (round_id) ON DELETE SET NULL,

    domain text NOT NULL DEFAULT '',
    text   text NOT NULL CHECK (text <> ''),
    -- A role rather than a person, because the person changes at handover and
    -- the responsibility does not. One of the two is required: a goal nobody
    -- owns is the one the round reads out every morning and nobody does.
    owner_role text NOT NULL DEFAULT '',
    owner_id   text NOT NULL DEFAULT '',

    status text NOT NULL CHECK (status IN ('open', 'met', 'not_met', 'cancelled')),
    target_at   timestamptz,
    resolved_at timestamptz,
    resolved_by text NOT NULL DEFAULT '',
    outcome     text NOT NULL DEFAULT '',

    created_by text        NOT NULL CHECK (created_by <> ''),
    created_at timestamptz NOT NULL,

    CONSTRAINT a_goal_is_owned CHECK (owner_role <> '' OR owner_id <> ''),
    -- A goal met needs no explanation. One abandoned or not met is the entry
    -- the next round has to act on.
    CONSTRAINT an_unmet_goal_says_why CHECK (
        status IN ('open', 'met') OR outcome <> ''
    )
);

CREATE INDEX goal_episode_idx ON icu.goal (tenant_id, episode_id, created_at);
CREATE INDEX goal_open_idx
    ON icu.goal (tenant_id, episode_id)
    WHERE status = 'open';

CREATE TABLE icu.goals_of_care (
    goals_of_care_id uuid        PRIMARY KEY,
    tenant_id        uuid        NOT NULL,
    episode_id       uuid        NOT NULL REFERENCES icu.episode (episode_id) ON DELETE CASCADE,

    intent text NOT NULL CHECK (intent IN ('full_escalation', 'limited', 'comfort')),
    limitations text[] NOT NULL DEFAULT '{}',
    -- Recorded separately because it is the first question every arriving team
    -- asks, and burying it in a list is how it is missed.
    cpr_status text NOT NULL DEFAULT '',

    discussed_with text NOT NULL DEFAULT '',
    rationale      text NOT NULL DEFAULT '',

    authorised_by   text NOT NULL CHECK (authorised_by <> ''),
    authorised_role text NOT NULL DEFAULT '',

    recorded_at timestamptz NOT NULL,
    recorded_by text        NOT NULL CHECK (recorded_by <> ''),
    -- Superseded rather than edited. A ceiling of treatment is the document a
    -- coroner reads, and one whose history was overwritten cannot answer what
    -- was agreed, by whom, and when it changed.
    --
    -- Deferred, because recording a new ceiling supersedes the old one in the
    -- same transaction and has to do so BEFORE inserting the new row: the
    -- partial unique index below permits exactly one current ceiling at a
    -- time, so the order is forced, and the reference to the not-yet-inserted
    -- replacement is only resolvable at commit.
    superseded_by uuid REFERENCES icu.goals_of_care (goals_of_care_id)
        DEFERRABLE INITIALLY DEFERRED,
    superseded_at timestamptz,
    -- A ceiling with no review date outlives the conversation that produced it.
    review_by timestamptz,

    CONSTRAINT limiting_treatment_has_a_rationale CHECK (
        intent = 'full_escalation' OR rationale <> ''
    )
);

CREATE INDEX goals_of_care_episode_idx
    ON icu.goals_of_care (tenant_id, episode_id, recorded_at);
-- Exactly one ceiling in force per episode, enforced rather than assumed. A
-- unit that briefly had two current ceilings is one where a resuscitation
-- decision was ambiguous, and the window does not have to be long for somebody
-- to arrest in it.
CREATE UNIQUE INDEX goals_of_care_current_idx
    ON icu.goals_of_care (tenant_id, episode_id)
    WHERE superseded_by IS NULL;
