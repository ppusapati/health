package postgres_test

import (
	"context"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	anaesthesiapostgres "github.com/ppusapati/health/code/internal/anaesthesia/adapters/postgres"
	"github.com/ppusapati/health/code/internal/anaesthesia/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
)

// The anaesthesia persistence adapter.
//
// Round-trip tests, because the defect they catch is invisible above the
// adapter: a dropped field reads back as a zero that looks like a decision
// nobody made. A lost E on an ASA grade turns an emergency into a routine
// case; a lost device connection flag makes an unreliable reading look
// trendable; a lost difficult-airway record is the one thing the next
// anaesthetist most needed.

var at = time.Date(2026, 9, 18, 8, 0, 0, 0, time.UTC)

type fixture struct {
	pool        *pgxpool.Pool
	assessments anaesthesiapostgres.AssessmentRepo
	records     anaesthesiapostgres.RecordRepo
	recovery    anaesthesiapostgres.RecoveryRepo

	scope     authctx.TenantScope
	tenantID  string
	caseID    string
	patientID string
}

func newFixture(t *testing.T) fixture {
	t.Helper()

	pool := pgtest.New(t)
	repo := anaesthesiapostgres.New(pgtx.NewManager(pool))
	tenantID := uuid.NewString()

	return fixture{
		pool:        pool,
		assessments: anaesthesiapostgres.AssessmentRepo{Repository: repo},
		records:     anaesthesiapostgres.RecordRepo{Repository: repo},
		recovery:    anaesthesiapostgres.RecoveryRepo{Repository: repo},
		scope: authctx.NewSession(authctx.Session{
			SubjectID: "anaesthetist-1", TenantID: tenantID,
		}).TenantScope(),
		tenantID:  tenantID,
		caseID:    uuid.NewString(),
		patientID: uuid.NewString(),
	}
}

func (f fixture) assessment(t *testing.T) domain.Assessment {
	t.Helper()

	assessment, err := domain.NewAssessment(uuid.NewString(), f.tenantID,
		domain.NewAssessmentInput{
			CaseID: f.caseID, PatientID: f.patientID,
			History: "hypertension, ex-smoker",
			Airway: domain.AirwayAssessment{
				Mallampati: "III", MouthOpeningMM: 32, ThyromentalMM: 55,
				NeckMovement: "reduced", Dentition: "crowns upper",
				Notes: "short neck", PredictedDifficult: true,
			},
			// The emergency modifier is the field a naive schema loses.
			ASAGrade:       domain.ASA3E,
			Investigations: []string{"fbc", "ecg"},
			Risks:          []string{"sore throat", "dental damage"},
			Plan:           "GA with videolaryngoscope",
			Consent:        domain.ConsentObtained,
			FitToProceed:   true,
			Conditions:     []string{"difficult airway trolley in theatre"},
		}, "anaesthetist-1", at)
	if err != nil {
		t.Fatalf("NewAssessment: %v", err)
	}
	if err := f.assessments.InsertAssessment(
		context.Background(), f.scope, assessment); err != nil {
		t.Fatalf("InsertAssessment: %v", err)
	}
	return assessment
}

func (f fixture) record(t *testing.T) domain.Record {
	t.Helper()

	record, err := domain.NewRecord(uuid.NewString(), f.tenantID,
		domain.NewRecordInput{
			CaseID: f.caseID, PatientID: f.patientID,
			Technique: domain.TechniqueGeneral, StartedAt: at,
		}, "anaesthetist-1", at)
	if err != nil {
		t.Fatalf("NewRecord: %v", err)
	}
	if err := f.records.InsertRecord(
		context.Background(), f.scope, record); err != nil {
		t.Fatalf("InsertRecord: %v", err)
	}
	return record
}

