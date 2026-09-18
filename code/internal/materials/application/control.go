package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/materials/domain"
	"github.com/ppusapati/health/code/internal/materials/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// DispatchTransfer sends stock to another store (SRS-MAT-010).
//
// The transfer row and its out-movements land in one transaction, into an
// in-transit bucket at the destination. Nothing is ever nowhere: the source
// has given it up, the destination has not got it, and the total inside the
// hospital has not changed.
func (s *Service) DispatchTransfer(ctx context.Context,
	in domain.NewTransferInput) (domain.Transfer, error) {

	session, scope, err := s.authorize(ctx, PermTransfer)
	if err != nil {
		return domain.Transfer{}, err
	}
	now := s.clock.Now()

	var out domain.Transfer
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		transfer, err := domain.NewTransfer(
			s.ids.NewID(), session.TenantID, in, session.SubjectID, now)
		if err != nil {
			return materialsError(err)
		}

		var movements []domain.Movement
		for _, line := range transfer.Lines {
			lot, err := s.master.Lot(ctx, scope, line.LotID)
			if err != nil {
				return err
			}
			if !lot.Issuable(now) {
				// Moving blocked stock between stores is how a recall loses
				// track of it: the ward it arrives at was never told.
				reason := "expired"
				if lot.Blocked {
					reason = "blocked: " + lot.BlockedReason
				}
				return rpcerr.FailedPrecondition("MAT_LOT_NOT_ISSUABLE",
					"this lot is "+reason)
			}

			movement, err := domain.NewMovement(s.ids.NewID(),
				session.TenantID, domain.NewMovementInput{
					ItemID: line.ItemID, LotID: line.LotID,
					From: domain.Bucket{
						LocationID: transfer.FromLocation,
						Status:     domain.StatusAvailable,
					},
					To: domain.Bucket{
						LocationID: transfer.ToLocation,
						Status:     domain.StatusInTransit,
					},
					Quantity:  line.Quantity,
					Kind:      domain.MovementTransferOut,
					Reference: transfer.ID, Reason: transfer.Reason,
				}, session.SubjectID, now)
			if err != nil {
				return materialsError(err)
			}
			movements = append(movements, movement)
		}

		if err := s.control.InsertTransfer(ctx, scope, transfer); err != nil {
			return err
		}
		if err := s.ledger.AppendMovements(ctx, scope, movements); err != nil {
			return err
		}
		out = transfer

		if err := s.appendEvent(ctx, session, EventTransferDispatched,
			"materials_transfer", transfer.ID, map[string]any{
				"from_location": transfer.FromLocation,
				"to_location":   transfer.ToLocation,
				"lines":         len(transfer.Lines),
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermTransfer,
			ResourceType: "materials_transfer", ResourceID: transfer.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: transfer.FromLocation + " to " + transfer.ToLocation +
				" (" + itoa(len(transfer.Lines)) + " line(s))",
		}, now)
	})
	if err != nil {
		return domain.Transfer{}, err
	}
	return out, nil
}

// ReceiveTransferInput closes a transfer at the destination.
type ReceiveTransferInput struct {
	TransferID string
	// Counted is what arrived, keyed by "itemID/lotID". A line left out means
	// it all arrived: a count that has to be retyped line by line is a count
	// nobody does, and assuming zero would write off a full pallet.
	Counted map[string]int
}

// TransferReceipt is what a transfer's arrival produced.
type TransferReceipt struct {
	Transfer domain.Transfer
	// Short names what did not arrive. Recorded rather than refused: the
	// stock is on the destination's counter whatever the count says, and the
	// difference is what an investigation starts from. The missing quantity
	// stays in the in-transit bucket rather than vanishing from both stores.
	Short []string
}

