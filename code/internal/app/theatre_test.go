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

// The operating theatre (SRS-OT-001 … 017), end to end.
//
// The domain tests hold the rules. These hold what only the assembled stack
// shows: that a procedure with sides cannot be scheduled without one, that a
// hard clash is refused whoever asks and a soft one needs a reason, that
// consent cannot be waived by anybody, that a recall reaches the patient who
// received the lot, and that the board's stage follows the milestones.

type otHarness struct {
	pool       *pgxpool.Pool
	theatre    theatrev1connect.TheatreServiceClient
	encounters encounterv1connect.EncounterServiceClient
	patients   empiv1connect.PatientServiceClient
	org        organizationv1connect.OrganizationServiceClient

	tenantID string
	facility string
}

func newOtHarness(t *testing.T) *otHarness {
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
		// The trigger-finger code has sides; the laparotomy does not.
		LateralProcedures: []string{"M65.3"},
	})

	server := httptest.NewServer(h2c.NewHandler(built.Handler, &http2.Server{}))
	t.Cleanup(server.Close)

	h := &otHarness{
		pool:       pool,
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

	for _, module := range []string{"empi", "encounter", "theatre"} {
		h.entitle(t, module)
	}
	return h
}

func (h *otHarness) entitle(t *testing.T, module string) {
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

func (h *otHarness) surgeonToken() string {
	return h.tenantID + ":surgeon-1:clinician:" + h.facility
}

func (h *otHarness) otherSurgeonToken() string {
	return h.tenantID + ":surgeon-2:clinician:" + h.facility
}

func (h *otHarness) nurseToken() string {
	return h.tenantID + ":nurse-1:nurse:" + h.facility
}

func (h *otHarness) schedulerToken() string {
	return h.tenantID + ":sched-1:scheduler:" + h.facility
}

func (h *otHarness) himToken() string {
	return h.tenantID + ":him-1:him_officer:" + h.facility
}

func (h *otHarness) clerkToken() string {
	return h.tenantID + ":clerk-1:registration_clerk:" + h.facility
}

// room configures a theatre.
func (h *otHarness) room(t *testing.T, code string, equipment []string) string {
	t.Helper()

	saved, err := h.theatre.SaveRoom(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &theatrev1.SaveRoomRequest{
			FacilityId: h.facility, Code: code, Name: "Theatre " + code,
			Equipment: equipment, Active: true,
		}))
	if err != nil {
		t.Fatalf("SaveRoom: %v", err)
	}
	return saved.Msg.GetRoom().GetRoomId()
}

