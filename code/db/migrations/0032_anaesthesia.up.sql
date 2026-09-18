-- 0032 Anaesthesia and recovery (SRS-ANE-001 … 011).
--
-- The anaesthetic record hangs off the theatre case rather than replacing it:
-- the patient, the procedure and the operative note belong to the case, and
-- what is here is the anaesthetist's record of what they did.
--
-- Four shapes here are unusual and deliberate.
--
-- A pre-anaesthesia assessment is versioned rather than updated. A patient
-- assessed in clinic and reassessed on the morning of surgery has two records,
-- and the difference between them is frequently the point — a chest infection
-- that appeared in the fortnight between.
--
-- A drug entry carries the dose, the unit and the concentration, with a CHECK
-- that an infusion has both halves of the concentration. SRS-ANE-004's unit
-- validation is worthless if a row can hold a rate that cannot be turned into
-- a dose.
--
-- Every intraoperative entry carries its source and, for a device, its
-- connection state. SRS-ANE-005 asks for integrated data to be marked by
-- device and connection status, and a value recorded while the monitor was
-- disconnected is one nobody should trend.
--
-- A record marked imported carries who transcribed it and when. A
-- reconstructed record that did not say so would read as a contemporaneous
-- one, which is what SRS-ANE-011's "clearly marked and audit-linked" prevents.
--
-- Trace: SRS-ANE-001 … SRS-ANE-011.
--
-- Rollback: drops the schema. Every pre-assessment, intraoperative chart,
-- airway record, fluid balance, recovery score and pain plan goes with it. An
-- anaesthetic record is read in a complaint and a claim, and a difficult-airway
-- record is what keeps the next anaesthetist safe. Treat as a
-- disaster-recovery action, never a deployment step.
--
-- Reconciliation: the tables are new, so the previous version writes nothing
-- here and sees nothing missing. The direction to watch is the theatre case: a
-- record created by the new version points at a case the old version serves
-- happily and shows no anaesthetic detail for. A display gap during the
-- rollout window, closing when every replica is new.

CREATE SCHEMA IF NOT EXISTS anaesthesia;

CREATE TABLE anaesthesia.assessment (
    assessment_id uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    -- An assessment floating free of an operation is an opinion about a
    -- patient rather than about a procedure.
    case_id      uuid NOT NULL,
    encounter_id uuid,
    patient_id   uuid NOT NULL,

    version    integer NOT NULL CHECK (version >= 1),
    supersedes uuid    REFERENCES anaesthesia.assessment (assessment_id),

    history text NOT NULL DEFAULT '',
    -- The airway prediction, kept as its parts rather than a score: units
    -- differ on which scale they record, and the anaesthetist's judgement is
    -- not the sum of the measurements.
    airway_mallampati   text    NOT NULL DEFAULT '',
    airway_mouth_mm     integer NOT NULL DEFAULT 0,
    airway_thyromental_mm integer NOT NULL DEFAULT 0,
    airway_neck         text    NOT NULL DEFAULT '',
    airway_dentition    text    NOT NULL DEFAULT '',
    airway_notes        text    NOT NULL DEFAULT '',
    -- The one prediction the theatre most needs in advance, because the
    -- equipment for it lives somewhere else.
    airway_predicted_difficult boolean NOT NULL DEFAULT false,

    -- The emergency modifier is part of the grade: "3" and "3E" are different
    -- patients, and a system storing an integer and a boolean would report
    -- them as the same.
    asa_grade text NOT NULL CHECK (asa_grade IN (
                  '1', '2', '3', '4', '5', '6',
                  '1E', '2E', '3E', '4E', '5E')),

    investigations text[] NOT NULL DEFAULT '{}',
    risks          text[] NOT NULL DEFAULT '{}',
    plan           text   NOT NULL DEFAULT '',

    consent text NOT NULL CHECK (consent IN (
                'obtained', 'pending', 'refused', 'not_required')),
    consent_note text NOT NULL DEFAULT '',

    -- Separate from the ASA grade: an ASA 4 patient can be fit for the
    -- operation they need and an ASA 2 patient can be unfit today.
    fit_to_proceed boolean NOT NULL,
    conditions     text[]  NOT NULL DEFAULT '{}',

    assessed_by   text        NOT NULL CHECK (assessed_by <> ''),
    assessed_at   timestamptz NOT NULL,
    -- The forward reference is deferrable because the one-current index forces
    -- supersede-then-insert: the old row has to point at the new one before the
    -- new one exists.
    superseded_by uuid        REFERENCES anaesthesia.assessment (assessment_id)
                      DEFERRABLE INITIALLY DEFERRED,
    superseded_at timestamptz,

    -- Refused and not-required consent are both states a review asks about,
    -- and neither explains itself.
    CONSTRAINT unusual_consent_is_explained CHECK (
        consent IN ('obtained', 'pending') OR consent_note <> ''
    ),
    -- "Not fit" with nothing to do about it is a conclusion the theatre
    -- cannot act on.
    -- COALESCE because array_length of an empty array is NULL, and a CHECK
    -- that evaluates to NULL passes. Without it the constraint would refuse a
    -- list of one and wave through a list of none, which is the case it exists
    -- for.
    CONSTRAINT an_unfit_patient_has_conditions CHECK (
        fit_to_proceed OR COALESCE(array_length(conditions, 1), 0) >= 1
    )
);

