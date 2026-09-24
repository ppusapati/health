package domain_test

import (
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/facilities/domain"
)

// The facilities engineering rules.
//
// Every refusal below is a rule somebody could otherwise take out, so each is
// tested by asking for the thing it forbids. The comment beside a test says
// what happens in a hospital when the rule is missing, because that is the
// only thing that justifies a rule being there.

var at = time.Date(2026, 9, 24, 8, 0, 0, 0, time.UTC)

func refused(t *testing.T, err error, contains string) {
	t.Helper()
	if err == nil {
		t.Fatalf("want a refusal mentioning %q, got none", contains)
	}
	if !strings.Contains(err.Error(), contains) {
		t.Fatalf("want a refusal mentioning %q, got %v", contains, err)
	}
}

func ok(t *testing.T, err error) {
	t.Helper()
	if err != nil {
		t.Fatalf("unexpected refusal: %v", err)
	}
}

// ------------------------------------------------------ assets (SRS-FAC-001)

func assetInput() domain.NewAssetInput {
	return domain.NewAssetInput{
		Tag: "dg-02", Name: "Generator 2",
		System: domain.SystemPower, Criticality: domain.CriticalityLife,
		FacilityID: "f1", LocationID: "ou-plantroom",
		Manufacturer: "Cummins", Model: "C750D5",
		CommissionedAt: at.AddDate(-4, 0, 0),
	}
}

func TestAnAssetCarriesLocationCriticalityAndStatus(t *testing.T) {
	// SRS-FAC-001's acceptance in one sentence: every asset has
	// location, criticality and status.
	asset, err := domain.NewAsset("a1", "t1", assetInput(), "u-est", at)
	ok(t, err)

	if asset.LocationID == "" || asset.Criticality == "" ||
		asset.Status == "" {
		t.Fatalf("an asset must carry location, criticality and status: %+v",
			asset)
	}
	if asset.Status != domain.AssetInService {
		t.Fatalf("a new asset is in service, got %s", asset.Status)
	}
	if asset.Tag != "DG-02" {
		// Tags are matched against what is stencilled on the machine,
		// and "dg-02" typed at three in the morning must find it.
		t.Fatalf("tags normalise to upper case, got %q", asset.Tag)
	}
}

func TestAnAssetWithoutALocationIsRefused(t *testing.T) {
	// An asset nobody can find is one nobody maintains, and it appears on
	// every report as plant the hospital owns and never services.
	in := assetInput()
	in.LocationID, in.LocationNote = "", ""
	_, err := domain.NewAsset("a1", "t1", in, "u-est", at)
	refused(t, err, "says where it is")
}

func TestAnAssetNoteIsLocationEnough(t *testing.T) {
	// A plant room on a roof has no org unit. Refusing it would push that
	// plant off the system altogether, which is worse than a free-text
	// location.
	in := assetInput()
	in.LocationID = ""
	in.LocationNote = "plant room, roof, north side"
	_, err := domain.NewAsset("a1", "t1", in, "u-est", at)
	ok(t, err)
}

func TestAnAssetNeedsItsTagAndName(t *testing.T) {
	in := assetInput()
	in.Tag = ""
	_, err := domain.NewAsset("a1", "t1", in, "u-est", at)
	refused(t, err, "needs its tag")

	in = assetInput()
	in.Name = ""
	_, err = domain.NewAsset("a1", "t1", in, "u-est", at)
	refused(t, err, "needs a name")
}

func TestAnAssetNeedsAnIdAndARegistrar(t *testing.T) {
	_, err := domain.NewAsset("", "t1", assetInput(), "u-est", at)
	refused(t, err, "needs an id")

	_, err = domain.NewAsset("a1", "t1", assetInput(), "", at)
	refused(t, err, "who registered it")
}

func TestAnUnknownSystemOrCriticalityIsRefused(t *testing.T) {
	// A free-text system is three systems as far as the escalation matrix
	// is concerned, and the matrix is what decides who is called at night.
	in := assetInput()
	in.System = "air conditioning"
	_, err := domain.NewAsset("a1", "t1", in, "u-est", at)
	refused(t, err, "unknown system")

	in = assetInput()
	in.Criticality = "very"
	_, err = domain.NewAsset("a1", "t1", in, "u-est", at)
	refused(t, err, "unknown criticality")
}

func TestAnAssetIsNotItsOwnParent(t *testing.T) {
	// A hierarchy read that never terminates.
	in := assetInput()
	in.ParentID = "a1"
	_, err := domain.NewAsset("a1", "t1", in, "u-est", at)
	refused(t, err, "not its own parent")
}

func TestAStatusChangeSaysWhy(t *testing.T) {
	asset, err := domain.NewAsset("a1", "t1", assetInput(), "u-est", at)
	ok(t, err)

	// A machine marked down for no recorded reason is one nobody can
	// chase, and the list of what is down reads as a list of mysteries.
	refused(t, asset.SetStatus(domain.AssetDown, "", at), "say why")
	ok(t, asset.SetStatus(domain.AssetDown, "alternator failed", at))
	if asset.StatusReason == "" || asset.Status != domain.AssetDown {
		t.Fatalf("status and reason must both be kept: %+v", asset)
	}
	// Returning to service needs no reason: nothing is being explained.
	ok(t, asset.SetStatus(domain.AssetInService, "", at))
}

func TestAnUnknownStatusIsRefused(t *testing.T) {
	asset, err := domain.NewAsset("a1", "t1", assetInput(), "u-est", at)
	ok(t, err)
	refused(t, asset.SetStatus("broken-ish", "x", at), "unknown asset status")
}

func TestADecommissionedAssetDoesNotComeBack(t *testing.T) {
	// Plant that has been removed and returns to service on a report is
	// plant somebody will be sent to maintain and will not find.
	asset, err := domain.NewAsset("a1", "t1", assetInput(), "u-est", at)
	ok(t, err)
	ok(t, asset.SetStatus(domain.AssetDecommissioned, "replaced by DG-04", at))
	refused(t, asset.SetStatus(domain.AssetInService, "", at),
		"is decommissioned")
}

func TestDescendantsWalkTheHierarchy(t *testing.T) {
	// SRS-FAC-001 asks for a hierarchy, and the hierarchy has to be
	// walkable: "everything under the medical gas system" is the question
	// a shutdown starts with.
	plant := domain.Asset{ID: "plant", Tag: "MGP"}
	manifold := domain.Asset{ID: "man", ParentID: "plant"}
	valve := domain.Asset{ID: "valve", ParentID: "man"}
	other := domain.Asset{ID: "other"}

	got := domain.Descendants(
		[]domain.Asset{plant, manifold, valve, other}, "plant")
	if len(got) != 3 {
		t.Fatalf("want the plant and its two children, got %d", len(got))
	}
}

func TestACycleInTheHierarchyDoesNotHang(t *testing.T) {
	// Two assets re-parented into each other is a data mistake, not a
	// reason for the estates screen to stop responding.
	a := domain.Asset{ID: "a", ParentID: "b"}
	b := domain.Asset{ID: "b", ParentID: "a"}
	got := domain.Descendants([]domain.Asset{a, b}, "a")
	if len(got) != 2 {
		t.Fatalf("a cycle must terminate, got %d", len(got))
	}
}

func TestCriticalDownPutsTheWorstFirst(t *testing.T) {
	// A list in tag order puts the oxygen manifold below the car park
	// barrier, which is how a facilities manager misses it.
	barrier := domain.Asset{ID: "b", Criticality: domain.CriticalityLow,
		Status: domain.AssetDown, StatusAt: at.Add(-time.Hour)}
	manifold := domain.Asset{ID: "m", Criticality: domain.CriticalityLife,
		Status: domain.AssetDegraded, StatusAt: at}
	fine := domain.Asset{ID: "f", Criticality: domain.CriticalityLife,
		Status: domain.AssetInService}

	got := domain.CriticalDown([]domain.Asset{barrier, manifold, fine})
	if len(got) != 2 {
		t.Fatalf("only the broken plant is listed, got %d", len(got))
	}
	if got[0].ID != "m" {
		t.Fatalf("the life-critical asset comes first, got %s", got[0].ID)
	}
}

func TestLifeSafetySystemsAreNamed(t *testing.T) {
	// Escalation depends on this answer, so it is asserted rather than
	// assumed.
	if !domain.SystemMedicalGas.LifeSafety() ||
		!domain.SystemFire.LifeSafety() {
		t.Fatal("medical gas and fire are life-safety systems")
	}
	if domain.SystemLifts.LifeSafety() || domain.SystemHVAC.LifeSafety() {
		t.Fatal("a lift outage is not a life-safety alarm")
	}
}

func TestOnlyInServiceCounts(t *testing.T) {
	if !domain.AssetInService.Working() {
		t.Fatal("in service is working")
	}
	if domain.AssetDegraded.Working() {
		// "Working" and "working for now" lead to different decisions.
		t.Fatal("degraded plant is not something to rely on")
	}
}

// ------------------------------------------------- work orders (SRS-FAC-002)

func openClass() domain.WorkClass {
	return domain.WorkClass{
		TenantID: "t1", Code: "general", Name: "General maintenance",
		Active: true,
	}
}

func permitClass() domain.WorkClass {
	return domain.WorkClass{
		TenantID: "t1", Code: "hv_switching", Name: "HV switching",
		RequiresPermit: true, RequiresLOTO: true, Active: true,
		Note: "11kV switchgear; two-person rule after the 2024 arc flash",
	}
}

func raiseInput() domain.RaiseInput {
	return domain.RaiseInput{
		Number: "wo-1041", FacilityID: "f1", AssetID: "a1",
		System: domain.SystemHVAC, LocationID: "ou-theatre-2",
		Fault:    "AHU-OT-1 tripping on overload",
		Impact:   "theatre 2 cannot be used",
		Priority: domain.PriorityUrgent,
		Class:    openClass(), OwnerTeam: "estates-mechanical",
	}
}

func raised(t *testing.T) domain.WorkOrder {
	t.Helper()
	w, err := domain.Raise("w1", "t1", raiseInput(),
		domain.DefaultSLAPolicy(), "u-ward", at)
	ok(t, err)
	return w
}

func TestATicketReceivesAnOwnerAndAnSLA(t *testing.T) {
	// SRS-FAC-002's acceptance exactly. A ticket with no owner waits for
	// somebody to notice it; one with no deadline is one no report can
	// ever call late.
	w := raised(t)
	if w.OwnerTeam == "" {
		t.Fatal("a work order is routed when it is raised")
	}
	if w.RespondBy.IsZero() || w.ResolveBy.IsZero() {
		t.Fatalf("a work order carries both SLA targets: %+v", w)
	}
	if !w.RespondBy.After(w.RaisedAt) || !w.ResolveBy.After(w.RespondBy) {
		t.Fatalf("SLA targets must be ordered: %+v", w)
	}
	if w.Number != "WO-1041" {
		t.Fatalf("the number a ward quotes is normalised, got %q", w.Number)
	}
}

func TestAWorkOrderWithoutAnOwnerIsRefused(t *testing.T) {
	in := raiseInput()
	in.OwnerTeam = ""
	_, err := domain.Raise("w1", "t1", in, domain.DefaultSLAPolicy(),
		"u-ward", at)
	refused(t, err, "needs an owner")
}

func TestAWorkOrderWithNoSLATargetIsRefused(t *testing.T) {
	// A priority nobody has set a target for produces a ticket with no
	// deadline, which is the same as no ticket as far as any report goes.
	_, err := domain.Raise("w1", "t1", raiseInput(),
		domain.SLAPolicy{Targets: []domain.SLATarget{{
			Priority:       domain.PriorityEmergency,
			RespondMinutes: 15, ResolveMinutes: 60,
		}}}, "u-ward", at)
	refused(t, err, "no SLA target")
}

