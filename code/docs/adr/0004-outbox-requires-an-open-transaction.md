# ADR-W0-004: Appending to the outbox requires an open transaction

- **Status**: Accepted
- **Date**: 2026-09-11
- **Defers to**: ADR-005 (event broker, *Decision Required*, blocking)
- **Requirements**: SRS-API-008, SRS-DAT-003, SRS-NFR-009
- **Gate**: A3

## Context

The architecture requires that a state change and its outbox event commit
atomically. Expressed as a convention, this is "remember to append the event
inside the transaction" — and the failure mode when someone forgets is silent:
the aggregate is written, no event is emitted, and a downstream projection
drifts out of sync in a way that only surfaces much later.

## Decision

The active transaction travels in the `context.Context`. `Store.Append` calls
`pgtx.RequireTx(ctx)` and returns an error if there is none, so an outbox write
outside a unit of work fails loudly and immediately.

Audit deliberately does **not** take this constraint: a denied attempt must
survive the rollback of the transaction it was refused in, so `AppendAudit`
works with or without one.

Delivery is at-least-once. The publisher can crash between the broker
acknowledging an event and the row being marked published, so consumers
deduplicate through `TryConsume`, which is a plain `INSERT … ON CONFLICT DO
NOTHING` against the inbox table.

The `Broker` interface is one method. ADR-005 has not chosen between
Kafka-compatible and NATS JetStream, and nothing above this interface knows or
cares.

## Consequences

**Good**

- Atomicity is enforced at runtime on the first call, not discovered in
  production.
- `FOR UPDATE SKIP LOCKED` lets several publisher replicas drain concurrently
  without double-claiming.
- One failing event records its error and leaves the row unpublished rather than
  stalling the batch.

**Costs**

- Putting the transaction in the context is implicit. The alternative — passing
  a `Tx` through every signature — is explicit but easy to bypass by simply not
  passing it, which is the failure this ADR exists to prevent.
- Nested `WithinTx` calls join the outer transaction rather than opening a
  second one. This is the correct behaviour for atomicity but means a caller
  cannot get an independent inner transaction without a new API.
