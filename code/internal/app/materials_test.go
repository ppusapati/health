package app_test

import (
	"context"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	empiv1 "github.com/ppusapati/health/code/gen/go/healthcare/empi/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/empi/v1/empiv1connect"
	materialsv1 "github.com/ppusapati/health/code/gen/go/healthcare/materials/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/materials/v1/materialsv1connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	"github.com/ppusapati/health/code/internal/app"
	"github.com/ppusapati/health/code/internal/identity_access/adapters/devauth"
	materialsapp "github.com/ppusapati/health/code/internal/materials/application"
	orgpostgres "github.com/ppusapati/health/code/internal/organization/adapters/postgres"
	orgdomain "github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
	platformapitransport "github.com/ppusapati/health/code/internal/platform_api/transport"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Materials, procurement and inventory (SRS-MAT-001 … 016), end to end.
//
// The domain tests hold the ledger arithmetic and the approval rules. These
// hold what only the assembled stack shows: that the balance a client reads is
// the ledger and not a maintained total, that an approval route is walked in
// order by people who actually hold the roles, that quarantined stock is on
// the shelf and not available, that a transfer conserves quantity through a
// real database, and that the four separations a stores audit turns on are
// permissions rather than convention.

type matHarness struct {
	pool      *pgxpool.Pool
	materials materialsv1connect.MaterialsServiceClient
	patients  empiv1connect.PatientServiceClient
	org       organizationv1connect.OrganizationServiceClient

	tenantID string
	facility string
}

func newMatHarness(t *testing.T) *matHarness {
	return newMatHarnessWith(t, materialsapp.Config{
		ExpiryHorizon: 90 * 24 * time.Hour,
	})
}

func newMatHarnessWith(t *testing.T, config materialsapp.Config) *matHarness {
	t.Helper()

	pool := pgtest.New(t)
	verifier, err := devauth.New(true)
	if err != nil {
		t.Fatalf("devauth.New: %v", err)
	}

	built := app.New(app.Deps{
		Pool: pool, Verifier: verifier,
		Build: platformapitransport.BuildInfo{Version: "test", Commit: "test", BuiltAt: "test"},
		RateLimit: platformtransport.RateLimitConfig{
			RequestsPerSecond: 10000, Burst: 10000,
			UnauthenticatedRequestsPerSecond: 10000, UnauthenticatedBurst: 10000,
		},
		Materials: config,
	})

	server := httptest.NewServer(h2c.NewHandler(built.Handler, &http2.Server{}))
	t.Cleanup(server.Close)

	h := &matHarness{
		pool:      pool,
		materials: materialsv1connect.NewMaterialsServiceClient(server.Client(), server.URL),
		patients:  empiv1connect.NewPatientServiceClient(server.Client(), server.URL),
		org:       organizationv1connect.NewOrganizationServiceClient(server.Client(), server.URL),
	}

	tenant, err := h.org.CreateTenant(context.Background(),
		as(platformOperatorToken(), &organizationv1.CreateTenantRequest{
			DisplayName: "Apollo Group", LegalJurisdiction: "IN",
			DefaultLocale: "en-IN", TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateTenant: %v", err)
	}
	h.tenantID = tenant.Msg.GetTenant().GetTenantId()

	facility, err := h.org.CreateFacility(context.Background(),
		as(tenantAdminToken(h.tenantID), &organizationv1.CreateFacilityRequest{
			Code: "main", DisplayName: "Main Hospital",
			Type:     organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL,
			TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateFacility: %v", err)
	}
	h.facility = facility.Msg.GetFacility().GetFacilityId()

	for _, module := range []string{"empi", "materials"} {
		h.entitle(t, module)
	}
	return h
}

func (h *matHarness) entitle(t *testing.T, module string) {
	t.Helper()

	repo := orgpostgres.New(pgtx.NewManager(h.pool))
	scope := authctx.NewSession(authctx.Session{
		SubjectID: "setup", TenantID: h.tenantID,
	}).TenantScope()

	now := time.Now().UTC()
	entitlement, err := orgdomain.NewEntitlement(uuid.NewString(), h.tenantID, "",
		module, true, now.Add(-time.Hour), time.Time{}, "setup", now)
	if err != nil {
		t.Fatalf("NewEntitlement: %v", err)
	}
	if err := repo.InsertEntitlement(context.Background(), scope, entitlement); err != nil {
		t.Fatalf("InsertEntitlement: %v", err)
	}
}

func (h *matHarness) storekeeperToken() string {
	return h.tenantID + ":stores-1:storekeeper:" + h.facility
}

func (h *matHarness) managerToken() string {
	return h.tenantID + ":manager-1:materials_manager:" + h.facility
}

func (h *matHarness) buyerToken() string {
	return h.tenantID + ":buyer-1:buyer:" + h.facility
}

func (h *matHarness) financeToken() string {
	return h.tenantID + ":finance-1:finance_admin:" + h.facility
}

func (h *matHarness) nurseToken() string {
	return h.tenantID + ":nurse-1:nurse:" + h.facility
}

func (h *matHarness) clerkToken() string {
	return h.tenantID + ":clerk-1:registration_clerk:" + h.facility
}

// item adds one line of the master.
func (h *matHarness) item(t *testing.T,
	req *materialsv1.AddItemRequest) *materialsv1.Item {

	t.Helper()
	out, err := h.materials.AddItem(context.Background(),
		withFacility(h.managerToken(), h.facility, req))
	if err != nil {
		t.Fatalf("AddItem(%s): %v", req.GetCode(), err)
	}
	return out.Msg.GetItem()
}

func (h *matHarness) glove(t *testing.T) *materialsv1.Item {
	return h.item(t, &materialsv1.AddItemRequest{
		Code: "GLOVE-M", Display: "Nitrile glove, medium",
		Category: "consumable", Uom: "piece",
		Tracking: materialsv1.Tracking_TRACKING_QUANTITY,
	})
}

func (h *matHarness) supplier(t *testing.T, approved bool) *materialsv1.Supplier {
	t.Helper()
	out, err := h.materials.AddSupplier(context.Background(),
		withFacility(h.managerToken(), h.facility, &materialsv1.AddSupplierRequest{
			Code: "ACME", Display: "Acme Surgical", Approved: approved,
			PaymentTermsDays: 30, Currency: "INR",
		}))
	if err != nil {
		t.Fatalf("AddSupplier: %v", err)
	}
	return out.Msg.GetSupplier()
}

// stockIn takes a delivery of an item into a store, through a real order.
func (h *matHarness) stockIn(t *testing.T, item *materialsv1.Item,
	supplier *materialsv1.Supplier, quantity int32, location string,
	lotCode string, expiry time.Time) *materialsv1.Receipt {

	t.Helper()
	ctx := context.Background()

	placed, err := h.materials.PlaceOrder(ctx,
		withFacility(h.buyerToken(), h.facility, &materialsv1.PlaceOrderRequest{
			Number: "PO-" + uuid.NewString()[:8], SupplierId: supplier.GetSupplierId(),
			Lines: []*materialsv1.PurchaseOrderLine{{
				ItemId: item.GetItemId(), Quantity: quantity, PackSize: 1,
				UnitPrice: &materialsv1.Money{Minor: 9_00, Currency: "INR"},
				DeliverBy: timestamppb.New(time.Now().Add(24 * time.Hour)),
			}},
			ToleranceOverPercent: 5, ToleranceShortPercent: 10,
		}))
	if err != nil {
		t.Fatalf("PlaceOrder: %v", err)
	}
	orderID := placed.Msg.GetOrder().GetPurchaseOrderId()

	if _, err := h.materials.IssueOrder(ctx,
		withFacility(h.buyerToken(), h.facility, &materialsv1.IssueOrderRequest{
			PurchaseOrderId: orderID,
		})); err != nil {
		t.Fatalf("IssueOrder: %v", err)
	}

	line := &materialsv1.ReceiptLine{
		ItemId: item.GetItemId(), QuantityReceived: quantity, LotCode: lotCode,
	}
	if !expiry.IsZero() {
		line.Expiry = timestamppb.New(expiry)
	}

	received, err := h.materials.ReceiveGoods(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.ReceiveGoodsRequest{
				PurchaseOrderId: orderID, Number: "GRN-" + uuid.NewString()[:8],
				LocationId: location, Lines: []*materialsv1.ReceiptLine{line},
			}))
	if err != nil {
		t.Fatalf("ReceiveGoods: %v", err)
	}
	return received.Msg.GetReceipt()
}

func (h *matHarness) available(t *testing.T, itemID, location string) int32 {
	t.Helper()
	out, err := h.materials.GetAvailable(context.Background(),
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.GetAvailableRequest{
				ItemId: itemID, LocationId: location,
			}))
	if err != nil {
		t.Fatalf("GetAvailable: %v", err)
	}
	return out.Msg.GetAvailable()
}

// onHand totals every status at a location, which is what a stocktake counts.
func (h *matHarness) onHand(t *testing.T, itemID, location string) int32 {
	t.Helper()
	out, err := h.materials.ListBalances(context.Background(),
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.ListBalancesRequest{
				LocationId: location, ItemId: itemID,
			}))
	if err != nil {
		t.Fatalf("ListBalances: %v", err)
	}
	total := int32(0)
	for _, balance := range out.Msg.GetBalances() {
		total += balance.GetQuantity()
	}
	return total
}

// SRS-MAT-004, SRS-MAT-005, SRS-MAT-007, SRS-MAT-008: a purchase reaches a
// patient, and the balance is the ledger the whole way.
func TestStockIsBoughtReceivedIssuedAndTheBalanceIsTheLedger(t *testing.T) {
	h := newMatHarness(t)
	ctx := context.Background()

	item := h.glove(t)
	supplier := h.supplier(t, true)
	h.stockIn(t, item, supplier, 500, "main-store", "", time.Time{})

	if got := h.available(t, item.GetItemId(), "main-store"); got != 500 {
		t.Fatalf("available after receipt = %d, want 500", got)
	}

	// Issue to a ward: the stock moves, it does not disappear.
	issued, err := h.materials.IssueStock(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.IssueStockRequest{
				ItemId: item.GetItemId(), FromLocation: "main-store",
				ToLocation: "ward-7", Quantity: 120, CostCentre: "CC-WARD7",
			}))
	if err != nil {
		t.Fatalf("IssueStock: %v", err)
	}
	if issued.Msg.GetShort() != 0 {
		t.Errorf("short = %d, want 0", issued.Msg.GetShort())
	}

	if got := h.available(t, item.GetItemId(), "main-store"); got != 380 {
		t.Errorf("main store = %d, want 380", got)
	}
	if got := h.available(t, item.GetItemId(), "ward-7"); got != 120 {
		t.Errorf("ward = %d, want 120", got)
	}

	// Consume on a patient: it leaves the hospital's stock.
	patientID := h.patient(t, "+91-98400-10001")
	consumed, err := h.materials.IssueStock(ctx,
		withFacility(h.nurseTokenWithIssue(), h.facility,
			&materialsv1.IssueStockRequest{
				ItemId: item.GetItemId(), FromLocation: "ward-7",
				Quantity: 20, CostCentre: "CC-WARD7", PatientId: patientID,
			}))
	if err != nil {
		t.Fatalf("IssueStock(consumption): %v", err)
	}
	if len(consumed.Msg.GetMovements()) != 1 {
		t.Fatalf("movements = %d, want 1", len(consumed.Msg.GetMovements()))
	}
	if consumed.Msg.GetMovements()[0].GetKind() !=
		materialsv1.MovementKind_MOVEMENT_KIND_CONSUMPTION {
		t.Errorf("kind = %v, want consumption",
			consumed.Msg.GetMovements()[0].GetKind())
	}

	if got := h.available(t, item.GetItemId(), "ward-7"); got != 100 {
		t.Errorf("ward after consumption = %d, want 100", got)
	}

	// Nothing was created or destroyed inside the hospital.
	inside := h.onHand(t, item.GetItemId(), "main-store") +
		h.onHand(t, item.GetItemId(), "ward-7")
	if inside != 480 {
		t.Errorf("stock inside the hospital = %d, want 480 (500 in, 20 out)",
			inside)
	}

	// And the ledger says the same thing the balances do.
	movements, err := h.materials.ListMovements(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.ListMovementsRequest{
				ItemId:      item.GetItemId(),
				PeriodStart: timestamppb.New(time.Now().Add(-time.Hour)),
				PeriodEnd:   timestamppb.New(time.Now().Add(time.Hour)),
			}))
	if err != nil {
		t.Fatalf("ListMovements: %v", err)
	}
	if len(movements.Msg.GetMovements()) != 3 {
		t.Errorf("movements = %d, want 3 (receipt, issue, consumption)",
			len(movements.Msg.GetMovements()))
	}
}

