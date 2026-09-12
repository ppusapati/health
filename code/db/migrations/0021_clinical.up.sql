-- 0021 The clinical record: notes, problems, allergies, observations,
-- procedures, plans, consents, decision support and consults (SRS-CLN).
--
-- The rule that shapes this whole schema is SRS-CLN-008's: signed content
-- cannot be edited in place. A clinical record is read by people making
-- decisions and by people investigating decisions, and both need to see what
-- was believed at the time rather than what somebody later wished had been
-- written. So a signed document is immutable at the table, and every later
-- thought is a new row that points back.
--
-- The second rule is SRS-CLN-011's, and it is unusually blunt: criticality is
-- supplied by the authoritative diagnostic service and never inferred here. A
-- chart that decided for itself whether a potassium of 6.1 is critical would
-- disagree with the laboratory that measured it, and the disagreement would be
-- invisible. So interpretation and its source are columns, and nothing computes
-- them.
--
-- Trace: SRS-CLN-002 (versioned templates), SRS-CLN-003 (problem list),
--   SRS-CLN-004 (allergies), SRS-CLN-005 (observations), SRS-CLN-006
--   (procedures), SRS-CLN-007 (care plans), SRS-CLN-008 (document lifecycle),
--   SRS-CLN-009 (signature with content hash), SRS-CLN-010 (provenance),
--   SRS-CLN-011 (authoritative flags), SRS-CLN-012 (critical acknowledgement),
--   SRS-CLN-013 (clinical consent), SRS-CLN-014 (attachments), SRS-CLN-015
--   (expanded smart phrases), SRS-CLN-019 (restricted notes), SRS-CLN-020
--   (versioned calculators), SRS-CLN-021 (CDS alerts and overrides),
--   SRS-CLN-022 (consults), SRS-CLN-023 (registry references).
-- Rollback: drops the whole schema. Every clinical note, result, problem and
--   allergy is lost — this is the patient record itself, and nothing else in
--   the system can reconstruct it. Export every table before dropping, and
--   treat a rollback here as a disaster-recovery event rather than a
--   deployment step.
-- Reconciliation: none for the forward direction; the schema is new. The
--   previous version writes nothing here during the rollout window because it
--   does not know these tables exist.

CREATE SCHEMA IF NOT EXISTS clinical;

-- A versioned note structure (SRS-CLN-002).
--
-- Never mutated in place: editing a published template would silently rewrite
-- what every historical note claims to have answered. A change is a new row
-- with a new version.
CREATE TABLE clinical.template (
    template_id     uuid        NOT NULL,
    tenant_id       uuid        NOT NULL,
    version         text        NOT NULL CHECK (version <> ''),
    name            text        NOT NULL CHECK (name <> ''),
    kind            text        NOT NULL CHECK (kind IN (
                        'progress_note', 'consultation_note', 'discharge_summary',
                        'operation_note', 'nursing_note', 'referral_letter',
                        'procedure_report')),
    specialty       text        NOT NULL DEFAULT '',
    sections        text[]      NOT NULL CHECK (cardinality(sections) > 0),
    -- A retired template can still be read on old notes but cannot be chosen
    -- for a new one.
    retired         boolean     NOT NULL DEFAULT false,
    created_by      text        NOT NULL,
    created_at      timestamptz NOT NULL,

    PRIMARY KEY (template_id, version)
);

CREATE INDEX template_choosable_idx
    ON clinical.template (tenant_id, kind, specialty)
    WHERE retired = false;

