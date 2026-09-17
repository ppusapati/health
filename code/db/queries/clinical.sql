-- The clinical record (SRS-CLN).

-- name: InsertTemplate :exec
INSERT INTO clinical.template (
    template_id, tenant_id, version, name, kind, specialty, sections,
    retired, created_by, created_at
) VALUES (
    @template_id, @tenant_id, @version, @name, @kind, @specialty, @sections,
    false, @created_by, @created_at
);

-- name: GetTemplate :one
SELECT template_id, tenant_id, version, name, kind, specialty, sections,
       retired, created_by, created_at
FROM clinical.template
WHERE tenant_id = @tenant_id AND template_id = @template_id AND version = @version;

-- name: ListTemplates :many
-- Only the choosable ones by default: a retired template can be read on an old
-- note but must not be picked for a new one.
SELECT template_id, tenant_id, version, name, kind, specialty, sections,
       retired, created_by, created_at
FROM clinical.template
WHERE tenant_id = @tenant_id
  AND (@include_retired::boolean = true OR retired = false)
  AND (@kind_filter::text = '' OR kind = @kind_filter::text)
ORDER BY name, version
LIMIT @page_limit;

-- name: RetireTemplate :execrows
UPDATE clinical.template
SET retired = true
WHERE tenant_id = @tenant_id AND template_id = @template_id AND version = @version;

-- name: InsertDocument :exec
INSERT INTO clinical.document (
    document_id, tenant_id, patient_id, encounter_id, kind, template_id,
    template_version, title, sections, status, confidentiality,
    amends_id, adds_to_id, change_reason, retraction_reason, dictated,
    authored_by, created_at, updated_at, version
) VALUES (
    @document_id, @tenant_id, @patient_id, @encounter_id, @kind,
    sqlc.narg('template_id')::uuid, @template_version, @title, @sections,
    @status, @confidentiality, sqlc.narg('amends_id')::uuid,
    sqlc.narg('adds_to_id')::uuid, @change_reason, @retraction_reason,
    @dictated, @authored_by, @created_at, @updated_at, 1
);

-- name: GetDocument :one
SELECT document_id, tenant_id, patient_id, encounter_id, kind, template_id,
       template_version, title, sections, status, confidentiality,
       amends_id, adds_to_id, change_reason, retraction_reason, dictated,
       authored_by, created_at, updated_at, version
FROM clinical.document
WHERE tenant_id = @tenant_id AND document_id = @document_id;

-- name: UpdateDocumentDraft :execrows
-- Guarded on still being a draft, which is the whole of SRS-CLN-008 at the
-- table: a signed document cannot be edited in place even by a caller that
-- skipped the domain check.
UPDATE clinical.document
SET title = @title, sections = @sections, updated_at = @updated_at,
    version = version + 1
WHERE tenant_id = @tenant_id
  AND document_id = @document_id
  AND status = 'draft'
  AND version = @expected_version;

-- name: SetDocumentStatus :execrows
UPDATE clinical.document
SET status = @status, retraction_reason = @retraction_reason,
    updated_at = @updated_at, version = version + 1
WHERE tenant_id = @tenant_id
  AND document_id = @document_id
  AND version = @expected_version;

-- name: ListDocumentsForPatient :many
SELECT document_id, tenant_id, patient_id, encounter_id, kind, template_id,
       template_version, title, sections, status, confidentiality,
       amends_id, adds_to_id, change_reason, retraction_reason, dictated,
       authored_by, created_at, updated_at, version
FROM clinical.document
WHERE tenant_id = @tenant_id
  AND patient_id = @patient_id
  AND (sqlc.narg('encounter_id')::uuid IS NULL
       OR encounter_id = sqlc.narg('encounter_id')::uuid)
  AND (@kind_filter::text = '' OR kind = @kind_filter::text)
  AND (@include_drafts::boolean = true OR status <> 'draft')
ORDER BY created_at DESC, document_id
LIMIT @page_limit;

-- name: CountSignedDocuments :one
-- What the encounter context's closure gate asks (SRS-ENC-008).
SELECT count(*) AS signed_documents
FROM clinical.document
WHERE tenant_id = @tenant_id
  AND encounter_id = @encounter_id
  AND status IN ('signed', 'amended', 'addendum');

