package app_test

import (
	"context"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	bloodbankv1 "github.com/ppusapati/health/code/gen/go/healthcare/bloodbank/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/bloodbank/v1/bloodbankv1connect"
	empiv1 "github.com/ppusapati/health/code/gen/go/healthcare/empi/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/empi/v1/empiv1connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	"github.com/ppusapati/health/code/internal/app"
	bloodbankapp "github.com/ppusapati/health/code/internal/bloodbank/application"
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

// The blood bank (SRS-BLD-001 … 017), end to end.
//
// The domain tests hold the compatibility tables. These hold what only the
// assembled stack shows: that an untested donation cannot be released whoever
// asks, that a bedside mismatch blocks the transfusion and raises a durable
// notice, that a reactive result pulls every sibling component off the shelf,
// and that the three blood bank jobs are separated by permissions rather than
// by convention.

type bldHarness struct {
	pool     *pgxpool.Pool
	bank     bloodbankv1connect.BloodBankServiceClient
	patients empiv1connect.PatientServiceClient
	org      organizationv1connect.OrganizationServiceClient

	tenantID string
	facility string
}

func newBldHarness(t *testing.T) *bldHarness {
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
		BloodBank: bloodbankapp.Config{
			// Without a configured panel nothing is releasable, which is the
			// zero value's deliberate refusal. These tests need a bank that
			// works, so they configure one.
			MandatoryTests: []string{"hiv", "hbv", "hcv", "syphilis"},
		},
	})

	server := httptest.NewServer(h2c.NewHandler(built.Handler, &http2.Server{}))
	t.Cleanup(server.Close)

	h := &bldHarness{
		pool:     pool,
		bank:     bloodbankv1connect.NewBloodBankServiceClient(server.Client(), server.URL),
		patients: empiv1connect.NewPatientServiceClient(server.Client(), server.URL),
		org:      organizationv1connect.NewOrganizationServiceClient(server.Client(), server.URL),
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

	for _, module := range []string{"empi", "bloodbank"} {
		h.entitle(t, module)
	}
	return h
}

func (h *bldHarness) entitle(t *testing.T, module string) {
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

func (h *bldHarness) scientistToken() string {
	return h.tenantID + ":scientist-1:blood_bank_scientist:" + h.facility
}

func (h *bldHarness) managerToken() string {
	return h.tenantID + ":manager-1:blood_bank_manager:" + h.facility
}

func (h *bldHarness) haemovigilanceToken() string {
	return h.tenantID + ":hv-1:haemovigilance_officer:" + h.facility
}

func (h *bldHarness) clinicianToken() string {
	return h.tenantID + ":doctor-1:clinician:" + h.facility
}

func (h *bldHarness) nurseToken() string {
	return h.tenantID + ":nurse-1:nurse:" + h.facility
}

func (h *bldHarness) clerkToken() string {
	return h.tenantID + ":clerk-1:registration_clerk:" + h.facility
}

func oNeg() *bloodbankv1.BloodGroup {
	return &bloodbankv1.BloodGroup{
		Abo: bloodbankv1.Abo_ABO_O, RhD: bloodbankv1.RhD_RH_D_NEGATIVE,
	}
}

func aPos() *bloodbankv1.BloodGroup {
	return &bloodbankv1.BloodGroup{
		Abo: bloodbankv1.Abo_ABO_A, RhD: bloodbankv1.RhD_RH_D_POSITIVE,
	}
}

// patient registers somebody who might be transfused.
func (h *bldHarness) patient(t *testing.T, family, phone string) string {
	t.Helper()

	registered, err := h.patients.RegisterPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterPatientRequest{
			Demographics: demographics(family, []string{"Vikram"},
				date(1972, 11, 9), empiv1.Sex_SEX_MALE, phone),
		}))
	if err != nil {
		t.Fatalf("RegisterPatient: %v", err)
	}
	return registered.Msg.GetPatient().GetPatientId()
}

// donation registers a donor, screens, collects and returns the collection id.
func (h *bldHarness) donation(t *testing.T, number string) string {
	t.Helper()
	ctx := context.Background()

	donor, err := h.bank.RegisterDonor(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.RegisterDonorRequest{
				DonorNumber: "D-" + number, DisplayName: "Anita Rao",
				Group: oNeg(),
			}))
	if err != nil {
		t.Fatalf("RegisterDonor: %v", err)
	}
	donorID := donor.Msg.GetDonor().GetDonorId()

	screening, err := h.bank.ScreenDonor(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.ScreenDonorRequest{
				DonorId:      donorID,
				Measurements: map[string]float64{"haemoglobin": 13.4},
				Consented:    true, Accepted: true,
			}))
	if err != nil {
		t.Fatalf("ScreenDonor: %v", err)
	}

	collection, err := h.bank.Collect(ctx,
		withFacility(h.scientistToken(), h.facility, &bloodbankv1.CollectRequest{
			DonorId:        donorID,
			ScreeningId:    screening.Msg.GetScreening().GetScreeningId(),
			DonationNumber: "DN-" + number, Kind: "whole_blood",
			VolumeMl: 450, Group: oNeg(),
		}))
	if err != nil {
		t.Fatalf("Collect: %v", err)
	}
	return collection.Msg.GetCollection().GetCollectionId()
}

// component makes one unit from a donation.
func (h *bldHarness) component(t *testing.T, collectionID, number string,
	mutate func(*bloodbankv1.AddComponentRequest)) string {

	t.Helper()

	req := &bloodbankv1.AddComponentRequest{
		UnitNumber: number, CollectionId: collectionID,
		ComponentClass: bloodbankv1.ComponentClass_COMPONENT_CLASS_RED_CELLS,
		Group:          oNeg(),
		VolumeMl:       280, Location: "fridge 2",
		Source:      "collected here",
		CollectedAt: timestamppb.New(time.Now().Add(-time.Hour)),
		ExpiresAt:   timestamppb.New(time.Now().Add(35 * 24 * time.Hour)),
	}
	if mutate != nil {
		mutate(req)
	}

	added, err := h.bank.AddComponent(context.Background(),
		withFacility(h.scientistToken(), h.facility, req))
	if err != nil {
		t.Fatalf("AddComponent: %v", err)
	}
	return added.Msg.GetComponent().GetComponentId()
}

// testAndRelease runs the full mandatory panel and releases the components.
func (h *bldHarness) testAndRelease(t *testing.T, collectionID string) {
	t.Helper()
	ctx := context.Background()

	for _, code := range []string{"hiv", "hbv", "hcv", "syphilis"} {
		if _, err := h.bank.RecordTest(ctx,
			withFacility(h.scientistToken(), h.facility,
				&bloodbankv1.RecordTestRequest{
					CollectionId: collectionID, Code: code, Reactive: false,
				})); err != nil {
			t.Fatalf("RecordTest %s: %v", code, err)
		}
	}
	if _, err := h.bank.ReleaseComponents(ctx,
		withFacility(h.managerToken(), h.facility,
			&bloodbankv1.ReleaseComponentsRequest{
				CollectionId: collectionID,
			})); err != nil {
		t.Fatalf("ReleaseComponents: %v", err)
	}
}

