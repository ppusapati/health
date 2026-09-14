package transport

import (
	"context"
	"time"

	"connectrpc.com/connect"
	nursingv1 "github.com/ppusapati/health/code/gen/go/healthcare/nursing/v1"
	"github.com/ppusapati/health/code/internal/nursing/application"
	"github.com/ppusapati/health/code/internal/nursing/domain"
	"github.com/ppusapati/health/code/internal/nursing/ports"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
)

// Handler serves healthcare.nursing.v1.NursingService.
type Handler struct {
	svc   *application.Service
	clock func() time.Time
}

// NewHandler constructs the handler.
//
// The clock is here only to render the derived "overdue" and
// "authorization expired" flags at the moment of the response; every stored
// time comes from the application layer's clock.
func NewHandler(svc *application.Service, clock func() time.Time) *Handler {
	if clock == nil {
		clock = time.Now
	}
	return &Handler{svc: svc, clock: clock}
}

func fail(ctx context.Context, err error) error {
	return platformtransport.ToConnect(err,
		platformtransport.CorrelationIDFromContext(ctx))
}

// ChartObservation implements SRS-NUR-003.
func (h *Handler) ChartObservation(
	ctx context.Context,
	req *connect.Request[nursingv1.ChartObservationRequest],
) (*connect.Response[nursingv1.ChartObservationResponse], error) {
	msg := req.Msg

	entry, err := h.svc.Chart(ctx, application.ChartInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		Code: codingFromProto(msg.GetCode()), Value: quantityFromProto(msg.GetValue()),
		TextValue: msg.GetTextValue(), CodedValue: codingFromProto(msg.GetCodedValue()),
		// Supplied by the nurse, never defaulted: defaulting it is the failure
		// SRS-NUR-003 exists to prevent, and it fails silently.
		ObservedAt:      goTime(msg.GetObservedAt()),
		Source:          entrySourceFromProto[msg.GetSource()],
		DeviceID:        msg.GetDeviceId(),
		LateEntryReason: msg.GetLateEntryReason(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.ChartObservationResponse{
		Entry: flowsheetEntryToProto(entry),
	}), nil
}

// GetFlowsheet implements SRS-NUR-003.
func (h *Handler) GetFlowsheet(
	ctx context.Context,
	req *connect.Request[nursingv1.GetFlowsheetRequest],
) (*connect.Response[nursingv1.GetFlowsheetResponse], error) {
	msg := req.Msg

	entries, err := h.svc.Flowsheet(ctx, msg.GetEncounterId(), msg.GetPatientId(),
		msg.GetCode(), goTime(msg.GetObservedFrom()), goTime(msg.GetObservedTo()),
		msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*nursingv1.FlowsheetEntry, 0, len(entries))
	for _, e := range entries {
		out = append(out, flowsheetEntryToProto(e))
	}
	return connect.NewResponse(&nursingv1.GetFlowsheetResponse{Entries: out}), nil
}

// RecordFluid implements SRS-NUR-004.
func (h *Handler) RecordFluid(
	ctx context.Context,
	req *connect.Request[nursingv1.RecordFluidRequest],
) (*connect.Response[nursingv1.RecordFluidResponse], error) {
	msg := req.Msg

	entry, err := h.svc.RecordFluid(ctx, application.RecordFluidInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		Direction: fluidDirectionFromProto[msg.GetDirection()],
		Category:  msg.GetCategory(), VolumeML: msg.GetVolumeMl(),
		ObservedAt: goTime(msg.GetObservedAt()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.RecordFluidResponse{
		Entry: fluidEntryToProto(entry),
	}), nil
}

// CorrectFluid implements SRS-NUR-004's amendment trail.
func (h *Handler) CorrectFluid(
	ctx context.Context,
	req *connect.Request[nursingv1.CorrectFluidRequest],
) (*connect.Response[nursingv1.CorrectFluidResponse], error) {
	msg := req.Msg

	correction, err := h.svc.CorrectFluid(ctx, msg.GetFluidId(),
		msg.GetVolumeMl(), msg.GetReason())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.CorrectFluidResponse{
		Correction: fluidEntryToProto(correction),
	}), nil
}

// GetFluidBalance implements SRS-NUR-004.
func (h *Handler) GetFluidBalance(
	ctx context.Context,
	req *connect.Request[nursingv1.GetFluidBalanceRequest],
) (*connect.Response[nursingv1.GetFluidBalanceResponse], error) {
	msg := req.Msg

	balance, err := h.svc.Balance(ctx, msg.GetEncounterId(), msg.GetPatientId(),
		goTime(msg.GetFrom()), goTime(msg.GetTo()))
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.GetFluidBalanceResponse{
		Balance: balanceToProto(balance),
	}), nil
}

// GetFluidTrail returns the amendment history, superseded entries included.
func (h *Handler) GetFluidTrail(
	ctx context.Context,
	req *connect.Request[nursingv1.GetFluidTrailRequest],
) (*connect.Response[nursingv1.GetFluidTrailResponse], error) {
	msg := req.Msg

	entries, err := h.svc.FluidTrail(ctx, msg.GetEncounterId(),
		msg.GetPatientId(), goTime(msg.GetFrom()), goTime(msg.GetTo()),
		msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*nursingv1.FluidEntry, 0, len(entries))
	for _, e := range entries {
		out = append(out, fluidEntryToProto(e))
	}
	return connect.NewResponse(&nursingv1.GetFluidTrailResponse{Entries: out}), nil
}

