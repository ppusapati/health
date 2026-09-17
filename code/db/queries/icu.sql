-- Critical care (SRS-ICU).

-- name: InsertIcuEpisode :exec
INSERT INTO icu.episode (
    episode_id, tenant_id, encounter_id, patient_id, facility_id,
    unit_id, bed_id, source, transferred_from,
    responsible_team, responsible_clinician, status, admitted_at,
    created_by, created_at, updated_at, version
) VALUES (
    @episode_id, @tenant_id, @encounter_id, @patient_id, @facility_id,
    @unit_id, @bed_id, @source, sqlc.narg('transferred_from')::uuid,
    @responsible_team, @responsible_clinician, @status, @admitted_at,
    @created_by, @created_at, @updated_at, 1
);

-- name: GetIcuEpisode :one
SELECT * FROM icu.episode
WHERE tenant_id = $1 AND episode_id = $2;

-- name: UpdateIcuEpisode :execrows
-- Guarded on the version, so two clinicians discharging at once do not both win.
UPDATE icu.episode
SET bed_id = @bed_id,
    responsible_team = @responsible_team,
    responsible_clinician = @responsible_clinician,
    status = @status,
    ready_at = sqlc.narg('ready_at')::timestamptz,
    discharged_at = sqlc.narg('discharged_at')::timestamptz,
    outcome = @outcome,
    outcome_note = @outcome_note,
    updated_at = @updated_at,
    version = version + 1
WHERE tenant_id = @tenant_id
  AND episode_id = @episode_id
  AND version = @expected_version;

-- name: ListOpenIcuEpisodes :many
-- The unit as it stands, which is what the dashboard is.
SELECT * FROM icu.episode
WHERE tenant_id = @tenant_id
  AND (@unit_id::text = '' OR unit_id = @unit_id)
  AND status <> 'closed'
ORDER BY bed_id
LIMIT @row_limit;

-- name: ListIcuEpisodesForEncounter :many
SELECT * FROM icu.episode
WHERE tenant_id = $1 AND encounter_id = $2
ORDER BY admitted_at;

-- name: ListIcuEpisodesInPeriod :many
-- Closed and open episodes overlapping a window, for occupancy and length of
-- stay (SRS-ICU-017).
SELECT * FROM icu.episode
WHERE tenant_id = @tenant_id
  AND (@unit_id::text = '' OR unit_id = @unit_id)
  AND admitted_at < @period_end
  AND (discharged_at IS NULL OR discharged_at >= @period_start)
ORDER BY admitted_at;

-- name: InsertIcuObservation :exec
INSERT INTO icu.observation (
    observation_id, tenant_id, episode_id,
    code_system, code, display, dimension,
    value, unit, raw_value, raw_unit, normalised,
    source, validation,
    device_id, device_model, device_channel, device_measured_at, device_quality,
    observed_at, recorded_at, recorded_by
) VALUES (
    @observation_id, @tenant_id, @episode_id,
    @code_system, @code, @display, @dimension,
    @value, @unit, @raw_value, @raw_unit, @normalised,
    @source, @validation,
    @device_id, @device_model, @device_channel,
    sqlc.narg('device_measured_at')::timestamptz, @device_quality,
    @observed_at, @recorded_at, @recorded_by
);

-- name: GetIcuObservation :one
SELECT * FROM icu.observation
WHERE tenant_id = $1 AND observation_id = $2;

-- name: DecideIcuObservation :execrows
-- Confirming or rejecting a device reading. The reading itself is never
-- changed: a rejected artefact that vanished would leave a gap in the trend
-- and no sign that anybody looked.
UPDATE icu.observation
SET validation = @validation,
    validated_by = @validated_by,
    validated_at = @validated_at,
    validation_note = @validation_note
WHERE tenant_id = @tenant_id
  AND observation_id = @observation_id
  AND validation = 'pending';

-- name: ListIcuObservations :many
SELECT * FROM icu.observation
WHERE tenant_id = @tenant_id
  AND episode_id = @episode_id
  AND (@since::timestamptz IS NULL OR observed_at >= @since)
ORDER BY observed_at DESC
LIMIT @row_limit;

-- name: ListPendingIcuObservations :many
-- The nurse's validation worklist.
SELECT * FROM icu.observation
WHERE tenant_id = @tenant_id
  AND episode_id = @episode_id
  AND validation = 'pending'
ORDER BY observed_at
LIMIT @row_limit;

-- name: InsertIcuBalanceEntry :exec
INSERT INTO icu.balance_entry (
    entry_id, tenant_id, episode_id, direction, route, volume_ml,
    occurred_at, recorded_at, recorded_by, corrects, correction_reason
) VALUES (
    @entry_id, @tenant_id, @episode_id, @direction, @route, @volume_ml,
    @occurred_at, @recorded_at, @recorded_by,
    sqlc.narg('corrects')::uuid, @correction_reason
);

