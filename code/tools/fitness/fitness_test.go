// Package fitness holds the architecture fitness tests.
//
// These run in CI on every change and encode the rules from the Domain, Data,
// API, Event & Security Architecture Specification §17. They exist because
// layering conventions decay silently: a single import added under deadline
// pressure is invisible in review but obvious to a test.
//
// Each test names the FIT rule it enforces.
//
// This package is the mechanism SRS-NFR-010 asks for: architecture boundaries
// enforced through package ownership and CI architecture tests, verified by a
// forbidden import or a cross-domain database access failing the build. Every
// rule here is a build failure rather than a review comment, which is the
// difference the requirement is actually about — a convention that is only
// written down is a convention that decays.
//
// Trace: SRS-NFR-010, SRS-API-012, SRS-DAT-004, SRS-DAT-007.
package fitness_test

import (
	"go/ast"
	"go/parser"
	"go/token"
	"os"
	"path"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"
	"testing"
)

// repoRoot is the module root, two levels above tools/fitness.
func repoRoot(t *testing.T) string {
	t.Helper()
	wd, err := os.Getwd()
	if err != nil {
		t.Fatalf("getwd: %v", err)
	}
	return filepath.Clean(filepath.Join(wd, "..", ".."))
}

// goFile is one parsed source file with its import list.
type goFile struct {
	path    string
	rel     string
	pkg     string
	imports []string
	file    *ast.File
	fset    *token.FileSet
}

// loadGoFiles parses every non-generated Go file under the module.
func loadGoFiles(t *testing.T) []goFile {
	t.Helper()
	root := repoRoot(t)

	var out []goFile
	err := filepath.WalkDir(root, func(path string, d os.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if d.IsDir() {
			switch d.Name() {
			// gen/ is produced by buf and sqlcgen by sqlc; generated code is
			// never hand-edited, so holding it to hand-written layering rules
			// would only produce noise.
			case ".git", "node_modules", "gen", "sqlcgen", "apps":
				return filepath.SkipDir
			}
			return nil
		}
		if !strings.HasSuffix(path, ".go") {
			return nil
		}

		fset := token.NewFileSet()
		parsed, parseErr := parser.ParseFile(fset, path, nil, parser.ImportsOnly|parser.ParseComments)
		if parseErr != nil {
			return parseErr
		}

		var imports []string
		for _, spec := range parsed.Imports {
			value, unquoteErr := strconv.Unquote(spec.Path.Value)
			if unquoteErr != nil {
				continue
			}
			imports = append(imports, value)
		}

		rel, _ := filepath.Rel(root, path)
		out = append(out, goFile{
			path: path, rel: rel, pkg: parsed.Name.Name,
			imports: imports, file: parsed, fset: fset,
		})
		return nil
	})
	if err != nil {
		t.Fatalf("walk: %v", err)
	}
	if len(out) == 0 {
		t.Fatal("no Go files found; fitness tests would vacuously pass")
	}
	return out
}

// FIT-01: domain packages must not import SQL, network, transport or cloud SDK
// packages. The domain is the one layer that has to stay portable and
// deterministic.
//
// This is also SRS-API-007's verification clause: the domain package has no
// sqlc or pgx dependency, so the repository interface belongs to the domain
// that consumes it and the generated implementation stays infrastructure.
func TestFIT01_DomainPackagesArePure(t *testing.T) {
	forbidden := []string{
		"database/sql",
		"github.com/jackc/pgx",
		"connectrpc.com/connect",
		"net/http",
		"go.opentelemetry.io",
		"github.com/aws/",
		"cloud.google.com/",
		"/adapters/",
		"/transport",
		"/sqlcgen",
	}

	for _, f := range loadGoFiles(t) {
		if !isDomainFile(f.rel) {
			continue
		}
		for _, imp := range f.imports {
			for _, bad := range forbidden {
				if strings.Contains(imp, bad) {
					t.Errorf("FIT-01: domain file %s imports %q", f.rel, imp)
				}
			}
		}
	}
}

// sqlSchemaRef matches a schema reference in SQL position. A dotted permission
// name such as "organization.facility.create" is not a query, and matching it
// would make these tests useless noise.
var sqlSchemaRef = regexp.MustCompile(
	`(?i)\b(?:from|join|into|update|delete\s+from|table)\s+` +
		`(organization|identity_access|platform_data|platform_workflow|platform_rules|platform_edge|platform_escalation|emergency|icu|theatre|anaesthesia|bloodbank|sterile|security_platform|housekeeping|laundry|ambulance|mortuary|facilities)\.[a-z_]+`)

// schemaOwners maps a schema to the one package path allowed to reach it.
var schemaOwners = map[string]string{
	"organization":        "internal/organization/adapters/postgres",
	"identity_access":     "internal/identity_access/adapters/postgres",
	"platform_data":       "internal/platform/store",
	"platform_workflow":   "internal/platform/workflow",
	"platform_rules":      "internal/platform/rules",
	"platform_edge":       "internal/edge/cloudstore",
	"security_platform":   "internal/security/adapters/postgres",
	"emergency":           "internal/emergency/adapters/postgres",
	"icu":                 "internal/icu/adapters/postgres",
	"theatre":             "internal/theatre/adapters/postgres",
	"anaesthesia":         "internal/anaesthesia/adapters/postgres",
	"bloodbank":           "internal/bloodbank/adapters/postgres",
	"sterile":             "internal/sterile/adapters/postgres",
	"platform_blob":       "internal/platform/blobstore",
	"platform_escalation": "internal/platform/escalation",
	"housekeeping":        "internal/housekeeping/adapters/postgres",
	"laundry":             "internal/laundry/adapters/postgres",
	"ambulance":           "internal/ambulance/adapters/postgres",
	"mortuary":            "internal/mortuary/adapters/postgres",
	"facilities":          "internal/facilities/adapters/postgres",
}