-- One clinical note (SRS-CLN-002, SRS-CLN-008).
CREATE TABLE clinical.document (
    document_id     uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    patient_id      uuid        NOT NULL,
    -- A note with no encounter cannot be placed in time or context, and the
    -- chart it belongs to cannot show it in order.
    encounter_id    uuid        NOT NULL,
    kind            text        NOT NULL CHECK (kind IN (
                        'progress_note', 'consultation_note', 'discharge_summary',
                        'operation_note', 'nursing_note', 'referral_letter',
                        'procedure_report')),
    template_id     uuid,
    -- The exact revision the note was composed against. Without it a chart
    -- review that assumed today's template would report omissions that were
    -- never asked for.
    template_version text       NOT NULL DEFAULT '',
    title           text        NOT NULL DEFAULT '',
    -- Sections as ordered JSON rather than a child table: a note is read and
    -- written whole, never by section, and the order is part of what was
    -- signed.
    sections        jsonb       NOT NULL DEFAULT '[]'::jsonb,

    status          text        NOT NULL CHECK (status IN (
                        'draft', 'signed', 'amended', 'addendum',
                        'entered_in_error')),
    confidentiality text        NOT NULL CHECK (confidentiality IN (
                        'normal', 'restricted', 'very_restricted')),

    -- Exactly one of these, and only on an amendment or an addendum.
    amends_id       uuid        REFERENCES clinical.document (document_id),
    adds_to_id      uuid        REFERENCES clinical.document (document_id),
    -- An amendment with no reason is indistinguishable from a rewrite.
    change_reason   text        NOT NULL DEFAULT '',
    retraction_reason text      NOT NULL DEFAULT '',

    -- Content that arrived from speech recognition (SRS-CLN-016). A clinician
    -- reviewing their own dictation needs to know they are reviewing a
    -- machine's transcript.
    dictated        boolean     NOT NULL DEFAULT false,

    authored_by     text        NOT NULL,
    created_at      timestamptz NOT NULL,
    updated_at      timestamptz NOT NULL,
    version         bigint      NOT NULL DEFAULT 1,

    CONSTRAINT a_document_amends_or_extends_not_both CHECK (
        amends_id IS NULL OR adds_to_id IS NULL
    ),
    CONSTRAINT only_an_amendment_or_addendum_points_back CHECK (
        (status IN ('amended', 'addendum'))
        OR (amends_id IS NULL AND adds_to_id IS NULL)
    ),
    CONSTRAINT an_amendment_states_its_reason CHECK (
        status <> 'amended' OR change_reason <> ''
    ),
    CONSTRAINT a_retraction_states_its_reason CHECK (
        status <> 'entered_in_error' OR retraction_reason <> ''
    )
);

CREATE INDEX document_patient_idx
    ON clinical.document (tenant_id, patient_id, created_at DESC);

CREATE INDEX document_encounter_idx
    ON clinical.document (tenant_id, encounter_id, created_at);

-- The closure gate asks whether an encounter has a signed note (SRS-ENC-008).
CREATE INDEX document_signed_idx
    ON clinical.document (tenant_id, encounter_id)
    WHERE status IN ('signed', 'amended', 'addendum');

-- A clinician's own unfinished work, which is the first thing they open.
CREATE INDEX document_draft_idx
    ON clinical.document (tenant_id, authored_by, updated_at DESC)
    WHERE status = 'draft';

-- One person's assertion about one version of a document (SRS-CLN-009).
CREATE TABLE clinical.signature (
    signature_id    uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    document_id     uuid        NOT NULL
                        REFERENCES clinical.document (document_id)
                        ON DELETE CASCADE,
    -- The authenticated identity. Never a typed name: a signature a clerk can
    -- attribute to anybody is not a signature.
    subject_id      text        NOT NULL CHECK (subject_id <> ''),
    -- "I wrote this" and "I supervised whoever wrote this" are different
    -- claims with different consequences.
    meaning         text        NOT NULL CHECK (meaning IN (
                        'author', 'verifier', 'cosigner', 'witness',
                        'transcriber')),
    signed_at       timestamptz NOT NULL,
    -- Pins what was signed. Without it a signature says "this person signed
    -- something called note 47", and the content of note 47 is exactly what a
    -- dispute is about.
    content_hash    text        NOT NULL CHECK (content_hash <> ''),
    template_version text       NOT NULL DEFAULT ''
);

CREATE INDEX signature_document_idx
    ON clinical.signature (tenant_id, document_id, signed_at);

