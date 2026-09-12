// Package ports declares what the scheduling application layer needs.
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
	"github.com/ppusapati/health/code/internal/scheduling/domain"
)

// ErrVersionConflict reports that another writer advanced the record first.
var ErrVersionConflict = errors.New("scheduling: appointment changed concurrently")

// ErrSlotFull reports that a slot's capacity was already taken.
//
// Returned by ClaimCapacity when the guarded statement matches no row, which is
// the only reliable signal: a count read beforehand is stale by the time the
// insert runs (SRS-SCH-004).
var ErrSlotFull = errors.New("scheduling: the slot is fully booked")

// ResourceRepository persists bookable resources.
//
// Every method takes authctx.TenantScope, which has no constructor outside the
// auth package, so reaching a row without a verified tenant does not compile
// (FIT-03).
type ResourceRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope, r domain.Resource) error
	Get(ctx context.Context, scope authctx.TenantScope, resourceID string) (domain.Resource, error)
	SetStatus(ctx context.Context, scope authctx.TenantScope,
		resourceID string, status domain.ResourceStatus, at time.Time) error
	// ForSearch returns the active resources a slot search generates from.
	// Inactive ones are excluded here rather than filtered later, so an
	// out-of-service resource's slots never exist (SRS-SCH-014).
	ForSearch(ctx context.Context, scope authctx.TenantScope, q ResourceQuery) ([]domain.Resource, error)
}

// ResourceQuery narrows the resources a search considers.
type ResourceQuery struct {
	FacilityID string
	OrgUnitID  string
	ResourceID string
	Limit      int32
}

// ScheduleRepository persists rosters and their exceptions.
type ScheduleRepository interface {
	InsertSchedule(ctx context.Context, scope authctx.TenantScope, s domain.Schedule) error
	// SchedulesFor returns every rule that could be in force for these
	// resources over a local date range.
	SchedulesFor(ctx context.Context, scope authctx.TenantScope, resourceIDs []string,
		visitType domain.VisitType, from, until time.Time) ([]domain.Schedule, error)
	// EndSchedule closes a rule that has already taken effect. Rosters that
	// have generated bookings are ended, not deleted: the appointments they
	// produced are still real.
	EndSchedule(ctx context.Context, scope authctx.TenantScope,
		scheduleID string, until time.Time, at time.Time) error
	// DeleteSchedule removes a rule that never took effect.
	DeleteSchedule(ctx context.Context, scope authctx.TenantScope,
		scheduleID string, today time.Time) error

	InsertException(ctx context.Context, scope authctx.TenantScope, e domain.Exception) error
	ExceptionsFor(ctx context.Context, scope authctx.TenantScope, resourceIDs []string,
		from, until time.Time) ([]domain.Exception, error)
	DeleteException(ctx context.Context, scope authctx.TenantScope, exceptionID string) error
}

// SlotRepository owns consumed capacity.
type SlotRepository interface {
	// ClaimCapacity materialises the slot if needed and takes one unit,
	// atomically. Returns ErrSlotFull when there is none.
	//
	// One method rather than an ensure and a claim, because the two must
	// happen in one call for the guarantee to mean anything: a caller that
	// could interleave them would have written the race back in.
	ClaimCapacity(ctx context.Context, scope authctx.TenantScope, slot domain.Slot,
		slotID string, at time.Time) (string, error)
	// ReleaseCapacity gives one unit back on cancellation.
	ReleaseCapacity(ctx context.Context, scope authctx.TenantScope, slotID string, at time.Time) error
	// BookedCounts reports consumed capacity across a window, for the search.
	BookedCounts(ctx context.Context, scope authctx.TenantScope, resourceIDs []string,
		from, until time.Time) (map[domain.SlotKey]int, error)
}

// AppointmentRepository persists bookings and their status history.
type AppointmentRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope, a *domain.Appointment) error
	Get(ctx context.Context, scope authctx.TenantScope, appointmentID string) (*domain.Appointment, error)
	// SetStatus writes the new status under optimistic concurrency and appends
	// the history entry. Returns ErrVersionConflict when another writer got
	// there first.
	SetStatus(ctx context.Context, scope authctx.TenantScope, a *domain.Appointment,
		change domain.StatusChange, expectedVersion int64) error
	ForPatient(ctx context.Context, scope authctx.TenantScope,
		patientID string, limit int32) ([]*domain.Appointment, error)
	ForDay(ctx context.Context, scope authctx.TenantScope, facilityID, resourceID string,
		from, until time.Time, limit int32) ([]*domain.Appointment, error)
	History(ctx context.Context, scope authctx.TenantScope,
		appointmentID string) ([]domain.StatusChange, error)
}

