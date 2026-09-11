# Runbook: core service

| | |
|---|---|
| Deployable | `core` (organization + identity_access bounded contexts) |
| Owning team | Platform |
| Criticality | Tier 2 (Wave 0; rises to Tier 0/1 as Wave-1 clinical contexts land) |
| Availability SLO | 99.95% monthly |
| Latency SLO | p95 ≤ 400 ms, excluding external dependency time |
| Manifests | `infra/k8s/` |

## Health endpoints

| Endpoint | Checks | Used by |
|---|---|---|
| `HealthService/CheckLiveness` | Process only | Liveness probe |
| `HealthService/CheckReadiness` | Process **and** PostgreSQL | Readiness probe, load balancer |
| `HealthService/GetBuildInfo` | — | Incident triage: which artifact is running |

Liveness deliberately does not touch the database. If you are tempted to
"improve" it by checking dependencies, read the reasoning in
`tools/infra/manifests_test.go` first — a test enforces this.

## Common alerts

### Readiness failing, liveness passing

The process is alive but PostgreSQL is unreachable. Pods are pulled from the
load balancer and will **not** be restarted, which is intended: restarting
loses nothing and costs a cold connection pool.

1. `GetBuildInfo` on a passing pod to confirm which version is deployed.
2. Check the database's own health and the `data` namespace network policy.
3. Check connection-pool saturation before assuming an outage: exhaustion looks
   identical from the probe's point of view.

### Elevated 5xx with `INTERNAL` error codes

Correlate on the `correlation_id` the client was shown. Every response carries
one, and it appears on the server span and log line.

```
correlation_id=<id>
```

Routine telemetry contains no request payloads by design, so reproduce with the
correlation ID and the audit record, not by turning up logging on PHI.

### Outbox backlog rising

`platform_data.outbox_event` where `published_at IS NULL`.

A rising backlog means committed facts are not reaching consumers. State is not
lost — the rows are durable — but projections are stale.

1. Check `attempts` and `last_error` on the oldest unpublished rows.
2. If one event is poisoned, the publisher skips it and continues; the row stays
   unpublished and is retried. Fix the consumer or the payload.
3. A backlog that stays non-zero for more than five minutes under normal load is
   migration trigger 2 in [ADR-005](../../adr/0005-event-broker.md), not a
   tuning task. Record it.

```sql
SELECT event_type, count(*), min(occurred_at)
FROM platform_data.outbox_event
WHERE published_at IS NULL
GROUP BY 1 ORDER BY 3;
```

### A consumer is not receiving events

Delivery is fanned out on write (ADR-005): every subscription gets its own row
in `platform_data.event_delivery`, so one stuck consumer cannot stop the
others. Which means "consumer X is behind" is always about consumer X.

```sql
SELECT s.consumer, d.state, count(*), min(d.occurred_at) AS oldest
FROM platform_data.event_delivery d
JOIN platform_data.subscription s USING (subscription_id)
GROUP BY 1, 2 ORDER BY 1, 2;
```

| What you see | What it means |
|---|---|
| No rows for that consumer at all | The subscription was never registered, or its `event_types` filter excludes what you expected. Check `SELECT * FROM platform_data.subscription`. |
| `pending` with `visible_at` in the future | The consumer is failing and backing off. `last_error` says why. |
| `in_flight` with `leased_until` in the past | The worker holding it died. Another worker reclaims it on its next poll; no action. |
| `in_flight` with `leased_until` in the future, not moving | The handler is blocked. The lease is also the handler's deadline, so it will be released — look at what the handler is waiting on. |
| `dead_lettered` | Gave up after `max_attempts`. See below. |

A consumer whose subscription is disabled (`enabled = false`) receives nothing
and accumulates nothing: fan-out skips it. Re-enabling does **not** backfill.

### Dead-lettered deliveries

A delivery that fails `max_attempts` times (5 by default) is dead-lettered
rather than retried forever. Nothing is lost — the event body is still in the
outbox — but that consumer will never see it again unless it is replayed.

```sql
SELECT d.delivery_id, s.consumer, d.event_id, d.attempts, d.last_error
FROM platform_data.event_delivery d
JOIN platform_data.subscription s USING (subscription_id)
WHERE d.state = 'dead_lettered'
ORDER BY d.occurred_at;
```

Fix the cause first. Replaying into a consumer that still cannot handle the
message spends another five attempts arriving back here.

Replay is `Store.ReplayDeadLetter(deliveryID)`, which resets the delivery to
pending with its attempt count cleared. Replay one and confirm it is
acknowledged before replaying the rest.

**Do not** delete a dead-lettered row to make an alert stop. The row is the
only record that a consumer missed a fact, and its absence reads as "nothing
went wrong".

## Deploy and rollback

```bash
kustomize build infra/k8s/overlays/prod | kubectl apply -f -
kubectl -n healthcare rollout status deployment/core
kubectl -n healthcare rollout undo deployment/core   # rollback
```

`maxUnavailable: 0` means a rollout never reduces capacity. A stuck rollout is
therefore safe to leave in place while you investigate.

## Migrations

Migrations are forward-only with expand/contract, so the previous application
version keeps working against the new schema. Apply the migration **before**
the deployment, and never in the same step.

## Escalation

Tenant-isolation or clinical-safety suspicion escalates immediately to Security
and the on-call architect. Per the Testing Master Plan §18, a known exploitable
tenant-isolation defect blocks release with no executive exception.