-- One entry on the patient's problem list (SRS-CLN-003).
CREATE TABLE clinical.problem (
    problem_id      uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    patient_id      uuid        NOT NULL,
    -- Where it was first recorded. A problem outlives the encounter that found
    -- it — that is what makes it a problem list rather than a diagnosis list —
    -- so this is provenance, not ownership.
    encounter_id    uuid,
    code_system     text        NOT NULL CHECK (code_system <> ''),
    code_version    text        NOT NULL DEFAULT '',
    code            text        NOT NULL CHECK (code <> ''),
    code_display    text        NOT NULL CHECK (code_display <> ''),
    note            text        NOT NULL DEFAULT '',
    status          text        NOT NULL CHECK (status IN (
                        'active', 'remission', 'resolved', 'inactive',
                        'entered_in_error')),
    onset_at        timestamptz,
    resolved_at     timestamptz,
    -- A diagnosis of HIV on an unrestricted problem list is visible on every
    -- screen in the hospital.
    confidentiality text        NOT NULL CHECK (confidentiality IN (
                        'normal', 'restricted', 'very_restricted')),
    recorded_by     text        NOT NULL,
    recorded_at     timestamptz NOT NULL,
    updated_by      text        NOT NULL,
    updated_at      timestamptz NOT NULL,
    version         bigint      NOT NULL DEFAULT 1,

    CONSTRAINT a_problem_resolves_after_it_begins CHECK (
        resolved_at IS NULL OR onset_at IS NULL OR resolved_at >= onset_at
    ),
    -- A resolved problem has a date, or a report of "resolved this year"
    -- silently omits it.
    CONSTRAINT a_resolved_problem_says_when CHECK (
        status <> 'resolved' OR resolved_at IS NOT NULL
    )
);

CREATE INDEX problem_patient_idx
    ON clinical.problem (tenant_id, patient_id, recorded_at DESC);

CREATE INDEX problem_active_idx
    ON clinical.problem (tenant_id, patient_id)
    WHERE status IN ('active', 'remission');

-- A recorded allergy or intolerance (SRS-CLN-004).
CREATE TABLE clinical.allergy (
    allergy_id      uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    patient_id      uuid        NOT NULL,
    encounter_id    uuid,
    -- Coded, because the acceptance criterion is that the allergy reaches
    -- medication decision support, and free text cannot be checked against a
    -- prescription.
    substance_system text       NOT NULL CHECK (substance_system <> ''),
    substance_version text      NOT NULL DEFAULT '',
    substance_code  text        NOT NULL CHECK (substance_code <> ''),
    substance_display text      NOT NULL CHECK (substance_display <> ''),
    -- Clinically different, and confusing them is how a patient with mild
    -- nausea on codeine ends up unable to receive any opiate.
    kind            text        NOT NULL CHECK (kind IN ('allergy', 'intolerance')),
    -- "Nobody has assessed this" is not the same as "this is mild".
    criticality     text        NOT NULL CHECK (criticality IN (
                        'low', 'high', 'unable_to_assess')),
    verification    text        NOT NULL CHECK (verification IN (
                        'unconfirmed', 'confirmed', 'refuted', 'entered_in_error')),
    reactions       jsonb       NOT NULL DEFAULT '[]'::jsonb,
    onset_at        timestamptz,
    note            text        NOT NULL DEFAULT '',
    recorded_by     text        NOT NULL,
    recorded_at     timestamptz NOT NULL,
    updated_by      text        NOT NULL,
    updated_at      timestamptz NOT NULL,
    version         bigint      NOT NULL DEFAULT 1
);

-- What a prescriber must be warned about, which is read on every prescription.
CREATE INDEX allergy_active_idx
    ON clinical.allergy (tenant_id, patient_id)
    WHERE verification IN ('unconfirmed', 'confirmed');

