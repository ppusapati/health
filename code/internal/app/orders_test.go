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
	encounterv1 "github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1/encounterv1connect"
	ordersv1 "github.com/ppusapati/health/code/gen/go/healthcare/orders/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/orders/v1/ordersv1connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	"github.com/ppusapati/health/code/internal/app"
	"github.com/ppusapati/health/code/internal/identity_access/adapters/devauth"
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

// Orders and CPOE (SRS-ORD-001 … SRS-ORD-012).
//
// Two rules this file exists to prove.
//
// SRS-ORD-004's: a cancellation after the performing service has started is
// rejected and converted to a request the service answers. Something has
// happened in the physical world — a specimen drawn, a unit of blood issued —
// and an order that simply disappeared would leave it attributable to nobody.
//
// SRS-ORD-009's: a duplicate produces a warning showing the existing orders,
// "rather than arbitrary suppression". The system is wrong often enough to
// matter — a repeat potassium four hours later is a duplicate on a medical ward
// and correct management on a renal unit — so it reports and the clinician
// decides.

type ordHarness struct {
	pool       *pgxpool.Pool
	orders     ordersv1connect.OrderServiceClient
	encounters encounterv1connect.EncounterServiceClient
	patients   empiv1connect.PatientServiceClient
	org        organizationv1connect.OrganizationServiceClient
	tenantID   string
	facility   string
}

func newOrdHarness(t *testing.T) *ordHarness {
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
	})

	server := httptest.NewServer(h2c.NewHandler(built.Handler, &http2.Server{}))
	t.Cleanup(server.Close)

	h := &ordHarness{
		pool:       pool,
		orders:     ordersv1connect.NewOrderServiceClient(server.Client(), server.URL),
		encounters: encounterv1connect.NewEncounterServiceClient(server.Client(), server.URL),
		patients:   empiv1connect.NewPatientServiceClient(server.Client(), server.URL),
		org:        organizationv1connect.NewOrganizationServiceClient(server.Client(), server.URL),
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

	for _, module := range []string{"empi", "encounter", "orders"} {
		h.entitle(t, module)
	}
	return h
}

func (h *ordHarness) entitle(t *testing.T, module string) {
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

func (h *ordHarness) clinicianToken() string {
	return h.tenantID + ":doctor-1:clinician:" + h.facility
}

func (h *ordHarness) otherClinicianToken() string {
	return h.tenantID + ":doctor-2:clinician:" + h.facility
}

func (h *ordHarness) nurseToken() string {
	return h.tenantID + ":nurse-1:nurse:" + h.facility
}

func (h *ordHarness) clerkToken() string {
	return h.tenantID + ":clerk-1:registration_clerk:" + h.facility
}

func (h *ordHarness) himToken() string {
	return h.tenantID + ":him-1:him_officer:" + h.facility
}

// chart registers a patient and opens an encounter.
func (h *ordHarness) chart(t *testing.T, family, phone string) (string, string) {
	t.Helper()

	registered, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterPatientRequest{
			Demographics: demographics(family, []string{"Meera"},
				date(1971, 5, 9), empiv1.Sex_SEX_FEMALE, phone),
		}))
	if err != nil {
		t.Fatalf("RegisterPatient: %v", err)
	}
	patient := registered.Msg.GetPatient().GetPatientId()

	opened, err := h.encounters.OpenEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&encounterv1.OpenEncounterRequest{
				PatientId: patient, FacilityId: h.facility,
				Class:               encounterv1.EncounterClass_ENCOUNTER_CLASS_INPATIENT,
				AttendingProviderId: "doctor-1", Reason: "chest pain",
				StartImmediately: true,
			}))
	if err != nil {
		t.Fatalf("OpenEncounter: %v", err)
	}
	return patient, opened.Msg.GetEncounter().GetEncounterId()
}

func ordCode(system, code, display string) *ordersv1.Coding {
	return &ordersv1.Coding{
		System: system, Version: "2.76", Code: code, Display: display,
	}
}

func potassiumCode() *ordersv1.Coding {
	return ordCode("http://loinc.org", "2823-3", "Potassium")
}

// place is the common path: a laboratory order for a potassium.
func (h *ordHarness) place(t *testing.T, token, patient, encounter,
	acknowledge string) *ordersv1.PlaceOrderResponse {

	t.Helper()
	placed, err := h.orders.PlaceOrder(context.Background(),
		withFacility(token, h.facility, &ordersv1.PlaceOrderRequest{
			Type:      ordersv1.OrderType_ORDER_TYPE_LABORATORY,
			PatientId: patient, EncounterId: encounter,
			Code:                  potassiumCode(),
			Priority:              ordersv1.Priority_PRIORITY_ROUTINE,
			AcknowledgeDuplicates: acknowledge,
		}))
	if err != nil {
		t.Fatalf("PlaceOrder: %v", err)
	}
	return placed.Msg
}

