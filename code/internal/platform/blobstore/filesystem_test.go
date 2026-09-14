package blobstore_test

import (
	"context"
	"errors"
	"io/fs"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/ppusapati/health/code/internal/platform/blobstore"
)

// Photographs of patients and scans of their records. A store created
// world-readable is not something anybody notices, and the files inside it
// inherit whatever umask the process happened to run with unless they are set
// explicitly.
func TestStoredFilesAreNotReadableByAnybodyElse(t *testing.T) {
	root := filepath.Join(t.TempDir(), "store")
	backend, err := blobstore.NewFilesystem(blobstore.FilesystemOptions{Name: "local", Root: root})
	if err != nil {
		t.Fatalf("NewFilesystem: %v", err)
	}
	vault, err := blobstore.NewVault(blobstore.Config{}, backend)
	if err != nil {
		t.Fatalf("NewVault: %v", err)
	}
	object, err := vault.Put(context.Background(), scopeFor("tenant-a"),
		blobstore.ClassPatientPhoto, "image/jpeg", photo)
	if err != nil {
		t.Fatalf("Put: %v", err)
	}

	ref, err := blobstore.ParseReference(object.Reference)
	if err != nil {
		t.Fatalf("ParseReference: %v", err)
	}
	info, err := os.Stat(filepath.Join(root, filepath.FromSlash(ref.BackendKey())))
	if err != nil {
		t.Fatalf("stat: %v", err)
	}
	if perm := info.Mode().Perm(); perm&0o077 != 0 {
		t.Errorf("stored object has mode %o; group and other can read it", perm)
	}
	rootInfo, err := os.Stat(root)
	if err != nil {
		t.Fatalf("stat root: %v", err)
	}
	if perm := rootInfo.Mode().Perm(); perm&0o077 != 0 {
		t.Errorf("store root has mode %o", perm)
	}
}

// A write interrupted partway leaves a file at the real key holding some of
// the bytes, and a partial object is one that exists, reads as the wrong
// content, and fails its digest check for a reason nobody can tell apart from
// tampering. The temporary file must be gone whether the write succeeded or
// not — the failure path is where they otherwise accumulate as objects nothing
// references and no sweep can attribute.
func TestNoPartialFilesSurviveAWrite(t *testing.T) {
	root := filepath.Join(t.TempDir(), "store")
	backend, err := blobstore.NewFilesystem(blobstore.FilesystemOptions{Name: "local", Root: root})
	if err != nil {
		t.Fatalf("NewFilesystem: %v", err)
	}
	vault, err := blobstore.NewVault(blobstore.Config{}, backend)
	if err != nil {
		t.Fatalf("NewVault: %v", err)
	}
	ctx, scope := context.Background(), scopeFor("tenant-a")

	for i := 0; i < 3; i++ {
		if _, err := vault.Put(ctx, scope, blobstore.ClassPatientPhoto, "image/jpeg", photo); err != nil {
			t.Fatalf("Put: %v", err)
		}
	}
	// A write that cannot complete: the context is already cancelled.
	cancelled, cancel := context.WithCancel(ctx)
	cancel()
	if _, err := vault.Put(cancelled, scope, blobstore.ClassPatientPhoto, "image/jpeg", photo); err == nil {
		t.Fatal("a cancelled write was accepted")
	}

	err = filepath.WalkDir(root, func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if !d.IsDir() && strings.HasPrefix(d.Name(), ".partial-") {
			return errors.New("a partial file survived: " + path)
		}
		return nil
	})
	if err != nil {
		t.Fatal(err)
	}
}

func TestAMisconfiguredFilesystemBackendRefusesToStart(t *testing.T) {
	if _, err := blobstore.NewFilesystem(blobstore.FilesystemOptions{Root: t.TempDir()}); err == nil {
		t.Error("a filesystem backend with no name was constructed")
	}
	if _, err := blobstore.NewFilesystem(blobstore.FilesystemOptions{Name: "local"}); err == nil {
		t.Error("a filesystem backend with no root was constructed")
	}
}
