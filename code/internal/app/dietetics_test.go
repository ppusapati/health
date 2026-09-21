package app_test

import (
	"context"
	"net/http/httptest"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	clinicalv1 "github.com/ppusapati/health/code/gen/go/healthcare/clinical/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/clinical/v1/clinicalv1connect"
	empiv1 "github.com/ppusapati/health/code/gen/go/healthcare/empi/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/empi/v1/empiv1connect"
	encounterv1 "github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1/encounterv1connect"
	dietv1 "github.com/ppusapati/health/code/gen/go/healthcare/hospital_ops_diet/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/hospital_ops_diet/v1/hospitalopsdietv1connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	"github.com/ppusapati/health/code/internal/app"
	dietapp "github.com/ppusapati/health/code/internal/dietetics/application"
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

// Dietetics and kitchen operations (SRS-DIET-001 … 009), end to end.
//
// The domain tests hold the rules and the repository tests hold the schema.
// These hold what only the assembled stack shows: that a diet order is
// checked against the allergies a clinician actually recorded rather than a
// copy this context keeps, that the kitchen cannot see an order with an
// unresolved conflict, that the person who placed the order is not the person
// who overrules the allergy — and, the one this family exists for, that a
// patient made nil by mouth after the census was taken does not get the tray
// that was already plated for them.

type dietHarness struct {
	pool       *pgxpool.Pool
	diet       hospitalopsdietv1connect.DietServiceClient
	clinical   clinicalv1connect.ClinicalServiceClient
	encounters encounterv1connect.EncounterServiceClient
	patients   empiv1connect.PatientServiceClient
	org        organizationv1connect.OrganizationServiceClient

	tenantID string
	facility string
}

func newDietHarness(t *testing.T) *dietHarness {
	t.Helper()

	pool := pgtest.New(t)
	verifier, err := devauth.New(true)
	if err != nil {
		t.Fatalf("devauth.New: %v", err)
	}

	built := app.New(app.Deps{
		Pool: pool, Verifier: verifier,
		Build: platformapitransport.BuildInfo{
			Version: "test", Commit: "test", BuiltAt: "test",
		},
		RateLimit: platformtransport.RateLimitConfig{
			RequestsPerSecond: 10000, Burst: 10000,
			UnauthenticatedRequestsPerSecond: 10000,
			UnauthenticatedBurst:             10000,
		},
		Dietetics: dietapp.Config{
			MealWindow:                  3 * time.Hour,
			MissedMealsBeforeEscalation: 2,
			SupportOrderContexts:        []string{"medication", "orders"},
		},
	})
	if built.Err != nil {
		t.Fatalf("app.New: %v", built.Err)
	}

	server := httptest.NewServer(h2c.NewHandler(built.Handler, &http2.Server{}))
	t.Cleanup(server.Close)

	h := &dietHarness{
		pool: pool,
		diet: hospitalopsdietv1connect.NewDietServiceClient(
			server.Client(), server.URL),
		clinical: clinicalv1connect.NewClinicalServiceClient(
			server.Client(), server.URL),
		encounters: encounterv1connect.NewEncounterServiceClient(
			server.Client(), server.URL),
		patients: empiv1connect.NewPatientServiceClient(
			server.Client(), server.URL),
		org: organizationv1connect.NewOrganizationServiceClient(
			server.Client(), server.URL),
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

	for _, module := range []string{
		"hospital_ops_diet", "empi", "encounter", "clinical",
	} {
		h.entitleDiet(t, module)
	}
	return h
}

func (h *dietHarness) entitleDiet(t *testing.T, module string) {
	t.Helper()

	repo := orgpostgres.New(pgtx.NewManager(h.pool))
	scope := authctx.NewSession(authctx.Session{
		SubjectID: "setup", TenantID: h.tenantID,
	}).TenantScope()

	now := time.Now().UTC()
	entitlement, err := orgdomain.NewEntitlement(uuid.NewString(), h.tenantID,
		"", module, true, now.Add(-time.Hour), time.Time{}, "setup", now)
	if err != nil {
		t.Fatalf("NewEntitlement: %v", err)
	}
	if err := repo.InsertEntitlement(context.Background(), scope,
		entitlement); err != nil {
		t.Fatalf("InsertEntitlement: %v", err)
	}
}

func (h *dietHarness) dietitianToken() string {
	return h.tenantID + ":diet-1:dietitian:" + h.facility
}

func (h *dietHarness) kitchenToken() string {
	return h.tenantID + ":kitchen-1:kitchen_staff:" + h.facility
}

func (h *dietHarness) doctorToken() string {
	return h.tenantID + ":doctor-1:clinician:" + h.facility
}

func (h *dietHarness) nurseToken() string {
	return h.tenantID + ":nurse-1:nurse:" + h.facility
}

func (h *dietHarness) clerkToken() string {
	return h.tenantID + ":clerk-1:registration_clerk:" + h.facility
}

// patient registers somebody and opens an inpatient encounter.
func (h *dietHarness) patient(t *testing.T, family, phone string) (
	string, string) {

	t.Helper()

	registered, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility,
			&empiv1.RegisterPatientRequest{
				Demographics: demographics(family, []string{"Meera"},
					date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, phone),
			}))
	if err != nil {
		t.Fatalf("RegisterPatient: %v", err)
	}
	patient := registered.Msg.GetPatient().GetPatientId()

	opened, err := h.encounters.OpenEncounter(context.Background(),
		withFacility(h.doctorToken(), h.facility,
			&encounterv1.OpenEncounterRequest{
				PatientId: patient, FacilityId: h.facility,
				Class:               encounterv1.EncounterClass_ENCOUNTER_CLASS_INPATIENT,
				AttendingProviderId: "doctor-1", Reason: "pneumonia",
				StartImmediately: true,
			}))
	if err != nil {
		t.Fatalf("OpenEncounter: %v", err)
	}
	return patient, opened.Msg.GetEncounter().GetEncounterId()
}

