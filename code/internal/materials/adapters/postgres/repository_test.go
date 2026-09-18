package postgres_test

import (
	"context"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	materialspostgres "github.com/ppusapati/health/code/internal/materials/adapters/postgres"
	"github.com/ppusapati/health/code/internal/materials/domain"
	"github.com/ppusapati/health/code/internal/materials/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
)

// The materials persistence adapter.
//
// Round-trip tests, because the defect they catch is invisible above the
// adapter: a dropped field reads back as a zero that looks like a decision
// nobody made. A lost pack size makes an invoice check pass on a hundredfold
// overcharge; a lost ownership flag turns a supplier's implant into the
// hospital's; a lost expiry makes a lot that went out of date last year
// issuable.
//
// Eight of these bypass the adapter and write raw SQL, because the rule under
// test belongs to the database rather than to Go — including the two that
// matter most: that the balance view and the ledger cannot disagree, and that
// the counter cannot approve their own adjustment.

var at = time.Date(2026, 9, 18, 10, 0, 0, 0, time.UTC)

type fixture struct {
	pool        *pgxpool.Pool
	master      materialspostgres.MasterRepo
	ledger      materialspostgres.LedgerRepo
	procurement materialspostgres.ProcurementRepo
	control     materialspostgres.ControlRepo

	scope    authctx.TenantScope
	tenantID string
}

func newFixture(t *testing.T) fixture {
	t.Helper()

	pool := pgtest.New(t)
	repo := materialspostgres.New(pgtx.NewManager(pool))
	tenantID := uuid.NewString()

	return fixture{
		pool:        pool,
		master:      materialspostgres.MasterRepo{Repository: repo},
		ledger:      materialspostgres.LedgerRepo{Repository: repo},
		procurement: materialspostgres.ProcurementRepo{Repository: repo},
		control:     materialspostgres.ControlRepo{Repository: repo},
		scope: authctx.NewSession(authctx.Session{
			SubjectID: "stores-1", TenantID: tenantID,
		}).TenantScope(),
		tenantID: tenantID,
	}
}

func (f fixture) item(t *testing.T, in domain.NewItemInput) domain.Item {
	t.Helper()
	item, err := domain.NewItem(uuid.NewString(), f.tenantID, in, "stores-1", at)
	if err != nil {
		t.Fatalf("NewItem: %v", err)
	}
	if err := f.master.InsertItem(context.Background(), f.scope, item); err != nil {
		t.Fatalf("InsertItem: %v", err)
	}
	return item
}

func (f fixture) supplier(t *testing.T, approved bool) domain.Supplier {
	t.Helper()
	supplier, err := domain.NewSupplier(uuid.NewString(), f.tenantID,
		domain.NewSupplierInput{
			Code: "ACME-" + uuid.NewString()[:8], Display: "Acme Surgical",
			Approved: approved, PaymentTermsDays: 30, Currency: "INR",
		}, "buyer-1", at)
	if err != nil {
		t.Fatalf("NewSupplier: %v", err)
	}
	if err := f.master.InsertSupplier(
		context.Background(), f.scope, supplier); err != nil {
		t.Fatalf("InsertSupplier: %v", err)
	}
	return supplier
}

func (f fixture) lot(t *testing.T, item domain.Item,
	in domain.NewLotInput) domain.Lot {

	t.Helper()
	in.ItemID = item.ID
	lot, err := domain.NewLot(uuid.NewString(), f.tenantID, in, item, at)
	if err != nil {
		t.Fatalf("NewLot: %v", err)
	}
	if err := f.master.InsertLot(context.Background(), f.scope, lot); err != nil {
		t.Fatalf("InsertLot: %v", err)
	}
	return lot
}

func (f fixture) move(t *testing.T, in domain.NewMovementInput,
	when time.Time) domain.Movement {

	t.Helper()
	m, err := domain.NewMovement(uuid.NewString(), f.tenantID, in, "stores-1", when)
	if err != nil {
		t.Fatalf("NewMovement: %v", err)
	}
	if err := f.ledger.AppendMovement(context.Background(), f.scope, m); err != nil {
		t.Fatalf("AppendMovement: %v", err)
	}
	return m
}

func bucket(location string, status domain.StockStatus) domain.Bucket {
	return domain.Bucket{LocationID: location, Status: status}
}

