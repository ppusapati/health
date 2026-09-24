package postgres_test

import (
	"context"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	"github.com/ppusapati/health/code/internal/facilities/adapters/postgres"
	"github.com/ppusapati/health/code/internal/facilities/domain"
	"github.com/ppusapati/health/code/internal/facilities/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
)

// The facilities persistence adapter.
//
// Round-trip tests, because the defect they catch is invisible above the
// adapter: a dropped field reads back as a zero that looks like a decision
// nobody made. A lost permit reference turns unsafe work into ordinary work;
// a lost criticality turns the oxygen manifold into a car park barrier; a
// lost source turns a number somebody typed into a meter reading.
//
// The assertions that bypass the adapter and write raw SQL are the rules that
// belong to the database rather than to Go. A rule the adapter is the only
// thing enforcing is one a migration, a backfill or the next context's
// repository walks straight past. Four of them span two rows and are held by
// composite foreign keys carrying a denormalised column — see the migration
// header — and those are the ones tested hardest here, because they are the
// ones that would otherwise be a convention.

var at = time.Date(2026, 9, 24, 8, 0, 0, 0, time.UTC)

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
			SubjectID: "fac-1", TenantID: tenantID,
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

func (f fixture) scalar(t *testing.T, sql string, args ...any) string {
	t.Helper()
	var out string
	if err := f.pool.QueryRow(context.Background(), sql, args...).
		Scan(&out); err != nil {
		t.Fatalf("query: %v", err)
	}
	return out
}

func ok(t *testing.T, err error) {
	t.Helper()
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
}

func ctx() context.Context { return context.Background() }

// ------------------------------------------------------ assets (SRS-FAC-001)

func (f fixture) asset(t *testing.T, tag string,
	mutate func(*domain.NewAssetInput)) domain.Asset {

	t.Helper()
	in := domain.NewAssetInput{
		Tag: tag, Name: "Generator 2",
		System: domain.SystemPower, Criticality: domain.CriticalityLife,
		LocationID: uuid.NewString(), FacilityID: uuid.NewString(),
		Manufacturer: "Cummins", Model: "C750D5",
		SerialNumber:   "SN-9920",
		CommissionedAt: at.AddDate(-4, 0, 0),
	}
	if mutate != nil {
		mutate(&in)
	}
	a, err := domain.NewAsset(uuid.NewString(), f.tenantID, in, "u-est", at)
	ok(t, err)
	ok(t, f.repo.InsertAsset(ctx(), f.scope, a))
	return a
}

func TestAnAssetSurvivesTheRoundTrip(t *testing.T) {
	f := newFixture(t)
	want := f.asset(t, "DG-02", nil)

	got, err := f.repo.Asset(ctx(), f.scope, want.ID)
	ok(t, err)

	if got.Criticality != domain.CriticalityLife {
		// Criticality is what orders the list a facilities manager
		// reads first. Losing it puts the oxygen manifold below the
		// car park barrier.
		t.Fatalf("criticality must survive: %+v", got)
	}
	if got.System != domain.SystemPower || got.Status != domain.AssetInService {
		t.Fatalf("system and status must survive: %+v", got)
	}
	if got.LocationID != want.LocationID || got.SerialNumber != "SN-9920" {
		t.Fatalf("location and serial must survive: %+v", got)
	}
	if !got.CommissionedAt.Equal(want.CommissionedAt) {
		t.Fatalf("the commissioning date must survive: %v",
			got.CommissionedAt)
	}

	byTag, err := f.repo.AssetByTag(ctx(), f.scope, "DG-02")
	ok(t, err)
	if byTag.ID != want.ID {
		t.Fatal("an asset is findable by the tag on the machine")
	}
}

func TestTheDatabaseInsistsAnAssetHasALocation(t *testing.T) {
	// SRS-FAC-001's acceptance, held below the adapter so a backfill
	// cannot create plant nobody can find.
	f := newFixture(t)
	f.mustFail(t, "an_asset_says_where_it_is", `
		INSERT INTO facilities.asset (id, tenant_id, tag, name, system,
			criticality, status, status_at, created_by)
		VALUES ($1, $2, 'X-1', 'Nowhere', 'hvac', 'normal',
			'in_service', now(), 'u')`,
		uuid.New(), f.tenantID)
}

func TestTheDatabaseInsistsDownPlantSaysWhy(t *testing.T) {
	f := newFixture(t)
	a := f.asset(t, "DG-03", nil)
	f.mustFail(t, "an_out_of_service_asset_says_why", `
		UPDATE facilities.asset SET status = 'down', status_reason = ''
		WHERE id = $1`, uuid.MustParse(a.ID))
}

func TestTwoLiveAssetsCannotShareATag(t *testing.T) {
	// A work order raised against whichever the search returned first.
	f := newFixture(t)
	f.asset(t, "DG-04", nil)
	f.mustFail(t, "asset_tag_idx", `
		INSERT INTO facilities.asset (id, tenant_id, tag, name, system,
			criticality, location_note, status, status_at, created_by)
		VALUES ($1, $2, 'DG-04', 'Clone', 'power', 'normal', 'roof',
			'in_service', now(), 'u')`,
		uuid.New(), f.tenantID)
}

func TestADecommissionedAssetReleasesItsTag(t *testing.T) {
	// A replacement usually inherits the stencil, and refusing the tag
	// would push the new machine onto a name nobody uses.
	f := newFixture(t)
	old := f.asset(t, "DG-05", nil)
	f.mustExec(t, `UPDATE facilities.asset
		SET status = 'decommissioned', status_reason = 'replaced'
		WHERE id = $1`, uuid.MustParse(old.ID))
	f.asset(t, "DG-05", nil)
}

// ---------------------------------- work orders and permits (SRS-FAC-002/010)

func (f fixture) workClass(t *testing.T, code string,
	permit, loto bool) domain.WorkClass {

	t.Helper()
	c := domain.WorkClass{
		TenantID: f.tenantID, Code: code, Name: "Class " + code,
		RequiresPermit: permit, RequiresLOTO: loto, Active: true,
	}
	if permit || loto {
		c.Note = "after the 2024 arc flash"
	}
	ok(t, f.repo.UpsertWorkClass(ctx(), f.scope, c))
	return c
}

func (f fixture) workOrder(t *testing.T, number string, class domain.WorkClass,
	mutate func(*domain.RaiseInput)) domain.WorkOrder {

	t.Helper()
	in := domain.RaiseInput{
		Number: number, FacilityID: uuid.NewString(),
		System: domain.SystemHVAC, LocationID: uuid.NewString(),
		Fault:    "AHU-OT-1 tripping on overload",
		Impact:   "theatre 2 cannot be used",
		Priority: domain.PriorityUrgent, Class: class,
		OwnerTeam: "estates-mechanical",
	}
	if mutate != nil {
		mutate(&in)
	}
	w, err := domain.Raise(uuid.NewString(), f.tenantID, in,
		domain.DefaultSLAPolicy(), "u-ward", at)
	ok(t, err)
	ok(t, f.repo.InsertWorkOrder(ctx(), f.scope, w))
	return w
}

