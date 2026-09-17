package postgres

import (
	"context"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"

	"github.com/ppusapati/health/code/internal/icu/domain"
	"github.com/ppusapati/health/code/internal/icu/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// CareRepo implements ports.CareRepository.
type CareRepo struct{ *Repository }

var _ ports.CareRepository = CareRepo{}

// InsertScore writes a score and the inputs it was calculated from.
//
// Both, in one call. SRS-ICU-009 requires the score to be reproducible from
// its inputs, and a total written without them is a claim nobody can check.
func (r CareRepo) InsertScore(ctx context.Context, scope authctx.TenantScope,
	s domain.Score) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	scoreID, err := uuid.Parse(s.ID)
	if err != nil {
		return notFound()
	}
	episodeID, err := uuid.Parse(s.EpisodeID)
	if err != nil {
		return notFound()
	}

	missing := s.Missing
	if missing == nil {
		missing = []string{}
	}

	queries := r.queries(ctx)
	if err := queries.InsertIcuScore(ctx, sqlcgen.InsertIcuScoreParams{
		ScoreID: scoreID, TenantID: tenantID, EpisodeID: episodeID,
		Name: s.Name, FormulaVersion: s.FormulaVersion,
		Total: int32(s.Total), Missing: missing,
		CalculatedAt: stamp(s.CalculatedAt), CalculatedBy: s.CalculatedBy,
	}); err != nil {
		return err
	}

	for _, input := range s.Inputs {
		observationID, err := uuid.Parse(input.ObservationID)
		if err != nil {
			return notFound()
		}
		if err := queries.InsertIcuScoreInput(ctx, sqlcgen.InsertIcuScoreInputParams{
			ScoreID: scoreID, Code: input.Code, ObservationID: observationID,
			Value: input.Value, Unit: input.Unit,
			ObservedAt: stamp(input.ObservedAt), Points: int32(input.Points),
		}); err != nil {
			return err
		}
	}
	return nil
}

// Scores reads an episode's scores with their inputs.
func (r CareRepo) Scores(ctx context.Context, scope authctx.TenantScope,
	episodeID string, limit int32) ([]domain.Score, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(episodeID)
	if err != nil {
		return nil, notFound()
	}

	queries := r.queries(ctx)
	rows, err := queries.ListIcuScores(ctx, sqlcgen.ListIcuScoresParams{
		TenantID: tenantID, EpisodeID: id, Limit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Score, 0, len(rows))
	for _, row := range rows {
		score := domain.Score{
			ID: row.ScoreID.String(), TenantID: row.TenantID.String(),
			EpisodeID: row.EpisodeID.String(),
			Name:      row.Name, FormulaVersion: row.FormulaVersion,
			Total: int(row.Total), Missing: row.Missing,
			CalculatedAt: timeOf(row.CalculatedAt), CalculatedBy: row.CalculatedBy,
		}
		inputs, err := queries.ListIcuScoreInputs(ctx, row.ScoreID)
		if err != nil {
			return nil, err
		}
		for _, input := range inputs {
			score.Inputs = append(score.Inputs, domain.ScoreInput{
				Code: input.Code, ObservationID: input.ObservationID.String(),
				Value: input.Value, Unit: input.Unit,
				ObservedAt: timeOf(input.ObservedAt), Points: int(input.Points),
			})
		}
		out = append(out, score)
	}
	return out, nil
}

// InsertBundle records a bundle run and each element's outcome.
func (r CareRepo) InsertBundle(ctx context.Context, scope authctx.TenantScope,
	p domain.BundlePerformance) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	performanceID, err := uuid.Parse(p.ID)
	if err != nil {
		return notFound()
	}
	episodeID, err := uuid.Parse(p.EpisodeID)
	if err != nil {
		return notFound()
	}

	queries := r.queries(ctx)
	if err := queries.InsertIcuBundlePerformance(ctx,
		sqlcgen.InsertIcuBundlePerformanceParams{
			PerformanceID: performanceID, TenantID: tenantID, EpisodeID: episodeID,
			Kind: string(p.Kind), Label: p.Label, Version: p.Version,
			PerformedAt: stamp(p.PerformedAt), PerformedBy: p.PerformedBy,
		}); err != nil {
		return err
	}

	for _, result := range p.Results {
		if err := queries.InsertIcuBundleResult(ctx, sqlcgen.InsertIcuBundleResultParams{
			PerformanceID: performanceID, Code: result.Code,
			State: string(result.State), Reason: result.Reason,
		}); err != nil {
			return err
		}
	}
	return nil
}

