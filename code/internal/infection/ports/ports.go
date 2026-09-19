// Package ports declares what the infection control use cases need from the
// outside.
//
// Interfaces owned by this context rather than by whoever implements them, so
// the dependency arrow points inward (FIT-01).
//
// One absence is deliberate and load-bearing: there is no port here that
// writes to a medication order. SRS-IPC-008's acceptance is that a stewardship
// review appears in a worklist "without autonomous medication change", and the
// way to mean that is to have nothing to change it with. Therapy reaches this
// context through Therapy, which reads.
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/infection/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
)

// ErrVersionConflict is a lost update: somebody else changed the record
// between the read and the write.
var ErrVersionConflict = errors.New("infection: version conflict")

// CaseFilter narrows a surveillance case list.
type CaseFilter struct {
	PatientID  string
	State      string
	Site       domain.InfectionSite
	LocationID string
	From, To   time.Time
	Limit      int32
	Offset     int32
}

// CaseRepository persists surveillance cases (SRS-IPC-001).
//
// Every method takes authctx.TenantScope, which has no constructor outside the
// auth package, so reaching a row without a verified tenant does not compile
// (FIT-03).
type CaseRepository interface {
	InsertCase(ctx context.Context, scope authctx.TenantScope,
		c domain.SurveillanceCase) error
	Case(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.SurveillanceCase, error)
	UpdateCase(ctx context.Context, scope authctx.TenantScope,
		c domain.SurveillanceCase, expectedVersion int64) error
	Cases(ctx context.Context, scope authctx.TenantScope, f CaseFilter) (
		[]domain.SurveillanceCase, error)
}

// DeviceDayFilter narrows a denominator list.
type DeviceDayFilter struct {
	Device     domain.DeviceKind
	LocationID string
	From, To   time.Time
}

// DeviceDayRepository persists the daily census a rate is computed over
// (SRS-IPC-002).
//
// Upsert rather than insert: a ward that recounts its day corrects the count
// it already filed. Two rows for one day would double the denominator and
// halve every rate that reads it, which is why the unique index is on
// (tenant, location, device, day) rather than on the identifier.
type DeviceDayRepository interface {
	UpsertDeviceDays(ctx context.Context, scope authctx.TenantScope,
		c domain.DeviceDayCount) error
	DeviceDays(ctx context.Context, scope authctx.TenantScope,
		f DeviceDayFilter) ([]domain.DeviceDayCount, error)
}

// IsolationFilter narrows an isolation list.
type IsolationFilter struct {
	LocationID string
	PatientID  string
	ActiveOnly bool
	Limit      int32
	Offset     int32
}

// IsolationRepository persists precautions (SRS-IPC-003).
type IsolationRepository interface {
	InsertIsolation(ctx context.Context, scope authctx.TenantScope,
		i domain.Isolation) error
	Isolation(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Isolation, error)
	UpdateIsolation(ctx context.Context, scope authctx.TenantScope,
		i domain.Isolation, expectedVersion int64) error
	Isolations(ctx context.Context, scope authctx.TenantScope,
		f IsolationFilter) ([]domain.Isolation, error)
}

// AlertRepository persists the MDRO rules and what they fired (SRS-IPC-004).
//
// Rules are inserted and superseded, never updated in place: an alert from
// eighteen months ago has to stay explicable after the rule has been changed
// twice.
type AlertRepository interface {
	InsertRule(ctx context.Context, scope authctx.TenantScope,
		r domain.AlertRule) error
	Rule(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.AlertRule, error)
	ApproveRule(ctx context.Context, scope authctx.TenantScope,
		r domain.AlertRule) error
	// SupersedeEarlier closes off every revision of a code below this one, so
	// two revisions cannot be live at the same moment.
	SupersedeEarlier(ctx context.Context, scope authctx.TenantScope,
		code string, revision int, at time.Time) error
	Rules(ctx context.Context, scope authctx.TenantScope, code string,
		liveAt time.Time) ([]domain.AlertRule, error)

	InsertAlert(ctx context.Context, scope authctx.TenantScope,
		a domain.Alert) error
	Alert(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Alert, error)
	UpdateAlert(ctx context.Context, scope authctx.TenantScope,
		a domain.Alert) error
	Alerts(ctx context.Context, scope authctx.TenantScope,
		patientID, encounterID string, outstandingOnly bool, limit int32) (
		[]domain.Alert, error)
}