// encounter registers a patient and opens the encounter a case hangs off.
func (h *otHarness) encounter(t *testing.T, family, phone string) string {
	t.Helper()

	registered, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterPatientRequest{
			Demographics: demographics(family, []string{"Vikram"},
				date(1980, 7, 21), empiv1.Sex_SEX_MALE, phone),
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
	return opened.Msg.GetEncounter().GetEncounterId()
}

// request raises a complete, schedulable surgery request.
func (h *otHarness) request(t *testing.T, encounterID string,
	mutate func(*theatrev1.RequestSurgeryRequest)) *theatrev1.RequestSurgeryResponse {

	t.Helper()

	req := &theatrev1.RequestSurgeryRequest{
		EncounterId: encounterID, FacilityId: h.facility,
		ProcedureCode: "M65.3", ProcedureDisplay: "Trigger finger release",
		DiagnosisCode: "M65.3", DiagnosisDisplay: "Trigger finger",
		Laterality:              theatrev1.Laterality_LATERALITY_RIGHT,
		Site:                    "right ring finger",
		Urgency:                 theatrev1.Urgency_URGENCY_ELECTIVE,
		ExpectedDurationSeconds: 1800,
		SurgeonId:               "surgeon-1",
	}
	if mutate != nil {
		mutate(req)
	}

	out, err := h.theatre.RequestSurgery(context.Background(),
		withFacility(h.surgeonToken(), h.facility, req))
	if err != nil {
		t.Fatalf("RequestSurgery: %v", err)
	}
	return out.Msg
}

// SRS-OT-002. A procedure with sides and no side recorded is kept out of the
// schedulable state rather than refused: a surgeon who cannot put a patient on
// a list at all is a surgeon keeping a paper list.
func TestARequestWithNoSideIsRecordedButNotSchedulable(t *testing.T) {
	h := newOtHarness(t)
	encounter := h.encounter(t, "Nair", "+91-99000-44001")

	result := h.request(t, encounter, func(req *theatrev1.RequestSurgeryRequest) {
		req.Laterality = theatrev1.Laterality_LATERALITY_UNSPECIFIED
	})

	if result.GetSurgicalCase().GetStatus() !=
		theatrev1.CaseStatus_CASE_STATUS_REQUESTED {
		t.Fatalf("status = %v, want requested", result.GetSurgicalCase().GetStatus())
	}
	found := false
	for _, item := range result.GetOutstanding() {
		if item == "laterality" {
			found = true
		}
	}
	if !found {
		t.Fatalf("outstanding = %v, want laterality", result.GetOutstanding())
	}

	// A procedure the deployment has not listed as lateral needs none.
	other := h.encounter(t, "Desai", "+91-99000-44002")
	laparotomy := h.request(t, other, func(req *theatrev1.RequestSurgeryRequest) {
		req.ProcedureCode = "0DTN0ZZ"
		req.ProcedureDisplay = "Laparotomy"
		req.DiagnosisCode = "K35.8"
		req.Laterality = theatrev1.Laterality_LATERALITY_UNSPECIFIED
		req.Site = "abdomen"
	})
	if laparotomy.GetSurgicalCase().GetStatus() !=
		theatrev1.CaseStatus_CASE_STATUS_SCHEDULABLE {
		t.Fatalf("status = %v on a procedure with no sides",
			laparotomy.GetSurgicalCase().GetStatus())
	}

	// Completing the first request with a side makes it schedulable.
	completed, err := h.theatre.CompleteRequest(context.Background(),
		withFacility(h.surgeonToken(), h.facility, &theatrev1.CompleteRequestRequest{
			CaseId:     result.GetSurgicalCase().GetCaseId(),
			Laterality: theatrev1.Laterality_LATERALITY_RIGHT,
			Site:       "right ring finger",
		}))
	if err != nil {
		t.Fatalf("CompleteRequest: %v", err)
	}
	if completed.Msg.GetSurgicalCase().GetStatus() !=
		theatrev1.CaseStatus_CASE_STATUS_SCHEDULABLE {
		t.Fatalf("status = %v after the side was recorded",
			completed.Msg.GetSurgicalCase().GetStatus())
	}
}

// SRS-OT-004. Every clash at once, a hard one refused whoever asks, and a soft
// one needing its own permission and a reason.
func TestSchedulingReportsEveryClashAndOnlyOverridesSoftOnes(t *testing.T) {
	h := newOtHarness(t)
	room := h.room(t, "OT1", []string{"laminar flow"})

	first := h.request(t, h.encounter(t, "Iyer", "+91-99000-44003"), nil)
	second := h.request(t, h.encounter(t, "Rao", "+91-99000-44004"),
		func(req *theatrev1.RequestSurgeryRequest) {
			req.Requirements = []string{"image intensifier"}
		})

	start := time.Now().UTC().Add(2 * time.Hour)
	if _, err := h.theatre.ScheduleCase(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &theatrev1.ScheduleCaseRequest{
			CaseId: first.GetSurgicalCase().GetCaseId(), RoomId: room,
			Start: timestamppb.New(start),
			End:   timestamppb.New(start.Add(time.Hour)),
		})); err != nil {
		t.Fatalf("ScheduleCase: %v", err)
	}

	// The second case clashes with the first and wants equipment the room does
	// not have.
	overlapping := &theatrev1.CheckSlotRequest{
		CaseId: second.GetSurgicalCase().GetCaseId(), RoomId: room,
		Start: timestamppb.New(start.Add(30 * time.Minute)),
		End:   timestamppb.New(start.Add(90 * time.Minute)),
	}
	checked, err := h.theatre.CheckSlot(context.Background(),
		withFacility(h.schedulerToken(), h.facility, overlapping))
	if err != nil {
		t.Fatalf("CheckSlot: %v", err)
	}
	// Three: the room is taken, the surgeon is in it, and the equipment is
	// missing. All at once, which is the point — a scheduler told one at a
	// time rebooks once per clash.
	if len(checked.Msg.GetConflicts()) != 3 {
		t.Fatalf("%d conflicts, want the room, the surgeon and the equipment: %v",
			len(checked.Msg.GetConflicts()), checked.Msg.GetConflicts())
	}
	var hard, soft int
	for _, conflict := range checked.Msg.GetConflicts() {
		if conflict.GetOverridable() {
			soft++
		} else {
			hard++
		}
	}
	if hard != 2 || soft != 1 {
		t.Fatalf("conflicts = %v; the room and the surgeon are hard, the "+
			"equipment is soft", checked.Msg.GetConflicts())
	}

	// Overriding does not help: the room clash is hard.
	if _, err := h.theatre.ScheduleCase(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &theatrev1.ScheduleCaseRequest{
			CaseId: second.GetSurgicalCase().GetCaseId(), RoomId: room,
			Start:    overlapping.GetStart(),
			End:      overlapping.GetEnd(),
			Override: true, OverrideReason: "list is full",
		})); err == nil {
		t.Fatal("a hard room clash was overridden")
	}

	// A later slot leaves only the soft equipment conflict, which needs the
	// override permission and a reason.
	later := &theatrev1.ScheduleCaseRequest{
		CaseId: second.GetSurgicalCase().GetCaseId(), RoomId: room,
		Start: timestamppb.New(start.Add(2 * time.Hour)),
		End:   timestamppb.New(start.Add(3 * time.Hour)),
	}
	if _, err := h.theatre.ScheduleCase(context.Background(),
		withFacility(h.schedulerToken(), h.facility, later)); err == nil {
		t.Fatal("a conflicting slot was booked with no override")
	}

	later.Override = true
	if _, err := h.theatre.ScheduleCase(context.Background(),
		withFacility(h.schedulerToken(), h.facility, later)); err == nil {
		t.Fatal("an override with no reason was accepted")
	}

	later.OverrideReason = "image intensifier borrowed from OT2"
	booked, err := h.theatre.ScheduleCase(context.Background(),
		withFacility(h.schedulerToken(), h.facility, later))
	if err != nil {
		t.Fatalf("ScheduleCase (override): %v", err)
	}
	if !booked.Msg.GetBooked() {
		t.Fatal("the override did not book the case")
	}
	// The scheduler still sees what they overrode.
	if len(booked.Msg.GetConflicts()) != 1 {
		t.Fatalf("conflicts = %v; a scheduler who overrode one should see it",
			booked.Msg.GetConflicts())
	}

	// And a surgeon cannot book at all.
	if _, err := h.theatre.ScheduleCase(context.Background(),
		withFacility(h.surgeonToken(), h.facility, &theatrev1.ScheduleCaseRequest{
			CaseId: first.GetSurgicalCase().GetCaseId(), RoomId: room,
			Start: timestamppb.New(start.Add(6 * time.Hour)),
			End:   timestamppb.New(start.Add(7 * time.Hour)),
		})); err == nil {
		t.Fatal("a surgeon booked their own case")
	}
}

