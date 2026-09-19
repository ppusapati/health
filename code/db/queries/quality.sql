-- Quality management, accreditation and risk (SRS-QMS-001 … 015).
--
-- Every statement is tenant-scoped in its WHERE clause as well as by the
-- caller's verified scope (FIT-03). Nothing here deletes: SRS-QMS-015 requires
-- these records be preserved subject to retention and legal hold.

-- name: InsertQualityIncident :exec
INSERT INTO quality.incident (
    incident_id, tenant_id, reference, category, subcategory,
    reach, harm, consequence, likelihood, risk_score, risk_band,
    patient_id, encounter_id, asset_id, location_id, facility_id, department,
    narrative, immediate_action, sentinel, restricted, anonymous, state,
    occurred_at, reported_at, reported_by
) VALUES (
    @incident_id, @tenant_id, @reference, @category, @subcategory,
    @reach, @harm, @consequence, @likelihood, @risk_score, @risk_band,
    @patient_id, @encounter_id, @asset_id, @location_id, @facility_id,
    @department, @narrative, @immediate_action, @sentinel, @restricted,
    @anonymous, @state, @occurred_at, @reported_at, @reported_by
);

-- name: GetQualityIncident :one
SELECT * FROM quality.incident
WHERE tenant_id = @tenant_id AND incident_id = @incident_id;

-- name: UpdateQualityIncident :execrows
UPDATE quality.incident
SET consequence = @consequence, likelihood = @likelihood,
    risk_score = @risk_score, risk_band = @risk_band,
    restricted = @restricted, sentinel = @sentinel, state = @state,
    reviewed_by = @reviewed_by, reviewed_at = @reviewed_at,
    closed_by = @closed_by, closed_at = @closed_at,
    closure_reason = @closure_reason, version = version + 1
WHERE tenant_id = @tenant_id AND incident_id = @incident_id
  AND version = @expected_version;

-- name: ListQualityIncidents :many
SELECT * FROM quality.incident
WHERE tenant_id = @tenant_id
  AND (@category::text = '' OR category = @category)
  AND (@state::text = '' OR state = @state)
  AND (NOT @open_only::boolean
       OR state IN ('reported', 'under_review', 'investigated'))
  AND (NOT @sentinel_only::boolean OR sentinel)
  AND occurred_at >= @from_at AND occurred_at < @to_at
ORDER BY occurred_at DESC
LIMIT @row_limit;

-- name: ListQualityIncidentsForPatient :many
SELECT * FROM quality.incident
WHERE tenant_id = @tenant_id AND patient_id = @patient_id
ORDER BY occurred_at DESC
LIMIT @row_limit;

-- name: InsertQualityRCA :exec
INSERT INTO quality.rca (
    rca_id, tenant_id, incident_id, method, state, restricted,
    opened_at, opened_by
) VALUES (
    @rca_id, @tenant_id, @incident_id, @method, @state, @restricted,
    @opened_at, @opened_by
);

-- name: GetQualityRCA :one
SELECT * FROM quality.rca
WHERE tenant_id = @tenant_id AND rca_id = @rca_id;

-- name: GetQualityRCAForIncident :one
SELECT * FROM quality.rca
WHERE tenant_id = @tenant_id AND incident_id = @incident_id;

-- name: UpdateQualityRCA :execrows
UPDATE quality.rca
SET accountable_owner = @accountable_owner, findings = @findings,
    no_action_reason = @no_action_reason, state = @state,
    closed_at = @closed_at, closed_by = @closed_by, version = version + 1
WHERE tenant_id = @tenant_id AND rca_id = @rca_id
  AND version = @expected_version;

-- name: InsertQualityRCAFactor :exec
INSERT INTO quality.rca_factor (
    factor_id, tenant_id, rca_id, category, detail, root
) VALUES (@factor_id, @tenant_id, @rca_id, @category, @detail, @root);

-- name: ListQualityRCAFactors :many
SELECT * FROM quality.rca_factor
WHERE tenant_id = @tenant_id AND rca_id = @rca_id
ORDER BY root DESC, recorded_at;

-- name: InsertQualityCAPA :exec
INSERT INTO quality.capa (
    capa_id, tenant_id, reference, kind, source_kind, source_id,
    action, owner_id, due_on, effectiveness_due_on, state,
    restricted, raised_at, raised_by
) VALUES (
    @capa_id, @tenant_id, @reference, @kind, @source_kind, @source_id,
    @action, @owner_id, @due_on, @effectiveness_due_on, @state,
    @restricted, @raised_at, @raised_by
);

-- name: GetQualityCAPA :one
SELECT * FROM quality.capa
WHERE tenant_id = @tenant_id AND capa_id = @capa_id;

