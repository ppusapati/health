package blobstore_test

import (
	"bytes"
	"context"
	"errors"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/blobstore"
)

func scopeFor(tenantID string) authctx.TenantScope {
	return authctx.NewSession(authctx.Session{SubjectID: "clerk", TenantID: tenantID}).TenantScope()
}

func filesystemBackend(t *testing.T, name string) *blobstore.Filesystem {
	t.Helper()
	backend, err := blobstore.NewFilesystem(blobstore.FilesystemOptions{
		Name: name, Root: filepath.Join(t.TempDir(), name),
	})
	if err != nil {
		t.Fatalf("NewFilesystem(%s): %v", name, err)
	}
	return backend
}

var photo = []byte("\xff\xd8\xff\xe0 not really a jpeg, but bytes are bytes")

func TestContentComesBackTheWayItWentIn(t *testing.T) {
	vault, err := blobstore.NewVault(blobstore.Config{}, filesystemBackend(t, "local"))
	if err != nil {
		t.Fatalf("NewVault: %v", err)
	}
	ctx, scope := context.Background(), scopeFor("tenant-a")

	object, err := vault.Put(ctx, scope, blobstore.ClassPatientPhoto, "image/jpeg", photo)
	if err != nil {
		t.Fatalf("Put: %v", err)
	}
	if object.SizeBytes != int64(len(photo)) {
		t.Errorf("SizeBytes = %d, want %d", object.SizeBytes, len(photo))
	}
	if object.Digest != blobstore.Digest(photo) {
		t.Errorf("Digest = %s, want %s", object.Digest, blobstore.Digest(photo))
	}

	got, err := vault.Get(ctx, scope, object.Reference)
	if err != nil {
		t.Fatalf("Get: %v", err)
	}
	if !bytes.Equal(got, photo) {
		t.Fatal("the bytes that came back are not the bytes that went in")
	}
}

// The reference is what a clinical row stores and what appears in a log line
// when something goes wrong. It must reveal nothing about the patient, and it
// must not be derivable — a key anybody could compute or enumerate would let
// whoever reaches the bucket walk every photograph in it.
func TestAReferenceRevealsNothingAndRepeatsNever(t *testing.T) {
	vault, err := blobstore.NewVault(blobstore.Config{}, filesystemBackend(t, "local"))
	if err != nil {
		t.Fatalf("NewVault: %v", err)
	}
	ctx, scope := context.Background(), scopeFor("tenant-a")

	first, err := vault.Put(ctx, scope, blobstore.ClassPatientPhoto, "image/jpeg", photo)
	if err != nil {
		t.Fatalf("Put: %v", err)
	}
	// The same bytes again. Content-addressing would give the same reference,
	// and then withdrawing one patient's consent would delete another
	// patient's photograph.
	second, err := vault.Put(ctx, scope, blobstore.ClassPatientPhoto, "image/jpeg", photo)
	if err != nil {
		t.Fatalf("Put again: %v", err)
	}
	if first.Reference == second.Reference {
		t.Fatal("identical content produced one shared reference")
	}

	ref, err := blobstore.ParseReference(first.Reference)
	if err != nil {
		t.Fatalf("ParseReference: %v", err)
	}
	if ref.TenantID != "tenant-a" {
		t.Errorf("TenantID = %q, want tenant-a", ref.TenantID)
	}
	if ref.Class != blobstore.ClassPatientPhoto {
		t.Errorf("Class = %q, want %q", ref.Class, blobstore.ClassPatientPhoto)
	}
	if len(ref.ObjectID) != 32 {
		t.Errorf("object id is %d hex characters, want 32 (128 bits)", len(ref.ObjectID))
	}
	if ref.Digest != blobstore.Digest(photo) {
		t.Error("the reference does not carry the digest, so a read cannot be verified")
	}
}

