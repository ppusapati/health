// Package app is the composition root.
//
// Every concrete dependency is chosen here and nowhere else, which is what lets
// the integration tests assemble the identical stack against a real database
// while main.go stays a thin entry point.
package app

import (
	"context"
	"errors"
	escalate "github.com/ppusapati/health/code/internal/clinical/adapters/escalate"
	"github.com/ppusapati/health/code/internal/platform/escalation"
	"net/http"
	"time"

	"connectrpc.com/connect"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/ppusapati/health/code/gen/go/healthcare/anaesthesia/v1/anaesthesiav1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/billing/v1/billingv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/biomedical/v1/biomedicalv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/bloodbank/v1/bloodbankv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/clinical/v1/clinicalv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/emergency/v1/emergencyv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/empi/v1/empiv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1/encounterv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/hospital_ops_diet/v1/hospitalopsdietv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/housekeeping/v1/housekeepingv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/icu/v1/icuv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/identity_access/v1/identityaccessv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/infection/v1/infectionv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/materials/v1/materialsv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/medication/v1/medicationv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/nursing/v1/nursingv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/orders/v1/ordersv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/platform_api/v1/platformapiv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/quality/v1/qualityv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/records/v1/recordsv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/scheduling/v1/schedulingv1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/sterile/v1/sterilev1connect"
	"github.com/ppusapati/health/code/gen/go/healthcare/theatre/v1/theatrev1connect"
	anaesthesiapostgres "github.com/ppusapati/health/code/internal/anaesthesia/adapters/postgres"
	anaesthesiaapp "github.com/ppusapati/health/code/internal/anaesthesia/application"
	anaesthesiatransport "github.com/ppusapati/health/code/internal/anaesthesia/transport"
	billingpostgres "github.com/ppusapati/health/code/internal/billing/adapters/postgres"
	billingapp "github.com/ppusapati/health/code/internal/billing/application"
	billingtransport "github.com/ppusapati/health/code/internal/billing/transport"
	biomedicalescalate "github.com/ppusapati/health/code/internal/biomedical/adapters/escalate"
	biomedicalpostgres "github.com/ppusapati/health/code/internal/biomedical/adapters/postgres"
	biomedicalapp "github.com/ppusapati/health/code/internal/biomedical/application"
	biomedicaltransport "github.com/ppusapati/health/code/internal/biomedical/transport"
	bloodbankescalate "github.com/ppusapati/health/code/internal/bloodbank/adapters/escalate"
	bloodbankpostgres "github.com/ppusapati/health/code/internal/bloodbank/adapters/postgres"
	bloodbankapp "github.com/ppusapati/health/code/internal/bloodbank/application"
	bloodbanktransport "github.com/ppusapati/health/code/internal/bloodbank/transport"
	"github.com/ppusapati/health/code/internal/clinical/adapters/attachmentstore"
	clinicalpostgres "github.com/ppusapati/health/code/internal/clinical/adapters/postgres"
	clinicalapp "github.com/ppusapati/health/code/internal/clinical/application"
	clinicaltransport "github.com/ppusapati/health/code/internal/clinical/transport"
	dietcrosscontext "github.com/ppusapati/health/code/internal/dietetics/adapters/crosscontext"
	dietescalate "github.com/ppusapati/health/code/internal/dietetics/adapters/escalate"
	dietpostgres "github.com/ppusapati/health/code/internal/dietetics/adapters/postgres"
	dietapp "github.com/ppusapati/health/code/internal/dietetics/application"
	diettransport "github.com/ppusapati/health/code/internal/dietetics/transport"
	emergencyescalate "github.com/ppusapati/health/code/internal/emergency/adapters/escalate"
	emergencypostgres "github.com/ppusapati/health/code/internal/emergency/adapters/postgres"
	emergencyapp "github.com/ppusapati/health/code/internal/emergency/application"
	emergencytransport "github.com/ppusapati/health/code/internal/emergency/transport"
	"github.com/ppusapati/health/code/internal/empi/adapters/photostore"
	empipostgres "github.com/ppusapati/health/code/internal/empi/adapters/postgres"
	empiapp "github.com/ppusapati/health/code/internal/empi/application"
	empiports "github.com/ppusapati/health/code/internal/empi/ports"
	empitransport "github.com/ppusapati/health/code/internal/empi/transport"
	encounterpostgres "github.com/ppusapati/health/code/internal/encounter/adapters/postgres"
	encounterapp "github.com/ppusapati/health/code/internal/encounter/application"
	encounterdomain "github.com/ppusapati/health/code/internal/encounter/domain"
	encountertransport "github.com/ppusapati/health/code/internal/encounter/transport"
	hkpcrosscontext "github.com/ppusapati/health/code/internal/housekeeping/adapters/crosscontext"
	hkpescalate "github.com/ppusapati/health/code/internal/housekeeping/adapters/escalate"
	hkppostgres "github.com/ppusapati/health/code/internal/housekeeping/adapters/postgres"
	hkpapp "github.com/ppusapati/health/code/internal/housekeeping/application"
	hkptransport "github.com/ppusapati/health/code/internal/housekeeping/transport"
	icuescalate "github.com/ppusapati/health/code/internal/icu/adapters/escalate"
	icupostgres "github.com/ppusapati/health/code/internal/icu/adapters/postgres"
	icuapp "github.com/ppusapati/health/code/internal/icu/application"
	icutransport "github.com/ppusapati/health/code/internal/icu/transport"
	identitypostgres "github.com/ppusapati/health/code/internal/identity_access/adapters/postgres"
	identitytransport "github.com/ppusapati/health/code/internal/identity_access/transport"
	infectionescalate "github.com/ppusapati/health/code/internal/infection/adapters/escalate"
	infectionindicators "github.com/ppusapati/health/code/internal/infection/adapters/indicators"
	infectionpostgres "github.com/ppusapati/health/code/internal/infection/adapters/postgres"
	infectiontherapy "github.com/ppusapati/health/code/internal/infection/adapters/therapy"
	infectionapp "github.com/ppusapati/health/code/internal/infection/application"
	infectiontransport "github.com/ppusapati/health/code/internal/infection/transport"
	materialsescalate "github.com/ppusapati/health/code/internal/materials/adapters/escalate"
	materialspostgres "github.com/ppusapati/health/code/internal/materials/adapters/postgres"
	materialsapp "github.com/ppusapati/health/code/internal/materials/application"
	materialstransport "github.com/ppusapati/health/code/internal/materials/transport"
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
	qualityescalate "github.com/ppusapati/health/code/internal/quality/adapters/escalate"
	qualitypostgres "github.com/ppusapati/health/code/internal/quality/adapters/postgres"
	qualityapp "github.com/ppusapati/health/code/internal/quality/application"
	qualitytransport "github.com/ppusapati/health/code/internal/quality/transport"
	recordscrosscontext "github.com/ppusapati/health/code/internal/records/adapters/crosscontext"
	recordsescalate "github.com/ppusapati/health/code/internal/records/adapters/escalate"
	recordspostgres "github.com/ppusapati/health/code/internal/records/adapters/postgres"
	recordsapp "github.com/ppusapati/health/code/internal/records/application"
	recordstransport "github.com/ppusapati/health/code/internal/records/transport"
	schedulingpostgres "github.com/ppusapati/health/code/internal/scheduling/adapters/postgres"
	schedulingapp "github.com/ppusapati/health/code/internal/scheduling/application"
	schedulingports "github.com/ppusapati/health/code/internal/scheduling/ports"
	schedulingtransport "github.com/ppusapati/health/code/internal/scheduling/transport"
	securitypostgres "github.com/ppusapati/health/code/internal/security/adapters/postgres"
	sterileescalate "github.com/ppusapati/health/code/internal/sterile/adapters/escalate"
	sterilepostgres "github.com/ppusapati/health/code/internal/sterile/adapters/postgres"
	sterileapp "github.com/ppusapati/health/code/internal/sterile/application"
	steriletransport "github.com/ppusapati/health/code/internal/sterile/transport"
	theatrepostgres "github.com/ppusapati/health/code/internal/theatre/adapters/postgres"
	theatreapp "github.com/ppusapati/health/code/internal/theatre/application"
	theatretransport "github.com/ppusapati/health/code/internal/theatre/transport"
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

	// Draining makes readiness answer false from the moment shutdown begins,
	// while the process is still serving. Nil means the process never reports
	// itself draining, which is right for a test and wrong for a Pod — see the
	// interface's own comment for the race it exists to close.
	Draining platformapitransport.Draining

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

	// Icu is what a deployment has decided about its critical-care units:
	// which severity scores it calculates, which care bundles it runs, what
	// the dashboard summarises, and how long a device feed may be silent
	// before it is marked stale (SRS-ICU-009, SRS-ICU-010, SRS-ICU-012).
	//
	// The zero value calculates no score and runs no bundle, which is a
	// configuration rather than a defect: a score nobody has agreed the
	// definition of is one nobody should be acting on the result of.
	Icu icuapp.Config

	// Theatre is what a deployment has decided about its operating theatres:
	// the pre-operative checklist, the surgical safety checklist, and how late
	// a case may start and still count as on time (SRS-OT-006, SRS-OT-007,
	// SRS-OT-015).
	//
	// The zero value takes the WHO safety checklist and a pre-operative list
	// whose consent and site-marking items cannot be waived by anybody. That
	// is a default rather than an empty one on purpose: a readiness gate
	// defaulting to nothing would pass every case.
	Theatre theatreapp.Config

	// LateralProcedures are the procedure codes that have sides
	// (SRS-OT-002). A code on this list cannot be scheduled without a
	// laterality, which is the first of the controls against wrong-site
	// surgery.
	//
	// Configured rather than looked up, because whether a procedure has sides
	// is a fact about the code system and this deployment has no terminology
	// service. Empty makes laterality optional everywhere, and the
	// unwaivable site-marking gate on the checklist still stands.
	LateralProcedures []string

	// Anaesthesia is what a deployment has decided about its anaesthetic
	// service: the score it discharges from recovery on, and which drugs a
	// summary calls out (SRS-ANE-008, SRS-ANE-010).
	//
	// The zero value takes the modified Aldrete score, which most units use,
	// and carries every drug into the summary. Both are defaults rather than
	// refusals: a unit that has agreed a different scale configures it, and a
	// verbose summary is better than one that quietly dropped the drugs.
	Anaesthesia anaesthesiaapp.Config

	// BloodBank is what a deployment has decided about its blood bank: the
	// mandatory test panel, how long a grouping sample and a reservation
	// last, and how far ahead an expiry alert looks (SRS-BLD-004,
	// SRS-BLD-007, SRS-BLD-008, SRS-BLD-017).
	//
	// The zero value releases nothing, because MandatoryTests is empty and an
	// unconfigured panel is a deployment that has not decided what it tests
	// for. That is the one default here that refuses rather than guesses: a
	// blood bank that released every unit because nobody configured it is the
	// outcome SRS-BLD-004 exists to prevent.
	BloodBank bloodbankapp.Config

	// Sterile is what a deployment has decided about its sterile services:
	// the shelf life a set with no policy of its own takes, and whether every
	// load waits for its biological indicator (SRS-CSSD-007, SRS-CSSD-008).
	//
	// The zero value refuses rather than guesses: DefaultShelfLife is zero, so
	// a set with no expiry policy is refused at sterilisation instead of
	// producing a pack that never goes out of date. That is the one direction
	// SRS-CSSD-008 exists to close.
	Sterile sterileapp.Config

	// Materials is what a deployment has decided about its stores: how far
	// ahead an expiry alert looks, what a delivery may differ from its order
	// by, and whether consignment stock must name the patient it went into
	// (SRS-MAT-005, SRS-MAT-012, SRS-MAT-016).
	//
	// The zero value takes exact deliveries and raises no expiry alerts. The
	// first is the safe direction — it keeps unordered stock off the ledger —
	// and the second is a deployment that has not decided, which the status
	// document names rather than this code guessing at.
	Materials materialsapp.Config

	// Biomedical is what a deployment has decided about its equipment:
	// whether a lapsed calibration stops a machine being used, how far ahead
	// the maintenance and renewal lists look, what a ticket promises on an
	// asset with no contract, and which criticality escalates when it goes
	// down (SRS-BIO-002 … 005, SRS-BIO-009).
	//
	// The zero value reports and does not enforce: a lapsed calibration is
	// named rather than blocking, the lists report only what has already
	// lapsed, and nothing escalates. Each of those is a deployment that has
	// not decided, which the status document names rather than this code
	// guessing at — the stricter reading of SRS-BIO-004 is a hospital's call,
	// not a default.
	Biomedical biomedicalapp.Config

	// Quality is what a deployment has decided about its quality system: which
	// analysis methods it has approved, which incident categories are sentinel
	// events, the risk band that escalates and the one that calls for an
	// analysis, how long an accreditation judgement stays current, the
	// complaint SLAs, and which roles the acknowledgement and competency gap
	// reports cover (SRS-QMS-002 … 014).
	//
	// The zero value escalates nothing, accepts any named analysis method,
	// marks no accreditation review stale, and reports no acknowledgement or
	// competency gaps. Each is a deployment that has not decided, and the last
	// two are the ones to watch: a clean gap report that means nothing reads
	// exactly like a compliant hospital. The status document names them rather
	// than this code guessing.
	Quality qualityapp.Config

	// Infection is what a deployment has decided about its infection control:
	// the surveillance window that decides every onset classification, the
	// multidrug-resistant organism list, how long precautions run before
	// review, the hand hygiene suppression threshold, how long a stewardship
	// review stays useful, which locations escalate a failed environmental
	// result, and which quality indicators the computed rates are filed
	// against (SRS-IPC-001 … 010).
	//
	// The zero value classifies every case as indeterminate, flags no
	// organism as resistant, leaves precautions with no review date,
	// publishes every hand hygiene group however small, gives reviews no
	// clock and files nothing against the indicator dictionary. Every one of
	// those is a deployment that has not decided, and the first is the one to
	// watch: a hospital whose cases are all indeterminate has no
	// healthcare-associated infection rate at all. The status document names
	// them rather than this code guessing a surveillance definition.
	Infection infectionapp.Config

	// InfectionTherapy is which ingredient codes the hospital treats as
	// antimicrobials and which of those are reserved (SRS-IPC-008). Empty
	// classifies nothing, so the stewardship worklist stays empty: a
	// programme that matched on a drug's display name would miss half the
	// formulary and invent the other half.
	InfectionTherapy infectiontherapy.Config

	// Records is what a deployment has decided about its records office: how
	// long a deficiency runs past its date before it escalates, the bands an
	// aging report is cut into, whose retention law applies when a facility
	// does not say, which document kinds are held back from a release unless
	// it asked for them, and which terminologies and editions the hospital
	// codes in (SRS-MRD-001 … 010).
	//
	// The zero value escalates a deficiency the moment it is overdue, reports
	// no aging bands, finds no retention rule and so sweeps nothing, holds
	// nothing back from a release, and accepts a code in any system. The
	// third and the fourth are the ones to watch: a disposition sweep that
	// finds nothing looks exactly like a hospital with nothing to destroy,
	// and a release that holds nothing back sends the psychiatric notes with
	// the discharge summary. The status document names them rather than this
	// code inventing a jurisdiction.
	Records recordsapp.Config

	// RecordsJurisdictions maps a facility to whose retention law its records
	// follow (SRS-MRD-009). Configuration rather than a fact the encounter
	// context holds: "which country is this hospital in" is not something a
	// clinical record answers.
	RecordsJurisdictions map[string]string

	// RecordsHeldClasses are the resource types a disposition sweep asks the
	// platform's hold store about (SRS-MRD-005). The store indexes holds by
	// resource type, so a batch read has to name them; a class added to the
	// inventory and not added here would be swept with its holds invisible.
	RecordsHeldClasses []string

	// RecordsConditions derives the encounter facts a conditional checklist
	// item turns on — whether there was an operation, whether the patient
	// died (SRS-MRD-001). Nil answers no condition, so conditional items
	// never apply: the safe direction is to ask for fewer documents than to
	// raise a deficiency against every chart for an operation note nobody
	// owed.
	RecordsConditions func(encounterdomain.Encounter) map[string]bool

	// Dietetics is what a deployment has decided about its kitchen: how long
	// after dispatch a meal stops being this meal, how many consecutive
	// missed meals reach somebody, and which contexts a nutrition support
	// plan may name as owning its order (SRS-DIET-006 … 008).
	//
	// The zero value leaves trays with no due time so nothing is reported
	// late, escalates no run of missed meals, and accepts any order context.
	// The second is the one to watch: a patient who has not eaten for a day
	// then appears in no worklist at all. The status document names these
	// rather than this code inventing a hospital's meal times.
	Dietetics dietapp.Config

	// Housekeeping is what a deployment has decided about its cleaning:
	// whether a bed waits for a supervisor's verification before it comes
	// back, whether a spill clean must name a resolvable incident, and
	// whether a terminal clean must name an encounter that has actually
	// ended (SRS-HKP-003, SRS-HKP-004, SRS-HKP-006).
	//
	// The zero value releases a bed on the cleaner's word, accepts a spill
	// task with an unresolved incident reference, and raises a terminal clean
	// on the ward's word alone. Each is a real hospital somewhere; the
	// status document names them rather than this code deciding for one.
	Housekeeping hkpapp.Config

	// Emergency is what a deployment has decided about its emergency
	// department: which triage scale it has approved, what must be measured at
	// triage, and what each disposition requires (SRS-ER-002, SRS-ER-013).
	//
	// The zero value takes ESI and the default disposition gates, which is a
	// default rather than a refusal: patients arrive whether or not anybody has
	// configured the department.
	Emergency emergencyapp.Config
}