// A surgeon in two theatres at once is the clash a room-only check misses, and
// it is hard.
func TestASurgeonCannotBeBookedInTwoTheatresAtOnce(t *testing.T) {
	h := newOtHarness(t)
	first := h.room(t, "OT1", nil)
	second := h.room(t, "OT2", nil)

	one := h.request(t, h.encounter(t, "Pillai", "+91-99000-44005"), nil)
	two := h.request(t, h.encounter(t, "Shetty", "+91-99000-44006"), nil)

	start := time.Now().UTC().Add(2 * time.Hour)
	if _, err := h.theatre.ScheduleCase(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &theatrev1.ScheduleCaseRequest{
			CaseId: one.GetSurgicalCase().GetCaseId(), RoomId: first,
			Start: timestamppb.New(start),
			End:   timestamppb.New(start.Add(2 * time.Hour)),
		})); err != nil {
		t.Fatalf("ScheduleCase: %v", err)
	}

	conflicts, err := h.theatre.CheckSlot(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &theatrev1.CheckSlotRequest{
			CaseId: two.GetSurgicalCase().GetCaseId(), RoomId: second,
			Start: timestamppb.New(start.Add(time.Hour)),
			End:   timestamppb.New(start.Add(90 * time.Minute)),
		}))
	if err != nil {
		t.Fatalf("CheckSlot: %v", err)
	}
	if len(conflicts.Msg.GetConflicts()) != 1 ||
		conflicts.Msg.GetConflicts()[0].GetKind() != "surgeon" {
		t.Fatalf("conflicts = %v, want the surgeon clash",
			conflicts.Msg.GetConflicts())
	}
	if conflicts.Msg.GetConflicts()[0].GetOverridable() {
		t.Fatal("the surgeon clash was overridable")
	}
}

// SRS-OT-006. Consent cannot be waived by anybody, and a waiver of anything
// else needs the right role and a reason.
func TestConsentCannotBeWaivedAndOtherWaiversNeedTheRightRole(t *testing.T) {
	h := newOtHarness(t)
	c := h.scheduledCase(t)

	if _, err := h.theatre.RecordPreop(context.Background(),
		withFacility(h.surgeonToken(), h.facility, &theatrev1.RecordPreopRequest{
			CaseId: c.caseID, Code: "consent",
			State: theatrev1.PreopState_PREOP_STATE_WAIVED,
			Note:  "running late", WaivedRole: "surgeon",
		})); err == nil {
		t.Fatal("consent was waived")
	}

	// A surgeon cannot waive the anaesthetist's item.
	if _, err := h.theatre.RecordPreop(context.Background(),
		withFacility(h.surgeonToken(), h.facility, &theatrev1.RecordPreopRequest{
			CaseId: c.caseID, Code: "fasting",
			State: theatrev1.PreopState_PREOP_STATE_WAIVED,
			Note:  "emergency", WaivedRole: "surgeon",
		})); err == nil {
		t.Fatal("a surgeon waived the anaesthetist's item")
	}

	// And a nurse cannot waive anything at all: they escalate instead.
	if _, err := h.theatre.RecordPreop(context.Background(),
		withFacility(h.nurseToken(), h.facility, &theatrev1.RecordPreopRequest{
			CaseId: c.caseID, Code: "blood",
			State: theatrev1.PreopState_PREOP_STATE_WAIVED,
			Note:  "group and save only", WaivedRole: "surgeon",
		})); err == nil {
		t.Fatal("a theatre nurse waived a pre-operative blocker")
	}

	// The surgeon may waive their own items, with a reason.
	if _, err := h.theatre.RecordPreop(context.Background(),
		withFacility(h.surgeonToken(), h.facility, &theatrev1.RecordPreopRequest{
			CaseId: c.caseID, Code: "blood",
			State:      theatrev1.PreopState_PREOP_STATE_WAIVED,
			WaivedRole: "surgeon",
		})); err == nil {
		t.Fatal("an unexplained waiver was accepted")
	}
	if _, err := h.theatre.RecordPreop(context.Background(),
		withFacility(h.surgeonToken(), h.facility, &theatrev1.RecordPreopRequest{
			CaseId: c.caseID, Code: "blood",
			State: theatrev1.PreopState_PREOP_STATE_WAIVED,
			Note:  "day-case procedure, group and save only", WaivedRole: "surgeon",
		})); err != nil {
		t.Fatalf("RecordPreop: %v", err)
	}
}