// nurseTokenWithIssue is a ward nurse who may issue stock. The nurse role does
// not hold mat.stock.issue — a ward does not run the store — so consumption at
// the bedside is recorded under the storekeeper's permission here rather than
// pretending the nurse holds one they do not.
func (h *matHarness) nurseTokenWithIssue() string {
	return h.storekeeperToken()
}

func (h *matHarness) patient(t *testing.T, phone string) string {
	t.Helper()
	registered, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterPatientRequest{
			Demographics: demographics("Nair", []string{"Vikram"},
				date(1968, 3, 14), empiv1.Sex_SEX_MALE, phone),
		}))
	if err != nil {
		t.Fatalf("RegisterPatient: %v", err)
	}
	return registered.Msg.GetPatient().GetPatientId()
}

// SRS-MAT-006: unaccepted stock is on the shelf and not available, and
// accepting it is a permission the receiver does not hold.
func TestInspectedStockIsCountedAndNotAvailableUntilSomebodyElseAcceptsIt(t *testing.T) {
	h := newMatHarness(t)
	ctx := context.Background()

	implant := h.item(t, &materialsv1.AddItemRequest{
		Code: "IMPL-HIP", Display: "Hip stem", Category: "implant",
		Uom: "each", Tracking: materialsv1.Tracking_TRACKING_SERIAL,
		InspectOnReceipt: true,
	})
	supplier := h.supplier(t, true)
	receipt := h.stockIn(t, implant, supplier, 1, "main-store", "SN-4410",
		time.Time{})

	if got := h.onHand(t, implant.GetItemId(), "main-store"); got != 1 {
		t.Errorf("on hand = %d, want 1; quarantined stock is on the shelf", got)
	}
	if got := h.available(t, implant.GetItemId(), "main-store"); got != 0 {
		t.Errorf("available = %d, want 0; unaccepted stock cannot become "+
			"available", got)
	}

	lots, err := h.materials.ListLots(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.ListLotsRequest{ItemId: implant.GetItemId()}))
	if err != nil {
		t.Fatalf("ListLots: %v", err)
	}
	if len(lots.Msg.GetLots()) != 1 {
		t.Fatalf("lots = %d, want 1", len(lots.Msg.GetLots()))
	}
	lotID := lots.Msg.GetLots()[0].GetLotId()
	_ = receipt

	// The storekeeper who took the delivery in cannot declare it fit.
	accept := &materialsv1.InspectRequest{
		LotId: lotID, LocationId: "main-store", Quantity: 1, Accept: true,
	}
	if _, err := h.materials.Inspect(ctx,
		withFacility(h.storekeeperToken(), h.facility, accept)); err == nil {
		t.Fatal("the storekeeper accepted their own delivery out of quarantine")
	}

	if _, err := h.materials.Inspect(ctx,
		withFacility(h.managerToken(), h.facility, accept)); err != nil {
		t.Fatalf("Inspect: %v", err)
	}
	if got := h.available(t, implant.GetItemId(), "main-store"); got != 1 {
		t.Errorf("available after acceptance = %d, want 1", got)
	}
}

