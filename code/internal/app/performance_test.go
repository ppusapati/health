package app_test

import (
	"context"
	"fmt"
	"sync"
	"testing"
	"time"

	"github.com/google/uuid"
	organizationv1 "github.com/ppusapati/health/code/gen/go/healthcare/organization/v1"
	"github.com/ppusapati/health/code/internal/platform/slo"
)

// Performance and scale (SRS-NFR-002, SRS-NFR-003, SRS-NFR-004).
//
// These run against the real service and a real database, through the full
// interceptor chain. A benchmark of a handler in isolation measures the
// handler; what these requirements are about is what a caller experiences,
// which includes authentication, authorization, the transaction and the
// outbox write.
//
// They are `-short`-skippable because they are slower than a unit test and
// because a laptop under load produces a number nobody should act on. CI runs
// them; `make test-unit` does not.

// TestInteractiveLatencyMeetsTarget covers SRS-NFR-002: interactive RPC p95
// under 400 ms within the deployment region.
//
// The measured figure is a floor rather than a prediction — a test database on
// the same machine has no network between the service and PostgreSQL, so the
// real figure will be higher. What this catches is a regression: a change that
// adds a query per row, or drops an index, moves this number immediately and
// visibly.
func TestInteractiveLatencyMeetsTarget(t *testing.T) {
	if testing.Short() {
		t.Skip("performance test; runs in CI and in `make test`")
	}

	h := newHarness(t)
	tenantID := h.provisionTenant(t, "Latency Hospital")
	admin := tenantAdminToken(tenantID)

	// A dataset rather than an empty table: a listing over no rows measures
	// nothing, and the query plan for an empty table is not the plan for a
	// populated one.
	for i := range 200 {
		_, err := h.org.CreateFacility(context.Background(),
			as(admin, &organizationv1.CreateFacilityRequest{
				Code:        fmt.Sprintf("PERF%03d", i),
				DisplayName: fmt.Sprintf("Performance Facility %03d", i),
				Type:        organizationv1.FacilityType_FACILITY_TYPE_CLINIC,
				TimeZone:    "Asia/Kolkata",
			}))
		if err != nil {
			t.Fatalf("seed facility %d: %v", i, err)
		}
	}

	const iterations = 200
	viewer := viewerToken(tenantID)
	samples := make([]slo.Sample, 0, iterations)

	for range iterations {
		started := time.Now()
		_, err := h.org.ListFacilities(context.Background(),
			as(viewer, &organizationv1.ListFacilitiesRequest{}))
		elapsed := time.Since(started)
		if err != nil {
			t.Fatalf("ListFacilities: %v", err)
		}
		samples = append(samples, slo.Sample{
			At: started, Outcome: slo.OutcomeGood, Latency: elapsed,
		})
	}

	// Reuses the SLO package's own percentile, so the number in a test and the
	// number on a dashboard are computed the same way.
	report := slo.Compute(samples, nil, samples[0].At.Add(-time.Minute),
		time.Now().Add(time.Minute), slo.DefaultAvailabilityTarget)

	const target = 400 * time.Millisecond
	t.Logf("ListFacilities over 200 rows: p95 %v (target %v)", report.LatencyP95, target)
	if report.LatencyP95 > target {
		t.Errorf("p95 %v exceeds the %v target (SRS-NFR-002)", report.LatencyP95, target)
	}
}

// TestConcurrentTenantsDoNotLeak covers SRS-NFR-003: the architecture scales
// horizontally "without tenant data leakage or correctness loss".
//
// Concurrency is the interesting part. Isolation under sequential access is
// already proven by the milestone-2 tests; what this adds is contention — many
// tenants writing and reading at once through one process, which is what a
// scaled deployment does on every replica.
func TestConcurrentTenantsDoNotLeak(t *testing.T) {
	if testing.Short() {
		t.Skip("load test; runs in CI and in `make test`")
	}

	h := newHarness(t)

	const tenants = 8
	const facilitiesPerTenant = 10

	type tenantFixture struct {
		id    string
		codes map[string]bool
	}

	fixtures := make([]tenantFixture, tenants)
	for i := range fixtures {
		fixtures[i] = tenantFixture{
			id:    h.provisionTenant(t, fmt.Sprintf("Concurrent Hospital %02d", i)),
			codes: map[string]bool{},
		}
	}

	// Every tenant writes at the same time, using the same facility codes. The
	// codes colliding across tenants is deliberate: a scoping bug that keyed on
	// code alone would surface as a unique violation or as one tenant reading
	// another's row.
	var wg sync.WaitGroup
	errs := make([]error, tenants)

	for i := range fixtures {
		wg.Add(1)
		go func() {
			defer wg.Done()
			admin := tenantAdminToken(fixtures[i].id)
			for j := range facilitiesPerTenant {
				code := fmt.Sprintf("SHARED%02d", j)
				_, err := h.org.CreateFacility(context.Background(),
					as(admin, &organizationv1.CreateFacilityRequest{
						Code:        code,
						DisplayName: fmt.Sprintf("Facility %s", code),
						Type:        organizationv1.FacilityType_FACILITY_TYPE_CLINIC,
						TimeZone:    "Asia/Kolkata",
					}))
				if err != nil {
					errs[i] = fmt.Errorf("tenant %d facility %s: %w", i, code, err)
					return
				}
				fixtures[i].codes[code] = true
			}
		}()
	}
	wg.Wait()

	for _, err := range errs {
		if err != nil {
			t.Fatalf("concurrent writes: %v", err)
		}
	}

	// Each tenant sees exactly its own rows, concurrently.
	var readWG sync.WaitGroup
	readErrs := make([]error, tenants)

	for i := range fixtures {
		readWG.Add(1)
		go func() {
			defer readWG.Done()
			resp, err := h.org.ListFacilities(context.Background(),
				as(viewerToken(fixtures[i].id), &organizationv1.ListFacilitiesRequest{}))
			if err != nil {
				readErrs[i] = err
				return
			}
			if got := len(resp.Msg.GetFacilities()); got != facilitiesPerTenant {
				readErrs[i] = fmt.Errorf("tenant %d sees %d facilities, want %d — "+
					"a scoping failure under contention", i, got, facilitiesPerTenant)
				return
			}
			for _, f := range resp.Msg.GetFacilities() {
				if f.GetTenantId() != fixtures[i].id {
					readErrs[i] = fmt.Errorf("tenant %d received a row belonging to %s",
						i, f.GetTenantId())
					return
				}
			}
		}()
	}
	readWG.Wait()

	for _, err := range readErrs {
		if err != nil {
			t.Fatalf("concurrent reads: %v", err)
		}
	}
}

