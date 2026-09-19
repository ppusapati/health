package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"

	"github.com/ppusapati/health/code/internal/infection/domain"
	"github.com/ppusapati/health/code/internal/infection/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// InsertStewardshipRule stores a new revision of a review trigger
// (SRS-IPC-008).
func (r *Repository) InsertStewardshipRule(ctx context.Context,
	scope authctx.TenantScope, rule domain.StewardshipRule) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	ruleID, err := uuid.Parse(rule.ID)
	if err != nil {
		return rpcerr.Invalid("IPC_RULE_ID_INVALID", "rule id must be a UUID")
	}

	return r.queries(ctx).InsertInfectionStewardshipRule(ctx,
		sqlcgen.InsertInfectionStewardshipRuleParams{
			RuleID: ruleID, TenantID: tenantID, Code: rule.Code,
			Name: rule.Name, Revision: int32(rule.Revision),
			Kind: string(rule.Kind), Agents: texts(rule.Agents),
			AllAgents:    rule.AllAgents,
			DayThreshold: int32(rule.DayThreshold), Prompt: rule.Prompt,
			EffectiveFrom: stamp(rule.EffectiveFrom),
			CreatedAt:     stamp(rule.CreatedAt), CreatedBy: rule.CreatedBy,
		})
}

// StewardshipRule reads one trigger revision.
func (r *Repository) StewardshipRule(ctx context.Context,
	scope authctx.TenantScope, id string) (domain.StewardshipRule, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.StewardshipRule{}, err
	}
	ruleID, err := uuid.Parse(id)
	if err != nil {
		return domain.StewardshipRule{}, notFound()
	}

	row, err := r.queries(ctx).GetInfectionStewardshipRule(ctx,
		sqlcgen.GetInfectionStewardshipRuleParams{
			TenantID: tenantID, RuleID: ruleID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.StewardshipRule{}, notFound()
	}
	if err != nil {
		return domain.StewardshipRule{}, err
	}
	return stewardshipRuleFrom(row), nil
}

// ApproveStewardshipRule signs a trigger off.
func (r *Repository) ApproveStewardshipRule(ctx context.Context,
	scope authctx.TenantScope, rule domain.StewardshipRule) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	ruleID, err := uuid.Parse(rule.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).ApproveInfectionStewardshipRule(ctx,
		sqlcgen.ApproveInfectionStewardshipRuleParams{
			ApprovedBy: rule.ApprovedBy, ApprovedAt: stamp(rule.ApprovedAt),
			EffectiveFrom: stamp(rule.EffectiveFrom),
			TenantID:      tenantID, RuleID: ruleID,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return rpcerr.FailedPrecondition("IPC_RULE_ALREADY_APPROVED",
			"this rule is already approved")
	}
	return nil
}

// SupersedeEarlierStewardshipRules closes off every earlier revision.
func (r *Repository) SupersedeEarlierStewardshipRules(ctx context.Context,
	scope authctx.TenantScope, code string, revision int, at time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	_, err = r.queries(ctx).SupersedeInfectionStewardshipRule(ctx,
		sqlcgen.SupersedeInfectionStewardshipRuleParams{
			SupersededAt: stamp(at), TenantID: tenantID, Code: code,
			Revision: int32(revision),
		})
	return err
}

// StewardshipRules lists trigger revisions.
func (r *Repository) StewardshipRules(ctx context.Context,
	scope authctx.TenantScope, code string, liveAt time.Time) (
	[]domain.StewardshipRule, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	at := liveAt
	if at.IsZero() {
		at = epoch
	}

	rows, err := r.queries(ctx).ListInfectionStewardshipRules(ctx,
		sqlcgen.ListInfectionStewardshipRulesParams{
			TenantID: tenantID, Code: code,
			LiveOnly: !liveAt.IsZero(), At: stamp(at),
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.StewardshipRule, 0, len(rows))
	for _, row := range rows {
		out = append(out, stewardshipRuleFrom(row))
	}
	return out, nil
}

func stewardshipRuleFrom(
	row sqlcgen.InfectionStewardshipRule) domain.StewardshipRule {

	return domain.StewardshipRule{
		ID: row.RuleID.String(), TenantID: row.TenantID.String(),
		Code: row.Code, Name: row.Name, Revision: int(row.Revision),
		Kind: domain.TriggerKind(row.Kind), Agents: row.Agents,
		AllAgents: row.AllAgents, DayThreshold: int(row.DayThreshold),
		Prompt: row.Prompt, Approved: row.Approved,
		ApprovedBy: row.ApprovedBy, ApprovedAt: timeOf(row.ApprovedAt),
		EffectiveFrom: timeOf(row.EffectiveFrom),
		SupersededAt:  timeOf(row.SupersededAt),
		CreatedAt:     timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
	}
}

// InsertReview puts a trigger on the worklist (SRS-IPC-008).
//
// The partial unique index on (tenant, encounter, rule code, revision, agent)
// for open and advised reviews is what stops an hourly re-evaluation raising
// the same review every hour, so a duplicate comes back as a constraint
// violation rather than as a worklist nobody can read.
func (r *Repository) InsertReview(ctx context.Context,
	scope authctx.TenantScope, review domain.StewardshipReview) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	reviewID, err := uuid.Parse(review.ID)
	if err != nil {
		return rpcerr.Invalid("IPC_REVIEW_ID_INVALID",
			"review id must be a UUID")
	}

	return r.queries(ctx).InsertInfectionStewardshipReview(ctx,
		sqlcgen.InsertInfectionStewardshipReviewParams{
			ReviewID: reviewID, TenantID: tenantID,
			PatientID: review.PatientID, EncounterID: review.EncounterID,
			LocationID:   review.LocationID,
			RuleID:       optionalUUID(review.RuleID),
			RuleCode:     review.RuleCode,
			RuleRevision: int32(review.RuleRevision),
			Kind:         string(review.Kind), Agent: review.Agent,
			OrderID: review.OrderID, Why: review.Why,
			State: string(review.State), RaisedAt: stamp(review.RaisedAt),
			DueBy: stamp(review.DueBy),
		})
}