// SRS-MAT-002: the route is walked in order, by people who hold the role.
func TestARequisitionWalksItsRouteInOrderAndNobodyApprovesTheirOwn(t *testing.T) {
	h := newMatHarness(t)
	ctx := context.Background()

	item := h.glove(t)

	for _, rule := range []*materialsv1.AddApprovalRuleRequest{
		{Roles: []string{"storekeeper"}},
		{MinimumValue: 5_000_00, Currency: "INR",
			Roles: []string{"materials_manager"}},
		{MinimumValue: 50_000_00, Currency: "INR",
			Roles: []string{"finance_admin"}},
	} {
		if _, err := h.materials.AddApprovalRule(ctx,
			withFacility(h.managerToken(), h.facility, rule)); err != nil {
			t.Fatalf("AddApprovalRule: %v", err)
		}
	}

	// 500 gloves at 12 rupees is 6,000: over the manager's threshold, under
	// finance's.
	raised, err := h.materials.RaiseRequisition(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.RaiseRequisitionRequest{
				Number: "REQ-001", FacilityId: h.facility,
				Source:     materialsv1.RequisitionSource_REQUISITION_SOURCE_MANUAL,
				NeedBy:     timestamppb.New(time.Now().Add(14 * 24 * time.Hour)),
				CostCentre: "CC-THEATRE",
				Lines: []*materialsv1.RequisitionLine{{
					ItemId: item.GetItemId(), Quantity: 500,
					EstimatedUnitPrice: &materialsv1.Money{
						Minor: 12_00, Currency: "INR",
					},
				}},
			}))
	if err != nil {
		t.Fatalf("RaiseRequisition: %v", err)
	}
	requisitionID := raised.Msg.GetRequisition().GetRequisitionId()

	route, err := h.materials.GetApprovalRoute(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.GetApprovalRouteRequest{RequisitionId: requisitionID}))
	if err != nil {
		t.Fatalf("GetApprovalRoute: %v", err)
	}
	if len(route.Msg.GetRoles()) != 2 ||
		route.Msg.GetRoles()[0] != "storekeeper" ||
		route.Msg.GetRoles()[1] != "materials_manager" {
		t.Fatalf("route = %v, want [storekeeper materials_manager]",
			route.Msg.GetRoles())
	}

	if _, err := h.materials.SubmitRequisition(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.SubmitRequisitionRequest{
				RequisitionId: requisitionID,
			})); err != nil {
		t.Fatalf("SubmitRequisition: %v", err)
	}

	// The manager cannot sign step one: the storekeeper would never see it.
	if _, err := h.materials.DecideRequisition(ctx,
		withFacility(h.managerToken(), h.facility,
			&materialsv1.DecideRequisitionRequest{
				RequisitionId: requisitionID,
				Decision:      materialsv1.ApprovalDecision_APPROVAL_DECISION_APPROVED,
				Role:          "materials_manager",
			})); err == nil {
		t.Fatal("the second approver signed first")
	}

	// The storekeeper raised it, so they cannot approve it — even though
	// their role is the one the route names first.
	if _, err := h.materials.DecideRequisition(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.DecideRequisitionRequest{
				RequisitionId: requisitionID,
				Decision:      materialsv1.ApprovalDecision_APPROVAL_DECISION_APPROVED,
				Role:          "storekeeper",
			})); err == nil {
		t.Fatal("the person who raised the requisition approved it")
	}

	// A second storekeeper can.
	otherStores := h.tenantID + ":stores-2:storekeeper:" + h.facility
	if _, err := h.materials.DecideRequisition(ctx,
		withFacility(otherStores, h.facility,
			&materialsv1.DecideRequisitionRequest{
				RequisitionId: requisitionID,
				Decision:      materialsv1.ApprovalDecision_APPROVAL_DECISION_APPROVED,
				Role:          "storekeeper", Note: "in budget",
			})); err != nil {
		t.Fatalf("first approval: %v", err)
	}

	// Nobody signs as a role they do not hold, whatever permission they have.
	if _, err := h.materials.DecideRequisition(ctx,
		withFacility(h.financeToken(), h.facility,
			&materialsv1.DecideRequisitionRequest{
				RequisitionId: requisitionID,
				Decision:      materialsv1.ApprovalDecision_APPROVAL_DECISION_APPROVED,
				Role:          "materials_manager",
			})); err == nil {
		t.Fatal("finance signed as the materials manager by typing the role")
	}

	decided, err := h.materials.DecideRequisition(ctx,
		withFacility(h.managerToken(), h.facility,
			&materialsv1.DecideRequisitionRequest{
				RequisitionId: requisitionID,
				Decision:      materialsv1.ApprovalDecision_APPROVAL_DECISION_APPROVED,
				Role:          "materials_manager",
			}))
	if err != nil {
		t.Fatalf("second approval: %v", err)
	}
	if decided.Msg.GetRequisition().GetState() !=
		materialsv1.RequisitionState_REQUISITION_STATE_APPROVED {
		t.Errorf("state = %v, want approved",
			decided.Msg.GetRequisition().GetState())
	}
	if len(decided.Msg.GetRequisition().GetApprovals()) != 2 {
		t.Errorf("chain = %d step(s), want 2",
			len(decided.Msg.GetRequisition().GetApprovals()))
	}
}

// SRS-MAT-002: a requisition nobody had to approve is a configuration gap.
func TestARequisitionWithNoConfiguredRouteCannotBeSubmitted(t *testing.T) {
	h := newMatHarness(t)
	item := h.glove(t)

	raised, err := h.materials.RaiseRequisition(context.Background(),
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.RaiseRequisitionRequest{
				NeedBy:     timestamppb.New(time.Now().Add(24 * time.Hour)),
				CostCentre: "CC-THEATRE",
				Lines: []*materialsv1.RequisitionLine{{
					ItemId: item.GetItemId(), Quantity: 10,
				}},
			}))
	if err != nil {
		t.Fatalf("RaiseRequisition: %v", err)
	}

	if _, err := h.materials.SubmitRequisition(context.Background(),
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.SubmitRequisitionRequest{
				RequisitionId: raised.Msg.GetRequisition().GetRequisitionId(),
			})); err == nil {
		t.Fatal("a requisition nobody had to approve was submitted; a " +
			"hospital would discover its rules were empty by reading an invoice")
	}
}

