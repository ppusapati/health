// Package application holds the clinical use cases.
package application

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/clinical/domain"
	"github.com/ppusapati/health/code/internal/clinical/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Permissions (SRS-CLN, Wave-1 backlog "cln.*").
const (
	// PermClinicalRead reads the chart.
	PermClinicalRead = "cln.record.read"
	// PermClinicalWrite records problems, allergies, observations, procedures
	// and plans, and writes note drafts.
	PermClinicalWrite = "cln.record.write"
	// PermClinicalSign signs a clinical document (SRS-CLN-009).
	//
	// Its own permission, because signing is an assertion of clinical
	// responsibility rather than an act of data entry. A ward clerk typing a
	// dictated note should be able to save the draft and must not be able to
	// finalise it.
	PermClinicalSign = "cln.document.sign"
	// PermRestrictedRead reads confidential clinical content (SRS-CLN-019).
	PermRestrictedRead = "cln.record.read_restricted"
	// PermClinicalConfigure maintains templates, smart phrases and the
	// escalation policy.
	PermClinicalConfigure = "cln.record.configure"
	// PermResultAcknowledge acknowledges a critical result (SRS-CLN-012).
	//
	// Held by clinicians, not by the desk: acknowledging means somebody has
	// taken clinical action, and a permission the whole hospital holds would
	// let a clerk clear the safety worklist by clicking through it.
	PermResultAcknowledge = "cln.result.acknowledge"
)

// Events (SRS-CLN-024).
//
// The requirement names six and asks for them to contain "minimum necessary
// data and references". Every payload here carries identifiers, codes and
// times, and no free text: an event stream is read by more systems, by more
// people and under fewer controls than the record it describes (SRS-API-009).
const (
	EventDocumentSigned             = "clinical_document.signed"
	EventObservationRecorded        = "observation.recorded"
	EventProblemUpdated             = "problem.updated"
	EventAllergyUpdated             = "allergy.updated"
	EventProcedureCompleted         = "procedure.completed"
	EventCriticalResultAcknowledged = "critical_result.acknowledged"
	// EventConsultAnswered is not in the requirement's list, and is emitted
	// because a requester whose system had to poll for the reply is a requester
	// who finds it tomorrow (SRS-CLN-022).
	EventConsultAnswered = "consult.answered"
)

const (
	eventSchemaVersion = 1
	eventSource        = "clinical"
)

// Service is the clinical use-case façade.
type Service struct {
	uow         ports.UnitOfWork
	documents   ports.DocumentRepository
	templates   ports.TemplateRepository
	records     ports.RecordRepository
	governance  ports.GovernanceRepository
	decisions   ports.DecisionRepository
	phrases     ports.SmartPhraseRepository
	timeline    ports.TimelineRepository
	encounters  ports.EncounterDirectory
	patients    ports.PatientSummary
	escalation  domain.EscalationPolicy
	escalations ports.Escalations
	attachments ports.AttachmentStore
	events      ports.EventAppender
	audits      ports.AuditAppender
	ids         ports.IDGenerator
	clock       ports.Clock
}

// Deps are the collaborators the service needs.
type Deps struct {
	UnitOfWork ports.UnitOfWork
	Documents  ports.DocumentRepository
	Templates  ports.TemplateRepository
	Records    ports.RecordRepository
	Governance ports.GovernanceRepository
	Decisions  ports.DecisionRepository
	Phrases    ports.SmartPhraseRepository
	Timeline   ports.TimelineRepository
	// Encounters reports whether a visit still accepts clinical content, and
	// which patient it belongs to. Nil accepts everything, which is correct
	// only where no encounter context exists.
	Encounters ports.EncounterDirectory
	// Patients supplies the identity half of the banner. Nil renders a banner
	// with identifiers and alerts but no name, which is visibly wrong rather
	// than quietly so.
	Patients ports.PatientSummary
	// Escalation is when an unacknowledged critical result escalates
	// (SRS-CLN-012). The zero value takes the domain default.
	//
	// It decides the timing of the worklist's "overdue" column. It does not
	// tell anybody: that is Escalations below, and the two are separate
	// because the first is a calculation this context owns and the second is a
	// platform mechanism seven Wave-2 families share.
	Escalation domain.EscalationPolicy
	// Escalations persists a critical result until somebody acknowledges it
	// (SRS-OPSNFR-003). Nil records the result and escalates nothing, which is
	// what a deployment with no chain configured asked for — and is never a
	// reason to fail the result.
	Escalations ports.Escalations
	// Attachments holds the bytes of attached files (SRS-CLN-014). Nil is a
	// valid deployment and the default: one that stores no binary content
	// refuses to attach a file rather than recording an attachment pointing at
	// nothing.
	Attachments ports.AttachmentStore
	Events      ports.EventAppender
	Audits      ports.AuditAppender
	IDs         ports.IDGenerator
	Clock       ports.Clock
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	escalation := d.Escalation
	if escalation.After <= 0 {
		escalation = domain.DefaultEscalationPolicy()
	}

	return &Service{
		uow: d.UnitOfWork, documents: d.Documents, templates: d.Templates,
		records: d.Records, governance: d.Governance, decisions: d.Decisions,
		phrases: d.Phrases, timeline: d.Timeline, encounters: d.Encounters,
		patients: d.Patients, escalation: escalation, escalations: d.Escalations,
		attachments: d.Attachments,
		events:      d.Events, audits: d.Audits, ids: d.IDs, clock: d.Clock,
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
			rpcerr.PermissionDenied("CLN_DENIED", decision.Reason)
	}
	return session, session.TenantScope(), nil
}

