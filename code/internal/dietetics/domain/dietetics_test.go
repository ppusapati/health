package domain_test

import (
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/dietetics/domain"
)

// The dietetics and kitchen rules.
//
// Every refusal below is a rule somebody could otherwise remove, so each is
// tested by weakening it: the assertion is that the domain says no, and the
// comment says what happens to a patient when it says yes.

var at = time.Date(2026, 9, 21, 6, 0, 0, 0, time.UTC)

func refused(t *testing.T, err error, contains string) {
	t.Helper()
	if err == nil {
		t.Fatalf("want a refusal mentioning %q, got none", contains)
	}
	if !strings.Contains(err.Error(), contains) {
		t.Fatalf("want a refusal mentioning %q, got %v", contains, err)
	}
}

// ---------------------------------------------- assessment (SRS-DIET-001)

func assessmentInput() domain.NewAssessmentInput {
	return domain.NewAssessmentInput{
		PatientID: "p1", EncounterID: "enc-1", FacilityID: "f1",
		Anthropometry: domain.Anthropometry{HeightMM: 1650, WeightG: 62000},
		IntakeSummary: "half portions",
		DiagnosisCode: "MAL-2", Diagnosis: "moderate malnutrition",
		Requirement: domain.Requirement{
			EnergyKcal: 1800, ProteinG: 75, FluidML: 2000,
			Basis: "25 kcal/kg, Schofield cross-checked",
		},
		RiskTool: "MUST", RiskScore: 2,
	}
}

func TestAnAssessmentBelongsToAnEncounterAndSaysHowItWasCalculated(
	t *testing.T) {

	// SRS-DIET-001's acceptance. An assessment floating free of an encounter
	// cannot be found by the team looking after the patient.
	in := assessmentInput()
	in.EncounterID = ""
	_, err := domain.NewAssessment("a1", "t1", in, "diet-1", at)
	refused(t, err, "linked to an encounter")

	// A requirement nobody can reproduce is a number, and the next dietitian
	// has to decide whether to believe it.
	in = assessmentInput()
	in.Requirement.Basis = ""
	_, err = domain.NewAssessment("a1", "t1", in, "diet-1", at)
	refused(t, err, "how the requirement was calculated")

	// A score of 3 means malnourished in one tool and at risk in another.
	in = assessmentInput()
	in.RiskTool = ""
	_, err = domain.NewAssessment("a1", "t1", in, "diet-1", at)
	refused(t, err, "names the tool")

	in = assessmentInput()
	in.Anthropometry.WeightG = -1
	_, err = domain.NewAssessment("a1", "t1", in, "diet-1", at)
	refused(t, err, "cannot be negative")

	in = assessmentInput()
	in.Requirement.ProteinG = -1
	_, err = domain.NewAssessment("a1", "t1", in, "diet-1", at)
	refused(t, err, "cannot be negative")

	assessment, err := domain.NewAssessment("a1", "t1", assessmentInput(),
		"diet-1", at)
	if err != nil {
		t.Fatalf("NewAssessment: %v", err)
	}
	if assessment.State != domain.AssessmentDraft {
		t.Fatalf("state = %q, want draft", assessment.State)
	}
	if assessment.Anthropometry.MeasuredAt.IsZero() {
		t.Fatal("a measurement with no time cannot be trended")
	}
}

func TestBodyMassIndexIsDerivedFromWhatWasMeasured(t *testing.T) {
	// A stored BMI sitting beside a height and weight that no longer agree
	// with it is a third number nobody can explain.
	a := domain.Anthropometry{HeightMM: 1650, WeightG: 62000}
	if got := a.BMITenths(); got != 227 {
		t.Fatalf("BMI = %d tenths, want 227 (62.0 kg at 1.65 m)", got)
	}

	// Change the weight and the index moves with it, because there is no
	// second copy to go stale.
	a.WeightG = 90000
	if got := a.BMITenths(); got != 330 {
		t.Fatalf("BMI = %d tenths, want 330 (90.0 kg at 1.65 m)", got)
	}

	// Nothing measured computes nothing rather than zero, and a caller has
	// to tell the difference: there is no patient with a BMI of zero.
	if got := (domain.Anthropometry{}).BMITenths(); got != 0 {
		t.Fatalf("BMI of an unmeasured patient = %d", got)
	}
	if (domain.Anthropometry{HeightMM: 1650}).Measured() {
		t.Fatal("a height with no weight reads as measured")
	}
}

func TestASignedAssessmentNamesWhoSignedItAndHasSomethingInIt(t *testing.T) {
	in := assessmentInput()
	in.Anthropometry = domain.Anthropometry{}
	empty, err := domain.NewAssessment("a1", "t1", in, "diet-1", at)
	if err != nil {
		t.Fatalf("NewAssessment: %v", err)
	}
	// Signed with nothing measured at all is an assessment of nobody.
	refused(t, empty.Sign("diet-1", at), "at least one measurement")

	// Mid-upper arm alone is accepted: in critical care it is often the only
	// thing there is, and refusing it would mean those patients go
	// unassessed.
	in.Anthropometry = domain.Anthropometry{MidUpperArmMM: 210}
	arm, err := domain.NewAssessment("a2", "t1", in, "diet-1", at)
	if err != nil {
		t.Fatalf("NewAssessment: %v", err)
	}
	if err := arm.Sign("diet-1", at); err != nil {
		t.Fatalf("Sign with a mid-upper arm measurement: %v", err)
	}

	assessment, err := domain.NewAssessment("a3", "t1", assessmentInput(),
		"diet-1", at)
	if err != nil {
		t.Fatalf("NewAssessment: %v", err)
	}
	refused(t, assessment.Sign("", at), "names who made it")
	if err := assessment.Sign("diet-1", at); err != nil {
		t.Fatalf("Sign: %v", err)
	}
	refused(t, assessment.Sign("diet-2", at), "already signed")
}