-- One measurement or finding (SRS-CLN-005, SRS-CLN-011).
CREATE TABLE clinical.observation (
    observation_id  uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    patient_id      uuid        NOT NULL,
    encounter_id    uuid,
    code_system     text        NOT NULL CHECK (code_system <> ''),
    code_version    text        NOT NULL DEFAULT '',
    code            text        NOT NULL CHECK (code <> ''),
    code_display    text        NOT NULL CHECK (code_display <> ''),

    -- Exactly one of these carries the result: a blood pressure is a quantity,
    -- a blood group is a code, and a microbiology comment is text.
    value_quantity  double precision,
    -- Unit and value are inseparable. A potassium of 6.1 is a crisis in mmol/L
    -- and meaningless without it.
    value_unit      text        NOT NULL DEFAULT '',
    value_text      text        NOT NULL DEFAULT '',
    value_code_system text      NOT NULL DEFAULT '',
    value_code      text        NOT NULL DEFAULT '',
    value_code_display text     NOT NULL DEFAULT '',

    -- The range the source used, stored rather than looked up: it depends on
    -- the analyser, the method and the patient's age and sex, and applying
    -- today's range to a five-year-old result would reinterpret history.
    reference_low   double precision,
    reference_high  double precision,
    reference_text  text        NOT NULL DEFAULT '',

    -- Supplied by the authoritative service, never derived here (SRS-CLN-011).
    interpretation  text        NOT NULL CHECK (interpretation IN (
                        'normal', 'high', 'low', 'critical_high', 'critical_low',
                        'abnormal', 'unknown')),
    -- Flag provenance. A chart showing "critical" with no source cannot answer
    -- "who decided this".
    interpretation_source text  NOT NULL DEFAULT '',

    status          text        NOT NULL CHECK (status IN (
                        'registered', 'preliminary', 'final', 'amended',
                        'cancelled', 'entered_in_error')),
    -- When the observation was true of the patient — when blood was drawn, not
    -- when the analyser finished. A trend built on the second is a trend of
    -- laboratory throughput.
    effective_at    timestamptz NOT NULL,
    issued_at       timestamptz,
    performer_id    text        NOT NULL DEFAULT '',
    -- A run of implausible values usually means one device, and without this
    -- nobody can see that.
    device_id       text        NOT NULL DEFAULT '',
    -- Empty for something recorded here; set for anything imported
    -- (SRS-CLN-010).
    source_system   text        NOT NULL DEFAULT '',
    note            text        NOT NULL DEFAULT '',
    amends_id       uuid        REFERENCES clinical.observation (observation_id),
    recorded_by     text        NOT NULL,
    recorded_at     timestamptz NOT NULL,
    version         bigint      NOT NULL DEFAULT 1,

    CONSTRAINT a_measured_value_has_its_unit CHECK (
        value_quantity IS NULL OR value_unit <> ''
    ),
    -- An interpretation with no source cannot answer "who decided this".
    CONSTRAINT an_interpretation_names_its_source CHECK (
        interpretation = 'unknown' OR interpretation_source <> ''
    )
);

-- The trend query: one code's results for one patient, in time order.
CREATE INDEX observation_trend_idx
    ON clinical.observation (tenant_id, patient_id, code_system, code, effective_at);

CREATE INDEX observation_encounter_idx
    ON clinical.observation (tenant_id, encounter_id, effective_at DESC);

-- The worklist of results that must reach a clinician now (SRS-CLN-012).
CREATE INDEX observation_critical_idx
    ON clinical.observation (tenant_id, issued_at)
    WHERE interpretation IN ('critical_high', 'critical_low')
      AND status NOT IN ('cancelled', 'entered_in_error');

-- A clinician acting on a critical result (SRS-CLN-012).
CREATE TABLE clinical.critical_acknowledgement (
    acknowledgement_id uuid     PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    observation_id  uuid        NOT NULL
                        REFERENCES clinical.observation (observation_id)
                        ON DELETE CASCADE,
    patient_id      uuid        NOT NULL,
    acknowledged_by text        NOT NULL,
    acknowledged_at timestamptz NOT NULL,
    -- The action is mandatory, not just the acknowledgement. "Seen" is not a
    -- clinical response to a potassium of 6.9, and a system that accepted a
    -- bare click would produce a complete acknowledgement log alongside a dead
    -- patient.
    action          text        NOT NULL CHECK (length(action) >= 10),
    -- What an escalation clock runs from. The gap between this and the
    -- acknowledgement is the number a safety review wants.
    notified_at     timestamptz
);

-- One acknowledgement per result: a second click would rewrite the first
-- clinician's stated action.
CREATE UNIQUE INDEX critical_acknowledgement_key
    ON clinical.critical_acknowledgement (tenant_id, observation_id);

