# ADR-W0-010: Operational drills are scripts, not transcripts

- **Status**: Accepted
- **Date**: 2026-09-15
- **Requirements**: SRS-SEC-002, SRS-NFR-005, SRS-NFR-016
- **Related**: Gate A8, `docs/engineering/drill-log.md`, `security/drill-register.yaml`

## Context

Three Wave-0 requirements are satisfied by an activity rather than an artefact:
a credential rotation that callers do not notice, a recovery that meets an RPO
and an RTO, and a backup whose restore is verified. For each of them the
repository had a runbook — careful, specific, reviewed — and no execution.

The usual way this closes is that somebody performs the procedure once against
pre-production, pastes the result into a ticket, and the requirement is marked
verified. That produces three problems:

The evidence cannot be re-run. Next quarter's drill is performed by whoever is
on call, from the runbook, with none of the setup the first person had. What was
learned the first time is in a ticket nobody opens.

The runbook drifts from the system. A runbook is prose about a system that
changes underneath it; nothing tells you when a step has stopped working. The
step that has stopped working is discovered during the incident.

And the result gets read for more than it says. "The DR drill passed" travels
further than the environment it passed in. Whether it covered a cross-zone
failover, or two processes on one machine, is the part that gets dropped.

## Decision

**Each drill is a committed script that sets up its own world, runs the
runbook's procedure against the real binary, measures, and prints numbers.**
`scripts/drills/{rotation,backup,dr}-drill.sh`, plus `make drills`.

Three rules follow, and each of them is a decision that could have gone the
other way:

**The script exercises the deployed artefact, not a copy.** The backup drill
reads `backup-verify.sh` out of `infra/k8s/base/backup-scripts.yaml` rather than
keeping its own copy, so a divergence between what is tested and what is
deployed is impossible rather than merely unlikely. The drills apply
`db/migrations` as shipped rather than a hand-built schema.

**Every result records what it did not cover.** `security/drill-register.yaml`
requires a `scope` field and `tools/security` fails a register entry without
one. This is the field that stops "the DR drill met its targets" from being read
as a statement about production.

**A missed target is recorded with a remediation reference, and the gate checks
currency rather than success.** A gate that requires a pass is a gate that
teaches a team to run the drill only when it will pass, which is exactly when it
has nothing to tell them.

## Consequences

The drills found seven defects on their first execution, three of them capable
of causing an outage during a real rotation and two of them making the nightly
backup verification worthless in opposite directions — a check that would have
failed most nights for the wrong reason, and passed silently over a restore that
lost every patient record. None was subtle in hindsight. All seven needed the
procedure executed under concurrent load rather than read; several of the
runbooks had been reviewed more than once.

The rate-limiter defect is the clearest argument for this decision. The code
comment already said the peer address is "a weak key behind a proxy": the fact
was known and its consequence — two requests per second for the entire
deployment behind a mesh sidecar — was not followed through. No amount of
reading finds that. A load generator at five requests per second does, in about
a second.

The cost is that the drills are not in `make ci`. They start real PostgreSQL
instances and real service processes and take minutes, so they run on demand and
quarterly. That is a real gap: a change to the rate limiter or the backup script
can land without one being run. `tools/infra` and `tools/security` hold the
specific invariants that the drills established, which is what narrows the gap —
a regression of a *known* defect is caught in CI, and the drill is what finds
the next unknown one.

## What this does not decide

It does not replace the pre-production drills the runbooks describe. A harness
on one machine proves the procedure, the application and the database; it proves
nothing about external-secrets, the mesh, a rollout, or a cross-zone failover.
Both are required, and the register says which one produced each number.

## Alternatives considered

**Leave them as runbooks and drill in pre-production only.** This is the
standard arrangement and it is what the runbooks assume. Rejected as the sole
mechanism, not as a mechanism: it needs an environment this repository's CI does
not have, it happens quarterly at best, and it leaves the runbook unexercised in
between — which is where all seven defects were living.

**Write the drills as Go tests so they run in `make ci`.** Attractive, and wrong
for what these measure. A rotation drill needs two service processes replaced
one at a time while a third party watches from outside; a DR drill needs a
primary killed with `SIGKILL` and a replica promoted. Modelling that in-process
would test a model. The drills are shell because the thing being tested is an
operator procedure, and an operator procedure is shell.

**Record the drill results only in prose.** Rejected because a release gate
cannot read prose. The register is machine-readable so currency can be enforced;
`drill-log.md` is the narrative, and the two are kept beside each other rather
than one being derived from the other.
