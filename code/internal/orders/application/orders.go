package application

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/orders/domain"
	"github.com/ppusapati/health/code/internal/orders/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Placing, checking and cancelling orders
// (SRS-ORD-001, SRS-ORD-002, SRS-ORD-004, SRS-ORD-005, SRS-ORD-007,
// SRS-ORD-009, SRS-ORD-010).

// PlaceInput is what placing an order needs.
type PlaceInput struct {
	Type        domain.Type
	PatientID   string
	EncounterID string

	Code                   domain.Coding
	Detail                 string
	Indication             string
	IndicationCode         domain.Coding
	Priority               domain.Priority
	Timing                 domain.Timing
	ConditionalInstruction string

	// EnteredByID names the person at the keyboard where that differs from the
	// requester — a verbal order taken by a nurse.
	EnteredByID string

	// AcknowledgeDuplicates is the clinician answering SRS-ORD-009's warning.
	// Empty means they have not been shown one, and a duplicate is reported
	// rather than placed; non-empty means they were, and it is the reason.
	AcknowledgeDuplicates string

	FromFavouriteID string
}

// PlaceResult is what placing returns.
//
// An order or a warning, never both: SRS-ORD-009 is explicit that a duplicate
// produces a warning "rather than arbitrary suppression", so a first attempt
// comes back with what exists and a second — carrying the clinician's reason —
// places the order.
type PlaceResult struct {
	Order   *domain.Order
	Warning *domain.DuplicateWarning
}

// Place composes, checks and submits an order in one step.
//
// Draft and submit are separate in the domain, because an order set is
// assembled before any of it is placed. They are one use case here because a
// single order is placed in one action, and a two-call API would leave drafts
// behind whenever a client crashed between them.
func (s *Service) Place(ctx context.Context, in PlaceInput) (PlaceResult, error) {
	session, scope, err := s.authorize(ctx, PermOrderPlace, "order", "", true)
	if err != nil {
		return PlaceResult{}, err
	}

	state, err := s.requireOpenEncounter(ctx, scope, in.EncounterID, in.PatientID)
	if err != nil {
		return PlaceResult{}, err
	}

	orderPolicy, err := s.catalogue.Policy(ctx, scope)
	if err != nil {
		return PlaceResult{}, err
	}
	// SRS-ORD-002's requester privilege. Checked before anything is built, so a
	// refusal leaves nothing behind — and checked against the privilege the
	// domain's policy names, so the two cannot drift.
	if privilege, needed := orderPolicy.RequiredPrivilege(in.Type); needed {
		if !session.HasPermission(privilege) {
			s.auditDenied(ctx, session, privilege, "order", "",
				"this order type needs "+privilege)
			return PlaceResult{}, rpcerr.PermissionDenied("ORD_DENIED",
				"placing a "+string(in.Type)+" order needs "+privilege)
		}
	}

	now := s.clock.Now()
	orderInput := domain.NewOrderInput{
		Type: in.Type, PatientID: in.PatientID, EncounterID: in.EncounterID,
		FacilityID: state.FacilityID, RequesterID: session.SubjectID,
		EnteredByID: in.EnteredByID,
		Code:        in.Code, Detail: in.Detail,
		Indication: in.Indication, IndicationCode: in.IndicationCode,
		Priority: in.Priority, Timing: in.Timing,
		ConditionalInstruction: in.ConditionalInstruction,
		FavouriteID:            in.FromFavouriteID,
	}

	result, err := s.place(ctx, session, scope, orderInput, state,
		in.AcknowledgeDuplicates, orderPolicy, now)
	if err != nil {
		return PlaceResult{}, err
	}
	return result, nil
}

