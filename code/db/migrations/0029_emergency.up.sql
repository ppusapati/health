-- 0029 The Emergency Department (SRS-ER-001 … 018).
--
-- The first Wave-2 clinical family. It keeps no patient and no episode of its
-- own: an emergency visit is the detail of a Wave-1 encounter, because a
-- department with a second patient record is a department whose allergies
-- disagree with the ward's.
--
-- Two shapes here are unusual and deliberate.
--
-- The event table stores `occurred_at` and `recorded_at` separately, and the
-- timeline sorts on the first. A resuscitation is written up in arrears more
-- often than not, and the gap between the two is the only thing distinguishing
-- a contemporaneous record from a reconstruction.
--
-- Nothing stores a door-to-triage or door-to-doctor interval. SRS-ER-006 says
-- the dashboard "derives times from immutable events", and a stored interval
-- is a number somebody can be asked to improve without anything happening to a
-- patient.
--
-- Trace: SRS-ER-001 … SRS-ER-018, SRS-OPSNFR-003 (pathway notification).
--
-- Rollback: drops the schema. Every emergency visit, triage assessment and
-- resuscitation timeline goes with it, and none of it is recoverable from the
-- encounter it hangs off — the encounter records that the patient was in the
-- department, not what was done to them there. A medico-legal case loses its
-- statutory record. Treat as a disaster-recovery action, never a deployment
-- step.
--
-- Reconciliation: the tables are new, so the previous version writes nothing
-- here and sees nothing missing. The direction to watch is the encounter: a
-- visit created by the new version points at an encounter the old version
-- serves happily and shows no emergency detail for. That is a display gap
-- during the rollout window rather than a correctness problem, and it closes
-- when every replica is new.

CREATE SCHEMA IF NOT EXISTS emergency;

CREATE TABLE emergency.visit (
    visit_id     uuid        PRIMARY KEY,
    tenant_id    uuid        NOT NULL,
    -- The Wave-1 encounter this is the emergency detail of.
    encounter_id uuid        NOT NULL,
    -- Nullable, because SRS-ER-004 requires care to proceed without
    -- demographic completeness. The CHECK below is what stops that becoming a
    -- visit nobody can attach to anyone.
    patient_id   uuid,
    facility_id  text        NOT NULL DEFAULT '',

    arrival_mode text        NOT NULL CHECK (arrival_mode IN (
                     'walk_in', 'ambulance', 'referral', 'transfer', 'unspecified')),
    -- What the patient or the crew said, in their words. Never coded: the
    -- first sentence is evidence, and coding it at the door loses the
    -- difference between "crushing chest pain" and "indigestion".
    chief_complaint text     NOT NULL CHECK (chief_complaint <> ''),
    arrived_at   timestamptz NOT NULL,

    unidentified   boolean   NOT NULL DEFAULT false,
    -- Kept after identification. A record that renamed its own history would
    -- make the resuscitation timeline refer to somebody who, as far as the
    -- chart is concerned, was never there.
    temporary_name text      NOT NULL DEFAULT '',

    medico_legal     boolean NOT NULL DEFAULT false,
    medico_legal_ref text    NOT NULL DEFAULT '',

    status   text NOT NULL CHECK (status IN (
                 'arrived', 'triaged', 'in_treatment', 'observation', 'disposed')),
    location text NOT NULL DEFAULT '',

    disposition       text        NOT NULL DEFAULT '',
    disposed_at       timestamptz,
    disposition_note  text        NOT NULL DEFAULT '',
    receiving_service text        NOT NULL DEFAULT '',

    observation_started_at timestamptz,
    observation_ends_at    timestamptz,

    created_by text        NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL,
    version    bigint      NOT NULL DEFAULT 1,

    -- A visit names its patient or says it cannot yet. The third state — no
    -- patient and not flagged unidentified — is a row nobody can attach to
    -- anyone, which is how a resuscitation record becomes an orphan.
    CONSTRAINT visit_has_a_patient_or_admits_it_does_not CHECK (
        patient_id IS NOT NULL OR (unidentified AND temporary_name <> '')
    ),
    CONSTRAINT disposed_visits_name_an_outcome CHECK (
        status <> 'disposed' OR (disposition <> '' AND disposed_at IS NOT NULL)
    ),
    -- An observation with no end is an admission nobody called an admission,
    -- and SRS-ER-014's "duration is reportable" needs both ends.
    CONSTRAINT observation_stays_have_a_review_time CHECK (
        status <> 'observation'
        OR (observation_started_at IS NOT NULL AND observation_ends_at IS NOT NULL)
    )
);

