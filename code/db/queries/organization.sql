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

-- Organizational units (SRS-PLT-005).

-- name: InsertOrgUnit :exec
INSERT INTO organization.org_unit (
    unit_id, tenant_id, facility_id, unit_type, code, display_name,
    parent_unit_id, effective_from, effective_until,
    accepts_activity_when_inactive, created_at, updated_at, version
) VALUES (
    @unit_id, @tenant_id, @facility_id, @unit_type, @code, @display_name,
    @parent_unit_id, @effective_from, @effective_until,
    @accepts_activity_when_inactive, @created_at, @updated_at, 1
);

-- name: GetOrgUnit :one
SELECT unit_id, tenant_id, facility_id, unit_type, code, display_name,
       parent_unit_id, effective_from, effective_until,
       accepts_activity_when_inactive, created_at, updated_at, version
FROM organization.org_unit
WHERE tenant_id = @tenant_id AND unit_id = @unit_id;

-- name: GetOrgUnitByCode :one
SELECT unit_id, tenant_id, facility_id, unit_type, code, display_name,
       parent_unit_id, effective_from, effective_until,
       accepts_activity_when_inactive, created_at, updated_at, version
FROM organization.org_unit
WHERE tenant_id = @tenant_id AND unit_type = @unit_type AND code = @code;

-- name: ListOrgUnits :many
-- Keyset pagination on (code, unit_id): no OFFSET, so a page is not skewed by
-- rows inserted while the caller is paging.
SELECT unit_id, tenant_id, facility_id, unit_type, code, display_name,
       parent_unit_id, effective_from, effective_until,
       accepts_activity_when_inactive, created_at, updated_at, version
FROM organization.org_unit
WHERE tenant_id = @tenant_id AND unit_type = @unit_type
  AND (@after_code::text = '' OR code > @after_code)
ORDER BY code, unit_id
LIMIT @page_size;

-- name: UpdateOrgUnit :execrows
UPDATE organization.org_unit
SET display_name = @display_name, parent_unit_id = @parent_unit_id,
    effective_from = @effective_from, effective_until = @effective_until,
    accepts_activity_when_inactive = @accepts_activity_when_inactive,
    updated_at = @updated_at, version = version + 1
WHERE tenant_id = @tenant_id AND unit_id = @unit_id AND version = @expected_version;

-- Versioned master-data changes (SRS-PLT-008).

-- name: InsertMasterDataChange :exec
INSERT INTO organization.master_data_change (
    change_id, tenant_id, entity_type, entity_id, proposed, base_version,
    status, effective_from, justification, proposed_by, proposed_at,
    created_at, updated_at, version
) VALUES (
    @change_id, @tenant_id, @entity_type, @entity_id, @proposed, @base_version,
    @status, @effective_from, @justification, @proposed_by, @proposed_at,
    @created_at, @updated_at, 1
);

-- name: GetMasterDataChange :one
SELECT change_id, tenant_id, entity_type, entity_id, proposed, base_version,
       status, effective_from, justification, proposed_by, proposed_at,
       decided_by, decided_at, decision_note, created_at, updated_at, version
FROM organization.master_data_change
WHERE tenant_id = @tenant_id AND change_id = @change_id;

-- name: ListPendingChanges :many
SELECT change_id, tenant_id, entity_type, entity_id, proposed, base_version,
       status, effective_from, justification, proposed_by, proposed_at,
       decided_by, decided_at, decision_note, created_at, updated_at, version
FROM organization.master_data_change
WHERE tenant_id = @tenant_id AND status = 'pending_approval'
ORDER BY proposed_at, change_id
LIMIT @page_size;

-- name: DecideMasterDataChange :execrows
-- The subject_id <> proposed_by predicate enforces four eyes in the statement,
-- so a caller that reached the store directly still cannot approve its own
-- proposal (SRS-PLT-008).
UPDATE organization.master_data_change
SET status = @status, decided_by = @decided_by, decided_at = @decided_at,
    decision_note = @decision_note, updated_at = @decided_at, version = version + 1
WHERE tenant_id = @tenant_id AND change_id = @change_id
  AND status = 'pending_approval'
  AND proposed_by <> @decided_by;

-- Entitlements (SRS-PLT-011).

-- name: InsertEntitlement :exec
INSERT INTO organization.entitlement (
    entitlement_id, tenant_id, facility_id, module, enabled,
    effective_from, effective_until, granted_by, created_at, updated_at, version
) VALUES (
    @entitlement_id, @tenant_id, @facility_id, @module, @enabled,
    @effective_from, @effective_until, @granted_by, @created_at, @updated_at, 1
);