// SRS-ORD-001: one framework, and the order carries everything the requirement
// names — including a target service derived from its type.
func TestAPlacedOrderCarriesItsIdentityAndRoutesItself(t *testing.T) {
	h := newOrdHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	order := h.place(t, h.clinicianToken(), patient, encounter, "").GetOrder()
	if order == nil {
		t.Fatal("nothing was placed")
	}
	if order.GetNumber() == "" || !strings.HasPrefix(order.GetNumber(), "ORD-") {
		t.Fatalf("the order number is %q", order.GetNumber())
	}
	// A caller that could name its own target could route a blood-product order
	// to the kitchen.
	if order.GetTargetService() != "laboratory" {
		t.Fatalf("a laboratory order routes to %q", order.GetTargetService())
	}
	if order.GetStatus() != ordersv1.OrderStatus_ORDER_STATUS_REQUESTED {
		t.Fatalf("a placed order is %v", order.GetStatus())
	}
	if order.GetRequesterId() != "doctor-1" {
		t.Fatalf("the requester is %q", order.GetRequesterId())
	}
}

// SRS-ORD-006: the performing service hears about the order on the bus rather
// than by reading the orders schema.
func TestPlacingAnOrderDispatchesItToItsService(t *testing.T) {
	h := newOrdHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	order := h.place(t, h.clinicianToken(), patient, encounter, "").GetOrder()

	var payload string
	if err := h.pool.QueryRow(context.Background(),
		`SELECT payload::text FROM platform_data.outbox_event
		 WHERE aggregate_id = $1 AND event_type = 'order.dispatched.laboratory'`,
		order.GetOrderId()).Scan(&payload); err != nil {
		t.Fatalf("no dispatch was written for the laboratory: %v", err)
	}
	if !strings.Contains(payload, "2823-3") {
		t.Fatalf("the dispatch does not carry what to do: %s", payload)
	}

	// And the lifecycle event, which is a different contract for a different
	// audience (SRS-ORD-011).
	var placedCount int
	if err := h.pool.QueryRow(context.Background(),
		`SELECT count(*) FROM platform_data.outbox_event
		 WHERE aggregate_id = $1 AND event_type = 'order.placed'`,
		order.GetOrderId()).Scan(&placedCount); err != nil {
		t.Fatalf("counting order.placed: %v", err)
	}
	if placedCount != 1 {
		t.Fatalf("%d order.placed events, want 1", placedCount)
	}
}

// SRS-ORD-008: the dispatch carries explicit times, not a rule the receiver
// has to interpret — and they are the ward's clock, not UTC.
func TestTheDispatchCarriesNormalisedTimesInTheWardsZone(t *testing.T) {
	h := newOrdHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	placed, err := h.orders.PlaceOrder(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &ordersv1.PlaceOrderRequest{
			Type:      ordersv1.OrderType_ORDER_TYPE_NURSING,
			PatientId: patient, EncounterId: encounter,
			Code: ordCode("http://snomed.info/sct", "46973005",
				"Blood pressure taking"),
			Priority: ordersv1.Priority_PRIORITY_ROUTINE,
			Timing: &ordersv1.Timing{
				StartAt: timestamppb.New(time.Now().UTC()),
				EndAt:   timestamppb.New(time.Now().UTC().Add(24 * time.Hour)),
				// 06:00 and 18:00 on the ward.
				TimesOfDay: []int32{6 * 60, 18 * 60},
			},
		}))
	if err != nil {
		t.Fatalf("PlaceOrder: %v", err)
	}

	var payload string
	if err := h.pool.QueryRow(context.Background(),
		`SELECT payload::text FROM platform_data.outbox_event
		 WHERE aggregate_id = $1 AND event_type = 'order.dispatched.nursing'`,
		placed.Msg.GetOrder().GetOrderId()).Scan(&payload); err != nil {
		t.Fatalf("no dispatch for nursing: %v", err)
	}
	// Kolkata is UTC+5:30, so 06:00 on the ward is 00:30 UTC. A schedule
	// computed in UTC would show 06:00Z and put the dose an hour out twice a
	// year.
	if !strings.Contains(payload, "T00:30:00Z") &&
		!strings.Contains(payload, "T12:30:00Z") {
		t.Fatalf("the dispatch times are not in the ward's zone: %s", payload)
	}
}