func TestAnAssessmentSurvivesTheRoundTrip(t *testing.T) {
	f := newFixture(t)
	written := f.assessment(t)

	read, err := f.assessments.Assessment(context.Background(), f.scope, written.ID)
	if err != nil {
		t.Fatalf("Assessment: %v", err)
	}

	if read.ASAGrade != domain.ASA3E {
		t.Errorf("ASA grade = %q, want %q", read.ASAGrade, domain.ASA3E)
	}
	if !read.ASAGrade.Emergency() {
		t.Error("the emergency modifier was lost, which makes an emergency read as routine")
	}
	if !read.Airway.PredictedDifficult {
		t.Error("predicted difficult airway was lost")
	}
	if read.Airway.ThyromentalMM != 55 || read.Airway.MouthOpeningMM != 32 {
		t.Errorf("airway measurements = %d/%d, want 32/55",
			read.Airway.MouthOpeningMM, read.Airway.ThyromentalMM)
	}
	if len(read.Risks) != 2 || len(read.Investigations) != 2 {
		t.Errorf("risks/investigations = %d/%d, want 2/2",
			len(read.Risks), len(read.Investigations))
	}
	if read.Consent != domain.ConsentObtained {
		t.Errorf("consent = %q, want obtained", read.Consent)
	}
	if !read.Current() {
		t.Error("a first assessment should be the one in force")
	}
}

// Empty arrays are the commonest source of a NOT NULL violation in this
// adapter: an assessment with no investigations is a nil slice in Go, and a
// nil slice into a NOT NULL text[] is a NULL.
func TestAnAssessmentWithNoListsIsStillWritable(t *testing.T) {
	f := newFixture(t)

	assessment, err := domain.NewAssessment(uuid.NewString(), f.tenantID,
		domain.NewAssessmentInput{
			CaseID: f.caseID, PatientID: f.patientID,
			ASAGrade: domain.ASA1, Consent: domain.ConsentPending,
			FitToProceed: true,
		}, "anaesthetist-1", at)
	if err != nil {
		t.Fatalf("NewAssessment: %v", err)
	}
	if err := f.assessments.InsertAssessment(
		context.Background(), f.scope, assessment); err != nil {
		t.Fatalf("InsertAssessment with empty lists: %v", err)
	}

	read, err := f.assessments.Assessment(context.Background(), f.scope, assessment.ID)
	if err != nil {
		t.Fatalf("Assessment: %v", err)
	}
	if len(read.Risks) != 0 || len(read.Conditions) != 0 {
		t.Errorf("empty lists came back non-empty: %v %v", read.Risks, read.Conditions)
	}
}

// Reassessment keeps both versions and leaves exactly one current.
func TestReassessmentRetiresTheOneItReplaces(t *testing.T) {
	f := newFixture(t)
	first := f.assessment(t)

	next, err := first.Reassess(uuid.NewString(), domain.NewAssessmentInput{
		ASAGrade:     domain.ASA4E,
		Consent:      domain.ConsentObtained,
		FitToProceed: false,
		Conditions:   []string{"chest infection: postpone two weeks"},
	}, "anaesthetist-2", at.Add(14*24*time.Hour))
	if err != nil {
		t.Fatalf("Reassess: %v", err)
	}
	if err := f.assessments.Supersede(context.Background(), f.scope, next,
		first.ID, at.Add(14*24*time.Hour)); err != nil {
		t.Fatalf("Supersede: %v", err)
	}

	all, err := f.assessments.Assessments(context.Background(), f.scope, f.caseID)
	if err != nil {
		t.Fatalf("Assessments: %v", err)
	}
	if len(all) != 2 {
		t.Fatalf("versions = %d, want 2; the clinic assessment must survive", len(all))
	}
	if all[0].Version != 1 || all[1].Version != 2 {
		t.Errorf("versions = %d, %d; want 1, 2", all[0].Version, all[1].Version)
	}
	if all[0].Current() {
		t.Error("the superseded assessment is still current")
	}

	current, ok := domain.CurrentAssessment(all)
	if !ok {
		t.Fatal("no current assessment after reassessment")
	}
	if current.ASAGrade != domain.ASA4E || current.FitToProceed {
		t.Errorf("current = %q fit=%v, want 4E unfit",
			current.ASAGrade, current.FitToProceed)
	}
}

// The database, not the application, holds "one current assessment per case".
// Written in raw SQL so the adapter cannot be the thing under test.
func TestTheDatabaseRefusesTwoCurrentAssessments(t *testing.T) {
	f := newFixture(t)
	f.assessment(t)

	_, err := f.pool.Exec(context.Background(), `
		INSERT INTO anaesthesia.assessment (
		    assessment_id, tenant_id, case_id, patient_id, version,
		    asa_grade, consent, fit_to_proceed, assessed_by, assessed_at)
		VALUES ($1, $2, $3, $4, 2, '2', 'obtained', true, 'sneaky', now())`,
		uuid.New(), f.tenantID, f.caseID, f.patientID)
	if err == nil {
		t.Fatal("two current assessments were accepted; " +
			"the theatre would have two opinions about whether the patient is fit")
	}
}

