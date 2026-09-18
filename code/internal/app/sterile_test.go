package app_test

import (
	"context"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	empiv1 "github.com/ppusapati/health/code/gen/go/healthcare/empi/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/empi/v1/empiv1connect"
	encounterv1 "github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1/encounterv1connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	sterilev1 "github.com/ppusapati/health/code/gen/go/healthcare/sterile/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/sterile/v1/sterilev1connect"
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
	sterileapp "github.com/ppusapati/health/code/internal/sterile/application"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Sterile services / CSSD (SRS-CSSD-001 … 012), end to end.
//
// The domain tests hold the stage sequence and the release rules. These hold
// what only the assembled stack shows: that a technician cannot skip a stage
// and a supervisor can, that a load nobody read an indicator for cannot be
// released whoever asks, that an expired pack cannot be issued even though it
// was released, that a revision does not change what an earlier pack was
// checked against, and that a recall reaches the wards holding the packs and
// the cases already opened.

type cssdHarness struct {
	pool       *pgxpool.Pool
	cssd       sterilev1connect.SterileServicesServiceClient
	theatre    theatrev1connect.TheatreServiceClient
	encounters encounterv1connect.EncounterServiceClient
	patients   empiv1connect.PatientServiceClient
	org        organizationv1connect.OrganizationServiceClient

	tenantID string
	facility string
}

func newCssdHarness(t *testing.T) *cssdHarness {
	return newCssdHarnessWith(t, sterileapp.Config{
		DefaultShelfLife: 30 * 24 * time.Hour,
	})
}

func newCssdHarnessWith(t *testing.T, config sterileapp.Config) *cssdHarness {
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
		Sterile: config,
	})

	server := httptest.NewServer(h2c.NewHandler(built.Handler, &http2.Server{}))
	t.Cleanup(server.Close)

	h := &cssdHarness{
		pool:       pool,
		cssd:       sterilev1connect.NewSterileServicesServiceClient(server.Client(), server.URL),
		theatre:    theatrev1connect.NewTheatreServiceClient(server.Client(), server.URL),
		encounters: encounterv1connect.NewEncounterServiceClient(server.Client(), server.URL),
		patients:   empiv1connect.NewPatientServiceClient(server.Client(), server.URL),
		org:        organizationv1connect.NewOrganizationServiceClient(server.Client(), server.URL),
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

	for _, module := range []string{"empi", "encounter", "theatre", "sterile"} {
		h.entitle(t, module)
	}
	return h
}

func (h *cssdHarness) entitle(t *testing.T, module string) {
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

func (h *cssdHarness) technicianToken() string {
	return h.tenantID + ":tech-1:sterile_technician:" + h.facility
}

func (h *cssdHarness) supervisorToken() string {
	return h.tenantID + ":super-1:sterile_supervisor:" + h.facility
}

func (h *cssdHarness) surgeonToken() string {
	return h.tenantID + ":surgeon-1:clinician:" + h.facility
}

func (h *cssdHarness) clerkToken() string {
	return h.tenantID + ":clerk-1:registration_clerk:" + h.facility
}

// defineSet publishes a packing list. The retractor is critical; the swabs are
// not, which is what separates a delay from a cancelled case.
func (h *cssdHarness) defineSet(t *testing.T, code string,
	shelfLifeSeconds int64) *sterilev1.TraySet {

	t.Helper()

	out, err := h.cssd.DefineSet(context.Background(),
		withFacility(h.supervisorToken(), h.facility, &sterilev1.DefineSetRequest{
			Code: code, Display: "Laparotomy set", Kind: "tray",
			Items: []*sterilev1.PackingItem{
				{Code: "SCALPEL-H", Display: "Blade handle", Quantity: 1, Critical: true},
				{Code: "RETRACT-M", Display: "Retractor", Quantity: 2, Critical: true},
				{Code: "SWAB-CL", Display: "Swab clamp", Quantity: 4},
			},
			ShelfLifeSeconds: shelfLifeSeconds,
		}))
	if err != nil {
		t.Fatalf("DefineSet(%q): %v", code, err)
	}
	return out.Msg.GetSet()
}

func fullCount() map[string]int32 {
	return map[string]int32{"SCALPEL-H": 1, "RETRACT-M": 2, "SWAB-CL": 4}
}

// surgeryCase produces an operation the theatre knows, which is what a case
// trace and a source-case receipt are checked against.
func (h *cssdHarness) surgeryCase(t *testing.T, phone string) string {
	t.Helper()

	registered, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterPatientRequest{
			Demographics: demographics("Nair", []string{"Vikram"},
				date(1968, 3, 14), empiv1.Sex_SEX_MALE, phone),
		}))
	if err != nil {
		t.Fatalf("RegisterPatient: %v", err)
	}

	opened, err := h.encounters.OpenEncounter(context.Background(),
		withFacility(h.surgeonToken(), h.facility, &encounterv1.OpenEncounterRequest{
			PatientId:           registered.Msg.GetPatient().GetPatientId(),
			FacilityId:          h.facility,
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
	return requested.Msg.GetSurgicalCase().GetCaseId()
}

// reprocess takes a set from the dirty counter to a packaged pack.
func (h *cssdHarness) reprocess(t *testing.T, setCode string) string {
	t.Helper()
	ctx := context.Background()

	received, err := h.cssd.Receive(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.ReceiveRequest{
			SetCode: setCode, SourceUnit: "Theatre 2", Counted: fullCount(),
		}))
	if err != nil {
		t.Fatalf("Receive: %v", err)
	}
	runID := received.Msg.GetRun().GetRunId()

	for _, stage := range []sterilev1.Stage{
		sterilev1.Stage_STAGE_DECONTAMINATED,
		sterilev1.Stage_STAGE_WASHED,
		sterilev1.Stage_STAGE_INSPECTED,
	} {
		if _, err := h.cssd.Advance(ctx,
			withFacility(h.technicianToken(), h.facility, &sterilev1.AdvanceRequest{
				RunId: runID, Stage: stage, Equipment: "Washer 1",
			})); err != nil {
			t.Fatalf("Advance(%v): %v", stage, err)
		}
	}

	if _, err := h.cssd.Assemble(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.AssembleRequest{
			RunId: runID, Packed: fullCount(),
		})); err != nil {
		t.Fatalf("Assemble: %v", err)
	}

	if _, err := h.cssd.Package(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.PackageRequest{
			RunId: runID, Method: "wrapped", IndicatorType: "class 4 strip",
		})); err != nil {
		t.Fatalf("Package: %v", err)
	}
	return runID
}