// TestSQLSchemaRefDetectorWorks guards the guard.
//
// Every FIT-02 assertion below is a search that passes when it finds nothing,
// so a broken pattern would silently disable the rule rather than fail. This
// test proves the detector still fires on a known violation and still ignores
// the permission strings that look similar.
func TestSQLSchemaRefDetectorWorks(t *testing.T) {
	shouldMatch := []string{
		`SELECT * FROM organization.facility`,
		`insert into platform_data.audit_record (x) values (1)`,
		`UPDATE organization.tenant SET status = 'active'`,
		`DELETE FROM platform_data.inbox_message`,
		`JOIN identity_access.user_account u ON u.id = x`,
		`select 1 from platform_workflow.instance`,
		`INSERT INTO platform_rules.rule_set (x) VALUES (1)`,
		`UPDATE platform_edge.node SET status = 'revoked'`,
		`SELECT 1 FROM security_platform.security_event`,
		`SELECT * FROM platform_escalation.notice WHERE state = 'pending'`,
		`SELECT * FROM emergency.visit WHERE status <> 'disposed'`,
		`SELECT * FROM icu.observation WHERE validation = 'pending'`,
		`SELECT * FROM theatre.case WHERE status <> 'cancelled'`,
		`SELECT * FROM anaesthesia.record WHERE status = 'open'`,
		`SELECT * FROM bloodbank.component WHERE status = 'available'`,
		`SELECT * FROM housekeeping.bed_hold WHERE state = 'open'`,
		`SELECT * FROM laundry.wash_batch WHERE state = 'passed'`,
		`SELECT * FROM sterile.run WHERE stage = 'released'`,
	}
	for _, sample := range shouldMatch {
		if !sqlSchemaRef.MatchString(sample) {
			t.Errorf("detector missed a real query: %q", sample)
		}
	}

	shouldNotMatch := []string{
		`"organization.facility.create"`,
		`PermFacilityRead = "organization.facility.read"`,
		`healthcare.organization.v1`,
		`// the organization.tenant aggregate is owned here`,
	}
	for _, sample := range shouldNotMatch {
		if sqlSchemaRef.MatchString(sample) {
			t.Errorf("detector fired on a non-query: %q", sample)
		}
	}
}

// FIT-02: only a context-owned adapter package may execute SQL against its
// schema. A stray query elsewhere is exactly the undocumented cross-domain
// coupling the architecture forbids.
//
// Production code currently holds all SQL in db/queries and reaches it through
// sqlc, so this check is about keeping it that way: the moment someone inlines
// a query, it has to be in the owning package.
func TestFIT02_InlineSQLIsConfinedToOwningAdapter(t *testing.T) {
	for _, f := range loadGoFiles(t) {
		// Tests legitimately assert against stored rows, and the migration
		// harness applies the schema itself.
		if strings.HasSuffix(f.rel, "_test.go") || strings.Contains(f.rel, "pgtest") {
			continue
		}

		source, err := os.ReadFile(f.path)
		if err != nil {
			t.Fatalf("read %s: %v", f.rel, err)
		}

		for _, match := range sqlSchemaRef.FindAllStringSubmatch(string(source), -1) {
			owner, known := schemaOwners[match[1]]
			if !known {
				continue
			}
			if !strings.HasPrefix(filepath.ToSlash(f.rel), owner) {
				t.Errorf("FIT-02: %s queries schema %q owned by %s", f.rel, match[1], owner)
			}
		}
	}
}

// FIT-02: the generated sqlc query surface is the only way into the database,
// so restricting who may import it is the boundary that actually bites today.
func TestFIT02_GeneratedQueriesImportedOnlyByAdapters(t *testing.T) {
	// Each entry owns a schema and is the only way into it. The platform
	// packages are on this list for the same reason the module adapters are:
	// workflow owns platform_workflow.*, rules owns platform_rules.*, store
	// owns platform_data.*. A package that does not own tables has no business
	// here, which is what the list is for.
	allowed := []string{
		"internal/organization/adapters/postgres",
		"internal/identity_access/adapters/postgres",
		"internal/empi/adapters/postgres",
		"internal/scheduling/adapters/postgres",
		"internal/encounter/adapters/postgres",
		"internal/clinical/adapters/postgres",
		"internal/nursing/adapters/postgres",
		"internal/orders/adapters/postgres",
		"internal/medication/adapters/postgres",
		"internal/billing/adapters/postgres",
		"internal/emergency/adapters/postgres",
		"internal/icu/adapters/postgres",
		"internal/theatre/adapters/postgres",
		"internal/anaesthesia/adapters/postgres",
		"internal/bloodbank/adapters/postgres",
		"internal/sterile/adapters/postgres",
		"internal/materials/adapters/postgres",
		"internal/biomedical/adapters/postgres",
		"internal/quality/adapters/postgres",
		"internal/infection/adapters/postgres",
		"internal/records/adapters/postgres",
		"internal/dietetics/adapters/postgres",
		"internal/housekeeping/adapters/postgres",
		"internal/laundry/adapters/postgres",
		"internal/ambulance/adapters/postgres",
		"internal/mortuary/adapters/postgres",
		"internal/facilities/adapters/postgres",
		"internal/platform/store",
		"internal/platform/workflow",
		"internal/platform/rules",
		"internal/edge/cloudstore",
		"internal/security/adapters/postgres",
		"internal/platform/blobstore",
		"internal/platform/escalation",
	}

	var importers int
	for _, f := range loadGoFiles(t) {
		rel := filepath.ToSlash(f.rel)
		if strings.HasSuffix(rel, "_test.go") {
			continue
		}

		for _, imp := range f.imports {
			if !strings.HasSuffix(imp, "/internal/platform/sqlcgen") {
				continue
			}
			importers++

			var ok bool
			for _, prefix := range allowed {
				if strings.HasPrefix(rel, prefix) {
					ok = true
					break
				}
			}
			if !ok {
				t.Errorf("FIT-02: %s imports the generated query package; only adapters may", rel)
			}
		}
	}

	// If nothing imports sqlcgen the rule is vacuous and something has been
	// renamed out from under this test.
	if importers == 0 {
		t.Fatal("no package imports sqlcgen; this rule is no longer testing anything")
	}
}

