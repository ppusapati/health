package app_test

import (
	"context"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
	"google.golang.org/protobuf/types/known/timestamppb"

	empiv1 "github.com/ppusapati/health/code/gen/go/healthcare/empi/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/empi/v1/empiv1connect"
	encounterv1 "github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1/encounterv1connect"
	hkpv1 "github.com/ppusapati/health/code/gen/go/healthcare/housekeeping/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/housekeeping/v1/housekeepingv1connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	qualityv1 "github.com/ppusapati/health/code/gen/go/healthcare/quality/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/quality/v1/qualityv1connect"
	"github.com/ppusapati/health/code/internal/app"
	hkpapp "github.com/ppusapati/health/code/internal/housekeeping/application"
	"github.com/ppusapati/health/code/internal/identity_access/adapters/devauth"
	orgpostgres "github.com/ppusapati/health/code/internal/organization/adapters/postgres"
	orgdomain "github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
	platformapitransport "github.com/ppusapati/health/code/internal/platform_api/transport"
)

// Housekeeping and environmental services (SRS-HKP-001 … 008), end to end.
//
// The domain tests hold the rules and the repository tests hold the schema.
// These hold what only the assembled stack shows: that a cleaning standard is
// approved by somebody other than whoever wrote it, that a spill task's
// detail does not reach a worklist read by somebody without the permission
// for it, that a scan does not move a task — and, the one this family exists
// for, that a bed stays out of service until the terminal clean is done or
// somebody with their own permission puts it back uncleaned by name and
// reason.

type hkpHarness struct {
	pool       *pgxpool.Pool
	hkp        housekeepingv1connect.HousekeepingServiceClient
	encounters encounterv1connect.EncounterServiceClient
	quality    qualityv1connect.QualityServiceClient
	patients   empiv1connect.PatientServiceClient
	org        organizationv1connect.OrganizationServiceClient

	tenantID string
	facility string
}

func newHkpHarness(t *testing.T) *hkpHarness {
	return newHkpHarnessWith(t, hkpapp.Config{})
}

func newHkpHarnessWith(t *testing.T, config hkpapp.Config) *hkpHarness {
	t.Helper()

	pool := pgtest.New(t)
	verifier, err := devauth.New(true)
	if err != nil {
		t.Fatalf("devauth.New: %v", err)
	}

	built := app.New(app.Deps{
		Pool: pool, Verifier: verifier,
		Build: platformapitransport.BuildInfo{
			Version: "test", Commit: "test", BuiltAt: "test",
		},
		RateLimit: platformtransport.RateLimitConfig{
			RequestsPerSecond: 10000, Burst: 10000,
			UnauthenticatedRequestsPerSecond: 10000,
			UnauthenticatedBurst:             10000,
		},
		Housekeeping: config,
	})
	if built.Err != nil {
		t.Fatalf("app.New: %v", built.Err)
	}

	server := httptest.NewServer(h2c.NewHandler(built.Handler, &http2.Server{}))
	t.Cleanup(server.Close)

	h := &hkpHarness{
		pool: pool,
		hkp: housekeepingv1connect.NewHousekeepingServiceClient(
			server.Client(), server.URL),
		encounters: encounterv1connect.NewEncounterServiceClient(
			server.Client(), server.URL),
		quality: qualityv1connect.NewQualityServiceClient(
			server.Client(), server.URL),
		patients: empiv1connect.NewPatientServiceClient(
			server.Client(), server.URL),
		org: organizationv1connect.NewOrganizationServiceClient(
			server.Client(), server.URL),
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

	for _, module := range []string{
		"housekeeping", "quality", "empi", "encounter",
	} {
		h.entitleHkp(t, module)
	}
	return h
}

func (h *hkpHarness) entitleHkp(t *testing.T, module string) {
	t.Helper()

	repo := orgpostgres.New(pgtx.NewManager(h.pool))
	scope := authctx.NewSession(authctx.Session{
		SubjectID: "setup", TenantID: h.tenantID,
	}).TenantScope()

	now := time.Now().UTC()
	entitlement, err := orgdomain.NewEntitlement(uuid.NewString(), h.tenantID,
		"", module, true, now.Add(-time.Hour), time.Time{}, "setup", now)
	if err != nil {
		t.Fatalf("NewEntitlement: %v", err)
	}
	if err := repo.InsertEntitlement(context.Background(), scope,
		entitlement); err != nil {
		t.Fatalf("InsertEntitlement: %v", err)
	}
}

func (h *hkpHarness) cleanerToken() string {
	return h.tenantID + ":cleaner-1:housekeeper:" + h.facility
}

func (h *hkpHarness) otherCleanerToken() string {
	return h.tenantID + ":cleaner-2:housekeeper:" + h.facility
}

func (h *hkpHarness) supervisorToken() string {
	return h.tenantID + ":hk-super:housekeeping_supervisor:" + h.facility
}

// otherSupervisorToken is a second supervisor, who authored nothing. It
// exists so the two locks can be told apart: the domain refuses the author
// their own approval, and the permission refuses everybody in housekeeping.
func (h *hkpHarness) otherSupervisorToken() string {
	return h.tenantID + ":hk-super-2:housekeeping_supervisor:" + h.facility
}

func (h *hkpHarness) ipcLeadToken() string {
	return h.tenantID + ":ipc-lead:infection_control_lead:" + h.facility
}

func (h *hkpHarness) nurseToken() string {
	return h.tenantID + ":nurse-1:nurse:" + h.facility
}

func (h *hkpHarness) matronToken() string {
	return h.tenantID + ":matron-1:nurse_manager:" + h.facility
}

func (h *hkpHarness) doctorToken() string {
	return h.tenantID + ":doctor-1:clinician:" + h.facility
}

func (h *hkpHarness) clerkToken() string {
	return h.tenantID + ":clerk-1:registration_clerk:" + h.facility
}

func (h *hkpHarness) officerToken() string {
	return h.tenantID + ":qms-1:quality_officer:" + h.facility
}

// standard configures a cleanable location and puts it in force. The
// supervisor writes it and infection control approves it, which is the
// separation SRS-HKP-001 turns on.
func (h *hkpHarness) standard(t *testing.T,
	req *hkpv1.ConfigureLocationRequest) *hkpv1.CleanableLocation {

	t.Helper()
	ctx := context.Background()

	drafted, err := h.hkp.ConfigureLocation(ctx,
		withFacility(h.supervisorToken(), h.facility, req))
	if err != nil {
		t.Fatalf("ConfigureLocation: %v", err)
	}
	approved, err := h.hkp.ApproveLocation(ctx,
		withFacility(h.ipcLeadToken(), h.facility,
			&hkpv1.ApproveLocationRequest{
				LocationId: drafted.Msg.GetLocation().GetLocationId(),
				EffectiveFrom: timestamppb.New(
					time.Now().UTC().Add(-time.Hour)),
			}))
	if err != nil {
		t.Fatalf("ApproveLocation: %v", err)
	}
	return approved.Msg.GetLocation()
}

func bedStandard(code, bedID string) *hkpv1.ConfigureLocationRequest {
	return &hkpv1.ConfigureLocationRequest{
		Code: code, Name: "Ward 3 " + bedID, FacilityId: "", Zone: "ward-3",
		BedId:             bedID,
		RiskClass:         hkpv1.RiskClass_RISK_CLASS_HIGH,
		RoutineEveryHours: 24, RoutineSlaMinutes: 120,
		TerminalSlaMinutes: 45,
		Checklist: []*hkpv1.ChecklistItem{
			{Code: "surfaces", Label: "High-touch surfaces", Required: true},
			{Code: "floor", Label: "Floor", Required: true},
			{Code: "curtains", Label: "Curtain change"},
		},
		ScanCode: strings.ToUpper(code),
	}
}

func theatreStandard() *hkpv1.ConfigureLocationRequest {
	req := bedStandard("th-2", "")
	req.Name, req.Zone = "Theatre 2", "theatres"
	req.RiskClass = hkpv1.RiskClass_RISK_CLASS_VERY_HIGH
	req.RoutineEveryHours, req.RoutineSlaMinutes = 6, 30
	return req
}

func (h *hkpHarness) patient(t *testing.T, family, phone string) (
	string, string) {

	t.Helper()

	registered, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility,
			&empiv1.RegisterPatientRequest{
				Demographics: demographics(family, []string{"Meera"},
					date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, phone),
			}))
	if err != nil {
		t.Fatalf("RegisterPatient: %v", err)
	}
	patient := registered.Msg.GetPatient().GetPatientId()

	opened, err := h.encounters.OpenEncounter(context.Background(),
		withFacility(h.doctorToken(), h.facility,
			&encounterv1.OpenEncounterRequest{
				PatientId: patient, FacilityId: h.facility,
				Class:               encounterv1.EncounterClass_ENCOUNTER_CLASS_INPATIENT,
				AttendingProviderId: "doctor-1", Reason: "pneumonia",
				StartImmediately: true,
			}))
	if err != nil {
		t.Fatalf("OpenEncounter: %v", err)
	}
	return patient, opened.Msg.GetEncounter().GetEncounterId()
}