// The guarantee this package makes on behalf of SRS-DAT-007: content that is
// not the content that was written is detected, and never handed back.
func TestTamperedContentIsRefusedAndNotReturned(t *testing.T) {
	root := t.TempDir()
	backend, err := blobstore.NewFilesystem(blobstore.FilesystemOptions{Name: "local", Root: root})
	if err != nil {
		t.Fatalf("NewFilesystem: %v", err)
	}
	vault, err := blobstore.NewVault(blobstore.Config{}, backend)
	if err != nil {
		t.Fatalf("NewVault: %v", err)
	}
	ctx, scope := context.Background(), scopeFor("tenant-a")

	object, err := vault.Put(ctx, scope, blobstore.ClassClinicalAttachment, "application/pdf",
		[]byte("%PDF-1.7 outside hospital discharge summary"))
	if err != nil {
		t.Fatalf("Put: %v", err)
	}

	// Somebody with write access to the store — a misbehaving backup restore,
	// an operator, an attacker who got the bucket and not the database.
	ref, err := blobstore.ParseReference(object.Reference)
	if err != nil {
		t.Fatalf("ParseReference: %v", err)
	}
	onDisk := filepath.Join(root, filepath.FromSlash(ref.BackendKey()))
	if err := os.WriteFile(onDisk, []byte("%PDF-1.7 a different discharge summary"), 0o600); err != nil {
		t.Fatalf("tampering with the stored object: %v", err)
	}

	body, err := vault.Get(ctx, scope, object.Reference)
	if !errors.Is(err, blobstore.ErrDigestMismatch) {
		t.Fatalf("want ErrDigestMismatch, got %v", err)
	}
	if body != nil {
		t.Fatal("the altered content was handed back alongside the error")
	}
}

// The property that makes changing a backend safe. Without it, repointing a
// class at S3 leaves every object written before the change unreadable while
// the bytes sit untouched where they were put.
func TestAnObjectStaysReadableAfterItsClassIsRepointed(t *testing.T) {
	disk := filesystemBackend(t, "disk")
	cloud := filesystemBackend(t, "cloud")
	ctx, scope := context.Background(), scopeFor("tenant-a")

	before, err := blobstore.NewVault(blobstore.Config{
		DefaultBackend: "disk",
		Classes: map[blobstore.Class]blobstore.ClassPolicy{
			blobstore.ClassWoundImage: {Backend: "disk"},
		},
	}, disk, cloud)
	if err != nil {
		t.Fatalf("NewVault: %v", err)
	}
	object, err := before.Put(ctx, scope, blobstore.ClassWoundImage, "image/png", photo)
	if err != nil {
		t.Fatalf("Put: %v", err)
	}

	// The deployment moves wound images to the object store.
	after, err := blobstore.NewVault(blobstore.Config{
		DefaultBackend: "disk",
		Classes: map[blobstore.Class]blobstore.ClassPolicy{
			blobstore.ClassWoundImage: {Backend: "cloud"},
		},
	}, disk, cloud)
	if err != nil {
		t.Fatalf("NewVault after repointing: %v", err)
	}

	got, err := after.Get(ctx, scope, object.Reference)
	if err != nil {
		t.Fatalf("an object written before the change is no longer readable: %v", err)
	}
	if !bytes.Equal(got, photo) {
		t.Fatal("the wrong bytes came back")
	}

	// New content goes to the new backend, which is the point of the change.
	fresh, err := after.Put(ctx, scope, blobstore.ClassWoundImage, "image/png", photo)
	if err != nil {
		t.Fatalf("Put after repointing: %v", err)
	}
	if !strings.HasPrefix(fresh.Reference, "cloud:") {
		t.Errorf("new content went to %q, want the cloud backend", fresh.Reference)
	}
}

// Residency is a contractual constraint, so it outranks the class default: a
// tenant whose records must stay in one place cannot have one class of them
// quietly written somewhere else because a default changed.
func TestATenantPinOutranksTheClassDefault(t *testing.T) {
	general := filesystemBackend(t, "general")
	mumbai := filesystemBackend(t, "mumbai")

	vault, err := blobstore.NewVault(blobstore.Config{
		DefaultBackend: "general",
		Classes: map[blobstore.Class]blobstore.ClassPolicy{
			blobstore.ClassPatientPhoto: {Backend: "general"},
		},
		TenantBackends: map[string]string{"tenant-in-india": "mumbai"},
	}, general, mumbai)
	if err != nil {
		t.Fatalf("NewVault: %v", err)
	}

	pinned, err := vault.Put(context.Background(), scopeFor("tenant-in-india"),
		blobstore.ClassPatientPhoto, "image/jpeg", photo)
	if err != nil {
		t.Fatalf("Put: %v", err)
	}
	if !strings.HasPrefix(pinned.Reference, "mumbai:") {
		t.Errorf("a pinned tenant's photograph went to %q", pinned.Reference)
	}

	elsewhere, err := vault.Put(context.Background(), scopeFor("tenant-b"),
		blobstore.ClassPatientPhoto, "image/jpeg", photo)
	if err != nil {
		t.Fatalf("Put: %v", err)
	}
	if !strings.HasPrefix(elsewhere.Reference, "general:") {
		t.Errorf("an unpinned tenant's photograph went to %q", elsewhere.Reference)
	}
}

