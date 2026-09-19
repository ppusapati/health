-- 0040 Medical records and health information management (SRS-MRD-001 … 010).
--
-- Six shapes here are unusual and deliberate.
--
-- There is no column in this schema that holds clinical text. Not a
-- narrative, not a section, not a finding. This context records which
-- documents exist, who signed them, what was coded, what was released and
-- what may be destroyed; the clinical content belongs to the clinical schema
-- and stays there. SRS-MRD-003 and SRS-MRD-008 both say so in their
-- acceptance criteria, and a schema with nowhere to put a narrative is a
-- stronger guarantee than a rule somebody reads once. The one text column
-- that comes close — records.deficiency.detail — is a reviewer's statement
-- about a document ("no medication list on discharge") and never from it.
--
-- A deficiency resolves by naming the document that answered it, and a
-- CHECK refuses an inadequate-document deficiency resolved by the same
-- document it was raised against. That is SRS-MRD-008's "without altering
-- signed history" at the table: the answer to an inadequate signed note is an
-- addendum, which has its own identifier.
--
-- Coding is revisions, not a mutable code list. records.coding_revision is
-- append-only and a code row belongs to a revision, so "what did we bill
-- under last quarter" has an answer. A partial unique index holds exactly one
-- principal diagnosis per revision, because two is two answers to "why was
-- this patient admitted" and every grouper that reads it picks one
-- arbitrarily. present_on_admission is NOT NULL on a diagnosis: defaulting it
-- would bias every hospital-acquired complication rate computed from this
-- data, in whichever direction the default fell.
--
-- A release keeps its package as rows. SRS-MRD-004's acceptance is that the
-- package is retained, and two years later the question is never "did we
-- release something" but "what did we release" — a row listing a scope cannot
-- answer it. records.release_item is one row per document that actually went.
--
-- records.disclosure duplicates what the platform audit trail also records,
-- and the duplication is the point: the audit trail is an operational record
-- with its own retention, and this is the accounting of disclosures a patient
-- is entitled to ask for. Its four SRS-MRD-010 columns — actor, purpose,
-- scope and recipient reference — are NOT NULL and non-empty by CHECK.
--
-- A statutory serial is unique per certificate, not per version. The
-- registrar holds one document under that number and a correction replaces
-- it, so the serial lives on records.certificate with a partial unique index
-- while each version keeps the serial it was issued under.
--
-- A destroyed physical record keeps its row, in state 'destroyed', naming the
-- approved list it was on. "We had it and destroyed it lawfully under this
-- rule on this certificate" is a different answer from "we never had it", and
-- only one of them is defensible.
--
-- Legal holds are not here. SRS-MRD-005 uses the platform's own mechanism
-- (security.legal_hold), the same one SRS-QMS-015 uses. A hold placed in one
-- place and a purge that reads another is a hold that does nothing, and
-- nobody finds out until the records are gone.
--
-- Trace: SRS-MRD-001 … SRS-MRD-010.
--
-- Rollback: drops the schema. Every chart checklist, deficiency, coded
-- episode and its revisions, release and its package, retention rule,
-- disposition list, physical record location and statutory certificate goes
-- with it. The certificates are documents a family and a registrar hold
-- copies of, and the disclosure accounting is what a patient is entitled to
-- ask for. Treat this as a disaster-recovery action, never a deployment step.
--
-- Reconciliation: the tables are new, so the previous version writes nothing
-- here and sees nothing missing.

CREATE SCHEMA IF NOT EXISTS records;

-- Chart completion checklists (SRS-MRD-001).
CREATE TABLE records.chart_checklist (
    checklist_id uuid PRIMARY KEY,
    tenant_id    uuid NOT NULL,

    code     text    NOT NULL CHECK (code <> ''),
    name     text    NOT NULL DEFAULT '',
    revision integer NOT NULL CHECK (revision > 0),

    encounter_class text NOT NULL CHECK (encounter_class <> ''),
    -- Empty matches every specialty of the class, which is how a hospital
    -- writes one inpatient baseline and overrides it for obstetrics.
    specialty text NOT NULL DEFAULT '',

    approved    boolean NOT NULL DEFAULT false,
    approved_by text    NOT NULL DEFAULT '',
    approved_at timestamptz,

    effective_from timestamptz,
    superseded_at  timestamptz,
    created_at     timestamptz NOT NULL,
    created_by     text        NOT NULL CHECK (created_by <> ''),

    -- One person writing and approving a checklist is one person deciding
    -- which consultants get a deficiency letter.
    CONSTRAINT a_checklist_is_approved_by_somebody_else CHECK (
        NOT approved
        OR (approved_by <> '' AND approved_by <> created_by
            AND effective_from IS NOT NULL)
    )
);

