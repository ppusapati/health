-- Infection prevention and control (SRS-IPC-001 … 010).
--
-- Every statement is tenant-scoped in its WHERE clause as well as by the
-- caller's verified scope (FIT-03). Nothing here deletes: a surveillance case
-- the reviewer refuted is evidence about the definition, an overridden alert
-- is the record of a judgement, and a hand hygiene observation removed after
-- the fact is a compliance rate somebody edited.
--
-- Nothing here writes to a medication order. The stewardship statements read
-- and write reviews only; SRS-IPC-008's acceptance is that a review appears
-- in a worklist without autonomous medication change.

-- name: InsertInfectionCase :exec
INSERT INTO infection.surveillance_case (
    case_id, tenant_id, reference, patient_id, encounter_id, facility_id,
    location_id, organism, organism_code, site, multidrug_resistant,
    onset, admitted_at, onset_at, window_hours, criteria,
    device_in_situ, device_days, state, notes, reported_at, reported_by
) VALUES (
    @case_id, @tenant_id, @reference, @patient_id, @encounter_id,
    @facility_id, @location_id, @organism, @organism_code, @site,
    @multidrug_resistant, @onset, @admitted_at, @onset_at, @window_hours,
    @criteria, @device_in_situ, @device_days, @state, @notes,
    @reported_at, @reported_by
);

-- name: GetInfectionCase :one
SELECT * FROM infection.surveillance_case
WHERE tenant_id = @tenant_id AND case_id = @case_id;

-- name: UpdateInfectionCase :execrows
UPDATE infection.surveillance_case
SET state = @state, criteria = @criteria,
    reviewed_by = @reviewed_by, reviewed_at = @reviewed_at,
    onset_override = @onset_override,
    onset_override_why = @onset_override_why,
    onset_overridden_by = @onset_overridden_by,
    notes = @notes, closed_at = @closed_at, closed_by = @closed_by,
    version = version + 1
WHERE tenant_id = @tenant_id AND case_id = @case_id
  AND version = @expected_version;

-- name: ListInfectionCases :many
SELECT * FROM infection.surveillance_case
WHERE tenant_id = @tenant_id
  AND (@patient_id::text = '' OR patient_id = @patient_id)
  AND (@state::text = '' OR state = @state)
  AND (@site::text = '' OR site = @site)
  AND (@location_id::text = '' OR location_id = @location_id)
  AND onset_at >= @onset_from AND onset_at < @onset_to
ORDER BY onset_at DESC
LIMIT @page_size OFFSET @page_offset;

-- name: UpsertInfectionDeviceDays :exec
INSERT INTO infection.device_day_count (
    count_id, tenant_id, facility_id, location_id, device, counted_on,
    patient_days, device_days, recorded_at, recorded_by
) VALUES (
    @count_id, @tenant_id, @facility_id, @location_id, @device, @counted_on,
    @patient_days, @device_days, @recorded_at, @recorded_by
)
ON CONFLICT (tenant_id, location_id, device, counted_on) DO UPDATE
SET patient_days = EXCLUDED.patient_days,
    device_days = EXCLUDED.device_days,
    recorded_at = EXCLUDED.recorded_at,
    recorded_by = EXCLUDED.recorded_by;

-- name: ListInfectionDeviceDays :many
SELECT * FROM infection.device_day_count
WHERE tenant_id = @tenant_id
  AND (@device::text = '' OR device = @device)
  AND (@location_id::text = '' OR location_id = @location_id)
  AND counted_on >= @counted_from AND counted_on < @counted_to
ORDER BY counted_on;

-- name: InsertInfectionIsolation :exec
INSERT INTO infection.isolation (
    isolation_id, tenant_id, patient_id, encounter_id, facility_id,
    location_id, bed_id, precaution, reason, case_id,
    started_at, started_by, review_due
) VALUES (
    @isolation_id, @tenant_id, @patient_id, @encounter_id, @facility_id,
    @location_id, @bed_id, @precaution, @reason, @case_id,
    @started_at, @started_by, @review_due
);

-- name: GetInfectionIsolation :one
SELECT * FROM infection.isolation
WHERE tenant_id = @tenant_id AND isolation_id = @isolation_id;

-- name: UpdateInfectionIsolation :execrows
UPDATE infection.isolation
SET review_due = @review_due, ended_at = @ended_at, ended_by = @ended_by,
    end_reason = @end_reason, version = version + 1
WHERE tenant_id = @tenant_id AND isolation_id = @isolation_id
  AND version = @expected_version;

