// Package migrations holds the invariants of the schema change process.
//
// Covers SRS-DAT-006 (expand/contract, automated and tested), SRS-DAT-013
// (every migration carries forward, rollback and reconciliation notes) and
// SRS-DAT-010 (partitioning only on a documented, measured decision).
//
// The reason these are tests rather than a review checklist: the migration
// that breaks a rolling release looks completely ordinary in a diff. A dropped
// column is one line. The old pods are still running when it lands, and the
// first anybody knows is a stream of errors from replicas that have not been
// replaced yet.
package migrations_test

import (
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strconv"
	"strings"
	"testing"

	"gopkg.in/yaml.v3"
)

func codeRoot(t *testing.T) string {
	t.Helper()
	wd, err := os.Getwd()
	if err != nil {
		t.Fatalf("getwd: %v", err)
	}
	return filepath.Clean(filepath.Join(wd, "..", ".."))
}

type migration struct {
	number int
	name   string
	up     string
	down   string
	upSQL  string
}

var migrationName = regexp.MustCompile(`^(\d{4})_([a-z0-9_]+)\.up\.sql$`)

func loadMigrations(t *testing.T) []migration {
	t.Helper()
	dir := filepath.Join(codeRoot(t), "db", "migrations")
	entries, err := os.ReadDir(dir)
	if err != nil {
		t.Fatalf("read migrations: %v", err)
	}

	var out []migration
	for _, e := range entries {
		m := migrationName.FindStringSubmatch(e.Name())
		if m == nil {
			continue
		}
		n, _ := strconv.Atoi(m[1])
		raw, err := os.ReadFile(filepath.Join(dir, e.Name()))
		if err != nil {
			t.Fatalf("read %s: %v", e.Name(), err)
		}
		out = append(out, migration{
			number: n,
			name:   m[2],
			up:     e.Name(),
			down:   strings.Replace(e.Name(), ".up.sql", ".down.sql", 1),
			upSQL:  string(raw),
		})
	}
	sort.Slice(out, func(i, j int) bool { return out[i].number < out[j].number })

	if len(out) == 0 {
		t.Fatal("no migrations found; these invariants would pass vacuously")
	}
	return out
}

// Numbering must be gapless and unique. A duplicate number means two
// developers' migrations apply in an order that depends on the filesystem, and
// a gap usually means one was deleted after being applied somewhere.
func TestMigrationNumberingIsContiguous(t *testing.T) {
	for i, m := range loadMigrations(t) {
		if want := i + 1; m.number != want {
			t.Errorf("%s: expected migration %04d, found %04d — a gap or duplicate "+
				"makes apply order depend on the filesystem", m.up, want, m.number)
		}
	}
}

// Every forward migration needs a reverse one (SRS-DAT-013). A down file that
// is deliberately empty is fine — some changes genuinely cannot be reversed —
// but it has to say so, so that the reviewer knows the question was asked.
func TestEveryMigrationHasAReverse(t *testing.T) {
	dir := filepath.Join(codeRoot(t), "db", "migrations")
	for _, m := range loadMigrations(t) {
		raw, err := os.ReadFile(filepath.Join(dir, m.down))
		if err != nil {
			t.Errorf("%s: no reverse migration (%s)", m.up, m.down)
			continue
		}
		if len(strings.TrimSpace(string(raw))) == 0 {
			t.Errorf("%s: is empty; if the change cannot be reversed, say why in a comment", m.down)
		}
	}
}

// SRS-DAT-013: forward, rollback/mitigation and data-reconciliation notes.
//
// The reconciliation note is the one people skip, and it is the one that
// matters at 3am: it says what to do about rows written by the old code after
// the migration landed.
func TestEveryMigrationDocumentsItsIntent(t *testing.T) {
	for _, m := range loadMigrations(t) {
		header := headerOf(m.upSQL)

		if len(header) < 3 {
			t.Errorf("%s: has no header comment", m.up)
			continue
		}
		// Trace lines tie the change back to a requirement, which is what
		// makes the RTM real rather than a spreadsheet maintained by hand.
		if !strings.Contains(header, "Trace:") {
			t.Errorf("%s: header has no Trace: line naming the requirements it serves", m.up)
		}
		if !strings.Contains(header, "Rollback:") {
			t.Errorf("%s: header has no Rollback: note (SRS-DAT-013)", m.up)
		}
		if !strings.Contains(header, "Reconciliation:") {
			t.Errorf("%s: header has no Reconciliation: note — what happens to rows "+
				"the previous version writes during the rollout window (SRS-DAT-013)", m.up)
		}
	}
}