// A patient can be unfit, but the assessment has to say what would change it.
func TestTheDatabaseRefusesAnUnfitPatientWithNothingToDo(t *testing.T) {
	f := newFixture(t)

	_, err := f.pool.Exec(context.Background(), `
		INSERT INTO anaesthesia.assessment (
		    assessment_id, tenant_id, case_id, patient_id, version,
		    asa_grade, consent, fit_to_proceed, assessed_by, assessed_at)
		VALUES ($1, $2, $3, $4, 1, '3', 'pending', false, 'someone', now())`,
		uuid.New(), f.tenantID, uuid.New(), f.patientID)
	if err == nil {
		t.Fatal("'not fit' with no conditions was accepted; " +
			"the theatre cannot act on that")
	}
}

func TestThePlanIsVisibleToTheTheatreChecklist(t *testing.T) {
	f := newFixture(t)
	f.assessment(t)

	plan, err := domain.NewPlan(uuid.NewString(), f.tenantID, domain.NewPlanInput{
		CaseID: f.caseID, Technique: domain.TechniqueGeneral,
		Agents: []string{"propofol", "rocuronium"}, Airway: "ETT size 8",
		Monitoring:       []string{"arterial line"},
		SpecialEquipment: []string{"videolaryngoscope", "fluid warmer"},
		PostOperative:    "critical care",
	}, "anaesthetist-1", at)
	if err != nil {
		t.Fatalf("NewPlan: %v", err)
	}
	if err := f.assessments.SavePlan(context.Background(), f.scope, plan); err != nil {
		t.Fatalf("SavePlan: %v", err)
	}

	read, ok, err := f.assessments.Plan(context.Background(), f.scope, f.caseID)
	if err != nil || !ok {
		t.Fatalf("Plan: %v ok=%v", err, ok)
	}
	if len(read.SpecialEquipment) != 2 {
		t.Errorf("special equipment = %v; the theatre would not fetch it",
			read.SpecialEquipment)
	}

	all, err := f.assessments.Assessments(context.Background(), f.scope, f.caseID)
	if err != nil {
		t.Fatalf("Assessments: %v", err)
	}
	readiness := domain.AssessReadiness(all, &read)
	if !readiness.Assessed || !readiness.Planned || !readiness.DifficultAirway {
		t.Errorf("readiness = %+v; assessed, planned and difficult expected", readiness)
	}
	if readiness.PostOperative != "critical care" {
		t.Errorf("post-operative destination = %q; the bed is booked before the "+
			"operation, not after it", readiness.PostOperative)
	}
}

// A plan the anaesthetist has not written yet is an ordinary state, not an
// error: the readiness projection has a place to say it is outstanding.
func TestACaseWithNoPlanReadsAsOutstandingRatherThanMissing(t *testing.T) {
	f := newFixture(t)

	_, ok, err := f.assessments.Plan(context.Background(), f.scope, f.caseID)
	if err != nil {
		t.Fatalf("Plan: %v", err)
	}
	if ok {
		t.Fatal("a plan appeared for a case that has none")
	}
}

