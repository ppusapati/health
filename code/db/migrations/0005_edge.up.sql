-- 0005 Hospital edge: enrollment registry (cloud side).
--
-- The cloud keeps the registry of enrolled edge nodes and their credentials'
-- fingerprints. The edge's own store-and-forward queue lives on the edge, in
-- SQLite, precisely so it survives the WAN link this table is reachable over.
--
-- Trace: SRS-NFR-013 (offline queue with deterministic conflict resolution),
--        Blueprint §12 (hospital edge and OT trust zones).
-- Scope : Wave-0 prototype. SRS-ONB-DEV (device/analyser/SCADA commissioning)
--         is Wave 9 and is not claimed here.
--
-- Rollback: drops the enrollment registry. Every edge node then fails
--   authentication at ingest, which is the safe direction — nodes queue
--   locally and forward on recovery rather than sending unauthenticated.
-- Reconciliation: re-enrol each node. Their local queues survive the outage,
--   and ingest is idempotent on (node, operation id), so nothing replays twice.

CREATE SCHEMA IF NOT EXISTS platform_edge;

CREATE TABLE platform_edge.node (
    node_id        uuid        PRIMARY KEY,
    tenant_id      uuid        NOT NULL,
    facility_id    uuid        NOT NULL,
    display_name   text        NOT NULL CHECK (length(btrim(display_name)) > 0),
    status         text        NOT NULL CHECK (status IN ('pending', 'enrolled', 'suspended', 'revoked')),
    -- SHA-256 of the node's client certificate. The certificate itself never
    -- reaches this table: a fingerprint is enough to authenticate and useless
    -- if the row leaks.
    credential_fingerprint text NOT NULL DEFAULT '',
    enrolled_at    timestamptz,
    last_seen_at   timestamptz,
    created_at     timestamptz NOT NULL,
    updated_at     timestamptz NOT NULL,
    version        bigint      NOT NULL CHECK (version > 0)
);

CREATE UNIQUE INDEX node_tenant_name_key
    ON platform_edge.node (tenant_id, facility_id, display_name);

CREATE INDEX node_tenant_status_idx
    ON platform_edge.node (tenant_id, status);

-- One-time enrollment tokens. Short-lived and single-use: a reusable token is
-- a permanent credential for anyone who reads a provisioning log.
CREATE TABLE platform_edge.enrollment_token (
    token_hash  text        PRIMARY KEY,
    node_id     uuid        NOT NULL REFERENCES platform_edge.node (node_id),
    tenant_id   uuid        NOT NULL,
    expires_at  timestamptz NOT NULL,
    consumed_at timestamptz,
    created_at  timestamptz NOT NULL
);

CREATE INDEX enrollment_token_node_idx
    ON platform_edge.enrollment_token (node_id)
    WHERE consumed_at IS NULL;

-- Operations forwarded from an edge node after a connectivity gap.
--
-- The primary key is (node, client operation id), which is what makes replay
-- after reconnection idempotent: the edge retries until acknowledged, and the
-- cloud absorbs duplicates without a second side effect.
CREATE TABLE platform_edge.forwarded_operation (
    node_id       uuid        NOT NULL REFERENCES platform_edge.node (node_id),
    operation_id  uuid        NOT NULL,
    tenant_id     uuid        NOT NULL,
    operation_type text       NOT NULL,
    payload       jsonb       NOT NULL,
    -- When the operation actually happened at the edge, which is not when the
    -- cloud received it. Clinical and operational records need the former.
    occurred_at   timestamptz NOT NULL,
    received_at   timestamptz NOT NULL,
    outcome       text        NOT NULL CHECK (outcome IN ('applied', 'duplicate', 'rejected')),
    reject_reason text        NOT NULL DEFAULT '',
    PRIMARY KEY (node_id, operation_id)
);

CREATE INDEX forwarded_operation_tenant_idx
    ON platform_edge.forwarded_operation (tenant_id, occurred_at);
