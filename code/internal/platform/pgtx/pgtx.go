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
	"fmt"
	"log/slog"
	"runtime/debug"
	"sync"

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

type hooksKey struct{}

// commitHooks collects work that must not happen until the transaction is
// durable.
//
// The motivating case is waking a consumer: a notification sent from inside
// the transaction arrives before the rows it is about are visible, so the
// woken worker looks, finds nothing, and goes back to sleep until its next
// poll. The notification was not merely early — it was wasted, and the latency
// it was meant to remove is paid in full.
type commitHooks struct {
	mu  sync.Mutex
	fns []func()
}

func (h *commitHooks) add(fn func()) {
	h.mu.Lock()
	defer h.mu.Unlock()
	h.fns = append(h.fns, fn)
}

// run executes the hooks in registration order.
//
// The transaction has already committed, so a hook cannot undo anything and
// must not be allowed to try: a panic here would unwind past a committed
// transaction and lose the caller's successful return. It is logged and the
// remaining hooks still run.
func (h *commitHooks) run(ctx context.Context) {
	h.mu.Lock()
	fns := h.fns
	h.fns = nil
	h.mu.Unlock()

	for _, fn := range fns {
		func() {
			defer func() {
				if p := recover(); p != nil {
					// The panic value itself is never logged: it is an
					// arbitrary value from application code and may carry
					// patient data (FIT-06). The type and the stack say where
					// to look without saying what was in it.
					slog.ErrorContext(ctx, "after-commit hook panicked",
						slog.String("panic_type", fmt.Sprintf("%T", p)),
						slog.String("stack", string(debug.Stack())))
				}
			}()
			fn()
		}()
	}
}

// AfterCommit registers fn to run once the active transaction commits.
//
// Returns ErrNoTransaction outside a transaction rather than running fn
// immediately. Running it would be the more forgiving choice and the wrong
// one: the caller asked for "after this commits", and silently reinterpreting
// that as "now" is how a notification comes to be sent for a change that never
// happened.
//
// fn returns nothing, because by the time it runs there is no longer anything
// a failure could affect. Anything that must be able to fail the unit of work
// belongs inside it.
func AfterCommit(ctx context.Context, fn func()) error {
	hooks, ok := ctx.Value(hooksKey{}).(*commitHooks)
	if !ok {
		return ErrNoTransaction
	}
	hooks.add(fn)
	return nil
}

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
// two transactions would defeat the atomicity the caller is asking for. They
// also share the outer call's after-commit hooks, so a nested unit of work
// cannot have its side effects fire before the transaction it is actually part
// of is durable.
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

	hooks := &commitHooks{}
	txCtx := context.WithValue(context.WithValue(ctx, txKey{}, tx), hooksKey{}, hooks)

	if err = fn(txCtx); err != nil {
		return err
	}
	if err = tx.Commit(ctx); err != nil {
		return err
	}

	hooks.run(ctx)
	return nil
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