-- name: SupersedeIcuBalanceEntry :execrows
-- A correction supersedes rather than overwrites. Refuses an entry already
-- superseded, so two corrections of the same entry do not both count.
UPDATE icu.balance_entry
SET superseded_by = @superseded_by
WHERE tenant_id = @tenant_id
  AND entry_id = @entry_id
  AND superseded_by IS NULL;

-- name: ListIcuBalanceEntries :many
SELECT * FROM icu.balance_entry
WHERE tenant_id = @tenant_id
  AND episode_id = @episode_id
  AND occurred_at >= @period_start
  AND occurred_at < @period_end
ORDER BY occurred_at;

-- name: InsertIcuSupport :exec
INSERT INTO icu.support (
    support_id, tenant_id, episode_id, kind, label, modality,
    started_at, started_by
) VALUES (
    @support_id, @tenant_id, @episode_id, @kind, @label, @modality,
    @started_at, @started_by
);

-- name: StopIcuSupport :execrows
UPDATE icu.support
SET stopped_at = @stopped_at, stopped_by = @stopped_by, stop_note = @stop_note
WHERE tenant_id = @tenant_id
  AND support_id = @support_id
  AND stopped_at IS NULL;

-- name: ListIcuSupport :many
SELECT * FROM icu.support
WHERE tenant_id = $1 AND episode_id = $2
ORDER BY started_at;

-- name: InsertIcuVentSetting :exec
INSERT INTO icu.vent_setting (
    setting_id, tenant_id, episode_id, support_id, mode,
    parameters, measured, units, device_id,
    effective_at, recorded_at, recorded_by, change_reason
) VALUES (
    @setting_id, @tenant_id, @episode_id, sqlc.narg('support_id')::uuid, @mode,
    @parameters, @measured, @units, @device_id,
    @effective_at, @recorded_at, @recorded_by, @change_reason
);

-- name: ListIcuVentSettings :many
SELECT * FROM icu.vent_setting
WHERE tenant_id = $1 AND episode_id = $2
ORDER BY effective_at;

-- name: InsertIcuInfusion :exec
INSERT INTO icu.infusion (
    infusion_id, tenant_id, episode_id, prescription_id,
    drug_code, drug_display,
    concentration_amount, concentration_unit, concentration_volume,
    dose_unit, weight_kg, started_at, started_by
) VALUES (
    @infusion_id, @tenant_id, @episode_id, sqlc.narg('prescription_id')::uuid,
    @drug_code, @drug_display,
    @concentration_amount, @concentration_unit, @concentration_volume,
    @dose_unit, @weight_kg, @started_at, @started_by
);

-- name: GetIcuInfusion :one
SELECT * FROM icu.infusion
WHERE tenant_id = $1 AND infusion_id = $2;

-- name: StopIcuInfusion :execrows
UPDATE icu.infusion
SET stopped_at = @stopped_at, stopped_by = @stopped_by
WHERE tenant_id = @tenant_id
  AND infusion_id = @infusion_id
  AND stopped_at IS NULL;

-- name: ListIcuInfusions :many
SELECT * FROM icu.infusion
WHERE tenant_id = $1 AND episode_id = $2
ORDER BY started_at;

-- name: InsertIcuTitration :exec
INSERT INTO icu.titration (
    titration_id, tenant_id, infusion_id, rate, rate_unit, dose,
    effective_at, recorded_at, recorded_by, device_id, reason
) VALUES (
    @titration_id, @tenant_id, @infusion_id, @rate, @rate_unit, @dose,
    @effective_at, @recorded_at, @recorded_by, @device_id, @reason
);

-- name: ListIcuTitrations :many
SELECT * FROM icu.titration
WHERE tenant_id = $1 AND infusion_id = $2
ORDER BY effective_at;

-- name: InsertIcuDevice :exec
INSERT INTO icu.invasive_device (
    device_id, tenant_id, episode_id, kind, site, lumens,
    inserted_at, inserted_by, review_every_seconds
) VALUES (
    @device_id, @tenant_id, @episode_id, @kind, @site, @lumens,
    @inserted_at, @inserted_by, @review_every_seconds
);

-- name: RemoveIcuDevice :execrows
UPDATE icu.invasive_device
SET removed_at = @removed_at, removed_by = @removed_by,
    removal_reason = @removal_reason
WHERE tenant_id = @tenant_id
  AND device_id = @device_id
  AND removed_at IS NULL;

-- name: ReviewIcuDevice :execrows
UPDATE icu.invasive_device
SET last_reviewed_at = @last_reviewed_at, last_reviewed_by = @last_reviewed_by
WHERE tenant_id = @tenant_id
  AND device_id = @device_id
  AND removed_at IS NULL;

-- name: ListIcuDevices :many
SELECT * FROM icu.invasive_device
WHERE tenant_id = $1 AND episode_id = $2
ORDER BY inserted_at;

-- name: ListIcuDevicesInPeriod :many
-- Device days (SRS-ICU-017), across a unit rather than one patient.
SELECT d.* FROM icu.invasive_device d
JOIN icu.episode e ON e.episode_id = d.episode_id AND e.tenant_id = d.tenant_id
WHERE d.tenant_id = @tenant_id
  AND (@unit_id::text = '' OR e.unit_id = @unit_id)
  AND d.inserted_at < @period_end
  AND (d.removed_at IS NULL OR d.removed_at >= @period_start)
