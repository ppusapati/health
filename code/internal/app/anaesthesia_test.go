package app_test

import (
	"context"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	anaesthesiav1 "github.com/ppusapati/health/code/gen/go/healthcare/anaesthesia/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/anaesthesia/v1/anaesthesiav1connect"
	empiv1 "github.com/ppusapati/health/code/gen/go/healthcare/empi/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/empi/v1/empiv1connect"
	encounterv1 "github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1/encounterv1connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	theatrev1 "github.com/ppusapati/health/code/gen/go/healthcare/theatre/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/theatre/v1/theatrev1connect"
	"github.com/ppusapati/health/code/internal/app"
	"github.com/ppusapati/health/code/internal/identity_access/adapters/devauth"
	orgpostgres "github.com/ppusapati/health/code/internal/organization/adapters/postgres"
	orgdomain "github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
	platformapitransport "github.com/ppusapati/health/code/internal/platform_api/transport"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Anaesthesia and recovery (SRS-ANE-001 … 011), end to end.
//
// The domain tests hold the rules. These hold what only the assembled stack
// shows: that a reading taken while the monitor was detached comes back marked
// untrustworthy through the wire, that a unit mismatch is refused until
// somebody says they meant it, that a recovery nurse cannot discharge a
// patient below the bar and an anaesthetist can, that nobody can discharge a
// patient who was never handed over, and that the summary is derived from the
// record rather than submitted alongside it.

type aneHarness struct {
	pool        *pgxpool.Pool
	anaesthesia anaesthesiav1connect.AnaesthesiaServiceClient
	theatre     theatrev1connect.TheatreServiceClient
	encounters  encounterv1connect.EncounterServiceClient
	patients    empiv1connect.PatientServiceClient
	org         organizationv1connect.OrganizationServiceClient

	tenantID string
	facility string
}

func newAneHarness(t *testing.T) *aneHarness {
	t.Helper()

	pool := pgtest.New(t)
	verifier, err := devauth.New(true)
	if err != nil {
		t.Fatalf("devauth.New: %v", err)
	}

	built := app.New(app.Deps{
		Pool: pool, Verifier: verifier,
		Build: platformapitransport.BuildInfo{Version: "test", Commit: "test", BuiltAt: "test"},
		RateLimit: platformtransport.RateLimitConfig{
			RequestsPerSecond: 10000, Burst: 10000,
			UnauthenticatedRequestsPerSecond: 10000, UnauthenticatedBurst: 10000,
		},
	})

	server := httptest.NewServer(h2c.NewHandler(built.Handler, &http2.Server{}))
	t.Cleanup(server.Close)

	h := &aneHarness{
		pool:        pool,
		anaesthesia: anaesthesiav1connect.NewAnaesthesiaServiceClient(server.Client(), server.URL),
		theatre:     theatrev1connect.NewTheatreServiceClient(server.Client(), server.URL),
		encounters:  encounterv1connect.NewEncounterServiceClient(server.Client(), server.URL),
		patients:    empiv1connect.NewPatientServiceClient(server.Client(), server.URL),
		org:         organizationv1connect.NewOrganizationServiceClient(server.Client(), server.URL),
	}

	tenant, err := h.org.CreateTenant(context.Background(),
		as(platformOperatorToken(), &organizationv1.CreateTenantRequest{
			DisplayName: "Apollo Group", LegalJurisdiction: "IN",
			DefaultLocale: "en-IN", TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateTenant: %v", err)
	}
	h.tenantID = tenant.Msg.GetTenant().GetTenantId()

	facility, err := h.org.CreateFacility(context.Background(),
		as(tenantAdminToken(h.tenantID), &organizationv1.CreateFacilityRequest{
			Code: "main", DisplayName: "Main Hospital",
			Type:     organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL,
			TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateFacility: %v", err)
	}
	h.facility = facility.Msg.GetFacility().GetFacilityId()

	for _, module := range []string{"empi", "encounter", "theatre", "anaesthesia"} {
		h.entitle(t, module)
	}
	return h
}

func (h *aneHarness) entitle(t *testing.T, module string) {
	t.Helper()

	repo := orgpostgres.New(pgtx.NewManager(h.pool))
	scope := authctx.NewSession(authctx.Session{
		SubjectID: "setup", TenantID: h.tenantID,
	}).TenantScope()

	now := time.Now().UTC()
	entitlement, err := orgdomain.NewEntitlement(uuid.NewString(), h.tenantID, "",
		module, true, now.Add(-time.Hour), time.Time{}, "setup", now)
	if err != nil {
		t.Fatalf("NewEntitlement: %v", err)
	}
	if err := repo.InsertEntitlement(context.Background(), scope, entitlement); err != nil {
		t.Fatalf("InsertEntitlement: %v", err)
	}
}

func (h *aneHarness) anaesthetistToken() string {
	return h.tenantID + ":anaes-1:anaesthetist:" + h.facility
}

func (h *aneHarness) surgeonToken() string {
	return h.tenantID + ":surgeon-1:clinician:" + h.facility
}

// A recovery nurse: scores and discharges a patient who meets the bar, and
// holds no override.
func (h *aneHarness) recoveryNurseToken() string {
	return h.tenantID + ":pacu-1:nurse:" + h.facility
}

func (h *aneHarness) clerkToken() string {
	return h.tenantID + ":clerk-1:registration_clerk:" + h.facility
}

// surgeryCase registers a patient, opens the encounter and raises the theatre
// case the anaesthetic hangs off.
func (h *aneHarness) surgeryCase(t *testing.T, phone string) (caseID, patientID string) {
	t.Helper()

	registered, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterPatientRequest{
			Demographics: demographics("Nair", []string{"Vikram"},
				date(1968, 3, 14), empiv1.Sex_SEX_MALE, phone),
		}))
	if err != nil {
		t.Fatalf("RegisterPatient: %v", err)
	}
	patientID = registered.Msg.GetPatient().GetPatientId()

	opened, err := h.encounters.OpenEncounter(context.Background(),
		withFacility(h.surgeonToken(), h.facility, &encounterv1.OpenEncounterRequest{
			PatientId: patientID, FacilityId: h.facility,
			Class:               encounterv1.EncounterClass_ENCOUNTER_CLASS_INPATIENT,
			AttendingProviderId: "surgeon-1", Reason: "for surgery",
			StartImmediately: true,
		}))
	if err != nil {
		t.Fatalf("OpenEncounter: %v", err)
	}

	requested, err := h.theatre.RequestSurgery(context.Background(),
		withFacility(h.surgeonToken(), h.facility, &theatrev1.RequestSurgeryRequest{
			EncounterId:   opened.Msg.GetEncounter().GetEncounterId(),
			FacilityId:    h.facility,
			ProcedureCode: "K80.2", ProcedureDisplay: "Cholecystectomy",
			DiagnosisCode: "K80.2", DiagnosisDisplay: "Gallstones",
			Laterality:              theatrev1.Laterality_LATERALITY_NOT_APPLICABLE,
			Urgency:                 theatrev1.Urgency_URGENCY_ELECTIVE,
			ExpectedDurationSeconds: 5400,
			SurgeonId:               "surgeon-1",
		}))
	if err != nil {
		t.Fatalf("RequestSurgery: %v", err)
	}
	return requested.Msg.GetSurgicalCase().GetCaseId(), patientID
}

// assess records a complete pre-anaesthesia assessment.
func (h *aneHarness) assess(t *testing.T, caseID, patientID string,
	mutate func(*anaesthesiav1.RecordAssessmentRequest)) *anaesthesiav1.Assessment {

	t.Helper()

	req := &anaesthesiav1.RecordAssessmentRequest{
		CaseId: caseID, PatientId: patientID,
		History: "hypertension, ex-smoker",
		Airway: &anaesthesiav1.AirwayAssessment{
			Mallampati: "III", MouthOpeningMm: 32, ThyromentalMm: 55,
			PredictedDifficult: true,
		},
		AsaGrade:     "3E",
		Risks:        []string{"sore throat", "dental damage"},
		Consent:      anaesthesiav1.ConsentStatus_CONSENT_STATUS_OBTAINED,
		FitToProceed: true,
		Conditions:   []string{"difficult airway trolley in theatre"},
	}
	if mutate != nil {
		mutate(req)
	}

	out, err := h.anaesthesia.RecordAssessment(context.Background(),
		withFacility(h.anaesthetistToken(), h.facility, req))
	if err != nil {
		t.Fatalf("RecordAssessment: %v", err)
	}
	return out.Msg.GetAssessment()
}

// openRecord starts the intraoperative record.
func (h *aneHarness) openRecord(t *testing.T, caseID string) string {
	t.Helper()

	out, err := h.anaesthesia.OpenRecord(context.Background(),
		withFacility(h.anaesthetistToken(), h.facility,
			&anaesthesiav1.OpenRecordRequest{
				CaseId:    caseID,
				Technique: anaesthesiav1.Technique_TECHNIQUE_GENERAL,
			}))
	if err != nil {
		t.Fatalf("OpenRecord: %v", err)
	}
	return out.Msg.GetRecord().GetRecordId()
}

// SRS-ANE-001, SRS-ANE-002. The assessment is versioned, and the theatre's
// readiness projection follows the assessment in force rather than the first.
func TestReassessmentChangesWhatTheTheatreSees(t *testing.T) {
	h := newAneHarness(t)
	caseID, patientID := h.surgeryCase(t, "+91-99000-55001")
	h.assess(t, caseID, patientID, nil)

	ready, err := h.anaesthesia.GetReadiness(context.Background(),
		withFacility(h.anaesthetistToken(), h.facility,
			&anaesthesiav1.GetReadinessRequest{CaseId: caseID}))
	if err != nil {
		t.Fatalf("GetReadiness: %v", err)
	}
	if !ready.Msg.GetReadiness().GetFit() {
		t.Fatal("the patient reads as unfit after a fit assessment")
	}
	if !ready.Msg.GetReadiness().GetDifficultAirway() {
		t.Error("the difficult-airway prediction did not reach the checklist; " +
			"the equipment for it lives somewhere else and somebody has to fetch it")
	}

	// A fortnight later, a chest infection.
	h.assess(t, caseID, patientID, func(req *anaesthesiav1.RecordAssessmentRequest) {
		req.AsaGrade = "4"
		req.FitToProceed = false
		req.Conditions = []string{"chest infection: postpone two weeks"}
	})

	all, err := h.anaesthesia.ListAssessments(context.Background(),
		withFacility(h.anaesthetistToken(), h.facility,
			&anaesthesiav1.ListAssessmentsRequest{CaseId: caseID}))
	if err != nil {
		t.Fatalf("ListAssessments: %v", err)
	}
	if len(all.Msg.GetAssessments()) != 2 {
		t.Fatalf("versions = %d, want 2; the clinic assessment must survive",
			len(all.Msg.GetAssessments()))
	}
	if all.Msg.GetAssessments()[0].GetCurrent() {
		t.Error("the superseded assessment is still current")
	}
	if all.Msg.GetAssessments()[0].GetAsaGrade() != "3E" {
		t.Errorf("the earlier grade was overwritten: %q",
			all.Msg.GetAssessments()[0].GetAsaGrade())
	}

	ready, err = h.anaesthesia.GetReadiness(context.Background(),
		withFacility(h.anaesthetistToken(), h.facility,
			&anaesthesiav1.GetReadinessRequest{CaseId: caseID}))
	if err != nil {
		t.Fatalf("GetReadiness: %v", err)
	}
	if ready.Msg.GetReadiness().GetFit() {
		t.Fatal("the theatre still sees a fit patient after the reassessment")
	}
	if len(ready.Msg.GetReadiness().GetOutstanding()) == 0 {
		t.Error("the checklist shows no reason the patient is not ready")
	}
}

// SRS-ANE-003, SRS-ANE-005. A value taken while the monitor was detached
// arrives marked untrustworthy, without the client having to know the rule.
func TestADisconnectedMonitorsReadingArrivesMarked(t *testing.T) {
	h := newAneHarness(t)
	caseID, patientID := h.surgeryCase(t, "+91-99000-55002")
	h.assess(t, caseID, patientID, nil)
	recordID := h.openRecord(t, caseID)
	ctx := context.Background()

	readings := []struct {
		value     float64
		connected bool
	}{{118, true}, {41, false}}
	for i, reading := range readings {
		if _, err := h.anaesthesia.ChartVital(ctx,
			withFacility(h.anaesthetistToken(), h.facility,
				&anaesthesiav1.ChartVitalRequest{
					RecordId: recordID, Code: "nibp_systolic",
					Value: reading.value, Unit: "mmHg",
					Source: anaesthesiav1.EntrySource_ENTRY_SOURCE_DEVICE,
					Device: &anaesthesiav1.DeviceLink{
						DeviceId: "monitor-7", Model: "IntelliVue MX550",
						Connected: reading.connected,
					},
					ObservedAt: timestamppb.New(
						time.Now().Add(time.Duration(i) * time.Minute)),
				})); err != nil {
			t.Fatalf("ChartVital: %v", err)
		}
	}

	chart, err := h.anaesthesia.ListVitals(ctx,
		withFacility(h.anaesthetistToken(), h.facility,
			&anaesthesiav1.ListVitalsRequest{RecordId: recordID}))
	if err != nil {
		t.Fatalf("ListVitals: %v", err)
	}
	entries := chart.Msg.GetEntries()
	if len(entries) != 2 {
		t.Fatalf("entries = %d, want 2", len(entries))
	}
	if !entries[0].GetTrustworthy() {
		t.Error("a connected reading arrived untrustworthy")
	}
	if entries[1].GetTrustworthy() {
		t.Error("a 41 systolic from a detached cuff arrived trendable; that " +
			"starts a resuscitation nobody needs")
	}
	if entries[1].GetDevice().GetConnected() {
		t.Error("the connection state was lost on the wire")
	}
}

// SRS-ANE-004. A dose in the wrong unit family is refused until somebody says
// they meant it, and the acknowledgement is recorded rather than silent.
func TestAUnitMismatchIsRefusedUntilItIsAcknowledged(t *testing.T) {
	h := newAneHarness(t)
	caseID, patientID := h.surgeryCase(t, "+91-99000-55003")
	h.assess(t, caseID, patientID, nil)
	recordID := h.openRecord(t, caseID)
	ctx := context.Background()

	req := &anaesthesiav1.ChartDrugRequest{
		RecordId: recordID, DrugCode: "morphine", DrugDisplay: "Morphine",
		Route: "iv", Dose: 5, DoseUnit: "mL",
		Source: anaesthesiav1.EntrySource_ENTRY_SOURCE_MANUAL,
		// The formulary doses morphine by mass.
		ExpectedUnit: "mg",
	}

	_, err := h.anaesthesia.ChartDrug(ctx,
		withFacility(h.anaesthetistToken(), h.facility, req))
	if err == nil {
		t.Fatal("5 mL of morphine charted against a formulary that doses in mg")
	}
	if !strings.Contains(err.Error(), "mg") {
		t.Errorf("the refusal does not say what the drug is dosed in: %v", err)
	}

	req.AcknowledgedMismatch = true
	entry, err := h.anaesthesia.ChartDrug(ctx,
		withFacility(h.anaesthetistToken(), h.facility, req))
	if err != nil {
		t.Fatalf("ChartDrug after acknowledgement: %v", err)
	}
	if entry.Msg.GetEntry().GetDoseUnit() != "mL" {
		t.Errorf("the unit was rewritten to %q", entry.Msg.GetEntry().GetDoseUnit())
	}

	// The acknowledgement is in the audit trail, not merely in the refusal
	// that did not happen.
	var reasons int
	if err := h.pool.QueryRow(ctx, `
		SELECT count(*) FROM platform_data.audit_record
		WHERE tenant_id = $1 AND reason LIKE 'unit mismatch acknowledged%'`,
		h.tenantID).Scan(&reasons); err != nil {
		t.Fatalf("audit query: %v", err)
	}
	if reasons != 1 {
		t.Errorf("audit rows for the acknowledged mismatch = %d, want 1", reasons)
	}
}

// SRS-ANE-006. The difficult airway follows the patient, not the record.
func TestTheDifficultAirwayIsReadableFromTheNextAdmission(t *testing.T) {
	h := newAneHarness(t)
	caseID, patientID := h.surgeryCase(t, "+91-99000-55004")
	h.assess(t, caseID, patientID, nil)
	recordID := h.openRecord(t, caseID)
	ctx := context.Background()

	attempts := []struct {
		attempt    int32
		device     string
		successful bool
	}{
		{1, "macintosh 3", false},
		{2, "macintosh 4", false},
		{3, "videolaryngoscope", true},
	}
	for _, a := range attempts {
		if _, err := h.anaesthesia.RecordAirway(ctx,
			withFacility(h.anaesthetistToken(), h.facility,
				&anaesthesiav1.RecordAirwayRequest{
					RecordId: recordID, Device: a.device, Attempt: a.attempt,
					Grade: "3", Successful: a.successful,
					Adjuncts: []string{"bougie"},
				})); err != nil {
			t.Fatalf("RecordAirway %d: %v", a.attempt, err)
		}
	}

	// The read a surgeon or another anaesthetist makes months later, by
	// patient rather than by record.
	history, err := h.anaesthesia.GetPatientAirway(ctx,
		withFacility(h.surgeonToken(), h.facility,
			&anaesthesiav1.GetPatientAirwayRequest{PatientId: patientID}))
	if err != nil {
		t.Fatalf("GetPatientAirway: %v", err)
	}
	if !history.Msg.GetAirway().GetDifficult() {
		t.Fatal("three attempts read as an easy airway from the patient's history")
	}
	if history.Msg.GetAirway().GetFinalDevice() != "videolaryngoscope" {
		t.Errorf("final device = %q; the next anaesthetist needs to know what "+
			"worked, not only that it was hard",
			history.Msg.GetAirway().GetFinalDevice())
	}

	// And the event that tells the systems outside this one.
	var difficult int
	if err := h.pool.QueryRow(ctx, `
		SELECT count(*) FROM platform_data.outbox_event
		WHERE tenant_id = $1 AND event_type = 'anaesthesia_airway.difficult'`,
		h.tenantID).Scan(&difficult); err != nil {
		t.Fatalf("outbox query: %v", err)
	}
	if difficult == 0 {
		t.Error("no difficult-airway event was published")
	}
}

// SRS-ANE-008. A patient nobody handed over cannot leave recovery, and the
// override does not reach that refusal.
func TestNobodyDischargesAPatientWhoWasNeverHandedOver(t *testing.T) {
	h := newAneHarness(t)
	caseID, patientID := h.surgeryCase(t, "+91-99000-55005")
	h.assess(t, caseID, patientID, nil)
	recordID := h.openRecord(t, caseID)
	ctx := context.Background()

	decision, err := h.anaesthesia.EvaluateDischarge(ctx,
		withFacility(h.recoveryNurseToken(), h.facility,
			&anaesthesiav1.EvaluateDischargeRequest{RecordId: recordID}))
	if err != nil {
		t.Fatalf("EvaluateDischarge: %v", err)
	}
	if decision.Msg.GetDecision().GetAllowed() {
		t.Fatal("a patient nobody handed over may leave recovery")
	}
	// Every refusal, not the first: a nurse who fixes one and is then told
	// about the next has been made to discover the requirements one at a time.
	if len(decision.Msg.GetDecision().GetRefusals()) < 2 {
		t.Errorf("refusals = %v, want the handover and the missing score both",
			decision.Msg.GetDecision().GetRefusals())
	}

	_, err = h.anaesthesia.DischargeFromRecovery(ctx,
		withFacility(h.anaesthetistToken(), h.facility,
			&anaesthesiav1.DischargeFromRecoveryRequest{
				RecordId: recordID, Destination: "ward 7",
				OverrideReason: "consultant says fine",
			}))
	if err == nil {
		t.Fatal("an anaesthetist overrode a missing handover; the override " +
			"exists for a patient who is ready and scores low, not for one " +
			"nobody has taken responsibility for")
	}
}

// SRS-ANE-008. The recovery nurse discharges a patient who meets the bar, and
// cannot discharge one who does not. The anaesthetist can, with a reason.
func TestOnlyAnAnaesthetistDischargesBelowTheBar(t *testing.T) {
	h := newAneHarness(t)
	caseID, patientID := h.surgeryCase(t, "+91-99000-55006")
	h.assess(t, caseID, patientID, nil)
	recordID := h.openRecord(t, caseID)
	ctx := context.Background()

	if _, err := h.anaesthesia.EndAnaesthesia(ctx,
		withFacility(h.anaesthetistToken(), h.facility,
			&anaesthesiav1.EndAnaesthesiaRequest{RecordId: recordID})); err != nil {
		t.Fatalf("EndAnaesthesia: %v", err)
	}
	if _, err := h.anaesthesia.HandOver(ctx,
		withFacility(h.anaesthetistToken(), h.facility,
			&anaesthesiav1.HandOverRequest{
				RecordId: recordID, ToClinician: "pacu-1",
				Summary:        "GA, difficult intubation third attempt",
				AnalgesiaGiven: []string{"morphine 10mg"},
			})); err != nil {
		t.Fatalf("HandOver: %v", err)
	}

	scale, err := h.anaesthesia.GetRecoveryScale(ctx,
		withFacility(h.recoveryNurseToken(), h.facility,
			&anaesthesiav1.GetRecoveryScaleRequest{}))
	if err != nil {
		t.Fatalf("GetRecoveryScale: %v", err)
	}

	// A score every component was marked down on: complete, but below the bar.
	low := map[string]int32{}
	for _, component := range scale.Msg.GetScale().GetComponents() {
		low[component.GetCode()] = 1
	}
	assessed, err := h.anaesthesia.AssessRecovery(ctx,
		withFacility(h.recoveryNurseToken(), h.facility,
			&anaesthesiav1.AssessRecoveryRequest{RecordId: recordID, Scores: low}))
	if err != nil {
		t.Fatalf("AssessRecovery: %v", err)
	}
	if assessed.Msg.GetAssessment().GetMeetsThreshold() {
		t.Fatal("a score of one per component met the discharge threshold")
	}
	if !assessed.Msg.GetAssessment().GetComplete() {
		t.Error("a fully scored assessment came back incomplete")
	}

	_, err = h.anaesthesia.DischargeFromRecovery(ctx,
		withFacility(h.recoveryNurseToken(), h.facility,
			&anaesthesiav1.DischargeFromRecoveryRequest{
				RecordId: recordID, Destination: "ward 7",
				OverrideReason: "he seems fine",
			}))
	if err == nil {
		t.Fatal("a recovery nurse discharged a patient below the bar")
	}

	discharge, err := h.anaesthesia.DischargeFromRecovery(ctx,
		withFacility(h.anaesthetistToken(), h.facility,
			&anaesthesiav1.DischargeFromRecoveryRequest{
				RecordId: recordID, Destination: "ward 7",
				OverrideReason: "baseline neurology; reviewed by the consultant",
			}))
	if err != nil {
		t.Fatalf("DischargeFromRecovery: %v", err)
	}
	if !discharge.Msg.GetDischarge().GetOverridden() {
		t.Error("the discharge is not marked as an override")
	}
	if discharge.Msg.GetDischarge().GetScoreId() == "" {
		t.Error("the discharge does not name the score it was made against; " +
			"a review would have to take the claim on trust")
	}

	// SRS-ANE-010. The summary is derived, and the override is on its face.
	summary, err := h.anaesthesia.GetSummary(ctx,
		withFacility(h.surgeonToken(), h.facility,
			&anaesthesiav1.GetSummaryRequest{RecordId: recordID}))
	if err != nil {
		t.Fatalf("GetSummary: %v", err)
	}
	if !summary.Msg.GetSummary().GetDischargeOverridden() {
		t.Error("the summary does not show the override; it is the one thing " +
			"a reader must not have to dig for")
	}
	if summary.Msg.GetSummary().GetAsaGrade() != "3E" {
		t.Errorf("summary ASA grade = %q, want 3E",
			summary.Msg.GetSummary().GetAsaGrade())
	}
	if summary.Msg.GetSummary().GetDisposal() != "ward 7" {
		t.Errorf("summary disposal = %q", summary.Msg.GetSummary().GetDisposal())
	}
}

// SRS-ANE-007, SRS-ANE-010. The summary carries the fluid balance the handover
// asks about, and names what it could not be built from.
func TestTheSummaryNamesWhatItCouldNotBeBuiltFrom(t *testing.T) {
	h := newAneHarness(t)
	caseID, patientID := h.surgeryCase(t, "+91-99000-55007")
	h.assess(t, caseID, patientID, nil)
	recordID := h.openRecord(t, caseID)
	ctx := context.Background()

	fluids := []*anaesthesiav1.ChartFluidRequest{
		{RecordId: recordID, Direction: anaesthesiav1.FluidDirection_FLUID_DIRECTION_IN,
			Kind: "crystalloid", Label: "Hartmann's", VolumeMl: 1500},
		{RecordId: recordID, Direction: anaesthesiav1.FluidDirection_FLUID_DIRECTION_IN,
			Kind: "transfusion", Label: "red cells", VolumeMl: 280,
			ProductId: "G123456"},
		{RecordId: recordID, Direction: anaesthesiav1.FluidDirection_FLUID_DIRECTION_OUT,
			Kind: "blood_loss", VolumeMl: 900},
	}
	for _, req := range fluids {
		if _, err := h.anaesthesia.ChartFluid(ctx,
			withFacility(h.anaesthetistToken(), h.facility, req)); err != nil {
			t.Fatalf("ChartFluid: %v", err)
		}
	}

	balance, err := h.anaesthesia.GetBalance(ctx,
		withFacility(h.anaesthetistToken(), h.facility,
			&anaesthesiav1.GetBalanceRequest{RecordId: recordID}))
	if err != nil {
		t.Fatalf("GetBalance: %v", err)
	}
	if got := balance.Msg.GetBalance().GetBloodLossMl(); got != 900 {
		t.Errorf("blood loss = %g, want 900", got)
	}
	if got := balance.Msg.GetBalance().GetTransfusedMl(); got != 280 {
		t.Errorf("transfused = %g, want 280", got)
	}

	// The patient is still in theatre: no end, no score, no discharge.
	summary, err := h.anaesthesia.GetSummary(ctx,
		withFacility(h.anaesthetistToken(), h.facility,
			&anaesthesiav1.GetSummaryRequest{RecordId: recordID}))
	if err != nil {
		t.Fatalf("GetSummary: %v", err)
	}
	incomplete := summary.Msg.GetSummary().GetIncomplete()
	if len(incomplete) != 3 {
		t.Errorf("incomplete = %v; want the end of anaesthesia, the recovery "+
			"score and the discharge, all named rather than quietly omitted",
			incomplete)
	}
}

// SRS-ANE-009. The pain plan names the prescriptions rather than being one,
// and the round is soonest-review-first.
func TestThePainPlanNamesThePrescriptionRatherThanBeingOne(t *testing.T) {
	h := newAneHarness(t)
	caseID, patientID := h.surgeryCase(t, "+91-99000-55008")
	h.assess(t, caseID, patientID, nil)
	recordID := h.openRecord(t, caseID)
	ctx := context.Background()

	// A plan with nothing to monitor is one nursing cannot follow.
	if _, err := h.anaesthesia.OrderPain(ctx,
		withFacility(h.anaesthetistToken(), h.facility,
			&anaesthesiav1.OrderPainRequest{
				RecordId: recordID, Modality: "PCA morphine",
				Escalation: "call the on-call anaesthetist",
			})); err == nil {
		t.Fatal("a pain plan with nothing to monitor was accepted")
	}

	ordered, err := h.anaesthesia.OrderPain(ctx,
		withFacility(h.anaesthetistToken(), h.facility,
			&anaesthesiav1.OrderPainRequest{
				RecordId: recordID, Modality: "PCA morphine",
				PrescriptionIds: []string{"rx-1"},
				TargetScore:     "≤3 on movement",
				Monitoring: []string{
					"sedation score hourly", "respiratory rate hourly"},
				Escalation: "call the on-call anaesthetist if sedation ≥ 2",
				ReviewBy:   timestamppb.New(time.Now().Add(4 * time.Hour)),
			}))
	if err != nil {
		t.Fatalf("OrderPain: %v", err)
	}
	if len(ordered.Msg.GetOrder().GetPrescriptionIds()) != 1 {
		t.Error("the prescription link was lost; the plan would have to be " +
			"prescribed a second time, which is how a patient gets two doses")
	}

	round, err := h.anaesthesia.GetPainRound(ctx,
		withFacility(h.recoveryNurseToken(), h.facility,
			&anaesthesiav1.GetPainRoundRequest{}))
	if err != nil {
		t.Fatalf("GetPainRound: %v", err)
	}
	if len(round.Msg.GetOrders()) != 1 {
		t.Fatalf("round = %d plans, want 1", len(round.Msg.GetOrders()))
	}
	if round.Msg.GetOrders()[0].GetReviewOverdue() {
		t.Error("a plan due for review in four hours reads as overdue")
	}

	if _, err := h.anaesthesia.StopPain(ctx,
		withFacility(h.anaesthetistToken(), h.facility,
			&anaesthesiav1.StopPainRequest{
				OrderId: ordered.Msg.GetOrder().GetOrderId(),
			})); err != nil {
		t.Fatalf("StopPain: %v", err)
	}
	round, err = h.anaesthesia.GetPainRound(ctx,
		withFacility(h.recoveryNurseToken(), h.facility,
			&anaesthesiav1.GetPainRoundRequest{}))
	if err != nil {
		t.Fatalf("GetPainRound: %v", err)
	}
	if len(round.Msg.GetOrders()) != 0 {
		t.Errorf("a stopped plan is still on the round: %d", len(round.Msg.GetOrders()))
	}
}

// SRS-ANE-011. A record transcribed from paper needs its own permission and
// arrives marked. A charting permission does not reach it.
func TestADowntimeImportNeedsItsOwnPermission(t *testing.T) {
	h := newAneHarness(t)
	caseID, patientID := h.surgeryCase(t, "+91-99000-55009")
	h.assess(t, caseID, patientID, nil)
	ctx := context.Background()

	// A recovery nurse holds ane.recovery.write and neither charting nor
	// import.
	if _, err := h.anaesthesia.OpenRecord(ctx,
		withFacility(h.recoveryNurseToken(), h.facility,
			&anaesthesiav1.OpenRecordRequest{
				CaseId:     caseID,
				Technique:  anaesthesiav1.Technique_TECHNIQUE_GENERAL,
				Origin:     anaesthesiav1.EntrySource_ENTRY_SOURCE_IMPORTED,
				ImportNote: "from the paper chart",
			})); err == nil {
		t.Fatal("a recovery nurse transcribed a backdated anaesthetic record")
	}

	// And an import with no note is refused whoever asks.
	if _, err := h.anaesthesia.OpenRecord(ctx,
		withFacility(h.anaesthetistToken(), h.facility,
			&anaesthesiav1.OpenRecordRequest{
				CaseId:    caseID,
				Technique: anaesthesiav1.Technique_TECHNIQUE_GENERAL,
				Origin:    anaesthesiav1.EntrySource_ENTRY_SOURCE_IMPORTED,
			})); err == nil {
		t.Fatal("an import with no provenance was accepted")
	}

	imported, err := h.anaesthesia.OpenRecord(ctx,
		withFacility(h.anaesthetistToken(), h.facility,
			&anaesthesiav1.OpenRecordRequest{
				CaseId:     caseID,
				Technique:  anaesthesiav1.Technique_TECHNIQUE_GENERAL,
				Origin:     anaesthesiav1.EntrySource_ENTRY_SOURCE_IMPORTED,
				ImportNote: "transcribed from the paper chart after the 14:00 outage",
				StartedAt:  timestamppb.New(time.Now().Add(-6 * time.Hour)),
			}))
	if err != nil {
		t.Fatalf("OpenRecord imported: %v", err)
	}
	record := imported.Msg.GetRecord()
	if record.GetOrigin() != anaesthesiav1.EntrySource_ENTRY_SOURCE_IMPORTED {
		t.Errorf("origin = %v; a reconstructed record that did not say so "+
			"would read as a contemporaneous one", record.GetOrigin())
	}
	if record.GetImportedBy() == "" || record.GetImportedAt() == nil {
		t.Errorf("import provenance incomplete: %+v", record)
	}

	// One record per case: a second is the same anaesthetic charted twice.
	if _, err := h.anaesthesia.OpenRecord(ctx,
		withFacility(h.anaesthetistToken(), h.facility,
			&anaesthesiav1.OpenRecordRequest{
				CaseId:    caseID,
				Technique: anaesthesiav1.Technique_TECHNIQUE_SPINAL,
			})); err == nil {
		t.Fatal("a second anaesthetic record was opened for the same case")
	}
}

// A surgeon reads the anaesthetic and writes none of it.
func TestASurgeonCannotDeclareTheirOwnPatientFit(t *testing.T) {
	h := newAneHarness(t)
	caseID, patientID := h.surgeryCase(t, "+91-99000-55010")
	ctx := context.Background()

	if _, err := h.anaesthesia.RecordAssessment(ctx,
		withFacility(h.surgeonToken(), h.facility,
			&anaesthesiav1.RecordAssessmentRequest{
				CaseId: caseID, PatientId: patientID, AsaGrade: "1",
				Consent:      anaesthesiav1.ConsentStatus_CONSENT_STATUS_OBTAINED,
				FitToProceed: true,
			})); err == nil {
		t.Fatal("a surgeon recorded the pre-anaesthesia assessment")
	}

	h.assess(t, caseID, patientID, nil)
	if _, err := h.anaesthesia.ListAssessments(ctx,
		withFacility(h.surgeonToken(), h.facility,
			&anaesthesiav1.ListAssessmentsRequest{CaseId: caseID})); err != nil {
		t.Fatalf("a surgeon cannot read the assessment of their own patient: %v", err)
	}
}

// Gate A2. Another tenant reaches none of it, at the RPC boundary.
func TestAnotherTenantSeesNoAnaesthetic(t *testing.T) {
	h := newAneHarness(t)
	caseID, patientID := h.surgeryCase(t, "+91-99000-55011")
	h.assess(t, caseID, patientID, nil)
	recordID := h.openRecord(t, caseID)
	ctx := context.Background()

	other := uuid.NewString() + ":anaes-9:anaesthetist:" + h.facility

	if _, err := h.anaesthesia.GetRecord(ctx,
		as(other, &anaesthesiav1.GetRecordRequest{RecordId: recordID})); err == nil {
		t.Error("another tenant read the anaesthetic record")
	}
	if _, err := h.anaesthesia.GetSummary(ctx,
		as(other, &anaesthesiav1.GetSummaryRequest{RecordId: recordID})); err == nil {
		t.Error("another tenant read the anaesthetic summary")
	}
	// A list read across tenants returns nothing rather than erroring — a
	// refusal would confirm the patient exists — so what is asserted is that
	// it is empty.
	airway, err := h.anaesthesia.GetPatientAirway(ctx,
		as(other, &anaesthesiav1.GetPatientAirwayRequest{PatientId: patientID}))
	if err == nil && airway.Msg.GetAirway().GetAttempts() != 0 {
		t.Errorf("another tenant read %d airway attempts",
			airway.Msg.GetAirway().GetAttempts())
	}
}