// SRS-MAT-003, SRS-MAT-004: unapproved suppliers are neither quoted nor
// ordered from, and a comparison normalises the pack size.
func TestQuotesAreNormalisedAndOnlyApprovedSuppliersAreOrderedFrom(t *testing.T) {
	h := newMatHarness(t)
	ctx := context.Background()

	item := h.glove(t)
	approved := h.supplier(t, true)

	unapproved, err := h.materials.AddSupplier(ctx,
		withFacility(h.managerToken(), h.facility,
			&materialsv1.AddSupplierRequest{
				Code: "NEWCO", Display: "Newco Supplies", Currency: "INR",
			}))
	if err != nil {
		t.Fatalf("AddSupplier: %v", err)
	}

	if _, err := h.materials.OpenRfq(ctx,
		withFacility(h.buyerToken(), h.facility, &materialsv1.OpenRfqRequest{
			SupplierIds: []string{unapproved.Msg.GetSupplier().GetSupplierId()},
			Lines: []*materialsv1.RequisitionLine{{
				ItemId: item.GetItemId(), Quantity: 500,
			}},
		})); err == nil {
		t.Fatal("an unapproved supplier was sent an RFQ")
	}

	if _, err := h.materials.PlaceOrder(ctx,
		withFacility(h.buyerToken(), h.facility, &materialsv1.PlaceOrderRequest{
			SupplierId: unapproved.Msg.GetSupplier().GetSupplierId(),
			Lines: []*materialsv1.PurchaseOrderLine{{
				ItemId: item.GetItemId(), Quantity: 5, PackSize: 100,
			}},
		})); err == nil {
		t.Fatal("an order was placed with an unapproved supplier")
	}

	// Approve a second supplier so there are two quotes to compare.
	second, err := h.materials.AddSupplier(ctx,
		withFacility(h.managerToken(), h.facility,
			&materialsv1.AddSupplierRequest{
				Code: "BETA", Display: "Beta Medical", Approved: true,
				Currency: "INR",
			}))
	if err != nil {
		t.Fatalf("AddSupplier: %v", err)
	}

	rfq, err := h.materials.OpenRfq(ctx,
		withFacility(h.buyerToken(), h.facility, &materialsv1.OpenRfqRequest{
			Number: "RFQ-001",
			SupplierIds: []string{
				approved.GetSupplierId(), second.Msg.GetSupplier().GetSupplierId(),
			},
			Lines: []*materialsv1.RequisitionLine{{
				ItemId: item.GetItemId(), Quantity: 500,
			}},
		}))
	if err != nil {
		t.Fatalf("OpenRfq: %v", err)
	}
	rfqID := rfq.Msg.GetRfq().GetRfqId()

	// Per box of a hundred: 900 each, plus 500 freight, over 500 pieces.
	if _, err := h.materials.RecordBid(ctx,
		withFacility(h.buyerToken(), h.facility, &materialsv1.RecordBidRequest{
			RfqId: rfqID, SupplierId: approved.GetSupplierId(),
			Lines: []*materialsv1.BidLine{{
				ItemId: item.GetItemId(), Quantity: 5, PackSize: 100,
				UnitPrice: &materialsv1.Money{Minor: 900_00, Currency: "INR"},
			}},
			FreightMinor: 500_00, LeadTimeDays: 7,
		})); err != nil {
		t.Fatalf("RecordBid: %v", err)
	}

	// Per piece: 8 each. Cheaper per piece, and a hundred times smaller per
	// line.
	if _, err := h.materials.RecordBid(ctx,
		withFacility(h.buyerToken(), h.facility, &materialsv1.RecordBidRequest{
			RfqId: rfqID, SupplierId: second.Msg.GetSupplier().GetSupplierId(),
			Lines: []*materialsv1.BidLine{{
				ItemId: item.GetItemId(), Quantity: 500, PackSize: 1,
				UnitPrice: &materialsv1.Money{Minor: 8_00, Currency: "INR"},
			}},
			LeadTimeDays: 21,
		})); err != nil {
		t.Fatalf("RecordBid: %v", err)
	}

	compared, err := h.materials.CompareBids(ctx,
		withFacility(h.buyerToken(), h.facility, &materialsv1.CompareBidsRequest{
			RfqId: rfqID,
		}))
	if err != nil {
		t.Fatalf("CompareBids: %v", err)
	}
	if len(compared.Msg.GetComparisons()) != 2 {
		t.Fatalf("comparisons = %d, want 2", len(compared.Msg.GetComparisons()))
	}

	byUnit := map[string]int64{}
	for _, comparison := range compared.Msg.GetComparisons() {
		byUnit[comparison.GetSupplierId()] = comparison.GetUnitMinor()
	}
	if byUnit[approved.GetSupplierId()] != 10_00 {
		t.Errorf("box quote = %d per piece, want 1000 minor units; without "+
			"the pack size it would read as 90,000",
			byUnit[approved.GetSupplierId()])
	}
	if byUnit[second.Msg.GetSupplier().GetSupplierId()] != 8_00 {
		t.Errorf("piece quote = %d per piece, want 800 minor units",
			byUnit[second.Msg.GetSupplier().GetSupplierId()])
	}
}

// SRS-MAT-005: over-receipt is refused and short receipt is recorded.
func TestOverReceiptIsRefusedAndShortReceiptIsRecorded(t *testing.T) {
	h := newMatHarness(t)
	ctx := context.Background()

	item := h.glove(t)
	supplier := h.supplier(t, true)

	placed, err := h.materials.PlaceOrder(ctx,
		withFacility(h.buyerToken(), h.facility, &materialsv1.PlaceOrderRequest{
			SupplierId: supplier.GetSupplierId(),
			Lines: []*materialsv1.PurchaseOrderLine{{
				ItemId: item.GetItemId(), Quantity: 500, PackSize: 1,
			}},
			ToleranceOverPercent: 5, ToleranceShortPercent: 10,
		}))
	if err != nil {
		t.Fatalf("PlaceOrder: %v", err)
	}
	orderID := placed.Msg.GetOrder().GetPurchaseOrderId()
	if _, err := h.materials.IssueOrder(ctx,
		withFacility(h.buyerToken(), h.facility, &materialsv1.IssueOrderRequest{
			PurchaseOrderId: orderID,
		})); err != nil {
		t.Fatalf("IssueOrder: %v", err)
	}

	if _, err := h.materials.ReceiveGoods(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.ReceiveGoodsRequest{
				PurchaseOrderId: orderID, LocationId: "main-store",
				Lines: []*materialsv1.ReceiptLine{{
					ItemId: item.GetItemId(), QuantityReceived: 530,
				}},
			})); err == nil {
		t.Fatal("an over-delivery beyond tolerance was accepted into the " +
			"ledger; somebody would be invoiced for it")
	}

	received, err := h.materials.ReceiveGoods(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.ReceiveGoodsRequest{
				PurchaseOrderId: orderID, LocationId: "main-store",
				Lines: []*materialsv1.ReceiptLine{{
					ItemId: item.GetItemId(), QuantityReceived: 400,
				}},
			}))
	if err != nil {
		t.Fatalf("a short delivery was refused: %v", err)
	}
	if len(received.Msg.GetShort()) != 1 {
		t.Errorf("short = %v, want one line reported", received.Msg.GetShort())
	}
	if got := h.available(t, item.GetItemId(), "main-store"); got != 400 {
		t.Errorf("available = %d, want 400; the goods are on the shelf "+
			"whatever the count says", got)
	}
}

