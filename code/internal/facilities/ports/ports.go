// Package ports declares what the facilities use cases need from the outside.
//
// Interfaces owned by this context rather than by whoever implements them, so
// the dependency arrow points inward (FIT-01).
//
// Four absences are deliberate and load-bearing.
//
// There is no method that edits or deletes a meter reading or a runtime
// reading. Both are the evidence behind decisions somebody will later be asked
// to justify — why the generator was serviced when it was, what the hospital
// consumed last quarter — and a series that can be rewritten agrees with
// whatever the last claim needed it to say.
//
// There is no method that closes a work order through an alarm, and none that
// clears an alarm through a work order. SRS-FAC-005 asks that the two
// lifecycles stay linked but distinct, and the guarantee is that there is no
// call that touches both states. The link itself is one directional write.
//
// There is no method that starts permit work without the permit. Start takes
// the references as arguments and there is no second door, so "an unsafe work
// class cannot proceed without its required fields" is a property of there
// being nowhere else to go rather than a check somebody remembered.
//
// And there is no way to ask for open critical deficiencies "since" a date.
// DeficiencyFilter has no time window at all, because SRS-FAC-008's acceptance
// is that they remain visible until closure and a window is how a hospital
// stops seeing the stairwell it never unblocked.
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/facilities/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
)

// ErrVersionConflict is a lost update: somebody else changed the record
// between the read and the write.
var ErrVersionConflict = errors.New("facilities: version conflict")

// AssetFilter narrows an asset list.
type AssetFilter struct {
	FacilityID string
	System     domain.System
	Status     domain.AssetStatus
	ParentID   string
	Limit      int32
}

// AssetRepository persists facilities plant (SRS-FAC-001).
//
// Every method takes authctx.TenantScope, which has no constructor outside
// the auth package, so reaching a row without a verified tenant does not
// compile (FIT-03).
type AssetRepository interface {
	InsertAsset(ctx context.Context, scope authctx.TenantScope,
		a domain.Asset) error
	Asset(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Asset, error)
	// AssetByTag is how somebody standing in front of a machine finds it.
	AssetByTag(ctx context.Context, scope authctx.TenantScope,
		tag string) (domain.Asset, error)
	UpdateAssetStatus(ctx context.Context, scope authctx.TenantScope,
		a domain.Asset, expectedVersion int64) error
	UpdateAssetRuntime(ctx context.Context, scope authctx.TenantScope,
		id string, hours int, at time.Time) error
	Assets(ctx context.Context, scope authctx.TenantScope, f AssetFilter) (
		[]domain.Asset, error)
}

// WorkClassRepository persists the configured classes of maintenance work
// (SRS-FAC-010).
type WorkClassRepository interface {
	UpsertWorkClass(ctx context.Context, scope authctx.TenantScope,
		c domain.WorkClass) error
	WorkClass(ctx context.Context, scope authctx.TenantScope, code string) (
		domain.WorkClass, error)
	WorkClasses(ctx context.Context, scope authctx.TenantScope) (
		[]domain.WorkClass, error)
}

// WorkOrderFilter narrows a work order list.
type WorkOrderFilter struct {
	FacilityID string
	AssetID    string
	System     domain.System
	State      domain.WorkState
	OpenOnly   bool
	From       time.Time
	To         time.Time
	Limit      int32
}

// WorkOrderRepository persists facilities work (SRS-FAC-002).
type WorkOrderRepository interface {
	InsertWorkOrder(ctx context.Context, scope authctx.TenantScope,
		w domain.WorkOrder) error
	WorkOrder(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.WorkOrder, error)
	UpdateWorkOrder(ctx context.Context, scope authctx.TenantScope,
		w domain.WorkOrder, expectedVersion int64) error
	WorkOrders(ctx context.Context, scope authctx.TenantScope,
		f WorkOrderFilter) ([]domain.WorkOrder, error)
}

// ScheduleFilter narrows a schedule list.
type ScheduleFilter struct {
	AssetID    string
	FacilityID string
	Kind       domain.MaintenanceKind
	ActiveOnly bool
	Limit      int32
}

// TaskFilter narrows a maintenance task list.
type TaskFilter struct {
	ScheduleID string
	AssetID    string
	FacilityID string
	State      domain.TaskState
	Kind       domain.MaintenanceKind
	Limit      int32
}