// DefineAssessmentTemplate implements SRS-NUR-001.
func (h *Handler) DefineAssessmentTemplate(
	ctx context.Context,
	req *connect.Request[nursingv1.DefineAssessmentTemplateRequest],
) (*connect.Response[nursingv1.DefineAssessmentTemplateResponse], error) {
	template, err := h.svc.DefineAssessmentTemplate(ctx,
		templateFromProto(req.Msg.GetTemplate()))
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.DefineAssessmentTemplateResponse{
		Template: templateToProto(template),
	}), nil
}

// ListAssessmentTemplates implements SRS-NUR-001.
func (h *Handler) ListAssessmentTemplates(
	ctx context.Context,
	req *connect.Request[nursingv1.ListAssessmentTemplatesRequest],
) (*connect.Response[nursingv1.ListAssessmentTemplatesResponse], error) {
	msg := req.Msg

	templates, err := h.svc.ListAssessmentTemplates(ctx, msg.GetServiceCode(),
		msg.GetIncludeRetired(), msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*nursingv1.AssessmentTemplate, 0, len(templates))
	for _, t := range templates {
		out = append(out, templateToProto(t))
	}
	return connect.NewResponse(&nursingv1.ListAssessmentTemplatesResponse{
		Templates: out,
	}), nil
}

// RetireAssessmentTemplate withdraws a template from new assessments.
func (h *Handler) RetireAssessmentTemplate(
	ctx context.Context,
	req *connect.Request[nursingv1.RetireAssessmentTemplateRequest],
) (*connect.Response[nursingv1.RetireAssessmentTemplateResponse], error) {
	if err := h.svc.RetireAssessmentTemplate(ctx, req.Msg.GetTemplateId(),
		req.Msg.GetVersion()); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.RetireAssessmentTemplateResponse{}), nil
}

// RecordAssessment implements SRS-NUR-001.
func (h *Handler) RecordAssessment(
	ctx context.Context,
	req *connect.Request[nursingv1.RecordAssessmentRequest],
) (*connect.Response[nursingv1.RecordAssessmentResponse], error) {
	msg := req.Msg

	assessment, err := h.svc.Assess(ctx, application.AssessInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		Kind:       assessmentKindFromProto[msg.GetKind()],
		TemplateID: msg.GetTemplateId(), TemplateVersion: msg.GetTemplateVersion(),
		Answers:    answersFromProto(msg.GetAnswers()),
		AssessedAt: goTime(msg.GetAssessedAt()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.RecordAssessmentResponse{
		Assessment: assessmentToProto(assessment),
	}), nil
}

// ListAssessments reads an encounter's assessments.
func (h *Handler) ListAssessments(
	ctx context.Context,
	req *connect.Request[nursingv1.ListAssessmentsRequest],
) (*connect.Response[nursingv1.ListAssessmentsResponse], error) {
	msg := req.Msg

	assessments, err := h.svc.ListAssessments(ctx, msg.GetEncounterId(),
		msg.GetPatientId(), assessmentKindFromProto[msg.GetKind()],
		msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*nursingv1.Assessment, 0, len(assessments))
	for _, a := range assessments {
		out = append(out, assessmentToProto(a))
	}
	return connect.NewResponse(&nursingv1.ListAssessmentsResponse{
		Assessments: out,
	}), nil
}

// DefineRiskScale implements SRS-NUR-005.
func (h *Handler) DefineRiskScale(
	ctx context.Context,
	req *connect.Request[nursingv1.DefineRiskScaleRequest],
) (*connect.Response[nursingv1.DefineRiskScaleResponse], error) {
	scale, err := h.svc.DefineRiskScale(ctx, riskScaleFromProto(req.Msg.GetScale()))
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.DefineRiskScaleResponse{
		Scale: riskScaleToProto(scale),
	}), nil
}

