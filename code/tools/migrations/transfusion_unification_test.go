package migrations_test

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"testing"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
)

// Migration 0047 moves the transfusion record into one place (SRS-NUR-014,
// SRS-BLD-010).
//
// The other tests in this package read migrations as text. This one runs them,
// because the risk in 0047 is not its syntax: it is a data migration across
// two schemas, and the three cases that matter are a row that links, a row
// that cannot, and a row the blood bank already has. Applying it to an empty
// database proves none of them.
//
// It applies 0001 through 0046, writes the fixtures a ward would have left
// behind, applies 0047, and asserts what moved and what stayed.

func TestMigration0047LeavesOneRecordOfATransfusion(t *testing.T) {
	url := os.Getenv("TEST_DATABASE_URL")
	if url == "" {
		t.Skip("TEST_DATABASE_URL is not set")
	}

	ctx := context.Background()
	admin, err := pgxpool.New(ctx, url)
	if err != nil {
		t.Fatalf("connect: %v", err)
	}
	defer admin.Close()

	name := "mig0047_" + strings.ReplaceAll(uuid.NewString()[:8], "-", "")
	if _, err := admin.Exec(ctx,
		fmt.Sprintf("CREATE DATABASE %q", name)); err != nil {
		t.Fatalf("create database: %v", err)
	}
	t.Cleanup(func() {
		_, _ = admin.Exec(context.Background(),
			fmt.Sprintf("DROP DATABASE IF EXISTS %q WITH (FORCE)", name))
	})

	at := strings.LastIndex(url, "/")
	target := url[:at+1] + name + url[strings.Index(url[at:], "?")+at:]
	pool, err := pgxpool.New(ctx, target)
	if err != nil {
		t.Fatalf("connect to %s: %v", name, err)
	}
	defer pool.Close()

	files := migrationFiles(t)
	apply(ctx, t, pool, files, "0047")

	tenant := uuid.New()
	seedTransfusions(ctx, t, pool, tenant)

	// Everything up to but not including the unification.
	applyOne(ctx, t, pool, files, "0047_transfusion_unification.up.sql")

	// The linkable one moved, with its observations, and its component is
	// off the shelf.
	assertScalar(ctx, t, pool, 1, `
		SELECT count(*) FROM bloodbank.episode e
		  JOIN bloodbank.component c ON c.component_id = e.component_id
		 WHERE e.tenant_id = $1 AND c.unit_number = 'U-LINKED'
		   AND e.status = 'completed'`, tenant)
	// Two in total: the one that moved and the one the blood bank had.
	assertScalar(ctx, t, pool, 2, `
		SELECT count(*) FROM bloodbank.episode WHERE tenant_id = $1`,
		tenant)
	assertScalar(ctx, t, pool, 2, `
		SELECT count(*) FROM bloodbank.observation o
		  JOIN bloodbank.episode e ON e.episode_id = o.episode_id
		 WHERE e.tenant_id = $1`, tenant)
	assertScalar(ctx, t, pool, 1, `
		SELECT count(*) FROM bloodbank.observation o
		  JOIN bloodbank.episode e ON e.episode_id = o.episode_id
		 WHERE e.tenant_id = $1 AND o.timing = 'baseline'`, tenant)
	assertScalar(ctx, t, pool, 1, `
		SELECT count(*) FROM bloodbank.component
		 WHERE tenant_id = $1 AND unit_number = 'U-LINKED'
		   AND status = 'transfused'`, tenant)

	// The bedside pair survived as two distinct people, which is the
	// control the whole record exists to carry.
	assertScalar(ctx, t, pool, 1, `
		SELECT count(*) FROM bloodbank.episode e
		  JOIN bloodbank.component c ON c.component_id = e.component_id
		 WHERE e.tenant_id = $1 AND c.unit_number = 'U-LINKED'
		   AND e.checked_by = 'nurse-a' AND e.checked_with = 'nurse-b'`,
		tenant)

	// The unlinkable one stayed put rather than being dropped, and so did
	// the duplicate the blood bank already had.
	assertScalar(ctx, t, pool, 2, `
		SELECT count(*) FROM nursing.transfusion WHERE tenant_id = $1`,
		tenant)
	assertScalar(ctx, t, pool, 1, `
		SELECT count(*) FROM nursing.transfusion
		 WHERE tenant_id = $1 AND unit_number = 'U-UNKNOWN'`, tenant)
	assertScalar(ctx, t, pool, 1, `
		SELECT count(*) FROM nursing.transfusion
		 WHERE tenant_id = $1 AND unit_number = 'U-DUPLICATE'`, tenant)

	// And the episode the blood bank already held was not overwritten: its
	// own bedside pair is intact, not the ward's.
	assertScalar(ctx, t, pool, 1, `
		SELECT count(*) FROM bloodbank.episode e
		  JOIN bloodbank.component c ON c.component_id = e.component_id
		 WHERE e.tenant_id = $1 AND c.unit_number = 'U-DUPLICATE'
		   AND e.checked_by = 'bank-a'`, tenant)

	// Nothing is recorded twice: no unit number appears on both sides.
	assertScalar(ctx, t, pool, 0, `
		SELECT count(*) FROM nursing.transfusion t
		  JOIN bloodbank.component c
		    ON c.tenant_id = t.tenant_id AND c.unit_number = t.unit_number
		  JOIN bloodbank.episode e
		    ON e.component_id = c.component_id
		 WHERE t.tenant_id = $1 AND e.episode_id = t.transfusion_id`,
		tenant)
}