func TestAWorkOrderSaysWhatItIsStopping(t *testing.T) {
	// Without impact every ticket is urgent, because every ticket matters
	// to whoever raised it.
	in := raiseInput()
	in.Impact = ""
	_, err := domain.Raise("w1", "t1", in, domain.DefaultSLAPolicy(),
		"u-ward", at)
	refused(t, err, "what the fault is stopping")

	in = raiseInput()
	in.Fault = ""
	_, err = domain.Raise("w1", "t1", in, domain.DefaultSLAPolicy(),
		"u-ward", at)
	refused(t, err, "what is wrong")
}

func TestAWorkOrderNeedsTheBasics(t *testing.T) {
	_, err := domain.Raise("", "t1", raiseInput(),
		domain.DefaultSLAPolicy(), "u-ward", at)
	refused(t, err, "needs an id")

	in := raiseInput()
	in.Number = ""
	_, err = domain.Raise("w1", "t1", in, domain.DefaultSLAPolicy(),
		"u-ward", at)
	refused(t, err, "needs a number")

	_, err = domain.Raise("w1", "t1", raiseInput(),
		domain.DefaultSLAPolicy(), "", at)
	refused(t, err, "who raised it")

	in = raiseInput()
	in.Priority = "asap"
	_, err = domain.Raise("w1", "t1", in, domain.DefaultSLAPolicy(),
		"u-ward", at)
	refused(t, err, "unknown priority")

	in = raiseInput()
	in.System = "aircon"
	_, err = domain.Raise("w1", "t1", in, domain.DefaultSLAPolicy(),
		"u-ward", at)
	refused(t, err, "unknown system")

	in = raiseInput()
	in.LocationID, in.LocationNote = "", ""
	_, err = domain.Raise("w1", "t1", in, domain.DefaultSLAPolicy(),
		"u-ward", at)
	refused(t, err, "where the fault is")
}

func TestAWorkOrderNeedsNoAsset(t *testing.T) {
	// A ceiling leaking into a ward is real work with no asset behind it.
	// Refusing it would push that work off the system entirely.
	in := raiseInput()
	in.AssetID = ""
	_, err := domain.Raise("w1", "t1", in, domain.DefaultSLAPolicy(),
		"u-ward", at)
	ok(t, err)
}

func TestAnInactiveOrInvalidWorkClassIsRefused(t *testing.T) {
	in := raiseInput()
	in.Class.Active = false
	_, err := domain.Raise("w1", "t1", in, domain.DefaultSLAPolicy(),
		"u-ward", at)
	refused(t, err, "not in use")

	in = raiseInput()
	in.Class.Code = ""
	_, err = domain.Raise("w1", "t1", in, domain.DefaultSLAPolicy(),
		"u-ward", at)
	refused(t, err, "needs a code")

	in = raiseInput()
	in.Class.Name = ""
	_, err = domain.Raise("w1", "t1", in, domain.DefaultSLAPolicy(),
		"u-ward", at)
	refused(t, err, "needs a name")
}

func TestAnUnsafeClassSaysWhyItIsUnsafe(t *testing.T) {
	// A class somebody marked unsafe without saying why is one the next
	// person to review the list will quietly unmark.
	class := permitClass()
	class.Note = ""
	err := class.Validate()
	refused(t, err, "needs safety paperwork")
}

func TestAnSLAPolicyIsCoherent(t *testing.T) {
	refused(t, domain.SLAPolicy{Targets: []domain.SLATarget{
		{Priority: "soon", RespondMinutes: 1, ResolveMinutes: 2},
	}}.Validate(), "unknown priority")

	refused(t, domain.SLAPolicy{Targets: []domain.SLATarget{
		{Priority: domain.PriorityUrgent, RespondMinutes: 1, ResolveMinutes: 2},
		{Priority: domain.PriorityUrgent, RespondMinutes: 3, ResolveMinutes: 4},
	}}.Validate(), "two targets")

	refused(t, domain.SLAPolicy{Targets: []domain.SLATarget{
		{Priority: domain.PriorityUrgent, RespondMinutes: 0, ResolveMinutes: 2},
	}}.Validate(), "positive targets")

	// A resolution target inside the response target is breached the
	// moment it is met.
	refused(t, domain.SLAPolicy{Targets: []domain.SLATarget{
		{Priority: domain.PriorityUrgent,
			RespondMinutes: 60, ResolveMinutes: 30},
	}}.Validate(), "resolved before it is answered")

	ok(t, domain.DefaultSLAPolicy().Validate())
}

func TestAssignmentIsTheResponse(t *testing.T) {
	// A ticket somebody has picked up has been answered, whatever else is
	// still true of it. Without this the response clock runs until
	// somebody remembers to press a second button.
	w := raised(t)
	ok(t, w.Assign("u-fitter", "estates-mechanical", at.Add(10*time.Minute)))
	if w.RespondedAt.IsZero() || w.State != domain.WorkAssigned {
		t.Fatalf("assignment answers the ticket: %+v", w)
	}
	if b := w.Breached(at.Add(time.Hour)); b.Response {
		t.Fatal("answered inside the hour is not a response breach")
	}
}

func TestAssignmentNeedsSomebody(t *testing.T) {
	w := raised(t)
	refused(t, w.Assign("", "", at), "who is taking the work")
}

func TestAClosedWorkOrderTakesNoAssignment(t *testing.T) {
	w := raised(t)
	ok(t, w.Cancel("duplicate of WO-1039", "u-est", at))
	refused(t, w.Assign("u-fitter", "", at), "is cancelled")
}

func TestPermitWorkDoesNotStartWithoutThePaperwork(t *testing.T) {
	// SRS-FAC-010. An electrician who isolated a panel and signed nothing
	// is the same as one who isolated nothing, and the person who finds
	// out is the next person to open it.
	in := raiseInput()
	in.Class = permitClass()
	in.System = domain.SystemElectrical
	w, err := domain.Raise("w1", "t1", in, domain.DefaultSLAPolicy(),
		"u-ward", at)
	ok(t, err)
	ok(t, w.Assign("u-fitter", "", at))

	refused(t, w.Start("", "", "LOTO-9", "u-fitter", at),
		"without a permit to work")
	refused(t, w.Start("PTW-77", "", "LOTO-9", "u-fitter", at),
		"who issued the permit")
	refused(t, w.Start("PTW-77", "u-auth", "", "u-fitter", at),
		"without a lockout-tagout reference")
	refused(t, w.Start("PTW-77", "u-auth", "LOTO-9", "", at),
		"who applied the lock")

	ok(t, w.Start("PTW-77", "u-auth", "LOTO-9", "u-fitter", at))
	if w.PermitRef == "" || w.LOTORef == "" {
		t.Fatalf("the references are kept: %+v", w)
	}
}

func TestTheClassFlagsAreCopiedOntoTheOrder(t *testing.T) {
	// The copy is what makes "a closed order of a permit class names its
	// permit" expressible as a database CHECK, which sees one row.
	in := raiseInput()
	in.Class = permitClass()
	w, err := domain.Raise("w1", "t1", in, domain.DefaultSLAPolicy(),
		"u-ward", at)
	ok(t, err)
	if !w.ClassRequiresPermit || !w.ClassRequiresLOTO {
		t.Fatalf("the order carries its class's flags: %+v", w)
	}
	if w.ClassCode != "hv_switching" {
		t.Fatalf("and the class it copied them from, got %q", w.ClassCode)
	}
}

func TestOrdinaryWorkStartsWithoutAPermit(t *testing.T) {
	// The rule is about classes the hospital decided are dangerous. Asking
	// every filter change for a permit is how a permit system stops being
	// believed.
	w := raised(t)
	ok(t, w.Assign("u-fitter", "", at))
	ok(t, w.Start("", "", "", "", at))
}

func TestWorkNobodyHasTakenDoesNotStart(t *testing.T) {
	// Not reachable through Assign, which insists on a name. It is
	// reachable from the database: a row in the assigned state with an
	// empty owner is what a bad migration or a hand-edited record looks
	// like, and the work must not start from one. The database carries
	// the same rule as a CHECK; this is the half that runs on a row
	// already in memory.
	w := domain.WorkOrder{
		ID: "w1", TenantID: "t1", State: domain.WorkAssigned,
		ClassCode: "general", OwnerTeam: "estates-mechanical",
	}
	refused(t, w.Start("", "", "", "", at), "nobody has taken this work")
}

func TestWorkStartsOnceItIsAssigned(t *testing.T) {
	w := raised(t)
	refused(t, w.Start("", "", "", "", at), "once it is assigned")
}

func TestWorkOnHoldSaysWhatItIsWaitingFor(t *testing.T) {
	// An order on hold for no recorded reason never comes off hold,
	// because nobody knows what to chase.
	w := raised(t)
	ok(t, w.Assign("u-fitter", "", at))
	ok(t, w.Start("", "", "", "", at))
	refused(t, w.Hold(""), "what the work is waiting for")
	ok(t, w.Hold("bearing on order, 6 weeks"))
	if w.State != domain.WorkOnHold {
		t.Fatalf("held work is on hold: %+v", w)
	}
	// And it resumes.
	ok(t, w.Start("", "", "", "", at))
	if w.HoldReason != "" {
		t.Fatalf("resuming clears the hold reason: %q", w.HoldReason)
	}
}

func TestResolvedWorkIsNotHeld(t *testing.T) {
	w := resolvedOrder(t)
	refused(t, w.Hold("waiting"), "cannot hold work that is resolved")
}

func resolvedOrder(t *testing.T) domain.WorkOrder {
	t.Helper()
	w := raised(t)
	ok(t, w.Assign("u-fitter", "", at))
	ok(t, w.Start("", "", "", "", at))
	ok(t, w.Resolve("replaced the overload relay", "relay aged", 95,
		at.Add(3*time.Hour)))
	return w
}

func TestResolutionSaysWhatWasDone(t *testing.T) {
	// The value of a maintenance history is what the engineer did, not
	// that somebody was there.
	w := raised(t)
	ok(t, w.Assign("u-fitter", "", at))
	ok(t, w.Start("", "", "", "", at))
	refused(t, w.Resolve("", "", 0, at), "say what was done")
	refused(t, w.Resolve("fixed", "", -5, at), "cannot be negative")
}

func TestOnlyWorkInProgressResolves(t *testing.T) {
	w := raised(t)
	refused(t, w.Resolve("fixed", "", 0, at), "from in_progress")
}

func TestTheEngineerDoesNotSignOffTheirOwnWork(t *testing.T) {
	// One pair of eyes is the arrangement that produces a maintenance
	// history of jobs that were all completed.
	w := resolvedOrder(t)
	refused(t, w.Close("u-fitter", at), "other than u-fitter")
	ok(t, w.Close("u-supervisor", at))
	if w.State != domain.WorkClosed || w.ClosedBy != "u-supervisor" {
		t.Fatalf("closure is recorded: %+v", w)
	}
}

func TestOnlyResolvedWorkCloses(t *testing.T) {
	w := raised(t)
	refused(t, w.Close("u-supervisor", at), "only resolved work closes")

	w = resolvedOrder(t)
	refused(t, w.Close("", at), "who closed the work order")
}

func TestResolvedWorkIsClosedRatherThanCancelled(t *testing.T) {
	// Cancelling it would lose the fact that somebody fixed something.
	w := resolvedOrder(t)
	refused(t, w.Cancel("not needed", "u-est", at),
		"closed rather than cancelled")
}

