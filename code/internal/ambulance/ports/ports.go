// Package ports declares what the ambulance use cases need from the outside.
//
// Interfaces owned by this context rather than by whoever implements them, so
// the dependency arrow points inward (FIT-01).
//
// Three absences are deliberate and load-bearing.
//
// There is no method that edits a milestone in place. A timeline somebody can
// rewrite is one nobody can audit, and the response time a service reports is
// only worth reading because nobody can move the arrival time afterwards. A
// correction is AmendMilestone, which appends.
//
// There is no method that changes a readiness check's outcomes after it was
// recorded. A service that could turn a failed check into a passed one would
// have no way of noticing that one vehicle fails its oxygen check every week.
// An override is its own act, by its own person, with its own reason.
//
// And there is no method that reads a location ping without an as-of moment.
// Every read is bounded by the horizon the ping was recorded with, so a trail
// cannot come back because a purge job is behind.
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/ambulance/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
)

// ErrVersionConflict is a lost update: somebody else changed the record
// between the read and the write.
var ErrVersionConflict = errors.New("ambulance: version conflict")

// VehicleFilter narrows a fleet list.
type VehicleFilter struct {
	States     []domain.VehicleState
	Kinds      []domain.VehicleKind
	FacilityID string
	Limit      int32
	Offset     int32
}

// VehicleRepository persists the fleet (SRS-AMB-002).
//
// Every method takes authctx.TenantScope, which has no constructor outside
// the auth package, so reaching a row without a verified tenant does not
// compile (FIT-03).
type VehicleRepository interface {
	InsertVehicle(ctx context.Context, scope authctx.TenantScope,
		v domain.Vehicle) error
	Vehicle(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Vehicle, error)
	UpdateVehicle(ctx context.Context, scope authctx.TenantScope,
		v domain.Vehicle, expectedVersion int64) error
	Vehicles(ctx context.Context, scope authctx.TenantScope,
		f VehicleFilter) ([]domain.Vehicle, error)
}

// ShiftFilter narrows a roster list.
type ShiftFilter struct {
	VehicleID  string
	FacilityID string
	States     []domain.ShiftState
	From       time.Time
	To         time.Time
	Limit      int32
	Offset     int32
}

// ShiftRepository persists crew rosters (SRS-AMB-002).
type ShiftRepository interface {
	InsertShift(ctx context.Context, scope authctx.TenantScope,
		s domain.Shift) error
	Shift(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Shift, error)
	UpdateShift(ctx context.Context, scope authctx.TenantScope,
		s domain.Shift, expectedVersion int64) error
	Shifts(ctx context.Context, scope authctx.TenantScope, f ShiftFilter) (
		[]domain.Shift, error)
}

// CheckFilter narrows a readiness list.
type CheckFilter struct {
	VehicleID  string
	FacilityID string
	States     []domain.CheckState
	From       time.Time
	To         time.Time
	Limit      int32
	Offset     int32
}

// ReadinessRepository persists vehicle readiness checks (SRS-AMB-006).
//
// UpdateOverride is the only write that touches a recorded check, and it
// changes the override columns alone.
type ReadinessRepository interface {
	InsertCheck(ctx context.Context, scope authctx.TenantScope,
		c domain.ReadinessCheck) error
	Check(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.ReadinessCheck, error)
	// LatestCheck is what a dispatch screen reads to show whether a vehicle
	// is in date.
	LatestCheck(ctx context.Context, scope authctx.TenantScope,
		vehicleID string) (domain.ReadinessCheck, error)
	UpdateOverride(ctx context.Context, scope authctx.TenantScope,
		c domain.ReadinessCheck, expectedVersion int64) error
	Checks(ctx context.Context, scope authctx.TenantScope, f CheckFilter) (
		[]domain.ReadinessCheck, error)
}

// RequestFilter narrows a call list.
type RequestFilter struct {
	States     []domain.RequestState
	Priorities []domain.Priority
	Kinds      []domain.RequestKind
	FacilityID string
	PatientID  string
	From       time.Time
	To         time.Time
	Limit      int32
	Offset     int32
}

// RequestRepository persists ambulance requests (SRS-AMB-001).
type RequestRepository interface {
	InsertRequest(ctx context.Context, scope authctx.TenantScope,
		r domain.Request) error
	Request(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Request, error)
	UpdateRequest(ctx context.Context, scope authctx.TenantScope,
		r domain.Request, expectedVersion int64) error
	Requests(ctx context.Context, scope authctx.TenantScope,
		f RequestFilter) ([]domain.Request, error)
}

// TripFilter narrows a trip list.
type TripFilter struct {
	States     []domain.TripState
	VehicleID  string
	FacilityID string
	From       time.Time
	To         time.Time
	Limit      int32
	Offset     int32
}

