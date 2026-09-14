-- Medication management (SRS-MED).
--
-- Every statement is scoped by tenant_id in its WHERE clause as well as by the
-- caller's verified TenantScope, so a missing scope is a query that returns
-- nothing rather than a query that returns somebody else's prescriptions.
--
-- The writes that change a therapy are guarded on the prescription's version,
-- which is how two clinicians holding the same drug at once resolve to one
-- ledger entry rather than two.

-- name: InsertPrescription :exec
-- Written fully formed, including its therapy status: a prescription that
-- reached the table as a draft and was then updated would be visible to a
-- concurrent reader in a state the prescriber never intended.
INSERT INTO medication.prescription (
    prescription_id, tenant_id, order_id, order_number,
    patient_id, encounter_id, facility_id, prescriber_id, entered_by_id,
    ingredient_system, ingredient_code, ingredient_display, ingredient_version,
    product_system, product_code, product_display,
    route, starts_at, stop_kind, stop_at, stop_doses, stop_text,
    indication, indication_system, indication_code, indication_display, instructions,
    prn, prn_indication, prn_min_interval, prn_max_doses,
    prn_max_total_value, prn_max_total_unit, prn_period,
    therapy_status, effective_stop,
    verified_by, verified_at, verification_note,
    formulary_status, formulary_scope, formulary_scope_id,
    formulary_restriction, formulary_approval_path,
    screened_at, created_at, updated_at, version
) VALUES (
    @prescription_id, @tenant_id, @order_id, @order_number,
    @patient_id, @encounter_id, @facility_id, @prescriber_id, @entered_by_id,
    @ingredient_system, @ingredient_code, @ingredient_display, @ingredient_version,
    @product_system, @product_code, @product_display,
    @route, @starts_at, @stop_kind, sqlc.narg('stop_at')::timestamptz,
    @stop_doses, @stop_text,
    @indication, @indication_system, @indication_code, @indication_display, @instructions,
    @prn, @prn_indication, sqlc.narg('prn_min_interval')::interval, @prn_max_doses,
    sqlc.narg('prn_max_total_value')::numeric, @prn_max_total_unit,
    sqlc.narg('prn_period')::interval,
    @therapy_status, sqlc.narg('effective_stop')::timestamptz,
    @verified_by, sqlc.narg('verified_at')::timestamptz, @verification_note,
    @formulary_status, @formulary_scope, @formulary_scope_id,
    @formulary_restriction, @formulary_approval_path,
    sqlc.narg('screened_at')::timestamptz, @created_at, @updated_at, @version
);

-- name: InsertDoseSegment :exec
INSERT INTO medication.dose_segment (
    tenant_id, prescription_id, sequence,
    dose_value, dose_unit, free_text_dose,
    frequency_text, interval_period, times_of_day, days_of_week, prn, dose_duration,
    starts_at, ends_at, note, version
) VALUES (
    @tenant_id, @prescription_id, @sequence,
    sqlc.narg('dose_value')::numeric, @dose_unit, @free_text_dose,
    @frequency_text, sqlc.narg('interval_period')::interval,
    @times_of_day::integer[], @days_of_week::integer[], @prn,
    sqlc.narg('dose_duration')::interval,
    @starts_at, sqlc.narg('ends_at')::timestamptz, @note, @version
);

-- name: DeleteDoseSegments :exec
-- Segments are rewritten as a set when a prescription is re-versioned, because
-- a taper is one instruction: leaving an old step behind would put a dose on the
-- chart that no current version of the prescription asks for.
DELETE FROM medication.dose_segment
WHERE tenant_id = @tenant_id AND prescription_id = @prescription_id;

-- name: GetPrescription :one
SELECT * FROM medication.prescription
WHERE tenant_id = @tenant_id AND prescription_id = @prescription_id;

-- name: GetPrescriptionByOrder :one
SELECT * FROM medication.prescription
WHERE tenant_id = @tenant_id AND order_id = @order_id;

-- name: ListDoseSegments :many
SELECT * FROM medication.dose_segment
WHERE tenant_id = @tenant_id AND prescription_id = @prescription_id
ORDER BY sequence;

-- name: ListPrescriptionSafetyFindings :many
SELECT * FROM medication.safety_finding
WHERE tenant_id = @tenant_id AND prescription_id = @prescription_id
ORDER BY finding_id;

-- name: ListTherapyChanges :many
SELECT * FROM medication.therapy_change
WHERE tenant_id = @tenant_id AND prescription_id = @prescription_id
ORDER BY effective_at, recorded_at;

