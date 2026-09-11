-- Platform data queries: outbox, inbox, audit.

-- name: InsertOutboxEvent :exec
INSERT INTO platform_data.outbox_event (
    event_id, event_type, schema_version, occurred_at, tenant_id, source,
    aggregate_type, aggregate_id, correlation_id, causation_id, actor, payload
) VALUES (
    @event_id, @event_type, @schema_version, @occurred_at, @tenant_id, @source,
    @aggregate_type, @aggregate_id, @correlation_id, @causation_id, @actor, @payload
);

-- name: ClaimUnpublishedEvents :many
-- SKIP LOCKED lets several publisher replicas drain the outbox concurrently
-- without blocking each other or double-claiming a row.
SELECT event_id, event_type, schema_version, occurred_at, tenant_id, source,
       aggregate_type, aggregate_id, correlation_id, causation_id, actor, payload
FROM platform_data.outbox_event
WHERE published_at IS NULL
ORDER BY occurred_at, event_id
LIMIT @page_limit
FOR UPDATE SKIP LOCKED;

-- name: MarkEventPublished :exec
UPDATE platform_data.outbox_event
SET published_at = @published_at, attempts = attempts + 1
WHERE event_id = @event_id;

-- name: RecordPublishFailure :exec
UPDATE platform_data.outbox_event
SET attempts = attempts + 1, last_error = @last_error
WHERE event_id = @event_id;

-- name: CountUnpublishedEvents :one
SELECT count(*) FROM platform_data.outbox_event WHERE published_at IS NULL;

-- name: ListOutboxEventsByTenant :many
SELECT event_id, event_type, schema_version, occurred_at, tenant_id, source,
       aggregate_type, aggregate_id, correlation_id, causation_id, actor, payload
FROM platform_data.outbox_event
WHERE tenant_id = @tenant_id
ORDER BY occurred_at, event_id;

-- name: TryConsumeInbox :execrows
-- Returns 1 the first time a consumer sees an event and 0 on every redelivery,
-- which is the whole deduplication contract (Domain/Data spec §8.2).
INSERT INTO platform_data.inbox_message (consumer, event_id, tenant_id, processed_at)
VALUES (@consumer, @event_id, @tenant_id, @processed_at)
ON CONFLICT (consumer, event_id) DO NOTHING;

-- name: InsertAuditRecord :exec
INSERT INTO platform_data.audit_record (
    audit_id, tenant_id, actor_id, action, resource_type, resource_id,
    outcome, reason, purpose_of_use, break_glass, correlation_id, request_id,
    occurred_at, context
) VALUES (
    @audit_id, @tenant_id, @actor_id, @action, @resource_type, @resource_id,
    @outcome, @reason, @purpose_of_use, @break_glass, @correlation_id, @request_id,
    @occurred_at, @context
);

-- name: ListAuditRecordsByTenant :many
SELECT audit_id, tenant_id, actor_id, action, resource_type, resource_id,
       outcome, reason, purpose_of_use, break_glass, correlation_id, request_id,
       occurred_at, context
FROM platform_data.audit_record
WHERE tenant_id = @tenant_id
ORDER BY occurred_at DESC, audit_id
LIMIT @page_limit;