-- name: ListEntitlementsForModule :many
-- Both scopes in one query, ordered so the more specific wins: a facility row
-- overrides the tenant-wide one, which is how a single ward pilots a module.
SELECT entitlement_id, tenant_id, facility_id, module, enabled,
       effective_from, effective_until, granted_by, created_at, updated_at, version
FROM organization.entitlement
WHERE tenant_id = @tenant_id AND module = @module
  AND (facility_id IS NULL OR facility_id = @facility_id)
ORDER BY (facility_id IS NOT NULL) DESC, effective_from DESC, entitlement_id;

-- name: ListTenantEntitlements :many
SELECT entitlement_id, tenant_id, facility_id, module, enabled,
       effective_from, effective_until, granted_by, created_at, updated_at, version
FROM organization.entitlement
WHERE tenant_id = @tenant_id
ORDER BY module, (facility_id IS NOT NULL) DESC, effective_from DESC;

-- Numbering sequences (SRS-PLT-014).

-- name: UpsertNumberSequence :exec
INSERT INTO organization.number_sequence (
    sequence_id, tenant_id, facility_id, scope, prefix, pad_width,
    next_value, period_key, created_at, updated_at
) VALUES (
    @sequence_id, @tenant_id, @facility_id, @scope, @prefix, @pad_width,
    @next_value, @period_key, @created_at, @updated_at
)
ON CONFLICT DO NOTHING;

-- name: IssueTenantNumber :one
-- The whole of SRS-PLT-014's "atomic and collision-free under concurrency" is
-- this statement. UPDATE ... RETURNING takes a row lock, so concurrent callers
-- serialise on it and each receives a distinct value; and because it is an
-- ordinary transactional write, a rolled-back transaction returns its number
-- rather than burning it — which a PostgreSQL SEQUENCE would not do, and which
-- an invoice number a tax authority expects to be gapless requires.
UPDATE organization.number_sequence
SET next_value = next_value + 1, updated_at = @now
WHERE tenant_id = @tenant_id AND scope = @scope AND period_key = @period_key
  AND facility_id IS NULL
-- The ::bigint cast is load-bearing: without it sqlc types the expression as
-- int32 and the counter silently wraps at about 2.1 billion, which an MRN
-- sequence for a large group would eventually reach.
RETURNING (next_value - 1)::bigint AS issued, prefix, pad_width;

-- name: IssueFacilityNumber :one
UPDATE organization.number_sequence
SET next_value = next_value + 1, updated_at = @now
WHERE tenant_id = @tenant_id AND facility_id = @facility_id
  AND scope = @scope AND period_key = @period_key
RETURNING (next_value - 1)::bigint AS issued, prefix, pad_width;

-- Facility calendars (SRS-PLT-016).

-- name: InsertCalendarEntry :exec
INSERT INTO organization.facility_calendar_entry (
    entry_id, tenant_id, facility_id, entry_type, starts_on, ends_on,
    label, override_permitted, created_at, updated_at
) VALUES (
    @entry_id, @tenant_id, @facility_id, @entry_type, @starts_on, @ends_on,
    @label, @override_permitted, @created_at, @updated_at
);

-- name: ListCalendarEntriesOn :many
-- Every entry covering a date, not just the first: a public holiday and a
-- planned closure can overlap, and they may differ on whether an override is
-- permitted. The caller needs both to decide.
SELECT entry_id, tenant_id, facility_id, entry_type, starts_on, ends_on,
       label, override_permitted, created_at, updated_at
FROM organization.facility_calendar_entry
WHERE tenant_id = @tenant_id AND facility_id = @facility_id
  AND starts_on <= @on_date AND ends_on >= @on_date
ORDER BY starts_on, entry_id;

-- Display labels (SRS-PLT-017).

-- name: UpsertDisplayLabel :exec
INSERT INTO organization.display_label (
    label_id, tenant_id, code_system, code, locale, display, short_display,
    created_at, updated_at
) VALUES (
    @label_id, @tenant_id, @code_system, @code, @locale, @display, @short_display,
    @created_at, @updated_at
)
ON CONFLICT (tenant_id, code_system, code, locale) DO UPDATE
SET display = EXCLUDED.display, short_display = EXCLUDED.short_display,
    updated_at = EXCLUDED.updated_at;

-- name: ListDisplayLabels :many
-- All locales for a code, so the caller can apply its own fallback chain
-- (en-IN then en, say) without a query per candidate.
SELECT label_id, tenant_id, code_system, code, locale, display, short_display,
       created_at, updated_at
FROM organization.display_label
WHERE tenant_id = @tenant_id AND code_system = @code_system AND code = @code
ORDER BY locale;