func migrationFiles(t *testing.T) []string {
	t.Helper()
	found, err := filepath.Glob(filepath.Join(
		codeRoot(t), "db", "migrations", "*.up.sql"))
	if err != nil || len(found) == 0 {
		t.Fatalf("no migrations found: %v", err)
	}
	sort.Strings(found)
	return found
}

// apply runs every migration whose name sorts before the given prefix.
func apply(ctx context.Context, t *testing.T, pool *pgxpool.Pool,
	files []string, stopBefore string) {

	t.Helper()
	for _, f := range files {
		if strings.HasPrefix(filepath.Base(f), stopBefore) {
			return
		}
		runSQL(ctx, t, pool, f)
	}
}

func applyOne(ctx context.Context, t *testing.T, pool *pgxpool.Pool,
	files []string, name string) {

	t.Helper()
	for _, f := range files {
		if filepath.Base(f) == name {
			runSQL(ctx, t, pool, f)
			return
		}
	}
	t.Fatalf("migration %s not found", name)
}

func runSQL(ctx context.Context, t *testing.T, pool *pgxpool.Pool, path string) {
	t.Helper()
	body, err := os.ReadFile(path)
	if err != nil {
		t.Fatalf("read %s: %v", path, err)
	}
	if _, err := pool.Exec(ctx, string(body)); err != nil {
		t.Fatalf("apply %s: %v", filepath.Base(path), err)
	}
}

func assertScalar(ctx context.Context, t *testing.T, pool *pgxpool.Pool,
	want int, query string, args ...any) {

	t.Helper()
	var got int
	if err := pool.QueryRow(ctx, query, args...).Scan(&got); err != nil {
		t.Fatalf("query: %v", err)
	}
	if got != want {
		t.Fatalf("want %d, got %d, for:%s", want, got, query)
	}
}

