-- 0006 Security platform: tamper-evident security events, bulk export,
-- retention and legal hold, privacy artifacts, data-subject requests.
--
-- Trace: SRS-SEC-004, SRS-SEC-008, SRS-SEC-009, SRS-SEC-010, SRS-SEC-012,
--        SRS-DAT-007, SRS-DAT-009, SRS-NFR-012.

CREATE SCHEMA IF NOT EXISTS security_platform;

-- Tamper-evident security event log (SRS-SEC-012).
--
-- Each row carries the hash of the previous row for the same tenant, forming a
-- chain. Deleting or editing a row breaks every hash after it, so tampering is
-- detectable even by someone with database write access — which is exactly the
-- threat an ordinary audit table does not address.
CREATE TABLE security_platform.security_event (
    event_id       uuid        PRIMARY KEY,
    tenant_id      uuid        NOT NULL,
    sequence       bigint      NOT NULL,
    event_class    text        NOT NULL,
    severity       text        NOT NULL CHECK (severity IN ('info', 'low', 'medium', 'high', 'critical')),
    actor_id       text        NOT NULL,
    resource_type  text        NOT NULL DEFAULT '',
    resource_id    text        NOT NULL DEFAULT '',
    outcome        text        NOT NULL CHECK (outcome IN ('success', 'denied', 'failure')),
    detail         jsonb       NOT NULL DEFAULT '{}'::jsonb,
    correlation_id text        NOT NULL,
    occurred_at    timestamptz NOT NULL,
    -- Hash of the canonical serialisation of this row plus previous_hash.
    entry_hash     text        NOT NULL,
    previous_hash  text        NOT NULL
);

CREATE UNIQUE INDEX security_event_tenant_sequence_key
    ON security_platform.security_event (tenant_id, sequence);

CREATE INDEX security_event_tenant_time_idx
    ON security_platform.security_event (tenant_id, occurred_at DESC);

CREATE INDEX security_event_severity_idx
    ON security_platform.security_event (tenant_id, severity, occurred_at DESC)
    WHERE severity IN ('high', 'critical');

-- Secure bulk export (SRS-SEC-008, SRS-NFR-012).
--
-- Export is asynchronous by construction: a synchronous bulk export of PHI is
-- both a timeout risk and a control that cannot be reviewed before it runs.
CREATE TABLE security_platform.export_request (
    export_id       uuid        PRIMARY KEY,
    tenant_id       uuid        NOT NULL,
    requested_by    text        NOT NULL,
    -- Free-text business reason, required. An export with no stated purpose is
    -- not reviewable after the fact.
    justification   text        NOT NULL CHECK (length(btrim(justification)) >= 10),
    data_class      text        NOT NULL,
    scope           jsonb       NOT NULL DEFAULT '{}'::jsonb,
    status          text        NOT NULL CHECK (status IN
        ('pending_approval', 'approved', 'rejected', 'running', 'completed', 'failed', 'expired')),
    -- Proof that step-up authentication was completed (SRS-IAM-012).
    step_up_reference text      NOT NULL DEFAULT '',
    approved_by     text        NOT NULL DEFAULT '',
    approved_at     timestamptz,
    -- Object-store reference; the content never lives in PostgreSQL.
    object_key      text        NOT NULL DEFAULT '',
    object_sha256   text        NOT NULL DEFAULT '',
    manifest        jsonb       NOT NULL DEFAULT '{}'::jsonb,
    row_count       bigint      NOT NULL DEFAULT 0,
    -- Watermark identifying the recipient, so a leaked export is attributable.
    watermark       text        NOT NULL DEFAULT '',
    -- Download grants expire; a permanent URL to a PHI export is a standing
    -- breach waiting for someone to find the link.
    grant_expires_at timestamptz,
    created_at      timestamptz NOT NULL,
    updated_at      timestamptz NOT NULL,
    version         bigint      NOT NULL CHECK (version > 0)
);

CREATE INDEX export_request_tenant_status_idx
    ON security_platform.export_request (tenant_id, status, created_at DESC);

-- Every download of an export is recorded, not just the request.
CREATE TABLE security_platform.export_download (
    download_id  uuid        PRIMARY KEY,
    export_id    uuid        NOT NULL REFERENCES security_platform.export_request (export_id),
    tenant_id    uuid        NOT NULL,
    downloaded_by text       NOT NULL,
    correlation_id text      NOT NULL,
    occurred_at  timestamptz NOT NULL
);

CREATE INDEX export_download_export_idx
    ON security_platform.export_download (export_id, occurred_at DESC);