// --------------------------------------- diet orders (SRS-DIET-002, 003)

func orderInput() domain.NewOrderInput {
	return domain.NewOrderInput{
		PatientID: "p1", EncounterID: "enc-1", FacilityID: "f1",
		WardID: "ward-4", BedID: "b12",
		Route: domain.RouteOral,
		Texture: domain.Texture{
			Code: "IDDSI-7", Label: "Regular", FluidCode: "IDDSI-0",
		},
		Restrictions:  []string{"low_sodium"},
		EffectiveFrom: at,
	}
}

func TestAnOralOrderSaysWhatThePatientCanManage(t *testing.T) {
	// A dysphagic patient sent a normal tray is an aspiration.
	in := orderInput()
	in.Texture.Code = ""
	_, err := domain.PlaceDietOrder("o1", "t1", in, nil, "doc-1", at)
	refused(t, err, "names the texture")

	// Nil by mouth with a renal restriction attached is an order two people
	// read two ways, and one of them sends a tray.
	in = orderInput()
	in.Route = domain.RouteNPO
	in.Texture = domain.Texture{}
	in.Supplements = []string{"ONS-1"}
	_, err = domain.PlaceDietOrder("o1", "t1", in, nil, "doc-1", at)
	refused(t, err, "carries no restrictions or supplements")

	// An order with no effective time cannot be the one in force, which is
	// the whole of SRS-DIET-002 and SRS-DIET-009.
	in = orderInput()
	in.EffectiveFrom = time.Time{}
	_, err = domain.PlaceDietOrder("o1", "t1", in, nil, "doc-1", at)
	refused(t, err, "needs an effective time")

	in = orderInput()
	in.EffectiveTo = at.Add(-time.Hour)
	_, err = domain.PlaceDietOrder("o1", "t1", in, nil, "doc-1", at)
	refused(t, err, "ends before it starts")

	in = orderInput()
	in.Route = "smuggled"
	_, err = domain.PlaceDietOrder("o1", "t1", in, nil, "doc-1", at)
	refused(t, err, "unknown route")
}

func TestTheKitchenSeesOneCurrentOrderAndNeverAPendingOne(t *testing.T) {
	first, err := domain.PlaceDietOrder("o1", "t1", orderInput(), nil,
		"doc-1", at)
	if err != nil {
		t.Fatalf("PlaceDietOrder: %v", err)
	}
	if first.State != domain.OrderActive {
		t.Fatalf("state = %q, want active", first.State)
	}

	later := orderInput()
	later.EffectiveFrom = at.Add(2 * time.Hour)
	later.Texture.Code = "IDDSI-4"
	second, err := domain.PlaceDietOrder("o2", "t1", later, nil, "doc-1",
		at.Add(time.Hour))
	if err != nil {
		t.Fatalf("PlaceDietOrder: %v", err)
	}

	// Before the second is effective, the first is what the kitchen cooks to.
	inForce, found := domain.OrderInForce([]domain.DietOrder{first, second},
		at.Add(time.Hour))
	if !found || inForce.ID != "o1" {
		t.Fatalf("in force at +1h = %+v, want the first order", inForce)
	}
	// After it, the second. One, never both: a kitchen shown two current
	// orders for one patient plates whichever is on top.
	inForce, found = domain.OrderInForce([]domain.DietOrder{first, second},
		at.Add(3*time.Hour))
	if !found || inForce.ID != "o2" {
		t.Fatalf("in force at +3h = %+v, want the second order", inForce)
	}

	// An order with an unresolved allergy conflict is pending, and pending
	// is never in force.
	pending, err := domain.PlaceDietOrder("o3", "t1", orderInput(),
		[]domain.Conflict{{AllergyRef: "al-1", Substance: "peanut",
			Item: "Satay chicken", Severity: "anaphylaxis"}},
		"doc-1", at)
	if err != nil {
		t.Fatalf("PlaceDietOrder: %v", err)
	}
	if pending.State != domain.OrderPending {
		t.Fatalf("state = %q, want pending", pending.State)
	}
	if pending.InForce(at) {
		t.Fatal("an order with an open allergy conflict reached the kitchen")
	}
}

func TestACancelledDietStopsNowAndNotAtMidnight(t *testing.T) {
	order, err := domain.PlaceDietOrder("o1", "t1", orderInput(), nil,
		"doc-1", at)
	if err != nil {
		t.Fatalf("PlaceDietOrder: %v", err)
	}
	refused(t, order.Cancel("", "doc-1", at), "say why")
	refused(t, order.Cancel("for theatre", "", at), "names who made it")

	cancelAt := at.Add(30 * time.Minute)
	if err := order.Cancel("for theatre", "doc-1", cancelAt); err != nil {
		t.Fatalf("Cancel: %v", err)
	}
	// A cancellation that leaves the order in force until midnight is a
	// cancellation that sends supper.
	if !order.EffectiveTo.Equal(cancelAt) {
		t.Fatalf("effective to = %v, want the moment it was cancelled",
			order.EffectiveTo)
	}
	if order.InForce(cancelAt.Add(time.Minute)) {
		t.Fatal("a cancelled diet is still in force")
	}
	refused(t, order.Cancel("again", "doc-1", cancelAt), "already cancelled")
}

