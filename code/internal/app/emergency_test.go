package app_test

import (
	"context"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	emergencyv1 "github.com/ppusapati/health/code/gen/go/healthcare/emergency/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/emergency/v1/emergencyv1connect"
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
	"github.com/ppusapati/health/code/internal/platform/escalation"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
	platformapitransport "github.com/ppusapati/health/code/internal/platform_api/transport"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// The Emergency Department, end to end.
//
// Domain tests already hold the rules. These hold what only the assembled
// stack can show: that a trauma call reaches the platform escalation
// mechanism inside the same transaction as the activation, that a drug given
// ahead of its order becomes a debt the department can see from the floor
// rather than from one chart, that the queue puts the sicker patient first
// across two clients, and that a medico-legal case is redacted for the caller
// who lacks the permission and whole for the one who has it.

// pathwayKind is the escalation matrix an activation escalates along. Named
// here as a client would name it, rather than imported from the adapter: a
// test that took the constant from the code under test would pass if the code
// renamed it.
const pathwayKind = "pathway_activation"

type erHarness struct {
	pool        *pgxpool.Pool
	emergency   emergencyv1connect.EmergencyServiceClient
	encounters  encounterv1connect.EncounterServiceClient
	patients    empiv1connect.PatientServiceClient
	org         organizationv1connect.OrganizationServiceClient
	escalations *escalation.Store
	tenantID    string
	facility    string
}

func newERHarness(t *testing.T) *erHarness {
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

	h := &erHarness{
		pool:       pool,
		emergency:  emergencyv1connect.NewEmergencyServiceClient(server.Client(), server.URL),
		encounters: encounterv1connect.NewEncounterServiceClient(server.Client(), server.URL),
		patients:   empiv1connect.NewPatientServiceClient(server.Client(), server.URL),
		org:        organizationv1connect.NewOrganizationServiceClient(server.Client(), server.URL),
		// The very store the emergency service writes through, not a lookalike
		// built the same way: a test against a second store would prove the
		// second store.
		escalations: built.EscalationStore,
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

	for _, module := range []string{"empi", "encounter", "emergency"} {
		h.entitle(t, module)
	}
	return h
}

func (h *erHarness) entitle(t *testing.T, module string) {
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

func (h *erHarness) clinicianToken() string {
	return h.tenantID + ":doctor-1:clinician:" + h.facility
}

func (h *erHarness) nurseToken() string {
	return h.tenantID + ":nurse-1:nurse:" + h.facility
}

func (h *erHarness) clerkToken() string {
	return h.tenantID + ":clerk-1:registration_clerk:" + h.facility
}

// chargeNurseToken holds the override and nothing else the floor needs.
func (h *erHarness) chargeNurseToken() string {
	return h.tenantID + ":charge-1:nurse_manager:" + h.facility
}

func (h *erHarness) scope() authctx.TenantScope {
	// The grant the background runners use, for the reason authctx.SystemScope
	// gives: a test has no session either.
	return authctx.SystemScope(h.tenantID)
}

// saveActivationChain configures who a trauma call reaches.
func (h *erHarness) saveActivationChain(t *testing.T) {
	t.Helper()

	tx := pgtx.NewManager(h.pool)
	matrix := escalation.Matrix{
		FacilityID: h.facility, Kind: pathwayKind,
		Rungs: []escalation.Rung{
			{Level: 0, Recipients: []escalation.Recipient{{Role: "trauma_team", FacilityID: h.facility}},
				Note: "the team on the bleep"},
			{Level: 1, Recipients: []escalation.Recipient{{UserID: "consultant-1"}},
				Note: "the consultant on call"},
		},
	}
	if err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
		return h.escalations.SaveMatrix(ctx, h.scope(), matrix, time.Now())
	}); err != nil {
		t.Fatalf("save activation matrix: %v", err)
	}
}

// encounter registers a patient and opens the Wave-1 encounter an emergency
// visit is the detail of.
func (h *erHarness) encounter(t *testing.T, family, phone string) (string, string) {
	t.Helper()

	registered, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterPatientRequest{
			Demographics: demographics(family, []string{"Arun"},
				date(1971, 6, 4), empiv1.Sex_SEX_MALE, phone),
		}))
	if err != nil {
		t.Fatalf("RegisterPatient: %v", err)
	}
	patient := registered.Msg.GetPatient().GetPatientId()

	opened, err := h.encounters.OpenEncounter(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &encounterv1.OpenEncounterRequest{
			PatientId: patient, FacilityId: h.facility,
			Class:               encounterv1.EncounterClass_ENCOUNTER_CLASS_EMERGENCY,
			AttendingProviderId: "doctor-1", Reason: "chest pain",
			StartImmediately: true,
		}))
	if err != nil {
		t.Fatalf("OpenEncounter: %v", err)
	}
	return patient, opened.Msg.GetEncounter().GetEncounterId()
}

