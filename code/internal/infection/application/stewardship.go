package application

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/infection/domain"
	"github.com/ppusapati/health/code/internal/infection/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// NewStewardshipRuleInput configures a review trigger (SRS-IPC-008).
type NewStewardshipRuleInput struct {
	Code         string
	Name         string
	Revision     int
	Kind         domain.TriggerKind
	Agents       []string
	AllAgents    bool
	DayThreshold int
	Prompt       string
}

// DraftStewardshipRule authors a review trigger (SRS-IPC-008).
func (s *Service) DraftStewardshipRule(ctx context.Context,
	in NewStewardshipRuleInput) (domain.StewardshipRule, error) {

	session, scope, err := s.authorize(ctx, PermRuleWrite)
	if err != nil {
		return domain.StewardshipRule{}, err
	}
	now := s.clock.Now()

	rule, err := domain.NewStewardshipRule(s.ids.NewID(), session.TenantID,
		domain.NewStewardshipRuleInput{
			Code: in.Code, Name: in.Name, Revision: in.Revision,
			Kind: in.Kind, Agents: in.Agents, AllAgents: in.AllAgents,
			DayThreshold: in.DayThreshold, Prompt: in.Prompt,
		}, session.SubjectID, now)
	if err != nil {
		return domain.StewardshipRule{}, infectionError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.stewardship.InsertStewardshipRule(ctx, scope,
			rule); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.stewardship_rule.drafted",
			ResourceType: "ipc_stewardship_rule", ResourceID: rule.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"code": rule.Code, "revision": itoa(rule.Revision),
				"kind": string(rule.Kind),
			}),
			Reason: "authored a stewardship trigger revision",
		}, now)
	})
	if err != nil {
		return domain.StewardshipRule{}, infectionError(err)
	}
	return rule, nil
}

// ApproveStewardshipRule puts a trigger in force (SRS-IPC-008).
func (s *Service) ApproveStewardshipRule(ctx context.Context, ruleID string,
	effectiveFrom time.Time) (domain.StewardshipRule, error) {

	session, scope, err := s.authorize(ctx, PermRuleApprove)
	if err != nil {
		return domain.StewardshipRule{}, err
	}
	now := s.clock.Now()

	var approved domain.StewardshipRule
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		rule, err := s.stewardship.StewardshipRule(ctx, scope, ruleID)
		if err != nil {
			return err
		}
		if err := rule.Approve(session.SubjectID, effectiveFrom,
			now); err != nil {
			return err
		}
		if err := s.stewardship.ApproveStewardshipRule(ctx, scope,
			rule); err != nil {
			return err
		}
		if err := s.stewardship.SupersedeEarlierStewardshipRules(ctx, scope,
			rule.Code, rule.Revision, effectiveFrom); err != nil {
			return err
		}
		approved = rule
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.stewardship_rule.approved",
			ResourceType: "ipc_stewardship_rule", ResourceID: rule.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"code": rule.Code, "revision": itoa(rule.Revision),
			}),
			Reason: "put a stewardship trigger in force",
		}, now)
	})
	if err != nil {
		return domain.StewardshipRule{}, infectionError(err)
	}
	return approved, nil
}

