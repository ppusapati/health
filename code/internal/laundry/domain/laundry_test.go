package domain_test

import (
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/laundry/domain"
)

// The laundry and linen rules.
//
// Every refusal below is a rule somebody could otherwise remove, so each is
// tested by weakening it: the assertion is that the domain says no, and the
// comment says what happens in a hospital when it says yes.

var at = time.Date(2026, 9, 23, 6, 0, 0, 0, time.UTC)

func refused(t *testing.T, err error, contains string) {
	t.Helper()
	if err == nil {
		t.Fatalf("want a refusal mentioning %q, got none", contains)
	}
	if !strings.Contains(err.Error(), contains) {
		t.Fatalf("want a refusal mentioning %q, got %v", contains, err)
	}
}

// ------------------------------------------------ linen master (SRS-LND-001)

func itemInput() domain.NewItemInput {
	return domain.NewItemInput{
		Code: "SHEET-FLAT", Name: "Flat sheet",
		Category:    domain.CategoryBedding,
		UnitWeightG: 600, ReplacementCostMinor: 42000,
	}
}

func sheet(t *testing.T) domain.LinenItem {
	t.Helper()
	item, err := domain.NewItem("i1", "t1", itemInput(), "lin-1", at)
	if err != nil {
		t.Fatalf("NewItem: %v", err)
	}
	return item
}

func TestALinenItemNamesItsCategoryAndCostsNothingNegative(t *testing.T) {
	// A category decides the par, the report and which wash the item can
	// take. A hospital that could type one would have four wards on values
	// nobody can explain.
	in := itemInput()
	in.Category = "linens"
	_, err := domain.NewItem("i1", "t1", in, "lin-1", at)
	refused(t, err, "unknown linen category")

	// A negative replacement cost is a write-off that pays the hospital.
	in = itemInput()
	in.ReplacementCostMinor = -1
	_, err = domain.NewItem("i1", "t1", in, "lin-1", at)
	refused(t, err, "cannot be negative")

	in = itemInput()
	in.Code = " "
	_, err = domain.NewItem("i1", "t1", in, "lin-1", at)
	refused(t, err, "needs a code")

	_, err = domain.NewItem("", "t1", itemInput(), "lin-1", at)
	refused(t, err, "needs an id")

	// Retiring an item stops it being issued and keeps what was.
	item := sheet(t)
	if err := item.Retire(at); err != nil {
		t.Fatalf("Retire: %v", err)
	}
	refused(t, item.Retire(at), "already retired")
}

func parInput() domain.NewParInput {
	return domain.NewParInput{
		UnitID: "ward-3", UnitName: "Ward 3", FacilityID: "f1", Revision: 1,
		Lines: []domain.ParLine{
			{ItemCode: "SHEET-FLAT", Quantity: 60, ReorderAt: 20},
			{ItemCode: "PILLOWCASE", Quantity: 60},
			{ItemCode: "GOWN", Quantity: 30, ReorderAt: 10},
		},
		EffectiveFrom: at.Add(-24 * time.Hour),
	}
}

func approvedPar(t *testing.T, id string,
	in domain.NewParInput) domain.ParLevel {

	t.Helper()
	par, err := domain.NewParLevel(id, "t1", in, "lin-1",
		at.Add(-48*time.Hour))
	if err != nil {
		t.Fatalf("NewParLevel: %v", err)
	}
	if err := par.Approve("lin-manager", in.EffectiveFrom,
		at.Add(-36*time.Hour)); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	return par
}

func TestAParLevelSaysWhatTheUnitHoldsAndIsApprovedBySomebodyElse(
	t *testing.T) {

	// A par with no lines is a unit whose shortfall is always zero, which
	// reads as a ward that never runs out.
	in := parInput()
	in.Lines = nil
	_, err := domain.NewParLevel("p1", "t1", in, "lin-1", at)
	refused(t, err, "says what the unit should hold")

	// The same item twice is two pars for one thing.
	in = parInput()
	in.Lines = append(in.Lines, domain.ParLine{
		ItemCode: "sheet-flat", Quantity: 10,
	})
	_, err = domain.NewParLevel("p1", "t1", in, "lin-1", at)
	refused(t, err, "appears twice")

	// A par of zero is an entitlement to nothing dressed up as a number.
	in = parInput()
	in.Lines[0].Quantity = 0
	_, err = domain.NewParLevel("p1", "t1", in, "lin-1", at)
	refused(t, err, "not a positive number")

	// A reorder level above par fires on every read.
	in = parInput()
	in.Lines[0].ReorderAt = 100
	_, err = domain.NewParLevel("p1", "t1", in, "lin-1", at)
	refused(t, err, "between zero and par")

	in = parInput()
	in.Lines[0].ItemCode = ""
	_, err = domain.NewParLevel("p1", "t1", in, "lin-1", at)
	refused(t, err, "names its item")

	in = parInput()
	in.Revision = 0
	_, err = domain.NewParLevel("p1", "t1", in, "lin-1", at)
	refused(t, err, "revision starts at one")

	in = parInput()
	in.UnitID = ""
	_, err = domain.NewParLevel("p1", "t1", in, "lin-1", at)
	refused(t, err, "names its unit")

	_, err = domain.NewParLevel("", "t1", parInput(), "lin-1", at)
	refused(t, err, "needs an id")

	par, err := domain.NewParLevel("p1", "t1", parInput(), "lin-1",
		at.Add(-48*time.Hour))
	if err != nil {
		t.Fatalf("NewParLevel: %v", err)
	}
	// Until somebody approves it, no ward is held to it.
	if par.Live(at) {
		t.Fatal("an unapproved par level is in force")
	}
	// One person writing and approving a par is one person deciding what
	// the laundry buys.
	refused(t, par.Approve("lin-1", at, at),
		"author of a par level cannot approve it")
	refused(t, par.Approve("", at, at), "names who made it")
	refused(t, par.Approve("lin-manager", time.Time{}, at),
		"when it takes effect")

	if err := par.Approve("lin-manager", at.Add(-24*time.Hour),
		at); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	if !par.Live(at) || par.Live(at.Add(-36*time.Hour)) {
		t.Fatal("the par is not in force exactly from its effective date")
	}
	refused(t, par.Approve("lin-other", at, at), "already approved")
}