// arrive books a patient into the department.
func (h *erHarness) arrive(t *testing.T, req *emergencyv1.ArriveRequest) *emergencyv1.EmergencyVisit {
	t.Helper()

	if req.GetFacilityId() == "" {
		req.FacilityId = h.facility
	}
	if req.GetArrivedAt() == nil {
		req.ArrivedAt = timestamppb.New(time.Now().UTC())
	}
	arrived, err := h.emergency.Arrive(context.Background(),
		withFacility(h.clerkToken(), h.facility, req))
	if err != nil {
		t.Fatalf("Arrive: %v", err)
	}
	return arrived.Msg.GetVisit()
}

func (h *erHarness) triage(t *testing.T, visitID, code string) *emergencyv1.Triage {
	t.Helper()

	assigned, err := h.emergency.AssignTriage(context.Background(),
		withFacility(h.nurseToken(), h.facility, &emergencyv1.AssignTriageRequest{
			VisitId: visitID, AcuityCode: code,
			Consciousness: "alert",
		}))
	if err != nil {
		t.Fatalf("AssignTriage(%s): %v", code, err)
	}
	return assigned.Msg.GetTriage()
}

// A patient arrives, is triaged, is seen, and goes somewhere (SRS-ER-001,
// SRS-ER-002). The clocks in SRS-ER-006 are derived from the events rather
// than stored, so this is the test that says the derivation reaches a client.
func TestAnEmergencyVisitRunsFromDoorToDisposition(t *testing.T) {
	h := newERHarness(t)
	_, encounter := h.encounter(t, "Nair", "+91-99000-22001")

	arrivedAt := time.Now().UTC().Add(-40 * time.Minute)
	visit := h.arrive(t, &emergencyv1.ArriveRequest{
		EncounterId: encounter, ArrivalMode: emergencyv1.ArrivalMode_ARRIVAL_MODE_AMBULANCE,
		ChiefComplaint: "central chest pain", ArrivedAt: timestamppb.New(arrivedAt),
		Location: "Majors 3",
	})
	if visit.GetStatus() != emergencyv1.VisitStatus_VISIT_STATUS_ARRIVED {
		t.Fatalf("status on arrival = %v", visit.GetStatus())
	}

	h.triage(t, visit.GetVisitId(), "2")

	if _, err := h.emergency.RecordEmergencyEvent(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &emergencyv1.RecordEmergencyEventRequest{
			VisitId: visit.GetVisitId(),
			Kind:    emergencyv1.EventKind_EVENT_KIND_CLINICIAN_SEEN,
			Detail:  "doctor-1", OccurredAt: timestamppb.New(time.Now().UTC()),
		})); err != nil {
		t.Fatalf("RecordEmergencyEvent(clinician seen): %v", err)
	}

	disposed, err := h.emergency.Dispose(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &emergencyv1.DisposeRequest{
			VisitId:     visit.GetVisitId(),
			Disposition: emergencyv1.Disposition_DISPOSITION_ADMISSION,
			Note:        "for coronary care", ReceivingService: "cardiology",
		}))
	if err != nil {
		t.Fatalf("Dispose: %v", err)
	}
	if disposed.Msg.GetVisit().GetStatus() != emergencyv1.VisitStatus_VISIT_STATUS_DISPOSED {
		t.Fatalf("status after disposition = %v", disposed.Msg.GetVisit().GetStatus())
	}

	timeline, err := h.emergency.GetTimeline(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &emergencyv1.GetTimelineRequest{
			VisitId: visit.GetVisitId(),
		}))
	if err != nil {
		t.Fatalf("GetTimeline: %v", err)
	}

	intervals := timeline.Msg.GetIntervals()
	if intervals.DoorToTriageSeconds == nil {
		t.Fatal("no door-to-triage interval after a triage was recorded")
	}
	if intervals.DoorToClinicianSeconds == nil {
		t.Fatal("no door-to-clinician interval after a clinician took the patient")
	}
	if intervals.DoorToDispositionSeconds == nil {
		t.Fatal("no door-to-disposition interval after a disposition")
	}
	// Forty minutes of waiting, not zero: the clock runs from the recorded
	// arrival rather than from when somebody got round to typing.
	if got := intervals.GetDoorToTriageSeconds(); got < int64(35*time.Minute/time.Second) {
		t.Fatalf("door-to-triage = %ds, want at least 2100s from a 40-minute-old arrival", got)
	}
}

