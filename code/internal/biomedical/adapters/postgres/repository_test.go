package postgres_test

import (
	"context"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	biopostgres "github.com/ppusapati/health/code/internal/biomedical/adapters/postgres"
	"github.com/ppusapati/health/code/internal/biomedical/domain"
	"github.com/ppusapati/health/code/internal/biomedical/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
)

// The biomedical persistence adapter.
//
// Round-trip tests, because the defect they catch is invisible above the
// adapter: a dropped field reads back as a zero that looks like a decision
// nobody made. A lost ticket kind makes a scheduled service count as a
// failure; a lost capability list takes a working intensifier out of a room; a
// lost calibration date makes a machine that needs one never come due.
//
// Seven of these bypass the adapter and write raw SQL, because the rule under
// test belongs to the database rather than to Go.

var at = time.Date(2026, 9, 19, 10, 0, 0, 0, time.UTC)

type fixture struct {
	pool      *pgxpool.Pool
	assets    biopostgres.AssetRepo
	contracts biopostgres.ContractRepo
	plans     biopostgres.PlanRepo
	tickets   biopostgres.TicketRepo
	notices   biopostgres.NoticeRepo
	telemetry biopostgres.TelemetryRepo
	disposals biopostgres.DisposalRepo

	scope    authctx.TenantScope
	tenantID string
}

func newFixture(t *testing.T) fixture {
	t.Helper()

	pool := pgtest.New(t)
	repo := biopostgres.New(pgtx.NewManager(pool))
	tenantID := uuid.NewString()

	return fixture{
		pool:      pool,
		assets:    biopostgres.AssetRepo{Repository: repo},
		contracts: biopostgres.ContractRepo{Repository: repo},
		plans:     biopostgres.PlanRepo{Repository: repo},
		tickets:   biopostgres.TicketRepo{Repository: repo},
		notices:   biopostgres.NoticeRepo{Repository: repo},
		telemetry: biopostgres.TelemetryRepo{Repository: repo},
		disposals: biopostgres.DisposalRepo{Repository: repo},
		scope: authctx.NewSession(authctx.Session{
			SubjectID: "bme-1", TenantID: tenantID,
		}).TenantScope(),
		tenantID: tenantID,
	}
}

func (f fixture) asset(t *testing.T, in domain.NewAssetInput) domain.Asset {
	t.Helper()
	asset, err := domain.NewAsset(uuid.NewString(), f.tenantID, in, "bme-1", at)
	if err != nil {
		t.Fatalf("NewAsset: %v", err)
	}
	if err := f.assets.InsertAsset(context.Background(), f.scope, asset); err != nil {
		t.Fatalf("InsertAsset: %v", err)
	}
	return asset
}

func (f fixture) intensifier(t *testing.T) domain.Asset {
	return f.asset(t, domain.NewAssetInput{
		Tag: "BME-" + uuid.NewString()[:6], Make: "Siemens",
		Model: "Cios Alpha", Category: "imaging",
		Criticality: domain.CriticalityCritical, LocationID: "theatre-2",
		Capabilities: []string{"image_intensifier"},
	})
}