// ReceiveTransfer closes a transfer at the destination (SRS-MAT-010).
func (s *Service) ReceiveTransfer(ctx context.Context,
	in ReceiveTransferInput) (TransferReceipt, error) {

	session, scope, err := s.authorize(ctx, PermTransfer)
	if err != nil {
		return TransferReceipt{}, err
	}
	now := s.clock.Now()

	var out TransferReceipt
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		transfer, err := s.control.Transfer(ctx, scope, in.TransferID)
		if err != nil {
			return err
		}
		short, err := transfer.Receive(in.Counted, session.SubjectID, now)
		if err != nil {
			return materialsError(err)
		}

		var movements []domain.Movement
		for _, line := range transfer.Lines {
			if line.QuantityReceived <= 0 {
				// Nothing arrived on this line. The dispatched quantity stays
				// in transit, which is where an investigation finds it.
				continue
			}
			movement, err := domain.NewMovement(s.ids.NewID(),
				session.TenantID, domain.NewMovementInput{
					ItemID: line.ItemID, LotID: line.LotID,
					From: domain.Bucket{
						LocationID: transfer.ToLocation,
						Status:     domain.StatusInTransit,
					},
					To: domain.Bucket{
						LocationID: transfer.ToLocation,
						Status:     domain.StatusAvailable,
					},
					Quantity: line.QuantityReceived,
					Kind:     domain.MovementTransferIn, Reference: transfer.ID,
				}, session.SubjectID, now)
			if err != nil {
				return materialsError(err)
			}
			movements = append(movements, movement)
		}

		if err := s.control.UpdateTransfer(
			ctx, scope, transfer, transfer.Version); err != nil {
			return materialsError(err)
		}
		if len(movements) > 0 {
			if err := s.ledger.AppendMovements(
				ctx, scope, movements); err != nil {
				return err
			}
		}
		out = TransferReceipt{Transfer: transfer, Short: short}

		if err := s.appendEvent(ctx, session, EventTransferReceived,
			"materials_transfer", transfer.ID, map[string]any{
				"to_location": transfer.ToLocation,
				"short":       short,
			}, now); err != nil {
			return err
		}

		reason := "received at " + transfer.ToLocation
		if len(short) > 0 {
			reason += "; short: " + join(short)
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermTransfer,
			ResourceType: "materials_transfer", ResourceID: transfer.ID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return TransferReceipt{}, err
	}
	return out, nil
}

// TransfersInTransit is what is still on a trolley somewhere (SRS-MAT-010).
func (s *Service) TransfersInTransit(ctx context.Context, toLocation string,
	limit int32) ([]domain.Transfer, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.control.TransfersInTransit(
		ctx, scope, toLocation, clampPageSize(limit))
}

// OpenCount opens a stocktake (SRS-MAT-011).
//
// The expected quantities are frozen here, from the ledger as it stands when
// the counter starts. Recomputing them at approval would compare the shelf
// against a balance that moved while they walked it, and the variance would be
// somebody else's issue.
func (s *Service) OpenCount(ctx context.Context, number, locationID string,
	cycle bool, itemIDs []string) (domain.Count, error) {

	session, scope, err := s.authorize(ctx, PermCount)
	if err != nil {
		return domain.Count{}, err
	}
	now := s.clock.Now()

	var out domain.Count
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		balances, err := s.ledger.BalancesAtLocation(
			ctx, scope, locationID, "", ledgerPageSize)
		if err != nil {
			return err
		}

		wanted := map[string]bool{}
		for _, id := range itemIDs {
			wanted[id] = true
		}

		var lines []domain.CountLine
		for _, balance := range balances {
			if len(wanted) > 0 && !wanted[balance.ItemID] {
				continue
			}
			lines = append(lines, domain.CountLine{
				ItemID: balance.ItemID, LotID: balance.LotID,
				Expected: balance.Quantity,
			})
		}

		count, err := domain.NewCount(s.ids.NewID(), session.TenantID,
			domain.NewCountInput{
				Number: number, LocationID: locationID, Cycle: cycle,
				Lines: lines,
			}, session.SubjectID, now)
		if err != nil {
			return materialsError(err)
		}
		if err := s.control.InsertCount(ctx, scope, count); err != nil {
			return err
		}
		out = count

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermCount,
			ResourceType: "materials_count", ResourceID: count.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: "opened at " + locationID + " over " +
				itoa(len(lines)) + " line(s)",
		}, now)
	})
	if err != nil {
		return domain.Count{}, err
	}
	return out, nil
}

