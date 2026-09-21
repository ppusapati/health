package postgres_test

import (
	"context"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"github.com/ppusapati/health/code/internal/dietetics/adapters/postgres"
	"github.com/ppusapati/health/code/internal/dietetics/domain"
	"github.com/ppusapati/health/code/internal/dietetics/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
)

// The dietetics persistence adapter.
//
// Round-trip tests, because the defect they catch is invisible above the
// adapter: a dropped field reads back as a zero that looks like a decision
// nobody made. A lost texture code turns a pureed diet into a normal one; a
// lost conflict turns a pending order into one the kitchen can see; a lost
// dispatch timestamp turns a meal that was checked into one that was not.
//
// The assertions that bypass the adapter and write raw SQL are the rules that
// belong to the database rather than to Go: a rule the adapter is the only
// thing enforcing is one a migration, a backfill or the next context's
// repository can walk straight past.

var at = time.Date(2026, 9, 21, 6, 0, 0, 0, time.UTC)

type fixture struct {
	pool     *pgxpool.Pool
	repo     *postgres.Repository
	scope    authctx.TenantScope
	tenantID string
}

func newFixture(t *testing.T) fixture {
	t.Helper()

	pool := pgtest.New(t)
	tenantID := uuid.NewString()

	return fixture{
		pool: pool,
		repo: postgres.New(pgtx.NewManager(pool)),
		scope: authctx.NewSession(authctx.Session{
			SubjectID: "diet-1", TenantID: tenantID,
		}).TenantScope(),
		tenantID: tenantID,
	}
}

// mustFail asserts the database refuses a write, naming the constraint it
// expects. A raw statement, because the point is that the rule holds against
// a caller that never went through the domain.
func (f fixture) mustFail(t *testing.T, constraint, sql string,
	args ...any) {

	t.Helper()
	_, err := f.pool.Exec(context.Background(), sql, args...)
	if err == nil {
		t.Fatalf("the database accepted a write %q should have refused",
			constraint)
	}
	if !strings.Contains(err.Error(), constraint) {
		t.Fatalf("want a violation of %q, got %v", constraint, err)
	}
}

func (f fixture) mustExec(t *testing.T, sql string, args ...any) {
	t.Helper()
	if _, err := f.pool.Exec(context.Background(), sql, args...); err != nil {
		t.Fatalf("exec: %v", err)
	}
}

func assessmentInput() domain.NewAssessmentInput {
	return domain.NewAssessmentInput{
		PatientID: "p1", EncounterID: "enc-1", FacilityID: "f1",
		Anthropometry: domain.Anthropometry{
			HeightMM: 1650, WeightG: 62000, MidUpperArmMM: 240,
		},
		IntakeSummary: "half portions",
		DiagnosisCode: "MAL-2", Diagnosis: "moderate malnutrition",
		AllergyRefs: []string{"al-1", "al-2"},
		Requirement: domain.Requirement{
			EnergyKcal: 1800, ProteinG: 75, FluidML: 2000,
			Basis: "25 kcal/kg",
		},
		RiskTool: "MUST", RiskScore: 2,
	}
}

// SRS-DIET-001. An assessment survives the round trip with the measurements
// the requirement was computed from.
func TestAnAssessmentRoundTripsWithWhatWasMeasured(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	assessment, err := domain.NewAssessment(uuid.NewString(), f.tenantID,
		assessmentInput(), "diet-1", at)
	if err != nil {
		t.Fatalf("NewAssessment: %v", err)
	}
	if err := f.repo.InsertAssessment(ctx, f.scope, assessment); err != nil {
		t.Fatalf("InsertAssessment: %v", err)
	}

	back, err := f.repo.Assessment(ctx, f.scope, assessment.ID)
	if err != nil {
		t.Fatalf("Assessment: %v", err)
	}
	switch {
	case back.Anthropometry.WeightG != 62000:
		t.Fatalf("weight = %d g", back.Anthropometry.WeightG)
	case back.Anthropometry.MidUpperArmMM != 240:
		t.Fatalf("mid-upper arm = %d mm", back.Anthropometry.MidUpperArmMM)
	case back.Requirement.Basis != "25 kcal/kg":
		t.Fatalf("basis = %q — a requirement nobody can reproduce is a "+
			"number", back.Requirement.Basis)
	case len(back.AllergyRefs) != 2:
		t.Fatalf("allergy refs = %+v, want what the dietitian saw",
			back.AllergyRefs)
	case back.Anthropometry.BMITenths() != 227:
		t.Fatalf("BMI = %d tenths after the round trip", back.Anthropometry.BMITenths())
	}

	if err := back.Sign("diet-2", at.Add(time.Hour)); err != nil {
		t.Fatalf("Sign: %v", err)
	}
	if err := f.repo.SignAssessment(ctx, f.scope, back,
		back.Version); err != nil {
		t.Fatalf("SignAssessment: %v", err)
	}
	// The same signature twice is a lost update: somebody else signed in
	// between and this write would silently overwrite them.
	if err := f.repo.SignAssessment(ctx, f.scope, back,
		back.Version); err == nil {
		t.Fatal("a stale sign was accepted")
	}

	signed, err := f.repo.Assessments(ctx, f.scope,
		ports.AssessmentFilter{PatientID: "p1", SignedOnly: true})
	if err != nil {
		t.Fatalf("Assessments: %v", err)
	}
	if len(signed) != 1 || signed[0].SignedBy != "diet-2" {
		t.Fatalf("signed = %+v", signed)
	}
}