// SRS-HKP-001. The cleaning standard is written by one person and put in
// force by another, and nothing is cleaned to it until then.
func TestACleaningStandardIsApprovedBySomebodyElseBeforeAnythingIsCleanedToIt(
	t *testing.T) {

	h := newHkpHarness(t)
	ctx := context.Background()

	drafted, err := h.hkp.ConfigureLocation(ctx,
		withFacility(h.supervisorToken(), h.facility,
			bedStandard("w3-bed-7", "bed-7")))
	if err != nil {
		t.Fatalf("ConfigureLocation: %v", err)
	}
	location := drafted.Msg.GetLocation()
	if location.GetRevision() != 1 {
		t.Fatalf("want revision 1, got %d", location.GetRevision())
	}

	// A housekeeper does not write the standard they are judged against.
	if _, err := h.hkp.ConfigureLocation(ctx,
		withFacility(h.cleanerToken(), h.facility,
			bedStandard("w3-bed-8", "bed-8"))); err == nil {
		t.Fatal("a cleaner configured a cleaning standard")
	}

	// Until it is approved, no task can be raised against it.
	if _, err := h.hkp.RaiseCleaningTask(ctx,
		withFacility(h.cleanerToken(), h.facility,
			&hkpv1.RaiseCleaningTaskRequest{
				LocationCode: "w3-bed-7",
				Kind:         hkpv1.TaskKind_TASK_KIND_ROUTINE,
			})); err == nil {
		t.Fatal("a task was raised against an unapproved standard")
	}

	// And the supervisor who wrote it cannot approve it — the domain refuses
	// the author.
	if _, err := h.hkp.ApproveLocation(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&hkpv1.ApproveLocationRequest{
				LocationId: location.GetLocationId(),
			})); err == nil {
		t.Fatal("the author approved their own cleaning standard")
	}

	// Nor can a second supervisor who wrote nothing. This is the other lock,
	// and it is the one that matters: the domain's rule stops one person
	// signing their own work, and the permission stops the department
	// signing its own. Without this assertion, granting housekeeping
	// hkp.location.approve would change nothing that any test could see.
	if _, err := h.hkp.ApproveLocation(ctx,
		withFacility(h.otherSupervisorToken(), h.facility,
			&hkpv1.ApproveLocationRequest{
				LocationId: location.GetLocationId(),
			})); err == nil {
		t.Fatal("housekeeping approved its own cleaning standard")
	}

	approved, err := h.hkp.ApproveLocation(ctx,
		withFacility(h.ipcLeadToken(), h.facility,
			&hkpv1.ApproveLocationRequest{
				LocationId: location.GetLocationId(),
				EffectiveFrom: timestamppb.New(
					time.Now().UTC().Add(-time.Hour)),
			}))
	if err != nil {
		t.Fatalf("ApproveLocation: %v", err)
	}
	if approved.Msg.GetLocation().GetApprovedBy() != "ipc-lead" {
		t.Fatalf("want the approver recorded, got %+v",
			approved.Msg.GetLocation())
	}

	// A second revision supersedes the first, so only one standard is ever
	// in force: a room cleaned to whichever the reader opened is a room with
	// two standards.
	second := bedStandard("w3-bed-7", "bed-7")
	second.RoutineEveryHours = 12
	h.standard(t, second)

	live, err := h.hkp.GetLocationInForce(ctx,
		withFacility(h.cleanerToken(), h.facility,
			&hkpv1.GetLocationInForceRequest{Code: "w3-bed-7"}))
	if err != nil {
		t.Fatalf("GetLocationInForce: %v", err)
	}
	if live.Msg.GetLocation().GetRevision() != 2 ||
		live.Msg.GetLocation().GetRoutineEveryHours() != 12 {
		t.Fatalf("want revision 2 in force, got %+v",
			live.Msg.GetLocation())
	}

	listed, err := h.hkp.ListLocations(ctx,
		withFacility(h.cleanerToken(), h.facility,
			&hkpv1.ListLocationsRequest{LiveOnly: true}))
	if err != nil {
		t.Fatalf("ListLocations: %v", err)
	}
	if len(listed.Msg.GetLocations()) != 1 {
		t.Fatalf("want one live standard, got %d",
			len(listed.Msg.GetLocations()))
	}
}