// SRS-BLD-004. An untested donation is not releasable, and the refusal names
// the assays that are missing.
func TestAnUntestedDonationCannotBeReleased(t *testing.T) {
	h := newBldHarness(t)
	ctx := context.Background()
	collection := h.donation(t, "0001")
	componentID := h.component(t, collection, "G100001", nil)

	// It arrives quarantined, whatever anybody meant.
	unit, err := h.bank.GetComponent(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.GetComponentRequest{ComponentId: componentID}))
	if err != nil {
		t.Fatalf("GetComponent: %v", err)
	}
	if unit.Msg.GetComponent().GetStatus() !=
		bloodbankv1.UnitStatus_UNIT_STATUS_QUARANTINED {
		t.Fatalf("status = %v, want quarantined",
			unit.Msg.GetComponent().GetStatus())
	}
	if unit.Msg.GetComponent().GetIssuable() {
		t.Error("an untested unit reads as issuable")
	}

	decision, err := h.bank.GetReleaseDecision(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.GetReleaseDecisionRequest{CollectionId: collection}))
	if err != nil {
		t.Fatalf("GetReleaseDecision: %v", err)
	}
	if decision.Msg.GetDecision().GetReleasable() {
		t.Fatal("an untested donation was releasable")
	}
	if len(decision.Msg.GetDecision().GetMissing()) != 4 {
		t.Errorf("missing = %v; a scientist needs to know which assay to run",
			decision.Msg.GetDecision().GetMissing())
	}

	if _, err := h.bank.ReleaseComponents(ctx,
		withFacility(h.managerToken(), h.facility,
			&bloodbankv1.ReleaseComponentsRequest{
				CollectionId: collection,
			})); err == nil {
		t.Fatal("an untested donation was released")
	}

	// A scientist cannot release even a fully tested one: the person who ran
	// the assay is not the person who declares it clear.
	for _, code := range []string{"hiv", "hbv", "hcv", "syphilis"} {
		if _, err := h.bank.RecordTest(ctx,
			withFacility(h.scientistToken(), h.facility,
				&bloodbankv1.RecordTestRequest{
					CollectionId: collection, Code: code,
				})); err != nil {
			t.Fatalf("RecordTest: %v", err)
		}
	}
	if _, err := h.bank.ReleaseComponents(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.ReleaseComponentsRequest{
				CollectionId: collection,
			})); err == nil {
		t.Fatal("a scientist released the donation they tested")
	}

	released, err := h.bank.ReleaseComponents(ctx,
		withFacility(h.managerToken(), h.facility,
			&bloodbankv1.ReleaseComponentsRequest{CollectionId: collection}))
	if err != nil {
		t.Fatalf("ReleaseComponents: %v", err)
	}
	if len(released.Msg.GetComponents()) != 1 {
		t.Fatalf("released = %d, want 1", len(released.Msg.GetComponents()))
	}
	if !released.Msg.GetComponents()[0].GetIssuable() {
		t.Error("a released unit does not read as issuable")
	}
}

// SRS-BLD-004. A reactive result arriving late pulls every component made from
// the donation back off the shelf.
func TestALateReactiveResultQuarantinesTheWholeDonation(t *testing.T) {
	h := newBldHarness(t)
	ctx := context.Background()
	collection := h.donation(t, "0002")
	cells := h.component(t, collection, "G200001", nil)
	plasma := h.component(t, collection, "G200002",
		func(req *bloodbankv1.AddComponentRequest) {
			req.ComponentClass = bloodbankv1.ComponentClass_COMPONENT_CLASS_PLASMA
		})
	h.testAndRelease(t, collection)

	// A repeat HCV comes back reactive.
	if _, err := h.bank.RecordTest(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.RecordTestRequest{
				CollectionId: collection, Code: "hcv", Reactive: true,
			})); err != nil {
		t.Fatalf("RecordTest: %v", err)
	}

	for _, id := range []string{cells, plasma} {
		unit, err := h.bank.GetComponent(ctx,
			withFacility(h.scientistToken(), h.facility,
				&bloodbankv1.GetComponentRequest{ComponentId: id}))
		if err != nil {
			t.Fatalf("GetComponent: %v", err)
		}
		if unit.Msg.GetComponent().GetStatus() !=
			bloodbankv1.UnitStatus_UNIT_STATUS_QUARANTINED {
			t.Errorf("unit %s status = %v; a reactive result must reach every "+
				"component made from the donation",
				unit.Msg.GetComponent().GetUnitNumber(),
				unit.Msg.GetComponent().GetStatus())
		}
	}

	decision, err := h.bank.GetReleaseDecision(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.GetReleaseDecisionRequest{CollectionId: collection}))
	if err != nil {
		t.Fatalf("GetReleaseDecision: %v", err)
	}
	if decision.Msg.GetDecision().GetReleasable() {
		t.Error("a donation with a reactive result was releasable again")
	}
}

