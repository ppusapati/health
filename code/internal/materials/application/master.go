package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/materials/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// AddItem adds an item to the master (SRS-MAT-001).
func (s *Service) AddItem(ctx context.Context, in domain.NewItemInput) (
	domain.Item, error) {

	session, scope, err := s.authorize(ctx, PermConfigure)
	if err != nil {
		return domain.Item{}, err
	}
	now := s.clock.Now()

	item, err := domain.NewItem(
		s.ids.NewID(), session.TenantID, in, session.SubjectID, now)
	if err != nil {
		return domain.Item{}, materialsError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.master.InsertItem(ctx, scope, item); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermConfigure,
			ResourceType: "materials_item", ResourceID: item.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "item " + item.Code + " added",
		}, now)
	})
	if err != nil {
		return domain.Item{}, err
	}
	return item, nil
}

// ReconfigureItemInput changes what a deployment has decided about an item.
type ReconfigureItemInput struct {
	ItemID           string
	Display          string
	Category         string
	Policy           domain.PickPolicy
	InspectOnReceipt bool
	Consignable      bool
	Active           bool
}

// ReconfigureItem changes an item's handling (SRS-MAT-001).
//
// Tracking and unit of measure are not changeable here. Both are the basis of
// every movement already in the ledger: changing an item from pieces to boxes
// would silently restate every historical balance by a factor of the pack, and
// changing its tracking would orphan the lots that exist.
func (s *Service) ReconfigureItem(ctx context.Context,
	in ReconfigureItemInput) (domain.Item, error) {

	session, scope, err := s.authorize(ctx, PermConfigure)
	if err != nil {
		return domain.Item{}, err
	}
	now := s.clock.Now()

	var out domain.Item
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		item, err := s.master.Item(ctx, scope, in.ItemID)
		if err != nil {
			return err
		}

		// Re-validated through the constructor rather than assigned, so the
		// perishable-and-FIFO refusal and the rest apply to a change as much
		// as to a creation.
		next, err := domain.NewItem(item.ID, item.TenantID,
			domain.NewItemInput{
				Code: item.Code, Display: in.Display, Category: in.Category,
				UOM: item.UOM, Tracking: item.Tracking, Policy: in.Policy,
				Perishable: item.Perishable, InspectOnReceipt: in.InspectOnReceipt,
				Consignable: in.Consignable,
			}, item.CreatedBy, item.CreatedAt)
		if err != nil {
			return materialsError(err)
		}
		next.Active = in.Active
		next.Version = item.Version

		if err := s.master.UpdateItem(
			ctx, scope, next, item.Version); err != nil {
			return materialsError(err)
		}
		out = next

		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermConfigure,
			ResourceType: "materials_item", ResourceID: item.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "item " + item.Code + " reconfigured",
		}, now)
	})
	if err != nil {
		return domain.Item{}, err
	}
	return out, nil
}

// Item reads one item.
func (s *Service) Item(ctx context.Context, itemID string) (domain.Item, error) {
	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Item{}, err
	}
	return s.master.Item(ctx, scope, itemID)
}

// Items lists the master.
func (s *Service) Items(ctx context.Context, category string, activeOnly bool,
	limit int32) ([]domain.Item, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.master.Items(ctx, scope, category, activeOnly, clampPageSize(limit))
}

// AddSupplier registers a supplier (SRS-MAT-003).
func (s *Service) AddSupplier(ctx context.Context,
	in domain.NewSupplierInput) (domain.Supplier, error) {

	session, scope, err := s.authorize(ctx, PermConfigure)
	if err != nil {
		return domain.Supplier{}, err
	}
	now := s.clock.Now()

	supplier, err := domain.NewSupplier(
		s.ids.NewID(), session.TenantID, in, session.SubjectID, now)
	if err != nil {
		return domain.Supplier{}, materialsError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.master.InsertSupplier(ctx, scope, supplier); err != nil {
			return err
		}
		reason := "supplier " + supplier.Code + " registered"
		if supplier.Approved {
			// Approval is what lets money be committed, so it is named in the
			// audit trail rather than left as a column somebody has to join.
			reason += ", approved"
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermConfigure,
			ResourceType: "materials_supplier", ResourceID: supplier.ID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return domain.Supplier{}, err
	}
	return supplier, nil
}

// SetSupplierApprovalInput approves or unapproves a supplier.
type SetSupplierApprovalInput struct {
	SupplierID string
	Approved   bool
	Reason     string
}

// SetSupplierApproval decides whether a supplier may be bought from
// (SRS-MAT-003).
func (s *Service) SetSupplierApproval(ctx context.Context,
	in SetSupplierApprovalInput) (domain.Supplier, error) {

	session, scope, err := s.authorize(ctx, PermConfigure)
	if err != nil {
		return domain.Supplier{}, err
	}
	now := s.clock.Now()

	if !in.Approved && in.Reason == "" {
		// Withdrawing approval stops every future order to this supplier.
		// Somebody will ask why in three months.
		return domain.Supplier{}, rpcerr.Invalid("MAT_INVALID",
			"say why this supplier's approval is being withdrawn")
	}

	var out domain.Supplier
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		supplier, err := s.master.Supplier(ctx, scope, in.SupplierID)
		if err != nil {
			return err
		}
		supplier.Approved = in.Approved
		if err := s.master.UpdateSupplier(
			ctx, scope, supplier, supplier.Version); err != nil {
			return materialsError(err)
		}
		out = supplier

		verdict := "approved"
		if !in.Approved {
			verdict = "approval withdrawn: " + in.Reason
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermConfigure,
			ResourceType: "materials_supplier", ResourceID: supplier.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  supplier.Code + " " + verdict,
		}, now)
	})
	if err != nil {
		return domain.Supplier{}, err
	}
	return out, nil
}