-- name: UpdateQualityCAPA :execrows
UPDATE quality.capa
SET state = @state, approved_by = @approved_by, approved_at = @approved_at,
    closed_by = @closed_by, closed_at = @closed_at,
    closure_note = @closure_note, cancelled_reason = @cancelled_reason,
    version = version + 1
WHERE tenant_id = @tenant_id AND capa_id = @capa_id
  AND version = @expected_version;

-- name: ListQualityCAPAs :many
SELECT * FROM quality.capa
WHERE tenant_id = @tenant_id
  AND (@source_kind::text = '' OR source_kind = @source_kind)
  AND (@source_id::text = '' OR source_id = @source_id)
  AND (@owner_id::text = '' OR owner_id = @owner_id)
  AND (NOT @live_only::boolean OR state NOT IN ('closed', 'cancelled'))
ORDER BY due_on
LIMIT @row_limit;

-- name: CountQualityLiveCAPAsForSource :one
SELECT count(*) FROM quality.capa
WHERE tenant_id = @tenant_id AND source_kind = @source_kind
  AND source_id = @source_id;

-- name: InsertQualityCAPACheck :exec
INSERT INTO quality.capa_check (
    check_id, tenant_id, capa_id, checked_at, checked_by, effective, evidence
) VALUES (
    @check_id, @tenant_id, @capa_id, @checked_at, @checked_by,
    @effective, @evidence
);

-- name: ListQualityCAPAChecks :many
SELECT * FROM quality.capa_check
WHERE tenant_id = @tenant_id AND capa_id = @capa_id
ORDER BY checked_at;

-- name: InsertQualityDocument :exec
INSERT INTO quality.document (
    document_id, tenant_id, code, title, kind, owner_id, review_months,
    department, created_at, created_by
) VALUES (
    @document_id, @tenant_id, @code, @title, @kind, @owner_id, @review_months,
    @department, @created_at, @created_by
);

-- name: GetQualityDocument :one
SELECT * FROM quality.document
WHERE tenant_id = @tenant_id AND document_id = @document_id;

-- name: UpdateQualityDocument :execrows
UPDATE quality.document
SET title = @title, owner_id = @owner_id, review_months = @review_months,
    department = @department, withdrawn = @withdrawn,
    withdrawn_at = @withdrawn_at, version = version + 1
WHERE tenant_id = @tenant_id AND document_id = @document_id
  AND version = @expected_version;

-- name: ListQualityDocuments :many
SELECT * FROM quality.document
WHERE tenant_id = @tenant_id
  AND (@kind::text = '' OR kind = @kind)
  AND (@department::text = '' OR department = @department)
  AND (NOT @exclude_withdrawn::boolean OR NOT withdrawn)
ORDER BY code
LIMIT @row_limit;

-- name: InsertQualityDocumentVersion :exec
INSERT INTO quality.document_version (
    version_id, tenant_id, document_id, label, ordinal, content_ref,
    change_summary, state, requires_acknowledgement, requires_retraining,
    created_at, created_by
) VALUES (
    @version_id, @tenant_id, @document_id, @label, @ordinal, @content_ref,
    @change_summary, @state, @requires_acknowledgement, @requires_retraining,
    @created_at, @created_by
);

-- name: GetQualityDocumentVersion :one
SELECT * FROM quality.document_version
WHERE tenant_id = @tenant_id AND version_id = @version_id;

-- name: UpdateQualityDocumentVersion :execrows
UPDATE quality.document_version
SET state = @state, content_ref = @content_ref,
    change_summary = @change_summary,
    approved_by = @approved_by, approved_at = @approved_at,
    effective_from = @effective_from, obsolete_from = @obsolete_from,
    row_version = row_version + 1
WHERE tenant_id = @tenant_id AND version_id = @version_id
  AND row_version = @expected_version;

-- name: ListQualityDocumentVersions :many
SELECT * FROM quality.document_version
WHERE tenant_id = @tenant_id AND document_id = @document_id
ORDER BY ordinal;

-- name: InsertQualityAcknowledgement :exec
INSERT INTO quality.document_acknowledgement (
    acknowledgement_id, tenant_id, version_id, document_id, person_id, role,
    acknowledged_at
) VALUES (
    @acknowledgement_id, @tenant_id, @version_id, @document_id, @person_id,
    @role, @acknowledged_at
)
ON CONFLICT (tenant_id, version_id, person_id) DO NOTHING;

-- name: ListQualityAcknowledgements :many
SELECT * FROM quality.document_acknowledgement
WHERE tenant_id = @tenant_id AND version_id = @version_id
ORDER BY acknowledged_at;

