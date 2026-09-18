package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/materials/domain"
)

// The materials rules (SRS-MAT-001 … 016).
//
// The ones worth asserting directly are the arithmetic and the refusals: that
// a balance is a sum over movements and cannot disagree with them, that a
// transfer conserves quantity through an in-transit state, that quarantined
// and blocked and expired stock each fail to be available independently, and
// that the four controls — approval routing, self-approval, count approval and
// over-receipt — refuse what they exist to refuse.

var at = time.Date(2026, 9, 18, 9, 0, 0, 0, time.UTC)

func mustItem(t *testing.T, in domain.NewItemInput) domain.Item {
	t.Helper()
	item, err := domain.NewItem("item-"+in.Code, "tenant-1", in, "stores-1", at)
	if err != nil {
		t.Fatalf("NewItem(%s): %v", in.Code, err)
	}
	return item
}

func glove(t *testing.T) domain.Item {
	return mustItem(t, domain.NewItemInput{
		Code: "GLOVE-M", Display: "Nitrile glove, medium",
		Category: "consumable", UOM: "piece",
	})
}

func suture(t *testing.T) domain.Item {
	return mustItem(t, domain.NewItemInput{
		Code: "SUT-30", Display: "Polyglactin 3-0", Category: "consumable",
		UOM: "piece", Tracking: domain.TrackingBatch, Perishable: true,
	})
}

func mustLot(t *testing.T, id string, item domain.Item,
	in domain.NewLotInput, received time.Time) domain.Lot {

	t.Helper()
	in.ItemID = item.ID
	lot, err := domain.NewLot(id, "tenant-1", in, item, received)
	if err != nil {
		t.Fatalf("NewLot(%s): %v", id, err)
	}
	return lot
}

func mustMove(t *testing.T, id string, in domain.NewMovementInput) domain.Movement {
	t.Helper()
	m, err := domain.NewMovement(id, "tenant-1", in, "stores-1", at)
	if err != nil {
		t.Fatalf("NewMovement(%s): %v", id, err)
	}
	return m
}

func store(status domain.StockStatus) domain.Bucket {
	return domain.Bucket{LocationID: "main-store", Status: status}
}

func ward(status domain.StockStatus) domain.Bucket {
	return domain.Bucket{LocationID: "ward-7", Status: status}
}

// SRS-MAT-007. On-hand is a sum over immutable movements, which is the whole
// reason there is no maintained total anywhere.
func TestOnHandIsDerivedFromMovementsAndNothingElse(t *testing.T) {
	item := glove(t)
	lot := mustLot(t, "lot-1", item, domain.NewLotInput{}, at)

	movements := []domain.Movement{
		mustMove(t, "m-1", domain.NewMovementInput{
			ItemID: item.ID, LotID: lot.ID,
			From: domain.Outside, To: store(domain.StatusAvailable),
			Quantity: 500, Kind: domain.MovementReceipt,
		}),
		mustMove(t, "m-2", domain.NewMovementInput{
			ItemID: item.ID, LotID: lot.ID,
			From: store(domain.StatusAvailable), To: ward(domain.StatusAvailable),
			Quantity: 120, Kind: domain.MovementIssue,
		}),
		mustMove(t, "m-3", domain.NewMovementInput{
			ItemID: item.ID, LotID: lot.ID,
			From: ward(domain.StatusAvailable), To: domain.Outside,
			Quantity: 20, Kind: domain.MovementConsumption,
		}),
	}

	balances := domain.Balances(movements)
	if got := domain.OnHand(balances, item.ID, "main-store"); got != 380 {
		t.Errorf("main store = %d, want 380", got)
	}
	if got := domain.OnHand(balances, item.ID, "ward-7"); got != 100 {
		t.Errorf("ward = %d, want 100", got)
	}

	// Nothing was created or destroyed inside the hospital: what came in less
	// what went out is what is held.
	inside := 0
	for _, b := range balances {
		inside += b.Quantity
	}
	if inside != 500-20 {
		t.Errorf("stock inside the hospital = %d, want %d", inside, 500-20)
	}
}

// SRS-MAT-007. A movement that changes no balance is not a movement.
func TestAMovementHasSomewhereToComeFromAndSomewhereToGo(t *testing.T) {
	item := glove(t)

	for _, tc := range []struct {
		name     string
		from, to domain.Bucket
	}{
		{"both outside", domain.Outside, domain.Outside},
		{"same bucket", store(domain.StatusAvailable), store(domain.StatusAvailable)},
	} {
		_, err := domain.NewMovement("m-x", "tenant-1", domain.NewMovementInput{
			ItemID: item.ID, LotID: "lot-1", From: tc.from, To: tc.to,
			Quantity: 10, Kind: domain.MovementIssue,
		}, "stores-1", at)
		if err == nil {
			t.Errorf("%s was accepted; it would sit in the ledger looking "+
				"like an event", tc.name)
		}
	}

	for _, quantity := range []int{0, -5} {
		_, err := domain.NewMovement("m-x", "tenant-1", domain.NewMovementInput{
			ItemID: item.ID, LotID: "lot-1",
			From: domain.Outside, To: store(domain.StatusAvailable),
			Quantity: quantity, Kind: domain.MovementReceipt,
		}, "stores-1", at)
		if err == nil {
			t.Errorf("a movement of %d was accepted", quantity)
		}
	}
}

// SRS-MAT-006, SRS-MAT-009, SRS-MAT-013. Three things keep stock out of
// available-to-promise, and each fails on its own.
func TestAvailableExcludesQuarantinedBlockedAndExpiredSeparately(t *testing.T) {
	item := suture(t)

	good := mustLot(t, "lot-good", item, domain.NewLotInput{
		Code: "B-100", Expiry: at.AddDate(1, 0, 0),
	}, at)
	blocked := mustLot(t, "lot-blocked", item, domain.NewLotInput{
		Code: "B-200", Expiry: at.AddDate(1, 0, 0),
	}, at)
	if err := blocked.Block("supplier recall", "stores-1", at); err != nil {
		t.Fatalf("Block: %v", err)
	}
	expired := mustLot(t, "lot-expired", item, domain.NewLotInput{
		Code: "B-300", Expiry: at.AddDate(0, 0, -1),
	}, at.AddDate(-1, 0, 0))
	quarantined := mustLot(t, "lot-quarantined", item, domain.NewLotInput{
		Code: "B-400", Expiry: at.AddDate(1, 0, 0),
	}, at)

	lots := map[string]domain.Lot{
		good.ID: good, blocked.ID: blocked,
		expired.ID: expired, quarantined.ID: quarantined,
	}

	var movements []domain.Movement
	for i, lot := range []domain.Lot{good, blocked, expired} {
		movements = append(movements, mustMove(t, "m-a"+string(rune('0'+i)),
			domain.NewMovementInput{
				ItemID: item.ID, LotID: lot.ID,
				From: domain.Outside, To: store(domain.StatusAvailable),
				Quantity: 50, Kind: domain.MovementReceipt,
			}))
	}
	movements = append(movements, mustMove(t, "m-q", domain.NewMovementInput{
		ItemID: item.ID, LotID: quarantined.ID,
		From: domain.Outside, To: store(domain.StatusQuarantine),
		Quantity: 50, Kind: domain.MovementReceipt,
	}))

	balances := domain.Balances(movements)

	// Two hundred on the shelf; fifty of it usable.
	if got := domain.OnHand(balances, item.ID, "main-store"); got != 200 {
		t.Errorf("on hand = %d, want 200; quarantined stock is still on the shelf", got)
	}
	if got := domain.Available(balances, lots, item.ID, "main-store", at); got != 50 {
		t.Errorf("available = %d, want 50", got)
	}

	// And a pick sees the same thing, with a reason for each exclusion.
	pick := domain.Recommend(item, balances, lots, "main-store", 80, at)
	if len(pick.Lines) != 1 || pick.Lines[0].LotID != good.ID {
		t.Fatalf("pick = %+v, want one line from the good lot", pick.Lines)
	}
	if pick.Short != 30 {
		t.Errorf("short = %d, want 30", pick.Short)
	}
	if len(pick.Skipped) != 3 {
		t.Errorf("skipped = %v, want three reasons; a storekeeper looking at a "+
			"full shelf and a short pick needs to know why", pick.Skipped)
	}
}

