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
    assigning_authority, status, source, is_primary, linked_at,
    assurance, verified_at
) VALUES (
    @identifier_id, @tenant_id, @patient_id, @identifier_type, @system, @value,
    @assigning_authority, @status, @source, @is_primary, @linked_at,
    @assurance, @verified_at
);

-- name: ListPatientIdentifiers :many
SELECT identifier_id, tenant_id, patient_id, identifier_type, system, value,
       assigning_authority, status, source, is_primary,
       linked_at, unlinked_at, superseded_by_id, reason,
       assurance, verified_at
FROM empi.patient_identifier
WHERE tenant_id = @tenant_id AND patient_id = @patient_id
ORDER BY is_primary DESC, linked_at, identifier_id;

-- name: ListIdentifiersForPatients :many
-- Batch load for a search result. One query per patient would make a page of
-- twenty candidates twenty-one round trips.
SELECT identifier_id, tenant_id, patient_id, identifier_type, system, value,
       assigning_authority, status, source, is_primary,
       linked_at, unlinked_at, superseded_by_id, reason,
       assurance, verified_at
FROM empi.patient_identifier
WHERE tenant_id = @tenant_id AND patient_id = ANY(@patient_ids::uuid[])
ORDER BY patient_id, is_primary DESC, linked_at;

-- name: GetPatientIdentifier :one
-- One identifier by its own id, so unlinking need not load a patient's whole
-- set and scan it.
SELECT identifier_id, tenant_id, patient_id, identifier_type, system, value,
       assigning_authority, status, source, is_primary,
       linked_at, unlinked_at, superseded_by_id, reason,
       assurance, verified_at
FROM empi.patient_identifier
WHERE tenant_id = @tenant_id AND identifier_id = @identifier_id;

-- name: RetirePatientIdentifier :execrows
-- Supersedes or revokes an identifier, keeping the row.
--
-- There is no delete on this table. SRS-EMPI-011 requires link and unlink
-- history to be retained, and an investigator asking "what did this patient's
-- wristband say in March, and who said so" needs the row that was retired, not
-- its absence.
--
-- Guarded on status = 'active': two concurrent unlinks would otherwise both
-- write, and the second would overwrite the first one's reason with its own.
UPDATE empi.patient_identifier
SET status          = @status,
    reason          = @reason,
    unlinked_at     = @unlinked_at,
    superseded_by_id = @superseded_by_id,
    is_primary      = false
WHERE tenant_id = @tenant_id
  AND identifier_id = @identifier_id
  AND status = 'active';

-- name: RecordIdentifierVerification :execrows
-- Stores an issuing authority's confirmation against a linked identifier.
--
-- Only while active: verifying a revoked identifier would assert that a value
-- known to belong elsewhere belongs here.
UPDATE empi.patient_identifier
SET assurance           = 'verified',
    verified_at         = @verified_at,
    assigning_authority = @assigning_authority
WHERE tenant_id = @tenant_id
  AND identifier_id = @identifier_id
  AND status = 'active';

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
-- Matches the name the patient holds now *or* any name they have held before
-- (SRS-EMPI-007). Searching only the current name is how a result addressed to
-- a maiden name finds nobody and becomes a second record.
--
-- Keyset on (lower(family_name), patient_id) rather than OFFSET: a clerk
-- paging through results while registrations are happening would otherwise see
-- rows shift under them.
SELECT p.patient_id, p.tenant_id, p.registered_facility_id, p.status,
       p.family_name, p.given_names, p.name_prefix, p.name_suffix,
       p.birth_date, p.birth_date_precision, p.sex, p.phones, p.emails, p.addresses,
       p.merged_into_patient_id,
       p.deceased_date, p.deceased_precision, p.deceased_source,
       p.deceased_recorded_at, p.deceased_recorded_by,
       p.created_at, p.updated_at, p.version
