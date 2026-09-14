// Package attachmentstore adapts the platform blob store onto the clinical
// record.
//
// It binds the clinical-attachment content class and translates errors. Where
// a scanned referral actually lives — a filesystem, an S3-compatible bucket, a
// different bucket for one tenant under a residency clause — is configured
// once in internal/platform/blobstore, and the clinical record has no business
// knowing which answer this deployment gave.
package attachmentstore

import (
	"context"
	"errors"

	"github.com/ppusapati/health/code/internal/clinical/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/blobstore"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Store holds attachment bytes in the platform blob store.
type Store struct {
	vault *blobstore.Vault
}

// New binds a vault to the clinical-attachment class.
//
// It returns the interface rather than *Store so a nil vault yields a nil
// port. A (*Store)(nil) in a ports.AttachmentStore is an interface value that
// is not nil, and the application's "this deployment stores no attachments"
// branch would be skipped in favour of a nil-pointer panic.
func New(vault *blobstore.Vault) ports.AttachmentStore {
	if vault == nil {
		return nil
	}
	return &Store{vault: vault}
}

// Put stores the bytes and returns the reference to record.
func (s *Store) Put(ctx context.Context, scope authctx.TenantScope,
	contentType string, content []byte) (string, error) {

	object, err := s.vault.Put(ctx, scope, blobstore.ClassClinicalAttachment, contentType, content)
	if err != nil {
		return "", attachmentError(err)
	}
	return object.Reference, nil
}

// Get reads the bytes back, verified against the digest in the reference.
func (s *Store) Get(ctx context.Context, scope authctx.TenantScope, key string) ([]byte, error) {
	content, err := s.vault.Get(ctx, scope, key)
	if err != nil {
		return nil, attachmentError(err)
	}
	return content, nil
}

// Delete removes the bytes, and does not mind if they are already gone.
func (s *Store) Delete(ctx context.Context, scope authctx.TenantScope, key string) error {
	if err := s.vault.Delete(ctx, scope, key); err != nil {
		return attachmentError(err)
	}
	return nil
}

func attachmentError(err error) error {
	switch {
	case errors.Is(err, blobstore.ErrNotFound):
		// Not found rather than forbidden, including for a reference belonging
		// to another tenant: a probe must not be able to confirm that a
		// document exists somewhere it cannot read.
		return rpcerr.NotFound("CLINICAL_ATTACHMENT_MISSING", "the file is not in the store")
	case errors.Is(err, blobstore.ErrDigestMismatch):
		// The stored bytes are not the bytes that were attached. Never served:
		// a discharge summary that is quietly the wrong document is worse than
		// one that is missing, because nobody goes looking for the right one.
		return rpcerr.Internal("CLINICAL_ATTACHMENT_CORRUPT",
			"the stored file does not match its recorded digest").WithCause(err)
	case errors.Is(err, blobstore.ErrTooLarge):
		return rpcerr.Invalid("CLINICAL_ATTACHMENT_TOO_LARGE", "that file is too large to store")
	case errors.Is(err, blobstore.ErrUnsupportedContentType):
		return rpcerr.Invalid("CLINICAL_ATTACHMENT_TYPE_UNSUPPORTED",
			"that is not a file type this store holds")
	case errors.Is(err, blobstore.ErrInvalidObject):
		return rpcerr.Invalid("CLINICAL_ATTACHMENT_INVALID",
			"that file cannot be stored").WithCause(err)
	case errors.Is(err, blobstore.ErrNoBackend):
		// A configuration mistake, not a missing file. Saying so is what keeps
		// it from being diagnosed as data loss.
		return rpcerr.Internal("CLINICAL_ATTACHMENT_STORE_NOT_CONFIGURED",
			"the store holding this file is not configured in this deployment").WithCause(err)
	default:
		return err
	}
}

var _ ports.AttachmentStore = (*Store)(nil)