-- name: ListInfectionIsolations :many
SELECT * FROM infection.isolation
WHERE tenant_id = @tenant_id
  AND (@location_id::text = '' OR location_id = @location_id)
  AND (@patient_id::text = '' OR patient_id = @patient_id)
  AND (NOT @active_only::boolean OR ended_at IS NULL)
ORDER BY started_at DESC
LIMIT @page_size OFFSET @page_offset;

-- name: InsertInfectionAlertRule :exec
INSERT INTO infection.alert_rule (
    rule_id, tenant_id, code, name, revision, organisms, lookback_days,
    precaution, advice, effective_from, created_at, created_by
) VALUES (
    @rule_id, @tenant_id, @code, @name, @revision, @organisms,
    @lookback_days, @precaution, @advice, @effective_from,
    @created_at, @created_by
);

-- name: GetInfectionAlertRule :one
SELECT * FROM infection.alert_rule
WHERE tenant_id = @tenant_id AND rule_id = @rule_id;

-- name: ApproveInfectionAlertRule :execrows
UPDATE infection.alert_rule
SET approved = true, approved_by = @approved_by, approved_at = @approved_at,
    effective_from = @effective_from
WHERE tenant_id = @tenant_id AND rule_id = @rule_id AND NOT approved;

-- name: SupersedeInfectionAlertRule :execrows
UPDATE infection.alert_rule
SET superseded_at = @superseded_at
WHERE tenant_id = @tenant_id AND code = @code AND revision < @revision
  AND superseded_at IS NULL;

-- name: ListInfectionAlertRules :many
SELECT * FROM infection.alert_rule
WHERE tenant_id = @tenant_id
  AND (@code::text = '' OR code = @code)
  AND (NOT @live_only::boolean
       OR (approved
           AND effective_from IS NOT NULL AND effective_from <= @at
           AND (superseded_at IS NULL OR superseded_at > @at)))
ORDER BY code, revision DESC;

-- name: InsertInfectionAlert :exec
INSERT INTO infection.alert (
    alert_id, tenant_id, patient_id, encounter_id, facility_id,
    rule_id, rule_code, rule_revision, organism, organism_code,
    last_positive_at, precaution, advice, raised_at
) VALUES (
    @alert_id, @tenant_id, @patient_id, @encounter_id, @facility_id,
    @rule_id, @rule_code, @rule_revision, @organism, @organism_code,
    @last_positive_at, @precaution, @advice, @raised_at
);

-- name: GetInfectionAlert :one
SELECT * FROM infection.alert
WHERE tenant_id = @tenant_id AND alert_id = @alert_id;

-- name: UpdateInfectionAlert :execrows
UPDATE infection.alert
SET acknowledged_at = @acknowledged_at, acknowledged_by = @acknowledged_by,
    overridden = @overridden, override_why = @override_why,
    overridden_by = @overridden_by, overridden_at = @overridden_at
WHERE tenant_id = @tenant_id AND alert_id = @alert_id;

-- name: ListInfectionAlerts :many
SELECT * FROM infection.alert
WHERE tenant_id = @tenant_id
  AND (@encounter_id::text = '' OR encounter_id = @encounter_id)
  AND (@patient_id::text = '' OR patient_id = @patient_id)
  AND (NOT @outstanding_only::boolean
       OR (acknowledged_at IS NULL AND NOT overridden))
ORDER BY raised_at DESC
LIMIT @page_size OFFSET @page_offset;

-- name: InsertInfectionOutbreak :exec
INSERT INTO infection.outbreak (
    outbreak_id, tenant_id, reference, organism, case_definition,
    locations, window_from, window_to, state, created_at, created_by
) VALUES (
    @outbreak_id, @tenant_id, @reference, @organism, @case_definition,
    @locations, @window_from, @window_to, @state, @created_at, @created_by
);

-- name: GetInfectionOutbreak :one
SELECT * FROM infection.outbreak
WHERE tenant_id = @tenant_id AND outbreak_id = @outbreak_id;

-- name: UpdateInfectionOutbreak :execrows
UPDATE infection.outbreak
SET state = @state, findings = @findings,
    control_measures = @control_measures, action_ids = @action_ids,
    declared_at = @declared_at, declared_by = @declared_by,
    closed_at = @closed_at, closed_by = @closed_by,
    closure_why = @closure_why, version = version + 1
WHERE tenant_id = @tenant_id AND outbreak_id = @outbreak_id
  AND version = @expected_version;

-- name: ListInfectionOutbreaks :many
SELECT * FROM infection.outbreak
WHERE tenant_id = @tenant_id
  AND (@state::text = '' OR state = @state)
  AND (NOT @open_only::boolean
       OR state IN ('suspected', 'declared', 'contained'))
