-- 0011 Enterprise master patient index (SRS-EMPI, Wave 1 Sprint 1).
--
-- The shape of this schema is one decision repeated: the internal patient id is
-- opaque and immutable, and every identifier a human ever sees lives in its own
-- table with its own lifecycle (SRS-EMPI-002).
--
-- That is not tidiness. An MRN is printed on a wristband, quoted down a phone,
-- corrected for a transposed digit and superseded by a merge; a national health
-- identifier is linked and unlinked by an adapter. A clinical record keyed on
-- any of them follows every one of those changes, and one of them leads to the
-- wrong patient. So patient.patient_id is a UUID nobody outside this system
-- ever types, and it never changes — not for a merge, not for a correction.
--
-- The losing side of a merge is never deleted. Every note, order and result
-- written against it still references it, and merged_into_patient_id is what
-- makes those readable (SRS-EMPI-005).
--
-- Trace: SRS-EMPI-001, SRS-EMPI-002, SRS-EMPI-003, SRS-EMPI-004, SRS-EMPI-008,
--        SRS-DAT-001 (tenant-leading access paths), SRS-SEC-004 (audited reads).
--
-- Rollback: drops the patient index. This destroys the link between every
--   clinical record and the person it belongs to, which no backup of a later
--   schema can reconstruct — the down migration exists for a failed deploy on
--   an empty database and for nothing else. Anywhere with data, restore.
-- Reconciliation: none for the forward direction; these tables are new.

CREATE SCHEMA IF NOT EXISTS empi;

-- The demographic minimum set, per jurisdiction and optionally per facility
-- (SRS-EMPI-001).
--
-- Configuration rather than a NOT NULL constraint, because the requirement is
-- that the minimum is "configured by jurisdiction/facility": a government
-- hospital in one state must capture an identifier a private clinic in another
-- is not permitted to ask for, and an emergency department must be able to
-- register an unconscious patient with no name at all. A column constraint can
-- express exactly one of those.
CREATE TABLE empi.demographic_policy (
    policy_id      uuid        PRIMARY KEY,
    tenant_id      uuid        NOT NULL,
    jurisdiction   text        NOT NULL,
    -- NULL means every facility in the jurisdiction; a row naming one overrides.
    facility_id    uuid,
    required_fields text[]     NOT NULL DEFAULT '{}',
    -- Permits registration with none of the required fields, for the
    -- unconscious-patient case. Separate from an empty required list because
    -- "this facility requires nothing" and "this facility requires a name
    -- unless the patient cannot give one" are different policies.
    allow_unidentified boolean NOT NULL DEFAULT false,
    created_at     timestamptz NOT NULL,
    updated_at     timestamptz NOT NULL
);

-- COALESCE gives the tenant-wide and facility-specific rows one uniqueness key,
-- so a facility cannot accumulate two conflicting policies.
CREATE UNIQUE INDEX demographic_policy_scope_key
    ON empi.demographic_policy (
        tenant_id, jurisdiction,
        COALESCE(facility_id, '00000000-0000-0000-0000-000000000000'::uuid)
    );

-- Duplicate-detection configuration (SRS-EMPI-004).
--
-- Weights are configurable because the right ones depend on the population: in
-- a catchment where a handful of surnames cover most of the register, a name
-- match means far less than a phone match, and a tenant that cannot tune this
-- either drowns in false positives or misses real duplicates.
CREATE TABLE empi.match_config (
    tenant_id           uuid        PRIMARY KEY,
    weights             jsonb       NOT NULL,
    review_threshold    numeric(4,3) NOT NULL CHECK (review_threshold BETWEEN 0 AND 1),
    probable_threshold  numeric(4,3) NOT NULL CHECK (probable_threshold BETWEEN 0 AND 1),
    -- Inverted thresholds would make the manual-review band unreachable and
    -- silently downgrade every real duplicate to a warning.
    CONSTRAINT match_thresholds_ordered CHECK (probable_threshold >= review_threshold),
    updated_at          timestamptz NOT NULL,
    updated_by          text        NOT NULL
);

