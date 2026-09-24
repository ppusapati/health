-- Nursing (SRS-NUR).

-- name: InsertAssessmentTemplate :exec
INSERT INTO nursing.assessment_template (
    template_id, tenant_id, version, name, min_age_years, max_age_years,
    service_code, sections, retired, created_by, created_at
) VALUES (
    @template_id, @tenant_id, @version, @name, @min_age_years, @max_age_years,
    @service_code, @sections, false, @created_by, @created_at
);

-- name: GetAssessmentTemplate :one
SELECT template_id, tenant_id, version, name, min_age_years, max_age_years,
       service_code, sections, retired, created_by, created_at
FROM nursing.assessment_template
WHERE tenant_id = @tenant_id AND template_id = @template_id
  AND version = @version;

-- name: ListAssessmentTemplates :many
-- Only the choosable ones by default: a retired template can be read on an old
-- assessment but must not be picked for a new one.
SELECT template_id, tenant_id, version, name, min_age_years, max_age_years,
       service_code, sections, retired, created_by, created_at
FROM nursing.assessment_template
WHERE tenant_id = @tenant_id
  AND (@include_retired::boolean = true OR retired = false)
  AND (@service_filter::text = '' OR service_code = @service_filter::text
       OR service_code = '')
ORDER BY name, version
LIMIT @page_limit;

-- name: RetireAssessmentTemplate :execrows
UPDATE nursing.assessment_template
SET retired = true
WHERE tenant_id = @tenant_id AND template_id = @template_id
  AND version = @version;

-- name: InsertAssessment :exec
INSERT INTO nursing.assessment (
    assessment_id, tenant_id, patient_id, encounter_id, kind, template_id,
    template_version, answers, assessed_at, recorded_at, assessed_by, version
) VALUES (
    @assessment_id, @tenant_id, @patient_id, @encounter_id, @kind, @template_id,
    @template_version, @answers, @assessed_at, @recorded_at, @assessed_by, 1
);

-- name: GetAssessment :one
SELECT assessment_id, tenant_id, patient_id, encounter_id, kind, template_id,
       template_version, answers, assessed_at, recorded_at, assessed_by, version
FROM nursing.assessment
WHERE tenant_id = @tenant_id AND assessment_id = @assessment_id;

-- name: ListAssessments :many
SELECT assessment_id, tenant_id, patient_id, encounter_id, kind, template_id,
       template_version, answers, assessed_at, recorded_at, assessed_by, version
FROM nursing.assessment
WHERE tenant_id = @tenant_id
  AND encounter_id = @encounter_id
  AND (@kind_filter::text = '' OR kind = @kind_filter::text)
ORDER BY assessed_at DESC
LIMIT @page_limit;

-- name: InsertRiskScale :exec
INSERT INTO nursing.risk_scale (
    scale_id, tenant_id, version, name, risk_domain, inputs, bands,
    reassess_after_seconds, retired, created_by, created_at
) VALUES (
    @scale_id, @tenant_id, @version, @name, @risk_domain, @inputs, @bands,
    @reassess_after_seconds, false, @created_by, @created_at
);

-- name: GetRiskScale :one
SELECT scale_id, tenant_id, version, name, risk_domain, inputs, bands,
       reassess_after_seconds, retired, created_by, created_at
FROM nursing.risk_scale
WHERE tenant_id = @tenant_id AND scale_id = @scale_id AND version = @version;

-- name: ListRiskScales :many
SELECT scale_id, tenant_id, version, name, risk_domain, inputs, bands,
       reassess_after_seconds, retired, created_by, created_at
FROM nursing.risk_scale
WHERE tenant_id = @tenant_id
  AND (@include_retired::boolean = true OR retired = false)
  AND (@domain_filter::text = '' OR risk_domain = @domain_filter::text)
ORDER BY name, version
LIMIT @page_limit;

-- name: InsertRiskAssessment :exec
INSERT INTO nursing.risk_assessment (
    risk_id, tenant_id, patient_id, encounter_id, scale_id, scale_version,
    risk_domain, inputs, total, band, escalate, assessed_at, recorded_at,
    assessed_by, due_at, version
) VALUES (
    @risk_id, @tenant_id, @patient_id, @encounter_id, @scale_id, @scale_version,
    @risk_domain, @inputs, @total, @band, @escalate, @assessed_at, @recorded_at,
    @assessed_by, @due_at, 1
);

-- name: SupersedeRiskAssessment :execrows
-- A recalculation never overwrites: the nurse acted on the old number.
UPDATE nursing.risk_assessment
SET superseded_by_id = sqlc.narg('superseded_by_id')::uuid, version = version + 1
WHERE tenant_id = @tenant_id AND risk_id = @risk_id
  AND superseded_by_id IS NULL;