// SRS-MAT-001. An item round-trips with every field that changes a decision.
func TestAnItemRoundTripsWithItsPolicyAndTracking(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	item := f.item(t, domain.NewItemInput{
		Code: "SUT-30", Display: "Polyglactin 3-0", Category: "consumable",
		UOM: "piece", Tracking: domain.TrackingBatch, Perishable: true,
		InspectOnReceipt: true, Consignable: true,
	})

	back, err := f.master.Item(ctx, f.scope, item.ID)
	if err != nil {
		t.Fatalf("Item: %v", err)
	}
	if back.Tracking != domain.TrackingBatch || back.Policy != domain.PickFEFO {
		t.Errorf("tracking %s policy %s, want batch and fefo",
			back.Tracking, back.Policy)
	}
	if !back.Perishable || !back.InspectOnReceipt || !back.Consignable {
		t.Errorf("flags lost: %+v", back)
	}

	byCode, found, err := f.master.ItemByCode(ctx, f.scope, "SUT-30")
	if err != nil || !found {
		t.Fatalf("ItemByCode: %v (found %v)", err, found)
	}
	if byCode.ID != item.ID {
		t.Errorf("ItemByCode returned %s, want %s", byCode.ID, item.ID)
	}

	_, found, err = f.master.ItemByCode(ctx, f.scope, "NOTHING")
	if err != nil || found {
		t.Errorf("an unknown code reported found=%v err=%v; the caller says "+
			"so in its own words", found, err)
	}
}

// SRS-MAT-001. A catalogue code identifies one item.
func TestAnItemCodeIsUsedOnce(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	f.item(t, domain.NewItemInput{Code: "GLOVE-M", UOM: "piece"})

	_, err := f.pool.Exec(ctx, `
		INSERT INTO materials.item (
		    item_id, tenant_id, code, uom, tracking, policy,
		    created_at, created_by)
		VALUES ($1, $2, 'GLOVE-M', 'box', 'quantity', 'fifo', now(), 'someone')`,
		uuid.New(), f.tenantID)
	if err == nil {
		t.Fatal("two items share a catalogue code; a requisition naming it " +
			"would order one of them at random")
	}
}

// SRS-MAT-007. The balance view and the ledger cannot disagree, because there
// is only one of them.
//
// Raw SQL, because the property under test is the view's: the same arithmetic
// the domain does in Go, done in Postgres, over the same movements.
func TestTheBalanceViewAgreesWithTheLedgerItSums(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	item := f.item(t, domain.NewItemInput{Code: "GLOVE-M", UOM: "piece"})
	lot := f.lot(t, item, domain.NewLotInput{})

	var movements []domain.Movement
	movements = append(movements, f.move(t, domain.NewMovementInput{
		ItemID: item.ID, LotID: lot.ID,
		From: domain.Outside, To: bucket("main-store", domain.StatusAvailable),
		Quantity: 500, Kind: domain.MovementReceipt,
	}, at))
	movements = append(movements, f.move(t, domain.NewMovementInput{
		ItemID: item.ID, LotID: lot.ID,
		From:     bucket("main-store", domain.StatusAvailable),
		To:       bucket("ward-7", domain.StatusAvailable),
		Quantity: 120, Kind: domain.MovementIssue,
	}, at.Add(time.Hour)))
	movements = append(movements, f.move(t, domain.NewMovementInput{
		ItemID: item.ID, LotID: lot.ID,
		From: bucket("ward-7", domain.StatusAvailable), To: domain.Outside,
		Quantity: 20, Kind: domain.MovementConsumption,
	}, at.Add(2*time.Hour)))

	// What the database says.
	fromView, err := f.ledger.BalancesForItem(ctx, f.scope, item.ID, 100)
	if err != nil {
		t.Fatalf("BalancesForItem: %v", err)
	}

	// What the domain says over the same rows.
	fromDomain := domain.Balances(movements)

	if len(fromView) != len(fromDomain) {
		t.Fatalf("view has %d lines, the domain %d", len(fromView), len(fromDomain))
	}
	byBucket := map[string]int{}
	for _, b := range fromView {
		byBucket[b.Bucket.String()] = b.Quantity
	}
	for _, b := range fromDomain {
		if got := byBucket[b.Bucket.String()]; got != b.Quantity {
			t.Errorf("%s: view %d, domain %d", b.Bucket, got, b.Quantity)
		}
	}

	// And a bucket that emptied is not a line in either.
	f.move(t, domain.NewMovementInput{
		ItemID: item.ID, LotID: lot.ID,
		From: bucket("ward-7", domain.StatusAvailable), To: domain.Outside,
		Quantity: 100, Kind: domain.MovementConsumption,
	}, at.Add(3*time.Hour))

	after, err := f.ledger.BalancesForItem(ctx, f.scope, item.ID, 100)
	if err != nil {
		t.Fatalf("BalancesForItem: %v", err)
	}
	for _, b := range after {
		if b.Bucket.LocationID == "ward-7" {
			t.Errorf("an emptied bucket is still a line: %+v", b)
		}
	}
}

