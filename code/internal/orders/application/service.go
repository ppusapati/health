// Package application holds the order use cases.
package application

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/orders/domain"
	"github.com/ppusapati/health/code/internal/orders/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Permissions (SRS-ORD, Wave-1 backlog "ord.*").
const (
	// PermOrderRead reads orders.
	PermOrderRead = "ord.order.read"
	// PermOrderPlace composes and places an order.
	PermOrderPlace = "ord.order.place"
	// PermOrderCancel withdraws one, or asks a performing service to stop
	// (SRS-ORD-004).
	//
	// Separate from placing, because the two are asymmetric: a junior who may
	// order a chest film should be able to cancel their own mistake, but
	// cancelling somebody else's order is an intervention in their clinical
	// plan. The distinction between own and others' is enforced in the use
	// case; the permission is what a hospital withholds from a role entirely.
	PermOrderCancel = "ord.order.cancel"
	// PermOrderRetract marks an order entered-in-error. Health information
	// management's, not the ward's: saying a record was never true is a
	// statement about the record rather than about the patient.
	PermOrderRetract = "ord.order.retract"
	// PermOrderAcknowledge is what a performing service holds (SRS-ORD-006).
	//
	// Its own permission, so a laboratory's service account can move orders
	// through their lifecycle and cannot place one.
	PermOrderAcknowledge = "ord.order.acknowledge"
	// PermOrderConfigure maintains order sets, policy and duplicate rules.
	PermOrderConfigure = "ord.order.configure"
	// PermBloodProductOrder is SRS-ORD-002's requester privilege for the type
	// that needs one. Named in the domain's policy so the two cannot drift.
	PermBloodProductOrder = "ord.blood_product.order"
)

// Events (SRS-ORD-011).
//
// Versioned by the envelope's schema version and idempotent by the aggregate
// and type: a consumer that receives order.placed twice for one order has
// received one placement.
const (
	EventOrderPlaced     = "order.placed"
	EventOrderAccepted   = "order.accepted"
	EventOrderInProgress = "order.in_progress"
	EventOrderCompleted  = "order.completed"
	EventOrderCancelled  = "order.cancelled"
	// EventCancellationRequested is not in the requirement's list, and is
	// emitted because SRS-ORD-004's corrective workflow has to reach the
	// performing service — a request nobody is told about is a request nobody
	// acts on.
	EventCancellationRequested = "order.cancellation_requested"
)

const (
	eventSchemaVersion = 1
	eventSource        = "orders"
)

// eventForStatus maps a lifecycle step onto its event.
//
// Written out rather than derived from the status name, because the set of
// events is a published contract and a status added later must not silently
// become an event nobody subscribed to.
var eventForStatus = map[domain.Status]string{
	domain.StatusRequested:  EventOrderPlaced,
	domain.StatusAccepted:   EventOrderAccepted,
	domain.StatusInProgress: EventOrderInProgress,
	domain.StatusCompleted:  EventOrderCompleted,
	domain.StatusCancelled:  EventOrderCancelled,
}

// Service is the order use-case façade.
type Service struct {
	uow        ports.UnitOfWork
	orders     ports.OrderRepository
	acks       ports.AcknowledgementRepository
	catalogue  ports.CatalogueRepository
	numbers    ports.Numbers
	encounters ports.Encounters
	dispatcher ports.Dispatcher
	events     ports.EventAppender
	audits     ports.AuditAppender
	ids        ports.IDGenerator
	clock      ports.Clock
}

// Deps are the collaborators the service needs.
type Deps struct {
	UnitOfWork ports.UnitOfWork
	Orders     ports.OrderRepository
	Acks       ports.AcknowledgementRepository
	Catalogue  ports.CatalogueRepository
	Numbers    ports.Numbers
	// Encounters reports whether a visit accepts orders and whose it is. Nil
	// accepts everything, which is correct only where no encounter context
	// exists.
	Encounters ports.Encounters
	// Dispatcher routes a placed order to its performing service
	// (SRS-ORD-006). Nil means nothing is routed — an order is recorded and no
	// laboratory hears about it — so the composition root always supplies one.
	Dispatcher ports.Dispatcher
	Events     ports.EventAppender
	Audits     ports.AuditAppender
	IDs        ports.IDGenerator
	Clock      ports.Clock
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, orders: d.Orders, acks: d.Acks,
		catalogue: d.Catalogue, numbers: d.Numbers,
		encounters: d.Encounters, dispatcher: d.Dispatcher,
		events: d.Events, audits: d.Audits, ids: d.IDs, clock: d.Clock,
	}
}

// Limits on what one request may ask for.
const (
	DefaultPageSize = 50
	MaxPageSize     = 200
	// MaxOrdersPerSet bounds an order-set expansion. A set with two hundred
	// components is a set nobody reviewed, and placing them in one transaction
	// would hold locks for as long as it takes.
	MaxOrdersPerSet = 50
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
func (s *Service) authorize(ctx context.Context, permission, resourceType,
	resourceID string, mutating bool) (
	authctx.Session, authctx.TenantScope, error) {

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
		s.auditDenied(ctx, session, permission, resourceType, resourceID,
			decision.Reason)
		return authctx.Session{}, authctx.TenantScope{},
			rpcerr.PermissionDenied("ORD_DENIED", decision.Reason)
	}
	return session, session.TenantScope(), nil
}