// kitchenSetUp configures the items, a recipe and the menu the conflict check
// and the forecast read.
func (h *dietHarness) kitchenSetUp(t *testing.T) {
	t.Helper()
	ctx := context.Background()

	for _, item := range []struct {
		code, name, kind string
		allergens        []string
	}{
		{"OATS", "Rolled oats", "ingredient", nil},
		{"MILK", "Milk", "ingredient", []string{"SCT-3718001"}},
		{"ONS-PEANUT", "Peanut-based supplement", "supplement",
			[]string{"SCT-256349002"}},
	} {
		if _, err := h.diet.ConfigureItem(ctx,
			withFacility(h.kitchenToken(), h.facility,
				&dietv1.ConfigureItemRequest{
					Item: &dietv1.DietItem{
						Code: item.code, Name: item.name,
						AllergenCodes: item.allergens,
					},
					Kind: item.kind,
				})); err != nil {
			t.Fatalf("ConfigureItem: %v", err)
		}
	}

	recipe := &dietv1.Recipe{
		Code: "R-100", Name: "Porridge",
		Ingredients: []*dietv1.IngredientQuantity{
			{Code: "OATS", Name: "Rolled oats", Grams: 60},
			{Code: "MILK", Name: "Milk", Grams: 200},
		},
	}
	if _, err := h.diet.ConfigureRecipe(ctx,
		withFacility(h.kitchenToken(), h.facility,
			&dietv1.ConfigureRecipeRequest{Recipe: recipe})); err != nil {
		t.Fatalf("ConfigureRecipe: %v", err)
	}
	if _, err := h.diet.ConfigureMenuItem(ctx,
		withFacility(h.kitchenToken(), h.facility,
			&dietv1.ConfigureMenuItemRequest{
				Item: &dietv1.MenuItem{
					Cycle:       dietv1.MealCycle_MEAL_CYCLE_BREAKFAST,
					TextureCode: "IDDSI-7", Recipe: recipe, Portions: 1,
				},
			})); err != nil {
		t.Fatalf("ConfigureMenuItem: %v", err)
	}
}

// orderRequest is a normal-texture oral diet on ward 4.
func (h *dietHarness) orderRequest(patient, encounter string,
	from time.Time) *dietv1.PlaceDietOrderRequest {

	return &dietv1.PlaceDietOrderRequest{
		PatientId: patient, EncounterId: encounter,
		FacilityId: h.facility, WardId: "ward-4", BedId: "b12",
		Route: dietv1.Route_ROUTE_ORAL,
		Texture: &dietv1.Texture{
			Code: "IDDSI-7", Label: "Regular", FluidCode: "IDDSI-0",
		},
		EffectiveFrom: timestamppb.New(from),
	}
}