// SRS-OT-006 and SRS-OT-013. Clearing the checklist moves the case to ready,
// which is what the board's "next case ready" column reads — so a theatre
// cannot have a clear checklist and a case still marked not ready.
func TestClearingTheChecklistMakesTheCaseReady(t *testing.T) {
	h := newOtHarness(t)
	c := h.scheduledCase(t)

	blockers, err := h.theatre.ListBlockers(context.Background(),
		withFacility(h.nurseToken(), h.facility, &theatrev1.ListBlockersRequest{
			CaseId: c.caseID,
		}))
	if err != nil {
		t.Fatalf("ListBlockers: %v", err)
	}
	if len(blockers.Msg.GetBlockers()) != 7 {
		t.Fatalf("%d blockers on an untouched checklist, want every mandatory item",
			len(blockers.Msg.GetBlockers()))
	}

	h.clearChecklist(t, c.caseID)

	got, err := h.theatre.GetSurgicalCase(context.Background(),
		withFacility(h.nurseToken(), h.facility, &theatrev1.GetSurgicalCaseRequest{
			CaseId: c.caseID,
		}))
	if err != nil {
		t.Fatalf("GetSurgicalCase: %v", err)
	}
	if got.Msg.GetSurgicalCase().GetStatus() != theatrev1.CaseStatus_CASE_STATUS_READY {
		t.Fatalf("status = %v after the checklist cleared",
			got.Msg.GetSurgicalCase().GetStatus())
	}
	if len(got.Msg.GetBlockers()) != 0 {
		t.Fatalf("blockers = %v", got.Msg.GetBlockers())
	}

	board, err := h.theatre.GetBoard(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &theatrev1.GetBoardRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("GetBoard: %v", err)
	}
	if len(board.Msg.GetRows()) != 1 {
		t.Fatalf("%d theatres on the board, want 1", len(board.Msg.GetRows()))
	}
	if !board.Msg.GetRows()[0].GetNextReady() {
		t.Fatalf("the board says the next case is not ready: %v",
			board.Msg.GetRows()[0].GetNextBlockers())
	}
}

// SRS-OT-007. A time-out needs the team, and every question answered: silence
// is not confirmation, and an unconfirmed item needs an explicit exception.
func TestATimeOutNeedsTheTeamAndEveryAnswer(t *testing.T) {
	h := newOtHarness(t)
	c := h.scheduledCase(t)

	answers := timeOutAnswers(true)

	if _, err := h.theatre.PerformSafetyCheck(context.Background(),
		withFacility(h.nurseToken(), h.facility, &theatrev1.PerformSafetyCheckRequest{
			CaseId: c.caseID, Phase: theatrev1.SafetyPhase_SAFETY_PHASE_TIME_OUT,
			Participants: []string{"nurse-1"}, Answers: answers,
		})); err == nil {
		t.Fatal("a solo time-out was accepted")
	}

	if _, err := h.theatre.PerformSafetyCheck(context.Background(),
		withFacility(h.nurseToken(), h.facility, &theatrev1.PerformSafetyCheckRequest{
			CaseId: c.caseID, Phase: theatrev1.SafetyPhase_SAFETY_PHASE_TIME_OUT,
			Participants: []string{"nurse-1", "surgeon-1", "anaes-1"},
			Answers:      answers[1:],
		})); err == nil {
		t.Fatal("a time-out was completed with a question unanswered")
	}

	unconfirmed := timeOutAnswers(true)
	unconfirmed[0].Confirmed = false
	if _, err := h.theatre.PerformSafetyCheck(context.Background(),
		withFacility(h.nurseToken(), h.facility, &theatrev1.PerformSafetyCheckRequest{
			CaseId: c.caseID, Phase: theatrev1.SafetyPhase_SAFETY_PHASE_TIME_OUT,
			Participants: []string{"nurse-1", "surgeon-1", "anaes-1"},
			Answers:      unconfirmed,
		})); err == nil {
		t.Fatal("an unconfirmed item was accepted with no exception")
	}

	unconfirmed[0].Exception = "prophylaxis contraindicated, documented"
	performed, err := h.theatre.PerformSafetyCheck(context.Background(),
		withFacility(h.nurseToken(), h.facility, &theatrev1.PerformSafetyCheckRequest{
			CaseId: c.caseID, Phase: theatrev1.SafetyPhase_SAFETY_PHASE_TIME_OUT,
			Participants: []string{"nurse-1", "surgeon-1", "anaes-1"},
			Answers:      unconfirmed,
		}))
	if err != nil {
		t.Fatalf("PerformSafetyCheck: %v", err)
	}
	if len(performed.Msg.GetCheck().GetParticipants()) != 3 {
		t.Fatalf("participants = %v", performed.Msg.GetCheck().GetParticipants())
	}
}

func timeOutAnswers(confirmed bool) []*theatrev1.SafetyAnswer {
	codes := []string{
		"team_introduced", "patient_procedure_site", "critical_steps",
		"antibiotic", "imaging",
	}
	out := make([]*theatrev1.SafetyAnswer, 0, len(codes))
	for _, code := range codes {
		out = append(out, &theatrev1.SafetyAnswer{Code: code, Confirmed: confirmed})
	}
	return out
}

