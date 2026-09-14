// Package imagestore adapts the platform blob store onto nursing wound
// photographs.
//
// It binds the wound-image content class and translates errors. Where a
// photograph of a patient actually lives — a filesystem, an S3-compatible
// bucket, a different bucket for one tenant under a residency clause — is
// configured once in internal/platform/blobstore, and a nursing assessment has
// no business knowing which answer this deployment gave.
package imagestore

import (
	"context"
	"errors"

	"github.com/ppusapati/health/code/internal/nursing/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/blobstore"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Store holds wound photograph bytes in the platform blob store.
type Store struct {
	vault *blobstore.Vault
}

// New binds a vault to the wound-image class.
//
// It returns the interface rather than *Store so a nil vault yields a nil
// port. A (*Store)(nil) in a ports.ImageStore is an interface value that is not
// nil, and the application's "this deployment stores no photographs" branch
// would be skipped in favour of a nil-pointer panic.
func New(vault *blobstore.Vault) ports.ImageStore {
	if vault == nil {
		return nil
	}
	return &Store{vault: vault}
}

// Put stores the bytes and returns the reference to record.
func (s *Store) Put(ctx context.Context, scope authctx.TenantScope,
	contentType string, content []byte) (string, error) {

	object, err := s.vault.Put(ctx, scope, blobstore.ClassWoundImage, contentType, content)
	if err != nil {
		return "", imageError(err)
	}
	return object.Reference, nil
}

// Get reads the bytes back, verified against the digest in the reference.
func (s *Store) Get(ctx context.Context, scope authctx.TenantScope, key string) ([]byte, error) {
	content, err := s.vault.Get(ctx, scope, key)
	if err != nil {
		return nil, imageError(err)
	}
	return content, nil
}

// Delete removes the bytes, and does not mind if they are already gone.
func (s *Store) Delete(ctx context.Context, scope authctx.TenantScope, key string) error {
	if err := s.vault.Delete(ctx, scope, key); err != nil {
		return imageError(err)
	}
	return nil
}

func imageError(err error) error {
	switch {
	case errors.Is(err, blobstore.ErrNotFound):
		// Not found rather than forbidden, including for another tenant's
		// reference: a probe must not be able to confirm that an image exists
		// somewhere it cannot read.
		return rpcerr.NotFound("NURSING_WOUND_IMAGE_MISSING", "the photograph is not in the store")
	case errors.Is(err, blobstore.ErrDigestMismatch):
		// A series of wound photographs is the evidence of healing. One that
		// is quietly the wrong image is evidence of the wrong thing.
		return rpcerr.Internal("NURSING_WOUND_IMAGE_CORRUPT",
			"the stored photograph does not match its recorded digest").WithCause(err)
	case errors.Is(err, blobstore.ErrTooLarge):
		return rpcerr.Invalid("NURSING_WOUND_IMAGE_TOO_LARGE", "that photograph is too large to store")
	case errors.Is(err, blobstore.ErrUnsupportedContentType):
		return rpcerr.Invalid("NURSING_WOUND_IMAGE_TYPE_UNSUPPORTED",
			"that is not a photograph format this store holds")
	case errors.Is(err, blobstore.ErrInvalidObject):
		return rpcerr.Invalid("NURSING_WOUND_IMAGE_INVALID",
			"that photograph cannot be stored").WithCause(err)
	case errors.Is(err, blobstore.ErrNoBackend):
		return rpcerr.Internal("NURSING_WOUND_IMAGE_STORE_NOT_CONFIGURED",
			"the store holding this photograph is not configured in this deployment").WithCause(err)
	default:
		return err
	}
}

var _ ports.ImageStore = (*Store)(nil)
