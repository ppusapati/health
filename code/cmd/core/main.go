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
	"fmt"
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
	oidcadapter "github.com/ppusapati/health/code/internal/identity_access/adapters/oidc"
	identitypostgres "github.com/ppusapati/health/code/internal/identity_access/adapters/postgres"
	"github.com/ppusapati/health/code/internal/platform/obs"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
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
	ctx, stop := signal.NotifyContext(context.Background(), syscall.SIGINT, syscall.SIGTERM)
	defer stop()

	// Traces go to the collector named by OTEL_EXPORTER_OTLP_ENDPOINT. An
	// unreachable or misconfigured collector is a startup failure rather than a
	// warning: the deployment asked for telemetry, and a service that runs
	// happily with its spans going nowhere is one whose first incident is
	// investigated without them.
	shutdownTracing, err := obs.SetupFromEnv(ctx, "core", version)
	if err != nil {
		return err
	}
	defer func() {
		shutdownCtx, cancel := context.WithTimeout(context.Background(), shutdownTimeout)
		defer cancel()
		_ = shutdownTracing(shutdownCtx)
	}()

	// Transport security is settled before anything opens a socket
	// (SRS-SEC-001). Both checks are startup failures rather than warnings: a
	// process that logs "PHI is travelling in clear" and then serves traffic
	// has told nobody who was going to act on it.
	tlsMode, err := platformtransport.ParseTLSMode(os.Getenv("TLS_MODE"))
	if err != nil {
		return err
	}

	dsn := os.Getenv("DATABASE_URL")
	if dsn == "" {
		return errors.New("DATABASE_URL is required")
	}
	// ALLOW_LOCAL_PLAINTEXT_DB is the developer escape hatch, and it only ever
	// excuses a loopback address — see ValidateDatabaseDSN.
	if err := platformtransport.ValidateDatabaseDSN(dsn, os.Getenv("ALLOW_LOCAL_PLAINTEXT_DB") == "true"); err != nil {
		return err
	}

	pool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		return err
	}
	defer pool.Close()

	if err := pool.Ping(ctx); err != nil {
		return err
	}

	verifier, err := buildVerifier(ctx, os.Getenv("AUTH_MODE"), pool)
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

	httpServer := &http.Server{
		Addr:              addr,
		Handler:           h2c.NewHandler(server.Handler, &http2.Server{}),
		ReadHeaderTimeout: readHeaderTimeout,
	}

	errCh := make(chan error, 2)
	go func() {
		slog.Info("core service listening",
			slog.String("addr", addr),
			slog.String("tls_mode", string(tlsMode)),
			slog.String("version", version))
		if err := serve(httpServer, tlsMode); err != nil && !errors.Is(err, http.ErrServerClosed) {
			errCh <- err
		}
	}()

	// The outbox publisher and the event consumers run in the same process as
	// the API (ADR-005). A failure here is fatal rather than logged: events
	// that are written but never published are invisible — the writes keep
	// succeeding, the API keeps answering, and only the consumers' silence
	// says anything is wrong.
	backgroundCtx, stopBackground := context.WithCancel(ctx)
	defer stopBackground()
	go func() {
		if err := server.RunBackground(backgroundCtx); err != nil && !errors.Is(err, context.Canceled) {
			errCh <- fmt.Errorf("event delivery stopped: %w", err)
		}
	}()

	select {
	case err := <-errCh:
		return err
	case <-ctx.Done():
		slog.Info("shutdown signal received")
	}

	// Stop consuming before draining HTTP, so a handler that publishes during
	// shutdown still has an outbox to publish into — the row is durable either
	// way, and the next process to start drains it.
	stopBackground()

	shutdownCtx, cancel := context.WithTimeout(context.Background(), shutdownTimeout)
	defer cancel()
	return httpServer.Shutdown(shutdownCtx)
}

// serve starts the listener under the declared transport mode.
//
// TLSModeMesh serves h2c: ConnectRPC needs HTTP/2, the sidecar terminates
// mTLS, and the NetworkPolicy keeps anything else off the port. TLSModeServe
// terminates TLS here, under ServerTLSConfig, for topologies with no mesh.
func serve(s *http.Server, mode platformtransport.TLSMode) error {
	if mode == platformtransport.TLSModeMesh {
		return s.ListenAndServe()
	}
	certFile, keyFile := os.Getenv("TLS_CERT_FILE"), os.Getenv("TLS_KEY_FILE")
	if certFile == "" || keyFile == "" {
		return errors.New("TLS_MODE=serve requires TLS_CERT_FILE and TLS_KEY_FILE")
	}
	// The h2c wrapper is harmless here — a TLS listener negotiates h2 through
	// ALPN and never reaches the prior-knowledge upgrade path.
	s.TLSConfig = platformtransport.ServerTLSConfig()
	return s.ListenAndServeTLS(certFile, keyFile)
}

// buildVerifier selects the identity provider.
//
// ADR-008 is closed: `oidc` is the production verifier and `dev` remains for
// local development. AUTH_MODE has no default and an unknown value is a hard
// failure, so there is no insecure mode reachable by configuration drift.
func buildVerifier(ctx context.Context, mode string, pool *pgxpool.Pool) (platformtransport.TokenVerifier, error) {
	switch mode = strings.ToLower(mode); mode {
	case "oidc":
		return buildOIDCVerifier(ctx, pool)
	case "dev":
		slog.Warn("using development token verifier; not for production")
		return devauth.New(true)
	case "":
		return nil, errors.New("AUTH_MODE is required (oidc, or dev for local development)")
	default:
		return nil, errors.New("unsupported AUTH_MODE: " + mode)
	}
}

// buildOIDCVerifier assembles the production verifier (ADR-008).
//
// Federations are read from the database rather than configured here, because
// each tenant brings its own identity provider and a deployment serves many:
// adding a customer must not require a redeploy.
func buildOIDCVerifier(_ context.Context, pool *pgxpool.Pool) (platformtransport.TokenVerifier, error) {
	audience := os.Getenv("OIDC_AUDIENCE")
	if audience == "" {
		// Without an audience every token any provider ever issued for any
		// application would be accepted here.
		return nil, errors.New("OIDC_AUDIENCE is required when AUTH_MODE=oidc")
	}

	cfg := oidcadapter.Config{Audience: audience}

	// A tenant that requires MFA states the acr/amr values that satisfy it.
	// Absent means the tenant has not asked, which is their decision rather
	// than a default this code picks (SRS-IAM-010).
	if raw := os.Getenv("OIDC_REQUIRED_ACR"); raw != "" {
		for _, value := range strings.Split(raw, ",") {
			if trimmed := strings.TrimSpace(value); trimmed != "" {
				cfg.RequiredACRValues = append(cfg.RequiredACRValues, trimmed)
			}
		}
	}
	if raw := os.Getenv("OIDC_CLOCK_SKEW"); raw != "" {
		skew, err := time.ParseDuration(raw)
		if err != nil {
			return nil, errors.New("OIDC_CLOCK_SKEW is not a duration: " + raw)
		}
		cfg.ClockSkew = skew
	}

	repo := identitypostgres.New(pgtx.NewManager(pool))
	return oidcadapter.New(cfg, repo, repo, systemClock{})
}

// systemClock reads the wall clock.
type systemClock struct{}

func (systemClock) Now() time.Time { return time.Now().UTC() }
