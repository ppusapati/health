// Package ports declares what the sterile services application layer needs.
//
// Declared by the consumer rather than by the adapters that implement them,
// which keeps the dependency arrow pointing inward (Blueprint §4.1).
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/sterile/domain"
)

// ErrVersionConflict reports that another writer got there first.
var ErrVersionConflict = errors.New("sterile: changed concurrently")

// MasterRepository persists the instrument and tray masters.
//
// Every method takes authctx.TenantScope, which has no constructor outside the
// auth package, so reaching a row without a verified tenant does not compile
// (FIT-03).
type MasterRepository interface {
	InsertInstrument(ctx context.Context, scope authctx.TenantScope,
		i domain.Instrument) error
	Instrument(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Instrument, error)
	UpdateInstrument(ctx context.Context, scope authctx.TenantScope,
		i domain.Instrument, expectedVersion int64) error
	Instruments(ctx context.Context, scope authctx.TenantScope, code string,
		limit int32) ([]domain.Instrument, error)
	// OutOfService is the lifecycle worklist: what is away, missing or
	// retired.
	OutOfService(ctx context.Context, scope authctx.TenantScope, limit int32) (
		[]domain.Instrument, error)

	InsertSet(ctx context.Context, scope authctx.TenantScope,
		s domain.TraySet) error
	// Supersede closes a version and opens its replacement, in one
	// transaction. Two statements rather than one because the database holds
	// "at most one current version per code" as an index.
	Supersede(ctx context.Context, scope authctx.TenantScope,
		next domain.TraySet, previousID string, at time.Time) error
	Set(ctx context.Context, scope authctx.TenantScope, setID string) (
		domain.TraySet, error)
	// CurrentSet is the version in force, which is what a run is assembled
	// against. False where the code is unknown.
	CurrentSet(ctx context.Context, scope authctx.TenantScope, code string) (
		domain.TraySet, bool, error)
	// SetVersions is the history, which is how a pack assembled last month is
	// read against the list as it was then.
	SetVersions(ctx context.Context, scope authctx.TenantScope, code string) (
		[]domain.TraySet, error)
	Sets(ctx context.Context, scope authctx.TenantScope, limit int32) (
		[]domain.TraySet, error)
}

// CycleRepository persists sterilizer loads and their indicators.
type CycleRepository interface {
	InsertCycle(ctx context.Context, scope authctx.TenantScope,
		c domain.Cycle) error
	Cycle(ctx context.Context, scope authctx.TenantScope, cycleID string) (
		domain.Cycle, error)
	// CycleByLoad is how a technician finds the load they just ran, from the
	// number on the printout.
	CycleByLoad(ctx context.Context, scope authctx.TenantScope,
		machine, loadNumber string) (domain.Cycle, bool, error)
	UpdateCycle(ctx context.Context, scope authctx.TenantScope, c domain.Cycle,
		expectedVersion int64) error
	// AwaitingRelease is the loads that finished and have not been cleared.
	AwaitingRelease(ctx context.Context, scope authctx.TenantScope,
		limit int32) ([]domain.Cycle, error)
	CyclesForMachine(ctx context.Context, scope authctx.TenantScope,
		machine string, from, to time.Time, limit int32) ([]domain.Cycle, error)

	InsertIndicator(ctx context.Context, scope authctx.TenantScope,
		i domain.IndicatorResult) error
	Indicators(ctx context.Context, scope authctx.TenantScope, cycleID string) (
		[]domain.IndicatorResult, error)
	// ClearedByLot runs the bad-batch investigation: from an indicator lot to
	// every load it cleared.
	ClearedByLot(ctx context.Context, scope authctx.TenantScope, lot string,
		limit int32) ([]domain.Cycle, error)
}