// requireWritableEncounter refuses clinical content against a visit that is
// closed, cancelled or retracted, and checks the patient the caller named is
// the one the encounter belongs to.
//
// The second half is SRS-CLN-017 at the seam: a note filed against the right
// encounter but the wrong patient is the wrong-patient error the context lock
// exists to prevent, seen from the other side.
func (s *Service) requireWritableEncounter(ctx context.Context, scope authctx.TenantScope,
	encounterID, patientID string) error {

	if s.encounters == nil || encounterID == "" {
		return nil
	}

	owner, accepts, err := s.encounters.AcceptsClinicalContent(ctx, scope, encounterID)
	if err != nil {
		return err
	}
	if !accepts {
		return rpcerr.FailedPrecondition("CLN_ENCOUNTER_NOT_OPEN",
			"that encounter no longer accepts clinical content")
	}
	if patientID != "" && owner != "" && owner != patientID {
		return rpcerr.Invalid("CLN_PATIENT_ENCOUNTER_MISMATCH",
			"that encounter belongs to a different patient")
	}
	return nil
}

// checkContext applies the patient-context lock (SRS-CLN-017).
func checkContext(pc domain.PatientContext, patientID, encounterID, action string,
	now time.Time) error {

	if err := pc.Check(patientID, encounterID, action, now); err != nil {
		var mismatch domain.ErrPatientContextMismatch
		if errors.As(err, &mismatch) {
			return rpcerr.FailedPrecondition("CLN_PATIENT_CONTEXT_MISMATCH", err.Error())
		}
		return clinicalError(err)
	}
	return nil
}

// appendEvent writes to the transactional outbox.
func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateType, aggregateID string, payload map[string]any,
	now time.Time) error {

	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("CLN_EVENT_ENCODE_FAILED", "could not encode event").
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

// clinicalError maps a domain refusal onto the wire contract.
func clinicalError(err error) error {
	var mismatch domain.ErrPatientContextMismatch
	if errors.As(err, &mismatch) {
		return rpcerr.FailedPrecondition("CLN_PATIENT_CONTEXT_MISMATCH", mismatch.Error())
	}
	if errors.Is(err, domain.ErrInvalidDocument) {
		return rpcerr.Invalid("CLN_INVALID", err.Error())
	}
	return err
}

// mapConflict turns a repository version conflict into the wire contract.
func mapConflict(err error) error {
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("CLN_VERSION_CONFLICT",
			"the record changed since it was read, or is no longer a draft")
	}
	return err
}

// canReadRestricted reports whether this session may read confidential
// clinical content (SRS-CLN-019).
func canReadRestricted(session authctx.Session) bool {
	// Break-glass reaches restricted content and is separately audited. It does
	// not make the entry ordinary, and the very-restricted tier is still out of
	// reach without the permission.
	return session.HasPermission(PermRestrictedRead) || session.BreakGlass
}

// visible reports whether a record of this class may be shown to this session.
func visible(session authctx.Session, c domain.Confidentiality) bool {
	if !c.Restricted() {
		return true
	}
	if c == domain.ConfidentialityVeryRestricted {
		// The tier a hospital has decided needs a conversation rather than a
		// button. Only the explicit permission reaches it.
		return session.HasPermission(PermRestrictedRead)
	}
	return canReadRestricted(session)
}