// SRS-DIET-002, SRS-DIET-003. A diet order is checked against the allergies a
// clinician actually recorded, and the kitchen never sees a pending one.
func TestADietOrderIsCheckedAgainstTheClinicalAllergyList(t *testing.T) {
	h := newDietHarness(t)
	ctx := context.Background()

	h.kitchenSetUp(t)
	patient, encounter := h.patient(t, "Iyer", "9876543210")

	// The allergy is recorded in the clinical context, where it belongs.
	if _, err := h.clinical.RecordAllergy(ctx,
		withFacility(h.doctorToken(), h.facility,
			&clinicalv1.RecordAllergyRequest{
				PatientId: patient, EncounterId: encounter,
				Substance: &clinicalv1.Coding{
					System: "SCT", Version: "2026",
					Code: "SCT-256349002", Display: "Peanut",
				},
				Kind:         clinicalv1.AllergyKind_ALLERGY_KIND_ALLERGY,
				Criticality:  clinicalv1.AllergyCriticality_ALLERGY_CRITICALITY_HIGH,
				Verification: clinicalv1.AllergyVerification_ALLERGY_VERIFICATION_CONFIRMED,
			})); err != nil {
		t.Fatalf("RecordAllergy: %v", err)
	}

	// An order naming the peanut supplement clashes with it, and comes back
	// pending rather than active.
	request := h.orderRequest(patient, encounter, time.Now().UTC())
	request.Supplements = []string{"ONS-PEANUT"}
	placed, err := h.diet.PlaceDietOrder(ctx,
		withFacility(h.dietitianToken(), h.facility, request))
	if err != nil {
		t.Fatalf("PlaceDietOrder: %v", err)
	}
	order := placed.Msg.GetOrder()
	if order.GetState() != dietv1.OrderState_ORDER_STATE_PENDING {
		t.Fatalf("state = %v, want pending", order.GetState())
	}
	if len(order.GetConflicts()) != 1 {
		t.Fatalf("conflicts = %+v, want the peanut supplement",
			order.GetConflicts())
	}
	if order.GetConflicts()[0].GetSeverity() == "" {
		t.Fatal("a conflict with no severity leaves the person resolving " +
			"it unable to tell an anaphylaxis from an intolerance")
	}

	// The kitchen's read never returns it.
	current, err := h.diet.GetCurrentDietOrder(ctx,
		withFacility(h.dietitianToken(), h.facility,
			&dietv1.GetCurrentDietOrderRequest{PatientId: patient}))
	if err != nil {
		t.Fatalf("GetCurrentDietOrder: %v", err)
	}
	if current.Msg.GetFound() {
		t.Fatal("an order with an open allergy conflict reached the kitchen")
	}

	// The dietitian who placed it cannot overrule the allergy.
	_, err = h.diet.ResolveConflict(ctx,
		withFacility(h.dietitianToken(), h.facility,
			&dietv1.ResolveConflictRequest{
				OrderId:    order.GetOrderId(),
				AllergyRef: order.GetConflicts()[0].GetAllergyRef(),
				Note:       "she says it was only the shell",
			}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("the dietitian overruled the allergy: %v", err)
	}
	// Nor can the kitchen.
	_, err = h.diet.ResolveConflict(ctx,
		withFacility(h.kitchenToken(), h.facility,
			&dietv1.ResolveConflictRequest{
				OrderId:    order.GetOrderId(),
				AllergyRef: order.GetConflicts()[0].GetAllergyRef(),
				Note:       "looks fine",
			}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("the kitchen overruled the allergy: %v", err)
	}

	// A clinician can, with a reason that an investigation would read.
	resolved, err := h.diet.ResolveConflict(ctx,
		withFacility(h.doctorToken(), h.facility,
			&dietv1.ResolveConflictRequest{
				OrderId:    order.GetOrderId(),
				AllergyRef: order.GetConflicts()[0].GetAllergyRef(),
				Note:       "challenge tested negative in clinic on 12 August",
			}))
	if err != nil {
		t.Fatalf("ResolveConflict: %v", err)
	}
	if resolved.Msg.GetOrder().GetState() !=
		dietv1.OrderState_ORDER_STATE_ACTIVE {
		t.Fatalf("state = %v, want active", resolved.Msg.GetOrder().GetState())
	}

	current, err = h.diet.GetCurrentDietOrder(ctx,
		withFacility(h.dietitianToken(), h.facility,
			&dietv1.GetCurrentDietOrderRequest{PatientId: patient}))
	if err != nil {
		t.Fatalf("GetCurrentDietOrder: %v", err)
	}
	if !current.Msg.GetFound() {
		t.Fatal("a resolved order still does not reach the kitchen")
	}
}

// SRS-DIET-009. The order in force is re-read when the tray leaves the
// kitchen, so a patient made nil by mouth after the census does not get the
// tray that was already plated for them.
func TestATrayIsCheckedAgainstTheOrderInForceWhenItLeavesTheKitchen(
	t *testing.T) {

	h := newDietHarness(t)
	ctx := context.Background()

	h.kitchenSetUp(t)
	patient, encounter := h.patient(t, "Rao", "9876543211")

	if _, err := h.diet.PlaceDietOrder(ctx,
		withFacility(h.dietitianToken(), h.facility,
			h.orderRequest(patient, encounter,
				time.Now().UTC().Add(-time.Hour)))); err != nil {
		t.Fatalf("PlaceDietOrder: %v", err)
	}

	census := h.frozenCensus(t)
	if len(census.GetLines()) != 1 {
		t.Fatalf("census = %+v, want the one oral patient", census.GetLines())
	}

	plated, err := h.diet.PlateTrays(ctx,
		withFacility(h.kitchenToken(), h.facility,
			&dietv1.PlateTraysRequest{CensusId: census.GetCensusId()}))
	if err != nil {
		t.Fatalf("PlateTrays: %v", err)
	}
	if len(plated.Msg.GetTrays()) != 1 {
		t.Fatalf("plated %d trays", len(plated.Msg.GetTrays()))
	}
	tray := plated.Msg.GetTrays()[0]

	// Plating the same census twice is two meals counted for one patient.
	again, err := h.diet.PlateTrays(ctx,
		withFacility(h.kitchenToken(), h.facility,
			&dietv1.PlateTraysRequest{CensusId: census.GetCensusId()}))
	if err != nil {
		t.Fatalf("PlateTrays: %v", err)
	}
	if len(again.Msg.GetTrays()) != 0 {
		t.Fatalf("the second plating produced %d duplicates",
			len(again.Msg.GetTrays()))
	}

	if _, err := h.diet.PrepareTray(ctx,
		withFacility(h.kitchenToken(), h.facility,
			&dietv1.PrepareTrayRequest{
				TrayId: tray.GetTrayId(),
			})); err != nil {
		t.Fatalf("PrepareTray: %v", err)
	}

	// And then the patient is listed for theatre. The census said breakfast;
	// the ward says nil by mouth.
	npo := h.orderRequest(patient, encounter, time.Now().UTC())
	npo.Route = dietv1.Route_ROUTE_NPO
	npo.Texture = nil
	if _, err := h.diet.PlaceDietOrder(ctx,
		withFacility(h.doctorToken(), h.facility, npo)); err != nil {
		t.Fatalf("PlaceDietOrder: %v", err)
	}

	dispatched, err := h.diet.DispatchTray(ctx,
		withFacility(h.kitchenToken(), h.facility,
			&dietv1.DispatchTrayRequest{TrayId: tray.GetTrayId()}))
	if err != nil {
		t.Fatalf("DispatchTray: %v", err)
	}
	held := dispatched.Msg.GetTray()
	if held.GetState() != dietv1.TrayState_TRAY_STATE_WITHHELD {
		t.Fatalf("state = %v — a tray plated before the patient was made "+
			"nil by mouth was sent anyway", held.GetState())
	}
	if held.GetReason() == "" {
		t.Fatal("a withheld tray with no reason looks to the ward like a " +
			"meal that went astray")
	}
	if held.GetDispatchedAt() != nil {
		t.Fatal("a withheld tray was marked as dispatched")
	}

	// And it cannot then be delivered.
	_, err = h.diet.DeliverTray(ctx,
		withFacility(h.nurseToken(), h.facility,
			&dietv1.DeliverTrayRequest{TrayId: tray.GetTrayId()}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("a withheld tray was delivered: %v", err)
	}

	outcome, err := h.diet.GetMealOutcome(ctx,
		withFacility(h.kitchenToken(), h.facility,
			&dietv1.GetMealOutcomeRequest{
				CensusId: census.GetCensusId(),
			}))
	if err != nil {
		t.Fatalf("GetMealOutcome: %v", err)
	}
	if outcome.Msg.GetOutcome().GetWithheld() != 1 {
		t.Fatalf("outcome = %+v, want one withheld", outcome.Msg.GetOutcome())
	}
}

// SRS-DIET-005, SRS-DIET-006. A census freezes, is reissued rather than
// edited, and the trays run through to delivery.
func TestACensusFreezesAndTheTraysRunThroughToDelivery(t *testing.T) {
	h := newDietHarness(t)
	ctx := context.Background()

	h.kitchenSetUp(t)
	patient, encounter := h.patient(t, "Nair", "9876543212")
	if _, err := h.diet.PlaceDietOrder(ctx,
		withFacility(h.dietitianToken(), h.facility,
			h.orderRequest(patient, encounter,
				time.Now().UTC().Add(-time.Hour)))); err != nil {
		t.Fatalf("PlaceDietOrder: %v", err)
	}

	census := h.frozenCensus(t)
	// Freezing twice is a second cutoff for one service.
	_, err := h.diet.FreezeCensus(ctx,
		withFacility(h.kitchenToken(), h.facility,
			&dietv1.FreezeCensusRequest{CensusId: census.GetCensusId()}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("a census was frozen twice: %v", err)
	}

	// A patient admitted after cutoff gets a reissue, and the frozen census
	// stays readable: it is what the kitchen cooked to.
	late, lateEncounter := h.patient(t, "Menon", "9876543213")
	if _, err := h.diet.PlaceDietOrder(ctx,
		withFacility(h.dietitianToken(), h.facility,
			h.orderRequest(late, lateEncounter,
				time.Now().UTC()))); err != nil {
		t.Fatalf("PlaceDietOrder: %v", err)
	}
	reissued, err := h.diet.ReissueCensus(ctx,
		withFacility(h.kitchenToken(), h.facility,
			&dietv1.ReissueCensusRequest{CensusId: census.GetCensusId()}))
	if err != nil {
		t.Fatalf("ReissueCensus: %v", err)
	}
	next := reissued.Msg.GetCensus()
	switch {
	case next.GetCensusVersion() != 2:
		t.Fatalf("version = %d", next.GetCensusVersion())
	case next.GetSupersedesId() != census.GetCensusId():
		t.Fatalf("supersedes = %q", next.GetSupersedesId())
	case len(next.GetLines()) != 2:
		t.Fatalf("lines = %d, want both patients", len(next.GetLines()))
	}

	listed, err := h.diet.ListCensuses(ctx,
		withFacility(h.kitchenToken(), h.facility,
			&dietv1.ListCensusesRequest{WardId: "ward-4"}))
	if err != nil {
		t.Fatalf("ListCensuses: %v", err)
	}
	if len(listed.Msg.GetCensuses()) != 2 {
		t.Fatalf("listed %d censuses, want both versions",
			len(listed.Msg.GetCensuses()))
	}

	plated, err := h.diet.PlateTrays(ctx,
		withFacility(h.kitchenToken(), h.facility,
			&dietv1.PlateTraysRequest{CensusId: next.GetCensusId()}))
	if err != nil {
		t.Fatalf("PlateTrays: %v", err)
	}
	tray := plated.Msg.GetTrays()[0]

	if _, err := h.diet.PrepareTray(ctx,
		withFacility(h.kitchenToken(), h.facility,
			&dietv1.PrepareTrayRequest{
				TrayId: tray.GetTrayId(),
			})); err != nil {
		t.Fatalf("PrepareTray: %v", err)
	}
	sent, err := h.diet.DispatchTray(ctx,
		withFacility(h.kitchenToken(), h.facility,
			&dietv1.DispatchTrayRequest{TrayId: tray.GetTrayId()}))
	if err != nil {
		t.Fatalf("DispatchTray: %v", err)
	}
	if sent.Msg.GetTray().GetState() !=
		dietv1.TrayState_TRAY_STATE_DISPATCHED {
		t.Fatalf("state = %v", sent.Msg.GetTray().GetState())
	}

	// The last few metres are the ward's.
	delivered, err := h.diet.DeliverTray(ctx,
		withFacility(h.nurseToken(), h.facility,
			&dietv1.DeliverTrayRequest{TrayId: tray.GetTrayId()}))
	if err != nil {
		t.Fatalf("DeliverTray: %v", err)
	}
	if delivered.Msg.GetTray().GetDeliveredBy() != "nurse-1" {
		t.Fatalf("delivered by %q",
			delivered.Msg.GetTray().GetDeliveredBy())
	}
}

// SRS-DIET-007. A support plan is not a prescription: it cannot go active
// against an order that does not exist, and the dietitian who wrote it is not
// the one who puts it into force.
func TestANutritionSupportPlanCannotStartAFeedOnItsOwn(t *testing.T) {
	h := newDietHarness(t)
	ctx := context.Background()

	patient, encounter := h.patient(t, "Pillai", "9876543214")

	planned, err := h.diet.PlanNutritionSupport(ctx,
		withFacility(h.dietitianToken(), h.facility,
			&dietv1.PlanNutritionSupportRequest{
				PatientId: patient, EncounterId: encounter,
				Kind:        dietv1.SupportKind_SUPPORT_KIND_PARENTERAL,
				FormulaCode: "TPN-STD", FormulaName: "Standard TPN",
				TargetVolumeMl: 1500, TargetEnergyKcal: 1400,
				TargetProteinG: 70,
				RampPlan:       "50% on day one for refeeding risk",
			}))
	if err != nil {
		t.Fatalf("PlanNutritionSupport: %v", err)
	}
	plan := planned.Msg.GetPlan()
	// Nothing is running. This state exists so a plan cannot be mistaken for
	// a feed.
	if plan.GetState() != dietv1.SupportState_SUPPORT_STATE_PLANNED {
		t.Fatalf("state = %v, want planned", plan.GetState())
	}

	// The dietitian who wrote it cannot put it into force.
	_, err = h.diet.LinkSupportOrder(ctx,
		withFacility(h.dietitianToken(), h.facility,
			&dietv1.LinkSupportOrderRequest{
				PlanId: plan.GetPlanId(), OrderRef: "rx-4471",
				OrderContext: "medication",
			}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("the dietitian started a feed: %v", err)
	}

	// Nor can a prescriber, against an order that does not exist. Without
	// this the rule is defeated by typing anything into the field, and the
	// pharmacy check the requirement exists to preserve is preserved in
	// wording only.
	_, err = h.diet.LinkSupportOrder(ctx,
		withFacility(h.doctorToken(), h.facility,
			&dietv1.LinkSupportOrderRequest{
				PlanId: plan.GetPlanId(), OrderRef: "rx-invented",
				OrderContext: "medication",
			}))
	if connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("a plan went active against an invented order: %v", err)
	}

	// And not against a context this deployment does not place orders in.
	_, err = h.diet.LinkSupportOrder(ctx,
		withFacility(h.doctorToken(), h.facility,
			&dietv1.LinkSupportOrderRequest{
				PlanId: plan.GetPlanId(), OrderRef: "rx-4471",
				OrderContext: "somewhere_else",
			}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("an unknown order context was accepted: %v", err)
	}

	listed, err := h.diet.ListSupportPlans(ctx,
		withFacility(h.dietitianToken(), h.facility,
			&dietv1.ListSupportPlansRequest{
				PatientId: patient, ActiveOnly: true,
			}))
	if err != nil {
		t.Fatalf("ListSupportPlans: %v", err)
	}
	if len(listed.Msg.GetPlans()) != 0 {
		t.Fatalf("a plan is active with no order behind it: %+v",
			listed.Msg.GetPlans())
	}
}

// SRS-DIET-001, SRS-DIET-004. An assessment pins the allergies the dietitian
// saw, and a care plan trends against it.
func TestAnAssessmentPinsWhatWasKnownAndThePlanTrendsAgainstIt(t *testing.T) {
	h := newDietHarness(t)
	ctx := context.Background()

	patient, encounter := h.patient(t, "Varma", "9876543215")
	if _, err := h.clinical.RecordAllergy(ctx,
		withFacility(h.doctorToken(), h.facility,
			&clinicalv1.RecordAllergyRequest{
				PatientId: patient, EncounterId: encounter,
				Substance: &clinicalv1.Coding{
					System: "SCT", Version: "2026",
					Code: "SCT-3718001", Display: "Milk",
				},
				Kind:         clinicalv1.AllergyKind_ALLERGY_KIND_INTOLERANCE,
				Criticality:  clinicalv1.AllergyCriticality_ALLERGY_CRITICALITY_LOW,
				Verification: clinicalv1.AllergyVerification_ALLERGY_VERIFICATION_CONFIRMED,
			})); err != nil {
		t.Fatalf("RecordAllergy: %v", err)
	}

	recorded, err := h.diet.RecordAssessment(ctx,
		withFacility(h.dietitianToken(), h.facility,
			&dietv1.RecordAssessmentRequest{
				PatientId: patient, EncounterId: encounter,
				FacilityId: h.facility,
				Anthropometry: &dietv1.Anthropometry{
					HeightMm: 1650, WeightG: 62000,
				},
				IntakeSummary: "half portions",
				DiagnosisCode: "MAL-2",
				Diagnosis:     "moderate malnutrition",
				Requirement: &dietv1.Requirement{
					EnergyKcal: 1800, ProteinG: 75, FluidMl: 2000,
					Basis: "25 kcal/kg",
				},
				RiskTool: "MUST", RiskScore: 2,
			}))
	if err != nil {
		t.Fatalf("RecordAssessment: %v", err)
	}
	assessment := recorded.Msg.GetAssessment()
	// Pinned from the clinical record rather than typed: a later question is
	// answered against what the dietitian actually saw.
	if len(assessment.GetAllergyRefs()) != 1 {
		t.Fatalf("allergy refs = %+v, want the milk intolerance",
			assessment.GetAllergyRefs())
	}
	// Derived, never stored.
	if assessment.GetBodyMassIndexTenths() != 227 {
		t.Fatalf("BMI = %d tenths", assessment.GetBodyMassIndexTenths())
	}

	signed, err := h.diet.SignAssessment(ctx,
		withFacility(h.dietitianToken(), h.facility,
			&dietv1.SignAssessmentRequest{
				AssessmentId: assessment.GetAssessmentId(),
			}))
	if err != nil {
		t.Fatalf("SignAssessment: %v", err)
	}
	if signed.Msg.GetAssessment().GetState() !=
		dietv1.AssessmentState_ASSESSMENT_STATE_SIGNED {
		t.Fatalf("state = %v", signed.Msg.GetAssessment().GetState())
	}

	opened, err := h.diet.OpenCarePlan(ctx,
		withFacility(h.dietitianToken(), h.facility,
			&dietv1.OpenCarePlanRequest{
				PatientId: patient, EncounterId: encounter,
				AssessmentId: assessment.GetAssessmentId(),
				Goals: []*dietv1.NutritionGoal{{
					Code: "weight", Label: "Body weight", Target: 68000,
					Unit: "g", Direction: dietv1.Direction_DIRECTION_INCREASE,
					Tolerance: 1000,
				}},
				Plan: "fortified diet plus two supplements daily",
			}))
	if err != nil {
		t.Fatalf("OpenCarePlan: %v", err)
	}
	plan := opened.Msg.GetPlan()

	// A trend with nothing on it is unanswerable rather than a flat line at
	// zero, which reads as a patient whose weight is nothing.
	empty, err := h.diet.GetGoalTrend(ctx,
		withFacility(h.dietitianToken(), h.facility,
			&dietv1.GetGoalTrendRequest{
				PlanId: plan.GetPlanId(), GoalCode: "weight",
			}))
	if err != nil {
		t.Fatalf("GetGoalTrend: %v", err)
	}
	if !empty.Msg.GetTrend().GetUnanswerable() {
		t.Fatal("a goal with no measurements reads as answered")
	}

	base := time.Now().UTC()
	for i, value := range []int32{62000, 65000, 67500} {
		if _, err := h.diet.RecordProgress(ctx,
			withFacility(h.dietitianToken(), h.facility,
				&dietv1.RecordProgressRequest{
					PlanId: plan.GetPlanId(), GoalCode: "weight",
					Value: value,
					MeasuredAt: timestamppb.New(
						base.AddDate(0, 0, i*7)),
				})); err != nil {
			t.Fatalf("RecordProgress: %v", err)
		}
	}

	trend, err := h.diet.GetGoalTrend(ctx,
		withFacility(h.dietitianToken(), h.facility,
			&dietv1.GetGoalTrendRequest{
				PlanId: plan.GetPlanId(), GoalCode: "weight",
			}))
	if err != nil {
		t.Fatalf("GetGoalTrend: %v", err)
	}
	got := trend.Msg.GetTrend()
	if len(got.GetPoints()) != 3 || !got.GetMet() || !got.GetImproving() {
		t.Fatalf("trend = %+v, want three points, met and improving", got)
	}

	// The kitchen has no business reading a nutrition assessment.
	_, err = h.diet.ListAssessments(ctx,
		withFacility(h.kitchenToken(), h.facility,
			&dietv1.ListAssessmentsRequest{PatientId: patient}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("the kitchen read a nutrition assessment: %v", err)
	}
}

// SRS-DIET-008. The forecast comes from the frozen census and stays apart
// from what the kitchen counted.
func TestTheForecastAndTheCountStayTwoNumbers(t *testing.T) {
	h := newDietHarness(t)
	ctx := context.Background()

	h.kitchenSetUp(t)
	patient, encounter := h.patient(t, "Menon", "9876543216")
	if _, err := h.diet.PlaceDietOrder(ctx,
		withFacility(h.dietitianToken(), h.facility,
			h.orderRequest(patient, encounter,
				time.Now().UTC().Add(-time.Hour)))); err != nil {
		t.Fatalf("PlaceDietOrder: %v", err)
	}
	census := h.frozenCensus(t)

	if _, err := h.diet.RecordConsumption(ctx,
		withFacility(h.kitchenToken(), h.facility,
			&dietv1.RecordConsumptionRequest{
				CensusId: census.GetCensusId(), IngredientCode: "OATS",
				ActualG: 45,
			})); err != nil {
		t.Fatalf("RecordConsumption: %v", err)
	}

	forecast, err := h.diet.GetIngredientForecast(ctx,
		withFacility(h.kitchenToken(), h.facility,
			&dietv1.GetIngredientForecastRequest{
				CensusId: census.GetCensusId(),
			}))
	if err != nil {
		t.Fatalf("GetIngredientForecast: %v", err)
	}
	got := forecast.Msg.GetForecast()
	if got.GetCensusVersion() != census.GetCensusVersion() {
		t.Fatal("a forecast that does not pin its census version cannot be " +
			"reconciled with either")
	}
	byCode := map[string]*dietv1.IngredientDemand{}
	for _, demand := range got.GetDemand() {
		byCode[demand.GetCode()] = demand
	}
	oats := byCode["OATS"]
	if oats.GetForecastG() != 60 || oats.GetActualG() != 45 {
		t.Fatalf("oats = %+v, want the forecast and the count side by side",
			oats)
	}
	if !oats.GetWastageKnown() || oats.GetWastageG() != 15 {
		t.Fatalf("oats wastage = %d (%v)", oats.GetWastageG(),
			oats.GetWastageKnown())
	}
	// Milk was forecast and nobody has counted it, which must not read as a
	// kitchen that wasted all of it.
	milk := byCode["MILK"]
	if milk.GetActualRecorded() || milk.GetWastageKnown() {
		t.Fatalf("milk = %+v, want no count and no wastage", milk)
	}
}

// frozenCensus builds and freezes a breakfast census for ward 4.
func (h *dietHarness) frozenCensus(t *testing.T) *dietv1.MealCensus {
	t.Helper()
	ctx := context.Background()
	now := time.Now().UTC()

	built, err := h.diet.BuildCensus(ctx,
		withFacility(h.kitchenToken(), h.facility,
			&dietv1.BuildCensusRequest{
				WardId: "ward-4", FacilityId: h.facility,
				Cycle:       dietv1.MealCycle_MEAL_CYCLE_BREAKFAST,
				ServiceDate: timestamppb.New(now),
				CutoffAt:    timestamppb.New(now.Add(time.Hour)),
			}))
	if err != nil {
		t.Fatalf("BuildCensus: %v", err)
	}
	frozen, err := h.diet.FreezeCensus(ctx,
		withFacility(h.kitchenToken(), h.facility,
			&dietv1.FreezeCensusRequest{
				CensusId: built.Msg.GetCensus().GetCensusId(),
			}))
	if err != nil {
		t.Fatalf("FreezeCensus: %v", err)
	}
	return frozen.Msg.GetCensus()
}
