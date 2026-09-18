package transport

import (
	"context"
	"time"

	"connectrpc.com/connect"

	materialsv1 "github.com/ppusapati/health/code/gen/go/healthcare/materials/v1"
	"github.com/ppusapati/health/code/internal/materials/application"
	"github.com/ppusapati/health/code/internal/materials/domain"
)

// Handler is the materials ConnectRPC surface.
//
// Thin on purpose: it translates, calls one use case and translates back.
// Every refusal comes from the application or the domain, so the same rule
// holds whichever client asks.
type Handler struct {
	svc *application.Service
	now func() time.Time
}

// NewHandler constructs a Handler.
//
// The clock is injected because a lot's issuability is derived at the moment
// of rendering rather than stored: a batch that expired an hour ago is expired
// whether or not a job has run.
func NewHandler(svc *application.Service, now func() time.Time) *Handler {
	if now == nil {
		now = time.Now
	}
	return &Handler{svc: svc, now: now}
}

func (h *Handler) AddItem(ctx context.Context,
	req *connect.Request[materialsv1.AddItemRequest]) (
	*connect.Response[materialsv1.AddItemResponse], error) {

	msg := req.Msg
	item, err := h.svc.AddItem(ctx, domain.NewItemInput{
		Code: msg.GetCode(), Display: msg.GetDisplay(),
		Category: msg.GetCategory(), UOM: msg.GetUom(),
		Tracking:         trackingFromWire[msg.GetTracking()],
		Policy:           policyFromWire[msg.GetPolicy()],
		Perishable:       msg.GetPerishable(),
		InspectOnReceipt: msg.GetInspectOnReceipt(),
		Consignable:      msg.GetConsignable(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.AddItemResponse{
		Item: itemToProto(item),
	}), nil
}

func (h *Handler) ReconfigureItem(ctx context.Context,
	req *connect.Request[materialsv1.ReconfigureItemRequest]) (
	*connect.Response[materialsv1.ReconfigureItemResponse], error) {

	msg := req.Msg
	item, err := h.svc.ReconfigureItem(ctx, application.ReconfigureItemInput{
		ItemID: msg.GetItemId(), Display: msg.GetDisplay(),
		Category: msg.GetCategory(), Policy: policyFromWire[msg.GetPolicy()],
		InspectOnReceipt: msg.GetInspectOnReceipt(),
		Consignable:      msg.GetConsignable(), Active: msg.GetActive(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.ReconfigureItemResponse{
		Item: itemToProto(item),
	}), nil
}

func (h *Handler) GetItem(ctx context.Context,
	req *connect.Request[materialsv1.GetItemRequest]) (
	*connect.Response[materialsv1.GetItemResponse], error) {

	item, err := h.svc.Item(ctx, req.Msg.GetItemId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.GetItemResponse{
		Item: itemToProto(item),
	}), nil
}

func (h *Handler) ListItems(ctx context.Context,
	req *connect.Request[materialsv1.ListItemsRequest]) (
	*connect.Response[materialsv1.ListItemsResponse], error) {

	msg := req.Msg
	items, err := h.svc.Items(ctx, msg.GetCategory(), msg.GetActiveOnly(),
		msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.ListItemsResponse{
		Items: itemsToProto(items),
	}), nil
}

func (h *Handler) AddSupplier(ctx context.Context,
	req *connect.Request[materialsv1.AddSupplierRequest]) (
	*connect.Response[materialsv1.AddSupplierResponse], error) {

	msg := req.Msg
	supplier, err := h.svc.AddSupplier(ctx, domain.NewSupplierInput{
		Code: msg.GetCode(), Display: msg.GetDisplay(),
		ContactEmail: msg.GetContactEmail(), ContactPhone: msg.GetContactPhone(),
		PaymentTermsDays: int(msg.GetPaymentTermsDays()),
		Currency:         msg.GetCurrency(), Approved: msg.GetApproved(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.AddSupplierResponse{
		Supplier: supplierToProto(supplier),
	}), nil
}

func (h *Handler) SetSupplierApproval(ctx context.Context,
	req *connect.Request[materialsv1.SetSupplierApprovalRequest]) (
	*connect.Response[materialsv1.SetSupplierApprovalResponse], error) {

	msg := req.Msg
	supplier, err := h.svc.SetSupplierApproval(ctx,
		application.SetSupplierApprovalInput{
			SupplierID: msg.GetSupplierId(), Approved: msg.GetApproved(),
			Reason: msg.GetReason(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.SetSupplierApprovalResponse{
		Supplier: supplierToProto(supplier),
	}), nil
}

func (h *Handler) ListSuppliers(ctx context.Context,
	req *connect.Request[materialsv1.ListSuppliersRequest]) (
	*connect.Response[materialsv1.ListSuppliersResponse], error) {

	msg := req.Msg
	suppliers, err := h.svc.Suppliers(ctx, msg.GetApprovedOnly(),
		msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.ListSuppliersResponse{
		Suppliers: suppliersToProto(suppliers),
	}), nil
}

func (h *Handler) SetStockLevel(ctx context.Context,
	req *connect.Request[materialsv1.SetStockLevelRequest]) (
	*connect.Response[materialsv1.SetStockLevelResponse], error) {

	if err := h.svc.SetStockLevel(ctx,
		stockLevelFromProto(req.Msg.GetLevel())); err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.SetStockLevelResponse{}), nil
}

func (h *Handler) ListStockLevels(ctx context.Context,
	req *connect.Request[materialsv1.ListStockLevelsRequest]) (
	*connect.Response[materialsv1.ListStockLevelsResponse], error) {

	msg := req.Msg
	levels, err := h.svc.StockLevels(ctx, msg.GetLocationId(), msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.ListStockLevelsResponse{
		Levels: stockLevelsToProto(levels),
	}), nil
}

func (h *Handler) AddApprovalRule(ctx context.Context,
	req *connect.Request[materialsv1.AddApprovalRuleRequest]) (
	*connect.Response[materialsv1.AddApprovalRuleResponse], error) {

	msg := req.Msg
	rule, err := h.svc.AddApprovalRule(ctx, domain.ApprovalRule{
		MinimumValue: msg.GetMinimumValue(), Currency: msg.GetCurrency(),
		Category: msg.GetCategory(), FacilityID: msg.GetFacilityId(),
		Roles: msg.GetRoles(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.AddApprovalRuleResponse{
		Rule: approvalRulesToProto([]domain.ApprovalRule{rule})[0],
	}), nil
}

func (h *Handler) ListApprovalRules(ctx context.Context,
	req *connect.Request[materialsv1.ListApprovalRulesRequest]) (
	*connect.Response[materialsv1.ListApprovalRulesResponse], error) {

	rules, err := h.svc.ApprovalRules(ctx)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.ListApprovalRulesResponse{
		Rules: approvalRulesToProto(rules),
	}), nil
}

func (h *Handler) RemoveApprovalRule(ctx context.Context,
	req *connect.Request[materialsv1.RemoveApprovalRuleRequest]) (
	*connect.Response[materialsv1.RemoveApprovalRuleResponse], error) {

	if err := h.svc.RemoveApprovalRule(
		ctx, req.Msg.GetApprovalRuleId()); err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.RemoveApprovalRuleResponse{}), nil
}

func (h *Handler) RaiseRequisition(ctx context.Context,
	req *connect.Request[materialsv1.RaiseRequisitionRequest]) (
	*connect.Response[materialsv1.RaiseRequisitionResponse], error) {

	msg := req.Msg
	requisition, err := h.svc.RaiseRequisition(ctx,
		domain.NewRequisitionInput{
			Number: msg.GetNumber(), FacilityID: msg.GetFacilityId(),
			Source: sourceFromWire[msg.GetSource()],
			NeedBy: timeOf(msg.GetNeedBy()), CostCentre: msg.GetCostCentre(),
			SourceReference: msg.GetSourceReference(),
			Lines:           requisitionLinesFromProto(msg.GetLines()),
			Justification:   msg.GetJustification(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.RaiseRequisitionResponse{
		Requisition: requisitionToProto(requisition),
	}), nil
}

func (h *Handler) GetApprovalRoute(ctx context.Context,
	req *connect.Request[materialsv1.GetApprovalRouteRequest]) (
	*connect.Response[materialsv1.GetApprovalRouteResponse], error) {

	roles, err := h.svc.RouteFor(ctx, req.Msg.GetRequisitionId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.GetApprovalRouteResponse{
		Roles: roles,
	}), nil
}

func (h *Handler) SubmitRequisition(ctx context.Context,
	req *connect.Request[materialsv1.SubmitRequisitionRequest]) (
	*connect.Response[materialsv1.SubmitRequisitionResponse], error) {

	requisition, route, err := h.svc.SubmitRequisition(
		ctx, req.Msg.GetRequisitionId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.SubmitRequisitionResponse{
		Requisition: requisitionToProto(requisition), Route: route,
	}), nil
}

func (h *Handler) DecideRequisition(ctx context.Context,
	req *connect.Request[materialsv1.DecideRequisitionRequest]) (
	*connect.Response[materialsv1.DecideRequisitionResponse], error) {

	msg := req.Msg
	requisition, step, err := h.svc.DecideRequisition(ctx,
		application.DecideInput{
			RequisitionID: msg.GetRequisitionId(),
			Decision:      decisionFromWire[msg.GetDecision()],
			Role:          msg.GetRole(), Note: msg.GetNote(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.DecideRequisitionResponse{
		Requisition: requisitionToProto(requisition),
		Step:        approvalStepToProto(step),
	}), nil
}

func (h *Handler) GetRequisition(ctx context.Context,
	req *connect.Request[materialsv1.GetRequisitionRequest]) (
	*connect.Response[materialsv1.GetRequisitionResponse], error) {

	requisition, err := h.svc.Requisition(ctx, req.Msg.GetRequisitionId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.GetRequisitionResponse{
		Requisition: requisitionToProto(requisition),
	}), nil
}

func (h *Handler) ListRequisitions(ctx context.Context,
	req *connect.Request[materialsv1.ListRequisitionsRequest]) (
	*connect.Response[materialsv1.ListRequisitionsResponse], error) {

	msg := req.Msg
	requisitions, err := h.svc.Requisitions(ctx, msg.GetState(), msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.ListRequisitionsResponse{
		Requisitions: requisitionsToProto(requisitions),
	}), nil
}

func (h *Handler) OpenRfq(ctx context.Context,
	req *connect.Request[materialsv1.OpenRfqRequest]) (
	*connect.Response[materialsv1.OpenRfqResponse], error) {

	msg := req.Msg
	rfq, err := h.svc.OpenRFQ(ctx, domain.NewRFQInput{
		Number: msg.GetNumber(), RequisitionID: msg.GetRequisitionId(),
		SupplierIDs: msg.GetSupplierIds(),
		Lines:       requisitionLinesFromProto(msg.GetLines()),
		ClosesAt:    timeOf(msg.GetClosesAt()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.OpenRfqResponse{
		Rfq: rfqToProto(rfq),
	}), nil
}

func (h *Handler) RecordBid(ctx context.Context,
	req *connect.Request[materialsv1.RecordBidRequest]) (
	*connect.Response[materialsv1.RecordBidResponse], error) {

	msg := req.Msg
	bid, err := h.svc.RecordBid(ctx, application.RecordBidInput{
		RFQID: msg.GetRfqId(), SupplierID: msg.GetSupplierId(),
		Lines:            bidLinesFromProto(msg.GetLines()),
		LeadTimeDays:     int(msg.GetLeadTimeDays()),
		WarrantyMonths:   int(msg.GetWarrantyMonths()),
		PaymentTermsDays: int(msg.GetPaymentTermsDays()),
		FreightMinor:     msg.GetFreightMinor(), TaxMinor: msg.GetTaxMinor(),
		Currency: msg.GetCurrency(), Notes: msg.GetNotes(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.RecordBidResponse{
		Bid: bidToProto(bid),
	}), nil
}

func (h *Handler) CompareBids(ctx context.Context,
	req *connect.Request[materialsv1.CompareBidsRequest]) (
	*connect.Response[materialsv1.CompareBidsResponse], error) {

	comparisons, err := h.svc.CompareBids(ctx, req.Msg.GetRfqId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.CompareBidsResponse{
		Comparisons: comparisonsToProto(comparisons),
	}), nil
}

func (h *Handler) GetRfq(ctx context.Context,
	req *connect.Request[materialsv1.GetRfqRequest]) (
	*connect.Response[materialsv1.GetRfqResponse], error) {

	rfq, err := h.svc.RFQ(ctx, req.Msg.GetRfqId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.GetRfqResponse{
		Rfq: rfqToProto(rfq),
	}), nil
}

func (h *Handler) ListRfqs(ctx context.Context,
	req *connect.Request[materialsv1.ListRfqsRequest]) (
	*connect.Response[materialsv1.ListRfqsResponse], error) {

	rfqs, err := h.svc.RFQs(ctx, req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.ListRfqsResponse{
		Rfqs: rfqsToProto(rfqs),
	}), nil
}

func (h *Handler) PlaceOrder(ctx context.Context,
	req *connect.Request[materialsv1.PlaceOrderRequest]) (
	*connect.Response[materialsv1.PlaceOrderResponse], error) {

	msg := req.Msg
	order, err := h.svc.PlaceOrder(ctx, domain.NewPOInput{
		Number: msg.GetNumber(), FacilityID: msg.GetFacilityId(),
		SupplierID: msg.GetSupplierId(), RequisitionID: msg.GetRequisitionId(),
		BidID: msg.GetBidId(), Lines: orderLinesFromProto(msg.GetLines()),
		Currency:              msg.GetCurrency(),
		PaymentTermsDays:      int(msg.GetPaymentTermsDays()),
		DeliveryTerms:         msg.GetDeliveryTerms(),
		ToleranceOverPercent:  int(msg.GetToleranceOverPercent()),
		ToleranceShortPercent: int(msg.GetToleranceShortPercent()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.PlaceOrderResponse{
		Order: orderToProto(order),
	}), nil
}

func (h *Handler) IssueOrder(ctx context.Context,
	req *connect.Request[materialsv1.IssueOrderRequest]) (
	*connect.Response[materialsv1.IssueOrderResponse], error) {

	order, err := h.svc.IssueOrder(ctx, req.Msg.GetPurchaseOrderId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.IssueOrderResponse{
		Order: orderToProto(order),
	}), nil
}

func (h *Handler) AmendOrder(ctx context.Context,
	req *connect.Request[materialsv1.AmendOrderRequest]) (
	*connect.Response[materialsv1.AmendOrderResponse], error) {

	msg := req.Msg
	order, err := h.svc.AmendOrder(ctx, application.AmendOrderInput{
		OrderID: msg.GetPurchaseOrderId(),
		Lines:   orderLinesFromProto(msg.GetLines()), Reason: msg.GetReason(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.AmendOrderResponse{
		Order: orderToProto(order),
	}), nil
}

func (h *Handler) GetPurchaseOrder(ctx context.Context,
	req *connect.Request[materialsv1.GetPurchaseOrderRequest]) (
	*connect.Response[materialsv1.GetPurchaseOrderResponse], error) {

	order, err := h.svc.PurchaseOrder(ctx, req.Msg.GetPurchaseOrderId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.GetPurchaseOrderResponse{
		Order: orderToProto(order),
	}), nil
}

func (h *Handler) ListOrderRevisions(ctx context.Context,
	req *connect.Request[materialsv1.ListOrderRevisionsRequest]) (
	*connect.Response[materialsv1.ListOrderRevisionsResponse], error) {

	revisions, err := h.svc.OrderRevisions(ctx, req.Msg.GetPurchaseOrderId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.ListOrderRevisionsResponse{
		Revisions: ordersToProto(revisions),
	}), nil
}

func (h *Handler) ListPurchaseOrders(ctx context.Context,
	req *connect.Request[materialsv1.ListPurchaseOrdersRequest]) (
	*connect.Response[materialsv1.ListPurchaseOrdersResponse], error) {

	msg := req.Msg
	orders, err := h.svc.PurchaseOrders(ctx, msg.GetSupplierId(),
		msg.GetState(), msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.ListPurchaseOrdersResponse{
		Orders: ordersToProto(orders),
	}), nil
}

func (h *Handler) ReceiveGoods(ctx context.Context,
	req *connect.Request[materialsv1.ReceiveGoodsRequest]) (
	*connect.Response[materialsv1.ReceiveGoodsResponse], error) {

	msg := req.Msg
	receipt, err := h.svc.ReceiveGoods(ctx, domain.NewReceiptInput{
		Number: msg.GetNumber(), LocationID: msg.GetLocationId(),
		DeliveryNote: msg.GetDeliveryNote(), InvoiceRef: msg.GetInvoiceRef(),
		Lines: receiptLinesFromProto(msg.GetLines()),
	}, msg.GetPurchaseOrderId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.ReceiveGoodsResponse{
		Receipt: receiptToProto(receipt.Receipt),
		Short:   receipt.Short, Quarantined: receipt.Quarantined,
	}), nil
}

func (h *Handler) Inspect(ctx context.Context,
	req *connect.Request[materialsv1.InspectRequest]) (
	*connect.Response[materialsv1.InspectResponse], error) {

	msg := req.Msg
	movement, err := h.svc.Inspect(ctx, application.InspectInput{
		LotID: msg.GetLotId(), LocationID: msg.GetLocationId(),
		Quantity: int(msg.GetQuantity()), Accept: msg.GetAccept(),
		Reason: msg.GetReason(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.InspectResponse{
		Movement: movementToProto(movement),
	}), nil
}

func (h *Handler) GetReceipt(ctx context.Context,
	req *connect.Request[materialsv1.GetReceiptRequest]) (
	*connect.Response[materialsv1.GetReceiptResponse], error) {

	receipt, err := h.svc.ReceiptByID(ctx, req.Msg.GetReceiptId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.GetReceiptResponse{
		Receipt: receiptToProto(receipt),
	}), nil
}

func (h *Handler) ListReceipts(ctx context.Context,
	req *connect.Request[materialsv1.ListReceiptsRequest]) (
	*connect.Response[materialsv1.ListReceiptsResponse], error) {

	receipts, err := h.svc.ReceiptsForOrder(ctx, req.Msg.GetPurchaseOrderId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.ListReceiptsResponse{
		Receipts: receiptsToProto(receipts),
	}), nil
}

func (h *Handler) RecommendPick(ctx context.Context,
	req *connect.Request[materialsv1.RecommendPickRequest]) (
	*connect.Response[materialsv1.RecommendPickResponse], error) {

	msg := req.Msg
	pick, err := h.svc.Recommend(ctx, msg.GetItemId(), msg.GetLocationId(),
		int(msg.GetQuantity()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.RecommendPickResponse{
		Pick: pickToProto(pick),
	}), nil
}

func (h *Handler) IssueStock(ctx context.Context,
	req *connect.Request[materialsv1.IssueStockRequest]) (
	*connect.Response[materialsv1.IssueStockResponse], error) {

	msg := req.Msg
	issued, err := h.svc.Issue(ctx, application.IssueInput{
		ItemID: msg.GetItemId(), LotID: msg.GetLotId(),
		FromLocation: msg.GetFromLocation(), ToLocation: msg.GetToLocation(),
		Quantity: int(msg.GetQuantity()), CostCentre: msg.GetCostCentre(),
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		Reference: msg.GetReference(), Reason: msg.GetReason(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.IssueStockResponse{
		Movements: movementsToProto(issued.Movements),
		Short:     int32(issued.Short), Skipped: issued.Skipped,
		ChargeId:    issued.ChargeID,
		Liabilities: liabilitiesToProto(issued.Liabilities),
	}), nil
}

func (h *Handler) ReturnStock(ctx context.Context,
	req *connect.Request[materialsv1.ReturnStockRequest]) (
	*connect.Response[materialsv1.ReturnStockResponse], error) {

	msg := req.Msg
	movement, err := h.svc.Return(ctx, application.ReturnInput{
		ItemID: msg.GetItemId(), LotID: msg.GetLotId(),
		FromLocation: msg.GetFromLocation(), ToLocation: msg.GetToLocation(),
		Quantity: int(msg.GetQuantity()), CostCentre: msg.GetCostCentre(),
		Reason: msg.GetReason(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.ReturnStockResponse{
		Movement: movementToProto(movement),
	}), nil
}

func (h *Handler) ListBalances(ctx context.Context,
	req *connect.Request[materialsv1.ListBalancesRequest]) (
	*connect.Response[materialsv1.ListBalancesResponse], error) {

	msg := req.Msg
	balances, err := h.svc.Balances(ctx, msg.GetLocationId(), msg.GetItemId(),
		msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.ListBalancesResponse{
		Balances: balancesToProto(balances),
	}), nil
}

func (h *Handler) GetAvailable(ctx context.Context,
	req *connect.Request[materialsv1.GetAvailableRequest]) (
	*connect.Response[materialsv1.GetAvailableResponse], error) {

	msg := req.Msg
	available, err := h.svc.Available(ctx, msg.GetItemId(), msg.GetLocationId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.GetAvailableResponse{
		Available: int32(available),
	}), nil
}

func (h *Handler) ListMovements(ctx context.Context,
	req *connect.Request[materialsv1.ListMovementsRequest]) (
	*connect.Response[materialsv1.ListMovementsResponse], error) {

	msg := req.Msg
	movements, err := h.svc.Movements(ctx, msg.GetItemId(),
		timeOf(msg.GetPeriodStart()), timeOf(msg.GetPeriodEnd()),
		msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.ListMovementsResponse{
		Movements: movementsToProto(movements),
	}), nil
}

func (h *Handler) DispatchTransfer(ctx context.Context,
	req *connect.Request[materialsv1.DispatchTransferRequest]) (
	*connect.Response[materialsv1.DispatchTransferResponse], error) {

	msg := req.Msg
	transfer, err := h.svc.DispatchTransfer(ctx, domain.NewTransferInput{
		Number: msg.GetNumber(), FromLocation: msg.GetFromLocation(),
		ToLocation: msg.GetToLocation(),
		Lines:      transferLinesFromProto(msg.GetLines()),
		Reason:     msg.GetReason(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.DispatchTransferResponse{
		Transfer: transferToProto(transfer),
	}), nil
}

func (h *Handler) ReceiveTransfer(ctx context.Context,
	req *connect.Request[materialsv1.ReceiveTransferRequest]) (
	*connect.Response[materialsv1.ReceiveTransferResponse], error) {

	msg := req.Msg
	counted := make(map[string]int, len(msg.GetCounted()))
	for key, value := range msg.GetCounted() {
		counted[key] = int(value)
	}

	received, err := h.svc.ReceiveTransfer(ctx,
		application.ReceiveTransferInput{
			TransferID: msg.GetTransferId(), Counted: counted,
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.ReceiveTransferResponse{
		Transfer: transferToProto(received.Transfer), Short: received.Short,
	}), nil
}

func (h *Handler) ListTransfersInTransit(ctx context.Context,
	req *connect.Request[materialsv1.ListTransfersInTransitRequest]) (
	*connect.Response[materialsv1.ListTransfersInTransitResponse], error) {

	msg := req.Msg
	transfers, err := h.svc.TransfersInTransit(ctx, msg.GetToLocation(),
		msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.ListTransfersInTransitResponse{
		Transfers: transfersToProto(transfers),
	}), nil
}

func (h *Handler) OpenCount(ctx context.Context,
	req *connect.Request[materialsv1.OpenCountRequest]) (
	*connect.Response[materialsv1.OpenCountResponse], error) {

	msg := req.Msg
	count, err := h.svc.OpenCount(ctx, msg.GetNumber(), msg.GetLocationId(),
		msg.GetCycle(), msg.GetItemIds())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.OpenCountResponse{
		Count: countToProto(count),
	}), nil
}

func (h *Handler) RecordCount(ctx context.Context,
	req *connect.Request[materialsv1.RecordCountRequest]) (
	*connect.Response[materialsv1.RecordCountResponse], error) {

	msg := req.Msg
	count, err := h.svc.RecordCount(ctx, msg.GetCountId(),
		countLinesFromProto(msg.GetLines()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.RecordCountResponse{
		Count: countToProto(count),
	}), nil
}

func (h *Handler) ApproveCount(ctx context.Context,
	req *connect.Request[materialsv1.ApproveCountRequest]) (
	*connect.Response[materialsv1.ApproveCountResponse], error) {

	msg := req.Msg
	count, adjustments, err := h.svc.ApproveCount(ctx, msg.GetCountId(),
		msg.GetNote())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.ApproveCountResponse{
		Count: countToProto(count), Adjustments: movementsToProto(adjustments),
	}), nil
}

func (h *Handler) RejectCount(ctx context.Context,
	req *connect.Request[materialsv1.RejectCountRequest]) (
	*connect.Response[materialsv1.RejectCountResponse], error) {

	msg := req.Msg
	count, err := h.svc.RejectCount(ctx, msg.GetCountId(), msg.GetNote())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.RejectCountResponse{
		Count: countToProto(count),
	}), nil
}

func (h *Handler) GetCount(ctx context.Context,
	req *connect.Request[materialsv1.GetCountRequest]) (
	*connect.Response[materialsv1.GetCountResponse], error) {

	count, err := h.svc.Count(ctx, req.Msg.GetCountId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.GetCountResponse{
		Count: countToProto(count),
	}), nil
}

func (h *Handler) ListCounts(ctx context.Context,
	req *connect.Request[materialsv1.ListCountsRequest]) (
	*connect.Response[materialsv1.ListCountsResponse], error) {

	msg := req.Msg
	counts, err := h.svc.Counts(ctx, msg.GetState(), msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.ListCountsResponse{
		Counts: countsToProto(counts),
	}), nil
}

func (h *Handler) BlockLot(ctx context.Context,
	req *connect.Request[materialsv1.BlockLotRequest]) (
	*connect.Response[materialsv1.BlockLotResponse], error) {

	msg := req.Msg
	lot, recall, err := h.svc.BlockLot(ctx, msg.GetLotId(), msg.GetReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.BlockLotResponse{
		Lot: lotToProto(lot, h.now()), Recall: recallToProto(recall),
	}), nil
}

func (h *Handler) ReleaseLot(ctx context.Context,
	req *connect.Request[materialsv1.ReleaseLotRequest]) (
	*connect.Response[materialsv1.ReleaseLotResponse], error) {

	msg := req.Msg
	lot, err := h.svc.ReleaseLot(ctx, msg.GetLotId(), msg.GetNote())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.ReleaseLotResponse{
		Lot: lotToProto(lot, h.now()),
	}), nil
}

func (h *Handler) GetRecallList(ctx context.Context,
	req *connect.Request[materialsv1.GetRecallListRequest]) (
	*connect.Response[materialsv1.GetRecallListResponse], error) {

	recall, err := h.svc.RecallFor(ctx, req.Msg.GetLotId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.GetRecallListResponse{
		Recall: recallToProto(recall),
	}), nil
}

func (h *Handler) ListBlockedLots(ctx context.Context,
	req *connect.Request[materialsv1.ListBlockedLotsRequest]) (
	*connect.Response[materialsv1.ListBlockedLotsResponse], error) {

	lots, err := h.svc.BlockedLots(ctx, req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.ListBlockedLotsResponse{
		Lots: lotsToProto(lots, h.now()),
	}), nil
}

func (h *Handler) GetLot(ctx context.Context,
	req *connect.Request[materialsv1.GetLotRequest]) (
	*connect.Response[materialsv1.GetLotResponse], error) {

	lot, err := h.svc.Lot(ctx, req.Msg.GetLotId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.GetLotResponse{
		Lot: lotToProto(lot, h.now()),
	}), nil
}

func (h *Handler) ListLots(ctx context.Context,
	req *connect.Request[materialsv1.ListLotsRequest]) (
	*connect.Response[materialsv1.ListLotsResponse], error) {

	msg := req.Msg
	lots, err := h.svc.LotsForItem(ctx, msg.GetItemId(), msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.ListLotsResponse{
		Lots: lotsToProto(lots, h.now()),
	}), nil
}

func (h *Handler) ListAlerts(ctx context.Context,
	req *connect.Request[materialsv1.ListAlertsRequest]) (
	*connect.Response[materialsv1.ListAlertsResponse], error) {

	msg := req.Msg
	alerts, err := h.svc.Alerts(ctx, msg.GetLocationId(), msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.ListAlertsResponse{
		Alerts: alertsToProto(alerts),
	}), nil
}

func (h *Handler) SuggestOrder(ctx context.Context,
	req *connect.Request[materialsv1.SuggestOrderRequest]) (
	*connect.Response[materialsv1.SuggestOrderResponse], error) {

	suggested, err := h.svc.SuggestOrder(ctx, req.Msg.GetLocationId())
	if err != nil {
		return nil, err
	}
	lines := make([]*materialsv1.SuggestedLine, 0, len(suggested.Lines))
	for _, line := range suggested.Lines {
		lines = append(lines, &materialsv1.SuggestedLine{
			ItemId: line.ItemID, ItemCode: line.ItemCode,
			Available: int32(line.Available), Minimum: int32(line.Minimum),
			Quantity: int32(line.Quantity), Stockout: line.Stockout,
		})
	}
	return connect.NewResponse(&materialsv1.SuggestOrderResponse{
		LocationId: suggested.LocationID, Lines: lines,
	}), nil
}

func (h *Handler) RecordInvoice(ctx context.Context,
	req *connect.Request[materialsv1.RecordInvoiceRequest]) (
	*connect.Response[materialsv1.RecordInvoiceResponse], error) {

	msg := req.Msg
	invoice, err := h.svc.RecordInvoice(ctx, application.RecordInvoiceInput{
		Number: msg.GetNumber(), SupplierID: msg.GetSupplierId(),
		PurchaseOrderID: msg.GetPurchaseOrderId(),
		Lines:           invoiceLinesFromProto(msg.GetLines()),
		Currency:        msg.GetCurrency(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.RecordInvoiceResponse{
		Invoice: invoiceToProto(invoice),
	}), nil
}

func (h *Handler) MatchInvoice(ctx context.Context,
	req *connect.Request[materialsv1.MatchInvoiceRequest]) (
	*connect.Response[materialsv1.MatchInvoiceResponse], error) {

	result, err := h.svc.Match(ctx, req.Msg.GetInvoiceId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.MatchInvoiceResponse{
		Result: matchToProto(result),
	}), nil
}

func (h *Handler) GetMetrics(ctx context.Context,
	req *connect.Request[materialsv1.GetMetricsRequest]) (
	*connect.Response[materialsv1.GetMetricsResponse], error) {

	msg := req.Msg
	metrics, err := h.svc.Metrics(ctx, msg.GetItemId(), msg.GetLocationId(),
		timeOf(msg.GetPeriodStart()), timeOf(msg.GetPeriodEnd()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.GetMetricsResponse{
		Metrics: metricsToProto(metrics),
	}), nil
}

func (h *Handler) GetFillRate(ctx context.Context,
	req *connect.Request[materialsv1.GetFillRateRequest]) (
	*connect.Response[materialsv1.GetFillRateResponse], error) {

	msg := req.Msg
	rate, err := h.svc.FillRate(ctx, msg.GetSupplierId(),
		timeOf(msg.GetPeriodStart()), timeOf(msg.GetPeriodEnd()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.GetFillRateResponse{
		FillRate: fillRateToProto(rate),
	}), nil
}

func (h *Handler) ListLiabilities(ctx context.Context,
	req *connect.Request[materialsv1.ListLiabilitiesRequest]) (
	*connect.Response[materialsv1.ListLiabilitiesResponse], error) {

	msg := req.Msg
	liabilities, err := h.svc.Liabilities(ctx, msg.GetSupplierId(),
		timeOf(msg.GetPeriodStart()), timeOf(msg.GetPeriodEnd()),
		msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&materialsv1.ListLiabilitiesResponse{
		Liabilities: liabilitiesToProto(liabilities),
	}), nil
}
