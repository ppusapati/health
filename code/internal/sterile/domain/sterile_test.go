package domain_test

import (
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/sterile/domain"
)

// The sterile services rules (SRS-CSSD-001 … 012).
//
// The stage sequence is asserted exhaustively rather than by example: every
// stage, tried from every other stage, is 64 combinations and small enough to
// check. A sequence verified by three cases is a sequence with sixty-one
// untested transitions, and the one that matters is the one that lets an
// unwashed instrument into a pack.

var at = time.Date(2026, 9, 18, 8, 0, 0, 0, time.UTC)

const shelfLife = 180 * 24 * time.Hour

func set(t *testing.T, mutate func(*domain.NewTraySetInput)) domain.TraySet {
	t.Helper()

	in := domain.NewTraySetInput{
		Code: "LAP-MAJOR", Display: "Laparotomy major", Kind: "tray",
		Items: []domain.PackingItem{
			{Code: "BLADE-HANDLE", Display: "Blade handle", Quantity: 2,
				Critical: true},
			{Code: "MOSQUITO", Display: "Mosquito forceps", Quantity: 10},
			{Code: "RETRACTOR", Display: "Deaver retractor", Quantity: 2},
		},
		ShelfLife: shelfLife,
	}
	if mutate != nil {
		mutate(&in)
	}
	out, err := domain.NewTraySet("set-1", "tenant-1", in, "cssd-1", at)
	if err != nil {
		t.Fatalf("NewTraySet: %v", err)
	}
	return out
}

func fullCount() map[string]int {
	return map[string]int{"BLADE-HANDLE": 2, "MOSQUITO": 10, "RETRACTOR": 2}
}

// SRS-CSSD-001. A set with no packing list cannot be assembled against
// anything, and every count after it would pass.
func TestASetNeedsAPackingListThatMakesSense(t *testing.T) {
	cases := []struct {
		name   string
		mutate func(*domain.NewTraySetInput)
	}{
		{"no items", func(in *domain.NewTraySetInput) { in.Items = nil }},
		{"no code", func(in *domain.NewTraySetInput) { in.Code = "" }},
		{"an item with no code", func(in *domain.NewTraySetInput) {
			in.Items = []domain.PackingItem{{Quantity: 1}}
		}},
		{"an item with no quantity", func(in *domain.NewTraySetInput) {
			in.Items = []domain.PackingItem{{Code: "X"}}
		}},
		{"one code twice", func(in *domain.NewTraySetInput) {
			in.Items = []domain.PackingItem{
				{Code: "X", Quantity: 1}, {Code: "X", Quantity: 2},
			}
		}},
	}
	for _, c := range cases {
		in := domain.NewTraySetInput{
			Code: "T", Items: []domain.PackingItem{{Code: "A", Quantity: 1}},
		}
		c.mutate(&in)
		if _, err := domain.NewTraySet("set-x", "tenant-1", in,
			"cssd-1", at); err == nil {
			t.Errorf("%s: accepted", c.name)
		} else if !errors.Is(err, domain.ErrInvalidSet) {
			t.Errorf("%s: wrong error type: %v", c.name, err)
		}
	}
}

// SRS-CSSD-001. A revision does not change what earlier packs were checked
// against.
func TestARevisionLeavesTheEarlierListAlone(t *testing.T) {
	first := set(t, nil)

	next, err := first.Revise("set-2", domain.NewTraySetInput{
		Display: "Laparotomy major", Kind: "tray",
		Items: []domain.PackingItem{
			{Code: "BLADE-HANDLE", Quantity: 2, Critical: true},
			{Code: "MOSQUITO", Quantity: 12},
		},
		ShelfLife: shelfLife,
	}, "cssd-2", at.Add(24*time.Hour))
	if err != nil {
		t.Fatalf("Revise: %v", err)
	}

	if next.Version != 2 || next.Supersedes != first.ID {
		t.Errorf("revision = v%d supersedes %q", next.Version, next.Supersedes)
	}
	if next.Code != first.Code {
		t.Errorf("code = %q; a revision is the same set", next.Code)
	}
	if first.Expected()["MOSQUITO"] != 10 {
		t.Error("the earlier packing list changed under a pack that was " +
			"already checked against it")
	}
	if next.Expected()["RETRACTOR"] != 0 {
		t.Error("the retractor survived a revision that removed it")
	}

	current, ok := domain.CurrentSet([]domain.TraySet{first, next})
	if !ok || current.Version != 2 {
		t.Errorf("current = v%d ok=%v, want v2", current.Version, ok)
	}
}

