package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/icu/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Scores (SRS-ICU-009), bundles (SRS-ICU-010), assessments (SRS-ICU-014),
// rounds and goals (SRS-ICU-008) and the ceiling of treatment (SRS-ICU-015).

// CalculateScore computes a severity score from validated inputs
// (SRS-ICU-009).
//
// The chart is read here and the arithmetic is the domain's. Only chartable
// values are visible to it, so an unconfirmed device reading cannot contribute
// — and a component with no validated input makes the score incomplete rather
// than lower.
func (s *Service) CalculateScore(ctx context.Context, episodeID, formulaName string) (
	domain.Score, error) {

	session, scope, err := s.authorize(ctx, PermIcuWrite)
	if err != nil {
		return domain.Score{}, err
	}

	formula, ok := s.config.Formulas[formulaName]
	if !ok {
		// A formula this deployment has not agreed the definition of is one
		// nobody should be acting on the result of.
		return domain.Score{}, rpcerr.Invalid("ICU_NO_SUCH_FORMULA",
			"this deployment does not calculate "+formulaName)
	}

	now := s.clock.Now()
	var out domain.Score

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		episode, err := s.episodes.GetEpisode(ctx, scope, episodeID)
		if err != nil {
			return err
		}

		chart, err := s.flowsheet.Observations(ctx, scope, episode.ID,
			time.Time{}, MaxPageSize)
		if err != nil {
			return err
		}

		score, err := formula.Calculate(s.ids.NewID(), scope.TenantID(), episode.ID,
			chart, session.SubjectID, now)
		if err != nil {
			return icuError(err)
		}
		if err := s.care.InsertScore(ctx, scope, score); err != nil {
			return err
		}

		out = score
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermIcuWrite,
			ResourceType: "icu_score", ResourceID: score.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  score.Name + " " + score.FormulaVersion + " calculated",
		}, now)
	})
	if err != nil {
		return domain.Score{}, err
	}
	return out, nil
}

// Scores reads an episode's severity scores with the inputs they were
// calculated from.
func (s *Service) Scores(ctx context.Context, episodeID string, pageSize int32) (
	[]domain.Score, error) {

	_, scope, err := s.authorize(ctx, PermIcuRead)
	if err != nil {
		return nil, err
	}
	return s.care.Scores(ctx, scope, episodeID, clampPageSize(pageSize))
}

// ReproduceScore recomputes a stored score from its stored inputs
// (SRS-ICU-009).
//
// The requirement made callable. A score whose inputs no longer add up to its
// total is one somebody edited, and the disagreement is worth more than either
// number — so this returns both rather than correcting one from the other.
func (s *Service) ReproduceScore(ctx context.Context, episodeID, scoreID string) (
	stored, reproduced int, err error) {

	_, scope, err := s.authorize(ctx, PermIcuRead)
	if err != nil {
		return 0, 0, err
	}

	scores, err := s.care.Scores(ctx, scope, episodeID, MaxPageSize)
	if err != nil {
		return 0, 0, err
	}
	for _, score := range scores {
		if score.ID != scoreID {
			continue
		}
		formula, ok := s.config.Formulas[score.Name]
		if !ok || formula.Version != score.FormulaVersion {
			// The formula has been revised since. Not an error to paper over:
			// the score is still reproducible, but only under the definition
			// it was calculated with, and this deployment no longer holds it.
			return score.Total, 0, rpcerr.FailedPrecondition("ICU_FORMULA_GONE",
				"this score was calculated under "+score.Name+" "+
					score.FormulaVersion+", which this deployment no longer holds")
		}
		total, err := formula.Reproduce(score)
		if err != nil {
			return score.Total, 0, icuError(err)
		}
		return score.Total, total, nil
	}
	return 0, 0, rpcerr.NotFound("ICU_NO_SUCH_SCORE", "no such score")
}

// PerformBundleInput records a bundle run.
type PerformBundleInput struct {
	EpisodeID string
	Kind      domain.BundleKind
	Results   []domain.BundleResult
}