func TestADeviceReadingKeepsItsConnectionState(t *testing.T) {
	f := newFixture(t)
	record := f.record(t)
	ctx := context.Background()

	connected, err := domain.RecordVital(uuid.NewString(), f.tenantID,
		domain.NewVitalInput{
			RecordID: record.ID, Code: "nibp_systolic", Value: 118, Unit: "mmHg",
			Source: domain.SourceDevice,
			Device: domain.DeviceLink{
				DeviceID: "monitor-7", Model: "IntelliVue MX550",
				Connected: true, MeasuredAt: at,
			},
			ObservedAt: at,
		}, "", at)
	if err != nil {
		t.Fatalf("RecordVital: %v", err)
	}
	// The same monitor, still sending, but no longer attached to the patient.
	disconnected, err := domain.RecordVital(uuid.NewString(), f.tenantID,
		domain.NewVitalInput{
			RecordID: record.ID, Code: "nibp_systolic", Value: 41, Unit: "mmHg",
			Source: domain.SourceDevice,
			Device: domain.DeviceLink{
				DeviceID: "monitor-7", Connected: false, MeasuredAt: at,
			},
			ObservedAt: at.Add(time.Minute),
		}, "", at)
	if err != nil {
		t.Fatalf("RecordVital: %v", err)
	}
	for _, entry := range []domain.VitalEntry{connected, disconnected} {
		if err := f.records.InsertVital(ctx, f.scope, entry); err != nil {
			t.Fatalf("InsertVital: %v", err)
		}
	}

	read, err := f.records.Vitals(ctx, f.scope, record.ID, "nibp_systolic")
	if err != nil {
		t.Fatalf("Vitals: %v", err)
	}
	if len(read) != 2 {
		t.Fatalf("values = %d, want 2", len(read))
	}
	if !read[0].Trustworthy() {
		t.Error("a connected reading came back untrustworthy")
	}
	if read[1].Trustworthy() {
		t.Error("a reading taken while the monitor was disconnected came back " +
			"trendable; a 41 systolic would start a resuscitation nobody needs")
	}
	if read[0].Device.Model != "IntelliVue MX550" {
		t.Errorf("device model = %q, want IntelliVue MX550", read[0].Device.Model)
	}
}

func TestAnInfusionKeepsBothHalvesOfItsConcentration(t *testing.T) {
	f := newFixture(t)
	record := f.record(t)
	ctx := context.Background()

	drug, err := domain.RecordDrug(uuid.NewString(), f.tenantID,
		domain.NewDrugInput{
			RecordID: record.ID, DrugCode: "propofol", DrugDisplay: "Propofol",
			Route: "iv", Dose: 400, DoseUnit: "mg",
			ConcentrationAmount: 10, ConcentrationUnit: "mg",
			ConcentrationVolume: 1, RateMLPerHour: 20,
			Infusion: true, Source: domain.SourceDevice,
			Device:  domain.DeviceLink{DeviceID: "pump-3", Connected: true},
			GivenAt: at,
		}, "anaesthetist-1", at)
	if err != nil {
		t.Fatalf("RecordDrug: %v", err)
	}
	if err := f.records.InsertDrug(ctx, f.scope, drug); err != nil {
		t.Fatalf("InsertDrug: %v", err)
	}

	read, err := f.records.Drugs(ctx, f.scope, record.ID)
	if err != nil {
		t.Fatalf("Drugs: %v", err)
	}
	if len(read) != 1 {
		t.Fatalf("drugs = %d, want 1", len(read))
	}
	if read[0].ConcentrationAmount != 10 || read[0].ConcentrationVolume != 1 {
		t.Errorf("concentration = %g/%g, want 10/1; without both halves the "+
			"rate is a number with no clinical meaning",
			read[0].ConcentrationAmount, read[0].ConcentrationVolume)
	}

	stopped, err := f.records.StopInfusion(ctx, f.scope, drug.ID, at.Add(time.Hour))
	if err != nil {
		t.Fatalf("StopInfusion: %v", err)
	}
	if !stopped {
		t.Fatal("a running infusion refused to stop")
	}
	again, err := f.records.StopInfusion(ctx, f.scope, drug.ID, at.Add(2*time.Hour))
	if err != nil {
		t.Fatalf("StopInfusion: %v", err)
	}
	if again {
		t.Error("stopping an already-stopped infusion moved its stop time; " +
			"the first stop is the true one")
	}
}

// The database, not the application, refuses a rate that cannot be turned into
// a dose.
func TestTheDatabaseRefusesAnInfusionWithoutAConcentration(t *testing.T) {
	f := newFixture(t)
	record := f.record(t)

	_, err := f.pool.Exec(context.Background(), `
		INSERT INTO anaesthesia.drug (
		    drug_id, tenant_id, record_id, drug_code, dose, dose_unit,
		    rate_ml_per_hour, infusion, source, given_at, recorded_at, recorded_by)
		VALUES ($1, $2, $3, 'remifentanil', 0, 'mcg', 8, true, 'manual',
		        now(), now(), 'someone')`,
		uuid.New(), f.tenantID, record.ID)
	if err == nil {
		t.Fatal("an infusion with no concentration was accepted; " +
			"the chart would show a rate nobody can interpret")
	}
}

