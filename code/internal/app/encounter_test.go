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

// Encounters and episodes of care (SRS-ENC-001 … SRS-ENC-012).
//
// The distinction this file exists to prove is SRS-ENC-003's: an appointment is
// a plan and an encounter is what happened. A patient can be seen without an
// appointment, and a consultation can run long past the slot it was booked
// into. A system that conflated them cannot answer "when was this patient
// actually seen", which is the question every audit turns on.

type encHarness struct {
	pool       *pgxpool.Pool
	encounters encounterv1connect.EncounterServiceClient
	patients   empiv1connect.PatientServiceClient
	org        organizationv1connect.OrganizationServiceClient
	tenantID   string
	facility   string
}

func newEncHarness(t *testing.T) *encHarness {
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

	h := &encHarness{
		pool:       pool,
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
			Type: organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL, TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateFacility: %v", err)
	}
	h.facility = facility.Msg.GetFacility().GetFacilityId()

	h.entitle(t, "empi")
	h.entitle(t, "encounter")
	return h
}

// entitle grants a module. Without it every call is refused at the wire with
// MODULE_NOT_ENTITLED, which is SRS-PLT-011 working rather than a harness
// inconvenience.
func (h *encHarness) entitle(t *testing.T, module string) {
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

// Tokens. The fourth segment is the facility claim.
func (h *encHarness) clerkToken() string {
	return h.tenantID + ":clerk-1:registration_clerk:" + h.facility
}

func (h *encHarness) clinicianToken() string {
	return h.tenantID + ":doctor-1:clinician:" + h.facility
}

func (h *encHarness) registerPatient(t *testing.T, family, phone string) string {
	t.Helper()

	registered, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterPatientRequest{
			Demographics: demographics(family, []string{"Meera"},
				date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, phone),
		}))
	if err != nil {
		t.Fatalf("RegisterPatient: %v", err)
	}
	return registered.Msg.GetPatient().GetPatientId()
}

// openEncounter opens and starts an outpatient encounter.
func (h *encHarness) openEncounter(t *testing.T, patient string,
	class encounterv1.EncounterClass) *encounterv1.Encounter {
	t.Helper()

	opened, err := h.encounters.OpenEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.OpenEncounterRequest{
			PatientId: patient, FacilityId: h.facility, Class: class,
			AttendingProviderId: "doctor-1", Reason: "chest pain",
			StartImmediately: true,
		}))
	if err != nil {
		t.Fatalf("OpenEncounter: %v", err)
	}
	return opened.Msg.GetEncounter()
}

// SRS-ENC-001: "encounter_id unique and state begins valid for context".
func TestOpeningAnEncounterStartsItInAValidState(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")

	encounter := h.openEncounter(t, patient,
		encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT)

	if encounter.GetEncounterId() == "" {
		t.Fatal("the encounter has no identifier")
	}
	if encounter.GetStatus() !=
		encounterv1.EncounterStatus_ENCOUNTER_STATUS_IN_PROGRESS {
		t.Fatalf("status = %v, want in_progress", encounter.GetStatus())
	}
	if encounter.GetStartedAt() == nil {
		t.Fatal("a started encounter has no clinical start time")
	}
	if encounter.GetPatientId() != patient {
		t.Fatal("the encounter is filed against the wrong patient")
	}
}

// SRS-ENC-003: "appointment and encounter remain separately auditable".
//
// A walk-in has no appointment at all, and that is not an error.
func TestAnEncounterNeedsNoAppointment(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")

	encounter := h.openEncounter(t, patient,
		encounterv1.EncounterClass_ENCOUNTER_CLASS_EMERGENCY)

	if encounter.GetAppointmentId() != "" {
		t.Fatal("an emergency walk-in was given an appointment it never had")
	}
	if encounter.GetStartedAt() == nil {
		t.Fatal("an encounter with no appointment has no start time of its own")
	}
}