-- name: InsertQualityCompetency :exec
INSERT INTO quality.competency (
    competency_id, tenant_id, code, name, document_id, valid_months,
    active, created_at, created_by
) VALUES (
    @competency_id, @tenant_id, @code, @name, @document_id, @valid_months,
    @active, @created_at, @created_by
);

-- name: ListQualityCompetencies :many
SELECT * FROM quality.competency
WHERE tenant_id = @tenant_id AND (NOT @active_only::boolean OR active)
ORDER BY code;

-- name: SetQualityRoleCompetency :exec
INSERT INTO quality.role_competency (tenant_id, role, competency_id)
VALUES (@tenant_id, @role, @competency_id)
ON CONFLICT DO NOTHING;

-- name: ListQualityRoleCompetencies :many
SELECT * FROM quality.role_competency
WHERE tenant_id = @tenant_id
ORDER BY role, competency_id;

-- name: InsertQualityAward :exec
INSERT INTO quality.competency_award (
    award_id, tenant_id, competency_id, person_id, version_id, evidence,
    awarded_at, awarded_by, expires_at
) VALUES (
    @award_id, @tenant_id, @competency_id, @person_id, @version_id, @evidence,
    @awarded_at, @awarded_by, @expires_at
);

-- name: RevokeQualityAward :execrows
UPDATE quality.competency_award
SET revoked_at = @revoked_at, revoked_why = @revoked_why
WHERE tenant_id = @tenant_id AND award_id = @award_id
  AND revoked_at IS NULL;

-- name: ListQualityAwards :many
SELECT * FROM quality.competency_award
WHERE tenant_id = @tenant_id
  AND (@person_id::text = '' OR person_id = @person_id)
ORDER BY person_id, awarded_at DESC
LIMIT @row_limit;

-- name: InsertQualityAudit :exec
INSERT INTO quality.audit (
    audit_id, tenant_id, reference, title, scope, standard_id,
    auditor_id, auditee_department, planned_from, planned_to, state,
    created_at, created_by
) VALUES (
    @audit_id, @tenant_id, @reference, @title, @scope, @standard_id,
    @auditor_id, @auditee_department, @planned_from, @planned_to, @state,
    @created_at, @created_by
);

-- name: GetQualityAudit :one
SELECT * FROM quality.audit
WHERE tenant_id = @tenant_id AND audit_id = @audit_id;

-- name: UpdateQualityAudit :execrows
UPDATE quality.audit
SET state = @state, summary = @summary,
    closed_at = @closed_at, closed_by = @closed_by, version = version + 1
WHERE tenant_id = @tenant_id AND audit_id = @audit_id
  AND version = @expected_version;

-- name: ListQualityAudits :many
SELECT * FROM quality.audit
WHERE tenant_id = @tenant_id
  AND (@state::text = '' OR state = @state)
ORDER BY planned_from DESC
LIMIT @row_limit;

-- name: InsertQualityFinding :exec
INSERT INTO quality.audit_finding (
    finding_id, tenant_id, audit_id, clause_id, severity, detail, evidence,
    raised_at, raised_by
) VALUES (
    @finding_id, @tenant_id, @audit_id, @clause_id, @severity, @detail,
    @evidence, @raised_at, @raised_by
);

-- name: GetQualityFinding :one
SELECT * FROM quality.audit_finding
WHERE tenant_id = @tenant_id AND finding_id = @finding_id;

-- name: UpdateQualityFinding :exec
UPDATE quality.audit_finding
SET capa_id = @capa_id, closed_at = @closed_at, closed_by = @closed_by,
    closure_note = @closure_note
WHERE tenant_id = @tenant_id AND finding_id = @finding_id;

-- name: ListQualityFindings :many
SELECT * FROM quality.audit_finding
WHERE tenant_id = @tenant_id
  AND (@audit_id::text = '' OR audit_id::text = @audit_id)
  AND (NOT @open_only::boolean OR closed_at IS NULL)
ORDER BY severity, raised_at;

-- name: InsertQualityCommittee :exec
INSERT INTO quality.committee (
    committee_id, tenant_id, code, name, terms, quorum_size, restricted,
    members, active, created_at, created_by
) VALUES (
    @committee_id, @tenant_id, @code, @name, @terms, @quorum_size, @restricted,
    @members, @active, @created_at, @created_by
);

-- name: GetQualityCommittee :one
SELECT * FROM quality.committee
WHERE tenant_id = @tenant_id AND committee_id = @committee_id;

-- name: UpdateQualityCommittee :execrows
UPDATE quality.committee
SET name = @name, terms = @terms, quorum_size = @quorum_size,
    members = @members, active = @active, version = version + 1
