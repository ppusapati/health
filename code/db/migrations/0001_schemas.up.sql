-- 0001 Bounded-context schemas.
--
-- Physical deployment may share one PostgreSQL database initially, but logical
-- schema ownership is enforced as if the contexts were already independent
-- services (Domain/Data spec §5.1). Schema names come from the "DB Schema
-- Owner" column of the Master Engineering Registry.
--
-- Trace: SRS-DAT-001, SRS-PLT-019.

CREATE SCHEMA IF NOT EXISTS organization;
CREATE SCHEMA IF NOT EXISTS identity_access;
CREATE SCHEMA IF NOT EXISTS platform_data;