func TestTheParInForceIsTheLatestApprovedRevisionAndDrivesTheTopUp(
	t *testing.T) {

	first := approvedPar(t, "p1", parInput())

	second := parInput()
	second.Revision, second.EffectiveFrom = 2, at.Add(-2*time.Hour)
	second.Lines[0].Quantity = 90
	latest := approvedPar(t, "p2", second)

	// Two live pars for one ward is a ward stocked to whichever the reader
	// opened.
	got, ok := domain.ParInForce([]domain.ParLevel{first, latest}, "WARD-3",
		at)
	if !ok || got.Revision != 2 {
		t.Fatalf("want revision 2 in force, got %+v %v", got, ok)
	}
	got, ok = domain.ParInForce([]domain.ParLevel{first, latest}, "ward-3",
		at.Add(-6*time.Hour))
	if !ok || got.Revision != 1 {
		t.Fatalf("want revision 1 in force earlier, got %+v %v", got, ok)
	}
	if _, ok := domain.ParInForce([]domain.ParLevel{first}, "ward-9",
		at); ok {
		t.Fatal("a ward with no par has one in force")
	}

	// The shortfall is computed from the par and the balance, so raising
	// the par produces a bigger top-up with nothing regenerated.
	short := domain.Shortfalls(latest, map[string]int{
		"SHEET-FLAT": 15, "PILLOWCASE": 60, "GOWN": 5,
	})
	if len(short) != 2 {
		t.Fatalf("want two items short, got %+v", short)
	}
	// Deepest first: a list in item-code order sends a porter with two
	// pillowcases while the ward has no sheets.
	if short[0].ItemCode != "SHEET-FLAT" || short[0].Short != 75 {
		t.Fatalf("want the sheets first and deepest, got %+v", short[0])
	}
	if short[1].ItemCode != "GOWN" || short[1].Short != 25 {
		t.Fatalf("want the gowns second, got %+v", short[1])
	}
	// An item at par is absent rather than present with a zero: a top-up
	// sheet listing everything the ward already has is one nobody finishes.
	for _, line := range short {
		if line.ItemCode == "PILLOWCASE" {
			t.Fatalf("an item at par appeared in the top-up: %+v", line)
		}
	}
}

// ------------------------------------------------- collections (SRS-LND-002)

func collectionInput() domain.NewCollectionInput {
	return domain.NewCollectionInput{
		UnitID: "ward-3", UnitName: "Ward 3", FacilityID: "f1",
		SoilClass: domain.SoilUsed, BagCount: 2, WeightG: 18000,
		Lines: []domain.CollectionLine{
			{ItemCode: "SHEET-FLAT", Quantity: 20},
			{ItemCode: "PILLOWCASE", Quantity: 10},
		},
	}
}

func collection(t *testing.T, id string,
	in domain.NewCollectionInput) domain.Collection {

	t.Helper()
	out, err := domain.RecordCollection(id, "t1", in, "porter-1", at)
	if err != nil {
		t.Fatalf("RecordCollection: %v", err)
	}
	return out
}

func infectedInput() domain.NewCollectionInput {
	in := collectionInput()
	in.SoilClass = domain.SoilInfected
	in.Lines = nil
	in.BagCount, in.WeightG = 1, 9000
	return in
}

func TestACollectionNamesItsUnitAndHowItHasToBeHandled(t *testing.T) {
	// A collection whose class nobody set would be handled as ordinary
	// linen, which is the outcome SRS-LND-005 exists to prevent.
	in := collectionInput()
	in.SoilClass = ""
	_, err := domain.RecordCollection("c1", "t1", in, "porter-1", at)
	refused(t, err, "unknown soil class")

	in = collectionInput()
	in.UnitID = ""
	_, err = domain.RecordCollection("c1", "t1", in, "porter-1", at)
	refused(t, err, "names its unit")

	in = collectionInput()
	in.BagCount = 0
	_, err = domain.RecordCollection("c1", "t1", in, "porter-1", at)
	refused(t, err, "at least one bag")

	in = collectionInput()
	in.WeightG = -1
	_, err = domain.RecordCollection("c1", "t1", in, "porter-1", at)
	refused(t, err, "cannot be negative")

	in = collectionInput()
	in.Lines[0].Quantity = 0
	_, err = domain.RecordCollection("c1", "t1", in, "porter-1", at)
	refused(t, err, "not a positive number")

	in = collectionInput()
	in.Lines[0].ItemCode = ""
	_, err = domain.RecordCollection("c1", "t1", in, "porter-1", at)
	refused(t, err, "names its item")

	in = collectionInput()
	in.Lines = append(in.Lines, domain.CollectionLine{
		ItemCode: "sheet-flat", Quantity: 1,
	})
	_, err = domain.RecordCollection("c1", "t1", in, "porter-1", at)
	refused(t, err, "appears twice")

	_, err = domain.RecordCollection("c1", "t1", collectionInput(), "", at)
	refused(t, err, "names who took it")

	_, err = domain.RecordCollection("", "t1", collectionInput(),
		"porter-1", at)
	refused(t, err, "needs an id")

	// The handling instruction is copied from the class rather than typed,
	// so the worklist a porter reads and the cycle the machine runs cannot
	// disagree.
	infected := collection(t, "c2", infectedInput())
	if !strings.Contains(infected.Handling, "barrier") ||
		!infected.SoilClass.Sealed() {
		t.Fatalf("an infected collection lost its handling: %+v", infected)
	}
	ordinary := collection(t, "c3", collectionInput())
	if ordinary.SoilClass.Sealed() ||
		!strings.Contains(ordinary.Handling, "standard") {
		t.Fatalf("an ordinary collection reads as sealed: %+v", ordinary)
	}
}