// Bundles reads an episode's bundle runs with their results.
func (r CareRepo) Bundles(ctx context.Context, scope authctx.TenantScope,
	episodeID string, limit int32) ([]domain.BundlePerformance, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(episodeID)
	if err != nil {
		return nil, notFound()
	}

	queries := r.queries(ctx)
	rows, err := queries.ListIcuBundlePerformances(ctx,
		sqlcgen.ListIcuBundlePerformancesParams{
			TenantID: tenantID, EpisodeID: id, Limit: limit,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.BundlePerformance, 0, len(rows))
	for _, row := range rows {
		performance := domain.BundlePerformance{
			ID: row.PerformanceID.String(), TenantID: row.TenantID.String(),
			EpisodeID: row.EpisodeID.String(), Kind: domain.BundleKind(row.Kind),
			Label: row.Label, Version: row.Version,
			PerformedAt: timeOf(row.PerformedAt), PerformedBy: row.PerformedBy,
		}
		results, err := queries.ListIcuBundleResults(ctx, row.PerformanceID)
		if err != nil {
			return nil, err
		}
		for _, result := range results {
			performance.Results = append(performance.Results, domain.BundleResult{
				Code: result.Code, State: domain.ItemState(result.State),
				Reason: result.Reason,
			})
		}
		out = append(out, performance)
	}
	return out, nil
}

// InsertAssessment records one bedside assessment.
func (r CareRepo) InsertAssessment(ctx context.Context, scope authctx.TenantScope,
	a domain.Assessment) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	assessmentID, err := uuid.Parse(a.ID)
	if err != nil {
		return notFound()
	}
	episodeID, err := uuid.Parse(a.EpisodeID)
	if err != nil {
		return notFound()
	}

	findings, err := encodeStrings(a.Findings)
	if err != nil {
		return err
	}
	var score *int32
	if a.Score != nil {
		value := int32(*a.Score)
		score = &value
	}

	return r.queries(ctx).InsertIcuAssessment(ctx, sqlcgen.InsertIcuAssessmentParams{
		AssessmentID: assessmentID, TenantID: tenantID, EpisodeID: episodeID,
		Kind: string(a.Kind), Scale: a.Scale, Score: score,
		Findings: findings, Note: a.Note,
		PerformedAt: stamp(a.PerformedAt), PerformedBy: a.PerformedBy,
		NextDueAt: stamp(a.NextDueAt),
	})
}