// ScoreRisk implements SRS-NUR-005.
func (h *Handler) ScoreRisk(
	ctx context.Context,
	req *connect.Request[nursingv1.ScoreRiskRequest],
) (*connect.Response[nursingv1.ScoreRiskResponse], error) {
	msg := req.Msg

	assessment, err := h.svc.ScoreRisk(ctx, application.ScoreRiskInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		ScaleID: msg.GetScaleId(), ScaleVersion: msg.GetScaleVersion(),
		Inputs: msg.GetInputs(), AssessedAt: goTime(msg.GetAssessedAt()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.ScoreRiskResponse{
		Assessment: riskAssessmentToProto(assessment),
	}), nil
}

// ListRiskAssessments reads a patient's scores.
func (h *Handler) ListRiskAssessments(
	ctx context.Context,
	req *connect.Request[nursingv1.ListRiskAssessmentsRequest],
) (*connect.Response[nursingv1.ListRiskAssessmentsResponse], error) {
	msg := req.Msg

	assessments, err := h.svc.ListRiskAssessments(ctx, msg.GetPatientId(),
		riskDomainFromProto[msg.GetDomain()], msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*nursingv1.RiskAssessment, 0, len(assessments))
	for _, a := range assessments {
		out = append(out, riskAssessmentToProto(a))
	}
	return connect.NewResponse(&nursingv1.ListRiskAssessmentsResponse{
		Assessments: out,
	}), nil
}

// ListDueReassessments implements SRS-NUR-005's due-reassessment work.
func (h *Handler) ListDueReassessments(
	ctx context.Context,
	req *connect.Request[nursingv1.ListDueReassessmentsRequest],
) (*connect.Response[nursingv1.ListDueReassessmentsResponse], error) {
	assessments, err := h.svc.DueReassessments(ctx, req.Msg.GetEncounterId(),
		req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*nursingv1.RiskAssessment, 0, len(assessments))
	for _, a := range assessments {
		out = append(out, riskAssessmentToProto(a))
	}
	return connect.NewResponse(&nursingv1.ListDueReassessmentsResponse{
		Assessments: out,
	}), nil
}

// InsertDevice implements SRS-NUR-006.
func (h *Handler) InsertDevice(
	ctx context.Context,
	req *connect.Request[nursingv1.InsertDeviceRequest],
) (*connect.Response[nursingv1.InsertDeviceResponse], error) {
	msg := req.Msg

	device, err := h.svc.InsertDevice(ctx, application.InsertDeviceInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		Kind: deviceKindFromProto[msg.GetKind()], Site: msg.GetSite(),
		Laterality: lateralityFromProto[msg.GetLaterality()],
		Size:       msg.GetSize(), Lot: msg.GetLot(),
		InsertedAt: goTime(msg.GetInsertedAt()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.InsertDeviceResponse{
		Device: deviceToProto(device, h.clock()),
	}), nil
}

// RemoveDevice implements SRS-NUR-006.
func (h *Handler) RemoveDevice(
	ctx context.Context,
	req *connect.Request[nursingv1.RemoveDeviceRequest],
) (*connect.Response[nursingv1.RemoveDeviceResponse], error) {
	msg := req.Msg

	device, err := h.svc.RemoveDevice(ctx, msg.GetDeviceId(),
		goTime(msg.GetRemovedAt()), msg.GetReason())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.RemoveDeviceResponse{
		Device: deviceToProto(device, h.clock()),
	}), nil
}

// RecordDeviceCare records looking after a device.
func (h *Handler) RecordDeviceCare(
	ctx context.Context,
	req *connect.Request[nursingv1.RecordDeviceCareRequest],
) (*connect.Response[nursingv1.RecordDeviceCareResponse], error) {
	msg := req.Msg

	if err := h.svc.RecordDeviceCare(ctx, msg.GetDeviceId(), domain.DeviceCare{
		Kind: msg.GetKind(), Finding: msg.GetFinding(),
		OutputML: msg.GetOutputMl(), PerformedAt: goTime(msg.GetPerformedAt()),
	}); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.RecordDeviceCareResponse{}), nil
}

// ListDevices returns devices with their device-day counts (SRS-NUR-006).
func (h *Handler) ListDevices(
	ctx context.Context,
	req *connect.Request[nursingv1.ListDevicesRequest],
) (*connect.Response[nursingv1.ListDevicesResponse], error) {
	msg := req.Msg

	reports, err := h.svc.Devices(ctx, msg.GetEncounterId(), msg.GetPatientId(),
		msg.GetInPlaceOnly(), msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*nursingv1.Device, 0, len(reports))
	for _, r := range reports {
		out = append(out, deviceReportToProto(r))
	}
	return connect.NewResponse(&nursingv1.ListDevicesResponse{Devices: out}), nil
}

