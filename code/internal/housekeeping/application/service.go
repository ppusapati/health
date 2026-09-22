// Package application holds the housekeeping and environmental services use
// cases (SRS-HKP-001 … 008).
package application

import (
	"context"
	"encoding/json"
	"errors"
	"strconv"
	"time"

	"github.com/ppusapati/health/code/internal/housekeeping/domain"
	"github.com/ppusapati/health/code/internal/housekeeping/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Permissions.
//
// Three stand apart from the rest because of what they make possible.
// PermVerify signs off somebody else's clean, PermOverrideHold puts a bed
// back into service without one, and PermSpillRead reads the detail of a
// biohazard task — which is often about a patient.
const (
	// PermRead reads the worklist, the locations and one task. Held widely:
	// a ward clerk asking whether the bed is clean needs it.
	PermRead = "hkp.read"
	// PermSpillRead reads a restricted task's detail (SRS-HKP-006). Its own
	// permission, because "blood, bay 3, 14:20" on the general worklist is a
	// clinical fact about whoever was in bay 3.
	PermSpillRead = "hkp.spill.read"
	// PermLocationManage configures a cleanable location's standard
	// (SRS-HKP-001).
	PermLocationManage = "hkp.location.manage"
	// PermLocationApprove puts a standard in force. Separate from writing
	// one, because a cleaning standard decides how often a theatre is
	// cleaned and what counts as cleaning it. The domain also refuses the
	// author, so holding both permissions is still not enough to approve
	// your own.
	PermLocationApprove = "hkp.location.approve"
	// PermTaskRaise raises cleaning work (SRS-HKP-002, SRS-HKP-006).
	PermTaskRaise = "hkp.task.raise"
	// PermTaskWork assigns, starts, completes, cancels and scans
	// (SRS-HKP-004, SRS-HKP-007). The cleaner's permission.
	PermTaskWork = "hkp.task.work"
	// PermVerify records a supervisor checking the work (SRS-HKP-004).
	// Separate from doing it: a clean signed off by the cleaner is the same
	// claim made twice.
	PermVerify = "hkp.task.verify"
	// PermHoldBed takes a bed out of service pending its terminal clean
	// (SRS-HKP-003).
	PermHoldBed = "hkp.bed.hold"
	// PermOverrideHold puts a bed back into service without the clean
	// finishing. Its own permission and every use audited: this is somebody
	// deciding a patient goes into an uncleaned bed, and it is the decision
	// an investigation reads first.
	PermOverrideHold = "hkp.bed.override"
	// PermReportRead reads the SLA, turnaround and audit-compliance reports
	// (SRS-HKP-008).
	PermReportRead = "hkp.report.read"
)

// Events.
//
// Identifiers, codes and counts. No spill detail, no patient, no encounter: an
// event stream is read by more systems and under fewer controls than the
// record it describes (SRS-API-009).
const (
	EventTaskRaised    = "cleaning_task.raised"
	EventTaskCompleted = "cleaning_task.completed"
	EventTaskVerified  = "cleaning_task.verified"
	EventBedHeld       = "bed_hold.placed"
	EventBedReleased   = "bed_hold.released"
	EventBedOverridden = "bed_hold.overridden"
)

// The escalations this context raises.
const (
	// EscalationOverdue is an overdue clean in a critical area
	// (SRS-HKP-005). Theatres, critical care, isolation rooms: the places
	// where a clean nobody did is a clean somebody operates in.
	EscalationOverdue = "cleaning_overdue_critical"
	// EscalationOverride is a bed back in service uncleaned. The ward that
	// admits into it is entitled to know.
	EscalationOverride = "bed_hold_overridden"
)

// Config is what a deployment has decided about its cleaning.
type Config struct {
	// RequireVerification holds a bed until a supervisor has checked the
	// terminal clean, rather than until the cleaner says it is done. A
	// hospital that verifies its terminal cleans and then releases beds on
	// the cleaner's word is one where the verification changes nothing.
	RequireVerification bool
	// RequireIncidentForSpill refuses a spill task whose incident reference
	// does not resolve. SRS-HKP-006's acceptance is that the link is
	// retained, and a link to nothing is not retained.
	RequireIncidentForSpill bool
	// RequireEndedEncounter refuses a terminal clean raised against an
	// encounter that has not ended. A bed taken out of service with
	// somebody in it is a bed the ward stops trusting the board about.
	RequireEndedEncounter bool
	// EscalationBatch bounds one escalation sweep. Zero uses the default.
	EscalationBatch int32
}

// Service is the housekeeping use-case façade.
type Service struct {
	uow       ports.UnitOfWork
	locations ports.LocationRepository
	tasks     ports.TaskRepository
	scans     ports.ScanRepository
	holds     ports.HoldRepository

	encounters  ports.Encounters
	incidents   ports.Incidents
	events      ports.EventAppender
	audit       ports.AuditAppender
	escalations ports.Escalator
	ids         ports.IDGenerator
	clock       ports.Clock
	config      Config
}

// Deps are the collaborators the service needs.
type Deps struct {
	UnitOfWork ports.UnitOfWork
	Locations  ports.LocationRepository
	Tasks      ports.TaskRepository
	Scans      ports.ScanRepository
	Holds      ports.HoldRepository

	// Encounters answers whether the discharge a terminal clean is raised
	// for actually happened. Nil raises terminal cleans on the ward's word
	// alone, which the status document says out loud.
	Encounters ports.Encounters
	// Incidents resolves a spill task's incident reference. Nil records the
	// reference unresolved.
	Incidents ports.Incidents
	Events    ports.EventAppender
	// AuditTrail is the platform's append-only trail.
	AuditTrail ports.AuditAppender
	// Escalations raises the notices an overdue critical clean and an
	// overridden hold produce. Nil records both and escalates neither.
	Escalations ports.Escalator
	IDs         ports.IDGenerator
	Clock       ports.Clock
	Config      Config
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, locations: d.Locations, tasks: d.Tasks,
		scans: d.Scans, holds: d.Holds,
		encounters: d.Encounters, incidents: d.Incidents,
		events: d.Events, audit: d.AuditTrail, escalations: d.Escalations,
		ids: d.IDs, clock: d.Clock, config: d.Config,
	}
}

