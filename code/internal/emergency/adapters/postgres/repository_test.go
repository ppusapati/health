package postgres_test

import (
	"context"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	emergencypostgres "github.com/ppusapati/health/code/internal/emergency/adapters/postgres"
	"github.com/ppusapati/health/code/internal/emergency/domain"
	"github.com/ppusapati/health/code/internal/emergency/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
)

// The emergency persistence adapter.
//
// These are round-trip tests, and they exist because the class of defect they
// catch is invisible everywhere else: a field the domain sets and the adapter
// drops reads back as a zero value that looks like a decision nobody made. An
// empty red-flag list stored as NULL, a `late` flag lost on the way out, a
// reconciliation debt that reads as settled — each of them is a silent wrong
// answer rather than an error.

var at = time.Date(2026, 9, 17, 9, 0, 0, 0, time.UTC)

type fixture struct {
	pool  *pgxpool.Pool
	repo  emergencypostgres.VisitRepo
	scope authctx.TenantScope

	tenantID   string
	facilityID string
}

func newFixture(t *testing.T) fixture {
	t.Helper()

	pool := pgtest.New(t)
	tenantID := uuid.NewString()

	return fixture{
		pool: pool,
		repo: emergencypostgres.VisitRepo{
			Repository: emergencypostgres.New(pgtx.NewManager(pool)),
		},
		scope: authctx.NewSession(authctx.Session{
			SubjectID: "nurse-1", TenantID: tenantID,
		}).TenantScope(),
		tenantID:   tenantID,
		facilityID: uuid.NewString(),
	}
}

func (f fixture) visit(t *testing.T, in domain.NewVisitInput) domain.Visit {
	t.Helper()

	if in.EncounterID == "" {
		in.EncounterID = uuid.NewString()
	}
	if in.PatientID == "" && !in.Unidentified {
		in.PatientID = uuid.NewString()
	}
	if in.FacilityID == "" {
		in.FacilityID = f.facilityID
	}
	if in.ChiefComplaint == "" {
		in.ChiefComplaint = "chest pain"
	}
	if in.ArrivedAt.IsZero() {
		in.ArrivedAt = at
	}

	visit, err := domain.NewVisit(uuid.NewString(), f.tenantID, in, "clerk-1", at)
	if err != nil {
		t.Fatalf("NewVisit: %v", err)
	}
	if err := f.repo.InsertVisit(context.Background(), f.scope, visit); err != nil {
		t.Fatalf("InsertVisit: %v", err)
	}
	return visit
}

func TestAVisitSurvivesTheRoundTrip(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	want := f.visit(t, domain.NewVisitInput{
		ArrivalMode: domain.ArrivalAmbulance, ChiefComplaint: "central chest pain",
		MedicoLegal: true, MedicoLegalRef: "FIR/2026/4417", Location: "Resus 1",
	})

	got, err := f.repo.GetVisit(ctx, f.scope, want.ID)
	if err != nil {
		t.Fatalf("GetVisit: %v", err)
	}

	if got.ID != want.ID || got.EncounterID != want.EncounterID ||
		got.PatientID != want.PatientID || got.FacilityID != want.FacilityID ||
		got.ArrivalMode != want.ArrivalMode || got.ChiefComplaint != want.ChiefComplaint ||
		got.Status != want.Status || got.Location != want.Location ||
		got.Version != want.Version {
		t.Fatalf("round trip lost data:\n got %+v\nwant %+v", got, want)
	}
	// The medico-legal pair travels together. A flag that came back without
	// its reference would be a restricted case nobody could trace.
	if !got.MedicoLegal || got.MedicoLegalRef != want.MedicoLegalRef {
		t.Fatalf("medico-legal = %v/%q, want true/%q",
			got.MedicoLegal, got.MedicoLegalRef, want.MedicoLegalRef)
	}
	if !got.ArrivedAt.Equal(want.ArrivedAt) {
		t.Fatalf("ArrivedAt = %v, want %v", got.ArrivedAt, want.ArrivedAt)
	}
}

