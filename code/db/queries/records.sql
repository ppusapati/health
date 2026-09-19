-- Medical records and health information management (SRS-MRD-001 … 010).
--
-- Every statement is tenant-scoped in its WHERE clause as well as by the
-- caller's verified scope (FIT-03).
--
-- Nothing here deletes. A refuted coding revision is evidence about the
-- coding, a refused release is a decision somebody made, and a destroyed
-- physical record keeps its row saying it was destroyed lawfully. The one
-- deletion this context performs is the disposition of records held in other
-- systems, and that is an execution recorded here rather than a DELETE
-- issued from here.
--
-- Nothing here reads or writes clinical text. The document identifiers are
-- references into the clinical schema and this context never follows them.

-- name: InsertRecordsChecklist :exec
INSERT INTO records.chart_checklist (
    checklist_id, tenant_id, code, name, revision, encounter_class,
    specialty, effective_from, created_at, created_by
) VALUES (
    @checklist_id, @tenant_id, @code, @name, @revision, @encounter_class,
    @specialty, @effective_from, @created_at, @created_by
);

-- name: InsertRecordsChecklistItem :exec
INSERT INTO records.checklist_item (
    item_id, tenant_id, checklist_id, document_kind, label, requirement,
    due_within_seconds, condition_code
) VALUES (
    @item_id, @tenant_id, @checklist_id, @document_kind, @label,
    @requirement, @due_within_seconds, @condition_code
);

-- name: GetRecordsChecklist :one
SELECT * FROM records.chart_checklist
WHERE tenant_id = @tenant_id AND checklist_id = @checklist_id;

-- name: ListRecordsChecklistItems :many
SELECT * FROM records.checklist_item
WHERE tenant_id = @tenant_id AND checklist_id = @checklist_id
ORDER BY document_kind;

-- name: ApproveRecordsChecklist :execrows
UPDATE records.chart_checklist
SET approved = true, approved_by = @approved_by, approved_at = @approved_at,
    effective_from = @effective_from
WHERE tenant_id = @tenant_id AND checklist_id = @checklist_id
  AND NOT approved;

-- name: SupersedeRecordsChecklist :execrows
UPDATE records.chart_checklist
SET superseded_at = @superseded_at
WHERE tenant_id = @tenant_id AND code = @code AND revision < @revision
  AND superseded_at IS NULL;

-- name: ListRecordsChecklists :many
SELECT * FROM records.chart_checklist
WHERE tenant_id = @tenant_id
  AND (@encounter_class::text = '' OR encounter_class = @encounter_class)
  AND (NOT @live_only::boolean
       OR (approved
           AND effective_from IS NOT NULL AND effective_from <= @at
           AND (superseded_at IS NULL OR superseded_at > @at)))
ORDER BY encounter_class, specialty, effective_from DESC, revision DESC;

-- name: InsertRecordsDeficiency :exec
INSERT INTO records.deficiency (
    deficiency_id, tenant_id, patient_id, encounter_id, facility_id, kind,
    document_kind, label, document_id, detail, owner_id, checklist_code,
    checklist_revision, state, due_by, raised_at, raised_by
) VALUES (
    @deficiency_id, @tenant_id, @patient_id, @encounter_id, @facility_id,
    @kind, @document_kind, @label, @document_id, @detail, @owner_id,
    @checklist_code, @checklist_revision, @state, @due_by, @raised_at,
    @raised_by
);

-- name: GetRecordsDeficiency :one
SELECT * FROM records.deficiency
WHERE tenant_id = @tenant_id AND deficiency_id = @deficiency_id;

-- name: UpdateRecordsDeficiency :execrows
UPDATE records.deficiency
SET state = @state, owner_id = @owner_id,
    resolved_by_document_id = @resolved_by_document_id,
    resolved_at = @resolved_at, resolved_by = @resolved_by,
    waived_reason = @waived_reason, escalated_at = @escalated_at,
    version = version + 1
WHERE tenant_id = @tenant_id AND deficiency_id = @deficiency_id
  AND version = @expected_version;