// SRS-BLD-006, SRS-BLD-007. A search returns every candidate with its verdict,
// so a near-miss is visible rather than silently absent.
func TestACompatibilitySearchShowsTheNearMisses(t *testing.T) {
	h := newBldHarness(t)
	ctx := context.Background()
	patientID := h.patient(t, "Nair", "+91-99000-66001")

	// Two units: one O-negative, one A-positive. The patient is O-negative, so
	// the second is incompatible and should still be shown with its reason.
	first := h.donation(t, "0003")
	h.component(t, first, "G300001", nil)
	h.testAndRelease(t, first)

	second := h.donation(t, "0004")
	h.component(t, second, "G300002", func(req *bloodbankv1.AddComponentRequest) {
		req.Group = aPos()
	})
	h.testAndRelease(t, second)

	if _, err := h.bank.GroupPatient(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.GroupPatientRequest{
				PatientId: patientID, SampleNumber: "S0001", Group: oNeg(),
			})); err != nil {
		t.Fatalf("GroupPatient: %v", err)
	}

	placed, err := h.bank.PlaceRequest(ctx,
		withFacility(h.clinicianToken(), h.facility,
			&bloodbankv1.PlaceRequestRequest{
				PatientId: patientID, FacilityId: h.facility,
				ComponentClass: bloodbankv1.ComponentClass_COMPONENT_CLASS_RED_CELLS,
				Quantity:       2,
				Indication:     "symptomatic anaemia, Hb 68",
				Urgency:        bloodbankv1.RequestUrgency_REQUEST_URGENCY_ROUTINE,
			}))
	if err != nil {
		t.Fatalf("PlaceRequest: %v", err)
	}
	requestID := placed.Msg.GetRequest().GetRequestId()

	found, err := h.bank.FindCompatible(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.FindCompatibleRequest{RequestId: requestID}))
	if err != nil {
		t.Fatalf("FindCompatible: %v", err)
	}
	if len(found.Msg.GetCandidates()) != 2 {
		t.Fatalf("candidates = %d, want both units shown",
			len(found.Msg.GetCandidates()))
	}

	byNumber := map[string]*bloodbankv1.Candidate{}
	for _, candidate := range found.Msg.GetCandidates() {
		byNumber[candidate.GetComponent().GetUnitNumber()] = candidate
	}
	if !byNumber["G300001"].GetDecision().GetAllowed() {
		t.Errorf("the O-negative unit was refused: %v",
			byNumber["G300001"].GetDecision().GetExplanations())
	}
	if byNumber["G300002"].GetDecision().GetAllowed() {
		t.Error("an A-positive unit matched an O-negative patient")
	}
	if len(byNumber["G300002"].GetDecision().GetExplanations()) == 0 {
		t.Error("the incompatible unit was shown with no reason, which is a " +
			"screen a scientist cannot act on")
	}

	// And a clinician cannot crossmatch their own patient's blood.
	if _, err := h.bank.Reserve(ctx,
		withFacility(h.clinicianToken(), h.facility, &bloodbankv1.ReserveRequest{
			RequestId:   requestID,
			ComponentId: byNumber["G300001"].GetComponent().GetComponentId(),
		})); err == nil {
		t.Fatal("a clinician crossmatched blood for their own request")
	}

	reserved, err := h.bank.Reserve(ctx,
		withFacility(h.scientistToken(), h.facility, &bloodbankv1.ReserveRequest{
			RequestId:    requestID,
			ComponentId:  byNumber["G300001"].GetComponent().GetComponentId(),
			Crossmatched: true,
		}))
	if err != nil {
		t.Fatalf("Reserve: %v", err)
	}
	if !reserved.Msg.GetReservation().GetCrossmatched() {
		t.Error("the crossmatch flag was lost")
	}

	// The reserved unit is no longer offered.
	again, err := h.bank.FindCompatible(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.FindCompatibleRequest{RequestId: requestID}))
	if err != nil {
		t.Fatalf("FindCompatible: %v", err)
	}
	for _, candidate := range again.Msg.GetCandidates() {
		if candidate.GetComponent().GetUnitNumber() == "G300001" {
			t.Error("a reserved unit was offered again")
		}
	}
}

// SRS-BLD-007. A patient nobody has grouped cannot be matched, and the refusal
// says so rather than "no blood available".
func TestAnUngroupedPatientIsToldToSendATube(t *testing.T) {
	h := newBldHarness(t)
	ctx := context.Background()
	patientID := h.patient(t, "Menon", "+91-99000-66002")

	collection := h.donation(t, "0005")
	h.component(t, collection, "G400001", nil)
	h.testAndRelease(t, collection)

	placed, err := h.bank.PlaceRequest(ctx,
		withFacility(h.clinicianToken(), h.facility,
			&bloodbankv1.PlaceRequestRequest{
				PatientId:      patientID,
				ComponentClass: bloodbankv1.ComponentClass_COMPONENT_CLASS_RED_CELLS,
				Quantity:       1, Indication: "pre-operative",
			}))
	if err != nil {
		t.Fatalf("PlaceRequest: %v", err)
	}

	_, err = h.bank.FindCompatible(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.FindCompatibleRequest{
				RequestId: placed.Msg.GetRequest().GetRequestId(),
			}))
	if err == nil {
		t.Fatal("a search ran for a patient with no grouping sample")
	}
	if !strings.Contains(err.Error(), "sample") {
		t.Errorf("the refusal does not say a sample is needed: %v; the fix is "+
			"another tube, not other blood", err)
	}
}

// SRS-BLD-006. A request with no indication cannot be reviewed afterwards.
func TestARequestWithoutAnIndicationIsRefused(t *testing.T) {
	h := newBldHarness(t)
	patientID := h.patient(t, "Rao", "+91-99000-66003")

	if _, err := h.bank.PlaceRequest(context.Background(),
		withFacility(h.clinicianToken(), h.facility,
			&bloodbankv1.PlaceRequestRequest{
				PatientId:      patientID,
				ComponentClass: bloodbankv1.ComponentClass_COMPONENT_CLASS_RED_CELLS,
				Quantity:       2,
			})); err == nil {
		t.Fatal("a request with no indication was accepted; the utilisation " +
			"review exists to find transfusions that should not have happened")
	}
}

