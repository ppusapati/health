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
