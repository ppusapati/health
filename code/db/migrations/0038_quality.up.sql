-- 0038 Quality management, accreditation and risk (SRS-QMS-001 … 015).
--
-- Six shapes here are unusual and deliberate.
--
-- An incident's reach is three states rather than a near-miss flag beside a
-- harm level. Two columns that can contradict each other will, and the
-- contradiction is the one that matters: a near miss recorded with harm is
-- either a mis-filed harm event or a mis-filed near miss, and the reports
-- built on it are wrong either way. The CHECKs below make both directions
-- unwritable.
--
-- Restriction is a column on the record rather than a separate table of
-- secrets. A ward needs to know an incident happened in it; what it must not
-- read is the narrative, the patient and the people. Splitting the record
-- would mean a reader who may see half of it joins to the other half, and
-- every query would carry the decision. One row, one flag, and a redaction in
-- the domain that returns a value rather than asking callers to remember.
--
-- A corrective action's effectiveness checks are rows, not a boolean. "Fixed,
-- checked, had not worked, fixed again, checked, had" is the history that
-- tells a hospital whether its analysis was any good, and a single column
-- keeps only the last word of it.
--
-- Document versions carry their own effective date and the current one is
-- derived. A "current" flag needs a job to maintain it, and a document control
-- system whose current version is whatever a job last set is one that will,
-- eventually, show an unapproved draft as policy.
--
-- An indicator's definition is versioned by (code, revision) and a recorded
-- value names the revision it was computed under. SRS-OPSNFR-008 requires
-- quality indicators be reproducible from source records; an indicator edited
-- in place turns its own history into two different measurements plotted on
-- one line.
--
-- Nothing here is ever deleted by the application. SRS-QMS-015 requires these
-- records be preserved subject to retention and legal hold, and the hold
-- mechanism is the platform's (security.legal_hold) rather than a second one
-- here — a hold placed in one place and a purge that reads another is a hold
-- that does nothing, and nobody finds out until the records are gone.
--
-- Trace: SRS-QMS-001 … SRS-QMS-015.
--
-- Rollback: drops the schema. Every incident, analysis, corrective action,
-- controlled document, audit, accreditation evidence map, indicator,
-- complaint and peer review goes with it. This is the record an accreditation
-- survey reads and the record a coroner asks for. Treat it as a
-- disaster-recovery action, never a deployment step.
--
-- Reconciliation: the tables are new, so the previous version writes nothing
-- here and sees nothing missing.

CREATE SCHEMA IF NOT EXISTS quality;

-- Incidents and near misses (SRS-QMS-001, SRS-QMS-002, SRS-QMS-005).
CREATE TABLE quality.incident (
    incident_id uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,

    reference   text NOT NULL,
    category    text NOT NULL CHECK (category <> ''),
    subcategory text NOT NULL DEFAULT '',

    reach text NOT NULL CHECK (reach IN (
        'near_miss', 'no_harm', 'harm', 'not_patient')),
    harm text NOT NULL CHECK (harm IN (
        'none', 'mild', 'moderate', 'severe', 'death')),

    consequence text NOT NULL CHECK (consequence IN (
        'negligible', 'minor', 'moderate', 'major', 'catastrophic')),
    likelihood text NOT NULL CHECK (likelihood IN (
        'rare', 'unlikely', 'possible', 'likely', 'almost_certain')),
    risk_score integer NOT NULL CHECK (risk_score BETWEEN 1 AND 25),
    risk_band  text    NOT NULL CHECK (risk_band IN (
        'low', 'moderate', 'high', 'extreme')),

    patient_id   text NOT NULL DEFAULT '',
    encounter_id text NOT NULL DEFAULT '',
    asset_id     text NOT NULL DEFAULT '',
    location_id  text NOT NULL DEFAULT '',
    facility_id  text NOT NULL DEFAULT '',
    department   text NOT NULL DEFAULT '',

    narrative        text NOT NULL CHECK (narrative <> ''),
    immediate_action text NOT NULL DEFAULT '',

    sentinel   boolean NOT NULL DEFAULT false,
    restricted boolean NOT NULL DEFAULT false,
    anonymous  boolean NOT NULL DEFAULT false,

    state text NOT NULL CHECK (state IN (
        'reported', 'under_review', 'investigated', 'closed', 'rejected')),

    occurred_at timestamptz NOT NULL,
    reported_at timestamptz NOT NULL,
    reported_by text        NOT NULL CHECK (reported_by <> ''),
    reviewed_by text        NOT NULL DEFAULT '',
    reviewed_at timestamptz,
    closed_by   text        NOT NULL DEFAULT '',
    closed_at   timestamptz,
    closure_reason text     NOT NULL DEFAULT '',

    version bigint NOT NULL DEFAULT 1,

    -- A near miss is an event that did not reach the patient. Harm recorded
    -- against one is a contradiction, and the reports built on it are wrong in
    -- both directions at once.
    CONSTRAINT a_near_miss_harmed_nobody CHECK (
        reach IN ('harm', 'no_harm') OR harm = 'none'
    ),
    CONSTRAINT harm_records_its_level CHECK (
        reach <> 'harm' OR harm <> 'none'
    ),
    -- Something happened to somebody and nothing was done at the time: either
    -- the report is incomplete or the response failed, and a blank column
    -- hides which.
    CONSTRAINT what_reached_a_patient_was_acted_on CHECK (
        reach NOT IN ('harm', 'no_harm') OR immediate_action <> ''
    ),
    -- Left to the reporter, the one incident that most needs an executive
    -- review is the one nobody wants to escalate.
    CONSTRAINT a_death_is_a_sentinel_event CHECK (
        harm <> 'death' OR sentinel
    ),
    -- A sentinel event's review is peer-review material and the people in it
    -- are identifiable.
    CONSTRAINT a_sentinel_event_is_restricted CHECK (
        NOT sentinel OR restricted
    ),
    -- Closing and rejecting are both decisions somebody has to be able to
    -- question later.
    CONSTRAINT a_finished_incident_says_why CHECK (
        state NOT IN ('closed', 'rejected') OR closure_reason <> ''
    ),
    -- The band is derived from the score. Stored for the reports that filter
    -- on it, and held to the arithmetic so the two can never disagree.
    CONSTRAINT the_band_matches_the_score CHECK (
        (risk_score >= 16 AND risk_band = 'extreme')
        OR (risk_score >= 10 AND risk_score < 16 AND risk_band = 'high')
        OR (risk_score >= 4 AND risk_score < 10 AND risk_band = 'moderate')
        OR (risk_score < 4 AND risk_band = 'low')
    )
);

