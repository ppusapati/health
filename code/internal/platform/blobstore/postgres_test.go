package blobstore_test

import (
	"bytes"
	"context"
	"errors"
	"strings"
	"testing"

	"github.com/ppusapati/health/code/internal/platform/blobstore"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
)

func inlineVault(t *testing.T, maxBytes int64) (*blobstore.Vault, *blobstore.Postgres, *pgtx.Manager) {
	t.Helper()
	manager := pgtx.NewManager(pgtest.New(t))
	backend, err := blobstore.NewPostgres(blobstore.PostgresOptions{
		Name: "inline", Transactions: manager, MaxBytes: maxBytes,
		KMSKeyAlias: "alias/healthcare/prod/database",
	})
	if err != nil {
		t.Fatalf("NewPostgres: %v", err)
	}
	vault, err := blobstore.NewVault(blobstore.Config{
		DefaultBackend: "inline",
		Classes: map[blobstore.Class]blobstore.ClassPolicy{
			// Every class has to fit the inline backend for the vault to
			// start, so this configuration inlines only what is small.
			blobstore.ClassPatientPhoto:       {MaxBytes: maxBytes},
			blobstore.ClassClinicalAttachment: {MaxBytes: maxBytes},
			blobstore.ClassWoundImage:         {MaxBytes: maxBytes},
			blobstore.ClassSignature:          {MaxBytes: maxBytes},
		},
	}, backend)
	if err != nil {
		t.Fatalf("NewVault: %v", err)
	}
	return vault, backend, manager
}

// The class the inline backend exists for: a captured signature, kilobytes,
// worthless if it is restored to a different instant than the consent it signs.
func TestASignatureRoundTripsThroughTheDatabase(t *testing.T) {
	vault, backend, _ := inlineVault(t, blobstore.DefaultPostgresMaxBytes)
	ctx, scope := context.Background(), scopeFor("tenant-a")

	signature := bytes.Repeat([]byte("\x89PNG signature"), 64)
	object, err := vault.Put(ctx, scope, blobstore.ClassSignature, "image/png", signature)
	if err != nil {
		t.Fatalf("Put: %v", err)
	}
	if !strings.HasPrefix(object.Reference, "inline:") {
		t.Fatalf("reference %q did not go to the inline backend", object.Reference)
	}
	if object.KMSKeyAlias != "alias/healthcare/prod/database" {
		t.Errorf("KMSKeyAlias = %q", object.KMSKeyAlias)
	}

	got, err := vault.Get(ctx, scope, object.Reference)
	if err != nil {
		t.Fatalf("Get: %v", err)
	}
	if !bytes.Equal(got, signature) {
		t.Fatal("the bytes that came back are not the bytes that went in")
	}

	total, count, err := backend.InlineFootprint(ctx)
	if err != nil {
		t.Fatalf("InlineFootprint: %v", err)
	}
	if count != 1 || total != int64(len(signature)) {
		t.Errorf("footprint = %d bytes in %d objects, want %d in 1", total, count, len(signature))
	}

	if err := vault.Delete(ctx, scope, object.Reference); err != nil {
		t.Fatalf("Delete: %v", err)
	}
	if _, err := vault.Get(ctx, scope, object.Reference); !errors.Is(err, blobstore.ErrNotFound) {
		t.Fatalf("want ErrNotFound after deletion, got %v", err)
	}
	// Idempotent, like every other backend: consent withdrawal is retried.
	if err := vault.Delete(ctx, scope, object.Reference); err != nil {
		t.Fatalf("Delete again: %v", err)
	}
}

// The whole justification for this backend. Content above the cap is refused
// outright and never redirected: a deployment that believed its signatures
// were in the database and finds half of them elsewhere has the worst of both.
func TestOversizedContentIsRefusedRatherThanRedirected(t *testing.T) {
	vault, backend, _ := inlineVault(t, 4<<10)
	ctx, scope := context.Background(), scopeFor("tenant-a")

	tooBig := bytes.Repeat([]byte("x"), (4<<10)+1)
	_, err := vault.Put(ctx, scope, blobstore.ClassSignature, "image/png", tooBig)
	if !errors.Is(err, blobstore.ErrTooLarge) {
		t.Fatalf("want ErrTooLarge, got %v", err)
	}

	total, count, err := backend.InlineFootprint(ctx)
	if err != nil {
		t.Fatalf("InlineFootprint: %v", err)
	}
	if count != 0 || total != 0 {
		t.Errorf("a refused object left %d bytes in %d rows", total, count)
	}
}

// The schema's CHECK constraint is the cap that cannot be raised by an
// environment variable, so a configuration that tries is refused rather than
// left to fail on the constraint at the first large write.
func TestTheInlineCapCannotBeRaisedByConfiguration(t *testing.T) {
	manager := pgtx.NewManager(pgtest.New(t))
	_, err := blobstore.NewPostgres(blobstore.PostgresOptions{
		Name: "inline", Transactions: manager,
		MaxBytes: blobstore.DefaultPostgresMaxBytes + 1,
	})
	if err == nil {
		t.Fatal("a cap above the schema's CHECK was accepted")
	}
	if !strings.Contains(err.Error(), "object store") {
		t.Errorf("the error does not say what to do instead: %v", err)
	}
}

// The property the inline backend exists for: the bytes and the row that
// references them commit together, so a rollback cannot leave one without the
// other.
func TestInlinedContentSharesTheCallersTransaction(t *testing.T) {
	vault, backend, manager := inlineVault(t, blobstore.DefaultPostgresMaxBytes)
	ctx, scope := context.Background(), scopeFor("tenant-a")

	failure := errors.New("the record could not be written")
	var reference string
	err := manager.WithinTx(ctx, func(ctx context.Context) error {
		object, err := vault.Put(ctx, scope, blobstore.ClassSignature, "image/png", []byte("\x89PNG"))
		if err != nil {
			return err
		}
		reference = object.Reference
		// The owning record fails validation after the bytes were written.
		return failure
	})
	if !errors.Is(err, failure) {
		t.Fatalf("WithinTx: %v", err)
	}

	if _, err := vault.Get(ctx, scope, reference); !errors.Is(err, blobstore.ErrNotFound) {
		t.Fatalf("the rolled-back object is still readable: %v", err)
	}
	total, count, err := backend.InlineFootprint(ctx)
	if err != nil {
		t.Fatalf("InlineFootprint: %v", err)
	}
	if count != 0 || total != 0 {
		t.Errorf("a rolled-back write left %d bytes in %d rows", total, count)
	}
}

// An upload retried after an ambiguous failure must not fail on a key that is
// already there, or the caller is stranded with no way to complete.
func TestWritingTheSameKeyTwiceSucceeds(t *testing.T) {
	_, backend, _ := inlineVault(t, blobstore.DefaultPostgresMaxBytes)
	ctx := context.Background()
	key := "tenant-a/signature/abc/" + strings.Repeat("0", 64)

	for attempt := 1; attempt <= 2; attempt++ {
		if err := backend.Put(ctx, key, "image/png", []byte("\x89PNG")); err != nil {
			t.Fatalf("Put attempt %d: %v", attempt, err)
		}
	}
	total, count, err := backend.InlineFootprint(ctx)
	if err != nil {
		t.Fatalf("InlineFootprint: %v", err)
	}
	if count != 1 {
		t.Errorf("a retried upload produced %d rows (%d bytes)", count, total)
	}
}