// SRS-ORD-007: a required indication blocks submit, and the refusal names the
// field rather than making a client parse a sentence.
func TestAnImagingOrderWithoutAnIndicationIsRefusedByField(t *testing.T) {
	h := newOrdHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	_, err := h.orders.PlaceOrder(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &ordersv1.PlaceOrderRequest{
			Type:      ordersv1.OrderType_ORDER_TYPE_IMAGING,
			PatientId: patient, EncounterId: encounter,
			Code: ordCode("http://snomed.info/sct", "399208008",
				"Plain chest X-ray"),
			Priority: ordersv1.Priority_PRIORITY_ROUTINE,
		}))
	if err == nil {
		t.Fatal("an imaging order with no indication was placed")
	}
	if !strings.Contains(err.Error(), "indication") {
		t.Fatalf("the refusal does not name the field: %v", err)
	}

	if _, err := h.orders.PlaceOrder(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &ordersv1.PlaceOrderRequest{
			Type:      ordersv1.OrderType_ORDER_TYPE_IMAGING,
			PatientId: patient, EncounterId: encounter,
			Code: ordCode("http://snomed.info/sct", "399208008",
				"Plain chest X-ray"),
			Indication: "persistent cough, query pneumonia",
			Priority:   ordersv1.Priority_PRIORITY_ROUTINE,
		})); err != nil {
		t.Fatalf("an imaging order with an indication was refused: %v", err)
	}
}

// SRS-ORD-009: a warning showing the existing orders, and nothing suppressed.
func TestADuplicateWarnsWithTheExistingOrderAndPlacesNothing(t *testing.T) {
	h := newOrdHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	first := h.place(t, h.clinicianToken(), patient, encounter, "").GetOrder()

	// A second potassium for the same patient, an hour later.
	second := h.place(t, h.otherClinicianToken(), patient, encounter, "")
	if second.GetOrder() != nil {
		t.Fatal("a duplicate was placed without a warning")
	}
	warning := second.GetWarning()
	if warning == nil {
		t.Fatal("a repeat potassium produced no warning")
	}
	// "A duplicate exists" without saying which one is a warning nobody can act
	// on.
	if len(warning.GetExisting()) != 1 ||
		warning.GetExisting()[0].GetOrderId() != first.GetOrderId() {
		t.Fatalf("the warning does not show the existing order: %+v",
			warning.GetExisting())
	}
	if !warning.GetOverridable() {
		t.Fatal("the duplicate is not overridable; the requirement forbids " +
			"arbitrary suppression")
	}

	// Nothing was written: the patient still has one order.
	listed, err := h.orders.ListOrders(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &ordersv1.ListOrdersRequest{
			PatientId: patient,
		}))
	if err != nil {
		t.Fatalf("ListOrders: %v", err)
	}
	if len(listed.Msg.GetOrders()) != 1 {
		t.Fatalf("%d orders exist after a warned duplicate, want 1",
			len(listed.Msg.GetOrders()))
	}
}

// The clinician reviews and proceeds, and what they overrode is recorded.
func TestAcknowledgingADuplicatePlacesItAndRecordsWhatWasOverridden(t *testing.T) {
	h := newOrdHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	first := h.place(t, h.clinicianToken(), patient, encounter, "").GetOrder()
	second := h.place(t, h.otherClinicianToken(), patient, encounter,
		"repeat requested by the renal team").GetOrder()

	if second == nil {
		t.Fatal("an acknowledged duplicate was not placed")
	}
	override := second.GetDuplicateOverride()
	if override == nil {
		t.Fatal("the override was not recorded on the order")
	}
	// Stored rather than recomputed: the first order usually completes
	// afterwards, and a recomputing report would show every override as having
	// overridden nothing.
	if len(override.GetAgainstOrderIds()) != 1 ||
		override.GetAgainstOrderIds()[0] != first.GetOrderId() {
		t.Fatalf("the override does not name what it overrode: %+v", override)
	}
	if override.GetBy() != "doctor-2" {
		t.Fatalf("the override names %q", override.GetBy())
	}
}

// A completed order is not a duplicate: the patient may well need the test
// again, and warning about last week's bloods is how a warning becomes noise.
func TestAFinishedOrderDoesNotWarn(t *testing.T) {
	h := newOrdHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	first := h.place(t, h.clinicianToken(), patient, encounter, "").GetOrder()
	h.advance(t, first.GetOrderId(), "laboratory", "d-1",
		ordersv1.OrderStatus_ORDER_STATUS_ACCEPTED, "")
	h.advance(t, first.GetOrderId(), "laboratory", "d-2",
		ordersv1.OrderStatus_ORDER_STATUS_IN_PROGRESS, "")
	h.advance(t, first.GetOrderId(), "laboratory", "d-3",
		ordersv1.OrderStatus_ORDER_STATUS_COMPLETED, "")

	second := h.place(t, h.otherClinicianToken(), patient, encounter, "")
	if second.GetWarning() != nil {
		t.Fatal("a completed order was reported as a duplicate")
	}
	if second.GetOrder() == nil {
		t.Fatal("the repeat was not placed")
	}
}