// SRS-MAT-006, SRS-MAT-013. Available-to-promise in SQL excludes the same
// three things the domain excludes.
func TestAvailableInSqlMatchesTheDomainOnEveryExclusion(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	item := f.item(t, domain.NewItemInput{
		Code: "SUT-30", UOM: "piece",
		Tracking: domain.TrackingBatch, Perishable: true,
	})

	good := f.lot(t, item, domain.NewLotInput{
		Code: "B-100", Expiry: at.AddDate(1, 0, 0),
	})
	blocked := f.lot(t, item, domain.NewLotInput{
		Code: "B-200", Expiry: at.AddDate(1, 0, 0),
	})
	expired := f.lot(t, item, domain.NewLotInput{
		Code: "B-300", Expiry: at.AddDate(0, 0, -1),
	})
	quarantined := f.lot(t, item, domain.NewLotInput{
		Code: "B-400", Expiry: at.AddDate(1, 0, 0),
	})

	for _, lot := range []domain.Lot{good, blocked, expired} {
		f.move(t, domain.NewMovementInput{
			ItemID: item.ID, LotID: lot.ID,
			From: domain.Outside, To: bucket("main-store", domain.StatusAvailable),
			Quantity: 50, Kind: domain.MovementReceipt,
		}, at)
	}
	f.move(t, domain.NewMovementInput{
		ItemID: item.ID, LotID: quarantined.ID,
		From: domain.Outside, To: bucket("main-store", domain.StatusQuarantine),
		Quantity: 50, Kind: domain.MovementReceipt,
	}, at)

	if err := blocked.Block("supplier recall", "qa-1", at); err != nil {
		t.Fatalf("Block: %v", err)
	}
	if err := f.master.UpdateLotBlock(
		ctx, f.scope, blocked, blocked.Version); err != nil {
		t.Fatalf("UpdateLotBlock: %v", err)
	}

	inSQL, err := f.ledger.Available(ctx, f.scope, item.ID, "main-store", at)
	if err != nil {
		t.Fatalf("Available: %v", err)
	}
	if inSQL != 50 {
		t.Errorf("SQL available = %d, want 50", inSQL)
	}

	// The same number the long way, so the two implementations are held
	// together rather than merely both existing.
	balances, err := f.ledger.BalancesForItem(ctx, f.scope, item.ID, 100)
	if err != nil {
		t.Fatalf("BalancesForItem: %v", err)
	}
	lots := map[string]domain.Lot{}
	for _, lot := range []domain.Lot{good, blocked, expired, quarantined} {
		fresh, err := f.master.Lot(ctx, f.scope, lot.ID)
		if err != nil {
			t.Fatalf("Lot: %v", err)
		}
		lots[fresh.ID] = fresh
	}
	inGo := domain.Available(balances, lots, item.ID, "main-store", at)
	if inGo != inSQL {
		t.Errorf("the domain says %d available and the database says %d; one "+
			"of them is offering blocked or expired stock", inGo, inSQL)
	}
}

// SRS-MAT-007. The ledger refuses a row that changes no balance.
//
// Raw SQL, because the constraint belongs to the database: anything writing
// directly — a migration, a repair script — has to meet it too.
func TestTheDatabaseRefusesAMovementThatMovesNothing(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	item := f.item(t, domain.NewItemInput{Code: "GLOVE-M", UOM: "piece"})
	lot := f.lot(t, item, domain.NewLotInput{})

	for _, tc := range []struct {
		name                                           string
		fromLocation, fromStatus, toLocation, toStatus string
		quantity                                       int
	}{
		{name: "both sides outside", quantity: 10},
		{name: "same bucket to same bucket",
			fromLocation: "main-store", fromStatus: "available",
			toLocation: "main-store", toStatus: "available", quantity: 10},
		{name: "zero quantity",
			toLocation: "main-store", toStatus: "available", quantity: 0},
		{name: "a location with no status",
			toLocation: "main-store", quantity: 10},
		{name: "a status with no location",
			toStatus: "available", quantity: 10},
	} {
		_, err := f.pool.Exec(ctx, `
			INSERT INTO materials.movement (
			    movement_id, tenant_id, item_id, lot_id, from_location,
			    from_status, to_location, to_status, quantity, kind,
			    occurred_at, recorded_by)
			VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, 'receipt', now(), 'someone')`,
			uuid.New(), f.tenantID, item.ID, lot.ID,
			tc.fromLocation, tc.fromStatus, tc.toLocation, tc.toStatus,
			tc.quantity)
		if err == nil {
			t.Errorf("%s was accepted; it would sit in the ledger looking "+
				"like an event", tc.name)
		}
	}
}

