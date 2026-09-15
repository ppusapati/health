# Getting started

## Prerequisites

- Go 1.24+
- Node 22+
- PostgreSQL 16 client and server binaries (or any reachable PostgreSQL 16)

## First run

```bash
cd code

make tools          # pinned buf, protoc plugins, sqlc
make db-start       # local PostgreSQL on 127.0.0.1:55432
make generate       # protobuf + sqlc code
make ci             # lint, fitness tests, full test suite
```

`make ci` is exactly what the pipeline runs. A green local run means a green
pipeline.

## Running the service

```bash
export DATABASE_URL='postgres://postgres@127.0.0.1:55432/postgres?sslmode=disable'
export AUTH_MODE=dev
make run
```

`AUTH_MODE` has no default. Starting without it is a hard failure, so there is
no insecure fallback to drift into — see ADR-W0-003.

### Storing files locally

Photographs, attachments and wound images go wherever `BLOB_BACKENDS` says. With
nothing set the service starts, logs a warning and refuses to store binary
content — which is a real deployment, and better than inventing a temporary
directory that works until the process restarts. For local work:

```bash
export BLOB_BACKENDS=local
export BLOB_BACKEND_LOCAL_KIND=filesystem
export BLOB_BACKEND_LOCAL_ROOT=/tmp/health-blobs
```

The startup log prints the routing table, one line per content class. The full
set of variables, including S3-compatible and inline-PostgreSQL backends, is in
the package documentation for `internal/platform/blobstore` and the reasoning is
in [ADR-W1-009](../adr/0009-object-storage-is-one-configured-routing-table.md).

### Development tokens

The development verifier accepts `tenantId:subjectId:role[,role]`. The tenant
component must be a UUID because audit and outbox rows store it as one.

| Role | Grants |
|---|---|
| `platform_operator` | `organization.tenant.create`, `organization.tenant.read` |
| `tenant_admin` | `organization.tenant.read`, `organization.facility.{create,read}` |
| `facility_viewer` | `organization.facility.read` |
| `auditor` | `platform.audit.read` plus read-only organization access |

A token names **roles**, never permissions: the catalogue in
`internal/identity_access/domain/roles.go` decides what a role means.

```bash
# Provision a tenant
curl -s localhost:8080/healthcare.organization.v1.OrganizationService/CreateTenant \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer 00000000-0000-0000-0000-000000000001:ops-1:platform_operator' \
  -d '{"displayName":"Apollo Group","legalJurisdiction":"IN","defaultLocale":"en-IN","timeZone":"Asia/Kolkata"}'

# Create a facility inside it (note: no tenant field — it comes from the token)
curl -s localhost:8080/healthcare.organization.v1.OrganizationService/CreateFacility \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $TENANT_ID:admin-1:tenant_admin" \
  -d '{"code":"main","displayName":"Main Hospital","type":"FACILITY_TYPE_HOSPITAL","timeZone":"Asia/Kolkata"}'
```

## Running the web workspace

```bash
cd apps/web
npm install
npm run generate   # TypeScript clients from the same protos
npm run dev
```

## Tests

| Command | Scope |
|---|---|
| `make test-unit` | Domain and pure-logic tests; no database |
| `make test` | Everything, including repository integration tests |
| `make test-fitness` | Architecture fitness tests (Gate A10) |
| `make drills` | Operational drills — rotation, backup restore, disaster recovery |
| `make manifests-admission` | Apply every overlay to a real API server; needs `KUBECONFIG` |

`make drills` is deliberately outside `make ci`: each one starts real PostgreSQL
instances and real service processes and takes minutes. Run them before changing
a runbook, the backup script or the rate limiter, and quarterly per the
runbooks. They are what found the seven defects recorded in
[`drill-log.md`](drill-log.md), none of which a unit test could see.

Repository tests need `TEST_DATABASE_URL`. Without it they **skip** rather than
fail, so `go test ./...` stays usable on a machine with no PostgreSQL — but CI
always sets it, so the full set always runs before merge.

Each test gets its own freshly migrated database, dropped on completion, so
tests are independent and parallel-safe.

## Adding a bounded context

Follow the checklist in the Domain, Data, API, Event & Security Architecture
Specification §16.1. Concretely:

1. `proto/healthcare/<context>/v1/<context>.proto` — package name comes from the
   **Proto Package** column of the Master Engineering Registry, not from taste.
2. `db/migrations/000N_<context>.up.sql` — own schema, `tenant_id` on every
   tenant-owned row, CHECK-constrained status, audit columns, `version`.
3. `db/queries/<context>.sql` — every tenant-owned statement takes `tenant_id`.
4. `internal/<context>/domain` — aggregates and invariants; pure Go.
5. `internal/<context>/ports` — interfaces the application needs, declared by
   the consumer. Tenant-owned methods take `authctx.TenantScope`.
6. `internal/<context>/application` — use cases owning the transaction, the
   policy check, the outbox append and the audit append.
7. `internal/<context>/adapters/postgres` — the only package allowed to query
   that schema.
8. `internal/<context>/transport` — mapping only.
9. Register the schema in `tools/fitness/fitness_test.go` so FIT-02 covers it.

Every new requirement implemented must carry its canonical `SRS-…` ID in a
doc comment. That is what keeps the RTM honest.