// SRS-BIO-001, SRS-BIO-009. An asset round-trips with the fields that decide
// whether a room can use it.
func TestAnAssetRoundTripsWithItsCapabilitiesAndCalibration(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	asset := f.asset(t, domain.NewAssetInput{
		Tag: "BME-500", UDI: "(01)0761234", Serial: "SN-9911",
		Make: "Drager", Model: "Primus", Category: "anaesthesia",
		Criticality: domain.CriticalityLifeSupport, LocationID: "theatre-1",
		Department:           "theatres",
		Capabilities:         []string{"anaesthesia_machine", "ventilator"},
		AcquiredOn:           at.AddDate(-3, 0, 0),
		AcquisitionCostMinor: 12_50_000_00, ExpectedLifeYears: 10,
		CalibrationRequired: true, CalibrationDue: at.AddDate(0, 6, 0),
	})

	back, err := f.assets.Asset(ctx, f.scope, asset.ID)
	if err != nil {
		t.Fatalf("Asset: %v", err)
	}
	if len(back.Capabilities) != 2 {
		t.Errorf("capabilities = %v; losing them takes a working machine out "+
			"of a room", back.Capabilities)
	}
	if back.Criticality != domain.CriticalityLifeSupport {
		t.Errorf("criticality = %s", back.Criticality)
	}
	if !back.CalibrationRequired || back.CalibrationDue.IsZero() {
		t.Error("the calibration requirement or its date was lost; the " +
			"machine would never come due")
	}
	if back.AcquisitionCostMinor != 12_50_000_00 {
		t.Errorf("cost = %d", back.AcquisitionCostMinor)
	}

	byTag, found, err := f.assets.AssetByTag(ctx, f.scope, "BME-500")
	if err != nil || !found || byTag.ID != asset.ID {
		t.Fatalf("AssetByTag: %v (found %v)", err, found)
	}
	if _, found, err := f.assets.AssetByTag(ctx, f.scope, "NOTHING"); err != nil || found {
		t.Errorf("an unknown tag reported found=%v err=%v", found, err)
	}
}

// SRS-BIO-001. A tag identifies one machine, and so does a serial within a
// make.
func TestAnAssetTagAndSerialAreEachUsedOnce(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	f.asset(t, domain.NewAssetInput{
		Tag: "BME-600", Make: "Acme", Model: "Vent-9", Serial: "SN-1",
	})

	_, err := f.pool.Exec(ctx, `
		INSERT INTO biomedical.asset (
		    asset_id, tenant_id, tag, make, model, criticality, status,
		    created_at, created_by)
		VALUES ($1, $2, 'BME-600', 'Other', 'Thing', 'routine', 'in_service',
		        now(), 'someone')`, uuid.New(), f.tenantID)
	if err == nil {
		t.Error("two assets share a tag; a service request would name both")
	}

	_, err = f.pool.Exec(ctx, `
		INSERT INTO biomedical.asset (
		    asset_id, tenant_id, tag, make, model, serial, criticality,
		    status, created_at, created_by)
		VALUES ($1, $2, 'BME-601', 'Acme', 'Vent-9', 'SN-1', 'routine',
		        'in_service', now(), 'someone')`, uuid.New(), f.tenantID)
	if err == nil {
		t.Error("two Acme machines share a serial; a recall naming it would " +
			"reach both or neither")
	}

	// Two assets with no serial are fine: most items counted in bulk have
	// none.
	for i := 0; i < 2; i++ {
		f.asset(t, domain.NewAssetInput{
			Tag: "BME-BULK-" + uuid.NewString()[:6], Make: "Acme",
			Model: "Drip stand",
		})
	}
}

// SRS-BIO-001, SRS-BIO-004. The database refuses an asset whose calibration
// requirement and date disagree.
func TestTheDatabaseRefusesACalibrationRequirementWithNoDate(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	_, err := f.pool.Exec(ctx, `
		INSERT INTO biomedical.asset (
		    asset_id, tenant_id, tag, make, model, criticality, status,
		    calibration_required, created_at, created_by)
		VALUES ($1, $2, 'BME-700', 'Fluke', 'ProSim', 'routine', 'in_service',
		        true, now(), 'someone')`, uuid.New(), f.tenantID)
	if err == nil {
		t.Error("an asset requiring calibration was stored with no due date; " +
			"it would never come due")
	}

	_, err = f.pool.Exec(ctx, `
		INSERT INTO biomedical.asset (
		    asset_id, tenant_id, tag, make, model, criticality, status,
		    calibration_due, created_at, created_by)
		VALUES ($1, $2, 'BME-701', 'Fluke', 'ProSim', 'routine', 'in_service',
		        now() + interval '1 year', now(), 'someone')`,
		uuid.New(), f.tenantID)
	if err == nil {
		t.Error("a calibration date was stored on an asset nobody calibrates")
	}

	_, err = f.pool.Exec(ctx, `
		INSERT INTO biomedical.asset (
		    asset_id, tenant_id, tag, make, model, criticality, status,
		    calibration_required, calibration_due, created_at, created_by)
		VALUES ($1, $2, 'BME-702', 'Fluke', 'ProSim', 'routine', 'in_service',
		        true, now() + interval '1 year', now(), 'someone')`,
		uuid.New(), f.tenantID)
	if err != nil {
		t.Fatalf("a consistent calibration record was refused: %v", err)
	}
}