// RunRepository persists reprocessing runs and their stages.
type RunRepository interface {
	InsertRun(ctx context.Context, scope authctx.TenantScope,
		r domain.Run) error
	Run(ctx context.Context, scope authctx.TenantScope, runID string) (
		domain.Run, error)
	UpdateRun(ctx context.Context, scope authctx.TenantScope, r domain.Run,
		expectedVersion int64) error
	RunsForCycle(ctx context.Context, scope authctx.TenantScope,
		cycleID string) ([]domain.Run, error)
	// InProgress is the department's own board.
	InProgress(ctx context.Context, scope authctx.TenantScope, limit int32) (
		[]domain.Run, error)
	// Shelf is the released, in-date packs, soonest to expire first.
	Shelf(ctx context.Context, scope authctx.TenantScope, setCode string,
		asOf time.Time, limit int32) ([]domain.Run, error)
	Expired(ctx context.Context, scope authctx.TenantScope, asOf time.Time,
		limit int32) ([]domain.Run, error)

	InsertStage(ctx context.Context, scope authctx.TenantScope,
		s domain.StageRecord) error
	Stages(ctx context.Context, scope authctx.TenantScope, runID string) (
		[]domain.StageRecord, error)
	// SkippedStages is the exceptions register a quality review reads.
	SkippedStages(ctx context.Context, scope authctx.TenantScope,
		from, to time.Time, limit int32) ([]domain.StageRecord, error)
}

// DistributionRepository persists issues and recalls.
type DistributionRepository interface {
	InsertIssue(ctx context.Context, scope authctx.TenantScope,
		i domain.Issue) error
	Issue(ctx context.Context, scope authctx.TenantScope, issueID string) (
		domain.Issue, error)
	UpdateIssue(ctx context.Context, scope authctx.TenantScope,
		i domain.Issue) error
	IssuesForRun(ctx context.Context, scope authctx.TenantScope, runID string) (
		[]domain.Issue, error)
	// IssuesForCase is SRS-CSSD-010's direction: from a patient's operation
	// back to every set it used.
	IssuesForCase(ctx context.Context, scope authctx.TenantScope,
		caseID string) ([]domain.Issue, error)
	// IssuesForCycle is the recall's reach: every issue of every pack in one
	// load.
	IssuesForCycle(ctx context.Context, scope authctx.TenantScope,
		cycleID string) ([]domain.Issue, error)
	Outstanding(ctx context.Context, scope authctx.TenantScope,
		destination string, limit int32) ([]domain.Issue, error)

	InsertRecall(ctx context.Context, scope authctx.TenantScope,
		r Recall) error
	Recall(ctx context.Context, scope authctx.TenantScope, recallID string) (
		Recall, error)
	// CloseRecall is false where somebody closed it first.
	CloseRecall(ctx context.Context, scope authctx.TenantScope,
		recallID, note, by string, at time.Time) (bool, error)
	OpenRecalls(ctx context.Context, scope authctx.TenantScope, limit int32) (
		[]Recall, error)
}

// Recall is a raised recall as it is stored.
//
// The counts are frozen at the moment it was raised, because the packs move
// afterwards and a recall report has to say what it found rather than what is
// true now.
type Recall struct {
	ID       string
	TenantID string
	CycleID  string

	Reason        string
	PacksAffected int
	CasesAffected int

	RaisedAt    time.Time
	RaisedBy    string
	ClosedAt    time.Time
	ClosedBy    string
	ClosingNote string
}

// Open reports a recall nobody has closed.
func (r Recall) Open() bool { return r.ClosedAt.IsZero() }

// Cases reports what the theatre knows about an operation a set was used in.
//
// A port, because the case belongs to SRS-OT and sterile services reads it
// without owning it.
type Cases interface {
	// Exists reports a case the theatre knows. False rather than an error for
	// an unknown one, so the caller says so in its own words.
	Exists(ctx context.Context, scope authctx.TenantScope, caseID string) (
		bool, error)
}

// EventAppender publishes domain events through the outbox.
type EventAppender interface {
	Append(ctx context.Context, e outbox.Event) error
}

// AuditAppender writes the append-only audit trail.
type AuditAppender interface {
	Append(ctx context.Context, r audit.Record) error
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
// Used for the one thing here that cannot wait for somebody to refresh a
// screen: a recall, which has to reach the wards holding the packs and the
// infection control team holding the patients.
//
// It does not take recipients. Who is paged is the tenant's configured
// escalation matrix, resolved at delivery.
type Escalator interface {
	Raise(ctx context.Context, scope authctx.TenantScope, n Notice,
		at time.Time) (string, error)
}

// UnitOfWork runs a use case in one transaction.
type UnitOfWork interface {
	WithinTx(ctx context.Context, fn func(context.Context) error) error
}

// IDGenerator mints identifiers.
type IDGenerator interface{ NewID() string }

// Clock reads the time.
type Clock interface{ Now() time.Time }