-- name: LatestRiskAssessment :one
SELECT risk_id, tenant_id, patient_id, encounter_id, scale_id, scale_version,
       risk_domain, inputs, total, band, escalate, assessed_at, recorded_at,
       assessed_by, due_at, superseded_by_id, version
FROM nursing.risk_assessment
WHERE tenant_id = @tenant_id AND patient_id = @patient_id
  AND risk_domain = @risk_domain AND superseded_by_id IS NULL
ORDER BY assessed_at DESC
LIMIT 1;

-- name: ListRiskAssessments :many
SELECT risk_id, tenant_id, patient_id, encounter_id, scale_id, scale_version,
       risk_domain, inputs, total, band, escalate, assessed_at, recorded_at,
       assessed_by, due_at, superseded_by_id, version
FROM nursing.risk_assessment
WHERE tenant_id = @tenant_id AND patient_id = @patient_id
  AND (@domain_filter::text = '' OR risk_domain = @domain_filter::text)
ORDER BY assessed_at DESC
LIMIT @page_limit;

-- name: ListDueRiskAssessments :many
-- SRS-NUR-005: due reassessment appears as work.
SELECT risk_id, tenant_id, patient_id, encounter_id, scale_id, scale_version,
       risk_domain, inputs, total, band, escalate, assessed_at, recorded_at,
       assessed_by, due_at, superseded_by_id, version
FROM nursing.risk_assessment
WHERE tenant_id = @tenant_id
  AND superseded_by_id IS NULL
  AND due_at <= @as_of
  AND (sqlc.narg('encounter_filter')::uuid IS NULL
       OR encounter_id = sqlc.narg('encounter_filter')::uuid)
ORDER BY due_at
LIMIT @page_limit;

-- name: InsertFlowsheetEntry :exec
INSERT INTO nursing.flowsheet_entry (
    entry_id, tenant_id, patient_id, encounter_id, code_system, code_version,
    code, code_display, value_number, value_unit, value_text, coded_system,
    coded_code, coded_display, observed_at, recorded_at, source, device_id,
    recorded_by, late_entry_reason, version
) VALUES (
    @entry_id, @tenant_id, @patient_id, @encounter_id, @code_system,
    @code_version, @code, @code_display, sqlc.narg('value_number')::double precision, @value_unit,
    @value_text, @coded_system, @coded_code, @coded_display, @observed_at,
    @recorded_at, @source, @device_id, @recorded_by, @late_entry_reason, 1
);

-- name: ListFlowsheetEntries :many
-- Ordered by observation time, because sorting by typing order puts a late
-- 06:00 reading after the 08:00 one and draws a graph saying the patient
-- improved and then deteriorated.
SELECT entry_id, tenant_id, patient_id, encounter_id, code_system, code_version,
       code, code_display, value_number, value_unit, value_text, coded_system,
       coded_code, coded_display, observed_at, recorded_at, source, device_id,
       recorded_by, late_entry_reason, superseded_by_id, version
FROM nursing.flowsheet_entry
WHERE tenant_id = @tenant_id
  AND encounter_id = @encounter_id
  AND (@code_filter::text = '' OR code = @code_filter::text)
  AND observed_at >= @observed_from
  AND observed_at < @observed_to
  AND superseded_by_id IS NULL
ORDER BY observed_at, recorded_at
LIMIT @page_limit;

-- name: SupersedeFlowsheetEntry :execrows
UPDATE nursing.flowsheet_entry
SET superseded_by_id = sqlc.narg('superseded_by_id')::uuid, version = version + 1
WHERE tenant_id = @tenant_id AND entry_id = @entry_id
  AND superseded_by_id IS NULL;

-- name: InsertFluidEntry :exec
INSERT INTO nursing.fluid_entry (
    fluid_id, tenant_id, patient_id, encounter_id, direction, category,
    volume_ml, observed_at, recorded_at, recorded_by, supersedes_id,
    amendment_reason, version
) VALUES (
    @fluid_id, @tenant_id, @patient_id, @encounter_id, @direction, @category,
    @volume_ml, @observed_at, @recorded_at, @recorded_by, sqlc.narg('supersedes_id')::uuid,
    @amendment_reason, 1
);

-- name: SupersedeFluidEntry :execrows
-- The original stays readable: the shift total that was handed over was
-- computed from it.
UPDATE nursing.fluid_entry
SET superseded_by_id = sqlc.narg('superseded_by_id')::uuid, version = version + 1
WHERE tenant_id = @tenant_id AND fluid_id = @fluid_id
  AND superseded_by_id IS NULL AND voided_reason = '';

