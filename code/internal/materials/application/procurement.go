package application

import (
	"context"

	"github.com/ppusapati/health/code/internal/materials/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// RaiseRequisition raises a request to buy (SRS-MAT-001).
func (s *Service) RaiseRequisition(ctx context.Context,
	in domain.NewRequisitionInput) (domain.Requisition, error) {

	session, scope, err := s.authorize(ctx, PermRaise)
	if err != nil {
		return domain.Requisition{}, err
	}
	now := s.clock.Now()

	var out domain.Requisition
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		// Every line has to name an item the master knows, because a
		// requisition for a code nobody recognises becomes a purchase order
		// for a code nobody recognises.
		for i, line := range in.Lines {
			item, err := s.master.Item(ctx, scope, line.ItemID)
			if err != nil {
				return err
			}
			if !item.Active {
				return rpcerr.FailedPrecondition("MAT_ITEM_INACTIVE",
					item.Code+" has been withdrawn from the catalogue")
			}
			in.Lines[i].ItemCode, in.Lines[i].UOM = item.Code, item.UOM
		}

		requisition, err := domain.NewRequisition(
			s.ids.NewID(), session.TenantID, in, session.SubjectID, now)
		if err != nil {
			return materialsError(err)
		}
		if err := s.procurement.InsertRequisition(
			ctx, scope, requisition); err != nil {
			return err
		}
		out = requisition

		if err := s.appendEvent(ctx, session, EventRequisitionRaised,
			"materials_requisition", requisition.ID, map[string]any{
				"source":      string(requisition.Source),
				"cost_centre": requisition.CostCentre,
				"lines":       len(requisition.Lines),
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermRaise,
			ResourceType: "materials_requisition", ResourceID: requisition.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: "raised against " + requisition.CostCentre + " (" +
				itoa(len(requisition.Lines)) + " line(s))",
		}, now)
	})
	if err != nil {
		return domain.Requisition{}, err
	}
	return out, nil
}

// RouteFor is the approval chain a requisition would need (SRS-MAT-002).
//
// Readable before submission, so a requester can see who has to sign rather
// than discovering it when the request sits unmoved for a week.
func (s *Service) RouteFor(ctx context.Context, requisitionID string) (
	[]string, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	requisition, err := s.procurement.Requisition(ctx, scope, requisitionID)
	if err != nil {
		return nil, err
	}
	return s.routeFor(ctx, scope, requisition)
}

func (s *Service) routeFor(ctx context.Context, scope authctx.TenantScope,
	requisition domain.Requisition) ([]string, error) {

	rules, err := s.procurement.ApprovalRules(ctx, scope)
	if err != nil {
		return nil, err
	}
	value, err := requisition.EstimatedValue()
	if err != nil {
		return nil, materialsError(err)
	}

	items := map[string]domain.Item{}
	for _, line := range requisition.Lines {
		item, err := s.master.Item(ctx, scope, line.ItemID)
		if err != nil {
			return nil, err
		}
		items[line.ItemID] = item
	}
	return domain.Route(rules, value, requisition.Categories(items),
		requisition.FacilityID), nil
}

// SubmitRequisition sends a request for approval (SRS-MAT-002).
func (s *Service) SubmitRequisition(ctx context.Context, requisitionID string) (
	domain.Requisition, []string, error) {

	session, scope, err := s.authorize(ctx, PermRaise)
	if err != nil {
		return domain.Requisition{}, nil, err
	}
	now := s.clock.Now()

	var out domain.Requisition
	var route []string
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		requisition, err := s.procurement.Requisition(ctx, scope, requisitionID)
		if err != nil {
			return err
		}
		route, err = s.routeFor(ctx, scope, requisition)
		if err != nil {
			return err
		}
		if err := requisition.Submit(route, now); err != nil {
			return materialsError(err)
		}
		if err := s.procurement.UpdateRequisitionState(
			ctx, scope, requisition, requisition.Version); err != nil {
			return materialsError(err)
		}
		out = requisition

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermRaise,
			ResourceType: "materials_requisition", ResourceID: requisition.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "submitted; route: " + join(route),
		}, now)
	})
	if err != nil {
		return domain.Requisition{}, nil, err
	}
	return out, route, nil
}