// SRS-BLD-009, SRS-BLD-010, SRS-BLD-011. The whole path: reserve, issue,
// bedside check, transfuse, observe, complete.
func TestAUnitTravelsFromTheFridgeToThePatient(t *testing.T) {
	h := newBldHarness(t)
	ctx := context.Background()
	patientID := h.patient(t, "Pillai", "+91-99000-66004")

	collection := h.donation(t, "0006")
	componentID := h.component(t, collection, "G500001", nil)
	h.testAndRelease(t, collection)

	if _, err := h.bank.GroupPatient(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.GroupPatientRequest{
				PatientId: patientID, SampleNumber: "S0006", Group: oNeg(),
			})); err != nil {
		t.Fatalf("GroupPatient: %v", err)
	}
	placed, err := h.bank.PlaceRequest(ctx,
		withFacility(h.clinicianToken(), h.facility,
			&bloodbankv1.PlaceRequestRequest{
				PatientId:      patientID,
				ComponentClass: bloodbankv1.ComponentClass_COMPONENT_CLASS_RED_CELLS,
				Quantity:       1, Indication: "acute blood loss",
			}))
	if err != nil {
		t.Fatalf("PlaceRequest: %v", err)
	}
	reserved, err := h.bank.Reserve(ctx,
		withFacility(h.scientistToken(), h.facility, &bloodbankv1.ReserveRequest{
			RequestId:   placed.Msg.GetRequest().GetRequestId(),
			ComponentId: componentID, Crossmatched: true,
		}))
	if err != nil {
		t.Fatalf("Reserve: %v", err)
	}

	// The final check at the counter is compared against the record.
	if _, err := h.bank.IssueUnit(ctx,
		withFacility(h.scientistToken(), h.facility, &bloodbankv1.IssueUnitRequest{
			ComponentId:     componentID,
			ReservationId:   reserved.Msg.GetReservation().GetReservationId(),
			Destination:     "ward 7",
			CheckUnitNumber: "G999999", CheckPatientId: patientID,
		})); err == nil {
		t.Fatal("a unit was issued against a different unit number")
	}

	issued, err := h.bank.IssueUnit(ctx,
		withFacility(h.scientistToken(), h.facility, &bloodbankv1.IssueUnitRequest{
			ComponentId:   componentID,
			ReservationId: reserved.Msg.GetReservation().GetReservationId(),
			Destination:   "ward 7", IssuedTo: "porter-1",
			CheckUnitNumber: "G500001", CheckPatientId: patientID,
		}))
	if err != nil {
		t.Fatalf("IssueUnit: %v", err)
	}
	if issued.Msg.GetIssue().GetEmergency() {
		t.Error("an ordinary issue was flagged as an emergency release")
	}
	if issued.Msg.GetIssue().GetCheckedBy() == "" {
		t.Error("the final identity check names nobody; it cannot be reviewed")
	}

	// A solo bedside check is refused, and the refusal says why.
	solo := &bloodbankv1.BedsideCheck{
		UnitNumber: "G500001", PatientId: patientID,
		PatientGroup: oNeg(), UnitGroup: oNeg(),
		CheckedWith: "",
	}
	verified, err := h.bank.VerifyBedside(ctx,
		withFacility(h.nurseToken(), h.facility,
			&bloodbankv1.VerifyBedsideRequest{Check: solo}))
	if err != nil {
		t.Fatalf("VerifyBedside: %v", err)
	}
	if verified.Msg.GetPassed() {
		t.Fatal("a solo bedside check passed")
	}

	good := &bloodbankv1.BedsideCheck{
		UnitNumber: "G500001", PatientId: patientID,
		PatientGroup: oNeg(), UnitGroup: oNeg(),
		CheckedWith: "nurse-2",
		Baseline:    map[string]float64{"temperature": 36.8, "pulse": 84},
	}
	verified, err = h.bank.VerifyBedside(ctx,
		withFacility(h.nurseToken(), h.facility,
			&bloodbankv1.VerifyBedsideRequest{Check: good}))
	if err != nil {
		t.Fatalf("VerifyBedside: %v", err)
	}
	if !verified.Msg.GetPassed() {
		t.Fatalf("a correct bedside check failed: %v",
			verified.Msg.GetExplanations())
	}

	started, err := h.bank.StartTransfusion(ctx,
		withFacility(h.nurseToken(), h.facility,
			&bloodbankv1.StartTransfusionRequest{Check: good}))
	if err != nil {
		t.Fatalf("StartTransfusion: %v", err)
	}
	episodeID := started.Msg.GetEpisode().GetEpisodeId()
	if len(started.Msg.GetEpisode().GetObservations()) != 1 {
		t.Errorf("baseline observations = %d, want 1",
			len(started.Msg.GetEpisode().GetObservations()))
	}

	// The protocol sets it still needs are named, not blocking.
	read, err := h.bank.GetEpisode(ctx,
		withFacility(h.nurseToken(), h.facility,
			&bloodbankv1.GetEpisodeRequest{EpisodeId: episodeID}))
	if err != nil {
		t.Fatalf("GetEpisode: %v", err)
	}
	if len(read.Msg.GetMissingObservations()) != 2 {
		t.Errorf("missing = %v, want the fifteen-minute and completion sets",
			read.Msg.GetMissingObservations())
	}

	if _, err := h.bank.Observe(ctx,
		withFacility(h.nurseToken(), h.facility, &bloodbankv1.ObserveRequest{
			EpisodeId: episodeID, Timing: "15_minutes",
			Values: map[string]float64{"temperature": 37.0, "pulse": 88},
		})); err != nil {
		t.Fatalf("Observe: %v", err)
	}

	ended, err := h.bank.EndTransfusion(ctx,
		withFacility(h.nurseToken(), h.facility,
			&bloodbankv1.EndTransfusionRequest{
				EpisodeId: episodeID, VolumeGivenMl: 280,
			}))
	if err != nil {
		t.Fatalf("EndTransfusion: %v", err)
	}
	if ended.Msg.GetEpisode().GetStatus() !=
		bloodbankv1.EpisodeStatus_EPISODE_STATUS_COMPLETED {
		t.Errorf("status = %v, want completed", ended.Msg.GetEpisode().GetStatus())
	}

	// And the unit is transfused: it cannot be given to anybody else.
	unit, err := h.bank.GetComponent(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.GetComponentRequest{UnitNumber: "G500001"}))
	if err != nil {
		t.Fatalf("GetComponent: %v", err)
	}
	if unit.Msg.GetComponent().GetStatus() !=
		bloodbankv1.UnitStatus_UNIT_STATUS_TRANSFUSED {
		t.Errorf("status = %v, want transfused",
			unit.Msg.GetComponent().GetStatus())
	}
}