// SRS-OT-008, SRS-OT-013 and SRS-OT-015. The board's stage follows the
// milestones, and the intervals are derived — one whose milestones have not
// both happened is absent rather than zero.
func TestTheBoardAndTheIntervalsFollowTheMilestones(t *testing.T) {
	h := newOtHarness(t)
	c := h.scheduledCase(t)
	h.clearChecklist(t, c.caseID)

	in := time.Now().UTC().Add(-40 * time.Minute)
	for _, step := range []struct {
		milestone theatrev1.Milestone
		at        time.Time
	}{
		{theatrev1.Milestone_MILESTONE_THEATRE_IN, in},
		{theatrev1.Milestone_MILESTONE_ANAESTHESIA_START, in.Add(5 * time.Minute)},
		{theatrev1.Milestone_MILESTONE_INCISION, in.Add(25 * time.Minute)},
	} {
		if _, err := h.theatre.RecordMilestone(context.Background(),
			withFacility(h.nurseToken(), h.facility, &theatrev1.RecordMilestoneRequest{
				CaseId: c.caseID, Milestone: step.milestone,
				OccurredAt: timestamppb.New(step.at),
			})); err != nil {
			t.Fatalf("RecordMilestone(%v): %v", step.milestone, err)
		}
	}

	timeline, err := h.theatre.GetTimeline(context.Background(),
		withFacility(h.nurseToken(), h.facility, &theatrev1.GetTimelineRequest{
			CaseId: c.caseID,
		}))
	if err != nil {
		t.Fatalf("GetTimeline: %v", err)
	}
	intervals := timeline.Msg.GetIntervals()
	if intervals.AnaesthesiaToIncisionSeconds == nil ||
		*intervals.AnaesthesiaToIncisionSeconds != 1200 {
		t.Fatalf("anaesthesia to incision = %v, want 1200s",
			intervals.AnaesthesiaToIncisionSeconds)
	}
	// The patient is still in theatre, so there is no occupancy yet: a zero
	// would make the list look efficient while the case was running.
	if intervals.TheatreOccupancySeconds != nil {
		t.Fatalf("occupancy = %v on a case still in theatre",
			*intervals.TheatreOccupancySeconds)
	}

	board, err := h.theatre.GetBoard(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &theatrev1.GetBoardRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("GetBoard: %v", err)
	}
	row := board.Msg.GetRows()[0]
	if row.GetStage() != theatrev1.RoomStage_ROOM_STAGE_IN_USE {
		t.Fatalf("stage = %v, want in use", row.GetStage())
	}
	if row.GetCurrentMilestone() != theatrev1.Milestone_MILESTONE_INCISION {
		t.Fatalf("milestone = %v, want incision", row.GetCurrentMilestone())
	}
	if row.GetCurrentCaseId() != c.caseID {
		t.Fatalf("current case = %q", row.GetCurrentCaseId())
	}
}

// SRS-OT-005 and SRS-OT-014. Both carry coded causes, because a free-text
// classification produces a report nobody can act on.
func TestCancellationsAndDelaysCarryCodedCauses(t *testing.T) {
	h := newOtHarness(t)
	c := h.scheduledCase(t)

	if _, err := h.theatre.RecordDelay(context.Background(),
		withFacility(h.nurseToken(), h.facility, &theatrev1.RecordDelayRequest{
			CaseId: c.caseID, Minutes: 25, Note: "waiting for a set",
		})); err == nil {
		t.Fatal("an unclassified delay was accepted")
	}
	if _, err := h.theatre.RecordDelay(context.Background(),
		withFacility(h.nurseToken(), h.facility, &theatrev1.RecordDelayRequest{
			CaseId:     c.caseID,
			Reason:     theatrev1.DelayReason_DELAY_REASON_INSTRUMENTS,
			Dependency: "cssd", Minutes: 25,
			Note: "set not returned from sterilisation",
		})); err != nil {
		t.Fatalf("RecordDelay: %v", err)
	}

	if _, err := h.theatre.CloseCase(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &theatrev1.CloseCaseRequest{
			CaseId: c.caseID, Reason: "no bed",
		})); err == nil {
		t.Fatal("a cancellation with no coded cause was accepted")
	}

	closed, err := h.theatre.CloseCase(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &theatrev1.CloseCaseRequest{
			CaseId: c.caseID, Postpone: true,
			Cause:  theatrev1.CaseCause_CASE_CAUSE_RESOURCE,
			Reason: "no critical care bed",
		}))
	if err != nil {
		t.Fatalf("CloseCase: %v", err)
	}
	if closed.Msg.GetSurgicalCase().GetStatus() !=
		theatrev1.CaseStatus_CASE_STATUS_POSTPONED {
		t.Fatalf("status = %v", closed.Msg.GetSurgicalCase().GetStatus())
	}
	// A postponed case releases its slot and goes back on the waiting list.
	if closed.Msg.GetSurgicalCase().GetRoomId() != "" {
		t.Fatal("the postponed case still holds a room")
	}
	waiting, err := h.theatre.ListWaiting(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &theatrev1.ListWaitingRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("ListWaiting: %v", err)
	}
	if len(waiting.Msg.GetCases()) != 1 {
		t.Fatalf("%d cases waiting, want the postponed one back",
			len(waiting.Msg.GetCases()))
	}
}

