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

-- Event delivery (ADR-005).

-- name: InsertSubscription :exec
INSERT INTO platform_data.subscription (
    subscription_id, consumer, event_types, tenant_id, enabled, max_attempts,
    created_at, updated_at
) VALUES (
    @subscription_id, @consumer, @event_types, @tenant_id, @enabled, @max_attempts,
    @created_at, @updated_at
);

-- name: GetSubscriptionByConsumer :one
SELECT subscription_id, consumer, event_types, tenant_id, enabled, max_attempts,
       created_at, updated_at
FROM platform_data.subscription
WHERE consumer = @consumer;

-- name: ListEnabledSubscriptions :many
SELECT subscription_id, consumer, event_types, tenant_id, enabled, max_attempts,
       created_at, updated_at
FROM platform_data.subscription
WHERE enabled
ORDER BY consumer;

-- name: FanOutEvent :execrows
-- Creates one delivery per interested subscription, in one statement.
--
-- ON CONFLICT DO NOTHING against the (subscription, event) unique index is what
-- makes the fan-out idempotent: a publisher that crashes part-way and re-runs
-- produces the same rows rather than duplicates. Filtering happens here rather
-- than in the application so a subscription can never be missed by a caller
-- that forgot to check its filters.
INSERT INTO platform_data.event_delivery (
    delivery_id, subscription_id, event_id, tenant_id, event_type, occurred_at,
    state, visible_at, created_at, updated_at
)
SELECT
    -- A random id is enough. Idempotency comes from the unique index on
    -- (subscription_id, event_id) below, not from the delivery id being
    -- derivable — deriving it was a second mechanism for the same guarantee.
    gen_random_uuid(),
    s.subscription_id, @event_id, @tenant_id, @event_type, @occurred_at,
    'pending', @occurred_at, @now, @now
FROM platform_data.subscription s
WHERE s.enabled
  AND (cardinality(s.event_types) = 0 OR @event_type = ANY (s.event_types))
  AND (s.tenant_id IS NULL OR s.tenant_id = @tenant_id)
ON CONFLICT (subscription_id, event_id) DO NOTHING;

-- name: ClaimDeliveries :many
-- FOR UPDATE SKIP LOCKED lets many consumer replicas drain one subscription
-- concurrently without double-claiming and without blocking one another.
--
-- The predicate reclaims an expired lease as well as pending work, so a
-- consumer that crashed mid-message does not strand it: the lease lapses and
-- the next poll picks it up. That is also why every consumer must be
-- idempotent — the crashed one may have finished the side effect before dying.
UPDATE platform_data.event_delivery d
SET state = 'in_flight',
    attempts = d.attempts + 1,
    leased_until = @leased_until,
    leased_by = @leased_by,
    updated_at = @now
FROM (
    SELECT c.delivery_id
    FROM platform_data.event_delivery c
    WHERE c.subscription_id = @subscription_id
      AND c.state IN ('pending', 'in_flight')
      AND c.visible_at <= @now
      AND (c.state = 'pending' OR c.leased_until IS NULL OR c.leased_until <= @now)
    ORDER BY c.occurred_at, c.delivery_id
    LIMIT @batch_size
    FOR UPDATE SKIP LOCKED
) claimed
WHERE d.delivery_id = claimed.delivery_id
RETURNING d.delivery_id, d.subscription_id, d.event_id, d.tenant_id,
          d.event_type, d.occurred_at, d.attempts, d.state;

-- name: AckDelivery :execrows
UPDATE platform_data.event_delivery
SET state = 'delivered', leased_until = NULL, leased_by = '',
    last_error = '', updated_at = @now
WHERE delivery_id = @delivery_id AND state = 'in_flight';

-- name: NackDelivery :execrows
-- Failure with backoff, or dead-lettering once the subscription's patience runs
-- out. Both outcomes in one statement so a consumer cannot leave a message
-- in_flight by crashing between deciding and writing.
UPDATE platform_data.event_delivery d
SET state = CASE
        WHEN d.attempts >= s.max_attempts THEN 'dead_lettered'
        ELSE 'pending'
    END,
    visible_at = CASE
        WHEN d.attempts >= s.max_attempts THEN d.visible_at
        ELSE @retry_at
    END,
    leased_until = NULL, leased_by = '',
    last_error = @last_error, updated_at = @now
FROM platform_data.subscription s
WHERE d.subscription_id = s.subscription_id
  AND d.delivery_id = @delivery_id AND d.state = 'in_flight';

-- name: CountPendingDeliveries :one
SELECT count(*) FROM platform_data.event_delivery
WHERE subscription_id = @subscription_id AND state IN ('pending', 'in_flight');

-- name: ListDeadLetters :many
SELECT delivery_id, subscription_id, event_id, tenant_id, event_type,
       occurred_at, attempts, last_error, updated_at
FROM platform_data.event_delivery
WHERE state = 'dead_lettered'
  -- sqlc.narg, not a plain parameter: a plain one types as non-nullable and
  -- the "all tenants" case becomes unexpressible.
  AND (sqlc.narg('tenant_id')::uuid IS NULL OR tenant_id = sqlc.narg('tenant_id')::uuid)
ORDER BY updated_at DESC, delivery_id
LIMIT @page_size;

-- name: ReplayDeadLetter :execrows
-- Returns a dead letter to the queue with its attempt count reset, so an
-- operator who fixed the consumer can retry without editing rows by hand.
UPDATE platform_data.event_delivery
SET state = 'pending', attempts = 0, visible_at = @now,
    leased_until = NULL, leased_by = '', last_error = '', updated_at = @now
WHERE delivery_id = @delivery_id AND state = 'dead_lettered';

-- name: GetOutboxEvent :one
SELECT event_id, event_type, schema_version, occurred_at, published_at,
       tenant_id, source, aggregate_type, aggregate_id, correlation_id,
       causation_id, actor, payload, attempts, last_error
FROM platform_data.outbox_event
WHERE event_id = @event_id;
