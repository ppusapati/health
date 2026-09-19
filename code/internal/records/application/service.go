// Package application holds the medical records and health information
// management use cases (SRS-MRD-001 … 010).
package application

import (
	"context"
	"encoding/json"
	"errors"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/records/domain"
	"github.com/ppusapati/health/code/internal/records/ports"
)

// Permissions.
//
// Split more finely than most contexts, and every split is at a point where
// one person acting alone could make something disappear: a waiver removes an
// encounter from the completion figures, an approval sends a patient's record
// out of the hospital, and an execution destroys records permanently. Each of
// those has a second permission behind it, and holding it is necessary and
// never sufficient — the domain and the database both refuse the same person
// twice.
const (
	// PermRead reads charts, checklists, deficiencies and coded episodes.
	PermRead = "mrd.record.read"
	// PermChecklistWrite authors chart completion checklists (SRS-MRD-001).
	PermChecklistWrite = "mrd.checklist.write"
	// PermChecklistApprove puts a checklist in force. Its own permission
	// because the checklist decides which consultants get a deficiency
	// letter, and one person writing and approving it decides that alone.
	PermChecklistApprove = "mrd.checklist.approve"
	// PermDeficiencyManage raises and reassigns deficiencies (SRS-MRD-002).
	PermDeficiencyManage = "mrd.deficiency.manage"
	// PermDeficiencyResolve answers a deficiency (SRS-MRD-002, SRS-MRD-008).
	// Held by the clinicians who owe the documents, which is far wider than
	// the records office.
	PermDeficiencyResolve = "mrd.deficiency.resolve"
	// PermDeficiencyWaive writes a deficiency off (SRS-MRD-002). Its own
	// permission: a waiver is the one way a chart leaves the worklist
	// without the document ever arriving, and an encounter with one is
	// reported as incompletable rather than complete.
	PermDeficiencyWaive = "mrd.deficiency.waive"
	// PermCodingWrite assigns codes (SRS-MRD-003).
	PermCodingWrite = "mrd.coding.write"
	// PermCodingFinalise is the second read that makes a coding final. Its
	// own permission, and the domain refuses the coder whoever holds it.
	PermCodingFinalise = "mrd.coding.finalise"
	// PermCodingQuery sends a question back to the clinician (SRS-MRD-003).
	PermCodingQuery = "mrd.coding.query"
	// PermReleaseRequest logs a request for a copy of a record
	// (SRS-MRD-004).
	PermReleaseRequest = "mrd.release.request"
	// PermReleaseApprove decides a patient's record may leave the hospital.
	PermReleaseApprove = "mrd.release.approve"
	// PermReleaseAssemble builds and sends the package.
	PermReleaseAssemble = "mrd.release.assemble"
	// PermDisclosureRead reads the accounting of disclosures (SRS-MRD-010).
	PermDisclosureRead = "mrd.disclosure.read"
	// PermRetentionWrite authors retention rules (SRS-MRD-009).
	PermRetentionWrite = "mrd.retention.write"
	// PermRetentionApprove puts a retention rule in force.
	PermRetentionApprove = "mrd.retention.approve"
	// PermHoldManage places and releases legal holds (SRS-MRD-005).
	PermHoldManage = "mrd.hold.manage"
	// PermDispositionPrepare builds a disposition list (SRS-MRD-009).
	PermDispositionPrepare = "mrd.disposition.prepare"
	// PermDispositionApprove is the last check before records stop existing.
	PermDispositionApprove = "mrd.disposition.approve"
	// PermDispositionExecute carries the destruction out. Separate from
	// approving it, because the person who signs and the person who shreds
	// are not the same person in any records office that has been audited.
	PermDispositionExecute = "mrd.disposition.execute"
	// PermPhysicalManage tracks paper records (SRS-MRD-006).
	PermPhysicalManage = "mrd.physical.manage"
	// PermFormWrite authors statutory certificate forms (SRS-MRD-007).
	PermFormWrite = "mrd.certificate.form.write"
	// PermFormApprove puts a form in force.
	PermFormApprove = "mrd.certificate.form.approve"
	// PermCertificateIssue issues and corrects a statutory certificate.
	// Held by the clinicians a jurisdiction lets sign one; the form's own
	// issuer role narrows it further, because who may sign a death
	// certificate is a statutory question and not one the hospital answers
	// by granting a permission.
	PermCertificateIssue = "mrd.certificate.issue"
	// PermCertificateVoid withdraws one that should not have been issued.
	PermCertificateVoid = "mrd.certificate.void"
)