FROM empi.patient p
WHERE p.tenant_id = @tenant_id
  AND p.status <> 'merged'
  AND (
        lower(p.family_name) LIKE lower(@family_prefix::text) || '%'
        -- EXISTS rather than a join: a patient who has held three names that
        -- all match the prefix is still one row, and the keyset below stays a
        -- total order over empi.patient alone.
     OR EXISTS (
          SELECT 1
          FROM empi.patient_name n
          WHERE n.tenant_id = p.tenant_id
            AND n.patient_id = p.patient_id
            AND lower(n.family_name) LIKE lower(@family_prefix::text) || '%'
        )
      )
  AND (lower(p.family_name), p.patient_id) > (lower(@after_family::text), @after_id::uuid)
ORDER BY lower(p.family_name), p.patient_id
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

-- Merge journal and duplicate review (SRS-EMPI-004/005/006).

-- name: InsertMergeRecord :exec
INSERT INTO empi.merge_journal (
    merge_id, tenant_id, survivor_id, merged_id, merged_previous_status,
    reason, performed_by, performed_at, moved_identifiers, carried_deceased
) VALUES (
    @merge_id, @tenant_id, @survivor_id, @merged_id, @merged_previous_status,
    @reason, @performed_by, @performed_at, @moved_identifiers, @carried_deceased
);

-- name: GetMergeRecord :one
SELECT merge_id, tenant_id, survivor_id, merged_id, merged_previous_status,
       reason, performed_by, performed_at, moved_identifiers, carried_deceased,
       undone, undone_by, undone_at, undo_reason
FROM empi.merge_journal
WHERE tenant_id = @tenant_id AND merge_id = @merge_id;

-- name: GetStandingMergeForLoser :one
-- The merge that currently holds this record down, if any.
SELECT merge_id, tenant_id, survivor_id, merged_id, merged_previous_status,
       reason, performed_by, performed_at, moved_identifiers, carried_deceased,
       undone, undone_by, undone_at, undo_reason
FROM empi.merge_journal
WHERE tenant_id = @tenant_id AND merged_id = @merged_id AND NOT undone;

-- name: CountLaterMergesIntoSurvivor :one
-- Whether another merge into this survivor came after the one being reversed.
--
-- Reversing an earlier merge while a later one stands would restore
-- identifiers the later merge has already moved again, and the second merge's
-- journal would then describe a state that no longer exists.
SELECT count(*)
FROM empi.merge_journal
WHERE tenant_id = @tenant_id
  AND survivor_id = @survivor_id
  AND NOT undone
  AND performed_at > @after;

-- name: MarkMergeUndone :execrows
UPDATE empi.merge_journal
SET undone = true, undone_by = @undone_by, undone_at = @undone_at, undo_reason = @undo_reason
WHERE tenant_id = @tenant_id AND merge_id = @merge_id AND NOT undone;

-- name: MoveIdentifierToPatient :execrows
-- Re-points one identifier at another patient.
--
-- Used by a merge to move the losing record's identifiers to the survivor, and
-- by an unmerge to put them back. The status travels with the move: a merged
-- MRN arrives superseded so the survivor's own stays the one on the wristband,
-- and an unmerge restores whatever the journal says it was.
UPDATE empi.patient_identifier
SET patient_id = @patient_id,
    status = @status,
    is_primary = @is_primary,
    reason = @reason,
    -- Both arms are cast: without them PostgreSQL infers the parameter's type
    -- from the comparison above and decides unlinked_at is text.
    unlinked_at = CASE WHEN @status::text = 'active'
                       THEN NULL::timestamptz
                       ELSE @unlinked_at::timestamptz END
WHERE tenant_id = @tenant_id AND identifier_id = @identifier_id;

-- name: SetPatientMergedInto :execrows
UPDATE empi.patient
SET status = @status,
    merged_into_patient_id = sqlc.narg('merged_into_patient_id')::uuid,
    updated_at = @updated_at,
    version = version + 1
WHERE tenant_id = @tenant_id
  AND patient_id = @patient_id
  AND version = @expected_version;

-- name: SetPatientDeceased :execrows
UPDATE empi.patient
SET deceased_date = sqlc.narg('deceased_date')::date,
    deceased_precision = @deceased_precision,
    deceased_source = @deceased_source,
    deceased_recorded_at = sqlc.narg('deceased_recorded_at')::timestamptz,
    deceased_recorded_by = @deceased_recorded_by,
    updated_at = @updated_at,
    version = version + 1
