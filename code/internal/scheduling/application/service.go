// Package application holds the scheduling use cases.
package application

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/scheduling/domain"
	"github.com/ppusapati/health/code/internal/scheduling/ports"
)

// Permissions (SRS-SCH, Wave-1 backlog "sch.*").
const (
	// PermScheduleConfigure defines rosters, resources and exceptions.
	PermScheduleConfigure = "sch.schedule.configure"
	// PermScheduleRead searches slots and reads diaries.
	PermScheduleRead = "sch.schedule.read"
	// PermAppointmentBook books, reschedules and cancels.
	//
	// Distinct from PermScheduleConfigure. The Wave-1 backlog lists SRS-SCH-004
	// under "sch.configure", which would mean that booking an appointment
	// required the authority to rewrite the clinic's roster — so every
	// receptionist would hold it, and the roster would be editable by the whole
	// front desk. Read as a transcription slip, the same shape as SRS-EMPI-005
	// appearing under "empi.read"; recorded in the Wave-1 status document.
	PermAppointmentBook = "sch.appointment.book"
	// PermAppointmentManage drives the queue: check-in, triage, completion.
	PermAppointmentManage = "sch.appointment.manage"
	// PermScheduleOverride books into a blocked period (SRS-SCH-002).
	PermScheduleOverride = "sch.schedule.override"
	// PermAppointmentCorrect makes a status change the machine would otherwise
	// refuse, under the "unless authorized correction" clause of SRS-SCH-008.
	PermAppointmentCorrect = "sch.appointment.correct"
)

// Events (SRS-SCH-016).
//
// The requirement names five and asks for them to be "idempotent/versioned".
// Idempotency comes from the outbox: each carries an event id and downstream
// consumers deduplicate on it (SRS-PLT-006). Versioning is the schema version
// the envelope already carries.
const (
	EventAppointmentBooked      = "appointment.booked"
	EventAppointmentRescheduled = "appointment.rescheduled"
	EventAppointmentCancelled   = "appointment.cancelled"
	EventAppointmentCheckedIn   = "appointment.checked_in"
	EventAppointmentNoShow      = "appointment.no_show"
	// EventAppointmentStatusChanged carries the rest of the queue transitions.
	// Not in the requirement's list, and emitted because a queue display that
	// had to poll would be a queue display that is wrong.
	EventAppointmentStatusChanged = "appointment.status_changed"
	// EventAppointmentReprioritised carries a move in the queue (SRS-SCH-011).
	// Separate from a status change because it reorders a board without
	// changing anybody's state, and a display that treated the two alike would
	// redraw the wrong rows.
	EventAppointmentReprioritised = "appointment.reprioritised"
)

const (
	eventSchemaVersion = 1
	eventSource        = "scheduling"
)

// Service is the scheduling use-case façade.
type Service struct {
	uow           ports.UnitOfWork
	resources     ports.ResourceRepository
	schedules     ports.ScheduleRepository
	slots         ports.SlotRepository
	appointments  ports.AppointmentRepository
	policies      ports.PolicyRepository
	series        ports.SeriesRepository
	waitlist      ports.WaitlistRepository
	queue         ports.QueueRepository
	notifications ports.NotificationRepository
	contacts      ports.PatientContact
	calendar      ports.FacilityCalendar
	patients      ports.PatientDirectory
	meetings      ports.MeetingProvider
	events        ports.EventAppender
	audits        ports.AuditAppender
	ids           ports.IDGenerator
	clock         ports.Clock
}

// Deps are the collaborators the service needs.
type Deps struct {
	UnitOfWork   ports.UnitOfWork
	Resources    ports.ResourceRepository
	Schedules    ports.ScheduleRepository
	Slots        ports.SlotRepository
	Appointments ports.AppointmentRepository
	Policies     ports.PolicyRepository
	Series       ports.SeriesRepository
	Waitlist     ports.WaitlistRepository
	Queue        ports.QueueRepository
	// Notifications records what was sent and what came back (SRS-SCH-012).
	// Nil records nothing: a deployment whose messages go out through some
	// other system should not accumulate a half-kept delivery log that reads as
	// authoritative.
	Notifications ports.NotificationRepository
	// Contacts answers how a patient agreed to be reached. Nil denies: an
	// unrecorded consent is a refusal, so every message is suppressed and the
	// suppression is visible.
	Contacts ports.PatientContact
	Calendar ports.FacilityCalendar
	Patients ports.PatientDirectory
	// Meetings mints teleconsult join links. Nil is a valid deployment: a
	// hospital that runs no video service books teleconsults with no link, and
	// the absence is visible rather than a broken URL.
	Meetings ports.MeetingProvider
	Events   ports.EventAppender
	Audits   ports.AuditAppender
	IDs      ports.IDGenerator
	Clock    ports.Clock
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, resources: d.Resources, schedules: d.Schedules,
		slots: d.Slots, appointments: d.Appointments,
		policies: d.Policies, series: d.Series, waitlist: d.Waitlist,
		queue: d.Queue, notifications: d.Notifications, contacts: d.Contacts,
		calendar: d.Calendar, patients: d.Patients, meetings: d.Meetings,
		events: d.Events, audits: d.Audits, ids: d.IDs, clock: d.Clock,
	}
}

