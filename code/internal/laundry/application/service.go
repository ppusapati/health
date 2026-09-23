// Package application holds the laundry and linen use cases
// (SRS-LND-001 … 007).
package application

import (
	"context"
	"encoding/json"
	"errors"
	"strconv"
	"time"

	"github.com/ppusapati/health/code/internal/laundry/domain"
	"github.com/ppusapati/health/code/internal/laundry/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Permissions.
//
// Two stand apart from the rest because of what they make possible.
// PermIssue sends linen back to a ward, which is the moment a wash's outcome
// stops being a record and becomes a made bed. PermApproveLoss writes linen
// off a unit's balance, which is the only way a ward's shortfall gets smaller
// without any linen arriving.
const (
	// PermRead reads the master, the pars, the worklist and one record.
	// Held widely: a ward clerk asking what the ward is short of needs it.
	PermRead = "lnd.read"
	// PermMasterManage configures the linen item master and drafts par
	// levels (SRS-LND-001).
	PermMasterManage = "lnd.master.manage"
	// PermParApprove puts a par level in force. Separate from drafting one,
	// because a par decides what a ward may hold and therefore what the
	// laundry buys. The domain also refuses the author, so holding both is
	// still not enough to approve your own.
	PermParApprove = "lnd.par.approve"
	// PermCollect records soiled linen leaving a unit (SRS-LND-002). Held
	// by the ward as well as the laundry: the count that matters for
	// infected linen is made at the bedside.
	PermCollect = "lnd.collect"
	// PermWash opens, loads, runs and closes wash batches (SRS-LND-003).
	PermWash = "lnd.wash"
	// PermIssue sends clean linen back to a unit (SRS-LND-004).
	PermIssue = "lnd.issue"
	// PermReceive signs for linen on the unit. Separate from issuing it,
	// because a delivery signed for by the porter who brought it is the
	// same claim made twice.
	PermReceive = "lnd.receive"
	// PermReportLoss reports condemned, damaged or missing linen
	// (SRS-LND-006). Held as widely as any permission here: a write-off
	// only a manager can report is linen that quietly disappears instead.
	PermReportLoss = "lnd.loss.report"
	// PermApproveLoss authorises or refuses a write-off. Its own
	// permission and every use audited: this is the decision an inventory
	// investigation reads first.
	PermApproveLoss = "lnd.loss.approve"
	// PermTrackManage registers and retires tags (SRS-LND-007).
	PermTrackManage = "lnd.track.manage"
	// PermTrackScan records a movement. Wider than managing tags, because
	// every reader in the building records one.
	PermTrackScan = "lnd.track.scan"
	// PermReportRead reads the wash, balance and loss reports
	// (SRS-LND-003, SRS-LND-004, SRS-LND-006).
	PermReportRead = "lnd.report.read"
)

// Events.
//
// Identifiers, codes and counts. No unit narrative, no patient, no reason
// text: an event stream is read by more systems and under fewer controls than
// the record it describes (SRS-API-009).
const (
	EventCollectionRecorded = "linen_collection.recorded"
	EventBatchPassed        = "wash_batch.passed"
	EventBatchFailed        = "wash_batch.failed"
	EventLinenIssued        = "linen_issue.issued"
	EventLossApproved       = "linen_loss.approved"
)

// The escalations this context raises.
const (
	// EscalationFailedWash is a wash that did not pass. The one thing here
	// that cannot wait for somebody to open a screen: the units whose linen
	// was in it may already be making beds with it.
	EscalationFailedWash = "linen_wash_failed"
)

// Config is what a deployment has decided about its laundry.
type Config struct {
	// LossApprovalThresholdMinor is the value at or above which a write-off
	// goes on somebody's approval worklist. Every write-off still needs a
	// second person; what this changes is which ones are chased. Zero flags
	// them all, which is a deployment that has not decided and is the safe
	// direction.
	LossApprovalThresholdMinor int
	// RequireKnownUnit refuses a par level or a collection for a unit the
	// organisation does not have. Linen recorded against a ward that is not
	// there is a balance nobody can reconcile.
	RequireKnownUnit bool
	// StaleTrackedAfter is how long a tagged item may go unscanned before
	// it appears on the stale report. Zero produces no report rather than
	// every item in the hospital.
	StaleTrackedAfter time.Duration
}

// Service is the laundry use-case façade.
type Service struct {
	uow         ports.UnitOfWork
	items       ports.ItemRepository
	pars        ports.ParRepository
	collections ports.CollectionRepository
	batches     ports.BatchRepository
	issues      ports.IssueRepository
	losses      ports.LossRepository
	tracked     ports.TrackedRepository

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
	UnitOfWork  ports.UnitOfWork
	Items       ports.ItemRepository
	Pars        ports.ParRepository
	Collections ports.CollectionRepository
	Batches     ports.BatchRepository
	Issues      ports.IssueRepository
	Losses      ports.LossRepository
	Tracked     ports.TrackedRepository

	// Units resolves the ward a par or a collection names. Nil accepts
	// whatever it is given, which the status document says out loud.
	Units  ports.Units
	Events ports.EventAppender
	// AuditTrail is the platform's append-only trail.
	AuditTrail ports.AuditAppender
	// Escalations raises the notice a failed wash produces. Nil records it
	// and escalates nothing.
	Escalations ports.Escalator
	IDs         ports.IDGenerator
	Clock       ports.Clock
	Config      Config
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, items: d.Items, pars: d.Pars,
		collections: d.Collections, batches: d.Batches,
		issues: d.Issues, losses: d.Losses, tracked: d.Tracked,
		units: d.Units, events: d.Events, audit: d.AuditTrail,
		escalations: d.Escalations,
		ids:         d.IDs, clock: d.Clock, config: d.Config,
	}
}