// place is the shared path a single order and an order-set component both take.
//
// One path, which is what makes SRS-ORD-012's "personal preferences cannot
// bypass mandatory rules" structural: a favourite produces an input and takes
// this route like everything else.
func (s *Service) place(ctx context.Context, session authctx.Session,
	scope authctx.TenantScope, in domain.NewOrderInput,
	state ports.EncounterState, acknowledgeDuplicates string,
	orderPolicy domain.Policy, now time.Time) (PlaceResult, error) {

	rules, err := s.catalogue.DuplicateRules(ctx, scope)
	if err != nil {
		return PlaceResult{}, err
	}

	number, err := s.numbers.Issue(ctx, scope, state.FacilityID, now)
	if err != nil {
		return PlaceResult{}, err
	}
	order, err := domain.NewOrder(s.ids.NewID(), session.TenantID, number, in, now)
	if err != nil {
		return PlaceResult{}, orderError(err)
	}

	// SRS-ORD-009. Checked before the order is written, so a warning leaves
	// nothing in the table for the clinician to clean up.
	warning, err := s.checkDuplicates(ctx, scope, order, rules, now)
	if err != nil {
		return PlaceResult{}, err
	}
	if warning.Any() {
		if acknowledgeDuplicates == "" {
			// The existing orders come back so the clinician can review them,
			// which is what the requirement asks for. Nothing is suppressed and
			// nothing is written.
			return PlaceResult{Warning: &warning}, nil
		}
		if !warning.Overridable {
			return PlaceResult{}, rpcerr.FailedPrecondition(
				"ORD_DUPLICATE_NOT_OVERRIDABLE",
				"this tenant does not allow a duplicate "+string(order.Type)+
					" order to be placed")
		}
		against := make([]string, 0, len(warning.Existing))
		for _, e := range warning.Existing {
			against = append(against, e.ID)
		}
		if err := order.RecordDuplicateOverride(against, acknowledgeDuplicates,
			session.SubjectID, now); err != nil {
			return PlaceResult{}, orderError(err)
		}
	}

	// The policy applies here and nowhere else, so a favourite, an order set
	// and a hand-typed order are all held to it (SRS-ORD-007, SRS-ORD-012).
	if err := order.Submit(orderPolicy, session.SubjectID, now); err != nil {
		return PlaceResult{}, orderError(err)
	}
	change := order.History[len(order.History)-1]
	change.ID = s.ids.NewID()
	order.History[len(order.History)-1] = change

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		// The order goes in already placed, and the history entry alongside it:
		// an insert-then-update would leave a draft visible to a concurrent
		// reader in a state the clinician never intended.
		if err := s.orders.Insert(ctx, scope, order); err != nil {
			return err
		}
		if err := s.orders.InsertStatusChange(ctx, scope, order.ID,
			change); err != nil {
			return err
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "orders.order.place", ResourceType: "order",
			ResourceID: order.ID, Outcome: audit.OutcomeSuccess,
			Reason: order.Indication,
		}, now); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventOrderPlaced, order.ID,
			orderEventPayload(order), now); err != nil {
			return err
		}
		// SRS-ORD-006: the performing service hears about it on the bus, not by
		// reading this schema.
		return s.dispatch(ctx, scope, order, state, now)
	})
	if err != nil {
		return PlaceResult{}, mapConflict(err)
	}
	return PlaceResult{Order: order}, nil
}

// dispatch routes an order to the service that performs it (SRS-ORD-006).
func (s *Service) dispatch(ctx context.Context, scope authctx.TenantScope,
	order *domain.Order, state ports.EncounterState, now time.Time) error {

	if s.dispatcher == nil {
		return nil
	}
	// A window rather than the whole series: a standing order has no last
	// occurrence, and a dispatch carrying an infinite list is one nobody can
	// send. Thirty days is long enough for a performing service to plan and
	// short enough to re-dispatch as the order runs on.
	from := now
	if !order.Timing.StartAt.IsZero() && order.Timing.StartAt.Before(from) {
		from = order.Timing.StartAt
	}
	to := now.Add(30 * 24 * time.Hour)

	return s.dispatcher.Dispatch(ctx, scope,
		order.DispatchFor(from, to, facilityLocation(state.TimeZone)))
}

// checkDuplicates reads the live orders a candidate might repeat
// (SRS-ORD-009).
func (s *Service) checkDuplicates(ctx context.Context, scope authctx.TenantScope,
	candidate *domain.Order, rules map[domain.Type]domain.DuplicateRule,
	now time.Time) (domain.DuplicateWarning, error) {

	rule, ok := rules[candidate.Type]
	if !ok || rule.Within <= 0 {
		return domain.DuplicateWarning{}, nil
	}

	existing, err := s.orders.LiveOfType(ctx, scope, candidate.PatientID,
		candidate.Type, now.Add(-rule.Within), MaxPageSize)
	if err != nil {
		return domain.DuplicateWarning{}, err
	}
	return domain.DetectDuplicates(candidate, existing, rules, now), nil
}