// SRS-CSSD-003. The whole stage table, every transition.
//
// This is the rule the department exists to enforce: an instrument packed
// without being washed carries the last patient's tissue into the next one.
func TestTheStageSequenceIsTheWholeTable(t *testing.T) {
	stages := []domain.Stage{
		domain.StageReceived, domain.StageDecontaminated, domain.StageWashed,
		domain.StageInspected, domain.StageAssembled, domain.StagePackaged,
		domain.StageSterilised, domain.StageReleased,
	}

	for i, from := range stages {
		for j, to := range stages {
			run := domain.Run{
				ID: "run-1", TenantID: "tenant-1", Stage: from,
			}
			// Sterilisation and release need their own calls, so this asserts
			// the sequence rule alone: exactly one step forward.
			_, err := run.Advance("stage-1", domain.AdvanceInput{Stage: to},
				"cssd-1", at)

			wantOK := j == i+1
			if wantOK && err != nil {
				t.Errorf("%s -> %s was refused: %v", from, to, err)
			}
			if !wantOK && err == nil {
				t.Errorf("%s -> %s was accepted; only the next stage is", from, to)
			}
		}
	}
}

func received(t *testing.T) domain.Run {
	t.Helper()
	run, short, err := domain.Receive("run-1", "tenant-1", domain.ReceiveInput{
		SetID: "set-1", SourceUnit: "theatre 3", SourceCaseID: "case-1",
		Counted: fullCount(),
	}, set(t, nil), "cssd-1", at)
	if err != nil {
		t.Fatalf("Receive: %v", err)
	}
	if len(short) != 0 {
		t.Fatalf("a full set arrived short: %v", short)
	}
	return run
}

// SRS-CSSD-002. The chain of custody begins with source, time and user, and a
// short set is reported rather than refused.
func TestReceiptBeginsTheChainAndReportsAShortfall(t *testing.T) {
	if _, _, err := domain.Receive("run-x", "tenant-1", domain.ReceiveInput{
		SetID: "set-1", Counted: fullCount(),
	}, set(t, nil), "cssd-1", at); err == nil {
		t.Error("a receipt with no source unit was accepted; the chain of " +
			"custody would begin nowhere")
	}

	run, short, err := domain.Receive("run-1", "tenant-1", domain.ReceiveInput{
		SetID: "set-1", SourceUnit: "theatre 3",
		Counted: map[string]int{"BLADE-HANDLE": 2, "MOSQUITO": 8, "RETRACTOR": 2},
	}, set(t, nil), "cssd-1", at)
	if err != nil {
		t.Fatalf("Receive: %v", err)
	}
	// Reported, not refused: the set is on the counter whatever the count
	// says, and refusing it would leave the shortfall unwritten.
	if len(short) != 1 || short[0] != "MOSQUITO" {
		t.Errorf("shortfall = %v, want [MOSQUITO]", short)
	}
	if run.Stage != domain.StageReceived {
		t.Errorf("stage = %q, want received", run.Stage)
	}
	if run.SourceUnit != "theatre 3" || run.StartedBy != "cssd-1" {
		t.Errorf("custody = %+v", run)
	}
	if run.SetVersion != 1 {
		t.Errorf("set version = %d; the pack must name the list it was "+
			"checked against", run.SetVersion)
	}
}

// SRS-CSSD-003. A skip needs a named authoriser and a reason, and two stages
// cannot be skipped at all.
func TestASkippedStageNeedsAuthorityAndTwoAreNeverSkippable(t *testing.T) {
	run := received(t)

	if _, err := run.Advance("s-1", domain.AdvanceInput{
		Stage: domain.StageDecontaminated, Skipped: true,
		SkipReason: "washer down",
	}, "cssd-1", at); err == nil {
		t.Error("a skip with no authoriser was accepted")
	}
	if _, err := run.Advance("s-1", domain.AdvanceInput{
		Stage: domain.StageDecontaminated, Skipped: true,
		SkipAuthorisedBy: "manager-1",
	}, "cssd-1", at); err == nil {
		t.Error("a skip with no reason was accepted")
	}

	if _, err := run.Advance("s-1", domain.AdvanceInput{
		Stage: domain.StageDecontaminated, Skipped: true,
		SkipAuthorisedBy: "manager-1",
		SkipReason:       "pre-cleaned at point of use, washer down",
	}, "cssd-1", at); err != nil {
		t.Fatalf("an authorised skip was refused: %v", err)
	}
	if run.Stage != domain.StageDecontaminated {
		t.Errorf("stage = %q; a skipped stage still advances the run", run.Stage)
	}
	if skipped := run.SkippedStages(); len(skipped) != 1 {
		t.Errorf("skipped = %v, want the decontamination", skipped)
	}

	// Walk to sterilisation and try to skip it.
	for _, stage := range []domain.Stage{
		domain.StageWashed, domain.StageInspected, domain.StageAssembled,
		domain.StagePackaged,
	} {
		if _, err := run.Advance("s-"+string(stage),
			domain.AdvanceInput{Stage: stage}, "cssd-1", at); err != nil {
			t.Fatalf("Advance %s: %v", stage, err)
		}
	}
	if _, err := run.Advance("s-ster", domain.AdvanceInput{
		Stage: domain.StageSterilised, Skipped: true,
		SkipAuthorisedBy: "manager-1", SkipReason: "list is running late",
	}, "cssd-1", at); err == nil {
		t.Fatal("sterilisation was skipped; a pack released without it is an " +
			"unsterile pack with a sterile label")
	}
}