// SRS-HKP-002, SRS-HKP-004. The work moves one step at a time, carries the
// checklist it was raised under, and is signed off by somebody other than
// whoever did it.
func TestACleanIsRecordedAgainstItsChecklistAndVerifiedBySomebodyElse(
	t *testing.T) {

	h := newHkpHarness(t)
	ctx := context.Background()
	h.standard(t, bedStandard("w3-bed-7", "bed-7"))

	raised, err := h.hkp.RaiseCleaningTask(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&hkpv1.RaiseCleaningTaskRequest{
				LocationCode: "w3-bed-7",
				Kind:         hkpv1.TaskKind_TASK_KIND_ROUTINE,
				AssigneeId:   "cleaner-1",
			}))
	if err != nil {
		t.Fatalf("RaiseCleaningTask: %v", err)
	}
	task := raised.Msg.GetTask()
	if len(task.GetChecklist()) != 3 || task.GetLocationRevision() != 1 ||
		task.GetDueBy() == nil {
		t.Fatalf("task did not carry its standard: %+v", task)
	}

	if _, err := h.hkp.StartCleaningTask(ctx,
		withFacility(h.cleanerToken(), h.facility,
			&hkpv1.StartCleaningTaskRequest{
				TaskId: task.GetTaskId(),
			})); err != nil {
		t.Fatalf("StartCleaningTask: %v", err)
	}

	// A required item nobody answered is a clean nobody can sign off.
	if _, err := h.hkp.CompleteCleaningTask(ctx,
		withFacility(h.cleanerToken(), h.facility,
			&hkpv1.CompleteCleaningTaskRequest{
				TaskId: task.GetTaskId(),
				Answers: []*hkpv1.ChecklistAnswer{
					{Code: "surfaces", Done: true},
				},
			})); err == nil {
		t.Fatal("a clean completed with a required item unanswered")
	}

	// And an unticked box with no note is indistinguishable from one nobody
	// looked at.
	if _, err := h.hkp.CompleteCleaningTask(ctx,
		withFacility(h.cleanerToken(), h.facility,
			&hkpv1.CompleteCleaningTaskRequest{
				TaskId: task.GetTaskId(),
				Answers: []*hkpv1.ChecklistAnswer{
					{Code: "surfaces", Done: true},
					{Code: "floor", Done: false},
				},
			})); err == nil {
		t.Fatal("a clean completed with an unexplained exception")
	}

	completed, err := h.hkp.CompleteCleaningTask(ctx,
		withFacility(h.cleanerToken(), h.facility,
			&hkpv1.CompleteCleaningTaskRequest{
				TaskId: task.GetTaskId(),
				Answers: []*hkpv1.ChecklistAnswer{
					{Code: "surfaces", Done: true},
					{Code: "floor", Done: false,
						Exception: "bed occupied"},
				},
			}))
	if err != nil {
		t.Fatalf("CompleteCleaningTask: %v", err)
	}
	if completed.Msg.GetTask().GetState() !=
		hkpv1.TaskState_TASK_STATE_COMPLETED ||
		len(completed.Msg.GetTask().GetAnswers()) != 2 {
		t.Fatalf("completion did not stick: %+v", completed.Msg.GetTask())
	}

	// A clean signed off by the cleaner is the same claim made twice, and the
	// domain refuses it.
	if _, err := h.hkp.VerifyCleaningTask(ctx,
		withFacility(h.cleanerToken(), h.facility,
			&hkpv1.VerifyCleaningTaskRequest{
				TaskId: task.GetTaskId(), Note: "looks fine",
			})); err == nil {
		t.Fatal("the cleaner verified their own clean")
	}

	// And the cleaner at the next bed cannot sign it off either. This is the
	// other lock: the domain's rule only stops one person signing their own
	// work, and verification is a supervisor's act rather than a second
	// cleaner's. Without this assertion, granting housekeepers
	// hkp.task.verify would change nothing that any test could see.
	if _, err := h.hkp.VerifyCleaningTask(ctx,
		withFacility(h.otherCleanerToken(), h.facility,
			&hkpv1.VerifyCleaningTaskRequest{
				TaskId: task.GetTaskId(), Note: "looked over from bay 2",
			})); err == nil {
		t.Fatal("one cleaner verified another cleaner's work")
	}

	verified, err := h.hkp.VerifyCleaningTask(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&hkpv1.VerifyCleaningTaskRequest{
				TaskId: task.GetTaskId(), Note: "spot-checked",
			}))
	if err != nil {
		t.Fatalf("VerifyCleaningTask: %v", err)
	}
	if verified.Msg.GetTask().GetVerifiedBy() != "hk-super" {
		t.Fatalf("verification did not stick: %+v",
			verified.Msg.GetTask())
	}
}