-- One thing done to a patient (SRS-CLN-006).
CREATE TABLE clinical.procedure (
    procedure_id    uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    patient_id      uuid        NOT NULL,
    encounter_id    uuid        NOT NULL,
    code_system     text        NOT NULL CHECK (code_system <> ''),
    code_version    text        NOT NULL DEFAULT '',
    code            text        NOT NULL CHECK (code <> ''),
    code_display    text        NOT NULL CHECK (code_display <> ''),
    status          text        NOT NULL CHECK (status IN (
                        'planned', 'in_progress', 'completed', 'stopped',
                        'not_done', 'entered_in_error')),
    indication      jsonb       NOT NULL DEFAULT '{}'::jsonb,
    -- "The operation happened" with nobody attached is a record that cannot
    -- answer the first question anybody asks about it.
    performers      jsonb       NOT NULL DEFAULT '[]'::jsonb,
    body_site       jsonb       NOT NULL DEFAULT '{}'::jsonb,
    -- Its own column rather than free text: wrong-side surgery is a
    -- never-event, and the only defence a record offers is that the side was
    -- stated somewhere a checklist can read.
    laterality      text        NOT NULL CHECK (laterality IN (
                        'not_applicable', 'left', 'right', 'bilateral',
                        'unspecified')),
    outcome         text        NOT NULL DEFAULT '',
    -- Coded so they can be counted. A complication in free text is a
    -- complication that never reaches a quality report.
    complications   jsonb       NOT NULL DEFAULT '[]'::jsonb,
    -- References rather than copies: a copied implant record is the one that
    -- stays wrong after a recall.
    order_ids       text[]      NOT NULL DEFAULT '{}',
    device_ids      text[]      NOT NULL DEFAULT '{}',
    specimen_ids    text[]      NOT NULL DEFAULT '{}',
    performed_start timestamptz,
    performed_end   timestamptz,
    note            text        NOT NULL DEFAULT '',
    recorded_by     text        NOT NULL,
    recorded_at     timestamptz NOT NULL,
    updated_at      timestamptz NOT NULL,
    version         bigint      NOT NULL DEFAULT 1,

    CONSTRAINT a_procedure_ends_after_it_starts CHECK (
        performed_end IS NULL OR performed_start IS NULL
        OR performed_end >= performed_start
    ),
    CONSTRAINT a_completed_procedure_names_its_performer CHECK (
        status <> 'completed' OR jsonb_array_length(performers) > 0
    )
);

CREATE INDEX procedure_patient_idx
    ON clinical.procedure (tenant_id, patient_id, performed_start DESC NULLS LAST);

CREATE INDEX procedure_encounter_idx
    ON clinical.procedure (tenant_id, encounter_id);

-- The quality report: procedures that did not go to plan.
CREATE INDEX procedure_complicated_idx
    ON clinical.procedure (tenant_id, performed_start DESC)
    WHERE status = 'stopped' OR jsonb_array_length(complications) > 0;

-- A plan of care (SRS-CLN-007).
CREATE TABLE clinical.care_plan (
    care_plan_id    uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    patient_id      uuid        NOT NULL,
    encounter_id    uuid,
    title           text        NOT NULL CHECK (title <> ''),
    status          text        NOT NULL CHECK (status IN (
                        'draft', 'active', 'on_hold', 'completed', 'revoked')),
    -- References rather than copies: a plan holding its own copy of a
    -- diagnosis is the copy that stays wrong after the diagnosis changes.
    problem_ids     text[]      NOT NULL DEFAULT '{}',
    goals           jsonb       NOT NULL DEFAULT '[]'::jsonb,
    -- Activities carry the task id that executes them, so the worklist and the
    -- plan do not drift.
    activities      jsonb       NOT NULL DEFAULT '[]'::jsonb,
    -- A plan nobody owns is a list of things everybody assumes somebody else
    -- is doing.
    owner_id        text        NOT NULL CHECK (owner_id <> ''),
    starts_at       timestamptz,
    ends_at         timestamptz,
    created_by      text        NOT NULL,
    created_at      timestamptz NOT NULL,
    updated_at      timestamptz NOT NULL,
    version         bigint      NOT NULL DEFAULT 1,

    CONSTRAINT a_care_plan_ends_after_it_starts CHECK (
        ends_at IS NULL OR starts_at IS NULL OR ends_at >= starts_at
    )
);

CREATE INDEX care_plan_patient_idx
    ON clinical.care_plan (tenant_id, patient_id, created_at DESC);

CREATE INDEX care_plan_active_idx
    ON clinical.care_plan (tenant_id, patient_id)
    WHERE status IN ('draft', 'active', 'on_hold');

