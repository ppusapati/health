# Wave-0 implementation audit

Conducted before Wave 1 begins, across the whole `code/` tree: security review,
requirement traceability against the 109 Wave-0 SRS IDs, architecture-gate
evidence, and test quality.

Everything under "Findings" was **fixed in the same pass**; everything under
"Accepted gaps" is open and is the reason Wave 0 is not finished.

---

## Findings fixed

### 1. Client headers overwrote verified session attributes — HIGH

`internal/platform/transport/interceptor.go`

`X-Facility-Id` and `X-Purpose-Of-Use` were assigned verbatim onto the
authenticated session after token verification. The code's own comment claimed
the value was "narrowed to what the token already permits"; no narrowing
existed.

Both fields are ABAC inputs the policy engine consumes, so the caller could
satisfy the gates that read them:

- `policy.ReasonFacilityScopeDenied` was unreachable for any remote caller —
  a caller entitled to facility A could assert facility B and be allowed.
- `purpose_of_use` is stamped onto every row of the regulated, append-only
  audit trail. A caller performing a bulk read for any purpose could label it
  `treatment`. Arbitrary strings were also accepted into the audit column and
  into span attributes.

The tenant check immediately above was safe only because it compares against
`session.TenantID` — the one field the interceptor did not let the client touch.

**Fixed.** The credential now carries `PermittedFacilities` and
`PermittedPurposes`; a header may only narrow to a value already granted, and
an unknown purpose string is refused against a closed set. A token with no
facility claim grants no facility scope — the absence of a claim is never an
unrestricted grant. Seven negative tests in `internal/app/header_scope_test.go`,
plus a fitness test that fails if the interceptor stops calling the guards.

### 2. Cross-tenant write in the workflow signal path — MEDIUM

`internal/platform/workflow/signal.go`

`deliverSignal` recorded the signal row *before* the tenant-scoped instance
lookup. A caller supplying another tenant's `instance_id` with an already-used
`signal_key` took the "duplicate" branch, which returned `nil` and therefore
**committed** a history row against the foreign instance. The non-duplicate path
was saved only by the later lookup failing and rolling the transaction back.

**Fixed.** The tenant-scoped lookup runs first, before any write.
`TestCrossTenantDuplicateSignalWritesNothing` asserts neither a history row nor
a signal row appears.

### 3. Edge `Ingest` accepted an unverified tenant ID — MEDIUM

`internal/edge/cloudstore/cloudstore.go`

`Ingest` took `tenantID string` while every neighbouring method in the same file
took an `authctx.TenantScope`. It was the only tenant-owned write in the
codebase not bound to a verified scope, and it is a write path.

**Fixed.** The signature now takes `authctx.TenantScope`.

Separately, `credential_fingerprint` is written at enrollment and read nowhere.
The edge uplink transport does not exist yet, so this is not currently
exploitable, but the column reads as a control that is not implemented. The gap
is now stated in the method's own doc comment rather than left implied, and is
listed under accepted gaps below.

### 4. Printer command injection in label rendering — MEDIUM

`internal/edge/labels.go`

`render` interpolated the barcode and text lines into ZPL with no escaping of
the `^` and `~` command prefixes. A barcode containing `^FS^XZ^XA…` would close
the label and start an attacker-chosen one. A forged wristband is a
wrong-patient hazard, not a cosmetic defect.

**Fixed.** Control prefixes are neutralised before rendering;
`TestLabelTextCannotInjectPrinterCommands` asserts exactly one label is emitted.

### 5. The protobuf compatibility gate never ran — MEDIUM

`Makefile`, `.github/workflows/ci.yml`

`buf breaking --against '.git#…'` resolves the path from the working directory,
which is `code/`. The repository root is one level up, so buf failed to clone
and the job failed for a reason unrelated to compatibility. Gate A4 and
SRS-API-002 were reported as passing on the strength of a check that could not
execute.

**Fixed** to `../.git#…`, and verified: the corrected form detects a field type
change (`string code = 3` → `int32`) and passes on an unchanged tree.

### 6. `EvaluateAccess` disagreed with the real call — MEDIUM

`internal/identity_access/transport/handler.go`

The handler hardcoded `TenantModeReadWrite` and never resolved the caller's
tenant, so for a suspended tenant it answered `allowed` for a mutating action
that the real call refuses — while its own comment claimed "a UI probe and the
real call can never disagree". It also ignored whether the permission mutates.

