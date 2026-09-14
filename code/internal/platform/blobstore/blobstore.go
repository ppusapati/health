// Package blobstore keeps binary content out of the relational database, and
// gives the whole system one place that decides where that content lives.
//
// SRS-DAT-007: object and blob content lives in an encrypted object store;
// PostgreSQL holds the metadata and the content hash. The separation is not
// tidiness. A scanned consent form or a DICOM study in a bytea column takes
// the database's whole operational profile with it: backups grow from minutes
// to hours, replication lag becomes a function of how many radiographs were
// taken today, and a restore drill nobody can finish inside a maintenance
// window stops being run.
//
// What PostgreSQL keeps is the part that needs transactions — which object
// belongs to which record, who uploaded it, and the digest that says the bytes
// are the ones that were uploaded. The object store keeps the bytes.
//
// # One package, several backends
//
// Where the bytes actually go is a deployment decision, and different content
// classes in the same deployment reasonably want different answers: wound
// photographs to S3, a captured signature inline in PostgreSQL because it is
// two kilobytes and wants the same backup as the row that references it, and
// everything on a single filesystem on a district hospital's one server. So
// the backend is chosen per content class from configuration, with a per-tenant
// override for data residency, and the modules that own the records — EMPI,
// clinical, nursing — never learn which backend answered.
//
// # Reads follow the key, not the configuration
//
// The backend that holds an object is recorded in the object's own reference.
// Reading resolves the backend from the reference rather than from today's
// configuration, because the alternative is that changing a class from
// filesystem to S3 silently orphans every object written before the change —
// the rows still point somewhere, the bytes are still there, and every read
// returns "not found" from a backend that was never asked to hold them.
//
// # The digest is load-bearing
//
// Object stores are eventually consistent, replicated across regions and
// administered by a different set of people; the hash is what lets a reader
// detect that the bytes it got back are not the bytes that were written,
// whether through corruption, a failed multipart upload, or someone with write
// access to the bucket. Here the digest is carried inside the reference, so
// every read is verified without each calling module having to remember to
// pass one — SRS-DAT-007's "missing/tampered object is detectable" becomes a
// property of this package rather than a discipline.
//
// Trace: SRS-DAT-007, SRS-SEC-002, SRS-EMPI-010, SRS-CLN-014, SRS-NUR-012.
package blobstore

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"io"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/platform/authctx"
)

// Errors returned by this package.
var (
	// ErrDigestMismatch reports content whose bytes are not the bytes that
	// were recorded. Always a hard failure: a document that fails this check
	// must never be shown to a clinician as if it were the record.
	ErrDigestMismatch = errors.New("blobstore: content does not match its recorded digest")
	// ErrInvalidObject reports metadata that could not be stored.
	ErrInvalidObject = errors.New("blobstore: invalid object metadata")
	// ErrNotFound reports an object the store does not hold.
	ErrNotFound = errors.New("blobstore: object not found")
	// ErrTooLarge reports content a backend refuses on size grounds.
	ErrTooLarge = errors.New("blobstore: content is larger than this backend accepts")
	// ErrUnsupportedContentType reports content whose media type the class does
	// not hold. Distinct from ErrInvalidObject so a caller can say "that is not
	// a format this holds" without also saying it about an empty upload or a
	// missing tenant scope — three different things to fix, and one message for
	// all three sends the reader to the wrong one.
	ErrUnsupportedContentType = errors.New("blobstore: content type is not one this class holds")
	// ErrNoBackend reports a reference naming a backend this process has not
	// been configured with — the usual cause is a backend removed from
	// configuration while objects written to it are still referenced.
	ErrNoBackend = errors.New("blobstore: no such backend")
)

// MaxInlineBytes is the largest content this package will buffer in memory
// while hashing. Beyond it, callers stream — the whole point of the object
// store is that content can be larger than a process's memory.
const MaxInlineBytes = 8 << 20 // 8 MiB

// ObjectMetadata is what PostgreSQL keeps. Deliberately no field holds
// content: if one did, the separation this package exists for would be
// optional, and it would stop being observed within a release or two.
type ObjectMetadata struct {
	ObjectID string
	TenantID string
	// Key is the reference returned by Vault.Put. Derived, never
	// client-supplied — see Reference.
	Key string
	// OwnerType and OwnerID tie the object to the record it belongs to, so an
	// orphan sweep can find objects whose record is gone.
	OwnerType string
	OwnerID   string

	ContentType string
	SizeBytes   int64
	// SHA256 is the hex digest of the content as uploaded.
	SHA256 string

	UploadedBy string
	UploadedAt time.Time
	// KMSKeyAlias records which managed key the object store encrypted this
	// object under, so a key rotation can find what still needs re-wrapping
	// without listing the bucket.
	KMSKeyAlias string
}

