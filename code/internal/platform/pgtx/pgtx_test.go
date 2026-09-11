package pgtx_test

import (
	"context"
	"errors"
	"sync"
	"testing"

	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
)

// After-commit hooks exist so a side effect cannot be triggered by a change
// that has not happened yet — or, worse, by one that never happens. These run
// against a real database because the whole point is the ordering against an
// actual commit.

func TestAfterCommitRunsOnceCommitted(t *testing.T) {
	tx := pgtx.NewManager(pgtest.New(t))

	var order []string
	err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
		if err := pgtx.AfterCommit(ctx, func() { order = append(order, "hook") }); err != nil {
			return err
		}
		order = append(order, "body")
		return nil
	})
	if err != nil {
		t.Fatalf("WithinTx: %v", err)
	}

	if len(order) != 2 || order[0] != "body" || order[1] != "hook" {
		t.Fatalf("hook ran in the wrong place: %v", order)
	}
}

// A rolled-back transaction must fire nothing. This is the case the feature is
// for: a notification about a facility that was never created sends a consumer
// looking for a row that does not exist.
func TestAfterCommitDoesNotRunOnRollback(t *testing.T) {
	tx := pgtx.NewManager(pgtest.New(t))

	ran := false
	boom := errors.New("boom")

	err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
		if hookErr := pgtx.AfterCommit(ctx, func() { ran = true }); hookErr != nil {
			return hookErr
		}
		return boom
	})
	if !errors.Is(err, boom) {
		t.Fatalf("WithinTx = %v, want boom", err)
	}
	if ran {
		t.Fatal("an after-commit hook ran for a transaction that rolled back")
	}
}

func TestAfterCommitDoesNotRunOnPanic(t *testing.T) {
	tx := pgtx.NewManager(pgtest.New(t))

	ran := false
	func() {
		defer func() {
			if recover() == nil {
				t.Error("the panic did not propagate")
			}
		}()
		_ = tx.WithinTx(context.Background(), func(ctx context.Context) error {
			_ = pgtx.AfterCommit(ctx, func() { ran = true })
			panic("handler exploded")
		})
	}()

	if ran {
		t.Fatal("an after-commit hook ran for a transaction that panicked")
	}
}

// Hooks registered by a nested unit of work belong to the outermost
// transaction, because that is the one whose commit makes them true.
func TestNestedRegistrationDefersToTheOuterCommit(t *testing.T) {
	tx := pgtx.NewManager(pgtest.New(t))

	var order []string
	err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
		return tx.WithinTx(ctx, func(ctx context.Context) error {
			if err := pgtx.AfterCommit(ctx, func() { order = append(order, "hook") }); err != nil {
				return err
			}
			order = append(order, "inner")
			return nil
		})
	})
	if err != nil {
		t.Fatalf("WithinTx: %v", err)
	}
	if len(order) != 2 || order[1] != "hook" {
		t.Fatalf("the nested hook did not wait for the outer commit: %v", order)
	}
}

// Outside a transaction the request is refused rather than honoured
// immediately. Running it would silently reinterpret "after this commits" as
// "now", which is the failure the type is meant to prevent.
func TestAfterCommitRefusesOutsideATransaction(t *testing.T) {
	ran := false
	err := pgtx.AfterCommit(context.Background(), func() { ran = true })
	if !errors.Is(err, pgtx.ErrNoTransaction) {
		t.Fatalf("AfterCommit = %v, want ErrNoTransaction", err)
	}
	if ran {
		t.Fatal("the hook ran outside a transaction")
	}
}

// One bad hook must not take the others with it, and must not unwind past a
// commit that already succeeded.
func TestAPanickingHookDoesNotFailTheTransaction(t *testing.T) {
	tx := pgtx.NewManager(pgtest.New(t))

	second := false
	err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
		if err := pgtx.AfterCommit(ctx, func() { panic("hook exploded") }); err != nil {
			return err
		}
		return pgtx.AfterCommit(ctx, func() { second = true })
	})
	if err != nil {
		t.Fatalf("a panicking hook failed a committed transaction: %v", err)
	}
	if !second {
		t.Fatal("the second hook did not run")
	}
}

// Hooks are registered from whatever goroutines the unit of work used.
func TestConcurrentRegistrationIsSafe(t *testing.T) {
	tx := pgtx.NewManager(pgtest.New(t))

	const n = 32
	var count struct {
		sync.Mutex
		n int
	}

	err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
		var wg sync.WaitGroup
		for range n {
			wg.Add(1)
			go func() {
				defer wg.Done()
				_ = pgtx.AfterCommit(ctx, func() {
					count.Lock()
					count.n++
					count.Unlock()
				})
			}()
		}
		wg.Wait()
		return nil
	})
	if err != nil {
		t.Fatalf("WithinTx: %v", err)
	}
	if count.n != n {
		t.Fatalf("ran %d hooks, want %d", count.n, n)
	}
}
