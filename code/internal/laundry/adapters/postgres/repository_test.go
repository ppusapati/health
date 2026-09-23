package postgres_test

import (
	"context"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"github.com/ppusapati/health/code/internal/laundry/adapters/postgres"
	"github.com/ppusapati/health/code/internal/laundry/domain"
	"github.com/ppusapati/health/code/internal/laundry/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
)

// The laundry persistence adapter.
//
// Round-trip tests, because the defect they catch is invisible above the
// adapter: a dropped field reads back as a zero that looks like a decision
// nobody made. A lost soil class turns infected linen into ordinary linen; a
// lost batch link turns a traceable wash into an anonymous one; a lost
// approval turns a write-off nobody authorised into one somebody did.
//
// The assertions that bypass the adapter and write raw SQL are the rules that
// belong to the database rather than to Go: a rule the adapter is the only
// thing enforcing is one a migration, a backfill or the next context's
// repository can walk straight past. Two of them here span rows — infected
// linen in a barrier cycle, and linen issued from a passed wash — and are
// held by composite foreign keys rather than by this package remembering.

var at = time.Date(2026, 9, 23, 6, 0, 0, 0, time.UTC)

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
			SubjectID: "lin-1", TenantID: tenantID,
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

func (f fixture) item(t *testing.T, code string,
	tracked bool) domain.LinenItem {

	t.Helper()
	item, err := domain.NewItem(uuid.NewString(), f.tenantID,
		domain.NewItemInput{
			Code: code, Name: code, Category: domain.CategoryBedding,
			UnitWeightG: 600, ReplacementCostMinor: 42000,
			Tracked: tracked,
		}, "lin-1", at)
	if err != nil {
		t.Fatalf("NewItem: %v", err)
	}
	if err := f.repo.InsertItem(context.Background(), f.scope,
		item); err != nil {
		t.Fatalf("InsertItem: %v", err)
	}
	return item
}

func (f fixture) collection(t *testing.T,
	class domain.SoilClass) domain.Collection {

	t.Helper()
	in := domain.NewCollectionInput{
		UnitID: "ward-3", UnitName: "Ward 3", FacilityID: "f1",
		SoilClass: class, BagCount: 2, WeightG: 18000,
		Lines: []domain.CollectionLine{
			{ItemCode: "SHEET-FLAT", Quantity: 20},
		},
	}
	if class == domain.SoilInfected {
		in.Lines, in.BagCount, in.WeightG = nil, 1, 9000
	}
	out, err := domain.RecordCollection(uuid.NewString(), f.tenantID, in,
		"porter-1", at)
	if err != nil {
		t.Fatalf("RecordCollection: %v", err)
	}
	if err := f.repo.InsertCollection(context.Background(), f.scope,
		out); err != nil {
		t.Fatalf("InsertCollection: %v", err)
	}
	return out
}

func (f fixture) batch(t *testing.T, cycle domain.Cycle) domain.Batch {
	t.Helper()
	out, err := domain.OpenBatch(uuid.NewString(), f.tenantID,
		domain.NewBatchInput{
			Reference: "W-1001", FacilityID: "f1", MachineID: "washer-2",
			Cycle: cycle,
		}, "lin-1", at)
	if err != nil {
		t.Fatalf("OpenBatch: %v", err)
	}
	if err := f.repo.InsertBatch(context.Background(), f.scope,
		out); err != nil {
		t.Fatalf("InsertBatch: %v", err)
	}
	return out
}

