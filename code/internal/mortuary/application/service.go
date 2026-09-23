// Package application holds the mortuary use cases (SRS-MORT-001 … 008).
package application

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"strconv"
	"time"

	"github.com/ppusapati/health/code/internal/mortuary/domain"
	"github.com/ppusapati/health/code/internal/mortuary/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Permissions.
//
// Three stand apart from the rest because of what they make possible.
// PermRelease sends a body out of the building, which happens once.
// PermSensitiveRead opens the cause of death and the medico-legal reference,
// which SRS-MORT-003 puts behind its own lock and audits every time.
// PermAuthorise records an authority's clearance, which is the thing standing
// between a medico-legal case and the door.
const (
	// PermRead reads the register, the board and one case without its
	// sensitive detail. Held widely: a ward ringing to ask whether a body
	// has been collected needs it.
	PermRead = "mort.read"
	// PermSensitiveRead opens the cause summary and the medico-legal
	// reference (SRS-MORT-003). Its own permission and every use audited:
	// this is the read an investigation asks about.
	PermSensitiveRead = "mort.sensitive.read"
	// PermCauseRecord writes the cause of death. Separate from reading it,
	// because the person who certifies what somebody died of is not
	// everybody who may look it up afterwards.
	PermCauseRecord = "mort.cause.record"
	// PermCaseManage opens cases and records identifications and
	// certificates (SRS-MORT-001).
	PermCaseManage = "mort.case.manage"
	// PermStorageManage registers spaces and takes them off the board
	// (SRS-MORT-002).
	PermStorageManage = "mort.storage.manage"
	// PermPlace puts a body in a space and moves it (SRS-MORT-002).
	PermPlace = "mort.place"
	// PermCustody lists belongings and records the chain (SRS-MORT-004).
	PermCustody = "mort.custody"
	// PermHandover gives belongings to a family. Separate from listing
	// them, because the person who wrote down what was in the pockets
	// should not be the only person involved in handing them over.
	PermHandover = "mort.handover"
	// PermPostmortemRequest asks for an examination (SRS-MORT-005).
	PermPostmortemRequest = "mort.postmortem.request"
	// PermPostmortemManage records the authorisation, the examination and
	// the report.
	PermPostmortemManage = "mort.postmortem.manage"
	// PermAuthorise records an authority's clearance to release
	// (SRS-MORT-006, SRS-MORT-007).
	PermAuthorise = "mort.authorise"
	// PermRelease releases a body (SRS-MORT-006).
	PermRelease = "mort.release"
	// PermReportRead reads the occupancy and pending-release dashboard
	// (SRS-MORT-008).
	PermReportRead = "mort.report.read"
)

// Events.
//
// Identifiers and states. No name, no cause, no medico-legal reference and no
// storage location: an event stream is read by more systems and under fewer
// controls than the record it describes (SRS-API-009), and a mortuary event
// naming a person is a death notice on a message bus.
const (
	EventCaseOpened     = "mortuary_case.opened"
	EventCaseReleased   = "mortuary_case.released"
	EventBodyIdentified = "mortuary_case.identified"
)

// The escalations this context raises.
const (
	// EscalationLongStay is a body held past the deployment's limit. The
	// one thing here that cannot wait for somebody to open a screen: a
	// body nobody has claimed becomes somebody's legal problem and then
	// nobody's, and the point at which it should have been chased is
	// weeks earlier.
	EscalationLongStay = "mortuary_long_stay"
)

