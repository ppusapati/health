// Package application holds the sterile services use cases
// (SRS-CSSD-001 … 012).
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
	"github.com/ppusapati/health/code/internal/sterile/domain"
	"github.com/ppusapati/health/code/internal/sterile/ports"
)

// Permissions.
//
// Split along the jobs. The three that stand alone are the ones a hospital is
// most answerable for: authorising a skipped reprocessing stage, releasing a
// sterilizer load, and raising a recall.
const (
	// PermRead reads the masters, the board, the shelf and a case trace.
	PermRead = "cssd.record.read"
	// PermConfigure maintains the instrument and tray masters
	// (SRS-CSSD-001).
	PermConfigure = "cssd.master.configure"
	// PermProcess receives sets and moves them through the stages
	// (SRS-CSSD-002 … 005).
	PermProcess = "cssd.run.process"
	// PermAuthoriseSkip signs off a stage that did not happen
	// (SRS-CSSD-003). Its own permission, because it is the exception the
	// whole sequence exists to make deliberate.
	PermAuthoriseSkip = "cssd.stage.skip"
	// PermRunCycle records a sterilizer load and its indicators
	// (SRS-CSSD-006, SRS-CSSD-007).
	PermRunCycle = "cssd.cycle.write"
	// PermRelease authorises a load for distribution (SRS-CSSD-007). Its own
	// permission, and held by a supervisor: it is the step that makes an
	// untested pack usable.
	PermRelease = "cssd.cycle.release"
	// PermIssue sends packs out and records their return (SRS-CSSD-009).
	PermIssue = "cssd.issue.write"
	// PermTrace runs a case trace or a look-back across cases
	// (SRS-CSSD-010). Its own permission because it reaches every patient a
	// load touched rather than one set.
	PermTrace = "cssd.trace.read"
	// PermRecall pulls a load back (SRS-CSSD-011). Its own permission,
	// because raising one tells wards to stop using what they have.
	PermRecall = "cssd.recall.raise"
)

// Events.
//
// Identifiers, codes and times. No patient identifiers beyond the case id a
// recall must carry, and no clinical detail: an event stream is read by more
// systems and under fewer controls than the record it describes
// (SRS-API-009).
const (
	EventSetReceived   = "sterile_set.received"
	EventStageSkipped  = "sterile_stage.skipped"
	EventCycleFinished = "sterile_cycle.finished"
	// EventCycleFailed is separate from finished so a quality system can
	// subscribe to it alone.
	EventCycleFailed   = "sterile_cycle.failed"
	EventCycleReleased = "sterile_cycle.released"
	EventPackIssued    = "sterile_pack.issued"
	EventPackExpired   = "sterile_pack.expired"
	EventRecallRaised  = "sterile_recall.raised"
)

// EscalationKind is the notice a recall raises.
//
// Durable and acknowledged rather than a log line: SRS-CSSD-011 asks for
// recall tasks to be generated, and a recall that only appeared on a screen
// nobody opened is a recall that did not happen.
const EscalationKind = "sterile_recall"

// Config is what a deployment has decided about its sterile services.
type Config struct {
	// DefaultShelfLife applies to a set whose own is zero. Zero here too
	// means a set with no policy is refused at sterilisation rather than
	// given a pack that never expires (SRS-CSSD-008).
	DefaultShelfLife time.Duration
	// RequireBiologicalIndicator holds every load until its spore challenge
	// reads. Most departments release routine loads on the chemical indicator
	// and hold implant loads; a few hold everything. The choice is the
	// hospital's, and the consequence is not.
	RequireBiologicalIndicator bool
}

// shelfLifeFor resolves a set's expiry policy.
func (c Config) shelfLifeFor(set domain.TraySet) time.Duration {
	if set.ShelfLife > 0 {
		return set.ShelfLife
	}
	return c.DefaultShelfLife
}

// Service is the sterile services use-case façade.
type Service struct {
	uow          ports.UnitOfWork
	master       ports.MasterRepository
	cycles       ports.CycleRepository
	runs         ports.RunRepository
	distribution ports.DistributionRepository
	cases        ports.Cases
	events       ports.EventAppender
	audits       ports.AuditAppender
	escalations  ports.Escalator
	ids          ports.IDGenerator
	clock        ports.Clock
	config       Config
}

// Deps are the collaborators the service needs.
type Deps struct {
	UnitOfWork   ports.UnitOfWork
	Master       ports.MasterRepository
	Cycles       ports.CycleRepository
	Runs         ports.RunRepository
	Distribution ports.DistributionRepository
	// Cases reports whether the theatre knows an operation. Nil skips the
	// check, which is visible in the status document rather than hidden here.
	Cases  ports.Cases
	Events ports.EventAppender
	Audits ports.AuditAppender
	// Escalations raises the notice a recall produces. Nil leaves the recall
	// recorded and unescalated, which is a configuration rather than a defect
	// — but a poor one, and the status document says so.
	Escalations ports.Escalator
	IDs         ports.IDGenerator
	Clock       ports.Clock
	Config      Config
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, master: d.Master, cycles: d.Cycles,
		runs: d.Runs, distribution: d.Distribution, cases: d.Cases,
		events: d.Events, audits: d.Audits, escalations: d.Escalations,
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
			"CSSD_NO_SESSION", "this call needs an authenticated caller")
	}
	if !session.HasPermission(permission) {
		return authctx.Session{}, authctx.TenantScope{}, rpcerr.PermissionDenied(
			"CSSD_FORBIDDEN", "this caller may not "+permission)
	}
	return session, session.TenantScope(), nil
}

// sterileError maps a domain refusal to the transport contract.
func sterileError(err error) error {
	if errors.Is(err, domain.ErrInvalidSet) {
		return rpcerr.Invalid("CSSD_INVALID", err.Error())
	}
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("CSSD_VERSION_CONFLICT",
			"somebody else changed this record; re-read it and try again")
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
	eventSource        = "sterile"
)

func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateType, aggregateID string, payload map[string]any,
	now time.Time) error {

	if s.events == nil {
		return nil
	}
	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("CSSD_EVENT_ENCODE_FAILED",
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

// knownCase refuses an operation the theatre does not know.
//
// A case trace built on an identifier nobody can resolve is a trace that
// reaches no patient, which is the one thing SRS-CSSD-010 is for.
func (s *Service) knownCase(ctx context.Context, scope authctx.TenantScope,
	caseID string) error {

	if s.cases == nil || caseID == "" {
		return nil
	}
	exists, err := s.cases.Exists(ctx, scope, caseID)
	if err != nil {
		return err
	}
	if !exists {
		return rpcerr.NotFound("CSSD_NOT_FOUND", "no such case")
	}
	return nil
}

func itoa(n int) string { return strconv.Itoa(n) }

func join(values []string) string {
	out := ""
	for i, value := range values {
		if i > 0 {
			out += ", "
		}
		out += value
	}
	return out
}