// Backend is what a deployment plugs in: keyed byte storage and nothing else.
//
// Narrow on purpose. A wider interface invites an adapter that exposes
// bucket-level operations, and no part of this system has business enumerating
// a bucket. It knows nothing of tenants, classes or digests — the Vault above
// it owns all three, so a new backend is a small amount of I/O rather than a
// re-implementation of the policy.
//
// Content is []byte rather than an io.Reader because every caller in this
// system holds a photograph, a signature or a scanned form already in memory,
// bounded by MaxInlineBytes. A streaming port that every implementation
// buffered anyway would be a promise the package does not keep; when something
// genuinely larger arrives — imaging — it gets a streaming port of its own
// rather than a reader that three backends quietly read to the end.
type Backend interface {
	// Name is the identifier recorded in a reference. Stable for the life of
	// the stored objects: renaming a backend strands everything written under
	// the old name.
	Name() string
	// Put writes content at key. Overwrite is not expected — keys are minted
	// per object and objects are immutable — but must not error if it happens,
	// because a retried upload after an ambiguous failure is normal.
	Put(ctx context.Context, key, contentType string, content []byte) error
	// Get returns the content at key, or ErrNotFound.
	Get(ctx context.Context, key string) ([]byte, error)
	// Delete removes the content. Idempotent: a consent withdrawal retried
	// after a partial failure must not fail because the object is already
	// gone, or the withdrawal can never complete.
	Delete(ctx context.Context, key string) error
	// KMSKeyAlias names the managed key this backend encrypts under, or "" if
	// it does not encrypt at rest. Recorded with the metadata so a key
	// rotation can find what needs re-wrapping.
	KMSKeyAlias() string
}

// Digest computes the hex SHA-256 of content.
func Digest(b []byte) string {
	sum := sha256.Sum256(b)
	return hex.EncodeToString(sum[:])
}

// Validate refuses metadata that would leave the object unverifiable.
func (m ObjectMetadata) Validate() error {
	switch {
	case strings.TrimSpace(m.ObjectID) == "":
		return fmt.Errorf("%w: object id is required", ErrInvalidObject)
	case strings.TrimSpace(m.TenantID) == "":
		return fmt.Errorf("%w: tenant is required", ErrInvalidObject)
	case strings.TrimSpace(m.Key) == "":
		return fmt.Errorf("%w: key is required", ErrInvalidObject)
	case strings.TrimSpace(m.OwnerType) == "" || strings.TrimSpace(m.OwnerID) == "":
		return fmt.Errorf("%w: owner is required, or an orphan sweep cannot attribute the object", ErrInvalidObject)
	case m.SizeBytes <= 0:
		return fmt.Errorf("%w: size must be positive", ErrInvalidObject)
	case len(m.SHA256) != 64:
		// Without a digest the object store is trusted absolutely, which is
		// the assumption SRS-DAT-007 exists to avoid.
		return fmt.Errorf("%w: sha256 must be a 64-character hex digest", ErrInvalidObject)
	case strings.TrimSpace(m.KMSKeyAlias) == "":
		return fmt.Errorf("%w: kms key alias is required (SRS-SEC-002)", ErrInvalidObject)
	case strings.TrimSpace(m.UploadedBy) == "":
		return fmt.Errorf("%w: uploader is required", ErrInvalidObject)
	case m.UploadedAt.IsZero():
		return fmt.Errorf("%w: upload time is required", ErrInvalidObject)
	}
	return nil
}

// Verify reads content and checks it against the recorded digest.
//
// The content is returned only when it matches. Returning it alongside an
// error would let a caller use it anyway — and under time pressure somebody
// would, because the bytes look fine.
func Verify(m ObjectMetadata, content io.Reader) ([]byte, error) {
	hasher := sha256.New()
	// Bounded: a caller that needs more than MaxInlineBytes must stream and
	// verify incrementally rather than buffer a study in memory.
	limited := io.LimitReader(content, MaxInlineBytes+1)

	body, err := io.ReadAll(io.TeeReader(limited, hasher))
	if err != nil {
		return nil, err
	}
	if int64(len(body)) > MaxInlineBytes {
		return nil, fmt.Errorf("%w: content exceeds %d bytes; stream it instead",
			ErrInvalidObject, MaxInlineBytes)
	}

	got := hex.EncodeToString(hasher.Sum(nil))
	if got != m.SHA256 {
		return nil, fmt.Errorf("%w: recorded %s, got %s", ErrDigestMismatch, m.SHA256, got)
	}
	if int64(len(body)) != m.SizeBytes {
		// A matching digest with a different size should be impossible, so it
		// means the metadata is inconsistent with itself rather than that the
		// content is wrong. Either way it is not safe to serve.
		return nil, fmt.Errorf("%w: recorded %d bytes, got %d",
			ErrInvalidObject, m.SizeBytes, len(body))
	}
	return body, nil
}

// tenantOf returns the tenant a scope carries, or an error.
func tenantOf(scope authctx.TenantScope) (string, error) {
	id := scope.TenantID()
	if strings.TrimSpace(id) == "" {
		return "", fmt.Errorf("%w: a stored object needs a tenant scope", ErrInvalidObject)
	}
	return id, nil
}