// SRS-DIET-001. The database holds the assessment rules.
func TestTheDatabaseHoldsTheAssessmentRules(t *testing.T) {
	f := newFixture(t)

	insert := `INSERT INTO hospital_ops_diet.nutrition_assessment (
		assessment_id, tenant_id, patient_id, encounter_id, height_mm,
		weight_g, mid_upper_arm_mm, energy_kcal, requirement_basis,
		risk_tool, risk_score, state, signed_by, signed_at,
		created_at, created_by
	) VALUES ($1, $2, 'p1', 'enc-1', $3, $4, $5, $6, $7, $8, $9, $10, $11,
		$12, $13, 'diet-1')`

	// A score of 3 means malnourished in one tool and at risk in another.
	f.mustFail(t, "a_risk_score_names_its_tool", insert,
		uuid.New(), f.tenantID, 1650, 62000, 0, 0, "", "", 3, "draft", "",
		nil, at)

	// A requirement nobody can reproduce is a number.
	f.mustFail(t, "a_requirement_says_how_it_was_calculated", insert,
		uuid.New(), f.tenantID, 1650, 62000, 0, 1800, "", "", 0, "draft", "",
		nil, at)

	f.mustFail(t, "a_signed_assessment_names_who_signed_it", insert,
		uuid.New(), f.tenantID, 1650, 62000, 0, 0, "", "", 0, "signed", "",
		nil, at)

	// Signed with nothing measured at all is an assessment of nobody.
	f.mustFail(t, "a_signed_assessment_measured_something", insert,
		uuid.New(), f.tenantID, 0, 0, 0, 0, "", "", 0, "signed", "diet-2",
		at, at)

	// A mid-upper arm circumference alone counts: in critical care it is
	// often the only measurement there is, and refusing it would leave those
	// patients unassessed.
	f.mustExec(t, insert, uuid.New(), f.tenantID, 0, 0, 210, 0, "", "", 0,
		"signed", "diet-2", at, at)

	f.mustFail(t, "nutrition_assessment_encounter_id_check",
		`INSERT INTO hospital_ops_diet.nutrition_assessment (
			assessment_id, tenant_id, patient_id, encounter_id, state,
			created_at, created_by
		) VALUES ($1, $2, 'p1', '', 'draft', $3, 'diet-1')`,
		uuid.New(), f.tenantID, at)
}

func orderInput() domain.NewOrderInput {
	return domain.NewOrderInput{
		PatientID: "p1", EncounterID: "enc-1", FacilityID: "f1",
		WardID: "ward-4", BedID: "b12", Route: domain.RouteOral,
		Texture: domain.Texture{
			Code: "IDDSI-7", Label: "Regular", FluidCode: "IDDSI-0",
		},
		Restrictions:  []string{"low_sodium"},
		Supplements:   []string{"ONS-1"},
		EffectiveFrom: at,
	}
}

// SRS-DIET-002, SRS-DIET-003. An order and its conflicts go in together, and
// the order stays pending until somebody resolves them.
func TestADietOrderRoundTripsWithItsAllergyConflicts(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	conflicts := []domain.Conflict{{
		AllergyRef: "al-1", Substance: "peanut", Item: "Satay chicken",
		Severity: "anaphylaxis",
	}}
	order, err := domain.PlaceDietOrder(uuid.NewString(), f.tenantID,
		orderInput(), conflicts, "doc-1", at)
	if err != nil {
		t.Fatalf("PlaceDietOrder: %v", err)
	}
	if err := f.repo.InsertOrder(ctx, f.scope, order); err != nil {
		t.Fatalf("InsertOrder: %v", err)
	}

	back, err := f.repo.Order(ctx, f.scope, order.ID)
	if err != nil {
		t.Fatalf("Order: %v", err)
	}
	switch {
	case back.State != domain.OrderPending:
		t.Fatalf("state = %q, want pending", back.State)
	case back.Texture.Code != "IDDSI-7" || back.Texture.FluidCode != "IDDSI-0":
		t.Fatalf("texture lost: %+v — a lost texture turns a pureed diet "+
			"into a normal one", back.Texture)
	case len(back.Restrictions) != 1 || len(back.Supplements) != 1:
		t.Fatalf("restrictions/supplements lost: %+v", back)
	case len(back.OpenConflicts()) != 1:
		t.Fatalf("conflicts = %+v — a lost conflict is an order the "+
			"kitchen can see with an unresolved peanut allergy on it",
			back.Conflicts)
	}

	// The kitchen's read never returns a pending order.
	ward, err := f.repo.OrdersForWard(ctx, f.scope, "ward-4", 100)
	if err != nil {
		t.Fatalf("OrdersForWard: %v", err)
	}
	if _, found := domain.OrderInForce(ward, at.Add(time.Hour)); found {
		t.Fatal("an order with an open allergy conflict reached the kitchen")
	}

	if err := back.ResolveConflict("al-1", "Satay chicken",
		"reaction was to the shell", "doc-2", at); err != nil {
		t.Fatalf("ResolveConflict: %v", err)
	}
	if err := f.repo.ResolveConflict(ctx, f.scope, back, "al-1",
		"Satay chicken"); err != nil {
		t.Fatalf("ResolveConflict: %v", err)
	}

	resolved, err := f.repo.Order(ctx, f.scope, order.ID)
	if err != nil {
		t.Fatalf("Order: %v", err)
	}
	if resolved.State != domain.OrderActive {
		t.Fatalf("state = %q, want active once nothing is open",
			resolved.State)
	}
	if len(resolved.OpenConflicts()) != 0 {
		t.Fatalf("open conflicts remain: %+v", resolved.OpenConflicts())
	}
	if resolved.Conflicts[0].ResolutionNote == "" {
		t.Fatal("the reason a doctor authorised a peanut dish was lost")
	}
}