// RecordCount enters what was on the shelf (SRS-MAT-011).
func (s *Service) RecordCount(ctx context.Context, countID string,
	lines []domain.CountLine) (domain.Count, error) {

	session, scope, err := s.authorize(ctx, PermCount)
	if err != nil {
		return domain.Count{}, err
	}
	now := s.clock.Now()

	var out domain.Count
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		count, err := s.control.Count(ctx, scope, countID)
		if err != nil {
			return err
		}

		// The expected figure comes from the count as opened, not from the
		// caller: a client that sent its own expectation could make any
		// variance disappear by sending the number it counted.
		expected := map[string]int{}
		for _, line := range count.Lines {
			expected[line.ItemID+"/"+line.LotID] = line.Expected
		}
		for i := range lines {
			lines[i].Expected = expected[lines[i].ItemID+"/"+lines[i].LotID]
		}

		if err := count.Record(lines, session.SubjectID, now); err != nil {
			return materialsError(err)
		}
		if err := s.control.UpdateCount(
			ctx, scope, count, count.Version); err != nil {
			return materialsError(err)
		}
		out = count

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermCount,
			ResourceType: "materials_count", ResourceID: count.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  itoa(len(count.Variances())) + " variance(s) recorded",
		}, now)
	})
	if err != nil {
		return domain.Count{}, err
	}
	return out, nil
}

// ApproveCount authorises the adjustments a count would post (SRS-MAT-011).
//
// Its own permission, and the domain refuses an approver who is the counter.
// The adjustments are posted here, in the same transaction as the approval:
// an approved count whose adjustments failed to post would leave a ledger
// everybody believes was corrected.
func (s *Service) ApproveCount(ctx context.Context, countID, note string) (
	domain.Count, []domain.Movement, error) {

	session, scope, err := s.authorize(ctx, PermApproveCount)
	if err != nil {
		return domain.Count{}, nil, err
	}
	now := s.clock.Now()

	var out domain.Count
	var posted []domain.Movement
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		count, err := s.control.Count(ctx, scope, countID)
		if err != nil {
			return err
		}
		if err := count.Approve(session.SubjectID, note, now); err != nil {
			return materialsError(err)
		}

		for _, line := range count.Variances() {
			variance := line.Variance()
			bucket := domain.Bucket{
				LocationID: count.LocationID, Status: domain.StatusAvailable,
			}

			in := domain.NewMovementInput{
				ItemID: line.ItemID, LotID: line.LotID,
				Quantity: variance, Kind: domain.MovementAdjustment,
				Reference: count.ID, Reason: line.Reason,
			}
			if variance > 0 {
				// The shelf had more than the ledger said: stock arrives
				// from outside, because there is no other bucket it can
				// honestly be said to have come from.
				in.From, in.To = domain.Outside, bucket
			} else {
				in.From, in.To = bucket, domain.Outside
				in.Quantity = -variance
			}

			movement, err := domain.NewMovement(s.ids.NewID(),
				session.TenantID, in, session.SubjectID, now)
			if err != nil {
				return materialsError(err)
			}
			posted = append(posted, movement)
		}

		if err := s.control.UpdateCount(
			ctx, scope, count, count.Version); err != nil {
			return materialsError(err)
		}
		if len(posted) > 0 {
			if err := s.ledger.AppendMovements(ctx, scope, posted); err != nil {
				return err
			}
		}
		out = count

		if err := s.appendEvent(ctx, session, EventCountApproved,
			"materials_count", count.ID, map[string]any{
				"location_id": count.LocationID,
				"variances":   len(posted),
				"cycle":       count.Cycle,
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermApproveCount,
			ResourceType: "materials_count", ResourceID: count.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: itoa(len(posted)) + " adjustment(s) posted, counted by " +
				count.CountedBy,
		}, now)
	})
	if err != nil {
		return domain.Count{}, nil, err
	}
	return out, posted, nil
}

