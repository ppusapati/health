package transport

import (
	"context"
	"time"

	"connectrpc.com/connect"

	anaesthesiav1 "github.com/ppusapati/health/code/gen/go/healthcare/anaesthesia/v1"
	"github.com/ppusapati/health/code/internal/anaesthesia/application"
	"github.com/ppusapati/health/code/internal/anaesthesia/domain"
)

// Handler is the anaesthesia ConnectRPC surface.
//
// Thin on purpose: it translates, calls one use case and translates back.
// Every refusal comes from the application or the domain, so the same rule
// holds whichever client asks.
type Handler struct {
	svc *application.Service
	now func() time.Time
}

// NewHandler constructs a Handler.
//
// The clock is injected because a pain plan's overdue state is derived at the
// moment of rendering rather than stored: a plan that became overdue overnight
// must show as overdue on the morning round, not when somebody next writes to
// it.
func NewHandler(svc *application.Service, now func() time.Time) *Handler {
	if now == nil {
		now = time.Now
	}
	return &Handler{svc: svc, now: now}
}

func (h *Handler) RecordAssessment(ctx context.Context,
	req *connect.Request[anaesthesiav1.RecordAssessmentRequest]) (
	*connect.Response[anaesthesiav1.RecordAssessmentResponse], error) {

	msg := req.Msg
	assessment, err := h.svc.RecordAssessment(ctx, domain.NewAssessmentInput{
		CaseID: msg.GetCaseId(), EncounterID: msg.GetEncounterId(),
		PatientID: msg.GetPatientId(), History: msg.GetHistory(),
		Airway:         airwayAssessmentFromProto(msg.GetAirway()),
		ASAGrade:       domain.ASA(msg.GetAsaGrade()),
		Investigations: msg.GetInvestigations(), Risks: msg.GetRisks(),
		Plan: msg.GetPlan(), Consent: consent(msg.GetConsent()),
		ConsentNote: msg.GetConsentNote(), FitToProceed: msg.GetFitToProceed(),
		Conditions: msg.GetConditions(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.RecordAssessmentResponse{
		Assessment: assessmentToProto(assessment),
	}), nil
}

func (h *Handler) ListAssessments(ctx context.Context,
	req *connect.Request[anaesthesiav1.ListAssessmentsRequest]) (
	*connect.Response[anaesthesiav1.ListAssessmentsResponse], error) {

	all, err := h.svc.Assessments(ctx, req.Msg.GetCaseId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.ListAssessmentsResponse{
		Assessments: assessmentsToProto(all),
	}), nil
}

func (h *Handler) ListPatientAssessments(ctx context.Context,
	req *connect.Request[anaesthesiav1.ListPatientAssessmentsRequest]) (
	*connect.Response[anaesthesiav1.ListPatientAssessmentsResponse], error) {

	all, err := h.svc.PatientAssessments(ctx,
		req.Msg.GetPatientId(), req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.ListPatientAssessmentsResponse{
		Assessments: assessmentsToProto(all),
	}), nil
}

func (h *Handler) RecordPlan(ctx context.Context,
	req *connect.Request[anaesthesiav1.RecordPlanRequest]) (
	*connect.Response[anaesthesiav1.RecordPlanResponse], error) {

	msg := req.Msg
	plan, err := h.svc.RecordPlan(ctx, domain.NewPlanInput{
		CaseID: msg.GetCaseId(), Technique: technique(msg.GetTechnique()),
		Agents: msg.GetAgents(), Airway: msg.GetAirway(),
		Monitoring:       msg.GetMonitoring(),
		SpecialEquipment: msg.GetSpecialEquipment(),
		PostOperative:    msg.GetPostOperative(), Notes: msg.GetNotes(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.RecordPlanResponse{
		Plan: planToProto(plan),
	}), nil
}

func (h *Handler) GetPlan(ctx context.Context,
	req *connect.Request[anaesthesiav1.GetPlanRequest]) (
	*connect.Response[anaesthesiav1.GetPlanResponse], error) {

	plan, err := h.svc.Plan(ctx, req.Msg.GetCaseId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.GetPlanResponse{
		Plan: planToProto(plan),
	}), nil
}

func (h *Handler) GetReadiness(ctx context.Context,
	req *connect.Request[anaesthesiav1.GetReadinessRequest]) (
	*connect.Response[anaesthesiav1.GetReadinessResponse], error) {

	readiness, err := h.svc.Readiness(ctx, req.Msg.GetCaseId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.GetReadinessResponse{
		Readiness: readinessToProto(readiness),
	}), nil
}

func (h *Handler) OpenRecord(ctx context.Context,
	req *connect.Request[anaesthesiav1.OpenRecordRequest]) (
	*connect.Response[anaesthesiav1.OpenRecordResponse], error) {

	msg := req.Msg
	record, err := h.svc.OpenRecord(ctx, domain.NewRecordInput{
		CaseID: msg.GetCaseId(), EncounterID: msg.GetEncounterId(),
		PatientID: msg.GetPatientId(), Technique: technique(msg.GetTechnique()),
		StartedAt: timeOf(msg.GetStartedAt()),
		Origin:    source(msg.GetOrigin()), ImportNote: msg.GetImportNote(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.OpenRecordResponse{
		Record: recordToProto(record),
	}), nil
}

func (h *Handler) GetRecord(ctx context.Context,
	req *connect.Request[anaesthesiav1.GetRecordRequest]) (
	*connect.Response[anaesthesiav1.GetRecordResponse], error) {

	record, err := h.svc.Record(ctx, req.Msg.GetRecordId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.GetRecordResponse{
		Record: recordToProto(record),
	}), nil
}

func (h *Handler) GetRecordForCase(ctx context.Context,
	req *connect.Request[anaesthesiav1.GetRecordForCaseRequest]) (
	*connect.Response[anaesthesiav1.GetRecordForCaseResponse], error) {

	record, err := h.svc.RecordForCase(ctx, req.Msg.GetCaseId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.GetRecordForCaseResponse{
		Record: recordToProto(record),
	}), nil
}

func (h *Handler) EndAnaesthesia(ctx context.Context,
	req *connect.Request[anaesthesiav1.EndAnaesthesiaRequest]) (
	*connect.Response[anaesthesiav1.EndAnaesthesiaResponse], error) {

	record, err := h.svc.EndAnaesthesia(ctx,
		req.Msg.GetRecordId(), timeOf(req.Msg.GetEndedAt()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.EndAnaesthesiaResponse{
		Record: recordToProto(record),
	}), nil
}

func (h *Handler) ChartVital(ctx context.Context,
	req *connect.Request[anaesthesiav1.ChartVitalRequest]) (
	*connect.Response[anaesthesiav1.ChartVitalResponse], error) {

	msg := req.Msg
	entry, err := h.svc.ChartVital(ctx, domain.NewVitalInput{
		RecordID: msg.GetRecordId(), Code: msg.GetCode(),
		Display: msg.GetDisplay(), Value: msg.GetValue(), Unit: msg.GetUnit(),
		Source: source(msg.GetSource()), Device: deviceFromProto(msg.GetDevice()),
		ObservedAt: timeOf(msg.GetObservedAt()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.ChartVitalResponse{
		Entry: vitalToProto(entry),
	}), nil
}

func (h *Handler) ListVitals(ctx context.Context,
	req *connect.Request[anaesthesiav1.ListVitalsRequest]) (
	*connect.Response[anaesthesiav1.ListVitalsResponse], error) {

	entries, err := h.svc.Vitals(ctx, req.Msg.GetRecordId(), req.Msg.GetCode())
	if err != nil {
		return nil, err
	}
	out := make([]*anaesthesiav1.VitalEntry, 0, len(entries))
	for _, entry := range entries {
		out = append(out, vitalToProto(entry))
	}
	return connect.NewResponse(&anaesthesiav1.ListVitalsResponse{
		Entries: out,
	}), nil
}

func (h *Handler) ChartDrug(ctx context.Context,
	req *connect.Request[anaesthesiav1.ChartDrugRequest]) (
	*connect.Response[anaesthesiav1.ChartDrugResponse], error) {

	msg := req.Msg
	entry, err := h.svc.ChartDrug(ctx, domain.NewDrugInput{
		RecordID: msg.GetRecordId(), DrugCode: msg.GetDrugCode(),
		DrugDisplay: msg.GetDrugDisplay(), Route: domain.DrugRoute(msg.GetRoute()),
		Dose: msg.GetDose(), DoseUnit: msg.GetDoseUnit(),
		ConcentrationAmount: msg.GetConcentrationAmount(),
		ConcentrationUnit:   msg.GetConcentrationUnit(),
		ConcentrationVolume: msg.GetConcentrationVolume(),
		RateMLPerHour:       msg.GetRateMlPerHour(), Infusion: msg.GetInfusion(),
		Source: source(msg.GetSource()), Device: deviceFromProto(msg.GetDevice()),
		GivenAt: timeOf(msg.GetGivenAt()), Note: msg.GetNote(),
		// The unit check is the domain's: a dose in a unit family the
		// formulary does not dose in is refused unless the anaesthetist says
		// explicitly that they meant it.
		ExpectedUnit:         msg.GetExpectedUnit(),
		AcknowledgedMismatch: msg.GetAcknowledgedMismatch(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.ChartDrugResponse{
		Entry: drugToProto(entry),
	}), nil
}

func (h *Handler) ListDrugs(ctx context.Context,
	req *connect.Request[anaesthesiav1.ListDrugsRequest]) (
	*connect.Response[anaesthesiav1.ListDrugsResponse], error) {

	entries, err := h.svc.Drugs(ctx, req.Msg.GetRecordId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.ListDrugsResponse{
		Entries: drugsToProto(entries),
	}), nil
}

func (h *Handler) StopInfusion(ctx context.Context,
	req *connect.Request[anaesthesiav1.StopInfusionRequest]) (
	*connect.Response[anaesthesiav1.StopInfusionResponse], error) {

	if err := h.svc.StopInfusion(ctx,
		req.Msg.GetDrugId(), timeOf(req.Msg.GetStoppedAt())); err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.StopInfusionResponse{}), nil
}

func (h *Handler) RecordAirway(ctx context.Context,
	req *connect.Request[anaesthesiav1.RecordAirwayRequest]) (
	*connect.Response[anaesthesiav1.RecordAirwayResponse], error) {

	msg := req.Msg
	event, err := h.svc.RecordAirway(ctx, domain.NewAirwayInput{
		RecordID: msg.GetRecordId(), Device: msg.GetDevice(),
		Attempt: int(msg.GetAttempt()), Grade: domain.AirwayGrade(msg.GetGrade()),
		Successful: msg.GetSuccessful(), Difficulty: msg.GetDifficulty(),
		Complications: msg.GetComplications(), Adjuncts: msg.GetAdjuncts(),
		OccurredAt: timeOf(msg.GetOccurredAt()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.RecordAirwayResponse{
		Event: airwayEventToProto(event),
	}), nil
}

func (h *Handler) GetAirway(ctx context.Context,
	req *connect.Request[anaesthesiav1.GetAirwayRequest]) (
	*connect.Response[anaesthesiav1.GetAirwayResponse], error) {

	summary, err := h.svc.Airway(ctx, req.Msg.GetRecordId())
	if err != nil {
		return nil, err
	}
	events, err := h.svc.AirwayEvents(ctx, req.Msg.GetRecordId())
	if err != nil {
		return nil, err
	}
	out := make([]*anaesthesiav1.AirwayEvent, 0, len(events))
	for _, event := range events {
		out = append(out, airwayEventToProto(event))
	}
	return connect.NewResponse(&anaesthesiav1.GetAirwayResponse{
		Airway: difficultAirwayToProto(summary), Events: out,
	}), nil
}

func (h *Handler) GetPatientAirway(ctx context.Context,
	req *connect.Request[anaesthesiav1.GetPatientAirwayRequest]) (
	*connect.Response[anaesthesiav1.GetPatientAirwayResponse], error) {

	summary, err := h.svc.PatientAirway(ctx,
		req.Msg.GetPatientId(), req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.GetPatientAirwayResponse{
		Airway: difficultAirwayToProto(summary),
	}), nil
}

func (h *Handler) ChartFluid(ctx context.Context,
	req *connect.Request[anaesthesiav1.ChartFluidRequest]) (
	*connect.Response[anaesthesiav1.ChartFluidResponse], error) {

	msg := req.Msg
	entry, err := h.svc.ChartFluid(ctx, domain.NewFluidInput{
		RecordID: msg.GetRecordId(), Direction: direction(msg.GetDirection()),
		Kind: msg.GetKind(), Label: msg.GetLabel(), VolumeML: msg.GetVolumeMl(),
		ProductID: msg.GetProductId(), OccurredAt: timeOf(msg.GetOccurredAt()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.ChartFluidResponse{
		Entry: fluidToProto(entry),
	}), nil
}

func (h *Handler) GetBalance(ctx context.Context,
	req *connect.Request[anaesthesiav1.GetBalanceRequest]) (
	*connect.Response[anaesthesiav1.GetBalanceResponse], error) {

	balance, err := h.svc.Balance(ctx, req.Msg.GetRecordId())
	if err != nil {
		return nil, err
	}
	entries, err := h.svc.Fluids(ctx, req.Msg.GetRecordId())
	if err != nil {
		return nil, err
	}
	out := make([]*anaesthesiav1.FluidEntry, 0, len(entries))
	for _, entry := range entries {
		out = append(out, fluidToProto(entry))
	}
	return connect.NewResponse(&anaesthesiav1.GetBalanceResponse{
		Balance: balanceToProto(balance), Entries: out,
	}), nil
}

func (h *Handler) HandOver(ctx context.Context,
	req *connect.Request[anaesthesiav1.HandOverRequest]) (
	*connect.Response[anaesthesiav1.HandOverResponse], error) {

	msg := req.Msg
	handover, err := h.svc.HandOver(ctx, domain.NewHandoverInput{
		RecordID: msg.GetRecordId(), ToClinician: msg.GetToClinician(),
		Summary: msg.GetSummary(), Concerns: msg.GetConcerns(),
		Instructions:   msg.GetInstructions(),
		AnalgesiaGiven: msg.GetAnalgesiaGiven(),
		// What recovery has to know before giving more.
		AntiemeticGiven: msg.GetAntiemeticGiven(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.HandOverResponse{
		Handover: handoverToProto(handover),
	}), nil
}

func (h *Handler) ListHandovers(ctx context.Context,
	req *connect.Request[anaesthesiav1.ListHandoversRequest]) (
	*connect.Response[anaesthesiav1.ListHandoversResponse], error) {

	handovers, err := h.svc.Handovers(ctx, req.Msg.GetRecordId())
	if err != nil {
		return nil, err
	}
	out := make([]*anaesthesiav1.Handover, 0, len(handovers))
	for _, handover := range handovers {
		out = append(out, handoverToProto(handover))
	}
	return connect.NewResponse(&anaesthesiav1.ListHandoversResponse{
		Handovers: out,
	}), nil
}

func (h *Handler) GetRecoveryScale(ctx context.Context,
	_ *connect.Request[anaesthesiav1.GetRecoveryScaleRequest]) (
	*connect.Response[anaesthesiav1.GetRecoveryScaleResponse], error) {

	scale, err := h.svc.Scale(ctx)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.GetRecoveryScaleResponse{
		Scale: scaleToProto(scale),
	}), nil
}

func (h *Handler) AssessRecovery(ctx context.Context,
	req *connect.Request[anaesthesiav1.AssessRecoveryRequest]) (
	*connect.Response[anaesthesiav1.AssessRecoveryResponse], error) {

	assessment, err := h.svc.AssessRecovery(ctx,
		req.Msg.GetRecordId(), scoresFromProto(req.Msg.GetScores()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.AssessRecoveryResponse{
		Assessment: recoveryAssessmentToProto(assessment),
	}), nil
}

func (h *Handler) ListRecoveryAssessments(ctx context.Context,
	req *connect.Request[anaesthesiav1.ListRecoveryAssessmentsRequest]) (
	*connect.Response[anaesthesiav1.ListRecoveryAssessmentsResponse], error) {

	all, err := h.svc.RecoveryAssessments(ctx, req.Msg.GetRecordId())
	if err != nil {
		return nil, err
	}
	out := make([]*anaesthesiav1.RecoveryAssessment, 0, len(all))
	for _, assessment := range all {
		out = append(out, recoveryAssessmentToProto(assessment))
	}
	return connect.NewResponse(&anaesthesiav1.ListRecoveryAssessmentsResponse{
		Assessments: out,
	}), nil
}

func (h *Handler) EvaluateDischarge(ctx context.Context,
	req *connect.Request[anaesthesiav1.EvaluateDischargeRequest]) (
	*connect.Response[anaesthesiav1.EvaluateDischargeResponse], error) {

	decision, err := h.svc.EvaluateDischarge(ctx, req.Msg.GetRecordId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.EvaluateDischargeResponse{
		Decision: decisionToProto(decision),
	}), nil
}

func (h *Handler) DischargeFromRecovery(ctx context.Context,
	req *connect.Request[anaesthesiav1.DischargeFromRecoveryRequest]) (
	*connect.Response[anaesthesiav1.DischargeFromRecoveryResponse], error) {

	discharge, err := h.svc.DischargeFromRecovery(ctx, req.Msg.GetRecordId(),
		req.Msg.GetDestination(), req.Msg.GetOverrideReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.DischargeFromRecoveryResponse{
		Discharge: dischargeToProto(discharge),
	}), nil
}

func (h *Handler) OrderPain(ctx context.Context,
	req *connect.Request[anaesthesiav1.OrderPainRequest]) (
	*connect.Response[anaesthesiav1.OrderPainResponse], error) {

	msg := req.Msg
	order, err := h.svc.OrderPain(ctx, domain.NewPainOrderInput{
		RecordID: msg.GetRecordId(), Modality: msg.GetModality(),
		// Names the prescriptions rather than being one.
		PrescriptionIDs: msg.GetPrescriptionIds(),
		TargetScore:     msg.GetTargetScore(),
		Monitoring:      msg.GetMonitoring(), Escalation: msg.GetEscalation(),
		ReviewBy: timeOf(msg.GetReviewBy()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.OrderPainResponse{
		Order: painOrderToProto(order, h.now()),
	}), nil
}

func (h *Handler) ListPainOrders(ctx context.Context,
	req *connect.Request[anaesthesiav1.ListPainOrdersRequest]) (
	*connect.Response[anaesthesiav1.ListPainOrdersResponse], error) {

	orders, err := h.svc.PainOrders(ctx, req.Msg.GetRecordId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.ListPainOrdersResponse{
		Orders: painOrdersToProto(orders, h.now()),
	}), nil
}

func (h *Handler) GetPainRound(ctx context.Context,
	req *connect.Request[anaesthesiav1.GetPainRoundRequest]) (
	*connect.Response[anaesthesiav1.GetPainRoundResponse], error) {

	orders, err := h.svc.PainRound(ctx, req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.GetPainRoundResponse{
		Orders: painOrdersToProto(orders, h.now()),
	}), nil
}

func (h *Handler) StopPain(ctx context.Context,
	req *connect.Request[anaesthesiav1.StopPainRequest]) (
	*connect.Response[anaesthesiav1.StopPainResponse], error) {

	if err := h.svc.StopPain(ctx,
		req.Msg.GetOrderId(), timeOf(req.Msg.GetStoppedAt())); err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.StopPainResponse{}), nil
}

func (h *Handler) GetSummary(ctx context.Context,
	req *connect.Request[anaesthesiav1.GetSummaryRequest]) (
	*connect.Response[anaesthesiav1.GetSummaryResponse], error) {

	summary, err := h.svc.Summary(ctx, req.Msg.GetRecordId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&anaesthesiav1.GetSummaryResponse{
		Summary: summaryToProto(summary),
	}), nil
}
