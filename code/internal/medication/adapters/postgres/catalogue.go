package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/medication/domain"
	"github.com/ppusapati/health/code/internal/medication/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Catalogue persists the rules a tenant configures (SRS-MED-003, SRS-MED-004,
// SRS-MED-006, SRS-MED-012).
type Catalogue struct{ *Repository }

// NewCatalogue constructs the adapter.
func NewCatalogue(r *Repository) Catalogue { return Catalogue{r} }

var _ ports.CatalogueRepository = Catalogue{}

// UpsertFormularyEntry records a medication's position in one scope
// (SRS-MED-012).
func (c Catalogue) UpsertFormularyEntry(ctx context.Context, scope authctx.TenantScope,
	e domain.FormularyEntry) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	return c.queries(ctx).UpsertFormularyEntry(ctx, sqlcgen.UpsertFormularyEntryParams{
		TenantID:         tenantID,
		MedicationSystem: e.Medication.System, MedicationCode: e.Medication.Code,
		MedicationDisplay: e.Medication.Display,
		Scope:             string(e.Scope), ScopeID: e.ScopeID,
		Status: string(e.Status), Restriction: e.Restriction,
		ApprovalPath: e.ApprovalPath,
		UpdatedBy:    e.UpdatedBy, UpdatedAt: timestamptz(e.UpdatedAt),
	})
}

// FormularyEntries reads the whole list.
//
// The whole list rather than a per-medication lookup, because the decision is
// "narrowest matching scope wins" and answering it needs every entry that could
// match — including the class-level ones, which a query keyed on the prescribed
// code would miss.
func (c Catalogue) FormularyEntries(ctx context.Context, scope authctx.TenantScope) (
	[]domain.FormularyEntry, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := c.queries(ctx).ListFormularyEntries(ctx, tenantID)
	if err != nil {
		return nil, err
	}

	out := make([]domain.FormularyEntry, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.FormularyEntry{
			TenantID: row.TenantID.String(),
			Medication: domain.Coding{
				System: row.MedicationSystem, Code: row.MedicationCode,
				Display: row.MedicationDisplay,
			},
			Scope: domain.FormularyScopeKind(row.Scope), ScopeID: row.ScopeID,
			Status: domain.FormularyStatus(row.Status), Restriction: row.Restriction,
			ApprovalPath: row.ApprovalPath,
			UpdatedBy:    row.UpdatedBy, UpdatedAt: timeOrZero(row.UpdatedAt),
		})
	}
	return out, nil
}

// UpsertInteractionRule publishes an interaction rule version (SRS-MED-003).
func (c Catalogue) UpsertInteractionRule(ctx context.Context, scope authctx.TenantScope,
	r domain.InteractionRule, active bool, updatedBy string, now time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	return c.queries(ctx).UpsertInteractionRule(ctx, sqlcgen.UpsertInteractionRuleParams{
		TenantID: tenantID, RuleID: r.ID, Version: r.Version,
		LeftSystem: r.Left.System, LeftCode: r.Left.Code, LeftDisplay: r.Left.Display,
		RightSystem: r.Right.System, RightCode: r.Right.Code,
		RightDisplay: r.Right.Display,
		Severity:     string(r.Severity), Advice: r.Advice, Management: r.Management,
		Active: active, UpdatedBy: updatedBy, UpdatedAt: timestamptz(now),
	})
}

// InteractionRules reads the active rules.
func (c Catalogue) InteractionRules(ctx context.Context, scope authctx.TenantScope) (
	[]domain.InteractionRule, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := c.queries(ctx).ListActiveInteractionRules(ctx, tenantID)
	if err != nil {
		return nil, err
	}

	out := make([]domain.InteractionRule, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.InteractionRule{
			ID: row.RuleID, Version: row.Version,
			Left: domain.Coding{
				System: row.LeftSystem, Code: row.LeftCode, Display: row.LeftDisplay,
			},
			Right: domain.Coding{
				System: row.RightSystem, Code: row.RightCode, Display: row.RightDisplay,
			},
			Severity: domain.Severity(row.Severity),
			Advice:   row.Advice, Management: row.Management,
		})
	}
	return out, nil
}