func TestALinenItemAndItsParRoundTrip(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	item := f.item(t, "SHEET-FLAT", false)
	back, err := f.repo.ItemByCode(ctx, f.scope, "sheet-flat")
	if err != nil {
		t.Fatalf("ItemByCode: %v", err)
	}
	if back.ID != item.ID || back.UnitWeightG != 600 ||
		back.ReplacementCostMinor != 42000 || back.Tracked ||
		back.Category != domain.CategoryBedding || !back.Active {
		t.Fatalf("the item did not round-trip: %+v", back)
	}

	par, err := domain.NewParLevel(uuid.NewString(), f.tenantID,
		domain.NewParInput{
			UnitID: "ward-3", UnitName: "Ward 3", FacilityID: "f1",
			Revision: 1,
			Lines: []domain.ParLine{
				{ItemCode: "SHEET-FLAT", Quantity: 60, ReorderAt: 20},
				{ItemCode: "PILLOWCASE", Quantity: 60},
			},
			EffectiveFrom: at.Add(-24 * time.Hour),
		}, "lin-1", at.Add(-48*time.Hour))
	if err != nil {
		t.Fatalf("NewParLevel: %v", err)
	}
	if err := f.repo.InsertPar(ctx, f.scope, par); err != nil {
		t.Fatalf("InsertPar: %v", err)
	}

	stored, err := f.repo.Par(ctx, f.scope, par.ID)
	if err != nil {
		t.Fatalf("Par: %v", err)
	}
	if len(stored.Lines) != 2 || stored.Lines[0].ItemCode != "SHEET-FLAT" ||
		stored.Lines[0].ReorderAt != 20 || stored.Live(at) {
		t.Fatalf("the par did not round-trip: %+v", stored)
	}

	if err := stored.Approve("lin-manager", at.Add(-24*time.Hour),
		at.Add(-36*time.Hour)); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	if err := f.repo.ApprovePar(ctx, f.scope, stored, 1); err != nil {
		t.Fatalf("ApprovePar: %v", err)
	}
	// A stale write loses to whoever got there first.
	if err := f.repo.ApprovePar(ctx, f.scope, stored, 1); err !=
		ports.ErrVersionConflict {
		t.Fatalf("want a version conflict, got %v", err)
	}

	live, err := f.repo.Pars(ctx, f.scope, ports.ParFilter{
		FacilityID: "f1", LiveOnly: true, At: at,
	})
	if err != nil {
		t.Fatalf("Pars: %v", err)
	}
	if len(live) != 1 || live[0].ApprovedBy != "lin-manager" ||
		len(live[0].Lines) != 2 {
		t.Fatalf("the approved par did not come back live: %+v", live)
	}

	// A second revision supersedes the first, and both stay readable.
	if err := f.repo.SupersedePar(ctx, f.scope, par.ID,
		at.Add(-2*time.Hour)); err != nil {
		t.Fatalf("SupersedePar: %v", err)
	}
	revisions, err := f.repo.RevisionsOf(ctx, f.scope, "WARD-3")
	if err != nil {
		t.Fatalf("RevisionsOf: %v", err)
	}
	if len(revisions) != 1 || revisions[0].SupersededAt.IsZero() {
		t.Fatalf("the supersede did not stick: %+v", revisions)
	}
}

func TestTheDatabaseHoldsTheLinenMasterRules(t *testing.T) {
	f := newFixture(t)
	item := f.item(t, "SHEET-FLAT", false)

	const insertItem = `
		INSERT INTO laundry.linen_item (
			item_id, tenant_id, code, category, unit_weight_g,
			replacement_cost_minor)
		VALUES ($1, $2, $3, $4, $5, $6)`

	f.mustFail(t, "linen_item_category_check", insertItem,
		uuid.New(), f.tenantID, "TOWEL", "linens", 0, 0)
	f.mustFail(t, "linen_item_unit_weight_g_check", insertItem,
		uuid.New(), f.tenantID, "TOWEL", "bedding", -1, 0)
	f.mustFail(t, "linen_item_replacement_cost_minor_check", insertItem,
		uuid.New(), f.tenantID, "TOWEL", "bedding", 0, -1)
	// Two items differing only in case is two pars for one thing.
	f.mustFail(t, "linen_item_code_idx", insertItem,
		uuid.New(), f.tenantID, "sheet-flat", "bedding", 0, 0)
	_ = item

	const insertPar = `
		INSERT INTO laundry.par_level (
			par_id, tenant_id, unit_id, revision, approved, approved_by,
			approved_at, effective_from, created_by)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)`

	// One person writing and approving a par is one person deciding what
	// the laundry buys.
	f.mustFail(t, "the_author_of_a_par_does_not_approve_it", insertPar,
		uuid.New(), f.tenantID, "ward-9", 1, true, "lin-1", at, at, "lin-1")
	f.mustFail(t, "an_approved_par_says_when_it_takes_effect", insertPar,
		uuid.New(), f.tenantID, "ward-9", 1, true, "lin-manager", at, nil,
		"lin-1")
	f.mustFail(t, "a_par_revision_starts_at_one", insertPar,
		uuid.New(), f.tenantID, "ward-9", 0, false, "", nil, nil, "lin-1")

	f.mustExec(t, insertPar,
		uuid.New(), f.tenantID, "ward-9", 1, false, "", nil,
		at.Add(-time.Hour), "lin-1")
	f.mustFail(t, "par_revision_idx", insertPar,
		uuid.New(), f.tenantID, "WARD-9", 1, false, "", nil, nil, "lin-1")

	var parID string
	if err := f.pool.QueryRow(context.Background(), `
		SELECT par_id FROM laundry.par_level
		WHERE tenant_id = $1 AND unit_id = 'ward-9'`,
		f.tenantID).Scan(&parID); err != nil {
		t.Fatalf("read the par: %v", err)
	}

	f.mustFail(t, "a_par_is_superseded_after_it_takes_effect", `
		UPDATE laundry.par_level SET superseded_at = $1 WHERE par_id = $2`,
		at.Add(-48*time.Hour), parID)

	const insertLine = `
		INSERT INTO laundry.par_line (par_id, item_code, quantity,
			reorder_at)
		VALUES ($1, $2, $3, $4)`

	f.mustFail(t, "a_par_is_a_positive_number", insertLine,
		parID, "SHEET-FLAT", 0, 0)
	// A reorder level above par fires on every read, so the top-up list is
	// the whole ward every morning and nobody reads it.
	f.mustFail(t, "a_reorder_level_is_not_above_par", insertLine,
		parID, "SHEET-FLAT", 10, 20)

	f.mustExec(t, insertLine, parID, "SHEET-FLAT", 60, 20)
	f.mustFail(t, "par_line_item_idx", insertLine,
		parID, "sheet-flat", 10, 0)
}

