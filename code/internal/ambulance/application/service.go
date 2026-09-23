// Package application holds the ambulance and fleet use cases
// (SRS-AMB-001 … 008).
package application

import (
	"context"
	"encoding/json"
	"errors"
	"strconv"
	"time"

	"github.com/ppusapati/health/code/internal/ambulance/domain"
	"github.com/ppusapati/health/code/internal/ambulance/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Permissions.
//
// Two stand apart from the rest because of what they make possible.
// PermDispatchOverride sends a vehicle that failed a check or a crew that is
// not on duty, which is the moment a safety rule becomes a note in a log.
// PermLocationRead opens the map of where an ambulance has been, which is a
// list of the addresses somebody was ill at.
const (
	// PermRead reads the fleet, the queue, a trip and its timeline. Held
	// widely: a ward asking when the transfer is coming needs it.
	PermRead = "amb.read"
	// PermFleetManage registers vehicles and rosters crews (SRS-AMB-002).
	PermFleetManage = "amb.fleet.manage"
	// PermCheck records a readiness check (SRS-AMB-006). Held by the crew:
	// the person who looks in the vehicle is the person who records it.
	PermCheck = "amb.check"
	// PermCheckOverride waves a failed check through. Its own permission
	// and every use audited, and the domain also refuses whoever made the
	// check, so holding both is still not enough to pass your own.
	PermCheckOverride = "amb.check.override"
	// PermRequest raises an ambulance request (SRS-AMB-001). Held as
	// widely as any permission here: a call only a dispatcher can raise is
	// a patient waiting while somebody finds a dispatcher.
	PermRequest = "amb.request"
	// PermDispatch assigns a vehicle to a call (SRS-AMB-003).
	PermDispatch = "amb.dispatch"
	// PermDispatchOverride sends a vehicle a rule would have refused.
	PermDispatchOverride = "amb.dispatch.override"
	// PermTimeline records and corrects milestones (SRS-AMB-003). Held by
	// the crew, who are the only people who know when they arrived.
	PermTimeline = "amb.timeline"
	// PermPrehospitalWrite records observations, interventions and drugs
	// (SRS-AMB-004). The domain refuses a non-clinical crew role on top of
	// this, so a driver holding it still records nothing clinical.
	PermPrehospitalWrite = "amb.prehospital.write"
	// PermPrehospitalRead reads the crew's account of a journey. Separate
	// from the fleet read, because it is the patient's record.
	PermPrehospitalRead = "amb.prehospital.read"
	// PermHandoverAccept takes the patient at the hospital door. Its own
	// permission: this is the moment responsibility moves.
	PermHandoverAccept = "amb.handover.accept"
	// PermLocationWrite records a position from a telematics box
	// (SRS-AMB-005). Held by the integration, not by people.
	PermLocationWrite = "amb.location.write"
	// PermLocationRead reads the feed. Its own permission, because a map
	// of an ambulance's day is a map of where patients were collected
	// from.
	PermLocationRead = "amb.location.read"
	// PermReportRead reads the response, turnaround and utilisation
	// reports (SRS-AMB-008).
	PermReportRead = "amb.report.read"
)

// Events.
//
// Identifiers, codes and counts. No address, no clinical need, no patient: an
// event stream is read by more systems and under fewer controls than the
// record it describes (SRS-API-009).
const (
	EventRequestRaised    = "ambulance_request.raised"
	EventTripDispatched   = "ambulance_trip.dispatched"
	EventTripCompleted    = "ambulance_trip.completed"
	EventHandoverAccepted = "prehospital_handover.accepted"
	EventReadinessFailed  = "vehicle_readiness.failed"
)

// The escalations this context raises.
const (
	// EscalationOverriddenDispatch is a vehicle sent that a rule would
	// have refused. Not a refusal — on a bad night the alternative is
	// nothing at all — but not a line in a log either.
	EscalationOverriddenDispatch = "ambulance_dispatch_overridden"
	// EscalationHandoverWaiting is a crew standing in a corridor with a
	// patient nobody has accepted. The one thing here that cannot wait for
	// somebody to open a screen.
	EscalationHandoverWaiting = "prehospital_handover_waiting"
)

// Config is what a deployment has decided about its ambulance service.
type Config struct {
	// LocationRetention is how long a position is kept. Zero refuses to
	// record a feed at all rather than keeping one forever: a deployment
	// that has not decided has not decided, and the safe direction for a
	// map of where patients were collected from is not to keep it.
	LocationRetention time.Duration
	// PositionStaleAfter is how old a position may be before a dispatch
	// board marks it stale. Zero marks nothing, which shows a vehicle at
	// its last known place with no hint that the last known place is from
	// this morning.
	PositionStaleAfter time.Duration
	// HandoverWaitBeforeEscalation is how long a given handover may sit
	// unaccepted before somebody is told. Zero escalates none of them.
	HandoverWaitBeforeEscalation time.Duration
	// RequireKnownPatient refuses a request naming a patient the index
	// does not have. Off by default: most emergency calls are taken before
	// anybody knows who the patient is.
	RequireKnownPatient bool
	// RequireKnownEncounter refuses a handover acceptance naming an
	// encounter that is not there. SRS-AMB-004's acceptance is that the
	// record attaches to the emergency encounter, and one that attaches to
	// an identifier nobody can resolve has not attached to anything.
	RequireKnownEncounter bool
	// RequireKnownFacility refuses a request or a vehicle naming a
	// facility the organisation does not have.
	RequireKnownFacility bool
}

// Service is the ambulance use-case façade.
type Service struct {
	uow       ports.UnitOfWork
	vehicles  ports.VehicleRepository
	shifts    ports.ShiftRepository
	readiness ports.ReadinessRepository
	requests  ports.RequestRepository
	trips     ports.TripRepository
	records   ports.PrehospitalRepository
	locations ports.LocationRepository

	encounters  ports.Encounters
	patients    ports.Patients
	units       ports.Units
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
	Vehicles   ports.VehicleRepository
	Shifts     ports.ShiftRepository
	Readiness  ports.ReadinessRepository
	Requests   ports.RequestRepository
	Trips      ports.TripRepository
	Records    ports.PrehospitalRepository
	Locations  ports.LocationRepository

	// Encounters resolves the encounter a handover attaches to. Nil
	// accepts whatever it is given, which the status document says out
	// loud.
	Encounters ports.Encounters
	// Patients resolves the patient a request names.
	Patients ports.Patients
	// Units resolves the facility a request or a vehicle names.
	Units  ports.Units
	Events ports.EventAppender
	// AuditTrail is the platform's append-only trail.
	AuditTrail ports.AuditAppender
	// Escalations raises the notices an overridden dispatch and a waiting
	// handover produce. Nil records them and escalates nothing.
	Escalations ports.Escalator
	IDs         ports.IDGenerator
	Clock       ports.Clock
	Config      Config
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, vehicles: d.Vehicles, shifts: d.Shifts,
		readiness: d.Readiness, requests: d.Requests, trips: d.Trips,
		records: d.Records, locations: d.Locations,
		encounters: d.Encounters, patients: d.Patients, units: d.Units,
		events: d.Events, audit: d.AuditTrail,
		escalations: d.Escalations,
		ids:         d.IDs, clock: d.Clock, config: d.Config,
	}
}

