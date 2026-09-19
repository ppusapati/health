// Package application holds the infection prevention and control use cases
// (SRS-IPC-001 … 010).
package application

import (
	"context"
	"encoding/json"
	"errors"
	"strconv"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/infection/domain"
	"github.com/ppusapati/health/code/internal/infection/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Permissions.
//
// Four stand alone because they are the steps this context is answerable for:
// overriding an onset classification, approving a rule, reading an
// occupational exposure, and recording a prescriber's response to stewardship
// advice. Each makes something possible that was not, and each is where a
// number a hospital reports could be altered by one person.
const (
	// PermRead reads surveillance cases, outbreaks, rates and environmental
	// results.
	PermRead = "ipc.record.read"
	// PermBoard reads the bed board (SRS-IPC-003). Separate from PermRead and
	// held far more widely: every nurse on a ward needs to know what to wear
	// outside a bay, and none of them needs the surveillance record to know
	// it. The board carries the precaution and never the reason.
	PermBoard = "ipc.board.read"
	// PermCase opens and reviews surveillance cases (SRS-IPC-001).
	PermCase = "ipc.case.write"
	// PermOverrideOnset disagrees with the derived classification
	// (SRS-IPC-001). Its own permission, because reclassifying a
	// healthcare-associated infection as community-acquired removes it from
	// the hospital's rate, and that is the single easiest way to make
	// infection surveillance look good.
	PermOverrideOnset = "ipc.onset.override"
	// PermDenominator records the daily device census (SRS-IPC-002). Held by
	// the ward: the denominator is a count somebody takes at the bedside.
	PermDenominator = "ipc.denominator.record"
	// PermIsolation places and lifts precautions (SRS-IPC-003).
	PermIsolation = "ipc.isolation.write"
	// PermRuleWrite authors alert rules, stewardship triggers and
	// environmental limits (SRS-IPC-004, 008, 009).
	PermRuleWrite = "ipc.rule.write"
	// PermRuleApprove puts a rule in force. Its own permission, and holding
	// it is necessary and not sufficient: the domain and the database both
	// refuse the author whoever they are.
	PermRuleApprove = "ipc.rule.approve"
	// PermAlertOverride decides an alert does not apply here (SRS-IPC-004).
	// Held by clinicians, and every use is audited.
	PermAlertOverride = "ipc.alert.override"
	// PermOutbreak runs cluster investigations (SRS-IPC-005).
	PermOutbreak = "ipc.outbreak.manage"
	// PermHygiene records hand hygiene observation (SRS-IPC-006).
	PermHygiene = "ipc.hygiene.observe"
	// PermExposureReport reports an occupational exposure (SRS-IPC-007). Held
	// as widely as any permission here: a reporting route only occupational
	// health can write to receives nothing, and an unreported needlestick is
	// an untreated one.
	PermExposureReport = "ipc.exposure.report"
	// PermExposureManage reads and works exposure records (SRS-IPC-007). Its
	// own permission because these are staff health records held by their
	// employer with a source patient's serology in them, and every read under
	// it is audited.
	PermExposureManage = "ipc.exposure.manage"
	// PermStewardshipReview answers a stewardship review (SRS-IPC-008).
	PermStewardshipReview = "ipc.stewardship.review"
	// PermStewardshipRespond records what the prescriber did about the advice
	// (SRS-IPC-008). Separate from reviewing, because the whole requirement
	// is that the team advises and somebody with prescribing authority
	// decides.
	PermStewardshipRespond = "ipc.stewardship.respond"
	// PermEnvironment collects environmental samples and files results
	// (SRS-IPC-009).
	PermEnvironment = "ipc.environment.sample"
	// PermEnvironmentAct raises and verifies corrective actions
	// (SRS-IPC-009). Held by estates, who do the work.
	PermEnvironmentAct = "ipc.environment.act"
)

// Events.
//
// Identifiers, codes and counts. No narrative, no organism against a named
// patient, nothing from an exposure record beyond the fact that one exists:
// an event stream is read by more systems and under fewer controls than the
// record it describes (SRS-API-009).
const (
	EventCaseOpened       = "ipc_case.opened"
	EventCaseConfirmed    = "ipc_case.confirmed"
	EventOnsetOverridden  = "ipc_case.onset_overridden"
	EventAlertRaised      = "ipc_alert.raised"
	EventIsolationStarted = "ipc_isolation.started"
	EventIsolationEnded   = "ipc_isolation.ended"
	EventOutbreakDeclared = "ipc_outbreak.declared"
	EventOutbreakClosed   = "ipc_outbreak.closed"
	EventExposureReported = "ipc_exposure.reported"
	EventReviewRaised     = "ipc_stewardship.review_raised"
	EventResultFailed     = "ipc_environment.result_failed"
)

// The escalations this context raises.
const (
	// EscalationOutbreak is a cluster the hospital has declared
	// (SRS-IPC-005).
	EscalationOutbreak = "ipc_outbreak_declared"
	// EscalationExposureStep is a time-sensitive follow-up step past the
	// point it stops being useful (SRS-IPC-007). The subject is the exposure
	// reference, never the member of staff.
	EscalationExposureStep = "ipc_exposure_step_overdue"
	// EscalationEnvironment is a failed environmental result where the
	// hospital has said a failure cannot wait (SRS-IPC-009).
	EscalationEnvironment = "ipc_environment_failure"
)

// Config is what a deployment has decided about its infection control.
type Config struct {
	// SurveillanceWindowHours is how long after admission an infection is
	// still counted as present on arrival (SRS-IPC-001). Zero classifies
	// every case as indeterminate rather than guessing, which is a deployment
	// that has not decided and is visible as such in every report.
	SurveillanceWindowHours int
	// MDROOrganismCodes are the organism codes on the hospital's
	// multidrug-resistant list (SRS-IPC-004). A case's flag is set from this
	// rather than typed, so adding an organism does not mean re-keying every
	// case.
	MDROOrganismCodes []string
	// IsolationReviewAfter is how long precautions run before somebody must
	// reconsider them (SRS-IPC-003). Zero leaves no review date, and the
	// board reports that as a gap rather than as "review never needed".
	IsolationReviewAfter time.Duration
	// MinimumHygieneObservations is the group size below which a compliance
	// figure is suppressed (SRS-IPC-006). Zero publishes everything, which is
	// a deployment that has not decided: a category with four observations on
	// a night shift is one individual with extra steps.
	MinimumHygieneObservations int
	// StewardshipDueWithin is how long a raised review stays useful
	// (SRS-IPC-008). Zero leaves no clock, and an unanswered review then
	// never appears as overdue.
	StewardshipDueWithin time.Duration
	// AugmentedCareLocations are the places where a failed environmental
	// result is escalated rather than queued (SRS-IPC-009) — the units whose
	// patients cannot wait for the next estates round.
	AugmentedCareLocations []string
	// IndicatorForSite maps an infection site to the code of an indicator in
	// the quality context's versioned dictionary (SRS-IPC-010, SRS-QMS-010).
	// A site with no entry is computed and reported here and not published,
	// which the status document names.
	IndicatorForSite map[domain.InfectionSite]string
	// HandHygieneIndicator and StewardshipIndicator are the same for the two
	// programme measures.
	HandHygieneIndicator string
	StewardshipIndicator string
}

// Service is the infection control use-case façade.
type Service struct {
	uow         ports.UnitOfWork
	cases       ports.CaseRepository
	deviceDays  ports.DeviceDayRepository
	isolations  ports.IsolationRepository
	alerts      ports.AlertRepository
	outbreaks   ports.OutbreakRepository
	hygiene     ports.HygieneRepository
	exposures   ports.ExposureRepository
	stewardship ports.StewardshipRepository
	environment ports.EnvironmentRepository

	therapy     ports.Therapy
	indicators  ports.Indicators
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
	DeviceDays  ports.DeviceDayRepository
	Isolations  ports.IsolationRepository
	Alerts      ports.AlertRepository
	Outbreaks   ports.OutbreakRepository
	Hygiene     ports.HygieneRepository
	Exposures   ports.ExposureRepository
	Stewardship ports.StewardshipRepository
	Environment ports.EnvironmentRepository

	// Therapy reads what a patient is on, for the stewardship triggers. Nil
	// raises no reviews, which is a stewardship programme with no input —
	// named in the status document rather than silently empty.
	Therapy ports.Therapy
	// Indicators publishes computed rates into the quality context's
	// versioned dictionary (SRS-IPC-010). Nil computes the rates and
	// publishes nothing.
	Indicators ports.Indicators
	Events     ports.EventAppender
	// AuditTrail is the platform's append-only trail.
	AuditTrail ports.AuditAppender
	// Escalations raises the notices an outbreak, an overdue exposure step
	// and a failed environmental result produce. Nil records all three and
	// escalates none.
	Escalations ports.Escalator
	IDs         ports.IDGenerator
	Clock       ports.Clock
	Config      Config
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, cases: d.Cases, deviceDays: d.DeviceDays,
		isolations: d.Isolations, alerts: d.Alerts, outbreaks: d.Outbreaks,
		hygiene: d.Hygiene, exposures: d.Exposures,
		stewardship: d.Stewardship, environment: d.Environment,
		therapy: d.Therapy, indicators: d.Indicators,
		events: d.Events, audit: d.AuditTrail, escalations: d.Escalations,
		ids: d.IDs, clock: d.Clock, config: d.Config,
	}
}