func TestInfectedLinenCannotBeAttachedToAnOrdinaryCycle(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	f.item(t, "SHEET-FLAT", false)

	infected := f.collection(t, domain.SoilInfected)
	standard := f.batch(t, domain.CycleStandard)
	barrier := f.batch(t, domain.CycleBarrier)

	// The rule this schema exists for, held across two rows by a composite
	// foreign key and a CHECK. A standard programme does not dissolve the
	// inner bag and does not reach disinfection temperature.
	f.mustFail(t, "infected_linen_goes_into_a_barrier_cycle", `
		UPDATE laundry.collection
		SET state = 'batched', batch_id = $1, batch_cycle = 'standard'
		WHERE collection_id = $2`, standard.ID, infected.ID)

	// Nor by lying about the cycle: the pair has to exist in wash_batch.
	f.mustFail(t, "collection_batch_id_batch_cycle_fkey", `
		UPDATE laundry.collection
		SET state = 'batched', batch_id = $1, batch_cycle = 'barrier'
		WHERE collection_id = $2`, standard.ID, infected.ID)

	// Through the domain and the adapter, the barrier load is accepted.
	working := infected
	loaded := barrier
	if err := loaded.Load(&working, at); err != nil {
		t.Fatalf("Load: %v", err)
	}
	if err := f.repo.UpdateBatch(ctx, f.scope, loaded, 1); err != nil {
		t.Fatalf("UpdateBatch: %v", err)
	}
	if err := f.repo.UpdateCollection(ctx, f.scope, working, 1); err != nil {
		t.Fatalf("UpdateCollection: %v", err)
	}

	back, err := f.repo.Collection(ctx, f.scope, infected.ID)
	if err != nil {
		t.Fatalf("Collection: %v", err)
	}
	if back.State != domain.CollectionBatched || back.BatchID != barrier.ID ||
		back.SoilClass != domain.SoilInfected ||
		!strings.Contains(back.Handling, "barrier") {
		t.Fatalf("the infected collection did not round-trip: %+v", back)
	}

	// And a batch that says it carries infected linen has to be a barrier
	// cycle, from its own side.
	f.mustFail(t, "a_batch_carrying_infected_linen_is_a_barrier_cycle", `
		UPDATE laundry.wash_batch SET infected = true WHERE batch_id = $1`,
		standard.ID)

	// The chain, read from the batch end: whose linen was in this load.
	chained, err := f.repo.ForBatch(ctx, f.scope, barrier.ID)
	if err != nil {
		t.Fatalf("ForBatch: %v", err)
	}
	if len(chained) != 1 || chained[0].UnitID != "ward-3" {
		t.Fatalf("the chain was not retained: %+v", chained)
	}
	hydrated, err := f.repo.Batch(ctx, f.scope, barrier.ID)
	if err != nil {
		t.Fatalf("Batch: %v", err)
	}
	if len(hydrated.CollectionIDs) != 1 || !hydrated.Infected {
		t.Fatalf("the batch did not carry its load back: %+v", hydrated)
	}
}