-- name: InsertSafetyFinding :exec
INSERT INTO medication.safety_finding (
    finding_id, tenant_id, prescription_id, kind, severity,
    rule_id, rule_version, summary, subjects, inputs,
    override_by, override_at, override_reason
) VALUES (
    @finding_id, @tenant_id, @prescription_id, @kind, @severity,
    @rule_id, @rule_version, @summary, @subjects, @inputs,
    @override_by, sqlc.narg('override_at')::timestamptz, @override_reason
);

-- name: UpdateTherapyStatus :execrows
-- Guarded on the version, so two clinicians holding the same drug at the same
-- moment produce one ledger entry rather than two. The status precondition is
-- part of the guard rather than a read-then-write, because the read and the
-- write are not one act.
UPDATE medication.prescription
SET therapy_status = @therapy_status,
    effective_stop = sqlc.narg('effective_stop')::timestamptz,
    updated_at = @updated_at,
    version = @version
WHERE tenant_id = @tenant_id
  AND prescription_id = @prescription_id
  AND version = @expected_version
  AND therapy_status = @expected_status;

-- name: InsertTherapyChange :exec
INSERT INTO medication.therapy_change (
    change_id, tenant_id, prescription_id,
    from_status, to_status, effective_at, recorded_at, changed_by, reason
) VALUES (
    @change_id, @tenant_id, @prescription_id,
    @from_status, @to_status, @effective_at, @recorded_at, @changed_by, @reason
);

-- name: VerifyPrescription :execrows
-- Guarded on the prescription still being unverified as well as on its version,
-- so a second pharmacist arriving at the same moment does not move the
-- timestamp that records when the check happened.
UPDATE medication.prescription
SET verified_by = @verified_by,
    verified_at = @verified_at,
    verification_note = @verification_note,
    updated_at = @updated_at,
    version = @version
WHERE tenant_id = @tenant_id
  AND prescription_id = @prescription_id
  AND version = @expected_version
  AND verified_by = '';

-- name: RecordSafetyOverride :execrows
UPDATE medication.safety_finding
SET override_by = @override_by,
    override_at = @override_at,
    override_reason = @override_reason
WHERE tenant_id = @tenant_id
  AND finding_id = @finding_id
  AND override_by = '';

-- name: ListPrescriptionsForEncounter :many
SELECT * FROM medication.prescription
WHERE tenant_id = @tenant_id
  AND encounter_id = @encounter_id
  AND (NOT @live_only::boolean OR therapy_status IN ('active', 'held'))
ORDER BY starts_at DESC
LIMIT @row_limit;

-- name: ListLivePrescriptionsForPatient :many
-- What the interaction and duplicate-therapy screens read (SRS-MED-003). Held
-- medications are included: a drug paused for a procedure is still in the
-- patient, and an interaction with it is still an interaction.
SELECT * FROM medication.prescription
WHERE tenant_id = @tenant_id
  AND patient_id = @patient_id
  AND therapy_status IN ('active', 'held')
ORDER BY starts_at DESC
LIMIT @row_limit;

-- name: ListPrescriptionsAwaitingVerification :many
-- The pharmacy worklist (SRS-MED-006).
SELECT * FROM medication.prescription
WHERE tenant_id = @tenant_id
  AND facility_id = @facility_id
  AND therapy_status = 'active'
  AND verified_by = ''
ORDER BY created_at
LIMIT @row_limit;

-- name: InsertReconciliation :exec
INSERT INTO medication.reconciliation (
    reconciliation_id, tenant_id, patient_id, encounter_id, event,
    started_by, started_at, completed_by, completed_at, updated_at, version
) VALUES (
    @reconciliation_id, @tenant_id, @patient_id, @encounter_id, @event,
    @started_by, @started_at, '', NULL, @updated_at, @version
);

-- name: InsertReconciliationItem :exec
INSERT INTO medication.reconciliation_item (
    tenant_id, reconciliation_id, sequence,
    medication_system, medication_code, medication_display,
    dose_text, route, source, disposition, rationale,
    resulting_prescription_id, decided_by, decided_at
) VALUES (
    @tenant_id, @reconciliation_id, @sequence,
    @medication_system, @medication_code, @medication_display,
    @dose_text, @route, @source, @disposition, @rationale,
    sqlc.narg('resulting_prescription_id')::uuid, @decided_by,
    sqlc.narg('decided_at')::timestamptz
);

-- name: GetReconciliation :one
SELECT * FROM medication.reconciliation
WHERE tenant_id = @tenant_id AND reconciliation_id = @reconciliation_id;

-- name: ListReconciliationItems :many
SELECT * FROM medication.reconciliation_item
WHERE tenant_id = @tenant_id AND reconciliation_id = @reconciliation_id
ORDER BY sequence;