// SRS-MAT-009, SRS-MAT-013: the pick follows the item's policy, and blocked
// and expired lots leave availability independently.
func TestThePickFollowsPolicyAndBlockedStockLeavesAvailability(t *testing.T) {
	h := newMatHarness(t)
	ctx := context.Background()

	suture := h.item(t, &materialsv1.AddItemRequest{
		Code: "SUT-30", Display: "Polyglactin 3-0", Category: "consumable",
		Uom: "piece", Tracking: materialsv1.Tracking_TRACKING_BATCH,
		Perishable: true,
	})
	supplier := h.supplier(t, true)

	// Two batches: one expiring sooner, received later.
	h.stockIn(t, suture, supplier, 50, "main-store", "B-LATE",
		time.Now().AddDate(0, 6, 0))
	h.stockIn(t, suture, supplier, 50, "main-store", "B-SOON",
		time.Now().AddDate(0, 1, 0))

	pick, err := h.materials.RecommendPick(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.RecommendPickRequest{
				ItemId: suture.GetItemId(), LocationId: "main-store",
				Quantity: 10,
			}))
	if err != nil {
		t.Fatalf("RecommendPick: %v", err)
	}
	if len(pick.Msg.GetPick().GetLines()) != 1 {
		t.Fatalf("pick = %d line(s), want 1", len(pick.Msg.GetPick().GetLines()))
	}
	if pick.Msg.GetPick().GetLines()[0].GetLotCode() != "B-SOON" {
		t.Errorf("FEFO picked %q, want the earliest expiry B-SOON",
			pick.Msg.GetPick().GetLines()[0].GetLotCode())
	}

	// Block the batch that would otherwise be picked.
	lots, err := h.materials.ListLots(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.ListLotsRequest{ItemId: suture.GetItemId()}))
	if err != nil {
		t.Fatalf("ListLots: %v", err)
	}
	var soonID string
	for _, lot := range lots.Msg.GetLots() {
		if lot.GetCode() == "B-SOON" {
			soonID = lot.GetLotId()
		}
	}
	if soonID == "" {
		t.Fatal("B-SOON was not found")
	}

	// A storekeeper cannot block: it tells every ward to stop using it.
	if _, err := h.materials.BlockLot(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.BlockLotRequest{
				LotId: soonID, Reason: "manufacturer recall",
			})); err == nil {
		t.Fatal("a storekeeper blocked a lot")
	}

	blocked, err := h.materials.BlockLot(ctx,
		withFacility(h.managerToken(), h.facility, &materialsv1.BlockLotRequest{
			LotId: soonID, Reason: "manufacturer recall, sterility",
		}))
	if err != nil {
		t.Fatalf("BlockLot: %v", err)
	}
	if blocked.Msg.GetLot().GetIssuable() {
		t.Error("a blocked lot reported itself issuable")
	}

	if got := h.available(t, suture.GetItemId(), "main-store"); got != 50 {
		t.Errorf("available after the block = %d, want 50", got)
	}
	// Blocked stock still exists: somebody has to go and get it.
	if got := h.onHand(t, suture.GetItemId(), "main-store"); got != 100 {
		t.Errorf("on hand = %d, want 100; blocked stock is still counted", got)
	}

	// The pick now takes the other batch and says why it skipped the first.
	after, err := h.materials.RecommendPick(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.RecommendPickRequest{
				ItemId: suture.GetItemId(), LocationId: "main-store",
				Quantity: 10,
			}))
	if err != nil {
		t.Fatalf("RecommendPick: %v", err)
	}
	if after.Msg.GetPick().GetLines()[0].GetLotCode() != "B-LATE" {
		t.Errorf("pick took %q, want B-LATE",
			after.Msg.GetPick().GetLines()[0].GetLotCode())
	}
	if len(after.Msg.GetPick().GetSkipped()) != 1 {
		t.Errorf("skipped = %v, want one reason; a storekeeper looking at a "+
			"full shelf needs to know why", after.Msg.GetPick().GetSkipped())
	}

	// The durable notice reaches the wards rather than a screen.
	var notices int
	if err := h.pool.QueryRow(ctx, `
		SELECT count(*) FROM platform_escalation.notice
		WHERE tenant_id = $1 AND subject_kind = 'materials_recall'`,
		h.tenantID).Scan(&notices); err != nil {
		t.Fatalf("notice query: %v", err)
	}
	if notices != 1 {
		t.Errorf("a blocked lot raised %d notice(s), want 1", notices)
	}
}

// SRS-MAT-013: a recall reaches the patients the lot was used on.
func TestARecallReachesThePatientsTheLotWasUsedOn(t *testing.T) {
	h := newMatHarness(t)
	ctx := context.Background()

	suture := h.item(t, &materialsv1.AddItemRequest{
		Code: "SUT-30", Category: "consumable", Uom: "piece",
		Tracking: materialsv1.Tracking_TRACKING_BATCH, Perishable: true,
	})
	supplier := h.supplier(t, true)
	h.stockIn(t, suture, supplier, 100, "main-store", "B-500",
		time.Now().AddDate(1, 0, 0))

	first := h.patient(t, "+91-98400-20001")
	second := h.patient(t, "+91-98400-20002")

	for _, use := range []struct {
		patient  string
		quantity int32
	}{{first, 2}, {second, 1}, {first, 3}} {
		if _, err := h.materials.IssueStock(ctx,
			withFacility(h.storekeeperToken(), h.facility,
				&materialsv1.IssueStockRequest{
					ItemId: suture.GetItemId(), FromLocation: "main-store",
					Quantity: use.quantity, CostCentre: "CC-THEATRE",
					PatientId: use.patient,
				})); err != nil {
			t.Fatalf("IssueStock: %v", err)
		}
	}

	lots, err := h.materials.ListLots(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.ListLotsRequest{ItemId: suture.GetItemId()}))
	if err != nil {
		t.Fatalf("ListLots: %v", err)
	}
	lotID := lots.Msg.GetLots()[0].GetLotId()

	blocked, err := h.materials.BlockLot(ctx,
		withFacility(h.managerToken(), h.facility, &materialsv1.BlockLotRequest{
			LotId: lotID, Reason: "field safety notice",
		}))
	if err != nil {
		t.Fatalf("BlockLot: %v", err)
	}

	recall := blocked.Msg.GetRecall()
	if len(recall.GetPatients()) != 2 {
		t.Errorf("recall reached %v, want two patients; one patient using "+
			"the lot twice is one patient to contact", recall.GetPatients())
	}
	if len(recall.GetConsumptions()) != 3 {
		t.Errorf("consumptions = %d, want 3", len(recall.GetConsumptions()))
	}
	if len(recall.GetHoldings()) != 1 ||
		recall.GetHoldings()[0].GetQuantity() != 94 {
		t.Errorf("holdings = %+v, want 94 still in the store",
			recall.GetHoldings())
	}
}

