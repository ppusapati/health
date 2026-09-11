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
3. The broker itself is not yet selected (ADR-005). Until then the publisher
   runs against whatever `Broker` implementation the deployment wires in.

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
