package postgres_test

import (
	"context"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	sterilepostgres "github.com/ppusapati/health/code/internal/sterile/adapters/postgres"
	"github.com/ppusapati/health/code/internal/sterile/domain"
	"github.com/ppusapati/health/code/internal/sterile/ports"
)

// The sterile services persistence adapter.
//
// Round-trip tests, because the defect they catch is invisible above the
// adapter: a dropped field reads back as a zero that looks like a decision
// nobody made. A lost set version makes a pack auditable against the wrong
// packing list; a lost skip flag makes an exception disappear from the
// register; a lost cycle id breaks the chain an infection investigation runs
// along.
//
// Six of these bypass the adapter and write raw SQL, because the rule under
// test belongs to the database rather than to Go.

var at = time.Date(2026, 9, 18, 8, 0, 0, 0, time.UTC)

const shelfLife = 180 * 24 * time.Hour

type fixture struct {
	pool         *pgxpool.Pool
	master       sterilepostgres.MasterRepo
	cycles       sterilepostgres.CycleRepo
	runs         sterilepostgres.RunRepo
	distribution sterilepostgres.DistributionRepo

	scope    authctx.TenantScope
	tenantID string
}

func newFixture(t *testing.T) fixture {
	t.Helper()

	pool := pgtest.New(t)
	repo := sterilepostgres.New(pgtx.NewManager(pool))
	tenantID := uuid.NewString()

	return fixture{
		pool:         pool,
		master:       sterilepostgres.MasterRepo{Repository: repo},
		cycles:       sterilepostgres.CycleRepo{Repository: repo},
		runs:         sterilepostgres.RunRepo{Repository: repo},
		distribution: sterilepostgres.DistributionRepo{Repository: repo},
		scope: authctx.NewSession(authctx.Session{
			SubjectID: "cssd-1", TenantID: tenantID,
		}).TenantScope(),
		tenantID: tenantID,
	}
}

func (f fixture) set(t *testing.T, code string) domain.TraySet {
	t.Helper()

	set, err := domain.NewTraySet(uuid.NewString(), f.tenantID,
		domain.NewTraySetInput{
			Code: code, Display: "Laparotomy major", Kind: "tray",
			Items: []domain.PackingItem{
				{Code: "BLADE-HANDLE", Display: "Blade handle", Quantity: 2,
					Critical: true},
				{Code: "MOSQUITO", Display: "Mosquito forceps", Quantity: 10},
			},
			ShelfLife: shelfLife,
		}, "cssd-1", at)
	if err != nil {
		t.Fatalf("NewTraySet: %v", err)
	}
	if err := f.master.InsertSet(context.Background(), f.scope, set); err != nil {
		t.Fatalf("InsertSet: %v", err)
	}
	return set
}

func fullCount() map[string]int {
	return map[string]int{"BLADE-HANDLE": 2, "MOSQUITO": 10}
}

func (f fixture) run(t *testing.T, set domain.TraySet) domain.Run {
	t.Helper()

	run, _, err := domain.Receive(uuid.NewString(), f.tenantID,
		domain.ReceiveInput{
			SetID: set.ID, SourceUnit: "theatre 3", Counted: fullCount(),
		}, set, "cssd-1", at)
	if err != nil {
		t.Fatalf("Receive: %v", err)
	}
	run.Stages[0].ID = uuid.NewString()
	if err := f.runs.InsertRun(context.Background(), f.scope, run); err != nil {
		t.Fatalf("InsertRun: %v", err)
	}
	return run
}

func (f fixture) cycle(t *testing.T, load string) domain.Cycle {
	t.Helper()

	cycle, err := domain.StartCycle(uuid.NewString(), f.tenantID,
		domain.NewCycleInput{
			Machine: "autoclave-2", LoadNumber: load, Program: "134C",
			Parameters: map[string]float64{"temperature_c": 134},
			StartedAt:  at,
		}, "cssd-1", at)
	if err != nil {
		t.Fatalf("StartCycle: %v", err)
	}
	if err := f.cycles.InsertCycle(context.Background(), f.scope, cycle); err != nil {
		t.Fatalf("InsertCycle: %v", err)
	}
	return cycle
}

