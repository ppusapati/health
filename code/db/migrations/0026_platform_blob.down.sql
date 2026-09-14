-- Rollback for 0026. Discards every inlined object — captured signatures and
-- anything else a deployment routed to the database backend. Those bytes exist
-- nowhere else, so this is a disaster-recovery action rather than a deployment
-- step: export first, or re-route the affected classes to another backend and
-- migrate the content before dropping the schema.
DROP SCHEMA IF EXISTS platform_blob CASCADE;
