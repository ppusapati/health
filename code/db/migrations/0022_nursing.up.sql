-- 0022 Nursing: assessments, flowsheets, fluid balance, risk scores, devices,
-- the medication administration record, tasks, handover, restraints,
-- transfusion, education, assignment and downtime (SRS-NUR).
--
-- Two rules shape this schema.
--
-- The first is about time. SRS-NUR-003 requires that a late entry is identified
-- as late and carries the actual observation time, so every bedside record here
-- has two timestamps that are never reconciled into one: when it was true of
-- the patient, and when it reached the record. A ward charts observations at
-- 06:00 and reaches a terminal at 08:40; a schema with one column says the
-- patient was stable two hours after they in fact were.
--
-- The second is about duplicate administration. SRS-NUR-018 requires that
-- recovery reconciliation cannot produce a duplicate administration record, and
-- the guard has to be at the table rather than in the application, because the
-- two transcriptions of one paper entry can be in flight at the same moment and
-- a check-then-insert would let both through. What identifies a dose is the
-- order and the scheduled time, which is what is written on the paper chart and
-- therefore what both transcribers read. See nursing_administration_dose_key.
--
-- Trace: SRS-NUR-001 (versioned admission assessment), SRS-NUR-002 (care plan
--   feeding the worklist), SRS-NUR-003 (flowsheet with late-entry marking),
--   SRS-NUR-004 (intake/output with amendment trail), SRS-NUR-005 (risk scores
--   with version and inputs), SRS-NUR-006 (devices and device-days),
--   SRS-NUR-007 (administration from verified orders), SRS-NUR-008 (positive
--   patient identification and override), SRS-NUR-009 (scheduled versus
--   actual), SRS-NUR-010 (handover with acknowledgement), SRS-NUR-011 (tasks
--   with escalation), SRS-NUR-012 (wound assessment with consented images),
--   SRS-NUR-013 (restraints with authorisation expiry), SRS-NUR-014
--   (transfusion monitoring), SRS-NUR-015 (education and discharge readiness),
--   SRS-NUR-016 (acuity inputs), SRS-NUR-017 (effective-dated assignment),
--   SRS-NUR-018 (downtime reconciliation).
-- Rollback: drops the whole schema. The medication administration record is
--   lost with it, and the MAR is the legal record of what was given to a
--   patient — there is no other source for it. Export every table before
--   dropping and treat a rollback here as a disaster-recovery event, not a
--   deployment step.
-- Reconciliation: none for the forward direction; the schema is new. The
--   previous version writes nothing here during the rollout window because it
--   does not know these tables exist.

CREATE SCHEMA IF NOT EXISTS nursing;

-- A versioned assessment structure (SRS-NUR-001).
--
-- Age- and service-specific, which is what min_age_years, max_age_years and
-- service_code are for: a paediatric assessment answered against an adult
-- template is a different set of questions under the same heading.
CREATE TABLE nursing.assessment_template (
    template_id     uuid        NOT NULL,
    tenant_id       uuid        NOT NULL,
    version         text        NOT NULL CHECK (version <> ''),
    name            text        NOT NULL CHECK (name <> ''),
    min_age_years   integer     NOT NULL DEFAULT 0,
    -- Zero means no upper bound.
    max_age_years   integer     NOT NULL DEFAULT 0,
    service_code    text        NOT NULL DEFAULT '',
    -- Sections as heading|required|prompts, one element per section. Stored
    -- rather than normalised: a template is read whole and never queried by
    -- section, and the assessments answered against it must see exactly the
    -- structure that was published.
    sections        jsonb       NOT NULL,
    retired         boolean     NOT NULL DEFAULT false,
    created_by      text        NOT NULL,
    created_at      timestamptz NOT NULL,

    PRIMARY KEY (template_id, version),
    CHECK (max_age_years = 0 OR max_age_years >= min_age_years),
    CHECK (jsonb_typeof(sections) = 'array' AND jsonb_array_length(sections) > 0)
);

CREATE INDEX assessment_template_tenant_idx
    ON nursing.assessment_template (tenant_id, retired, min_age_years);

-- One completed nursing assessment (SRS-NUR-001).
CREATE TABLE nursing.assessment (
    assessment_id    uuid        PRIMARY KEY,
    tenant_id        uuid        NOT NULL,
    patient_id       uuid        NOT NULL,
    encounter_id     uuid        NOT NULL,
    kind             text        NOT NULL CHECK (kind IN (
                         'admission', 'shift', 'focused', 'discharge')),
    -- The version is stored, not resolved at read time: a template edited
    -- afterwards would otherwise silently restate what was asked.
    template_id      uuid        NOT NULL,
    template_version text        NOT NULL CHECK (template_version <> ''),
    answers          jsonb       NOT NULL,
    -- Bedside time and record time. See the header.
    assessed_at      timestamptz NOT NULL,
    recorded_at      timestamptz NOT NULL,
    assessed_by      text        NOT NULL CHECK (assessed_by <> ''),
    version          bigint      NOT NULL DEFAULT 1,

    CHECK (assessed_at <= recorded_at)
);

CREATE INDEX assessment_patient_idx
    ON nursing.assessment (tenant_id, patient_id, assessed_at DESC);
CREATE INDEX assessment_encounter_idx
    ON nursing.assessment (tenant_id, encounter_id, kind);

