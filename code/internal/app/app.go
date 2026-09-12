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
	"github.com/ppusapati/health/code/gen/go/healthcare/empi/v1/empiv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1/encounterv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/identity_access/v1/identityaccessv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/platform_api/v1/platformapiv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/scheduling/v1/schedulingv1connect"
	empipostgres "github.com/ppusapati/health/code/internal/empi/adapters/postgres"
	empiapp "github.com/ppusapati/health/code/internal/empi/application"
	empiports "github.com/ppusapati/health/code/internal/empi/ports"
	empitransport "github.com/ppusapati/health/code/internal/empi/transport"
	encounterpostgres "github.com/ppusapati/health/code/internal/encounter/adapters/postgres"
	encounterapp "github.com/ppusapati/health/code/internal/encounter/application"
	encountertransport "github.com/ppusapati/health/code/internal/encounter/transport"
	identitytransport "github.com/ppusapati/health/code/internal/identity_access/transport"
	orgpostgres "github.com/ppusapati/health/code/internal/organization/adapters/postgres"
	orgapp "github.com/ppusapati/health/code/internal/organization/application"
	orgtransport "github.com/ppusapati/health/code/internal/organization/transport"
	"github.com/ppusapati/health/code/internal/platform/eventbus"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/store"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
	platformapitransport "github.com/ppusapati/health/code/internal/platform_api/transport"
	schedulingpostgres "github.com/ppusapati/health/code/internal/scheduling/adapters/postgres"
	schedulingapp "github.com/ppusapati/health/code/internal/scheduling/application"
	schedulingports "github.com/ppusapati/health/code/internal/scheduling/ports"
	schedulingtransport "github.com/ppusapati/health/code/internal/scheduling/transport"
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

	// ProcedureDeadlines overrides the default request budget for named
	// procedures (SRS-API-010). Nil gives every procedure the default, which
	// is the right answer for anything that should not be slow — a genuinely
	// long operation belongs in a job (SRS-API-011) rather than a longer
	// timeout.
	ProcedureDeadlines map[string]time.Duration

	// SecurityHeaders is the browser security baseline (SRS-WEB-015). The zero
	// value sends a CSP with no configured connect sources, which breaks a
	// split-origin deployment loudly rather than quietly — so the composition
	// root fills in a default below.
	SecurityHeaders platformtransport.SecurityHeaderConfig

	// Revoker refuses sessions belonging to disabled or moved users
	// (SRS-IAM-006). Nil disables the check, which is correct only where no
	// revocation store exists yet — ADR-008 is open, so the development
	// verifier has nothing to revoke against.
	Revoker platformtransport.SessionRevoker

	// Consumers are the event subscriptions this process drives (ADR-005).
	//
	// Empty is a valid deployment: a process that serves requests and
	// publishes but consumes nothing. It is also the Wave-0 default, because
	// consumers belong to the modules that need them and Wave 1 is where those
	// arrive.
	Consumers []eventbus.Registration

	// PublishInterval is how often the outbox is drained. Zero takes the
	// default.
	PublishInterval time.Duration

	// IdentifierRegistries resolves an identifier system to the authority that
	// issues it (SRS-EMPI-011).
	//
	// Nil is a valid deployment and the default: a hospital with no national
	// identifier adapter links every external identifier as asserted, which is
	// an honest record of what it actually knows. Wiring a registry is what
	// makes verification possible, not what makes linking possible.
	IdentifierRegistries empiports.IdentifierRegistries

	// PhotoStore holds patient photograph bytes (SRS-EMPI-010).
	//
	// Nil is a valid deployment and the default: one that does not store
	// patient photographs refuses to capture one rather than recording a row
	// that points at nothing.
	PhotoStore empiports.PhotoStore

	// MeetingProvider mints teleconsult join links (SRS-SCH-015).
	//
	// Nil is a valid deployment and the default: a hospital that runs no video
	// service books teleconsults with no link, and the absence is visible rather
	// than a broken URL.
	MeetingProvider schedulingports.MeetingProvider
}