// OutbreakRepository persists cluster investigations (SRS-IPC-005).
type OutbreakRepository interface {
	InsertOutbreak(ctx context.Context, scope authctx.TenantScope,
		o domain.Outbreak) error
	Outbreak(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Outbreak, error)
	UpdateOutbreak(ctx context.Context, scope authctx.TenantScope,
		o domain.Outbreak, expectedVersion int64) error
	Outbreaks(ctx context.Context, scope authctx.TenantScope, state string,
		openOnly bool, limit int32) ([]domain.Outbreak, error)

	AddMember(ctx context.Context, scope authctx.TenantScope,
		m domain.Membership) error
	Members(ctx context.Context, scope authctx.TenantScope,
		outbreakID string) ([]domain.Membership, error)
}

// HygieneRepository persists observation sessions and what was seen
// (SRS-IPC-006).
//
// Observations carry no person identifier, here or anywhere else. The port
// does not take one, so an adapter cannot start storing one without this
// interface changing first.
type HygieneRepository interface {
	InsertSession(ctx context.Context, scope authctx.TenantScope,
		s domain.HygieneSession) error
	Session(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.HygieneSession, error)
	EndSession(ctx context.Context, scope authctx.TenantScope,
		s domain.HygieneSession, expectedVersion int64) error
	InsertObservation(ctx context.Context, scope authctx.TenantScope,
		o domain.HygieneObservation) error
	Observations(ctx context.Context, scope authctx.TenantScope,
		locationID, sessionID string, from, to time.Time) (
		[]domain.HygieneObservation, error)
}

// ExposureFilter narrows an exposure list.
type ExposureFilter struct {
	StaffID  string
	OpenOnly bool
	From, To time.Time
	Limit    int32
	Offset   int32
}

// ExposureRepository persists occupational exposures (SRS-IPC-007).
type ExposureRepository interface {
	InsertExposure(ctx context.Context, scope authctx.TenantScope,
		e domain.Exposure, tasks []domain.ExposureTask) error
	Exposure(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Exposure, error)
	CloseExposure(ctx context.Context, scope authctx.TenantScope,
		e domain.Exposure, expectedVersion int64) error
	Exposures(ctx context.Context, scope authctx.TenantScope,
		f ExposureFilter) ([]domain.Exposure, error)

	Tasks(ctx context.Context, scope authctx.TenantScope, exposureID string) (
		[]domain.ExposureTask, error)
	UpdateTask(ctx context.Context, scope authctx.TenantScope,
		t domain.ExposureTask) error
	// DueTasks is the follow-up worklist: steps still due and past the point
	// they stop being useful.
	DueTasks(ctx context.Context, scope authctx.TenantScope,
		before time.Time) ([]domain.ExposureTask, error)
}

// ReviewFilter narrows a stewardship worklist.
type ReviewFilter struct {
	PatientID    string
	EncounterID  string
	State        string
	WorklistOnly bool
	From, To     time.Time
	Limit        int32
	Offset       int32
}

// StewardshipRepository persists the review triggers and the worklist
// (SRS-IPC-008).
type StewardshipRepository interface {
	// Named apart from the alert rules rather than overloaded: one adapter
	// implements both, and two "InsertRule" methods would mean two adapters
	// or a silent choice about which rule kind a caller meant.
	InsertStewardshipRule(ctx context.Context, scope authctx.TenantScope,
		r domain.StewardshipRule) error
	StewardshipRule(ctx context.Context, scope authctx.TenantScope,
		id string) (domain.StewardshipRule, error)
	ApproveStewardshipRule(ctx context.Context, scope authctx.TenantScope,
		r domain.StewardshipRule) error
	SupersedeEarlierStewardshipRules(ctx context.Context,
		scope authctx.TenantScope, code string, revision int,
		at time.Time) error
	StewardshipRules(ctx context.Context, scope authctx.TenantScope,
		code string, liveAt time.Time) ([]domain.StewardshipRule, error)

	InsertReview(ctx context.Context, scope authctx.TenantScope,
		r domain.StewardshipReview) error
	Review(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.StewardshipReview, error)
	UpdateReview(ctx context.Context, scope authctx.TenantScope,
		r domain.StewardshipReview, expectedVersion int64) error
	Reviews(ctx context.Context, scope authctx.TenantScope, f ReviewFilter) (
		[]domain.StewardshipReview, error)
}

// SampleFilter narrows an environmental result list.
type SampleFilter struct {
	LocationID  string
	Kind        domain.SampleKind
	FailingOnly bool
	From, To    time.Time
	Limit       int32
	Offset      int32
}