-- A versioned scoring instrument (SRS-NUR-005).
CREATE TABLE nursing.risk_scale (
    scale_id        uuid        NOT NULL,
    tenant_id       uuid        NOT NULL,
    version         text        NOT NULL CHECK (version <> ''),
    name            text        NOT NULL CHECK (name <> ''),
    risk_domain     text        NOT NULL CHECK (risk_domain IN (
                        'falls', 'pressure_injury', 'pain', 'nutrition',
                        'deterioration')),
    inputs          jsonb       NOT NULL,
    bands           jsonb       NOT NULL,
    -- How long a score stays current. A Braden from four days ago is not an
    -- assessment of today's patient, so this is required and positive.
    reassess_after_seconds bigint NOT NULL CHECK (reassess_after_seconds > 0),
    retired         boolean     NOT NULL DEFAULT false,
    created_by      text        NOT NULL,
    created_at      timestamptz NOT NULL,

    PRIMARY KEY (scale_id, version),
    CHECK (jsonb_array_length(inputs) > 0),
    CHECK (jsonb_array_length(bands) > 0)
);

CREATE INDEX risk_scale_tenant_idx
    ON nursing.risk_scale (tenant_id, risk_domain, retired);

-- One scored assessment (SRS-NUR-005).
--
-- The inputs are stored alongside the total, which is the requirement's "score
-- version and inputs stored". A total on its own cannot be checked, cannot be
-- explained to the patient and cannot be recomputed when somebody asks whether
-- the scale was applied correctly.
CREATE TABLE nursing.risk_assessment (
    risk_id          uuid        PRIMARY KEY,
    tenant_id        uuid        NOT NULL,
    patient_id       uuid        NOT NULL,
    encounter_id     uuid        NOT NULL,
    scale_id         uuid        NOT NULL,
    scale_version    text        NOT NULL CHECK (scale_version <> ''),
    risk_domain      text        NOT NULL,
    inputs           jsonb       NOT NULL,
    total            integer     NOT NULL,
    band             text        NOT NULL CHECK (band <> ''),
    -- Captured at the time rather than recomputed: the bands can be retuned,
    -- and a retuned scale must not rewrite what the nurse was told.
    escalate         boolean     NOT NULL,
    assessed_at      timestamptz NOT NULL,
    recorded_at      timestamptz NOT NULL,
    assessed_by      text        NOT NULL CHECK (assessed_by <> ''),
    due_at           timestamptz NOT NULL,
    -- A recalculation under a new scale version never overwrites.
    superseded_by_id uuid        REFERENCES nursing.risk_assessment (risk_id)
                                 DEFERRABLE INITIALLY DEFERRED,
    version          bigint      NOT NULL DEFAULT 1,

    CHECK (assessed_at <= recorded_at),
    CHECK (due_at > assessed_at)
);

CREATE INDEX risk_assessment_patient_idx
    ON nursing.risk_assessment (tenant_id, patient_id, risk_domain,
        assessed_at DESC);

-- Live scores that are due for reassessment, which is what SRS-NUR-005's
-- "due reassessment appears as task" is read from.
CREATE INDEX risk_assessment_due_idx
    ON nursing.risk_assessment (tenant_id, due_at)
    WHERE superseded_by_id IS NULL;

-- One charted observation (SRS-NUR-003).
CREATE TABLE nursing.flowsheet_entry (
    entry_id         uuid        PRIMARY KEY,
    tenant_id        uuid        NOT NULL,
    patient_id       uuid        NOT NULL,
    encounter_id     uuid        NOT NULL,
    code_system      text        NOT NULL CHECK (code_system <> ''),
    code_version     text        NOT NULL DEFAULT '',
    code             text        NOT NULL CHECK (code <> ''),
    code_display     text        NOT NULL CHECK (code_display <> ''),
    value_number     double precision,
    value_unit       text        NOT NULL DEFAULT '',
    value_text       text        NOT NULL DEFAULT '',
    coded_system     text        NOT NULL DEFAULT '',
    coded_code       text        NOT NULL DEFAULT '',
    coded_display    text        NOT NULL DEFAULT '',
    -- When the observation was true of the patient, and when it reached the
    -- record. Both, always.
    observed_at      timestamptz NOT NULL,
    recorded_at      timestamptz NOT NULL,
    -- A monitor artefact and a nurse's count are both "a pulse of 140" and are
    -- not equally trustworthy.
    source           text        NOT NULL CHECK (source IN (
                         'manual', 'device', 'paper', 'patient')),
    device_id        text        NOT NULL DEFAULT '',
    recorded_by      text        NOT NULL CHECK (recorded_by <> ''),
    late_entry_reason text       NOT NULL DEFAULT '',
    superseded_by_id uuid        REFERENCES nursing.flowsheet_entry (entry_id)
                                 DEFERRABLE INITIALLY DEFERRED,
    version          bigint      NOT NULL DEFAULT 1,

    CHECK (observed_at <= recorded_at),
    -- A value attributed to "a monitor" with no monitor named cannot be checked
    -- against the monitor when somebody disputes it.
    CHECK (source <> 'device' OR device_id <> ''),
    -- A number with no unit is not a measurement.
    CHECK (value_number IS NULL OR value_unit <> ''),
    CHECK (value_number IS NOT NULL OR value_text <> '' OR coded_code <> '')
);

-- The chart is read by observation time, because sorting by typing order puts
-- a late 06:00 reading after the 08:00 one and draws a graph saying the patient
-- improved and then deteriorated.
CREATE INDEX flowsheet_entry_chart_idx
    ON nursing.flowsheet_entry (tenant_id, encounter_id, code, observed_at DESC)
    WHERE superseded_by_id IS NULL;