// db/queries must not reach across schema ownership within a single file, which
// would smuggle a cross-context join past the Go-level checks.
// SRS-DAT-001's verification clause: each bounded context owns its tables, and
// a cross-domain write goes through a contract rather than a direct table
// write. A query file that reaches into a second schema is that direct write.
func TestFIT02_QueryFilesStayWithinOneSchema(t *testing.T) {
	root := repoRoot(t)
	files, err := filepath.Glob(filepath.Join(root, "db", "queries", "*.sql"))
	if err != nil {
		t.Fatalf("glob: %v", err)
	}
	if len(files) == 0 {
		t.Fatal("no query files found")
	}

	for _, path := range files {
		source, err := os.ReadFile(path)
		if err != nil {
			t.Fatalf("read %s: %v", path, err)
		}

		schemas := map[string]bool{}
		for _, match := range sqlSchemaRef.FindAllStringSubmatch(string(source), -1) {
			schemas[match[1]] = true
		}
		if len(schemas) > 1 {
			t.Errorf("FIT-02: %s joins across schemas %v; cross-context reads go through APIs or read models",
				filepath.Base(path), keysOf(schemas))
		}
	}
}

func keysOf(m map[string]bool) []string {
	out := make([]string, 0, len(m))
	for k := range m {
		out = append(out, k)
	}
	return out
}

// tenantScopeExemptions are the ports whose callers cannot hold a verified
// scope, because the scope is what they are being used to build.
//
// Named individually with a reason rather than matched by a pattern: an
// exemption that a file can grant itself by containing the right identifier is
// an exemption every file will eventually grant itself.
var tenantScopeExemptions = map[string]string{
	"internal/organization/ports/ports.go":    "tenant provisioning creates the tenant a scope would name",
	"internal/identity_access/ports/ports.go": "account and federation lookups run before a session exists, so there is no scope to take",
}

// bareTenantParam matches a parameter named tenantID whatever else shares its
// type declaration.
//
// The earlier form of this check was `tenantID\s+string`, which passed
// `tenantID, subjectID string` — the commonest way the parameter is actually
// written. It was found by a new port that happened to be written the other
// way round, which is not a way to find things.
var bareTenantParam = regexp.MustCompile(`\btenantID\b\s*(,\s*\w+\s*)*string\b`)

// FIT-03: every tenant-owned repository method must take a verified
// authctx.TenantScope rather than a bare tenant string.
//
// SRS-API-005's verification clause: a handler cannot bypass authorization by
// calling a repository directly. It cannot, because it has no way to produce
// the scope the repository demands — the type has no exported constructor
// (ADR-0001), so the only scope in existence is one the interceptor derived
// from a verified credential.
func TestFIT03_RepositoryPortsRequireTenantScope(t *testing.T) {
	for _, f := range loadGoFiles(t) {
		if !strings.HasSuffix(filepath.ToSlash(f.rel), "ports/ports.go") {
			continue
		}

		source, err := os.ReadFile(f.path)
		if err != nil {
			t.Fatalf("read %s: %v", f.rel, err)
		}
		text := string(source)

		// A port that names tenantID as a plain string parameter has bypassed
		// the unforgeable scope type.
		rel := filepath.ToSlash(f.rel)
		if bareTenantParam.MatchString(text) {
			if _, exempt := tenantScopeExemptions[rel]; !exempt {
				t.Errorf("FIT-03: %s accepts a bare tenant string", rel)
			}
		}

		if strings.Contains(text, "FacilityRepository") &&
			!strings.Contains(text, "authctx.TenantScope") {
			t.Errorf("FIT-03: %s declares a tenant-owned repository without TenantScope", f.rel)
		}
	}
}