CREATE INDEX assessment_case_idx ON anaesthesia.assessment (tenant_id, case_id, version);
CREATE INDEX assessment_patient_idx ON anaesthesia.assessment (tenant_id, patient_id);
-- The assessment in force, which is what the theatre checklist reads. One per
-- case, enforced: two current assessments is two opinions about whether a
-- patient is fit.
CREATE UNIQUE INDEX assessment_current_idx
    ON anaesthesia.assessment (tenant_id, case_id)
    WHERE superseded_by IS NULL;

CREATE TABLE anaesthesia.plan (
    plan_id   uuid        PRIMARY KEY,
    tenant_id uuid        NOT NULL,
    case_id   uuid        NOT NULL,

    technique text NOT NULL CHECK (technique IN (
                  'general', 'regional', 'spinal', 'epidural', 'sedation',
                  'local', 'combined')),
    agents            text[] NOT NULL DEFAULT '{}',
    airway            text   NOT NULL DEFAULT '',
    monitoring        text[] NOT NULL DEFAULT '{}',
    -- What has to be fetched. The list a theatre reads to know whether it
    -- needs a videolaryngoscope.
    special_equipment text[] NOT NULL DEFAULT '{}',
    -- Where the patient is planned to go. Recorded at planning because a
    -- critical-care bed is booked before the operation, not after it.
    post_operative text NOT NULL DEFAULT '',
    notes          text NOT NULL DEFAULT '',

    planned_by text        NOT NULL CHECK (planned_by <> ''),
    planned_at timestamptz NOT NULL,

    UNIQUE (tenant_id, case_id)
);

CREATE TABLE anaesthesia.record (
    record_id    uuid        PRIMARY KEY,
    tenant_id    uuid        NOT NULL,
    case_id      uuid        NOT NULL,
    encounter_id uuid,
    patient_id   uuid        NOT NULL,

    technique text NOT NULL CHECK (technique IN (
                  'general', 'regional', 'spinal', 'epidural', 'sedation',
                  'local', 'combined')),
    status text NOT NULL CHECK (status IN ('open', 'in_recovery', 'closed')),

    started_at timestamptz NOT NULL,
    started_by text        NOT NULL CHECK (started_by <> ''),
    -- When the anaesthetic ended, which is not when the operation ended:
    -- emergence takes time and it is the anaesthetist's.
    ended_at timestamptz,

    -- A record made here, or transcribed from paper after a downtime.
    origin text NOT NULL CHECK (origin IN ('manual', 'imported')),
    import_note text        NOT NULL DEFAULT '',
    imported_at timestamptz,
    imported_by text        NOT NULL DEFAULT '',

    CONSTRAINT an_import_says_where_it_came_from CHECK (
        origin <> 'imported'
        OR (import_note <> '' AND imported_at IS NOT NULL AND imported_by <> '')
    ),
    CONSTRAINT anaesthesia_ends_after_it_starts CHECK (
        ended_at IS NULL OR ended_at >= started_at
    ),
    UNIQUE (tenant_id, case_id)
);