// SRS-BIO-009, SRS-BIO-011. A disposed asset is nowhere, so it stops offering
// capability to the room it stood in.
func TestTheDatabaseRefusesADisposedAssetWithALocation(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	_, err := f.pool.Exec(ctx, `
		INSERT INTO biomedical.asset (
		    asset_id, tenant_id, tag, make, model, criticality, status,
		    location_id, created_at, created_by)
		VALUES ($1, $2, 'BME-800', 'Acme', 'Thing', 'routine', 'disposed',
		        'theatre-2', now(), 'someone')`, uuid.New(), f.tenantID)
	if err == nil {
		t.Error("a disposed asset was left standing in a theatre; the room " +
			"would keep offering its capability after the machine left")
	}

	_, err = f.pool.Exec(ctx, `
		INSERT INTO biomedical.asset (
		    asset_id, tenant_id, tag, make, model, criticality, status,
		    created_at, created_by)
		VALUES ($1, $2, 'BME-801', 'Acme', 'Thing', 'routine', 'disposed',
		        now(), 'someone')`, uuid.New(), f.tenantID)
	if err != nil {
		t.Fatalf("a disposed asset with no location was refused: %v", err)
	}
}

// SRS-BIO-009. A room's assets are readable, and a disposed one is not among
// them.
func TestALocationReadsBackOnlyWhatIsStillThere(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	present := f.intensifier(t)
	gone := f.asset(t, domain.NewAssetInput{
		Tag: "BME-810", Make: "Stryker", Model: "Neptune",
		LocationID: "theatre-2", Capabilities: []string{"laminar_flow"},
	})

	_, disposed, err := domain.Dispose("disp-1", f.tenantID,
		domain.DisposalInput{
			AssetID: gone.ID, Method: "recycler", Reason: "end of life",
			RequestedBy: "bme-1",
		}, gone, "bme-manager-1", at)
	if err != nil {
		t.Fatalf("Dispose: %v", err)
	}
	if err := f.assets.UpdateAsset(
		ctx, f.scope, disposed, gone.Version); err != nil {
		t.Fatalf("UpdateAsset: %v", err)
	}

	here, err := f.assets.AtLocation(ctx, f.scope, "theatre-2", 50)
	if err != nil {
		t.Fatalf("AtLocation: %v", err)
	}
	if len(here) != 1 || here[0].ID != present.ID {
		t.Fatalf("theatre-2 holds %d asset(s), want only the intensifier",
			len(here))
	}

	working := domain.AvailableCapabilities(here, "theatre-2", at, true)
	if working["laminar_flow"] != 0 {
		t.Error("a disposed asset still offered its capability")
	}
	if working["image_intensifier"] != 1 {
		t.Errorf("capabilities = %v, want the intensifier", working)
	}
}

