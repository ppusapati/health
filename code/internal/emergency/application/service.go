// Package application holds the Emergency Department's use cases
// (SRS-ER-001 … 018).
package application

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/emergency/domain"
	"github.com/ppusapati/health/code/internal/emergency/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Permissions.
//
// Triage and disposition are separate from ordinary emergency write, because
// they are separate jobs: a triage nurse assigns acuity and does not decide
// admissions, and a receptionist books arrivals and does neither.
const (
	// PermEmergencyRead reads the board and a visit's record.
	PermEmergencyRead = "er.visit.read"
	// PermEmergencyWrite books an arrival and records the timeline.
	PermEmergencyWrite = "er.visit.write"
	// PermTriage assigns acuity (SRS-ER-002).
	PermTriage = "er.triage.assign"
	// PermOverride moves a patient in the queue (SRS-ER-003). Its own
	// permission because it overrules a triage nurse's assessment, and the
	// person who may do that is not everybody who may record a dressing
	// change.
	PermOverride = "er.queue.override"
	// PermActivatePathway calls a resus, trauma or stroke team (SRS-ER-005).
	PermActivatePathway = "er.pathway.activate"
	// PermDispose decides where the patient goes (SRS-ER-013).
	PermDispose = "er.visit.dispose"
	// PermRestrictedRead sees a medico-legal case's detail (SRS-ER-011).
	PermRestrictedRead = "er.visit.read_restricted"
)

// Events (SRS-ER-006's "immutable events", and the rest of the hospital's
// interest in the department).
//
// Identifiers, codes and times; no free text. An event stream is read by more
// systems and under fewer controls than the record it describes (SRS-API-009),
// and a chief complaint on a broker is the patient's presenting problem
// outside the chart's access rules.
const (
	EventVisitArrived      = "emergency_visit.arrived"
	EventVisitTriaged      = "emergency_visit.triaged"
	EventPathwayActivated  = "emergency_pathway.activated"
	EventVisitDisposed     = "emergency_visit.disposed"
	EventAdministrationDue = "emergency_administration.awaiting_reconciliation"
)

// Config is what a deployment has decided about its department.
type Config struct {
	// Scale is the approved triage scale (SRS-ER-002). The zero value takes
	// ESI, which is a default rather than a refusal: a department with no
	// configured scale still has patients arriving.
	Scale domain.AcuityScale
	// Mandatory is what must be measured at triage.
	Mandatory domain.MandatoryTriageFields
	// Requirements decides what a disposition needs, per outcome. Nil takes
	// domain.DefaultDispositionRequirements, which is deliberately not empty:
	// a gate defaulting to permit-everything exists only for the deployments
	// that already thought about it.
	Requirements func(domain.Disposition) domain.DispositionRequirements
}

func (c Config) scale() domain.AcuityScale {
	if len(c.Scale.Levels) == 0 {
		return domain.ESI()
	}
	return c.Scale
}

func (c Config) requirements(d domain.Disposition) domain.DispositionRequirements {
	if c.Requirements == nil {
		return domain.DefaultDispositionRequirements(d)
	}
	return c.Requirements(d)
}

// Service is the emergency use-case façade.
type Service struct {
	uow         ports.UnitOfWork
	visits      ports.VisitRepository
	encounters  ports.Encounters
	escalations ports.Escalations
	events      ports.EventAppender
	audits      ports.AuditAppender
	ids         ports.IDGenerator
	clock       ports.Clock
	config      Config
}

// Deps are the collaborators the service needs.
type Deps struct {
	UnitOfWork ports.UnitOfWork
	Visits     ports.VisitRepository
	// Encounters reports whether the Wave-1 encounter still accepts content.
	// Nil accepts everything, which is correct only where no encounter context
	// exists.
	Encounters ports.Encounters
	// Escalations carries a pathway activation to the team (SRS-ER-005). Nil
	// records the activation and calls nobody — a department that activates by
	// shouting across the resus room, which is a real arrangement.
	Escalations ports.Escalations
	Events      ports.EventAppender
	Audits      ports.AuditAppender
	IDs         ports.IDGenerator
	Clock       ports.Clock
	Config      Config
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, visits: d.Visits, encounters: d.Encounters,
		escalations: d.Escalations, events: d.Events, audits: d.Audits,
		ids: d.IDs, clock: d.Clock, config: d.Config,
	}
}

// Limits on what one request may ask for.
const (
	DefaultPageSize = 100
	MaxPageSize     = 500
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

// authorize resolves the session and checks one permission.
func (s *Service) authorize(ctx context.Context, permission string) (
	authctx.Session, authctx.TenantScope, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return authctx.Session{}, authctx.TenantScope{}, rpcerr.Unauthenticated(
			"ER_NO_SESSION", "this call needs an authenticated caller")
	}
	if !session.HasPermission(permission) {
		return authctx.Session{}, authctx.TenantScope{}, rpcerr.PermissionDenied(
			"ER_FORBIDDEN", "this caller may not "+permission)
	}
	return session, session.TenantScope(), nil
}

// emergencyError maps a domain refusal to the transport contract.
func emergencyError(err error) error {
	if errors.Is(err, domain.ErrInvalidVisit) {
		return rpcerr.Invalid("ER_INVALID", err.Error())
	}
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("ER_VERSION_CONFLICT",
			"somebody else changed this visit; re-read it and try again")
	}
	return err
}

func (s *Service) appendAudit(ctx context.Context, session authctx.Session,
	r audit.Record, now time.Time) error {

	if s.audits == nil {
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
	return s.audits.Append(ctx, r)
}

// eventSchemaVersion and eventSource identify this context on the stream.
const (
	eventSchemaVersion = 1
	eventSource        = "emergency"
)

// appendEvent writes to the transactional outbox.
//
// Identifiers, codes and times; no free text. A chief complaint on a broker is
// the patient's presenting problem outside the chart's access rules
// (SRS-API-009).
func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateType, aggregateID string, payload map[string]any,
	now time.Time) error {

	if s.events == nil {
		return nil
	}
	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("ER_EVENT_ENCODE_FAILED", "could not encode event").
			WithCause(err)
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

// requireWritableEncounter refuses content on a closed encounter, and reports
// the patient the encounter is for.
func (s *Service) requireWritableEncounter(ctx context.Context,
	scope authctx.TenantScope, encounterID string) (string, error) {

	if s.encounters == nil {
		return "", nil
	}
	patientID, writable, err := s.encounters.Writable(ctx, scope, encounterID)
	if err != nil {
		return "", err
	}
	if !writable {
		return "", rpcerr.FailedPrecondition("ER_ENCOUNTER_CLOSED",
			"this encounter no longer accepts content")
	}
	return patientID, nil
}

func trimmed(values ...string) string {
	for _, value := range values {
		if v := strings.TrimSpace(value); v != "" {
			return v
		}
	}
	return ""
}

// describeVisit is the one-line label the board and the audit trail use.
//
// The temporary name for somebody nobody has identified, so a resuscitation
// record and a wristband agree.
func describeVisit(v domain.Visit) string {
	if v.Unidentified {
		return v.TemporaryName
	}
	return fmt.Sprintf("patient %s", v.PatientID)
}