// SRS-BLD-010. A bedside mismatch blocks the transfusion and raises a durable,
// acknowledged notice — the critical exception the requirement names.
func TestABedsideMismatchBlocksAndEscalates(t *testing.T) {
	h := newBldHarness(t)
	ctx := context.Background()
	intended := h.patient(t, "Kurup", "+91-99000-66005")
	other := h.patient(t, "Menon", "+91-99000-66006")

	collection := h.donation(t, "0007")
	componentID := h.component(t, collection, "G600001", nil)
	h.testAndRelease(t, collection)

	if _, err := h.bank.GroupPatient(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.GroupPatientRequest{
				PatientId: intended, SampleNumber: "S0007", Group: oNeg(),
			})); err != nil {
		t.Fatalf("GroupPatient: %v", err)
	}
	placed, err := h.bank.PlaceRequest(ctx,
		withFacility(h.clinicianToken(), h.facility,
			&bloodbankv1.PlaceRequestRequest{
				PatientId:      intended,
				ComponentClass: bloodbankv1.ComponentClass_COMPONENT_CLASS_RED_CELLS,
				Quantity:       1, Indication: "anaemia",
			}))
	if err != nil {
		t.Fatalf("PlaceRequest: %v", err)
	}
	reserved, err := h.bank.Reserve(ctx,
		withFacility(h.scientistToken(), h.facility, &bloodbankv1.ReserveRequest{
			RequestId:   placed.Msg.GetRequest().GetRequestId(),
			ComponentId: componentID, Crossmatched: true,
		}))
	if err != nil {
		t.Fatalf("Reserve: %v", err)
	}
	if _, err := h.bank.IssueUnit(ctx,
		withFacility(h.scientistToken(), h.facility, &bloodbankv1.IssueUnitRequest{
			ComponentId:     componentID,
			ReservationId:   reserved.Msg.GetReservation().GetReservationId(),
			Destination:     "ward 7",
			CheckUnitNumber: "G600001", CheckPatientId: intended,
		})); err != nil {
		t.Fatalf("IssueUnit: %v", err)
	}

	// The wrong patient at the bedside.
	wrong := &bloodbankv1.BedsideCheck{
		UnitNumber: "G600001", PatientId: other,
		PatientGroup: oNeg(), UnitGroup: oNeg(),
		CheckedWith: "nurse-2",
		Baseline:    map[string]float64{"temperature": 36.8, "pulse": 88},
	}
	if _, err := h.bank.StartTransfusion(ctx,
		withFacility(h.nurseToken(), h.facility,
			&bloodbankv1.StartTransfusionRequest{Check: wrong})); err == nil {
		t.Fatal("a transfusion started against the wrong patient")
	}

	// The notice is durable: the blood bank finds out whether or not anybody
	// is looking at a screen.
	var notices int
	if err := h.pool.QueryRow(ctx, `
		SELECT count(*) FROM platform_escalation.notice
		WHERE tenant_id = $1 AND subject_kind = 'transfusion_mismatch'`,
		h.tenantID).Scan(&notices); err != nil {
		t.Fatalf("notice query: %v", err)
	}
	if notices == 0 {
		t.Error("a bedside mismatch raised no escalation; the bank would not " +
			"know before the next unit went out")
	}

	// And the denial is in the audit trail.
	var denials int
	if err := h.pool.QueryRow(ctx, `
		SELECT count(*) FROM platform_data.audit_record
		WHERE tenant_id = $1 AND outcome = 'denied'
		  AND reason LIKE 'bedside check failed%'`,
		h.tenantID).Scan(&denials); err != nil {
		t.Fatalf("audit query: %v", err)
	}
	if denials == 0 {
		t.Error("the failed bedside check is not in the audit trail")
	}

	// The unit was not consumed by the failed attempt.
	unit, err := h.bank.GetComponent(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.GetComponentRequest{UnitNumber: "G600001"}))
	if err != nil {
		t.Fatalf("GetComponent: %v", err)
	}
	if unit.Msg.GetComponent().GetStatus() ==
		bloodbankv1.UnitStatus_UNIT_STATUS_TRANSFUSED {
		t.Error("a failed bedside check consumed the unit")
	}
}

// SRS-BLD-016. An emergency release needs a senior authoriser, is flagged, and
// stays on the outstanding list until it is reconciled.
func TestAnEmergencyReleaseIsAuthorisedAndReconciled(t *testing.T) {
	h := newBldHarness(t)
	ctx := context.Background()
	patientID := h.patient(t, "Thomas", "+91-99000-66007")

	collection := h.donation(t, "0008")
	componentID := h.component(t, collection, "G700001", nil)
	h.testAndRelease(t, collection)

	// A scientist does not hold the emergency permission.
	if _, err := h.bank.IssueUnit(ctx,
		withFacility(h.scientistToken(), h.facility, &bloodbankv1.IssueUnitRequest{
			ComponentId: componentID, Destination: "resus",
			CheckUnitNumber: "G700001", CheckPatientId: patientID,
			Emergency:           true,
			EmergencyAuthoriser: "consultant-1",
			EmergencyReason:     "massive haemorrhage protocol",
		})); err == nil {
		t.Fatal("a scientist authorised an uncrossmatched release")
	}

	// And a manager cannot without naming somebody.
	if _, err := h.bank.IssueUnit(ctx,
		withFacility(h.managerToken(), h.facility, &bloodbankv1.IssueUnitRequest{
			ComponentId: componentID, Destination: "resus",
			CheckUnitNumber: "G700001", CheckPatientId: patientID,
			Emergency: true,
		})); err == nil {
		t.Fatal("an emergency release with no authoriser was accepted")
	}

	issued, err := h.bank.IssueUnit(ctx,
		withFacility(h.managerToken(), h.facility, &bloodbankv1.IssueUnitRequest{
			ComponentId: componentID, Destination: "resus",
			CheckUnitNumber: "G700001", CheckPatientId: patientID,
			Emergency:           true,
			EmergencyAuthoriser: "consultant-1",
			EmergencyReason:     "massive haemorrhage protocol",
		}))
	if err != nil {
		t.Fatalf("IssueUnit emergency: %v", err)
	}
	if !issued.Msg.GetIssue().GetEmergency() {
		t.Error("the release is not flagged as an emergency")
	}

	outstanding, err := h.bank.ListOutstandingReleases(ctx,
		withFacility(h.managerToken(), h.facility,
			&bloodbankv1.ListOutstandingReleasesRequest{}))
	if err != nil {
		t.Fatalf("ListOutstandingReleases: %v", err)
	}
	if len(outstanding.Msg.GetIssues()) != 1 {
		t.Fatalf("outstanding = %d, want 1", len(outstanding.Msg.GetIssues()))
	}

	if _, err := h.bank.ReconcileRelease(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.ReconcileReleaseRequest{
				IssueId: issued.Msg.GetIssue().GetIssueId(),
				Note:    "retrospective crossmatch compatible",
			})); err != nil {
		t.Fatalf("ReconcileRelease: %v", err)
	}

	outstanding, err = h.bank.ListOutstandingReleases(ctx,
		withFacility(h.managerToken(), h.facility,
			&bloodbankv1.ListOutstandingReleasesRequest{}))
	if err != nil {
		t.Fatalf("ListOutstandingReleases: %v", err)
	}
	if len(outstanding.Msg.GetIssues()) != 0 {
		t.Errorf("outstanding = %d after reconciliation",
			len(outstanding.Msg.GetIssues()))
	}
}

