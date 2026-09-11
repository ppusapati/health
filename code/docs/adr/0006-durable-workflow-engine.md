# ADR-006: The workflow engine is ours until a process owner needs to author one

- **Status**: Accepted — **closes the blocking decision for Waves 1–6**
- **Date**: 2026-09-11
- **Relates to**: ADR-001 (modular monolith), ADR-005 (event transport),
  ADR-007 (rules engine)
- **Requirements**: none claimed. The Wave-7 families SRS-BPM-DEF, SRS-BPM-RUN
  and SRS-BPM-TASK are explicitly **not** claimed by this decision.
- **Gate**: A11

## Context

The register asks for "a durable workflow technology with Go SDK, versioning,
timers, retries, compensation and operational visibility", evidenced by a
reference long-running workflow and a version upgrade test.

P0-07 built that reference workflow — tenant onboarding — against an in-repo
engine, and the evidence section below records what it showed. So the question
is no longer "can this be done" but "by what, and when does that change".

Two facts frame the answer.

The first is what Waves 1–6 actually need. The workflows in the Wave-1 backlog
are coordination flows written by engineers: onboard a tenant, admit a patient,
route an order for approval. They are long-running in the sense that they wait
on people and timers, not in the sense that they run for months. Nobody outside
engineering authors them.

The second is Wave 7. The programme already assigns SRS-BPM-* to Wave 7, with
its own canonical schemas, and the Wave-0 specification says Wave 7 may replace
this harness entirely. So this decision does not have to be permanent, and
pretending otherwise would be the mistake — a decision claiming to settle Wave 7
would be made now, with none of Wave 7's information.

## Options considered

**A. Temporal.**
The strongest product in this category. Workflow code is ordinary Go, made
durable by deterministic replay of an event history, with timers, signals,
retries, saga compensation and a mature web UI. The Go SDK is first-class.

Two real costs. Operationally it is a cluster — frontend, history, matching and
worker services over its own persistence, plus Elasticsearch for visibility —
which is a large surface for an on-premises install serving one hospital group,
and the same argument that decided ADR-005. Developmentally, the determinism
constraint on workflow code is a sharp edge: a `time.Now()`, a map iteration or
a version-gated branch in the wrong place breaks replay on the next deploy, and
the failure appears in production on old instances rather than in CI. That is a
worthwhile trade at Temporal's scale and an expensive one below it.

**B. Camunda 8 / Zeebe.**
BPMN, which matters more than engineers usually credit: a clinical process owner
can read and change a BPMN diagram, and cannot read a Go function. Operate and
Tasklist are genuinely good operational surfaces. Costs are a broker plus
exporter plus Elasticsearch, a commercial licence for self-managed production
use, and a JVM runtime this system does not otherwise have.

**C. The in-repo tick-driven engine on PostgreSQL.**
What P0-07 built. Definitions are Go values; instances, history, timers, signals
and human tasks are rows; the engine claims runnable instances and steps them
forward. No new system, and the workflow's state commits in the same database
as the domain change it coordinates.

What it does not have is most of what a product is for — see **Consequences**.

## Decision

**Option C for Waves 1–6**, with the `Definition`/`Step` contract as the seam
and the reopening conditions named below. The blocking status is lifted: no
Wave-1 team is waiting on a vendor.

The properties that make this defensible rather than merely convenient:

1. **Versions are pinned, and migration is explicit.** A running instance keeps
   the definition version it started on, so publishing v2 on a Tuesday cannot
   change what an in-flight v1 instance does. When an instance must move — it is
   waiting on the very step v2 fixes — `Engine.Migrate` moves that one instance,
   resuming at the step with the same **name**, never the same index. Every case
   it cannot handle safely is a refusal, not a guess.
2. **The workflow coordinates; it does not own domain state.** Steps call
   services. Compensation is an explicit reverse command, because by the time a
   later step fails the earlier transaction is long committed. This is the rule
   that keeps the engine replaceable: nothing authoritative lives in it.
3. **It is not a second source of truth.** Instance state is correlation and
   decisions, not copies of aggregates.

## Evidence

The reference workflow (`tenant_onboarding`) exercises every criterion the
register names. Each is a test rather than a claim:

| Criterion | Evidence |
|---|---|
| Go SDK | The definition *is* Go. `internal/platform/workflow/definition.go` |
| Versioning (pinning) | `TestRunningInstanceStaysPinnedToItsVersion` — v2 is published mid-flight; the running instance finishes on v1's step bodies |
| **Version upgrade** | `TestMigratingAWaitingInstanceResumesOnTheNewVersion` — a waiting instance moves to v2, resumes at the right step although the indices shifted, and does **not** re-run the step v2 inserted behind it |
| Version upgrade refusals | Step removed, step changed kind, instance terminal, instance compensating, unknown target version — each a distinct refusal |
| Timers | `TestTimerStepWaitsAndThenResumes` |
| Human tasks | `TestOverdueHumanTaskExpires`, `TestCompletingATaskTwiceIsRefused` |
| Retry / backoff | `TestTransientFailureRetriesWithBackoffThenSucceeds` |
| Compensation | `TestExhaustedRetriesCompensateInReverseOrder`, `TestNonRetryableErrorCompensatesImmediately` |
| Idempotent signals | `TestDuplicateSignalIsIgnored`, `TestLateSignalOnACompletedInstanceIsIgnored`, `TestCrossTenantDuplicateSignalWritesNothing` |
| **HA** | `TestConcurrentEnginesRunEachStepExactlyOnce` — four engine replicas, twenty instances, every step executed exactly once |
| Visibility | `TestListSurfacesInstancesByStatus`, `TestStalledFindsInstancesThatShouldBeMovingAndAreNot`, `TestHistoryRecordsTheWholeExecution` |