// SRS-MAT-013, SRS-MAT-016. A lot round-trips with the two flags that decide
// whether it may be used and who owns it.
func TestALotRoundTripsWithItsOwnershipAndBlock(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	supplier := f.supplier(t, true)
	item := f.item(t, domain.NewItemInput{
		Code: "IMPL-HIP", UOM: "each",
		Tracking: domain.TrackingSerial, Consignable: true,
	})

	lot := f.lot(t, item, domain.NewLotInput{
		Code: "SN-4410", Ownership: domain.OwnedConsignment,
		SupplierID: supplier.ID,
	})

	back, err := f.master.Lot(ctx, f.scope, lot.ID)
	if err != nil {
		t.Fatalf("Lot: %v", err)
	}
	if back.Ownership != domain.OwnedConsignment || back.SupplierID != supplier.ID {
		t.Errorf("ownership %s supplier %q; a lost flag turns a supplier's "+
			"implant into the hospital's", back.Ownership, back.SupplierID)
	}

	if err := back.Block("field safety notice", "qa-1", at.Add(time.Hour)); err != nil {
		t.Fatalf("Block: %v", err)
	}
	if err := f.master.UpdateLotBlock(ctx, f.scope, back, back.Version); err != nil {
		t.Fatalf("UpdateLotBlock: %v", err)
	}

	blocked, err := f.master.BlockedLots(ctx, f.scope, 50)
	if err != nil {
		t.Fatalf("BlockedLots: %v", err)
	}
	if len(blocked) != 1 || blocked[0].BlockedReason != "field safety notice" {
		t.Errorf("blocked lots = %+v", blocked)
	}

	// A stale version loses.
	if err := f.master.UpdateLotBlock(
		ctx, f.scope, back, back.Version); err != ports.ErrVersionConflict {
		t.Errorf("a stale write returned %v, want a version conflict", err)
	}
}

// SRS-MAT-016. The database refuses consignment stock that names no owner.
func TestTheDatabaseRefusesUnownedConsignmentStock(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	item := f.item(t, domain.NewItemInput{
		Code: "IMPL-HIP", UOM: "each",
		Tracking: domain.TrackingSerial, Consignable: true,
	})

	_, err := f.pool.Exec(ctx, `
		INSERT INTO materials.lot (
		    lot_id, tenant_id, item_id, code, received_at, ownership, created_at)
		VALUES ($1, $2, $3, 'SN-1', now(), 'consignment', now())`,
		uuid.New(), f.tenantID, item.ID)
	if err == nil {
		t.Fatal("consignment stock was recorded with no owner; consuming it " +
			"could raise no liability against anybody")
	}

	// The same row with an owner is accepted, so the constraint is not simply
	// refusing consignment.
	supplier := f.supplier(t, true)
	_, err = f.pool.Exec(ctx, `
		INSERT INTO materials.lot (
		    lot_id, tenant_id, item_id, code, received_at, ownership,
		    supplier_id, created_at)
		VALUES ($1, $2, $3, 'SN-2', now(), 'consignment', $4, now())`,
		uuid.New(), f.tenantID, item.ID, supplier.ID)
	if err != nil {
		t.Fatalf("owned consignment stock was refused: %v", err)
	}
}