func TestInfectedLinenIsCountedAtTheBedsideAndTheBagIsNotOpenedAgain(
	t *testing.T) {

	// SRS-LND-005 in one assertion. Re-counting infected linen means
	// opening the bag, and the declaration made at the bedside is the only
	// count anybody is going to get. A system that allowed the correction
	// would be a system where somebody was asked to make it.
	infected := collection(t, "c1", infectedInput())
	refused(t, infected.Recount([]domain.CollectionLine{
		{ItemCode: "SHEET-FLAT", Quantity: 12},
	}, "sorter-1", at), "not opened again")

	// Ordinary linen is sorted and counted, and the correction is
	// ordinary work.
	ordinary := collection(t, "c2", collectionInput())
	if err := ordinary.Recount([]domain.CollectionLine{
		{ItemCode: "SHEET-FLAT", Quantity: 18},
	}, "sorter-1", at); err != nil {
		t.Fatalf("Recount: %v", err)
	}
	if ordinary.DeclaredPieces() != 18 {
		t.Fatalf("the recount did not stick: %+v", ordinary.Lines)
	}
	refused(t, ordinary.Recount(nil, "sorter-1", at), "says what was counted")
	refused(t, ordinary.Recount([]domain.CollectionLine{
		{ItemCode: "", Quantity: 1},
	}, "sorter-1", at), "names its item")
	refused(t, ordinary.Recount([]domain.CollectionLine{
		{ItemCode: "A", Quantity: 1}, {ItemCode: "a", Quantity: 1},
	}, "sorter-1", at), "appears twice")
	refused(t, ordinary.Recount([]domain.CollectionLine{
		{ItemCode: "A", Quantity: 0},
	}, "sorter-1", at), "not a positive number")

	// A cancelled collection is not something to carry on correcting.
	refused(t, ordinary.Cancel("", "porter-1", at), "say why")
	if err := ordinary.Cancel("recorded twice", "porter-1", at); err != nil {
		t.Fatalf("Cancel: %v", err)
	}
	refused(t, ordinary.Cancel("again", "porter-1", at),
		"this collection is cancelled")
	refused(t, ordinary.Recount([]domain.CollectionLine{
		{ItemCode: "A", Quantity: 1},
	}, "sorter-1", at), "this collection is cancelled")
}

func TestTheWeightIsTheOnlyHonestCheckOnABagNobodyOpens(t *testing.T) {
	weights := map[string]int{"SHEET-FLAT": 600, "PILLOWCASE": 120}

	// Twenty sheets and ten pillowcases weigh 13.2 kg dry; the trolley came
	// in at 18 kg, which is wet linen rather than a discrepancy.
	check := domain.CheckWeight(collection(t, "c1", collectionInput()),
		weights)
	if check.Unanswerable || check.DeclaredPieces != 30 ||
		check.ExpectedG != 13200 || check.VarianceG != 4800 {
		t.Fatalf("the weight check is wrong: %+v", check)
	}

	// A sealed bag declares nothing, so it reports unanswerable rather than
	// a variance of everything — which would put every infected bag on the
	// exception list and take the list with it.
	check = domain.CheckWeight(collection(t, "c2", infectedInput()), weights)
	if !check.Unanswerable || check.VarianceG != 0 {
		t.Fatalf("a sealed bag produced a variance: %+v", check)
	}

	// And an item whose unit weight nobody recorded makes the whole check
	// unanswerable rather than silently counting it as weightless.
	check = domain.CheckWeight(collection(t, "c3", collectionInput()),
		map[string]int{"SHEET-FLAT": 600})
	if !check.Unanswerable {
		t.Fatalf("an unweighed item was counted as nothing: %+v", check)
	}
}

func TestTheWashQueuePutsInfectedLinenFirst(t *testing.T) {
	early := collectionInput()
	ordinary, err := domain.RecordCollection("c1", "t1", early, "porter-1",
		at.Add(-2*time.Hour))
	if err != nil {
		t.Fatalf("RecordCollection: %v", err)
	}
	infected := collection(t, "c2", infectedInput())
	cancelled := collection(t, "c3", collectionInput())
	if err := cancelled.Cancel("duplicate", "porter-1", at); err != nil {
		t.Fatalf("Cancel: %v", err)
	}

	// It is the load nobody wants sitting in a corridor, and a worklist in
	// arrival order leaves it there behind a trolley of towels.
	pending := domain.PendingCollections([]domain.Collection{
		ordinary, infected, cancelled})
	if len(pending) != 2 || pending[0].ID != "c2" {
		t.Fatalf("want the infected load first, got %+v", pending)
	}
}

// ------------------------------------------------------ batches (SRS-LND-003)

func batchInput(cycle domain.Cycle) domain.NewBatchInput {
	return domain.NewBatchInput{
		Reference: "W-1001", FacilityID: "f1", MachineID: "washer-2",
		Cycle: cycle,
	}
}

func batch(t *testing.T, id string, cycle domain.Cycle) domain.Batch {
	t.Helper()
	out, err := domain.OpenBatch(id, "t1", batchInput(cycle), "lin-1", at)
	if err != nil {
		t.Fatalf("OpenBatch: %v", err)
	}
	return out
}

func TestInfectedLinenGoesIntoABarrierCycleOrItGoesNowhere(t *testing.T) {
	// The rule this family exists for. A standard programme does not
	// dissolve the inner bag and does not reach disinfection temperature,
	// so the load comes out contaminated and indistinguishable from clean —
	// and the people who sort it afterwards are the ones who find out.
	infected := collection(t, "c1", infectedInput())
	for _, cycle := range []domain.Cycle{
		domain.CycleStandard, domain.CycleHot, domain.CycleDelicate,
	} {
		wash := batch(t, "b1", cycle)
		refused(t, wash.Load(&infected, at), "goes into a barrier cycle")
		if infected.State != domain.CollectionOpen {
			t.Fatalf("a refused load still moved the collection: %+v",
				infected.State)
		}
	}

	barrier := batch(t, "b2", domain.CycleBarrier)
	if err := barrier.Load(&infected, at); err != nil {
		t.Fatalf("Load: %v", err)
	}
	// The chain SRS-LND-002 asks to be retained, in both directions.
	if infected.State != domain.CollectionBatched ||
		infected.BatchID != "b2" || len(barrier.CollectionIDs) != 1 {
		t.Fatalf("the chain was not retained: %+v %+v", infected, barrier)
	}
	// And the batch knows what it is carrying, derived rather than set: an
	// operator who could clear the flag would, on the night the barrier
	// machine broke.
	if !barrier.Infected || barrier.WeightG != 9000 {
		t.Fatalf("the batch did not take on the load: %+v", barrier)
	}

	// The same collection twice is one trolley washed once and counted
	// twice. Refused on the batch's own list rather than on the
	// collection's state, so a caller holding a stale read whose copy still
	// says open is refused too.
	refused(t, barrier.Load(&infected, at), "already in the batch")
	stale := infected
	stale.State, stale.BatchID = domain.CollectionOpen, ""
	refused(t, barrier.Load(&stale, at), "already in the batch")
	if barrier.WeightG != 9000 {
		t.Fatalf("a refused load changed the weight: %d", barrier.WeightG)
	}

	// A collection that is already somewhere else does not move again.
	other := collection(t, "c2", collectionInput())
	if err := barrier.Load(&other, at); err != nil {
		t.Fatalf("Load: %v", err)
	}
	second := batch(t, "b3", domain.CycleStandard)
	refused(t, second.Load(&other, at), "this collection is batched")
}