// FIT-03 companion: authctx.SystemScope is the one way to obtain tenant scope
// without a session, and only background runners may call it.
//
// TenantScope has no exported constructor so that a repository cannot be
// reached without verified tenant scope -- FIT-03 above is that rule. Work with
// no caller needs a way through it anyway: a timer sweeping due escalations
// cannot present credentials, and an outbox publisher is not acting for a user.
// SystemScope is that way through, and what makes it safe is that it is easy to
// find rather than hard to call.
//
// So this pins the callers. A clinical, transport or application package
// calling SystemScope would be taking tenant scope without going through the
// authorization its request path exists to perform, and the diff that did it
// would look entirely ordinary.
func TestFIT03_SystemScopeIsForBackgroundRunnersOnly(t *testing.T) {
	// Directories whose work genuinely has no caller. Each entry is a claim
	// that the package runs on a timer or a queue rather than in a request.
	allowed := map[string]string{
		"internal/platform/authctx":    "declares it",
		"internal/platform/escalation": "the escalation sweeper (SRS-OPSNFR-003)",
	}

	var callers []string
	for _, f := range loadGoFiles(t) {
		if strings.HasSuffix(f.rel, "_test.go") {
			continue
		}
		source, err := os.ReadFile(f.path)
		if err != nil {
			t.Fatalf("read %s: %v", f.rel, err)
		}
		if !strings.Contains(string(source), "SystemScope(") {
			continue
		}

		dir := path.Dir(filepath.ToSlash(f.rel))
		if _, ok := allowed[dir]; !ok {
			callers = append(callers, f.rel)
		}
	}

	for _, caller := range callers {
		t.Errorf("FIT-03: %s calls authctx.SystemScope; only background runners may, "+
			"and a new one is a decision to record in tools/fitness rather than "+
			"take in passing", caller)
	}

	// Guard the guard. A rule whose allowlist has quietly swallowed the only
	// real caller passes forever while checking nothing.
	found := false
	for _, f := range loadGoFiles(t) {
		if strings.HasPrefix(filepath.ToSlash(f.rel), "internal/platform/escalation/") &&
			!strings.HasSuffix(f.rel, "_test.go") {
			source, err := os.ReadFile(f.path)
			if err != nil {
				t.Fatalf("read %s: %v", f.rel, err)
			}
			if strings.Contains(string(source), "authctx.SystemScope(") {
				found = true
			}
		}
	}
	if !found {
		t.Error("FIT-03: no background runner calls authctx.SystemScope; either the " +
			"escalation sweeper stopped using it or this rule is checking nothing")
	}
}

// FIT-06: no production log or span statement may serialise a whole request or
// response message.
func TestFIT06_NoWholeMessageLogging(t *testing.T) {
	banned := []*regexp.Regexp{
		regexp.MustCompile(`slog\.Any\(`),
		regexp.MustCompile(`slog\.[A-Za-z]+\([^)]*req\.Msg`),
		regexp.MustCompile(`slog\.[A-Za-z]+\([^)]*resp\.Msg`),
		regexp.MustCompile(`fmt\.Print`),
		regexp.MustCompile(`\bprintln\(`),
		regexp.MustCompile(`log\.Print`),
	}

	// Drill harnesses are excluded, and the exclusion is narrow on purpose.
	// scripts/drills/* is built and run by an operator during a drill and is
	// never in the deployed image; its whole output is the measurement, printed
	// to a terminal somebody is watching. Everything that ships -- cmd/,
	// internal/, tools/ -- is still covered, and the assertion below is what
	// stops this exclusion quietly widening to any of them.
	var covered int
	for _, f := range loadGoFiles(t) {
		if strings.HasSuffix(f.rel, "_test.go") {
			continue
		}
		if strings.HasPrefix(filepath.ToSlash(f.rel), "scripts/drills/") {
			continue
		}
		if strings.HasPrefix(filepath.ToSlash(f.rel), "cmd/") ||
			strings.HasPrefix(filepath.ToSlash(f.rel), "internal/") {
			covered++
		}

		source, err := os.ReadFile(f.path)
		if err != nil {
			t.Fatalf("read %s: %v", f.rel, err)
		}

		for _, pattern := range banned {
			if loc := pattern.FindString(string(source)); loc != "" {
				t.Errorf("FIT-06: %s contains unsafe logging construct %q", f.rel, loc)
			}
		}
	}

	// A skip rule that swallowed the deployed tree would leave this test green
	// and meaningless.
	if covered < 50 {
		t.Errorf("FIT-06 scanned only %d files under cmd/ and internal/; the "+
			"exclusion above has widened past the drill harnesses", covered)
	}
}

