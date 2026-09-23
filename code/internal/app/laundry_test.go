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

	laundryv1 "github.com/ppusapati/health/code/gen/go/healthcare/laundry/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/laundry/v1/laundryv1connect"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/organization/v1/organizationv1connect"
	"github.com/ppusapati/health/code/internal/app"
	"github.com/ppusapati/health/code/internal/identity_access/adapters/devauth"
	lndapp "github.com/ppusapati/health/code/internal/laundry/application"
	orgpostgres "github.com/ppusapati/health/code/internal/organization/adapters/postgres"
	orgdomain "github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
	platformapitransport "github.com/ppusapati/health/code/internal/platform_api/transport"
)

// Laundry and linen (SRS-LND-001 … 007), end to end.
//
// The domain tests hold the rules and the repository tests hold the schema.
// These hold what only the assembled stack shows: that a par level is
// approved by somebody outside the laundry, that a ward cannot sign for a
// delivery it also sent, that a write-off is decided by a second person — and,
// the two this family exists for, that infected linen cannot reach an
// ordinary wash and that linen from a wash that did not pass cannot reach a
// ward.

type lndHarness struct {
	pool    *pgxpool.Pool
	laundry laundryv1connect.LaundryServiceClient
	org     organizationv1connect.OrganizationServiceClient

	tenantID string
	facility string
	wardID   string
}

func newLndHarness(t *testing.T) *lndHarness {
	return newLndHarnessWith(t, lndapp.Config{})
}

func newLndHarnessWith(t *testing.T, config lndapp.Config) *lndHarness {
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
		Laundry: config,
	})
	if built.Err != nil {
		t.Fatalf("app.New: %v", built.Err)
	}

	server := httptest.NewServer(h2c.NewHandler(built.Handler, &http2.Server{}))
	t.Cleanup(server.Close)

	h := &lndHarness{
		pool: pool,
		laundry: laundryv1connect.NewLaundryServiceClient(
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
	h.wardID = h.orgUnit(t, "ward-3", "Ward 3")

	for _, module := range []string{"laundry", "organization"} {
		h.entitleLnd(t, module)
	}
	return h
}

func (h *lndHarness) entitleLnd(t *testing.T, module string) {
	t.Helper()

	repo := orgpostgres.New(pgtx.NewManager(h.pool))
	scope := h.setupScope()

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

func (h *lndHarness) setupScope() authctx.TenantScope {
	return authctx.NewSession(authctx.Session{
		SubjectID: "setup", TenantID: h.tenantID,
	}).TenantScope()
}

// orgUnit creates a ward directly through the organisation repository. The
// laundry's unit check reads this, and a par recorded against a ward that is
// not here is the thing the check exists to refuse.
func (h *lndHarness) orgUnit(t *testing.T, code, name string) string {
	t.Helper()

	repo := orgpostgres.New(pgtx.NewManager(h.pool))
	unit, err := orgdomain.NewOrgUnit(uuid.NewString(), h.tenantID,
		h.facility, orgdomain.UnitCareLocation, code, name, "",
		time.Now().UTC().Add(-time.Hour), time.Time{}, false,
		time.Now().UTC())
	if err != nil {
		t.Fatalf("NewOrgUnit: %v", err)
	}
	if err := repo.InsertOrgUnit(context.Background(), h.setupScope(),
		unit); err != nil {
		t.Fatalf("InsertOrgUnit: %v", err)
	}
	return unit.ID
}

func (h *lndHarness) operatorToken() string {
	return h.tenantID + ":lnd-op:laundry_operator:" + h.facility
}

func (h *lndHarness) otherOperatorToken() string {
	return h.tenantID + ":lnd-op-2:laundry_operator:" + h.facility
}

func (h *lndHarness) managerToken() string {
	return h.tenantID + ":lnd-mgr:laundry_manager:" + h.facility
}

func (h *lndHarness) otherManagerToken() string {
	return h.tenantID + ":lnd-mgr-2:laundry_manager:" + h.facility
}

func (h *lndHarness) materialsToken() string {
	return h.tenantID + ":mat-mgr:materials_manager:" + h.facility
}

func (h *lndHarness) nurseToken() string {
	return h.tenantID + ":nurse-1:nurse:" + h.facility
}

// otherNurseToken is a second nurse, who reported nothing. It exists so the
// two locks can be told apart: the domain refuses the reporter their own
// approval, and the permission refuses the ward.
func (h *lndHarness) otherNurseToken() string {
	return h.tenantID + ":nurse-2:nurse:" + h.facility
}

func (h *lndHarness) clerkToken() string {
	return h.tenantID + ":clerk-1:registration_clerk:" + h.facility
}

// item registers a linen item as the laundry manager.
func (h *lndHarness) item(t *testing.T, code string, tracked bool) {
	t.Helper()
	if _, err := h.laundry.ConfigureLinenItem(context.Background(),
		withFacility(h.managerToken(), h.facility,
			&laundryv1.ConfigureLinenItemRequest{
				Code: code, Name: code,
				Category:    laundryv1.LinenCategory_LINEN_CATEGORY_BEDDING,
				UnitWeightG: 600, ReplacementCostMinor: 42000,
				Tracked: tracked,
			})); err != nil {
		t.Fatalf("ConfigureLinenItem %s: %v", code, err)
	}
}

// collection records soiled linen from the ward.
func (h *lndHarness) collection(t *testing.T,
	class laundryv1.SoilClass) string {

	t.Helper()
	req := &laundryv1.RecordCollectionRequest{
		UnitId: h.wardID, UnitName: "Ward 3", FacilityId: h.facility,
		SoilClass: class, BagCount: 2, WeightG: 18000,
		Lines: []*laundryv1.CollectionLine{
			{ItemCode: "SHEET-FLAT", Quantity: 20},
		},
	}
	if class == laundryv1.SoilClass_SOIL_CLASS_INFECTED {
		req.Lines, req.BagCount, req.WeightG = nil, 1, 9000
	}
	out, err := h.laundry.RecordCollection(context.Background(),
		withFacility(h.nurseToken(), h.facility, req))
	if err != nil {
		t.Fatalf("RecordCollection: %v", err)
	}
	return out.Msg.GetCollection().GetCollectionId()
}

// passedWash runs one collection through a wash that passes.
func (h *lndHarness) passedWash(t *testing.T) string {
	t.Helper()
	ctx := context.Background()

	opened, err := h.laundry.OpenWashBatch(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.OpenWashBatchRequest{
				Reference: "W-1001", FacilityId: h.facility,
				MachineId: "washer-2",
				Cycle:     laundryv1.WashCycle_WASH_CYCLE_HOT,
			}))
	if err != nil {
		t.Fatalf("OpenWashBatch: %v", err)
	}
	batchID := opened.Msg.GetBatch().GetBatchId()

	if _, err := h.laundry.LoadWashBatch(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.LoadWashBatchRequest{
				BatchId: batchID,
				CollectionId: h.collection(t,
					laundryv1.SoilClass_SOIL_CLASS_USED),
			})); err != nil {
		t.Fatalf("LoadWashBatch: %v", err)
	}
	if _, err := h.laundry.StartWashBatch(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.StartWashBatchRequest{
				BatchId: batchID,
			})); err != nil {
		t.Fatalf("StartWashBatch: %v", err)
	}
	if _, err := h.laundry.CompleteWashBatch(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.CompleteWashBatchRequest{
				BatchId: batchID, Passed: true,
				Outcome:          "71C held for 3 minutes",
				PeakTemperatureC: 74, HoldMinutes: 3,
			})); err != nil {
		t.Fatalf("CompleteWashBatch: %v", err)
	}
	return batchID
}