// SRS-HKP-003. The one this family exists for: a bed stays out of service
// until the clean is done or somebody puts it back uncleaned by name and
// reason.
func TestABedStaysOutOfServiceUntilItIsCleanedOrSomebodyOverridesIt(
	t *testing.T) {

	h := newHkpHarnessWith(t, hkpapp.Config{RequireEndedEncounter: true})
	ctx := context.Background()
	h.standard(t, bedStandard("w3-bed-7", "bed-7"))

	_, encounter := h.patient(t, "Rao", "+91-9000000001")

	// A terminal clean raised against an encounter that has not ended is a
	// bed taken out of service with somebody in it.
	if _, err := h.hkp.TriggerTerminalClean(ctx,
		withFacility(h.nurseToken(), h.facility,
			&hkpv1.TriggerTerminalCleanRequest{
				LocationCode: "w3-bed-7", EncounterId: encounter,
			})); err == nil {
		t.Fatal("a terminal clean was raised for an occupied bed")
	}

	// And one that names no encounter at all is refused too, because a
	// setting that only checks when the caller happens to send something is
	// a check nobody can rely on.
	if _, err := h.hkp.TriggerTerminalClean(ctx,
		withFacility(h.nurseToken(), h.facility,
			&hkpv1.TriggerTerminalCleanRequest{
				LocationCode: "w3-bed-7",
			})); err == nil {
		t.Fatal("a terminal clean was raised naming no discharge at all")
	}

	if _, err := h.encounters.EndEncounter(ctx,
		withFacility(h.doctorToken(), h.facility,
			&encounterv1.EndEncounterRequest{
				EncounterId: encounter,
				EndedAt:     timestamppb.New(time.Now().UTC()),
			})); err != nil {
		t.Fatalf("EndEncounter: %v", err)
	}

	triggered, err := h.hkp.TriggerTerminalClean(ctx,
		withFacility(h.nurseToken(), h.facility,
			&hkpv1.TriggerTerminalCleanRequest{
				LocationCode: "w3-bed-7", EncounterId: encounter,
				AssigneeId: "cleaner-1",
			}))
	if err != nil {
		t.Fatalf("TriggerTerminalClean: %v", err)
	}
	task := triggered.Msg.GetTask()
	hold := triggered.Msg.GetHold()
	if hold.GetState() != hkpv1.HoldState_HOLD_STATE_OPEN ||
		hold.GetBedId() != "bed-7" || hold.GetTaskId() != task.GetTaskId() {
		t.Fatalf("the hold did not record what it holds: %+v", hold)
	}

	status, err := h.hkp.GetBedStatus(ctx,
		withFacility(h.nurseToken(), h.facility,
			&hkpv1.GetBedStatusRequest{BedId: "bed-7"}))
	if err != nil {
		t.Fatalf("GetBedStatus: %v", err)
	}
	if status.Msg.GetClear() {
		t.Fatal("a bed with an open terminal clean came back clear")
	}

	// A nurse under pressure for the bed cannot lift the hold themselves.
	if _, err := h.hkp.OverrideBedHold(ctx,
		withFacility(h.nurseToken(), h.facility,
			&hkpv1.OverrideBedHoldRequest{
				HoldId: hold.GetHoldId(), Reason: "we need it",
			})); err == nil {
		t.Fatal("a ward nurse overrode a cleaning hold")
	}
	// Nor can housekeeping, which would be the side that benefits from the
	// bed looking clean.
	if _, err := h.hkp.OverrideBedHold(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&hkpv1.OverrideBedHoldRequest{
				HoldId: hold.GetHoldId(), Reason: "short staffed",
			})); err == nil {
		t.Fatal("housekeeping overrode its own cleaning hold")
	}
	// And a reason is not optional.
	if _, err := h.hkp.OverrideBedHold(ctx,
		withFacility(h.matronToken(), h.facility,
			&hkpv1.OverrideBedHoldRequest{
				HoldId: hold.GetHoldId(),
			})); err == nil {
		t.Fatal("a bed went back into service uncleaned with no reason")
	}

	// The clean finishing is the ordinary way out, and the bed comes back in
	// the same act.
	if _, err := h.hkp.StartCleaningTask(ctx,
		withFacility(h.cleanerToken(), h.facility,
			&hkpv1.StartCleaningTaskRequest{
				TaskId: task.GetTaskId(),
			})); err != nil {
		t.Fatalf("StartCleaningTask: %v", err)
	}
	if _, err := h.hkp.CompleteCleaningTask(ctx,
		withFacility(h.cleanerToken(), h.facility,
			&hkpv1.CompleteCleaningTaskRequest{
				TaskId: task.GetTaskId(),
				Answers: []*hkpv1.ChecklistAnswer{
					{Code: "surfaces", Done: true},
					{Code: "floor", Done: true},
				},
			})); err != nil {
		t.Fatalf("CompleteCleaningTask: %v", err)
	}

	status, err = h.hkp.GetBedStatus(ctx,
		withFacility(h.nurseToken(), h.facility,
			&hkpv1.GetBedStatusRequest{BedId: "bed-7"}))
	if err != nil {
		t.Fatalf("GetBedStatus: %v", err)
	}
	if !status.Msg.GetClear() {
		t.Fatal("the bed is still held after the terminal clean finished")
	}
}