CREATE INDEX visit_encounter_idx ON emergency.visit (tenant_id, encounter_id);
CREATE INDEX visit_patient_idx ON emergency.visit (tenant_id, patient_id);
-- The board's own index: the open department, most recently arrived last.
-- Partial, because the board is today's patients and the table is every
-- patient the department has ever seen.
CREATE INDEX visit_open_idx
    ON emergency.visit (tenant_id, facility_id, arrived_at)
    WHERE status <> 'disposed';

CREATE TABLE emergency.triage (
    triage_id uuid        PRIMARY KEY,
    tenant_id uuid        NOT NULL,
    visit_id  uuid        NOT NULL REFERENCES emergency.visit (visit_id) ON DELETE CASCADE,

    -- The scale travels with the assessment. An ESI 2 read under Manchester is
    -- a different patient, and a level with no scale is a number nobody can
    -- read back.
    scale_name    text    NOT NULL CHECK (scale_name <> ''),
    scale_version text    NOT NULL DEFAULT '',
    acuity_code   text    NOT NULL CHECK (acuity_code <> ''),
    acuity_rank   integer NOT NULL CHECK (acuity_rank >= 1),

    -- The inputs, kept as recorded. "Acuity, inputs, author and time are
    -- retained" is the criterion, and a score with its inputs discarded cannot
    -- be reviewed. Nullable throughout: a missing observation is recorded as
    -- missing rather than as zero.
    respiratory_rate  integer,
    heart_rate        integer,
    systolic_bp       integer,
    oxygen_saturation integer,
    temperature       double precision,
    pain_score        integer CHECK (pain_score IS NULL OR pain_score BETWEEN 0 AND 10),
    consciousness     text    NOT NULL DEFAULT '',
    red_flags         text[]  NOT NULL DEFAULT '{}',

    -- What the department required and did not get. Flagged rather than
    -- refused: a nurse with a crashing patient does not stop for a
    -- temperature, and refusing the assessment produces a fabricated one.
    missing_fields text[] NOT NULL DEFAULT '{}',

    note        text        NOT NULL DEFAULT '',
    assessed_by text        NOT NULL CHECK (assessed_by <> ''),
    assessed_at timestamptz NOT NULL
);

CREATE INDEX triage_visit_idx ON emergency.triage (tenant_id, visit_id, assessed_at DESC);

-- A clinician moving a patient up or down the queue (SRS-ER-003).
--
-- Its own table rather than a column, because an override is a decision with
-- an author and a time, and the sequence of them on one visit is what a review
-- reads.
CREATE TABLE emergency.priority_override (
    override_id uuid        PRIMARY KEY,
    tenant_id   uuid        NOT NULL,
    visit_id    uuid        NOT NULL
        REFERENCES emergency.visit (visit_id) ON DELETE CASCADE,
    acuity_rank integer     NOT NULL CHECK (acuity_rank >= 1),
    -- Required in both directions. Moving somebody down is the decision argued
    -- about afterwards.
    reason      text        NOT NULL CHECK (reason <> ''),
    overridden_by text      NOT NULL CHECK (overridden_by <> ''),
    overridden_at timestamptz NOT NULL
);

CREATE INDEX override_visit_idx
    ON emergency.priority_override (tenant_id, visit_id, overridden_at DESC);

