-- 0001 Bounded-context schemas.
--
-- Physical deployment may share one PostgreSQL database initially, but logical
-- schema ownership is enforced as if the contexts were already independent
-- services (Domain/Data spec §5.1). Schema names come from the "DB Schema
-- Owner" column of the Master Engineering Registry.
--
-- Trace: SRS-DAT-001, SRS-PLT-019.
--
-- Rollback: 0001_schemas.down.sql drops the schemas. Safe only while they are
--   empty; once any context owns tables the drop is refused without CASCADE,
--   which is the correct behaviour rather than an inconvenience.
-- Reconciliation: none. Creating a schema changes no row, so there is nothing
--   the previous application version can have written that needs reconciling.

CREATE SCHEMA IF NOT EXISTS organization;
CREATE SCHEMA IF NOT EXISTS identity_access;
CREATE SCHEMA IF NOT EXISTS platform_data;