// advance applies a performing service's acknowledgement.
func (h *ordHarness) advance(t *testing.T, orderID, service, delivery string,
	status ordersv1.OrderStatus, reason string) *ordersv1.Order {

	t.Helper()
	// The laboratory's service account, which holds acknowledge and cannot
	// place (SRS-ORD-006).
	token := h.tenantID + ":" + service + "-svc:performing_service:" + h.facility
	acked, err := h.orders.AcknowledgeOrder(context.Background(),
		withFacility(token, h.facility, &ordersv1.AcknowledgeOrderRequest{
			OrderId: orderID, Service: service, DeliveryId: delivery,
			Status: status, Reason: reason, PerformerId: "analyser-3",
			OccurredAt: timestamppb.New(time.Now().UTC()),
		}))
	if err != nil {
		t.Fatalf("AcknowledgeOrder(%v): %v", status, err)
	}
	return acked.Msg.GetOrder()
}

// SRS-ORD-006: the same delivery applied twice changes nothing and emits
// nothing.
func TestAReplayedAcknowledgementIsANoOp(t *testing.T) {
	h := newOrdHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	order := h.place(t, h.clinicianToken(), patient, encounter, "").GetOrder()

	h.advance(t, order.GetOrderId(), "laboratory", "delivery-1",
		ordersv1.OrderStatus_ORDER_STATUS_ACCEPTED, "")
	// The bus redelivers. An at-least-once bus is the only kind anybody can
	// build.
	again := h.advance(t, order.GetOrderId(), "laboratory", "delivery-1",
		ordersv1.OrderStatus_ORDER_STATUS_ACCEPTED, "")

	if again.GetStatus() != ordersv1.OrderStatus_ORDER_STATUS_ACCEPTED {
		t.Fatalf("the replay moved the order to %v", again.GetStatus())
	}
	if len(again.GetHistory()) != 2 {
		t.Fatalf("history holds %d entries, want 2 (placed, accepted)",
			len(again.GetHistory()))
	}

	var accepted int
	if err := h.pool.QueryRow(context.Background(),
		`SELECT count(*) FROM platform_data.outbox_event
		 WHERE aggregate_id = $1 AND event_type = 'order.accepted'`,
		order.GetOrderId()).Scan(&accepted); err != nil {
		t.Fatalf("counting order.accepted: %v", err)
	}
	if accepted != 1 {
		t.Fatalf("%d order.accepted events after a redelivery, want 1", accepted)
	}
}

// SRS-ORD-006: the case that actually bites. A bus redelivers an old
// acknowledgement after the order has moved on, and without the delivery key
// that reaches the domain as an impossible transition — an error the consumer
// retries forever.
func TestAStaleRedeliveryIsANoOpRatherThanAnError(t *testing.T) {
	h := newOrdHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	order := h.place(t, h.clinicianToken(), patient, encounter, "").GetOrder()

	h.advance(t, order.GetOrderId(), "laboratory", "delivery-1",
		ordersv1.OrderStatus_ORDER_STATUS_ACCEPTED, "")
	h.advance(t, order.GetOrderId(), "laboratory", "delivery-2",
		ordersv1.OrderStatus_ORDER_STATUS_IN_PROGRESS, "")

	// delivery-1 arrives again, saying "accepted", long after the order started.
	// in_progress → accepted is not a legal transition, so the only thing that
	// makes this survivable is recognising the delivery.
	replayed := h.advance(t, order.GetOrderId(), "laboratory", "delivery-1",
		ordersv1.OrderStatus_ORDER_STATUS_ACCEPTED, "")

	if replayed.GetStatus() != ordersv1.OrderStatus_ORDER_STATUS_IN_PROGRESS {
		t.Fatalf("a stale redelivery moved the order to %v", replayed.GetStatus())
	}
	if len(replayed.GetHistory()) != 3 {
		t.Fatalf("history holds %d entries, want 3 (placed, accepted, started)",
			len(replayed.GetHistory()))
	}
}

// A new delivery carrying an impossible transition is a real error, not a
// replay: the delivery key is what tells the two apart.
func TestANewDeliveryWithAnImpossibleTransitionIsRefused(t *testing.T) {
	h := newOrdHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	order := h.place(t, h.clinicianToken(), patient, encounter, "").GetOrder()

	h.advance(t, order.GetOrderId(), "laboratory", "delivery-1",
		ordersv1.OrderStatus_ORDER_STATUS_ACCEPTED, "")
	h.advance(t, order.GetOrderId(), "laboratory", "delivery-2",
		ordersv1.OrderStatus_ORDER_STATUS_IN_PROGRESS, "")

	token := h.tenantID + ":laboratory-svc:performing_service:" + h.facility
	_, err := h.orders.AcknowledgeOrder(context.Background(),
		withFacility(token, h.facility, &ordersv1.AcknowledgeOrderRequest{
			OrderId: order.GetOrderId(), Service: "laboratory",
			DeliveryId:  "delivery-3",
			Status:      ordersv1.OrderStatus_ORDER_STATUS_ACCEPTED,
			PerformerId: "analyser-3",
		}))
	if err == nil {
		t.Fatal("a genuinely impossible transition was accepted")
	}
}

