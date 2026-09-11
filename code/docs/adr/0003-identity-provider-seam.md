# ADR-W0-003: Wave 0 ships an identity seam, not an identity vendor

- **Status**: Accepted (provisional — closes with ADR-008)
- **Date**: 2026-09-11
- **Defers to**: ADR-008 (enterprise identity provider, *Decision Required*, blocking)
- **Requirements**: SRS-IAM-001, SRS-IAM-003, SRS-IAM-013
- **Gate**: A5

## Context

ADR-008 is open and marked as blocking: the enterprise OIDC provider has not
been selected, and the register requires federation, MFA, service identity,
session revocation, HA and admin-audit evidence before it closes.

Wave-1 feature teams cannot wait for that decision, but they also must not build
against a vendor SDK that is later replaced.

## Decision

The transport layer depends on a one-method interface:

```go
type TokenVerifier interface {
    Verify(ctx context.Context, bearerToken string) (authctx.Session, error)
}
```

Everything downstream — interceptor, session context, policy engine, use cases,
audit — consumes the resulting `authctx.Session` and knows nothing about how it
was produced.

The only implementation today is `devauth`, which:

- must be requested explicitly (`AUTH_MODE=dev`); any other value is a startup
  failure, so there is no insecure default to drift into,
- refuses to construct unless passed `enabled == true`,
- accepts **roles**, never permissions — the role catalogue decides what a role
  means, so a forged token is a claim to be interpreted, not a direct grant,
- carries the facilities and purposes-of-use the credential permits, so the
  `X-Facility-Id` and `X-Purpose-Of-Use` headers can only *narrow* to something
  already granted. A token with no facility claim grants no facility scope: the
  absence of a claim is never an unrestricted grant,
- returns a uniform `"invalid credentials"` message for every failure mode.

## Consequences

**Good**

- Wave-1 development proceeds against the final session shape.
- Closing ADR-008 is one new implementation of one interface plus a composition-
  root change. No downstream code moves.
- The blocking status stays visible: the service logs a warning at startup and
  `docs/engineering/wave-0-status.md` lists the seam as open.

**Costs**

- The development verifier is real code that must never reach production. The
  explicit opt-in, the startup warning and the absence of any other `AUTH_MODE`
  are the controls; a production build should additionally exclude the package.
- MFA, session revocation and step-up authentication (SRS-IAM-010 … 012) are not
  implemented in Wave 0. They are properties of the selected provider and are
  tracked against ADR-008, not silently assumed complete.