// FacilityCalendar answers whether a facility is open on a local date
// (SRS-PLT-016).
//
// A port onto the organization context rather than a shared table: whether the
// hospital is shut on 2 October is that context's fact, and a scheduling copy
// of it would be a second answer that drifts.
type FacilityCalendar interface {
	// ClosedDates returns the local dates a facility is closed, as
	// "2006-01-02" keys, so slot generation can test membership without
	// re-deriving a calendar.
	ClosedDates(ctx context.Context, scope authctx.TenantScope,
		facilityID string, from, until time.Time) (map[string]bool, error)
	// Active reports whether the facility itself can be booked at all
	// (SRS-SCH-014).
	Active(ctx context.Context, scope authctx.TenantScope, facilityID string) (bool, error)
}

// PatientDirectory answers what scheduling needs to know about a patient.
//
// Deliberately narrow. Scheduling does not read demographics: it needs to know
// the patient exists, that they are in this tenant, and whether they may be
// given a routine appointment — the factual half SRS-EMPI-008 leaves to the
// identity context. Widening this port would put patient data in a diary far
// more people can see.
type PatientDirectory interface {
	// AcceptsRoutineScheduling reports whether a routine appointment may be
	// booked. False for a patient recorded as deceased. Returns a not-found
	// error when the patient is not in this tenant.
	AcceptsRoutineScheduling(ctx context.Context, scope authctx.TenantScope,
		patientID string) (bool, error)
	// IdentityConfirmed reports whether the patient's identity has been
	// positively established (SRS-EMPI-010). A facility may insist a first
	// teleconsult waits for that, because identifying somebody over video is
	// materially harder than at a desk.
	IdentityConfirmed(ctx context.Context, scope authctx.TenantScope,
		patientID string) (bool, error)
}

// UnitOfWork runs work in one transaction.
type UnitOfWork interface {
	WithinTx(ctx context.Context, fn func(ctx context.Context) error) error
}

// EventAppender writes to the transactional outbox.
type EventAppender interface {
	Append(ctx context.Context, e outbox.Event) error
}

// AuditAppender writes the append-only audit trail.
type AuditAppender interface {
	Append(ctx context.Context, r audit.Record) error
}

// IDGenerator mints identifiers.
type IDGenerator interface{ NewID() string }

// Clock reads the current time.
type Clock interface{ Now() time.Time }

// PolicyRepository reads and writes the cancellation and teleconsult rules
// (SRS-SCH-005, SRS-SCH-015).
type PolicyRepository interface {
	// Resolve returns the policy in force, facility-specific first and
	// tenant-wide second, falling back to the domain defaults when a tenant
	// has configured nothing.
	//
	// Returns all three of a facility's scheduling rules together. One call
	// rather than three, because they live on one row and a caller that read
	// them separately could act on a cancellation rule from before an edit and
	// a notification rule from after it.
	Resolve(ctx context.Context, scope authctx.TenantScope, facilityID string) (
		domain.SchedulingPolicy, error)
	Set(ctx context.Context, scope authctx.TenantScope, facilityID string,
		p domain.SchedulingPolicy, now time.Time) error
	// RecordOutcome captures what the policy made of a cancellation or a
	// reschedule, at the moment of the decision. Append-only: the record a
	// disputed fee turns on is the one written at the time.
	RecordOutcome(ctx context.Context, scope authctx.TenantScope, appointmentID,
		kind string, outcome domain.CancellationOutcome, by, reason string, at time.Time) error
	Outcomes(ctx context.Context, scope authctx.TenantScope, appointmentID string) (
		[]PolicyOutcome, error)
}

// PolicyOutcome is a stored decision.
type PolicyOutcome struct {
	Kind      string
	Outcome   domain.CancellationOutcome
	DecidedBy string
	DecidedAt time.Time
	Reason    string
}

// SeriesRepository persists recurring courses (SRS-SCH-013).
type SeriesRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope, s domain.Series) error
	Get(ctx context.Context, scope authctx.TenantScope, seriesID string) (domain.Series, error)
	// Appointments returns every occurrence in order, so a bulk change can
	// walk them.
	Appointments(ctx context.Context, scope authctx.TenantScope,
		seriesID string) ([]*domain.Appointment, error)
	Cancel(ctx context.Context, scope authctx.TenantScope, seriesID string) error
}