WHERE tenant_id = @tenant_id AND committee_id = @committee_id
  AND version = @expected_version;

-- name: ListQualityCommittees :many
SELECT * FROM quality.committee
WHERE tenant_id = @tenant_id AND (NOT @active_only::boolean OR active)
ORDER BY code;

-- name: InsertQualityMeeting :exec
INSERT INTO quality.committee_meeting (
    meeting_id, tenant_id, committee_id, scheduled_at, agenda, state,
    restricted, created_at, created_by
) VALUES (
    @meeting_id, @tenant_id, @committee_id, @scheduled_at, @agenda, @state,
    @restricted, @created_at, @created_by
);

-- name: GetQualityMeeting :one
SELECT * FROM quality.committee_meeting
WHERE tenant_id = @tenant_id AND meeting_id = @meeting_id;

-- name: UpdateQualityMeeting :execrows
UPDATE quality.committee_meeting
SET held_at = @held_at, attendees = @attendees, apologies = @apologies,
    minutes = @minutes, decisions = @decisions, state = @state,
    approved_by = @approved_by, approved_at = @approved_at,
    version = version + 1
WHERE tenant_id = @tenant_id AND meeting_id = @meeting_id
  AND version = @expected_version;

-- name: ListQualityMeetings :many
SELECT * FROM quality.committee_meeting
WHERE tenant_id = @tenant_id AND committee_id = @committee_id
ORDER BY scheduled_at DESC
LIMIT @row_limit;

-- name: InsertQualityStandard :exec
INSERT INTO quality.standard (
    standard_id, tenant_id, code, name, edition, active, created_at, created_by
) VALUES (
    @standard_id, @tenant_id, @code, @name, @edition, @active,
    @created_at, @created_by
);

-- name: GetQualityStandard :one
SELECT * FROM quality.standard
WHERE tenant_id = @tenant_id AND standard_id = @standard_id;

-- name: ListQualityStandards :many
SELECT * FROM quality.standard
WHERE tenant_id = @tenant_id AND (NOT @active_only::boolean OR active)
ORDER BY code, edition;

-- name: InsertQualityClause :exec
INSERT INTO quality.clause (
    clause_id, tenant_id, standard_id, reference, chapter, clause_text,
    critical, created_at
) VALUES (
    @clause_id, @tenant_id, @standard_id, @reference, @chapter, @clause_text,
    @critical, @created_at
);

-- name: ListQualityClauses :many
SELECT * FROM quality.clause
WHERE tenant_id = @tenant_id AND standard_id = @standard_id
ORDER BY chapter, reference;

-- name: InsertQualityEvidence :exec
INSERT INTO quality.evidence (
    evidence_id, tenant_id, clause_id, kind, ref_id, external_ref,
    description, added_at, added_by
) VALUES (
    @evidence_id, @tenant_id, @clause_id, @kind, @ref_id, @external_ref,
    @description, @added_at, @added_by
);

-- name: WithdrawQualityEvidence :execrows
UPDATE quality.evidence
SET removed_at = @removed_at, removed_by = @removed_by,
    removed_why = @removed_why
WHERE tenant_id = @tenant_id AND evidence_id = @evidence_id
  AND removed_at IS NULL;

-- name: ListQualityEvidenceForStandard :many
SELECT e.* FROM quality.evidence e
JOIN quality.clause c ON c.clause_id = e.clause_id AND c.tenant_id = e.tenant_id
WHERE e.tenant_id = @tenant_id AND c.standard_id = @standard_id
  AND (NOT @live_only::boolean OR e.removed_at IS NULL)
ORDER BY e.clause_id, e.added_at;

-- name: InsertQualityClauseReview :exec
INSERT INTO quality.clause_review (
    review_id, tenant_id, clause_id, verdict, note, capa_id,
    reviewed_at, reviewed_by
) VALUES (
    @review_id, @tenant_id, @clause_id, @verdict, @note, @capa_id,
    @reviewed_at, @reviewed_by
);

-- name: ListQualityLatestClauseReviews :many
SELECT DISTINCT ON (r.clause_id) r.*
FROM quality.clause_review r
JOIN quality.clause c ON c.clause_id = r.clause_id AND c.tenant_id = r.tenant_id
WHERE r.tenant_id = @tenant_id AND c.standard_id = @standard_id
ORDER BY r.clause_id, r.reviewed_at DESC;

