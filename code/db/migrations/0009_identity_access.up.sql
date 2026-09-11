-- 0009 Identity and access: federations, accounts, step-up proofs, risk.
--
-- Closes the storage half of ADR-008. The verifier itself is stateless; what
-- lives here is everything the external identity provider does not know —
-- which roles this tenant granted, which facilities, and the revocation
-- watermark that lets an administrator end a session before its token expires.
--
-- Trace: SRS-IAM-001, SRS-IAM-006, SRS-IAM-009, SRS-IAM-010, SRS-IAM-012,
--        SRS-IAM-015.
--
-- Rollback: drops every table. Federations go with it, so every federated user
--   loses access until they are re-created — which fails closed, and is still
--   an outage. Restore from backup rather than rolling back a tenant that
--   signs in through SSO.
-- Reconciliation: none forward; all tables are new. After a restore, check
--   that no account's revocation watermark moved backwards: a restore that
--   reinstates a pre-revocation watermark would resurrect sessions an
--   administrator deliberately killed, which is the one direction this data
--   must never move.

CREATE TABLE identity_access.federation (
    federation_id uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    -- The trust anchor. Unique across the whole deployment, not per tenant:
    -- an issuer identifies exactly one customer directory, and letting two
    -- tenants claim one would make "which tenant is this token for?"
    -- ambiguous at the only point where it cannot be.
    issuer        text        NOT NULL,
    domains       text[]      NOT NULL DEFAULT '{}',
    -- Mapping from provider claim values to this tenant's roles, as
    -- [{claim, value, roles[], permitted_facilities[]}]. JSON rather than a
    -- child table because it is read whole on every sign-in and never queried
    -- by its parts.
    role_mappings jsonb       NOT NULL DEFAULT '[]'::jsonb,
    default_roles text[]      NOT NULL DEFAULT '{}',
    enabled       boolean     NOT NULL DEFAULT true,
    created_at    timestamptz NOT NULL,
    updated_at    timestamptz NOT NULL,
    CONSTRAINT federation_issuer_is_https CHECK (issuer LIKE 'https://%')
);

-- One federation per issuer, globally. This is the constraint that makes
-- issuer-based tenant resolution safe.
CREATE UNIQUE INDEX federation_issuer_key ON identity_access.federation (issuer);

CREATE INDEX federation_tenant_idx ON identity_access.federation (tenant_id);

CREATE TABLE identity_access.account (
    account_id    uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    -- The identity provider's subject. For a federated user this is the
    -- external subject and there is no second credential to keep in step.
    subject_id    text        NOT NULL,
    identity_provider text    NOT NULL,
    display_name  text        NOT NULL,
    status        text        NOT NULL CHECK (status IN
        ('invited', 'active', 'suspended', 'deactivated')),
    roles         text[]      NOT NULL DEFAULT '{}',
    permitted_facilities text[] NOT NULL DEFAULT '{}',
    -- The revocation watermark: any credential issued before this instant is
    -- refused, whatever its own expiry says. Moving it forward ends every live
    -- session at once, which is what "disable this user" actually means.
    not_valid_before timestamptz NOT NULL DEFAULT '-infinity',
    created_at    timestamptz NOT NULL,
    updated_at    timestamptz NOT NULL,
    version       bigint      NOT NULL CHECK (version > 0)
);

CREATE UNIQUE INDEX account_tenant_subject_key
    ON identity_access.account (tenant_id, subject_id);

CREATE TABLE identity_access.step_up_proof (
    proof_id      uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    subject_id    text        NOT NULL,
    -- The action the proof was obtained for. A proof for one action must not
    -- authorise another, so this is part of the key rather than metadata.
    action        text        NOT NULL,
    reference     text        NOT NULL,
    -- How the user authenticated: the strength of the control depends on it
    -- and an incident review needs to know.
    method        text        NOT NULL CHECK (length(btrim(method)) > 0),
    obtained_at   timestamptz NOT NULL
);

-- The routine lookup is "the latest proof this subject has for this action".
CREATE INDEX step_up_latest_idx
    ON identity_access.step_up_proof (tenant_id, subject_id, action, obtained_at DESC);

CREATE TABLE identity_access.signin_risk (
    assessment_id uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    subject_id    text        NOT NULL,
    score         integer     NOT NULL CHECK (score BETWEEN 0 AND 100),
    signals       text[]      NOT NULL DEFAULT '{}',
    alerted       boolean     NOT NULL,
    blocked       boolean     NOT NULL,
    occurred_at   timestamptz NOT NULL
);

-- Finding a subject's recent history is what makes "new device" and "dormant
-- account" answerable at the next sign-in.
CREATE INDEX signin_risk_subject_idx
    ON identity_access.signin_risk (tenant_id, subject_id, occurred_at DESC);

CREATE INDEX signin_risk_alerts_idx
    ON identity_access.signin_risk (tenant_id, occurred_at DESC)
    WHERE alerted;
