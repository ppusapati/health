-- Mortuary operations (SRS-MORT-001 … 008).
--
-- Every statement is tenant-scoped in its WHERE clause. The adapter cannot be
-- called without authctx.TenantScope and the scope's tenant is what lands in
-- @tenant_id, so a cross-tenant read is not a thing a caller can ask for
-- (ADR-0001, FIT-03).
--
-- There is no UPDATE and no DELETE against mortuary.custody_entry. A chain of
-- custody somebody can edit says whatever the last person to touch it wanted
-- it to say (FIT-08).
--
-- There is no statement that selects cause_summary onto a list. It is read
-- one case at a time, under its own permission, and audited every time
-- (SRS-MORT-003). A board query that returned it would put a cause of death
-- on a screen in a corridor.

-- name: InsertMortuaryCase :exec
INSERT INTO mortuary.case (
    case_id, tenant_id, reference, source, encounter_id, patient_id,
    external_source, identity, identified_by, identified_at,
    identified_note, display_name, medico_legal, mlc_reference, restricted,
    cause_summary, death_certificate_ref, certificate_recorded_by,
    certificate_recorded_at, state, location_id, storage_tag, died_at,
    received_at, received_by, facility_id, created_at, created_by, version
) VALUES (
    @case_id, @tenant_id, @reference, @source, @encounter_id, @patient_id,
    @external_source, @identity, @identified_by, @identified_at,
    @identified_note, @display_name, @medico_legal, @mlc_reference,
    @restricted, @cause_summary, @death_certificate_ref,
    @certificate_recorded_by, @certificate_recorded_at, @state,
    @location_id, @storage_tag, @died_at, @received_at, @received_by,
    @facility_id, @created_at, @created_by, @version
);

-- name: GetMortuaryCase :one
SELECT * FROM mortuary.case
WHERE tenant_id = @tenant_id AND case_id = @case_id;

-- name: GetMortuaryCaseByReference :one
SELECT * FROM mortuary.case
WHERE tenant_id = @tenant_id AND upper(reference) = upper(@reference::text);

-- name: UpdateMortuaryCase :execrows
UPDATE mortuary.case
SET identity = @identity, identified_by = @identified_by,
    identified_at = @identified_at, identified_note = @identified_note,
    display_name = @display_name, medico_legal = @medico_legal,
    mlc_reference = @mlc_reference, restricted = @restricted,
    cause_summary = @cause_summary,
    death_certificate_ref = @death_certificate_ref,
    certificate_recorded_by = @certificate_recorded_by,
    certificate_recorded_at = @certificate_recorded_at,
    state = @state, location_id = @location_id, storage_tag = @storage_tag,
    version = version + 1
WHERE tenant_id = @tenant_id AND case_id = @case_id
  AND version = @expected_version;

-- name: ListMortuaryCases :many
SELECT * FROM mortuary.case
WHERE tenant_id = @tenant_id
  AND (cardinality(@states::text[]) = 0 OR state = ANY(@states::text[]))
  AND (cardinality(@identities::text[]) = 0
       OR identity = ANY(@identities::text[]))
  AND (@facility_id::text = '' OR facility_id = @facility_id::uuid)
  AND (NOT @medico_legal_only::boolean OR medico_legal)
  AND received_at >= @window_from AND received_at < @window_to
ORDER BY received_at
LIMIT @row_limit OFFSET @row_offset;

-- name: InsertMortuaryLocation :exec
INSERT INTO mortuary.location (
    location_id, tenant_id, code, kind, facility_id, zone, out_of_service,
    out_of_service_reason, created_at, created_by, version
) VALUES (
    @location_id, @tenant_id, @code, @kind, @facility_id, @zone,
    @out_of_service, @out_of_service_reason, @created_at, @created_by,
    @version
);

-- name: GetMortuaryLocation :one
SELECT * FROM mortuary.location
WHERE tenant_id = @tenant_id AND location_id = @location_id;

