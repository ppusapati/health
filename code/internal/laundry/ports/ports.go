// Package ports declares what the laundry use cases need from the outside.
//
// Interfaces owned by this context rather than by whoever implements them, so
// the dependency arrow points inward (FIT-01).
//
// One absence is deliberate and load-bearing. There is no method here that
// changes a wash batch's outcome after it has been recorded, and none that
// re-counts a sealed collection. A laundry that could turn a failed batch
// into a passed one would have no way of noticing that one machine fails
// every third load, and a system that could re-count infected linen is a
// system where somebody is asked to open the bag.
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/laundry/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
)

// ErrVersionConflict is a lost update: somebody else changed the record
// between the read and the write.
var ErrVersionConflict = errors.New("laundry: version conflict")

// ItemFilter narrows a linen item list.
type ItemFilter struct {
	Category    string
	TrackedOnly bool
	ActiveOnly  bool
	Limit       int32
	Offset      int32
}

// ItemRepository persists the linen item master (SRS-LND-001).
//
// Every method takes authctx.TenantScope, which has no constructor outside
// the auth package, so reaching a row without a verified tenant does not
// compile (FIT-03).
type ItemRepository interface {
	InsertItem(ctx context.Context, scope authctx.TenantScope,
		i domain.LinenItem) error
	Item(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.LinenItem, error)
	// ItemByCode is how a tag registration and a par line resolve what they
	// name.
	ItemByCode(ctx context.Context, scope authctx.TenantScope, code string) (
		domain.LinenItem, error)
	UpdateItem(ctx context.Context, scope authctx.TenantScope,
		i domain.LinenItem, expectedVersion int64) error
	Items(ctx context.Context, scope authctx.TenantScope, f ItemFilter) (
		[]domain.LinenItem, error)
}

// ParFilter narrows a par level list.
type ParFilter struct {
	FacilityID string
	UnitID     string
	LiveOnly   bool
	At         time.Time
	Limit      int32
	Offset     int32
}

// ParRepository persists unit par levels (SRS-LND-001).
type ParRepository interface {
	// InsertPar stores the par and its lines together. A par whose lines
	// landed afterwards would be a unit whose shortfall was briefly
	// everything it holds.
	InsertPar(ctx context.Context, scope authctx.TenantScope,
		p domain.ParLevel) error
	Par(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.ParLevel, error)
	// ApprovePar and SupersedePar are the only updates. There is no method
	// that edits an approved par in place: the question after a ward ran
	// out of sheets is what the par said at the time, and a row edited
	// afterwards cannot answer it.
	ApprovePar(ctx context.Context, scope authctx.TenantScope,
		p domain.ParLevel, expectedVersion int64) error
	SupersedePar(ctx context.Context, scope authctx.TenantScope,
		id string, at time.Time) error
	Pars(ctx context.Context, scope authctx.TenantScope, f ParFilter) (
		[]domain.ParLevel, error)
	// RevisionsOf returns every revision of one unit's par, which is what
	// ParInForce picks between.
	RevisionsOf(ctx context.Context, scope authctx.TenantScope,
		unitID string) ([]domain.ParLevel, error)
}

// CollectionFilter narrows a soiled-collection list.
type CollectionFilter struct {
	FacilityID  string
	UnitID      string
	SoilClass   string
	States      []string
	BatchID     string
	PendingOnly bool
	From        time.Time
	To          time.Time
	Limit       int32
	Offset      int32
}

// CollectionRepository persists soiled linen collections (SRS-LND-002).
type CollectionRepository interface {
	InsertCollection(ctx context.Context, scope authctx.TenantScope,
		c domain.Collection) error
	Collection(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Collection, error)
	// UpdateCollection writes the collection and its declared lines
	// together.
	UpdateCollection(ctx context.Context, scope authctx.TenantScope,
		c domain.Collection, expectedVersion int64) error
	Collections(ctx context.Context, scope authctx.TenantScope,
		f CollectionFilter) ([]domain.Collection, error)
	// ForBatch is the chain SRS-LND-002 asks to be retained, read from the
	// batch end: whose linen was in the load that failed.
	ForBatch(ctx context.Context, scope authctx.TenantScope,
		batchID string) ([]domain.Collection, error)
}

// BatchFilter narrows a wash batch list.
type BatchFilter struct {
	FacilityID string
	MachineID  string
	Cycle      string
	States     []string
	From       time.Time
	To         time.Time
	Limit      int32
	Offset     int32
}

