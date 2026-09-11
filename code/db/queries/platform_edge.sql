-- Hospital edge registry queries (P0-13).

-- name: InsertEdgeNode :exec
INSERT INTO platform_edge.node (
    node_id, tenant_id, facility_id, display_name, status, created_at, updated_at, version
) VALUES (@node_id, @tenant_id, @facility_id, @display_name, @status, @created_at, @updated_at, 1);

-- name: GetEdgeNode :one
SELECT node_id, tenant_id, facility_id, display_name, status,
       credential_fingerprint, enrolled_at, last_seen_at, created_at, updated_at, version
FROM platform_edge.node
WHERE tenant_id = @tenant_id AND node_id = @node_id;

-- name: SetEdgeNodeStatus :execrows
UPDATE platform_edge.node
SET status = @status, updated_at = @updated_at, version = version + 1
WHERE node_id = @node_id AND tenant_id = @tenant_id;

-- name: TouchEdgeNode :exec
UPDATE platform_edge.node
SET last_seen_at = @last_seen_at
WHERE node_id = @node_id AND tenant_id = @tenant_id;

-- name: InsertEnrollmentToken :exec
INSERT INTO platform_edge.enrollment_token (token_hash, node_id, tenant_id, expires_at, created_at)
VALUES (@token_hash, @node_id, @tenant_id, @expires_at, @created_at);

-- name: ConsumeEnrollmentToken :execrows
-- Single-use and time-bounded, enforced in the predicate rather than in
-- application code: two nodes racing the same token cannot both match.
UPDATE platform_edge.enrollment_token
SET consumed_at = @consumed_at
WHERE token_hash = @token_hash
  AND consumed_at IS NULL
  AND expires_at > @now;

-- name: GetEnrollmentTokenNode :one
SELECT node_id, tenant_id FROM platform_edge.enrollment_token
WHERE token_hash = @token_hash;

-- name: EnrollEdgeNode :one
UPDATE platform_edge.node
SET status = 'enrolled',
    credential_fingerprint = @credential_fingerprint,
    enrolled_at = @enrolled_at,
    updated_at = @updated_at,
    version = version + 1
WHERE node_id = @node_id AND tenant_id = @tenant_id AND status = 'pending'
RETURNING node_id, tenant_id, facility_id, display_name, status,
          credential_fingerprint, enrolled_at, last_seen_at, created_at, updated_at, version;

-- name: TryInsertForwardedOperation :execrows
-- Returns 1 for a new operation and 0 for a redelivery, which is what makes the
-- edge's blind retry safe.
INSERT INTO platform_edge.forwarded_operation (
    node_id, operation_id, tenant_id, operation_type, payload, occurred_at, received_at, outcome
) VALUES (
    @node_id, @operation_id, @tenant_id, @operation_type, @payload, @occurred_at, @received_at, @outcome
)
ON CONFLICT (node_id, operation_id) DO NOTHING;

-- name: InsertForwardedOperation :exec
INSERT INTO platform_edge.forwarded_operation (
    node_id, operation_id, tenant_id, operation_type, payload, occurred_at,
    received_at, outcome, reject_reason
) VALUES (
    @node_id, @operation_id, @tenant_id, @operation_type, @payload, @occurred_at,
    @received_at, @outcome, @reject_reason
)
ON CONFLICT (node_id, operation_id) DO NOTHING;

-- name: ListForwardedOperations :many
SELECT node_id, operation_id, tenant_id, operation_type, payload, occurred_at,
       received_at, outcome, reject_reason
FROM platform_edge.forwarded_operation
WHERE tenant_id = @tenant_id
ORDER BY occurred_at, operation_id;
