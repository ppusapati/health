// Package application holds the encounter use cases.
package application

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/encounter/domain"
	"github.com/ppusapati/health/code/internal/encounter/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Permissions (SRS-ENC, Wave-1 backlog "enc.*").
const (
	// PermEncounterRead reads encounters, episodes and the timeline.
	PermEncounterRead = "enc.encounter.read"
	// PermEncounterManage opens, starts, ends and cancels encounters, and
	// maintains care teams and episodes.
	PermEncounterManage = "enc.encounter.manage"
	// PermDiagnosisRecord records and revises encounter diagnoses.
	//
	// Distinct from PermEncounterManage. A clerk opens and closes encounters
	// all day; recording what is wrong with the patient is a clinical act, and
	// behind one permission every receptionist would be able to enter a
	// diagnosis under their own name.
	PermDiagnosisRecord = "enc.diagnosis.record"
	// PermEncounterClose finalises an encounter and issues its visit summary.
	PermEncounterClose = "enc.encounter.close"
	// PermEncounterOverride finalises over an incomplete record (SRS-ENC-008).
	// Its own permission because the override is the thing a quality committee
	// reports on, and an authority everybody holds is not an authority.
	PermEncounterOverride = "enc.encounter.override"
	// PermEncounterConfigure sets the closure policy.
	PermEncounterConfigure = "enc.encounter.configure"
	// PermRestrictedRead reads confidential clinical entries (SRS-CLN-019).
	PermRestrictedRead = "enc.restricted.read"
)

// Events (SRS-ENC-012).
//
// The requirement names four and asks for ordering and version to be
// "deterministic per aggregate". Ordering comes from the outbox, which is
// written inside the same transaction as the change it describes, so an event
// cannot precede the fact it reports. Version is the encounter's own optimistic
// concurrency counter, carried in the payload.
const (
	EventEncounterStarted   = "encounter.started"
	EventEncounterCompleted = "encounter.completed"
	EventEncounterCancelled = "encounter.cancelled"
	EventDiagnosisRecorded  = "diagnosis.recorded"
	// EventEncounterEnteredInError is not in the requirement's list, and is
	// emitted because a downstream projection that never heard about a
	// retracted encounter would keep asserting a visit that the record no
	// longer claims happened.
	EventEncounterEnteredInError = "encounter.entered_in_error"
)

const (
	eventSchemaVersion = 1
	eventSource        = "encounter"
)

// Service is the encounter use-case façade.
type Service struct {
	uow          ports.UnitOfWork
	encounters   ports.EncounterRepository
	episodes     ports.EpisodeRepository
	careTeams    ports.CareTeamRepository
	diagnoses    ports.DiagnosisRepository
	policies     ports.ClosurePolicyRepository
	summaries    ports.SummaryRepository
	clinical     ports.ClinicalContent
	patients     ports.PatientDirectory
	appointments ports.AppointmentDirectory
	events       ports.EventAppender
	audits       ports.AuditAppender
	ids          ports.IDGenerator
	clock        ports.Clock
}

// Deps are the collaborators the service needs.
type Deps struct {
	UnitOfWork ports.UnitOfWork
	Encounters ports.EncounterRepository
	Episodes   ports.EpisodeRepository
	CareTeams  ports.CareTeamRepository
	Diagnoses  ports.DiagnosisRepository
	Policies   ports.ClosurePolicyRepository
	Summaries  ports.SummaryRepository
	// Clinical reports what an encounter has documented, for the closure gate,
	// and supplies the clinical half of the timeline. Nil answers "nothing
	// documented" — which correctly blocks a closure that requires a signed
	// note rather than silently passing it.
	Clinical ports.ClinicalContent
	Patients ports.PatientDirectory
	// Appointments checks that a claimed appointment is this patient's. Nil
	// skips the check: SRS-ENC-003 requires the encounter to stand on its own,
	// so a deployment without the scheduling context still opens encounters.
	Appointments ports.AppointmentDirectory
	Events       ports.EventAppender
	Audits       ports.AuditAppender
	IDs          ports.IDGenerator
	Clock        ports.Clock
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, encounters: d.Encounters, episodes: d.Episodes,
		careTeams: d.CareTeams, diagnoses: d.Diagnoses, policies: d.Policies,
		summaries: d.Summaries, clinical: d.Clinical, patients: d.Patients,
		appointments: d.Appointments,
		events:       d.Events, audits: d.Audits, ids: d.IDs, clock: d.Clock,
	}
}