-- name: VoidFluidEntry :execrows
UPDATE nursing.fluid_entry
SET voided_reason = @voided_reason, recorded_at = @recorded_at,
    version = version + 1
WHERE tenant_id = @tenant_id AND fluid_id = @fluid_id
  AND superseded_by_id IS NULL AND voided_reason = '';

-- name: GetFluidEntry :one
SELECT fluid_id, tenant_id, patient_id, encounter_id, direction, category,
       volume_ml, observed_at, recorded_at, recorded_by, superseded_by_id,
       supersedes_id, amendment_reason, voided_reason, version
FROM nursing.fluid_entry
WHERE tenant_id = @tenant_id AND fluid_id = @fluid_id;

-- name: ListFluidEntries :many
-- Bounded by observation time, so a 06:00 reading charted at 08:40 falls in the
-- night shift's balance where it belongs.
SELECT fluid_id, tenant_id, patient_id, encounter_id, direction, category,
       volume_ml, observed_at, recorded_at, recorded_by, superseded_by_id,
       supersedes_id, amendment_reason, voided_reason, version
FROM nursing.fluid_entry
WHERE tenant_id = @tenant_id
  AND encounter_id = @encounter_id
  AND observed_at >= @observed_from
  AND observed_at < @observed_to
  AND (@include_superseded::boolean = true
       OR (superseded_by_id IS NULL AND voided_reason = ''))
ORDER BY observed_at, recorded_at
LIMIT @page_limit;

-- name: InsertDevice :exec
INSERT INTO nursing.device (
    device_id, tenant_id, patient_id, encounter_id, kind, site, laterality,
    size, lot, inserted_at, inserted_by, version
) VALUES (
    @device_id, @tenant_id, @patient_id, @encounter_id, @kind, @site,
    @laterality, @size, @lot, @inserted_at, @inserted_by, 1
);

-- name: GetDevice :one
SELECT device_id, tenant_id, patient_id, encounter_id, kind, site, laterality,
       size, lot, inserted_at, inserted_by, removed_at, removed_by,
       removal_reason, version
FROM nursing.device
WHERE tenant_id = @tenant_id AND device_id = @device_id;

-- name: RemoveDevice :execrows
UPDATE nursing.device
SET removed_at = sqlc.narg('removed_at')::timestamptz, removed_by = @removed_by,
    removal_reason = @removal_reason, version = version + 1
WHERE tenant_id = @tenant_id AND device_id = @device_id
  AND removed_at IS NULL AND version = @expected_version;

-- name: ListDevices :many
SELECT device_id, tenant_id, patient_id, encounter_id, kind, site, laterality,
       size, lot, inserted_at, inserted_by, removed_at, removed_by,
       removal_reason, version
FROM nursing.device
WHERE tenant_id = @tenant_id
  AND encounter_id = @encounter_id
  AND (@in_place_only::boolean = false OR removed_at IS NULL)
ORDER BY inserted_at DESC
LIMIT @page_limit;

-- name: InsertDeviceCare :exec
INSERT INTO nursing.device_care (
    care_id, tenant_id, device_id, kind, finding, output_ml, performed_at,
    performed_by
) VALUES (
    @care_id, @tenant_id, @device_id, @kind, @finding, @output_ml,
    @performed_at, @performed_by
);

-- name: ListDeviceCare :many
SELECT care_id, tenant_id, device_id, kind, finding, output_ml, performed_at,
       performed_by
FROM nursing.device_care
WHERE tenant_id = @tenant_id AND device_id = @device_id
ORDER BY performed_at DESC
LIMIT @page_limit;

-- name: InsertAdministration :exec
-- SRS-NUR-018: the unique index on (tenant, order, scheduled_at) rejects a
-- second transcription of the same paper entry. The refusal is a constraint
-- violation the adapter maps, not a check this query performs, because the two
-- transcriptions can be in flight at the same moment.
INSERT INTO nursing.administration (
    administration_id, tenant_id, patient_id, encounter_id, order_id,
    medication_system, medication_version, medication_code, medication_display,
    scheduled_dose, scheduled_unit, scheduled_at, given_dose, given_unit,
    given_at, route, site, outcome, reason, scan_performed, scanned_patient,
    scanned_medication, scanned_at, override_reason, override_by, override_at,
    override_patient_mismatch, override_medication_mismatch,
    override_not_scanned, idempotency_key, recorded_offline, administered_by,
    witnessed_by, recorded_at, version
) VALUES (
    @administration_id, @tenant_id, @patient_id, @encounter_id, @order_id,
    @medication_system, @medication_version, @medication_code,
    @medication_display, @scheduled_dose, @scheduled_unit, sqlc.narg('scheduled_at')::timestamptz,
    @given_dose, @given_unit, sqlc.narg('given_at')::timestamptz, @route, @site, @outcome, @reason,
    @scan_performed, @scanned_patient, @scanned_medication, sqlc.narg('scanned_at')::timestamptz,
    @override_reason, @override_by, sqlc.narg('override_at')::timestamptz, @override_patient_mismatch,
    @override_medication_mismatch, @override_not_scanned, @idempotency_key,
    @recorded_offline, @administered_by, @witnessed_by, @recorded_at, 1
);