func TestTheDifficultAirwayFollowsThePatient(t *testing.T) {
	f := newFixture(t)
	record := f.record(t)
	ctx := context.Background()

	attempts := []struct {
		attempt    int
		device     string
		successful bool
	}{
		{1, "macintosh 3", false},
		{2, "macintosh 4", false},
		{3, "videolaryngoscope", true},
	}
	for _, a := range attempts {
		event, err := domain.RecordAirway(uuid.NewString(), f.tenantID,
			domain.NewAirwayInput{
				RecordID: record.ID, Device: a.device, Attempt: a.attempt,
				Grade: "3", Successful: a.successful,
				Adjuncts:   []string{"bougie"},
				OccurredAt: at.Add(time.Duration(a.attempt) * time.Minute),
			}, "anaesthetist-1", at)
		if err != nil {
			t.Fatalf("RecordAirway: %v", err)
		}
		if err := f.records.InsertAirwayEvent(ctx, f.scope, event); err != nil {
			t.Fatalf("InsertAirwayEvent: %v", err)
		}
	}

	onRecord, err := f.records.AirwayEvents(ctx, f.scope, record.ID)
	if err != nil {
		t.Fatalf("AirwayEvents: %v", err)
	}
	if summary := domain.SummariseAirway(onRecord); !summary.Difficult {
		t.Errorf("three attempts read as an easy airway: %+v", summary)
	}

	// The read the next anaesthetist makes, months later, from a different
	// admission: by patient, not by record.
	history, err := f.records.PatientAirwayEvents(ctx, f.scope, f.patientID, 20)
	if err != nil {
		t.Fatalf("PatientAirwayEvents: %v", err)
	}
	if len(history) != 3 {
		t.Fatalf("history = %d events, want 3; a lost difficult-airway record "+
			"is the one thing the next anaesthetist most needed", len(history))
	}
	if summary := domain.SummariseAirway(history); summary.FinalDevice != "videolaryngoscope" {
		t.Errorf("final device = %q, want videolaryngoscope", summary.FinalDevice)
	}
}

// The database enforces that attempts are numbered from one and only once.
func TestTheDatabaseRefusesTwoAttemptsWithTheSameNumber(t *testing.T) {
	f := newFixture(t)
	record := f.record(t)
	ctx := context.Background()

	event, err := domain.RecordAirway(uuid.NewString(), f.tenantID,
		domain.NewAirwayInput{
			RecordID: record.ID, Device: "macintosh 3", Attempt: 1,
			Successful: true, OccurredAt: at,
		}, "anaesthetist-1", at)
	if err != nil {
		t.Fatalf("RecordAirway: %v", err)
	}
	if err := f.records.InsertAirwayEvent(ctx, f.scope, event); err != nil {
		t.Fatalf("InsertAirwayEvent: %v", err)
	}

	_, err = f.pool.Exec(ctx, `
		INSERT INTO anaesthesia.airway_event (
		    airway_id, tenant_id, record_id, device, attempt, occurred_at,
		    recorded_by)
		VALUES ($1, $2, $3, 'macintosh 4', 1, now(), 'someone')`,
		uuid.New(), f.tenantID, record.ID)
	if err == nil {
		t.Fatal("two first attempts were accepted; the count of attempts, " +
			"which is what the next anaesthetist reads, would be wrong")
	}
}

func TestTheFluidBalanceCallsOutBloodAndTransfusion(t *testing.T) {
	f := newFixture(t)
	record := f.record(t)
	ctx := context.Background()

	entries := []domain.NewFluidInput{
		{RecordID: record.ID, Direction: domain.FluidIn, Kind: "crystalloid",
			Label: "Hartmann's", VolumeML: 1500, OccurredAt: at},
		{RecordID: record.ID, Direction: domain.FluidIn, Kind: domain.KindTransfusion,
			Label: "red cells", VolumeML: 280, ProductID: "G123456",
			OccurredAt: at.Add(time.Hour)},
		{RecordID: record.ID, Direction: domain.FluidOut, Kind: domain.KindBloodLoss,
			VolumeML: 900, OccurredAt: at.Add(time.Hour)},
		{RecordID: record.ID, Direction: domain.FluidOut, Kind: domain.KindUrine,
			VolumeML: 250, OccurredAt: at.Add(90 * time.Minute)},
	}
	for _, in := range entries {
		entry, err := domain.RecordFluid(uuid.NewString(), f.tenantID, in,
			"anaesthetist-1", at)
		if err != nil {
			t.Fatalf("RecordFluid: %v", err)
		}
		if err := f.records.InsertFluid(ctx, f.scope, entry); err != nil {
			t.Fatalf("InsertFluid: %v", err)
		}
	}

	read, err := f.records.Fluids(ctx, f.scope, record.ID)
	if err != nil {
		t.Fatalf("Fluids: %v", err)
	}
	balance := domain.Balance(read)
	if balance.InML != 1780 || balance.OutML != 1150 {
		t.Errorf("balance = in %g out %g, want 1780/1150", balance.InML, balance.OutML)
	}
	if balance.BloodLossML != 900 || balance.TransfusedML != 280 || balance.UrineML != 250 {
		t.Errorf("blood loss/transfused/urine = %g/%g/%g, want 900/280/250",
			balance.BloodLossML, balance.TransfusedML, balance.UrineML)
	}
	for _, entry := range read {
		if entry.Kind == domain.KindTransfusion && entry.ProductID != "G123456" {
			t.Error("the blood bank's unit identifier was lost; the transfusion " +
				"cannot be reconciled against the issue record")
		}
	}
}