CREATE TABLE empi.patient (
    -- Opaque, internal, immutable. Never printed, never quoted, never changed.
    patient_id             uuid        PRIMARY KEY,
    tenant_id              uuid        NOT NULL,
    -- Where the patient first presented. Scopes the MRN series; does NOT scope
    -- access, because a patient registered at one site is treated at another.
    registered_facility_id uuid        NOT NULL,

    status                 text        NOT NULL CHECK (status IN (
                               'candidate', 'active', 'merged', 'inactive')),

    -- Demographics are stored as columns rather than a document because the
    -- matcher reads them field by field and the search index is built over
    -- them. A jsonb blob would make every search a full scan.
    family_name            text        NOT NULL DEFAULT '',
    given_names            text[]      NOT NULL DEFAULT '{}',
    name_prefix            text        NOT NULL DEFAULT '',
    name_suffix            text        NOT NULL DEFAULT '',
    birth_date             date,
    -- The precision travels with the date. "About forty years old" stored as
    -- 1 January is a false precision the matcher would then treat as a strong
    -- signal.
    birth_date_precision   text        NOT NULL DEFAULT '' CHECK (
                               birth_date_precision IN ('', 'day', 'month', 'year', 'estimated')),
    CONSTRAINT birth_date_has_precision CHECK (
        birth_date IS NULL OR birth_date_precision <> ''),

    sex                    text        NOT NULL DEFAULT 'unknown' CHECK (
                               sex IN ('unknown', 'female', 'male', 'other')),

    -- Contact points and addresses are documents: they are displayed and
    -- matched as wholes, never filtered on individually, and a normalised
    -- table for them would be three joins for every banner.
    phones                 jsonb       NOT NULL DEFAULT '[]'::jsonb,
    emails                 jsonb       NOT NULL DEFAULT '[]'::jsonb,
    addresses              jsonb       NOT NULL DEFAULT '[]'::jsonb,

    merged_into_patient_id uuid        REFERENCES empi.patient (patient_id),
    -- A merged record must name its survivor, and a live one must not.
    CONSTRAINT merged_records_name_a_survivor CHECK (
        (status = 'merged') = (merged_into_patient_id IS NOT NULL)),
    -- A record cannot be merged into itself: the resolver would loop.
    CONSTRAINT merge_is_not_self_referential CHECK (
        merged_into_patient_id IS NULL OR merged_into_patient_id <> patient_id),

    deceased_date          date,
    deceased_precision     text        NOT NULL DEFAULT '' CHECK (
                               deceased_precision IN ('', 'day', 'month', 'year', 'estimated')),
    -- Who says so. A national registry feed can be wrong about the wrong
    -- patient, and reversing it needs to know what claimed it (SRS-EMPI-008).
    deceased_source        text        NOT NULL DEFAULT '',
    deceased_recorded_at   timestamptz,
    deceased_recorded_by   text        NOT NULL DEFAULT '',
    CONSTRAINT deceased_has_provenance CHECK (
        deceased_recorded_at IS NULL OR deceased_source <> ''),

    created_at             timestamptz NOT NULL,
    updated_at             timestamptz NOT NULL,
    version                bigint      NOT NULL DEFAULT 1
);

-- Tenant-leading, as every access path in this system must be (SRS-DAT-001).
CREATE INDEX patient_tenant_status_idx
    ON empi.patient (tenant_id, status, updated_at DESC);

-- The blocking index for duplicate search. Comparing a new registration
-- against every patient in the tenant is O(n) per registration; comparing it
-- against everyone sharing a birth date, or a soundalike surname, is not.
CREATE INDEX patient_tenant_birthdate_idx
    ON empi.patient (tenant_id, birth_date)
    WHERE birth_date IS NOT NULL AND status <> 'merged';

-- Fuzzy name search (SRS-EMPI-003). lower() rather than a case-insensitive
-- collation so the index is usable by a LIKE prefix as well as by equality.
CREATE INDEX patient_tenant_family_name_idx
    ON empi.patient (tenant_id, lower(family_name))
    WHERE status <> 'merged';

-- Resolving a reference written before a merge.
CREATE INDEX patient_merged_into_idx
    ON empi.patient (merged_into_patient_id)
    WHERE merged_into_patient_id IS NOT NULL;

CREATE TABLE empi.patient_identifier (
    identifier_id       uuid        PRIMARY KEY,
    tenant_id           uuid        NOT NULL,
    patient_id          uuid        NOT NULL REFERENCES empi.patient (patient_id),

    identifier_type     text        NOT NULL CHECK (identifier_type IN (
                            'mrn', 'national_health', 'government', 'insurance', 'external')),
    -- Namespaces the value. Two facilities both issuing "MRN 1001" are two
    -- different patients, and without a system they collide.
    system              text        NOT NULL,
    value               text        NOT NULL,
    assigning_authority text        NOT NULL DEFAULT '',

    status              text        NOT NULL CHECK (status IN (
                            'active', 'superseded', 'revoked')),
    -- Where this system learned the value: a registration desk, an ABDM
    -- adapter, a merge. SRS-EMPI-011 requires link history and source retained.
    source              text        NOT NULL,
    is_primary          boolean     NOT NULL DEFAULT false,

    linked_at           timestamptz NOT NULL,
    unlinked_at         timestamptz,
    superseded_by_id    uuid        REFERENCES empi.patient_identifier (identifier_id),
    reason              text        NOT NULL DEFAULT '',

    -- An identifier that left active use records when and why. "What did this
    -- patient's wristband say in March" needs an interval, not a flag.
    CONSTRAINT retired_identifiers_explain_themselves CHECK (
        status = 'active' OR (unlinked_at IS NOT NULL AND reason <> '')),
    CONSTRAINT active_identifiers_are_current CHECK (
        status <> 'active' OR unlinked_at IS NULL)
);

-- One active holder per identifier value, per tenant.
--
-- This is the constraint that makes SRS-EMPI-016 ("prevent duplicate MRN
-- assignment under concurrent registration") a property of the database rather
-- than of a check-then-insert that two transactions can both pass. Partial on
-- active because a superseded MRN is deliberately still present.
CREATE UNIQUE INDEX patient_identifier_active_value_key
    ON empi.patient_identifier (tenant_id, identifier_type, system, value)
    WHERE status = 'active';

-- Search by any identifier the patient ever had, including superseded ones: a
-- discharge summary printed last week quotes one, and a clerk typing it in has
-- to reach this patient.
CREATE INDEX patient_identifier_lookup_idx
    ON empi.patient_identifier (tenant_id, identifier_type, system, value)
    WHERE status <> 'revoked';

CREATE INDEX patient_identifier_patient_idx
    ON empi.patient_identifier (tenant_id, patient_id, status);

-- At most one primary MRN per patient, so a banner has one answer.
CREATE UNIQUE INDEX patient_identifier_one_primary_key
    ON empi.patient_identifier (tenant_id, patient_id)
    WHERE is_primary AND status = 'active';