// SRS-DIET-002. Placing a new order retires the old one, so the kitchen sees
// exactly one.
func TestANewOrderRetiresTheOneBeforeIt(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	first, err := domain.PlaceDietOrder(uuid.NewString(), f.tenantID,
		orderInput(), nil, "doc-1", at)
	if err != nil {
		t.Fatalf("PlaceDietOrder: %v", err)
	}
	if err := f.repo.InsertOrder(ctx, f.scope, first); err != nil {
		t.Fatalf("InsertOrder: %v", err)
	}

	later := orderInput()
	later.Texture.Code = "IDDSI-4"
	later.EffectiveFrom = at.Add(2 * time.Hour)
	second, err := domain.PlaceDietOrder(uuid.NewString(), f.tenantID, later,
		nil, "doc-1", at.Add(time.Hour))
	if err != nil {
		t.Fatalf("PlaceDietOrder: %v", err)
	}
	if err := f.repo.InsertOrder(ctx, f.scope, second); err != nil {
		t.Fatalf("InsertOrder: %v", err)
	}
	if err := f.repo.SupersedeOtherOrders(ctx, f.scope, "p1", second.ID,
		at.Add(time.Hour)); err != nil {
		t.Fatalf("SupersedeOtherOrders: %v", err)
	}

	orders, err := f.repo.OrdersForWard(ctx, f.scope, "ward-4", 100)
	if err != nil {
		t.Fatalf("OrdersForWard: %v", err)
	}
	// One live order for one patient. Two is a kitchen that plates whichever
	// is on top.
	if len(orders) != 1 || orders[0].ID != second.ID {
		t.Fatalf("live orders = %d, want only the latest", len(orders))
	}
}

// SRS-DIET-002, SRS-DIET-009. The database holds the diet order rules.
func TestTheDatabaseHoldsTheDietOrderRules(t *testing.T) {
	f := newFixture(t)

	insert := `INSERT INTO hospital_ops_diet.diet_order (
		order_id, tenant_id, patient_id, ward_id, route, texture_code,
		restrictions, supplements, effective_from, effective_to, state,
		cancelled_reason, cancelled_by, cancelled_at, placed_at, placed_by
	) VALUES ($1, $2, 'p1', 'ward-4', $3, $4, $5, $6, $7, $8, $9, $10, $11,
		$12, $13, 'doc-1')`

	// A dysphagic patient sent a normal tray is an aspiration.
	f.mustFail(t, "an_oral_order_names_its_texture", insert,
		uuid.New(), f.tenantID, "oral", "", []string{}, []string{}, at, nil,
		"active", "", "", nil, at)

	// Nil by mouth with a renal restriction attached is an order two people
	// read two ways, and one of them sends a tray.
	f.mustFail(t, "nil_by_mouth_carries_nothing_to_eat", insert,
		uuid.New(), f.tenantID, "npo", "", []string{"renal"}, []string{}, at,
		nil, "active", "", "", nil, at)

	f.mustFail(t, "an_order_ends_after_it_starts", insert,
		uuid.New(), f.tenantID, "oral", "IDDSI-7", []string{}, []string{},
		at, at.Add(-time.Hour), "active", "", "", nil, at)

	f.mustFail(t, "a_cancelled_order_says_why", insert,
		uuid.New(), f.tenantID, "oral", "IDDSI-7", []string{}, []string{},
		at, at.Add(time.Hour), "cancelled", "", "", nil, at)

	// A cancellation that leaves the order in force until midnight is a
	// cancellation that sends supper.
	f.mustFail(t, "a_cancelled_order_stops", insert,
		uuid.New(), f.tenantID, "oral", "IDDSI-7", []string{}, []string{},
		at, nil, "cancelled", "for theatre", "doc-1", at, at)

	orderID := uuid.New()
	f.mustExec(t, insert, orderID, f.tenantID, "oral", "IDDSI-7",
		[]string{}, []string{}, at, nil, "active", "", "", nil, at)

	insertConflict := `INSERT INTO hospital_ops_diet.order_conflict (
		conflict_id, tenant_id, order_id, allergy_ref, item, resolved_by,
		resolved_at, resolution_note
	) VALUES ($1, $2, $3, 'al-1', 'Satay', $4, $5, $6)`

	// "Resolved by Dr Rao" is not an answer to why a patient with a
	// documented peanut allergy is being given a peanut dish.
	f.mustFail(t, "a_resolved_conflict_says_why", insertConflict,
		uuid.New(), f.tenantID, orderID, "doc-2", at, "")
	f.mustFail(t, "a_resolved_conflict_says_why", insertConflict,
		uuid.New(), f.tenantID, orderID, "", at, "shell only")

	f.mustExec(t, insertConflict, uuid.New(), f.tenantID, orderID, "doc-2",
		at, "reaction was to the shell")
	// The same allergen against the same item twice is two decisions on one
	// question, and a worklist that shows the unresolved one for ever.
	f.mustFail(t, "order_conflict_unique_idx", insertConflict,
		uuid.New(), f.tenantID, orderID, "doc-3", at, "again")
}