func TestTheDatabaseHoldsTheCollectionAndBatchRules(t *testing.T) {
	f := newFixture(t)
	f.item(t, "SHEET-FLAT", false)
	batch := f.batch(t, domain.CycleHot)
	collection := f.collection(t, domain.SoilUsed)

	const insertCollection = `
		INSERT INTO laundry.collection (
			collection_id, tenant_id, unit_id, soil_class, bag_count,
			weight_g, state, batch_id, batch_cycle, cancel_reason,
			collected_by)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)`

	f.mustFail(t, "collection_soil_class_check", insertCollection,
		uuid.New(), f.tenantID, "ward-3", "dirty", 1, 0, "open", nil, nil,
		"", "porter-1")
	f.mustFail(t, "a_collection_is_at_least_one_bag", insertCollection,
		uuid.New(), f.tenantID, "ward-3", "used", 0, 0, "open", nil, nil,
		"", "porter-1")
	f.mustFail(t, "collection_collected_by_check", insertCollection,
		uuid.New(), f.tenantID, "ward-3", "used", 1, 0, "open", nil, nil,
		"", "")
	// A batched collection with no batch is the chain SRS-LND-002 asks for,
	// broken.
	f.mustFail(t, "a_batched_collection_names_its_batch", insertCollection,
		uuid.New(), f.tenantID, "ward-3", "used", 1, 0, "batched", nil, nil,
		"", "porter-1")
	// And an open one carrying a batch is a trolley in two places.
	f.mustFail(t, "an_unbatched_collection_names_no_batch", insertCollection,
		uuid.New(), f.tenantID, "ward-3", "used", 1, 0, "open", batch.ID,
		"hot", "", "porter-1")
	f.mustFail(t, "a_cancelled_collection_says_why", insertCollection,
		uuid.New(), f.tenantID, "ward-3", "used", 1, 0, "cancelled", nil,
		nil, "", "porter-1")

	f.mustFail(t, "a_collected_count_is_positive", `
		INSERT INTO laundry.collection_line (collection_id, item_code,
			quantity)
		VALUES ($1, 'TOWEL', 0)`, collection.ID)
	f.mustFail(t, "collection_line_item_idx", `
		INSERT INTO laundry.collection_line (collection_id, item_code,
			quantity)
		VALUES ($1, 'sheet-flat', 1)`, collection.ID)

	const insertBatch = `
		INSERT INTO laundry.wash_batch (
			batch_id, tenant_id, machine_id, cycle, state, outcome,
			completed_at, completed_by, started_at, started_by,
			rewash_batch_id, created_by)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)`

	f.mustFail(t, "wash_batch_machine_id_check", insertBatch,
		uuid.New(), f.tenantID, "", "hot", "loading", "", nil, "", nil, "",
		nil, "lin-1")
	f.mustFail(t, "wash_batch_cycle_check", insertBatch,
		uuid.New(), f.tenantID, "washer-1", "boil", "loading", "", nil, "",
		nil, "", nil, "lin-1")
	f.mustFail(t, "wash_batch_state_check", insertBatch,
		uuid.New(), f.tenantID, "washer-1", "hot", "spinning", "", nil, "",
		nil, "", nil, "lin-1")
	// SRS-LND-003's acceptance: the outcome is recorded. An outcome of
	// nothing tells the person deciding whether to rewash or condemn the
	// load nothing at all.
	f.mustFail(t, "a_completed_wash_says_how_it_went", insertBatch,
		uuid.New(), f.tenantID, "washer-1", "hot", "passed", "", at,
		"op-1", nil, "", nil, "lin-1")
	f.mustFail(t, "a_started_wash_says_who_started_it", insertBatch,
		uuid.New(), f.tenantID, "washer-1", "hot", "loading", "", nil, "",
		at, "", nil, "lin-1")
	f.mustFail(t, "a_rewashed_batch_names_its_replacement", insertBatch,
		uuid.New(), f.tenantID, "washer-1", "hot", "rewashed", "redone", at,
		"op-1", at, "op-1", nil, "lin-1")

	f.mustFail(t, "batch_exception_code_check", `
		INSERT INTO laundry.batch_exception (batch_id, code)
		VALUES ($1, '')`, batch.ID)
}