-- name: ListRecordsDeficiencies :many
SELECT * FROM records.deficiency
WHERE tenant_id = @tenant_id
  AND (@owner_id::text = '' OR owner_id = @owner_id)
  AND (@encounter_id::text = '' OR encounter_id = @encounter_id)
  AND (@facility_id::text = '' OR facility_id = @facility_id)
  AND (@state::text = '' OR state = @state)
  AND (NOT @open_only::boolean OR state = 'open')
  AND raised_at >= @raised_from AND raised_at < @raised_to
ORDER BY due_by NULLS LAST, raised_at
LIMIT @page_size OFFSET @page_offset;

-- name: ListRecordsEscalationCandidates :many
SELECT * FROM records.deficiency
WHERE tenant_id = @tenant_id AND state = 'open'
  AND escalated_at IS NULL
  AND due_by IS NOT NULL AND due_by < @before
ORDER BY due_by
LIMIT @page_size;

-- name: InsertRecordsCodedEpisode :exec
INSERT INTO records.coded_episode (
    episode_id, tenant_id, patient_id, encounter_id, facility_id,
    created_at, created_by
) VALUES (
    @episode_id, @tenant_id, @patient_id, @encounter_id, @facility_id,
    @created_at, @created_by
);

-- name: GetRecordsCodedEpisode :one
SELECT * FROM records.coded_episode
WHERE tenant_id = @tenant_id AND episode_id = @episode_id;

-- name: GetRecordsCodedEpisodeByEncounter :one
SELECT * FROM records.coded_episode
WHERE tenant_id = @tenant_id AND encounter_id = @encounter_id;

-- name: BumpRecordsCodedEpisode :execrows
UPDATE records.coded_episode
SET version = version + 1
WHERE tenant_id = @tenant_id AND episode_id = @episode_id
  AND version = @expected_version;

-- name: InsertRecordsCodingRevision :exec
INSERT INTO records.coding_revision (
    revision_id, tenant_id, episode_id, revision, reason, state, coded_by,
    coded_at, reviewed_by, reviewed_at
) VALUES (
    @revision_id, @tenant_id, @episode_id, @revision, @reason, @state,
    @coded_by, @coded_at, @reviewed_by, @reviewed_at
);

-- name: UpdateRecordsCodingRevision :execrows
UPDATE records.coding_revision
SET state = @state, reviewed_by = @reviewed_by, reviewed_at = @reviewed_at
WHERE tenant_id = @tenant_id AND revision_id = @revision_id;

-- name: ListRecordsCodingRevisions :many
SELECT * FROM records.coding_revision
WHERE tenant_id = @tenant_id AND episode_id = @episode_id
ORDER BY revision;

-- name: InsertRecordsAssignedCode :exec
INSERT INTO records.assigned_code (
    code_id, tenant_id, revision_id, code_system, code_version, code_value,
    display, role, sequence, present_on_admission, source_document_id
) VALUES (
    @code_id, @tenant_id, @revision_id, @code_system, @code_version,
    @code_value, @display, @role, @sequence, @present_on_admission,
    @source_document_id
);

-- name: ListRecordsAssignedCodes :many
SELECT c.* FROM records.assigned_code c
JOIN records.coding_revision r
  ON r.revision_id = c.revision_id AND r.tenant_id = c.tenant_id
WHERE c.tenant_id = @tenant_id AND r.episode_id = @episode_id
ORDER BY r.revision, c.sequence, c.code_value;

-- name: InsertRecordsRelease :exec
INSERT INTO records.release_request (
    release_id, tenant_id, reference, patient_id, purpose, authority_kind,
    authority_reference, authority_signed_by, authority_signed_at,
    authority_expires_at, recipient_kind, recipient_name,
    recipient_reference, delivery_method, scope_from, scope_to,
    record_classes, document_kinds, encounter_ids, whole_record,
    include_restricted, state, requested_at, requested_by
) VALUES (
    @release_id, @tenant_id, @reference, @patient_id, @purpose,
    @authority_kind, @authority_reference, @authority_signed_by,
    @authority_signed_at, @authority_expires_at, @recipient_kind,
    @recipient_name, @recipient_reference, @delivery_method, @scope_from,
    @scope_to, @record_classes, @document_kinds, @encounter_ids,
    @whole_record, @include_restricted, @state, @requested_at, @requested_by
);