// One leaked reference must not become cross-tenant access, and a probe must
// not be able to confirm that a reference exists in another tenant.
func TestAnotherTenantsReferenceIsNotFoundRatherThanForbidden(t *testing.T) {
	vault, err := blobstore.NewVault(blobstore.Config{}, filesystemBackend(t, "local"))
	if err != nil {
		t.Fatalf("NewVault: %v", err)
	}
	ctx := context.Background()

	object, err := vault.Put(ctx, scopeFor("tenant-a"), blobstore.ClassPatientPhoto, "image/jpeg", photo)
	if err != nil {
		t.Fatalf("Put: %v", err)
	}

	if _, err := vault.Get(ctx, scopeFor("tenant-b"), object.Reference); !errors.Is(err, blobstore.ErrNotFound) {
		t.Fatalf("want ErrNotFound for another tenant's object, got %v", err)
	}
	if err := vault.Delete(ctx, scopeFor("tenant-b"), object.Reference); !errors.Is(err, blobstore.ErrNotFound) {
		t.Fatalf("another tenant could reach Delete: %v", err)
	}
	// And the object is still there for the tenant that owns it.
	if _, err := vault.Get(ctx, scopeFor("tenant-a"), object.Reference); err != nil {
		t.Fatalf("the owning tenant lost its object: %v", err)
	}
}

// References arrive from rows, and a row can be written by an earlier version
// of this code or by anything else with table access.
func TestACraftedReferenceCannotReachOutsideTheStore(t *testing.T) {
	root := t.TempDir()
	outside := filepath.Join(root, "outside.txt")
	if err := os.WriteFile(outside, []byte("not an object"), 0o600); err != nil {
		t.Fatalf("seeding: %v", err)
	}
	backend, err := blobstore.NewFilesystem(blobstore.FilesystemOptions{
		Name: "local", Root: filepath.Join(root, "store"),
	})
	if err != nil {
		t.Fatalf("NewFilesystem: %v", err)
	}
	vault, err := blobstore.NewVault(blobstore.Config{}, backend)
	if err != nil {
		t.Fatalf("NewVault: %v", err)
	}

	hostile := []string{
		"local:tenant-a/patient-photo/../../../outside.txt/" + strings.Repeat("0", 64),
		"local:tenant-a/patient-photo/..%2F..%2Foutside.txt/" + strings.Repeat("0", 64),
		"local:/etc/passwd",
		"local:tenant-a/patient-photo/abc/short-digest",
		"tenant-a/patient-photo/abc/" + strings.Repeat("0", 64),
		"",
	}
	for _, reference := range hostile {
		if _, err := vault.Get(context.Background(), scopeFor("tenant-a"), reference); err == nil {
			t.Errorf("reference %q was accepted", reference)
		}
	}
}

func TestAClassRefusesContentItDoesNotHold(t *testing.T) {
	vault, err := blobstore.NewVault(blobstore.Config{}, filesystemBackend(t, "local"))
	if err != nil {
		t.Fatalf("NewVault: %v", err)
	}
	ctx, scope := context.Background(), scopeFor("tenant-a")

	// An executable dressed as a photograph.
	if _, err := vault.Put(ctx, scope, blobstore.ClassPatientPhoto,
		"application/x-msdownload", photo); !errors.Is(err, blobstore.ErrUnsupportedContentType) {
		t.Errorf("want ErrUnsupportedContentType for a disallowed content type, got %v", err)
	}
	// Distinct from a disallowed type: "there is nothing here" and "that is not
	// a photograph" are different things to fix, and one message for both sends
	// the reader to the wrong one.
	if _, err := vault.Put(ctx, scope, blobstore.ClassPatientPhoto,
		"image/jpeg", nil); errors.Is(err, blobstore.ErrUnsupportedContentType) {
		t.Error("empty content was reported as an unsupported content type")
	}
	// A parameter on an otherwise fine content type is not a reason to refuse
	// a perfectly good photograph.
	if _, err := vault.Put(ctx, scope, blobstore.ClassPatientPhoto,
		"IMAGE/JPEG; charset=binary", photo); err != nil {
		t.Errorf("a content type with a parameter was refused: %v", err)
	}
	// Bounded before anything is written: the bytes arrive from a ward tablet
	// over a network.
	oversized := bytes.Repeat([]byte("x"), (2<<20)+1)
	if _, err := vault.Put(ctx, scope, blobstore.ClassPatientPhoto,
		"image/jpeg", oversized); !errors.Is(err, blobstore.ErrTooLarge) {
		t.Errorf("want ErrTooLarge, got %v", err)
	}
	if _, err := vault.Put(ctx, scope, blobstore.ClassPatientPhoto,
		"image/jpeg", nil); !errors.Is(err, blobstore.ErrInvalidObject) {
		t.Errorf("empty content was accepted: %v", err)
	}
	if _, err := vault.Put(ctx, scope, "invented-class", "image/jpeg", photo); err == nil {
		t.Error("an unknown class was accepted")
	}
}