// headerOf returns the leading comment block of a SQL file.
func headerOf(sql string) string {
	var b strings.Builder
	for _, line := range strings.Split(sql, "\n") {
		trimmed := strings.TrimSpace(line)
		if trimmed == "" {
			continue
		}
		if !strings.HasPrefix(trimmed, "--") {
			break
		}
		b.WriteString(trimmed)
		b.WriteString("\n")
	}
	return b.String()
}

// Statements that break a previous application version mid-rollout
// (SRS-DAT-006). Each is safe eventually and unsafe now, which is exactly why
// expand/contract exists: the destructive half waits for a later release, once
// no running code refers to the thing being removed.
var contractingStatements = []struct {
	pattern *regexp.Regexp
	why     string
}{
	{regexp.MustCompile(`(?i)\bDROP\s+COLUMN\b`),
		"the previous version still selects it"},
	{regexp.MustCompile(`(?i)\bDROP\s+TABLE\b`),
		"the previous version still reads it"},
	{regexp.MustCompile(`(?i)\bRENAME\s+(COLUMN|TO)\b`),
		"a rename is a drop and an add at the same instant, with no window in between"},
	{regexp.MustCompile(`(?i)\bALTER\s+COLUMN\s+\w+\s+TYPE\b`),
		"the previous version's driver may not decode the new type"},
	{regexp.MustCompile(`(?i)\bSET\s+NOT\s+NULL\b`),
		"the previous version inserts rows without that column"},
	{regexp.MustCompile(`(?i)\bDROP\s+(CONSTRAINT|DEFAULT)\b`),
		"the previous version relies on it"},
}

// contractMarker lets a migration declare itself the contract half of an
// expand/contract pair. It has to name the migration that expanded, so the
// claim can be checked rather than taken on trust.
var contractMarker = regexp.MustCompile(`(?i)--\s*Contract:\s*expanded in (\d{4})`)

// A migration may contract only when it says which migration expanded first
// (SRS-DAT-006). Without the pairing, "expand/contract" is a convention people
// remember when they are not in a hurry.
func TestContractingChangesDeclareTheirExpansion(t *testing.T) {
	migrations := loadMigrations(t)
	byNumber := map[int]migration{}
	for _, m := range migrations {
		byNumber[m.number] = m
	}

	for _, m := range migrations {
		statements := stripComments(m.upSQL)

		for _, c := range contractingStatements {
			if !c.pattern.MatchString(statements) {
				continue
			}
			marker := contractMarker.FindStringSubmatch(m.upSQL)
			if marker == nil {
				t.Errorf("%s: contains a contracting change (%s) with no "+
					"`-- Contract: expanded in NNNN` marker. %s, so the destructive "+
					"half belongs in a later release (SRS-DAT-006)",
					m.up, c.pattern.String(), c.why)
				continue
			}
			expanded, _ := strconv.Atoi(marker[1])
			if _, ok := byNumber[expanded]; !ok {
				t.Errorf("%s: claims migration %04d expanded, but there is no such migration",
					m.up, expanded)
				continue
			}
			// The expansion must be in an earlier release, not the same one:
			// expanding and contracting together leaves no window in which
			// both versions work, which is the entire point.
			if expanded >= m.number {
				t.Errorf("%s: claims to contract what %04d expanded, but that is not "+
					"an earlier migration; there is then no window in which both "+
					"application versions work", m.up, expanded)
			}
		}
	}
}

// stripComments removes SQL comments so a pattern cannot match prose. Without
// this, a header explaining "we do not DROP COLUMN here" would trip the check
// and teach people to phrase comments around a linter.
func stripComments(sql string) string {
	var b strings.Builder
	for _, line := range strings.Split(sql, "\n") {
		if idx := strings.Index(line, "--"); idx >= 0 {
			line = line[:idx]
		}
		b.WriteString(line)
		b.WriteString("\n")
	}
	return b.String()
}