-- name: ListReconciliationsForEncounter :many
SELECT * FROM medication.reconciliation
WHERE tenant_id = @tenant_id AND encounter_id = @encounter_id
ORDER BY started_at DESC
LIMIT @row_limit;

-- name: UpdateReconciliationItem :execrows
UPDATE medication.reconciliation_item
SET disposition = @disposition,
    rationale = @rationale,
    resulting_prescription_id = sqlc.narg('resulting_prescription_id')::uuid,
    decided_by = @decided_by,
    decided_at = @decided_at
WHERE tenant_id = @tenant_id
  AND reconciliation_id = @reconciliation_id
  AND sequence = @sequence;

-- name: TouchReconciliation :execrows
UPDATE medication.reconciliation
SET updated_at = @updated_at, version = @version
WHERE tenant_id = @tenant_id
  AND reconciliation_id = @reconciliation_id
  AND version = @expected_version
  AND completed_at IS NULL;

-- name: CompleteReconciliation :execrows
-- Guarded on nothing being left pending, so the acceptance criterion holds even
-- against a caller that skipped the domain — two clinicians working the same
-- list cannot complete it between each other's decisions.
UPDATE medication.reconciliation r
SET completed_by = @completed_by,
    completed_at = @completed_at,
    updated_at = @updated_at,
    version = @version
WHERE r.tenant_id = @tenant_id
  AND r.reconciliation_id = @reconciliation_id
  AND r.version = @expected_version
  AND r.completed_at IS NULL
  AND NOT EXISTS (
      SELECT 1 FROM medication.reconciliation_item i
      WHERE i.tenant_id = r.tenant_id
        AND i.reconciliation_id = r.reconciliation_id
        AND i.disposition = 'pending');

-- name: InsertSubstitution :exec
INSERT INTO medication.substitution (
    substitution_id, tenant_id, prescription_id,
    prescribed_system, prescribed_code, prescribed_display,
    dispensed_system, dispensed_code, dispensed_display,
    kind, status, reason, proposed_by, proposed_at,
    authorized_by, authorized_at, dispensed_at
) VALUES (
    @substitution_id, @tenant_id, @prescription_id,
    @prescribed_system, @prescribed_code, @prescribed_display,
    @dispensed_system, @dispensed_code, @dispensed_display,
    @kind, @status, @reason, @proposed_by, @proposed_at,
    '', NULL, NULL
);

-- name: GetSubstitution :one
SELECT * FROM medication.substitution
WHERE tenant_id = @tenant_id AND substitution_id = @substitution_id;

-- name: UpdateSubstitution :execrows
UPDATE medication.substitution
SET status = @status,
    reason = @reason,
    authorized_by = @authorized_by,
    authorized_at = sqlc.narg('authorized_at')::timestamptz,
    dispensed_at = sqlc.narg('dispensed_at')::timestamptz
WHERE tenant_id = @tenant_id
  AND substitution_id = @substitution_id
  AND status = @expected_status;

-- name: ListSubstitutions :many
SELECT * FROM medication.substitution
WHERE tenant_id = @tenant_id AND prescription_id = @prescription_id
ORDER BY proposed_at DESC;

-- name: UpsertFormularyEntry :exec
INSERT INTO medication.formulary_entry (
    tenant_id, medication_system, medication_code, medication_display,
    scope, scope_id, status, restriction, approval_path, updated_by, updated_at
) VALUES (
    @tenant_id, @medication_system, @medication_code, @medication_display,
    @scope, @scope_id, @status, @restriction, @approval_path, @updated_by, @updated_at
)
ON CONFLICT (tenant_id, medication_system, medication_code, scope, scope_id)
DO UPDATE SET
    medication_display = EXCLUDED.medication_display,
    status = EXCLUDED.status,
    restriction = EXCLUDED.restriction,
    approval_path = EXCLUDED.approval_path,
    updated_by = EXCLUDED.updated_by,
    updated_at = EXCLUDED.updated_at;

-- name: ListFormularyEntries :many
SELECT * FROM medication.formulary_entry
WHERE tenant_id = @tenant_id
ORDER BY medication_system, medication_code, scope, scope_id;

-- name: UpsertInteractionRule :exec
-- A new version inserts a new row rather than editing the old one: a finding
-- recorded last March names a version, and a version edited in place is a
-- finding nobody can explain.
INSERT INTO medication.interaction_rule (
    tenant_id, rule_id, version,
    left_system, left_code, left_display,
    right_system, right_code, right_display,
    severity, advice, management, active, updated_by, updated_at
) VALUES (
    @tenant_id, @rule_id, @version,
    @left_system, @left_code, @left_display,
    @right_system, @right_code, @right_display,
    @severity, @advice, @management, @active, @updated_by, @updated_at
)
ON CONFLICT (tenant_id, rule_id, version)
DO UPDATE SET
    severity = EXCLUDED.severity,
    advice = EXCLUDED.advice,
    management = EXCLUDED.management,
    active = EXCLUDED.active,
    updated_by = EXCLUDED.updated_by,
    updated_at = EXCLUDED.updated_at;

