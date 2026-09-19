package app_test

import (
	"context"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"

	biomedicalv1 "github.com/ppusapati/health/code/gen/go/healthcare/biomedical/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/biomedical/v1/biomedicalv1connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	"github.com/ppusapati/health/code/internal/app"
	biomedicalapp "github.com/ppusapati/health/code/internal/biomedical/application"
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

// Biomedical engineering (SRS-BIO-001 … 011), end to end.
//
// The domain tests hold the reliability arithmetic, the SLA derivation and
// the recall matching. These hold what only the assembled stack shows: that a
// ticket's clock comes from the contract in the database rather than from the
// request, that the separation between doing a repair and validating it is a
// permission and a domain rule rather than a convention, that a recall holds
// equipment in the same call that records it, and that a machine going down
// takes its capability off the room a scheduler reads.

type bioHarness struct {
	dbPool *pgxpool.Pool
	bio    biomedicalv1connect.BiomedicalServiceClient
	org    organizationv1connect.OrganizationServiceClient

	tenantID string
	facility string
}

func newBioHarness(t *testing.T) *bioHarness {
	return newBioHarnessWith(t, biomedicalapp.Config{
		ExpiryHorizon:          90 * 24 * time.Hour,
		SoonWindow:             14 * 24 * time.Hour,
		DefaultResponseHours:   48,
		DefaultResolutionHours: 120,
	})
}

func newBioHarnessWith(t *testing.T, config biomedicalapp.Config) *bioHarness {
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
		Biomedical: config,
	})

	server := httptest.NewServer(h2c.NewHandler(built.Handler, &http2.Server{}))
	t.Cleanup(server.Close)

	h := &bioHarness{
		bio: biomedicalv1connect.NewBiomedicalServiceClient(server.Client(), server.URL),
		org: organizationv1connect.NewOrganizationServiceClient(server.Client(), server.URL),
	}
	h.dbPool = pool

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
	h.entitle(t, "biomedical")
	return h
}