// SRS-ER-013: every reason at once. A clinician told one missing thing at a
// time makes three attempts at the same screen while a patient waits in a
// corridor.
func TestADispositionReportsEveryRefusalAtOnce(t *testing.T) {
	h := newERHarness(t)
	_, encounter := h.encounter(t, "Iyer", "+91-99000-22002")

	visit := h.arrive(t, &emergencyv1.ArriveRequest{
		EncounterId: encounter, ArrivalMode: emergencyv1.ArrivalMode_ARRIVAL_MODE_WALK_IN,
		ChiefComplaint: "ankle injury",
	})

	// Untriaged, unsigned summary, and no accepting service: three separate
	// gates, one attempt.
	_, err := h.emergency.Dispose(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &emergencyv1.DisposeRequest{
			VisitId:     visit.GetVisitId(),
			Disposition: emergencyv1.Disposition_DISPOSITION_REFERRAL,
		}))
	if err == nil {
		t.Fatal("referral accepted with no triage, no summary and no receiving service")
	}

	message := err.Error()
	for _, want := range []string{"no triage record", "not signed", "accepting the patient"} {
		if !strings.Contains(message, want) {
			t.Fatalf("refusal %q does not mention %q; a caller told one gate at a time "+
				"retries once per gate", message, want)
		}
	}
}

// SRS-ER-005: the activation and the call are one transaction. A pathway
// recorded without the team being called is the failure the requirement's
// notification clause exists for, and it is the common one — the activation is
// what the person at the keyboard can see and the call is not.
func TestActivatingAPathwayRaisesADurableNotice(t *testing.T) {
	h := newERHarness(t)
	h.saveActivationChain(t)
	_, encounter := h.encounter(t, "Bose", "+91-99000-22003")

	visit := h.arrive(t, &emergencyv1.ArriveRequest{
		EncounterId: encounter, ArrivalMode: emergencyv1.ArrivalMode_ARRIVAL_MODE_AMBULANCE,
		ChiefComplaint: "RTC, hypotensive", Location: "Resus 1",
	})

	activated, err := h.emergency.ActivatePathway(context.Background(),
		withFacility(h.nurseToken(), h.facility, &emergencyv1.ActivatePathwayRequest{
			VisitId: visit.GetVisitId(),
			Kind:    emergencyv1.PathwayKind_PATHWAY_KIND_TRAUMA,
			Label:   "Trauma team", NotifiedTeam: "trauma_team",
		}))
	if err != nil {
		t.Fatalf("ActivatePathway: %v", err)
	}
	pathway := activated.Msg.GetPathway()

	tx := pgtx.NewManager(h.pool)
	var notice escalation.Notice
	if err := tx.WithinTx(context.Background(), func(ctx context.Context) error {
		var err error
		notice, err = h.escalations.NoticeFor(ctx, h.scope(), escalation.Subject{
			Kind: pathwayKind, ID: pathway.GetPathwayId(),
		})
		return err
	}); err != nil {
		t.Fatalf("no escalation notice for pathway %s: %v", pathway.GetPathwayId(), err)
	}

	if notice.State != escalation.StatePending {
		t.Fatalf("notice state %q, want pending", notice.State)
	}
	if notice.Subject.FacilityID != h.facility {
		t.Fatalf("notice facility %q, want %q", notice.Subject.FacilityID, h.facility)
	}
	// The pathway and where to go, and nothing about the patient. SRS-API-009
	// applied to a platform table: the escalation inbox is read by a mechanism
	// that knows nothing about clinical confidentiality.
	if !strings.Contains(notice.Summary, "Resus 1") {
		t.Fatalf("notice summary %q does not say where to go", notice.Summary)
	}
	if strings.Contains(strings.ToLower(notice.Summary), "hypotensive") {
		t.Fatalf("notice summary %q carries the chief complaint outside the chart",
			notice.Summary)
	}
}