// SRS-MAT-009. The pick order is the item's policy, not the code's habit.
func TestThePickOrderFollowsTheItemsPolicy(t *testing.T) {
	perishable := suture(t)

	// Received in one order, expiring in another. FEFO and FIFO disagree, and
	// the disagreement is the point.
	oldest := mustLot(t, "lot-oldest", perishable, domain.NewLotInput{
		Code: "B-1", Expiry: at.AddDate(0, 6, 0),
	}, at.AddDate(0, -3, 0))
	newest := mustLot(t, "lot-newest", perishable, domain.NewLotInput{
		Code: "B-2", Expiry: at.AddDate(0, 1, 0),
	}, at)

	lots := map[string]domain.Lot{oldest.ID: oldest, newest.ID: newest}
	movements := []domain.Movement{
		mustMove(t, "m-o", domain.NewMovementInput{
			ItemID: perishable.ID, LotID: oldest.ID,
			From: domain.Outside, To: store(domain.StatusAvailable),
			Quantity: 10, Kind: domain.MovementReceipt,
		}),
		mustMove(t, "m-n", domain.NewMovementInput{
			ItemID: perishable.ID, LotID: newest.ID,
			From: domain.Outside, To: store(domain.StatusAvailable),
			Quantity: 10, Kind: domain.MovementReceipt,
		}),
	}
	balances := domain.Balances(movements)

	// FEFO takes the one that will be thrown away, which is the newer box.
	fefo := domain.Recommend(perishable, balances, lots, "main-store", 5, at)
	if len(fefo.Lines) != 1 || fefo.Lines[0].LotID != newest.ID {
		t.Fatalf("FEFO picked %+v, want the earliest expiry", fefo.Lines)
	}

	// The same shelf under FIFO takes the one that arrived first.
	fifo := perishable
	fifo.Policy = domain.PickFIFO
	picked := domain.Recommend(fifo, balances, lots, "main-store", 5, at)
	if len(picked.Lines) != 1 || picked.Lines[0].LotID != oldest.ID {
		t.Fatalf("FIFO picked %+v, want the earliest received", picked.Lines)
	}
}

// SRS-MAT-001, SRS-MAT-005. An expiry belongs to a lot, so an item with no lot
// cannot claim one.
func TestAPerishableItemIsTrackedAndAPerishableLotHasADate(t *testing.T) {
	_, err := domain.NewItem("item-x", "tenant-1", domain.NewItemInput{
		Code: "MILK", UOM: "bottle", Perishable: true,
		Tracking: domain.TrackingQuantity,
	}, "stores-1", at)
	if !errors.Is(err, domain.ErrInvalidMaterials) {
		t.Error("a perishable item counted in bulk was accepted; its expiry " +
			"would have nothing to hang on")
	}

	_, err = domain.NewItem("item-y", "tenant-1", domain.NewItemInput{
		Code: "MILK", UOM: "bottle", Perishable: true,
		Tracking: domain.TrackingBatch, Policy: domain.PickFIFO,
	}, "stores-1", at)
	if !errors.Is(err, domain.ErrInvalidMaterials) {
		t.Error("a perishable item was set to earliest-received-first; it " +
			"would throw away stock somebody could have used")
	}

	item := suture(t)
	if _, err := domain.NewLot("lot-z", "tenant-1", domain.NewLotInput{
		ItemID: item.ID, Code: "B-1",
	}, item, at); !errors.Is(err, domain.ErrInvalidMaterials) {
		t.Error("a perishable lot was received with no expiry; it would never " +
			"go out of date")
	}

	if _, err := domain.NewLot("lot-z", "tenant-1", domain.NewLotInput{
		ItemID: item.ID, Expiry: at.AddDate(1, 0, 0),
	}, item, at); !errors.Is(err, domain.ErrInvalidMaterials) {
		t.Error("a batch-tracked lot was received with no batch; a recall " +
			"could not find it")
	}
}