CREATE INDEX record_patient_idx ON anaesthesia.record (tenant_id, patient_id);

CREATE TABLE anaesthesia.vital (
    vital_id  uuid        PRIMARY KEY,
    tenant_id uuid        NOT NULL,
    record_id uuid        NOT NULL
        REFERENCES anaesthesia.record (record_id) ON DELETE CASCADE,

    code    text NOT NULL CHECK (code <> ''),
    display text NOT NULL DEFAULT '',
    value   double precision NOT NULL,
    unit    text NOT NULL DEFAULT '',

    source text NOT NULL CHECK (source IN ('manual', 'device', 'imported')),
    device_id    text NOT NULL DEFAULT '',
    device_model text NOT NULL DEFAULT '',
    -- The connection state at the moment of the reading. A value recorded
    -- while the monitor was disconnected is one nobody should trend.
    device_connected   boolean     NOT NULL DEFAULT false,
    device_measured_at timestamptz,

    observed_at timestamptz NOT NULL,
    recorded_at timestamptz NOT NULL,
    recorded_by text        NOT NULL DEFAULT '',

    CONSTRAINT a_device_value_names_its_device CHECK (
        source <> 'device' OR device_id <> ''
    ),
    CONSTRAINT a_human_entry_names_who_made_it CHECK (
        source = 'device' OR recorded_by <> ''
    )
);

CREATE INDEX vital_record_idx ON anaesthesia.vital (tenant_id, record_id, observed_at);
CREATE INDEX vital_code_idx ON anaesthesia.vital (tenant_id, record_id, code, observed_at);

CREATE TABLE anaesthesia.drug (
    drug_id   uuid        PRIMARY KEY,
    tenant_id uuid        NOT NULL,
    record_id uuid        NOT NULL
        REFERENCES anaesthesia.record (record_id) ON DELETE CASCADE,

    drug_code    text NOT NULL CHECK (drug_code <> ''),
    drug_display text NOT NULL DEFAULT '',
    route        text NOT NULL DEFAULT '',

    -- A system that stored "5" without knowing whether it was millilitres or
    -- milligrams has recorded nothing.
    dose      double precision NOT NULL CHECK (dose >= 0),
    dose_unit text             NOT NULL CHECK (dose_unit <> ''),

    concentration_amount double precision NOT NULL DEFAULT 0,
    concentration_unit   text             NOT NULL DEFAULT '',
    concentration_volume double precision NOT NULL DEFAULT 0,
    rate_ml_per_hour     double precision NOT NULL DEFAULT 0,
    infusion             boolean          NOT NULL DEFAULT false,
    stopped_at           timestamptz,

    source text NOT NULL CHECK (source IN ('manual', 'device', 'imported')),
    device_id          text        NOT NULL DEFAULT '',
    device_connected   boolean     NOT NULL DEFAULT false,
    device_measured_at timestamptz,

    given_at    timestamptz NOT NULL,
    recorded_at timestamptz NOT NULL,
    recorded_by text        NOT NULL DEFAULT '',
    note        text        NOT NULL DEFAULT '',

    -- Without both halves the rate cannot be turned into a dose, and the chart
    -- shows a number with no clinical meaning.
    CONSTRAINT an_infusion_records_its_concentration CHECK (
        NOT infusion
        OR (concentration_amount > 0 AND concentration_volume > 0)
    ),
    CONSTRAINT a_device_drug_entry_names_its_device CHECK (
        source <> 'device' OR device_id <> ''
    )
);

