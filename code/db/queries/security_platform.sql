-- Security platform queries.

-- name: NextSecurityEventSequence :one
-- The chain is per tenant, so one tenant's volume cannot renumber another's.
SELECT COALESCE(MAX(sequence), 0) + 1 FROM security_platform.security_event
WHERE tenant_id = @tenant_id;

-- name: GetLastSecurityEventHash :one
SELECT entry_hash FROM security_platform.security_event
WHERE tenant_id = @tenant_id
ORDER BY sequence DESC
LIMIT 1;

-- name: InsertSecurityEvent :exec
INSERT INTO security_platform.security_event (
    event_id, tenant_id, sequence, event_class, severity, actor_id,
    resource_type, resource_id, outcome, detail, correlation_id, occurred_at,
    entry_hash, previous_hash
) VALUES (
    @event_id, @tenant_id, @sequence, @event_class, @severity, @actor_id,
    @resource_type, @resource_id, @outcome, @detail, @correlation_id, @occurred_at,
    @entry_hash, @previous_hash
);

-- name: ListSecurityEvents :many
SELECT event_id, tenant_id, sequence, event_class, severity, actor_id,
       resource_type, resource_id, outcome, detail, correlation_id, occurred_at,
       entry_hash, previous_hash
FROM security_platform.security_event
WHERE tenant_id = @tenant_id
ORDER BY sequence;

-- name: InsertExportRequest :exec
INSERT INTO security_platform.export_request (
    export_id, tenant_id, requested_by, justification, data_class, scope,
    status, step_up_reference, watermark, created_at, updated_at, version
) VALUES (
    @export_id, @tenant_id, @requested_by, @justification, @data_class, @scope,
    @status, @step_up_reference, @watermark, @created_at, @updated_at, 1
);

-- name: GetExportRequest :one
SELECT export_id, tenant_id, requested_by, justification, data_class, scope,
       status, step_up_reference, approved_by, approved_at, object_key,
       object_sha256, manifest, row_count, watermark, grant_expires_at,
       created_at, updated_at, version
FROM security_platform.export_request
WHERE tenant_id = @tenant_id AND export_id = @export_id;

-- name: ApproveExportRequest :execrows
-- Only a pending request may be approved, and the approver is recorded. The
-- predicate is what stops a second approval from overwriting the first.
UPDATE security_platform.export_request
SET status = 'approved', approved_by = @approved_by, approved_at = @approved_at,
    updated_at = @approved_at, version = version + 1
WHERE export_id = @export_id AND tenant_id = @tenant_id
  AND status = 'pending_approval';

-- name: RejectExportRequest :execrows
UPDATE security_platform.export_request
SET status = 'rejected', approved_by = @approved_by, approved_at = @approved_at,
    updated_at = @approved_at, version = version + 1
WHERE export_id = @export_id AND tenant_id = @tenant_id
  AND status = 'pending_approval';

-- name: CompleteExportRequest :execrows
UPDATE security_platform.export_request
SET status = 'completed', object_key = @object_key, object_sha256 = @object_sha256,
    manifest = @manifest, row_count = @row_count, grant_expires_at = @grant_expires_at,
    updated_at = @updated_at, version = version + 1
WHERE export_id = @export_id AND tenant_id = @tenant_id AND status = 'approved';

-- name: InsertExportDownload :exec
INSERT INTO security_platform.export_download (
    download_id, export_id, tenant_id, downloaded_by, correlation_id, occurred_at
) VALUES (@download_id, @export_id, @tenant_id, @downloaded_by, @correlation_id, @occurred_at);

-- name: CountExportDownloads :one
SELECT count(*) FROM security_platform.export_download
WHERE tenant_id = @tenant_id AND export_id = @export_id;

-- name: InsertRetentionClass :exec
INSERT INTO security_platform.retention_class (
    retention_class_id, tenant_id, name, data_class, retain_days,
    archive_after_days, created_at, updated_at
) VALUES (
    @retention_class_id, @tenant_id, @name, @data_class, @retain_days,
    @archive_after_days, @created_at, @updated_at
);

-- name: GetRetentionClass :one
SELECT retention_class_id, tenant_id, name, data_class, retain_days,
       archive_after_days, created_at, updated_at
FROM security_platform.retention_class
WHERE tenant_id = @tenant_id AND name = @name;

-- name: PlaceLegalHold :execrows
INSERT INTO security_platform.legal_hold (
    hold_id, tenant_id, resource_type, resource_id, reason, placed_by, placed_at
) VALUES (@hold_id, @tenant_id, @resource_type, @resource_id, @reason, @placed_by, @placed_at)
ON CONFLICT DO NOTHING;

-- name: ReleaseLegalHold :execrows
UPDATE security_platform.legal_hold
SET released_by = @released_by, released_at = @released_at
WHERE tenant_id = @tenant_id AND resource_type = @resource_type
  AND resource_id = @resource_id AND released_at IS NULL;

-- name: IsUnderLegalHold :one
SELECT EXISTS (
    SELECT 1 FROM security_platform.legal_hold
    WHERE tenant_id = @tenant_id AND resource_type = @resource_type
      AND resource_id = @resource_id AND released_at IS NULL
);

