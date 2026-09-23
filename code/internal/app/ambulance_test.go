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

	ambulancev1 "github.com/ppusapati/health/code/gen/go/healthcare/ambulance/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/ambulance/v1/ambulancev1connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	ambapp "github.com/ppusapati/health/code/internal/ambulance/application"
	"github.com/ppusapati/health/code/internal/app"
	"github.com/ppusapati/health/code/internal/identity_access/adapters/devauth"
	orgpostgres "github.com/ppusapati/health/code/internal/organization/adapters/postgres"
	orgdomain "github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
	platformapitransport "github.com/ppusapati/health/code/internal/platform_api/transport"
)

// Ambulance and fleet operations (SRS-AMB-001 … 008), end to end.
//
// The domain tests hold the rules and the repository tests hold the schema.
// These hold what only the assembled stack shows: that a vehicle goes on the
// run behind a check somebody else made, that the person who waves a failed
// check through is not the person who made it, that a dispatcher cannot
// override on their own authority, that a crew cannot accept its own
// handover — and, the one this family exists for, that a patient transport
// van is never sent to an emergency however hard anybody tries.

type ambHarness struct {
	pool      *pgxpool.Pool
	ambulance ambulancev1connect.AmbulanceServiceClient
	org       organizationv1connect.OrganizationServiceClient

	tenantID string
	facility string
}

func newAmbHarness(t *testing.T) *ambHarness {
	return newAmbHarnessWith(t, ambapp.Config{})
}

func newAmbHarnessWith(t *testing.T, config ambapp.Config) *ambHarness {
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
		Ambulance: config,
	})
	if built.Err != nil {
		t.Fatalf("app.New: %v", built.Err)
	}

	server := httptest.NewServer(h2c.NewHandler(built.Handler,
		&http2.Server{}))
	t.Cleanup(server.Close)

	h := &ambHarness{
		pool: pool,
		ambulance: ambulancev1connect.NewAmbulanceServiceClient(
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
		as(tenantAdminToken(h.tenantID),
			&organizationv1.CreateFacilityRequest{
				Code: "main", DisplayName: "Main Hospital",
				Type:     organizationv1.FacilityType_FACILITY_TYPE_HOSPITAL,
				TimeZone: "Asia/Kolkata",
			}))
	if err != nil {
		t.Fatalf("CreateFacility: %v", err)
	}
	h.facility = facility.Msg.GetFacility().GetFacilityId()

	for _, module := range []string{"ambulance", "organization"} {
		h.entitleAmb(t, module)
	}
	return h
}

func (h *ambHarness) entitleAmb(t *testing.T, module string) {
	t.Helper()

	repo := orgpostgres.New(pgtx.NewManager(h.pool))
	now := time.Now().UTC()
	entitlement, err := orgdomain.NewEntitlement(uuid.NewString(),
		h.tenantID, "", module, true, now.Add(-time.Hour), time.Time{},
		"setup", now)
	if err != nil {
		t.Fatalf("NewEntitlement: %v", err)
	}
	if err := repo.InsertEntitlement(context.Background(), h.ambScope(),
		entitlement); err != nil {
		t.Fatalf("InsertEntitlement: %v", err)
	}
}

func (h *ambHarness) ambScope() authctx.TenantScope {
	return authctx.NewSession(authctx.Session{
		SubjectID: "setup", TenantID: h.tenantID,
	}).TenantScope()
}

func (h *ambHarness) crewToken() string {
	return h.tenantID + ":crew-1:ambulance_crew:" + h.facility
}

// otherCrewToken is a second crew member on the same vehicle. It exists so
// the two locks can be told apart: the domain refuses whoever made a check
// their own override, and the permission refuses anybody on the crew.
func (h *ambHarness) otherCrewToken() string {
	return h.tenantID + ":crew-2:ambulance_crew:" + h.facility
}

func (h *ambHarness) dispatcherToken() string {
	return h.tenantID + ":disp-1:ambulance_dispatcher:" + h.facility
}

func (h *ambHarness) managerToken() string {
	return h.tenantID + ":mgr-1:ambulance_manager:" + h.facility
}

func (h *ambHarness) telematicsToken() string {
	return h.tenantID + ":box-1:fleet_telematics:" + h.facility
}

func (h *ambHarness) clinicianToken() string {
	return h.tenantID + ":doc-1:clinician:" + h.facility
}

func (h *ambHarness) nurseToken() string {
	return h.tenantID + ":nurse-1:nurse:" + h.facility
}

// vehicle registers an ambulance and leaves it off the run.
func (h *ambHarness) vehicle(t *testing.T, kind ambulancev1.VehicleKind,
	registration string, capabilities ...string) *ambulancev1.Vehicle {

	t.Helper()
	out, err := h.ambulance.RegisterVehicle(context.Background(),
		as(h.managerToken(), &ambulancev1.RegisterVehicleRequest{
			Registration: registration, CallSign: registration,
			Kind: kind, FacilityId: h.facility,
			Capabilities: capabilities,
		}))
	if err != nil {
		t.Fatalf("RegisterVehicle: %v", err)
	}
	return out.Msg.GetVehicle()
}

// check records a passing readiness check against a vehicle.
func (h *ambHarness) check(t *testing.T, vehicleID string,
	defibPresent bool) *ambulancev1.ReadinessCheck {

	t.Helper()
	out, err := h.ambulance.RecordReadinessCheck(context.Background(),
		as(h.crewToken(), &ambulancev1.RecordReadinessCheckRequest{
			VehicleId: vehicleID, FacilityId: h.facility,
			Items: []*ambulancev1.ChecklistItem{
				{Code: "defib", Label: "Defibrillator", Critical: true},
				{Code: "blankets", Label: "Blankets"},
			},
			Outcomes: []*ambulancev1.ItemOutcome{
				{Code: "defib", Present: defibPresent,
					Note: noteWhenAbsent(defibPresent)},
				{Code: "blankets", Present: true},
			},
			OxygenBar: 180, OxygenMinimumBar: 100,
			ValidForSeconds: int32((12 * time.Hour).Seconds()),
		}))
	if err != nil {
		t.Fatalf("RecordReadinessCheck: %v", err)
	}
	return out.Msg.GetCheck()
}

func noteWhenAbsent(present bool) string {
	if present {
		return ""
	}
	return "away for service"
}