func TestAnAllergyConflictIsMatchedOnCodesAndResolvedWithAReason(
	t *testing.T) {

	allergens := []domain.Allergen{{
		Ref: "al-1", Substance: "peanut", Codes: []string{"SCT-256349002"},
		Severity: "anaphylaxis",
	}}

	// Matched on the code, not the display. "Groundnut oil" contains neither
	// the word peanut nor anything a string comparison would catch, and a
	// check that compared displays would put it straight in front of a
	// patient who is anaphylactic to it.
	coded := []domain.DietItem{{
		Code: "R-441", Name: "Groundnut oil dressing",
		AllergenCodes: []string{"SCT-256349002"},
	}}
	conflicts := domain.CheckConflicts(coded, allergens)
	if len(conflicts) != 1 || conflicts[0].AllergyRef != "al-1" {
		t.Fatalf("conflicts = %+v, want the coded match", conflicts)
	}

	// A deployment whose item list is not coded yet gets a noisy name match
	// somebody has to resolve, which is the safe direction. What it must
	// never do is find nothing because nothing was coded.
	uncoded := []domain.DietItem{{Code: "R-9", Name: "Peanut satay"}}
	if got := domain.CheckConflicts(uncoded, allergens); len(got) != 1 {
		t.Fatalf("an uncoded item slipped past: %+v", got)
	}

	// And something unrelated does not fire.
	if got := domain.CheckConflicts(
		[]domain.DietItem{{Code: "R-1", Name: "Steamed rice"}},
		allergens); len(got) != 0 {
		t.Fatalf("spurious conflict: %+v", got)
	}

	order, err := domain.PlaceDietOrder("o1", "t1", orderInput(),
		conflicts, "doc-1", at)
	if err != nil {
		t.Fatalf("PlaceDietOrder: %v", err)
	}

	// "Resolved by Dr Rao" is not an answer to why a patient with a
	// documented peanut allergy is being given a peanut dressing.
	refused(t, order.ResolveConflict("al-1", "", "", "doc-2", at),
		"why this item is safe")
	refused(t, order.ResolveConflict("al-1", "", "checked", "", at),
		"names who authorised it")
	refused(t, order.ResolveConflict("al-999", "", "checked", "doc-2", at),
		"no open conflict")

	if err := order.ResolveConflict("al-1", "", "reaction was to the shell",
		"doc-2", at); err != nil {
		t.Fatalf("ResolveConflict: %v", err)
	}
	if order.State != domain.OrderActive {
		t.Fatalf("state = %q, want active once nothing is open", order.State)
	}
	if len(order.OpenConflicts()) != 0 {
		t.Fatalf("open conflicts remain: %+v", order.OpenConflicts())
	}
}

// ------------------------------------------- meal census (SRS-DIET-005)

func wardOrders(t *testing.T) []domain.DietOrder {
	t.Helper()

	oral, err := domain.PlaceDietOrder("o1", "t1", orderInput(), nil,
		"doc-1", at)
	if err != nil {
		t.Fatalf("PlaceDietOrder: %v", err)
	}

	npoInput := orderInput()
	npoInput.PatientID = "p2"
	npoInput.BedID = "b13"
	npoInput.Route = domain.RouteNPO
	npoInput.Texture = domain.Texture{}
	npoInput.Restrictions = nil
	npo, err := domain.PlaceDietOrder("o2", "t1", npoInput, nil, "doc-1", at)
	if err != nil {
		t.Fatalf("PlaceDietOrder: %v", err)
	}

	tubeInput := orderInput()
	tubeInput.PatientID = "p3"
	tubeInput.BedID = "b14"
	tubeInput.Route = domain.RouteEnteral
	tubeInput.Texture = domain.Texture{}
	tubeInput.Restrictions = nil
	tube, err := domain.PlaceDietOrder("o3", "t1", tubeInput, nil, "doc-1", at)
	if err != nil {
		t.Fatalf("PlaceDietOrder: %v", err)
	}

	return []domain.DietOrder{oral, npo, tube}
}

func TestACensusPlatesOnlyThePatientsWhoEat(t *testing.T) {
	census, err := domain.BuildCensus("c1", "t1", "f1", "ward-4",
		domain.CycleBreakfast, at, at.Add(time.Hour), wardOrders(t), at,
		"kitchen-1", at)
	if err != nil {
		t.Fatalf("BuildCensus: %v", err)
	}
	if len(census.Lines) != 1 || census.Lines[0].PatientID != "p1" {
		t.Fatalf("lines = %+v, want only the oral patient", census.Lines)
	}
	if census.Lines[0].OrderID != "o1" {
		t.Fatal("a census line that does not pin its order cannot answer " +
			"what the kitchen cooked to")
	}

	// A census with no cutoff never freezes, and a census that never freezes
	// is a count nobody can be held to.
	_, err = domain.BuildCensus("c2", "t1", "f1", "ward-4",
		domain.CycleBreakfast, at, time.Time{}, wardOrders(t), at,
		"kitchen-1", at)
	refused(t, err, "production cutoff")

	_, err = domain.BuildCensus("c2", "t1", "f1", "", domain.CycleBreakfast,
		at, at.Add(time.Hour), nil, at, "kitchen-1", at)
	refused(t, err, "names its ward")

	_, err = domain.BuildCensus("c2", "t1", "f1", "ward-4", "brunch",
		at, at.Add(time.Hour), nil, at, "kitchen-1", at)
	refused(t, err, "unknown meal cycle")
}