// A new NOT NULL column without a default breaks the previous version's
// inserts immediately. Adding the default is the expand step; dropping it, if
// ever, is the contract step.
func TestNewColumnsAreBackwardCompatible(t *testing.T) {
	addColumn := regexp.MustCompile(`(?is)ADD\s+COLUMN\s+(?:IF\s+NOT\s+EXISTS\s+)?(\w+)\s+([^,;]+)`)

	for _, m := range loadMigrations(t) {
		for _, match := range addColumn.FindAllStringSubmatch(stripComments(m.upSQL), -1) {
			column, definition := match[1], match[2]
			if !regexp.MustCompile(`(?i)\bNOT\s+NULL\b`).MatchString(definition) {
				continue
			}
			if regexp.MustCompile(`(?i)\bDEFAULT\b`).MatchString(definition) {
				continue
			}
			t.Errorf("%s: adds NOT NULL column %q with no DEFAULT; the previous "+
				"application version's inserts fail the moment this lands (SRS-DAT-006)",
				m.up, column)
		}
	}
}

// Partitioning register (SRS-DAT-010).

type partitionRegister struct {
	Tables []partitionedTable `yaml:"tables"`
}

type partitionedTable struct {
	Table          string `yaml:"table"`
	Key            string `yaml:"key"`
	Strategy       string `yaml:"strategy"`
	Rationale      string `yaml:"rationale"`
	MeasuredVolume string `yaml:"measured_volume"`
	RetentionPlan  string `yaml:"retention_plan"`
	PruningTest    string `yaml:"pruning_test"`
}

// Partitioning is a decision that is very hard to reverse and is usually made
// too early, on a guess about volume. SRS-DAT-010 therefore allows it only
// with a measured or forecast workload, a documented key and a retention plan,
// and this test is where that is checked: a PARTITION BY in a migration with
// no register entry fails the build.
func TestPartitionedTablesAreRegistered(t *testing.T) {
	raw, err := os.ReadFile(filepath.Join(codeRoot(t), "db", "partitioning.yaml"))
	if err != nil {
		t.Fatalf("read partitioning register: %v", err)
	}
	var reg partitionRegister
	if err := yaml.Unmarshal(raw, &reg); err != nil {
		t.Fatalf("parse partitioning register: %v", err)
	}

	registered := map[string]partitionedTable{}
	for _, p := range reg.Tables {
		registered[p.Table] = p

		for field, value := range map[string]string{
			"key":             p.Key,
			"strategy":        p.Strategy,
			"measured_volume": p.MeasuredVolume,
			"retention_plan":  p.RetentionPlan,
			"pruning_test":    p.PruningTest,
		} {
			if strings.TrimSpace(value) == "" {
				t.Errorf("partitioning register: %s has no %s", p.Table, field)
			}
		}
		if len(strings.TrimSpace(p.Rationale)) < 40 {
			t.Errorf("partitioning register: %s needs a rationale naming the measured "+
				"workload that justifies partitioning", p.Table)
		}
	}

	partitionBy := regexp.MustCompile(`(?is)CREATE\s+TABLE\s+([\w.]+)\s*\(.*?\)\s*PARTITION\s+BY\s+(\w+)\s*\(([^)]+)\)`)
	for _, m := range loadMigrations(t) {
		for _, match := range partitionBy.FindAllStringSubmatch(stripComments(m.upSQL), -1) {
			table, strategy, key := match[1], strings.ToLower(match[2]), strings.TrimSpace(match[3])
			p, ok := registered[table]
			if !ok {
				t.Errorf("%s: partitions %s but it is not in db/partitioning.yaml; "+
					"partitioning needs a measured workload, a documented key and a "+
					"retention plan (SRS-DAT-010)", m.up, table)
				continue
			}
			if !strings.EqualFold(p.Strategy, strategy) {
				t.Errorf("%s: partitions %s BY %s; the register says %s", m.up, table, strategy, p.Strategy)
			}
			if !strings.EqualFold(strings.TrimSpace(p.Key), key) {
				t.Errorf("%s: partitions %s on (%s); the register says (%s)", m.up, table, key, p.Key)
			}
		}
	}
}

