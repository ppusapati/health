// Package ports declares what the housekeeping use cases need from the
// outside.
//
// Interfaces owned by this context rather than by whoever implements them, so
// the dependency arrow points inward (FIT-01).
//
// One absence is deliberate and load-bearing. There is no port here a
// location scan can be handed to on its own, and no method that takes a
// scanned code and returns a completed task. SRS-HKP-007's "scan does not
// replace user authentication" is a property of this interface list: a scan
// is appended to a task by an authenticated caller who is already allowed to
// work on it, and that is the only thing a scan can do.
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/housekeeping/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
)

// ErrVersionConflict is a lost update: somebody else changed the record
// between the read and the write.
var ErrVersionConflict = errors.New("housekeeping: version conflict")

// LocationFilter narrows a location list.
type LocationFilter struct {
	FacilityID string
	Zone       string
	RiskClass  string
	// LiveOnly restricts to standards in force at the moment asked about.
	LiveOnly bool
	At       time.Time
	Limit    int32
	Offset   int32
}

// LocationRepository persists cleanable locations and their standards
// (SRS-HKP-001).
//
// Every method takes authctx.TenantScope, which has no constructor outside
// the auth package, so reaching a row without a verified tenant does not
// compile (FIT-03).
type LocationRepository interface {
	// InsertLocation stores the configuration and its checklist together.
	// One act, because a standard whose checklist landed afterwards would be
	// a standard a task could be raised against with nothing to answer.
	InsertLocation(ctx context.Context, scope authctx.TenantScope,
		l domain.CleanableLocation) error
	Location(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.CleanableLocation, error)
	// ApproveLocation is the only update to an unapproved standard, and
	// SupersedeLocation the only one to an approved one. There is no method
	// here that edits an approved standard in place: the audit question is
	// what the standard said at the time, and a row edited afterwards cannot
	// answer it.
	ApproveLocation(ctx context.Context, scope authctx.TenantScope,
		l domain.CleanableLocation, expectedVersion int64) error
	SupersedeLocation(ctx context.Context, scope authctx.TenantScope,
		id string, at time.Time) error
	Locations(ctx context.Context, scope authctx.TenantScope,
		f LocationFilter) ([]domain.CleanableLocation, error)
	// RevisionsOf returns every revision of one location's standard, which
	// is what LocationInForce picks between.
	RevisionsOf(ctx context.Context, scope authctx.TenantScope,
		code string) ([]domain.CleanableLocation, error)
}

// TaskFilter narrows a task list.
type TaskFilter struct {
	FacilityID string
	Zone       string
	// LocationCode restricts to one place.
	LocationCode string
	BedID        string
	Kind         string
	// States is the set wanted. Empty means every state.
	States     []string
	AssigneeID string
	// OpenOnly is the worklist read: tasks somebody still has to do.
	OpenOnly bool
	From     time.Time
	To       time.Time
	Limit    int32
	Offset   int32
}

// TaskRepository persists cleaning tasks (SRS-HKP-002, SRS-HKP-004).
type TaskRepository interface {
	// InsertTask stores the task and its copied checklist together, for the
	// same reason InsertLocation does.
	InsertTask(ctx context.Context, scope authctx.TenantScope,
		t domain.CleaningTask) error
	Task(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.CleaningTask, error)
	// UpdateTask writes the task and its checklist answers together.
	UpdateTask(ctx context.Context, scope authctx.TenantScope,
		t domain.CleaningTask, expectedVersion int64) error
	Tasks(ctx context.Context, scope authctx.TenantScope, f TaskFilter) (
		[]domain.CleaningTask, error)
	// OverdueCritical is the escalation read: unfinished critical-area tasks
	// past their SLA that nobody has been told about yet.
	OverdueCritical(ctx context.Context, scope authctx.TenantScope,
		facilityID string, at time.Time, limit int32) (
		[]domain.CleaningTask, error)
	// LastCleanedByLocation answers when each location was last cleaned,
	// which is what the routine schedule is derived from. Derived from the
	// tasks rather than stored on the location: a stored "last cleaned"
	// and the tasks behind it disagree the first time somebody corrects a
	// task, and the stored one is the one on the board.
	LastCleanedByLocation(ctx context.Context, scope authctx.TenantScope,
		facilityID string) (map[string]time.Time, error)
}

// ScanRepository persists location scans (SRS-HKP-007).
//
// Append-only. There is no update and no delete: a scan is evidence about a
// moment, and evidence somebody can edit afterwards is not evidence.
type ScanRepository interface {
	AppendScan(ctx context.Context, scope authctx.TenantScope, taskID string,
		s domain.LocationScan) error
	ScansForTask(ctx context.Context, scope authctx.TenantScope,
		taskID string) ([]domain.LocationScan, error)
}

// HoldFilter narrows a bed-hold list.
type HoldFilter struct {
	FacilityID string
	Zone       string
	BedID      string
	OpenOnly   bool
	From       time.Time
	To         time.Time
	Limit      int32
	Offset     int32
}

// HoldRepository persists bed cleaning holds (SRS-HKP-003).
type HoldRepository interface {
	InsertHold(ctx context.Context, scope authctx.TenantScope,
		h domain.BedHold) error
	Hold(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.BedHold, error)
	UpdateHold(ctx context.Context, scope authctx.TenantScope,
		h domain.BedHold, expectedVersion int64) error
	// OpenHoldForBed is the availability read a ward makes before putting
	// somebody in a bed.
	OpenHoldForBed(ctx context.Context, scope authctx.TenantScope,
		bedID string) (domain.BedHold, bool, error)
	// HoldForTask finds the hold a terminal clean is releasing.
	HoldForTask(ctx context.Context, scope authctx.TenantScope,
		taskID string) (domain.BedHold, bool, error)
	Holds(ctx context.Context, scope authctx.TenantScope, f HoldFilter) (
		[]domain.BedHold, error)
}

// EncounterFacts is what this context needs to know about a discharge
// (SRS-HKP-003).
type EncounterFacts struct {
	PatientID  string
	FacilityID string
	// OrgUnitID is the ward.
	OrgUnitID string
	// Ended reports the patient having left. A terminal clean raised against
	// an encounter that is still open is a bed taken out of service with
	// somebody in it.
	Ended   bool
	EndedAt time.Time
}

// Encounters answers whether the discharge a terminal clean is raised for
// actually happened (SRS-HKP-003).
//
// Read-only, and a projection rather than the encounter: housekeeping has no
// business reading why a patient came in. A deployment with no adapter raises
// terminal cleans on the ward's word alone, which is what the status document
// says it does.
type Encounters interface {
	Describe(ctx context.Context, scope authctx.TenantScope,
		encounterID string) (EncounterFacts, bool, error)
}

// Incidents answers whether the incident a spill task names exists
// (SRS-HKP-006).
//
// Without this, "the incident link is retained" is defeated by typing
// anything into the reference field, and the link the requirement exists to
// preserve is preserved in wording only. A deployment with no adapter records
// the reference unresolved and the status document says so, rather than this
// context pretending it checked.
type Incidents interface {
	Exists(ctx context.Context, scope authctx.TenantScope, ref string) (
		bool, error)
}

// Notice is something somebody has to be told about now.
type Notice struct {
	Kind       string
	Subject    string
	FacilityID string
	Summary    string
}

// Escalator raises a durable, acknowledged notice (SRS-HKP-005).
//
// Used for the one thing here that cannot wait for somebody to open a screen:
// an overdue clean in a theatre, a critical care bay or an isolation room.
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