// GetMedicationRound implements SRS-NUR-007.
func (h *Handler) GetMedicationRound(
	ctx context.Context,
	req *connect.Request[nursingv1.GetMedicationRoundRequest],
) (*connect.Response[nursingv1.GetMedicationRoundResponse], error) {
	msg := req.Msg

	round, err := h.svc.Round(ctx, application.RoundInput{
		EncounterID: msg.GetEncounterId(), PatientID: msg.GetPatientId(),
		FacilityID: msg.GetFacilityId(),
		From:       goTime(msg.GetFrom()), To: goTime(msg.GetTo()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}

	now := h.clock()
	doses := make([]*nursingv1.DueDose, 0, len(round.Doses))
	for _, d := range round.Doses {
		doses = append(doses, &nursingv1.DueDose{
			Order: orderToProto(d.Order), ScheduledAt: ts(d.ScheduledAt),
			// What has already been given: a round that does not show this
			// invites the dose being given twice.
			Given:       administrationToProto(d.Given, round.Policy),
			Outstanding: d.Outstanding(),
			Overdue:     d.Overdue(round.Policy, now),
		})
	}
	return connect.NewResponse(&nursingv1.GetMedicationRoundResponse{
		Doses: doses, Policy: policyToProto(round.Policy),
	}), nil
}

// Administer implements SRS-NUR-008 and SRS-NUR-009.
func (h *Handler) Administer(
	ctx context.Context,
	req *connect.Request[nursingv1.AdministerRequest],
) (*connect.Response[nursingv1.AdministerResponse], error) {
	msg := req.Msg

	administration, err := h.svc.Administer(ctx, application.AdministerInput{
		OrderID: msg.GetOrderId(), FacilityID: msg.GetFacilityId(),
		// Scheduled and actual travel separately, which is what makes "was it
		// late" answerable (SRS-NUR-009).
		ScheduledAt: goTime(msg.GetScheduledAt()),
		GivenDose:   quantityFromProto(msg.GetGivenDose()),
		GivenAt:     goTime(msg.GetGivenAt()),
		Route:       msg.GetRoute(), Site: msg.GetSite(),
		Outcome: outcomeFromProto[msg.GetOutcome()], Reason: msg.GetReason(),
		Verification:   verificationFromProto(msg.GetVerification()),
		OverrideReason: msg.GetOverrideReason(),
		WitnessedBy:    msg.GetWitnessedBy(),
		IdempotencyKey: msg.GetIdempotencyKey(),
		Offline:        msg.GetOffline(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.AdministerResponse{
		Administration: administrationToProto(administration,
			domain.DefaultAdministrationPolicy()),
	}), nil
}

// ListAdministrations reads the MAR for an encounter.
func (h *Handler) ListAdministrations(
	ctx context.Context,
	req *connect.Request[nursingv1.ListAdministrationsRequest],
) (*connect.Response[nursingv1.ListAdministrationsResponse], error) {
	msg := req.Msg

	administrations, err := h.svc.ListAdministrations(ctx, msg.GetEncounterId(),
		msg.GetPatientId(), msg.GetOrderId(), msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	policy := domain.DefaultAdministrationPolicy()
	out := make([]*nursingv1.Administration, 0, len(administrations))
	for _, a := range administrations {
		out = append(out, administrationToProto(a, policy))
	}
	return connect.NewResponse(&nursingv1.ListAdministrationsResponse{
		Administrations: out,
	}), nil
}

// GetOverrideReport implements SRS-NUR-008's reportable override.
func (h *Handler) GetOverrideReport(
	ctx context.Context,
	req *connect.Request[nursingv1.GetOverrideReportRequest],
) (*connect.Response[nursingv1.GetOverrideReportResponse], error) {
	msg := req.Msg

	administrations, err := h.svc.OverrideReport(ctx, goTime(msg.GetFrom()),
		goTime(msg.GetTo()), msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	policy := domain.DefaultAdministrationPolicy()
	out := make([]*nursingv1.Administration, 0, len(administrations))
	for _, a := range administrations {
		out = append(out, administrationToProto(a, policy))
	}
	return connect.NewResponse(&nursingv1.GetOverrideReportResponse{
		Administrations: out,
	}), nil
}

// SetAdministrationPolicy configures a facility's barcode rules.
func (h *Handler) SetAdministrationPolicy(
	ctx context.Context,
	req *connect.Request[nursingv1.SetAdministrationPolicyRequest],
) (*connect.Response[nursingv1.SetAdministrationPolicyResponse], error) {
	if err := h.svc.SetAdministrationPolicy(ctx, req.Msg.GetFacilityId(),
		policyFromProto(req.Msg.GetPolicy())); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.SetAdministrationPolicyResponse{}), nil
}

// CreateCarePlan implements SRS-NUR-002.
func (h *Handler) CreateCarePlan(
	ctx context.Context,
	req *connect.Request[nursingv1.CreateCarePlanRequest],
) (*connect.Response[nursingv1.CreateCarePlanResponse], error) {
	msg := req.Msg

	plan, err := h.svc.CreateCarePlan(ctx, domain.NewCarePlanInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		Title: msg.GetTitle(), Problems: planProblemsFromProto(msg.GetProblems()),
	}, goTime(msg.GetScheduleUntil()))
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.CreateCarePlanResponse{
		Plan: carePlanToProto(plan),
	}), nil
}

// ReviewCarePlan implements SRS-NUR-002's evaluation.
func (h *Handler) ReviewCarePlan(
	ctx context.Context,
	req *connect.Request[nursingv1.ReviewCarePlanRequest],
) (*connect.Response[nursingv1.ReviewCarePlanResponse], error) {
	plan, err := h.svc.ReviewCarePlan(ctx, req.Msg.GetPlanId(),
		req.Msg.GetEvaluation())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.ReviewCarePlanResponse{
		Plan: carePlanToProto(plan),
	}), nil
}

// ListCarePlans reads an encounter's plans.
func (h *Handler) ListCarePlans(
	ctx context.Context,
	req *connect.Request[nursingv1.ListCarePlansRequest],
) (*connect.Response[nursingv1.ListCarePlansResponse], error) {
	msg := req.Msg

	plans, err := h.svc.ListCarePlans(ctx, msg.GetEncounterId(),
		msg.GetPatientId(), msg.GetActiveOnly(), msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*nursingv1.CarePlan, 0, len(plans))
	for _, p := range plans {
		out = append(out, carePlanToProto(p))
	}
	return connect.NewResponse(&nursingv1.ListCarePlansResponse{Plans: out}), nil
}

// CreateTask implements SRS-NUR-011.
func (h *Handler) CreateTask(
	ctx context.Context,
	req *connect.Request[nursingv1.CreateTaskRequest],
) (*connect.Response[nursingv1.CreateTaskResponse], error) {
	msg := req.Msg

	task, err := h.svc.CreateTask(ctx, domain.NewTaskInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		Description: msg.GetDescription(),
		Priority:    priorityFromProto[msg.GetPriority()],
		DueAt:       goTime(msg.GetDueAt()),
		RecurEvery:  time.Duration(msg.GetRecurEverySeconds()) * time.Second,
		RecurUntil:  goTime(msg.GetRecurUntil()),
		AssignedTo:  msg.GetAssignedTo(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.CreateTaskResponse{
		Task: taskToProto(task, h.clock()),
	}), nil
}

// CompleteTask implements SRS-NUR-011's completion evidence and recurrence.
func (h *Handler) CompleteTask(
	ctx context.Context,
	req *connect.Request[nursingv1.CompleteTaskRequest],
) (*connect.Response[nursingv1.CompleteTaskResponse], error) {
	next, err := h.svc.CompleteTask(ctx, req.Msg.GetTaskId(),
		req.Msg.GetEvidence())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.CompleteTaskResponse{
		Next: taskToProto(next, h.clock()),
	}), nil
}

// SkipTask records a deliberate omission.
func (h *Handler) SkipTask(
	ctx context.Context,
	req *connect.Request[nursingv1.SkipTaskRequest],
) (*connect.Response[nursingv1.SkipTaskResponse], error) {
	if err := h.svc.SkipTask(ctx, req.Msg.GetTaskId(),
		req.Msg.GetReason()); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.SkipTaskResponse{}), nil
}

// GetWorklist implements SRS-NUR-011.
func (h *Handler) GetWorklist(
	ctx context.Context,
	req *connect.Request[nursingv1.GetWorklistRequest],
) (*connect.Response[nursingv1.GetWorklistResponse], error) {
	msg := req.Msg

	tasks, err := h.svc.Worklist(ctx, ports.WorklistQuery{
		EncounterID: msg.GetEncounterId(), AssignedTo: msg.GetAssignedTo(),
		PendingOnly: msg.GetPendingOnly(), Limit: msg.GetPageSize(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	now := h.clock()
	out := make([]*nursingv1.NursingTask, 0, len(tasks))
	for _, t := range tasks {
		out = append(out, taskToProto(t, now))
	}
	return connect.NewResponse(&nursingv1.GetWorklistResponse{Tasks: out}), nil
}

// EscalateOverdueWork implements SRS-NUR-011's escalation.
func (h *Handler) EscalateOverdueWork(
	ctx context.Context,
	req *connect.Request[nursingv1.EscalateOverdueWorkRequest],
) (*connect.Response[nursingv1.EscalateOverdueWorkResponse], error) {
	tasks, err := h.svc.EscalateOverdueWork(ctx, req.Msg.GetEscalateTo(),
		req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	now := h.clock()
	out := make([]*nursingv1.NursingTask, 0, len(tasks))
	for _, t := range tasks {
		out = append(out, taskToProto(t, now))
	}
	return connect.NewResponse(&nursingv1.EscalateOverdueWorkResponse{
		Escalated: out,
	}), nil
}

// ComposeHandover implements SRS-NUR-010.
func (h *Handler) ComposeHandover(
	ctx context.Context,
	req *connect.Request[nursingv1.ComposeHandoverRequest],
) (*connect.Response[nursingv1.ComposeHandoverResponse], error) {
	msg := req.Msg

	handover, err := h.svc.ComposeHandover(ctx, domain.NewHandoverInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		UnitID:    msg.GetUnitId(),
		FromShift: shiftFromProto(msg.GetFromShift()),
		ToShift:   shiftFromProto(msg.GetToShift()),
		Situation: msg.GetSituation(), Background: msg.GetBackground(),
		Assessment: msg.GetAssessment(), Recommendation: msg.GetRecommendation(),
		CriticalRisks:    msg.GetCriticalRisks(),
		OutstandingIssue: msg.GetOutstanding(),
		// Devices and pending tasks are not taken from the request: the server
		// captures them, so a handover cannot quietly omit the line that has
		// been in for nine days.
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.ComposeHandoverResponse{
		Handover: handoverToProto(handover),
	}), nil
}

// AcknowledgeHandover implements SRS-NUR-010's acceptance.
func (h *Handler) AcknowledgeHandover(
	ctx context.Context,
	req *connect.Request[nursingv1.AcknowledgeHandoverRequest],
) (*connect.Response[nursingv1.AcknowledgeHandoverResponse], error) {
	handover, err := h.svc.AcknowledgeHandover(ctx, req.Msg.GetHandoverId(),
		req.Msg.GetQuestions())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.AcknowledgeHandoverResponse{
		Handover: handoverToProto(handover),
	}), nil
}

// ListHandovers reads handovers, optionally only the unaccepted ones.
func (h *Handler) ListHandovers(
	ctx context.Context,
	req *connect.Request[nursingv1.ListHandoversRequest],
) (*connect.Response[nursingv1.ListHandoversResponse], error) {
	msg := req.Msg

	handovers, err := h.svc.ListHandovers(ctx, msg.GetEncounterId(),
		msg.GetUnacknowledgedOnly(), msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*nursingv1.Handover, 0, len(handovers))
	for _, handover := range handovers {
		out = append(out, handoverToProto(handover))
	}
	return connect.NewResponse(&nursingv1.ListHandoversResponse{
		Handovers: out,
	}), nil
}

// ApplyRestraint implements SRS-NUR-013.
func (h *Handler) ApplyRestraint(
	ctx context.Context,
	req *connect.Request[nursingv1.ApplyRestraintRequest],
) (*connect.Response[nursingv1.ApplyRestraintResponse], error) {
	msg := req.Msg

	restraint, err := h.svc.ApplyRestraint(ctx, domain.NewRestraintInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		Kind:          restraintKindFromProto[msg.GetKind()],
		Description:   msg.GetDescription(),
		Authorization: authorizationFromProto(msg.GetAuthorization()),
		StartedAt:     goTime(msg.GetStartedAt()),
		MonitorEvery:  time.Duration(msg.GetMonitorEverySeconds()) * time.Second,
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.ApplyRestraintResponse{
		Restraint: restraintToProto(restraint, h.clock()),
	}), nil
}

// RenewRestraint implements SRS-NUR-013.
func (h *Handler) RenewRestraint(
	ctx context.Context,
	req *connect.Request[nursingv1.RenewRestraintRequest],
) (*connect.Response[nursingv1.RenewRestraintResponse], error) {
	restraint, err := h.svc.RenewRestraint(ctx, req.Msg.GetRestraintId(),
		authorizationFromProto(req.Msg.GetAuthorization()))
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.RenewRestraintResponse{
		Restraint: restraintToProto(restraint, h.clock()),
	}), nil
}

// CheckRestraint records an observation of a restrained patient.
func (h *Handler) CheckRestraint(
	ctx context.Context,
	req *connect.Request[nursingv1.CheckRestraintRequest],
) (*connect.Response[nursingv1.CheckRestraintResponse], error) {
	msg := req.Msg

	if err := h.svc.CheckRestraint(ctx, msg.GetRestraintId(),
		domain.RestraintCheck{
			ObservedAt: goTime(msg.GetObservedAt()),
			Findings:   msg.GetFindings(),
			// Required: a check that never asks whether the restraint is still
			// needed keeps patients restrained.
			ContinuedReason: msg.GetContinuedReason(),
		}); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.CheckRestraintResponse{}), nil
}

// DiscontinueRestraint ends a restraint episode.
func (h *Handler) DiscontinueRestraint(
	ctx context.Context,
	req *connect.Request[nursingv1.DiscontinueRestraintRequest],
) (*connect.Response[nursingv1.DiscontinueRestraintResponse], error) {
	msg := req.Msg

	restraint, err := h.svc.DiscontinueRestraint(ctx, msg.GetRestraintId(),
		goTime(msg.GetDiscontinuedAt()), msg.GetReason())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.DiscontinueRestraintResponse{
		Restraint: restraintToProto(restraint, h.clock()),
	}), nil
}

// ListRestraints reads an encounter's restraint episodes.
func (h *Handler) ListRestraints(
	ctx context.Context,
	req *connect.Request[nursingv1.ListRestraintsRequest],
) (*connect.Response[nursingv1.ListRestraintsResponse], error) {
	msg := req.Msg

	restraints, err := h.svc.ListRestraints(ctx, msg.GetEncounterId(),
		msg.GetActiveOnly(), msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	now := h.clock()
	out := make([]*nursingv1.Restraint, 0, len(restraints))
	for _, r := range restraints {
		out = append(out, restraintToProto(r, now))
	}
	return connect.NewResponse(&nursingv1.ListRestraintsResponse{
		Restraints: out,
	}), nil
}

// GetRestraintAlerts implements SRS-NUR-013's expiry alert.
func (h *Handler) GetRestraintAlerts(
	ctx context.Context,
	req *connect.Request[nursingv1.GetRestraintAlertsRequest],
) (*connect.Response[nursingv1.GetRestraintAlertsResponse], error) {
	alerts, err := h.svc.RestraintAlerts(ctx, req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	now := h.clock()
	out := make([]*nursingv1.Restraint, 0, len(alerts))
	for _, a := range alerts {
		out = append(out, restraintToProto(a.Restraint, now))
	}
	return connect.NewResponse(&nursingv1.GetRestraintAlertsResponse{
		Restraints: out,
	}), nil
}

// StartTransfusion implements SRS-NUR-014.
func (h *Handler) StartTransfusion(
	ctx context.Context,
	req *connect.Request[nursingv1.StartTransfusionRequest],
) (*connect.Response[nursingv1.StartTransfusionResponse], error) {
	msg := req.Msg

	transfusion, err := h.svc.StartTransfusion(ctx, domain.NewTransfusionInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		UnitNumber: msg.GetUnitNumber(), Product: codingFromProto(msg.GetProduct()),
		ABOGroup: msg.GetAboGroup(), RhD: msg.GetRhd(),
		VolumeML: msg.GetVolumeMl(), StartedAt: goTime(msg.GetStartedAt()),
		CheckedBy: msg.GetCheckedBy(),
		Baseline:  transfusionObservationFromProto(msg.GetBaseline()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.StartTransfusionResponse{
		Transfusion: transfusionToProto(transfusion),
	}), nil
}

// ObserveTransfusion records a monitoring set.
func (h *Handler) ObserveTransfusion(
	ctx context.Context,
	req *connect.Request[nursingv1.ObserveTransfusionRequest],
) (*connect.Response[nursingv1.ObserveTransfusionResponse], error) {
	transfusion, err := h.svc.ObserveTransfusion(ctx,
		req.Msg.GetTransfusionId(),
		transfusionObservationFromProto(req.Msg.GetObservation()))
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.ObserveTransfusionResponse{
		Transfusion: transfusionToProto(transfusion),
	}), nil
}

// ReportTransfusionReaction stops the transfusion and records the reaction.
func (h *Handler) ReportTransfusionReaction(
	ctx context.Context,
	req *connect.Request[nursingv1.ReportTransfusionReactionRequest],
) (*connect.Response[nursingv1.ReportTransfusionReactionResponse], error) {
	msg := req.Msg

	transfusion, err := h.svc.ReportTransfusionReaction(ctx,
		msg.GetTransfusionId(), domain.TransfusionReaction{
			Features: msg.GetFeatures(), ActionTaken: msg.GetActionTaken(),
			UnitReturned: msg.GetUnitReturned(),
		})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.ReportTransfusionReactionResponse{
		Transfusion: transfusionToProto(transfusion),
	}), nil
}

// CompleteTransfusion ends a transfusion that finished normally.
func (h *Handler) CompleteTransfusion(
	ctx context.Context,
	req *connect.Request[nursingv1.CompleteTransfusionRequest],
) (*connect.Response[nursingv1.CompleteTransfusionResponse], error) {
	transfusion, err := h.svc.CompleteTransfusion(ctx,
		req.Msg.GetTransfusionId(), goTime(req.Msg.GetEndedAt()))
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.CompleteTransfusionResponse{
		Transfusion: transfusionToProto(transfusion),
	}), nil
}

// AssessWound implements SRS-NUR-012.
func (h *Handler) AssessWound(
	ctx context.Context,
	req *connect.Request[nursingv1.AssessWoundRequest],
) (*connect.Response[nursingv1.AssessWoundResponse], error) {
	msg := req.Msg

	in := domain.NewWoundAssessmentInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		WoundID: msg.GetWoundId(), Location: msg.GetLocation(),
		BodyMapCode: codingFromProto(msg.GetBodyMapCode()),
		Laterality:  lateralityFromProto[msg.GetLaterality()],
		Kind:        woundKindFromProto[msg.GetKind()], Stage: msg.GetStage(),
		LengthMM: msg.GetLengthMm(), WidthMM: msg.GetWidthMm(),
		DepthMM:    msg.GetDepthMm(),
		Appearance: msg.GetAppearance(), Exudate: msg.GetExudate(),
		SurroundingSkin: msg.GetSurroundingSkin(),
		AssessedAt:      goTime(msg.GetAssessedAt()),
	}
	if msg.GetPainScoreRecorded() {
		// A pain score of 0 and an unrecorded one are different facts.
		score := msg.GetPainScore()
		in.PainScore = &score
	}

	assessment, err := h.svc.AssessWound(ctx, in)
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.AssessWoundResponse{
		Assessment: woundToProto(assessment),
	}), nil
}