-- name: InsertSignature :exec
INSERT INTO clinical.signature (
    signature_id, tenant_id, document_id, subject_id, meaning, signed_at,
    content_hash, template_version
) VALUES (
    @signature_id, @tenant_id, @document_id, @subject_id, @meaning, @signed_at,
    @content_hash, @template_version
);

-- name: ListSignatures :many
SELECT signature_id, tenant_id, document_id, subject_id, meaning, signed_at,
       content_hash, template_version
FROM clinical.signature
WHERE tenant_id = @tenant_id AND document_id = @document_id
ORDER BY signed_at, signature_id;

-- name: InsertProblem :exec
INSERT INTO clinical.problem (
    problem_id, tenant_id, patient_id, encounter_id, code_system, code_version,
    code, code_display, note, status, onset_at, resolved_at, confidentiality,
    recorded_by, recorded_at, updated_by, updated_at, version
) VALUES (
    @problem_id, @tenant_id, @patient_id, sqlc.narg('encounter_id')::uuid,
    @code_system, @code_version, @code, @code_display, @note, @status,
    sqlc.narg('onset_at')::timestamptz, sqlc.narg('resolved_at')::timestamptz,
    @confidentiality, @recorded_by, @recorded_at, @updated_by, @updated_at, 1
);

-- name: GetProblem :one
SELECT problem_id, tenant_id, patient_id, encounter_id, code_system, code_version,
       code, code_display, note, status, onset_at, resolved_at, confidentiality,
       recorded_by, recorded_at, updated_by, updated_at, version
FROM clinical.problem
WHERE tenant_id = @tenant_id AND problem_id = @problem_id;

-- name: SetProblemStatus :execrows
UPDATE clinical.problem
SET status = @status, resolved_at = sqlc.narg('resolved_at')::timestamptz,
    updated_by = @updated_by, updated_at = @updated_at, version = version + 1
WHERE tenant_id = @tenant_id
  AND problem_id = @problem_id
  AND version = @expected_version;

-- name: ListProblems :many
-- Every entry, resolved ones included: a problem list that forgot a resolved
-- myocardial infarction would hide the most important fact about the patient.
SELECT problem_id, tenant_id, patient_id, encounter_id, code_system, code_version,
       code, code_display, note, status, onset_at, resolved_at, confidentiality,
       recorded_by, recorded_at, updated_by, updated_at, version
FROM clinical.problem
WHERE tenant_id = @tenant_id
  AND patient_id = @patient_id
  AND (@active_only::boolean = false OR status IN ('active', 'remission'))
ORDER BY recorded_at DESC, problem_id
LIMIT @page_limit;

-- name: InsertAllergy :exec
INSERT INTO clinical.allergy (
    allergy_id, tenant_id, patient_id, encounter_id, substance_system,
    substance_version, substance_code, substance_display, kind, criticality,
    verification, reactions, onset_at, note, recorded_by, recorded_at,
    updated_by, updated_at, version
) VALUES (
    @allergy_id, @tenant_id, @patient_id, sqlc.narg('encounter_id')::uuid,
    @substance_system, @substance_version, @substance_code, @substance_display,
    @kind, @criticality, @verification, @reactions,
    sqlc.narg('onset_at')::timestamptz, @note, @recorded_by, @recorded_at,
    @updated_by, @updated_at, 1
);

-- name: GetAllergy :one
SELECT allergy_id, tenant_id, patient_id, encounter_id, substance_system,
       substance_version, substance_code, substance_display, kind, criticality,
       verification, reactions, onset_at, note, recorded_by, recorded_at,
       updated_by, updated_at, version
FROM clinical.allergy
WHERE tenant_id = @tenant_id AND allergy_id = @allergy_id;

-- name: SetAllergyVerification :execrows
UPDATE clinical.allergy
SET verification = @verification, updated_by = @updated_by,
    updated_at = @updated_at, version = version + 1
WHERE tenant_id = @tenant_id
  AND allergy_id = @allergy_id
  AND version = @expected_version;