func TestAWorkOrderSurvivesTheRoundTrip(t *testing.T) {
	f := newFixture(t)
	class := f.workClass(t, "hv_switching", true, true)
	want := f.workOrder(t, "WO-2001", class, nil)

	got, err := f.repo.WorkOrder(ctx(), f.scope, want.ID)
	ok(t, err)

	if !got.ClassRequiresPermit || !got.ClassRequiresLOTO {
		// Losing either flag turns unsafe work into ordinary work,
		// and the rule that it cannot close without paperwork stops
		// applying to it.
		t.Fatalf("the class flags must survive: %+v", got)
	}
	if !got.RespondBy.Equal(want.RespondBy) ||
		!got.ResolveBy.Equal(want.ResolveBy) {
		t.Fatalf("both SLA targets must survive: %+v", got)
	}
	if got.Impact != want.Impact || got.OwnerTeam != want.OwnerTeam {
		t.Fatalf("impact and owner must survive: %+v", got)
	}
}

func TestPermitWorkCannotCloseWithoutItsPaperwork(t *testing.T) {
	// SRS-FAC-010's acceptance, as a database rule. The whole reason the
	// order carries its class's flags: a CHECK sees one row.
	f := newFixture(t)
	class := f.workClass(t, "confined_space", true, true)
	w := f.workOrder(t, "WO-2002", class, nil)

	f.mustExec(t, `UPDATE facilities.work_order
		SET state = 'resolved', owner_user_id = 'u-fitter',
		    completion_note = 'cleaned', loto_ref = 'LOTO-1',
		    loto_applied_by = 'u-fitter'
		WHERE id = $1`, uuid.MustParse(w.ID))

	f.mustFail(t, "permit_work_does_not_close_without_its_permit", `
		UPDATE facilities.work_order
		SET state = 'closed', closed_by = 'u-supervisor', closed_at = now()
		WHERE id = $1`, uuid.MustParse(w.ID))
}

func TestPermitWorkCannotCloseWithoutItsIsolation(t *testing.T) {
	f := newFixture(t)
	class := f.workClass(t, "belt_change", false, true)
	w := f.workOrder(t, "WO-2003", class, nil)

	f.mustExec(t, `UPDATE facilities.work_order
		SET state = 'resolved', owner_user_id = 'u-fitter',
		    completion_note = 'belt replaced'
		WHERE id = $1`, uuid.MustParse(w.ID))

	f.mustFail(t, "permit_work_does_not_close_without_its_isolation", `
		UPDATE facilities.work_order
		SET state = 'closed', closed_by = 'u-supervisor', closed_at = now()
		WHERE id = $1`, uuid.MustParse(w.ID))
}

func TestAnOrderCannotDisagreeWithItsClass(t *testing.T) {
	// The composite key. Without it the copied flags would be a
	// convention, and the rule above could be defeated by writing false
	// into a column.
	f := newFixture(t)
	f.workClass(t, "hot_work", true, false)

	f.mustFail(t, "work_order_class_fk", `
		INSERT INTO facilities.work_order (id, tenant_id, number, system,
			location_note, fault, impact, priority, class_code,
			class_requires_permit, class_requires_loto, owner_team,
			state, raised_at, raised_by, respond_by, resolve_by)
		VALUES ($1, $2, 'WO-FAKE', 'fire', 'roof', 'welding',
			'nothing', 'routine', 'hot_work', false, false,
			'estates', 'raised', now(), 'u', now(), now())`,
		uuid.New(), f.tenantID)
}

func TestMarkingAClassUnsafeReachesItsOpenOrders(t *testing.T) {
	// The cascade. A hospital that decides a class needs a permit after
	// an incident must not be left with orders of that class that think
	// they do not.
	f := newFixture(t)
	class := f.workClass(t, "roof_access", false, false)
	w := f.workOrder(t, "WO-2004", class, nil)

	class.RequiresPermit = true
	class.Note = "fall from the plant room roof, March"
	ok(t, f.repo.UpsertWorkClass(ctx(), f.scope, class))

	got, err := f.repo.WorkOrder(ctx(), f.scope, w.ID)
	ok(t, err)
	if !got.ClassRequiresPermit {
		t.Fatalf("the order must have followed its class: %+v", got)
	}
}

func TestMarkingAClassUnsafeFailsAgainstWorkAlreadyClosedWithoutAPermit(
	t *testing.T) {

	// The other side of the cascade, and the honest outcome. A hospital
	// cannot retroactively declare that closed work had a permit; the
	// update fails and somebody has to look at those orders.
	f := newFixture(t)
	class := f.workClass(t, "panel_work", false, false)
	w := f.workOrder(t, "WO-2005", class, nil)
	f.mustExec(t, `UPDATE facilities.work_order
		SET state = 'closed', owner_user_id = 'u-fitter',
		    closed_by = 'u-supervisor', closed_at = now(),
		    completion_note = 'tightened'
		WHERE id = $1`, uuid.MustParse(w.ID))

	// The note is set in the same statement so that the class's own
	// "say why it is unsafe" rule cannot be the one that fires: the
	// assertion has to be about the closed order, not about the class.
	f.mustFail(t, "permit_work_does_not_close_without_its_permit", `
		UPDATE facilities.work_class
		SET requires_permit = true, note = 'live panel incident, March'
		WHERE tenant_id = $1 AND code = 'panel_work'`, f.tenantID)
}

func TestWorkIsNotSignedOffByWhoeverDidIt(t *testing.T) {
	f := newFixture(t)
	class := f.workClass(t, "general", false, false)
	w := f.workOrder(t, "WO-2006", class, nil)
	f.mustExec(t, `UPDATE facilities.work_order
		SET state = 'resolved', owner_user_id = 'u-fitter',
		    completion_note = 'done'
		WHERE id = $1`, uuid.MustParse(w.ID))

	f.mustFail(t, "work_is_not_signed_off_by_whoever_did_it", `
		UPDATE facilities.work_order
		SET state = 'closed', closed_by = 'u-fitter', closed_at = now()
		WHERE id = $1`, uuid.MustParse(w.ID))
}

func TestOptimisticConcurrencyOnAWorkOrder(t *testing.T) {
	f := newFixture(t)
	class := f.workClass(t, "general", false, false)
	w := f.workOrder(t, "WO-2007", class, nil)

	ok(t, w.Assign("u-fitter", "", at))
	ok(t, f.repo.UpdateWorkOrder(ctx(), f.scope, w, 1))

	// A second write against the version we already superseded is the
	// lost update this guards.
	if err := f.repo.UpdateWorkOrder(ctx(), f.scope, w, 1); err == nil ||
		!strings.Contains(err.Error(), "version conflict") {
		t.Fatalf("want a version conflict, got %v", err)
	}
}