// SRS-HKP-003, SRS-HKP-008. The other way out, and the reason it is a state
// of its own: a turnaround report must not be able to count it as a clean.
func TestAnOverriddenHoldIsItsOwnFactAndNotAFastTurnaround(t *testing.T) {
	h := newHkpHarness(t)
	ctx := context.Background()
	h.standard(t, bedStandard("w3-bed-7", "bed-7"))

	triggered, err := h.hkp.TriggerTerminalClean(ctx,
		withFacility(h.nurseToken(), h.facility,
			&hkpv1.TriggerTerminalCleanRequest{
				LocationCode: "w3-bed-7", AssigneeId: "cleaner-1",
			}))
	if err != nil {
		t.Fatalf("TriggerTerminalClean: %v", err)
	}
	hold := triggered.Msg.GetHold()

	overridden, err := h.hkp.OverrideBedHold(ctx,
		withFacility(h.matronToken(), h.facility,
			&hkpv1.OverrideBedHoldRequest{
				HoldId: hold.GetHoldId(),
				Reason: "no beds left, patient in corridor",
			}))
	if err != nil {
		t.Fatalf("OverrideBedHold: %v", err)
	}
	if overridden.Msg.GetHold().GetState() !=
		hkpv1.HoldState_HOLD_STATE_OVERRIDDEN ||
		overridden.Msg.GetHold().GetOverriddenBy() != "matron-1" {
		t.Fatalf("the override did not record itself: %+v",
			overridden.Msg.GetHold())
	}

	// The bed is available again, and the clean it never had is still open
	// work: somebody has to go and do it.
	status, err := h.hkp.GetBedStatus(ctx,
		withFacility(h.nurseToken(), h.facility,
			&hkpv1.GetBedStatusRequest{BedId: "bed-7"}))
	if err != nil {
		t.Fatalf("GetBedStatus: %v", err)
	}
	if !status.Msg.GetClear() {
		t.Fatal("an overridden hold still holds the bed")
	}
	open, err := h.hkp.ListCleaningTasks(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&hkpv1.ListCleaningTasksRequest{OpenOnly: true}))
	if err != nil {
		t.Fatalf("ListCleaningTasks: %v", err)
	}
	if len(open.Msg.GetTasks()) != 1 {
		t.Fatalf("the uncleaned bed's task left the worklist: %+v",
			open.Msg.GetTasks())
	}

	// And the report counts it apart. A bed back in service in minutes
	// because nobody cleaned it is not a fast turnaround, and a report that
	// said so would reward exactly what the hold exists to discourage.
	report, err := h.hkp.GetTurnaroundReport(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&hkpv1.GetTurnaroundReportRequest{}))
	if err != nil {
		t.Fatalf("GetTurnaroundReport: %v", err)
	}
	summary := report.Msg.GetSummary()
	if summary.GetHeld() != 1 || summary.GetOverridden() != 1 ||
		summary.GetReleased() != 0 || !summary.GetUnanswerable() {
		t.Fatalf("an override was counted as a turnaround: %+v", summary)
	}
}

// SRS-HKP-006. A biohazard task stays on the worklist and its detail does
// not: the circumstances of a spill are about whoever was in that bay.
func TestASpillTaskKeepsItsIncidentLinkAndHidesItsDetail(t *testing.T) {
	h := newHkpHarnessWith(t, hkpapp.Config{RequireIncidentForSpill: true})
	ctx := context.Background()
	h.standard(t, bedStandard("w3-bed-7", "bed-7"))

	// A link to an incident nobody can find is not a link.
	if _, err := h.hkp.RaiseCleaningTask(ctx,
		withFacility(h.nurseToken(), h.facility,
			&hkpv1.RaiseCleaningTaskRequest{
				LocationCode: "w3-bed-7",
				Kind:         hkpv1.TaskKind_TASK_KIND_SPILL,
				Detail:       "blood, bay 3", IncidentRef: "INC-9999",
			})); err == nil {
		t.Fatal("a spill task linked to an incident that does not exist")
	}

	reported, err := h.quality.ReportIncident(ctx,
		withFacility(h.officerToken(), h.facility,
			&qualityv1.ReportIncidentRequest{
				Reference: "INC-" + uuid.NewString()[:8],
				Category:  "environment",
				Reach:     qualityv1.Reach_REACH_NEAR_MISS,
				Harm:      qualityv1.Harm_HARM_NONE,
				Consequence: qualityv1.
					Consequence_CONSEQUENCE_MINOR,
				Likelihood: qualityv1.Likelihood_LIKELIHOOD_POSSIBLE,
				Narrative:  "blood spill in bay 3",
				Department: "ward-3", FacilityId: h.facility,
				OccurredAt: timestamppb.New(
					time.Now().UTC().Add(-time.Hour)),
			}))
	if err != nil {
		t.Fatalf("ReportIncident: %v", err)
	}
	incident := reported.Msg.GetIncident().GetIncidentId()

	// A biohazard task with no detail sends somebody with the wrong
	// equipment.
	if _, err := h.hkp.RaiseCleaningTask(ctx,
		withFacility(h.nurseToken(), h.facility,
			&hkpv1.RaiseCleaningTaskRequest{
				LocationCode: "w3-bed-7",
				Kind:         hkpv1.TaskKind_TASK_KIND_SPILL,
				IncidentRef:  incident,
			})); err == nil {
		t.Fatal("a spill task was raised with no detail")
	}

	raised, err := h.hkp.RaiseCleaningTask(ctx,
		withFacility(h.nurseToken(), h.facility,
			&hkpv1.RaiseCleaningTaskRequest{
				LocationCode: "w3-bed-7",
				Kind:         hkpv1.TaskKind_TASK_KIND_SPILL,
				Detail:       "blood, bay 3", IncidentRef: incident,
			}))
	if err != nil {
		t.Fatalf("RaiseCleaningTask: %v", err)
	}
	taskID := raised.Msg.GetTask().GetTaskId()
	if !raised.Msg.GetTask().GetRestricted() {
		t.Fatal("a spill task came back unrestricted")
	}

	// The cleaner going to it needs to know what it is before deciding what
	// to wear.
	forCleaner, err := h.hkp.GetCleaningTask(ctx,
		withFacility(h.cleanerToken(), h.facility,
			&hkpv1.GetCleaningTaskRequest{TaskId: taskID}))
	if err != nil {
		t.Fatalf("GetCleaningTask: %v", err)
	}
	if forCleaner.Msg.GetTask().GetDetail() != "blood, bay 3" ||
		forCleaner.Msg.GetTask().GetIncidentRef() != incident {
		t.Fatalf("the cleaner cannot see what was spilled: %+v",
			forCleaner.Msg.GetTask())
	}

	// The ward manager reading the board can see the task — somebody still
	// has to clean it — and not what it is.
	forMatron, err := h.hkp.ListCleaningTasks(ctx,
		withFacility(h.matronToken(), h.facility,
			&hkpv1.ListCleaningTasksRequest{OpenOnly: true}))
	if err != nil {
		t.Fatalf("ListCleaningTasks: %v", err)
	}
	if len(forMatron.Msg.GetTasks()) != 1 {
		t.Fatalf("the spill task left the worklist: %+v",
			forMatron.Msg.GetTasks())
	}
	hidden := forMatron.Msg.GetTasks()[0]
	if hidden.GetDetail() != "" || hidden.GetIncidentRef() != "" {
		t.Fatalf("a spill's detail reached a caller without the "+
			"permission for it: %+v", hidden)
	}
	if !hidden.GetRestricted() || hidden.GetLocationCode() != "w3-bed-7" {
		t.Fatalf("the redacted task lost what a cleaner needs: %+v", hidden)
	}
}

