package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/materials/domain"
	"github.com/ppusapati/health/code/internal/materials/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// ProcurementRepo implements ports.ProcurementRepository.
type ProcurementRepo struct{ *Repository }

var _ ports.ProcurementRepository = ProcurementRepo{}

// InsertRequisition raises a request to buy.
func (r ProcurementRepo) InsertRequisition(ctx context.Context,
	scope authctx.TenantScope, req domain.Requisition) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	requisitionID, err := uuid.Parse(req.ID)
	if err != nil {
		return notFound()
	}
	lines, err := encode(req.Lines)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertRequisition(ctx, sqlcgen.InsertRequisitionParams{
		RequisitionID: requisitionID, TenantID: tenantID,
		Number: req.Number, FacilityID: optionalUUID(req.FacilityID),
		Source: string(req.Source), NeedBy: stamp(req.NeedBy),
		CostCentre: req.CostCentre, SourceReference: req.SourceReference,
		Lines: lines, State: string(req.State),
		Justification: req.Justification,
		RaisedAt:      stamp(req.RaisedAt), RaisedBy: req.RaisedBy,
	})
}

// Requisition reads one request with its approval chain.
func (r ProcurementRepo) Requisition(ctx context.Context,
	scope authctx.TenantScope, id string) (domain.Requisition, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Requisition{}, err
	}
	requisitionID, err := uuid.Parse(id)
	if err != nil {
		return domain.Requisition{}, notFound()
	}

	row, err := r.queries(ctx).GetRequisition(ctx, sqlcgen.GetRequisitionParams{
		TenantID: tenantID, RequisitionID: requisitionID,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Requisition{}, notFound()
	}
	if err != nil {
		return domain.Requisition{}, err
	}

	out, err := requisitionFrom(row)
	if err != nil {
		return domain.Requisition{}, err
	}
	// The chain is a separate table, joined on read. It has to travel with the
	// requisition because the next decision's level is derived from it.
	steps, err := r.Approvals(ctx, scope, id)
	if err != nil {
		return domain.Requisition{}, err
	}
	out.Approvals = steps
	return out, nil
}

