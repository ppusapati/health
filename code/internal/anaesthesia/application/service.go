// Package application holds the anaesthesia use cases (SRS-ANE-001 … 011).
package application

import (
	"context"
	"encoding/json"
	"errors"
	"strconv"
	"time"

	"github.com/ppusapati/health/code/internal/anaesthesia/domain"
	"github.com/ppusapati/health/code/internal/anaesthesia/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Permissions.
//
// Split along the jobs rather than along the tables. The three that stand
// alone are the ones a hospital is most answerable for: discharging a patient
// from recovery below the agreed score, transcribing a record from paper after
// a downtime, and reading a patient's anaesthetic history from outside their
// current admission.
const (
	// PermRead reads an assessment, a plan, a record and a summary.
	PermRead = "ane.record.read"
	// PermAssess records or revises a pre-anaesthesia assessment
	// (SRS-ANE-001).
	PermAssess = "ane.assessment.write"
	// PermPlan records the anaesthetic plan (SRS-ANE-002).
	PermPlan = "ane.plan.write"
	// PermChart opens a record and charts against it — values, drugs, airway,
	// fluids (SRS-ANE-003 … 007).
	PermChart = "ane.record.chart"
	// PermRecover scores a patient in recovery and discharges one who meets
	// the bar (SRS-ANE-008).
	PermRecover = "ane.recovery.write"
	// PermOverride discharges a patient who does not meet the bar. Its own
	// permission because it is the decision a complaint is traced back to, and
	// the domain still requires a reason: a system where every gate has a
	// general override has no gates.
	PermOverride = "ane.recovery.override"
	// PermPrescribePain records the post-operative pain plan (SRS-ANE-009).
	PermPrescribePain = "ane.pain.write"
	// PermImport transcribes a record made on paper during a downtime
	// (SRS-ANE-011). Its own permission because an imported record is
	// backdated by construction.
	PermImport = "ane.record.import"
	// PermHistory reads a patient's anaesthetic history across admissions,
	// which is a different kind of access from reading the case in front of
	// you.
	PermHistory = "ane.history.read"
)

// Events.
//
// Identifiers, codes and times. No history, no risks, no summary text: an
// event stream is read by more systems and under fewer controls than the
// record it describes (SRS-API-009).
const (
	EventAssessmentRecorded = "anaesthesia_assessment.recorded"
	EventRecordOpened       = "anaesthesia_record.opened"
	EventRecordImported     = "anaesthesia_record.imported"
	EventAnaesthesiaEnded   = "anaesthesia_record.ended"
	// EventDifficultAirway is the one intraoperative event worth telling other
	// systems about: the next anaesthetist needs it, and they are frequently
	// not in this one.
	EventDifficultAirway   = "anaesthesia_airway.difficult"
	EventHandedOver        = "anaesthesia_record.handed_over"
	EventRecoveryDischarge = "anaesthesia_recovery.discharged"
	EventDischargeOverride = "anaesthesia_recovery.override"
	EventPainOrdered       = "anaesthesia_pain.ordered"
)

// Config is what a deployment has decided about its anaesthesia service.
type Config struct {
	// RecoveryScale is the score this unit discharges from recovery on. Zero
	// takes the modified Aldrete score, which most units use; a unit that has
	// agreed another configures it rather than waiting for an enumeration.
	RecoveryScale domain.RecoveryScale
	// KeyDrugCodes are the drugs a summary calls out — reversal agents,
	// vasopressors, antibiotics. Which drugs matter is a deployment's
	// decision, and a summary of a four-hour case cannot be every entry.
	KeyDrugCodes []string
	// DifficultAirwayAttempts is how many attempts make an airway difficult.
	// Zero takes the domain's default of two.
	DifficultAirwayAttempts int
}

func (c Config) scale() domain.RecoveryScale {
	if len(c.RecoveryScale.Components) == 0 {
		return domain.Aldrete()
	}
	return c.RecoveryScale
}

func (c Config) keyDrugs() map[string]bool {
	set := make(map[string]bool, len(c.KeyDrugCodes))
	for _, code := range c.KeyDrugCodes {
		set[code] = true
	}
	return set
}

// Service is the anaesthesia use-case façade.
type Service struct {
	uow         ports.UnitOfWork
	assessments ports.AssessmentRepository
	records     ports.RecordRepository
	recovery    ports.RecoveryRepository
	cases       ports.Cases
	events      ports.EventAppender
	audits      ports.AuditAppender
	ids         ports.IDGenerator
	clock       ports.Clock
	config      Config
}

// Deps are the collaborators the service needs.
type Deps struct {
	UnitOfWork  ports.UnitOfWork
	Assessments ports.AssessmentRepository
	Records     ports.RecordRepository
	Recovery    ports.RecoveryRepository
	// Cases reports what the theatre knows about the operation. Nil makes the
	// case check unavailable, which is visible in the status document rather
	// than hidden here.
	Cases  ports.Cases
	Events ports.EventAppender
	Audits ports.AuditAppender
	IDs    ports.IDGenerator
	Clock  ports.Clock
	Config Config
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, assessments: d.Assessments, records: d.Records,
		recovery: d.Recovery, cases: d.Cases,
		events: d.Events, audits: d.Audits,
		ids: d.IDs, clock: d.Clock, config: d.Config,
	}
}