-- One recorded volume (SRS-NUR-004).
CREATE TABLE nursing.fluid_entry (
    fluid_id         uuid        PRIMARY KEY,
    tenant_id        uuid        NOT NULL,
    patient_id       uuid        NOT NULL,
    encounter_id     uuid        NOT NULL,
    direction        text        NOT NULL CHECK (direction IN ('intake', 'output')),
    category         text        NOT NULL CHECK (category <> ''),
    -- Always millilitres, converted on the way in. A running total summed
    -- across units is a number nobody can defend.
    volume_ml        double precision NOT NULL CHECK (volume_ml >= 0),
    observed_at      timestamptz NOT NULL,
    recorded_at      timestamptz NOT NULL,
    recorded_by      text        NOT NULL CHECK (recorded_by <> ''),
    -- SRS-NUR-004's amendment trail. A correction is a new row that supersedes
    -- this one; this one stays, because the shift total that was handed over
    -- was computed from it.
    superseded_by_id uuid        REFERENCES nursing.fluid_entry (fluid_id)
                                 DEFERRABLE INITIALLY DEFERRED,
    supersedes_id    uuid        REFERENCES nursing.fluid_entry (fluid_id)
                                 DEFERRABLE INITIALLY DEFERRED,
    amendment_reason text        NOT NULL DEFAULT '',
    voided_reason    text        NOT NULL DEFAULT '',
    version          bigint      NOT NULL DEFAULT 1,

    CHECK (observed_at <= recorded_at),
    -- A correction says why.
    CHECK (supersedes_id IS NULL OR amendment_reason <> '')
);

-- A correction replaces exactly one entry: two rows superseding the same entry
-- would make the balance depend on which one a query happened to find.
CREATE UNIQUE INDEX fluid_entry_one_correction
    ON nursing.fluid_entry (tenant_id, supersedes_id)
    WHERE supersedes_id IS NOT NULL;

-- The balance is bounded by observation time, so a 06:00 reading charted at
-- 08:40 falls in the night shift's balance where it belongs.
CREATE INDEX fluid_entry_balance_idx
    ON nursing.fluid_entry (tenant_id, encounter_id, observed_at)
    WHERE superseded_by_id IS NULL AND voided_reason = '';

-- One line, tube, drain or catheter (SRS-NUR-006).
CREATE TABLE nursing.device (
    device_id        uuid        PRIMARY KEY,
    tenant_id        uuid        NOT NULL,
    patient_id       uuid        NOT NULL,
    encounter_id     uuid        NOT NULL,
    kind             text        NOT NULL CHECK (kind IN (
                         'central_line', 'peripheral_line', 'urinary_catheter',
                         'drain', 'feeding_tube', 'endotracheal_tube',
                         'chest_tube')),
    site             text        NOT NULL CHECK (site <> ''),
    laterality       text        NOT NULL CHECK (laterality IN (
                         'left', 'right', 'bilateral', 'not_applicable')),
    size             text        NOT NULL DEFAULT '',
    lot              text        NOT NULL DEFAULT '',
    -- The canonical dates. Device-days are computed from these and nothing
    -- else: a denominator derived from how often somebody documented line care
    -- falls when the ward is busy, which makes the infection rate rise exactly
    -- when it should not.
    inserted_at      timestamptz NOT NULL,
    inserted_by      text        NOT NULL CHECK (inserted_by <> ''),
    removed_at       timestamptz,
    removed_by       text        NOT NULL DEFAULT '',
    -- Planned removal and removal for suspected infection are the same event to
    -- the chart and different events to surveillance.
    removal_reason   text        NOT NULL DEFAULT '',
    version          bigint      NOT NULL DEFAULT 1,

    CHECK (removed_at IS NULL OR removed_at >= inserted_at),
    CHECK (removed_at IS NULL OR (removed_by <> '' AND removal_reason <> ''))
);

CREATE INDEX device_patient_idx
    ON nursing.device (tenant_id, patient_id, inserted_at DESC);

-- Devices still in place, which is what a ward round and a handover read.
CREATE INDEX device_in_place_idx
    ON nursing.device (tenant_id, encounter_id, kind)
    WHERE removed_at IS NULL;

-- One episode of looking after a device. Never used as a proxy for the device
-- being in place.
CREATE TABLE nursing.device_care (
    care_id       uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    device_id     uuid        NOT NULL REFERENCES nursing.device (device_id),
    kind          text        NOT NULL CHECK (kind <> ''),
    finding       text        NOT NULL DEFAULT '',
    output_ml     double precision NOT NULL DEFAULT 0,
    performed_at  timestamptz NOT NULL,
    performed_by  text        NOT NULL CHECK (performed_by <> '')
);

CREATE INDEX device_care_device_idx
    ON nursing.device_care (tenant_id, device_id, performed_at DESC);

