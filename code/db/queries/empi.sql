-- Enterprise master patient index (SRS-EMPI).
--
-- Every statement here leads with tenant_id. That is not a convention: a query
-- that filters on patient_id alone would return another tenant's patient to a
-- caller who guessed a UUID, and the repository cannot even be called without
-- a verified tenant scope (FIT-03). The predicate is the second half of that.

-- name: InsertPatient :exec
INSERT INTO empi.patient (
    patient_id, tenant_id, registered_facility_id, status,
    family_name, given_names, name_prefix, name_suffix,
    birth_date, birth_date_precision, sex,
    phones, emails, addresses,
    created_at, updated_at, version
) VALUES (
    @patient_id, @tenant_id, @registered_facility_id, @status,
    @family_name, @given_names, @name_prefix, @name_suffix,
    sqlc.narg('birth_date')::date, @birth_date_precision, @sex,
    @phones, @emails, @addresses,
    @created_at, @updated_at, 1
);

-- name: GetPatient :one
SELECT patient_id, tenant_id, registered_facility_id, status,
       family_name, given_names, name_prefix, name_suffix,
       birth_date, birth_date_precision, sex, phones, emails, addresses,
       merged_into_patient_id,
       deceased_date, deceased_precision, deceased_source,
       deceased_recorded_at, deceased_recorded_by,
       created_at, updated_at, version
FROM empi.patient
WHERE tenant_id = @tenant_id AND patient_id = @patient_id;

-- name: UpdatePatientDemographics :execrows
-- Optimistic concurrency. Two clerks correcting one record at the same
-- registration desk is routine, and last-write-wins silently discards one of
-- their corrections.
UPDATE empi.patient
SET family_name = @family_name,
    given_names = @given_names,
    name_prefix = @name_prefix,
    name_suffix = @name_suffix,
    birth_date = sqlc.narg('birth_date')::date,
    birth_date_precision = @birth_date_precision,
    sex = @sex,
    phones = @phones,
    emails = @emails,
    addresses = @addresses,
    updated_at = @updated_at,
    version = version + 1
WHERE tenant_id = @tenant_id
  AND patient_id = @patient_id
  AND version = @expected_version
  -- Correcting the losing side of a merge writes to a record nobody reads.
  AND status <> 'merged';

-- name: SetPatientStatus :execrows
UPDATE empi.patient
SET status = @status, updated_at = @updated_at, version = version + 1
WHERE tenant_id = @tenant_id
  AND patient_id = @patient_id
  AND version = @expected_version;

-- name: InsertPatientIdentifier :exec
-- Relies on patient_identifier_active_value_key to refuse a value already held
-- by another patient. Checking first and inserting second is a race two
-- concurrent registrations both win (SRS-EMPI-016).
INSERT INTO empi.patient_identifier (
    identifier_id, tenant_id, patient_id, identifier_type, system, value,
    assigning_authority, status, source, is_primary, linked_at
) VALUES (
    @identifier_id, @tenant_id, @patient_id, @identifier_type, @system, @value,
    @assigning_authority, @status, @source, @is_primary, @linked_at
);

-- name: ListPatientIdentifiers :many
SELECT identifier_id, tenant_id, patient_id, identifier_type, system, value,
       assigning_authority, status, source, is_primary,
       linked_at, unlinked_at, superseded_by_id, reason
FROM empi.patient_identifier
WHERE tenant_id = @tenant_id AND patient_id = @patient_id
ORDER BY is_primary DESC, linked_at, identifier_id;

-- name: ListIdentifiersForPatients :many
-- Batch load for a search result. One query per patient would make a page of
-- twenty candidates twenty-one round trips.
SELECT identifier_id, tenant_id, patient_id, identifier_type, system, value,
       assigning_authority, status, source, is_primary,
       linked_at, unlinked_at, superseded_by_id, reason
FROM empi.patient_identifier
WHERE tenant_id = @tenant_id AND patient_id = ANY(@patient_ids::uuid[])
ORDER BY patient_id, is_primary DESC, linked_at;

-- name: FindPatientByIdentifier :many
-- Resolves an identifier a patient quoted.
--
-- Excludes revoked values and nothing else: a superseded MRN is on a discharge
-- summary printed last week, and a clerk typing it in has to reach this
-- patient. A revoked one belongs to somebody else and must not resolve.
SELECT p.patient_id, p.tenant_id, p.registered_facility_id, p.status,
       p.family_name, p.given_names, p.name_prefix, p.name_suffix,
       p.birth_date, p.birth_date_precision, p.sex, p.phones, p.emails, p.addresses,
       p.merged_into_patient_id,
       p.deceased_date, p.deceased_precision, p.deceased_source,
       p.deceased_recorded_at, p.deceased_recorded_by,
       p.created_at, p.updated_at, p.version
FROM empi.patient p
JOIN empi.patient_identifier i
  ON i.tenant_id = p.tenant_id AND i.patient_id = p.patient_id
WHERE p.tenant_id = @tenant_id
  AND i.identifier_type = @identifier_type
  AND i.system = @system
  AND i.value = @value
  AND i.status <> 'revoked'
ORDER BY p.updated_at DESC
LIMIT @page_limit;