// Config is what a deployment has decided about its mortuary.
type Config struct {
	// Release is the policy SRS-MORT-007 asks to be configurable. Its zero
	// value applies the floor — a medico-legal or unidentified case needs
	// an authority's clearance — and nothing more.
	Release domain.ReleasePolicy
	// LongStayAfter is how long a body may be held before it appears on
	// the escalation sweep. Zero escalates none of them, which is a
	// mortuary that will find out from somebody else.
	LongStayAfter time.Duration
	// RequireKnownEncounter refuses an in-hospital case naming an
	// encounter the encounter context does not have. SRS-MORT-001's
	// acceptance is that the case is linked or clearly external, and one
	// linked to an identifier nobody can resolve is neither.
	RequireKnownEncounter bool
	// RequireKnownPatient refuses a case naming a patient the index does
	// not have.
	RequireKnownPatient bool
}

// Service is the mortuary use-case façade.
type Service struct {
	uow         ports.UnitOfWork
	cases       ports.CaseRepository
	storage     ports.StorageRepository
	custody     ports.CustodyRepository
	postmortems ports.PostmortemRepository
	releases    ports.ReleaseRepository

	encounters  ports.Encounters
	patients    ports.Patients
	events      ports.EventAppender
	audit       ports.AuditAppender
	escalations ports.Escalator
	ids         ports.IDGenerator
	clock       ports.Clock
	config      Config
}

// Deps are the collaborators the service needs.
type Deps struct {
	UnitOfWork  ports.UnitOfWork
	Cases       ports.CaseRepository
	Storage     ports.StorageRepository
	Custody     ports.CustodyRepository
	Postmortems ports.PostmortemRepository
	Releases    ports.ReleaseRepository

	// Encounters resolves the death an in-hospital case names. Nil accepts
	// whatever it is given, which the status document says out loud.
	Encounters ports.Encounters
	// Patients resolves the patient a case names.
	Patients ports.Patients
	Events   ports.EventAppender
	// AuditTrail is the platform's append-only trail.
	AuditTrail ports.AuditAppender
	// Escalations raises the notice a long-held body produces. Nil records
	// it and escalates nothing.
	Escalations ports.Escalator
	IDs         ports.IDGenerator
	Clock       ports.Clock
	Config      Config
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, cases: d.Cases, storage: d.Storage,
		custody: d.Custody, postmortems: d.Postmortems,
		releases: d.Releases, encounters: d.Encounters,
		patients: d.Patients, events: d.Events, audit: d.AuditTrail,
		escalations: d.Escalations,
		ids:         d.IDs, clock: d.Clock, config: d.Config,
	}
}

// Limits on what one request may ask for.
const (
	DefaultPageSize = 200
	MaxPageSize     = 1000
	// reportPageSize bounds one dashboard read. A mortuary holding more
	// than this is one whose board should be split by facility.
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
			rpcerr.Unauthenticated("MORT_NO_SESSION",
				"this call needs an authenticated caller")
	}
	if !session.HasPermission(permission) {
		return authctx.Session{}, authctx.TenantScope{},
			rpcerr.PermissionDenied("MORT_FORBIDDEN",
				"this caller may not "+permission)
	}
	return session, session.TenantScope(), nil
}

// mortuaryError maps a domain refusal to the transport contract.
func mortuaryError(err error) error {
	if errors.Is(err, domain.ErrInvalidMortuary) {
		return rpcerr.Invalid("MORT_INVALID", err.Error())
	}
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("MORT_VERSION_CONFLICT",
			"somebody else changed this record; re-read it and try again")
	}
	return err
}

// errUnknownStep refuses a postmortem transition nobody defined.
func errUnknownStep(to string) error {
	return fmt.Errorf("%w: unknown postmortem step %q",
		domain.ErrInvalidMortuary, to)
}

// errClearanceIncomplete refuses an authorisation missing one of its two
// halves. A name with no reference is not something anybody can check.
func errClearanceIncomplete() error {
	return fmt.Errorf(
		"%w: a clearance names the authority and their own reference",
		domain.ErrInvalidMortuary)
}

// forbidden refuses a caller who lacks a permission the call needs beyond the
// one that let them in.
func forbidden(permission string) error {
	return rpcerr.PermissionDenied("MORT_FORBIDDEN",
		"this caller may not "+permission)
}

