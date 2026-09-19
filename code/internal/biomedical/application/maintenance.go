package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/biomedical/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
)

// RecordContract records a warranty, AMC or CMC (SRS-BIO-002).
func (s *Service) RecordContract(ctx context.Context,
	in domain.NewContractInput) (domain.ServiceContract, error) {

	session, scope, err := s.authorize(ctx, PermContract)
	if err != nil {
		return domain.ServiceContract{}, err
	}
	now := s.clock.Now()

	contract, err := domain.NewServiceContract(s.ids.NewID(), session.TenantID,
		in, session.SubjectID, now)
	if err != nil {
		return domain.ServiceContract{}, biomedicalError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		// A contract against an asset nobody can resolve is a renewal
		// reminder for a machine that does not exist.
		if _, err := s.assets.Asset(ctx, scope, contract.AssetID); err != nil {
			return err
		}
		if err := s.contracts.InsertContract(ctx, scope, contract); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action:       "biomedical.contract.record",
			ResourceType: "biomedical_contract", ResourceID: contract.ID,
			Outcome: audit.OutcomeSuccess,
			Reason:  string(contract.Kind) + " " + contract.Reference,
		}, now)
	})
	if err != nil {
		return domain.ServiceContract{}, biomedicalError(err)
	}
	return contract, nil
}

// Contract reads one agreement.
func (s *Service) Contract(ctx context.Context, id string) (
	domain.ServiceContract, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.ServiceContract{}, err
	}
	contract, err := s.contracts.Contract(ctx, scope, id)
	if err != nil {
		return domain.ServiceContract{}, biomedicalError(err)
	}
	return contract, nil
}

// ContractsForAsset lists what covers one machine.
func (s *Service) ContractsForAsset(ctx context.Context, assetID string) (
	[]domain.ServiceContract, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	contracts, err := s.contracts.ContractsForAsset(ctx, scope, assetID)
	if err != nil {
		return nil, biomedicalError(err)
	}
	return contracts, nil
}

// CoverForAsset reports which agreement applies right now, if any
// (SRS-BIO-002).
//
// Answered here rather than left to the caller, because "the most protective
// live contract" is a rule and three clients would each get it slightly
// different.
func (s *Service) CoverForAsset(ctx context.Context, assetID string) (
	domain.ServiceContract, bool, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return domain.ServiceContract{}, false, err
	}
	contracts, err := s.contracts.ContractsForAsset(ctx, scope, assetID)
	if err != nil {
		return domain.ServiceContract{}, false, biomedicalError(err)
	}
	contract, found := domain.CoverFor(contracts, assetID, s.clock.Now())
	return contract, found, nil
}

// ExpiryReminders reports what is coming due (SRS-BIO-002, SRS-BIO-004).
//
// Contracts and calibrations in one list, because the person who chases a
// lapsed AMC is the person who chases a lapsed calibration and two screens
// means one of them gets looked at.
func (s *Service) ExpiryReminders(ctx context.Context, pageSize int32) (
	[]domain.Expiry, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()
	limit := clampPageSize(pageSize)

	// Retired equipment is excluded at the source: a lapsed contract on a
	// disposed machine is not work.
	assets, err := s.assets.Assets(ctx, scope, "", "", true, MaxPageSize)
	if err != nil {
		return nil, biomedicalError(err)
	}
	contracts, err := s.contracts.ExpiringBefore(ctx, scope,
		now.Add(s.config.ExpiryHorizon), limit)
	if err != nil {
		return nil, biomedicalError(err)
	}

	expiries := domain.Expiries(assets, contracts, s.config.ExpiryHorizon, now)
	if int32(len(expiries)) > limit {
		expiries = expiries[:limit]
	}
	return expiries, nil
}

// SchedulePlan schedules preventive maintenance (SRS-BIO-003).
func (s *Service) SchedulePlan(ctx context.Context, in domain.NewPlanInput) (
	domain.PMPlan, error) {

	session, scope, err := s.authorize(ctx, PermPlan)
	if err != nil {
		return domain.PMPlan{}, err
	}
	now := s.clock.Now()

	plan, err := domain.NewPMPlan(s.ids.NewID(), session.TenantID, in,
		session.SubjectID, now)
	if err != nil {
		return domain.PMPlan{}, biomedicalError(err)
	}

	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if _, err := s.assets.Asset(ctx, scope, plan.AssetID); err != nil {
			return err
		}
		if err := s.plans.InsertPlan(ctx, scope, plan); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			Action: "biomedical.plan.schedule", ResourceType: "biomedical_plan",
			ResourceID: plan.ID, Outcome: audit.OutcomeSuccess,
			Reason: string(plan.Basis) + ": " + plan.Procedure,
		}, now)
	})
	if err != nil {
		return domain.PMPlan{}, biomedicalError(err)
	}
	return plan, nil
}