func TestAFrozenCensusIsReissuedRatherThanEdited(t *testing.T) {
	census, err := domain.BuildCensus("c1", "t1", "f1", "ward-4",
		domain.CycleBreakfast, at, at.Add(time.Hour), wardOrders(t), at,
		"kitchen-1", at)
	if err != nil {
		t.Fatalf("BuildCensus: %v", err)
	}

	// A draft census is not something to reissue; it is something to rebuild.
	_, err = census.Reissue("c2", wardOrders(t), at, "kitchen-1", at)
	refused(t, err, "has not been frozen")

	refused(t, census.Freeze("", at), "names who made it")
	if err := census.Freeze("kitchen-1", at.Add(time.Hour)); err != nil {
		t.Fatalf("Freeze: %v", err)
	}
	refused(t, census.Freeze("kitchen-1", at), "already frozen")

	// A ward that admits a patient after cutoff gets another tray, and the
	// hospital keeps both answers to what the kitchen cooked to.
	extra := orderInput()
	extra.PatientID = "p9"
	extra.BedID = "b20"
	admitted, err := domain.PlaceDietOrder("o9", "t1", extra, nil, "doc-1",
		at.Add(2*time.Hour))
	if err != nil {
		t.Fatalf("PlaceDietOrder: %v", err)
	}
	next, err := census.Reissue("c2", append(wardOrders(t), admitted),
		at.Add(2*time.Hour), "kitchen-1", at.Add(2*time.Hour))
	if err != nil {
		t.Fatalf("Reissue: %v", err)
	}
	switch {
	case next.Version != 2:
		t.Fatalf("version = %d, want 2", next.Version)
	case next.SupersedesID != "c1":
		t.Fatalf("supersedes = %q, want c1", next.SupersedesID)
	case len(next.Lines) != 2:
		t.Fatalf("lines = %+v, want the original and the admission",
			next.Lines)
	case census.Version != 1 || len(census.Lines) != 1:
		t.Fatal("the frozen census changed underneath the reissue")
	}
}

// ------------------------- trays, dispatch and nil by mouth (SRS-DIET-009)

func platedTray(t *testing.T) (domain.Tray, domain.CensusLine,
	domain.DietOrder) {

	t.Helper()
	orders := wardOrders(t)
	census, err := domain.BuildCensus("c1", "t1", "f1", "ward-4",
		domain.CycleBreakfast, at, at.Add(time.Hour), orders, at,
		"kitchen-1", at)
	if err != nil {
		t.Fatalf("BuildCensus: %v", err)
	}
	if err := census.Freeze("kitchen-1", at.Add(time.Hour)); err != nil {
		t.Fatalf("Freeze: %v", err)
	}
	line := census.Lines[0]
	tray, err := domain.NewTray("tr1", "t1", census, line,
		at.Add(3*time.Hour))
	if err != nil {
		t.Fatalf("NewTray: %v", err)
	}
	if err := tray.Prepare("kitchen-1", at.Add(90*time.Minute)); err != nil {
		t.Fatalf("Prepare: %v", err)
	}
	return tray, line, orders[0]
}

func TestATrayIsCheckedAgainstTheOrderInForceWhenItLeavesTheKitchen(
	t *testing.T) {

	dispatchAt := at.Add(2 * time.Hour)

	// The ordinary case: nothing changed, the tray goes.
	tray, line, order := platedTray(t)
	if err := tray.Dispatch(order, true, line, "porter-1",
		dispatchAt); err != nil {
		t.Fatalf("Dispatch: %v", err)
	}
	if tray.State != domain.TrayDispatched {
		t.Fatalf("state = %q", tray.State)
	}

	// Nil by mouth for a theatre list. This is the one that matters: the
	// census was taken at five and the patient was made NPO at six, and a
	// kitchen that dispatches what the census said sends breakfast to
	// somebody about to be anaesthetised.
	tray, line, order = platedTray(t)
	npo := order
	if err := npo.Cancel("for theatre", "doc-1", at.Add(90*time.Minute)); err != nil {
		t.Fatalf("Cancel: %v", err)
	}
	npoInput := orderInput()
	npoInput.Route = domain.RouteNPO
	npoInput.Texture = domain.Texture{}
	npoInput.Restrictions = nil
	npoInput.EffectiveFrom = at.Add(90 * time.Minute)
	fasting, err := domain.PlaceDietOrder("o-npo", "t1", npoInput, nil,
		"doc-1", at.Add(90*time.Minute))
	if err != nil {
		t.Fatalf("PlaceDietOrder: %v", err)
	}
	refused(t, tray.Dispatch(fasting, true, line, "porter-1", dispatchAt),
		"nil by mouth")
	if tray.State == domain.TrayDispatched {
		t.Fatal("a refused dispatch left the tray marked as sent")
	}

	// No order at all — the patient was discharged.
	tray, line, _ = platedTray(t)
	refused(t, tray.Dispatch(domain.DietOrder{}, false, line, "porter-1",
		dispatchAt), "no diet order is in force")

	// Downgraded to a pureed texture after a swallow assessment. The plated
	// tray is the wrong food for this patient now.
	tray, line, order = platedTray(t)
	thickened := order
	thickened.Texture.Code = "IDDSI-4"
	refused(t, tray.Dispatch(thickened, true, line, "porter-1", dispatchAt),
		"texture changed")

	tray, line, order = platedTray(t)
	fluids := order
	fluids.Texture.FluidCode = "IDDSI-2"
	refused(t, tray.Dispatch(fluids, true, line, "porter-1", dispatchAt),
		"fluid level changed")

	tray, line, order = platedTray(t)
	renal := order
	renal.Restrictions = []string{"low_sodium", "renal"}
	refused(t, tray.Dispatch(renal, true, line, "porter-1", dispatchAt),
		"restrictions changed")

	// Switched to tube feeding.
	tray, line, order = platedTray(t)
	tube := order
	tube.Route = domain.RouteEnteral
	refused(t, tray.Dispatch(tube, true, line, "porter-1", dispatchAt),
		"enteral route")
}