-- name: GetRecordsRelease :one
SELECT * FROM records.release_request
WHERE tenant_id = @tenant_id AND release_id = @release_id;

-- name: UpdateRecordsRelease :execrows
UPDATE records.release_request
SET state = @state, refusal_reason = @refusal_reason,
    approved_at = @approved_at, approved_by = @approved_by,
    content_hash = @content_hash, pages = @pages,
    assembled_at = @assembled_at, assembled_by = @assembled_by,
    released_at = @released_at, released_by = @released_by,
    version = version + 1
WHERE tenant_id = @tenant_id AND release_id = @release_id
  AND version = @expected_version;

-- name: InsertRecordsReleaseItem :exec
INSERT INTO records.release_item (
    item_id, tenant_id, release_id, document_id, encounter_id,
    document_kind, record_class, occurred_at, restricted, pages
) VALUES (
    @item_id, @tenant_id, @release_id, @document_id, @encounter_id,
    @document_kind, @record_class, @occurred_at, @restricted, @pages
);

-- name: ListRecordsReleaseItems :many
SELECT * FROM records.release_item
WHERE tenant_id = @tenant_id AND release_id = @release_id
ORDER BY occurred_at NULLS LAST, document_id;

-- name: ListRecordsReleases :many
SELECT * FROM records.release_request
WHERE tenant_id = @tenant_id
  AND (@patient_id::text = '' OR patient_id = @patient_id)
  AND (@state::text = '' OR state = @state)
  AND (NOT @open_only::boolean
       OR state IN ('requested', 'approved', 'assembled'))
  AND requested_at >= @requested_from AND requested_at < @requested_to
ORDER BY requested_at DESC
LIMIT @page_size OFFSET @page_offset;

-- name: InsertRecordsDisclosure :exec
INSERT INTO records.disclosure (
    disclosure_id, tenant_id, patient_id, kind, release_id, actor_id,
    purpose, scope_summary, recipient_reference, recipient_name, items,
    pages, occurred_at
) VALUES (
    @disclosure_id, @tenant_id, @patient_id, @kind, @release_id, @actor_id,
    @purpose, @scope_summary, @recipient_reference, @recipient_name, @items,
    @pages, @occurred_at
);

-- name: ListRecordsDisclosures :many
SELECT * FROM records.disclosure
WHERE tenant_id = @tenant_id
  AND (@patient_id::text = '' OR patient_id = @patient_id)
  AND (@actor_id::text = '' OR actor_id = @actor_id)
  AND occurred_at >= @occurred_from AND occurred_at < @occurred_to
ORDER BY occurred_at DESC
LIMIT @page_size OFFSET @page_offset;

-- name: InsertRecordsRetentionRule :exec
INSERT INTO records.retention_rule (
    rule_id, tenant_id, code, name, revision, record_class, jurisdiction,
    anchor, retain_years, disposition, authority, effective_from,
    created_at, created_by
) VALUES (
    @rule_id, @tenant_id, @code, @name, @revision, @record_class,
    @jurisdiction, @anchor, @retain_years, @disposition, @authority,
    @effective_from, @created_at, @created_by
);

-- name: GetRecordsRetentionRule :one
SELECT * FROM records.retention_rule
WHERE tenant_id = @tenant_id AND rule_id = @rule_id;

-- name: ApproveRecordsRetentionRule :execrows
UPDATE records.retention_rule
SET approved = true, approved_by = @approved_by, approved_at = @approved_at,
    effective_from = @effective_from
WHERE tenant_id = @tenant_id AND rule_id = @rule_id AND NOT approved;

-- name: SupersedeRecordsRetentionRule :execrows
UPDATE records.retention_rule
SET superseded_at = @superseded_at
WHERE tenant_id = @tenant_id AND code = @code AND revision < @revision
  AND superseded_at IS NULL;