// Limits on what one request may ask for.
const (
	DefaultPageSize = 200
	MaxPageSize     = 1000
	// reportPageSize bounds one report. A window holding more rows than
	// this comes back marked truncated rather than silently summarised
	// from part of itself.
	reportPageSize = 5000
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
			rpcerr.Unauthenticated("AMB_NO_SESSION",
				"this call needs an authenticated caller")
	}
	if !session.HasPermission(permission) {
		return authctx.Session{}, authctx.TenantScope{},
			rpcerr.PermissionDenied("AMB_FORBIDDEN",
				"this caller may not "+permission)
	}
	return session, session.TenantScope(), nil
}

// ambulanceError maps a domain refusal to the transport contract.
func ambulanceError(err error) error {
	if errors.Is(err, domain.ErrInvalidAmbulance) {
		return rpcerr.Invalid("AMB_INVALID", err.Error())
	}
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("AMB_VERSION_CONFLICT",
			"somebody else changed this record; re-read it and try again")
	}
	return err
}

// checkPatient refuses a request naming a patient the index does not have
// (SRS-AMB-001).
func (s *Service) checkPatient(ctx context.Context,
	scope authctx.TenantScope, patientID string) error {

	if !s.config.RequireKnownPatient || patientID == "" {
		return nil
	}
	if s.patients == nil {
		return rpcerr.FailedPrecondition("AMB_NO_PATIENT_INDEX",
			"this deployment requires a request to name a known patient, "+
				"but no patient index is configured")
	}
	exists, err := s.patients.Exists(ctx, scope, patientID)
	if err != nil {
		return err
	}
	if !exists {
		return rpcerr.FailedPrecondition("AMB_NO_SUCH_PATIENT",
			"no patient "+patientID+" to raise a request for")
	}
	return nil
}

