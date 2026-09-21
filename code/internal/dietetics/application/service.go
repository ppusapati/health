// Package application holds the dietetics and kitchen use cases
// (SRS-DIET-001 … 009).
package application

import (
	"context"
	"encoding/json"
	"errors"
	"strconv"
	"time"

	"github.com/ppusapati/health/code/internal/dietetics/domain"
	"github.com/ppusapati/health/code/internal/dietetics/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Permissions.
//
// Two stand apart from the rest because of what they make possible.
// PermResolveConflict authorises a diet item against a documented allergy —
// somebody deciding that a patient with an anaphylaxis on their record may be
// given the thing they react to. PermLinkOrder puts a nutrition support plan
// into force against an order somewhere else, which is the moment a feed
// becomes real.
const (
	// PermRead reads the clinical side: nutrition assessments, care plans,
	// diet orders and support plans.
	PermRead = "diet.record.read"
	// PermServiceRead reads the kitchen's side: the census, the trays, the
	// menu and the ingredient report. Separate from PermRead and held far
	// more widely, because the kitchen needs the tray card and has no
	// business reading a nutrition assessment — a tray card carries a
	// texture and a restriction, and an assessment carries a diagnosis.
	PermServiceRead = "diet.service.read"
	// PermCreate writes nutrition assessments and care plans
	// (SRS-DIET-001, SRS-DIET-004). A dietitian's own work.
	PermCreate = "diet.create"
	// PermOrderWrite places and cancels diet orders (SRS-DIET-002). Held by
	// clinicians as well as dietitians: making a patient nil by mouth for
	// theatre is a ward decision taken at the bedside.
	PermOrderWrite = "diet.order.write"
	// PermResolveConflict authorises a diet item against a documented
	// allergy (SRS-DIET-003). Its own permission, and every use is audited:
	// this is a person deciding that an allergy on the record does not
	// apply to this food, and it is the decision an investigation reads
	// first.
	PermResolveConflict = "diet.conflict.resolve"
	// PermCensusManage builds, freezes and reissues meal censuses
	// (SRS-DIET-005).
	PermCensusManage = "diet.manage"
	// PermTrayWrite prepares, dispatches, delivers and closes trays
	// (SRS-DIET-006). Held by the kitchen and by the porters and nurses who
	// carry the meal the last few metres.
	PermTrayWrite = "diet.write"
	// PermSupportPlan proposes tube or intravenous feeding (SRS-DIET-007).
	PermSupportPlan = "diet.support.plan"
	// PermLinkOrder puts a support plan into force against the order
	// carrying it out. Separate from proposing it, because the whole of
	// SRS-DIET-007 is that the plan is not the prescription.
	PermLinkOrder = "diet.support.link"
	// PermMenuManage configures recipes, items and the menu (SRS-DIET-003,
	// SRS-DIET-008). The allergen codes live on these, so this permission
	// decides what the conflict check can see.
	PermMenuManage = "diet.menu.manage"
	// PermCountRecord records what the kitchen actually used (SRS-DIET-008).
	PermCountRecord = "diet.count.record"
)

// Events.
//
// Identifiers, codes and counts. No intake narrative, no nutrition diagnosis
// against a named patient, no allergen: an event stream is read by more
// systems and under fewer controls than the record it describes
// (SRS-API-009).
const (
	EventOrderPlaced     = "diet_order.placed"
	EventOrderPending    = "diet_order.pending_allergy_conflict"
	EventOrderCancelled  = "diet_order.cancelled"
	EventConflictCleared = "diet_order.conflict_resolved"
	EventCensusFrozen    = "diet_census.frozen"
	EventTrayWithheld    = "diet_tray.withheld"
	EventMealMissed      = "diet_tray.missed"
	EventSupportActive   = "diet_support.active"
)

// The escalations this context raises.
const (
	// EscalationWithheld is a tray the dispatch check stopped
	// (SRS-DIET-009). The ward needs to know the meal was held back rather
	// than that it went astray — and if the reason is that the patient is
	// nil by mouth, somebody has to know before the next tray.
	EscalationWithheld = "diet_tray_withheld"
	// EscalationMissed is a patient who has missed meals. A clinical fact
	// rather than a logistics one.
	EscalationMissed = "diet_meals_missed"
)

// Config is what a deployment has decided about its kitchen.
type Config struct {
	// MealWindow is how long after dispatch a meal stops being this meal. A
	// lunch delivered at seven in the evening is a missed lunch and a late
	// dinner. Zero leaves trays with no due time, so nothing is ever
	// reported late — which is a deployment that has not decided.
	MealWindow time.Duration
	// MissedMealsBeforeEscalation is how many consecutive missed meals reach
	// somebody. Zero escalates none, and a patient who has not eaten for a
	// day then shows up in no worklist at all.
	MissedMealsBeforeEscalation int
	// SupportOrderContexts are the contexts a nutrition support plan may
	// name as owning its order. Empty accepts any, which is a deployment
	// that has not decided where its prescriptions live.
	SupportOrderContexts []string
}

// Service is the dietetics use-case façade.
type Service struct {
	uow         ports.UnitOfWork
	assessments ports.AssessmentRepository
	orders      ports.OrderRepository
	plans       ports.CarePlanRepository
	censuses    ports.CensusRepository
	trays       ports.TrayRepository
	support     ports.SupportRepository
	menu        ports.MenuRepository

	allergies   ports.Allergies
	orderBook   ports.OrderDirectory
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
	Assessments ports.AssessmentRepository
	Orders      ports.OrderRepository
	Plans       ports.CarePlanRepository
	Censuses    ports.CensusRepository
	Trays       ports.TrayRepository
	Support     ports.SupportRepository
	Menu        ports.MenuRepository

	// Allergies reads what the patient is documented as reacting to. Nil
	// makes placing a diet order refuse rather than place one nobody
	// checked: a system that quietly stopped looking is worse than one that
	// sends dietitians to the ward.
	Allergies ports.Allergies
	// OrderBook resolves the order a support plan names. Nil makes
	// activating a support plan refuse, for the same reason.
	OrderBook ports.OrderDirectory
	Events    ports.EventAppender
	// AuditTrail is the platform's append-only trail.
	AuditTrail ports.AuditAppender
	// Escalations raises the notices a withheld tray and a run of missed
	// meals produce. Nil records both and escalates neither.
	Escalations ports.Escalator
	IDs         ports.IDGenerator
	Clock       ports.Clock
	Config      Config
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, assessments: d.Assessments, orders: d.Orders,
		plans: d.Plans, censuses: d.Censuses, trays: d.Trays,
		support: d.Support, menu: d.Menu,
		allergies: d.Allergies, orderBook: d.OrderBook,
		events: d.Events, audit: d.AuditTrail, escalations: d.Escalations,
		ids: d.IDs, clock: d.Clock, config: d.Config,
	}
}

