# ADR-007: A governed decision-table library, not a rules product

- **Status**: Accepted — closes ADR-007 (previously *Partially Closed*)
- **Date**: 2026-09-11
- **Relates to**: ADR-006 (workflow engine) — see **Coupling** below
- **Requirements**: none claimed. The Wave-7 families SRS-RUL-DEF and
  SRS-RUL-RUN are explicitly **not** claimed by this decision.
- **Gate**: A11

## Context

The register frames this as "internal DSL/library vs selected product", with
acceptance criteria of determinism, versioning, simulation, explainability,
replay and governance, evidenced by a decision-table reference implementation.

It was already marked *Partially Closed* and non-blocking, because P0-07 built
the evaluator. What that left open was the half the criteria actually turn on.
An evaluator is a pure function; a **rules capability** is that function plus
the answer to "who may change this, and can you prove what it said in March".
Determinism in a library nobody governs is a property of a file, not of the
system.

So closing this ADR meant finishing the governance, effective dating and
decision-log path, and then deciding whether what results is better or worse
than a product.

## Options considered

**A. Drools / Kogito.**
The reference business-rules engine, and genuinely powerful — forward chaining,
a mature authoring story, decades of use in exactly this domain. It is a JVM
runtime this system does not otherwise have, which in practice means a second
service and a network hop inside a clinical decision path. Its expressiveness
is also more than is wanted here: rules that can chain and mutate working memory
are rules whose outcome is harder to simulate exhaustively and harder to explain
in a sentence.

**B. Camunda DMN.**
DMN is a real standard, and a DMN decision table is a grid a finance or clinical
analyst can read and change — the single strongest argument for a product over a
library. Also JVM. Its cost is lowest if ADR-006 had chosen Camunda 8, because
the runtime would already be deployed; ADR-006 did not, so DMN would arrive
alone.

**C. OPA / Rego.**
Excellent at authorization policy, which is what it was built for, and already a
plausible future for this platform's policy engine. Wrong shape here. A business
decision table is a grid with a hit policy; Rego is a general policy language,
and the gap between "this table has 40 rows" and "this program has 40 branches"
is the gap between exhaustive simulation and hoping the test suite is
representative.

**D. GoRules ZEN.**
Go-native JDM decision tables with a graphical editor. The closest product to
what is built here, and the natural migration target if authoring becomes the
constraint — see the trigger below.

**E. An internal decision-table library, governed.**
A versioned table of priority-ordered rules over typed conditions, evaluated
first-match, with simulation, an execution trace stored per decision, and
four-eyes publication.

## Decision

**Option E**, and the reason is narrower than "we prefer our own code".

For this platform's rules — copay bands, triage routing, eligibility, approval
thresholds — the useful shape is a decision table, and a decision table is small
enough that the interesting engineering is not in evaluating it. It is in
refusing the tables that cannot be explained later. The internal library refuses
things the products permit:

- **Ambiguous precedence is a validation error.** Two rules at the same priority
  are rejected at authoring time. Most engines resolve the tie by some documented
  order, which is deterministic and still not what the author meant; the
  resulting decision is defensible and inexplicable.
- **A type mismatch is a miss, never a coerced guess.** Comparing the string
  `"5"` to the number `5` does not match. Coercion is convenient exactly until a
  patient's record has a number where a code was expected.
- **Evaluation order is total and independent of authoring order.** Priority,
  then ID. Nothing depends on map iteration or file order.
- **A published version is immutable.** A change is a new version, effective-
  dated, so a decision made in March is explained with March's rules.

And the governance those criteria actually require:

- **Four eyes, in the SQL.** `created_by <> published_by` is a predicate on the
  publish statement, not a check in Go, so no future caller can reach the table
  without it. It follows the master-data approval precedent rather than
  inventing a second pattern.
- **Draft rejects an invalid table.** Not only publish — a draft that cannot
  evaluate should be caught while its author is looking at it, rather than after
  a reviewer has approved something that never worked.
- **Every evaluation is logged with its trace**, against the exact version that
  produced it. The outcome alone would make replay a comparison against an
  assertion; the trace is the evidence.
- **Tenant override with platform fallback.** A tenant's published version beats
  the platform default, and a tenant without one inherits it — otherwise a
  platform-wide rule change would require every tenant to publish a copy.

## Evidence

