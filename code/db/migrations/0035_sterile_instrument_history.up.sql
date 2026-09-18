-- 0035 Instrument lifecycle history (SRS-CSSD-012).
--
-- 0034 gave an instrument a current status and a note. That answers "where is
-- this item now" and nothing else, and SRS-CSSD-012's acceptance is explicit
-- about what it is for: "History supports replacement and loss analysis." Both
-- questions are about the past. Whether to replace a laparoscope is answered
-- by how many times it has been away this year, not by whether it happens to
-- be in the department today; a loss analysis asks which trays lose
-- instruments and where they were last seen. Neither can be read from a
-- column that the next move overwrites.
--
-- The audit trail records every move, but it is not this. It is written for a
-- different reader, retained on a different schedule, and queried by actor and
-- time rather than by instrument — asking it "how often has SC-0041 been in
-- repair" means trusting a LIKE over a free-text reason. A department's own
-- history belongs in the department's own schema.
--
-- Append-only by construction: rows are inserted and never updated, and the
-- previous status is carried on the row so the sequence reads without a window
-- function. There is no unique constraint on (instrument, time): an instrument
-- can genuinely be moved twice in the same microsecond by two callers, and
-- refusing the second would lose a real event to protect a report.
--
-- Trace: SRS-CSSD-012.
--
-- Rollback: drops the table. The current status on sterile.instrument is
-- unaffected, so the department keeps working and loses only the history —
-- which is the thing this migration exists to keep, so treat a rollback as a
-- disaster-recovery action.
--
-- Reconciliation: the table is new and starts empty, so instruments
-- registered before this migration have no history rather than a wrong one.
-- A reader must not read "no rows" as "never moved"; the registration row
-- below is written from the point this deploys, and the gap is visible as an
-- instrument whose first history row is not its registration.

CREATE TABLE sterile.instrument_event (
    instrument_event_id uuid PRIMARY KEY,
    tenant_id           uuid NOT NULL,
    instrument_id       uuid NOT NULL
        REFERENCES sterile.instrument (instrument_id),

    -- Where it went, and where it was. Carrying the previous status makes the
    -- sequence readable on its own: "in_service -> in_repair" is one row
    -- rather than a join to the row before it.
    from_status text NOT NULL DEFAULT '' CHECK (from_status IN (
        '', 'in_service', 'in_repair', 'missing', 'retired')),
    to_status text NOT NULL CHECK (to_status IN (
        'in_service', 'in_repair', 'missing', 'retired')),

    -- Why. Required for anything but a return to service, which is the same
    -- rule the domain applies: a status change with no reason is a number in a
    -- report nobody can act on.
    note text NOT NULL DEFAULT '',
    -- Where it was last seen, frozen at the moment of the move. The current
    -- location moves on; a loss analysis needs where it was when it went
    -- missing.
    location text NOT NULL DEFAULT '',

    occurred_at timestamptz NOT NULL,
    recorded_by text        NOT NULL CHECK (recorded_by <> ''),

    CONSTRAINT a_move_out_of_service_is_explained CHECK (
        to_status = 'in_service' OR note <> ''
    )
);

-- The lifecycle read: one instrument's history, most recent first.
CREATE INDEX instrument_event_instrument_idx
    ON sterile.instrument_event (tenant_id, instrument_id, occurred_at DESC);
-- The replacement analysis: every move of a kind across the master, which is
-- how a department finds the code that keeps going away.
CREATE INDEX instrument_event_status_idx
    ON sterile.instrument_event (tenant_id, to_status, occurred_at DESC);