-- One dose's record (SRS-NUR-009).
CREATE TABLE nursing.administration (
    administration_id uuid       PRIMARY KEY,
    tenant_id         uuid       NOT NULL,
    patient_id        uuid       NOT NULL,
    encounter_id      uuid       NOT NULL,
    order_id          uuid       NOT NULL,
    medication_system text       NOT NULL CHECK (medication_system <> ''),
    medication_version text      NOT NULL DEFAULT '',
    medication_code   text       NOT NULL CHECK (medication_code <> ''),
    medication_display text      NOT NULL CHECK (medication_display <> ''),
    -- What the order asked for, kept separately from what happened. This is the
    -- whole of SRS-NUR-009's acceptance criterion: overwriting the scheduled
    -- values leaves "was it late" unanswerable.
    scheduled_dose    double precision NOT NULL DEFAULT 0,
    scheduled_unit    text       NOT NULL DEFAULT '',
    scheduled_at      timestamptz,
    given_dose        double precision NOT NULL DEFAULT 0,
    given_unit        text       NOT NULL DEFAULT '',
    given_at          timestamptz,
    route             text       NOT NULL DEFAULT '',
    site              text       NOT NULL DEFAULT '',
    outcome           text       NOT NULL CHECK (outcome IN (
                          'administered', 'not_administered', 'held',
                          'refused', 'delayed')),
    reason            text       NOT NULL DEFAULT '',
    -- SRS-NUR-008's barcode check, recorded whether or not it matched.
    scan_performed    boolean    NOT NULL DEFAULT false,
    scanned_patient   text       NOT NULL DEFAULT '',
    scanned_medication text      NOT NULL DEFAULT '',
    scanned_at        timestamptz,
    -- The override is stored, not only audited: the audit trail answers "who
    -- did this" and the stored record answers "how often, on which ward, for
    -- which drugs", which is the question that gets a broken scanner replaced.
    override_reason   text       NOT NULL DEFAULT '',
    override_by       text       NOT NULL DEFAULT '',
    override_at       timestamptz,
    override_patient_mismatch    boolean NOT NULL DEFAULT false,
    override_medication_mismatch boolean NOT NULL DEFAULT false,
    override_not_scanned         boolean NOT NULL DEFAULT false,
    -- SRS-NUR-018's weaker guard, for PRN doses that have no scheduled time.
    idempotency_key   text       NOT NULL DEFAULT '',
    -- A record reconstructed from a paper chart hours later is weaker evidence
    -- than one charted at the bedside, and a reviewer should be able to see
    -- which they are reading.
    recorded_offline  boolean    NOT NULL DEFAULT false,
    administered_by   text       NOT NULL CHECK (administered_by <> ''),
    witnessed_by      text       NOT NULL DEFAULT '',
    recorded_at       timestamptz NOT NULL,
    version           bigint     NOT NULL DEFAULT 1,

    -- Anything other than a plain administration says why.
    CHECK (outcome = 'administered' OR reason <> ''),
    -- A dose that was given carries what was given, when and by what route.
    CHECK (outcome NOT IN ('administered', 'delayed')
        OR (given_at IS NOT NULL AND given_dose > 0 AND given_unit <> ''
            AND route <> '')),
    CHECK (override_reason = '' OR (override_by <> '' AND override_at IS NOT NULL))
);

-- SRS-NUR-018. The duplicate-administration guard, and the reason it is here
-- rather than only in the application: two transcriptions of one paper entry
-- can be in flight at the same moment, and a check-then-insert would let both
-- through. What identifies the dose is the order and the scheduled time, which
-- is what is written on the paper chart and therefore what both transcribers
-- read.
--
-- Partial, because a PRN dose has no scheduled time — and a PRN dose genuinely
-- given twice is a clinical judgement that may be correct, so refusing it
-- outright would be wrong. There the guard is the idempotency key below and
-- the reconciliation report's suspected-duplicate list.
CREATE UNIQUE INDEX nursing_administration_dose_key
    ON nursing.administration (tenant_id, order_id, scheduled_at)
    WHERE scheduled_at IS NOT NULL;

CREATE UNIQUE INDEX nursing_administration_idempotency_key
    ON nursing.administration (tenant_id, idempotency_key)
    WHERE idempotency_key <> '';

CREATE INDEX administration_mar_idx
    ON nursing.administration (tenant_id, encounter_id, scheduled_at DESC NULLS LAST);
CREATE INDEX administration_order_idx
    ON nursing.administration (tenant_id, order_id);

-- Overrides, for the report that gets a broken scanner replaced.
CREATE INDEX administration_override_idx
    ON nursing.administration (tenant_id, override_at)
    WHERE override_reason <> '';

-- One piece of nursing work (SRS-NUR-011).
CREATE TABLE nursing.task (
    task_id          uuid        PRIMARY KEY,
    tenant_id        uuid        NOT NULL,
    patient_id       uuid        NOT NULL,
    encounter_id     uuid        NOT NULL,
    description      text        NOT NULL CHECK (description <> ''),
    priority         text        NOT NULL CHECK (priority IN (
                         'routine', 'urgent', 'critical')),
    -- A task with no due time never appears overdue, never escalates and never
    -- prompts anybody.
    due_at           timestamptz NOT NULL,
    source_kind      text        NOT NULL DEFAULT 'manual',
    source_id        text        NOT NULL DEFAULT '',
    recur_every_seconds bigint   NOT NULL DEFAULT 0 CHECK (recur_every_seconds >= 0),
    -- A recurrence with no end is a task that keeps appearing after the patient
    -- has gone home.
    recur_until      timestamptz,
    status           text        NOT NULL CHECK (status IN (
                         'pending', 'done', 'not_done', 'cancelled')),
    -- SRS-NUR-011's completion evidence. A tick with no evidence is
    -- indistinguishable from a tick to clear the list.
    evidence         text        NOT NULL DEFAULT '',
    completed_at     timestamptz,
    completed_by     text        NOT NULL DEFAULT '',
    not_done_reason  text        NOT NULL DEFAULT '',
    assigned_to      text        NOT NULL DEFAULT '',
    escalated_at     timestamptz,
    escalated_to     text        NOT NULL DEFAULT '',
    created_at       timestamptz NOT NULL,
    created_by       text        NOT NULL CHECK (created_by <> ''),
    version          bigint      NOT NULL DEFAULT 1,

    CHECK (status <> 'done' OR (evidence <> '' AND completed_by <> '')),
    CHECK (status <> 'not_done' OR not_done_reason <> ''),
    CHECK (recur_every_seconds = 0 OR recur_until IS NULL OR recur_until > due_at)
);

