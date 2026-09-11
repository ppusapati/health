# ADR-008: OIDC federation per tenant, verified in-process

- **Status**: Accepted — **closes the blocking decision**
- **Date**: 2026-09-11
- **Supersedes**: ADR-W0-003 (identity seam), which was provisional pending this
- **Requirements**: SRS-IAM-001, SRS-IAM-006, SRS-IAM-009, SRS-IAM-010,
  SRS-IAM-012, SRS-IAM-013, SRS-IAM-015
- **Gate**: A5

## Context

The register required evidence on federation, MFA, service identity, session
revocation, HA and admin audit before this closed. Wave 0 ran on a development
verifier behind a one-method seam so nothing downstream bound to a vendor.

The decision is not really "which vendor". A healthcare SaaS platform does not
get to choose its customers' identity providers: a hospital group arrives with
Entra ID, the next with Okta, the one after with an on-premises Keycloak, and
several with more than one. The actual decision is **where verification
happens** and **how a token becomes a tenant**.

## Options considered

**A. Delegate to a single hosted IdP (Auth0/Okta/Entra) as the system of
record, brokering customer directories into it.**
One integration to build, one vendor to operate, MFA and risk scoring included.
But every customer's users become records in our vendor's tenant, which is a
data-residency and a commercial problem: an Indian hospital group's staff
directory replicated into a US-hosted identity vendor is a conversation nobody
wants to have during a procurement. Brokering also puts a third party in the
path of every sign-in, so their outage is our outage.

**B. Verify tokens in-process, one federation per tenant.**
Each customer's provider stays theirs. This system holds the trust anchor (the
issuer), the mapping from their groups to our roles, and the revocation
watermark. No user directory is copied anywhere. The cost is that we implement
verification, and verification is the kind of code where a subtle mistake
authenticates everyone.

**C. A gateway (Envoy/oauth2-proxy) verifies and passes headers.**
Moves verification out of the application, which is appealing until the
application has to trust a header. Any path that reaches the service without
traversing the gateway — a port-forward, a misconfigured NetworkPolicy, a
sidecar — becomes a full authentication bypass with no signature to check.

## Decision

**Option B.** Tokens are verified in-process, one federation per tenant,
resolved by issuer.

Signature verification, JWKS fetching and key rotation are delegated to
`coreos/go-oidc` rather than hand-rolled. Accepting `alg: none`, confusing an
HMAC key with an RSA public key, or skipping the key id are mistakes that
produce a system which authenticates anyone and passes every functional test; a
reviewed library is the correct call for this specific layer.

What the application owns on top is everything a JWT library cannot know:

| Concern | Where it lives | Why it is ours |
|---|---|---|
| Which tenant a token belongs to | `FederationStore.ByIssuer` | A unique index on issuer makes it unambiguous; taking a tenant hint from the request would let a caller choose |
| What a provider's group means here | `Federation.Resolve` | The provider asserts membership; this system decides what it grants, so a customer cannot grant themselves permissions by adding a group |
| Purpose-of-use | `domain.PurposesFor` | What data may be *used for* is our policy, not the customer's directory |
| Whether a live session is still valid | `Account.AuthorizeSession` | A token is valid until it expires; revocation is ours |
| MFA | `checkAuthenticationStrength` | Which `acr`/`amr` satisfies a tenant is the tenant's policy |

### Revocation is a watermark, not a token list

`Account.NotValidBefore`: any credential issued before that instant is refused,
whatever its own expiry says. One comparison per request, cheap enough to
actually run, and it kills every session a user holds at once — which is what
an administrator clicking "disable" means, not "revoke the one they are using".

Two properties are enforced in SQL rather than in Go, because a caller passing
a stale account could otherwise undo them by accident:

- `UpsertAccount` refreshes roles and leaves status and watermark alone, so a
  re-login cannot clear a suspension.
- Every revocation uses `GREATEST`, so a replayed or late revocation cannot
  move the watermark backwards and resurrect killed sessions.

The verifier prefers `auth_time` over `iat` where the provider supplies it: a
silently refreshed token has a fresh `iat` and a stale `auth_time`, and using
`iat` would let a refresh outlive a revocation.

### Every rejection looks the same

Unknown issuer, bad signature, expired token, revoked session and suspended
account all return `AUTH_TOKEN_INVALID` / "invalid credentials". Distinguishing
them would let a probe map out which hospitals use the platform and which
accounts exist.

## Consequences

**Good**

- No customer directory is copied into this system or any vendor's.
- No third party is in the sign-in path, so their outage is not ours.
- Adding a customer is a row, not a redeploy.
- Revocation propagates on the next request rather than at token expiry.
- The Wave-0 seam held: closing this changed the composition root and the
  `AUTH_MODE` switch. No downstream code moved.

**Costs**

- We operate the verification path. Mitigated by using a reviewed library for
  the cryptography and by testing against a real OIDC provider — a TLS
  `httptest` server with a genuine JWKS and RSA-signed tokens — rather than a
  fake that returns a pre-made session. The suite includes `alg: none`, a token
  signed by an unpublished key, a forged issuer, a wrong audience and an
  expired token.
- A revocation check per request. Bounded by design: the answer is one instant
  per subject, so it caches aggressively, and the propagation target is how
  stale that cache may be — a number the deployment chooses rather than a
  property of the token.
- Discovery is lazy and cached per issuer. A customer's IdP being unreachable
  fails their sign-ins and nobody else's, but the first sign-in after a restart
  pays a discovery round trip.

**Not covered by this decision**

- **Service-to-service identity** is SRS-IAM-007 and is workload identity
  (`domain.WorkloadIdentity`), not OIDC. A workload proves possession of a
  short-lived credential; the type has no field for a secret, which is the
  requirement expressed in the type system.
- **Step-up** (SRS-IAM-012) is a separate proof bound to subject, action and a
  short window. A sign-in is not a step-up, and an `acr` claim from an hour ago
  does not authorise deleting a tenant now.

## Reopen this decision if

- A customer requires that we hold their directory (option A becomes the ask
  rather than the risk).
- Token verification cost becomes material at the p95 the SLO is measured
  against — it is currently a signature check against a cached key.
- The number of federations makes lazy discovery a cold-start problem, in which
  case discovery moves to a warmed background refresh rather than changing this
  decision.