ORDER BY window_from DESC
LIMIT @page_size OFFSET @page_offset;

-- name: InsertInfectionOutbreakMember :exec
INSERT INTO infection.outbreak_member (
    membership_id, tenant_id, outbreak_id, case_id, patient_id,
    reason, note, decided_at, decided_by
) VALUES (
    @membership_id, @tenant_id, @outbreak_id, @case_id, @patient_id,
    @reason, @note, @decided_at, @decided_by
);

-- name: ListInfectionOutbreakMembers :many
SELECT * FROM infection.outbreak_member
WHERE tenant_id = @tenant_id AND outbreak_id = @outbreak_id
ORDER BY decided_at;

-- name: InsertInfectionHygieneSession :exec
INSERT INTO infection.hygiene_session (
    session_id, tenant_id, facility_id, location_id, observer_id,
    started_at, notes, created_at
) VALUES (
    @session_id, @tenant_id, @facility_id, @location_id, @observer_id,
    @started_at, @notes, @created_at
);

-- name: GetInfectionHygieneSession :one
SELECT * FROM infection.hygiene_session
WHERE tenant_id = @tenant_id AND session_id = @session_id;

-- name: EndInfectionHygieneSession :execrows
UPDATE infection.hygiene_session
SET ended_at = @ended_at, notes = @notes, version = version + 1
WHERE tenant_id = @tenant_id AND session_id = @session_id
  AND version = @expected_version;

-- name: InsertInfectionHygieneObservation :exec
INSERT INTO infection.hygiene_observation (
    observation_id, tenant_id, session_id, discipline, moment, action,
    gloves_worn, observed_at
) VALUES (
    @observation_id, @tenant_id, @session_id, @discipline, @moment, @action,
    @gloves_worn, @observed_at
);

-- name: ListInfectionHygieneObservations :many
SELECT o.* FROM infection.hygiene_observation o
JOIN infection.hygiene_session s
  ON s.session_id = o.session_id AND s.tenant_id = o.tenant_id
WHERE o.tenant_id = @tenant_id
  AND (@location_id::text = '' OR s.location_id = @location_id)
  AND (@session_id::text = '' OR o.session_id::text = @session_id)
  AND o.observed_at >= @observed_from AND o.observed_at < @observed_to
ORDER BY o.observed_at;

-- name: InsertInfectionExposure :exec
INSERT INTO infection.exposure (
    exposure_id, tenant_id, reference, staff_id, discipline, facility_id,
    location_id, kind, device, circumstance, deep_injury,
    source_patient_id, source_known, source_consented,
    occurred_at, reported_at, reported_by
) VALUES (
    @exposure_id, @tenant_id, @reference, @staff_id, @discipline,
    @facility_id, @location_id, @kind, @device, @circumstance, @deep_injury,
    @source_patient_id, @source_known, @source_consented,
    @occurred_at, @reported_at, @reported_by
);

-- name: GetInfectionExposure :one
SELECT * FROM infection.exposure
WHERE tenant_id = @tenant_id AND exposure_id = @exposure_id;

-- name: CloseInfectionExposure :execrows
UPDATE infection.exposure
SET closed_at = @closed_at, closed_by = @closed_by, outcome = @outcome,
    version = version + 1
WHERE tenant_id = @tenant_id AND exposure_id = @exposure_id
  AND version = @expected_version;

-- name: ListInfectionExposures :many
SELECT * FROM infection.exposure
WHERE tenant_id = @tenant_id
  AND (@staff_id::text = '' OR staff_id = @staff_id)
  AND (NOT @open_only::boolean OR closed_at IS NULL)
  AND occurred_at >= @occurred_from AND occurred_at < @occurred_to
ORDER BY occurred_at DESC
LIMIT @page_size OFFSET @page_offset;

-- name: InsertInfectionExposureTask :exec
INSERT INTO infection.exposure_task (
    task_id, tenant_id, exposure_id, code, due_by, state
) VALUES (
    @task_id, @tenant_id, @exposure_id, @code, @due_by, @state
);

-- name: ListInfectionExposureTasks :many
SELECT * FROM infection.exposure_task
WHERE tenant_id = @tenant_id AND exposure_id = @exposure_id
ORDER BY due_by;

-- name: UpdateInfectionExposureTask :execrows
UPDATE infection.exposure_task
SET state = @state, outcome = @outcome, completed_at = @completed_at,
    completed_by = @completed_by
WHERE tenant_id = @tenant_id AND task_id = @task_id AND state = 'due';

