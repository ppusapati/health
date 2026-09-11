// Package blobstore keeps binary content out of the relational database.
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
// The digest is the load-bearing field. Object stores are eventually
// consistent, replicated across regions and administered by a different set of
// people; the hash recorded in the transaction is what lets a reader detect
// that the bytes it got back are not the bytes that were written, whether
// through corruption, a failed multipart upload, or someone with write access
// to the bucket.
package blobstore

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"io"
	"path"
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
	// Key is the path within the bucket. Derived, never client-supplied — see
	// Key below.
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

// Store is the object-store port. Narrow on purpose: a wider interface invites
// an adapter that exposes bucket-level operations, and the application has no
// business enumerating a bucket.
type Store interface {
	// Put writes content and returns its size and digest.
	Put(ctx context.Context, key, contentType string, content io.Reader) (size int64, sha256Hex string, err error)
	// Get returns the content at a key.
	Get(ctx context.Context, key string) (io.ReadCloser, error)
	// Delete removes the content. Metadata deletion is the caller's
	// transaction, and must happen after this succeeds — the other order
	// leaves an object nothing references, which no sweep can attribute.
	Delete(ctx context.Context, key string) error
}

// Key builds the object-store path for a piece of content.
//
// The tenant is the first path segment, so a bucket policy can grant access
// per tenant prefix — defence in depth behind the application's own scoping,
// and the thing that makes a misconfigured client fail rather than read
// somebody else's records.
//
// The object id is the last segment and the caller never chooses the key.
// A client-supplied key is a path traversal waiting to be written, and a
// key derived from a filename collides the moment two wards both upload
// "consent.pdf".
func Key(scope authctx.TenantScope, ownerType, objectID string) string {
	return path.Join(scope.TenantID(), sanitiseSegment(ownerType), objectID)
}

func sanitiseSegment(s string) string {
	s = strings.TrimSpace(s)
	s = strings.ReplaceAll(s, "/", "_")
	s = strings.ReplaceAll(s, "..", "_")
	if s == "" {
		return "unclassified"
	}
	return s
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
