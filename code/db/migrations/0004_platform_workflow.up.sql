-- 0004 Workflow and rules evaluation harness (P0-07).
--
-- SCOPE
-- =====
-- ADR-006 and ADR-007 are now closed against these tables: ADR-006 for Waves
-- 1-6, ADR-007 outright. They began life as the proof of concept those ADRs
-- required and are now the running implementation, so the tables below carry
-- real workflow instances and real published rule sets.
--
-- They still deliberately do NOT claim the Wave-7 requirement families
-- SRS-BPM-DEF, SRS-BPM-RUN, SRS-BPM-TASK, SRS-RUL-DEF or SRS-RUL-RUN. Those own
-- the canonical schemas enterprise_platform_bpm_* and enterprise_platform_rul_*,
-- and Wave 7 re-runs the ADR-006 evaluation with six waves of real workflows as
-- its input (Wave-0 spec §13, ADR-006 reopening trigger 5).
--
-- What survives a replacement is the Go contract in internal/platform/workflow
-- and internal/platform/rules, not these tables.
--
-- Trace: ADR-006 and ADR-007. No Wave-7 SRS-BPM-* or SRS-RUL-* requirement is
--        claimed here.
--
-- Rollback: drops the workflow and rules tables. A running instance loses its
--   history and a published rule set loses the versions that justify past
--   decisions, so this is a restore-from-backup situation rather than a
--   down-migration anywhere real.
-- Reconciliation: none for the forward direction; these tables are new.

CREATE SCHEMA IF NOT EXISTS platform_workflow;
CREATE SCHEMA IF NOT EXISTS platform_rules;

-- A running workflow instance.
--
-- definition_version is pinned at start: a new definition version must not
-- change the behaviour of instances already in flight (Domain/Data spec §9,
-- "Migration"). Upgrading a running instance requires a controlled migration,
-- which this harness does not perform.
CREATE TABLE platform_workflow.instance (
    instance_id        uuid        PRIMARY KEY,
    tenant_id          uuid        NOT NULL,
    definition_name    text        NOT NULL,
    definition_version integer     NOT NULL CHECK (definition_version > 0),
    -- Business correlation, e.g. the tenant being onboarded. Unique per
    -- definition so a retried Start cannot fork a second instance.
    correlation_key    text        NOT NULL,
    status             text        NOT NULL CHECK (status IN (
        'running', 'awaiting_signal', 'awaiting_timer',
        'completed', 'failed', 'compensating', 'compensated', 'cancelled')),
    current_step       text        NOT NULL DEFAULT '',
    -- Index into the definition's step list; drives forward progress and,
    -- on failure, the reverse walk for compensation.
    step_index         integer     NOT NULL DEFAULT 0,
    attempts           integer     NOT NULL DEFAULT 0,
    state              jsonb       NOT NULL DEFAULT '{}'::jsonb,
    last_error         text        NOT NULL DEFAULT '',
    created_at         timestamptz NOT NULL,
    updated_at         timestamptz NOT NULL,
    version            bigint      NOT NULL CHECK (version > 0)
);

CREATE UNIQUE INDEX instance_definition_correlation_key
    ON platform_workflow.instance (tenant_id, definition_name, correlation_key);

-- Claiming runnable work is a hot path; a partial index keeps it proportional
-- to the runnable set rather than to all history.
CREATE INDEX instance_runnable_idx
    ON platform_workflow.instance (updated_at, instance_id)
    WHERE status IN ('running', 'compensating');

-- Append-only execution history. This is the visibility and replay surface
-- ADR-006 requires evidence for.
CREATE TABLE platform_workflow.history (
    history_id   bigserial   PRIMARY KEY,
    instance_id  uuid        NOT NULL REFERENCES platform_workflow.instance (instance_id),
    tenant_id    uuid        NOT NULL,
    sequence     integer     NOT NULL,
    event_type   text        NOT NULL,
    step         text        NOT NULL DEFAULT '',
    attempt      integer     NOT NULL DEFAULT 0,
    detail       jsonb       NOT NULL DEFAULT '{}'::jsonb,
    occurred_at  timestamptz NOT NULL
);

CREATE UNIQUE INDEX history_instance_sequence_key
    ON platform_workflow.history (instance_id, sequence);

