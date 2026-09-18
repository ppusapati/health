package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/materials/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Receipt is what a delivery produced.
type Receipt struct {
	Receipt domain.Receipt
	// Short names the lines that arrived beyond the order's short tolerance.
	// Returned rather than refused: the goods are on the dock whatever the
	// count says, and refusing would leave them unrecorded.
	Short []string
	// Quarantined names the lines that landed in quarantine because the item
	// is inspected on receipt, so a storekeeper is not left wondering why the
	// shelf figure did not move (SRS-MAT-006).
	Quarantined []string
}

// ReceiveGoods records a delivery against an order (SRS-MAT-005).
//
// One transaction: the receipt row, the lots and the ledger movements land
// together. A receipt recorded without its movements is a delivery the store
// has on paper and not on the shelf, and the balance would be wrong in the
// direction that causes a stockout nobody expected.
func (s *Service) ReceiveGoods(ctx context.Context,
	in domain.NewReceiptInput, orderID string) (Receipt, error) {

	session, scope, err := s.authorize(ctx, PermReceive)
	if err != nil {
		return Receipt{}, err
	}
	now := s.clock.Now()

	var out Receipt
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		order, err := s.procurement.PurchaseOrder(ctx, scope, orderID)
		if err != nil {
			return err
		}

		items := map[string]domain.Item{}
		for _, line := range in.Lines {
			item, err := s.master.Item(ctx, scope, line.ItemID)
			if err != nil {
				return err
			}
			items[line.ItemID] = item
		}

		receipt, short, err := domain.NewReceipt(s.ids.NewID(),
			session.TenantID, in, order, items, session.SubjectID, now)
		if err != nil {
			return materialsError(err)
		}
		if err := s.procurement.InsertReceipt(ctx, scope, receipt); err != nil {
			return err
		}

		var movements []domain.Movement
		var quarantined []string
		for _, line := range receipt.Lines {
			item := items[line.ItemID]

			lot, err := s.resolveLot(ctx, scope, item, line, now)
			if err != nil {
				return err
			}

			// The one place that decides where received stock lands. An item
			// configured for inspection lands in quarantine, and SRS-MAT-006's
			// "unaccepted stock cannot become available" is then a property of
			// where it went rather than a check somebody has to remember.
			status := domain.LandingStatus(item)
			if status == domain.StatusQuarantine {
				quarantined = append(quarantined, item.Code)
			}

			movement, err := domain.NewMovement(s.ids.NewID(),
				session.TenantID, domain.NewMovementInput{
					ItemID: item.ID, LotID: lot.ID,
					From: domain.Outside,
					To: domain.Bucket{
						LocationID: receipt.LocationID, Status: status,
					},
					Quantity: line.QuantityReceived,
					Kind:     domain.MovementReceipt, Reference: receipt.ID,
				}, session.SubjectID, now)
			if err != nil {
				return materialsError(err)
			}
			movements = append(movements, movement)
		}

		if err := s.ledger.AppendMovements(ctx, scope, movements); err != nil {
			return err
		}

		// The order advances to received or partly received, read from the
		// ledger rather than from this delivery alone: a second receipt
		// against the same order is normal and this is where it is noticed.
		if err := s.advanceOrder(ctx, scope, order, now); err != nil {
			return err
		}

		out = Receipt{Receipt: receipt, Short: short, Quarantined: quarantined}

		if err := s.appendEvent(ctx, session, EventGoodsReceived,
			"materials_receipt", receipt.ID, map[string]any{
				"purchase_order_id": order.ID,
				"po_revision":       receipt.PORevision,
				"location_id":       receipt.LocationID,
				"lines":             len(receipt.Lines),
				"short":             short,
			}, now); err != nil {
			return err
		}

		reason := "received against " + order.Number
		if len(short) > 0 {
			reason += "; short: " + join(short)
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermReceive,
			ResourceType: "materials_receipt", ResourceID: receipt.ID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return Receipt{}, err
	}
	return out, nil
}