// The database refuses a transfusion with no unit identifier.
func TestTheDatabaseRefusesAnUntraceableTransfusion(t *testing.T) {
	f := newFixture(t)
	record := f.record(t)

	_, err := f.pool.Exec(context.Background(), `
		INSERT INTO anaesthesia.fluid (
		    fluid_id, tenant_id, record_id, direction, kind, volume_ml,
		    occurred_at, recorded_at, recorded_by)
		VALUES ($1, $2, $3, 'in', 'transfusion', 280, now(), now(), 'someone')`,
		uuid.New(), f.tenantID, record.ID)
	if err == nil {
		t.Fatal("a transfusion with no unit identifier was accepted; " +
			"half of every transfusion audit is reconciling against the issue")
	}
}

func TestRecoveryScoringAndDischargeRoundTrip(t *testing.T) {
	f := newFixture(t)
	record := f.record(t)
	ctx := context.Background()

	handover, err := domain.HandOver(uuid.NewString(), f.tenantID,
		domain.NewHandoverInput{
			RecordID: record.ID, ToClinician: "recovery-nurse-1",
			Summary:        "GA, uneventful, difficult intubation third attempt",
			Concerns:       []string{"sore throat"},
			Instructions:   []string{"oxygen 4L until saturating"},
			AnalgesiaGiven: []string{"morphine 10mg"},
		}, "anaesthetist-1", at.Add(2*time.Hour))
	if err != nil {
		t.Fatalf("HandOver: %v", err)
	}
	if err := f.records.InsertHandover(ctx, f.scope, handover); err != nil {
		t.Fatalf("InsertHandover: %v", err)
	}

	scale := domain.Aldrete()
	partial, err := domain.Assess(uuid.NewString(), f.tenantID, record.ID, scale,
		map[string]int{"activity": 2, "respiration": 2},
		"recovery-nurse-1", at.Add(2*time.Hour))
	if err != nil {
		t.Fatalf("Assess: %v", err)
	}
	if err := f.recovery.InsertAssessment(ctx, f.scope, partial); err != nil {
		t.Fatalf("InsertAssessment: %v", err)
	}

	full := map[string]int{}
	for _, component := range scale.Components {
		full[component.Code] = component.Max
	}
	complete, err := domain.Assess(uuid.NewString(), f.tenantID, record.ID, scale,
		full, "recovery-nurse-1", at.Add(3*time.Hour))
	if err != nil {
		t.Fatalf("Assess: %v", err)
	}
	if err := f.recovery.InsertAssessment(ctx, f.scope, complete); err != nil {
		t.Fatalf("InsertAssessment: %v", err)
	}

	scores, err := f.recovery.Assessments(ctx, f.scope, record.ID)
	if err != nil {
		t.Fatalf("Assessments: %v", err)
	}
	if len(scores) != 2 {
		t.Fatalf("assessments = %d, want 2", len(scores))
	}
	if scores[0].Complete() {
		t.Error("a partial assessment read back as complete; scoring an " +
			"unscored component would trap or discharge a patient on a guess")
	}
	if len(scores[0].Missing) == 0 {
		t.Error("the missing components were lost")
	}
	if got := scores[1].Scores["activity"]; got != 2 {
		t.Errorf("component score = %d, want 2; the total cannot be read back", got)
	}
	if !scores[1].MeetsThreshold() {
		t.Errorf("a full score of %d did not meet a threshold of %d",
			scores[1].Total, scores[1].DischargeThreshold)
	}

	decision := domain.EvaluateDischarge(true, scores)
	if !decision.Allowed() {
		t.Fatalf("discharge refused: %v", decision.Refusals)
	}

	discharge, err := domain.NewDischarge(uuid.NewString(), f.tenantID, record.ID,
		"ward 7", decision, "", "recovery-nurse-1", at.Add(3*time.Hour))
	if err != nil {
		t.Fatalf("NewDischarge: %v", err)
	}
	if err := f.recovery.InsertDischarge(ctx, f.scope, discharge); err != nil {
		t.Fatalf("InsertDischarge: %v", err)
	}

	read, ok, err := f.recovery.Discharge(ctx, f.scope, record.ID)
	if err != nil || !ok {
		t.Fatalf("Discharge: %v ok=%v", err, ok)
	}
	if read.Destination != "ward 7" || read.Overridden {
		t.Errorf("discharge = %+v, want ward 7 and no override", read)
	}
	if read.ScoreID != scores[1].ID {
		t.Errorf("score id = %q, want %q; a review reads back the score the "+
			"decision was made on", read.ScoreID, scores[1].ID)
	}
}