// UpsertDoseRule publishes a dose-support rule version (SRS-MED-004).
func (c Catalogue) UpsertDoseRule(ctx context.Context, scope authctx.TenantScope,
	r domain.DoseRule, active bool, validatedBy, updatedBy string, now time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	maxCrCl, err := numeric(r.MaxCreatinineClearance)
	if err != nil {
		return err
	}
	maxAge, err := numeric(r.MaxAgeYears)
	if err != nil {
		return err
	}

	params := sqlcgen.UpsertDoseRuleParams{
		TenantID: tenantID, RuleID: r.ID, Version: r.Version, Scope: string(r.Scope),
		MedicationSystem: r.Medication.System, MedicationCode: r.Medication.Code,
		MedicationDisplay:      r.Medication.Display,
		MaxCreatinineClearance: maxCrCl, MaxAgeYears: maxAge,
		Advice: r.Advice, Validated: r.Validated,
		Active: active, UpdatedBy: updatedBy, UpdatedAt: timestamptz(now),
	}
	if r.Validated {
		params.ValidatedBy = validatedBy
		params.ValidatedAt = timestamptz(now)
	}
	return c.queries(ctx).UpsertDoseRule(ctx, params)
}

// DoseRules reads the rules that may actually run (SRS-MED-004).
func (c Catalogue) DoseRules(ctx context.Context, scope authctx.TenantScope) (
	[]domain.DoseRule, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	rows, err := c.queries(ctx).ListRunnableDoseRules(ctx, tenantID)
	if err != nil {
		return nil, err
	}

	out := make([]domain.DoseRule, 0, len(rows))
	for _, row := range rows {
		maxCrCl, err := numericOrZero(row.MaxCreatinineClearance)
		if err != nil {
			return nil, err
		}
		maxAge, err := numericOrZero(row.MaxAgeYears)
		if err != nil {
			return nil, err
		}
		out = append(out, domain.DoseRule{
			ID: row.RuleID, Version: row.Version, Scope: domain.DoseRuleScope(row.Scope),
			Medication: domain.Coding{
				System: row.MedicationSystem, Code: row.MedicationCode,
				Display: row.MedicationDisplay,
			},
			MaxCreatinineClearance: maxCrCl, MaxAgeYears: maxAge,
			Advice: row.Advice, Validated: row.Validated,
		})
	}
	return out, nil
}

// SetPolicy records the tenant's medication policy.
func (c Catalogue) SetPolicy(ctx context.Context, scope authctx.TenantScope,
	p ports.Policy, updatedBy string, now time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}

	verificationClasses := make([]string, 0, len(p.Verification.RequiredForClasses))
	for key, required := range p.Verification.RequiredForClasses {
		if required {
			verificationClasses = append(verificationClasses, key)
		}
	}
	structured := make([]string, 0, len(p.StructuredDoseClasses))
	for key, required := range p.StructuredDoseClasses {
		if required {
			structured = append(structured, key)
		}
	}

	return c.queries(ctx).SetMedicationPolicy(ctx, sqlcgen.SetMedicationPolicyParams{
		TenantID:              tenantID,
		MaxOverridable:        string(p.Override.MaxOverridable),
		VerificationRequired:  p.Verification.Required,
		VerificationClasses:   orEmptyString(verificationClasses),
		StructuredDoseClasses: orEmptyString(structured),
		UpdatedBy:             updatedBy, UpdatedAt: timestamptz(now),
	})
}

// Policy returns the tenant's configuration merged over the domain default.
//
// Merged rather than returned raw, so a tenant that has configured nothing gets
// the safe starting point — verification required, severe the override ceiling
// — rather than a zero value in which nothing is checked.
func (c Catalogue) Policy(ctx context.Context, scope authctx.TenantScope) (
	ports.Policy, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return ports.Policy{}, err
	}

	row, err := c.queries(ctx).GetMedicationPolicy(ctx, tenantID)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return ports.DefaultPolicy(), nil
		}
		return ports.Policy{}, err
	}

	policy := ports.DefaultPolicy()
	policy.Override = domain.OverridePolicy{
		MaxOverridable: domain.Severity(row.MaxOverridable),
	}
	policy.Verification = domain.VerificationPolicy{Required: row.VerificationRequired}
	if len(row.VerificationClasses) > 0 {
		policy.Verification.RequiredForClasses = make(map[string]bool, len(row.VerificationClasses))
		for _, key := range row.VerificationClasses {
			policy.Verification.RequiredForClasses[key] = true
		}
	}
	if len(row.StructuredDoseClasses) > 0 {
		policy.StructuredDoseClasses = make(map[string]bool, len(row.StructuredDoseClasses))
		for _, key := range row.StructuredDoseClasses {
			policy.StructuredDoseClasses[key] = true
		}
	}
	return policy, nil
}