// Supplier reads one supplier.
func (s *Service) Supplier(ctx context.Context, supplierID string) (
	domain.Supplier, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Supplier{}, err
	}
	return s.master.Supplier(ctx, scope, supplierID)
}

// Suppliers lists who the hospital buys from.
func (s *Service) Suppliers(ctx context.Context, approvedOnly bool,
	limit int32) ([]domain.Supplier, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.master.Suppliers(ctx, scope, approvedOnly, clampPageSize(limit))
}

// SetStockLevel configures an item's min-max at a location (SRS-MAT-012).
func (s *Service) SetStockLevel(ctx context.Context,
	level domain.StockLevel) error {

	session, scope, err := s.authorize(ctx, PermConfigure)
	if err != nil {
		return err
	}
	now := s.clock.Now()

	if err := level.Validate(); err != nil {
		return materialsError(err)
	}

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		// The item has to exist, because a level against a code nobody
		// recognises produces a reorder alert nobody can act on.
		item, err := s.master.Item(ctx, scope, level.ItemID)
		if err != nil {
			return err
		}
		if err := s.master.UpsertStockLevel(
			ctx, scope, level, session.SubjectID, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermConfigure,
			ResourceType: "materials_stock_level", ResourceID: item.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: item.Code + " at " + level.LocationID + ": min " +
				itoa(level.Minimum) + " max " + itoa(level.Maximum),
		}, now)
	})
}

// StockLevels lists the configured policies.
func (s *Service) StockLevels(ctx context.Context, locationID string,
	limit int32) ([]domain.StockLevel, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.master.StockLevels(ctx, scope, locationID, clampPageSize(limit))
}

// AddApprovalRule adds a routing rule (SRS-MAT-002).
func (s *Service) AddApprovalRule(ctx context.Context,
	rule domain.ApprovalRule) (domain.ApprovalRule, error) {

	session, scope, err := s.authorize(ctx, PermConfigure)
	if err != nil {
		return domain.ApprovalRule{}, err
	}
	now := s.clock.Now()

	rule.ID = s.ids.NewID()
	rule.TenantID = session.TenantID
	if err := rule.Validate(); err != nil {
		return domain.ApprovalRule{}, materialsError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.procurement.InsertApprovalRule(
			ctx, scope, rule, session.SubjectID, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermConfigure,
			ResourceType: "materials_approval_rule", ResourceID: rule.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: "route from " + itoa(int(rule.MinimumValue)) +
				": " + join(rule.Roles),
		}, now)
	})
	if err != nil {
		return domain.ApprovalRule{}, err
	}
	return rule, nil
}

// ApprovalRules reads the routing configuration.
func (s *Service) ApprovalRules(ctx context.Context) (
	[]domain.ApprovalRule, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.procurement.ApprovalRules(ctx, scope)
}

// RemoveApprovalRule deletes a routing rule (SRS-MAT-002).
//
// Audited with what it removed, because deleting a rule lowers the bar on
// every future request it would have matched, and the row itself is gone.
func (s *Service) RemoveApprovalRule(ctx context.Context, ruleID string) error {
	session, scope, err := s.authorize(ctx, PermConfigure)
	if err != nil {
		return err
	}
	now := s.clock.Now()

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		rules, err := s.procurement.ApprovalRules(ctx, scope)
		if err != nil {
			return err
		}
		var removed domain.ApprovalRule
		for _, rule := range rules {
			if rule.ID == ruleID {
				removed = rule
				break
			}
		}
		if removed.ID == "" {
			return rpcerr.NotFound("MAT_NOT_FOUND", "no such approval rule")
		}

		if err := s.procurement.DeleteApprovalRule(ctx, scope, ruleID); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermConfigure,
			ResourceType: "materials_approval_rule", ResourceID: ruleID,
			Outcome: audit.OutcomeSuccess,
			Reason: "route removed, was from " +
				itoa(int(removed.MinimumValue)) + ": " + join(removed.Roles),
		}, now)
	})
}

// LotsForItem lists an item's lots.
func (s *Service) LotsForItem(ctx context.Context, itemID string,
	limit int32) ([]domain.Lot, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.master.LotsForItem(ctx, scope, itemID, clampPageSize(limit))
}

// Lot reads one lot.
func (s *Service) Lot(ctx context.Context, lotID string) (domain.Lot, error) {
	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.Lot{}, err
	}
	return s.master.Lot(ctx, scope, lotID)
}

// resolveLot finds or creates the lot a receipt line names.
//
// A second delivery of the same batch joins the existing lot rather than
// creating a duplicate: two rows for one manufacturer's batch would split a
// recall in half, and the half nobody found is the half still on a shelf.
func (s *Service) resolveLot(ctx context.Context, scope authctx.TenantScope,
	item domain.Item, line domain.ReceiptLine, now time.Time) (
	domain.Lot, error) {

	if line.LotCode != "" {
		existing, found, err := s.master.LotByCode(
			ctx, scope, item.ID, line.LotCode)
		if err != nil {
			return domain.Lot{}, err
		}
		if found {
			return existing, nil
		}
	}

	lot, err := domain.NewLot(s.ids.NewID(), item.TenantID, domain.NewLotInput{
		ItemID: item.ID, Code: line.LotCode, Expiry: line.Expiry,
		Ownership: line.Ownership, SupplierID: line.SupplierID,
	}, item, now)
	if err != nil {
		return domain.Lot{}, materialsError(err)
	}
	if err := s.master.InsertLot(ctx, scope, lot); err != nil {
		return domain.Lot{}, err
	}
	return lot, nil
}