-- name: UpdateMortuaryLocation :execrows
UPDATE mortuary.location
SET out_of_service = @out_of_service,
    out_of_service_reason = @out_of_service_reason, version = version + 1
WHERE tenant_id = @tenant_id AND location_id = @location_id
  AND version = @expected_version;

-- name: ListMortuaryLocations :many
SELECT * FROM mortuary.location
WHERE tenant_id = @tenant_id
  AND (@facility_id::text = '' OR facility_id = @facility_id::uuid)
  AND (cardinality(@kinds::text[]) = 0 OR kind = ANY(@kinds::text[]))
  AND (NOT @in_service_only::boolean OR NOT out_of_service)
ORDER BY zone, code
LIMIT @row_limit OFFSET @row_offset;

-- name: InsertPlacement :exec
INSERT INTO mortuary.placement (
    placement_id, tenant_id, case_id, location_id, storage_tag, state,
    identity_checked_by, identity_checked_note, placed_at, placed_by,
    ended_at, ended_by, ended_reason
) VALUES (
    @placement_id, @tenant_id, @case_id, @location_id, @storage_tag, @state,
    @identity_checked_by, @identity_checked_note, @placed_at, @placed_by,
    @ended_at, @ended_by, @ended_reason
);

-- name: EndPlacement :execrows
UPDATE mortuary.placement
SET state = 'ended', ended_at = @ended_at, ended_by = @ended_by,
    ended_reason = @ended_reason
WHERE tenant_id = @tenant_id AND placement_id = @placement_id
  AND state = 'current';

-- name: GetCurrentPlacement :one
SELECT * FROM mortuary.placement
WHERE tenant_id = @tenant_id AND case_id = @case_id AND state = 'current';

-- name: ListPlacements :many
SELECT * FROM mortuary.placement
WHERE tenant_id = @tenant_id AND case_id = ANY(@case_ids::uuid[])
ORDER BY case_id, placed_at;

-- name: ListCurrentPlacements :many
SELECT * FROM mortuary.placement
WHERE tenant_id = @tenant_id AND state = 'current'
ORDER BY placed_at
LIMIT @row_limit;

-- name: InsertBelonging :exec
INSERT INTO mortuary.belonging (
    item_id, tenant_id, case_id, kind, description, quantity, state,
    seal_number, listed_at, listed_by, witnessed_by, handover_id
) VALUES (
    @item_id, @tenant_id, @case_id, @kind, @description, @quantity, @state,
    @seal_number, @listed_at, @listed_by, @witnessed_by, @handover_id
);

-- name: GetBelonging :one
SELECT * FROM mortuary.belonging
WHERE tenant_id = @tenant_id AND item_id = @item_id;

-- name: UpdateBelongingState :execrows
UPDATE mortuary.belonging
SET state = @state, handover_id = @handover_id
WHERE tenant_id = @tenant_id AND item_id = @item_id
  AND state = @expected_state;

-- name: ListBelongings :many
SELECT * FROM mortuary.belonging
WHERE tenant_id = @tenant_id AND case_id = ANY(@case_ids::uuid[])
ORDER BY case_id, listed_at;

-- name: InsertMortuaryHandover :exec
INSERT INTO mortuary.handover (
    handover_id, tenant_id, case_id, recipient_name, recipient_relation,
    recipient_id_type, recipient_id_ref, signature_ref, handed_at,
    handed_by, witnessed_by, note
) VALUES (
    @handover_id, @tenant_id, @case_id, @recipient_name,
    @recipient_relation, @recipient_id_type, @recipient_id_ref,
    @signature_ref, @handed_at, @handed_by, @witnessed_by, @note
);

-- name: ListMortuaryHandovers :many
SELECT * FROM mortuary.handover
WHERE tenant_id = @tenant_id AND case_id = @case_id
ORDER BY handed_at;