// An unidentified patient has no patient id, and the schema has to hold a
// visit that admits it rather than one with an empty string in a foreign key.
func TestAnUnidentifiedVisitStoresNoPatient(t *testing.T) {
	f := newFixture(t)

	want := f.visit(t, domain.NewVisitInput{
		Unidentified: true, TemporaryName: "UNKNOWN MALE ALPHA",
		ChiefComplaint: "found collapsed",
	})

	got, err := f.repo.GetVisit(context.Background(), f.scope, want.ID)
	if err != nil {
		t.Fatalf("GetVisit: %v", err)
	}
	if got.PatientID != "" {
		t.Fatalf("PatientID = %q on an unidentified visit", got.PatientID)
	}
	if !got.Unidentified || got.TemporaryName != "UNKNOWN MALE ALPHA" {
		t.Fatalf("unidentified = %v, temporary name = %q",
			got.Unidentified, got.TemporaryName)
	}
}

// Optimistic concurrency. Two clinicians on the same visit in a resus room is
// the ordinary case, not the exotic one.
func TestAStaleWriteIsRefused(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	visit := f.visit(t, domain.NewVisitInput{})
	stale := visit.Version

	visit.Location = "Majors 2"
	if err := f.repo.UpdateVisit(ctx, f.scope, visit, stale); err != nil {
		t.Fatalf("UpdateVisit: %v", err)
	}

	visit.Location = "Majors 3"
	err := f.repo.UpdateVisit(ctx, f.scope, visit, stale)
	if err == nil {
		t.Fatal("a write against a stale version was accepted")
	}
	if !isVersionConflict(err) {
		t.Fatalf("want a version conflict, got %v", err)
	}
}

func isVersionConflict(err error) bool {
	for e := err; e != nil; {
		if e == ports.ErrVersionConflict {
			return true
		}
		unwrapped, ok := e.(interface{ Unwrap() error })
		if !ok {
			return false
		}
		e = unwrapped.Unwrap()
	}
	return false
}

// A triage with nothing missing and no red flags: both arrays are empty rather
// than absent. This is the shape most assessments have, and the one a NOT NULL
// column rejects if the adapter passes a nil slice through.
func TestATriageWithNoRedFlagsAndNoGapsStores(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	visit := f.visit(t, domain.NewVisitInput{})
	rate, pulse := 18, 96
	triage, err := domain.NewTriage(uuid.NewString(), f.tenantID, domain.NewTriageInput{
		VisitID: visit.ID, Scale: domain.ESI(), AcuityCode: "2",
		RespiratoryRate: &rate, HeartRate: &pulse, Consciousness: "alert",
	}, "nurse-1", at)
	if err != nil {
		t.Fatalf("NewTriage: %v", err)
	}
	if err := f.repo.InsertTriage(ctx, f.scope, triage); err != nil {
		t.Fatalf("InsertTriage: %v", err)
	}

	got, ok, err := f.repo.LatestTriage(ctx, f.scope, visit.ID)
	if err != nil {
		t.Fatalf("LatestTriage: %v", err)
	}
	if !ok {
		t.Fatal("the assessment just written is not the latest")
	}
	if got.AcuityCode != "2" || got.AcuityRank != 2 || got.ScaleName != "ESI" {
		t.Fatalf("acuity = %s/%d on scale %q", got.AcuityCode, got.AcuityRank, got.ScaleName)
	}
	// The measurements come back as measurements, not as zeroes. A pulse of 0
	// and an unrecorded pulse are different clinical statements.
	if got.HeartRate == nil || *got.HeartRate != pulse {
		t.Fatalf("HeartRate = %v, want %d", got.HeartRate, pulse)
	}
	if got.SystolicBP != nil {
		t.Fatalf("SystolicBP = %v, want absent", *got.SystolicBP)
	}
}

// Re-triage is the same operation, and the queue sorts on the latest. A
// deteriorating patient in the waiting room is exactly who re-assessment is
// for, so reading back the first assessment would be the dangerous answer.
func TestLatestTriageIsTheMostRecent(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	visit := f.visit(t, domain.NewVisitInput{})
	for i, code := range []string{"4", "2"} {
		triage, err := domain.NewTriage(uuid.NewString(), f.tenantID, domain.NewTriageInput{
			VisitID: visit.ID, Scale: domain.ESI(), AcuityCode: code,
			Consciousness: "alert",
		}, "nurse-1", at.Add(time.Duration(i)*time.Hour))
		if err != nil {
			t.Fatalf("NewTriage(%s): %v", code, err)
		}
		if err := f.repo.InsertTriage(ctx, f.scope, triage); err != nil {
			t.Fatalf("InsertTriage(%s): %v", code, err)
		}
	}

	got, ok, err := f.repo.LatestTriage(ctx, f.scope, visit.ID)
	if err != nil || !ok {
		t.Fatalf("LatestTriage: %v (found=%v)", err, ok)
	}
	if got.AcuityCode != "2" {
		t.Fatalf("latest acuity = %q, want the re-triage", got.AcuityCode)
	}

	all, err := f.repo.ListTriage(ctx, f.scope, visit.ID)
	if err != nil {
		t.Fatalf("ListTriage: %v", err)
	}
	if len(all) != 2 {
		t.Fatalf("%d assessments retained, want 2: a re-triage does not replace the first",
			len(all))
	}
}

