package postgres_test

import (
	"context"
	"fmt"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	orgpostgres "github.com/ppusapati/health/code/internal/organization/adapters/postgres"
	"github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/organization/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

var at = time.Date(2026, 9, 11, 10, 0, 0, 0, time.UTC)

type repoFixture struct {
	pool     *pgxpool.Pool
	tenants  ports.TenantRepository
	fac      ports.FacilityRepository
	scope    authctx.TenantScope
	tenantID string
}

func newRepoFixture(t *testing.T) repoFixture {
	t.Helper()

	pool := pgtest.New(t)
	repo := orgpostgres.New(pgtx.NewManager(pool))

	tenants := orgpostgres.TenantRepo{Repository: repo}
	tenant, err := domain.NewTenant(uuid.NewString(), "Apollo Group", "IN", "en-IN", "Asia/Kolkata", at)
	if err != nil {
		t.Fatalf("NewTenant: %v", err)
	}
	if err := tenants.Insert(context.Background(), tenant); err != nil {
		t.Fatalf("insert tenant: %v", err)
	}

	session := authctx.NewSession(authctx.Session{SubjectID: "admin", TenantID: tenant.ID})
	return repoFixture{
		pool:     pool,
		tenants:  tenants,
		fac:      orgpostgres.FacilityRepo{Repository: repo},
		scope:    session.TenantScope(),
		tenantID: tenant.ID,
	}
}

// seedFacilities inserts n facilities with strictly increasing created_at so
// the keyset order is deterministic.
func (f repoFixture) seedFacilities(t *testing.T, n int) []*domain.Facility {
	t.Helper()

	out := make([]*domain.Facility, 0, n)
	for i := 0; i < n; i++ {
		fac, err := domain.NewFacility(uuid.NewString(), f.tenantID,
			fmt.Sprintf("FAC%02d", i), fmt.Sprintf("Facility %02d", i),
			domain.FacilityClinic, "Asia/Kolkata", at.Add(time.Duration(i)*time.Second))
		if err != nil {
			t.Fatalf("NewFacility: %v", err)
		}
		if err := f.fac.Insert(context.Background(), f.scope, fac); err != nil {
			t.Fatalf("insert facility %d: %v", i, err)
		}
		out = append(out, fac)
	}
	return out
}

func TestRoundTripPreservesEveryField(t *testing.T) {
	f := newRepoFixture(t)
	ctx := context.Background()

	want := f.seedFacilities(t, 1)[0]

	got, err := f.fac.GetByID(ctx, f.scope, want.ID)
	if err != nil {
		t.Fatalf("GetByID: %v", err)
	}

	if got.ID != want.ID || got.TenantID != want.TenantID || got.Code != want.Code ||
		got.DisplayName != want.DisplayName || got.Type != want.Type ||
		got.Status != want.Status || got.TimeZone != want.TimeZone || got.Version != want.Version {
		t.Fatalf("round trip lost data:\n got %+v\nwant %+v", got, want)
	}
	// Timestamps must come back as UTC instants, not shifted by the session
	// time zone.
	if !got.CreatedAt.Equal(want.CreatedAt) {
		t.Fatalf("CreatedAt = %v, want %v", got.CreatedAt, want.CreatedAt)
	}
}

// Keyset paging must walk the whole set exactly once, with no repeats and no
// gaps at the page boundary.
func TestKeysetPaginationCoversEveryRowExactlyOnce(t *testing.T) {
	f := newRepoFixture(t)
	ctx := context.Background()

	const total = 25
	const pageSize = 10
	f.seedFacilities(t, total)

	seen := map[string]int{}
	token := ""
	pages := 0

	for {
		items, next, err := f.fac.List(ctx, f.scope, ports.FacilityFilter{
			PageSize: pageSize, PageToken: token,
		})
		if err != nil {
			t.Fatalf("List page %d: %v", pages, err)
		}
		pages++
		for _, item := range items {
			seen[item.ID]++
		}
		if next == "" {
			break
		}
		token = next

		if pages > total {
			t.Fatal("pagination did not terminate")
		}
	}

	if len(seen) != total {
		t.Fatalf("saw %d distinct facilities, want %d", len(seen), total)
	}
	for id, count := range seen {
		if count != 1 {
			t.Fatalf("facility %s returned %d times", id, count)
		}
	}
	if pages != 3 {
		t.Fatalf("walked %d pages for %d rows at size %d, want 3", pages, total, pageSize)
	}
}

// The final page must not advertise a cursor, or a client will loop forever.
func TestLastPageHasNoNextToken(t *testing.T) {
	f := newRepoFixture(t)
	f.seedFacilities(t, 3)

	_, next, err := f.fac.List(context.Background(), f.scope, ports.FacilityFilter{PageSize: 10})
	if err != nil {
		t.Fatalf("List: %v", err)
	}
	if next != "" {
		t.Fatalf("next token = %q on a complete page", next)
	}
}

// An exactly-full page must not claim there is more when there is not.
func TestExactPageBoundaryHasNoNextToken(t *testing.T) {
	f := newRepoFixture(t)
	f.seedFacilities(t, 10)

	items, next, err := f.fac.List(context.Background(), f.scope, ports.FacilityFilter{PageSize: 10})
	if err != nil {
		t.Fatalf("List: %v", err)
	}
	if len(items) != 10 {
		t.Fatalf("got %d items", len(items))
	}
	if next != "" {
		t.Fatalf("next token = %q when the page exactly consumed the set", next)
	}
}

func TestStatusFilter(t *testing.T) {
	f := newRepoFixture(t)
	ctx := context.Background()

	facs := f.seedFacilities(t, 3)
	if _, err := f.pool.Exec(ctx,
		`UPDATE organization.facility SET status = 'retired' WHERE facility_id = $1`,
		facs[0].ID); err != nil {
		t.Fatalf("retire: %v", err)
	}

	active, _, err := f.fac.List(ctx, f.scope, ports.FacilityFilter{
		PageSize: 10, Status: domain.FacilityActive,
	})
	if err != nil {
		t.Fatalf("List active: %v", err)
	}
	if len(active) != 2 {
		t.Fatalf("active = %d, want 2", len(active))
	}

	retired, _, err := f.fac.List(ctx, f.scope, ports.FacilityFilter{
		PageSize: 10, Status: domain.FacilityRetired,
	})
	if err != nil {
		t.Fatalf("List retired: %v", err)
	}
	if len(retired) != 1 || retired[0].ID != facs[0].ID {
		t.Fatalf("retired = %v", retired)
	}
}

// A tampered cursor must be a clean client error, not a 500.
func TestMalformedPageTokenIsInvalidArgument(t *testing.T) {
	f := newRepoFixture(t)

	_, _, err := f.fac.List(context.Background(), f.scope, ports.FacilityFilter{
		PageSize: 10, PageToken: "not-a-cursor",
	})
	e, ok := rpcerr.As(err)
	if !ok || e.Category != rpcerr.CategoryInvalidArgument {
		t.Fatalf("want invalid_argument, got %v", err)
	}
}

// The database constraint, not just the application pre-check, must hold the
// per-tenant uniqueness line under concurrency.
func TestDuplicateCodeHitsUniqueConstraint(t *testing.T) {
	f := newRepoFixture(t)
	ctx := context.Background()

	first := f.seedFacilities(t, 1)[0]

	dup, err := domain.NewFacility(uuid.NewString(), f.tenantID, first.Code,
		"Another Name", domain.FacilityClinic, "Asia/Kolkata", at)
	if err != nil {
		t.Fatalf("NewFacility: %v", err)
	}

	err = f.fac.Insert(ctx, f.scope, dup)
	e, ok := rpcerr.As(err)
	if !ok || e.Category != rpcerr.CategoryAlreadyExists {
		t.Fatalf("want already_exists from the unique index, got %v", err)
	}
}

// An aggregate from another tenant must never be writable through a scope that
// does not own it, even if the caller assembled it by hand.
func TestInsertRejectsScopeMismatch(t *testing.T) {
	f := newRepoFixture(t)

	foreign, err := domain.NewFacility(uuid.NewString(), uuid.NewString(), "OTHER",
		"Other Tenant Facility", domain.FacilityClinic, "Asia/Kolkata", at)
	if err != nil {
		t.Fatalf("NewFacility: %v", err)
	}

	if err := f.fac.Insert(context.Background(), f.scope, foreign); err == nil {
		t.Fatal("repository wrote an aggregate belonging to another tenant")
	}
}

func TestGetTenantNotFound(t *testing.T) {
	f := newRepoFixture(t)

	_, err := f.tenants.GetByID(context.Background(), uuid.NewString())
	e, ok := rpcerr.As(err)
	if !ok || e.Category != rpcerr.CategoryNotFound {
		t.Fatalf("want not_found, got %v", err)
	}
}

// A malformed identifier must be concealed as not-found rather than surfacing
// a parse error that confirms the ID format.
func TestMalformedIDsAreConcealed(t *testing.T) {
	f := newRepoFixture(t)
	ctx := context.Background()

	if _, err := f.tenants.GetByID(ctx, "definitely-not-a-uuid"); err == nil {
		t.Fatal("malformed tenant ID accepted")
	} else if e, _ := rpcerr.As(err); e.Category != rpcerr.CategoryNotFound {
		t.Fatalf("category = %q, want NOT_FOUND", e.Category)
	}

	if _, err := f.fac.GetByID(ctx, f.scope, "definitely-not-a-uuid"); err == nil {
		t.Fatal("malformed facility ID accepted")
	} else if e, _ := rpcerr.As(err); e.Category != rpcerr.CategoryNotFound {
		t.Fatalf("category = %q, want NOT_FOUND", e.Category)
	}
}

func TestExistsByCode(t *testing.T) {
	f := newRepoFixture(t)
	ctx := context.Background()

	first := f.seedFacilities(t, 1)[0]

	exists, err := f.fac.ExistsByCode(ctx, f.scope, first.Code)
	if err != nil {
		t.Fatalf("ExistsByCode: %v", err)
	}
	if !exists {
		t.Fatal("existing code reported missing")
	}

	exists, err = f.fac.ExistsByCode(ctx, f.scope, "NOPE")
	if err != nil {
		t.Fatalf("ExistsByCode: %v", err)
	}
	if exists {
		t.Fatal("absent code reported present")
	}
}