// WaitlistRepository persists patients waiting for an earlier slot
// (SRS-SCH-006).
type WaitlistRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope, w domain.WaitlistEntry) error
	Get(ctx context.Context, scope authctx.TenantScope, waitlistID string) (domain.WaitlistEntry, error)
	// Open returns the list a scheduler works when a slot frees up, oldest
	// first — the only ordering anybody can defend at the desk.
	Open(ctx context.Context, scope authctx.TenantScope, resourceID string,
		limit int32) ([]domain.WaitlistEntry, error)
	// Update writes the entry back, guarded on the status the caller read.
	// Returns ErrVersionConflict when another scheduler acted first.
	Update(ctx context.Context, scope authctx.TenantScope, w domain.WaitlistEntry,
		expected domain.WaitlistStatus) error
	// ExpireStale returns unanswered offers to the waiting list.
	ExpireStale(ctx context.Context, scope authctx.TenantScope, now time.Time) (int64, error)
}

// RescheduleRecorder carries a reschedule count forward across a chain.
type RescheduleRecorder interface {
	SetRescheduleCount(ctx context.Context, scope authctx.TenantScope,
		appointmentID string, count int, expectedVersion int64, at time.Time) error
}

// MeetingProvider mints the link a teleconsult happens on (SRS-SCH-015).
//
// A port because which video service a hospital uses is a procurement decision
// that changes, and because the link is a credential: anybody holding it can
// join a consultation. Keeping minting behind an interface means the production
// adapter can issue a short-lived, per-appointment token without the scheduling
// context knowing how.
type MeetingProvider interface {
	// NewMeeting returns the join link for one appointment.
	NewMeeting(ctx context.Context, scope authctx.TenantScope,
		appointmentID string, startsAt, endsAt time.Time) (string, error)
	// EndMeeting revokes a link when the appointment is cancelled, so a
	// cancelled consultation does not leave a door open.
	EndMeeting(ctx context.Context, scope authctx.TenantScope, appointmentID string) error
}

// QueueRepository serves check-in and the queue (SRS-SCH-007 … SRS-SCH-011).
type QueueRepository interface {
	SetCheckIn(ctx context.Context, scope authctx.TenantScope, a *domain.Appointment,
		change domain.StatusChange, expectedVersion int64) error
	SetPriority(ctx context.Context, scope authctx.TenantScope, a *domain.Appointment,
		expectedVersion int64) error
	// Queue returns everyone checked in at a facility over a window, in arrival
	// order. The priority ordering is applied in the domain, so the queue a
	// board renders and the queue a test asserts are built by the same code.
	Queue(ctx context.Context, scope authctx.TenantScope, facilityID, resourceID string,
		from, until time.Time, limit int32) ([]*domain.Appointment, error)
	// NextQueueNumber issues the next number for a facility on a local date.
	//
	// A sequence rather than a random string, because "queue number" is what
	// SRS-SCH-007 asks for and what a waiting room understands: 014 comes after
	// 013, and a board showing "K7QX" tells nobody how long they have left.
	NextQueueNumber(ctx context.Context, scope authctx.TenantScope,
		facilityID string, day time.Time, at time.Time) (int, error)
}

// NotificationRepository records what was sent and what came back
// (SRS-SCH-012).
type NotificationRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope, n domain.Notification) error
	Get(ctx context.Context, scope authctx.TenantScope, notificationID string) (
		domain.Notification, error)
	Resolve(ctx context.Context, scope authctx.TenantScope, n domain.Notification) error
	ForSubject(ctx context.Context, scope authctx.TenantScope,
		subject domain.NotificationSubject) ([]domain.Notification, error)
	Pending(ctx context.Context, scope authctx.TenantScope, now time.Time, limit int32) (
		[]domain.Notification, error)
}

// PatientContact answers how a patient has agreed to be contacted.
//
// A port onto the patient index, because SRS-EMPI-013 holds communication
// preference per channel *and* per purpose and this context must not hold a
// second copy that drifts. Narrow on purpose: scheduling asks whether it may
// send this kind of message and by what channel, and receives an answer — not
// the patient's contact details, which belong to a record far fewer people can
// see.
type PatientContact interface {
	// PreferredChannel returns the channel this patient has agreed to for
	// appointment messages, and false when they have agreed to none. Deny by
	// default: SRS-EMPI-013 records consent per purpose, and an unrecorded
	// combination is a refusal rather than a permission.
	PreferredChannel(ctx context.Context, scope authctx.TenantScope, patientID string) (
		string, bool, error)
}