// AttachWoundImage implements SRS-NUR-012's consented image.
func (h *Handler) AttachWoundImage(
	ctx context.Context,
	req *connect.Request[nursingv1.AttachWoundImageRequest],
) (*connect.Response[nursingv1.AttachWoundImageResponse], error) {
	msg := req.Msg

	assessment, err := h.svc.AttachWoundImage(ctx, msg.GetWoundAssessmentId(),
		domain.WoundImage{
			// Checked against the clinical consent record rather than taken on
			// trust: a consent identifier a caller made up is not a consent.
			ConsentID: msg.GetConsentId(),
			// Read and passed on so the service can refuse it by name. A
			// client still sending a key believes the record will point at
			// bytes it placed itself.
			StorageKey:  msg.GetStorageKey(), //nolint:staticcheck // deprecated on purpose; refused below
			ContentType: msg.GetContentType(),
			CapturedAt:  goTime(msg.GetCapturedAt()),
		}, msg.GetContent())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.AttachWoundImageResponse{
		Assessment: woundToProto(assessment),
	}), nil
}

// GetWoundHistory reads a wound's assessments over time.
func (h *Handler) GetWoundHistory(
	ctx context.Context,
	req *connect.Request[nursingv1.GetWoundHistoryRequest],
) (*connect.Response[nursingv1.GetWoundHistoryResponse], error) {
	msg := req.Msg

	assessments, err := h.svc.WoundHistory(ctx, msg.GetPatientId(),
		msg.GetWoundId(), msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*nursingv1.WoundAssessment, 0, len(assessments))
	for _, a := range assessments {
		out = append(out, woundToProto(a))
	}
	return connect.NewResponse(&nursingv1.GetWoundHistoryResponse{
		Assessments: out,
	}), nil
}

