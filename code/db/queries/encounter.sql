-- Encounters, episodes, care teams and diagnoses (SRS-ENC).

-- name: InsertEpisode :exec
INSERT INTO encounter.episode (
    episode_id, tenant_id, patient_id, facility_id, episode_type, label,
    care_manager_id, status, started_at, ended_at, created_by,
    created_at, updated_at, version
) VALUES (
    @episode_id, @tenant_id, @patient_id, @facility_id, @episode_type, @label,
    @care_manager_id, @status, @started_at, sqlc.narg('ended_at')::timestamptz,
    @created_by, @created_at, @updated_at, 1
);

-- name: GetEpisode :one
SELECT episode_id, tenant_id, patient_id, facility_id, episode_type, label,
       care_manager_id, status, started_at, ended_at, created_by,
       created_at, updated_at, version
FROM encounter.episode
WHERE tenant_id = @tenant_id AND episode_id = @episode_id;

-- name: ListEpisodesForPatient :many
SELECT episode_id, tenant_id, patient_id, facility_id, episode_type, label,
       care_manager_id, status, started_at, ended_at, created_by,
       created_at, updated_at, version
FROM encounter.episode
WHERE tenant_id = @tenant_id
  AND patient_id = @patient_id
  AND (@open_only::boolean = false OR status IN ('active', 'on_hold'))
ORDER BY started_at DESC, episode_id
LIMIT @page_limit;

-- name: SetEpisodeStatus :execrows
-- Guarded on the version read, so two clinicians closing a course of care at
-- once do not both believe they did it.
UPDATE encounter.episode
SET status = @status,
    ended_at = sqlc.narg('ended_at')::timestamptz,
    updated_at = @updated_at,
    version = version + 1
WHERE tenant_id = @tenant_id
  AND episode_id = @episode_id
  AND version = @expected_version;

-- name: InsertEncounter :exec
INSERT INTO encounter.encounter (
    encounter_id, tenant_id, facility_id, org_unit_id, patient_id, class,
    visit_type, attending_provider_id, appointment_id, episode_id, referral_id,
    reason, status, started_at, ended_at, closed_at,
    created_by, created_at, updated_at, version
) VALUES (
    @encounter_id, @tenant_id, @facility_id, sqlc.narg('org_unit_id')::uuid,
    @patient_id, @class, @visit_type, @attending_provider_id,
    sqlc.narg('appointment_id')::uuid, sqlc.narg('episode_id')::uuid,
    @referral_id, @reason, @status,
    sqlc.narg('started_at')::timestamptz, sqlc.narg('ended_at')::timestamptz,
    sqlc.narg('closed_at')::timestamptz,
    @created_by, @created_at, @updated_at, 1
);

-- name: GetEncounter :one
SELECT encounter_id, tenant_id, facility_id, org_unit_id, patient_id, class,
       visit_type, attending_provider_id, appointment_id, episode_id, referral_id,
       reason, status, started_at, ended_at, closed_at,
       created_by, created_at, updated_at, version
FROM encounter.encounter
WHERE tenant_id = @tenant_id AND encounter_id = @encounter_id;

-- name: SetEncounterState :execrows
-- Writes a status change under optimistic concurrency (SRS-ENC-006).
--
-- The times move with the status because they always change together: an
-- encounter becomes in_progress exactly when it starts. Two statements would be
-- two chances to commit half of it.
UPDATE encounter.encounter
SET status = @status,
    started_at = sqlc.narg('started_at')::timestamptz,
    ended_at = sqlc.narg('ended_at')::timestamptz,
    closed_at = sqlc.narg('closed_at')::timestamptz,
    attending_provider_id = @attending_provider_id,
    updated_at = @updated_at,
    version = version + 1
WHERE tenant_id = @tenant_id
  AND encounter_id = @encounter_id
  AND version = @expected_version;

-- name: ListEncountersForPatient :many
-- The patient's chronology, newest first, which is how a chart is read.
SELECT encounter_id, tenant_id, facility_id, org_unit_id, patient_id, class,
       visit_type, attending_provider_id, appointment_id, episode_id, referral_id,
       reason, status, started_at, ended_at, closed_at,
       created_by, created_at, updated_at, version