-- name: InsertQualityKPIDefinition :exec
INSERT INTO quality.kpi_definition (
    definition_id, tenant_id, code, name, revision, numerator, denominator,
    unit, target_permille, direction, frequency, owner_id, effective_from,
    created_at, created_by
) VALUES (
    @definition_id, @tenant_id, @code, @name, @revision, @numerator,
    @denominator, @unit, @target_permille, @direction, @frequency, @owner_id,
    @effective_from, @created_at, @created_by
);

-- name: SupersedeQualityKPIDefinition :exec
UPDATE quality.kpi_definition
SET superseded_at = @superseded_at
WHERE tenant_id = @tenant_id AND code = @code AND revision < @revision
  AND superseded_at IS NULL;

-- name: GetQualityKPIDefinition :one
SELECT * FROM quality.kpi_definition
WHERE tenant_id = @tenant_id AND definition_id = @definition_id;

-- name: GetQualityCurrentKPIDefinition :one
SELECT * FROM quality.kpi_definition
WHERE tenant_id = @tenant_id AND code = @code
ORDER BY revision DESC
LIMIT 1;

-- name: ListQualityKPIDefinitions :many
SELECT DISTINCT ON (code) *
FROM quality.kpi_definition
WHERE tenant_id = @tenant_id
ORDER BY code, revision DESC;

-- name: InsertQualityKPIValue :exec
INSERT INTO quality.kpi_value (
    value_id, tenant_id, definition_id, code, revision, period_from,
    period_to, numerator, denominator, permille, unanswerable, source_note,
    recorded_at, recorded_by
) VALUES (
    @value_id, @tenant_id, @definition_id, @code, @revision, @period_from,
    @period_to, @numerator, @denominator, @permille, @unanswerable,
    @source_note, @recorded_at, @recorded_by
);

-- name: ListQualityKPIValues :many
SELECT * FROM quality.kpi_value
WHERE tenant_id = @tenant_id AND code = @code
  AND period_to > @from_at AND period_from < @to_at
ORDER BY period_from;

-- name: InsertQualityComplaint :exec
INSERT INTO quality.complaint (
    complaint_id, tenant_id, reference, kind, complainant_ref, patient_id,
    encounter_id, category, department, facility_id, channel, detail,
    acknowledge_by, resolve_by, state, received_at, received_by
) VALUES (
    @complaint_id, @tenant_id, @reference, @kind, @complainant_ref,
    @patient_id, @encounter_id, @category, @department, @facility_id,
    @channel, @detail, @acknowledge_by, @resolve_by, @state,
    @received_at, @received_by
);

-- name: GetQualityComplaint :one
SELECT * FROM quality.complaint
WHERE tenant_id = @tenant_id AND complaint_id = @complaint_id;

-- name: UpdateQualityComplaint :execrows
UPDATE quality.complaint
SET acknowledged_at = @acknowledged_at, acknowledged_by = @acknowledged_by,
    state = @state, outcome = @outcome, resolution = @resolution,
    closure_reason = @closure_reason, escalated = @escalated,
    escalated_at = @escalated_at, closed_at = @closed_at,
    closed_by = @closed_by, version = version + 1
WHERE tenant_id = @tenant_id AND complaint_id = @complaint_id
  AND version = @expected_version;

-- name: ListQualityComplaints :many
SELECT * FROM quality.complaint
WHERE tenant_id = @tenant_id
  AND (@category::text = '' OR category = @category)
  AND (NOT @open_only::boolean OR state <> 'closed')
ORDER BY received_at DESC
LIMIT @row_limit;

-- name: InsertQualityMortalityReview :exec
INSERT INTO quality.mortality_review (
    review_id, tenant_id, patient_id, encounter_id, died_at, committee_id,
    state, opened_at, opened_by
) VALUES (
    @review_id, @tenant_id, @patient_id, @encounter_id, @died_at,
    @committee_id, @state, @opened_at, @opened_by
);

-- name: GetQualityMortalityReview :one
SELECT * FROM quality.mortality_review
WHERE tenant_id = @tenant_id AND review_id = @review_id;

-- name: UpdateQualityMortalityReview :execrows
UPDATE quality.mortality_review
SET meeting_id = @meeting_id, classification = @classification,
    findings = @findings, learning_points = @learning_points,
    capa_ids = @capa_ids, state = @state,
    completed_at = @completed_at, completed_by = @completed_by,
    version = version + 1
WHERE tenant_id = @tenant_id AND review_id = @review_id
  AND version = @expected_version;

-- name: ListQualityMortalityReviews :many
SELECT * FROM quality.mortality_review
WHERE tenant_id = @tenant_id
  AND (NOT @open_only::boolean OR state = 'open')
  AND died_at >= @from_at AND died_at < @to_at
ORDER BY died_at DESC
LIMIT @row_limit;
