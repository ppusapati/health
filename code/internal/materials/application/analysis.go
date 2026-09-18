package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/materials/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// ledgerEpoch is early enough to precede any movement and late enough to be a
// real timestamp. Replaying "everything before the period" needs a lower bound
// the database can compare against.
var ledgerEpoch = time.Date(1970, 1, 1, 0, 0, 0, 0, time.UTC)

// Alerts derives what a storekeeper should look at (SRS-MAT-012).
//
// Derived on read, never stored. A stored alert is one that stays raised after
// the stock arrives, and a storekeeper who has learned to ignore stale alerts
// ignores the real one too. A level nobody configured raises nothing: not
// every store carries every item, and an alert on all of them is an alert on
// none.
func (s *Service) Alerts(ctx context.Context, locationID string,
	limit int32) ([]domain.Alert, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	levels, err := s.master.StockLevels(
		ctx, scope, locationID, clampPageSize(limit))
	if err != nil {
		return nil, err
	}
	balances, err := s.ledger.BalancesAtLocation(
		ctx, scope, locationID, "", ledgerPageSize)
	if err != nil {
		return nil, err
	}

	lots := map[string]domain.Lot{}
	for _, balance := range balances {
		if _, seen := lots[balance.LotID]; seen {
			continue
		}
		lot, err := s.master.Lot(ctx, scope, balance.LotID)
		if err != nil {
			return nil, err
		}
		lots[lot.ID] = lot
	}

	return domain.StockAlerts(
		levels, balances, lots, s.config.ExpiryHorizon, now), nil
}

// SuggestedOrder is a reorder a storekeeper can review before it becomes a
// requisition (SRS-MAT-012).
//
// The acceptance is "suggested order is reviewable before PO", and this is the
// shape that makes it true: the system computes and proposes, a person raises.
// A system that raised the requisition itself would buy what its own
// arithmetic decided, and the arithmetic is only as good as the min-max
// somebody set last year.
type SuggestedOrder struct {
	LocationID string
	Lines      []SuggestedLine
}

// SuggestedLine is one item a top-up would order.
type SuggestedLine struct {
	ItemID    string
	ItemCode  string
	Available int
	Minimum   int
	Quantity  int
	Stockout  bool
}

// SuggestOrder proposes a replenishment (SRS-MAT-012).
func (s *Service) SuggestOrder(ctx context.Context, locationID string) (
	SuggestedOrder, error) {

	alerts, err := s.Alerts(ctx, locationID, MaxPageSize)
	if err != nil {
		return SuggestedOrder{}, err
	}
	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return SuggestedOrder{}, err
	}

	out := SuggestedOrder{LocationID: locationID}
	for _, alert := range alerts {
		if alert.Kind != domain.AlertBelowMinimum &&
			alert.Kind != domain.AlertStockout {
			continue
		}
		if alert.SuggestedOrder <= 0 {
			continue
		}
		item, err := s.master.Item(ctx, scope, alert.ItemID)
		if err != nil {
			return SuggestedOrder{}, err
		}
		out.Lines = append(out.Lines, SuggestedLine{
			ItemID: alert.ItemID, ItemCode: item.Code,
			Available: alert.Available, Minimum: alert.Minimum,
			Quantity: alert.SuggestedOrder,
			Stockout: alert.Kind == domain.AlertStockout,
		})
	}
	return out, nil
}

// RecordInvoiceInput records a supplier's bill (SRS-MAT-014).
type RecordInvoiceInput struct {
	Number          string
	SupplierID      string
	PurchaseOrderID string
	Lines           []domain.InvoiceLine
	Currency        string
}

// RecordInvoice records a supplier's bill (SRS-MAT-014).
func (s *Service) RecordInvoice(ctx context.Context, in RecordInvoiceInput) (
	domain.Invoice, error) {

	session, scope, err := s.authorize(ctx, PermMatch)
	if err != nil {
		return domain.Invoice{}, err
	}
	now := s.clock.Now()

	if len(in.Lines) == 0 {
		return domain.Invoice{}, rpcerr.Invalid("MAT_INVALID",
			"an invoice bills for something")
	}

	var out domain.Invoice
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		supplier, err := s.master.Supplier(ctx, scope, in.SupplierID)
		if err != nil {
			return err
		}
		currency := in.Currency
		if currency == "" {
			currency = supplier.Currency
		}

		invoice := domain.Invoice{
			ID: s.ids.NewID(), TenantID: session.TenantID,
			Number: in.Number, SupplierID: supplier.ID,
			PurchaseOrderID: in.PurchaseOrderID,
			Lines:           in.Lines, Currency: currency,
			ReceivedAt: now.UTC(), RecordedBy: session.SubjectID,
		}
		if err := s.procurement.InsertInvoice(ctx, scope, invoice); err != nil {
			return err
		}
		out = invoice

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermMatch,
			ResourceType: "materials_invoice", ResourceID: invoice.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "invoice " + invoice.Number + " from " + supplier.Code,
		}, now)
	})
	if err != nil {
		return domain.Invoice{}, err
	}
	return out, nil
}