-- Retention classes and legal hold (SRS-DAT-009, SRS-SEC-010).
CREATE TABLE security_platform.retention_class (
    retention_class_id uuid     PRIMARY KEY,
    tenant_id      uuid         NOT NULL,
    name           text         NOT NULL,
    data_class     text         NOT NULL,
    -- NULL means retain indefinitely, which must be a deliberate choice rather
    -- than the default that happens when nobody sets a period.
    retain_days    integer      CHECK (retain_days IS NULL OR retain_days > 0),
    archive_after_days integer  CHECK (archive_after_days IS NULL OR archive_after_days > 0),
    created_at     timestamptz  NOT NULL,
    updated_at     timestamptz  NOT NULL
);

CREATE UNIQUE INDEX retention_class_tenant_name_key
    ON security_platform.retention_class (tenant_id, name);

-- A legal hold suspends deletion regardless of retention class. Deletion jobs
-- must consult this table, never only the retention period.
CREATE TABLE security_platform.legal_hold (
    hold_id       uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    resource_type text        NOT NULL,
    resource_id   text        NOT NULL,
    reason        text        NOT NULL CHECK (length(btrim(reason)) > 0),
    placed_by     text        NOT NULL,
    placed_at     timestamptz NOT NULL,
    released_by   text        NOT NULL DEFAULT '',
    released_at   timestamptz
);

-- Only one active hold per resource; releasing and re-placing is the audited
-- path rather than stacking duplicates.
CREATE UNIQUE INDEX legal_hold_active_resource_key
    ON security_platform.legal_hold (tenant_id, resource_type, resource_id)
    WHERE released_at IS NULL;

-- Privacy notices and processing purposes (SRS-SEC-009).
--
-- Deliberately separate from clinical consent: a patient withdrawing marketing
-- consent must not affect the lawful basis for their medical record.
CREATE TABLE security_platform.privacy_notice (
    notice_id    uuid        PRIMARY KEY,
    tenant_id    uuid        NOT NULL,
    version      integer     NOT NULL CHECK (version > 0),
    locale       text        NOT NULL,
    body_uri     text        NOT NULL,
    effective_from timestamptz NOT NULL,
    created_at   timestamptz NOT NULL
);

CREATE UNIQUE INDEX privacy_notice_tenant_version_locale_key
    ON security_platform.privacy_notice (tenant_id, version, locale);

CREATE TABLE security_platform.processing_purpose (
    purpose_id   uuid        PRIMARY KEY,
    tenant_id    uuid        NOT NULL,
    code         text        NOT NULL,
    description  text        NOT NULL,
    -- Whether the subject may withdraw. Care delivery cannot be withdrawn from
    -- while the record must lawfully be retained; marketing can.
    withdrawable boolean     NOT NULL,
    lawful_basis text        NOT NULL,
    created_at   timestamptz NOT NULL
);

CREATE UNIQUE INDEX processing_purpose_tenant_code_key
    ON security_platform.processing_purpose (tenant_id, code);

CREATE TABLE security_platform.purpose_grant (
    grant_id     uuid        PRIMARY KEY,
    tenant_id    uuid        NOT NULL,
    subject_ref  text        NOT NULL,
    purpose_code text        NOT NULL,
    notice_version integer   NOT NULL,
    granted      boolean     NOT NULL,
    recorded_by  text        NOT NULL,
    occurred_at  timestamptz NOT NULL
);

-- Append-only: a withdrawal is a new row, so the history of what the subject
-- agreed to and when stays reconstructable.
CREATE INDEX purpose_grant_subject_idx
    ON security_platform.purpose_grant (tenant_id, subject_ref, purpose_code, occurred_at DESC);

-- Data-subject requests (SRS-SEC-010).
CREATE TABLE security_platform.subject_request (
    request_id   uuid        PRIMARY KEY,
    tenant_id    uuid        NOT NULL,
    subject_ref  text        NOT NULL,
    request_type text        NOT NULL CHECK (request_type IN
        ('access', 'rectification', 'erasure', 'restriction', 'portability', 'objection')),
    status       text        NOT NULL CHECK (status IN
        ('received', 'verifying', 'in_review', 'fulfilled', 'partially_fulfilled', 'refused')),
    received_at  timestamptz NOT NULL,
    due_at       timestamptz NOT NULL,
    reviewer     text        NOT NULL DEFAULT '',
    decision     text        NOT NULL DEFAULT '',
    -- Why a request was refused or only partly met — a clinical retention
    -- obligation, say. An unexplained refusal is not defensible.
    decision_basis text      NOT NULL DEFAULT '',
    evidence_ref text        NOT NULL DEFAULT '',
    closed_at    timestamptz,
    created_at   timestamptz NOT NULL,
    updated_at   timestamptz NOT NULL,
    version      bigint      NOT NULL CHECK (version > 0)
);

CREATE INDEX subject_request_tenant_status_idx
    ON security_platform.subject_request (tenant_id, status, due_at);