func TestATrayMovesThroughItsStatesAndSaysWhyItStopped(t *testing.T) {
	tray, line, order := platedTray(t)

	// Dispatching something nobody plated.
	fresh := tray
	fresh.State = domain.TrayPlanned
	refused(t, fresh.Dispatch(order, true, line, "porter-1", at),
		"has not been prepared")

	// Held back, with the reason the ward needs so the meal does not simply
	// look like it went astray.
	held := tray
	refused(t, held.Withhold("", "porter-1", at), "say why")
	if err := held.Withhold("patient is nil by mouth", "porter-1",
		at); err != nil {
		t.Fatalf("Withhold: %v", err)
	}
	if held.State != domain.TrayWithheld || held.Reason == "" {
		t.Fatalf("withheld tray = %+v", held)
	}

	// Delivered only from dispatched.
	notSent := tray
	refused(t, notSent.Deliver("nurse-1", at), "was not dispatched")

	if err := tray.Dispatch(order, true, line, "porter-1",
		at.Add(2*time.Hour)); err != nil {
		t.Fatalf("Dispatch: %v", err)
	}
	if err := tray.Deliver("nurse-1", at.Add(150*time.Minute)); err != nil {
		t.Fatalf("Deliver: %v", err)
	}

	// A patient who has not eaten needs a reason recorded: three of these in
	// a row is a referral rather than a logistics note.
	missed, _, _ := platedTray(t)
	refused(t, missed.Close(domain.TrayMissed, "", "nurse-1", at), "say why")
	refused(t, missed.Close("vanished", "off the trolley", "nurse-1", at),
		"refused or missed")
	if err := missed.Close(domain.TrayMissed, "patient off the ward",
		"nurse-1", at); err != nil {
		t.Fatalf("Close: %v", err)
	}
	refused(t, missed.Close(domain.TrayRefused, "again", "nurse-1", at),
		"already")
}

func TestAServiceCountsLateSeparatelyFromMissed(t *testing.T) {
	due := at.Add(3 * time.Hour)
	delivered := domain.Tray{State: domain.TrayDelivered, DueBy: due,
		DeliveredAt: due.Add(90 * time.Minute)}
	onTime := domain.Tray{State: domain.TrayDelivered, DueBy: due,
		DeliveredAt: due.Add(-time.Minute)}
	stuck := domain.Tray{State: domain.TrayPrepared, DueBy: due}
	missed := domain.Tray{State: domain.TrayMissed, DueBy: due}
	withheld := domain.Tray{State: domain.TrayWithheld, DueBy: due}

	out := domain.SummariseMeals([]domain.Tray{
		delivered, onTime, stuck, missed, withheld}, due.Add(time.Hour))

	switch {
	case out.Planned != 5:
		t.Fatalf("planned = %d", out.Planned)
	case out.Delivered != 2:
		t.Fatalf("delivered = %d", out.Delivered)
	case out.Missed != 1:
		t.Fatalf("missed = %d", out.Missed)
	case out.Withheld != 1:
		t.Fatalf("withheld = %d", out.Withheld)
	case out.Outstanding != 1:
		t.Fatalf("outstanding = %d", out.Outstanding)
	// A lunch at four is a different failure from a lunch that never came,
	// and the one still in the kitchen is counted now so a ward can do
	// something about it.
	case out.Late != 2:
		t.Fatalf("late = %d, want the late delivery and the stuck tray",
			out.Late)
	}
}

// ------------------------------------------- care plans (SRS-DIET-004)

func planInput() domain.NewCarePlanInput {
	return domain.NewCarePlanInput{
		PatientID: "p1", EncounterID: "enc-1", AssessmentID: "a1",
		Goals: []domain.NutritionGoal{{
			Code: "weight", Label: "Body weight", Target: 68000,
			Unit: "g", Direction: domain.DirectionIncrease, Tolerance: 1000,
		}},
		Plan: "fortified diet plus two supplements daily",
	}
}

func TestACarePlanNamesItsAssessmentAndSaysWhichWayEachGoalMoves(
	t *testing.T) {

	in := planInput()
	in.AssessmentID = ""
	_, err := domain.NewCarePlan("cp1", "t1", in, "diet-1", at)
	refused(t, err, "names the assessment")

	in = planInput()
	in.Goals = nil
	_, err = domain.NewCarePlan("cp1", "t1", in, "diet-1", at)
	refused(t, err, "what it is trying to achieve")

	// "Target 60" is gain for one patient and loss for another, and a trend
	// that assumed one would report the other as deteriorating.
	in = planInput()
	in.Goals[0].Direction = ""
	_, err = domain.NewCarePlan("cp1", "t1", in, "diet-1", at)
	refused(t, err, "which way")

	in = planInput()
	in.Goals[0].Unit = ""
	_, err = domain.NewCarePlan("cp1", "t1", in, "diet-1", at)
	refused(t, err, "needs a unit")

	in = planInput()
	in.Goals[0].Tolerance = -1
	_, err = domain.NewCarePlan("cp1", "t1", in, "diet-1", at)
	refused(t, err, "negative tolerance")

	// The same measure twice is two targets, and progress against it is
	// whichever the reader picked.
	in = planInput()
	in.Goals = append(in.Goals, in.Goals[0])
	_, err = domain.NewCarePlan("cp1", "t1", in, "diet-1", at)
	refused(t, err, "appears twice")
}

