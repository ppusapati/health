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
| P0-04 | PostgreSQL / sqlc | Implemented | 10 migrations, sqlc queries, per-test database harness, expand/contract rules enforced by `tools/migrations` |
| P0-05 | Identity / auth context | Implemented | Session context, RBAC+ABAC, audit, joiner/mover/leaver with session revocation, step-up, risk scoring, federation and workload identity, plus the production OIDC verifier (ADR-008 closed) |
| P0-06 | Event backbone | Implemented | Outbox, inbox dedup, publisher, envelope, plus PostgreSQL-backed fan-out delivery with leases, backoff and dead-lettering, wired into the composition root (ADR-005 closed) |
| P0-07 | Workflow / rules engines | Implemented | Durable engine with per-instance version migration, multi-replica safety and an operator surface; deterministic rules with four-eyes publication, effective dating and a replayable decision log. ADR-006 and ADR-007 closed |
| P0-08 | SvelteKit shell | Implemented | AppShell, context banner, generated client, facility screen, error/permission states |
| P0-09 | Flutter shell | Implemented | Generated Dart clients, Connect transport, session, offline queue, shell UI. Platform bindings wired at the composition point and verified: Android Keystore via EncryptedSharedPreferences (minSdk pinned to 23, which the option requires), iOS Keychain bound to the device and gated on first unlock, atomic file-backed queue that survives a kill |
| P0-10 | Observability | Implemented | Tracing, correlation propagation, PHI-safe logging, and OTLP export to the collector the manifests already named. Parent-based ratio sampling, service/version/environment on the resource, flush on shutdown. Tested against a real in-process OTLP receiver |
| P0-11 | DevSecOps | Implemented | Lint, vet, codegen drift, proto compatibility, plus a Security workflow: gitleaks, gosec, govulncheck, npm audit, syft SBOM, trivy image and IaC. Release workflow signs the image keyless (cosign/Sigstore), attests SLSA provenance and the image SBOM, and verifies its own output; manifests pin every image by digest and a Kyverno policy refuses an unsigned one at admission |
| P0-12 | Deployment platform | **Partial** | Distroless image, kustomize base + 3 overlays, network policy, PDB, backup-with-restore-verification. No cluster deploy executed |
| P0-13 | Hospital edge prototype | Implemented | Enrollment, durable store-and-forward, local labelling, idempotent cloud ingest |
| P0-14 | Architecture fitness tests | Implemented | FIT-01, FIT-02, FIT-03, FIT-06, FIT-08 plus layering rules |

## Architecture gates

| Gate | Criterion | State | Evidence |
|---|---|---|---|
| A1 | Request flows client → RPC → application → domain → sqlc → PostgreSQL with trace and audit | **Pass** | `TestMilestone1_EndToEndTransaction` |
| A2 | Tenant A cannot read/write Tenant B data | **Pass (API, repository, events, audit)** | `milestone2_isolation_test.go` — cache, search and object store are not yet in the stack |
| A3 | State + outbox commit and inbox dedup survive retry/crash | **Pass** | `TestOutboxRollsBackWithItsTransaction`, `TestInboxDeduplicatesRedelivery`, workflow retry/compensation suite, plus the delivery suite against the chosen transport (ADR-005): `TestACrashedConsumerReleasesItsMessage`, `TestAnEventSurvivesTheConsumerRestarting`, `TestAFailedDeliveryIsRetried`, poison-message dead-lettering |
| A4 | Proto breaking-change protection and generated SDKs in CI | **Pass** | `proto-compatibility` and `generated-code` jobs; Go, TypeScript and Dart clients all generated from `proto/` |
| A5 | OIDC/MFA/session/workload identity in non-production | **Pass** | ADR-008 closed: per-tenant OIDC federation verified in-process, ACR-based step-up, revocation watermark, workload identity. `internal/identity_access/adapters/oidc` against a live test provider over TLS |
| A6 | Trace crosses client/RPC/DB/event without raw PHI | **Pass** | `observability_test.go` |
| A7 | Migration strategy supports rolling expand/contract | **Pass** | `tools/migrations` refuses a contracting change that does not name the migration that expanded, and a NOT NULL column with no default. Every migration carries Trace, Rollback and Reconciliation notes |
| A8 | Kubernetes deploy, secret rotation, backup/restore smoke | **Partial** | Manifests render and schema-validate; invariants tested in `tools/infra` including encryption-at-rest key references and TLS_MODE per overlay; image builds. Rotation and DR drills are written as runbooks but **have not been executed** — no cluster deploy has happened |
| A9 | Svelte and Flutter consume the same contracts | **Pass** | Both generated from `proto/`; `connect_client_test.dart` asserts the procedure path matches the proto package |
| A10 | Fitness tests block forbidden imports and cross-schema writes | **Pass** | `tools/fitness` |
| A11 | Broker and workflow/rules ADRs closed after PoC | **Pass** | All three closed with the evidence the register asks for: [ADR-005](../adr/0005-event-broker.md) (benchmark + working transport), [ADR-006](../adr/0006-durable-workflow-engine.md) (reference long-running workflow + version upgrade test + multi-replica test), [ADR-007](../adr/0007-rules-engine.md) (decision-table reference implementation + replay). Each names its reopening triggers; ADR-006 is closed for Waves 1–6 and reopens unconditionally at Wave 7, which owns SRS-BPM-* |
| A12 | Edge/OT trust-zone pattern approved | **Pass (edge); OT not built** | Security review at [`edge-ot-security-review.md`](edge-ot-security-review.md): the edge pattern is approved with named deployment requirements. Two findings fixed (node authentication is now an unforgeable `PeerFingerprint`; enrollment tokens are minted, bounded and redacted), one mitigated with residual risk accepted (unencrypted local queue, now retention-bounded). The OT/DMZ half is **not reviewed because it is not built** — Wave 7 SCADA and Wave 9 SRS-ONB-DEV own it |