func TestCancellationSaysWhoAndWhy(t *testing.T) {
	w := raised(t)
	refused(t, w.Cancel("", "u-est", at), "why the work order is cancelled")
	refused(t, w.Cancel("duplicate", "", at), "who cancelled")
	ok(t, w.Cancel("duplicate of WO-1039", "u-est", at))
	refused(t, w.Cancel("again", "u-est", at), "already cancelled")
}

func TestABreachIsMeasuredAgainstTheTarget(t *testing.T) {
	w := raised(t)
	// Urgent: 60 minutes to answer, 1440 to resolve.
	b := w.Breached(at.Add(90 * time.Minute))
	if !b.Response || b.ResponseLateMinutes != 30 {
		t.Fatalf("thirty minutes late to answer, got %+v", b)
	}
	if b.Resolution {
		t.Fatalf("not yet late to resolve, got %+v", b)
	}
	if !b.Late() {
		t.Fatal("a response breach is late")
	}
}

func TestACancelledOrderIsNotLate(t *testing.T) {
	// Counting it would make withdrawing tickets a way to look better.
	w := raised(t)
	ok(t, w.Cancel("raised in error", "u-est", at))
	if w.Breached(at.AddDate(0, 0, 30)).Late() {
		t.Fatal("a withdrawn ticket is measured against nothing")
	}
}

func TestACriticalGasIssueGetsTheHighestConfiguredRung(t *testing.T) {
	// SRS-FAC-006's acceptance. "Configured" is the operative word: the
	// level is the top of whatever matrix the tenant set up.
	in := raiseInput()
	in.System = domain.SystemMedicalGas
	in.Priority = domain.PriorityEmergency
	in.Fault = "manifold changeover failed, VIE low"
	w, err := domain.Raise("w1", "t1", in, domain.DefaultSLAPolicy(),
		"u-ward", at)
	ok(t, err)

	if got := domain.EscalationLevel(w, domain.CriticalityLife, 4); got != 4 {
		t.Fatalf("a critical gas emergency starts at the top rung, got %d", got)
	}
	if got := domain.EscalationLevel(w, domain.CriticalityLife, 2); got != 2 {
		t.Fatalf("the top is the tenant's top, not a constant, got %d", got)
	}
	if domain.EscalationKind(domain.SystemMedicalGas) != "medical_gas" {
		t.Fatal("medical gas has its own chain")
	}
	if domain.EscalationKind(domain.SystemLifts) != "facilities" {
		t.Fatal("a lift escalates to facilities")
	}
}

func TestOrdinaryWorkStartsAtTheBottomRung(t *testing.T) {
	// Going straight to the top is reserved for the case where waiting
	// fifteen minutes to tell the next person is itself the harm. A
	// system that did it for everything would be ignored within a week.
	w := raised(t)
	if got := domain.EscalationLevel(w, domain.CriticalityLife, 4); got != 0 {
		t.Fatalf("an urgent HVAC fault starts at zero, got %d", got)
	}

	// An emergency on a life-safety system, but not life-critical plant.
	in := raiseInput()
	in.System = domain.SystemFire
	in.Priority = domain.PriorityEmergency
	w2, err := domain.Raise("w2", "t1", in, domain.DefaultSLAPolicy(),
		"u-ward", at)
	ok(t, err)
	if got := domain.EscalationLevel(w2, domain.CriticalityNormal, 4); got != 0 {
		t.Fatalf("normal plant does not jump the chain, got %d", got)
	}
	// And a life-critical emergency on a system that is not life-safety.
	in.System = domain.SystemLifts
	w3, err := domain.Raise("w3", "t1", in, domain.DefaultSLAPolicy(),
		"u-ward", at)
	ok(t, err)
	if got := domain.EscalationLevel(w3, domain.CriticalityLife, 4); got != 0 {
		t.Fatalf("a stuck lift is not a gas alarm, got %d", got)
	}
}

func TestOpenWorkPutsBreachesFirst(t *testing.T) {
	late := raised(t)
	late.ID = "late"

	fresh := raised(t)
	fresh.ID = "fresh"
	ok(t, fresh.Assign("u-fitter", "", at))

	done := resolvedOrder(t)
	done.ID = "done"
	ok(t, done.Close("u-supervisor", at.Add(4*time.Hour)))

	got := domain.OpenWork([]domain.WorkOrder{fresh, late, done},
		at.Add(90*time.Minute))
	if len(got) != 2 {
		t.Fatalf("closed work is not open work, got %d", len(got))
	}
	if got[0].ID != "late" {
		t.Fatalf("the breached order comes first, got %s", got[0].ID)
	}
}

// ------------------------------- preventive maintenance (SRS-FAC-003/007)

func calendarSchedule() domain.Schedule {
	return domain.Schedule{
		ID: "s1", TenantID: "t1", AssetID: "a1", FacilityID: "f1",
		Title: "AHU filter change", Kind: domain.MaintenancePreventive,
		Trigger: domain.TriggerCalendar, IntervalDays: 90,
		WorkClassCode: "general", Active: true,
		CreatedAt: at.AddDate(0, 0, -100), CreatedBy: "u-est",
	}
}

func statutorySchedule() domain.Schedule {
	return domain.Schedule{
		ID: "s2", TenantID: "t1", AssetID: "lift-1", FacilityID: "f1",
		Title:   "Lift thorough examination",
		Kind:    domain.MaintenanceStatutory,
		Trigger: domain.TriggerCalendar, IntervalDays: 182,
		Authority: "State Lift Inspectorate", RequiresEvidence: true,
		Active: true, CreatedAt: at.AddDate(0, 0, -200), CreatedBy: "u-est",
	}
}

func runtimeSchedule() domain.Schedule {
	return domain.Schedule{
		ID: "s3", TenantID: "t1", AssetID: "dg-2", FacilityID: "f1",
		Title:        "Generator 250-hour service",
		Kind:         domain.MaintenancePreventive,
		Trigger:      domain.TriggerEither,
		IntervalDays: 180, IntervalRuntimeHours: 250,
		Active: true, CreatedAt: at.AddDate(0, 0, -30), CreatedBy: "u-est",
	}
}

func TestAStatutoryInspectionNamesItsAuthorityAndIsEvidenced(t *testing.T) {
	// A statutory inspection whose evidence is optional is one that will
	// be marked done on the day the inspector did not come.
	s := statutorySchedule()
	s.Authority = ""
	refused(t, s.Validate(), "names who requires it")

	s = statutorySchedule()
	s.RequiresEvidence = false
	refused(t, s.Validate(), "is evidenced")
}

func TestAScheduleNeedsAnIntervalForItsTrigger(t *testing.T) {
	s := calendarSchedule()
	s.IntervalDays = 0
	refused(t, s.Validate(), "interval in days")

	s = runtimeSchedule()
	s.IntervalRuntimeHours = 0
	refused(t, s.Validate(), "interval in hours")

	// Running hours belong to a machine; a runtime schedule against a
	// building can never come due.
	s = runtimeSchedule()
	s.AssetID = ""
	refused(t, s.Validate(), "needs an asset")
}

func TestAScheduleNeedsTheBasics(t *testing.T) {
	s := calendarSchedule()
	s.Title = ""
	refused(t, s.Validate(), "needs a title")

	s = calendarSchedule()
	s.Kind = "when we remember"
	refused(t, s.Validate(), "unknown maintenance kind")

	s = calendarSchedule()
	s.Trigger = "vibes"
	refused(t, s.Validate(), "unknown trigger")

	s = calendarSchedule()
	s.GraceDays = -1
	refused(t, s.Validate(), "grace cannot be negative")
}

func TestATaskCopiesItsSchedulesKindAndEvidenceRule(t *testing.T) {
	// Same reason a work order copies its class flags: a CHECK sees one
	// row, so the task has to know it is statutory.
	task, err := domain.PlanTask("k1", statutorySchedule(),
		at.AddDate(0, 0, 7), 0, domain.TriggerCalendar, at)
	ok(t, err)
	if task.ScheduleKind != domain.MaintenanceStatutory ||
		!task.ScheduleRequiresEvidence {
		t.Fatalf("the task carries its schedule's rules: %+v", task)
	}
}

func TestATaskNeedsADueDateOrADueReading(t *testing.T) {
	// A task due neither on a date nor at a reading never appears on any
	// list.
	_, err := domain.PlanTask("k1", calendarSchedule(), time.Time{}, 0,
		domain.TriggerCalendar, at)
	refused(t, err, "due date or a due reading")

	_, err = domain.PlanTask("", calendarSchedule(), at, 0,
		domain.TriggerCalendar, at)
	refused(t, err, "needs an id")

	s := calendarSchedule()
	s.Active = false
	_, err = domain.PlanTask("k1", s, at, 0, domain.TriggerCalendar, at)
	refused(t, err, "not active")

	_, err = domain.PlanTask("k1", calendarSchedule(), at, 0, "guesswork", at)
	refused(t, err, "unknown trigger")

	s = calendarSchedule()
	s.Title = ""
	_, err = domain.PlanTask("k1", s, at, 0, domain.TriggerCalendar, at)
	refused(t, err, "needs a title")
}

func TestAStatutoryInspectionClosesWithACertificateAndAnExpiry(t *testing.T) {
	// SRS-FAC-003's acceptance is that evidence is reportable. A
	// certificate with no expiry is one nobody renews, and the first
	// anybody hears of it is the inspector.
	task, err := domain.PlanTask("k1", statutorySchedule(),
		at.AddDate(0, 0, -1), 0, domain.TriggerCalendar, at)
	ok(t, err)

	refused(t, task.Complete(domain.CompleteInput{
		Findings: "passed", EvidenceRef: "doc-1",
	}, "u-insp", at), "closes with a certificate")

	refused(t, task.Complete(domain.CompleteInput{
		Findings: "passed", EvidenceRef: "doc-1", CertificateRef: "LI-88",
	}, "u-insp", at), "when the certificate expires")

	refused(t, task.Complete(domain.CompleteInput{
		Findings: "passed", EvidenceRef: "doc-1", CertificateRef: "LI-88",
		CertificateExpiresAt: at.AddDate(0, 0, -1),
	}, "u-insp", at), "already expired")

	ok(t, task.Complete(domain.CompleteInput{
		Findings: "passed", EvidenceRef: "doc-1", CertificateRef: "LI-88",
		CertificateExpiresAt: at.AddDate(0, 6, 0),
	}, "u-insp", at))
	if task.State != domain.TaskDone {
		t.Fatalf("a completed inspection is done: %+v", task)
	}
}

func TestAnEvidencedTaskDoesNotCloseOnSomebodysWord(t *testing.T) {
	s := calendarSchedule()
	s.RequiresEvidence = true
	task, err := domain.PlanTask("k1", s, at, 0, domain.TriggerCalendar, at)
	ok(t, err)
	refused(t, task.Complete(domain.CompleteInput{Findings: "changed"},
		"u-fitter", at), "closes with evidence")
}

func TestCompletionRecordsWhatWasFound(t *testing.T) {
	// "Done" is not a finding.
	task, err := domain.PlanTask("k1", calendarSchedule(), at, 0,
		domain.TriggerCalendar, at)
	ok(t, err)
	refused(t, task.Complete(domain.CompleteInput{}, "u-fitter", at),
		"record what was found")
	refused(t, task.Complete(domain.CompleteInput{Findings: "ok"}, "", at),
		"who did the work")

	ok(t, task.Complete(domain.CompleteInput{Findings: "filters replaced"},
		"u-fitter", at))
	refused(t, task.Complete(domain.CompleteInput{Findings: "again"},
		"u-fitter", at), "already done")
}

func TestAHospitalCannotWaiveItsOwnLiftInspection(t *testing.T) {
	// If the inspection genuinely cannot happen, the schedule is what
	// changes, with somebody's name on that decision.
	task, err := domain.PlanTask("k1", statutorySchedule(), at, 0,
		domain.TriggerCalendar, at)
	ok(t, err)
	refused(t, task.Waive("lift out of service", "u-est", at),
		"not waived")
}

