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
| P0-09 | Flutter shell | Implemented | Generated Dart clients, Connect transport, session, offline queue, shell UI. Platform bindings wired at the composition point and verified: Android Keystore via EncryptedSharedPreferences (minSdk pinned to 23, which the option requires), iOS Keychain bound to the device and gated on first unlock, atomic file-backed queue that survives a kill. The SRS-WEB foundation family is now present on this shell too, not only the web one — see the note under the family table |
| P0-10 | Observability | Implemented | Tracing, correlation propagation, PHI-safe logging, and OTLP export to the collector the manifests already named. Parent-based ratio sampling, service/version/environment on the resource, flush on shutdown. Tested against a real in-process OTLP receiver |
| P0-11 | DevSecOps | Implemented | Lint, vet, codegen drift, proto compatibility, plus a Security workflow: gitleaks, gosec, govulncheck, npm audit, syft SBOM, trivy image and IaC. Release workflow signs the image keyless (cosign/Sigstore), attests SLSA provenance and the image SBOM, and verifies its own output; manifests pin every image by digest and a Kyverno policy refuses an unsigned one at admission |
| P0-12 | Deployment platform | **Partial** | Distroless image, kustomize base + 3 overlays, network policy, PDB, and a backup-with-restore-verification job that has now been executed against a real PostgreSQL (DRILL-2026-002). No cluster deploy executed — see [What is still open](#what-is-still-open) for why that is an environment limit rather than an omission |
| P0-13 | Hospital edge prototype | Implemented | Enrollment, durable store-and-forward, local labelling, idempotent cloud ingest |
| P0-14 | Architecture fitness tests | Implemented | FIT-01, FIT-02, FIT-03, FIT-06, FIT-08 plus layering rules |

## Architecture gates

| Gate | Criterion | State | Evidence |
|---|---|---|---|
| A1 | Request flows client → RPC → application → domain → sqlc → PostgreSQL with trace and audit | **Pass** | `TestMilestone1_EndToEndTransaction` |
| A2 | Tenant A cannot read/write Tenant B data | **Pass (API, repository, events, audit, object store)** | `milestone2_isolation_test.go`. The object store joined the stack in Wave 1 (SRS-DAT-007) and is now inside the boundary rather than beside it: a cross-tenant read is `ErrNotFound` rather than forbidden, a cross-tenant delete does nothing and the owner's object survives it, byte-identical content in two tenants is two objects under two tenant prefixes, and a zero scope fails closed at `Put`, `Get` and `Delete`. Each assertion was checked for sensitivity by re-running it with the owning tenant in the attacker's place, and each failed as it must. **Cache and search are still not in the stack** — nothing to isolate yet |
| A3 | State + outbox commit and inbox dedup survive retry/crash | **Pass** | `TestOutboxRollsBackWithItsTransaction`, `TestInboxDeduplicatesRedelivery`, workflow retry/compensation suite, plus the delivery suite against the chosen transport (ADR-005): `TestACrashedConsumerReleasesItsMessage`, `TestAnEventSurvivesTheConsumerRestarting`, `TestAFailedDeliveryIsRetried`, poison-message dead-lettering |
| A4 | Proto breaking-change protection and generated SDKs in CI | **Pass** | `proto-compatibility` and `generated-code` jobs; Go, TypeScript and Dart clients all generated from `proto/` |
| A5 | OIDC/MFA/session/workload identity in non-production | **Pass** | ADR-008 closed: per-tenant OIDC federation verified in-process, ACR-based step-up, revocation watermark, workload identity. `internal/identity_access/adapters/oidc` against a live test provider over TLS |
| A6 | Trace crosses client/RPC/DB/event without raw PHI | **Pass** | `observability_test.go` |
| A7 | Migration strategy supports rolling expand/contract | **Pass** | `tools/migrations` refuses a contracting change that does not name the migration that expanded, and a NOT NULL column with no default. Every migration carries Trace, Rollback and Reconciliation notes |
| A8 | Kubernetes deploy, secret rotation, backup/restore smoke | **Pass** | The manifests apply to a real API server (`make manifests-admission`) **and the workload runs under kubelet** (`make cluster-deploy`): the dev overlay rolls out to 1/1 with the security context read back off the running Pod, both probes answer on their real paths, the Milestone-1 slice and the Milestone-2 denial hold through the Service, the disruption budget and both network policies are in effect, and pod security refuses a privileged pod in the same namespace. The rotation, backup and DR drills were executed against the real binary and a real PostgreSQL, and a rolling update under load (DRILL-2026-004) now covers the cluster behaviour they could not. Seven defects from the drills, three more from the deploy, one more from the rollout |
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

**This table used to count identifiers, and it was wrong.** It reported each of
the seven families "Implemented" on the strength of every `SRS-*` id appearing
somewhere in the tree. An id appears in a trace header whether or not the thing
it names was built, so four requirements read as implemented while nothing
implemented them — among them a bed and room master that the ICU, emergency and
housekeeping contexts were later built on top of. Nothing caught it because
`tools/parity/traceability.py` read only the Wave-1 and Wave-2 documents; this
one it never opened.

The table below is per requirement, a test names each one it claims, and this
document is now in `STATUS_DOCS`, so the gate holds it the way it holds the
other two. 105 of the 109 are implemented and tested, five of those partially;
four are not built and say so.

| ID | Requirement | State |
|---|---|---|
| SRS-PLT-001 | Tenant with immutable id, jurisdiction, locale, time zone | **Implemented** — the milestone-1 transaction creates one and scopes its children to it |
| SRS-PLT-002 | Hierarchy Tenant → Legal Entity → Region → Facility → Department → Room/Bed/Store | **Partial** — tenant, facility and effective-dated org units below a facility. Legal entity, region, room, bed and store are not modelled; a deployment whose legal entities differ from its tenants has nowhere to say so |
| SRS-PLT-004 | Facility type, address, contact, licences, operating hours, identifiers | **Partial** — type, status, time zone and operating hours, which scheduling reads. No address, contact, licence or registration identifier, so billing and printed documents cannot carry what a facility is legally required to print on them |
| SRS-PLT-006 | Bed and room class, gender/isolation capability, operational status, charge mapping | **Not built** — there is no bed or room master anywhere. `housekeeping.bed_hold` and the ICU and emergency contexts reference beds by free identifier, and `billing.*.room_class` is free text with nothing behind it, which is the charge mapping this requirement was supposed to supply. The organization contract traces it; that trace line is now removed |
| SRS-PLT-019 | Global reference data separated from tenant-owned configuration | **Not built** — traced to migration 0001, which separates bounded-context schemas. That is a different separation: every table there is tenant-owned. There is no platform-owned catalogue, so there is nothing a platform role is needed to change |
| SRS-IAM-005 | Break-glass with reason capture, elevated audit and review notification | **Implemented** — as emergency grants in `security_platform`: justification and incident reference required, bounded TTL, expiry independent of the sweeper, self-review refused, the access list append-only and the review's subject matter |
| SRS-IAM-011 | Active sessions and devices, with self-revocation | **Partial** — revocation works and is monotonic: a revoked session is refused at its next validation despite a signed, unexpired token. There is no surface for a user to see their own sessions or end one, which is the "self" in self-revocation |
| SRS-WEB-003 | Display active tenant/facility/department/patient/encounter context | **Partial** — the context bar is present and tested on both shells. The requirement's other half, that a context switch is explicit and cannot silently carry patient context, has no switch to test: context arrives with the session |
| SRS-DAT-012 | Sensitive fields support encryption or masking where the threat model requires | **Partial** — encryption at rest for objects, with the managed key recorded in the metadata, and masking at read time for restricted clinical content. No column-level encryption, so a database operator sees the columns |
| SRS-NFR-009 | Failed async workflows retryable and replayable, with an operator-visible exception queue | **Partial** — retry is per event rather than per batch and the inbox makes redelivery idempotent, so a retry does not duplicate a clinical or financial action. `attempts` and `last_error` are recorded but nothing surfaces them: there is no queue an operator can look at |
| SRS-API-001 | Define canonical internal service contracts in Protobuf; generated clients/servers are version-controlled artifacts | **Implemented** |
| SRS-API-002 | Use package versioning such as domain.v1; additive-compatible evolution is preferred | **Implemented** |
| SRS-API-003 | Every state-changing RPC accepts request/correlation metadata and idempotency key where retry could duplicate business action | **Implemented** |
| SRS-API-004 | Return structured domain error codes independent of display message | **Implemented** |
| SRS-API-005 | Enforce authn/authz in shared interceptors plus domain-specific policy in use case | **Implemented** |
| SRS-API-006 | Handlers perform transport mapping/validation only; business rules reside in application/domain layers | **Implemented** |
| SRS-API-007 | Repository interfaces are defined by consuming domain; sqlc implementation remains infrastructure concern | **Implemented** |
| SRS-API-008 | Use transaction boundaries in application layer and transactional outbox for externally visible domain events | **Implemented** |
| SRS-API-009 | Protect PII/PHI in logs through structured allowlisted logging | **Implemented** |
| SRS-API-010 | Support deadlines/timeouts and cancellation propagation | **Implemented** |
| SRS-API-011 | Use asynchronous job/workflow for exports, bulk imports and long-running integrations | **Implemented** |
| SRS-API-012 | Expose FHIR/REST/vendor gateways separately from internal domain contracts | **Implemented** |
| SRS-API-013 | Contract test suite covers backward compatibility and permission/error semantics | **Implemented** |
| SRS-API-014 | Propagate trace context across ConnectRPC, events and outbound adapters | **Implemented** |
| SRS-DAT-001 | PostgreSQL is system of record for Phase-1 transactional data; each bounded context owns its tables | **Implemented** |
| SRS-DAT-002 | Use sqlc-generated typed queries with reviewed SQL; dynamic SQL is limited to justified search/report patterns | **Implemented** |
| SRS-DAT-003 | Financial, inventory and signed clinical records use append/amend/reversal semantics | **Implemented** |
| SRS-DAT-004 | Store all timestamps in unambiguous instant form plus source timezone/local-time metadata where clinically/legal material | **Implemented** |
| SRS-DAT-005 | Use database constraints for invariants that can be expressed safely: foreign keys, uniqueness, non-null, check constraints | **Implemented** |
| SRS-DAT-006 | Schema migrations use expand/contract for rolling releases and are automated/tested | **Implemented** |
| SRS-DAT-007 | Object/blob content is stored in encrypted object store; relational DB stores metadata, hash, classification and reference | **Implemented** |
| SRS-DAT-008 | Search index and analytics stores are derivative/rebuildable; they are never legal source of truth | **Implemented** |
| SRS-DAT-009 | Maintain retention/archival class metadata and legal hold capability | **Implemented** |
| SRS-DAT-010 | Partition high-volume tables only on measured/forecast workload with documented key and retention plan | **Implemented** |
| SRS-DAT-011 | Backups are encrypted and restore is tested on schedule | **Implemented** |
| SRS-DAT-013 | Every migration includes forward, rollback/mitigation and data-reconciliation notes | **Implemented** |
| SRS-DAT-014 | CDC/event replication for analytics must exclude or tokenize fields not required downstream | **Implemented** |
| SRS-IAM-001 | Authenticate through standards-based identity provider with MFA policy configurable by role/risk | **Implemented** |
| SRS-IAM-002 | Issue short-lived access credentials and rotate/refresh according to policy; browser must not persist long-lived secrets in local storage | **Implemented** |
| SRS-IAM-003 | Define roles and permissions by bounded-context action, not only menu visibility | **Implemented** |
| SRS-IAM-004 | Evaluate ABAC conditions including tenant, facility, department, assigned care team, patient relationship, encounter, purpose-of-use and time | **Implemented** |
| SRS-IAM-006 | Support joiner/mover/leaver lifecycle and immediate session revocation | **Implemented** |
| SRS-IAM-007 | Support service-to-service identities using mTLS/workload identity or equivalent | **Implemented** |
| SRS-IAM-008 | Audit successful/failed authentication, MFA changes, privilege changes, break-glass and sensitive exports | **Implemented** |
| SRS-IAM-009 | Support SSO federation for enterprise customers | **Implemented** |
| SRS-IAM-010 | Enforce idle and absolute session timeout by risk profile | **Implemented** |
| SRS-IAM-012 | Require step-up authentication for privileged security, bulk export and destructive administrative actions | **Implemented** |
| SRS-IAM-013 | Protect against privilege escalation through user-controlled tenant/facility identifiers | **Implemented** |
| SRS-IAM-014 | Provide read-only auditor role that cannot mutate clinical/financial records | **Implemented** |
| SRS-IAM-015 | Risk-score abnormal login/session behavior and alert security team | **Implemented** |
| SRS-NFR-001 | Core Phase-1 SaaS premium profile target 99.95% monthly availability excluding contractually defined maintenance | **Implemented** |
| SRS-NFR-002 | Typical interactive internal RPC p95 target <400 ms within deployment region excluding external dependencies | **Implemented** |
| SRS-NFR-003 | Architecture supports horizontal API/workflow workers and independently scalable high-load bounded contexts | **Implemented** |
| SRS-NFR-004 | Appointment booking, MRN sequence, payments and finalization are concurrency-safe | **Implemented** |
| SRS-NFR-005 | Proposed core enterprise target RPO ≤5 min and RTO ≤60 min subject to contracted deployment profile | **Implemented** |
| SRS-NFR-006 | All critical workflows expose metrics, traces, structured logs and business-state backlog indicators | **Implemented** |
| SRS-NFR-007 | Patient and major staff journeys target WCAG 2.2 AA | **Implemented** |
| SRS-NFR-008 | Support locale/timezone/currency/multilingual labels without duplicating business logic | **Implemented** |
| SRS-NFR-010 | Architecture boundaries enforced through package/module ownership and CI architecture tests | **Implemented** |
| SRS-NFR-011 | Clinically/financially material history is reconstructable from source records, versions and audit/event references | **Implemented** |
| SRS-NFR-012 | Tenant/patient authorized export uses asynchronous jobs for large scope and produces manifest/checksums | **Implemented** |
| SRS-NFR-013 | Selected edge/mobile workflows can queue operations during transient outage with deterministic conflict resolution | **Implemented** |
| SRS-NFR-014 | Support current enterprise versions of major evergreen browsers per published support matrix | **Implemented** |
| SRS-NFR-015 | No unresolved severity-1 clinical/security/data-integrity defect at production gate | **Implemented** |
| SRS-NFR-016 | Backups and restore evidence are monitored; backup success alone is insufficient without restore test | **Implemented** |
| SRS-PLT-003 | Every tenant-owned database row shall carry tenant scope directly or through an unambiguous parent foreign key enforced by repository access patterns | **Implemented** |
| SRS-PLT-005 | Create departments, specialties, cost centers, service units and care locations with effective dates | **Implemented** |
| SRS-PLT-007 | Support organization-scoped unique codes plus human-readable display names; avoid using names as keys | **Implemented** |
| SRS-PLT-008 | Version master-data changes requiring approval before effective use | **Implemented** |
| SRS-PLT-009 | Allow bulk import/export of master data using validated templates and dry-run mode | **Implemented** |
| SRS-PLT-010 | Emit domain events for approved master-data changes used by downstream caches/search indexes | **Implemented** |
| SRS-PLT-011 | Configure feature/module entitlements per tenant/facility | **Implemented** |
| SRS-PLT-012 | Maintain correlation_id, request_id and actor context for all state-changing requests | **Implemented** |
| SRS-PLT-013 | Provide effective-date evaluation for tariffs, roles, forms, code mappings and policies | **Implemented** |
| SRS-PLT-014 | Support tenant-specific numbering sequences for MRN, encounter, invoice, receipt and other documents | **Implemented** |
| SRS-PLT-015 | Prevent hard deletion of referenced transactional masters; use inactive/retired state | **Implemented** |
| SRS-PLT-016 | Maintain holidays and facility calendars independent of provider rosters | **Implemented** |
| SRS-PLT-017 | Support multilingual display labels and document templates | **Implemented** |
| SRS-PLT-018 | Store configuration provenance: creator, approver, timestamps, reason and prior version | **Implemented** |
| SRS-PLT-020 | Support tenant suspension/read-only states with controlled emergency access policy | **Implemented** |
| SRS-SEC-001 | Encrypt external and inter-service traffic using current secure transport policy | **Implemented** |
| SRS-SEC-002 | Encrypt databases, object storage, backups and secrets at rest using managed keys | **Implemented** |
| SRS-SEC-003 | Use secret manager; no production secrets in source control or container images | **Implemented** |
| SRS-SEC-004 | Audit reads of sensitive records, exports and state-changing actions with actor/purpose/context | **Implemented** |
| SRS-SEC-005 | Rate-limit and abuse-protect public/patient-facing endpoints | **Implemented** |
| SRS-SEC-006 | Generate SBOM and perform dependency, container, IaC, SAST and secret scans in CI/CD | **Implemented** |
| SRS-SEC-007 | Perform threat model for each new high-risk domain/integration | **Implemented** |
| SRS-SEC-008 | Provide secure bulk-export workflow with authorization, step-up, justification, watermarking/classification and expiring download grant | **Implemented** |
| SRS-SEC-009 | Maintain privacy notice/purpose/consent artifacts independently from clinical consent | **Implemented** |
| SRS-SEC-010 | Support configurable retention and data-subject request workflow subject to legal/clinical retention obligations | **Implemented** |
| SRS-SEC-011 | Protect against insecure direct object references by server-side scope checks on every resource ID | **Implemented** |
| SRS-SEC-012 | Implement tamper-evident security/event logging and centralized alerting | **Implemented** |
| SRS-SEC-013 | Penetration test before major production launch and after material security architecture change | **Implemented** |
| SRS-SEC-014 | Define emergency/downtime access and recovery behavior that preserves audit and does not normalize bypass credentials | **Implemented** |
| SRS-WEB-001 | Implement all browser applications in Svelte + SvelteKit + TypeScript using shared design system | **Implemented** |
| SRS-WEB-002 | Use generated ConnectRPC/Protobuf TypeScript clients as canonical API contract bindings | **Implemented** |
| SRS-WEB-004 | Provide role-specific workspace home with worklists, tasks, alerts and quick actions | **Implemented** |
| SRS-WEB-005 | Large worklists use server-side pagination/filter/sort and stable cursor or equivalent | **Implemented** |
| SRS-WEB-006 | All forms expose loading, saved, validation, conflict and failure states | **Implemented** |
| SRS-WEB-007 | Use optimistic UI only where server conflict semantics are defined and rollback is visible | **Implemented** |
| SRS-WEB-008 | Prevent double-submit through disabled state plus idempotency key on eligible mutations | **Implemented** |
| SRS-WEB-009 | Accessibility target WCAG 2.2 AA for patient and major staff workflows | **Implemented** |
| SRS-WEB-010 | No PHI/clinical note text in client telemetry by default | **Implemented** |
| SRS-WEB-011 | Client error surface includes correlation ID suitable for support without exposing stack traces/secrets | **Implemented** |
| SRS-WEB-012 | Unsaved clinical draft warning on navigation/patient switch | **Implemented** |
| SRS-WEB-013 | Saved views and column preferences for operational worklists | **Implemented** |
| SRS-WEB-014 | Date/time display uses facility/user timezone explicitly for clinically material timestamps | **Implemented** |
| SRS-WEB-015 | Security headers, CSRF protections where applicable, CSP and XSS-safe rendering are enforced | **Implemented** |
| SRS-WEB-016 | Clinical print/PDF views use versioned templates and preserve signed-document identity | **Implemented** |

The 99 rows above carry the requirement's own wording rather than a paraphrase,
and one verdict. The evidence behind each is the test that names it: 41 of them
had none until this pass and were checked one at a time against their
verification clause; the rest were cited when they were built. A row is only as
good as its test, which is why the gate's job is to notice when a claim stops
having one — not to decide whether the test was a good one.

**What the four unbuilt ones cost.** SRS-PLT-006 is the one to fix first, and
not because it is a MUST: three contexts already shipped against beds that have
no master, so each of them invented its own idea of what a bed is. That
divergence grows with every context that touches a bed, and the cost of
reconciling it grows with it — this is the SRS-NUR-014 shape, found earlier
rather than later.

**This is traceability and passing tests, not RTM `Verified`.** The distinction
matters and is not a formality:

- **Four requirements need something executed, not written. Three of them now
  have been.** SRS-SEC-002 (credential rotation), SRS-NFR-005 (disaster
  recovery) and SRS-NFR-016 (backup restore verification) have executed drills
  recorded in `security/drill-register.yaml`, with the numbers they measured and
  an explicit statement of what each one did not cover; `tools/security` refuses
  a production release when any of them is more than 120 days old. SRS-SEC-013
  still needs a penetration test, which is an external engagement and cannot be
  manufactured here — the pentest gate **fails today by design**, and
  `make release-gate` refuses a production release because no engagement is
  registered.
- **Some verification clauses are only partly reachable in Wave 0.** SRS-NFR-002
  measures p95 against a local database with no network between the service and
  PostgreSQL, so the figure is a floor and a regression detector rather than a
  prediction. SRS-WEB-009's automated scan catches roughly a third of WCAG
  failures by construction; the release gate keeps a manual pass for the rest.
- **Nothing here has been deployed to a cluster.** Manifests are validated and
  their invariants tested, and that is a different claim from "it runs". The
  reason is an environment limit rather than an omission — see
  [What is still open](#what-is-still-open).

**SRS-WEB-001…016 are assigned to P0-08 *and* P0-09.** They were implemented on
the web shell first and, for a period, only there — the family table said
"Implemented" and was measuring the web. It is a limitation of tracking by
requirement identifier: a requirement assigned to two deliverables reads as met
when either one meets it. The Flutter shell now carries the same family:

| Concern | Module | Requirement |
|---|---|---|
| Time zone display and cross-site comparison | `lib/src/time/display.dart` | SRS-WEB-014 |
| Unsaved-work guard, including backgrounding | `lib/src/drafts/guard.dart` | SRS-CLN-017 on the client |
| Optimistic update policy | `lib/src/api/optimistic.dart` | SRS-WEB-012 |
| Saved views and column preferences | `lib/src/prefs/views.dart` | SRS-WEB-013 |
| Role-specific workspace | `lib/src/workspace/navigation.dart` | SRS-WEB-004 |
| Pagination and incremental loading | `lib/src/api/pagination.dart` | SRS-WEB-010 |
| Printable document identity and reconciliation | `lib/src/print/document.dart` | SRS-WEB-015/016 |
| The seven screen states | `lib/src/ui/states.dart` | SRS-WEB-006 |

Every one of these is reached by the running application rather than merely
present: `test/app_states_test.dart` and the workspace group in
`test/app_shell_test.dart` drive the shell itself. That check exists because
two Wave-0 modules had previously been written, tested and left entirely inert,
which no requirement-level status table can show.

## Test inventory

| Stack | Count | Command |
|---|---|---|
| Go | 1,666 test functions across 48 packages (1,963 cases with subtests) | `make test` |
| Web (unit) | 85 tests across 8 files | `cd apps/web && npm test` |
| Web (browser) | accessibility and cross-browser smoke, 3 browser profiles | `make web-a11y`, `make web-browsers` |
| Flutter | 663 tests | `make mobile-test` |

Repository tests run against a real PostgreSQL rather than a mock: constraints,
SQLSTATE codes and transaction semantics are what a mock gets wrong, and
several of the controls in this codebase — the one-active-grant index, the
four-eyes UPDATE predicate, the numbering row lock — exist only in the database
and would pass vacuously against a fake.

## Gates that fail on purpose

One check refuses today, and that refusal is the control working rather than a
defect:

| Gate | Refuses because | Command |
|---|---|---|
| Penetration test (SRS-SEC-013) | No engagement covers a production release | `make release-gate` |

Three more are armed and pass today only because there is nothing for them to
catch. Each is listed so that a green run is not mistaken for a check that does
not exist:

| Gate | Would refuse | Command |
|---|---|---|
| Drill currency (SRS-SEC-002, SRS-NFR-005, SRS-NFR-016) | A drill more than 120 days old, or a missed target with no remediation reference. All three ran on 2026-09-15 | `make release-gate` |
| Risk-acceptance expiry (SRS-SEC-006) | An expired acceptance; the register is empty | `make test-security` |
| Severity-1 defects (SRS-NFR-015) | An open severity-1 defect; the register is empty | `make release-gate` |

## Drills

The three requirements that are satisfied by an activity rather than an artefact
have been executed, against the real binary and a real PostgreSQL, following the
real runbooks. Harnesses are in `scripts/drills/`, results in
`security/drill-register.yaml`, narrative in [`drill-log.md`](drill-log.md).

| Drill | Requirement | Result |
|---|---|---|
| DRILL-2026-001 credential rotation | SRS-SEC-002 | **met** — 433 requests through a full rotation, zero failed |
| DRILL-2026-002 backup restore verification | SRS-NFR-016 | **met** — verified quiet and under load; a restore 100 rows short was detected |
| DRILL-2026-003 disaster recovery | SRS-NFR-005 | **met** — 341 writes confirmed, 341 survived a `SIGKILL`ed primary; 483 ms from declaration to serving |

They found **seven defects**, every one of which needed the procedure actually
executed under concurrent load rather than read:

- the rotation runbook's final step could not run at all, and its new-role
  membership caused a total outage when the old role was dropped;
- the peer-address rate limiter applied a 2/s budget to every request, which
  behind a mesh sidecar is 2/s for the whole deployment;
- the nightly backup verification used the application's credential (needing
  `CREATEDB` on the role that serves patient traffic), compared three schemas
  out of twenty, compared statistics estimates rather than rows, and would have
  failed on any night the hospital was writing.

All seven are fixed, and `tools/infra` and `tools/security` hold the ones that
can regress.

A fourth check, `make manifests-admission`, applies every overlay to a real
Kubernetes API server. It is the step `make manifests-validate` cannot do:
`kubeconform` has no schema for ExternalSecret, SecretStore or ClusterPolicy and
skips all four such objects in every overlay, and it cannot run admission at
all. All three overlays apply
clean, and the shipped Deployment is admitted under `restricted` while a
privileged variant of it is refused — the second half being what makes the first
mean anything. It is not wired into CI yet; a GitHub runner could run it, and
that is named as the next step rather than shipped unverified.

## What is still open

| Item | Why it cannot close here |
|---|---|
| ~~P0-12 / A8 — the orchestrator running the workload~~ | **Closed.** This was reported here as an environment limit and it was not one. A pod sandbox sets `oom_score_adj` to -998 and `CAP_SYS_RESOURCE` is dropped, both true — but containerd has `restrict_oom_score_adj`, the supported setting for rootless and constrained hosts, which clamps the value instead of failing. One line of kind config and every pod starts. What was described as "no distribution can start a pod here" was a default configuration nobody had looked past. See [`drill-log.md`](drill-log.md) for the three defects that were hiding behind it. |
| SRS-SEC-013 | A penetration test is an external engagement, not an artefact, and must not be recorded as done because a gate wants it green. `make release-gate` refuses a production release until an engagement is registered, which is the control working. |
| The cluster half of each drill | **Narrower than it was.** Rollouts are now covered (DRILL-2026-004, on a real cluster under load). Still uncovered: external-secrets, the mesh, a multi-node or cross-zone failover, and production concurrency. Each register entry says which. The pre-production drills the runbooks describe are still required before a production launch. |

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