-- name: FindIdentifierHolder :one
-- Who currently holds this identifier value, if anybody.
--
-- Used before linking, so a conflict is reported as "already linked to another
-- patient" rather than as a unique-violation SQLSTATE the transport would have
-- to guess at.
SELECT patient_id
FROM empi.patient_identifier
WHERE tenant_id = @tenant_id
  AND identifier_type = @identifier_type
  AND system = @system
  AND value = @value
  AND status = 'active';

-- name: SearchPatientCandidates :many
-- The blocking query for duplicate detection (SRS-EMPI-003, SRS-EMPI-004).
--
-- Scoring every patient in the tenant against a new registration is O(tenant)
-- per registration and unusable by the second week. This narrows to records
-- that share at least one strong, indexable signal — a birth date, a surname
-- prefix, a phone number — and the matcher scores only those.
--
-- Blocking is allowed to miss: a duplicate whose surname, birth date and phone
-- all differ is not findable by any index, and the merge workflow exists for
-- what search does not catch.
SELECT patient_id, tenant_id, registered_facility_id, status,
       family_name, given_names, name_prefix, name_suffix,
       birth_date, birth_date_precision, sex, phones, emails, addresses,
       merged_into_patient_id,
       deceased_date, deceased_precision, deceased_source,
       deceased_recorded_at, deceased_recorded_by,
       created_at, updated_at, version
FROM empi.patient
WHERE tenant_id = @tenant_id
  -- A merged record is not a candidate: its survivor is the one to match
  -- against, and offering both would invite a second merge of the same pair.
  AND status <> 'merged'
  AND patient_id <> COALESCE(sqlc.narg('exclude_patient_id')::uuid,
                             '00000000-0000-0000-0000-000000000000'::uuid)
  AND (
        (sqlc.narg('birth_date')::date IS NOT NULL AND birth_date = sqlc.narg('birth_date')::date)
     OR (sqlc.narg('family_prefix')::text IS NOT NULL
         AND lower(family_name) LIKE sqlc.narg('family_prefix')::text || '%')
     OR (sqlc.narg('phone')::text IS NOT NULL
         AND phones @> jsonb_build_array(jsonb_build_object('value', sqlc.narg('phone')::text)))
  )
ORDER BY updated_at DESC, patient_id
LIMIT @page_limit;

-- name: ListPatientsByName :many
-- Plain name search for the registration desk, cursor-paginated.
--
-- Keyset on (lower(family_name), patient_id) rather than OFFSET: a clerk
-- paging through results while registrations are happening would otherwise see
-- rows shift under them.
SELECT patient_id, tenant_id, registered_facility_id, status,
       family_name, given_names, name_prefix, name_suffix,
       birth_date, birth_date_precision, sex, phones, emails, addresses,
       merged_into_patient_id,
       deceased_date, deceased_precision, deceased_source,
       deceased_recorded_at, deceased_recorded_by,
       created_at, updated_at, version
FROM empi.patient
WHERE tenant_id = @tenant_id
  AND status <> 'merged'
  AND lower(family_name) LIKE lower(@family_prefix::text) || '%'
  AND (lower(family_name), patient_id) > (lower(@after_family::text), @after_id::uuid)
ORDER BY lower(family_name), patient_id
LIMIT @page_limit;

-- name: GetDemographicPolicy :one
-- The minimum set in force, facility first then jurisdiction (SRS-EMPI-001).
--
-- ORDER BY on the facility column puts the specific row first, so one query
-- answers both scopes rather than the application making two round trips and
-- choosing between them.
SELECT policy_id, tenant_id, jurisdiction, facility_id,
       required_fields, allow_unidentified, created_at, updated_at
FROM empi.demographic_policy
WHERE tenant_id = @tenant_id
  AND jurisdiction = @jurisdiction
  AND (facility_id IS NULL OR facility_id = @facility_id)
ORDER BY facility_id NULLS LAST
LIMIT 1;

-- name: UpsertDemographicPolicy :exec
INSERT INTO empi.demographic_policy (
    policy_id, tenant_id, jurisdiction, facility_id,
    required_fields, allow_unidentified, created_at, updated_at
) VALUES (
    @policy_id, @tenant_id, @jurisdiction, sqlc.narg('facility_id')::uuid,
    @required_fields, @allow_unidentified, @created_at, @updated_at
)
ON CONFLICT (tenant_id, jurisdiction,
             COALESCE(facility_id, '00000000-0000-0000-0000-000000000000'::uuid))
DO UPDATE SET
    required_fields = EXCLUDED.required_fields,
    allow_unidentified = EXCLUDED.allow_unidentified,
    updated_at = EXCLUDED.updated_at;

-- name: GetMatchConfig :one
SELECT tenant_id, weights, review_threshold, probable_threshold, updated_at, updated_by
FROM empi.match_config
WHERE tenant_id = @tenant_id;

-- name: UpsertMatchConfig :exec
INSERT INTO empi.match_config (
    tenant_id, weights, review_threshold, probable_threshold, updated_at, updated_by
) VALUES (
    @tenant_id, @weights, @review_threshold, @probable_threshold, @updated_at, @updated_by
)
ON CONFLICT (tenant_id) DO UPDATE SET
    weights = EXCLUDED.weights,
    review_threshold = EXCLUDED.review_threshold,
    probable_threshold = EXCLUDED.probable_threshold,
    updated_at = EXCLUDED.updated_at,
    updated_by = EXCLUDED.updated_by;