-- name: ListRecordsRetentionRules :many
SELECT * FROM records.retention_rule
WHERE tenant_id = @tenant_id
  AND (@jurisdiction::text = '' OR jurisdiction = @jurisdiction)
  AND (@record_class::text = '' OR record_class = @record_class)
  AND (NOT @live_only::boolean
       OR (approved
           AND effective_from IS NOT NULL AND effective_from <= @at
           AND (superseded_at IS NULL OR superseded_at > @at)))
ORDER BY record_class, effective_from DESC, revision DESC;

-- name: InsertRecordsDispositionList :exec
INSERT INTO records.disposition_list (
    list_id, tenant_id, reference, jurisdiction, disposition, state,
    prepared_at, prepared_by
) VALUES (
    @list_id, @tenant_id, @reference, @jurisdiction, @disposition, @state,
    @prepared_at, @prepared_by
);

-- name: InsertRecordsDispositionItem :exec
INSERT INTO records.disposition_item (
    item_id, tenant_id, list_id, record_id, patient_id, record_class,
    description, rule_code, rule_revision, authority, anchor_date,
    eligible_from
) VALUES (
    @item_id, @tenant_id, @list_id, @record_id, @patient_id, @record_class,
    @description, @rule_code, @rule_revision, @authority, @anchor_date,
    @eligible_from
);

-- name: GetRecordsDispositionList :one
SELECT * FROM records.disposition_list
WHERE tenant_id = @tenant_id AND list_id = @list_id;

-- name: ListRecordsDispositionItems :many
SELECT * FROM records.disposition_item
WHERE tenant_id = @tenant_id AND list_id = @list_id
ORDER BY eligible_from, record_id;

-- name: UpdateRecordsDispositionList :execrows
UPDATE records.disposition_list
SET state = @state, approved_at = @approved_at, approved_by = @approved_by,
    executed_at = @executed_at, executed_by = @executed_by,
    certificate = @certificate, cancelled_reason = @cancelled_reason,
    version = version + 1
WHERE tenant_id = @tenant_id AND list_id = @list_id
  AND version = @expected_version;

-- name: ListRecordsDispositionLists :many
SELECT * FROM records.disposition_list
WHERE tenant_id = @tenant_id
  AND (@state::text = '' OR state = @state)
  AND (@jurisdiction::text = '' OR jurisdiction = @jurisdiction)
ORDER BY prepared_at DESC
LIMIT @page_size OFFSET @page_offset;

-- name: InsertRecordsPhysicalRecord :exec
INSERT INTO records.physical_record (
    record_id, tenant_id, reference, patient_id, volume, record_class,
    jurisdiction, description, state, home_location, current_location,
    created_at, created_by
) VALUES (
    @record_id, @tenant_id, @reference, @patient_id, @volume, @record_class,
    @jurisdiction, @description, @state, @home_location, @current_location,
    @created_at, @created_by
);

-- name: GetRecordsPhysicalRecord :one
SELECT * FROM records.physical_record
WHERE tenant_id = @tenant_id AND record_id = @record_id;

-- name: UpdateRecordsPhysicalRecord :execrows
UPDATE records.physical_record
SET state = @state, home_location = @home_location,
    current_location = @current_location, custodian = @custodian,
    checked_out_at = @checked_out_at, checked_out_by = @checked_out_by,
    due_back_at = @due_back_at, purpose = @purpose, version = version + 1
WHERE tenant_id = @tenant_id AND record_id = @record_id
  AND version = @expected_version;

-- name: ListRecordsPhysicalRecords :many
SELECT * FROM records.physical_record
WHERE tenant_id = @tenant_id
  AND (@patient_id::text = '' OR patient_id = @patient_id)
  AND (@state::text = '' OR state = @state)
  AND (NOT @out_only::boolean OR state = 'checked_out')
  AND (NOT @overdue_only::boolean
       OR (state = 'checked_out' AND due_back_at IS NOT NULL
           AND due_back_at < @at))
ORDER BY checked_out_at NULLS LAST, reference
LIMIT @page_size OFFSET @page_offset;