// FIT-08: signed or finalised records must not have a generic update or delete
// path. Wave 0 has no clinical aggregate yet, so this guards the boundary that
// exists today: retired masters and the append-only platform tables.
func TestFIT08_NoDeleteOnAppendOnlyTables(t *testing.T) {
	// Qualified names, because the financial ledgers live in their own schema
	// and "delete from ledger_entry" unqualified would match nothing.
	appendOnly := []string{
		"platform_data.audit_record",
		"platform_data.outbox_event",
		"platform_data.inbox_message",
		// SRS-BIL-012's "balance derives from ledger and reconciles" is only
		// true while the ledger is the whole truth. A deleted entry is money
		// that moved and left no trace, and the balance would still add up —
		// to the wrong number, with nothing to reconcile against.
		"billing.ledger_entry",
		// SRS-BIL-004's consumption ledger explains what a package billed and
		// did not. A deleted entry is a charge the patient was told about and
		// can no longer be shown the reason for.
		"billing.package_consumption",
		// SRS-IPC-006 reports hand hygiene compliance. A deleted observation
		// is a miss that never happened, and the rate still adds up — to a
		// better number, with nothing to audit it against.
		"infection.hygiene_observation",
		// SRS-IPC-004's acceptance is that an override is audited. A deleted
		// alert is an override nobody can review, and the patient's next
		// encounter carries on as though the rule had never fired.
		"infection.alert",
		// SRS-MRD-010's accounting of disclosures is what a patient is
		// entitled to ask for. A deleted row is a copy of somebody's record
		// that left the hospital and that nobody can be told about.
		"records.disclosure",
		// A certificate version went to a family and to a registrar. Deleting
		// one makes the hospital's account of what it issued untrue.
		"records.certificate_version",
		// SRS-DIET-004 asks that progress can be trended. A trend built from
		// measurements somebody deleted shows whatever is left, and a
		// patient losing weight looks like one holding steady.
		"hospital_ops_diet.care_plan_progress",
		// SRS-DIET-008 keeps the forecast and the count apart. A deleted
		// count is wastage that never happened, and the kitchen's variance
		// comes out at whatever the remaining rows say.
		"hospital_ops_diet.ingredient_consumption",
		// SRS-HKP-007's acceptance is that a scan does not replace user
		// authentication, and a scan is worth recording only because nobody
		// can edit it afterwards. A deleted scan is somebody who was never
		// in the room, and the audit-compliance figure comes out higher for
		// it.
		"housekeeping.location_scan",
		// SRS-LND-007's acceptance is that a tracked item has a last known
		// custody. A deleted movement is a garment that was never where it
		// was, and the trail still reads cleanly — which is exactly what
		// somebody removing one would be after.
		"laundry.tracked_movement",
		// SRS-AMB-003's acceptance is that the trip timeline is complete and
		// auditable. A deleted milestone is a response time that never
		// happened, and the remaining rows still read as a clean job; a
		// correction is a further row carrying amends_at, so nothing needs
		// deleting for an honest reason.
		"ambulance.trip_milestone",
		// SRS-MORT-004 asks for a chain of custody. A deleted line is a
		// movement of a body or of somebody's wedding ring that never
		// happened, and the chain still reads unbroken — which is exactly
		// what somebody removing one would be after.
		"mortuary.custody_entry",
		// A consumption series or an hour-counter history that can be
		// edited agrees with whatever the last service claimed, and both
		// are the evidence behind a decision somebody will be asked about.
		"facilities.meter_reading",
		"facilities.runtime_reading",
	}

	for _, f := range loadGoFiles(t) {
		if strings.HasSuffix(f.rel, "_test.go") {
			continue
		}
		source, err := os.ReadFile(f.path)
		if err != nil {
			t.Fatalf("read %s: %v", f.rel, err)
		}
		text := strings.ToLower(string(source))

		for _, table := range appendOnly {
			if strings.Contains(text, "delete from "+table) {
				t.Errorf("FIT-08: %s deletes from append-only table %q", f.rel, table)
			}
		}
	}
}

// FIT-08 for the money: the financial ledgers take no UPDATE and no DELETE, and
// an issued invoice's lines and totals are never edited (SRS-BIL-010,
// SRS-BIL-012).
//
// Checked against db/queries rather than against Go source, because that is
// where such a statement would actually be written — sqlc generates the method
// and the adapter calls it, so the query file is the door.
// SRS-DAT-003's verification clause: financial, inventory and signed clinical
// records use append, amend and reversal rather than update-in-place, so the
// audit can reconstruct what a row said before and who changed it. A ledger
// with a DELETE has thrown that away.
func TestFIT08_FinancialLedgersAreAppendOnly(t *testing.T) {
	root := repoRoot(t)
	path := filepath.Join(root, "db", "queries", "billing.sql")
	source, err := os.ReadFile(path)
	if err != nil {
		t.Fatalf("read %s: %v", path, err)
	}
	text := strings.ToLower(string(source))

	for _, forbidden := range []string{
		"update billing.ledger_entry",
		"delete from billing.ledger_entry",
		"update billing.package_consumption",
		"delete from billing.package_consumption",
		// An issued document's lines are a snapshot. Editing them would change
		// what a document the patient is holding says it charged for.
		"update billing.invoice_line",
		"delete from billing.invoice_line",
	} {
		if strings.Contains(text, forbidden) {
			t.Errorf("FIT-08/SRS-BIL-010: billing.sql contains %q", forbidden)
		}
	}

	// The rule is vacuous if the file has been renamed out from under it.
	if !strings.Contains(text, "insert into billing.ledger_entry") {
		t.Fatal("billing.sql no longer appends to the ledger; this rule is not testing anything")
	}
}

// The migrations themselves must not offer a destructive path on audit history.
func TestFIT08_AuditTableHasNoDeleteQuery(t *testing.T) {
	root := repoRoot(t)
	queries, err := filepath.Glob(filepath.Join(root, "db", "queries", "*.sql"))
	if err != nil {
		t.Fatalf("glob: %v", err)
	}
	if len(queries) == 0 {
		t.Fatal("no query files found")
	}

	for _, path := range queries {
		source, err := os.ReadFile(path)
		if err != nil {
			t.Fatalf("read %s: %v", path, err)
		}
		text := strings.ToLower(string(source))
		for _, forbidden := range []string{
			"delete from platform_data.audit_record",
			"update platform_data.audit_record",
			"delete from organization.facility",
			"delete from organization.tenant",
		} {
			if strings.Contains(text, forbidden) {
				t.Errorf("FIT-08/SRS-PLT-015: %s contains %q", filepath.Base(path), forbidden)
			}
		}
	}
}