// Events.
//
// Identifiers, kinds and counts. No document content, no diagnosis code
// against a named patient, no certificate values: an event stream is read by
// more systems and under fewer controls than the record it describes
// (SRS-API-009).
const (
	EventDeficiencyRaised    = "mrd_deficiency.raised"
	EventDeficiencyResolved  = "mrd_deficiency.resolved"
	EventDeficiencyWaived    = "mrd_deficiency.waived"
	EventChartComplete       = "mrd_chart.complete"
	EventCodingFinal         = "mrd_coding.final"
	EventCodingQueried       = "mrd_coding.queried"
	EventReleaseApproved     = "mrd_release.approved"
	EventReleaseSent         = "mrd_release.sent"
	EventDispositionExecuted = "mrd_disposition.executed"
	EventRecordMissing       = "mrd_physical.missing"
	EventCertificateIssued   = "mrd_certificate.issued"
	EventCertificateVoided   = "mrd_certificate.voided"
)

// The escalations this context raises.
const (
	// EscalationDeficiency is a chart deficiency past its date and its grace
	// period (SRS-MRD-002). It goes above the clinician who owes it, because
	// the ones that matter are the ones that have already been ignored.
	EscalationDeficiency = "mrd_deficiency_overdue"
	// EscalationMissingRecord is a paper record nobody can find
	// (SRS-MRD-006).
	EscalationMissingRecord = "mrd_record_missing"
)

// Config is what a deployment has decided about its records office.
type Config struct {
	// DeficiencyGrace is how long past its date a deficiency runs before it
	// escalates (SRS-MRD-002). Zero escalates the moment it is overdue,
	// which is a deployment that has decided there is no grace rather than
	// one that has not decided: the due dates come from the checklist.
	DeficiencyGrace time.Duration
	// AgingBands are the bands a deficiency report is cut into. Empty
	// reports no bands rather than inventing them: "old" means something
	// different for a discharge summary and for a coding query, and the
	// hospital that sends the letters is the one that decides.
	AgingBands []domain.AgeBucket
	// DefaultJurisdiction is whose retention law applies when an encounter's
	// facility does not say. Empty finds no retention rule and sweeps
	// nothing, which is visible in every disposition list as a record passed
	// over for want of a rule.
	DefaultJurisdiction string
	// RestrictedDocumentKinds are the kinds that stay out of a release
	// package unless it asked for them (SRS-MRD-004).
	RestrictedDocumentKinds []string
	// CodingSystems are the terminologies this deployment codes in, with the
	// edition in force. A code in a system not on this list is refused,
	// because a grouper reading ICD-10 against an ICD-11 code produces a
	// number rather than an error.
	CodingSystems map[string]string
}

// Service is the medical records use-case façade.
type Service struct {
	uow          ports.UnitOfWork
	checklists   ports.ChecklistRepository
	deficiencies ports.DeficiencyRepository
	coding       ports.CodingRepository
	releases     ports.ReleaseRepository
	retention    ports.RetentionRepository
	physical     ports.PhysicalRepository
	certificates ports.CertificateRepository

	documents   ports.ChartDocuments
	encounters  ports.Encounters
	holds       ports.LegalHolds
	inventory   ports.RecordInventory
	events      ports.EventAppender
	audit       ports.AuditAppender
	escalations ports.Escalator
	ids         ports.IDGenerator
	clock       ports.Clock
	config      Config
}