// A department that has configured no chain still gets the activation and the
// notice. Raising and delivering are separate: refusing the activation because
// nobody had filled in a form would be refusing to record a trauma call, and
// dropping the notice would lose it for the department that configures its
// matrix that afternoon.
func TestAnActivationWithNoChainStillStands(t *testing.T) {
	h := newERHarness(t)
	_, encounter := h.encounter(t, "Rao", "+91-99000-22004")

	visit := h.arrive(t, &emergencyv1.ArriveRequest{
		EncounterId: encounter, ArrivalMode: emergencyv1.ArrivalMode_ARRIVAL_MODE_AMBULANCE,
		ChiefComplaint: "cardiac arrest", Location: "Resus 2",
	})

	activated, err := h.emergency.ActivatePathway(context.Background(),
		withFacility(h.nurseToken(), h.facility, &emergencyv1.ActivatePathwayRequest{
			VisitId: visit.GetVisitId(),
			Kind:    emergencyv1.PathwayKind_PATHWAY_KIND_RESUSCITATION,
		}))
	if err != nil {
		t.Fatalf("activation refused because no escalation chain was configured: %v", err)
	}
	if activated.Msg.GetPathway().GetEscalationNoticeId() == "" {
		t.Fatal("no notice was raised, so a configured chain would find nothing to deliver")
	}
}

// SRS-ER-009: a drug given under a standing order before the order existed is
// a debt, and the criterion is "no silent stock/clinical gap". A debt visible
// only to somebody who opens that one chart is close enough to silent, so the
// department sees it facility-wide.
func TestAPreOrderAdministrationBecomesVisibleDebt(t *testing.T) {
	h := newERHarness(t)
	_, encounter := h.encounter(t, "Menon", "+91-99000-22005")

	visit := h.arrive(t, &emergencyv1.ArriveRequest{
		EncounterId: encounter, ArrivalMode: emergencyv1.ArrivalMode_ARRIVAL_MODE_AMBULANCE,
		ChiefComplaint: "anaphylaxis", Location: "Resus 1",
	})

	given, err := h.emergency.RecordEmergencyEvent(context.Background(),
		withFacility(h.nurseToken(), h.facility, &emergencyv1.RecordEmergencyEventRequest{
			VisitId: visit.GetVisitId(), Kind: emergencyv1.EventKind_EVENT_KIND_DRUG,
			Detail: "adrenaline 500 micrograms IM", OccurredAt: timestamppb.New(time.Now().UTC()),
			ProtocolId: "anaphylaxis-v3", PreOrder: true,
		}))
	if err != nil {
		t.Fatalf("RecordEmergencyEvent(pre-order drug): %v", err)
	}
	event := given.Msg.GetEvent()

	outstanding, err := h.emergency.ListUnreconciled(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &emergencyv1.ListUnreconciledRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("ListUnreconciled: %v", err)
	}
	if !containsEvent(outstanding.Msg.GetEvents(), event.GetEventId()) {
		t.Fatal("a drug given ahead of its order is not on the department's debt list")
	}

	if _, err := h.emergency.ReconcileAdministration(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&emergencyv1.ReconcileAdministrationRequest{
				EventId: event.GetEventId(), OrderId: uuid.NewString(),
			})); err != nil {
		t.Fatalf("ReconcileAdministration: %v", err)
	}

	after, err := h.emergency.ListUnreconciled(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &emergencyv1.ListUnreconciledRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("ListUnreconciled after reconciling: %v", err)
	}
	if containsEvent(after.Msg.GetEvents(), event.GetEventId()) {
		t.Fatal("the debt survived the order being written")
	}

	// Reconciling twice is a refusal rather than a silent success: a caller
	// told "done" for an order that was not recorded would never write the
	// real one.
	if _, err := h.emergency.ReconcileAdministration(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&emergencyv1.ReconcileAdministrationRequest{
				EventId: event.GetEventId(), OrderId: uuid.NewString(),
			})); err == nil {
		t.Fatal("reconciling an already-settled administration reported success")
	}
}