// The kitchen acknowledging a laboratory order is either a routing bug or an
// attempt to move somebody else's work.
func TestAServiceCannotAcknowledgeAnotherServicesOrder(t *testing.T) {
	h := newOrdHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	order := h.place(t, h.clinicianToken(), patient, encounter, "").GetOrder()

	token := h.tenantID + ":dietetics-svc:performing_service:" + h.facility
	_, err := h.orders.AcknowledgeOrder(context.Background(),
		withFacility(token, h.facility, &ordersv1.AcknowledgeOrderRequest{
			OrderId: order.GetOrderId(), Service: "dietetics",
			DeliveryId:  "delivery-1",
			Status:      ordersv1.OrderStatus_ORDER_STATUS_ACCEPTED,
			PerformerId: "kitchen-1",
		}))
	if err == nil {
		t.Fatal("the kitchen accepted a laboratory order")
	}
}

// SRS-ORD-004: cancelling before execution withdraws the order.
func TestAnUnstartedOrderIsCancelledOutright(t *testing.T) {
	h := newOrdHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	order := h.place(t, h.clinicianToken(), patient, encounter, "").GetOrder()

	cancelled, err := h.orders.CancelOrder(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &ordersv1.CancelOrderRequest{
			OrderId: order.GetOrderId(), Reason: "no longer needed",
		}))
	if err != nil {
		t.Fatalf("CancelOrder: %v", err)
	}
	if cancelled.Msg.GetCancellationRequested() {
		t.Fatal("an unstarted order produced a cancellation request")
	}
	if cancelled.Msg.GetOrder().GetStatus() !=
		ordersv1.OrderStatus_ORDER_STATUS_CANCELLED {
		t.Fatalf("status is %v, want cancelled",
			cancelled.Msg.GetOrder().GetStatus())
	}
}

// SRS-ORD-004: after the specimen is drawn, the cancellation becomes a request
// and the order does not pretend to have stopped.
func TestCancellingAnExecutingOrderBecomesARequestTheServiceAnswers(t *testing.T) {
	h := newOrdHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	order := h.place(t, h.clinicianToken(), patient, encounter, "").GetOrder()

	h.advance(t, order.GetOrderId(), "laboratory", "d-1",
		ordersv1.OrderStatus_ORDER_STATUS_ACCEPTED, "")
	// The specimen has been drawn.
	h.advance(t, order.GetOrderId(), "laboratory", "d-2",
		ordersv1.OrderStatus_ORDER_STATUS_IN_PROGRESS, "")

	cancelled, err := h.orders.CancelOrder(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &ordersv1.CancelOrderRequest{
			OrderId: order.GetOrderId(), Reason: "patient discharged",
		}))
	if err != nil {
		t.Fatalf("CancelOrder: %v", err)
	}
	if !cancelled.Msg.GetCancellationRequested() {
		t.Fatal("an executing order was cancelled outright; the specimen is " +
			"already drawn")
	}
	// Showing it as cancelled while the laboratory is still running the test
	// would tell the ward the wrong thing.
	if cancelled.Msg.GetOrder().GetStatus() !=
		ordersv1.OrderStatus_ORDER_STATUS_IN_PROGRESS {
		t.Fatalf("the request moved the order to %v",
			cancelled.Msg.GetOrder().GetStatus())
	}
	if cancelled.Msg.GetOrder().GetCancellationRequestedAt() == nil {
		t.Fatal("the pending cancellation is not visible on the order")
	}

	// The request reaches the service that has to act on it.
	var payload string
	if err := h.pool.QueryRow(context.Background(),
		`SELECT payload::text FROM platform_data.outbox_event
		 WHERE aggregate_id = $1
		   AND event_type = 'order.cancellation_requested'`,
		order.GetOrderId()).Scan(&payload); err != nil {
		t.Fatalf("no cancellation request was emitted: %v", err)
	}

	// And the laboratory answers it.
	answered := h.advance(t, order.GetOrderId(), "laboratory", "d-3",
		ordersv1.OrderStatus_ORDER_STATUS_COMPLETED, "")
	if answered.GetStatus() != ordersv1.OrderStatus_ORDER_STATUS_COMPLETED {
		t.Fatalf("the laboratory could not answer the request: %v",
			answered.GetStatus())
	}
}

// A cancelled order and one placed on the wrong patient are different facts,
// and the second is health information management's call.
func TestRetractingIsSeparateFromCancellingAndIsHIMsCall(t *testing.T) {
	h := newOrdHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	order := h.place(t, h.clinicianToken(), patient, encounter, "").GetOrder()

	// A clinician cannot say a record was never true.
	if _, err := h.orders.RetractOrder(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&ordersv1.RetractOrderRequest{
				OrderId: order.GetOrderId(),
				Reason:  "placed on the wrong patient",
			})); err == nil {
		t.Fatal("a clinician retracted an order")
	}

	retracted, err := h.orders.RetractOrder(context.Background(),
		withFacility(h.himToken(), h.facility, &ordersv1.RetractOrderRequest{
			OrderId: order.GetOrderId(), Reason: "placed on the wrong patient",
		}))
	if err != nil {
		t.Fatalf("RetractOrder: %v", err)
	}
	if retracted.Msg.GetOrder().GetStatus() !=
		ordersv1.OrderStatus_ORDER_STATUS_ENTERED_IN_ERROR {
		t.Fatalf("status is %v", retracted.Msg.GetOrder().GetStatus())
	}
}

