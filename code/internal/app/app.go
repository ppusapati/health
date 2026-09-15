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
	"github.com/ppusapati/health/code/gen/go/healthcare/billing/v1/billingv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/clinical/v1/clinicalv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/empi/v1/empiv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1/encounterv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/identity_access/v1/identityaccessv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/medication/v1/medicationv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/nursing/v1/nursingv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/orders/v1/ordersv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/platform_api/v1/platformapiv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/scheduling/v1/schedulingv1connect"
	billingpostgres "github.com/ppusapati/health/code/internal/billing/adapters/postgres"
	billingapp "github.com/ppusapati/health/code/internal/billing/application"
	billingtransport "github.com/ppusapati/health/code/internal/billing/transport"
	"github.com/ppusapati/health/code/internal/clinical/adapters/attachmentstore"
	clinicalpostgres "github.com/ppusapati/health/code/internal/clinical/adapters/postgres"
	clinicalapp "github.com/ppusapati/health/code/internal/clinical/application"
	clinicaltransport "github.com/ppusapati/health/code/internal/clinical/transport"
	"github.com/ppusapati/health/code/internal/empi/adapters/photostore"
	empipostgres "github.com/ppusapati/health/code/internal/empi/adapters/postgres"
	empiapp "github.com/ppusapati/health/code/internal/empi/application"
	empiports "github.com/ppusapati/health/code/internal/empi/ports"
	empitransport "github.com/ppusapati/health/code/internal/empi/transport"
	encounterpostgres "github.com/ppusapati/health/code/internal/encounter/adapters/postgres"
	encounterapp "github.com/ppusapati/health/code/internal/encounter/application"
	encountertransport "github.com/ppusapati/health/code/internal/encounter/transport"
	identitytransport "github.com/ppusapati/health/code/internal/identity_access/transport"
	medicationorders "github.com/ppusapati/health/code/internal/medication/adapters/orders"
	medicationpostgres "github.com/ppusapati/health/code/internal/medication/adapters/postgres"
	medicationapp "github.com/ppusapati/health/code/internal/medication/application"
	medicationtransport "github.com/ppusapati/health/code/internal/medication/transport"
	"github.com/ppusapati/health/code/internal/nursing/adapters/imagestore"
	nursingmedication "github.com/ppusapati/health/code/internal/nursing/adapters/medication"
	nursingpostgres "github.com/ppusapati/health/code/internal/nursing/adapters/postgres"
	nursingapp "github.com/ppusapati/health/code/internal/nursing/application"
	nursingports "github.com/ppusapati/health/code/internal/nursing/ports"
	nursingtransport "github.com/ppusapati/health/code/internal/nursing/transport"
	orderspostgres "github.com/ppusapati/health/code/internal/orders/adapters/postgres"
	ordersapp "github.com/ppusapati/health/code/internal/orders/application"
	orderstransport "github.com/ppusapati/health/code/internal/orders/transport"
	orgpostgres "github.com/ppusapati/health/code/internal/organization/adapters/postgres"
	orgapp "github.com/ppusapati/health/code/internal/organization/application"
	orgtransport "github.com/ppusapati/health/code/internal/organization/transport"
	"github.com/ppusapati/health/code/internal/platform/blobstore"
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

	// Blobs is the platform blob store: one configured routing table deciding
	// where every class of binary content lives (SRS-DAT-007).
	//
	// Nil is a valid deployment and the default. One that stores no binary
	// content refuses to capture a photograph rather than recording a row that
	// points at nothing, and inventing a scratch directory for it would give it
	// a store that works until the pod restarts.
	Blobs *blobstore.Vault

	// PhotoStore overrides where patient photograph bytes go (SRS-EMPI-010).
	//
	// Left nil it is derived from Blobs, which is what a deployment does. It is
	// here for tests that want to watch or fail the store itself.
	PhotoStore empiports.PhotoStore

	// MeetingProvider mints teleconsult join links (SRS-SCH-015).
	//
	// Nil is a valid deployment and the default: a hospital that runs no video
	// service books teleconsults with no link, and the absence is visible rather
	// than a broken URL.
	MeetingProvider schedulingports.MeetingProvider

	// MedicationOrders overrides the eMAR's seam onto the drug chart
	// (SRS-NUR-007).
	//
	// Nil is the normal deployment: the medication context supplies the
	// adapter, so an eMAR checks pharmacist verification against the real
	// prescription. Set it only to exercise the eMAR against a stand-in — never
	// one that answers "verified", which would be a safety control present in
	// the code and absent in effect.
	MedicationOrders nursingports.MedicationOrders
}