func TestProgressIsMeasuredAgainstAGoalThePlanActuallyHas(t *testing.T) {
	plan, err := domain.NewCarePlan("cp1", "t1", planInput(), "diet-1", at)
	if err != nil {
		t.Fatalf("NewCarePlan: %v", err)
	}

	// A measurement against a goal the plan does not have appears in no
	// trend and answers no review.
	_, err = plan.RecordProgress("pr1", "albumin", 30, "", "diet-1", at, at)
	refused(t, err, "no goal")

	_, err = plan.RecordProgress("pr1", "weight", 62000, "", "", at, at)
	refused(t, err, "names who took it")

	first, err := plan.RecordProgress("pr1", "weight", 62000, "", "diet-1",
		at, at)
	if err != nil {
		t.Fatalf("RecordProgress: %v", err)
	}
	second, err := plan.RecordProgress("pr2", "weight", 65000, "", "diet-1",
		at.AddDate(0, 0, 7), at)
	if err != nil {
		t.Fatalf("RecordProgress: %v", err)
	}

	trend, found := domain.TrendFor(plan, []domain.Progress{second, first},
		"weight")
	if !found {
		t.Fatal("TrendFor did not find the goal")
	}
	switch {
	case len(trend.Points) != 2:
		t.Fatalf("points = %+v", trend.Points)
	case !trend.Points[0].At.Before(trend.Points[1].At):
		t.Fatal("a trend out of order is not a trend")
	case trend.Met:
		t.Fatal("65.0 kg against a 68.0 kg target reads as met")
	case !trend.Improving:
		t.Fatal("a patient gaining weight against a gain goal reads as " +
			"deteriorating")
	case trend.Unanswerable:
		t.Fatal("a trend with two points reads as unanswerable")
	}

	// Inside the tolerance is met. Exactly the target is almost never what
	// anybody means about a body weight.
	third, err := plan.RecordProgress("pr3", "weight", 67500, "", "diet-1",
		at.AddDate(0, 0, 14), at)
	if err != nil {
		t.Fatalf("RecordProgress: %v", err)
	}
	trend, _ = domain.TrendFor(plan, []domain.Progress{first, second, third},
		"weight")
	if !trend.Met {
		t.Fatal("67.5 kg against 68.0 kg with a 1.0 kg tolerance is met")
	}

	// A goal with nothing measured is unanswerable rather than a flat line
	// at zero, which reads as a patient whose weight is nothing.
	empty, _ := domain.TrendFor(plan, nil, "weight")
	if !empty.Unanswerable || len(empty.Points) != 0 {
		t.Fatalf("empty trend = %+v", empty)
	}
	if _, found := domain.TrendFor(plan, nil, "albumin"); found {
		t.Fatal("TrendFor invented a goal")
	}

	refused(t, plan.Close("", "diet-1", at), "say how the plan ended")
	if err := plan.Close("discharged on oral supplements", "diet-1",
		at); err != nil {
		t.Fatalf("Close: %v", err)
	}
	refused(t, plan.Close("again", "diet-1", at), "already closed")
	_, err = plan.RecordProgress("pr4", "weight", 68000, "", "diet-1", at, at)
	refused(t, err, "closed")
}

// --------------------------------- nutrition support (SRS-DIET-007)

func TestASupportPlanGoesActiveOnlyAgainstAnOrderSomewhereElse(t *testing.T) {
	in := domain.NewSupportPlanInput{
		PatientID: "p1", EncounterID: "enc-1",
		Kind: domain.SupportParenteral, FormulaCode: "TPN-STD",
		FormulaName: "Standard TPN", TargetVolumeML: 1500,
		TargetEnergyKcal: 1400, TargetProteinG: 70,
		RampPlan: "50% day one for refeeding risk",
	}
	plan, err := domain.PlanNutritionSupport("sp1", "t1", in, "diet-1", at)
	if err != nil {
		t.Fatalf("PlanNutritionSupport: %v", err)
	}
	// Nothing is running. This state exists precisely so a plan cannot be
	// mistaken for a feed.
	if plan.State != domain.SupportPlanned {
		t.Fatalf("state = %q, want planned", plan.State)
	}

	// A hospital where a dietitian's plan alone starts a feed is a hospital
	// where parenteral nutrition bypasses pharmacy.
	refused(t, plan.LinkOrder("", "medication", at), "not on its own")
	// "Order 4471" means one thing in orders and another in medication.
	refused(t, plan.LinkOrder("rx-4471", "", at), "which context owns")

	if err := plan.LinkOrder("rx-4471", "medication", at); err != nil {
		t.Fatalf("LinkOrder: %v", err)
	}
	if plan.State != domain.SupportActive || plan.OrderRef != "rx-4471" {
		t.Fatalf("plan = %+v", plan)
	}

	refused(t, plan.Stop("", "diet-1", at), "say why")
	if err := plan.Stop("oral intake adequate", "diet-1", at); err != nil {
		t.Fatalf("Stop: %v", err)
	}
	refused(t, plan.Stop("again", "diet-1", at), "already stopped")
	refused(t, plan.LinkOrder("rx-2", "medication", at), "stopped")

	bad := in
	bad.FormulaCode = ""
	_, err = domain.PlanNutritionSupport("sp2", "t1", bad, "diet-1", at)
	refused(t, err, "names the formula")

	bad = in
	bad.Kind = "intravenous-ish"
	_, err = domain.PlanNutritionSupport("sp2", "t1", bad, "diet-1", at)
	refused(t, err, "unknown nutrition support kind")

	bad = in
	bad.TargetEnergyKcal = -1
	_, err = domain.PlanNutritionSupport("sp2", "t1", bad, "diet-1", at)
	refused(t, err, "cannot be negative")
}

// -------------------------------- ingredients and wastage (SRS-DIET-008)