// SRS-MAT-002. The approval chain is append-only and a level is claimed once.
func TestTheApprovalChainCannotBeRewrittenOrDoubled(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	req, err := domain.NewRequisition(uuid.NewString(), f.tenantID,
		domain.NewRequisitionInput{
			Number: "REQ-001", Source: domain.SourceManual,
			NeedBy: at.AddDate(0, 0, 14), CostCentre: "CC-THEATRE",
			Lines: []domain.RequisitionLine{{
				ItemID: uuid.NewString(), ItemCode: "GLOVE-M", Quantity: 500,
			}},
		}, "nurse-1", at)
	if err != nil {
		t.Fatalf("NewRequisition: %v", err)
	}
	if err := f.procurement.InsertRequisition(ctx, f.scope, req); err != nil {
		t.Fatalf("InsertRequisition: %v", err)
	}

	step := domain.ApprovalStep{
		ID: uuid.NewString(), Level: 1, Role: "storekeeper",
		Decision: domain.ApprovalApproved, Decider: "stores-1", At: at,
	}
	if err := f.procurement.AppendApproval(
		ctx, f.scope, req.ID, step); err != nil {
		t.Fatalf("AppendApproval: %v", err)
	}

	// A second row at the same level is refused, so two callers cannot both
	// claim step one and leave the history ambiguous.
	_, err = f.pool.Exec(ctx, `
		INSERT INTO materials.approval_step (
		    approval_step_id, tenant_id, requisition_id, level, role,
		    decision, decider, decided_at)
		VALUES ($1, $2, $3, 1, 'storekeeper', 'approved', 'someone-else', now())`,
		uuid.New(), f.tenantID, req.ID)
	if err == nil {
		t.Fatal("two approvals claimed level one; the history would not say " +
			"who approved it")
	}

	// A rejection with no reason is refused by the database too.
	_, err = f.pool.Exec(ctx, `
		INSERT INTO materials.approval_step (
		    approval_step_id, tenant_id, requisition_id, level, role,
		    decision, decider, decided_at)
		VALUES ($1, $2, $3, 2, 'manager', 'rejected', 'manager-1', now())`,
		uuid.New(), f.tenantID, req.ID)
	if err == nil {
		t.Fatal("a rejection with no reason was recorded")
	}

	back, err := f.procurement.Requisition(ctx, f.scope, req.ID)
	if err != nil {
		t.Fatalf("Requisition: %v", err)
	}
	if len(back.Approvals) != 1 || back.Approvals[0].Decider != "stores-1" {
		t.Errorf("chain = %+v", back.Approvals)
	}
}

// SRS-MAT-002. A routing rule that requires nobody is refused by the database.
//
// COALESCE is the reason this test exists: array_length of an empty array is
// NULL, and a CHECK evaluating to NULL passes. Without it the constraint would
// wave through exactly the case it is written for.
func TestTheDatabaseRefusesAnApprovalRuleRequiringNobody(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	_, err := f.pool.Exec(ctx, `
		INSERT INTO materials.approval_rule (
		    approval_rule_id, tenant_id, minimum_value, roles,
		    created_at, created_by)
		VALUES ($1, $2, 100000, '{}', now(), 'someone')`,
		uuid.New(), f.tenantID)
	if err == nil {
		t.Fatal("an approval rule requiring nobody was stored; it would " +
			"approve every request it matched")
	}

	_, err = f.pool.Exec(ctx, `
		INSERT INTO materials.approval_rule (
		    approval_rule_id, tenant_id, minimum_value, roles,
		    created_at, created_by)
		VALUES ($1, $2, 100000, ARRAY['finance_admin'], now(), 'someone')`,
		uuid.New(), f.tenantID)
	if err != nil {
		t.Fatalf("a rule naming one approver was refused: %v", err)
	}
}

