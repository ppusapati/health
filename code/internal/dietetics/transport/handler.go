package transport

import (
	"context"
	"time"

	"connectrpc.com/connect"

	hospitalopsdietv1 "github.com/ppusapati/health/code/gen/go/healthcare/hospital_ops_diet/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/hospital_ops_diet/v1/hospitalopsdietv1connect"
	"github.com/ppusapati/health/code/internal/dietetics/application"
	"github.com/ppusapati/health/code/internal/dietetics/domain"
	"github.com/ppusapati/health/code/internal/dietetics/ports"
)

// Handler is the dietetics ConnectRPC surface.
//
// Thin on purpose: it translates, calls one use case and translates back.
// Every refusal comes from the application or the domain, so the same rule
// holds whichever client asks.
type Handler struct {
	svc *application.Service
	now func() time.Time
}

// NewHandler constructs a Handler.
func NewHandler(svc *application.Service, now func() time.Time) *Handler {
	if now == nil {
		now = time.Now
	}
	return &Handler{svc: svc, now: now}
}

// Nutrition assessment and care plans (SRS-DIET-001, SRS-DIET-004).

func (h *Handler) RecordAssessment(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.RecordAssessmentRequest]) (
	*connect.Response[hospitalopsdietv1.RecordAssessmentResponse], error) {

	msg := req.Msg
	assessment, err := h.svc.RecordAssessment(ctx,
		application.NewAssessmentInput{
			PatientID:     msg.GetPatientId(),
			EncounterID:   msg.GetEncounterId(),
			FacilityID:    msg.GetFacilityId(),
			Anthropometry: anthropometryFromWire(msg.GetAnthropometry()),
			IntakeSummary: msg.GetIntakeSummary(),
			DiagnosisCode: msg.GetDiagnosisCode(),
			Diagnosis:     msg.GetDiagnosis(),
			Requirement:   requirementFromWire(msg.GetRequirement()),
			RiskTool:      msg.GetRiskTool(),
			RiskScore:     int(msg.GetRiskScore()),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(
		&hospitalopsdietv1.RecordAssessmentResponse{
			Assessment: assessmentToWire(assessment),
		}), nil
}

func (h *Handler) SignAssessment(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.SignAssessmentRequest]) (
	*connect.Response[hospitalopsdietv1.SignAssessmentResponse], error) {

	assessment, err := h.svc.SignAssessment(ctx, req.Msg.GetAssessmentId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&hospitalopsdietv1.SignAssessmentResponse{
		Assessment: assessmentToWire(assessment),
	}), nil
}

func (h *Handler) ListAssessments(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.ListAssessmentsRequest]) (
	*connect.Response[hospitalopsdietv1.ListAssessmentsResponse], error) {

	msg := req.Msg
	list, err := h.svc.Assessments(ctx, ports.AssessmentFilter{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		SignedOnly: msg.GetSignedOnly(),
		Limit:      msg.GetPageSize(), Offset: msg.GetPageOffset(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*hospitalopsdietv1.NutritionAssessment, 0, len(list))
	for _, assessment := range list {
		out = append(out, assessmentToWire(assessment))
	}
	return connect.NewResponse(&hospitalopsdietv1.ListAssessmentsResponse{
		Assessments: out,
	}), nil
}

func (h *Handler) OpenCarePlan(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.OpenCarePlanRequest]) (
	*connect.Response[hospitalopsdietv1.OpenCarePlanResponse], error) {

	msg := req.Msg
	plan, err := h.svc.OpenCarePlan(ctx, application.NewCarePlanInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		AssessmentID: msg.GetAssessmentId(),
		Goals:        goalsFromWire(msg.GetGoals()),
		Plan:         msg.GetPlan(),
		ReviewDue:    timeOf(msg.GetReviewDue()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&hospitalopsdietv1.OpenCarePlanResponse{
		Plan: carePlanToWire(plan),
	}), nil
}

func (h *Handler) RecordProgress(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.RecordProgressRequest]) (
	*connect.Response[hospitalopsdietv1.RecordProgressResponse], error) {

	msg := req.Msg
	progress, err := h.svc.RecordProgress(ctx, msg.GetPlanId(),
		msg.GetGoalCode(), int(msg.GetValue()), msg.GetNote(),
		timeOf(msg.GetMeasuredAt()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&hospitalopsdietv1.RecordProgressResponse{
		Progress: &hospitalopsdietv1.Progress{
			ProgressId: progress.ID, PlanId: progress.PlanID,
			GoalCode: progress.GoalCode, Value: int32(progress.Value),
			Unit: progress.Unit, Note: progress.Note,
			RecordedAt: stamp(progress.RecordedAt),
			RecordedBy: progress.RecordedBy,
		},
	}), nil
}

func (h *Handler) CloseCarePlan(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.CloseCarePlanRequest]) (
	*connect.Response[hospitalopsdietv1.CloseCarePlanResponse], error) {

	plan, err := h.svc.CloseCarePlan(ctx, req.Msg.GetPlanId(),
		req.Msg.GetNote())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&hospitalopsdietv1.CloseCarePlanResponse{
		Plan: carePlanToWire(plan),
	}), nil
}