-- The worklist: pending work for a patient, most urgent first.
CREATE INDEX task_worklist_idx
    ON nursing.task (tenant_id, encounter_id, priority, due_at)
    WHERE status = 'pending';

-- Overdue critical work that has not yet been escalated (SRS-NUR-011).
CREATE INDEX task_escalation_idx
    ON nursing.task (tenant_id, due_at)
    WHERE status = 'pending' AND priority = 'critical' AND escalated_at IS NULL;

CREATE INDEX task_assignment_idx
    ON nursing.task (tenant_id, assigned_to, due_at)
    WHERE status = 'pending';

-- A nursing care plan (SRS-NUR-002).
CREATE TABLE nursing.care_plan (
    plan_id      uuid        PRIMARY KEY,
    tenant_id    uuid        NOT NULL,
    patient_id   uuid        NOT NULL,
    encounter_id uuid        NOT NULL,
    title        text        NOT NULL CHECK (title <> ''),
    -- Problems, their goals and their interventions. Read whole and never
    -- queried by part, and the interventions carry the frequency that turns the
    -- plan into work.
    problems     jsonb       NOT NULL,
    status       text        NOT NULL CHECK (status IN (
                     'active', 'completed', 'cancelled')),
    created_at   timestamptz NOT NULL,
    created_by   text        NOT NULL CHECK (created_by <> ''),
    -- SRS-NUR-002's evaluation. A plan with no evaluation is a plan nobody has
    -- checked against the patient.
    reviewed_at  timestamptz,
    reviewed_by  text        NOT NULL DEFAULT '',
    evaluation   text        NOT NULL DEFAULT '',
    version      bigint      NOT NULL DEFAULT 1,

    CHECK (jsonb_typeof(problems) = 'array' AND jsonb_array_length(problems) > 0),
    CHECK (reviewed_at IS NULL OR (reviewed_by <> '' AND evaluation <> ''))
);

CREATE INDEX care_plan_encounter_idx
    ON nursing.care_plan (tenant_id, encounter_id, status);

-- One shift's handover for one patient (SRS-NUR-010).
--
-- A stored snapshot rather than a screen that renders current state. Rendered
-- live, the handover acknowledged at 20:00 shows something different at 23:00
-- and nobody can say afterwards what they were told.
CREATE TABLE nursing.handover (
    handover_id      uuid        PRIMARY KEY,
    tenant_id        uuid        NOT NULL,
    patient_id       uuid        NOT NULL,
    encounter_id     uuid        NOT NULL,
    unit_id          text        NOT NULL DEFAULT '',
    -- The shift is recorded, because a handover that does not say which shift
    -- handed to which cannot establish who held the patient at any given hour.
    from_shift_code  text        NOT NULL CHECK (from_shift_code <> ''),
    from_shift_start timestamptz,
    from_shift_end   timestamptz,
    to_shift_code    text        NOT NULL CHECK (to_shift_code <> ''),
    to_shift_start   timestamptz,
    to_shift_end     timestamptz,
    situation        text        NOT NULL CHECK (situation <> ''),
    background       text        NOT NULL DEFAULT '',
    assessment       text        NOT NULL DEFAULT '',
    -- The part the incoming nurse acts on.
    recommendation   text        NOT NULL CHECK (recommendation <> ''),
    critical_risks   text[]      NOT NULL DEFAULT '{}',
    outstanding      text[]      NOT NULL DEFAULT '{}',
    devices          jsonb       NOT NULL DEFAULT '[]'::jsonb,
    pending_tasks    jsonb       NOT NULL DEFAULT '[]'::jsonb,
    composed_at      timestamptz NOT NULL,
    composed_by      text        NOT NULL CHECK (composed_by <> ''),
    -- SRS-NUR-010's acceptance criterion, and the reason the handover is a
    -- record rather than a report.
    acknowledged_at  timestamptz,
    acknowledged_by  text        NOT NULL DEFAULT '',
    questions        text        NOT NULL DEFAULT '',
    version          bigint      NOT NULL DEFAULT 1,

    CHECK (acknowledged_at IS NULL OR acknowledged_by <> ''),
    -- One person marking their own work received is not a handover.
    CHECK (acknowledged_by = '' OR lower(acknowledged_by) <> lower(composed_by))
);

-- Handovers nobody has accepted: a patient whose care nobody has taken
-- responsibility for.
CREATE INDEX handover_unacknowledged_idx
    ON nursing.handover (tenant_id, unit_id, composed_at)
    WHERE acknowledged_at IS NULL;

CREATE INDEX handover_encounter_idx
    ON nursing.handover (tenant_id, encounter_id, composed_at DESC);

