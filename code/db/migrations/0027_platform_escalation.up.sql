-- 0027 Durable clinical escalation (SRS-OPSNFR-003, SRS-OPSAPI-007, SRS-FAC-012).
--
-- Wave 1 escalated by calculation. `EscalationPolicy.DueEscalations(notifiedAt,
-- now)` answers how many times a critical result should have escalated by now,
-- which is the correct answer to a question nobody was acting on: nothing was
-- stored, nothing was delivered, and no recipient was ever named. A derived
-- count survives a restart trivially, because there was nothing to lose.
--
-- SRS-OPSNFR-003 is explicit that this is not enough — "shall persist
-- notifications until acknowledged/escalated/closed", verified by "restart does
-- not lose pending escalation" — and Wave 2 puts seven families behind the same
-- mechanism. These tables are what makes the escalation a thing that exists
-- between processes rather than a number a screen would have shown.
--
-- Trace: SRS-OPSNFR-003, SRS-OPSAPI-007, SRS-FAC-012, SRS-ER-016, SRS-CLN-012.
--
-- Rollback: drops the schema, and with it every escalation in flight. A notice
-- that was pending at the moment of the rollback is not recoverable from
-- anywhere else — the owning context recorded that the result was critical, not
-- that anybody was told about it — so rolling this back during an incident
-- silently un-tells a chain of clinicians. Do it only from a maintenance window
-- with no pending rows: `SELECT count(*) FROM platform_escalation.notice WHERE
-- state = 'pending'` must be zero first, and the previous version of the
-- application must already be the one running.
--
-- Reconciliation: during the rollout window, a new version raising notices and
-- an old version that cannot see them are the two states to reason about. The
-- old version escalates by calculation (clinical.EscalationPolicy) and touches
-- none of these tables, so nothing it writes is lost or contradicted — it
-- simply does not participate. The reverse direction is the one to watch: a
-- notice raised by the new version and then served by an old replica will not
-- be delivered or advanced by that replica, and it stays pending until a new
-- replica sweeps it. That is why the driver's sweep is idempotent and
-- time-based rather than event-driven: a notice missed for the length of a
-- deployment is late, not lost.

CREATE SCHEMA IF NOT EXISTS platform_escalation;

-- The escalation matrix (SRS-FAC-012), by facility and kind.
--
-- Both, because a critical potassium and a medical gas alarm go to different
-- people by different routes, and neither chain is a sensible default for the
-- other. A facility with no matrix for a kind falls back to the tenant's, and a
-- tenant with none falls back to nothing — which the application refuses to
-- raise against rather than inventing a recipient.
CREATE TABLE platform_escalation.matrix (
    matrix_id   uuid        PRIMARY KEY,
    tenant_id   uuid        NOT NULL,
    -- Empty string rather than NULL for a tenant-wide matrix, so the unique
    -- index below treats "no facility" as one value rather than as many
    -- distinct NULLs that would each admit a duplicate.
    facility_id text        NOT NULL DEFAULT '',
    kind        text        NOT NULL CHECK (kind <> ''),
    created_at  timestamptz NOT NULL,
    updated_at  timestamptz NOT NULL
);

CREATE UNIQUE INDEX matrix_scope_idx
    ON platform_escalation.matrix (tenant_id, facility_id, kind);

-- One rung of a chain.
CREATE TABLE platform_escalation.rung (
    matrix_id uuid    NOT NULL
        REFERENCES platform_escalation.matrix (matrix_id) ON DELETE CASCADE,
    -- Counts from zero, and zero is whoever was already responsible. A chain
    -- that starts at one begins by telling somebody else's boss.
    level     integer NOT NULL CHECK (level >= 0),
    note      text    NOT NULL DEFAULT '',
    PRIMARY KEY (matrix_id, level)
);