// RejectCount ends a count without posting anything (SRS-MAT-011).
func (s *Service) RejectCount(ctx context.Context, countID, note string) (
	domain.Count, error) {

	session, scope, err := s.authorize(ctx, PermApproveCount)
	if err != nil {
		return domain.Count{}, err
	}
	now := s.clock.Now()

	var out domain.Count
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		count, err := s.control.Count(ctx, scope, countID)
		if err != nil {
			return err
		}
		if err := count.Reject(session.SubjectID, note, now); err != nil {
			return materialsError(err)
		}
		if err := s.control.UpdateCount(
			ctx, scope, count, count.Version); err != nil {
			return materialsError(err)
		}
		out = count

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermApproveCount,
			ResourceType: "materials_count", ResourceID: count.ID,
			Outcome: audit.OutcomeSuccess, Reason: "rejected: " + note,
		}, now)
	})
	if err != nil {
		return domain.Count{}, err
	}
	return out, nil
}

// Count reads one stocktake.
func (s *Service) Count(ctx context.Context, countID string) (
	domain.Count, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Count{}, err
	}
	return s.control.Count(ctx, scope, countID)
}

// Counts lists stocktakes.
func (s *Service) Counts(ctx context.Context, state string, limit int32) (
	[]domain.Count, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.control.Counts(ctx, scope, state, clampPageSize(limit))
}

// BlockLot stops a lot being issued and works out what it reached
// (SRS-MAT-013).
//
// Its own permission, because blocking tells every ward to stop using what
// they have. Raises a durable acknowledged notice rather than a log line: the
// wards holding the stock have to be told, and a screen nobody opened is not
// telling them.
func (s *Service) BlockLot(ctx context.Context, lotID, reason string) (
	domain.Lot, domain.RecallList, error) {

	session, scope, err := s.authorize(ctx, PermBlock)
	if err != nil {
		return domain.Lot{}, domain.RecallList{}, err
	}
	now := s.clock.Now()

	var lot domain.Lot
	var recall domain.RecallList
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		loaded, err := s.master.Lot(ctx, scope, lotID)
		if err != nil {
			return err
		}
		if err := loaded.Block(reason, session.SubjectID, now); err != nil {
			return materialsError(err)
		}
		if err := s.master.UpdateLotBlock(
			ctx, scope, loaded, loaded.Version); err != nil {
			return materialsError(err)
		}
		lot = loaded

		recall, err = s.buildRecall(ctx, scope, loaded)
		if err != nil {
			return err
		}

		if err := s.escalateRecall(ctx, scope, recall, now); err != nil {
			return err
		}
		if err := s.appendEvent(ctx, session, EventLotBlocked,
			"materials_lot", loaded.ID, map[string]any{
				"item_id":  loaded.ItemID,
				"lot_code": loaded.Code,
				"patients": len(recall.Patients),
				"holdings": len(recall.Holdings),
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermBlock,
			ResourceType: "materials_lot", ResourceID: loaded.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: "blocked: " + reason + "; reaches " +
				itoa(len(recall.Patients)) + " patient(s)",
		}, now)
	})
	if err != nil {
		return domain.Lot{}, domain.RecallList{}, err
	}
	return lot, recall, nil
}

