// Package transport translates between the materials contract and the domain.
//
// The enum maps are one-way tables in both directions rather than casts,
// because the wire enum and the domain constant are allowed to diverge and a
// cast would hide it. Each default fails in the safe direction: an
// unrecognised stock status stays empty, and the domain refuses it rather than
// guessing that a client meant "available".
package transport

import (
	"time"

	materialsv1 "github.com/ppusapati/health/code/gen/go/healthcare/materials/v1"
	"github.com/ppusapati/health/code/internal/materials/domain"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func stamp(t time.Time) *timestamppb.Timestamp {
	if t.IsZero() {
		// Absent rather than the epoch: a zero timestamp on the wire reads as
		// 1970, and an expiry of 1970 would take good stock off the shelf.
		return nil
	}
	return timestamppb.New(t.UTC())
}

func timeOf(t *timestamppb.Timestamp) time.Time {
	if t == nil {
		return time.Time{}
	}
	return t.AsTime().UTC()
}

var trackingFromWire = map[materialsv1.Tracking]domain.Tracking{
	materialsv1.Tracking_TRACKING_QUANTITY: domain.TrackingQuantity,
	materialsv1.Tracking_TRACKING_BATCH:    domain.TrackingBatch,
	materialsv1.Tracking_TRACKING_SERIAL:   domain.TrackingSerial,
}

var trackingToWire = map[domain.Tracking]materialsv1.Tracking{
	domain.TrackingQuantity: materialsv1.Tracking_TRACKING_QUANTITY,
	domain.TrackingBatch:    materialsv1.Tracking_TRACKING_BATCH,
	domain.TrackingSerial:   materialsv1.Tracking_TRACKING_SERIAL,
}

var policyFromWire = map[materialsv1.PickPolicy]domain.PickPolicy{
	materialsv1.PickPolicy_PICK_POLICY_FEFO:   domain.PickFEFO,
	materialsv1.PickPolicy_PICK_POLICY_FIFO:   domain.PickFIFO,
	materialsv1.PickPolicy_PICK_POLICY_SERIAL: domain.PickSerial,
}

var policyToWire = map[domain.PickPolicy]materialsv1.PickPolicy{
	domain.PickFEFO:   materialsv1.PickPolicy_PICK_POLICY_FEFO,
	domain.PickFIFO:   materialsv1.PickPolicy_PICK_POLICY_FIFO,
	domain.PickSerial: materialsv1.PickPolicy_PICK_POLICY_SERIAL,
}

var ownershipFromWire = map[materialsv1.Ownership]domain.Ownership{
	materialsv1.Ownership_OWNERSHIP_HOSPITAL:    domain.OwnedByHospital,
	materialsv1.Ownership_OWNERSHIP_CONSIGNMENT: domain.OwnedConsignment,
}

var ownershipToWire = map[domain.Ownership]materialsv1.Ownership{
	domain.OwnedByHospital:  materialsv1.Ownership_OWNERSHIP_HOSPITAL,
	domain.OwnedConsignment: materialsv1.Ownership_OWNERSHIP_CONSIGNMENT,
}

var statusFromWire = map[materialsv1.StockStatus]domain.StockStatus{
	materialsv1.StockStatus_STOCK_STATUS_QUARANTINE: domain.StatusQuarantine,
	materialsv1.StockStatus_STOCK_STATUS_AVAILABLE:  domain.StatusAvailable,
	materialsv1.StockStatus_STOCK_STATUS_IN_TRANSIT: domain.StatusInTransit,
	materialsv1.StockStatus_STOCK_STATUS_REJECTED:   domain.StatusRejected,
}

var statusToWire = map[domain.StockStatus]materialsv1.StockStatus{
	domain.StatusQuarantine: materialsv1.StockStatus_STOCK_STATUS_QUARANTINE,
	domain.StatusAvailable:  materialsv1.StockStatus_STOCK_STATUS_AVAILABLE,
	domain.StatusInTransit:  materialsv1.StockStatus_STOCK_STATUS_IN_TRANSIT,
	domain.StatusRejected:   materialsv1.StockStatus_STOCK_STATUS_REJECTED,
}

var kindToWire = map[domain.MovementKind]materialsv1.MovementKind{
	domain.MovementReceipt:     materialsv1.MovementKind_MOVEMENT_KIND_RECEIPT,
	domain.MovementAccept:      materialsv1.MovementKind_MOVEMENT_KIND_ACCEPT,
	domain.MovementReject:      materialsv1.MovementKind_MOVEMENT_KIND_REJECT,
	domain.MovementIssue:       materialsv1.MovementKind_MOVEMENT_KIND_ISSUE,
	domain.MovementReturn:      materialsv1.MovementKind_MOVEMENT_KIND_RETURN,
	domain.MovementTransferOut: materialsv1.MovementKind_MOVEMENT_KIND_TRANSFER_OUT,
	domain.MovementTransferIn:  materialsv1.MovementKind_MOVEMENT_KIND_TRANSFER_IN,
	domain.MovementAdjustment:  materialsv1.MovementKind_MOVEMENT_KIND_ADJUSTMENT,
	domain.MovementConsumption: materialsv1.MovementKind_MOVEMENT_KIND_CONSUMPTION,
	domain.MovementDisposal:    materialsv1.MovementKind_MOVEMENT_KIND_DISPOSAL,
}

var sourceFromWire = map[materialsv1.RequisitionSource]domain.RequisitionSource{
	materialsv1.RequisitionSource_REQUISITION_SOURCE_MANUAL:        domain.SourceManual,
	materialsv1.RequisitionSource_REQUISITION_SOURCE_MIN_MAX:       domain.SourceMinMax,
	materialsv1.RequisitionSource_REQUISITION_SOURCE_PROCEDURE:     domain.SourceProcedure,
	materialsv1.RequisitionSource_REQUISITION_SOURCE_REPLENISHMENT: domain.SourceReplenishment,
}

var sourceToWire = map[domain.RequisitionSource]materialsv1.RequisitionSource{
	domain.SourceManual:        materialsv1.RequisitionSource_REQUISITION_SOURCE_MANUAL,
	domain.SourceMinMax:        materialsv1.RequisitionSource_REQUISITION_SOURCE_MIN_MAX,
	domain.SourceProcedure:     materialsv1.RequisitionSource_REQUISITION_SOURCE_PROCEDURE,
	domain.SourceReplenishment: materialsv1.RequisitionSource_REQUISITION_SOURCE_REPLENISHMENT,
}

var requisitionStateToWire = map[domain.RequisitionState]materialsv1.RequisitionState{
	domain.RequisitionDraft:     materialsv1.RequisitionState_REQUISITION_STATE_DRAFT,
	domain.RequisitionPending:   materialsv1.RequisitionState_REQUISITION_STATE_PENDING_APPROVAL,
	domain.RequisitionApproved:  materialsv1.RequisitionState_REQUISITION_STATE_APPROVED,
	domain.RequisitionRejected:  materialsv1.RequisitionState_REQUISITION_STATE_REJECTED,
	domain.RequisitionOrdered:   materialsv1.RequisitionState_REQUISITION_STATE_ORDERED,
	domain.RequisitionCancelled: materialsv1.RequisitionState_REQUISITION_STATE_CANCELLED,
}

var decisionFromWire = map[materialsv1.ApprovalDecision]domain.ApprovalDecision{
	materialsv1.ApprovalDecision_APPROVAL_DECISION_APPROVED: domain.ApprovalApproved,
	materialsv1.ApprovalDecision_APPROVAL_DECISION_REJECTED: domain.ApprovalRejected,
}

var decisionToWire = map[domain.ApprovalDecision]materialsv1.ApprovalDecision{
	domain.ApprovalApproved: materialsv1.ApprovalDecision_APPROVAL_DECISION_APPROVED,
	domain.ApprovalRejected: materialsv1.ApprovalDecision_APPROVAL_DECISION_REJECTED,
}

var orderStateToWire = map[domain.POState]materialsv1.PurchaseOrderState{
	domain.PODraft:     materialsv1.PurchaseOrderState_PURCHASE_ORDER_STATE_DRAFT,
	domain.POIssued:    materialsv1.PurchaseOrderState_PURCHASE_ORDER_STATE_ISSUED,
	domain.POPartial:   materialsv1.PurchaseOrderState_PURCHASE_ORDER_STATE_PARTLY_RECEIVED,
	domain.POReceived:  materialsv1.PurchaseOrderState_PURCHASE_ORDER_STATE_RECEIVED,
	domain.POClosed:    materialsv1.PurchaseOrderState_PURCHASE_ORDER_STATE_CLOSED,
	domain.POCancelled: materialsv1.PurchaseOrderState_PURCHASE_ORDER_STATE_CANCELLED,
}

var transferStateToWire = map[domain.TransferState]materialsv1.TransferState{
	domain.TransferInTransit: materialsv1.TransferState_TRANSFER_STATE_IN_TRANSIT,
	domain.TransferReceived:  materialsv1.TransferState_TRANSFER_STATE_RECEIVED,
	domain.TransferCancelled: materialsv1.TransferState_TRANSFER_STATE_CANCELLED,
}

var countStateToWire = map[domain.CountState]materialsv1.CountState{
	domain.CountOpen:     materialsv1.CountState_COUNT_STATE_OPEN,
	domain.CountCounted:  materialsv1.CountState_COUNT_STATE_COUNTED,
	domain.CountApproved: materialsv1.CountState_COUNT_STATE_APPROVED,
	domain.CountRejected: materialsv1.CountState_COUNT_STATE_REJECTED,
}

var alertKindToWire = map[domain.AlertKind]materialsv1.AlertKind{
	domain.AlertStockout:     materialsv1.AlertKind_ALERT_KIND_STOCKOUT,
	domain.AlertBelowMinimum: materialsv1.AlertKind_ALERT_KIND_BELOW_MINIMUM,
	domain.AlertExpiringSoon: materialsv1.AlertKind_ALERT_KIND_EXPIRING_SOON,
	domain.AlertExpired:      materialsv1.AlertKind_ALERT_KIND_EXPIRED,
}

var matchStatusToWire = map[domain.MatchStatus]materialsv1.MatchStatus{
	domain.MatchOK:       materialsv1.MatchStatus_MATCH_STATUS_MATCHED,
	domain.MatchQuantity: materialsv1.MatchStatus_MATCH_STATUS_QUANTITY_MISMATCH,
	domain.MatchPrice:    materialsv1.MatchStatus_MATCH_STATUS_PRICE_MISMATCH,
	domain.MatchMissing:  materialsv1.MatchStatus_MATCH_STATUS_MISSING_DOCUMENT,
}

func moneyFromProto(in *materialsv1.Money) domain.Money {
	if in == nil {
		return domain.Money{}
	}
	return domain.Money{Minor: in.GetMinor(), Currency: in.GetCurrency()}
}

func moneyToProto(in domain.Money) *materialsv1.Money {
	return &materialsv1.Money{Minor: in.Minor, Currency: in.Currency}
}

func bucketFromProto(in *materialsv1.Bucket) domain.Bucket {
	if in == nil {
		return domain.Outside
	}
	return domain.Bucket{
		LocationID: in.GetLocationId(),
		Status:     statusFromWire[in.GetStatus()],
	}
}

func bucketToProto(in domain.Bucket) *materialsv1.Bucket {
	return &materialsv1.Bucket{
		LocationId: in.LocationID, Status: statusToWire[in.Status],
	}
}

func itemToProto(in domain.Item) *materialsv1.Item {
	return &materialsv1.Item{
		ItemId: in.ID, Code: in.Code, Display: in.Display,
		Category: in.Category, Uom: in.UOM,
		Tracking: trackingToWire[in.Tracking], Policy: policyToWire[in.Policy],
		Perishable: in.Perishable, InspectOnReceipt: in.InspectOnReceipt,
		Consignable: in.Consignable, Active: in.Active,
		CreatedAt: stamp(in.CreatedAt), CreatedBy: in.CreatedBy,
		Version: in.Version,
	}
}

func itemsToProto(in []domain.Item) []*materialsv1.Item {
	out := make([]*materialsv1.Item, 0, len(in))
	for _, item := range in {
		out = append(out, itemToProto(item))
	}
	return out
}

func supplierToProto(in domain.Supplier) *materialsv1.Supplier {
	return &materialsv1.Supplier{
		SupplierId: in.ID, Code: in.Code, Display: in.Display,
		Approved:     in.Approved,
		ContactEmail: in.ContactEmail, ContactPhone: in.ContactPhone,
		PaymentTermsDays: int32(in.PaymentTermsDays), Currency: in.Currency,
		CreatedAt: stamp(in.CreatedAt), CreatedBy: in.CreatedBy,
		Version: in.Version,
	}
}

func suppliersToProto(in []domain.Supplier) []*materialsv1.Supplier {
	out := make([]*materialsv1.Supplier, 0, len(in))
	for _, supplier := range in {
		out = append(out, supplierToProto(supplier))
	}
	return out
}

// lotToProto renders a lot.
//
// The clock is passed in because issuable is two independent failures —
// blocked and expired — and a client that checked only the block would offer
// out-of-date stock.
func lotToProto(in domain.Lot, now time.Time) *materialsv1.Lot {
	return &materialsv1.Lot{
		LotId: in.ID, ItemId: in.ItemID, Code: in.Code,
		Expiry: stamp(in.Expiry), ReceivedAt: stamp(in.ReceivedAt),
		Ownership: ownershipToWire[in.Ownership], SupplierId: in.SupplierID,
		Blocked: in.Blocked, BlockedReason: in.BlockedReason,
		BlockedAt: stamp(in.BlockedAt), BlockedBy: in.BlockedBy,
		Version: in.Version, Issuable: in.Issuable(now),
	}
}

func lotsToProto(in []domain.Lot, now time.Time) []*materialsv1.Lot {
	out := make([]*materialsv1.Lot, 0, len(in))
	for _, lot := range in {
		out = append(out, lotToProto(lot, now))
	}
	return out
}

func movementToProto(in domain.Movement) *materialsv1.Movement {
	return &materialsv1.Movement{
		MovementId: in.ID, ItemId: in.ItemID, LotId: in.LotID,
		From: bucketToProto(in.From), To: bucketToProto(in.To),
		Quantity: int32(in.Quantity), Kind: kindToWire[in.Kind],
		Reference: in.Reference, Reason: in.Reason,
		CostCentre: in.CostCentre, PatientId: in.PatientID,
		EncounterId: in.EncounterID,
		OccurredAt:  stamp(in.OccurredAt), RecordedBy: in.RecordedBy,
	}
}

func movementsToProto(in []domain.Movement) []*materialsv1.Movement {
	out := make([]*materialsv1.Movement, 0, len(in))
	for _, movement := range in {
		out = append(out, movementToProto(movement))
	}
	return out
}

func balanceToProto(in domain.Balance) *materialsv1.Balance {
	return &materialsv1.Balance{
		ItemId: in.ItemID, LotId: in.LotID,
		Bucket: bucketToProto(in.Bucket), Quantity: int32(in.Quantity),
	}
}

func balancesToProto(in []domain.Balance) []*materialsv1.Balance {
	out := make([]*materialsv1.Balance, 0, len(in))
	for _, balance := range in {
		out = append(out, balanceToProto(balance))
	}
	return out
}

func stockLevelFromProto(in *materialsv1.StockLevel) domain.StockLevel {
	if in == nil {
		return domain.StockLevel{}
	}
	return domain.StockLevel{
		ItemID: in.GetItemId(), LocationID: in.GetLocationId(),
		Minimum: int(in.GetMinimum()), Maximum: int(in.GetMaximum()),
		ReorderQuantity: int(in.GetReorderQuantity()),
	}
}

func stockLevelsToProto(in []domain.StockLevel) []*materialsv1.StockLevel {
	out := make([]*materialsv1.StockLevel, 0, len(in))
	for _, level := range in {
		out = append(out, &materialsv1.StockLevel{
			ItemId: level.ItemID, LocationId: level.LocationID,
			Minimum: int32(level.Minimum), Maximum: int32(level.Maximum),
			ReorderQuantity: int32(level.ReorderQuantity),
		})
	}
	return out
}

func requisitionLinesFromProto(
	in []*materialsv1.RequisitionLine) []domain.RequisitionLine {

	out := make([]domain.RequisitionLine, 0, len(in))
	for _, line := range in {
		out = append(out, domain.RequisitionLine{
			ItemID: line.GetItemId(), ItemCode: line.GetItemCode(),
			Quantity: int(line.GetQuantity()), UOM: line.GetUom(),
			EstimatedUnitPrice: moneyFromProto(line.GetEstimatedUnitPrice()),
			Notes:              line.GetNotes(),
		})
	}
	return out
}

func requisitionLinesToProto(
	in []domain.RequisitionLine) []*materialsv1.RequisitionLine {

	out := make([]*materialsv1.RequisitionLine, 0, len(in))
	for _, line := range in {
		out = append(out, &materialsv1.RequisitionLine{
			ItemId: line.ItemID, ItemCode: line.ItemCode,
			Quantity: int32(line.Quantity), Uom: line.UOM,
			EstimatedUnitPrice: moneyToProto(line.EstimatedUnitPrice),
			Notes:              line.Notes,
		})
	}
	return out
}

func approvalStepToProto(in domain.ApprovalStep) *materialsv1.ApprovalStep {
	return &materialsv1.ApprovalStep{
		ApprovalStepId: in.ID, Level: int32(in.Level), Role: in.Role,
		Decision: decisionToWire[in.Decision], Decider: in.Decider,
		Note: in.Note, DecidedAt: stamp(in.At),
	}
}

func requisitionToProto(in domain.Requisition) *materialsv1.Requisition {
	steps := make([]*materialsv1.ApprovalStep, 0, len(in.Approvals))
	for _, step := range in.Approvals {
		steps = append(steps, approvalStepToProto(step))
	}
	return &materialsv1.Requisition{
		RequisitionId: in.ID, Number: in.Number, FacilityId: in.FacilityID,
		Source: sourceToWire[in.Source], NeedBy: stamp(in.NeedBy),
		CostCentre: in.CostCentre, SourceReference: in.SourceReference,
		Lines: requisitionLinesToProto(in.Lines),
		State: requisitionStateToWire[in.State], Approvals: steps,
		Justification: in.Justification,
		RaisedAt:      stamp(in.RaisedAt), RaisedBy: in.RaisedBy,
		Version: in.Version,
	}
}

func requisitionsToProto(in []domain.Requisition) []*materialsv1.Requisition {
	out := make([]*materialsv1.Requisition, 0, len(in))
	for _, requisition := range in {
		out = append(out, requisitionToProto(requisition))
	}
	return out
}

func approvalRulesToProto(in []domain.ApprovalRule) []*materialsv1.ApprovalRule {
	out := make([]*materialsv1.ApprovalRule, 0, len(in))
	for _, rule := range in {
		out = append(out, &materialsv1.ApprovalRule{
			ApprovalRuleId: rule.ID, MinimumValue: rule.MinimumValue,
			Currency: rule.Currency, Category: rule.Category,
			FacilityId: rule.FacilityID, Roles: rule.Roles,
		})
	}
	return out
}

func bidLinesFromProto(in []*materialsv1.BidLine) []domain.BidLine {
	out := make([]domain.BidLine, 0, len(in))
	for _, line := range in {
		out = append(out, domain.BidLine{
			ItemID:    line.GetItemId(),
			UnitPrice: moneyFromProto(line.GetUnitPrice()),
			Quantity:  int(line.GetQuantity()),
			PackSize:  int(line.GetPackSize()),
		})
	}
	return out
}

func bidToProto(in domain.Bid) *materialsv1.Bid {
	lines := make([]*materialsv1.BidLine, 0, len(in.Lines))
	for _, line := range in.Lines {
		lines = append(lines, &materialsv1.BidLine{
			ItemId: line.ItemID, UnitPrice: moneyToProto(line.UnitPrice),
			Quantity: int32(line.Quantity), PackSize: int32(line.PackSize),
		})
	}
	return &materialsv1.Bid{
		BidId: in.ID, RfqId: in.RFQID, SupplierId: in.SupplierID,
		Lines: lines, LeadTimeDays: int32(in.LeadTimeDays),
		WarrantyMonths:   int32(in.WarrantyMonths),
		PaymentTermsDays: int32(in.PaymentTermsDays),
		FreightMinor:     in.FreightMinor, TaxMinor: in.TaxMinor,
		Currency: in.Currency, Notes: in.Notes,
		ReceivedAt: stamp(in.ReceivedAt), RecordedBy: in.RecordedBy,
	}
}

func rfqToProto(in domain.RFQ) *materialsv1.Rfq {
	return &materialsv1.Rfq{
		RfqId: in.ID, Number: in.Number, RequisitionId: in.RequisitionID,
		SupplierIds: in.SupplierIDs,
		Lines:       requisitionLinesToProto(in.Lines),
		ClosesAt:    stamp(in.ClosesAt),
		IssuedAt:    stamp(in.IssuedAt), IssuedBy: in.IssuedBy,
		Version: in.Version,
	}
}

func rfqsToProto(in []domain.RFQ) []*materialsv1.Rfq {
	out := make([]*materialsv1.Rfq, 0, len(in))
	for _, rfq := range in {
		out = append(out, rfqToProto(rfq))
	}
	return out
}

func comparisonsToProto(in []domain.Comparison) []*materialsv1.Comparison {
	out := make([]*materialsv1.Comparison, 0, len(in))
	for _, comparison := range in {
		out = append(out, &materialsv1.Comparison{
			BidId: comparison.BidID, SupplierId: comparison.SupplierID,
			LandedMinor: comparison.LandedMinor, Currency: comparison.Currency,
			UnitMinor:        comparison.UnitMinor,
			LeadTimeDays:     int32(comparison.LeadTimeDays),
			PaymentTermsDays: int32(comparison.PaymentTermsDays),
			WarrantyMonths:   int32(comparison.WarrantyMonths),
			Incomparable:     comparison.Incomparable,
		})
	}
	return out
}

func orderLinesFromProto(
	in []*materialsv1.PurchaseOrderLine) []domain.POLine {

	out := make([]domain.POLine, 0, len(in))
	for _, line := range in {
		out = append(out, domain.POLine{
			ItemID: line.GetItemId(), ItemCode: line.GetItemCode(),
			Quantity: int(line.GetQuantity()), PackSize: int(line.GetPackSize()),
			UOM: line.GetUom(), UnitPrice: moneyFromProto(line.GetUnitPrice()),
			TaxMinor: line.GetTaxMinor(), DiscountMinor: line.GetDiscountMinor(),
			DeliverBy: timeOf(line.GetDeliverBy()), Notes: line.GetNotes(),
		})
	}
	return out
}

func orderToProto(in domain.PurchaseOrder) *materialsv1.PurchaseOrder {
	lines := make([]*materialsv1.PurchaseOrderLine, 0, len(in.Lines))
	for _, line := range in.Lines {
		lines = append(lines, &materialsv1.PurchaseOrderLine{
			ItemId: line.ItemID, ItemCode: line.ItemCode,
			Quantity: int32(line.Quantity), PackSize: int32(line.PackSize),
			Uom: line.UOM, UnitPrice: moneyToProto(line.UnitPrice),
			TaxMinor: line.TaxMinor, DiscountMinor: line.DiscountMinor,
			DeliverBy: stamp(line.DeliverBy), Notes: line.Notes,
		})
	}

	out := &materialsv1.PurchaseOrder{
		PurchaseOrderId: in.ID, Number: in.Number, FacilityId: in.FacilityID,
		SupplierId: in.SupplierID, RequisitionId: in.RequisitionID,
		BidId: in.BidID, Revision: int32(in.Revision), ChainId: in.ChainID,
		Supersedes: in.Supersedes, AmendmentReason: in.AmendmentReason,
		Lines: lines, State: orderStateToWire[in.State],
		Currency: in.Currency, PaymentTermsDays: int32(in.PaymentTermsDays),
		DeliveryTerms:         in.DeliveryTerms,
		ToleranceOverPercent:  int32(in.ToleranceOverPercent),
		ToleranceShortPercent: int32(in.ToleranceShortPercent),
		IssuedAt:              stamp(in.IssuedAt), IssuedBy: in.IssuedBy,
		CreatedAt: stamp(in.CreatedAt), CreatedBy: in.CreatedBy,
		Version: in.Version,
	}
	// Derived, so a client need not total the lines itself and get the tax
	// and the discount the wrong way round. A mixed-currency order has no
	// total, and leaving it unset says so rather than rendering a number that
	// added rupees to dollars.
	if total, err := in.Total(); err == nil {
		out.Total = moneyToProto(total)
	}
	return out
}

func ordersToProto(in []domain.PurchaseOrder) []*materialsv1.PurchaseOrder {
	out := make([]*materialsv1.PurchaseOrder, 0, len(in))
	for _, order := range in {
		out = append(out, orderToProto(order))
	}
	return out
}

func receiptLinesFromProto(
	in []*materialsv1.ReceiptLine) []domain.ReceiptLine {

	out := make([]domain.ReceiptLine, 0, len(in))
	for _, line := range in {
		out = append(out, domain.ReceiptLine{
			ItemID: line.GetItemId(), ItemCode: line.GetItemCode(),
			LotCode: line.GetLotCode(), Expiry: timeOf(line.GetExpiry()),
			QuantityReceived: int(line.GetQuantityReceived()),
			Ownership:        ownershipFromWire[line.GetOwnership()],
			SupplierID:       line.GetSupplierId(), Notes: line.GetNotes(),
		})
	}
	return out
}

func receiptToProto(in domain.Receipt) *materialsv1.Receipt {
	lines := make([]*materialsv1.ReceiptLine, 0, len(in.Lines))
	for _, line := range in.Lines {
		lines = append(lines, &materialsv1.ReceiptLine{
			ItemId: line.ItemID, ItemCode: line.ItemCode,
			LotCode: line.LotCode, Expiry: stamp(line.Expiry),
			QuantityOrdered:  int32(line.QuantityOrdered),
			QuantityReceived: int32(line.QuantityReceived),
			Ownership:        ownershipToWire[line.Ownership],
			SupplierId:       line.SupplierID, Notes: line.Notes,
			// Derived, so the difference reads on the row rather than being
			// recomputed by every client that displays it.
			Discrepancy: int32(line.Discrepancy()),
		})
	}
	return &materialsv1.Receipt{
		ReceiptId: in.ID, Number: in.Number,
		PurchaseOrderId: in.PurchaseOrderID, PoRevision: int32(in.PORevision),
		SupplierId: in.SupplierID, LocationId: in.LocationID,
		DeliveryNote: in.DeliveryNote, InvoiceRef: in.InvoiceRef,
		Lines:      lines,
		ReceivedAt: stamp(in.ReceivedAt), ReceivedBy: in.ReceivedBy,
		Version: in.Version,
	}
}

func receiptsToProto(in []domain.Receipt) []*materialsv1.Receipt {
	out := make([]*materialsv1.Receipt, 0, len(in))
	for _, receipt := range in {
		out = append(out, receiptToProto(receipt))
	}
	return out
}

func pickToProto(in domain.Pick) *materialsv1.Pick {
	lines := make([]*materialsv1.PickLine, 0, len(in.Lines))
	for _, line := range in.Lines {
		lines = append(lines, &materialsv1.PickLine{
			LotId: line.LotID, LotCode: line.LotCode,
			Bucket: bucketToProto(line.Bucket), Quantity: int32(line.Quantity),
			Expiry: stamp(line.Expiry),
		})
	}
	return &materialsv1.Pick{
		ItemId: in.ItemID, Lines: lines, Short: int32(in.Short),
		Skipped: in.Skipped,
	}
}

func liabilityToProto(in domain.LiabilityEvent) *materialsv1.LiabilityEvent {
	return &materialsv1.LiabilityEvent{
		LiabilityEventId: in.ID, LotId: in.LotID, ItemId: in.ItemID,
		SupplierId: in.SupplierID, Quantity: int32(in.Quantity),
		PatientId: in.PatientID, EncounterId: in.EncounterID,
		MovementId: in.MovementID,
		OccurredAt: stamp(in.OccurredAt), RecordedBy: in.RecordedBy,
	}
}

func liabilitiesToProto(
	in []domain.LiabilityEvent) []*materialsv1.LiabilityEvent {

	out := make([]*materialsv1.LiabilityEvent, 0, len(in))
	for _, event := range in {
		out = append(out, liabilityToProto(event))
	}
	return out
}

func transferLinesFromProto(
	in []*materialsv1.TransferLine) []domain.TransferLine {

	out := make([]domain.TransferLine, 0, len(in))
	for _, line := range in {
		out = append(out, domain.TransferLine{
			ItemID: line.GetItemId(), LotID: line.GetLotId(),
			Quantity: int(line.GetQuantity()),
		})
	}
	return out
}

func transferToProto(in domain.Transfer) *materialsv1.Transfer {
	lines := make([]*materialsv1.TransferLine, 0, len(in.Lines))
	for _, line := range in.Lines {
		lines = append(lines, &materialsv1.TransferLine{
			ItemId: line.ItemID, LotId: line.LotID,
			Quantity: int32(line.Quantity),
			// Carried rather than dropped: two cartons short of a hundred is
			// an investigation, and the number is where it starts.
			QuantityReceived: int32(line.QuantityReceived),
		})
	}
	return &materialsv1.Transfer{
		TransferId: in.ID, Number: in.Number,
		FromLocation: in.FromLocation, ToLocation: in.ToLocation,
		Lines: lines, State: transferStateToWire[in.State], Reason: in.Reason,
		DispatchedAt: stamp(in.DispatchedAt), DispatchedBy: in.DispatchedBy,
		ReceivedAt: stamp(in.ReceivedAt), ReceivedBy: in.ReceivedBy,
		Version: in.Version,
	}
}

func transfersToProto(in []domain.Transfer) []*materialsv1.Transfer {
	out := make([]*materialsv1.Transfer, 0, len(in))
	for _, transfer := range in {
		out = append(out, transferToProto(transfer))
	}
	return out
}

func countLinesFromProto(in []*materialsv1.CountLine) []domain.CountLine {
	out := make([]domain.CountLine, 0, len(in))
	for _, line := range in {
		out = append(out, domain.CountLine{
			ItemID: line.GetItemId(), LotID: line.GetLotId(),
			// Expected is deliberately not read from the wire: it comes from
			// the count as opened, because a client sending its own
			// expectation could make any variance disappear.
			Counted: int(line.GetCounted()), Reason: line.GetReason(),
		})
	}
	return out
}

func countToProto(in domain.Count) *materialsv1.Count {
	lines := make([]*materialsv1.CountLine, 0, len(in.Lines))
	for _, line := range in.Lines {
		lines = append(lines, &materialsv1.CountLine{
			ItemId: line.ItemID, LotId: line.LotID,
			Expected: int32(line.Expected), Counted: int32(line.Counted),
			Reason: line.Reason, Variance: int32(line.Variance()),
		})
	}
	return &materialsv1.Count{
		CountId: in.ID, Number: in.Number, LocationId: in.LocationID,
		Cycle: in.Cycle, Lines: lines, State: countStateToWire[in.State],
		ApprovedBy: in.ApprovedBy, ApprovedAt: stamp(in.ApprovedAt),
		ApprovalNote: in.ApprovalNote,
		OpenedAt:     stamp(in.OpenedAt), OpenedBy: in.OpenedBy,
		CountedAt: stamp(in.CountedAt), CountedBy: in.CountedBy,
		Version: in.Version,
	}
}

func countsToProto(in []domain.Count) []*materialsv1.Count {
	out := make([]*materialsv1.Count, 0, len(in))
	for _, count := range in {
		out = append(out, countToProto(count))
	}
	return out
}

func alertsToProto(in []domain.Alert) []*materialsv1.Alert {
	out := make([]*materialsv1.Alert, 0, len(in))
	for _, alert := range in {
		out = append(out, &materialsv1.Alert{
			Kind: alertKindToWire[alert.Kind], ItemId: alert.ItemID,
			LocationId: alert.LocationID, LotId: alert.LotID,
			Available: int32(alert.Available), Minimum: int32(alert.Minimum),
			SuggestedOrder: int32(alert.SuggestedOrder),
			Expiry:         stamp(alert.Expiry), Detail: alert.Detail,
		})
	}
	return out
}

func invoiceLinesFromProto(
	in []*materialsv1.InvoiceLine) []domain.InvoiceLine {

	out := make([]domain.InvoiceLine, 0, len(in))
	for _, line := range in {
		out = append(out, domain.InvoiceLine{
			ItemID: line.GetItemId(), Quantity: int(line.GetQuantity()),
			UnitPrice: moneyFromProto(line.GetUnitPrice()),
			TaxMinor:  line.GetTaxMinor(),
		})
	}
	return out
}

func invoiceToProto(in domain.Invoice) *materialsv1.Invoice {
	lines := make([]*materialsv1.InvoiceLine, 0, len(in.Lines))
	for _, line := range in.Lines {
		lines = append(lines, &materialsv1.InvoiceLine{
			ItemId: line.ItemID, Quantity: int32(line.Quantity),
			UnitPrice: moneyToProto(line.UnitPrice), TaxMinor: line.TaxMinor,
		})
	}
	return &materialsv1.Invoice{
		InvoiceId: in.ID, Number: in.Number, SupplierId: in.SupplierID,
		PurchaseOrderId: in.PurchaseOrderID, Lines: lines,
		Currency:   in.Currency,
		ReceivedAt: stamp(in.ReceivedAt), RecordedBy: in.RecordedBy,
	}
}

func matchToProto(in domain.MatchResult) *materialsv1.MatchResult {
	lines := make([]*materialsv1.MatchLine, 0, len(in.Lines))
	for _, line := range in.Lines {
		lines = append(lines, &materialsv1.MatchLine{
			ItemId: line.ItemID, Status: matchStatusToWire[line.Status],
			Ordered: int32(line.Ordered), Received: int32(line.Received),
			Invoiced:          int32(line.Invoiced),
			OrderedUnitMinor:  line.OrderedUnitMinor,
			InvoicedUnitMinor: line.InvoicedUnitMinor,
			Detail:            line.Detail,
		})
	}
	return &materialsv1.MatchResult{
		PurchaseOrderId: in.PurchaseOrderID, InvoiceId: in.InvoiceID,
		Lines: lines, Matched: in.Matched,
	}
}

func recallToProto(in domain.RecallList) *materialsv1.RecallList {
	return &materialsv1.RecallList{
		LotId: in.LotID, LotCode: in.LotCode, ItemId: in.ItemID,
		Reason:   in.Reason,
		Holdings: balancesToProto(in.Holdings),
		// Carried in full, because a recall that only listed the stock still
		// on a shelf would miss exactly the patients it exists to find.
		Consumptions: movementsToProto(in.Consumptions),
		Patients:     in.Patients,
	}
}

func metricsToProto(in domain.Metrics) *materialsv1.Metrics {
	return &materialsv1.Metrics{
		ItemId: in.ItemID, LocationId: in.LocationID,
		PeriodStart: stamp(in.From), PeriodEnd: stamp(in.To),
		ConsumedUnits: int32(in.ConsumedUnits),
		OpeningOnHand: int32(in.OpeningOnHand),
		ClosingOnHand: int32(in.ClosingOnHand),
		AverageOnHand: int32(in.AverageOnHand),
		TurnsPerYear:  in.TurnsPerYear, DaysOnHand: in.DaysOnHand,
		ExpiryExposureUnits: int32(in.ExpiryExposureUnits),
		// So a reader can tell a real zero from a gap.
		Incomplete: in.Incomplete,
	}
}

func fillRateToProto(in domain.SupplierFillRate) *materialsv1.SupplierFillRate {
	return &materialsv1.SupplierFillRate{
		SupplierId:  in.SupplierID,
		PeriodStart: stamp(in.From), PeriodEnd: stamp(in.To),
		OrderedUnits:  int32(in.OrderedUnits),
		ReceivedUnits: int32(in.ReceivedUnits), FillRate: in.FillRate,
		OnTimeLines: int32(in.OnTimeLines), LateLines: int32(in.LateLines),
		Incomplete: in.Incomplete,
	}
}