// SRS-BLD-012, SRS-BLD-014. A reaction quarantines the siblings, and the
// look-back reaches the patients.
func TestAReactionPullsTheSiblingsAndTheLookBackFindsThePatients(t *testing.T) {
	h := newBldHarness(t)
	ctx := context.Background()
	patientID := h.patient(t, "Varghese", "+91-99000-66008")

	collection := h.donation(t, "0009")
	cells := h.component(t, collection, "G800001", nil)
	plasma := h.component(t, collection, "G800002",
		func(req *bloodbankv1.AddComponentRequest) {
			req.ComponentClass = bloodbankv1.ComponentClass_COMPONENT_CLASS_PLASMA
		})
	h.testAndRelease(t, collection)

	// Get the red cells into the patient.
	if _, err := h.bank.GroupPatient(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.GroupPatientRequest{
				PatientId: patientID, SampleNumber: "S0009", Group: oNeg(),
			})); err != nil {
		t.Fatalf("GroupPatient: %v", err)
	}
	placed, err := h.bank.PlaceRequest(ctx,
		withFacility(h.clinicianToken(), h.facility,
			&bloodbankv1.PlaceRequestRequest{
				PatientId:      patientID,
				ComponentClass: bloodbankv1.ComponentClass_COMPONENT_CLASS_RED_CELLS,
				Quantity:       1, Indication: "anaemia",
			}))
	if err != nil {
		t.Fatalf("PlaceRequest: %v", err)
	}
	reserved, err := h.bank.Reserve(ctx,
		withFacility(h.scientistToken(), h.facility, &bloodbankv1.ReserveRequest{
			RequestId:   placed.Msg.GetRequest().GetRequestId(),
			ComponentId: cells, Crossmatched: true,
		}))
	if err != nil {
		t.Fatalf("Reserve: %v", err)
	}
	if _, err := h.bank.IssueUnit(ctx,
		withFacility(h.scientistToken(), h.facility, &bloodbankv1.IssueUnitRequest{
			ComponentId:     cells,
			ReservationId:   reserved.Msg.GetReservation().GetReservationId(),
			Destination:     "ward 7",
			CheckUnitNumber: "G800001", CheckPatientId: patientID,
		})); err != nil {
		t.Fatalf("IssueUnit: %v", err)
	}
	check := &bloodbankv1.BedsideCheck{
		UnitNumber: "G800001", PatientId: patientID,
		PatientGroup: oNeg(), UnitGroup: oNeg(), CheckedWith: "nurse-2",
		Baseline: map[string]float64{"temperature": 36.8, "pulse": 88},
	}
	started, err := h.bank.StartTransfusion(ctx,
		withFacility(h.nurseToken(), h.facility,
			&bloodbankv1.StartTransfusionRequest{Check: check}))
	if err != nil {
		t.Fatalf("StartTransfusion: %v", err)
	}

	// Fifteen minutes in, rigors. SRS-NUR-014: the action runs from the
	// bedside, so reporting is one call — it stops the transfusion, records
	// what was done and what the patient had received, and opens the
	// investigation. A nurse who had to call EndTransfusion as well would be
	// filling in a form while the patient is reacting.
	if _, err := h.bank.ReportReaction(ctx,
		withFacility(h.nurseToken(), h.facility,
			&bloodbankv1.ReportReactionRequest{
				EpisodeId:   started.Msg.GetEpisode().GetEpisodeId(),
				ComponentId: cells, PatientId: patientID,
				Severity: bloodbankv1.ReactionSeverity_REACTION_SEVERITY_SEVERE,
				Features: []string{"rigors", "fever", "hypotension"},
			})); err == nil {
		t.Fatal("a reaction was reported with no account of what was done")
	}

	reported, err := h.bank.ReportReaction(ctx,
		withFacility(h.nurseToken(), h.facility,
			&bloodbankv1.ReportReactionRequest{
				EpisodeId:   started.Msg.GetEpisode().GetEpisodeId(),
				ComponentId: cells, PatientId: patientID,
				Severity: bloodbankv1.ReactionSeverity_REACTION_SEVERITY_SEVERE,
				Features: []string{"rigors", "fever", "hypotension"},
				ActionTaken: "transfusion stopped, line kept open with saline, " +
					"unit and giving set returned to the blood bank",
				VolumeGivenMl: 60,
			}))
	if err != nil {
		t.Fatalf("ReportReaction: %v", err)
	}
	if reported.Msg.GetReaction().GetActionTaken() == "" {
		t.Error("the reaction came back without what was done about it")
	}

	stopped, err := h.bank.GetEpisode(ctx,
		withFacility(h.nurseToken(), h.facility,
			&bloodbankv1.GetEpisodeRequest{
				EpisodeId: started.Msg.GetEpisode().GetEpisodeId(),
			}))
	if err != nil {
		t.Fatalf("GetEpisode: %v", err)
	}
	episode := stopped.Msg.GetEpisode()
	if episode.GetStatus() != bloodbankv1.EpisodeStatus_EPISODE_STATUS_STOPPED {
		t.Errorf("the transfusion is %v after a reaction was reported; "+
			"the unit was left running", episode.GetStatus())
	}
	if !strings.Contains(episode.GetStopReason(), "saline") {
		t.Errorf("stop reason = %q; it does not carry the bedside action",
			episode.GetStopReason())
	}
	if episode.GetVolumeGivenMl() != 60 {
		t.Errorf("volume given = %d, want the 60ml the patient received",
			episode.GetVolumeGivenMl())
	}

	// The plasma from the same donation comes off the shelf.
	sibling, err := h.bank.GetComponent(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.GetComponentRequest{ComponentId: plasma}))
	if err != nil {
		t.Fatalf("GetComponent: %v", err)
	}
	if sibling.Msg.GetComponent().GetStatus() !=
		bloodbankv1.UnitStatus_UNIT_STATUS_QUARANTINED {
		t.Errorf("the sibling plasma status = %v; waiting for the "+
			"investigation to conclude is waiting while it is given to "+
			"somebody else", sibling.Msg.GetComponent().GetStatus())
	}

	// The nurse cannot run a look-back; the haemovigilance officer can.
	donor, err := h.bank.GetComponent(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.GetComponentRequest{ComponentId: cells}))
	if err != nil {
		t.Fatalf("GetComponent: %v", err)
	}
	donorID := donor.Msg.GetComponent().GetDonorId()

	if _, err := h.bank.LookBack(ctx,
		withFacility(h.nurseToken(), h.facility,
			&bloodbankv1.LookBackRequest{DonorId: donorID})); err == nil {
		t.Fatal("a nurse ran a look-back across every patient a donor reached")
	}

	recipients, err := h.bank.LookBack(ctx,
		withFacility(h.haemovigilanceToken(), h.facility,
			&bloodbankv1.LookBackRequest{DonorId: donorID}))
	if err != nil {
		t.Fatalf("LookBack: %v", err)
	}
	if len(recipients.Msg.GetRecipients()) != 1 {
		t.Fatalf("recipients = %d, want 1", len(recipients.Msg.GetRecipients()))
	}
	if recipients.Msg.GetRecipients()[0].GetUnitNumber() != "G800001" {
		t.Errorf("the look-back does not name the unit: %+v",
			recipients.Msg.GetRecipients()[0])
	}

	// The look-back is audited with the count, because it and a fishing
	// expedition look identical in the query log.
	var traces int
	if err := h.pool.QueryRow(ctx, `
		SELECT count(*) FROM platform_data.audit_record
		WHERE tenant_id = $1 AND reason LIKE 'look-back reached%'`,
		h.tenantID).Scan(&traces); err != nil {
		t.Fatalf("audit query: %v", err)
	}
	if traces != 1 {
		t.Errorf("look-back audit rows = %d, want 1", traces)
	}

	// The vein-to-vein chain renders end to end with no gaps.
	chain, err := h.bank.TraceUnit(ctx,
		withFacility(h.haemovigilanceToken(), h.facility,
			&bloodbankv1.TraceUnitRequest{ComponentId: cells}))
	if err != nil {
		t.Fatalf("TraceUnit: %v", err)
	}
	if len(chain.Msg.GetChain().GetGaps()) != 0 {
		t.Errorf("gaps = %v; this unit has a complete history",
			chain.Msg.GetChain().GetGaps())
	}
	stages := map[string]bool{}
	for _, link := range chain.Msg.GetChain().GetLinks() {
		stages[link.GetStage()] = true
	}
	for _, want := range []string{"donor", "collection", "component",
		"testing", "issue", "transfusion", "reaction"} {
		if !stages[want] {
			t.Errorf("the chain is missing the %q stage", want)
		}
	}

	// And the investigation concludes once, by the officer.
	if _, err := h.bank.ConcludeInvestigation(ctx,
		withFacility(h.haemovigilanceToken(), h.facility,
			&bloodbankv1.ConcludeInvestigationRequest{
				ReactionId:     reported.Msg.GetReaction().GetReactionId(),
				Classification: "febrile_non_haemolytic",
				Conclusion:     "no serological incompatibility",
				UnitReturned:   true,
			})); err != nil {
		t.Fatalf("ConcludeInvestigation: %v", err)
	}
	open, err := h.bank.ListOpenInvestigations(ctx,
		withFacility(h.haemovigilanceToken(), h.facility,
			&bloodbankv1.ListOpenInvestigationsRequest{}))
	if err != nil {
		t.Fatalf("ListOpenInvestigations: %v", err)
	}
	if len(open.Msg.GetReactions()) != 0 {
		t.Errorf("open investigations = %d after concluding",
			len(open.Msg.GetReactions()))
	}
}