func TestTwoWorkOrdersCannotShareANumber(t *testing.T) {
	f := newFixture(t)
	class := f.workClass(t, "general", false, false)
	f.workOrder(t, "WO-2008", class, nil)

	w, err := domain.Raise(uuid.NewString(), f.tenantID, domain.RaiseInput{
		Number: "WO-2008", System: domain.SystemHVAC,
		LocationNote: "ward 5", Fault: "leak", Impact: "bay closed",
		Priority: domain.PriorityRoutine, Class: class,
		OwnerTeam: "estates",
	}, domain.DefaultSLAPolicy(), "u-ward", at)
	ok(t, err)

	err = f.repo.InsertWorkOrder(ctx(), f.scope, w)
	if err == nil || !strings.Contains(err.Error(), "FAC_NUMBER_IN_USE") {
		// A clerk who reused a number must be told that, not handed an
		// internal error with the answer in a log they cannot read.
		t.Fatalf("want a named refusal, got %v", err)
	}
}

func TestAWorkOrderListFiltersByOpenness(t *testing.T) {
	f := newFixture(t)
	class := f.workClass(t, "general", false, false)
	open := f.workOrder(t, "WO-2009", class, nil)
	closed := f.workOrder(t, "WO-2010", class, nil)
	f.mustExec(t, `UPDATE facilities.work_order
		SET state = 'closed', owner_user_id = 'u-fitter',
		    closed_by = 'u-sup', closed_at = now(),
		    completion_note = 'done'
		WHERE id = $1`, uuid.MustParse(closed.ID))

	got, err := f.repo.WorkOrders(ctx(), f.scope,
		ports.WorkOrderFilter{OpenOnly: true})
	ok(t, err)
	if len(got) != 1 || got[0].ID != open.ID {
		t.Fatalf("only the open order, got %d", len(got))
	}

	// And an unfiltered list still returns both — the zero-time window
	// must not exclude everything.
	all, err := f.repo.WorkOrders(ctx(), f.scope, ports.WorkOrderFilter{})
	ok(t, err)
	if len(all) != 2 {
		t.Fatalf("an unfiltered list returns everything, got %d", len(all))
	}
}

// ------------------------------ maintenance and evidence (SRS-FAC-003/007)

func (f fixture) schedule(t *testing.T, kind domain.MaintenanceKind,
	mutate func(*domain.Schedule)) domain.Schedule {

	t.Helper()
	s := domain.Schedule{
		ID: uuid.NewString(), TenantID: f.tenantID,
		Title: "Lift thorough examination", Kind: kind,
		Trigger: domain.TriggerCalendar, IntervalDays: 182,
		Active: true, CreatedAt: at.AddDate(0, 0, -200), CreatedBy: "u-est",
	}
	if kind == domain.MaintenanceStatutory {
		s.Authority = "State Lift Inspectorate"
		s.RequiresEvidence = true
	}
	if mutate != nil {
		mutate(&s)
	}
	ok(t, f.repo.InsertSchedule(ctx(), f.scope, s))
	return s
}

func (f fixture) task(t *testing.T, s domain.Schedule) domain.Task {
	t.Helper()
	task, err := domain.PlanTask(uuid.NewString(), s, at.AddDate(0, 0, -1),
		0, domain.TriggerCalendar, at)
	ok(t, err)
	ok(t, f.repo.InsertTask(ctx(), f.scope, task))
	return task
}

func TestAScheduleAndItsTaskSurviveTheRoundTrip(t *testing.T) {
	f := newFixture(t)
	s := f.schedule(t, domain.MaintenanceStatutory, nil)
	want := f.task(t, s)

	got, err := f.repo.Task(ctx(), f.scope, want.ID)
	ok(t, err)
	if got.ScheduleKind != domain.MaintenanceStatutory ||
		!got.ScheduleRequiresEvidence {
		// Losing either copy makes the certificate rule stop applying
		// to this inspection.
		t.Fatalf("the schedule's rules must survive: %+v", got)
	}
	if !got.DueAt.Equal(want.DueAt) ||
		got.TriggeredBy != domain.TriggerCalendar {
		t.Fatalf("the due date and its trigger must survive: %+v", got)
	}

	back, err := f.repo.Schedule(ctx(), f.scope, s.ID)
	ok(t, err)
	if back.Authority != "State Lift Inspectorate" || !back.RequiresEvidence {
		t.Fatalf("the authority must survive: %+v", back)
	}
}

func TestAStatutoryInspectionCannotBeMarkedDoneWithoutACertificate(
	t *testing.T) {

	// SRS-FAC-003's evidence acceptance, held below the adapter. An
	// inspection marked done on the day the inspector did not come is the
	// one this prevents.
	f := newFixture(t)
	s := f.schedule(t, domain.MaintenanceStatutory, nil)
	task := f.task(t, s)

	f.mustFail(t, "a_statutory_inspection_closes_with_a_certificate", `
		UPDATE facilities.task
		SET state = 'done', done_at = now(), done_by = 'u-insp',
		    findings = 'passed', evidence_ref = 'doc-1'
		WHERE id = $1`, uuid.MustParse(task.ID))
}

func TestAnEvidencedTaskCannotBeMarkedDoneWithoutEvidence(t *testing.T) {
	f := newFixture(t)
	s := f.schedule(t, domain.MaintenancePreventive, func(s *domain.Schedule) {
		s.RequiresEvidence = true
		s.Title = "Fire damper drop test"
	})
	task := f.task(t, s)

	f.mustFail(t, "an_evidenced_task_closes_with_evidence", `
		UPDATE facilities.task
		SET state = 'done', done_at = now(), done_by = 'u-fitter',
		    findings = 'all dampers dropped'
		WHERE id = $1`, uuid.MustParse(task.ID))
}

func TestAStatutoryInspectionCannotBeWaived(t *testing.T) {
	// A hospital cannot waive its own lift inspection.
	f := newFixture(t)
	s := f.schedule(t, domain.MaintenanceStatutory, nil)
	task := f.task(t, s)

	f.mustFail(t, "a_statutory_inspection_is_not_waived", `
		UPDATE facilities.task
		SET state = 'waived', waived_reason = 'lift out of service',
		    done_by = 'u-est', done_at = now()
		WHERE id = $1`, uuid.MustParse(task.ID))
}

