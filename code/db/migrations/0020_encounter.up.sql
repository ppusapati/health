-- 0020 Encounters, episodes of care, care teams and diagnoses (SRS-ENC).
--
-- The shape here turns on one distinction the requirement makes explicitly
-- (SRS-ENC-003): an appointment is a plan, an encounter is what happened. A
-- patient can be seen without an appointment, an appointment can be kept
-- without a consultation ever starting, and a consultation can run long past
-- the slot it was booked into. So the encounter carries its own start and end,
-- and the appointment is a nullable reference rather than a parent.
--
-- One encounter table with a class column rather than seven tables, because
-- everything downstream — orders, results, notes, billing — attaches to an
-- encounter and would otherwise have to know about seven of them. The
-- differences between an outpatient visit and an admission are rules about one
-- thing, not seven things (SRS-ENC-002).
--
-- Diagnoses are append-only. A change of mind supersedes rather than
-- overwrites, because a differential that became a final diagnosis is a
-- clinical reasoning trail and overwriting it destroys the only evidence that
-- the reasoning happened (SRS-ENC-007).
--
-- Trace: SRS-ENC-001 (encounter with patient, facility, class, provider,
--   reason), SRS-ENC-002 (seven classes from one model), SRS-ENC-003 (clinical
--   times independent of the appointment), SRS-ENC-004 (episode of care),
--   SRS-ENC-005 (care team with role and effective time), SRS-ENC-006 (status
--   machine with cancelled and entered-in-error), SRS-ENC-007 (diagnoses with
--   certainty, rank and coding system), SRS-ENC-008 (closure policy and
--   audited override), SRS-ENC-009 (visit summary, amended not rewritten),
--   SRS-ENC-010 (external referral source).
-- Rollback: drops the whole schema. Every encounter is lost — which is the
--   record of who was seen, when and by whom, and the container every clinical
--   record in later waves points at. Export encounter, encounter_diagnosis and
--   visit_summary before dropping; the episodes and care teams can be rebuilt
--   from them only approximately, and the summaries not at all.
-- Reconciliation: none for the forward direction; the schema is new. The
--   previous version writes nothing here during the rollout window because it
--   does not know these tables exist.

CREATE SCHEMA IF NOT EXISTS encounter;

-- A course of treatment spanning encounters (SRS-ENC-004).
--
-- Deliberately thin: it holds the fact of the grouping and nothing else. The
-- acceptance criterion is that "multiple encounters can reference one episode
-- without copying data", and the moment this table held a copy of a diagnosis
-- or a plan, that copy would be the version somebody read after the original
-- changed.
CREATE TABLE encounter.episode (
    episode_id      uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    patient_id      uuid        NOT NULL,
    facility_id     uuid        NOT NULL,
    episode_type    text        NOT NULL CHECK (episode_type IN (
                        'pregnancy', 'oncology', 'dialysis', 'chronic_disease',
                        'rehabilitation', 'surgical_care', 'other')),
    -- What clinicians call it: "second pregnancy", "left breast". A patient
    -- with two pregnancies has two, and an unlabelled one cannot be picked out
    -- of a list.
    label           text        NOT NULL CHECK (label <> ''),
    -- Nullable: plenty of episodes are managed by a team rather than a person,
    -- and inventing an owner would put a name against decisions they did not
    -- make.
    care_manager_id text        NOT NULL DEFAULT '',
    status          text        NOT NULL CHECK (status IN (
                        'active', 'on_hold', 'finished', 'cancelled')),
    started_at      timestamptz NOT NULL,
    ended_at        timestamptz,
    created_by      text        NOT NULL,
    created_at      timestamptz NOT NULL,
    updated_at      timestamptz NOT NULL,
    version         bigint      NOT NULL DEFAULT 1,

    CONSTRAINT an_episode_ends_after_it_starts CHECK (
        ended_at IS NULL OR ended_at >= started_at
    ),
    -- A finished or cancelled course of care has an end date, or a report of
    -- "episodes closed this quarter" silently omits it.
    CONSTRAINT a_settled_episode_has_an_end CHECK (
        status NOT IN ('finished', 'cancelled') OR ended_at IS NOT NULL
    )
);

CREATE INDEX episode_patient_idx
    ON encounter.episode (tenant_id, patient_id, started_at DESC);

