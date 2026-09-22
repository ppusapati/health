package postgres_test

import (
	"context"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"github.com/ppusapati/health/code/internal/housekeeping/adapters/postgres"
	"github.com/ppusapati/health/code/internal/housekeeping/domain"
	"github.com/ppusapati/health/code/internal/housekeeping/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
)

// The housekeeping persistence adapter.
//
// Round-trip tests, because the defect they catch is invisible above the
// adapter: a dropped field reads back as a zero that looks like a decision
// nobody made. A lost checklist turns a clean nobody can judge into a clean
// with nothing to judge; a lost restricted flag puts a biohazard task on the
// general worklist; a lost override reason turns a bed that went back into
// service uncleaned into one that was cleaned.
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
			SubjectID: "hk-1", TenantID: tenantID,
		}).TenantScope(),
		tenantID: tenantID,
	}
}

// mustFail asserts the database refuses a write, naming the constraint it
// expects. A raw statement, because the point is that the rule holds against
// a caller that never went through the domain.
func (f fixture) mustFail(t *testing.T, constraint, sql string, args ...any) {
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

func bedInput() domain.NewLocationInput {
	return domain.NewLocationInput{
		Code: "w3-bed-7", Name: "Ward 3 bed 7", Revision: 1,
		FacilityID: "f1", Zone: "ward-3", BedID: "bed-7",
		RiskClass:         domain.RiskHigh,
		RoutineEveryHours: 24, RoutineSLAMinutes: 120,
		TerminalSLAMinutes: 45,
		Checklist: []domain.ChecklistItem{
			{Code: "surfaces", Label: "High-touch surfaces", Required: true},
			{Code: "floor", Label: "Floor", Required: true},
			{Code: "curtains", Label: "Curtain change"},
		},
		ScanCode:      "W3B7",
		EffectiveFrom: at.Add(-24 * time.Hour),
	}
}

// approvedLocation stores a location whose standard is in force at `at`.
func (f fixture) approvedLocation(t *testing.T,
	in domain.NewLocationInput) domain.CleanableLocation {

	t.Helper()
	location, err := domain.NewLocation(uuid.NewString(), f.tenantID, in,
		"hk-author", at.Add(-48*time.Hour))
	if err != nil {
		t.Fatalf("NewLocation: %v", err)
	}
	if err := location.Approve("hk-manager", in.EffectiveFrom,
		at.Add(-36*time.Hour)); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	if err := f.repo.InsertLocation(context.Background(), f.scope,
		location); err != nil {
		t.Fatalf("InsertLocation: %v", err)
	}
	return location
}

func (f fixture) task(t *testing.T, location domain.CleanableLocation,
	kind domain.TaskKind) domain.CleaningTask {

	t.Helper()
	in := domain.NewTaskInput{Kind: kind, AssigneeID: "cleaner-1"}
	if kind == domain.TaskSpill {
		in.Detail, in.IncidentRef = "blood, bay 3", "inc-9"
	}
	task, err := domain.RaiseTask(uuid.NewString(), f.tenantID, location, in,
		"hk-lead", at)
	if err != nil {
		t.Fatalf("RaiseTask: %v", err)
	}
	if err := f.repo.InsertTask(context.Background(), f.scope,
		task); err != nil {
		t.Fatalf("InsertTask: %v", err)
	}
	return task
}

func TestALocationRoundTripsWithItsChecklistAndItsRevisions(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	stored := f.approvedLocation(t, bedInput())

	back, err := f.repo.Location(ctx, f.scope, stored.ID)
	if err != nil {
		t.Fatalf("Location: %v", err)
	}
	if back.Code != "w3-bed-7" || back.Revision != 1 ||
		back.RiskClass != domain.RiskHigh || back.BedID != "bed-7" ||
		back.ScanCode != "W3B7" || back.RoutineEveryHours != 24 ||
		back.RoutineSLAMinutes != 120 || back.TerminalSLAMinutes != 45 {
		t.Fatalf("location did not round-trip: %+v", back)
	}
	if !back.Approved || back.ApprovedBy != "hk-manager" ||
		back.CreatedBy != "hk-author" || !back.Live(at) {
		t.Fatalf("approval did not round-trip: %+v", back)
	}
	// A clean with no checklist is a clean nobody can judge.
	if len(back.Checklist) != 3 || back.Checklist[0].Code != "surfaces" ||
		!back.Checklist[0].Required || back.Checklist[2].Required {
		t.Fatalf("checklist did not round-trip: %+v", back.Checklist)
	}

	// A second revision supersedes the first, and both stay readable: the
	// audit question is what the standard said at the time.
	if err := f.repo.SupersedeLocation(ctx, f.scope, stored.ID,
		at.Add(-2*time.Hour)); err != nil {
		t.Fatalf("SupersedeLocation: %v", err)
	}
	second := bedInput()
	second.Revision, second.RoutineEveryHours = 2, 12
	second.EffectiveFrom = at.Add(-2 * time.Hour)
	f.approvedLocation(t, second)

	revisions, err := f.repo.RevisionsOf(ctx, f.scope, "W3-BED-7")
	if err != nil {
		t.Fatalf("RevisionsOf: %v", err)
	}
	if len(revisions) != 2 {
		t.Fatalf("want both revisions, got %d", len(revisions))
	}
	live, ok := domain.LocationInForce(revisions, "w3-bed-7", at)
	if !ok || live.Revision != 2 || live.RoutineEveryHours != 12 {
		t.Fatalf("want revision 2 in force, got %+v %v", live, ok)
	}
	// And the old one is what a clean six hours ago was judged against.
	live, ok = domain.LocationInForce(revisions, "w3-bed-7",
		at.Add(-6*time.Hour))
	if !ok || live.Revision != 1 {
		t.Fatalf("want revision 1 in force earlier, got %+v %v", live, ok)
	}

	// The live-only list is what a worklist build reads.
	listed, err := f.repo.Locations(ctx, f.scope, ports.LocationFilter{
		FacilityID: "f1", LiveOnly: true, At: at,
	})
	if err != nil {
		t.Fatalf("Locations: %v", err)
	}
	if len(listed) != 1 || listed[0].Revision != 2 {
		t.Fatalf("want only the live revision, got %+v", listed)
	}
}

func TestTheDatabaseHoldsTheCleaningStandardRules(t *testing.T) {
	f := newFixture(t)
	stored := f.approvedLocation(t, bedInput())

	const insert = `
		INSERT INTO housekeeping.cleanable_location (
			location_id, tenant_id, code, revision, risk_class, approved,
			approved_by, approved_at, effective_from, created_by)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)`

	// One person writing and approving a cleaning standard is one person
	// deciding how often a theatre is cleaned and what counts as cleaning
	// it.
	f.mustFail(t, "the_author_of_a_standard_does_not_approve_it", insert,
		uuid.New(), f.tenantID, "th-9", 1, "very_high", true,
		"hk-author", at, at, "hk-author")

	// A standard in force from no particular moment silently rejudges the
	// cleans already done against the old one.
	f.mustFail(t, "an_approved_standard_says_when_it_takes_effect", insert,
		uuid.New(), f.tenantID, "th-9", 1, "very_high", true,
		"hk-manager", at, nil, "hk-author")

	f.mustFail(t, "a_location_revision_starts_at_one", insert,
		uuid.New(), f.tenantID, "th-9", 0, "very_high", false,
		"", nil, nil, "hk-author")

	// A hospital that could type a risk class would have four wards on
	// values nobody can explain.
	f.mustFail(t, "cleanable_location_risk_class_check", insert,
		uuid.New(), f.tenantID, "th-9", 1, "quite_dirty", false,
		"", nil, nil, "hk-author")

	// A standard superseded before it took effect is a window nothing was
	// ever cleaned to.
	f.mustFail(t, "a_standard_is_superseded_after_it_takes_effect", `
		UPDATE housekeeping.cleanable_location
		SET superseded_at = effective_from - interval '1 day'
		WHERE location_id = $1`, stored.ID)

	// Two rows for one revision is two standards a reader picks between.
	f.mustFail(t, "location_revision_idx", insert,
		uuid.New(), f.tenantID, "W3-BED-7", 1, "high", false,
		"", nil, nil, "hk-author")

	// The same checklist item twice is two answers to one question.
	f.mustFail(t, "location_checklist_item_code_idx", `
		INSERT INTO housekeeping.location_checklist_item (
			location_id, item_code, required)
		VALUES ($1, 'Floor', true)`, stored.ID)
}

func TestACleaningTaskRoundTripsWithWhatItWasJudgedAgainst(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	location := f.approvedLocation(t, bedInput())

	task := f.task(t, location, domain.TaskTerminal)
	back, err := f.repo.Task(ctx, f.scope, task.ID)
	if err != nil {
		t.Fatalf("Task: %v", err)
	}
	if back.Kind != domain.TaskTerminal || back.BedID != "bed-7" ||
		back.LocationRevision != 1 || back.RiskClass != domain.RiskHigh ||
		back.ScanCode != "W3B7" || back.AssigneeID != "cleaner-1" {
		t.Fatalf("task did not round-trip: %+v", back)
	}
	if !back.DueBy.Equal(at.Add(45 * time.Minute)) {
		t.Fatalf("the terminal SLA did not round-trip: %v", back.DueBy)
	}
	// The checklist is the task's own copy, which is what a completed clean
	// is judged against.
	if len(back.Checklist) != 3 || back.Checklist[0].Code != "surfaces" {
		t.Fatalf("checklist did not round-trip: %+v", back.Checklist)
	}

	// Work it through, and the answers and exceptions come back with it.
	if err := back.Start("cleaner-1", at.Add(5*time.Minute)); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if err := f.repo.UpdateTask(ctx, f.scope, back, 1); err != nil {
		t.Fatalf("UpdateTask: %v", err)
	}
	back, err = f.repo.Task(ctx, f.scope, task.ID)
	if err != nil {
		t.Fatalf("Task: %v", err)
	}
	if err := back.Complete([]domain.ChecklistAnswer{
		{Code: "surfaces", Done: true},
		{Code: "floor", Done: false, Exception: "bed occupied"},
	}, "cleaner-1", at.Add(35*time.Minute)); err != nil {
		t.Fatalf("Complete: %v", err)
	}
	if err := f.repo.UpdateTask(ctx, f.scope, back, 2); err != nil {
		t.Fatalf("UpdateTask: %v", err)
	}

	back, err = f.repo.Task(ctx, f.scope, task.ID)
	if err != nil {
		t.Fatalf("Task: %v", err)
	}
	if back.State != domain.TaskCompleted || back.CompletedBy != "cleaner-1" ||
		len(back.Answers) != 2 {
		t.Fatalf("completion did not round-trip: %+v", back)
	}
	// An unticked box with no note is indistinguishable from one nobody
	// looked at, and the note is what makes the difference readable.
	var exception string
	for _, answer := range back.Answers {
		if answer.Code == "floor" {
			exception = answer.Exception
		}
	}
	if exception != "bed occupied" {
		t.Fatalf("the exception did not round-trip: %+v", back.Answers)
	}
	// The optional item nobody answered stays unanswered rather than
	// reading as done.
	if len(back.Checklist) != 3 {
		t.Fatalf("checklist lost an item: %+v", back.Checklist)
	}

	// A stale write loses to whoever got there first.
	if err := f.repo.UpdateTask(ctx, f.scope, back, 1); err !=
		ports.ErrVersionConflict {
		t.Fatalf("want a version conflict, got %v", err)
	}

	// A spill task keeps its restricted flag and its incident link.
	spill := f.task(t, location, domain.TaskSpill)
	backSpill, err := f.repo.Task(ctx, f.scope, spill.ID)
	if err != nil {
		t.Fatalf("Task: %v", err)
	}
	if !backSpill.Restricted || backSpill.IncidentRef != "inc-9" ||
		backSpill.Detail != "blood, bay 3" {
		t.Fatalf("spill task did not round-trip: %+v", backSpill)
	}
}

func TestTheDatabaseHoldsTheCleaningTaskRules(t *testing.T) {
	f := newFixture(t)
	location := f.approvedLocation(t, bedInput())
	task := f.task(t, location, domain.TaskRoutine)

	const insert = `
		INSERT INTO housekeeping.cleaning_task (
			task_id, tenant_id, kind, location_code, risk_class,
			location_revision, state, raised_by, bed_id, detail, restricted,
			completed_at, completed_by, verified_at, verified_by,
			cancel_reason, started_at, started_by)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
			$15, $16, $17, $18)`

	// A biohazard task with no detail sends somebody with the wrong
	// equipment.
	f.mustFail(t, "a_spill_task_says_what_was_spilled", insert,
		uuid.New(), f.tenantID, "spill", "w3-bed-7", "high", 1, "open",
		"hk-lead", "", "", true, nil, "", nil, "", "", nil, "")

	// An operator who could un-restrict a biohazard task would.
	f.mustFail(t, "a_spill_task_is_restricted", insert,
		uuid.New(), f.tenantID, "spill", "w3-bed-7", "high", 1, "open",
		"hk-lead", "", "blood", false, nil, "", nil, "", "", nil, "")

	// A terminal clean raised against a corridor holds nothing and looks
	// like it held something.
	f.mustFail(t, "a_terminal_clean_names_its_bed", insert,
		uuid.New(), f.tenantID, "terminal", "w3-bed-7", "high", 1, "open",
		"hk-lead", "", "", false, nil, "", nil, "", "", nil, "")

	f.mustFail(t, "a_completed_clean_says_who_did_the_work", insert,
		uuid.New(), f.tenantID, "routine", "w3-bed-7", "high", 1,
		"completed", "hk-lead", "", "", false, at, "", nil, "", "", nil, "")

	// A clean signed off by the cleaner is the same claim made twice.
	f.mustFail(t, "a_clean_is_verified_by_somebody_else", insert,
		uuid.New(), f.tenantID, "routine", "w3-bed-7", "high", 1,
		"verified", "hk-lead", "", "", false, at, "cleaner-1", at,
		"cleaner-1", "", nil, "")

	f.mustFail(t, "a_cancelled_task_says_why", insert,
		uuid.New(), f.tenantID, "routine", "w3-bed-7", "high", 1,
		"cancelled", "hk-lead", "", "", false, nil, "", nil, "", "", nil, "")

	f.mustFail(t, "a_started_task_says_who_began_it", insert,
		uuid.New(), f.tenantID, "routine", "w3-bed-7", "high", 1,
		"in_progress", "hk-lead", "", "", false, nil, "", nil, "", "", at, "")

	f.mustFail(t, "cleaning_task_state_check", insert,
		uuid.New(), f.tenantID, "routine", "w3-bed-7", "high", 1, "nearly",
		"hk-lead", "", "", false, nil, "", nil, "", "", nil, "")

	f.mustFail(t, "cleaning_task_kind_check", insert,
		uuid.New(), f.tenantID, "hoover", "w3-bed-7", "high", 1, "open",
		"hk-lead", "", "", false, nil, "", nil, "", "", nil, "")

	f.mustFail(t, "cleaning_task_raised_by_check", insert,
		uuid.New(), f.tenantID, "routine", "w3-bed-7", "high", 1, "open",
		"", "", "", false, nil, "", nil, "", "", nil, "")

	// An unticked box with no note is indistinguishable from one nobody
	// looked at.
	f.mustFail(t, "an_item_not_done_says_why", `
		UPDATE housekeeping.task_checklist_item
		SET answered = true, done = false, exception = ''
		WHERE task_id = $1 AND item_code = 'floor'`, task.ID)

	// And an unanswered item carries no answer, so a report counting done
	// items cannot be fooled by a row nobody filled in.
	f.mustFail(t, "an_unanswered_item_carries_no_answer", `
		UPDATE housekeeping.task_checklist_item
		SET answered = false, done = true
		WHERE task_id = $1 AND item_code = 'floor'`, task.ID)
}

func TestAScanIsAppendOnlyAndNamesWhoMadeIt(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	location := f.approvedLocation(t, bedInput())
	task := f.task(t, location, domain.TaskRoutine)

	scans := []domain.LocationScan{
		{ScannedCode: "TH2", Matched: false, ScannedBy: "cleaner-1",
			ScannedAt: at},
		{ScannedCode: "W3B7", Matched: true, ScannedBy: "cleaner-1",
			ScannedAt: at.Add(time.Minute)},
	}
	for _, scan := range scans {
		if err := f.repo.AppendScan(ctx, f.scope, task.ID, scan); err != nil {
			t.Fatalf("AppendScan: %v", err)
		}
	}

	back, err := f.repo.ScansForTask(ctx, f.scope, task.ID)
	if err != nil {
		t.Fatalf("ScansForTask: %v", err)
	}
	// The mismatch is kept, not dropped: somebody scanned the wrong door or
	// the label on this one is wrong, and both are findings.
	if len(back) != 2 || back[0].Matched || !back[1].Matched ||
		back[0].ScannedCode != "TH2" || back[0].ScannedBy != "cleaner-1" {
		t.Fatalf("scans did not round-trip: %+v", back)
	}

	// SRS-HKP-007's acceptance in the schema: a scan with nobody behind it
	// is not a scan.
	f.mustFail(t, "a_scan_names_the_person_who_made_it", `
		INSERT INTO housekeeping.location_scan (
			scan_id, tenant_id, task_id, scanned_code, scanned_by)
		VALUES ($1, $2, $3, 'W3B7', '')`,
		uuid.New(), f.tenantID, task.ID)

	f.mustFail(t, "location_scan_scanned_code_check", `
		INSERT INTO housekeeping.location_scan (
			scan_id, tenant_id, task_id, scanned_code, scanned_by)
		VALUES ($1, $2, $3, '', 'cleaner-1')`,
		uuid.New(), f.tenantID, task.ID)

	// The task itself carries the evidence back up.
	hydrated, err := f.repo.Task(ctx, f.scope, task.ID)
	if err != nil {
		t.Fatalf("Task: %v", err)
	}
	if !hydrated.ScanVerified() {
		t.Fatal("the matched scan did not reach the task")
	}
}

func TestABedHoldRoundTripsAndKeepsAnOverrideApartFromARelease(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	location := f.approvedLocation(t, bedInput())
	task := f.task(t, location, domain.TaskTerminal)

	hold, err := domain.PlaceBedHold(uuid.NewString(), f.tenantID, task,
		"enc-1", "ward-clerk", at)
	if err != nil {
		t.Fatalf("PlaceBedHold: %v", err)
	}
	if err := f.repo.InsertHold(ctx, f.scope, hold); err != nil {
		t.Fatalf("InsertHold: %v", err)
	}

	open, found, err := f.repo.OpenHoldForBed(ctx, f.scope, "bed-7")
	if err != nil || !found {
		t.Fatalf("OpenHoldForBed: %v %v", found, err)
	}
	if open.TaskID != task.ID || open.EncounterID != "enc-1" ||
		open.State != domain.HoldOpen || open.PlacedBy != "ward-clerk" {
		t.Fatalf("hold did not round-trip: %+v", open)
	}
	if _, found, err := f.repo.OpenHoldForBed(ctx, f.scope,
		"bed-9"); err != nil || found {
		t.Fatalf("a bed nobody held came back held: %v %v", found, err)
	}

	byTask, found, err := f.repo.HoldForTask(ctx, f.scope, task.ID)
	if err != nil || !found || byTask.ID != hold.ID {
		t.Fatalf("HoldForTask: %+v %v %v", byTask, found, err)
	}

	// Two open holds on one bed is a bed released once and still dirty.
	second := f.task(t, location, domain.TaskTerminal)
	f.mustFail(t, "bed_hold_open_idx", `
		INSERT INTO housekeeping.bed_hold (
			hold_id, tenant_id, bed_id, task_id, state, placed_by)
		VALUES ($1, $2, 'bed-7', $3, 'open', 'ward-clerk')`,
		uuid.New(), f.tenantID, second.ID)

	// The clean finishes, and the bed comes back.
	working, err := f.repo.Task(ctx, f.scope, task.ID)
	if err != nil {
		t.Fatalf("Task: %v", err)
	}
	if err := working.Start("cleaner-1", at.Add(5*time.Minute)); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if err := working.Complete([]domain.ChecklistAnswer{
		{Code: "surfaces", Done: true}, {Code: "floor", Done: true},
	}, "cleaner-1", at.Add(35*time.Minute)); err != nil {
		t.Fatalf("Complete: %v", err)
	}
	if err := open.Release(working, false, "ward-clerk",
		at.Add(40*time.Minute)); err != nil {
		t.Fatalf("Release: %v", err)
	}
	if err := f.repo.UpdateHold(ctx, f.scope, open, 1); err != nil {
		t.Fatalf("UpdateHold: %v", err)
	}

	released, err := f.repo.Hold(ctx, f.scope, hold.ID)
	if err != nil {
		t.Fatalf("Hold: %v", err)
	}
	if released.State != domain.HoldReleased ||
		released.ReleasedBy != "ward-clerk" ||
		!released.ReleasedAt.Equal(at.Add(40*time.Minute)) {
		t.Fatalf("release did not round-trip: %+v", released)
	}

	// The other way out keeps its own state and its reason, so a turnaround
	// report cannot count it as a clean.
	override, err := domain.PlaceBedHold(uuid.NewString(), f.tenantID, second,
		"enc-2", "ward-clerk", at.Add(time.Hour))
	if err != nil {
		t.Fatalf("PlaceBedHold: %v", err)
	}
	if err := f.repo.InsertHold(ctx, f.scope, override); err != nil {
		t.Fatalf("InsertHold: %v", err)
	}
	if err := override.Override("no beds left", "matron",
		at.Add(2*time.Hour)); err != nil {
		t.Fatalf("Override: %v", err)
	}
	if err := f.repo.UpdateHold(ctx, f.scope, override, 1); err != nil {
		t.Fatalf("UpdateHold: %v", err)
	}

	holds, err := f.repo.Holds(ctx, f.scope, ports.HoldFilter{
		FacilityID: "f1",
	})
	if err != nil {
		t.Fatalf("Holds: %v", err)
	}
	summary := domain.SummariseTurnaround(holds)
	if summary.Held != 2 || summary.Released != 1 ||
		summary.Overridden != 1 || summary.MeanMinutes != 40 {
		t.Fatalf("an override was averaged into the turnaround: %+v", summary)
	}
}

func TestTheDatabaseHoldsTheBedHoldRules(t *testing.T) {
	f := newFixture(t)
	location := f.approvedLocation(t, bedInput())
	task := f.task(t, location, domain.TaskTerminal)

	const insert = `
		INSERT INTO housekeeping.bed_hold (
			hold_id, tenant_id, bed_id, task_id, state, placed_by,
			released_at, released_by, overridden_at, overridden_by,
			override_reason)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)`

	f.mustFail(t, "a_released_hold_says_who_released_it", insert,
		uuid.New(), f.tenantID, "bed-8", task.ID, "released", "ward-clerk",
		at, "", nil, "", "")

	// A bed going back into service uncleaned is always a decision somebody
	// has to be able to point at afterwards.
	f.mustFail(t, "an_overridden_hold_says_why", insert,
		uuid.New(), f.tenantID, "bed-8", task.ID, "overridden", "ward-clerk",
		nil, "", at, "matron", "")

	// The two ways out stay apart, so a report cannot merge them.
	f.mustFail(t, "a_released_hold_is_not_an_override", insert,
		uuid.New(), f.tenantID, "bed-8", task.ID, "released", "ward-clerk",
		at, "ward-clerk", at, "matron", "no beds left")

	f.mustFail(t, "bed_hold_state_check", insert,
		uuid.New(), f.tenantID, "bed-8", task.ID, "sort of", "ward-clerk",
		nil, "", nil, "", "")

	f.mustFail(t, "bed_hold_bed_id_check", insert,
		uuid.New(), f.tenantID, "", task.ID, "open", "ward-clerk",
		nil, "", nil, "", "")

	f.mustFail(t, "bed_hold_placed_by_check", insert,
		uuid.New(), f.tenantID, "bed-8", task.ID, "open", "",
		nil, "", nil, "", "")

	// A hold with no task behind it is a bed nobody is coming to clean.
	f.mustFail(t, "bed_hold_task_id_fkey", insert,
		uuid.New(), f.tenantID, "bed-8", uuid.New(), "open", "ward-clerk",
		nil, "", nil, "", "")
}

func TestTheWorklistAndTheScheduleAnswerFromTheTasksThemselves(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	bed := f.approvedLocation(t, bedInput())

	theatreIn := bedInput()
	theatreIn.Code, theatreIn.Name = "th-2", "Theatre 2"
	theatreIn.Zone, theatreIn.BedID = "theatres", ""
	theatreIn.RiskClass = domain.RiskVeryHigh
	theatreIn.RoutineEveryHours, theatreIn.RoutineSLAMinutes = 6, 30
	theatre := f.approvedLocation(t, theatreIn)

	// A routine clean somebody finished is what the schedule derives from.
	done := f.task(t, bed, domain.TaskRoutine)
	working, err := f.repo.Task(ctx, f.scope, done.ID)
	if err != nil {
		t.Fatalf("Task: %v", err)
	}
	if err := working.Start("cleaner-1", at); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if err := working.Complete([]domain.ChecklistAnswer{
		{Code: "surfaces", Done: true}, {Code: "floor", Done: true},
	}, "cleaner-1", at.Add(30*time.Minute)); err != nil {
		t.Fatalf("Complete: %v", err)
	}
	if err := f.repo.UpdateTask(ctx, f.scope, working, 1); err != nil {
		t.Fatalf("UpdateTask: %v", err)
	}

	overdue := f.task(t, theatre, domain.TaskRoutine)

	last, err := f.repo.LastCleanedByLocation(ctx, f.scope, "f1")
	if err != nil {
		t.Fatalf("LastCleanedByLocation: %v", err)
	}
	if got := last["w3-bed-7"]; !got.Equal(at.Add(30 * time.Minute)) {
		t.Fatalf("want the completion time, got %v", got)
	}
	if _, ok := last["th-2"]; ok {
		t.Fatal("an unfinished task counted as a clean")
	}

	// The open worklist is what a housekeeping supervisor reads.
	open, err := f.repo.Tasks(ctx, f.scope, ports.TaskFilter{
		FacilityID: "f1", OpenOnly: true,
	})
	if err != nil {
		t.Fatalf("Tasks: %v", err)
	}
	if len(open) != 1 || open[0].ID != overdue.ID {
		t.Fatalf("want only the unfinished task, got %+v", open)
	}

	// And the escalation read is critical areas only, once each. A channel
	// that repeated every overdue office clean is one people filter.
	later := at.Add(4 * time.Hour)
	candidates, err := f.repo.OverdueCritical(ctx, f.scope, "f1", later, 50)
	if err != nil {
		t.Fatalf("OverdueCritical: %v", err)
	}
	if len(candidates) != 1 || candidates[0].LocationCode != "th-2" {
		t.Fatalf("want only the theatre, got %+v", candidates)
	}

	escalating := candidates[0]
	escalating.MarkEscalated(later)
	if err := f.repo.UpdateTask(ctx, f.scope, escalating, 1); err != nil {
		t.Fatalf("UpdateTask: %v", err)
	}
	candidates, err = f.repo.OverdueCritical(ctx, f.scope, "f1", later, 50)
	if err != nil {
		t.Fatalf("OverdueCritical: %v", err)
	}
	if len(candidates) != 0 {
		t.Fatalf("an escalated task came up again: %+v", candidates)
	}
}
