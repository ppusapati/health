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

// Recommend suggests which lots to pick from (SRS-MAT-009).
//
// A recommendation, not an instruction. The person at the shelf can see things
// this cannot — a crushed box, a label that does not match — and what the
// system owes them is the right order and an honest account of what it left
// out.
func (s *Service) Recommend(ctx context.Context, itemID, locationID string,
	quantity int) (domain.Pick, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Pick{}, err
	}
	now := s.clock.Now()

	item, err := s.master.Item(ctx, scope, itemID)
	if err != nil {
		return domain.Pick{}, err
	}
	balances, err := s.ledger.BalancesAtLocation(
		ctx, scope, locationID, itemID, ledgerPageSize)
	if err != nil {
		return domain.Pick{}, err
	}
	lots, err := s.master.LotsAtLocation(
		ctx, scope, itemID, locationID, ledgerPageSize)
	if err != nil {
		return domain.Pick{}, err
	}
	return domain.Recommend(
		item, balances, lotsByID(lots), locationID, quantity, now), nil
}

// IssueInput sends stock out of a store (SRS-MAT-008).
type IssueInput struct {
	ItemID string
	// LotID picks a specific lot. Empty lets the item's policy choose, which
	// is what a ward top-up does; an implant for a named patient names its
	// serial.
	LotID        string
	FromLocation string
	// ToLocation is where it went. Empty means it left the hospital's stock
	// entirely — used on a patient or consumed by a department.
	ToLocation  string
	Quantity    int
	CostCentre  string
	PatientID   string
	EncounterID string
	Reference   string
	Reason      string
}

// Issued is what an issue produced.
type Issued struct {
	Movements []domain.Movement
	// Short is the quantity the location could not supply.
	Short int
	// Skipped names lots passed over and why.
	Skipped []string
	// ChargeID links the consumption to what the patient was charged
	// (SRS-MAT-008). Empty where no patient was named or no charge seam is
	// configured.
	ChargeID string
	// Liabilities are what consuming a supplier's stock owes them
	// (SRS-MAT-016).
	Liabilities []domain.LiabilityEvent
}