// Server holds the assembled HTTP handler and the services behind it.
type Server struct {
	Handler      http.Handler
	Organization *orgapp.Service
	Patients     *empiapp.Service
	Scheduling   *schedulingapp.Service
	Encounters   *encounterapp.Service
	Clinical     *clinicalapp.Service
	Nursing      *nursingapp.Service
	Orders       *ordersapp.Service
	Medication   *medicationapp.Service
	Billing      *billingapp.Service
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
	// A caller that set only the subject budget would otherwise get a peer
	// budget of zero, which refuses every request. Filled per field rather than
	// wholesale so a partial configuration stays partial.
	if deps.RateLimit.PeerRequestsPerSecond == 0 {
		deps.RateLimit.PeerRequestsPerSecond = platformtransport.DefaultRateLimit().PeerRequestsPerSecond
		deps.RateLimit.PeerBurst = platformtransport.DefaultRateLimit().PeerBurst
	}
	if len(deps.SecurityHeaders.ConnectSources) == 0 {
		deps.SecurityHeaders = platformtransport.DefaultSecurityHeaders()
	}

	txManager := pgtx.NewManager(deps.Pool)

	// Where patient photographs go is the blob store's routing decision, not
	// the patient index's. photostore.New returns a nil interface for a nil
	// vault, so "this deployment stores no binary content" stays a single
	// condition rather than one repeated at every call site.
	photoStore := deps.PhotoStore
	if photoStore == nil {
		photoStore = photostore.New(deps.Blobs)
	}

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
		PhotoStore:   photoStore,
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

	clinicalRepo := clinicalpostgres.New(txManager)
	clinicalDocuments := clinicalpostgres.DocumentRepo{Repository: clinicalRepo}
	clinicalTimeline := clinicalpostgres.TimelineRepo{Repository: clinicalRepo}

	encounterRepo := encounterpostgres.New(txManager)
	encounterService := encounterapp.NewService(encounterapp.Deps{
		UnitOfWork: txManager,
		Encounters: encounterpostgres.EncounterRepo{Repository: encounterRepo},
		Episodes:   encounterpostgres.EpisodeRepo{Repository: encounterRepo},
		CareTeams:  encounterpostgres.CareTeamRepo{Repository: encounterRepo},
		Diagnoses:  encounterpostgres.DiagnosisRepo{Repository: encounterRepo},
		Policies:   encounterpostgres.ClosurePolicyRepo{Repository: encounterRepo},
		Summaries:  encounterpostgres.SummaryRepo{Repository: encounterRepo},
		// The clinical record answers the closure gate's "is there a signed
		// note" and supplies the clinical half of the timeline (SRS-ENC-008,
		// SRS-ENC-011). Narrow by construction: the seam returns booleans and
		// projections, never clinical content.
		Clinical: clinicalpostgres.NewClinicalContent(clinicalDocuments, clinicalTimeline),
		Patients: encounterpostgres.NewPatients(
			empipostgres.PatientRepo{Repository: empiRepo}),
		Appointments: encounterpostgres.NewAppointments(
			schedulingpostgres.AppointmentRepo{Repository: schedulingRepo}),
		Events: platformStore,
		Audits: store.AuditAppenderFunc(platformStore.AppendAudit),
		IDs:    uuidGenerator{},
		Clock:  systemClock{},
	})

	clinicalService := clinicalapp.NewService(clinicalapp.Deps{
		UnitOfWork: txManager,
		Documents:  clinicalDocuments,
		Templates:  clinicalpostgres.TemplateRepo{Repository: clinicalRepo},
		Records:    clinicalpostgres.RecordRepo{Repository: clinicalRepo},
		Governance: clinicalpostgres.GovernanceRepo{Repository: clinicalRepo},
		// Attached files go to the blob store's clinical-attachment class
		// (SRS-CLN-014). Nil vault, nil port: a deployment that stores no
		// binary content refuses to attach a file.
		Attachments: attachmentstore.New(deps.Blobs),
		Decisions:   clinicalpostgres.DecisionRepo{Repository: clinicalRepo},
		Phrases:     clinicalpostgres.SmartPhraseRepo{Repository: clinicalRepo},
		Timeline:    clinicalTimeline,
		Encounters: clinicalpostgres.NewEncounters(
			encounterpostgres.EncounterRepo{Repository: encounterRepo}),
		Patients: clinicalpostgres.NewPatients(
			empipostgres.PatientRepo{Repository: empiRepo},
			empipostgres.IdentifierRepo{Repository: empiRepo}, time.Now),
		Events: platformStore,
		Audits: store.AuditAppenderFunc(platformStore.AppendAudit),
		IDs:    uuidGenerator{},
		Clock:  systemClock{},
	})

	ordersRepo := orderspostgres.New(txManager)
	ordersService := ordersapp.NewService(ordersapp.Deps{
		UnitOfWork: txManager,
		Orders:     orderspostgres.NewOrders(ordersRepo),
		Acks:       orderspostgres.NewAcknowledgements(ordersRepo),
		Catalogue:  orderspostgres.NewCatalogue(ordersRepo),
		// Order numbers come from the platform's sequence (SRS-PLT-014) rather
		// than a counter of this context's own: atomic, collision-free and
		// gapless are exactly what a number a ward reads down a phone needs.
		Numbers: orderspostgres.NewNumbers(repo),
		Encounters: orderspostgres.NewEncounters(
			encounterpostgres.EncounterRepo{Repository: encounterRepo},
			orgpostgres.FacilityRepo{Repository: repo}),
		// SRS-ORD-006: the performing service hears about an order on the bus,
		// never by reading the orders schema — which is what lets the two be
		// released independently.
		Dispatcher: orderspostgres.NewDispatcher(platformStore, uuidGenerator{},
			systemClock{}),
		Events: platformStore,
		Audits: store.AuditAppenderFunc(platformStore.AppendAudit),
		IDs:    uuidGenerator{},
		Clock:  systemClock{},
	})

	medicationRepo := medicationpostgres.New(txManager)
	medicationTerminology := medicationpostgres.NewTerminology(medicationRepo)
	medicationService := medicationapp.NewService(medicationapp.Deps{
		UnitOfWork:      txManager,
		Prescriptions:   medicationRepo,
		Reconciliations: medicationpostgres.NewReconciliations(medicationRepo),
		Substitutions:   medicationpostgres.NewSubstitutions(medicationRepo),
		Catalogue:       medicationpostgres.NewCatalogue(medicationRepo),
		// The tenant's own terminology map (SRS-MED-002). A deployment that
		// licenses a drug database replaces this one adapter and changes
		// nothing else, which is why the screen was written against a port.
		Terminology: medicationTerminology,
		// What a patient is allergic to is the clinical record's fact
		// (SRS-MED-002), and how old they are and what their renal function is
		// are the EMPI's and the laboratory's (SRS-MED-004). Adapters rather
		// than copies: a second answer here would drift from the first.
		Allergies: medicationpostgres.NewAllergies(
			clinicalpostgres.RecordRepo{Repository: clinicalRepo}),
		Patients: medicationpostgres.NewPatientFactors(
			empipostgres.PatientRepo{Repository: empiRepo},
			clinicalpostgres.RecordRepo{Repository: clinicalRepo}),
		Encounters: medicationpostgres.NewEncounters(
			encounterpostgres.EncounterRepo{Repository: encounterRepo},
			orgpostgres.FacilityRepo{Repository: repo}),
		// A prescription is the clinical detail of a medication order, so
		// placing one places an order: the number a ward reads down a phone,
		// the routing to the pharmacy, the duplicate check and the order
		// lifecycle are all the order framework's, and this context asks for
		// them rather than keeping a second copy.
		Orders: medicationorders.New(ordersService),
		Events: platformStore,
		Audits: store.AuditAppenderFunc(platformStore.AppendAudit),
		IDs:    uuidGenerator{},
		Clock:  systemClock{},
	})

	// The eMAR's seam onto the drug chart (SRS-NUR-007), which Sprint 4C left
	// as a port with no adapter. Deps.MedicationOrders overrides it, which is
	// how a test exercises the eMAR without the whole medication stack.
	var medicationOrders nursingports.MedicationOrders = nursingmedication.New(medicationService, systemClock{})
	if deps.MedicationOrders != nil {
		medicationOrders = deps.MedicationOrders
	}

	nursingRepo := nursingpostgres.New(txManager)
	nursingService := nursingapp.NewService(nursingapp.Deps{
		UnitOfWork:  txManager,
		Assessments: nursingpostgres.NewAssessments(nursingRepo),
		// Wound photographs go to the blob store's wound-image class
		// (SRS-NUR-012).
		Images:         imagestore.New(deps.Blobs),
		Risks:          nursingpostgres.NewRisk(nursingRepo),
		Flowsheet:      nursingpostgres.NewFlowsheet(nursingRepo),
		Devices:        nursingpostgres.NewDevices(nursingRepo),
		Administration: nursingpostgres.NewAdministrations(nursingRepo),
		// The drug chart, projected (SRS-NUR-007). A nurse sees what to give,
		// when, and whether a pharmacist has checked it; the indication, the
		// safety findings and the prescriber's reasoning stay in the
		// medication context, which is what keeps a drug round from depending
		// on that context's shape.
		Orders:    medicationOrders,
		Tasks:     nursingpostgres.NewTasks(nursingRepo),
		Plans:     nursingpostgres.NewCarePlans(nursingRepo),
		Handovers: nursingpostgres.NewHandovers(nursingRepo),
		Safety:    nursingpostgres.NewSafety(nursingRepo),
		Ward:      nursingpostgres.NewWard(nursingRepo),
		Downtime:  nursingpostgres.NewDowntime(nursingRepo),
		Encounters: nursingpostgres.NewEncounters(
			encounterpostgres.EncounterRepo{Repository: encounterRepo}),
		// Whether a consent covers clinical photography is the clinical
		// context's question to answer (SRS-NUR-012).
		Consents: nursingpostgres.NewConsents(
			clinicalpostgres.GovernanceRepo{Repository: clinicalRepo}, time.Now),
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
	mux.Handle(clinicalv1connect.NewClinicalServiceHandler(
		clinicaltransport.NewHandler(clinicalService), interceptors))
	mux.Handle(nursingv1connect.NewNursingServiceHandler(
		nursingtransport.NewHandler(nursingService, time.Now), interceptors))
	mux.Handle(ordersv1connect.NewOrderServiceHandler(
		orderstransport.NewHandler(ordersService), interceptors))
	billingRepo := billingpostgres.New(txManager)
	billingService := billingapp.NewService(billingapp.Deps{
		UnitOfWork: txManager,
		Master:     billingpostgres.NewMaster(billingRepo),
		Accounts:   billingpostgres.NewAccounts(billingRepo),
		Charges:    billingpostgres.NewCharges(billingRepo),
		Invoices:   billingpostgres.NewInvoices(billingRepo),
		Ledger:     billingpostgres.NewLedger(billingRepo),
		Shifts:     billingpostgres.NewShifts(billingRepo),
		Policies:   billingpostgres.NewPolicies(billingRepo),
		// Invoice and receipt numbers come from the platform's sequence
		// (SRS-PLT-014) rather than a counter of this context's own: gapless is
		// what a finance department's first question about a numbering scheme
		// asks for, and a gap in an invoice series is a question an auditor
		// asks.
		Numbers: billingpostgres.NewNumbers(repo),
		Encounters: billingpostgres.NewEncounters(
			encounterpostgres.EncounterRepo{Repository: encounterRepo}),
		Events: platformStore,
		Audits: store.AuditAppenderFunc(platformStore.AppendAudit),
		IDs:    uuidGenerator{},
		Clock:  systemClock{},
	})

	mux.Handle(medicationv1connect.NewMedicationServiceHandler(
		medicationtransport.NewHandler(medicationService, medicationTerminology),
		interceptors))
	mux.Handle(billingv1connect.NewBillingServiceHandler(
		billingtransport.NewHandler(billingService), interceptors))
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
		Clinical:        clinicalService,
		Nursing:         nursingService,
		Orders:          ordersService,
		Medication:      medicationService,
		Billing:         billingService,
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