// sterilise runs a load, reads a passing chemical indicator and releases it.
func (h *cssdHarness) sterilise(t *testing.T, loadNumber string,
	runIDs ...string) string {

	t.Helper()
	ctx := context.Background()

	started, err := h.cssd.StartCycle(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.StartCycleRequest{
			Machine: "Autoclave 1", LoadNumber: loadNumber, Program: "134C",
			Parameters: map[string]float64{"temperature_c": 134, "hold_s": 210},
			Source:     sterilev1.CycleSource_CYCLE_SOURCE_INGESTED,
		}))
	if err != nil {
		t.Fatalf("StartCycle: %v", err)
	}
	cycleID := started.Msg.GetCycle().GetCycleId()

	if _, err := h.cssd.LoadCycle(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.LoadCycleRequest{
			CycleId: cycleID, RunIds: runIDs,
		})); err != nil {
		t.Fatalf("LoadCycle: %v", err)
	}

	if _, err := h.cssd.FinishCycle(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.FinishCycleRequest{
			CycleId: cycleID, Result: sterilev1.CycleResult_CYCLE_RESULT_PASSED,
		})); err != nil {
		t.Fatalf("FinishCycle: %v", err)
	}

	if _, err := h.cssd.RecordIndicator(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.RecordIndicatorRequest{
			CycleId: cycleID, Kind: sterilev1.IndicatorKind_INDICATOR_KIND_CHEMICAL,
			Lot: "CI-2026-04", Passed: true,
		})); err != nil {
		t.Fatalf("RecordIndicator: %v", err)
	}

	if _, err := h.cssd.ReleaseLoad(ctx,
		withFacility(h.supervisorToken(), h.facility, &sterilev1.ReleaseLoadRequest{
			CycleId: cycleID, Note: "parameters and indicator reviewed",
		})); err != nil {
		t.Fatalf("ReleaseLoad: %v", err)
	}
	return cycleID
}

// SRS-CSSD-001 … 010: a set goes round once, and the record follows it.
func TestASetIsReprocessedIssuedAndTracedBackFromTheCase(t *testing.T) {
	h := newCssdHarness(t)
	ctx := context.Background()

	h.defineSet(t, "LAP-01", 0)
	runID := h.reprocess(t, "LAP-01")
	h.sterilise(t, "L-101", runID)

	// The label is derived from the record, and it is complete.
	label, err := h.cssd.GetLabel(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.GetLabelRequest{
			RunId: runID,
		}))
	if err != nil {
		t.Fatalf("GetLabel: %v", err)
	}
	if got := label.Msg.GetLabel(); len(got.GetIncomplete()) > 0 {
		t.Errorf("a fully processed pack has an incomplete label: %v",
			got.GetIncomplete())
	}
	if label.Msg.GetLabel().GetLoadNumber() != "L-101" {
		t.Errorf("label load number = %q, want L-101",
			label.Msg.GetLabel().GetLoadNumber())
	}
	if label.Msg.GetLabel().GetExpiresAt() == nil {
		t.Error("the label carries no expiry; a pack with none never goes out of date")
	}

	// It is on the shelf and issuable.
	shelf, err := h.cssd.GetShelf(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.GetShelfRequest{
			SetCode: "LAP-01",
		}))
	if err != nil {
		t.Fatalf("GetShelf: %v", err)
	}
	if len(shelf.Msg.GetRuns()) != 1 || !shelf.Msg.GetRuns()[0].GetIssuable() {
		t.Fatalf("shelf = %d pack(s), issuable = %v; want one issuable pack",
			len(shelf.Msg.GetRuns()), shelf.Msg.GetRuns()[0].GetIssuable())
	}

	issued, err := h.cssd.IssuePack(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.IssuePackRequest{
			RunId: runID, Destination: "Theatre 2", IssuedTo: "scrub-1",
		}))
	if err != nil {
		t.Fatalf("IssuePack: %v", err)
	}
	issueID := issued.Msg.GetIssue().GetIssueId()

	caseID := h.surgeryCase(t, "+91-98400-00001")
	if _, err := h.cssd.MarkUsed(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.MarkUsedRequest{
			IssueId: issueID, CaseId: caseID,
		})); err != nil {
		t.Fatalf("MarkUsed: %v", err)
	}

	// SRS-CSSD-010: from the patient's operation back to the cycle.
	trace, err := h.cssd.TraceCase(ctx,
		withFacility(h.supervisorToken(), h.facility, &sterilev1.TraceCaseRequest{
			CaseId: caseID,
		}))
	if err != nil {
		t.Fatalf("TraceCase: %v", err)
	}
	sets := trace.Msg.GetTrace().GetSets()
	if len(sets) != 1 {
		t.Fatalf("trace = %d set(s), want 1", len(sets))
	}
	if sets[0].GetLoadNumber() != "L-101" || sets[0].GetMachine() != "Autoclave 1" {
		t.Errorf("trace reached load %q on %q, want L-101 on Autoclave 1",
			sets[0].GetLoadNumber(), sets[0].GetMachine())
	}
	if len(trace.Msg.GetTrace().GetIncomplete()) > 0 {
		t.Errorf("a complete chain reported gaps: %v",
			trace.Msg.GetTrace().GetIncomplete())
	}
}