// SRS-MAT-010. A transfer conserves quantity: the in-transit state is what
// makes the two balances reconcile at every moment, not only at the end.
func TestATransferConservesQuantityThroughInTransit(t *testing.T) {
	item := glove(t)
	lot := mustLot(t, "lot-1", item, domain.NewLotInput{}, at)

	received := mustMove(t, "m-r", domain.NewMovementInput{
		ItemID: item.ID, LotID: lot.ID,
		From: domain.Outside, To: store(domain.StatusAvailable),
		Quantity: 300, Kind: domain.MovementReceipt,
	})

	transfer, err := domain.NewTransfer("tr-1", "tenant-1",
		domain.NewTransferInput{
			FromLocation: "main-store", ToLocation: "ward-7",
			Lines:  []domain.TransferLine{{ItemID: item.ID, LotID: lot.ID, Quantity: 100}},
			Reason: "ward top-up",
		}, "stores-1", at)
	if err != nil {
		t.Fatalf("NewTransfer: %v", err)
	}

	out := mustMove(t, "m-out", domain.NewMovementInput{
		ItemID: item.ID, LotID: lot.ID,
		From:     store(domain.StatusAvailable),
		To:       domain.Bucket{LocationID: "ward-7", Status: domain.StatusInTransit},
		Quantity: 100, Kind: domain.MovementTransferOut, Reference: transfer.ID,
	})

	// Mid-flight: the source has given it up, the destination has not got it,
	// and the total inside the hospital has not changed.
	midFlight := domain.Balances([]domain.Movement{received, out})
	if got := domain.OnHand(midFlight, item.ID, "main-store"); got != 200 {
		t.Errorf("source mid-flight = %d, want 200", got)
	}
	if got := domain.Available(midFlight,
		map[string]domain.Lot{lot.ID: lot}, item.ID, "ward-7", at); got != 0 {
		t.Errorf("stock in transit was available at the destination (%d); it "+
			"is on a trolley somewhere", got)
	}
	total := 0
	for _, b := range midFlight {
		total += b.Quantity
	}
	if total != 300 {
		t.Errorf("mid-flight total = %d, want 300; nothing is ever nowhere", total)
	}

	// Ninety-eight arrive. The shortfall is recorded, not refused.
	short, err := transfer.Receive(
		map[string]int{item.ID + "/" + lot.ID: 98}, "ward-nurse-1", at.Add(time.Hour))
	if err != nil {
		t.Fatalf("Receive: %v", err)
	}
	if len(short) != 1 {
		t.Fatalf("short = %v, want one line", short)
	}

	in := mustMove(t, "m-in", domain.NewMovementInput{
		ItemID: item.ID, LotID: lot.ID,
		From:     domain.Bucket{LocationID: "ward-7", Status: domain.StatusInTransit},
		To:       ward(domain.StatusAvailable),
		Quantity: 98, Kind: domain.MovementTransferIn, Reference: transfer.ID,
	})

	settled := domain.Balances([]domain.Movement{received, out, in})
	if got := domain.OnHand(settled, item.ID, "ward-7"); got != 100 {
		t.Errorf("ward on-hand = %d, want 100; two are still in transit and "+
			"the ledger should say so rather than lose them", got)
	}
	inTransit := 0
	for _, b := range settled {
		if b.Bucket.Status == domain.StatusInTransit {
			inTransit += b.Quantity
		}
	}
	if inTransit != 2 {
		t.Errorf("in transit = %d, want 2; a missing carton is an "+
			"investigation, not a rounding", inTransit)
	}
}

// SRS-MAT-002. The route is amount, category and facility, and the chain is an
// order rather than a set.
func TestTheApprovalRouteAccumulatesAndKeepsItsOrder(t *testing.T) {
	rules := []domain.ApprovalRule{
		{ID: "r-1", Roles: []string{"storekeeper"}},
		{ID: "r-2", MinimumValue: 5_000_00, Currency: "INR",
			Roles: []string{"materials_manager"}},
		{ID: "r-3", MinimumValue: 50_000_00, Currency: "INR",
			Roles: []string{"finance_admin"}},
		{ID: "r-4", Category: "capital", Roles: []string{"medical_director"}},
	}
	for _, rule := range rules {
		if err := rule.Validate(); err != nil {
			t.Fatalf("Validate(%s): %v", rule.ID, err)
		}
	}

	for _, tc := range []struct {
		name       string
		value      domain.Money
		categories []string
		want       []string
	}{
		{
			name:  "a small consumable order stops at the storekeeper",
			value: domain.Money{Minor: 1_000_00, Currency: "INR"},
			want:  []string{"storekeeper"},
		},
		{
			name:  "a larger one adds the manager, after the storekeeper",
			value: domain.Money{Minor: 10_000_00, Currency: "INR"},
			want:  []string{"storekeeper", "materials_manager"},
		},
		{
			name:  "a large one adds finance, and the order is the route",
			value: domain.Money{Minor: 80_000_00, Currency: "INR"},
			want:  []string{"storekeeper", "materials_manager", "finance_admin"},
		},
		{
			name:       "a capital item adds the director whatever it costs",
			value:      domain.Money{Minor: 100_00, Currency: "INR"},
			categories: []string{"capital"},
			want:       []string{"storekeeper", "medical_director"},
		},
	} {
		got := domain.Route(rules, tc.value, tc.categories, "main")
		if len(got) != len(tc.want) {
			t.Errorf("%s: route = %v, want %v", tc.name, got, tc.want)
			continue
		}
		for i := range got {
			if got[i] != tc.want[i] {
				t.Errorf("%s: route = %v, want %v", tc.name, got, tc.want)
				break
			}
		}
	}

	// A rule that requires nobody is the dangerous one, and it is refused.
	empty := domain.ApprovalRule{ID: "r-bad", MinimumValue: 1000}
	if err := empty.Validate(); err == nil {
		t.Error("an approval rule requiring nobody was accepted; it would " +
			"approve every request it matched")
	}
}

func requisition(t *testing.T) domain.Requisition {
	t.Helper()
	r, err := domain.NewRequisition("req-1", "tenant-1",
		domain.NewRequisitionInput{
			Number: "REQ-001", FacilityID: "main", Source: domain.SourceManual,
			NeedBy: at.AddDate(0, 0, 14), CostCentre: "CC-THEATRE",
			Lines: []domain.RequisitionLine{{
				ItemID: "item-GLOVE-M", ItemCode: "GLOVE-M", Quantity: 500,
				UOM: "piece", EstimatedUnitPrice: domain.Money{Minor: 12_00, Currency: "INR"},
			}},
		}, "nurse-1", at)
	if err != nil {
		t.Fatalf("NewRequisition: %v", err)
	}
	return r
}

// SRS-MAT-002. The approval history is appended and never rewritten, the route
// is walked in order, and nobody approves their own request.
func TestApprovalIsInOrderAppendOnlyAndNeverSelfGiven(t *testing.T) {
	r := requisition(t)
	route := []string{"storekeeper", "materials_manager"}

	if err := r.Submit(route, at); err != nil {
		t.Fatalf("Submit: %v", err)
	}

	// Out of order: finance cannot sign before the storekeeper, because then
	// the storekeeper never sees it.
	if _, err := r.Decide("ap-x", route, domain.ApprovalApproved,
		"manager-1", "materials_manager", "", at); err == nil {
		t.Fatal("the second approver signed first")
	}

	// The requester cannot approve their own request.
	if _, err := r.Decide("ap-y", route, domain.ApprovalApproved,
		"nurse-1", "storekeeper", "", at); err == nil {
		t.Fatal("the person who raised the requisition approved it")
	}

	if _, err := r.Decide("ap-1", route, domain.ApprovalApproved,
		"stores-1", "storekeeper", "in budget", at); err != nil {
		t.Fatalf("first approval: %v", err)
	}
	if r.State != domain.RequisitionPending {
		t.Errorf("state after one of two approvals = %s, want pending", r.State)
	}

	if _, err := r.Decide("ap-2", route, domain.ApprovalApproved,
		"manager-1", "materials_manager", "", at.Add(time.Hour)); err != nil {
		t.Fatalf("second approval: %v", err)
	}
	if r.State != domain.RequisitionApproved {
		t.Errorf("state = %s, want approved", r.State)
	}

	// The chain is complete and contiguous, and a third decision is refused
	// rather than appended to a finished route.
	if len(r.Approvals) != 2 ||
		r.Approvals[0].Level != 1 || r.Approvals[1].Level != 2 {
		t.Fatalf("approvals = %+v", r.Approvals)
	}
	if _, err := r.Decide("ap-3", route, domain.ApprovalApproved,
		"someone", "materials_manager", "", at); err == nil {
		t.Error("a third approval was appended to a two-step route")
	}
}

