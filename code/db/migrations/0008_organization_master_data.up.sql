-- 0008 Organization master data: units, versioned changes, entitlements,
-- numbering, calendars and labels.
--
-- Trace: SRS-PLT-005, SRS-PLT-008, SRS-PLT-010, SRS-PLT-011, SRS-PLT-013,
--        SRS-PLT-014, SRS-PLT-016, SRS-PLT-017.
--
-- Rollback: drops every table here. Destructive for tenant configuration —
--   numbering counters especially, since re-issuing an MRN that was already
--   printed on a wristband is a patient-safety event, not a data problem.
--   Restore from backup rather than rolling back a tenant in use.
-- Reconciliation: none forward; all tables are new. After a restore, the
--   numbering counters must be advanced past the highest number already
--   issued (see the runbook) before the service accepts traffic, because the
--   counter is authoritative and the backup may be behind what was printed.

-- Organizational units (SRS-PLT-005).
--
-- Departments, specialties, cost centres, service units and care locations are
-- one table rather than five. They differ in what they mean to a human and not
-- at all in what the system does with them: each is a named, effective-dated
-- node in a hierarchy that transactions attach to. Five near-identical tables
-- would mean five sets of the same queries and five places to forget the
-- effective-date check.
CREATE TABLE organization.org_unit (
    unit_id       uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    facility_id   uuid        REFERENCES organization.facility (facility_id),
    unit_type     text        NOT NULL CHECK (unit_type IN
        ('department', 'specialty', 'cost_center', 'service_unit', 'care_location')),
    -- Stable within a tenant and never reused. Transactions reference the
    -- code in exports and interfaces, so reusing it would silently re-point
    -- historical records at a different unit.
    code          text        NOT NULL,
    display_name  text        NOT NULL CHECK (length(btrim(display_name)) > 0),
    parent_unit_id uuid       REFERENCES organization.org_unit (unit_id),
    -- Half-open window [effective_from, effective_until). Closed intervals
    -- make the changeover day ambiguous and something always gets counted
    -- twice on it.
    effective_from  timestamptz NOT NULL,
    effective_until timestamptz,
    -- Some units legitimately accept activity after they close — a ward being
    -- decommissioned still receives late documentation for patients it
    -- treated. That is an explicit permission, not a default.
    accepts_activity_when_inactive boolean NOT NULL DEFAULT false,
    created_at    timestamptz NOT NULL,
    updated_at    timestamptz NOT NULL,
    version       bigint      NOT NULL CHECK (version > 0),
    CONSTRAINT org_unit_window CHECK (effective_until IS NULL OR effective_until > effective_from)
);

CREATE UNIQUE INDEX org_unit_tenant_code_key
    ON organization.org_unit (tenant_id, unit_type, code);

CREATE INDEX org_unit_tenant_facility_idx
    ON organization.org_unit (tenant_id, facility_id, unit_type);

-- Versioned master-data changes with maker/checker approval (SRS-PLT-008).
--
-- The pending version lives here, not in the target table. Writing a pending
-- change into the row it will eventually become means every reader has to know
-- to filter it out, and one reader that forgets applies an unapproved change
-- to production.
CREATE TABLE organization.master_data_change (
    change_id     uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    entity_type   text        NOT NULL,
    entity_id     uuid        NOT NULL,
    -- The proposed state, as it would be applied. Kept whole rather than as a
    -- field-level diff: a diff has to be replayed against whatever the row
    -- looks like at approval time, which may no longer be what the proposer
    -- saw.
    proposed      jsonb       NOT NULL,
    -- What the proposer was looking at, so approval can detect that somebody
    -- else changed the row in between.
    base_version  bigint      NOT NULL CHECK (base_version >= 0),
    status        text        NOT NULL CHECK (status IN
        ('pending_approval', 'approved', 'rejected', 'superseded')),
    effective_from timestamptz NOT NULL,
    justification text        NOT NULL CHECK (length(btrim(justification)) >= 10),
    proposed_by   text        NOT NULL,
    proposed_at   timestamptz NOT NULL,
    decided_by    text        NOT NULL DEFAULT '',
    decided_at    timestamptz,
    decision_note text        NOT NULL DEFAULT '',
    created_at    timestamptz NOT NULL,
    updated_at    timestamptz NOT NULL,
    version       bigint      NOT NULL CHECK (version > 0),
    -- Maker and checker must differ. In the database as well as the domain,
    -- because a direct write would otherwise bypass the whole control.
    CONSTRAINT master_data_change_four_eyes
        CHECK (decided_by = '' OR decided_by <> proposed_by)
);

CREATE INDEX master_data_change_pending_idx
    ON organization.master_data_change (tenant_id, entity_type, proposed_at)
    WHERE status = 'pending_approval';

-- One pending change per entity. A queue of pending changes against the same
-- row would apply in an order nobody chose, each computed against a base the
-- next one invalidates.
CREATE UNIQUE INDEX master_data_change_one_pending_per_entity
    ON organization.master_data_change (tenant_id, entity_type, entity_id)
    WHERE status = 'pending_approval';

-- Feature and module entitlements (SRS-PLT-011).
CREATE TABLE organization.entitlement (
    entitlement_id uuid       PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    -- NULL facility means the whole tenant. A facility row overrides the
    -- tenant row for that facility, which is how one ward pilots a module.
    facility_id   uuid        REFERENCES organization.facility (facility_id),
    module        text        NOT NULL CHECK (length(btrim(module)) > 0),
    enabled       boolean     NOT NULL,
    effective_from  timestamptz NOT NULL,
    effective_until timestamptz,
    granted_by    text        NOT NULL,
    created_at    timestamptz NOT NULL,
    updated_at    timestamptz NOT NULL,
    version       bigint      NOT NULL CHECK (version > 0),
    CONSTRAINT entitlement_window CHECK (effective_until IS NULL OR effective_until > effective_from)
);