func liveOrder(t *testing.T, f fixture, mutate func(*domain.NewOrderInput)) (
	domain.DietOrder, error) {

	t.Helper()
	in := orderInput()
	if mutate != nil {
		mutate(&in)
	}
	order, err := domain.PlaceDietOrder(uuid.NewString(), f.tenantID, in,
		nil, "doc-1", at)
	if err != nil {
		return domain.DietOrder{}, err
	}
	return order, f.repo.InsertOrder(context.Background(), f.scope, order)
}

// SRS-DIET-005. A census freezes, is reissued rather than edited, and both
// versions stay readable.
func TestACensusFreezesAndIsReissuedRatherThanEdited(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	order, err := liveOrder(t, f, nil)
	if err != nil {
		t.Fatalf("liveOrder: %v", err)
	}

	census, err := domain.BuildCensus(uuid.NewString(), f.tenantID, "f1",
		"ward-4", domain.CycleBreakfast, at, at.Add(time.Hour),
		[]domain.DietOrder{order}, at, "kitchen-1", at)
	if err != nil {
		t.Fatalf("BuildCensus: %v", err)
	}
	if err := f.repo.InsertCensus(ctx, f.scope, census); err != nil {
		t.Fatalf("InsertCensus: %v", err)
	}

	back, err := f.repo.Census(ctx, f.scope, census.ID)
	if err != nil {
		t.Fatalf("Census: %v", err)
	}
	if len(back.Lines) != 1 || back.Lines[0].OrderID != order.ID {
		t.Fatalf("lines = %+v — a line that does not pin its order cannot "+
			"answer what the kitchen cooked to", back.Lines)
	}
	if back.Lines[0].TextureCode != "IDDSI-7" {
		t.Fatalf("texture lost: %+v", back.Lines[0])
	}

	if err := back.Freeze("kitchen-1", at.Add(time.Hour)); err != nil {
		t.Fatalf("Freeze: %v", err)
	}
	if err := f.repo.FreezeCensus(ctx, f.scope, back); err != nil {
		t.Fatalf("FreezeCensus: %v", err)
	}
	// Freezing twice is a second cutoff for one service.
	if err := f.repo.FreezeCensus(ctx, f.scope, back); err == nil {
		t.Fatal("a census was frozen twice")
	}

	frozen, err := f.repo.Census(ctx, f.scope, census.ID)
	if err != nil {
		t.Fatalf("Census: %v", err)
	}
	admitted, err := liveOrder(t, f, func(in *domain.NewOrderInput) {
		in.PatientID = "p9"
		in.BedID = "b20"
	})
	if err != nil {
		t.Fatalf("liveOrder: %v", err)
	}
	next, err := frozen.Reissue(uuid.NewString(),
		[]domain.DietOrder{order, admitted}, at.Add(2*time.Hour),
		"kitchen-1", at.Add(2*time.Hour))
	if err != nil {
		t.Fatalf("Reissue: %v", err)
	}
	if err := f.repo.InsertCensus(ctx, f.scope, next); err != nil {
		t.Fatalf("InsertCensus: %v", err)
	}
	if err := f.repo.SupersedeCensus(ctx, f.scope, frozen.ID); err != nil {
		t.Fatalf("SupersedeCensus: %v", err)
	}

	// The frozen census is still readable: it is what the kitchen cooked to.
	original, err := f.repo.Census(ctx, f.scope, census.ID)
	if err != nil {
		t.Fatalf("Census: %v", err)
	}
	if len(original.Lines) != 1 || original.Version != 1 {
		t.Fatalf("the frozen census changed underneath the reissue: %+v",
			original)
	}
	reissued, err := f.repo.Census(ctx, f.scope, next.ID)
	if err != nil {
		t.Fatalf("Census: %v", err)
	}
	if reissued.Version != 2 || reissued.SupersedesID != census.ID ||
		len(reissued.Lines) != 2 {
		t.Fatalf("reissue = %+v", reissued)
	}

	listed, err := f.repo.Censuses(ctx, f.scope, ports.CensusFilter{
		WardID: "ward-4", Cycle: domain.CycleBreakfast,
	})
	if err != nil {
		t.Fatalf("Censuses: %v", err)
	}
	if len(listed) != 2 {
		t.Fatalf("listed %d censuses, want both versions", len(listed))
	}
}