-- Where an imported record came from (SRS-CLN-010).
CREATE TABLE clinical.provenance (
    provenance_id   uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    record_type     text        NOT NULL CHECK (record_type <> ''),
    record_id       uuid        NOT NULL,
    -- Without the organisation this says "it came from outside", which tells a
    -- clinician nothing they can weigh.
    source_organization text    NOT NULL CHECK (source_organization <> ''),
    source_system   text        NOT NULL DEFAULT '',
    -- So a duplicate arriving twice can be recognised.
    source_record_id text       NOT NULL DEFAULT '',
    -- When it arrived here, distinct from when it was true of the patient: a
    -- result from March that arrived in September was not available to the
    -- clinician who saw the patient in June.
    ingested_at     timestamptz NOT NULL,
    authored_at     timestamptz,
    -- A string rather than a subject id: they are not a user of this system,
    -- and pretending otherwise would make an external author indistinguishable
    -- from a local one in every query that joins on identity.
    authored_by     text        NOT NULL DEFAULT '',
    assertion       text        NOT NULL DEFAULT ''
);

CREATE INDEX provenance_record_idx
    ON clinical.provenance (tenant_id, record_type, record_id);

-- A duplicate arriving twice from the same source is the same record.
CREATE UNIQUE INDEX provenance_source_key
    ON clinical.provenance (tenant_id, source_organization, source_system, source_record_id)
    WHERE source_record_id <> '';

-- A file held against a clinical record (SRS-CLN-014).
CREATE TABLE clinical.attachment (
    attachment_id   uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    parent_type     text        NOT NULL CHECK (parent_type <> ''),
    parent_id       uuid        NOT NULL,
    patient_id      uuid        NOT NULL,
    kind            text        NOT NULL CHECK (kind IN (
                        'image', 'document', 'audio', 'video', 'waveform')),
    content_type    text        NOT NULL CHECK (content_type <> ''),
    -- Opaque: a key that encoded the patient would leak in every log line that
    -- carried it.
    storage_key     text        NOT NULL CHECK (storage_key <> ''),
    size_bytes      bigint      NOT NULL CHECK (size_bytes > 0),
    digest          text        NOT NULL DEFAULT '',
    description     text        NOT NULL DEFAULT '',
    -- The attachment's own class, which may be tighter than its parent's: a
    -- photograph of an injury attached to an ordinary note can be more
    -- sensitive than the note.
    confidentiality text        NOT NULL CHECK (confidentiality IN (
                        'normal', 'restricted', 'very_restricted')),
    -- When the image or recording was made, which is not when it was uploaded.
    captured_at     timestamptz NOT NULL,
    source_system   text        NOT NULL DEFAULT '',
    uploaded_by     text        NOT NULL,
    uploaded_at     timestamptz NOT NULL
);

CREATE INDEX attachment_parent_idx
    ON clinical.attachment (tenant_id, parent_type, parent_id);

CREATE INDEX attachment_patient_idx
    ON clinical.attachment (tenant_id, patient_id, captured_at DESC);

-- A recorded consent for a clinical act (SRS-CLN-013).
--
-- Deliberately not the privacy consent of SRS-EMPI-013. The two answer
-- different questions, and conflating them produces a system where withdrawing
-- a marketing preference cancels an operation.
CREATE TABLE clinical.clinical_consent (
    consent_id      uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    patient_id      uuid        NOT NULL,
    encounter_id    uuid,
    kind            text        NOT NULL CHECK (kind IN (
                        'procedure', 'anaesthesia', 'transfusion', 'photography',
                        'research', 'treatment')),
    -- A consent for "a procedure" is not a consent for any procedure.
    procedure_system text       NOT NULL DEFAULT '',
    procedure_code  text        NOT NULL DEFAULT '',
    procedure_display text      NOT NULL DEFAULT '',
    status          text        NOT NULL CHECK (status IN (
                        'given', 'refused', 'withdrawn', 'expired')),
    -- A consent given by a parent for a child is a different fact from one the
    -- patient gave, and the difference is what a court asks about.
    given_by        text        NOT NULL CHECK (given_by IN (
                        'patient', 'parent', 'legal_guardian', 'representative')),
    given_by_name   text        NOT NULL DEFAULT '',
    document_id     uuid        REFERENCES clinical.document (document_id),
    witness_id      text        NOT NULL DEFAULT '',
    valid_from      timestamptz NOT NULL,
    -- A consent with no expiry for an operation that happens two years later
    -- is a consent to something the patient no longer remembers agreeing to.
    valid_until     timestamptz,
    note            text        NOT NULL DEFAULT '',
    recorded_by     text        NOT NULL,
    recorded_at     timestamptz NOT NULL,
    updated_at      timestamptz NOT NULL,

    CONSTRAINT a_consent_expires_after_it_begins CHECK (
        valid_until IS NULL OR valid_until > valid_from
    ),
    CONSTRAINT a_procedure_consent_names_the_procedure CHECK (
        kind <> 'procedure' OR procedure_code <> ''
    ),
    CONSTRAINT a_proxy_consent_names_the_giver CHECK (
        given_by = 'patient' OR given_by_name <> ''
    )
);