// SRS-CSSD-003: the stage sequence is the department's safety property, and
// stepping round it is a permission of its own.
func TestATechnicianCannotSkipAStageAndASupervisorCan(t *testing.T) {
	h := newCssdHarness(t)
	ctx := context.Background()

	h.defineSet(t, "LAP-02", 0)
	received, err := h.cssd.Receive(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.ReceiveRequest{
			SetCode: "LAP-02", SourceUnit: "Ward 4", Counted: fullCount(),
		}))
	if err != nil {
		t.Fatalf("Receive: %v", err)
	}
	runID := received.Msg.GetRun().GetRunId()

	skip := &sterilev1.AdvanceRequest{
		RunId: runID, Stage: sterilev1.Stage_STAGE_DECONTAMINATED,
		Skipped: true, SkipReason: "washer-disinfector out of service",
	}
	if _, err := h.cssd.Advance(ctx,
		withFacility(h.technicianToken(), h.facility, skip)); err == nil {
		t.Fatal("a technician skipped a reprocessing stage")
	}

	record, err := h.cssd.Advance(ctx,
		withFacility(h.supervisorToken(), h.facility, skip))
	if err != nil {
		t.Fatalf("supervisor Advance(skipped): %v", err)
	}
	// The authoriser is the caller, not a field somebody typed.
	if got := record.Msg.GetRecord().GetSkipAuthorisedBy(); got != "super-1" {
		t.Errorf("skip authorised by %q, want super-1", got)
	}

	// And it is on the exception register a quality review reads.
	exceptions, err := h.cssd.ListExceptions(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&sterilev1.ListExceptionsRequest{}))
	if err != nil {
		t.Fatalf("ListExceptions: %v", err)
	}
	if len(exceptions.Msg.GetRecords()) != 1 {
		t.Fatalf("exception register = %d record(s), want 1",
			len(exceptions.Msg.GetRecords()))
	}
}

// SRS-CSSD-003: two stages are not skippable by anybody.
func TestSterilisationAndReleaseAreNotSkippableWhoeverAuthorises(t *testing.T) {
	h := newCssdHarness(t)
	ctx := context.Background()

	h.defineSet(t, "LAP-03", 0)
	runID := h.reprocess(t, "LAP-03")

	if _, err := h.cssd.Advance(ctx,
		withFacility(h.supervisorToken(), h.facility, &sterilev1.AdvanceRequest{
			RunId: runID, Stage: sterilev1.Stage_STAGE_STERILISED,
			Skipped:    true,
			SkipReason: "list overran and the set is needed now",
		})); err == nil {
		t.Fatal("sterilisation was skipped; the pack would carry a sterile " +
			"label having never been through an autoclave")
	}
}

// SRS-CSSD-007: a load that ran is not a load that passed, and the refusal
// names every reason rather than the first.
func TestALoadWithNoIndicatorReadCannotBeReleased(t *testing.T) {
	h := newCssdHarness(t)
	ctx := context.Background()

	h.defineSet(t, "LAP-04", 0)
	runID := h.reprocess(t, "LAP-04")

	started, err := h.cssd.StartCycle(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.StartCycleRequest{
			Machine: "Autoclave 2", LoadNumber: "L-201", Program: "134C",
		}))
	if err != nil {
		t.Fatalf("StartCycle: %v", err)
	}
	cycleID := started.Msg.GetCycle().GetCycleId()

	if _, err := h.cssd.LoadCycle(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.LoadCycleRequest{
			CycleId: cycleID, RunIds: []string{runID},
		})); err != nil {
		t.Fatalf("LoadCycle: %v", err)
	}

	// Still running: two things are against it, and both are reported.
	decision, err := h.cssd.GetReleaseDecision(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&sterilev1.GetReleaseDecisionRequest{CycleId: cycleID}))
	if err != nil {
		t.Fatalf("GetReleaseDecision: %v", err)
	}
	if decision.Msg.GetDecision().GetAllowed() {
		t.Fatal("a running cycle was releasable")
	}
	refusals := decision.Msg.GetDecision().GetRefusals()
	if !hasRefusal(refusals, sterilev1.ReleaseRefusal_RELEASE_REFUSAL_CYCLE_STILL_RUNNING) ||
		!hasRefusal(refusals, sterilev1.ReleaseRefusal_RELEASE_REFUSAL_NO_CHEMICAL_INDICATOR) {
		t.Errorf("refusals = %v; a technician told one reason at a time comes "+
			"back to the same screen three times", refusals)
	}

	if _, err := h.cssd.FinishCycle(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.FinishCycleRequest{
			CycleId: cycleID, Result: sterilev1.CycleResult_CYCLE_RESULT_PASSED,
		})); err != nil {
		t.Fatalf("FinishCycle: %v", err)
	}

	// Passed, but nobody has read an indicator.
	if _, err := h.cssd.ReleaseLoad(ctx,
		withFacility(h.supervisorToken(), h.facility, &sterilev1.ReleaseLoadRequest{
			CycleId: cycleID,
		})); err == nil {
		t.Fatal("a load with no indicator read was released")
	}

	// And the pack cannot be issued while its load is uncleared.
	if _, err := h.cssd.IssuePack(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.IssuePackRequest{
			RunId: runID, Destination: "Theatre 1",
		})); err == nil {
		t.Fatal("a pack from an uncleared load was issued")
	}
}

func hasRefusal(all []sterilev1.ReleaseRefusal, want sterilev1.ReleaseRefusal) bool {
	for _, refusal := range all {
		if refusal == want {
			return true
		}
	}
	return false
}