// The two clocks are stored separately, and `late` with them. A resuscitation
// written up in arrears is the ordinary case, and the gap is the only thing
// that distinguishes a contemporaneous record from a reconstruction.
func TestAnEventKeepsBothClocksAndItsLateFlag(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	visit := f.visit(t, domain.NewVisitInput{})
	happened := at.Add(-30 * time.Minute)
	event, err := domain.NewEvent(uuid.NewString(), f.tenantID, domain.NewEventInput{
		VisitID: visit.ID, Kind: domain.EventDefibrillation,
		Detail: "200J synchronised", OccurredAt: happened, Sequence: 2,
	}, "doctor-1", at)
	if err != nil {
		t.Fatalf("NewEvent: %v", err)
	}
	if !event.Late {
		t.Fatal("an entry written 30 minutes afterwards is not marked late")
	}
	if err := f.repo.InsertEvent(ctx, f.scope, event); err != nil {
		t.Fatalf("InsertEvent: %v", err)
	}

	timeline, err := f.repo.Timeline(ctx, f.scope, visit.ID)
	if err != nil {
		t.Fatalf("Timeline: %v", err)
	}
	if len(timeline) != 1 {
		t.Fatalf("%d events on the timeline, want 1", len(timeline))
	}
	got := timeline[0]
	if !got.OccurredAt.Equal(happened) {
		t.Fatalf("OccurredAt = %v, want %v", got.OccurredAt, happened)
	}
	if !got.RecordedAt.Equal(at) {
		t.Fatalf("RecordedAt = %v, want %v", got.RecordedAt, at)
	}
	if !got.Late {
		t.Fatal("the late flag did not survive the round trip")
	}
	if got.Sequence != 2 {
		t.Fatalf("Sequence = %d, want 2", got.Sequence)
	}
}

// SRS-ER-009. The debt is facility-wide, and reconciling it twice is a race
// rather than a success: a caller told "done" for an order nobody wrote would
// never write the real one.
func TestAPreOrderAdministrationIsOwedUntilReconciled(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	visit := f.visit(t, domain.NewVisitInput{})
	event, err := domain.NewEvent(uuid.NewString(), f.tenantID, domain.NewEventInput{
		VisitID: visit.ID, Kind: domain.EventDrug,
		Detail: "adrenaline 500 micrograms IM", OccurredAt: at,
		ProtocolID: "anaphylaxis-v3", PreOrder: true,
	}, "nurse-1", at)
	if err != nil {
		t.Fatalf("NewEvent: %v", err)
	}
	if err := f.repo.InsertEvent(ctx, f.scope, event); err != nil {
		t.Fatalf("InsertEvent: %v", err)
	}

	owed, err := f.repo.Unreconciled(ctx, f.scope, f.facilityID, 50)
	if err != nil {
		t.Fatalf("Unreconciled: %v", err)
	}
	if len(owed) != 1 || owed[0].ID != event.ID {
		t.Fatalf("debt list = %v, want the one administration", owed)
	}

	settled, err := f.repo.ReconcileEvent(ctx, f.scope, event.ID, uuid.NewString())
	if err != nil {
		t.Fatalf("ReconcileEvent: %v", err)
	}
	if !settled {
		t.Fatal("reconciling an outstanding administration reported nothing to do")
	}

	again, err := f.repo.ReconcileEvent(ctx, f.scope, event.ID, uuid.NewString())
	if err != nil {
		t.Fatalf("ReconcileEvent (second): %v", err)
	}
	if again {
		t.Fatal("reconciling twice settled the same debt twice")
	}

	after, err := f.repo.Unreconciled(ctx, f.scope, f.facilityID, 50)
	if err != nil {
		t.Fatalf("Unreconciled after: %v", err)
	}
	if len(after) != 0 {
		t.Fatalf("%d administrations still owed after reconciliation", len(after))
	}
}