// ReleaseLot lifts a block (SRS-MAT-013).
func (s *Service) ReleaseLot(ctx context.Context, lotID, note string) (
	domain.Lot, error) {

	session, scope, err := s.authorize(ctx, PermBlock)
	if err != nil {
		return domain.Lot{}, err
	}
	now := s.clock.Now()

	if note == "" {
		// Putting recalled stock back on the shelf is the more dangerous
		// direction of the two, so it is the one that needs a reason.
		return domain.Lot{}, rpcerr.Invalid("MAT_INVALID",
			"say why this lot is being released back into stock")
	}

	var out domain.Lot
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		lot, err := s.master.Lot(ctx, scope, lotID)
		if err != nil {
			return err
		}
		if err := lot.Release(session.SubjectID); err != nil {
			return materialsError(err)
		}
		if err := s.master.UpdateLotBlock(
			ctx, scope, lot, lot.Version); err != nil {
			return materialsError(err)
		}
		out = lot

		if err := s.appendEvent(ctx, session, EventLotReleased,
			"materials_lot", lot.ID, map[string]any{
				"item_id": lot.ItemID, "lot_code": lot.Code,
			}, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermBlock,
			ResourceType: "materials_lot", ResourceID: lot.ID,
			Outcome: audit.OutcomeSuccess, Reason: "block lifted: " + note,
		}, now)
	})
	if err != nil {
		return domain.Lot{}, err
	}
	return out, nil
}

// RecallFor is what a blocked lot reaches, without blocking anything
// (SRS-MAT-013).
func (s *Service) RecallFor(ctx context.Context, lotID string) (
	domain.RecallList, error) {

	session, scope, err := s.authorize(ctx, PermBlock)
	if err != nil {
		return domain.RecallList{}, err
	}
	now := s.clock.Now()

	lot, err := s.master.Lot(ctx, scope, lotID)
	if err != nil {
		return domain.RecallList{}, err
	}
	recall, err := s.buildRecall(ctx, scope, lot)
	if err != nil {
		return domain.RecallList{}, err
	}

	// Audited with the count, because a recall list and a fishing expedition
	// look identical in the query log: both ask which patients received
	// something.
	if err := s.uow.WithinTx(ctx, func(ctx context.Context) error {
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermBlock,
			ResourceType: "materials_lot", ResourceID: lot.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: "recall list read, " + itoa(len(recall.Patients)) +
				" patient(s)",
		}, now)
	}); err != nil {
		return domain.RecallList{}, err
	}
	return recall, nil
}

func (s *Service) buildRecall(ctx context.Context, scope authctx.TenantScope,
	lot domain.Lot) (domain.RecallList, error) {

	movements, err := s.ledger.MovementsForLot(
		ctx, scope, lot.ID, ledgerPageSize)
	if err != nil {
		return domain.RecallList{}, err
	}
	balances, err := s.ledger.BalancesForLot(ctx, scope, lot.ID)
	if err != nil {
		return domain.RecallList{}, err
	}
	return domain.BuildRecall(lot, movements, balances), nil
}

// escalateRecall tells the wards holding the stock (SRS-MAT-013).
func (s *Service) escalateRecall(ctx context.Context, scope authctx.TenantScope,
	recall domain.RecallList, now time.Time) error {

	if s.escalations == nil {
		return nil
	}
	label := recall.LotCode
	if label == "" {
		label = recall.LotID
	}
	summary := "Lot " + label + " blocked: " + recall.Reason + ". " +
		itoa(len(recall.Holdings)) + " holding(s) to recover, " +
		itoa(len(recall.Patients)) + " patient(s) already exposed."

	_, err := s.escalations.Raise(ctx, scope, ports.Notice{
		Kind:    EscalationKind,
		Subject: "lot " + label,
		Summary: summary,
	}, now)
	return err
}

// BlockedLots is the recall worklist (SRS-MAT-013).
func (s *Service) BlockedLots(ctx context.Context, limit int32) (
	[]domain.Lot, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.master.BlockedLots(ctx, scope, clampPageSize(limit))
}