// RetirePlan stops a schedule without deleting what it produced.
//
// Deactivated rather than removed: the closed tickets raised under it are the
// evidence that maintenance was done, and a plan that vanishes takes the
// compliance history with it.
func (s *Service) RetirePlan(ctx context.Context, planID string,
	expectedVersion int64) (domain.PMPlan, error) {

	session, scope, err := s.authorize(ctx, PermPlan)
	if err != nil {
		return domain.PMPlan{}, err
	}
	now := s.clock.Now()

	var updated domain.PMPlan
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		plan, err := s.plans.Plan(ctx, scope, planID)
		if err != nil {
			return err
		}
		plan.Active = false
		if err := s.plans.UpdatePlan(ctx, scope, plan,
			expectedVersion); err != nil {
			return err
		}
		plan.Version = expectedVersion + 1
		updated = plan
		return s.appendAudit(ctx, session, audit.Record{
			Action: "biomedical.plan.retire", ResourceType: "biomedical_plan",
			ResourceID: plan.ID, Outcome: audit.OutcomeSuccess,
		}, now)
	})
	if err != nil {
		return domain.PMPlan{}, biomedicalError(err)
	}
	return updated, nil
}

// Plans lists the schedules against one asset, or all of them.
func (s *Service) Plans(ctx context.Context, assetID string, activeOnly bool,
	pageSize int32) ([]domain.PMPlan, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	plans, err := s.plans.Plans(ctx, scope, assetID, activeOnly,
		clampPageSize(pageSize))
	if err != nil {
		return nil, biomedicalError(err)
	}
	return plans, nil
}

// DueMaintenance derives what preventive maintenance is due (SRS-BIO-003).
//
// Derived on read, over the live meter readings rather than a stored date: a
// stored due date drifts the moment somebody services the machine without
// closing the right record.
func (s *Service) DueMaintenance(ctx context.Context, pageSize int32) (
	[]domain.Due, error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return nil, err
	}
	now := s.clock.Now()

	plans, err := s.plans.Plans(ctx, scope, "", true, MaxPageSize)
	if err != nil {
		return nil, biomedicalError(err)
	}
	assets, err := s.assets.Assets(ctx, scope, "", "", true, MaxPageSize)
	if err != nil {
		return nil, biomedicalError(err)
	}

	// The meter, where there is one. A runtime plan with no reading is
	// reported as unanswerable rather than as not-due, which is the domain's
	// job — this only has to supply what it knows.
	runtime := map[string]int{}
	if s.telemetry != nil {
		readings, err := s.telemetry.LatestByMetric(ctx, scope,
			domain.MetricRuntimeHours)
		if err != nil {
			return nil, biomedicalError(err)
		}
		runtime = domain.LatestRuntime(readings)
	}

	due := domain.DueList(plans, assets, runtime, s.config.SoonWindow, now)
	if limit := clampPageSize(pageSize); int32(len(due)) > limit {
		due = due[:limit]
	}
	return due, nil
}

// advancePlanBaseline moves a plan's baseline forward after planned work
// closed against it.
//
// Called from ticket closure rather than exposed, because a baseline that can
// be set directly is a PM compliance figure anybody can correct upwards.
func (s *Service) advancePlanBaseline(ctx context.Context, scope authctx.TenantScope,
	planID string, at time.Time) error {

	if planID == "" {
		return nil
	}
	plan, err := s.plans.Plan(ctx, scope, planID)
	if err != nil {
		return err
	}
	if !plan.LastPerformedAt.IsZero() && !at.After(plan.LastPerformedAt) {
		// Work closed out of order. Leaving the later baseline alone is the
		// direction that reports the plan as due sooner rather than later.
		return nil
	}
	plan.LastPerformedAt = at.UTC()
	if s.telemetry != nil && plan.Basis == domain.BasisRuntime {
		readings, err := s.telemetry.LatestByMetric(ctx, scope,
			domain.MetricRuntimeHours)
		if err != nil {
			return err
		}
		if hours, told := domain.LatestRuntime(readings)[plan.AssetID]; told {
			plan.LastRuntimeHours = hours
		}
	}
	return s.plans.UpdatePlan(ctx, scope, plan, plan.Version)
}