// SRS-MAT-002. A request that matched no rule is a configuration gap, not an
// approval.
func TestARequisitionWithNoRouteCannotBeSubmitted(t *testing.T) {
	r := requisition(t)
	if err := r.Submit(nil, at); err == nil {
		t.Fatal("a requisition nobody had to approve was submitted; a " +
			"hospital would discover its rules were empty by reading an invoice")
	}
	if r.State != domain.RequisitionDraft {
		t.Errorf("state = %s, want it left in draft", r.State)
	}
}

// SRS-MAT-002. A rejection ends the chain and says why.
func TestARejectionEndsTheChainAndCarriesItsReason(t *testing.T) {
	r := requisition(t)
	route := []string{"storekeeper"}
	if err := r.Submit(route, at); err != nil {
		t.Fatalf("Submit: %v", err)
	}

	if _, err := r.Decide("ap-1", route, domain.ApprovalRejected,
		"stores-1", "storekeeper", "", at); err == nil {
		t.Fatal("a rejection with no reason was recorded; the requester " +
			"would raise it again unchanged")
	}

	if _, err := r.Decide("ap-1", route, domain.ApprovalRejected,
		"stores-1", "storekeeper", "buy from the rate contract instead",
		at); err != nil {
		t.Fatalf("Decide: %v", err)
	}
	if r.State != domain.RequisitionRejected {
		t.Errorf("state = %s, want rejected", r.State)
	}
}

func approvedSupplier(t *testing.T) domain.Supplier {
	t.Helper()
	s, err := domain.NewSupplier("sup-1", "tenant-1", domain.NewSupplierInput{
		Code: "ACME", Display: "Acme Surgical", Approved: true,
		PaymentTermsDays: 30, Currency: "INR",
	}, "buyer-1", at)
	if err != nil {
		t.Fatalf("NewSupplier: %v", err)
	}
	return s
}

// SRS-MAT-003. Two quotes are not comparable until the pack sizes, freight and
// tax are on the same footing.
func TestBidComparisonNormalisesPackSizeFreightAndTax(t *testing.T) {
	bids := []domain.Bid{
		{
			// Quoted per box of 100 at 900 rupees: nine rupees a piece.
			ID: "bid-box", SupplierID: "sup-1", Currency: "INR",
			Lines: []domain.BidLine{{
				ItemID: "item-GLOVE-M", Quantity: 5, PackSize: 100,
				UnitPrice: domain.Money{Minor: 900_00, Currency: "INR"},
			}},
			FreightMinor: 500_00, LeadTimeDays: 7,
		},
		{
			// Quoted per piece at eight rupees, which is cheaper per piece and
			// looks a hundred times cheaper per line.
			ID: "bid-piece", SupplierID: "sup-2", Currency: "INR",
			Lines: []domain.BidLine{{
				ItemID: "item-GLOVE-M", Quantity: 500, PackSize: 1,
				UnitPrice: domain.Money{Minor: 8_00, Currency: "INR"},
			}},
			FreightMinor: 0, LeadTimeDays: 21,
		},
		{
			// A quote nobody can normalise, because it does not say what a
			// pack holds.
			ID: "bid-vague", SupplierID: "sup-3", Currency: "INR",
			Lines: []domain.BidLine{{
				ItemID: "item-GLOVE-M", Quantity: 5,
				UnitPrice: domain.Money{Minor: 100_00, Currency: "INR"},
			}},
		},
	}

	compared := domain.Compare(bids)
	if len(compared) != 3 {
		t.Fatalf("comparisons = %d, want 3", len(compared))
	}

	// The vague one sorts last however small its total is.
	if compared[2].BidID != "bid-vague" {
		t.Errorf("order = %s %s %s; a bid nobody could normalise is not "+
			"cheapest because its total parsed small",
			compared[0].BidID, compared[1].BidID, compared[2].BidID)
	}
	if len(compared[2].Incomparable) == 0 {
		t.Error("the vague bid reported no reason; a buyer would see a row " +
			"that quietly sorted last")
	}

	byID := map[string]domain.Comparison{}
	for _, c := range compared {
		byID[c.BidID] = c
	}
	// Per piece: 900*5 + 500 freight over 500 pieces = 10 rupees.
	if got := byID["bid-box"].UnitMinor; got != 10_00 {
		t.Errorf("box bid unit = %d, want 1000 minor units", got)
	}
	// Per piece: 8*500 over 500 pieces = 8 rupees.
	if got := byID["bid-piece"].UnitMinor; got != 8_00 {
		t.Errorf("piece bid unit = %d, want 800 minor units", got)
	}
	// Lead time is carried, not scored: three weeks against two rupees is the
	// buyer's judgement.
	if byID["bid-piece"].LeadTimeDays != 21 {
		t.Error("lead time was not carried into the comparison")
	}
}

// SRS-MAT-003, SRS-MAT-004. An unapproved supplier is not quoted and not
// ordered from.
func TestAnUnapprovedSupplierIsNeitherQuotedNorOrdered(t *testing.T) {
	unapproved, err := domain.NewSupplier("sup-9", "tenant-1",
		domain.NewSupplierInput{Code: "NEW", Display: "Newco"}, "buyer-1", at)
	if err != nil {
		t.Fatalf("NewSupplier: %v", err)
	}
	suppliers := map[string]domain.Supplier{unapproved.ID: unapproved}

	if _, err := domain.NewRFQ("rfq-1", "tenant-1", domain.NewRFQInput{
		SupplierIDs: []string{unapproved.ID},
		Lines: []domain.RequisitionLine{{
			ItemID: "item-GLOVE-M", ItemCode: "GLOVE-M", Quantity: 10,
		}},
	}, suppliers, "buyer-1", at); err == nil {
		t.Error("an unapproved supplier was sent an RFQ")
	}

	if _, err := domain.NewPurchaseOrder("po-1", "tenant-1", domain.NewPOInput{
		Lines: []domain.POLine{{ItemID: "item-GLOVE-M", Quantity: 5}},
	}, unapproved, "buyer-1", at); err == nil {
		t.Error("an order was placed with an unapproved supplier")
	}
}

func issuedOrder(t *testing.T) domain.PurchaseOrder {
	t.Helper()
	order, err := domain.NewPurchaseOrder("po-1", "tenant-1", domain.NewPOInput{
		Number: "PO-001", FacilityID: "main",
		Lines: []domain.POLine{{
			ItemID: "item-GLOVE-M", ItemCode: "GLOVE-M",
			Quantity: 5, PackSize: 100, UOM: "box",
			UnitPrice: domain.Money{Minor: 900_00, Currency: "INR"},
			DeliverBy: at.AddDate(0, 0, 7),
		}},
		ToleranceOverPercent: 5, ToleranceShortPercent: 10,
	}, approvedSupplier(t), "buyer-1", at)
	if err != nil {
		t.Fatalf("NewPurchaseOrder: %v", err)
	}
	if err := order.Issue("buyer-1", at); err != nil {
		t.Fatalf("Issue: %v", err)
	}
	return order
}