// SRS-MAT-010: a transfer conserves quantity through the in-transit state.
func TestATransferConservesQuantityAndAShortArrivalStaysInTransit(t *testing.T) {
	h := newMatHarness(t)
	ctx := context.Background()

	item := h.glove(t)
	supplier := h.supplier(t, true)
	h.stockIn(t, item, supplier, 300, "main-store", "", time.Time{})

	lots, err := h.materials.ListLots(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.ListLotsRequest{ItemId: item.GetItemId()}))
	if err != nil {
		t.Fatalf("ListLots: %v", err)
	}
	lotID := lots.Msg.GetLots()[0].GetLotId()

	dispatched, err := h.materials.DispatchTransfer(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.DispatchTransferRequest{
				Number: "TR-001", FromLocation: "main-store",
				ToLocation: "ward-7",
				Lines: []*materialsv1.TransferLine{{
					ItemId: item.GetItemId(), LotId: lotID, Quantity: 100,
				}},
				Reason: "ward top-up",
			}))
	if err != nil {
		t.Fatalf("DispatchTransfer: %v", err)
	}
	transferID := dispatched.Msg.GetTransfer().GetTransferId()

	// Mid-flight: the source has given it up, the destination cannot use it,
	// and the total inside the hospital has not changed.
	if got := h.available(t, item.GetItemId(), "main-store"); got != 200 {
		t.Errorf("source mid-flight = %d, want 200", got)
	}
	if got := h.available(t, item.GetItemId(), "ward-7"); got != 0 {
		t.Errorf("stock in transit was available at the destination (%d); it "+
			"is on a trolley somewhere", got)
	}
	total := h.onHand(t, item.GetItemId(), "main-store") +
		h.onHand(t, item.GetItemId(), "ward-7")
	if total != 300 {
		t.Errorf("mid-flight total = %d, want 300; nothing is ever nowhere",
			total)
	}

	// Ninety-eight arrive.
	received, err := h.materials.ReceiveTransfer(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.ReceiveTransferRequest{
				TransferId: transferID,
				Counted:    map[string]int32{item.GetItemId() + "/" + lotID: 98},
			}))
	if err != nil {
		t.Fatalf("ReceiveTransfer: %v", err)
	}
	if len(received.Msg.GetShort()) != 1 {
		t.Fatalf("short = %v, want one line", received.Msg.GetShort())
	}

	if got := h.available(t, item.GetItemId(), "ward-7"); got != 98 {
		t.Errorf("ward available = %d, want 98", got)
	}
	if got := h.onHand(t, item.GetItemId(), "ward-7"); got != 100 {
		t.Errorf("ward on hand = %d, want 100; two are still in transit and "+
			"the ledger should say so rather than lose them", got)
	}

	// Still conserved.
	total = h.onHand(t, item.GetItemId(), "main-store") +
		h.onHand(t, item.GetItemId(), "ward-7")
	if total != 300 {
		t.Errorf("total after the transfer = %d, want 300", total)
	}
}

// SRS-MAT-011: a count's variance needs a reason and somebody else's approval,
// and the adjustment moves the ledger.
func TestACountPostsItsAdjustmentOnlyWithSomebodyElsesApproval(t *testing.T) {
	h := newMatHarness(t)
	ctx := context.Background()

	item := h.glove(t)
	supplier := h.supplier(t, true)
	h.stockIn(t, item, supplier, 500, "main-store", "", time.Time{})

	opened, err := h.materials.OpenCount(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.OpenCountRequest{
				Number: "CNT-001", LocationId: "main-store", Cycle: true,
			}))
	if err != nil {
		t.Fatalf("OpenCount: %v", err)
	}
	countID := opened.Msg.GetCount().GetCountId()
	if len(opened.Msg.GetCount().GetLines()) != 1 {
		t.Fatalf("count lines = %d, want 1",
			len(opened.Msg.GetCount().GetLines()))
	}
	if opened.Msg.GetCount().GetLines()[0].GetExpected() != 500 {
		t.Errorf("expected = %d, want 500 frozen from the ledger",
			opened.Msg.GetCount().GetLines()[0].GetExpected())
	}
	lotID := opened.Msg.GetCount().GetLines()[0].GetLotId()

	// The shelf has 480, and the caller's own "expected" is ignored.
	recorded, err := h.materials.RecordCount(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.RecordCountRequest{
				CountId: countID,
				Lines: []*materialsv1.CountLine{{
					ItemId: item.GetItemId(), LotId: lotID,
					Expected: 480, Counted: 480,
					Reason: "damaged in store, written off",
				}},
			}))
	if err != nil {
		t.Fatalf("RecordCount: %v", err)
	}
	if recorded.Msg.GetCount().GetLines()[0].GetVariance() != -20 {
		t.Errorf("variance = %d, want -20; the expectation comes from the "+
			"count as opened, not from the caller",
			recorded.Msg.GetCount().GetLines()[0].GetVariance())
	}

	// Two separate controls, and this test exercises both. The permission
	// says only a manager may approve any count at all; the domain and the
	// database say that even a manager may not approve one they took. A test
	// that only covered the second would pass with the permission granted to
	// everybody, which is how the first one gets lost.
	//
	// First: a second storekeeper, who did not count, still cannot approve.
	otherStores := h.tenantID + ":stores-2:storekeeper:" + h.facility
	if _, err := h.materials.ApproveCount(ctx,
		withFacility(otherStores, h.facility,
			&materialsv1.ApproveCountRequest{CountId: countID})); err == nil {
		t.Fatal("a storekeeper approved a stocktake adjustment")
	}

	// Second: the person who counted cannot approve their own, whatever
	// permission they hold.
	if _, err := h.materials.ApproveCount(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.ApproveCountRequest{CountId: countID})); err == nil {
		t.Fatal("the person who counted approved their own adjustment")
	}

	approved, err := h.materials.ApproveCount(ctx,
		withFacility(h.managerToken(), h.facility,
			&materialsv1.ApproveCountRequest{
				CountId: countID, Note: "spot-checked",
			}))
	if err != nil {
		t.Fatalf("ApproveCount: %v", err)
	}
	if len(approved.Msg.GetAdjustments()) != 1 {
		t.Fatalf("adjustments = %d, want 1", len(approved.Msg.GetAdjustments()))
	}
	if got := h.available(t, item.GetItemId(), "main-store"); got != 480 {
		t.Errorf("available after the adjustment = %d, want 480", got)
	}
}