// SRS-CSSD-007: the deployment may hold every load for its spore challenge.
func TestABiologicalHoldKeepsAPassedLoadOffTheShelf(t *testing.T) {
	h := newCssdHarnessWith(t, sterileapp.Config{
		DefaultShelfLife:           30 * 24 * time.Hour,
		RequireBiologicalIndicator: true,
	})
	ctx := context.Background()

	h.defineSet(t, "IMPL-01", 0)
	runID := h.reprocess(t, "IMPL-01")

	started, err := h.cssd.StartCycle(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.StartCycleRequest{
			Machine: "Autoclave 1", LoadNumber: "L-301", Program: "134C",
		}))
	if err != nil {
		t.Fatalf("StartCycle: %v", err)
	}
	cycleID := started.Msg.GetCycle().GetCycleId()

	if _, err := h.cssd.LoadCycle(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.LoadCycleRequest{
			CycleId: cycleID, RunIds: []string{runID},
		})); err != nil {
		t.Fatalf("LoadCycle: %v", err)
	}
	if _, err := h.cssd.FinishCycle(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.FinishCycleRequest{
			CycleId: cycleID, Result: sterilev1.CycleResult_CYCLE_RESULT_PASSED,
		})); err != nil {
		t.Fatalf("FinishCycle: %v", err)
	}
	if _, err := h.cssd.RecordIndicator(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.RecordIndicatorRequest{
			CycleId: cycleID, Kind: sterilev1.IndicatorKind_INDICATOR_KIND_CHEMICAL,
			Lot: "CI-2026-04", Passed: true,
		})); err != nil {
		t.Fatalf("RecordIndicator(chemical): %v", err)
	}

	// The chemical indicator passed. Under this policy that is not enough.
	if _, err := h.cssd.ReleaseLoad(ctx,
		withFacility(h.supervisorToken(), h.facility, &sterilev1.ReleaseLoadRequest{
			CycleId: cycleID,
		})); err == nil {
		t.Fatal("a load was released on a promise while its spore challenge " +
			"was still incubating")
	}

	// It is on the worklist of loads waiting.
	waiting, err := h.cssd.ListCyclesAwaitingRelease(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&sterilev1.ListCyclesAwaitingReleaseRequest{}))
	if err != nil {
		t.Fatalf("ListCyclesAwaitingRelease: %v", err)
	}
	if len(waiting.Msg.GetCycles()) != 1 {
		t.Fatalf("awaiting release = %d, want 1", len(waiting.Msg.GetCycles()))
	}

	if _, err := h.cssd.RecordIndicator(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.RecordIndicatorRequest{
			CycleId: cycleID, Kind: sterilev1.IndicatorKind_INDICATOR_KIND_BIOLOGICAL,
			Lot: "BI-2026-04", Passed: true,
		})); err != nil {
		t.Fatalf("RecordIndicator(biological): %v", err)
	}
	if _, err := h.cssd.ReleaseLoad(ctx,
		withFacility(h.supervisorToken(), h.facility, &sterilev1.ReleaseLoadRequest{
			CycleId: cycleID, Note: "spore challenge negative at 24h",
		})); err != nil {
		t.Fatalf("ReleaseLoad after the biological read: %v", err)
	}
}

// SRS-CSSD-007: a failed indicator stops the load, and the pack with it.
func TestAFailedIndicatorStopsTheLoad(t *testing.T) {
	h := newCssdHarness(t)
	ctx := context.Background()

	h.defineSet(t, "LAP-05", 0)
	runID := h.reprocess(t, "LAP-05")

	started, err := h.cssd.StartCycle(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.StartCycleRequest{
			Machine: "Autoclave 2", LoadNumber: "L-401", Program: "134C",
		}))
	if err != nil {
		t.Fatalf("StartCycle: %v", err)
	}
	cycleID := started.Msg.GetCycle().GetCycleId()

	if _, err := h.cssd.LoadCycle(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.LoadCycleRequest{
			CycleId: cycleID, RunIds: []string{runID},
		})); err != nil {
		t.Fatalf("LoadCycle: %v", err)
	}
	if _, err := h.cssd.FinishCycle(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.FinishCycleRequest{
			CycleId: cycleID, Result: sterilev1.CycleResult_CYCLE_RESULT_PASSED,
		})); err != nil {
		t.Fatalf("FinishCycle: %v", err)
	}
	if _, err := h.cssd.RecordIndicator(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.RecordIndicatorRequest{
			CycleId: cycleID, Kind: sterilev1.IndicatorKind_INDICATOR_KIND_CHEMICAL,
			Lot: "CI-2026-05", Passed: false, Notes: "strip unchanged",
		})); err != nil {
		t.Fatalf("RecordIndicator: %v", err)
	}

	if _, err := h.cssd.ReleaseLoad(ctx,
		withFacility(h.supervisorToken(), h.facility, &sterilev1.ReleaseLoadRequest{
			CycleId: cycleID,
		})); err == nil {
		t.Fatal("a load with a failed indicator was released")
	}

	// The bad-batch question, which runs the other way: a lot that turns out
	// to be faulty invalidates every load it cleared, and the lot is the only
	// thing that can find them. A lot that cleared nothing reaches nothing.
	good := h.reprocess(t, "LAP-05")
	h.sterilise(t, "L-402", good)

	for _, tc := range []struct {
		lot  string
		want int
	}{
		// CI-2026-04 is what the harness releases on.
		{lot: "CI-2026-04", want: 1},
		// CI-2026-05 failed, so it cleared nothing: the load it was read
		// against never left the department.
		{lot: "CI-2026-05", want: 0},
	} {
		byLot, err := h.cssd.ListLoadsClearedByLot(ctx,
			withFacility(h.supervisorToken(), h.facility,
				&sterilev1.ListLoadsClearedByLotRequest{Lot: tc.lot}))
		if err != nil {
			t.Fatalf("ListLoadsClearedByLot(%s): %v", tc.lot, err)
		}
		if len(byLot.Msg.GetCycles()) != tc.want {
			t.Errorf("lot %s cleared %d load(s), want %d",
				tc.lot, len(byLot.Msg.GetCycles()), tc.want)
		}
	}
}