// SRS-BIO-002. A contract round-trips with the SLA hours a ticket's clock is
// derived from.
func TestAContractRoundTripsWithItsSlaHours(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	asset := f.intensifier(t)
	contract, err := domain.NewServiceContract(uuid.NewString(), f.tenantID,
		domain.NewContractInput{
			AssetID: asset.ID, Kind: domain.ContractCMC, Reference: "CMC-77",
			VendorName: "Siemens Healthineers", VendorPhone: "+91-80-1234",
			StartsOn: at.AddDate(-1, 0, 0), EndsOn: at.AddDate(0, 0, 10),
			ValueMinor: 4_00_000_00, ResponseHours: 4, ResolutionHours: 24,
		}, "bme-1", at)
	if err != nil {
		t.Fatalf("NewServiceContract: %v", err)
	}
	if err := f.contracts.InsertContract(ctx, f.scope, contract); err != nil {
		t.Fatalf("InsertContract: %v", err)
	}

	back, err := f.contracts.Contract(ctx, f.scope, contract.ID)
	if err != nil {
		t.Fatalf("Contract: %v", err)
	}
	if back.ResponseHours != 4 || back.ResolutionHours != 24 {
		t.Errorf("SLA hours = %d/%d, want 4/24; losing them makes a ticket's "+
			"clock a number somebody typed", back.ResponseHours,
			back.ResolutionHours)
	}
	if !back.Kind.CoversParts() {
		t.Error("a CMC read back as not covering parts")
	}

	expiring, err := f.contracts.ExpiringBefore(
		ctx, f.scope, at.AddDate(0, 0, 30), 50)
	if err != nil {
		t.Fatalf("ExpiringBefore: %v", err)
	}
	if len(expiring) != 1 {
		t.Errorf("expiring = %d, want 1", len(expiring))
	}

	// A contract ending before it starts is refused by the database.
	_, err = f.pool.Exec(ctx, `
		INSERT INTO biomedical.service_contract (
		    contract_id, tenant_id, asset_id, kind, vendor_name,
		    starts_on, ends_on, created_at, created_by)
		VALUES ($1, $2, $3, 'amc', 'Acme',
		        now(), now() - interval '1 day', now(), 'someone')`,
		uuid.New(), f.tenantID, asset.ID)
	if err == nil {
		t.Error("a contract that ends before it starts was stored")
	}
}

// SRS-BIO-003. A plan whose basis has no interval never comes due.
func TestTheDatabaseRefusesAPlanWithNoIntervalForItsBasis(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	asset := f.intensifier(t)

	for _, tc := range []struct {
		name         string
		basis        string
		intervalDays int
		runtimeHours int
	}{
		{"interval plan with no days", "interval", 0, 500},
		{"runtime plan with no hours", "runtime", 90, 0},
		{"risk plan with no days", "risk", 0, 0},
	} {
		_, err := f.pool.Exec(ctx, `
			INSERT INTO biomedical.pm_plan (
			    plan_id, tenant_id, asset_id, basis, interval_days,
			    runtime_hours, procedure, last_performed_at, created_at,
			    created_by)
			VALUES ($1, $2, $3, $4, $5, $6, 'service it', now(), now(),
			        'someone')`,
			uuid.New(), f.tenantID, asset.ID, tc.basis, tc.intervalDays,
			tc.runtimeHours)
		if err == nil {
			t.Errorf("%s was stored; it would never come due", tc.name)
		}
	}

	plan, err := domain.NewPMPlan(uuid.NewString(), f.tenantID,
		domain.NewPlanInput{
			AssetID: asset.ID, Basis: domain.BasisInterval, IntervalDays: 90,
			Procedure:        "electrical safety and image quality",
			EstimatedMinutes: 120, LastPerformedAt: at.AddDate(0, 0, -100),
		}, "bme-1", at)
	if err != nil {
		t.Fatalf("NewPMPlan: %v", err)
	}
	if err := f.plans.InsertPlan(ctx, f.scope, plan); err != nil {
		t.Fatalf("InsertPlan: %v", err)
	}

	back, err := f.plans.Plan(ctx, f.scope, plan.ID)
	if err != nil {
		t.Fatalf("Plan: %v", err)
	}
	if back.IntervalDays != 90 || back.Procedure == "" {
		t.Errorf("plan = %+v", back)
	}
	if back.LastPerformedAt.IsZero() {
		t.Error("the baseline was lost; every due date would be wrong")
	}
}