CREATE TABLE emergency.pathway (
    pathway_id uuid        PRIMARY KEY,
    tenant_id  uuid        NOT NULL,
    visit_id   uuid        NOT NULL REFERENCES emergency.visit (visit_id) ON DELETE CASCADE,

    kind  text NOT NULL CHECK (kind IN (
              'resuscitation', 'trauma', 'stroke', 'stemi', 'sepsis', 'other', 'unknown')),
    -- Names a locally defined pathway. Required for 'other', or the record
    -- cannot say which protocol was run.
    label text NOT NULL DEFAULT '',

    activated_at timestamptz NOT NULL,
    activated_by text        NOT NULL CHECK (activated_by <> ''),
    -- Who was called. The commonest failure in a time-critical pathway is not
    -- that nobody activated it — it is that the team nobody called did not
    -- come.
    notified_team text       NOT NULL DEFAULT '',
    -- The durable notice carrying the call (SRS-OPSNFR-003). Empty where the
    -- department activates by shouting across the resus room, which is a real
    -- arrangement rather than a defect.
    escalation_notice_id uuid,

    stood_down_at     timestamptz,
    stood_down_reason text NOT NULL DEFAULT '',

    CONSTRAINT local_pathways_are_named CHECK (kind <> 'other' OR label <> ''),
    -- A department's false-activation rate is a quality measure, and one
    -- nobody can read from a stand-down with no reason.
    CONSTRAINT stand_downs_carry_a_reason CHECK (
        stood_down_at IS NULL OR stood_down_reason <> ''
    )
);

CREATE INDEX pathway_visit_idx ON emergency.pathway (tenant_id, visit_id, activated_at);
CREATE INDEX pathway_active_idx
    ON emergency.pathway (tenant_id, visit_id)
    WHERE stood_down_at IS NULL;

-- One target of a pathway, stored per activation rather than looked up.
--
-- The same reason the reference range is stored on an observation: guidelines
-- are revised, and measuring a two-year-old activation against today's target
-- would reinterpret history.
CREATE TABLE emergency.pathway_target (
    pathway_id    uuid    NOT NULL
        REFERENCES emergency.pathway (pathway_id) ON DELETE CASCADE,
    code          text    NOT NULL CHECK (code <> ''),
    label         text    NOT NULL DEFAULT '',
    within_seconds bigint NOT NULL DEFAULT 0 CHECK (within_seconds >= 0),
    PRIMARY KEY (pathway_id, code)
);

CREATE TABLE emergency.event (
    event_id  uuid NOT NULL,
    tenant_id uuid NOT NULL,
    visit_id  uuid NOT NULL REFERENCES emergency.visit (visit_id) ON DELETE CASCADE,

    kind text NOT NULL CHECK (kind IN (
             'arrival', 'triage', 'clinician_seen', 'pathway_activated', 'milestone',
             'airway', 'cpr', 'defibrillation', 'fluid', 'drug', 'procedure',
             'observation', 'disposition', 'unknown')),
    -- What was done. Free text on purpose: a resuscitation record that only
    -- accepted coded entries would be one with things missing from it.
    detail text NOT NULL CHECK (detail <> ''),

    -- When it happened to the patient, and when somebody typed it. The
    -- timeline sorts on the first; the gap between them is what marks an entry
    -- as written up rather than recorded.
    occurred_at timestamptz NOT NULL,
    recorded_at timestamptz NOT NULL,
    -- Breaks ties within a minute. A defibrillation and the rhythm check
    -- before it are frequently recorded at the same minute, and their order is
    -- the clinically interesting part.
    sequence integer NOT NULL DEFAULT 0,

    actor_id text    NOT NULL CHECK (actor_id <> ''),
    late     boolean NOT NULL DEFAULT false,

    pathway_id uuid REFERENCES emergency.pathway (pathway_id) ON DELETE SET NULL,

    -- A medication given before the order existed, under a standing order
    -- (SRS-ER-009). The protocol is required, because without one it is an
    -- unordered administration rather than the exception the requirement
    -- carves out.
    protocol_id          text NOT NULL DEFAULT '',
    needs_reconciliation boolean NOT NULL DEFAULT false,
    reconciled_order_id  text NOT NULL DEFAULT '',

    PRIMARY KEY (event_id),
    CONSTRAINT pre_order_administrations_name_their_protocol CHECK (
        NOT needs_reconciliation OR protocol_id <> ''
    )
);

CREATE INDEX event_timeline_idx
    ON emergency.event (tenant_id, visit_id, occurred_at, sequence);

-- The department's debt: administrations still owed an order. Partial, because
-- the interesting set is small and the table is every event in every
-- resuscitation.
CREATE INDEX event_unreconciled_idx
    ON emergency.event (tenant_id, visit_id)
    WHERE needs_reconciliation AND reconciled_order_id = '';