CREATE UNIQUE INDEX chart_checklist_revision_idx
    ON records.chart_checklist (tenant_id, code, revision);
CREATE INDEX chart_checklist_live_idx
    ON records.chart_checklist
       (tenant_id, encounter_class, specialty, effective_from DESC)
    WHERE approved AND superseded_at IS NULL;

CREATE TABLE records.checklist_item (
    item_id      uuid PRIMARY KEY,
    tenant_id    uuid NOT NULL,
    checklist_id uuid NOT NULL
        REFERENCES records.chart_checklist (checklist_id) ON DELETE CASCADE,

    -- The document kind, in the clinical schema's vocabulary. Text rather
    -- than an enum because the list of note kinds is that context's to own.
    document_kind text NOT NULL CHECK (document_kind <> ''),
    label         text NOT NULL DEFAULT '',
    requirement   text NOT NULL CHECK (requirement IN (
        'signed', 'present', 'conditional')),
    -- Seconds rather than an interval, so the arithmetic that derives a due
    -- date is the same in the database and in Go.
    due_within_seconds bigint NOT NULL DEFAULT 0
        CHECK (due_within_seconds >= 0),
    condition_code text NOT NULL DEFAULT '',

    -- A conditional item with no condition applies to nothing, or to
    -- everything, depending on the reader.
    CONSTRAINT a_conditional_item_names_its_condition CHECK (
        requirement <> 'conditional' OR condition_code <> ''
    )
);

-- The same kind twice is two deficiencies for one gap, and a worklist that
-- double-counts is one nobody believes.
CREATE UNIQUE INDEX checklist_item_kind_idx
    ON records.checklist_item (tenant_id, checklist_id, lower(document_kind));

-- Chart deficiencies (SRS-MRD-001, SRS-MRD-002, SRS-MRD-008).
CREATE TABLE records.deficiency (
    deficiency_id uuid PRIMARY KEY,
    tenant_id     uuid NOT NULL,

    patient_id   text NOT NULL DEFAULT '',
    encounter_id text NOT NULL CHECK (encounter_id <> ''),
    facility_id  text NOT NULL DEFAULT '',

    kind text NOT NULL CHECK (kind IN (
        'missing_document', 'unsigned_document', 'incomplete_document',
        'coding_query')),
    document_kind text NOT NULL CHECK (document_kind <> ''),
    label         text NOT NULL DEFAULT '',
    -- The unsigned or inadequate document. Empty for a missing one, which is
    -- the whole difference between the two kinds.
    document_id text NOT NULL DEFAULT '',
    -- A reviewer's statement about the document. Never from it.
    detail text NOT NULL DEFAULT '',

    -- A deficiency owned by "the medical team" is owned by nobody, and it is
    -- still open when a coroner asks for the notes.
    owner_id text NOT NULL CHECK (owner_id <> ''),
    checklist_code     text    NOT NULL DEFAULT '',
    checklist_revision integer NOT NULL DEFAULT 0,

    state text NOT NULL CHECK (state IN ('open', 'resolved', 'waived')),
    due_by timestamptz,

    raised_at timestamptz NOT NULL,
    raised_by text        NOT NULL CHECK (raised_by <> ''),

    -- The note, signature or addendum that answered it.
    resolved_by_document_id text NOT NULL DEFAULT '',
    resolved_at timestamptz,
    resolved_by text NOT NULL DEFAULT '',
    waived_reason text NOT NULL DEFAULT '',

    escalated_at timestamptz,
    version      bigint NOT NULL DEFAULT 1,

    -- A missing document has no document to name; an unsigned or inadequate
    -- one does. Without both halves the two kinds are indistinguishable in
    -- every report built on them.
    CONSTRAINT a_missing_document_names_no_document CHECK (
        kind <> 'missing_document' OR document_id = ''
    ),
    CONSTRAINT a_document_deficiency_names_its_document CHECK (
        kind NOT IN ('unsigned_document', 'incomplete_document')
        OR document_id <> ''
    ),
    -- "Inadequate" with no detail is a deficiency the clinician cannot
    -- answer, and it sits open until somebody waives it.
    CONSTRAINT an_inadequate_document_says_what_is_inadequate CHECK (
        kind <> 'incomplete_document' OR detail <> ''
    ),
    -- A deficiency closed with nothing to point at is one somebody ticked.
    CONSTRAINT a_resolution_names_what_answered_it CHECK (
        state <> 'resolved'
        OR (resolved_by_document_id <> '' AND resolved_by <> '')
    ),
    -- SRS-MRD-008 at the table: an inadequate signed document is answered by
    -- an addendum or an amendment, which has its own identifier. Resolving it
    -- with itself is the edit-in-place the requirement exists to prevent.
    CONSTRAINT signed_history_is_answered_not_altered CHECK (
        kind <> 'incomplete_document'
        OR resolved_by_document_id = ''
        OR resolved_by_document_id <> document_id
    ),
    CONSTRAINT a_waiver_says_why CHECK (
        state <> 'waived' OR (waived_reason <> '' AND resolved_by <> '')
    )
);

