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
