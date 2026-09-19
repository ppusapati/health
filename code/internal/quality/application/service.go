// Package application holds the quality management use cases
// (SRS-QMS-001 … 015).
package application

import (
	"context"
	"encoding/json"
	"errors"
	"strconv"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/quality/domain"
	"github.com/ppusapati/health/code/internal/quality/ports"
)

// Permissions.
//
// Split along the jobs, with six standing alone because they are the steps a
// hospital's quality system is answerable for: reading restricted material,
// approving a corrective action, approving a document version, conducting peer
// review, placing a legal hold, and closing an incident. Each makes something
// possible that was not, and each is what an accreditation survey traces a
// failure back to.
const (
	// PermRead reads incidents, actions, documents, audits and indicators —
	// everything that is not restricted.
	PermRead = "qms.record.read"
	// PermReport reports an incident or near miss (SRS-QMS-001). Held as
	// widely as any permission in this system: a reporting system only the
	// quality department can write to is a reporting system that receives
	// nothing.
	PermReport = "qms.incident.report"
	// PermReview scores, investigates and closes an incident (SRS-QMS-002).
	PermReview = "qms.incident.review"
	// PermRestricted reads restricted incidents, analyses and peer reviews
	// (SRS-QMS-001, SRS-QMS-005, SRS-QMS-012). Its own permission, and every
	// read under it is audited: the requirement's acceptance is that access is
	// limited to the authorised committee and logged.
	PermRestricted = "qms.restricted.read"
	// PermInvestigate conducts root cause analysis (SRS-QMS-003).
	PermInvestigate = "qms.rca.conduct"
	// PermAction raises and works corrective and preventive actions
	// (SRS-QMS-004).
	PermAction = "qms.capa.write"
	// PermApproveAction authorises an action to start and signs its closure
	// off (SRS-QMS-004). Its own permission, because those are the two ends
	// the separation of duties is at — and holding it is necessary and not
	// sufficient, since the domain refuses the raiser and the owner whoever
	// they are.
	PermApproveAction = "qms.capa.approve"
	// PermDocument drafts and maintains controlled documents (SRS-QMS-006).
	PermDocument = "qms.document.write"
	// PermApproveDocument approves a version (SRS-QMS-006). Its own
	// permission, because approval is the step that makes a draft into policy
	// and everything downstream — acknowledgement, competency, accreditation
	// evidence — is pinned to it.
	PermApproveDocument = "qms.document.approve"
	// PermAcknowledge confirms having read a version (SRS-QMS-006). Held by
	// everybody, because everybody is asked.
	PermAcknowledge = "qms.document.acknowledge"
	// PermCompetency maintains competencies and awards them (SRS-QMS-013).
	PermCompetency = "qms.competency.write"
	// PermAudit plans and conducts internal audits (SRS-QMS-007).
	PermAudit = "qms.audit.conduct"
	// PermCommittee runs committees and their minutes (SRS-QMS-008).
	PermCommittee = "qms.committee.manage"
	// PermAccreditation maintains the standard, its clauses and the evidence
	// map (SRS-QMS-009, SRS-QMS-014).
	PermAccreditation = "qms.accreditation.write"
	// PermIndicator maintains the dictionary and records values
	// (SRS-QMS-010).
	PermIndicator = "qms.indicator.write"
	// PermComplaint handles grievances (SRS-QMS-011).
	PermComplaint = "qms.complaint.handle"
	// PermPeerReview conducts mortality and morbidity review (SRS-QMS-012).
	// Its own permission, separate from reading restricted material: reading
	// the committee's conclusions and sitting on the committee are different
	// things.
	PermPeerReview = "qms.peerreview.conduct"
	// PermHold places and lifts a legal hold (SRS-QMS-015). Its own
	// permission, because a hold is what stops a record being destroyed and
	// lifting one is the step nobody should take casually.
	PermHold = "qms.record.hold"
)

// Events.
//
// Identifiers, categories and counts. No narrative, no patient identifier and
// nothing from a restricted record beyond the fact that it exists: an event
// stream is read by more systems and under fewer controls than the record it
// describes (SRS-API-009), and an incident stream carrying narratives would
// be the widest-read copy of the most sensitive text in the hospital.
const (
	EventIncidentReported  = "qms_incident.reported"
	EventIncidentEscalated = "qms_incident.escalated"
	EventIncidentClosed    = "qms_incident.closed"
	EventActionRaised      = "qms_capa.raised"
	EventActionClosed      = "qms_capa.closed"
	// EventDocumentApproved is how a ward learns a policy has changed.
	EventDocumentApproved  = "qms_document.approved"
	EventFindingRaised     = "qms_audit.finding_raised"
	EventComplaintReceived = "qms_complaint.received"
	EventClauseReviewed    = "qms_accreditation.clause_reviewed"
)

