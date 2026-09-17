package transport

import (
	"context"
	"time"

	"connectrpc.com/connect"
	icuv1 "github.com/ppusapati/health/code/gen/go/healthcare/icu/v1"
	"github.com/ppusapati/health/code/internal/icu/application"
	"github.com/ppusapati/health/code/internal/icu/domain"
)

// Handler is the critical-care ConnectRPC surface.
//
// Thin on purpose: it translates, calls one use case and translates back. Every
// refusal below comes from the application or the domain, so the same rule
// holds whichever client asks.
type Handler struct {
	svc *application.Service
	now func() time.Time
}

// NewHandler constructs a Handler.
//
// The clock is injected because several responses derive a state — a device
// review overdue, an assessment overdue, a ceiling past its review — at the
// moment of rendering rather than storing it.
func NewHandler(svc *application.Service, now func() time.Time) *Handler {
	if now == nil {
		now = time.Now
	}
	return &Handler{svc: svc, now: now}
}

func (h *Handler) Admit(ctx context.Context, req *connect.Request[icuv1.AdmitRequest]) (
	*connect.Response[icuv1.AdmitResponse], error) {

	msg := req.Msg
	episode, err := h.svc.Admit(ctx, application.AdmitInput{
		EncounterID: msg.GetEncounterId(), PatientID: msg.GetPatientId(),
		FacilityID: msg.GetFacilityId(), UnitID: msg.GetUnitId(),
		BedID:                msg.GetBedId(),
		Source:               admissionSource(msg.GetSource()),
		TransferredFrom:      msg.GetTransferredFrom(),
		ResponsibleTeam:      msg.GetResponsibleTeam(),
		ResponsibleClinician: msg.GetResponsibleClinician(),
		AdmittedAt:           timeOf(msg.GetAdmittedAt()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&icuv1.AdmitResponse{
		Episode: episodeToProto(episode),
	}), nil
}

func (h *Handler) GetIcuEpisode(ctx context.Context,
	req *connect.Request[icuv1.GetIcuEpisodeRequest]) (
	*connect.Response[icuv1.GetIcuEpisodeResponse], error) {

	episodeID := req.Msg.GetEpisodeId()
	now := h.now()

	episode, err := h.svc.Episode(ctx, episodeID)
	if err != nil {
		return nil, err
	}
	support, err := h.svc.Support(ctx, episodeID)
	if err != nil {
		return nil, err
	}
	devices, err := h.svc.Devices(ctx, episodeID)
	if err != nil {
		return nil, err
	}
	infusions, err := h.svc.Infusions(ctx, episodeID)
	if err != nil {
		return nil, err
	}
	goals, err := h.svc.OpenGoals(ctx, episodeID)
	if err != nil {
		return nil, err
	}

	out := &icuv1.GetIcuEpisodeResponse{Episode: episodeToProto(episode)}
	for _, item := range support {
		out.Support = append(out.Support, supportToProto(item))
	}
	for _, device := range devices {
		out.Devices = append(out.Devices, invasiveDeviceToProto(device, now))
	}
	for _, infusion := range infusions {
		out.Infusions = append(out.Infusions, infusionToProto(infusion))
	}
	for _, goal := range goals {
		out.OpenGoals = append(out.OpenGoals, goalToProto(goal))
	}

	// The ceiling is fetched separately because reading one is separately
	// permitted and separately audited. A caller without the permission gets
	// the flag rather than a blank field: an absent ceiling means none was
	// agreed, and the difference is what gets a patient resuscitated against
	// their wishes.
	current, _, err := h.svc.Ceiling(ctx, episodeID)
	switch {
	case err == nil:
		out.Ceiling = ceilingToProto(current, now)
	case connect.CodeOf(err) == connect.CodePermissionDenied:
		out.CeilingRestricted = true
	default:
		return nil, err
	}

	return connect.NewResponse(out), nil
}

func (h *Handler) MoveBed(ctx context.Context, req *connect.Request[icuv1.MoveBedRequest]) (
	*connect.Response[icuv1.MoveBedResponse], error) {

	episode, err := h.svc.Move(ctx, application.MoveInput{
		EpisodeID: req.Msg.GetEpisodeId(), BedID: req.Msg.GetBedId(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&icuv1.MoveBedResponse{
		Episode: episodeToProto(episode),
	}), nil
}

func (h *Handler) DeclareReady(ctx context.Context,
	req *connect.Request[icuv1.DeclareReadyRequest]) (
	*connect.Response[icuv1.DeclareReadyResponse], error) {

	episode, err := h.svc.DeclareReady(ctx, req.Msg.GetEpisodeId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&icuv1.DeclareReadyResponse{
		Episode: episodeToProto(episode),
	}), nil
}

func (h *Handler) Discharge(ctx context.Context,
	req *connect.Request[icuv1.DischargeRequest]) (
	*connect.Response[icuv1.DischargeResponse], error) {

	msg := req.Msg
	episode, err := h.svc.Discharge(ctx, application.DischargeInput{
		EpisodeID: msg.GetEpisodeId(), Outcome: outcome(msg.GetOutcome()),
		Note: msg.GetNote(),
		Evidence: domain.HandoverEvidence{
			MedicationsReconciled: msg.GetMedicationsReconciled(),
			DevicesListed:         msg.GetDevicesListed(),
			TasksHandedOver:       msg.GetTasksHandedOver(),
			SummaryWritten:        msg.GetSummaryWritten(),
		},
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&icuv1.DischargeResponse{
		Episode: episodeToProto(episode),
	}), nil
}

func (h *Handler) ChartValue(ctx context.Context,
	req *connect.Request[icuv1.ChartValueRequest]) (
	*connect.Response[icuv1.ChartValueResponse], error) {

	msg := req.Msg
	observation, err := h.svc.Chart(ctx, application.ChartInput{
		EpisodeID: msg.GetEpisodeId(), CodeSystem: msg.GetCodeSystem(),
		Code: msg.GetCode(), Display: msg.GetDisplay(),
		Dimension: domain.Dimension(msg.GetDimension()),
		Value:     msg.GetValue(), Unit: msg.GetUnit(),
		Source:     observationSource(msg.GetSource()),
		Device:     deviceSourceFromProto(msg.GetDevice()),
		ObservedAt: timeOf(msg.GetObservedAt()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&icuv1.ChartValueResponse{
		Observation: observationToProto(observation),
	}), nil
}

func (h *Handler) DecideReading(ctx context.Context,
	req *connect.Request[icuv1.DecideReadingRequest]) (
	*connect.Response[icuv1.DecideReadingResponse], error) {

	observation, err := h.svc.Decide(ctx, application.DecideInput{
		ObservationID: req.Msg.GetObservationId(),
		Accept:        req.Msg.GetAccept(), Note: req.Msg.GetNote(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&icuv1.DecideReadingResponse{
		Observation: observationToProto(observation),
	}), nil
}

func (h *Handler) ListFlowsheet(ctx context.Context,
	req *connect.Request[icuv1.ListFlowsheetRequest]) (
	*connect.Response[icuv1.ListFlowsheetResponse], error) {

	list, err := h.svc.Flowsheet(ctx, req.Msg.GetEpisodeId(),
		timeOf(req.Msg.GetSince()), req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	out := &icuv1.ListFlowsheetResponse{}
	for _, observation := range list {
		out.Observations = append(out.Observations, observationToProto(observation))
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) ListPendingReadings(ctx context.Context,
	req *connect.Request[icuv1.ListPendingReadingsRequest]) (
	*connect.Response[icuv1.ListPendingReadingsResponse], error) {

	list, err := h.svc.PendingReadings(ctx, req.Msg.GetEpisodeId(),
		req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	out := &icuv1.ListPendingReadingsResponse{}
	for _, observation := range list {
		out.Observations = append(out.Observations, observationToProto(observation))
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) RecordBalance(ctx context.Context,
	req *connect.Request[icuv1.RecordBalanceRequest]) (
	*connect.Response[icuv1.RecordBalanceResponse], error) {

	msg := req.Msg
	entry, err := h.svc.RecordBalance(ctx, application.BalanceInput{
		EpisodeID: msg.GetEpisodeId(),
		Direction: domain.BalanceDirection(msg.GetDirection()),
		Route:     msg.GetRoute(), Volume: msg.GetVolume(), Unit: msg.GetUnit(),
		OccurredAt: timeOf(msg.GetOccurredAt()),
		Corrects:   msg.GetCorrects(), CorrectionReason: msg.GetCorrectionReason(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&icuv1.RecordBalanceResponse{
		Entry: balanceEntryToProto(entry),
	}), nil
}

func (h *Handler) GetBalance(ctx context.Context,
	req *connect.Request[icuv1.GetBalanceRequest]) (
	*connect.Response[icuv1.GetBalanceResponse], error) {

	total, hourly, err := h.svc.Balance(ctx, req.Msg.GetEpisodeId(),
		timeOf(req.Msg.GetFrom()), timeOf(req.Msg.GetTo()))
	if err != nil {
		return nil, err
	}
	out := &icuv1.GetBalanceResponse{Total: balanceToProto(total)}
	for _, hour := range hourly {
		out.Hourly = append(out.Hourly, balanceToProto(hour))
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) StartSupport(ctx context.Context,
	req *connect.Request[icuv1.StartSupportRequest]) (
	*connect.Response[icuv1.StartSupportResponse], error) {

	msg := req.Msg
	support, err := h.svc.StartSupport(ctx, application.StartSupportInput{
		EpisodeID: msg.GetEpisodeId(), Kind: supportKindFromWire[msg.GetKind()],
		Label: msg.GetLabel(), Modality: msg.GetModality(),
		StartedAt: timeOf(msg.GetStartedAt()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&icuv1.StartSupportResponse{
		Support: supportToProto(support),
	}), nil
}

func (h *Handler) StopSupport(ctx context.Context,
	req *connect.Request[icuv1.StopSupportRequest]) (
	*connect.Response[icuv1.StopSupportResponse], error) {

	if err := h.svc.StopSupport(ctx, application.StopSupportInput{
		SupportID: req.Msg.GetSupportId(), Note: req.Msg.GetNote(),
		StoppedAt: timeOf(req.Msg.GetStoppedAt()),
	}); err != nil {
		return nil, err
	}
	return connect.NewResponse(&icuv1.StopSupportResponse{}), nil
}

func (h *Handler) ListSupport(ctx context.Context,
	req *connect.Request[icuv1.ListSupportRequest]) (
	*connect.Response[icuv1.ListSupportResponse], error) {

	support, err := h.svc.Support(ctx, req.Msg.GetEpisodeId())
	if err != nil {
		return nil, err
	}
	out := &icuv1.ListSupportResponse{}
	for _, item := range support {
		out.Support = append(out.Support, supportToProto(item))
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) RecordVentSetting(ctx context.Context,
	req *connect.Request[icuv1.RecordVentSettingRequest]) (
	*connect.Response[icuv1.RecordVentSettingResponse], error) {

	msg := req.Msg
	setting, err := h.svc.RecordVentSetting(ctx, application.VentSettingInput{
		EpisodeID: msg.GetEpisodeId(), SupportID: msg.GetSupportId(),
		Mode: msg.GetMode(), Parameters: msg.GetParameters(),
		Measured: msg.GetMeasured(), Units: msg.GetUnits(),
		DeviceID: msg.GetDeviceId(), EffectiveAt: timeOf(msg.GetEffectiveAt()),
		ChangeReason: msg.GetChangeReason(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&icuv1.RecordVentSettingResponse{
		Setting: ventSettingToProto(setting),
	}), nil
}

func (h *Handler) GetVentTimeline(ctx context.Context,
	req *connect.Request[icuv1.GetVentTimelineRequest]) (
	*connect.Response[icuv1.GetVentTimelineResponse], error) {

	timeline, err := h.svc.VentTimeline(ctx, req.Msg.GetEpisodeId())
	if err != nil {
		return nil, err
	}
	out := &icuv1.GetVentTimelineResponse{}
	for _, setting := range timeline {
		out.Settings = append(out.Settings, ventSettingToProto(setting))
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) StartInfusion(ctx context.Context,
	req *connect.Request[icuv1.StartInfusionRequest]) (
	*connect.Response[icuv1.StartInfusionResponse], error) {

	msg := req.Msg
	infusion, err := h.svc.StartInfusion(ctx, application.StartInfusionInput{
		EpisodeID: msg.GetEpisodeId(), PrescriptionID: msg.GetPrescriptionId(),
		DrugCode: msg.GetDrugCode(), DrugDisplay: msg.GetDrugDisplay(),
		ConcentrationAmount: msg.GetConcentrationAmount(),
		ConcentrationUnit:   msg.GetConcentrationUnit(),
		ConcentrationVolume: msg.GetConcentrationVolume(),
		DoseUnit:            msg.GetDoseUnit(), WeightKg: msg.GetWeightKg(),
		StartedAt: timeOf(msg.GetStartedAt()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&icuv1.StartInfusionResponse{
		Infusion: infusionToProto(infusion),
	}), nil
}

func (h *Handler) Titrate(ctx context.Context, req *connect.Request[icuv1.TitrateRequest]) (
	*connect.Response[icuv1.TitrateResponse], error) {

	msg := req.Msg
	titration, err := h.svc.Titrate(ctx, application.TitrateInput{
		InfusionID: msg.GetInfusionId(), Rate: msg.GetRate(),
		RateUnit: msg.GetRateUnit(), Dose: msg.GetDose(),
		EffectiveAt: timeOf(msg.GetEffectiveAt()),
		DeviceID:    msg.GetDeviceId(), Reason: msg.GetReason(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&icuv1.TitrateResponse{
		Titration: titrationToProto(titration),
	}), nil
}

func (h *Handler) StopInfusion(ctx context.Context,
	req *connect.Request[icuv1.StopInfusionRequest]) (
	*connect.Response[icuv1.StopInfusionResponse], error) {

	if err := h.svc.StopInfusion(ctx, req.Msg.GetInfusionId()); err != nil {
		return nil, err
	}
	return connect.NewResponse(&icuv1.StopInfusionResponse{}), nil
}

func (h *Handler) ListInfusions(ctx context.Context,
	req *connect.Request[icuv1.ListInfusionsRequest]) (
	*connect.Response[icuv1.ListInfusionsResponse], error) {

	infusions, err := h.svc.Infusions(ctx, req.Msg.GetEpisodeId())
	if err != nil {
		return nil, err
	}
	out := &icuv1.ListInfusionsResponse{}
	for _, infusion := range infusions {
		out.Infusions = append(out.Infusions, infusionToProto(infusion))
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) InsertDevice(ctx context.Context,
	req *connect.Request[icuv1.InsertDeviceRequest]) (
	*connect.Response[icuv1.InsertDeviceResponse], error) {

	msg := req.Msg
	device, err := h.svc.InsertDevice(ctx, application.InsertDeviceInput{
		EpisodeID: msg.GetEpisodeId(), Kind: msg.GetKind(), Site: msg.GetSite(),
		Lumens: int(msg.GetLumens()), InsertedAt: timeOf(msg.GetInsertedAt()),
		ReviewEvery: time.Duration(msg.GetReviewEverySeconds()) * time.Second,
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&icuv1.InsertDeviceResponse{
		Device: invasiveDeviceToProto(device, h.now()),
	}), nil
}

func (h *Handler) RemoveDevice(ctx context.Context,
	req *connect.Request[icuv1.RemoveDeviceRequest]) (
	*connect.Response[icuv1.RemoveDeviceResponse], error) {

	if err := h.svc.RemoveDevice(ctx, application.RemoveDeviceInput{
		DeviceID: req.Msg.GetDeviceId(), Reason: req.Msg.GetReason(),
		RemovedAt: timeOf(req.Msg.GetRemovedAt()),
	}); err != nil {
		return nil, err
	}
	return connect.NewResponse(&icuv1.RemoveDeviceResponse{}), nil
}

func (h *Handler) ReviewDevice(ctx context.Context,
	req *connect.Request[icuv1.ReviewDeviceRequest]) (
	*connect.Response[icuv1.ReviewDeviceResponse], error) {

	if err := h.svc.ReviewDevice(ctx, req.Msg.GetDeviceId()); err != nil {
		return nil, err
	}
	return connect.NewResponse(&icuv1.ReviewDeviceResponse{}), nil
}

func (h *Handler) ListDevices(ctx context.Context,
	req *connect.Request[icuv1.ListDevicesRequest]) (
	*connect.Response[icuv1.ListDevicesResponse], error) {

	devices, err := h.svc.Devices(ctx, req.Msg.GetEpisodeId())
	if err != nil {
		return nil, err
	}
	now := h.now()
	out := &icuv1.ListDevicesResponse{}
	for _, device := range devices {
		out.Devices = append(out.Devices, invasiveDeviceToProto(device, now))
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) CalculateScore(ctx context.Context,
	req *connect.Request[icuv1.CalculateScoreRequest]) (
	*connect.Response[icuv1.CalculateScoreResponse], error) {

	score, err := h.svc.CalculateScore(ctx, req.Msg.GetEpisodeId(),
		req.Msg.GetFormulaName())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&icuv1.CalculateScoreResponse{
		Score: scoreToProto(score),
	}), nil
}

func (h *Handler) ListScores(ctx context.Context,
	req *connect.Request[icuv1.ListScoresRequest]) (
	*connect.Response[icuv1.ListScoresResponse], error) {

	scores, err := h.svc.Scores(ctx, req.Msg.GetEpisodeId(), req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	out := &icuv1.ListScoresResponse{}
	for _, score := range scores {
		out.Scores = append(out.Scores, scoreToProto(score))
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) ReproduceScore(ctx context.Context,
	req *connect.Request[icuv1.ReproduceScoreRequest]) (
	*connect.Response[icuv1.ReproduceScoreResponse], error) {

	stored, reproduced, err := h.svc.ReproduceScore(ctx, req.Msg.GetEpisodeId(),
		req.Msg.GetScoreId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&icuv1.ReproduceScoreResponse{
		StoredTotal: int32(stored), ReproducedTotal: int32(reproduced),
		Reproduced: stored == reproduced,
	}), nil
}

func (h *Handler) PerformBundle(ctx context.Context,
	req *connect.Request[icuv1.PerformBundleRequest]) (
	*connect.Response[icuv1.PerformBundleResponse], error) {

	results := make([]domain.BundleResult, 0, len(req.Msg.GetResults()))
	for _, result := range req.Msg.GetResults() {
		results = append(results, domain.BundleResult{
			Code: result.GetCode(), State: itemState(result.GetState()),
			Reason: result.GetReason(),
		})
	}

	run, compliance, err := h.svc.PerformBundle(ctx, application.PerformBundleInput{
		EpisodeID: req.Msg.GetEpisodeId(),
		Kind:      bundleKindFromWire[req.Msg.GetKind()],
		Results:   results,
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&icuv1.PerformBundleResponse{
		Performance: bundleToProto(run, compliance),
	}), nil
}

func (h *Handler) ListBundles(ctx context.Context,
	req *connect.Request[icuv1.ListBundlesRequest]) (
	*connect.Response[icuv1.ListBundlesResponse], error) {

	runs, err := h.svc.Bundles(ctx, req.Msg.GetEpisodeId(), req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	out := &icuv1.ListBundlesResponse{}
	for _, run := range runs {
		out.Performances = append(out.Performances,
			bundleToProto(run.Performance, run.Compliance))
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) RecordAssessment(ctx context.Context,
	req *connect.Request[icuv1.RecordAssessmentRequest]) (
	*connect.Response[icuv1.RecordAssessmentResponse], error) {

	msg := req.Msg
	in := application.AssessInput{
		EpisodeID: msg.GetEpisodeId(),
		Kind:      domain.AssessmentKind(msg.GetKind()),
		Scale:     msg.GetScale(), Findings: msg.GetFindings(), Note: msg.GetNote(),
		PerformedAt: timeOf(msg.GetPerformedAt()),
		Every:       time.Duration(msg.GetEverySeconds()) * time.Second,
	}
	if msg.Score != nil {
		score := int(msg.GetScore())
		in.Score = &score
	}

	assessment, err := h.svc.Assess(ctx, in)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&icuv1.RecordAssessmentResponse{
		Assessment: assessmentToProto(assessment, h.now()),
	}), nil
}

func (h *Handler) ListDueAssessments(ctx context.Context,
	req *connect.Request[icuv1.ListDueAssessmentsRequest]) (
	*connect.Response[icuv1.ListDueAssessmentsResponse], error) {

	assessments, err := h.svc.DueAssessments(ctx, req.Msg.GetEpisodeId())
	if err != nil {
		return nil, err
	}
	now := h.now()
	out := &icuv1.ListDueAssessmentsResponse{}
	for _, assessment := range assessments {
		out.Assessments = append(out.Assessments, assessmentToProto(assessment, now))
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) RecordRound(ctx context.Context,
	req *connect.Request[icuv1.RecordRoundRequest]) (
	*connect.Response[icuv1.RecordRoundResponse], error) {

	goals := make([]application.GoalInput, 0, len(req.Msg.GetGoals()))
	for _, goal := range req.Msg.GetGoals() {
		goals = append(goals, application.GoalInput{
			Domain: goal.GetDomain(), Text: goal.GetText(),
			OwnerRole: goal.GetOwnerRole(), OwnerID: goal.GetOwnerId(),
			TargetAt: timeOf(goal.GetTargetAt()),
		})
	}

	round, recorded, err := h.svc.Round(ctx, application.RoundInput{
		EpisodeID: req.Msg.GetEpisodeId(), Attendance: req.Msg.GetAttendance(),
		Summary: req.Msg.GetSummary(), Goals: goals,
	})
	if err != nil {
		return nil, err
	}

	out := &icuv1.RecordRoundResponse{Round: roundToProto(round)}
	for _, goal := range recorded {
		out.Goals = append(out.Goals, goalToProto(goal))
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) ResolveGoal(ctx context.Context,
	req *connect.Request[icuv1.ResolveGoalRequest]) (
	*connect.Response[icuv1.ResolveGoalResponse], error) {

	if err := h.svc.ResolveGoal(ctx, application.ResolveGoalInput{
		EpisodeID: req.Msg.GetEpisodeId(), GoalID: req.Msg.GetGoalId(),
		Status:  goalStatusFromWire[req.Msg.GetStatus()],
		Outcome: req.Msg.GetOutcome(),
	}); err != nil {
		return nil, err
	}
	return connect.NewResponse(&icuv1.ResolveGoalResponse{}), nil
}

func (h *Handler) ListOpenGoals(ctx context.Context,
	req *connect.Request[icuv1.ListOpenGoalsRequest]) (
	*connect.Response[icuv1.ListOpenGoalsResponse], error) {

	goals, err := h.svc.OpenGoals(ctx, req.Msg.GetEpisodeId())
	if err != nil {
		return nil, err
	}
	out := &icuv1.ListOpenGoalsResponse{}
	for _, goal := range goals {
		out.Goals = append(out.Goals, goalToProto(goal))
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) SetCeiling(ctx context.Context,
	req *connect.Request[icuv1.SetCeilingRequest]) (
	*connect.Response[icuv1.SetCeilingResponse], error) {

	msg := req.Msg
	ceiling, err := h.svc.SetCeiling(ctx, application.CeilingInput{
		EpisodeID: msg.GetEpisodeId(), Intent: careIntent(msg.GetIntent()),
		Limitations: msg.GetLimitations(), CPRStatus: msg.GetCprStatus(),
		DiscussedWith: msg.GetDiscussedWith(), Rationale: msg.GetRationale(),
		AuthorisedBy: msg.GetAuthorisedBy(), AuthorisedRole: msg.GetAuthorisedRole(),
		ReviewBy: timeOf(msg.GetReviewBy()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&icuv1.SetCeilingResponse{
		Ceiling: ceilingToProto(ceiling, h.now()),
	}), nil
}

func (h *Handler) GetCeiling(ctx context.Context,
	req *connect.Request[icuv1.GetCeilingRequest]) (
	*connect.Response[icuv1.GetCeilingResponse], error) {

	current, history, err := h.svc.Ceiling(ctx, req.Msg.GetEpisodeId())
	if err != nil {
		return nil, err
	}
	now := h.now()
	out := &icuv1.GetCeilingResponse{Current: ceilingToProto(current, now)}
	for _, ceiling := range history {
		out.History = append(out.History, ceilingToProto(ceiling, now))
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) GetDashboard(ctx context.Context,
	req *connect.Request[icuv1.GetDashboardRequest]) (
	*connect.Response[icuv1.GetDashboardResponse], error) {

	rows, err := h.svc.Dashboard(ctx, application.DashboardInput{
		UnitID: req.Msg.GetUnitId(), PageSize: req.Msg.GetPageSize(),
		BalanceWindow: time.Duration(req.Msg.GetBalanceWindowSeconds()) * time.Second,
	})
	if err != nil {
		return nil, err
	}
	out := &icuv1.GetDashboardResponse{}
	for _, row := range rows {
		out.Rows = append(out.Rows, dashboardRowToProto(row))
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) ListAdvisories(ctx context.Context,
	req *connect.Request[icuv1.ListAdvisoriesRequest]) (
	*connect.Response[icuv1.ListAdvisoriesResponse], error) {

	alarms, err := h.svc.Advisories(ctx, req.Msg.GetEpisodeId())
	if err != nil {
		return nil, err
	}
	out := &icuv1.ListAdvisoriesResponse{}
	for _, alarm := range alarms {
		out.Alarms = append(out.Alarms, alarmToProto(alarm))
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) EscalateAdvisory(ctx context.Context,
	req *connect.Request[icuv1.EscalateAdvisoryRequest]) (
	*connect.Response[icuv1.EscalateAdvisoryResponse], error) {

	noticeID, err := h.svc.EscalateAdvisory(ctx, req.Msg.GetEpisodeId(),
		req.Msg.GetKind(), req.Msg.GetSummary())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&icuv1.EscalateAdvisoryResponse{
		NoticeId: noticeID,
	}), nil
}

func (h *Handler) GetUnitMetrics(ctx context.Context,
	req *connect.Request[icuv1.GetUnitMetricsRequest]) (
	*connect.Response[icuv1.GetUnitMetricsResponse], error) {

	metrics, err := h.svc.Metrics(ctx, req.Msg.GetUnitId(),
		timeOf(req.Msg.GetFrom()), timeOf(req.Msg.GetTo()))
	if err != nil {
		return nil, err
	}

	deviceDays := make(map[string]int32, len(metrics.DeviceDays))
	for kind, days := range metrics.DeviceDays {
		deviceDays[kind] = int32(days)
	}

	return connect.NewResponse(&icuv1.GetUnitMetricsResponse{
		Metrics: &icuv1.UnitMetrics{
			UnitId: metrics.UnitID, From: stamp(metrics.From), To: stamp(metrics.To),
			Admissions:              int32(metrics.Admissions),
			Discharges:              int32(metrics.Discharges),
			Deaths:                  int32(metrics.Deaths),
			BedDays:                 int32(metrics.BedDays),
			VentilatorDays:          int32(metrics.VentilatorDays),
			DeviceDays:              deviceDays,
			MeanLengthOfStayHours:   metrics.MeanLengthOfStayHours,
			ClosedEpisodes:          int32(metrics.ClosedEpisodes),
			MeanDischargeDelayHours: metrics.MeanDischargeDelayHours,
			DelayedDischarges:       int32(metrics.DelayedDischarges),
		},
	}), nil
}
