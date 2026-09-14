// Package photostore adapts the platform blob store onto the patient index.
//
// All this does is bind a content class and translate errors. Where patient
// photographs actually live — a filesystem, an S3-compatible bucket, a
// different bucket for one tenant because of a residency clause — is a
// deployment decision configured once in internal/platform/blobstore, and the
// patient index has no business knowing which answer this deployment gave.
//
// The translation is the other half. The blob store speaks sentinel errors,
// because it is a platform package and platform packages do not decide what a
// caller's API returns; the patient index speaks rpcerr codes, because a
// clinician's screen has to say something useful. Doing it here means an
// object that has been tampered with surfaces as EMPI_PHOTO_CORRUPT rather
// than as an opaque internal error.
package photostore

import (
	"context"
	"errors"

	"github.com/ppusapati/health/code/internal/empi/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/blobstore"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Store holds patient photographs in the platform blob store.
type Store struct {
	vault *blobstore.Vault
}

// New binds a vault to the patient-photograph class.
//
// A nil vault yields a nil store, so a deployment that configured no blob
// backends stays one that refuses to capture a photograph rather than one that
// records a row pointing at nothing. The application layer already treats a
// nil PhotoStore that way; this keeps the composition root from having to
// spell the same condition out again.
//
// It returns the interface rather than *Store precisely because of that. A
// (*Store)(nil) assigned into a ports.PhotoStore is an interface value that is
// not nil, so the application's "no store configured" branch would be skipped
// and the first photograph would panic on a nil pointer instead. Returning the
// interface here is the one place that can be got right once.
func New(vault *blobstore.Vault) ports.PhotoStore {
	if vault == nil {
		return nil
	}
	return &Store{vault: vault}
}

// Put stores the bytes and returns the reference to keep on the photo record.
func (s *Store) Put(ctx context.Context, scope authctx.TenantScope,
	contentType string, content []byte) (string, error) {

	object, err := s.vault.Put(ctx, scope, blobstore.ClassPatientPhoto, contentType, content)
	if err != nil {
		return "", photoError(err)
	}
	return object.Reference, nil
}

// Get reads the bytes back, verified against the digest in the reference.
func (s *Store) Get(ctx context.Context, scope authctx.TenantScope, key string) ([]byte, error) {
	content, err := s.vault.Get(ctx, scope, key)
	if err != nil {
		return nil, photoError(err)
	}
	return content, nil
}

// Delete removes the bytes. Idempotent, so a withdrawal retried after a
// partial failure completes rather than sticking.
func (s *Store) Delete(ctx context.Context, scope authctx.TenantScope, key string) error {
	if err := s.vault.Delete(ctx, scope, key); err != nil {
		return photoError(err)
	}
	return nil
}

// photoError translates a blob store failure into what a clinician's screen
// should say.
func photoError(err error) error {
	switch {
	case errors.Is(err, blobstore.ErrNotFound):
		// Not found rather than forbidden, including for another tenant's
		// reference: a probe must not be able to confirm that a photograph
		// exists somewhere it cannot read.
		return rpcerr.NotFound("EMPI_PHOTO_MISSING", "the photograph is not in the store")
	case errors.Is(err, blobstore.ErrDigestMismatch):
		// The bytes in the store are not the bytes that were captured. Never
		// shown: a photograph used to identify a patient at the bedside is
		// exactly the thing that must not be quietly wrong.
		return rpcerr.Internal("EMPI_PHOTO_CORRUPT",
			"the stored photograph does not match its recorded digest").WithCause(err)
	case errors.Is(err, blobstore.ErrTooLarge):
		return rpcerr.Invalid("EMPI_PHOTO_TOO_LARGE", "that photograph is too large to store")
	case errors.Is(err, blobstore.ErrUnsupportedContentType):
		return rpcerr.Invalid("EMPI_PHOTO_TYPE_UNSUPPORTED",
			"that is not a photograph format this store holds")
	case errors.Is(err, blobstore.ErrInvalidObject):
		return rpcerr.Invalid("EMPI_PHOTO_INVALID", "that photograph cannot be stored").WithCause(err)
	case errors.Is(err, blobstore.ErrNoBackend):
		// A configuration mistake, not a missing photograph. Saying so is what
		// keeps it from being diagnosed as data loss.
		return rpcerr.Internal("EMPI_PHOTO_STORE_NOT_CONFIGURED",
			"the store holding this photograph is not configured in this deployment").WithCause(err)
	default:
		return err
	}
}

var _ ports.PhotoStore = (*Store)(nil)