// PerformBundle records a care bundle (SRS-ICU-010).
func (s *Service) PerformBundle(ctx context.Context, in PerformBundleInput) (
	domain.BundlePerformance, domain.Compliance, error) {

	session, scope, err := s.authorize(ctx, PermIcuWrite)
	if err != nil {
		return domain.BundlePerformance{}, domain.Compliance{}, err
	}

	def, ok := s.config.Bundles[in.Kind]
	if !ok {
		return domain.BundlePerformance{}, domain.Compliance{},
			rpcerr.Invalid("ICU_NO_SUCH_BUNDLE",
				"this deployment does not run the "+string(in.Kind)+" bundle")
	}

	now := s.clock.Now()
	var (
		out        domain.BundlePerformance
		compliance domain.Compliance
	)

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		episode, err := s.openEpisode(ctx, scope, in.EpisodeID)
		if err != nil {
			return err
		}

		run, err := domain.PerformBundle(s.ids.NewID(), scope.TenantID(), episode.ID,
			def, in.Results, session.SubjectID, now)
		if err != nil {
			return icuError(err)
		}
		if err := s.care.InsertBundle(ctx, scope, run); err != nil {
			return err
		}

		out, compliance = run, run.Score(def)
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermIcuWrite,
			ResourceType: "icu_bundle", ResourceID: run.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  string(run.Kind) + " bundle performed",
		}, now)
	})
	if err != nil {
		return domain.BundlePerformance{}, domain.Compliance{}, err
	}
	return out, compliance, nil
}

// BundleRun is one bundle performance with its compliance.
type BundleRun struct {
	Performance domain.BundlePerformance
	Compliance  domain.Compliance
}

// Bundles reads an episode's bundle runs, scored.
//
// Scored here against the definition currently configured. Where a bundle has
// been revised since, the run's stored version says so and the compliance is
// reported against the current definition — which is the honest answer to
// "are we compliant now", and is why the version travels with the run.
func (s *Service) Bundles(ctx context.Context, episodeID string, pageSize int32) (
	[]BundleRun, error) {

	_, scope, err := s.authorize(ctx, PermIcuRead)
	if err != nil {
		return nil, err
	}
	runs, err := s.care.Bundles(ctx, scope, episodeID, clampPageSize(pageSize))
	if err != nil {
		return nil, err
	}

	out := make([]BundleRun, 0, len(runs))
	for _, run := range runs {
		entry := BundleRun{Performance: run}
		if def, ok := s.config.Bundles[run.Kind]; ok {
			entry.Compliance = run.Score(def)
		}
		out = append(out, entry)
	}
	return out, nil
}

// AssessInput records one bedside assessment.
type AssessInput struct {
	EpisodeID   string
	Kind        domain.AssessmentKind
	Scale       string
	Score       *int
	Findings    map[string]string
	Note        string
	PerformedAt time.Time
	Every       time.Duration
}

// Assess records a bedside assessment and generates its reassessment time
// (SRS-ICU-014).
func (s *Service) Assess(ctx context.Context, in AssessInput) (domain.Assessment, error) {
	session, scope, err := s.authorize(ctx, PermIcuWrite)
	if err != nil {
		return domain.Assessment{}, err
	}

	now := s.clock.Now()
	var out domain.Assessment

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		episode, err := s.openEpisode(ctx, scope, in.EpisodeID)
		if err != nil {
			return err
		}

		assessment, err := domain.RecordAssessment(s.ids.NewID(), scope.TenantID(),
			domain.NewAssessmentInput{
				EpisodeID: episode.ID, Kind: in.Kind, Scale: in.Scale,
				Score: in.Score, Findings: in.Findings, Note: in.Note,
				PerformedAt: in.PerformedAt, Every: in.Every,
			}, session.SubjectID, now)
		if err != nil {
			return icuError(err)
		}
		if err := s.care.InsertAssessment(ctx, scope, assessment); err != nil {
			return err
		}

		out = assessment
		// A restraint assessment is audited. The others are ordinary nursing
		// observation and would flood the trail; a restrained patient is the
		// one a unit is answerable for, and who looked at them and when is the
		// record that answers it.
		if assessment.Kind != domain.AssessmentRestraint {
			return nil
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermIcuWrite,
			ResourceType: "icu_assessment", ResourceID: assessment.ID,
			Outcome: audit.OutcomeSuccess, Reason: "restraint assessment",
		}, now)
	})
	if err != nil {
		return domain.Assessment{}, err
	}
	return out, nil
}

