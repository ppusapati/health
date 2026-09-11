// Package app is the composition root.
//
// Every concrete dependency is chosen here and nowhere else, which is what lets
// the integration tests assemble the identical stack against a real database
// while main.go stays a thin entry point.
package app

import (
	"context"
	"net/http"
	"time"

	"connectrpc.com/connect"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/ppusapati/health/code/gen/go/healthcare/identity_access/v1/identityaccessv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/platform_api/v1/platformapiv1connect"
	identitytransport "github.com/ppusapati/health/code/internal/identity_access/transport"
	orgpostgres "github.com/ppusapati/health/code/internal/organization/adapters/postgres"
	orgapp "github.com/ppusapati/health/code/internal/organization/application"
	orgtransport "github.com/ppusapati/health/code/internal/organization/transport"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/store"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
	platformapitransport "github.com/ppusapati/health/code/internal/platform_api/transport"
)

// uuidGenerator mints opaque v4 identifiers. Business meaning is never encoded
// into a key (Domain/Data spec §3.1).
type uuidGenerator struct{}

func (uuidGenerator) NewID() string { return uuid.NewString() }

// systemClock is the production clock.
type systemClock struct{}

func (systemClock) Now() time.Time { return time.Now().UTC() }

// poolPinger adapts the pgx pool to the readiness check.
type poolPinger struct{ pool *pgxpool.Pool }

func (p poolPinger) Ping(ctx context.Context) error { return p.pool.Ping(ctx) }

// Deps are the externally supplied collaborators.
type Deps struct {
	Pool     *pgxpool.Pool
	Verifier platformtransport.TokenVerifier
	Build    platformapitransport.BuildInfo

	// RateLimit bounds per-caller request rate (SRS-SEC-005). The zero value
	// disables limiting, which is why the composition root supplies a default
	// rather than leaving it unset.
	RateLimit platformtransport.RateLimitConfig
}

// Server holds the assembled HTTP handler and the services behind it.
type Server struct {
	Handler      http.Handler
	Organization *orgapp.Service
	Store        *store.Store
	RateLimiter  *platformtransport.RateLimiter
}

// New wires the whole stack and returns the ready-to-serve handler.
func New(deps Deps) *Server {
	if deps.RateLimit.RequestsPerSecond == 0 {
		deps.RateLimit = platformtransport.DefaultRateLimit()
	}

	txManager := pgtx.NewManager(deps.Pool)

	repo := orgpostgres.New(txManager)
	platformStore := store.New(txManager)

	orgService := orgapp.NewService(
		txManager,
		orgpostgres.TenantRepo{Repository: repo},
		orgpostgres.FacilityRepo{Repository: repo},
		platformStore,
		store.AuditAppenderFunc(platformStore.AppendAudit),
		uuidGenerator{},
		systemClock{},
	)

	// Order matters.
	//
	// Tracing is outermost so a rejected request still produces a span. The
	// peer rate limit comes before authentication, so an unauthenticated flood
	// is refused without paying for token verification. The error interceptor
	// wraps auth, so an authentication failure is rendered through the same
	// error contract as everything else. The subject rate limit comes after
	// auth, where a caller identity finally exists to key on.
	rateLimiter := platformtransport.NewRateLimiter(deps.RateLimit, nil)

	interceptors := connect.WithInterceptors(
		platformtransport.NewTracingInterceptor(),
		platformtransport.NewErrorInterceptor(),
		platformtransport.NewPeerRateLimitInterceptor(rateLimiter),
		platformtransport.NewAuthInterceptor(deps.Verifier),
		platformtransport.NewSubjectRateLimitInterceptor(rateLimiter),
	)

	mux := http.NewServeMux()
	mux.Handle(organizationv1connect.NewOrganizationServiceHandler(
		orgtransport.NewHandler(orgService), interceptors))
	mux.Handle(identityaccessv1connect.NewIdentityServiceHandler(
		identitytransport.NewHandler(orgService), interceptors))
	mux.Handle(platformapiv1connect.NewHealthServiceHandler(
		platformapitransport.NewHandler(deps.Build, map[string]platformapitransport.Pinger{
			"postgres": poolPinger{pool: deps.Pool},
		}), interceptors))

	return &Server{
		Handler:      mux,
		Organization: orgService,
		Store:        platformStore,
		RateLimiter:  rateLimiter,
	}
}