func TestLinenCannotBeIssuedFromAWashThatDidNotPass(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	f.item(t, "SHEET-FLAT", false)

	wash := f.batch(t, domain.CycleHot)
	load := f.collection(t, domain.SoilUsed)
	if err := wash.Load(&load, at); err != nil {
		t.Fatalf("Load: %v", err)
	}
	if err := wash.Start("op-1", at); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if err := f.repo.UpdateBatch(ctx, f.scope, wash, 1); err != nil {
		t.Fatalf("UpdateBatch: %v", err)
	}
	if err := f.repo.UpdateCollection(ctx, f.scope, load, 1); err != nil {
		t.Fatalf("UpdateCollection: %v", err)
	}

	const insertIssue = `
		INSERT INTO laundry.linen_issue (
			issue_id, tenant_id, unit_id, batch_id, batch_state, issued_by,
			received_at, received_by)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`

	// Linen from a wash that did not pass looks exactly like clean linen,
	// and the ward that gets it has no way of telling.
	f.mustFail(t, "linen_is_issued_from_a_passed_wash", insertIssue,
		uuid.New(), f.tenantID, "ward-3", wash.ID, "processing", "lin-1",
		nil, "")
	// And claiming it passed when it has not is refused by the composite
	// key: the pair has to exist in wash_batch.
	f.mustFail(t, "linen_issue_batch_id_batch_state_fkey", insertIssue,
		uuid.New(), f.tenantID, "ward-3", wash.ID, "passed", "lin-1", nil,
		"")

	if err := wash.Complete(domain.CompleteInput{
		Passed: true, Outcome: "71C held for 3 minutes",
		PeakTemperatureC: 74, HoldMinutes: 3,
	}, "op-1", at.Add(time.Hour)); err != nil {
		t.Fatalf("Complete: %v", err)
	}
	if err := f.repo.UpdateBatch(ctx, f.scope, wash, 2); err != nil {
		t.Fatalf("UpdateBatch: %v", err)
	}

	issue, err := domain.IssueLinen(uuid.NewString(), f.tenantID, wash,
		domain.NewIssueInput{
			UnitID: "ward-3", UnitName: "Ward 3", FacilityID: "f1",
			Lines: []domain.IssueLine{
				{ItemCode: "SHEET-FLAT", Quantity: 40},
			},
		}, "lin-1", at.Add(2*time.Hour))
	if err != nil {
		t.Fatalf("IssueLinen: %v", err)
	}
	if err := f.repo.InsertIssue(ctx, f.scope, issue); err != nil {
		t.Fatalf("InsertIssue: %v", err)
	}

	// A delivery signed for by the porter who brought it is the same claim
	// made twice.
	f.mustFail(t, "linen_is_received_by_somebody_else", `
		UPDATE laundry.linen_issue
		SET received_at = $1, received_by = 'lin-1' WHERE issue_id = $2`,
		at, issue.ID)

	// And the wash cannot be un-passed once linen has gone out on it: the
	// cascade would carry the new state onto the issue, where the CHECK
	// refuses it.
	f.mustFail(t, "linen_is_issued_from_a_passed_wash", `
		UPDATE laundry.wash_batch SET state = 'failed' WHERE batch_id = $1`,
		wash.ID)

	back, err := f.repo.Issue(ctx, f.scope, issue.ID)
	if err != nil {
		t.Fatalf("Issue: %v", err)
	}
	if back.BatchID != wash.ID || back.Pieces() != 40 ||
		back.BatchReference != "W-1001" {
		t.Fatalf("the issue did not round-trip: %+v", back)
	}

	if err := back.Receive("nurse-1", at.Add(3*time.Hour)); err != nil {
		t.Fatalf("Receive: %v", err)
	}
	if err := f.repo.ReceiveIssue(ctx, f.scope, back, 1); err != nil {
		t.Fatalf("ReceiveIssue: %v", err)
	}
	outstanding, err := f.repo.Issues(ctx, f.scope, ports.IssueFilter{
		FacilityID: "f1", OutstandingOnly: true,
	})
	if err != nil {
		t.Fatalf("Issues: %v", err)
	}
	if len(outstanding) != 0 {
		t.Fatalf("a received issue is still outstanding: %+v", outstanding)
	}

	f.mustFail(t, "an_issued_count_is_positive", `
		INSERT INTO laundry.issue_line (issue_id, item_code, quantity)
		VALUES ($1, 'TOWEL', 0)`, issue.ID)
	f.mustFail(t, "issue_line_item_idx", `
		INSERT INTO laundry.issue_line (issue_id, item_code, quantity)
		VALUES ($1, 'sheet-flat', 1)`, issue.ID)
}