// DueAssessments is what a bed is behind on (SRS-ICU-014).
func (s *Service) DueAssessments(ctx context.Context, episodeID string) (
	[]domain.Assessment, error) {

	_, scope, err := s.authorize(ctx, PermIcuRead)
	if err != nil {
		return nil, err
	}
	assessments, err := s.care.Assessments(ctx, scope, episodeID, MaxPageSize)
	if err != nil {
		return nil, err
	}
	return domain.DueAssessments(assessments, s.clock.Now()), nil
}

// RoundInput records a ward round and the goals it set.
type RoundInput struct {
	EpisodeID  string
	Attendance []string
	Summary    string
	Goals      []GoalInput
}

// GoalInput is one daily goal.
type GoalInput struct {
	Domain    string
	Text      string
	OwnerRole string
	OwnerID   string
	TargetAt  time.Time
}

// Round records a multidisciplinary round and its goals (SRS-ICU-008).
//
// One call, because the goals are the round: a round recorded without them is
// a note saying a meeting happened, and goals recorded without a round are
// tasks nobody agreed.
func (s *Service) Round(ctx context.Context, in RoundInput) (domain.Round,
	[]domain.Goal, error) {

	session, scope, err := s.authorize(ctx, PermIcuWrite)
	if err != nil {
		return domain.Round{}, nil, err
	}

	now := s.clock.Now()
	var (
		out   domain.Round
		goals []domain.Goal
	)

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		episode, err := s.openEpisode(ctx, scope, in.EpisodeID)
		if err != nil {
			return err
		}

		round, err := domain.NewRound(s.ids.NewID(), scope.TenantID(), episode.ID,
			in.Attendance, in.Summary, session.SubjectID, now)
		if err != nil {
			return icuError(err)
		}
		if err := s.care.InsertRound(ctx, scope, round); err != nil {
			return err
		}

		for _, goalInput := range in.Goals {
			goal, err := domain.NewGoal(s.ids.NewID(), scope.TenantID(),
				domain.NewGoalInput{
					EpisodeID: episode.ID, RoundID: round.ID,
					Domain: goalInput.Domain, Text: goalInput.Text,
					OwnerRole: goalInput.OwnerRole, OwnerID: goalInput.OwnerID,
					TargetAt: goalInput.TargetAt,
				}, session.SubjectID, now)
			if err != nil {
				return icuError(err)
			}
			if err := s.care.InsertGoal(ctx, scope, goal); err != nil {
				return err
			}
			goals = append(goals, goal)
		}

		out = round
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermIcuWrite,
			ResourceType: "icu_round", ResourceID: round.ID,
			Outcome: audit.OutcomeSuccess, Reason: "multidisciplinary round",
		}, now)
	})
	if err != nil {
		return domain.Round{}, nil, err
	}
	return out, goals, nil
}

// ResolveGoalInput closes a daily goal.
type ResolveGoalInput struct {
	EpisodeID string
	GoalID    string
	Status    domain.GoalStatus
	Outcome   string
}

// ResolveGoal closes a daily goal (SRS-ICU-008).
func (s *Service) ResolveGoal(ctx context.Context, in ResolveGoalInput) error {
	session, scope, err := s.authorize(ctx, PermIcuWrite)
	if err != nil {
		return err
	}

	now := s.clock.Now()
	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		goals, err := s.care.Goals(ctx, scope, in.EpisodeID)
		if err != nil {
			return err
		}
		for _, goal := range goals {
			if goal.ID != in.GoalID {
				continue
			}
			if err := goal.Resolve(in.Status, in.Outcome, session.SubjectID, now); err != nil {
				return icuError(err)
			}
			resolved, err := s.care.ResolveGoal(ctx, scope, goal)
			if err != nil {
				return err
			}
			if !resolved {
				return rpcerr.FailedPrecondition("ICU_GOAL_ALREADY_CLOSED",
					"somebody closed this goal first")
			}
			return nil
		}
		return rpcerr.NotFound("ICU_NO_SUCH_GOAL", "no such goal on this episode")
	})
}

// OpenGoals is what the last round left outstanding (SRS-ICU-008).
func (s *Service) OpenGoals(ctx context.Context, episodeID string) ([]domain.Goal, error) {
	_, scope, err := s.authorize(ctx, PermIcuRead)
	if err != nil {
		return nil, err
	}
	goals, err := s.care.Goals(ctx, scope, episodeID)
	if err != nil {
		return nil, err
	}
	return domain.OpenGoals(goals), nil
}