func TestAWashNamesItsMachineAndItsProgramme(t *testing.T) {
	// A batch with no machine is a wash nobody can trace when the machine
	// turns out to be the problem — and "one washer fails every third load"
	// is the finding a laundry most needs and least expects.
	in := batchInput(domain.CycleHot)
	in.MachineID = " "
	_, err := domain.OpenBatch("b1", "t1", in, "lin-1", at)
	refused(t, err, "names the machine it ran in")

	// An unknown cycle would default to whatever the machine was last set
	// to, which on the barrier washer is the one load that must not.
	in = batchInput("boil")
	_, err = domain.OpenBatch("b1", "t1", in, "lin-1", at)
	refused(t, err, "unknown wash cycle")

	_, err = domain.OpenBatch("b1", "t1", batchInput(domain.CycleHot), "", at)
	refused(t, err, "names who opened it")

	_, err = domain.OpenBatch("", "t1", batchInput(domain.CycleHot),
		"lin-1", at)
	refused(t, err, "needs an id")
}

func TestAWashSaysHowItWentAndAFailureSaysWhat(t *testing.T) {
	wash := batch(t, "b1", domain.CycleHot)
	load := collection(t, "c1", collectionInput())

	// An empty batch that later reads as passed is a batch somebody can
	// issue linen from without any linen having been washed.
	refused(t, wash.Start("op-1", at), "nothing in it is not a wash")

	if err := wash.Load(&load, at); err != nil {
		t.Fatalf("Load: %v", err)
	}
	refused(t, wash.Start("", at), "names who started it")

	// Nothing to complete until it has run.
	refused(t, wash.Complete(domain.CompleteInput{
		Passed: true, Outcome: "fine",
	}, "op-1", at), "has not been started")

	if err := wash.Start("op-1", at); err != nil {
		t.Fatalf("Start: %v", err)
	}
	refused(t, wash.Start("op-1", at), "this batch is processing")
	// A batch in the machine is not taking more linen.
	more := collection(t, "c2", collectionInput())
	refused(t, wash.Load(&more, at), "is not taking linen")

	// An outcome of "failed" with nothing beside it tells the person
	// deciding whether to rewash or condemn the load nothing at all.
	refused(t, wash.Complete(domain.CompleteInput{
		Passed: false, Outcome: "did not finish",
	}, "op-1", at), "says what went wrong")
	refused(t, wash.Complete(domain.CompleteInput{
		Passed: true, Outcome: "",
	}, "op-1", at), "says how it went")
	refused(t, wash.Complete(domain.CompleteInput{
		Passed: true, Outcome: "fine",
	}, "", at), "names who recorded it")
	refused(t, wash.Complete(domain.CompleteInput{
		Passed: true, Outcome: "fine", PeakTemperatureC: -5,
	}, "op-1", at), "cannot be negative")
	refused(t, wash.Complete(domain.CompleteInput{
		Passed: false, Outcome: "aborted",
		Exceptions: []domain.BatchException{{Detail: "no code"}},
	}, "op-1", at), "names what it is")

	if err := wash.Complete(domain.CompleteInput{
		Passed: false, Outcome: "cycle aborted at 40 minutes",
		PeakTemperatureC: 58, HoldMinutes: 0,
		Exceptions: []domain.BatchException{
			{Code: "TEMP_NOT_HELD", Detail: "peaked at 58C, needs 71C"},
		},
	}, "op-1", at.Add(time.Hour)); err != nil {
		t.Fatalf("Complete: %v", err)
	}
	if wash.State != domain.BatchFailed || wash.Issuable() {
		t.Fatalf("a failed wash is issuable: %+v", wash)
	}
	refused(t, wash.Complete(domain.CompleteInput{
		Passed: true, Outcome: "fine",
	}, "op-1", at), "this batch is failed")
}

func TestAFailedLoadIsRewashedAndTheFailureStaysOnTheRecord(t *testing.T) {
	wash := batch(t, "b1", domain.CycleBarrier)
	infected := collection(t, "c1", infectedInput())
	if err := wash.Load(&infected, at); err != nil {
		t.Fatalf("Load: %v", err)
	}
	if err := wash.Start("op-1", at); err != nil {
		t.Fatalf("Start: %v", err)
	}

	// A passed batch is not rewashed: a hospital that could turn a pass
	// into a rewash could turn a failure into a pass.
	passed := batch(t, "b9", domain.CycleStandard)
	into := batch(t, "b2", domain.CycleBarrier)
	refused(t, passed.Rewash(&into, at), "not failed")

	if err := wash.Complete(domain.CompleteInput{
		Passed: false, Outcome: "aborted",
		Exceptions: []domain.BatchException{{Code: "ABORT"}},
	}, "op-1", at); err != nil {
		t.Fatalf("Complete: %v", err)
	}

	// An infected load does not become an ordinary one by failing.
	ordinaryRetry := batch(t, "b3", domain.CycleStandard)
	refused(t, wash.Rewash(&ordinaryRetry, at), "replacement batch is a")

	// Nor into a batch already running.
	running := batch(t, "b4", domain.CycleBarrier)
	other := collection(t, "c2", infectedInput())
	if err := running.Load(&other, at); err != nil {
		t.Fatalf("Load: %v", err)
	}
	if err := running.Start("op-1", at); err != nil {
		t.Fatalf("Start: %v", err)
	}
	refused(t, wash.Rewash(&running, at), "replacement batch is processing")

	if err := wash.Rewash(&into, at); err != nil {
		t.Fatalf("Rewash: %v", err)
	}
	// The failure stays. A hospital with no way of noticing that one
	// machine fails every third load is a hospital that keeps using it.
	if wash.State != domain.BatchRewashed || wash.RewashBatchID != "b2" ||
		len(wash.Exceptions) != 1 {
		t.Fatalf("the failure was erased: %+v", wash)
	}
	if into.RewashOfBatchID != "b1" || !into.Infected ||
		len(into.CollectionIDs) != 1 {
		t.Fatalf("the replacement did not take the load: %+v", into)
	}
	refused(t, wash.Rewash(&into, at), "this batch is rewashed")
}