// DecideInput records one approval or rejection.
type DecideInput struct {
	RequisitionID string
	Decision      domain.ApprovalDecision
	// Role is the step being taken. Checked against the route's next step, so
	// an approver holding the permission still cannot sign out of turn or
	// sign somebody else's step.
	Role string
	Note string
}

// DecideRequisition records one step of the approval chain (SRS-MAT-002).
//
// Holding mat.requisition.approve is necessary and not sufficient: the route
// names which role is required at which step, the caller must claim that role,
// and the domain refuses a requester approving their own request.
func (s *Service) DecideRequisition(ctx context.Context, in DecideInput) (
	domain.Requisition, domain.ApprovalStep, error) {

	session, scope, err := s.authorize(ctx, PermApprove)
	if err != nil {
		return domain.Requisition{}, domain.ApprovalStep{}, err
	}
	now := s.clock.Now()

	if !session.HasRole(in.Role) {
		// The role is not a free-text claim. Without this, anybody with the
		// approve permission could sign as the medical director by typing it.
		return domain.Requisition{}, domain.ApprovalStep{},
			rpcerr.PermissionDenied("MAT_FORBIDDEN",
				"this caller does not hold the role "+in.Role)
	}

	var requisition domain.Requisition
	var step domain.ApprovalStep
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		loaded, err := s.procurement.Requisition(ctx, scope, in.RequisitionID)
		if err != nil {
			return err
		}
		route, err := s.routeFor(ctx, scope, loaded)
		if err != nil {
			return err
		}

		step, err = loaded.Decide(s.ids.NewID(), route, in.Decision,
			session.SubjectID, in.Role, in.Note, now)
		if err != nil {
			return materialsError(err)
		}
		if err := s.procurement.AppendApproval(
			ctx, scope, loaded.ID, step); err != nil {
			return err
		}
		if err := s.procurement.UpdateRequisitionState(
			ctx, scope, loaded, loaded.Version); err != nil {
			return materialsError(err)
		}
		requisition = loaded

		switch loaded.State {
		case domain.RequisitionApproved:
			if err := s.appendEvent(ctx, session, EventRequisitionApproved,
				"materials_requisition", loaded.ID, map[string]any{
					"cost_centre": loaded.CostCentre,
					"approvals":   len(loaded.Approvals),
				}, now); err != nil {
				return err
			}
		case domain.RequisitionRejected:
			if err := s.appendEvent(ctx, session, EventRequisitionRejected,
				"materials_requisition", loaded.ID, map[string]any{
					"cost_centre": loaded.CostCentre,
					"level":       step.Level,
				}, now); err != nil {
				return err
			}
		}

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermApprove,
			ResourceType: "materials_requisition", ResourceID: loaded.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: "step " + itoa(step.Level) + " as " + step.Role + ": " +
				string(in.Decision),
		}, now)
	})
	if err != nil {
		return domain.Requisition{}, domain.ApprovalStep{}, err
	}
	return requisition, step, nil
}

// Requisition reads one request with its chain.
func (s *Service) Requisition(ctx context.Context, requisitionID string) (
	domain.Requisition, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Requisition{}, err
	}
	return s.procurement.Requisition(ctx, scope, requisitionID)
}

// Requisitions lists the work, soonest needed first.
func (s *Service) Requisitions(ctx context.Context, state string,
	limit int32) ([]domain.Requisition, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.procurement.Requisitions(ctx, scope, state, clampPageSize(limit))
}