ORDER BY d.inserted_at;

-- name: InsertIcuScore :exec
INSERT INTO icu.score (
    score_id, tenant_id, episode_id, name, formula_version,
    total, missing, calculated_at, calculated_by
) VALUES (
    @score_id, @tenant_id, @episode_id, @name, @formula_version,
    @total, @missing, @calculated_at, @calculated_by
);

-- name: InsertIcuScoreInput :exec
INSERT INTO icu.score_input (
    score_id, code, observation_id, value, unit, observed_at, points
) VALUES (
    @score_id, @code, @observation_id, @value, @unit, @observed_at, @points
);

-- name: ListIcuScores :many
SELECT * FROM icu.score
WHERE tenant_id = $1 AND episode_id = $2
ORDER BY calculated_at DESC
LIMIT $3;

-- name: ListIcuScoreInputs :many
SELECT * FROM icu.score_input
WHERE score_id = $1
ORDER BY code;

-- name: InsertIcuBundlePerformance :exec
INSERT INTO icu.bundle_performance (
    performance_id, tenant_id, episode_id, kind, label, version,
    performed_at, performed_by
) VALUES (
    @performance_id, @tenant_id, @episode_id, @kind, @label, @version,
    @performed_at, @performed_by
);

-- name: InsertIcuBundleResult :exec
INSERT INTO icu.bundle_result (performance_id, code, state, reason)
VALUES (@performance_id, @code, @state, @reason);

-- name: ListIcuBundlePerformances :many
SELECT * FROM icu.bundle_performance
WHERE tenant_id = $1 AND episode_id = $2
ORDER BY performed_at DESC
LIMIT $3;

-- name: ListIcuBundleResults :many
SELECT * FROM icu.bundle_result
WHERE performance_id = $1
ORDER BY code;

-- name: InsertIcuAssessment :exec
INSERT INTO icu.assessment (
    assessment_id, tenant_id, episode_id, kind, scale, score,
    findings, note, performed_at, performed_by, next_due_at
) VALUES (
    @assessment_id, @tenant_id, @episode_id, @kind, @scale,
    sqlc.narg('score')::integer, @findings, @note,
    @performed_at, @performed_by, @next_due_at
);

-- name: ListIcuAssessments :many
SELECT * FROM icu.assessment
WHERE tenant_id = $1 AND episode_id = $2
ORDER BY performed_at DESC
LIMIT $3;

-- name: InsertIcuRound :exec
INSERT INTO icu.round (
    round_id, tenant_id, episode_id, attendance, summary,
    performed_at, performed_by
) VALUES (
    @round_id, @tenant_id, @episode_id, @attendance, @summary,
    @performed_at, @performed_by
);

-- name: ListIcuRounds :many
SELECT * FROM icu.round
WHERE tenant_id = $1 AND episode_id = $2
ORDER BY performed_at DESC
LIMIT $3;

-- name: InsertIcuGoal :exec
INSERT INTO icu.goal (
    goal_id, tenant_id, episode_id, round_id, domain, text,
    owner_role, owner_id, status, target_at, created_by, created_at
) VALUES (
    @goal_id, @tenant_id, @episode_id, sqlc.narg('round_id')::uuid,
    @domain, @text, @owner_role, @owner_id, @status,
    sqlc.narg('target_at')::timestamptz, @created_by, @created_at
);

-- name: ResolveIcuGoal :execrows
UPDATE icu.goal
SET status = @status, outcome = @outcome,
    resolved_by = @resolved_by, resolved_at = @resolved_at
WHERE tenant_id = @tenant_id
  AND goal_id = @goal_id
  AND status = 'open';

-- name: ListIcuGoals :many
SELECT * FROM icu.goal
WHERE tenant_id = $1 AND episode_id = $2
ORDER BY created_at;

-- name: InsertIcuGoalsOfCare :exec
INSERT INTO icu.goals_of_care (
    goals_of_care_id, tenant_id, episode_id, intent, limitations, cpr_status,
    discussed_with, rationale, authorised_by, authorised_role,
    recorded_at, recorded_by, review_by
) VALUES (
    @goals_of_care_id, @tenant_id, @episode_id, @intent, @limitations, @cpr_status,
    @discussed_with, @rationale, @authorised_by, @authorised_role,
    @recorded_at, @recorded_by, sqlc.narg('review_by')::timestamptz
);

-- name: SupersedeIcuGoalsOfCare :execrows
-- Refuses one already superseded, so two replacements of the same ceiling do
-- not both claim to have replaced it.
UPDATE icu.goals_of_care
SET superseded_by = @superseded_by, superseded_at = @superseded_at
WHERE tenant_id = @tenant_id
  AND episode_id = @episode_id
  AND superseded_by IS NULL;

-- name: ListIcuGoalsOfCare :many
SELECT * FROM icu.goals_of_care
WHERE tenant_id = $1 AND episode_id = $2
ORDER BY recorded_at;
