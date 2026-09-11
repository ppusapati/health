# ADR-005: PostgreSQL is the event transport until it measurably is not

- **Status**: Accepted — **closes the blocking decision**
- **Date**: 2026-09-11
- **Relates to**: ADR-W0-004 (outbox requires an open transaction)
- **Requirements**: SRS-API-008, SRS-DAT-003, SRS-NFR-003, SRS-NFR-006,
  SRS-NFR-009
- **Gate**: A3

## Context

The register framed this as "Kafka-compatible vs NATS JetStream", and Wave 0
deliberately did not answer it: `store.Broker` is a one-method interface and
nothing above it knows what is behind it.

Framed as a product comparison the question has no answer yet, because the
inputs are missing. Nobody can say what this platform's event rate will be —
there is no production deployment — and both candidates comfortably exceed any
rate a hospital group generates. Choosing between them on throughput would be
choosing on a number neither of them is constrained by.

What is knowable is the shape of the traffic and the shape of the operation:

- Events are written by the transactional outbox, so they are already durable
  in PostgreSQL before any transport sees them.
- Consumers are, for the whole of Wave 1, other modules of the same monolith
  (ADR-001). There is no consumer outside this deployment.
- A deployment target is a single hospital group, frequently on their own
  infrastructure, sometimes on-premises. Every additional running system is an
  additional thing their operations team has to keep alive at 3am.

That last point is the one that decides it. A broker is not only a throughput
decision; it is an operational surface, and this platform's most common
installation is one where that surface is expensive.

## Options considered

**A. Kafka (or a Kafka-compatible service such as Redpanda / MSK).**
Unmatched throughput and retention, and the ecosystem every data team already
knows. But it is a stateful cluster with its own storage, its own failure
modes, and its own upgrade path, and delivery to it is a second commit: the
publisher writes to Kafka, then marks the outbox row published, and a crash
between the two loses nothing but duplicates everything. Reasonable at scale;
heavy for an on-premises install serving one hospital group.

**B. NATS JetStream.**
Materially lighter than Kafka — a single binary, clustering built in — and
still a real broker with persistence and consumer groups. Same second-commit
problem, and the same "one more system" cost, but a much smaller version of it.
The strongest candidate once this platform outgrows option C.

**C. PostgreSQL itself: fan out to per-consumer delivery rows inside the
publisher's transaction.**
No new system. The delivery rows, the outbox row and the aggregate change
commit together, which removes the second commit entirely — an event cannot be
marked published without its deliveries existing. Competing consumers,
at-least-once delivery, retry with backoff and dead-lettering are all ordinary
SQL over `FOR UPDATE SKIP LOCKED`. The ceiling is one database's write
capacity, and retention is coupled to the transactional store.

## Decision

**Option C for now, with the seam intact and the migration triggers named.**

Event delivery runs on PostgreSQL: `store.PgBroker` fans an event out into one
`platform_data.event_delivery` row per interested subscription, and
`eventbus.Worker` drains a subscription with leases, exponential backoff and a
dead-letter state.

Three properties make this defensible rather than merely convenient:

1. **Atomic publish.** Fan-out happens inside the publisher's transaction. With
   a network broker, a crash between the broker's acknowledgement and the
   outbox update leaves the event delivered-but-unpublished, and the retry
   duplicates it to every consumer. Here there is no window, because there is
   no second system.
2. **Head-of-line blocking is per consumer.** Delivery is fanned out on write,
   not on read. A consumer that cannot process one message dead-letters it and
   carries on; it does not stall a shared cursor. In a hospital that is the
   difference between "the analytics loader is stuck" and "medication events
   stopped reaching everybody".
3. **The seam is unchanged.** `store.Broker` is still one method. Replacing the
   transport is a new implementation plus a line in the composition root.

`AfterCommit` in `pgtx` exists for this: the notification that wakes a consumer
fires after the transaction is durable. Fired inside it, the woken worker looks
before the rows are visible, finds nothing, and sleeps until its next poll —
measured below, that mistake cost a 6.7× increase in median latency.

## Evidence

`internal/platform/store/eventbus_bench_test.go`, `go test -bench . -benchtime
3s`, against PostgreSQL 16.13 on the development machine (4 vCPU Xeon @ 2.10
GHz, 15 GB RAM, database over a local TCP socket). These are single-node
development numbers, not a capacity plan; they are here to establish the order
of magnitude the triggers below refer to.