-- Two rows for the same scope and module would make "is this enabled?" depend
-- on row order. Separate indexes because NULL is not equal to NULL, so one
-- index cannot cover both the tenant-wide and per-facility case.
CREATE UNIQUE INDEX entitlement_tenant_scope_key
    ON organization.entitlement (tenant_id, module, effective_from)
    WHERE facility_id IS NULL;

CREATE UNIQUE INDEX entitlement_facility_scope_key
    ON organization.entitlement (tenant_id, facility_id, module, effective_from)
    WHERE facility_id IS NOT NULL;

-- Tenant numbering sequences (SRS-PLT-014).
--
-- A counter row rather than a PostgreSQL SEQUENCE, deliberately. A sequence is
-- non-transactional: numbers are consumed even by transactions that roll back,
-- which is fine for a surrogate key and not fine for an invoice number a tax
-- authority expects to be gapless. A row updated with RETURNING is atomic,
-- serialises concurrent callers on the row lock, and rolls back with its
-- transaction.
--
-- The cost is that concurrent issuers contend on one row per (tenant, scope).
-- That is acceptable here: numbering happens once per document, not per query.
CREATE TABLE organization.number_sequence (
    sequence_id   uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    -- 'mrn', 'encounter', 'invoice', 'receipt', …
    scope         text        NOT NULL CHECK (length(btrim(scope)) > 0),
    -- Optional per-facility sequence; hospitals commonly want MRNs that say
    -- which site registered the patient.
    facility_id   uuid        REFERENCES organization.facility (facility_id),
    prefix        text        NOT NULL DEFAULT '',
    -- Zero-padded width of the numeric part. 0 means no padding.
    pad_width     integer     NOT NULL DEFAULT 0 CHECK (pad_width >= 0 AND pad_width <= 20),
    -- next_value is the number the next call will issue, not the last issued.
    -- Storing "next" makes the update a plain increment with no off-by-one at
    -- the boundary between an unused and a used sequence.
    next_value    bigint      NOT NULL CHECK (next_value > 0),
    -- A period key such as '2026' or '2026-04' resets numbering; NULL never
    -- resets. Stored rather than derived so a tenant on a fiscal year that is
    -- not the calendar year does not need special-case code.
    period_key    text        NOT NULL DEFAULT '',
    created_at    timestamptz NOT NULL,
    updated_at    timestamptz NOT NULL
);

CREATE UNIQUE INDEX number_sequence_tenant_scope_key
    ON organization.number_sequence (tenant_id, scope, period_key)
    WHERE facility_id IS NULL;

CREATE UNIQUE INDEX number_sequence_facility_scope_key
    ON organization.number_sequence (tenant_id, facility_id, scope, period_key)
    WHERE facility_id IS NOT NULL;

-- Facility calendars and holidays (SRS-PLT-016).
--
-- Independent of provider rosters on purpose: a hospital is closed on a public
-- holiday whether or not anybody was rostered, and a consultant's leave does
-- not close the hospital. Conflating the two produces a system where cancelling
-- a roster accidentally opens the building.
CREATE TABLE organization.facility_calendar_entry (
    entry_id      uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    facility_id   uuid        NOT NULL REFERENCES organization.facility (facility_id),
    entry_type    text        NOT NULL CHECK (entry_type IN
        ('holiday', 'closure', 'reduced_hours', 'special_opening')),
    -- Local dates, not instants: "closed on 2 October" is a statement about
    -- the facility's own calendar, and converting it to UTC would move the
    -- boundary for sites east of Greenwich.
    starts_on     date        NOT NULL,
    ends_on       date        NOT NULL,
    label         text        NOT NULL,
    -- Whether an authorised user may book into this period anyway. Emergency
    -- departments run through every holiday; an outpatient clinic does not.
    override_permitted boolean NOT NULL DEFAULT false,
    created_at    timestamptz NOT NULL,
    updated_at    timestamptz NOT NULL,
    CONSTRAINT facility_calendar_range CHECK (ends_on >= starts_on)
);

CREATE INDEX facility_calendar_lookup_idx
    ON organization.facility_calendar_entry (tenant_id, facility_id, starts_on, ends_on);

-- Multilingual display labels (SRS-PLT-017).
--
-- Labels never replace codes. The canonical code is what the system reasons
-- with, stores and exchanges; a label is a rendering of it for one locale. A
-- design that localises the code itself cannot round-trip an interface message
-- or compare two records from different locales.
CREATE TABLE organization.display_label (
    label_id      uuid        PRIMARY KEY,
    tenant_id     uuid        NOT NULL,
    -- What is being labelled: 'org_unit', 'entitlement.module', a value set
    -- name — the namespace of the code.
    code_system   text        NOT NULL,
    code          text        NOT NULL,
    -- BCP 47 tag: 'en', 'en-IN', 'hi', 'ta'.
    locale        text        NOT NULL CHECK (length(btrim(locale)) > 0),
    display       text        NOT NULL CHECK (length(btrim(display)) > 0),
    -- Shorter form for dense UI; falls back to display when absent.
    short_display text        NOT NULL DEFAULT '',
    created_at    timestamptz NOT NULL,
    updated_at    timestamptz NOT NULL
);

CREATE UNIQUE INDEX display_label_key
    ON organization.display_label (tenant_id, code_system, code, locale);