// SRS-HKP-007. A scan says somebody was in the room. It does not say they may
// be, and it does not finish anything.
func TestAScanIsEvidenceAndDoesNotMoveTheTask(t *testing.T) {
	h := newHkpHarness(t)
	ctx := context.Background()
	h.standard(t, bedStandard("w3-bed-7", "bed-7"))

	raised, err := h.hkp.RaiseCleaningTask(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&hkpv1.RaiseCleaningTaskRequest{
				LocationCode: "w3-bed-7",
				Kind:         hkpv1.TaskKind_TASK_KIND_ROUTINE,
			}))
	if err != nil {
		t.Fatalf("RaiseCleaningTask: %v", err)
	}
	taskID := raised.Msg.GetTask().GetTaskId()

	// Scanning the wrong door is a finding, not an error.
	wrong, err := h.hkp.RecordLocationScan(ctx,
		withFacility(h.cleanerToken(), h.facility,
			&hkpv1.RecordLocationScanRequest{
				TaskId: taskID, ScannedCode: "TH-2",
			}))
	if err != nil {
		t.Fatalf("RecordLocationScan: %v", err)
	}
	if wrong.Msg.GetScan().GetMatched() {
		t.Fatal("a scan of the wrong door matched")
	}
	if wrong.Msg.GetScan().GetScannedBy() != "cleaner-1" {
		t.Fatalf("the scan was not attributed to the caller: %+v",
			wrong.Msg.GetScan())
	}

	// And the task has not moved. Nothing in this contract completes work
	// because a scan happened.
	after, err := h.hkp.GetCleaningTask(ctx,
		withFacility(h.cleanerToken(), h.facility,
			&hkpv1.GetCleaningTaskRequest{TaskId: taskID}))
	if err != nil {
		t.Fatalf("GetCleaningTask: %v", err)
	}
	if after.Msg.GetTask().GetState() != hkpv1.TaskState_TASK_STATE_OPEN {
		t.Fatalf("a scan moved the task to %v",
			after.Msg.GetTask().GetState())
	}

	// A caller who may not work on the task may not scan against it either:
	// the permission decides, and the scan adds evidence rather than
	// permission.
	if _, err := h.hkp.RecordLocationScan(ctx,
		withFacility(h.nurseToken(), h.facility,
			&hkpv1.RecordLocationScanRequest{
				TaskId: taskID, ScannedCode: "W3-BED-7",
			})); err == nil {
		t.Fatal("somebody without hkp.task.work recorded a scan")
	}

	right, err := h.hkp.RecordLocationScan(ctx,
		withFacility(h.cleanerToken(), h.facility,
			&hkpv1.RecordLocationScanRequest{
				TaskId: taskID, ScannedCode: "W3-BED-7",
			}))
	if err != nil {
		t.Fatalf("RecordLocationScan: %v", err)
	}
	if !right.Msg.GetScan().GetMatched() {
		t.Fatal("the right door scanned did not match")
	}

	// Both scans are kept. The mismatch is the one an audit reads.
	withScans, err := h.hkp.GetCleaningTask(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&hkpv1.GetCleaningTaskRequest{TaskId: taskID}))
	if err != nil {
		t.Fatalf("GetCleaningTask: %v", err)
	}
	if len(withScans.Msg.GetTask().GetScans()) != 2 {
		t.Fatalf("want both scans kept, got %+v",
			withScans.Msg.GetTask().GetScans())
	}
}

