package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/infection/domain"
	"github.com/ppusapati/health/code/internal/infection/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
)

// NewLimitInput configures an environmental limit (SRS-IPC-009).
type NewLimitInput struct {
	Code           string
	Name           string
	Revision       int
	SampleKind     domain.SampleKind
	Unit           string
	ActionLevel    int64
	FailLevel      int64
	DetectionFails bool
	BelowIsFailure bool
}

// DraftLimit authors a limit revision (SRS-IPC-009).
func (s *Service) DraftLimit(ctx context.Context, in NewLimitInput) (
	domain.EnvironmentalLimit, error) {

	session, scope, err := s.authorize(ctx, PermRuleWrite)
	if err != nil {
		return domain.EnvironmentalLimit{}, err
	}
	now := s.clock.Now()

	limit, err := domain.NewEnvironmentalLimit(s.ids.NewID(),
		session.TenantID, domain.NewLimitInput{
			Code: in.Code, Name: in.Name, Revision: in.Revision,
			SampleKind: in.SampleKind, Unit: in.Unit,
			ActionLevel: in.ActionLevel, FailLevel: in.FailLevel,
			DetectionFails: in.DetectionFails,
			BelowIsFailure: in.BelowIsFailure,
		}, session.SubjectID, now)
	if err != nil {
		return domain.EnvironmentalLimit{}, infectionError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.environment.InsertLimit(ctx, scope, limit); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.limit.drafted",
			ResourceType: "ipc_environmental_limit", ResourceID: limit.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"code": limit.Code, "revision": itoa(limit.Revision),
				"sample_kind": string(limit.SampleKind),
			}),
			Reason: "authored an environmental limit revision",
		}, now)
	})
	if err != nil {
		return domain.EnvironmentalLimit{}, infectionError(err)
	}
	return limit, nil
}

// ApproveLimit puts a limit in force (SRS-IPC-009).
//
// Approving a revision supersedes the ones before it, so a result is judged
// by exactly one version. A limit loosened after a bad quarter changes what
// happens next and nothing about what already happened: past results keep the
// revision they were judged under.
func (s *Service) ApproveLimit(ctx context.Context, limitID string,
	effectiveFrom time.Time) (domain.EnvironmentalLimit, error) {

	session, scope, err := s.authorize(ctx, PermRuleApprove)
	if err != nil {
		return domain.EnvironmentalLimit{}, err
	}
	now := s.clock.Now()

	var approved domain.EnvironmentalLimit
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		limit, err := s.environment.Limit(ctx, scope, limitID)
		if err != nil {
			return err
		}
		if err := limit.Approve(session.SubjectID, effectiveFrom,
			now); err != nil {
			return err
		}
		if err := s.environment.ApproveLimit(ctx, scope, limit); err != nil {
			return err
		}
		if err := s.environment.SupersedeEarlierLimits(ctx, scope, limit.Code,
			limit.Revision, effectiveFrom); err != nil {
			return err
		}
		approved = limit
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.limit.approved",
			ResourceType: "ipc_environmental_limit", ResourceID: limit.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"code": limit.Code, "revision": itoa(limit.Revision),
			}),
			Reason: "put an environmental limit in force",
		}, now)
	})
	if err != nil {
		return domain.EnvironmentalLimit{}, infectionError(err)
	}
	return approved, nil
}

// AddSamplingPlan configures a schedule for a point (SRS-IPC-009).
func (s *Service) AddSamplingPlan(ctx context.Context, code string,
	kind domain.SampleKind, facilityID, locationID, point string,
	everyDays int, startedAt time.Time) (domain.SamplingPlan, error) {

	session, scope, err := s.authorize(ctx, PermRuleWrite)
	if err != nil {
		return domain.SamplingPlan{}, err
	}
	now := s.clock.Now()
	if startedAt.IsZero() {
		startedAt = now
	}

	plan, err := domain.NewSamplingPlan(s.ids.NewID(), session.TenantID, code,
		kind, facilityID, locationID, point, everyDays, startedAt)
	if err != nil {
		return domain.SamplingPlan{}, infectionError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.environment.InsertPlan(ctx, scope, plan); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.sampling_plan.added",
			ResourceType: "ipc_sampling_plan", ResourceID: plan.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"location_id": locationID, "sample_point": point,
				"every_days": itoa(everyDays),
			}),
			Reason: "configured an environmental sampling schedule",
		}, now)
	})
	if err != nil {
		return domain.SamplingPlan{}, infectionError(err)
	}
	return plan, nil
}