// RecordEducation implements SRS-NUR-015.
func (h *Handler) RecordEducation(
	ctx context.Context,
	req *connect.Request[nursingv1.RecordEducationRequest],
) (*connect.Response[nursingv1.RecordEducationResponse], error) {
	msg := req.Msg

	record, err := h.svc.Teach(ctx, application.TeachInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		Topic:       codingFromProto(msg.GetTopic()),
		Learner:     learnerFromProto[msg.GetLearner()],
		LearnerName: msg.GetLearnerName(), Method: msg.GetMethod(),
		Understanding: understandingFromProto[msg.GetUnderstanding()],
		Barriers:      msg.GetBarriers(), TaughtAt: goTime(msg.GetTaughtAt()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.RecordEducationResponse{
		Record: educationToProto(record),
	}), nil
}

// GetDischargeReadiness implements SRS-NUR-015's readiness.
func (h *Handler) GetDischargeReadiness(
	ctx context.Context,
	req *connect.Request[nursingv1.GetDischargeReadinessRequest],
) (*connect.Response[nursingv1.GetDischargeReadinessResponse], error) {
	readiness, err := h.svc.DischargeReadiness(ctx, req.Msg.GetEncounterId(),
		req.Msg.GetPatientId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.GetDischargeReadinessResponse{
		Readiness: readinessToProto(readiness),
	}), nil
}

// AssignNurse implements SRS-NUR-017.
func (h *Handler) AssignNurse(
	ctx context.Context,
	req *connect.Request[nursingv1.AssignNurseRequest],
) (*connect.Response[nursingv1.AssignNurseResponse], error) {
	msg := req.Msg

	assignment, err := h.svc.AssignNurse(ctx, application.AssignNurseInput{
		UnitID: msg.GetUnitId(), BedID: msg.GetBedId(),
		PatientID: msg.GetPatientId(), NurseID: msg.GetNurseId(),
		Relationship: relationshipFromProto[msg.GetRelationship()],
		From:         goTime(msg.GetEffectiveFrom()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.AssignNurseResponse{
		Assignment: assignmentToProto(assignment),
	}), nil
}

// EndAssignment closes an assignment.
func (h *Handler) EndAssignment(
	ctx context.Context,
	req *connect.Request[nursingv1.EndAssignmentRequest],
) (*connect.Response[nursingv1.EndAssignmentResponse], error) {
	if err := h.svc.EndAssignment(ctx, req.Msg.GetAssignmentId(),
		goTime(req.Msg.GetEffectiveTo()), req.Msg.GetReason()); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.EndAssignmentResponse{}), nil
}

// ListAssignments answers "who was looking after this patient at this time".
func (h *Handler) ListAssignments(
	ctx context.Context,
	req *connect.Request[nursingv1.ListAssignmentsRequest],
) (*connect.Response[nursingv1.ListAssignmentsResponse], error) {
	msg := req.Msg

	assignments, err := h.svc.WhoWasCaring(ctx, ports.AssignmentQuery{
		UnitID: msg.GetUnitId(), PatientID: msg.GetPatientId(),
		NurseID: msg.GetNurseId(), AsOf: goTime(msg.GetAsOf()),
		Limit: msg.GetPageSize(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*nursingv1.NurseAssignment, 0, len(assignments))
	for _, a := range assignments {
		out = append(out, assignmentToProto(a))
	}
	return connect.NewResponse(&nursingv1.ListAssignmentsResponse{
		Assignments: out,
	}), nil
}

// GetUnitAcuity implements SRS-NUR-016.
func (h *Handler) GetUnitAcuity(
	ctx context.Context,
	req *connect.Request[nursingv1.GetUnitAcuityRequest],
) (*connect.Response[nursingv1.GetUnitAcuityResponse], error) {
	msg := req.Msg

	patients := make([]application.AcuityInput, 0, len(msg.GetPatients()))
	for _, p := range msg.GetPatients() {
		patients = append(patients, application.AcuityInput{
			PatientID: p.GetPatientId(), EncounterID: p.GetEncounterId(),
			DependencyScore: p.GetDependencyScore(), Isolation: p.GetIsolation(),
		})
	}

	acuity, err := h.svc.UnitAcuity(ctx, msg.GetUnitId(), patients)
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.GetUnitAcuityResponse{
		Acuity: unitAcuityToProto(acuity),
	}), nil
}

// SetAcuityWeights configures a unit's multipliers.
func (h *Handler) SetAcuityWeights(
	ctx context.Context,
	req *connect.Request[nursingv1.SetAcuityWeightsRequest],
) (*connect.Response[nursingv1.SetAcuityWeightsResponse], error) {
	if err := h.svc.SetAcuityWeights(ctx, req.Msg.GetUnitId(),
		acuityWeightsFromProto(req.Msg.GetWeights())); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.SetAcuityWeightsResponse{}), nil
}

// DeclareDowntime implements SRS-NUR-018.
func (h *Handler) DeclareDowntime(
	ctx context.Context,
	req *connect.Request[nursingv1.DeclareDowntimeRequest],
) (*connect.Response[nursingv1.DeclareDowntimeResponse], error) {
	msg := req.Msg

	episode, err := h.svc.DeclareDowntime(ctx, msg.GetUnitId(), msg.GetReason(),
		goTime(msg.GetStartedAt()))
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.DeclareDowntimeResponse{
		Episode: downtimeToProto(episode),
	}), nil
}

// EndDowntime closes a downtime period.
func (h *Handler) EndDowntime(
	ctx context.Context,
	req *connect.Request[nursingv1.EndDowntimeRequest],
) (*connect.Response[nursingv1.EndDowntimeResponse], error) {
	episode, err := h.svc.EndDowntime(ctx, req.Msg.GetEpisodeId(),
		goTime(req.Msg.GetEndedAt()))
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.EndDowntimeResponse{
		Episode: downtimeToProto(episode),
	}), nil
}