CREATE UNIQUE INDEX incident_reference_idx
    ON quality.incident (tenant_id, reference) WHERE reference <> '';
CREATE INDEX incident_category_idx
    ON quality.incident (tenant_id, category, occurred_at DESC);
CREATE INDEX incident_open_idx
    ON quality.incident (tenant_id, state, risk_band)
    WHERE state IN ('reported', 'under_review', 'investigated');
CREATE INDEX incident_patient_idx
    ON quality.incident (tenant_id, patient_id) WHERE patient_id <> '';

-- Root cause analysis (SRS-QMS-003).
CREATE TABLE quality.rca (
    rca_id      uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,
    incident_id uuid NOT NULL REFERENCES quality.incident (incident_id),

    method            text NOT NULL CHECK (method <> ''),
    accountable_owner text NOT NULL DEFAULT '',
    findings          text NOT NULL DEFAULT '',
    no_action_reason  text NOT NULL DEFAULT '',

    state      text    NOT NULL CHECK (state IN ('open', 'complete')),
    restricted boolean NOT NULL DEFAULT false,

    opened_at timestamptz NOT NULL,
    opened_by text        NOT NULL CHECK (opened_by <> ''),
    closed_at timestamptz,
    closed_by text        NOT NULL DEFAULT '',

    version bigint NOT NULL DEFAULT 1,

    -- An analysis owned by "the committee" is owned by nobody, and one that
    -- closed with no findings recorded nothing.
    CONSTRAINT a_complete_analysis_is_owned CHECK (
        state <> 'complete' OR (accountable_owner <> '' AND findings <> '')
    )
);

CREATE UNIQUE INDEX rca_incident_idx ON quality.rca (tenant_id, incident_id);

