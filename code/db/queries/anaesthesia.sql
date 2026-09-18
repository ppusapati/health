-- Anaesthesia and recovery (SRS-ANE-001 … 011).

-- name: InsertAnaesthesiaAssessment :exec
INSERT INTO anaesthesia.assessment (
    assessment_id, tenant_id, case_id, encounter_id, patient_id,
    version, supersedes,
    history, airway_mallampati, airway_mouth_mm, airway_thyromental_mm,
    airway_neck, airway_dentition, airway_notes, airway_predicted_difficult,
    asa_grade, investigations, risks, plan,
    consent, consent_note, fit_to_proceed, conditions,
    assessed_by, assessed_at
) VALUES (
    @assessment_id, @tenant_id, @case_id, @encounter_id, @patient_id,
    @version, @supersedes,
    @history, @airway_mallampati, @airway_mouth_mm, @airway_thyromental_mm,
    @airway_neck, @airway_dentition, @airway_notes, @airway_predicted_difficult,
    @asa_grade, @investigations, @risks, @plan,
    @consent, @consent_note, @fit_to_proceed, @conditions,
    @assessed_by, @assessed_at
);

-- Supersession is a separate statement because the one-current index forbids
-- two live assessments for a case: the old row has to point at the new one
-- before the new one may exist, and the forward reference is deferrable so the
-- pair can be written in either order inside a transaction.
-- name: SupersedeAnaesthesiaAssessment :exec
UPDATE anaesthesia.assessment
SET superseded_by = @superseded_by, superseded_at = @superseded_at
WHERE tenant_id = @tenant_id AND assessment_id = @assessment_id
  AND superseded_by IS NULL;

-- name: GetAnaesthesiaAssessment :one
SELECT * FROM anaesthesia.assessment
WHERE tenant_id = $1 AND assessment_id = $2;

-- name: ListAnaesthesiaAssessments :many
SELECT * FROM anaesthesia.assessment
WHERE tenant_id = @tenant_id AND case_id = @case_id
ORDER BY version;

-- name: ListPatientAnaesthesiaAssessments :many
SELECT * FROM anaesthesia.assessment
WHERE tenant_id = @tenant_id AND patient_id = @patient_id
ORDER BY assessed_at DESC
LIMIT @row_limit;

-- name: UpsertAnaesthesiaPlan :exec
INSERT INTO anaesthesia.plan (
    plan_id, tenant_id, case_id, technique, agents, airway, monitoring,
    special_equipment, post_operative, notes, planned_by, planned_at
) VALUES (
    @plan_id, @tenant_id, @case_id, @technique, @agents, @airway, @monitoring,
    @special_equipment, @post_operative, @notes, @planned_by, @planned_at
)
ON CONFLICT (tenant_id, case_id) DO UPDATE
SET technique = EXCLUDED.technique,
    agents = EXCLUDED.agents,
    airway = EXCLUDED.airway,
    monitoring = EXCLUDED.monitoring,
    special_equipment = EXCLUDED.special_equipment,
    post_operative = EXCLUDED.post_operative,
    notes = EXCLUDED.notes,
    planned_by = EXCLUDED.planned_by,
    planned_at = EXCLUDED.planned_at;

-- name: GetAnaesthesiaPlanForCase :one
SELECT * FROM anaesthesia.plan
WHERE tenant_id = $1 AND case_id = $2;

-- name: InsertAnaesthesiaRecord :exec
INSERT INTO anaesthesia.record (
    record_id, tenant_id, case_id, encounter_id, patient_id,
    technique, status, started_at, started_by, ended_at,
    origin, import_note, imported_at, imported_by
) VALUES (
    @record_id, @tenant_id, @case_id, @encounter_id, @patient_id,
    @technique, @status, @started_at, @started_by, @ended_at,
    @origin, @import_note, @imported_at, @imported_by
);

-- name: GetAnaesthesiaRecord :one
SELECT * FROM anaesthesia.record
WHERE tenant_id = $1 AND record_id = $2;