// requireOpenEncounter is SRS-ORD-002's "validate against patient/encounter
// state".
//
// An order against a closed visit is an order nobody will perform and nobody
// can bill, and one whose patient does not match the encounter is the
// wrong-patient error every downstream control exists to prevent.
func (s *Service) requireOpenEncounter(ctx context.Context,
	scope authctx.TenantScope, encounterID, patientID string) (
	ports.EncounterState, error) {

	if s.encounters == nil || encounterID == "" {
		return ports.EncounterState{PatientID: patientID, Open: true}, nil
	}

	state, err := s.encounters.Check(ctx, scope, encounterID)
	if err != nil {
		return ports.EncounterState{}, err
	}
	if !state.Open {
		return ports.EncounterState{}, rpcerr.FailedPrecondition(
			"ORD_ENCOUNTER_NOT_OPEN",
			"that encounter no longer accepts orders")
	}
	if patientID != "" && state.PatientID != "" && state.PatientID != patientID {
		return ports.EncounterState{}, rpcerr.Invalid(
			"ORD_PATIENT_ENCOUNTER_MISMATCH",
			"that encounter belongs to a different patient")
	}
	return state, nil
}

// facilityLocation resolves a facility's zone for SRS-ORD-008's expansion.
//
// UTC where the zone is unknown or unloadable, and visibly so: a schedule in
// the wrong zone is an hour out twice a year, and falling back loudly is better
// than refusing every order because a time-zone database is stale.
func facilityLocation(name string) *time.Location {
	if name == "" {
		return time.UTC
	}
	loc, err := time.LoadLocation(name)
	if err != nil {
		return time.UTC
	}
	return loc
}

// appendEvent writes to the transactional outbox.
func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateID string, payload map[string]any,
	now time.Time) error {

	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("ORD_EVENT_ENCODE_FAILED",
			"could not encode event").WithCause(err)
	}

	return s.events.Append(ctx, outbox.Event{
		EventID:       s.ids.NewID(),
		EventType:     eventType,
		SchemaVersion: eventSchemaVersion,
		OccurredAt:    now.UTC(),
		TenantID:      session.TenantID,
		Source:        eventSource,
		AggregateType: "order",
		AggregateID:   aggregateID,
		CorrelationID: session.CorrelationID,
		CausationID:   session.RequestID,
		Actor:         session.SubjectID,
		Payload:       encoded,
	})
}

// orderEventPayload is what every order event carries.
//
// Identifiers, codes and times, and no clinical reasoning: an event stream is
// read by more systems, by more people and under fewer controls than the record
// it describes (SRS-API-009). The indication in particular stays out — it is
// the sentence that says what the clinician suspects.
func orderEventPayload(o *domain.Order) map[string]any {
	return map[string]any{
		"order_id": o.ID, "number": o.Number,
		"order_type": string(o.Type), "service": o.TargetService,
		"patient_id": o.PatientID, "encounter_id": o.EncounterID,
		"facility_id": o.FacilityID, "requester_id": o.RequesterID,
		"code_system": o.Code.System, "code": o.Code.Code,
		"priority": string(o.Priority), "status": string(o.Status),
		"version": o.Version,
	}
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

// orderError maps a domain refusal onto the wire contract.
func orderError(err error) error {
	var incomplete domain.ErrOrderIncomplete
	if errors.As(err, &incomplete) {
		// SRS-ORD-002's structured field errors travel as field violations, so
		// a client can highlight the right box rather than parsing a sentence.
		violations := make([]rpcerr.FieldViolation, 0, len(incomplete.Violations))
		for _, v := range incomplete.Violations {
			violations = append(violations, rpcerr.FieldViolation{
				Field: v.Field, Reason: v.Reason,
			})
		}
		return rpcerr.Invalid("ORD_INCOMPLETE", incomplete.Error(), violations...)
	}
	var cancellation domain.ErrCancellationAfterExecution
	if errors.As(err, &cancellation) {
		// FAILED_PRECONDITION rather than INVALID_ARGUMENT: the request is
		// well-formed, and what is wrong is that the world has moved on. The
		// message names the corrective workflow (SRS-ORD-004).
		return rpcerr.FailedPrecondition("ORD_ALREADY_EXECUTING",
			cancellation.Error())
	}
	if errors.Is(err, domain.ErrNotAllowed) {
		return rpcerr.FailedPrecondition("ORD_NOT_ALLOWED", err.Error())
	}
	if errors.Is(err, domain.ErrInvalidOrder) {
		return rpcerr.Invalid("ORD_INVALID", err.Error())
	}
	return err
}

// mapConflict turns a repository version conflict into the wire contract.
func mapConflict(err error) error {
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("ORD_VERSION_CONFLICT",
			"the order changed since it was read, or is no longer in that state")
	}
	return err
}