// The encounter's clinical times are its own, not the appointment's.
func TestAnEncounterRecordsWhenThePatientWasActuallySeen(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")

	// Booked for 09:00; actually seen at 10:30, an hour and a half late.
	seen := time.Now().UTC().Add(-90 * time.Minute).Truncate(time.Second)

	opened, err := h.encounters.OpenEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.OpenEncounterRequest{
			PatientId: patient, FacilityId: h.facility,
			Class:               encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT,
			AttendingProviderId: "doctor-1", Reason: "review",
			StartImmediately: true, StartedAt: timestamppb.New(seen),
		}))
	if err != nil {
		t.Fatalf("OpenEncounter: %v", err)
	}

	got := opened.Msg.GetEncounter().GetStartedAt().AsTime()
	if !got.Equal(seen) {
		t.Fatalf("started at %v, want the time the patient was actually seen (%v)",
			got, seen)
	}
}

// SRS-ENC-002: the class-specific rule that a consultation names somebody
// answerable, and a diagnostic-only visit does not.
func TestAConsultationNamesItsClinicianAndAnXRayDoesNot(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")

	_, err := h.encounters.OpenEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.OpenEncounterRequest{
			PatientId: patient, FacilityId: h.facility,
			Class:  encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT,
			Reason: "review",
		}))
	if err == nil {
		t.Fatal("a consultation was opened with nobody answerable for it")
	}

	if _, err := h.encounters.OpenEncounter(context.Background(),
		withFacility(h.clerkToken(), h.facility, &encounterv1.OpenEncounterRequest{
			PatientId: patient, FacilityId: h.facility,
			Class:  encounterv1.EncounterClass_ENCOUNTER_CLASS_DIAGNOSTIC_ONLY,
			Reason: "chest x-ray",
		})); err != nil {
		t.Fatalf("a diagnostic-only visit was refused for having no clinician: %v", err)
	}
}

// SRS-ENC-005: "authorization can evaluate active care-team relationship".
//
// The attending clinician joins their own care team on the way in; without it
// authorization would answer "no" for the person responsible for the patient.
func TestTheAttendingClinicianIsOnTheCareTeamFromTheStart(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")
	encounter := h.openEncounter(t, patient,
		encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT)

	team, err := h.encounters.GetCareTeam(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.GetCareTeamRequest{
			EncounterId: encounter.GetEncounterId(),
		}))
	if err != nil {
		t.Fatalf("GetCareTeam: %v", err)
	}

	members := team.Msg.GetMembers()
	if len(members) != 1 {
		t.Fatalf("%d care-team members, want the attending clinician", len(members))
	}
	if members[0].GetSubjectId() != "doctor-1" ||
		members[0].GetRole() != encounterv1.CareTeamRole_CARE_TEAM_ROLE_ATTENDING {
		t.Fatalf("care team = %+v, want doctor-1 as attending", members[0])
	}
	if members[0].GetEffectiveFrom() == nil {
		t.Fatal("the assignment has no effective date, so it cannot answer a " +
			"question about the past")
	}
}

// A care-team assignment is closed rather than deleted: whether this clinician
// was looking after the patient last Tuesday is a question an investigation
// asks.
func TestEndingACareTeamAssignmentKeepsIt(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")
	encounter := h.openEncounter(t, patient,
		encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT)

	assigned, err := h.encounters.AssignCareTeamMember(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&encounterv1.AssignCareTeamMemberRequest{
				EncounterId: encounter.GetEncounterId(), SubjectId: "nurse-1",
				Role: encounterv1.CareTeamRole_CARE_TEAM_ROLE_NURSE,
			}))
	if err != nil {
		t.Fatalf("AssignCareTeamMember: %v", err)
	}

	if _, err := h.encounters.EndCareTeamAssignment(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&encounterv1.EndCareTeamAssignmentRequest{
				CareTeamId:     assigned.Msg.GetMember().GetCareTeamId(),
				EffectiveUntil: timestamppb.New(time.Now().UTC().Add(time.Hour)),
			})); err != nil {
		t.Fatalf("EndCareTeamAssignment: %v", err)
	}

	team, err := h.encounters.GetCareTeam(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.GetCareTeamRequest{
			EncounterId: encounter.GetEncounterId(),
		}))
	if err != nil {
		t.Fatalf("GetCareTeam: %v", err)
	}
	if len(team.Msg.GetMembers()) != 2 {
		t.Fatalf("%d members after ending one, want both kept",
			len(team.Msg.GetMembers()))
	}
	for _, m := range team.Msg.GetMembers() {
		if m.GetSubjectId() == "nurse-1" && m.GetEffectiveUntil() == nil {
			t.Fatal("the ended assignment has no end date")
		}
	}
}