// SRS-BLD-017. Stock alerts fire on a configured threshold and on expiry.
func TestStockAlertsFireOnThresholdsAndExpiry(t *testing.T) {
	h := newBldHarness(t)
	ctx := context.Background()

	collection := h.donation(t, "0010")
	h.component(t, collection, "G900001", nil)
	h.component(t, collection, "G900002", func(req *bloodbankv1.AddComponentRequest) {
		// Expiring inside the default three-day horizon.
		req.ExpiresAt = timestamppb.New(time.Now().Add(24 * time.Hour))
	})
	h.testAndRelease(t, collection)

	stock, err := h.bank.GetStock(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.GetStockRequest{FacilityId: h.facility}))
	if err != nil {
		t.Fatalf("GetStock: %v", err)
	}
	if len(stock.Msg.GetLevels()) != 1 || stock.Msg.GetLevels()[0].GetAvailable() != 2 {
		t.Fatalf("levels = %+v, want one bucket with 2 available",
			stock.Msg.GetLevels())
	}

	// No threshold configured: the expiry alert only.
	for _, alert := range stock.Msg.GetAlerts() {
		if alert.GetKind() == bloodbankv1.StockAlertKind_STOCK_ALERT_KIND_LOW_STOCK {
			t.Error("a low-stock alert fired for a bucket nobody configured")
		}
	}
	if len(stock.Msg.GetAlerts()) != 1 {
		t.Errorf("alerts = %+v, want one expiry alert", stock.Msg.GetAlerts())
	}

	// A scientist cannot set the threshold; a manager can.
	threshold := &bloodbankv1.StockThreshold{
		ComponentClass: bloodbankv1.ComponentClass_COMPONENT_CLASS_RED_CELLS,
		Group:          oNeg(), Minimum: 6,
	}
	if _, err := h.bank.SetThreshold(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.SetThresholdRequest{
				FacilityId: h.facility, Threshold: threshold,
			})); err == nil {
		t.Fatal("a scientist set a stock threshold")
	}
	if _, err := h.bank.SetThreshold(ctx,
		withFacility(h.managerToken(), h.facility,
			&bloodbankv1.SetThresholdRequest{
				FacilityId: h.facility, Threshold: threshold,
			})); err != nil {
		t.Fatalf("SetThreshold: %v", err)
	}

	stock, err = h.bank.GetStock(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.GetStockRequest{FacilityId: h.facility}))
	if err != nil {
		t.Fatalf("GetStock: %v", err)
	}
	var low *bloodbankv1.StockAlert
	for _, alert := range stock.Msg.GetAlerts() {
		if alert.GetKind() == bloodbankv1.StockAlertKind_STOCK_ALERT_KIND_LOW_STOCK {
			low = alert
		}
	}
	if low == nil {
		t.Fatal("no low-stock alert below the configured minimum")
	}
	if low.GetAvailable() != 2 || low.GetMinimum() != 6 {
		t.Errorf("alert = %+v, want 2 against a minimum of 6", low)
	}
	if !strings.Contains(low.GetMessage(), "O-") {
		t.Errorf("the alert does not name the group: %q", low.GetMessage())
	}
}

// SRS-BLD-002. A deferred donor cannot donate, however the call is made.
func TestADeferredDonorCannotDonate(t *testing.T) {
	h := newBldHarness(t)
	ctx := context.Background()

	donor, err := h.bank.RegisterDonor(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.RegisterDonorRequest{
				DonorNumber: "D-0011", DisplayName: "Priya Nair", Group: oNeg(),
			}))
	if err != nil {
		t.Fatalf("RegisterDonor: %v", err)
	}
	donorID := donor.Msg.GetDonor().GetDonorId()

	screening, err := h.bank.ScreenDonor(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.ScreenDonorRequest{
				DonorId: donorID, Consented: true, Accepted: true,
			}))
	if err != nil {
		t.Fatalf("ScreenDonor: %v", err)
	}

	// A temporary deferral with no end date is refused.
	if _, err := h.bank.DeferDonor(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.DeferDonorRequest{
				DonorId: donorID,
				Kind:    bloodbankv1.DeferralKind_DEFERRAL_KIND_TEMPORARY,
				Code:    "low_hb",
			})); err == nil {
		t.Fatal("a temporary deferral with no end date was accepted")
	}

	if _, err := h.bank.DeferDonor(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.DeferDonorRequest{
				DonorId: donorID,
				Kind:    bloodbankv1.DeferralKind_DEFERRAL_KIND_PERMANENT,
				Code:    "vcjd_risk",
			})); err != nil {
		t.Fatalf("DeferDonor: %v", err)
	}

	if _, err := h.bank.Collect(ctx,
		withFacility(h.scientistToken(), h.facility, &bloodbankv1.CollectRequest{
			DonorId:        donorID,
			ScreeningId:    screening.Msg.GetScreening().GetScreeningId(),
			DonationNumber: "DN-0011", VolumeMl: 450,
		})); err == nil {
		t.Fatal("a permanently deferred donor donated")
	}

	// And a permanent deferral is not lifted at a screening desk.
	if _, err := h.bank.ReinstateDonor(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.ReinstateDonorRequest{
				DonorId: donorID, Reason: "seems fine now",
			})); err == nil {
		t.Fatal("a permanent deferral was lifted")
	}

	deferred, err := h.bank.ListDeferredDonors(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.ListDeferredDonorsRequest{}))
	if err != nil {
		t.Fatalf("ListDeferredDonors: %v", err)
	}
	if len(deferred.Msg.GetDonors()) != 1 {
		t.Fatalf("deferred = %d, want 1", len(deferred.Msg.GetDonors()))
	}
	if !deferred.Msg.GetDonors()[0].GetCurrentlyDeferred() {
		t.Error("a permanently deferred donor does not read as deferred")
	}
}