// Limits on what one request may ask for.
const (
	DefaultPageSize = 200
	MaxPageSize     = 1000
	// wardPageSize bounds the kitchen's read of a ward's orders. A ward with
	// more live diet orders than this is one somebody should split.
	wardPageSize = 2000
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
			"DIET_NO_SESSION", "this call needs an authenticated caller")
	}
	if !session.HasPermission(permission) {
		return authctx.Session{}, authctx.TenantScope{}, rpcerr.PermissionDenied(
			"DIET_FORBIDDEN", "this caller may not "+permission)
	}
	return session, session.TenantScope(), nil
}

// dieteticsError maps a domain refusal to the transport contract.
func dieteticsError(err error) error {
	if errors.Is(err, domain.ErrInvalidDietetics) {
		return rpcerr.Invalid("DIET_INVALID", err.Error())
	}
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("DIET_VERSION_CONFLICT",
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
	eventSource        = "dietetics"
)

func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateType, aggregateID string, payload map[string]any,
	now time.Time) error {

	if s.events == nil {
		return nil
	}
	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("DIET_EVENT_ENCODE_FAILED",
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
// A deployment with no escalator records the fact and carries on: a tray held
// back because the patient is nil by mouth is still held back, and losing the
// record of it because the notice failed would be the worse outcome.
func (s *Service) escalate(ctx context.Context, session authctx.Session,
	scope authctx.TenantScope, n ports.Notice, now time.Time) error {

	if s.escalations == nil {
		return s.appendAudit(ctx, session, audit.Record{
			Action: "dietetics.escalation.skipped", ResourceType: n.Kind,
			ResourceID: n.Subject, Outcome: audit.OutcomeSuccess,
			Reason: "no escalation channel is configured",
		}, now)
	}
	noticeID, err := s.escalations.Raise(ctx, scope, n, now)
	if err != nil {
		return err
	}
	return s.appendAudit(ctx, session, audit.Record{
		Action: "dietetics.escalation.raised", ResourceType: n.Kind,
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