func TestATaskCannotDisagreeWithItsSchedule(t *testing.T) {
	// The second composite key. Without it, a task could claim to be
	// preventive against a statutory schedule and escape the certificate
	// rule entirely.
	f := newFixture(t)
	s := f.schedule(t, domain.MaintenanceStatutory, nil)

	f.mustFail(t, "task_schedule_fk", `
		INSERT INTO facilities.task (id, tenant_id, schedule_id, title,
			schedule_kind, schedule_requires_evidence, due_at,
			triggered_by, state)
		VALUES ($1, $2, $3, 'Sneaky', 'preventive', false, now(),
			'calendar', 'planned')`,
		uuid.New(), f.tenantID, uuid.MustParse(s.ID))
}

func TestOneOpenOccurrencePerSchedule(t *testing.T) {
	// Two planned filter changes for one AHU means somebody does it twice
	// or nobody does.
	f := newFixture(t)
	s := f.schedule(t, domain.MaintenancePreventive, nil)
	f.task(t, s)

	second, err := domain.PlanTask(uuid.NewString(), s, at, 0,
		domain.TriggerCalendar, at)
	ok(t, err)
	err = f.repo.InsertTask(ctx(), f.scope, second)
	if err == nil ||
		!strings.Contains(err.Error(), "FAC_TASK_ALREADY_PLANNED") {
		t.Fatalf("want a named refusal, got %v", err)
	}
}

func TestARuntimeSeriesIsAppendOnlyAndOrdered(t *testing.T) {
	// SRS-FAC-007. The latest reading is what a new one is checked
	// against, so reading it back in the wrong order would let a counter
	// go backwards unnoticed.
	f := newFixture(t)
	a := f.asset(t, "DG-10", nil)

	for i, hours := range []int{1000, 1180, 1260} {
		reading, err := domain.RecordRuntime(uuid.NewString(), f.tenantID,
			a.ID, hours, at.AddDate(0, 0, -10+i*4),
			domain.SourceBMS, "bms:DG2.RunHours", false, "", "u-gw",
			0, at)
		ok(t, err)
		ok(t, f.repo.InsertRuntimeReading(ctx(), f.scope, reading))
	}

	latest, found, err := f.repo.LatestRuntime(ctx(), f.scope, a.ID)
	ok(t, err)
	if !found || latest.Hours != 1260 {
		t.Fatalf("the latest reading is the most recent one: %+v", latest)
	}
	if latest.Source != domain.SourceBMS || latest.SourceRef == "" {
		// A figure whose origin was not kept cannot be argued with.
		t.Fatalf("provenance must survive: %+v", latest)
	}

	all, err := f.repo.RuntimeReadings(ctx(), f.scope, a.ID,
		time.Time{}, time.Time{}, 0)
	ok(t, err)
	if len(all) != 3 || all[0].Hours != 1000 {
		t.Fatalf("the series reads oldest first: %+v", all)
	}
}

func TestAnAssetWithNoRuntimeReadingsIsNotAnError(t *testing.T) {
	// The first reading of a machine has nothing before it. An error here
	// would make recording the very first hour count impossible.
	f := newFixture(t)
	a := f.asset(t, "DG-11", nil)
	_, found, err := f.repo.LatestRuntime(ctx(), f.scope, a.ID)
	ok(t, err)
	if found {
		t.Fatal("a machine nobody has read has no latest reading")
	}
}

func TestTheDatabaseInsistsARuntimeReadingNamesItsSource(t *testing.T) {
	f := newFixture(t)
	a := f.asset(t, "DG-12", nil)
	f.mustFail(t, "an_automated_runtime_reading_names_its_source", `
		INSERT INTO facilities.runtime_reading (id, tenant_id, asset_id,
			hours, read_at, source, recorded_by)
		VALUES ($1, $2, $3, 100, now(), 'scada', 'u')`,
		uuid.New(), f.tenantID, uuid.MustParse(a.ID))
}

// ------------------------------------- utility metering (SRS-FAC-009)

func (f fixture) meter(t *testing.T, code string,
	mutate func(*domain.Meter)) domain.Meter {

	t.Helper()
	m := domain.Meter{
		ID: uuid.NewString(), TenantID: f.tenantID,
		Code: code, Name: "LV panel 1",
		Utility: domain.UtilityElectricity, Unit: "kWh",
		Source: domain.SourceAMI, SourceRef: "ami:00291",
		Cumulative: true, RegisterMax: 99999, Active: true,
		CreatedAt: at, CreatedBy: "u-est",
	}
	if mutate != nil {
		mutate(&m)
	}
	ok(t, f.repo.InsertMeter(ctx(), f.scope, m))
	return m
}

func TestAMeterReadingKeepsItsOwnProvenance(t *testing.T) {
	// SRS-FAC-009's acceptance. The reading's source rather than the
	// meter's, because the night the gateway was down somebody read the
	// dial and the figure is worth less.
	f := newFixture(t)
	m := f.meter(t, "LV-MAIN-1", nil)

	automated, err := domain.RecordReading(uuid.NewString(), f.tenantID, m,
		41000, at, domain.SourceAMI, "ami:00291", false, "", "u-gw", at)
	ok(t, err)
	ok(t, f.repo.InsertReading(ctx(), f.scope, automated))

	typed, err := domain.RecordReading(uuid.NewString(), f.tenantID, m,
		41500, at.Add(12*time.Hour), domain.SourceManual, "", false,
		"gateway offline", "u-fitter", at.Add(13*time.Hour))
	ok(t, err)
	ok(t, f.repo.InsertReading(ctx(), f.scope, typed))

	got, err := f.repo.Readings(ctx(), f.scope, m.ID,
		time.Time{}, time.Time{}, 0)
	ok(t, err)
	if len(got) != 2 {
		t.Fatalf("both readings, got %d", len(got))
	}
	if got[0].Source != domain.SourceAMI ||
		got[1].Source != domain.SourceManual {
		t.Fatalf("each reading keeps its own source: %+v", got)
	}

	back, err := f.repo.Meter(ctx(), f.scope, m.ID)
	ok(t, err)
	consumption, isOK := domain.Consume(back, got, at.Add(-time.Hour),
		at.Add(24*time.Hour))
	if !isOK || consumption.Quantity != 500 {
		t.Fatalf("500 kWh between the readings: %+v", consumption)
	}
	if !consumption.Estimated {
		// One typed reading makes the whole figure an estimate, and
		// the command centre is entitled to know that.
		t.Fatalf("a hand-read figure is an estimate: %+v", consumption)
	}
	if consumption.Unit != "kWh" || consumption.MeterID != m.ID {
		t.Fatalf("the figure names its meter and unit: %+v", consumption)
	}
}

func TestTheDatabaseInsistsAnAutomatedReadingNamesItsSource(t *testing.T) {
	f := newFixture(t)
	m := f.meter(t, "LV-MAIN-2", nil)
	f.mustFail(t, "an_automated_reading_names_its_source", `
		INSERT INTO facilities.meter_reading (id, tenant_id, meter_id,
			value, read_at, source, recorded_by)
		VALUES ($1, $2, $3, 100, now(), 'ami', 'u-gw')`,
		uuid.New(), f.tenantID, uuid.MustParse(m.ID))
}