CREATE INDEX episode_open_idx
    ON encounter.episode (tenant_id, patient_id)
    WHERE status IN ('active', 'on_hold');

-- One episode of contact between a patient and the service (SRS-ENC-001).
CREATE TABLE encounter.encounter (
    encounter_id    uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    facility_id     uuid        NOT NULL,
    -- The ward, clinic or department. Nullable: a home-care visit belongs to
    -- no unit.
    org_unit_id     uuid,
    patient_id      uuid        NOT NULL,
    class           text        NOT NULL CHECK (class IN (
                        'outpatient', 'emergency', 'inpatient', 'day_care',
                        'telemedicine', 'home_care', 'diagnostic_only')),
    visit_type      text        NOT NULL DEFAULT '',
    -- One attending provider, not many. The care team holds everybody else; a
    -- record where responsibility is diffuse is one where nobody holds it.
    attending_provider_id text  NOT NULL DEFAULT '',
    -- Nullable, and nullable is not an error: SRS-ENC-003 requires the
    -- appointment and the encounter to be separately auditable, and a walk-in
    -- has no appointment at all.
    appointment_id  uuid,
    episode_id      uuid        REFERENCES encounter.episode (episode_id),
    -- The external request this visit answers (SRS-ENC-010).
    referral_id     text        NOT NULL DEFAULT '',
    reason          text        NOT NULL DEFAULT '',

    status          text        NOT NULL CHECK (status IN (
                        'planned', 'in_progress', 'on_leave', 'finished',
                        'closed', 'cancelled', 'entered_in_error')),
    -- Clinical times, independent of the appointment (SRS-ENC-003). Null until
    -- the encounter begins and ends.
    started_at      timestamptz,
    ended_at        timestamptz,
    closed_at       timestamptz,

    created_by      text        NOT NULL,
    created_at      timestamptz NOT NULL,
    updated_at      timestamptz NOT NULL,
    version         bigint      NOT NULL DEFAULT 1,

    CONSTRAINT an_encounter_ends_after_it_starts CHECK (
        ended_at IS NULL OR (started_at IS NOT NULL AND ended_at >= started_at)
    ),
    CONSTRAINT an_encounter_closes_after_it_ends CHECK (
        closed_at IS NULL OR ended_at IS NOT NULL
    ),
    -- Every class but diagnostic-only names somebody answerable. A visit with
    -- no named clinician is one where, six months later, nobody can say who
    -- decided.
    CONSTRAINT a_consultation_names_its_clinician CHECK (
        class = 'diagnostic_only' OR attending_provider_id <> ''
    )
);

CREATE INDEX encounter_patient_idx
    ON encounter.encounter (tenant_id, patient_id, started_at DESC NULLS FIRST);

-- The ward round: who is here now.
CREATE INDEX encounter_open_idx
    ON encounter.encounter (tenant_id, facility_id, class, started_at)
    WHERE status IN ('planned', 'in_progress', 'on_leave');

CREATE INDEX encounter_episode_idx
    ON encounter.encounter (tenant_id, episode_id)
    WHERE episode_id IS NOT NULL;

-- The appointment a visit answers, for closing the loop from the diary.
CREATE INDEX encounter_appointment_idx
    ON encounter.encounter (tenant_id, appointment_id)
    WHERE appointment_id IS NOT NULL;

-- Every status an encounter has held (SRS-ENC-006).
CREATE TABLE encounter.encounter_status_history (
    history_id      uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    encounter_id    uuid        NOT NULL
                        REFERENCES encounter.encounter (encounter_id)
                        ON DELETE CASCADE,
    from_status     text        NOT NULL DEFAULT '',
    to_status       text        NOT NULL,
    changed_at      timestamptz NOT NULL,
    changed_by      text        NOT NULL,
    -- Required for cancellation, entered-in-error and any change after
    -- closure. Those are the ones somebody asks about later.
    reason          text        NOT NULL DEFAULT ''
);

CREATE INDEX encounter_status_history_idx
    ON encounter.encounter_status_history (tenant_id, encounter_id, changed_at);