// The database refuses a discharge below the threshold with no reason.
func TestTheDatabaseRefusesAnUnexplainedOverride(t *testing.T) {
	f := newFixture(t)
	record := f.record(t)

	_, err := f.pool.Exec(context.Background(), `
		INSERT INTO anaesthesia.discharge (
		    discharge_id, tenant_id, record_id, destination, overridden,
		    discharged_at, discharged_by)
		VALUES ($1, $2, $3, 'ward 7', true, now(), 'someone')`,
		uuid.New(), f.tenantID, record.ID)
	if err == nil {
		t.Fatal("an unexplained override was accepted; the reason is the whole " +
			"of what a review reads")
	}
}

func TestThePainTeamsWorklistIsSoonestReviewFirst(t *testing.T) {
	f := newFixture(t)
	record := f.record(t)
	ctx := context.Background()

	later, err := domain.NewPainOrder(uuid.NewString(), f.tenantID,
		domain.NewPainOrderInput{
			RecordID: record.ID, PatientID: f.patientID, Modality: "PCA morphine",
			PrescriptionIDs: []string{"rx-1"}, TargetScore: "≤3 on movement",
			Monitoring: []string{"sedation score hourly", "respiratory rate hourly"},
			Escalation: "call the on-call anaesthetist if sedation ≥ 2",
			ReviewBy:   at.Add(24 * time.Hour),
		}, "anaesthetist-1", at)
	if err != nil {
		t.Fatalf("NewPainOrder: %v", err)
	}
	sooner, err := domain.NewPainOrder(uuid.NewString(), f.tenantID,
		domain.NewPainOrderInput{
			RecordID: record.ID, PatientID: f.patientID, Modality: "epidural",
			Monitoring: []string{"block height 4-hourly"},
			Escalation: "call the acute pain team",
			ReviewBy:   at.Add(4 * time.Hour),
		}, "anaesthetist-1", at)
	if err != nil {
		t.Fatalf("NewPainOrder: %v", err)
	}
	for _, order := range []domain.PainOrder{later, sooner} {
		if err := f.recovery.InsertPainOrder(ctx, f.scope, order); err != nil {
			t.Fatalf("InsertPainOrder: %v", err)
		}
	}

	worklist, err := f.recovery.RunningPainOrders(ctx, f.scope, 20)
	if err != nil {
		t.Fatalf("RunningPainOrders: %v", err)
	}
	if len(worklist) != 2 {
		t.Fatalf("worklist = %d, want 2", len(worklist))
	}
	if worklist[0].ID != sooner.ID {
		t.Error("the worklist is not soonest-review-first")
	}
	if len(worklist[1].PrescriptionIDs) != 1 {
		t.Error("the prescription link was lost; the plan would have to be " +
			"prescribed a second time, which is how a patient gets two doses")
	}

	stopped, err := f.recovery.StopPainOrder(ctx, f.scope, sooner.ID,
		"ward-nurse-1", at.Add(6*time.Hour))
	if err != nil {
		t.Fatalf("StopPainOrder: %v", err)
	}
	if !stopped {
		t.Fatal("a running pain plan refused to stop")
	}
	again, err := f.recovery.StopPainOrder(ctx, f.scope, sooner.ID,
		"pain-team-1", at.Add(8*time.Hour))
	if err != nil {
		t.Fatalf("StopPainOrder: %v", err)
	}
	if again {
		t.Error("stopping an already-stopped plan moved its stop time")
	}

	remaining, err := f.recovery.RunningPainOrders(ctx, f.scope, 20)
	if err != nil {
		t.Fatalf("RunningPainOrders: %v", err)
	}
	if len(remaining) != 1 || remaining[0].ID != later.ID {
		t.Errorf("worklist after stopping = %d entries", len(remaining))
	}
}