-- Who a rung tells. A named person or a duty role, never both: at three in the
-- morning "the named consultant" and "whoever is on duty" are different people,
-- and a row holding both cannot say which it meant.
CREATE TABLE platform_escalation.rung_recipient (
    matrix_id   uuid    NOT NULL,
    level       integer NOT NULL,
    -- Ordinal only to keep the set stable and replayable; recipients on one
    -- rung are told together, never in turn.
    ordinal     integer NOT NULL CHECK (ordinal >= 0),
    user_id     text    NOT NULL DEFAULT '',
    role        text    NOT NULL DEFAULT '',
    facility_id text    NOT NULL DEFAULT '',

    PRIMARY KEY (matrix_id, level, ordinal),
    FOREIGN KEY (matrix_id, level)
        REFERENCES platform_escalation.rung (matrix_id, level) ON DELETE CASCADE,

    -- The invariant, in the schema rather than only in Go. A row that named
    -- both or neither would be one the application refuses to load and the
    -- database was happy to store, which is how a chain acquires a rung that
    -- reaches nobody.
    CONSTRAINT recipient_is_a_person_or_a_role
        CHECK ((user_id <> '') <> (role <> ''))
);

-- The notice itself: the row that has to survive a restart.
CREATE TABLE platform_escalation.notice (
    notice_id    uuid        PRIMARY KEY,
    tenant_id    uuid        NOT NULL,

    subject_kind text        NOT NULL CHECK (subject_kind <> ''),
    subject_id   text        NOT NULL CHECK (subject_id <> ''),
    patient_id   text        NOT NULL DEFAULT '',
    facility_id  text        NOT NULL DEFAULT '',

    summary      text        NOT NULL CHECK (summary <> ''),

    state        text        NOT NULL
        CHECK (state IN ('pending', 'acknowledged', 'closed', 'exhausted')),
    level        integer     NOT NULL CHECK (level >= 0),

    raised_at          timestamptz NOT NULL,
    last_escalated_at  timestamptz NOT NULL,
    acknowledged_by    text        NOT NULL DEFAULT '',
    acknowledged_at    timestamptz,
    closed_reason      text        NOT NULL DEFAULT '',
    updated_at         timestamptz NOT NULL,

    -- An acknowledged notice names who acknowledged it and when. Enforced here
    -- because the acknowledgement is the only evidence anybody took the
    -- notice, and a half-written one is indistinguishable from a bug.
    CONSTRAINT acknowledged_notices_name_a_person CHECK (
        state <> 'acknowledged'
        OR (acknowledged_by <> '' AND acknowledged_at IS NOT NULL)
    ),
    CONSTRAINT closed_notices_carry_a_reason CHECK (
        state <> 'closed' OR closed_reason <> ''
    )
);

-- One notice per subject per tenant. This is the idempotency key, and it is a
-- constraint rather than a convention because raising the same notice twice
-- happens on every retry, replay and restart — and two chains racing each other
-- to the same consultant is the outcome.
CREATE UNIQUE INDEX notice_subject_idx
    ON platform_escalation.notice (tenant_id, subject_kind, subject_id);

-- What the driver sweeps: only the notices that can still escalate. Partial, so
-- the index stays the size of the outstanding work rather than of the history.
CREATE INDEX notice_pending_idx
    ON platform_escalation.notice (last_escalated_at)
    WHERE state = 'pending';

-- Every attempt to tell somebody, successful or not.
--
-- Append-only by intent. The question an incident review asks is why the third
-- rung was reached, and a table that recorded only successful deliveries
-- answers it with silence.
CREATE TABLE platform_escalation.delivery (
    delivery_id uuid        PRIMARY KEY,
    notice_id   uuid        NOT NULL
        REFERENCES platform_escalation.notice (notice_id) ON DELETE CASCADE,
    level       integer     NOT NULL CHECK (level >= 0),
    user_id     text        NOT NULL DEFAULT '',
    role        text        NOT NULL DEFAULT '',
    facility_id text        NOT NULL DEFAULT '',
    channel     text        NOT NULL CHECK (channel <> ''),
    -- Empty when it went. A failure does not stop the chain: the next rung is
    -- the remedy for a recipient who cannot be reached.
    error       text        NOT NULL DEFAULT '',
    delivered_at timestamptz NOT NULL
);

CREATE INDEX delivery_notice_idx ON platform_escalation.delivery (notice_id, delivered_at);