// Assessments reads an episode's assessments.
func (r CareRepo) Assessments(ctx context.Context, scope authctx.TenantScope,
	episodeID string, limit int32) ([]domain.Assessment, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(episodeID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListIcuAssessments(ctx, sqlcgen.ListIcuAssessmentsParams{
		TenantID: tenantID, EpisodeID: id, Limit: limit,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Assessment, 0, len(rows))
	for _, row := range rows {
		assessment := domain.Assessment{
			ID: row.AssessmentID.String(), TenantID: row.TenantID.String(),
			EpisodeID: row.EpisodeID.String(),
			Kind:      domain.AssessmentKind(row.Kind), Scale: row.Scale,
			Findings: decodeStrings(row.Findings), Note: row.Note,
			PerformedAt: timeOf(row.PerformedAt), PerformedBy: row.PerformedBy,
			NextDueAt: timeOf(row.NextDueAt),
		}
		if row.Score != nil {
			value := int(*row.Score)
			assessment.Score = &value
		}
		out = append(out, assessment)
	}
	return out, nil
}

// InsertRound records a ward round.
func (r CareRepo) InsertRound(ctx context.Context, scope authctx.TenantScope,
	round domain.Round) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	roundID, err := uuid.Parse(round.ID)
	if err != nil {
		return notFound()
	}
	episodeID, err := uuid.Parse(round.EpisodeID)
	if err != nil {
		return notFound()
	}

	attendance := round.Attendance
	if attendance == nil {
		attendance = []string{}
	}

	return r.queries(ctx).InsertIcuRound(ctx, sqlcgen.InsertIcuRoundParams{
		RoundID: roundID, TenantID: tenantID, EpisodeID: episodeID,
		Attendance: attendance, Summary: round.Summary,
		PerformedAt: stamp(round.PerformedAt), PerformedBy: round.PerformedBy,
	})
}

// Rounds reads an episode's ward rounds.
func (r CareRepo) Rounds(ctx context.Context, scope authctx.TenantScope,
	episodeID string, limit int32) ([]domain.Round, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(episodeID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListIcuRounds(ctx, sqlcgen.ListIcuRoundsParams{
		TenantID: tenantID, EpisodeID: id, Limit: limit,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Round, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Round{
			ID: row.RoundID.String(), TenantID: row.TenantID.String(),
			EpisodeID: row.EpisodeID.String(), Attendance: row.Attendance,
			Summary:     row.Summary,
			PerformedAt: timeOf(row.PerformedAt), PerformedBy: row.PerformedBy,
		})
	}
	return out, nil
}

// InsertGoal sets a daily goal.
func (r CareRepo) InsertGoal(ctx context.Context, scope authctx.TenantScope,
	g domain.Goal) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	goalID, err := uuid.Parse(g.ID)
	if err != nil {
		return notFound()
	}
	episodeID, err := uuid.Parse(g.EpisodeID)
	if err != nil {
		return notFound()
	}
	roundID, err := optionalUUID(g.RoundID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertIcuGoal(ctx, sqlcgen.InsertIcuGoalParams{
		GoalID: goalID, TenantID: tenantID, EpisodeID: episodeID, RoundID: roundID,
		Domain: g.Domain, Text: g.Text,
		OwnerRole: g.OwnerRole, OwnerID: g.OwnerID, Status: string(g.Status),
		TargetAt: stamp(g.TargetAt), CreatedBy: g.CreatedBy,
		CreatedAt: stamp(g.CreatedAt),
	})
}

// ResolveGoal closes a goal. False where somebody closed it first.
func (r CareRepo) ResolveGoal(ctx context.Context, scope authctx.TenantScope,
	g domain.Goal) (bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return false, err
	}
	goalID, err := uuid.Parse(g.ID)
	if err != nil {
		return false, notFound()
	}

	rows, err := r.queries(ctx).ResolveIcuGoal(ctx, sqlcgen.ResolveIcuGoalParams{
		Status: string(g.Status), Outcome: g.Outcome,
		ResolvedBy: g.ResolvedBy, ResolvedAt: stamp(g.ResolvedAt),
		TenantID: tenantID, GoalID: goalID,
	})
	if err != nil {
		return false, err
	}
	return rows > 0, nil
}

// Goals reads an episode's daily goals.
func (r CareRepo) Goals(ctx context.Context, scope authctx.TenantScope,
	episodeID string) ([]domain.Goal, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(episodeID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListIcuGoals(ctx, sqlcgen.ListIcuGoalsParams{
		TenantID: tenantID, EpisodeID: id,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Goal, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Goal{
			ID: row.GoalID.String(), TenantID: row.TenantID.String(),
			EpisodeID: row.EpisodeID.String(), RoundID: uuidOrEmpty(row.RoundID),
			Domain: row.Domain, Text: row.Text,
			OwnerRole: row.OwnerRole, OwnerID: row.OwnerID,
			Status: domain.GoalStatus(row.Status), TargetAt: timeOf(row.TargetAt),
			ResolvedAt: timeOf(row.ResolvedAt), ResolvedBy: row.ResolvedBy,
			Outcome:   row.Outcome,
			CreatedBy: row.CreatedBy, CreatedAt: timeOf(row.CreatedAt),
		})
	}
	return out, nil
}

// InsertGoalsOfCare supersedes the ceiling in force and records the new one.
//
// The two statements are one transaction, and the order is forced by the
// schema: a partial unique index permits exactly one current ceiling per
// episode, so the old one must be superseded before the new one exists, and
// its forward reference to the not-yet-inserted replacement resolves only at
// commit — which is why that foreign key is deferred.
//
// WithinTx joins the caller's transaction where there is one and opens its own
// where there is not, so this cannot be called in a way that leaves an episode
// with two current ceilings or none. A unit that briefly had either is one
// where a resuscitation decision was ambiguous, and the window does not have
// to be long for somebody to arrest in it.
func (r CareRepo) InsertGoalsOfCare(ctx context.Context, scope authctx.TenantScope,
	g domain.GoalsOfCare) error {

	return r.tx.WithinTx(ctx, func(ctx context.Context) error {
		return r.insertGoalsOfCare(ctx, scope, g)
	})
}

func (r CareRepo) insertGoalsOfCare(ctx context.Context, scope authctx.TenantScope,
	g domain.GoalsOfCare) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	goalsID, err := uuid.Parse(g.ID)
	if err != nil {
		return notFound()
	}
	episodeID, err := uuid.Parse(g.EpisodeID)
	if err != nil {
		return notFound()
	}

	limitations := g.Limitations
	if limitations == nil {
		limitations = []string{}
	}

	queries := r.queries(ctx)
	if _, err := queries.SupersedeIcuGoalsOfCare(ctx,
		sqlcgen.SupersedeIcuGoalsOfCareParams{
			SupersededBy: pgtype.UUID{Bytes: goalsID, Valid: true}, SupersededAt: stamp(g.RecordedAt),
			TenantID: tenantID, EpisodeID: episodeID,
		}); err != nil {
		return err
	}

	return queries.InsertIcuGoalsOfCare(ctx, sqlcgen.InsertIcuGoalsOfCareParams{
		GoalsOfCareID: goalsID, TenantID: tenantID, EpisodeID: episodeID,
		Intent: string(g.Intent), Limitations: limitations, CprStatus: g.CPRStatus,
		DiscussedWith: g.DiscussedWith, Rationale: g.Rationale,
		AuthorisedBy: g.AuthorisedBy, AuthorisedRole: g.AuthorisedRole,
		RecordedAt: stamp(g.RecordedAt), RecordedBy: g.RecordedBy,
		ReviewBy: stamp(g.ReviewBy),
	})
}

// GoalsOfCare reads an episode's ceilings, superseded ones included: the
// history is the point.
func (r CareRepo) GoalsOfCare(ctx context.Context, scope authctx.TenantScope,
	episodeID string) ([]domain.GoalsOfCare, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(episodeID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListIcuGoalsOfCare(ctx, sqlcgen.ListIcuGoalsOfCareParams{
		TenantID: tenantID, EpisodeID: id,
	})
	if err != nil {
		return nil, err
	}
	out := make([]domain.GoalsOfCare, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.GoalsOfCare{
			ID: row.GoalsOfCareID.String(), TenantID: row.TenantID.String(),
			EpisodeID: row.EpisodeID.String(), Intent: domain.CareIntent(row.Intent),
			Limitations: row.Limitations, CPRStatus: row.CprStatus,
			DiscussedWith: row.DiscussedWith, Rationale: row.Rationale,
			AuthorisedBy: row.AuthorisedBy, AuthorisedRole: row.AuthorisedRole,
			RecordedAt: timeOf(row.RecordedAt), RecordedBy: row.RecordedBy,
			SupersededBy: uuidOrEmpty(row.SupersededBy),
			SupersededAt: timeOf(row.SupersededAt),
			ReviewBy:     timeOf(row.ReviewBy),
		})
	}
	return out, nil
}