// ReviewEncounter evaluates the live triggers against what a patient is
// actually on, and puts what fires on the worklist (SRS-IPC-008).
//
// Nothing here changes a prescription. The triggers read therapy through a
// port that has no write on it, and what comes out is a question for somebody
// with prescribing authority to answer.
func (s *Service) ReviewEncounter(ctx context.Context, encounterID string) (
	[]domain.StewardshipReview, error) {

	session, scope, err := s.authorize(ctx, PermStewardshipReview)
	if err != nil {
		return nil, err
	}
	if s.therapy == nil {
		// Named rather than an empty worklist: a stewardship programme with
		// no input is not a stewardship programme with nothing to do.
		return nil, rpcerr.FailedPrecondition("IPC_NO_THERAPY_SOURCE",
			"no therapy source is configured, so no review can be raised")
	}
	now := s.clock.Now()

	signal, err := s.therapy.Current(ctx, scope, encounterID)
	if err != nil {
		return nil, err
	}
	signal.EncounterID = encounterID

	rules, err := s.stewardship.StewardshipRules(ctx, scope, "", now)
	if err != nil {
		return nil, err
	}
	triggers := domain.TriggeredRules(rules, signal, now)

	var raised []domain.StewardshipReview
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		open, err := s.stewardship.Reviews(ctx, scope, ports.ReviewFilter{
			EncounterID: encounterID, WorklistOnly: true,
			Limit: reportPageSize,
		})
		if err != nil {
			return err
		}

		for _, trigger := range triggers {
			// Re-evaluating a patient every hour must not raise the same
			// review every hour. Checked here and held by a partial unique
			// index underneath, because two callers can do this at once.
			if domain.AlreadyOpen(open, trigger, encounterID) {
				continue
			}
			var dueBy time.Time
			if s.config.StewardshipDueWithin > 0 {
				dueBy = now.Add(s.config.StewardshipDueWithin)
			}
			review, err := domain.RaiseReview(s.ids.NewID(),
				session.TenantID, trigger, signal, dueBy, now)
			if err != nil {
				return err
			}
			if err := s.stewardship.InsertReview(ctx, scope,
				review); err != nil {
				return err
			}
			open = append(open, review)
			raised = append(raised, review)

			if err := s.appendEvent(ctx, session, EventReviewRaised,
				"ipc_stewardship_review", review.ID, map[string]any{
					"rule_code":     review.RuleCode,
					"rule_revision": review.RuleRevision,
					"kind":          string(review.Kind),
				}, now); err != nil {
				return err
			}
		}
		if len(raised) == 0 {
			return nil
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.stewardship.reviews_raised",
			ResourceType: "encounter", ResourceID: encounterID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"raised": itoa(len(raised)),
			}),
			Reason: "evaluated the stewardship triggers",
		}, now)
	})
	if err != nil {
		return nil, infectionError(err)
	}
	return raised, nil
}

// AdviseReview records the stewardship team's recommendation (SRS-IPC-008).
//
// This is the whole of what the team can do to a prescription: say what they
// think should happen to it. Acting on the advice is the prescriber's, under
// their own authority, in the medication context.
func (s *Service) AdviseReview(ctx context.Context, reviewID string,
	recommendation domain.Recommendation, advice string) (
	domain.StewardshipReview, error) {

	session, scope, err := s.authorize(ctx, PermStewardshipReview)
	if err != nil {
		return domain.StewardshipReview{}, err
	}
	now := s.clock.Now()

	var advised domain.StewardshipReview
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		review, err := s.stewardship.Review(ctx, scope, reviewID)
		if err != nil {
			return err
		}
		version := review.Version
		if err := review.Advise(recommendation, advice, session.SubjectID,
			now); err != nil {
			return err
		}
		if err := s.stewardship.UpdateReview(ctx, scope, review,
			version); err != nil {
			return err
		}
		advised = review
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.stewardship.advised",
			ResourceType: "ipc_stewardship_review", ResourceID: review.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"recommendation": string(recommendation),
			}),
			Reason: advice,
		}, now)
	})
	if err != nil {
		return domain.StewardshipReview{}, infectionError(err)
	}
	return advised, nil
}

// RespondToReview records what the prescriber did about the advice
// (SRS-IPC-008).
//
// Its own permission, and the domain and the database both refuse the
// reviewer: acceptance rate is the one number a stewardship programme is
// judged on, and a programme that can close its own advice as accepted writes
// that number itself.
func (s *Service) RespondToReview(ctx context.Context, reviewID string,
	response domain.Response, reason string) (
	domain.StewardshipReview, error) {

	session, scope, err := s.authorize(ctx, PermStewardshipRespond)
	if err != nil {
		return domain.StewardshipReview{}, err
	}
	now := s.clock.Now()

	var answered domain.StewardshipReview
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		review, err := s.stewardship.Review(ctx, scope, reviewID)
		if err != nil {
			return err
		}
		version := review.Version
		if err := review.RecordResponse(response, reason,
			session.SubjectID, now); err != nil {
			return err
		}
		if err := s.stewardship.UpdateReview(ctx, scope, review,
			version); err != nil {
			return err
		}
		answered = review
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.stewardship.responded",
			ResourceType: "ipc_stewardship_review", ResourceID: review.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"response": string(response),
			}),
			Reason: reason,
		}, now)
	})
	if err != nil {
		return domain.StewardshipReview{}, infectionError(err)
	}
	return answered, nil
}

