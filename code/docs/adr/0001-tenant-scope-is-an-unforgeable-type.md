# ADR-W0-001: Tenant scope is an unforgeable type, not a string

- **Status**: Accepted
- **Date**: 2026-09-11
- **Realises**: ADR-004 (tenant isolation model, *Closed*)
- **Requirements**: SRS-PLT-003, SRS-IAM-013, FIT-03
- **Gate**: A2

## Context

Every tenant-owned query must filter on `tenant_id`, and that value must come
from verified credentials rather than from a request body. The usual way to do
this is a convention — "always pass `tenantID string` from the session" — policed
by code review.

That convention fails quietly. A repository method that takes a `string` accepts
any string, including one read off the wire, and the resulting defect is
invisible until a cross-tenant leak is found in production. The Master Index
sets a control target of **zero** cross-tenant writes; a convention cannot hold
that target across 210 requirement families and many teams.

## Decision

`authctx.TenantScope` is a struct with an unexported field and no exported
constructor. The only way to obtain a usable one is `Session.TenantScope()`, and
a `Session` only exists after the transport interceptor has authenticated the
request.

Every tenant-owned repository method takes a `TenantScope`:

```go
GetByID(ctx context.Context, scope authctx.TenantScope, facilityID string) (*domain.Facility, error)
```

The zero value is detectable (`IsZero()`) and every repository method rejects it.

## Consequences

**Good**

- A repository cannot be called with an unverified tenant. The compiler, not a
  reviewer, enforces it.
- The rule survives refactoring: extracting a module or adding a caller cannot
  bypass it without deliberately editing `authctx`.
- New bounded contexts inherit the guarantee by following the port signature.

**Limits of the claim**

"Unforgeable" is precise about what it means, and it is worth being exact:

- A repository method **cannot** be reached without *some* verified scope.
  There is no public constructor, so a tenant ID read off the wire cannot
  become a `TenantScope`.
- Any package **inside this module** can still call `authctx.NewSession` with
  an arbitrary tenant and take a scope from it. Go has no friend packages, so
  the type system cannot express "only the interceptor may mint a session".
  That constraint is enforced by a fitness test instead
  (`TestOnlyTransportMintsSessions`), which permits only the transport
  interceptor, the composition root, and tests.

So the guarantee is: *no remote input can forge a scope*, and *in-tree minting
is confined to two reviewed packages*. It is not a claim that the type is
unforgeable against a determined author of new code in this module.

**Costs**

- Repository signatures are slightly noisier than `tenantID string`.
- Tests must construct a `Session` rather than passing a literal. This is
  intentional: a test that cannot easily fake a tenant is a test that reflects
  production constraints.
- `TenantRepository` is the deliberate exception — a tenant row *is* the tenancy
  anchor, so it takes the ID directly. This is the one place to look if the rule
  ever appears to be violated.

## Alternatives considered

- **PostgreSQL row-level security alone.** Valuable as defence in depth and
  planned per ADR-004 for shared-database profiles, but RLS does not protect the
  cache, search index, object store or event bus. Application-level scope is
  needed regardless.
- **A linter rule.** Would catch the same class of defect, but only for patterns
  it was taught, and it cannot be enforced at compile time by downstream teams.