// OpenRFQ sends a quotation round to approved suppliers (SRS-MAT-003).
func (s *Service) OpenRFQ(ctx context.Context, in domain.NewRFQInput) (
	domain.RFQ, error) {

	session, scope, err := s.authorize(ctx, PermPurchase)
	if err != nil {
		return domain.RFQ{}, err
	}
	now := s.clock.Now()

	var out domain.RFQ
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		suppliers := map[string]domain.Supplier{}
		for _, id := range in.SupplierIDs {
			supplier, err := s.master.Supplier(ctx, scope, id)
			if err != nil {
				return err
			}
			suppliers[id] = supplier
		}

		if in.RequisitionID != "" {
			requisition, err := s.procurement.Requisition(
				ctx, scope, in.RequisitionID)
			if err != nil {
				return err
			}
			if requisition.State != domain.RequisitionApproved {
				// Quoting an unapproved request commits the hospital's time
				// and the suppliers' to something nobody has agreed to buy.
				return rpcerr.FailedPrecondition("MAT_NOT_APPROVED",
					"this requisition is "+string(requisition.State))
			}
			if len(in.Lines) == 0 {
				in.Lines = requisition.Lines
			}
		}

		rfq, err := domain.NewRFQ(s.ids.NewID(), session.TenantID, in,
			suppliers, session.SubjectID, now)
		if err != nil {
			return materialsError(err)
		}
		if err := s.procurement.InsertRFQ(ctx, scope, rfq); err != nil {
			return err
		}
		out = rfq

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPurchase,
			ResourceType: "materials_rfq", ResourceID: rfq.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "quoted to " + itoa(len(rfq.SupplierIDs)) + " supplier(s)",
		}, now)
	})
	if err != nil {
		return domain.RFQ{}, err
	}
	return out, nil
}

// RecordBidInput records a supplier's response.
type RecordBidInput struct {
	RFQID            string
	SupplierID       string
	Lines            []domain.BidLine
	LeadTimeDays     int
	WarrantyMonths   int
	PaymentTermsDays int
	FreightMinor     int64
	TaxMinor         int64
	Currency         string
	Notes            string
}

// RecordBid records a quote (SRS-MAT-003).
func (s *Service) RecordBid(ctx context.Context, in RecordBidInput) (
	domain.Bid, error) {

	session, scope, err := s.authorize(ctx, PermPurchase)
	if err != nil {
		return domain.Bid{}, err
	}
	now := s.clock.Now()

	var out domain.Bid
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		rfq, err := s.procurement.RFQ(ctx, scope, in.RFQID)
		if err != nil {
			return err
		}
		invited := false
		for _, id := range rfq.SupplierIDs {
			if id == in.SupplierID {
				invited = true
				break
			}
		}
		if !invited {
			// A quote from somebody who was not asked is not a quote in this
			// round, and counting it would make "we went to three suppliers"
			// untrue in the one direction an audit checks.
			return rpcerr.FailedPrecondition("MAT_NOT_INVITED",
				"this supplier was not asked to quote")
		}
		supplier, err := s.master.Supplier(ctx, scope, in.SupplierID)
		if err != nil {
			return err
		}

		currency := in.Currency
		if currency == "" {
			currency = supplier.Currency
		}
		terms := in.PaymentTermsDays
		if terms == 0 {
			terms = supplier.PaymentTermsDays
		}

		bid := domain.Bid{
			ID: s.ids.NewID(), TenantID: session.TenantID,
			RFQID: rfq.ID, SupplierID: supplier.ID, Lines: in.Lines,
			LeadTimeDays: in.LeadTimeDays, WarrantyMonths: in.WarrantyMonths,
			PaymentTermsDays: terms,
			FreightMinor:     in.FreightMinor, TaxMinor: in.TaxMinor,
			Currency: currency, Notes: in.Notes,
			ReceivedAt: now.UTC(), RecordedBy: session.SubjectID,
		}
		if len(bid.Lines) == 0 {
			return rpcerr.Invalid("MAT_INVALID", "a quote prices something")
		}
		if err := s.procurement.InsertBid(ctx, scope, bid); err != nil {
			return err
		}
		out = bid

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPurchase,
			ResourceType: "materials_bid", ResourceID: bid.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "quote from " + supplier.Code,
		}, now)
	})
	if err != nil {
		return domain.Bid{}, err
	}
	return out, nil
}