// SRS-CSSD-008: a released pack is not an issuable pack for ever.
func TestAnExpiredPackCannotBeIssuedThoughItWasReleased(t *testing.T) {
	// A shelf life of a few milliseconds, so the pack is out of date by the
	// time anybody asks for it. The rule under test is the same one a
	// thirty-day pack meets a month later. It is not shorter than this because
	// the database stores times to the microsecond and refuses a pack whose
	// expiry is not after its sterilisation — a constraint worth keeping.
	const shelfLife = 50 * time.Millisecond
	h := newCssdHarnessWith(t, sterileapp.Config{DefaultShelfLife: shelfLife})
	ctx := context.Background()

	h.defineSet(t, "LAP-06", 0)
	runID := h.reprocess(t, "LAP-06")
	h.sterilise(t, "L-501", runID)
	time.Sleep(2 * shelfLife)

	run, err := h.cssd.GetRun(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.GetRunRequest{
			RunId: runID,
		}))
	if err != nil {
		t.Fatalf("GetRun: %v", err)
	}
	if run.Msg.GetRun().GetStage() != sterilev1.Stage_STAGE_RELEASED {
		t.Fatalf("run is at %v, want released", run.Msg.GetRun().GetStage())
	}
	if run.Msg.GetRun().GetIssuable() {
		t.Error("an expired pack reported itself issuable; a client checking " +
			"only the stage would offer it")
	}

	if _, err := h.cssd.IssuePack(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.IssuePackRequest{
			RunId: runID, Destination: "Theatre 3",
		})); err == nil {
		t.Fatal("an expired pack was issued")
	}

	expired, err := h.cssd.ListExpiredPacks(ctx,
		withFacility(h.technicianToken(), h.facility,
			&sterilev1.ListExpiredPacksRequest{}))
	if err != nil {
		t.Fatalf("ListExpiredPacks: %v", err)
	}
	if len(expired.Msg.GetRuns()) != 1 {
		t.Errorf("expired packs = %d, want 1", len(expired.Msg.GetRuns()))
	}
}

// SRS-CSSD-004: a missing critical item is a cancelled case found when the
// surgeon opens the pack, so it is found here instead.
func TestACriticalShortfallRefusesAssemblyAndANonCriticalOneIsRecorded(t *testing.T) {
	h := newCssdHarness(t)
	ctx := context.Background()

	h.defineSet(t, "LAP-07", 0)

	received, err := h.cssd.Receive(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.ReceiveRequest{
			SetCode: "LAP-07", SourceUnit: "Theatre 1",
			// One retractor short on arrival, which is reported rather than
			// refused: the set is on the counter whatever the count says.
			Counted: map[string]int32{"SCALPEL-H": 1, "RETRACT-M": 1, "SWAB-CL": 4},
		}))
	if err != nil {
		t.Fatalf("Receive: %v", err)
	}
	if got := received.Msg.GetShort(); len(got) != 1 || got[0] != "RETRACT-M" {
		t.Fatalf("receipt short = %v, want [RETRACT-M]", got)
	}
	runID := received.Msg.GetRun().GetRunId()

	for _, stage := range []sterilev1.Stage{
		sterilev1.Stage_STAGE_DECONTAMINATED,
		sterilev1.Stage_STAGE_WASHED,
		sterilev1.Stage_STAGE_INSPECTED,
	} {
		if _, err := h.cssd.Advance(ctx,
			withFacility(h.technicianToken(), h.facility, &sterilev1.AdvanceRequest{
				RunId: runID, Stage: stage,
			})); err != nil {
			t.Fatalf("Advance(%v): %v", stage, err)
		}
	}

	// A retractor is critical: the pack cannot go out without it.
	if _, err := h.cssd.Assemble(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.AssembleRequest{
			RunId:  runID,
			Packed: map[string]int32{"SCALPEL-H": 1, "RETRACT-M": 1, "SWAB-CL": 4},
		})); err == nil {
		t.Fatal("a set short of a critical item was assembled")
	}

	// A swab clamp is not: the pack goes out short and the record says so.
	assembled, err := h.cssd.Assemble(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.AssembleRequest{
			RunId:  runID,
			Packed: map[string]int32{"SCALPEL-H": 1, "RETRACT-M": 2, "SWAB-CL": 3},
		}))
	if err != nil {
		t.Fatalf("Assemble: %v", err)
	}
	if got := assembled.Msg.GetMissing(); len(got) != 1 || got[0] != "SWAB-CL" {
		t.Errorf("assembly missing = %v, want [SWAB-CL]", got)
	}
}

// SRS-CSSD-001: a revision does not change what an earlier pack was checked
// against.
func TestRevisingASetLeavesAnEarlierPackCheckedAgainstTheOldList(t *testing.T) {
	h := newCssdHarness(t)
	ctx := context.Background()

	h.defineSet(t, "LAP-08", 0)
	runID := h.reprocess(t, "LAP-08")

	// A second definition of the same code revises it.
	revised, err := h.cssd.DefineSet(ctx,
		withFacility(h.supervisorToken(), h.facility, &sterilev1.DefineSetRequest{
			Code: "LAP-08", Display: "Laparotomy set", Kind: "tray",
			Items: []*sterilev1.PackingItem{
				{Code: "SCALPEL-H", Display: "Blade handle", Quantity: 1, Critical: true},
				{Code: "RETRACT-M", Display: "Retractor", Quantity: 3, Critical: true},
			},
		}))
	if err != nil {
		t.Fatalf("DefineSet(revision): %v", err)
	}
	if revised.Msg.GetSet().GetSetVersion() != 2 {
		t.Fatalf("revision is version %d, want 2",
			revised.Msg.GetSet().GetSetVersion())
	}

	run, err := h.cssd.GetRun(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.GetRunRequest{
			RunId: runID,
		}))
	if err != nil {
		t.Fatalf("GetRun: %v", err)
	}
	if got := run.Msg.GetRun().GetSetVersion(); got != 1 {
		t.Errorf("the pack now claims version %d; it was assembled against 1, "+
			"and the version is the only thing that could audit it", got)
	}

	versions, err := h.cssd.ListSetVersions(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&sterilev1.ListSetVersionsRequest{Code: "LAP-08"}))
	if err != nil {
		t.Fatalf("ListSetVersions: %v", err)
	}
	if len(versions.Msg.GetVersions()) != 2 {
		t.Fatalf("versions = %d, want 2", len(versions.Msg.GetVersions()))
	}
}