// Get reads one order.
func (s *Service) Get(ctx context.Context, orderID string) (*domain.Order, error) {
	session, scope, err := s.authorize(ctx, PermOrderRead, "order", orderID, false)
	if err != nil {
		return nil, err
	}

	order, err := s.orders.Get(ctx, scope, orderID)
	if err != nil {
		return nil, err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "orders.order.read", ResourceType: "order",
		ResourceID: orderID, Outcome: audit.OutcomeSuccess,
	}, s.clock.Now()); err != nil {
		return nil, err
	}
	return order, nil
}

// List reads a patient's orders.
func (s *Service) List(ctx context.Context, q ports.OrderQuery) (
	[]*domain.Order, error) {

	session, scope, err := s.authorize(ctx, PermOrderRead, "patient",
		q.PatientID, false)
	if err != nil {
		return nil, err
	}
	if q.PatientID == "" {
		return nil, rpcerr.Invalid("ORD_LIST_UNFILTERED",
			"an order listing needs a patient")
	}
	q.Limit = clampPageSize(q.Limit)

	out, err := s.orders.ForPatient(ctx, scope, q)
	if err != nil {
		return nil, err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "orders.order.list", ResourceType: "patient",
		ResourceID: q.PatientID, Outcome: audit.OutcomeSuccess,
	}, s.clock.Now()); err != nil {
		return nil, err
	}
	return out, nil
}

// Worklist reads a performing service's outstanding orders (SRS-ORD-006).
func (s *Service) Worklist(ctx context.Context, service, facilityID string,
	limit int32) ([]*domain.Order, error) {

	session, scope, err := s.authorize(ctx, PermOrderRead, "service", service,
		false)
	if err != nil {
		return nil, err
	}
	if service == "" {
		return nil, rpcerr.Invalid("ORD_WORKLIST_NO_SERVICE",
			"a worklist is for one performing service")
	}

	out, err := s.orders.ForService(ctx, scope, service, facilityID,
		clampPageSize(limit))
	if err != nil {
		return nil, err
	}
	if err := s.appendAudit(ctx, session, audit.Record{
		Action: "orders.worklist.read", ResourceType: "service",
		ResourceID: service, Outcome: audit.OutcomeSuccess,
	}, s.clock.Now()); err != nil {
		return nil, err
	}
	return out, nil
}

// CancelResult is what cancelling returns (SRS-ORD-004).
//
// Either the order was withdrawn, or a request was recorded for the performing
// service to answer. Both are reported so a client can tell the clinician what
// actually happened rather than implying the order has stopped.
type CancelResult struct {
	Order *domain.Order
	// Requested is true where the order was already executing and the
	// cancellation became a request.
	Requested bool
}

// Cancel withdraws an order, or asks the performing service to stop
// (SRS-ORD-004).
//
// One use case for both, because from the clinician's side it is one intention
// — "stop this" — and which of the two happens is a property of the order's
// state that the clinician cannot be expected to know.
func (s *Service) Cancel(ctx context.Context, orderID, reason string) (
	CancelResult, error) {

	session, scope, err := s.authorize(ctx, PermOrderCancel, "order", orderID,
		true)
	if err != nil {
		return CancelResult{}, err
	}

	order, err := s.orders.Get(ctx, scope, orderID)
	if err != nil {
		return CancelResult{}, err
	}
	expected := order.Version
	now := s.clock.Now()

	err = order.Cancel(reason, session.SubjectID, now)
	var executing domain.ErrCancellationAfterExecution
	switch {
	case err == nil:
		// Withdrawn outright.
	case errors.As(err, &executing):
		// SRS-ORD-004's corrective workflow: the request is recorded and the
		// order stays where the performing service put it.
		if err := order.RequestCancellation(reason, session.SubjectID,
			now); err != nil {
			return CancelResult{}, orderError(err)
		}
	default:
		return CancelResult{}, orderError(err)
	}

	requested := order.CancellationPending()
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if requested {
			if err := s.orders.RequestCancellation(ctx, scope, order,
				expected); err != nil {
				return err
			}
		} else {
			change := order.History[len(order.History)-1]
			change.ID = s.ids.NewID()
			order.History[len(order.History)-1] = change
			if err := s.orders.UpdateStatus(ctx, scope, order, change,
				expected); err != nil {
				return err
			}
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "orders.order.cancel", ResourceType: "order",
			ResourceID: order.ID, Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now); err != nil {
			return err
		}

		eventType := EventOrderCancelled
		if requested {
			// A request nobody is told about is a request nobody acts on.
			eventType = EventCancellationRequested
		}
		payload := orderEventPayload(order)
		payload["reason"] = reason
		payload["cancellation_requested"] = requested
		return s.appendEvent(ctx, session, eventType, order.ID, payload, now)
	})
	if err != nil {
		return CancelResult{}, mapConflict(err)
	}
	return CancelResult{Order: order, Requested: requested}, nil
}

