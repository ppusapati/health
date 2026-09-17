-- name: UpsertEscalationMatrix :one
INSERT INTO platform_escalation.matrix (
    matrix_id, tenant_id, facility_id, kind, created_at, updated_at
) VALUES ($1, $2, $3, $4, $5, $5)
ON CONFLICT (tenant_id, facility_id, kind) DO UPDATE
    SET updated_at = EXCLUDED.updated_at
RETURNING *;

-- name: DeleteEscalationRungs :exec
DELETE FROM platform_escalation.rung WHERE matrix_id = $1;

-- name: InsertEscalationRung :exec
INSERT INTO platform_escalation.rung (matrix_id, level, note)
VALUES ($1, $2, $3);

-- name: InsertEscalationRecipient :exec
INSERT INTO platform_escalation.rung_recipient (
    matrix_id, level, ordinal, user_id, role, facility_id
) VALUES ($1, $2, $3, $4, $5, $6);

-- name: GetEscalationMatrix :one
-- Facility first, then the tenant-wide fallback. Ordered rather than two
-- queries so a facility matrix and a tenant matrix cannot both be read and
-- then combined by accident.
SELECT * FROM platform_escalation.matrix
WHERE tenant_id = $1 AND kind = $2 AND facility_id IN ($3, '')
ORDER BY facility_id DESC
LIMIT 1;

-- name: ListEscalationRungs :many
SELECT r.level, r.note,
       p.ordinal, p.user_id, p.role, p.facility_id
FROM platform_escalation.rung r
LEFT JOIN platform_escalation.rung_recipient p
    ON p.matrix_id = r.matrix_id AND p.level = r.level
WHERE r.matrix_id = $1
ORDER BY r.level, p.ordinal;

-- name: RaiseEscalationNotice :one
-- Idempotent on the subject: a retry, a replay or a restart re-running the
-- code that raised this must produce one notice, not two chains racing each
-- other to the same consultant. DO NOTHING would return no row and leave the
-- caller unable to tell a duplicate from a failure, so the conflict updates
-- nothing observable and returns what is already there.
INSERT INTO platform_escalation.notice (
    notice_id, tenant_id, subject_kind, subject_id, patient_id, facility_id,
    summary, state, level, raised_at, last_escalated_at, updated_at
) VALUES ($1, $2, $3, $4, $5, $6, $7, 'pending', 0, $8, $8, $8)
ON CONFLICT (tenant_id, subject_kind, subject_id) DO UPDATE
    SET updated_at = platform_escalation.notice.updated_at
RETURNING *;

-- name: GetEscalationNotice :one
SELECT * FROM platform_escalation.notice
WHERE tenant_id = $1 AND notice_id = $2;

-- name: GetEscalationNoticeBySubject :one
SELECT * FROM platform_escalation.notice
WHERE tenant_id = $1 AND subject_kind = $2 AND subject_id = $3;

-- name: ClaimDueEscalations :many
-- What the driver sweeps.
--
-- `delivered` is what makes a notice self-driving. Raising happens inside the
-- transaction that made the thing worth escalating; delivering happens after
-- that transaction commits, because a consultant woken for a transaction that
-- then rolled back is a consultant who stops answering. Between those two
-- moments the process can die — and if the sweep could not tell a notice that
-- has been told to somebody from one that never was, that death would silently
-- eat the first notification. Which is precisely what SRS-OPSNFR-003 is about.
--
-- FOR UPDATE SKIP LOCKED for the same reason the outbox uses it: two replicas
-- both running the driver must not both escalate the same notice, and a
-- replica that dies mid-sweep must not hold the rest of the queue. The due
-- calculation is in Go, not here, so the policy can change without a migration
-- -- this returns the pending notices that could plausibly be due and the
-- caller decides.
SELECT n.*,
       EXISTS (
           SELECT 1 FROM platform_escalation.delivery d
           WHERE d.notice_id = n.notice_id
       ) AS delivered
FROM platform_escalation.notice n
WHERE n.state = 'pending' AND n.last_escalated_at <= $1
ORDER BY n.last_escalated_at
LIMIT $2
FOR UPDATE OF n SKIP LOCKED;

-- name: UpdateEscalationNotice :exec
UPDATE platform_escalation.notice
SET state = $3,
    level = $4,
    last_escalated_at = $5,
    acknowledged_by = $6,
    acknowledged_at = $7,
    closed_reason = $8,
    updated_at = $9
WHERE tenant_id = $1 AND notice_id = $2;

-- name: InsertEscalationDelivery :exec
INSERT INTO platform_escalation.delivery (
    delivery_id, notice_id, level, user_id, role, facility_id,
    channel, error, delivered_at
) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9);

-- name: ListEscalationDeliveries :many
SELECT * FROM platform_escalation.delivery
WHERE notice_id = $1
ORDER BY delivered_at, delivery_id;

-- name: ListOpenEscalationsForRecipient :many
-- What a clinician's task inbox shows: the notices delivered to them that
-- nobody has acknowledged yet.
SELECT DISTINCT n.* FROM platform_escalation.notice n
JOIN platform_escalation.delivery d ON d.notice_id = n.notice_id
WHERE n.tenant_id = $1 AND n.state = 'pending' AND d.user_id = $2
ORDER BY n.raised_at;