// SRS-DIET-006, SRS-DIET-009. A tray round-trips, and the database refuses a
// delivery with no dispatch behind it.
func TestATrayRoundTripsAndCannotBeDeliveredWithoutBeingDispatched(
	t *testing.T) {

	f := newFixture(t)
	ctx := context.Background()

	order, err := liveOrder(t, f, nil)
	if err != nil {
		t.Fatalf("liveOrder: %v", err)
	}
	census, err := domain.BuildCensus(uuid.NewString(), f.tenantID, "f1",
		"ward-4", domain.CycleBreakfast, at, at.Add(time.Hour),
		[]domain.DietOrder{order}, at, "kitchen-1", at)
	if err != nil {
		t.Fatalf("BuildCensus: %v", err)
	}
	if err := census.Freeze("kitchen-1", at.Add(time.Hour)); err != nil {
		t.Fatalf("Freeze: %v", err)
	}
	if err := f.repo.InsertCensus(ctx, f.scope, census); err != nil {
		t.Fatalf("InsertCensus: %v", err)
	}

	line := census.Lines[0]
	tray, err := domain.NewTray(uuid.NewString(), f.tenantID, census, line,
		at.Add(3*time.Hour))
	if err != nil {
		t.Fatalf("NewTray: %v", err)
	}
	if err := f.repo.InsertTray(ctx, f.scope, tray); err != nil {
		t.Fatalf("InsertTray: %v", err)
	}
	// One tray per patient per service. Two is two meals counted for one
	// patient and a ward count that never reconciles.
	f.mustFail(t, "meal_tray_patient_idx",
		`INSERT INTO hospital_ops_diet.meal_tray (
			tray_id, tenant_id, census_id, patient_id, order_id, state
		) VALUES ($1, $2, $3, 'p1', $4, 'planned')`,
		uuid.New(), f.tenantID, census.ID, order.ID)

	if err := tray.Prepare("kitchen-1", at.Add(90*time.Minute)); err != nil {
		t.Fatalf("Prepare: %v", err)
	}
	if err := f.repo.UpdateTray(ctx, f.scope, tray,
		tray.Version); err != nil {
		t.Fatalf("UpdateTray: %v", err)
	}
	tray.Version++

	if err := tray.Dispatch(order, true, line, "porter-1",
		at.Add(2*time.Hour)); err != nil {
		t.Fatalf("Dispatch: %v", err)
	}
	if err := f.repo.UpdateTray(ctx, f.scope, tray,
		tray.Version); err != nil {
		t.Fatalf("UpdateTray: %v", err)
	}
	tray.Version++

	if err := tray.Deliver("nurse-1", at.Add(150*time.Minute)); err != nil {
		t.Fatalf("Deliver: %v", err)
	}
	if err := f.repo.UpdateTray(ctx, f.scope, tray,
		tray.Version); err != nil {
		t.Fatalf("UpdateTray: %v", err)
	}

	back, err := f.repo.Tray(ctx, f.scope, tray.ID)
	if err != nil {
		t.Fatalf("Tray: %v", err)
	}
	if back.DispatchedAt.IsZero() || back.DeliveredBy != "nurse-1" {
		t.Fatalf("tray = %+v — a lost dispatch timestamp turns a meal that "+
			"was checked into one that was not", back)
	}

	trays, err := f.repo.Trays(ctx, f.scope, ports.TrayFilter{
		CensusID: census.ID,
	})
	if err != nil {
		t.Fatalf("Trays: %v", err)
	}
	if len(trays) != 1 {
		t.Fatalf("trays = %d", len(trays))
	}
}

// SRS-DIET-005, SRS-DIET-006, SRS-DIET-009. The database holds the kitchen
// rules.
func TestTheDatabaseHoldsTheKitchenRules(t *testing.T) {
	f := newFixture(t)

	order, err := liveOrder(t, f, nil)
	if err != nil {
		t.Fatalf("liveOrder: %v", err)
	}
	npo, err := liveOrder(t, f, func(in *domain.NewOrderInput) {
		in.PatientID = "p2"
		in.Route = domain.RouteNPO
		in.Texture = domain.Texture{}
		in.Restrictions = nil
		in.Supplements = nil
	})
	if err != nil {
		t.Fatalf("liveOrder: %v", err)
	}

	insertCensus := `INSERT INTO hospital_ops_diet.meal_census (
		census_id, tenant_id, ward_id, cycle, service_date, cutoff_at,
		state, census_version, supersedes_id, frozen_at, frozen_by,
		built_at, built_by
	) VALUES ($1, $2, 'ward-4', 'breakfast', $3, $4, $5, $6, $7, $8, $9,
		$10, 'kitchen-1')`

	f.mustFail(t, "a_frozen_census_says_who_froze_it", insertCensus,
		uuid.New(), f.tenantID, at, at.Add(time.Hour), "frozen", 1, nil,
		nil, "", at)

	// A reissue that does not name what it replaced leaves two counts for
	// one service and no way to tell which came first.
	f.mustFail(t, "a_reissue_names_what_it_replaced", insertCensus,
		uuid.New(), f.tenantID, at, at.Add(time.Hour), "frozen", 2, nil,
		at, "kitchen-1", at)

	censusID := uuid.New()
	f.mustExec(t, insertCensus, censusID, f.tenantID, at, at.Add(time.Hour),
		"frozen", 1, nil, at, "kitchen-1", at)
	// Two rows for the same version are two answers to what the kitchen
	// cooked to.
	f.mustFail(t, "meal_census_version_idx", insertCensus,
		uuid.New(), f.tenantID, at, at.Add(time.Hour), "frozen", 1, nil,
		at, "kitchen-1", at)

	insertLine := `INSERT INTO hospital_ops_diet.census_line (
		line_id, tenant_id, census_id, patient_id, order_id, route,
		texture_code
	) VALUES ($1, $2, $3, $4, $5, $6, 'IDDSI-7')`

	// A census line for a patient who is nil by mouth is a tray plated for
	// somebody who must not eat.
	f.mustFail(t, "a_census_line_is_someone_who_eats", insertLine,
		uuid.New(), f.tenantID, censusID, "p2", npo.ID, "npo")

	f.mustExec(t, insertLine, uuid.New(), f.tenantID, censusID, "p1",
		order.ID, "oral")
	// Two lines for one patient is two trays.
	f.mustFail(t, "census_line_patient_idx", insertLine,
		uuid.New(), f.tenantID, censusID, "p1", order.ID, "oral")

	insertTray := `INSERT INTO hospital_ops_diet.meal_tray (
		tray_id, tenant_id, census_id, patient_id, order_id, state, reason,
		dispatched_at, dispatched_by, delivered_at, delivered_by
	) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)`

	// SRS-DIET-009 at the table. A row that reads as delivered with no
	// dispatch behind it is a meal that reached a patient without the check
	// that would have stopped it.
	f.mustFail(t, "a_delivered_tray_was_dispatched", insertTray,
		uuid.New(), f.tenantID, censusID, "p1", order.ID, "delivered", "",
		nil, "", at, "nurse-1")

	f.mustFail(t, "a_dispatched_tray_says_who_sent_it", insertTray,
		uuid.New(), f.tenantID, censusID, "p1", order.ID, "dispatched", "",
		at, "", nil, "")

	// The ward needs to know the meal was held back rather than that it
	// simply went astray.
	f.mustFail(t, "a_withheld_tray_says_why", insertTray,
		uuid.New(), f.tenantID, censusID, "p1", order.ID, "withheld", "",
		nil, "", nil, "")

	// A patient who has not eaten needs a reason recorded: three of these in
	// a row is a referral rather than a logistics note.
	f.mustFail(t, "an_uneaten_meal_says_why", insertTray,
		uuid.New(), f.tenantID, censusID, "p1", order.ID, "missed", "",
		nil, "", nil, "")
}