// SRS-MAT-014: the match finds the overcharge through the pack size.
func TestTheThreeWayMatchFindsAnOverchargeThroughThePackSize(t *testing.T) {
	h := newMatHarness(t)
	ctx := context.Background()

	item := h.glove(t)
	supplier := h.supplier(t, true)

	placed, err := h.materials.PlaceOrder(ctx,
		withFacility(h.buyerToken(), h.facility, &materialsv1.PlaceOrderRequest{
			SupplierId: supplier.GetSupplierId(),
			Lines: []*materialsv1.PurchaseOrderLine{{
				ItemId: item.GetItemId(), Quantity: 5, PackSize: 100,
				UnitPrice: &materialsv1.Money{Minor: 900_00, Currency: "INR"},
			}},
		}))
	if err != nil {
		t.Fatalf("PlaceOrder: %v", err)
	}
	orderID := placed.Msg.GetOrder().GetPurchaseOrderId()
	if _, err := h.materials.IssueOrder(ctx,
		withFacility(h.buyerToken(), h.facility, &materialsv1.IssueOrderRequest{
			PurchaseOrderId: orderID,
		})); err != nil {
		t.Fatalf("IssueOrder: %v", err)
	}
	if _, err := h.materials.ReceiveGoods(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.ReceiveGoodsRequest{
				PurchaseOrderId: orderID, LocationId: "main-store",
				Lines: []*materialsv1.ReceiptLine{{
					ItemId: item.GetItemId(), QuantityReceived: 500,
				}},
			})); err != nil {
		t.Fatalf("ReceiveGoods: %v", err)
	}

	// Ten rupees a piece rather than nine: a thousand rupees, invisible
	// unless the pack size is applied.
	invoice, err := h.materials.RecordInvoice(ctx,
		withFacility(h.buyerToken(), h.facility,
			&materialsv1.RecordInvoiceRequest{
				Number: "INV-001", SupplierId: supplier.GetSupplierId(),
				PurchaseOrderId: orderID,
				Lines: []*materialsv1.InvoiceLine{{
					ItemId: item.GetItemId(), Quantity: 500,
					UnitPrice: &materialsv1.Money{Minor: 10_00, Currency: "INR"},
				}},
			}))
	if err != nil {
		t.Fatalf("RecordInvoice: %v", err)
	}

	matched, err := h.materials.MatchInvoice(ctx,
		withFacility(h.buyerToken(), h.facility,
			&materialsv1.MatchInvoiceRequest{
				InvoiceId: invoice.Msg.GetInvoice().GetInvoiceId(),
			}))
	if err != nil {
		t.Fatalf("MatchInvoice: %v", err)
	}
	if matched.Msg.GetResult().GetMatched() {
		t.Fatal("an overcharge of a rupee a piece matched")
	}
	if matched.Msg.GetResult().GetLines()[0].GetStatus() !=
		materialsv1.MatchStatus_MATCH_STATUS_PRICE_MISMATCH {
		t.Errorf("status = %v, want a price mismatch",
			matched.Msg.GetResult().GetLines()[0].GetStatus())
	}
}

// SRS-MAT-016: consuming consignment stock raises the liability.
func TestConsumingConsignmentStockRaisesItsLiability(t *testing.T) {
	h := newMatHarnessWith(t, materialsapp.Config{
		ExpiryHorizon:                90 * 24 * time.Hour,
		RequirePatientForConsignment: true,
	})
	ctx := context.Background()

	implant := h.item(t, &materialsv1.AddItemRequest{
		Code: "IMPL-HIP", Display: "Hip stem", Category: "implant",
		Uom: "each", Tracking: materialsv1.Tracking_TRACKING_SERIAL,
		Consignable: true,
	})
	supplier := h.supplier(t, true)

	placed, err := h.materials.PlaceOrder(ctx,
		withFacility(h.buyerToken(), h.facility, &materialsv1.PlaceOrderRequest{
			SupplierId: supplier.GetSupplierId(),
			Lines: []*materialsv1.PurchaseOrderLine{{
				ItemId: implant.GetItemId(), Quantity: 1, PackSize: 1,
			}},
		}))
	if err != nil {
		t.Fatalf("PlaceOrder: %v", err)
	}
	orderID := placed.Msg.GetOrder().GetPurchaseOrderId()
	if _, err := h.materials.IssueOrder(ctx,
		withFacility(h.buyerToken(), h.facility, &materialsv1.IssueOrderRequest{
			PurchaseOrderId: orderID,
		})); err != nil {
		t.Fatalf("IssueOrder: %v", err)
	}
	if _, err := h.materials.ReceiveGoods(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.ReceiveGoodsRequest{
				PurchaseOrderId: orderID, LocationId: "theatre-store",
				Lines: []*materialsv1.ReceiptLine{{
					ItemId: implant.GetItemId(), QuantityReceived: 1,
					LotCode:   "SN-4410",
					Ownership: materialsv1.Ownership_OWNERSHIP_CONSIGNMENT,
				}},
			})); err != nil {
		t.Fatalf("ReceiveGoods: %v", err)
	}

	// Consignment stock with no patient is refused under this policy: the
	// supplier invoices against the case.
	if _, err := h.materials.IssueStock(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.IssueStockRequest{
				ItemId: implant.GetItemId(), FromLocation: "theatre-store",
				Quantity: 1, CostCentre: "CC-THEATRE",
			})); err == nil {
		t.Fatal("a consignment implant was used with no patient named; the " +
			"liability would reconcile to nothing")
	}

	patientID := h.patient(t, "+91-98400-30001")
	issued, err := h.materials.IssueStock(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.IssueStockRequest{
				ItemId: implant.GetItemId(), FromLocation: "theatre-store",
				Quantity: 1, CostCentre: "CC-THEATRE", PatientId: patientID,
			}))
	if err != nil {
		t.Fatalf("IssueStock: %v", err)
	}
	if len(issued.Msg.GetLiabilities()) != 1 {
		t.Fatalf("liabilities = %d, want 1; the hospital used a supplier's "+
			"implant and nobody will invoice for it",
			len(issued.Msg.GetLiabilities()))
	}
	liability := issued.Msg.GetLiabilities()[0]
	if liability.GetSupplierId() != supplier.GetSupplierId() ||
		liability.GetPatientId() != patientID {
		t.Errorf("liability = %+v", liability)
	}

	listed, err := h.materials.ListLiabilities(ctx,
		withFacility(h.managerToken(), h.facility,
			&materialsv1.ListLiabilitiesRequest{
				SupplierId:  supplier.GetSupplierId(),
				PeriodStart: timestamppb.New(time.Now().Add(-time.Hour)),
				PeriodEnd:   timestamppb.New(time.Now().Add(time.Hour)),
			}))
	if err != nil {
		t.Fatalf("ListLiabilities: %v", err)
	}
	if len(listed.Msg.GetLiabilities()) != 1 {
		t.Errorf("listed liabilities = %d, want 1",
			len(listed.Msg.GetLiabilities()))
	}
}

// SRS-MAT-012: alerts are derived, and the suggestion is reviewable rather
// than raised.
func TestAlertsAreDerivedAndTheReorderIsOnlySuggested(t *testing.T) {
	h := newMatHarness(t)
	ctx := context.Background()

	item := h.glove(t)
	supplier := h.supplier(t, true)
	h.stockIn(t, item, supplier, 40, "main-store", "", time.Time{})

	// Nothing configured raises nothing.
	before, err := h.materials.ListAlerts(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.ListAlertsRequest{LocationId: "main-store"}))
	if err != nil {
		t.Fatalf("ListAlerts: %v", err)
	}
	if len(before.Msg.GetAlerts()) != 0 {
		t.Errorf("alerts with no configured level = %d; an alert on every "+
			"item is an alert on none", len(before.Msg.GetAlerts()))
	}

	if _, err := h.materials.SetStockLevel(ctx,
		withFacility(h.managerToken(), h.facility,
			&materialsv1.SetStockLevelRequest{
				Level: &materialsv1.StockLevel{
					ItemId: item.GetItemId(), LocationId: "main-store",
					Minimum: 100, Maximum: 500,
				},
			})); err != nil {
		t.Fatalf("SetStockLevel: %v", err)
	}

	alerts, err := h.materials.ListAlerts(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.ListAlertsRequest{LocationId: "main-store"}))
	if err != nil {
		t.Fatalf("ListAlerts: %v", err)
	}
	if len(alerts.Msg.GetAlerts()) != 1 ||
		alerts.Msg.GetAlerts()[0].GetKind() !=
			materialsv1.AlertKind_ALERT_KIND_BELOW_MINIMUM {
		t.Fatalf("alerts = %+v, want one below-minimum", alerts.Msg.GetAlerts())
	}

	suggested, err := h.materials.SuggestOrder(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.SuggestOrderRequest{LocationId: "main-store"}))
	if err != nil {
		t.Fatalf("SuggestOrder: %v", err)
	}
	if len(suggested.Msg.GetLines()) != 1 ||
		suggested.Msg.GetLines()[0].GetQuantity() != 460 {
		t.Errorf("suggestion = %+v, want one line topping up to 500",
			suggested.Msg.GetLines())
	}

	// Nothing was ordered: the system proposes, a person raises.
	orders, err := h.materials.ListRequisitions(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.ListRequisitionsRequest{}))
	if err != nil {
		t.Fatalf("ListRequisitions: %v", err)
	}
	if len(orders.Msg.GetRequisitions()) != 0 {
		t.Errorf("a suggestion raised %d requisition(s); it would buy what "+
			"its own arithmetic decided", len(orders.Msg.GetRequisitions()))
	}
}