func TestALossRecordRoundTripsAndIsDecidedBySomebodyElse(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	record, err := domain.ReportLoss(uuid.NewString(), f.tenantID,
		domain.NewLossInput{
			UnitID: "ward-3", FacilityID: "f1", ItemCode: "SHEET-FLAT",
			Quantity: 4, Kind: domain.LossCondemned,
			Reason: "torn beyond repair", ValueMinor: 42000,
			ApprovalThresholdMinor: 10000,
		}, "sister-1", at)
	if err != nil {
		t.Fatalf("ReportLoss: %v", err)
	}
	if err := f.repo.InsertLoss(ctx, f.scope, record); err != nil {
		t.Fatalf("InsertLoss: %v", err)
	}

	back, err := f.repo.Loss(ctx, f.scope, record.ID)
	if err != nil {
		t.Fatalf("Loss: %v", err)
	}
	if back.Quantity != 4 || back.ValueMinor != 42000 ||
		!back.ApprovalRequired || back.Counts() ||
		back.Reason != "torn beyond repair" {
		t.Fatalf("the loss did not round-trip: %+v", back)
	}

	const insertLoss = `
		INSERT INTO laundry.loss_record (
			loss_id, tenant_id, unit_id, item_code, quantity, kind, reason,
			value_minor, state, approved_by, approved_at, decision_note,
			reported_by)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)`

	// A ward sister writing off her own ward's linen and approving it
	// herself is the whole of why the requirement says "with approval where
	// required".
	f.mustFail(t, "a_write_off_is_decided_by_somebody_else", insertLoss,
		uuid.New(), f.tenantID, "ward-3", "TOWEL", 1, "condemned", "torn",
		0, "approved", "sister-1", at, "", "sister-1")
	f.mustFail(t, "a_refused_write_off_says_why", insertLoss,
		uuid.New(), f.tenantID, "ward-3", "TOWEL", 1, "condemned", "torn",
		0, "rejected", "lin-manager", at, "", "sister-1")
	// A condemned sheet does not turn up again.
	f.mustFail(t, "only_missing_linen_is_recovered", insertLoss,
		uuid.New(), f.tenantID, "ward-3", "TOWEL", 1, "condemned", "torn",
		0, "recovered", "", nil, "", "sister-1")
	f.mustFail(t, "a_loss_is_a_positive_number", insertLoss,
		uuid.New(), f.tenantID, "ward-3", "TOWEL", 0, "condemned", "torn",
		0, "reported", "", nil, "", "sister-1")
	f.mustFail(t, "loss_record_reason_check", insertLoss,
		uuid.New(), f.tenantID, "ward-3", "TOWEL", 1, "condemned", "",
		0, "reported", "", nil, "", "sister-1")
	f.mustFail(t, "loss_record_kind_check", insertLoss,
		uuid.New(), f.tenantID, "ward-3", "TOWEL", 1, "vanished", "torn",
		0, "reported", "", nil, "", "sister-1")
	f.mustFail(t, "loss_record_reported_by_check", insertLoss,
		uuid.New(), f.tenantID, "ward-3", "TOWEL", 1, "condemned", "torn",
		0, "reported", "", nil, "", "")

	if err := back.Approve("agreed", "lin-manager", at); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	if err := f.repo.UpdateLoss(ctx, f.scope, back, 1); err != nil {
		t.Fatalf("UpdateLoss: %v", err)
	}
	approved, err := f.repo.Losses(ctx, f.scope, ports.LossFilter{
		UnitID: "WARD-3", States: []string{"approved"},
	})
	if err != nil {
		t.Fatalf("Losses: %v", err)
	}
	if len(approved) != 1 || !approved[0].Counts() ||
		approved[0].ApprovedBy != "lin-manager" {
		t.Fatalf("the approval did not round-trip: %+v", approved)
	}
}