// SRS-LND-005, SRS-LND-003. The first rule this family exists for: infected
// linen cannot reach an ordinary wash, and nobody opens the bag.
func TestInfectedLinenCannotReachAnOrdinaryWashAndIsNeverReCounted(
	t *testing.T) {

	h := newLndHarness(t)
	ctx := context.Background()
	h.item(t, "SHEET-FLAT", false)

	infected := h.collection(t, laundryv1.SoilClass_SOIL_CLASS_INFECTED)

	// The handling instruction travels on the collection, derived from the
	// class rather than typed beside it, so the worklist a porter reads and
	// the cycle the machine runs cannot disagree.
	pending, err := h.laundry.ListCollections(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.ListCollectionsRequest{PendingOnly: true}))
	if err != nil {
		t.Fatalf("ListCollections: %v", err)
	}
	if len(pending.Msg.GetCollections()) != 1 {
		t.Fatalf("want one pending collection, got %+v",
			pending.Msg.GetCollections())
	}
	first := pending.Msg.GetCollections()[0]
	if !strings.Contains(first.GetHandling(), "barrier") ||
		first.GetSoilClass() !=
			laundryv1.SoilClass_SOIL_CLASS_INFECTED {
		t.Fatalf("the handling did not travel: %+v", first)
	}

	// A standard programme does not dissolve the inner bag and does not
	// reach disinfection temperature; the load comes out contaminated and
	// indistinguishable from clean.
	for _, cycle := range []laundryv1.WashCycle{
		laundryv1.WashCycle_WASH_CYCLE_STANDARD,
		laundryv1.WashCycle_WASH_CYCLE_HOT,
		laundryv1.WashCycle_WASH_CYCLE_DELICATE,
	} {
		opened, err := h.laundry.OpenWashBatch(ctx,
			withFacility(h.operatorToken(), h.facility,
				&laundryv1.OpenWashBatchRequest{
					FacilityId: h.facility, MachineId: "washer-1",
					Cycle: cycle,
				}))
		if err != nil {
			t.Fatalf("OpenWashBatch: %v", err)
		}
		if _, err := h.laundry.LoadWashBatch(ctx,
			withFacility(h.operatorToken(), h.facility,
				&laundryv1.LoadWashBatchRequest{
					BatchId:      opened.Msg.GetBatch().GetBatchId(),
					CollectionId: infected,
				})); err == nil {
			t.Fatalf("infected linen was loaded into a %v cycle", cycle)
		}
	}

	// Re-counting it means opening the bag. The declaration made at the
	// bedside is the only count anybody is going to get, and a system that
	// allowed the correction would be one where somebody was asked to make
	// it.
	if _, err := h.laundry.RecountCollection(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.RecountCollectionRequest{
				CollectionId: infected,
				Lines: []*laundryv1.CollectionLine{
					{ItemCode: "SHEET-FLAT", Quantity: 12},
				},
			})); err == nil {
		t.Fatal("infected linen was re-counted at the laundry")
	}

	// The barrier machine takes it, and the batch knows what it carries.
	barrier, err := h.laundry.OpenWashBatch(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.OpenWashBatchRequest{
				FacilityId: h.facility, MachineId: "washer-barrier",
				Cycle: laundryv1.WashCycle_WASH_CYCLE_BARRIER,
			}))
	if err != nil {
		t.Fatalf("OpenWashBatch: %v", err)
	}
	loaded, err := h.laundry.LoadWashBatch(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.LoadWashBatchRequest{
				BatchId:      barrier.Msg.GetBatch().GetBatchId(),
				CollectionId: infected,
			}))
	if err != nil {
		t.Fatalf("LoadWashBatch: %v", err)
	}
	if !loaded.Msg.GetBatch().GetInfected() ||
		len(loaded.Msg.GetBatch().GetCollectionIds()) != 1 {
		t.Fatalf("the barrier batch did not take the load: %+v",
			loaded.Msg.GetBatch())
	}

	// Ordinary linen is sorted and counted, and the correction is ordinary
	// work.
	ordinary := h.collection(t, laundryv1.SoilClass_SOIL_CLASS_USED)
	recounted, err := h.laundry.RecountCollection(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.RecountCollectionRequest{
				CollectionId: ordinary,
				Lines: []*laundryv1.CollectionLine{
					{ItemCode: "SHEET-FLAT", Quantity: 18},
				},
			}))
	if err != nil {
		t.Fatalf("RecountCollection: %v", err)
	}
	if len(recounted.Msg.GetCollection().GetLines()) != 1 ||
		recounted.Msg.GetCollection().GetLines()[0].GetQuantity() != 18 {
		t.Fatalf("the recount did not stick: %+v",
			recounted.Msg.GetCollection())
	}
}