// SRS-HKP-005, SRS-HKP-008. The theatre is escalated and the office is not,
// and the report is derived from the tasks rather than stored beside them.
func TestOnlyCriticalAreasEscalateAndTheReportComesFromTheTasks(t *testing.T) {
	h := newHkpHarness(t)
	ctx := context.Background()
	h.standard(t, bedStandard("w3-bed-7", "bed-7"))
	h.standard(t, theatreStandard())

	for _, code := range []string{"w3-bed-7", "th-2"} {
		if _, err := h.hkp.RaiseCleaningTask(ctx,
			withFacility(h.supervisorToken(), h.facility,
				&hkpv1.RaiseCleaningTaskRequest{
					LocationCode: code,
					Kind:         hkpv1.TaskKind_TASK_KIND_ROUTINE,
				})); err != nil {
			t.Fatalf("RaiseCleaningTask %s: %v", code, err)
		}
	}

	// Nothing is overdue yet, so nothing escalates.
	first, err := h.hkp.EscalateOverdueCleans(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&hkpv1.EscalateOverdueCleansRequest{}))
	if err != nil {
		t.Fatalf("EscalateOverdueCleans: %v", err)
	}
	if len(first.Msg.GetEscalated()) != 0 {
		t.Fatalf("a task escalated before its SLA: %+v",
			first.Msg.GetEscalated())
	}

	// Age both past their SLA. The theatre's is thirty minutes and the
	// bed's two hours; both are behind us now.
	if _, err := h.pool.Exec(ctx, `
		UPDATE housekeeping.cleaning_task
		SET due_by = now() - interval '1 hour'`); err != nil {
		t.Fatalf("age the tasks: %v", err)
	}

	escalated, err := h.hkp.EscalateOverdueCleans(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&hkpv1.EscalateOverdueCleansRequest{}))
	if err != nil {
		t.Fatalf("EscalateOverdueCleans: %v", err)
	}
	if len(escalated.Msg.GetEscalated()) != 1 ||
		escalated.Msg.GetEscalated()[0].GetLocationCode() != "th-2" {
		t.Fatalf("want only the theatre escalated, got %+v",
			escalated.Msg.GetEscalated())
	}

	// Once each. A channel that repeated every overdue clean is one people
	// filter, and the theatre goes with it.
	again, err := h.hkp.EscalateOverdueCleans(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&hkpv1.EscalateOverdueCleansRequest{}))
	if err != nil {
		t.Fatalf("EscalateOverdueCleans: %v", err)
	}
	if len(again.Msg.GetEscalated()) != 0 {
		t.Fatalf("an escalated task came up again: %+v",
			again.Msg.GetEscalated())
	}

	// A cleaner cannot read the compliance report they appear in.
	if _, err := h.hkp.GetCleaningReport(ctx,
		withFacility(h.cleanerToken(), h.facility,
			&hkpv1.GetCleaningReportRequest{})); err == nil {
		t.Fatal("a cleaner read the cleaning compliance report")
	}

	report, err := h.hkp.GetCleaningReport(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&hkpv1.GetCleaningReportRequest{}))
	if err != nil {
		t.Fatalf("GetCleaningReport: %v", err)
	}
	summary := report.Msg.GetSummary()
	if summary.GetRaised() != 2 || summary.GetOutstanding() != 2 ||
		summary.GetOverdueNow() != 2 || summary.GetCompleted() != 0 ||
		!summary.GetUnanswerable() {
		t.Fatalf("the report does not reconcile to the tasks: %+v", summary)
	}
}

// SRS-HKP-004, SRS-HKP-003. Where a hospital verifies its terminal cleans,
// the bed comes back when the supervisor says so and not when the cleaner
// does. Otherwise the verification changes nothing.
func TestWhereTerminalCleansAreVerifiedTheBedWaitsForTheSupervisor(
	t *testing.T) {

	h := newHkpHarnessWith(t, hkpapp.Config{RequireVerification: true})
	ctx := context.Background()
	h.standard(t, bedStandard("w3-bed-7", "bed-7"))

	triggered, err := h.hkp.TriggerTerminalClean(ctx,
		withFacility(h.nurseToken(), h.facility,
			&hkpv1.TriggerTerminalCleanRequest{
				LocationCode: "w3-bed-7", AssigneeId: "cleaner-1",
			}))
	if err != nil {
		t.Fatalf("TriggerTerminalClean: %v", err)
	}
	taskID := triggered.Msg.GetTask().GetTaskId()

	if _, err := h.hkp.StartCleaningTask(ctx,
		withFacility(h.cleanerToken(), h.facility,
			&hkpv1.StartCleaningTaskRequest{TaskId: taskID})); err != nil {
		t.Fatalf("StartCleaningTask: %v", err)
	}
	if _, err := h.hkp.CompleteCleaningTask(ctx,
		withFacility(h.cleanerToken(), h.facility,
			&hkpv1.CompleteCleaningTaskRequest{
				TaskId: taskID,
				Answers: []*hkpv1.ChecklistAnswer{
					{Code: "surfaces", Done: true},
					{Code: "floor", Done: true},
				},
			})); err != nil {
		t.Fatalf("CompleteCleaningTask: %v", err)
	}

	status, err := h.hkp.GetBedStatus(ctx,
		withFacility(h.nurseToken(), h.facility,
			&hkpv1.GetBedStatusRequest{BedId: "bed-7"}))
	if err != nil {
		t.Fatalf("GetBedStatus: %v", err)
	}
	if status.Msg.GetClear() {
		t.Fatal("the bed came back on the cleaner's word alone")
	}

	held, err := h.hkp.ListHeldBeds(ctx,
		withFacility(h.matronToken(), h.facility,
			&hkpv1.ListHeldBedsRequest{}))
	if err != nil {
		t.Fatalf("ListHeldBeds: %v", err)
	}
	if len(held.Msg.GetHolds()) != 1 {
		t.Fatalf("want the bed on the held list, got %+v",
			held.Msg.GetHolds())
	}

	if _, err := h.hkp.VerifyCleaningTask(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&hkpv1.VerifyCleaningTaskRequest{
				TaskId: taskID, Note: "checked",
			})); err != nil {
		t.Fatalf("VerifyCleaningTask: %v", err)
	}

	status, err = h.hkp.GetBedStatus(ctx,
		withFacility(h.nurseToken(), h.facility,
			&hkpv1.GetBedStatusRequest{BedId: "bed-7"}))
	if err != nil {
		t.Fatalf("GetBedStatus: %v", err)
	}
	if !status.Msg.GetClear() {
		t.Fatal("the bed is still held after verification")
	}
}