-- name: ListAllergies :many
SELECT allergy_id, tenant_id, patient_id, encounter_id, substance_system,
       substance_version, substance_code, substance_display, kind, criticality,
       verification, reactions, onset_at, note, recorded_by, recorded_at,
       updated_by, updated_at, version
FROM clinical.allergy
WHERE tenant_id = @tenant_id
  AND patient_id = @patient_id
  AND (@active_only::boolean = false
       OR verification IN ('unconfirmed', 'confirmed'))
ORDER BY recorded_at DESC, allergy_id
LIMIT @page_limit;

-- name: InsertObservation :exec
INSERT INTO clinical.observation (
    observation_id, tenant_id, patient_id, encounter_id, code_system,
    code_version, code, code_display, value_quantity, value_unit, value_text,
    value_code_system, value_code, value_code_display, reference_low,
    reference_high, reference_text, interpretation, interpretation_source,
    status, effective_at, issued_at, performer_id, device_id, source_system,
    note, amends_id, recorded_by, recorded_at, version,
    source, validation, device_channel, device_quality,
    device_observed_at, device_received_at
) VALUES (
    @observation_id, @tenant_id, @patient_id, sqlc.narg('encounter_id')::uuid,
    @code_system, @code_version, @code, @code_display,
    sqlc.narg('value_quantity')::double precision, @value_unit, @value_text,
    @value_code_system, @value_code, @value_code_display,
    sqlc.narg('reference_low')::double precision,
    sqlc.narg('reference_high')::double precision, @reference_text,
    @interpretation, @interpretation_source, @status, @effective_at,
    sqlc.narg('issued_at')::timestamptz, @performer_id, @device_id,
    @source_system, @note, sqlc.narg('amends_id')::uuid, @recorded_by,
    @recorded_at, 1,
    @source, @validation, @device_channel, @device_quality,
    sqlc.narg('device_observed_at')::timestamptz,
    sqlc.narg('device_received_at')::timestamptz
);

-- name: SetObservationValidation :exec
-- Records a clinician accepting a device reading into the chart, or rejecting
-- it as an artefact (SRS-ICU-003).
--
-- The predicate is the control. `validation = 'pending'` means a reading
-- already decided cannot be decided again by a second request that raced the
-- first, and a value that was never device-derived cannot be walked into the
-- chart by this path at all.
UPDATE clinical.observation
SET validation = @validation,
    validated_by = @validated_by,
    validated_at = @validated_at,
    validation_note = @validation_note,
    version = version + 1
WHERE tenant_id = @tenant_id
  AND observation_id = @observation_id
  AND validation = 'pending';

-- name: ListPendingValidation :many
-- What the ICU dashboard shows as provisional (SRS-ICU-003, SRS-ICU-012).
SELECT * FROM clinical.observation
WHERE tenant_id = $1 AND patient_id = $2 AND validation = 'pending'
ORDER BY effective_at DESC
LIMIT $3;

-- name: GetObservation :one
SELECT observation_id, tenant_id, patient_id, encounter_id, code_system,
       code_version, code, code_display, value_quantity, value_unit, value_text,
       value_code_system, value_code, value_code_display, reference_low,
       reference_high, reference_text, interpretation, interpretation_source,
       status, effective_at, issued_at, performer_id, device_id, source_system,
       note, amends_id, recorded_by, recorded_at, version,
       source, validation, device_channel, device_quality,
       device_observed_at, device_received_at, validated_by, validated_at,
       validation_note
FROM clinical.observation
WHERE tenant_id = @tenant_id AND observation_id = @observation_id;

-- name: ListObservations :many
-- One code's trend, or everything for a patient. Oldest first when a code is
-- named, because a trend is read left to right.
SELECT observation_id, tenant_id, patient_id, encounter_id, code_system,
       code_version, code, code_display, value_quantity, value_unit, value_text,
       value_code_system, value_code, value_code_display, reference_low,
       reference_high, reference_text, interpretation, interpretation_source,
       status, effective_at, issued_at, performer_id, device_id, source_system,
       note, amends_id, recorded_by, recorded_at, version,
       source, validation, device_channel, device_quality,
       device_observed_at, device_received_at, validated_by, validated_at,
       validation_note
