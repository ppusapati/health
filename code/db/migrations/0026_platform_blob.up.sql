-- 0026 Inline object storage for small blobs.
--
-- This table is a deliberate, bounded exception to SRS-DAT-007, which says
-- object content belongs in an encrypted object store and PostgreSQL holds
-- only the metadata, hash and reference. The reason for that rule is
-- operational: a scanned report or a radiograph in a bytea column takes the
-- database's whole profile with it — backups grow from minutes to hours,
-- replication lag becomes a function of how many studies were taken today,
-- and a restore drill nobody can finish inside a maintenance window stops
-- being run.
--
-- None of that follows from a two-kilobyte signature image. What does follow,
-- for content that small, is the opposite argument: an object store is a
-- second system that can be unavailable, can be restored to a different point
-- in time than the database, and needs its own backup verification. A consent
-- signature restored to a different instant than the consent record it signs
-- is a clinical record that disagrees with itself, and the failure is silent.
--
-- So the exception is capped rather than granted. The size limit is enforced
-- twice — by a CHECK here, and by the backend's configured maximum before the
-- write is attempted — because a limit held only in application configuration
-- is one a later deployment raises without anybody re-reading this comment.
-- The CHECK is the one that cannot be raised without a migration and a review.
--
-- The default cap is 64 KiB (65536). Content above it is refused outright: it
-- is never silently redirected to another backend, because a deployment that
-- believed its signatures were in the database and finds half of them in S3
-- has the worst of both.
--
-- Trace: SRS-DAT-007 (documented deviation, bounded), SRS-SEC-002.
--
-- Rollback: drops the whole schema, and with it every object a deployment
-- routed to the database backend. Those bytes exist nowhere else — the
-- reference in the owning clinical or index record points here and only here —
-- so this is a disaster-recovery action rather than a deployment step. To
-- retire the backend safely instead, re-route the affected classes to an object
-- store, copy the content across, and drop the schema once nothing references
-- it. There is no automatic migration: which backend holds an object is
-- recorded in its reference, so moving the bytes means rewriting the owning
-- rows, which only the owning context can do.
--
-- Reconciliation: none. The schema is new, no previous version writes to it,
-- and a deployment rolled back to the previous version simply has no backend
-- named "postgres" to route to — which its own configuration decides, since
-- BLOB_BACKENDS is read at startup. A rollback with objects already inlined is
-- the case the paragraph above covers.
CREATE SCHEMA IF NOT EXISTS platform_blob;

CREATE TABLE platform_blob.object (
    -- The backend key minted by internal/platform/blobstore: a tenant-prefixed
    -- path whose last segment is the content's SHA-256. Opaque here on
    -- purpose. There is no tenant_id column because this table is not the
    -- authority on which tenant an object belongs to — the owning clinical or
    -- index record is, and a second answer that could disagree with it is
    -- worse than no answer. The key is tenant-prefixed, which is what the
    -- reader checks before it ever reaches this table.
    object_key   text        PRIMARY KEY,

    content_type text        NOT NULL,
    size_bytes   bigint      NOT NULL CHECK (size_bytes > 0),

    -- 65536 bytes. See the header: the cap is the whole justification for this
    -- table existing, so it lives in the schema where raising it is a
    -- reviewable change rather than an environment variable.
    content      bytea       NOT NULL CHECK (octet_length(content) <= 65536),

    written_at   timestamptz NOT NULL
);

-- Written for the operational question this table creates: how much of the
-- database is now blob content, and is it growing. Without it the answer needs
-- a sequential scan of the one table whose size is the thing being asked about.
CREATE INDEX object_written_at_idx ON platform_blob.object (written_at);