// SRS-ORD-002: the requester privilege, and a nurse who may not place at all.
func TestABloodProductOrderNeedsItsOwnPrivilege(t *testing.T) {
	h := newOrdHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	request := func(token string) error {
		_, err := h.orders.PlaceOrder(context.Background(),
			withFacility(token, h.facility, &ordersv1.PlaceOrderRequest{
				Type:      ordersv1.OrderType_ORDER_TYPE_BLOOD_PRODUCT,
				PatientId: patient, EncounterId: encounter,
				Code: ordCode("http://snomed.info/sct", "256395009",
					"Packed red blood cells"),
				Indication: "haemoglobin 62 g/L, symptomatic",
				Priority:   ordersv1.Priority_PRIORITY_URGENT,
			}))
		return err
	}

	// A clinician holds it.
	if err := request(h.clinicianToken()); err != nil {
		t.Fatalf("a clinician could not order blood: %v", err)
	}
	// A nurse does not place orders at all: a verbal order is recorded under
	// the doctor's name through the entered-by field.
	if err := request(h.nurseToken()); err == nil {
		t.Fatal("a nurse placed a blood-product order")
	}
}

// SRS-ORD-003: individually selectable components, mandatory ones come anyway,
// and the set's version travels as provenance.
func TestAnOrderSetPlacesWhatWasSelectedAndStampsItsVersion(t *testing.T) {
	h := newOrdHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	defined, err := h.orders.DefineOrderSet(context.Background(),
		as(tenantAdminToken(h.tenantID), &ordersv1.DefineOrderSetRequest{
			Set: &ordersv1.OrderSet{
				Version: "4", Name: "Chest pain admission",
				Specialty: "cardiology",
				Components: []*ordersv1.Component{
					{
						ComponentId:       "c-troponin",
						Type:              ordersv1.OrderType_ORDER_TYPE_LABORATORY,
						Code:              ordCode("http://loinc.org", "42757-5", "Troponin T"),
						Priority:          ordersv1.Priority_PRIORITY_URGENT,
						SelectedByDefault: true,
					},
					{
						ComponentId: "c-ecg",
						Type:        ordersv1.OrderType_ORDER_TYPE_PROCEDURE,
						Code: ordCode("http://snomed.info/sct", "29303009",
							"Electrocardiogram"),
						Indication: "chest pain",
						Priority:   ordersv1.Priority_PRIORITY_URGENT,
						// A twelve-lead ECG in a chest-pain pathway is not
						// optional.
						SelectedByDefault: true, Mandatory: true,
					},
					{
						ComponentId: "c-cxr",
						Type:        ordersv1.OrderType_ORDER_TYPE_IMAGING,
						Code: ordCode("http://snomed.info/sct", "399208008",
							"Plain chest X-ray"),
						Indication: "chest pain",
						Priority:   ordersv1.Priority_PRIORITY_ROUTINE,
					},
				},
			},
		}))
	if err != nil {
		t.Fatalf("DefineOrderSet: %v", err)
	}
	set := defined.Msg.GetSet()

	// The clinician ticks only the troponin.
	placed, err := h.orders.PlaceFromOrderSet(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&ordersv1.PlaceFromOrderSetRequest{
				SetId: set.GetSetId(), SetVersion: "4",
				PatientId: patient, EncounterId: encounter,
				Selections: []*ordersv1.Selection{{ComponentId: "c-troponin"}},
			}))
	if err != nil {
		t.Fatalf("PlaceFromOrderSet: %v", err)
	}

	orders := placed.Msg.GetPlaced()
	if len(orders) != 2 {
		t.Fatalf("the set placed %d orders, want 2 (troponin + mandatory ECG)",
			len(orders))
	}
	got := map[string]bool{}
	for _, o := range orders {
		got[o.GetCode().GetCode()] = true
		// A set edited afterwards must not restate what was ordered.
		if o.GetOrderSetVersion() != "4" {
			t.Fatalf("an order carries set version %q", o.GetOrderSetVersion())
		}
	}
	if !got["42757-5"] || !got["29303009"] {
		t.Fatalf("the wrong components were placed: %v", got)
	}
	if got["399208008"] {
		t.Fatal("an unticked component was placed; a set that places everything " +
			"is a set clinicians stop using")
	}
}