// checkEncounter refuses a handover attaching to an encounter that is not
// there (SRS-AMB-004).
//
// The requirement's acceptance is that the crew's account attaches to the
// emergency encounter. One that attaches to an identifier nobody can resolve
// has not attached to anything, and the receiving doctor reads a chart with
// no prehospital record in it.
func (s *Service) checkEncounter(ctx context.Context,
	scope authctx.TenantScope, encounterID string) error {

	if !s.config.RequireKnownEncounter {
		return nil
	}
	if s.encounters == nil {
		return rpcerr.FailedPrecondition("AMB_NO_ENCOUNTER_DIRECTORY",
			"this deployment requires a handover to name a known "+
				"encounter, but no encounter directory is configured")
	}
	exists, err := s.encounters.Exists(ctx, scope, encounterID)
	if err != nil {
		return err
	}
	if !exists {
		return rpcerr.FailedPrecondition("AMB_NO_SUCH_ENCOUNTER",
			"no encounter "+encounterID+" to attach this record to")
	}
	return nil
}

// checkFacility refuses a record naming a facility the organisation does not
// have (SRS-AMB-001, SRS-AMB-007).
func (s *Service) checkFacility(ctx context.Context,
	scope authctx.TenantScope, facilityID string) error {

	if !s.config.RequireKnownFacility || facilityID == "" {
		return nil
	}
	if s.units == nil {
		return rpcerr.FailedPrecondition("AMB_NO_UNIT_DIRECTORY",
			"this deployment requires records to name a known facility, "+
				"but no unit directory is configured")
	}
	exists, err := s.units.Exists(ctx, scope, facilityID)
	if err != nil {
		return err
	}
	if !exists {
		return rpcerr.FailedPrecondition("AMB_NO_SUCH_FACILITY",
			"no facility "+facilityID+" to record this against")
	}
	return nil
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
	eventSource        = "ambulance"
)

func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateType, aggregateID string, payload map[string]any,
	now time.Time) error {

	if s.events == nil {
		return nil
	}
	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("AMB_EVENT_ENCODE_FAILED",
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
// A deployment with no escalator records the fact and carries on: a dispatch
// made under override has still been made, and losing the record of it
// because the notice failed would be the worse outcome.
func (s *Service) escalate(ctx context.Context, session authctx.Session,
	scope authctx.TenantScope, n ports.Notice, now time.Time) error {

	if s.escalations == nil {
		return s.appendAudit(ctx, session, audit.Record{
			Action: "ambulance.escalation.skipped", ResourceType: n.Kind,
			ResourceID: n.Subject, Outcome: audit.OutcomeSuccess,
			Reason: "no escalation channel is configured",
		}, now)
	}
	noticeID, err := s.escalations.Raise(ctx, scope, n, now)
	if err != nil {
		return err
	}
	return s.appendAudit(ctx, session, audit.Record{
		Action: "ambulance.escalation.raised", ResourceType: n.Kind,
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