// Server holds the assembled HTTP handler and the services behind it.
type Server struct {
	Handler      http.Handler
	Organization *orgapp.Service
	Patients     *empiapp.Service
	Scheduling   *schedulingapp.Service
	Encounters   *encounterapp.Service
	Clinical     *clinicalapp.Service
	Emergency    *emergencyapp.Service
	Icu          *icuapp.Service
	Theatre      *theatreapp.Service
	Anaesthesia  *anaesthesiaapp.Service
	BloodBank    *bloodbankapp.Service
	Sterile      *sterileapp.Service
	Materials    *materialsapp.Service
	Biomedical   *biomedicalapp.Service
	Quality      *qualityapp.Service
	Infection    *infectionapp.Service
	Records      *recordsapp.Service
	Dietetics    *dietapp.Service
	Housekeeping *hkpapp.Service
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

	// Escalations advances clinical notices nobody has acknowledged
	// (SRS-OPSNFR-003). Nil where no channel is configured, which is a
	// deployment that records escalations and tells nobody — visible in the
	// log at startup rather than silent.
	Escalations *escalation.Driver
	// EscalationStore is the very store the clinical service writes through,
	// exposed for the same reason the blob vault is: a test that built a
	// lookalike would be proving the lookalike.
	EscalationStore *escalation.Store

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

	// The escalation mechanism, and clinical's way into it. Built before the
	// clinical service because that service takes the port.
	escalationStore := escalation.NewStore(txManager, uuidGenerator{})
	escalationDriver, escalationErr := escalation.NewDriver(escalation.DriverOptions{
		Transactions: txManager,
		Store:        escalationStore,
		// The in-platform task inbox is the only channel this build has.
		// Outbound channels arrive with SRS-PAT-ENG in Wave 5, and a
		// deployment that configures one before then gets a refusal by name
		// rather than silence.
		Channels: []escalation.Channel{escalation.TaskInbox{}},
		// slog.Default(), like the publisher: this package takes no logger, and
		// the process configures the default handler at startup.
		Logger: nil,
	})

	clinicalService := clinicalapp.NewService(clinicalapp.Deps{
		UnitOfWork: txManager,
		// SRS-CLN-012 escalates through the platform mechanism rather than by
		// calculation. The policy field below still decides the worklist's
		// "overdue" column; this decides who gets told.
		Escalations: escalate.New(escalationStore),
		Documents:   clinicalDocuments,
		Templates:   clinicalpostgres.TemplateRepo{Repository: clinicalRepo},
		Records:     clinicalpostgres.RecordRepo{Repository: clinicalRepo},
		Governance:  clinicalpostgres.GovernanceRepo{Repository: clinicalRepo},
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

	emergencyRepo := emergencypostgres.New(txManager)
	emergencyService := emergencyapp.NewService(emergencyapp.Deps{
		UnitOfWork: txManager,
		Visits:     emergencypostgres.VisitRepo{Repository: emergencyRepo},
		// Whether the Wave-1 encounter still accepts content is the encounter
		// context's fact (SRS-ENC-005), reached through a port. A department
		// keeping its own copy is one that charts a dressing change into a
		// discharged episode.
		Encounters: emergencypostgres.NewEncounters(
			encounterpostgres.EncounterRepo{Repository: encounterRepo}),
		// SRS-ER-005 activates the team through the platform escalation
		// mechanism rather than by shouting into a log: a trauma call that
		// nobody acknowledged has to be visible as such.
		Escalations: emergencyescalate.New(escalationStore),
		Events:      platformStore,
		Audits:      store.AuditAppenderFunc(platformStore.AppendAudit),
		IDs:         uuidGenerator{},
		Clock:       systemClock{},
		Config:      deps.Emergency,
	})

	icuRepo := icupostgres.New(txManager)
	icuService := icuapp.NewService(icuapp.Deps{
		UnitOfWork: txManager,
		Episodes:   icupostgres.EpisodeRepo{Repository: icuRepo},
		Flowsheet:  icupostgres.FlowsheetRepo{Repository: icuRepo},
		Support:    icupostgres.SupportRepo{Repository: icuRepo},
		Care:       icupostgres.CareRepo{Repository: icuRepo},
		// Whether the Wave-1 encounter still accepts content is the encounter
		// context's fact (SRS-ENC-005), reached through a port. A unit keeping
		// its own copy is one that charts an infusion into a discharged
		// episode.
		Encounters: icupostgres.NewEncounters(
			encounterpostgres.EncounterRepo{Repository: encounterRepo}),
		// SRS-ICU-013's advisories escalate through the platform mechanism.
		// Operational conditions only: a bedside alarm is a safety function of
		// a regulated device and is not reachable from here.
		Escalations: icuescalate.New(escalationStore),
		Events:      platformStore,
		Audits:      store.AuditAppenderFunc(platformStore.AppendAudit),
		IDs:         uuidGenerator{},
		Clock:       systemClock{},
		Config:      deps.Icu,
	})

	theatreRepo := theatrepostgres.New(txManager)
	// Built before the theatre because the theatre reads it: what a room can
	// be scheduled for depends on which of its machines are working
	// (SRS-BIO-009).
	biomedicalRepo := biomedicalpostgres.New(txManager)

	theatreService := theatreapp.NewService(theatreapp.Deps{
		UnitOfWork: txManager,
		Schedule:   theatrepostgres.ScheduleRepo{Repository: theatreRepo},
		Cases:      theatrepostgres.CaseRepo{Repository: theatreRepo},
		// Whether the Wave-1 encounter still accepts content is the encounter
		// context's fact (SRS-ENC-005), reached through a port.
		Encounters: theatrepostgres.NewEncounters(
			encounterpostgres.EncounterRepo{Repository: encounterRepo}),
		// Whether a procedure has sides belongs to the code system
		// (SRS-OT-002), not to the theatre.
		Procedures: theatrepostgres.NewLateralProcedures(deps.LateralProcedures),
		// What the room's machines can actually do right now (SRS-BIO-009).
		// An adapter over the equipment register rather than a second copy
		// here: "is the intensifier working" has to have one answer, and it
		// belongs to the people who maintain it.
		//
		// The calibration setting is passed from the biomedical config rather
		// than read again, so a hospital that treats a certificate as a
		// condition of use has its theatre list agree with its equipment
		// screen.
		Equipment: theatrepostgres.NewEquipment(
			biomedicalpostgres.AssetRepo{Repository: biomedicalRepo},
			deps.Biomedical.BlockOnCalibration, time.Now),
		Events: platformStore,
		Audits: store.AuditAppenderFunc(platformStore.AppendAudit),
		IDs:    uuidGenerator{},
		Clock:  systemClock{},
		Config: deps.Theatre,
	})

	anaesthesiaRepo := anaesthesiapostgres.New(txManager)
	anaesthesiaService := anaesthesiaapp.NewService(anaesthesiaapp.Deps{
		UnitOfWork:  txManager,
		Assessments: anaesthesiapostgres.AssessmentRepo{Repository: anaesthesiaRepo},
		Records:     anaesthesiapostgres.RecordRepo{Repository: anaesthesiaRepo},
		Recovery:    anaesthesiapostgres.RecoveryRepo{Repository: anaesthesiaRepo},
		// Which patient is on the table is the theatre's fact (SRS-OT-002),
		// reached through a port. An anaesthesia context holding its own copy
		// is one that charts a drug against the wrong person.
		Cases:  anaesthesiapostgres.NewCases(theatrepostgres.ScheduleRepo{Repository: theatreRepo}),
		Events: platformStore,
		Audits: store.AuditAppenderFunc(platformStore.AppendAudit),
		IDs:    uuidGenerator{},
		Clock:  systemClock{},
		Config: deps.Anaesthesia,
	})

	bloodbankRepo := bloodbankpostgres.New(txManager)
	bloodbankService := bloodbankapp.NewService(bloodbankapp.Deps{
		UnitOfWork:  txManager,
		Donors:      bloodbankpostgres.DonorRepo{Repository: bloodbankRepo},
		Inventory:   bloodbankpostgres.InventoryRepo{Repository: bloodbankRepo},
		Crossmatch:  bloodbankpostgres.CrossmatchRepo{Repository: bloodbankRepo},
		Transfusion: bloodbankpostgres.TransfusionRepo{Repository: bloodbankRepo},
		// Who a patient is belongs to SRS-EMPI, reached through a port. A
		// blood bank with its own copy crossmatches against the wrong person.
		Patients: bloodbankpostgres.NewPatients(
			empipostgres.PatientRepo{Repository: empiRepo}),
		Events: platformStore,
		Audits: store.AuditAppenderFunc(platformStore.AppendAudit),
		// SRS-BLD-010's critical exception. Durable and acknowledged, because
		// a bedside mismatch has to reach the blood bank before the next unit
		// goes out.
		Escalations: bloodbankescalate.New(escalationStore),
		IDs:         uuidGenerator{},
		Clock:       systemClock{},
		Config:      deps.BloodBank,
	})

	sterileRepo := sterilepostgres.New(txManager)
	sterileService := sterileapp.NewService(sterileapp.Deps{
		UnitOfWork:   txManager,
		Master:       sterilepostgres.MasterRepo{Repository: sterileRepo},
		Cycles:       sterilepostgres.CycleRepo{Repository: sterileRepo},
		Runs:         sterilepostgres.RunRepo{Repository: sterileRepo},
		Distribution: sterilepostgres.DistributionRepo{Repository: sterileRepo},
		// Whether an operation is real belongs to SRS-OT, reached through a
		// port. A case trace built on an identifier nobody can resolve is a
		// trace that reaches no patient.
		Cases:  sterilepostgres.NewCases(theatrepostgres.ScheduleRepo{Repository: theatreRepo}),
		Events: platformStore,
		Audits: store.AuditAppenderFunc(platformStore.AppendAudit),
		// SRS-CSSD-011's recall tasks. Durable and acknowledged, because a
		// recall has to reach the wards holding the packs rather than a screen
		// nobody opened.
		Escalations: sterileescalate.New(escalationStore),
		IDs:         uuidGenerator{},
		Clock:       systemClock{},
		Config:      deps.Sterile,
	})

	materialsRepo := materialspostgres.New(txManager)
	materialsService := materialsapp.NewService(materialsapp.Deps{
		UnitOfWork:  txManager,
		Master:      materialspostgres.MasterRepo{Repository: materialsRepo},
		Ledger:      materialspostgres.LedgerRepo{Repository: materialsRepo},
		Procurement: materialspostgres.ProcurementRepo{Repository: materialsRepo},
		Control:     materialspostgres.ControlRepo{Repository: materialsRepo},
		// Who a patient is belongs to SRS-EMPI, reached through a port. A
		// store with its own copy would charge the wrong person.
		Patients: materialspostgres.NewPatients(
			empipostgres.PatientRepo{Repository: empiRepo}),
		// Charges is deliberately nil: what a patient is charged belongs to
		// SRS-BIL, and wiring materials into it is a cross-context change to a
		// Wave-1 contract rather than something to half-do here. The seam
		// exists and is named in the status document.
		Events: platformStore,
		Audits: store.AuditAppenderFunc(platformStore.AppendAudit),
		// SRS-MAT-013's recall. Durable and acknowledged, because the wards
		// holding the stock have to be told rather than left to open a screen.
		Escalations: materialsescalate.New(escalationStore),
		IDs:         uuidGenerator{},
		Clock:       systemClock{},
		Config:      deps.Materials,
	})

	biomedicalService := biomedicalapp.NewService(biomedicalapp.Deps{
		UnitOfWork: txManager,
		Assets:     biomedicalpostgres.AssetRepo{Repository: biomedicalRepo},
		Contracts:  biomedicalpostgres.ContractRepo{Repository: biomedicalRepo},
		Plans:      biomedicalpostgres.PlanRepo{Repository: biomedicalRepo},
		Tickets:    biomedicalpostgres.TicketRepo{Repository: biomedicalRepo},
		Notices:    biomedicalpostgres.NoticeRepo{Repository: biomedicalRepo},
		Telemetry:  biomedicalpostgres.TelemetryRepo{Repository: biomedicalRepo},
		Disposals:  biomedicalpostgres.DisposalRepo{Repository: biomedicalRepo},
		Events:     platformStore,
		Audits:     store.AuditAppenderFunc(platformStore.AppendAudit),
		// SRS-BIO-008's recall and a critical machine going down. Durable and
		// acknowledged, because both have to reach the ward rather than a
		// screen nobody opened.
		Escalations: biomedicalescalate.New(escalationStore),
		IDs:         uuidGenerator{},
		Clock:       systemClock{},
		Config:      deps.Biomedical,
	})

	// The platform's legal-hold store and the staff directory, both owned by
	// other contexts and reached through adapters. Quality places holds on its
	// own records and asks who holds which role; it owns neither answer.
	securityRepo := securitypostgres.New(txManager)
	identityRepo := identitypostgres.New(txManager)

	qualityRepo := qualitypostgres.New(txManager)
	qualityService := qualityapp.NewService(qualityapp.Deps{
		UnitOfWork:     txManager,
		Incidents:      qualitypostgres.IncidentRepo{Repository: qualityRepo},
		Investigations: qualitypostgres.InvestigationRepo{Repository: qualityRepo},
		Actions:        qualitypostgres.ActionRepo{Repository: qualityRepo},
		Documents:      qualitypostgres.DocumentRepo{Repository: qualityRepo},
		Competencies:   qualitypostgres.CompetencyRepo{Repository: qualityRepo},
		Audits:         qualitypostgres.AuditRepo{Repository: qualityRepo},
		Committees:     qualitypostgres.CommitteeRepo{Repository: qualityRepo},
		Accreditation:  qualitypostgres.AccreditationRepo{Repository: qualityRepo},
		Indicators:     qualitypostgres.IndicatorRepo{Repository: qualityRepo},
		Complaints:     qualitypostgres.ComplaintRepo{Repository: qualityRepo},
		PeerReviews:    qualitypostgres.PeerReviewRepo{Repository: qualityRepo},
		// SRS-QMS-015's retention. The platform's own hold mechanism rather
		// than a second one: a hold placed in one place and a purge that reads
		// another is a hold that does nothing.
		Holds: qualitypostgres.NewHolds(securityRepo, uuidGenerator{}),
		// Who works here belongs to identity and access (SRS-QMS-006,
		// SRS-QMS-013). A second copy would drift the first time somebody
		// changed job, and the gap report would be counting people who left.
		Staff:      qualitypostgres.NewStaffDirectory(identityRepo),
		Events:     platformStore,
		AuditTrail: store.AuditAppenderFunc(platformStore.AppendAudit),
		// A sentinel event, a high-risk incident, an overdue corrective action
		// and a breached complaint clock. Durable and acknowledged, because
		// all four have to reach somebody rather than a screen nobody opened.
		Escalations: qualityescalate.New(escalationStore),
		IDs:         uuidGenerator{},
		Clock:       systemClock{},
		Config:      deps.Quality,
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

	// Infection control (SRS-IPC). Wired after medication because the
	// stewardship triggers read what a patient is actually on, through an
	// adapter that holds a prescription reader and nothing that writes: the
	// requirement's "without autonomous medication change" is a property of
	// this wiring as much as of the code behind it.
	infectionRepo := infectionpostgres.New(txManager)
	infectionService := infectionapp.NewService(infectionapp.Deps{
		UnitOfWork:  txManager,
		Cases:       infectionRepo,
		DeviceDays:  infectionRepo,
		Isolations:  infectionRepo,
		Alerts:      infectionRepo,
		Outbreaks:   infectionRepo,
		Hygiene:     infectionRepo,
		Exposures:   infectionRepo,
		Stewardship: infectionRepo,
		Environment: infectionRepo,
		Therapy: infectiontherapy.New(medicationRepo, infectionRepo,
			systemClock{}, deps.InfectionTherapy),
		// The computed rates are filed against the quality context's
		// versioned indicator dictionary (SRS-IPC-010, SRS-QMS-010) rather
		// than a second one here. Two dictionaries would disagree the first
		// time somebody changed a definition.
		Indicators: infectionindicators.New(
			qualitypostgres.IndicatorRepo{Repository: qualityRepo},
			uuidGenerator{}),
		Events:     platformStore,
		AuditTrail: store.AuditAppenderFunc(platformStore.AppendAudit),
		// A declared outbreak, an occupational exposure step past its window
		// and a failed environmental result in augmented care. All three have
		// to reach somebody rather than a screen nobody opened.
		Escalations: infectionescalate.New(escalationStore),
		IDs:         uuidGenerator{},
		Clock:       systemClock{},
		Config:      deps.Infection,
	})

	// Dietetics and kitchen operations (SRS-DIET). Wired after the clinical,
	// orders and medication contexts because everything safety-critical here
	// reads one of them: the allergy list a diet order is checked against,
	// and the order a nutrition support plan names. Both are read through
	// ports that cannot write, so SRS-DIET-007's "without replacing
	// medication/order controls" is a property of this wiring as much as of
	// the code behind it.
	dietRepo := dietpostgres.New(txManager)
	dietService := dietapp.NewService(dietapp.Deps{
		UnitOfWork:  txManager,
		Assessments: dietRepo,
		Orders:      dietRepo,
		Plans:       dietRepo,
		Censuses:    dietRepo,
		Trays:       dietRepo,
		Support:     dietRepo,
		Menu:        dietRepo,
		// What the patient reacts to belongs to the clinical record. A copy
		// here would go stale on the one correction that matters most.
		Allergies: dietcrosscontext.NewAllergies(
			clinicalpostgres.RecordRepo{Repository: clinicalRepo}),
		// And the order a support plan names is resolved where it was
		// placed. Without this, "a plan cannot go active without an order"
		// is defeated by typing anything into the field.
		OrderBook: dietcrosscontext.NewOrderDirectory(
			orderspostgres.NewOrders(ordersRepo), medicationRepo),
		Events:     platformStore,
		AuditTrail: store.AuditAppenderFunc(platformStore.AppendAudit),
		// A tray held back because the patient is nil by mouth, and a run of
		// missed meals. Both have to reach somebody rather than a screen
		// nobody opened.
		Escalations: dietescalate.New(escalationStore),
		IDs:         uuidGenerator{},
		Clock:       systemClock{},
		Config:      deps.Dietetics,
	})

	// Housekeeping and environmental services (SRS-HKP). Wired after the
	// encounter and quality contexts because both of its seams read one:
	// whether the discharge a terminal clean is raised for actually
	// happened, and whether the incident a spill clean names exists. Both
	// are read through ports that cannot write, so housekeeping can neither
	// close an encounter nor raise an incident — it reads what happened and
	// cleans up afterwards.
	hkpRepo := hkppostgres.New(txManager)
	housekeepingService := hkpapp.NewService(hkpapp.Deps{
		UnitOfWork: txManager,
		Locations:  hkpRepo,
		Tasks:      hkpRepo,
		Scans:      hkpRepo,
		Holds:      hkpRepo,
		// Whether the patient has left belongs to the encounter context. A
		// bed taken out of service with somebody still in it is a bed the
		// ward stops trusting the board about.
		Encounters: hkpcrosscontext.NewEncounters(
			encounterpostgres.EncounterRepo{Repository: encounterRepo}),
		// And the incident a spill belongs to is resolved where it was
		// raised. Without this, "the incident link is retained" is defeated
		// by typing anything into the field.
		Incidents: hkpcrosscontext.NewIncidents(
			qualitypostgres.IncidentRepo{Repository: qualityRepo}),
		Events:     platformStore,
		AuditTrail: store.AuditAppenderFunc(platformStore.AppendAudit),
		// An overdue clean in a theatre, and a bed put back into service
		// uncleaned. Both have to reach somebody rather than a screen nobody
		// opened.
		Escalations: hkpescalate.New(escalationStore),
		IDs:         uuidGenerator{},
		Clock:       systemClock{},
		Config:      deps.Housekeeping,
	})

	// Medical records and health information management (SRS-MRD). Wired
	// after the clinical and encounter contexts because everything here is
	// judged against what they hold, and read through ports that cannot write
	// to either: SRS-MRD-003's "coder changes do not rewrite clinical text"
	// and SRS-MRD-008's "resolved without altering signed history" are
	// properties of this wiring as much as of the code behind it.
	recordsRepo := recordspostgres.New(txManager)
	recordsService := recordsapp.NewService(recordsapp.Deps{
		UnitOfWork:   txManager,
		Checklists:   recordsRepo,
		Deficiencies: recordsRepo,
		Coding:       recordsRepo,
		Releases:     recordsRepo,
		Retention:    recordsRepo,
		Physical:     recordsRepo,
		Certificates: recordsRepo,
		// Read-only seams. The chart is the clinical context's documents and
		// the encounter context's facts, not a copy of either.
		Documents: recordscrosscontext.NewDocuments(clinicalDocuments),
		Encounters: recordscrosscontext.NewEncounters(
			encounterpostgres.EncounterRepo{Repository: encounterRepo},
			deps.RecordsJurisdictions, deps.RecordsConditions),
		// The platform's own hold mechanism, which SRS-QMS-015 and SRS-DAT
		// also place holds through. A hold placed in one place and a purge
		// that reads another is a hold that does nothing.
		Holds: recordscrosscontext.NewHolds(securityRepo, uuidGenerator{},
			deps.RecordsHeldClasses),
		// The paper volumes this context owns. A deployment that wants its
		// electronic records swept supplies an inventory adapter that knows
		// where they are; without one the sweep covers the paper and says so.
		Inventory:  recordsRepo,
		Events:     platformStore,
		AuditTrail: store.AuditAppenderFunc(platformStore.AppendAudit),
		// A deficiency past its date and its grace period, and a paper record
		// nobody can find. Both have to reach somebody rather than a screen
		// nobody opened.
		Escalations: recordsescalate.New(escalationStore),
		IDs:         uuidGenerator{},
		Clock:       systemClock{},
		Config:      deps.Records,
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
	mux.Handle(emergencyv1connect.NewEmergencyServiceHandler(
		emergencytransport.NewHandler(emergencyService), interceptors))
	mux.Handle(icuv1connect.NewIcuServiceHandler(
		icutransport.NewHandler(icuService, time.Now), interceptors))
	mux.Handle(theatrev1connect.NewTheatreServiceHandler(
		theatretransport.NewHandler(theatreService, time.Now), interceptors))
	mux.Handle(anaesthesiav1connect.NewAnaesthesiaServiceHandler(
		anaesthesiatransport.NewHandler(anaesthesiaService, time.Now), interceptors))
	mux.Handle(bloodbankv1connect.NewBloodBankServiceHandler(
		bloodbanktransport.NewHandler(bloodbankService, time.Now), interceptors))
	mux.Handle(sterilev1connect.NewSterileServicesServiceHandler(
		steriletransport.NewHandler(sterileService, time.Now), interceptors))
	mux.Handle(biomedicalv1connect.NewBiomedicalServiceHandler(
		biomedicaltransport.NewHandler(biomedicalService, time.Now), interceptors))
	mux.Handle(qualityv1connect.NewQualityServiceHandler(
		qualitytransport.NewHandler(qualityService, time.Now), interceptors))
	mux.Handle(infectionv1connect.NewInfectionServiceHandler(
		infectiontransport.NewHandler(infectionService, time.Now),
		interceptors))
	mux.Handle(recordsv1connect.NewRecordsServiceHandler(
		recordstransport.NewHandler(recordsService, time.Now),
		interceptors))
	mux.Handle(hospitalopsdietv1connect.NewDietServiceHandler(
		diettransport.NewHandler(dietService, time.Now),
		interceptors))
	mux.Handle(housekeepingv1connect.NewHousekeepingServiceHandler(
		hkptransport.NewHandler(housekeepingService, time.Now),
		interceptors))
	mux.Handle(materialsv1connect.NewMaterialsServiceHandler(
		materialstransport.NewHandler(materialsService, time.Now), interceptors))
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
	health := platformapitransport.NewHandler(deps.Build,
		map[string]platformapitransport.Pinger{
			"postgres": poolPinger{pool: deps.Pool},
		})
	if deps.Draining != nil {
		health.WatchDraining(deps.Draining)
	}
	mux.Handle(platformapiv1connect.NewHealthServiceHandler(health, interceptors))
	// The same checks over plain HTTP GET, because a Kubernetes httpGet probe
	// cannot POST and a Connect procedure is a POST. Registered outside the
	// interceptor chain on purpose: a probe that needed a bearer token would
	// make an unauthenticated kubelet mark every pod unready.
	health.RegisterProbes(mux)

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
		Emergency:       emergencyService,
		Icu:             icuService,
		Theatre:         theatreService,
		Anaesthesia:     anaesthesiaService,
		BloodBank:       bloodbankService,
		Sterile:         sterileService,
		Materials:       materialsService,
		Biomedical:      biomedicalService,
		Quality:         qualityService,
		Infection:       infectionService,
		Records:         recordsService,
		Dietetics:       dietService,
		Housekeeping:    housekeepingService,
		Nursing:         nursingService,
		Orders:          ordersService,
		Medication:      medicationService,
		Billing:         billingService,
		Store:           platformStore,
		RateLimiter:     rateLimiter,
		Publisher:       publisher,
		Events:          events,
		Escalations:     escalationDriver,
		EscalationStore: escalationStore,
		Err:             errors.Join(eventsErr, escalationErr),
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

	runners := 2
	errs := make(chan error, 3)
	go func() { errs <- s.Publisher.Run(ctx, s.publishInterval) }()
	go func() { errs <- s.Events.Run(ctx) }()
	if s.Escalations != nil {
		runners++
		go func() { errs <- s.Escalations.Run(ctx, 0) }()
	}

	// The first exit stops the others: a publisher without consumers builds a
	// backlog, consumers without a publisher have nothing to consume, and an
	// escalation driver that has stopped is a ward whose unacknowledged
	// results sit still while the screens keep working. Running on with part
	// of the pipeline is the shape of an outage nobody notices for an hour.
	first := <-errs
	cancel()
	for i := 1; i < runners; i++ {
		<-errs
	}
	return first
}