func containsEvent(events []*emergencyv1.EmergencyEvent, id string) bool {
	for _, event := range events {
		if event.GetEventId() == id {
			return true
		}
	}
	return false
}

// SRS-ER-003: the board is ordered by acuity, an override moves a patient, and
// the reason is required in both directions.
func TestTheBoardPutsTheSickerPatientFirst(t *testing.T) {
	h := newERHarness(t)

	_, minorEncounter := h.encounter(t, "Pillai", "+91-99000-22006")
	minor := h.arrive(t, &emergencyv1.ArriveRequest{
		EncounterId: minorEncounter, ChiefComplaint: "sprained wrist",
		ArrivedAt: timestamppb.New(time.Now().UTC().Add(-90 * time.Minute)),
	})
	h.triage(t, minor.GetVisitId(), "4")

	_, sickEncounter := h.encounter(t, "Varma", "+91-99000-22007")
	sick := h.arrive(t, &emergencyv1.ArriveRequest{
		EncounterId: sickEncounter, ChiefComplaint: "breathless",
		ArrivedAt: timestamppb.New(time.Now().UTC().Add(-5 * time.Minute)),
	})
	h.triage(t, sick.GetVisitId(), "2")

	board, err := h.emergency.GetBoard(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &emergencyv1.GetBoardRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("GetBoard: %v", err)
	}
	rows := board.Msg.GetRows()
	if len(rows) != 2 {
		t.Fatalf("board has %d rows, want 2", len(rows))
	}
	// The patient who arrived 85 minutes later is first, because they are
	// sicker. A board that sorted on arrival would be a waiting list.
	if rows[0].GetVisitId() != sick.GetVisitId() {
		t.Fatalf("board head is %q, want the ESI 2", rows[0].GetVisitId())
	}

	// An override needs a reason in both directions. Moving somebody down is
	// the decision argued about afterwards.
	if _, err := h.emergency.OverridePriority(context.Background(),
		withFacility(h.chargeNurseToken(), h.facility,
			&emergencyv1.OverridePriorityRequest{
				VisitId: minor.GetVisitId(), AcuityRank: 1,
			})); err == nil {
		t.Fatal("an unexplained override was accepted")
	}

	if _, err := h.emergency.OverridePriority(context.Background(),
		withFacility(h.chargeNurseToken(), h.facility,
			&emergencyv1.OverridePriorityRequest{
				VisitId: minor.GetVisitId(), AcuityRank: 1,
				Reason: "open fracture, obvious deformity, missed at triage",
			})); err != nil {
		t.Fatalf("OverridePriority: %v", err)
	}

	after, err := h.emergency.GetBoard(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &emergencyv1.GetBoardRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("GetBoard after override: %v", err)
	}
	if after.Msg.GetRows()[0].GetVisitId() != minor.GetVisitId() {
		t.Fatal("the override did not move the patient")
	}
}