func (h *Handler) ListCarePlans(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.ListCarePlansRequest]) (
	*connect.Response[hospitalopsdietv1.ListCarePlansResponse], error) {

	msg := req.Msg
	list, err := h.svc.CarePlans(ctx, ports.CarePlanFilter{
		PatientID: msg.GetPatientId(), OpenOnly: msg.GetOpenOnly(),
		Limit: msg.GetPageSize(), Offset: msg.GetPageOffset(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*hospitalopsdietv1.CarePlan, 0, len(list))
	for _, plan := range list {
		out = append(out, carePlanToWire(plan))
	}
	return connect.NewResponse(&hospitalopsdietv1.ListCarePlansResponse{
		Plans: out,
	}), nil
}

func (h *Handler) GetGoalTrend(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.GetGoalTrendRequest]) (
	*connect.Response[hospitalopsdietv1.GetGoalTrendResponse], error) {

	trend, err := h.svc.GoalTrend(ctx, req.Msg.GetPlanId(),
		req.Msg.GetGoalCode())
	if err != nil {
		return nil, err
	}
	points := make([]*hospitalopsdietv1.TrendPoint, 0, len(trend.Points))
	for _, point := range trend.Points {
		points = append(points, &hospitalopsdietv1.TrendPoint{
			Value: int32(point.Value), At: stamp(point.At),
		})
	}
	return connect.NewResponse(&hospitalopsdietv1.GetGoalTrendResponse{
		Trend: &hospitalopsdietv1.Trend{
			Goal: goalToWire(trend.Goal), Points: points,
			Met: trend.Met, Improving: trend.Improving,
			Unanswerable: trend.Unanswerable,
		},
	}), nil
}

// Diet orders (SRS-DIET-002, SRS-DIET-003, SRS-DIET-009).

func (h *Handler) PlaceDietOrder(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.PlaceDietOrderRequest]) (
	*connect.Response[hospitalopsdietv1.PlaceDietOrderResponse], error) {

	msg := req.Msg
	order, err := h.svc.PlaceDietOrder(ctx, application.NewOrderInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		FacilityID: msg.GetFacilityId(), WardID: msg.GetWardId(),
		BedID: msg.GetBedId(), Route: routeFromWire[msg.GetRoute()],
		Texture:       textureFromWire(msg.GetTexture()),
		Restrictions:  msg.GetRestrictions(),
		Supplements:   msg.GetSupplements(),
		Instruction:   msg.GetInstruction(),
		EffectiveFrom: timeOf(msg.GetEffectiveFrom()),
		EffectiveTo:   timeOf(msg.GetEffectiveTo()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&hospitalopsdietv1.PlaceDietOrderResponse{
		Order: orderToWire(order),
	}), nil
}

func (h *Handler) ResolveConflict(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.ResolveConflictRequest]) (
	*connect.Response[hospitalopsdietv1.ResolveConflictResponse], error) {

	msg := req.Msg
	order, err := h.svc.ResolveConflict(ctx, msg.GetOrderId(),
		msg.GetAllergyRef(), msg.GetItem(), msg.GetNote())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&hospitalopsdietv1.ResolveConflictResponse{
		Order: orderToWire(order),
	}), nil
}

func (h *Handler) CancelDietOrder(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.CancelDietOrderRequest]) (
	*connect.Response[hospitalopsdietv1.CancelDietOrderResponse], error) {

	order, err := h.svc.CancelDietOrder(ctx, req.Msg.GetOrderId(),
		req.Msg.GetReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&hospitalopsdietv1.CancelDietOrderResponse{
		Order: orderToWire(order),
	}), nil
}