func TestAFailedWashNamesTheWardsWhoseLinenWasInIt(t *testing.T) {
	wash := batch(t, "b1", domain.CycleHot)
	first := collection(t, "c1", collectionInput())
	secondIn := collectionInput()
	secondIn.UnitID = "theatre-1"
	second := collection(t, "c2", secondIn)
	elsewhere := collection(t, "c3", collectionInput())

	for _, load := range []*domain.Collection{&first, &second} {
		if err := wash.Load(load, at); err != nil {
			t.Fatalf("Load: %v", err)
		}
	}
	if err := wash.Start("op-1", at); err != nil {
		t.Fatalf("Start: %v", err)
	}

	all := []domain.Collection{first, second, elsewhere}
	// A batch still running names nobody: the question only arises once it
	// has failed.
	if got := domain.FailedBatchUnits(wash, all); got != nil {
		t.Fatalf("a running batch named units: %+v", got)
	}

	if err := wash.Complete(domain.CompleteInput{
		Passed: false, Outcome: "drum fault",
		Exceptions: []domain.BatchException{{Code: "MECHANICAL"}},
	}, "op-1", at); err != nil {
		t.Fatalf("Complete: %v", err)
	}

	// The reason the chain is worth retaining: a failed batch is linen that
	// may already be on its way back, and this is the answer to "whose".
	units := domain.FailedBatchUnits(wash, all)
	if len(units) != 2 || units[0] != "theatre-1" || units[1] != "ward-3" {
		t.Fatalf("want both units named once, got %+v", units)
	}
}

func TestTheBatchReportCountsExceptionsApartFromFailures(t *testing.T) {
	var batches []domain.Batch

	for i, spec := range []struct {
		passed     bool
		exceptions []domain.BatchException
	}{
		{true, nil},
		{true, []domain.BatchException{{Code: "PROBE_DRIFT"}}},
		{false, []domain.BatchException{{Code: "ABORT"}}},
	} {
		wash := batch(t, string(rune('a'+i)), domain.CycleHot)
		load := collection(t, "c"+string(rune('a'+i)), collectionInput())
		if err := wash.Load(&load, at); err != nil {
			t.Fatalf("Load: %v", err)
		}
		if err := wash.Start("op-1", at); err != nil {
			t.Fatalf("Start: %v", err)
		}
		if err := wash.Complete(domain.CompleteInput{
			Passed: spec.passed, Outcome: "recorded",
			Exceptions: spec.exceptions,
		}, "op-1", at); err != nil {
			t.Fatalf("Complete: %v", err)
		}
		batches = append(batches, wash)
	}

	summary := domain.SummariseBatches(batches)
	if summary.Run != 3 || summary.Passed != 2 || summary.Failed != 1 {
		t.Fatalf("the counts are wrong: %+v", summary)
	}
	// A load that passed with a probe fault is the one that tells a
	// hospital its next load will not.
	if summary.WithExceptions != 2 {
		t.Fatalf("exceptions were folded into failures: %+v", summary)
	}
	if summary.Unanswerable {
		t.Fatal("a set with completed washes is unanswerable")
	}

	empty := domain.SummariseBatches([]domain.Batch{
		batch(t, "z", domain.CycleHot)})
	if !empty.Unanswerable || empty.InFlight != 1 {
		t.Fatalf("want an unanswerable summary, got %+v", empty)
	}
}

// ------------------------------------------------------- issues (SRS-LND-004)

func passedBatch(t *testing.T, id string) (domain.Batch, domain.Collection) {
	t.Helper()
	wash := batch(t, id, domain.CycleHot)
	load := collection(t, "col-"+id, collectionInput())
	if err := wash.Load(&load, at); err != nil {
		t.Fatalf("Load: %v", err)
	}
	if err := wash.Start("op-1", at); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if err := wash.Complete(domain.CompleteInput{
		Passed: true, Outcome: "71C held for 3 minutes",
		PeakTemperatureC: 74, HoldMinutes: 3,
	}, "op-1", at.Add(time.Hour)); err != nil {
		t.Fatalf("Complete: %v", err)
	}
	return wash, load
}

func issueInput() domain.NewIssueInput {
	return domain.NewIssueInput{
		UnitID: "ward-3", UnitName: "Ward 3", FacilityID: "f1",
		Lines: []domain.IssueLine{
			{ItemCode: "SHEET-FLAT", Quantity: 40},
			{ItemCode: "PILLOWCASE", Quantity: 40},
		},
	}
}

func TestLinenIsIssuedFromAPassedWashAndFromNothingElse(t *testing.T) {
	// The other rule this family exists for. Linen from a wash that did not
	// pass looks exactly like clean linen, and the ward that gets it has no
	// way of telling.
	loading := batch(t, "b1", domain.CycleHot)
	_, err := domain.IssueLinen("i1", "t1", loading, issueInput(), "lin-1",
		at)
	refused(t, err, "linen is issued from a passed wash")

	failed := batch(t, "b2", domain.CycleHot)
	load := collection(t, "c2", collectionInput())
	if err := failed.Load(&load, at); err != nil {
		t.Fatalf("Load: %v", err)
	}
	if err := failed.Start("op-1", at); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if err := failed.Complete(domain.CompleteInput{
		Passed: false, Outcome: "temperature never held",
		Exceptions: []domain.BatchException{{Code: "TEMP_NOT_HELD"}},
	}, "op-1", at); err != nil {
		t.Fatalf("Complete: %v", err)
	}
	_, err = domain.IssueLinen("i1", "t1", failed, issueInput(), "lin-1", at)
	refused(t, err, "linen is issued from a passed wash")

	passed, _ := passedBatch(t, "b3")
	_, err = domain.IssueLinen("i1", "t1", passed,
		domain.NewIssueInput{UnitID: "ward-3"}, "lin-1", at)
	refused(t, err, "says what was sent")

	in := issueInput()
	in.UnitID = ""
	_, err = domain.IssueLinen("i1", "t1", passed, in, "lin-1", at)
	refused(t, err, "names the unit it goes to")

	in = issueInput()
	in.Lines[0].Quantity = 0
	_, err = domain.IssueLinen("i1", "t1", passed, in, "lin-1", at)
	refused(t, err, "not a positive number")

	in = issueInput()
	in.Lines[0].ItemCode = " "
	_, err = domain.IssueLinen("i1", "t1", passed, in, "lin-1", at)
	refused(t, err, "names its item")

	in = issueInput()
	in.Lines = append(in.Lines, domain.IssueLine{
		ItemCode: "sheet-flat", Quantity: 1,
	})
	_, err = domain.IssueLinen("i1", "t1", passed, in, "lin-1", at)
	refused(t, err, "appears twice")

	_, err = domain.IssueLinen("i1", "t1", passed, issueInput(), "", at)
	refused(t, err, "names who made it")

	_, err = domain.IssueLinen("", "t1", passed, issueInput(), "lin-1", at)
	refused(t, err, "needs an id")

	issue, err := domain.IssueLinen("i1", "t1", passed, issueInput(),
		"lin-1", at)
	if err != nil {
		t.Fatalf("IssueLinen: %v", err)
	}
	// The link back to the wash is what makes "which wards got linen from
	// the load that failed" answerable.
	if issue.BatchID != "b3" || issue.BatchReference != "W-1001" ||
		issue.Pieces() != 80 {
		t.Fatalf("the issue lost its batch: %+v", issue)
	}

	// A delivery signed for by the porter who brought it is the same claim
	// made twice, and a ward that never got its linen has no way to say so.
	refused(t, issue.Receive("lin-1", at), "other than whoever issued it")
	refused(t, issue.Receive("", at), "names who signed for it")
	if err := issue.Receive("nurse-1", at.Add(time.Hour)); err != nil {
		t.Fatalf("Receive: %v", err)
	}
	refused(t, issue.Receive("nurse-2", at), "already been received")
}