// SRS-MAT-004. A purchase order round-trips with its pack sizes and prices,
// and every revision is retrievable.
func TestAPurchaseOrderRoundTripsAndKeepsEveryRevision(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	supplier := f.supplier(t, true)
	item := f.item(t, domain.NewItemInput{Code: "GLOVE-M", UOM: "piece"})

	order, err := domain.NewPurchaseOrder(uuid.NewString(), f.tenantID,
		domain.NewPOInput{
			Number: "PO-001", SupplierID: supplier.ID,
			Lines: []domain.POLine{{
				ItemID: item.ID, ItemCode: "GLOVE-M",
				Quantity: 5, PackSize: 100, UOM: "box",
				UnitPrice: domain.Money{Minor: 900_00, Currency: "INR"},
				TaxMinor:  225_00,
			}},
			ToleranceOverPercent: 5, ToleranceShortPercent: 10,
		}, supplier, "buyer-1", at)
	if err != nil {
		t.Fatalf("NewPurchaseOrder: %v", err)
	}
	if err := order.Issue("buyer-1", at); err != nil {
		t.Fatalf("Issue: %v", err)
	}
	if err := f.procurement.InsertPurchaseOrder(ctx, f.scope, order); err != nil {
		t.Fatalf("InsertPurchaseOrder: %v", err)
	}

	back, err := f.procurement.PurchaseOrder(ctx, f.scope, order.ID)
	if err != nil {
		t.Fatalf("PurchaseOrder: %v", err)
	}
	if len(back.Lines) != 1 {
		t.Fatalf("lines = %d", len(back.Lines))
	}
	if back.Lines[0].PackSize != 100 {
		t.Errorf("pack size = %d, want 100; losing it makes an invoice check "+
			"pass on a hundredfold overcharge", back.Lines[0].PackSize)
	}
	if back.Lines[0].UnitPrice.Minor != 900_00 ||
		back.Lines[0].TaxMinor != 225_00 {
		t.Errorf("price %+v tax %d", back.Lines[0].UnitPrice, back.Lines[0].TaxMinor)
	}
	if back.ToleranceOverPercent != 5 || back.ToleranceShortPercent != 10 {
		t.Errorf("tolerances lost: over %d short %d",
			back.ToleranceOverPercent, back.ToleranceShortPercent)
	}

	// Amend, and both revisions stay readable.
	amended, err := back.Amend(uuid.NewString(), back.Lines,
		"theatre list increased", "buyer-1", at.Add(time.Hour))
	if err != nil {
		t.Fatalf("Amend: %v", err)
	}
	// The earlier revision is closed first: at most one is live.
	superseded := back
	superseded.State = domain.POClosed
	if err := f.procurement.UpdatePurchaseOrderState(
		ctx, f.scope, superseded, superseded.Version); err != nil {
		t.Fatalf("UpdatePurchaseOrderState: %v", err)
	}
	if err := f.procurement.InsertPurchaseOrder(ctx, f.scope, amended); err != nil {
		t.Fatalf("InsertPurchaseOrder(amended): %v", err)
	}

	revisions, err := f.procurement.Revisions(ctx, f.scope, order.ChainID)
	if err != nil {
		t.Fatalf("Revisions: %v", err)
	}
	if len(revisions) != 2 || revisions[0].Revision != 1 ||
		revisions[1].Revision != 2 {
		t.Fatalf("revisions = %+v, want 1 then 2", revisions)
	}
	if revisions[1].AmendmentReason != "theatre list increased" {
		t.Error("the amendment reason was lost; nobody could defend the " +
			"change when the invoice arrives")
	}
}

// SRS-MAT-004. Two revisions of one order cannot both be live.
func TestOnlyOneRevisionOfAnOrderIsLive(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	supplier := f.supplier(t, true)
	item := f.item(t, domain.NewItemInput{Code: "GLOVE-M", UOM: "piece"})

	order, err := domain.NewPurchaseOrder(uuid.NewString(), f.tenantID,
		domain.NewPOInput{
			SupplierID: supplier.ID,
			Lines: []domain.POLine{{
				ItemID: item.ID, Quantity: 5, PackSize: 100,
			}},
		}, supplier, "buyer-1", at)
	if err != nil {
		t.Fatalf("NewPurchaseOrder: %v", err)
	}
	if err := order.Issue("buyer-1", at); err != nil {
		t.Fatalf("Issue: %v", err)
	}
	if err := f.procurement.InsertPurchaseOrder(ctx, f.scope, order); err != nil {
		t.Fatalf("InsertPurchaseOrder: %v", err)
	}

	amended, err := order.Amend(uuid.NewString(), order.Lines,
		"quantity changed", "buyer-1", at.Add(time.Hour))
	if err != nil {
		t.Fatalf("Amend: %v", err)
	}
	// Inserting the amendment while the first is still issued is refused: a
	// supplier would be delivering against either.
	if err := f.procurement.InsertPurchaseOrder(
		ctx, f.scope, amended); err == nil {
		t.Fatal("two revisions of one order were both live; a supplier would " +
			"be delivering against either and neither side could say which")
	}
}

// SRS-MAT-011. The database refuses an adjustment approved by the counter.
func TestTheDatabaseRefusesACountApprovedByItsOwnCounter(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	count, err := domain.NewCount(uuid.NewString(), f.tenantID,
		domain.NewCountInput{Number: "CNT-001", LocationID: "main-store"},
		"counter-1", at)
	if err != nil {
		t.Fatalf("NewCount: %v", err)
	}
	if err := f.control.InsertCount(ctx, f.scope, count); err != nil {
		t.Fatalf("InsertCount: %v", err)
	}

	_, err = f.pool.Exec(ctx, `
		UPDATE materials.stock_count
		SET state = 'approved', counted_by = 'counter-1',
		    approved_by = 'counter-1', approved_at = now()
		WHERE count_id = $1`, count.ID)
	if err == nil {
		t.Fatal("the person who counted approved their own adjustment; any " +
			"shortfall could be made to disappear")
	}

	_, err = f.pool.Exec(ctx, `
		UPDATE materials.stock_count
		SET state = 'approved', counted_by = 'counter-1',
		    approved_by = 'manager-1', approved_at = now()
		WHERE count_id = $1`, count.ID)
	if err != nil {
		t.Fatalf("an approval by somebody else was refused: %v", err)
	}
}