-- One person's involvement in one encounter, effective-dated (SRS-ENC-005).
--
-- Dated rather than a simple membership list because the question authorization
-- actually asks is "was this clinician on the team *at the time*". A list with
-- no dates answers today's question and silently gives the wrong answer to
-- every question about the past — including the one an investigation asks.
CREATE TABLE encounter.care_team_member (
    care_team_id    uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    encounter_id    uuid        NOT NULL
                        REFERENCES encounter.encounter (encounter_id)
                        ON DELETE CASCADE,
    subject_id      text        NOT NULL CHECK (subject_id <> ''),
    role            text        NOT NULL CHECK (role IN (
                        'attending', 'consulting', 'nurse', 'resident',
                        'therapist', 'pharmacist', 'social_work',
                        'admitting', 'discharging')),
    effective_from  timestamptz NOT NULL,
    -- Null means still involved.
    effective_until timestamptz,
    assigned_by     text        NOT NULL,
    assigned_at     timestamptz NOT NULL,

    CONSTRAINT an_assignment_ends_after_it_begins CHECK (
        effective_until IS NULL OR effective_until > effective_from
    )
);

-- The authorization question: is this clinician looking after this patient now.
CREATE INDEX care_team_active_idx
    ON encounter.care_team_member (tenant_id, encounter_id, effective_from)
    WHERE effective_until IS NULL;

CREATE INDEX care_team_subject_idx
    ON encounter.care_team_member (tenant_id, subject_id, effective_from DESC);

-- One condition recorded against one encounter (SRS-ENC-007).
--
-- Append-only: a change of mind is a new row that supersedes the old one.
CREATE TABLE encounter.encounter_diagnosis (
    diagnosis_id    uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    encounter_id    uuid        NOT NULL
                        REFERENCES encounter.encounter (encounter_id)
                        ON DELETE CASCADE,
    patient_id      uuid        NOT NULL,
    -- System and code together, never code alone: "C50" means breast cancer in
    -- ICD-10 and something else in a local scheme.
    code_system     text        NOT NULL CHECK (code_system <> ''),
    -- Pins the release. ICD-10 codes have been reassigned between revisions, so
    -- a code with no version is ambiguous once a decade.
    code_version    text        NOT NULL DEFAULT '',
    code            text        NOT NULL CHECK (code <> ''),
    -- A bare code on a screen is a screen clinicians stop reading.
    code_display    text        NOT NULL CHECK (code_display <> ''),
    certainty       text        NOT NULL CHECK (certainty IN (
                        'provisional', 'differential', 'final', 'ruled_out')),
    rank            text        NOT NULL CHECK (rank IN (
                        'primary', 'secondary', 'complication', 'comorbidity')),
    note            text        NOT NULL DEFAULT '',
    -- When the condition began, where known. Distinct from recorded_at: a
    -- diagnosis of an illness that started last month is not a diagnosis made
    -- last month.
    onset_at        timestamptz,

    -- Chains to the entry that replaced this one, so the trail reads forwards.
    --
    -- Deferrable because revising a diagnosis has to happen in one order: the
    -- old entry is superseded *before* the new one is inserted, or the partial
    -- unique index below would briefly see two live primaries and refuse. With
    -- the reference deferred to commit, both statements can run in the order the
    -- invariant needs and the chain is still checked before the transaction
    -- lands.
    superseded_by_id uuid       REFERENCES encounter.encounter_diagnosis (diagnosis_id)
                        DEFERRABLE INITIALLY DEFERRED,
    -- Distinct from superseded: superseded means the thinking moved on,
    -- retracted means this was never true of this patient.
    retracted_reason text       NOT NULL DEFAULT '',

    recorded_by     text        NOT NULL,
    recorded_at     timestamptz NOT NULL,

    -- A superseded entry and a retracted one are different claims; being both
    -- is neither.
    CONSTRAINT a_diagnosis_is_superseded_or_retracted_not_both CHECK (
        superseded_by_id IS NULL OR retracted_reason = ''
    )
);

CREATE INDEX encounter_diagnosis_idx
    ON encounter.encounter_diagnosis (tenant_id, encounter_id, recorded_at);

-- The patient's live conditions across every encounter, which is what a problem
-- list and a discharge summary both read.
CREATE INDEX encounter_diagnosis_live_idx
    ON encounter.encounter_diagnosis (tenant_id, patient_id, recorded_at DESC)
    WHERE superseded_by_id IS NULL AND retracted_reason = '';

-- Only one live primary diagnosis per encounter (SRS-ENC-007).
--
-- The rank answers "what was this visit about", and two answers is no answer.
CREATE UNIQUE INDEX encounter_one_live_primary_diagnosis
    ON encounter.encounter_diagnosis (tenant_id, encounter_id)
    WHERE rank = 'primary' AND superseded_by_id IS NULL AND retracted_reason = '';