// ReconcileDowntime implements SRS-NUR-018's recovery reconciliation.
func (h *Handler) ReconcileDowntime(
	ctx context.Context,
	req *connect.Request[nursingv1.ReconcileDowntimeRequest],
) (*connect.Response[nursingv1.ReconcileDowntimeResponse], error) {
	report, err := h.svc.ReconcileDowntime(ctx, req.Msg.GetEpisodeId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&nursingv1.ReconcileDowntimeResponse{
		EpisodeId: report.EpisodeID, UnitId: report.UnitID,
		RunAt: ts(report.RunAt),
	}), nil
}

// ListDowntime reads downtime episodes.
func (h *Handler) ListDowntime(
	ctx context.Context,
	req *connect.Request[nursingv1.ListDowntimeRequest],
) (*connect.Response[nursingv1.ListDowntimeResponse], error) {
	msg := req.Msg

	episodes, err := h.svc.ListDowntime(ctx, msg.GetUnitId(),
		msg.GetUnreconciledOnly(), msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*nursingv1.DowntimeEpisode, 0, len(episodes))
	for _, e := range episodes {
		out = append(out, downtimeToProto(e))
	}
	return connect.NewResponse(&nursingv1.ListDowntimeResponse{
		Episodes: out,
	}), nil
}

// GetSuspectedDuplicates implements SRS-NUR-018's eyebrow report.
//
// Reporting only: the scheduled-dose key refuses, and two PRN doses an hour
// apart can be entirely correct.
func (h *Handler) GetSuspectedDuplicates(
	ctx context.Context,
	req *connect.Request[nursingv1.GetSuspectedDuplicatesRequest],
) (*connect.Response[nursingv1.GetSuspectedDuplicatesResponse], error) {
	duplicates, err := h.svc.SuspectedDuplicates(ctx,
		req.Msg.GetEncounterId(), req.Msg.GetPatientId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*nursingv1.SuspectedDuplicate, 0, len(duplicates))
	for _, d := range duplicates {
		out = append(out, &nursingv1.SuspectedDuplicate{
			FirstId: d.FirstID, SecondId: d.SecondID, OrderId: d.OrderID,
			ApartSeconds: int64(d.Apart / time.Second),
		})
	}
	return connect.NewResponse(&nursingv1.GetSuspectedDuplicatesResponse{
		Duplicates: out,
	}), nil
}