// WithdrawReview takes a review off the worklist (SRS-IPC-008).
func (s *Service) WithdrawReview(ctx context.Context, reviewID,
	reason string) (domain.StewardshipReview, error) {

	session, scope, err := s.authorize(ctx, PermStewardshipReview)
	if err != nil {
		return domain.StewardshipReview{}, err
	}
	now := s.clock.Now()

	var withdrawn domain.StewardshipReview
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		review, err := s.stewardship.Review(ctx, scope, reviewID)
		if err != nil {
			return err
		}
		version := review.Version
		if err := review.Withdraw(reason, session.SubjectID, now); err != nil {
			return err
		}
		if err := s.stewardship.UpdateReview(ctx, scope, review,
			version); err != nil {
			return err
		}
		withdrawn = review
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.stewardship.withdrawn",
			ResourceType: "ipc_stewardship_review", ResourceID: review.ID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return domain.StewardshipReview{}, infectionError(err)
	}
	return withdrawn, nil
}

// StewardshipWorklist lists the reviews waiting for an answer (SRS-IPC-008).
func (s *Service) StewardshipWorklist(ctx context.Context,
	f ports.ReviewFilter) ([]domain.StewardshipReview, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	f.Limit = clampPageSize(f.Limit)
	return s.stewardship.Reviews(ctx, scope, f)
}

// StewardshipIndicators reports the programme's numbers (SRS-IPC-008,
// SRS-IPC-010).
//
// locationID narrows the days-of-therapy denominator to a ward. Modified
// advice counts as neither accepted nor refused, and advice nobody has
// answered leaves the acceptance rate unanswerable rather than zero.
func (s *Service) StewardshipIndicators(ctx context.Context,
	locationID string, from, to time.Time) (StewardshipReport, error) {

	session, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return StewardshipReport{}, err
	}
	now := s.clock.Now()

	reviews, err := s.stewardship.Reviews(ctx, scope, ports.ReviewFilter{
		From: from, To: to, Limit: reportPageSize,
	})
	if err != nil {
		return StewardshipReport{}, err
	}
	report := StewardshipReport{
		Summary: domain.SummariseStewardship(reviews, now),
	}

	if s.therapy != nil {
		patientDays, err := s.therapy.PatientDays(ctx, scope, locationID,
			from, to)
		if err != nil {
			return StewardshipReport{}, err
		}
		// Days of therapy are counted from the same worklist the reviews came
		// from, which is honest about what it measures: agents this
		// programme looked at, not every antimicrobial in the hospital.
		rate, err := domain.ComputeTherapyRate(report.Summary.Raised,
			patientDays)
		if err != nil && !errors.Is(err, domain.ErrInvalidInfection) {
			return StewardshipReport{}, err
		}
		report.TherapyRate = rate
	}

	if s.config.StewardshipIndicator == "" || s.indicators == nil {
		return report, nil
	}
	responded := report.Summary.Accepted + report.Summary.Modified +
		report.Summary.Declined
	revision, err := s.indicators.Record(ctx, scope,
		s.config.StewardshipIndicator, from, to, report.Summary.Accepted,
		responded, session.SubjectID, now)
	if err != nil {
		return StewardshipReport{}, err
	}
	report.IndicatorCode = s.config.StewardshipIndicator
	report.IndicatorRevision = revision
	return report, nil
}

// StewardshipReport is the programme's indicator set (SRS-IPC-010).
type StewardshipReport struct {
	Summary           domain.StewardshipSummary
	TherapyRate       domain.TherapyRate
	IndicatorCode     string
	IndicatorRevision int
}