// SRS-OT-009. A signed operative note is amended into a new version and the
// original is kept: the document read in a claim cannot have had its history
// overwritten. And signing is the surgeon's, not the scribe's.
func TestASignedNoteIsAmendedNotEdited(t *testing.T) {
	h := newOtHarness(t)
	c := h.scheduledCase(t)

	written, err := h.theatre.WriteOperativeNote(context.Background(),
		withFacility(h.nurseToken(), h.facility,
			&theatrev1.WriteOperativeNoteRequest{
				CaseId: c.caseID, ProcedurePerformed: "Trigger finger release",
				Findings: "A1 pulley released", EstimatedBloodLossMl: 5,
			}))
	if err != nil {
		t.Fatalf("WriteOperativeNote: %v", err)
	}
	noteID := written.Msg.GetNote().GetNoteId()

	// A nurse may type it and may not sign it.
	if _, err := h.theatre.SignOperativeNote(context.Background(),
		withFacility(h.nurseToken(), h.facility,
			&theatrev1.SignOperativeNoteRequest{
				CaseId: c.caseID, NoteId: noteID,
			})); err == nil {
		t.Fatal("a theatre nurse signed the operative note")
	}

	if _, err := h.theatre.SignOperativeNote(context.Background(),
		withFacility(h.surgeonToken(), h.facility,
			&theatrev1.SignOperativeNoteRequest{
				CaseId: c.caseID, NoteId: noteID,
			})); err != nil {
		t.Fatalf("SignOperativeNote: %v", err)
	}

	if _, err := h.theatre.AmendOperativeNote(context.Background(),
		withFacility(h.surgeonToken(), h.facility,
			&theatrev1.AmendOperativeNoteRequest{
				CaseId: c.caseID, NoteId: noteID,
				ProcedurePerformed: "Trigger finger release, left",
			})); err == nil {
		t.Fatal("an unexplained amendment was accepted")
	}

	if _, err := h.theatre.AmendOperativeNote(context.Background(),
		withFacility(h.surgeonToken(), h.facility,
			&theatrev1.AmendOperativeNoteRequest{
				CaseId: c.caseID, NoteId: noteID,
				Reason:               "side recorded incorrectly",
				ProcedurePerformed:   "Trigger finger release, right ring finger",
				EstimatedBloodLossMl: 5,
			})); err != nil {
		t.Fatalf("AmendOperativeNote: %v", err)
	}

	got, err := h.theatre.GetSurgicalCase(context.Background(),
		withFacility(h.surgeonToken(), h.facility,
			&theatrev1.GetSurgicalCaseRequest{CaseId: c.caseID}))
	if err != nil {
		t.Fatalf("GetSurgicalCase: %v", err)
	}
	if len(got.Msg.GetNotes()) != 2 {
		t.Fatalf("%d notes, want both versions kept", len(got.Msg.GetNotes()))
	}
	if got.Msg.GetNotes()[0].GetStatus() !=
		theatrev1.NoteStatus_NOTE_STATUS_SUPERSEDED {
		t.Fatalf("version 1 status = %v", got.Msg.GetNotes()[0].GetStatus())
	}
	if got.Msg.GetNotes()[1].GetAmendmentReason() == "" {
		t.Fatal("the amendment reason was lost")
	}
}

// SRS-OT-010. A recall reaches the patients who received the lot, and it needs
// a permission of its own because it reaches across patients rather than into
// one chart.
func TestARecallReachesThePatientsAndNeedsItsOwnPermission(t *testing.T) {
	h := newOtHarness(t)
	affected := h.scheduledCase(t)
	other := h.scheduledCase(t)

	// An implant with no serial and no lot is refused: a recall is traced by
	// one or the other.
	if _, err := h.theatre.RecordUsage(context.Background(),
		withFacility(h.nurseToken(), h.facility, &theatrev1.RecordUsageRequest{
			CaseId: affected.caseID, Kind: theatrev1.UsageKind_USAGE_KIND_IMPLANT,
			ItemCode: "TEN-001", Quantity: 1,
		})); err == nil {
		t.Fatal("an untraceable implant was accepted")
	}

	for _, item := range []struct {
		caseID string
		serial string
		lot    string
	}{
		{affected.caseID, "SN-1", "LOT-A"},
		{other.caseID, "SN-2", "LOT-B"},
	} {
		if _, err := h.theatre.RecordUsage(context.Background(),
			withFacility(h.nurseToken(), h.facility, &theatrev1.RecordUsageRequest{
				CaseId: item.caseID, Kind: theatrev1.UsageKind_USAGE_KIND_IMPLANT,
				ItemCode: "TEN-001", ItemName: "Tendon anchor",
				SerialNumber: item.serial, LotNumber: item.lot, Quantity: 1,
				Scanned: true, ScanData: "0100987...",
			})); err != nil {
			t.Fatalf("RecordUsage: %v", err)
		}
	}

	// Neither the nurse who scanned it nor the surgeon may run the recall.
	for _, token := range []string{h.nurseToken(), h.surgeonToken()} {
		if _, err := h.theatre.RecallImplant(context.Background(),
			withFacility(token, h.facility, &theatrev1.RecallImplantRequest{
				ItemCode: "TEN-001", LotNumber: "LOT-A",
			})); err == nil {
			t.Fatal("a recall was run without the traceability permission")
		}
	}

	recalled, err := h.theatre.RecallImplant(context.Background(),
		withFacility(h.himToken(), h.facility, &theatrev1.RecallImplantRequest{
			ItemCode: "TEN-001", LotNumber: "LOT-A",
		}))
	if err != nil {
		t.Fatalf("RecallImplant: %v", err)
	}
	if len(recalled.Msg.GetRecipients()) != 1 {
		t.Fatalf("%d recipients of the recalled lot, want 1",
			len(recalled.Msg.GetRecipients()))
	}
	if recalled.Msg.GetRecipients()[0].GetReference() != "SN-1" {
		t.Fatalf("reference = %q, want the serial that identifies the device",
			recalled.Msg.GetRecipients()[0].GetReference())
	}
	if recalled.Msg.GetRecipients()[0].GetPatientId() == "" {
		t.Fatal("the recall reached no patient, which is the only thing it is for")
	}
}