FROM clinical.observation
WHERE tenant_id = @tenant_id
  AND patient_id = @patient_id
  AND (@code_filter::text = '' OR code = @code_filter::text)
  AND (sqlc.narg('encounter_id')::uuid IS NULL
       OR encounter_id = sqlc.narg('encounter_id')::uuid)
  AND status NOT IN ('cancelled', 'entered_in_error')
ORDER BY effective_at DESC, observation_id
LIMIT @page_limit;

-- name: ListUnacknowledgedCriticalResults :many
-- The worklist that must reach a clinician now (SRS-CLN-012).
SELECT o.observation_id, o.tenant_id, o.patient_id, o.encounter_id, o.code_system,
       o.code_version, o.code, o.code_display, o.value_quantity, o.value_unit,
       o.value_text, o.value_code_system, o.value_code, o.value_code_display,
       o.reference_low, o.reference_high, o.reference_text, o.interpretation,
       o.interpretation_source, o.status, o.effective_at, o.issued_at,
       o.performer_id, o.device_id, o.source_system, o.note, o.amends_id,
       o.recorded_by, o.recorded_at, o.version,
       o.source, o.validation, o.device_channel, o.device_quality,
       o.device_observed_at, o.device_received_at, o.validated_by,
       o.validated_at, o.validation_note
FROM clinical.observation o
WHERE o.tenant_id = @tenant_id
  AND o.interpretation IN ('critical_high', 'critical_low')
  AND o.status NOT IN ('cancelled', 'entered_in_error')
  AND NOT EXISTS (
      SELECT 1 FROM clinical.critical_acknowledgement a
      WHERE a.tenant_id = o.tenant_id AND a.observation_id = o.observation_id
  )
ORDER BY o.issued_at NULLS FIRST, o.observation_id
LIMIT @page_limit;

-- name: InsertCriticalAcknowledgement :exec
INSERT INTO clinical.critical_acknowledgement (
    acknowledgement_id, tenant_id, observation_id, patient_id,
    acknowledged_by, acknowledged_at, action, notified_at
) VALUES (
    @acknowledgement_id, @tenant_id, @observation_id, @patient_id,
    @acknowledged_by, @acknowledged_at, @action,
    sqlc.narg('notified_at')::timestamptz
);

-- name: GetCriticalAcknowledgement :one
SELECT acknowledgement_id, tenant_id, observation_id, patient_id,
       acknowledged_by, acknowledged_at, action, notified_at
FROM clinical.critical_acknowledgement
WHERE tenant_id = @tenant_id AND observation_id = @observation_id;

-- name: InsertProcedure :exec
INSERT INTO clinical.procedure (
    procedure_id, tenant_id, patient_id, encounter_id, code_system, code_version,
    code, code_display, status, indication, performers, body_site, laterality,
    outcome, complications, order_ids, device_ids, specimen_ids,
    performed_start, performed_end, note, recorded_by, recorded_at,
    updated_at, version
) VALUES (
    @procedure_id, @tenant_id, @patient_id, @encounter_id, @code_system,
    @code_version, @code, @code_display, @status, @indication, @performers,
    @body_site, @laterality, @outcome, @complications, @order_ids, @device_ids,
    @specimen_ids, sqlc.narg('performed_start')::timestamptz,
    sqlc.narg('performed_end')::timestamptz, @note, @recorded_by, @recorded_at,
    @updated_at, 1
);

-- name: GetProcedure :one
SELECT procedure_id, tenant_id, patient_id, encounter_id, code_system, code_version,
       code, code_display, status, indication, performers, body_site, laterality,
       outcome, complications, order_ids, device_ids, specimen_ids,
       performed_start, performed_end, note, recorded_by, recorded_at,
       updated_at, version
FROM clinical.procedure
WHERE tenant_id = @tenant_id AND procedure_id = @procedure_id;

-- name: ListProcedures :many
SELECT procedure_id, tenant_id, patient_id, encounter_id, code_system, code_version,
       code, code_display, status, indication, performers, body_site, laterality,
       outcome, complications, order_ids, device_ids, specimen_ids,
       performed_start, performed_end, note, recorded_by, recorded_at,
       updated_at, version