// SRS-MAT-010. A transfer round-trips with its per-line received counts.
func TestATransferRoundTripsWithWhatActuallyArrived(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	item := f.item(t, domain.NewItemInput{Code: "GLOVE-M", UOM: "piece"})
	lot := f.lot(t, item, domain.NewLotInput{})

	transfer, err := domain.NewTransfer(uuid.NewString(), f.tenantID,
		domain.NewTransferInput{
			Number: "TR-001", FromLocation: "main-store", ToLocation: "ward-7",
			Lines: []domain.TransferLine{
				{ItemID: item.ID, LotID: lot.ID, Quantity: 100},
			},
			Reason: "ward top-up",
		}, "stores-1", at)
	if err != nil {
		t.Fatalf("NewTransfer: %v", err)
	}
	if err := f.control.InsertTransfer(ctx, f.scope, transfer); err != nil {
		t.Fatalf("InsertTransfer: %v", err)
	}

	inTransit, err := f.control.TransfersInTransit(ctx, f.scope, "ward-7", 50)
	if err != nil {
		t.Fatalf("TransfersInTransit: %v", err)
	}
	if len(inTransit) != 1 {
		t.Fatalf("in transit = %d, want 1", len(inTransit))
	}

	short, err := transfer.Receive(
		map[string]int{item.ID + "/" + lot.ID: 98}, "ward-nurse-1",
		at.Add(time.Hour))
	if err != nil {
		t.Fatalf("Receive: %v", err)
	}
	if len(short) != 1 {
		t.Fatalf("short = %v", short)
	}
	if err := f.control.UpdateTransfer(
		ctx, f.scope, transfer, transfer.Version); err != nil {
		t.Fatalf("UpdateTransfer: %v", err)
	}

	back, err := f.control.Transfer(ctx, f.scope, transfer.ID)
	if err != nil {
		t.Fatalf("Transfer: %v", err)
	}
	if back.Lines[0].QuantityReceived != 98 {
		t.Errorf("received = %d, want 98; two cartons short is an "+
			"investigation, not a rounding", back.Lines[0].QuantityReceived)
	}
	if back.State != domain.TransferReceived || back.ReceivedBy != "ward-nurse-1" {
		t.Errorf("state %s received by %q", back.State, back.ReceivedBy)
	}
}

// SRS-MAT-016. One movement raises at most one liability, so a retry cannot
// bill a supplier twice for one implant.
func TestALiabilityIsRaisedOncePerMovement(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	supplier := f.supplier(t, true)
	item := f.item(t, domain.NewItemInput{
		Code: "IMPL-HIP", UOM: "each",
		Tracking: domain.TrackingSerial, Consignable: true,
	})
	lot := f.lot(t, item, domain.NewLotInput{
		Code: "SN-4410", Ownership: domain.OwnedConsignment,
		SupplierID: supplier.ID,
	})
	movement := f.move(t, domain.NewMovementInput{
		ItemID: item.ID, LotID: lot.ID,
		From: bucket("theatre-store", domain.StatusAvailable), To: domain.Outside,
		Quantity: 1, Kind: domain.MovementConsumption,
	}, at)

	event := domain.LiabilityEvent{
		ID: uuid.NewString(), TenantID: f.tenantID,
		LotID: lot.ID, ItemID: item.ID, SupplierID: supplier.ID,
		Quantity: 1, MovementID: movement.ID,
		OccurredAt: at, RecordedBy: "theatre-1",
	}
	if err := f.control.AppendLiability(ctx, f.scope, event); err != nil {
		t.Fatalf("AppendLiability: %v", err)
	}

	event.ID = uuid.NewString()
	if err := f.control.AppendLiability(ctx, f.scope, event); err == nil {
		t.Fatal("one consumption raised two liabilities; a retry would bill " +
			"the supplier twice for one implant")
	}

	back, err := f.control.Liabilities(ctx, f.scope, supplier.ID,
		at.Add(-time.Hour), at.Add(time.Hour), 50)
	if err != nil {
		t.Fatalf("Liabilities: %v", err)
	}
	if len(back) != 1 || back[0].MovementID != movement.ID {
		t.Errorf("liabilities = %+v", back)
	}
}