// Server holds the assembled HTTP handler and the services behind it.
type Server struct {
	Handler      http.Handler
	Organization *orgapp.Service
	Patients     *empiapp.Service
	Scheduling   *schedulingapp.Service
	Encounters   *encounterapp.Service
	Store        *store.Store
	RateLimiter  *platformtransport.RateLimiter

	// Publisher drains the outbox; Events drives the consumers. Both are nil
	// only if New failed to build them, which it reports through Err.
	Publisher *store.Publisher
	Events    *eventbus.Runtime

	// Err carries a wiring failure. New does not return an error because every
	// other dependency here is infallible, and a Server that cannot run its
	// consumers must not quietly serve requests — RunBackground surfaces it.
	Err error

	publishInterval time.Duration
}

// New wires the whole stack and returns the ready-to-serve handler.
func New(deps Deps) *Server {
	if deps.RateLimit.RequestsPerSecond == 0 {
		deps.RateLimit = platformtransport.DefaultRateLimit()
	}
	if len(deps.SecurityHeaders.ConnectSources) == 0 {
		deps.SecurityHeaders = platformtransport.DefaultSecurityHeaders()
	}

	txManager := pgtx.NewManager(deps.Pool)

	repo := orgpostgres.New(txManager)
	platformStore := store.New(txManager)

	// Event delivery (ADR-005). The runtime is built before the broker because
	// the broker notifies it: publishing an event wakes exactly the consumers
	// that asked for that type, which is what keeps steady-state delivery
	// latency at milliseconds rather than at the poll interval.
	events, eventsErr := eventbus.NewRuntime(platformStore, deps.Consumers...)
	var publisher *store.Publisher
	if eventsErr == nil {
		publisher = store.NewPublisher(platformStore,
			store.NewPgBroker(platformStore, events.Notify, nil),
			store.DefaultBatchSize)
	}

	// The patient index (SRS-EMPI). It reuses the organization context's
	// numbering sequence for the MRN rather than minting one: that statement
	// takes a row lock, which is what makes MRN issuance collision-free under
	// concurrent registration (SRS-EMPI-016).
	empiRepo := empipostgres.New(txManager)
	empiService := empiapp.NewService(empiapp.Deps{
		UnitOfWork:   txManager,
		Patients:     empipostgres.PatientRepo{Repository: empiRepo},
		Identifiers:  empipostgres.IdentifierRepo{Repository: empiRepo},
		Config:       empipostgres.ConfigRepo{Repository: empiRepo},
		Merges:       empipostgres.MergeRepo{Repository: empiRepo},
		History:      empipostgres.HistoryRepo{Repository: empiRepo},
		Proposals:    empipostgres.ProposalRepo{Repository: empiRepo},
		Photos:       empipostgres.PhotoRepo{Repository: empiRepo},
		PhotoStore:   deps.PhotoStore,
		Unidentified: empipostgres.UnidentifiedRepo{Repository: empiRepo},
		Registries:   deps.IdentifierRegistries,
		Numbers:      empipostgres.NewMRNIssuer(repo),
		Tenants:      empipostgres.NewTenantJurisdiction(orgpostgres.TenantRepo{Repository: repo}),
		Events:       platformStore,
		Audits:       store.AuditAppenderFunc(platformStore.AppendAudit),
		IDs:          uuidGenerator{},
		Clock:        systemClock{},
	})

	schedulingRepo := schedulingpostgres.New(txManager)
	schedulingService := schedulingapp.NewService(schedulingapp.Deps{
		UnitOfWork:    txManager,
		Resources:     schedulingpostgres.ResourceRepo{Repository: schedulingRepo},
		Schedules:     schedulingpostgres.ScheduleRepo{Repository: schedulingRepo},
		Slots:         schedulingpostgres.SlotRepo{Repository: schedulingRepo},
		Appointments:  schedulingpostgres.AppointmentRepo{Repository: schedulingRepo},
		Policies:      schedulingpostgres.PolicyRepo{Repository: schedulingRepo},
		Series:        schedulingpostgres.SeriesRepo{Repository: schedulingRepo},
		Waitlist:      schedulingpostgres.WaitlistRepo{Repository: schedulingRepo},
		Queue:         schedulingpostgres.AppointmentRepo{Repository: schedulingRepo},
		Notifications: schedulingpostgres.NotificationRepo{Repository: schedulingRepo},
		Contacts: schedulingpostgres.NewContacts(
			empipostgres.HistoryRepo{Repository: empiRepo}, time.Now),
		Meetings: deps.MeetingProvider,
		Calendar: schedulingpostgres.NewCalendar(repo,
			orgpostgres.FacilityRepo{Repository: repo}),
		Patients: schedulingpostgres.NewPatients(empipostgres.PatientRepo{Repository: empiRepo}),
		Events:   platformStore,
		Audits:   store.AuditAppenderFunc(platformStore.AppendAudit),
		IDs:      uuidGenerator{},
		Clock:    systemClock{},
	})

	encounterRepo := encounterpostgres.New(txManager)
	encounterService := encounterapp.NewService(encounterapp.Deps{
		UnitOfWork: txManager,
		Encounters: encounterpostgres.EncounterRepo{Repository: encounterRepo},
		Episodes:   encounterpostgres.EpisodeRepo{Repository: encounterRepo},
		CareTeams:  encounterpostgres.CareTeamRepo{Repository: encounterRepo},
		Diagnoses:  encounterpostgres.DiagnosisRepo{Repository: encounterRepo},
		Policies:   encounterpostgres.ClosurePolicyRepo{Repository: encounterRepo},
		Summaries:  encounterpostgres.SummaryRepo{Repository: encounterRepo},
		// Clinical is nil until Sprint 4B wires the clinical context. A
		// closure policy that requires a signed note therefore blocks rather
		// than silently passing, which is the right way round: a deployment
		// with no clinical documentation should not be able to satisfy a rule
		// about clinical documentation.
		Patients: encounterpostgres.NewPatients(
			empipostgres.PatientRepo{Repository: empiRepo}),
		Appointments: encounterpostgres.NewAppointments(
			schedulingpostgres.AppointmentRepo{Repository: schedulingRepo}),
		Events: platformStore,
		Audits: store.AuditAppenderFunc(platformStore.AppendAudit),
		IDs:    uuidGenerator{},
		Clock:  systemClock{},
	})

	orgService := orgapp.NewService(orgapp.Deps{
		UnitOfWork: txManager,
		Tenants:    orgpostgres.TenantRepo{Repository: repo},
		Facilities: orgpostgres.FacilityRepo{Repository: repo},
		Numbers:    repo,
		Events:     platformStore,
		Audits:     store.AuditAppenderFunc(platformStore.AppendAudit),
		IDs:        uuidGenerator{},
		Clock:      systemClock{},
	})

	// Order matters.
	//
	// Tracing is outermost so a rejected request still produces a span. The
	// peer rate limit comes before authentication, so an unauthenticated flood
	// is refused without paying for token verification. The error interceptor
	// wraps auth, so an authentication failure is rendered through the same
	// error contract as everything else. The subject rate limit comes after
	// auth, where a caller identity finally exists to key on. The entitlement
	// check is last, because it needs the tenant and active facility that only
	// a verified session carries — and it is an interceptor rather than a
	// handler concern so a disabled module is unreachable by direct call
	// (SRS-PLT-011).
	rateLimiter := platformtransport.NewRateLimiter(deps.RateLimit, nil)

	entitlements := orgapp.EntitlementChecker{
		Entitlements: repo,
		Clock:        systemClock{},
	}

	chain := []connect.Interceptor{
		platformtransport.NewTracingInterceptor(),
		platformtransport.NewErrorInterceptor(),
		// Bounds every request before anything expensive starts, so an
		// abandoned browser request cannot leave a handler holding a
		// transaction (SRS-API-010).
		platformtransport.NewDeadlineInterceptor(deps.ProcedureDeadlines),
		platformtransport.NewPeerRateLimitInterceptor(rateLimiter),
		platformtransport.NewAuthInterceptor(deps.Verifier),
		platformtransport.NewSubjectRateLimitInterceptor(rateLimiter),
	}
	// Revocation runs immediately after authentication, so a disabled user's
	// existing session is refused before any handler sees it (SRS-IAM-006).
	// Optional because it costs a lookup per request, and a deployment with no
	// revocation store configured should fail loudly at wiring rather than
	// silently skip the check — so a nil Revoker means the feature is off by
	// configuration, not by accident.
	if deps.Revoker != nil {
		chain = append(chain, platformtransport.NewRevocationInterceptor(deps.Revoker))
	}
	chain = append(chain, platformtransport.NewEntitlementInterceptor(entitlements, nil))

	interceptors := connect.WithInterceptors(chain...)

	mux := http.NewServeMux()
	mux.Handle(organizationv1connect.NewOrganizationServiceHandler(
		orgtransport.NewHandler(orgService), interceptors))
	mux.Handle(identityaccessv1connect.NewIdentityServiceHandler(
		identitytransport.NewHandler(orgService), interceptors))
	mux.Handle(empiv1connect.NewPatientServiceHandler(
		empitransport.NewHandler(empiService), interceptors))
	mux.Handle(schedulingv1connect.NewAppointmentServiceHandler(
		schedulingtransport.NewHandler(schedulingService), interceptors))
	mux.Handle(encounterv1connect.NewEncounterServiceHandler(
		encountertransport.NewHandler(encounterService), interceptors))
	mux.Handle(platformapiv1connect.NewHealthServiceHandler(
		platformapitransport.NewHandler(deps.Build, map[string]platformapitransport.Pinger{
			"postgres": poolPinger{pool: deps.Pool},
		}), interceptors))

	// Security headers wrap the mux rather than sitting in the interceptor
	// chain, so they reach every response the browser sees — a 404, a
	// malformed request rejected before routing, anything an interceptor never
	// runs for (SRS-WEB-015).
	handler := platformtransport.NewSecurityHeaders(deps.SecurityHeaders, mux)

	return &Server{
		Handler:         handler,
		Organization:    orgService,
		Patients:        empiService,
		Scheduling:      schedulingService,
		Encounters:      encounterService,
		Store:           platformStore,
		RateLimiter:     rateLimiter,
		Publisher:       publisher,
		Events:          events,
		Err:             eventsErr,
		publishInterval: deps.PublishInterval,
	}
}

// RunBackground drives the outbox publisher and the event consumers until the
// context is cancelled.
//
// Separate from serving HTTP on purpose. A process can serve requests without
// consuming (the usual API replica), consume without serving (a worker
// deployment), or do both (a single-binary install) — and the deployment
// decides which, not this package.
//
// Returns the context error on a clean shutdown, so a caller can distinguish
// "we were asked to stop" from "a consumer died".
func (s *Server) RunBackground(ctx context.Context) error {
	if s.Err != nil {
		return s.Err
	}

	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	errs := make(chan error, 2)
	go func() { errs <- s.Publisher.Run(ctx, s.publishInterval) }()
	go func() { errs <- s.Events.Run(ctx) }()

	// The first exit stops the other: a publisher without consumers builds a
	// backlog, and consumers without a publisher have nothing to consume.
	// Running on with half the pipeline is the shape of an outage nobody
	// notices for an hour.
	first := <-errs
	cancel()
	<-errs
	return first
}