// advanceOrder moves an order to partly-received or received.
//
// Computed from every receipt against the order, not from the one just
// recorded: a delivery in two lorries is one order fully received, and
// counting only the second would leave it open for ever.
func (s *Service) advanceOrder(ctx context.Context, scope authctx.TenantScope,
	order domain.PurchaseOrder, now time.Time) error {

	receipts, err := s.procurement.ReceiptsForOrder(ctx, scope, order.ID)
	if err != nil {
		return err
	}
	received := map[string]int{}
	for _, receipt := range receipts {
		for _, line := range receipt.Lines {
			received[line.ItemID] += line.QuantityReceived
		}
	}

	complete := true
	any := false
	for _, line := range order.Lines {
		got := received[line.ItemID]
		if got > 0 {
			any = true
		}
		if got < line.StockQuantity() {
			complete = false
		}
	}

	next := order
	switch {
	case complete:
		next.State = domain.POReceived
	case any:
		next.State = domain.POPartial
	default:
		return nil
	}
	if next.State == order.State {
		return nil
	}
	if err := s.procurement.UpdatePurchaseOrderState(
		ctx, scope, next, order.Version); err != nil {
		return materialsError(err)
	}
	return nil
}

// InspectInput accepts or rejects quarantined stock.
type InspectInput struct {
	LotID      string
	LocationID string
	Quantity   int
	Accept     bool
	// Reason is required on a rejection: stock sent back to a supplier or
	// destroyed is a claim somebody has to defend.
	Reason string
}

// Inspect accepts or rejects quarantined stock (SRS-MAT-006).
//
// Its own permission, because it is the step that makes uninspected stock
// usable. Accepting moves it from quarantine to available; rejecting moves it
// to rejected, which is counted and never issuable. Neither destroys the
// quantity: it is somewhere, and the ledger says where.
func (s *Service) Inspect(ctx context.Context, in InspectInput) (
	domain.Movement, error) {

	session, scope, err := s.authorize(ctx, PermInspect)
	if err != nil {
		return domain.Movement{}, err
	}
	now := s.clock.Now()

	if !in.Accept && in.Reason == "" {
		return domain.Movement{}, rpcerr.Invalid("MAT_INVALID",
			"say why this stock is being rejected")
	}

	var out domain.Movement
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		lot, err := s.master.Lot(ctx, scope, in.LotID)
		if err != nil {
			return err
		}

		// Only what is actually in quarantine can be inspected out of it.
		// Without this check an inspector could "accept" stock that was
		// already available and mint it a second time.
		balances, err := s.ledger.BalancesForLot(ctx, scope, lot.ID)
		if err != nil {
			return err
		}
		held := 0
		for _, balance := range balances {
			if balance.Bucket.LocationID == in.LocationID &&
				balance.Bucket.Status == domain.StatusQuarantine {
				held += balance.Quantity
			}
		}
		if held < in.Quantity {
			return rpcerr.FailedPrecondition("MAT_NOT_IN_QUARANTINE",
				"only "+itoa(held)+" of this lot is in quarantine at "+
					in.LocationID)
		}

		status := domain.StatusAvailable
		kind := domain.MovementAccept
		if !in.Accept {
			status, kind = domain.StatusRejected, domain.MovementReject
		}

		movement, err := domain.NewMovement(s.ids.NewID(), session.TenantID,
			domain.NewMovementInput{
				ItemID: lot.ItemID, LotID: lot.ID,
				From: domain.Bucket{
					LocationID: in.LocationID, Status: domain.StatusQuarantine,
				},
				To:       domain.Bucket{LocationID: in.LocationID, Status: status},
				Quantity: in.Quantity, Kind: kind, Reason: in.Reason,
			}, session.SubjectID, now)
		if err != nil {
			return materialsError(err)
		}
		if err := s.ledger.AppendMovement(ctx, scope, movement); err != nil {
			return err
		}
		out = movement

		eventType := EventStockAccepted
		if !in.Accept {
			eventType = EventStockRejected
		}
		if err := s.appendEvent(ctx, session, eventType,
			"materials_lot", lot.ID, map[string]any{
				"item_id":     lot.ItemID,
				"location_id": in.LocationID,
				"quantity":    in.Quantity,
			}, now); err != nil {
			return err
		}

		verdict := "accepted"
		if !in.Accept {
			verdict = "rejected: " + in.Reason
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermInspect,
			ResourceType: "materials_lot", ResourceID: lot.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  itoa(in.Quantity) + " " + verdict,
		}, now)
	})
	if err != nil {
		return domain.Movement{}, err
	}
	return out, nil
}

// Receipt reads one delivery.
func (s *Service) ReceiptByID(ctx context.Context, receiptID string) (
	domain.Receipt, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Receipt{}, err
	}
	return s.procurement.Receipt(ctx, scope, receiptID)
}

// ReceiptsForOrder reads every delivery against one order.
func (s *Service) ReceiptsForOrder(ctx context.Context, orderID string) (
	[]domain.Receipt, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.procurement.ReceiptsForOrder(ctx, scope, orderID)
}
