// Command core runs the core-hospital deployable.
//
// Wave 0 ships a single Go binary hosting the organization and identity
// bounded contexts as separate modules (Blueprint §5, ADR-001: modular monolith
// first). Extraction to independent services later needs no contract change,
// because the module boundary is already the proto package and the outbox.
package main

import (
	"context"
	"errors"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"syscall"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/ppusapati/health/code/internal/app"
	"github.com/ppusapati/health/code/internal/identity_access/adapters/devauth"
	"github.com/ppusapati/health/code/internal/platform/obs"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
	platformapitransport "github.com/ppusapati/health/code/internal/platform_api/transport"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
)

// Stamped at build time via -ldflags.
var (
	version = "dev"
	commit  = "unknown"
	builtAt = "unknown"
)

const (
	readHeaderTimeout = 10 * time.Second
	shutdownTimeout   = 20 * time.Second
)

func main() {
	if err := run(); err != nil {
		slog.Error("server exited with error", slog.String("error", err.Error()))
		os.Exit(1)
	}
}

func run() error {
	shutdownTracing := obs.Setup("core")
	defer func() {
		ctx, cancel := context.WithTimeout(context.Background(), shutdownTimeout)
		defer cancel()
		_ = shutdownTracing(ctx)
	}()

	ctx, stop := signal.NotifyContext(context.Background(), syscall.SIGINT, syscall.SIGTERM)
	defer stop()

	dsn := os.Getenv("DATABASE_URL")
	if dsn == "" {
		return errors.New("DATABASE_URL is required")
	}

	pool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		return err
	}
	defer pool.Close()

	if err := pool.Ping(ctx); err != nil {
		return err
	}

	verifier, err := buildVerifier()
	if err != nil {
		return err
	}

	server := app.New(app.Deps{
		Pool:     pool,
		Verifier: verifier,
		Build: platformapitransport.BuildInfo{
			Version: version, Commit: commit, BuiltAt: builtAt,
		},
	})

	addr := os.Getenv("LISTEN_ADDR")
	if addr == "" {
		addr = ":8080"
	}

	// h2c lets ConnectRPC serve gRPC and gRPC-Web over plaintext HTTP/2 behind
	// a TLS-terminating ingress, which is how the cluster fronts this service.
	httpServer := &http.Server{
		Addr:              addr,
		Handler:           h2c.NewHandler(server.Handler, &http2.Server{}),
		ReadHeaderTimeout: readHeaderTimeout,
	}

	errCh := make(chan error, 1)
	go func() {
		slog.Info("core service listening", slog.String("addr", addr), slog.String("version", version))
		if err := httpServer.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
			errCh <- err
		}
	}()

	select {
	case err := <-errCh:
		return err
	case <-ctx.Done():
		slog.Info("shutdown signal received")
	}

	shutdownCtx, cancel := context.WithTimeout(context.Background(), shutdownTimeout)
	defer cancel()
	return httpServer.Shutdown(shutdownCtx)
}

// buildVerifier selects the identity provider.
//
// ADR-008 is still open, so the only implementation available today is the
// development verifier, and it must be requested explicitly. Any other value —
// including the empty string — is a hard failure rather than a silent fallback
// to an insecure default.
func buildVerifier() (platformtransport.TokenVerifier, error) {
	switch mode := strings.ToLower(os.Getenv("AUTH_MODE")); mode {
	case "dev":
		slog.Warn("using development token verifier; not for production (ADR-008 open)")
		return devauth.New(true)
	case "":
		return nil, errors.New("AUTH_MODE is required (set AUTH_MODE=dev for local development)")
	default:
		return nil, errors.New("unsupported AUTH_MODE: " + mode)
	}
}