// SRS-LND-003, SRS-LND-004. The second rule: linen from a wash that did not
// pass never reaches a ward, and the wards it would have reached are named.
func TestLinenFromAFailedWashNeverReachesAWard(t *testing.T) {
	h := newLndHarness(t)
	ctx := context.Background()
	h.item(t, "SHEET-FLAT", false)

	opened, err := h.laundry.OpenWashBatch(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.OpenWashBatchRequest{
				Reference: "W-2001", FacilityId: h.facility,
				MachineId: "washer-2",
				Cycle:     laundryv1.WashCycle_WASH_CYCLE_HOT,
			}))
	if err != nil {
		t.Fatalf("OpenWashBatch: %v", err)
	}
	batchID := opened.Msg.GetBatch().GetBatchId()

	issue := &laundryv1.IssueLinenRequest{
		BatchId: batchID, UnitId: h.wardID, FacilityId: h.facility,
		Lines: []*laundryv1.IssueLine{
			{ItemCode: "SHEET-FLAT", Quantity: 40},
		},
	}

	// Nothing has been washed yet.
	if _, err := h.laundry.IssueLinen(ctx,
		withFacility(h.operatorToken(), h.facility, issue)); err == nil {
		t.Fatal("linen was issued from a batch still loading")
	}

	// An empty batch that later read as passed would be a batch somebody
	// could issue from without any linen having been washed.
	if _, err := h.laundry.StartWashBatch(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.StartWashBatchRequest{
				BatchId: batchID,
			})); err == nil {
		t.Fatal("an empty batch was started")
	}

	if _, err := h.laundry.LoadWashBatch(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.LoadWashBatchRequest{
				BatchId: batchID,
				CollectionId: h.collection(t,
					laundryv1.SoilClass_SOIL_CLASS_USED),
			})); err != nil {
		t.Fatalf("LoadWashBatch: %v", err)
	}
	if _, err := h.laundry.StartWashBatch(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.StartWashBatchRequest{
				BatchId: batchID,
			})); err != nil {
		t.Fatalf("StartWashBatch: %v", err)
	}

	// An outcome of "failed" with nothing beside it tells the person
	// deciding whether to rewash or condemn the load nothing at all.
	if _, err := h.laundry.CompleteWashBatch(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.CompleteWashBatchRequest{
				BatchId: batchID, Passed: false,
				Outcome: "did not finish",
			})); err == nil {
		t.Fatal("a failed wash was recorded with no exception")
	}

	failed, err := h.laundry.CompleteWashBatch(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.CompleteWashBatchRequest{
				BatchId: batchID, Passed: false,
				Outcome:          "cycle aborted at 40 minutes",
				PeakTemperatureC: 58,
				Exceptions: []*laundryv1.BatchException{
					{Code: "TEMP_NOT_HELD",
						Detail: "peaked at 58C, needs 71C"},
				},
			}))
	if err != nil {
		t.Fatalf("CompleteWashBatch: %v", err)
	}
	if failed.Msg.GetBatch().GetState() !=
		laundryv1.BatchState_BATCH_STATE_FAILED ||
		len(failed.Msg.GetBatch().GetExceptions()) != 1 {
		t.Fatalf("the failure did not stick: %+v", failed.Msg.GetBatch())
	}

	// Linen from a wash that did not pass looks exactly like clean linen,
	// and the ward that gets it has no way of telling.
	if _, err := h.laundry.IssueLinen(ctx,
		withFacility(h.operatorToken(), h.facility, issue)); err == nil {
		t.Fatal("linen was issued from a failed wash")
	}

	// The reason the chain is worth retaining: a failed batch is linen that
	// may already be on its way back, and this is the answer to "whose".
	affected, err := h.laundry.ListAffectedUnits(ctx,
		withFacility(h.managerToken(), h.facility,
			&laundryv1.ListAffectedUnitsRequest{BatchId: batchID}))
	if err != nil {
		t.Fatalf("ListAffectedUnits: %v", err)
	}
	if len(affected.Msg.GetUnitIds()) != 1 ||
		affected.Msg.GetUnitIds()[0] != h.wardID {
		t.Fatalf("want the ward named, got %+v", affected.Msg.GetUnitIds())
	}

	// And it escalates durably, naming how many units are affected. A wash
	// recorded as failed with the paging silently switched off is linen the
	// wards in it are already making beds with.
	var noticeKind, noticeSummary string
	if err := h.pool.QueryRow(ctx, `
		SELECT subject_kind, summary FROM platform_escalation.notice
		WHERE tenant_id = $1 AND subject_id = $2`,
		h.tenantID, batchID).Scan(&noticeKind, &noticeSummary); err != nil {
		t.Fatalf("read the escalation: %v", err)
	}
	if noticeKind != "linen_wash_failed" ||
		!strings.Contains(noticeSummary, "1 unit(s) affected") ||
		!strings.Contains(noticeSummary, "washer-2") {
		t.Fatalf("the notice does not say what failed: %q %q",
			noticeKind, noticeSummary)
	}

	// A rewash keeps the failure on the record. A hospital with no way of
	// noticing that one machine fails every third load is a hospital that
	// keeps using it.
	retry, err := h.laundry.OpenWashBatch(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.OpenWashBatchRequest{
				Reference: "W-2002", FacilityId: h.facility,
				MachineId: "washer-3",
				Cycle:     laundryv1.WashCycle_WASH_CYCLE_HOT,
			}))
	if err != nil {
		t.Fatalf("OpenWashBatch: %v", err)
	}
	if _, err := h.laundry.RewashBatch(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.RewashBatchRequest{
				FailedBatchId: batchID,
				IntoBatchId:   retry.Msg.GetBatch().GetBatchId(),
			})); err != nil {
		t.Fatalf("RewashBatch: %v", err)
	}

	original, err := h.laundry.GetWashBatch(ctx,
		withFacility(h.managerToken(), h.facility,
			&laundryv1.GetWashBatchRequest{BatchId: batchID}))
	if err != nil {
		t.Fatalf("GetWashBatch: %v", err)
	}
	if original.Msg.GetBatch().GetState() !=
		laundryv1.BatchState_BATCH_STATE_REWASHED ||
		len(original.Msg.GetBatch().GetExceptions()) != 1 {
		t.Fatalf("the failure was erased: %+v", original.Msg.GetBatch())
	}

	// And the report counts the failure apart from the rewash.
	report, err := h.laundry.GetWashReport(ctx,
		withFacility(h.managerToken(), h.facility,
			&laundryv1.GetWashReportRequest{FacilityId: h.facility}))
	if err != nil {
		t.Fatalf("GetWashReport: %v", err)
	}
	summary := report.Msg.GetSummary()
	if summary.GetRewashed() != 1 || summary.GetWithExceptions() != 1 ||
		summary.GetPassed() != 0 {
		t.Fatalf("the rewash was counted as a pass: %+v", summary)
	}
}