CREATE INDEX deficiency_worklist_idx
    ON records.deficiency (tenant_id, owner_id, due_by)
    WHERE state = 'open';
CREATE INDEX deficiency_encounter_idx
    ON records.deficiency (tenant_id, encounter_id);
CREATE INDEX deficiency_aging_idx
    ON records.deficiency (tenant_id, facility_id, raised_at)
    WHERE state = 'open';
CREATE INDEX deficiency_escalation_idx
    ON records.deficiency (tenant_id, due_by)
    WHERE state = 'open' AND escalated_at IS NULL;

-- Coding (SRS-MRD-003).
CREATE TABLE records.coded_episode (
    episode_id uuid PRIMARY KEY,
    tenant_id  uuid NOT NULL,

    patient_id   text NOT NULL CHECK (patient_id <> ''),
    encounter_id text NOT NULL CHECK (encounter_id <> ''),
    facility_id  text NOT NULL DEFAULT '',

    created_at timestamptz NOT NULL,
    created_by text        NOT NULL CHECK (created_by <> ''),
    version    bigint      NOT NULL DEFAULT 1
);

-- One coded episode per encounter. Two would be two answers to what the
-- hospital reported for this admission.
CREATE UNIQUE INDEX coded_episode_encounter_idx
    ON records.coded_episode (tenant_id, encounter_id);

CREATE TABLE records.coding_revision (
    revision_id uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,
    episode_id  uuid NOT NULL
        REFERENCES records.coded_episode (episode_id) ON DELETE CASCADE,

    revision integer NOT NULL CHECK (revision > 0),
    -- Required from revision 2: the first is the coding and every one after
    -- it is a change somebody has to be able to question.
    reason text NOT NULL DEFAULT '',

    state text NOT NULL CHECK (state IN (
        'in_progress', 'queried', 'coded', 'final')),
    coded_by text        NOT NULL CHECK (coded_by <> ''),
    coded_at timestamptz NOT NULL,
    -- The second read.
    reviewed_by text NOT NULL DEFAULT '',
    reviewed_at timestamptz,

    CONSTRAINT a_changed_coding_says_why CHECK (
        revision = 1 OR reason <> ''
    ),
    -- Coded data is what a hospital is funded on and benchmarked by, and a
    -- second read by the same person is the same read.
    CONSTRAINT the_second_read_is_a_second_person CHECK (
        state <> 'final'
        OR (reviewed_by <> '' AND reviewed_by <> coded_by
            AND reviewed_at IS NOT NULL)
    )
);

CREATE UNIQUE INDEX coding_revision_number_idx
    ON records.coding_revision (tenant_id, episode_id, revision);