FROM clinical.procedure
WHERE tenant_id = @tenant_id
  AND patient_id = @patient_id
  AND (sqlc.narg('encounter_id')::uuid IS NULL
       OR encounter_id = sqlc.narg('encounter_id')::uuid)
ORDER BY performed_start DESC NULLS LAST, procedure_id
LIMIT @page_limit;

-- name: InsertCarePlan :exec
INSERT INTO clinical.care_plan (
    care_plan_id, tenant_id, patient_id, encounter_id, title, status,
    problem_ids, goals, activities, owner_id, starts_at, ends_at,
    created_by, created_at, updated_at, version
) VALUES (
    @care_plan_id, @tenant_id, @patient_id, sqlc.narg('encounter_id')::uuid,
    @title, @status, @problem_ids, @goals, @activities, @owner_id,
    sqlc.narg('starts_at')::timestamptz, sqlc.narg('ends_at')::timestamptz,
    @created_by, @created_at, @updated_at, 1
);

-- name: GetCarePlan :one
SELECT care_plan_id, tenant_id, patient_id, encounter_id, title, status,
       problem_ids, goals, activities, owner_id, starts_at, ends_at,
       created_by, created_at, updated_at, version
FROM clinical.care_plan
WHERE tenant_id = @tenant_id AND care_plan_id = @care_plan_id;

-- name: UpdateCarePlan :execrows
UPDATE clinical.care_plan
SET status = @status, goals = @goals, activities = @activities,
    problem_ids = @problem_ids, updated_at = @updated_at, version = version + 1
WHERE tenant_id = @tenant_id
  AND care_plan_id = @care_plan_id
  AND version = @expected_version;

-- name: ListCarePlans :many
SELECT care_plan_id, tenant_id, patient_id, encounter_id, title, status,
       problem_ids, goals, activities, owner_id, starts_at, ends_at,
       created_by, created_at, updated_at, version
FROM clinical.care_plan
WHERE tenant_id = @tenant_id
  AND patient_id = @patient_id
  AND (@active_only::boolean = false
       OR status IN ('draft', 'active', 'on_hold'))
ORDER BY created_at DESC, care_plan_id
LIMIT @page_limit;

-- name: InsertProvenance :exec
INSERT INTO clinical.provenance (
    provenance_id, tenant_id, record_type, record_id, source_organization,
    source_system, source_record_id, ingested_at, authored_at, authored_by,
    assertion
) VALUES (
    @provenance_id, @tenant_id, @record_type, @record_id, @source_organization,
    @source_system, @source_record_id, @ingested_at,
    sqlc.narg('authored_at')::timestamptz, @authored_by, @assertion
);

-- name: ListProvenance :many
SELECT provenance_id, tenant_id, record_type, record_id, source_organization,
       source_system, source_record_id, ingested_at, authored_at, authored_by,
       assertion
FROM clinical.provenance
WHERE tenant_id = @tenant_id
  AND record_type = @record_type
  AND record_id = @record_id
ORDER BY ingested_at DESC;

-- name: InsertAttachment :exec
INSERT INTO clinical.attachment (
    attachment_id, tenant_id, parent_type, parent_id, patient_id, kind,
    content_type, storage_key, size_bytes, digest, description,
    confidentiality, captured_at, source_system, uploaded_by, uploaded_at
) VALUES (
    @attachment_id, @tenant_id, @parent_type, @parent_id, @patient_id, @kind,
    @content_type, @storage_key, @size_bytes, @digest, @description,
    @confidentiality, @captured_at, @source_system, @uploaded_by, @uploaded_at
);

-- name: GetAttachment :one
SELECT attachment_id, tenant_id, parent_type, parent_id, patient_id, kind,
       content_type, storage_key, size_bytes, digest, description,
       confidentiality, captured_at, source_system, uploaded_by, uploaded_at
FROM clinical.attachment
WHERE tenant_id = @tenant_id AND attachment_id = @attachment_id;

-- name: ListAttachments :many
SELECT attachment_id, tenant_id, parent_type, parent_id, patient_id, kind,
       content_type, storage_key, size_bytes, digest, description,
       confidentiality, captured_at, source_system, uploaded_by, uploaded_at
