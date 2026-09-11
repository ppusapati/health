// Package pgtest provides the real-PostgreSQL harness for repository and
// end-to-end tests.
//
// Repository tests run against a real database, never a mocked SQL layer
// (Testing Master Plan §9, SRS-DAT-002): constraints, SQLSTATE codes, cursor
// ordering and transaction semantics are exactly the things a mock gets wrong.
//
// Each caller gets its own freshly migrated database, so tests are independent
// and can run in parallel without coordinating fixtures.
package pgtest

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"runtime"
	"sort"
	"strings"
	"testing"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
)

// EnvDatabaseURL names the admin connection string used to create per-test
// databases.
const EnvDatabaseURL = "TEST_DATABASE_URL"

// New returns a pool connected to a freshly migrated, uniquely named database.
// The database is dropped when the test finishes.
//
// If EnvDatabaseURL is unset the test is skipped rather than failed, so `go
// test ./...` stays usable on a laptop without PostgreSQL while CI runs the
// full set.
func New(t *testing.T) *pgxpool.Pool {
	t.Helper()

	adminURL := os.Getenv(EnvDatabaseURL)
	if adminURL == "" {
		t.Skipf("%s is not set; skipping repository integration test", EnvDatabaseURL)
	}

	ctx, cancel := context.WithTimeout(context.Background(), 60*time.Second)
	defer cancel()

	admin, err := pgxpool.New(ctx, adminURL)
	if err != nil {
		t.Fatalf("connect admin database: %v", err)
	}
	defer admin.Close()

	dbName := uniqueDatabaseName(t)
	if _, err := admin.Exec(ctx, fmt.Sprintf("CREATE DATABASE %q", dbName)); err != nil {
		t.Fatalf("create database %s: %v", dbName, err)
	}

	pool, err := pgxpool.New(ctx, replaceDatabase(adminURL, dbName))
	if err != nil {
		t.Fatalf("connect test database: %v", err)
	}

	if err := Migrate(ctx, pool); err != nil {
		pool.Close()
		t.Fatalf("migrate: %v", err)
	}

	t.Cleanup(func() {
		pool.Close()

		cleanupCtx, cleanupCancel := context.WithTimeout(context.Background(), 30*time.Second)
		defer cleanupCancel()

		dropper, err := pgxpool.New(cleanupCtx, adminURL)
		if err != nil {
			return
		}
		defer dropper.Close()
		// FORCE terminates any connection the test left behind, so a leaked
		// pool cannot wedge the drop and leak a database per run.
		_, _ = dropper.Exec(cleanupCtx, fmt.Sprintf("DROP DATABASE IF EXISTS %q WITH (FORCE)", dbName))
	})

	return pool
}

// Migrate applies every up migration in lexical order. Wave 0 uses plain
// ordered SQL files; a migration tool can replace this without changing the
// files themselves.
func Migrate(ctx context.Context, pool *pgxpool.Pool) error {
	files, err := filepath.Glob(filepath.Join(migrationsDir(), "*.up.sql"))
	if err != nil {
		return err
	}
	if len(files) == 0 {
		return fmt.Errorf("pgtest: no migrations found in %s", migrationsDir())
	}
	sort.Strings(files)

	for _, file := range files {
		sqlBytes, err := os.ReadFile(file)
		if err != nil {
			return err
		}
		if _, err := pool.Exec(ctx, string(sqlBytes)); err != nil {
			return fmt.Errorf("apply %s: %w", filepath.Base(file), err)
		}
	}
	return nil
}

// migrationsDir locates db/migrations relative to this source file, so tests
// work regardless of the package they run from.
func migrationsDir() string {
	_, thisFile, _, _ := runtime.Caller(0)
	return filepath.Join(filepath.Dir(thisFile), "..", "..", "..", "db", "migrations")
}

// uniqueDatabaseName derives a readable, collision-free name from the test.
func uniqueDatabaseName(t *testing.T) string {
	safe := strings.Map(func(r rune) rune {
		switch {
		case r >= 'a' && r <= 'z', r >= '0' && r <= '9':
			return r
		case r >= 'A' && r <= 'Z':
			return r + 32
		default:
			return '_'
		}
	}, t.Name())

	const maxNameLen = 30
	if len(safe) > maxNameLen {
		safe = safe[:maxNameLen]
	}
	return fmt.Sprintf("ht_%s_%d", safe, time.Now().UnixNano())
}

// replaceDatabase swaps the database component of a libpq URL.
func replaceDatabase(url, dbName string) string {
	base, query, hasQuery := strings.Cut(url, "?")

	slash := strings.LastIndex(base, "/")
	if slash == -1 {
		base += "/" + dbName
	} else {
		base = base[:slash+1] + dbName
	}

	if hasQuery {
		return base + "?" + query
	}
	return base
}
