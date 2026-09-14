package transport

import (
	"context"
	"time"

	"connectrpc.com/connect"
	ordersv1 "github.com/ppusapati/health/code/gen/go/healthcare/orders/v1"
	"github.com/ppusapati/health/code/internal/orders/application"
	"github.com/ppusapati/health/code/internal/orders/domain"
	"github.com/ppusapati/health/code/internal/orders/ports"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
)

// Handler serves healthcare.orders.v1.OrderService.
type Handler struct {
	svc *application.Service
}

// NewHandler constructs the handler.
func NewHandler(svc *application.Service) *Handler { return &Handler{svc: svc} }

func fail(ctx context.Context, err error) error {
	return platformtransport.ToConnect(err,
		platformtransport.CorrelationIDFromContext(ctx))
}

// PlaceOrder implements SRS-ORD-001, SRS-ORD-002 and SRS-ORD-009.
//
// Returns an order or a duplicate warning, never both: the requirement is
// explicit that a duplicate produces a warning "rather than arbitrary
// suppression", so a first attempt reports what already exists and places
// nothing.
func (h *Handler) PlaceOrder(
	ctx context.Context,
	req *connect.Request[ordersv1.PlaceOrderRequest],
) (*connect.Response[ordersv1.PlaceOrderResponse], error) {
	msg := req.Msg

	result, err := h.svc.Place(ctx, application.PlaceInput{
		Type: typeFromProto[msg.GetType()], PatientID: msg.GetPatientId(),
		EncounterID: msg.GetEncounterId(),
		Code:        codingFromProto(msg.GetCode()), Detail: msg.GetDetail(),
		Indication:             msg.GetIndication(),
		IndicationCode:         codingFromProto(msg.GetIndicationCode()),
		Priority:               priorityFromProto[msg.GetPriority()],
		Timing:                 timingFromProto(msg.GetTiming()),
		ConditionalInstruction: msg.GetConditionalInstruction(),
		EnteredByID:            msg.GetEnteredById(),
		AcknowledgeDuplicates:  msg.GetAcknowledgeDuplicates(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&ordersv1.PlaceOrderResponse{
		Order: orderToProto(result.Order), Warning: warningToProto(result.Warning),
	}), nil
}

// GetOrder reads one order.
func (h *Handler) GetOrder(
	ctx context.Context,
	req *connect.Request[ordersv1.GetOrderRequest],
) (*connect.Response[ordersv1.GetOrderResponse], error) {
	order, err := h.svc.Get(ctx, req.Msg.GetOrderId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&ordersv1.GetOrderResponse{
		Order: orderToProto(order),
	}), nil
}

// ListOrders reads a patient's orders.
func (h *Handler) ListOrders(
	ctx context.Context,
	req *connect.Request[ordersv1.ListOrdersRequest],
) (*connect.Response[ordersv1.ListOrdersResponse], error) {
	msg := req.Msg

	orders, err := h.svc.List(ctx, ports.OrderQuery{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		Type: typeFromProto[msg.GetType()], LiveOnly: msg.GetLiveOnly(),
		Limit: msg.GetPageSize(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&ordersv1.ListOrdersResponse{
		Orders: ordersToProto(orders),
	}), nil
}

// GetWorklist reads a performing service's outstanding orders (SRS-ORD-006).
func (h *Handler) GetWorklist(
	ctx context.Context,
	req *connect.Request[ordersv1.GetWorklistRequest],
) (*connect.Response[ordersv1.GetWorklistResponse], error) {
	msg := req.Msg

	orders, err := h.svc.Worklist(ctx, msg.GetService(), msg.GetFacilityId(),
		msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&ordersv1.GetWorklistResponse{
		Orders: ordersToProto(orders),
	}), nil
}

// CancelOrder implements SRS-ORD-004.
//
// Reports whether the order was withdrawn or a cancellation was requested,
// because a client that assumed cancellation always succeeds would tell a ward
// that a transfusion had stopped when it had not.
func (h *Handler) CancelOrder(
	ctx context.Context,
	req *connect.Request[ordersv1.CancelOrderRequest],
) (*connect.Response[ordersv1.CancelOrderResponse], error) {
	result, err := h.svc.Cancel(ctx, req.Msg.GetOrderId(), req.Msg.GetReason())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&ordersv1.CancelOrderResponse{
		Order:                 orderToProto(result.Order),
		CancellationRequested: result.Requested,
	}), nil
}

// RetractOrder marks an order that was never true.
func (h *Handler) RetractOrder(
	ctx context.Context,
	req *connect.Request[ordersv1.RetractOrderRequest],
) (*connect.Response[ordersv1.RetractOrderResponse], error) {
	order, err := h.svc.Retract(ctx, req.Msg.GetOrderId(), req.Msg.GetReason())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&ordersv1.RetractOrderResponse{
		Order: orderToProto(order),
	}), nil
}

// AcknowledgeOrder applies a performing service's report (SRS-ORD-006).
func (h *Handler) AcknowledgeOrder(
	ctx context.Context,
	req *connect.Request[ordersv1.AcknowledgeOrderRequest],
) (*connect.Response[ordersv1.AcknowledgeOrderResponse], error) {
	msg := req.Msg

	order, err := h.svc.Acknowledge(ctx, domain.Acknowledgement{
		OrderID: msg.GetOrderId(), Service: msg.GetService(),
		// The deduplication key: without it a replay is indistinguishable from
		// a new acknowledgement.
		DeliveryID: msg.GetDeliveryId(),
		Status:     statusFromProto[msg.GetStatus()], Reason: msg.GetReason(),
		PerformerID: msg.GetPerformerId(),
		OccurredAt:  goTime(msg.GetOccurredAt()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&ordersv1.AcknowledgeOrderResponse{
		Order: orderToProto(order),
	}), nil
}

// DefineOrderSet publishes a version of an order set (SRS-ORD-003).
func (h *Handler) DefineOrderSet(
	ctx context.Context,
	req *connect.Request[ordersv1.DefineOrderSetRequest],
) (*connect.Response[ordersv1.DefineOrderSetResponse], error) {
	set, err := h.svc.DefineSet(ctx, setFromProto(req.Msg.GetSet()))
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&ordersv1.DefineOrderSetResponse{
		Set: setToProto(set),
	}), nil
}

// ListOrderSets lists what a clinician may choose from.
func (h *Handler) ListOrderSets(
	ctx context.Context,
	req *connect.Request[ordersv1.ListOrderSetsRequest],
) (*connect.Response[ordersv1.ListOrderSetsResponse], error) {
	msg := req.Msg

	sets, err := h.svc.ListSets(ctx, msg.GetSpecialty(), msg.GetIncludeRetired(),
		msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*ordersv1.OrderSet, 0, len(sets))
	for _, s := range sets {
		out = append(out, setToProto(s))
	}
	return connect.NewResponse(&ordersv1.ListOrderSetsResponse{Sets: out}), nil
}

// RetireOrderSet withdraws a version from new use.
func (h *Handler) RetireOrderSet(
	ctx context.Context,
	req *connect.Request[ordersv1.RetireOrderSetRequest],
) (*connect.Response[ordersv1.RetireOrderSetResponse], error) {
	if err := h.svc.RetireSet(ctx, req.Msg.GetSetId(),
		req.Msg.GetVersion()); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&ordersv1.RetireOrderSetResponse{}), nil
}

// PlaceFromOrderSet expands a set and places the selected components
// (SRS-ORD-003).
func (h *Handler) PlaceFromOrderSet(
	ctx context.Context,
	req *connect.Request[ordersv1.PlaceFromOrderSetRequest],
) (*connect.Response[ordersv1.PlaceFromOrderSetResponse], error) {
	msg := req.Msg

	result, err := h.svc.PlaceFromSet(ctx, application.PlaceFromSetInput{
		SetID: msg.GetSetId(), SetVersion: msg.GetSetVersion(),
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		Selections:            selectionsFromProto(msg.GetSelections()),
		AcknowledgeDuplicates: msg.GetAcknowledgeDuplicates(),
		EnteredByID:           msg.GetEnteredById(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}

	warnings := make(map[string]*ordersv1.DuplicateWarning, len(result.Warnings))
	for code, w := range result.Warnings {
		warnings[code] = warningToProto(w)
	}
	return connect.NewResponse(&ordersv1.PlaceFromOrderSetResponse{
		Placed: ordersToProto(result.Placed), Warnings: warnings,
	}), nil
}

// SaveFavourite stores the caller's own shortcut (SRS-ORD-012).
func (h *Handler) SaveFavourite(
	ctx context.Context,
	req *connect.Request[ordersv1.SaveFavouriteRequest],
) (*connect.Response[ordersv1.SaveFavouriteResponse], error) {
	favourite, err := h.svc.SaveFavourite(ctx,
		favouriteFromProto(req.Msg.GetFavourite()))
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&ordersv1.SaveFavouriteResponse{
		Favourite: favouriteToProto(favourite),
	}), nil
}

// ListFavourites reads the caller's own.
func (h *Handler) ListFavourites(
	ctx context.Context,
	req *connect.Request[ordersv1.ListFavouritesRequest],
) (*connect.Response[ordersv1.ListFavouritesResponse], error) {
	favourites, err := h.svc.ListFavourites(ctx,
		typeFromProto[req.Msg.GetType()], req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*ordersv1.Favourite, 0, len(favourites))
	for _, f := range favourites {
		out = append(out, favouriteToProto(f))
	}
	return connect.NewResponse(&ordersv1.ListFavouritesResponse{
		Favourites: out,
	}), nil
}

// DeleteFavourite removes one of the caller's own.
func (h *Handler) DeleteFavourite(
	ctx context.Context,
	req *connect.Request[ordersv1.DeleteFavouriteRequest],
) (*connect.Response[ordersv1.DeleteFavouriteResponse], error) {
	if err := h.svc.DeleteFavourite(ctx,
		req.Msg.GetFavouriteId()); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&ordersv1.DeleteFavouriteResponse{}), nil
}

// PlaceFromFavourite applies a favourite and places the order.
//
// The policy still applies, so a shortcut saved before the tenant made
// indications mandatory is refused rather than quietly placed (SRS-ORD-012).
func (h *Handler) PlaceFromFavourite(
	ctx context.Context,
	req *connect.Request[ordersv1.PlaceFromFavouriteRequest],
) (*connect.Response[ordersv1.PlaceFromFavouriteResponse], error) {
	msg := req.Msg

	result, err := h.svc.PlaceFromFavourite(ctx, msg.GetFavouriteId(),
		application.PlaceInput{
			PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
			Detail: msg.GetDetail(), Indication: msg.GetIndication(),
			Priority:              priorityFromProto[msg.GetPriority()],
			AcknowledgeDuplicates: msg.GetAcknowledgeDuplicates(),
			EnteredByID:           msg.GetEnteredById(),
		})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&ordersv1.PlaceFromFavouriteResponse{
		Order: orderToProto(result.Order), Warning: warningToProto(result.Warning),
	}), nil
}

// SetOrderPolicy configures what an order type requires (SRS-ORD-007).
func (h *Handler) SetOrderPolicy(
	ctx context.Context,
	req *connect.Request[ordersv1.SetOrderPolicyRequest],
) (*connect.Response[ordersv1.SetOrderPolicyResponse], error) {
	msg := req.Msg

	if err := h.svc.SetPolicy(ctx, typeFromProto[msg.GetType()],
		msg.GetIndicationRequired(), msg.GetStructuredTimingRequired(),
		msg.GetRequiredPrivilege()); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&ordersv1.SetOrderPolicyResponse{}), nil
}

// SetDuplicateRule configures how two orders count as the same (SRS-ORD-009).
func (h *Handler) SetDuplicateRule(
	ctx context.Context,
	req *connect.Request[ordersv1.SetDuplicateRuleRequest],
) (*connect.Response[ordersv1.SetDuplicateRuleResponse], error) {
	msg := req.Msg

	if err := h.svc.SetDuplicateRule(ctx, domain.DuplicateRule{
		Type:         typeFromProto[msg.GetType()],
		Within:       time.Duration(msg.GetWithinSeconds()) * time.Second,
		SameCodeOnly: msg.GetSameCodeOnly(),
		Overridable:  msg.GetOverridable(),
	}); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&ordersv1.SetDuplicateRuleResponse{}), nil
}