// SRS-ER-011 and SRS-ER-012: the board keeps the bed, the acuity and the
// clock, and loses the identity, for a viewer without the restricted read. The
// department is not shorter than it is — the count says how many rows are
// redacted.
func TestAMedicoLegalCaseIsRedactedOnTheBoard(t *testing.T) {
	h := newERHarness(t)
	_, encounter := h.encounter(t, "Krishnan", "+91-99000-22008")

	visit := h.arrive(t, &emergencyv1.ArriveRequest{
		EncounterId: encounter, ChiefComplaint: "assault",
		MedicoLegal: true, MedicoLegalRef: "FIR/2026/4417", Location: "Majors 1",
	})
	h.triage(t, visit.GetVisitId(), "3")

	// The nurse holds er.visit.read and not er.visit.read_restricted.
	restricted, err := h.emergency.GetBoard(context.Background(),
		withFacility(h.nurseToken(), h.facility, &emergencyv1.GetBoardRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("GetBoard as nurse: %v", err)
	}
	rows := restricted.Msg.GetRows()
	if len(rows) != 1 {
		t.Fatalf("board has %d rows, want 1", len(rows))
	}
	if !rows[0].GetRestricted() {
		t.Fatal("a medico-legal row was not marked restricted for a viewer without the permission")
	}
	if restricted.Msg.GetRestricted() != 1 {
		t.Fatalf("restricted count = %d, want 1: the board must not be silently shorter",
			restricted.Msg.GetRestricted())
	}
	// The bed and the acuity stay — a nurse who cannot see the police
	// reference still has to know somebody is in Majors 1.
	if rows[0].GetLocation() != "Majors 1" {
		t.Fatalf("location = %q, want the bed to survive redaction", rows[0].GetLocation())
	}
	if rows[0].GetAcuityRank() != 3 {
		t.Fatalf("acuity rank = %d, want 3 to survive redaction", rows[0].GetAcuityRank())
	}
	if strings.Contains(rows[0].GetDisplay(), "patient ") {
		t.Fatalf("display %q identifies a restricted patient", rows[0].GetDisplay())
	}

	// And the visit's own record is withheld from the same caller.
	record, err := h.emergency.GetEmergencyVisit(context.Background(),
		withFacility(h.nurseToken(), h.facility, &emergencyv1.GetEmergencyVisitRequest{
			VisitId: visit.GetVisitId(),
		}))
	if err != nil {
		t.Fatalf("GetEmergencyVisit as nurse: %v", err)
	}
	if record.Msg.GetVisit().GetMedicoLegalRef() != "" {
		t.Fatal("the police reference reached a caller without the restricted read")
	}

	// The clinician holds it, and sees the whole thing.
	whole, err := h.emergency.GetEmergencyVisit(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &emergencyv1.GetEmergencyVisitRequest{
			VisitId: visit.GetVisitId(),
		}))
	if err != nil {
		t.Fatalf("GetEmergencyVisit as clinician: %v", err)
	}
	if whole.Msg.GetVisit().GetMedicoLegalRef() != "FIR/2026/4417" {
		t.Fatalf("medico-legal ref = %q for a caller who holds the permission",
			whole.Msg.GetVisit().GetMedicoLegalRef())
	}
}

// SRS-ER-004: an unidentified patient is cared for under a temporary name, and
// identifying them later keeps everything written under it. "Merge retains
// chronology" is the criterion.
func TestAnUnidentifiedPatientKeepsTheirChronology(t *testing.T) {
	h := newERHarness(t)
	patient, encounter := h.encounter(t, "Unknown", "+91-99000-22009")

	visit := h.arrive(t, &emergencyv1.ArriveRequest{
		EncounterId: encounter, ArrivalMode: emergencyv1.ArrivalMode_ARRIVAL_MODE_AMBULANCE,
		ChiefComplaint: "found collapsed", Unidentified: true,
		TemporaryName: "UNKNOWN MALE ALPHA", Location: "Resus 1",
	})
	if visit.GetTemporaryName() != "UNKNOWN MALE ALPHA" {
		t.Fatalf("temporary name = %q", visit.GetTemporaryName())
	}

	h.triage(t, visit.GetVisitId(), "1")
	// SRS-ER-008: the resuscitation timeline, written under the temporary name.
	if _, err := h.emergency.RecordEmergencyEvent(context.Background(),
		withFacility(h.nurseToken(), h.facility, &emergencyv1.RecordEmergencyEventRequest{
			VisitId: visit.GetVisitId(), Kind: emergencyv1.EventKind_EVENT_KIND_AIRWAY,
			Detail: "oropharyngeal airway sited", OccurredAt: timestamppb.New(time.Now().UTC()),
		})); err != nil {
		t.Fatalf("RecordEmergencyEvent: %v", err)
	}

	before, err := h.emergency.GetTimeline(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &emergencyv1.GetTimelineRequest{
			VisitId: visit.GetVisitId(),
		}))
	if err != nil {
		t.Fatalf("GetTimeline: %v", err)
	}

	identified, err := h.emergency.IdentifyPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &emergencyv1.IdentifyPatientRequest{
			VisitId: visit.GetVisitId(), PatientId: patient,
		}))
	if err != nil {
		t.Fatalf("IdentifyPatient: %v", err)
	}
	if identified.Msg.GetVisit().GetPatientId() != patient {
		t.Fatalf("patient = %q after identification", identified.Msg.GetVisit().GetPatientId())
	}
	// The temporary name stays. A wristband, a blood-gas printout and a
	// resuscitation record all say UNKNOWN MALE ALPHA, and a chart that
	// rewrote it would no longer agree with any of them.
	if identified.Msg.GetVisit().GetTemporaryName() != "UNKNOWN MALE ALPHA" {
		t.Fatal("identification erased the temporary name the record was written under")
	}

	after, err := h.emergency.GetTimeline(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &emergencyv1.GetTimelineRequest{
			VisitId: visit.GetVisitId(),
		}))
	if err != nil {
		t.Fatalf("GetTimeline after identification: %v", err)
	}
	if len(after.Msg.GetEvents()) != len(before.Msg.GetEvents()) {
		t.Fatalf("timeline went from %d events to %d across identification",
			len(before.Msg.GetEvents()), len(after.Msg.GetEvents()))
	}
}