-- What a facility requires before an encounter can be closed (SRS-ENC-008).
--
-- Per tenant, optionally per facility, the same resolution order as the
-- scheduling policies: the most specific row wins.
CREATE TABLE encounter.closure_policy (
    policy_id       uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    facility_id     uuid,
    encounter_class text        NOT NULL CHECK (encounter_class IN (
                        'outpatient', 'emergency', 'inpatient', 'day_care',
                        'telemedicine', 'home_care', 'diagnostic_only')),
    required_items  text[]      NOT NULL DEFAULT '{}',
    -- Per class, because the judgement differs: an emergency department that
    -- cannot close a resuscitation until the notes are perfect will simply
    -- leave it open, and an open encounter reads as a patient still under care.
    allow_override  boolean     NOT NULL DEFAULT false,
    created_at      timestamptz NOT NULL,
    updated_at      timestamptz NOT NULL
);

CREATE UNIQUE INDEX closure_policy_key
    ON encounter.closure_policy (
        tenant_id,
        COALESCE(facility_id, '00000000-0000-0000-0000-000000000000'::uuid),
        encounter_class
    );

-- A finalisation forced over an incomplete record (SRS-ENC-008).
--
-- Stored, not just audited. The audit trail answers "who did this"; this
-- answers "how often does this happen and for what", which is the question a
-- quality committee asks and the reason the requirement exists.
CREATE TABLE encounter.closure_override (
    override_id     uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    encounter_id    uuid        NOT NULL
                        REFERENCES encounter.encounter (encounter_id)
                        ON DELETE CASCADE,
    -- What was outstanding at the moment of the override, captured then rather
    -- than recomputed later: the items are usually completed afterwards, and a
    -- report that recomputed would show every override as having overridden
    -- nothing.
    missing_items   text[]      NOT NULL CHECK (cardinality(missing_items) > 0),
    reason          text        NOT NULL CHECK (length(reason) >= 10),
    overridden_by   text        NOT NULL,
    overridden_at   timestamptz NOT NULL
);

CREATE INDEX closure_override_report_idx
    ON encounter.closure_override (tenant_id, overridden_at DESC);

-- What closing an encounter produces (SRS-ENC-009).
--
-- Stored rather than rendered on demand. A summary rendered on demand shows
-- today's chart, so a patient handed a printout in March and a clinician
-- looking at the same "summary" in June see different documents with the same
-- name. The requirement is that a closed encounter's chronology cannot be
-- silently rewritten, and a stored artefact is what makes "silently"
-- impossible.
CREATE TABLE encounter.visit_summary (
    summary_id      uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    encounter_id    uuid        NOT NULL
                        REFERENCES encounter.encounter (encounter_id)
                        ON DELETE CASCADE,
    patient_id      uuid        NOT NULL,
    version         integer     NOT NULL CHECK (version > 0),
    supersedes_id   uuid        REFERENCES encounter.visit_summary (summary_id),
    -- An amendment with no reason is indistinguishable from a rewrite, and a
    -- rewrite is what the requirement forbids.
    amendment_reason text       NOT NULL DEFAULT '',
    encounter_class text        NOT NULL,
    started_at      timestamptz,
    ended_at        timestamptz,
    -- Flattened rather than joined: the summary must survive a later edit of
    -- its sources, which is the whole reason it is stored.
    diagnoses       jsonb       NOT NULL DEFAULT '[]'::jsonb,
    care_team       text[]      NOT NULL DEFAULT '{}',
    narrative       text        NOT NULL DEFAULT '',
    generated_by    text        NOT NULL,
    generated_at    timestamptz NOT NULL,

    CONSTRAINT an_amendment_states_its_reason CHECK (
        version = 1 OR amendment_reason <> ''
    ),
    CONSTRAINT only_an_amendment_supersedes CHECK (
        (version = 1) = (supersedes_id IS NULL)
    )
);

CREATE INDEX visit_summary_encounter_idx
    ON encounter.visit_summary (tenant_id, encounter_id, version DESC);

-- One current version per encounter: the document a patient was handed.
CREATE UNIQUE INDEX visit_summary_version_key
    ON encounter.visit_summary (tenant_id, encounter_id, version);