-- One episode of restraint (SRS-NUR-013).
CREATE TABLE nursing.restraint (
    restraint_id     uuid        PRIMARY KEY,
    tenant_id        uuid        NOT NULL,
    patient_id       uuid        NOT NULL,
    encounter_id     uuid        NOT NULL,
    kind             text        NOT NULL CHECK (kind IN (
                         'physical', 'chemical', 'seclusion')),
    description      text        NOT NULL CHECK (description <> ''),
    authorized_by    text        NOT NULL CHECK (authorized_by <> ''),
    authorized_at    timestamptz NOT NULL,
    -- Not nullable. An authorization with no expiry is the failure the
    -- requirement exists to prevent.
    expires_at       timestamptz NOT NULL,
    -- "Agitated" is not an indication, and a blank field is how a restraint
    -- becomes routine.
    indication       text        NOT NULL CHECK (indication <> ''),
    -- Renewals are appended, because how many times a restraint has been
    -- renewed is the number a review board asks for.
    renewals         jsonb       NOT NULL DEFAULT '[]'::jsonb,
    started_at       timestamptz NOT NULL,
    started_by       text        NOT NULL CHECK (started_by <> ''),
    monitor_every_seconds bigint NOT NULL CHECK (monitor_every_seconds > 0),
    discontinued_at  timestamptz,
    discontinued_by  text        NOT NULL DEFAULT '',
    discontinued_reason text     NOT NULL DEFAULT '',
    version          bigint      NOT NULL DEFAULT 1,

    CHECK (expires_at > authorized_at),
    CHECK (discontinued_at IS NULL OR discontinued_at >= started_at),
    CHECK (discontinued_at IS NULL
        OR (discontinued_by <> '' AND discontinued_reason <> ''))
);

-- Live restraints, which is what the expiry alert and the monitoring check are
-- read from. An expired authorization does not end the restraint: the patient
-- is still restrained, and what has lapsed is the permission.
CREATE INDEX restraint_active_idx
    ON nursing.restraint (tenant_id, expires_at)
    WHERE discontinued_at IS NULL;

-- One observation of a restrained patient.
CREATE TABLE nursing.restraint_check (
    check_id      uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    restraint_id  uuid        NOT NULL REFERENCES nursing.restraint (restraint_id),
    observed_at   timestamptz NOT NULL,
    observed_by   text        NOT NULL CHECK (observed_by <> ''),
    findings      text        NOT NULL CHECK (findings <> ''),
    -- A check that records observations but never asks whether the restraint is
    -- still needed is a check that keeps patients restrained.
    continued_reason text     NOT NULL CHECK (continued_reason <> '')
);

CREATE INDEX restraint_check_idx
    ON nursing.restraint_check (tenant_id, restraint_id, observed_at DESC);

-- One blood-product episode (SRS-NUR-014).
CREATE TABLE nursing.transfusion (
    transfusion_id   uuid        PRIMARY KEY,
    tenant_id        uuid        NOT NULL,
    patient_id       uuid        NOT NULL,
    encounter_id     uuid        NOT NULL,
    -- The pack's own identifier, which links this record back to the blood bank
    -- and forward to a look-back investigation.
    unit_number      text        NOT NULL CHECK (unit_number <> ''),
    product_system   text        NOT NULL CHECK (product_system <> ''),
    product_version  text        NOT NULL DEFAULT '',
    product_code     text        NOT NULL CHECK (product_code <> ''),
    product_display  text        NOT NULL CHECK (product_display <> ''),
    -- As issued, not as the patient's record says: what matters in a reaction
    -- investigation is what was hung.
    abo_group        text        NOT NULL DEFAULT '',
    rhd              text        NOT NULL DEFAULT '',
    volume_ml        double precision NOT NULL DEFAULT 0,
    started_at       timestamptz NOT NULL,
    started_by       text        NOT NULL CHECK (started_by <> ''),
    -- The second person at the bedside check.
    checked_by       text        NOT NULL CHECK (checked_by <> ''),
    status           text        NOT NULL CHECK (status IN (
                         'in_progress', 'completed', 'stopped')),
    ended_at         timestamptz,
    reaction_reported_at timestamptz,
    reaction_reported_by text    NOT NULL DEFAULT '',
    reaction_features    text    NOT NULL DEFAULT '',
    -- The first action — stop, keep the line open — is the one that matters,
    -- and a reaction report without it is a report of an unhandled reaction.
    reaction_action      text    NOT NULL DEFAULT '',
    reaction_unit_returned boolean NOT NULL DEFAULT false,
    version          bigint      NOT NULL DEFAULT 1,

    -- One person checking their own work is not a two-person check.
    CHECK (lower(checked_by) <> lower(started_by)),
    CHECK (ended_at IS NULL OR ended_at >= started_at),
    CHECK (status <> 'stopped'
        OR (reaction_reported_by <> '' AND reaction_features <> ''
            AND reaction_action <> ''))
);

CREATE UNIQUE INDEX transfusion_unit_idx
    ON nursing.transfusion (tenant_id, unit_number, patient_id);

CREATE INDEX transfusion_running_idx
    ON nursing.transfusion (tenant_id, encounter_id)
    WHERE status = 'in_progress';

