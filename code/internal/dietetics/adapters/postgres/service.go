package postgres

import (
	"context"

	"github.com/google/uuid"

	"github.com/ppusapati/health/code/internal/dietetics/domain"
	"github.com/ppusapati/health/code/internal/dietetics/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// ---------------------------------------------- care plans (SRS-DIET-004)

// InsertCarePlan implements ports.CarePlanRepository.
func (r *Repository) InsertCarePlan(ctx context.Context,
	scope authctx.TenantScope, p domain.CarePlan) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(p.ID)
	if err != nil {
		return notFound()
	}
	assessmentID, err := uuid.Parse(p.AssessmentID)
	if err != nil {
		return notFound()
	}
	queries := r.queries(ctx)

	if err := queries.InsertDietCarePlan(ctx,
		sqlcgen.InsertDietCarePlanParams{
			PlanID: id, TenantID: tenantID, PatientID: p.PatientID,
			EncounterID: p.EncounterID, AssessmentID: assessmentID,
			Plan: p.Plan, ReviewDue: stamp(p.ReviewDue),
			State:     string(p.State),
			CreatedAt: stamp(p.CreatedAt), CreatedBy: p.CreatedBy,
		}); err != nil {
		return err
	}

	for _, goal := range p.Goals {
		if err := queries.InsertDietCarePlanGoal(ctx,
			sqlcgen.InsertDietCarePlanGoalParams{
				GoalID: uuid.New(), TenantID: tenantID, PlanID: id,
				Code: goal.Code, Label: goal.Label,
				Target: int32(goal.Target), Unit: goal.Unit,
				Direction: string(goal.Direction),
				Tolerance: int32(goal.Tolerance),
				TargetBy:  stamp(goal.TargetBy),
			}); err != nil {
			return err
		}
	}
	return nil
}

// CarePlan implements ports.CarePlanRepository.
func (r *Repository) CarePlan(ctx context.Context,
	scope authctx.TenantScope, id string) (domain.CarePlan, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.CarePlan{}, err
	}
	parsed, err := uuid.Parse(id)
	if err != nil {
		return domain.CarePlan{}, notFound()
	}

	queries := r.queries(ctx)
	row, err := queries.GetDietCarePlan(ctx, sqlcgen.GetDietCarePlanParams{
		TenantID: tenantID, PlanID: parsed,
	})
	if isNoRows(err) {
		return domain.CarePlan{}, notFound()
	}
	if err != nil {
		return domain.CarePlan{}, err
	}
	goals, err := queries.ListDietCarePlanGoals(ctx,
		sqlcgen.ListDietCarePlanGoalsParams{
			TenantID: tenantID, PlanID: parsed,
		})
	if err != nil {
		return domain.CarePlan{}, err
	}
	return carePlanFromRow(row, goals), nil
}