-- name: FindAdministrationForDose :one
-- What the duplicate refusal names, so a transcriber checks rather than retries
-- with a changed time.
SELECT administration_id, tenant_id, patient_id, encounter_id, order_id,
       scheduled_at, given_at, outcome, administered_by, recorded_at
FROM nursing.administration
WHERE tenant_id = @tenant_id AND order_id = @order_id
  AND scheduled_at = @scheduled_at;

-- name: ListAdministrations :many
SELECT administration_id, tenant_id, patient_id, encounter_id, order_id,
       medication_system, medication_version, medication_code,
       medication_display, scheduled_dose, scheduled_unit, scheduled_at,
       given_dose, given_unit, given_at, route, site, outcome, reason,
       scan_performed, scanned_patient, scanned_medication, scanned_at,
       override_reason, override_by, override_at, override_patient_mismatch,
       override_medication_mismatch, override_not_scanned, idempotency_key,
       recorded_offline, administered_by, witnessed_by, recorded_at, version
FROM nursing.administration
WHERE tenant_id = @tenant_id
  AND encounter_id = @encounter_id
  AND (sqlc.narg('order_filter')::uuid IS NULL
       OR order_id = sqlc.narg('order_filter')::uuid)
ORDER BY COALESCE(scheduled_at, given_at, recorded_at) DESC
LIMIT @page_limit;

-- name: ListOverrides :many
-- The report that gets a broken scanner replaced (SRS-NUR-008).
SELECT administration_id, tenant_id, patient_id, encounter_id, order_id,
       medication_display, override_reason, override_by, override_at,
       override_patient_mismatch, override_medication_mismatch,
       override_not_scanned, administered_by
FROM nursing.administration
WHERE tenant_id = @tenant_id
  AND override_reason <> ''
  AND override_at >= @from_time
  AND override_at < @to_time
ORDER BY override_at DESC
LIMIT @page_limit;

-- name: UpsertAdministrationPolicy :exec
INSERT INTO nursing.administration_policy (
    tenant_id, facility_id, barcode_required, override_allowed,
    late_after_seconds, updated_by, updated_at
) VALUES (
    @tenant_id, @facility_id, @barcode_required, @override_allowed,
    @late_after_seconds, @updated_by, @updated_at
)
ON CONFLICT (tenant_id, facility_id) DO UPDATE
SET barcode_required = EXCLUDED.barcode_required,
    override_allowed = EXCLUDED.override_allowed,
    late_after_seconds = EXCLUDED.late_after_seconds,
    updated_by = EXCLUDED.updated_by,
    updated_at = EXCLUDED.updated_at;

-- name: GetAdministrationPolicy :one
SELECT tenant_id, facility_id, barcode_required, override_allowed,
       late_after_seconds, updated_by, updated_at
FROM nursing.administration_policy
WHERE tenant_id = @tenant_id AND facility_id = @facility_id;

-- name: InsertTask :exec
INSERT INTO nursing.task (
    task_id, tenant_id, patient_id, encounter_id, description, priority,
    due_at, source_kind, source_id, recur_every_seconds, recur_until, status,
    assigned_to, created_at, created_by, version
) VALUES (
    @task_id, @tenant_id, @patient_id, @encounter_id, @description, @priority,
    @due_at, @source_kind, @source_id, @recur_every_seconds, sqlc.narg('recur_until')::timestamptz,
    'pending', @assigned_to, @created_at, @created_by, 1
);

-- name: GetTask :one
SELECT task_id, tenant_id, patient_id, encounter_id, description, priority,
       due_at, source_kind, source_id, recur_every_seconds, recur_until,
       status, evidence, completed_at, completed_by, not_done_reason,
       assigned_to, escalated_at, escalated_to, created_at, created_by, version
FROM nursing.task
WHERE tenant_id = @tenant_id AND task_id = @task_id;

-- name: CloseTask :execrows
-- Guarded on the task still being pending as well as on its version, so a
-- second nurse completing the same task does not overwrite the first one's
-- evidence.
UPDATE nursing.task
SET status = @status, evidence = @evidence, completed_at = sqlc.narg('completed_at')::timestamptz,
    completed_by = @completed_by, not_done_reason = @not_done_reason,
    version = version + 1