CREATE INDEX clinical_consent_patient_idx
    ON clinical.clinical_consent (tenant_id, patient_id, kind, valid_from DESC);

-- One run of a clinical calculator (SRS-CLN-020).
--
-- Stored, never recomputed on read. A score rendered on demand changes meaning
-- the day the formula is corrected, so a note saying "CHA2DS2-VASc 3" would
-- silently become 4 and nobody would know which number the anticoagulation
-- decision was made from.
CREATE TABLE clinical.calculator_result (
    result_id       uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    patient_id      uuid        NOT NULL,
    encounter_id    uuid,
    calculator_id   text        NOT NULL CHECK (calculator_id <> ''),
    -- An unversioned calculator makes every stored score ambiguous the first
    -- time somebody corrects a coefficient.
    formula_version text        NOT NULL CHECK (formula_version <> ''),
    name            text        NOT NULL DEFAULT '',
    -- A score whose inputs were not kept cannot be checked, and the one time
    -- anybody checks is when it looks wrong.
    inputs          jsonb       NOT NULL CHECK (jsonb_array_length(inputs) > 0),
    value           double precision NOT NULL,
    unit            text        NOT NULL DEFAULT '',
    interpretation  text        NOT NULL DEFAULT '',
    -- A rerun with a newer formula chains forward; the original stays.
    superseded_by_id uuid       REFERENCES clinical.calculator_result (result_id)
                        DEFERRABLE INITIALLY DEFERRED,
    calculated_by   text        NOT NULL,
    calculated_at   timestamptz NOT NULL
);

CREATE INDEX calculator_result_patient_idx
    ON clinical.calculator_result (tenant_id, patient_id, calculator_id, calculated_at DESC);

-- One firing of a decision-support rule (SRS-CLN-021).
CREATE TABLE clinical.cds_alert (
    alert_id        uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    patient_id      uuid        NOT NULL,
    encounter_id    uuid,
    rule_id         text        NOT NULL CHECK (rule_id <> ''),
    -- An override report that could not say which version fired cannot tell a
    -- tuning change from a behaviour change.
    rule_version    text        NOT NULL CHECK (rule_version <> ''),
    level           text        NOT NULL CHECK (level IN ('hard', 'soft', 'info')),
    -- The wording is tuned too, and an override against a message nobody can
    -- reproduce is an override nobody can interpret.
    message         text        NOT NULL CHECK (message <> ''),
    context_type    text        NOT NULL DEFAULT '',
    context_id      text        NOT NULL DEFAULT '',
    outcome         text        NOT NULL CHECK (outcome IN (
                        'pending', 'accepted', 'overridden', 'not_applicable')),
    -- A chosen code is what makes overrides reportable rather than a pile of
    -- free text.
    override_code   text        NOT NULL DEFAULT '',
    override_reason text        NOT NULL DEFAULT '',
    fired_at        timestamptz NOT NULL,
    responded_by    text        NOT NULL DEFAULT '',
    responded_at    timestamptz,

    CONSTRAINT an_override_states_a_reason CHECK (
        outcome <> 'overridden' OR override_code <> '' OR override_reason <> ''
    ),
    CONSTRAINT an_answered_alert_names_who_answered CHECK (
        outcome = 'pending' OR responded_by <> ''
    )
);

-- The override report the requirement exists to make possible.
CREATE INDEX cds_alert_override_idx
    ON clinical.cds_alert (tenant_id, rule_id, rule_version, responded_at DESC)
    WHERE outcome = 'overridden';

CREATE INDEX cds_alert_pending_idx
    ON clinical.cds_alert (tenant_id, patient_id, fired_at DESC)
    WHERE outcome = 'pending';

