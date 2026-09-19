package transport

import (
	"context"
	"time"

	"connectrpc.com/connect"

	biomedicalv1 "github.com/ppusapati/health/code/gen/go/healthcare/biomedical/v1"
	"github.com/ppusapati/health/code/internal/biomedical/application"
	"github.com/ppusapati/health/code/internal/biomedical/domain"
)

// Handler is the biomedical ConnectRPC surface.
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
// The clock is injected because an asset's usability is derived at the moment
// of rendering rather than stored: a calibration that lapsed an hour ago has
// lapsed whether or not a job has run.
func NewHandler(svc *application.Service, now func() time.Time) *Handler {
	if now == nil {
		now = time.Now
	}
	return &Handler{svc: svc, now: now}
}

func (h *Handler) asset(a domain.Asset) *biomedicalv1.Asset {
	return assetToProto(a, h.now(), h.svc.BlocksOnCalibration())
}

func (h *Handler) assets(in []domain.Asset) []*biomedicalv1.Asset {
	now, blocks := h.now(), h.svc.BlocksOnCalibration()
	out := make([]*biomedicalv1.Asset, 0, len(in))
	for _, a := range in {
		out = append(out, assetToProto(a, now, blocks))
	}
	return out
}

func (h *Handler) RegisterAsset(ctx context.Context,
	req *connect.Request[biomedicalv1.RegisterAssetRequest]) (
	*connect.Response[biomedicalv1.RegisterAssetResponse], error) {

	msg := req.Msg
	asset, err := h.svc.RegisterAsset(ctx, domain.NewAssetInput{
		Tag: msg.GetTag(), UDI: msg.GetUdi(), Serial: msg.GetSerial(),
		Make: msg.GetMake(), Model: msg.GetModel(),
		Category:    msg.GetCategory(),
		Criticality: criticalityFromWire[msg.GetCriticality()],
		LocationID:  msg.GetLocationId(), Department: msg.GetDepartment(),
		Capabilities:         msg.GetCapabilities(),
		AcquiredOn:           timeOf(msg.GetAcquiredOn()),
		AcquisitionCostMinor: msg.GetAcquisitionCostMinor(),
		ExpectedLifeYears:    int(msg.GetExpectedLifeYears()),
		CalibrationRequired:  msg.GetCalibrationRequired(),
		CalibrationDue:       timeOf(msg.GetCalibrationDue()),
		Notes:                msg.GetNotes(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.RegisterAssetResponse{
		Asset: h.asset(asset),
	}), nil
}

func (h *Handler) GetAsset(ctx context.Context,
	req *connect.Request[biomedicalv1.GetAssetRequest]) (
	*connect.Response[biomedicalv1.GetAssetResponse], error) {

	asset, err := h.svc.Asset(ctx, req.Msg.GetAssetId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.GetAssetResponse{
		Asset: h.asset(asset),
	}), nil
}

func (h *Handler) GetAssetByTag(ctx context.Context,
	req *connect.Request[biomedicalv1.GetAssetByTagRequest]) (
	*connect.Response[biomedicalv1.GetAssetByTagResponse], error) {

	asset, err := h.svc.AssetByTag(ctx, req.Msg.GetTag())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.GetAssetByTagResponse{
		Asset: h.asset(asset),
	}), nil
}

func (h *Handler) ListAssets(ctx context.Context,
	req *connect.Request[biomedicalv1.ListAssetsRequest]) (
	*connect.Response[biomedicalv1.ListAssetsResponse], error) {

	msg := req.Msg
	assets, err := h.svc.Assets(ctx, application.AssetFilter{
		Category:       msg.GetCategory(),
		Status:         string(assetStatusFromWire[msg.GetStatus()]),
		ExcludeRetired: msg.GetExcludeRetired(),
		PageSize:       msg.GetPageSize(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.ListAssetsResponse{
		Assets: h.assets(assets),
	}), nil
}

func (h *Handler) MoveAsset(ctx context.Context,
	req *connect.Request[biomedicalv1.MoveAssetRequest]) (
	*connect.Response[biomedicalv1.MoveAssetResponse], error) {

	msg := req.Msg
	asset, err := h.svc.MoveAsset(ctx, application.MoveAssetInput{
		AssetID:         msg.GetAssetId(),
		Status:          assetStatusFromWire[msg.GetStatus()],
		LocationID:      msg.GetLocationId(),
		ClearLocation:   msg.GetClearLocation(),
		Department:      msg.GetDepartment(),
		Note:            msg.GetNote(),
		ExpectedVersion: msg.GetExpectedVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.MoveAssetResponse{
		Asset: h.asset(asset),
	}), nil
}

func (h *Handler) RecordCalibration(ctx context.Context,
	req *connect.Request[biomedicalv1.RecordCalibrationRequest]) (
	*connect.Response[biomedicalv1.RecordCalibrationResponse], error) {

	msg := req.Msg
	asset, err := h.svc.RecordCalibration(ctx, application.CalibrationInput{
		AssetID: msg.GetAssetId(), Certificate: msg.GetCertificate(),
		NextDue:         timeOf(msg.GetNextDue()),
		ExpectedVersion: msg.GetExpectedVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.RecordCalibrationResponse{
		Asset: h.asset(asset),
	}), nil
}

func (h *Handler) HoldAsset(ctx context.Context,
	req *connect.Request[biomedicalv1.HoldAssetRequest]) (
	*connect.Response[biomedicalv1.HoldAssetResponse], error) {

	msg := req.Msg
	asset, err := h.svc.HoldAsset(ctx, application.HoldInput{
		AssetID: msg.GetAssetId(), Reason: msg.GetReason(),
		ExpectedVersion: msg.GetExpectedVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.HoldAssetResponse{
		Asset: h.asset(asset),
	}), nil
}

func (h *Handler) ReleaseAsset(ctx context.Context,
	req *connect.Request[biomedicalv1.ReleaseAssetRequest]) (
	*connect.Response[biomedicalv1.ReleaseAssetResponse], error) {

	msg := req.Msg
	asset, err := h.svc.ReleaseAsset(ctx, application.HoldInput{
		AssetID: msg.GetAssetId(), Reason: msg.GetReason(),
		ExpectedVersion: msg.GetExpectedVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.ReleaseAssetResponse{
		Asset: h.asset(asset),
	}), nil
}

func (h *Handler) GetLocationCapability(ctx context.Context,
	req *connect.Request[biomedicalv1.GetLocationCapabilityRequest]) (
	*connect.Response[biomedicalv1.GetLocationCapabilityResponse], error) {

	capability, err := h.svc.LocationCapability(ctx, req.Msg.GetLocationId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(capabilityToProto(capability)), nil
}

func (h *Handler) RecordContract(ctx context.Context,
	req *connect.Request[biomedicalv1.RecordContractRequest]) (
	*connect.Response[biomedicalv1.RecordContractResponse], error) {

	msg := req.Msg
	contract, err := h.svc.RecordContract(ctx, domain.NewContractInput{
		AssetID:    msg.GetAssetId(),
		Kind:       contractKindFromWire[msg.GetKind()],
		Reference:  msg.GetReference(),
		VendorName: msg.GetVendorName(), VendorContact: msg.GetVendorContact(),
		VendorPhone: msg.GetVendorPhone(), VendorEmail: msg.GetVendorEmail(),
		StartsOn: timeOf(msg.GetStartsOn()), EndsOn: timeOf(msg.GetEndsOn()),
		ValueMinor:      msg.GetValueMinor(),
		ResponseHours:   int(msg.GetResponseHours()),
		ResolutionHours: int(msg.GetResolutionHours()),
		Notes:           msg.GetNotes(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.RecordContractResponse{
		Contract: contractToProto(contract),
	}), nil
}

func (h *Handler) GetContract(ctx context.Context,
	req *connect.Request[biomedicalv1.GetContractRequest]) (
	*connect.Response[biomedicalv1.GetContractResponse], error) {

	contract, err := h.svc.Contract(ctx, req.Msg.GetContractId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.GetContractResponse{
		Contract: contractToProto(contract),
	}), nil
}

func (h *Handler) ListContractsForAsset(ctx context.Context,
	req *connect.Request[biomedicalv1.ListContractsForAssetRequest]) (
	*connect.Response[biomedicalv1.ListContractsForAssetResponse], error) {

	contracts, err := h.svc.ContractsForAsset(ctx, req.Msg.GetAssetId())
	if err != nil {
		return nil, err
	}
	out := make([]*biomedicalv1.ServiceContract, 0, len(contracts))
	for _, contract := range contracts {
		out = append(out, contractToProto(contract))
	}
	return connect.NewResponse(&biomedicalv1.ListContractsForAssetResponse{
		Contracts: out,
	}), nil
}

func (h *Handler) GetCoverForAsset(ctx context.Context,
	req *connect.Request[biomedicalv1.GetCoverForAssetRequest]) (
	*connect.Response[biomedicalv1.GetCoverForAssetResponse], error) {

	contract, covered, err := h.svc.CoverForAsset(ctx, req.Msg.GetAssetId())
	if err != nil {
		return nil, err
	}
	out := &biomedicalv1.GetCoverForAssetResponse{Covered: covered}
	if covered {
		out.Contract = contractToProto(contract)
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) ListExpiryReminders(ctx context.Context,
	req *connect.Request[biomedicalv1.ListExpiryRemindersRequest]) (
	*connect.Response[biomedicalv1.ListExpiryRemindersResponse], error) {

	expiries, err := h.svc.ExpiryReminders(ctx, req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	out := make([]*biomedicalv1.Expiry, 0, len(expiries))
	for _, expiry := range expiries {
		out = append(out, expiryToProto(expiry))
	}
	return connect.NewResponse(&biomedicalv1.ListExpiryRemindersResponse{
		Expiries: out,
	}), nil
}

func (h *Handler) SchedulePlan(ctx context.Context,
	req *connect.Request[biomedicalv1.SchedulePlanRequest]) (
	*connect.Response[biomedicalv1.SchedulePlanResponse], error) {

	msg := req.Msg
	plan, err := h.svc.SchedulePlan(ctx, domain.NewPlanInput{
		AssetID:          msg.GetAssetId(),
		Basis:            planBasisFromWire[msg.GetBasis()],
		IntervalDays:     int(msg.GetIntervalDays()),
		RuntimeHours:     int(msg.GetRuntimeHours()),
		Procedure:        msg.GetProcedure(),
		EstimatedMinutes: int(msg.GetEstimatedMinutes()),
		LastPerformedAt:  timeOf(msg.GetLastPerformedAt()),
		LastRuntimeHours: int(msg.GetLastRuntimeHours()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.SchedulePlanResponse{
		Plan: planToProto(plan),
	}), nil
}

func (h *Handler) RetirePlan(ctx context.Context,
	req *connect.Request[biomedicalv1.RetirePlanRequest]) (
	*connect.Response[biomedicalv1.RetirePlanResponse], error) {

	plan, err := h.svc.RetirePlan(ctx, req.Msg.GetPlanId(),
		req.Msg.GetExpectedVersion())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.RetirePlanResponse{
		Plan: planToProto(plan),
	}), nil
}

func (h *Handler) ListPlans(ctx context.Context,
	req *connect.Request[biomedicalv1.ListPlansRequest]) (
	*connect.Response[biomedicalv1.ListPlansResponse], error) {

	msg := req.Msg
	plans, err := h.svc.Plans(ctx, msg.GetAssetId(), msg.GetActiveOnly(),
		msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	out := make([]*biomedicalv1.PMPlan, 0, len(plans))
	for _, plan := range plans {
		out = append(out, planToProto(plan))
	}
	return connect.NewResponse(&biomedicalv1.ListPlansResponse{Plans: out}), nil
}

func (h *Handler) ListDueMaintenance(ctx context.Context,
	req *connect.Request[biomedicalv1.ListDueMaintenanceRequest]) (
	*connect.Response[biomedicalv1.ListDueMaintenanceResponse], error) {

	due, err := h.svc.DueMaintenance(ctx, req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	out := make([]*biomedicalv1.Due, 0, len(due))
	for _, one := range due {
		out = append(out, dueToProto(one))
	}
	return connect.NewResponse(&biomedicalv1.ListDueMaintenanceResponse{
		Due: out,
	}), nil
}

func (h *Handler) RaiseTicket(ctx context.Context,
	req *connect.Request[biomedicalv1.RaiseTicketRequest]) (
	*connect.Response[biomedicalv1.RaiseTicketResponse], error) {

	msg := req.Msg
	ticket, err := h.svc.RaiseTicket(ctx, domain.NewTicketInput{
		Number:  msg.GetNumber(),
		Kind:    ticketKindFromWire[msg.GetKind()],
		AssetID: msg.GetAssetId(), PlanID: msg.GetPlanId(),
		Symptom:  msg.GetSymptom(),
		Priority: priorityFromWire[msg.GetPriority()],
		Impact:   impactFromWire[msg.GetImpact()],
		DownFrom: timeOf(msg.GetDownFrom()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.RaiseTicketResponse{
		Ticket: ticketToProto(ticket),
	}), nil
}

func (h *Handler) GetTicket(ctx context.Context,
	req *connect.Request[biomedicalv1.GetTicketRequest]) (
	*connect.Response[biomedicalv1.GetTicketResponse], error) {

	ticket, err := h.svc.Ticket(ctx, req.Msg.GetTicketId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.GetTicketResponse{
		Ticket: ticketToProto(ticket),
	}), nil
}

func (h *Handler) ListTickets(ctx context.Context,
	req *connect.Request[biomedicalv1.ListTicketsRequest]) (
	*connect.Response[biomedicalv1.ListTicketsResponse], error) {

	msg := req.Msg
	tickets, err := h.svc.Tickets(ctx, application.TicketFilter{
		AssetID:  msg.GetAssetId(),
		State:    string(ticketStateFromWire[msg.GetState()]),
		OpenOnly: msg.GetOpenOnly(), PageSize: msg.GetPageSize(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*biomedicalv1.Ticket, 0, len(tickets))
	for _, ticket := range tickets {
		out = append(out, ticketToProto(ticket))
	}
	return connect.NewResponse(&biomedicalv1.ListTicketsResponse{
		Tickets: out,
	}), nil
}

func (h *Handler) AssignTicket(ctx context.Context,
	req *connect.Request[biomedicalv1.AssignTicketRequest]) (
	*connect.Response[biomedicalv1.AssignTicketResponse], error) {

	msg := req.Msg
	ticket, err := h.svc.AssignTicket(ctx, msg.GetTicketId(), msg.GetOwnerId(),
		msg.GetExpectedVersion())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.AssignTicketResponse{
		Ticket: ticketToProto(ticket),
	}), nil
}

func (h *Handler) StartTicket(ctx context.Context,
	req *connect.Request[biomedicalv1.StartTicketRequest]) (
	*connect.Response[biomedicalv1.StartTicketResponse], error) {

	msg := req.Msg
	ticket, err := h.svc.StartTicket(ctx, msg.GetTicketId(),
		msg.GetExpectedVersion())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.StartTicketResponse{
		Ticket: ticketToProto(ticket),
	}), nil
}

func (h *Handler) AwaitParts(ctx context.Context,
	req *connect.Request[biomedicalv1.AwaitPartsRequest]) (
	*connect.Response[biomedicalv1.AwaitPartsResponse], error) {

	msg := req.Msg
	ticket, err := h.svc.AwaitParts(ctx, msg.GetTicketId(), msg.GetNote(),
		msg.GetExpectedVersion())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.AwaitPartsResponse{
		Ticket: ticketToProto(ticket),
	}), nil
}

func (h *Handler) CancelTicket(ctx context.Context,
	req *connect.Request[biomedicalv1.CancelTicketRequest]) (
	*connect.Response[biomedicalv1.CancelTicketResponse], error) {

	msg := req.Msg
	ticket, err := h.svc.CancelTicket(ctx, msg.GetTicketId(), msg.GetReason(),
		msg.GetExpectedVersion())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.CancelTicketResponse{
		Ticket: ticketToProto(ticket),
	}), nil
}

func (h *Handler) ResolveTicket(ctx context.Context,
	req *connect.Request[biomedicalv1.ResolveTicketRequest]) (
	*connect.Response[biomedicalv1.ResolveTicketResponse], error) {

	msg := req.Msg
	ticket, err := h.svc.ResolveTicket(ctx, msg.GetTicketId(),
		domain.ResolveInput{
			Diagnosis: msg.GetDiagnosis(), WorkPerformed: msg.GetWorkPerformed(),
			Parts:           partsFromProto(msg.GetParts()),
			BackInServiceAt: timeOf(msg.GetBackInServiceAt()),
		}, msg.GetExpectedVersion())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.ResolveTicketResponse{
		Ticket: ticketToProto(ticket),
	}), nil
}

func (h *Handler) CloseTicket(ctx context.Context,
	req *connect.Request[biomedicalv1.CloseTicketRequest]) (
	*connect.Response[biomedicalv1.CloseTicketResponse], error) {

	msg := req.Msg
	ticket, err := h.svc.CloseTicket(ctx, msg.GetTicketId(), msg.GetNote(),
		msg.GetExpectedVersion())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.CloseTicketResponse{
		Ticket: ticketToProto(ticket),
	}), nil
}

func (h *Handler) ListBreaches(ctx context.Context,
	req *connect.Request[biomedicalv1.ListBreachesRequest]) (
	*connect.Response[biomedicalv1.ListBreachesResponse], error) {

	breaches, err := h.svc.Breaches(ctx, req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	out := make([]*biomedicalv1.Breach, 0, len(breaches))
	for _, breach := range breaches {
		out = append(out, &biomedicalv1.Breach{
			Ticket:             ticketToProto(breach.Ticket),
			ResponseBreached:   breach.Response,
			ResolutionBreached: breach.Resolution,
		})
	}
	return connect.NewResponse(&biomedicalv1.ListBreachesResponse{
		Breaches: out,
	}), nil
}

func (h *Handler) RaiseNotice(ctx context.Context,
	req *connect.Request[biomedicalv1.RaiseNoticeRequest]) (
	*connect.Response[biomedicalv1.RaiseNoticeResponse], error) {

	msg := req.Msg
	notice, tasks, err := h.svc.RaiseNotice(ctx, domain.NewNoticeInput{
		Reference: msg.GetReference(),
		Kind:      noticeKindFromWire[msg.GetKind()],
		Issuer:    msg.GetIssuer(), Summary: msg.GetSummary(),
		Make: msg.GetMake(), Model: msg.GetModel(),
		SerialFrom: msg.GetSerialFrom(), SerialTo: msg.GetSerialTo(),
		AffectedUDI: msg.GetAffectedUdi(), HoldAffected: msg.GetHoldAffected(),
		RequiredAction: msg.GetRequiredAction(),
		DueBy:          timeOf(msg.GetDueBy()),
		IssuedOn:       timeOf(msg.GetIssuedOn()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.RaiseNoticeResponse{
		Notice: noticeToProto(notice), Tasks: tasksToProto(tasks),
	}), nil
}

func tasksToProto(tasks []domain.NoticeTask) []*biomedicalv1.NoticeTask {
	out := make([]*biomedicalv1.NoticeTask, 0, len(tasks))
	for _, task := range tasks {
		out = append(out, taskToProto(task))
	}
	return out
}

func (h *Handler) GetNotice(ctx context.Context,
	req *connect.Request[biomedicalv1.GetNoticeRequest]) (
	*connect.Response[biomedicalv1.GetNoticeResponse], error) {

	notice, err := h.svc.Notice(ctx, req.Msg.GetNoticeId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.GetNoticeResponse{
		Notice: noticeToProto(notice),
	}), nil
}

func (h *Handler) ListNotices(ctx context.Context,
	req *connect.Request[biomedicalv1.ListNoticesRequest]) (
	*connect.Response[biomedicalv1.ListNoticesResponse], error) {

	msg := req.Msg
	notices, err := h.svc.Notices(ctx, msg.GetOpenOnly(), msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	out := make([]*biomedicalv1.SafetyNotice, 0, len(notices))
	for _, notice := range notices {
		out = append(out, noticeToProto(notice))
	}
	return connect.NewResponse(&biomedicalv1.ListNoticesResponse{
		Notices: out,
	}), nil
}

func (h *Handler) ListNoticeTasks(ctx context.Context,
	req *connect.Request[biomedicalv1.ListNoticeTasksRequest]) (
	*connect.Response[biomedicalv1.ListNoticeTasksResponse], error) {

	tasks, err := h.svc.NoticeTasks(ctx, req.Msg.GetNoticeId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.ListNoticeTasksResponse{
		Tasks: tasksToProto(tasks),
	}), nil
}

func (h *Handler) AdvanceTask(ctx context.Context,
	req *connect.Request[biomedicalv1.AdvanceTaskRequest]) (
	*connect.Response[biomedicalv1.AdvanceTaskResponse], error) {

	msg := req.Msg
	task, err := h.svc.AdvanceTask(ctx, application.AdvanceTaskInput{
		TaskID: msg.GetTaskId(),
		To:     taskStateFromWire[msg.GetState()],
		Note:   msg.GetNote(), ReleaseHold: msg.GetReleaseHold(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.AdvanceTaskResponse{
		Task: taskToProto(task),
	}), nil
}

func (h *Handler) TrackNotice(ctx context.Context,
	req *connect.Request[biomedicalv1.TrackNoticeRequest]) (
	*connect.Response[biomedicalv1.TrackNoticeResponse], error) {

	progress, err := h.svc.TrackNotice(ctx, req.Msg.GetNoticeId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.TrackNoticeResponse{
		NoticeId:    progress.NoticeID,
		Total:       int32(progress.Total),
		Outstanding: int32(progress.Outstanding),
		Inspected:   int32(progress.Inspected),
		Complete:    int32(progress.Complete),
		Overdue:     progress.Overdue,
	}), nil
}

func (h *Handler) CloseNotice(ctx context.Context,
	req *connect.Request[biomedicalv1.CloseNoticeRequest]) (
	*connect.Response[biomedicalv1.CloseNoticeResponse], error) {

	msg := req.Msg
	notice, err := h.svc.CloseNotice(ctx, msg.GetNoticeId(), msg.GetNote(),
		msg.GetExpectedVersion())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.CloseNoticeResponse{
		Notice: noticeToProto(notice),
	}), nil
}

func (h *Handler) AppendReadings(ctx context.Context,
	req *connect.Request[biomedicalv1.AppendReadingsRequest]) (
	*connect.Response[biomedicalv1.AppendReadingsResponse], error) {

	in := make([]domain.NewReadingInput, 0, len(req.Msg.GetReadings()))
	for _, reading := range req.Msg.GetReadings() {
		in = append(in, domain.NewReadingInput{
			AssetID: reading.GetAssetId(), Metric: reading.GetMetric(),
			Value: reading.GetValue(), Unit: reading.GetUnit(),
			Source: reading.GetSource(), Ingested: reading.GetIngested(),
			ObservedAt: timeOf(reading.GetObservedAt()),
		})
	}
	readings, err := h.svc.AppendReadings(ctx, in)
	if err != nil {
		return nil, err
	}
	out := make([]*biomedicalv1.Reading, 0, len(readings))
	for _, reading := range readings {
		out = append(out, readingToProto(reading))
	}
	return connect.NewResponse(&biomedicalv1.AppendReadingsResponse{
		Readings: out,
	}), nil
}

func (h *Handler) ListReadings(ctx context.Context,
	req *connect.Request[biomedicalv1.ListReadingsRequest]) (
	*connect.Response[biomedicalv1.ListReadingsResponse], error) {

	msg := req.Msg
	readings, err := h.svc.Readings(ctx, application.ReadingFilter{
		AssetID: msg.GetAssetId(), Metric: msg.GetMetric(),
		From: timeOf(msg.GetFrom()), To: timeOf(msg.GetTo()),
		PageSize: msg.GetPageSize(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*biomedicalv1.Reading, 0, len(readings))
	for _, reading := range readings {
		out = append(out, readingToProto(reading))
	}
	return connect.NewResponse(&biomedicalv1.ListReadingsResponse{
		Readings: out,
	}), nil
}

func (h *Handler) GetAssetMetrics(ctx context.Context,
	req *connect.Request[biomedicalv1.GetAssetMetricsRequest]) (
	*connect.Response[biomedicalv1.GetAssetMetricsResponse], error) {

	msg := req.Msg
	metrics, err := h.svc.AssetMetrics(ctx, msg.GetAssetId(),
		timeOf(msg.GetFrom()), timeOf(msg.GetTo()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.GetAssetMetricsResponse{
		Metrics: metricsToProto(metrics),
	}), nil
}

func (h *Handler) GetFleetMetrics(ctx context.Context,
	req *connect.Request[biomedicalv1.GetFleetMetricsRequest]) (
	*connect.Response[biomedicalv1.GetFleetMetricsResponse], error) {

	msg := req.Msg
	lines, err := h.svc.FleetMetrics(ctx, msg.GetCategory(),
		timeOf(msg.GetFrom()), timeOf(msg.GetTo()), msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	out := make([]*biomedicalv1.FleetLine, 0, len(lines))
	for _, line := range lines {
		out = append(out, &biomedicalv1.FleetLine{
			AssetId: line.AssetID, AssetTag: line.AssetTag,
			Criticality: criticalityToWire[line.Criticality],
			Metrics:     metricsToProto(line.Metrics),
		})
	}
	return connect.NewResponse(&biomedicalv1.GetFleetMetricsResponse{
		Lines: out,
	}), nil
}

func (h *Handler) DisposeAsset(ctx context.Context,
	req *connect.Request[biomedicalv1.DisposeAssetRequest]) (
	*connect.Response[biomedicalv1.DisposeAssetResponse], error) {

	msg := req.Msg
	disposal, err := h.svc.Dispose(ctx, domain.DisposalInput{
		AssetID: msg.GetAssetId(), Method: msg.GetMethod(),
		Reason: msg.GetReason(), RequestedBy: msg.GetRequestedBy(),
		SanitisationRequired:    msg.GetSanitisationRequired(),
		SanitisationMethod:      msg.GetSanitisationMethod(),
		SanitisationCertificate: msg.GetSanitisationCertificate(),
		SanitisedBy:             msg.GetSanitisedBy(),
		Recipient:               msg.GetRecipient(),
		ProceedsMinor:           msg.GetProceedsMinor(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.DisposeAssetResponse{
		Disposal: disposalToProto(disposal),
	}), nil
}

func (h *Handler) GetDisposal(ctx context.Context,
	req *connect.Request[biomedicalv1.GetDisposalRequest]) (
	*connect.Response[biomedicalv1.GetDisposalResponse], error) {

	disposal, err := h.svc.Disposal(ctx, req.Msg.GetAssetId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&biomedicalv1.GetDisposalResponse{
		Disposal: disposalToProto(disposal),
	}), nil
}

func (h *Handler) ListDisposals(ctx context.Context,
	req *connect.Request[biomedicalv1.ListDisposalsRequest]) (
	*connect.Response[biomedicalv1.ListDisposalsResponse], error) {

	msg := req.Msg
	disposals, err := h.svc.Disposals(ctx, timeOf(msg.GetFrom()),
		timeOf(msg.GetTo()), msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	out := make([]*biomedicalv1.Disposal, 0, len(disposals))
	for _, disposal := range disposals {
		out = append(out, disposalToProto(disposal))
	}
	return connect.NewResponse(&biomedicalv1.ListDisposalsResponse{
		Disposals: out,
	}), nil
}