// SRS-LND-001. The par is drafted in the laundry and put in force outside it.
func TestAParLevelIsApprovedOutsideTheLaundry(t *testing.T) {
	h := newLndHarnessWith(t, lndapp.Config{RequireKnownUnit: true})
	ctx := context.Background()
	h.item(t, "SHEET-FLAT", false)
	h.item(t, "PILLOWCASE", false)

	// Linen recorded against a ward that is not there is a balance that
	// adds up for somewhere nobody can go and look.
	if _, err := h.laundry.SetParLevel(ctx,
		withFacility(h.managerToken(), h.facility,
			&laundryv1.SetParLevelRequest{
				UnitId: "ward-nowhere", FacilityId: h.facility,
				Lines: []*laundryv1.ParLine{
					{ItemCode: "SHEET-FLAT", Quantity: 60},
				},
			})); err == nil {
		t.Fatal("a par was set for a ward the hospital does not have")
	}

	drafted, err := h.laundry.SetParLevel(ctx,
		withFacility(h.managerToken(), h.facility,
			&laundryv1.SetParLevelRequest{
				UnitId: h.wardID, UnitName: "Ward 3",
				FacilityId: h.facility,
				Lines: []*laundryv1.ParLine{
					{ItemCode: "SHEET-FLAT", Quantity: 60, ReorderAt: 20},
					{ItemCode: "PILLOWCASE", Quantity: 60},
				},
			}))
	if err != nil {
		t.Fatalf("SetParLevel: %v", err)
	}
	parID := drafted.Msg.GetPar().GetParId()
	if drafted.Msg.GetPar().GetRevision() != 1 ||
		drafted.Msg.GetPar().GetApproved() {
		t.Fatalf("a drafted par is already in force: %+v",
			drafted.Msg.GetPar())
	}

	// An operator does not write the par they are judged against.
	if _, err := h.laundry.SetParLevel(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.SetParLevelRequest{
				UnitId: h.wardID, FacilityId: h.facility,
				Lines: []*laundryv1.ParLine{
					{ItemCode: "SHEET-FLAT", Quantity: 600},
				},
			})); err == nil {
		t.Fatal("a laundry operator set a par level")
	}

	// The manager who wrote it cannot approve it — the domain refuses the
	// author.
	if _, err := h.laundry.ApproveParLevel(ctx,
		withFacility(h.managerToken(), h.facility,
			&laundryv1.ApproveParLevelRequest{
				ParId: parID,
			})); err == nil {
		t.Fatal("the author approved their own par level")
	}
	// And neither can a second laundry manager. This is the other lock: a
	// par is a standing purchasing commitment, and the laundry does not
	// sign its own.
	if _, err := h.laundry.ApproveParLevel(ctx,
		withFacility(h.otherManagerToken(), h.facility,
			&laundryv1.ApproveParLevelRequest{
				ParId: parID,
			})); err == nil {
		t.Fatal("the laundry approved its own par level")
	}

	approved, err := h.laundry.ApproveParLevel(ctx,
		withFacility(h.materialsToken(), h.facility,
			&laundryv1.ApproveParLevelRequest{
				ParId: parID,
				EffectiveFrom: timestamppb.New(
					time.Now().UTC().Add(-time.Hour)),
			}))
	if err != nil {
		t.Fatalf("ApproveParLevel: %v", err)
	}
	if approved.Msg.GetPar().GetApprovedBy() != "mat-mgr" {
		t.Fatalf("the approver was not recorded: %+v",
			approved.Msg.GetPar())
	}

	// A second revision supersedes the first, so only one par is ever in
	// force.
	second, err := h.laundry.SetParLevel(ctx,
		withFacility(h.managerToken(), h.facility,
			&laundryv1.SetParLevelRequest{
				UnitId: h.wardID, FacilityId: h.facility,
				Lines: []*laundryv1.ParLine{
					{ItemCode: "SHEET-FLAT", Quantity: 90, ReorderAt: 30},
				},
			}))
	if err != nil {
		t.Fatalf("SetParLevel: %v", err)
	}
	if second.Msg.GetPar().GetRevision() != 2 {
		t.Fatalf("want revision 2, got %d", second.Msg.GetPar().GetRevision())
	}
	if _, err := h.laundry.ApproveParLevel(ctx,
		withFacility(h.materialsToken(), h.facility,
			&laundryv1.ApproveParLevelRequest{
				ParId: second.Msg.GetPar().GetParId(),
				EffectiveFrom: timestamppb.New(
					time.Now().UTC().Add(-time.Minute)),
			})); err != nil {
		t.Fatalf("ApproveParLevel: %v", err)
	}

	live, err := h.laundry.GetParInForce(ctx,
		withFacility(h.nurseToken(), h.facility,
			&laundryv1.GetParInForceRequest{UnitId: h.wardID}))
	if err != nil {
		t.Fatalf("GetParInForce: %v", err)
	}
	if live.Msg.GetPar().GetRevision() != 2 {
		t.Fatalf("want revision 2 in force, got %+v", live.Msg.GetPar())
	}
	listed, err := h.laundry.ListParLevels(ctx,
		withFacility(h.nurseToken(), h.facility,
			&laundryv1.ListParLevelsRequest{LiveOnly: true}))
	if err != nil {
		t.Fatalf("ListParLevels: %v", err)
	}
	if len(listed.Msg.GetPars()) != 1 {
		t.Fatalf("want one live par, got %d", len(listed.Msg.GetPars()))
	}
}

