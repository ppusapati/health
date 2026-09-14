-- Inline object storage for small blobs (see 0026_platform_blob.up.sql).
--
-- Four statements and no listing query. Enumerating stored objects is not
-- something any part of this system does — the owning records are the index —
-- and a query that made it possible would be the one an incident reaches for.

-- name: PutInlineObject :exec
-- Upsert rather than insert. Keys are minted per object and objects are
-- immutable, so a conflict means an upload retried after an ambiguous failure,
-- and failing that retry would strand the caller with no way to complete.
INSERT INTO platform_blob.object (
    object_key, content_type, size_bytes, content, written_at
) VALUES (
    @object_key, @content_type, @size_bytes, @content, @written_at
)
ON CONFLICT (object_key) DO UPDATE
SET content_type = EXCLUDED.content_type,
    size_bytes   = EXCLUDED.size_bytes,
    content      = EXCLUDED.content,
    written_at   = EXCLUDED.written_at;

-- name: GetInlineObject :one
SELECT content FROM platform_blob.object WHERE object_key = @object_key;

-- name: DeleteInlineObject :exec
-- No row is not an error. The callers are consent withdrawals and cleanups
-- after a rejected upload; one that failed because the object was already gone
-- would leave a withdrawal that can never be completed.
DELETE FROM platform_blob.object WHERE object_key = @object_key;

-- name: SumInlineObjectBytes :one
-- For the operational question the table creates: how much of the database is
-- blob content. Reported by a monitoring job, not by a request path.
SELECT COALESCE(SUM(size_bytes), 0)::bigint AS total_bytes,
       COUNT(*)::bigint AS object_count
FROM platform_blob.object;