// Limits on what one request may ask for.
const (
	// DefaultPageSize for a slot search or a clinic list.
	DefaultPageSize = 50
	// MaxPageSize caps a listing regardless of what the client asks for.
	MaxPageSize = 200
	// maxSearchResources bounds how many diaries one search expands. A search
	// across every clinician in a hospital is a report, not a booking screen.
	maxSearchResources = 50
)

func clampPageSize(requested int32) int32 {
	switch {
	case requested <= 0:
		return DefaultPageSize
	case requested > MaxPageSize:
		return MaxPageSize
	default:
		return requested
	}
}

// appendEvent writes to the transactional outbox.
func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateID string, payload json.RawMessage, now time.Time) error {

	return s.events.Append(ctx, outbox.Event{
		EventID:       s.ids.NewID(),
		EventType:     eventType,
		SchemaVersion: eventSchemaVersion,
		OccurredAt:    now.UTC(),
		TenantID:      session.TenantID,
		Source:        eventSource,
		AggregateType: "appointment",
		AggregateID:   aggregateID,
		CorrelationID: session.CorrelationID,
		CausationID:   session.RequestID,
		Actor:         session.SubjectID,
		Payload:       payload,
	})
}

func (s *Service) appendAudit(ctx context.Context, session authctx.Session,
	r audit.Record, now time.Time) error {

	r.AuditID = s.ids.NewID()
	r.ActorID = session.SubjectID
	r.CorrelationID = session.CorrelationID
	r.RequestID = session.RequestID
	r.PurposeOfUse = string(session.Purpose)
	r.BreakGlass = session.BreakGlass
	r.OccurredAt = now.UTC()
	if r.TenantID == "" {
		r.TenantID = session.TenantID
	}
	return s.audits.Append(ctx, r)
}

func (s *Service) auditDenied(ctx context.Context, session authctx.Session,
	action, resourceType, resourceID, reason string) {

	// Best effort: a denial that cannot be recorded must not turn into a
	// different error for the caller, who is being refused either way.
	_ = s.appendAudit(ctx, session, audit.Record{
		TenantID: session.TenantID, Action: action,
		ResourceType: resourceType, ResourceID: resourceID,
		Outcome: audit.OutcomeDenied, Reason: reason,
	}, s.clock.Now())
}

// scheduleError maps a domain refusal onto the wire contract.
func scheduleError(err error) error {
	var notBookable domain.ErrNotBookable
	if errors.As(err, &notBookable) {
		// SRS-SCH-014 asks for a domain-specific unavailability error: a client
		// that cannot tell "this clinician has left" from "the server is busy"
		// retries the first forever.
		return rpcerr.FailedPrecondition("SCH_NOT_BOOKABLE", notBookable.Error())
	}

	var invalidTransition domain.ErrInvalidTransition
	if errors.As(err, &invalidTransition) {
		return rpcerr.FailedPrecondition("SCH_INVALID_TRANSITION", invalidTransition.Error())
	}

	switch {
	case errors.Is(err, domain.ErrInvalidResource):
		return rpcerr.Invalid("SCH_RESOURCE_INVALID", err.Error())
	case errors.Is(err, domain.ErrInvalidSchedule):
		return rpcerr.Invalid("SCH_SCHEDULE_INVALID", err.Error())
	case errors.Is(err, domain.ErrInvalidAppointment):
		return rpcerr.Invalid("SCH_APPOINTMENT_INVALID", err.Error())
	}
	return err
}

// mapConflict turns a repository version conflict into the wire contract.
func mapConflict(err error) error {
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("SCH_VERSION_CONFLICT",
			"the appointment changed since it was read")
	}
	if errors.Is(err, ports.ErrSlotFull) {
		return rpcerr.FailedPrecondition("SCH_SLOT_FULL",
			"that slot was taken while this booking was being made")
	}
	return err
}