| Measurement | Result | Derived |
|---|---|---|
| Fan-out, 1 subscription | 703 µs/event | ≈ 1,400 events/s per publisher |
| Fan-out, 4 subscriptions | 843 µs/event | +47 µs per extra subscription |
| Fan-out, 16 subscriptions | 1,407 µs/event | +47 µs per extra subscription |
| Claim + ack, batch 1 | 1,005 µs/delivery | ≈ 1,000 deliveries/s per worker |
| Claim + ack, batch 50 | 494 µs/delivery | ≈ 2,000 deliveries/s per worker |
| Publish → handled, p50 | 2.2 ms | |
| Publish → handled, p95 | 2.9 ms | |
| Publish → handled, p99 | 4.5 ms | |

Two things are worth reading off this table.

Adding a consumer costs about 47 µs of the publisher's transaction. Sixteen
subscriptions double the publish cost relative to one. That is the number that
eventually forces a broker — not the raw rate, but the fact that here fan-out
is paid by the writer, and on a broker it is paid by the broker.

Batching helps a consumer by roughly 2×, and no more, because each
acknowledgement is its own round trip. A consumer that needs more than a couple
of thousand messages a second per process gets it by running more processes —
`SKIP LOCKED` means they need no coordination — until the database's write
capacity is the limit rather than the worker's.

For scale: 1,400 events/s is roughly 120 million events a day. A large hospital
group generates clinical events in the low millions per day.

## Migration triggers

This decision is reopened — to NATS JetStream first, Kafka only if the third
trigger fires — when **any** of the following is observed in a production
deployment:

1. **Publisher cost.** Fan-out exceeds 25% of the median write transaction's
   duration, or a single event type has more than ~20 subscriptions. Both mean
   the writer is paying for other people's consumption.
2. **Backlog.** The outbox backlog (`Publisher.PendingCount`, already an SLI
   under SRS-NFR-006) is non-zero for more than five consecutive minutes under
   normal load, with the publisher not blocked on a single failing consumer.
   This is the honest signal that production rate exceeds drain rate.
3. **A consumer outside this deployment.** Anything that is not a module of
   this system needs events — a customer's data warehouse, a partner
   integration, a separately deployed service. Exporting events by giving a
   third party a login to the transactional database is not an option, and a
   broker is the correct answer the moment this is real.
4. **Retention conflict.** Event history must outlive what the transactional
   database should be carrying: replaying six months of events to rebuild a
   projection is a broker's job, not a hot OLTP table's.

Trigger 3 selects a broker on its own regardless of any measurement. Triggers 1
and 2 are capacity, and the first response to them is vertical: the delivery
table is narrow and its claim index is partial, so it responds well to more
database. A broker is the answer when more database is no longer the answer.

## Consequences

**Good**

- No second system to deploy, secure, back up, upgrade or explain to a hospital
  IT department.
- Publishing is atomic with the state change it describes. The
  delivered-but-unpublished window that every network broker has does not exist
  here.
- Delivery state is queryable with SQL, and the dead-letter queue is a table.
  Diagnosing "why did this event not arrive" is a `SELECT`, not a broker CLI.
- Backup and restore already cover event state, because it is in the same
  database (SRS-NFR-016).

**Costs**

- Fan-out is paid by the writer, and grows with the number of subscriptions.
  Trigger 1 exists because this is the cost that bites first.
- The ceiling is one database. Sharding event delivery would be re-implementing
  a broker badly, so trigger 2 is a migration signal and not a tuning task.
- Retention is coupled to the transactional store, so long event history means
  a larger OLTP database until trigger 4 forces the split.
- Delivery is at-least-once, as it would be on any transport. Every consumer
  deduplicates on event id through the inbox; that requirement does not change
  when the transport does.

## Verification

- `internal/platform/store/eventbus_test.go` — 17 tests against real
  PostgreSQL: fan-out to every subscription, event-type and tenant filters,
  competing consumers with no double-claim, **crashed-consumer lease recovery
  (gate A3)**, backoff and retry, a poison message dead-lettered without
  blocking other consumers, dead-letter replay, idempotent fan-out and
  registration, and notification ordering against commit.
- `internal/platform/eventbus/worker_test.go` and `runtime_test.go` — worker
  and routing logic under `-race`: drain-to-empty, panic containment, the lease
  as a handler deadline, notification routing, and a consumer that fails to
  register stopping the process.
- `internal/app/eventdelivery_test.go` — the pipeline as wired: an RPC that
  creates a facility results in a consumer being handed that fact, a filtered
  consumer is not sent everything, a failing consumer is retried with the
  attempt count visible, and an event survives the consumer process restarting.
- `internal/platform/pgtx/pgtx_test.go` — after-commit hooks run only on
  commit, never on rollback or panic.