-- Durable timers. A timer that only lives in a process is lost on restart,
-- which is the whole reason cron-only orchestration is prohibited.
CREATE TABLE platform_workflow.timer (
    timer_id    uuid        PRIMARY KEY,
    instance_id uuid        NOT NULL REFERENCES platform_workflow.instance (instance_id),
    tenant_id   uuid        NOT NULL,
    step        text        NOT NULL,
    due_at      timestamptz NOT NULL,
    fired_at    timestamptz,
    created_at  timestamptz NOT NULL
);

CREATE INDEX timer_due_idx
    ON platform_workflow.timer (due_at, timer_id)
    WHERE fired_at IS NULL;

-- Signal inbox. Signals may arrive late, out of order or more than once
-- (Domain/Data spec §9); the primary key is what makes redelivery harmless.
CREATE TABLE platform_workflow.signal (
    instance_id  uuid        NOT NULL REFERENCES platform_workflow.instance (instance_id),
    signal_key   text        NOT NULL,
    tenant_id    uuid        NOT NULL,
    signal_name  text        NOT NULL,
    payload      jsonb       NOT NULL DEFAULT '{}'::jsonb,
    received_at  timestamptz NOT NULL,
    PRIMARY KEY (instance_id, signal_key)
);

-- Human tasks with an SLA due date.
CREATE TABLE platform_workflow.human_task (
    task_id      uuid        PRIMARY KEY,
    instance_id  uuid        NOT NULL REFERENCES platform_workflow.instance (instance_id),
    tenant_id    uuid        NOT NULL,
    step         text        NOT NULL,
    assigned_role text       NOT NULL,
    status       text        NOT NULL CHECK (status IN ('open', 'completed', 'expired', 'cancelled')),
    due_at       timestamptz NOT NULL,
    completed_by text        NOT NULL DEFAULT '',
    outcome      text        NOT NULL DEFAULT '',
    created_at   timestamptz NOT NULL,
    updated_at   timestamptz NOT NULL
);

CREATE INDEX human_task_open_idx
    ON platform_workflow.human_task (tenant_id, assigned_role, due_at)
    WHERE status = 'open';

-- Versioned, effective-dated decision tables.
--
-- A published rule set is immutable: changing a live rule in place would make
-- past decisions unexplainable. A change means a new version.
CREATE TABLE platform_rules.rule_set (
    rule_set_id  uuid        PRIMARY KEY,
    tenant_id    uuid,
    name         text        NOT NULL,
    version      integer     NOT NULL CHECK (version > 0),
    status       text        NOT NULL CHECK (status IN ('draft', 'published', 'retired')),
    effective_from timestamptz NOT NULL,
    effective_to   timestamptz,
    definition   jsonb       NOT NULL,
    created_at   timestamptz NOT NULL,
    created_by   text        NOT NULL,
    published_at timestamptz,
    published_by text        NOT NULL DEFAULT ''
);

-- tenant_id NULL means a platform-wide default; COALESCE gives both a stable
-- uniqueness key.
CREATE UNIQUE INDEX rule_set_name_version_key
    ON platform_rules.rule_set (COALESCE(tenant_id, '00000000-0000-0000-0000-000000000000'::uuid), name, version);

CREATE INDEX rule_set_lookup_idx
    ON platform_rules.rule_set (name, status, effective_from DESC);

-- Every evaluation is recorded with the exact rule-set version that produced
-- it, which is what makes replay meaningful (ADR-007 explainability/replay).
CREATE TABLE platform_rules.decision_log (
    decision_id    uuid        PRIMARY KEY,
    tenant_id      uuid        NOT NULL,
    rule_set_name  text        NOT NULL,
    rule_set_version integer   NOT NULL,
    matched_rule   text        NOT NULL DEFAULT '',
    input          jsonb       NOT NULL,
    outcome        jsonb       NOT NULL,
    explanation    jsonb       NOT NULL DEFAULT '[]'::jsonb,
    correlation_id text        NOT NULL,
    occurred_at    timestamptz NOT NULL
);

CREATE INDEX decision_log_tenant_time_idx
    ON platform_rules.decision_log (tenant_id, occurred_at DESC);