WHERE tenant_id = @tenant_id AND task_id = @task_id
  AND status = 'pending' AND version = @expected_version;

-- name: EscalateTask :execrows
UPDATE nursing.task
SET escalated_at = sqlc.narg('escalated_at')::timestamptz, escalated_to = @escalated_to,
    version = version + 1
WHERE tenant_id = @tenant_id AND task_id = @task_id
  AND status = 'pending' AND escalated_at IS NULL;

-- name: ListWorklist :many
-- Ordered the way a nurse works: most urgent first, then by how overdue.
SELECT task_id, tenant_id, patient_id, encounter_id, description, priority,
       due_at, source_kind, source_id, recur_every_seconds, recur_until,
       status, evidence, completed_at, completed_by, not_done_reason,
       assigned_to, escalated_at, escalated_to, created_at, created_by, version
FROM nursing.task
WHERE tenant_id = @tenant_id
  AND (sqlc.narg('encounter_filter')::uuid IS NULL
       OR encounter_id = sqlc.narg('encounter_filter')::uuid)
  AND (@assignee_filter::text = '' OR assigned_to = @assignee_filter::text)
  AND (@pending_only::boolean = false OR status = 'pending')
ORDER BY
    CASE priority WHEN 'critical' THEN 0 WHEN 'urgent' THEN 1 ELSE 2 END,
    due_at
LIMIT @page_limit;

-- name: ListTasksNeedingEscalation :many
-- SRS-NUR-011: overdue critical work, and only critical. A stream nobody reads
-- loses the critical one first.
SELECT task_id, tenant_id, patient_id, encounter_id, description, priority,
       due_at, assigned_to, created_at, created_by, version
FROM nursing.task
WHERE tenant_id = @tenant_id
  AND status = 'pending'
  AND priority = 'critical'
  AND escalated_at IS NULL
  AND due_at < @as_of
ORDER BY due_at
LIMIT @page_limit;

-- name: InsertNursingCarePlan :exec
INSERT INTO nursing.care_plan (
    plan_id, tenant_id, patient_id, encounter_id, title, problems, status,
    created_at, created_by, version
) VALUES (
    @plan_id, @tenant_id, @patient_id, @encounter_id, @title, @problems,
    'active', @created_at, @created_by, 1
);

-- name: GetNursingCarePlan :one
SELECT plan_id, tenant_id, patient_id, encounter_id, title, problems, status,
       created_at, created_by, reviewed_at, reviewed_by, evaluation, version
FROM nursing.care_plan
WHERE tenant_id = @tenant_id AND plan_id = @plan_id;

-- name: UpdateNursingCarePlan :execrows
UPDATE nursing.care_plan
SET problems = @problems, status = @status, reviewed_at = sqlc.narg('reviewed_at')::timestamptz,
    reviewed_by = @reviewed_by, evaluation = @evaluation, version = version + 1
WHERE tenant_id = @tenant_id AND plan_id = @plan_id
  AND version = @expected_version;

-- name: ListNursingCarePlans :many
SELECT plan_id, tenant_id, patient_id, encounter_id, title, problems, status,
       created_at, created_by, reviewed_at, reviewed_by, evaluation, version
FROM nursing.care_plan
WHERE tenant_id = @tenant_id AND encounter_id = @encounter_id
  AND (@active_only::boolean = false OR status = 'active')
ORDER BY created_at DESC
LIMIT @page_limit;

-- name: InsertHandover :exec
INSERT INTO nursing.handover (
    handover_id, tenant_id, patient_id, encounter_id, unit_id,
    from_shift_code, from_shift_start, from_shift_end,
    to_shift_code, to_shift_start, to_shift_end,
    situation, background, assessment, recommendation, critical_risks,
    outstanding, devices, pending_tasks, composed_at, composed_by, version
) VALUES (
    @handover_id, @tenant_id, @patient_id, @encounter_id, @unit_id,
    @from_shift_code, sqlc.narg('from_shift_start')::timestamptz,
    sqlc.narg('from_shift_end')::timestamptz,
    @to_shift_code, sqlc.narg('to_shift_start')::timestamptz,
    sqlc.narg('to_shift_end')::timestamptz,
    @situation, @background, @assessment, @recommendation, @critical_risks,
    @outstanding, @devices, @pending_tasks, @composed_at, @composed_by, 1
);

