-- 0010 Event delivery: subscriptions, per-consumer queues, dead letters.
--
-- Closes the storage half of ADR-005. The outbox (0003) is the producer side —
-- it guarantees no state change without its event. This is the consumer side:
-- who is listening, what each of them still owes, and what to do with a message
-- that cannot be processed.
--
-- The central design choice is fan-out on write. Each event becomes one
-- delivery row per interested subscription, rather than each subscription
-- tracking a cursor over a single log.
--
-- Fan-out on read is cheaper in storage and has a property this system cannot
-- accept: head-of-line blocking. One poison message stalls that subscription's
-- cursor, and every later event waits behind it. In a hospital that means one
-- broken consumer stops medication events reaching the others — the failure is
-- in the wrong place and the blast radius is everyone. Per-consumer rows cost
-- N rows per event and buy independent retry, independent dead-lettering, and
-- a slow consumer that inconveniences only itself.
--
-- Trace: SRS-API-008, SRS-PLT-010, SRS-NFR-003.
--
-- Rollback: drops subscriptions and undelivered work. Events themselves survive
--   in the outbox, so recovery is re-creating subscriptions and re-fanning from
--   the outbox rather than data loss — but anything already acknowledged will
--   be redelivered, which is why every consumer deduplicates on event_id.
-- Reconciliation: after a restore, re-run the fan-out for events whose
--   occurred_at is later than the newest delivery row. Consumers are
--   at-least-once and idempotent, so over-delivering is safe and
--   under-delivering is not.

CREATE TABLE platform_data.subscription (
    subscription_id uuid      PRIMARY KEY,
    -- The consumer group name. Two processes sharing a name share the work;
    -- two names each get their own copy. This is the only knob that decides
    -- competing-consumer versus fan-out, and it is deliberately the same knob
    -- every broker uses, so the mental model survives a future migration.
    consumer       text        NOT NULL,
    -- Event types this subscription wants. Empty means every type, which is
    -- what a projection rebuilding a search index needs and what a targeted
    -- consumer must not have.
    event_types    text[]      NOT NULL DEFAULT '{}',
    -- NULL means every tenant. A per-tenant subscription exists for the case
    -- where one customer's data must not leave a region.
    tenant_id      uuid,
    enabled        boolean     NOT NULL DEFAULT true,
    -- How many attempts before a message is dead-lettered. Per subscription,
    -- because a consumer that calls a flaky external system deserves more
    -- patience than one doing a local write.
    max_attempts   integer     NOT NULL DEFAULT 5 CHECK (max_attempts > 0),
    created_at     timestamptz NOT NULL,
    updated_at     timestamptz NOT NULL
);

CREATE UNIQUE INDEX subscription_consumer_key ON platform_data.subscription (consumer);

CREATE TABLE platform_data.event_delivery (
    delivery_id    uuid        PRIMARY KEY,
    subscription_id uuid       NOT NULL
        REFERENCES platform_data.subscription (subscription_id) ON DELETE CASCADE,
    event_id       uuid        NOT NULL
        REFERENCES platform_data.outbox_event (event_id),
    -- Denormalised from the event so a consumer's claim query does not join.
    -- The claim runs on every poll of every consumer; the join would be the
    -- hottest thing in the system.
    tenant_id      uuid        NOT NULL,
    event_type     text        NOT NULL,
    occurred_at    timestamptz NOT NULL,

    state          text        NOT NULL CHECK (state IN
        ('pending', 'in_flight', 'delivered', 'dead_lettered')),
    attempts       integer     NOT NULL DEFAULT 0,
    -- When this delivery becomes eligible. Backoff is expressed as a future
    -- visibility time rather than a sleep, so a retry costs nothing while it
    -- waits and survives the process that scheduled it dying.
    visible_at     timestamptz NOT NULL,
    -- Set while a consumer holds the message. A claim that is never
    -- acknowledged — because the consumer crashed — becomes visible again
    -- after the lease expires.
    leased_until   timestamptz,
    leased_by      text        NOT NULL DEFAULT '',
    last_error     text        NOT NULL DEFAULT '',
    created_at     timestamptz NOT NULL,
    updated_at     timestamptz NOT NULL
);

-- One delivery per (subscription, event). This is what makes the fan-out
-- idempotent: a publisher that crashes mid-fan-out and re-runs produces the
-- same rows rather than duplicates.
CREATE UNIQUE INDEX event_delivery_subscription_event_key
    ON platform_data.event_delivery (subscription_id, event_id);

-- The claim query: the oldest visible work for one subscription. Partial, so
-- the scan is proportional to the backlog rather than to all history — the
-- difference between a constant-cost consumer and one that slows down forever.
CREATE INDEX event_delivery_claimable_idx
    ON platform_data.event_delivery (subscription_id, visible_at, occurred_at, delivery_id)
    WHERE state IN ('pending', 'in_flight');

-- Dead letters are read by a human, rarely, and must be findable by tenant.
CREATE INDEX event_delivery_dead_idx
    ON platform_data.event_delivery (tenant_id, updated_at DESC)
    WHERE state = 'dead_lettered';

-- Finding what has not yet been fanned out after a restore.
CREATE INDEX event_delivery_event_idx
    ON platform_data.event_delivery (event_id);