-- name: InsertCustodyEntry :exec
INSERT INTO mortuary.custody_entry (
    entry_id, tenant_id, case_id, event, detail, from_party, to_party,
    recorded_at, recorded_by
) VALUES (
    @entry_id, @tenant_id, @case_id, @event, @detail, @from_party,
    @to_party, @recorded_at, @recorded_by
);

-- name: ListCustodyEntries :many
SELECT * FROM mortuary.custody_entry
WHERE tenant_id = @tenant_id AND case_id = @case_id
ORDER BY recorded_at, entry_id;

-- name: InsertPostmortem :exec
INSERT INTO mortuary.postmortem (
    postmortem_id, tenant_id, case_id, kind, reason, state, authority,
    authority_reference, authorised_by, authorised_at, performed_by,
    performed_at, report_ref, reported_at, decline_reason, requested_at,
    requested_by, version
) VALUES (
    @postmortem_id, @tenant_id, @case_id, @kind, @reason, @state,
    @authority, @authority_reference, @authorised_by, @authorised_at,
    @performed_by, @performed_at, @report_ref, @reported_at,
    @decline_reason, @requested_at, @requested_by, @version
);

-- name: GetPostmortem :one
SELECT * FROM mortuary.postmortem
WHERE tenant_id = @tenant_id AND postmortem_id = @postmortem_id;

-- name: UpdatePostmortem :execrows
UPDATE mortuary.postmortem
SET state = @state, authority = @authority,
    authority_reference = @authority_reference,
    authorised_by = @authorised_by, authorised_at = @authorised_at,
    performed_by = @performed_by, performed_at = @performed_at,
    report_ref = @report_ref, reported_at = @reported_at,
    decline_reason = @decline_reason, version = version + 1
WHERE tenant_id = @tenant_id AND postmortem_id = @postmortem_id
  AND version = @expected_version;

-- name: ListPostmortems :many
SELECT * FROM mortuary.postmortem
WHERE tenant_id = @tenant_id AND case_id = ANY(@case_ids::uuid[])
ORDER BY case_id, requested_at;

-- name: InsertAuthorisation :exec
INSERT INTO mortuary.authorisation (
    authorisation_id, tenant_id, case_id, authority, reference,
    recorded_at, recorded_by, note
) VALUES (
    @authorisation_id, @tenant_id, @case_id, @authority, @reference,
    @recorded_at, @recorded_by, @note
);

-- name: LatestAuthorisation :one
SELECT * FROM mortuary.authorisation
WHERE tenant_id = @tenant_id AND case_id = @case_id
ORDER BY recorded_at DESC
LIMIT 1;

-- name: ListAuthorisations :many
SELECT * FROM mortuary.authorisation
WHERE tenant_id = @tenant_id AND case_id = ANY(@case_ids::uuid[])
ORDER BY case_id, recorded_at DESC;

-- name: InsertRelease :exec
INSERT INTO mortuary.release (
    release_id, tenant_id, case_id, case_medico_legal, recipient_name,
    recipient_relation, recipient_id_type, recipient_id_ref,
    verification_note, signature_ref, destination, death_certificate_ref,
    authority, authority_reference, released_at, released_by,
    witnessed_by, note
) VALUES (
    @release_id, @tenant_id, @case_id, @case_medico_legal, @recipient_name,
    @recipient_relation, @recipient_id_type, @recipient_id_ref,
    @verification_note, @signature_ref, @destination,
    @death_certificate_ref, @authority, @authority_reference, @released_at,
    @released_by, @witnessed_by, @note
);

-- name: GetRelease :one
SELECT * FROM mortuary.release
WHERE tenant_id = @tenant_id AND case_id = @case_id;

-- name: ListReleases :many
SELECT * FROM mortuary.release
WHERE tenant_id = @tenant_id
  AND released_at >= @window_from AND released_at < @window_to
ORDER BY released_at DESC
LIMIT @row_limit OFFSET @row_offset;