// Limits on what one request may ask for.
const (
	DefaultPageSize = 200
	MaxPageSize     = 1000
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
			"ANE_NO_SESSION", "this call needs an authenticated caller")
	}
	if !session.HasPermission(permission) {
		return authctx.Session{}, authctx.TenantScope{}, rpcerr.PermissionDenied(
			"ANE_FORBIDDEN", "this caller may not "+permission)
	}
	return session, session.TenantScope(), nil
}

// anaesthesiaError maps a domain refusal to the transport contract.
func anaesthesiaError(err error) error {
	if errors.Is(err, domain.ErrInvalidRecord) {
		return rpcerr.Invalid("ANE_INVALID", err.Error())
	}
	if errors.Is(err, ports.ErrNotFound) {
		return rpcerr.NotFound("ANE_NOT_FOUND", "no such anaesthetic record")
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

const (
	eventSchemaVersion = 1
	eventSource        = "anaesthesia"
)

func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateType, aggregateID string, payload map[string]any,
	now time.Time) error {

	if s.events == nil {
		return nil
	}
	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("ANE_EVENT_ENCODE_FAILED", "could not encode event").
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

// openCase reads the theatre's case and refuses one that has closed.
//
// Nil Cases returns the identifiers the caller supplied and no refusal: a
// deployment without the theatre context wired is one where anaesthesia is
// used alone, and refusing every call would be worse than not checking.
func (s *Service) openCase(ctx context.Context, scope authctx.TenantScope,
	caseID, patientID, encounterID string) (string, string, error) {

	if s.cases == nil {
		return patientID, encounterID, nil
	}
	foundPatient, foundEncounter, writable, err := s.cases.Case(ctx, scope, caseID)
	if err != nil {
		return "", "", err
	}
	if !writable {
		return "", "", rpcerr.FailedPrecondition("ANE_CASE_CLOSED",
			"this case is closed; charting against it would record entries "+
				"made after the patient left")
	}
	return foundPatient, foundEncounter, nil
}

// openRecord reads a record and refuses one that has been closed.
func (s *Service) openRecord(ctx context.Context, scope authctx.TenantScope,
	recordID string) (domain.Record, error) {

	record, err := s.records.Record(ctx, scope, recordID)
	if err != nil {
		return domain.Record{}, err
	}
	if record.Status == domain.RecordClosed {
		return domain.Record{}, rpcerr.FailedPrecondition("ANE_RECORD_CLOSED",
			"this anaesthetic record is closed")
	}
	return record, nil
}

// itoa keeps audit reasons readable without importing fmt for one number.
func itoa(n int) string { return strconv.Itoa(n) }
