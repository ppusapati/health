package transport

import (
	"context"
	"time"

	"connectrpc.com/connect"

	housekeepingv1 "github.com/ppusapati/health/code/gen/go/healthcare/housekeeping/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/housekeeping/v1/housekeepingv1connect"
	"github.com/ppusapati/health/code/internal/housekeeping/application"
	"github.com/ppusapati/health/code/internal/housekeeping/domain"
)

// Handler is the housekeeping ConnectRPC surface.
//
// Thin on purpose: it translates, calls one use case and translates back.
// Every refusal comes from the application or the domain, so the same rule
// holds whichever client asks — and the redaction of a spill task's detail
// happens in the application, so a second client cannot be written that
// forgets it.
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

var _ housekeepingv1connect.HousekeepingServiceHandler = (*Handler)(nil)

// Cleanable locations and their standards (SRS-HKP-001).

func (h *Handler) ConfigureLocation(ctx context.Context,
	req *connect.Request[housekeepingv1.ConfigureLocationRequest]) (
	*connect.Response[housekeepingv1.ConfigureLocationResponse], error) {

	msg := req.Msg
	location, err := h.svc.ConfigureLocation(ctx,
		application.ConfigureLocationInput{
			NewLocationInput: domain.NewLocationInput{
				Code: msg.GetCode(), Name: msg.GetName(),
				FacilityID: msg.GetFacilityId(), Zone: msg.GetZone(),
				BedID:              msg.GetBedId(),
				RiskClass:          riskClassFromWire[msg.GetRiskClass()],
				RoutineEveryHours:  int(msg.GetRoutineEveryHours()),
				RoutineSLAMinutes:  int(msg.GetRoutineSlaMinutes()),
				TerminalSLAMinutes: int(msg.GetTerminalSlaMinutes()),
				Checklist:          checklistFromWire(msg.GetChecklist()),
				ScanCode:           msg.GetScanCode(),
			},
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(
		&housekeepingv1.ConfigureLocationResponse{
			Location: locationToWire(location),
		}), nil
}

func (h *Handler) ApproveLocation(ctx context.Context,
	req *connect.Request[housekeepingv1.ApproveLocationRequest]) (
	*connect.Response[housekeepingv1.ApproveLocationResponse], error) {

	location, err := h.svc.ApproveLocation(ctx, req.Msg.GetLocationId(),
		timeOf(req.Msg.GetEffectiveFrom()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(
		&housekeepingv1.ApproveLocationResponse{
			Location: locationToWire(location),
		}), nil
}

func (h *Handler) ListLocations(ctx context.Context,
	req *connect.Request[housekeepingv1.ListLocationsRequest]) (
	*connect.Response[housekeepingv1.ListLocationsResponse], error) {

	msg := req.Msg
	locations, err := h.svc.ListLocations(ctx, application.ListLocationsInput{
		FacilityID: msg.GetFacilityId(), Zone: msg.GetZone(),
		RiskClass: string(riskClassFromWire[msg.GetRiskClass()]),
		LiveOnly:  msg.GetLiveOnly(),
		PageSize:  msg.GetPageSize(), Offset: msg.GetOffset(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&housekeepingv1.ListLocationsResponse{
		Locations: locationsToWire(locations),
	}), nil
}

func (h *Handler) GetLocationInForce(ctx context.Context,
	req *connect.Request[housekeepingv1.GetLocationInForceRequest]) (
	*connect.Response[housekeepingv1.GetLocationInForceResponse], error) {

	location, err := h.svc.LocationInForce(ctx, req.Msg.GetCode())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(
		&housekeepingv1.GetLocationInForceResponse{
			Location: locationToWire(location),
		}), nil
}

func (h *Handler) ListDueRoutineCleans(ctx context.Context,
	req *connect.Request[housekeepingv1.ListDueRoutineCleansRequest]) (
	*connect.Response[housekeepingv1.ListDueRoutineCleansResponse], error) {

	due, err := h.svc.DueRoutineCleans(ctx, req.Msg.GetFacilityId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(
		&housekeepingv1.ListDueRoutineCleansResponse{
			Due: dueToWire(due),
		}), nil
}

// Cleaning work (SRS-HKP-002, SRS-HKP-004, SRS-HKP-006).

func (h *Handler) RaiseCleaningTask(ctx context.Context,
	req *connect.Request[housekeepingv1.RaiseCleaningTaskRequest]) (
	*connect.Response[housekeepingv1.RaiseCleaningTaskResponse], error) {

	msg := req.Msg
	task, err := h.svc.RaiseTask(ctx, application.RaiseTaskInput{
		LocationCode: msg.GetLocationCode(),
		Kind:         taskKindFromWire[msg.GetKind()],
		IncidentRef:  msg.GetIncidentRef(), Detail: msg.GetDetail(),
		AssigneeID: msg.GetAssigneeId(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&housekeepingv1.RaiseCleaningTaskResponse{
		Task: taskToWire(task),
	}), nil
}

func (h *Handler) AssignCleaningTask(ctx context.Context,
	req *connect.Request[housekeepingv1.AssignCleaningTaskRequest]) (
	*connect.Response[housekeepingv1.AssignCleaningTaskResponse], error) {

	task, err := h.svc.AssignTask(ctx, req.Msg.GetTaskId(),
		req.Msg.GetAssigneeId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&housekeepingv1.AssignCleaningTaskResponse{
		Task: taskToWire(task),
	}), nil
}

func (h *Handler) StartCleaningTask(ctx context.Context,
	req *connect.Request[housekeepingv1.StartCleaningTaskRequest]) (
	*connect.Response[housekeepingv1.StartCleaningTaskResponse], error) {

	task, err := h.svc.StartTask(ctx, req.Msg.GetTaskId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&housekeepingv1.StartCleaningTaskResponse{
		Task: taskToWire(task),
	}), nil
}

func (h *Handler) CompleteCleaningTask(ctx context.Context,
	req *connect.Request[housekeepingv1.CompleteCleaningTaskRequest]) (
	*connect.Response[housekeepingv1.CompleteCleaningTaskResponse], error) {

	task, err := h.svc.CompleteTask(ctx, req.Msg.GetTaskId(),
		answersFromWire(req.Msg.GetAnswers()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&housekeepingv1.CompleteCleaningTaskResponse{
		Task: taskToWire(task),
	}), nil
}

func (h *Handler) VerifyCleaningTask(ctx context.Context,
	req *connect.Request[housekeepingv1.VerifyCleaningTaskRequest]) (
	*connect.Response[housekeepingv1.VerifyCleaningTaskResponse], error) {

	task, err := h.svc.VerifyTask(ctx, req.Msg.GetTaskId(),
		req.Msg.GetNote())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&housekeepingv1.VerifyCleaningTaskResponse{
		Task: taskToWire(task),
	}), nil
}

func (h *Handler) CancelCleaningTask(ctx context.Context,
	req *connect.Request[housekeepingv1.CancelCleaningTaskRequest]) (
	*connect.Response[housekeepingv1.CancelCleaningTaskResponse], error) {

	task, err := h.svc.CancelTask(ctx, req.Msg.GetTaskId(),
		req.Msg.GetReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&housekeepingv1.CancelCleaningTaskResponse{
		Task: taskToWire(task),
	}), nil
}

func (h *Handler) GetCleaningTask(ctx context.Context,
	req *connect.Request[housekeepingv1.GetCleaningTaskRequest]) (
	*connect.Response[housekeepingv1.GetCleaningTaskResponse], error) {

	task, err := h.svc.GetTask(ctx, req.Msg.GetTaskId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&housekeepingv1.GetCleaningTaskResponse{
		Task: taskToWire(task),
	}), nil
}

func (h *Handler) ListCleaningTasks(ctx context.Context,
	req *connect.Request[housekeepingv1.ListCleaningTasksRequest]) (
	*connect.Response[housekeepingv1.ListCleaningTasksResponse], error) {

	msg := req.Msg
	tasks, err := h.svc.ListTasks(ctx, application.ListTasksInput{
		FacilityID: msg.GetFacilityId(), Zone: msg.GetZone(),
		LocationCode: msg.GetLocationCode(), BedID: msg.GetBedId(),
		Kind:       string(taskKindFromWire[msg.GetKind()]),
		States:     statesFromWire(msg.GetStates()),
		AssigneeID: msg.GetAssigneeId(), OpenOnly: msg.GetOpenOnly(),
		From: timeOf(msg.GetFrom()), To: timeOf(msg.GetTo()),
		PageSize: msg.GetPageSize(), Offset: msg.GetOffset(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&housekeepingv1.ListCleaningTasksResponse{
		Tasks: tasksToWire(tasks),
	}), nil
}

// Overdue critical-area escalation (SRS-HKP-005).

func (h *Handler) EscalateOverdueCleans(ctx context.Context,
	req *connect.Request[housekeepingv1.EscalateOverdueCleansRequest]) (
	*connect.Response[housekeepingv1.EscalateOverdueCleansResponse], error) {

	tasks, err := h.svc.EscalateOverdue(ctx, req.Msg.GetFacilityId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(
		&housekeepingv1.EscalateOverdueCleansResponse{
			Escalated: tasksToWire(tasks),
		}), nil
}

// Location scanning (SRS-HKP-007).

func (h *Handler) RecordLocationScan(ctx context.Context,
	req *connect.Request[housekeepingv1.RecordLocationScanRequest]) (
	*connect.Response[housekeepingv1.RecordLocationScanResponse], error) {

	scan, err := h.svc.RecordScan(ctx, req.Msg.GetTaskId(),
		req.Msg.GetScannedCode())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&housekeepingv1.RecordLocationScanResponse{
		Scan: scanToWire(scan),
	}), nil
}

// Bed cleaning holds (SRS-HKP-003).

func (h *Handler) TriggerTerminalClean(ctx context.Context,
	req *connect.Request[housekeepingv1.TriggerTerminalCleanRequest]) (
	*connect.Response[housekeepingv1.TriggerTerminalCleanResponse], error) {

	msg := req.Msg
	result, err := h.svc.TriggerTerminalClean(ctx,
		application.TriggerTerminalCleanInput{
			LocationCode: msg.GetLocationCode(),
			EncounterID:  msg.GetEncounterId(),
			AssigneeID:   msg.GetAssigneeId(), Detail: msg.GetDetail(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(
		&housekeepingv1.TriggerTerminalCleanResponse{
			Task: taskToWire(result.Task), Hold: holdToWire(result.Hold),
		}), nil
}

func (h *Handler) OverrideBedHold(ctx context.Context,
	req *connect.Request[housekeepingv1.OverrideBedHoldRequest]) (
	*connect.Response[housekeepingv1.OverrideBedHoldResponse], error) {

	hold, err := h.svc.OverrideHold(ctx, req.Msg.GetHoldId(),
		req.Msg.GetReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&housekeepingv1.OverrideBedHoldResponse{
		Hold: holdToWire(hold),
	}), nil
}

func (h *Handler) GetBedStatus(ctx context.Context,
	req *connect.Request[housekeepingv1.GetBedStatusRequest]) (
	*connect.Response[housekeepingv1.GetBedStatusResponse], error) {

	status, err := h.svc.BedClear(ctx, req.Msg.GetBedId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&housekeepingv1.GetBedStatusResponse{
		BedId: status.BedID, Clear: status.Clear,
		Hold: holdToWire(status.Hold),
	}), nil
}

func (h *Handler) ListHeldBeds(ctx context.Context,
	req *connect.Request[housekeepingv1.ListHeldBedsRequest]) (
	*connect.Response[housekeepingv1.ListHeldBedsResponse], error) {

	msg := req.Msg
	holds, err := h.svc.ListHeldBeds(ctx, application.ListHeldBedsInput{
		FacilityID: msg.GetFacilityId(), Zone: msg.GetZone(),
		PageSize: msg.GetPageSize(), Offset: msg.GetOffset(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&housekeepingv1.ListHeldBedsResponse{
		Holds: holdsToWire(holds),
	}), nil
}

// Reporting (SRS-HKP-008).

func (h *Handler) GetCleaningReport(ctx context.Context,
	req *connect.Request[housekeepingv1.GetCleaningReportRequest]) (
	*connect.Response[housekeepingv1.GetCleaningReportResponse], error) {

	msg := req.Msg
	report, err := h.svc.CleaningReport(ctx, reportInput(msg.GetFacilityId(),
		msg.GetZone(), msg.GetFrom(), msg.GetTo()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&housekeepingv1.GetCleaningReportResponse{
		Summary:   cleaningSummaryToWire(report.Summary),
		Truncated: report.Truncated,
	}), nil
}

func (h *Handler) GetTurnaroundReport(ctx context.Context,
	req *connect.Request[housekeepingv1.GetTurnaroundReportRequest]) (
	*connect.Response[housekeepingv1.GetTurnaroundReportResponse], error) {

	msg := req.Msg
	report, err := h.svc.TurnaroundReport(ctx,
		reportInput(msg.GetFacilityId(), msg.GetZone(), msg.GetFrom(),
			msg.GetTo()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&housekeepingv1.GetTurnaroundReportResponse{
		Summary:   turnaroundSummaryToWire(report.Summary),
		Truncated: report.Truncated,
	}), nil
}
