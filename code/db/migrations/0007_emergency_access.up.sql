-- Emergency and downtime access (SRS-SEC-014).
--
-- Both tables live in security_platform because both are security records
-- first: the clinical effect of a downtime action is reconciled into the
-- owning context's own tables, and what stays here is the account of what was
-- done outside the normal controls and whether anybody checked.
--
-- Trace: SRS-SEC-014, SRS-IAM-005.
--
-- Rollback: drops both tables. An open downtime episode's reconciliation queue
--   goes with them, which would lose the record of paper actions not yet
--   entered into the chart — restore from backup rather than rolling back a
--   facility that is mid-outage.
-- Reconciliation: none forward. New tables, no previous version writes to them.
--   The partial unique index on active grants is created with the table, so
--   there is no window in which a stacked activation could be inserted.

CREATE TABLE security_platform.emergency_grant (
    grant_id      uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    subject_id    text        NOT NULL,
    facility_id   text        NOT NULL DEFAULT '',
    -- The incident the activation belongs to. Required, because the review
    -- has to check the access against something.
    incident_ref  text        NOT NULL CHECK (length(btrim(incident_ref)) > 0),
    justification text        NOT NULL CHECK (length(btrim(justification)) >= 10),
    -- Always a subset of what the subject's roles already grant. Emergency
    -- access widens reach, never privilege; the domain refuses anything else.
    permissions   text[]      NOT NULL CHECK (cardinality(permissions) > 0),
    status        text        NOT NULL CHECK (status IN
        ('active', 'closed', 'expired', 'reviewed', 'reviewed_abused')),
    activated_at  timestamptz NOT NULL,
    expires_at    timestamptz NOT NULL,
    closed_at     timestamptz,
    -- What was actually reached. This is the review's subject matter, so it is
    -- the resource references and not a count.
    accessed_resources text[] NOT NULL DEFAULT '{}',
    reviewed_by   text        NOT NULL DEFAULT '',
    reviewed_at   timestamptz,
    review_note   text        NOT NULL DEFAULT '',
    correlation_id text       NOT NULL DEFAULT '',
    CONSTRAINT emergency_grant_window CHECK (expires_at > activated_at),
    -- A review must name someone other than the subject. Enforced in the
    -- domain too; here because a direct write would otherwise bypass it.
    CONSTRAINT emergency_grant_not_self_reviewed
        CHECK (reviewed_by = '' OR reviewed_by <> subject_id)
);

-- At most one active grant per subject. This is the constraint that stops a
-- bounded TTL being defeated by stacking activations, and it belongs in the
-- database because the check and the insert would otherwise race.
CREATE UNIQUE INDEX emergency_grant_one_active_per_subject
    ON security_platform.emergency_grant (tenant_id, subject_id)
    WHERE status = 'active';

-- Finding the grants nobody has reviewed is the routine query, so it gets the
-- index rather than the list-by-tenant case.
CREATE INDEX emergency_grant_awaiting_review_idx
    ON security_platform.emergency_grant (tenant_id, closed_at)
    WHERE status IN ('closed', 'expired');

CREATE TABLE security_platform.downtime_episode (
    episode_id    uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    facility_id   text        NOT NULL CHECK (length(btrim(facility_id)) > 0),
    planned       boolean     NOT NULL,
    declared_by   text        NOT NULL,
    declared_at   timestamptz NOT NULL,
    reason        text        NOT NULL CHECK (length(btrim(reason)) >= 10),
    restored_at   timestamptz,
    status        text        NOT NULL CHECK (status IN ('open', 'recovering', 'reconciled')),
    closed_by     text        NOT NULL DEFAULT '',
    closed_at     timestamptz,
    correlation_id text       NOT NULL DEFAULT ''
);

-- One open episode per facility: two concurrent declarations would split the
-- reconciliation queue and a ward would work from the wrong one.
CREATE UNIQUE INDEX downtime_episode_one_open_per_facility
    ON security_platform.downtime_episode (tenant_id, facility_id)
    WHERE status <> 'reconciled';

CREATE TABLE security_platform.downtime_action (
    action_id     uuid        PRIMARY KEY,
    episode_id    uuid        NOT NULL
        REFERENCES security_platform.downtime_episode (episode_id),
    tenant_id     uuid        NOT NULL,
    -- The clinical truth: who did it and when, not who typed it in and when.
    -- Conflating the two is the failure this table exists to prevent, so they
    -- are separate columns and both are required.
    performed_by  text        NOT NULL,
    performed_at  timestamptz NOT NULL,
    action_type   text        NOT NULL,
    subject_ref   text        NOT NULL,
    summary       text        NOT NULL,
    -- Ties the row back to the physical form, so a dispute is settled against
    -- the paper rather than against the database.
    paper_form_ref text       NOT NULL CHECK (length(btrim(paper_form_ref)) > 0),
    reconciled_by text        NOT NULL DEFAULT '',
    reconciled_at timestamptz,
    -- What the action became in the record once entered.
    resource_ref  text        NOT NULL DEFAULT '',
    CONSTRAINT downtime_action_reconciliation_is_whole
        CHECK ((reconciled_at IS NULL AND reconciled_by = '' AND resource_ref = '')
            OR (reconciled_at IS NOT NULL AND reconciled_by <> '' AND resource_ref <> ''))
);

-- The outstanding queue is what a ward works from after restore.
CREATE INDEX downtime_action_outstanding_idx
    ON security_platform.downtime_action (episode_id, performed_at)
    WHERE reconciled_at IS NULL;

-- One paper action becomes one record entry. Without this a retried
-- reconciliation could double a medication administration.
CREATE UNIQUE INDEX downtime_action_one_resource_per_action
    ON security_platform.downtime_action (episode_id, resource_ref)
    WHERE resource_ref <> '';