CREATE TABLE quality.rca_factor (
    factor_id uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,
    rca_id    uuid NOT NULL REFERENCES quality.rca (rca_id) ON DELETE CASCADE,

    category text NOT NULL CHECK (category IN (
        'patient', 'task', 'individual', 'team', 'environment',
        'equipment', 'organisational')),
    detail text    NOT NULL CHECK (detail <> ''),
    root   boolean NOT NULL DEFAULT false,

    recorded_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX rca_factor_rca_idx ON quality.rca_factor (tenant_id, rca_id);
CREATE INDEX rca_factor_category_idx
    ON quality.rca_factor (tenant_id, category) WHERE root;

-- Corrective and preventive action (SRS-QMS-004).
CREATE TABLE quality.capa (
    capa_id   uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    reference text NOT NULL,
    kind      text NOT NULL CHECK (kind IN ('corrective', 'preventive')),

    source_kind text NOT NULL CHECK (source_kind IN (
        'incident', 'rca', 'audit_finding', 'complaint',
        'committee', 'inspection')),
    source_id text NOT NULL CHECK (source_id <> ''),

    action   text NOT NULL CHECK (action <> ''),
    owner_id text NOT NULL CHECK (owner_id <> ''),

    due_on               timestamptz NOT NULL,
    effectiveness_due_on timestamptz,

    state text NOT NULL CHECK (state IN (
        'draft', 'approved', 'open', 'action_in_progress',
        'effectiveness_review', 'closed', 'cancelled')),

    approved_by text NOT NULL DEFAULT '',
    approved_at timestamptz,

    closed_by        text NOT NULL DEFAULT '',
    closed_at        timestamptz,
    closure_note     text NOT NULL DEFAULT '',
    cancelled_reason text NOT NULL DEFAULT '',

    restricted boolean     NOT NULL DEFAULT false,
    raised_at  timestamptz NOT NULL,
    raised_by  text        NOT NULL CHECK (raised_by <> ''),
    version    bigint      NOT NULL DEFAULT 1,

    -- An action somebody raised, approved, did and closed is one person's
    -- account of their own work. Two separations, at the two ends.
    CONSTRAINT an_action_is_approved_by_somebody_else CHECK (
        approved_by = '' OR approved_by <> raised_by
    ),
    CONSTRAINT the_owner_does_not_approve_their_own_closure CHECK (
        closed_by = '' OR closed_by <> owner_id
    ),
    -- Checking whether a change worked before it was made is a check that will
    -- pass and mean nothing.
    CONSTRAINT a_check_falls_after_the_action CHECK (
        effectiveness_due_on IS NULL OR effectiveness_due_on >= due_on
    ),
    CONSTRAINT a_cancelled_action_says_why CHECK (
        state <> 'cancelled' OR cancelled_reason <> ''
    )
);

CREATE UNIQUE INDEX capa_reference_idx
    ON quality.capa (tenant_id, reference) WHERE reference <> '';
CREATE INDEX capa_source_idx ON quality.capa (tenant_id, source_kind, source_id);
CREATE INDEX capa_open_idx ON quality.capa (tenant_id, due_on)
    WHERE state NOT IN ('closed', 'cancelled');
CREATE INDEX capa_owner_idx ON quality.capa (tenant_id, owner_id)
    WHERE state NOT IN ('closed', 'cancelled');

-- Effectiveness checks, including the ones that failed (SRS-QMS-004).
CREATE TABLE quality.capa_check (
    check_id  uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,
    capa_id   uuid NOT NULL REFERENCES quality.capa (capa_id),

    checked_at timestamptz NOT NULL,
    checked_by text        NOT NULL CHECK (checked_by <> ''),
    effective  boolean     NOT NULL,
    -- "It worked" is an opinion; a re-audit result is a fact.
    evidence text NOT NULL CHECK (evidence <> '')
);

CREATE INDEX capa_check_capa_idx
    ON quality.capa_check (tenant_id, capa_id, checked_at);

-- Controlled documents (SRS-QMS-006).
CREATE TABLE quality.document (
    document_id uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,

    code  text NOT NULL CHECK (code <> ''),
    title text NOT NULL CHECK (title <> ''),
    kind  text NOT NULL CHECK (kind IN (
        'policy', 'sop', 'protocol', 'guideline', 'form', 'manual')),
    owner_id text NOT NULL CHECK (owner_id <> ''),
    -- Zero means nobody has decided, which the readiness report names rather
    -- than treating as "never expires".
    review_months integer NOT NULL DEFAULT 0 CHECK (review_months >= 0),
    department    text    NOT NULL DEFAULT '',

    withdrawn    boolean NOT NULL DEFAULT false,
    withdrawn_at timestamptz,

    created_at timestamptz NOT NULL,
    created_by text        NOT NULL CHECK (created_by <> ''),
    version    bigint      NOT NULL DEFAULT 1
);

CREATE UNIQUE INDEX document_code_idx ON quality.document (tenant_id, code);

CREATE TABLE quality.document_version (
    version_id  uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,
    document_id uuid NOT NULL REFERENCES quality.document (document_id),

    label   text    NOT NULL CHECK (label <> ''),
    ordinal integer NOT NULL CHECK (ordinal > 0),

    content_ref    text NOT NULL DEFAULT '',
    change_summary text NOT NULL DEFAULT '',

    state text NOT NULL CHECK (state IN (
        'draft', 'approved', 'effective', 'obsolete')),

    approved_by    text NOT NULL DEFAULT '',
    approved_at    timestamptz,
    effective_from timestamptz,
    obsolete_from  timestamptz,

    requires_acknowledgement boolean NOT NULL DEFAULT false,
    requires_retraining      boolean NOT NULL DEFAULT false,

    created_at timestamptz NOT NULL,
    created_by text        NOT NULL CHECK (created_by <> ''),
    row_version bigint     NOT NULL DEFAULT 1,

    -- A version with an effective date that nobody approved is an unapproved
    -- draft that the current-version query would return as policy.
    CONSTRAINT an_effective_date_implies_an_approval CHECK (
        effective_from IS NULL OR (approved_by <> '' AND approved_at IS NOT NULL)
    ),
    -- A policy approved with nothing attached will be cited in a survey as
    -- though it were a document.
    CONSTRAINT an_approved_version_has_content CHECK (
        state = 'draft' OR content_ref <> ''
    ),
    CONSTRAINT the_author_does_not_approve_their_own_version CHECK (
        approved_by = '' OR approved_by <> created_by
    ),
    CONSTRAINT a_version_ends_after_it_starts CHECK (
        obsolete_from IS NULL OR effective_from IS NULL
        OR obsolete_from >= effective_from
    )
);

CREATE UNIQUE INDEX document_version_ordinal_idx
    ON quality.document_version (tenant_id, document_id, ordinal);
CREATE INDEX document_version_effective_idx
    ON quality.document_version (tenant_id, document_id, effective_from DESC)
    WHERE effective_from IS NOT NULL;

CREATE TABLE quality.document_acknowledgement (
    acknowledgement_id uuid PRIMARY KEY,
    tenant_id          uuid NOT NULL,
    version_id         uuid NOT NULL
        REFERENCES quality.document_version (version_id),
    document_id uuid NOT NULL REFERENCES quality.document (document_id),

    person_id text NOT NULL CHECK (person_id <> ''),
    role      text NOT NULL DEFAULT '',

    acknowledged_at timestamptz NOT NULL,

    -- One acknowledgement per person per version. A second row would make the
    -- compliance count wrong in the direction that reports a policy as better
    -- read than it is.
    UNIQUE (tenant_id, version_id, person_id)
);

CREATE INDEX acknowledgement_person_idx
    ON quality.document_acknowledgement (tenant_id, person_id);

-- Competency (SRS-QMS-013).
CREATE TABLE quality.competency (
    competency_id uuid PRIMARY KEY,
    tenant_id     uuid NOT NULL,

    code        text NOT NULL CHECK (code <> ''),
    name        text NOT NULL CHECK (name <> ''),
    document_id uuid REFERENCES quality.document (document_id),
    -- Zero means it does not expire, which is a decision rather than an
    -- omission and is reported as such.
    valid_months integer NOT NULL DEFAULT 0 CHECK (valid_months >= 0),

    active     boolean     NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL,
    created_by text        NOT NULL CHECK (created_by <> ''),
    version    bigint      NOT NULL DEFAULT 1
);

CREATE UNIQUE INDEX competency_code_idx ON quality.competency (tenant_id, code);

CREATE TABLE quality.role_competency (
    tenant_id     uuid NOT NULL,
    role          text NOT NULL CHECK (role <> ''),
    competency_id uuid NOT NULL REFERENCES quality.competency (competency_id),

    PRIMARY KEY (tenant_id, role, competency_id)
);

CREATE TABLE quality.competency_award (
    award_id      uuid PRIMARY KEY,
    tenant_id     uuid NOT NULL,
    competency_id uuid NOT NULL REFERENCES quality.competency (competency_id),
    person_id     text NOT NULL CHECK (person_id <> ''),

    -- The document version they were trained against, so a revision marked as
    -- requiring retraining expires exactly the awards made against earlier
    -- text and no others.
    version_id uuid REFERENCES quality.document_version (version_id),
    evidence   text NOT NULL CHECK (evidence <> ''),

    awarded_at timestamptz NOT NULL,
    awarded_by text        NOT NULL CHECK (awarded_by <> ''),
    expires_at timestamptz,

    revoked_at  timestamptz,
    revoked_why text NOT NULL DEFAULT '',

    CONSTRAINT an_award_expires_after_it_is_given CHECK (
        expires_at IS NULL OR expires_at > awarded_at
    ),
    CONSTRAINT a_revocation_says_why CHECK (
        revoked_at IS NULL OR revoked_why <> ''
    )
);

CREATE INDEX award_person_idx
    ON quality.competency_award (tenant_id, person_id, competency_id);

-- Internal audit (SRS-QMS-007).
CREATE TABLE quality.audit (
    audit_id  uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    reference   text NOT NULL,
    title       text NOT NULL CHECK (title <> ''),
    scope       text NOT NULL CHECK (scope <> ''),
    standard_id uuid,

    auditor_id         text NOT NULL CHECK (auditor_id <> ''),
    auditee_department text NOT NULL DEFAULT '',

    planned_from timestamptz NOT NULL,
    planned_to   timestamptz NOT NULL,

    state text NOT NULL CHECK (state IN (
        'planned', 'in_progress', 'reported', 'closed', 'cancelled')),
    summary text NOT NULL DEFAULT '',

    created_at timestamptz NOT NULL,
    created_by text        NOT NULL CHECK (created_by <> ''),
    closed_at  timestamptz,
    closed_by  text        NOT NULL DEFAULT '',
    version    bigint      NOT NULL DEFAULT 1,

    CONSTRAINT an_audit_ends_after_it_starts CHECK (planned_to >= planned_from),
    CONSTRAINT a_reported_audit_has_a_conclusion CHECK (
        state NOT IN ('reported', 'closed') OR summary <> ''
    )
);

CREATE UNIQUE INDEX audit_reference_idx
    ON quality.audit (tenant_id, reference) WHERE reference <> '';

CREATE TABLE quality.audit_finding (
    finding_id uuid PRIMARY KEY,
    tenant_id  uuid NOT NULL,
    audit_id   uuid NOT NULL REFERENCES quality.audit (audit_id),

    clause_id uuid,
    severity  text NOT NULL CHECK (severity IN (
        'observation', 'minor_nc', 'major_nc')),
    detail   text NOT NULL CHECK (detail <> ''),
    evidence text NOT NULL DEFAULT '',

    capa_id uuid REFERENCES quality.capa (capa_id),

    closed_at    timestamptz,
    closed_by    text NOT NULL DEFAULT '',
    closure_note text NOT NULL DEFAULT '',

    raised_at timestamptz NOT NULL,
    raised_by text        NOT NULL CHECK (raised_by <> ''),

    -- A non-conformity is an accusation about the hospital's system. One with
    -- no evidence is an opinion, and the department it names will treat it as
    -- one.
    CONSTRAINT a_non_conformity_records_its_evidence CHECK (
        severity = 'observation' OR evidence <> ''
    ),
    -- The whole of "audit trail links finding to closure": a non-conformity
    -- closed with a note is one somebody talked their way out of, and the next
    -- audit finds it again.
    CONSTRAINT a_non_conformity_closes_through_an_action CHECK (
        closed_at IS NULL OR severity = 'observation' OR capa_id IS NOT NULL
    ),
    CONSTRAINT a_closed_observation_says_how CHECK (
        closed_at IS NULL OR severity <> 'observation' OR closure_note <> ''
    )
);

CREATE INDEX finding_audit_idx ON quality.audit_finding (tenant_id, audit_id);
CREATE INDEX finding_open_idx ON quality.audit_finding (tenant_id, severity)
    WHERE closed_at IS NULL;
CREATE INDEX finding_clause_idx ON quality.audit_finding (tenant_id, clause_id)
    WHERE clause_id IS NOT NULL;

-- Committees and their meetings (SRS-QMS-008).
CREATE TABLE quality.committee (
    committee_id uuid PRIMARY KEY,
    tenant_id    uuid NOT NULL,

    code  text NOT NULL CHECK (code <> ''),
    name  text NOT NULL CHECK (name <> ''),
    terms text NOT NULL DEFAULT '',
    -- Zero means the hospital has not set one, which is reported rather than
    -- treated as "any number will do".
    quorum_size integer NOT NULL DEFAULT 0 CHECK (quorum_size >= 0),
    restricted  boolean NOT NULL DEFAULT false,

    members text[] NOT NULL DEFAULT '{}',

    active     boolean     NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL,
    created_by text        NOT NULL CHECK (created_by <> ''),
    version    bigint      NOT NULL DEFAULT 1
);

CREATE UNIQUE INDEX committee_code_idx ON quality.committee (tenant_id, code);

CREATE TABLE quality.committee_meeting (
    meeting_id   uuid PRIMARY KEY,
    tenant_id    uuid NOT NULL,
    committee_id uuid NOT NULL REFERENCES quality.committee (committee_id),

    scheduled_at timestamptz NOT NULL,
    held_at      timestamptz,

    agenda    text[] NOT NULL DEFAULT '{}',
    attendees text[] NOT NULL DEFAULT '{}',
    -- "Did not come and said so" and "did not come" are different facts about
    -- a committee.
    apologies text[] NOT NULL DEFAULT '{}',
    minutes   text   NOT NULL DEFAULT '',
    decisions jsonb  NOT NULL DEFAULT '[]'::jsonb,

    state text NOT NULL CHECK (state IN (
        'scheduled', 'held', 'minutes_approved', 'cancelled')),
    approved_by text NOT NULL DEFAULT '',
    approved_at timestamptz,

    restricted boolean     NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL,
    created_by text        NOT NULL CHECK (created_by <> ''),
    version    bigint      NOT NULL DEFAULT 1,

    -- Approved minutes that do not record who was there cannot be checked for
    -- quorum by anybody, ever. COALESCE because array_length of an empty array
    -- is NULL, and a CHECK that evaluates to NULL passes.
    CONSTRAINT approved_minutes_record_who_was_there CHECK (
        state <> 'minutes_approved'
        OR (minutes <> '' AND COALESCE(array_length(attendees, 1), 0) > 0)
    ),
    CONSTRAINT a_held_meeting_has_a_date CHECK (
        state NOT IN ('held', 'minutes_approved') OR held_at IS NOT NULL
    )
);

CREATE INDEX meeting_committee_idx
    ON quality.committee_meeting (tenant_id, committee_id, scheduled_at DESC);

-- Accreditation standards and the evidence map (SRS-QMS-009).
CREATE TABLE quality.standard (
    standard_id uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,

    code text NOT NULL CHECK (code <> ''),
    name text NOT NULL CHECK (name <> ''),
    -- Part of the identity: clause numbering changes between editions, and
    -- evidence filed under the old numbering is evidence against a clause that
    -- no longer exists.
    edition text NOT NULL CHECK (edition <> ''),

    active     boolean     NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL,
    created_by text        NOT NULL CHECK (created_by <> ''),
    version    bigint      NOT NULL DEFAULT 1
);

CREATE UNIQUE INDEX standard_code_idx
    ON quality.standard (tenant_id, code, edition);

CREATE TABLE quality.clause (
    clause_id   uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,
    standard_id uuid NOT NULL REFERENCES quality.standard (standard_id),

    reference text    NOT NULL CHECK (reference <> ''),
    chapter   text    NOT NULL DEFAULT '',
    clause_text text  NOT NULL DEFAULT '',
    critical  boolean NOT NULL DEFAULT false,

    created_at timestamptz NOT NULL,
    version    bigint      NOT NULL DEFAULT 1,

    UNIQUE (tenant_id, standard_id, reference)
);

CREATE INDEX clause_standard_idx ON quality.clause (tenant_id, standard_id);

CREATE TABLE quality.evidence (
    evidence_id uuid PRIMARY KEY,
    tenant_id   uuid NOT NULL,
    clause_id   uuid NOT NULL REFERENCES quality.clause (clause_id),

    kind text NOT NULL CHECK (kind IN (
        'document_version', 'audit', 'audit_finding', 'capa', 'kpi',
        'committee_meeting', 'competency', 'external')),
    ref_id       text NOT NULL DEFAULT '',
    external_ref text NOT NULL DEFAULT '',
    description  text NOT NULL DEFAULT '',

    added_at timestamptz NOT NULL,
    added_by text        NOT NULL CHECK (added_by <> ''),

    -- Withdrawn rather than deleted: a survey that asks what changed since the
    -- last one is asking exactly this.
    removed_at  timestamptz,
    removed_by  text NOT NULL DEFAULT '',
    removed_why text NOT NULL DEFAULT '',

    -- Evidence held elsewhere has to say what it is and where, or it is a tick
    -- in a box.
    CONSTRAINT external_evidence_says_what_and_where CHECK (
        kind <> 'external' OR (external_ref <> '' AND description <> '')
    ),
    CONSTRAINT internal_evidence_names_its_record CHECK (
        kind = 'external' OR ref_id <> ''
    ),
    CONSTRAINT a_withdrawal_says_why CHECK (
        removed_at IS NULL OR removed_why <> ''
    )
);

CREATE INDEX evidence_clause_idx ON quality.evidence (tenant_id, clause_id)
    WHERE removed_at IS NULL;

CREATE TABLE quality.clause_review (
    review_id uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,
    clause_id uuid NOT NULL REFERENCES quality.clause (clause_id),

    verdict text NOT NULL CHECK (verdict IN (
        'met', 'partially_met', 'not_met', 'not_applicable')),
    note    text NOT NULL DEFAULT '',
    capa_id uuid REFERENCES quality.capa (capa_id),

    reviewed_at timestamptz NOT NULL,
    reviewed_by text        NOT NULL CHECK (reviewed_by <> ''),

    -- A gap recorded with nothing to close it is a gap the survey finds in the
    -- same state next year.
    CONSTRAINT a_clause_not_met_names_its_action CHECK (
        verdict <> 'not_met' OR capa_id IS NOT NULL
    ),
    -- "Not applicable" is the verdict that removes a clause from the
    -- assessment, so it is the one that needs a reason.
    CONSTRAINT not_applicable_says_why CHECK (
        verdict <> 'not_applicable' OR note <> ''
    )
);

-- The latest review per clause is what the readiness view reads.
CREATE INDEX clause_review_latest_idx
    ON quality.clause_review (tenant_id, clause_id, reviewed_at DESC);

-- The indicator dictionary (SRS-QMS-010).
CREATE TABLE quality.kpi_definition (
    definition_id uuid PRIMARY KEY,
    tenant_id     uuid NOT NULL,

    code     text    NOT NULL CHECK (code <> ''),
    name     text    NOT NULL CHECK (name <> ''),
    revision integer NOT NULL CHECK (revision > 0),

    numerator   text NOT NULL CHECK (numerator <> ''),
    denominator text NOT NULL CHECK (denominator <> ''),
    unit        text NOT NULL DEFAULT '',

    -- Parts per thousand and an integer. A float target that reads 0.949999 in
    -- one report and 95% in another is an argument in a committee meeting.
    target_permille integer NOT NULL DEFAULT 0 CHECK (target_permille >= 0),
    direction       text    NOT NULL CHECK (direction IN (
        'higher_is_better', 'lower_is_better')),
    frequency text NOT NULL CHECK (frequency IN (
        'daily', 'weekly', 'monthly', 'quarterly', 'annual')),
    owner_id text NOT NULL CHECK (owner_id <> ''),

    effective_from timestamptz NOT NULL,
    superseded_at  timestamptz,

    created_at timestamptz NOT NULL,
    created_by text        NOT NULL CHECK (created_by <> '')
);

-- Versioned, never edited: an indicator changed in place turns its own history
-- into two different measurements plotted on one line.
CREATE UNIQUE INDEX kpi_definition_revision_idx
    ON quality.kpi_definition (tenant_id, code, revision);

CREATE TABLE quality.kpi_value (
    value_id      uuid PRIMARY KEY,
    tenant_id     uuid NOT NULL,
    definition_id uuid NOT NULL
        REFERENCES quality.kpi_definition (definition_id),

    code     text    NOT NULL CHECK (code <> ''),
    revision integer NOT NULL CHECK (revision > 0),

    period_from timestamptz NOT NULL,
    period_to   timestamptz NOT NULL,

    numerator   bigint NOT NULL CHECK (numerator >= 0),
    denominator bigint NOT NULL CHECK (denominator >= 0),
    permille    integer NOT NULL DEFAULT 0 CHECK (permille >= 0),
    unanswerable boolean NOT NULL DEFAULT false,

    source_note text        NOT NULL CHECK (source_note <> ''),
    recorded_at timestamptz NOT NULL,
    recorded_by text        NOT NULL CHECK (recorded_by <> ''),

    CONSTRAINT a_period_has_length CHECK (period_to > period_from),
    -- A rate above 100% is an arithmetic mistake or a definition mistake, and
    -- either way it is not a measurement.
    CONSTRAINT a_rate_does_not_exceed_its_denominator CHECK (
        denominator = 0 OR numerator <= denominator
    ),
    -- "No eligible cases this month" and "we failed every case this month" are
    -- opposite facts, and a zero says the second.
    CONSTRAINT an_unmeasured_period_says_so CHECK (
        (denominator = 0) = unanswerable
    ),
    CONSTRAINT an_unmeasured_period_has_no_value CHECK (
        NOT unanswerable OR permille = 0
    ),
    -- One value per indicator revision per period. A second row would put two
    -- points on the chart for one month.
    UNIQUE (tenant_id, definition_id, period_from, period_to)
);

CREATE INDEX kpi_value_code_idx
    ON quality.kpi_value (tenant_id, code, period_to DESC);

-- Complaints and grievances (SRS-QMS-011).
CREATE TABLE quality.complaint (
    complaint_id uuid PRIMARY KEY,
    tenant_id    uuid NOT NULL,

    reference text NOT NULL,
    kind      text NOT NULL CHECK (kind IN (
        'patient', 'relative', 'visitor', 'staff', 'external')),
    complainant_ref text NOT NULL DEFAULT '',
    patient_id      text NOT NULL DEFAULT '',
    encounter_id    text NOT NULL DEFAULT '',

    category    text NOT NULL CHECK (category <> ''),
    department  text NOT NULL DEFAULT '',
    facility_id text NOT NULL DEFAULT '',
    channel     text NOT NULL DEFAULT '',
    detail      text NOT NULL CHECK (detail <> ''),

    -- Two clocks, not one. A hospital that acknowledges in a day and resolves
    -- in a month is behaving correctly; merging them hides whichever one is
    -- being missed.
    acknowledge_by  timestamptz,
    acknowledged_at timestamptz,
    acknowledged_by text NOT NULL DEFAULT '',
    resolve_by      timestamptz,

    state text NOT NULL CHECK (state IN (
        'received', 'acknowledged', 'investigating', 'resolved', 'closed')),
    outcome text NOT NULL DEFAULT '' CHECK (outcome IN (
        '', 'upheld', 'partially_upheld', 'not_upheld', 'withdrawn')),
    resolution     text NOT NULL DEFAULT '',
    closure_reason text NOT NULL DEFAULT '',

    escalated    boolean NOT NULL DEFAULT false,
    escalated_at timestamptz,

    received_at timestamptz NOT NULL,
    received_by text        NOT NULL CHECK (received_by <> ''),
    closed_at   timestamptz,
    closed_by   text        NOT NULL DEFAULT '',
    version     bigint      NOT NULL DEFAULT 1,

    -- A complaint resolved without the complainant ever being spoken to is a
    -- file closed rather than a grievance handled. Withdrawal is the one
    -- exception: they went away before anybody got to them.
    CONSTRAINT a_resolution_was_acknowledged CHECK (
        state NOT IN ('resolved', 'closed')
        OR outcome = 'withdrawn' OR acknowledged_at IS NOT NULL
    ),
    CONSTRAINT a_resolved_complaint_says_what_was_decided CHECK (
        state NOT IN ('resolved', 'closed')
        OR (outcome <> '' AND resolution <> '')
    ),
    CONSTRAINT a_closed_complaint_says_why CHECK (
        state <> 'closed' OR closure_reason <> ''
    ),
    CONSTRAINT an_escalation_has_a_time CHECK (
        NOT escalated OR escalated_at IS NOT NULL
    )
);

CREATE UNIQUE INDEX complaint_reference_idx
    ON quality.complaint (tenant_id, reference) WHERE reference <> '';
CREATE INDEX complaint_open_idx
    ON quality.complaint (tenant_id, received_at)
    WHERE state <> 'closed';

-- Mortality and morbidity peer review (SRS-QMS-012).
--
-- Always restricted. Peer review is a discussion between clinicians about
-- whether a colleague's care was adequate, and it only happens honestly if it
-- is not readable by everybody with a clinical login.
CREATE TABLE quality.mortality_review (
    review_id uuid PRIMARY KEY,
    tenant_id uuid NOT NULL,

    patient_id   text NOT NULL CHECK (patient_id <> ''),
    encounter_id text NOT NULL DEFAULT '',
    died_at      timestamptz NOT NULL,

    committee_id uuid REFERENCES quality.committee (committee_id),
    meeting_id   uuid REFERENCES quality.committee_meeting (meeting_id),

    classification text NOT NULL DEFAULT '' CHECK (classification IN (
        '', 'expected', 'unexpected', 'potentially_preventable',
        'preventable')),
    findings        text   NOT NULL DEFAULT '',
    learning_points text   NOT NULL DEFAULT '',
    capa_ids        uuid[] NOT NULL DEFAULT '{}',

    state text NOT NULL CHECK (state IN ('open', 'complete')),

    opened_at    timestamptz NOT NULL,
    opened_by    text        NOT NULL CHECK (opened_by <> ''),
    completed_at timestamptz,
    completed_by text        NOT NULL DEFAULT '',
    version      bigint      NOT NULL DEFAULT 1,

    -- A peer review signed by one person is not a peer review.
    CONSTRAINT a_peer_review_names_its_meeting CHECK (
        state <> 'complete' OR (meeting_id IS NOT NULL AND findings <> '')
    ),
    -- A hospital that has written down that it could have done better and done
    -- nothing. COALESCE because array_length of an empty array is NULL, and a
    -- CHECK that evaluates to NULL passes.
    CONSTRAINT a_preventable_death_raises_an_action CHECK (
        state <> 'complete'
        OR classification NOT IN ('potentially_preventable', 'preventable')
        OR COALESCE(array_length(capa_ids, 1), 0) > 0
    )
);

CREATE UNIQUE INDEX mortality_review_patient_idx
    ON quality.mortality_review (tenant_id, patient_id, died_at);
CREATE INDEX mortality_review_open_idx
    ON quality.mortality_review (tenant_id, state) WHERE state = 'open';