// Consent withdrawal retried after a partial failure must not fail because the
// bytes are already gone, or the withdrawal can never be completed.
func TestDeletingTwiceSucceedsTwice(t *testing.T) {
	vault, err := blobstore.NewVault(blobstore.Config{}, filesystemBackend(t, "local"))
	if err != nil {
		t.Fatalf("NewVault: %v", err)
	}
	ctx, scope := context.Background(), scopeFor("tenant-a")

	object, err := vault.Put(ctx, scope, blobstore.ClassPatientPhoto, "image/jpeg", photo)
	if err != nil {
		t.Fatalf("Put: %v", err)
	}
	for attempt := 1; attempt <= 2; attempt++ {
		if err := vault.Delete(ctx, scope, object.Reference); err != nil {
			t.Fatalf("Delete attempt %d: %v", attempt, err)
		}
	}
	if _, err := vault.Get(ctx, scope, object.Reference); !errors.Is(err, blobstore.ErrNotFound) {
		t.Fatalf("want ErrNotFound after deletion, got %v", err)
	}
}

// An object whose backend has been removed from configuration says so. The
// alternative — reporting it missing — is how a configuration mistake gets
// diagnosed as data loss.
func TestAnObjectWhoseBackendIsGoneSaysSo(t *testing.T) {
	disk := filesystemBackend(t, "disk")
	ctx, scope := context.Background(), scopeFor("tenant-a")

	original, err := blobstore.NewVault(blobstore.Config{}, disk)
	if err != nil {
		t.Fatalf("NewVault: %v", err)
	}
	object, err := original.Put(ctx, scope, blobstore.ClassPatientPhoto, "image/jpeg", photo)
	if err != nil {
		t.Fatalf("Put: %v", err)
	}

	// Somebody removes "disk" from BLOB_BACKENDS.
	replacement, err := blobstore.NewVault(blobstore.Config{}, filesystemBackend(t, "cloud"))
	if err != nil {
		t.Fatalf("NewVault: %v", err)
	}
	_, err = replacement.Get(ctx, scope, object.Reference)
	if !errors.Is(err, blobstore.ErrNoBackend) {
		t.Fatalf("want ErrNoBackend, got %v", err)
	}
	if errors.Is(err, blobstore.ErrNotFound) {
		t.Fatal("a missing backend was reported as a missing object")
	}
}

// Every one of these is a failure a deployment would otherwise meet at the
// first upload, hours after the change that caused it.
func TestAMisconfiguredVaultRefusesToStart(t *testing.T) {
	a := filesystemBackend(t, "a")
	b := filesystemBackend(t, "b")

	cases := map[string]struct {
		cfg      blobstore.Config
		backends []blobstore.Backend
	}{
		"no backends at all": {
			cfg: blobstore.Config{},
		},
		"two backends and no default": {
			cfg:      blobstore.Config{},
			backends: []blobstore.Backend{a, b},
		},
		"default names a backend that is not configured": {
			cfg:      blobstore.Config{DefaultBackend: "c"},
			backends: []blobstore.Backend{a, b},
		},
		"a class routes somewhere that does not exist": {
			cfg: blobstore.Config{
				DefaultBackend: "a",
				Classes: map[blobstore.Class]blobstore.ClassPolicy{
					blobstore.ClassWoundImage: {Backend: "nowhere"},
				},
			},
			backends: []blobstore.Backend{a, b},
		},
		"a tenant is pinned somewhere that does not exist": {
			cfg: blobstore.Config{
				DefaultBackend: "a",
				TenantBackends: map[string]string{"tenant-a": "nowhere"},
			},
			backends: []blobstore.Backend{a, b},
		},
		"an unknown class is configured": {
			cfg: blobstore.Config{
				DefaultBackend: "a",
				Classes:        map[blobstore.Class]blobstore.ClassPolicy{"invented": {}},
			},
			backends: []blobstore.Backend{a},
		},
		"two backends share a name": {
			cfg:      blobstore.Config{DefaultBackend: "a"},
			backends: []blobstore.Backend{a, a},
		},
	}
	for name, tc := range cases {
		t.Run(name, func(t *testing.T) {
			if _, err := blobstore.NewVault(tc.cfg, tc.backends...); err == nil {
				t.Fatal("the vault started with a configuration that cannot work")
			}
		})
	}
}