// UpdateRequisitionState advances a request.
func (r ProcurementRepo) UpdateRequisitionState(ctx context.Context,
	scope authctx.TenantScope, req domain.Requisition,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	requisitionID, err := uuid.Parse(req.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateRequisitionState(ctx,
		sqlcgen.UpdateRequisitionStateParams{
			TenantID: tenantID, RequisitionID: requisitionID,
			State: string(req.State), ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// Requisitions lists the work, soonest needed first.
func (r ProcurementRepo) Requisitions(ctx context.Context,
	scope authctx.TenantScope, state string, limit int32) (
	[]domain.Requisition, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListRequisitions(ctx,
		sqlcgen.ListRequisitionsParams{
			TenantID: tenantID, State: state, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Requisition, 0, len(rows))
	for _, row := range rows {
		req, err := requisitionFrom(row)
		if err != nil {
			return nil, err
		}
		out = append(out, req)
	}
	return out, nil
}

func requisitionFrom(row sqlcgen.MaterialsRequisition) (
	domain.Requisition, error) {

	out := domain.Requisition{
		ID: row.RequisitionID.String(), TenantID: row.TenantID.String(),
		Number: row.Number, FacilityID: uuidString(row.FacilityID),
		Source: domain.RequisitionSource(row.Source),
		NeedBy: timeOf(row.NeedBy), CostCentre: row.CostCentre,
		SourceReference: row.SourceReference,
		State:           domain.RequisitionState(row.State),
		Justification:   row.Justification,
		RaisedAt:        timeOf(row.RaisedAt), RaisedBy: row.RaisedBy,
		Version: row.Version,
	}
	if err := decode(row.Lines, &out.Lines); err != nil {
		return domain.Requisition{}, err
	}
	return out, nil
}

// AppendApproval writes one step of the chain (SRS-MAT-002).
//
// Insert only. There is no update path to this table anywhere in the adapter:
// an approval that can be edited afterwards is indistinguishable from one that
// was never given, and the unique (requisition, level) in the schema stops two
// callers claiming the same step.
func (r ProcurementRepo) AppendApproval(ctx context.Context,
	scope authctx.TenantScope, requisitionID string,
	step domain.ApprovalStep) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	stepID, err := uuid.Parse(step.ID)
	if err != nil {
		return notFound()
	}
	reqID, err := uuid.Parse(requisitionID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertApprovalStep(ctx,
		sqlcgen.InsertApprovalStepParams{
			ApprovalStepID: stepID, TenantID: tenantID, RequisitionID: reqID,
			Level: int32(step.Level), Role: step.Role,
			Decision: string(step.Decision), Decider: step.Decider,
			Note: step.Note, DecidedAt: stamp(step.At),
		})
}

// Approvals reads the chain in order.
func (r ProcurementRepo) Approvals(ctx context.Context,
	scope authctx.TenantScope, requisitionID string) (
	[]domain.ApprovalStep, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	reqID, err := uuid.Parse(requisitionID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListApprovalSteps(ctx,
		sqlcgen.ListApprovalStepsParams{
			TenantID: tenantID, RequisitionID: reqID,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.ApprovalStep, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.ApprovalStep{
			ID: row.ApprovalStepID.String(), Level: int(row.Level),
			Role: row.Role, Decision: domain.ApprovalDecision(row.Decision),
			Decider: row.Decider, Note: row.Note, At: timeOf(row.DecidedAt),
		})
	}
	return out, nil
}

// InsertApprovalRule adds a routing rule.
func (r ProcurementRepo) InsertApprovalRule(ctx context.Context,
	scope authctx.TenantScope, rule domain.ApprovalRule, by string,
	at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	ruleID, err := uuid.Parse(rule.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertApprovalRule(ctx,
		sqlcgen.InsertApprovalRuleParams{
			ApprovalRuleID: ruleID, TenantID: tenantID,
			MinimumValue: rule.MinimumValue, Currency: rule.Currency,
			Category: rule.Category, FacilityID: optionalUUID(rule.FacilityID),
			Roles: rule.Roles, CreatedAt: stamp(at), CreatedBy: by,
		})
}

// ApprovalRules reads the routing configuration, cheapest threshold first.
func (r ProcurementRepo) ApprovalRules(ctx context.Context,
	scope authctx.TenantScope) ([]domain.ApprovalRule, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListApprovalRules(ctx, tenantID)
	if err != nil {
		return nil, err
	}
	out := make([]domain.ApprovalRule, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.ApprovalRule{
			ID: row.ApprovalRuleID.String(), TenantID: row.TenantID.String(),
			MinimumValue: row.MinimumValue, Currency: row.Currency,
			Category: row.Category, FacilityID: uuidString(row.FacilityID),
			Roles: row.Roles,
		})
	}
	return out, nil
}

// DeleteApprovalRule removes a routing rule.
func (r ProcurementRepo) DeleteApprovalRule(ctx context.Context,
	scope authctx.TenantScope, id string) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	ruleID, err := uuid.Parse(id)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).DeleteApprovalRule(ctx,
		sqlcgen.DeleteApprovalRuleParams{
			TenantID: tenantID, ApprovalRuleID: ruleID,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return notFound()
	}
	return nil
}

// InsertRFQ opens a quotation round.
func (r ProcurementRepo) InsertRFQ(ctx context.Context,
	scope authctx.TenantScope, rfq domain.RFQ) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	rfqID, err := uuid.Parse(rfq.ID)
	if err != nil {
		return notFound()
	}
	suppliers := make([]uuid.UUID, 0, len(rfq.SupplierIDs))
	for _, id := range rfq.SupplierIDs {
		parsed, err := uuid.Parse(id)
		if err != nil {
			return notFound()
		}
		suppliers = append(suppliers, parsed)
	}
	lines, err := encode(rfq.Lines)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertRFQ(ctx, sqlcgen.InsertRFQParams{
		RfqID: rfqID, TenantID: tenantID, Number: rfq.Number,
		RequisitionID: optionalUUID(rfq.RequisitionID),
		SupplierIds:   suppliers, Lines: lines,
		ClosesAt: stamp(rfq.ClosesAt),
		IssuedAt: stamp(rfq.IssuedAt), IssuedBy: rfq.IssuedBy,
	})
}

// RFQ reads one quotation round.
func (r ProcurementRepo) RFQ(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.RFQ, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.RFQ{}, err
	}
	rfqID, err := uuid.Parse(id)
	if err != nil {
		return domain.RFQ{}, notFound()
	}

	row, err := r.queries(ctx).GetRFQ(ctx, sqlcgen.GetRFQParams{
		TenantID: tenantID, RfqID: rfqID,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.RFQ{}, notFound()
	}
	if err != nil {
		return domain.RFQ{}, err
	}
	return rfqFrom(row)
}

// RFQs lists the rounds, most recent first.
func (r ProcurementRepo) RFQs(ctx context.Context, scope authctx.TenantScope,
	limit int32) ([]domain.RFQ, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListRFQs(ctx, sqlcgen.ListRFQsParams{
		TenantID: tenantID, RowLimit: limit,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.RFQ, 0, len(rows))
	for _, row := range rows {
		rfq, err := rfqFrom(row)
		if err != nil {
			return nil, err
		}
		out = append(out, rfq)
	}
	return out, nil
}

func rfqFrom(row sqlcgen.MaterialsRfq) (domain.RFQ, error) {
	out := domain.RFQ{
		ID: row.RfqID.String(), TenantID: row.TenantID.String(),
		Number: row.Number, RequisitionID: uuidString(row.RequisitionID),
		ClosesAt: timeOf(row.ClosesAt),
		IssuedAt: timeOf(row.IssuedAt), IssuedBy: row.IssuedBy,
		Version: row.Version,
	}
	for _, id := range row.SupplierIds {
		out.SupplierIDs = append(out.SupplierIDs, id.String())
	}
	if err := decode(row.Lines, &out.Lines); err != nil {
		return domain.RFQ{}, err
	}
	return out, nil
}

// InsertBid records a supplier's quote.
func (r ProcurementRepo) InsertBid(ctx context.Context,
	scope authctx.TenantScope, b domain.Bid) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	bidID, err := uuid.Parse(b.ID)
	if err != nil {
		return notFound()
	}
	rfqID, err := uuid.Parse(b.RFQID)
	if err != nil {
		return notFound()
	}
	supplierID, err := uuid.Parse(b.SupplierID)
	if err != nil {
		return notFound()
	}
	lines, err := encode(b.Lines)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertBid(ctx, sqlcgen.InsertBidParams{
		BidID: bidID, TenantID: tenantID, RfqID: rfqID, SupplierID: supplierID,
		Lines: lines, LeadTimeDays: int32(b.LeadTimeDays),
		WarrantyMonths:   int32(b.WarrantyMonths),
		PaymentTermsDays: int32(b.PaymentTermsDays),
		FreightMinor:     b.FreightMinor, TaxMinor: b.TaxMinor,
		Currency: b.Currency, Notes: b.Notes,
		ReceivedAt: stamp(b.ReceivedAt), RecordedBy: b.RecordedBy,
	})
}

// BidsForRFQ reads every quote in one round.
func (r ProcurementRepo) BidsForRFQ(ctx context.Context,
	scope authctx.TenantScope, rfqID string) ([]domain.Bid, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(rfqID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListBidsForRFQ(ctx,
		sqlcgen.ListBidsForRFQParams{TenantID: tenantID, RfqID: id})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Bid, 0, len(rows))
	for _, row := range rows {
		bid := domain.Bid{
			ID: row.BidID.String(), TenantID: row.TenantID.String(),
			RFQID: row.RfqID.String(), SupplierID: row.SupplierID.String(),
			LeadTimeDays:     int(row.LeadTimeDays),
			WarrantyMonths:   int(row.WarrantyMonths),
			PaymentTermsDays: int(row.PaymentTermsDays),
			FreightMinor:     row.FreightMinor, TaxMinor: row.TaxMinor,
			Currency: row.Currency, Notes: row.Notes,
			ReceivedAt: timeOf(row.ReceivedAt), RecordedBy: row.RecordedBy,
		}
		if err := decode(row.Lines, &bid.Lines); err != nil {
			return nil, err
		}
		out = append(out, bid)
	}
	return out, nil
}

// InsertPurchaseOrder writes a revision.
//
// Insert, never update-in-place for the lines: an amendment is a new row, and
// the partial unique index on the chain holds "at most one live revision".
func (r ProcurementRepo) InsertPurchaseOrder(ctx context.Context,
	scope authctx.TenantScope, o domain.PurchaseOrder) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	orderID, err := uuid.Parse(o.ID)
	if err != nil {
		return notFound()
	}
	chainID, err := uuid.Parse(o.ChainID)
	if err != nil {
		return notFound()
	}
	supplierID, err := uuid.Parse(o.SupplierID)
	if err != nil {
		return notFound()
	}
	lines, err := encode(o.Lines)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertPurchaseOrder(ctx,
		sqlcgen.InsertPurchaseOrderParams{
			PurchaseOrderID: orderID, TenantID: tenantID,
			Number: o.Number, FacilityID: optionalUUID(o.FacilityID),
			SupplierID:    supplierID,
			RequisitionID: optionalUUID(o.RequisitionID),
			BidID:         optionalUUID(o.BidID),
			Revision:      int32(o.Revision), ChainID: chainID,
			Supersedes:      optionalUUID(o.Supersedes),
			AmendmentReason: o.AmendmentReason,
			Lines:           lines, State: string(o.State),
			Currency: o.Currency, PaymentTermsDays: int32(o.PaymentTermsDays),
			DeliveryTerms:         o.DeliveryTerms,
			ToleranceOverPercent:  int32(o.ToleranceOverPercent),
			ToleranceShortPercent: int32(o.ToleranceShortPercent),
			IssuedAt:              stamp(o.IssuedAt), IssuedBy: o.IssuedBy,
			CreatedAt: stamp(o.CreatedAt), CreatedBy: o.CreatedBy,
		})
}

// PurchaseOrder reads one revision.
func (r ProcurementRepo) PurchaseOrder(ctx context.Context,
	scope authctx.TenantScope, id string) (domain.PurchaseOrder, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.PurchaseOrder{}, err
	}
	orderID, err := uuid.Parse(id)
	if err != nil {
		return domain.PurchaseOrder{}, notFound()
	}

	row, err := r.queries(ctx).GetPurchaseOrder(ctx,
		sqlcgen.GetPurchaseOrderParams{
			TenantID: tenantID, PurchaseOrderID: orderID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.PurchaseOrder{}, notFound()
	}
	if err != nil {
		return domain.PurchaseOrder{}, err
	}
	return orderFrom(row)
}

// UpdatePurchaseOrderState advances one revision.
func (r ProcurementRepo) UpdatePurchaseOrderState(ctx context.Context,
	scope authctx.TenantScope, o domain.PurchaseOrder,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	orderID, err := uuid.Parse(o.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdatePurchaseOrderState(ctx,
		sqlcgen.UpdatePurchaseOrderStateParams{
			TenantID: tenantID, PurchaseOrderID: orderID,
			State: string(o.State), IssuedAt: stamp(o.IssuedAt),
			IssuedBy: o.IssuedBy, ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	return nil
}

// Revisions reads every version of one order (SRS-MAT-004).
func (r ProcurementRepo) Revisions(ctx context.Context,
	scope authctx.TenantScope, chainID string) (
	[]domain.PurchaseOrder, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	chain, err := uuid.Parse(chainID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListPurchaseOrderRevisions(ctx,
		sqlcgen.ListPurchaseOrderRevisionsParams{
			TenantID: tenantID, ChainID: chain,
		})
	if err != nil {
		return nil, err
	}
	return ordersFrom(rows)
}

// PurchaseOrders lists orders, most recent first.
func (r ProcurementRepo) PurchaseOrders(ctx context.Context,
	scope authctx.TenantScope, supplierID, state string, limit int32) (
	[]domain.PurchaseOrder, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := r.queries(ctx).ListPurchaseOrders(ctx,
		sqlcgen.ListPurchaseOrdersParams{
			TenantID: tenantID, SupplierID: supplierID, State: state,
			RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return ordersFrom(rows)
}

// OrdersIssuedBetween is what a fill rate is computed over.
func (r ProcurementRepo) OrdersIssuedBetween(ctx context.Context,
	scope authctx.TenantScope, supplierID string, from, to time.Time) (
	[]domain.PurchaseOrder, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	supplier, err := uuid.Parse(supplierID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListPurchaseOrdersIssuedBetween(ctx,
		sqlcgen.ListPurchaseOrdersIssuedBetweenParams{
			TenantID: tenantID, SupplierID: supplier,
			PeriodStart: stamp(from), PeriodEnd: stamp(to),
		})
	if err != nil {
		return nil, err
	}
	return ordersFrom(rows)
}

func ordersFrom(rows []sqlcgen.MaterialsPurchaseOrder) (
	[]domain.PurchaseOrder, error) {

	out := make([]domain.PurchaseOrder, 0, len(rows))
	for _, row := range rows {
		order, err := orderFrom(row)
		if err != nil {
			return nil, err
		}
		out = append(out, order)
	}
	return out, nil
}

func orderFrom(row sqlcgen.MaterialsPurchaseOrder) (
	domain.PurchaseOrder, error) {

	out := domain.PurchaseOrder{
		ID: row.PurchaseOrderID.String(), TenantID: row.TenantID.String(),
		Number: row.Number, FacilityID: uuidString(row.FacilityID),
		SupplierID:    row.SupplierID.String(),
		RequisitionID: uuidString(row.RequisitionID),
		BidID:         uuidString(row.BidID),
		Revision:      int(row.Revision), ChainID: row.ChainID.String(),
		Supersedes:            uuidString(row.Supersedes),
		AmendmentReason:       row.AmendmentReason,
		State:                 domain.POState(row.State),
		Currency:              row.Currency,
		PaymentTermsDays:      int(row.PaymentTermsDays),
		DeliveryTerms:         row.DeliveryTerms,
		ToleranceOverPercent:  int(row.ToleranceOverPercent),
		ToleranceShortPercent: int(row.ToleranceShortPercent),
		IssuedAt:              timeOf(row.IssuedAt), IssuedBy: row.IssuedBy,
		CreatedAt: timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
	if err := decode(row.Lines, &out.Lines); err != nil {
		return domain.PurchaseOrder{}, err
	}
	return out, nil
}

// InsertReceipt records a delivery.
func (r ProcurementRepo) InsertReceipt(ctx context.Context,
	scope authctx.TenantScope, rec domain.Receipt) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	receiptID, err := uuid.Parse(rec.ID)
	if err != nil {
		return notFound()
	}
	orderID, err := uuid.Parse(rec.PurchaseOrderID)
	if err != nil {
		return notFound()
	}
	supplierID, err := uuid.Parse(rec.SupplierID)
	if err != nil {
		return notFound()
	}
	lines, err := encode(rec.Lines)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertReceipt(ctx, sqlcgen.InsertReceiptParams{
		ReceiptID: receiptID, TenantID: tenantID, Number: rec.Number,
		PurchaseOrderID: orderID, PoRevision: int32(rec.PORevision),
		SupplierID: supplierID, LocationID: rec.LocationID,
		DeliveryNote: rec.DeliveryNote, InvoiceRef: rec.InvoiceRef,
		Lines:      lines,
		ReceivedAt: stamp(rec.ReceivedAt), ReceivedBy: rec.ReceivedBy,
	})
}

// Receipt reads one delivery.
func (r ProcurementRepo) Receipt(ctx context.Context,
	scope authctx.TenantScope, id string) (domain.Receipt, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Receipt{}, err
	}
	receiptID, err := uuid.Parse(id)
	if err != nil {
		return domain.Receipt{}, notFound()
	}

	row, err := r.queries(ctx).GetReceipt(ctx, sqlcgen.GetReceiptParams{
		TenantID: tenantID, ReceiptID: receiptID,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Receipt{}, notFound()
	}
	if err != nil {
		return domain.Receipt{}, err
	}
	return receiptFrom(row)
}

// ReceiptsForOrder is what a three-way match totals.
func (r ProcurementRepo) ReceiptsForOrder(ctx context.Context,
	scope authctx.TenantScope, orderID string) ([]domain.Receipt, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(orderID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListReceiptsForOrder(ctx,
		sqlcgen.ListReceiptsForOrderParams{
			TenantID: tenantID, PurchaseOrderID: id,
		})
	if err != nil {
		return nil, err
	}
	return receiptsFrom(rows)
}

// ReceiptsForSupplier is what a fill rate is computed from.
func (r ProcurementRepo) ReceiptsForSupplier(ctx context.Context,
	scope authctx.TenantScope, supplierID string, from, to time.Time,
	limit int32) ([]domain.Receipt, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	supplier, err := uuid.Parse(supplierID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListReceiptsForSupplier(ctx,
		sqlcgen.ListReceiptsForSupplierParams{
			TenantID: tenantID, SupplierID: supplier,
			PeriodStart: stamp(from), PeriodEnd: stamp(to), RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return receiptsFrom(rows)
}

func receiptsFrom(rows []sqlcgen.MaterialsReceipt) ([]domain.Receipt, error) {
	out := make([]domain.Receipt, 0, len(rows))
	for _, row := range rows {
		receipt, err := receiptFrom(row)
		if err != nil {
			return nil, err
		}
		out = append(out, receipt)
	}
	return out, nil
}

func receiptFrom(row sqlcgen.MaterialsReceipt) (domain.Receipt, error) {
	out := domain.Receipt{
		ID: row.ReceiptID.String(), TenantID: row.TenantID.String(),
		Number: row.Number, PurchaseOrderID: row.PurchaseOrderID.String(),
		PORevision: int(row.PoRevision), SupplierID: row.SupplierID.String(),
		LocationID: row.LocationID, DeliveryNote: row.DeliveryNote,
		InvoiceRef: row.InvoiceRef,
		ReceivedAt: timeOf(row.ReceivedAt), ReceivedBy: row.ReceivedBy,
		Version: row.Version,
	}
	if err := decode(row.Lines, &out.Lines); err != nil {
		return domain.Receipt{}, err
	}
	return out, nil
}

// InsertInvoice records a supplier's bill.
func (r ProcurementRepo) InsertInvoice(ctx context.Context,
	scope authctx.TenantScope, i domain.Invoice) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	invoiceID, err := uuid.Parse(i.ID)
	if err != nil {
		return notFound()
	}
	supplierID, err := uuid.Parse(i.SupplierID)
	if err != nil {
		return notFound()
	}
	lines, err := encode(i.Lines)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertSupplierInvoice(ctx,
		sqlcgen.InsertSupplierInvoiceParams{
			InvoiceID: invoiceID, TenantID: tenantID, Number: i.Number,
			SupplierID:      supplierID,
			PurchaseOrderID: optionalUUID(i.PurchaseOrderID),
			Lines:           lines, Currency: i.Currency,
			ReceivedAt: stamp(i.ReceivedAt), RecordedBy: i.RecordedBy,
		})
}

// Invoice reads one bill.
func (r ProcurementRepo) Invoice(ctx context.Context,
	scope authctx.TenantScope, id string) (domain.Invoice, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Invoice{}, err
	}
	invoiceID, err := uuid.Parse(id)
	if err != nil {
		return domain.Invoice{}, notFound()
	}

	row, err := r.queries(ctx).GetSupplierInvoice(ctx,
		sqlcgen.GetSupplierInvoiceParams{TenantID: tenantID, InvoiceID: invoiceID})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Invoice{}, notFound()
	}
	if err != nil {
		return domain.Invoice{}, err
	}
	return invoiceFrom(row)
}

// InvoicesForOrder reads every bill against one order.
func (r ProcurementRepo) InvoicesForOrder(ctx context.Context,
	scope authctx.TenantScope, orderID string) ([]domain.Invoice, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	if _, err := uuid.Parse(orderID); err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListSupplierInvoicesForOrder(ctx,
		sqlcgen.ListSupplierInvoicesForOrderParams{
			TenantID: tenantID, PurchaseOrderID: optionalUUID(orderID),
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Invoice, 0, len(rows))
	for _, row := range rows {
		invoice, err := invoiceFrom(row)
		if err != nil {
			return nil, err
		}
		out = append(out, invoice)
	}
	return out, nil
}

func invoiceFrom(row sqlcgen.MaterialsInvoice) (domain.Invoice, error) {
	out := domain.Invoice{
		ID: row.InvoiceID.String(), TenantID: row.TenantID.String(),
		Number: row.Number, SupplierID: row.SupplierID.String(),
		PurchaseOrderID: uuidString(row.PurchaseOrderID),
		Currency:        row.Currency,
		ReceivedAt:      timeOf(row.ReceivedAt), RecordedBy: row.RecordedBy,
	}
	if err := decode(row.Lines, &out.Lines); err != nil {
		return domain.Invoice{}, err
	}
	return out, nil
}
