# Wave 0 — implementation status

Wave 0 owns **109 atomic requirements** across SRS-PLT, SRS-IAM, SRS-WEB,
SRS-API, SRS-DAT, SRS-SEC and SRS-NFR.

Nothing below is claimed as `Verified` in the RTM sense. Verification requires
the concrete test cases named in the Master RTM to pass and be reviewed; what
this document records is which P0 items have working, tested implementations.

## P0 backlog

| Item | Capability | State | Notes |
|---|---|---|---|
| P0-01 | Monorepo / bootstrap | Implemented | Structure per Blueprint §16; pinned toolchain; Makefile; CI |
| P0-02 | Protobuf / ConnectRPC | Implemented | 4 packages, buf lint + breaking checks, Go and TS clients generated |
| P0-03 | Go service skeleton | Implemented | transport → application → domain → ports → adapters, with txn + outbox helpers |
| P0-04 | PostgreSQL / sqlc | Implemented | 8 migrations, sqlc queries, per-test database harness, expand/contract rules enforced by `tools/migrations` |
| P0-05 | Identity / auth context | **Partial** | Session context, RBAC+ABAC, audit, joiner/mover/leaver with session revocation, step-up, risk scoring, federation and workload identity complete. The OIDC *verifier* is blocked on ADR-008 |
| P0-06 | Event backbone | **Partial** | Outbox, inbox dedup, publisher, envelope complete. Broker blocked on ADR-005 |
| P0-07 | Workflow / rules PoC | Implemented | Durable engine + deterministic rules harness; ADR-006/007 evidence produced |
| P0-08 | SvelteKit shell | Implemented | AppShell, context banner, generated client, facility screen, error/permission states |
| P0-09 | Flutter shell | **Partial** | Generated Dart clients, Connect transport, session, offline queue, shell UI. Keystore and durable queue bindings outstanding |
| P0-10 | Observability | **Partial** | Tracing, correlation propagation, PHI-safe logging. Collector export not wired |
| P0-11 | DevSecOps | Implemented | Lint, vet, codegen drift, proto compatibility, plus a Security workflow: gitleaks, gosec, govulncheck, npm audit, syft SBOM, trivy image and IaC. Image signing not added |
| P0-12 | Deployment platform | **Partial** | Distroless image, kustomize base + 3 overlays, network policy, PDB, backup-with-restore-verification. No cluster deploy executed |
| P0-13 | Hospital edge prototype | Implemented | Enrollment, durable store-and-forward, local labelling, idempotent cloud ingest |
| P0-14 | Architecture fitness tests | Implemented | FIT-01, FIT-02, FIT-03, FIT-06, FIT-08 plus layering rules |

## Architecture gates

| Gate | Criterion | State | Evidence |
|---|---|---|---|
| A1 | Request flows client → RPC → application → domain → sqlc → PostgreSQL with trace and audit | **Pass** | `TestMilestone1_EndToEndTransaction` |
| A2 | Tenant A cannot read/write Tenant B data | **Pass (API, repository, events, audit)** | `milestone2_isolation_test.go` — cache, search and object store are not yet in the stack |
| A3 | State + outbox commit and inbox dedup survive retry/crash | **Partial** | `TestOutboxRollsBackWithItsTransaction`, `TestInboxDeduplicatesRedelivery`, workflow retry/compensation suite. Full crash test needs a real broker (ADR-005) |
| A4 | Proto breaking-change protection and generated SDKs in CI | **Pass** | `proto-compatibility` and `generated-code` jobs; Go, TypeScript and Dart clients all generated from `proto/` |
| A5 | OIDC/MFA/session/workload identity in non-production | **Blocked** | ADR-008 |
| A6 | Trace crosses client/RPC/DB/event without raw PHI | **Pass** | `observability_test.go` |
| A7 | Migration strategy supports rolling expand/contract | **Pass** | `tools/migrations` refuses a contracting change that does not name the migration that expanded, and a NOT NULL column with no default. Every migration carries Trace, Rollback and Reconciliation notes |
| A8 | Kubernetes deploy, secret rotation, backup/restore smoke | **Partial** | Manifests render and schema-validate; invariants tested in `tools/infra` including encryption-at-rest key references and TLS_MODE per overlay; image builds. Rotation and DR drills are written as runbooks but **have not been executed** — no cluster deploy has happened |
| A9 | Svelte and Flutter consume the same contracts | **Pass** | Both generated from `proto/`; `connect_client_test.dart` asserts the procedure path matches the proto package |
| A10 | Fitness tests block forbidden imports and cross-schema writes | **Pass** | `tools/fitness` |
| A11 | Broker and workflow/rules ADRs closed after PoC | **Evidence ready, decision outstanding** | Workflow and rules PoCs produce the evidence ADR-006/007 require; broker PoC (ADR-005) still needs a real broker benchmark |
| A12 | Edge/OT trust-zone pattern approved | **Partial** | Edge prototype demonstrates the store-and-forward and enrollment pattern; OT DMZ and SCADA gateway not built, and the pattern has not been through security review |