// SRS-BIO-006, SRS-BIO-007. A ticket round-trips with the fields the metrics
// are computed from.
func TestATicketRoundTripsWithItsKindPartsAndDowntime(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	asset := f.intensifier(t)
	tkt, err := domain.RaiseTicket(uuid.NewString(), f.tenantID,
		domain.NewTicketInput{
			Number: "TKT-001", Kind: domain.KindCorrective,
			Symptom: "image drifts", Priority: domain.PriorityHigh,
			Impact: domain.ImpactServiceStopped, DownFrom: at.AddDate(0, 0, -1),
		}, asset, domain.SLA{ResponseHours: 4, ResolutionHours: 24}, "nurse-1", at)
	if err != nil {
		t.Fatalf("RaiseTicket: %v", err)
	}
	if err := f.tickets.InsertTicket(ctx, f.scope, tkt); err != nil {
		t.Fatalf("InsertTicket: %v", err)
	}

	if err := tkt.Assign("engineer-1", at.Add(time.Hour)); err != nil {
		t.Fatalf("Assign: %v", err)
	}
	if err := tkt.Resolve(domain.ResolveInput{
		Diagnosis: "detector board", WorkPerformed: "replaced and verified",
		Parts: []domain.PartUsed{{
			Code: "DET-77", Description: "detector board", Quantity: 1,
			CoveredByContract: true,
		}},
		BackInServiceAt: at.Add(2 * time.Hour),
	}, "engineer-1", at.Add(2*time.Hour)); err != nil {
		t.Fatalf("Resolve: %v", err)
	}
	if err := tkt.Close("bme-manager-1", "verified", at.Add(3*time.Hour)); err != nil {
		t.Fatalf("Close: %v", err)
	}
	if err := f.tickets.UpdateTicket(ctx, f.scope, tkt, tkt.Version); err != nil {
		t.Fatalf("UpdateTicket: %v", err)
	}

	back, err := f.tickets.Ticket(ctx, f.scope, tkt.ID)
	if err != nil {
		t.Fatalf("Ticket: %v", err)
	}
	if back.Kind != domain.KindCorrective {
		t.Errorf("kind = %s; losing it makes a scheduled service count as a "+
			"failure", back.Kind)
	}
	if len(back.Parts) != 1 || !back.Parts[0].CoveredByContract {
		t.Errorf("parts = %+v; the contract-covered flag is what a renewal "+
			"is argued with", back.Parts)
	}
	if back.DownFrom.IsZero() || back.DownUntil.IsZero() {
		t.Error("the outage bounds were lost; uptime would be unmeasurable")
	}
	if back.ClosedBy != "bme-manager-1" {
		t.Errorf("closed by %q, want the validator", back.ClosedBy)
	}

	// A stale write loses.
	if err := f.tickets.UpdateTicket(
		ctx, f.scope, tkt, tkt.Version); err != ports.ErrVersionConflict {
		t.Errorf("a stale write returned %v, want a version conflict", err)
	}
}

// SRS-BIO-006. The database refuses a repair validated by the engineer who
// made it.
func TestTheDatabaseRefusesASelfValidatedRepair(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	asset := f.intensifier(t)
	_, err := f.pool.Exec(ctx, `
		INSERT INTO biomedical.ticket (
		    ticket_id, tenant_id, kind, asset_id, symptom, priority, impact,
		    state, owner_id, diagnosis, work_performed, closed_by, closed_at,
		    raised_at, raised_by)
		VALUES ($1, $2, 'corrective', $3, 'broken', 'normal', 'none',
		        'closed', 'engineer-1', 'found', 'fixed', 'engineer-1',
		        now(), now(), 'nurse-1')`,
		uuid.New(), f.tenantID, asset.ID)
	if err == nil {
		t.Fatal("a repair was validated by the engineer who made it; that is " +
			"the same claim twice, not a validation")
	}

	_, err = f.pool.Exec(ctx, `
		INSERT INTO biomedical.ticket (
		    ticket_id, tenant_id, kind, asset_id, symptom, priority, impact,
		    state, owner_id, diagnosis, work_performed, closed_by, closed_at,
		    raised_at, raised_by)
		VALUES ($1, $2, 'corrective', $3, 'broken', 'normal', 'none',
		        'closed', 'engineer-1', 'found', 'fixed', 'bme-manager-1',
		        now(), now(), 'nurse-1')`,
		uuid.New(), f.tenantID, asset.ID)
	if err != nil {
		t.Fatalf("a repair validated by somebody else was refused: %v", err)
	}
}