WHERE tenant_id = @tenant_id AND patient_id = @patient_id;

-- name: UpsertDuplicateCandidate :exec
-- Queues a pair for review, or leaves an existing decision alone.
--
-- DO NOTHING rather than DO UPDATE on purpose: re-detecting a pair that was
-- already dismissed must not reopen it. A decision already taken is not a new
-- question, and reopening it would put the same pair in front of HIM every
-- time either record is touched.
INSERT INTO empi.duplicate_candidate (
    candidate_id, tenant_id, patient_a_id, patient_b_id,
    score, outcome, status, detected_by, detected_at
) VALUES (
    @candidate_id, @tenant_id, @patient_a_id, @patient_b_id,
    @score, @outcome, 'open', @detected_by, @detected_at
)
ON CONFLICT (tenant_id, patient_a_id, patient_b_id) DO NOTHING;

-- name: GetDuplicateCandidate :one
SELECT candidate_id, tenant_id, patient_a_id, patient_b_id, score, outcome,
       status, detected_by, detected_at, reviewed_by, reviewed_at, resolution
FROM empi.duplicate_candidate
WHERE tenant_id = @tenant_id AND candidate_id = @candidate_id;

-- name: FindDuplicateCandidateByPair :one
SELECT candidate_id, tenant_id, patient_a_id, patient_b_id, score, outcome,
       status, detected_by, detected_at, reviewed_by, reviewed_at, resolution
FROM empi.duplicate_candidate
WHERE tenant_id = @tenant_id AND patient_a_id = @patient_a_id AND patient_b_id = @patient_b_id;

-- name: ListOpenDuplicateCandidates :many
-- The review worklist, strongest first: that is the pair most likely to be one
-- person, and the one whose being wrong costs the most.
SELECT candidate_id, tenant_id, patient_a_id, patient_b_id, score, outcome,
       status, detected_by, detected_at, reviewed_by, reviewed_at, resolution
FROM empi.duplicate_candidate
WHERE tenant_id = @tenant_id AND status = 'open'
ORDER BY score DESC, detected_at, candidate_id
LIMIT @page_limit;

-- name: CloseDuplicateCandidate :execrows
UPDATE empi.duplicate_candidate
SET status = @status, reviewed_by = @reviewed_by,
    reviewed_at = @reviewed_at, resolution = @resolution
WHERE tenant_id = @tenant_id AND candidate_id = @candidate_id AND status = 'open';

-- Demographic history, preferences and related persons (SRS-EMPI-007/009).

-- name: InsertPatientName :exec
INSERT INTO empi.patient_name (
    name_id, tenant_id, patient_id, kind,
    family_name, given_names, name_prefix, name_suffix,
    effective_from, effective_until, recorded_by, recorded_at, source
) VALUES (
    @name_id, @tenant_id, @patient_id, @kind,
    @family_name, @given_names, @name_prefix, @name_suffix,
    @effective_from, sqlc.narg('effective_until')::timestamptz,
    @recorded_by, @recorded_at, @source
);

-- name: CloseOpenPatientName :execrows
-- Ends the current window rather than overwriting the row.
--
-- An overwrite would lose the interval the old name applied to, which is the
-- one fact a misfiled result needs: what this patient was called in March.
UPDATE empi.patient_name
SET effective_until = @effective_until
WHERE tenant_id = @tenant_id
  AND patient_id = @patient_id
  AND kind = @kind
  AND effective_until IS NULL
  -- A window that would end before it began is a clock problem, not a rename.
  AND effective_from < @effective_until;

-- name: ListPatientNames :many
SELECT name_id, tenant_id, patient_id, kind,
       family_name, given_names, name_prefix, name_suffix,
       effective_from, effective_until, recorded_by, recorded_at, source
FROM empi.patient_name
WHERE tenant_id = @tenant_id AND patient_id = @patient_id
ORDER BY kind, effective_from DESC, name_id;

-- name: MatchingFormerNames :many
-- The former names that caused these patients to appear in a name search.
--
-- A row reached through a maiden name scores low against the current name, so
-- without this the clerk sees an apparently irrelevant result and dismisses
-- it. Naming the name that matched is what makes the row actionable.
--
-- Only closed names: a name still in force is the current one, and saying
-- "matched former name" about it would be wrong.
SELECT name_id, patient_id, kind, family_name, given_names,
       name_prefix, name_suffix, effective_from, effective_until,
       source, recorded_by, recorded_at