// The escalations this context raises.
const (
	// EscalationSentinel is a sentinel event. The executive is told
	// individually (SRS-QMS-005).
	EscalationSentinel = "qms_sentinel_event"
	// EscalationHighRisk is an incident scored in a band the hospital acts on
	// now (SRS-QMS-002).
	EscalationHighRisk = "qms_high_risk_incident"
	// EscalationOverdueAction is a corrective action past its date
	// (SRS-QMS-004).
	EscalationOverdueAction = "qms_overdue_capa"
	// EscalationComplaintBreach is a grievance past a clock (SRS-QMS-011).
	EscalationComplaintBreach = "qms_complaint_breach"
)

// ComplaintSLA is what a category of grievance promises (SRS-QMS-011).
type ComplaintSLA struct {
	AcknowledgeWithin time.Duration
	ResolveWithin     time.Duration
}

// Config is what a deployment has decided about its quality system.
type Config struct {
	// RCAMethods is the set of analysis techniques the hospital has approved
	// (SRS-QMS-003). Empty accepts any non-empty method, which is a deployment
	// that has not decided — visible in the status document rather than
	// guessed at here.
	RCAMethods []string
	// SentinelCategories are the incident categories that are sentinel events
	// whatever else was recorded — wrong-site surgery, a retained item
	// (SRS-QMS-005). A death is always one, in the domain, whatever this says.
	SentinelCategories []string
	// EscalateAtBand is the risk band at or above which an incident raises a
	// notice (SRS-QMS-002). Empty escalates nothing, which is a deployment
	// that has not decided.
	EscalateAtBand domain.RiskBand
	// RCARequiredAtBand is the band at or above which an incident is expected
	// to have an analysis. Reported, not enforced: refusing to close an
	// incident until somebody has done an RCA makes the incident log a place
	// work goes to be forgotten.
	RCARequiredAtBand domain.RiskBand
	// StaleReviewAfter is how old an accreditation judgement may be before the
	// readiness report stops counting it as current (SRS-QMS-014). Zero marks
	// nothing stale.
	StaleReviewAfter time.Duration
	// DefaultComplaintSLA applies where a category has none (SRS-QMS-011).
	DefaultComplaintSLA ComplaintSLA
	// ComplaintSLAByCategory overrides it per category.
	ComplaintSLAByCategory map[string]ComplaintSLA
	// AcknowledgementRoles are the roles asked to confirm they have read a
	// policy that requires acknowledgement (SRS-QMS-006). Empty asks nobody,
	// which reports no gaps — a clean report that means nothing, and one the
	// status document names.
	AcknowledgementRoles []string
	// CompetencyRoles are the roles the competency gap report covers
	// (SRS-QMS-013).
	CompetencyRoles []string
}

// Service is the quality use-case façade.
type Service struct {
	uow            ports.UnitOfWork
	incidents      ports.IncidentRepository
	investigations ports.InvestigationRepository
	actions        ports.ActionRepository
	documents      ports.DocumentRepository
	competencies   ports.CompetencyRepository
	audits         ports.AuditRepository
	committees     ports.CommitteeRepository
	accreditation  ports.AccreditationRepository
	indicators     ports.IndicatorRepository
	complaints     ports.ComplaintRepository
	peerReviews    ports.PeerReviewRepository

	holds       ports.LegalHolds
	staff       ports.Staff
	events      ports.EventAppender
	audit       ports.AuditAppender
	escalations ports.Escalator
	ids         ports.IDGenerator
	clock       ports.Clock
	config      Config
}