func (h *Handler) GetCurrentDietOrder(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.GetCurrentDietOrderRequest]) (
	*connect.Response[hospitalopsdietv1.GetCurrentDietOrderResponse],
	error) {

	order, found, err := h.svc.CurrentDietOrder(ctx, req.Msg.GetPatientId())
	if err != nil {
		return nil, err
	}
	response := &hospitalopsdietv1.GetCurrentDietOrderResponse{Found: found}
	if found {
		response.Order = orderToWire(order)
	}
	return connect.NewResponse(response), nil
}

func (h *Handler) ListDietOrders(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.ListDietOrdersRequest]) (
	*connect.Response[hospitalopsdietv1.ListDietOrdersResponse], error) {

	orders, err := h.svc.DietOrders(ctx, req.Msg.GetPatientId())
	if err != nil {
		return nil, err
	}
	out := make([]*hospitalopsdietv1.DietOrder, 0, len(orders))
	for _, order := range orders {
		out = append(out, orderToWire(order))
	}
	return connect.NewResponse(&hospitalopsdietv1.ListDietOrdersResponse{
		Orders: out,
	}), nil
}

// Nutrition support (SRS-DIET-007).

func (h *Handler) PlanNutritionSupport(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.PlanNutritionSupportRequest]) (
	*connect.Response[hospitalopsdietv1.PlanNutritionSupportResponse],
	error) {

	msg := req.Msg
	plan, err := h.svc.PlanNutritionSupport(ctx,
		application.NewSupportPlanInput{
			PatientID:        msg.GetPatientId(),
			EncounterID:      msg.GetEncounterId(),
			Kind:             supportKindFromWire[msg.GetKind()],
			FormulaCode:      msg.GetFormulaCode(),
			FormulaName:      msg.GetFormulaName(),
			TargetVolumeML:   int(msg.GetTargetVolumeMl()),
			TargetEnergyKcal: int(msg.GetTargetEnergyKcal()),
			TargetProteinG:   int(msg.GetTargetProteinG()),
			RampPlan:         msg.GetRampPlan(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(
		&hospitalopsdietv1.PlanNutritionSupportResponse{
			Plan: supportToWire(plan),
		}), nil
}

func (h *Handler) LinkSupportOrder(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.LinkSupportOrderRequest]) (
	*connect.Response[hospitalopsdietv1.LinkSupportOrderResponse], error) {

	plan, err := h.svc.LinkSupportOrder(ctx, req.Msg.GetPlanId(),
		req.Msg.GetOrderRef(), req.Msg.GetOrderContext())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&hospitalopsdietv1.LinkSupportOrderResponse{
		Plan: supportToWire(plan),
	}), nil
}

func (h *Handler) StopSupport(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.StopSupportRequest]) (
	*connect.Response[hospitalopsdietv1.StopSupportResponse], error) {

	plan, err := h.svc.StopSupport(ctx, req.Msg.GetPlanId(),
		req.Msg.GetReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&hospitalopsdietv1.StopSupportResponse{
		Plan: supportToWire(plan),
	}), nil
}

func (h *Handler) ListSupportPlans(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.ListSupportPlansRequest]) (
	*connect.Response[hospitalopsdietv1.ListSupportPlansResponse], error) {

	msg := req.Msg
	plans, err := h.svc.SupportPlans(ctx, ports.SupportFilter{
		PatientID: msg.GetPatientId(), ActiveOnly: msg.GetActiveOnly(),
		Limit: msg.GetPageSize(), Offset: msg.GetPageOffset(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*hospitalopsdietv1.NutritionSupportPlan, 0, len(plans))
	for _, plan := range plans {
		out = append(out, supportToWire(plan))
	}
	return connect.NewResponse(&hospitalopsdietv1.ListSupportPlansResponse{
		Plans: out,
	}), nil
}

// Meal census and trays (SRS-DIET-005, SRS-DIET-006, SRS-DIET-009).

func (h *Handler) BuildCensus(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.BuildCensusRequest]) (
	*connect.Response[hospitalopsdietv1.BuildCensusResponse], error) {

	msg := req.Msg
	census, err := h.svc.BuildCensus(ctx, msg.GetWardId(),
		msg.GetFacilityId(), cycleFromWire[msg.GetCycle()],
		timeOf(msg.GetServiceDate()), timeOf(msg.GetCutoffAt()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&hospitalopsdietv1.BuildCensusResponse{
		Census: censusToWire(census),
	}), nil
}

func (h *Handler) FreezeCensus(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.FreezeCensusRequest]) (
	*connect.Response[hospitalopsdietv1.FreezeCensusResponse], error) {

	census, err := h.svc.FreezeCensus(ctx, req.Msg.GetCensusId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&hospitalopsdietv1.FreezeCensusResponse{
		Census: censusToWire(census),
	}), nil
}

func (h *Handler) ReissueCensus(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.ReissueCensusRequest]) (
	*connect.Response[hospitalopsdietv1.ReissueCensusResponse], error) {

	census, err := h.svc.ReissueCensus(ctx, req.Msg.GetCensusId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&hospitalopsdietv1.ReissueCensusResponse{
		Census: censusToWire(census),
	}), nil
}