FROM empi.patient_name
WHERE tenant_id = @tenant_id
  AND patient_id = ANY (@patient_ids::uuid[])
  AND effective_until IS NOT NULL
  AND lower(family_name) LIKE lower(@family_prefix::text) || '%'
ORDER BY patient_id, effective_until DESC;

-- name: InsertCommunicationPreference :exec
INSERT INTO empi.communication_preference (
    preference_id, tenant_id, patient_id, channel, purpose, allowed,
    effective_from, effective_until, recorded_by, recorded_at
) VALUES (
    @preference_id, @tenant_id, @patient_id, @channel, @purpose, @allowed,
    @effective_from, sqlc.narg('effective_until')::timestamptz, @recorded_by, @recorded_at
);

-- name: CloseOpenCommunicationPreference :execrows
UPDATE empi.communication_preference
SET effective_until = @effective_until
WHERE tenant_id = @tenant_id
  AND patient_id = @patient_id
  AND channel = @channel
  AND purpose = @purpose
  AND effective_until IS NULL
  AND effective_from < @effective_until;

-- name: ListCommunicationPreferences :many
SELECT preference_id, tenant_id, patient_id, channel, purpose, allowed,
       effective_from, effective_until, recorded_by, recorded_at
FROM empi.communication_preference
WHERE tenant_id = @tenant_id AND patient_id = @patient_id
ORDER BY channel, purpose, effective_from DESC;

-- name: InsertRelatedPerson :exec
INSERT INTO empi.related_person (
    relationship_id, tenant_id, patient_id, related_patient_id,
    family_name, given_names, contact, relationship, authorities,
    effective_from, effective_until,
    verified_by, verified_at, verification_note, recorded_by, recorded_at
) VALUES (
    @relationship_id, @tenant_id, @patient_id, sqlc.narg('related_patient_id')::uuid,
    @family_name, @given_names, @contact, @relationship, @authorities,
    @effective_from, sqlc.narg('effective_until')::timestamptz,
    @verified_by, sqlc.narg('verified_at')::timestamptz, @verification_note,
    @recorded_by, @recorded_at
);

-- name: VerifyRelatedPerson :execrows
-- Records that somebody checked the claim, and what they saw.
--
-- Only an unverified relationship may be verified: re-verifying would overwrite
-- the note saying what was originally checked, which is the part that holds up.
UPDATE empi.related_person
SET verified_by = @verified_by,
    verified_at = @verified_at,
    verification_note = @verification_note
WHERE tenant_id = @tenant_id
  AND relationship_id = @relationship_id
  AND verified_at IS NULL;

-- name: EndRelatedPerson :execrows
UPDATE empi.related_person
SET effective_until = @effective_until
WHERE tenant_id = @tenant_id
  AND relationship_id = @relationship_id
  AND effective_until IS NULL
  AND effective_from < @effective_until;

-- name: ListRelatedPersons :many
SELECT relationship_id, tenant_id, patient_id, related_patient_id,
       family_name, given_names, contact, relationship, authorities,
       effective_from, effective_until,
       verified_by, verified_at, verification_note, recorded_by, recorded_at
FROM empi.related_person
WHERE tenant_id = @tenant_id AND patient_id = @patient_id
ORDER BY effective_from DESC, relationship_id;

-- name: ListRelationshipsHeldBy :many
-- What this person may do for other patients: the reverse direction, which is
-- the question an authorization check asks.
SELECT relationship_id, tenant_id, patient_id, related_patient_id,
       family_name, given_names, contact, relationship, authorities,
       effective_from, effective_until,
       verified_by, verified_at, verification_note, recorded_by, recorded_at
FROM empi.related_person
WHERE tenant_id = @tenant_id
  AND related_patient_id = @related_patient_id
  AND patient_id = @patient_id;