-- name: ListInfectionDueExposureTasks :many
SELECT * FROM infection.exposure_task
WHERE tenant_id = @tenant_id AND state = 'due' AND due_by < @before
ORDER BY due_by;

-- name: InsertInfectionStewardshipRule :exec
INSERT INTO infection.stewardship_rule (
    rule_id, tenant_id, code, name, revision, kind, agents, all_agents,
    day_threshold, prompt, effective_from, created_at, created_by
) VALUES (
    @rule_id, @tenant_id, @code, @name, @revision, @kind, @agents,
    @all_agents, @day_threshold, @prompt, @effective_from,
    @created_at, @created_by
);

-- name: GetInfectionStewardshipRule :one
SELECT * FROM infection.stewardship_rule
WHERE tenant_id = @tenant_id AND rule_id = @rule_id;

-- name: ApproveInfectionStewardshipRule :execrows
UPDATE infection.stewardship_rule
SET approved = true, approved_by = @approved_by, approved_at = @approved_at,
    effective_from = @effective_from
WHERE tenant_id = @tenant_id AND rule_id = @rule_id AND NOT approved;

-- name: SupersedeInfectionStewardshipRule :execrows
UPDATE infection.stewardship_rule
SET superseded_at = @superseded_at
WHERE tenant_id = @tenant_id AND code = @code AND revision < @revision
  AND superseded_at IS NULL;

-- name: ListInfectionStewardshipRules :many
SELECT * FROM infection.stewardship_rule
WHERE tenant_id = @tenant_id
  AND (@code::text = '' OR code = @code)
  AND (NOT @live_only::boolean
       OR (approved
           AND effective_from IS NOT NULL AND effective_from <= @at
           AND (superseded_at IS NULL OR superseded_at > @at)))
ORDER BY code, revision DESC;

-- name: InsertInfectionStewardshipReview :exec
INSERT INTO infection.stewardship_review (
    review_id, tenant_id, patient_id, encounter_id, location_id,
    rule_id, rule_code, rule_revision, kind, agent, order_id, why,
    state, raised_at, due_by
) VALUES (
    @review_id, @tenant_id, @patient_id, @encounter_id, @location_id,
    @rule_id, @rule_code, @rule_revision, @kind, @agent, @order_id, @why,
    @state, @raised_at, @due_by
);

-- name: GetInfectionStewardshipReview :one
SELECT * FROM infection.stewardship_review
WHERE tenant_id = @tenant_id AND review_id = @review_id;

-- name: UpdateInfectionStewardshipReview :execrows
UPDATE infection.stewardship_review
SET state = @state, recommendation = @recommendation, advice = @advice,
    reviewed_by = @reviewed_by, reviewed_at = @reviewed_at,
    response = @response, response_reason = @response_reason,
    responded_by = @responded_by, responded_at = @responded_at,
    withdrawn_reason = @withdrawn_reason, version = version + 1
WHERE tenant_id = @tenant_id AND review_id = @review_id
  AND version = @expected_version;

-- name: ListInfectionStewardshipReviews :many
SELECT * FROM infection.stewardship_review
WHERE tenant_id = @tenant_id
  AND (@encounter_id::text = '' OR encounter_id = @encounter_id)
  AND (@patient_id::text = '' OR patient_id = @patient_id)
  AND (@state::text = '' OR state = @state)
  AND (NOT @worklist_only::boolean OR state IN ('open', 'advised'))
  AND raised_at >= @raised_from AND raised_at < @raised_to
ORDER BY due_by NULLS LAST, raised_at
LIMIT @page_size OFFSET @page_offset;

-- name: InsertInfectionLimit :exec
INSERT INTO infection.environmental_limit (
    limit_id, tenant_id, code, name, revision, sample_kind, unit,
    action_level, fail_level, detection_fails, below_is_failure,
    effective_from, created_at, created_by
) VALUES (
    @limit_id, @tenant_id, @code, @name, @revision, @sample_kind, @unit,
    @action_level, @fail_level, @detection_fails, @below_is_failure,
    @effective_from, @created_at, @created_by
);

-- name: GetInfectionLimit :one
SELECT * FROM infection.environmental_limit
WHERE tenant_id = @tenant_id AND limit_id = @limit_id;

-- name: ApproveInfectionLimit :execrows
UPDATE infection.environmental_limit
SET approved = true, approved_by = @approved_by, approved_at = @approved_at,
    effective_from = @effective_from
WHERE tenant_id = @tenant_id AND limit_id = @limit_id AND NOT approved;