// SRS-CSSD-001. The packing list survives the round trip, and a revision does
// not change what an earlier pack was checked against.
func TestASetAndItsVersionsSurviveTheRoundTrip(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	first := f.set(t, "LAP-MAJOR")

	read, err := f.master.Set(ctx, f.scope, first.ID)
	if err != nil {
		t.Fatalf("Set: %v", err)
	}
	if len(read.Items) != 2 {
		t.Fatalf("items = %d, want 2", len(read.Items))
	}
	if read.Expected()["MOSQUITO"] != 10 {
		t.Errorf("expected = %v; the count a pack is checked against was lost",
			read.Expected())
	}
	if len(read.CriticalItems()) != 1 {
		t.Errorf("critical = %v; a tray would go out without its blade handle",
			read.CriticalItems())
	}
	if read.ShelfLife != shelfLife {
		t.Errorf("shelf life = %v; a pack with none never expires", read.ShelfLife)
	}

	next, err := read.Revise(uuid.NewString(), domain.NewTraySetInput{
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
	if err := f.master.Supersede(ctx, f.scope, next, first.ID,
		at.Add(24*time.Hour)); err != nil {
		t.Fatalf("Supersede: %v", err)
	}

	versions, err := f.master.SetVersions(ctx, f.scope, "LAP-MAJOR")
	if err != nil {
		t.Fatalf("SetVersions: %v", err)
	}
	if len(versions) != 2 {
		t.Fatalf("versions = %d, want 2", len(versions))
	}
	if versions[0].Expected()["MOSQUITO"] != 10 {
		t.Error("the earlier packing list changed under a pack that was " +
			"already checked against it")
	}

	current, ok, err := f.master.CurrentSet(ctx, f.scope, "LAP-MAJOR")
	if err != nil || !ok {
		t.Fatalf("CurrentSet: %v ok=%v", err, ok)
	}
	if current.Version != 2 {
		t.Errorf("current = v%d, want v2", current.Version)
	}

	// A second supersede of the same version loses.
	if err := f.master.Supersede(ctx, f.scope, next, first.ID,
		at.Add(25*time.Hour)); err == nil {
		t.Error("a version was superseded twice")
	}
}

// SRS-CSSD-001. The database holds "one current version per code".
func TestTheDatabaseRefusesTwoLivePackingLists(t *testing.T) {
	f := newFixture(t)
	f.set(t, "LAP-MAJOR")

	_, err := f.pool.Exec(context.Background(), `
		INSERT INTO sterile.tray_set (
		    set_id, tenant_id, code, set_version, items, created_at, created_by)
		VALUES ($1, $2, 'LAP-MAJOR', 2, '[{"Code":"X","Quantity":1}]',
		        now(), 'sneaky')`,
		uuid.New(), f.tenantID)
	if err == nil {
		t.Fatal("two live packing lists for one set; there would be two " +
			"answers to what should be in the tray")
	}
}

// SRS-CSSD-002. The chain of custody and the set version survive.
func TestARunKeepsItsCustodyAndItsVersion(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	set := f.set(t, "LAP-MAJOR")
	run := f.run(t, set)

	read, err := f.runs.Run(ctx, f.scope, run.ID)
	if err != nil {
		t.Fatalf("Run: %v", err)
	}
	if read.SourceUnit != "theatre 3" || read.StartedBy != "cssd-1" {
		t.Errorf("custody = %+v", read)
	}
	if read.SetVersion != 1 {
		t.Errorf("set version = %d; the pack must name the list it was "+
			"checked against", read.SetVersion)
	}
	if read.ReceivedCount["MOSQUITO"] != 10 {
		t.Errorf("received count = %v", read.ReceivedCount)
	}
	if len(read.Stages) != 1 || read.Stages[0].Stage != domain.StageReceived {
		t.Errorf("stages = %+v; the receipt is the first link in the chain",
			read.Stages)
	}
}

// SRS-CSSD-003. A skipped stage keeps its authoriser, and the exceptions
// register finds it.
func TestASkippedStageReachesTheExceptionsRegister(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	set := f.set(t, "LAP-MAJOR")
	run := f.run(t, set)

	record, err := run.Advance(uuid.NewString(), domain.AdvanceInput{
		Stage: domain.StageDecontaminated, Skipped: true,
		SkipAuthorisedBy: "manager-1",
		SkipReason:       "pre-cleaned at point of use, washer down",
	}, "cssd-1", at.Add(time.Hour))
	if err != nil {
		t.Fatalf("Advance: %v", err)
	}
	if err := f.runs.InsertStage(ctx, f.scope, record); err != nil {
		t.Fatalf("InsertStage: %v", err)
	}
	if err := f.runs.UpdateRun(ctx, f.scope, run, run.Version); err != nil {
		t.Fatalf("UpdateRun: %v", err)
	}

	read, err := f.runs.Run(ctx, f.scope, run.ID)
	if err != nil {
		t.Fatalf("Run: %v", err)
	}
	if skipped := read.SkippedStages(); len(skipped) != 1 {
		t.Errorf("skipped = %v; an exception disappeared from the record",
			skipped)
	}

	register, err := f.runs.SkippedStages(ctx, f.scope, at,
		at.Add(24*time.Hour), 50)
	if err != nil {
		t.Fatalf("SkippedStages: %v", err)
	}
	if len(register) != 1 {
		t.Fatalf("register = %d, want 1", len(register))
	}
	if register[0].SkipAuthorisedBy != "manager-1" {
		t.Errorf("authoriser = %q; nobody would be answerable for the skip",
			register[0].SkipAuthorisedBy)
	}
}

// SRS-CSSD-003. The database refuses an unauthorised skip and refuses to skip
// the two stages that are never skippable.
func TestTheDatabaseHoldsTheSkipRules(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	set := f.set(t, "LAP-MAJOR")
	run := f.run(t, set)

	for _, c := range []struct {
		name         string
		stage        string
		authorisedBy string
		reason       string
	}{
		{"no authoriser", "washed", "", "washer down"},
		{"no reason", "washed", "manager-1", ""},
		{"sterilisation", "sterilised", "manager-1", "list running late"},
		{"release", "released", "manager-1", "in a hurry"},
	} {
		_, err := f.pool.Exec(ctx, `
			INSERT INTO sterile.stage_record (
			    stage_record_id, tenant_id, run_id, stage, skipped,
			    skip_authorised_by, skip_reason, performed_at, performed_by)
			VALUES ($1, $2, $3, $4, true, $5, $6, now(), 'someone')`,
			uuid.New(), f.tenantID, run.ID, c.stage, c.authorisedBy, c.reason)
		if err == nil {
			t.Errorf("%s: a skip was accepted", c.name)
		}
	}
}

// One record per stage per run: a second is the same step recorded twice, and
// an audit counting stages would be wrong.
func TestTheDatabaseRefusesAStageRecordedTwice(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	set := f.set(t, "LAP-MAJOR")
	run := f.run(t, set)

	_, err := f.pool.Exec(ctx, `
		INSERT INTO sterile.stage_record (
		    stage_record_id, tenant_id, run_id, stage, performed_at, performed_by)
		VALUES ($1, $2, $3, 'received', now(), 'someone')`,
		uuid.New(), f.tenantID, run.ID)
	if err == nil {
		t.Fatal("the receipt was recorded twice")
	}
}

// SRS-CSSD-006, SRS-CSSD-007. A cycle and its indicators survive, and the
// release is separate from the result.
func TestACycleCarriesItsIndicators(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	cycle := f.cycle(t, "L-0091")

	if err := cycle.Finish(domain.CyclePassed,
		map[string]float64{"hold_seconds": 210}, at.Add(time.Hour)); err != nil {
		t.Fatalf("Finish: %v", err)
	}
	if err := f.cycles.UpdateCycle(ctx, f.scope, cycle, cycle.Version); err != nil {
		t.Fatalf("UpdateCycle: %v", err)
	}

	indicator, err := cycle.RecordIndicator(uuid.NewString(),
		domain.IndicatorChemical, "LOT-77", true, "", "cssd-1", at)
	if err != nil {
		t.Fatalf("RecordIndicator: %v", err)
	}
	if err := f.cycles.InsertIndicator(ctx, f.scope, indicator); err != nil {
		t.Fatalf("InsertIndicator: %v", err)
	}

	read, err := f.cycles.Cycle(ctx, f.scope, cycle.ID)
	if err != nil {
		t.Fatalf("Cycle: %v", err)
	}
	if len(read.Indicators) != 1 {
		t.Fatalf("indicators = %d; a cycle fetched without them would look "+
			"releasable", len(read.Indicators))
	}
	if read.Parameters["hold_seconds"] != 210 ||
		read.Parameters["temperature_c"] != 134 {
		t.Errorf("parameters = %v; the machine's record was lost",
			read.Parameters)
	}
	if read.Released {
		t.Error("a passed cycle came back released; the biological indicator " +
			"may still be incubating")
	}

	// Awaiting release finds it.
	awaiting, err := f.cycles.AwaitingRelease(ctx, f.scope, 50)
	if err != nil {
		t.Fatalf("AwaitingRelease: %v", err)
	}
	if len(awaiting) != 1 {
		t.Fatalf("awaiting = %d, want 1", len(awaiting))
	}

	if err := read.Release(read.EvaluateRelease(false), "routine", "cssd-2",
		at.Add(2*time.Hour)); err != nil {
		t.Fatalf("Release: %v", err)
	}
	if err := f.cycles.UpdateCycle(ctx, f.scope, read, read.Version); err != nil {
		t.Fatalf("UpdateCycle: %v", err)
	}

	awaiting, err = f.cycles.AwaitingRelease(ctx, f.scope, 50)
	if err != nil {
		t.Fatalf("AwaitingRelease: %v", err)
	}
	if len(awaiting) != 0 {
		t.Errorf("a released load is still awaiting release")
	}

	// And the bad-batch investigation finds the load this lot cleared.
	cleared, err := f.cycles.ClearedByLot(ctx, f.scope, "LOT-77", 50)
	if err != nil {
		t.Fatalf("ClearedByLot: %v", err)
	}
	if len(cleared) != 1 {
		t.Errorf("cleared by LOT-77 = %d, want 1; a bad batch of indicators "+
			"invalidates every load they cleared", len(cleared))
	}
}

// SRS-CSSD-007. The database refuses to release a load that did not pass.
func TestTheDatabaseRefusesToReleaseAFailedLoad(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	cycle := f.cycle(t, "L-0092")

	for _, c := range []struct {
		name   string
		result string
	}{
		{"a running load", "running"},
		{"a failed load", "failed"},
		{"an aborted load", "aborted"},
	} {
		_, err := f.pool.Exec(ctx, `
			UPDATE sterile.cycle
			SET result = $3, released = true, released_by = 'someone',
			    released_at = now()
			WHERE tenant_id = $1 AND cycle_id = $2`,
			f.tenantID, cycle.ID, c.result)
		if err == nil {
			t.Errorf("%s was released", c.name)
		}
	}

	// And a release naming nobody.
	_, err := f.pool.Exec(ctx, `
		UPDATE sterile.cycle
		SET result = 'passed', released = true
		WHERE tenant_id = $1 AND cycle_id = $2`,
		f.tenantID, cycle.ID)
	if err == nil {
		t.Error("a load was released by nobody")
	}
}

// SRS-CSSD-006. One load number per machine: two would make a recall ambiguous.
func TestTheDatabaseRefusesADuplicateLoadNumber(t *testing.T) {
	f := newFixture(t)
	f.cycle(t, "L-0093")

	_, err := f.pool.Exec(context.Background(), `
		INSERT INTO sterile.cycle (
		    cycle_id, tenant_id, machine, load_number, source, result,
		    started_at, started_by)
		VALUES ($1, $2, 'autoclave-2', 'L-0093', 'manual', 'running',
		        now(), 'someone')`,
		uuid.New(), f.tenantID)
	if err == nil {
		t.Fatal("two loads share a number on one machine; a recall announced " +
			"by it would be ambiguous")
	}
}

// SRS-CSSD-008. The database refuses a sterilised pack with no expiry.
func TestTheDatabaseRefusesASterilisedPackWithNoExpiry(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	set := f.set(t, "LAP-MAJOR")
	run := f.run(t, set)
	cycle := f.cycle(t, "L-0094")

	_, err := f.pool.Exec(ctx, `
		UPDATE sterile.run
		SET sterilised_at = now(), cycle_id = $3
		WHERE tenant_id = $1 AND run_id = $2`,
		f.tenantID, run.ID, cycle.ID)
	if err == nil {
		t.Fatal("a sterilised pack with no expiry was accepted; it would " +
			"never expire")
	}

	// And a released pack that was never sterilised.
	_, err = f.pool.Exec(ctx, `
		UPDATE sterile.run SET stage = 'released'
		WHERE tenant_id = $1 AND run_id = $2`,
		f.tenantID, run.ID)
	if err == nil {
		t.Fatal("a pack was released without being sterilised")
	}
}

// releasedRun walks a run all the way to the shelf.
func (f fixture) releasedRun(t *testing.T, set domain.TraySet,
	load string) (domain.Run, domain.Cycle) {

	t.Helper()
	ctx := context.Background()
	run := f.run(t, set)

	for _, stage := range []domain.Stage{
		domain.StageDecontaminated, domain.StageWashed, domain.StageInspected,
	} {
		record, err := run.Advance(uuid.NewString(),
			domain.AdvanceInput{Stage: stage}, "cssd-1", at.Add(time.Hour))
		if err != nil {
			t.Fatalf("Advance %s: %v", stage, err)
		}
		if err := f.runs.InsertStage(ctx, f.scope, record); err != nil {
			t.Fatalf("InsertStage: %v", err)
		}
	}
	record, _, err := run.Assemble(uuid.NewString(), domain.AssembleInput{
		Packed: fullCount(),
	}, set, "cssd-1", at.Add(2*time.Hour))
	if err != nil {
		t.Fatalf("Assemble: %v", err)
	}
	if err := f.runs.InsertStage(ctx, f.scope, record); err != nil {
		t.Fatalf("InsertStage: %v", err)
	}
	record, err = run.Package(uuid.NewString(), domain.PackageInput{
		Method: "double wrap", IndicatorType: "class 5",
	}, "cssd-1", at.Add(3*time.Hour))
	if err != nil {
		t.Fatalf("Package: %v", err)
	}
	if err := f.runs.InsertStage(ctx, f.scope, record); err != nil {
		t.Fatalf("InsertStage: %v", err)
	}

	cycle := f.cycle(t, load)
	record, err = run.Sterilise(uuid.NewString(), cycle, set.ShelfLife,
		"cssd-1", at.Add(4*time.Hour))
	if err != nil {
		t.Fatalf("Sterilise: %v", err)
	}
	if err := f.runs.InsertStage(ctx, f.scope, record); err != nil {
		t.Fatalf("InsertStage: %v", err)
	}
	if err := f.runs.UpdateRun(ctx, f.scope, run, run.Version); err != nil {
		t.Fatalf("UpdateRun: %v", err)
	}
	run.Version++

	if err := cycle.Finish(domain.CyclePassed, nil, at.Add(5*time.Hour)); err != nil {
		t.Fatalf("Finish: %v", err)
	}
	indicator, err := cycle.RecordIndicator(uuid.NewString(),
		domain.IndicatorChemical, "LOT-77", true, "", "cssd-1",
		at.Add(5*time.Hour))
	if err != nil {
		t.Fatalf("RecordIndicator: %v", err)
	}
	if err := f.cycles.InsertIndicator(ctx, f.scope, indicator); err != nil {
		t.Fatalf("InsertIndicator: %v", err)
	}
	if err := cycle.Release(cycle.EvaluateRelease(false), "", "cssd-2",
		at.Add(6*time.Hour)); err != nil {
		t.Fatalf("Release: %v", err)
	}
	if err := f.cycles.UpdateCycle(ctx, f.scope, cycle, cycle.Version); err != nil {
		t.Fatalf("UpdateCycle: %v", err)
	}
	cycle.Version++

	record, err = run.ReleaseRun(uuid.NewString(), cycle, "cssd-1",
		at.Add(6*time.Hour))
	if err != nil {
		t.Fatalf("ReleaseRun: %v", err)
	}
	if err := f.runs.InsertStage(ctx, f.scope, record); err != nil {
		t.Fatalf("InsertStage: %v", err)
	}
	if err := f.runs.UpdateRun(ctx, f.scope, run, run.Version); err != nil {
		t.Fatalf("UpdateRun: %v", err)
	}
	run.Version++
	return run, cycle
}

// SRS-CSSD-008, SRS-CSSD-009. The shelf offers the pack that would otherwise
// be wasted first, and never an expired one.
func TestTheShelfOffersTheSoonestToExpireFirst(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	set := f.set(t, "LAP-MAJOR")

	first, _ := f.releasedRun(t, set, "L-0095")
	second, _ := f.releasedRun(t, set, "L-0096")

	shelf, err := f.runs.Shelf(ctx, f.scope, "", at.Add(7*time.Hour), 50)
	if err != nil {
		t.Fatalf("Shelf: %v", err)
	}
	if len(shelf) != 2 {
		t.Fatalf("shelf = %d, want 2", len(shelf))
	}
	for i := 1; i < len(shelf); i++ {
		if shelf[i].ExpiresAt.Before(shelf[i-1].ExpiresAt) {
			t.Fatal("the shelf is not soonest-to-expire first")
		}
	}
	_ = first
	_ = second

	// Past their life, nothing is on the shelf and both are in the sweep.
	later := at.Add(shelfLife + 24*time.Hour)
	shelf, err = f.runs.Shelf(ctx, f.scope, "", later, 50)
	if err != nil {
		t.Fatalf("Shelf: %v", err)
	}
	if len(shelf) != 0 {
		t.Errorf("shelf = %d after expiry; an out-of-date pack would be issued",
			len(shelf))
	}
	expired, err := f.runs.Expired(ctx, f.scope, later, 50)
	if err != nil {
		t.Fatalf("Expired: %v", err)
	}
	if len(expired) != 2 {
		t.Errorf("expired = %d, want 2", len(expired))
	}
}

// SRS-CSSD-009, SRS-CSSD-010. An issue carries the cycle, and the case trace
// runs back along it.
func TestTheCaseTraceReachesTheCycleThroughTheIssue(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	set := f.set(t, "LAP-MAJOR")
	run, cycle := f.releasedRun(t, set, "L-0097")
	caseID := uuid.NewString()

	issue, err := domain.IssuePack(uuid.NewString(), f.tenantID,
		domain.NewIssueInput{
			RunID: run.ID, Destination: "theatre 3", IssuedTo: "porter-1",
		}, run, "cssd-1", at.Add(7*time.Hour))
	if err != nil {
		t.Fatalf("IssuePack: %v", err)
	}
	if err := f.distribution.InsertIssue(ctx, f.scope, issue); err != nil {
		t.Fatalf("InsertIssue: %v", err)
	}
	if err := issue.MarkUsed(caseID, "nurse-1", at.Add(8*time.Hour)); err != nil {
		t.Fatalf("MarkUsed: %v", err)
	}
	if err := f.distribution.UpdateIssue(ctx, f.scope, issue); err != nil {
		t.Fatalf("UpdateIssue: %v", err)
	}

	issues, err := f.distribution.IssuesForCase(ctx, f.scope, caseID)
	if err != nil {
		t.Fatalf("IssuesForCase: %v", err)
	}
	if len(issues) != 1 {
		t.Fatalf("issues for the case = %d, want 1", len(issues))
	}
	if issues[0].CycleID != cycle.ID {
		t.Error("the issue does not carry the cycle; the case trace breaks here")
	}

	read, err := f.runs.Run(ctx, f.scope, run.ID)
	if err != nil {
		t.Fatalf("Run: %v", err)
	}
	trace := domain.BuildCaseTrace(caseID, issues,
		map[string]domain.Run{read.ID: read},
		map[string]domain.Cycle{cycle.ID: cycle})
	if len(trace.Sets) != 1 {
		t.Fatalf("traced sets = %d, want 1", len(trace.Sets))
	}
	if trace.Sets[0].LoadNumber != "L-0097" {
		t.Errorf("load = %q; an investigation asks for the machine and the "+
			"load", trace.Sets[0].LoadNumber)
	}
	if len(trace.Incomplete) != 0 {
		t.Errorf("a complete chain reported %v", trace.Incomplete)
	}
}

// SRS-CSSD-010. The database refuses a used pack that names no case.
func TestTheDatabaseRefusesAUsedPackWithNoCase(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	set := f.set(t, "LAP-MAJOR")
	run, _ := f.releasedRun(t, set, "L-0098")

	issue, err := domain.IssuePack(uuid.NewString(), f.tenantID,
		domain.NewIssueInput{RunID: run.ID, Destination: "theatre 3"},
		run, "cssd-1", at.Add(7*time.Hour))
	if err != nil {
		t.Fatalf("IssuePack: %v", err)
	}
	if err := f.distribution.InsertIssue(ctx, f.scope, issue); err != nil {
		t.Fatalf("InsertIssue: %v", err)
	}

	_, err = f.pool.Exec(ctx, `
		UPDATE sterile.issue SET state = 'used'
		WHERE tenant_id = $1 AND issue_id = $2`,
		f.tenantID, issue.ID)
	if err == nil {
		t.Fatal("a pack was opened for nobody; it would drop out of every " +
			"infection investigation")
	}
}

// SRS-CSSD-011. The recall reaches every pack in the load and every case one
// was opened for.
func TestARecallReachesEveryPackInTheLoad(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	set := f.set(t, "LAP-MAJOR")
	run, cycle := f.releasedRun(t, set, "L-0099")
	caseID := uuid.NewString()

	issue, err := domain.IssuePack(uuid.NewString(), f.tenantID,
		domain.NewIssueInput{RunID: run.ID, Destination: "theatre 3"},
		run, "cssd-1", at.Add(7*time.Hour))
	if err != nil {
		t.Fatalf("IssuePack: %v", err)
	}
	if err := f.distribution.InsertIssue(ctx, f.scope, issue); err != nil {
		t.Fatalf("InsertIssue: %v", err)
	}
	if err := issue.MarkUsed(caseID, "nurse-1", at.Add(8*time.Hour)); err != nil {
		t.Fatalf("MarkUsed: %v", err)
	}
	if err := f.distribution.UpdateIssue(ctx, f.scope, issue); err != nil {
		t.Fatalf("UpdateIssue: %v", err)
	}

	runs, err := f.runs.RunsForCycle(ctx, f.scope, cycle.ID)
	if err != nil {
		t.Fatalf("RunsForCycle: %v", err)
	}
	if len(runs) != 1 {
		t.Fatalf("packs in the load = %d, want 1", len(runs))
	}

	cycleIssues, err := f.distribution.IssuesForCycle(ctx, f.scope, cycle.ID)
	if err != nil {
		t.Fatalf("IssuesForCycle: %v", err)
	}
	byRun := map[string][]domain.Issue{}
	for _, i := range cycleIssues {
		byRun[i.RunID] = append(byRun[i.RunID], i)
	}

	scope := domain.BuildRecall(cycle, "biological indicator failed", runs, byRun)
	if len(scope.Cases) != 1 || scope.Cases[0] != caseID {
		t.Errorf("cases = %v; a recall covering only the packs on a shelf "+
			"would miss exactly the patients it is for", scope.Cases)
	}

	recall := ports.Recall{
		ID: uuid.NewString(), TenantID: f.tenantID, CycleID: cycle.ID,
		Reason:        "biological indicator failed",
		PacksAffected: len(scope.Packs), CasesAffected: len(scope.Cases),
		RaisedAt: at.Add(9 * time.Hour), RaisedBy: "cssd-manager",
	}
	if err := f.distribution.InsertRecall(ctx, f.scope, recall); err != nil {
		t.Fatalf("InsertRecall: %v", err)
	}

	open, err := f.distribution.OpenRecalls(ctx, f.scope, 50)
	if err != nil {
		t.Fatalf("OpenRecalls: %v", err)
	}
	if len(open) != 1 || open[0].CasesAffected != 1 {
		t.Fatalf("open recalls = %+v", open)
	}

	closed, err := f.distribution.CloseRecall(ctx, f.scope, recall.ID,
		"all packs accounted for", "cssd-manager", at.Add(30*time.Hour))
	if err != nil {
		t.Fatalf("CloseRecall: %v", err)
	}
	if !closed {
		t.Fatal("an open recall refused to close")
	}
	again, err := f.distribution.CloseRecall(ctx, f.scope, recall.ID,
		"again", "cssd-manager", at)
	if err != nil {
		t.Fatalf("CloseRecall: %v", err)
	}
	if again {
		t.Error("a recall was closed twice")
	}
}

// SRS-CSSD-012. An instrument's serial cannot be held by two objects, and the
// lifecycle worklist finds what is away.
func TestAnInstrumentSerialIdentifiesOneObject(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	instrument, err := domain.NewInstrument(uuid.NewString(), f.tenantID,
		domain.NewInstrumentInput{
			Code: "SCOPE-5", Display: "10mm laparoscope",
			SerialNumber: "SN-44219", Location: "store",
		}, "cssd-1", at)
	if err != nil {
		t.Fatalf("NewInstrument: %v", err)
	}
	if err := f.master.InsertInstrument(ctx, f.scope, instrument); err != nil {
		t.Fatalf("InsertInstrument: %v", err)
	}

	_, err = f.pool.Exec(ctx, `
		INSERT INTO sterile.instrument (
		    instrument_id, tenant_id, code, serial_number, status,
		    created_at, created_by)
		VALUES ($1, $2, 'SCOPE-6', 'SN-44219', 'in_service', now(), 'someone')`,
		uuid.New(), f.tenantID)
	if err == nil {
		t.Fatal("two instruments share a serial number; a repair history " +
			"would belong to neither")
	}

	// Bulk items have no serial and are excluded from the rule.
	for i := 0; i < 2; i++ {
		bulk, err := domain.NewInstrument(uuid.NewString(), f.tenantID,
			domain.NewInstrumentInput{Code: "MOSQUITO"}, "cssd-1", at)
		if err != nil {
			t.Fatalf("NewInstrument: %v", err)
		}
		if err := f.master.InsertInstrument(ctx, f.scope, bulk); err != nil {
			t.Fatalf("two bulk instruments with no serial were refused: %v", err)
		}
	}

	if err := instrument.Move(domain.InstrumentMissing,
		"not in the count after the case", at.Add(time.Hour)); err != nil {
		t.Fatalf("Move: %v", err)
	}
	if err := f.master.UpdateInstrument(ctx, f.scope, instrument,
		instrument.Version); err != nil {
		t.Fatalf("UpdateInstrument: %v", err)
	}

	out, err := f.master.OutOfService(ctx, f.scope, 50)
	if err != nil {
		t.Fatalf("OutOfService: %v", err)
	}
	if len(out) != 1 || out[0].Status != domain.InstrumentMissing {
		t.Errorf("out of service = %+v", out)
	}
	if out[0].Notes == "" {
		t.Error("the reason was lost; a loss analysis reads it")
	}

	// A stale version loses.
	if err := f.master.UpdateInstrument(ctx, f.scope, instrument,
		instrument.Version); err == nil {
		t.Error("a stale version overwrote the instrument")
	}
}

// Gate A2. Another tenant reaches none of it.
func TestAnotherTenantSeesNoSterileRecords(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	set := f.set(t, "LAP-MAJOR")
	run, cycle := f.releasedRun(t, set, "L-0100")

	other := authctx.NewSession(authctx.Session{
		SubjectID: "cssd-9", TenantID: uuid.NewString(),
	}).TenantScope()

	if _, err := f.runs.Run(ctx, other, run.ID); err == nil {
		t.Error("another tenant read a reprocessing run")
	}
	if _, err := f.cycles.Cycle(ctx, other, cycle.ID); err == nil {
		t.Error("another tenant read a sterilizer cycle")
	}
	if _, err := f.master.Set(ctx, other, set.ID); err == nil {
		t.Error("another tenant read a packing list")
	}
	shelf, err := f.runs.Shelf(ctx, other, "", at.Add(7*time.Hour), 50)
	if err != nil {
		t.Fatalf("Shelf: %v", err)
	}
	if len(shelf) != 0 {
		t.Errorf("another tenant saw %d packs on the shelf", len(shelf))
	}
	_, found, err := f.master.CurrentSet(ctx, other, "LAP-MAJOR")
	if err != nil {
		t.Fatalf("CurrentSet: %v", err)
	}
	if found {
		t.Error("another tenant read the current packing list")
	}
}

// SRS-CSSD-012. The lifecycle history is what "history supports replacement
// and loss analysis" means when it is written down as rows rather than as a
// status column the next move overwrites.
func TestTheInstrumentHistoryOutlivesTheStatusColumn(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	instrument, err := domain.NewInstrument(uuid.NewString(), f.tenantID,
		domain.NewInstrumentInput{
			Code: "SCOPE-5", Display: "10mm laparoscope",
			SerialNumber: "SN-88110", Location: "store",
		}, "cssd-1", at)
	if err != nil {
		t.Fatalf("NewInstrument: %v", err)
	}
	if err := f.master.InsertInstrument(ctx, f.scope, instrument); err != nil {
		t.Fatalf("InsertInstrument: %v", err)
	}

	// Three moves: away, back, away again. The status column ends where it
	// started but the item has been out of service twice, which is the whole
	// of the replacement question.
	moves := []struct {
		to   domain.InstrumentStatus
		note string
		when time.Time
	}{
		{domain.InstrumentInRepair, "lens fogged", at.Add(time.Hour)},
		{domain.InstrumentInService, "", at.Add(48 * time.Hour)},
		{domain.InstrumentInRepair, "light cable intermittent", at.Add(72 * time.Hour)},
	}
	for _, move := range moves {
		from := instrument.Status
		if err := instrument.Move(move.to, move.note, move.when); err != nil {
			t.Fatalf("Move(%s): %v", move.to, err)
		}
		if err := f.master.UpdateInstrument(ctx, f.scope, instrument,
			instrument.Version); err != nil {
			t.Fatalf("UpdateInstrument: %v", err)
		}
		instrument.Version++

		event, err := domain.NewInstrumentEvent(uuid.NewString(), instrument,
			from, move.note, "cssd-1", move.when)
		if err != nil {
			t.Fatalf("NewInstrumentEvent: %v", err)
		}
		if err := f.master.InsertInstrumentEvent(ctx, f.scope, event); err != nil {
			t.Fatalf("InsertInstrumentEvent: %v", err)
		}
	}

	history, err := f.master.InstrumentHistory(ctx, f.scope, instrument.ID, 50)
	if err != nil {
		t.Fatalf("InstrumentHistory: %v", err)
	}
	if len(history) != 3 {
		t.Fatalf("history = %d move(s), want 3", len(history))
	}
	// Most recent first, and each row says what it left.
	if history[0].From != domain.InstrumentInService ||
		history[0].To != domain.InstrumentInRepair {
		t.Errorf("most recent move = %s -> %s, want in_service -> in_repair",
			history[0].From, history[0].To)
	}
	if history[0].Note != "light cable intermittent" {
		t.Errorf("most recent note = %q", history[0].Note)
	}
	if history[2].From != domain.InstrumentInService {
		t.Errorf("oldest move left %q, want in_service", history[2].From)
	}

	// The loss analysis runs the other way: every move of a kind in a period,
	// across the master.
	repairs, err := f.master.MovesByStatus(ctx, f.scope, domain.InstrumentInRepair,
		at, at.Add(100*time.Hour), 50)
	if err != nil {
		t.Fatalf("MovesByStatus: %v", err)
	}
	if len(repairs) != 2 {
		t.Errorf("repairs in the period = %d, want 2", len(repairs))
	}
	// A period that ends before the second one excludes it, which is what
	// makes the report a report rather than a running total.
	earlier, err := f.master.MovesByStatus(ctx, f.scope, domain.InstrumentInRepair,
		at, at.Add(24*time.Hour), 50)
	if err != nil {
		t.Fatalf("MovesByStatus: %v", err)
	}
	if len(earlier) != 1 {
		t.Errorf("repairs in the first day = %d, want 1", len(earlier))
	}
}

// SRS-CSSD-012. The database refuses a move out of service with no reason.
//
// Raw SQL, because the rule under test belongs to the database: a status
// change with no reason is a number in a report nobody can act on, and the
// domain's own refusal would be no use to a repair tool writing directly.
func TestTheDatabaseRefusesAnUnexplainedMoveOutOfService(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	instrument, err := domain.NewInstrument(uuid.NewString(), f.tenantID,
		domain.NewInstrumentInput{Code: "SCOPE-7", SerialNumber: "SN-99001"},
		"cssd-1", at)
	if err != nil {
		t.Fatalf("NewInstrument: %v", err)
	}
	if err := f.master.InsertInstrument(ctx, f.scope, instrument); err != nil {
		t.Fatalf("InsertInstrument: %v", err)
	}

	_, err = f.pool.Exec(ctx, `
		INSERT INTO sterile.instrument_event (
		    instrument_event_id, tenant_id, instrument_id, from_status,
		    to_status, note, occurred_at, recorded_by)
		VALUES ($1, $2, $3, 'in_service', 'missing', '', now(), 'someone')`,
		uuid.New(), f.tenantID, instrument.ID)
	if err == nil {
		t.Fatal("an instrument went missing with no reason recorded; a loss " +
			"analysis would have a count and nothing to act on")
	}

	// The same move with a reason is accepted, so the constraint is not
	// simply refusing everything.
	_, err = f.pool.Exec(ctx, `
		INSERT INTO sterile.instrument_event (
		    instrument_event_id, tenant_id, instrument_id, from_status,
		    to_status, note, occurred_at, recorded_by)
		VALUES ($1, $2, $3, 'in_service', 'missing',
		        'not in the count after the case', now(), 'someone')`,
		uuid.New(), f.tenantID, instrument.ID)
	if err != nil {
		t.Fatalf("an explained move was refused: %v", err)
	}
}