// CloseCarePlan implements ports.CarePlanRepository.
func (r *Repository) CloseCarePlan(ctx context.Context,
	scope authctx.TenantScope, p domain.CarePlan,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(p.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).CloseDietCarePlan(ctx,
		sqlcgen.CloseDietCarePlanParams{
			TenantID: tenantID, PlanID: id,
			ClosedAt: stamp(p.ClosedAt), ClosedBy: p.ClosedBy,
			ClosureNote: p.ClosureNote, ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// CarePlans implements ports.CarePlanRepository.
func (r *Repository) CarePlans(ctx context.Context,
	scope authctx.TenantScope, f ports.CarePlanFilter) (
	[]domain.CarePlan, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	limit, offset := page(f.Limit, f.Offset)

	queries := r.queries(ctx)
	rows, err := queries.ListDietCarePlans(ctx,
		sqlcgen.ListDietCarePlansParams{
			TenantID: tenantID, PatientID: f.PatientID,
			OpenOnly: f.OpenOnly, PageLimit: limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}

	out := make([]domain.CarePlan, 0, len(rows))
	for _, row := range rows {
		goals, err := queries.ListDietCarePlanGoals(ctx,
			sqlcgen.ListDietCarePlanGoalsParams{
				TenantID: tenantID, PlanID: row.PlanID,
			})
		if err != nil {
			return nil, err
		}
		out = append(out, carePlanFromRow(row, goals))
	}
	return out, nil
}

// AppendProgress implements ports.CarePlanRepository.
func (r *Repository) AppendProgress(ctx context.Context,
	scope authctx.TenantScope, p domain.Progress) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(p.ID)
	if err != nil {
		return notFound()
	}
	planID, err := uuid.Parse(p.PlanID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertDietProgress(ctx,
		sqlcgen.InsertDietProgressParams{
			ProgressID: id, TenantID: tenantID, PlanID: planID,
			GoalCode: p.GoalCode, Value: int32(p.Value), Unit: p.Unit,
			Note: p.Note, RecordedAt: stamp(p.RecordedAt),
			RecordedBy: p.RecordedBy,
		})
}

// Progress implements ports.CarePlanRepository.
func (r *Repository) Progress(ctx context.Context,
	scope authctx.TenantScope, planID, goalCode string) (
	[]domain.Progress, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	parsed, err := uuid.Parse(planID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListDietProgress(ctx,
		sqlcgen.ListDietProgressParams{
			TenantID: tenantID, PlanID: parsed, GoalCode: goalCode,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.Progress, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Progress{
			ID: row.ProgressID.String(), TenantID: row.TenantID.String(),
			PlanID: row.PlanID.String(), GoalCode: row.GoalCode,
			Value: int(row.Value), Unit: row.Unit, Note: row.Note,
			RecordedAt: timeOf(row.RecordedAt), RecordedBy: row.RecordedBy,
		})
	}
	return out, nil
}

func carePlanFromRow(row sqlcgen.HospitalOpsDietCarePlan,
	goals []sqlcgen.HospitalOpsDietCarePlanGoal) domain.CarePlan {

	out := domain.CarePlan{
		ID: row.PlanID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID, EncounterID: row.EncounterID,
		AssessmentID: row.AssessmentID.String(),
		Plan:         row.Plan, ReviewDue: timeOf(row.ReviewDue),
		State:    domain.PlanState(row.State),
		ClosedAt: timeOf(row.ClosedAt), ClosedBy: row.ClosedBy,
		ClosureNote: row.ClosureNote,
		CreatedAt:   timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
	for _, goal := range goals {
		out.Goals = append(out.Goals, domain.NutritionGoal{
			Code: goal.Code, Label: goal.Label, Target: int(goal.Target),
			Unit: goal.Unit, Direction: domain.Direction(goal.Direction),
			Tolerance: int(goal.Tolerance), TargetBy: timeOf(goal.TargetBy),
		})
	}
	return out
}

// ------------------------------------- nutrition support (SRS-DIET-007)

// InsertSupportPlan implements ports.SupportRepository.
func (r *Repository) InsertSupportPlan(ctx context.Context,
	scope authctx.TenantScope, p domain.NutritionSupportPlan) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(p.ID)
	if err != nil {
		return notFound()
	}

	return r.queries(ctx).InsertDietSupportPlan(ctx,
		sqlcgen.InsertDietSupportPlanParams{
			PlanID: id, TenantID: tenantID, PatientID: p.PatientID,
			EncounterID: p.EncounterID, Kind: string(p.Kind),
			FormulaCode: p.FormulaCode, FormulaName: p.FormulaName,
			TargetVolumeMl:   int32(p.TargetVolumeML),
			TargetEnergyKcal: int32(p.TargetEnergyKcal),
			TargetProteinG:   int32(p.TargetProteinG),
			RampPlan:         p.RampPlan, State: string(p.State),
			CreatedAt: stamp(p.CreatedAt), CreatedBy: p.CreatedBy,
		})
}

// SupportPlan implements ports.SupportRepository.
func (r *Repository) SupportPlan(ctx context.Context,
	scope authctx.TenantScope, id string) (domain.NutritionSupportPlan,
	error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.NutritionSupportPlan{}, err
	}
	parsed, err := uuid.Parse(id)
	if err != nil {
		return domain.NutritionSupportPlan{}, notFound()
	}

	row, err := r.queries(ctx).GetDietSupportPlan(ctx,
		sqlcgen.GetDietSupportPlanParams{TenantID: tenantID, PlanID: parsed})
	if isNoRows(err) {
		return domain.NutritionSupportPlan{}, notFound()
	}
	if err != nil {
		return domain.NutritionSupportPlan{}, err
	}
	return supportFromRow(row), nil
}

// UpdateSupportPlan implements ports.SupportRepository.
func (r *Repository) UpdateSupportPlan(ctx context.Context,
	scope authctx.TenantScope, p domain.NutritionSupportPlan,
	expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(p.ID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).UpdateDietSupportPlan(ctx,
		sqlcgen.UpdateDietSupportPlanParams{
			TenantID: tenantID, PlanID: id, State: string(p.State),
			OrderRef: p.OrderRef, OrderContext: p.OrderContext,
			StoppedAt: stamp(p.StoppedAt), StoppedBy: p.StoppedBy,
			StopReason: p.StopReason, ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	return conflict(rows)
}

// SupportPlans implements ports.SupportRepository.
func (r *Repository) SupportPlans(ctx context.Context,
	scope authctx.TenantScope, f ports.SupportFilter) (
	[]domain.NutritionSupportPlan, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	limit, offset := page(f.Limit, f.Offset)

	rows, err := r.queries(ctx).ListDietSupportPlans(ctx,
		sqlcgen.ListDietSupportPlansParams{
			TenantID: tenantID, PatientID: f.PatientID,
			ActiveOnly: f.ActiveOnly, PageLimit: limit, PageOffset: offset,
		})
	if err != nil {
		return nil, err
	}
	out := make([]domain.NutritionSupportPlan, 0, len(rows))
	for _, row := range rows {
		out = append(out, supportFromRow(row))
	}
	return out, nil
}

func supportFromRow(
	row sqlcgen.HospitalOpsDietSupportPlan) domain.NutritionSupportPlan {

	return domain.NutritionSupportPlan{
		ID: row.PlanID.String(), TenantID: row.TenantID.String(),
		PatientID: row.PatientID, EncounterID: row.EncounterID,
		Kind:        domain.SupportKind(row.Kind),
		FormulaCode: row.FormulaCode, FormulaName: row.FormulaName,
		TargetVolumeML:   int(row.TargetVolumeMl),
		TargetEnergyKcal: int(row.TargetEnergyKcal),
		TargetProteinG:   int(row.TargetProteinG),
		RampPlan:         row.RampPlan,
		OrderRef:         row.OrderRef, OrderContext: row.OrderContext,
		State:     domain.SupportState(row.State),
		StoppedAt: timeOf(row.StoppedAt), StoppedBy: row.StoppedBy,
		StopReason: row.StopReason,
		CreatedAt:  timeOf(row.CreatedAt), CreatedBy: row.CreatedBy,
		Version: row.Version,
	}
}

var _ ports.CarePlanRepository = (*Repository)(nil)
var _ ports.SupportRepository = (*Repository)(nil)
