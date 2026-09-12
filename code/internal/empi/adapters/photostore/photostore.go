// Package photostore holds patient photograph bytes.
//
// A separate package behind ports.PhotoStore because where patient photographs
// live is a deployment decision with real consequences — encryption at rest,
// retention, data residency — and none of them belong in the patient index.
// The production adapter is object storage; this one is a filesystem, which is
// enough for development and for a single-node edge deployment and is honest
// about being neither replicated nor encrypted.
package photostore

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"errors"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"strings"

	"github.com/ppusapati/health/code/internal/empi/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Filesystem stores photographs under a root directory.
//
// Keys are tenant-prefixed and generated here rather than supplied by the
// caller. A caller-chosen key is a path traversal waiting to happen, and a key
// derived from the patient id would make the object name itself a patient
// identifier visible to anybody who can list the bucket.
type Filesystem struct {
	root string
}

// extensions maps a content type to the suffix a key gets.
//
// Allowlisted rather than derived from the content type string: a suffix taken
// from caller input is how "image/jpeg; ../../etc/passwd" becomes a filename.
var extensions = map[string]string{
	"image/jpeg": ".jpg",
	"image/png":  ".png",
	"image/webp": ".webp",
}

// NewFilesystem prepares a store rooted at dir.
func NewFilesystem(dir string) (*Filesystem, error) {
	if strings.TrimSpace(dir) == "" {
		return nil, errors.New("photostore: a filesystem store needs a root directory")
	}
	absolute, err := filepath.Abs(dir)
	if err != nil {
		return nil, fmt.Errorf("photostore: resolving %q: %w", dir, err)
	}
	// 0o700: photographs of patients. Group and other have no business here,
	// and a store created world-readable is not something anybody notices.
	if err := os.MkdirAll(absolute, 0o700); err != nil {
		return nil, fmt.Errorf("photostore: creating %q: %w", absolute, err)
	}
	return &Filesystem{root: absolute}, nil
}

// Put writes the bytes under a newly generated key.
func (f *Filesystem) Put(ctx context.Context, scope authctx.TenantScope,
	contentType string, content []byte) (string, error) {

	if err := ctx.Err(); err != nil {
		return "", err
	}
	tenantID := scope.TenantID()
	if tenantID == "" {
		return "", rpcerr.Internal("EMPI_NO_TENANT_SCOPE", "a photograph needs a tenant scope")
	}
	extension, ok := extensions[contentType]
	if !ok {
		return "", rpcerr.Invalid("EMPI_PHOTO_TYPE_UNSUPPORTED",
			"that is not a photograph format this store holds")
	}

	// 128 bits from crypto/rand. Unguessable, because a key that could be
	// enumerated would let anybody who can reach the store walk every
	// photograph in it.
	var raw [16]byte
	if _, err := rand.Read(raw[:]); err != nil {
		return "", fmt.Errorf("photostore: generating a key: %w", err)
	}
	key := tenantID + "/" + hex.EncodeToString(raw[:]) + extension

	path, err := f.resolve(key)
	if err != nil {
		return "", err
	}
	if err := os.MkdirAll(filepath.Dir(path), 0o700); err != nil {
		return "", fmt.Errorf("photostore: creating tenant directory: %w", err)
	}
	if err := os.WriteFile(path, content, 0o600); err != nil {
		return "", fmt.Errorf("photostore: writing %q: %w", key, err)
	}
	return key, nil
}

// Get reads the bytes back.
func (f *Filesystem) Get(ctx context.Context, scope authctx.TenantScope, key string) ([]byte, error) {
	if err := ctx.Err(); err != nil {
		return nil, err
	}
	if err := f.ownedBy(scope, key); err != nil {
		return nil, err
	}
	path, err := f.resolve(key)
	if err != nil {
		return nil, err
	}
	content, err := os.ReadFile(path)
	if errors.Is(err, fs.ErrNotExist) {
		return nil, rpcerr.NotFound("EMPI_PHOTO_MISSING", "the photograph is not in the store")
	}
	if err != nil {
		return nil, fmt.Errorf("photostore: reading %q: %w", key, err)
	}
	return content, nil
}

// Delete removes the bytes.
//
// Idempotent: a withdrawal retried after a partial failure must not fail
// because the object is already gone, or consent stays un-withdrawable.
func (f *Filesystem) Delete(ctx context.Context, scope authctx.TenantScope, key string) error {
	if err := ctx.Err(); err != nil {
		return err
	}
	if err := f.ownedBy(scope, key); err != nil {
		return err
	}
	path, err := f.resolve(key)
	if err != nil {
		return err
	}
	if err := os.Remove(path); err != nil && !errors.Is(err, fs.ErrNotExist) {
		return fmt.Errorf("photostore: deleting %q: %w", key, err)
	}
	return nil
}

// ownedBy refuses a key belonging to another tenant.
//
// The key prefix is the tenant, so this is checkable without a database read.
// Belt and braces: the repository already scopes every lookup, and a store that
// served any key it was handed would turn one leaked key into cross-tenant
// access.
func (f *Filesystem) ownedBy(scope authctx.TenantScope, key string) error {
	tenantID := scope.TenantID()
	if tenantID == "" {
		return rpcerr.Internal("EMPI_NO_TENANT_SCOPE", "a photograph needs a tenant scope")
	}
	if !strings.HasPrefix(key, tenantID+"/") {
		// Not found rather than forbidden: a probe must not be able to confirm
		// that a key exists in another tenant.
		return rpcerr.NotFound("EMPI_PHOTO_MISSING", "the photograph is not in the store")
	}
	return nil
}

// resolve turns a key into a path inside the root.
//
// The containment check is not redundant with key generation: Get and Delete
// take a key read back from the database, and a row written by an earlier
// version — or by anything else with table access — must not be able to reach
// outside the store.
func (f *Filesystem) resolve(key string) (string, error) {
	cleaned := filepath.Clean(filepath.Join(f.root, filepath.FromSlash(key)))
	if cleaned != f.root && !strings.HasPrefix(cleaned, f.root+string(os.PathSeparator)) {
		return "", rpcerr.NotFound("EMPI_PHOTO_MISSING", "the photograph is not in the store")
	}
	return cleaned, nil
}

var _ ports.PhotoStore = (*Filesystem)(nil)