func TestATagOnlyGoesOnATrackedItemAndItsTrailIsAppendOnly(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	sheet := f.item(t, "SHEET-FLAT", false)
	scrub := f.item(t, "SCRUB-TOP", true)

	tracked, err := domain.RegisterTag(uuid.NewString(), f.tenantID, scrub,
		domain.NewTrackedInput{
			TagID: "RF-0001", TagKind: domain.TagRFID,
			ItemCode: "SCRUB-TOP", AssignedTo: "nurse-1", FacilityID: "f1",
		}, "lin-1", at)
	if err != nil {
		t.Fatalf("RegisterTag: %v", err)
	}
	if err := f.repo.InsertTracked(ctx, f.scope, tracked); err != nil {
		t.Fatalf("InsertTracked: %v", err)
	}

	// A custody trail for one sheet out of four thousand reads as a system
	// that lost the other three thousand nine hundred and ninety-nine. The
	// composite key onto (tenant, code, tracked) is what refuses it.
	f.mustFail(t, "tracked_item_tenant_id_item_code_item_tracked_fkey", `
		INSERT INTO laundry.tracked_item (
			tracked_id, tenant_id, tag_id, tag_kind, item_code, state,
			registered_by)
		VALUES ($1, $2, 'RF-9999', 'rfid', $3, 'in_service', 'lin-1')`,
		uuid.New(), f.tenantID, sheet.Code)

	// And not by declaring the item untracked either. The composite key
	// would happily match (tenant, SHEET-FLAT, false); the CHECK is what
	// stops a caller tagging a bed sheet by admitting it is not a tracked
	// item.
	f.mustFail(t, "a_tag_is_only_on_a_tracked_item", `
		INSERT INTO laundry.tracked_item (
			tracked_id, tenant_id, tag_id, tag_kind, item_code,
			item_tracked, state, registered_by)
		VALUES ($1, $2, 'RF-9998', 'rfid', $3, false, 'in_service',
			'lin-1')`, uuid.New(), f.tenantID, sheet.Code)

	// Two items answering to one tag is a custody trail that belongs to
	// neither.
	f.mustFail(t, "tracked_tag_idx", `
		INSERT INTO laundry.tracked_item (
			tracked_id, tenant_id, tag_id, tag_kind, item_code, state,
			registered_by)
		VALUES ($1, $2, 'rf-0001', 'rfid', 'SCRUB-TOP', 'in_service',
			'lin-1')`, uuid.New(), f.tenantID)

	f.mustFail(t, "a_retired_tag_says_why", `
		UPDATE laundry.tracked_item SET state = 'retired'
		WHERE tracked_id = $1`, tracked.ID)

	// A movement attributed to a reader rather than a session is a movement
	// anybody walking past the reader can create.
	f.mustFail(t, "a_movement_names_who_recorded_it", `
		INSERT INTO laundry.tracked_movement (
			movement_id, tenant_id, tracked_id, location, recorded_by)
		VALUES ($1, $2, $3, 'laundry-door', '')`,
		uuid.New(), f.tenantID, tracked.ID)
	f.mustFail(t, "tracked_movement_location_check", `
		INSERT INTO laundry.tracked_movement (
			movement_id, tenant_id, tracked_id, location, recorded_by)
		VALUES ($1, $2, $3, '', 'op-1')`,
		uuid.New(), f.tenantID, tracked.ID)

	for _, scan := range []struct {
		location, holder string
		when             time.Time
	}{
		{"laundry-door", "", at},
		{"ward-3-store", "nurse-1", at.Add(2 * time.Hour)},
		{"laundry-sort", "", at.Add(time.Hour)},
	} {
		if err := f.repo.AppendMovement(ctx, f.scope, tracked.ID,
			domain.Movement{
				Location: scan.location, HolderID: scan.holder,
				RecordedBy: "op-1", At: scan.when,
			}); err != nil {
			t.Fatalf("AppendMovement: %v", err)
		}
	}

	byTag, err := f.repo.TrackedByTag(ctx, f.scope, "rf-0001")
	if err != nil {
		t.Fatalf("TrackedByTag: %v", err)
	}
	if len(byTag.Movements) != 3 || byTag.AssignedTo != "nurse-1" {
		t.Fatalf("the trail did not round-trip: %+v", byTag)
	}
	// The last known custody is the latest scan by time, not the last one
	// written: a reader that uploads late must not rewrite where something
	// is.
	custody := byTag.LastKnown()
	if !custody.Known || custody.Location != "ward-3-store" ||
		custody.HolderID != "nurse-1" {
		t.Fatalf("the custody is wrong: %+v", custody)
	}
}