// SRS-CSSD-004. A tray short of a critical item does not go out.
func TestATrayShortOfACriticalItemIsRefused(t *testing.T) {
	run := received(t)
	for _, stage := range []domain.Stage{
		domain.StageDecontaminated, domain.StageWashed, domain.StageInspected,
	} {
		if _, err := run.Advance("s-"+string(stage),
			domain.AdvanceInput{Stage: stage}, "cssd-1", at); err != nil {
			t.Fatalf("Advance %s: %v", stage, err)
		}
	}

	// Missing a blade handle, which is critical.
	_, missing, err := run.Assemble("s-asm", domain.AssembleInput{
		Packed: map[string]int{"BLADE-HANDLE": 1, "MOSQUITO": 10, "RETRACTOR": 2},
	}, set(t, nil), "cssd-1", at)
	if err == nil {
		t.Fatal("a tray went out without a blade handle; that is a cancelled " +
			"case discovered when the surgeon opens it")
	}
	if len(missing) != 1 || missing[0] != "BLADE-HANDLE" {
		t.Errorf("missing = %v", missing)
	}
	if run.Stage != domain.StageInspected {
		t.Errorf("stage = %q; a refused assembly does not advance", run.Stage)
	}

	// Missing a retractor, which is not.
	_, missing, err = run.Assemble("s-asm", domain.AssembleInput{
		Packed:   map[string]int{"BLADE-HANDLE": 2, "MOSQUITO": 10, "RETRACTOR": 1},
		Replaced: []string{"MOSQUITO"},
	}, set(t, nil), "cssd-1", at)
	if err != nil {
		t.Fatalf("Assemble: %v", err)
	}
	if len(missing) != 1 || missing[0] != "RETRACTOR" {
		t.Errorf("missing = %v, want [RETRACTOR]", missing)
	}
	if len(run.Missing) != 1 || len(run.Replaced) != 1 {
		t.Errorf("the pack's composition was lost: missing=%v replaced=%v",
			run.Missing, run.Replaced)
	}
	if run.PackedCount["MOSQUITO"] != 10 {
		t.Errorf("packed count = %v; a case trace reads this",
			run.PackedCount)
	}
}

// packed walks a run to the packaged stage.
func packed(t *testing.T) domain.Run {
	t.Helper()
	run := received(t)
	for _, stage := range []domain.Stage{
		domain.StageDecontaminated, domain.StageWashed, domain.StageInspected,
	} {
		if _, err := run.Advance("s-"+string(stage),
			domain.AdvanceInput{Stage: stage}, "cssd-1", at); err != nil {
			t.Fatalf("Advance %s: %v", stage, err)
		}
	}
	if _, _, err := run.Assemble("s-asm", domain.AssembleInput{
		Packed: fullCount(),
	}, set(t, nil), "cssd-1", at); err != nil {
		t.Fatalf("Assemble: %v", err)
	}
	if _, err := run.Package("s-pkg", domain.PackageInput{
		Method: "double wrap", IndicatorType: "class 5",
	}, "cssd-1", at); err != nil {
		t.Fatalf("Package: %v", err)
	}
	return run
}