-- name: ListActiveInteractionRules :many
SELECT * FROM medication.interaction_rule
WHERE tenant_id = @tenant_id AND active
ORDER BY rule_id, version;

-- name: UpsertDoseRule :exec
INSERT INTO medication.dose_rule (
    tenant_id, rule_id, version, scope,
    medication_system, medication_code, medication_display,
    max_creatinine_clearance, max_age_years, advice,
    validated, validated_by, validated_at, active, updated_by, updated_at
) VALUES (
    @tenant_id, @rule_id, @version, @scope,
    @medication_system, @medication_code, @medication_display,
    @max_creatinine_clearance, @max_age_years, @advice,
    @validated, @validated_by, sqlc.narg('validated_at')::timestamptz,
    @active, @updated_by, @updated_at
)
ON CONFLICT (tenant_id, rule_id, version)
DO UPDATE SET
    scope = EXCLUDED.scope,
    max_creatinine_clearance = EXCLUDED.max_creatinine_clearance,
    max_age_years = EXCLUDED.max_age_years,
    advice = EXCLUDED.advice,
    validated = EXCLUDED.validated,
    validated_by = EXCLUDED.validated_by,
    validated_at = EXCLUDED.validated_at,
    active = EXCLUDED.active,
    updated_by = EXCLUDED.updated_by,
    updated_at = EXCLUDED.updated_at;

-- name: ListRunnableDoseRules :many
-- Active and validated only (SRS-MED-004). The filter is in the query rather
-- than in the caller, so a caller that forgets gets no advice rather than
-- unchecked advice.
SELECT * FROM medication.dose_rule
WHERE tenant_id = @tenant_id AND active AND validated
ORDER BY rule_id, version;

-- name: SetMedicationPolicy :exec
INSERT INTO medication.policy (
    tenant_id, max_overridable, verification_required, verification_classes,
    structured_dose_classes, updated_by, updated_at
) VALUES (
    @tenant_id, @max_overridable, @verification_required,
    @verification_classes::text[], @structured_dose_classes::text[],
    @updated_by, @updated_at
)
ON CONFLICT (tenant_id)
DO UPDATE SET
    max_overridable = EXCLUDED.max_overridable,
    verification_required = EXCLUDED.verification_required,
    verification_classes = EXCLUDED.verification_classes,
    structured_dose_classes = EXCLUDED.structured_dose_classes,
    updated_by = EXCLUDED.updated_by,
    updated_at = EXCLUDED.updated_at;

-- name: GetMedicationPolicy :one
SELECT * FROM medication.policy WHERE tenant_id = @tenant_id;

-- name: UpsertTerminologyMapping :exec
INSERT INTO medication.terminology_map (
    tenant_id, medication_system, medication_code, medication_display,
    ingredients, classes, moiety_system, moiety_code, moiety_display,
    map_version, updated_by, updated_at
) VALUES (
    @tenant_id, @medication_system, @medication_code, @medication_display,
    @ingredients::text[], @classes::text[],
    @moiety_system, @moiety_code, @moiety_display,
    @map_version, @updated_by, @updated_at
)
ON CONFLICT (tenant_id, medication_system, medication_code)
DO UPDATE SET
    medication_display = EXCLUDED.medication_display,
    ingredients = EXCLUDED.ingredients,
    classes = EXCLUDED.classes,
    moiety_system = EXCLUDED.moiety_system,
    moiety_code = EXCLUDED.moiety_code,
    moiety_display = EXCLUDED.moiety_display,
    map_version = EXCLUDED.map_version,
    updated_by = EXCLUDED.updated_by,
    updated_at = EXCLUDED.updated_at;

-- name: GetTerminologyMapping :one
SELECT * FROM medication.terminology_map
WHERE tenant_id = @tenant_id
  AND medication_system = @medication_system
  AND medication_code = @medication_code;

-- name: LatestTerminologyMapVersion :one
-- The edition in force, so an allergy finding can name the version of the map
-- that produced it. The most recently updated row wins: the map is published as
-- a set, and a tenant midway through an import is a tenant whose findings should
-- name the version they were actually screened against.
SELECT map_version FROM medication.terminology_map
WHERE tenant_id = @tenant_id
ORDER BY updated_at DESC
LIMIT 1;