// SRS-MAT-004. An amendment is a new revision, and the old one is untouched.
func TestAnAmendmentIsANewRevisionAndSaysWhy(t *testing.T) {
	order := issuedOrder(t)

	if _, err := order.Amend("po-2", order.Lines, "", "buyer-1", at); err == nil {
		t.Fatal("an amendment with no reason was accepted")
	}

	lines := []domain.POLine{{
		ItemID: "item-GLOVE-M", ItemCode: "GLOVE-M",
		Quantity: 8, PackSize: 100, UOM: "box",
		UnitPrice: domain.Money{Minor: 900_00, Currency: "INR"},
	}}
	amended, err := order.Amend("po-2", lines,
		"theatre list increased", "buyer-1", at.Add(time.Hour))
	if err != nil {
		t.Fatalf("Amend: %v", err)
	}

	if amended.Revision != 2 || amended.Supersedes != order.ID {
		t.Errorf("revision = %d superseding %q, want 2 superseding %q",
			amended.Revision, amended.Supersedes, order.ID)
	}
	if order.Lines[0].Quantity != 5 {
		t.Error("amending changed the earlier revision; a correct delivery " +
			"against it would now look short")
	}
	if amended.State != domain.PODraft {
		t.Errorf("an amended order is %s; the supplier has not been sent it",
			amended.State)
	}
}

// SRS-MAT-005. Over-receipt is refused and short receipt is recorded, and the
// asymmetry is the whole rule.
func TestOverReceiptIsRefusedAndShortReceiptIsRecorded(t *testing.T) {
	order := issuedOrder(t)
	items := map[string]domain.Item{"item-GLOVE-M": glove(t)}
	items["item-GLOVE-M"] = domain.Item{
		ID: "item-GLOVE-M", Code: "GLOVE-M", UOM: "piece",
		Tracking: domain.TrackingQuantity,
	}

	// 500 ordered, 5% over allowed. 530 is over.
	_, _, err := domain.NewReceipt("grn-1", "tenant-1", domain.NewReceiptInput{
		LocationID: "main-store",
		Lines: []domain.ReceiptLine{{
			ItemID: "item-GLOVE-M", QuantityReceived: 530,
		}},
	}, order, items, "stores-1", at)
	if err == nil {
		t.Fatal("an over-delivery beyond tolerance was accepted into the " +
			"ledger; somebody would be invoiced for it")
	}

	// 520 is within the 5%.
	if _, short, err := domain.NewReceipt("grn-2", "tenant-1",
		domain.NewReceiptInput{
			LocationID: "main-store",
			Lines: []domain.ReceiptLine{{
				ItemID: "item-GLOVE-M", QuantityReceived: 520,
			}},
		}, order, items, "stores-1", at); err != nil || len(short) != 0 {
		t.Fatalf("a delivery inside tolerance was refused: %v (short %v)", err, short)
	}

	// 400 is short beyond the 10%, and is recorded rather than refused: the
	// goods are on the dock whatever the count says.
	receipt, short, err := domain.NewReceipt("grn-3", "tenant-1",
		domain.NewReceiptInput{
			LocationID: "main-store",
			Lines: []domain.ReceiptLine{{
				ItemID: "item-GLOVE-M", QuantityReceived: 400,
			}},
		}, order, items, "stores-1", at)
	if err != nil {
		t.Fatalf("a short delivery was refused: %v", err)
	}
	if len(short) != 1 {
		t.Errorf("short = %v, want one line reported", short)
	}
	if receipt.Lines[0].Discrepancy() != -100 {
		t.Errorf("discrepancy = %d, want -100", receipt.Lines[0].Discrepancy())
	}
}

// SRS-MAT-006. Received stock lands where the item's configuration says, and
// unaccepted stock is not available.
func TestInspectedStockLandsInQuarantineAndIsNotAvailable(t *testing.T) {
	inspected := mustItem(t, domain.NewItemInput{
		Code: "IMPL-HIP", Display: "Hip stem", Category: "implant",
		UOM: "each", Tracking: domain.TrackingSerial, InspectOnReceipt: true,
	})
	ordinary := glove(t)

	if got := domain.LandingStatus(inspected); got != domain.StatusQuarantine {
		t.Errorf("an inspected item landed %s, want quarantine", got)
	}
	if got := domain.LandingStatus(ordinary); got != domain.StatusAvailable {
		t.Errorf("an ordinary item landed %s, want available", got)
	}

	lot := mustLot(t, "lot-1", inspected,
		domain.NewLotInput{Code: "SN-991"}, at)
	balances := domain.Balances([]domain.Movement{
		mustMove(t, "m-1", domain.NewMovementInput{
			ItemID: inspected.ID, LotID: lot.ID,
			From: domain.Outside, To: store(domain.StatusQuarantine),
			Quantity: 1, Kind: domain.MovementReceipt,
		}),
	})
	lots := map[string]domain.Lot{lot.ID: lot}

	if got := domain.OnHand(balances, inspected.ID, "main-store"); got != 1 {
		t.Errorf("on hand = %d, want 1; quarantined stock is on the shelf", got)
	}
	if got := domain.Available(balances, lots, inspected.ID, "main-store", at); got != 0 {
		t.Errorf("available = %d, want 0; unaccepted stock cannot become "+
			"available", got)
	}
}

// SRS-MAT-011. A variance needs a reason and an approver who is not the
// counter.
func TestACountVarianceNeedsAReasonAndSomebodyElsesApproval(t *testing.T) {
	count, err := domain.NewCount("cnt-1", "tenant-1", domain.NewCountInput{
		Number: "CNT-001", LocationID: "main-store", Cycle: true,
	}, "stores-1", at)
	if err != nil {
		t.Fatalf("NewCount: %v", err)
	}

	if err := count.Record([]domain.CountLine{
		{ItemID: "item-GLOVE-M", LotID: "lot-1", Expected: 500, Counted: 480},
	}, "counter-1", at.Add(time.Hour)); err != nil {
		t.Fatalf("Record: %v", err)
	}
	if len(count.Variances()) != 1 {
		t.Fatalf("variances = %d, want 1", len(count.Variances()))
	}

	if err := count.Approve("manager-1", "", at.Add(2*time.Hour)); err == nil {
		t.Fatal("a variance with no reason was approved; the same count " +
			"happens again next quarter with the same result")
	}

	count.Lines[0].Reason = "damaged in store, written off"
	if err := count.Approve("counter-1", "", at.Add(2*time.Hour)); err == nil {
		t.Fatal("the person who counted approved their own adjustment")
	}
	if err := count.Approve("manager-1", "spot-checked",
		at.Add(2*time.Hour)); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	if count.State != domain.CountApproved {
		t.Errorf("state = %s, want approved", count.State)
	}
}