// SRS-CSSD-005. A pack needs a method and an indicator.
func TestAPackRecordsItsMethodAndIndicator(t *testing.T) {
	run := received(t)
	for _, stage := range []domain.Stage{
		domain.StageDecontaminated, domain.StageWashed, domain.StageInspected,
	} {
		if _, err := run.Advance("s-"+string(stage),
			domain.AdvanceInput{Stage: stage}, "cssd-1", at); err != nil {
			t.Fatalf("Advance %s: %v", stage, err)
		}
	}
	if _, _, err := run.Assemble("s-asm", domain.AssembleInput{
		Packed: fullCount(),
	}, set(t, nil), "cssd-1", at); err != nil {
		t.Fatalf("Assemble: %v", err)
	}

	if _, err := run.Package("s-pkg", domain.PackageInput{
		IndicatorType: "class 5",
	}, "cssd-1", at); err == nil {
		t.Error("a pack with no packaging method was accepted")
	}
	if _, err := run.Package("s-pkg", domain.PackageInput{
		Method: "double wrap",
	}, "cssd-1", at); err == nil {
		t.Error("a pack with no indicator was accepted; the scrub nurse would " +
			"have nothing to read as it is opened")
	}
}

func cycle(t *testing.T) domain.Cycle {
	t.Helper()
	out, err := domain.StartCycle("cycle-1", "tenant-1", domain.NewCycleInput{
		Machine: "autoclave-2", LoadNumber: "L-0091", Program: "134C 3.5min",
		Parameters: map[string]float64{"temperature_c": 134},
		StartedAt:  at,
	}, "cssd-1", at)
	if err != nil {
		t.Fatalf("StartCycle: %v", err)
	}
	return out
}

// SRS-CSSD-006. A cycle names the machine and the load, because a recall is
// announced by them.
func TestACycleNamesItsMachineAndLoad(t *testing.T) {
	for _, c := range []struct {
		name string
		in   domain.NewCycleInput
	}{
		{"no machine", domain.NewCycleInput{LoadNumber: "L-1"}},
		{"no load number", domain.NewCycleInput{Machine: "autoclave-2"}},
	} {
		if _, err := domain.StartCycle("cycle-x", "tenant-1", c.in,
			"cssd-1", at); err == nil {
			t.Errorf("%s: accepted", c.name)
		}
	}

	run := cycle(t)
	if run.Result != domain.CycleRunning {
		t.Errorf("result = %q; a load in the machine has no verdict yet",
			run.Result)
	}
	if run.Source != domain.CycleManual {
		t.Errorf("source = %q, want manual by default", run.Source)
	}

	if err := run.Finish(domain.CyclePassed,
		map[string]float64{"hold_seconds": 210}, at.Add(-time.Hour)); err == nil {
		t.Error("a cycle ended before it started")
	}
	if err := run.Finish(domain.CyclePassed,
		map[string]float64{"hold_seconds": 210}, at.Add(time.Hour)); err != nil {
		t.Fatalf("Finish: %v", err)
	}
	if run.Parameters["hold_seconds"] != 210 ||
		run.Parameters["temperature_c"] != 134 {
		t.Errorf("parameters = %v; the machine's record was lost", run.Parameters)
	}
	if err := run.Finish(domain.CycleFailed, nil, at.Add(2*time.Hour)); err == nil {
		t.Error("a finished cycle was finished again")
	}
}

// SRS-CSSD-007. Every reason a load may not be distributed, at once.
func TestReleaseReportsEveryRefusal(t *testing.T) {
	// A running cycle with no indicators, under a policy that wants both.
	running := cycle(t)
	decision := running.EvaluateRelease(true)
	if decision.Allowed() {
		t.Fatal("a running cycle with no indicators was releasable")
	}
	want := map[domain.ReleaseRefusal]bool{
		domain.ReleaseStillRunning:      true,
		domain.ReleaseNoChemical:        true,
		domain.ReleaseBiologicalPending: true,
	}
	got := map[domain.ReleaseRefusal]bool{}
	for _, refusal := range decision.Refusals {
		got[refusal] = true
	}
	for refusal := range want {
		if !got[refusal] {
			t.Errorf("refusal %q was not reported", refusal)
		}
	}
	if len(decision.Explanations) != len(decision.Refusals) {
		t.Error("the refusals and their explanations disagree in length")
	}

	// A passed cycle whose chemical indicator failed.
	failed := cycle(t)
	if err := failed.Finish(domain.CyclePassed, nil, at.Add(time.Hour)); err != nil {
		t.Fatalf("Finish: %v", err)
	}
	if _, err := failed.RecordIndicator("ind-1", domain.IndicatorChemical,
		"LOT-77", false, "no colour change", "cssd-1", at); err != nil {
		t.Fatalf("RecordIndicator: %v", err)
	}
	if failed.EvaluateRelease(false).Allowed() {
		t.Error("a load with a failed indicator was releasable")
	}

	// A passed cycle with a passed chemical indicator, no biological.
	ok := cycle(t)
	if err := ok.Finish(domain.CyclePassed, nil, at.Add(time.Hour)); err != nil {
		t.Fatalf("Finish: %v", err)
	}
	if _, err := ok.RecordIndicator("ind-2", domain.IndicatorChemical,
		"LOT-77", true, "", "cssd-1", at); err != nil {
		t.Fatalf("RecordIndicator: %v", err)
	}
	if !ok.EvaluateRelease(false).Allowed() {
		t.Errorf("a passed load was refused: %v",
			ok.EvaluateRelease(false).Explanations)
	}
	// The same load, under a policy that holds for the biological indicator.
	if ok.EvaluateRelease(true).Allowed() {
		t.Error("a load with no biological indicator was released under a " +
			"policy that requires one")
	}

	if err := ok.Release(ok.EvaluateRelease(false), "routine", "cssd-2",
		at.Add(2*time.Hour)); err != nil {
		t.Fatalf("Release: %v", err)
	}
	if !ok.Released || ok.ReleasedBy != "cssd-2" {
		t.Errorf("release = %+v", ok)
	}
	if ok.EvaluateRelease(false).Allowed() {
		t.Error("a released load was releasable again")
	}
}