CREATE INDEX drug_record_idx ON anaesthesia.drug (tenant_id, record_id, given_at);
CREATE INDEX drug_running_idx
    ON anaesthesia.drug (tenant_id, record_id)
    WHERE infusion AND stopped_at IS NULL;

CREATE TABLE anaesthesia.airway_event (
    airway_id uuid        PRIMARY KEY,
    tenant_id uuid        NOT NULL,
    record_id uuid        NOT NULL
        REFERENCES anaesthesia.record (record_id) ON DELETE CASCADE,

    device text NOT NULL CHECK (device <> ''),
    -- Attempts count from one. A zeroth attempt would make the count of
    -- attempts, which is what the next anaesthetist reads, wrong.
    attempt integer NOT NULL CHECK (attempt >= 1),
    grade   text    NOT NULL DEFAULT '',
    successful boolean NOT NULL DEFAULT false,
    difficulty text   NOT NULL DEFAULT '',
    complications text[] NOT NULL DEFAULT '{}',
    adjuncts      text[] NOT NULL DEFAULT '{}',

    occurred_at timestamptz NOT NULL,
    recorded_by text        NOT NULL CHECK (recorded_by <> ''),

    UNIQUE (record_id, attempt)
);

CREATE INDEX airway_record_idx ON anaesthesia.airway_event (tenant_id, record_id, attempt);

CREATE TABLE anaesthesia.fluid (
    fluid_id  uuid        PRIMARY KEY,
    tenant_id uuid        NOT NULL,
    record_id uuid        NOT NULL
        REFERENCES anaesthesia.record (record_id) ON DELETE CASCADE,

    direction text NOT NULL CHECK (direction IN ('in', 'out')),
    -- A litre in and a litre of blood out are different clinical pictures, and
    -- the kind is what tells them apart.
    kind      text NOT NULL CHECK (kind <> ''),
    label     text NOT NULL DEFAULT '',
    volume_ml double precision NOT NULL CHECK (volume_ml >= 0),
    -- The blood bank's unit identifier, for a transfusion. A transfusion with
    -- none cannot be reconciled against the issue record, which is half of
    -- every transfusion audit.
    product_id text NOT NULL DEFAULT '',

    occurred_at timestamptz NOT NULL,
    recorded_at timestamptz NOT NULL,
    recorded_by text        NOT NULL CHECK (recorded_by <> ''),

    CONSTRAINT a_transfusion_names_its_unit CHECK (
        kind <> 'transfusion' OR product_id <> ''
    )
);

CREATE INDEX fluid_record_idx ON anaesthesia.fluid (tenant_id, record_id, occurred_at);

CREATE TABLE anaesthesia.handover (
    handover_id uuid        PRIMARY KEY,
    tenant_id   uuid        NOT NULL,
    record_id   uuid        NOT NULL
        REFERENCES anaesthesia.record (record_id) ON DELETE CASCADE,

    -- Both people. A handover naming only the giver is a note left on a
    -- trolley.
    from_clinician text NOT NULL CHECK (from_clinician <> ''),
    to_clinician   text NOT NULL CHECK (to_clinician <> ''),

    summary      text   NOT NULL CHECK (summary <> ''),
    concerns     text[] NOT NULL DEFAULT '{}',
    instructions text[] NOT NULL DEFAULT '{}',
    -- What was given in theatre, so recovery knows what is already on board
    -- before giving more.
    analgesia_given  text[] NOT NULL DEFAULT '{}',
    antiemetic_given text[] NOT NULL DEFAULT '{}',

    handed_over_at timestamptz NOT NULL
);

CREATE INDEX handover_record_idx ON anaesthesia.handover (tenant_id, record_id);