func TestAWaivedTaskSaysWhoAndWhy(t *testing.T) {
	task, err := domain.PlanTask("k1", calendarSchedule(), at, 0,
		domain.TriggerCalendar, at)
	ok(t, err)
	refused(t, task.Waive("", "u-est", at), "why the task was not done")
	refused(t, task.Waive("ward closed", "", at), "who waived")
	ok(t, task.Waive("ward closed for refurbishment", "u-est", at))
	refused(t, task.Waive("again", "u-est", at), "already waived")
}

func TestAMissedTaskIsKept(t *testing.T) {
	// The reportable fact SRS-FAC-003 asks for is the inspection that did
	// not happen, so a missed occurrence is a state rather than a
	// deletion.
	task, err := domain.PlanTask("k1", calendarSchedule(), at, 0,
		domain.TriggerCalendar, at)
	ok(t, err)
	ok(t, task.Miss(at))
	if task.State != domain.TaskMissed {
		t.Fatalf("a missed task is missed: %+v", task)
	}
	refused(t, task.Miss(at), "already missed")
}

func TestATaskGoesOverdueAfterItsGrace(t *testing.T) {
	task, err := domain.PlanTask("k1", calendarSchedule(),
		at.AddDate(0, 0, -5), 0, domain.TriggerCalendar, at)
	ok(t, err)
	if task.Overdue(7, at) {
		t.Fatal("inside grace is not overdue")
	}
	if !task.Overdue(0, at) {
		t.Fatal("past due with no grace is overdue")
	}
}

func TestPreventiveMaintenanceUsesARuntimeTrigger(t *testing.T) {
	// SRS-FAC-007's acceptance. A generator serviced only on the calendar
	// runs a monsoon's worth of hours between services.
	s := runtimeSchedule()
	due, isDue := domain.NextDue(s, at.AddDate(0, 0, -30), 1000, 1260, at)
	if !isDue {
		t.Fatal("260 hours past the last service is due")
	}
	if due.By != domain.TriggerRuntime {
		t.Fatalf("and it is the hours that did it, got %s", due.By)
	}
	if due.DueRuntimeHours != 1250 {
		t.Fatalf("due at 1250 hours, got %d", due.DueRuntimeHours)
	}

	// The same schedule, not enough hours and not enough days.
	_, isDue = domain.NextDue(s, at.AddDate(0, 0, -30), 1000, 1100, at)
	if isDue {
		t.Fatal("100 hours into a 250-hour interval is not due")
	}
}

func TestACalendarScheduleComesDueOnTime(t *testing.T) {
	s := calendarSchedule()
	due, isDue := domain.NextDue(s, at.AddDate(0, 0, -100), 0, 0, at)
	if !isDue || due.By != domain.TriggerCalendar {
		t.Fatalf("100 days into a 90-day interval is due on the calendar: %+v",
			due)
	}
	if !due.Overdue {
		t.Fatal("ten days past due with no grace is overdue")
	}

	_, isDue = domain.NextDue(s, at.AddDate(0, 0, -10), 0, 0, at)
	if isDue {
		t.Fatal("ten days into a 90-day interval is not due")
	}
}

func TestAnInactiveOrInvalidScheduleIsNeverDue(t *testing.T) {
	s := calendarSchedule()
	s.Active = false
	if _, isDue := domain.NextDue(s, at.AddDate(0, 0, -100), 0, 0, at); isDue {
		t.Fatal("a schedule nobody runs any more does not come due")
	}

	s = calendarSchedule()
	s.IntervalDays = 0
	if _, isDue := domain.NextDue(s, at.AddDate(0, 0, -100), 0, 0, at); isDue {
		t.Fatal("an incoherent schedule cannot be due")
	}
}

func TestARuntimeCounterDoesNotGoBackwards(t *testing.T) {
	// SRS-FAC-007. A generator whose hours dropped from 4,000 to 12 has a
	// new hour meter or a mistyped reading, and silently accepting it
	// makes every service after it fire at the wrong time.
	_, err := domain.RecordRuntime("r1", "t1", "a1", 12, at,
		domain.SourceManual, "", false, "", "u-fitter", 4000, at)
	refused(t, err, "below the last reading")

	// Unless the counter was genuinely replaced, and said so.
	_, err = domain.RecordRuntime("r1", "t1", "a1", 12, at,
		domain.SourceManual, "", true, "", "u-fitter", 4000, at)
	refused(t, err, "what happened to the counter")

	reading, err := domain.RecordRuntime("r1", "t1", "a1", 12, at,
		domain.SourceManual, "", true,
		"hour meter replaced under warranty", "u-fitter", 4000, at)
	ok(t, err)
	if !reading.CounterReplaced {
		t.Fatalf("the replacement is on the record: %+v", reading)
	}
}

func TestARuntimeReadingKeepsItsProvenance(t *testing.T) {
	// A figure typed by a technician and one polled from a BMS are not
	// interchangeable, and SRS-FAC-009's rule applies to SRS-FAC-007's
	// data too.
	_, err := domain.RecordRuntime("r1", "t1", "a1", 4200, at,
		domain.SourceBMS, "", false, "", "u-gw", 4000, at)
	refused(t, err, "names its source")

	_, err = domain.RecordRuntime("r1", "t1", "a1", 4200, at,
		"guess", "x", false, "", "u-gw", 4000, at)
	refused(t, err, "unknown source")

	reading, err := domain.RecordRuntime("r1", "t1", "a1", 4200, at,
		domain.SourceBMS, "bms:DG2.RunHours", false, "", "u-gw", 4000, at)
	ok(t, err)
	if reading.SourceRef == "" {
		t.Fatalf("the reference is kept: %+v", reading)
	}
}

func TestARuntimeReadingNeedsTheBasics(t *testing.T) {
	_, err := domain.RecordRuntime("", "t1", "a1", 10, at,
		domain.SourceManual, "", false, "", "u", 0, at)
	refused(t, err, "needs an id")

	_, err = domain.RecordRuntime("r1", "t1", "", 10, at,
		domain.SourceManual, "", false, "", "u", 0, at)
	refused(t, err, "names its asset")

	_, err = domain.RecordRuntime("r1", "t1", "a1", -1, at,
		domain.SourceManual, "", false, "", "u", 0, at)
	refused(t, err, "cannot be negative")

	_, err = domain.RecordRuntime("r1", "t1", "a1", 10, time.Time{},
		domain.SourceManual, "", false, "", "u", 0, at)
	refused(t, err, "when it was taken")

	_, err = domain.RecordRuntime("r1", "t1", "a1", 10, at.AddDate(0, 0, 1),
		domain.SourceManual, "", false, "", "u", 0, at)
	refused(t, err, "in the future")

	_, err = domain.RecordRuntime("r1", "t1", "a1", 10, at,
		domain.SourceManual, "", false, "", "", 0, at)
	refused(t, err, "who recorded it")
}

func TestTheMaintenanceReportSeparatesStatutoryOverdue(t *testing.T) {
	// The rest is housekeeping; a missed statutory inspection is a
	// licence problem, and a single "overdue" number hides it.
	planned, err := domain.PlanTask("k1", calendarSchedule(),
		at.AddDate(0, 0, -30), 0, domain.TriggerCalendar, at)
	ok(t, err)
	statutory, err := domain.PlanTask("k2", statutorySchedule(),
		at.AddDate(0, 0, -10), 0, domain.TriggerCalendar, at)
	ok(t, err)
	done, err := domain.PlanTask("k3", calendarSchedule(), at, 0,
		domain.TriggerCalendar, at)
	ok(t, err)
	ok(t, done.Complete(domain.CompleteInput{Findings: "filters replaced"},
		"u-fitter", at))

	report := domain.SummariseMaintenance(
		[]domain.Task{planned, statutory, done}, 0, at)
	if report.Overdue != 2 || report.StatutoryOverdue != 1 {
		t.Fatalf("two overdue, one of them statutory: %+v", report)
	}
	if report.Done != 1 || report.EvidenceMissing != 0 {
		t.Fatalf("one done, evidenced: %+v", report)
	}
	if len(report.OverdueTasks) != 2 ||
		report.OverdueTasks[0].ID != "k2" {
		t.Fatalf("the statutory one is listed first: %+v",
			report.OverdueTasks)
	}
}

// ------------------------------------- utilities and KPIs (SRS-FAC-009)

func kwhMeter() domain.Meter {
	return domain.Meter{
		ID: "m1", TenantID: "t1", Code: "LV-MAIN-1",
		Name: "LV panel 1", Utility: domain.UtilityElectricity,
		Unit: "kWh", FacilityID: "f1",
		Source: domain.SourceAMI, SourceRef: "ami:00291",
		Cumulative: true, RegisterMax: 99999, Active: true,
	}
}

func TestAMeterDeclaresItsUnitAndItsSource(t *testing.T) {
	// A number with no unit is not a measurement, and a figure whose
	// origin was not kept cannot be argued with or corrected.
	m := kwhMeter()
	m.Unit = ""
	refused(t, m.Validate(), "declares its unit")

	m = kwhMeter()
	m.SourceRef = ""
	refused(t, m.Validate(), "names its source reference")

	m = kwhMeter()
	m.Source = "somewhere"
	refused(t, m.Validate(), "unknown source")

	m = kwhMeter()
	m.Utility = "electric"
	refused(t, m.Validate(), "unknown utility")

	m = kwhMeter()
	m.Code = ""
	refused(t, m.Validate(), "needs a code")
}

func TestOnlyACountingRegisterWraps(t *testing.T) {
	// A maximum on an instantaneous meter is a rule that would fire on a
	// perfectly good reading.
	m := kwhMeter()
	m.Cumulative = false
	refused(t, m.Validate(), "only a cumulative meter wraps")

	m = kwhMeter()
	m.RegisterMax = -1
	refused(t, m.Validate(), "cannot be negative")
}

func TestAReadingKeepsItsOwnProvenance(t *testing.T) {
	// The point of recording it per reading rather than per meter is the
	// night the gateway was down and somebody read the dial.
	r, err := domain.RecordReading("r1", "t1", kwhMeter(), 41200, at,
		domain.SourceManual, "", false, "gateway offline", "u-fitter", at)
	ok(t, err)
	if r.Source != domain.SourceManual {
		t.Fatalf("the reading's own source is kept: %+v", r)
	}

	_, err = domain.RecordReading("r1", "t1", kwhMeter(), 41200, at,
		domain.SourceAMI, "", false, "", "u-gw", at)
	refused(t, err, "names its source")
}

func TestAReadingIsRefusedWhenItCannotBeTrue(t *testing.T) {
	_, err := domain.RecordReading("r1", "t1", kwhMeter(), -1, at,
		domain.SourceManual, "", false, "", "u", at)
	refused(t, err, "cannot be negative")

	// Past the register's maximum is a mistyped digit.
	_, err = domain.RecordReading("r1", "t1", kwhMeter(), 412000, at,
		domain.SourceManual, "", false, "", "u", at)
	refused(t, err, "past this register's maximum")

	_, err = domain.RecordReading("r1", "t1", kwhMeter(), 100,
		at.AddDate(0, 0, 1), domain.SourceManual, "", false, "", "u", at)
	refused(t, err, "in the future")

	_, err = domain.RecordReading("r1", "t1", kwhMeter(), 100, time.Time{},
		domain.SourceManual, "", false, "", "u", at)
	refused(t, err, "when it was taken")

	_, err = domain.RecordReading("", "t1", kwhMeter(), 100, at,
		domain.SourceManual, "", false, "", "u", at)
	refused(t, err, "needs an id")

	_, err = domain.RecordReading("r1", "t1", kwhMeter(), 100, at,
		domain.SourceManual, "", false, "", "", at)
	refused(t, err, "who recorded it")

	_, err = domain.RecordReading("r1", "t1", kwhMeter(), 100, at,
		"guess", "", false, "", "u", at)
	refused(t, err, "unknown source")

	m := kwhMeter()
	m.Active = false
	_, err = domain.RecordReading("r1", "t1", m, 100, at,
		domain.SourceManual, "", false, "", "u", at)
	refused(t, err, "not in use")

	m = kwhMeter()
	m.Unit = ""
	_, err = domain.RecordReading("r1", "t1", m, 100, at,
		domain.SourceManual, "", false, "", "u", at)
	refused(t, err, "declares its unit")
}