// SRS-CSSD-007. A load cannot be released by skipping the evaluation.
func TestALoadCannotBeReleasedBySkippingTheCheck(t *testing.T) {
	failed := cycle(t)
	if err := failed.Finish(domain.CycleFailed, nil, at.Add(time.Hour)); err != nil {
		t.Fatalf("Finish: %v", err)
	}
	decision := failed.EvaluateRelease(false)
	if err := failed.Release(decision, "", "cssd-2", at); err == nil {
		t.Fatal("a failed load was released")
	}
	if failed.Released {
		t.Error("the load is marked released after a refusal")
	}
}

// SRS-CSSD-008. A pack with no expiry policy never expires, which is the one
// direction that lets an out-of-date pack reach a patient.
func TestAPackNeedsAnExpiryPolicy(t *testing.T) {
	run := packed(t)
	load := cycle(t)

	if _, err := run.Sterilise("s-ster", load, 0, "cssd-1", at); err == nil {
		t.Fatal("a pack with no shelf life was sterilised")
	}
	if _, err := run.Sterilise("s-ster", domain.Cycle{}, shelfLife,
		"cssd-1", at); err == nil {
		t.Error("a pack was sterilised against no load")
	}

	if _, err := run.Sterilise("s-ster", load, shelfLife, "cssd-1", at); err != nil {
		t.Fatalf("Sterilise: %v", err)
	}
	if run.ExpiresAt.IsZero() || !run.ExpiresAt.After(run.SterilisedAt) {
		t.Errorf("expiry = %v after sterilising at %v",
			run.ExpiresAt, run.SterilisedAt)
	}
	if run.CycleID != load.ID {
		t.Error("the pack does not name its load; the case trace has no chain")
	}
}

// SRS-CSSD-007, SRS-CSSD-008. A pack cannot be released before its load is.
func TestAPackIsNotReleasedBeforeItsLoad(t *testing.T) {
	run := packed(t)
	load := cycle(t)
	if _, err := run.Sterilise("s-ster", load, shelfLife, "cssd-1", at); err != nil {
		t.Fatalf("Sterilise: %v", err)
	}

	if _, err := run.ReleaseRun("s-rel", load, "cssd-1", at); err == nil {
		t.Fatal("a pack was released from an unreleased load")
	}

	if err := load.Finish(domain.CyclePassed, nil, at.Add(time.Hour)); err != nil {
		t.Fatalf("Finish: %v", err)
	}
	if _, err := load.RecordIndicator("ind-1", domain.IndicatorChemical,
		"LOT-77", true, "", "cssd-1", at); err != nil {
		t.Fatalf("RecordIndicator: %v", err)
	}
	if err := load.Release(load.EvaluateRelease(false), "", "cssd-2",
		at.Add(2*time.Hour)); err != nil {
		t.Fatalf("Release: %v", err)
	}

	// And not against a different load.
	other := cycle(t)
	other.ID = "cycle-9"
	if _, err := run.ReleaseRun("s-rel", other, "cssd-1", at); err == nil {
		t.Error("a pack was released against a different load")
	}

	if _, err := run.ReleaseRun("s-rel", load, "cssd-1",
		at.Add(3*time.Hour)); err != nil {
		t.Fatalf("ReleaseRun: %v", err)
	}
	if !run.Issuable(at.Add(3 * time.Hour)) {
		t.Error("a released, in-date pack is not issuable")
	}
	if run.Issuable(run.ExpiresAt.Add(time.Hour)) {
		t.Error("an expired pack is issuable")
	}
}