// seedTransfusions writes what a ward and a blood bank would have left behind
// before the two records were unified: one transfusion whose unit the blood
// bank knows, one whose unit it has never heard of, and one the blood bank has
// already recorded itself.
func seedTransfusions(ctx context.Context, t *testing.T, pool *pgxpool.Pool,
	tenant uuid.UUID) {

	t.Helper()

	// A component hangs off a collection, which hangs off a screened donor.
	// Built in full rather than stubbed, because the point of keeping
	// bloodbank.episode is that this chain exists behind it.
	donor, screening, collection := uuid.New(), uuid.New(), uuid.New()
	if _, err := pool.Exec(ctx, `
		INSERT INTO bloodbank.donor (
			donor_id, tenant_id, donor_number, display_name,
			abo, rhd, registered_at, registered_by)
		VALUES ($1, $2, 'D-1', 'A Donor', 'O', 'positive', now(),
			'u-bank')`,
		donor, tenant); err != nil {
		t.Fatalf("seed donor: %v", err)
	}
	if _, err := pool.Exec(ctx, `
		INSERT INTO bloodbank.screening (
			screening_id, tenant_id, donor_id, consented, accepted,
			screened_at, screened_by)
		VALUES ($1, $2, $3, true, true, now() - interval '10 days',
			'u-bank')`,
		screening, tenant, donor); err != nil {
		t.Fatalf("seed screening: %v", err)
	}
	if _, err := pool.Exec(ctx, `
		INSERT INTO bloodbank.collection (
			collection_id, tenant_id, donor_id, screening_id,
			donation_number, volume_ml, abo, rhd,
			collected_at, collected_by)
		VALUES ($1, $2, $3, $4, 'C-1', 450, 'O', 'positive',
			now() - interval '10 days', 'u-bank')`,
		collection, tenant, donor, screening); err != nil {
		t.Fatalf("seed collection: %v", err)
	}

	components := map[string]uuid.UUID{
		"U-LINKED": uuid.New(), "U-DUPLICATE": uuid.New(),
	}
	for number, id := range components {
		if _, err := pool.Exec(ctx, `
			INSERT INTO bloodbank.component (
				component_id, tenant_id, unit_number, collection_id,
				donor_id, component_class, abo, rhd, status,
				volume_ml, expires_at, created_at, created_by)
			VALUES ($1, $2, $3, $4, $5, 'red_cells', 'O', 'positive',
				'available', 280, now() + interval '20 days', now(),
				'u-bank')`,
			id, tenant, number, collection, donor); err != nil {
			t.Fatalf("seed component %s: %v", number, err)
		}
	}

	// The blood bank already recorded this one itself.
	if _, err := pool.Exec(ctx, `
		INSERT INTO bloodbank.episode (
			episode_id, tenant_id, component_id, patient_id,
			status, started_at, started_by, checked_by, checked_with)
		VALUES ($1, $2, $3, $4, 'completed', now() - interval '2 days',
			'bank-a', 'bank-a', 'bank-b')`,
		uuid.New(), tenant, components["U-DUPLICATE"],
		uuid.New()); err != nil {
		t.Fatalf("seed existing episode: %v", err)
	}

	linked := uuid.New()
	for _, row := range []struct {
		id   uuid.UUID
		unit string
	}{
		{linked, "U-LINKED"},
		{uuid.New(), "U-UNKNOWN"},
		{uuid.New(), "U-DUPLICATE"},
	} {
		if _, err := pool.Exec(ctx, `
			INSERT INTO nursing.transfusion (
				transfusion_id, tenant_id, patient_id, encounter_id,
				unit_number, product_system, product_code,
				product_display, volume_ml, started_at, started_by,
				checked_by, status, ended_at)
			VALUES ($1, $2, $3, $4, $5, 'http://snomed.info/sct',
				'256- 1', 'Red cells', 280.0,
				now() - interval '1 day', 'nurse-a', 'nurse-b',
				'completed', now() - interval '20 hours')`,
			row.id, tenant, uuid.New(), uuid.New(), row.unit); err != nil {
			t.Fatalf("seed nursing transfusion %s: %v", row.unit, err)
		}
	}

	// Two observations on the one that will move, so the baseline mapping
	// is exercised rather than assumed.
	for _, baseline := range []bool{true, false} {
		if _, err := pool.Exec(ctx, `
			INSERT INTO nursing.transfusion_observation (
				observation_id, tenant_id, transfusion_id, observed_at,
				observed_by, temperature_c, pulse, systolic_bp,
				respiratory_rate, baseline)
			VALUES ($1, $2, $3, now() - interval '1 day', 'nurse-a',
				37.1, 78, 122, 16, $4)`,
			uuid.New(), tenant, linked, baseline); err != nil {
			t.Fatalf("seed observation: %v", err)
		}
	}
}
