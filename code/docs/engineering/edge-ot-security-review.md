# Edge and OT trust-zone security review

- **Scope**: the hospital edge prototype (P0-13) — `internal/edge`,
  `internal/edge/cloudstore`, `db/migrations/0005_edge.up.sql` — and the trust
  boundary between a ward, the cloud, and the hospital's operational-technology
  network.
- **Date**: 2026-09-11
- **Gate**: A12
- **Verdict**: the edge pattern is approved for Wave 1. The OT/DMZ half is
  **not reviewed because it is not built**, and this document says so rather
  than implying coverage it does not have.

## What is being trusted

An edge node is a small machine in a ward — frequently a corridor cupboard,
occasionally a bench — that keeps clinical work flowing when the WAN is down.
It holds patient data, it forwards to the cloud, and it is the least physically
protected component in the deployment. Someone can walk off with it.

That single fact drives most of this review. Everything else in the platform
sits in a datacentre where the threat model is network and credential; here the
threat model starts with physical possession.

Three trust boundaries exist:

| Boundary | Crossed by | Control |
|---|---|---|
| Ward device → edge node | Local capture (labels, observations) | Out of scope for Wave 0: no device onboarding is built |
| Edge node → cloud | Forwarded operations | mTLS, per-node certificate, idempotent ingest |
| Hospital OT network → anything | Not crossed. No connection exists | **Not built** |

## Findings

### E-1 — The local queue is not encrypted at rest (Medium, mitigated, residual accepted)

The edge queue is SQLite on local disk. `modernc.org/sqlite` is a pure-Go
driver with no SQLCipher equivalent, so there is no application-level
encryption available without either cgo or a second storage engine.

Payloads in that queue are clinical. A stolen node yields them.

**What was done.** Retention. An operation the cloud has acknowledged is no
longer being held for durability — it is only exposure — so it is now deleted
an hour after acknowledgement (`Queue.Purge`, `Forwarder.PurgeExpired`,
`edge.DefaultRetention`). Before this change a node accumulated every operation
it had ever handled, indefinitely; a machine in service for a year yielded a
year. It now yields roughly a shift.

Retention is measured from **acknowledgement**, not from when the operation
happened, so a week-long outage does not cause work to be purged the instant it
is finally forwarded. Pending operations are never purged — deleting
unacknowledged clinical work would be worse than the exposure this guards
against — and rejected ones are kept until a human has seen them.

**Residual risk, accepted.** Up to one retention window of clinical data sits
unencrypted on a ward machine. The compensating control is **full-disk
encryption on the edge host**, which is now a deployment requirement rather
than an assumption (see *Deployment requirements* below). Revisit if a pure-Go
encrypted store becomes available, or if a site's threat model makes an hour
too long — `Forwarder.WithRetention` exists for that.

### E-2 — Node authentication accepted a caller-supplied string (High, fixed)

`AuthenticateNode` and `IngestFromNode` took `credentialFingerprint string`.
The doc comment said the transport must pass the SHA-256 digest of the peer
certificate from a terminated mTLS connection — and nothing enforced it.

The failure this invites is specific and easy: a transport author writes
`r.Header.Get("X-Node-Fingerprint")`, it works in every test, and node
authentication silently becomes *tell us who you are*. The node's identifiers
are non-secret UUIDs that appear in logs and manifests, so the fingerprint is
the only thing distinguishing the real node from anyone who has read them.

**Fixed.** `cloudstore.PeerFingerprint` has an unexported field and no string
constructor — the same technique as `authctx.TenantScope` under ADR-W0-001. It
can only be built from a `*tls.ConnectionState` or an `*x509.Certificate`, so
the header mistake does not compile. The digest is taken over the leaf
certificate's raw DER, not over a subject or serial, which can repeat across
issuers.

### E-3 — Enrollment token strength was the caller's problem (Medium, fixed)

Tokens were stored as unsalted SHA-256. That is the correct construction for a
high-entropy random value and the wrong one for anything a human chose, and
nothing constrained which kind arrived. A token of `ward-4b-enroll` was
accepted and stored as a trivially reversible hash.

Validity was also unbounded: a token could be issued good for a year, which is
not a one-time token but a standing credential that happens to be redeemable
once — and it will be pasted into a ticket, a chat message and a runbook on its
way to the ward.