// SRS-MAT-012. Alerts are derived, and a level nobody configured raises
// nothing.
func TestAlertsAreDerivedAndOnlyForConfiguredLevels(t *testing.T) {
	item := glove(t)
	lot := mustLot(t, "lot-1", item, domain.NewLotInput{}, at)
	lots := map[string]domain.Lot{lot.ID: lot}

	balances := domain.Balances([]domain.Movement{
		mustMove(t, "m-1", domain.NewMovementInput{
			ItemID: item.ID, LotID: lot.ID,
			From: domain.Outside, To: store(domain.StatusAvailable),
			Quantity: 40, Kind: domain.MovementReceipt,
		}),
	})

	if alerts := domain.StockAlerts(nil, balances, lots, 0, at); len(alerts) != 0 {
		t.Errorf("alerts with no configured level = %v; an alert on every "+
			"item is an alert on none", alerts)
	}

	levels := []domain.StockLevel{{
		ItemID: item.ID, LocationID: "main-store", Minimum: 100, Maximum: 500,
	}}
	alerts := domain.StockAlerts(levels, balances, lots, 0, at)
	if len(alerts) != 1 || alerts[0].Kind != domain.AlertBelowMinimum {
		t.Fatalf("alerts = %+v, want one below-minimum", alerts)
	}
	if alerts[0].SuggestedOrder != 460 {
		t.Errorf("suggested order = %d, want 460 (top up to the maximum)",
			alerts[0].SuggestedOrder)
	}

	// Nothing left is a stockout, which is a different alert from low.
	empty := domain.StockAlerts(levels, nil, lots, 0, at)
	if len(empty) != 1 || empty[0].Kind != domain.AlertStockout {
		t.Fatalf("alerts with nothing on the shelf = %+v, want a stockout", empty)
	}

	// A maximum below the minimum can never be topped up to.
	bad := domain.StockLevel{ItemID: item.ID, LocationID: "main-store",
		Minimum: 100, Maximum: 50}
	if err := bad.Validate(); err == nil {
		t.Error("a maximum below the minimum was accepted; every suggested " +
			"order would round to nothing and the store would never reorder")
	}
}

// SRS-MAT-013. A blocked lot is excluded from availability and its recall
// reaches the patients it was used on.
func TestABlockedLotLeavesAvailabilityAndItsRecallReachesPatients(t *testing.T) {
	item := suture(t)
	lot := mustLot(t, "lot-1", item, domain.NewLotInput{
		Code: "B-500", Expiry: at.AddDate(1, 0, 0),
	}, at)

	movements := []domain.Movement{
		mustMove(t, "m-1", domain.NewMovementInput{
			ItemID: item.ID, LotID: lot.ID,
			From: domain.Outside, To: store(domain.StatusAvailable),
			Quantity: 100, Kind: domain.MovementReceipt,
		}),
		mustMove(t, "m-2", domain.NewMovementInput{
			ItemID: item.ID, LotID: lot.ID,
			From: store(domain.StatusAvailable), To: domain.Outside,
			Quantity: 2, Kind: domain.MovementConsumption,
			PatientID: "patient-1", EncounterID: "enc-1",
		}),
		mustMove(t, "m-3", domain.NewMovementInput{
			ItemID: item.ID, LotID: lot.ID,
			From: store(domain.StatusAvailable), To: domain.Outside,
			Quantity: 1, Kind: domain.MovementConsumption,
			PatientID: "patient-2",
		}),
		mustMove(t, "m-4", domain.NewMovementInput{
			ItemID: item.ID, LotID: lot.ID,
			From: store(domain.StatusAvailable), To: domain.Outside,
			Quantity: 3, Kind: domain.MovementConsumption,
			PatientID: "patient-1",
		}),
	}
	balances := domain.Balances(movements)
	lots := map[string]domain.Lot{lot.ID: lot}

	if got := domain.Available(balances, lots, item.ID, "main-store", at); got != 94 {
		t.Fatalf("available before the block = %d, want 94", got)
	}

	if err := lot.Block("manufacturer recall, sterility", "qa-1",
		at.Add(time.Hour)); err != nil {
		t.Fatalf("Block: %v", err)
	}
	lots[lot.ID] = lot

	if got := domain.Available(balances, lots, item.ID, "main-store", at); got != 0 {
		t.Errorf("available after the block = %d, want 0", got)
	}
	// Blocked stock still exists: it is on the shelf and somebody has to go
	// and get it.
	if got := domain.OnHand(balances, item.ID, "main-store"); got != 94 {
		t.Errorf("on hand = %d, want 94; blocked stock is still counted", got)
	}

	recall := domain.BuildRecall(lot, movements, balances)
	if len(recall.Patients) != 2 {
		t.Errorf("recall reached %v, want two patients; one case using three "+
			"of a lot is one patient to contact", recall.Patients)
	}
	if len(recall.Consumptions) != 3 {
		t.Errorf("recall consumptions = %d, want 3", len(recall.Consumptions))
	}
	if len(recall.Holdings) != 1 || recall.Holdings[0].Quantity != 94 {
		t.Errorf("recall holdings = %+v, want 94 still in the store",
			recall.Holdings)
	}
}

// SRS-MAT-016. Consignment stock consumed raises the liability, and it cannot
// come apart from the movement.
func TestConsumingConsignmentStockRaisesItsLiability(t *testing.T) {
	implant := mustItem(t, domain.NewItemInput{
		Code: "IMPL-HIP", Display: "Hip stem", Category: "implant",
		UOM: "each", Tracking: domain.TrackingSerial, Consignable: true,
	})

	consigned := mustLot(t, "lot-c", implant, domain.NewLotInput{
		Code: "SN-4410", Ownership: domain.OwnedConsignment, SupplierID: "sup-1",
	}, at)

	movement, liability, err := domain.Consume("m-1", "liab-1", "tenant-1",
		consigned, implant, store(domain.StatusAvailable), 1,
		"patient-1", "enc-1", "CC-THEATRE", "case-1", "theatre-1", at)
	if err != nil {
		t.Fatalf("Consume: %v", err)
	}
	if liability == nil {
		t.Fatal("consignment stock was consumed and raised no liability; the " +
			"hospital used a supplier's implant and nobody will invoice for it")
	}
	if liability.SupplierID != "sup-1" || liability.PatientID != "patient-1" {
		t.Errorf("liability = %+v", liability)
	}
	if liability.MovementID != movement.ID {
		t.Error("the liability does not name the movement that caused it")
	}

	// The hospital's own stock raises none.
	owned := mustLot(t, "lot-o", implant, domain.NewLotInput{Code: "SN-4411"}, at)
	_, none, err := domain.Consume("m-2", "liab-2", "tenant-1", owned, implant,
		store(domain.StatusAvailable), 1, "patient-2", "", "CC-THEATRE",
		"case-2", "theatre-1", at)
	if err != nil {
		t.Fatalf("Consume: %v", err)
	}
	if none != nil {
		t.Error("the hospital's own stock raised a liability against a supplier")
	}

	// Consignment of an item nobody agreed to hold that way is refused.
	notConsignable := mustItem(t, domain.NewItemInput{
		Code: "GAUZE", UOM: "piece", Tracking: domain.TrackingBatch,
	})
	if _, err := domain.NewLot("lot-x", "tenant-1", domain.NewLotInput{
		ItemID: notConsignable.ID, Code: "B-1",
		Ownership: domain.OwnedConsignment, SupplierID: "sup-1",
	}, notConsignable, at); err == nil {
		t.Error("the hospital's own stock was recorded as a supplier's; the " +
			"error would surface as an invoice")
	}
}