FROM clinical.attachment
WHERE tenant_id = @tenant_id
  AND parent_type = @parent_type
  AND parent_id = @parent_id
ORDER BY captured_at DESC, attachment_id
LIMIT @page_limit;

-- name: InsertClinicalConsent :exec
INSERT INTO clinical.clinical_consent (
    consent_id, tenant_id, patient_id, encounter_id, kind, procedure_system,
    procedure_code, procedure_display, status, given_by, given_by_name,
    document_id, witness_id, valid_from, valid_until, note, recorded_by,
    recorded_at, updated_at
) VALUES (
    @consent_id, @tenant_id, @patient_id, sqlc.narg('encounter_id')::uuid,
    @kind, @procedure_system, @procedure_code, @procedure_display, @status,
    @given_by, @given_by_name, sqlc.narg('document_id')::uuid, @witness_id,
    @valid_from, sqlc.narg('valid_until')::timestamptz, @note, @recorded_by,
    @recorded_at, @updated_at
);

-- name: SetConsentStatus :execrows
UPDATE clinical.clinical_consent
SET status = @status, updated_at = @updated_at
WHERE tenant_id = @tenant_id AND consent_id = @consent_id;

-- name: ListClinicalConsents :many
SELECT consent_id, tenant_id, patient_id, encounter_id, kind, procedure_system,
       procedure_code, procedure_display, status, given_by, given_by_name,
       document_id, witness_id, valid_from, valid_until, note, recorded_by,
       recorded_at, updated_at
FROM clinical.clinical_consent
WHERE tenant_id = @tenant_id
  AND patient_id = @patient_id
  AND (@kind_filter::text = '' OR kind = @kind_filter::text)
ORDER BY valid_from DESC, consent_id
LIMIT @page_limit;

-- name: InsertCalculatorResult :exec
INSERT INTO clinical.calculator_result (
    result_id, tenant_id, patient_id, encounter_id, calculator_id,
    formula_version, name, inputs, value, unit, interpretation,
    superseded_by_id, calculated_by, calculated_at
) VALUES (
    @result_id, @tenant_id, @patient_id, sqlc.narg('encounter_id')::uuid,
    @calculator_id, @formula_version, @name, @inputs, @value, @unit,
    @interpretation, NULL, @calculated_by, @calculated_at
);

-- name: SupersedeCalculatorResult :execrows
-- A rerun with a newer formula chains forward; the original stays, because the
-- decision was made from it.
UPDATE clinical.calculator_result
SET superseded_by_id = @superseded_by_id
WHERE tenant_id = @tenant_id
  AND result_id = @result_id
  AND superseded_by_id IS NULL;

-- name: ListCalculatorResults :many
SELECT result_id, tenant_id, patient_id, encounter_id, calculator_id,
       formula_version, name, inputs, value, unit, interpretation,
       superseded_by_id, calculated_by, calculated_at
FROM clinical.calculator_result
WHERE tenant_id = @tenant_id
  AND patient_id = @patient_id
  AND (@calculator_filter::text = '' OR calculator_id = @calculator_filter::text)
ORDER BY calculated_at DESC, result_id
LIMIT @page_limit;

-- name: InsertCDSAlert :exec
INSERT INTO clinical.cds_alert (
    alert_id, tenant_id, patient_id, encounter_id, rule_id, rule_version,
    level, message, context_type, context_id, outcome, override_code,
    override_reason, fired_at, responded_by, responded_at
) VALUES (
    @alert_id, @tenant_id, @patient_id, sqlc.narg('encounter_id')::uuid,
    @rule_id, @rule_version, @level, @message, @context_type, @context_id,
    'pending', '', '', @fired_at, '', NULL
);

-- name: GetCDSAlert :one
SELECT alert_id, tenant_id, patient_id, encounter_id, rule_id, rule_version,
       level, message, context_type, context_id, outcome, override_code,
       override_reason, fired_at, responded_by, responded_at
FROM clinical.cds_alert
WHERE tenant_id = @tenant_id AND alert_id = @alert_id;