-- name: GetAnaesthesiaRecordForCase :one
SELECT * FROM anaesthesia.record
WHERE tenant_id = $1 AND case_id = $2;

-- name: ListPatientAnaesthesiaRecords :many
SELECT * FROM anaesthesia.record
WHERE tenant_id = @tenant_id AND patient_id = @patient_id
ORDER BY started_at DESC
LIMIT @row_limit;

-- name: UpdateAnaesthesiaRecordStatus :exec
UPDATE anaesthesia.record
SET status = @status, ended_at = @ended_at
WHERE tenant_id = @tenant_id AND record_id = @record_id;

-- name: InsertAnaesthesiaVital :exec
INSERT INTO anaesthesia.vital (
    vital_id, tenant_id, record_id, code, display, value, unit,
    source, device_id, device_model, device_connected, device_measured_at,
    observed_at, recorded_at, recorded_by
) VALUES (
    @vital_id, @tenant_id, @record_id, @code, @display, @value, @unit,
    @source, @device_id, @device_model, @device_connected, @device_measured_at,
    @observed_at, @recorded_at, @recorded_by
);

-- name: ListAnaesthesiaVitals :many
SELECT * FROM anaesthesia.vital
WHERE tenant_id = @tenant_id AND record_id = @record_id
  AND (@code::text = '' OR code = @code)
ORDER BY observed_at;

-- name: InsertAnaesthesiaDrug :exec
INSERT INTO anaesthesia.drug (
    drug_id, tenant_id, record_id, drug_code, drug_display, route,
    dose, dose_unit,
    concentration_amount, concentration_unit, concentration_volume,
    rate_ml_per_hour, infusion, stopped_at,
    source, device_id, device_connected, device_measured_at,
    given_at, recorded_at, recorded_by, note
) VALUES (
    @drug_id, @tenant_id, @record_id, @drug_code, @drug_display, @route,
    @dose, @dose_unit,
    @concentration_amount, @concentration_unit, @concentration_volume,
    @rate_ml_per_hour, @infusion, @stopped_at,
    @source, @device_id, @device_connected, @device_measured_at,
    @given_at, @recorded_at, @recorded_by, @note
);

-- name: ListAnaesthesiaDrugs :many
SELECT * FROM anaesthesia.drug
WHERE tenant_id = @tenant_id AND record_id = @record_id
ORDER BY given_at;

-- name: StopAnaesthesiaInfusion :execrows
UPDATE anaesthesia.drug
SET stopped_at = @stopped_at
WHERE tenant_id = @tenant_id AND drug_id = @drug_id AND stopped_at IS NULL;

-- name: InsertAnaesthesiaAirwayEvent :exec
INSERT INTO anaesthesia.airway_event (
    airway_id, tenant_id, record_id, device, attempt, grade, successful,
    difficulty, complications, adjuncts, occurred_at, recorded_by
) VALUES (
    @airway_id, @tenant_id, @record_id, @device, @attempt, @grade, @successful,
    @difficulty, @complications, @adjuncts, @occurred_at, @recorded_by
);

-- name: ListAnaesthesiaAirwayEvents :many
SELECT * FROM anaesthesia.airway_event
WHERE tenant_id = @tenant_id AND record_id = @record_id
ORDER BY attempt;

-- The difficult-airway history, which is the one thing the next anaesthetist
-- most needs and the one most often lost between admissions.
-- name: ListPatientAirwayEvents :many
SELECT a.* FROM anaesthesia.airway_event a
JOIN anaesthesia.record r
  ON r.record_id = a.record_id AND r.tenant_id = a.tenant_id
WHERE a.tenant_id = @tenant_id AND r.patient_id = @patient_id
ORDER BY a.occurred_at DESC
LIMIT @row_limit;