// CeilingInput documents a ceiling of treatment.
type CeilingInput struct {
	EpisodeID      string
	Intent         domain.CareIntent
	Limitations    []string
	CPRStatus      string
	DiscussedWith  string
	Rationale      string
	AuthorisedBy   string
	AuthorisedRole string
	ReviewBy       time.Time
}

// SetCeiling documents a ceiling of treatment (SRS-ICU-015).
//
// Its own permission, which is the requirement's "restricted authorization".
// The name in AuthorisedBy is the senior clinician who owns the decision; the
// session's subject is whoever typed it, and both are recorded because a
// registrar writing up a consultant's decision is the ordinary case and a
// record that conflated them could not answer who decided.
func (s *Service) SetCeiling(ctx context.Context, in CeilingInput) (
	domain.GoalsOfCare, error) {

	session, scope, err := s.authorize(ctx, PermSetCeiling)
	if err != nil {
		return domain.GoalsOfCare{}, err
	}

	now := s.clock.Now()
	var out domain.GoalsOfCare

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		episode, err := s.openEpisode(ctx, scope, in.EpisodeID)
		if err != nil {
			return err
		}

		ceiling, err := domain.RecordGoalsOfCare(s.ids.NewID(), scope.TenantID(),
			domain.NewGoalsOfCareInput{
				EpisodeID: episode.ID, Intent: in.Intent,
				Limitations: in.Limitations, CPRStatus: in.CPRStatus,
				DiscussedWith: in.DiscussedWith, Rationale: in.Rationale,
				AuthorisedBy:   trimmed(in.AuthorisedBy, session.SubjectID),
				AuthorisedRole: in.AuthorisedRole,
				ReviewBy:       in.ReviewBy,
			}, session.SubjectID, now)
		if err != nil {
			return icuError(err)
		}
		if err := s.care.InsertGoalsOfCare(ctx, scope, ceiling); err != nil {
			return err
		}

		// The event says a ceiling changed and what the intent is, so a
		// resuscitation team paged to this bed knows to read it. Not the
		// limitations, not the rationale and not who it was discussed with:
		// those are the conversation, and they belong to the chart.
		if err := s.appendEvent(ctx, session, EventCeilingRecorded,
			"icu_goals_of_care", ceiling.ID, map[string]any{
				"goals_of_care_id": ceiling.ID,
				"episode_id":       episode.ID,
				"patient_id":       episode.PatientID,
				"facility_id":      episode.FacilityID,
				"intent":           string(ceiling.Intent),
				"recorded_at":      ceiling.RecordedAt.Format(time.RFC3339),
			}, now); err != nil {
			return err
		}

		out = ceiling
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermSetCeiling,
			ResourceType: "icu_goals_of_care", ResourceID: ceiling.ID,
			Outcome: audit.OutcomeSuccess,
			Reason: "ceiling of treatment " + string(ceiling.Intent) +
				", authorised by " + ceiling.AuthorisedBy,
		}, now)
	})
	if err != nil {
		return domain.GoalsOfCare{}, err
	}
	return out, nil
}

// Ceiling reads the ceiling in force and its history (SRS-ICU-015).
//
// Every read is audited. "Status is prominently visible to authorized care
// team and audited" is the requirement, and the audit half is about the reads:
// who looked at a patient's resuscitation status is exactly the question asked
// afterwards.
func (s *Service) Ceiling(ctx context.Context, episodeID string) (
	current domain.GoalsOfCare, history []domain.GoalsOfCare, err error) {

	session, scope, err := s.authorize(ctx, PermReadCeiling)
	if err != nil {
		return domain.GoalsOfCare{}, nil, err
	}

	all, err := s.care.GoalsOfCare(ctx, scope, episodeID)
	if err != nil {
		return domain.GoalsOfCare{}, nil, err
	}
	current, _ = domain.CurrentGoalsOfCare(all)

	now := s.clock.Now()
	if err := s.appendAudit(ctx, session, audit.Record{
		TenantID: session.TenantID, Action: PermReadCeiling,
		ResourceType: "icu_episode", ResourceID: episodeID,
		Outcome: audit.OutcomeSuccess, Reason: "ceiling of treatment read",
	}, now); err != nil {
		return domain.GoalsOfCare{}, nil, err
	}
	return current, all, nil
}