## Open seams

Each blocking ADR has a one-interface seam so Wave-1 work can proceed:

| ADR | Seam | Location |
|---|---|---|
| ADR-005 event broker | `store.Broker` | `internal/platform/store/publisher.go` |
| ADR-006 workflow engine | `workflow.Definition` / `workflow.Step` | `internal/platform/workflow/definition.go` |
| ADR-007 rules engine | `rules.Table` | `internal/platform/rules/rules.go` |
| ADR-008 identity provider | `transport.TokenVerifier` | `internal/platform/transport/interceptor.go` |

## Audit

A full implementation audit was run before Wave 1 — security review, requirement
traceability, gate evidence and test quality. Nine findings, one of them HIGH,
were fixed in the same pass. See [`wave-0-audit.md`](wave-0-audit.md).

The audit's headline number at the time was **52 of 109 Wave-0 requirements
traceable in code**, with SRS-SEC at 2/14.

## Requirement coverage

All 109 Wave-0 requirements now have an implementation that names them, and
each requirement's own verification clause is what its tests assert rather than
a paraphrase. Measured by matching every `SRS-*` identifier in the registry
against the implementation tree:

| Family | Count | State |
|---|---|---|
| SRS-PLT | 20 | Implemented |
| SRS-IAM | 15 | Implemented; the OIDC verifier itself is a seam (ADR-008) |
| SRS-WEB | 16 | Implemented |
| SRS-API | 14 | Implemented |
| SRS-DAT | 14 | Implemented |
| SRS-SEC | 14 | Implemented |
| SRS-NFR | 16 | Implemented; two require executed drills, see below |

**This is traceability and passing tests, not RTM `Verified`.** The distinction
matters and is not a formality:

- **Three requirements need something executed, not written.** SRS-SEC-013
  needs a penetration test; SRS-NFR-005 needs a disaster-recovery drill;
  SRS-SEC-002 needs a rotation drill. Runbooks and blocking gates exist for all
  three, and the pentest gate **fails today by design** — `make release-gate`
  refuses a production release because no engagement is registered.
- **Some verification clauses are only partly reachable in Wave 0.** SRS-NFR-002
  measures p95 against a local database with no network between the service and
  PostgreSQL, so the figure is a floor and a regression detector rather than a
  prediction. SRS-WEB-009's automated scan catches roughly a third of WCAG
  failures by construction; the release gate keeps a manual pass for the rest.
- **Nothing here has been deployed to a cluster.** Manifests are validated and
  their invariants tested, and that is a different claim from "it runs".

## Test inventory

| Stack | Count | Command |
|---|---|---|
| Go | 580 tests across 35 packages | `make test` |
| Web (unit) | 85 tests across 8 files | `cd apps/web && npm test` |
| Web (browser) | accessibility and cross-browser smoke, 3 browser profiles | `make web-a11y`, `make web-browsers` |
| Flutter | 44 tests | `make mobile-test` |

Repository tests run against a real PostgreSQL rather than a mock: constraints,
SQLSTATE codes and transaction semantics are what a mock gets wrong, and
several of the controls in this codebase — the one-active-grant index, the
four-eyes UPDATE predicate, the numbering row lock — exist only in the database
and would pass vacuously against a fake.

## Gates that fail on purpose

Three checks are expected to refuse today, and each refusal is the control
working rather than a defect:

| Gate | Refuses because | Command |
|---|---|---|
| Penetration test (SRS-SEC-013) | No engagement covers a production release | `make release-gate` |
| Risk-acceptance expiry (SRS-SEC-006) | Would refuse an expired acceptance; register is empty | `make test-security` |
| Severity-1 defects (SRS-NFR-015) | Would refuse an open defect; register is empty | `make release-gate` |

## Wave-1 readiness

The Development Backlog lists eleven foundations Wave 1 needs before the Core
Clinical team can start. Current state:

- Monorepo + CI — ready
- Proto generation — ready
- Go architecture template — ready
- PostgreSQL/sqlc migrations — ready, with expand/contract rules enforced
- Tenant context — ready
- Authentication — **seam only** (ADR-008); the lifecycle, revocation, step-up,
  federation mapping and workload identity around it are built
- Authorization baseline — ready, plus module entitlements enforced at the wire
- Audit framework — ready, plus a tamper-evident security event chain
- Svelte shell — ready, with accessibility and cross-browser gates in CI
- Observability baseline — ready (export target not yet configured)
- Testing/traceability framework — ready

Wave 1 (EMPI first, per the backlog's vertical-slice sequence) can begin against
the established patterns. The horizontal capabilities Wave 1 will reach for —
effective dating, numbering sequences, calendars, labels, maker/checker
approval, entitlements, jobs, projections — are built and tested, so a clinical
context consumes them rather than inventing its own. Authentication is the one item where Wave-1 code will
consume a seam rather than a finished implementation; because everything
downstream depends on `authctx.Session` and not on the verifier, closing ADR-008
will not require Wave-1 changes.