// The database refuses a pain plan a ward nurse cannot act on at 3am.
func TestTheDatabaseRefusesAPainPlanWithNothingToObserve(t *testing.T) {
	f := newFixture(t)
	record := f.record(t)

	_, err := f.pool.Exec(context.Background(), `
		INSERT INTO anaesthesia.pain_order (
		    order_id, tenant_id, record_id, patient_id, modality, monitoring,
		    escalation, ordered_by, ordered_at)
		VALUES ($1, $2, $3, $4, 'PCA morphine', '{}', 'call someone',
		        'anaesthetist-1', now())`,
		uuid.New(), f.tenantID, record.ID, f.patientID)
	if err == nil {
		t.Fatal("a pain plan with nothing to monitor was accepted; " +
			"nursing cannot follow it")
	}
}

// A record transcribed from paper after a downtime has to say so.
func TestAnImportedRecordSaysWhereItCameFrom(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	record, err := domain.NewRecord(uuid.NewString(), f.tenantID,
		domain.NewRecordInput{
			CaseID: f.caseID, PatientID: f.patientID,
			Technique: domain.TechniqueSpinal, StartedAt: at,
			Origin:     domain.SourceImported,
			ImportNote: "transcribed from the paper chart after the 14:00 outage",
		}, "anaesthetist-2", at.Add(6*time.Hour))
	if err != nil {
		t.Fatalf("NewRecord: %v", err)
	}
	if err := f.records.InsertRecord(ctx, f.scope, record); err != nil {
		t.Fatalf("InsertRecord: %v", err)
	}

	read, ok, err := f.records.RecordForCase(ctx, f.scope, f.caseID)
	if err != nil || !ok {
		t.Fatalf("RecordForCase: %v ok=%v", err, ok)
	}
	if read.Origin != domain.SourceImported {
		t.Errorf("origin = %q; a reconstructed record that did not say so "+
			"would read as a contemporaneous one", read.Origin)
	}
	if read.ImportedBy == "" || read.ImportedAt.IsZero() || read.ImportNote == "" {
		t.Errorf("import provenance incomplete: %+v", read)
	}

	// The database holds the same rule, so a writer that skipped the domain
	// could not leave an import unexplained.
	_, err = f.pool.Exec(ctx, `
		INSERT INTO anaesthesia.record (
		    record_id, tenant_id, case_id, patient_id, technique, status,
		    started_at, started_by, origin)
		VALUES ($1, $2, $3, $4, 'general', 'open', now(), 'someone', 'imported')`,
		uuid.New(), f.tenantID, uuid.New(), f.patientID)
	if err == nil {
		t.Fatal("an import with no provenance was accepted")
	}
}

// Another tenant's scope reaches nothing, at the repository rather than at the
// handler (Gate A2).
func TestAnotherTenantSeesNoneOfIt(t *testing.T) {
	f := newFixture(t)
	written := f.assessment(t)
	record := f.record(t)

	other := authctx.NewSession(authctx.Session{
		SubjectID: "anaesthetist-9", TenantID: uuid.NewString(),
	}).TenantScope()
	ctx := context.Background()

	if _, err := f.assessments.Assessment(ctx, other, written.ID); err == nil {
		t.Error("another tenant read the assessment")
	}
	if _, err := f.records.Record(ctx, other, record.ID); err == nil {
		t.Error("another tenant read the record")
	}
	all, err := f.assessments.Assessments(ctx, other, f.caseID)
	if err != nil {
		t.Fatalf("Assessments: %v", err)
	}
	if len(all) != 0 {
		t.Errorf("another tenant listed %d assessments", len(all))
	}
}