// SRS-ORD-012: a favourite is pre-filled values, and the policy still applies.
func TestAFavouriteCannotBypassAMandatoryIndication(t *testing.T) {
	h := newOrdHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	// Saved with no indication — before the tenant made them mandatory, or
	// simply carelessly.
	saved, err := h.orders.SaveFavourite(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&ordersv1.SaveFavouriteRequest{
				Favourite: &ordersv1.Favourite{
					Name: "My routine chest film",
					Type: ordersv1.OrderType_ORDER_TYPE_IMAGING,
					Code: ordCode("http://snomed.info/sct", "399208008",
						"Plain chest X-ray"),
					Priority: ordersv1.Priority_PRIORITY_ROUTINE,
				},
			}))
	if err != nil {
		t.Fatalf("SaveFavourite: %v", err)
	}
	favourite := saved.Msg.GetFavourite().GetFavouriteId()

	_, err = h.orders.PlaceFromFavourite(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&ordersv1.PlaceFromFavouriteRequest{
				FavouriteId: favourite,
				PatientId:   patient, EncounterId: encounter,
			}))
	if err == nil {
		t.Fatal("a favourite bypassed the mandatory indication")
	}
	if !strings.Contains(err.Error(), "indication") {
		t.Fatalf("the refusal does not name the field: %v", err)
	}

	// Supplying the indication at placement works: the favourite is a starting
	// point, not a template.
	if _, err := h.orders.PlaceFromFavourite(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&ordersv1.PlaceFromFavouriteRequest{
				FavouriteId: favourite,
				PatientId:   patient, EncounterId: encounter,
				Indication: "persistent cough",
			})); err != nil {
		t.Fatalf("a favourite with an indication was refused: %v", err)
	}
}

// A favourite is never shared: a shared shortcut with no review is an order set
// that escaped governance.
func TestAFavouriteBelongsToOneClinician(t *testing.T) {
	h := newOrdHarness(t)

	saved, err := h.orders.SaveFavourite(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&ordersv1.SaveFavouriteRequest{
				Favourite: &ordersv1.Favourite{
					Name: "Routine bloods",
					Type: ordersv1.OrderType_ORDER_TYPE_LABORATORY,
					Code: potassiumCode(),
				},
			}))
	if err != nil {
		t.Fatalf("SaveFavourite: %v", err)
	}

	// The other clinician does not see it.
	listed, err := h.orders.ListFavourites(context.Background(),
		withFacility(h.otherClinicianToken(), h.facility,
			&ordersv1.ListFavouritesRequest{}))
	if err != nil {
		t.Fatalf("ListFavourites: %v", err)
	}
	if len(listed.Msg.GetFavourites()) != 0 {
		t.Fatalf("a colleague sees %d of somebody else's favourites",
			len(listed.Msg.GetFavourites()))
	}

	// And cannot place from it. Not-found rather than forbidden: a probe must
	// not be able to confirm that a colleague has one.
	_, err = h.orders.PlaceFromFavourite(context.Background(),
		withFacility(h.otherClinicianToken(), h.facility,
			&ordersv1.PlaceFromFavouriteRequest{
				FavouriteId: saved.Msg.GetFavourite().GetFavouriteId(),
			}))
	if err == nil {
		t.Fatal("a colleague placed from somebody else's favourite")
	}
	if !strings.Contains(strings.ToLower(err.Error()), "not_found") {
		t.Fatalf("the refusal confirms the favourite exists: %v", err)
	}
}

// SRS-ORD-009's rules are configurable, and turning the window off stops the
// warning.
func TestATenantCanRetuneTheDuplicateRule(t *testing.T) {
	h := newOrdHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	if _, err := h.orders.SetDuplicateRule(context.Background(),
		as(tenantAdminToken(h.tenantID), &ordersv1.SetDuplicateRuleRequest{
			Type: ordersv1.OrderType_ORDER_TYPE_LABORATORY,
			// A renal unit repeats potassiums deliberately.
			WithinSeconds: 0,
		})); err != nil {
		t.Fatalf("SetDuplicateRule: %v", err)
	}

	h.place(t, h.clinicianToken(), patient, encounter, "")
	second := h.place(t, h.otherClinicianToken(), patient, encounter, "")
	if second.GetWarning() != nil {
		t.Fatal("a duplicate warned after the rule was turned off")
	}
	if second.GetOrder() == nil {
		t.Fatal("the second order was not placed")
	}
}

// A closed encounter takes no new orders: one placed against it is an order
// nobody will perform and nobody can bill.
func TestAClosedEncounterTakesNoNewOrders(t *testing.T) {
	h := newOrdHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	if _, err := h.encounters.CancelEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&encounterv1.CancelEncounterRequest{
				EncounterId: encounter, Reason: "opened on the wrong patient",
			})); err != nil {
		t.Fatalf("CancelEncounter: %v", err)
	}

	_, err := h.orders.PlaceOrder(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &ordersv1.PlaceOrderRequest{
			Type:      ordersv1.OrderType_ORDER_TYPE_LABORATORY,
			PatientId: patient, EncounterId: encounter,
			Code: potassiumCode(),
		}))
	if err == nil {
		t.Fatal("a cancelled encounter accepted an order")
	}
}