-- name: ListHeldResourceIDs :many
SELECT resource_id FROM security_platform.legal_hold
WHERE tenant_id = @tenant_id AND resource_type = @resource_type AND released_at IS NULL;

-- name: InsertPrivacyNotice :exec
INSERT INTO security_platform.privacy_notice (
    notice_id, tenant_id, version, locale, body_uri, effective_from, created_at
) VALUES (@notice_id, @tenant_id, @version, @locale, @body_uri, @effective_from, @created_at);

-- name: InsertProcessingPurpose :exec
INSERT INTO security_platform.processing_purpose (
    purpose_id, tenant_id, code, description, withdrawable, lawful_basis, created_at
) VALUES (@purpose_id, @tenant_id, @code, @description, @withdrawable, @lawful_basis, @created_at);

-- name: GetProcessingPurpose :one
SELECT purpose_id, tenant_id, code, description, withdrawable, lawful_basis, created_at
FROM security_platform.processing_purpose
WHERE tenant_id = @tenant_id AND code = @code;

-- name: InsertPurposeGrant :exec
INSERT INTO security_platform.purpose_grant (
    grant_id, tenant_id, subject_ref, purpose_code, notice_version, granted,
    recorded_by, occurred_at
) VALUES (
    @grant_id, @tenant_id, @subject_ref, @purpose_code, @notice_version, @granted,
    @recorded_by, @occurred_at
);

-- name: GetCurrentPurposeGrant :one
-- The latest row wins; earlier rows stay for the history of what was agreed.
SELECT grant_id, tenant_id, subject_ref, purpose_code, notice_version, granted,
       recorded_by, occurred_at
FROM security_platform.purpose_grant
WHERE tenant_id = @tenant_id AND subject_ref = @subject_ref AND purpose_code = @purpose_code
ORDER BY occurred_at DESC, grant_id DESC
LIMIT 1;

-- name: CountPurposeGrants :one
SELECT count(*) FROM security_platform.purpose_grant
WHERE tenant_id = @tenant_id AND subject_ref = @subject_ref AND purpose_code = @purpose_code;

-- name: InsertSubjectRequest :exec
INSERT INTO security_platform.subject_request (
    request_id, tenant_id, subject_ref, request_type, status, received_at,
    due_at, created_at, updated_at, version
) VALUES (
    @request_id, @tenant_id, @subject_ref, @request_type, @status, @received_at,
    @due_at, @created_at, @updated_at, 1
);

-- name: GetSubjectRequest :one
SELECT request_id, tenant_id, subject_ref, request_type, status, received_at,
       due_at, reviewer, decision, decision_basis, evidence_ref, closed_at,
       created_at, updated_at, version
FROM security_platform.subject_request
WHERE tenant_id = @tenant_id AND request_id = @request_id;

-- name: DecideSubjectRequest :execrows
UPDATE security_platform.subject_request
SET status = @status, reviewer = @reviewer, decision = @decision,
    decision_basis = @decision_basis, evidence_ref = @evidence_ref,
    closed_at = @closed_at, updated_at = @updated_at, version = version + 1
WHERE request_id = @request_id AND tenant_id = @tenant_id
  AND status NOT IN ('fulfilled', 'refused');

-- Emergency access (SRS-SEC-014).

-- name: InsertEmergencyGrant :exec
-- The partial unique index on (tenant_id, subject_id) WHERE status = 'active'
-- is what refuses a second concurrent activation; this insert relies on it
-- rather than on a prior SELECT, which would race.
INSERT INTO security_platform.emergency_grant (
    grant_id, tenant_id, subject_id, facility_id, incident_ref, justification,
    permissions, status, activated_at, expires_at, correlation_id
) VALUES (
    @grant_id, @tenant_id, @subject_id, @facility_id, @incident_ref, @justification,
    @permissions, @status, @activated_at, @expires_at, @correlation_id
);

-- name: GetEmergencyGrant :one
SELECT grant_id, tenant_id, subject_id, facility_id, incident_ref, justification,
       permissions, status, activated_at, expires_at, closed_at,
       accessed_resources, reviewed_by, reviewed_at, review_note, correlation_id
FROM security_platform.emergency_grant
WHERE tenant_id = @tenant_id AND grant_id = @grant_id;

-- name: GetActiveEmergencyGrant :one
SELECT grant_id, tenant_id, subject_id, facility_id, incident_ref, justification,
       permissions, status, activated_at, expires_at, closed_at,
       accessed_resources, reviewed_by, reviewed_at, review_note, correlation_id
FROM security_platform.emergency_grant
WHERE tenant_id = @tenant_id AND subject_id = @subject_id AND status = 'active';

-- name: RecordEmergencyAccess :execrows
-- array_append only when absent, so a repeated read of the same record does not
-- inflate the list the reviewer reads. The expires_at predicate means a grant
-- past its window cannot record access even if the sweeper has not run.
UPDATE security_platform.emergency_grant
SET accessed_resources = CASE
        WHEN @resource_ref::text = ANY (accessed_resources) THEN accessed_resources
        ELSE array_append(accessed_resources, @resource_ref::text)
    END