// MaintenanceRepository persists schedules and their occurrences
// (SRS-FAC-003, SRS-FAC-007).
type MaintenanceRepository interface {
	InsertSchedule(ctx context.Context, scope authctx.TenantScope,
		s domain.Schedule) error
	Schedule(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Schedule, error)
	// ScheduleProgress is where the clock and the counter stood when the
	// schedule was last satisfied, which is what NextDue measures from.
	ScheduleProgress(ctx context.Context, scope authctx.TenantScope,
		id string) (time.Time, int, error)
	SetScheduleDone(ctx context.Context, scope authctx.TenantScope,
		id string, at time.Time, hours int) error
	Schedules(ctx context.Context, scope authctx.TenantScope,
		f ScheduleFilter) ([]domain.Schedule, error)

	InsertTask(ctx context.Context, scope authctx.TenantScope,
		t domain.Task) error
	Task(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Task, error)
	UpdateTask(ctx context.Context, scope authctx.TenantScope,
		t domain.Task, expectedVersion int64) error
	Tasks(ctx context.Context, scope authctx.TenantScope, f TaskFilter) (
		[]domain.Task, error)
}

// RuntimeRepository persists hour-counter readings (SRS-FAC-007).
//
// Insert and read only. See the package comment.
type RuntimeRepository interface {
	InsertRuntimeReading(ctx context.Context, scope authctx.TenantScope,
		r domain.RuntimeReading) error
	// LatestRuntime is what a new reading is checked against for a
	// counter that went backwards. Absent rather than an error when there
	// is none: the first reading of a machine has nothing before it.
	LatestRuntime(ctx context.Context, scope authctx.TenantScope,
		assetID string) (domain.RuntimeReading, bool, error)
	RuntimeReadings(ctx context.Context, scope authctx.TenantScope,
		assetID string, from, to time.Time, limit int32) (
		[]domain.RuntimeReading, error)
}

// MeterFilter narrows a meter list.
type MeterFilter struct {
	FacilityID string
	Utility    domain.Utility
	ActiveOnly bool
	Limit      int32
}

// MeterRepository persists meters and their readings (SRS-FAC-009).
//
// Readings are insert and read only. See the package comment.
type MeterRepository interface {
	InsertMeter(ctx context.Context, scope authctx.TenantScope,
		m domain.Meter) error
	Meter(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Meter, error)
	Meters(ctx context.Context, scope authctx.TenantScope, f MeterFilter) (
		[]domain.Meter, error)

	InsertReading(ctx context.Context, scope authctx.TenantScope,
		r domain.Reading) error
	Readings(ctx context.Context, scope authctx.TenantScope,
		meterID string, from, to time.Time, limit int32) (
		[]domain.Reading, error)
}

// OutageFilter narrows a shutdown list.
type OutageFilter struct {
	FacilityID string
	System     domain.System
	LiveOnly   bool
	From       time.Time
	To         time.Time
	Limit      int32
}

// OutageRepository persists shutdown permits and the areas they reach
// (SRS-FAC-004).
type OutageRepository interface {
	InsertOutage(ctx context.Context, scope authctx.TenantScope,
		o domain.Outage) error
	Outage(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Outage, error)
	// UpdateOutage rewrites the outage's own row. The area rows follow it
	// through the database's composite key rather than through a second
	// write here, so an outage cannot be in effect while its areas still
	// say planned.
	UpdateOutage(ctx context.Context, scope authctx.TenantScope,
		o domain.Outage, expectedVersion int64) error
	Outages(ctx context.Context, scope authctx.TenantScope,
		f OutageFilter) ([]domain.Outage, error)

	InsertArea(ctx context.Context, scope authctx.TenantScope,
		a domain.OutageArea) error
	UpdateArea(ctx context.Context, scope authctx.TenantScope,
		a domain.OutageArea, expectedVersion int64) error
	Areas(ctx context.Context, scope authctx.TenantScope, outageID string) (
		[]domain.OutageArea, error)
}

// AlarmFilter narrows an alarm list.
type AlarmFilter struct {
	FacilityID string
	System     domain.System
	State      domain.AlarmState
	// UnansweredOnly is the list worth looking at: alarms the plant raised
	// and nobody acknowledged.
	UnansweredOnly bool
	From           time.Time
	To             time.Time
	Limit          int32
}