// SRS-LND-004. The balance is derived from what moved, and the ward signs for
// its own linen.
func TestAUnitsStockIsDerivedAndSignedForBySomebodyElse(t *testing.T) {
	h := newLndHarness(t)
	ctx := context.Background()
	h.item(t, "SHEET-FLAT", false)
	h.item(t, "PILLOWCASE", false)

	batchID := h.passedWash(t)

	issued, err := h.laundry.IssueLinen(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.IssueLinenRequest{
				BatchId: batchID, UnitId: h.wardID, UnitName: "Ward 3",
				FacilityId: h.facility,
				Lines: []*laundryv1.IssueLine{
					{ItemCode: "SHEET-FLAT", Quantity: 50},
					{ItemCode: "PILLOWCASE", Quantity: 50},
				},
			}))
	if err != nil {
		t.Fatalf("IssueLinen: %v", err)
	}
	issueID := issued.Msg.GetIssue().GetIssueId()
	// The reference comes off the batch the server read, not off anything
	// the caller sent: a delivery note that named a wash the caller
	// asserted would be a delivery note nobody could check.
	if issued.Msg.GetIssue().GetBatchId() != batchID ||
		issued.Msg.GetIssue().GetBatchReference() != "W-1001" {
		t.Fatalf("the issue lost its wash: %+v", issued.Msg.GetIssue())
	}

	// A delivery signed for by whoever brought it is the same claim made
	// twice, and a ward that never got its linen has no way to say so. The
	// operator does not hold the permission, and a second operator who did
	// would be somebody with an interest in the linen having arrived.
	if _, err := h.laundry.ReceiveLinen(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.ReceiveLinenRequest{
				IssueId: issueID,
			})); err == nil {
		t.Fatal("the laundry signed for its own delivery")
	}
	if _, err := h.laundry.ReceiveLinen(ctx,
		withFacility(h.otherOperatorToken(), h.facility,
			&laundryv1.ReceiveLinenRequest{
				IssueId: issueID,
			})); err == nil {
		t.Fatal("a second operator signed for the laundry's delivery")
	}

	// Until somebody signs, it is outstanding — and it still counts towards
	// the ward's stock, because linen that left the laundry is linen the
	// ward has.
	outstanding, err := h.laundry.ListLinenIssues(ctx,
		withFacility(h.managerToken(), h.facility,
			&laundryv1.ListLinenIssuesRequest{OutstandingOnly: true}))
	if err != nil {
		t.Fatalf("ListLinenIssues: %v", err)
	}
	if len(outstanding.Msg.GetIssues()) != 1 {
		t.Fatalf("want one outstanding issue, got %+v",
			outstanding.Msg.GetIssues())
	}

	if _, err := h.laundry.ReceiveLinen(ctx,
		withFacility(h.nurseToken(), h.facility,
			&laundryv1.ReceiveLinenRequest{
				IssueId: issueID,
			})); err != nil {
		t.Fatalf("ReceiveLinen: %v", err)
	}

	// The ward sent twenty sheets back in the collection that fed the wash.
	stock, err := h.laundry.GetUnitStock(ctx,
		withFacility(h.nurseToken(), h.facility,
			&laundryv1.GetUnitStockRequest{UnitId: h.wardID}))
	if err != nil {
		t.Fatalf("GetUnitStock: %v", err)
	}
	onHand := map[string]int32{}
	for _, line := range stock.Msg.GetOnHand() {
		onHand[line.GetItemCode()] = line.GetQuantity()
	}
	if onHand["SHEET-FLAT"] != 30 || onHand["PILLOWCASE"] != 50 {
		t.Fatalf("the balance is wrong: %+v", stock.Msg.GetOnHand())
	}
	// A ward with no par reports that rather than an empty shortfall list,
	// which would read as a ward that has everything it needs.
	if !stock.Msg.GetNoPar() || len(stock.Msg.GetShortfalls()) != 0 {
		t.Fatalf("a ward with no par reported a shortfall: %+v",
			stock.Msg)
	}
}