// SRS-MAT-015: the KPIs are derived from the ledger.
func TestTheInventoryKpisComeFromTheLedger(t *testing.T) {
	h := newMatHarness(t)
	ctx := context.Background()

	item := h.glove(t)
	supplier := h.supplier(t, true)
	h.stockIn(t, item, supplier, 1000, "main-store", "", time.Time{})

	if _, err := h.materials.IssueStock(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.IssueStockRequest{
				ItemId: item.GetItemId(), FromLocation: "main-store",
				Quantity: 300, CostCentre: "CC-WARD7",
			})); err != nil {
		t.Fatalf("IssueStock: %v", err)
	}

	// A storekeeper may not read the KPIs: they are the stores review's.
	period := &materialsv1.GetMetricsRequest{
		ItemId: item.GetItemId(), LocationId: "main-store",
		PeriodStart: timestamppb.New(time.Now().Add(-time.Hour)),
		PeriodEnd:   timestamppb.New(time.Now().Add(time.Hour)),
	}
	if _, err := h.materials.GetMetrics(ctx,
		withFacility(h.storekeeperToken(), h.facility, period)); err == nil {
		t.Fatal("a storekeeper read the inventory KPIs")
	}

	metrics, err := h.materials.GetMetrics(ctx,
		withFacility(h.managerToken(), h.facility, period))
	if err != nil {
		t.Fatalf("GetMetrics: %v", err)
	}
	got := metrics.Msg.GetMetrics()
	if got.GetConsumedUnits() != 300 {
		t.Errorf("consumed = %d, want 300", got.GetConsumedUnits())
	}
	if got.GetClosingOnHand() != 700 {
		t.Errorf("closing = %d, want 700", got.GetClosingOnHand())
	}
	if len(got.GetIncomplete()) != 0 {
		t.Errorf("a complete ledger reported gaps: %v", got.GetIncomplete())
	}
}

// A buyer never touches the ledger: the person who commits the money does not
// also confirm the goods arrived.
func TestABuyerCannotReceiveOrIssueStock(t *testing.T) {
	h := newMatHarness(t)
	ctx := context.Background()

	item := h.glove(t)
	supplier := h.supplier(t, true)
	h.stockIn(t, item, supplier, 100, "main-store", "", time.Time{})

	if _, err := h.materials.IssueStock(ctx,
		withFacility(h.buyerToken(), h.facility,
			&materialsv1.IssueStockRequest{
				ItemId: item.GetItemId(), FromLocation: "main-store",
				Quantity: 10, CostCentre: "CC-WARD7",
			})); err == nil {
		t.Error("a buyer issued stock")
	}

	if _, err := h.materials.OpenCount(ctx,
		withFacility(h.buyerToken(), h.facility,
			&materialsv1.OpenCountRequest{LocationId: "main-store"})); err == nil {
		t.Error("a buyer opened a stocktake")
	}
}

// SRS-MAT-008: stock issued against no cost centre is consumption nobody's
// budget carries.
func TestAnIssueNamesItsCostCentreAndItsPatientIsReal(t *testing.T) {
	h := newMatHarness(t)
	ctx := context.Background()

	item := h.glove(t)
	supplier := h.supplier(t, true)
	h.stockIn(t, item, supplier, 100, "main-store", "", time.Time{})

	if _, err := h.materials.IssueStock(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.IssueStockRequest{
				ItemId: item.GetItemId(), FromLocation: "main-store",
				Quantity: 10,
			})); err == nil {
		t.Error("stock was issued against no cost centre")
	}

	_, err := h.materials.IssueStock(ctx,
		withFacility(h.storekeeperToken(), h.facility,
			&materialsv1.IssueStockRequest{
				ItemId: item.GetItemId(), FromLocation: "main-store",
				Quantity: 10, CostCentre: "CC-WARD7",
				PatientId: uuid.NewString(),
			}))
	if err == nil {
		t.Fatal("stock was consumed on a patient nobody can resolve")
	}
	if !strings.Contains(strings.ToLower(err.Error()), "no such patient") {
		t.Errorf("error = %v, want it to say the patient is unknown", err)
	}
}

// Tenant isolation over the stores (Gate A2).
func TestAnotherTenantCannotReadStockOrOrders(t *testing.T) {
	h := newMatHarness(t)
	ctx := context.Background()

	item := h.glove(t)
	supplier := h.supplier(t, true)
	h.stockIn(t, item, supplier, 100, "main-store", "", time.Time{})

	other, err := h.org.CreateTenant(ctx,
		as(platformOperatorToken(), &organizationv1.CreateTenantRequest{
			DisplayName: "Fortis Group", LegalJurisdiction: "IN",
			DefaultLocale: "en-IN", TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateTenant: %v", err)
	}
	otherTenant := other.Msg.GetTenant().GetTenantId()

	repo := orgpostgres.New(pgtx.NewManager(h.pool))
	scope := authctx.NewSession(authctx.Session{
		SubjectID: "setup", TenantID: otherTenant,
	}).TenantScope()
	now := time.Now().UTC()
	entitlement, err := orgdomain.NewEntitlement(uuid.NewString(), otherTenant, "",
		"materials", true, now.Add(-time.Hour), time.Time{}, "setup", now)
	if err != nil {
		t.Fatalf("NewEntitlement: %v", err)
	}
	if err := repo.InsertEntitlement(ctx, scope, entitlement); err != nil {
		t.Fatalf("InsertEntitlement: %v", err)
	}

	intruder := otherTenant + ":manager-2:materials_manager"
	if _, err := h.materials.GetItem(ctx,
		as(intruder, &materialsv1.GetItemRequest{
			ItemId: item.GetItemId(),
		})); err == nil {
		t.Error("another tenant read an item")
	}

	balances, err := h.materials.ListBalances(ctx,
		as(intruder, &materialsv1.ListBalancesRequest{
			LocationId: "main-store",
		}))
	if err != nil {
		t.Fatalf("ListBalances: %v", err)
	}
	if len(balances.Msg.GetBalances()) != 0 {
		t.Errorf("another tenant read %d balance line(s)",
			len(balances.Msg.GetBalances()))
	}
}