-- name: RespondToCDSAlert :execrows
-- Guarded on still being pending: answering twice would let a second click
-- rewrite the first clinician's stated reason.
UPDATE clinical.cds_alert
SET outcome = @outcome, override_code = @override_code,
    override_reason = @override_reason, responded_by = @responded_by,
    responded_at = @responded_at
WHERE tenant_id = @tenant_id
  AND alert_id = @alert_id
  AND outcome = 'pending';

-- name: ListCDSAlerts :many
SELECT alert_id, tenant_id, patient_id, encounter_id, rule_id, rule_version,
       level, message, context_type, context_id, outcome, override_code,
       override_reason, fired_at, responded_by, responded_at
FROM clinical.cds_alert
WHERE tenant_id = @tenant_id
  AND (sqlc.narg('patient_id')::uuid IS NULL
       OR patient_id = sqlc.narg('patient_id')::uuid)
  AND (@outcome_filter::text = '' OR outcome = @outcome_filter::text)
  AND (@rule_filter::text = '' OR rule_id = @rule_filter::text)
ORDER BY fired_at DESC, alert_id
LIMIT @page_limit;

-- name: InsertConsult :exec
INSERT INTO clinical.consult (
    consult_id, tenant_id, patient_id, encounter_id, specialty, urgency,
    reason, question, status, responding_subject_id, response,
    response_document_id, decline_reason, requested_by, requested_at,
    responded_at, updated_at, version
) VALUES (
    @consult_id, @tenant_id, @patient_id, @encounter_id, @specialty, @urgency,
    @reason, @question, @status, '', '', NULL, '', @requested_by,
    @requested_at, NULL, @updated_at, 1
);

-- name: GetConsult :one
SELECT consult_id, tenant_id, patient_id, encounter_id, specialty, urgency,
       reason, question, status, responding_subject_id, response,
       response_document_id, decline_reason, requested_by, requested_at,
       responded_at, updated_at, version
FROM clinical.consult
WHERE tenant_id = @tenant_id AND consult_id = @consult_id;

-- name: UpdateConsult :execrows
UPDATE clinical.consult
SET status = @status, responding_subject_id = @responding_subject_id,
    response = @response,
    response_document_id = sqlc.narg('response_document_id')::uuid,
    decline_reason = @decline_reason,
    responded_at = sqlc.narg('responded_at')::timestamptz,
    updated_at = @updated_at, version = version + 1
WHERE tenant_id = @tenant_id
  AND consult_id = @consult_id
  AND version = @expected_version;

-- name: ListConsults :many
-- The receiving service's worklist, most urgent first.
SELECT consult_id, tenant_id, patient_id, encounter_id, specialty, urgency,
       reason, question, status, responding_subject_id, response,
       response_document_id, decline_reason, requested_by, requested_at,
       responded_at, updated_at, version
FROM clinical.consult
WHERE tenant_id = @tenant_id
  AND (sqlc.narg('patient_id')::uuid IS NULL
       OR patient_id = sqlc.narg('patient_id')::uuid)
  AND (@specialty_filter::text = '' OR specialty = @specialty_filter::text)
  AND (@open_only::boolean = false OR status IN ('requested', 'accepted'))
ORDER BY
    CASE urgency WHEN 'emergency' THEN 0 WHEN 'urgent' THEN 1 ELSE 2 END,
    requested_at, consult_id
LIMIT @page_limit;

-- name: InsertRegistryMembership :exec
INSERT INTO clinical.registry_membership (
    membership_id, tenant_id, patient_id, registry_id, problem_id,
    diagnosis_id, enrolled_at, exited_at, exit_reason, consented,
    enrolled_by, recorded_at
) VALUES (
    @membership_id, @tenant_id, @patient_id, @registry_id,
    sqlc.narg('problem_id')::uuid, sqlc.narg('diagnosis_id')::uuid,
    @enrolled_at, NULL, '', @consented, @enrolled_by, @recorded_at
);

-- name: ExitRegistryMembership :execrows
UPDATE clinical.registry_membership
SET exited_at = @exited_at, exit_reason = @exit_reason
WHERE tenant_id = @tenant_id
  AND membership_id = @membership_id
  AND exited_at IS NULL;