func TestARolloverCannotBeClaimedOnARegisterThatDoesNotWrap(t *testing.T) {
	// Otherwise a mistyped reading is accepted as a real one.
	m := kwhMeter()
	m.RegisterMax = 0
	_, err := domain.RecordReading("r1", "t1", m, 100, at,
		domain.SourceManual, "", true, "", "u", at)
	refused(t, err, "no register maximum")
}

func reading(t *testing.T, id string, value int, offsetHours int,
	source domain.Source, rolled bool) domain.Reading {

	t.Helper()
	ref := ""
	if source != domain.SourceManual {
		ref = "ami:00291"
	}
	r, err := domain.RecordReading(id, "t1", kwhMeter(), value,
		at.Add(time.Duration(offsetHours)*time.Hour), source, ref,
		rolled, "", "u-gw", at.AddDate(0, 0, 1))
	ok(t, err)
	return r
}

func TestConsumptionCarriesItsMeterAndItsSources(t *testing.T) {
	// SRS-FAC-009's acceptance: metrics retain meter/source provenance. A
	// number that reached the command centre without it cannot be checked.
	readings := []domain.Reading{
		reading(t, "r1", 41000, 0, domain.SourceAMI, false),
		reading(t, "r2", 41500, 12, domain.SourceAMI, false),
	}
	got, isOK := domain.Consume(kwhMeter(), readings, at, at.Add(24*time.Hour))
	if !isOK {
		t.Fatal("two readings make a consumption figure")
	}
	if got.Quantity != 500 {
		t.Fatalf("500 kWh between the two readings, got %d", got.Quantity)
	}
	if got.MeterID != "m1" || got.Unit != "kWh" ||
		got.Utility != domain.UtilityElectricity {
		t.Fatalf("the figure names its meter: %+v", got)
	}
	if len(got.Sources) != 1 || got.Sources[0] != domain.SourceAMI {
		t.Fatalf("and its sources: %+v", got)
	}
	if got.Estimated {
		t.Fatal("two instrument readings are not an estimate")
	}
}

func TestAConsumptionBuiltOnATypedReadingSaysSo(t *testing.T) {
	// A figure that is 90% instrument and 10% clipboard is an estimate,
	// and saying so is the honest thing.
	readings := []domain.Reading{
		reading(t, "r1", 41000, 0, domain.SourceAMI, false),
		reading(t, "r2", 41500, 12, domain.SourceManual, false),
	}
	got, isOK := domain.Consume(kwhMeter(), readings, at, at.Add(24*time.Hour))
	if !isOK || !got.Estimated {
		t.Fatalf("a hand-read figure is an estimate: %+v", got)
	}
	if len(got.Sources) != 2 {
		t.Fatalf("both provenances are kept: %+v", got.Sources)
	}
}

func TestASingleReadingIsNotAConsumptionFigure(t *testing.T) {
	// One reading of a counting register says where the counter stands,
	// not what was used. Reporting it as consumption is the mistake that
	// has a hospital using four million units in an hour.
	readings := []domain.Reading{
		reading(t, "r1", 41000, 0, domain.SourceAMI, false),
	}
	if _, isOK := domain.Consume(kwhMeter(), readings, at,
		at.Add(24*time.Hour)); isOK {
		t.Fatal("one reading of a cumulative meter yields nothing")
	}
}

func TestARegisterRolloverIsHandled(t *testing.T) {
	// The night a five-digit meter wraps, an unaware system reports the
	// hospital consumed negative ninety-nine thousand units.
	readings := []domain.Reading{
		reading(t, "r1", 99800, 0, domain.SourceAMI, false),
		reading(t, "r2", 300, 12, domain.SourceAMI, true),
	}
	got, isOK := domain.Consume(kwhMeter(), readings, at, at.Add(24*time.Hour))
	if !isOK {
		t.Fatal("a declared rollover is still a consumption figure")
	}
	if got.Quantity != 499 {
		t.Fatalf("199 to the top plus 300 after it, got %d", got.Quantity)
	}
	if got.Rollovers != 1 {
		t.Fatalf("the wrap is counted so it can be traced: %+v", got)
	}
}

func TestACounterThatWentBackwardsYieldsNothing(t *testing.T) {
	// Contributing nothing is wrong and contributing a negative is worse.
	// The honest answer is that the series is not trustworthy.
	readings := []domain.Reading{
		reading(t, "r1", 41500, 0, domain.SourceAMI, false),
		reading(t, "r2", 41000, 12, domain.SourceAMI, false),
	}
	if _, isOK := domain.Consume(kwhMeter(), readings, at,
		at.Add(24*time.Hour)); isOK {
		t.Fatal("an undeclared backwards step is not a consumption figure")
	}
}

func TestAnInstantaneousMeterIsNotDifferenced(t *testing.T) {
	m := kwhMeter()
	m.Cumulative, m.RegisterMax = false, 0
	m.Utility, m.Unit = domain.UtilityOxygen, "bar"
	r1, err := domain.RecordReading("r1", "t1", m, 40, at,
		domain.SourceSCADA, "scada:VIE1", false, "", "u-gw", at)
	ok(t, err)
	r2, err := domain.RecordReading("r2", "t1", m, 36, at.Add(2*time.Hour),
		domain.SourceSCADA, "scada:VIE1", false, "", "u-gw", at.Add(3*time.Hour))
	ok(t, err)

	got, isOK := domain.Consume(m, []domain.Reading{r1, r2}, at,
		at.Add(24*time.Hour))
	if !isOK {
		t.Fatalf("an instantaneous meter still answers: %+v", got)
	}
	// Not 76. Adding a pressure to a pressure is how a VIE at 36 bar
	// reads as one at nearly eighty, which is a cylinder store nobody
	// goes to check.
	if got.Quantity != 36 {
		t.Fatalf("the last reading is the measurement, got %d",
			got.Quantity)
	}
	if got.Readings != 2 {
		t.Fatalf("and it says how many it rested on: %+v", got)
	}
}

func TestReadingsOutsideTheWindowAreIgnored(t *testing.T) {
	readings := []domain.Reading{
		reading(t, "r1", 41000, -48, domain.SourceAMI, false),
		reading(t, "r2", 41500, 0, domain.SourceAMI, false),
	}
	if _, isOK := domain.Consume(kwhMeter(), readings, at,
		at.Add(24*time.Hour)); isOK {
		t.Fatal("only one reading falls in the window")
	}

	// A reading belonging to another meter is not this meter's.
	other := readings[0]
	other.MeterID = "m2"
	other.ReadAt = at.Add(time.Hour)
	if _, isOK := domain.Consume(kwhMeter(),
		[]domain.Reading{readings[1], other}, at,
		at.Add(24*time.Hour)); isOK {
		t.Fatal("another meter's readings do not count")
	}
}

func TestDowntimeCarriesTheIncidentsBehindIt(t *testing.T) {
	// A downtime KPI with no way back to the incidents cannot be
	// investigated, and a suspiciously low figure must declare its gap.
	measured := resolvedOrder(t)
	measured.ID = "measured"

	unmeasured := resolvedOrder(t)
	unmeasured.ID = "unmeasured"
	unmeasured.DowntimeMinutes = 0

	open := raised(t)
	open.ID = "open"

	got := domain.SummariseDowntime(
		[]domain.WorkOrder{measured, unmeasured, open},
		at, at.AddDate(0, 0, 1))
	if len(got) != 1 {
		t.Fatalf("one system had downtime, got %d", len(got))
	}
	if got[0].Minutes != 95 || got[0].Incidents != 1 {
		t.Fatalf("95 minutes from one incident: %+v", got[0])
	}
	if len(got[0].WorkOrderIDs) != 1 || got[0].WorkOrderIDs[0] != "measured" {
		t.Fatalf("the provenance is the order: %+v", got[0])
	}
	if got[0].Unmeasured != 1 {
		t.Fatalf("the gap declares itself: %+v", got[0])
	}
}

func TestOpenWorkDoesNotContributeDowntimeYet(t *testing.T) {
	// An open order's downtime is still accruing, and including it would
	// make yesterday's KPI change tomorrow.
	open := raised(t)
	open.DowntimeMinutes = 500
	got := domain.SummariseDowntime([]domain.WorkOrder{open}, at,
		at.AddDate(0, 0, 1))
	if len(got) != 0 {
		t.Fatalf("nothing is closed, so nothing is counted: %+v", got)
	}
}

func TestMeasuredSourcesAreNamed(t *testing.T) {
	if !domain.SourceAMI.Measured() || !domain.SourceSCADA.Measured() ||
		!domain.SourceBMS.Measured() {
		t.Fatal("instruments are measured sources")
	}
	if domain.SourceManual.Measured() ||
		domain.SourceCalculated.Measured() {
		// A calculated figure inherits every error in its inputs.
		t.Fatal("a typed or derived figure is not measured")
	}
}

// --------------------------------------- planned outages (SRS-FAC-004)

func outageInput() domain.PlanOutageInput {
	return domain.PlanOutageInput{
		Reference: "sd-2026-031", FacilityID: "f1",
		System:      domain.SystemElectrical,
		Title:       "LV panel 3 maintenance shutdown",
		Reason:      "thermographic survey found a hot joint on the busbar",
		PlannedFrom: at.AddDate(0, 0, 7),
		PlannedTo:   at.AddDate(0, 0, 7).Add(4 * time.Hour),
		Contingency: "ward 5 on the UPS ring; theatres unaffected",
	}
}

func planned(t *testing.T) domain.Outage {
	t.Helper()
	o, err := domain.PlanOutage("o1", "t1", outageInput(), "u-est", at)
	ok(t, err)
	return o
}

func areas(t *testing.T, o domain.Outage) []domain.OutageArea {
	t.Helper()
	ward, err := domain.AddArea("ar1", o, "ou-ward5", "Ward 5", false, at)
	ok(t, err)
	theatre, err := domain.AddArea("ar2", o, "ou-ot", "Theatres", true, at)
	ok(t, err)
	return []domain.OutageArea{ward, theatre}
}

func TestAnOutageNamesItsWindowAndItsReason(t *testing.T) {
	o := planned(t)
	if o.State != domain.OutagePlanned || o.Reference != "SD-2026-031" {
		t.Fatalf("a requested outage is planned: %+v", o)
	}

	in := outageInput()
	in.Reason = ""
	_, err := domain.PlanOutage("o1", "t1", in, "u-est", at)
	refused(t, err, "why the supply has to go off")

	in = outageInput()
	in.PlannedTo = in.PlannedFrom
	_, err = domain.PlanOutage("o1", "t1", in, "u-est", at)
	refused(t, err, "ends after it starts")

	in = outageInput()
	in.PlannedFrom = time.Time{}
	_, err = domain.PlanOutage("o1", "t1", in, "u-est", at)
	refused(t, err, "needs a planned window")
}