// SRS-CSSD-011: a recall reaches every pack in the load and every case one was
// opened for, and somebody is told.
func TestARecallReachesTheWardsAndTheCasesAlreadyOpened(t *testing.T) {
	h := newCssdHarness(t)
	ctx := context.Background()

	h.defineSet(t, "LAP-09", 0)
	used := h.reprocess(t, "LAP-09")
	out := h.reprocess(t, "LAP-09")
	onShelf := h.reprocess(t, "LAP-09")
	h.sterilise(t, "L-601", used, out, onShelf)

	// One pack was opened for a case, one is sitting on a ward, one never
	// left. The three need different actions.
	openedIssue, err := h.cssd.IssuePack(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.IssuePackRequest{
			RunId: used, Destination: "Theatre 2",
		}))
	if err != nil {
		t.Fatalf("IssuePack(used): %v", err)
	}
	caseID := h.surgeryCase(t, "+91-98400-00002")
	if _, err := h.cssd.MarkUsed(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.MarkUsedRequest{
			IssueId: openedIssue.Msg.GetIssue().GetIssueId(), CaseId: caseID,
		})); err != nil {
		t.Fatalf("MarkUsed: %v", err)
	}
	if _, err := h.cssd.IssuePack(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.IssuePackRequest{
			RunId: out, Destination: "Ward 7",
		})); err != nil {
		t.Fatalf("IssuePack(out): %v", err)
	}

	// A technician may not raise one: it tells wards to stop using what they
	// have.
	if _, err := h.cssd.RaiseRecall(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.RaiseRecallRequest{
			CycleId: h.cycleOf(t, used), Reason: "chamber gasket failure found",
		})); err == nil {
		t.Fatal("a technician raised a recall")
	}

	raised, err := h.cssd.RaiseRecall(ctx,
		withFacility(h.supervisorToken(), h.facility, &sterilev1.RaiseRecallRequest{
			CycleId: h.cycleOf(t, used),
			Reason:  "chamber gasket failure found on service",
		}))
	if err != nil {
		t.Fatalf("RaiseRecall: %v", err)
	}
	scope := raised.Msg.GetScope()
	if len(scope.GetPacks()) != 3 {
		t.Errorf("recall reached %d pack(s), want 3", len(scope.GetPacks()))
	}
	if len(scope.GetCases()) != 1 || scope.GetCases()[0] != caseID {
		t.Errorf("recall cases = %v, want [%s]; the patients who cannot have "+
			"the pack back are the reason it exists", scope.GetCases(), caseID)
	}
	if len(scope.GetLocations()) != 1 || scope.GetLocations()[0] != "Ward 7" {
		t.Errorf("recall locations = %v, want [Ward 7]", scope.GetLocations())
	}
	if raised.Msg.GetRecall().GetPacksAffected() != 3 {
		t.Errorf("recall recorded %d pack(s) affected, want 3",
			raised.Msg.GetRecall().GetPacksAffected())
	}

	// Durable and acknowledged rather than a line in a log nobody reads.
	var notices int
	if err := h.pool.QueryRow(ctx, `
		SELECT count(*) FROM platform_escalation.notice
		WHERE tenant_id = $1 AND subject_kind = 'sterile_recall'`,
		h.tenantID).Scan(&notices); err != nil {
		t.Fatalf("notice query: %v", err)
	}
	if notices != 1 {
		t.Errorf("a recall raised %d notice(s), want 1; wards holding the "+
			"packs would not be told", notices)
	}

	open, err := h.cssd.ListOpenRecalls(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&sterilev1.ListOpenRecallsRequest{}))
	if err != nil {
		t.Fatalf("ListOpenRecalls: %v", err)
	}
	if len(open.Msg.GetRecalls()) != 1 {
		t.Fatalf("open recalls = %d, want 1", len(open.Msg.GetRecalls()))
	}

	if _, err := h.cssd.CloseRecall(ctx,
		withFacility(h.supervisorToken(), h.facility, &sterilev1.CloseRecallRequest{
			RecallId: raised.Msg.GetRecall().GetRecallId(),
			Note:     "two packs returned, one patient reviewed",
		})); err != nil {
		t.Fatalf("CloseRecall: %v", err)
	}
}

// cycleOf reads the load a pack went into.
func (h *cssdHarness) cycleOf(t *testing.T, runID string) string {
	t.Helper()

	run, err := h.cssd.GetRun(context.Background(),
		withFacility(h.technicianToken(), h.facility, &sterilev1.GetRunRequest{
			RunId: runID,
		}))
	if err != nil {
		t.Fatalf("GetRun: %v", err)
	}
	return run.Msg.GetRun().GetCycleId()
}

// SRS-CSSD-010: a trace and a fishing expedition look identical in the query
// log, so the access is a permission of its own.
func TestATechnicianCannotRunACaseTrace(t *testing.T) {
	h := newCssdHarness(t)

	if _, err := h.cssd.TraceCase(context.Background(),
		withFacility(h.technicianToken(), h.facility, &sterilev1.TraceCaseRequest{
			CaseId: "any-case",
		})); err == nil {
		t.Fatal("a technician ran a case trace")
	}
}