// SRS-BIO-007. The database refuses preventive work that names no plan.
func TestTheDatabaseRefusesPreventiveWorkWithNoPlan(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	asset := f.intensifier(t)
	_, err := f.pool.Exec(ctx, `
		INSERT INTO biomedical.ticket (
		    ticket_id, tenant_id, kind, asset_id, symptom, priority, impact,
		    state, raised_at, raised_by)
		VALUES ($1, $2, 'preventive', $3, 'service', 'normal', 'none',
		        'open', now(), 'bme-1')`,
		uuid.New(), f.tenantID, asset.ID)
	if err == nil {
		t.Fatal("preventive work was stored against no plan; PM compliance " +
			"would be whatever anybody labelled preventive")
	}

	plan, err := domain.NewPMPlan(uuid.NewString(), f.tenantID,
		domain.NewPlanInput{
			AssetID: asset.ID, Basis: domain.BasisInterval, IntervalDays: 90,
			Procedure: "service",
		}, "bme-1", at)
	if err != nil {
		t.Fatalf("NewPMPlan: %v", err)
	}
	if err := f.plans.InsertPlan(ctx, f.scope, plan); err != nil {
		t.Fatalf("InsertPlan: %v", err)
	}

	_, err = f.pool.Exec(ctx, `
		INSERT INTO biomedical.ticket (
		    ticket_id, tenant_id, kind, asset_id, plan_id, symptom, priority,
		    impact, state, raised_at, raised_by)
		VALUES ($1, $2, 'preventive', $3, $4, 'service', 'normal', 'none',
		        'open', now(), 'bme-1')`,
		uuid.New(), f.tenantID, asset.ID, plan.ID)
	if err != nil {
		t.Fatalf("preventive work naming its plan was refused: %v", err)
	}
}