func TestAnOutageNeedsTheBasics(t *testing.T) {
	_, err := domain.PlanOutage("", "t1", outageInput(), "u-est", at)
	refused(t, err, "needs an id")

	in := outageInput()
	in.Reference = ""
	_, err = domain.PlanOutage("o1", "t1", in, "u-est", at)
	refused(t, err, "needs a permit reference")

	in = outageInput()
	in.Title = ""
	_, err = domain.PlanOutage("o1", "t1", in, "u-est", at)
	refused(t, err, "needs a title")

	in = outageInput()
	in.System = "the mains"
	_, err = domain.PlanOutage("o1", "t1", in, "u-est", at)
	refused(t, err, "unknown system")

	_, err = domain.PlanOutage("o1", "t1", outageInput(), "", at)
	refused(t, err, "who requested it")
}

func TestAreasAreDeclaredBeforeThePermitIsSigned(t *testing.T) {
	// Adding one afterwards means the permit was approved against a
	// different set of consequences from the one that applied.
	o := planned(t)
	list := areas(t, o)
	ok(t, o.Approve(list, "PTW-12", "u-manager", at))

	_, err := domain.AddArea("ar3", o, "ou-icu", "ICU", true, at)
	refused(t, err, "while the outage is still planned")
}

func TestAnAreaNeedsAnIdentity(t *testing.T) {
	o := planned(t)
	_, err := domain.AddArea("ar1", o, "", "", false, at)
	refused(t, err, "needs a department or a name")

	_, err = domain.AddArea("", o, "ou-ward5", "Ward 5", false, at)
	refused(t, err, "needs an id")
}

func TestAnOutageThatReachesNobodyIsRefused(t *testing.T) {
	// The acceptance is that impacted departments receive a notification,
	// and an outage with no declared areas has not been thought about.
	o := planned(t)
	refused(t, o.Approve(nil, "PTW-12", "u-manager", at),
		"which departments the outage reaches")
}

func TestTheEngineerWhoWantsTheShutdownDoesNotApproveIt(t *testing.T) {
	// The whole value of a permit is that somebody else looked.
	o := planned(t)
	refused(t, o.Approve(areas(t, o), "PTW-12", "u-est", at),
		"other than u-est")
	refused(t, o.Approve(areas(t, o), "PTW-12", "", at),
		"who approved the outage")
}

func TestACriticalAreaNeedsAContingency(t *testing.T) {
	// Otherwise this is a decision to take the theatre's supply away and
	// hope, made by nobody in particular.
	in := outageInput()
	in.Contingency = ""
	o, err := domain.PlanOutage("o1", "t1", in, "u-est", at)
	ok(t, err)
	refused(t, o.Approve(areas(t, o), "PTW-12", "u-manager", at),
		"covers the critical areas")
}

func TestALifeSafetyShutdownNeedsAPermitToWork(t *testing.T) {
	// Taking the medical gas or the fire system off needs a permit behind
	// it, not just an estates note.
	in := outageInput()
	in.System = domain.SystemMedicalGas
	o, err := domain.PlanOutage("o1", "t1", in, "u-est", at)
	ok(t, err)
	refused(t, o.Approve(areas(t, o), "", "u-manager", at),
		"needs a permit to work")
	ok(t, o.Approve(areas(t, o), "PTW-12", "u-manager", at))
}

func TestAnOutageIsApprovedOnce(t *testing.T) {
	o := planned(t)
	list := areas(t, o)
	ok(t, o.Approve(list, "PTW-12", "u-manager", at))
	refused(t, o.Approve(list, "PTW-12", "u-manager", at), "already approved")
}

func TestASupplyDoesNotGoOffUntilTheCriticalAreasHaveAnswered(t *testing.T) {
	// SRS-FAC-004's acceptance with teeth. "We emailed theatres" and
	// "theatres know" are different facts, and only the second is safe to
	// cut the power on.
	o := planned(t)
	list := areas(t, o)
	ok(t, o.Approve(list, "PTW-12", "u-manager", at))

	refused(t, o.TakeEffect(list, at), "has not been notified")

	for i := range list {
		ok(t, list[i].Notify(at))
	}
	refused(t, o.TakeEffect(list, at), "Theatres has not acknowledged")

	ok(t, list[1].Acknowledge("u-ot-manager", "", at))
	ok(t, o.TakeEffect(list, at))
	if o.State != domain.OutageInEffect || o.ActualFrom.IsZero() {
		t.Fatalf("the supply is off: %+v", o)
	}
}

func TestANonCriticalAreaDoesNotBlockTheShutdown(t *testing.T) {
	// A ward being told is enough; requiring every office to answer is
	// how a permit system becomes something people route around.
	o := planned(t)
	list := areas(t, o)
	ok(t, o.Approve(list, "PTW-12", "u-manager", at))
	for i := range list {
		ok(t, list[i].Notify(at))
	}
	ok(t, list[1].Acknowledge("u-ot-manager", "", at))
	ok(t, o.TakeEffect(list, at))
}

func TestAnAcknowledgementNeedsANotice(t *testing.T) {
	// Otherwise a row makes an unnotified outage look consulted.
	o := planned(t)
	list := areas(t, o)
	refused(t, list[0].Acknowledge("u-ward", "", at), "has not been notified")

	ok(t, list[0].Notify(at))
	refused(t, list[0].Acknowledge("", "", at), "who answered for the area")
	ok(t, list[0].Acknowledge("u-ward", "we lose the drug fridge", at))
	if list[0].Objection == "" {
		// A ward cannot veto a statutory shutdown, but the objection
		// being on the record changes how the conversation goes.
		t.Fatalf("the objection is kept: %+v", list[0])
	}
}

func TestACancelledOutageIsNotNotified(t *testing.T) {
	o := planned(t)
	list := areas(t, o)
	ok(t, o.CancelOutage("hot joint re-torqued live", at))
	list[0].OutageState = o.State
	refused(t, list[0].Notify(at), "this outage is cancelled")
}

func TestAnOutageInEffectIsRestoredRatherThanCancelled(t *testing.T) {
	// Cancelling it would leave the record saying the shutdown never
	// happened while the ward sat in the dark.
	o := inEffect(t)
	refused(t, o.CancelOutage("changed our minds", at),
		"restored, not cancelled")
	refused(t, o.Restore("", at), "who restored the supply")
	ok(t, o.Restore("u-est", at.Add(3*time.Hour)))
	if o.State != domain.OutageRestored || o.ActualTo.IsZero() {
		t.Fatalf("the supply is back: %+v", o)
	}
	refused(t, o.Restore("u-est", at), "only an outage in effect")
}

func inEffect(t *testing.T) domain.Outage {
	t.Helper()
	o := planned(t)
	list := areas(t, o)
	ok(t, o.Approve(list, "PTW-12", "u-manager", at))
	for i := range list {
		ok(t, list[i].Notify(at))
	}
	ok(t, list[1].Acknowledge("u-ot-manager", "", at))
	ok(t, o.TakeEffect(list, at))
	return o
}

func TestAnUnapprovedOutageDoesNotTakeEffect(t *testing.T) {
	o := planned(t)
	refused(t, o.TakeEffect(areas(t, o), at), "once approved")
}

func TestCancellationSaysWhy(t *testing.T) {
	o := planned(t)
	refused(t, o.CancelOutage("", at), "why the outage was cancelled")
	ok(t, o.CancelOutage("survey repeated, joint is cold", at))
	refused(t, o.CancelOutage("again", at), "already cancelled")
}

func TestOverlappingShutdownsOfOneSystemAreVisible(t *testing.T) {
	first := planned(t)
	second := planned(t)
	second.ID = "o2"
	if !first.Overlaps(second) {
		t.Fatal("two live electrical shutdowns in the same window overlap")
	}

	second.System = domain.SystemHVAC
	if first.Overlaps(second) {
		t.Fatal("different systems do not")
	}

	second.System = domain.SystemElectrical
	second.PlannedFrom = first.PlannedTo.Add(time.Hour)
	second.PlannedTo = second.PlannedFrom.Add(time.Hour)
	if first.Overlaps(second) {
		t.Fatal("consecutive windows do not overlap")
	}

	// And a cancelled one is not in anybody's way.
	second.PlannedFrom, second.PlannedTo = first.PlannedFrom, first.PlannedTo
	ok(t, second.CancelOutage("no longer needed", at))
	if first.Overlaps(second) {
		t.Fatal("a cancelled outage does not overlap")
	}
	if first.Overlaps(first) {
		t.Fatal("an outage does not overlap itself")
	}
}

// --------------------------------------------- SCADA alarms (SRS-FAC-005)

func ingestInput() domain.IngestInput {
	return domain.IngestInput{
		GatewayID: "gw-plant-1", PointRef: "MGP.VIE1.LowPressure",
		ExternalID: "evt-99120", AssetID: "a-vie1", FacilityID: "f1",
		System: domain.SystemMedicalGas, Severity: domain.SeverityCritical,
		Message: "VIE 1 low pressure alarm", Source: domain.SourceSCADA,
		RaisedAt: at.Add(-5 * time.Minute),
	}
}

func ingested(t *testing.T) domain.Alarm {
	t.Helper()
	a, err := domain.Ingest("al1", "t1", ingestInput(), at)
	ok(t, err)
	return a
}

func TestAnAlarmCarriesTheGatewaysOwnEventId(t *testing.T) {
	// A gateway reconnecting after a network drop replays everything it
	// buffered, and without this there is no way to recognise a replay.
	in := ingestInput()
	in.ExternalID = ""
	_, err := domain.Ingest("al1", "t1", in, at)
	refused(t, err, "the gateway's event id")
}

func TestAlarmsComeFromPlantNotPeople(t *testing.T) {
	// Letting somebody type an alarm would put fabricated plant events
	// into the record the command centre trusts because it came off the
	// gateway. A person who has noticed something raises a work order.
	in := ingestInput()
	in.Source = domain.SourceManual
	_, err := domain.Ingest("al1", "t1", in, at)
	refused(t, err, "from plant, not people")
}

func TestAnAlarmNeedsItsOrigin(t *testing.T) {
	in := ingestInput()
	in.GatewayID = ""
	_, err := domain.Ingest("al1", "t1", in, at)
	refused(t, err, "names its gateway")

	in = ingestInput()
	in.PointRef = ""
	_, err = domain.Ingest("al1", "t1", in, at)
	refused(t, err, "names its point")

	in = ingestInput()
	in.Message = ""
	_, err = domain.Ingest("al1", "t1", in, at)
	refused(t, err, "needs its message")

	_, err = domain.Ingest("", "t1", ingestInput(), at)
	refused(t, err, "needs an id")

	in = ingestInput()
	in.System = "gas"
	_, err = domain.Ingest("al1", "t1", in, at)
	refused(t, err, "unknown system")

	in = ingestInput()
	in.Severity = "bad"
	_, err = domain.Ingest("al1", "t1", in, at)
	refused(t, err, "unknown severity")

	in = ingestInput()
	in.Source = "somewhere"
	_, err = domain.Ingest("al1", "t1", in, at)
	refused(t, err, "unknown source")

	in = ingestInput()
	in.RaisedAt = time.Time{}
	_, err = domain.Ingest("al1", "t1", in, at)
	refused(t, err, "when it was raised")

	in = ingestInput()
	in.RaisedAt = at.AddDate(0, 0, 1)
	_, err = domain.Ingest("al1", "t1", in, at)
	refused(t, err, "in the future")
}