// onTheRun registers a vehicle, checks it and puts it on the run with a crew
// on duty.
func (h *ambHarness) onTheRun(t *testing.T, kind ambulancev1.VehicleKind,
	registration string, capabilities ...string) (
	*ambulancev1.Vehicle, *ambulancev1.Shift) {

	t.Helper()
	vehicle := h.vehicle(t, kind, registration, capabilities...)
	check := h.check(t, vehicle.GetVehicleId(), true)

	available, err := h.ambulance.SetVehicleState(context.Background(),
		as(h.managerToken(), &ambulancev1.SetVehicleStateRequest{
			VehicleId: vehicle.GetVehicleId(),
			State:     ambulancev1.VehicleState_VEHICLE_STATE_AVAILABLE,
			CheckId:   check.GetCheckId(), Version: vehicle.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("SetVehicleState: %v", err)
	}

	shift := h.shift(t, vehicle.GetVehicleId())
	return available.Msg.GetVehicle(), shift
}

func (h *ambHarness) shift(t *testing.T, vehicleID string) *ambulancev1.Shift {
	t.Helper()
	now := time.Now().UTC()
	rostered, err := h.ambulance.RosterShift(context.Background(),
		as(h.managerToken(), &ambulancev1.RosterShiftRequest{
			VehicleId: vehicleID, FacilityId: h.facility,
			Crew: []*ambulancev1.CrewMember{
				{SubjectId: "crew-1", DisplayName: "A Paramedic",
					Role:               ambulancev1.CrewRole_CREW_ROLE_PARAMEDIC,
					RegistrationNumber: "P-1"},
				{SubjectId: "crew-2", DisplayName: "A Driver",
					Role: ambulancev1.CrewRole_CREW_ROLE_DRIVER},
			},
			StartsAt: timestamppb.New(now.Add(-time.Hour)),
			EndsAt:   timestamppb.New(now.Add(11 * time.Hour)),
		}))
	if err != nil {
		t.Fatalf("RosterShift: %v", err)
	}
	started, err := h.ambulance.SetShiftState(context.Background(),
		as(h.managerToken(), &ambulancev1.SetShiftStateRequest{
			ShiftId: rostered.Msg.GetShift().GetShiftId(),
			State:   ambulancev1.ShiftState_SHIFT_STATE_ON_DUTY,
			Version: rostered.Msg.GetShift().GetVersion(),
		}))
	if err != nil {
		t.Fatalf("SetShiftState: %v", err)
	}
	return started.Msg.GetShift()
}

func (h *ambHarness) request(t *testing.T, priority ambulancev1.Priority,
	capabilities ...string) *ambulancev1.Request {

	t.Helper()
	out, err := h.ambulance.RaiseRequest(context.Background(),
		as(h.dispatcherToken(), &ambulancev1.RaiseRequestRequest{
			Kind:     ambulancev1.RequestKind_REQUEST_KIND_EMERGENCY,
			Priority: priority, OriginName: "12 Mount Road",
			DestinationFacilityId: h.facility,
			ClinicalNeed:          "chest pain",
			RequiredCapabilities:  capabilities,
		}))
	if err != nil {
		t.Fatalf("RaiseRequest: %v", err)
	}
	return out.Msg.GetRequest()
}

func TestAVehicleGoesOnTheRunOnlyBehindAPassedCheck(t *testing.T) {
	h := newAmbHarness(t)
	ctx := context.Background()

	vehicle := h.vehicle(t, ambulancev1.VehicleKind_VEHICLE_KIND_ALS,
		"KA-01-AB-1234", "monitor")
	// A vehicle that appeared as available the moment somebody typed its
	// plate is one a dispatcher can send before anybody looked inside it.
	if vehicle.GetState() !=
		ambulancev1.VehicleState_VEHICLE_STATE_OUT_OF_SERVICE {
		t.Fatalf("a new vehicle is on the run: %v", vehicle.GetState())
	}

	failed := h.check(t, vehicle.GetVehicleId(), false)
	if failed.GetState() != ambulancev1.CheckState_CHECK_STATE_FAILED ||
		len(failed.GetMissing()) != 1 {
		t.Fatalf("a missing defibrillator passed: %+v", failed)
	}

	_, err := h.ambulance.SetVehicleState(ctx,
		as(h.managerToken(), &ambulancev1.SetVehicleStateRequest{
			VehicleId: vehicle.GetVehicleId(),
			State:     ambulancev1.VehicleState_VEHICLE_STATE_AVAILABLE,
			CheckId:   failed.GetCheckId(), Version: vehicle.GetVersion(),
		}))
	if err == nil {
		t.Fatal("a failed vehicle went on the run")
	}

	// An override is made by somebody other than whoever checked the
	// vehicle, and the crew who did the check does not hold the permission
	// either. Two locks, and this is the one that catches a colleague on
	// the same crew.
	if _, err := h.ambulance.OverrideReadinessCheck(ctx,
		as(h.otherCrewToken(), &ambulancev1.OverrideReadinessCheckRequest{
			CheckId: failed.GetCheckId(), Reason: "no spare vehicle",
			Version: failed.GetVersion(),
		})); err == nil {
		t.Fatal("a second crew member overrode the check")
	}
	// And the manager, who holds the permission, is still refused their own
	// findings if they made them — here they did not, so it goes through.
	overridden, err := h.ambulance.OverrideReadinessCheck(ctx,
		as(h.managerToken(), &ambulancev1.OverrideReadinessCheckRequest{
			CheckId: failed.GetCheckId(),
			Reason:  "no spare vehicle; second defibrillator carried",
			Version: failed.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("OverrideReadinessCheck: %v", err)
	}
	// Its own state rather than a pass, so a readiness report cannot count
	// it as one.
	if overridden.Msg.GetCheck().GetState() !=
		ambulancev1.CheckState_CHECK_STATE_OVERRIDDEN {
		t.Fatalf("the override did not stick: %+v",
			overridden.Msg.GetCheck())
	}

	onRun, err := h.ambulance.SetVehicleState(ctx,
		as(h.managerToken(), &ambulancev1.SetVehicleStateRequest{
			VehicleId: vehicle.GetVehicleId(),
			State:     ambulancev1.VehicleState_VEHICLE_STATE_AVAILABLE,
			CheckId:   failed.GetCheckId(), Version: vehicle.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("SetVehicleState: %v", err)
	}
	if onRun.Msg.GetVehicle().GetReadyUntil() == nil {
		t.Fatal("a vehicle on the run carries no expiry")
	}

	summary, err := h.ambulance.GetReadinessSummary(ctx,
		as(h.managerToken(), &ambulancev1.GetReadinessSummaryRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("GetReadinessSummary: %v", err)
	}
	// A fleet where every check is overridden reads as a fleet that passes
	// every check, unless the two are counted apart.
	got := summary.Msg.GetSummary()
	if got.GetOverridden() != 1 || got.GetPassed() != 0 {
		t.Fatalf("an override was counted as a pass: %+v", got)
	}
	if got.GetMissingByItem()["defib"] != 1 {
		t.Fatalf("the missing item was not counted: %+v",
			got.GetMissingByItem())
	}
}

func TestAVanIsNeverSentToAnEmergencyAndAnOverrideIsNotADispatchersToMake(
	t *testing.T) {

	h := newAmbHarness(t)
	ctx := context.Background()

	van, vanShift := h.onTheRun(t,
		ambulancev1.VehicleKind_VEHICLE_KIND_TRANSPORT, "KA-09-ZZ-9999")
	call := h.request(t, ambulancev1.Priority_PRIORITY_IMMEDIATE)

	// A van with no defibrillator in it does not acquire one because a duty
	// officer typed a sentence.
	_, err := h.ambulance.Dispatch(ctx,
		as(h.dispatcherToken(), &ambulancev1.DispatchRequest{
			RequestId: call.GetRequestId(), VehicleId: van.GetVehicleId(),
			ShiftId: vanShift.GetShiftId(),
		}))
	if err == nil {
		t.Fatal("a transport van was sent to an immediate call")
	}
	_, err = h.ambulance.Dispatch(ctx,
		as(h.managerToken(), &ambulancev1.DispatchRequest{
			RequestId: call.GetRequestId(), VehicleId: van.GetVehicleId(),
			ShiftId:        vanShift.GetShiftId(),
			OverrideReason: "nothing else within twenty minutes",
		}))
	if err == nil {
		t.Fatal("an override sent a transport van to an immediate call")
	}

	// An ALS vehicle off the run is a blocker an override does cover — but
	// not on a dispatcher's own authority.
	als, alsShift := h.onTheRun(t,
		ambulancev1.VehicleKind_VEHICLE_KIND_ALS, "KA-01-AB-1234",
		"monitor")
	offRun, err := h.ambulance.SetVehicleState(ctx,
		as(h.managerToken(), &ambulancev1.SetVehicleStateRequest{
			VehicleId: als.GetVehicleId(),
			State:     ambulancev1.VehicleState_VEHICLE_STATE_OUT_OF_SERVICE,
			Reason:    "brake light", Version: als.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("SetVehicleState: %v", err)
	}
	_ = offRun

	_, err = h.ambulance.Dispatch(ctx,
		as(h.dispatcherToken(), &ambulancev1.DispatchRequest{
			RequestId: call.GetRequestId(), VehicleId: als.GetVehicleId(),
			ShiftId: alsShift.GetShiftId(),
		}))
	if err == nil {
		t.Fatal("an out-of-service vehicle was dispatched")
	}
	// The dispatcher holds amb.dispatch and not amb.dispatch.override, so
	// this is refused for the permission rather than for the rule.
	_, err = h.ambulance.Dispatch(ctx,
		as(h.dispatcherToken(), &ambulancev1.DispatchRequest{
			RequestId: call.GetRequestId(), VehicleId: als.GetVehicleId(),
			ShiftId:        alsShift.GetShiftId(),
			OverrideReason: "nothing else within twenty minutes",
		}))
	if err == nil || !strings.Contains(err.Error(),
		"amb.dispatch.override") {
		t.Fatalf("want a refusal naming the override permission, got %v",
			err)
	}

	// The manager holds the override but not amb.dispatch, so neither of
	// them can do this alone. That is the separation: a vehicle a rule
	// would refuse needs two people.
	_, err = h.ambulance.Dispatch(ctx,
		as(h.managerToken(), &ambulancev1.DispatchRequest{
			RequestId: call.GetRequestId(), VehicleId: als.GetVehicleId(),
			ShiftId:        alsShift.GetShiftId(),
			OverrideReason: "nothing else within twenty minutes",
		}))
	if err == nil || !strings.Contains(err.Error(), "amb.dispatch") {
		t.Fatalf("want a refusal naming the dispatch permission, got %v",
			err)
	}
}

func TestATimelineIsRecordedAndACorrectionKeepsWhatItCorrected(t *testing.T) {
	h := newAmbHarness(t)
	ctx := context.Background()

	vehicle, shift := h.onTheRun(t,
		ambulancev1.VehicleKind_VEHICLE_KIND_ALS, "KA-01-AB-1234",
		"monitor")
	call := h.request(t, ambulancev1.Priority_PRIORITY_IMMEDIATE, "monitor")

	dispatched, err := h.ambulance.Dispatch(ctx,
		as(h.dispatcherToken(), &ambulancev1.DispatchRequest{
			RequestId: call.GetRequestId(),
			VehicleId: vehicle.GetVehicleId(),
			ShiftId:   shift.GetShiftId(),
		}))
	if err != nil {
		t.Fatalf("Dispatch: %v", err)
	}
	trip := dispatched.Msg.GetTrip()
	// The crew who went, pinned at dispatch.
	if len(trip.GetCrewSubjects()) != 2 {
		t.Fatalf("the crew was not pinned: %+v", trip.GetCrewSubjects())
	}

	// The call and the vehicle move with the trip: a request still reading
	// "queued" is one a second dispatcher sends a second vehicle to.
	after, err := h.ambulance.GetRequest(ctx,
		as(h.dispatcherToken(), &ambulancev1.GetRequestRequest{
			RequestId: call.GetRequestId(),
		}))
	if err != nil {
		t.Fatalf("GetRequest: %v", err)
	}
	if after.Msg.GetRequest().GetState() !=
		ambulancev1.RequestState_REQUEST_STATE_ASSIGNED {
		t.Fatalf("the call stayed queued: %v",
			after.Msg.GetRequest().GetState())
	}

	base := time.Now().UTC()
	for _, step := range []struct {
		milestone ambulancev1.Milestone
		minutes   int
	}{
		{ambulancev1.Milestone_MILESTONE_MOBILE, 1},
		{ambulancev1.Milestone_MILESTONE_AT_SCENE, 8},
	} {
		out, err := h.ambulance.RecordTripMilestone(ctx,
			as(h.crewToken(), &ambulancev1.RecordTripMilestoneRequest{
				TripId: trip.GetTripId(), Milestone: step.milestone,
				OccurredAt: timestamppb.New(
					base.Add(time.Duration(step.minutes) * time.Minute)),
				Version: trip.GetVersion(),
			}))
		if err != nil {
			t.Fatalf("RecordTripMilestone %v: %v", step.milestone, err)
		}
		trip = out.Msg.GetTrip()
	}

	// A timeline that accepted "at scene" twice would have two arrival
	// times and one response figure that is whichever the report reached
	// first.
	if _, err := h.ambulance.RecordTripMilestone(ctx,
		as(h.crewToken(), &ambulancev1.RecordTripMilestoneRequest{
			TripId:     trip.GetTripId(),
			Milestone:  ambulancev1.Milestone_MILESTONE_AT_SCENE,
			OccurredAt: timestamppb.New(base.Add(9 * time.Minute)),
			Version:    trip.GetVersion(),
		})); err == nil {
		t.Fatal("a milestone was recorded twice")
	}

	corrected, err := h.ambulance.AmendTripMilestone(ctx,
		as(h.crewToken(), &ambulancev1.AmendTripMilestoneRequest{
			TripId:     trip.GetTripId(),
			Milestone:  ambulancev1.Milestone_MILESTONE_AT_SCENE,
			OccurredAt: timestamppb.New(base.Add(6 * time.Minute)),
			Reason:     "tablet clock was two minutes fast",
		}))
	if err != nil {
		t.Fatalf("AmendTripMilestone: %v", err)
	}

	// "The arrival time was changed after the complaint" is a question
	// somebody asks, and a timeline holding one value per point could not
	// answer it.
	original, amendment := false, false
	for _, record := range corrected.Msg.GetTrip().GetMilestones() {
		if record.GetMilestone() !=
			ambulancev1.Milestone_MILESTONE_AT_SCENE {
			continue
		}
		// Rounded to the second: PostgreSQL keeps microseconds and the
		// test's clock keeps nanoseconds, and the question here is which
		// minute was recorded rather than which nanosecond.
		if record.GetAmendsAt() == nil &&
			record.GetOccurredAt().AsTime().Sub(base).
				Round(time.Second) == 8*time.Minute {
			original = true
		}
		if record.GetAmendsAt() != nil &&
			record.GetAmendReason() != "" &&
			record.GetAmendedAt() != nil {
			amendment = true
		}
	}
	if !original || !amendment {
		t.Fatalf("the correction did not keep what it corrected: %+v",
			corrected.Msg.GetTrip().GetMilestones())
	}
}

func TestACrewCannotAcceptItsOwnHandoverAndAcceptanceAttachesTheRecord(
	t *testing.T) {

	h := newAmbHarness(t)
	ctx := context.Background()

	vehicle, shift := h.onTheRun(t,
		ambulancev1.VehicleKind_VEHICLE_KIND_ALS, "KA-01-AB-1234")
	call := h.request(t, ambulancev1.Priority_PRIORITY_IMMEDIATE)
	dispatched, err := h.ambulance.Dispatch(ctx,
		as(h.dispatcherToken(), &ambulancev1.DispatchRequest{
			RequestId: call.GetRequestId(),
			VehicleId: vehicle.GetVehicleId(),
			ShiftId:   shift.GetShiftId(),
		}))
	if err != nil {
		t.Fatalf("Dispatch: %v", err)
	}
	trip := dispatched.Msg.GetTrip()

	opened, err := h.ambulance.OpenPrehospitalRecord(ctx,
		as(h.crewToken(), &ambulancev1.OpenPrehospitalRecordRequest{
			TripId: trip.GetTripId(), FacilityId: h.facility,
			PresentingComplaint: "chest pain",
			DocumentRefs:        []string{"referral-1"},
		}))
	if err != nil {
		t.Fatalf("OpenPrehospitalRecord: %v", err)
	}
	record := opened.Msg.GetRecord()

	// A driver does not record a drug. The caller is resolved against the
	// crew that went, so this is the domain's rule reaching the wire.
	if _, err := h.ambulance.RecordPrehospitalEntry(ctx,
		as(h.otherCrewToken(),
			&ambulancev1.RecordPrehospitalEntryRequest{
				RecordId: record.GetRecordId(),
				Kind:     ambulancev1.EntryKind_ENTRY_KIND_MEDICATION,
				Code:     "MORPH", DoseAmount: 5, DoseUnit: "mg",
				Route: "iv",
			})); err == nil {
		t.Fatal("a driver recorded a drug")
	}

	entered, err := h.ambulance.RecordPrehospitalEntry(ctx,
		as(h.crewToken(), &ambulancev1.RecordPrehospitalEntryRequest{
			RecordId: record.GetRecordId(),
			Kind:     ambulancev1.EntryKind_ENTRY_KIND_MEDICATION,
			Code:     "ASP", DoseAmount: 300, DoseUnit: "mg",
			Route: "po",
		}))
	if err != nil {
		t.Fatalf("RecordPrehospitalEntry: %v", err)
	}
	record = entered.Msg.GetRecord()
	// The role is pinned at the time: a paramedic who becomes a manager
	// next year still gave that drug as a paramedic.
	if record.GetEntries()[0].GetRecordedRole() !=
		ambulancev1.CrewRole_CREW_ROLE_PARAMEDIC {
		t.Fatalf("the role was not pinned: %+v", record.GetEntries()[0])
	}

	given, err := h.ambulance.GiveHandover(ctx,
		as(h.crewToken(), &ambulancev1.GiveHandoverRequest{
			RecordId:   record.GetRecordId(),
			Summary:    "chest pain, 300mg aspirin, ST elevation on ECG",
			Impression: "ACS", Version: record.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("GiveHandover: %v", err)
	}
	record = given.Msg.GetRecord()

	// A handover accepted by the person who gave it is the same claim made
	// twice, and the crew do not hold the permission either.
	if _, err := h.ambulance.AcceptHandover(ctx,
		as(h.crewToken(), &ambulancev1.AcceptHandoverRequest{
			RecordId:    record.GetRecordId(),
			EncounterId: uuid.NewString(), Version: record.GetVersion(),
		})); err == nil {
		t.Fatal("the crew accepted their own handover")
	}
	// Nor can the driver who was on the same vehicle. The domain refuses
	// whoever gave the handover; this is the other lock, and it is the one
	// that catches the crew taking their own patient off themselves.
	if _, err := h.ambulance.AcceptHandover(ctx,
		as(h.otherCrewToken(), &ambulancev1.AcceptHandoverRequest{
			RecordId:    record.GetRecordId(),
			EncounterId: uuid.NewString(), Version: record.GetVersion(),
		})); err == nil {
		t.Fatal("a second crew member accepted their crew's handover")
	}
	// Nor can a dispatcher, who can see the trip but not the patient.
	if _, err := h.ambulance.AcceptHandover(ctx,
		as(h.dispatcherToken(), &ambulancev1.AcceptHandoverRequest{
			RecordId:    record.GetRecordId(),
			EncounterId: uuid.NewString(), Version: record.GetVersion(),
		})); err == nil {
		t.Fatal("a dispatcher accepted a handover")
	}

	encounterID := uuid.NewString()
	accepted, err := h.ambulance.AcceptHandover(ctx,
		as(h.clinicianToken(), &ambulancev1.AcceptHandoverRequest{
			RecordId: record.GetRecordId(), EncounterId: encounterID,
			Note: "to resus", Version: record.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("AcceptHandover: %v", err)
	}
	// SRS-AMB-004's acceptance: the crew's account attaches to the
	// encounter on arrival.
	if accepted.Msg.GetRecord().GetEncounterId() != encounterID {
		t.Fatalf("the record did not attach: %+v", accepted.Msg.GetRecord())
	}
	if accepted.Msg.GetRecord().GetState() !=
		ambulancev1.HandoverState_HANDOVER_STATE_ACCEPTED {
		t.Fatalf("the handover did not complete: %v",
			accepted.Msg.GetRecord().GetState())
	}
	// The referral travelled as a reference rather than a copy.
	if len(accepted.Msg.GetRecord().GetDocumentRefs()) != 1 {
		t.Fatalf("the transfer document was lost: %+v",
			accepted.Msg.GetRecord().GetDocumentRefs())
	}
}

func TestTheLocationFeedNeedsARetentionPeriodAndItsOwnPermission(
	t *testing.T) {

	h := newAmbHarness(t)
	ctx := context.Background()

	vehicle := h.vehicle(t, ambulancev1.VehicleKind_VEHICLE_KIND_ALS,
		"KA-01-AB-1234")

	// A deployment that has not decided how long it keeps a map of where
	// its ambulances went has not decided the one thing SRS-AMB-005 asks it
	// to decide, and records no feed at all.
	_, err := h.ambulance.RecordPing(ctx,
		as(h.telematicsToken(), &ambulancev1.RecordPingRequest{
			VehicleId:     vehicle.GetVehicleId(),
			LatitudeMicro: 13_082_680, LongitudeMicro: 80_270_718,
			Source: "fleet-telematics",
		}))
	if err == nil {
		t.Fatal("a position was recorded with no retention period")
	}

	configured := newAmbHarnessWith(t, ambapp.Config{
		LocationRetention:  24 * time.Hour,
		PositionStaleAfter: 5 * time.Minute,
	})
	vehicle = configured.vehicle(t,
		ambulancev1.VehicleKind_VEHICLE_KIND_ALS, "KA-01-AB-1234")

	if _, err := configured.ambulance.RecordPing(ctx,
		as(configured.telematicsToken(),
			&ambulancev1.RecordPingRequest{
				VehicleId:     vehicle.GetVehicleId(),
				LatitudeMicro: 13_082_680, LongitudeMicro: 80_270_718,
				SpeedKph: 48, HeadingDegrees: 270,
				Source: "fleet-telematics",
			})); err != nil {
		t.Fatalf("RecordPing: %v", err)
	}

	// The box that writes the feed cannot read it: a box that could ask
	// where every ambulance has been is a box somebody can ask.
	if _, err := configured.ambulance.GetVehiclePosition(ctx,
		as(configured.telematicsToken(),
			&ambulancev1.GetVehiclePositionRequest{
				VehicleId: vehicle.GetVehicleId(),
			})); err == nil {
		t.Fatal("the telematics account read the feed it writes")
	}
	// And a crew cannot read the map of where every other vehicle went.
	if _, err := configured.ambulance.ListPings(ctx,
		as(configured.crewToken(), &ambulancev1.ListPingsRequest{
			VehicleId: vehicle.GetVehicleId(),
		})); err == nil {
		t.Fatal("a crew member read the location trail")
	}

	position, err := configured.ambulance.GetVehiclePosition(ctx,
		as(configured.dispatcherToken(),
			&ambulancev1.GetVehiclePositionRequest{
				VehicleId: vehicle.GetVehicleId(),
			}))
	if err != nil {
		t.Fatalf("GetVehiclePosition: %v", err)
	}
	got := position.Msg.GetPosition()
	if !got.GetKnown() || got.GetLatitudeMicro() != 13_082_680 {
		t.Fatalf("the position did not survive: %+v", got)
	}
	// No provider, so no estimate — reported as unknown rather than as an
	// estimate of zero, which a dispatcher would read as "arriving now".
	if position.Msg.GetEta().GetKnown() {
		t.Fatalf("an estimate appeared with no provider: %+v",
			position.Msg.GetEta())
	}

	// A vehicle with nothing in retention reports that, rather than
	// defaulting to its base.
	other := configured.vehicle(t,
		ambulancev1.VehicleKind_VEHICLE_KIND_BLS, "KA-02-CD-5678")
	absent, err := configured.ambulance.GetVehiclePosition(ctx,
		as(configured.dispatcherToken(),
			&ambulancev1.GetVehiclePositionRequest{
				VehicleId: other.GetVehicleId(),
			}))
	if err != nil {
		t.Fatalf("GetVehiclePosition: %v", err)
	}
	if absent.Msg.GetPosition().GetKnown() {
		t.Fatalf("a vehicle with no feed has a position: %+v",
			absent.Msg.GetPosition())
	}
}

func TestTheQueueIsPriorityThenOldestAndAWardCannotSendTheVehicle(
	t *testing.T) {

	h := newAmbHarness(t)
	ctx := context.Background()

	routine := h.request(t, ambulancev1.Priority_PRIORITY_ROUTINE)
	urgent := h.request(t, ambulancev1.Priority_PRIORITY_URGENT)
	immediate := h.request(t, ambulancev1.Priority_PRIORITY_IMMEDIATE)

	queue, err := h.ambulance.GetDispatchQueue(ctx,
		as(h.dispatcherToken(), &ambulancev1.GetDispatchQueueRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("GetDispatchQueue: %v", err)
	}
	// A queue in arrival order sends the next vehicle to a booked discharge
	// while a cardiac arrest waits.
	order := queue.Msg.GetRequests()
	if len(order) != 3 || order[0].GetRequestId() != immediate.GetRequestId() ||
		order[1].GetRequestId() != urgent.GetRequestId() ||
		order[2].GetRequestId() != routine.GetRequestId() {
		t.Fatalf("the queue is in the wrong order: %+v", order)
	}

	// A ward books the transfer it needs and watches the queue it put the
	// patient in.
	booked, err := h.ambulance.RaiseRequest(ctx,
		as(h.nurseToken(), &ambulancev1.RaiseRequestRequest{
			Kind:             ambulancev1.RequestKind_REQUEST_KIND_DISCHARGE,
			Priority:         ambulancev1.Priority_PRIORITY_ROUTINE,
			OriginFacilityId: h.facility,
			DestinationName:  "home",
			ClinicalNeed:     "stretcher, oxygen",
		}))
	if err != nil {
		t.Fatalf("RaiseRequest: %v", err)
	}

	// A ward that could send the vehicle to its own call is a ward whose
	// patients always go first.
	vehicle, shift := h.onTheRun(t,
		ambulancev1.VehicleKind_VEHICLE_KIND_TRANSPORT, "KA-09-ZZ-9999")
	if _, err := h.ambulance.Dispatch(ctx,
		as(h.nurseToken(), &ambulancev1.DispatchRequest{
			RequestId: booked.Msg.GetRequest().GetRequestId(),
			VehicleId: vehicle.GetVehicleId(),
			ShiftId:   shift.GetShiftId(),
		})); err == nil {
		t.Fatal("a ward dispatched a vehicle to its own call")
	}

	// The cancellation rate is only useful with the reasons beside it.
	if _, err := h.ambulance.CancelRequest(ctx,
		as(h.dispatcherToken(), &ambulancev1.CancelRequestRequest{
			RequestId: routine.GetRequestId(),
			Version:   routine.GetVersion(),
		})); err == nil {
		t.Fatal("a call was cancelled with no reason")
	}
}

func TestTheServiceSummaryComesFromTheMilestonesAndNamesItsGaps(t *testing.T) {
	h := newAmbHarness(t)
	ctx := context.Background()

	base := time.Now().UTC()

	// One complete job.
	complete := h.runTrip(t, "KA-01-AB-1234", base, map[ambulancev1.Milestone]int{
		ambulancev1.Milestone_MILESTONE_MOBILE:         1,
		ambulancev1.Milestone_MILESTONE_AT_SCENE:       7,
		ambulancev1.Milestone_MILESTONE_WITH_PATIENT:   9,
		ambulancev1.Milestone_MILESTONE_LEFT_SCENE:     20,
		ambulancev1.Milestone_MILESTONE_AT_DESTINATION: 35,
		ambulancev1.Milestone_MILESTONE_HANDOVER:       50,
		ambulancev1.Milestone_MILESTONE_CLEAR:          60,
	})

	// And one where the crew never marked themselves at the scene.
	gapped := h.runTrip(t, "KA-02-CD-5678", base,
		map[ambulancev1.Milestone]int{
			ambulancev1.Milestone_MILESTONE_MOBILE:         2,
			ambulancev1.Milestone_MILESTONE_AT_DESTINATION: 40,
			ambulancev1.Milestone_MILESTONE_HANDOVER:       55,
			ambulancev1.Milestone_MILESTONE_CLEAR:          70,
		})

	metrics, err := h.ambulance.GetTripMetrics(ctx,
		as(h.managerToken(), &ambulancev1.GetTripMetricsRequest{
			TripId: complete,
		}))
	if err != nil {
		t.Fatalf("GetTripMetrics: %v", err)
	}
	// The response time is measured from the call, not from the dispatch.
	if !metrics.Msg.GetMetrics().GetResponseKnown() {
		t.Fatalf("the response time is unknown: %+v",
			metrics.Msg.GetMetrics())
	}
	// The number that turns an ambulance into a corridor.
	if metrics.Msg.GetMetrics().GetHandoverSeconds() != 15*60 {
		t.Fatalf("the handover time is wrong: %+v",
			metrics.Msg.GetMetrics())
	}

	gaps, err := h.ambulance.GetTimelineGaps(ctx,
		as(h.dispatcherToken(), &ambulancev1.GetTimelineGapsRequest{
			TripId: gapped,
		}))
	if err != nil {
		t.Fatalf("GetTimelineGaps: %v", err)
	}
	// At the scene, with the patient, and leaving it: three points the crew
	// never marked, reported rather than filled in with a guess.
	if len(gaps.Msg.GetGaps()) != 3 {
		t.Fatalf("want the three missing points, got %+v",
			gaps.Msg.GetGaps())
	}

	summary, err := h.ambulance.GetServiceSummary(ctx,
		as(h.managerToken(), &ambulancev1.GetServiceSummaryRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("GetServiceSummary: %v", err)
	}
	got := summary.Msg.GetSummary()
	if got.GetCompleted() != 2 {
		t.Fatalf("the trips were not counted: %+v", got)
	}
	// A service whose worst calls have incomplete timelines would otherwise
	// report the best response times in the region.
	if got.GetIncompleteTimelines() != 1 {
		t.Fatalf("the gap was not reported: %+v", got)
	}
	// Only the trip that can be measured is in the response figure.
	// About seven minutes: the call was raised a moment before the test's
	// clock reading, and the point is which trip is in the figure rather
	// than the second it lands on.
	mean := got.GetResponse().GetMeanSeconds()
	if got.GetResponse().GetMeasured() != 1 ||
		mean < 7*60-30 || mean > 7*60+30 {
		t.Fatalf("a gap was guessed at: %+v", got.GetResponse())
	}
	// And a crew cannot read the report they appear in.
	if _, err := h.ambulance.GetServiceSummary(ctx,
		as(h.crewToken(), &ambulancev1.GetServiceSummaryRequest{
			FacilityId: h.facility,
		})); err == nil {
		t.Fatal("a crew member read the service report")
	}
}

func TestAStoodDownCallGoesBackInTheQueueAndTheNextVehicleAnswersIt(
	t *testing.T) {

	h := newAmbHarness(t)
	ctx := context.Background()

	first, firstShift := h.onTheRun(t,
		ambulancev1.VehicleKind_VEHICLE_KIND_ALS, "KA-01-AB-1234")
	call := h.request(t, ambulancev1.Priority_PRIORITY_IMMEDIATE)

	dispatched, err := h.ambulance.Dispatch(ctx,
		as(h.dispatcherToken(), &ambulancev1.DispatchRequest{
			RequestId: call.GetRequestId(),
			VehicleId: first.GetVehicleId(),
			ShiftId:   firstShift.GetShiftId(),
		}))
	if err != nil {
		t.Fatalf("Dispatch: %v", err)
	}
	trip := dispatched.Msg.GetTrip()

	// A trip stood down for no recorded reason is a call that looks like an
	// abandonment.
	if _, err := h.ambulance.AbortTrip(ctx,
		as(h.dispatcherToken(), &ambulancev1.AbortTripRequest{
			TripId: trip.GetTripId(), Version: trip.GetVersion(),
		})); err == nil {
		t.Fatal("a trip was aborted with no reason")
	}

	aborted, err := h.ambulance.AbortTrip(ctx,
		as(h.dispatcherToken(), &ambulancev1.AbortTripRequest{
			TripId: trip.GetTripId(), Reason: "vehicle broke down en route",
			Version: trip.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("AbortTrip: %v", err)
	}
	if aborted.Msg.GetTrip().GetState() !=
		ambulancev1.TripState_TRIP_STATE_ABORTED {
		t.Fatalf("the trip did not stand down: %v",
			aborted.Msg.GetTrip().GetState())
	}

	// The patient still needs an ambulance. A request left reading
	// "assigned" is a call that has fallen off the board with nobody going
	// to it.
	queue, err := h.ambulance.GetDispatchQueue(ctx,
		as(h.dispatcherToken(), &ambulancev1.GetDispatchQueueRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("GetDispatchQueue: %v", err)
	}
	if len(queue.Msg.GetRequests()) != 1 ||
		queue.Msg.GetRequests()[0].GetRequestId() != call.GetRequestId() {
		t.Fatalf("the stood-down call is not back in the queue: %+v",
			queue.Msg.GetRequests())
	}

	// And the next vehicle answers it. Both trips are kept: the first one
	// happened, and a report that lost it would show a service that never
	// breaks down.
	second, secondShift := h.onTheRun(t,
		ambulancev1.VehicleKind_VEHICLE_KIND_ALS, "KA-02-CD-5678")
	again, err := h.ambulance.Dispatch(ctx,
		as(h.dispatcherToken(), &ambulancev1.DispatchRequest{
			RequestId: call.GetRequestId(),
			VehicleId: second.GetVehicleId(),
			ShiftId:   secondShift.GetShiftId(),
		}))
	if err != nil {
		t.Fatalf("Dispatch: %v", err)
	}
	if again.Msg.GetTrip().GetTripId() == trip.GetTripId() {
		t.Fatal("the second dispatch reused the first trip")
	}

	trips, err := h.ambulance.ListTrips(ctx,
		as(h.dispatcherToken(), &ambulancev1.ListTripsRequest{
			FacilityId: h.facility,
		}))
	if err != nil {
		t.Fatalf("ListTrips: %v", err)
	}
	if len(trips.Msg.GetTrips()) != 2 {
		t.Fatalf("want both trips kept, got %d", len(trips.Msg.GetTrips()))
	}
}

// dutyOfficerToken is somebody rostered as both a dispatcher and a manager,
// which is how a small service covers a night shift. It exists so the
// override path can be exercised end to end: neither role alone can send a
// vehicle a rule would refuse, and the separation the other test asserts is
// exactly that.
func (h *ambHarness) dutyOfficerToken() string {
	return h.tenantID +
		":duty-1:ambulance_dispatcher,ambulance_manager:" + h.facility
}

func TestAnOverriddenDispatchRaisesANoticeSomebodyHasToAcknowledge(
	t *testing.T) {

	h := newAmbHarness(t)
	ctx := context.Background()

	vehicle, shift := h.onTheRun(t,
		ambulancev1.VehicleKind_VEHICLE_KIND_ALS, "KA-01-AB-1234")
	offRun, err := h.ambulance.SetVehicleState(ctx,
		as(h.managerToken(), &ambulancev1.SetVehicleStateRequest{
			VehicleId: vehicle.GetVehicleId(),
			State:     ambulancev1.VehicleState_VEHICLE_STATE_OUT_OF_SERVICE,
			Reason:    "brake light", Version: vehicle.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("SetVehicleState: %v", err)
	}
	_ = offRun
	call := h.request(t, ambulancev1.Priority_PRIORITY_IMMEDIATE)

	dispatched, err := h.ambulance.Dispatch(ctx,
		as(h.dutyOfficerToken(), &ambulancev1.DispatchRequest{
			RequestId:      call.GetRequestId(),
			VehicleId:      vehicle.GetVehicleId(),
			ShiftId:        shift.GetShiftId(),
			OverrideReason: "nothing else within twenty minutes",
		}))
	if err != nil {
		t.Fatalf("Dispatch: %v", err)
	}
	trip := dispatched.Msg.GetTrip()
	// An override is one thing rather than two flags: a named person and a
	// reason, both recorded on the trip itself.
	if trip.GetOverrideBy() != "duty-1" ||
		trip.GetOverrideReason() == "" {
		t.Fatalf("the override was not recorded: %+v", trip)
	}

	// And it reaches somebody rather than a screen nobody opened.
	var kind, summary string
	if err := h.pool.QueryRow(ctx,
		`SELECT subject_kind, summary
		 FROM platform_escalation.notice
		 WHERE tenant_id = $1 AND subject_id = $2`,
		h.tenantID, trip.GetTripId()).Scan(&kind, &summary); err != nil {
		t.Fatalf("notice: %v", err)
	}
	if kind != "ambulance_dispatch_overridden" {
		t.Fatalf("the wrong notice was raised: %s", kind)
	}
	// The summary names the vehicle and the reason. Never a patient and
	// never an address: a notice goes further and under fewer controls
	// than the record that produced it.
	if !strings.Contains(summary, vehicle.GetVehicleId()) ||
		!strings.Contains(summary, "twenty minutes") {
		t.Fatalf("the notice does not say what happened: %q", summary)
	}
	if strings.Contains(summary, "Mount Road") ||
		strings.Contains(summary, "chest pain") {
		t.Fatalf("the notice carries the call's detail: %q", summary)
	}
}

func TestAHandoverNobodyAcceptedIsEscalatedRatherThanLeftOnAScreen(
	t *testing.T) {

	h := newAmbHarnessWith(t, ambapp.Config{
		HandoverWaitBeforeEscalation: time.Minute,
	})
	ctx := context.Background()

	vehicle, shift := h.onTheRun(t,
		ambulancev1.VehicleKind_VEHICLE_KIND_ALS, "KA-01-AB-1234")
	call := h.request(t, ambulancev1.Priority_PRIORITY_IMMEDIATE)
	dispatched, err := h.ambulance.Dispatch(ctx,
		as(h.dispatcherToken(), &ambulancev1.DispatchRequest{
			RequestId: call.GetRequestId(),
			VehicleId: vehicle.GetVehicleId(),
			ShiftId:   shift.GetShiftId(),
		}))
	if err != nil {
		t.Fatalf("Dispatch: %v", err)
	}

	opened, err := h.ambulance.OpenPrehospitalRecord(ctx,
		as(h.crewToken(), &ambulancev1.OpenPrehospitalRecordRequest{
			TripId:     dispatched.Msg.GetTrip().GetTripId(),
			FacilityId: h.facility, PresentingComplaint: "chest pain",
		}))
	if err != nil {
		t.Fatalf("OpenPrehospitalRecord: %v", err)
	}
	record := opened.Msg.GetRecord()

	entered, err := h.ambulance.RecordPrehospitalEntry(ctx,
		as(h.crewToken(), &ambulancev1.RecordPrehospitalEntryRequest{
			RecordId:  record.GetRecordId(),
			Kind:      ambulancev1.EntryKind_ENTRY_KIND_NOTE,
			Narrative: "walked to the vehicle",
		}))
	if err != nil {
		t.Fatalf("RecordPrehospitalEntry: %v", err)
	}
	record = entered.Msg.GetRecord()

	given, err := h.ambulance.GiveHandover(ctx,
		as(h.crewToken(), &ambulancev1.GiveHandoverRequest{
			RecordId: record.GetRecordId(), Summary: "chest pain",
			Version: record.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("GiveHandover: %v", err)
	}
	record = given.Msg.GetRecord()

	// Nothing is due yet: the crew handed over a moment ago.
	early, err := h.ambulance.SweepWaitingHandovers(ctx,
		as(h.clinicianToken(),
			&ambulancev1.SweepWaitingHandoversRequest{
				FacilityId: h.facility,
			}))
	if err != nil {
		t.Fatalf("SweepWaitingHandovers: %v", err)
	}
	if early.Msg.GetRaised() != 0 {
		t.Fatalf("a fresh handover was escalated: %d",
			early.Msg.GetRaised())
	}

	// Ten minutes later, the crew are still standing in the corridor and
	// the ambulance is not answering calls.
	if _, err := h.pool.Exec(ctx,
		`UPDATE ambulance.prehospital_record
		 SET given_at = given_at - interval '10 minutes'
		 WHERE record_id = $1`, record.GetRecordId()); err != nil {
		t.Fatalf("age the handover: %v", err)
	}

	swept, err := h.ambulance.SweepWaitingHandovers(ctx,
		as(h.clinicianToken(),
			&ambulancev1.SweepWaitingHandoversRequest{
				FacilityId: h.facility,
			}))
	if err != nil {
		t.Fatalf("SweepWaitingHandovers: %v", err)
	}
	if swept.Msg.GetRaised() != 1 {
		t.Fatalf("want one notice raised, got %d", swept.Msg.GetRaised())
	}

	var kind, summary string
	if err := h.pool.QueryRow(ctx,
		`SELECT subject_kind, summary
		 FROM platform_escalation.notice
		 WHERE tenant_id = $1 AND subject_id = $2`,
		h.tenantID, record.GetRecordId()).Scan(&kind,
		&summary); err != nil {
		t.Fatalf("notice: %v", err)
	}
	if kind != "prehospital_handover_waiting" {
		t.Fatalf("the wrong notice was raised: %s", kind)
	}
	// It says how long, which is the number somebody acts on.
	if !strings.Contains(summary, "minutes") {
		t.Fatalf("the notice does not say how long: %q", summary)
	}
	// And a dispatcher, who cannot read the record, cannot run the sweep
	// over it either.
	if _, err := h.ambulance.SweepWaitingHandovers(ctx,
		as(h.dispatcherToken(),
			&ambulancev1.SweepWaitingHandoversRequest{
				FacilityId: h.facility,
			})); err == nil {
		t.Fatal("a dispatcher swept the handover worklist")
	}
}

// runTrip dispatches a vehicle to a fresh call and records the milestones
// given, returning the trip identifier.
func (h *ambHarness) runTrip(t *testing.T, registration string,
	base time.Time, offsets map[ambulancev1.Milestone]int) string {

	t.Helper()
	ctx := context.Background()

	vehicle, shift := h.onTheRun(t,
		ambulancev1.VehicleKind_VEHICLE_KIND_ALS, registration)
	call := h.request(t, ambulancev1.Priority_PRIORITY_IMMEDIATE)

	dispatched, err := h.ambulance.Dispatch(ctx,
		as(h.dispatcherToken(), &ambulancev1.DispatchRequest{
			RequestId: call.GetRequestId(),
			VehicleId: vehicle.GetVehicleId(),
			ShiftId:   shift.GetShiftId(),
		}))
	if err != nil {
		t.Fatalf("Dispatch: %v", err)
	}
	trip := dispatched.Msg.GetTrip()

	for _, milestone := range []ambulancev1.Milestone{
		ambulancev1.Milestone_MILESTONE_MOBILE,
		ambulancev1.Milestone_MILESTONE_AT_SCENE,
		ambulancev1.Milestone_MILESTONE_WITH_PATIENT,
		ambulancev1.Milestone_MILESTONE_LEFT_SCENE,
		ambulancev1.Milestone_MILESTONE_AT_DESTINATION,
		ambulancev1.Milestone_MILESTONE_HANDOVER,
		ambulancev1.Milestone_MILESTONE_CLEAR,
	} {
		minutes, ok := offsets[milestone]
		if !ok {
			continue
		}
		out, err := h.ambulance.RecordTripMilestone(ctx,
			as(h.crewToken(), &ambulancev1.RecordTripMilestoneRequest{
				TripId: trip.GetTripId(), Milestone: milestone,
				OccurredAt: timestamppb.New(
					base.Add(time.Duration(minutes) * time.Minute)),
				Version: trip.GetVersion(),
			}))
		if err != nil {
			t.Fatalf("RecordTripMilestone %v: %v", milestone, err)
		}
		trip = out.Msg.GetTrip()
	}
	return trip.GetTripId()
}
