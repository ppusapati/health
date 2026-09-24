// Continuous-integration invariants.
//
// Four Wave-0 requirements are verified by the build rather than by a running
// system: their clauses are "CI detects drift", "the build reproducibly
// generates contract code", "CI compiles queries against the schema" and
// "secret scanning blocks commit/build violations". Nothing a service does at
// runtime can demonstrate any of them.
//
// That leaves them provable only by the workflow files, and a workflow file is
// the easiest thing in the repository to weaken: a job that is deleted, renamed
// or quietly switched to continue-on-error removes a gate and changes no code.
// These tests are the gate on the gates.
package infra_test

import (
	"encoding/json"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"gopkg.in/yaml.v3"
)

// workflow is one parsed GitHub Actions workflow.
type workflow struct {
	path string
	data map[string]any
}

func loadWorkflow(t *testing.T, name string) workflow {
	t.Helper()
	path := filepath.Join(repoRoot(t), "..", ".github", "workflows", name)
	raw, err := os.ReadFile(path)
	if err != nil {
		t.Fatalf("read %s: %v", name, err)
	}
	var data map[string]any
	if err := yaml.Unmarshal(raw, &data); err != nil {
		t.Fatalf("parse %s: %v", name, err)
	}
	return workflow{path: path, data: data}
}

// steps returns every run command in a workflow, flattened. The job a command
// sits in does not matter here: what matters is that the command still runs.
func (w workflow) steps(t *testing.T) []string {
	t.Helper()
	jobs, ok := w.data["jobs"].(map[string]any)
	if !ok {
		t.Fatalf("%s declares no jobs", w.path)
	}

	var out []string
	for name, raw := range jobs {
		job, ok := raw.(map[string]any)
		if !ok {
			continue
		}
		if cont, ok := job["continue-on-error"].(bool); ok && cont {
			// A job that cannot fail the build is not a gate. Reported here
			// rather than silently skipped, because the change that adds this
			// line is exactly the change these tests exist to catch.
			t.Errorf("%s: job %q is continue-on-error, so it gates nothing",
				w.path, name)
		}
		list, _ := job["steps"].([]any)
		for _, rawStep := range list {
			step, ok := rawStep.(map[string]any)
			if !ok {
				continue
			}
			if run, ok := step["run"].(string); ok {
				out = append(out, run)
			}
			if uses, ok := step["uses"].(string); ok {
				out = append(out, uses)
			}
		}
	}
	return out
}

func requireStep(t *testing.T, w workflow, substring, why string) {
	t.Helper()
	for _, step := range w.steps(t) {
		if strings.Contains(step, substring) {
			return
		}
	}
	t.Errorf("%s runs nothing containing %q; %s", w.path, substring, why)
}

// SRS-SEC-003's verification clause: secret scanning blocks commit and build
// violations. The configuration file existing is not the requirement — a
// .gitleaks.toml nothing runs is a document.
func TestSecretScanningRuns(t *testing.T) {
	security := loadWorkflow(t, "security.yml")
	requireStep(t, security, "gitleaks detect",
		"SRS-SEC-003 asks for scanning that blocks, not a configuration file")
	requireStep(t, security, "--exit-code 1",
		"a scan that reports and exits zero blocks nothing")
}

// SRS-API-001's verification clause: the build reproducibly generates contract
// code. SRS-WEB-002's: CI detects incompatible schema and client generation
// drift. Both are the same mechanism — regenerate, then fail on a dirty tree —
// applied to the Go, TypeScript and Dart outputs.
func TestGeneratedContractCodeIsCheckedForDrift(t *testing.T) {
	ci := loadWorkflow(t, "ci.yml")
	for _, target := range []string{
		"make generate-check",
		"make web-generate-check",
		"make mobile-generate-check",
	} {
		requireStep(t, ci, target,
			"a generated client nothing regenerates drifts from its contract "+
				"silently, which is the failure SRS-API-001 and SRS-WEB-002 name")
	}
}

// SRS-DAT-002's verification clause: CI compiles the queries against the
// schema. sqlc does that as part of generation, so the check that the generated
// output is current is also the check that every query still typechecks against
// the migrations — a query that no longer matches its table cannot generate.
//
// The workflow reaches it through the Makefile, so the chain is asserted in two
// links rather than by looking for "sqlc" in a file that does not mention it.
func TestQueriesAreCompiledAgainstTheSchema(t *testing.T) {
	ci := loadWorkflow(t, "ci.yml")
	requireStep(t, ci, "make generate-check",
		"SRS-DAT-002 asks CI to compile the queries")

	makefile, err := os.ReadFile(filepath.Join(repoRoot(t), "Makefile"))
	if err != nil {
		t.Fatalf("read Makefile: %v", err)
	}
	if !strings.Contains(string(makefile), "sqlc generate") {
		t.Error("the generate target no longer runs sqlc, so nothing compiles " +
			"the queries against the schema")
	}
}

// The traceability gate runs in CI rather than only in `make verify`.
//
// It did not, which is how a status document came to claim four requirements
// nothing had built. A gate that runs only when somebody remembers to run it is
// a gate for the people who already check.
func TestTraceabilityGateRuns(t *testing.T) {
	ci := loadWorkflow(t, "ci.yml")
	requireStep(t, ci, "make traceability",
		"a requirement claimed with no test is exactly what this gate catches")
}

// SRS-NFR-014's verification clause: an automated cross-browser smoke suite
// passes. A support matrix nothing exercises is a promise, so the gate is the
// suite running rather than the matrix being written down.
func TestCrossBrowserSmokeRuns(t *testing.T) {
	ci := loadWorkflow(t, "ci.yml")
	requireStep(t, ci, "playwright",
		"SRS-NFR-014 asks for an automated cross-browser suite")
}

// SRS-WEB-001's verification clause: no parallel React or Angular operational
// UI is introduced. Asserted against the manifest the browser actually builds
// from, because a second framework arrives as a dependency long before it
// arrives as a screen.
func TestNoSecondBrowserFramework(t *testing.T) {
	raw, err := os.ReadFile(filepath.Join(repoRoot(t), "apps", "web", "package.json"))
	if err != nil {
		t.Fatalf("read the web package manifest: %v", err)
	}
	var manifest struct {
		Dependencies    map[string]string `json:"dependencies"`
		DevDependencies map[string]string `json:"devDependencies"`
	}
	if err := json.Unmarshal(raw, &manifest); err != nil {
		t.Fatalf("parse the web package manifest: %v", err)
	}

	banned := []string{"react", "react-dom", "@angular/core", "vue", "next"}
	for _, group := range []map[string]string{
		manifest.Dependencies, manifest.DevDependencies,
	} {
		for name := range group {
			for _, bad := range banned {
				if name == bad {
					t.Errorf("the web workspace depends on %q; SRS-WEB-001 keeps "+
						"the operational UI on one framework", name)
				}
			}
		}
	}
	if len(manifest.Dependencies)+len(manifest.DevDependencies) == 0 {
		t.Fatal("no dependencies parsed; this assertion would pass vacuously")
	}
}

// The detector has to be able to fail, or the tests above pass whatever
// the workflows say.
func TestWorkflowStepDetectorWorks(t *testing.T) {
	ci := loadWorkflow(t, "ci.yml")
	for _, step := range ci.steps(t) {
		if strings.Contains(step, "a command no workflow runs") {
			t.Fatal("the fixture string was found; the detector proves nothing")
		}
	}
	if len(ci.steps(t)) == 0 {
		t.Fatal("no steps parsed; every workflow assertion would pass vacuously")
	}
}
