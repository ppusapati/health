// Package application holds the facilities engineering use cases
// (SRS-FAC-001 … 011).
package application

import (
	"context"
	"encoding/json"
	"errors"
	"strconv"
	"time"

	"github.com/ppusapati/health/code/internal/facilities/domain"
	"github.com/ppusapati/health/code/internal/facilities/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Permissions.
//
// Four stand apart from the rest because of what they make possible.
//
// PermPermit lets somebody start work a hospital has decided is dangerous. It
// is separate from managing work because the question "who may isolate an
// eleven-kilovolt panel" has a shorter answer than "who may fix things".
//
// PermWorkClose signs off that work was done, and the domain refuses it to
// whoever did the work. Two permissions and one rule, because an engineer who
// holds both still cannot close their own job.
//
// PermOutageApprove signs a shutdown permit. Also separate, and also refused
// to the requester: the whole value of a permit is that somebody else looked.
//
// PermAlarmIngest is held by gateways and by nobody else. An alarm typed by a
// person would be a fabricated plant event in the record the command centre
// trusts precisely because it came off the plant.
const (
	// PermRead reads assets, work orders, schedules and alarms. Held
	// widely: a ward asking whether anybody is coming needs it.
	PermRead = "fac.read"
	// PermAssetManage registers plant and moves it between service states
	// (SRS-FAC-001).
	PermAssetManage = "fac.asset.manage"
	// PermWorkRaise raises a work order (SRS-FAC-002). Held very widely —
	// anybody who can see a leak should be able to report it — and that
	// is why impact and priority are recorded rather than assumed.
	PermWorkRaise = "fac.work.raise"
	// PermWorkManage assigns, starts, holds and resolves work
	// (SRS-FAC-002).
	PermWorkManage = "fac.work.manage"
	// PermWorkClose signs work off (SRS-FAC-002).
	PermWorkClose = "fac.work.close"
	// PermPermit starts work of a class that needs a permit to work or a
	// lockout-tagout reference (SRS-FAC-010).
	PermPermit = "fac.permit"
	// PermMaintenanceManage writes schedules and plans occurrences
	// (SRS-FAC-003).
	PermMaintenanceManage = "fac.maintenance.manage"
	// PermMaintenanceComplete records a task as done or waived
	// (SRS-FAC-003).
	PermMaintenanceComplete = "fac.maintenance.complete"
	// PermRuntimeWrite records an hour-counter reading (SRS-FAC-007).
	PermRuntimeWrite = "fac.runtime.write"
	// PermMeterWrite registers meters and records readings (SRS-FAC-009).
	PermMeterWrite = "fac.meter.write"
	// PermOutageRequest asks for a shutdown (SRS-FAC-004).
	PermOutageRequest = "fac.outage.request"
	// PermOutageApprove signs the shutdown permit (SRS-FAC-004).
	PermOutageApprove = "fac.outage.approve"
	// PermOutageAcknowledge answers for a department (SRS-FAC-004). Held
	// by ward and theatre managers rather than by estates, which is the
	// point: the people whose supply goes off are the ones who answer.
	PermOutageAcknowledge = "fac.outage.acknowledge"
	// PermAlarmIngest accepts an event from a gateway (SRS-FAC-005).
	PermAlarmIngest = "fac.alarm.ingest"
	// PermAlarmManage acknowledges, clears and links an alarm
	// (SRS-FAC-005).
	PermAlarmManage = "fac.alarm.manage"
	// PermSafetyRaise records a fire or life-safety deficiency
	// (SRS-FAC-008).
	PermSafetyRaise = "fac.safety.raise"
	// PermSafetyClose certifies one fixed (SRS-FAC-008). Separate from
	// raising, and the domain refuses a critical closure to whoever found
	// it.
	PermSafetyClose = "fac.safety.close"
	// PermVendorManage signs contractors in and out (SRS-FAC-011).
	PermVendorManage = "fac.vendor.manage"
	// PermReportRead reads the KPI and compliance reports (SRS-FAC-009).
	PermReportRead = "fac.report.read"
)

// Events.
//
// Identifiers, systems and states. No patient, no ward occupancy, no fault
// text: an event stream is read by more systems and under fewer controls than
// the record it describes (SRS-API-009), and a facilities event carrying
// "theatre 2 cancelled" is a piece of operational intelligence on a message
// bus.
const (
	EventWorkRaised       = "facilities_work_order.raised"
	EventWorkClosed       = "facilities_work_order.closed"
	EventOutageInEffect   = "facilities_outage.in_effect"
	EventOutageRestored   = "facilities_outage.restored"
	EventAlarmRaised      = "facilities_alarm.raised"
	EventDeficiencyRaised = "facilities_deficiency.raised"
)

// The escalation chains this context raises on.
//
// The strings match the kinds SRS-FAC-012's matrix is keyed by, because a
// context that invented its own would escalate to a matrix nobody configured
// and the notice would go nowhere.
const (
	EscalationMedicalGas = "medical_gas"
	EscalationFireSafety = "fire_safety"
	EscalationFacilities = "facilities"
)

// Config is what a deployment has decided about its facilities function.
type Config struct {
	// SLA is the response and resolution policy SRS-FAC-002 asks for. Its
	// zero value falls back to domain.DefaultSLAPolicy, because a
	// deployment that has not yet held the meeting about response times
	// still raises tickets and they still need deadlines.
	SLA domain.SLAPolicy
	// Routing decides which team owns work on each system. A ticket with
	// no owner waits for somebody to notice it, so this always resolves:
	// the system's team, or DefaultTeam.
	Routing map[domain.System]string
	// DefaultTeam catches systems Routing does not name. Empty means
	// "facilities", which is wrong for a big hospital and right for one
	// that has not configured anything.
	DefaultTeam string
	// RequireKnownOrgUnit refuses an asset or an outage area naming a
	// department the organization context does not have. Off by default,
	// because a plant room on a roof is genuinely not an org unit.
	RequireKnownOrgUnit bool
	// EscalateCriticalGas sends a critical medical gas emergency straight
	// to the top configured rung (SRS-FAC-006). On by default in effect —
	// the zero value is false, so a deployment must ask for it — but the
	// status document says so rather than the code pretending otherwise.
	EscalateCriticalGas bool
	// DeficiencyGraceDays is how long past its date a critical life-safety
	// finding may sit before the sweep escalates it (SRS-FAC-008).
	DeficiencyGraceDays int
}

// slaPolicy resolves the configured policy or the default.
func (c Config) slaPolicy() domain.SLAPolicy {
	if len(c.SLA.Targets) == 0 {
		return domain.DefaultSLAPolicy()
	}
	return c.SLA
}

// team routes a system to an owner. It always answers, because SRS-FAC-002's
// acceptance is that the ticket receives one.
func (c Config) team(system domain.System) string {
	if named, ok := c.Routing[system]; ok && named != "" {
		return named
	}
	if c.DefaultTeam != "" {
		return c.DefaultTeam
	}
	return "facilities"
}

// Service is the facilities use-case façade.
type Service struct {
	uow ports.UnitOfWork

	assets       ports.AssetRepository
	classes      ports.WorkClassRepository
	work         ports.WorkOrderRepository
	maintenance  ports.MaintenanceRepository
	runtime      ports.RuntimeRepository
	meters       ports.MeterRepository
	outages      ports.OutageRepository
	alarms       ports.AlarmRepository
	deficiencies ports.DeficiencyRepository
	visits       ports.VisitRepository

	orgUnits    ports.OrgUnits
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
	Assets       ports.AssetRepository
	Classes      ports.WorkClassRepository
	Work         ports.WorkOrderRepository
	Maintenance  ports.MaintenanceRepository
	Runtime      ports.RuntimeRepository
	Meters       ports.MeterRepository
	Outages      ports.OutageRepository
	Alarms       ports.AlarmRepository
	Deficiencies ports.DeficiencyRepository
	Visits       ports.VisitRepository

	// OrgUnits resolves the departments an asset sits in and an outage
	// reaches. Nil accepts whatever it is given, which the status
	// document says out loud.
	OrgUnits ports.OrgUnits
	Events   ports.EventAppender
	// AuditTrail is the platform's append-only trail.
	AuditTrail ports.AuditAppender
	// Escalations raises the notices a critical gas failure and an overdue
	// life-safety finding produce. Nil records the attempt and escalates
	// nothing.
	Escalations ports.Escalator
	IDs         ports.IDGenerator
	Clock       ports.Clock
	Config      Config
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, assets: d.Assets, classes: d.Classes,
		work: d.Work, maintenance: d.Maintenance, runtime: d.Runtime,
		meters: d.Meters, outages: d.Outages, alarms: d.Alarms,
		deficiencies: d.Deficiencies, visits: d.Visits,
		orgUnits: d.OrgUnits, events: d.Events, audit: d.AuditTrail,
		escalations: d.Escalations,
		ids:         d.IDs, clock: d.Clock, config: d.Config,
	}
}