-- name: GetHandover :one
SELECT handover_id, tenant_id, patient_id, encounter_id, unit_id,
       from_shift_code, from_shift_start, from_shift_end,
       to_shift_code, to_shift_start, to_shift_end,
       situation, background, assessment, recommendation, critical_risks,
       outstanding, devices, pending_tasks, composed_at, composed_by,
       acknowledged_at, acknowledged_by, questions, version
FROM nursing.handover
WHERE tenant_id = @tenant_id AND handover_id = @handover_id;

-- name: AcknowledgeHandover :execrows
-- Guarded on the handover still being unacknowledged, so responsibility cannot
-- be accepted twice and the record cannot be made to show a second transfer.
UPDATE nursing.handover
SET acknowledged_at = sqlc.narg('acknowledged_at')::timestamptz, acknowledged_by = @acknowledged_by,
    questions = @questions, version = version + 1
WHERE tenant_id = @tenant_id AND handover_id = @handover_id
  AND acknowledged_at IS NULL;

-- name: ListHandovers :many
SELECT handover_id, tenant_id, patient_id, encounter_id, unit_id,
       from_shift_code, from_shift_start, from_shift_end,
       to_shift_code, to_shift_start, to_shift_end,
       situation, background, assessment, recommendation, critical_risks,
       outstanding, devices, pending_tasks, composed_at, composed_by,
       acknowledged_at, acknowledged_by, questions, version
FROM nursing.handover
WHERE tenant_id = @tenant_id
  AND (sqlc.narg('encounter_filter')::uuid IS NULL
       OR encounter_id = sqlc.narg('encounter_filter')::uuid)
  AND (@unacknowledged_only::boolean = false OR acknowledged_at IS NULL)
ORDER BY composed_at DESC
LIMIT @page_limit;

-- name: InsertRestraint :exec
INSERT INTO nursing.restraint (
    restraint_id, tenant_id, patient_id, encounter_id, kind, description,
    authorized_by, authorized_at, expires_at, indication, renewals,
    started_at, started_by, monitor_every_seconds, version
) VALUES (
    @restraint_id, @tenant_id, @patient_id, @encounter_id, @kind, @description,
    @authorized_by, @authorized_at, @expires_at, @indication, @renewals,
    @started_at, @started_by, @monitor_every_seconds, 1
);

-- name: GetRestraint :one
SELECT restraint_id, tenant_id, patient_id, encounter_id, kind, description,
       authorized_by, authorized_at, expires_at, indication, renewals,
       started_at, started_by, monitor_every_seconds, discontinued_at,
       discontinued_by, discontinued_reason, version
FROM nursing.restraint
WHERE tenant_id = @tenant_id AND restraint_id = @restraint_id;

-- name: RenewRestraint :execrows
UPDATE nursing.restraint
SET renewals = @renewals, version = version + 1
WHERE tenant_id = @tenant_id AND restraint_id = @restraint_id
  AND discontinued_at IS NULL AND version = @expected_version;

-- name: DiscontinueRestraint :execrows
UPDATE nursing.restraint
SET discontinued_at = sqlc.narg('discontinued_at')::timestamptz, discontinued_by = @discontinued_by,
    discontinued_reason = @discontinued_reason, version = version + 1
WHERE tenant_id = @tenant_id AND restraint_id = @restraint_id
  AND discontinued_at IS NULL AND version = @expected_version;

-- name: ListRestraints :many
SELECT restraint_id, tenant_id, patient_id, encounter_id, kind, description,
       authorized_by, authorized_at, expires_at, indication, renewals,
       started_at, started_by, monitor_every_seconds, discontinued_at,
       discontinued_by, discontinued_reason, version
FROM nursing.restraint
WHERE tenant_id = @tenant_id
  AND (sqlc.narg('encounter_filter')::uuid IS NULL
       OR encounter_id = sqlc.narg('encounter_filter')::uuid)
  AND (@active_only::boolean = false OR discontinued_at IS NULL)
ORDER BY started_at DESC
LIMIT @page_limit;

-- name: ListExpiredRestraints :many
-- SRS-NUR-013: an expired authorization raises an alert. It does not free the
-- patient, so these rows are still active restraints.
SELECT restraint_id, tenant_id, patient_id, encounter_id, kind, description,
       authorized_by, expires_at, indication, started_at, monitor_every_seconds,
       version
FROM nursing.restraint
WHERE tenant_id = @tenant_id
  AND discontinued_at IS NULL
  AND expires_at <= @as_of
ORDER BY expires_at
LIMIT @page_limit;

-- name: InsertRestraintCheck :exec
INSERT INTO nursing.restraint_check (
    check_id, tenant_id, restraint_id, observed_at, observed_by, findings,
    continued_reason
) VALUES (
    @check_id, @tenant_id, @restraint_id, @observed_at, @observed_by,
    @findings, @continued_reason
);