-- name: InsertDemographicProposal :exec
INSERT INTO empi.demographic_proposal (
    proposal_id, tenant_id, patient_id, origin, source, proposed_by, reason,
    status, patient_version, proposed_at
) VALUES (
    @proposal_id, @tenant_id, @patient_id, @origin, @source, @proposed_by, @reason,
    @status, @patient_version, @proposed_at
);

-- name: InsertDemographicProposalField :exec
INSERT INTO empi.demographic_proposal_field (
    proposal_id, tenant_id, field, current_value, proposed_value
) VALUES (
    @proposal_id, @tenant_id, @field, @current_value, @proposed_value
);

-- name: GetDemographicProposal :one
SELECT proposal_id, tenant_id, patient_id, origin, source, proposed_by, reason,
       status, patient_version, proposed_at, resolved_at, resolved_by, resolution_note
FROM empi.demographic_proposal
WHERE tenant_id = @tenant_id AND proposal_id = @proposal_id;

-- name: FindOpenProposalBySource :one
-- The nightly-feed case. A source that keeps disagreeing must refresh its one
-- open item rather than add another: fifty identical items are one conflict and
-- a reviewer who has stopped reading the queue.
SELECT proposal_id, tenant_id, patient_id, origin, source, proposed_by, reason,
       status, patient_version, proposed_at, resolved_at, resolved_by, resolution_note
FROM empi.demographic_proposal
WHERE tenant_id = @tenant_id AND patient_id = @patient_id
  AND source = @source AND status = 'open';

-- name: ListOpenDemographicProposals :many
-- The reconciliation worklist. Oldest first: a conflict that has waited three
-- weeks is the one most likely to have been forgotten.
SELECT proposal_id, tenant_id, patient_id, origin, source, proposed_by, reason,
       status, patient_version, proposed_at, resolved_at, resolved_by, resolution_note
FROM empi.demographic_proposal
WHERE tenant_id = @tenant_id AND status = 'open'
ORDER BY proposed_at, proposal_id
LIMIT @page_limit;

-- name: ListProposalsForPatient :many
-- Everything ever proposed about one patient, newest first. Includes rejections
-- and withdrawals: that a value was offered and refused is the answer when the
-- same value arrives again.
SELECT proposal_id, tenant_id, patient_id, origin, source, proposed_by, reason,
       status, patient_version, proposed_at, resolved_at, resolved_by, resolution_note
FROM empi.demographic_proposal
WHERE tenant_id = @tenant_id AND patient_id = @patient_id
ORDER BY proposed_at DESC, proposal_id
LIMIT @page_limit;

-- name: ListProposalFields :many
SELECT proposal_id, field, current_value, proposed_value, accepted
FROM empi.demographic_proposal_field
WHERE tenant_id = @tenant_id AND proposal_id = ANY(@proposal_ids::uuid[])
ORDER BY proposal_id, field;

-- name: ResolveDemographicProposal :execrows
-- Guarded on status = 'open': two reviewers deciding at once would otherwise
-- both write, and the second would silently replace the first one's decision
-- and note.
UPDATE empi.demographic_proposal
SET status          = @status,
    resolved_at     = @resolved_at,
    resolved_by     = @resolved_by,
    resolution_note = @resolution_note
WHERE tenant_id = @tenant_id
  AND proposal_id = @proposal_id
  AND status = 'open';

-- name: SetProposalFieldDecision :exec
UPDATE empi.demographic_proposal_field
SET accepted = @accepted
WHERE tenant_id = @tenant_id AND proposal_id = @proposal_id AND field = @field;

-- name: SupersedeOpenProposalsForPatient :execrows
-- Closes proposals whose comparison no longer holds.
--
-- Run when the record changes for an unrelated reason. Leaving them open would
-- show a reviewer "on file: X" against a record that now says Y, and accepting
-- would overwrite Y with a value nobody compared it against — the silent
-- overwrite SRS-EMPI-012 exists to prevent, arriving through the mechanism
-- meant to prevent it.
UPDATE empi.demographic_proposal
SET status          = 'superseded',
    resolved_at     = @resolved_at,
    resolved_by     = @resolved_by,
    resolution_note = 'the record changed after this was raised'
WHERE tenant_id = @tenant_id
  AND patient_id = @patient_id
  AND status = 'open'
  AND patient_version <> @patient_version;