CREATE TABLE records.assigned_code (
    code_id     uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,
    revision_id uuid NOT NULL
        REFERENCES records.coding_revision (revision_id) ON DELETE CASCADE,

    -- A code with no system is a string: ICD-10 J18.9 and ICD-11 CA40.0 are
    -- both "pneumonia" and neither is the other. A code with no edition
    -- cannot be re-grouped after the terminology is revised.
    code_system  text NOT NULL CHECK (code_system <> ''),
    code_version text NOT NULL CHECK (code_version <> ''),
    code_value   text NOT NULL CHECK (code_value <> ''),
    -- The terminology's own label, not a coder's words about the patient.
    display text NOT NULL DEFAULT '',

    role text NOT NULL CHECK (role IN (
        'principal_diagnosis', 'secondary_diagnosis', 'principal_procedure',
        'secondary_procedure', 'external_cause', 'morphology')),
    sequence integer NOT NULL DEFAULT 0,
    present_on_admission text NOT NULL CHECK (present_on_admission IN (
        'yes', 'no', 'undetermined', 'not_applicable')),

    -- The clinical document the code was read from. Half of SRS-MRD-003's
    -- provenance; the revision history is the other half.
    source_document_id text NOT NULL DEFAULT '',

    -- Defaulting this would bias every hospital-acquired complication rate
    -- computed from coded data, in whichever direction the default fell.
    CONSTRAINT a_diagnosis_says_whether_it_was_present_on_admission CHECK (
        role NOT IN ('principal_diagnosis', 'secondary_diagnosis',
                     'external_cause', 'morphology')
        OR present_on_admission <> 'not_applicable'
    ),
    CONSTRAINT a_procedure_has_no_admission_status CHECK (
        role NOT IN ('principal_procedure', 'secondary_procedure')
        OR present_on_admission = 'not_applicable'
    )
);

-- Two principal diagnoses is two answers to "why was this patient admitted".
CREATE UNIQUE INDEX assigned_code_principal_diagnosis_idx
    ON records.assigned_code (tenant_id, revision_id)
    WHERE role = 'principal_diagnosis';
CREATE UNIQUE INDEX assigned_code_principal_procedure_idx
    ON records.assigned_code (tenant_id, revision_id)
    WHERE role = 'principal_procedure';
CREATE UNIQUE INDEX assigned_code_unique_idx
    ON records.assigned_code
       (tenant_id, revision_id, lower(code_system), lower(code_value), role);
CREATE INDEX assigned_code_revision_idx
    ON records.assigned_code (tenant_id, revision_id);

-- Record release (SRS-MRD-004).
CREATE TABLE records.release_request (
    release_id uuid PRIMARY KEY,
    tenant_id  uuid NOT NULL,

    reference  text NOT NULL DEFAULT '',
    patient_id text NOT NULL CHECK (patient_id <> ''),

    -- The four SRS-MRD-004 names. Every one of them is required.
    purpose            text NOT NULL CHECK (purpose <> ''),
    authority_kind text NOT NULL CHECK (authority_kind IN (
        'patient_consent', 'authorised_representative', 'court_order',
        'statutory_requirement', 'continuity_of_care', 'insurance_claim')),
    -- A release whose authority cannot be produced later is one nobody can
    -- defend.
    authority_reference text NOT NULL CHECK (authority_reference <> ''),
    authority_signed_by text NOT NULL DEFAULT '',
    authority_signed_at timestamptz,
    authority_expires_at timestamptz,

    recipient_kind text NOT NULL CHECK (recipient_kind IN (
        'patient', 'treating_clinician', 'institution', 'insurer', 'legal',
        'government_body')),
    recipient_name text NOT NULL CHECK (recipient_name <> ''),
    -- Three hospitals are called St Mary's.
    recipient_reference text NOT NULL CHECK (recipient_reference <> ''),
    delivery_method     text NOT NULL DEFAULT '',

    scope_from      timestamptz,
    scope_to        timestamptz,
    record_classes  text[] NOT NULL DEFAULT '{}',
    document_kinds  text[] NOT NULL DEFAULT '{}',
    encounter_ids   text[] NOT NULL DEFAULT '{}',
    whole_record       boolean NOT NULL DEFAULT false,
    include_restricted boolean NOT NULL DEFAULT false,

    state text NOT NULL CHECK (state IN (
        'requested', 'approved', 'assembled', 'released', 'refused')),
    refusal_reason text NOT NULL DEFAULT '',

    requested_at timestamptz NOT NULL,
    requested_by text        NOT NULL CHECK (requested_by <> ''),
    approved_at  timestamptz,
    approved_by  text NOT NULL DEFAULT '',

    content_hash text   NOT NULL DEFAULT '',
    pages        integer NOT NULL DEFAULT 0 CHECK (pages >= 0),
    assembled_at timestamptz,
    assembled_by text NOT NULL DEFAULT '',
    released_at  timestamptz,
    released_by  text NOT NULL DEFAULT '',

    version bigint NOT NULL DEFAULT 1,

    -- A scope with nothing in it is a request for everything ever recorded
    -- about a person, and it has to be asked for rather than fallen into.
    -- array_length of an empty array is NULL and a CHECK evaluating to NULL
    -- passes, so the COALESCE is load-bearing.
    CONSTRAINT a_scope_says_what_it_wants CHECK (
        whole_record
        OR scope_from IS NOT NULL OR scope_to IS NOT NULL
        OR COALESCE(array_length(record_classes, 1), 0) > 0
        OR COALESCE(array_length(document_kinds, 1), 0) > 0
        OR COALESCE(array_length(encounter_ids, 1), 0) > 0
    ),
    CONSTRAINT a_scope_period_ends_after_it_starts CHECK (
        scope_from IS NULL OR scope_to IS NULL OR scope_to > scope_from
    ),
    -- A records officer who requested a release and then approved it is one
    -- person deciding that a patient's record leaves the hospital.
    CONSTRAINT a_release_is_approved_by_somebody_else CHECK (
        state NOT IN ('approved', 'assembled', 'released')
        OR (approved_by <> '' AND approved_by <> requested_by)
    ),
    CONSTRAINT a_refusal_says_why CHECK (
        state <> 'refused' OR refusal_reason <> ''
    ),
    CONSTRAINT a_released_package_says_when_it_went CHECK (
        state <> 'released' OR (released_at IS NOT NULL AND released_by <> '')
    )
);