// Match compares order, receipts and invoice (SRS-MAT-014).
//
// Surfaces mismatches; it does not resolve them. The resolution is a human
// negotiation — a credit note, a short shipment agreed by phone — and a system
// that silently picked one of the three numbers would pay the wrong one.
//
// A failing match publishes an event, because the party who needs to know is
// accounts payable and they are not looking at this screen.
func (s *Service) Match(ctx context.Context, invoiceID string) (
	domain.MatchResult, error) {

	session, scope, err := s.authorize(ctx, PermMatch)
	if err != nil {
		return domain.MatchResult{}, err
	}
	now := s.clock.Now()

	var out domain.MatchResult
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		invoice, err := s.procurement.Invoice(ctx, scope, invoiceID)
		if err != nil {
			return err
		}
		if invoice.PurchaseOrderID == "" {
			// An invoice against no order cannot be three-way matched at all,
			// which is a fact worth saying rather than a match that passes
			// because there was nothing to compare against.
			return rpcerr.FailedPrecondition("MAT_NO_ORDER",
				"this invoice names no purchase order, so there is nothing "+
					"to match it against")
		}

		order, err := s.procurement.PurchaseOrder(
			ctx, scope, invoice.PurchaseOrderID)
		if err != nil {
			return err
		}
		receipts, err := s.procurement.ReceiptsForOrder(ctx, scope, order.ID)
		if err != nil {
			return err
		}
		out = domain.ThreeWayMatch(order, receipts, invoice)

		if !out.Matched {
			mismatched := 0
			for _, line := range out.Lines {
				if line.Status != domain.MatchOK {
					mismatched++
				}
			}
			if err := s.appendEvent(ctx, session, EventMatchFailed,
				"materials_invoice", invoice.ID, map[string]any{
					"purchase_order_id": order.ID,
					"supplier_id":       invoice.SupplierID,
					"mismatched_lines":  mismatched,
				}, now); err != nil {
				return err
			}
		}

		verdict := "matched"
		if !out.Matched {
			verdict = "mismatched"
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermMatch,
			ResourceType: "materials_invoice", ResourceID: invoice.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "three-way match: " + verdict,
		}, now)
	})
	if err != nil {
		return domain.MatchResult{}, err
	}
	return out, nil
}

// Metrics derives the inventory KPIs (SRS-MAT-015).
//
// Computed from the ledger every time. A stored KPI is by construction not
// reproducible from the data the requirement says it must come from: it is
// whatever the job that wrote it computed, from rows that have since changed.
func (s *Service) Metrics(ctx context.Context, itemID, locationID string,
	from, to time.Time) (domain.Metrics, error) {

	_, scope, err := s.authorize(ctx, PermAnalyse)
	if err != nil {
		return domain.Metrics{}, err
	}
	if from.IsZero() || to.IsZero() || !from.Before(to) {
		return domain.Metrics{}, rpcerr.Invalid("MAT_INVALID",
			"a KPI covers a period: give a start before an end")
	}

	// Read from before any hospital ran this system, because the opening
	// balance is derived by replaying everything before the period. A window
	// that started at `from` would report an opening balance of nothing and a
	// turn rate to match. Go's zero time is not usable here: it renders as a
	// NULL timestamp, and a NULL comparison excludes every row.
	movements, err := s.ledger.MovementsForItem(
		ctx, scope, itemID, ledgerEpoch, to, ledgerPageSize)
	if err != nil {
		return domain.Metrics{}, err
	}

	lots := map[string]domain.Lot{}
	for _, movement := range movements {
		if _, seen := lots[movement.LotID]; seen {
			continue
		}
		lot, err := s.master.Lot(ctx, scope, movement.LotID)
		if err != nil {
			return domain.Metrics{}, err
		}
		lots[lot.ID] = lot
	}

	return domain.ComputeMetrics(domain.MetricsInput{
		ItemID: itemID, LocationID: locationID, From: from, To: to,
		Movements: movements, Lots: lots,
		ExpiryHorizon: s.config.ExpiryHorizon,
	}), nil
}

// FillRate derives a supplier's fill rate (SRS-MAT-015).
func (s *Service) FillRate(ctx context.Context, supplierID string,
	from, to time.Time) (domain.SupplierFillRate, error) {

	_, scope, err := s.authorize(ctx, PermAnalyse)
	if err != nil {
		return domain.SupplierFillRate{}, err
	}
	if from.IsZero() || to.IsZero() || !from.Before(to) {
		return domain.SupplierFillRate{}, rpcerr.Invalid("MAT_INVALID",
			"a KPI covers a period: give a start before an end")
	}

	orders, err := s.procurement.OrdersIssuedBetween(
		ctx, scope, supplierID, from, to)
	if err != nil {
		return domain.SupplierFillRate{}, err
	}
	// Receipts are read over a wider window than the orders: a delivery
	// against an order issued on the last day of the period arrives after it,
	// and counting it as never delivered would make every recent order look
	// unfilled.
	receipts, err := s.procurement.ReceiptsForSupplier(
		ctx, scope, supplierID, from, to.AddDate(0, 3, 0), ledgerPageSize)
	if err != nil {
		return domain.SupplierFillRate{}, err
	}

	return domain.ComputeFillRate(supplierID, from, to, orders, receipts), nil
}

// Liabilities is what the hospital owes one supplier for consumed consignment
// stock (SRS-MAT-016).
func (s *Service) Liabilities(ctx context.Context, supplierID string,
	from, to time.Time, limit int32) ([]domain.LiabilityEvent, error) {

	_, scope, err := s.authorize(ctx, PermAnalyse)
	if err != nil {
		return nil, err
	}
	if from.IsZero() || to.IsZero() || !from.Before(to) {
		return nil, rpcerr.Invalid("MAT_INVALID",
			"a liability report covers a period: give a start before an end")
	}
	return s.control.Liabilities(
		ctx, scope, supplierID, from, to, clampPageSize(limit))
}