func TestTheDatabaseInsistsOnlyACumulativeMeterWraps(t *testing.T) {
	f := newFixture(t)
	f.mustFail(t, "only_a_cumulative_meter_wraps", `
		INSERT INTO facilities.meter (id, tenant_id, code, utility,
			unit, source, source_ref, cumulative, register_max,
			created_by)
		VALUES ($1, $2, 'VIE-1', 'oxygen', 'bar', 'scada',
			'scada:VIE1', false, 99999, 'u')`,
		uuid.New(), f.tenantID)
}

func TestTheDatabaseInsistsAMeterDeclaresItsUnit(t *testing.T) {
	f := newFixture(t)
	f.mustFail(t, "a_meter_declares_its_unit", `
		INSERT INTO facilities.meter (id, tenant_id, code, utility,
			unit, source, created_by)
		VALUES ($1, $2, 'W-1', 'water', '', 'manual', 'u')`,
		uuid.New(), f.tenantID)
}

// ------------------------------------- planned outages (SRS-FAC-004)

func (f fixture) outage(t *testing.T, reference string,
	system domain.System) (domain.Outage, []domain.OutageArea) {

	t.Helper()
	o, err := domain.PlanOutage(uuid.NewString(), f.tenantID,
		domain.PlanOutageInput{
			Reference: reference, System: system,
			Title:       "Panel maintenance shutdown",
			Reason:      "hot joint on the busbar",
			PlannedFrom: at.AddDate(0, 0, 7),
			PlannedTo:   at.AddDate(0, 0, 7).Add(4 * time.Hour),
			Contingency: "ward 5 on the UPS ring",
		}, "u-est", at)
	ok(t, err)
	ok(t, f.repo.InsertOutage(ctx(), f.scope, o))

	theatre, err := domain.AddArea(uuid.NewString(), o, uuid.NewString(),
		"Theatres", true, at)
	ok(t, err)
	ok(t, f.repo.InsertArea(ctx(), f.scope, theatre))
	return o, []domain.OutageArea{theatre}
}

func TestAnOutageAndItsAreasSurviveTheRoundTrip(t *testing.T) {
	f := newFixture(t)
	o, areas := f.outage(t, "SD-3001", domain.SystemElectrical)

	got, err := f.repo.Outage(ctx(), f.scope, o.ID)
	ok(t, err)
	if got.Contingency == "" || got.Reason == "" {
		// The contingency is what the critical areas fall back on, and
		// the reason is what a ward asks about when it objects.
		t.Fatalf("contingency and reason must survive: %+v", got)
	}
	if !got.PlannedFrom.Equal(o.PlannedFrom) {
		t.Fatalf("the window must survive: %+v", got)
	}

	back, err := f.repo.Areas(ctx(), f.scope, o.ID)
	ok(t, err)
	if len(back) != 1 || !back[0].Critical {
		t.Fatalf("the critical mark must survive: %+v", back)
	}
	if back[0].OutageState != domain.OutagePlanned ||
		back[0].OutageSystem != domain.SystemElectrical {
		t.Fatalf("the area carries the outage's system and state: %+v",
			back[0])
	}
	_ = areas
}

func TestTakingAnOutageIntoEffectReachesItsAreas(t *testing.T) {
	// The third composite key, and the cascade it exists for. Without
	// the area rows following the outage, the "one live shutdown per
	// department" index below would never see a state change.
	f := newFixture(t)
	o, areas := f.outage(t, "SD-3002", domain.SystemElectrical)

	ok(t, o.Approve(areas, "PTW-12", "u-manager", at))
	ok(t, f.repo.UpdateOutage(ctx(), f.scope, o, 1))

	current, err := f.repo.Areas(ctx(), f.scope, o.ID)
	ok(t, err)
	if current[0].OutageState != domain.OutageApproved {
		t.Fatalf("the area must have followed the outage: %+v", current[0])
	}
}

func TestAnAreaCannotDisagreeWithItsOutage(t *testing.T) {
	f := newFixture(t)
	o, _ := f.outage(t, "SD-3003", domain.SystemElectrical)

	f.mustFail(t, "outage_area_outage_fk", `
		INSERT INTO facilities.outage_area (id, tenant_id, outage_id,
			name, outage_system, outage_state)
		VALUES ($1, $2, $3, 'Sneaky ward', 'hvac', 'in_effect')`,
		uuid.New(), f.tenantID, uuid.MustParse(o.ID))
}

func TestTwoShutdownsOfOneSystemCannotCoverOneDepartment(t *testing.T) {
	// The rule the denormalised columns buy. Two live isolations of the
	// same supply over one ward is a ward that gets its power back
	// because the first permit was signed off while the second was still
	// open.
	f := newFixture(t)
	orgUnit := uuid.NewString()

	first := f.liveOutage(t, "SD-3004", orgUnit)
	_ = first

	second, err := domain.PlanOutage(uuid.NewString(), f.tenantID,
		domain.PlanOutageInput{
			Reference: "SD-3005", System: domain.SystemElectrical,
			Title: "Second isolation", Reason: "same busbar",
			PlannedFrom: at.AddDate(0, 0, 7),
			PlannedTo:   at.AddDate(0, 0, 7).Add(time.Hour),
			Contingency: "none",
		}, "u-est", at)
	ok(t, err)
	ok(t, f.repo.InsertOutage(ctx(), f.scope, second))
	area, err := domain.AddArea(uuid.NewString(), second, orgUnit,
		"Theatres", true, at)
	ok(t, err)
	ok(t, f.repo.InsertArea(ctx(), f.scope, area))

	areas := []domain.OutageArea{area}
	ok(t, second.Approve(areas, "PTW-13", "u-manager", at))
	ok(t, f.repo.UpdateOutage(ctx(), f.scope, second, 1))
	ok(t, areas[0].Notify(at))
	ok(t, areas[0].Acknowledge("u-ot", "", at))
	ok(t, f.repo.UpdateArea(ctx(), f.scope, areas[0], 1))
	ok(t, second.TakeEffect(areas, at))

	err = f.repo.UpdateOutage(ctx(), f.scope, second, 2)
	if err == nil ||
		!strings.Contains(err.Error(), "FAC_AREA_ALREADY_SHUT_DOWN") {
		t.Fatalf("want a named refusal, got %v", err)
	}
}