// SRS-DIET-007. A support plan round-trips and cannot go active without the
// order carrying it out.
func TestASupportPlanRoundTripsAndNeedsAnOrderBehindIt(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	plan, err := domain.PlanNutritionSupport(uuid.NewString(), f.tenantID,
		domain.NewSupportPlanInput{
			PatientID: "p1", EncounterID: "enc-1",
			Kind: domain.SupportParenteral, FormulaCode: "TPN-STD",
			FormulaName: "Standard TPN", TargetVolumeML: 1500,
			TargetEnergyKcal: 1400, TargetProteinG: 70,
			RampPlan: "50% day one for refeeding risk",
		}, "diet-1", at)
	if err != nil {
		t.Fatalf("PlanNutritionSupport: %v", err)
	}
	if err := f.repo.InsertSupportPlan(ctx, f.scope, plan); err != nil {
		t.Fatalf("InsertSupportPlan: %v", err)
	}

	back, err := f.repo.SupportPlan(ctx, f.scope, plan.ID)
	if err != nil {
		t.Fatalf("SupportPlan: %v", err)
	}
	switch {
	case back.State != domain.SupportPlanned:
		t.Fatalf("state = %q, want planned", back.State)
	case back.TargetEnergyKcal != 1400 || back.RampPlan == "":
		t.Fatalf("plan = %+v — a lost ramp plan matters more than the "+
			"target for a patient at refeeding risk", back)
	}

	if err := back.LinkOrder("rx-4471", "medication", at); err != nil {
		t.Fatalf("LinkOrder: %v", err)
	}
	if err := f.repo.UpdateSupportPlan(ctx, f.scope, back,
		back.Version); err != nil {
		t.Fatalf("UpdateSupportPlan: %v", err)
	}

	active, err := f.repo.SupportPlans(ctx, f.scope, ports.SupportFilter{
		PatientID: "p1", ActiveOnly: true,
	})
	if err != nil {
		t.Fatalf("SupportPlans: %v", err)
	}
	if len(active) != 1 || active[0].OrderRef != "rx-4471" ||
		active[0].OrderContext != "medication" {
		t.Fatalf("active = %+v", active)
	}

	// A hospital where a dietitian's plan alone starts a feed is one where
	// parenteral nutrition bypasses pharmacy.
	f.mustFail(t, "an_active_plan_names_its_order",
		`INSERT INTO hospital_ops_diet.support_plan (
			plan_id, tenant_id, patient_id, kind, formula_code, state,
			created_at, created_by
		) VALUES ($1, $2, 'p1', 'parenteral', 'TPN-STD', 'active', $3,
			'diet-1')`,
		uuid.New(), f.tenantID, at)

	f.mustFail(t, "a_stopped_plan_says_why",
		`INSERT INTO hospital_ops_diet.support_plan (
			plan_id, tenant_id, patient_id, kind, formula_code, state,
			created_at, created_by
		) VALUES ($1, $2, 'p1', 'enteral', 'FEED-1', 'stopped', $3,
			'diet-1')`,
		uuid.New(), f.tenantID, at)

	// And the table has nowhere to put a dose. SRS-DIET-007's "without
	// replacing medication/order controls" is asserted against the catalogue
	// rather than trusted to review: a column added later would fail here.
	rows, err := f.pool.Query(ctx,
		`SELECT column_name FROM information_schema.columns
		 WHERE table_schema = 'hospital_ops_diet'
		   AND table_name = 'support_plan'`)
	if err != nil {
		t.Fatalf("information_schema: %v", err)
	}
	defer rows.Close()
	for rows.Next() {
		var column string
		if err := rows.Scan(&column); err != nil {
			t.Fatalf("scan: %v", err)
		}
		switch column {
		case "dose", "dose_unit", "rate", "rate_ml_per_hour",
			"administered_at", "administered_by":
			t.Fatalf("support_plan has a %q column: this context must not "+
				"be able to express an administration", column)
		}
	}
}