-- One set of monitoring observations (SRS-NUR-014).
CREATE TABLE nursing.transfusion_observation (
    observation_id   uuid        PRIMARY KEY,
    tenant_id        uuid        NOT NULL,
    transfusion_id   uuid        NOT NULL
                                 REFERENCES nursing.transfusion (transfusion_id),
    observed_at      timestamptz NOT NULL,
    observed_by      text        NOT NULL CHECK (observed_by <> ''),
    temperature_c    double precision NOT NULL DEFAULT 0,
    pulse            integer     NOT NULL DEFAULT 0,
    systolic_bp      integer     NOT NULL DEFAULT 0,
    respiratory_rate integer     NOT NULL DEFAULT 0,
    -- Without a baseline, a temperature of 38.1 twenty minutes in cannot be
    -- read as a rise or as where the patient already was.
    baseline         boolean     NOT NULL DEFAULT false,
    notes            text        NOT NULL DEFAULT ''
);

CREATE UNIQUE INDEX transfusion_one_baseline
    ON nursing.transfusion_observation (tenant_id, transfusion_id)
    WHERE baseline;

CREATE INDEX transfusion_observation_idx
    ON nursing.transfusion_observation (tenant_id, transfusion_id, observed_at);

-- One assessment of a wound or pressure area (SRS-NUR-012).
CREATE TABLE nursing.wound_assessment (
    wound_assessment_id uuid     PRIMARY KEY,
    tenant_id        uuid        NOT NULL,
    patient_id       uuid        NOT NULL,
    encounter_id     uuid        NOT NULL,
    -- Groups the assessments of one wound over time, which is what makes a
    -- healing trajectory readable.
    wound_id         text        NOT NULL CHECK (wound_id <> ''),
    location         text        NOT NULL CHECK (location <> ''),
    body_map_system  text        NOT NULL DEFAULT '',
    body_map_code    text        NOT NULL DEFAULT '',
    body_map_display text        NOT NULL DEFAULT '',
    laterality       text        NOT NULL CHECK (laterality IN (
                         'left', 'right', 'bilateral', 'not_applicable')),
    kind             text        NOT NULL CHECK (kind IN (
                         'pressure_injury', 'surgical', 'trauma', 'burn',
                         'ulcer', 'other')),
    stage            text        NOT NULL DEFAULT '',
    length_mm        double precision NOT NULL DEFAULT 0,
    width_mm         double precision NOT NULL DEFAULT 0,
    depth_mm         double precision NOT NULL DEFAULT 0,
    appearance       text        NOT NULL CHECK (appearance <> ''),
    exudate          text        NOT NULL DEFAULT '',
    surrounding_skin text        NOT NULL DEFAULT '',
    pain_score       integer     CHECK (pain_score IS NULL
                                    OR (pain_score >= 0 AND pain_score <= 10)),
    assessed_at      timestamptz NOT NULL,
    recorded_at      timestamptz NOT NULL,
    assessed_by      text        NOT NULL CHECK (assessed_by <> ''),
    version          bigint      NOT NULL DEFAULT 1,

    -- A pressure injury charted without a stage is one nobody reports.
    CHECK (kind <> 'pressure_injury' OR stage <> ''),
    CHECK (assessed_at <= recorded_at)
);

CREATE INDEX wound_assessment_trajectory_idx
    ON nursing.wound_assessment (tenant_id, patient_id, wound_id,
        assessed_at DESC);

-- A photograph of a wound is a photograph of a patient (SRS-NUR-012).
CREATE TABLE nursing.wound_image (
    image_id      uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    wound_assessment_id uuid  NOT NULL
                              REFERENCES nursing.wound_assessment (wound_assessment_id),
    -- Not a boolean: a boolean cannot be checked against a consent that was
    -- later withdrawn.
    consent_id    uuid        NOT NULL,
    storage_key   text        NOT NULL CHECK (storage_key <> ''),
    content_type  text        NOT NULL DEFAULT '',
    captured_at   timestamptz NOT NULL,
    captured_by   text        NOT NULL CHECK (captured_by <> ''),
    -- A series of images is the evidence of healing, so an image is added and
    -- never replaced.
    sequence      integer     NOT NULL CHECK (sequence > 0)
);

CREATE UNIQUE INDEX wound_image_sequence_idx
    ON nursing.wound_image (tenant_id, wound_assessment_id, sequence);

-- One episode of patient or family teaching (SRS-NUR-015).
CREATE TABLE nursing.education (
    education_id  uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    patient_id    uuid        NOT NULL,
    encounter_id  uuid        NOT NULL,
    topic_system  text        NOT NULL CHECK (topic_system <> ''),
    topic_version text        NOT NULL DEFAULT '',
    topic_code    text        NOT NULL CHECK (topic_code <> ''),
    topic_display text        NOT NULL CHECK (topic_display <> ''),
    -- Not always the patient: teaching a carer to manage a stoma determines
    -- whether the patient copes at home, and recording it against the patient
    -- loses who actually knows how.
    learner       text        NOT NULL CHECK (learner IN (
                      'patient', 'family', 'carer')),
    learner_name  text        NOT NULL DEFAULT '',
    method        text        NOT NULL CHECK (method <> ''),
    -- The outcome, and the reason the record exists. Teaching delivered is not
    -- teaching received.
    understanding text        NOT NULL CHECK (understanding IN (
                      'demonstrated', 'verbalised', 'needs_reinforcement',
                      'unable_to_assess')),
    barriers      text        NOT NULL DEFAULT '',
    taught_at     timestamptz NOT NULL,
    taught_by     text        NOT NULL CHECK (taught_by <> ''),
    version       bigint      NOT NULL DEFAULT 1,

    CHECK (learner = 'patient' OR learner_name <> '')
);