// CollectSampleInput records an environmental collection (SRS-IPC-009).
type CollectSampleInput struct {
	Reference   string
	Kind        domain.SampleKind
	FacilityID  string
	LocationID  string
	SamplePoint string
	PlanID      string
	OutbreakID  string
	RepeatOfID  string
	CollectedAt time.Time
	Method      string
}

// CollectSample records an environmental sample (SRS-IPC-009).
func (s *Service) CollectSample(ctx context.Context,
	in CollectSampleInput) (domain.EnvironmentalSample, error) {

	session, scope, err := s.authorize(ctx, PermEnvironment)
	if err != nil {
		return domain.EnvironmentalSample{}, err
	}
	now := s.clock.Now()
	if in.CollectedAt.IsZero() {
		in.CollectedAt = now
	}

	sample, err := domain.CollectSample(s.ids.NewID(), session.TenantID,
		domain.NewSampleInput{
			Reference: in.Reference, Kind: in.Kind,
			FacilityID: in.FacilityID, LocationID: in.LocationID,
			SamplePoint: in.SamplePoint, PlanID: in.PlanID,
			OutbreakID: in.OutbreakID, RepeatOfID: in.RepeatOfID,
			CollectedAt: in.CollectedAt, Method: in.Method,
		}, session.SubjectID, now)
	if err != nil {
		return domain.EnvironmentalSample{}, infectionError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		return s.environment.InsertSample(ctx, scope, sample)
	})
	if err != nil {
		return domain.EnvironmentalSample{}, infectionError(err)
	}
	return sample, nil
}

// RecordSampleResult files a laboratory result and derives its outcome
// (SRS-IPC-009).
//
// The outcome is computed from the limit in force when the result was
// reported. Nobody types it: a failed water sample entered as a pass does not
// move between reports, it stops existing, and the ward carries on drinking
// it.
func (s *Service) RecordSampleResult(ctx context.Context, sampleID,
	labReference string, value int64, unit, organism string, detected bool,
	resultedAt time.Time) (domain.EnvironmentalSample, error) {

	session, scope, err := s.authorize(ctx, PermEnvironment)
	if err != nil {
		return domain.EnvironmentalSample{}, err
	}
	now := s.clock.Now()
	if resultedAt.IsZero() {
		resultedAt = now
	}

	var resulted domain.EnvironmentalSample
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		sample, err := s.environment.Sample(ctx, scope, sampleID)
		if err != nil {
			return err
		}
		limits, err := s.environment.Limits(ctx, scope, sample.Kind,
			resultedAt)
		if err != nil {
			return err
		}
		version := sample.Version
		if err := sample.RecordResult(domain.ResultInput{
			LabReference: labReference, Value: value, Unit: unit,
			Organism: organism, Detected: detected, ResultedAt: resultedAt,
		}, limits, session.SubjectID, now); err != nil {
			return err
		}
		if err := s.environment.UpdateSample(ctx, scope, sample,
			version); err != nil {
			return err
		}
		resulted = sample

		if err := s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.sample.resulted",
			ResourceType: "ipc_environmental_sample", ResourceID: sample.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"outcome":        string(sample.Outcome),
				"limit_code":     sample.LimitCode,
				"limit_revision": itoa(sample.LimitRevision),
			}),
			Reason: "filed an environmental result",
		}, now); err != nil {
			return err
		}
		if !sample.Outcome.Failing() {
			return nil
		}
		if err := s.appendEvent(ctx, session, EventResultFailed,
			"ipc_environmental_sample", sample.ID, map[string]any{
				"sample_kind":  string(sample.Kind),
				"location_id":  sample.LocationID,
				"sample_point": sample.SamplePoint,
				"outcome":      string(sample.Outcome),
				"organism":     sample.Organism,
			}, now); err != nil {
			return err
		}
		if sample.Outcome != domain.OutcomeFail ||
			!s.augmentedCare(sample.LocationID) {
			return nil
		}
		// Where the hospital has said a failure cannot wait, it does not.
		return s.escalate(ctx, session, scope, ports.Notice{
			Kind: EscalationEnvironment, Subject: sample.ID,
			FacilityID: sample.FacilityID,
			Summary: "environmental failure at " + sample.LocationID +
				" " + sample.SamplePoint,
		}, now)
	})
	if err != nil {
		return domain.EnvironmentalSample{}, infectionError(err)
	}
	return resulted, nil
}

