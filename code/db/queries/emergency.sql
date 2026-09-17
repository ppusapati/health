-- The Emergency Department (SRS-ER).

-- name: InsertEmergencyVisit :exec
INSERT INTO emergency.visit (
    visit_id, tenant_id, encounter_id, patient_id, facility_id,
    arrival_mode, chief_complaint, arrived_at,
    unidentified, temporary_name, medico_legal, medico_legal_ref,
    status, location, created_by, created_at, updated_at, version
) VALUES (
    @visit_id, @tenant_id, @encounter_id, sqlc.narg('patient_id')::uuid,
    @facility_id, @arrival_mode, @chief_complaint, @arrived_at,
    @unidentified, @temporary_name, @medico_legal, @medico_legal_ref,
    @status, @location, @created_by, @created_at, @updated_at, 1
);

-- name: GetEmergencyVisit :one
SELECT * FROM emergency.visit
WHERE tenant_id = $1 AND visit_id = $2;

-- name: UpdateEmergencyVisit :execrows
-- Guarded on the version, so two clinicians disposing at once do not both win.
UPDATE emergency.visit
SET patient_id = sqlc.narg('patient_id')::uuid,
    unidentified = @unidentified,
    status = @status,
    location = @location,
    disposition = @disposition,
    disposed_at = sqlc.narg('disposed_at')::timestamptz,
    disposition_note = @disposition_note,
    receiving_service = @receiving_service,
    observation_started_at = sqlc.narg('observation_started_at')::timestamptz,
    observation_ends_at = sqlc.narg('observation_ends_at')::timestamptz,
    medico_legal = @medico_legal,
    medico_legal_ref = @medico_legal_ref,
    updated_at = @updated_at,
    version = version + 1
WHERE tenant_id = @tenant_id
  AND visit_id = @visit_id
  AND version = @expected_version;

-- name: ListOpenEmergencyVisits :many
-- The department as it stands. Ordering is the board's job, not the query's:
-- acuity ordering needs the triage and the override, which the application
-- assembles.
SELECT * FROM emergency.visit
WHERE tenant_id = $1
  AND status <> 'disposed'
  AND (@facility_filter::text = '' OR facility_id = @facility_filter::text)
ORDER BY arrived_at
LIMIT @page_limit;

-- name: InsertTriage :exec
INSERT INTO emergency.triage (
    triage_id, tenant_id, visit_id, scale_name, scale_version,
    acuity_code, acuity_rank, respiratory_rate, heart_rate, systolic_bp,
    oxygen_saturation, temperature, pain_score, consciousness, red_flags,
    missing_fields, note, assessed_by, assessed_at
) VALUES (
    @triage_id, @tenant_id, @visit_id, @scale_name, @scale_version,
    @acuity_code, @acuity_rank,
    sqlc.narg('respiratory_rate')::integer, sqlc.narg('heart_rate')::integer,
    sqlc.narg('systolic_bp')::integer, sqlc.narg('oxygen_saturation')::integer,
    sqlc.narg('temperature')::double precision, sqlc.narg('pain_score')::integer,
    @consciousness, @red_flags, @missing_fields, @note, @assessed_by, @assessed_at
);

-- name: LatestTriage :one
-- The current acuity. A patient may be re-triaged, and the latest assessment
-- is the one the queue sorts on — a deteriorating patient in the waiting room
-- is exactly who re-triage exists for.
SELECT * FROM emergency.triage
WHERE tenant_id = $1 AND visit_id = $2
ORDER BY assessed_at DESC
LIMIT 1;

-- name: ListTriage :many
SELECT * FROM emergency.triage
WHERE tenant_id = $1 AND visit_id = $2
ORDER BY assessed_at DESC;

-- name: InsertPriorityOverride :exec
INSERT INTO emergency.priority_override (
    override_id, tenant_id, visit_id, acuity_rank, reason,
    overridden_by, overridden_at
) VALUES ($1, $2, $3, $4, $5, $6, $7);

-- name: LatestPriorityOverride :one
SELECT * FROM emergency.priority_override
WHERE tenant_id = $1 AND visit_id = $2
ORDER BY overridden_at DESC
LIMIT 1;

-- name: InsertPathway :exec
INSERT INTO emergency.pathway (
    pathway_id, tenant_id, visit_id, kind, label, activated_at, activated_by,
    notified_team, escalation_notice_id
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, sqlc.narg('escalation_notice_id')::uuid
);

-- name: InsertPathwayTarget :exec
INSERT INTO emergency.pathway_target (pathway_id, code, label, within_seconds)
VALUES ($1, $2, $3, $4);

-- name: ListPathways :many
SELECT * FROM emergency.pathway
WHERE tenant_id = $1 AND visit_id = $2
ORDER BY activated_at;

-- name: ListPathwayTargets :many
SELECT * FROM emergency.pathway_target
WHERE pathway_id = $1
ORDER BY within_seconds, code;

-- name: ListActivePathways :many
-- What the board flashes. Facility-wide, because a resus activation is a
-- department-wide fact rather than one patient's.
SELECT p.* FROM emergency.pathway p
JOIN emergency.visit v ON v.visit_id = p.visit_id
WHERE p.tenant_id = $1
  AND p.stood_down_at IS NULL
  AND v.status <> 'disposed'
  AND (@facility_filter::text = '' OR v.facility_id = @facility_filter::text);

-- name: StandDownPathway :execrows
UPDATE emergency.pathway
SET stood_down_at = @stood_down_at, stood_down_reason = @stood_down_reason
WHERE tenant_id = @tenant_id
  AND pathway_id = @pathway_id
  AND stood_down_at IS NULL;

-- name: InsertEmergencyEvent :exec
INSERT INTO emergency.event (
    event_id, tenant_id, visit_id, kind, detail, occurred_at, recorded_at,
    sequence, actor_id, late, pathway_id, protocol_id, needs_reconciliation
) VALUES (
    @event_id, @tenant_id, @visit_id, @kind, @detail, @occurred_at, @recorded_at,
    @sequence, @actor_id, @late, sqlc.narg('pathway_id')::uuid,
    @protocol_id, @needs_reconciliation
);

-- name: ListEmergencyEvents :many
-- In the order things happened, which is not the order they were typed.
SELECT * FROM emergency.event
WHERE tenant_id = $1 AND visit_id = $2
ORDER BY occurred_at, sequence, event_id;

-- name: ReconcileEmergencyEvent :execrows
-- Predicated on the debt still being open, so two clinicians reconciling the
-- same administration do not both write an order against it.
UPDATE emergency.event
SET reconciled_order_id = @reconciled_order_id
WHERE tenant_id = @tenant_id
  AND event_id = @event_id
  AND needs_reconciliation
  AND reconciled_order_id = '';

-- name: ListUnreconciledAdministrations :many
-- The department's debt (SRS-ER-009). Facility-wide: a drug given under
-- protocol and never written up is the department's problem, not the
-- patient's, and nobody finds it by opening one chart at a time.
SELECT e.* FROM emergency.event e
JOIN emergency.visit v ON v.visit_id = e.visit_id
WHERE e.tenant_id = $1
  AND e.needs_reconciliation
  AND e.reconciled_order_id = ''
  AND (@facility_filter::text = '' OR v.facility_id = @facility_filter::text)
ORDER BY e.occurred_at
LIMIT @page_limit;