// CompareBids normalises the quotes in one round (SRS-MAT-003).
//
// Returns the comparison, not a winner. Which quote to accept weighs lead time
// against price against a relationship, and that is a buyer's judgement
// recorded against their name when they raise the order.
func (s *Service) CompareBids(ctx context.Context, rfqID string) (
	[]domain.Comparison, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	bids, err := s.procurement.BidsForRFQ(ctx, scope, rfqID)
	if err != nil {
		return nil, err
	}
	return domain.Compare(bids), nil
}

// RFQ reads one quotation round.
func (s *Service) RFQ(ctx context.Context, rfqID string) (domain.RFQ, error) {
	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.RFQ{}, err
	}
	return s.procurement.RFQ(ctx, scope, rfqID)
}

// RFQs lists the rounds.
func (s *Service) RFQs(ctx context.Context, limit int32) ([]domain.RFQ, error) {
	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.procurement.RFQs(ctx, scope, clampPageSize(limit))
}

// PlaceOrder raises a purchase order (SRS-MAT-004).
func (s *Service) PlaceOrder(ctx context.Context, in domain.NewPOInput) (
	domain.PurchaseOrder, error) {

	session, scope, err := s.authorize(ctx, PermPurchase)
	if err != nil {
		return domain.PurchaseOrder{}, err
	}
	now := s.clock.Now()

	if in.ToleranceOverPercent == 0 {
		in.ToleranceOverPercent = s.config.DefaultToleranceOverPercent
	}
	if in.ToleranceShortPercent == 0 {
		in.ToleranceShortPercent = s.config.DefaultToleranceShortPercent
	}

	var out domain.PurchaseOrder
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		supplier, err := s.master.Supplier(ctx, scope, in.SupplierID)
		if err != nil {
			return err
		}
		for i, line := range in.Lines {
			item, err := s.master.Item(ctx, scope, line.ItemID)
			if err != nil {
				return err
			}
			in.Lines[i].ItemCode = item.Code
		}
		if in.RequisitionID != "" {
			requisition, err := s.procurement.Requisition(
				ctx, scope, in.RequisitionID)
			if err != nil {
				return err
			}
			if requisition.State != domain.RequisitionApproved {
				// The whole of SRS-MAT-002 lands here: money is committed
				// only against a request that went through its route.
				return rpcerr.FailedPrecondition("MAT_NOT_APPROVED",
					"this requisition is "+string(requisition.State))
			}
		}

		order, err := domain.NewPurchaseOrder(s.ids.NewID(), session.TenantID,
			in, supplier, session.SubjectID, now)
		if err != nil {
			return materialsError(err)
		}
		if err := s.procurement.InsertPurchaseOrder(ctx, scope, order); err != nil {
			return err
		}
		out = order

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPurchase,
			ResourceType: "materials_purchase_order", ResourceID: order.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "raised with " + supplier.Code,
		}, now)
	})
	if err != nil {
		return domain.PurchaseOrder{}, err
	}
	return out, nil
}