// The application layer owns transactions; handlers must never begin one
// (Blueprint §4.2). SRS-API-006's verification clause asks an architecture
// test to detect a handler that has taken on work belonging to the layers
// below it, and a transaction is the first such thing a handler reaches for.
func TestTransportDoesNotOpenTransactions(t *testing.T) {
	for _, f := range loadGoFiles(t) {
		rel := filepath.ToSlash(f.rel)
		if !strings.Contains(rel, "/transport/") || strings.HasSuffix(rel, "_test.go") {
			continue
		}
		for _, imp := range f.imports {
			if strings.HasSuffix(imp, "/internal/platform/pgtx") {
				t.Errorf("transport file %s imports pgtx; transactions belong to the application layer", rel)
			}
		}
	}
}

// The application layer must not import the transport layer: the dependency
// arrow points inward only.
func TestApplicationDoesNotImportTransport(t *testing.T) {
	for _, f := range loadGoFiles(t) {
		rel := filepath.ToSlash(f.rel)
		if !strings.Contains(rel, "/application/") {
			continue
		}
		for _, imp := range f.imports {
			if strings.Contains(imp, "/transport") || strings.Contains(imp, "connectrpc.com/connect") {
				t.Errorf("application file %s imports transport concern %q", rel, imp)
			}
		}
	}
}

// Bounded contexts must not reach into each other's internals. Cross-context
// work goes through APIs, events or workflows (Domain/Data spec §2.1).
func TestBoundedContextsDoNotImportEachOther(t *testing.T) {
	contexts := []string{"organization", "identity_access"}

	for _, f := range loadGoFiles(t) {
		rel := filepath.ToSlash(f.rel)

		var owning string
		for _, c := range contexts {
			if strings.HasPrefix(rel, "internal/"+c+"/") {
				owning = c
				break
			}
		}
		if owning == "" {
			continue
		}

		for _, imp := range f.imports {
			for _, other := range contexts {
				if other == owning {
					continue
				}
				if strings.Contains(imp, "/internal/"+other+"/") {
					t.Errorf("%s (context %q) imports context %q via %q", rel, owning, other, imp)
				}
			}
		}
	}
}

// isDomainFile reports whether a path sits in a bounded context's domain
// package.
func isDomainFile(rel string) bool {
	slashed := filepath.ToSlash(rel)
	return strings.Contains(slashed, "/domain/") && !strings.HasSuffix(slashed, "_test.go")
}

// authctx.NewSession is the only door to a TenantScope, so it is the seam that
// makes ADR-W0-001's "unforgeable" claim true or false.
//
// The type system cannot express "only the interceptor may call this" — Go has
// no friend packages — so the constraint is enforced here instead. Production
// code may mint a session in exactly two places: the transport interceptor that
// authenticated the request, and the composition root. Everywhere else, a
// session must arrive through the context.
func TestOnlyTransportMintsSessions(t *testing.T) {
	// Two authentication boundaries may mint a session, plus the composition
	// root. Both boundaries verify a credential and derive identity from it;
	// neither accepts an identity a caller asserted.
	//
	//   internal/platform/transport   — verifies a bearer token
	//   internal/edge/cloudstore      — verifies a node's certificate
	//                                   fingerprint in AuthenticateNode
	//
	// Adding to this list is a security decision, not a convenience: a package
	// here can act as any tenant.
	allowed := []string{
		"internal/platform/transport",
		"internal/edge/cloudstore",
		"internal/app",
	}

	var callers int
	for _, f := range loadGoFiles(t) {
		rel := filepath.ToSlash(f.rel)

		// Tests legitimately stand in for the interceptor.
		if strings.HasSuffix(rel, "_test.go") {
			continue
		}

		source, err := os.ReadFile(f.path)
		if err != nil {
			t.Fatalf("read %s: %v", rel, err)
		}
		if !strings.Contains(string(source), "authctx.NewSession(") {
			continue
		}
		callers++

		var ok bool
		for _, prefix := range allowed {
			if strings.HasPrefix(rel, prefix) {
				ok = true
				break
			}
		}
		if !ok {
			t.Errorf("%s mints a session; only %v may", rel, allowed)
		}
	}

	if callers == 0 {
		t.Fatal("nothing calls authctx.NewSession; this rule is no longer testing anything")
	}
}

// The facility and purpose headers are client-controlled ABAC inputs. Assigning
// either straight onto a verified session makes the corresponding policy gate
// unreachable, so the interceptor must route both through a Permits* check.
func TestClientHeadersAreNarrowedNotAssigned(t *testing.T) {
	root := repoRoot(t)
	path := filepath.Join(root, "internal", "platform", "transport", "interceptor.go")

	source, err := os.ReadFile(path)
	if err != nil {
		t.Fatalf("read interceptor: %v", err)
	}
	text := string(source)

	for _, guard := range []string{"PermitsFacility(", "PermitsPurpose(", "IsKnownPurpose("} {
		if !strings.Contains(text, guard) {
			t.Errorf("interceptor.go no longer calls %s; a client header would be trusted verbatim", guard)
		}
	}
}