// Triage is a nursing assessment against a published scale. A department where
// anybody may restate an acuity has no scale, so the desk that books the
// arrival cannot assign one.
func TestTheDeskMayBookAnArrivalAndMayNotTriage(t *testing.T) {
	h := newERHarness(t)
	_, encounter := h.encounter(t, "Shetty", "+91-99000-22010")

	visit := h.arrive(t, &emergencyv1.ArriveRequest{
		EncounterId: encounter, ChiefComplaint: "headache",
	})

	_, err := h.emergency.AssignTriage(context.Background(),
		withFacility(h.clerkToken(), h.facility, &emergencyv1.AssignTriageRequest{
			VisitId: visit.GetVisitId(), AcuityCode: "5", Consciousness: "alert",
		}))
	if err == nil {
		t.Fatal("a registration clerk assigned a triage acuity")
	}
	if code := connectCode(err); code.String() != "permission_denied" {
		t.Fatalf("code = %v, want permission_denied", code)
	}

	// And the desk cannot decide where the patient goes.
	if _, err := h.emergency.Dispose(context.Background(),
		withFacility(h.clerkToken(), h.facility, &emergencyv1.DisposeRequest{
			VisitId:     visit.GetVisitId(),
			Disposition: emergencyv1.Disposition_DISPOSITION_DISCHARGE,
		})); err == nil {
		t.Fatal("a registration clerk discharged a patient")
	}
}

// SRS-ER-014: an observation stay is not an admission, and recording it as one
// inflates the department's admission rate while emptying its observation
// reporting. Both numbers are ones a hospital is measured on.
func TestAnObservationStayIsNotAnAdmission(t *testing.T) {
	h := newERHarness(t)
	_, encounter := h.encounter(t, "Das", "+91-99000-22011")

	visit := h.arrive(t, &emergencyv1.ArriveRequest{
		EncounterId: encounter, ChiefComplaint: "head injury, brief LOC",
	})
	h.triage(t, visit.GetVisitId(), "3")

	// A review time in the future, because an observation stay with no end is
	// an admission nobody called an admission. One second, so the overdue
	// state below is reached rather than asserted about a clock.
	observing, err := h.emergency.StartObservation(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &emergencyv1.StartObservationRequest{
			VisitId:  visit.GetVisitId(),
			ReviewAt: timestamppb.New(time.Now().UTC().Add(time.Second)),
			Location: "Obs 2",
		}))
	if err != nil {
		t.Fatalf("StartObservation: %v", err)
	}
	if observing.Msg.GetVisit().GetStatus() != emergencyv1.VisitStatus_VISIT_STATUS_OBSERVATION {
		t.Fatalf("status = %v, want observation", observing.Msg.GetVisit().GetStatus())
	}

	// A review time that has passed shows on the board, which is the whole
	// point of recording one: four hours in a corridor bed is how an
	// observation stay becomes an admission nobody decided on.
	time.Sleep(1200 * time.Millisecond)
	board, err := h.emergency.GetBoard(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &emergencyv1.GetBoardRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("GetBoard: %v", err)
	}
	if len(board.Msg.GetRows()) != 1 || !board.Msg.GetRows()[0].GetObservationOverdue() {
		t.Fatal("an overdue observation review is not flagged on the board")
	}
}
