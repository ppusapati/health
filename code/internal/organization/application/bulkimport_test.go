package application_test

import (
	"context"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/ppusapati/health/code/internal/organization/application"
	"github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

const importHeader = "unit_type,code,display_name,facility_id,parent_code," +
	"effective_from,effective_until,accepts_activity_when_inactive\n"

func importFile(rows ...string) string {
	return importHeader + strings.Join(rows, "\n") + "\n"
}

func countUnits(t *testing.T, h harness) int {
	t.Helper()
	var n int
	err := h.pool.QueryRow(context.Background(),
		`SELECT count(*) FROM organization.org_unit WHERE tenant_id = $1`, h.tenant).Scan(&n)
	if err != nil {
		t.Fatalf("count units: %v", err)
	}
	return n
}

// SRS-PLT-009's verification clause: a dry run reports row-level errors and
// creates no records. The second half is asserted against the database, not
// against a returned counter — a counter is what the code says it did, and the
// row count is what it did.
func TestDryRunCreatesNothing(t *testing.T) {
	h := newHarness(t)
	file := importFile(
		"department,CARD,Cardiology,,,2026-01-01,,false",
		"specialty,NEURO,Neurology,,,2026-01-01,,false",
	)

	outcome, err := h.svc.ImportOrgUnits(h.admin(), h.md, strings.NewReader(file), true)
	if err != nil {
		t.Fatalf("ImportOrgUnits: %v", err)
	}
	if !outcome.DryRun {
		t.Fatal("the outcome does not record that it was a dry run")
	}
	if outcome.Valid != 2 || outcome.Total != 2 {
		t.Fatalf("valid=%d total=%d, want 2 and 2", outcome.Valid, outcome.Total)
	}
	if outcome.Applied != 0 {
		t.Fatalf("a dry run reported %d rows applied", outcome.Applied)
	}
	if n := countUnits(t, h); n != 0 {
		t.Fatalf("a dry run created %d rows in the database", n)
	}
}

// A load that reports "import failed: invalid input" against a 4,000-row
// spreadsheet is a load nobody can fix. Every error names its line and column.
func TestDryRunReportsRowLevelErrors(t *testing.T) {
	h := newHarness(t)
	file := importFile(
		"department,CARD,Cardiology,,,2026-01-01,,false", // line 2, valid
		"ward,ORTHO,Orthopaedics,,,2026-01-01,,false",    // line 3, bad unit_type
		"department,,Missing Code,,,2026-01-01,,false",   // line 4, no code
		"department,ENT,ENT,,,not-a-date,,false",         // line 5, bad date
		"department,GAS,Gastro,,,2026-01-01,,maybe",      // line 6, bad boolean
	)

	outcome, err := h.svc.ImportOrgUnits(h.admin(), h.md, strings.NewReader(file), true)
	if err != nil {
		t.Fatalf("ImportOrgUnits: %v", err)
	}
	if outcome.Total != 5 {
		t.Fatalf("total=%d, want 5", outcome.Total)
	}
	if outcome.Valid != 1 {
		t.Fatalf("valid=%d, want 1", outcome.Valid)
	}
	if n := countUnits(t, h); n != 0 {
		t.Fatalf("the dry run created %d rows", n)
	}

	byLine := map[int]application.RowError{}
	for _, e := range outcome.Errors {
		byLine[e.Line] = e
	}
	expected := map[int]struct{ column, reason string }{
		3: {"unit_type", application.ReasonUnknownValue},
		4: {"code", application.ReasonMissingValue},
		5: {"effective_from", application.ReasonMalformedDate},
		6: {"accepts_activity_when_inactive", application.ReasonMalformedBoolean},
	}
	for line, want := range expected {
		got, found := byLine[line]
		if !found {
			t.Errorf("line %d produced no error", line)
			continue
		}
		if got.Column != want.column {
			t.Errorf("line %d: column %q, want %q", line, got.Column, want.column)
		}
		if got.Reason != want.reason {
			t.Errorf("line %d: reason %q, want %q", line, got.Reason, want.reason)
		}
	}
	if _, found := byLine[2]; found {
		t.Error("the valid row was reported as an error")
	}
}

// Line numbers must match what the administrator sees in their spreadsheet,
// header included, or every error sends them to the wrong row.
func TestLineNumbersMatchTheSpreadsheet(t *testing.T) {
	h := newHarness(t)
	file := importFile(
		"department,CARD,Cardiology,,,2026-01-01,,false", // spreadsheet line 2
		"ward,BAD,Bad Row,,,2026-01-01,,false",           // spreadsheet line 3
	)
	outcome, err := h.svc.ImportOrgUnits(h.admin(), h.md, strings.NewReader(file), true)
	if err != nil {
		t.Fatalf("ImportOrgUnits: %v", err)
	}
	if len(outcome.Errors) != 1 {
		t.Fatalf("want 1 error, got %d", len(outcome.Errors))
	}
	if outcome.Errors[0].Line != 3 {
		t.Fatalf("error reported on line %d, want 3 (the header is line 1)", outcome.Errors[0].Line)
	}
}

// Duplicates within the file are caught by the validator rather than left to
// the unique index. The index rejects the second row only after the first is
// written, so a real import would half-succeed — and a dry run, which writes
// nothing, would report no problem at all.
func TestDuplicatesWithinTheFileAreCaughtByTheDryRun(t *testing.T) {
	h := newHarness(t)
	file := importFile(
		"department,CARD,Cardiology,,,2026-01-01,,false",
		"department,CARD,Cardiology Duplicate,,,2026-01-01,,false",
	)

	outcome, err := h.svc.ImportOrgUnits(h.admin(), h.md, strings.NewReader(file), true)
	if err != nil {
		t.Fatalf("ImportOrgUnits: %v", err)
	}
	if len(outcome.Errors) != 1 {
		t.Fatalf("want 1 duplicate error, got %d: %v", len(outcome.Errors), outcome.Errors)
	}
	e := outcome.Errors[0]
	if e.Reason != application.ReasonDuplicateInFile {
		t.Fatalf("reason %q, want %q", e.Reason, application.ReasonDuplicateInFile)
	}
	// The message has to say which earlier line, or the administrator searches
	// the file by hand.
	if !strings.Contains(e.Detail, "line 2") {
		t.Errorf("the duplicate error does not name the first occurrence: %q", e.Detail)
	}
	// The same code under a different unit type is not a duplicate.
	mixed := importFile(
		"department,CARD,Cardiology,,,2026-01-01,,false",
		"specialty,CARD,Cardiology Specialty,,,2026-01-01,,false",
	)
	outcome, err = h.svc.ImportOrgUnits(h.admin(), h.md, strings.NewReader(mixed), true)
	if err != nil {
		t.Fatalf("ImportOrgUnits: %v", err)
	}
	if len(outcome.Errors) != 0 {
		t.Fatalf("the same code under two unit types was reported as a duplicate: %v", outcome.Errors)
	}
}

// A partial import is worse than none: the administrator has to work out which
// rows landed, and re-running hits unique violations on exactly the rows that
// succeeded.
func TestAFileWithAnyErrorImportsNothing(t *testing.T) {
	h := newHarness(t)
	file := importFile(
		"department,CARD,Cardiology,,,2026-01-01,,false",
		"department,NEURO,Neurology,,,2026-01-01,,false",
		"ward,BAD,Bad Row,,,2026-01-01,,false",
	)

	_, err := h.svc.ImportOrgUnits(h.admin(), h.md, strings.NewReader(file), false)
	if got := categoryOf(t, err); got != rpcerr.CategoryInvalidArgument {
		t.Fatalf("want INVALID_ARGUMENT, got %v", got)
	}
	if n := countUnits(t, h); n != 0 {
		t.Fatalf("%d valid rows were imported from a file containing an error", n)
	}
}

func TestACleanFileImports(t *testing.T) {
	h := newHarness(t)
	file := importFile(
		"department,CARD,Cardiology,,,2026-01-01,,false",
		"specialty,NEURO,Neurology,,,2026-01-01,2027-01-01,true",
		"cost_center,CC100,Theatres,,,2026-01-01,,no",
	)

	outcome, err := h.svc.ImportOrgUnits(h.admin(), h.md, strings.NewReader(file), false)
	if err != nil {
		t.Fatalf("ImportOrgUnits: %v", err)
	}
	if outcome.Applied != 3 {
		t.Fatalf("applied=%d, want 3", outcome.Applied)
	}
	if n := countUnits(t, h); n != 3 {
		t.Fatalf("%d rows in the database, want 3", n)
	}
}

// The whole file lands in one transaction, so a failure partway through leaves
// nothing behind. Driven by importing a file that collides with existing data.
func TestARealImportIsAllOrNothing(t *testing.T) {
	h := newHarness(t)
	ctx := h.admin()

	if _, err := h.svc.CreateOrgUnit(ctx, h.md, application.CreateOrgUnitInput{
		Type: domain.UnitDepartment, Code: "CARD", DisplayName: "Cardiology",
		EffectiveFrom: day(2026, time.January, 1),
	}); err != nil {
		t.Fatalf("CreateOrgUnit: %v", err)
	}

	// Two new rows and one that collides with what is already there. The
	// collision is invisible to the validator, which sees only the file.
	file := importFile(
		"department,ORTHO,Orthopaedics,,,2026-01-01,,false",
		"department,ENT,ENT,,,2026-01-01,,false",
		"department,CARD,Cardiology Again,,,2026-01-01,,false",
	)
	outcome, err := h.svc.ImportOrgUnits(ctx, h.md, strings.NewReader(file), false)
	if err == nil {
		t.Fatal("the colliding import succeeded")
	}
	if outcome.Applied != 0 {
		t.Fatalf("the outcome reports %d applied after a rollback", outcome.Applied)
	}
	if n := countUnits(t, h); n != 1 {
		t.Fatalf("%d units exist; the rollback left partial rows behind", n)
	}
}

// A header the importer silently reorders is a header somebody will reorder
// differently next time, and the import then maps the wrong columns without
// failing.
func TestTemplateMismatchIsRejected(t *testing.T) {
	h := newHarness(t)

	cases := map[string]string{
		"reordered columns": "code,unit_type,display_name,facility_id,parent_code," +
			"effective_from,effective_until,accepts_activity_when_inactive\n" +
			"CARD,department,Cardiology,,,2026-01-01,,false\n",
		"missing column": "unit_type,code,display_name\ndepartment,CARD,Cardiology\n",
		"empty file":     "",
	}
	for name, file := range cases {
		t.Run(name, func(t *testing.T) {
			_, err := h.svc.ImportOrgUnits(h.admin(), h.md, strings.NewReader(file), true)
			if got := categoryOf(t, err); got != rpcerr.CategoryInvalidArgument {
				t.Fatalf("want INVALID_ARGUMENT, got %v", got)
			}
		})
	}
}

// Every file saved from Excel starts with a BOM. Failing them all for a reason
// no administrator can see is how a template stops being used.
func TestAByteOrderMarkIsTolerated(t *testing.T) {
	h := newHarness(t)
	// "\ufeff" rather than the literal character, so the byte is visible in
	// review and survives an editor that normalises encodings.
	file := "\ufeff" + importFile("department,CARD,Cardiology,,,2026-01-01,,false")

	outcome, err := h.svc.ImportOrgUnits(h.admin(), h.md, strings.NewReader(file), true)
	if err != nil {
		t.Fatalf("a file with a BOM was rejected: %v", err)
	}
	if outcome.Valid != 1 {
		t.Fatalf("valid=%d, want 1", outcome.Valid)
	}
}

// Administrators type "yes", "Y" and "TRUE" in the same column of the same
// file. Rejecting all but Go's spelling turns a data-entry habit into a failed
// import.
func TestBooleanSpellingsAdministratorsActuallyUse(t *testing.T) {
	h := newHarness(t)
	file := importFile(
		"department,A,Alpha,,,2026-01-01,,yes",
		"department,B,Bravo,,,2026-01-01,,TRUE",
		"department,C,Charlie,,,2026-01-01,,Y",
		"department,D,Delta,,,2026-01-01,,no",
		"department,E,Echo,,,2026-01-01,,",
	)
	outcome, err := h.svc.ImportOrgUnits(h.admin(), h.md, strings.NewReader(file), true)
	if err != nil {
		t.Fatalf("ImportOrgUnits: %v", err)
	}
	if len(outcome.Errors) != 0 {
		t.Fatalf("common boolean spellings were rejected: %v", outcome.Errors)
	}
}

// The validator takes no repository, which is what makes "creates no records"
// structural rather than a flag somebody must check on every path.
func TestTheValidatorCannotWrite(t *testing.T) {
	file := importFile("department,CARD,Cardiology,,,2026-01-01,,false")
	inputs, outcome, err := application.ValidateOrgUnitImport(
		strings.NewReader(file), uuid.NewString(), now)
	if err != nil {
		t.Fatalf("ValidateOrgUnitImport: %v", err)
	}
	if len(inputs) != 1 || outcome.Valid != 1 {
		t.Fatalf("inputs=%d valid=%d", len(inputs), outcome.Valid)
	}
	if outcome.Applied != 0 {
		t.Fatal("the validator reported rows applied")
	}
}

func TestImportNeedsThePermission(t *testing.T) {
	h := newHarness(t)
	file := importFile("department,CARD,Cardiology,,,2026-01-01,,false")

	// Even a dry run is privileged: validating a file reveals which codes
	// already exist.
	_, err := h.svc.ImportOrgUnits(h.as("clerk"), h.md, strings.NewReader(file), true)
	if got := categoryOf(t, err); got != rpcerr.CategoryPermissionDenied {
		t.Fatalf("want PERMISSION_DENIED for a dry run without the permission, got %v", got)
	}
}

func TestTemplateHeaderMatchesTheValidator(t *testing.T) {
	header := application.OrgUnitTemplateHeader()
	if strings.Join(header, ",")+"\n" != importHeader {
		t.Fatalf("the exported template header %v does not match what the validator accepts", header)
	}
	// The returned slice is a copy: a caller mutating it must not change what
	// the validator accepts.
	header[0] = "tampered"
	if application.OrgUnitTemplateHeader()[0] == "tampered" {
		t.Fatal("the template header is shared mutable state")
	}
}