FROM encounter.encounter
WHERE tenant_id = @tenant_id
  AND patient_id = @patient_id
  AND (sqlc.narg('episode_id')::uuid IS NULL OR episode_id = sqlc.narg('episode_id')::uuid)
  AND (@class_filter::text = '' OR class = @class_filter::text)
  AND (@include_retracted::boolean = true OR status <> 'entered_in_error')
ORDER BY COALESCE(started_at, created_at) DESC, encounter_id
LIMIT @page_limit;

-- name: ListOpenEncounters :many
-- The ward round: who is here now.
SELECT encounter_id, tenant_id, facility_id, org_unit_id, patient_id, class,
       visit_type, attending_provider_id, appointment_id, episode_id, referral_id,
       reason, status, started_at, ended_at, closed_at,
       created_by, created_at, updated_at, version
FROM encounter.encounter
WHERE tenant_id = @tenant_id
  AND facility_id = @facility_id
  AND status IN ('planned', 'in_progress', 'on_leave')
  AND (@class_filter::text = '' OR class = @class_filter::text)
ORDER BY COALESCE(started_at, created_at), encounter_id
LIMIT @page_limit;

-- name: InsertEncounterStatusHistory :exec
INSERT INTO encounter.encounter_status_history (
    history_id, tenant_id, encounter_id, from_status, to_status,
    changed_at, changed_by, reason
) VALUES (
    @history_id, @tenant_id, @encounter_id, @from_status, @to_status,
    @changed_at, @changed_by, @reason
);

-- name: ListEncounterStatusHistory :many
SELECT from_status, to_status, changed_at, changed_by, reason
FROM encounter.encounter_status_history
WHERE tenant_id = @tenant_id AND encounter_id = @encounter_id
ORDER BY changed_at, history_id;

-- name: InsertCareTeamMember :exec
INSERT INTO encounter.care_team_member (
    care_team_id, tenant_id, encounter_id, subject_id, role,
    effective_from, effective_until, assigned_by, assigned_at
) VALUES (
    @care_team_id, @tenant_id, @encounter_id, @subject_id, @role,
    @effective_from, sqlc.narg('effective_until')::timestamptz,
    @assigned_by, @assigned_at
);

-- name: ListCareTeam :many
SELECT care_team_id, tenant_id, encounter_id, subject_id, role,
       effective_from, effective_until, assigned_by, assigned_at
FROM encounter.care_team_member
WHERE tenant_id = @tenant_id AND encounter_id = @encounter_id
ORDER BY effective_from, care_team_id;

-- name: EndCareTeamMember :execrows
-- Closes an involvement rather than deleting it: whether this clinician was
-- looking after the patient last Tuesday is a question an investigation asks.
UPDATE encounter.care_team_member
SET effective_until = @effective_until
WHERE tenant_id = @tenant_id
  AND care_team_id = @care_team_id
  AND effective_until IS NULL
  AND @effective_until::timestamptz > effective_from;

-- name: IsOnCareTeamAt :one
-- The authorization question, answered as of a time (SRS-ENC-005).
SELECT EXISTS (
    SELECT 1
    FROM encounter.care_team_member
    WHERE tenant_id = @tenant_id
      AND encounter_id = @encounter_id
      AND subject_id = @subject_id
      AND effective_from <= @at::timestamptz
      AND (effective_until IS NULL OR effective_until > @at::timestamptz)
) AS on_team;

-- name: InsertDiagnosis :exec
INSERT INTO encounter.encounter_diagnosis (
    diagnosis_id, tenant_id, encounter_id, patient_id, code_system,
    code_version, code, code_display, certainty, rank, note, onset_at,
    superseded_by_id, retracted_reason, recorded_by, recorded_at
) VALUES (
    @diagnosis_id, @tenant_id, @encounter_id, @patient_id, @code_system,
    @code_version, @code, @code_display, @certainty, @rank, @note,
    sqlc.narg('onset_at')::timestamptz, NULL, '', @recorded_by, @recorded_at
);

-- name: SupersedeDiagnosis :execrows
-- A change of mind is a new row that supersedes the old one, never an edit.
--
-- Guarded on still being live, so two clinicians revising the same diagnosis at
-- once produce one chain rather than a fork nobody can read.
UPDATE encounter.encounter_diagnosis
SET superseded_by_id = @superseded_by_id
WHERE tenant_id = @tenant_id
  AND diagnosis_id = @diagnosis_id
  AND superseded_by_id IS NULL
  AND retracted_reason = '';