// RaiseCorrectiveAction opens an action against a failing result
// (SRS-IPC-009).
func (s *Service) RaiseCorrectiveAction(ctx context.Context, sampleID,
	action, owner string, dueBy time.Time) (domain.CorrectiveAction, error) {

	session, scope, err := s.authorize(ctx, PermEnvironmentAct)
	if err != nil {
		return domain.CorrectiveAction{}, err
	}
	now := s.clock.Now()

	var raised domain.CorrectiveAction
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		sample, err := s.environment.Sample(ctx, scope, sampleID)
		if err != nil {
			return err
		}
		raised, err = domain.RaiseCorrectiveAction(s.ids.NewID(),
			session.TenantID, sample, action, owner, dueBy, now)
		if err != nil {
			return err
		}
		if err := s.environment.InsertAction(ctx, scope, raised); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.corrective_action.raised",
			ResourceType: "ipc_corrective_action", ResourceID: raised.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"sample_id": sampleID, "owner": owner,
			}),
			Reason: action,
		}, now)
	})
	if err != nil {
		return domain.CorrectiveAction{}, infectionError(err)
	}
	return raised, nil
}

// CompleteCorrectiveAction records the work having been carried out
// (SRS-IPC-009).
func (s *Service) CompleteCorrectiveAction(ctx context.Context, actionID,
	note string) (domain.CorrectiveAction, error) {

	session, scope, err := s.authorize(ctx, PermEnvironmentAct)
	if err != nil {
		return domain.CorrectiveAction{}, err
	}
	now := s.clock.Now()

	var done domain.CorrectiveAction
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		action, err := s.environment.Action(ctx, scope, actionID)
		if err != nil {
			return err
		}
		version := action.Version
		if err := action.MarkDone(note, session.SubjectID, now); err != nil {
			return err
		}
		if err := s.environment.UpdateAction(ctx, scope, action,
			version); err != nil {
			return err
		}
		done = action
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.corrective_action.done",
			ResourceType: "ipc_corrective_action", ResourceID: action.ID,
			Outcome: audit.OutcomeSuccess, Reason: note,
		}, now)
	})
	if err != nil {
		return domain.CorrectiveAction{}, infectionError(err)
	}
	return done, nil
}

