// Package transport translates between the dietetics contract and the domain.
//
// The enum maps are one-way tables in both directions rather than casts,
// because the wire enum and the domain constant are allowed to diverge and a
// cast would hide it. Reverse maps are built in init() from the forward ones,
// so a value added to one direction cannot be forgotten in the other.
//
// Every default fails in the safe direction. An unrecognised route stays
// empty and the domain refuses it rather than defaulting to oral, which would
// plate a tray for a patient who might be nil by mouth; an unrecognised tray
// state stays empty rather than becoming delivered.
package transport

import (
	"time"

	hospitalopsdietv1 "github.com/ppusapati/health/code/gen/go/healthcare/hospital_ops_diet/v1"
	"github.com/ppusapati/health/code/internal/dietetics/domain"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func stamp(t time.Time) *timestamppb.Timestamp {
	if t.IsZero() {
		// Absent rather than the epoch: a zero timestamp reads as 1970 on
		// the wire, and a meal due in 1970 is one every screen shows as
		// hours late.
		return nil
	}
	return timestamppb.New(t.UTC())
}

func timeOf(t *timestamppb.Timestamp) time.Time {
	if t == nil {
		return time.Time{}
	}
	return t.AsTime().UTC()
}

var routeFromWire = map[hospitalopsdietv1.Route]domain.Route{
	hospitalopsdietv1.Route_ROUTE_ORAL:       domain.RouteOral,
	hospitalopsdietv1.Route_ROUTE_ENTERAL:    domain.RouteEnteral,
	hospitalopsdietv1.Route_ROUTE_PARENTERAL: domain.RouteParenteral,
	hospitalopsdietv1.Route_ROUTE_NPO:        domain.RouteNPO,
}

var orderStateFromWire = map[hospitalopsdietv1.OrderState]domain.OrderState{
	hospitalopsdietv1.OrderState_ORDER_STATE_PENDING:    domain.OrderPending,
	hospitalopsdietv1.OrderState_ORDER_STATE_ACTIVE:     domain.OrderActive,
	hospitalopsdietv1.OrderState_ORDER_STATE_SUPERSEDED: domain.OrderSuperseded,
	hospitalopsdietv1.OrderState_ORDER_STATE_CANCELLED:  domain.OrderCancelled,
}

var assessmentStateFromWire = map[hospitalopsdietv1.AssessmentState]domain.AssessmentState{
	hospitalopsdietv1.AssessmentState_ASSESSMENT_STATE_DRAFT:  domain.AssessmentDraft,
	hospitalopsdietv1.AssessmentState_ASSESSMENT_STATE_SIGNED: domain.AssessmentSigned,
}

var directionFromWire = map[hospitalopsdietv1.Direction]domain.Direction{
	hospitalopsdietv1.Direction_DIRECTION_INCREASE: domain.DirectionIncrease,
	hospitalopsdietv1.Direction_DIRECTION_DECREASE: domain.DirectionDecrease,
	hospitalopsdietv1.Direction_DIRECTION_MAINTAIN: domain.DirectionMaintain,
}

var planStateFromWire = map[hospitalopsdietv1.PlanState]domain.PlanState{
	hospitalopsdietv1.PlanState_PLAN_STATE_ACTIVE: domain.PlanActive,
	hospitalopsdietv1.PlanState_PLAN_STATE_CLOSED: domain.PlanClosed,
}

var cycleFromWire = map[hospitalopsdietv1.MealCycle]domain.MealCycle{
	hospitalopsdietv1.MealCycle_MEAL_CYCLE_BREAKFAST: domain.CycleBreakfast,
	hospitalopsdietv1.MealCycle_MEAL_CYCLE_LUNCH:     domain.CycleLunch,
	hospitalopsdietv1.MealCycle_MEAL_CYCLE_DINNER:    domain.CycleDinner,
	hospitalopsdietv1.MealCycle_MEAL_CYCLE_SNACK:     domain.CycleSnack,
}

var censusStateFromWire = map[hospitalopsdietv1.CensusState]domain.CensusState{
	hospitalopsdietv1.CensusState_CENSUS_STATE_DRAFT:      domain.CensusDraft,
	hospitalopsdietv1.CensusState_CENSUS_STATE_FROZEN:     domain.CensusFrozen,
	hospitalopsdietv1.CensusState_CENSUS_STATE_SUPERSEDED: domain.CensusSuperseded,
}

var trayStateFromWire = map[hospitalopsdietv1.TrayState]domain.TrayState{
	hospitalopsdietv1.TrayState_TRAY_STATE_PLANNED:    domain.TrayPlanned,
	hospitalopsdietv1.TrayState_TRAY_STATE_PREPARED:   domain.TrayPrepared,
	hospitalopsdietv1.TrayState_TRAY_STATE_DISPATCHED: domain.TrayDispatched,
	hospitalopsdietv1.TrayState_TRAY_STATE_DELIVERED:  domain.TrayDelivered,
	hospitalopsdietv1.TrayState_TRAY_STATE_REFUSED:    domain.TrayRefused,
	hospitalopsdietv1.TrayState_TRAY_STATE_MISSED:     domain.TrayMissed,
	hospitalopsdietv1.TrayState_TRAY_STATE_WITHHELD:   domain.TrayWithheld,
}

var supportKindFromWire = map[hospitalopsdietv1.SupportKind]domain.SupportKind{
	hospitalopsdietv1.SupportKind_SUPPORT_KIND_ENTERAL:    domain.SupportEnteral,
	hospitalopsdietv1.SupportKind_SUPPORT_KIND_PARENTERAL: domain.SupportParenteral,
}

var supportStateFromWire = map[hospitalopsdietv1.SupportState]domain.SupportState{
	hospitalopsdietv1.SupportState_SUPPORT_STATE_PLANNED: domain.SupportPlanned,
	hospitalopsdietv1.SupportState_SUPPORT_STATE_ACTIVE:  domain.SupportActive,
	hospitalopsdietv1.SupportState_SUPPORT_STATE_STOPPED: domain.SupportStopped,
}

// The reverse tables, built from the forward ones so a value added to one
// direction cannot be forgotten in the other.
var (
	routeToWire           = map[domain.Route]hospitalopsdietv1.Route{}
	orderStateToWire      = map[domain.OrderState]hospitalopsdietv1.OrderState{}
	assessmentStateToWire = map[domain.AssessmentState]hospitalopsdietv1.AssessmentState{}
	directionToWire       = map[domain.Direction]hospitalopsdietv1.Direction{}
	planStateToWire       = map[domain.PlanState]hospitalopsdietv1.PlanState{}
	cycleToWire           = map[domain.MealCycle]hospitalopsdietv1.MealCycle{}
	censusStateToWire     = map[domain.CensusState]hospitalopsdietv1.CensusState{}
	trayStateToWire       = map[domain.TrayState]hospitalopsdietv1.TrayState{}
	supportKindToWire     = map[domain.SupportKind]hospitalopsdietv1.SupportKind{}
	supportStateToWire    = map[domain.SupportState]hospitalopsdietv1.SupportState{}
)

func init() {
	for wire, value := range routeFromWire {
		routeToWire[value] = wire
	}
	for wire, value := range orderStateFromWire {
		orderStateToWire[value] = wire
	}
	for wire, value := range assessmentStateFromWire {
		assessmentStateToWire[value] = wire
	}
	for wire, value := range directionFromWire {
		directionToWire[value] = wire
	}
	for wire, value := range planStateFromWire {
		planStateToWire[value] = wire
	}
	for wire, value := range cycleFromWire {
		cycleToWire[value] = wire
	}
	for wire, value := range censusStateFromWire {
		censusStateToWire[value] = wire
	}
	for wire, value := range trayStateFromWire {
		trayStateToWire[value] = wire
	}
	for wire, value := range supportKindFromWire {
		supportKindToWire[value] = wire
	}
	for wire, value := range supportStateFromWire {
		supportStateToWire[value] = wire
	}
}

func anthropometryFromWire(
	a *hospitalopsdietv1.Anthropometry) domain.Anthropometry {

	if a == nil {
		return domain.Anthropometry{}
	}
	return domain.Anthropometry{
		HeightMM: int(a.GetHeightMm()), WeightG: int(a.GetWeightG()),
		MidUpperArmMM: int(a.GetMidUpperArmMm()),
		Estimated:     a.GetEstimated(),
		MeasuredAt:    timeOf(a.GetMeasuredAt()),
	}
}

func requirementFromWire(
	r *hospitalopsdietv1.Requirement) domain.Requirement {

	if r == nil {
		return domain.Requirement{}
	}
	return domain.Requirement{
		EnergyKcal: int(r.GetEnergyKcal()), ProteinG: int(r.GetProteinG()),
		FluidML: int(r.GetFluidMl()), Basis: r.GetBasis(),
	}
}

func textureFromWire(t *hospitalopsdietv1.Texture) domain.Texture {
	if t == nil {
		return domain.Texture{}
	}
	return domain.Texture{
		Code: t.GetCode(), Label: t.GetLabel(),
		FluidCode: t.GetFluidCode(),
	}
}

func goalsFromWire(
	goals []*hospitalopsdietv1.NutritionGoal) []domain.NutritionGoal {

	out := make([]domain.NutritionGoal, 0, len(goals))
	for _, goal := range goals {
		out = append(out, domain.NutritionGoal{
			Code: goal.GetCode(), Label: goal.GetLabel(),
			Target: int(goal.GetTarget()), Unit: goal.GetUnit(),
			Direction: directionFromWire[goal.GetDirection()],
			Tolerance: int(goal.GetTolerance()),
			TargetBy:  timeOf(goal.GetTargetBy()),
		})
	}
	return out
}

func assessmentToWire(
	a domain.NutritionAssessment) *hospitalopsdietv1.NutritionAssessment {

	return &hospitalopsdietv1.NutritionAssessment{
		AssessmentId: a.ID, PatientId: a.PatientID,
		EncounterId: a.EncounterID, FacilityId: a.FacilityID,
		Anthropometry: &hospitalopsdietv1.Anthropometry{
			HeightMm:      int32(a.Anthropometry.HeightMM),
			WeightG:       int32(a.Anthropometry.WeightG),
			MidUpperArmMm: int32(a.Anthropometry.MidUpperArmMM),
			Estimated:     a.Anthropometry.Estimated,
			MeasuredAt:    stamp(a.Anthropometry.MeasuredAt),
		},
		BodyMassIndexTenths: int32(a.Anthropometry.BMITenths()),
		IntakeSummary:       a.IntakeSummary,
		DiagnosisCode:       a.DiagnosisCode, Diagnosis: a.Diagnosis,
		AllergyRefs: a.AllergyRefs,
		Requirement: &hospitalopsdietv1.Requirement{
			EnergyKcal: int32(a.Requirement.EnergyKcal),
			ProteinG:   int32(a.Requirement.ProteinG),
			FluidMl:    int32(a.Requirement.FluidML),
			Basis:      a.Requirement.Basis,
		},
		RiskTool: a.RiskTool, RiskScore: int32(a.RiskScore),
		State: assessmentStateToWire[a.State], SignedBy: a.SignedBy,
		SignedAt: stamp(a.SignedAt), CreatedAt: stamp(a.CreatedAt),
		CreatedBy: a.CreatedBy, Version: a.Version,
	}
}

func orderToWire(o domain.DietOrder) *hospitalopsdietv1.DietOrder {
	conflicts := make([]*hospitalopsdietv1.Conflict, 0, len(o.Conflicts))
	for _, conflict := range o.Conflicts {
		conflicts = append(conflicts, &hospitalopsdietv1.Conflict{
			AllergyRef: conflict.AllergyRef, Substance: conflict.Substance,
			Item: conflict.Item, Severity: conflict.Severity,
			ResolvedBy:     conflict.ResolvedBy,
			ResolvedAt:     stamp(conflict.ResolvedAt),
			ResolutionNote: conflict.ResolutionNote,
		})
	}
	return &hospitalopsdietv1.DietOrder{
		OrderId: o.ID, PatientId: o.PatientID,
		EncounterId: o.EncounterID, FacilityId: o.FacilityID,
		WardId: o.WardID, BedId: o.BedID, Route: routeToWire[o.Route],
		Texture: &hospitalopsdietv1.Texture{
			Code: o.Texture.Code, Label: o.Texture.Label,
			FluidCode: o.Texture.FluidCode,
		},
		Restrictions: o.Restrictions, Supplements: o.Supplements,
		Instruction:   o.Instruction,
		EffectiveFrom: stamp(o.EffectiveFrom),
		EffectiveTo:   stamp(o.EffectiveTo),
		State:         orderStateToWire[o.State], Conflicts: conflicts,
		CancelledReason: o.CancelledReason, CancelledBy: o.CancelledBy,
		CancelledAt: stamp(o.CancelledAt),
		PlacedAt:    stamp(o.PlacedAt), PlacedBy: o.PlacedBy,
		Version: o.Version,
	}
}

func carePlanToWire(p domain.CarePlan) *hospitalopsdietv1.CarePlan {
	goals := make([]*hospitalopsdietv1.NutritionGoal, 0, len(p.Goals))
	for _, goal := range p.Goals {
		goals = append(goals, goalToWire(goal))
	}
	return &hospitalopsdietv1.CarePlan{
		PlanId: p.ID, PatientId: p.PatientID, EncounterId: p.EncounterID,
		AssessmentId: p.AssessmentID, Goals: goals, Plan: p.Plan,
		ReviewDue: stamp(p.ReviewDue), State: planStateToWire[p.State],
		ClosedAt: stamp(p.ClosedAt), ClosedBy: p.ClosedBy,
		ClosureNote: p.ClosureNote, CreatedAt: stamp(p.CreatedAt),
		CreatedBy: p.CreatedBy, Version: p.Version,
	}
}

func goalToWire(g domain.NutritionGoal) *hospitalopsdietv1.NutritionGoal {
	return &hospitalopsdietv1.NutritionGoal{
		Code: g.Code, Label: g.Label, Target: int32(g.Target),
		Unit: g.Unit, Direction: directionToWire[g.Direction],
		Tolerance: int32(g.Tolerance), TargetBy: stamp(g.TargetBy),
	}
}

func censusToWire(c domain.MealCensus) *hospitalopsdietv1.MealCensus {
	lines := make([]*hospitalopsdietv1.CensusLine, 0, len(c.Lines))
	for _, line := range c.Lines {
		lines = append(lines, &hospitalopsdietv1.CensusLine{
			PatientId: line.PatientID, EncounterId: line.EncounterID,
			WardId: line.WardID, BedId: line.BedID,
			OrderId: line.OrderID, Route: routeToWire[line.Route],
			TextureCode:  line.TextureCode,
			TextureLabel: line.TextureLabel, FluidCode: line.FluidCode,
			Restrictions: line.Restrictions,
			Supplements:  line.Supplements,
			Instruction:  line.Instruction,
		})
	}
	return &hospitalopsdietv1.MealCensus{
		CensusId: c.ID, FacilityId: c.FacilityID, WardId: c.WardID,
		Cycle: cycleToWire[c.Cycle], ServiceDate: stamp(c.ServiceDate),
		CutoffAt: stamp(c.CutoffAt), Lines: lines,
		State:         censusStateToWire[c.State],
		CensusVersion: int32(c.Version), SupersedesId: c.SupersedesID,
		FrozenAt: stamp(c.FrozenAt), FrozenBy: c.FrozenBy,
		BuiltAt: stamp(c.BuiltAt), BuiltBy: c.BuiltBy,
	}
}

func trayToWire(t domain.Tray) *hospitalopsdietv1.Tray {
	return &hospitalopsdietv1.Tray{
		TrayId: t.ID, CensusId: t.CensusID, PatientId: t.PatientID,
		WardId: t.WardID, BedId: t.BedID, Cycle: cycleToWire[t.Cycle],
		OrderId: t.OrderID, State: trayStateToWire[t.State],
		Reason:     t.Reason,
		PreparedAt: stamp(t.PreparedAt), PreparedBy: t.PreparedBy,
		DispatchedAt: stamp(t.DispatchedAt),
		DispatchedBy: t.DispatchedBy,
		DeliveredAt:  stamp(t.DeliveredAt), DeliveredBy: t.DeliveredBy,
		DueBy: stamp(t.DueBy), Version: t.Version,
	}
}

func supportToWire(
	p domain.NutritionSupportPlan) *hospitalopsdietv1.NutritionSupportPlan {

	return &hospitalopsdietv1.NutritionSupportPlan{
		PlanId: p.ID, PatientId: p.PatientID, EncounterId: p.EncounterID,
		Kind: supportKindToWire[p.Kind], FormulaCode: p.FormulaCode,
		FormulaName:      p.FormulaName,
		TargetVolumeMl:   int32(p.TargetVolumeML),
		TargetEnergyKcal: int32(p.TargetEnergyKcal),
		TargetProteinG:   int32(p.TargetProteinG),
		RampPlan:         p.RampPlan, OrderRef: p.OrderRef,
		OrderContext: p.OrderContext,
		State:        supportStateToWire[p.State],
		StoppedAt:    stamp(p.StoppedAt), StoppedBy: p.StoppedBy,
		StopReason: p.StopReason, CreatedAt: stamp(p.CreatedAt),
		CreatedBy: p.CreatedBy, Version: p.Version,
	}
}

func recipeFromWire(r *hospitalopsdietv1.Recipe) domain.Recipe {
	if r == nil {
		return domain.Recipe{}
	}
	out := domain.Recipe{Code: r.GetCode(), Name: r.GetName()}
	for _, ingredient := range r.GetIngredients() {
		out.Ingredients = append(out.Ingredients, domain.IngredientQuantity{
			Code: ingredient.GetCode(), Name: ingredient.GetName(),
			Grams: int(ingredient.GetGrams()),
		})
	}
	return out
}

func recipeToWire(r domain.Recipe) *hospitalopsdietv1.Recipe {
	ingredients := make([]*hospitalopsdietv1.IngredientQuantity, 0,
		len(r.Ingredients))
	for _, ingredient := range r.Ingredients {
		ingredients = append(ingredients,
			&hospitalopsdietv1.IngredientQuantity{
				Code: ingredient.Code, Name: ingredient.Name,
				Grams: int32(ingredient.Grams),
			})
	}
	return &hospitalopsdietv1.Recipe{
		Code: r.Code, Name: r.Name, Ingredients: ingredients,
	}
}

func forecastToWire(f domain.Forecast) *hospitalopsdietv1.Forecast {
	demand := make([]*hospitalopsdietv1.IngredientDemand, 0, len(f.Demand))
	for _, one := range f.Demand {
		waste, known := one.WastageG()
		demand = append(demand, &hospitalopsdietv1.IngredientDemand{
			Code: one.Code, Name: one.Name,
			ForecastG: int32(one.ForecastG), ActualG: int32(one.ActualG),
			ActualRecorded: one.ActualRecorded,
			WastageG:       int32(waste), WastageKnown: known,
		})
	}
	return &hospitalopsdietv1.Forecast{
		CensusId: f.CensusID, CensusVersion: int32(f.CensusVersion),
		Cycle: cycleToWire[f.Cycle], ServiceDate: stamp(f.ServiceDate),
		Trays: int32(f.Trays), Demand: demand,
		Uncovered: int32(f.Uncovered),
	}
}