-- name: RetractDiagnosis :execrows
UPDATE encounter.encounter_diagnosis
SET retracted_reason = @retracted_reason
WHERE tenant_id = @tenant_id
  AND diagnosis_id = @diagnosis_id
  AND superseded_by_id IS NULL
  AND retracted_reason = '';

-- name: ListDiagnosesForEncounter :many
SELECT diagnosis_id, tenant_id, encounter_id, patient_id, code_system,
       code_version, code, code_display, certainty, rank, note, onset_at,
       superseded_by_id, retracted_reason, recorded_by, recorded_at
FROM encounter.encounter_diagnosis
WHERE tenant_id = @tenant_id AND encounter_id = @encounter_id
ORDER BY recorded_at, diagnosis_id;

-- name: ListLiveDiagnosesForPatient :many
-- What a problem list and a discharge summary both read.
SELECT diagnosis_id, tenant_id, encounter_id, patient_id, code_system,
       code_version, code, code_display, certainty, rank, note, onset_at,
       superseded_by_id, retracted_reason, recorded_by, recorded_at
FROM encounter.encounter_diagnosis
WHERE tenant_id = @tenant_id
  AND patient_id = @patient_id
  AND superseded_by_id IS NULL
  AND retracted_reason = ''
ORDER BY recorded_at DESC, diagnosis_id
LIMIT @page_limit;

-- name: UpsertClosurePolicy :exec
INSERT INTO encounter.closure_policy (
    policy_id, tenant_id, facility_id, encounter_class, required_items,
    allow_override, created_at, updated_at
) VALUES (
    @policy_id, @tenant_id, sqlc.narg('facility_id')::uuid, @encounter_class,
    @required_items, @allow_override, @created_at, @updated_at
)
ON CONFLICT (tenant_id,
             COALESCE(facility_id, '00000000-0000-0000-0000-000000000000'::uuid),
             encounter_class)
DO UPDATE SET required_items = EXCLUDED.required_items,
              allow_override = EXCLUDED.allow_override,
              updated_at = EXCLUDED.updated_at;

-- name: ListClosurePolicy :many
-- Facility-specific rows first, so the resolver takes the first it sees for
-- each class.
SELECT encounter_class, required_items, allow_override, facility_id
FROM encounter.closure_policy
WHERE tenant_id = @tenant_id
  AND (facility_id IS NULL OR facility_id = sqlc.narg('facility_id')::uuid)
ORDER BY (facility_id IS NULL), encounter_class;

-- name: InsertClosureOverride :exec
INSERT INTO encounter.closure_override (
    override_id, tenant_id, encounter_id, missing_items, reason,
    overridden_by, overridden_at
) VALUES (
    @override_id, @tenant_id, @encounter_id, @missing_items, @reason,
    @overridden_by, @overridden_at
);

-- name: ListClosureOverrides :many
SELECT override_id, tenant_id, encounter_id, missing_items, reason,
       overridden_by, overridden_at
FROM encounter.closure_override
WHERE tenant_id = @tenant_id
  AND (sqlc.narg('encounter_id')::uuid IS NULL
       OR encounter_id = sqlc.narg('encounter_id')::uuid)
ORDER BY overridden_at DESC, override_id
LIMIT @page_limit;

-- name: InsertVisitSummary :exec
INSERT INTO encounter.visit_summary (
    summary_id, tenant_id, encounter_id, patient_id, version, supersedes_id,
    amendment_reason, encounter_class, started_at, ended_at, diagnoses,
    care_team, narrative, generated_by, generated_at
) VALUES (
    @summary_id, @tenant_id, @encounter_id, @patient_id, @version,
    sqlc.narg('supersedes_id')::uuid, @amendment_reason, @encounter_class,
    sqlc.narg('started_at')::timestamptz, sqlc.narg('ended_at')::timestamptz,
    @diagnoses, @care_team, @narrative, @generated_by, @generated_at
);

-- name: ListVisitSummaries :many
-- Every version, newest first. The superseded ones stay readable: somebody
-- acted on them.
SELECT summary_id, tenant_id, encounter_id, patient_id, version, supersedes_id,
       amendment_reason, encounter_class, started_at, ended_at, diagnoses,
       care_team, narrative, generated_by, generated_at
FROM encounter.visit_summary
WHERE tenant_id = @tenant_id AND encounter_id = @encounter_id
ORDER BY version DESC;