func (h *bioHarness) entitle(t *testing.T, module string) {
	t.Helper()

	repo := orgpostgres.New(pgtx.NewManager(h.dbPool))
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

func (h *bioHarness) engineerToken() string {
	return h.tenantID + ":bme-1:biomedical_engineer:" + h.facility
}

func (h *bioHarness) otherEngineerToken() string {
	return h.tenantID + ":bme-2:biomedical_engineer:" + h.facility
}

func (h *bioHarness) managerToken() string {
	return h.tenantID + ":bme-boss:biomedical_manager:" + h.facility
}

func (h *bioHarness) nurseToken() string {
	return h.tenantID + ":nurse-1:nurse:" + h.facility
}

func (h *bioHarness) clerkToken() string {
	return h.tenantID + ":clerk-1:registration_clerk:" + h.facility
}

// register adds one machine to the register.
func (h *bioHarness) register(t *testing.T,
	req *biomedicalv1.RegisterAssetRequest) *biomedicalv1.Asset {

	t.Helper()
	out, err := h.bio.RegisterAsset(context.Background(),
		withFacility(h.engineerToken(), h.facility, req))
	if err != nil {
		t.Fatalf("RegisterAsset(%s): %v", req.GetTag(), err)
	}
	return out.Msg.GetAsset()
}

// ventilator is the running example: life support, in a room, with a
// capability the theatre would schedule against.
func (h *bioHarness) ventilator(t *testing.T, tag, room string) *biomedicalv1.Asset {
	return h.register(t, &biomedicalv1.RegisterAssetRequest{
		Tag: tag, Serial: "SN-" + tag, Make: "Draeger", Model: "Evita",
		Category:    "ventilator",
		Criticality: biomedicalv1.Criticality_CRITICALITY_LIFE_SUPPORT,
		LocationId:  room, Department: "icu",
		Capabilities:      []string{"invasive_ventilation"},
		ExpectedLifeYears: 10,
	})
}

func (h *bioHarness) contract(t *testing.T, assetID string,
	kind biomedicalv1.ContractKind, response, resolution int32) string {

	t.Helper()
	now := time.Now().UTC()
	out, err := h.bio.RecordContract(context.Background(),
		withFacility(h.managerToken(), h.facility,
			&biomedicalv1.RecordContractRequest{
				AssetId: assetID, Kind: kind, Reference: "AMC/" + assetID[:8],
				VendorName:    "Draeger India",
				StartsOn:      timestamppb.New(now.Add(-24 * time.Hour)),
				EndsOn:        timestamppb.New(now.Add(365 * 24 * time.Hour)),
				ResponseHours: response, ResolutionHours: resolution,
			}))
	if err != nil {
		t.Fatalf("RecordContract: %v", err)
	}
	return out.Msg.GetContract().GetContractId()
}

// raise opens a corrective ticket against one asset.
func (h *bioHarness) raise(t *testing.T, assetID string,
	priority biomedicalv1.Priority, impact biomedicalv1.Impact,
	token string) *biomedicalv1.Ticket {

	t.Helper()
	out, err := h.bio.RaiseTicket(context.Background(),
		withFacility(token, h.facility, &biomedicalv1.RaiseTicketRequest{
			Kind:    biomedicalv1.TicketKind_TICKET_KIND_CORRECTIVE,
			AssetId: assetID, Symptom: "will not power on",
			Priority: priority, Impact: impact,
		}))
	if err != nil {
		t.Fatalf("RaiseTicket: %v", err)
	}
	return out.Msg.GetTicket()
}

func TestAnAssetIsRegisteredAndFoundByTheNumberOnItsSticker(t *testing.T) {
	h := newBioHarness(t)
	ctx := context.Background()

	registered := h.ventilator(t, "BME-0001", "icu-bay-1")

	// The tag is what somebody reporting a fault reads out loud. If it does
	// not resolve, the ticket names nothing an engineer can walk to.
	found, err := h.bio.GetAssetByTag(ctx,
		withFacility(h.engineerToken(), h.facility,
			&biomedicalv1.GetAssetByTagRequest{Tag: "BME-0001"}))
	if err != nil {
		t.Fatalf("GetAssetByTag: %v", err)
	}
	if found.Msg.GetAsset().GetAssetId() != registered.GetAssetId() {
		t.Fatalf("tag resolved to %s, want %s",
			found.Msg.GetAsset().GetAssetId(), registered.GetAssetId())
	}
	if got := found.Msg.GetAsset().GetUnusableReasons(); len(got) != 0 {
		t.Fatalf("a new in-service asset reports as unusable: %v", got)
	}
}

func TestATagBelongsToOneMachine(t *testing.T) {
	h := newBioHarness(t)

	h.ventilator(t, "BME-0001", "icu-bay-1")
	_, err := h.bio.RegisterAsset(context.Background(),
		withFacility(h.engineerToken(), h.facility,
			&biomedicalv1.RegisterAssetRequest{
				Tag: "BME-0001", Make: "Philips", Model: "V60",
				Criticality: biomedicalv1.Criticality_CRITICALITY_CRITICAL,
			}))
	if err == nil {
		t.Fatal("a second asset took a tag that was already in use")
	}
	if got := connectCode(err); got != connect.CodeAlreadyExists {
		t.Fatalf("duplicate tag returned %v, want AlreadyExists", got)
	}
}

func TestATicketTakesItsClockFromTheContractAndPriorityOnlyTightensIt(t *testing.T) {
	h := newBioHarness(t)

	// A comprehensive contract promising four working days. The deployment's
	// own default is 48/120, so if the ticket took the default rather than
	// the contract this test would not notice — the contract is deliberately
	// slower than the default in one direction and faster in the other.
	slow := h.ventilator(t, "BME-0001", "icu-bay-1")
	h.contract(t, slow.GetAssetId(),
		biomedicalv1.ContractKind_CONTRACT_KIND_CMC, 8, 96)

	routine := h.raise(t, slow.GetAssetId(),
		biomedicalv1.Priority_PRIORITY_NORMAL,
		biomedicalv1.Impact_IMPACT_DEGRADED, h.engineerToken())

	if routine.GetContractId() == "" {
		t.Fatal("a ticket on a covered asset names no contract")
	}
	respondIn := routine.GetRespondBy().AsTime().Sub(routine.GetRaisedAt().AsTime())
	if respondIn.Round(time.Hour) != 8*time.Hour {
		t.Fatalf("response due in %v, want the contract's 8h", respondIn)
	}

	// The same contract, an emergency. The vendor agreed eight hours; the
	// hospital's cap for an emergency is one. Priority tightens and never
	// relaxes, because an emergency is an emergency to the hospital whatever
	// the vendor signed.
	urgent := h.raise(t, slow.GetAssetId(),
		biomedicalv1.Priority_PRIORITY_EMERGENCY,
		biomedicalv1.Impact_IMPACT_PATIENT_AFFECTED, h.engineerToken())
	respondIn = urgent.GetRespondBy().AsTime().Sub(urgent.GetRaisedAt().AsTime())
	if respondIn.Round(time.Minute) != time.Hour {
		t.Fatalf("emergency response due in %v, want 1h", respondIn)
	}
}

func TestAnEngineerCannotSignOffTheirOwnRepair(t *testing.T) {
	h := newBioHarness(t)
	ctx := context.Background()

	asset := h.ventilator(t, "BME-0001", "icu-bay-1")
	ticket := h.raise(t, asset.GetAssetId(),
		biomedicalv1.Priority_PRIORITY_HIGH,
		biomedicalv1.Impact_IMPACT_SERVICE_STOPPED, h.engineerToken())

	assigned, err := h.bio.AssignTicket(ctx, withFacility(h.engineerToken(),
		h.facility, &biomedicalv1.AssignTicketRequest{
			TicketId: ticket.GetTicketId(), OwnerId: "bme-boss",
			ExpectedVersion: ticket.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("AssignTicket: %v", err)
	}
	resolved, err := h.bio.ResolveTicket(ctx, withFacility(h.managerToken(),
		h.facility, &biomedicalv1.ResolveTicketRequest{
			TicketId:  ticket.GetTicketId(),
			Diagnosis: "failed power supply", WorkPerformed: "replaced PSU",
			ExpectedVersion: assigned.Msg.GetTicket().GetVersion(),
		}))
	if err != nil {
		t.Fatalf("ResolveTicket: %v", err)
	}

	// The manager holds bio.ticket.close. Holding it is necessary and not
	// sufficient: they did the work, so the domain refuses them.
	_, err = h.bio.CloseTicket(ctx, withFacility(h.managerToken(), h.facility,
		&biomedicalv1.CloseTicketRequest{
			TicketId: ticket.GetTicketId(), Note: "looks fine to me",
			ExpectedVersion: resolved.Msg.GetTicket().GetVersion(),
		}))
	if err == nil {
		t.Fatal("the engineer who did the work validated it themselves")
	}
	if got := connectCode(err); got != connect.CodeInvalidArgument {
		t.Fatalf("self-validation returned %v, want InvalidArgument", got)
	}
}

func TestAnEngineerDoesNotHoldTheValidation(t *testing.T) {
	h := newBioHarness(t)
	ctx := context.Background()

	asset := h.ventilator(t, "BME-0001", "icu-bay-1")
	ticket := h.raise(t, asset.GetAssetId(),
		biomedicalv1.Priority_PRIORITY_HIGH,
		biomedicalv1.Impact_IMPACT_SERVICE_STOPPED, h.engineerToken())

	resolved, err := h.bio.ResolveTicket(ctx, withFacility(h.engineerToken(),
		h.facility, &biomedicalv1.ResolveTicketRequest{
			TicketId:  ticket.GetTicketId(),
			Diagnosis: "failed power supply", WorkPerformed: "replaced PSU",
			ExpectedVersion: ticket.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("ResolveTicket: %v", err)
	}

	// A different engineer, who did not do the work. The domain would allow
	// them; the permission does not. Two controls, and this is the one that
	// says who the department trusts to validate.
	_, err = h.bio.CloseTicket(ctx, withFacility(h.otherEngineerToken(),
		h.facility, &biomedicalv1.CloseTicketRequest{
			TicketId: ticket.GetTicketId(), Note: "checked",
			ExpectedVersion: resolved.Msg.GetTicket().GetVersion(),
		}))
	if err == nil {
		t.Fatal("an engineer closed a ticket without holding the validation")
	}
	if got := connectCode(err); got != connect.CodePermissionDenied {
		t.Fatalf("close by an engineer returned %v, want PermissionDenied", got)
	}

	// The manager, who did not do the work either, can.
	if _, err := h.bio.CloseTicket(ctx, withFacility(h.managerToken(),
		h.facility, &biomedicalv1.CloseTicketRequest{
			TicketId: ticket.GetTicketId(), Note: "checked",
			ExpectedVersion: resolved.Msg.GetTicket().GetVersion(),
		})); err != nil {
		t.Fatalf("CloseTicket by the manager: %v", err)
	}
}

func TestPlannedWorkNamesItsPlanAndClosingItAdvancesTheBaseline(t *testing.T) {
	h := newBioHarness(t)
	ctx := context.Background()

	asset := h.ventilator(t, "BME-0001", "icu-bay-1")

	// Serviced 200 days ago on a 90-day interval: overdue twice over.
	plan, err := h.bio.SchedulePlan(ctx, withFacility(h.engineerToken(),
		h.facility, &biomedicalv1.SchedulePlanRequest{
			AssetId:      asset.GetAssetId(),
			Basis:        biomedicalv1.PlanBasis_PLAN_BASIS_INTERVAL,
			IntervalDays: 90, Procedure: "annual service per manual §7",
			EstimatedMinutes: 120,
			LastPerformedAt: timestamppb.New(
				time.Now().UTC().Add(-200 * 24 * time.Hour)),
		}))
	if err != nil {
		t.Fatalf("SchedulePlan: %v", err)
	}
	planID := plan.Msg.GetPlan().GetPlanId()

	due, err := h.bio.ListDueMaintenance(ctx, withFacility(h.engineerToken(),
		h.facility, &biomedicalv1.ListDueMaintenanceRequest{}))
	if err != nil {
		t.Fatalf("ListDueMaintenance: %v", err)
	}
	if len(due.Msg.GetDue()) != 1 ||
		due.Msg.GetDue()[0].GetState() != biomedicalv1.DueState_DUE_STATE_OVERDUE {
		t.Fatalf("due list = %v, want one overdue plan", due.Msg.GetDue())
	}

	// Preventive work naming no plan is refused: PM compliance would
	// otherwise be whatever anybody labelled preventive.
	_, err = h.bio.RaiseTicket(ctx, withFacility(h.engineerToken(), h.facility,
		&biomedicalv1.RaiseTicketRequest{
			Kind:    biomedicalv1.TicketKind_TICKET_KIND_PREVENTIVE,
			AssetId: asset.GetAssetId(), Symptom: "scheduled service",
			Priority: biomedicalv1.Priority_PRIORITY_LOW,
			Impact:   biomedicalv1.Impact_IMPACT_NONE,
		}))
	if err == nil {
		t.Fatal("preventive work was raised without naming a plan")
	}

	raised, err := h.bio.RaiseTicket(ctx, withFacility(h.engineerToken(),
		h.facility, &biomedicalv1.RaiseTicketRequest{
			Kind:    biomedicalv1.TicketKind_TICKET_KIND_PREVENTIVE,
			AssetId: asset.GetAssetId(), PlanId: planID,
			Symptom:  "scheduled service",
			Priority: biomedicalv1.Priority_PRIORITY_LOW,
			Impact:   biomedicalv1.Impact_IMPACT_NONE,
		}))
	if err != nil {
		t.Fatalf("RaiseTicket(preventive): %v", err)
	}
	ticket := raised.Msg.GetTicket()

	resolved, err := h.bio.ResolveTicket(ctx, withFacility(h.engineerToken(),
		h.facility, &biomedicalv1.ResolveTicketRequest{
			TicketId:  ticket.GetTicketId(),
			Diagnosis: "routine", WorkPerformed: "serviced per manual §7",
			ExpectedVersion: ticket.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("ResolveTicket: %v", err)
	}
	if _, err := h.bio.CloseTicket(ctx, withFacility(h.managerToken(),
		h.facility, &biomedicalv1.CloseTicketRequest{
			TicketId: ticket.GetTicketId(), Note: "verified",
			ExpectedVersion: resolved.Msg.GetTicket().GetVersion(),
		})); err != nil {
		t.Fatalf("CloseTicket: %v", err)
	}

	// The baseline moved because the work closed, not because anybody set it,
	// so the plan stops being work. The due list is a work list: a plan that
	// is not due is not on it.
	due, err = h.bio.ListDueMaintenance(ctx, withFacility(h.engineerToken(),
		h.facility, &biomedicalv1.ListDueMaintenanceRequest{}))
	if err != nil {
		t.Fatalf("ListDueMaintenance after service: %v", err)
	}
	if len(due.Msg.GetDue()) != 0 {
		t.Fatalf("due list = %v, want nothing outstanding after the service",
			due.Msg.GetDue())
	}

	// And the plan itself is still there, still active, with the baseline it
	// was given by the work rather than by anybody setting it.
	plans, err := h.bio.ListPlans(ctx, withFacility(h.engineerToken(),
		h.facility, &biomedicalv1.ListPlansRequest{ActiveOnly: true}))
	if err != nil {
		t.Fatalf("ListPlans: %v", err)
	}
	if len(plans.Msg.GetPlans()) != 1 {
		t.Fatalf("plans = %v, want the schedule still active",
			plans.Msg.GetPlans())
	}
	serviced := plans.Msg.GetPlans()[0].GetLastPerformedAt().AsTime()
	if time.Since(serviced) > time.Hour {
		t.Fatalf("baseline is %v, want it advanced to the work that closed",
			serviced)
	}
}

func TestOnlyABreakdownCountsAgainstTheMachine(t *testing.T) {
	h := newBioHarness(t)
	ctx := context.Background()

	asset := h.ventilator(t, "BME-0001", "icu-bay-1")
	plan, err := h.bio.SchedulePlan(ctx, withFacility(h.engineerToken(),
		h.facility, &biomedicalv1.SchedulePlanRequest{
			AssetId:      asset.GetAssetId(),
			Basis:        biomedicalv1.PlanBasis_PLAN_BASIS_INTERVAL,
			IntervalDays: 90, Procedure: "service",
			LastPerformedAt: timestamppb.New(
				time.Now().UTC().Add(-10 * 24 * time.Hour)),
		}))
	if err != nil {
		t.Fatalf("SchedulePlan: %v", err)
	}

	// Two outages of the same length: one planned, one a breakdown. If both
	// counted, servicing the machine properly would make it look unreliable.
	h.closeWork(t, asset.GetAssetId(), plan.Msg.GetPlan().GetPlanId(),
		biomedicalv1.TicketKind_TICKET_KIND_PREVENTIVE,
		time.Now().UTC().Add(-8*24*time.Hour), 4*time.Hour)
	h.closeWork(t, asset.GetAssetId(), "",
		biomedicalv1.TicketKind_TICKET_KIND_CORRECTIVE,
		time.Now().UTC().Add(-4*24*time.Hour), 4*time.Hour)

	metrics, err := h.bio.GetAssetMetrics(ctx, withFacility(h.engineerToken(),
		h.facility, &biomedicalv1.GetAssetMetricsRequest{
			AssetId: asset.GetAssetId(),
			From:    timestamppb.New(time.Now().UTC().Add(-30 * 24 * time.Hour)),
			To:      timestamppb.New(time.Now().UTC().Add(time.Minute)),
		}))
	if err != nil {
		t.Fatalf("GetAssetMetrics: %v", err)
	}
	m := metrics.Msg.GetMetrics()

	if m.GetFailures() != 1 {
		t.Fatalf("failures = %d, want 1: a scheduled service is not a failure",
			m.GetFailures())
	}
	if m.GetPlannedDowntimeMinutes() < 200 {
		t.Fatalf("planned downtime = %d minutes, want the service reported separately",
			m.GetPlannedDowntimeMinutes())
	}
	if m.GetDowntimeMinutes() >= m.GetPlannedDowntimeMinutes()*2 {
		t.Fatalf("downtime %d includes the planned work as well",
			m.GetDowntimeMinutes())
	}
}

// closeWork runs one ticket all the way to closed, with a fixed outage.
func (h *bioHarness) closeWork(t *testing.T, assetID, planID string,
	kind biomedicalv1.TicketKind, from time.Time, length time.Duration) {

	t.Helper()
	ctx := context.Background()

	raised, err := h.bio.RaiseTicket(ctx, withFacility(h.engineerToken(),
		h.facility, &biomedicalv1.RaiseTicketRequest{
			Kind: kind, AssetId: assetID, PlanId: planID,
			Symptom:  "work",
			Priority: biomedicalv1.Priority_PRIORITY_NORMAL,
			Impact:   biomedicalv1.Impact_IMPACT_DEGRADED,
			DownFrom: timestamppb.New(from),
		}))
	if err != nil {
		t.Fatalf("RaiseTicket(%s): %v", kind, err)
	}
	ticket := raised.Msg.GetTicket()

	resolved, err := h.bio.ResolveTicket(ctx, withFacility(h.engineerToken(),
		h.facility, &biomedicalv1.ResolveTicketRequest{
			TicketId:  ticket.GetTicketId(),
			Diagnosis: "found", WorkPerformed: "done",
			BackInServiceAt: timestamppb.New(from.Add(length)),
			ExpectedVersion: ticket.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("ResolveTicket(%s): %v", kind, err)
	}
	if _, err := h.bio.CloseTicket(ctx, withFacility(h.managerToken(),
		h.facility, &biomedicalv1.CloseTicketRequest{
			TicketId: ticket.GetTicketId(), Note: "verified",
			ExpectedVersion: resolved.Msg.GetTicket().GetVersion(),
		})); err != nil {
		t.Fatalf("CloseTicket(%s): %v", kind, err)
	}
}

func TestARecallHoldsEveryMatchedMachineInTheCallThatRecordsIt(t *testing.T) {
	h := newBioHarness(t)
	ctx := context.Background()

	affected := h.ventilator(t, "BME-0001", "icu-bay-1")
	other := h.register(t, &biomedicalv1.RegisterAssetRequest{
		Tag: "BME-0002", Serial: "SN-OTHER", Make: "Philips", Model: "V60",
		Criticality: biomedicalv1.Criticality_CRITICALITY_CRITICAL,
		LocationId:  "icu-bay-2",
	})

	raised, err := h.bio.RaiseNotice(ctx, withFacility(h.managerToken(),
		h.facility, &biomedicalv1.RaiseNoticeRequest{
			Reference: "FSN-2026-014",
			Kind:      biomedicalv1.NoticeKind_NOTICE_KIND_RECALL,
			Issuer:    "CDSCO", Summary: "expiratory valve may stick",
			Make: "Draeger", Model: "Evita",
			RequiredAction: "replace the expiratory valve cassette",
			IssuedOn:       timestamppb.New(time.Now().UTC()),
		}))
	if err != nil {
		t.Fatalf("RaiseNotice: %v", err)
	}
	if got := len(raised.Msg.GetTasks()); got != 1 {
		t.Fatalf("recall matched %d assets, want 1", got)
	}

	// Held in the same call. A recall recorded now and swept later is a
	// window in which the hospital has been told and the machine is still on
	// a patient.
	held, err := h.bio.GetAsset(ctx, withFacility(h.engineerToken(), h.facility,
		&biomedicalv1.GetAssetRequest{AssetId: affected.GetAssetId()}))
	if err != nil {
		t.Fatalf("GetAsset: %v", err)
	}
	if !held.Msg.GetAsset().GetSafetyHold() {
		t.Fatal("the recalled machine is not on safety hold")
	}
	if len(held.Msg.GetAsset().GetUnusableReasons()) == 0 {
		t.Fatal("a held asset reports no reason it cannot be used")
	}

	untouched, err := h.bio.GetAsset(ctx, withFacility(h.engineerToken(),
		h.facility, &biomedicalv1.GetAssetRequest{AssetId: other.GetAssetId()}))
	if err != nil {
		t.Fatalf("GetAsset(other): %v", err)
	}
	if untouched.Msg.GetAsset().GetSafetyHold() {
		t.Fatal("a recall on one make held a machine of another")
	}
}

func TestARecallIsNotClosedOverUnfinishedWork(t *testing.T) {
	h := newBioHarness(t)
	ctx := context.Background()

	h.ventilator(t, "BME-0001", "icu-bay-1")
	raised, err := h.bio.RaiseNotice(ctx, withFacility(h.managerToken(),
		h.facility, &biomedicalv1.RaiseNoticeRequest{
			Reference: "FSN-2026-014",
			Kind:      biomedicalv1.NoticeKind_NOTICE_KIND_RECALL,
			Issuer:    "CDSCO", Summary: "expiratory valve may stick",
			Make: "Draeger", RequiredAction: "replace the valve cassette",
			IssuedOn: timestamppb.New(time.Now().UTC()),
		}))
	if err != nil {
		t.Fatalf("RaiseNotice: %v", err)
	}
	notice := raised.Msg.GetNotice()

	_, err = h.bio.CloseNotice(ctx, withFacility(h.managerToken(), h.facility,
		&biomedicalv1.CloseNoticeRequest{
			NoticeId: notice.GetNoticeId(), Note: "all done",
			ExpectedVersion: notice.GetVersion(),
		}))
	if err == nil {
		t.Fatal("a recall was closed with a machine still outstanding")
	}
	if !strings.Contains(strings.ToLower(err.Error()), "outstanding") {
		t.Fatalf("closure refusal does not say what is outstanding: %v", err)
	}

	// Correct the one asset, releasing its hold, and the notice closes.
	task := raised.Msg.GetTasks()[0]
	if _, err := h.bio.AdvanceTask(ctx, withFacility(h.managerToken(),
		h.facility, &biomedicalv1.AdvanceTaskRequest{
			TaskId:      task.GetTaskId(),
			State:       biomedicalv1.TaskState_TASK_STATE_CORRECTED,
			Note:        "cassette replaced, serial VC-99",
			ReleaseHold: true,
		})); err != nil {
		t.Fatalf("AdvanceTask: %v", err)
	}
	if _, err := h.bio.CloseNotice(ctx, withFacility(h.managerToken(),
		h.facility, &biomedicalv1.CloseNoticeRequest{
			NoticeId: notice.GetNoticeId(), Note: "complete",
			ExpectedVersion: notice.GetVersion(),
		})); err != nil {
		t.Fatalf("CloseNotice after correction: %v", err)
	}

	tracked, err := h.bio.TrackNotice(ctx, withFacility(h.engineerToken(),
		h.facility, &biomedicalv1.TrackNoticeRequest{
			NoticeId: notice.GetNoticeId(),
		}))
	if err != nil {
		t.Fatalf("TrackNotice: %v", err)
	}
	if tracked.Msg.GetComplete() != 1 || tracked.Msg.GetOutstanding() != 0 {
		t.Fatalf("progress = %+v, want one complete and none outstanding",
			tracked.Msg)
	}
}

func TestABrokenMachineTakesItsCapabilityOffTheRoom(t *testing.T) {
	h := newBioHarness(t)
	ctx := context.Background()

	// Two intensifiers in one theatre. Losing one must not take the room off
	// the list, because the room can still do the work.
	first := h.register(t, &biomedicalv1.RegisterAssetRequest{
		Tag: "BME-II-1", Serial: "II-1", Make: "Siemens", Model: "Cios",
		Criticality:  biomedicalv1.Criticality_CRITICALITY_CRITICAL,
		LocationId:   "ot-1",
		Capabilities: []string{"image_intensifier"},
	})
	h.register(t, &biomedicalv1.RegisterAssetRequest{
		Tag: "BME-II-2", Serial: "II-2", Make: "Siemens", Model: "Cios",
		Criticality:  biomedicalv1.Criticality_CRITICALITY_CRITICAL,
		LocationId:   "ot-1",
		Capabilities: []string{"image_intensifier"},
	})

	capability := h.capability(t, "ot-1")
	if capability.GetAvailable()["image_intensifier"] != 2 {
		t.Fatalf("available = %v, want two intensifiers",
			capability.GetAvailable())
	}

	moved, err := h.bio.MoveAsset(ctx, withFacility(h.engineerToken(),
		h.facility, &biomedicalv1.MoveAssetRequest{
			AssetId:         first.GetAssetId(),
			Status:          biomedicalv1.AssetStatus_ASSET_STATUS_UNDER_MAINTENANCE,
			Note:            "detector fault",
			ExpectedVersion: first.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("MoveAsset: %v", err)
	}

	capability = h.capability(t, "ot-1")
	if got := capability.GetAvailable()["image_intensifier"]; got != 1 {
		t.Fatalf("available = %d, want 1 after one went for service", got)
	}
	if len(capability.GetUnavailable()) != 0 {
		t.Fatalf("the room reports %v unavailable while one still works",
			capability.GetUnavailable())
	}
	if len(capability.GetUnusable()) != 1 {
		t.Fatalf("unusable = %v, want the one machine that is down",
			capability.GetUnusable())
	}

	// The second one goes too. Now the room genuinely cannot do the work, and
	// a scheduler offering the slot would be offering something the hospital
	// cannot deliver.
	second, err := h.bio.GetAssetByTag(ctx, withFacility(h.engineerToken(),
		h.facility, &biomedicalv1.GetAssetByTagRequest{Tag: "BME-II-2"}))
	if err != nil {
		t.Fatalf("GetAssetByTag: %v", err)
	}
	if _, err := h.bio.MoveAsset(ctx, withFacility(h.engineerToken(),
		h.facility, &biomedicalv1.MoveAssetRequest{
			AssetId:         second.Msg.GetAsset().GetAssetId(),
			Status:          biomedicalv1.AssetStatus_ASSET_STATUS_AWAITING_PARTS,
			Note:            "awaiting detector",
			ExpectedVersion: second.Msg.GetAsset().GetVersion(),
		})); err != nil {
		t.Fatalf("MoveAsset(second): %v", err)
	}

	capability = h.capability(t, "ot-1")
	if capability.GetAvailable()["image_intensifier"] != 0 {
		t.Fatalf("available = %v, want none", capability.GetAvailable())
	}
	if len(capability.GetUnavailable()) != 1 ||
		capability.GetUnavailable()[0] != "image_intensifier" {
		t.Fatalf("unavailable = %v, want image_intensifier named",
			capability.GetUnavailable())
	}
	_ = moved
}

func (h *bioHarness) capability(t *testing.T,
	room string) *biomedicalv1.GetLocationCapabilityResponse {

	t.Helper()
	out, err := h.bio.GetLocationCapability(context.Background(),
		withFacility(h.engineerToken(), h.facility,
			&biomedicalv1.GetLocationCapabilityRequest{LocationId: room}))
	if err != nil {
		t.Fatalf("GetLocationCapability(%s): %v", room, err)
	}
	return out.Msg
}

func TestAHeldMachineIsUnavailableThoughItIsStillInService(t *testing.T) {
	h := newBioHarness(t)
	ctx := context.Background()

	asset := h.register(t, &biomedicalv1.RegisterAssetRequest{
		Tag: "BME-II-1", Serial: "II-1", Make: "Siemens", Model: "Cios",
		Criticality:  biomedicalv1.Criticality_CRITICALITY_CRITICAL,
		LocationId:   "ot-1",
		Capabilities: []string{"image_intensifier"},
	})

	held, err := h.bio.HoldAsset(ctx, withFacility(h.managerToken(), h.facility,
		&biomedicalv1.HoldAssetRequest{
			AssetId:         asset.GetAssetId(),
			Reason:          "pending investigation of a dose discrepancy",
			ExpectedVersion: asset.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("HoldAsset: %v", err)
	}
	// Still in service, and still must not be used. That distinction is the
	// whole reason the hold is not a status.
	if got := held.Msg.GetAsset().GetStatus(); got != biomedicalv1.AssetStatus_ASSET_STATUS_IN_SERVICE {
		t.Fatalf("status = %v, want the hold to leave it in service", got)
	}
	if h.capability(t, "ot-1").GetAvailable()["image_intensifier"] != 0 {
		t.Fatal("a held machine still counts towards what the room can do")
	}

	if _, err := h.bio.ReleaseAsset(ctx, withFacility(h.managerToken(),
		h.facility, &biomedicalv1.ReleaseAssetRequest{
			AssetId: asset.GetAssetId(), Reason: "investigation closed",
			ExpectedVersion: held.Msg.GetAsset().GetVersion(),
		})); err != nil {
		t.Fatalf("ReleaseAsset: %v", err)
	}
	if h.capability(t, "ot-1").GetAvailable()["image_intensifier"] != 1 {
		t.Fatal("the room did not get its capability back")
	}
}

func TestALapsedCalibrationBlocksTheRoomOnlyWhereTheDeploymentSaysSo(t *testing.T) {
	// Two deployments, the same machine. SRS-BIO-004's stricter reading — a
	// calibration certificate as a condition of use — is a hospital's
	// decision, so it is configuration rather than a default either way.
	for _, tc := range []struct {
		name          string
		blocks        bool
		wantAvailable int32
	}{
		{"reported but not enforced", false, 1},
		{"a condition of use", true, 0},
	} {
		t.Run(tc.name, func(t *testing.T) {
			h := newBioHarnessWith(t, biomedicalapp.Config{
				BlockOnCalibration: tc.blocks,
				ExpiryHorizon:      90 * 24 * time.Hour,
			})
			h.register(t, &biomedicalv1.RegisterAssetRequest{
				Tag: "BME-AN-1", Serial: "AN-1", Make: "Roche", Model: "Cobas",
				Criticality:         biomedicalv1.Criticality_CRITICALITY_IMPORTANT,
				LocationId:          "lab-1",
				Capabilities:        []string{"chemistry_analysis"},
				CalibrationRequired: true,
				CalibrationDue: timestamppb.New(
					time.Now().UTC().Add(-24 * time.Hour)),
			})

			got := h.capability(t, "lab-1").GetAvailable()["chemistry_analysis"]
			if got != tc.wantAvailable {
				t.Fatalf("available = %d, want %d", got, tc.wantAvailable)
			}
		})
	}
}

func TestARuntimePlanWithNoMeterReadingSaysSoRatherThanNotDue(t *testing.T) {
	h := newBioHarness(t)
	ctx := context.Background()

	asset := h.ventilator(t, "BME-0001", "icu-bay-1")
	if _, err := h.bio.SchedulePlan(ctx, withFacility(h.engineerToken(),
		h.facility, &biomedicalv1.SchedulePlanRequest{
			AssetId:      asset.GetAssetId(),
			Basis:        biomedicalv1.PlanBasis_PLAN_BASIS_RUNTIME,
			RuntimeHours: 5000, Procedure: "5000-hour service",
		})); err != nil {
		t.Fatalf("SchedulePlan: %v", err)
	}

	due, err := h.bio.ListDueMaintenance(ctx, withFacility(h.engineerToken(),
		h.facility, &biomedicalv1.ListDueMaintenanceRequest{}))
	if err != nil {
		t.Fatalf("ListDueMaintenance: %v", err)
	}
	if len(due.Msg.GetDue()) != 1 {
		t.Fatalf("due list = %v, want one line", due.Msg.GetDue())
	}
	// "We do not know" and "it is fine" are different answers, and only one
	// of them needs somebody to go and look at the meter.
	if !due.Msg.GetDue()[0].GetUnanswerable() {
		t.Fatal("a runtime plan with no reading reported as answerable")
	}

	if _, err := h.bio.AppendReadings(ctx, withFacility(h.engineerToken(),
		h.facility, &biomedicalv1.AppendReadingsRequest{
			Readings: []*biomedicalv1.NewReading{{
				AssetId: asset.GetAssetId(), Metric: "runtime_hours",
				Value: 5200, Unit: "h", Source: "gateway-1", Ingested: true,
				ObservedAt: timestamppb.New(time.Now().UTC()),
			}},
		})); err != nil {
		t.Fatalf("AppendReadings: %v", err)
	}

	due, err = h.bio.ListDueMaintenance(ctx, withFacility(h.engineerToken(),
		h.facility, &biomedicalv1.ListDueMaintenanceRequest{}))
	if err != nil {
		t.Fatalf("ListDueMaintenance after reading: %v", err)
	}
	line := due.Msg.GetDue()[0]
	if line.GetUnanswerable() {
		t.Fatal("the plan is still unanswerable after a meter reading arrived")
	}
	if line.GetState() != biomedicalv1.DueState_DUE_STATE_OVERDUE {
		t.Fatalf("state = %v, want overdue at 5200 hours against 5000",
			line.GetState())
	}
}

func TestADisposalIsApprovedBySomebodyOtherThanWhoAskedForIt(t *testing.T) {
	h := newBioHarness(t)
	ctx := context.Background()

	asset := h.ventilator(t, "BME-0001", "icu-bay-1")

	// The approver is the caller, so naming yourself as requester is the one
	// thing the request cannot do.
	_, err := h.bio.DisposeAsset(ctx, withFacility(h.managerToken(), h.facility,
		&biomedicalv1.DisposeAssetRequest{
			AssetId: asset.GetAssetId(), Method: "recycler",
			Reason: "beyond economic repair", RequestedBy: "bme-boss",
		}))
	if err == nil {
		t.Fatal("a disposal was approved by the person who requested it")
	}

	// Sanitisation without its evidence is refused too: "we wiped it" is what
	// everybody says, and a certificate is what an inspection can check.
	_, err = h.bio.DisposeAsset(ctx, withFacility(h.managerToken(), h.facility,
		&biomedicalv1.DisposeAssetRequest{
			AssetId: asset.GetAssetId(), Method: "recycler",
			Reason: "beyond economic repair", RequestedBy: "bme-1",
			SanitisationRequired: true,
		}))
	if err == nil {
		t.Fatal("a disposal requiring sanitisation carried no evidence")
	}

	done, err := h.bio.DisposeAsset(ctx, withFacility(h.managerToken(),
		h.facility, &biomedicalv1.DisposeAssetRequest{
			AssetId: asset.GetAssetId(), Method: "recycler",
			Reason: "beyond economic repair", RequestedBy: "bme-1",
			SanitisationRequired:    true,
			SanitisationMethod:      "NIST 800-88 purge",
			SanitisationCertificate: "CERT-2026-77",
			SanitisedBy:             "infosec-1",
			Recipient:               "Green Recyclers",
		}))
	if err != nil {
		t.Fatalf("DisposeAsset: %v", err)
	}
	if done.Msg.GetDisposal().GetApprovedBy() != "bme-boss" {
		t.Fatalf("approved by %q, want the authenticated caller",
			done.Msg.GetDisposal().GetApprovedBy())
	}
}

func TestADisposedMachineLeavesItsRoomAndTakesNoMoreWork(t *testing.T) {
	h := newBioHarness(t)
	ctx := context.Background()

	asset := h.register(t, &biomedicalv1.RegisterAssetRequest{
		Tag: "BME-II-1", Serial: "II-1", Make: "Siemens", Model: "Cios",
		Criticality:  biomedicalv1.Criticality_CRITICALITY_CRITICAL,
		LocationId:   "ot-1",
		Capabilities: []string{"image_intensifier"},
	})
	if h.capability(t, "ot-1").GetAvailable()["image_intensifier"] != 1 {
		t.Fatal("the room does not have the machine standing in it")
	}

	if _, err := h.bio.DisposeAsset(ctx, withFacility(h.managerToken(),
		h.facility, &biomedicalv1.DisposeAssetRequest{
			AssetId: asset.GetAssetId(), Method: "sold",
			Reason: "replaced", RequestedBy: "bme-1",
		})); err != nil {
		t.Fatalf("DisposeAsset: %v", err)
	}

	// Equipment that has left the building stops contributing capability to
	// the room it stood in, the moment it goes.
	capability := h.capability(t, "ot-1")
	if capability.GetAvailable()["image_intensifier"] != 0 {
		t.Fatalf("a disposed machine still counts: %v", capability.GetAvailable())
	}
	if len(capability.GetUnavailable()) != 0 {
		t.Fatalf("a disposed machine is still listed as the room's: %v",
			capability.GetUnavailable())
	}

	// SRS-BIO-011: a disposed asset cannot be assigned for use, and a work
	// order is an assignment.
	_, err := h.bio.RaiseTicket(ctx, withFacility(h.engineerToken(), h.facility,
		&biomedicalv1.RaiseTicketRequest{
			Kind:    biomedicalv1.TicketKind_TICKET_KIND_CORRECTIVE,
			AssetId: asset.GetAssetId(), Symptom: "will not power on",
			Priority: biomedicalv1.Priority_PRIORITY_NORMAL,
			Impact:   biomedicalv1.Impact_IMPACT_DEGRADED,
		}))
	if err == nil {
		t.Fatal("a work order was raised against a machine that has gone")
	}
}

func TestANurseReportsABrokenMachineAndNothingElse(t *testing.T) {
	h := newBioHarness(t)
	ctx := context.Background()

	asset := h.ventilator(t, "BME-0001", "icu-bay-1")

	// The person who finds a broken machine is whoever was using it.
	ticket := h.raise(t, asset.GetAssetId(),
		biomedicalv1.Priority_PRIORITY_EMERGENCY,
		biomedicalv1.Impact_IMPACT_PATIENT_AFFECTED, h.nurseToken())
	if ticket.GetRaisedBy() != "nurse-1" {
		t.Fatalf("raised by %q, want the nurse", ticket.GetRaisedBy())
	}

	// And nothing else. A nurse does not lift a safety hold.
	_, err := h.bio.HoldAsset(ctx, withFacility(h.nurseToken(), h.facility,
		&biomedicalv1.HoldAssetRequest{
			AssetId: asset.GetAssetId(), Reason: "looks wrong",
			ExpectedVersion: asset.GetVersion(),
		}))
	if got := connectCode(err); got != connect.CodePermissionDenied {
		t.Fatalf("a nurse holding an asset returned %v, want PermissionDenied",
			got)
	}

	// Nor does a clerk report one: bio.ticket.raise is wide, not universal.
	_, err = h.bio.RaiseTicket(ctx, withFacility(h.clerkToken(), h.facility,
		&biomedicalv1.RaiseTicketRequest{
			Kind:    biomedicalv1.TicketKind_TICKET_KIND_CORRECTIVE,
			AssetId: asset.GetAssetId(), Symptom: "noise",
			Priority: biomedicalv1.Priority_PRIORITY_LOW,
			Impact:   biomedicalv1.Impact_IMPACT_NONE,
		}))
	if got := connectCode(err); got != connect.CodePermissionDenied {
		t.Fatalf("a clerk raising a ticket returned %v, want PermissionDenied",
			got)
	}
}

func TestAnExpiryListHoldsBothContractsAndCalibrations(t *testing.T) {
	h := newBioHarness(t)
	ctx := context.Background()

	// A contract running out inside the horizon, and a calibration that
	// lapsed last week. The person who chases one chases the other, and two
	// screens means one of them is never looked at.
	asset := h.ventilator(t, "BME-0001", "icu-bay-1")
	now := time.Now().UTC()
	if _, err := h.bio.RecordContract(ctx, withFacility(h.managerToken(),
		h.facility, &biomedicalv1.RecordContractRequest{
			AssetId:   asset.GetAssetId(),
			Kind:      biomedicalv1.ContractKind_CONTRACT_KIND_AMC,
			Reference: "AMC/2025/11", VendorName: "Draeger India",
			StartsOn:      timestamppb.New(now.Add(-300 * 24 * time.Hour)),
			EndsOn:        timestamppb.New(now.Add(30 * 24 * time.Hour)),
			ResponseHours: 8, ResolutionHours: 48,
		})); err != nil {
		t.Fatalf("RecordContract: %v", err)
	}
	h.register(t, &biomedicalv1.RegisterAssetRequest{
		Tag: "BME-AN-1", Serial: "AN-1", Make: "Roche", Model: "Cobas",
		Criticality:         biomedicalv1.Criticality_CRITICALITY_IMPORTANT,
		LocationId:          "lab-1",
		CalibrationRequired: true,
		CalibrationDue:      timestamppb.New(now.Add(-7 * 24 * time.Hour)),
	})

	out, err := h.bio.ListExpiryReminders(ctx, withFacility(h.engineerToken(),
		h.facility, &biomedicalv1.ListExpiryRemindersRequest{}))
	if err != nil {
		t.Fatalf("ListExpiryReminders: %v", err)
	}

	kinds := map[biomedicalv1.ExpiryKind]int32{}
	for _, expiry := range out.Msg.GetExpiries() {
		kinds[expiry.GetKind()]++
		if expiry.GetAssetTag() == "" {
			t.Fatal("a reminder names a UUID rather than the machine")
		}
	}
	if kinds[biomedicalv1.ExpiryKind_EXPIRY_KIND_CONTRACT] != 1 ||
		kinds[biomedicalv1.ExpiryKind_EXPIRY_KIND_CALIBRATION] != 1 {
		t.Fatalf("expiries = %v, want one of each kind", kinds)
	}
}

func TestAnotherTenantReachesNoEquipment(t *testing.T) {
	h := newBioHarness(t)
	ctx := context.Background()

	asset := h.ventilator(t, "BME-0001", "icu-bay-1")

	other := h.provisionOtherTenant(t)
	_, err := h.bio.GetAsset(ctx, as(other+":bme-x:biomedical_manager",
		&biomedicalv1.GetAssetRequest{AssetId: asset.GetAssetId()}))
	if err == nil {
		t.Fatal("another tenant read this hospital's equipment register")
	}
	// NOT_FOUND rather than PERMISSION_DENIED: a probe must not be able to
	// confirm that an identifier exists.
	if got := connectCode(err); got != connect.CodeNotFound &&
		got != connect.CodePermissionDenied {
		t.Fatalf("cross-tenant read returned %v", got)
	}
}

func (h *bioHarness) provisionOtherTenant(t *testing.T) string {
	t.Helper()

	tenant, err := h.org.CreateTenant(context.Background(),
		as(platformOperatorToken(), &organizationv1.CreateTenantRequest{
			DisplayName: "Fortis Group", LegalJurisdiction: "IN",
			DefaultLocale: "en-IN", TimeZone: "Asia/Kolkata",
		}))
	if err != nil {
		t.Fatalf("CreateTenant(other): %v", err)
	}
	id := tenant.Msg.GetTenant().GetTenantId()

	repo := orgpostgres.New(pgtx.NewManager(h.dbPool))
	scope := authctx.NewSession(authctx.Session{
		SubjectID: "setup", TenantID: id,
	}).TenantScope()
	now := time.Now().UTC()
	entitlement, err := orgdomain.NewEntitlement(uuid.NewString(), id, "",
		"biomedical", true, now.Add(-time.Hour), time.Time{}, "setup", now)
	if err != nil {
		t.Fatalf("NewEntitlement(other): %v", err)
	}
	if err := repo.InsertEntitlement(context.Background(), scope,
		entitlement); err != nil {
		t.Fatalf("InsertEntitlement(other): %v", err)
	}
	return id
}