// releasedRun walks a run all the way to issuable.
func releasedRun(t *testing.T) (domain.Run, domain.Cycle) {
	t.Helper()
	run := packed(t)
	load := cycle(t)
	if _, err := run.Sterilise("s-ster", load, shelfLife, "cssd-1", at); err != nil {
		t.Fatalf("Sterilise: %v", err)
	}
	if err := load.Finish(domain.CyclePassed, nil, at.Add(time.Hour)); err != nil {
		t.Fatalf("Finish: %v", err)
	}
	if _, err := load.RecordIndicator("ind-1", domain.IndicatorChemical,
		"LOT-77", true, "", "cssd-1", at); err != nil {
		t.Fatalf("RecordIndicator: %v", err)
	}
	if err := load.Release(load.EvaluateRelease(false), "", "cssd-2",
		at.Add(2*time.Hour)); err != nil {
		t.Fatalf("Release: %v", err)
	}
	if _, err := run.ReleaseRun("s-rel", load, "cssd-1",
		at.Add(2*time.Hour)); err != nil {
		t.Fatalf("ReleaseRun: %v", err)
	}
	return run, load
}

// SRS-CSSD-008. The label is derived and names what it could not be built
// from.
func TestTheLabelNamesWhatIsMissing(t *testing.T) {
	unfinished := packed(t)
	label := domain.BuildLabel(unfinished, domain.Cycle{})
	if len(label.Incomplete) != 4 {
		t.Errorf("incomplete = %v; a pack with no cycle, date, expiry or "+
			"release would otherwise look like any other", label.Incomplete)
	}

	run, load := releasedRun(t)
	label = domain.BuildLabel(run, load)
	if len(label.Incomplete) != 0 {
		t.Errorf("a complete pack reported %v", label.Incomplete)
	}
	if label.LoadNumber != "L-0091" || label.SetVersion != 1 {
		t.Errorf("label = %+v", label)
	}
}

// SRS-CSSD-008, SRS-CSSD-009. An unreleased or expired pack is not issued.
func TestAnUnreleasedOrExpiredPackIsNotIssued(t *testing.T) {
	unreleased := packed(t)
	if _, err := domain.IssuePack("iss-1", "tenant-1", domain.NewIssueInput{
		RunID: unreleased.ID, Destination: "theatre 3",
	}, unreleased, "cssd-1", at); err == nil {
		t.Fatal("an unreleased pack was issued")
	}

	run, _ := releasedRun(t)
	if _, err := domain.IssuePack("iss-1", "tenant-1", domain.NewIssueInput{
		RunID: run.ID, Destination: "theatre 3",
	}, run, "cssd-1", run.ExpiresAt.Add(time.Hour)); err == nil {
		t.Fatal("an expired pack was issued")
	}
	if _, err := domain.IssuePack("iss-1", "tenant-1", domain.NewIssueInput{
		RunID: run.ID,
	}, run, "cssd-1", at.Add(3*time.Hour)); err == nil {
		t.Error("a pack was issued to nowhere; a recall could not fetch it back")
	}

	issue, err := domain.IssuePack("iss-1", "tenant-1", domain.NewIssueInput{
		RunID: run.ID, Destination: "theatre 3", IssuedTo: "porter-1",
	}, run, "cssd-1", at.Add(3*time.Hour))
	if err != nil {
		t.Fatalf("IssuePack: %v", err)
	}
	if issue.CycleID != run.CycleID {
		t.Error("the issue does not carry the cycle; the case trace breaks here")
	}

	// Used needs the case, because that is the link the trace runs along.
	if err := issue.MarkUsed("", "nurse-1", at.Add(4*time.Hour)); err == nil {
		t.Error("a pack was marked used for no case")
	}
	if err := issue.MarkUsed("case-9", "nurse-1", at.Add(4*time.Hour)); err != nil {
		t.Fatalf("MarkUsed: %v", err)
	}
	if err := issue.MarkUsed("case-10", "nurse-1", at); err == nil {
		t.Error("a used pack was used again")
	}
}