CREATE UNIQUE INDEX release_reference_idx
    ON records.release_request (tenant_id, reference) WHERE reference <> '';
CREATE INDEX release_patient_idx
    ON records.release_request (tenant_id, patient_id, requested_at DESC);
CREATE INDEX release_open_idx
    ON records.release_request (tenant_id, requested_at)
    WHERE state IN ('requested', 'approved', 'assembled');

-- Exactly what left the hospital (SRS-MRD-004).
CREATE TABLE records.release_item (
    item_id    uuid PRIMARY KEY,
    tenant_id  uuid NOT NULL,
    release_id uuid NOT NULL
        REFERENCES records.release_request (release_id) ON DELETE CASCADE,

    -- A reference and its provenance, never its content.
    document_id  text NOT NULL CHECK (document_id <> ''),
    encounter_id text NOT NULL DEFAULT '',
    document_kind text NOT NULL DEFAULT '',
    record_class  text NOT NULL DEFAULT '',
    occurred_at   timestamptz,
    restricted    boolean NOT NULL DEFAULT false,
    pages         integer NOT NULL DEFAULT 0 CHECK (pages >= 0)
);

CREATE UNIQUE INDEX release_item_document_idx
    ON records.release_item (tenant_id, release_id, document_id);

-- The accounting of disclosures (SRS-MRD-010).
CREATE TABLE records.disclosure (
    disclosure_id uuid PRIMARY KEY,
    tenant_id     uuid NOT NULL,

    patient_id text NOT NULL CHECK (patient_id <> ''),
    kind text NOT NULL CHECK (kind IN ('release', 'export', 'print')),
    release_id uuid REFERENCES records.release_request (release_id),

    -- The four SRS-MRD-010's acceptance names, and they are required.
    actor_id            text NOT NULL CHECK (actor_id <> ''),
    purpose             text NOT NULL CHECK (purpose <> ''),
    scope_summary       text NOT NULL CHECK (scope_summary <> ''),
    recipient_reference text NOT NULL CHECK (recipient_reference <> ''),
    recipient_name      text NOT NULL DEFAULT '',

    items       integer NOT NULL DEFAULT 0 CHECK (items >= 0),
    pages       integer NOT NULL DEFAULT 0 CHECK (pages >= 0),
    occurred_at timestamptz NOT NULL
);

CREATE INDEX disclosure_patient_idx
    ON records.disclosure (tenant_id, patient_id, occurred_at DESC);