// TestConcurrentCreatesAreIdempotentOnCode covers SRS-NFR-004's uniqueness
// half: concurrent attempts to create the same facility produce one row, not
// several or a partial failure.
//
// The MRN sequence half is proven in internal/organization/adapters/postgres,
// where 24 concurrent callers receive a contiguous run. This one exercises the
// same property through the whole stack, where an application-level check
// would race even though the database constraint does not.
func TestConcurrentCreatesOfTheSameCodeYieldOneRow(t *testing.T) {
	if testing.Short() {
		t.Skip("race test; runs in CI and in `make test`")
	}

	h := newHarness(t)
	tenantID := h.provisionTenant(t, "Race Hospital")
	admin := tenantAdminToken(tenantID)

	const attempts = 12
	var wg sync.WaitGroup
	results := make([]error, attempts)
	start := make(chan struct{})

	for i := range attempts {
		wg.Add(1)
		go func() {
			defer wg.Done()
			<-start
			_, results[i] = h.org.CreateFacility(context.Background(),
				as(admin, &organizationv1.CreateFacilityRequest{
					Code:        "RACE01",
					DisplayName: "Contested Facility",
					Type:        organizationv1.FacilityType_FACILITY_TYPE_CLINIC,
					TimeZone:    "Asia/Kolkata",
				}))
		}()
	}
	close(start)
	wg.Wait()

	var created int
	for i, err := range results {
		if err == nil {
			created++
			continue
		}
		// Every loser must fail with ALREADY_EXISTS. A different error would
		// mean the constraint was reached by accident rather than the
		// contention being handled.
		detail := errorDetail(t, err)
		if detail == nil || detail.GetCode() != "ORG_FACILITY_CODE_TAKEN" {
			t.Errorf("attempt %d failed with %v, want ORG_FACILITY_CODE_TAKEN", i, err)
		}
	}
	if created != 1 {
		t.Fatalf("%d of %d concurrent creates succeeded, want exactly 1", created, attempts)
	}

	// And exactly one row exists, so no loser left a partial write behind.
	var rows int
	err := h.pool.QueryRow(context.Background(),
		`SELECT count(*) FROM organization.facility WHERE tenant_id = $1 AND code = $2`,
		tenantID, "RACE01").Scan(&rows)
	if err != nil {
		t.Fatalf("count: %v", err)
	}
	if rows != 1 {
		t.Fatalf("%d rows for a contested code, want 1", rows)
	}
}

// A generated identifier must be unique across concurrent callers. Trivially
// true for a UUID and worth pinning: a future change to a shorter or
// sequential id would break it silently.
func TestGeneratedIdentifiersAreUniqueUnderConcurrency(t *testing.T) {
	if testing.Short() {
		t.Skip("race test")
	}

	h := newHarness(t)
	tenantID := h.provisionTenant(t, "Identifier Hospital")
	admin := tenantAdminToken(tenantID)

	const attempts = 20
	var wg sync.WaitGroup
	ids := make([]string, attempts)

	for i := range attempts {
		wg.Add(1)
		go func() {
			defer wg.Done()
			resp, err := h.org.CreateFacility(context.Background(),
				as(admin, &organizationv1.CreateFacilityRequest{
					Code:        fmt.Sprintf("UNIQ%02d", i),
					DisplayName: fmt.Sprintf("Facility %02d", i),
					Type:        organizationv1.FacilityType_FACILITY_TYPE_CLINIC,
					TimeZone:    "Asia/Kolkata",
				}))
			if err != nil {
				t.Errorf("CreateFacility: %v", err)
				return
			}
			ids[i] = resp.Msg.GetFacility().GetFacilityId()
		}()
	}
	wg.Wait()

	seen := make(map[string]bool, attempts)
	for _, id := range ids {
		if id == "" {
			t.Fatal("a create returned no identifier")
		}
		if seen[id] {
			t.Fatalf("identifier %s was issued twice", id)
		}
		if _, err := uuid.Parse(id); err != nil {
			t.Fatalf("identifier %q is not a UUID: %v", id, err)
		}
		seen[id] = true
	}
}