// SRS-MAT-008, SRS-MAT-013. Quarantined, blocked and expired stock cannot be
// consumed, and each refusal says which.
func TestStockThatIsNotAvailableCannotBeConsumed(t *testing.T) {
	item := suture(t)
	good := mustLot(t, "lot-1", item, domain.NewLotInput{
		Code: "B-1", Expiry: at.AddDate(1, 0, 0),
	}, at)

	// From quarantine.
	if _, _, err := domain.Consume("m-1", "", "tenant-1", good, item,
		store(domain.StatusQuarantine), 1, "", "", "CC", "", "nurse-1",
		at); err == nil {
		t.Error("stock nobody accepted was consumed")
	}

	blocked := good
	if err := blocked.Block("recall", "qa-1", at); err != nil {
		t.Fatalf("Block: %v", err)
	}
	if _, _, err := domain.Consume("m-2", "", "tenant-1", blocked, item,
		store(domain.StatusAvailable), 1, "", "", "CC", "", "nurse-1",
		at); err == nil {
		t.Error("a blocked lot was consumed")
	}

	expired := mustLot(t, "lot-2", item, domain.NewLotInput{
		Code: "B-2", Expiry: at.AddDate(0, 0, -1),
	}, at.AddDate(-1, 0, 0))
	if _, _, err := domain.Consume("m-3", "", "tenant-1", expired, item,
		store(domain.StatusAvailable), 1, "", "", "CC", "", "nurse-1",
		at); err == nil {
		t.Error("expired stock was consumed")
	}
}

// SRS-MAT-014. Every line of all three documents appears, including the ones
// present in only one.
func TestThreeWayMatchSurfacesEveryKindOfMismatch(t *testing.T) {
	supplier := approvedSupplier(t)
	order, err := domain.NewPurchaseOrder("po-1", "tenant-1", domain.NewPOInput{
		Lines: []domain.POLine{
			{ItemID: "item-A", ItemCode: "A", Quantity: 5, PackSize: 100,
				UnitPrice: domain.Money{Minor: 900_00, Currency: "INR"}},
			{ItemID: "item-B", ItemCode: "B", Quantity: 10, PackSize: 1,
				UnitPrice: domain.Money{Minor: 50_00, Currency: "INR"}},
			{ItemID: "item-C", ItemCode: "C", Quantity: 2, PackSize: 1,
				UnitPrice: domain.Money{Minor: 100_00, Currency: "INR"}},
		},
	}, supplier, "buyer-1", at)
	if err != nil {
		t.Fatalf("NewPurchaseOrder: %v", err)
	}

	receipts := []domain.Receipt{{
		ID: "grn-1", PurchaseOrderID: order.ID, SupplierID: supplier.ID,
		Lines: []domain.ReceiptLine{
			// A matches exactly.
			{ItemID: "item-A", QuantityOrdered: 500, QuantityReceived: 500},
			// B arrived short of what was invoiced.
			{ItemID: "item-B", QuantityOrdered: 10, QuantityReceived: 8},
			// C was received and never invoiced.
			{ItemID: "item-C", QuantityOrdered: 2, QuantityReceived: 2},
		},
	}}

	invoice := domain.Invoice{
		ID: "inv-1", SupplierID: supplier.ID, PurchaseOrderID: order.ID,
		Currency: "INR",
		Lines: []domain.InvoiceLine{
			{ItemID: "item-A", Quantity: 500,
				UnitPrice: domain.Money{Minor: 9_00, Currency: "INR"}},
			{ItemID: "item-B", Quantity: 10,
				UnitPrice: domain.Money{Minor: 50_00, Currency: "INR"}},
			// D was invoiced and never ordered: the commonest fraud and the
			// commonest typo.
			{ItemID: "item-D", Quantity: 3,
				UnitPrice: domain.Money{Minor: 20_00, Currency: "INR"}},
		},
	}

	result := domain.ThreeWayMatch(order, receipts, invoice)
	if result.Matched {
		t.Fatal("a match with three problems reported as matched")
	}
	if len(result.Lines) != 4 {
		t.Fatalf("lines = %d, want 4 (A, B, C, D)", len(result.Lines))
	}

	byItem := map[string]domain.MatchLine{}
	for _, line := range result.Lines {
		byItem[line.ItemID] = line
	}
	if byItem["item-A"].Status != domain.MatchOK {
		t.Errorf("A = %s (%s), want matched; 900 per box of 100 is 9 per piece",
			byItem["item-A"].Status, byItem["item-A"].Detail)
	}
	if byItem["item-B"].Status != domain.MatchQuantity {
		t.Errorf("B = %s, want a quantity mismatch", byItem["item-B"].Status)
	}
	if byItem["item-C"].Status != domain.MatchMissing {
		t.Errorf("C = %s, want missing (received, not invoiced)",
			byItem["item-C"].Status)
	}
	if byItem["item-D"].Status != domain.MatchMissing {
		t.Errorf("D = %s, want missing (invoiced, never ordered)",
			byItem["item-D"].Status)
	}
}

// SRS-MAT-014. A price mismatch is found through the pack-size conversion,
// which is where a by-eye invoice check goes wrong.
func TestThreeWayMatchFindsAPriceMismatchThroughThePackSize(t *testing.T) {
	supplier := approvedSupplier(t)
	order, err := domain.NewPurchaseOrder("po-1", "tenant-1", domain.NewPOInput{
		Lines: []domain.POLine{{
			ItemID: "item-A", ItemCode: "A", Quantity: 5, PackSize: 100,
			UnitPrice: domain.Money{Minor: 900_00, Currency: "INR"},
		}},
	}, supplier, "buyer-1", at)
	if err != nil {
		t.Fatalf("NewPurchaseOrder: %v", err)
	}

	receipts := []domain.Receipt{{
		ID: "grn-1", PurchaseOrderID: order.ID, SupplierID: supplier.ID,
		Lines: []domain.ReceiptLine{
			{ItemID: "item-A", QuantityOrdered: 500, QuantityReceived: 500},
		},
	}}
	invoice := domain.Invoice{
		ID: "inv-1", SupplierID: supplier.ID, PurchaseOrderID: order.ID,
		Lines: []domain.InvoiceLine{{
			ItemID: "item-A", Quantity: 500,
			// Ten rupees a piece rather than nine: a thousand rupees on one
			// line, and invisible unless the pack size is applied.
			UnitPrice: domain.Money{Minor: 10_00, Currency: "INR"},
		}},
	}

	result := domain.ThreeWayMatch(order, receipts, invoice)
	if result.Matched {
		t.Fatal("an overcharge of a rupee a piece matched")
	}
	if result.Lines[0].Status != domain.MatchPrice {
		t.Errorf("status = %s, want a price mismatch", result.Lines[0].Status)
	}
}