// VerifyCorrectiveAction closes an action against a repeat sample that passed
// (SRS-IPC-009).
//
// Not against somebody saying the tap was flushed. The repeat has to be of
// the same sample, taken after the work, and to have passed; every one of
// those is a way a hospital otherwise ends up with three years of "flushed
// and cleared" against the same outlet.
func (s *Service) VerifyCorrectiveAction(ctx context.Context, actionID,
	repeatSampleID string) (domain.CorrectiveAction, error) {

	session, scope, err := s.authorize(ctx, PermEnvironmentAct)
	if err != nil {
		return domain.CorrectiveAction{}, err
	}
	now := s.clock.Now()

	var verified domain.CorrectiveAction
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		action, err := s.environment.Action(ctx, scope, actionID)
		if err != nil {
			return err
		}
		repeat, err := s.environment.Sample(ctx, scope, repeatSampleID)
		if err != nil {
			return err
		}
		version := action.Version
		if err := action.Verify(repeat, session.SubjectID, now); err != nil {
			return err
		}
		if err := s.environment.UpdateAction(ctx, scope, action,
			version); err != nil {
			return err
		}
		verified = action
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.corrective_action.verified",
			ResourceType: "ipc_corrective_action", ResourceID: action.ID,
			Outcome: audit.OutcomeSuccess,
			Context: auditContext(map[string]string{
				"repeat_sample_id": repeatSampleID,
			}),
			Reason: "verified by a repeat sample that passed",
		}, now)
	})
	if err != nil {
		return domain.CorrectiveAction{}, infectionError(err)
	}
	return verified, nil
}

// CloseSample signs a result off (SRS-IPC-009).
//
// A failing result closes only through a verified corrective action, which is
// the requirement's acceptance: results link to location and corrective
// action.
func (s *Service) CloseSample(ctx context.Context, sampleID string) (
	domain.EnvironmentalSample, error) {

	session, scope, err := s.authorize(ctx, PermEnvironment)
	if err != nil {
		return domain.EnvironmentalSample{}, err
	}
	now := s.clock.Now()

	var closed domain.EnvironmentalSample
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		sample, err := s.environment.Sample(ctx, scope, sampleID)
		if err != nil {
			return err
		}
		actions, err := s.environment.Actions(ctx, scope, sampleID, false)
		if err != nil {
			return err
		}
		version := sample.Version
		if err := sample.CloseSample(actions, session.SubjectID,
			now); err != nil {
			return err
		}
		if err := s.environment.UpdateSample(ctx, scope, sample,
			version); err != nil {
			return err
		}
		closed = sample
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "infection.sample.closed",
			ResourceType: "ipc_environmental_sample", ResourceID: sample.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  "closed an environmental result",
		}, now)
	})
	if err != nil {
		return domain.EnvironmentalSample{}, infectionError(err)
	}
	return closed, nil
}

// DueSampling lists the points that are due or overdue (SRS-IPC-009).
func (s *Service) DueSampling(ctx context.Context, locationID string) (
	[]domain.DuePoint, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	plans, err := s.environment.Plans(ctx, scope, locationID, true)
	if err != nil {
		return nil, err
	}
	samples, err := s.environment.Samples(ctx, scope, ports.SampleFilter{
		LocationID: locationID, Limit: reportPageSize,
	})
	if err != nil {
		return nil, err
	}
	return domain.DueSampling(plans, samples, now), nil
}

// EnvironmentSummary counts a period's environmental testing (SRS-IPC-010).
func (s *Service) EnvironmentSummary(ctx context.Context, locationID string,
	from, to time.Time) (domain.EnvironmentSummary, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.EnvironmentSummary{}, err
	}

	samples, err := s.environment.Samples(ctx, scope, ports.SampleFilter{
		LocationID: locationID, From: from, To: to, Limit: reportPageSize,
	})
	if err != nil {
		return domain.EnvironmentSummary{}, err
	}
	actions, err := s.environment.Actions(ctx, scope, "", false)
	if err != nil {
		return domain.EnvironmentSummary{}, err
	}
	return domain.SummariseEnvironment(samples, actions), nil
}

// Samples lists environmental results (SRS-IPC-009).
func (s *Service) Samples(ctx context.Context, f ports.SampleFilter) (
	[]domain.EnvironmentalSample, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	f.Limit = clampPageSize(f.Limit)
	return s.environment.Samples(ctx, scope, f)
}

// CorrectiveActions lists a sample's actions, or every open one
// (SRS-IPC-009).
func (s *Service) CorrectiveActions(ctx context.Context, sampleID string,
	openOnly bool) ([]domain.CorrectiveAction, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	return s.environment.Actions(ctx, scope, sampleID, openOnly)
}
