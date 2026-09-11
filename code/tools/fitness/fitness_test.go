// Package fitness holds the architecture fitness tests.
//
// These run in CI on every change and encode the rules from the Domain, Data,
// API, Event & Security Architecture Specification §17. They exist because
// layering conventions decay silently: a single import added under deadline
// pressure is invisible in review but obvious to a test.
//
// Each test names the FIT rule it enforces.
package fitness_test

import (
	"go/ast"
	"go/parser"
	"go/token"
	"os"
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
		`(organization|identity_access|platform_data|platform_workflow|platform_rules|platform_edge)\.[a-z_]+`)

// schemaOwners maps a schema to the one package path allowed to reach it.
var schemaOwners = map[string]string{
	"organization":      "internal/organization/adapters/postgres",
	"identity_access":   "internal/identity_access/adapters/postgres",
	"platform_data":     "internal/platform/store",
	"platform_workflow": "internal/platform/workflow",
	"platform_rules":    "internal/platform/rules",
	"platform_edge":     "internal/edge/cloudstore",
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
	allowed := []string{
		"internal/organization/adapters/postgres",
		"internal/identity_access/adapters/postgres",
		"internal/platform/store",
		"internal/platform/workflow",
		"internal/edge/cloudstore",
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

// FIT-03: every tenant-owned repository method must take a verified
// authctx.TenantScope rather than a bare tenant string.
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
		if regexp.MustCompile(`tenantID\s+string`).MatchString(text) &&
			!strings.Contains(text, "TenantRepository") {
			t.Errorf("FIT-03: %s accepts a bare tenant string", f.rel)
		}

		if strings.Contains(text, "FacilityRepository") &&
			!strings.Contains(text, "authctx.TenantScope") {
			t.Errorf("FIT-03: %s declares a tenant-owned repository without TenantScope", f.rel)
		}
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

	for _, f := range loadGoFiles(t) {
		if strings.HasSuffix(f.rel, "_test.go") {
			continue
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
}

// FIT-08: signed or finalised records must not have a generic update or delete
// path. Wave 0 has no clinical aggregate yet, so this guards the boundary that
// exists today: retired masters and the append-only platform tables.
func TestFIT08_NoDeleteOnAppendOnlyTables(t *testing.T) {
	appendOnly := []string{"audit_record", "outbox_event", "inbox_message"}

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
			if strings.Contains(text, "delete from platform_data."+table) {
				t.Errorf("FIT-08: %s deletes from append-only table %q", f.rel, table)
			}
		}
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
// (Blueprint §4.2).
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