**Fixed.** `cloudstore.NewEnrollmentToken` mints 256 bits from `crypto/rand`
and callers cannot choose the value; `ParseEnrollmentToken` refuses anything
shorter on redemption; `MaxEnrollmentValidity` caps a token at 24 hours, the
length of a commissioning visit. `EnrollmentToken.String()` deliberately does
not reveal the secret, because a token reaches a log through an accidental `%v`
far more often than through a decision.

### E-4 — No OT/DMZ zone exists (Open, out of Wave-0 scope)

There is no SCADA gateway, no OT DMZ, no unidirectional boundary, and no
device-commissioning path. The Wave-0 edge talks to a ward's own capture
workflow and to the cloud; it does not touch building management, medical-gas
monitoring, nurse call, or any other operational-technology system.

This is correct for Wave 0 and is not a finding against the code. It is a
finding against **this gate's title**: A12 asks for an approved edge/OT
trust-zone pattern, and only the edge half can be approved today. The OT half
belongs to Wave 7 (SCADA families) and Wave 9 (SRS-ONB-DEV device
commissioning), and must be reviewed then against an OT threat model — which is
a different discipline, with safety consequences this review is not scoped to
assess.

Recorded so that nobody later reads "A12 passed" as covering OT.

## What was already right

Worth stating, because a review that lists only findings gives a false picture.

- **Enrollment tokens are one-time, hashed and expiring.** The consume and the
  enrolment commit in one transaction, and the UPDATE matches only an unused,
  unexpired token, so two nodes racing the same token cannot both enrol.
- **A revoked node stops immediately.** The authentication query filters on
  `status = 'enrolled'`, and ingest re-checks. The row and its fingerprint stay
  for audit.
- **Failure modes are indistinguishable.** Unknown, suspended and revoked all
  return the same error, so a caller probing credentials learns nothing.
- **The tenant comes from the credential, never from the request.**
  `IngestFromNode` derives both node and tenant from the certificate presented,
  so a node cannot name a tenant it does not belong to (ADR-W0-001).
- **Ingest is idempotent on (node, operation).** The edge retries blindly
  because it cannot know whether an acknowledgement was lost; the cloud absorbs
  the duplicate without a second side effect.
- **Local storage survives power loss.** `journal_mode(WAL)` with
  `synchronous(FULL)`: a ward that loses power mid-write loses no acknowledged
  operation.
- **Logs carry identifiers, not payloads.** The forwarder logs through
  `obs.SafeAttrs`, and FIT-06 fails the build on a whole-message log.

## Deployment requirements

These are conditions of the approval, not suggestions. An edge node deployed
without them is outside the pattern this review approved.

1. **Full-disk encryption on the edge host**, with the key held in a TPM and
   released on measured boot. This is the compensating control for E-1 and the
   only thing standing between a stolen node and its queue.
2. **mTLS terminated at the edge ingest endpoint**, with the peer certificate
   passed to `cloudstore.FingerprintPeer`. A deployment that terminates TLS at
   a load balancer and forwards plain HTTP has removed node authentication
   entirely — `PeerFingerprint` makes that a compile error in Go, not a
   configuration error in a proxy.
3. **Per-node certificates from a private CA**, one certificate per node, with
   revocation handled through `RevokeNode` rather than only through CRL/OCSP —
   the cloud must be able to cut a node off without waiting for a revocation
   list to propagate.
4. **The edge node is on the clinical network, never the OT network.** Until a
   reviewed OT pattern exists (E-4), any connection between them is
   unreviewed.
5. **Physical**: a locked cupboard, an asset tag, and an incident path that
   treats a missing edge node as a data-breach candidate rather than as an IT
   asset loss.

## Verification

- `internal/edge/cloudstore/credential_test.go` — the fingerprint identifies
  the certificate and not the subject; a connection with no client certificate
  is an error; the leaf is used, not the issuer; minted tokens are unique; a
  token does not print itself; a short token is refused.
- `internal/edge/cloudstore/cloudstore_test.go` — enrolment lifecycle, one-time
  and expiring tokens, hashed storage, revocation, tenant derived from the
  credential, and a certificate the node did not enrol with being refused.
- `internal/edge/edge_test.go` — the WAN-loss scenario, and retention:
  acknowledged work is purged, unacknowledged work never is, retention is
  measured from acknowledgement, rejected operations are kept, and zero
  retention disables purging.