// SRS-CSSD-010: a trace built on an identifier nobody can resolve reaches no
// patient, which is the one thing the trace exists for.
func TestAPackCannotBeMarkedUsedForACaseTheTheatreDoesNotKnow(t *testing.T) {
	h := newCssdHarness(t)
	ctx := context.Background()

	h.defineSet(t, "LAP-10", 0)
	runID := h.reprocess(t, "LAP-10")
	h.sterilise(t, "L-701", runID)

	issued, err := h.cssd.IssuePack(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.IssuePackRequest{
			RunId: runID, Destination: "Theatre 2",
		}))
	if err != nil {
		t.Fatalf("IssuePack: %v", err)
	}

	_, err = h.cssd.MarkUsed(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.MarkUsedRequest{
			IssueId: issued.Msg.GetIssue().GetIssueId(),
			CaseId:  uuid.NewString(),
		}))
	if err == nil {
		t.Fatal("a pack was marked used for a case nobody can resolve")
	}
	if !strings.Contains(strings.ToLower(err.Error()), "no such case") {
		t.Errorf("MarkUsed error = %v, want it to say the case is unknown", err)
	}
}

// SRS-CSSD-009, SRS-CSSD-012: the count comes back with the pack, and a
// missing instrument becomes the master's problem.
func TestAPackReturnedShortIsRecordedAndTheInstrumentCanBeMarkedMissing(t *testing.T) {
	h := newCssdHarness(t)
	ctx := context.Background()

	h.defineSet(t, "LAP-11", 0)
	runID := h.reprocess(t, "LAP-11")
	h.sterilise(t, "L-801", runID)

	issued, err := h.cssd.IssuePack(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.IssuePackRequest{
			RunId: runID, Destination: "Theatre 4",
		}))
	if err != nil {
		t.Fatalf("IssuePack: %v", err)
	}

	outstanding, err := h.cssd.ListOutstanding(ctx,
		withFacility(h.technicianToken(), h.facility,
			&sterilev1.ListOutstandingRequest{Destination: "Theatre 4"}))
	if err != nil {
		t.Fatalf("ListOutstanding: %v", err)
	}
	if len(outstanding.Msg.GetIssues()) != 1 {
		t.Fatalf("outstanding = %d, want 1", len(outstanding.Msg.GetIssues()))
	}

	returned, err := h.cssd.ReturnPack(ctx,
		withFacility(h.technicianToken(), h.facility, &sterilev1.ReturnPackRequest{
			IssueId: issued.Msg.GetIssue().GetIssueId(),
			Counted: map[string]int32{"SCALPEL-H": 1, "RETRACT-M": 2, "SWAB-CL": 3},
			Note:    "one swab clamp not accounted for",
		}))
	if err != nil {
		t.Fatalf("ReturnPack: %v", err)
	}
	if got := returned.Msg.GetShort(); len(got) != 1 || got[0] != "SWAB-CL" {
		t.Fatalf("return short = %v, want [SWAB-CL]; this is the last moment "+
			"anybody can say where it was", got)
	}

	// SRS-CSSD-012: the instrument's own lifecycle. Missing is distinct from
	// retired, because a missing instrument may be inside a patient.
	registered, err := h.cssd.RegisterInstrument(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&sterilev1.RegisterInstrumentRequest{
				Code: "SWAB-CL", Display: "Swab clamp",
				SerialNumber: "SC-0041", Location: "LAP-11",
			}))
	if err != nil {
		t.Fatalf("RegisterInstrument: %v", err)
	}
	if !registered.Msg.GetInstrument().GetPackable() {
		t.Error("a newly registered instrument is not packable")
	}

	moved, err := h.cssd.MoveInstrument(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&sterilev1.MoveInstrumentRequest{
				InstrumentId: registered.Msg.GetInstrument().GetInstrumentId(),
				Status:       sterilev1.InstrumentStatus_INSTRUMENT_STATUS_MISSING,
				Note:         "not returned from Theatre 4, load L-801",
			}))
	if err != nil {
		t.Fatalf("MoveInstrument: %v", err)
	}
	if moved.Msg.GetInstrument().GetPackable() {
		t.Error("a missing instrument reported itself packable")
	}

	outOfService, err := h.cssd.ListInstruments(ctx,
		withFacility(h.technicianToken(), h.facility,
			&sterilev1.ListInstrumentsRequest{OutOfServiceOnly: true}))
	if err != nil {
		t.Fatalf("ListInstruments: %v", err)
	}
	if len(outOfService.Msg.GetInstruments()) != 1 {
		t.Errorf("out of service = %d, want 1",
			len(outOfService.Msg.GetInstruments()))
	}
}