func TestAUnitsBalanceIsDerivedFromWhatMovedAndNeverGoesNegative(
	t *testing.T) {

	passed, _ := passedBatch(t, "b1")
	issue, err := domain.IssueLinen("i1", "t1", passed, issueInput(),
		"lin-1", at)
	if err != nil {
		t.Fatalf("IssueLinen: %v", err)
	}
	unreceived, err := domain.IssueLinen("i2", "t1", passed,
		domain.NewIssueInput{
			UnitID: "ward-3",
			Lines: []domain.IssueLine{
				{ItemCode: "SHEET-FLAT", Quantity: 10},
			},
		}, "lin-1", at.Add(time.Hour))
	if err != nil {
		t.Fatalf("IssueLinen: %v", err)
	}
	elsewhere, err := domain.IssueLinen("i3", "t1", passed,
		domain.NewIssueInput{
			UnitID: "theatre-1",
			Lines: []domain.IssueLine{
				{ItemCode: "SHEET-FLAT", Quantity: 99},
			},
		}, "lin-1", at)
	if err != nil {
		t.Fatalf("IssueLinen: %v", err)
	}

	returned := collection(t, "c1", collectionInput())
	sealed := collection(t, "c2", infectedInput())
	cancelled := collection(t, "c3", collectionInput())
	if err := cancelled.Cancel("recorded twice", "porter-1", at); err != nil {
		t.Fatalf("Cancel: %v", err)
	}

	writeOff := lossRecord(t, "l1", func(in *domain.NewLossInput) {
		in.ItemCode, in.Quantity = "SHEET-FLAT", 5
	})
	if err := writeOff.Approve("ok", "lin-manager", at); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	undecided := lossRecord(t, "l2", func(in *domain.NewLossInput) {
		in.ItemCode, in.Quantity = "SHEET-FLAT", 100
	})

	balance := domain.DeriveBalance("WARD-3",
		[]domain.Issue{issue, unreceived, elsewhere},
		[]domain.Collection{returned, sealed, cancelled},
		[]domain.LossRecord{writeOff, undecided})

	// Issued fifty, returned twenty, five written off. An unreceived issue
	// still counts: linen that left the laundry is linen the ward has,
	// whether or not anybody signed for it.
	if balance.Issued["SHEET-FLAT"] != 50 ||
		balance.Returned["SHEET-FLAT"] != 20 ||
		balance.WrittenOff["SHEET-FLAT"] != 5 ||
		balance.OnHand["SHEET-FLAT"] != 25 {
		t.Fatalf("the balance is wrong: %+v", balance)
	}
	// A write-off nobody has approved does not move the balance; anybody
	// who can type a number could otherwise clear a ward's losses.
	if balance.OnHand["PILLOWCASE"] != 30 {
		t.Fatalf("the pillowcase balance is wrong: %+v", balance)
	}
	// A cancelled collection is skipped, and a sealed bag is reported
	// rather than dropped: a ward whose linen all comes back in sealed bags
	// would otherwise look like a ward that never returns anything.
	if balance.UnreconciledReturns != 1 {
		t.Fatalf("the sealed return was not reported: %+v", balance)
	}

	// A ward that returned more than it was issued is a counting problem,
	// and reporting minus four sheets reads as a ward that owes the laundry
	// linen it never had.
	overreturn := domain.DeriveBalance("ward-3", nil,
		[]domain.Collection{returned}, nil)
	if overreturn.OnHand["SHEET-FLAT"] != 0 {
		t.Fatalf("the balance went negative: %+v", overreturn)
	}

	// Linen nobody has signed for is reported, oldest first.
	outstanding := domain.OutstandingIssues([]domain.Issue{
		unreceived, issue, elsewhere})
	if len(outstanding) != 3 || outstanding[0].ID != "i1" {
		t.Fatalf("want the oldest unreceived issue first, got %+v",
			outstanding)
	}
	if err := issue.Receive("nurse-1", at); err != nil {
		t.Fatalf("Receive: %v", err)
	}
	if got := domain.OutstandingIssues([]domain.Issue{issue}); len(got) != 0 {
		t.Fatalf("a received issue is still outstanding: %+v", got)
	}
}

// ------------------------------------------------------- losses (SRS-LND-006)

func lossInput() domain.NewLossInput {
	return domain.NewLossInput{
		UnitID: "ward-3", FacilityID: "f1", ItemCode: "SHEET-FLAT",
		Quantity: 4, Kind: domain.LossCondemned,
		Reason: "torn beyond repair", ValueMinor: 42000,
		ApprovalThresholdMinor: 10000,
	}
}

func lossRecord(t *testing.T, id string,
	mutate func(*domain.NewLossInput)) domain.LossRecord {

	t.Helper()
	in := lossInput()
	if mutate != nil {
		mutate(&in)
	}
	out, err := domain.ReportLoss(id, "t1", in, "sister-1", at)
	if err != nil {
		t.Fatalf("ReportLoss: %v", err)
	}
	return out
}