func frozenCensus(t *testing.T) domain.MealCensus {
	t.Helper()
	census, err := domain.BuildCensus("c1", "t1", "f1", "ward-4",
		domain.CycleBreakfast, at, at.Add(time.Hour), wardOrders(t), at,
		"kitchen-1", at)
	if err != nil {
		t.Fatalf("BuildCensus: %v", err)
	}
	if err := census.Freeze("kitchen-1", at.Add(time.Hour)); err != nil {
		t.Fatalf("Freeze: %v", err)
	}
	return census
}

func TestAForecastComesFromTheFrozenCensusAndStaysApartFromWhatWasUsed(
	t *testing.T) {

	menu := []domain.MenuItem{{
		Cycle: domain.CycleBreakfast, TextureCode: "IDDSI-7", Portions: 1,
		Recipe: domain.Recipe{
			Code: "R-100", Name: "Porridge",
			Ingredients: []domain.IngredientQuantity{
				{Code: "OATS", Name: "Rolled oats", Grams: 60},
				{Code: "MILK", Name: "Milk", Grams: 200},
			},
		},
	}}

	// A forecast against a moving count is a purchase order nobody can check.
	draft, err := domain.BuildCensus("c0", "t1", "f1", "ward-4",
		domain.CycleBreakfast, at, at.Add(time.Hour), wardOrders(t), at,
		"kitchen-1", at)
	if err != nil {
		t.Fatalf("BuildCensus: %v", err)
	}
	_, err = domain.ForecastIngredients(draft, menu)
	refused(t, err, "frozen census")

	census := frozenCensus(t)
	forecast, err := domain.ForecastIngredients(census, menu)
	if err != nil {
		t.Fatalf("ForecastIngredients: %v", err)
	}
	if forecast.CensusVersion != census.Version {
		t.Fatal("a forecast that does not pin its census version cannot be " +
			"reconciled with either")
	}
	if len(forecast.Demand) != 2 || forecast.Demand[0].Code != "MILK" {
		t.Fatalf("demand = %+v", forecast.Demand)
	}
	if forecast.Demand[1].ForecastG != 60 {
		t.Fatalf("oats = %d g for one tray", forecast.Demand[1].ForecastG)
	}
	// A forecast that silently ignored the trays no menu item covers is a
	// kitchen that runs out.
	bare, err := domain.ForecastIngredients(census, nil)
	if err != nil {
		t.Fatalf("ForecastIngredients: %v", err)
	}
	if bare.Uncovered != 1 {
		t.Fatalf("uncovered = %d, want the one unmatched tray", bare.Uncovered)
	}

	// Wastage is not meaningful until somebody has counted, and a forecast
	// with no count must not read as a kitchen that wasted everything.
	if _, ok := forecast.Demand[0].WastageG(); ok {
		t.Fatal("wastage was reported against a count nobody took")
	}

	count, err := domain.RecordConsumption("u1", "t1", census.ID, "OATS", 45,
		"", "kitchen-1", at)
	if err != nil {
		t.Fatalf("RecordConsumption: %v", err)
	}
	// An ingredient counted but not forecast is the finding the report
	// exists to surface, so it is added rather than dropped.
	extra, err := domain.RecordConsumption("u2", "t1", census.ID, "SUGAR", 20,
		"", "kitchen-1", at)
	if err != nil {
		t.Fatalf("RecordConsumption: %v", err)
	}

	applied := domain.ApplyConsumption(forecast,
		[]domain.Consumption{count, extra})
	byCode := map[string]domain.IngredientDemand{}
	for _, demand := range applied.Demand {
		byCode[demand.Code] = demand
	}
	oats := byCode["OATS"]
	waste, ok := oats.WastageG()
	if !ok || waste != 15 {
		t.Fatalf("oats wastage = %d (%v), want 15 g", waste, ok)
	}
	// Two numbers, never one: a single variance figure cannot say whether
	// the kitchen over-ordered or over-served.
	if oats.ForecastG != 60 || oats.ActualG != 45 {
		t.Fatalf("oats = %+v, want the forecast and the count side by side",
			oats)
	}
	if sugar, known := byCode["SUGAR"]; !known || sugar.ForecastG != 0 ||
		!sugar.ActualRecorded {
		t.Fatalf("an unforecast ingredient was dropped: %+v", byCode)
	}
	// A count against another service does not land on this one.
	elsewhere, err := domain.RecordConsumption("u3", "t1", "other-census",
		"OATS", 900, "", "kitchen-1", at)
	if err != nil {
		t.Fatalf("RecordConsumption: %v", err)
	}
	unchanged := domain.ApplyConsumption(forecast,
		[]domain.Consumption{elsewhere})
	for _, demand := range unchanged.Demand {
		if demand.Code == "OATS" && demand.ActualG != 45 {
			t.Fatalf("another service's count landed here: %+v", demand)
		}
	}

	_, err = domain.RecordConsumption("u4", "t1", census.ID, "OATS", -1, "",
		"kitchen-1", at)
	refused(t, err, "cannot be negative")
	_, err = domain.RecordConsumption("u4", "t1", census.ID, "", 10, "",
		"kitchen-1", at)
	refused(t, err, "names its ingredient")
	_, err = domain.RecordConsumption("u4", "t1", "", "OATS", 10, "",
		"kitchen-1", at)
	refused(t, err, "names the service")
	_, err = domain.RecordConsumption("u4", "t1", census.ID, "OATS", 10, "",
		"", at)
	refused(t, err, "names who took it")
}

// ------------------------------------------------- identifiers and states