func TestAnAlarmAndItsWorkOrderStayDistinct(t *testing.T) {
	// SRS-FAC-005's acceptance. A chiller whose alarm cleared because
	// somebody cycled the power has not been repaired, and an order
	// somebody completed does not make the plant stop shouting.
	alarm := ingested(t)
	order := raised(t)
	ok(t, alarm.LinkWork(order.ID, "u-est", at))

	// Close the work: the alarm is untouched.
	ok(t, order.Assign("u-fitter", "", at))
	ok(t, order.Start("", "", "", "", at))
	ok(t, order.Resolve("changed the regulator", "", 20, at))
	ok(t, order.Close("u-supervisor", at))
	if !alarm.Open() {
		t.Fatal("closing the work order must not clear the alarm")
	}

	// Clear the alarm: the work order is untouched.
	alarm2 := ingested(t)
	order2 := raised(t)
	ok(t, alarm2.LinkWork(order2.ID, "u-est", at))
	ok(t, alarm2.Clear(at))
	if !order2.State.Open() {
		t.Fatal("clearing the alarm must not close the work order")
	}
	if alarm2.WorkOrderID != order2.ID {
		t.Fatal("and the link survives both")
	}
}

func TestAnAlarmIsLinkedToOneWorkOrder(t *testing.T) {
	// "What did we do about the gas alarm on the 14th" has one answer,
	// and it is whichever order was raised at the time.
	alarm := ingested(t)
	ok(t, alarm.LinkWork("w1", "u-est", at))
	refused(t, alarm.LinkWork("w2", "u-est", at), "already linked to w1")
	// Linking the same order again is not an error; a retried call is
	// not a second decision.
	ok(t, alarm.LinkWork("w1", "u-est", at.Add(time.Minute)))
	if !alarm.LinkedAt.Equal(at) {
		t.Fatalf("the first link stands: %v", alarm.LinkedAt)
	}

	fresh := ingested(t)
	refused(t, fresh.LinkWork("", "u-est", at), "name the work order")
	refused(t, fresh.LinkWork("w1", "", at), "who linked the work")
}

func TestAClearedAlarmStaysCleared(t *testing.T) {
	alarm := ingested(t)
	ok(t, alarm.Clear(at))
	refused(t, alarm.Clear(at), "already cleared")
	if alarm.ClearedAt.IsZero() {
		t.Fatalf("the clear time is kept: %+v", alarm)
	}
}

func TestAClearedAlarmCanStillBeAcknowledged(t *testing.T) {
	// A pressure dip at 3am that cleared itself still needs somebody to
	// have looked at it. Refusing would mean the only alarms anybody can
	// be shown to have read are the ones still sounding when they arrived.
	alarm := ingested(t)
	ok(t, alarm.Clear(at))
	ok(t, alarm.AcknowledgeAlarm("u-duty", at))
	if !alarm.Acknowledged() {
		t.Fatalf("the acknowledgement is recorded: %+v", alarm)
	}
	refused(t, alarm.AcknowledgeAlarm("u-other", at), "already acknowledged")

	fresh := ingested(t)
	refused(t, fresh.AcknowledgeAlarm("", at), "who acknowledged")
}

func gasRule() domain.AlarmRule {
	return domain.AlarmRule{
		TenantID: "t1", FacilityID: "f1",
		System: domain.SystemMedicalGas, MinSeverity: domain.SeverityMajor,
		Priority: domain.PriorityEmergency, ClassCode: "gas_work",
		OwnerTeam: "estates-gas", Active: true,
	}
}

func TestAnAlarmRaisesWorkOnlyWhenConfigured(t *testing.T) {
	// SRS-FAC-005 says "when configured". A hospital that wires every
	// informational state change to a work order produces a thousand
	// tickets a week and stops reading any of them.
	alarm := ingested(t)
	if _, found := domain.RuleFor(nil, alarm); found {
		t.Fatal("no rules means no work")
	}

	rule, found := domain.RuleFor([]domain.AlarmRule{gasRule()}, alarm)
	if !found || rule.OwnerTeam != "estates-gas" {
		t.Fatalf("the gas rule matches a critical gas alarm: %+v", rule)
	}

	quiet := gasRule()
	quiet.MinSeverity = domain.SeverityCritical
	minor := ingested(t)
	minor.Severity = domain.SeverityMinor
	if _, found := domain.RuleFor([]domain.AlarmRule{quiet}, minor); found {
		t.Fatal("a minor alarm does not meet a critical threshold")
	}

	inactive := gasRule()
	inactive.Active = false
	if _, found := domain.RuleFor([]domain.AlarmRule{inactive},
		alarm); found {
		t.Fatal("a rule nobody switched on does not fire")
	}

	elsewhere := gasRule()
	elsewhere.FacilityID = "f2"
	if _, found := domain.RuleFor([]domain.AlarmRule{elsewhere},
		alarm); found {
		t.Fatal("another hospital's rule does not fire here")
	}

	wrongSystem := gasRule()
	wrongSystem.System = domain.SystemHVAC
	if _, found := domain.RuleFor([]domain.AlarmRule{wrongSystem},
		alarm); found {
		t.Fatal("an HVAC rule does not answer a gas alarm")
	}
}

func TestTheMostSpecificRuleWins(t *testing.T) {
	// A rule written for this hospital beats a tenant-wide default,
	// because somebody sat down and wrote it for this hospital.
	wide := gasRule()
	wide.FacilityID = ""
	wide.OwnerTeam = "estates-central"

	got, found := domain.RuleFor(
		[]domain.AlarmRule{wide, gasRule()}, ingested(t))
	if !found || got.OwnerTeam != "estates-gas" {
		t.Fatalf("the facility rule wins: %+v", got)
	}
}

func TestAnAlarmRuleIsCoherent(t *testing.T) {
	r := gasRule()
	r.System = "gas"
	refused(t, r.Validate(), "unknown system")

	r = gasRule()
	r.MinSeverity = "loud"
	refused(t, r.Validate(), "unknown severity")

	r = gasRule()
	r.Priority = "now"
	refused(t, r.Validate(), "unknown priority")

	r = gasRule()
	r.ClassCode = ""
	refused(t, r.Validate(), "names the work class")

	r = gasRule()
	r.OwnerTeam = ""
	refused(t, r.Validate(), "names who the work goes to")

	ok(t, gasRule().Validate())
}

func TestGeneratedWorkAdmitsItIsGenerated(t *testing.T) {
	// A ticket claiming a human had assessed the impact would be worse
	// than one that admits it is an automatic transcription of an alarm.
	work := domain.WorkFor(gasRule(), ingested(t))
	if !strings.Contains(work.Impact, "not yet assessed") {
		t.Fatalf("the impact line is honest: %q", work.Impact)
	}
	if !strings.Contains(work.Fault, "VIE 1 low pressure alarm") {
		t.Fatalf("the gateway's own words are carried: %q", work.Fault)
	}
	if work.Priority != domain.PriorityEmergency ||
		work.OwnerTeam != "estates-gas" {
		t.Fatalf("the rule shapes the work: %+v", work)
	}
}

func TestUnansweredAlarmsAreListedLoudestFirst(t *testing.T) {
	// An alarm that came and went without anybody acknowledging it is the
	// one worth looking at: the plant told the hospital something and the
	// hospital was not listening.
	critical := ingested(t)
	critical.ID = "critical"
	ok(t, critical.Clear(at))

	minor := ingested(t)
	minor.ID = "minor"
	minor.Severity = domain.SeverityMinor

	info := ingested(t)
	info.ID = "info"
	info.Severity = domain.SeverityInfo

	seen := ingested(t)
	seen.ID = "seen"
	ok(t, seen.AcknowledgeAlarm("u-duty", at))

	got := domain.UnansweredAlarms(
		[]domain.Alarm{minor, critical, info, seen})
	if len(got) != 2 {
		t.Fatalf("two unanswered alarms worth showing, got %d", len(got))
	}
	if got[0].ID != "critical" {
		t.Fatalf("the critical one first, got %s", got[0].ID)
	}
}

func TestSeverityOrdering(t *testing.T) {
	if !domain.SeverityCritical.AtLeast(domain.SeverityMajor) {
		t.Fatal("critical is at least major")
	}
	if domain.SeverityMinor.AtLeast(domain.SeverityMajor) {
		t.Fatal("minor is not")
	}
}

// -------------------------------------- fire and life safety (SRS-FAC-008)

func deficiencyInput() domain.RaiseDeficiencyInput {
	return domain.RaiseDeficiencyInput{
		TaskID: "k-fire-q3", FacilityID: "f1",
		LocationNote: "stair core B, level 3",
		System:       domain.SystemFire, Severity: domain.SeverityCritical,
		Finding:  "fire door wedged open, self-closer disconnected",
		Standard: "NFPA 101 7.2.1.8",
		DueAt:    at.AddDate(0, 0, 7), WorkOrderID: "w-fire-1",
	}
}

func deficiency(t *testing.T) domain.Deficiency {
	t.Helper()
	d, err := domain.RaiseDeficiency("d1", "t1", deficiencyInput(),
		"u-fire-officer", at)
	ok(t, err)
	return d
}

func TestACriticalDeficiencyGetsWorkAndADate(t *testing.T) {
	// A critical deficiency that is only a note is one nobody is assigned
	// to, and one with no date is one that is never late.
	in := deficiencyInput()
	in.WorkOrderID = ""
	_, err := domain.RaiseDeficiency("d1", "t1", in, "u-fire-officer", at)
	refused(t, err, "needs work raised against it")

	in = deficiencyInput()
	in.DueAt = time.Time{}
	_, err = domain.RaiseDeficiency("d1", "t1", in, "u-fire-officer", at)
	refused(t, err, "date to be fixed by")

	in = deficiencyInput()
	in.DueAt = at.AddDate(0, 0, -1)
	_, err = domain.RaiseDeficiency("d1", "t1", in, "u-fire-officer", at)
	refused(t, err, "due date has passed")
}

func TestAMinorDeficiencyNeedsNoWorkOrder(t *testing.T) {
	// A chipped escape-route sign is recorded and batched. Demanding a
	// ticket for each is how an inspection stops being done properly.
	in := deficiencyInput()
	in.Severity = domain.SeverityMinor
	in.WorkOrderID, in.DueAt = "", time.Time{}
	_, err := domain.RaiseDeficiency("d1", "t1", in, "u-fire-officer", at)
	ok(t, err)
}

func TestALifeSafetyDeficiencyIsAtLeastMinor(t *testing.T) {
	// Something is either a breach or an observation, and the second one
	// is a note on the inspection.
	in := deficiencyInput()
	in.Severity = domain.SeverityInfo
	_, err := domain.RaiseDeficiency("d1", "t1", in, "u-fire-officer", at)
	refused(t, err, "at least minor")
}

func TestADeficiencyNeedsTheBasics(t *testing.T) {
	_, err := domain.RaiseDeficiency("", "t1", deficiencyInput(),
		"u-fire-officer", at)
	refused(t, err, "needs an id")

	in := deficiencyInput()
	in.Finding = ""
	_, err = domain.RaiseDeficiency("d1", "t1", in, "u-fire-officer", at)
	refused(t, err, "say what is deficient")

	in = deficiencyInput()
	in.System = "fire doors"
	_, err = domain.RaiseDeficiency("d1", "t1", in, "u-fire-officer", at)
	refused(t, err, "unknown system")

	in = deficiencyInput()
	in.Severity = "serious"
	_, err = domain.RaiseDeficiency("d1", "t1", in, "u-fire-officer", at)
	refused(t, err, "unknown severity")

	in = deficiencyInput()
	in.LocationID, in.LocationNote, in.AssetID = "", "", ""
	_, err = domain.RaiseDeficiency("d1", "t1", in, "u-fire-officer", at)
	refused(t, err, "where the deficiency is")

	_, err = domain.RaiseDeficiency("d1", "t1", deficiencyInput(), "", at)
	refused(t, err, "who raised the deficiency")
}