// Review reads one worklist entry.
func (r *Repository) Review(ctx context.Context, scope authctx.TenantScope,
	id string) (domain.StewardshipReview, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.StewardshipReview{}, err
	}
	reviewID, err := uuid.Parse(id)
	if err != nil {
		return domain.StewardshipReview{}, notFound()
	}

	row, err := r.queries(ctx).GetInfectionStewardshipReview(ctx,
		sqlcgen.GetInfectionStewardshipReviewParams{
			TenantID: tenantID, ReviewID: reviewID,
		})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.StewardshipReview{}, notFound()
	}
	if err != nil {
		return domain.StewardshipReview{}, err
	}
	return reviewFrom(row), nil
}

// UpdateReview records advice, a prescriber's response or a withdrawal.
//
// Nothing here writes to a medication order; there is no column on the table
// and no parameter on this call that could (SRS-IPC-008).
func (r *Repository) UpdateReview(ctx context.Context,
	scope authctx.TenantScope, review domain.StewardshipReview,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	reviewID, err := uuid.Parse(review.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateInfectionStewardshipReview(ctx,
		sqlcgen.UpdateInfectionStewardshipReviewParams{
			State:           string(review.State),
			Recommendation:  string(review.Recommendation),
			Advice:          review.Advice,
			ReviewedBy:      review.ReviewedBy,
			ReviewedAt:      stamp(review.ReviewedAt),
			Response:        string(review.Response),
			ResponseReason:  review.ResponseReason,
			RespondedBy:     review.RespondedBy,
			RespondedAt:     stamp(review.RespondedAt),
			WithdrawnReason: review.WithdrawnReason,
			TenantID:        tenantID, ReviewID: reviewID,
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// Reviews lists the worklist.
func (r *Repository) Reviews(ctx context.Context, scope authctx.TenantScope,
	f ports.ReviewFilter) ([]domain.StewardshipReview, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	from, to := window(f.From, f.To)
	limit, offset := page(f.Limit, f.Offset)

	rows, err := r.queries(ctx).ListInfectionStewardshipReviews(ctx,
		sqlcgen.ListInfectionStewardshipReviewsParams{
			TenantID: tenantID, EncounterID: f.EncounterID,
			PatientID: f.PatientID, State: f.State,
			WorklistOnly: f.WorklistOnly,
			RaisedFrom:   stamp(from), RaisedTo: stamp(to),
			PageSize: limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.StewardshipReview, 0, len(rows))
	for _, row := range rows {
		out = append(out, reviewFrom(row))
	}
	return out, nil
}

func reviewFrom(
	row sqlcgen.InfectionStewardshipReview) domain.StewardshipReview {

	return domain.StewardshipReview{
		ID: row.ReviewID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID, EncounterID: row.EncounterID,
		LocationID: row.LocationID, RuleID: uuidString(row.RuleID),
		RuleCode: row.RuleCode, RuleRevision: int(row.RuleRevision),
		Kind: domain.TriggerKind(row.Kind), Agent: row.Agent,
		OrderID: row.OrderID, Why: row.Why,
		State:    domain.ReviewState(row.State),
		RaisedAt: timeOf(row.RaisedAt), DueBy: timeOf(row.DueBy),
		Recommendation: domain.Recommendation(row.Recommendation),
		Advice:         row.Advice, ReviewedBy: row.ReviewedBy,
		ReviewedAt:      timeOf(row.ReviewedAt),
		Response:        domain.Response(row.Response),
		ResponseReason:  row.ResponseReason,
		RespondedBy:     row.RespondedBy,
		RespondedAt:     timeOf(row.RespondedAt),
		WithdrawnReason: row.WithdrawnReason, Version: row.Version,
	}
}