// BatchRepository persists wash batches (SRS-LND-003).
type BatchRepository interface {
	InsertBatch(ctx context.Context, scope authctx.TenantScope,
		b domain.Batch) error
	Batch(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Batch, error)
	// UpdateBatch writes the batch and its exceptions together. A failed
	// batch whose exceptions landed afterwards would read, for as long as
	// it took, as a failure nobody could explain.
	UpdateBatch(ctx context.Context, scope authctx.TenantScope,
		b domain.Batch, expectedVersion int64) error
	Batches(ctx context.Context, scope authctx.TenantScope, f BatchFilter) (
		[]domain.Batch, error)
}

// IssueFilter narrows a clean-linen issue list.
type IssueFilter struct {
	FacilityID      string
	UnitID          string
	BatchID         string
	OutstandingOnly bool
	From            time.Time
	To              time.Time
	Limit           int32
	Offset          int32
}

// IssueRepository persists clean linen issues (SRS-LND-004).
type IssueRepository interface {
	InsertIssue(ctx context.Context, scope authctx.TenantScope,
		i domain.Issue) error
	Issue(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Issue, error)
	// ReceiveIssue is the only update. An issue's lines are not editable:
	// a delivery note corrected after the fact is a balance nobody can
	// reconcile.
	ReceiveIssue(ctx context.Context, scope authctx.TenantScope,
		i domain.Issue, expectedVersion int64) error
	Issues(ctx context.Context, scope authctx.TenantScope, f IssueFilter) (
		[]domain.Issue, error)
}

// LossFilter narrows a loss record list.
type LossFilter struct {
	FacilityID string
	UnitID     string
	ItemCode   string
	Kind       string
	States     []string
	From       time.Time
	To         time.Time
	Limit      int32
	Offset     int32
}

// LossRepository persists condemned, damaged and missing linen
// (SRS-LND-006).
type LossRepository interface {
	InsertLoss(ctx context.Context, scope authctx.TenantScope,
		l domain.LossRecord) error
	Loss(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.LossRecord, error)
	UpdateLoss(ctx context.Context, scope authctx.TenantScope,
		l domain.LossRecord, expectedVersion int64) error
	Losses(ctx context.Context, scope authctx.TenantScope, f LossFilter) (
		[]domain.LossRecord, error)
}

// TrackedFilter narrows a tracked item list.
type TrackedFilter struct {
	FacilityID    string
	ItemCode      string
	AssignedTo    string
	InServiceOnly bool
	Limit         int32
	Offset        int32
}

// TrackedRepository persists tagged linen and its custody trail
// (SRS-LND-007).
//
// AppendMovement is append-only and there is no method that edits or removes
// one. A custody trail somebody can edit says whatever the last person to
// touch it wanted, and the question it answers is always asked by somebody
// who suspects an answer.
type TrackedRepository interface {
	InsertTracked(ctx context.Context, scope authctx.TenantScope,
		t domain.TrackedItem) error
	Tracked(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.TrackedItem, error)
	// TrackedByTag is the reader's lookup: a scan arrives as a tag, not an
	// identifier.
	TrackedByTag(ctx context.Context, scope authctx.TenantScope,
		tagID string) (domain.TrackedItem, error)
	UpdateTracked(ctx context.Context, scope authctx.TenantScope,
		t domain.TrackedItem, expectedVersion int64) error
	AppendMovement(ctx context.Context, scope authctx.TenantScope,
		trackedID string, m domain.Movement) error
	TrackedItems(ctx context.Context, scope authctx.TenantScope,
		f TrackedFilter) ([]domain.TrackedItem, error)
}

// Units answers whether the ward a par or a collection names exists
// (SRS-LND-001, SRS-LND-002).
//
// Without this, a par level and a collection can be recorded against a unit
// nobody has heard of, and the linen that goes there is linen nobody can
// reconcile: the balance is right, for a ward that is not there. A deployment
// with no adapter accepts whatever it is given, which the status document
// says out loud.
type Units interface {
	Exists(ctx context.Context, scope authctx.TenantScope,
		unitID string) (bool, error)
}

// Notice is something somebody has to be told about now.
type Notice struct {
	Kind       string
	Subject    string
	FacilityID string
	Summary    string
}

// Escalator raises a durable, acknowledged notice (SRS-LND-003).
//
// Used for the one thing here that cannot wait for somebody to open a screen:
// a wash that failed, whose linen the wards in it may already be making beds
// with.
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