// SRS-ENC-004: "multiple encounters can reference one episode without copying
// data".
func TestEncountersShareAnEpisodeWithoutCopyingIt(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")

	episode, err := h.encounters.OpenEpisode(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.OpenEpisodeRequest{
			PatientId: patient, FacilityId: h.facility,
			Type:  encounterv1.EpisodeType_EPISODE_TYPE_PREGNANCY,
			Label: "second pregnancy", CareManagerId: "doctor-1",
		}))
	if err != nil {
		t.Fatalf("OpenEpisode: %v", err)
	}
	episodeID := episode.Msg.GetEpisode().GetEpisodeId()

	for i := 0; i < 3; i++ {
		if _, err := h.encounters.OpenEncounter(context.Background(),
			withFacility(h.clinicianToken(), h.facility,
				&encounterv1.OpenEncounterRequest{
					PatientId: patient, FacilityId: h.facility,
					Class:               encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT,
					AttendingProviderId: "doctor-1", EpisodeId: episodeID,
					Reason: "antenatal review", StartImmediately: true,
				})); err != nil {
			t.Fatalf("OpenEncounter %d: %v", i, err)
		}
	}

	listed, err := h.encounters.ListEncounters(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.ListEncountersRequest{
			PatientId: patient, EpisodeId: episodeID,
		}))
	if err != nil {
		t.Fatalf("ListEncounters: %v", err)
	}
	if len(listed.Msg.GetEncounters()) != 3 {
		t.Fatalf("%d encounters in the episode, want 3",
			len(listed.Msg.GetEncounters()))
	}
}

// A pregnancy that resumes is a different pregnancy.
func TestAFinishedEpisodeTakesNoMoreEncounters(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")

	episode, err := h.encounters.OpenEpisode(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.OpenEpisodeRequest{
			PatientId: patient, FacilityId: h.facility,
			Type: encounterv1.EpisodeType_EPISODE_TYPE_PREGNANCY, Label: "first pregnancy",
		}))
	if err != nil {
		t.Fatalf("OpenEpisode: %v", err)
	}
	episodeID := episode.Msg.GetEpisode().GetEpisodeId()

	if _, err := h.encounters.SetEpisodeStatus(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.SetEpisodeStatusRequest{
			EpisodeId: episodeID,
			Status:    encounterv1.EpisodeStatus_EPISODE_STATUS_FINISHED,
		})); err != nil {
		t.Fatalf("SetEpisodeStatus: %v", err)
	}

	_, err = h.encounters.OpenEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.OpenEncounterRequest{
			PatientId: patient, FacilityId: h.facility,
			Class:               encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT,
			AttendingProviderId: "doctor-1", EpisodeId: episodeID, Reason: "review",
		}))
	if err == nil {
		t.Fatal("an encounter was filed into a finished course of care")
	}
	if !strings.Contains(err.Error(), "no longer open") {
		t.Fatalf("the refusal does not say why: %v", err)
	}
}