// SRS-LND-006. A write-off is decided by a second person, and what turns up
// again is recovered rather than deleted.
func TestAWriteOffIsDecidedBySomebodyElseAndRecoveryIsItsOwnFact(
	t *testing.T) {

	h := newLndHarnessWith(t, lndapp.Config{
		LossApprovalThresholdMinor: 10000,
	})
	ctx := context.Background()
	h.item(t, "SHEET-FLAT", false)

	reported, err := h.laundry.ReportLinenLoss(ctx,
		withFacility(h.nurseToken(), h.facility,
			&laundryv1.ReportLinenLossRequest{
				UnitId: h.wardID, FacilityId: h.facility,
				ItemCode: "SHEET-FLAT", Quantity: 4,
				Kind:   laundryv1.LossKind_LOSS_KIND_CONDEMNED,
				Reason: "torn beyond repair",
			}))
	if err != nil {
		t.Fatalf("ReportLinenLoss: %v", err)
	}
	lossID := reported.Msg.GetLoss().GetLossId()
	// The value is pinned from the master rather than typed, so a price
	// list changed in March cannot restate what January's losses cost.
	if reported.Msg.GetLoss().GetValueMinor() != 42000 ||
		!reported.Msg.GetLoss().GetApprovalRequired() {
		t.Fatalf("the loss did not pin its value: %+v",
			reported.Msg.GetLoss())
	}

	// A write-off with no reason is a number in an annual report that
	// nobody can act on.
	if _, err := h.laundry.ReportLinenLoss(ctx,
		withFacility(h.nurseToken(), h.facility,
			&laundryv1.ReportLinenLossRequest{
				UnitId: h.wardID, ItemCode: "SHEET-FLAT", Quantity: 1,
				Kind: laundryv1.LossKind_LOSS_KIND_MISSING,
			})); err == nil {
		t.Fatal("a write-off was reported with no reason")
	}

	// A ward sister writing off her own ward's linen and approving it
	// herself is the whole of why the requirement says "with approval where
	// required".
	if _, err := h.laundry.ApproveLinenLoss(ctx,
		withFacility(h.nurseToken(), h.facility,
			&laundryv1.ApproveLinenLossRequest{
				LossId: lossID, Approve: true,
			})); err == nil {
		t.Fatal("the reporter approved their own write-off")
	}
	// An operator cannot either: one who could write off the linen they
	// lost is one whose losses are always nil.
	if _, err := h.laundry.ApproveLinenLoss(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.ApproveLinenLossRequest{
				LossId: lossID, Approve: true,
			})); err == nil {
		t.Fatal("a laundry operator approved a write-off")
	}

	// Nor can the nurse at the next bed. This is the other lock: the
	// domain's rule only stops one person approving their own report, and a
	// write-off is a decision the ward does not make about itself. Without
	// this assertion, granting nurses lnd.loss.approve would change nothing
	// any test could see.
	if _, err := h.laundry.ApproveLinenLoss(ctx,
		withFacility(h.otherNurseToken(), h.facility,
			&laundryv1.ApproveLinenLossRequest{
				LossId: lossID, Approve: true,
			})); err == nil {
		t.Fatal("a second ward nurse approved the ward's write-off")
	}

	// Until somebody approves it, it moves no balance.
	before, err := h.laundry.GetLinenLossReport(ctx,
		withFacility(h.managerToken(), h.facility,
			&laundryv1.GetLinenLossReportRequest{FacilityId: h.facility}))
	if err != nil {
		t.Fatalf("GetLinenLossReport: %v", err)
	}
	if before.Msg.GetSummary().GetPieces() != 0 ||
		before.Msg.GetSummary().GetAwaitingApproval() != 1 {
		t.Fatalf("an undecided write-off moved the total: %+v",
			before.Msg.GetSummary())
	}

	queue, err := h.laundry.ListPendingLossApprovals(ctx,
		withFacility(h.managerToken(), h.facility,
			&laundryv1.ListPendingLossApprovalsRequest{
				FacilityId: h.facility,
			}))
	if err != nil {
		t.Fatalf("ListPendingLossApprovals: %v", err)
	}
	if len(queue.Msg.GetLosses()) != 1 {
		t.Fatalf("want the write-off queued, got %+v", queue.Msg.GetLosses())
	}

	if _, err := h.laundry.ApproveLinenLoss(ctx,
		withFacility(h.managerToken(), h.facility,
			&laundryv1.ApproveLinenLossRequest{
				LossId: lossID, Approve: true, Note: "agreed",
			})); err != nil {
		t.Fatalf("ApproveLinenLoss: %v", err)
	}

	// Missing linen that turns up is recovered rather than deleted: a loss
	// figure has to be able to say "we lost four hundred and found sixty".
	missing, err := h.laundry.ReportLinenLoss(ctx,
		withFacility(h.nurseToken(), h.facility,
			&laundryv1.ReportLinenLossRequest{
				UnitId: h.wardID, FacilityId: h.facility,
				ItemCode: "SHEET-FLAT", Quantity: 60,
				Kind:   laundryv1.LossKind_LOSS_KIND_MISSING,
				Reason: "not returned after discharge",
			}))
	if err != nil {
		t.Fatalf("ReportLinenLoss: %v", err)
	}
	if _, err := h.laundry.RecoverLinenLoss(ctx,
		withFacility(h.nurseToken(), h.facility,
			&laundryv1.RecoverLinenLossRequest{
				LossId: missing.Msg.GetLoss().GetLossId(),
				Note:   "found in a store cupboard",
			})); err != nil {
		t.Fatalf("RecoverLinenLoss: %v", err)
	}
	// And a condemned sheet does not turn up again.
	if _, err := h.laundry.RecoverLinenLoss(ctx,
		withFacility(h.nurseToken(), h.facility,
			&laundryv1.RecoverLinenLossRequest{
				LossId: lossID, Note: "found",
			})); err == nil {
		t.Fatal("condemned linen was recovered")
	}

	after, err := h.laundry.GetLinenLossReport(ctx,
		withFacility(h.managerToken(), h.facility,
			&laundryv1.GetLinenLossReportRequest{FacilityId: h.facility}))
	if err != nil {
		t.Fatalf("GetLinenLossReport: %v", err)
	}
	summary := after.Msg.GetSummary()
	if summary.GetPieces() != 4 || summary.GetCondemned() != 4 ||
		summary.GetMissing() != 0 || summary.GetRecovered() != 60 {
		t.Fatalf("the loss report is wrong: %+v", summary)
	}
	if summary.GetValueMinor() != 4*42000 {
		t.Fatalf("the value is wrong: %+v", summary)
	}
}