// Limits on what one request may ask for.
const (
	DefaultPageSize = 200
	MaxPageSize     = 1000
	// facilityPageSize bounds a whole-facility read. A site with more
	// cleanable units than this is one somebody should split by building.
	facilityPageSize = 5000
	// reportPageSize bounds one report. A window holding more rows than
	// this comes back marked truncated rather than silently summarised from
	// part of itself.
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
			rpcerr.Unauthenticated("LND_NO_SESSION",
				"this call needs an authenticated caller")
	}
	if !session.HasPermission(permission) {
		return authctx.Session{}, authctx.TenantScope{},
			rpcerr.PermissionDenied("LND_FORBIDDEN",
				"this caller may not "+permission)
	}
	return session, session.TenantScope(), nil
}

// laundryError maps a domain refusal to the transport contract.
func laundryError(err error) error {
	if errors.Is(err, domain.ErrInvalidLaundry) {
		return rpcerr.Invalid("LND_INVALID", err.Error())
	}
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("LND_VERSION_CONFLICT",
			"somebody else changed this record; re-read it and try again")
	}
	return err
}

// checkUnit refuses a record for a unit the organisation does not have
// (SRS-LND-001, SRS-LND-002).
//
// Linen recorded against a ward that is not there is a balance that adds up
// for somewhere nobody can go and look.
func (s *Service) checkUnit(ctx context.Context, scope authctx.TenantScope,
	unitID string) error {

	if !s.config.RequireKnownUnit {
		return nil
	}
	if s.units == nil {
		return rpcerr.FailedPrecondition("LND_NO_UNIT_DIRECTORY",
			"this deployment requires linen records to name a known unit, "+
				"but no unit directory is configured")
	}
	exists, err := s.units.Exists(ctx, scope, unitID)
	if err != nil {
		return err
	}
	if !exists {
		return rpcerr.FailedPrecondition("LND_NO_SUCH_UNIT",
			"no unit "+unitID+" to record linen against")
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
	eventSource        = "laundry"
)

func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateType, aggregateID string, payload map[string]any,
	now time.Time) error {

	if s.events == nil {
		return nil
	}
	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("LND_EVENT_ENCODE_FAILED",
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
// A deployment with no escalator records the fact and carries on: a wash that
// failed has still failed, and losing the record of it because the notice
// failed would be the worse outcome.
func (s *Service) escalate(ctx context.Context, session authctx.Session,
	scope authctx.TenantScope, n ports.Notice, now time.Time) error {

	if s.escalations == nil {
		return s.appendAudit(ctx, session, audit.Record{
			Action: "laundry.escalation.skipped", ResourceType: n.Kind,
			ResourceID: n.Subject, Outcome: audit.OutcomeSuccess,
			Reason: "no escalation channel is configured",
		}, now)
	}
	noticeID, err := s.escalations.Raise(ctx, scope, n, now)
	if err != nil {
		return err
	}
	return s.appendAudit(ctx, session, audit.Record{
		Action: "laundry.escalation.raised", ResourceType: n.Kind,
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