// SRS-HKP-001. The routine schedule is derived from the configuration in
// force and the cleans already done, so a frequency changed this morning
// changes what is due this afternoon.
func TestTheRoutineScheduleFollowsTheStandardInForce(t *testing.T) {
	h := newHkpHarness(t)
	ctx := context.Background()
	h.standard(t, bedStandard("w3-bed-7", "bed-7"))
	h.standard(t, theatreStandard())

	due, err := h.hkp.ListDueRoutineCleans(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&hkpv1.ListDueRoutineCleansRequest{}))
	if err != nil {
		t.Fatalf("ListDueRoutineCleans: %v", err)
	}
	// Neither has ever been cleaned, so both are due and both say so: a room
	// with no history is the one most likely to have been missed.
	if len(due.Msg.GetDue()) != 2 {
		t.Fatalf("want both locations due, got %+v", due.Msg.GetDue())
	}
	for _, item := range due.Msg.GetDue() {
		if !item.GetNeverCleaned() {
			t.Fatalf("a never-cleaned location did not say so: %+v", item)
		}
	}

	// Clean the bed, and it drops off until its frequency comes round.
	raised, err := h.hkp.RaiseCleaningTask(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&hkpv1.RaiseCleaningTaskRequest{
				LocationCode: "w3-bed-7",
				Kind:         hkpv1.TaskKind_TASK_KIND_ROUTINE,
			}))
	if err != nil {
		t.Fatalf("RaiseCleaningTask: %v", err)
	}
	taskID := raised.Msg.GetTask().GetTaskId()
	if _, err := h.hkp.StartCleaningTask(ctx,
		withFacility(h.cleanerToken(), h.facility,
			&hkpv1.StartCleaningTaskRequest{TaskId: taskID})); err != nil {
		t.Fatalf("StartCleaningTask: %v", err)
	}
	if _, err := h.hkp.CompleteCleaningTask(ctx,
		withFacility(h.cleanerToken(), h.facility,
			&hkpv1.CompleteCleaningTaskRequest{
				TaskId: taskID,
				Answers: []*hkpv1.ChecklistAnswer{
					{Code: "surfaces", Done: true},
					{Code: "floor", Done: true},
				},
			})); err != nil {
		t.Fatalf("CompleteCleaningTask: %v", err)
	}

	due, err = h.hkp.ListDueRoutineCleans(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&hkpv1.ListDueRoutineCleansRequest{}))
	if err != nil {
		t.Fatalf("ListDueRoutineCleans: %v", err)
	}
	if len(due.Msg.GetDue()) != 1 ||
		due.Msg.GetDue()[0].GetLocation().GetCode() != "th-2" {
		t.Fatalf("want only the theatre due, got %+v", due.Msg.GetDue())
	}

	// Shorten the bed's frequency to an hour and age the completion. The
	// same history is due again, with nothing regenerated.
	quicker := bedStandard("w3-bed-7", "bed-7")
	quicker.RoutineEveryHours = 1
	h.standard(t, quicker)
	if _, err := h.pool.Exec(ctx, `
		UPDATE housekeeping.cleaning_task
		SET completed_at = now() - interval '3 hours'
		WHERE task_id = $1`, taskID); err != nil {
		t.Fatalf("age the completion: %v", err)
	}

	due, err = h.hkp.ListDueRoutineCleans(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&hkpv1.ListDueRoutineCleansRequest{}))
	if err != nil {
		t.Fatalf("ListDueRoutineCleans: %v", err)
	}
	if len(due.Msg.GetDue()) != 2 {
		t.Fatalf("the shortened frequency did not bring the bed back: %+v",
			due.Msg.GetDue())
	}
}

// Nobody outside the tenant sees any of it, and a caller with no housekeeping
// permission at all sees nothing either.
func TestHousekeepingIsTenantScopedAndPermissioned(t *testing.T) {
	h := newHkpHarness(t)
	ctx := context.Background()
	h.standard(t, bedStandard("w3-bed-7", "bed-7"))

	raised, err := h.hkp.RaiseCleaningTask(ctx,
		withFacility(h.supervisorToken(), h.facility,
			&hkpv1.RaiseCleaningTaskRequest{
				LocationCode: "w3-bed-7",
				Kind:         hkpv1.TaskKind_TASK_KIND_ROUTINE,
			}))
	if err != nil {
		t.Fatalf("RaiseCleaningTask: %v", err)
	}
	taskID := raised.Msg.GetTask().GetTaskId()

	// A clerk holds no housekeeping permission.
	if _, err := h.hkp.GetCleaningTask(ctx,
		withFacility(h.clerkToken(), h.facility,
			&hkpv1.GetCleaningTaskRequest{
				TaskId: taskID,
			})); err == nil {
		t.Fatal("a registration clerk read a cleaning task")
	}

	// And another tenant's supervisor sees an absence rather than a refusal,
	// so a probe cannot confirm the identifier exists.
	other := h.tenantID
	stranger := strings.Replace(other, other[:8], "00000000", 1) +
		":hk-super:housekeeping_supervisor:" + h.facility
	if _, err := h.hkp.GetCleaningTask(ctx,
		withFacility(stranger, h.facility,
			&hkpv1.GetCleaningTaskRequest{
				TaskId: taskID,
			})); err == nil {
		t.Fatal("another tenant read a cleaning task")
	}

	// A second cleaner may work the task — the worklist is shared — but a
	// scan is still attributed to whoever made it.
	if _, err := h.hkp.StartCleaningTask(ctx,
		withFacility(h.otherCleanerToken(), h.facility,
			&hkpv1.StartCleaningTaskRequest{TaskId: taskID})); err != nil {
		t.Fatalf("StartCleaningTask: %v", err)
	}
	scan, err := h.hkp.RecordLocationScan(ctx,
		withFacility(h.otherCleanerToken(), h.facility,
			&hkpv1.RecordLocationScanRequest{
				TaskId: taskID, ScannedCode: "W3-BED-7",
			}))
	if err != nil {
		t.Fatalf("RecordLocationScan: %v", err)
	}
	if scan.Msg.GetScan().GetScannedBy() != "cleaner-2" {
		t.Fatalf("the scan was attributed to the wrong person: %+v",
			scan.Msg.GetScan())
	}
}