// SRS-BIO-008. A notice's tasks are one per asset, and the database holds it.
func TestANoticeHasOneTaskPerAsset(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	first := f.asset(t, domain.NewAssetInput{
		Tag: "BME-900", Make: "Acme", Model: "Vent-9", LocationID: "icu-1",
	})
	second := f.asset(t, domain.NewAssetInput{
		Tag: "BME-901", Make: "Acme", Model: "Vent-9", LocationID: "icu-2",
	})

	notice, err := domain.NewSafetyNotice(uuid.NewString(), f.tenantID,
		domain.NewNoticeInput{
			Reference: "FSN-2026-99", Kind: domain.NoticeRecall,
			Issuer: "Acme", Summary: "valve may stick",
			Make: "Acme", Model: "Vent-9",
			RequiredAction: "inspect and replace",
			DueBy:          at.AddDate(0, 0, 14),
		}, "bme-1", at)
	if err != nil {
		t.Fatalf("NewSafetyNotice: %v", err)
	}
	if err := f.notices.InsertNotice(ctx, f.scope, notice); err != nil {
		t.Fatalf("InsertNotice: %v", err)
	}

	tasks := notice.Match([]domain.Asset{first, second}, uuid.NewString)
	if err := f.notices.InsertTasks(ctx, f.scope, tasks); err != nil {
		t.Fatalf("InsertTasks: %v", err)
	}

	// A second task for the same asset would report the recall as further
	// along than it is.
	_, err = f.pool.Exec(ctx, `
		INSERT INTO biomedical.notice_task (
		    task_id, tenant_id, notice_id, asset_id, state)
		VALUES ($1, $2, $3, $4, 'outstanding')`,
		uuid.New(), f.tenantID, notice.ID, first.ID)
	if err == nil {
		t.Error("one asset got two tasks under one notice")
	}

	// "Not affected" with no reason is refused by the database too.
	_, err = f.pool.Exec(ctx, `
		UPDATE biomedical.notice_task
		SET state = 'not_affected', completed_at = now(), completed_by = 'x'
		WHERE task_id = $1`, tasks[0].ID)
	if err == nil {
		t.Error("an asset was declared unaffected with no reason")
	}

	back, err := f.notices.Tasks(ctx, f.scope, notice.ID)
	if err != nil {
		t.Fatalf("Tasks: %v", err)
	}
	if len(back) != 2 {
		t.Fatalf("tasks = %d, want 2", len(back))
	}

	progress := domain.Track(notice, back, at)
	if progress.Outstanding != 2 {
		t.Errorf("progress = %+v, want two outstanding", progress)
	}

	candidates, err := f.assets.ByMake(ctx, f.scope, "Acme", "", 50)
	if err != nil {
		t.Fatalf("ByMake: %v", err)
	}
	if len(candidates) != 2 {
		t.Errorf("ByMake found %d, want 2", len(candidates))
	}
}

// SRS-BIO-010. Telemetry round-trips and the latest is by observation.
func TestTelemetryRoundTripsAndTheLatestIsByObservation(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	asset := f.intensifier(t)
	newest, err := domain.NewReading(uuid.NewString(), f.tenantID,
		domain.NewReadingInput{
			AssetID: asset.ID, Metric: domain.MetricRuntimeHours,
			Value: 4200, Unit: "h", Source: "gateway-1", Ingested: true,
			ObservedAt: at.Add(-time.Hour),
		}, "ingest", at)
	if err != nil {
		t.Fatalf("NewReading: %v", err)
	}
	stale, err := domain.NewReading(uuid.NewString(), f.tenantID,
		domain.NewReadingInput{
			AssetID: asset.ID, Metric: domain.MetricRuntimeHours,
			Value: 4100, Unit: "h", ObservedAt: at.Add(-24 * time.Hour),
		}, "ingest", at.Add(time.Minute))
	if err != nil {
		t.Fatalf("NewReading: %v", err)
	}

	// Inserted stale-first, as a backlog flush would.
	if err := f.telemetry.AppendReadings(
		ctx, f.scope, []domain.Reading{stale, newest}); err != nil {
		t.Fatalf("AppendReadings: %v", err)
	}

	latest, err := f.telemetry.LatestByMetric(
		ctx, f.scope, domain.MetricRuntimeHours)
	if err != nil {
		t.Fatalf("LatestByMetric: %v", err)
	}
	if len(latest) != 1 {
		t.Fatalf("latest = %d rows, want one per asset", len(latest))
	}
	if latest[0].Value != 4200 {
		t.Errorf("latest = %v, want 4200; a backlog flushing after an outage "+
			"arrives out of order", latest[0].Value)
	}
	if !latest[0].Ingested {
		t.Error("the ingested flag was lost; a hand-typed reading and a " +
			"device's are evidence of different weight")
	}

	byAsset, err := f.telemetry.Readings(ctx, f.scope, asset.ID,
		domain.MetricRuntimeHours, at.AddDate(0, 0, -2), at.AddDate(0, 0, 1), 50)
	if err != nil {
		t.Fatalf("Readings: %v", err)
	}
	if len(byAsset) != 2 {
		t.Errorf("readings = %d, want 2", len(byAsset))
	}
}

