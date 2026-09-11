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
| P0-04 | PostgreSQL / sqlc | Implemented | 3 migrations, sqlc queries, per-test database harness |
| P0-05 | Identity / auth context | **Partial** | Session context, RBAC+ABAC, audit complete. OIDC/MFA blocked on ADR-008 |
| P0-06 | Event backbone | **Partial** | Outbox, inbox dedup, publisher, envelope complete. Broker blocked on ADR-005 |
| P0-07 | Workflow / rules PoC | Not started | Blocked on ADR-006 |
| P0-08 | SvelteKit shell | Implemented | AppShell, context banner, generated client, facility screen, error/permission states |
| P0-09 | Flutter shell | Not started | |
| P0-10 | Observability | **Partial** | Tracing, correlation propagation, PHI-safe logging. Collector export not wired |
| P0-11 | DevSecOps | **Partial** | Lint, vet, codegen drift, proto compatibility. SAST/SCA/SBOM/signing not added |
| P0-12 | Deployment platform | Not started | |
| P0-13 | Hospital edge prototype | Not started | |
| P0-14 | Architecture fitness tests | Implemented | FIT-01, FIT-02, FIT-03, FIT-06, FIT-08 plus layering rules |

## Architecture gates

| Gate | Criterion | State | Evidence |
|---|---|---|---|
| A1 | Request flows client → RPC → application → domain → sqlc → PostgreSQL with trace and audit | **Pass** | `TestMilestone1_EndToEndTransaction` |
| A2 | Tenant A cannot read/write Tenant B data | **Pass (API, repository, events, audit)** | `milestone2_isolation_test.go` — cache, search and object store are not yet in the stack |
| A3 | State + outbox commit and inbox dedup survive retry/crash | **Partial** | `TestOutboxRollsBackWithItsTransaction`, `TestInboxDeduplicatesRedelivery`. Full crash test needs a real broker (ADR-005) |
| A4 | Proto breaking-change protection and generated SDKs in CI | **Pass (Go, TS)** | `proto-compatibility` and `generated-code` jobs. Dart pending P0-09 |
| A5 | OIDC/MFA/session/workload identity in non-production | **Blocked** | ADR-008 |
| A6 | Trace crosses client/RPC/DB/event without raw PHI | **Pass** | `observability_test.go` |
| A7 | Migration strategy supports rolling expand/contract | **Partial** | Forward/rollback files exist; no rolling-deploy compatibility test yet |
| A8 | Kubernetes deploy, secret rotation, backup/restore smoke | **Not started** | P0-12 |
| A9 | Svelte and Flutter consume the same contracts | **Partial** | Svelte does; Flutter pending P0-09 |
| A10 | Fitness tests block forbidden imports and cross-schema writes | **Pass** | `tools/fitness` |
| A11 | Broker and workflow/rules ADRs closed after PoC | **Blocked** | ADR-005, ADR-006 |
| A12 | Edge/OT trust-zone pattern approved | **Not started** | P0-13 |

## Open seams

Each blocking ADR has a one-interface seam so Wave-1 work can proceed:

| ADR | Seam | Location |
|---|---|---|
| ADR-005 event broker | `store.Broker` | `internal/platform/store/publisher.go` |
| ADR-006 workflow engine | none yet | — |
| ADR-008 identity provider | `transport.TokenVerifier` | `internal/platform/transport/interceptor.go` |

## Wave-1 readiness

The Development Backlog lists eleven foundations Wave 1 needs before the Core
Clinical team can start. Current state:

- Monorepo + CI — ready
- Proto generation — ready
- Go architecture template — ready
- PostgreSQL/sqlc migrations — ready
- Tenant context — ready
- Authentication — **seam only** (ADR-008)
- Authorization baseline — ready
- Audit framework — ready
- Svelte shell — ready
- Observability baseline — ready (export target not yet configured)
- Testing/traceability framework — ready

Wave 1 (EMPI first, per the backlog's vertical-slice sequence) can begin against
the established patterns. Authentication is the one item where Wave-1 code will
consume a seam rather than a finished implementation; because everything
downstream depends on `authctx.Session` and not on the verifier, closing ADR-008
will not require Wave-1 changes.
