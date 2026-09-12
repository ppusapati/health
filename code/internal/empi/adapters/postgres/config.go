package postgres

import (
	"context"
	"encoding/json"
	"errors"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/ppusapati/health/code/internal/empi/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Registration and matching configuration (SRS-EMPI-001, SRS-EMPI-004).
//
// Both readers fall back to the domain defaults when a tenant has configured
// nothing. Failing instead would make a freshly provisioned tenant unable to
// register anybody, and defaulting to "require nothing" would ship an index
// that cannot match. The defaults live in the domain, so the fallback is one
// decision rather than a value repeated here.

// DemographicPolicy resolves the minimum set in force.
func (r ConfigRepo) DemographicPolicy(ctx context.Context, scope authctx.TenantScope,
	jurisdiction, facilityID string) (domain.DemographicPolicy, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.DemographicPolicy{}, err
	}

	params := sqlcgen.GetDemographicPolicyParams{TenantID: tenantID, Jurisdiction: jurisdiction}
	if parsed, parseErr := uuid.Parse(facilityID); parseErr == nil {
		params.FacilityID = pgtype.UUID{Bytes: parsed, Valid: true}
	}

	row, err := r.queries(ctx).GetDemographicPolicy(ctx, params)
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.DefaultPolicy(jurisdiction), nil
	}
	if err != nil {
		return domain.DemographicPolicy{}, err
	}

	policy := domain.DemographicPolicy{
		Jurisdiction:      row.Jurisdiction,
		AllowUnidentified: row.AllowUnidentified,
	}
	if row.FacilityID.Valid {
		policy.FacilityID = uuid.UUID(row.FacilityID.Bytes).String()
	}
	for _, f := range row.RequiredFields {
		policy.Required = append(policy.Required, domain.Field(f))
	}

	// A stored policy naming a field the domain does not know is a row written
	// around the application — an operator editing SQL, or a migration from a
	// later version. Refusing is the safe direction: the alternative is
	// treating the unknown requirement as satisfied and silently registering
	// patients without something the jurisdiction demands.
	if err := policy.Validate(); err != nil {
		return domain.DemographicPolicy{}, rpcerr.Internal(
			"EMPI_POLICY_INVALID", "the configured demographic policy cannot be applied").WithCause(err)
	}
	return policy, nil
}

// MatchConfig returns the tenant's duplicate-detection weights and thresholds.
func (r ConfigRepo) MatchConfig(ctx context.Context, scope authctx.TenantScope) (
	domain.MatchWeights, domain.MatchThresholds, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.MatchWeights{}, domain.MatchThresholds{}, err
	}

	row, err := r.queries(ctx).GetMatchConfig(ctx, tenantID)
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.DefaultWeights(), domain.DefaultThresholds(), nil
	}
	if err != nil {
		return domain.MatchWeights{}, domain.MatchThresholds{}, err
	}

	var weights domain.MatchWeights
	if err := json.Unmarshal(row.Weights, &weights); err != nil {
		return domain.MatchWeights{}, domain.MatchThresholds{}, rpcerr.Internal(
			"EMPI_MATCH_CONFIG_INVALID", "the configured match weights cannot be read").WithCause(err)
	}

	review, err := numericToFloat(row.ReviewThreshold)
	if err != nil {
		return domain.MatchWeights{}, domain.MatchThresholds{}, err
	}
	probable, err := numericToFloat(row.ProbableThreshold)
	if err != nil {
		return domain.MatchWeights{}, domain.MatchThresholds{}, err
	}

	thresholds := domain.MatchThresholds{Review: review, Probable: probable}
	// The table has a CHECK for the ordering, so this catches only a row
	// written before that constraint existed — but a misrouted duplicate is
	// exactly the failure nobody notices, so it is worth the check.
	if err := thresholds.Validate(); err != nil {
		return domain.MatchWeights{}, domain.MatchThresholds{}, rpcerr.Internal(
			"EMPI_MATCH_CONFIG_INVALID", "the configured match thresholds cannot be applied").WithCause(err)
	}
	return weights, thresholds, nil
}

func numericToFloat(n pgtype.Numeric) (float64, error) {
	if !n.Valid {
		return 0, rpcerr.Internal("EMPI_MATCH_CONFIG_INVALID", "a match threshold is null")
	}
	value, err := n.Float64Value()
	if err != nil {
		return 0, rpcerr.Internal("EMPI_MATCH_CONFIG_INVALID", "a match threshold is not a number").WithCause(err)
	}
	return value.Float64, nil
}
