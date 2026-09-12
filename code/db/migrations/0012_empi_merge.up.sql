-- 0012 Patient merge journal and duplicate review queue (SRS-EMPI-004/005/006).
--
-- Two tables, and both exist because merging is irreversible unless somebody
-- wrote down exactly what it did.
--
-- A merge that should not have happened produces a chart that reads as
-- coherent: two people's allergies, medications and diagnoses sit together and
-- nothing looks broken. It is found by a reaction, not by a report. So the
-- losing record is never deleted, its identifiers are moved rather than
-- dropped, and merge_journal records which row moved, from whom, and what its
-- status was before — because an unmerge has to put all of it back, and
-- re-deriving that from current state is impossible once a second merge has
-- touched the same identifiers.
--
-- duplicate_candidate is where "thresholds route to manual review"
-- (SRS-EMPI-004) actually routes to. Without it, a clerk who acknowledges a
-- probable duplicate and registers anyway has made that call alone, at a busy
-- desk, with a patient waiting, and nobody looks at the pair again.
--
-- Trace: SRS-EMPI-004, SRS-EMPI-005, SRS-EMPI-006.
--
-- Rollback: drops the journal and the queue. Dropping the journal makes every
--   existing merge permanent — the information needed to reverse one exists
--   nowhere else. Restore rather than run this anywhere with data.
-- Reconciliation: none for the forward direction; these tables are new.

CREATE TABLE empi.merge_journal (
    merge_id      uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    -- The survivor keeps its own patient_id. A merge never changes an internal
    -- identifier; that is the whole of SRS-EMPI-002.
    survivor_id   uuid        NOT NULL REFERENCES empi.patient (patient_id),
    merged_id     uuid        NOT NULL REFERENCES empi.patient (patient_id),
    CONSTRAINT merge_is_between_two_records CHECK (survivor_id <> merged_id),

    -- What the losing record was before it lost. An unmerge restores this
    -- rather than defaulting to active, which would silently confirm an
    -- identity nobody verified.
    merged_previous_status text NOT NULL CHECK (merged_previous_status IN (
                               'candidate', 'active', 'inactive')),

    reason        text        NOT NULL CHECK (reason <> ''),
    performed_by  text        NOT NULL CHECK (performed_by <> ''),
    performed_at  timestamptz NOT NULL,

    -- One row per identifier that moved: its id, who it came from, and the
    -- status and primary flag it held before.
    moved_identifiers jsonb   NOT NULL DEFAULT '[]'::jsonb,
    -- The survivor inherited a deceased record it did not have, so an unmerge
    -- takes it back off.
    carried_deceased  boolean NOT NULL DEFAULT false,

    undone        boolean     NOT NULL DEFAULT false,
    undone_by     text        NOT NULL DEFAULT '',
    undone_at     timestamptz,
    undo_reason   text        NOT NULL DEFAULT '',
    CONSTRAINT reversals_explain_themselves CHECK (
        NOT undone OR (undone_at IS NOT NULL AND undo_reason <> '' AND undone_by <> ''))
);

-- A record may lose at most one merge that still stands. Two standing merges
-- of the same loser would give it two survivors, and resolution would pick
-- whichever row came back first.
CREATE UNIQUE INDEX merge_journal_active_loser_key
    ON empi.merge_journal (tenant_id, merged_id)
    WHERE NOT undone;

-- "Has this survivor been merged into since?", which an unmerge has to answer.
CREATE INDEX merge_journal_survivor_idx
    ON empi.merge_journal (tenant_id, survivor_id, performed_at DESC);

CREATE TABLE empi.duplicate_candidate (
    candidate_id  uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    -- Stored in a canonical order, lower identifier first, so the same pair
    -- discovered from either side is one row. Without it a busy desk produces
    -- a queue full of A-B and B-A.
    patient_a_id  uuid        NOT NULL REFERENCES empi.patient (patient_id),
    patient_b_id  uuid        NOT NULL REFERENCES empi.patient (patient_id),
    CONSTRAINT candidate_pairs_two_records CHECK (patient_a_id < patient_b_id),

    score         numeric(4,3) NOT NULL CHECK (score BETWEEN 0 AND 1),
    outcome       text        NOT NULL CHECK (outcome IN ('review', 'probable', 'conflict')),
    status        text        NOT NULL CHECK (status IN ('open', 'merged', 'dismissed')),

    -- What surfaced the pair: a registration, a bulk scan, an operator. It
    -- matters when deciding how much to trust the score.
    detected_by   text        NOT NULL CHECK (detected_by <> ''),
    detected_at   timestamptz NOT NULL,
    reviewed_by   text        NOT NULL DEFAULT '',
    reviewed_at   timestamptz,
    -- Explains a dismissal, or names the merge that resolved it.
    resolution    text        NOT NULL DEFAULT '',
    CONSTRAINT closed_candidates_explain_themselves CHECK (
        status = 'open' OR (reviewed_at IS NOT NULL AND resolution <> ''))
);

-- One open candidate per pair. Re-detecting a pair that is already queued must
-- not queue it again, and re-detecting one that was dismissed must not either:
-- a decision already taken is not a new question.
CREATE UNIQUE INDEX duplicate_candidate_pair_key
    ON empi.duplicate_candidate (tenant_id, patient_a_id, patient_b_id);

-- The review worklist: strongest first, because that is the pair most likely to
-- be one person.
CREATE INDEX duplicate_candidate_open_idx
    ON empi.duplicate_candidate (tenant_id, score DESC, detected_at)
    WHERE status = 'open';