// SRS-ORD-006: the performing service's worklist, most urgent first.
func TestTheWorklistShowsAServicesOutstandingWorkMostUrgentFirst(t *testing.T) {
	h := newOrdHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")

	placeWith := func(code string, priority ordersv1.Priority) {
		t.Helper()
		if _, err := h.orders.PlaceOrder(context.Background(),
			withFacility(h.clinicianToken(), h.facility,
				&ordersv1.PlaceOrderRequest{
					Type:      ordersv1.OrderType_ORDER_TYPE_LABORATORY,
					PatientId: patient, EncounterId: encounter,
					Code:     ordCode("http://loinc.org", code, "A test"),
					Priority: priority,
				})); err != nil {
			t.Fatalf("PlaceOrder: %v", err)
		}
	}
	placeWith("1111-1", ordersv1.Priority_PRIORITY_ROUTINE)
	placeWith("2222-2", ordersv1.Priority_PRIORITY_STAT)

	// A diet order that must not appear on the laboratory's list.
	if _, err := h.orders.PlaceOrder(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &ordersv1.PlaceOrderRequest{
			Type:      ordersv1.OrderType_ORDER_TYPE_DIET,
			PatientId: patient, EncounterId: encounter,
			Code: ordCode("http://snomed.info/sct", "182922004", "Nil by mouth"),
		})); err != nil {
		t.Fatalf("PlaceOrder: %v", err)
	}

	worklist, err := h.orders.GetWorklist(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &ordersv1.GetWorklistRequest{
			Service: "laboratory",
		}))
	if err != nil {
		t.Fatalf("GetWorklist: %v", err)
	}
	orders := worklist.Msg.GetOrders()
	if len(orders) != 2 {
		t.Fatalf("the laboratory worklist holds %d orders, want 2", len(orders))
	}
	if orders[0].GetPriority() != ordersv1.Priority_PRIORITY_STAT {
		t.Fatal("the stat order is not first")
	}
}

// SRS-ORD-011: the events carry identifiers and codes, and no clinical
// reasoning — an event stream is read by more systems and under fewer controls
// than the record it describes.
func TestTheOrderEventsCarryNoClinicalReasoning(t *testing.T) {
	h := newOrdHarness(t)
	patient, encounter := h.chart(t, "Venkataraghavan", "9876543210")

	placed, err := h.orders.PlaceOrder(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &ordersv1.PlaceOrderRequest{
			Type:      ordersv1.OrderType_ORDER_TYPE_IMAGING,
			PatientId: patient, EncounterId: encounter,
			Code: ordCode("http://snomed.info/sct", "399208008",
				"Plain chest X-ray"),
			Indication: "query metastatic disease",
			Priority:   ordersv1.Priority_PRIORITY_ROUTINE,
		}))
	if err != nil {
		t.Fatalf("PlaceOrder: %v", err)
	}

	var payload string
	if err := h.pool.QueryRow(context.Background(),
		`SELECT payload::text FROM platform_data.outbox_event
		 WHERE aggregate_id = $1 AND event_type = 'order.placed'`,
		placed.Msg.GetOrder().GetOrderId()).Scan(&payload); err != nil {
		t.Fatalf("no order.placed event: %v", err)
	}
	// The indication is the sentence that says what the clinician suspects.
	if strings.Contains(payload, "metastatic") ||
		strings.Contains(payload, "Venkataraghavan") {
		t.Fatalf("the event carries clinical reasoning or a name: %s", payload)
	}
	if !strings.Contains(payload, "399208008") {
		t.Fatalf("the event does not say what was ordered: %s", payload)
	}
}

// An order cannot be read across a tenant boundary.
func TestAnOrderCannotBeReachedFromAnotherTenant(t *testing.T) {
	h := newOrdHarness(t)
	patient, encounter := h.chart(t, "Iyer", "9876543210")
	order := h.place(t, h.clinicianToken(), patient, encounter, "").GetOrder()

	other := newOrdHarness(t)
	_, err := other.orders.GetOrder(context.Background(),
		withFacility(other.clinicianToken(), other.facility,
			&ordersv1.GetOrderRequest{OrderId: order.GetOrderId()}))
	if err == nil {
		t.Fatal("another tenant's order is readable")
	}
	// NOT_FOUND rather than PERMISSION_DENIED: a probe must not be able to
	// confirm that an identifier exists in somebody else's tenant.
	if !strings.Contains(strings.ToLower(err.Error()), "not_found") &&
		!strings.Contains(strings.ToLower(err.Error()), "no such") {
		t.Fatalf("the refusal confirms the order exists elsewhere: %v", err)
	}
}