// SRS-CSSD-009. A set returning short is reported, and the count is kept.
func TestAReturnedSetIsCountedBack(t *testing.T) {
	run, _ := releasedRun(t)
	issue, err := domain.IssuePack("iss-1", "tenant-1", domain.NewIssueInput{
		RunID: run.ID, Destination: "theatre 3",
	}, run, "cssd-1", at.Add(3*time.Hour))
	if err != nil {
		t.Fatalf("IssuePack: %v", err)
	}

	short, err := issue.Return(
		map[string]int{"BLADE-HANDLE": 2, "MOSQUITO": 9, "RETRACTOR": 2},
		"one mosquito not accounted for", "cssd-1", set(t, nil),
		at.Add(5*time.Hour))
	if err != nil {
		t.Fatalf("Return: %v", err)
	}
	if len(short) != 1 || short[0] != "MOSQUITO" {
		t.Errorf("shortfall = %v, want [MOSQUITO]; the moment it is counted is "+
			"the last moment anybody can say where it was", short)
	}
	if issue.State != domain.IssueReturned {
		t.Errorf("state = %q, want returned", issue.State)
	}
	if issue.ReturnCount["MOSQUITO"] != 9 {
		t.Error("the return count was lost")
	}
}

// SRS-CSSD-010. The case trace runs from the patient back to the cycle, and
// names what it could not follow.
func TestTheCaseTraceReachesTheCycle(t *testing.T) {
	run, load := releasedRun(t)
	issue, err := domain.IssuePack("iss-1", "tenant-1", domain.NewIssueInput{
		RunID: run.ID, Destination: "theatre 3",
	}, run, "cssd-1", at.Add(3*time.Hour))
	if err != nil {
		t.Fatalf("IssuePack: %v", err)
	}
	if err := issue.MarkUsed("case-9", "nurse-1", at.Add(4*time.Hour)); err != nil {
		t.Fatalf("MarkUsed: %v", err)
	}

	trace := domain.BuildCaseTrace("case-9", []domain.Issue{issue},
		map[string]domain.Run{run.ID: run},
		map[string]domain.Cycle{load.ID: load})

	if len(trace.Sets) != 1 {
		t.Fatalf("sets = %d, want 1", len(trace.Sets))
	}
	if trace.Sets[0].LoadNumber != "L-0091" || trace.Sets[0].Machine != "autoclave-2" {
		t.Errorf("traced set = %+v; an investigation asks for the machine and "+
			"the load", trace.Sets[0])
	}
	if len(trace.Incomplete) != 0 {
		t.Errorf("a complete chain reported %v", trace.Incomplete)
	}

	// A pack whose cycle record is gone is named rather than silently dropped:
	// "three sets" and "three sets that we know of" are different answers.
	broken := domain.BuildCaseTrace("case-9", []domain.Issue{issue},
		map[string]domain.Run{run.ID: run}, nil)
	if len(broken.Incomplete) == 0 {
		t.Error("a missing cycle record was not named")
	}
	if len(broken.Sets) != 1 {
		t.Error("a set with no cycle record disappeared from the trace")
	}
}

// SRS-CSSD-011. A recall reaches every pack in the load and every case one was
// opened for.
func TestARecallReachesTheCasesAndTheShelves(t *testing.T) {
	load := cycle(t)

	// Three packs from one load: one still in the department, one out on a
	// ward, one already used in a case.
	inDepartment := domain.Run{ID: "run-a", SetCode: "LAP-MAJOR", CycleID: load.ID}
	issued := domain.Run{ID: "run-b", SetCode: "ORTHO-1", CycleID: load.ID}
	used := domain.Run{ID: "run-c", SetCode: "GEN-2", CycleID: load.ID}

	issues := map[string][]domain.Issue{
		issued.ID: {{
			ID: "iss-b", RunID: issued.ID, State: domain.IssueOut,
			Destination: "ward 7",
		}},
		used.ID: {{
			ID: "iss-c", RunID: used.ID, State: domain.IssueUsed,
			Destination: "theatre 3", UsedCaseID: "case-42",
		}},
	}

	scope := domain.BuildRecall(load, "biological indicator failed",
		[]domain.Run{inDepartment, issued, used}, issues)

	if len(scope.Packs) != 3 {
		t.Fatalf("packs = %d, want 3", len(scope.Packs))
	}
	states := map[string]string{}
	for _, pack := range scope.Packs {
		states[pack.RunID] = pack.State
	}
	if states["run-a"] != domain.RecallInDepartment {
		t.Errorf("run-a state = %q", states["run-a"])
	}
	if states["run-b"] != domain.RecallIssued {
		t.Errorf("run-b state = %q", states["run-b"])
	}
	if states["run-c"] != domain.RecallUsed {
		t.Errorf("run-c state = %q", states["run-c"])
	}

	if len(scope.Cases) != 1 || scope.Cases[0] != "case-42" {
		t.Errorf("cases = %v; a recall that only covered the packs still on a "+
			"shelf would miss exactly the patients it exists to find",
			scope.Cases)
	}
	if len(scope.Locations) != 1 || scope.Locations[0] != "ward 7" {
		t.Errorf("locations = %v; somebody has to go and fetch them",
			scope.Locations)
	}
	if scope.LoadNumber != "L-0091" {
		t.Errorf("load = %q; a recall is announced by it", scope.LoadNumber)
	}
}