// AlarmRepository persists gateway alarms and the rules that route them
// (SRS-FAC-005).
type AlarmRepository interface {
	InsertAlarm(ctx context.Context, scope authctx.TenantScope,
		a domain.Alarm) error
	Alarm(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Alarm, error)
	// AlarmByEvent recognises a gateway replaying its buffer after a
	// network drop. Absent rather than an error when it is new.
	AlarmByEvent(ctx context.Context, scope authctx.TenantScope,
		gatewayID, externalID string) (domain.Alarm, bool, error)
	UpdateAlarm(ctx context.Context, scope authctx.TenantScope,
		a domain.Alarm, expectedVersion int64) error
	Alarms(ctx context.Context, scope authctx.TenantScope, f AlarmFilter) (
		[]domain.Alarm, error)

	InsertAlarmRule(ctx context.Context, scope authctx.TenantScope,
		id string, r domain.AlarmRule, by string, at time.Time) error
	AlarmRules(ctx context.Context, scope authctx.TenantScope,
		system domain.System) ([]domain.AlarmRule, error)
}

// DeficiencyFilter narrows a life-safety finding list.
//
// No time window, on purpose. See the package comment.
type DeficiencyFilter struct {
	FacilityID string
	TaskID     string
	Severity   domain.Severity
	OpenOnly   bool
	Limit      int32
}

// DeficiencyRepository persists fire and life-safety findings (SRS-FAC-008).
type DeficiencyRepository interface {
	InsertDeficiency(ctx context.Context, scope authctx.TenantScope,
		d domain.Deficiency) error
	Deficiency(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Deficiency, error)
	UpdateDeficiency(ctx context.Context, scope authctx.TenantScope,
		d domain.Deficiency, expectedVersion int64) error
	Deficiencies(ctx context.Context, scope authctx.TenantScope,
		f DeficiencyFilter) ([]domain.Deficiency, error)
}

// VisitFilter narrows a contractor visit list.
type VisitFilter struct {
	FacilityID  string
	WorkOrderID string
	AssetID     string
	OnSiteOnly  bool
	Limit       int32
}

// VisitRepository persists contractor attendances (SRS-FAC-011).
type VisitRepository interface {
	InsertVisit(ctx context.Context, scope authctx.TenantScope,
		v domain.Visit) error
	Visit(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Visit, error)
	UpdateVisit(ctx context.Context, scope authctx.TenantScope,
		v domain.Visit, expectedVersion int64) error
	Visits(ctx context.Context, scope authctx.TenantScope, f VisitFilter) (
		[]domain.Visit, error)
}

// OrgUnits is the read this context needs from the organization context
// (SRS-FAC-001, SRS-FAC-004).
//
// An asset's location and a shutdown's affected departments are org units, and
// this is what says they are real. Read-only: facilities cannot create a
// department by mistyping one into a work order.
type OrgUnits interface {
	// Exists reports whether the unit is one this tenant has. An error
	// other than absence is returned rather than swallowed: a directory
	// that is down must not read as a directory that says no.
	Exists(ctx context.Context, scope authctx.TenantScope,
		orgUnitID string) (bool, error)
}

// Notice is something somebody has to be told about now.
type Notice struct {
	Kind       string
	Subject    string
	FacilityID string
	Summary    string
	// Level is the rung to start on. Zero is the ordinary case;
	// SRS-FAC-006 is the reason this field exists at all.
	Level int
}

// Escalator raises a durable, acknowledged notice (SRS-FAC-006, SRS-FAC-008).
//
// Used where a rule is broken in a way a report would not catch in time: a
// critical medical gas failure, and a critical life-safety deficiency that
// has gone past the date somebody promised to fix it by.
type Escalator interface {
	Raise(ctx context.Context, scope authctx.TenantScope, n Notice,
		at time.Time) (string, error)
	// Top is the highest rung the tenant has configured for a kind of
	// notice. SRS-FAC-006's acceptance is the *highest configured*
	// escalation, so the number comes from the matrix rather than from a
	// constant in this context.
	Top(ctx context.Context, scope authctx.TenantScope,
		kind, facilityID string) (int, error)
}

// EventAppender publishes domain events through the outbox.
type EventAppender interface {
	Append(ctx context.Context, e outbox.Event) error
}

// AuditAppender writes the append-only audit trail.
type AuditAppender interface {
	Append(ctx context.Context, r audit.Record) error
}

// UnitOfWork runs a use case in one transaction. The outbox requires an open
// transaction (ADR-0004).
type UnitOfWork interface {
	WithinTx(ctx context.Context, fn func(context.Context) error) error
}

// IDGenerator mints identifiers.
type IDGenerator interface{ NewID() string }

// Clock reads the time.
type Clock interface{ Now() time.Time }