// Limits on what one request may ask for.
const (
	DefaultPageSize = 200
	MaxPageSize     = 1000
	// reportPageSize bounds a derived report. A month's rates across a
	// hospital is a report, not a query that pulls every case into memory.
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
			"IPC_NO_SESSION", "this call needs an authenticated caller")
	}
	if !session.HasPermission(permission) {
		return authctx.Session{}, authctx.TenantScope{}, rpcerr.PermissionDenied(
			"IPC_FORBIDDEN", "this caller may not "+permission)
	}
	return session, session.TenantScope(), nil
}

// infectionError maps a domain refusal to the transport contract.
func infectionError(err error) error {
	if errors.Is(err, domain.ErrInvalidInfection) {
		return rpcerr.Invalid("IPC_INVALID", err.Error())
	}
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("IPC_VERSION_CONFLICT",
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
	eventSource        = "infection"
)

func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateType, aggregateID string, payload map[string]any,
	now time.Time) error {

	if s.events == nil {
		return nil
	}
	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("IPC_EVENT_ENCODE_FAILED",
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
// A deployment with no escalator records the fact and carries on: an outbreak
// that could not be announced is still an outbreak, and losing the record of
// it because the notice failed would be the worse outcome.
func (s *Service) escalate(ctx context.Context, session authctx.Session,
	scope authctx.TenantScope, n ports.Notice, now time.Time) error {

	if s.escalations == nil {
		return s.appendAudit(ctx, session, audit.Record{
			Action: "infection.escalation.skipped", ResourceType: n.Kind,
			ResourceID: n.Subject, Outcome: audit.OutcomeSuccess,
			Reason: "no escalation channel is configured",
		}, now)
	}
	noticeID, err := s.escalations.Raise(ctx, scope, n, now)
	if err != nil {
		return err
	}
	return s.appendAudit(ctx, session, audit.Record{
		Action: "infection.escalation.raised", ResourceType: n.Kind,
		ResourceID: n.Subject, Outcome: audit.OutcomeSuccess,
		Context: auditContext(map[string]string{"notice_id": noticeID}),
		Reason:  n.Summary,
	}, now)
}

// readExposure decides whether a caller may see an occupational exposure and
// audits the read (SRS-IPC-007).
//
// The audit is the point. A staff health record that can be read without a
// trace is restricted in name only.
func (s *Service) readExposure(ctx context.Context, session authctx.Session,
	exposureID string, now time.Time) error {

	if !session.HasPermission(PermExposureManage) {
		return rpcerr.PermissionDenied("IPC_FORBIDDEN",
			"this caller may not "+PermExposureManage)
	}
	return s.appendAudit(ctx, session, audit.Record{
		Action: "infection.exposure.read", ResourceType: "ipc_exposure",
		ResourceID: exposureID, Outcome: audit.OutcomeSuccess,
		Reason: "read an occupational exposure record",
	}, now)
}

// multidrugResistant answers the configured list rather than the caller
// (SRS-IPC-004).
func (s *Service) multidrugResistant(organismCode string) bool {
	for _, code := range s.config.MDROOrganismCodes {
		if strings.EqualFold(code, organismCode) {
			return true
		}
	}
	return false
}

// augmentedCare reports a location where a failed environmental result cannot
// wait for the next estates round (SRS-IPC-009).
func (s *Service) augmentedCare(locationID string) bool {
	for _, id := range s.config.AugmentedCareLocations {
		if strings.EqualFold(id, locationID) {
			return true
		}
	}
	return false
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
