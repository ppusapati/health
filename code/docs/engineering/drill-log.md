# Operational drill log

Three Wave-0 requirements are satisfied by an activity rather than an artefact:

| Requirement | Activity | Runbook | Harness |
| --- | --- | --- | --- |
| SRS-SEC-002 | Database credential rotation | [key-rotation.md](runbooks/key-rotation.md) | `scripts/drills/rotation-drill.sh` |
| SRS-NFR-005 | Disaster recovery, RPO ≤ 5 min / RTO ≤ 60 min | [disaster-recovery.md](runbooks/disaster-recovery.md) | `scripts/drills/dr-drill.sh` |
| SRS-NFR-016 | Backup with restore verification | [backup-restore.md](runbooks/backup-restore.md) | `scripts/drills/backup-drill.sh` |

The machine-readable results are in `security/drill-register.yaml`, which
`tools/security` reads; a production release is refused when the most recent
drill for any of the three is more than 120 days old. This file is the
narrative: what each drill found, and what it did not cover.

## What these drills are, and what they are not

They run the real binary against a real PostgreSQL, following the real runbook,
and they measure. They do **not** run a workload on Kubernetes.

That limitation is not a choice. A pod sandbox sets `oom_score_adj` to -998, and
lowering `oom_score_adj` needs `CAP_SYS_RESOURCE`, which is dropped from both
the effective and the bounding capability set of the environment these drills
were executed in. Every Kubernetes distribution fails identically there — kind
and k3s were both tried, and both got as far as a running control plane and then
could not start a single pod sandbox.