// Deps are the collaborators the service needs.
type Deps struct {
	UnitOfWork   ports.UnitOfWork
	Checklists   ports.ChecklistRepository
	Deficiencies ports.DeficiencyRepository
	Coding       ports.CodingRepository
	Releases     ports.ReleaseRepository
	Retention    ports.RetentionRepository
	Physical     ports.PhysicalRepository
	Certificates ports.CertificateRepository

	// Documents reads which clinical documents exist on an encounter. Nil
	// finds every chart complete, so the chart-completion use cases refuse
	// rather than report a gapless hospital.
	Documents ports.ChartDocuments
	// Encounters supplies the facts a checklist is judged against. Nil has
	// the same effect and the same refusal.
	Encounters ports.Encounters
	// Holds is the platform's legal-hold mechanism. Nil holds nothing, and
	// the disposition use cases refuse rather than destroy records whose
	// hold status is unknown.
	Holds ports.LegalHolds
	// Inventory lists the electronic records a retention sweep covers. Nil
	// sweeps the paper records this context owns and nothing else, which the
	// status document names.
	Inventory ports.RecordInventory
	Events    ports.EventAppender
	// AuditTrail is the platform's append-only trail.
	AuditTrail ports.AuditAppender
	// Escalations raises the notices an overdue deficiency and a missing
	// record produce. Nil records both and escalates neither.
	Escalations ports.Escalator
	IDs         ports.IDGenerator
	Clock       ports.Clock
	Config      Config
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, checklists: d.Checklists,
		deficiencies: d.Deficiencies, coding: d.Coding,
		releases: d.Releases, retention: d.Retention,
		physical: d.Physical, certificates: d.Certificates,
		documents: d.Documents, encounters: d.Encounters,
		holds: d.Holds, inventory: d.Inventory,
		events: d.Events, audit: d.AuditTrail, escalations: d.Escalations,
		ids: d.IDs, clock: d.Clock, config: d.Config,
	}
}

// Limits on what one request may ask for.
const (
	DefaultPageSize = 200
	MaxPageSize     = 1000
	// sweepPageSize bounds a retention sweep. A hospital's whole holding is
	// a batch job, not a query that pulls every record into memory.
	sweepPageSize = 5000
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
			"MRD_NO_SESSION", "this call needs an authenticated caller")
	}
	if !session.HasPermission(permission) {
		return authctx.Session{}, authctx.TenantScope{}, rpcerr.PermissionDenied(
			"MRD_FORBIDDEN", "this caller may not "+permission)
	}
	return session, session.TenantScope(), nil
}

// recordsError maps a domain refusal to the transport contract.
func recordsError(err error) error {
	if errors.Is(err, domain.ErrInvalidRecord) {
		return rpcerr.Invalid("MRD_INVALID", err.Error())
	}
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("MRD_VERSION_CONFLICT",
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
	eventSource        = "records"
)

func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateType, aggregateID string, payload map[string]any,
	now time.Time) error {

	if s.events == nil {
		return nil
	}
	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("MRD_EVENT_ENCODE_FAILED",
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
// A deployment with no escalator records the fact and carries on: a record
// nobody can find is still missing, and losing the record of it because the
// notice failed would be the worse outcome.
func (s *Service) escalate(ctx context.Context, session authctx.Session,
	scope authctx.TenantScope, n ports.Notice, now time.Time) error {

	if s.escalations == nil {
		return s.appendAudit(ctx, session, audit.Record{
			Action: "records.escalation.skipped", ResourceType: n.Kind,
			ResourceID: n.Subject, Outcome: audit.OutcomeSuccess,
			Reason: "no escalation channel is configured",
		}, now)
	}
	noticeID, err := s.escalations.Raise(ctx, scope, n, now)
	if err != nil {
		return err
	}
	return s.appendAudit(ctx, session, audit.Record{
		Action: "records.escalation.raised", ResourceType: n.Kind,
		ResourceID: n.Subject, Outcome: audit.OutcomeSuccess,
		Context: auditContext(map[string]string{"notice_id": noticeID}),
		Reason:  n.Summary,
	}, now)
}

// restricted reports a document kind a release package holds back unless the
// request asked for it (SRS-MRD-004).
func (s *Service) restricted(kind string) bool {
	for _, restricted := range s.config.RestrictedDocumentKinds {
		if strings.EqualFold(restricted, kind) {
			return true
		}
	}
	return false
}

// jurisdictionFor answers whose retention law an encounter's records follow,
// falling back to the deployment's default (SRS-MRD-009).
func (s *Service) jurisdictionFor(facts ports.EncounterFacts) string {
	if facts.Jurisdiction != "" {
		return facts.Jurisdiction
	}
	return s.config.DefaultJurisdiction
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