// SRS-BLD-015. The utilisation report derives from the records.
func TestUtilisationDerivesFromWhatHappened(t *testing.T) {
	h := newBldHarness(t)
	ctx := context.Background()
	patientID := h.patient(t, "George", "+91-99000-66009")

	collection := h.donation(t, "0012")
	componentID := h.component(t, collection, "GA00001", nil)
	h.testAndRelease(t, collection)

	if _, err := h.bank.GroupPatient(ctx,
		withFacility(h.scientistToken(), h.facility,
			&bloodbankv1.GroupPatientRequest{
				PatientId: patientID, SampleNumber: "S0012", Group: oNeg(),
			})); err != nil {
		t.Fatalf("GroupPatient: %v", err)
	}
	placed, err := h.bank.PlaceRequest(ctx,
		withFacility(h.clinicianToken(), h.facility,
			&bloodbankv1.PlaceRequestRequest{
				PatientId:      patientID,
				ComponentClass: bloodbankv1.ComponentClass_COMPONENT_CLASS_RED_CELLS,
				Quantity:       1, Indication: "symptomatic anaemia",
			}))
	if err != nil {
		t.Fatalf("PlaceRequest: %v", err)
	}
	reserved, err := h.bank.Reserve(ctx,
		withFacility(h.scientistToken(), h.facility, &bloodbankv1.ReserveRequest{
			RequestId:   placed.Msg.GetRequest().GetRequestId(),
			ComponentId: componentID, Crossmatched: true,
		}))
	if err != nil {
		t.Fatalf("Reserve: %v", err)
	}
	if _, err := h.bank.IssueUnit(ctx,
		withFacility(h.scientistToken(), h.facility, &bloodbankv1.IssueUnitRequest{
			ComponentId:     componentID,
			ReservationId:   reserved.Msg.GetReservation().GetReservationId(),
			Destination:     "ward 7",
			CheckUnitNumber: "GA00001", CheckPatientId: patientID,
		})); err != nil {
		t.Fatalf("IssueUnit: %v", err)
	}

	report, err := h.bank.GetUtilisation(ctx,
		withFacility(h.haemovigilanceToken(), h.facility,
			&bloodbankv1.GetUtilisationRequest{}))
	if err != nil {
		t.Fatalf("GetUtilisation: %v", err)
	}
	if report.Msg.GetUtilisation().GetIssued() != 1 {
		t.Errorf("issued = %d, want 1", report.Msg.GetUtilisation().GetIssued())
	}
	if report.Msg.GetUtilisation().GetTransfused() != 0 {
		t.Errorf("transfused = %d; a unit that left the fridge has not been "+
			"given yet", report.Msg.GetUtilisation().GetTransfused())
	}
	if report.Msg.GetUtilisation().GetReturned() != 1 {
		t.Errorf("returned = %d, want 1; an issued-and-untransfused unit is "+
			"the number a bank manages down",
			report.Msg.GetUtilisation().GetReturned())
	}

	// Transfuse it, and the report moves.
	check := &bloodbankv1.BedsideCheck{
		UnitNumber: "GA00001", PatientId: patientID,
		PatientGroup: oNeg(), UnitGroup: oNeg(), CheckedWith: "nurse-2",
		Baseline: map[string]float64{"temperature": 36.6, "pulse": 76},
	}
	started, err := h.bank.StartTransfusion(ctx,
		withFacility(h.nurseToken(), h.facility,
			&bloodbankv1.StartTransfusionRequest{Check: check}))
	if err != nil {
		t.Fatalf("StartTransfusion: %v", err)
	}
	if _, err := h.bank.EndTransfusion(ctx,
		withFacility(h.nurseToken(), h.facility,
			&bloodbankv1.EndTransfusionRequest{
				EpisodeId:     started.Msg.GetEpisode().GetEpisodeId(),
				VolumeGivenMl: 280,
			})); err != nil {
		t.Fatalf("EndTransfusion: %v", err)
	}

	report, err = h.bank.GetUtilisation(ctx,
		withFacility(h.haemovigilanceToken(), h.facility,
			&bloodbankv1.GetUtilisationRequest{}))
	if err != nil {
		t.Fatalf("GetUtilisation: %v", err)
	}
	if report.Msg.GetUtilisation().GetTransfused() != 1 {
		t.Errorf("transfused = %d, want 1",
			report.Msg.GetUtilisation().GetTransfused())
	}
	if report.Msg.GetUtilisation().GetCrossmatchToTransfusion() != 1 {
		t.Errorf("C:T = %v, want 1",
			report.Msg.GetUtilisation().GetCrossmatchToTransfusion())
	}
	if report.Msg.GetUtilisation().GetByIndication()["symptomatic anaemia"] != 1 {
		t.Errorf("by indication = %v; a utilisation review reads this",
			report.Msg.GetUtilisation().GetByIndication())
	}
}

// Gate A2. Another tenant reaches none of it.
func TestAnotherTenantSeesNoBloodOverTheWire(t *testing.T) {
	h := newBldHarness(t)
	ctx := context.Background()

	collection := h.donation(t, "0013")
	componentID := h.component(t, collection, "GB00001", nil)

	other := uuid.NewString() + ":scientist-9:blood_bank_scientist:" + h.facility

	if _, err := h.bank.GetComponent(ctx,
		as(other, &bloodbankv1.GetComponentRequest{
			ComponentId: componentID})); err == nil {
		t.Error("another tenant read a unit")
	}
	if _, err := h.bank.GetComponent(ctx,
		as(other, &bloodbankv1.GetComponentRequest{
			UnitNumber: "GB00001"})); err == nil {
		t.Error("another tenant read a unit by its label")
	}
	stock, err := h.bank.GetStock(ctx,
		as(other, &bloodbankv1.GetStockRequest{}))
	if err == nil && len(stock.Msg.GetLevels()) != 0 {
		t.Errorf("another tenant counted %d stock buckets",
			len(stock.Msg.GetLevels()))
	}
}