// Every aggregate here refuses to be created without an identifier or a
// patient. Dull rules, and the reason they are worth a test is that a record
// with neither is one no worklist, census or trend will ever show anybody:
// it is written, and then it is gone.
func TestNothingIsCreatedWithoutAnIdentifierOrAPatient(t *testing.T) {
	_, err := domain.NewAssessment("", "t1", assessmentInput(), "diet-1", at)
	refused(t, err, "needs an id")
	blankPatient := assessmentInput()
	blankPatient.PatientID = ""
	_, err = domain.NewAssessment("a1", "t1", blankPatient, "diet-1", at)
	refused(t, err, "names its patient")

	_, err = domain.PlaceDietOrder("", "t1", orderInput(), nil, "doc-1", at)
	refused(t, err, "needs an id")
	orderNoPatient := orderInput()
	orderNoPatient.PatientID = ""
	_, err = domain.PlaceDietOrder("o1", "t1", orderNoPatient, nil, "doc-1", at)
	refused(t, err, "names its patient")

	_, err = domain.NewCarePlan("", "t1", planInput(), "diet-1", at)
	refused(t, err, "needs an id")
	planNoPatient := planInput()
	planNoPatient.PatientID = ""
	_, err = domain.NewCarePlan("cp1", "t1", planNoPatient, "diet-1", at)
	refused(t, err, "names its patient")
	// A goal with no code is a target nothing can be measured against.
	planNoCode := planInput()
	planNoCode.Goals[0].Code = "  "
	_, err = domain.NewCarePlan("cp1", "t1", planNoCode, "diet-1", at)
	refused(t, err, "a goal needs a code")

	support := domain.NewSupportPlanInput{
		PatientID: "p1", Kind: domain.SupportEnteral, FormulaCode: "F-1",
	}
	_, err = domain.PlanNutritionSupport("", "t1", support, "diet-1", at)
	refused(t, err, "needs an id")
	support.PatientID = ""
	_, err = domain.PlanNutritionSupport("sp1", "t1", support, "diet-1", at)
	refused(t, err, "names its patient")

	_, err = domain.BuildCensus("", "t1", "f1", "ward-4",
		domain.CycleBreakfast, at, at.Add(time.Hour), nil, at, "k1", at)
	refused(t, err, "needs an id")
	// A census with no service date cannot be found by the ward asking
	// where yesterday's lunch went.
	_, err = domain.BuildCensus("c1", "t1", "f1", "ward-4",
		domain.CycleBreakfast, time.Time{}, at.Add(time.Hour), nil, at,
		"k1", at)
	refused(t, err, "names its service date")

	_, err = domain.RecordConsumption("", "t1", "c1", "OATS", 10, "", "k1", at)
	refused(t, err, "needs an id")

	plan, err := domain.NewCarePlan("cp1", "t1", planInput(), "diet-1", at)
	if err != nil {
		t.Fatalf("NewCarePlan: %v", err)
	}
	_, err = plan.RecordProgress("", "weight", 1, "", "diet-1", at, at)
	refused(t, err, "needs an id")
}

func TestATrayIsPlatedFromAFrozenCensusAndMovesOneStepAtATime(t *testing.T) {
	orders := wardOrders(t)
	draft, err := domain.BuildCensus("c1", "t1", "f1", "ward-4",
		domain.CycleBreakfast, at, at.Add(time.Hour), orders, at, "k1", at)
	if err != nil {
		t.Fatalf("BuildCensus: %v", err)
	}
	line := draft.Lines[0]

	// Cooking to a census that has not been frozen is cooking to a number
	// that is still moving.
	_, err = domain.NewTray("tr1", "t1", draft, line, at.Add(3*time.Hour))
	refused(t, err, "has not been frozen")

	_, err = domain.NewTray("", "t1", frozenCensus(t), line,
		at.Add(3*time.Hour))
	refused(t, err, "needs an id")

	tray, err := domain.NewTray("tr1", "t1", frozenCensus(t), line,
		at.Add(3*time.Hour))
	if err != nil {
		t.Fatalf("NewTray: %v", err)
	}
	if err := tray.Prepare("k1", at); err != nil {
		t.Fatalf("Prepare: %v", err)
	}
	// Plating the same tray twice is two meals counted for one patient.
	refused(t, tray.Prepare("k1", at), "this tray is prepared")

	if err := tray.Dispatch(orders[0], true, line, "porter-1",
		at.Add(2*time.Hour)); err != nil {
		t.Fatalf("Dispatch: %v", err)
	}
	if err := tray.Deliver("nurse-1", at.Add(2*time.Hour)); err != nil {
		t.Fatalf("Deliver: %v", err)
	}
	// A meal the patient has already eaten cannot be held back afterwards.
	refused(t, tray.Withhold("changed my mind", "porter-1", at),
		"this tray is delivered")
}

func TestACancelledOrderIsNotSomethingToAuthoriseAnAllergenAgainst(
	t *testing.T) {

	order, err := domain.PlaceDietOrder("o1", "t1", orderInput(),
		[]domain.Conflict{{AllergyRef: "al-1", Substance: "peanut",
			Item: "Satay", Severity: "anaphylaxis"}}, "doc-1", at)
	if err != nil {
		t.Fatalf("PlaceDietOrder: %v", err)
	}
	if err := order.Cancel("patient discharged", "doc-1", at); err != nil {
		t.Fatalf("Cancel: %v", err)
	}
	// Resolving a conflict on a cancelled order puts a doctor's name against
	// a decision that has no effect, which is the sort of record that turns
	// up in an investigation looking like one that did.
	refused(t, order.ResolveConflict("al-1", "", "shell only", "doc-2", at),
		"cancelled")
}