// A backend name goes into every reference, so one containing the separator
// would produce references that parse back into something else entirely.
func TestABackendNameCannotForgeAReference(t *testing.T) {
	for _, name := range []string{"a:b", "a/b", `a\b`, " "} {
		backend, err := blobstore.NewFilesystem(blobstore.FilesystemOptions{
			Name: name, Root: t.TempDir(),
		})
		if err != nil {
			continue // refused at construction, which is also fine
		}
		if _, err := blobstore.NewVault(blobstore.Config{}, backend); err == nil {
			t.Errorf("backend name %q was accepted", name)
		}
	}
}

// A class routed to a backend that cannot hold objects of that size fails at
// boot. Discovered at the first large upload instead, it is reported as a
// clinician who cannot attach a scan and nobody connects it to the routing
// change made last month.
func TestAClassTooLargeForItsBackendFailsAtBoot(t *testing.T) {
	small, err := blobstore.NewFilesystem(blobstore.FilesystemOptions{
		Name: "small", Root: t.TempDir(), MaxBytes: 64 << 10,
	})
	if err != nil {
		t.Fatalf("NewFilesystem: %v", err)
	}
	big := filesystemBackend(t, "big")
	_, err = blobstore.NewVault(blobstore.Config{
		DefaultBackend: "big",
		Classes: map[blobstore.Class]blobstore.ClassPolicy{
			// The default clinical attachment limit is 8 MiB.
			blobstore.ClassClinicalAttachment: {Backend: "small"},
		},
	}, big, small)
	if err == nil {
		t.Fatal("a class larger than its backend started")
	}
	if !strings.Contains(err.Error(), "clinical-attachment") {
		t.Errorf("the error does not name the class: %v", err)
	}

	// The same check covers tenant pins, which is the case that actually bites:
	// a residency setting added later quietly narrows what every class can hold.
	_, err = blobstore.NewVault(blobstore.Config{
		DefaultBackend: "big",
		TenantBackends: map[string]string{"tenant-a": "small"},
	}, big, small)
	if err == nil {
		t.Fatal("a tenant pinned to a backend too small for its classes started")
	}
}

// Route answers the question an operator asks during an incident, and the
// answer has to be the one Put would actually give.
func TestRouteAgreesWithWhatPutDoes(t *testing.T) {
	general := filesystemBackend(t, "general")
	inline := filesystemBackend(t, "inline")

	vault, err := blobstore.NewVault(blobstore.Config{
		DefaultBackend: "general",
		Classes: map[blobstore.Class]blobstore.ClassPolicy{
			blobstore.ClassSignature: {Backend: "inline"},
		},
	}, general, inline)
	if err != nil {
		t.Fatalf("NewVault: %v", err)
	}
	ctx, scope := context.Background(), scopeFor("tenant-a")

	for _, class := range blobstore.Classes() {
		routed, err := vault.Route(scope, class)
		if err != nil {
			t.Fatalf("Route(%s): %v", class, err)
		}
		contentType := "image/png"
		if class == blobstore.ClassClinicalAttachment {
			contentType = "application/pdf"
		}
		object, err := vault.Put(ctx, scope, class, contentType, photo)
		if err != nil {
			t.Fatalf("Put(%s): %v", class, err)
		}
		if !strings.HasPrefix(object.Reference, routed+":") {
			t.Errorf("Route said %q for %s but Put wrote %q", routed, class, object.Reference)
		}
	}

	described := strings.Join(vault.Describe(), "\n")
	if !strings.Contains(described, "class signature -> backend inline") {
		t.Errorf("Describe does not show the signature route:\n%s", described)
	}
}

// Without a tenant there is no prefix to scope by, and an object written
// without one would be readable by everybody or by nobody.
func TestAStoreNeedsATenantScope(t *testing.T) {
	vault, err := blobstore.NewVault(blobstore.Config{}, filesystemBackend(t, "local"))
	if err != nil {
		t.Fatalf("NewVault: %v", err)
	}
	var unscoped authctx.TenantScope
	if _, err := vault.Put(context.Background(), unscoped,
		blobstore.ClassPatientPhoto, "image/jpeg", photo); !errors.Is(err, blobstore.ErrInvalidObject) {
		t.Fatalf("want ErrInvalidObject without a tenant scope, got %v", err)
	}
}
