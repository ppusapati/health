-- 0015 Proposed demographic changes (SRS-EMPI-012, SRS-EMPI-017).
--
-- Two requirements meet in one table because they are the same shape: a change
-- somebody wants made to a patient's demographics, which is not made until
-- somebody with the authority to make it agrees.
--
-- SRS-EMPI-012 is the machine case. A national registry or a payer file returns
-- a birth date that differs from the one on file. Writing it is the obvious
-- implementation and the wrong one: the feed may be describing a different
-- person, or may itself be wrong, and by the time anybody notices, the trusted
-- value is gone and nothing records what it was.
--
-- SRS-EMPI-017 is the human case. A patient says their name is misspelled. The
-- correction is applied without erasing what the record said before, because a
-- result filed last month was filed against the old value.
--
-- Nothing here is ever deleted, including rejections. That a wrong value was
-- offered and refused is exactly what somebody needs when the same wrong value
-- arrives a third time from the same feed.
--
-- Trace: SRS-EMPI-012, SRS-EMPI-017, SRS-EMPI-014 (reviewing a proposal is a
--   read of demographic values and is audited as one).
-- Rollback: drops both tables. Open proposals are lost, so the conflicts they
--   held stop being visible — and the next feed carrying the same values finds
--   no record that they were already refused. Export before dropping.
-- Reconciliation: none for the forward direction; these tables are new. Rows
--   the previous version writes during the rollout window are ordinary patient
--   updates and are unaffected.

CREATE TABLE empi.demographic_proposal (
    proposal_id   uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    patient_id    uuid        NOT NULL,

    origin        text        NOT NULL CHECK (origin IN (
                      'external_source', 'correction_request')),
    -- Which feed, or which person. SRS-EMPI-012 is about reconciling
    -- disagreements between sources; one with no source reconciles against
    -- nothing.
    source        text        NOT NULL CHECK (source <> ''),
    proposed_by   text        NOT NULL CHECK (proposed_by <> ''),
    reason        text        NOT NULL DEFAULT '',

    status        text        NOT NULL CHECK (status IN (
                      'open', 'accepted', 'rejected', 'withdrawn', 'superseded')),

    -- The record's version when the proposal was raised. A reviewer decides on
    -- the comparison they were shown; if the record has moved since, accepting
    -- would overwrite a value nobody reviewed.
    patient_version bigint    NOT NULL,

    proposed_at     timestamptz NOT NULL,
    resolved_at     timestamptz,
    resolved_by     text        NOT NULL DEFAULT '',
    resolution_note text        NOT NULL DEFAULT '',

    -- A decision with no decider is not a decision anybody can be asked about.
    CONSTRAINT resolved_proposals_name_their_decider CHECK (
        status = 'open'
        OR (resolved_at IS NOT NULL AND resolved_by <> '')
    ),
    -- Rejecting everything is the decision that needs explaining most: the same
    -- value will arrive again, and the next reviewer needs to know this one was
    -- considered rather than missed.
    CONSTRAINT rejections_explain_themselves CHECK (
        status <> 'rejected' OR resolution_note <> ''
    ),
    -- A correction request is a person asking for something, and the reason is
    -- what a reviewer is actually deciding on.
    CONSTRAINT correction_requests_state_a_reason CHECK (
        origin <> 'correction_request' OR reason <> ''
    )
);

-- The reconciliation worklist, which is the query this table exists to serve.
-- Partial, because resolved proposals are history rather than work.
CREATE INDEX demographic_proposal_open_idx
    ON empi.demographic_proposal (tenant_id, proposed_at)
    WHERE status = 'open';

-- Everything ever proposed about one patient, in order. The audit question.
CREATE INDEX demographic_proposal_patient_idx
    ON empi.demographic_proposal (tenant_id, patient_id, proposed_at DESC);

-- One open proposal per patient per source.
--
-- A feed that runs nightly and keeps disagreeing must not add an item to the
-- queue every night: fifty identical items are not fifty conflicts, they are
-- one conflict and a reviewer who has stopped reading the queue. The
-- application refreshes the existing open proposal instead.
CREATE UNIQUE INDEX demographic_proposal_one_open_per_source_key
    ON empi.demographic_proposal (tenant_id, patient_id, source)
    WHERE status = 'open';

CREATE TABLE empi.demographic_proposal_field (
    proposal_id    uuid    NOT NULL
                       REFERENCES empi.demographic_proposal (proposal_id)
                       ON DELETE CASCADE,
    tenant_id      uuid    NOT NULL,
    field          text    NOT NULL CHECK (field IN (
                       'family_name', 'given_name', 'birth_date',
                       'sex', 'phone', 'email', 'address')),

    -- What was on file when the proposal was raised, stored rather than looked
    -- up at review time: the reviewer has to see the comparison the proposer
    -- saw, and a value re-read later may have changed for an unrelated reason.
    current_value  text    NOT NULL,
    proposed_value text    NOT NULL,

    -- Null while open, then the reviewer's per-field decision. Per field
    -- because a registry that agrees on the name and disagrees on the birth
    -- date is offering one correction and one conflict, and a reviewer must be
    -- able to take the first without the second.
    accepted       boolean,

    PRIMARY KEY (proposal_id, field),

    -- Proposing the value already on file is a no-op somebody has to close.
    CONSTRAINT proposals_change_something CHECK (current_value <> proposed_value)
);

CREATE INDEX demographic_proposal_field_tenant_idx
    ON empi.demographic_proposal_field (tenant_id, proposal_id);