CREATE INDEX disclosure_actor_idx
    ON records.disclosure (tenant_id, actor_id, occurred_at DESC);

-- Retention (SRS-MRD-009).
CREATE TABLE records.retention_rule (
    rule_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    code     text    NOT NULL CHECK (code <> ''),
    name     text    NOT NULL DEFAULT '',
    revision integer NOT NULL CHECK (revision > 0),

    record_class text NOT NULL CHECK (record_class <> ''),
    -- A schedule with no jurisdiction is one nobody can defend to a
    -- regulator, and a group operating in two states needs two.
    jurisdiction text NOT NULL CHECK (jurisdiction <> ''),

    -- A minor's record runs from their eighteenth birthday, not from the
    -- discharge. A schedule that anchored everything to discharge would
    -- destroy children's records years early.
    anchor text NOT NULL CHECK (anchor IN (
        'discharge', 'last_contact', 'majority', 'death', 'creation')),
    retain_years integer NOT NULL CHECK (retain_years >= 0),
    disposition text NOT NULL CHECK (disposition IN (
        'destroy', 'archive', 'permanent')),
    -- The first question about a destruction is which rule allowed it.
    authority text NOT NULL CHECK (authority <> ''),

    approved    boolean NOT NULL DEFAULT false,
    approved_by text    NOT NULL DEFAULT '',
    approved_at timestamptz,

    effective_from timestamptz,
    superseded_at  timestamptz,
    created_at     timestamptz NOT NULL,
    created_by     text        NOT NULL CHECK (created_by <> ''),

    -- Zero years with a destroy disposition destroys on the anchor date.
    CONSTRAINT a_rule_that_disposes_keeps_the_record_first CHECK (
        disposition = 'permanent' OR retain_years > 0
    ),
    CONSTRAINT a_retention_rule_is_approved_by_somebody_else CHECK (
        NOT approved
        OR (approved_by <> '' AND approved_by <> created_by
            AND effective_from IS NOT NULL)
    )
);

CREATE UNIQUE INDEX retention_rule_revision_idx
    ON records.retention_rule (tenant_id, code, revision);
CREATE INDEX retention_rule_live_idx
    ON records.retention_rule
       (tenant_id, record_class, jurisdiction, effective_from DESC)
    WHERE approved AND superseded_at IS NULL;

CREATE TABLE records.disposition_list (
    list_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    reference    text NOT NULL DEFAULT '',
    jurisdiction text NOT NULL CHECK (jurisdiction <> ''),
    -- One kind at a time: a list mixing archival and destruction is one
    -- where an approver ticks one and gets both.
    disposition text NOT NULL CHECK (disposition IN ('destroy', 'archive')),

    state text NOT NULL CHECK (state IN (
        'draft', 'approved', 'executed', 'cancelled')),

    prepared_at timestamptz NOT NULL,
    prepared_by text        NOT NULL CHECK (prepared_by <> ''),
    approved_at timestamptz,
    approved_by text NOT NULL DEFAULT '',
    executed_at timestamptz,
    executed_by text NOT NULL DEFAULT '',
    certificate text NOT NULL DEFAULT '',
    cancelled_reason text NOT NULL DEFAULT '',

    version bigint NOT NULL DEFAULT 1,

    -- The last check before records stop existing. One person preparing and
    -- approving it is one person deciding what the hospital no longer has.
    CONSTRAINT a_disposition_list_is_approved_by_somebody_else CHECK (
        state NOT IN ('approved', 'executed')
        OR (approved_by <> '' AND approved_by <> prepared_by
            AND approved_at IS NOT NULL)
    ),
    CONSTRAINT an_executed_list_says_who_carried_it_out CHECK (
        state <> 'executed'
        OR (executed_by <> '' AND executed_at IS NOT NULL)
    ),
    CONSTRAINT a_cancelled_list_says_why CHECK (
        state <> 'cancelled' OR cancelled_reason <> ''
    )
);

CREATE UNIQUE INDEX disposition_list_reference_idx
    ON records.disposition_list (tenant_id, reference) WHERE reference <> '';
CREATE INDEX disposition_list_state_idx
    ON records.disposition_list (tenant_id, state, prepared_at DESC);