**Fixed** with a `TenantModeResolver` port declared by the consumer and wired at
the composition root, keeping the bounded-context boundary intact.
`TestEvaluateAccessAgreesWithTheRealCallOnASuspendedTenant` pins the behaviour.

### 7. `UpdateWorkflowInstance` had no tenant predicate — LOW

The only tenant-owned write in the codebase missing one. Not reachable
unsafely — every caller arrives after a tenant-scoped read — but it was the
single exception a future caller could get wrong. Predicate added.

### 8. The "unforgeable" claim was overstated — documentation

`authctx.NewSession` is exported and is an identity function, so any in-tree
package could mint a session for any tenant. The remote-input guarantee holds;
the blanket claim did not.

**Fixed** by constraining callers with a fitness test
(`TestOnlyTransportMintsSessions`, permitting only the transport interceptor,
the composition root and tests) and by stating the precise limit in ADR-W0-001.

### 9. Security-critical code paths had no tests

`buildVerifier` (the `AUTH_MODE` fail-closed guard ADR-W0-003 rests on),
`GetSessionContext`, `EvaluateAccess` and `GetTenant` were all at 0% coverage.
The `StepTimer` step kind appeared only in a *validation* test — no test ever
ran a workflow containing one, so a feature claimed as ADR-006 evidence was
unverified.

**Fixed.** Tests added for all of them, including a timer workflow that asserts
the step holds, does not fire early, and is marked fired afterwards.

---

## Accepted gaps

These are open. They are why **Wave 0 is not complete**, and Done-3 of the
Wave-0 spec — all 109 requirements Verified — is not met.

### Requirement traceability: 52 of 109

Only 52 Wave-0 requirement IDs appear anywhere in the code or engineering docs.

| Family | Traced | Total |
|---|---:|---:|
| SRS-PLT | 11 | 20 |
| SRS-IAM | 10 | 15 |
| SRS-API | 9 | 14 |
| SRS-WEB | 8 | 16 |
| SRS-NFR | 6 | 16 |
| SRS-DAT | 5 | 14 |
| SRS-SEC | 2 | 14 |

`SRS-SEC` at 2/14 is the starkest. Encryption at rest and in transit with
managed keys (SEC-001/002), secret management (SEC-003), SBOM and scanning
(SEC-006), threat modelling (SEC-007), the secure bulk-export workflow
(SEC-008), retention and data-subject requests (SEC-010), tamper-evident
security logging (SEC-012) and penetration testing (SEC-013) are not
implemented.

A few untraced requirements are partially realised but untagged — the SLO
annotations on the Deployment cover NFR-001/002 in substance. Most are simply
not built.

### Other open items

- **Edge node authentication.** `credential_fingerprint` is recorded but never
  checked. The uplink transport must terminate mTLS and bind the peer
  certificate to `node_id` before an edge node can reach `Ingest`.
- **Mobile keystore and durable queue bindings.** Both interfaces exist and are
  tested; both are wired to in-memory implementations. SRS-IAM-002 is not
  satisfied on mobile until the keystore binding lands.
- **No cluster deploy and no live restore drill.** Manifests render, validate
  and are invariant-tested; the image builds and runs. Nothing has been applied
  to a cluster, and the backup job's restore path has never executed against
  real data.
- **RPO.** A daily logical backup does not meet the Tier-0 or Tier-1 RPO in the
  Wave-0 spec §10. Continuous archiving and PITR are required before any Tier-0/1
  workload goes live.
- **ADR-005 broker** still needs a real benchmark; ADR-006 and ADR-007 now have
  their evidence but the decisions are not recorded as closed.
- **`policy` skip-on-empty.** The cross-tenant and facility checks no-op when
  the resource attribute is empty. Safe at every current call site, but
  "deny-by-default" and "skip when empty" are in tension; worth revisiting as
  call sites multiply.

---

## Test position after the audit

| Suite | Count |
|---|---:|
| Go tests | 190 across 20 packages |
| Go statement coverage | 76.9% |
| Flutter tests | 44 |
| Web tests | 14 |

Coverage is thinnest in `internal/platform/obs` (40%) and `cmd/core`, both
largely wiring. No package carrying domain rules or authorization logic sits
below 77%.