-- name: ListRestraintChecks :many
SELECT check_id, tenant_id, restraint_id, observed_at, observed_by, findings,
       continued_reason
FROM nursing.restraint_check
WHERE tenant_id = @tenant_id AND restraint_id = @restraint_id
ORDER BY observed_at
LIMIT @page_limit;

-- name: InsertWoundAssessment :exec
INSERT INTO nursing.wound_assessment (
    wound_assessment_id, tenant_id, patient_id, encounter_id, wound_id,
    location, body_map_system, body_map_code, body_map_display, laterality,
    kind, stage, length_mm, width_mm, depth_mm, appearance, exudate,
    surrounding_skin, pain_score, assessed_at, recorded_at, assessed_by, version
) VALUES (
    @wound_assessment_id, @tenant_id, @patient_id, @encounter_id, @wound_id,
    @location, @body_map_system, @body_map_code, @body_map_display, @laterality,
    @kind, @stage, @length_mm, @width_mm, @depth_mm, @appearance, @exudate,
    @surrounding_skin, sqlc.narg('pain_score')::integer, @assessed_at, @recorded_at, @assessed_by, 1
);

-- name: GetWoundAssessment :one
SELECT wound_assessment_id, tenant_id, patient_id, encounter_id, wound_id,
       location, body_map_system, body_map_code, body_map_display, laterality,
       kind, stage, length_mm, width_mm, depth_mm, appearance, exudate,
       surrounding_skin, pain_score, assessed_at, recorded_at, assessed_by,
       version
FROM nursing.wound_assessment
WHERE tenant_id = @tenant_id AND wound_assessment_id = @wound_assessment_id;

-- name: ListWoundAssessments :many
SELECT wound_assessment_id, tenant_id, patient_id, encounter_id, wound_id,
       location, body_map_system, body_map_code, body_map_display, laterality,
       kind, stage, length_mm, width_mm, depth_mm, appearance, exudate,
       surrounding_skin, pain_score, assessed_at, recorded_at, assessed_by,
       version
FROM nursing.wound_assessment
WHERE tenant_id = @tenant_id AND patient_id = @patient_id
  AND (@wound_filter::text = '' OR wound_id = @wound_filter::text)
ORDER BY assessed_at DESC
LIMIT @page_limit;

-- name: InsertWoundImage :exec
INSERT INTO nursing.wound_image (
    image_id, tenant_id, wound_assessment_id, consent_id, storage_key,
    content_type, captured_at, captured_by, sequence
) VALUES (
    @image_id, @tenant_id, @wound_assessment_id, @consent_id, @storage_key,
    @content_type, @captured_at, @captured_by, @sequence
);

-- name: ListWoundImages :many
SELECT image_id, tenant_id, wound_assessment_id, consent_id, storage_key,
       content_type, captured_at, captured_by, sequence
FROM nursing.wound_image
WHERE tenant_id = @tenant_id AND wound_assessment_id = @wound_assessment_id
ORDER BY sequence;

-- name: InsertEducation :exec
INSERT INTO nursing.education (
    education_id, tenant_id, patient_id, encounter_id, topic_system,
    topic_version, topic_code, topic_display, learner, learner_name, method,
    understanding, barriers, taught_at, taught_by, version
) VALUES (
    @education_id, @tenant_id, @patient_id, @encounter_id, @topic_system,
    @topic_version, @topic_code, @topic_display, @learner, @learner_name,
    @method, @understanding, @barriers, @taught_at, @taught_by, 1
);

-- name: ListEducation :many
SELECT education_id, tenant_id, patient_id, encounter_id, topic_system,
       topic_version, topic_code, topic_display, learner, learner_name, method,
       understanding, barriers, taught_at, taught_by, version
FROM nursing.education
WHERE tenant_id = @tenant_id AND patient_id = @patient_id
ORDER BY taught_at DESC
LIMIT @page_limit;

-- name: InsertAssignment :exec
INSERT INTO nursing.assignment (
    assignment_id, tenant_id, unit_id, bed_id, patient_id, nurse_id,
    relationship, effective_from, assigned_by, version
) VALUES (
    @assignment_id, @tenant_id, @unit_id, @bed_id, sqlc.narg('patient_id')::uuid, @nurse_id,
    @relationship, @effective_from, @assigned_by, 1
);

-- name: EndAssignment :execrows
-- Closed rather than deleted, so the answer to "who held this patient last
-- Tuesday night" survives the shift ending.
UPDATE nursing.assignment
SET effective_to = sqlc.narg('effective_to')::timestamptz, ended_reason = @ended_reason,
    version = version + 1