// EnvironmentRepository persists limits, plans, samples and their actions
// (SRS-IPC-009).
type EnvironmentRepository interface {
	InsertLimit(ctx context.Context, scope authctx.TenantScope,
		l domain.EnvironmentalLimit) error
	Limit(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.EnvironmentalLimit, error)
	ApproveLimit(ctx context.Context, scope authctx.TenantScope,
		l domain.EnvironmentalLimit) error
	SupersedeEarlierLimits(ctx context.Context, scope authctx.TenantScope,
		code string, revision int, at time.Time) error
	// Limits returns the versions a result is judged against. liveAt zero
	// returns every revision, which is what an administrator's screen reads.
	Limits(ctx context.Context, scope authctx.TenantScope,
		kind domain.SampleKind, liveAt time.Time) (
		[]domain.EnvironmentalLimit, error)

	InsertPlan(ctx context.Context, scope authctx.TenantScope,
		p domain.SamplingPlan) error
	StopPlan(ctx context.Context, scope authctx.TenantScope, planID string,
		at time.Time) error
	Plans(ctx context.Context, scope authctx.TenantScope, locationID string,
		activeOnly bool) ([]domain.SamplingPlan, error)

	InsertSample(ctx context.Context, scope authctx.TenantScope,
		s domain.EnvironmentalSample) error
	Sample(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.EnvironmentalSample, error)
	UpdateSample(ctx context.Context, scope authctx.TenantScope,
		s domain.EnvironmentalSample, expectedVersion int64) error
	Samples(ctx context.Context, scope authctx.TenantScope, f SampleFilter) (
		[]domain.EnvironmentalSample, error)

	InsertAction(ctx context.Context, scope authctx.TenantScope,
		a domain.CorrectiveAction) error
	Action(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.CorrectiveAction, error)
	UpdateAction(ctx context.Context, scope authctx.TenantScope,
		a domain.CorrectiveAction, expectedVersion int64) error
	// Actions for one sample, or every open one where sampleID is empty.
	Actions(ctx context.Context, scope authctx.TenantScope, sampleID string,
		openOnly bool) ([]domain.CorrectiveAction, error)
}

// Therapy reads what a patient is actually on, for the stewardship triggers
// (SRS-IPC-008).
//
// Read-only by construction. This is the seam where a system that meant to be
// helpful would grow a "stop the antibiotic" method, and the requirement's
// acceptance is that it does not: the review produces a recommendation and a
// prescriber acts on it under their own authority.
type Therapy interface {
	Current(ctx context.Context, scope authctx.TenantScope,
		encounterID string) (domain.TherapySignal, error)
	// PatientDays is the denominator for days of therapy per 1000 patient
	// days (SRS-IPC-010). Counted from the census rather than estimated.
	PatientDays(ctx context.Context, scope authctx.TenantScope,
		locationID string, from, to time.Time) (int, error)
}

// Indicators publishes this context's computed rates into the quality
// context's versioned indicator dictionary (SRS-IPC-010, SRS-QMS-011).
//
// A port rather than a second dictionary here. SRS-IPC-010's acceptance is
// that metric definitions are versioned, and SRS-QMS-011 already versions
// them; two dictionaries would disagree, and the argument would be about
// which report was right rather than about the infection rate.
type Indicators interface {
	// Record files a value against an indicator definition. The definition's
	// revision comes back, so a report can say which version produced the
	// number.
	Record(ctx context.Context, scope authctx.TenantScope, code string,
		periodFrom, periodTo time.Time, numerator, denominator int,
		by string, at time.Time) (revision int, err error)
}

// Notice is something somebody has to be told about now.
type Notice struct {
	Kind       string
	Subject    string
	FacilityID string
	Summary    string
}

// Escalator raises a durable, acknowledged notice.
//
// Used for the things here that cannot wait for somebody to open a screen: an
// outbreak being declared, an exposure step running past its window, and a
// failed environmental result in an augmented-care area.
type Escalator interface {
	Raise(ctx context.Context, scope authctx.TenantScope, n Notice,
		at time.Time) (string, error)
}

// EventAppender publishes domain events through the outbox.
type EventAppender interface {
	Append(ctx context.Context, e outbox.Event) error
}

// AuditAppender writes the append-only audit trail.
type AuditAppender interface {
	Append(ctx context.Context, r audit.Record) error
}

// UnitOfWork runs a use case in one transaction.
type UnitOfWork interface {
	WithinTx(ctx context.Context, fn func(context.Context) error) error
}

// IDGenerator mints identifiers.
type IDGenerator interface{ NewID() string }

// Clock reads the time.
type Clock interface{ Now() time.Time }