// SRS-OT-011 and SRS-OT-012. A specimen takes its patient and side from the
// case, so a right-sided case cannot produce a left-sided pot; and a tray
// opened without its sterilisation cycle is refused, because the cycle is the
// chain an infection investigation runs back along.
func TestSpecimensAndTraysCarryTheirChain(t *testing.T) {
	h := newOtHarness(t)
	c := h.scheduledCase(t)

	specimen, err := h.theatre.TakeSpecimen(context.Background(),
		withFacility(h.nurseToken(), h.facility, &theatrev1.TakeSpecimenRequest{
			CaseId: c.caseID, Label: "Pot 1", Container: "formalin pot",
			Fixative: "10% formalin",
		}))
	if err != nil {
		t.Fatalf("TakeSpecimen: %v", err)
	}
	if specimen.Msg.GetSpecimen().GetLaterality() !=
		theatrev1.Laterality_LATERALITY_RIGHT {
		t.Fatalf("laterality = %v; a right-sided case cannot produce a left-sided pot",
			specimen.Msg.GetSpecimen().GetLaterality())
	}
	if specimen.Msg.GetSpecimen().GetSite() != "right ring finger" {
		t.Fatalf("site = %q, want the case's", specimen.Msg.GetSpecimen().GetSite())
	}

	outstanding, err := h.theatre.ListOutstandingSpecimens(context.Background(),
		withFacility(h.nurseToken(), h.facility,
			&theatrev1.ListOutstandingSpecimensRequest{FacilityId: h.facility}))
	if err != nil {
		t.Fatalf("ListOutstandingSpecimens: %v", err)
	}
	if len(outstanding.Msg.GetSpecimens()) != 1 {
		t.Fatalf("%d outstanding specimens, want 1",
			len(outstanding.Msg.GetSpecimens()))
	}

	if _, err := h.theatre.AccessionSpecimen(context.Background(),
		withFacility(h.nurseToken(), h.facility,
			&theatrev1.AccessionSpecimenRequest{
				SpecimenId: specimen.Msg.GetSpecimen().GetSpecimenId(),
				OrderId:    uuid.NewString(),
			})); err != nil {
		t.Fatalf("AccessionSpecimen: %v", err)
	}
	if _, err := h.theatre.AccessionSpecimen(context.Background(),
		withFacility(h.nurseToken(), h.facility,
			&theatrev1.AccessionSpecimenRequest{
				SpecimenId: specimen.Msg.GetSpecimen().GetSpecimenId(),
				OrderId:    uuid.NewString(),
			})); err == nil {
		t.Fatal("a specimen was accessioned twice")
	}

	// A tray with no cycle recorded is refused.
	if _, err := h.theatre.OpenTray(context.Background(),
		withFacility(h.nurseToken(), h.facility, &theatrev1.OpenTrayRequest{
			CaseId: c.caseID, TrayId: "tray-9", TrayName: "Hand set",
			IndicatorPassed: true,
		})); err == nil {
		t.Fatal("a tray was opened with no sterilisation cycle")
	}

	if _, err := h.theatre.OpenTray(context.Background(),
		withFacility(h.nurseToken(), h.facility, &theatrev1.OpenTrayRequest{
			CaseId: c.caseID, TrayId: "tray-9", TrayName: "Hand set",
			CycleId: "cycle-44", IndicatorPassed: true,
		})); err != nil {
		t.Fatalf("OpenTray: %v", err)
	}

	traced, err := h.theatre.TraceCycle(context.Background(),
		withFacility(h.himToken(), h.facility, &theatrev1.TraceCycleRequest{
			CycleId: "cycle-44",
		}))
	if err != nil {
		t.Fatalf("TraceCycle: %v", err)
	}
	if len(traced.Msg.GetRecipients()) != 1 {
		t.Fatalf("%d patients reached by the cycle, want 1",
			len(traced.Msg.GetRecipients()))
	}
}

// SRS-OT-003. The reason is required in both directions, and the audit entry
// carries it — which is the requirement's own clause.
func TestReprioritisingNeedsAReason(t *testing.T) {
	h := newOtHarness(t)
	c := h.scheduledCase(t)

	if _, err := h.theatre.Reprioritise(context.Background(),
		withFacility(h.surgeonToken(), h.facility, &theatrev1.ReprioritiseRequest{
			CaseId: c.caseID, Urgency: theatrev1.Urgency_URGENCY_URGENT,
		})); err == nil {
		t.Fatal("an unexplained upgrade was accepted")
	}

	if _, err := h.theatre.Reprioritise(context.Background(),
		withFacility(h.surgeonToken(), h.facility, &theatrev1.ReprioritiseRequest{
			CaseId: c.caseID, Urgency: theatrev1.Urgency_URGENCY_URGENT,
			Reason: "symptoms progressing, function deteriorating",
		})); err != nil {
		t.Fatalf("Reprioritise: %v", err)
	}

	// A theatre nurse cannot change a case's priority.
	if _, err := h.theatre.Reprioritise(context.Background(),
		withFacility(h.nurseToken(), h.facility, &theatrev1.ReprioritiseRequest{
			CaseId: c.caseID, Urgency: theatrev1.Urgency_URGENCY_ELECTIVE,
			Reason: "no longer urgent",
		})); err == nil {
		t.Fatal("a theatre nurse changed a case's priority")
	}
}