-- A request for another service's opinion (SRS-CLN-022).
CREATE TABLE clinical.consult (
    consult_id      uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    patient_id      uuid        NOT NULL,
    encounter_id    uuid        NOT NULL,
    specialty       text        NOT NULL CHECK (specialty <> ''),
    urgency         text        NOT NULL CHECK (urgency IN (
                        'emergency', 'urgent', 'routine')),
    reason          text        NOT NULL DEFAULT '',
    -- A consult with background but no question produces an opinion that
    -- answers something else, which is the commonest way a consult wastes two
    -- clinicians' time.
    question        text        NOT NULL CHECK (question <> ''),
    status          text        NOT NULL CHECK (status IN (
                        'requested', 'accepted', 'answered', 'declined',
                        'cancelled')),
    responding_subject_id text  NOT NULL DEFAULT '',
    response        text        NOT NULL DEFAULT '',
    -- The answer lands on the request rather than becoming a free-floating
    -- note: a requester who has to search the chart for the reply will not
    -- find it.
    response_document_id uuid   REFERENCES clinical.document (document_id),
    decline_reason  text        NOT NULL DEFAULT '',
    requested_by    text        NOT NULL,
    requested_at    timestamptz NOT NULL,
    responded_at    timestamptz,
    updated_at      timestamptz NOT NULL,
    version         bigint      NOT NULL DEFAULT 1,

    CONSTRAINT an_answered_consult_has_an_answer CHECK (
        status <> 'answered' OR response <> '' OR response_document_id IS NOT NULL
    ),
    CONSTRAINT a_declined_consult_says_why CHECK (
        status <> 'declined' OR decline_reason <> ''
    )
);

-- The receiving service's worklist, most urgent first.
CREATE INDEX consult_open_idx
    ON clinical.consult (tenant_id, specialty, urgency, requested_at)
    WHERE status IN ('requested', 'accepted');

CREATE INDEX consult_patient_idx
    ON clinical.consult (tenant_id, patient_id, requested_at DESC);

-- A patient's place in a disease registry (SRS-CLN-023).
--
-- A pointer, never a copy. A registry holding its own copy of a diagnosis is a
-- second version of the patient's record that nobody updates: the diabetes
-- registry still says type 1 three years after the diagnosis was corrected.
CREATE TABLE clinical.registry_membership (
    membership_id   uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    patient_id      uuid        NOT NULL,
    registry_id     text        NOT NULL CHECK (registry_id <> ''),
    problem_id      uuid        REFERENCES clinical.problem (problem_id),
    diagnosis_id    uuid,
    enrolled_at     timestamptz NOT NULL,
    exited_at       timestamptz,
    exit_reason     text        NOT NULL DEFAULT '',
    -- Not every registry needs consent — a statutory cancer registry does not
    -- — so this is a fact rather than a gate.
    consented       boolean     NOT NULL DEFAULT false,
    enrolled_by     text        NOT NULL,
    recorded_at     timestamptz NOT NULL,

    -- A membership resting on nothing cannot be re-derived or defended, and
    -- the alternative — copying the diagnosis in — is the drift the
    -- requirement exists to prevent.
    CONSTRAINT a_membership_points_at_something CHECK (
        problem_id IS NOT NULL OR diagnosis_id IS NOT NULL
    ),
    CONSTRAINT a_membership_ends_after_it_begins CHECK (
        exited_at IS NULL OR exited_at >= enrolled_at
    ),
    CONSTRAINT leaving_a_registry_says_why CHECK (
        exited_at IS NULL OR exit_reason <> ''
    )
);

-- One live membership per registry per patient.
CREATE UNIQUE INDEX registry_membership_current_key
    ON clinical.registry_membership (tenant_id, patient_id, registry_id)
    WHERE exited_at IS NULL;

-- A stored expansion a clinician types a shortcut for (SRS-CLN-015).
CREATE TABLE clinical.smart_phrase (
    phrase_id       uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    -- Empty means shared across the tenant; otherwise it is one clinician's.
    owner_id        text        NOT NULL DEFAULT '',
    shortcut        text        NOT NULL CHECK (shortcut <> ''),
    expansion       text        NOT NULL CHECK (expansion <> ''),
    created_at      timestamptz NOT NULL,
    updated_at      timestamptz NOT NULL
);

-- One meaning per shortcut per owner: two expansions for ".normalcvs" is a
-- clinician who cannot predict what their own note will say.
CREATE UNIQUE INDEX smart_phrase_key
    ON clinical.smart_phrase (tenant_id, owner_id, shortcut);
