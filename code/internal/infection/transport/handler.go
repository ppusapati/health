package transport

import (
	"context"
	"time"

	"connectrpc.com/connect"

	infectionv1 "github.com/ppusapati/health/code/gen/go/healthcare/infection/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/infection/v1/infectionv1connect"
	"github.com/ppusapati/health/code/internal/infection/application"
	"github.com/ppusapati/health/code/internal/infection/domain"
	"github.com/ppusapati/health/code/internal/infection/ports"
)

// Handler is the infection control ConnectRPC surface.
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

func (h *Handler) OpenCase(ctx context.Context,
	req *connect.Request[infectionv1.OpenCaseRequest]) (
	*connect.Response[infectionv1.OpenCaseResponse], error) {

	msg := req.Msg
	one, err := h.svc.OpenCase(ctx, application.OpenCaseInput{
		Reference: msg.GetReference(), PatientID: msg.GetPatientId(),
		EncounterID: msg.GetEncounterId(), FacilityID: msg.GetFacilityId(),
		LocationID: msg.GetLocationId(), Organism: msg.GetOrganism(),
		OrganismCode: msg.GetOrganismCode(),
		Site:         siteFromWire[msg.GetSite()],
		AdmittedAt:   timeOf(msg.GetAdmittedAt()),
		OnsetAt:      timeOf(msg.GetOnsetAt()),
		DeviceInSitu: msg.GetDeviceInSitu(),
		DeviceDays:   int(msg.GetDeviceDays()),
		Criteria:     msg.GetCriteria(), Notes: msg.GetNotes(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.OpenCaseResponse{
		SurveillanceCase: caseToProto(one),
	}), nil
}

func (h *Handler) ReviewCase(ctx context.Context,
	req *connect.Request[infectionv1.ReviewCaseRequest]) (
	*connect.Response[infectionv1.ReviewCaseResponse], error) {

	one, err := h.svc.ReviewCase(ctx, req.Msg.GetCaseId(),
		caseStateFromWire[req.Msg.GetState()], req.Msg.GetCriteria())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.ReviewCaseResponse{
		SurveillanceCase: caseToProto(one),
	}), nil
}

func (h *Handler) OverrideOnset(ctx context.Context,
	req *connect.Request[infectionv1.OverrideOnsetRequest]) (
	*connect.Response[infectionv1.OverrideOnsetResponse], error) {

	one, err := h.svc.OverrideOnset(ctx, req.Msg.GetCaseId(),
		onsetFromWire[req.Msg.GetOnset()], req.Msg.GetReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.OverrideOnsetResponse{
		SurveillanceCase: caseToProto(one),
	}), nil
}

func (h *Handler) ListCases(ctx context.Context,
	req *connect.Request[infectionv1.ListCasesRequest]) (
	*connect.Response[infectionv1.ListCasesResponse], error) {

	msg := req.Msg
	cases, err := h.svc.Cases(ctx, ports.CaseFilter{
		PatientID:  msg.GetPatientId(),
		State:      string(caseStateFromWire[msg.GetState()]),
		Site:       siteFromWire[msg.GetSite()],
		LocationID: msg.GetLocationId(),
		From:       timeOf(msg.GetOnsetFrom()), To: timeOf(msg.GetOnsetTo()),
		Limit: msg.GetPageSize(), Offset: msg.GetPageOffset(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*infectionv1.SurveillanceCase, 0, len(cases))
	for _, one := range cases {
		out = append(out, caseToProto(one))
	}
	return connect.NewResponse(&infectionv1.ListCasesResponse{
		Cases: out,
	}), nil
}

func (h *Handler) RecordDeviceDays(ctx context.Context,
	req *connect.Request[infectionv1.RecordDeviceDaysRequest]) (
	*connect.Response[infectionv1.RecordDeviceDaysResponse], error) {

	msg := req.Msg
	count, err := h.svc.RecordDeviceDays(ctx, msg.GetFacilityId(),
		msg.GetLocationId(), deviceFromWire[msg.GetDevice()],
		timeOf(msg.GetCountedOn()), int(msg.GetPatientDays()),
		int(msg.GetDeviceDays()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.RecordDeviceDaysResponse{
		Count: deviceDaysToProto(count),
	}), nil
}

func (h *Handler) GetRate(ctx context.Context,
	req *connect.Request[infectionv1.GetRateRequest]) (
	*connect.Response[infectionv1.GetRateResponse], error) {

	msg := req.Msg
	rate, err := h.svc.Rate(ctx, siteFromWire[msg.GetSite()],
		msg.GetLocationId(), timeOf(msg.GetPeriodFrom()),
		timeOf(msg.GetPeriodTo()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.GetRateResponse{
		Rate: rateToProto(rate),
	}), nil
}

func (h *Handler) StartIsolation(ctx context.Context,
	req *connect.Request[infectionv1.StartIsolationRequest]) (
	*connect.Response[infectionv1.StartIsolationResponse], error) {

	msg := req.Msg
	isolation, err := h.svc.StartIsolation(ctx,
		application.StartIsolationInput{
			PatientID:   msg.GetPatientId(),
			EncounterID: msg.GetEncounterId(),
			FacilityID:  msg.GetFacilityId(),
			LocationID:  msg.GetLocationId(), BedID: msg.GetBedId(),
			Precaution: precautionFromWire[msg.GetPrecaution()],
			Reason:     msg.GetReason(), CaseID: msg.GetCaseId(),
			StartedAt: timeOf(msg.GetStartedAt()),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.StartIsolationResponse{
		Isolation: isolationToProto(isolation),
	}), nil
}

func (h *Handler) ExtendIsolation(ctx context.Context,
	req *connect.Request[infectionv1.ExtendIsolationRequest]) (
	*connect.Response[infectionv1.ExtendIsolationResponse], error) {

	isolation, err := h.svc.ExtendIsolation(ctx, req.Msg.GetIsolationId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.ExtendIsolationResponse{
		Isolation: isolationToProto(isolation),
	}), nil
}

func (h *Handler) EndIsolation(ctx context.Context,
	req *connect.Request[infectionv1.EndIsolationRequest]) (
	*connect.Response[infectionv1.EndIsolationResponse], error) {

	isolation, err := h.svc.EndIsolation(ctx, req.Msg.GetIsolationId(),
		req.Msg.GetReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.EndIsolationResponse{
		Isolation: isolationToProto(isolation),
	}), nil
}

func (h *Handler) GetBoard(ctx context.Context,
	req *connect.Request[infectionv1.GetBoardRequest]) (
	*connect.Response[infectionv1.GetBoardResponse], error) {

	entries, err := h.svc.Board(ctx, req.Msg.GetLocationId())
	if err != nil {
		return nil, err
	}
	out := make([]*infectionv1.BoardEntry, 0, len(entries))
	for _, entry := range entries {
		out = append(out, boardEntryToProto(entry))
	}
	return connect.NewResponse(&infectionv1.GetBoardResponse{
		Entries: out,
	}), nil
}

func (h *Handler) DraftAlertRule(ctx context.Context,
	req *connect.Request[infectionv1.DraftAlertRuleRequest]) (
	*connect.Response[infectionv1.DraftAlertRuleResponse], error) {

	msg := req.Msg
	rule, err := h.svc.DraftAlertRule(ctx, application.NewAlertRuleInput{
		Code: msg.GetCode(), Name: msg.GetName(),
		Revision: int(msg.GetRevision()), Organisms: msg.GetOrganisms(),
		LookbackDays: int(msg.GetLookbackDays()),
		Precaution:   precautionFromWire[msg.GetPrecaution()],
		Advice:       msg.GetAdvice(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.DraftAlertRuleResponse{
		Rule: alertRuleToProto(rule),
	}), nil
}

func (h *Handler) ApproveAlertRule(ctx context.Context,
	req *connect.Request[infectionv1.ApproveAlertRuleRequest]) (
	*connect.Response[infectionv1.ApproveAlertRuleResponse], error) {

	effective := timeOf(req.Msg.GetEffectiveFrom())
	if effective.IsZero() {
		effective = h.now()
	}
	rule, err := h.svc.ApproveAlertRule(ctx, req.Msg.GetRuleId(), effective)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.ApproveAlertRuleResponse{
		Rule: alertRuleToProto(rule),
	}), nil
}

func (h *Handler) ScreenEncounter(ctx context.Context,
	req *connect.Request[infectionv1.ScreenEncounterRequest]) (
	*connect.Response[infectionv1.ScreenEncounterResponse], error) {

	msg := req.Msg
	alerts, err := h.svc.ScreenEncounter(ctx, msg.GetPatientId(),
		msg.GetEncounterId(), msg.GetFacilityId(), msg.GetOrganism(),
		msg.GetOrganismCode(), timeOf(msg.GetLastPositiveAt()))
	if err != nil {
		return nil, err
	}
	out := make([]*infectionv1.Alert, 0, len(alerts))
	for _, alert := range alerts {
		out = append(out, alertToProto(alert))
	}
	return connect.NewResponse(&infectionv1.ScreenEncounterResponse{
		Alerts: out,
	}), nil
}

func (h *Handler) AcknowledgeAlert(ctx context.Context,
	req *connect.Request[infectionv1.AcknowledgeAlertRequest]) (
	*connect.Response[infectionv1.AcknowledgeAlertResponse], error) {

	alert, err := h.svc.AcknowledgeAlert(ctx, req.Msg.GetAlertId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.AcknowledgeAlertResponse{
		Alert: alertToProto(alert),
	}), nil
}

func (h *Handler) OverrideAlert(ctx context.Context,
	req *connect.Request[infectionv1.OverrideAlertRequest]) (
	*connect.Response[infectionv1.OverrideAlertResponse], error) {

	alert, err := h.svc.OverrideAlert(ctx, req.Msg.GetAlertId(),
		req.Msg.GetReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.OverrideAlertResponse{
		Alert: alertToProto(alert),
	}), nil
}

func (h *Handler) ListAlerts(ctx context.Context,
	req *connect.Request[infectionv1.ListAlertsRequest]) (
	*connect.Response[infectionv1.ListAlertsResponse], error) {

	msg := req.Msg
	alerts, err := h.svc.Alerts(ctx, msg.GetPatientId(),
		msg.GetEncounterId(), msg.GetOutstandingOnly(), msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	out := make([]*infectionv1.Alert, 0, len(alerts))
	for _, alert := range alerts {
		out = append(out, alertToProto(alert))
	}
	return connect.NewResponse(&infectionv1.ListAlertsResponse{
		Alerts: out,
	}), nil
}

func (h *Handler) OpenOutbreak(ctx context.Context,
	req *connect.Request[infectionv1.OpenOutbreakRequest]) (
	*connect.Response[infectionv1.OpenOutbreakResponse], error) {

	msg := req.Msg
	outbreak, err := h.svc.OpenOutbreak(ctx, application.OpenOutbreakInput{
		Reference: msg.GetReference(), Organism: msg.GetOrganism(),
		CaseDefinition: msg.GetCaseDefinition(),
		Locations:      msg.GetLocations(),
		WindowFrom:     timeOf(msg.GetWindowFrom()),
		WindowTo:       timeOf(msg.GetWindowTo()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.OpenOutbreakResponse{
		Outbreak: outbreakToProto(outbreak),
	}), nil
}

func (h *Handler) AdvanceOutbreak(ctx context.Context,
	req *connect.Request[infectionv1.AdvanceOutbreakRequest]) (
	*connect.Response[infectionv1.AdvanceOutbreakResponse], error) {

	outbreak, err := h.svc.AdvanceOutbreak(ctx, req.Msg.GetOutbreakId(),
		outbreakStateFromWire[req.Msg.GetState()], req.Msg.GetReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.AdvanceOutbreakResponse{
		Outbreak: outbreakToProto(outbreak),
	}), nil
}

func (h *Handler) CloseOutbreak(ctx context.Context,
	req *connect.Request[infectionv1.CloseOutbreakRequest]) (
	*connect.Response[infectionv1.CloseOutbreakResponse], error) {

	msg := req.Msg
	outbreak, err := h.svc.CloseOutbreak(ctx, msg.GetOutbreakId(),
		msg.GetFindings(), msg.GetReason(), msg.GetControlMeasures(),
		msg.GetActionIds())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.CloseOutbreakResponse{
		Outbreak: outbreakToProto(outbreak),
	}), nil
}

func (h *Handler) AddOutbreakMember(ctx context.Context,
	req *connect.Request[infectionv1.AddOutbreakMemberRequest]) (
	*connect.Response[infectionv1.AddOutbreakMemberResponse], error) {

	msg := req.Msg
	member, err := h.svc.AddOutbreakMember(ctx, msg.GetOutbreakId(),
		msg.GetCaseId(), membershipFromWire[msg.GetReason()], msg.GetNote())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.AddOutbreakMemberResponse{
		Membership: membershipToProto(member),
	}), nil
}

func (h *Handler) GetCluster(ctx context.Context,
	req *connect.Request[infectionv1.GetClusterRequest]) (
	*connect.Response[infectionv1.GetClusterResponse], error) {

	cluster, err := h.svc.OutbreakCluster(ctx, req.Msg.GetOutbreakId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.GetClusterResponse{
		Cluster: clusterToProto(cluster),
	}), nil
}

func (h *Handler) ListOutbreaks(ctx context.Context,
	req *connect.Request[infectionv1.ListOutbreaksRequest]) (
	*connect.Response[infectionv1.ListOutbreaksResponse], error) {

	msg := req.Msg
	outbreaks, err := h.svc.Outbreaks(ctx,
		string(outbreakStateFromWire[msg.GetState()]), msg.GetOpenOnly(),
		msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	out := make([]*infectionv1.Outbreak, 0, len(outbreaks))
	for _, outbreak := range outbreaks {
		out = append(out, outbreakToProto(outbreak))
	}
	return connect.NewResponse(&infectionv1.ListOutbreaksResponse{
		Outbreaks: out,
	}), nil
}

func (h *Handler) StartHygieneSession(ctx context.Context,
	req *connect.Request[infectionv1.StartHygieneSessionRequest]) (
	*connect.Response[infectionv1.StartHygieneSessionResponse], error) {

	msg := req.Msg
	session, err := h.svc.StartHygieneSession(ctx, msg.GetFacilityId(),
		msg.GetLocationId(), msg.GetNotes(), timeOf(msg.GetStartedAt()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.StartHygieneSessionResponse{
		Session: hygieneSessionToProto(session),
	}), nil
}

func (h *Handler) RecordObservation(ctx context.Context,
	req *connect.Request[infectionv1.RecordObservationRequest]) (
	*connect.Response[infectionv1.RecordObservationResponse], error) {

	msg := req.Msg
	observation, err := h.svc.RecordObservation(ctx, msg.GetSessionId(),
		disciplineFromWire[msg.GetDiscipline()],
		momentFromWire[msg.GetMoment()], actionFromWire[msg.GetAction()],
		msg.GetGlovesWorn(), timeOf(msg.GetObservedAt()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.RecordObservationResponse{
		Observation: observationToProto(observation),
	}), nil
}

func (h *Handler) EndHygieneSession(ctx context.Context,
	req *connect.Request[infectionv1.EndHygieneSessionRequest]) (
	*connect.Response[infectionv1.EndHygieneSessionResponse], error) {

	session, err := h.svc.EndHygieneSession(ctx, req.Msg.GetSessionId(),
		req.Msg.GetNotes())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.EndHygieneSessionResponse{
		Session: hygieneSessionToProto(session),
	}), nil
}

func (h *Handler) GetHygieneCompliance(ctx context.Context,
	req *connect.Request[infectionv1.GetHygieneComplianceRequest]) (
	*connect.Response[infectionv1.GetHygieneComplianceResponse], error) {

	msg := req.Msg
	report, err := h.svc.HygieneCompliance(ctx, msg.GetLocationId(),
		msg.GetGroupBy(), timeOf(msg.GetPeriodFrom()),
		timeOf(msg.GetPeriodTo()))
	if err != nil {
		return nil, err
	}
	groups := make([]*infectionv1.Compliance, 0, len(report.Groups))
	for _, group := range report.Groups {
		groups = append(groups, complianceToProto(group))
	}
	return connect.NewResponse(&infectionv1.GetHygieneComplianceResponse{
		Groups: groups, Observations: int32(report.Observations),
		SuppressionThreshold: int32(report.SuppressionThreshold),
		IndicatorCode:        report.IndicatorCode,
		IndicatorRevision:    int32(report.IndicatorRevision),
	}), nil
}

func (h *Handler) ReportExposure(ctx context.Context,
	req *connect.Request[infectionv1.ReportExposureRequest]) (
	*connect.Response[infectionv1.ReportExposureResponse], error) {

	msg := req.Msg
	exposure, tasks, err := h.svc.ReportExposure(ctx,
		application.ReportExposureInput{
			Reference: msg.GetReference(), StaffID: msg.GetStaffId(),
			Discipline:      disciplineFromWire[msg.GetDiscipline()],
			FacilityID:      msg.GetFacilityId(),
			LocationID:      msg.GetLocationId(),
			Kind:            exposureKindFromWire[msg.GetKind()],
			Device:          msg.GetDevice(),
			Circumstance:    msg.GetCircumstance(),
			DeepInjury:      msg.GetDeepInjury(),
			SourcePatientID: msg.GetSourcePatientId(),
			SourceKnown:     msg.GetSourceKnown(),
			SourceConsented: msg.GetSourceConsented(),
			OccurredAt:      timeOf(msg.GetOccurredAt()),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.ReportExposureResponse{
		Exposure: exposureToProto(exposure), Tasks: tasksToProto(tasks),
	}), nil
}

func tasksToProto(tasks []domain.ExposureTask) []*infectionv1.ExposureTask {
	out := make([]*infectionv1.ExposureTask, 0, len(tasks))
	for _, task := range tasks {
		out = append(out, taskToProto(task))
	}
	return out
}

func (h *Handler) GetExposure(ctx context.Context,
	req *connect.Request[infectionv1.GetExposureRequest]) (
	*connect.Response[infectionv1.GetExposureResponse], error) {

	exposure, tasks, err := h.svc.Exposure(ctx, req.Msg.GetExposureId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.GetExposureResponse{
		Exposure: exposureToProto(exposure), Tasks: tasksToProto(tasks),
	}), nil
}

func (h *Handler) CompleteExposureTask(ctx context.Context,
	req *connect.Request[infectionv1.CompleteExposureTaskRequest]) (
	*connect.Response[infectionv1.CompleteExposureTaskResponse], error) {

	msg := req.Msg
	task, err := h.svc.CompleteExposureTask(ctx, msg.GetExposureId(),
		msg.GetTaskId(), taskStateFromWire[msg.GetState()],
		msg.GetOutcome())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.CompleteExposureTaskResponse{
		Task: taskToProto(task),
	}), nil
}

func (h *Handler) CloseExposure(ctx context.Context,
	req *connect.Request[infectionv1.CloseExposureRequest]) (
	*connect.Response[infectionv1.CloseExposureResponse], error) {

	exposure, err := h.svc.CloseExposure(ctx, req.Msg.GetExposureId(),
		req.Msg.GetOutcome())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.CloseExposureResponse{
		Exposure: exposureToProto(exposure),
	}), nil
}

func (h *Handler) ListExposures(ctx context.Context,
	req *connect.Request[infectionv1.ListExposuresRequest]) (
	*connect.Response[infectionv1.ListExposuresResponse], error) {

	msg := req.Msg
	exposures, err := h.svc.Exposures(ctx, ports.ExposureFilter{
		StaffID: msg.GetStaffId(), OpenOnly: msg.GetOpenOnly(),
		From:  timeOf(msg.GetOccurredFrom()),
		To:    timeOf(msg.GetOccurredTo()),
		Limit: msg.GetPageSize(), Offset: msg.GetPageOffset(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*infectionv1.Exposure, 0, len(exposures))
	for _, exposure := range exposures {
		out = append(out, exposureToProto(exposure))
	}
	return connect.NewResponse(&infectionv1.ListExposuresResponse{
		Exposures: out,
	}), nil
}

func (h *Handler) SweepExposureTasks(ctx context.Context,
	req *connect.Request[infectionv1.SweepExposureTasksRequest]) (
	*connect.Response[infectionv1.SweepExposureTasksResponse], error) {

	raised, err := h.svc.SweepExposureTasks(ctx)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.SweepExposureTasksResponse{
		Escalated: int32(raised),
	}), nil
}

func (h *Handler) DraftStewardshipRule(ctx context.Context,
	req *connect.Request[infectionv1.DraftStewardshipRuleRequest]) (
	*connect.Response[infectionv1.DraftStewardshipRuleResponse], error) {

	msg := req.Msg
	rule, err := h.svc.DraftStewardshipRule(ctx,
		application.NewStewardshipRuleInput{
			Code: msg.GetCode(), Name: msg.GetName(),
			Revision: int(msg.GetRevision()),
			Kind:     triggerFromWire[msg.GetKind()],
			Agents:   msg.GetAgents(), AllAgents: msg.GetAllAgents(),
			DayThreshold: int(msg.GetDayThreshold()),
			Prompt:       msg.GetPrompt(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.DraftStewardshipRuleResponse{
		Rule: stewardshipRuleToProto(rule),
	}), nil
}

func (h *Handler) ApproveStewardshipRule(ctx context.Context,
	req *connect.Request[infectionv1.ApproveStewardshipRuleRequest]) (
	*connect.Response[infectionv1.ApproveStewardshipRuleResponse], error) {

	effective := timeOf(req.Msg.GetEffectiveFrom())
	if effective.IsZero() {
		effective = h.now()
	}
	rule, err := h.svc.ApproveStewardshipRule(ctx, req.Msg.GetRuleId(),
		effective)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.ApproveStewardshipRuleResponse{
		Rule: stewardshipRuleToProto(rule),
	}), nil
}

func (h *Handler) ReviewEncounter(ctx context.Context,
	req *connect.Request[infectionv1.ReviewEncounterRequest]) (
	*connect.Response[infectionv1.ReviewEncounterResponse], error) {

	reviews, err := h.svc.ReviewEncounter(ctx, req.Msg.GetEncounterId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.ReviewEncounterResponse{
		Reviews: reviewsToProto(reviews),
	}), nil
}

func reviewsToProto(
	reviews []domain.StewardshipReview) []*infectionv1.StewardshipReview {

	out := make([]*infectionv1.StewardshipReview, 0, len(reviews))
	for _, review := range reviews {
		out = append(out, reviewToProto(review))
	}
	return out
}

func (h *Handler) AdviseReview(ctx context.Context,
	req *connect.Request[infectionv1.AdviseReviewRequest]) (
	*connect.Response[infectionv1.AdviseReviewResponse], error) {

	review, err := h.svc.AdviseReview(ctx, req.Msg.GetReviewId(),
		recommendationFromWire[req.Msg.GetRecommendation()],
		req.Msg.GetAdvice())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.AdviseReviewResponse{
		Review: reviewToProto(review),
	}), nil
}

func (h *Handler) RespondToReview(ctx context.Context,
	req *connect.Request[infectionv1.RespondToReviewRequest]) (
	*connect.Response[infectionv1.RespondToReviewResponse], error) {

	review, err := h.svc.RespondToReview(ctx, req.Msg.GetReviewId(),
		responseFromWire[req.Msg.GetResponse()], req.Msg.GetReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.RespondToReviewResponse{
		Review: reviewToProto(review),
	}), nil
}

func (h *Handler) WithdrawReview(ctx context.Context,
	req *connect.Request[infectionv1.WithdrawReviewRequest]) (
	*connect.Response[infectionv1.WithdrawReviewResponse], error) {

	review, err := h.svc.WithdrawReview(ctx, req.Msg.GetReviewId(),
		req.Msg.GetReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.WithdrawReviewResponse{
		Review: reviewToProto(review),
	}), nil
}

func (h *Handler) ListReviews(ctx context.Context,
	req *connect.Request[infectionv1.ListReviewsRequest]) (
	*connect.Response[infectionv1.ListReviewsResponse], error) {

	msg := req.Msg
	reviews, err := h.svc.StewardshipWorklist(ctx, ports.ReviewFilter{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		State:        string(reviewStateFromWire[msg.GetState()]),
		WorklistOnly: msg.GetWorklistOnly(),
		From:         timeOf(msg.GetRaisedFrom()),
		To:           timeOf(msg.GetRaisedTo()),
		Limit:        msg.GetPageSize(), Offset: msg.GetPageOffset(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.ListReviewsResponse{
		Reviews: reviewsToProto(reviews),
	}), nil
}

func (h *Handler) GetStewardshipIndicators(ctx context.Context,
	req *connect.Request[infectionv1.GetStewardshipIndicatorsRequest]) (
	*connect.Response[infectionv1.GetStewardshipIndicatorsResponse], error) {

	msg := req.Msg
	report, err := h.svc.StewardshipIndicators(ctx, msg.GetLocationId(),
		timeOf(msg.GetPeriodFrom()), timeOf(msg.GetPeriodTo()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(
		&infectionv1.GetStewardshipIndicatorsResponse{
			Summary: stewardshipSummaryToProto(report),
		}), nil
}

func (h *Handler) DraftLimit(ctx context.Context,
	req *connect.Request[infectionv1.DraftLimitRequest]) (
	*connect.Response[infectionv1.DraftLimitResponse], error) {

	msg := req.Msg
	limit, err := h.svc.DraftLimit(ctx, application.NewLimitInput{
		Code: msg.GetCode(), Name: msg.GetName(),
		Revision:    int(msg.GetRevision()),
		SampleKind:  sampleKindFromWire[msg.GetSampleKind()],
		Unit:        msg.GetUnit(),
		ActionLevel: msg.GetActionLevel(), FailLevel: msg.GetFailLevel(),
		DetectionFails: msg.GetDetectionFails(),
		BelowIsFailure: msg.GetBelowIsFailure(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.DraftLimitResponse{
		Limit: limitToProto(limit),
	}), nil
}

func (h *Handler) ApproveLimit(ctx context.Context,
	req *connect.Request[infectionv1.ApproveLimitRequest]) (
	*connect.Response[infectionv1.ApproveLimitResponse], error) {

	effective := timeOf(req.Msg.GetEffectiveFrom())
	if effective.IsZero() {
		effective = h.now()
	}
	limit, err := h.svc.ApproveLimit(ctx, req.Msg.GetLimitId(), effective)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.ApproveLimitResponse{
		Limit: limitToProto(limit),
	}), nil
}

func (h *Handler) AddSamplingPlan(ctx context.Context,
	req *connect.Request[infectionv1.AddSamplingPlanRequest]) (
	*connect.Response[infectionv1.AddSamplingPlanResponse], error) {

	msg := req.Msg
	plan, err := h.svc.AddSamplingPlan(ctx, msg.GetCode(),
		sampleKindFromWire[msg.GetSampleKind()], msg.GetFacilityId(),
		msg.GetLocationId(), msg.GetSamplePoint(),
		int(msg.GetEveryDays()), timeOf(msg.GetStartedAt()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.AddSamplingPlanResponse{
		Plan: planToProto(plan),
	}), nil
}

func (h *Handler) CollectSample(ctx context.Context,
	req *connect.Request[infectionv1.CollectSampleRequest]) (
	*connect.Response[infectionv1.CollectSampleResponse], error) {

	msg := req.Msg
	sample, err := h.svc.CollectSample(ctx, application.CollectSampleInput{
		Reference:  msg.GetReference(),
		Kind:       sampleKindFromWire[msg.GetSampleKind()],
		FacilityID: msg.GetFacilityId(), LocationID: msg.GetLocationId(),
		SamplePoint: msg.GetSamplePoint(), PlanID: msg.GetPlanId(),
		OutbreakID: msg.GetOutbreakId(), RepeatOfID: msg.GetRepeatOfId(),
		CollectedAt: timeOf(msg.GetCollectedAt()), Method: msg.GetMethod(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.CollectSampleResponse{
		Sample: sampleToProto(sample),
	}), nil
}

func (h *Handler) RecordSampleResult(ctx context.Context,
	req *connect.Request[infectionv1.RecordSampleResultRequest]) (
	*connect.Response[infectionv1.RecordSampleResultResponse], error) {

	msg := req.Msg
	sample, err := h.svc.RecordSampleResult(ctx, msg.GetSampleId(),
		msg.GetLabReference(), msg.GetValue(), msg.GetUnit(),
		msg.GetOrganism(), msg.GetDetected(), timeOf(msg.GetResultedAt()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.RecordSampleResultResponse{
		Sample: sampleToProto(sample),
	}), nil
}

func (h *Handler) RaiseCorrectiveAction(ctx context.Context,
	req *connect.Request[infectionv1.RaiseCorrectiveActionRequest]) (
	*connect.Response[infectionv1.RaiseCorrectiveActionResponse], error) {

	msg := req.Msg
	action, err := h.svc.RaiseCorrectiveAction(ctx, msg.GetSampleId(),
		msg.GetAction(), msg.GetOwner(), timeOf(msg.GetDueBy()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.RaiseCorrectiveActionResponse{
		Action: correctiveActionToProto(action),
	}), nil
}

func (h *Handler) CompleteCorrectiveAction(ctx context.Context,
	req *connect.Request[infectionv1.CompleteCorrectiveActionRequest]) (
	*connect.Response[infectionv1.CompleteCorrectiveActionResponse], error) {

	action, err := h.svc.CompleteCorrectiveAction(ctx,
		req.Msg.GetActionId(), req.Msg.GetNote())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(
		&infectionv1.CompleteCorrectiveActionResponse{
			Action: correctiveActionToProto(action),
		}), nil
}

func (h *Handler) VerifyCorrectiveAction(ctx context.Context,
	req *connect.Request[infectionv1.VerifyCorrectiveActionRequest]) (
	*connect.Response[infectionv1.VerifyCorrectiveActionResponse], error) {

	action, err := h.svc.VerifyCorrectiveAction(ctx, req.Msg.GetActionId(),
		req.Msg.GetRepeatSampleId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.VerifyCorrectiveActionResponse{
		Action: correctiveActionToProto(action),
	}), nil
}

func (h *Handler) CloseSample(ctx context.Context,
	req *connect.Request[infectionv1.CloseSampleRequest]) (
	*connect.Response[infectionv1.CloseSampleResponse], error) {

	sample, err := h.svc.CloseSample(ctx, req.Msg.GetSampleId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.CloseSampleResponse{
		Sample: sampleToProto(sample),
	}), nil
}

func (h *Handler) ListDueSampling(ctx context.Context,
	req *connect.Request[infectionv1.ListDueSamplingRequest]) (
	*connect.Response[infectionv1.ListDueSamplingResponse], error) {

	points, err := h.svc.DueSampling(ctx, req.Msg.GetLocationId())
	if err != nil {
		return nil, err
	}
	out := make([]*infectionv1.DuePoint, 0, len(points))
	for _, point := range points {
		out = append(out, duePointToProto(point))
	}
	return connect.NewResponse(&infectionv1.ListDueSamplingResponse{
		Points: out,
	}), nil
}

func (h *Handler) ListSamples(ctx context.Context,
	req *connect.Request[infectionv1.ListSamplesRequest]) (
	*connect.Response[infectionv1.ListSamplesResponse], error) {

	msg := req.Msg
	samples, err := h.svc.Samples(ctx, ports.SampleFilter{
		LocationID:  msg.GetLocationId(),
		Kind:        sampleKindFromWire[msg.GetSampleKind()],
		FailingOnly: msg.GetFailingOnly(),
		From:        timeOf(msg.GetCollectedFrom()),
		To:          timeOf(msg.GetCollectedTo()),
		Limit:       msg.GetPageSize(), Offset: msg.GetPageOffset(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*infectionv1.EnvironmentalSample, 0, len(samples))
	for _, sample := range samples {
		out = append(out, sampleToProto(sample))
	}
	return connect.NewResponse(&infectionv1.ListSamplesResponse{
		Samples: out,
	}), nil
}

func (h *Handler) ListCorrectiveActions(ctx context.Context,
	req *connect.Request[infectionv1.ListCorrectiveActionsRequest]) (
	*connect.Response[infectionv1.ListCorrectiveActionsResponse], error) {

	actions, err := h.svc.CorrectiveActions(ctx, req.Msg.GetSampleId(),
		req.Msg.GetOpenOnly())
	if err != nil {
		return nil, err
	}
	out := make([]*infectionv1.CorrectiveAction, 0, len(actions))
	for _, action := range actions {
		out = append(out, correctiveActionToProto(action))
	}
	return connect.NewResponse(&infectionv1.ListCorrectiveActionsResponse{
		Actions: out,
	}), nil
}

func (h *Handler) GetEnvironmentSummary(ctx context.Context,
	req *connect.Request[infectionv1.GetEnvironmentSummaryRequest]) (
	*connect.Response[infectionv1.GetEnvironmentSummaryResponse], error) {

	msg := req.Msg
	summary, err := h.svc.EnvironmentSummary(ctx, msg.GetLocationId(),
		timeOf(msg.GetPeriodFrom()), timeOf(msg.GetPeriodTo()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&infectionv1.GetEnvironmentSummaryResponse{
		Summary: environmentSummaryToProto(summary),
	}), nil
}

// Compile-time proof that the handler satisfies the generated service
// contract. A missing RPC is a build failure rather than a 404 somebody finds
// in production.
var _ infectionv1connect.InfectionServiceHandler = (*Handler)(nil)