// liveOutage drives one shutdown all the way to in_effect over an org unit.
func (f fixture) liveOutage(t *testing.T, reference,
	orgUnitID string) domain.Outage {

	t.Helper()
	o, err := domain.PlanOutage(uuid.NewString(), f.tenantID,
		domain.PlanOutageInput{
			Reference: reference, System: domain.SystemElectrical,
			Title: "First isolation", Reason: "hot joint",
			PlannedFrom: at.AddDate(0, 0, 7),
			PlannedTo:   at.AddDate(0, 0, 7).Add(4 * time.Hour),
			Contingency: "theatre list moved",
		}, "u-est", at)
	ok(t, err)
	ok(t, f.repo.InsertOutage(ctx(), f.scope, o))

	area, err := domain.AddArea(uuid.NewString(), o, orgUnitID,
		"Theatres", true, at)
	ok(t, err)
	ok(t, f.repo.InsertArea(ctx(), f.scope, area))

	areas := []domain.OutageArea{area}
	ok(t, o.Approve(areas, "PTW-12", "u-manager", at))
	ok(t, f.repo.UpdateOutage(ctx(), f.scope, o, 1))
	ok(t, areas[0].Notify(at))
	ok(t, areas[0].Acknowledge("u-ot", "", at))
	ok(t, f.repo.UpdateArea(ctx(), f.scope, areas[0], 1))
	ok(t, o.TakeEffect(areas, at))
	ok(t, f.repo.UpdateOutage(ctx(), f.scope, o, 2))
	return o
}

func TestAnAcknowledgementCannotPrecedeItsNotice(t *testing.T) {
	// Otherwise a row makes an unnotified outage look consulted.
	f := newFixture(t)
	o, _ := f.outage(t, "SD-3006", domain.SystemElectrical)
	areas, err := f.repo.Areas(ctx(), f.scope, o.ID)
	ok(t, err)

	f.mustFail(t, "an_acknowledgement_follows_a_notice", `
		UPDATE facilities.outage_area
		SET acknowledged_at = now(), acknowledged_by = 'u-ot'
		WHERE id = $1`, uuid.MustParse(areas[0].ID))
}

func TestALifeSafetyShutdownCannotBeApprovedWithoutAPermit(t *testing.T) {
	f := newFixture(t)
	o, _ := f.outage(t, "SD-3007", domain.SystemMedicalGas)

	f.mustFail(t, "a_life_safety_shutdown_names_its_permit", `
		UPDATE facilities.outage
		SET state = 'approved', approved_by = 'u-manager',
		    approved_at = now()
		WHERE id = $1`, uuid.MustParse(o.ID))
}

func TestAnOutageIsNotApprovedByWhoeverAskedForIt(t *testing.T) {
	f := newFixture(t)
	o, _ := f.outage(t, "SD-3008", domain.SystemElectrical)

	f.mustFail(t, "an_outage_is_not_approved_by_whoever_asked_for_it", `
		UPDATE facilities.outage
		SET state = 'approved', approved_by = 'u-est', approved_at = now()
		WHERE id = $1`, uuid.MustParse(o.ID))
}

// ---------------------------------------- SCADA alarms (SRS-FAC-005)

func (f fixture) alarm(t *testing.T, externalID string) domain.Alarm {
	t.Helper()
	a, err := domain.Ingest(uuid.NewString(), f.tenantID,
		domain.IngestInput{
			GatewayID: "gw-plant-1", PointRef: "MGP.VIE1.LowPressure",
			ExternalID: externalID, FacilityID: uuid.NewString(),
			System:   domain.SystemMedicalGas,
			Severity: domain.SeverityCritical,
			Message:  "VIE 1 low pressure alarm",
			Source:   domain.SourceSCADA, RaisedAt: at.Add(-5 * time.Minute),
		}, at)
	ok(t, err)
	ok(t, f.repo.InsertAlarm(ctx(), f.scope, a))
	return a
}

func TestAGatewayReplayDoesNotProduceASecondAlarm(t *testing.T) {
	// A gateway reconnecting after a network drop resends everything it
	// buffered, and a duplicated critical gas alarm is a second call-out
	// for an event that happened once.
	f := newFixture(t)
	first := f.alarm(t, "evt-99120")

	found, exists, err := f.repo.AlarmByEvent(ctx(), f.scope,
		"gw-plant-1", "evt-99120")
	ok(t, err)
	if !exists || found.ID != first.ID {
		t.Fatalf("the replay must be recognised: %+v", found)
	}

	replay, err := domain.Ingest(uuid.NewString(), f.tenantID,
		domain.IngestInput{
			GatewayID: "gw-plant-1", PointRef: "MGP.VIE1.LowPressure",
			ExternalID: "evt-99120", System: domain.SystemMedicalGas,
			Severity: domain.SeverityCritical, Message: "replayed",
			Source: domain.SourceSCADA, RaisedAt: at,
		}, at)
	ok(t, err)
	err = f.repo.InsertAlarm(ctx(), f.scope, replay)
	if err == nil ||
		!strings.Contains(err.Error(), "FAC_ALARM_ALREADY_SEEN") {
		t.Fatalf("want a named refusal, got %v", err)
	}

	// And an event the gateway has not sent before is simply new.
	_, exists, err = f.repo.AlarmByEvent(ctx(), f.scope,
		"gw-plant-1", "evt-99121")
	ok(t, err)
	if exists {
		t.Fatal("an unseen event is new, not an error")
	}
}

func TestAnAlarmAndItsWorkOrderStayDistinctInTheDatabase(t *testing.T) {
	// SRS-FAC-005's acceptance below the adapter: closing the work does
	// not touch the alarm row, and clearing the alarm does not touch the
	// order. Neither table has a column that could carry the other's
	// lifecycle, so this holds against any writer.
	f := newFixture(t)
	class := f.workClass(t, "gas_work", false, false)
	w := f.workOrder(t, "WO-4001", class, nil)
	alarm := f.alarm(t, "evt-99130")

	ok(t, alarm.LinkWork(w.ID, "u-est", at))
	ok(t, f.repo.UpdateAlarm(ctx(), f.scope, alarm, 1))

	f.mustExec(t, `UPDATE facilities.work_order
		SET state = 'closed', owner_user_id = 'u-fitter',
		    closed_by = 'u-sup', closed_at = now(),
		    completion_note = 'regulator changed'
		WHERE id = $1`, uuid.MustParse(w.ID))

	stillOpen, err := f.repo.Alarm(ctx(), f.scope, alarm.ID)
	ok(t, err)
	if !stillOpen.Open() {
		t.Fatal("closing the work order must not clear the alarm")
	}
	if stillOpen.WorkOrderID != w.ID {
		t.Fatalf("and the link survives: %+v", stillOpen)
	}

	ok(t, stillOpen.Clear(at.Add(time.Hour)))
	ok(t, f.repo.UpdateAlarm(ctx(), f.scope, stillOpen, 2))

	state := f.scalar(t,
		`SELECT state FROM facilities.work_order WHERE id = $1`,
		uuid.MustParse(w.ID))
	if state != "closed" {
		t.Fatalf("the work order is untouched by the alarm, got %q", state)
	}
}