// SRS-BIO-011. An asset is disposed of once, and the evidence is required.
func TestADisposalHappensOnceAndCarriesItsEvidence(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	asset := f.asset(t, domain.NewAssetInput{
		Tag: "BME-950", Make: "GE", Model: "Carescape",
		LocationID: "icu-1",
	})

	disposal, disposed, err := domain.Dispose(uuid.NewString(), f.tenantID,
		domain.DisposalInput{
			AssetID: asset.ID, Method: "certified recycler",
			Reason: "end of life", RequestedBy: "bme-1",
			SanitisationRequired:    true,
			SanitisationMethod:      "NIST 800-88 purge",
			SanitisationCertificate: "CERT-4411",
			SanitisedBy:             "it-sec-1",
			Recipient:               "GreenTech",
		}, asset, "bme-manager-1", at)
	if err != nil {
		t.Fatalf("Dispose: %v", err)
	}
	if err := f.disposals.InsertDisposal(ctx, f.scope, disposal); err != nil {
		t.Fatalf("InsertDisposal: %v", err)
	}
	if err := f.assets.UpdateAsset(
		ctx, f.scope, disposed, asset.Version); err != nil {
		t.Fatalf("UpdateAsset: %v", err)
	}

	// A second disposal row for the same asset is refused.
	second := disposal
	second.ID = uuid.NewString()
	if err := f.disposals.InsertDisposal(ctx, f.scope, second); err == nil {
		t.Error("an asset was disposed of twice")
	}

	// Sanitisation without evidence is refused by the database.
	other := f.asset(t, domain.NewAssetInput{
		Tag: "BME-951", Make: "GE", Model: "Carescape",
	})
	_, err = f.pool.Exec(ctx, `
		INSERT INTO biomedical.disposal (
		    disposal_id, tenant_id, asset_id, method, reason, approved_by,
		    approved_at, sanitisation_required, disposed_at, recorded_by)
		VALUES ($1, $2, $3, 'skip', 'obsolete', 'manager', now(), true,
		        now(), 'manager')`,
		uuid.New(), f.tenantID, other.ID)
	if err == nil {
		t.Error("a disposal claiming sanitisation stored no evidence; the " +
			"machine is a hard drive in a skip")
	}

	// And an approval by the requester is refused.
	_, err = f.pool.Exec(ctx, `
		INSERT INTO biomedical.disposal (
		    disposal_id, tenant_id, asset_id, method, reason, requested_by,
		    approved_by, approved_at, disposed_at, recorded_by)
		VALUES ($1, $2, $3, 'skip', 'obsolete', 'bme-1', 'bme-1', now(),
		        now(), 'bme-1')`,
		uuid.New(), f.tenantID, other.ID)
	if err == nil {
		t.Error("a disposal was approved by the person who requested it")
	}

	back, err := f.disposals.Disposal(ctx, f.scope, asset.ID)
	if err != nil {
		t.Fatalf("Disposal: %v", err)
	}
	if back.SanitisationCertificate != "CERT-4411" {
		t.Errorf("certificate = %q; it is what an inspection checks",
			back.SanitisationCertificate)
	}
}

// Gate A2. Another tenant's scope reaches none of it.
func TestAnotherTenantReachesNoEquipment(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	asset := f.intensifier(t)
	intruder := authctx.NewSession(authctx.Session{
		SubjectID: "bme-2", TenantID: uuid.NewString(),
	}).TenantScope()

	if _, err := f.assets.Asset(ctx, intruder, asset.ID); err == nil {
		t.Error("another tenant read an asset")
	}
	if _, found, err := f.assets.AssetByTag(
		ctx, intruder, asset.Tag); err != nil || found {
		t.Errorf("another tenant resolved a tag (found %v)", found)
	}
	here, err := f.assets.AtLocation(ctx, intruder, "theatre-2", 50)
	if err != nil {
		t.Fatalf("AtLocation: %v", err)
	}
	if len(here) != 0 {
		t.Errorf("another tenant read %d asset(s) in a room", len(here))
	}
}