func (h *Handler) ListCensuses(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.ListCensusesRequest]) (
	*connect.Response[hospitalopsdietv1.ListCensusesResponse], error) {

	msg := req.Msg
	list, err := h.svc.Censuses(ctx, ports.CensusFilter{
		WardID: msg.GetWardId(), Cycle: cycleFromWire[msg.GetCycle()],
		From: timeOf(msg.GetFrom()), To: timeOf(msg.GetTo()),
		Limit: msg.GetPageSize(), Offset: msg.GetPageOffset(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*hospitalopsdietv1.MealCensus, 0, len(list))
	for _, census := range list {
		out = append(out, censusToWire(census))
	}
	return connect.NewResponse(&hospitalopsdietv1.ListCensusesResponse{
		Censuses: out,
	}), nil
}

func (h *Handler) PlateTrays(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.PlateTraysRequest]) (
	*connect.Response[hospitalopsdietv1.PlateTraysResponse], error) {

	trays, err := h.svc.PlateTrays(ctx, req.Msg.GetCensusId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&hospitalopsdietv1.PlateTraysResponse{
		Trays: traysToWire(trays),
	}), nil
}

func (h *Handler) PrepareTray(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.PrepareTrayRequest]) (
	*connect.Response[hospitalopsdietv1.PrepareTrayResponse], error) {

	tray, err := h.svc.PrepareTray(ctx, req.Msg.GetTrayId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&hospitalopsdietv1.PrepareTrayResponse{
		Tray: trayToWire(tray),
	}), nil
}

func (h *Handler) DispatchTray(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.DispatchTrayRequest]) (
	*connect.Response[hospitalopsdietv1.DispatchTrayResponse], error) {

	tray, err := h.svc.DispatchTray(ctx, req.Msg.GetTrayId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&hospitalopsdietv1.DispatchTrayResponse{
		Tray: trayToWire(tray),
	}), nil
}

func (h *Handler) DeliverTray(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.DeliverTrayRequest]) (
	*connect.Response[hospitalopsdietv1.DeliverTrayResponse], error) {

	tray, err := h.svc.DeliverTray(ctx, req.Msg.GetTrayId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&hospitalopsdietv1.DeliverTrayResponse{
		Tray: trayToWire(tray),
	}), nil
}

func (h *Handler) CloseTray(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.CloseTrayRequest]) (
	*connect.Response[hospitalopsdietv1.CloseTrayResponse], error) {

	tray, err := h.svc.CloseTray(ctx, req.Msg.GetTrayId(),
		trayStateFromWire[req.Msg.GetState()], req.Msg.GetReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&hospitalopsdietv1.CloseTrayResponse{
		Tray: trayToWire(tray),
	}), nil
}

func (h *Handler) ListTrays(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.ListTraysRequest]) (
	*connect.Response[hospitalopsdietv1.ListTraysResponse], error) {

	msg := req.Msg
	trays, err := h.svc.Trays(ctx, ports.TrayFilter{
		CensusID: msg.GetCensusId(), WardID: msg.GetWardId(),
		State: string(trayStateFromWire[msg.GetState()]),
		Limit: msg.GetPageSize(), Offset: msg.GetPageOffset(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&hospitalopsdietv1.ListTraysResponse{
		Trays: traysToWire(trays),
	}), nil
}

func (h *Handler) GetMealOutcome(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.GetMealOutcomeRequest]) (
	*connect.Response[hospitalopsdietv1.GetMealOutcomeResponse], error) {

	outcome, err := h.svc.MealOutcome(ctx, req.Msg.GetCensusId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&hospitalopsdietv1.GetMealOutcomeResponse{
		Outcome: &hospitalopsdietv1.MealOutcome{
			Planned:     int32(outcome.Planned),
			Delivered:   int32(outcome.Delivered),
			Refused:     int32(outcome.Refused),
			Missed:      int32(outcome.Missed),
			Withheld:    int32(outcome.Withheld),
			Late:        int32(outcome.Late),
			Outstanding: int32(outcome.Outstanding),
		},
	}), nil
}

// Kitchen configuration and forecasting (SRS-DIET-003, SRS-DIET-008).

func (h *Handler) ConfigureItem(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.ConfigureItemRequest]) (
	*connect.Response[hospitalopsdietv1.ConfigureItemResponse], error) {

	item := req.Msg.GetItem()
	if err := h.svc.ConfigureItem(ctx, domain.DietItem{
		Code: item.GetCode(), Name: item.GetName(),
		AllergenCodes: item.GetAllergenCodes(),
	}, req.Msg.GetKind()); err != nil {
		return nil, err
	}
	return connect.NewResponse(
		&hospitalopsdietv1.ConfigureItemResponse{}), nil
}