// Confirming somebody else's episode exists would leak that a patient is under
// a course of oncology care.
func TestAnEpisodeCannotBeUsedForAnotherPatient(t *testing.T) {
	h := newEncHarness(t)
	hers := h.registerPatient(t, "Iyer", "9876543210")
	his := h.registerPatient(t, "Nair", "9876543211")

	episode, err := h.encounters.OpenEpisode(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.OpenEpisodeRequest{
			PatientId: hers, FacilityId: h.facility,
			Type: encounterv1.EpisodeType_EPISODE_TYPE_ONCOLOGY, Label: "left breast",
		}))
	if err != nil {
		t.Fatalf("OpenEpisode: %v", err)
	}

	_, err = h.encounters.OpenEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.OpenEncounterRequest{
			PatientId: his, FacilityId: h.facility,
			Class:               encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT,
			AttendingProviderId: "doctor-1", Reason: "review",
			EpisodeId: episode.Msg.GetEpisode().GetEpisodeId(),
		}))
	if err == nil {
		t.Fatal("one patient's encounter was filed into another patient's episode")
	}
	if strings.Contains(strings.ToLower(err.Error()), "oncology") ||
		strings.Contains(strings.ToLower(err.Error()), "breast") {
		t.Fatalf("the refusal leaks what the other patient's episode is: %v", err)
	}
}

// SRS-ENC-006: "invalid state change rejected".
func TestAnEncounterRefusesAnImpossibleStateChange(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")
	encounter := h.openEncounter(t, patient,
		encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT)

	// In progress straight to closed skips the end of the consultation.
	_, err := h.encounters.CloseEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.CloseEncounterRequest{
			EncounterId: encounter.GetEncounterId(),
		}))
	if err == nil {
		t.Fatal("an encounter was closed before it ended")
	}
}

// SRS-ENC-006: cancelled and entered-in-error are different facts.
//
// Counting them together would tell a quality team that patients are
// cancelling when in fact clerks are misclicking.
func TestCancelledAndEnteredInErrorStayDistinct(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")

	cancelled := h.openEncounter(t, patient,
		encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT)
	if _, err := h.encounters.CancelEncounter(context.Background(),
		withFacility(h.clerkToken(), h.facility, &encounterv1.CancelEncounterRequest{
			EncounterId: cancelled.GetEncounterId(), Reason: "patient left",
		})); err != nil {
		t.Fatalf("CancelEncounter: %v", err)
	}

	wrong := h.openEncounter(t, patient,
		encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT)
	retracted, err := h.encounters.CancelEncounter(context.Background(),
		withFacility(h.clerkToken(), h.facility, &encounterv1.CancelEncounterRequest{
			EncounterId: wrong.GetEncounterId(),
			Reason:      "opened against the wrong patient", EnteredInError: true,
		}))
	if err != nil {
		t.Fatalf("CancelEncounter (entered in error): %v", err)
	}
	if retracted.Msg.GetEncounter().GetStatus() !=
		encounterv1.EncounterStatus_ENCOUNTER_STATUS_ENTERED_IN_ERROR {
		t.Fatalf("status = %v, want entered_in_error",
			retracted.Msg.GetEncounter().GetStatus())
	}

	// A record that was never true does not appear in a clinical chronology.
	listed, err := h.encounters.ListEncounters(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.ListEncountersRequest{
			PatientId: patient,
		}))
	if err != nil {
		t.Fatalf("ListEncounters: %v", err)
	}
	for _, e := range listed.Msg.GetEncounters() {
		if e.GetEncounterId() == wrong.GetEncounterId() {
			t.Fatal("an entered-in-error encounter appears in the patient's chronology")
		}
		if e.GetEncounterId() == cancelled.GetEncounterId() {
			// A cancelled visit is a real fact about the patient and stays.
			return
		}
	}
	t.Fatal("the cancelled encounter was dropped along with the retracted one")
}

// Both need a reason: they are the states somebody asks about later.
func TestCancellingNeedsAReason(t *testing.T) {
	h := newEncHarness(t)
	patient := h.registerPatient(t, "Iyer", "9876543210")
	encounter := h.openEncounter(t, patient,
		encounterv1.EncounterClass_ENCOUNTER_CLASS_OUTPATIENT)

	if _, err := h.encounters.CancelEncounter(context.Background(),
		withFacility(h.clerkToken(), h.facility, &encounterv1.CancelEncounterRequest{
			EncounterId: encounter.GetEncounterId(),
		})); err == nil {
		t.Fatal("an encounter was cancelled with no reason")
	}
}