// Issue sends stock to a department, a patient or a cost centre
// (SRS-MAT-008, SRS-MAT-016).
//
// Picks by the item's policy where no lot is named, refuses blocked and
// expired stock, and raises the consignment liability in the same transaction
// as the movement — so a supplier's implant cannot be used without the
// hospital owing for it.
func (s *Service) Issue(ctx context.Context, in IssueInput) (Issued, error) {
	session, scope, err := s.authorize(ctx, PermIssue)
	if err != nil {
		return Issued{}, err
	}
	now := s.clock.Now()

	if in.CostCentre == "" {
		// SRS-MAT-008's clause is that the movement and the charge are
		// traceable. Stock issued against no cost centre is consumption
		// nobody's budget carries and no utilisation review can attribute.
		return Issued{}, rpcerr.Invalid("MAT_INVALID",
			"an issue names the cost centre it is against")
	}
	if err := s.knownPatient(ctx, scope, in.PatientID); err != nil {
		return Issued{}, err
	}

	var out Issued
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		item, err := s.master.Item(ctx, scope, in.ItemID)
		if err != nil {
			return err
		}

		lines, short, skipped, err := s.pickLines(ctx, scope, item, in, now)
		if err != nil {
			return err
		}
		out.Short, out.Skipped = short, skipped

		to := domain.Outside
		kind := domain.MovementConsumption
		if in.ToLocation != "" {
			to = domain.Bucket{
				LocationID: in.ToLocation, Status: domain.StatusAvailable,
			}
			kind = domain.MovementIssue
		}

		for _, line := range lines {
			lot, err := s.master.Lot(ctx, scope, line.LotID)
			if err != nil {
				return err
			}

			if lot.Ownership == domain.OwnedConsignment &&
				s.config.RequirePatientForConsignment && in.PatientID == "" {
				// The supplier invoices against the case. Consuming their
				// implant with no patient named produces a liability nobody
				// can reconcile to anything.
				return rpcerr.FailedPrecondition("MAT_PATIENT_REQUIRED",
					"consignment stock names the patient it was used on")
			}

			movement, liability, err := domain.Consume(
				s.ids.NewID(), s.ids.NewID(), session.TenantID, lot, item,
				line.Bucket, line.Quantity, in.PatientID, in.EncounterID,
				in.CostCentre, in.Reference, session.SubjectID, now)
			if err != nil {
				return materialsError(err)
			}
			// Consume always produces a departure. Where the stock is going
			// to another store rather than out of the hospital, the
			// destination and kind are corrected here rather than by a second
			// code path that could drift from the checks Consume applies.
			movement.To, movement.Kind = to, kind
			movement.Reason = in.Reason

			if err := s.ledger.AppendMovement(ctx, scope, movement); err != nil {
				return err
			}
			out.Movements = append(out.Movements, movement)

			if liability != nil {
				liability.MovementID = movement.ID
				if err := s.control.AppendLiability(
					ctx, scope, *liability); err != nil {
					return err
				}
				out.Liabilities = append(out.Liabilities, *liability)

				if err := s.appendEvent(ctx, session, EventConsignmentConsumed,
					"materials_liability", liability.ID, map[string]any{
						"supplier_id": liability.SupplierID,
						"item_id":     liability.ItemID,
						"quantity":    liability.Quantity,
					}, now); err != nil {
					return err
				}
			}
		}

		if len(out.Movements) == 0 {
			// Nothing was picked, so nothing happened. Reported as a refusal
			// rather than an empty success, because a caller that read
			// "issued" and got no stock would send somebody to a shelf that
			// has none.
			return rpcerr.FailedPrecondition("MAT_OUT_OF_STOCK",
				"nothing available at "+in.FromLocation+
					" for "+item.Code+"; "+join(skipped))
		}

		if err := s.raiseCharge(ctx, scope, in, item, out.Movements, now,
			&out); err != nil {
			return err
		}

		issued := 0
		for _, m := range out.Movements {
			issued += m.Quantity
		}
		if err := s.appendEvent(ctx, session, EventStockIssued,
			"materials_item", item.ID, map[string]any{
				"location_id": in.FromLocation,
				"quantity":    issued,
				"cost_centre": in.CostCentre,
			}, now); err != nil {
			return err
		}

		reason := itoa(issued) + " " + item.Code + " from " + in.FromLocation +
			" to " + in.CostCentre
		if short > 0 {
			reason += "; short " + itoa(short)
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermIssue,
			ResourceType: "materials_item", ResourceID: item.ID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return Issued{}, err
	}
	return out, nil
}

// pickLines resolves which lots an issue takes from.
func (s *Service) pickLines(ctx context.Context, scope authctx.TenantScope,
	item domain.Item, in IssueInput, now time.Time) (
	[]domain.PickLine, int, []string, error) {

	balances, err := s.ledger.BalancesAtLocation(
		ctx, scope, in.FromLocation, item.ID, ledgerPageSize)
	if err != nil {
		return nil, 0, nil, err
	}
	lots, err := s.master.LotsAtLocation(
		ctx, scope, item.ID, in.FromLocation, ledgerPageSize)
	if err != nil {
		return nil, 0, nil, err
	}

	if in.LotID == "" {
		pick := domain.Recommend(item, balances, lotsByID(lots),
			in.FromLocation, in.Quantity, now)
		return pick.Lines, pick.Short, pick.Skipped, nil
	}

	// A named lot is still checked. Naming one is how a nurse picks the
	// implant in their hand, not a way past the block and expiry rules.
	named, err := s.master.Lot(ctx, scope, in.LotID)
	if err != nil {
		return nil, 0, nil, err
	}
	pick := domain.Recommend(item, balances,
		map[string]domain.Lot{named.ID: named}, in.FromLocation,
		in.Quantity, now)
	return pick.Lines, pick.Short, pick.Skipped, nil
}