| Criterion | Evidence |
|---|---|
| Determinism | `TestEvaluationIsRepeatable`, `TestEvaluationIsIndependentOfAuthoringOrder`, `TestFirstMatchByPriorityWins`, `TestTypeMismatchIsAMissNotAGuess` |
| Versioning | `TestTheVersionInForceDependsOnTheInstant` — March resolves v1, August resolves v2, and a date before anything was published resolves **nothing** rather than the earliest version |
| Simulation | `TestSimulateReportsAssertionOutcomes`, `TestSimulateReportsUncoveredRules` — a rule no case reaches is reported, because an unreachable rule is usually a bug in the table |
| Explainability | `TestTraceExplainsEveryConsideredRule` — the trace carries the actual value compared, not just the verdict |
| Replay | `TestEvaluationIsLoggedAndReplayable`, `TestReplayUsesTheVersionThatMadeTheDecisionNotTheCurrentOne`, `TestReplayDetectsARuleSetEditedInPlace` |
| Governance | `TestAnAuthorCannotPublishTheirOwnRuleSet`, `TestPublishingTwiceIsRefused`, `TestAnInvalidTableIsRefusedAtDraft`, `TestATenantVersionOverridesThePlatformDefault` |

Two of these are worth naming specifically.

`TestReplayUsesTheVersionThatMadeTheDecisionNotTheCurrentOne` is the whole point
of the decision log. It publishes v1 in March, records a decision, publishes v2
in July, and then proves that March's decision still reproduces exactly — against
March's rules, not today's. Replaying against the current version would be a
comparison that tells you nothing about what happened.

The four-eyes predicate was fault-injected to confirm the test bites: removing
`created_by <> published_by` from the statement makes
`TestAnAuthorCannotPublishTheirOwnRuleSet` fail rather than pass vacuously.

## Coupling with ADR-006

These two decisions are more linked than they look. Camunda 8 would bring BPMN
*and* DMN on one runtime, so "a process owner must author a workflow" and "an
analyst must author a rule table" are, in that world, one adoption rather than
two.

Recorded here so the second decision is not made in isolation: if ADR-006
reopens toward Camunda, ADR-007 should be re-evaluated in the same breath, and
DMN becomes materially cheaper than it looks today. If ADR-006 reopens toward
Temporal, ADR-007 is untouched by it and GoRules ZEN is the closer target.

## Reopening triggers

1. **A non-engineer must author rules.** The table format is JSON and a grid,
   but there is no editor, and a rule change is a deploy. When a finance or
   clinical analyst needs to change a copay band on a Tuesday, a product with an
   authoring UI is the answer — DMN if ADR-006 went to Camunda, GoRules ZEN
   otherwise. Migration is a translation rather than a rewrite: priority-ordered
   first-match rules over typed conditions map onto a DMN decision table with
   hit policy **P**.
2. **Rules must chain.** A rule whose output is another rule's input, across
   tables. First-match over one table stops being the right model, and a
   forward-chaining engine earns its cost.
3. **Rule authoring outgrows review.** Hundreds of tables, or tables changing
   several times a week, where simulation coverage and a diff view stop being
   something a code review can carry.

None of these are capacity triggers, which is the difference from ADR-005 and
ADR-006. Evaluating a decision table is microseconds; this will never be
reopened because it is slow.

## Consequences

**Good**

- No second runtime, no network hop in a decision path, no JVM.
- Determinism is a property the code refuses to violate, not a configuration
  setting: ambiguous precedence and type coercion are rejected outright.
- Every decision is reproducible from the database alone — version, input,
  outcome and trace, all in the same PostgreSQL as the decision it justified.
- Governance matches the platform's existing four-eyes pattern rather than a
  product's.

**Costs**

- **No authoring UI.** A rule change is a code change, reviewed and deployed.
  This is trigger 1, and it is the one that will fire.
- **No chaining, no expression language.** Conditions are typed comparisons.
  Anything more complex is a service, not a rule — which is a defensible line to
  hold and occasionally an inconvenient one.
- **Simulation coverage is only as good as the cases written.** The report names
  rules no case reached; it cannot invent the case.
- **We own the correctness.** A determinism bug here is ours, and it is the kind
  that surfaces as an inexplicable historical decision rather than as a failing
  test. The pure-function design and the stored trace are the mitigations.

## Verification

- `internal/platform/rules/rules_test.go` — determinism, ordering, typed
  comparison, trace.
- `internal/platform/rules/simulation_test.go` — simulation, coverage,
  tamper-detecting replay.
- `internal/platform/rules/store_test.go` — four-eyes publication, immutability,
  effective dating, tenant override with platform fallback, decision logging and
  replay against the recorded version, all against a real PostgreSQL.