The HA test is the one worth dwelling on, because writing it found a real
defect. The engine claimed a batch of instances under `FOR UPDATE SKIP LOCKED`,
committed that transaction, and *then* advanced each instance. Committing
released the locks, so a second replica claimed the same instances and ran the
same step bodies. The optimistic version predicate duly rejected the loser's
write — but the step had already executed, and a side effect is not something a
rolled-back transaction takes back. In a clinical workflow that is a duplicate
order.

The fix is that a step now runs while its row lock is held: the engine re-locks
each candidate individually (`LockWorkflowInstance`, `FOR UPDATE SKIP LOCKED`)
and advances it inside that transaction. The first version of the test failed
with duplicate executions on nineteen of sixty steps; it passes five
consecutive runs under `-race` now.

"SKIP LOCKED is in the query" was true before the fix and meant nothing. This is
why the criterion is evidenced by counting side effects rather than by reading
the SQL.

## Reopening triggers

Reopen — to Temporal for a technical trigger, to Camunda 8 for an authoring
trigger — when **any** of the following becomes true:

1. **A process owner must author a workflow.** The moment a clinical or
   operations lead needs to change a process without an engineer and a deploy,
   this engine is the wrong tool and no amount of work on it will make it the
   right one. This is the trigger most likely to fire, and it selects Camunda
   (BPMN) rather than Temporal.
2. **Workflows outlive deployments by a wide margin.** Instances routinely
   running for months, so that several definition versions are in flight at
   once and per-instance migration becomes a standing operational chore rather
   than an incident response. Temporal's versioning is built for exactly this.
3. **Scale.** Sustained workflow-step throughput that one PostgreSQL cannot
   carry, measured the same way as ADR-005's trigger 2: instances sitting in
   `running` for minutes under normal load with the engine healthy. The
   `Stalled` query exists to make this observable rather than anecdotal.
4. **Cross-service orchestration.** A workflow must coordinate systems outside
   this deployment — a partner lab, a payer, a separately deployed service.
   In-process steps stop being the right unit, and a durable-execution product
   earns its operational cost.
5. **Wave 7, unconditionally.** SRS-BPM-DEF, SRS-BPM-RUN and SRS-BPM-TASK are
   Wave-7 scope and this decision does not attempt to satisfy them. Wave 7
   re-runs this evaluation with six waves of real workflows as its input, which
   is information nobody has today.

Trigger 1 is worth watching deliberately rather than waiting for. Everything
else on this list is a capacity or complexity problem that announces itself; a
process owner who has quietly given up asking for changes does not.

## Consequences

**Good**

- No cluster, no JVM, no second datastore. Workflow state is in the same
  PostgreSQL as the domain change it coordinates, so it is covered by the same
  backup, the same restore drill and the same tenant isolation.
- Everything is inspectable with SQL. "Which instances are stuck" is a query,
  and the history table is the whole execution record.
- Wave-1 teams write workflows in Go against the same patterns as the rest of
  the codebase, with no SDK, no separate worker deployment and no determinism
  constraint on their code.

**Costs, stated plainly**

- **No workflow-as-code durability.** Temporal replays your function; this
  engine re-enters a named step. So steps must be idempotent and any state a
  workflow needs must be explicit in `State`, rather than living in local
  variables. This is the single biggest developer-facing difference.
- **No UI.** `History`, `List` and `Stalled` plus SQL are the operational
  surface. Adequate for an engineer, not for a process owner — which is trigger
  1 restated.
- **No child workflows, continue-as-new, search attributes or cross-language
  SDKs.** Compose by starting a second instance and correlating, or do not
  compose.
- **Throughput is one database's.** The same ceiling as ADR-005 and the same
  first response: more database before more architecture.
- **Migration is per instance and manual.** Deliberately — a bulk migration is
  a bulk risk — but it is an operator's afternoon when many instances are
  affected.
- **Human-task expiry records, it does not decide.** What happens to an
  unanswered approval is a business rule, so an expired task sits expired until
  a definition says otherwise. Silent auto-approval would be far worse.

## Verification

- `internal/platform/workflow/workflow_test.go` — the reference long-running
  workflow, retries, compensation, start idempotency.
- `internal/platform/workflow/versioning_test.go` — pinning, definition
  validation, refusal to re-register a published version.
- `internal/platform/workflow/migrate_test.go` — the version upgrade test the
  register asks for, plus every refusal.
- `internal/platform/workflow/ha_test.go` — concurrent replicas, and the
  operator visibility surface.
- `internal/platform/workflow/signal_test.go` — signals, human tasks, timers,
  tenant scoping, execution history.
