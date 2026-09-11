-- 0003 Platform data: transactional outbox, consumer inbox, audit trail.
--
-- The outbox row is written in the SAME transaction as the aggregate change,
-- which is what guarantees there is no state change without its event and no
-- event without its state change (SRS-API-008, Domain/Data spec §8.2).
--
-- The inbox exists because the publisher may deliver more than once: every
-- side-effecting consumer deduplicates on event_id.
--
-- Audit is append-oriented and deliberately has no UPDATE/DELETE path in the
-- application (Domain/Data spec §12, SRS-SEC-004, SRS-NFR-011).

CREATE TABLE platform_data.outbox_event (
    event_id        uuid        PRIMARY KEY,
    event_type      text        NOT NULL,
    schema_version  integer     NOT NULL CHECK (schema_version > 0),
    occurred_at     timestamptz NOT NULL,
    published_at    timestamptz,
    tenant_id       uuid        NOT NULL,
    source          text        NOT NULL,
    aggregate_type  text        NOT NULL,
    aggregate_id    text        NOT NULL,
    correlation_id  text        NOT NULL,
    causation_id    text        NOT NULL DEFAULT '',
    actor           text        NOT NULL DEFAULT '',
    payload         jsonb       NOT NULL DEFAULT '{}'::jsonb,
    attempts        integer     NOT NULL DEFAULT 0,
    last_error      text
);

-- The publisher claims the oldest unpublished rows; a partial index keeps that
-- scan proportional to the backlog rather than to total history.
CREATE INDEX outbox_event_unpublished_idx
    ON platform_data.outbox_event (occurred_at, event_id)
    WHERE published_at IS NULL;

CREATE INDEX outbox_event_tenant_idx
    ON platform_data.outbox_event (tenant_id, occurred_at);

CREATE TABLE platform_data.inbox_message (
    consumer     text        NOT NULL,
    event_id     uuid        NOT NULL,
    tenant_id    uuid        NOT NULL,
    processed_at timestamptz NOT NULL,
    PRIMARY KEY (consumer, event_id)
);

CREATE TABLE platform_data.audit_record (
    audit_id       uuid        PRIMARY KEY,
    tenant_id      uuid        NOT NULL,
    actor_id       text        NOT NULL,
    action         text        NOT NULL,
    resource_type  text        NOT NULL DEFAULT '',
    resource_id    text        NOT NULL DEFAULT '',
    outcome        text        NOT NULL CHECK (outcome IN ('success', 'denied', 'failure')),
    reason         text        NOT NULL DEFAULT '',
    purpose_of_use text        NOT NULL DEFAULT '',
    break_glass    boolean     NOT NULL DEFAULT false,
    correlation_id text        NOT NULL,
    request_id     text        NOT NULL DEFAULT '',
    occurred_at    timestamptz NOT NULL,
    context        jsonb       NOT NULL DEFAULT '{}'::jsonb
);

CREATE INDEX audit_record_tenant_time_idx
    ON platform_data.audit_record (tenant_id, occurred_at DESC);

CREATE INDEX audit_record_actor_idx
    ON platform_data.audit_record (tenant_id, actor_id, occurred_at DESC);

-- Denied attempts are the rows a security reviewer reaches for first.
CREATE INDEX audit_record_denied_idx
    ON platform_data.audit_record (tenant_id, occurred_at DESC)
    WHERE outcome = 'denied';