// SRS-CSSD-011. A used pack stays on the recall list. The pack cannot come
// back, but the patient is the reason the list exists.
func TestARecalledUsedPackStaysOnTheList(t *testing.T) {
	issue := domain.Issue{
		ID: "iss-1", RunID: "run-1", State: domain.IssueUsed,
		UsedCaseID: "case-42",
	}
	if err := issue.Recall("cssd-manager", at); err != nil {
		t.Fatalf("Recall: %v", err)
	}
	if issue.State != domain.IssueRecalled {
		t.Errorf("state = %q, want recalled", issue.State)
	}
	if issue.UsedCaseID != "case-42" {
		t.Error("the case was cleared by the recall; that patient would drop " +
			"off the list")
	}
	if err := issue.Recall("cssd-manager", at); err == nil {
		t.Error("a pack was recalled twice")
	}
}

// SRS-CSSD-012. An instrument out of service says why, and a retired one does
// not come back.
func TestAnInstrumentOutOfServiceSaysWhy(t *testing.T) {
	instrument, err := domain.NewInstrument("inst-1", "tenant-1",
		domain.NewInstrumentInput{
			Code: "SCOPE-5", Display: "10mm laparoscope",
			SerialNumber: "SN-44219", Location: "store",
		}, "cssd-1", at)
	if err != nil {
		t.Fatalf("NewInstrument: %v", err)
	}
	if !instrument.Status.Packable() {
		t.Error("a new instrument is not packable")
	}

	if err := instrument.Move(domain.InstrumentInRepair, "", at); err == nil {
		t.Error("an instrument went for repair with no reason; a replacement " +
			"analysis reads this")
	}
	if err := instrument.Move(domain.InstrumentMissing,
		"not in the count after case-42", at); err != nil {
		t.Fatalf("Move: %v", err)
	}
	if instrument.Status.Packable() {
		t.Error("a missing instrument is packable")
	}

	if err := instrument.Move(domain.InstrumentRetired, "damaged beyond repair",
		at.Add(24*time.Hour)); err != nil {
		t.Fatalf("Move: %v", err)
	}
	if instrument.RetiredOn.IsZero() {
		t.Error("a retired instrument has no retirement date")
	}
	if err := instrument.Move(domain.InstrumentInService, "", at); err == nil {
		t.Error("a retired instrument came back into service; that is how a " +
			"broken one returns to a tray")
	}

	// An instrument counted in bulk has no serial, which is not a gap.
	bulk, err := domain.NewInstrument("inst-2", "tenant-1",
		domain.NewInstrumentInput{Code: "MOSQUITO"}, "cssd-1", at)
	if err != nil {
		t.Fatalf("NewInstrument: %v", err)
	}
	if bulk.SerialNumber != "" {
		t.Error("a bulk instrument acquired a serial number")
	}
	if _, err := domain.NewInstrument("inst-3", "tenant-1",
		domain.NewInstrumentInput{}, "cssd-1", at); err == nil {
		t.Error("an instrument with no catalogue code was accepted; a packing " +
			"list could not name it")
	}
}

// The refusals read as instructions rather than as codes.
func TestRefusalsExplainThemselves(t *testing.T) {
	for _, refusal := range []domain.ReleaseRefusal{
		domain.ReleaseStillRunning, domain.ReleaseCycleFailed,
		domain.ReleaseNoChemical, domain.ReleaseIndicatorFailed,
		domain.ReleaseBiologicalPending, domain.ReleaseAlreadyReleased,
	} {
		explanation := refusal.Explain()
		if explanation == string(refusal) {
			t.Errorf("%q has no explanation", refusal)
		}
		if !strings.HasSuffix(explanation, ".") {
			t.Errorf("%q reads as a code rather than a sentence: %q",
				refusal, explanation)
		}
	}
}