-- name: InsertAnaesthesiaFluid :exec
INSERT INTO anaesthesia.fluid (
    fluid_id, tenant_id, record_id, direction, kind, label, volume_ml,
    product_id, occurred_at, recorded_at, recorded_by
) VALUES (
    @fluid_id, @tenant_id, @record_id, @direction, @kind, @label, @volume_ml,
    @product_id, @occurred_at, @recorded_at, @recorded_by
);

-- name: ListAnaesthesiaFluids :many
SELECT * FROM anaesthesia.fluid
WHERE tenant_id = @tenant_id AND record_id = @record_id
ORDER BY occurred_at;

-- name: InsertAnaesthesiaHandover :exec
INSERT INTO anaesthesia.handover (
    handover_id, tenant_id, record_id, from_clinician, to_clinician,
    summary, concerns, instructions, analgesia_given, antiemetic_given,
    handed_over_at
) VALUES (
    @handover_id, @tenant_id, @record_id, @from_clinician, @to_clinician,
    @summary, @concerns, @instructions, @analgesia_given, @antiemetic_given,
    @handed_over_at
);

-- name: ListAnaesthesiaHandovers :many
SELECT * FROM anaesthesia.handover
WHERE tenant_id = @tenant_id AND record_id = @record_id
ORDER BY handed_over_at;

-- name: InsertRecoveryAssessment :exec
INSERT INTO anaesthesia.recovery_assessment (
    assessment_id, tenant_id, record_id, scale_name, scale_version,
    scores, total, discharge_threshold, missing, assessed_at, assessed_by
) VALUES (
    @assessment_id, @tenant_id, @record_id, @scale_name, @scale_version,
    @scores, @total, @discharge_threshold, @missing, @assessed_at, @assessed_by
);

-- name: ListRecoveryAssessments :many
SELECT * FROM anaesthesia.recovery_assessment
WHERE tenant_id = @tenant_id AND record_id = @record_id
ORDER BY assessed_at;

-- name: InsertAnaesthesiaDischarge :exec
INSERT INTO anaesthesia.discharge (
    discharge_id, tenant_id, record_id, destination, overridden,
    override_reason, score_id, discharged_at, discharged_by
) VALUES (
    @discharge_id, @tenant_id, @record_id, @destination, @overridden,
    @override_reason, @score_id, @discharged_at, @discharged_by
);

-- name: GetAnaesthesiaDischarge :one
SELECT * FROM anaesthesia.discharge
WHERE tenant_id = $1 AND record_id = $2;

-- name: InsertPainOrder :exec
INSERT INTO anaesthesia.pain_order (
    order_id, tenant_id, record_id, patient_id, encounter_id, modality,
    prescription_ids, target_score, monitoring, escalation, review_by,
    ordered_by, ordered_at
) VALUES (
    @order_id, @tenant_id, @record_id, @patient_id, @encounter_id, @modality,
    @prescription_ids, @target_score, @monitoring, @escalation, @review_by,
    @ordered_by, @ordered_at
);

-- name: GetPainOrder :one
SELECT * FROM anaesthesia.pain_order
WHERE tenant_id = $1 AND order_id = $2;

-- name: ListPainOrdersForRecord :many
SELECT * FROM anaesthesia.pain_order
WHERE tenant_id = @tenant_id AND record_id = @record_id
ORDER BY ordered_at;

-- The acute pain team's worklist: plans still running, soonest review first. A
-- plan with no review time sorts last rather than being hidden, because an
-- unreviewed plan is the one the round exists to find.
-- name: ListRunningPainOrders :many
SELECT * FROM anaesthesia.pain_order
WHERE tenant_id = @tenant_id AND stopped_at IS NULL
ORDER BY review_by NULLS LAST
LIMIT @row_limit;

-- name: StopPainOrder :execrows
UPDATE anaesthesia.pain_order
SET stopped_at = @stopped_at, stopped_by = @stopped_by
WHERE tenant_id = @tenant_id AND order_id = @order_id AND stopped_at IS NULL;