WHERE tenant_id = @tenant_id AND grant_id = @grant_id
  AND status = 'active' AND expires_at > @now;

-- name: CloseEmergencyGrant :execrows
UPDATE security_platform.emergency_grant
SET status = 'closed', closed_at = @closed_at
WHERE tenant_id = @tenant_id AND grant_id = @grant_id AND status = 'active';

-- name: ExpireEmergencyGrants :execrows
-- Idempotent by construction: only rows still 'active' are touched, so the
-- at-least-once sweeper cannot move closed_at on a second pass.
UPDATE security_platform.emergency_grant
SET status = 'expired', closed_at = expires_at
WHERE status = 'active' AND expires_at <= @now;

-- name: ReviewEmergencyGrant :execrows
-- "Ended" is a question about the clock, not about the sweeper: a grant whose
-- window has passed is reviewable even while the row still reads 'active',
-- so a reviewer working promptly after expiry is not told to come back later.
-- Same rule as RecordEmergencyAccess, which refuses on the same predicate.
UPDATE security_platform.emergency_grant
SET status = @status, reviewed_by = @reviewed_by, reviewed_at = @reviewed_at,
    review_note = @review_note
WHERE tenant_id = @tenant_id AND grant_id = @grant_id
  AND (status IN ('closed', 'expired') OR (status = 'active' AND expires_at <= @now))
  AND subject_id <> @reviewed_by;

-- name: ListGrantsAwaitingReview :many
SELECT grant_id, tenant_id, subject_id, facility_id, incident_ref, justification,
       permissions, status, activated_at, expires_at, closed_at,
       accessed_resources, reviewed_by, reviewed_at, review_note, correlation_id
FROM security_platform.emergency_grant
WHERE tenant_id = @tenant_id AND status IN ('closed', 'expired')
ORDER BY closed_at ASC, grant_id ASC
LIMIT @page_size;

-- Downtime episodes (SRS-SEC-014).

-- name: InsertDowntimeEpisode :exec
INSERT INTO security_platform.downtime_episode (
    episode_id, tenant_id, facility_id, planned, declared_by, declared_at,
    reason, status, correlation_id
) VALUES (
    @episode_id, @tenant_id, @facility_id, @planned, @declared_by, @declared_at,
    @reason, @status, @correlation_id
);

-- name: GetDowntimeEpisode :one
SELECT episode_id, tenant_id, facility_id, planned, declared_by, declared_at,
       reason, restored_at, status, closed_by, closed_at, correlation_id
FROM security_platform.downtime_episode
WHERE tenant_id = @tenant_id AND episode_id = @episode_id;

-- name: RestoreDowntimeEpisode :execrows
UPDATE security_platform.downtime_episode
SET status = 'recovering', restored_at = @restored_at
WHERE tenant_id = @tenant_id AND episode_id = @episode_id AND status = 'open';

-- name: CloseDowntimeEpisode :execrows
-- The NOT EXISTS clause is the control, not a convenience: an episode closed
-- with unreconciled actions means paper that never reaches the chart. Putting
-- it in the statement means a caller cannot close one by skipping the domain.
UPDATE security_platform.downtime_episode e
SET status = 'reconciled', closed_by = @closed_by, closed_at = @closed_at
WHERE e.tenant_id = @tenant_id AND e.episode_id = @episode_id AND e.status = 'recovering'
  AND NOT EXISTS (
      SELECT 1 FROM security_platform.downtime_action a
      WHERE a.episode_id = e.episode_id AND a.reconciled_at IS NULL
  );

-- name: InsertDowntimeAction :execrows
-- ON CONFLICT DO NOTHING: a ward terminal that loses its response retries, and
-- duplicating a medication administration would be a clinical incident.
INSERT INTO security_platform.downtime_action (
    action_id, episode_id, tenant_id, performed_by, performed_at, action_type,
    subject_ref, summary, paper_form_ref
) VALUES (
    @action_id, @episode_id, @tenant_id, @performed_by, @performed_at, @action_type,
    @subject_ref, @summary, @paper_form_ref
)
ON CONFLICT (action_id) DO NOTHING;

-- name: ReconcileDowntimeAction :execrows
UPDATE security_platform.downtime_action
SET reconciled_by = @reconciled_by, reconciled_at = @reconciled_at,
    resource_ref = @resource_ref
WHERE tenant_id = @tenant_id AND episode_id = @episode_id AND action_id = @action_id
  AND reconciled_at IS NULL;

-- name: ListDowntimeActions :many
SELECT action_id, episode_id, tenant_id, performed_by, performed_at, action_type,
       subject_ref, summary, paper_form_ref, reconciled_by, reconciled_at, resource_ref
FROM security_platform.downtime_action
WHERE tenant_id = @tenant_id AND episode_id = @episode_id
ORDER BY performed_at ASC, action_id ASC;

-- name: CountUnreconciledActions :one
SELECT count(*) FROM security_platform.downtime_action
WHERE tenant_id = @tenant_id AND episode_id = @episode_id AND reconciled_at IS NULL;