-- name: ListRegistryMemberships :many
SELECT membership_id, tenant_id, patient_id, registry_id, problem_id,
       diagnosis_id, enrolled_at, exited_at, exit_reason, consented,
       enrolled_by, recorded_at
FROM clinical.registry_membership
WHERE tenant_id = @tenant_id
  AND (sqlc.narg('patient_id')::uuid IS NULL
       OR patient_id = sqlc.narg('patient_id')::uuid)
  AND (@registry_filter::text = '' OR registry_id = @registry_filter::text)
  AND (@current_only::boolean = false OR exited_at IS NULL)
ORDER BY enrolled_at DESC, membership_id
LIMIT @page_limit;

-- name: UpsertSmartPhrase :exec
INSERT INTO clinical.smart_phrase (
    phrase_id, tenant_id, owner_id, shortcut, expansion, created_at, updated_at
) VALUES (
    @phrase_id, @tenant_id, @owner_id, @shortcut, @expansion, @created_at,
    @updated_at
)
ON CONFLICT (tenant_id, owner_id, shortcut)
DO UPDATE SET expansion = EXCLUDED.expansion, updated_at = EXCLUDED.updated_at;

-- name: ListSmartPhrases :many
-- A clinician's own phrases and the tenant's shared ones. Their own first, so
-- a personal override of a shared shortcut wins.
SELECT phrase_id, tenant_id, owner_id, shortcut, expansion, created_at, updated_at
FROM clinical.smart_phrase
WHERE tenant_id = @tenant_id
  AND (owner_id = @owner_id OR owner_id = '')
ORDER BY (owner_id = ''), shortcut;

-- name: ListTimelineEntries :many
-- The clinical half of the longitudinal timeline (SRS-ENC-011).
--
-- One query rather than five round trips, because the timeline is the screen
-- everybody keeps open. Confidentiality is returned rather than filtered here:
-- the encounter context applies the filter once, on the way out, so one rule
-- governs every contributing source.
SELECT d.document_id AS entry_id, 'note' AS kind, d.created_at AS at,
       d.encounter_id, d.title, d.confidentiality, d.authored_by
FROM clinical.document d
WHERE d.tenant_id = @tenant_id AND d.patient_id = @patient_id
  AND d.created_at >= @from_at::timestamptz AND d.created_at < @until_at::timestamptz
  AND d.status <> 'entered_in_error'

UNION ALL

SELECT o.observation_id AS entry_id, 'observation' AS kind, o.effective_at AS at,
       COALESCE(o.encounter_id, '00000000-0000-0000-0000-000000000000'::uuid),
       o.code_display AS title, 'normal' AS confidentiality, o.recorded_by AS authored_by
FROM clinical.observation o
WHERE o.tenant_id = @tenant_id AND o.patient_id = @patient_id
  AND o.effective_at >= @from_at::timestamptz AND o.effective_at < @until_at::timestamptz
  AND o.status NOT IN ('cancelled', 'entered_in_error')

UNION ALL

SELECT p.procedure_id AS entry_id, 'procedure' AS kind,
       COALESCE(p.performed_start, p.recorded_at) AS at,
       p.encounter_id, p.code_display AS title, 'normal' AS confidentiality,
       p.recorded_by AS authored_by
FROM clinical.procedure p
WHERE p.tenant_id = @tenant_id AND p.patient_id = @patient_id
  AND COALESCE(p.performed_start, p.recorded_at) >= @from_at::timestamptz
  AND COALESCE(p.performed_start, p.recorded_at) < @until_at::timestamptz
  AND p.status <> 'entered_in_error'

UNION ALL

SELECT a.allergy_id AS entry_id, 'allergy' AS kind, a.recorded_at AS at,
       COALESCE(a.encounter_id, '00000000-0000-0000-0000-000000000000'::uuid),
       a.substance_display AS title, 'normal' AS confidentiality,
       a.recorded_by AS authored_by
FROM clinical.allergy a
WHERE a.tenant_id = @tenant_id AND a.patient_id = @patient_id
  AND a.recorded_at >= @from_at::timestamptz AND a.recorded_at < @until_at::timestamptz
  AND a.verification <> 'entered_in_error'

ORDER BY at DESC, entry_id
LIMIT @page_limit;
