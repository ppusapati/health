package blobstore

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// DefaultPostgresMaxBytes is the cap on inlined content.
//
// 64 KiB holds a captured signature, a thumbnail, a barcode image — the class
// of object where putting the bytes in the object store costs more than it
// saves, because the object store is a second system that can be unavailable
// and can be restored to a different point in time than the record that
// references it. It does not hold a photograph or a scanned report, and it is
// not meant to.
const DefaultPostgresMaxBytes = 64 << 10

// Postgres stores small objects inline in the database.
//
// A documented, bounded deviation from SRS-DAT-007, which says object content
// belongs in an encrypted object store. The reasoning is in
// db/migrations/0026_platform_blob.up.sql and comes down to this: the rule
// exists because large blobs wreck a database's operational profile, and that
// argument does not apply below a few tens of kilobytes, where the opposite
// argument does — a consent signature restored to a different instant than the
// consent record it signs is a record that silently disagrees with itself.
//
// The bound is enforced in three places, which is not redundancy but defence
// against the three different ways it gets lost: here, so the error names what
// to do; in NewVault, so a class routed here whose limit exceeds this one
// fails at boot rather than at the first large upload; and as a CHECK
// constraint in the schema, so raising it takes a migration and a review
// rather than an environment variable.
//
// Encryption at rest is the database's — the volume and the backups — so
// KMSKeyAlias reports whatever the deployment says encrypts the cluster, and
// reports nothing when the deployment says nothing. An alias invented here
// would be a claim about encryption that nothing verifies.
type Postgres struct {
	name  string
	tx    *pgtx.Manager
	kms   string
	limit int64
	now   func() time.Time
}

// PostgresOptions configures the inline backend.
type PostgresOptions struct {
	// Name is the identifier recorded in references. Required, and permanent
	// for the life of the objects written under it.
	Name string
	// Transactions is the manager the rest of the platform writes through, so
	// an inlined object enlists in whatever transaction its owning record is
	// being written in. That is the property this backend exists for: the
	// bytes and the row commit together or not at all.
	Transactions *pgtx.Manager
	// KMSKeyAlias names the key the database volume is encrypted under, if the
	// deployment encrypts it. Empty means nothing here claims to.
	KMSKeyAlias string
	// MaxBytes caps inlined content. Zero takes DefaultPostgresMaxBytes. It
	// may be lowered freely; raising it above the schema's CHECK constraint
	// only moves where the write fails.
	MaxBytes int64
	// Now overrides the clock.
	Now func() time.Time
}

// NewPostgres prepares the inline backend.
func NewPostgres(opts PostgresOptions) (*Postgres, error) {
	if strings.TrimSpace(opts.Name) == "" {
		return nil, errors.New("blobstore: a postgres backend needs a name")
	}
	if opts.Transactions == nil {
		return nil, errors.New("blobstore: a postgres backend needs a transaction manager")
	}
	limit := opts.MaxBytes
	if limit <= 0 {
		limit = DefaultPostgresMaxBytes
	}
	if limit > DefaultPostgresMaxBytes {
		// The schema's CHECK is at 64 KiB. Accepting a larger configured limit
		// would mean the boot-time route check in NewVault passes and the
		// write then fails on a constraint, which is the failure mode this
		// package is built to avoid.
		return nil, fmt.Errorf(
			"blobstore: postgres backend %q is configured for %d bytes, but the schema "+
				"caps inlined content at %d; route larger content to an object store",
			opts.Name, limit, DefaultPostgresMaxBytes)
	}
	now := opts.Now
	if now == nil {
		now = time.Now
	}
	return &Postgres{
		name: opts.Name, tx: opts.Transactions,
		kms: opts.KMSKeyAlias, limit: limit, now: now,
	}, nil
}

// Name identifies the backend in references.
func (p *Postgres) Name() string { return p.name }

// KMSKeyAlias names whatever encrypts the database volume, or "".
func (p *Postgres) KMSKeyAlias() string { return p.kms }

// MaxBytes implements Limiter.
func (p *Postgres) MaxBytes() int64 { return p.limit }

func (p *Postgres) queries(ctx context.Context) *sqlcgen.Queries {
	return sqlcgen.New(p.tx.Querier(ctx))
}

// Put inlines the content.
//
// Refused rather than redirected when it is too large. A backend that quietly
// sent oversized content somewhere else would leave a deployment believing its
// signatures are in the database while half of them are not — the worst of
// both arrangements, and invisible until a restore.
func (p *Postgres) Put(ctx context.Context, key, contentType string, content []byte) error {
	if err := ctx.Err(); err != nil {
		return err
	}
	if int64(len(content)) > p.limit {
		return fmt.Errorf(
			"%w: %d bytes exceeds the %d backend %q inlines; route this class to an object store",
			ErrTooLarge, len(content), p.limit, p.name)
	}
	return p.queries(ctx).PutInlineObject(ctx, sqlcgen.PutInlineObjectParams{
		ObjectKey:   key,
		ContentType: contentType,
		SizeBytes:   int64(len(content)),
		Content:     content,
		WrittenAt:   timestamptz(p.now()),
	})
}

// Get reads the content back.
func (p *Postgres) Get(ctx context.Context, key string) ([]byte, error) {
	if err := ctx.Err(); err != nil {
		return nil, err
	}
	content, err := p.queries(ctx).GetInlineObject(ctx, key)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, fmt.Errorf("%w: %s", ErrNotFound, key)
	}
	if err != nil {
		return nil, fmt.Errorf("blobstore: reading %q: %w", key, err)
	}
	return content, nil
}

// Delete removes the content, and does not mind if it is already gone.
func (p *Postgres) Delete(ctx context.Context, key string) error {
	if err := ctx.Err(); err != nil {
		return err
	}
	if err := p.queries(ctx).DeleteInlineObject(ctx, key); err != nil {
		return fmt.Errorf("blobstore: deleting %q: %w", key, err)
	}
	return nil
}

// InlineFootprint reports how much of the database is blob content.
//
// The question this backend creates, so it answers it. A deployment that
// inlines content needs to know when the exception has stopped being small —
// the cap bounds each object, not how many there are.
func (p *Postgres) InlineFootprint(ctx context.Context) (totalBytes, objects int64, err error) {
	row, err := p.queries(ctx).SumInlineObjectBytes(ctx)
	if err != nil {
		return 0, 0, fmt.Errorf("blobstore: measuring inline content: %w", err)
	}
	return row.TotalBytes, row.ObjectCount, nil
}

var (
	_ Backend = (*Postgres)(nil)
	_ Limiter = (*Postgres)(nil)
)

func timestamptz(t time.Time) pgtype.Timestamptz {
	return pgtype.Timestamptz{Time: t.UTC(), Valid: true}
}
