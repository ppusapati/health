-- 0002 Organization context: tenant and facility.
--
-- Conventions applied (Domain/Data spec §5.1, Wave-0 spec §5):
--   * opaque UUID primary keys; no business meaning encoded in a key
--   * tenant_id on every tenant-owned row
--   * UTC timestamptz; created/updated provenance; version for concurrency
--   * status as a CHECK-constrained value, never free text
--   * retirement instead of deletion for referenced masters
--
-- Trace: SRS-PLT-001, SRS-PLT-002, SRS-PLT-004, SRS-PLT-007, SRS-PLT-015,
--        SRS-PLT-020, SRS-DAT-005.

CREATE TABLE organization.tenant (
    tenant_id           uuid        PRIMARY KEY,
    display_name        text        NOT NULL CHECK (length(btrim(display_name)) > 0),
    legal_jurisdiction  char(2)     NOT NULL,
    default_locale      text        NOT NULL,
    time_zone           text        NOT NULL,
    status              text        NOT NULL
        CHECK (status IN ('provisioning', 'active', 'suspended', 'offboarding', 'terminated')),
    created_at          timestamptz NOT NULL,
    created_by          text        NOT NULL,
    updated_at          timestamptz NOT NULL,
    updated_by          text        NOT NULL,
    version             bigint      NOT NULL CHECK (version > 0)
);

COMMENT ON TABLE organization.tenant IS
    'SRS-PLT-001. tenant_id is immutable; display_name is not a key.';

CREATE TABLE organization.facility (
    facility_id   uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL REFERENCES organization.tenant (tenant_id),
    code          text        NOT NULL CHECK (code ~ '^[A-Z0-9][A-Z0-9_-]{1,31}$'),
    display_name  text        NOT NULL CHECK (length(btrim(display_name)) > 0),
    type          text        NOT NULL
        CHECK (type IN ('hospital', 'clinic', 'laboratory', 'pharmacy', 'collection_centre', 'warehouse')),
    status        text        NOT NULL
        CHECK (status IN ('active', 'inactive', 'retired')),
    time_zone     text        NOT NULL,
    created_at    timestamptz NOT NULL,
    created_by    text        NOT NULL,
    updated_at    timestamptz NOT NULL,
    updated_by    text        NOT NULL,
    version       bigint      NOT NULL CHECK (version > 0)
);

-- SRS-PLT-007: codes are unique per tenant, not globally. Two tenants may both
-- run a facility called "MAIN".
CREATE UNIQUE INDEX facility_tenant_code_key
    ON organization.facility (tenant_id, code);

-- Listings are always tenant-scoped and ordered by the cursor key, so the
-- tenant column leads the index (Domain/Data spec §5.1 "Indexes").
CREATE INDEX facility_tenant_status_idx
    ON organization.facility (tenant_id, status, created_at, facility_id);
