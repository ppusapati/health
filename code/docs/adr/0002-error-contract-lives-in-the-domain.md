# ADR-W0-002: The error contract lives below transport

- **Status**: Accepted
- **Date**: 2026-09-11
- **Realises**: ADR-002 (Protobuf + ConnectRPC, *Closed*)
- **Requirements**: SRS-API-004, SRS-API-006, SRS-WEB-011
- **Gate**: A1

## Context

Clients need a stable machine-readable failure code that is independent of any
display message (SRS-API-004). The obvious implementation is to return
`connect.NewError(...)` from the place that detects the problem — but the places
that detect problems are the domain and application layers, and the domain is
forbidden from importing transport packages (FIT-01).

## Decision

`internal/platform/rpcerr` defines a transport-neutral `*Error` carrying a
category, a stable code, field violations and a retryability flag. Domain and
application code returns these.

A single mapping table in `internal/platform/transport` converts a category to a
Connect code and attaches a `healthcare.common.v1.ErrorDetail`. Unrecognised
errors become `INTERNAL` with a generic message, and the cause is logged rather
than returned.

## Consequences

**Good**

- The domain stays pure and independently testable.
- The category-to-code mapping exists in exactly one place, so a new category
  cannot be handled inconsistently across handlers.
- An unexpected fault cannot leak a driver string or stack trace to a caller;
  the correlation ID is returned instead, which is what support actually needs.

**Costs**

- Two error vocabularies exist (platform categories and Connect codes) and must
  be kept aligned. The mapping table is small and centrally tested.
- Every handler must remember to call `ToConnect`. The error interceptor is the
  backstop for anything that does not.
