package application

import (
	"context"
	"encoding/csv"
	"errors"
	"fmt"
	"io"
	"strconv"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/policy"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Bulk master-data import (SRS-PLT-009).
//
// The verification clause is the design: "dry run reports row-level errors and
// creates no records". Two properties follow, and the second is the one that
// is usually got wrong.
//
//	Row-level    a failure names the row and the column. A load that reports
//	             "import failed: invalid input" against a 4,000-row spreadsheet
//	             is a load nobody can fix — the administrator's next move is to
//	             bisect the file by hand.
//	No records   a dry run must be unable to write, not merely choose not to.
//	             The usual implementation passes a boolean into the same code
//	             path as the real import, and the one branch that forgets to
//	             check it writes. Here, validation and application are separate
//	             functions: Validate takes no repository at all, so there is
//	             nothing for it to write to.

// ImportOutcome describes what happened, or what would happen.
type ImportOutcome struct {
	DryRun bool
	// Total is every data row read, including the failures.
	Total int
	// Valid is the rows that would be created.
	Valid int
	// Errors are row-level problems, in file order.
	Errors []RowError
	// Applied is how many rows were actually written. Always zero on a dry
	// run, and asserted as such by test: this is the field that proves the
	// requirement rather than describing it.
	Applied int
}

// RowError names one problem, precisely enough to fix it.
type RowError struct {
	// Line is the 1-based line number in the source file, header included, so
	// it matches what a spreadsheet shows.
	Line   int
	Column string
	Value  string
	// Reason is a stable code, not prose: the UI localises it, and the same
	// import run may be read by people in different locales.
	Reason string
	Detail string
}

func (e RowError) Error() string {
	return fmt.Sprintf("line %d, column %s: %s (%s)", e.Line, e.Column, e.Reason, e.Detail)
}

// Stable import reason codes.
const (
	ReasonMissingValue     = "MISSING_VALUE"
	ReasonUnknownValue     = "UNKNOWN_VALUE"
	ReasonMalformedDate    = "MALFORMED_DATE"
	ReasonMalformedBoolean = "MALFORMED_BOOLEAN"
	ReasonDuplicateInFile  = "DUPLICATE_IN_FILE"
	ReasonInvalidRecord    = "INVALID_RECORD"
	ReasonWrongColumnCount = "WRONG_COLUMN_COUNT"
)

// ErrTemplateMismatch reports a file whose header is not the expected
// template. Distinct from a row error because it is not fixable per row: the
// administrator exported the wrong template or edited the header.
var ErrTemplateMismatch = errors.New("organization: file does not match the import template")

// orgUnitTemplate is the validated template for organisational units.
//
// Fixed order rather than name-matching. A header the importer reorders
// silently is a header somebody will reorder differently next time, and the
// resulting import maps the wrong columns without failing.
var orgUnitTemplate = []string{
	"unit_type", "code", "display_name", "facility_id", "parent_code",
	"effective_from", "effective_until", "accepts_activity_when_inactive",
}

// ValidateOrgUnitImport parses and checks a file, writing nothing.
//
// It takes no repository. That is the point: a dry run cannot create records
// because this function has nothing to create them with, rather than because a
// flag was checked correctly on every path.
func ValidateOrgUnitImport(r io.Reader, tenantID string, now time.Time) ([]CreateOrgUnitInput, ImportOutcome, error) {
	reader := csv.NewReader(r)
	// Fixed field count off, so a short row produces a row-level error naming
	// the line rather than aborting the whole parse.
	reader.FieldsPerRecord = -1

	header, err := reader.Read()
	if errors.Is(err, io.EOF) {
		return nil, ImportOutcome{}, fmt.Errorf("%w: the file is empty", ErrTemplateMismatch)
	}
	if err != nil {
		return nil, ImportOutcome{}, fmt.Errorf("%w: %v", ErrTemplateMismatch, err)
	}
	if err := checkTemplate(header); err != nil {
		return nil, ImportOutcome{}, err
	}

	var (
		inputs   []CreateOrgUnitInput
		outcome  ImportOutcome
		seenCode = map[string]int{}
		line     = 1 // the header
	)

	for {
		record, err := reader.Read()
		if errors.Is(err, io.EOF) {
			break
		}
		line++
		if err != nil {
			outcome.Total++
			outcome.Errors = append(outcome.Errors, RowError{
				Line: line, Column: "-", Reason: ReasonWrongColumnCount, Detail: err.Error(),
			})
			continue
		}
		outcome.Total++

		if len(record) != len(orgUnitTemplate) {
			outcome.Errors = append(outcome.Errors, RowError{
				Line: line, Column: "-", Reason: ReasonWrongColumnCount,
				Detail: fmt.Sprintf("expected %d columns, found %d", len(orgUnitTemplate), len(record)),
			})
			continue
		}

		input, rowErrors := parseOrgUnitRow(record, line)

		// Duplicates within the file are caught here rather than left to the
		// unique index. The index would reject the second row after the first
		// was written, so a real import would half-succeed — and a dry run,
		// which writes nothing, would report no problem at all and then the
		// real run would fail.
		if input.Code != "" {
			key := string(input.Type) + "/" + input.Code
			if first, seen := seenCode[key]; seen {
				rowErrors = append(rowErrors, RowError{
					Line: line, Column: "code", Value: input.Code,
					Reason: ReasonDuplicateInFile,
					Detail: fmt.Sprintf("already used on line %d", first),
				})
			} else {
				seenCode[key] = line
			}
		}

		if len(rowErrors) > 0 {
			outcome.Errors = append(outcome.Errors, rowErrors...)
			continue
		}

		// Construct the domain object to catch what the parser cannot: the
		// invariants live there, and duplicating them here would mean two
		// definitions of a valid unit that drift apart.
		if _, err := domain.NewOrgUnit("probe", tenantID, input.FacilityID, input.Type,
			input.Code, input.DisplayName, "", input.EffectiveFrom, input.EffectiveUntil,
			input.AcceptsActivityWhenInactive, now); err != nil {
			outcome.Errors = append(outcome.Errors, RowError{
				Line: line, Column: "-", Reason: ReasonInvalidRecord, Detail: err.Error(),
			})
			continue
		}

		outcome.Valid++
		inputs = append(inputs, input)
	}

	return inputs, outcome, nil
}

// utf8BOM is what a spreadsheet export puts on the first cell. Written as an
// escape rather than the literal character so the byte is visible in review
// and cannot be lost by an editor that normalises encodings.
const utf8BOM = "\ufeff"

func checkTemplate(header []string) error {
	if len(header) != len(orgUnitTemplate) {
		return fmt.Errorf("%w: expected %d columns, found %d",
			ErrTemplateMismatch, len(orgUnitTemplate), len(header))
	}
	for i, want := range orgUnitTemplate {
		// Trim the UTF-8 BOM a spreadsheet export puts on the first cell;
		// otherwise every file saved from Excel fails template validation for
		// a reason no administrator can see.
		got := strings.TrimSpace(strings.TrimPrefix(header[i], utf8BOM))
		if !strings.EqualFold(got, want) {
			return fmt.Errorf("%w: column %d is %q, expected %q", ErrTemplateMismatch, i+1, got, want)
		}
	}
	return nil
}

func parseOrgUnitRow(record []string, line int) (CreateOrgUnitInput, []RowError) {
	var errs []RowError
	field := func(i int) string { return strings.TrimSpace(record[i]) }

	in := CreateOrgUnitInput{
		Code:        field(1),
		DisplayName: field(2),
		FacilityID:  field(3),
	}

	unitType := domain.UnitType(strings.ToLower(field(0)))
	switch unitType {
	case domain.UnitDepartment, domain.UnitSpecialty, domain.UnitCostCenter,
		domain.UnitServiceUnit, domain.UnitCareLocation:
		in.Type = unitType
	case "":
		errs = append(errs, RowError{Line: line, Column: "unit_type", Reason: ReasonMissingValue})
	default:
		errs = append(errs, RowError{
			Line: line, Column: "unit_type", Value: field(0), Reason: ReasonUnknownValue,
			Detail: "expected one of department, specialty, cost_center, service_unit, care_location",
		})
	}

	if in.Code == "" {
		errs = append(errs, RowError{Line: line, Column: "code", Reason: ReasonMissingValue})
	}
	if in.DisplayName == "" {
		errs = append(errs, RowError{Line: line, Column: "display_name", Reason: ReasonMissingValue})
	}

	from, err := parseImportDate(field(5))
	if err != nil {
		errs = append(errs, RowError{
			Line: line, Column: "effective_from", Value: field(5),
			Reason: ReasonMalformedDate, Detail: "expected YYYY-MM-DD",
		})
	} else if from.IsZero() {
		errs = append(errs, RowError{Line: line, Column: "effective_from", Reason: ReasonMissingValue})
	} else {
		in.EffectiveFrom = from
	}

	if until, err := parseImportDate(field(6)); err != nil {
		errs = append(errs, RowError{
			Line: line, Column: "effective_until", Value: field(6),
			Reason: ReasonMalformedDate, Detail: "expected YYYY-MM-DD, or empty for open-ended",
		})
	} else {
		in.EffectiveUntil = until
	}

	if accepts, err := parseImportBool(field(7)); err != nil {
		errs = append(errs, RowError{
			Line: line, Column: "accepts_activity_when_inactive", Value: field(7),
			Reason: ReasonMalformedBoolean, Detail: "expected true, false, yes, no, or empty",
		})
	} else {
		in.AcceptsActivityWhenInactive = accepts
	}

	return in, errs
}

// parseImportDate accepts YYYY-MM-DD, or empty for "not set".
func parseImportDate(value string) (time.Time, error) {
	if value == "" {
		return time.Time{}, nil
	}
	return time.Parse("2006-01-02", value)
}

// parseImportBool accepts what a spreadsheet actually contains.
//
// Administrators type "yes", "Y" and "TRUE" in the same column of the same
// file. Rejecting all but Go's own spelling turns a data-entry habit into a
// failed import, and the fix an administrator reaches for is to stop using the
// template.
func parseImportBool(value string) (bool, error) {
	switch strings.ToLower(value) {
	case "", "false", "no", "n", "0":
		return false, nil
	case "true", "yes", "y", "1":
		return true, nil
	default:
		if b, err := strconv.ParseBool(value); err == nil {
			return b, nil
		}
		return false, fmt.Errorf("not a boolean: %q", value)
	}
}

// ImportOrgUnits validates a file and, unless dryRun, creates the units
// (SRS-PLT-009).
//
// All-or-nothing on a real run: the whole file is applied in one transaction,
// so a failure on row 3,000 leaves nothing behind. A partial import is worse
// than none — the administrator has to work out which rows landed before
// re-running, and re-running a partially applied file hits unique violations
// on exactly the rows that succeeded.
func (s *Service) ImportOrgUnits(ctx context.Context, p MasterDataPorts,
	r io.Reader, dryRun bool) (ImportOutcome, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return ImportOutcome{}, rpcerr.Unauthenticated("AUTH_NO_SESSION", "authentication required")
	}

	decision := policy.Evaluate(session, policy.Request{
		Permission: PermUnitManage,
		// A dry run reads the file and writes nothing, but it still has to be
		// a privileged act: the file itself is master data, and validating it
		// reveals which codes already exist.
		Mutating:   !dryRun,
		TenantMode: policy.TenantModeReadWrite,
	})
	if !decision.Allowed {
		s.auditDenied(ctx, session, PermUnitManage, "org_unit_import", "", decision.Reason)
		return ImportOutcome{}, rpcerr.PermissionDenied("ORG_IMPORT_DENIED", decision.Reason)
	}

	now := s.clock.Now()
	inputs, outcome, err := ValidateOrgUnitImport(r, session.TenantID, now)
	if errors.Is(err, ErrTemplateMismatch) {
		return ImportOutcome{}, rpcerr.Invalid("ORG_IMPORT_TEMPLATE_MISMATCH", err.Error())
	}
	if err != nil {
		return ImportOutcome{}, err
	}
	outcome.DryRun = dryRun

	if dryRun {
		// Applied stays zero. Nothing above this line could have written: the
		// validator has no repository.
		return outcome, nil
	}

	// A file with any error is not applied at all. Importing the valid rows
	// and reporting the rest would leave the administrator with a half-loaded
	// hospital and no way to tell which half.
	if len(outcome.Errors) > 0 {
		return outcome, rpcerr.Invalid("ORG_IMPORT_HAS_ERRORS",
			fmt.Sprintf("%d of %d rows are invalid; nothing was imported",
				len(outcome.Errors), outcome.Total))
	}

	scope := session.TenantScope()
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		for _, in := range inputs {
			unit, err := domain.NewOrgUnit(s.ids.NewID(), session.TenantID, in.FacilityID,
				in.Type, in.Code, in.DisplayName, in.ParentUnitID,
				in.EffectiveFrom, in.EffectiveUntil, in.AcceptsActivityWhenInactive, now)
			if err != nil {
				return rpcerr.Invalid("ORG_UNIT_INVALID", err.Error())
			}
			if err := p.Units.InsertOrgUnit(ctx, scope, unit); err != nil {
				return err
			}
			outcome.Applied++
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermUnitManage,
			ResourceType: "org_unit_import", ResourceID: "",
			Outcome: audit.OutcomeSuccess,
			Reason:  fmt.Sprintf("imported %d units", outcome.Applied),
		}, now)
	})
	if err != nil {
		// The transaction rolled back, so nothing was applied whatever the
		// counter reached before the failure.
		outcome.Applied = 0
		return outcome, err
	}
	return outcome, nil
}

// OrgUnitTemplateHeader returns the import template's header row, so the
// export and the validator cannot disagree about it.
func OrgUnitTemplateHeader() []string {
	header := make([]string, len(orgUnitTemplate))
	copy(header, orgUnitTemplate)
	return header
}