func TestTheDatabaseRefusesAnAlarmTypedByAPerson(t *testing.T) {
	// Fabricated plant events would go into the record the command
	// centre trusts precisely because it came off the gateway.
	f := newFixture(t)
	f.mustFail(t, "an_alarm_comes_from_plant_not_people", `
		INSERT INTO facilities.alarm (id, tenant_id, gateway_id,
			point_ref, external_id, system, severity, message,
			source, raised_at, state)
		VALUES ($1, $2, 'gw-1', 'p', 'e-1', 'hvac', 'major',
			'made up', 'manual', now(), 'active')`,
		uuid.New(), f.tenantID)
}

func TestAlarmRulesComeBackMostSpecificFirst(t *testing.T) {
	f := newFixture(t)
	facilityID := uuid.NewString()

	ok(t, f.repo.InsertAlarmRule(ctx(), f.scope, uuid.NewString(),
		domain.AlarmRule{
			System:      domain.SystemMedicalGas,
			MinSeverity: domain.SeverityMajor,
			Priority:    domain.PriorityUrgent, ClassCode: "gas_work",
			OwnerTeam: "estates-central", Active: true,
		}, "u-est", at))
	ok(t, f.repo.InsertAlarmRule(ctx(), f.scope, uuid.NewString(),
		domain.AlarmRule{
			FacilityID: facilityID, System: domain.SystemMedicalGas,
			MinSeverity: domain.SeverityMajor,
			Priority:    domain.PriorityEmergency, ClassCode: "gas_work",
			OwnerTeam: "estates-gas", Active: true,
		}, "u-est", at))

	rules, err := f.repo.AlarmRules(ctx(), f.scope, domain.SystemMedicalGas)
	ok(t, err)
	if len(rules) != 2 {
		t.Fatalf("both rules, got %d", len(rules))
	}

	alarm := f.alarm(t, "evt-99140")
	alarm.FacilityID = facilityID
	got, found := domain.RuleFor(rules, alarm)
	if !found || got.OwnerTeam != "estates-gas" {
		t.Fatalf("the facility's own rule wins: %+v", got)
	}
}

// ------------------------- fire and life safety (SRS-FAC-008)

func (f fixture) deficiency(t *testing.T, severity domain.Severity,
	workOrderID string) domain.Deficiency {

	t.Helper()
	in := domain.RaiseDeficiencyInput{
		LocationNote: "stair core B, level 3",
		System:       domain.SystemFire, Severity: severity,
		Finding:  "fire door wedged open, self-closer disconnected",
		Standard: "NFPA 101 7.2.1.8",
	}
	if severity == domain.SeverityCritical {
		in.DueAt = at.AddDate(0, 0, 7)
		in.WorkOrderID = workOrderID
	}
	d, err := domain.RaiseDeficiency(uuid.NewString(), f.tenantID, in,
		"u-fire-officer", at)
	ok(t, err)
	ok(t, f.repo.InsertDeficiency(ctx(), f.scope, d))
	return d
}

func TestACriticalDeficiencyStaysVisibleThroughMitigation(t *testing.T) {
	// SRS-FAC-008's acceptance. A fire watch recorded as a fix is how a
	// hospital ends up with a fire watch nobody stands down.
	f := newFixture(t)
	class := f.workClass(t, "general", false, false)
	w := f.workOrder(t, "WO-5001", class, nil)
	d := f.deficiency(t, domain.SeverityCritical, w.ID)

	ok(t, d.Mitigate("fire watch posted on level 3", "u-fire-officer", at))
	ok(t, f.repo.UpdateDeficiency(ctx(), f.scope, d, 1))

	open, err := f.repo.Deficiencies(ctx(), f.scope,
		ports.DeficiencyFilter{OpenOnly: true})
	ok(t, err)
	if len(open) != 1 {
		t.Fatalf("a mitigated finding is still open, got %d", len(open))
	}
	if open[0].State != domain.DeficiencyMitigated ||
		open[0].MitigationNote == "" {
		t.Fatalf("the interim measure must survive: %+v", open[0])
	}
	if open[0].Standard == "" || open[0].WorkOrderID != w.ID {
		// The clause is what turns "the door does not shut" into
		// something the hospital can be held to.
		t.Fatalf("the standard and the work must survive: %+v", open[0])
	}
}

func TestACriticalDeficiencyCannotCloseWithoutEvidence(t *testing.T) {
	f := newFixture(t)
	class := f.workClass(t, "general", false, false)
	w := f.workOrder(t, "WO-5002", class, nil)
	d := f.deficiency(t, domain.SeverityCritical, w.ID)

	f.mustFail(t, "a_critical_deficiency_closes_with_evidence", `
		UPDATE facilities.deficiency
		SET state = 'closed', closed_by = 'u-estates', closed_at = now()
		WHERE id = $1`, uuid.MustParse(d.ID))
}

func TestACriticalDeficiencyIsNotClosedByItsFinder(t *testing.T) {
	f := newFixture(t)
	class := f.workClass(t, "general", false, false)
	w := f.workOrder(t, "WO-5003", class, nil)
	d := f.deficiency(t, domain.SeverityCritical, w.ID)

	f.mustFail(t, "a_critical_deficiency_is_not_closed_by_its_finder", `
		UPDATE facilities.deficiency
		SET state = 'closed', closed_by = 'u-fire-officer',
		    closed_at = now(), closure_evidence_ref = 'photo-1'
		WHERE id = $1`, uuid.MustParse(d.ID))
}

func TestACriticalDeficiencyNeedsWorkAndADate(t *testing.T) {
	f := newFixture(t)
	f.mustFail(t, "a_critical_deficiency_has_work_raised", `
		INSERT INTO facilities.deficiency (id, tenant_id, location_note,
			system, severity, finding, state, raised_at, raised_by,
			due_at)
		VALUES ($1, $2, 'stair B', 'fire', 'critical', 'blocked exit',
			'open', now(), 'u-fire', now() + interval '7 days')`,
		uuid.New(), f.tenantID)
}

func TestAnInfoLevelDeficiencyIsRefused(t *testing.T) {
	// Something is either a breach or an observation.
	f := newFixture(t)
	f.mustFail(t, "a_deficiency_is_at_least_minor", `
		INSERT INTO facilities.deficiency (id, tenant_id, location_note,
			system, severity, finding, state, raised_at, raised_by)
		VALUES ($1, $2, 'stair B', 'fire', 'info', 'looks fine',
			'open', now(), 'u-fire')`,
		uuid.New(), f.tenantID)
}

// ------------------------------- contractor visits (SRS-FAC-011)