## Open seams

Every blocking ADR had a one-interface seam so Wave-1 work could proceed
without binding to a vendor. All four are now closed, and the seams stay — they
are what the reopening triggers in each ADR act through.

| ADR | Seam | Location | State |
|---|---|---|---|
| ADR-005 event broker | `store.Broker` | `internal/platform/store/publisher.go` | **Closed** — `store.PgBroker` implements it |
| ADR-006 workflow engine | `workflow.Definition` / `workflow.Step` | `internal/platform/workflow/definition.go` | **Closed for Waves 1–6**; reopens at Wave 7 |
| ADR-007 rules engine | `rules.Table` | `internal/platform/rules/rules.go` | **Closed** |
| ADR-008 identity provider | `transport.TokenVerifier` | `internal/platform/transport/interceptor.go` | **Closed** — `oidc.Verifier` implements it |

No downstream code moved for any closure, which is the evidence that the seams
were drawn in the right place.

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
| SRS-IAM | 15 | Implemented, including the production OIDC verifier (ADR-008 closed) |
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
| Go | 701 tests across 39 packages | `make test` |
| Web (unit) | 85 tests across 8 files | `cd apps/web && npm test` |
| Web (browser) | accessibility and cross-browser smoke, 3 browser profiles | `make web-a11y`, `make web-browsers` |
| Flutter | 54 tests | `make mobile-test` |

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

## What is still open

Two items, and both need a cluster rather than more code:

| Item | Why it cannot close here |
|---|---|
| P0-12 / A8 — cluster deploy, secret rotation, DR drill | Manifests render, schema-validate and have their invariants tested without a cluster, and the image builds. "It runs" is a different claim, and so is "the rotation runbook works" — both require an environment to run in. The runbooks exist; they have not been executed. |
| SRS-SEC-013, SRS-NFR-005, SRS-SEC-002 | A penetration test, a disaster-recovery drill and a key-rotation drill. Each is an activity, not an artefact; `make release-gate` refuses a production release until the pentest engagement is registered, which is the control working. |

Everything else that was previously **Partial** is now implemented and tested.
Gate A12 is a partial pass by design rather than by omission: the edge pattern
is approved, and the OT half is not reviewed because it is not built.

## Wave-1 readiness

The Development Backlog lists eleven foundations Wave 1 needs before the Core
Clinical team can start. Current state:

- Monorepo + CI — ready
- Proto generation — ready
- Go architecture template — ready
- PostgreSQL/sqlc migrations — ready, with expand/contract rules enforced
- Tenant context — ready
- Authentication — ready; per-tenant OIDC federation verified in-process
  (ADR-008), with lifecycle, revocation, step-up, federation mapping and
  workload identity around it
- Authorization baseline — ready, plus module entitlements enforced at the wire
- Audit framework — ready, plus a tamper-evident security event chain
- Svelte shell — ready, with accessibility and cross-browser gates in CI
- Observability baseline — ready, exporting to the collector
- Testing/traceability framework — ready

Wave 1 (EMPI first, per the backlog's vertical-slice sequence) can begin against
the established patterns. The horizontal capabilities Wave 1 will reach for —
effective dating, numbering sequences, calendars, labels, maker/checker
approval, entitlements, jobs, projections — are built and tested, so a clinical
context consumes them rather than inventing its own. Event delivery is wired
end to end, so a Wave-1 module registers a consumer rather than building one.

No blocking ADR remains open. The workflow and rules engines are decided for
Waves 1–6 and each names what reopens it, so a Wave-1 slice that reaches for
either consumes a finished implementation rather than a placeholder.