// No blob content in the relational schema (SRS-DAT-007).
//
// A scanned consent form or a DICOM study in a bytea column takes the
// database's whole operational profile with it: backups grow from minutes to
// hours, replication lag becomes a function of how many radiographs were taken
// today, and a restore drill nobody can finish stops being run. The rule is
// easy to state and easy to break with one convenient column, so it is a test.
func TestNoBlobContentInRelationalSchema(t *testing.T) {
	// bytea is legitimate for small fixed-size cryptographic material — a
	// nonce, a digest, a signature. It is not legitimate for content. The
	// distinction cannot be drawn from the type, so it is drawn from the
	// column, and an allowlist carries the exceptions with their reasons.
	//
	// Keyed on migration and column together rather than on the column name
	// alone. "content" is the obvious name for the thing this rule exists to
	// forbid, and an allowlist entry for the bare word would silently permit
	// every future migration that reached for it.
	allowedByteaColumns := map[string]string{
		"0026_platform_blob.up.sql:content": "SRS-DAT-007 deviation, bounded and deliberate: " +
			"content inlined here is capped at 64 KiB by a CHECK constraint in the same " +
			"migration, which is what keeps the rule's actual concern — a database whose " +
			"backup and replication profile is set by how many studies were taken today — " +
			"from applying. Raising that cap needs a migration and this comment re-read. " +
			"See db/migrations/0026_platform_blob.up.sql.",
	}

	byteaColumn := regexp.MustCompile(`(?mi)^\s*(\w+)\s+bytea\b`)

	for _, path := range migrationFiles(t) {
		raw, err := os.ReadFile(path)
		if err != nil {
			t.Fatalf("read %s: %v", path, err)
		}
		for _, match := range byteaColumn.FindAllStringSubmatch(stripSQLComments(string(raw)), -1) {
			column := match[1]
			if _, ok := allowedByteaColumns[filepath.Base(path)+":"+column]; ok {
				continue
			}
			t.Errorf("%s: column %q is bytea. Object content belongs in the object "+
				"store with its digest in PostgreSQL (SRS-DAT-007); if this is small "+
				"cryptographic material, add it to allowedByteaColumns with a reason",
				filepath.Base(path), column)
		}
	}
}

// Timestamps must be timestamptz, never timestamp (SRS-DAT-004).
//
// `timestamp without time zone` stores a wall-clock reading with no offset, so
// the instant it denotes depends on the session's TimeZone setting at read
// time. Two replicas configured differently disagree about when a dose was
// given, and nothing in the data says which is right.
func TestTimestampColumnsCarryAZone(t *testing.T) {
	// Negative lookahead is unavailable in RE2, so match the type and then
	// exclude the qualified spellings explicitly.
	timestampColumn := regexp.MustCompile(`(?mi)^\s*(\w+)\s+(timestamp\w*)`)

	for _, path := range migrationFiles(t) {
		raw, err := os.ReadFile(path)
		if err != nil {
			t.Fatalf("read %s: %v", path, err)
		}
		for _, match := range timestampColumn.FindAllStringSubmatch(stripSQLComments(string(raw)), -1) {
			column, columnType := match[1], strings.ToLower(match[2])
			if columnType == "timestamptz" {
				continue
			}
			t.Errorf("%s: column %q is %s. Use timestamptz: a timestamp without a "+
				"zone denotes a different instant depending on the reading session's "+
				"TimeZone, and nothing in the data says which was meant (SRS-DAT-004)",
				filepath.Base(path), column, columnType)
		}
	}
}

func migrationFiles(t *testing.T) []string {
	t.Helper()
	paths, err := filepath.Glob(filepath.Join(repoRoot(t), "db", "migrations", "*.up.sql"))
	if err != nil {
		t.Fatalf("glob migrations: %v", err)
	}
	if len(paths) == 0 {
		t.Fatal("no migrations found; these schema rules would pass vacuously")
	}
	return paths
}