// Retract marks an order that was never true (SRS-ORD-005).
func (s *Service) Retract(ctx context.Context, orderID, reason string) (
	*domain.Order, error) {

	session, scope, err := s.authorize(ctx, PermOrderRetract, "order", orderID,
		true)
	if err != nil {
		return nil, err
	}

	order, err := s.orders.Get(ctx, scope, orderID)
	if err != nil {
		return nil, err
	}
	expected := order.Version

	now := s.clock.Now()
	if err := order.Retract(reason, session.SubjectID, now); err != nil {
		return nil, orderError(err)
	}
	if order.Version == expected {
		// Already retracted; nothing to write.
		return order, nil
	}
	change := order.History[len(order.History)-1]
	change.ID = s.ids.NewID()
	order.History[len(order.History)-1] = change

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.orders.UpdateStatus(ctx, scope, order, change,
			expected); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "orders.order.retract", ResourceType: "order",
			ResourceID: order.ID, Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return order, nil
}

// Acknowledge applies a performing service's report (SRS-ORD-006).
//
// The delivery is recorded first and the order is moved only if the recording
// was new. An at-least-once bus redelivers, and the primary key on
// (tenant, order, service, delivery) is what makes the second delivery a
// no-op — a check-then-apply would let two concurrent deliveries through.
func (s *Service) Acknowledge(ctx context.Context, ack domain.Acknowledgement) (
	*domain.Order, error) {

	session, scope, err := s.authorize(ctx, PermOrderAcknowledge, "order",
		ack.OrderID, true)
	if err != nil {
		return nil, err
	}

	order, err := s.orders.Get(ctx, scope, ack.OrderID)
	if err != nil {
		return nil, err
	}
	expected := order.Version
	now := s.clock.Now()

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		// Claimed before the order is touched, and this order matters. A
		// redelivery that arrives after the order has advanced would otherwise
		// reach the domain as an impossible transition and come back as an
		// error the consumer retries forever — which is precisely the failure
		// an at-least-once bus produces most often.
		if err := s.acks.Claim(ctx, scope, ack, now); err != nil {
			if errors.Is(err, ports.ErrAlreadyAcknowledged) {
				return errRedelivery
			}
			return err
		}

		changed, err := order.ApplyAcknowledgement(ack, now)
		if err != nil {
			return orderError(err)
		}
		if !changed {
			return nil
		}
		if err := s.acks.MarkApplied(ctx, scope, ack); err != nil {
			return err
		}

		change := order.History[len(order.History)-1]
		change.ID = s.ids.NewID()
		order.History[len(order.History)-1] = change
		if err := s.orders.UpdateStatus(ctx, scope, order, change,
			expected); err != nil {
			return err
		}
		if err := s.appendAudit(ctx, session, audit.Record{
			Action: "orders.order.acknowledge", ResourceType: "order",
			ResourceID: order.ID, Outcome: audit.OutcomeSuccess,
			Reason: ack.Reason,
		}, now); err != nil {
			return err
		}
		eventType, ok := eventForStatus[order.Status]
		if !ok {
			return nil
		}
		payload := orderEventPayload(order)
		payload["performer_id"] = ack.PerformerID
		if ack.Reason != "" {
			payload["reason"] = ack.Reason
		}
		return s.appendEvent(ctx, session, eventType, order.ID, payload, now)
	})
	if errors.Is(err, errRedelivery) {
		// The order as it stands, which is what a redelivering consumer needs
		// to see to stop retrying.
		return s.orders.Get(ctx, scope, ack.OrderID)
	}
	if err != nil {
		return nil, mapConflict(err)
	}
	return order, nil
}

// errRedelivery unwinds the transaction on a replayed delivery without
// reporting a failure.
var errRedelivery = errors.New("orders: redelivery")