// SRS-OT-016. A card seeds a case's requirements and never constrains what is
// actually used.
func TestAPreferenceCardSeedsTheRequest(t *testing.T) {
	h := newOtHarness(t)

	if _, err := h.theatre.SavePreferenceCard(context.Background(),
		withFacility(h.schedulerToken(), h.facility,
			&theatrev1.SavePreferenceCardRequest{
				SurgeonId: "surgeon-1", ProcedureCode: "M65.3",
				Name: "Trigger finger", Equipment: []string{"tourniquet", "loupes"},
				Consumables: []*theatrev1.CardItem{
					{ItemCode: "SUT-1", ItemName: "Suture", Quantity: 2},
				},
			})); err != nil {
		t.Fatalf("SavePreferenceCard: %v", err)
	}

	seeded := h.request(t, h.encounter(t, "Varma", "+91-99000-44010"),
		func(req *theatrev1.RequestSurgeryRequest) {
			req.SeedFromCard = true
			req.Requirements = []string{"tourniquet"}
		})
	requirements := seeded.GetSurgicalCase().GetRequirements()
	if len(requirements) != 2 {
		t.Fatalf("requirements = %v, want the card added without duplicating",
			requirements)
	}

	// And nothing stops an item that is not on the card being recorded.
	if _, err := h.theatre.RecordUsage(context.Background(),
		withFacility(h.nurseToken(), h.facility, &theatrev1.RecordUsageRequest{
			CaseId:   seeded.GetSurgicalCase().GetCaseId(),
			Kind:     theatrev1.UsageKind_USAGE_KIND_CONSUMABLE,
			ItemCode: "SUT-9", ItemName: "Suture not on the card", Quantity: 1,
		})); err != nil {
		t.Fatalf("RecordUsage: %v", err)
	}
}

// A closed theatre cannot be booked, and the refusal says why.
func TestAClosedTheatreCannotBeBooked(t *testing.T) {
	h := newOtHarness(t)
	room := h.room(t, "OT1", nil)
	c := h.request(t, h.encounter(t, "Bose", "+91-99000-44011"), nil)

	start := time.Now().UTC().Add(2 * time.Hour)

	if _, err := h.theatre.SaveBlock(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &theatrev1.SaveBlockRequest{
			RoomId: room, Kind: theatrev1.BlockKind_BLOCK_KIND_DOWNTIME,
			StartsAt: timestamppb.New(start.Add(-time.Hour)),
			EndsAt:   timestamppb.New(start.Add(8 * time.Hour)),
		})); err == nil {
		t.Fatal("a theatre was closed with no reason given")
	}

	if _, err := h.theatre.SaveBlock(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &theatrev1.SaveBlockRequest{
			RoomId: room, Kind: theatrev1.BlockKind_BLOCK_KIND_DOWNTIME,
			StartsAt: timestamppb.New(start.Add(-time.Hour)),
			EndsAt:   timestamppb.New(start.Add(8 * time.Hour)),
			Note:     "annual deep clean",
		})); err != nil {
		t.Fatalf("SaveBlock: %v", err)
	}

	conflicts, err := h.theatre.CheckSlot(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &theatrev1.CheckSlotRequest{
			CaseId: c.GetSurgicalCase().GetCaseId(), RoomId: room,
			Start: timestamppb.New(start),
			End:   timestamppb.New(start.Add(time.Hour)),
		}))
	if err != nil {
		t.Fatalf("CheckSlot: %v", err)
	}
	if len(conflicts.Msg.GetConflicts()) != 1 {
		t.Fatalf("conflicts = %v, want the closure", conflicts.Msg.GetConflicts())
	}
	if conflicts.Msg.GetConflicts()[0].GetOverridable() {
		t.Fatal("a closed theatre was overridable")
	}
	if !strings.Contains(conflicts.Msg.GetConflicts()[0].GetDetail(), "deep clean") {
		t.Fatalf("detail = %q, want it to say why the theatre is closed",
			conflicts.Msg.GetConflicts()[0].GetDetail())
	}
}

// scheduledCase is a request booked into a theatre, which is where most of
// these tests start.
type otCase struct {
	caseID string
	roomID string
}

func (h *otHarness) scheduledCase(t *testing.T) otCase {
	t.Helper()

	rooms, err := h.theatre.ListRooms(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &theatrev1.ListRoomsRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("ListRooms: %v", err)
	}
	roomID := ""
	if len(rooms.Msg.GetRooms()) > 0 {
		roomID = rooms.Msg.GetRooms()[0].GetRoomId()
	} else {
		roomID = h.room(t, "OT1", nil)
	}

	encounter := h.encounter(t, "Case"+uuid.NewString()[:8],
		"+91-99000-"+uuid.NewString()[:5])
	requested := h.request(t, encounter, nil)

	// Far enough apart that successive cases in one test do not clash.
	start := time.Now().UTC().Add(time.Duration(len(rooms.Msg.GetRooms())+1) *
		4 * time.Hour)
	booked, err := h.theatre.ScheduleCase(context.Background(),
		withFacility(h.schedulerToken(), h.facility, &theatrev1.ScheduleCaseRequest{
			CaseId: requested.GetSurgicalCase().GetCaseId(), RoomId: roomID,
			Start: timestamppb.New(start),
			End:   timestamppb.New(start.Add(time.Hour)),
		}))
	if err != nil {
		t.Fatalf("ScheduleCase: %v", err)
	}
	return otCase{caseID: booked.Msg.GetSurgicalCase().GetCaseId(), roomID: roomID}
}

// clearChecklist answers every mandatory pre-operative item.
func (h *otHarness) clearChecklist(t *testing.T, caseID string) {
	t.Helper()

	for _, code := range []string{
		"identity", "site_marked", "consent", "investigations",
		"blood", "implants", "fasting",
	} {
		if _, err := h.theatre.RecordPreop(context.Background(),
			withFacility(h.nurseToken(), h.facility, &theatrev1.RecordPreopRequest{
				CaseId: caseID, Code: code,
				State: theatrev1.PreopState_PREOP_STATE_MET,
			})); err != nil {
			t.Fatalf("RecordPreop(%s): %v", code, err)
		}
	}
}