// SRS-MAT-005. A receipt round-trips with the discrepancy on every line.
func TestAReceiptRoundTripsWithItsDiscrepancies(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	supplier := f.supplier(t, true)
	item := f.item(t, domain.NewItemInput{Code: "GLOVE-M", UOM: "piece"})

	order, err := domain.NewPurchaseOrder(uuid.NewString(), f.tenantID,
		domain.NewPOInput{
			SupplierID: supplier.ID,
			Lines: []domain.POLine{{
				ItemID: item.ID, ItemCode: "GLOVE-M", Quantity: 5, PackSize: 100,
			}},
			ToleranceShortPercent: 10,
		}, supplier, "buyer-1", at)
	if err != nil {
		t.Fatalf("NewPurchaseOrder: %v", err)
	}
	if err := order.Issue("buyer-1", at); err != nil {
		t.Fatalf("Issue: %v", err)
	}
	if err := f.procurement.InsertPurchaseOrder(ctx, f.scope, order); err != nil {
		t.Fatalf("InsertPurchaseOrder: %v", err)
	}

	receipt, short, err := domain.NewReceipt(uuid.NewString(), f.tenantID,
		domain.NewReceiptInput{
			Number: "GRN-001", LocationID: "main-store",
			DeliveryNote: "DN-77", InvoiceRef: "INV-88",
			Lines: []domain.ReceiptLine{{
				ItemID: item.ID, QuantityReceived: 400,
			}},
		}, order, map[string]domain.Item{item.ID: item}, "stores-1", at)
	if err != nil {
		t.Fatalf("NewReceipt: %v", err)
	}
	if len(short) != 1 {
		t.Fatalf("short = %v, want one line reported", short)
	}
	if err := f.procurement.InsertReceipt(ctx, f.scope, receipt); err != nil {
		t.Fatalf("InsertReceipt: %v", err)
	}

	back, err := f.procurement.Receipt(ctx, f.scope, receipt.ID)
	if err != nil {
		t.Fatalf("Receipt: %v", err)
	}
	if back.Lines[0].QuantityOrdered != 500 ||
		back.Lines[0].QuantityReceived != 400 {
		t.Errorf("ordered %d received %d, want 500 and 400",
			back.Lines[0].QuantityOrdered, back.Lines[0].QuantityReceived)
	}
	if back.Lines[0].Discrepancy() != -100 {
		t.Errorf("discrepancy = %d", back.Lines[0].Discrepancy())
	}
	if back.PORevision != 1 {
		t.Errorf("po revision = %d; a receipt that did not say which would be "+
			"unresolvable the moment the order was amended", back.PORevision)
	}
	if back.DeliveryNote != "DN-77" || back.InvoiceRef != "INV-88" {
		t.Error("the supplier's own references were lost; a three-way match " +
			"joins on them")
	}
}

// Gate A2. Another tenant's scope reaches none of it.
func TestAnotherTenantReachesNothing(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	item := f.item(t, domain.NewItemInput{Code: "GLOVE-M", UOM: "piece"})
	lot := f.lot(t, item, domain.NewLotInput{})
	f.move(t, domain.NewMovementInput{
		ItemID: item.ID, LotID: lot.ID,
		From: domain.Outside, To: bucket("main-store", domain.StatusAvailable),
		Quantity: 100, Kind: domain.MovementReceipt,
	}, at)

	intruder := authctx.NewSession(authctx.Session{
		SubjectID: "stores-2", TenantID: uuid.NewString(),
	}).TenantScope()

	if _, err := f.master.Item(ctx, intruder, item.ID); err == nil {
		t.Error("another tenant read an item")
	}
	if _, err := f.master.Lot(ctx, intruder, lot.ID); err == nil {
		t.Error("another tenant read a lot")
	}
	balances, err := f.ledger.BalancesForItem(ctx, intruder, item.ID, 50)
	if err != nil {
		t.Fatalf("BalancesForItem: %v", err)
	}
	if len(balances) != 0 {
		t.Errorf("another tenant read %d balance line(s)", len(balances))
	}
	available, err := f.ledger.Available(ctx, intruder, item.ID, "main-store", at)
	if err != nil {
		t.Fatalf("Available: %v", err)
	}
	if available != 0 {
		t.Errorf("another tenant saw %d available", available)
	}
}