CREATE TABLE anaesthesia.recovery_assessment (
    assessment_id uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    record_id     uuid        NOT NULL
        REFERENCES anaesthesia.record (record_id) ON DELETE CASCADE,

    scale_name    text NOT NULL CHECK (scale_name <> ''),
    scale_version text NOT NULL CHECK (scale_version <> ''),
    -- The component scores as recorded, so the total can be read back rather
    -- than taken on trust.
    scores jsonb   NOT NULL DEFAULT '{}'::jsonb,
    total  integer NOT NULL,
    -- The threshold travels with the assessment, so a score recorded under one
    -- scale is never read against another's bar.
    discharge_threshold integer NOT NULL CHECK (discharge_threshold > 0),
    -- Components with no score. A partial assessment is not a low one.
    missing text[] NOT NULL DEFAULT '{}',

    assessed_at timestamptz NOT NULL,
    assessed_by text        NOT NULL CHECK (assessed_by <> '')
);

CREATE INDEX recovery_record_idx
    ON anaesthesia.recovery_assessment (tenant_id, record_id, assessed_at);

CREATE TABLE anaesthesia.discharge (
    discharge_id uuid        PRIMARY KEY,
    tenant_id    uuid        NOT NULL,
    record_id    uuid        NOT NULL
        REFERENCES anaesthesia.record (record_id) ON DELETE CASCADE,

    destination text NOT NULL CHECK (destination <> ''),
    -- A discharge below the threshold, with the reason. The override is the
    -- whole of what a review reads.
    overridden      boolean NOT NULL DEFAULT false,
    override_reason text    NOT NULL DEFAULT '',
    -- The assessment the decision was made on, so the record can be read back.
    score_id uuid REFERENCES anaesthesia.recovery_assessment (assessment_id),

    discharged_at timestamptz NOT NULL,
    discharged_by text        NOT NULL CHECK (discharged_by <> ''),

    CONSTRAINT an_override_says_why CHECK (
        NOT overridden OR override_reason <> ''
    ),
    UNIQUE (tenant_id, record_id)
);

CREATE TABLE anaesthesia.pain_order (
    order_id  uuid        PRIMARY KEY,
    tenant_id uuid        NOT NULL,
    record_id uuid        NOT NULL
        REFERENCES anaesthesia.record (record_id) ON DELETE CASCADE,

    patient_id   uuid NOT NULL,
    encounter_id uuid,

    modality text NOT NULL CHECK (modality <> ''),
    -- The drug chart is SRS-MED's. A second place to prescribe from is how a
    -- patient gets two doses, so this names the prescriptions rather than
    -- being one.
    prescription_ids text[] NOT NULL DEFAULT '{}',

    target_score text   NOT NULL DEFAULT '',
    -- A plan with nothing to observe is one nursing cannot follow, and one
    -- with no escalation is one a ward nurse cannot act on at 3am.
    -- COALESCE because array_length of an empty array is NULL, and a CHECK
    -- that evaluates to NULL passes.
    monitoring   text[] NOT NULL
                     CHECK (COALESCE(array_length(monitoring, 1), 0) >= 1),
    escalation   text   NOT NULL CHECK (escalation <> ''),
    review_by    timestamptz,

    ordered_by text        NOT NULL CHECK (ordered_by <> ''),
    ordered_at timestamptz NOT NULL,
    stopped_at timestamptz,
    stopped_by text        NOT NULL DEFAULT ''
);

CREATE INDEX pain_order_record_idx ON anaesthesia.pain_order (tenant_id, record_id);
CREATE INDEX pain_order_patient_idx ON anaesthesia.pain_order (tenant_id, patient_id);
-- The acute pain team's worklist: plans still running, soonest review first.
CREATE INDEX pain_order_running_idx
    ON anaesthesia.pain_order (tenant_id, review_by)
    WHERE stopped_at IS NULL;