// IssueOrder sends an order to the supplier (SRS-MAT-004).
func (s *Service) IssueOrder(ctx context.Context, orderID string) (
	domain.PurchaseOrder, error) {

	session, scope, err := s.authorize(ctx, PermPurchase)
	if err != nil {
		return domain.PurchaseOrder{}, err
	}
	now := s.clock.Now()

	var out domain.PurchaseOrder
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		order, err := s.procurement.PurchaseOrder(ctx, scope, orderID)
		if err != nil {
			return err
		}
		if err := order.Issue(session.SubjectID, now); err != nil {
			return materialsError(err)
		}
		if err := s.procurement.UpdatePurchaseOrderState(
			ctx, scope, order, order.Version); err != nil {
			return materialsError(err)
		}
		out = order

		total, err := order.Total()
		if err != nil {
			return materialsError(err)
		}
		if err := s.appendEvent(ctx, session, EventOrderIssued,
			"materials_purchase_order", order.ID, map[string]any{
				"supplier_id": order.SupplierID,
				"revision":    order.Revision,
				"lines":       len(order.Lines),
				"currency":    total.Currency,
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPurchase,
			ResourceType: "materials_purchase_order", ResourceID: order.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "issued, revision " + itoa(order.Revision),
		}, now)
	})
	if err != nil {
		return domain.PurchaseOrder{}, err
	}
	return out, nil
}

// AmendOrderInput produces the next revision.
type AmendOrderInput struct {
	OrderID string
	Lines   []domain.POLine
	Reason  string
}

// AmendOrder produces the next revision of an order (SRS-MAT-004).
//
// The earlier revision is closed in the same transaction as the new one is
// written, because the database holds "at most one live revision per chain":
// two live revisions would mean a supplier delivering against either, with
// nothing to say which was right.
func (s *Service) AmendOrder(ctx context.Context, in AmendOrderInput) (
	domain.PurchaseOrder, error) {

	session, scope, err := s.authorize(ctx, PermPurchase)
	if err != nil {
		return domain.PurchaseOrder{}, err
	}
	now := s.clock.Now()

	var out domain.PurchaseOrder
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		order, err := s.procurement.PurchaseOrder(ctx, scope, in.OrderID)
		if err != nil {
			return err
		}
		for i, line := range in.Lines {
			item, err := s.master.Item(ctx, scope, line.ItemID)
			if err != nil {
				return err
			}
			in.Lines[i].ItemCode = item.Code
		}

		amended, err := order.Amend(s.ids.NewID(), in.Lines, in.Reason,
			session.SubjectID, now)
		if err != nil {
			return materialsError(err)
		}

		superseded := order
		superseded.State = domain.POClosed
		if err := s.procurement.UpdatePurchaseOrderState(
			ctx, scope, superseded, order.Version); err != nil {
			return materialsError(err)
		}
		if err := s.procurement.InsertPurchaseOrder(
			ctx, scope, amended); err != nil {
			return err
		}
		out = amended

		if err := s.appendEvent(ctx, session, EventOrderAmended,
			"materials_purchase_order", amended.ID, map[string]any{
				"supersedes": order.ID,
				"revision":   amended.Revision,
				"reason":     amended.AmendmentReason,
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermPurchase,
			ResourceType: "materials_purchase_order", ResourceID: amended.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: "revision " + itoa(amended.Revision) + " of " +
				order.ID + ": " + in.Reason,
		}, now)
	})
	if err != nil {
		return domain.PurchaseOrder{}, err
	}
	return out, nil
}

// PurchaseOrder reads one revision.
func (s *Service) PurchaseOrder(ctx context.Context, orderID string) (
	domain.PurchaseOrder, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.PurchaseOrder{}, err
	}
	return s.procurement.PurchaseOrder(ctx, scope, orderID)
}

// OrderRevisions is every version of one order (SRS-MAT-004).
func (s *Service) OrderRevisions(ctx context.Context, orderID string) (
	[]domain.PurchaseOrder, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	order, err := s.procurement.PurchaseOrder(ctx, scope, orderID)
	if err != nil {
		return nil, err
	}
	return s.procurement.Revisions(ctx, scope, order.ChainID)
}

// PurchaseOrders lists orders.
func (s *Service) PurchaseOrders(ctx context.Context, supplierID, state string,
	limit int32) ([]domain.PurchaseOrder, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.procurement.PurchaseOrders(
		ctx, scope, supplierID, state, clampPageSize(limit))
}