CREATE TABLE records.disposition_item (
    item_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,
    list_id   uuid NOT NULL
        REFERENCES records.disposition_list (list_id) ON DELETE CASCADE,

    record_id    text NOT NULL CHECK (record_id <> ''),
    patient_id   text NOT NULL DEFAULT '',
    record_class text NOT NULL DEFAULT '',
    description  text NOT NULL DEFAULT '',

    -- The rule that made it eligible, pinned. The first question about a
    -- destruction is which rule allowed it, and a rule revised afterwards
    -- must not change the answer.
    rule_code     text    NOT NULL CHECK (rule_code <> ''),
    rule_revision integer NOT NULL CHECK (rule_revision > 0),
    authority     text    NOT NULL DEFAULT '',
    anchor_date   timestamptz,
    eligible_from timestamptz NOT NULL
);

CREATE UNIQUE INDEX disposition_item_record_idx
    ON records.disposition_item (tenant_id, list_id, record_id);

-- Physical legacy records (SRS-MRD-006).
CREATE TABLE records.physical_record (
    record_id uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    -- What is written on the folder, and how somebody at a shelf finds it.
    reference    text    NOT NULL CHECK (reference <> ''),
    patient_id   text    NOT NULL CHECK (patient_id <> ''),
    volume       integer NOT NULL DEFAULT 1 CHECK (volume > 0),
    record_class text    NOT NULL DEFAULT '',
    jurisdiction text    NOT NULL DEFAULT '',
    description  text    NOT NULL DEFAULT '',

    state text NOT NULL CHECK (state IN (
        'filed', 'checked_out', 'archived', 'destroyed', 'missing')),
    home_location    text NOT NULL CHECK (home_location <> ''),
    current_location text NOT NULL DEFAULT '',
    -- A record out to "the ward" is a record nobody has to give back.
    custodian      text NOT NULL DEFAULT '',
    checked_out_at timestamptz,
    checked_out_by text NOT NULL DEFAULT '',
    due_back_at    timestamptz,
    purpose        text NOT NULL DEFAULT '',

    created_at timestamptz NOT NULL,
    created_by text        NOT NULL CHECK (created_by <> ''),
    version    bigint      NOT NULL DEFAULT 1,

    CONSTRAINT a_record_out_names_its_custodian CHECK (
        state <> 'checked_out'
        OR (custodian <> '' AND current_location <> ''
            AND purpose <> '' AND checked_out_at IS NOT NULL)
    ),
    CONSTRAINT a_filed_record_is_with_nobody CHECK (
        state NOT IN ('filed', 'archived') OR custodian = ''
    )
);

CREATE UNIQUE INDEX physical_record_reference_idx
    ON records.physical_record (tenant_id, reference, volume);
CREATE INDEX physical_record_patient_idx
    ON records.physical_record (tenant_id, patient_id);
CREATE INDEX physical_record_out_idx
    ON records.physical_record (tenant_id, due_back_at)
    WHERE state = 'checked_out';

-- Statutory certificates (SRS-MRD-007).
CREATE TABLE records.certificate_form (
    form_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    code     text    NOT NULL CHECK (code <> ''),
    name     text    NOT NULL DEFAULT '',
    revision integer NOT NULL CHECK (revision > 0),

    kind text NOT NULL CHECK (kind IN (
        'birth', 'death', 'stillbirth', 'medical', 'cause_of_death')),
    jurisdiction text NOT NULL CHECK (jurisdiction <> ''),
    -- Who may sign is a statutory question, not a permission the hospital
    -- invents at issue time.
    issuer_role text NOT NULL CHECK (issuer_role <> ''),

    approved    boolean NOT NULL DEFAULT false,
    approved_by text    NOT NULL DEFAULT '',
    approved_at timestamptz,

    effective_from timestamptz,
    superseded_at  timestamptz,
    created_at     timestamptz NOT NULL,
    created_by     text        NOT NULL CHECK (created_by <> ''),

    CONSTRAINT a_form_is_approved_by_somebody_else CHECK (
        NOT approved
        OR (approved_by <> '' AND approved_by <> created_by
            AND effective_from IS NOT NULL)
    )
);

CREATE UNIQUE INDEX certificate_form_revision_idx
    ON records.certificate_form (tenant_id, code, revision);
CREATE INDEX certificate_form_live_idx
    ON records.certificate_form
       (tenant_id, kind, jurisdiction, effective_from DESC)
    WHERE approved AND superseded_at IS NULL;