// SRS-MAT-015. The KPIs are arithmetic over the ledger, restated here so the
// formula is checkable rather than only asserted.
func TestTheInventoryKPIsAreReproducibleFromTheLedger(t *testing.T) {
	item := glove(t)
	lot := mustLot(t, "lot-1", item, domain.NewLotInput{}, at.AddDate(0, -2, 0))
	from, to := at.AddDate(0, -1, 0), at

	movements := []domain.Movement{
		// Before the period: the opening balance.
		mustMoveAt(t, "m-0", domain.NewMovementInput{
			ItemID: item.ID, LotID: lot.ID,
			From: domain.Outside, To: store(domain.StatusAvailable),
			Quantity: 1000, Kind: domain.MovementReceipt,
		}, at.AddDate(0, -2, 0)),
		// In the period: 300 consumed.
		mustMoveAt(t, "m-1", domain.NewMovementInput{
			ItemID: item.ID, LotID: lot.ID,
			From: store(domain.StatusAvailable), To: domain.Outside,
			Quantity: 300, Kind: domain.MovementConsumption,
		}, at.AddDate(0, 0, -20)),
	}

	metrics := domain.ComputeMetrics(domain.MetricsInput{
		ItemID: item.ID, LocationID: "main-store", From: from, To: to,
		Movements: movements, Lots: map[string]domain.Lot{lot.ID: lot},
	})

	if metrics.OpeningOnHand != 1000 || metrics.ClosingOnHand != 700 {
		t.Fatalf("opening %d closing %d, want 1000 and 700",
			metrics.OpeningOnHand, metrics.ClosingOnHand)
	}
	if metrics.ConsumedUnits != 300 {
		t.Fatalf("consumed = %d, want 300", metrics.ConsumedUnits)
	}
	if metrics.AverageOnHand != 850 {
		t.Fatalf("average = %d, want 850", metrics.AverageOnHand)
	}

	// turns/year = 300 / 850, scaled from the period to a year.
	days := to.Sub(from).Hours() / 24
	wantTurns := 300.0 / 850.0 * (365 / days)
	if diff := metrics.TurnsPerYear - wantTurns; diff > 0.001 || diff < -0.001 {
		t.Errorf("turns = %f, want %f", metrics.TurnsPerYear, wantTurns)
	}

	// days on hand = 700 / (300 / period days).
	wantDays := 700.0 / (300.0 / days)
	if diff := metrics.DaysOnHand - wantDays; diff > 0.001 || diff < -0.001 {
		t.Errorf("days on hand = %f, want %f", metrics.DaysOnHand, wantDays)
	}

	// Consumption with nothing ever received is a gap, and it is named rather
	// than reported as a turn rate.
	orphan := domain.ComputeMetrics(domain.MetricsInput{
		ItemID: item.ID, LocationID: "other-store", From: from, To: to,
		Movements: []domain.Movement{
			mustMoveAt(t, "m-x", domain.NewMovementInput{
				ItemID: item.ID, LotID: lot.ID,
				From: domain.Bucket{LocationID: "other-store",
					Status: domain.StatusAvailable},
				To: domain.Outside, Quantity: 5, Kind: domain.MovementConsumption,
			}, at.AddDate(0, 0, -5)),
		},
	})
	if len(orphan.Incomplete) == 0 {
		t.Error("a ledger missing its receipts produced a turn rate with no " +
			"complaint")
	}
}

func mustMoveAt(t *testing.T, id string, in domain.NewMovementInput,
	when time.Time) domain.Movement {

	t.Helper()
	m, err := domain.NewMovement(id, "tenant-1", in, "stores-1", when)
	if err != nil {
		t.Fatalf("NewMovement(%s): %v", id, err)
	}
	return m
}

// SRS-MAT-015. A supplier's fill rate counts the revision delivered against,
// and an over-delivery does not make up for a short one.
func TestSupplierFillRateCountsOneRevisionAndDoesNotNetOut(t *testing.T) {
	supplier := approvedSupplier(t)
	from, to := at.AddDate(0, 0, -30), at.AddDate(0, 0, 30)

	order, err := domain.NewPurchaseOrder("po-1", "tenant-1", domain.NewPOInput{
		Lines: []domain.POLine{
			{ItemID: "item-A", Quantity: 100, PackSize: 1,
				DeliverBy: at.AddDate(0, 0, -5)},
			{ItemID: "item-B", Quantity: 100, PackSize: 1,
				DeliverBy: at.AddDate(0, 0, -5)},
		},
		ToleranceOverPercent: 20,
	}, supplier, "buyer-1", at.AddDate(0, 0, -20))
	if err != nil {
		t.Fatalf("NewPurchaseOrder: %v", err)
	}
	if err := order.Issue("buyer-1", at.AddDate(0, 0, -20)); err != nil {
		t.Fatalf("Issue: %v", err)
	}

	receipts := []domain.Receipt{{
		ID: "grn-1", PurchaseOrderID: order.ID, SupplierID: supplier.ID,
		Lines: []domain.ReceiptLine{
			// Over on one line.
			{ItemID: "item-A", QuantityOrdered: 100, QuantityReceived: 110},
			// Short on the other.
			{ItemID: "item-B", QuantityOrdered: 100, QuantityReceived: 50},
		},
		ReceivedAt: at.AddDate(0, 0, -10),
	}}

	rate := domain.ComputeFillRate(supplier.ID, from, to,
		[]domain.PurchaseOrder{order}, receipts)

	if rate.OrderedUnits != 200 {
		t.Fatalf("ordered = %d, want 200", rate.OrderedUnits)
	}
	// 100 capped + 50 = 150, not 160: the extra ten do not cover the fifty.
	if rate.ReceivedUnits != 150 {
		t.Errorf("received = %d, want 150; an over-delivery on one line does "+
			"not make up for a short one on another", rate.ReceivedUnits)
	}
	if rate.FillRate != 0.75 {
		t.Errorf("fill rate = %f, want 0.75", rate.FillRate)
	}
	if rate.OnTimeLines != 2 {
		t.Errorf("on time = %d, want 2", rate.OnTimeLines)
	}
}