-- name: SupersedeInfectionLimit :execrows
UPDATE infection.environmental_limit
SET superseded_at = @superseded_at
WHERE tenant_id = @tenant_id AND code = @code AND revision < @revision
  AND superseded_at IS NULL;

-- name: ListInfectionLimits :many
SELECT * FROM infection.environmental_limit
WHERE tenant_id = @tenant_id
  AND (@sample_kind::text = '' OR sample_kind = @sample_kind)
  AND (NOT @live_only::boolean
       OR (approved
           AND effective_from IS NOT NULL AND effective_from <= @at
           AND (superseded_at IS NULL OR superseded_at > @at)))
ORDER BY sample_kind, effective_from DESC, revision DESC;

-- name: InsertInfectionSamplingPlan :exec
INSERT INTO infection.sampling_plan (
    plan_id, tenant_id, code, sample_kind, facility_id, location_id,
    sample_point, every_days, active, started_at
) VALUES (
    @plan_id, @tenant_id, @code, @sample_kind, @facility_id, @location_id,
    @sample_point, @every_days, @active, @started_at
);

-- name: StopInfectionSamplingPlan :execrows
UPDATE infection.sampling_plan
SET active = false, stopped_at = @stopped_at
WHERE tenant_id = @tenant_id AND plan_id = @plan_id AND active;

-- name: ListInfectionSamplingPlans :many
SELECT * FROM infection.sampling_plan
WHERE tenant_id = @tenant_id
  AND (@location_id::text = '' OR location_id = @location_id)
  AND (NOT @active_only::boolean OR active)
ORDER BY location_id, sample_point;

-- name: InsertInfectionSample :exec
INSERT INTO infection.environmental_sample (
    sample_id, tenant_id, reference, sample_kind, facility_id, location_id,
    sample_point, plan_id, outbreak_id, repeat_of_id,
    collected_at, collected_by, method, state
) VALUES (
    @sample_id, @tenant_id, @reference, @sample_kind, @facility_id,
    @location_id, @sample_point, @plan_id, @outbreak_id, @repeat_of_id,
    @collected_at, @collected_by, @method, @state
);

-- name: GetInfectionSample :one
SELECT * FROM infection.environmental_sample
WHERE tenant_id = @tenant_id AND sample_id = @sample_id;

-- name: UpdateInfectionSample :execrows
UPDATE infection.environmental_sample
SET state = @state, lab_reference = @lab_reference, value = @value,
    unit = @unit, organism = @organism, detected = @detected,
    resulted_at = @resulted_at, resulted_by = @resulted_by,
    outcome = @outcome, limit_code = @limit_code,
    limit_revision = @limit_revision,
    closed_at = @closed_at, closed_by = @closed_by, version = version + 1
WHERE tenant_id = @tenant_id AND sample_id = @sample_id
  AND version = @expected_version;

-- name: ListInfectionSamples :many
SELECT * FROM infection.environmental_sample
WHERE tenant_id = @tenant_id
  AND (@location_id::text = '' OR location_id = @location_id)
  AND (@sample_kind::text = '' OR sample_kind = @sample_kind)
  AND (NOT @failing_only::boolean
       OR outcome IN ('action_level', 'fail', 'unassessable'))
  AND collected_at >= @collected_from AND collected_at < @collected_to
ORDER BY collected_at DESC
LIMIT @page_size OFFSET @page_offset;

-- name: InsertInfectionCorrectiveAction :exec
INSERT INTO infection.corrective_action (
    action_id, tenant_id, sample_id, location_id, action, owner, due_by,
    state
) VALUES (
    @action_id, @tenant_id, @sample_id, @location_id, @action, @owner,
    @due_by, @state
);

-- name: GetInfectionCorrectiveAction :one
SELECT * FROM infection.corrective_action
WHERE tenant_id = @tenant_id AND action_id = @action_id;

-- name: UpdateInfectionCorrectiveAction :execrows
UPDATE infection.corrective_action
SET state = @state, done_at = @done_at, done_by = @done_by,
    done_note = @done_note, repeat_sample_id = @repeat_sample_id,
    verified_at = @verified_at, verified_by = @verified_by,
    version = version + 1
WHERE tenant_id = @tenant_id AND action_id = @action_id
  AND version = @expected_version;

-- name: ListInfectionCorrectiveActions :many
SELECT * FROM infection.corrective_action
WHERE tenant_id = @tenant_id
  AND (@sample_id::uuid = '00000000-0000-0000-0000-000000000000'::uuid
       OR sample_id = @sample_id)
  AND (NOT @open_only::boolean OR state <> 'verified')
ORDER BY due_by;