// SRS-LND-007. A tag goes on a tracked item and nothing else, and its trail
// says who scanned it.
func TestATagGoesOnATrackedItemAndItsTrailNamesWhoScannedIt(t *testing.T) {
	h := newLndHarnessWith(t, lndapp.Config{
		StaleTrackedAfter: 14 * 24 * time.Hour,
	})
	ctx := context.Background()
	h.item(t, "SHEET-FLAT", false)
	h.item(t, "SCRUB-TOP", true)

	// A custody trail for one sheet out of four thousand reads as a system
	// that lost the other three thousand nine hundred and ninety-nine.
	if _, err := h.laundry.RegisterTag(ctx,
		withFacility(h.managerToken(), h.facility,
			&laundryv1.RegisterTagRequest{
				TagId: "RF-9999", TagKind: laundryv1.TagKind_TAG_KIND_RFID,
				ItemCode: "SHEET-FLAT", FacilityId: h.facility,
			})); err == nil {
		t.Fatal("a tag was registered against an untracked item")
	}

	// Registered against the code the master holds rather than the one the
	// caller typed: a trail keyed on "scrub-top" and a master keyed on
	// "SCRUB-TOP" are two inventories.
	registered, err := h.laundry.RegisterTag(ctx,
		withFacility(h.managerToken(), h.facility,
			&laundryv1.RegisterTagRequest{
				TagId: "RF-0001", TagKind: laundryv1.TagKind_TAG_KIND_RFID,
				ItemCode: "scrub-top", AssignedTo: "nurse-1",
				FacilityId: h.facility,
			}))
	if err != nil {
		t.Fatalf("RegisterTag: %v", err)
	}
	if registered.Msg.GetItem().GetItemCode() != "SCRUB-TOP" {
		t.Fatalf("the tag was not registered against the master's code: %+v",
			registered.Msg.GetItem())
	}
	trackedID := registered.Msg.GetItem().GetTrackedId()

	// An operator does not register tags, but every reader in the building
	// records a movement.
	if _, err := h.laundry.RegisterTag(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.RegisterTagRequest{
				TagId: "RF-0002", TagKind: laundryv1.TagKind_TAG_KIND_RFID,
				ItemCode: "SCRUB-TOP", FacilityId: h.facility,
			})); err == nil {
		t.Fatal("a laundry operator registered a tag")
	}

	// An item nobody has scanned reports that nobody has, rather than
	// defaulting to the laundry.
	custody, err := h.laundry.GetTagCustody(ctx,
		withFacility(h.nurseToken(), h.facility,
			&laundryv1.GetTagCustodyRequest{TagId: "RF-0001"}))
	if err != nil {
		t.Fatalf("GetTagCustody: %v", err)
	}
	if custody.Msg.GetCustody().GetKnown() {
		t.Fatalf("an unscanned item has a custody: %+v",
			custody.Msg.GetCustody())
	}

	for _, scan := range []struct{ location, holder string }{
		{"laundry-door", ""},
		{"ward-3-store", "nurse-1"},
	} {
		if _, err := h.laundry.RecordTagScan(ctx,
			withFacility(h.operatorToken(), h.facility,
				&laundryv1.RecordTagScanRequest{
					TagId: "rf-0001", Location: scan.location,
					HolderId: scan.holder,
				})); err != nil {
			t.Fatalf("RecordTagScan: %v", err)
		}
	}

	custody, err = h.laundry.GetTagCustody(ctx,
		withFacility(h.nurseToken(), h.facility,
			&laundryv1.GetTagCustodyRequest{TagId: "RF-0001"}))
	if err != nil {
		t.Fatalf("GetTagCustody: %v", err)
	}
	// A movement attributed to a reader rather than a session is a movement
	// anybody walking past the reader can create.
	if custody.Msg.GetCustody().GetRecordedBy() != "lnd-op" ||
		custody.Msg.GetCustody().GetLocation() != "ward-3-store" ||
		custody.Msg.GetCustody().GetHolderId() != "nurse-1" {
		t.Fatalf("the custody is wrong: %+v", custody.Msg.GetCustody())
	}
	if len(custody.Msg.GetItem().GetMovements()) != 2 {
		t.Fatalf("a movement was dropped: %+v",
			custody.Msg.GetItem().GetMovements())
	}

	// A second garment, scanned two days ago. It is quiet but not stale
	// under this deployment's fourteen-day period, and the report has to
	// respect that period rather than one of its own choosing.
	if _, err := h.laundry.RegisterTag(ctx,
		withFacility(h.managerToken(), h.facility,
			&laundryv1.RegisterTagRequest{
				TagId: "RF-0003", TagKind: laundryv1.TagKind_TAG_KIND_RFID,
				ItemCode: "SCRUB-TOP", FacilityId: h.facility,
			})); err != nil {
		t.Fatalf("RegisterTag: %v", err)
	}
	if _, err := h.laundry.RecordTagScan(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.RecordTagScanRequest{
				TagId: "RF-0003", Location: "laundry-door",
			})); err != nil {
		t.Fatalf("RecordTagScan: %v", err)
	}

	// The stale report names what nobody has seen and writes nothing off.
	if _, err := h.pool.Exec(ctx, `
		UPDATE laundry.tracked_movement
		SET occurred_at = now() - interval '30 days'
		WHERE tracked_id <> (
			SELECT tracked_id FROM laundry.tracked_item
			WHERE tenant_id = $1 AND tag_id = 'RF-0003')`,
		h.tenantID); err != nil {
		t.Fatalf("age the scans: %v", err)
	}
	if _, err := h.pool.Exec(ctx, `
		UPDATE laundry.tracked_movement
		SET occurred_at = now() - interval '2 days'
		WHERE tracked_id = (
			SELECT tracked_id FROM laundry.tracked_item
			WHERE tenant_id = $1 AND tag_id = 'RF-0003')`,
		h.tenantID); err != nil {
		t.Fatalf("age the recent scan: %v", err)
	}
	stale, err := h.laundry.ListStaleTrackedItems(ctx,
		withFacility(h.managerToken(), h.facility,
			&laundryv1.ListStaleTrackedItemsRequest{
				FacilityId: h.facility,
			}))
	if err != nil {
		t.Fatalf("ListStaleTrackedItems: %v", err)
	}
	if len(stale.Msg.GetItems()) != 1 ||
		stale.Msg.GetItems()[0].GetQuietDays() < 29 ||
		stale.Msg.GetItems()[0].GetItem().GetTagId() != "RF-0001" {
		t.Fatalf("the stale report is wrong: %+v", stale.Msg.GetItems())
	}
	if stale.Msg.GetItems()[0].GetItem().GetState() !=
		laundryv1.TrackedState_TRACKED_STATE_IN_SERVICE {
		t.Fatal("the report changed the item's state")
	}

	if _, err := h.laundry.RetireTag(ctx,
		withFacility(h.managerToken(), h.facility,
			&laundryv1.RetireTagRequest{
				TrackedId: trackedID, Reason: "worn out",
			})); err != nil {
		t.Fatalf("RetireTag: %v", err)
	}
	// A retired item is not something anybody carries on scanning.
	if _, err := h.laundry.RecordTagScan(ctx,
		withFacility(h.operatorToken(), h.facility,
			&laundryv1.RecordTagScanRequest{
				TagId: "RF-0001", Location: "ward-3",
			})); err == nil {
		t.Fatal("a retired tag was scanned")
	}
}