// redact strips the sensitive fields from a case for a caller without
// PermSensitiveRead (SRS-MORT-003).
//
// Here rather than in each caller, so a second read path cannot be written
// that forgets it. The cause summary and the medico-legal reference go; the
// flag stays, because an attendant needs to know a case needs clearance
// before they move it and does not need the police number to know that.
func redact(c domain.Case, sensitive bool) domain.Case {
	if sensitive {
		return c
	}
	c.CauseSummary = ""
	c.MLCReference = ""
	return c
}

// checkEncounter refuses an in-hospital case naming a death nobody can
// resolve (SRS-MORT-001).
func (s *Service) checkEncounter(ctx context.Context,
	scope authctx.TenantScope, encounterID string) error {

	if !s.config.RequireKnownEncounter || encounterID == "" {
		return nil
	}
	if s.encounters == nil {
		return rpcerr.FailedPrecondition("MORT_NO_ENCOUNTER_DIRECTORY",
			"this deployment requires a case to name a known encounter, "+
				"but no encounter directory is configured")
	}
	exists, err := s.encounters.Exists(ctx, scope, encounterID)
	if err != nil {
		return err
	}
	if !exists {
		return rpcerr.FailedPrecondition("MORT_NO_SUCH_ENCOUNTER",
			"no encounter "+encounterID+" to link this case to")
	}
	return nil
}

// checkPatient refuses a case naming a patient the index does not have
// (SRS-MORT-001).
func (s *Service) checkPatient(ctx context.Context,
	scope authctx.TenantScope, patientID string) error {

	if !s.config.RequireKnownPatient || patientID == "" {
		return nil
	}
	if s.patients == nil {
		return rpcerr.FailedPrecondition("MORT_NO_PATIENT_INDEX",
			"this deployment requires a case to name a known patient, "+
				"but no patient index is configured")
	}
	exists, err := s.patients.Exists(ctx, scope, patientID)
	if err != nil {
		return err
	}
	if !exists {
		return rpcerr.FailedPrecondition("MORT_NO_SUCH_PATIENT",
			"no patient "+patientID+" to open a case for")
	}
	return nil
}

// appendCustody writes one line of the chain inside the caller's transaction
// (SRS-MORT-004).
//
// Called from every act that moves a body or its belongings, so the chain is
// a property of the use cases rather than something a caller remembers.
func (s *Service) appendCustody(ctx context.Context,
	scope authctx.TenantScope, caseID, event, detail, fromParty,
	toParty, by string, now time.Time) error {

	entry, err := domain.RecordCustody(s.ids.NewID(), scope.TenantID(),
		caseID, event, detail, fromParty, toParty, by, now)
	if err != nil {
		return mortuaryError(err)
	}
	return s.custody.AppendCustody(ctx, scope, entry)
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
	eventSource        = "mortuary"
)

func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateType, aggregateID string, payload map[string]any,
	now time.Time) error {

	if s.events == nil {
		return nil
	}
	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("MORT_EVENT_ENCODE_FAILED",
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
// A deployment with no escalator records the fact and carries on: a body held
// three weeks has still been held three weeks, and losing the record of the
// notice would be the worse outcome.
func (s *Service) escalate(ctx context.Context, session authctx.Session,
	scope authctx.TenantScope, n ports.Notice, now time.Time) error {

	if s.escalations == nil {
		return s.appendAudit(ctx, session, audit.Record{
			Action: "mortuary.escalation.skipped", ResourceType: n.Kind,
			ResourceID: n.Subject, Outcome: audit.OutcomeSuccess,
			Reason: "no escalation channel is configured",
		}, now)
	}
	noticeID, err := s.escalations.Raise(ctx, scope, n, now)
	if err != nil {
		return err
	}
	return s.appendAudit(ctx, session, audit.Record{
		Action: "mortuary.escalation.raised", ResourceType: n.Kind,
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
