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

	facilitiesv1 "github.com/ppusapati/health/code/gen/go/healthcare/facilities/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/facilities/v1/facilitiesv1connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	"github.com/ppusapati/health/code/internal/app"
	facapp "github.com/ppusapati/health/code/internal/facilities/application"
	"github.com/ppusapati/health/code/internal/identity_access/adapters/devauth"
	orgpostgres "github.com/ppusapati/health/code/internal/organization/adapters/postgres"
	orgdomain "github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
	platformapitransport "github.com/ppusapati/health/code/internal/platform_api/transport"
)

// Facilities engineering operations (SRS-FAC-001 … 011), end to end.
//
// The domain tests hold the rules and the repository tests hold the schema.
// These hold what only the assembled stack shows: that the engineer who did
// the work cannot sign it off, that permit work needs a second permission as
// well as a permit number, that a shutdown cannot take the theatre's power
// away until the theatre has answered, that an alarm and the work it caused
// have separate lives, and that a fire watch does not take a blocked
// stairwell off the list.

type facHarness struct {
	pool       *pgxpool.Pool
	facilities facilitiesv1connect.FacilitiesServiceClient
	org        organizationv1connect.OrganizationServiceClient

	tenantID string
	facility string
}

func newFacHarness(t *testing.T) *facHarness {
	return newFacHarnessWith(t, facapp.Config{})
}