func TestAWriteOffSaysWhyAndIsApprovedBySomebodyElse(t *testing.T) {
	// SRS-LND-006 asks for the loss to be reportable, and a reportable loss
	// is one that says what happened.
	in := lossInput()
	in.Reason = " "
	_, err := domain.ReportLoss("l1", "t1", in, "sister-1", at)
	refused(t, err, "say why this linen is gone")

	in = lossInput()
	in.Kind = "vanished"
	_, err = domain.ReportLoss("l1", "t1", in, "sister-1", at)
	refused(t, err, "unknown loss kind")

	in = lossInput()
	in.Quantity = 0
	_, err = domain.ReportLoss("l1", "t1", in, "sister-1", at)
	refused(t, err, "a positive number of pieces")

	in = lossInput()
	in.ValueMinor = -1
	_, err = domain.ReportLoss("l1", "t1", in, "sister-1", at)
	refused(t, err, "cannot be negative")

	in = lossInput()
	in.ItemCode = ""
	_, err = domain.ReportLoss("l1", "t1", in, "sister-1", at)
	refused(t, err, "names its item")

	in = lossInput()
	in.UnitID = ""
	_, err = domain.ReportLoss("l1", "t1", in, "sister-1", at)
	refused(t, err, "names its unit")

	_, err = domain.ReportLoss("l1", "t1", lossInput(), "", at)
	refused(t, err, "names who reported it")

	_, err = domain.ReportLoss("", "t1", lossInput(), "sister-1", at)
	refused(t, err, "needs an id")

	record := lossRecord(t, "l1", nil)
	if !record.ApprovalRequired || record.Counts() {
		t.Fatalf("a reported loss already counts: %+v", record)
	}

	// A ward sister writing off her own ward's linen and approving it
	// herself is the whole of why the requirement says "with approval where
	// required".
	refused(t, record.Approve("fine", "sister-1", at),
		"other than whoever reported it")
	refused(t, record.Approve("fine", "", at), "names who made it")
	refused(t, record.Reject("found them", "sister-1", at),
		"other than whoever reported it")
	refused(t, record.Reject("found them", "", at), "names who made it")
	refused(t, record.Reject("", "lin-manager", at), "say why")

	if err := record.Approve("agreed", "lin-manager", at); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	if !record.Counts() || record.ApprovedBy != "lin-manager" {
		t.Fatalf("the approval did not stick: %+v", record)
	}
	refused(t, record.Approve("again", "lin-manager", at),
		"this loss record is approved")
	refused(t, record.Reject("changed my mind", "lin-manager", at),
		"this loss record is approved")

	// A small loss below the threshold still needs a second person to
	// approve it before it moves a balance; what the threshold changes is
	// whether it goes on somebody's worklist.
	small := lossRecord(t, "l2", func(in *domain.NewLossInput) {
		in.ValueMinor = 500
	})
	if small.ApprovalRequired {
		t.Fatalf("a small loss was flagged for approval: %+v", small)
	}
	refused(t, small.Approve("fine", "sister-1", at),
		"other than whoever reported it")
}

func TestMissingLinenThatTurnsUpIsRecoveredRatherThanDeleted(t *testing.T) {
	// A hospital's loss figure has to be able to say "we lost four hundred
	// sheets and found sixty of them", and a record somebody removed says
	// neither number.
	condemned := lossRecord(t, "l1", nil)
	refused(t, condemned.Recover("found", "sister-1", at),
		"only missing linen is recovered")

	missing := lossRecord(t, "l2", func(in *domain.NewLossInput) {
		in.Kind, in.Quantity = domain.LossMissing, 60
		in.Reason = "not returned after discharge"
	})
	refused(t, missing.Recover("found", "", at), "names who found it")
	if err := missing.Recover("found in a store cupboard", "sister-1",
		at); err != nil {
		t.Fatalf("Recover: %v", err)
	}
	if missing.Counts() {
		t.Fatal("recovered linen still counts as lost")
	}
	refused(t, missing.Recover("again", "sister-1", at),
		"already been recovered")

	rejected := lossRecord(t, "l3", func(in *domain.NewLossInput) {
		in.Kind = domain.LossMissing
	})
	if err := rejected.Reject("they were in the trolley", "lin-manager",
		at); err != nil {
		t.Fatalf("Reject: %v", err)
	}
	refused(t, rejected.Recover("found", "sister-1", at),
		"write-off was refused")
}

func TestTheLossReportCountsOnlyWhatSomebodyApproved(t *testing.T) {
	approved := lossRecord(t, "l1", nil)
	if err := approved.Approve("agreed", "lin-manager", at); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	damaged := lossRecord(t, "l2", func(in *domain.NewLossInput) {
		in.Kind, in.Quantity, in.ValueMinor = domain.LossDamaged, 2, 50000
	})
	if err := damaged.Approve("machine fault", "lin-manager", at); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	pending := lossRecord(t, "l3", func(in *domain.NewLossInput) {
		in.Quantity, in.ValueMinor = 100, 42000
	})
	recovered := lossRecord(t, "l4", func(in *domain.NewLossInput) {
		in.Kind, in.Quantity = domain.LossMissing, 60
	})
	if err := recovered.Recover("found", "sister-1", at); err != nil {
		t.Fatalf("Recover: %v", err)
	}

	records := []domain.LossRecord{approved, damaged, pending, recovered}
	summary := domain.SummariseLosses(records)

	// A reported loss nobody has decided on is not yet a loss, and counting
	// it as one would let the report be moved by anybody who can type a
	// number.
	if summary.Pieces != 6 || summary.Condemned != 4 ||
		summary.Damaged != 2 || summary.Missing != 0 {
		t.Fatalf("unapproved losses were counted: %+v", summary)
	}
	if summary.ValueMinor != 4*42000+2*50000 {
		t.Fatalf("the value is wrong: %+v", summary)
	}
	// Reported beside the totals rather than folded in, because a large
	// figure here means the totals are understated.
	if summary.AwaitingApproval != 1 || summary.Recovered != 60 ||
		summary.Reported != 4 {
		t.Fatalf("the components are wrong: %+v", summary)
	}

	// The approval queue is largest first: a hundred sheets matters more
	// than four, and a queue in report order buries it.
	queue := domain.AwaitingApproval(records)
	if len(queue) != 1 || queue[0].ID != "l3" {
		t.Fatalf("want only the undecided loss queued, got %+v", queue)
	}
}

// ------------------------------------------------ tracked items (SRS-LND-007)

func trackedItem(t *testing.T) domain.LinenItem {
	t.Helper()
	in := itemInput()
	in.Code, in.Name = "SCRUB-TOP", "Scrub top"
	in.Category, in.Tracked = domain.CategoryUniform, true
	item, err := domain.NewItem("i2", "t1", in, "lin-1", at)
	if err != nil {
		t.Fatalf("NewItem: %v", err)
	}
	return item
}