// SRS-CSSD-012: the acceptance is "history supports replacement and loss
// analysis", and both questions are about the past rather than about where an
// item is today.
func TestAnInstrumentsHistorySurvivesTheStatusChangingBack(t *testing.T) {
	h := newCssdHarness(t)
	ctx := context.Background()

	registered, err := h.cssd.RegisterInstrument(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&sterilev1.RegisterInstrumentRequest{
				Code: "SCOPE-5", Display: "10mm laparoscope",
				SerialNumber: "SN-77300", Location: "store",
			}))
	if err != nil {
		t.Fatalf("RegisterInstrument: %v", err)
	}
	instrumentID := registered.Msg.GetInstrument().GetInstrumentId()

	// Away, back, away again. The status ends where it started.
	for _, move := range []struct {
		to   sterilev1.InstrumentStatus
		note string
	}{
		{sterilev1.InstrumentStatus_INSTRUMENT_STATUS_IN_REPAIR, "lens fogged"},
		{sterilev1.InstrumentStatus_INSTRUMENT_STATUS_IN_SERVICE, ""},
		{sterilev1.InstrumentStatus_INSTRUMENT_STATUS_IN_REPAIR, "light cable intermittent"},
		{sterilev1.InstrumentStatus_INSTRUMENT_STATUS_IN_SERVICE, ""},
	} {
		if _, err := h.cssd.MoveInstrument(ctx,
			withFacility(h.supervisorToken(), h.facility,
				&sterilev1.MoveInstrumentRequest{
					InstrumentId: instrumentID, Status: move.to, Note: move.note,
				})); err != nil {
			t.Fatalf("MoveInstrument(%v): %v", move.to, err)
		}
	}

	current, err := h.cssd.ListInstruments(ctx,
		withFacility(h.technicianToken(), h.facility,
			&sterilev1.ListInstrumentsRequest{OutOfServiceOnly: true}))
	if err != nil {
		t.Fatalf("ListInstruments: %v", err)
	}
	if len(current.Msg.GetInstruments()) != 0 {
		t.Fatalf("the scope is back in service but %d instrument(s) are out",
			len(current.Msg.GetInstruments()))
	}

	// The status column says nothing happened. The history says it has been
	// away twice, which is the answer to whether to replace it.
	history, err := h.cssd.GetInstrumentHistory(ctx,
		withFacility(h.technicianToken(), h.facility,
			&sterilev1.GetInstrumentHistoryRequest{InstrumentId: instrumentID}))
	if err != nil {
		t.Fatalf("GetInstrumentHistory: %v", err)
	}
	events := history.Msg.GetEvents()
	// Four moves plus the registration.
	if len(events) != 5 {
		t.Fatalf("history = %d event(s), want 5", len(events))
	}
	// Most recent first; the oldest is the registration, which has no
	// previous status because it is not a move.
	if events[len(events)-1].GetFromStatus() !=
		sterilev1.InstrumentStatus_INSTRUMENT_STATUS_UNSPECIFIED {
		t.Errorf("the registration claims to have left %v",
			events[len(events)-1].GetFromStatus())
	}

	repairs := 0
	for _, event := range events {
		if event.GetToStatus() ==
			sterilev1.InstrumentStatus_INSTRUMENT_STATUS_IN_REPAIR {
			repairs++
		}
	}
	if repairs != 2 {
		t.Errorf("history records %d repair(s), want 2", repairs)
	}

	// The loss analysis runs the other way: every move of a kind, in a period.
	moves, err := h.cssd.ListInstrumentMoves(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&sterilev1.ListInstrumentMovesRequest{
				Status:      sterilev1.InstrumentStatus_INSTRUMENT_STATUS_IN_REPAIR,
				PeriodStart: timestamppb.New(time.Now().Add(-time.Hour)),
				PeriodEnd:   timestamppb.New(time.Now().Add(time.Hour)),
			}))
	if err != nil {
		t.Fatalf("ListInstrumentMoves: %v", err)
	}
	if len(moves.Msg.GetEvents()) != 2 {
		t.Errorf("repairs across the master = %d, want 2",
			len(moves.Msg.GetEvents()))
	}

	// A report with no period is refused rather than silently widened to
	// everything ever recorded.
	if _, err := h.cssd.ListInstrumentMoves(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&sterilev1.ListInstrumentMovesRequest{
				Status: sterilev1.InstrumentStatus_INSTRUMENT_STATUS_MISSING,
			})); err == nil {
		t.Error("a lifecycle report with no period was accepted; " +
			"\"everything ever lost\" is a different report from " +
			"\"lost since April\"")
	}
}

// A technician may not maintain the masters: what belongs in a tray is decided
// once, not while packing.
func TestATechnicianCannotChangeThePackingList(t *testing.T) {
	h := newCssdHarness(t)

	if _, err := h.cssd.DefineSet(context.Background(),
		withFacility(h.technicianToken(), h.facility, &sterilev1.DefineSetRequest{
			Code: "LAP-12", Display: "Laparotomy set", Kind: "tray",
			Items: []*sterilev1.PackingItem{
				{Code: "SCALPEL-H", Quantity: 1, Critical: true},
			},
		})); err == nil {
		t.Fatal("a technician rewrote a packing list")
	}
}

// Tenant isolation over the department's own records (Gate A2).
func TestAnotherTenantCannotReadAPackOrItsLoad(t *testing.T) {
	h := newCssdHarness(t)
	ctx := context.Background()

	h.defineSet(t, "LAP-13", 0)
	runID := h.reprocess(t, "LAP-13")
	cycleID := h.sterilise(t, "L-901", runID)

	other, err := h.org.CreateTenant(ctx,
		as(platformOperatorToken(), &organizationv1.CreateTenantRequest{
			DisplayName: "Fortis Group", LegalJurisdiction: "IN",
			DefaultLocale: "en-IN", TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateTenant: %v", err)
	}
	otherTenant := other.Msg.GetTenant().GetTenantId()

	repo := orgpostgres.New(pgtx.NewManager(h.pool))
	scope := authctx.NewSession(authctx.Session{
		SubjectID: "setup", TenantID: otherTenant,
	}).TenantScope()
	now := time.Now().UTC()
	entitlement, err := orgdomain.NewEntitlement(uuid.NewString(), otherTenant, "",
		"sterile", true, now.Add(-time.Hour), time.Time{}, "setup", now)
	if err != nil {
		t.Fatalf("NewEntitlement: %v", err)
	}
	if err := repo.InsertEntitlement(ctx, scope, entitlement); err != nil {
		t.Fatalf("InsertEntitlement: %v", err)
	}

	intruder := otherTenant + ":super-2:sterile_supervisor"
	if _, err := h.cssd.GetRun(ctx,
		as(intruder, &sterilev1.GetRunRequest{RunId: runID})); err == nil {
		t.Error("another tenant read a pack")
	}
	if _, err := h.cssd.GetCycle(ctx,
		as(intruder, &sterilev1.GetCycleRequest{CycleId: cycleID})); err == nil {
		t.Error("another tenant read a sterilizer load")
	}
}
