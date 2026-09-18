// Package application holds the perioperative use cases (SRS-OT-001 … 017).
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
	"github.com/ppusapati/health/code/internal/theatre/domain"
	"github.com/ppusapati/health/code/internal/theatre/ports"
)

// Permissions.
//
// Split along the jobs. The two that stand alone are the ones a hospital is
// most answerable for: overriding a scheduling constraint, and waiving a
// pre-operative blocker.
const (
	// PermTheatreRead reads the list, the board and a case's record.
	PermTheatreRead = "ot.case.read"
	// PermRequest raises a surgery request (SRS-OT-002).
	PermRequest = "ot.case.request"
	// PermSchedule books a case into a room (SRS-OT-004).
	PermSchedule = "ot.case.schedule"
	// PermOverride books into a slot with a soft conflict. Its own permission
	// because it is the decision the list overrun is traced back to.
	PermOverride = "ot.schedule.override"
	// PermReprioritise changes a case's urgency (SRS-OT-003).
	PermReprioritise = "ot.case.reprioritise"
	// PermCancel takes a case off the list (SRS-OT-005).
	PermCancel = "ot.case.cancel"
	// PermRecord records checklists, milestones, usage and specimens.
	PermRecord = "ot.case.record"
	// PermWaive waives a pre-operative blocker (SRS-OT-006). Its own
	// permission, and the domain still checks the role: a system where every
	// gate has a general override has no gates.
	PermWaive = "ot.preop.waive"
	// PermSign signs the operative note (SRS-OT-009).
	PermSign = "ot.note.sign"
	// PermConfigure maintains rooms, blocks and preference cards
	// (SRS-OT-001, SRS-OT-016).
	PermConfigure = "ot.theatre.configure"
	// PermTrace runs a recall or an infection investigation across patients
	// (SRS-OT-010, SRS-OT-012). Its own permission because it reaches every
	// patient who received an item rather than one chart, which is a different
	// kind of access from reading a case.
	PermTrace = "ot.trace.read"
)

// Events.
//
// Identifiers, codes and times. No procedure narrative, no findings, no
// diagnosis display: an event stream is read by more systems and under fewer
// controls than the record it describes (SRS-API-009).
const (
	EventCaseRequested   = "theatre_case.requested"
	EventCaseScheduled   = "theatre_case.scheduled"
	EventCaseCancelled   = "theatre_case.cancelled"
	EventCaseCompleted   = "theatre_case.completed"
	EventImplantUsed     = "theatre_implant.used"
	EventSpecimenTaken   = "theatre_specimen.taken"
	EventTrayOpened      = "theatre_tray.opened"
	EventIndicatorFailed = "theatre_tray.indicator_failed"
)

// Config is what a deployment has decided about its theatres.
type Config struct {
	// PreopItems is the pre-operative checklist. Empty takes
	// domain.DefaultPreopItems, which is deliberately not empty: a readiness
	// gate defaulting to nothing would pass every case.
	PreopItems []domain.PreopItem
	// PreopVersion identifies the configuration, so a checklist answered last
	// month is readable under the rules it was answered under.
	PreopVersion string
	// SafetyItems is the surgical safety checklist.
	SafetyItems []domain.SafetyItem
	// OnTimeGrace is how late a start may be and still count as on time. Zero
	// takes fifteen minutes, which is what most published measures use.
	OnTimeGrace time.Duration
}

func (c Config) preopItems() []domain.PreopItem {
	if len(c.PreopItems) == 0 {
		return domain.DefaultPreopItems()
	}
	return c.PreopItems
}

func (c Config) safetyItems() []domain.SafetyItem {
	if len(c.SafetyItems) == 0 {
		return domain.DefaultSafetyItems()
	}
	return c.SafetyItems
}

// Service is the perioperative use-case façade.
type Service struct {
	uow        ports.UnitOfWork
	schedule   ports.ScheduleRepository
	cases      ports.CaseRepository
	encounters ports.Encounters
	procedures ports.Procedures
	events     ports.EventAppender
	audits     ports.AuditAppender
	ids        ports.IDGenerator
	clock      ports.Clock
	config     Config
}

// Deps are the collaborators the service needs.
type Deps struct {
	UnitOfWork ports.UnitOfWork
	Schedule   ports.ScheduleRepository
	Cases      ports.CaseRepository
	// Encounters reports whether the Wave-1 encounter still accepts content.
	Encounters ports.Encounters
	// Procedures answers whether a procedure code has sides. Nil answers false
	// for everything, which makes laterality optional — correct only where no
	// terminology service exists, and visible in the status document rather
	// than hidden here.
	Procedures ports.Procedures
	Events     ports.EventAppender
	Audits     ports.AuditAppender
	IDs        ports.IDGenerator
	Clock      ports.Clock
	Config     Config
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, schedule: d.Schedule, cases: d.Cases,
		encounters: d.Encounters, procedures: d.Procedures,
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
			"OT_NO_SESSION", "this call needs an authenticated caller")
	}
	if !session.HasPermission(permission) {
		return authctx.Session{}, authctx.TenantScope{}, rpcerr.PermissionDenied(
			"OT_FORBIDDEN", "this caller may not "+permission)
	}
	return session, session.TenantScope(), nil
}

// theatreError maps a domain refusal to the transport contract.
func theatreError(err error) error {
	if errors.Is(err, domain.ErrInvalidCase) {
		return rpcerr.Invalid("OT_INVALID", err.Error())
	}
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("OT_VERSION_CONFLICT",
			"somebody else changed this case; re-read it and try again")
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
	eventSource        = "theatre"
)

func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateType, aggregateID string, payload map[string]any,
	now time.Time) error {

	if s.events == nil {
		return nil
	}
	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("OT_EVENT_ENCODE_FAILED", "could not encode event").
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

// openCase reads a case and refuses one that has closed.
func (s *Service) openCase(ctx context.Context, scope authctx.TenantScope,
	caseID string) (domain.Case, error) {

	c, err := s.schedule.Case(ctx, scope, caseID)
	if err != nil {
		return domain.Case{}, err
	}
	if !c.Status.Open() {
		return domain.Case{}, rpcerr.FailedPrecondition("OT_CASE_CLOSED",
			"this case is "+string(c.Status))
	}
	return c, nil
}

// sideRequired asks the terminology whether a procedure has sides.
func (s *Service) sideRequired(ctx context.Context, scope authctx.TenantScope,
	code string) (bool, error) {

	if s.procedures == nil {
		return false, nil
	}
	return s.procedures.SideRequired(ctx, scope, code)
}

func trimmed(values ...string) string {
	for _, value := range values {
		if v := strings.TrimSpace(value); v != "" {
			return v
		}
	}
	return ""
}