-- name: InsertRecordsCertificateForm :exec
INSERT INTO records.certificate_form (
    form_id, tenant_id, code, name, revision, kind, jurisdiction,
    issuer_role, effective_from, created_at, created_by
) VALUES (
    @form_id, @tenant_id, @code, @name, @revision, @kind, @jurisdiction,
    @issuer_role, @effective_from, @created_at, @created_by
);

-- name: InsertRecordsCertificateField :exec
INSERT INTO records.certificate_field (
    field_id, tenant_id, form_id, code, label, required, source_path, ordinal
) VALUES (
    @field_id, @tenant_id, @form_id, @code, @label, @required, @source_path,
    @ordinal
);

-- name: GetRecordsCertificateForm :one
SELECT * FROM records.certificate_form
WHERE tenant_id = @tenant_id AND form_id = @form_id;

-- name: ListRecordsCertificateFields :many
SELECT * FROM records.certificate_field
WHERE tenant_id = @tenant_id AND form_id = @form_id
ORDER BY ordinal, code;

-- name: ApproveRecordsCertificateForm :execrows
UPDATE records.certificate_form
SET approved = true, approved_by = @approved_by, approved_at = @approved_at,
    effective_from = @effective_from
WHERE tenant_id = @tenant_id AND form_id = @form_id AND NOT approved;

-- name: SupersedeRecordsCertificateForm :execrows
UPDATE records.certificate_form
SET superseded_at = @superseded_at
WHERE tenant_id = @tenant_id AND code = @code AND revision < @revision
  AND superseded_at IS NULL;

-- name: ListRecordsCertificateForms :many
SELECT * FROM records.certificate_form
WHERE tenant_id = @tenant_id
  AND (@kind::text = '' OR kind = @kind)
  AND (@jurisdiction::text = '' OR jurisdiction = @jurisdiction)
  AND (NOT @live_only::boolean
       OR (approved
           AND effective_from IS NOT NULL AND effective_from <= @at
           AND (superseded_at IS NULL OR superseded_at > @at)))
ORDER BY kind, effective_from DESC, revision DESC;

-- name: InsertRecordsCertificate :exec
INSERT INTO records.certificate (
    certificate_id, tenant_id, kind, form_code, form_revision, jurisdiction,
    patient_id, encounter_id, serial_number, state, created_at
) VALUES (
    @certificate_id, @tenant_id, @kind, @form_code, @form_revision,
    @jurisdiction, @patient_id, @encounter_id, @serial_number, @state,
    @created_at
);

-- name: InsertRecordsCertificateVersion :exec
INSERT INTO records.certificate_version (
    version_id, tenant_id, certificate_id, version, values, source_refs,
    reason, issuer_id, issuer_name, issuer_role, issued_at, serial_number
) VALUES (
    @version_id, @tenant_id, @certificate_id, @version, @values,
    @source_refs, @reason, @issuer_id, @issuer_name, @issuer_role,
    @issued_at, @serial_number
);

-- name: GetRecordsCertificate :one
SELECT * FROM records.certificate
WHERE tenant_id = @tenant_id AND certificate_id = @certificate_id;

-- name: ListRecordsCertificateVersions :many
SELECT * FROM records.certificate_version
WHERE tenant_id = @tenant_id AND certificate_id = @certificate_id
ORDER BY version;

-- name: UpdateRecordsCertificate :execrows
UPDATE records.certificate
SET state = @state, form_code = @form_code, form_revision = @form_revision,
    serial_number = @serial_number, void_reason = @void_reason,
    voided_by = @voided_by, voided_at = @voided_at, version = version + 1
WHERE tenant_id = @tenant_id AND certificate_id = @certificate_id
  AND version = @expected_version;

-- name: ListRecordsCertificates :many
SELECT * FROM records.certificate
WHERE tenant_id = @tenant_id
  AND (@patient_id::text = '' OR patient_id = @patient_id)
  AND (@kind::text = '' OR kind = @kind)
  AND (@state::text = '' OR state = @state)
ORDER BY created_at DESC
LIMIT @page_size OFFSET @page_offset;
