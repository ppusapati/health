// Package pgtx owns the transaction boundary.
//
// The application layer opens transactions; handlers never do (Blueprint §4.2).
// The active transaction travels in the context so that a repository and the
// outbox writer automatically enlist in the same unit of work — which is what
// makes "state change and outbox event commit atomically" (SRS-API-008) hold
// without every call site remembering to pass a tx handle.
package pgtx

import (
	"context"
	"errors"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/jackc/pgx/v5/pgxpool"
)

// DBTX is the query surface shared by a pool and a transaction. It matches the
// interface sqlc generates for pgx/v5.
type DBTX interface {
	Exec(context.Context, string, ...any) (pgconn.CommandTag, error)
	Query(context.Context, string, ...any) (pgx.Rows, error)
	QueryRow(context.Context, string, ...any) pgx.Row
}

// ErrNoTransaction is returned when a write that must be transactional runs
// outside a unit of work.
var ErrNoTransaction = errors.New("pgtx: operation requires an active transaction")

type txKey struct{}

// Manager opens units of work against a connection pool.
type Manager struct {
	pool *pgxpool.Pool
}

// NewManager constructs a Manager.
func NewManager(pool *pgxpool.Pool) *Manager { return &Manager{pool: pool} }

// Pool exposes the underlying pool for readiness checks.
func (m *Manager) Pool() *pgxpool.Pool { return m.pool }

// WithinTx runs fn inside a single database transaction. It commits when fn
// returns nil and rolls back otherwise, including on panic, so a partially
// applied aggregate write can never escape with its outbox row.
//
// Nested calls join the outer transaction rather than opening a second one:
// two transactions would defeat the atomicity the caller is asking for.
func (m *Manager) WithinTx(ctx context.Context, fn func(context.Context) error) (err error) {
	if _, ok := ctx.Value(txKey{}).(pgx.Tx); ok {
		return fn(ctx)
	}

	tx, err := m.pool.Begin(ctx)
	if err != nil {
		return err
	}

	defer func() {
		if p := recover(); p != nil {
			_ = tx.Rollback(ctx)
			panic(p)
		}
		if err != nil {
			_ = tx.Rollback(ctx)
		}
	}()

	if err = fn(context.WithValue(ctx, txKey{}, tx)); err != nil {
		return err
	}
	return tx.Commit(ctx)
}

// Querier returns the active transaction if one is open, otherwise the pool.
// Reads outside a transaction are legitimate; writes guard with RequireTx.
func (m *Manager) Querier(ctx context.Context) DBTX {
	if tx, ok := ctx.Value(txKey{}).(pgx.Tx); ok {
		return tx
	}
	return m.pool
}

// RequireTx returns the active transaction, or ErrNoTransaction. Writers that
// must be paired with an outbox row call this instead of Querier.
func RequireTx(ctx context.Context) (DBTX, error) {
	tx, ok := ctx.Value(txKey{}).(pgx.Tx)
	if !ok {
		return nil, ErrNoTransaction
	}
	return tx, nil
}