func TestAVendorVisitSurvivesTheRoundTrip(t *testing.T) {
	f := newFixture(t)
	class := f.workClass(t, "general", false, false)
	w := f.workOrder(t, "WO-6001", class, nil)

	v, err := domain.SignIn(uuid.NewString(), f.tenantID,
		domain.SignInInput{
			VendorName: "Coolair Services", VendorRef: "PO-2211",
			ContactName: "R Menon",
			Technicians: []string{"S Kumar", "A Das"},
			WorkOrderID: w.ID, Purpose: "quarterly chiller service",
		}, "u-security", at)
	ok(t, err)
	ok(t, f.repo.InsertVisit(ctx(), f.scope, v))

	got, err := f.repo.Visit(ctx(), f.scope, v.ID)
	ok(t, err)
	if len(got.Technicians) != 2 {
		// Losing the names makes the visit unmatched against the gate
		// log and unusable in a roll call.
		t.Fatalf("the technicians must survive: %+v", got)
	}
	if got.WorkOrderID != w.ID || got.VendorRef != "PO-2211" {
		t.Fatalf("the linkage must survive: %+v", got)
	}

	ok(t, got.SignOut(domain.SignOutInput{
		ServiceReportRef: "sr-1",
		ReportSummary:    "compressor 2 replaced",
		PartsUsed:        []string{"compressor CS-220"},
		FollowUp:         "condenser coils before summer",
	}, "u-security", at.Add(4*time.Hour)))
	ok(t, f.repo.UpdateVisit(ctx(), f.scope, got, 1))

	back, err := f.repo.Visit(ctx(), f.scope, v.ID)
	ok(t, err)
	if back.ServiceReportRef == "" || back.FollowUp == "" ||
		len(back.PartsUsed) != 1 {
		t.Fatalf("the report must survive: %+v", back)
	}
}

func TestAVisitMustBeLinkedToSomething(t *testing.T) {
	// SRS-FAC-011's acceptance below the adapter.
	f := newFixture(t)
	f.mustFail(t, "a_visit_is_linked_to_work_an_asset_or_a_task", `
		INSERT INTO facilities.vendor_visit (id, tenant_id, vendor_name,
			technicians, purpose, state, signed_in_at, signed_in_by)
		VALUES ($1, $2, 'Anybody Ltd', ARRAY['S Kumar'], 'looking around',
			'on_site', now(), 'u-security')`,
		uuid.New(), f.tenantID)
}

func TestAVisitMustNameWhoCame(t *testing.T) {
	f := newFixture(t)
	class := f.workClass(t, "general", false, false)
	w := f.workOrder(t, "WO-6002", class, nil)
	f.mustFail(t, "a_visit_names_who_came", `
		INSERT INTO facilities.vendor_visit (id, tenant_id, vendor_name,
			technicians, work_order_id, purpose, state, signed_in_at,
			signed_in_by)
		VALUES ($1, $2, 'Coolair', ARRAY[]::text[], $3, 'service',
			'on_site', now(), 'u-security')`,
		uuid.New(), f.tenantID, uuid.MustParse(w.ID))
}

func TestAVisitCannotDepartWithoutItsServiceReport(t *testing.T) {
	f := newFixture(t)
	class := f.workClass(t, "general", false, false)
	w := f.workOrder(t, "WO-6003", class, nil)
	v, err := domain.SignIn(uuid.NewString(), f.tenantID,
		domain.SignInInput{
			VendorName: "Coolair", Technicians: []string{"S Kumar"},
			WorkOrderID: w.ID, Purpose: "service",
		}, "u-security", at)
	ok(t, err)
	ok(t, f.repo.InsertVisit(ctx(), f.scope, v))

	f.mustFail(t, "a_departed_visit_carries_its_service_report", `
		UPDATE facilities.vendor_visit
		SET state = 'departed', signed_out_at = now(),
		    signed_out_by = 'u-security'
		WHERE id = $1`, uuid.MustParse(v.ID))
}

func TestAContractorOnPermitWorkCarriesTheirInduction(t *testing.T) {
	// SRS-FAC-010 reaching the people least likely to know the building.
	f := newFixture(t)
	class := f.workClass(t, "hv_switching", true, true)
	w := f.workOrder(t, "WO-6004", class, nil)

	f.mustFail(t, "permit_work_names_the_contractors_induction", `
		INSERT INTO facilities.vendor_visit (id, tenant_id, vendor_name,
			technicians, work_order_id, work_requires_permit,
			purpose, state, signed_in_at, signed_in_by)
		VALUES ($1, $2, 'Sparks Ltd', ARRAY['R Rao'], $3, true,
			'switching', 'on_site', now(), 'u-security')`,
		uuid.New(), f.tenantID, uuid.MustParse(w.ID))
}

func TestAVisitCannotClaimSaferWorkThanItsOrder(t *testing.T) {
	// The fourth composite key. Without it a contractor could sign in
	// against permit work with the flag set false and slip past the
	// induction rule.
	f := newFixture(t)
	class := f.workClass(t, "hv_switching", true, true)
	w := f.workOrder(t, "WO-6005", class, nil)

	f.mustFail(t, "vendor_visit_work_order_fk", `
		INSERT INTO facilities.vendor_visit (id, tenant_id, vendor_name,
			technicians, work_order_id, work_requires_permit,
			purpose, state, signed_in_at, signed_in_by)
		VALUES ($1, $2, 'Sparks Ltd', ARRAY['R Rao'], $3, false,
			'switching', 'on_site', now(), 'u-security')`,
		uuid.New(), f.tenantID, uuid.MustParse(w.ID))
}

func TestOnSiteVisitsAreListedForARollCall(t *testing.T) {
	f := newFixture(t)
	class := f.workClass(t, "general", false, false)
	w := f.workOrder(t, "WO-6006", class, nil)

	here, err := domain.SignIn(uuid.NewString(), f.tenantID,
		domain.SignInInput{
			VendorName: "Coolair", Technicians: []string{"S Kumar"},
			WorkOrderID: w.ID, Purpose: "service",
		}, "u-security", at)
	ok(t, err)
	ok(t, f.repo.InsertVisit(ctx(), f.scope, here))

	gone, err := domain.SignIn(uuid.NewString(), f.tenantID,
		domain.SignInInput{
			VendorName: "Liftco", Technicians: []string{"P Nair"},
			WorkOrderID: w.ID, Purpose: "lift service",
		}, "u-security", at.Add(-3*time.Hour))
	ok(t, err)
	ok(t, f.repo.InsertVisit(ctx(), f.scope, gone))
	ok(t, gone.SignOut(domain.SignOutInput{
		ServiceReportRef: "sr-2", ReportSummary: "ropes checked",
	}, "u-security", at))
	ok(t, f.repo.UpdateVisit(ctx(), f.scope, gone, 1))

	onSite, err := f.repo.Visits(ctx(), f.scope,
		ports.VisitFilter{OnSiteOnly: true})
	ok(t, err)
	if len(onSite) != 1 || onSite[0].ID != here.ID {
		t.Fatalf("only the contractor still in the building: %+v", onSite)
	}
}