// Limits on what one request may ask for.
const (
	DefaultPageSize = 200
	MaxPageSize     = 1000
	// reportPageSize bounds one report read. A hospital with more open
	// work than this has a problem no page size will fix.
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
			rpcerr.Unauthenticated("FAC_NO_SESSION",
				"this call needs an authenticated caller")
	}
	if !session.HasPermission(permission) {
		return authctx.Session{}, authctx.TenantScope{},
			rpcerr.PermissionDenied("FAC_FORBIDDEN",
				"this caller may not "+permission)
	}
	return session, session.TenantScope(), nil
}

// facilitiesError maps a domain refusal to the transport contract.
func facilitiesError(err error) error {
	if errors.Is(err, domain.ErrInvalidFacilities) {
		return rpcerr.Invalid("FAC_INVALID", err.Error())
	}
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("FAC_VERSION_CONFLICT",
			"somebody else changed this record; re-read it and try again")
	}
	return err
}

// forbidden refuses a caller who lacks a permission the call needs beyond the
// one that let them in.
func forbidden(permission string) error {
	return rpcerr.PermissionDenied("FAC_FORBIDDEN",
		"this caller may not "+permission)
}

// checkOrgUnit refuses a department nobody can resolve (SRS-FAC-001,
// SRS-FAC-004).
func (s *Service) checkOrgUnit(ctx context.Context,
	scope authctx.TenantScope, orgUnitID string) error {

	if !s.config.RequireKnownOrgUnit || orgUnitID == "" {
		return nil
	}
	if s.orgUnits == nil {
		return rpcerr.FailedPrecondition("FAC_NO_ORG_DIRECTORY",
			"this deployment requires a known department, "+
				"but no organization directory is configured")
	}
	exists, err := s.orgUnits.Exists(ctx, scope, orgUnitID)
	if err != nil {
		// A directory that is down must not read as a directory that
		// says no: refusing every asset because a lookup timed out is
		// worse than the check being unavailable.
		return err
	}
	if !exists {
		return rpcerr.FailedPrecondition("FAC_NO_SUCH_ORG_UNIT",
			"no department "+orgUnitID+" to attach this to")
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
	eventSource        = "facilities"
)

func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateType, aggregateID string, payload map[string]any,
	now time.Time) error {

	if s.events == nil {
		return nil
	}
	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("FAC_EVENT_ENCODE_FAILED",
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
// A deployment with no escalator records the fact and carries on: an empty
// oxygen manifold is still an empty oxygen manifold, and losing the record
// that nobody was paged would be the worse outcome.
func (s *Service) escalate(ctx context.Context, session authctx.Session,
	scope authctx.TenantScope, n ports.Notice, now time.Time) error {

	if s.escalations == nil {
		return s.appendAudit(ctx, session, audit.Record{
			Action: "facilities.escalation.skipped", ResourceType: n.Kind,
			ResourceID: n.Subject, Outcome: audit.OutcomeSuccess,
			Reason: "no escalation channel is configured",
		}, now)
	}
	noticeID, err := s.escalations.Raise(ctx, scope, n, now)
	if err != nil {
		return err
	}
	return s.appendAudit(ctx, session, audit.Record{
		Action: "facilities.escalation.raised", ResourceType: n.Kind,
		ResourceID: n.Subject, Outcome: audit.OutcomeSuccess,
		Context: auditContext(map[string]string{
			"notice_id": noticeID, "level": itoa(n.Level),
		}),
		Reason: n.Summary,
	}, now)
}

// topRung asks the escalation matrix how high its chain goes (SRS-FAC-006).
//
// A matrix nobody configured answers zero, which is the ordinary rung and the
// honest answer: a hospital that has not written down who to call cannot be
// given a top of its chain, and inventing one would page nobody while looking
// like it had paged somebody senior.
func (s *Service) topRung(ctx context.Context, scope authctx.TenantScope,
	kind, facilityID string) int {

	if s.escalations == nil {
		return 0
	}
	top, err := s.escalations.Top(ctx, scope, kind, facilityID)
	if err != nil || top < 0 {
		return 0
	}
	return top
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