// A pathway's targets are the milestones it is measured on, and they are
// stored with it rather than looked up: a department that publishes new
// targets next month has not changed what this activation was measured
// against.
func TestAPathwayKeepsTheTargetsItWasActivatedUnder(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	visit := f.visit(t, domain.NewVisitInput{})
	pathway, err := domain.ActivatePathway(uuid.NewString(), f.tenantID,
		domain.NewPathwayInput{
			VisitID: visit.ID, Kind: domain.PathwayStroke, NotifiedTeam: "stroke_team",
		}, "nurse-1", at)
	if err != nil {
		t.Fatalf("ActivatePathway: %v", err)
	}
	if len(pathway.Targets) == 0 {
		t.Fatal("the stroke pathway has no published targets to store")
	}
	if err := f.repo.InsertPathway(ctx, f.scope, pathway); err != nil {
		t.Fatalf("InsertPathway: %v", err)
	}

	listed, err := f.repo.ListPathways(ctx, f.scope, visit.ID)
	if err != nil {
		t.Fatalf("ListPathways: %v", err)
	}
	if len(listed) != 1 {
		t.Fatalf("%d pathways, want 1", len(listed))
	}
	if len(listed[0].Targets) != len(pathway.Targets) {
		t.Fatalf("%d targets came back, want %d",
			len(listed[0].Targets), len(pathway.Targets))
	}
	if listed[0].NotifiedTeam != "stroke_team" {
		t.Fatalf("NotifiedTeam = %q; who was called is the commonest thing to lose",
			listed[0].NotifiedTeam)
	}

	active, err := f.repo.ActivePathways(ctx, f.scope, f.facilityID)
	if err != nil {
		t.Fatalf("ActivePathways: %v", err)
	}
	if kinds := active[visit.ID]; len(kinds) != 1 || kinds[0] != domain.PathwayStroke {
		t.Fatalf("active pathways for the visit = %v", kinds)
	}

	if err := f.repo.StandDownPathway(ctx, f.scope, pathway.ID,
		"CT negative, stroke mimic", at.Add(time.Hour)); err != nil {
		t.Fatalf("StandDownPathway: %v", err)
	}
	stoodDown, err := f.repo.ActivePathways(ctx, f.scope, f.facilityID)
	if err != nil {
		t.Fatalf("ActivePathways after stand-down: %v", err)
	}
	if len(stoodDown[visit.ID]) != 0 {
		t.Fatal("a stood-down pathway is still flashing on the board")
	}
}

// The open board is the department as it stands. A disposed visit has left.
func TestOpenVisitsExcludesTheDisposed(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	open := f.visit(t, domain.NewVisitInput{ChiefComplaint: "breathless"})
	gone := f.visit(t, domain.NewVisitInput{ChiefComplaint: "sprained wrist"})

	expected := gone.Version
	refusals, err := gone.Dispose(domain.DispositionDischarge, "advice given", "",
		domain.DispositionRequirements{}, domain.DispositionEvidence{}, at.Add(time.Hour))
	if err != nil {
		t.Fatalf("Dispose: %v", err)
	}
	if len(refusals) != 0 {
		t.Fatalf("refusals with no requirements configured: %v", refusals)
	}
	if err := f.repo.UpdateVisit(ctx, f.scope, gone, expected); err != nil {
		t.Fatalf("UpdateVisit: %v", err)
	}

	visits, err := f.repo.OpenVisits(ctx, f.scope, f.facilityID, 50)
	if err != nil {
		t.Fatalf("OpenVisits: %v", err)
	}
	if len(visits) != 1 || visits[0].ID != open.ID {
		t.Fatalf("open board = %v, want only the open visit", visits)
	}
}

// A visit belonging to another tenant is not readable through this scope, and
// the refusal is not-found rather than permission-denied: a probe must not be
// able to confirm that an identifier exists elsewhere.
func TestAnotherTenantsVisitIsNotFound(t *testing.T) {
	f := newFixture(t)

	visit := f.visit(t, domain.NewVisitInput{})

	other := authctx.NewSession(authctx.Session{
		SubjectID: "nurse-2", TenantID: uuid.NewString(),
	}).TenantScope()

	if _, err := f.repo.GetVisit(context.Background(), other, visit.ID); err == nil {
		t.Fatal("a visit was readable from another tenant's scope")
	}
}