// SRS-DIET-004. A care plan round-trips with its goals, and progress is
// append-only.
func TestACarePlanRoundTripsWithItsGoalsAndItsTrend(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	assessment, err := domain.NewAssessment(uuid.NewString(), f.tenantID,
		assessmentInput(), "diet-1", at)
	if err != nil {
		t.Fatalf("NewAssessment: %v", err)
	}
	if err := f.repo.InsertAssessment(ctx, f.scope, assessment); err != nil {
		t.Fatalf("InsertAssessment: %v", err)
	}

	plan, err := domain.NewCarePlan(uuid.NewString(), f.tenantID,
		domain.NewCarePlanInput{
			PatientID: "p1", EncounterID: "enc-1",
			AssessmentID: assessment.ID,
			Goals: []domain.NutritionGoal{{
				Code: "weight", Label: "Body weight", Target: 68000,
				Unit: "g", Direction: domain.DirectionIncrease,
				Tolerance: 1000, TargetBy: at.AddDate(0, 1, 0),
			}},
			Plan:      "fortified diet plus two supplements daily",
			ReviewDue: at.AddDate(0, 0, 7),
		}, "diet-1", at)
	if err != nil {
		t.Fatalf("NewCarePlan: %v", err)
	}
	if err := f.repo.InsertCarePlan(ctx, f.scope, plan); err != nil {
		t.Fatalf("InsertCarePlan: %v", err)
	}

	back, err := f.repo.CarePlan(ctx, f.scope, plan.ID)
	if err != nil {
		t.Fatalf("CarePlan: %v", err)
	}
	if len(back.Goals) != 1 || back.Goals[0].Direction !=
		domain.DirectionIncrease || back.Goals[0].Tolerance != 1000 {
		t.Fatalf("goals = %+v — a lost direction reports a patient gaining "+
			"weight as deteriorating", back.Goals)
	}
	if back.AssessmentID != assessment.ID {
		t.Fatal("a plan whose assessment cannot be produced is one nobody " +
			"can review")
	}

	for i, value := range []int{62000, 65000, 67500} {
		progress, err := back.RecordProgress(uuid.NewString(), "weight",
			value, "", "diet-1", at.AddDate(0, 0, i*7), at)
		if err != nil {
			t.Fatalf("RecordProgress: %v", err)
		}
		if err := f.repo.AppendProgress(ctx, f.scope, progress); err != nil {
			t.Fatalf("AppendProgress: %v", err)
		}
	}

	measured, err := f.repo.Progress(ctx, f.scope, plan.ID, "weight")
	if err != nil {
		t.Fatalf("Progress: %v", err)
	}
	trend, found := domain.TrendFor(back, measured, "weight")
	if !found || len(trend.Points) != 3 {
		t.Fatalf("trend = %+v", trend)
	}
	if !trend.Met || !trend.Improving {
		t.Fatalf("67.5 kg against a 68.0 kg target with a 1.0 kg "+
			"tolerance: met=%v improving=%v", trend.Met, trend.Improving)
	}

	if err := back.Close("discharged on oral supplements", "diet-1",
		at.AddDate(0, 0, 21)); err != nil {
		t.Fatalf("Close: %v", err)
	}
	if err := f.repo.CloseCarePlan(ctx, f.scope, back,
		back.Version); err != nil {
		t.Fatalf("CloseCarePlan: %v", err)
	}
	if err := f.repo.CloseCarePlan(ctx, f.scope, back,
		back.Version); err == nil {
		t.Fatal("a stale close was accepted")
	}

	// The same measure twice on one plan is two targets, and progress
	// against it is whichever the reader picked.
	f.mustFail(t, "care_plan_goal_code_idx",
		`INSERT INTO hospital_ops_diet.care_plan_goal (
			goal_id, tenant_id, plan_id, code, unit, direction
		) VALUES ($1, $2, $3, 'Weight', 'g', 'increase')`,
		uuid.New(), f.tenantID, plan.ID)

	f.mustFail(t, "a_closed_plan_says_how_it_ended",
		`INSERT INTO hospital_ops_diet.care_plan (
			plan_id, tenant_id, patient_id, assessment_id, state,
			created_at, created_by
		) VALUES ($1, $2, 'p1', $3, 'closed', $4, 'diet-1')`,
		uuid.New(), f.tenantID, assessment.ID, at)
}