// raiseCharge tells billing what a patient consumed (SRS-MAT-008).
//
// Inside the caller's transaction on purpose: a movement recorded without its
// charge is stock that left and nobody billed for, and a charge without its
// movement is a patient billed for something the store still holds. The seam
// is a port because what a patient is charged belongs to SRS-BIL.
func (s *Service) raiseCharge(ctx context.Context, scope authctx.TenantScope,
	in IssueInput, item domain.Item, movements []domain.Movement,
	now time.Time, out *Issued) error {

	if s.charges == nil || in.PatientID == "" || in.ToLocation != "" {
		// No charge for a transfer between stores: nothing was consumed, and
		// billing a patient for stock that moved shelves is the error this
		// guard exists to prevent.
		return nil
	}

	quantity := 0
	for _, m := range movements {
		quantity += m.Quantity
	}
	chargeID, err := s.charges.Raise(ctx, scope, ports.Charge{
		PatientID: in.PatientID, EncounterID: in.EncounterID,
		ItemID: item.ID, ItemCode: item.Code, Quantity: quantity,
		CostCentre: in.CostCentre, MovementID: movements[0].ID,
	}, now)
	if err != nil {
		return err
	}
	out.ChargeID = chargeID
	return nil
}

// ReturnInput brings stock back to a store.
type ReturnInput struct {
	ItemID       string
	LotID        string
	FromLocation string
	ToLocation   string
	Quantity     int
	CostCentre   string
	Reason       string
}

// Return records stock coming back (SRS-MAT-008).
//
// Into quarantine, not straight onto the shelf. Stock that has been to a ward
// and come back has been out of the store's control: whether it is still fit
// is an inspection decision, and putting it back as available would make that
// decision by default.
func (s *Service) Return(ctx context.Context, in ReturnInput) (
	domain.Movement, error) {

	session, scope, err := s.authorize(ctx, PermIssue)
	if err != nil {
		return domain.Movement{}, err
	}
	now := s.clock.Now()

	var out domain.Movement
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		lot, err := s.master.Lot(ctx, scope, in.LotID)
		if err != nil {
			return err
		}

		movement, err := domain.NewMovement(s.ids.NewID(), session.TenantID,
			domain.NewMovementInput{
				ItemID: lot.ItemID, LotID: lot.ID,
				From: domain.Bucket{
					LocationID: in.FromLocation, Status: domain.StatusAvailable,
				},
				To: domain.Bucket{
					LocationID: in.ToLocation, Status: domain.StatusQuarantine,
				},
				Quantity: in.Quantity, Kind: domain.MovementReturn,
				CostCentre: in.CostCentre, Reason: in.Reason,
			}, session.SubjectID, now)
		if err != nil {
			return materialsError(err)
		}
		if err := s.ledger.AppendMovement(ctx, scope, movement); err != nil {
			return err
		}
		out = movement

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermIssue,
			ResourceType: "materials_lot", ResourceID: lot.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: itoa(in.Quantity) + " returned from " + in.FromLocation +
				" into quarantine at " + in.ToLocation,
		}, now)
	})
	if err != nil {
		return domain.Movement{}, err
	}
	return out, nil
}

// Balances reads what a store holds (SRS-MAT-007).
func (s *Service) Balances(ctx context.Context, locationID, itemID string,
	limit int32) ([]domain.Balance, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.ledger.BalancesAtLocation(
		ctx, scope, locationID, itemID, clampPageSize(limit))
}

// Available is available-to-promise (SRS-MAT-006, SRS-MAT-013).
func (s *Service) Available(ctx context.Context, itemID, locationID string) (
	int, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return 0, err
	}
	return s.ledger.Available(ctx, scope, itemID, locationID, s.clock.Now())
}

// Movements reads an item's ledger over a period (SRS-MAT-007).
func (s *Service) Movements(ctx context.Context, itemID string,
	from, to time.Time, limit int32) ([]domain.Movement, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	if from.IsZero() || to.IsZero() || !from.Before(to) {
		return nil, rpcerr.Invalid("MAT_INVALID",
			"a ledger read covers a period: give a start before an end")
	}
	return s.ledger.MovementsForItem(
		ctx, scope, itemID, from, to, clampPageSize(limit))
}
