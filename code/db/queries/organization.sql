-- Organization context queries.
--
-- Every tenant-owned statement takes tenant_id explicitly; the repository layer
-- can only supply it from an authctx.TenantScope (SRS-PLT-003, FIT-03).

-- name: InsertTenant :exec
INSERT INTO organization.tenant (
    tenant_id, display_name, legal_jurisdiction, default_locale, time_zone,
    status, created_at, created_by, updated_at, updated_by, version
) VALUES (
    @tenant_id, @display_name, @legal_jurisdiction, @default_locale, @time_zone,
    @status, @created_at, @created_by, @updated_at, @updated_by, @version
);

-- name: GetTenantByID :one
SELECT tenant_id, display_name, legal_jurisdiction, default_locale, time_zone,
       status, created_at, updated_at, version
FROM organization.tenant
WHERE tenant_id = @tenant_id;

-- name: InsertFacility :exec
INSERT INTO organization.facility (
    facility_id, tenant_id, code, display_name, type, status, time_zone,
    created_at, created_by, updated_at, updated_by, version
) VALUES (
    @facility_id, @tenant_id, @code, @display_name, @type, @status, @time_zone,
    @created_at, @created_by, @updated_at, @updated_by, @version
);

-- name: GetFacilityByID :one
-- The tenant predicate is part of the lookup, not a post-filter: a facility ID
-- belonging to another tenant returns no rows rather than a forbidden row.
SELECT facility_id, tenant_id, code, display_name, type, status, time_zone,
       created_at, updated_at, version
FROM organization.facility
WHERE tenant_id = @tenant_id
  AND facility_id = @facility_id;

-- name: FacilityCodeExists :one
SELECT EXISTS (
    SELECT 1 FROM organization.facility
    WHERE tenant_id = @tenant_id AND code = @code
);

-- name: ListFacilities :many
-- Keyset pagination on (created_at, facility_id). Page numbers are avoided
-- because concurrent inserts would shift rows across page boundaries.
SELECT facility_id, tenant_id, code, display_name, type, status, time_zone,
       created_at, updated_at, version
FROM organization.facility
WHERE tenant_id = @tenant_id
  AND (sqlc.narg(status)::text IS NULL OR status = sqlc.narg(status)::text)
  AND (
        sqlc.narg(cursor_created_at)::timestamptz IS NULL
        OR (created_at, facility_id) >
           (sqlc.narg(cursor_created_at)::timestamptz, sqlc.narg(cursor_id)::uuid)
      )
ORDER BY created_at, facility_id
LIMIT @page_limit;