// TripRepository persists trips and their timelines (SRS-AMB-003).
//
// AppendMilestone takes one record and inserts it. There is no method that
// replaces one: a correction is a further record carrying AmendsAt, and the
// table takes no UPDATE and no DELETE (FIT-08).
type TripRepository interface {
	InsertTrip(ctx context.Context, scope authctx.TenantScope,
		t domain.Trip) error
	Trip(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Trip, error)
	TripForRequest(ctx context.Context, scope authctx.TenantScope,
		requestID string) (domain.Trip, error)
	UpdateTrip(ctx context.Context, scope authctx.TenantScope,
		t domain.Trip, expectedVersion int64) error
	AppendMilestone(ctx context.Context, scope authctx.TenantScope,
		id, tripID string, record domain.MilestoneRecord) error
	Trips(ctx context.Context, scope authctx.TenantScope, f TripFilter) (
		[]domain.Trip, error)
}

// RecordFilter narrows a prehospital record list.
type RecordFilter struct {
	States     []domain.HandoverState
	FacilityID string
	PatientID  string
	From       time.Time
	To         time.Time
	Limit      int32
	Offset     int32
}

// PrehospitalRepository persists the crew's account of a journey
// (SRS-AMB-004, SRS-AMB-007).
type PrehospitalRepository interface {
	InsertRecord(ctx context.Context, scope authctx.TenantScope,
		r domain.PrehospitalRecord) error
	Record(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.PrehospitalRecord, error)
	RecordForTrip(ctx context.Context, scope authctx.TenantScope,
		tripID string) (domain.PrehospitalRecord, error)
	UpdateRecord(ctx context.Context, scope authctx.TenantScope,
		r domain.PrehospitalRecord, expectedVersion int64) error
	AppendEntry(ctx context.Context, scope authctx.TenantScope,
		recordID string, e domain.Entry) error
	AttachDocument(ctx context.Context, scope authctx.TenantScope,
		recordID, documentRef string, at time.Time) error
	Records(ctx context.Context, scope authctx.TenantScope, f RecordFilter) (
		[]domain.PrehospitalRecord, error)
}

// PingFilter narrows a location feed read.
//
// AsOf is not optional. Every read is bounded by the horizon each ping was
// recorded with, so the feed a caller gets back is the feed the deployment
// said it keeps.
type PingFilter struct {
	VehicleID string
	TripID    string
	From      time.Time
	To        time.Time
	AsOf      time.Time
	Limit     int32
}

// LocationRepository persists the vehicle location feed (SRS-AMB-005).
type LocationRepository interface {
	InsertPing(ctx context.Context, scope authctx.TenantScope,
		p domain.Ping) error
	Pings(ctx context.Context, scope authctx.TenantScope, f PingFilter) (
		[]domain.Ping, error)
	LatestPing(ctx context.Context, scope authctx.TenantScope,
		vehicleID string, asOf time.Time) (domain.Ping, error)
	// PurgeExpired removes what the horizon has passed. The reads do not
	// depend on it having run, which is what makes it safe to run on a
	// schedule rather than in the request path.
	PurgeExpired(ctx context.Context, scope authctx.TenantScope,
		asOf time.Time) (int64, error)
	InsertETA(ctx context.Context, scope authctx.TenantScope,
		id string, e domain.ETA) error
	LatestETA(ctx context.Context, scope authctx.TenantScope,
		tripID string) (domain.ETA, error)
}

// Encounters is the read this context needs from the encounter context
// (SRS-AMB-004).
//
// A handover attaches the crew's account to an emergency encounter. Nothing
// here creates or changes one: a read-only seam, so the ambulance context
// cannot become a second place encounters are made.
type Encounters interface {
	// Exists reports whether the encounter is one this tenant has. An error
	// other than absence is returned rather than swallowed: a directory that
	// is down must not read as a directory that says no.
	Exists(ctx context.Context, scope authctx.TenantScope,
		encounterID string) (bool, error)
}

// Patients is the read this context needs from the patient index
// (SRS-AMB-001).
type Patients interface {
	Exists(ctx context.Context, scope authctx.TenantScope,
		patientID string) (bool, error)
}

// Units is the read this context needs from the organization context
// (SRS-AMB-001, SRS-AMB-007).
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

// Escalator raises a durable, acknowledged notice (SRS-AMB-002,
// SRS-AMB-004).
//
// Used where a rule is broken in a way a report would not catch in time: a
// dispatch made under override, and a handover nobody has accepted while the
// crew is still standing in the corridor.
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

// UnitOfWork runs a use case in one transaction. The outbox requires an open
// transaction (ADR-0004).
type UnitOfWork interface {
	WithinTx(ctx context.Context, fn func(context.Context) error) error
}

// IDGenerator mints identifiers.
type IDGenerator interface{ NewID() string }

// Clock reads the time.
type Clock interface{ Now() time.Time }