func trackedInput() domain.NewTrackedInput {
	return domain.NewTrackedInput{
		TagID: "RF-0001", TagKind: domain.TagRFID,
		ItemCode: "SCRUB-TOP", AssignedTo: "nurse-1", FacilityID: "f1",
	}
}

func TestATagBelongsToATrackedItemAndNothingElse(t *testing.T) {
	item := trackedItem(t)

	// Tagging something the master does not call tracked produces a custody
	// trail for one sheet out of four thousand, which reads as a system
	// that lost the other three thousand nine hundred.
	_, err := domain.RegisterTag("tr1", "t1", sheet(t),
		domain.NewTrackedInput{
			TagID: "RF-1", TagKind: domain.TagRFID, ItemCode: "SHEET-FLAT",
		}, "lin-1", at)
	refused(t, err, "not a tracked item")

	// A tag registered against the wrong item is a custody trail for
	// something else.
	in := trackedInput()
	in.ItemCode = "GOWN"
	_, err = domain.RegisterTag("tr1", "t1", item, in, "lin-1", at)
	refused(t, err, "registered against item")

	in = trackedInput()
	in.TagKind = "sticker"
	_, err = domain.RegisterTag("tr1", "t1", item, in, "lin-1", at)
	refused(t, err, "unknown tag kind")

	in = trackedInput()
	in.TagID = " "
	_, err = domain.RegisterTag("tr1", "t1", item, in, "lin-1", at)
	refused(t, err, "needs its tag")

	_, err = domain.RegisterTag("", "t1", item, trackedInput(), "lin-1", at)
	refused(t, err, "needs an id")

	_, err = domain.RegisterTag("tr1", "t1", item, trackedInput(), "", at)
	refused(t, err, "names who made it")

	retired := item
	if err := retired.Retire(at); err != nil {
		t.Fatalf("Retire: %v", err)
	}
	_, err = domain.RegisterTag("tr1", "t1", retired, trackedInput(),
		"lin-1", at)
	refused(t, err, "is retired")
}

func TestATrackedItemsCustodyIsTheLastScanAndNothingIsAssumed(t *testing.T) {
	item := trackedItem(t)
	tracked, err := domain.RegisterTag("tr1", "t1", item, trackedInput(),
		"lin-1", at)
	if err != nil {
		t.Fatalf("RegisterTag: %v", err)
	}

	// An item nobody has scanned reports that nobody has, rather than
	// defaulting to the laundry — which would put every unscanned garment
	// somewhere it may not be.
	if custody := tracked.LastKnown(); custody.Known {
		t.Fatalf("an unscanned item has a custody: %+v", custody)
	}

	// A movement with nobody behind it is a movement anybody standing near
	// the reader can create.
	refused(t, tracked.RecordMovement("laundry-door", "", "", "", at),
		"names who recorded it")
	refused(t, tracked.RecordMovement("", "", "", "op-1", at),
		"says where the item was read")

	for _, scan := range []struct {
		location, holder string
		at               time.Time
	}{
		{"laundry-door", "", at},
		{"ward-3-store", "nurse-1", at.Add(2 * time.Hour)},
		{"laundry-sort", "", at.Add(time.Hour)},
	} {
		if err := tracked.RecordMovement(scan.location, scan.holder, "",
			"op-1", scan.at); err != nil {
			t.Fatalf("RecordMovement: %v", err)
		}
	}

	// The last known custody is the latest scan by time, not the last one
	// appended: a reader that uploads late must not rewrite where something
	// is.
	custody := tracked.LastKnown()
	if !custody.Known || custody.Location != "ward-3-store" ||
		custody.HolderID != "nurse-1" || custody.RecordedBy != "op-1" {
		t.Fatalf("the custody is wrong: %+v", custody)
	}
	if len(tracked.Movements) != 3 {
		t.Fatalf("a movement was dropped: %+v", tracked.Movements)
	}

	refused(t, tracked.Retire("", "lin-1", at), "say why")
	if err := tracked.Retire("worn out", "lin-1", at); err != nil {
		t.Fatalf("Retire: %v", err)
	}
	// A retired item is not something anybody carries on scanning.
	refused(t, tracked.RecordMovement("ward-3", "", "", "op-1", at),
		"this item is retired")
	refused(t, tracked.Retire("again", "lin-1", at), "already retired")
}

func TestTheStaleReportNamesWhatNobodyHasSeenAndWritesOffNothing(t *testing.T) {
	item := trackedItem(t)

	never, err := domain.RegisterTag("tr1", "t1", item, trackedInput(),
		"lin-1", at.Add(-40*24*time.Hour))
	if err != nil {
		t.Fatalf("RegisterTag: %v", err)
	}

	quiet := never
	quiet.ID, quiet.TagID, quiet.Movements = "tr2", "RF-0002", nil
	if err := quiet.RecordMovement("ward-3", "", "", "op-1",
		at.Add(-20*24*time.Hour)); err != nil {
		t.Fatalf("RecordMovement: %v", err)
	}

	recent := never
	recent.ID, recent.TagID, recent.Movements = "tr3", "RF-0003", nil
	if err := recent.RecordMovement("laundry", "", "", "op-1",
		at.Add(-time.Hour)); err != nil {
		t.Fatalf("RecordMovement: %v", err)
	}

	retired := never
	retired.ID, retired.TagID = "tr4", "RF-0004"
	retired.State = domain.TrackedRetired

	items := []domain.TrackedItem{never, quiet, recent, retired}
	stale := domain.StaleItems(items, 14*24*time.Hour, at)

	if len(stale) != 2 {
		t.Fatalf("want two stale items, got %+v", stale)
	}
	// A tag that never read once is more likely to be a tag that does not
	// work than a garment in a cupboard, so it comes first.
	if !stale[0].NeverSeen || stale[0].Item.TagID != "RF-0001" {
		t.Fatalf("want the never-seen tag first, got %+v", stale[0])
	}
	if stale[1].Item.TagID != "RF-0002" || stale[1].QuietDays != 20 {
		t.Fatalf("the quiet item is wrong: %+v", stale[1])
	}
	// Nothing here writes anything off: a uniform nobody has scanned for a
	// month is usually a uniform somebody wore past a reader that was
	// switched off.
	for _, entry := range stale {
		if entry.Item.State != domain.TrackedInService {
			t.Fatalf("the report changed an item's state: %+v", entry.Item)
		}
	}

	// A deployment that has not set a quiet period gets no report rather
	// than every item in the hospital.
	if got := domain.StaleItems(items, 0, at); got != nil {
		t.Fatalf("an unset quiet period produced a report: %+v", got)
	}
}