// SRS-DIET-003, SRS-DIET-008. The menu answers what is on the tray, and the
// forecast comes out of the frozen census.
func TestTheMenuAnswersWhatIsOnTheTrayAndWhatItTakes(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	for _, item := range []struct {
		item domain.DietItem
		kind string
	}{
		{domain.DietItem{Code: "OATS", Name: "Rolled oats"}, "ingredient"},
		{domain.DietItem{
			Code: "MILK", Name: "Milk",
			AllergenCodes: []string{"SCT-3718001"},
		}, "ingredient"},
		{domain.DietItem{
			Code: "ONS-1", Name: "Peanut-based supplement",
			AllergenCodes: []string{"SCT-256349002"},
		}, "supplement"},
	} {
		if err := f.repo.InsertItem(ctx, f.scope, item.item,
			item.kind); err != nil {
			t.Fatalf("InsertItem: %v", err)
		}
	}

	recipe := domain.Recipe{
		Code: "R-100", Name: "Porridge",
		Ingredients: []domain.IngredientQuantity{
			{Code: "OATS", Name: "Rolled oats", Grams: 60},
			{Code: "MILK", Name: "Milk", Grams: 200},
		},
	}
	if err := f.repo.InsertRecipe(ctx, f.scope, recipe); err != nil {
		t.Fatalf("InsertRecipe: %v", err)
	}
	if err := f.repo.InsertMenuItem(ctx, f.scope, domain.MenuItem{
		Cycle: domain.CycleBreakfast, TextureCode: "IDDSI-7",
		Recipe: recipe, Portions: 1,
	}); err != nil {
		t.Fatalf("InsertMenuItem: %v", err)
	}

	// Everything the kitchen could put in front of this patient: the
	// porridge's ingredients at this texture, and the supplement the order
	// names.
	items, err := f.repo.ItemsForOrder(ctx, f.scope, "IDDSI-7",
		[]string{"ONS-1"})
	if err != nil {
		t.Fatalf("ItemsForOrder: %v", err)
	}
	byCode := map[string]domain.DietItem{}
	for _, item := range items {
		byCode[item.Code] = item
	}
	if len(byCode) != 3 {
		t.Fatalf("items = %+v, want the two ingredients and the supplement",
			items)
	}
	if len(byCode["ONS-1"].AllergenCodes) != 1 {
		t.Fatal("the supplement's allergen codes were lost, which is how " +
			"a peanut supplement reaches a peanut-allergic patient")
	}

	conflicts := domain.CheckConflicts(items, []domain.Allergen{{
		Ref: "al-1", Substance: "peanut",
		Codes: []string{"SCT-256349002"}, Severity: "anaphylaxis",
	}})
	if len(conflicts) != 1 || conflicts[0].AllergyRef != "al-1" {
		t.Fatalf("conflicts = %+v", conflicts)
	}

	order, err := liveOrder(t, f, nil)
	if err != nil {
		t.Fatalf("liveOrder: %v", err)
	}
	census, err := domain.BuildCensus(uuid.NewString(), f.tenantID, "f1",
		"ward-4", domain.CycleBreakfast, at, at.Add(time.Hour),
		[]domain.DietOrder{order}, at, "kitchen-1", at)
	if err != nil {
		t.Fatalf("BuildCensus: %v", err)
	}
	if err := census.Freeze("kitchen-1", at.Add(time.Hour)); err != nil {
		t.Fatalf("Freeze: %v", err)
	}
	if err := f.repo.InsertCensus(ctx, f.scope, census); err != nil {
		t.Fatalf("InsertCensus: %v", err)
	}

	menu, err := f.repo.Menu(ctx, f.scope, domain.CycleBreakfast)
	if err != nil {
		t.Fatalf("Menu: %v", err)
	}
	forecast, err := domain.ForecastIngredients(census, menu)
	if err != nil {
		t.Fatalf("ForecastIngredients: %v", err)
	}
	if len(forecast.Demand) != 2 || forecast.Uncovered != 0 {
		t.Fatalf("forecast = %+v", forecast)
	}

	count, err := domain.RecordConsumption(uuid.NewString(), f.tenantID,
		census.ID, "OATS", 45, "", "kitchen-1", at)
	if err != nil {
		t.Fatalf("RecordConsumption: %v", err)
	}
	if err := f.repo.AppendConsumption(ctx, f.scope, count); err != nil {
		t.Fatalf("AppendConsumption: %v", err)
	}
	counts, err := f.repo.Consumption(ctx, f.scope, census.ID)
	if err != nil {
		t.Fatalf("Consumption: %v", err)
	}
	applied := domain.ApplyConsumption(forecast, counts)
	for _, demand := range applied.Demand {
		if demand.Code != "OATS" {
			continue
		}
		waste, ok := demand.WastageG()
		if !ok || waste != 15 || demand.ForecastG != 60 {
			t.Fatalf("oats = %+v, want the forecast and the count side by "+
				"side", demand)
		}
	}

	// The same ingredient twice in one recipe is two quantities for one
	// thing, and a forecast that adds both.
	var recipeID uuid.UUID
	if err := f.pool.QueryRow(ctx,
		`SELECT recipe_id FROM hospital_ops_diet.recipe
		 WHERE tenant_id = $1`, f.tenantID).Scan(&recipeID); err != nil {
		t.Fatalf("recipe lookup: %v", err)
	}
	f.mustFail(t, "recipe_ingredient_code_idx",
		`INSERT INTO hospital_ops_diet.recipe_ingredient (
			ingredient_id, tenant_id, recipe_id, code, grams
		) VALUES ($1, $2, $3, 'oats', 20)`,
		uuid.New(), f.tenantID, recipeID)

	f.mustFail(t, "menu_item_portions_check",
		`INSERT INTO hospital_ops_diet.menu_item (
			menu_item_id, tenant_id, recipe_id, cycle, texture_code, portions
		) VALUES ($1, $2, $3, 'lunch', 'IDDSI-7', 0)`,
		uuid.New(), f.tenantID, recipeID)

	f.mustFail(t, "ingredient_consumption_actual_g_check",
		`INSERT INTO hospital_ops_diet.ingredient_consumption (
			consumption_id, tenant_id, census_id, ingredient_code, actual_g,
			recorded_at, recorded_by
		) VALUES ($1, $2, $3, 'OATS', -1, $4, 'kitchen-1')`,
		uuid.New(), f.tenantID, census.ID, at)
}