// Limits on what one request may ask for.
const (
	DefaultPageSize = 200
	MaxPageSize     = 1000
	// facilityPageSize bounds a whole-facility read of locations. A site
	// with more cleanable places than this is one somebody should split by
	// building.
	facilityPageSize = 5000
	// defaultEscalationBatch bounds one sweep.
	defaultEscalationBatch = 200
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

func (s *Service) authorize(ctx context.Context, permission string) (
	authctx.Session, authctx.TenantScope, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return authctx.Session{}, authctx.TenantScope{},
			rpcerr.Unauthenticated("HKP_NO_SESSION",
				"this call needs an authenticated caller")
	}
	if !session.HasPermission(permission) {
		return authctx.Session{}, authctx.TenantScope{},
			rpcerr.PermissionDenied("HKP_FORBIDDEN",
				"this caller may not "+permission)
	}
	return session, session.TenantScope(), nil
}

// housekeepingError maps a domain refusal to the transport contract.
func housekeepingError(err error) error {
	if errors.Is(err, domain.ErrInvalidHousekeeping) {
		return rpcerr.Invalid("HKP_INVALID", err.Error())
	}
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("HKP_VERSION_CONFLICT",
			"somebody else changed this record; re-read it and try again")
	}
	return err
}

// redact hides a restricted task's detail from a caller who may not read it
// (SRS-HKP-006).
//
// The task itself stays on the worklist — somebody still has to go and clean
// it, and hiding the task would mean nobody did. What goes is what the spill
// was and which incident it belongs to, because that is the part that is
// about a patient.
func redact(session authctx.Session, task domain.CleaningTask) domain.CleaningTask {
	if !task.Restricted || session.HasPermission(PermSpillRead) {
		return task
	}
	task.Detail = ""
	task.IncidentRef = ""
	return task
}

func redactAll(session authctx.Session,
	tasks []domain.CleaningTask) []domain.CleaningTask {

	out := make([]domain.CleaningTask, 0, len(tasks))
	for _, task := range tasks {
		out = append(out, redact(session, task))
	}
	return out
}

func (s *Service) appendAudit(ctx context.Context, session authctx.Session,
	r audit.Record, now time.Time) error {

	if s.audit == nil {
		return nil
	}
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
	return s.audit.Append(ctx, r)
}

const (
	eventSchemaVersion = 1
	eventSource        = "housekeeping"
)

func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateType, aggregateID string, payload map[string]any,
	now time.Time) error {

	if s.events == nil {
		return nil
	}
	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("HKP_EVENT_ENCODE_FAILED",
			"could not encode event").WithCause(err)
	}
	return s.events.Append(ctx, outbox.Event{
		EventID:       s.ids.NewID(),
		EventType:     eventType,
		SchemaVersion: eventSchemaVersion,
		OccurredAt:    now.UTC(),
		TenantID:      session.TenantID,
		Source:        eventSource,
		AggregateType: aggregateType,
		AggregateID:   aggregateID,
		CorrelationID: session.CorrelationID,
		CausationID:   session.RequestID,
		Actor:         session.SubjectID,
		Payload:       encoded,
	})
}

// escalate raises a durable notice, recording the attempt either way.
//
// A deployment with no escalator records the fact and carries on: a theatre
// whose clean is overdue is still overdue, and losing the record of it
// because the notice failed would be the worse outcome.
func (s *Service) escalate(ctx context.Context, session authctx.Session,
	scope authctx.TenantScope, n ports.Notice, now time.Time) error {

	if s.escalations == nil {
		return s.appendAudit(ctx, session, audit.Record{
			Action: "housekeeping.escalation.skipped", ResourceType: n.Kind,
			ResourceID: n.Subject, Outcome: audit.OutcomeSuccess,
			Reason: "no escalation channel is configured",
		}, now)
	}
	noticeID, err := s.escalations.Raise(ctx, scope, n, now)
	if err != nil {
		return err
	}
	return s.appendAudit(ctx, session, audit.Record{
		Action: "housekeeping.escalation.raised", ResourceType: n.Kind,
		ResourceID: n.Subject, Outcome: audit.OutcomeSuccess,
		Context: auditContext(map[string]string{"notice_id": noticeID}),
		Reason:  n.Summary,
	}, now)
}

// auditContext encodes allowlisted, non-PHI attributes for the trail. A
// failure to encode drops the attributes rather than the audit record: an
// audit entry with less context is worth more than none (FIT-06).
func auditContext(attributes map[string]string) json.RawMessage {
	encoded, err := json.Marshal(attributes)
	if err != nil {
		return nil
	}
	return encoded
}

func itoa(n int) string { return strconv.Itoa(n) }