WHERE tenant_id = @tenant_id AND assignment_id = @assignment_id
  AND effective_to IS NULL;

-- name: ListAssignments :many
-- Answered as of a time, because the question an incident review asks is "who
-- was looking after this patient at 03:40".
SELECT assignment_id, tenant_id, unit_id, bed_id, patient_id, nurse_id,
       relationship, effective_from, effective_to, assigned_by, ended_reason,
       version
FROM nursing.assignment
WHERE tenant_id = @tenant_id
  AND (@unit_filter::text = '' OR unit_id = @unit_filter::text)
  AND (sqlc.narg('patient_filter')::uuid IS NULL
       OR patient_id = sqlc.narg('patient_filter')::uuid)
  AND (@nurse_filter::text = '' OR nurse_id = @nurse_filter::text)
  AND effective_from <= @as_of
  AND (effective_to IS NULL OR effective_to > @as_of)
ORDER BY effective_from DESC
LIMIT @page_limit;

-- name: CountNursesOnDuty :one
-- Counted from live assignments, not from a roster: a roster says who was meant
-- to be there.
SELECT COUNT(DISTINCT nurse_id)
FROM nursing.assignment
WHERE tenant_id = @tenant_id AND unit_id = @unit_id
  AND effective_from <= @as_of
  AND (effective_to IS NULL OR effective_to > @as_of);

-- name: UpsertAcuityWeights :exec
INSERT INTO nursing.acuity_weights (
    tenant_id, unit_id, dependency, open_task, overdue_task, device,
    high_risk, isolation, updated_by, updated_at
) VALUES (
    @tenant_id, @unit_id, @dependency, @open_task, @overdue_task, @device,
    @high_risk, @isolation, @updated_by, @updated_at
)
ON CONFLICT (tenant_id, unit_id) DO UPDATE
SET dependency = EXCLUDED.dependency, open_task = EXCLUDED.open_task,
    overdue_task = EXCLUDED.overdue_task, device = EXCLUDED.device,
    high_risk = EXCLUDED.high_risk, isolation = EXCLUDED.isolation,
    updated_by = EXCLUDED.updated_by, updated_at = EXCLUDED.updated_at;

-- name: GetAcuityWeights :one
SELECT tenant_id, unit_id, dependency, open_task, overdue_task, device,
       high_risk, isolation, updated_by, updated_at
FROM nursing.acuity_weights
WHERE tenant_id = @tenant_id AND unit_id = @unit_id;

-- name: InsertNursingDowntime :exec
INSERT INTO nursing.downtime_episode (
    episode_id, tenant_id, unit_id, reason, started_at, started_by, version
) VALUES (
    @episode_id, @tenant_id, @unit_id, @reason, @started_at, @started_by, 1
);

-- name: GetNursingDowntime :one
SELECT episode_id, tenant_id, unit_id, reason, started_at, started_by,
       ended_at, ended_by, reconciled_at, reconciled_by, version
FROM nursing.downtime_episode
WHERE tenant_id = @tenant_id AND episode_id = @episode_id;

-- name: EndNursingDowntime :execrows
UPDATE nursing.downtime_episode
SET ended_at = sqlc.narg('ended_at')::timestamptz, ended_by = @ended_by, version = version + 1
WHERE tenant_id = @tenant_id AND episode_id = @episode_id
  AND ended_at IS NULL;

-- name: ReconcileNursingDowntime :execrows
-- Guarded on the episode having ended and not yet been reconciled: reconciling
-- an open episode claims the paper is fully entered while the ward is still
-- writing on it.
UPDATE nursing.downtime_episode
SET reconciled_at = sqlc.narg('reconciled_at')::timestamptz, reconciled_by = @reconciled_by,
    version = version + 1
WHERE tenant_id = @tenant_id AND episode_id = @episode_id
  AND ended_at IS NOT NULL AND reconciled_at IS NULL;

-- name: ListNursingDowntime :many
SELECT episode_id, tenant_id, unit_id, reason, started_at, started_by,
       ended_at, ended_by, reconciled_at, reconciled_by, version
FROM nursing.downtime_episode
WHERE tenant_id = @tenant_id
  AND (@unit_filter::text = '' OR unit_id = @unit_filter::text)
  AND (@unreconciled_only::boolean = false OR reconciled_at IS NULL)
ORDER BY started_at DESC
LIMIT @page_limit;

-- No transfusion queries. bloodbank.episode is the record of a
-- transfusion (SRS-NUR-014, SRS-BLD-010) and migration 0047 moved the
-- rows; what is left in nursing.transfusion is the archive of the ones
-- that could not be linked, and nothing here reads it.

