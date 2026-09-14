package blobstore

import (
	"context"
	"errors"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"strings"
)

// Filesystem stores objects under a root directory.
//
// Honest about what it is: neither replicated nor encrypted at rest by this
// process. That makes it right for development and for a single-node district
// hospital where the disk itself is encrypted and the backup is the machine's
// backup, and wrong for anything with a second availability zone. A deployment
// that needs encryption at rest from the storage layer names a KMS alias so
// the metadata records which key the volume is under; leaving it empty says
// plainly that nothing here is encrypted, which is better than a field that
// implies it is.
type Filesystem struct {
	name  string
	root  string
	kms   string
	limit int64
}

// FilesystemOptions configures a filesystem backend.
type FilesystemOptions struct {
	// Name is the identifier recorded in references. Required, and permanent
	// for the life of the objects written under it.
	Name string
	// Root is the directory objects live under.
	Root string
	// KMSKeyAlias names the key the underlying volume is encrypted with, if
	// the deployment encrypts the volume. Empty means unencrypted.
	KMSKeyAlias string
	// MaxBytes refuses larger objects. Zero means the class limits are the
	// only ceiling.
	MaxBytes int64
}

// NewFilesystem prepares a filesystem backend.
func NewFilesystem(opts FilesystemOptions) (*Filesystem, error) {
	if strings.TrimSpace(opts.Name) == "" {
		return nil, errors.New("blobstore: a filesystem backend needs a name")
	}
	if strings.TrimSpace(opts.Root) == "" {
		return nil, errors.New("blobstore: a filesystem backend needs a root directory")
	}
	absolute, err := filepath.Abs(opts.Root)
	if err != nil {
		return nil, fmt.Errorf("blobstore: resolving %q: %w", opts.Root, err)
	}
	// 0o700: photographs of patients and scans of their records. Group and
	// other have no business here, and a store created world-readable is not
	// something anybody notices.
	if err := os.MkdirAll(absolute, 0o700); err != nil {
		return nil, fmt.Errorf("blobstore: creating %q: %w", absolute, err)
	}
	return &Filesystem{
		name: opts.Name, root: absolute,
		kms: opts.KMSKeyAlias, limit: opts.MaxBytes,
	}, nil
}

// Name identifies the backend in references.
func (f *Filesystem) Name() string { return f.name }

// KMSKeyAlias names the volume key, or "" when nothing encrypts this store.
func (f *Filesystem) KMSKeyAlias() string { return f.kms }

// MaxBytes implements Limiter.
func (f *Filesystem) MaxBytes() int64 { return f.limit }

// Put writes the object.
//
// Written to a temporary file and renamed. A direct write that is interrupted
// — the process killed, the disk filling — leaves a truncated file at the real
// key, and a truncated file is an object that exists, is the wrong bytes, and
// whose digest check fails for a reason nobody can distinguish from tampering.
// Rename within a directory is atomic, so the key either does not exist or
// holds the whole object.
func (f *Filesystem) Put(ctx context.Context, key, contentType string, content []byte) error {
	if err := ctx.Err(); err != nil {
		return err
	}
	if f.limit > 0 && int64(len(content)) > f.limit {
		return fmt.Errorf("%w: %d bytes exceeds the %d backend %q accepts",
			ErrTooLarge, len(content), f.limit, f.name)
	}
	path, err := f.resolve(key)
	if err != nil {
		return err
	}
	dir := filepath.Dir(path)
	if err := os.MkdirAll(dir, 0o700); err != nil {
		return fmt.Errorf("blobstore: creating %q: %w", dir, err)
	}

	temp, err := os.CreateTemp(dir, ".partial-*")
	if err != nil {
		return fmt.Errorf("blobstore: creating a temporary file: %w", err)
	}
	tempName := temp.Name()
	defer func() {
		// No-op once the rename has succeeded; the point is the paths where it
		// has not, which would otherwise accumulate partial files nothing
		// references and no sweep can attribute.
		_ = os.Remove(tempName)
	}()

	if err := temp.Chmod(0o600); err != nil {
		_ = temp.Close()
		return fmt.Errorf("blobstore: securing a temporary file: %w", err)
	}
	if _, err := temp.Write(content); err != nil {
		_ = temp.Close()
		return fmt.Errorf("blobstore: writing %q: %w", key, err)
	}
	// Sync before rename. Without it the rename can be durable while the bytes
	// it points at are not, and a power loss leaves a key naming an empty file
	// — which is exactly the state the temp-and-rename is meant to rule out.
	if err := temp.Sync(); err != nil {
		_ = temp.Close()
		return fmt.Errorf("blobstore: flushing %q: %w", key, err)
	}
	if err := temp.Close(); err != nil {
		return fmt.Errorf("blobstore: closing %q: %w", key, err)
	}
	if err := os.Rename(tempName, path); err != nil {
		return fmt.Errorf("blobstore: publishing %q: %w", key, err)
	}
	return nil
}

// Get reads the object.
func (f *Filesystem) Get(ctx context.Context, key string) ([]byte, error) {
	if err := ctx.Err(); err != nil {
		return nil, err
	}
	path, err := f.resolve(key)
	if err != nil {
		return nil, err
	}
	content, err := os.ReadFile(path)
	if errors.Is(err, fs.ErrNotExist) {
		return nil, fmt.Errorf("%w: %s", ErrNotFound, key)
	}
	if err != nil {
		return nil, fmt.Errorf("blobstore: reading %q: %w", key, err)
	}
	return content, nil
}

// Delete removes the object, and does not mind if it is already gone.
func (f *Filesystem) Delete(ctx context.Context, key string) error {
	if err := ctx.Err(); err != nil {
		return err
	}
	path, err := f.resolve(key)
	if err != nil {
		return err
	}
	if err := os.Remove(path); err != nil && !errors.Is(err, fs.ErrNotExist) {
		return fmt.Errorf("blobstore: deleting %q: %w", key, err)
	}
	return nil
}

// resolve turns a backend key into a path inside the root.
//
// The containment check is not redundant with the reference parser. Keys reach
// here from rows read back out of the database, and a row written by an earlier
// version — or by anything else with table access — must not be able to reach
// outside the store. Two cheap checks in series are worth more than one clever
// one: the parser rejects traversal segments, and this refuses anything that
// nonetheless resolves outside the root.
func (f *Filesystem) resolve(key string) (string, error) {
	cleaned := filepath.Clean(filepath.Join(f.root, filepath.FromSlash(key)))
	if cleaned != f.root && !strings.HasPrefix(cleaned, f.root+string(os.PathSeparator)) {
		return "", fmt.Errorf("%w: %s", ErrNotFound, key)
	}
	return cleaned, nil
}

var (
	_ Backend = (*Filesystem)(nil)
	_ Limiter = (*Filesystem)(nil)
)
