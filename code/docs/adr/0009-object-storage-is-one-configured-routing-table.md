# ADR-W1-009: Object storage is one configured routing table, with a bounded database exception

- **Status**: Accepted
- **Date**: 2026-09-14
- **Requirements**: SRS-DAT-007, SRS-SEC-002, SRS-EMPI-010, SRS-CLN-014, SRS-NUR-012
- **Supersedes**: the per-module `photostore` filesystem adapter added in Sprint 2C

## Context

Three contexts store binary content: the patient index keeps identification
photographs, the clinical record keeps scanned and photographed documents, and
nursing keeps wound images. Each arrived in its own sprint, and each arrived
differently. EMPI had a port with a filesystem implementation and no other.
Clinical and nursing had neither — they took a `storage_key` string from the
caller and recorded it, which meant the client was trusted to have put bytes
somewhere, to say truthfully where, and to report the digest that a later
reader would use to decide the content had not been altered.

Three problems followed from that, and only the first is the obvious one.

A caller-supplied key is a caller-supplied path. It can name another tenant's
object, something outside the store, or nothing at all, and the resulting
clinical record reads as complete in every case.

A caller-supplied digest is worse than no digest. The field exists so a reader
can detect that the bytes it fetched are not the bytes that were written;
asserted by whoever supplied the content, it detects nothing and looks like it
does.

And where content lives is a deployment question — encryption at rest,
retention, residency, what the backup covers — with a different right answer
for a district hospital on one server than for a multi-region tenant under a
residency clause. Answering it three times, in three modules, guarantees the
three answers diverge.

SRS-DAT-007 is a MUST: object and blob content lives in an encrypted object
store; PostgreSQL keeps the metadata, the hash, the classification and the
reference; a missing or tampered object is detectable.

## Decision

**One package owns the question.** `internal/platform/blobstore` routes content
to a backend by *content class* — patient photograph, clinical attachment,
wound image, signature — with a per-tenant override for residency that outranks
the class. Three backends ship: a filesystem, an S3-compatible store, and
PostgreSQL. A deployment configures them from the environment and no module
learns which one answered. `NewVault` validates the whole routing table at
startup, including whether each class fits what the backend it routes to will
accept, so a misconfiguration is a process that does not start rather than a
clinician who cannot photograph a wound.

**Reads follow the key, not the configuration.** The backend that holds an
object is recorded in the object's own reference, and a read resolves the
backend from the reference. Repointing a class from the filesystem to S3 leaves
everything written before the change readable. Resolving from today's
configuration instead would report every one of those objects as missing while
the bytes sat untouched where they were put — and "missing" is how that gets
diagnosed as data loss.

**The digest travels in the reference.** A reference is
`backend:tenant/class/object-id/sha256`, and every read re-hashes what came back
and refuses to return content that does not match. SRS-DAT-007's "missing or
tampered object is detectable" becomes a property of the package rather than a
discipline each module has to remember, and no caller can accidentally use
content the store returned but cannot vouch for, because it never receives it.

**The server writes the bytes.** `AttachFile` and `AttachWoundImage` now take
content and refuse a caller-supplied key, size or digest — refuse rather than
ignore, so a client that believes it placed the bytes itself is told instead of
quietly having its values replaced.

**SigV4 is implemented here rather than taken from the AWS SDK.** The client
issues three requests against an endpoint the deployment names. The SDK brings a
large dependency tree with its own retry, credential-chain and endpoint
resolution for that. The signing algorithm is small, stable since 2012, and
published with test vectors — and it is pinned here by one of them, so a mistake
in it is a failing test rather than a 403 in an environment nobody can debug
from outside. It also makes MinIO and Ceph work identically to AWS, which
matters for a system that has to run in a hospital's own rack.

**A bounded exception to SRS-DAT-007.** The PostgreSQL backend inlines content
up to 64 KiB and refuses anything larger. The rule's actual concern is
operational: a scanned report or a radiograph in a `bytea` column takes the
database's whole profile with it — backups grow from minutes to hours,
replication lag becomes a function of how many studies were taken today, and a
restore drill nobody can finish inside a maintenance window stops being run.
None of that follows from a two-kilobyte signature. For content that small the
opposite argument holds: an object store is a second system that can be
unavailable and can be restored to a different point in time than the database,
and a consent signature restored to a different instant than the consent record
it signs is a clinical record that silently disagrees with itself.

The cap is enforced three times, against the three ways a limit is lost: by the
backend, so the error says what to do; by `NewVault`, so a class routed there
whose limit exceeds it fails at boot; and by a `CHECK` constraint in
`db/migrations/0026_platform_blob.up.sql`, so raising it takes a migration and a
review rather than an environment variable. The `content bytea` column is
allowlisted in `TestNoBlobContentInRelationalSchema` by migration *and* column
name together, with the reason inline — the bare word "content" is the obvious
name for the thing that rule exists to forbid, and an entry for it alone would
silently permit every future migration that reached for it.

## Consequences

**Good**

- Where content lives is one configuration file, not three code paths.
- A tampered or truncated object is detected on every read, in every module,
  without any module doing anything.
- Changing a backend is safe: existing objects stay readable.
- Clinical and nursing attachments can no longer point at another tenant's
  object, at nothing, or at content whose digest was asserted by its supplier.
- A district hospital runs on a filesystem and a multi-region tenant on S3 with
  no code difference; residency is one environment variable.

**Bad**

- The database backend is a real deviation from a MUST. It is documented,
  capped and tested, but it is a deviation, and a future deployment that raises
  the cap has the operational problem SRS-DAT-007 is about. The `CHECK`
  constraint is what makes raising it a deliberate act.
- The SigV4 implementation is ours to maintain. It is pinned to a published
  vector, but a future signing change (SigV4A for multi-region access points,
  say) is work rather than a dependency bump.
- Attachments travel in the request rather than through a presigned upload, so
  they are bounded by what a unary call should carry. Imaging will need a
  presigned upload and a streaming port; this decision deliberately does not
  pretend to cover it.

**Reopens if**

- Content larger than `MaxInlineBytes` (8 MiB) has to be stored — imaging, video
  — at which point the streaming port and presigned uploads are required and
  this package's buffered shape is the wrong one.
- The inline backend's footprint stops being negligible. `InlineFootprint`
  exists to be monitored: the cap bounds each object, not how many there are.
- A deployment needs SigV4A, or credentials from a source that is not an
  environment variable (IAM Roles for Service Accounts, IMDS), at which point
  the credential chain is worth more than the dependency it costs.