CREATE TABLE records.certificate_field (
    field_id  uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,
    form_id   uuid NOT NULL
        REFERENCES records.certificate_form (form_id) ON DELETE CASCADE,

    code     text    NOT NULL CHECK (code <> ''),
    label    text    NOT NULL DEFAULT '',
    required boolean NOT NULL DEFAULT false,
    -- Where the value comes from in the hospital's own records, so a later
    -- question about a certificate is answered from the record.
    source_path text NOT NULL DEFAULT '',
    ordinal     integer NOT NULL DEFAULT 0
);

CREATE UNIQUE INDEX certificate_field_code_idx
    ON records.certificate_field (tenant_id, form_id, lower(code));

CREATE TABLE records.certificate (
    certificate_id uuid PRIMARY KEY,
    tenant_id      uuid NOT NULL,

    kind text NOT NULL CHECK (kind IN (
        'birth', 'death', 'stillbirth', 'medical', 'cause_of_death')),
    -- The form version it was issued against, pinned.
    form_code     text    NOT NULL CHECK (form_code <> ''),
    form_revision integer NOT NULL CHECK (form_revision > 0),
    jurisdiction  text    NOT NULL DEFAULT '',

    patient_id   text NOT NULL CHECK (patient_id <> ''),
    encounter_id text NOT NULL DEFAULT '',

    -- The statutory serial the registrar holds. It belongs to the
    -- certificate rather than to each version: a correction replaces the
    -- document that serial names, and two certificates sharing one serial is
    -- how a registrar ends up holding two different documents with one
    -- number. Each version keeps the serial it was issued under as well, for
    -- the record of what was actually sent.
    serial_number text NOT NULL DEFAULT '',

    state text NOT NULL CHECK (state IN ('issued', 'voided')),
    void_reason text NOT NULL DEFAULT '',
    voided_by   text NOT NULL DEFAULT '',
    voided_at   timestamptz,

    created_at timestamptz NOT NULL,
    version    bigint      NOT NULL DEFAULT 1,

    -- A certificate withdrawn without a reason is one a family cannot be
    -- told about.
    CONSTRAINT a_voided_certificate_says_why CHECK (
        state <> 'voided'
        OR (void_reason <> '' AND voided_by <> '' AND voided_at IS NOT NULL)
    )
);

CREATE INDEX certificate_patient_idx
    ON records.certificate (tenant_id, patient_id, created_at DESC);
CREATE INDEX certificate_kind_idx
    ON records.certificate (tenant_id, kind, created_at DESC);
CREATE UNIQUE INDEX certificate_serial_idx
    ON records.certificate (tenant_id, serial_number)
    WHERE serial_number <> '';

-- Append-only. A death certificate corrected after issue is a new version
-- that keeps the first: the first one went to a family and to a registrar,
-- and a system that overwrote it could not say what they hold.
CREATE TABLE records.certificate_version (
    version_id     uuid PRIMARY KEY,
    tenant_id      uuid NOT NULL,
    certificate_id uuid NOT NULL
        REFERENCES records.certificate (certificate_id) ON DELETE CASCADE,

    version integer NOT NULL CHECK (version > 0),
    -- The completed fields and where each value came from, as JSON objects
    -- keyed by the form's field codes. Statutory form data, not clinical
    -- narrative: the fields are the ones a registrar's form has.
    values      jsonb NOT NULL DEFAULT '{}'::jsonb,
    source_refs jsonb NOT NULL DEFAULT '{}'::jsonb,

    -- Required from version 2: the first is the certificate and every one
    -- after it is a correction somebody has to be able to question.
    reason text NOT NULL DEFAULT '',

    issuer_id   text NOT NULL CHECK (issuer_id <> ''),
    issuer_name text NOT NULL DEFAULT '',
    issuer_role text NOT NULL CHECK (issuer_role <> ''),
    issued_at   timestamptz NOT NULL,
    serial_number text NOT NULL DEFAULT '',

    CONSTRAINT a_corrected_certificate_says_why CHECK (
        version = 1 OR reason <> ''
    )
);

CREATE UNIQUE INDEX certificate_version_number_idx
    ON records.certificate_version (tenant_id, certificate_id, version);