// stripSQLComments prevents a comment from tripping a schema rule, so nobody
// has to phrase an explanation around a linter.
func stripSQLComments(sql string) string {
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

// TestSchemaRuleDetectorsWork proves the two rules above can fail. Both
// currently pass over a schema that happens to comply, and a rule that has
// never failed is a rule nobody has checked.
func TestSchemaRuleDetectorsWork(t *testing.T) {
	byteaColumn := regexp.MustCompile(`(?mi)^\s*(\w+)\s+bytea\b`)
	if !byteaColumn.MatchString("    scan_content    bytea       NOT NULL,") {
		t.Error("the bytea detector does not fire on a content column")
	}
	if byteaColumn.MatchString("    body_uri        text        NOT NULL,") {
		t.Error("the bytea detector fires on a text column")
	}

	timestampColumn := regexp.MustCompile(`(?mi)^\s*(\w+)\s+(timestamp\w*)`)
	naive := timestampColumn.FindStringSubmatch("    occurred_at     timestamp   NOT NULL,")
	if naive == nil || strings.ToLower(naive[2]) == "timestamptz" {
		t.Error("the timestamp detector does not fire on a zone-less column")
	}
	zoned := timestampColumn.FindStringSubmatch("    occurred_at     timestamptz NOT NULL,")
	if zoned == nil || strings.ToLower(zoned[2]) != "timestamptz" {
		t.Error("the timestamp detector misclassifies timestamptz")
	}
}

// External gateways stay out of the domain (SRS-API-012).
//
// The verification clause is "external standard changes do not force internal
// DB model rewrite", and the way that stays true is a translation boundary
// nobody is tempted to skip. The temptation is real and specific: FHIR
// resources look enough like domain aggregates that storing a fhir.Patient
// directly saves a mapping layer — until the next FHIR release renumbers a
// field and the migration is a data migration rather than a code change.
//
// So a gateway package may depend on a domain, and no domain, application or
// adapter package may depend on a gateway.
func TestGatewaysAreNotImportedByTheDomain(t *testing.T) {
	for _, f := range loadGoFiles(t) {
		rel := filepath.ToSlash(f.rel)
		// A gateway may import inward; that is the direction translation runs.
		if strings.Contains(rel, "internal/gateway/") {
			continue
		}
		for _, imp := range f.imports {
			if strings.Contains(imp, "/internal/gateway/") {
				t.Errorf("%s imports %s. A gateway translates an external standard; "+
					"depending on one inward means a change to that standard reaches "+
					"the domain and the database (SRS-API-012)", rel, imp)
			}
		}
	}
}

// TestGatewayRuleDetectorWorks proves the rule can fail while no gateway
// exists yet, so it is not asserting nothing while reporting green.
func TestGatewayRuleDetectorWorks(t *testing.T) {
	offending := "github.com/ppusapati/health/code/internal/gateway/fhir"
	if !strings.Contains(offending, "/internal/gateway/") {
		t.Fatal("the gateway detector does not recognise a gateway import")
	}
	innocent := "github.com/ppusapati/health/code/internal/organization/domain"
	if strings.Contains(innocent, "/internal/gateway/") {
		t.Fatal("the gateway detector fires on a domain import")
	}
}

// permissionLiteral matches a permission name in quotes: three or more
// dot-separated lower-case segments, which is the shape every permission in
// this codebase has.
var permissionLiteral = regexp.MustCompile(
	`"([a-z][a-z0-9_]*(?:\.[a-z][a-z0-9_]*){2,})"`)

// lineComment strips a trailing // comment, so a permission named in prose
// ("deliberately no ot.case.schedule") is not mistaken for a grant.
var lineComment = regexp.MustCompile(`//.*$`)

// rolesCatalogue is the one file that grants permissions.
const rolesCatalogue = "internal/identity_access/domain/roles.go"

// FIT-09: every permission a role grants is one some service checks.
//
// The failure this catches is silent in both directions and invisible in
// review. A role granting "cln.allergy.read" when the service checks
// "cln.record.read" denies the holder nothing they notice until they need it,
// and the catalogue reads as though the access were already there. Nothing
// else in the build refers to a permission twice, so a misspelling is a string
// that matches nothing and fails nowhere.
//
// The reverse direction is deliberately not asserted: a permission no role
// holds yet is an ordinary state — a context built before anybody has decided
// which job does it — and failing on it would force a premature grant.
func TestFIT09_EveryGrantedPermissionIsCheckedSomewhere(t *testing.T) {
	root := repoRoot(t)

	catalogue, err := os.ReadFile(filepath.Join(root, rolesCatalogue))
	if err != nil {
		t.Fatalf("read %s: %v", rolesCatalogue, err)
	}
	granted := permissionsIn(string(catalogue))
	if len(granted) == 0 {
		t.Fatalf("no permissions found in %s; the detector is broken and this "+
			"test would pass whatever the catalogue said", rolesCatalogue)
	}

	checked := map[string]bool{}
	for _, f := range loadGoFiles(t) {
		if f.rel == rolesCatalogue || strings.HasSuffix(f.rel, "_test.go") {
			continue
		}
		source, err := os.ReadFile(f.path)
		if err != nil {
			t.Fatalf("read %s: %v", f.rel, err)
		}
		for name := range permissionsIn(string(source)) {
			checked[name] = true
		}
	}

	for name := range granted {
		if grantedAheadOfItsSurface[name] {
			continue
		}
		if !checked[name] {
			t.Errorf("FIT-09: %s grants %q, which no service defines or checks",
				rolesCatalogue, name)
		}
	}
}

// grantedAheadOfItsSurface are the permissions a role holds for a surface
// that has not been built.
//
// Named here rather than dropped from the catalogue, and named individually
// rather than by prefix, so the list can only grow by somebody writing an
// entry and saying why.
//
// platform.audit.read: the auditor role is defined by SRS-IAM-014 and the
// audit trail it names is written and stored, but nothing reads it back over
// the API yet — there is no audit-query RPC. The permission is the access the
// role will hold; until the surface exists it grants nothing, which is the
// honest state and not a silent one.
var grantedAheadOfItsSurface = map[string]bool{
	"platform.audit.read": true,
}

// permissionsIn collects the permission names quoted in Go source, ignoring
// line comments.
func permissionsIn(source string) map[string]bool {
	out := map[string]bool{}
	for _, line := range strings.Split(source, "\n") {
		for _, match := range permissionLiteral.FindAllStringSubmatch(
			lineComment.ReplaceAllString(line, ""), -1) {
			out[match[1]] = true
		}
	}
	return out
}

// TestPermissionLiteralDetectorWorks guards the guard above, which passes when
// it finds nothing.
func TestPermissionLiteralDetectorWorks(t *testing.T) {
	found := permissionsIn(`
		"ane.recovery.override",
		PermTheatreRead = "ot.case.read"
		// Deliberately no ot.case.schedule: not this role's job.
		// Nor "ot.preop.waive", which the prose quotes.
		healthcare.anaesthesia.v1
		notAPermission := "two.segments"
	`)
	for _, want := range []string{"ane.recovery.override", "ot.case.read"} {
		if !found[want] {
			t.Errorf("detector missed a grant: %q", want)
		}
	}
	for _, unwanted := range []string{
		"ot.case.schedule", "ot.preop.waive",
		"healthcare.anaesthesia.v1", "two.segments",
	} {
		if found[unwanted] {
			t.Errorf("detector fired on %q", unwanted)
		}
	}
}