func newFacHarnessWith(t *testing.T, config facapp.Config) *facHarness {
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
		Facilities: config,
	})
	if built.Err != nil {
		t.Fatalf("app.New: %v", built.Err)
	}

	server := httptest.NewServer(h2c.NewHandler(built.Handler,
		&http2.Server{}))
	t.Cleanup(server.Close)

	h := &facHarness{
		pool: pool,
		facilities: facilitiesv1connect.NewFacilitiesServiceClient(
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

	for _, module := range []string{"facilities", "organization"} {
		h.entitleFac(t, module)
	}
	return h
}

func (h *facHarness) entitleFac(t *testing.T, module string) {
	t.Helper()

	repo := orgpostgres.New(pgtx.NewManager(h.pool))
	now := time.Now().UTC()
	entitlement, err := orgdomain.NewEntitlement(uuid.NewString(),
		h.tenantID, "", module, true, now.Add(-time.Hour), time.Time{},
		"setup", now)
	if err != nil {
		t.Fatalf("NewEntitlement: %v", err)
	}
	if err := repo.InsertEntitlement(context.Background(), h.facScope(),
		entitlement); err != nil {
		t.Fatalf("InsertEntitlement: %v", err)
	}
}

func (h *facHarness) facScope() authctx.TenantScope {
	return authctx.NewSession(authctx.Session{
		SubjectID: "setup", TenantID: h.tenantID,
	}).TenantScope()
}

func (h *facHarness) technicianToken() string {
	return h.tenantID + ":fac-tech-1:facilities_technician:" + h.facility
}

// otherTechnicianToken is a second engineer. It exists so two locks can be
// told apart: the domain refuses somebody signing off their own work, and the
// permissions refuse an engineer from signing off anybody's.
func (h *facHarness) otherTechnicianToken() string {
	return h.tenantID + ":fac-tech-2:facilities_technician:" + h.facility
}

func (h *facHarness) managerToken() string {
	return h.tenantID + ":fac-mgr-1:facilities_manager:" + h.facility
}

func (h *facHarness) otherManagerToken() string {
	return h.tenantID + ":fac-mgr-2:facilities_manager:" + h.facility
}

func (h *facHarness) fireOfficerToken() string {
	return h.tenantID + ":fire-1:fire_safety_officer:" + h.facility
}

func (h *facHarness) otherFireOfficerToken() string {
	return h.tenantID + ":fire-2:fire_safety_officer:" + h.facility
}

func (h *facHarness) gatewayToken() string {
	return h.tenantID + ":gw-plant-1:plant_gateway:" + h.facility
}

func (h *facHarness) wardManagerToken() string {
	return h.tenantID + ":ward-mgr-1:nurse_manager:" + h.facility
}

// setUpClasses configures one ordinary class and one that needs a permit.
func (h *facHarness) setUpClasses(t *testing.T) {
	t.Helper()
	ctx := context.Background()

	if _, err := h.facilities.SetWorkClass(ctx,
		as(h.managerToken(), &facilitiesv1.SetWorkClassRequest{
			Code: "general", Name: "General maintenance", Active: true,
		})); err != nil {
		t.Fatalf("SetWorkClass(general): %v", err)
	}
	if _, err := h.facilities.SetWorkClass(ctx,
		as(h.managerToken(), &facilitiesv1.SetWorkClassRequest{
			Code: "hv_switching", Name: "HV switching",
			RequiresPermit: true, RequiresLoto: true, Active: true,
			Note: "11kV switchgear; after the 2024 arc flash",
		})); err != nil {
		t.Fatalf("SetWorkClass(hv_switching): %v", err)
	}
}

func (h *facHarness) registerAsset(t *testing.T, tag string,
	system facilitiesv1.System,
	criticality facilitiesv1.Criticality) *facilitiesv1.Asset {

	t.Helper()
	got, err := h.facilities.RegisterAsset(context.Background(),
		as(h.managerToken(), &facilitiesv1.RegisterAssetRequest{
			Tag: tag, Name: "Asset " + tag, System: system,
			Criticality: criticality, FacilityId: h.facility,
			LocationNote: "plant room",
		}))
	if err != nil {
		t.Fatalf("RegisterAsset(%s): %v", tag, err)
	}
	return got.Msg.GetAsset()
}

func (h *facHarness) raiseWork(t *testing.T, token, classCode string,
	mutate func(*facilitiesv1.RaiseWorkRequest)) *facilitiesv1.WorkOrder {

	t.Helper()
	req := &facilitiesv1.RaiseWorkRequest{
		FacilityId:   h.facility,
		System:       facilitiesv1.System_SYSTEM_HVAC,
		LocationNote: "theatre 2",
		Fault:        "AHU-OT-1 tripping on overload",
		Impact:       "theatre 2 cannot be used",
		Priority:     facilitiesv1.Priority_PRIORITY_URGENT,
		ClassCode:    classCode,
	}
	if mutate != nil {
		mutate(req)
	}
	got, err := h.facilities.RaiseWork(context.Background(),
		as(token, req))
	if err != nil {
		t.Fatalf("RaiseWork: %v", err)
	}
	return got.Msg.GetWorkOrder()
}

// SRS-FAC-001, SRS-FAC-002: a ward reports a fault and it arrives routed,
// deadlined and owned by somebody.
func TestAWardReportsAFaultAndItArrivesWithAnOwnerAndADeadline(t *testing.T) {
	h := newFacHarness(t)
	h.setUpClasses(t)
	ctx := context.Background()

	// A nurse can report a leak. Anybody who can see one should be able
	// to, which is why the ticket records impact rather than assuming it.
	order := h.raiseWork(t, h.wardManagerToken(), "general", nil)

	if order.GetOwnerTeam() == "" {
		t.Fatal("SRS-FAC-002: a ticket receives an owner")
	}
	if order.GetRespondBy() == nil || order.GetResolveBy() == nil {
		t.Fatalf("SRS-FAC-002: a ticket receives an SLA: %+v", order)
	}
	if order.GetNumber() == "" {
		t.Fatal("and a number a ward can quote on the phone")
	}

	// It shows up on the worklist for the team that owns it.
	list, err := h.facilities.GetWorklist(ctx,
		as(h.technicianToken(), &facilitiesv1.GetWorklistRequest{
			FacilityId: h.facility}))
	if err != nil {
		t.Fatalf("GetWorklist: %v", err)
	}
	if len(list.Msg.GetWorkOrders()) != 1 {
		t.Fatalf("the ticket is on the worklist, got %d",
			len(list.Msg.GetWorkOrders()))
	}
}

// SRS-FAC-002: the engineer who did the work does not sign it off.
func TestTheEngineerWhoDidTheWorkCannotSignItOff(t *testing.T) {
	h := newFacHarness(t)
	h.setUpClasses(t)
	ctx := context.Background()

	order := h.raiseWork(t, h.wardManagerToken(), "general", nil)

	assigned, err := h.facilities.AssignWork(ctx,
		as(h.technicianToken(), &facilitiesv1.AssignWorkRequest{
			WorkOrderId: order.GetWorkOrderId(),
			UserId:      "fac-tech-1",
		}))
	if err != nil {
		t.Fatalf("AssignWork: %v", err)
	}
	if assigned.Msg.GetWorkOrder().GetRespondedAt() == nil {
		// A ticket somebody picked up has been answered. Without this
		// the response clock runs until somebody presses a second
		// button that nobody knows about.
		t.Fatal("assignment answers the ticket")
	}

	if _, err := h.facilities.StartWork(ctx,
		as(h.technicianToken(), &facilitiesv1.StartWorkRequest{
			WorkOrderId: order.GetWorkOrderId()})); err != nil {
		t.Fatalf("StartWork: %v", err)
	}
	if _, err := h.facilities.ResolveWork(ctx,
		as(h.technicianToken(), &facilitiesv1.ResolveWorkRequest{
			WorkOrderId:     order.GetWorkOrderId(),
			Note:            "replaced the overload relay",
			RootCause:       "relay aged",
			DowntimeMinutes: 95,
		})); err != nil {
		t.Fatalf("ResolveWork: %v", err)
	}

	// The engineer holds no fac.work.close at all.
	_, err = h.facilities.CloseWork(ctx,
		as(h.technicianToken(), &facilitiesv1.CloseWorkRequest{
			WorkOrderId: order.GetWorkOrderId()}))
	if err == nil || !strings.Contains(err.Error(), "fac.work.close") {
		t.Fatalf("want a refusal naming fac.work.close, got %v", err)
	}

	// And even a manager who had done the work would be refused, which is
	// the domain's half of the same rule.
	if _, err := h.facilities.AssignWork(ctx,
		as(h.managerToken(), &facilitiesv1.AssignWorkRequest{
			WorkOrderId: order.GetWorkOrderId(),
			UserId:      "fac-mgr-1",
		})); err != nil {
		t.Fatalf("AssignWork(manager): %v", err)
	}
	_, err = h.facilities.CloseWork(ctx,
		as(h.managerToken(), &facilitiesv1.CloseWorkRequest{
			WorkOrderId: order.GetWorkOrderId()}))
	if err == nil || !strings.Contains(err.Error(), "other than fac-mgr-1") {
		t.Fatalf("want a refusal naming the worker, got %v", err)
	}

	// A second manager signs it off.
	closed, err := h.facilities.CloseWork(ctx,
		as(h.otherManagerToken(), &facilitiesv1.CloseWorkRequest{
			WorkOrderId: order.GetWorkOrderId()}))
	if err != nil {
		t.Fatalf("CloseWork: %v", err)
	}
	if closed.Msg.GetWorkOrder().GetState() !=
		facilitiesv1.WorkState_WORK_STATE_CLOSED {
		t.Fatalf("the work is closed: %+v", closed.Msg.GetWorkOrder())
	}
}

// SRS-FAC-010: unsafe work does not start without its permit, and starting it
// needs a permission the engineer does not have.
func TestPermitWorkNeedsBothThePaperworkAndThePermission(t *testing.T) {
	h := newFacHarness(t)
	h.setUpClasses(t)
	ctx := context.Background()

	order := h.raiseWork(t, h.managerToken(), "hv_switching",
		func(r *facilitiesv1.RaiseWorkRequest) {
			r.System = facilitiesv1.System_SYSTEM_ELECTRICAL
			r.Fault = "LV panel 3 busbar hot joint"
			r.Impact = "ward 5 on one supply"
		})
	if !order.GetClassRequiresPermit() || !order.GetClassRequiresLoto() {
		t.Fatalf("the order carries its class's flags: %+v", order)
	}

	if _, err := h.facilities.AssignWork(ctx,
		as(h.technicianToken(), &facilitiesv1.AssignWorkRequest{
			WorkOrderId: order.GetWorkOrderId(),
			UserId:      "fac-tech-1"})); err != nil {
		t.Fatalf("AssignWork: %v", err)
	}

	// The engineer has the permit numbers and not the permission.
	_, err := h.facilities.StartWork(ctx,
		as(h.technicianToken(), &facilitiesv1.StartWorkRequest{
			WorkOrderId: order.GetWorkOrderId(),
			PermitRef:   "PTW-77", PermitIssuedBy: "u-auth",
			LotoRef: "LOTO-9", LotoAppliedBy: "fac-tech-1",
		}))
	if err == nil || !strings.Contains(err.Error(), "fac.permit") {
		t.Fatalf("want a refusal naming fac.permit, got %v", err)
	}

	// The manager has the permission and no permit number.
	_, err = h.facilities.StartWork(ctx,
		as(h.managerToken(), &facilitiesv1.StartWorkRequest{
			WorkOrderId: order.GetWorkOrderId(),
			LotoRef:     "LOTO-9", LotoAppliedBy: "fac-tech-1",
		}))
	if err == nil ||
		!strings.Contains(err.Error(), "without a permit to work") {
		t.Fatalf("want a refusal naming the permit, got %v", err)
	}

	// And no isolation.
	_, err = h.facilities.StartWork(ctx,
		as(h.managerToken(), &facilitiesv1.StartWorkRequest{
			WorkOrderId: order.GetWorkOrderId(),
			PermitRef:   "PTW-77", PermitIssuedBy: "u-auth",
		}))
	if err == nil ||
		!strings.Contains(err.Error(), "lockout-tagout") {
		t.Fatalf("want a refusal naming the isolation, got %v", err)
	}

	started, err := h.facilities.StartWork(ctx,
		as(h.managerToken(), &facilitiesv1.StartWorkRequest{
			WorkOrderId: order.GetWorkOrderId(),
			PermitRef:   "PTW-77", PermitIssuedBy: "u-auth",
			LotoRef: "LOTO-9", LotoAppliedBy: "fac-tech-1",
		}))
	if err != nil {
		t.Fatalf("StartWork: %v", err)
	}
	if started.Msg.GetWorkOrder().GetPermitRef() != "PTW-77" ||
		started.Msg.GetWorkOrder().GetLotoRef() != "LOTO-9" {
		t.Fatalf("the references are kept: %+v",
			started.Msg.GetWorkOrder())
	}
}

// SRS-FAC-004: the supply does not go off until the theatre has answered.
func TestAShutdownWaitsForTheDepartmentItWillReach(t *testing.T) {
	h := newFacHarness(t)
	ctx := context.Background()

	from := time.Now().UTC().Add(7 * 24 * time.Hour)
	planned, err := h.facilities.PlanOutage(ctx,
		as(h.technicianToken(), &facilitiesv1.PlanOutageRequest{
			Reference: "SD-2026-031", FacilityId: h.facility,
			System:      facilitiesv1.System_SYSTEM_ELECTRICAL,
			Title:       "LV panel 3 maintenance shutdown",
			Reason:      "thermographic survey found a hot joint",
			PlannedFrom: timestamppb.New(from),
			PlannedTo:   timestamppb.New(from.Add(4 * time.Hour)),
			Contingency: "ward 5 on the UPS ring",
			Areas: []*facilitiesv1.AreaInput{
				{Name: "Ward 5", Critical: false},
				{Name: "Theatres", Critical: true},
			},
		}))
	if err != nil {
		t.Fatalf("PlanOutage: %v", err)
	}
	outage := planned.Msg.GetOutage()
	if len(planned.Msg.GetAreas()) != 2 {
		t.Fatalf("both departments are declared: %+v", planned.Msg)
	}

	// The engineer who wants the shutdown does not sign it.
	_, err = h.facilities.ApproveOutage(ctx,
		as(h.technicianToken(), &facilitiesv1.ApproveOutageRequest{
			OutageId: outage.GetOutageId(), PermitRef: "PTW-12"}))
	if err == nil || !strings.Contains(err.Error(), "fac.outage.approve") {
		t.Fatalf("want a refusal naming fac.outage.approve, got %v", err)
	}

	approved, err := h.facilities.ApproveOutage(ctx,
		as(h.managerToken(), &facilitiesv1.ApproveOutageRequest{
			OutageId: outage.GetOutageId(), PermitRef: "PTW-12"}))
	if err != nil {
		t.Fatalf("ApproveOutage: %v", err)
	}
	// SRS-FAC-004's acceptance: approving notifies the impacted
	// departments, in the same call.
	var theatres *facilitiesv1.OutageArea
	for _, area := range approved.Msg.GetAreas() {
		if area.GetNotifiedAt() == nil {
			t.Fatalf("every declared area is notified: %+v", area)
		}
		if area.GetCritical() {
			theatres = area
		}
	}
	if theatres == nil {
		t.Fatal("the critical area survives the approval")
	}

	// And the power stays on until theatres answer.
	_, err = h.facilities.StartOutage(ctx,
		as(h.managerToken(), &facilitiesv1.StartOutageRequest{
			OutageId: outage.GetOutageId()}))
	if err == nil ||
		!strings.Contains(err.Error(), "Theatres has not acknowledged") {
		t.Fatalf("want a refusal naming theatres, got %v", err)
	}

	// The ward manager answers for their own department. Estates cannot
	// answer on their behalf: that is the notification not happening.
	_, err = h.facilities.AcknowledgeOutage(ctx,
		as(h.managerToken(), &facilitiesv1.AcknowledgeOutageRequest{
			OutageId: outage.GetOutageId(),
			AreaId:   theatres.GetAreaId()}))
	if err == nil ||
		!strings.Contains(err.Error(), "fac.outage.acknowledge") {
		t.Fatalf("want a refusal naming fac.outage.acknowledge, got %v",
			err)
	}

	if _, err := h.facilities.AcknowledgeOutage(ctx,
		as(h.wardManagerToken(), &facilitiesv1.AcknowledgeOutageRequest{
			OutageId:  outage.GetOutageId(),
			AreaId:    theatres.GetAreaId(),
			Objection: "we lose the drug fridge on that circuit",
		})); err != nil {
		t.Fatalf("AcknowledgeOutage: %v", err)
	}

	live, err := h.facilities.StartOutage(ctx,
		as(h.managerToken(), &facilitiesv1.StartOutageRequest{
			OutageId: outage.GetOutageId()}))
	if err != nil {
		t.Fatalf("StartOutage: %v", err)
	}
	if live.Msg.GetOutage().GetState() !=
		facilitiesv1.OutageState_OUTAGE_STATE_IN_EFFECT {
		t.Fatalf("the supply is off: %+v", live.Msg.GetOutage())
	}

	// The objection is on the record, which is what changes the
	// conversation afterwards.
	read, err := h.facilities.GetOutage(ctx,
		as(h.managerToken(), &facilitiesv1.GetOutageRequest{
			OutageId: outage.GetOutageId()}))
	if err != nil {
		t.Fatalf("GetOutage: %v", err)
	}
	var objected bool
	for _, area := range read.Msg.GetAreas() {
		if area.GetObjection() != "" {
			objected = true
		}
		// And every area row followed the outage into effect.
		if area.GetAcknowledgedAt() == nil && area.GetCritical() {
			t.Fatalf("the critical area answered: %+v", area)
		}
	}
	if !objected {
		t.Fatal("the ward's objection is kept")
	}
}

// SRS-FAC-005: an alarm raises work when configured, and the two lifecycles
// stay linked but distinct.
func TestAnAlarmRaisesWorkAndTheTwoStayDistinct(t *testing.T) {
	h := newFacHarness(t)
	h.setUpClasses(t)
	ctx := context.Background()

	asset := h.registerAsset(t, "VIE-1",
		facilitiesv1.System_SYSTEM_MEDICAL_GAS,
		facilitiesv1.Criticality_CRITICALITY_LIFE)

	// Nothing configured: the alarm is recorded and raises nothing. A
	// hospital that wired every state change to a ticket would produce a
	// thousand a week and read none of them.
	quiet, err := h.facilities.IngestAlarm(ctx,
		as(h.gatewayToken(), h.alarmRequest("evt-1", asset.GetAssetId())))
	if err != nil {
		t.Fatalf("IngestAlarm: %v", err)
	}
	if quiet.Msg.GetRaisedWork() {
		t.Fatal("no rule means no ticket")
	}

	if _, err := h.facilities.SetAlarmRule(ctx,
		as(h.managerToken(), &facilitiesv1.SetAlarmRuleRequest{
			FacilityId:  h.facility,
			System:      facilitiesv1.System_SYSTEM_MEDICAL_GAS,
			MinSeverity: facilitiesv1.Severity_SEVERITY_MAJOR,
			Priority:    facilitiesv1.Priority_PRIORITY_EMERGENCY,
			ClassCode:   "general", OwnerTeam: "estates-gas",
			Active: true,
		})); err != nil {
		t.Fatalf("SetAlarmRule: %v", err)
	}

	got, err := h.facilities.IngestAlarm(ctx,
		as(h.gatewayToken(), h.alarmRequest("evt-2", asset.GetAssetId())))
	if err != nil {
		t.Fatalf("IngestAlarm: %v", err)
	}
	if !got.Msg.GetRaisedWork() {
		t.Fatalf("the configured rule raises a ticket: %+v", got.Msg)
	}
	alarm := got.Msg.GetAlarm()
	order := got.Msg.GetWorkOrder()
	if alarm.GetWorkOrderId() != order.GetWorkOrderId() {
		t.Fatal("and links the two")
	}
	if order.GetOwnerTeam() != "estates-gas" {
		t.Fatalf("the rule routes the ticket: %+v", order)
	}
	if !strings.Contains(order.GetImpact(), "not yet assessed") {
		// A generated ticket claiming somebody assessed the impact is
		// worse than one admitting it is a transcription.
		t.Fatalf("the generated impact is honest: %q", order.GetImpact())
	}

	// A replayed gateway buffer does not produce a second alarm or a
	// second call-out.
	replay, err := h.facilities.IngestAlarm(ctx,
		as(h.gatewayToken(), h.alarmRequest("evt-2", asset.GetAssetId())))
	if err != nil {
		t.Fatalf("IngestAlarm(replay): %v", err)
	}
	if !replay.Msg.GetDuplicate() ||
		replay.Msg.GetAlarm().GetAlarmId() != alarm.GetAlarmId() {
		t.Fatalf("a replay is recognised: %+v", replay.Msg)
	}

	// Close the work: the alarm is untouched.
	h.driveToClosed(t, order.GetWorkOrderId())
	after, err := h.facilities.ListAlarms(ctx,
		as(h.technicianToken(), &facilitiesv1.ListAlarmsRequest{
			FacilityId: h.facility}))
	if err != nil {
		t.Fatalf("ListAlarms: %v", err)
	}
	for _, a := range after.Msg.GetAlarms() {
		if a.GetAlarmId() != alarm.GetAlarmId() {
			continue
		}
		if a.GetState() != facilitiesv1.AlarmState_ALARM_STATE_ACTIVE {
			t.Fatal("closing the work order must not clear the alarm")
		}
	}

	// Clear the alarm: the work order is untouched.
	cleared, err := h.facilities.ClearAlarm(ctx,
		as(h.technicianToken(), &facilitiesv1.ClearAlarmRequest{
			AlarmId: alarm.GetAlarmId()}))
	if err != nil {
		t.Fatalf("ClearAlarm: %v", err)
	}
	if cleared.Msg.GetAlarm().GetWorkOrderId() != order.GetWorkOrderId() {
		t.Fatal("and the link survives both")
	}

	// A cleared alarm can still be acknowledged: a dip at 3am that
	// cleared itself still needs somebody to have looked at it.
	if _, err := h.facilities.AcknowledgeAlarm(ctx,
		as(h.technicianToken(), &facilitiesv1.AcknowledgeAlarmRequest{
			AlarmId: alarm.GetAlarmId()})); err != nil {
		t.Fatalf("AcknowledgeAlarm: %v", err)
	}

	// And a person cannot type an alarm at all.
	_, err = h.facilities.IngestAlarm(ctx,
		as(h.managerToken(), h.alarmRequest("evt-3", asset.GetAssetId())))
	if err == nil || !strings.Contains(err.Error(), "fac.alarm.ingest") {
		t.Fatalf("want a refusal naming fac.alarm.ingest, got %v", err)
	}
}

func (h *facHarness) alarmRequest(externalID,
	assetID string) *facilitiesv1.IngestAlarmRequest {

	return &facilitiesv1.IngestAlarmRequest{
		GatewayId: "gw-plant-1", PointRef: "MGP.VIE1.LowPressure",
		ExternalId: externalID, AssetId: assetID,
		FacilityId: h.facility,
		System:     facilitiesv1.System_SYSTEM_MEDICAL_GAS,
		Severity:   facilitiesv1.Severity_SEVERITY_CRITICAL,
		Message:    "VIE 1 low pressure alarm",
		Source:     facilitiesv1.Source_SOURCE_SCADA,
		RaisedAt:   timestamppb.New(time.Now().UTC().Add(-time.Minute)),
	}
}

// driveToClosed takes a work order all the way through, using two people.
func (h *facHarness) driveToClosed(t *testing.T, workOrderID string) {
	t.Helper()
	ctx := context.Background()

	if _, err := h.facilities.AssignWork(ctx,
		as(h.technicianToken(), &facilitiesv1.AssignWorkRequest{
			WorkOrderId: workOrderID, UserId: "fac-tech-1"})); err != nil {
		t.Fatalf("AssignWork: %v", err)
	}
	if _, err := h.facilities.StartWork(ctx,
		as(h.technicianToken(), &facilitiesv1.StartWorkRequest{
			WorkOrderId: workOrderID})); err != nil {
		t.Fatalf("StartWork: %v", err)
	}
	if _, err := h.facilities.ResolveWork(ctx,
		as(h.technicianToken(), &facilitiesv1.ResolveWorkRequest{
			WorkOrderId: workOrderID, Note: "changed the regulator",
			DowntimeMinutes: 40})); err != nil {
		t.Fatalf("ResolveWork: %v", err)
	}
	if _, err := h.facilities.CloseWork(ctx,
		as(h.managerToken(), &facilitiesv1.CloseWorkRequest{
			WorkOrderId: workOrderID})); err != nil {
		t.Fatalf("CloseWork: %v", err)
	}
}

// SRS-FAC-008: a fire watch does not take a blocked stairwell off the list.
func TestACriticalDeficiencyStaysVisibleUntilSomebodyFixesIt(t *testing.T) {
	h := newFacHarness(t)
	h.setUpClasses(t)
	ctx := context.Background()

	due := time.Now().UTC().Add(7 * 24 * time.Hour)
	raised, err := h.facilities.RaiseDeficiency(ctx,
		as(h.fireOfficerToken(), &facilitiesv1.RaiseDeficiencyRequest{
			FacilityId:   h.facility,
			LocationNote: "stair core B, level 3",
			System:       facilitiesv1.System_SYSTEM_FIRE,
			Severity:     facilitiesv1.Severity_SEVERITY_CRITICAL,
			Finding:      "fire door wedged open, self-closer disconnected",
			Standard:     "NFPA 101 7.2.1.8",
			DueAt:        timestamppb.New(due),
			ClassCode:    "general",
		}))
	if err != nil {
		t.Fatalf("RaiseDeficiency: %v", err)
	}
	// A critical finding that is only a note is one nobody is assigned
	// to, so the service raises the work rather than making the inspector
	// fill in a second form.
	if !raised.Msg.GetRaisedWork() {
		t.Fatalf("a critical finding gets work raised: %+v", raised.Msg)
	}
	deficiency := raised.Msg.GetDeficiency()
	if deficiency.GetWorkOrderId() == "" {
		t.Fatal("and the finding names it")
	}

	// A fire watch is posted. It is not a repair.
	if _, err := h.facilities.MitigateDeficiency(ctx,
		as(h.fireOfficerToken(),
			&facilitiesv1.MitigateDeficiencyRequest{
				DeficiencyId: deficiency.GetDeficiencyId(),
				Note:         "fire watch posted on level 3 until the closer is fitted",
			})); err != nil {
		t.Fatalf("MitigateDeficiency: %v", err)
	}

	open, err := h.facilities.ListOpenCritical(ctx,
		as(h.managerToken(), &facilitiesv1.ListOpenCriticalRequest{
			FacilityId: h.facility}))
	if err != nil {
		t.Fatalf("ListOpenCritical: %v", err)
	}
	if len(open.Msg.GetDeficiencies()) != 1 {
		t.Fatalf("a mitigated finding stays on the list, got %d",
			len(open.Msg.GetDeficiencies()))
	}
	if open.Msg.GetDeficiencies()[0].GetState() !=
		facilitiesv1.DeficiencyState_DEFICIENCY_STATE_MITIGATED {
		t.Fatalf("and says what is in place: %+v",
			open.Msg.GetDeficiencies()[0])
	}

	// A facilities manager under pressure to clear a backlog cannot
	// certify a fire door repaired.
	_, err = h.facilities.CloseDeficiency(ctx,
		as(h.managerToken(), &facilitiesv1.CloseDeficiencyRequest{
			DeficiencyId: deficiency.GetDeficiencyId(),
			EvidenceRef:  "photo-1"}))
	if err == nil || !strings.Contains(err.Error(), "fac.safety.close") {
		t.Fatalf("want a refusal naming fac.safety.close, got %v", err)
	}

	// Nor can the officer who found it, and not without evidence.
	_, err = h.facilities.CloseDeficiency(ctx,
		as(h.fireOfficerToken(), &facilitiesv1.CloseDeficiencyRequest{
			DeficiencyId: deficiency.GetDeficiencyId()}))
	if err == nil ||
		!strings.Contains(err.Error(), "closes with evidence") {
		t.Fatalf("want a refusal naming the evidence, got %v", err)
	}
	_, err = h.facilities.CloseDeficiency(ctx,
		as(h.fireOfficerToken(), &facilitiesv1.CloseDeficiencyRequest{
			DeficiencyId: deficiency.GetDeficiencyId(),
			EvidenceRef:  "photo-1"}))
	if err == nil || !strings.Contains(err.Error(), "other than fire-1") {
		t.Fatalf("want a refusal naming the finder, got %v", err)
	}

	// A second officer certifies it, with evidence.
	if _, err := h.facilities.CloseDeficiency(ctx,
		as(h.otherFireOfficerToken(),
			&facilitiesv1.CloseDeficiencyRequest{
				DeficiencyId: deficiency.GetDeficiencyId(),
				EvidenceRef:  "photo-1",
			})); err != nil {
		t.Fatalf("CloseDeficiency: %v", err)
	}

	after, err := h.facilities.ListOpenCritical(ctx,
		as(h.managerToken(), &facilitiesv1.ListOpenCriticalRequest{
			FacilityId: h.facility}))
	if err != nil {
		t.Fatalf("ListOpenCritical: %v", err)
	}
	if len(after.Msg.GetDeficiencies()) != 0 {
		t.Fatalf("a closed finding leaves the list, got %d",
			len(after.Msg.GetDeficiencies()))
	}
}

// SRS-FAC-003, SRS-FAC-007: a generator's service fires on hours, and the
// statutory inspection closes with a certificate or not at all.
func TestMaintenanceComesDueOnHoursAndClosesOnEvidence(t *testing.T) {
	h := newFacHarness(t)
	ctx := context.Background()

	generator := h.registerAsset(t, "DG-02",
		facilitiesv1.System_SYSTEM_POWER,
		facilitiesv1.Criticality_CRITICALITY_LIFE)

	if _, err := h.facilities.AddSchedule(ctx,
		as(h.managerToken(), &facilitiesv1.AddScheduleRequest{
			AssetId: generator.GetAssetId(), FacilityId: h.facility,
			Title:        "Generator 250-hour service",
			Kind:         facilitiesv1.MaintenanceKind_MAINTENANCE_KIND_PREVENTIVE,
			Trigger:      facilitiesv1.Trigger_TRIGGER_EITHER,
			IntervalDays: 180, IntervalRuntimeHours: 250,
		})); err != nil {
		t.Fatalf("AddSchedule: %v", err)
	}

	// Nothing is due yet: the schedule was created today and the
	// generator has run 100 hours.
	if _, err := h.facilities.RecordRuntime(ctx,
		as(h.technicianToken(), &facilitiesv1.RecordRuntimeRequest{
			AssetId: generator.GetAssetId(), Hours: 100,
			Source:    facilitiesv1.Source_SOURCE_BMS,
			SourceRef: "bms:DG2.RunHours",
		})); err != nil {
		t.Fatalf("RecordRuntime: %v", err)
	}
	quiet, err := h.facilities.PlanDue(ctx,
		as(h.managerToken(), &facilitiesv1.PlanDueRequest{
			FacilityId: h.facility}))
	if err != nil {
		t.Fatalf("PlanDue: %v", err)
	}
	if len(quiet.Msg.GetTasks()) != 0 {
		t.Fatalf("100 hours into a 250-hour interval is not due, got %d",
			len(quiet.Msg.GetTasks()))
	}

	// The monsoon happens and the generator runs.
	if _, err := h.facilities.RecordRuntime(ctx,
		as(h.technicianToken(), &facilitiesv1.RecordRuntimeRequest{
			AssetId: generator.GetAssetId(), Hours: 260,
			Source:    facilitiesv1.Source_SOURCE_BMS,
			SourceRef: "bms:DG2.RunHours",
		})); err != nil {
		t.Fatalf("RecordRuntime: %v", err)
	}

	due, err := h.facilities.PlanDue(ctx,
		as(h.managerToken(), &facilitiesv1.PlanDueRequest{
			FacilityId: h.facility}))
	if err != nil {
		t.Fatalf("PlanDue: %v", err)
	}
	if len(due.Msg.GetTasks()) != 1 {
		t.Fatalf("SRS-FAC-007: the runtime trigger fires, got %d",
			len(due.Msg.GetTasks()))
	}
	task := due.Msg.GetTasks()[0]
	if task.GetTriggeredBy() != facilitiesv1.Trigger_TRIGGER_RUNTIME {
		// The evidence SRS-FAC-007 asks for: a service that fired on
		// hours rather than on the calendar can prove it did.
		t.Fatalf("and says it was the hours: %+v", task)
	}
	if task.GetDueRuntimeHours() != 250 {
		t.Fatalf("due at 250 hours, got %d", task.GetDueRuntimeHours())
	}

	// And a counter that went backwards without saying why is refused.
	_, err = h.facilities.RecordRuntime(ctx,
		as(h.technicianToken(), &facilitiesv1.RecordRuntimeRequest{
			AssetId: generator.GetAssetId(), Hours: 12,
			Source:    facilitiesv1.Source_SOURCE_BMS,
			SourceRef: "bms:DG2.RunHours",
		}))
	if err == nil ||
		!strings.Contains(err.Error(), "below the last reading") {
		t.Fatalf("want a refusal naming the last reading, got %v", err)
	}

	// The statutory half. A lift inspection closes with a certificate and
	// an expiry, and cannot be waived at all.
	lift := h.registerAsset(t, "LIFT-1",
		facilitiesv1.System_SYSTEM_LIFTS,
		facilitiesv1.Criticality_CRITICALITY_HIGH)
	if _, err := h.facilities.AddSchedule(ctx,
		as(h.managerToken(), &facilitiesv1.AddScheduleRequest{
			AssetId: lift.GetAssetId(), FacilityId: h.facility,
			Title:            "Lift thorough examination",
			Kind:             facilitiesv1.MaintenanceKind_MAINTENANCE_KIND_STATUTORY,
			Trigger:          facilitiesv1.Trigger_TRIGGER_CALENDAR,
			IntervalDays:     182,
			Authority:        "State Lift Inspectorate",
			RequiresEvidence: true,
		})); err != nil {
		t.Fatalf("AddSchedule(statutory): %v", err)
	}

	// A schedule created today is not due for 182 days, so the occurrence
	// is planned directly to exercise the closure rules.
	statutory := h.planStatutory(t, lift.GetAssetId())

	_, err = h.facilities.WaiveTask(ctx,
		as(h.fireOfficerToken(), &facilitiesv1.WaiveTaskRequest{
			TaskId: statutory.GetTaskId(),
			Reason: "lift out of service all quarter"}))
	if err == nil || !strings.Contains(err.Error(), "not waived") {
		t.Fatalf("a hospital cannot waive its own lift inspection: %v",
			err)
	}

	_, err = h.facilities.CompleteTask(ctx,
		as(h.fireOfficerToken(), &facilitiesv1.CompleteTaskRequest{
			TaskId: statutory.GetTaskId(), Findings: "passed",
			EvidenceRef: "doc-1"}))
	if err == nil ||
		!strings.Contains(err.Error(), "closes with a certificate") {
		t.Fatalf("want a refusal naming the certificate, got %v", err)
	}

	done, err := h.facilities.CompleteTask(ctx,
		as(h.fireOfficerToken(), &facilitiesv1.CompleteTaskRequest{
			TaskId: statutory.GetTaskId(), Findings: "passed",
			EvidenceRef: "doc-1", CertificateRef: "LI-88",
			CertificateExpiresAt: timestamppb.New(
				time.Now().UTC().AddDate(0, 6, 0)),
		}))
	if err != nil {
		t.Fatalf("CompleteTask: %v", err)
	}
	if done.Msg.GetTask().GetCertificateExpiresAt() == nil {
		// A certificate with no expiry is one nobody renews, and the
		// first anybody hears of it is the inspector.
		t.Fatalf("the expiry is kept: %+v", done.Msg.GetTask())
	}
}

// planStatutory makes the statutory schedule due by hand and plans its
// occurrence. PlanDue measures from the schedule's creation, and a test that
// waited 182 days would not be a test.
func (h *facHarness) planStatutory(t *testing.T,
	assetID string) *facilitiesv1.Task {

	t.Helper()
	ctx := context.Background()

	if _, err := h.pool.Exec(ctx, `
		UPDATE facilities.schedule
		SET created_at = now() - interval '200 days'
		WHERE tenant_id = $1 AND kind = 'statutory'`,
		uuid.MustParse(h.tenantID)); err != nil {
		t.Fatalf("age the schedule: %v", err)
	}

	planned, err := h.facilities.PlanDue(ctx,
		as(h.managerToken(), &facilitiesv1.PlanDueRequest{
			FacilityId: h.facility}))
	if err != nil {
		t.Fatalf("PlanDue(statutory): %v", err)
	}
	for _, task := range planned.Msg.GetTasks() {
		if task.GetScheduleKind() ==
			facilitiesv1.MaintenanceKind_MAINTENANCE_KIND_STATUTORY {
			return task
		}
	}
	t.Fatalf("the statutory occurrence was planned, got %d tasks",
		len(planned.Msg.GetTasks()))
	return nil
}

// SRS-FAC-009: a consumption figure reaches the command centre with its
// meter and its sources, and says when it is an estimate.
func TestAConsumptionFigureCarriesItsProvenance(t *testing.T) {
	h := newFacHarness(t)
	ctx := context.Background()

	meter, err := h.facilities.AddMeter(ctx,
		as(h.managerToken(), &facilitiesv1.AddMeterRequest{
			Code: "LV-MAIN-1", Name: "LV panel 1",
			Utility: facilitiesv1.Utility_UTILITY_ELECTRICITY,
			Unit:    "kWh", FacilityId: h.facility,
			Source:     facilitiesv1.Source_SOURCE_AMI,
			SourceRef:  "ami:00291",
			Cumulative: true, RegisterMax: 99999,
		}))
	if err != nil {
		t.Fatalf("AddMeter: %v", err)
	}
	meterID := meter.Msg.GetMeter().GetMeterId()

	start := time.Now().UTC().Add(-24 * time.Hour)
	if _, err := h.facilities.RecordMeterReading(ctx,
		as(h.technicianToken(),
			&facilitiesv1.RecordMeterReadingRequest{
				MeterId: meterID, Value: 41000,
				ReadAt: timestamppb.New(start),
			})); err != nil {
		t.Fatalf("RecordMeterReading: %v", err)
	}

	// One reading of a counting register says where the counter stands,
	// not what was used. Reporting it as consumption is the mistake that
	// has a hospital using four million units in an hour.
	single, err := h.facilities.GetConsumption(ctx,
		as(h.managerToken(), &facilitiesv1.GetConsumptionRequest{
			MeterId: meterID,
			From:    timestamppb.New(start.Add(-time.Hour)),
		}))
	if err != nil {
		t.Fatalf("GetConsumption: %v", err)
	}
	if single.Msg.GetAvailable() {
		t.Fatalf("one reading is not a consumption figure: %+v",
			single.Msg)
	}

	// The gateway was down overnight, so somebody read the dial.
	if _, err := h.facilities.RecordMeterReading(ctx,
		as(h.technicianToken(),
			&facilitiesv1.RecordMeterReadingRequest{
				MeterId: meterID, Value: 41500,
				ReadAt: timestamppb.New(start.Add(12 * time.Hour)),
				Source: facilitiesv1.Source_SOURCE_MANUAL,
				Note:   "gateway offline",
			})); err != nil {
		t.Fatalf("RecordMeterReading(manual): %v", err)
	}

	got, err := h.facilities.GetConsumption(ctx,
		as(h.managerToken(), &facilitiesv1.GetConsumptionRequest{
			MeterId: meterID,
			From:    timestamppb.New(start.Add(-time.Hour)),
		}))
	if err != nil {
		t.Fatalf("GetConsumption: %v", err)
	}
	if !got.Msg.GetAvailable() {
		t.Fatalf("two readings make a figure: %+v", got.Msg)
	}
	consumption := got.Msg.GetConsumption()
	if consumption.GetQuantity() != 500 {
		t.Fatalf("500 kWh between the readings, got %d",
			consumption.GetQuantity())
	}
	if consumption.GetMeterId() != meterID ||
		consumption.GetUnit() != "kWh" {
		// SRS-FAC-009's acceptance: a number that reached the command
		// centre without its provenance cannot be checked.
		t.Fatalf("the figure names its meter and unit: %+v", consumption)
	}
	if len(consumption.GetSources()) != 2 {
		t.Fatalf("both provenances are kept: %+v",
			consumption.GetSources())
	}
	if !consumption.GetEstimated() {
		t.Fatalf("a hand-read figure is an estimate: %+v", consumption)
	}
}

// SRS-FAC-011: a contractor on permit work carries their site induction, and
// leaves with a service report.
func TestAContractorOnPermitWorkCarriesTheirInduction(t *testing.T) {
	h := newFacHarness(t)
	h.setUpClasses(t)
	ctx := context.Background()

	order := h.raiseWork(t, h.managerToken(), "hv_switching",
		func(r *facilitiesv1.RaiseWorkRequest) {
			r.System = facilitiesv1.System_SYSTEM_ELECTRICAL
			r.Fault = "LV panel 3 busbar hot joint"
			r.Impact = "ward 5 on one supply"
		})

	// The flag comes from the work order's class, not from the
	// contractor: somebody asked at the gate whether their work needs a
	// permit will say no.
	_, err := h.facilities.SignInVendor(ctx,
		as(h.technicianToken(), &facilitiesv1.SignInVendorRequest{
			VendorName: "Sparks Ltd", VendorRef: "PO-2211",
			Technicians: []string{"R Rao"},
			FacilityId:  h.facility,
			WorkOrderId: order.GetWorkOrderId(),
			Purpose:     "11kV switching and joint repair",
		}))
	if err == nil ||
		!strings.Contains(err.Error(), "site induction on record") {
		t.Fatalf("want a refusal naming the induction, got %v", err)
	}

	visit, err := h.facilities.SignInVendor(ctx,
		as(h.technicianToken(), &facilitiesv1.SignInVendorRequest{
			VendorName: "Sparks Ltd", VendorRef: "PO-2211",
			Technicians:  []string{"R Rao", "S Kumar"},
			FacilityId:   h.facility,
			WorkOrderId:  order.GetWorkOrderId(),
			InductionRef: "IND-4412",
			Purpose:      "11kV switching and joint repair",
		}))
	if err != nil {
		t.Fatalf("SignInVendor: %v", err)
	}
	if !visit.Msg.GetVisit().GetWorkRequiresPermit() {
		t.Fatalf("the visit carries the class's flag: %+v",
			visit.Msg.GetVisit())
	}

	// A visit against nothing at all is a visitor log entry.
	_, err = h.facilities.SignInVendor(ctx,
		as(h.technicianToken(), &facilitiesv1.SignInVendorRequest{
			VendorName:  "Anybody Ltd",
			Technicians: []string{"A Person"},
			FacilityId:  h.facility, Purpose: "looking around",
		}))
	if err == nil ||
		!strings.Contains(err.Error(), "work order, asset or task") {
		t.Fatalf("want a refusal naming the linkage, got %v", err)
	}

	// The roll call shows who is in the building.
	onSite, err := h.facilities.ListVendorVisits(ctx,
		as(h.managerToken(), &facilitiesv1.ListVendorVisitsRequest{
			FacilityId: h.facility, OnSiteOnly: true}))
	if err != nil {
		t.Fatalf("ListVendorVisits: %v", err)
	}
	if len(onSite.Msg.GetVisits()) != 1 ||
		len(onSite.Msg.GetVisits()[0].GetTechnicians()) != 2 {
		t.Fatalf("one visit, two people: %+v", onSite.Msg.GetVisits())
	}

	// And they do not leave without a report.
	_, err = h.facilities.SignOutVendor(ctx,
		as(h.technicianToken(), &facilitiesv1.SignOutVendorRequest{
			VisitId:       visit.Msg.GetVisit().GetVisitId(),
			ReportSummary: "joint re-torqued"}))
	if err == nil ||
		!strings.Contains(err.Error(), "closes with the service report") {
		t.Fatalf("want a refusal naming the report, got %v", err)
	}

	if _, err := h.facilities.SignOutVendor(ctx,
		as(h.technicianToken(), &facilitiesv1.SignOutVendorRequest{
			VisitId:          visit.Msg.GetVisit().GetVisitId(),
			ServiceReportRef: "sr-1",
			ReportSummary:    "joint re-torqued and thermographed",
			FollowUp:         "re-survey the panel at the next shutdown",
		})); err != nil {
		t.Fatalf("SignOutVendor: %v", err)
	}
}