// TestDetectorsWork proves the two checks that currently pass over an empty
// set can actually fail.
//
// No migration contracts anything yet and nothing is partitioned, so without
// this the strongest rules in this file would be asserting nothing while
// reporting green.
func TestDetectorsWork(t *testing.T) {
	contracting := []string{
		"ALTER TABLE organization.facility DROP COLUMN legacy_code;",
		"ALTER TABLE organization.facility RENAME COLUMN code TO facility_code;",
		"ALTER TABLE organization.facility ALTER COLUMN name TYPE varchar(80);",
		"ALTER TABLE organization.facility ALTER COLUMN code SET NOT NULL;",
		"DROP TABLE organization.legacy_site;",
	}
	for _, sql := range contracting {
		var caught bool
		for _, c := range contractingStatements {
			if c.pattern.MatchString(sql) {
				caught = true
			}
		}
		if !caught {
			t.Errorf("a contracting statement slipped through: %s", sql)
		}
	}

	// A comment must not trip the detector, or people write comments to please
	// the linter instead of to explain the change.
	commented := stripComments("-- we deliberately do not DROP COLUMN here\nSELECT 1;")
	for _, c := range contractingStatements {
		if c.pattern.MatchString(commented) {
			t.Error("a comment mentioning a contracting statement was treated as one")
		}
	}

	if !contractMarker.MatchString("-- Contract: expanded in 0009") {
		t.Error("a valid contract marker was not recognised")
	}

	partitionBy := regexp.MustCompile(`(?is)CREATE\s+TABLE\s+([\w.]+)\s*\(.*?\)\s*PARTITION\s+BY\s+(\w+)\s*\(([^)]+)\)`)
	sample := "CREATE TABLE platform_data.audit_event (\n  audit_id uuid\n) PARTITION BY RANGE (occurred_at);"
	m := partitionBy.FindStringSubmatch(sample)
	if m == nil {
		t.Fatal("the partition detector does not recognise a partitioned table")
	}
	if m[1] != "platform_data.audit_event" || !strings.EqualFold(m[2], "range") {
		t.Fatalf("partition detector parsed %q / %q", m[1], m[2])
	}

	notNullNoDefault := regexp.MustCompile(`(?is)ADD\s+COLUMN\s+(?:IF\s+NOT\s+EXISTS\s+)?(\w+)\s+([^,;]+)`)
	bad := notNullNoDefault.FindStringSubmatch("ALTER TABLE t ADD COLUMN code text NOT NULL;")
	if bad == nil || !regexp.MustCompile(`(?i)\bNOT\s+NULL\b`).MatchString(bad[2]) {
		t.Fatal("the NOT NULL detector does not fire on a column that would break the previous version")
	}
}

// sqlc is given its schema as an explicit, ordered list of migration files
// rather than a directory. The ordering is deliberate — sqlc has to see
// migrations in the order PostgreSQL will apply them — but an explicit list has
// a failure mode a directory does not: adding a migration and forgetting to
// register it.
//
// That failure is quiet in exactly the wrong way. sqlc keeps generating happily
// against the previous schema, so the build stays green and the generated code
// simply does not know about the new columns. Whether anybody notices depends
// on whether the queries written that day happen to reference them.
func TestSqlcSeesEveryMigration(t *testing.T) {
	var cfg struct {
		SQL []struct {
			Schema []string `yaml:"schema"`
		} `yaml:"sql"`
	}
	raw, err := os.ReadFile(filepath.Join(codeRoot(t), "sqlc.yaml"))
	if err != nil {
		t.Fatalf("read sqlc.yaml: %v", err)
	}
	if err := yaml.Unmarshal(raw, &cfg); err != nil {
		t.Fatalf("parse sqlc.yaml: %v", err)
	}
	if len(cfg.SQL) == 0 {
		t.Fatal("sqlc.yaml declares no sql package; this invariant would pass vacuously")
	}

	registered := map[string]int{}
	var order []string
	for _, pkg := range cfg.SQL {
		for _, path := range pkg.Schema {
			name := filepath.Base(path)
			registered[name]++
			order = append(order, name)
		}
	}

	for _, m := range loadMigrations(t) {
		if registered[m.up] == 0 {
			t.Errorf("migration %s is not listed in sqlc.yaml, so sqlc generates "+
				"against a schema that does not contain it — silently, because "+
				"generation still succeeds", m.up)
		}
		if registered[m.up] > 1 {
			t.Errorf("migration %s is listed %d times in sqlc.yaml", m.up, registered[m.up])
		}
	}

	// Listed in apply order. Out of order, a migration that alters a table
	// created by a later one fails to generate, and the error names the column
	// rather than the ordering.
	if !sort.SliceIsSorted(order, func(i, j int) bool { return order[i] < order[j] }) {
		t.Errorf("sqlc.yaml lists schema files out of migration order: %v", order)
	}
}