// Limits on what one request may ask for.
const (
	DefaultPageSize = 50
	MaxPageSize     = 200
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

// authorize is the shared preamble.
func (s *Service) authorize(ctx context.Context, permission, resourceType, resourceID string,
	mutating bool) (authctx.Session, authctx.TenantScope, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return authctx.Session{}, authctx.TenantScope{},
			rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: permission,
		Mutating:   mutating,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, permission, resourceType, resourceID, decision.Reason)
		return authctx.Session{}, authctx.TenantScope{},
			rpcerr.PermissionDenied("ENC_DENIED", decision.Reason)
	}
	return session, session.TenantScope(), nil
}

// appendEvent writes to the transactional outbox.
func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateType, aggregateID string, payload json.RawMessage,
	now time.Time) error {

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
		Payload:       payload,
	})
}

// emitEncounterEvent writes one of the SRS-ENC-012 events.
//
// The payload carries identifiers, times and the class, never the reason for
// the visit or any diagnosis text. An event stream is read by more systems, by
// more people and under fewer controls than the record it describes
// (SRS-API-009).
func (s *Service) emitEncounterEvent(ctx context.Context, session authctx.Session,
	eventType string, e *domain.Encounter, now time.Time, extra map[string]any) error {

	payload := map[string]any{
		"encounter_id": e.ID(),
		"patient_id":   e.PatientID,
		"facility_id":  e.FacilityID,
		"class":        string(e.Class),
		"status":       string(e.Status),
		// The aggregate's own counter, so a consumer can order two events about
		// one encounter without trusting delivery order (SRS-ENC-012).
		"version": e.Version,
	}
	if !e.StartedAt.IsZero() {
		payload["started_at"] = e.StartedAt.Format(time.RFC3339)
	}
	if !e.EndedAt.IsZero() {
		payload["ended_at"] = e.EndedAt.Format(time.RFC3339)
	}
	if e.EpisodeID != "" {
		payload["episode_id"] = e.EpisodeID
	}
	for k, v := range extra {
		payload[k] = v
	}

	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("ENC_EVENT_ENCODE_FAILED", "could not encode event").
			WithCause(err)
	}
	return s.appendEvent(ctx, session, eventType, "encounter", e.ID(), encoded, now)
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

// encounterError maps a domain refusal onto the wire contract.
func encounterError(err error) error {
	var invalidTransition domain.ErrInvalidTransition
	if errors.As(err, &invalidTransition) {
		return rpcerr.FailedPrecondition("ENC_INVALID_TRANSITION", invalidTransition.Error())
	}

	var incomplete domain.ErrIncompleteDocumentation
	if errors.As(err, &incomplete) {
		// SRS-ENC-008 asks for the blocking items to be listed. They travel as
		// field violations so a client can highlight the right screens rather
		// than parsing a sentence.
		violations := make([]rpcerr.FieldViolation, 0, len(incomplete.Missing))
		for _, item := range incomplete.Missing {
			violations = append(violations, rpcerr.FieldViolation{
				Field: string(item), Reason: item.Description(),
			})
		}
		return rpcerr.Invalid("ENC_DOCUMENTATION_INCOMPLETE", incomplete.Error(), violations...)
	}

	if errors.Is(err, domain.ErrInvalidEncounter) {
		return rpcerr.Invalid("ENC_INVALID", err.Error())
	}
	return err
}

// mapConflict turns a repository version conflict into the wire contract.
func mapConflict(err error) error {
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("ENC_VERSION_CONFLICT",
			"the record changed since it was read")
	}
	return err
}
