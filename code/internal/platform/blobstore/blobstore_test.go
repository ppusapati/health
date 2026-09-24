package blobstore_test

import (
	"bytes"
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/platform/blobstore"
)

var uploadedAt = time.Date(2026, 9, 11, 9, 0, 0, 0, time.UTC)

func metadata(content []byte) blobstore.ObjectMetadata {
	return blobstore.ObjectMetadata{
		ObjectID:    "obj-1",
		TenantID:    "tenant-a",
		Key:         "tenant-a/consent_form/obj-1",
		OwnerType:   "consent_form",
		OwnerID:     "consent-1",
		ContentType: "application/pdf",
		SizeBytes:   int64(len(content)),
		SHA256:      blobstore.Digest(content),
		UploadedBy:  "clerk-1",
		UploadedAt:  uploadedAt,
		KMSKeyAlias: "alias/healthcare/prod/object-store",
	}
}

func TestVerifyAcceptsMatchingContent(t *testing.T) {
	content := []byte("%PDF-1.7 signed consent")
	m := metadata(content)

	got, err := blobstore.Verify(m, bytes.NewReader(content))
	if err != nil {
		t.Fatalf("Verify: %v", err)
	}
	if !bytes.Equal(got, content) {
		t.Fatal("Verify returned different bytes")
	}
}

// The reason the digest is recorded in the transaction at all. Object stores
// are replicated, eventually consistent and administered by other people; the
// hash is what detects bytes that are not the bytes that were written.
func TestAlteredContentIsRejected(t *testing.T) {
	content := []byte("%PDF-1.7 signed consent")
	m := metadata(content)

	altered := []byte("%PDF-1.7 signed consent (amended)")
	body, err := blobstore.Verify(m, bytes.NewReader(altered))
	if !errors.Is(err, blobstore.ErrDigestMismatch) {
		t.Fatalf("want ErrDigestMismatch, got %v", err)
	}
	// Nothing is handed back on failure. Returning the bytes alongside an
	// error would let a caller use them anyway, and under time pressure
	// somebody would — they look fine.
	if body != nil {
		t.Fatal("Verify returned content that failed its digest check")
	}
}

// A truncated download — a cut connection, a failed multipart upload — must
// not read as a valid document.
func TestTruncatedContentIsRejected(t *testing.T) {
	content := []byte("%PDF-1.7 signed consent")
	m := metadata(content)

	if _, err := blobstore.Verify(m, bytes.NewReader(content[:5])); !errors.Is(err, blobstore.ErrDigestMismatch) {
		t.Fatalf("want ErrDigestMismatch for truncated content, got %v", err)
	}
}

// SRS-DAT-012 in part: the metadata records which managed key the backend
// encrypted an object under, so an operator can say what protects it without
// reading it. Encryption here is at rest and at the object; column-level
// encryption of sensitive fields is not built — see
// docs/engineering/wave-0-status.md.
func TestMetadataMustLeaveTheObjectVerifiable(t *testing.T) {
	content := []byte("%PDF-1.7")

	cases := map[string]func(*blobstore.ObjectMetadata){
		"no object id":   func(m *blobstore.ObjectMetadata) { m.ObjectID = "" },
		"no tenant":      func(m *blobstore.ObjectMetadata) { m.TenantID = "" },
		"no key":         func(m *blobstore.ObjectMetadata) { m.Key = "" },
		"no owner":       func(m *blobstore.ObjectMetadata) { m.OwnerID = "" },
		"no size":        func(m *blobstore.ObjectMetadata) { m.SizeBytes = 0 },
		"no digest":      func(m *blobstore.ObjectMetadata) { m.SHA256 = "" },
		"short digest":   func(m *blobstore.ObjectMetadata) { m.SHA256 = "abc123" },
		"no kms key":     func(m *blobstore.ObjectMetadata) { m.KMSKeyAlias = "" },
		"no uploader":    func(m *blobstore.ObjectMetadata) { m.UploadedBy = "" },
		"no upload time": func(m *blobstore.ObjectMetadata) { m.UploadedAt = time.Time{} },
	}
	for name, mutate := range cases {
		t.Run(name, func(t *testing.T) {
			m := metadata(content)
			mutate(&m)
			if err := m.Validate(); !errors.Is(err, blobstore.ErrInvalidObject) {
				t.Fatalf("want ErrInvalidObject, got %v", err)
			}
		})
	}

	if err := metadata(content).Validate(); err != nil {
		t.Fatalf("complete metadata was rejected: %v", err)
	}
}

// Verify buffers, so it has to refuse content large enough to be a problem
// rather than quietly hold a radiology study in memory.
func TestOversizedContentMustBeStreamed(t *testing.T) {
	content := bytes.Repeat([]byte("x"), blobstore.MaxInlineBytes+1)
	m := metadata(content)

	_, err := blobstore.Verify(m, bytes.NewReader(content))
	if !errors.Is(err, blobstore.ErrInvalidObject) {
		t.Fatalf("want ErrInvalidObject for oversized content, got %v", err)
	}
	if !strings.Contains(err.Error(), "stream") {
		t.Fatalf("the error does not tell the caller what to do instead: %v", err)
	}
}

// A digest that matches with a size that does not means the metadata
// disagrees with itself. Not safe to serve either way.
func TestInconsistentMetadataIsRejected(t *testing.T) {
	content := []byte("%PDF-1.7 signed consent")
	m := metadata(content)
	m.SizeBytes = m.SizeBytes + 10

	if _, err := blobstore.Verify(m, bytes.NewReader(content)); !errors.Is(err, blobstore.ErrInvalidObject) {
		t.Fatalf("want ErrInvalidObject, got %v", err)
	}
}