// Deps are the collaborators the service needs.
type Deps struct {
	UnitOfWork     ports.UnitOfWork
	Incidents      ports.IncidentRepository
	Investigations ports.InvestigationRepository
	Actions        ports.ActionRepository
	Documents      ports.DocumentRepository
	Competencies   ports.CompetencyRepository
	Audits         ports.AuditRepository
	Committees     ports.CommitteeRepository
	Accreditation  ports.AccreditationRepository
	Indicators     ports.IndicatorRepository
	Complaints     ports.ComplaintRepository
	PeerReviews    ports.PeerReviewRepository

	// Holds is the platform's legal-hold mechanism (SRS-QMS-015). Nil places
	// no holds and reports nothing held, which is a deployment with no
	// retention policy — visible in the status document.
	Holds ports.LegalHolds
	// Staff answers who holds which role, for the gap reports. Nil reports no
	// gaps, which is a clean report that means nothing and is named as such.
	Staff  ports.Staff
	Events ports.EventAppender
	// AuditTrail is the platform's append-only trail. Named apart from Audits
	// above, which are this context's own internal audits — SRS-QMS-007's
	// kind, not SRS-SEC's.
	AuditTrail ports.AuditAppender
	// Escalations raises the notices a sentinel event, a high-risk incident
	// and an overdue action produce. Nil records all three and escalates none.
	Escalations ports.Escalator
	IDs         ports.IDGenerator
	Clock       ports.Clock
	Config      Config
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, incidents: d.Incidents,
		investigations: d.Investigations, actions: d.Actions,
		documents: d.Documents, competencies: d.Competencies,
		audits: d.Audits, committees: d.Committees,
		accreditation: d.Accreditation, indicators: d.Indicators,
		complaints: d.Complaints, peerReviews: d.PeerReviews,
		holds: d.Holds, staff: d.Staff,
		events: d.Events, audit: d.AuditTrail, escalations: d.Escalations,
		ids: d.IDs, clock: d.Clock, config: d.Config,
	}
}

// Limits on what one request may ask for.
const (
	DefaultPageSize = 200
	MaxPageSize     = 1000
	// reportPageSize bounds a derived report. A readiness assessment over a
	// standard with a thousand clauses is a report, not a query that pulls the
	// hospital into memory.
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
		return authctx.Session{}, authctx.TenantScope{}, rpcerr.Unauthenticated(
			"QMS_NO_SESSION", "this call needs an authenticated caller")
	}
	if !session.HasPermission(permission) {
		return authctx.Session{}, authctx.TenantScope{}, rpcerr.PermissionDenied(
			"QMS_FORBIDDEN", "this caller may not "+permission)
	}
	return session, session.TenantScope(), nil
}

// qualityError maps a domain refusal to the transport contract.
func qualityError(err error) error {
	if errors.Is(err, domain.ErrInvalidQuality) {
		return rpcerr.Invalid("QMS_INVALID", err.Error())
	}
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("QMS_VERSION_CONFLICT",
			"somebody else changed this record; re-read it and try again")
	}
	return err
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
	eventSource        = "quality"
)

func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateType, aggregateID string, payload map[string]any,
	now time.Time) error {

	if s.events == nil {
		return nil
	}
	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("QMS_EVENT_ENCODE_FAILED",
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

// readRestricted decides what a caller may see of a restricted record, and
// audits the read when they may see all of it (SRS-QMS-012, SRS-OPSSEC-002).
//
// The audit is the point. A restricted record that can be read without a trace
// is a restricted record in name only, and the requirement's acceptance is
// that access is limited to the authorised committee *and* logged.
func (s *Service) readRestricted(ctx context.Context, session authctx.Session,
	restricted bool, resourceType, resourceID string, now time.Time) (
	bool, error) {

	if !restricted {
		return true, nil
	}
	if !session.HasPermission(PermRestricted) {
		return false, nil
	}
	return true, s.appendAudit(ctx, session, audit.Record{
		Action: "quality.restricted.read", ResourceType: resourceType,
		ResourceID: resourceID, Outcome: audit.OutcomeSuccess,
		Reason: "read a restricted quality record",
	}, now)
}

// heldBack refuses a write to a record under legal hold (SRS-QMS-015).
//
// A hold stops destruction, and this stops the other way a record is lost: a
// closure or a correction that rewrites what a court asked to see. Reads are
// untouched.
func (s *Service) heldBack(ctx context.Context, scope authctx.TenantScope,
	recordClass, recordID string) error {

	if s.holds == nil {
		return nil
	}
	held, err := s.holds.Held(ctx, scope, recordClass, recordID)
	if err != nil {
		return err
	}
	if held {
		return rpcerr.FailedPrecondition("QMS_UNDER_LEGAL_HOLD",
			"this record is under legal hold and cannot be changed")
	}
	return nil
}

func itoa(n int) string { return strconv.Itoa(n) }

// bandRank orders the risk bands so a configured threshold can be compared.
func bandRank(b domain.RiskBand) int {
	switch b {
	case domain.RiskModerate:
		return 1
	case domain.RiskHigh:
		return 2
	case domain.RiskExtreme:
		return 3
	case domain.RiskLow:
		return 0
	default:
		// An unset threshold is above everything, so nothing reaches it.
		return 99
	}
}