func TestAMitigationIsNotAClosure(t *testing.T) {
	// SRS-FAC-008's acceptance: open critical deficiencies remain visible
	// until closure. A fire watch recorded as a fix is how a hospital ends
	// up with a fire watch nobody stands down and a door nobody repairs.
	d := deficiency(t)
	ok(t, d.Mitigate("fire watch posted on level 3 until the closer is fitted",
		"u-fire-officer", at))
	if d.State != domain.DeficiencyMitigated {
		t.Fatalf("the interim measure is recorded: %+v", d)
	}
	if !d.State.Open() {
		t.Fatal("a mitigated deficiency is still open")
	}

	got := domain.OpenCritical([]domain.Deficiency{d})
	if len(got) != 1 {
		t.Fatal("and it stays on the open critical list until closure")
	}
}

func TestAMitigationSaysWhatItIs(t *testing.T) {
	// "Mitigated" with nothing said is a deficiency that has been
	// downgraded rather than managed.
	d := deficiency(t)
	refused(t, d.Mitigate("", "u-fire-officer", at), "interim measure is")
	refused(t, d.Mitigate("fire watch", "", at), "who put the measure")
}

func TestACriticalDeficiencyDoesNotCloseOnSomebodysWord(t *testing.T) {
	d := deficiency(t)
	refused(t, d.CloseDeficiency("", "u-estates", at),
		"closes with evidence, not a note")
	// And not by the inspector who found it.
	refused(t, d.CloseDeficiency("photo-1", "u-fire-officer", at),
		"other than u-fire-officer")

	ok(t, d.CloseDeficiency("photo-1", "u-estates", at))
	if d.State.Open() {
		t.Fatalf("a closed deficiency is closed: %+v", d)
	}
	refused(t, d.CloseDeficiency("photo-1", "u-estates", at),
		"already closed")
	other := deficiency(t)
	refused(t, other.CloseDeficiency("photo-1", "", at),
		"who closed the deficiency")
}

func TestAClosedDeficiencyIsNotMitigated(t *testing.T) {
	d := deficiency(t)
	ok(t, d.CloseDeficiency("photo-1", "u-estates", at))
	refused(t, d.Mitigate("fire watch", "u-fire-officer", at),
		"is closed")
}

func TestAMinorDeficiencyClosesWithoutEvidence(t *testing.T) {
	// The evidence rule is about critical findings. Applying it to every
	// chipped sign is how an inspection backlog is created.
	in := deficiencyInput()
	in.Severity = domain.SeverityMinor
	in.WorkOrderID, in.DueAt = "", time.Time{}
	d, err := domain.RaiseDeficiency("d1", "t1", in, "u-fire-officer", at)
	ok(t, err)
	ok(t, d.CloseDeficiency("", "u-fire-officer", at))
}

func TestCriticalFindingsBlockTheInspectionSignOff(t *testing.T) {
	// Without this a fire inspection closes with its own findings
	// outstanding and the report reads as a pass.
	open := deficiency(t)
	open.ID = "open"

	mitigated := deficiency(t)
	mitigated.ID = "mitigated"
	ok(t, mitigated.Mitigate("fire watch posted", "u-fire-officer", at))

	minorIn := deficiencyInput()
	minorIn.Severity = domain.SeverityMinor
	minorIn.WorkOrderID, minorIn.DueAt = "", time.Time{}
	minor, err := domain.RaiseDeficiency("minor", "t1", minorIn,
		"u-fire-officer", at)
	ok(t, err)

	got := domain.Blocking("k-fire-q3",
		[]domain.Deficiency{open, mitigated, minor})
	if len(got) != 1 || got[0].ID != "open" {
		// A mitigated finding does not block the paperwork — there is
		// somebody standing there — but it stays on the open list.
		t.Fatalf("only the unmitigated critical finding blocks: %+v", got)
	}

	if len(domain.Blocking("k-other",
		[]domain.Deficiency{open})) != 0 {
		t.Fatal("another inspection's findings do not block this one")
	}
}

func TestOpenCriticalPutsTheUnmitigatedFirst(t *testing.T) {
	mitigated := deficiency(t)
	mitigated.ID = "mitigated"
	mitigated.DueAt = at.AddDate(0, 0, 1)
	ok(t, mitigated.Mitigate("fire watch posted", "u-fire-officer", at))

	open := deficiency(t)
	open.ID = "open"
	open.DueAt = at.AddDate(0, 0, 30)

	closed := deficiency(t)
	closed.ID = "closed"
	ok(t, closed.CloseDeficiency("photo-1", "u-estates", at))

	got := domain.OpenCritical(
		[]domain.Deficiency{mitigated, open, closed})
	if len(got) != 2 {
		t.Fatalf("the closed one is gone, got %d", len(got))
	}
	if got[0].ID != "open" {
		t.Fatalf("nothing in place comes first, got %s", got[0].ID)
	}
}

func TestTheSafetyReportShowsTheOldestOutstandingFinding(t *testing.T) {
	// One number a board can be shown and cannot misread.
	old := deficiency(t)
	old.ID = "old"
	old.RaisedAt = at.AddDate(0, 0, -200)
	old.DueAt = at.AddDate(0, 0, -100)

	recent := deficiency(t)
	recent.ID = "recent"

	closed := deficiency(t)
	closed.ID = "closed"
	ok(t, closed.CloseDeficiency("photo-1", "u-estates", at))

	report := domain.SummariseSafety(
		[]domain.Deficiency{old, recent, closed},
		at.AddDate(0, 0, -30), at.AddDate(0, 0, 1), at)
	if report.OpenCritical != 2 {
		t.Fatalf("two open critical findings: %+v", report)
	}
	if report.OldestOpenDays != 200 {
		t.Fatalf("the oldest has been open 200 days, got %d",
			report.OldestOpenDays)
	}
	if report.Overdue != 1 {
		t.Fatalf("one is past its date: %+v", report)
	}
	if report.ClosedInWindow != 1 {
		t.Fatalf("one was closed in the window: %+v", report)
	}
}

// -------------------------------------- contractor visits (SRS-FAC-011)

func visitInput() domain.SignInInput {
	return domain.SignInInput{
		VendorName: "Coolair Services", VendorRef: "PO-2211",
		ContactName: "R Menon", Technicians: []string{"S Kumar", "A Das"},
		FacilityID: "f1", WorkOrderID: "w1",
		Purpose: "quarterly chiller service",
	}
}

func visit(t *testing.T) domain.Visit {
	t.Helper()
	v, err := domain.SignIn("v1", "t1", visitInput(), "u-security", at)
	ok(t, err)
	return v
}

func TestAVendorVisitIsLinkedToWorkOrAnAsset(t *testing.T) {
	// SRS-FAC-011's acceptance. A contractor who came, did something to
	// the plant and left with no record of which plant is why a
	// maintenance history has gaps nobody can explain when the machine
	// fails two years later.
	in := visitInput()
	in.WorkOrderID, in.AssetID, in.TaskID = "", "", ""
	_, err := domain.SignIn("v1", "t1", in, "u-security", at)
	refused(t, err, "work order, asset or task")

	// Any one of the three is enough.
	in.AssetID = "a1"
	_, err = domain.SignIn("v1", "t1", in, "u-security", at)
	ok(t, err)

	in.AssetID, in.TaskID = "", "k1"
	_, err = domain.SignIn("v1", "t1", in, "u-security", at)
	ok(t, err)
}

func TestPermitWorkNeedsTheContractorsInduction(t *testing.T) {
	// SRS-FAC-010 reaching the people who are most likely not to know the
	// building: a contractor doing permit work has a recorded induction.
	in := visitInput()
	in.WorkRequiresPermit = true
	_, err := domain.SignIn("v1", "t1", in, "u-security", at)
	refused(t, err, "site induction on record")

	in.InductionRef = "IND-4412"
	v, err := domain.SignIn("v1", "t1", in, "u-security", at)
	ok(t, err)
	if !v.WorkRequiresPermit {
		t.Fatalf("the flag is carried for the database's sake: %+v", v)
	}

	// The flag is copied from a work order, so setting it without one
	// would leave a foreign key with nothing on the other end.
	in.WorkOrderID = ""
	in.AssetID = "a1"
	_, err = domain.SignIn("v1", "t1", in, "u-security", at)
	refused(t, err, "names its work order")
}

func TestAVisitNamesWhoCame(t *testing.T) {
	// A visit by nobody in particular cannot be matched against the
	// induction record or the gate log — or checked during an evacuation.
	in := visitInput()
	in.Technicians = nil
	_, err := domain.SignIn("v1", "t1", in, "u-security", at)
	refused(t, err, "who came on site")

	in.Technicians = []string{"  ", ""}
	_, err = domain.SignIn("v1", "t1", in, "u-security", at)
	refused(t, err, "who came on site")
}

func TestAVisitNeedsTheBasics(t *testing.T) {
	_, err := domain.SignIn("", "t1", visitInput(), "u-security", at)
	refused(t, err, "needs an id")

	in := visitInput()
	in.VendorName = ""
	_, err = domain.SignIn("v1", "t1", in, "u-security", at)
	refused(t, err, "names the contractor")

	in = visitInput()
	in.Purpose = ""
	_, err = domain.SignIn("v1", "t1", in, "u-security", at)
	refused(t, err, "what the contractor came to do")

	_, err = domain.SignIn("v1", "t1", visitInput(), "", at)
	refused(t, err, "who signed the contractor in")
}

func TestAVisitClosesWithAServiceReport(t *testing.T) {
	// The report is what SRS-FAC-011 is actually asking to be kept, and
	// the summary is what appears in the asset's history — the reference
	// points at a PDF nobody will open.
	v := visit(t)
	refused(t, v.SignOut(domain.SignOutInput{ReportSummary: "serviced"},
		"u-security", at), "closes with the service report")
	refused(t, v.SignOut(domain.SignOutInput{ServiceReportRef: "sr-1"},
		"u-security", at), "summarise what the contractor did")
	refused(t, v.SignOut(domain.SignOutInput{
		ServiceReportRef: "sr-1", ReportSummary: "serviced",
	}, "", at), "who signed the contractor out")

	ok(t, v.SignOut(domain.SignOutInput{
		ServiceReportRef: "sr-1",
		ReportSummary:    "compressor 2 replaced; refrigerant topped up",
		PartsUsed:        []string{"compressor CS-220", "compressor CS-220"},
		FollowUp:         "condenser coils need cleaning before summer",
	}, "u-security", at.Add(4*time.Hour)))

	if v.State != domain.VisitDeparted || v.SignedOutAt.IsZero() {
		t.Fatalf("the contractor has left: %+v", v)
	}
	if len(v.PartsUsed) != 1 {
		t.Fatalf("a part listed twice is one part: %+v", v.PartsUsed)
	}
	if v.FollowUp == "" {
		// Otherwise it is said out loud in a corridor and lost.
		t.Fatal("the follow-up is captured")
	}
	refused(t, v.SignOut(domain.SignOutInput{
		ServiceReportRef: "sr-2", ReportSummary: "again",
	}, "u-security", at), "already signed out")
}

func TestOnSiteListsTheLongestVisitFirst(t *testing.T) {
	// The order that surfaces the visit somebody forgot to sign out, and
	// during an evacuation the list that matters.
	early := visit(t)
	early.ID = "early"
	early.SignedInAt = at.Add(-6 * time.Hour)

	late := visit(t)
	late.ID = "late"

	gone := visit(t)
	gone.ID = "gone"
	ok(t, gone.SignOut(domain.SignOutInput{
		ServiceReportRef: "sr-9", ReportSummary: "done",
	}, "u-security", at))

	got := domain.OnSite([]domain.Visit{late, early, gone})
	if len(got) != 2 {
		t.Fatalf("two contractors are still in the building, got %d",
			len(got))
	}
	if got[0].ID != "early" {
		t.Fatalf("the one here longest comes first, got %s", got[0].ID)
	}
}