// SRS-LND-002. The weight is the only honest cross-check on a bag nobody
// opens, and a bag with nothing declared says so.
func TestTheWeightCheckIsAFindingNotARefusal(t *testing.T) {
	h := newLndHarness(t)
	ctx := context.Background()
	h.item(t, "SHEET-FLAT", false)

	ordinary := h.collection(t, laundryv1.SoilClass_SOIL_CLASS_USED)
	check, err := h.laundry.CheckCollectionWeight(ctx,
		withFacility(h.managerToken(), h.facility,
			&laundryv1.CheckCollectionWeightRequest{
				CollectionId: ordinary,
			}))
	if err != nil {
		t.Fatalf("CheckCollectionWeight: %v", err)
	}
	// Twenty sheets weigh 12 kg dry; the trolley came in at 18 kg, which is
	// wet linen rather than a discrepancy — and the caller decides that,
	// not this system.
	if check.Msg.GetUnanswerable() || check.Msg.GetExpectedG() != 12000 ||
		check.Msg.GetVarianceG() != 6000 {
		t.Fatalf("the weight check is wrong: %+v", check.Msg)
	}

	// A sealed bag declares nothing, so it reports unanswerable rather than
	// a variance of everything — which would put every infected bag on the
	// exception list and take the list with it.
	sealed := h.collection(t, laundryv1.SoilClass_SOIL_CLASS_INFECTED)
	check, err = h.laundry.CheckCollectionWeight(ctx,
		withFacility(h.managerToken(), h.facility,
			&laundryv1.CheckCollectionWeightRequest{
				CollectionId: sealed,
			}))
	if err != nil {
		t.Fatalf("CheckCollectionWeight: %v", err)
	}
	if !check.Msg.GetUnanswerable() || check.Msg.GetVarianceG() != 0 {
		t.Fatalf("a sealed bag produced a variance: %+v", check.Msg)
	}
}

// Nobody outside the tenant sees any of it, and a caller with no laundry
// permission sees nothing either.
func TestLaundryIsTenantScopedAndPermissioned(t *testing.T) {
	h := newLndHarness(t)
	ctx := context.Background()
	h.item(t, "SHEET-FLAT", false)

	collection := h.collection(t, laundryv1.SoilClass_SOIL_CLASS_USED)

	// A clerk holds no laundry permission.
	if _, err := h.laundry.ListCollections(ctx,
		withFacility(h.clerkToken(), h.facility,
			&laundryv1.ListCollectionsRequest{})); err == nil {
		t.Fatal("a registration clerk read the laundry")
	}

	// And a nurse cannot run a machine.
	if _, err := h.laundry.OpenWashBatch(ctx,
		withFacility(h.nurseToken(), h.facility,
			&laundryv1.OpenWashBatchRequest{
				FacilityId: h.facility, MachineId: "washer-1",
				Cycle: laundryv1.WashCycle_WASH_CYCLE_HOT,
			})); err == nil {
		t.Fatal("a ward nurse opened a wash batch")
	}

	// Another tenant sees an absence rather than a refusal, so a probe
	// cannot confirm the identifier exists.
	stranger := strings.Replace(h.tenantID, h.tenantID[:8], "00000000", 1) +
		":lnd-mgr:laundry_manager:" + h.facility
	if _, err := h.laundry.CheckCollectionWeight(ctx,
		withFacility(stranger, h.facility,
			&laundryv1.CheckCollectionWeightRequest{
				CollectionId: collection,
			})); err == nil {
		t.Fatal("another tenant read a collection")
	}
}