The control plane itself works, which is worth something and is used: see
[Manifest admission](#manifest-admission-against-a-real-api-server) below. But
what is written about the three drills is true of the application, the database,
the procedure and the scripts, and says nothing about rollouts, the mesh, or
external-secrets. **P0-12 and Gate A8 remain open**, and the pre-production
drills the runbooks describe are still required before a production launch.

A drill that is honest about its scope is worth more than one that is not, which
is why every entry in the register names what it did not cover.

## Why run them at all, then

Because they found seven defects, and all seven are the kind that only a
sustained, concurrent, adversarial execution of the procedure can produce. None
of them would have been caught by reading the runbook, and several had been read
several times.

### DRILL-2026-001 — credential rotation (SRS-SEC-002)

**Result: met.** 433 requests at roughly 15 per second through a full rotation.
Zero failed.

Three defects, each of which would have caused an outage during a real rotation:

1. **The runbook's last step could not run.** `DROP ROLE core` fails when the
   role owns objects, and the application's login role owned the entire schema.
   The alternative — reassigning ownership mid-rotation — takes exclusive locks
   across every table during a procedure whose whole promise is that callers do
   not notice. Fixed by separating a `NOLOGIN` owner from the login roles, which
   is now what the runbook describes and what the harness sets up.

2. **The new credential was created with the wrong membership.** The runbook
   said `CREATE ROLE core_v2 ... IN ROLE core`, which reads as "give it the same
   privileges" and is fatal: the new role's only path to the data then runs
   through the role that step 7 drops. The drill produced exactly that — the
   rotation reported success and every subsequent request failed. `IN ROLE
   core_owner` is correct and the runbook now says so, with the reason.

3. **The peer-address rate limiter capped the deployment at two requests per
   second.** The drill's own load — under five requests per second, from one
   address — was throttled. The limiter applied the tight unauthenticated budget
   to every request, keyed on the peer address; behind a service mesh the peer
   address is the sidecar, so that budget is shared by the whole hospital. Fixed
   in `internal/platform/transport/ratelimit.go`: credential-bearing traffic
   gets a flood-scale peer budget, uncredentialed traffic keeps the tight one,
   and `ClientAddress` recovers the real client from `X-Forwarded-For` when, and
   only when, the immediate peer is inside a configured trusted network.

The third is the one worth dwelling on. The code comment already said the peer
address is "a weak key behind a proxy" — the fact was known and its consequence
was not followed through. Nothing short of concurrent load through the real
binary makes that consequence visible.

### DRILL-2026-002 — backup restore verification (SRS-NFR-016)

**Result: met.** Verified and published with the database quiet, verified and
published with writes continuing throughout the dump, and a restore missing 100
rows out of 5017 was detected.

Four defects, two of them severe:

1. **The job could not run under least privilege.** It creates a scratch
   database to restore into, so it needs `CREATEDB`; it was configured to use
   the application's credential. Making it work as configured would have meant
   granting `CREATEDB` to the role that serves patient traffic. Fixed with a
   separate `core-backup-database` secret, and `tools/infra` now refuses a
   CronJob that reads `core-database`.

2. **Verification covered three schemas out of twenty.** The dump covers the
   whole database; the comparison listed `organization`, `identity_access` and
   `platform_data` by hand. Every clinical schema added since — `empi`,
   `clinical`, `nursing`, `orders`, `medication`, `billing`, `scheduling`,
   `encounter` — was unverified. **A restore that lost every patient record
   would have passed this check**, because the schemas it did compare happened to
   be empty. Fixed to discover every schema rather than list any.

3. **It compared estimates, not rows.** `n_live_tup` is maintained by the
   statistics collector and is approximate in both directions, so the control
   could raise a false alarm or wave through a short restore. Fixed to exact
   `count(*)`.

4. **It would have failed every night.** Row counts were taken after the dump,
   outside its snapshot, so any write between the two made source and restored
   disagree — and the job exits non-zero without publishing. A hospital writes at
   one in the morning. The job would have failed most nights, published no
   backup on those nights, and its alert would have stopped being read within a
   fortnight. Fixed by exporting the dump's own snapshot with
   `pg_export_snapshot()`, passing it to `pg_dump --snapshot`, and counting
   inside the same transaction.

Defects 2 and 4 interact in the worst possible way: a control that fails
constantly for the wrong reason, and passes silently for the right one.

### DRILL-2026-003 — disaster recovery (SRS-NFR-005)

See `security/drill-register.yaml` for the measured RPO and RTO.

The drill kills the primary with `SIGKILL` rather than shutting it down, because
a graceful stop flushes WAL that a real failure would not, and measures the RPO
against **the last write the user was told had been saved** rather than against
the last WAL position — those are not the same number, and only the first one is
what a clinician experiences. RTO runs from the declaration, not from the
outage.

The measured RTO is a floor rather than a prediction: the drill declares the
incident immediately, and in a real event the decision is usually the largest
single component. The runbook is explicit about this and the drill does not
pretend otherwise.

## Manifest admission against a real API server

Not one of the three drills, but the same idea and the same environment
constraint, so it lives here: `scripts/cluster/admission-check.sh`
(`make manifests-admission`).

`make manifests-validate` renders each overlay and checks it against published
JSON schemas — and **skips ExternalSecret, SecretStore and ClusterPolicy**,
because no schema exists for them. That is four objects per overlay
(`kubeconform` reports `Skipped: 4`), and until now nothing validated them.

`tools/infra` separately asserts that the namespace carries
`pod-security.kubernetes.io/enforce=restricted`, which is a statement about a
label rather than about the workload: nothing checked that the Deployment
actually satisfies `restricted`.

The check applies every overlay to a real Kubernetes API server with the two
CRD bundles installed, pinned by version. Result:

| Overlay | Objects applied |
|---|---|
| dev | 15 |
| preprod | 16 |
| prod | 16 |

All three applied clean, those four objects included, and the Deployment
produced a Pod — which is the evidence that pod security admitted it, since pod
creation by the ReplicaSet controller is where the plugin runs.

A pass there means nothing unless the policy can refuse, so the check injects a
privileged variant of the shipped Deployment — derived from the real manifest
rather than hand-written, so it cannot drift into a fixture refused for some
unrelated reason. In `healthcare-dev` it is refused:

```
violates PodSecurity "restricted:latest": privileged (container "core" must not
set securityContext.privileged=true), allowPrivilegeEscalation != false, …
runAsNonRoot != true, seccompProfile …
```

and in a namespace without the label the identical manifest is **admitted** and
a Pod appears. So the refusal is attributable to the policy and not to anything
else about the manifest.

**This is not a deployment.** The image is digest-pinned to a placeholder only
the release pipeline substitutes, so nothing pulls; there is no database, no
mesh and no external-secrets controller. "Every overlay applies to a real API
server and pod security is enforcing" is the whole claim.

**Not yet in CI.** A GitHub runner can run k3s, so wiring this into the pipeline
is the obvious next step; it has not been done because it cannot be verified
from the environment these checks were executed in, and shipping an unverified
CI job is how a pipeline goes red on somebody else's change.

## The workload under its own security context

Also not a drill, and for the same reason as the section above: what could not
be done here was running the workload *under kubelet*, so this establishes as
much of "the workload runs" as the environment allows and says plainly where
it stops.

A pod sandbox cannot start here — `CAP_SYS_RESOURCE` is dropped, and the
sandbox needs it to set `oom_score_adj` — but plain containers run fine, which
is what makes this possible at all and also confirms the original diagnosis was
specific rather than "containers do not work".

The runtime image was run with the container-level controls the Deployment
declares, set one for one:

| Deployment | Runtime |
|---|---|
| `runAsUser: 65532`, `runAsNonRoot` | `--user 65532:65532` |
| `readOnlyRootFilesystem: true` | `--read-only` |
| `capabilities.drop: ["ALL"]` | `--cap-drop ALL` |
| `allowPrivilegeEscalation: false` | `--security-opt no-new-privileges` |
| `tmp` emptyDir | `--tmpfs /tmp` |
| `core-config` + the database secret | the same variables, `AUTH_MODE=dev`, `TLS_MODE=mesh` |

Under those constraints, against a PostgreSQL carrying the migrations exactly
as `db/migrations` ships them:

- the service starts, and says so: `core service listening addr=:8080 tls_mode=mesh`
- both probes the manifest declares answer 200 on their real paths, and
  readiness reports its dependency — `{"ready":true,"dependencies":{"postgres":true}}`
- the Milestone-1 slice runs end to end through the container: `CreateTenant`
  then `CreateFacility`, leaving 2 audit records and 2 outbox events
- the Milestone-2 denial holds through the container: a second tenant asking
  for the first tenant's facility gets `not_found`, not `permission_denied`
- an incomplete request is refused by the domain with field violations and a
  correlation id, so the error contract survives the wire
- there is no shell to exec into: `/bin/sh` and `/bin/bash` are both absent
- `SIGTERM` drains in **72 ms** against a `terminationGracePeriodSeconds: 30`,
  exiting 0

**What this is not.** No kubelet, so nothing here exercises the probe scheduler,
the readiness gate's effect on endpoints, the rollout, the PodDisruptionBudget,
the NetworkPolicy or the mesh. Those are properties of the orchestrator, and
they remain untested. What it removes from doubt is the other half: the image
runs, under the security context the manifests ask for, and serves the system's
own gate criteria.

### What it found

Running it surfaced a defect that no unit test would, because it only appears
when the process stays up across a failure:

**The outbox publisher reported the same failure forever, and its recovery
never at all.** With the database reachable but the schema absent, the drain
retried every 250 ms and logged one identical `ERROR` line per attempt — four a
second, per replica, for as long as the outage lasted. Over a half-hour
incident that is tens of thousands of identical lines burying the diagnostics
somebody needs during exactly that incident, and when the fault cleared the
stream simply stopped complaining, which looks the same as a publisher that
died.

The retry is not what was wrong and did not change: the outbox is durable, so
waiting loses nothing, and a publisher that exits on a transient database error
takes the events with it. What changed is the reporting. The first failure is
logged immediately, repetitions are throttled to one line per
`DrainFailureReportInterval` (30 s), a changed error message is always reported
because a changed message is a changed fault, and recovery gets its own line
carrying how long the outage lasted and how many attempts it covered.

Measured in the container before and after, over 12 seconds of continuous
failure: **48 lines before, 1 after**, with the recovery line accounting for the
148 attempts the regression test observes it swallowing.

Evidence: `TestRepeatedDrainFailureIsReportedOnceThenThrottled`, which asserts
one failure line and one recovery line across many failing ticks — and asserts
the recovery line reports at least ten swallowed attempts, so it cannot pass by
the drain having been attempted only once.

Not a severity-1 defect and deliberately not in `security/defect-register.yaml`:
nothing is lost, corrupted or exposed. That register is narrow on purpose, and
filling it with severe-but-recoverable faults is how it stops being read.

## The workload under a real kubelet

This section replaces one that said no Kubernetes distribution could start a
pod here. **That was wrong**, and it is worth being precise about how: every
observation in it was accurate — the sandbox does set `oom_score_adj` to -998,
`CAP_SYS_RESOURCE` is dropped, kind and k3s both failed — and the conclusion
drawn from them was not. containerd's CRI plugin has `restrict_oom_score_adj`,
the supported setting for rootless and constrained hosts, which clamps the
value instead of failing. One line of kind config:

```yaml
containerdConfigPatches:
  - |-
    [plugins."io.containerd.grpc.v1.cri"]
      restrict_oom_score_adj = true
```

A default configuration had been mistaken for a property of the environment,
and "cannot be done here" is a conclusion that stops people looking.

`make cluster-deploy` deploys the dev overlay to that cluster. Substituted: the
image, because the manifests pin a digest only the release pipeline produces;
the database Secret, because the external-secrets controller is not installed;
and a PostgreSQL to talk to. Everything else — security context, probes,
resource limits, service account, network policies, disruption budget — applies
as written, and `scripts/cluster/localise.py` asserts the security context it
passes through is the one the overlay rendered, so a future edit cannot quietly
relax one and leave the deploy green.

### What it found

Four defects. Three meant the Deployment could not have rolled out in any
cluster, and none was reachable by schema validation, by admission, or by
running the image by hand — the first two never execute a probe or a mount, and
the third means choosing the verb and the environment yourself, which is where
two of these live.

**Every probe was unsatisfiable.** All three were declared as `httpGet` against
the ConnectRPC procedure paths. A Connect unary procedure is a POST; an
`httpGet` probe issues GET and cannot be made to do otherwise. They answered
405, the Pod never became ready, and the Deployment could never have rolled
out. The server now serves `/healthz` and `/readyz` over plain HTTP, delegating
to the same methods the RPC surface exposes — two implementations of "is this
instance ready" drift, and the one the orchestrator believes is whichever it
happens to call. `tools/infra` gained the invariant, verified against the
original manifest before being trusted.

**The Deployment could not reach any database it was willing to talk to.** The
binary refuses any `sslmode` below `verify-ca`, rightly: `require` encrypts
without authenticating the server. But `verify-ca` needs a CA the client
trusts, and the manifests gave it nowhere to put one — no volume, no mount,
only public roots in the image. Every managed PostgreSQL presents a private CA.
The policy and the manifest contradicted each other. There is now an optional
`core-database-ca` mount.

**The dev overlay could not start.** It configures a filesystem blob backend at
`/var/lib/health/blobs`; the base Deployment runs `readOnlyRootFilesystem` and
mounts nothing there. The two had never been applied together.

**A rolling update dropped one request in 589, intermittently.** Endpoint
removal is asynchronous, so for a short window traffic arrives at a Pod on its
way out. The service shut down in 72ms — reported in the previous section as a
good result, and in fact the opposite: the cleaner the shutdown, the wider the
race. Readiness now answers false the moment the signal lands and the process
serves for five more seconds. See DRILL-2026-004.

### What is still not covered

One node, so a rollout replaces a Pod on the same kubelet, which is the easy
case. No mesh, no external-secrets controller, no cross-zone failover, and
nothing at production concurrency. The pre-production drills the runbooks
describe are still required.

## Running them

```bash
make drills                     # all three, building the binary first

KUBECONFIG=… make manifests-admission   # needs a cluster
```

Each is self-contained: it builds its own PostgreSQL under `/tmp/health-drill`,
applies the repository's migrations, runs, prints its numbers and tears down.
They are not part of `make ci` — they take minutes and start real servers — but
they are cheap enough to run before any change to a runbook, a backup script or
the rate limiter, and that is the point of them being scripts rather than
transcripts.

## If a drill fails

Record the number that was actually achieved, raise the remediation item, and
run the next drill on schedule. Do not extend the window and retry until it
passes: a register of nothing but passes is a register of drills that were only
ever run when they would pass, and `tools/security` enforces that a missed
target carries a remediation reference precisely so that recording the failure
is cheaper than hiding it.