func (h *Handler) ConfigureRecipe(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.ConfigureRecipeRequest]) (
	*connect.Response[hospitalopsdietv1.ConfigureRecipeResponse], error) {

	if err := h.svc.ConfigureRecipe(ctx,
		recipeFromWire(req.Msg.GetRecipe())); err != nil {
		return nil, err
	}
	return connect.NewResponse(
		&hospitalopsdietv1.ConfigureRecipeResponse{}), nil
}

func (h *Handler) ConfigureMenuItem(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.ConfigureMenuItemRequest]) (
	*connect.Response[hospitalopsdietv1.ConfigureMenuItemResponse], error) {

	item := req.Msg.GetItem()
	if err := h.svc.ConfigureMenuItem(ctx, domain.MenuItem{
		Cycle:       cycleFromWire[item.GetCycle()],
		TextureCode: item.GetTextureCode(),
		Recipe:      recipeFromWire(item.GetRecipe()),
		Portions:    int(item.GetPortions()),
	}); err != nil {
		return nil, err
	}
	return connect.NewResponse(
		&hospitalopsdietv1.ConfigureMenuItemResponse{}), nil
}

func (h *Handler) ListMenu(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.ListMenuRequest]) (
	*connect.Response[hospitalopsdietv1.ListMenuResponse], error) {

	items, err := h.svc.Menu(ctx, cycleFromWire[req.Msg.GetCycle()])
	if err != nil {
		return nil, err
	}
	out := make([]*hospitalopsdietv1.MenuItem, 0, len(items))
	for _, item := range items {
		out = append(out, &hospitalopsdietv1.MenuItem{
			Cycle:       cycleToWire[item.Cycle],
			TextureCode: item.TextureCode,
			Recipe:      recipeToWire(item.Recipe),
			Portions:    int32(item.Portions),
		})
	}
	return connect.NewResponse(&hospitalopsdietv1.ListMenuResponse{
		Items: out,
	}), nil
}

func (h *Handler) RecordConsumption(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.RecordConsumptionRequest]) (
	*connect.Response[hospitalopsdietv1.RecordConsumptionResponse], error) {

	msg := req.Msg
	count, err := h.svc.RecordConsumption(ctx, msg.GetCensusId(),
		msg.GetIngredientCode(), int(msg.GetActualG()), msg.GetNote())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(
		&hospitalopsdietv1.RecordConsumptionResponse{
			Counted: &hospitalopsdietv1.IngredientQuantity{
				Code: count.IngredientCode, Grams: int32(count.ActualG),
			},
		}), nil
}

func (h *Handler) GetIngredientForecast(ctx context.Context,
	req *connect.Request[hospitalopsdietv1.GetIngredientForecastRequest]) (
	*connect.Response[hospitalopsdietv1.GetIngredientForecastResponse],
	error) {

	forecast, err := h.svc.IngredientForecast(ctx, req.Msg.GetCensusId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(
		&hospitalopsdietv1.GetIngredientForecastResponse{
			Forecast: forecastToWire(forecast),
		}), nil
}

func traysToWire(trays []domain.Tray) []*hospitalopsdietv1.Tray {
	out := make([]*hospitalopsdietv1.Tray, 0, len(trays))
	for _, tray := range trays {
		out = append(out, trayToWire(tray))
	}
	return out
}

// The handler implements the generated service interface. A compile-time
// assertion rather than a test, because a contract that has drifted from its
// implementation should not build.
var _ hospitalopsdietv1connect.DietServiceHandler = (*Handler)(nil)