CREATE INDEX education_patient_idx
    ON nursing.education (tenant_id, patient_id, taught_at DESC);

-- One nurse's responsibility for one patient (SRS-NUR-017).
--
-- Effective-dated, because the question an incident review asks is "who was
-- looking after this patient at 03:40", and a list with no dates answers
-- today's question and silently gives the wrong answer to every question about
-- the past.
CREATE TABLE nursing.assignment (
    assignment_id  uuid        PRIMARY KEY,
    tenant_id      uuid        NOT NULL,
    unit_id        text        NOT NULL CHECK (unit_id <> ''),
    bed_id         text        NOT NULL DEFAULT '',
    patient_id     uuid,
    nurse_id       text        NOT NULL CHECK (nurse_id <> ''),
    relationship   text        NOT NULL CHECK (relationship IN (
                       'primary', 'associate', 'covering', 'in_charge')),
    effective_from timestamptz NOT NULL,
    effective_to   timestamptz,
    assigned_by    text        NOT NULL CHECK (assigned_by <> ''),
    -- A shift ending and a reassignment mid-shift are routine and an event
    -- worth looking at, respectively.
    ended_reason   text        NOT NULL DEFAULT '',
    version        bigint      NOT NULL DEFAULT 1,

    CHECK (effective_to IS NULL OR effective_to > effective_from),
    -- An assignment to neither a patient nor a bed says the nurse is on the
    -- ward, which is not an assignment.
    CHECK (patient_id IS NOT NULL OR bed_id <> '')
);

-- One live primary nurse per patient: two answers to "who is responsible" is
-- no answer.
CREATE UNIQUE INDEX assignment_one_live_primary
    ON nursing.assignment (tenant_id, patient_id)
    WHERE relationship = 'primary' AND effective_to IS NULL
        AND patient_id IS NOT NULL;

CREATE INDEX assignment_unit_idx
    ON nursing.assignment (tenant_id, unit_id, effective_from DESC);
CREATE INDEX assignment_nurse_idx
    ON nursing.assignment (tenant_id, nurse_id, effective_from DESC);

-- One period during which a unit worked on paper (SRS-NUR-018).
CREATE TABLE nursing.downtime_episode (
    episode_id     uuid        PRIMARY KEY,
    tenant_id      uuid        NOT NULL,
    unit_id        text        NOT NULL CHECK (unit_id <> ''),
    -- Planned maintenance and an outage change what a reviewer expects to find.
    reason         text        NOT NULL CHECK (reason <> ''),
    started_at     timestamptz NOT NULL,
    started_by     text        NOT NULL CHECK (started_by <> ''),
    ended_at       timestamptz,
    ended_by       text        NOT NULL DEFAULT '',
    -- Separate from ended_at, because the system coming back and the paper
    -- being typed in are hours apart and the gap is where the record is
    -- incomplete.
    reconciled_at  timestamptz,
    reconciled_by  text        NOT NULL DEFAULT '',
    version        bigint      NOT NULL DEFAULT 1,

    CHECK (ended_at IS NULL OR ended_at > started_at),
    CHECK (ended_at IS NOT NULL OR reconciled_at IS NULL),
    CHECK (reconciled_at IS NULL OR reconciled_by <> '')
);

-- One open downtime episode per unit: two would make "are we on paper" depend
-- on which row a query found.
CREATE UNIQUE INDEX downtime_one_open_per_unit
    ON nursing.downtime_episode (tenant_id, unit_id)
    WHERE ended_at IS NULL;

CREATE INDEX downtime_unreconciled_idx
    ON nursing.downtime_episode (tenant_id, ended_at)
    WHERE ended_at IS NOT NULL AND reconciled_at IS NULL;

-- The tenant's administration policy (SRS-NUR-008).
--
-- Per facility, because scanner coverage is a property of the ward rather than
-- of the hospital. A row's absence means the default, which requires the scan:
-- a safety control that has to be switched on is a control that is off in the
-- wards that most need it.
CREATE TABLE nursing.administration_policy (
    tenant_id        uuid        NOT NULL,
    facility_id      uuid        NOT NULL,
    barcode_required boolean     NOT NULL DEFAULT true,
    override_allowed boolean     NOT NULL DEFAULT true,
    late_after_seconds bigint    NOT NULL DEFAULT 3600
                                 CHECK (late_after_seconds >= 0),
    updated_by       text        NOT NULL,
    updated_at       timestamptz NOT NULL,

    PRIMARY KEY (tenant_id, facility_id)
);

-- The tenant's acuity weights (SRS-NUR-016).
--
-- Stored rather than compiled in, because every hospital that has tried to
-- compute nursing workload has ended up with different weights — the work
-- depends on the ward's layout, its skill mix and its case mix.
CREATE TABLE nursing.acuity_weights (
    tenant_id      uuid        NOT NULL,
    unit_id        text        NOT NULL DEFAULT '',
    dependency     integer     NOT NULL DEFAULT 3,
    open_task      integer     NOT NULL DEFAULT 1,
    overdue_task   integer     NOT NULL DEFAULT 2,
    device         integer     NOT NULL DEFAULT 2,
    high_risk      integer     NOT NULL DEFAULT 4,
    isolation      integer     NOT NULL DEFAULT 5,
    updated_by     text        NOT NULL,
    updated_at     timestamptz NOT NULL,

    PRIMARY KEY (tenant_id, unit_id)
);
