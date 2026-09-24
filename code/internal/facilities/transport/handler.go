package transport

import (
	"context"
	"time"

	"connectrpc.com/connect"

	facilitiesv1 "github.com/ppusapati/health/code/gen/go/healthcare/facilities/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/facilities/v1/facilitiesv1connect"
	"github.com/ppusapati/health/code/internal/facilities/application"
)

// Handler is the facilities ConnectRPC surface.
//
// Thin on purpose: it translates, calls one use case and translates back.
// Every refusal comes from the application or the domain, so the same rule
// holds whichever client asks — a second client cannot be written that
// forgets permit work needs its permit.
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

var _ facilitiesv1connect.FacilitiesServiceHandler = (*Handler)(nil)

// Assets (SRS-FAC-001).

func (h *Handler) RegisterAsset(ctx context.Context,
	req *connect.Request[facilitiesv1.RegisterAssetRequest]) (
	*connect.Response[facilitiesv1.RegisterAssetResponse], error) {

	msg := req.Msg
	asset, err := h.svc.RegisterAsset(ctx, application.RegisterAssetInput{
		Tag: msg.GetTag(), Name: msg.GetName(),
		System:       string(systemFromWire[msg.GetSystem()]),
		Criticality:  string(criticalityFromWire[msg.GetCriticality()]),
		ParentID:     msg.GetParentId(),
		FacilityID:   msg.GetFacilityId(),
		LocationID:   msg.GetLocationId(),
		LocationNote: msg.GetLocationNote(),
		Manufacturer: msg.GetManufacturer(), Model: msg.GetModel(),
		SerialNumber:   msg.GetSerialNumber(),
		CommissionedAt: textOf(msg.GetCommissionedAt()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.RegisterAssetResponse{
		Asset: assetToWire(asset)}), nil
}

func (h *Handler) SetAssetStatus(ctx context.Context,
	req *connect.Request[facilitiesv1.SetAssetStatusRequest]) (
	*connect.Response[facilitiesv1.SetAssetStatusResponse], error) {

	msg := req.Msg
	asset, err := h.svc.SetAssetStatus(ctx, application.SetAssetStatusInput{
		AssetID: msg.GetAssetId(),
		Status:  string(assetStatusFromWire[msg.GetStatus()]),
		Reason:  msg.GetReason(), Version: msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.SetAssetStatusResponse{
		Asset: assetToWire(asset)}), nil
}

func (h *Handler) GetAsset(ctx context.Context,
	req *connect.Request[facilitiesv1.GetAssetRequest]) (
	*connect.Response[facilitiesv1.GetAssetResponse], error) {

	asset, err := h.svc.GetAsset(ctx, req.Msg.GetAssetId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.GetAssetResponse{
		Asset: assetToWire(asset)}), nil
}

func (h *Handler) ListAssets(ctx context.Context,
	req *connect.Request[facilitiesv1.ListAssetsRequest]) (
	*connect.Response[facilitiesv1.ListAssetsResponse], error) {

	msg := req.Msg
	found, err := h.svc.ListAssets(ctx, application.AssetFilterInput{
		FacilityID: msg.GetFacilityId(),
		System:     string(systemFromWire[msg.GetSystem()]),
		Status:     string(assetStatusFromWire[msg.GetStatus()]),
		ParentID:   msg.GetParentId(), PageSize: msg.GetPageSize(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.ListAssetsResponse{
		Assets: assetsToWire(found)}), nil
}

func (h *Handler) GetAssetTree(ctx context.Context,
	req *connect.Request[facilitiesv1.GetAssetTreeRequest]) (
	*connect.Response[facilitiesv1.GetAssetTreeResponse], error) {

	found, err := h.svc.AssetTree(ctx, req.Msg.GetRootId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.GetAssetTreeResponse{
		Assets: assetsToWire(found)}), nil
}

func (h *Handler) ListDownAssets(ctx context.Context,
	req *connect.Request[facilitiesv1.ListDownAssetsRequest]) (
	*connect.Response[facilitiesv1.ListDownAssetsResponse], error) {

	found, err := h.svc.DownAssets(ctx, req.Msg.GetFacilityId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.ListDownAssetsResponse{
		Assets: assetsToWire(found)}), nil
}

// Work classes (SRS-FAC-010).

func (h *Handler) SetWorkClass(ctx context.Context,
	req *connect.Request[facilitiesv1.SetWorkClassRequest]) (
	*connect.Response[facilitiesv1.SetWorkClassResponse], error) {

	msg := req.Msg
	class, err := h.svc.SetWorkClass(ctx, application.SetWorkClassInput{
		Code: msg.GetCode(), Name: msg.GetName(),
		RequiresPermit: msg.GetRequiresPermit(),
		RequiresLOTO:   msg.GetRequiresLoto(),
		Active:         msg.GetActive(), Note: msg.GetNote(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.SetWorkClassResponse{
		WorkClass: classToWire(class)}), nil
}

func (h *Handler) ListWorkClasses(ctx context.Context,
	req *connect.Request[facilitiesv1.ListWorkClassesRequest]) (
	*connect.Response[facilitiesv1.ListWorkClassesResponse], error) {

	found, err := h.svc.ListWorkClasses(ctx)
	if err != nil {
		return nil, err
	}
	out := make([]*facilitiesv1.WorkClass, 0, len(found))
	for _, c := range found {
		out = append(out, classToWire(c))
	}
	return connect.NewResponse(&facilitiesv1.ListWorkClassesResponse{
		WorkClasses: out}), nil
}

// Work orders (SRS-FAC-002, SRS-FAC-010).

func (h *Handler) RaiseWork(ctx context.Context,
	req *connect.Request[facilitiesv1.RaiseWorkRequest]) (
	*connect.Response[facilitiesv1.RaiseWorkResponse], error) {

	msg := req.Msg
	order, err := h.svc.RaiseWork(ctx, application.RaiseWorkInput{
		Number: msg.GetNumber(), FacilityID: msg.GetFacilityId(),
		AssetID:      msg.GetAssetId(),
		System:       string(systemFromWire[msg.GetSystem()]),
		LocationID:   msg.GetLocationId(),
		LocationNote: msg.GetLocationNote(),
		Fault:        msg.GetFault(), Impact: msg.GetImpact(),
		Priority:  string(priorityFromWire[msg.GetPriority()]),
		ClassCode: msg.GetClassCode(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.RaiseWorkResponse{
		WorkOrder: workToWire(order)}), nil
}

func (h *Handler) AssignWork(ctx context.Context,
	req *connect.Request[facilitiesv1.AssignWorkRequest]) (
	*connect.Response[facilitiesv1.AssignWorkResponse], error) {

	msg := req.Msg
	order, err := h.svc.AssignWork(ctx, application.AssignWorkInput{
		WorkOrderID: msg.GetWorkOrderId(), UserID: msg.GetUserId(),
		Team: msg.GetTeam(), Version: msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.AssignWorkResponse{
		WorkOrder: workToWire(order)}), nil
}

func (h *Handler) StartWork(ctx context.Context,
	req *connect.Request[facilitiesv1.StartWorkRequest]) (
	*connect.Response[facilitiesv1.StartWorkResponse], error) {

	msg := req.Msg
	order, err := h.svc.StartWork(ctx, application.StartWorkInput{
		WorkOrderID:    msg.GetWorkOrderId(),
		PermitRef:      msg.GetPermitRef(),
		PermitIssuedBy: msg.GetPermitIssuedBy(),
		LOTORef:        msg.GetLotoRef(),
		LOTOAppliedBy:  msg.GetLotoAppliedBy(),
		Version:        msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.StartWorkResponse{
		WorkOrder: workToWire(order)}), nil
}

func (h *Handler) HoldWork(ctx context.Context,
	req *connect.Request[facilitiesv1.HoldWorkRequest]) (
	*connect.Response[facilitiesv1.HoldWorkResponse], error) {

	msg := req.Msg
	order, err := h.svc.HoldWork(ctx, application.HoldWorkInput{
		WorkOrderID: msg.GetWorkOrderId(), Reason: msg.GetReason(),
		Version: msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.HoldWorkResponse{
		WorkOrder: workToWire(order)}), nil
}

func (h *Handler) ResolveWork(ctx context.Context,
	req *connect.Request[facilitiesv1.ResolveWorkRequest]) (
	*connect.Response[facilitiesv1.ResolveWorkResponse], error) {

	msg := req.Msg
	order, err := h.svc.ResolveWork(ctx, application.ResolveWorkInput{
		WorkOrderID: msg.GetWorkOrderId(), Note: msg.GetNote(),
		RootCause:       msg.GetRootCause(),
		DowntimeMinutes: msg.GetDowntimeMinutes(),
		Version:         msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.ResolveWorkResponse{
		WorkOrder: workToWire(order)}), nil
}

func (h *Handler) CloseWork(ctx context.Context,
	req *connect.Request[facilitiesv1.CloseWorkRequest]) (
	*connect.Response[facilitiesv1.CloseWorkResponse], error) {

	msg := req.Msg
	order, err := h.svc.CloseWork(ctx, application.CloseWorkInput{
		WorkOrderID: msg.GetWorkOrderId(), Version: msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.CloseWorkResponse{
		WorkOrder: workToWire(order)}), nil
}

func (h *Handler) CancelWork(ctx context.Context,
	req *connect.Request[facilitiesv1.CancelWorkRequest]) (
	*connect.Response[facilitiesv1.CancelWorkResponse], error) {

	msg := req.Msg
	order, err := h.svc.CancelWork(ctx, application.CancelWorkInput{
		WorkOrderID: msg.GetWorkOrderId(), Reason: msg.GetReason(),
		Version: msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.CancelWorkResponse{
		WorkOrder: workToWire(order)}), nil
}

func (h *Handler) GetWork(ctx context.Context,
	req *connect.Request[facilitiesv1.GetWorkRequest]) (
	*connect.Response[facilitiesv1.GetWorkResponse], error) {

	order, err := h.svc.GetWork(ctx, req.Msg.GetWorkOrderId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.GetWorkResponse{
		WorkOrder: workToWire(order),
		Breach:    breachToWire(order.Breached(h.now())),
	}), nil
}

func (h *Handler) ListWork(ctx context.Context,
	req *connect.Request[facilitiesv1.ListWorkRequest]) (
	*connect.Response[facilitiesv1.ListWorkResponse], error) {

	msg := req.Msg
	found, err := h.svc.ListWork(ctx, application.WorkFilterInput{
		FacilityID: msg.GetFacilityId(), AssetID: msg.GetAssetId(),
		System:   string(systemFromWire[msg.GetSystem()]),
		State:    string(workStateFromWire[msg.GetState()]),
		OpenOnly: msg.GetOpenOnly(),
		From:     textOf(msg.GetFrom()), To: textOf(msg.GetTo()),
		PageSize: msg.GetPageSize(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.ListWorkResponse{
		WorkOrders: workOrdersToWire(found)}), nil
}

func (h *Handler) GetWorklist(ctx context.Context,
	req *connect.Request[facilitiesv1.GetWorklistRequest]) (
	*connect.Response[facilitiesv1.GetWorklistResponse], error) {

	found, err := h.svc.Worklist(ctx, req.Msg.GetFacilityId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.GetWorklistResponse{
		WorkOrders: workOrdersToWire(found)}), nil
}

// Maintenance (SRS-FAC-003, SRS-FAC-007).

func (h *Handler) AddSchedule(ctx context.Context,
	req *connect.Request[facilitiesv1.AddScheduleRequest]) (
	*connect.Response[facilitiesv1.AddScheduleResponse], error) {

	msg := req.Msg
	schedule, err := h.svc.AddSchedule(ctx, application.AddScheduleInput{
		AssetID: msg.GetAssetId(), FacilityID: msg.GetFacilityId(),
		Title:                msg.GetTitle(),
		Kind:                 string(kindFromWire[msg.GetKind()]),
		Trigger:              string(triggerFromWire[msg.GetTrigger()]),
		IntervalDays:         msg.GetIntervalDays(),
		IntervalRuntimeHours: msg.GetIntervalRuntimeHours(),
		Authority:            msg.GetAuthority(),
		RequiresEvidence:     msg.GetRequiresEvidence(),
		WorkClassCode:        msg.GetWorkClassCode(),
		GraceDays:            msg.GetGraceDays(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.AddScheduleResponse{
		Schedule: scheduleToWire(schedule)}), nil
}

func (h *Handler) ListSchedules(ctx context.Context,
	req *connect.Request[facilitiesv1.ListSchedulesRequest]) (
	*connect.Response[facilitiesv1.ListSchedulesResponse], error) {

	msg := req.Msg
	found, err := h.svc.ListSchedules(ctx, msg.GetAssetId(),
		msg.GetFacilityId(), msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	out := make([]*facilitiesv1.Schedule, 0, len(found))
	for _, s := range found {
		out = append(out, scheduleToWire(s))
	}
	return connect.NewResponse(&facilitiesv1.ListSchedulesResponse{
		Schedules: out}), nil
}

func (h *Handler) PlanDue(ctx context.Context,
	req *connect.Request[facilitiesv1.PlanDueRequest]) (
	*connect.Response[facilitiesv1.PlanDueResponse], error) {

	planned, err := h.svc.PlanDue(ctx, req.Msg.GetFacilityId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.PlanDueResponse{
		Tasks: tasksToWire(planned)}), nil
}

func (h *Handler) CompleteTask(ctx context.Context,
	req *connect.Request[facilitiesv1.CompleteTaskRequest]) (
	*connect.Response[facilitiesv1.CompleteTaskResponse], error) {

	msg := req.Msg
	task, err := h.svc.CompleteTask(ctx, application.CompleteTaskInput{
		TaskID: msg.GetTaskId(), Findings: msg.GetFindings(),
		EvidenceRef:          msg.GetEvidenceRef(),
		CertificateRef:       msg.GetCertificateRef(),
		CertificateExpiresAt: textOf(msg.GetCertificateExpiresAt()),
		WorkOrderID:          msg.GetWorkOrderId(),
		RuntimeHours:         msg.GetRuntimeHours(),
		Version:              msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.CompleteTaskResponse{
		Task: taskToWire(task)}), nil
}

func (h *Handler) WaiveTask(ctx context.Context,
	req *connect.Request[facilitiesv1.WaiveTaskRequest]) (
	*connect.Response[facilitiesv1.WaiveTaskResponse], error) {

	msg := req.Msg
	task, err := h.svc.WaiveTask(ctx, application.WaiveTaskInput{
		TaskID: msg.GetTaskId(), Reason: msg.GetReason(),
		Version: msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.WaiveTaskResponse{
		Task: taskToWire(task)}), nil
}

func (h *Handler) ListTasks(ctx context.Context,
	req *connect.Request[facilitiesv1.ListTasksRequest]) (
	*connect.Response[facilitiesv1.ListTasksResponse], error) {

	msg := req.Msg
	found, err := h.svc.ListTasks(ctx, application.TaskFilterInput{
		ScheduleID: msg.GetScheduleId(), AssetID: msg.GetAssetId(),
		FacilityID: msg.GetFacilityId(),
		State:      string(taskStateFromWire[msg.GetState()]),
		Kind:       string(kindFromWire[msg.GetKind()]),
		PageSize:   msg.GetPageSize(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.ListTasksResponse{
		Tasks: tasksToWire(found)}), nil
}

func (h *Handler) GetMaintenanceReport(ctx context.Context,
	req *connect.Request[facilitiesv1.GetMaintenanceReportRequest]) (
	*connect.Response[facilitiesv1.GetMaintenanceReportResponse], error) {

	report, err := h.svc.MaintenanceStatus(ctx, req.Msg.GetFacilityId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.GetMaintenanceReportResponse{
		Report: maintenanceReportToWire(report)}), nil
}

func (h *Handler) RecordRuntime(ctx context.Context,
	req *connect.Request[facilitiesv1.RecordRuntimeRequest]) (
	*connect.Response[facilitiesv1.RecordRuntimeResponse], error) {

	msg := req.Msg
	reading, err := h.svc.RecordRuntime(ctx, application.RecordRuntimeInput{
		AssetID: msg.GetAssetId(), Hours: msg.GetHours(),
		ReadAt:          textOf(msg.GetReadAt()),
		Source:          string(sourceFromWire[msg.GetSource()]),
		SourceRef:       msg.GetSourceRef(),
		CounterReplaced: msg.GetCounterReplaced(),
		Note:            msg.GetNote(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.RecordRuntimeResponse{
		Reading: runtimeToWire(reading)}), nil
}

// Planned outages (SRS-FAC-004).

func (h *Handler) PlanOutage(ctx context.Context,
	req *connect.Request[facilitiesv1.PlanOutageRequest]) (
	*connect.Response[facilitiesv1.PlanOutageResponse], error) {

	msg := req.Msg
	areas := make([]application.AreaInput, 0, len(msg.GetAreas()))
	for _, area := range msg.GetAreas() {
		areas = append(areas, application.AreaInput{
			OrgUnitID: area.GetOrgUnitId(), Name: area.GetName(),
			Critical: area.GetCritical(),
		})
	}

	planned, err := h.svc.PlanOutage(ctx, application.PlanOutageInput{
		Reference: msg.GetReference(), FacilityID: msg.GetFacilityId(),
		System: string(systemFromWire[msg.GetSystem()]),
		Title:  msg.GetTitle(), Reason: msg.GetReason(),
		PlannedFrom: textOf(msg.GetPlannedFrom()),
		PlannedTo:   textOf(msg.GetPlannedTo()),
		Contingency: msg.GetContingency(), Areas: areas,
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.PlanOutageResponse{
		Outage:      outageToWire(planned.Outage),
		Areas:       areasToWire(planned.Areas),
		Overlapping: outagesToWire(planned.Overlapping),
	}), nil
}

func (h *Handler) ApproveOutage(ctx context.Context,
	req *connect.Request[facilitiesv1.ApproveOutageRequest]) (
	*connect.Response[facilitiesv1.ApproveOutageResponse], error) {

	msg := req.Msg
	approved, err := h.svc.ApproveOutage(ctx, application.ApproveOutageInput{
		OutageID: msg.GetOutageId(), PermitRef: msg.GetPermitRef(),
		Version: msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.ApproveOutageResponse{
		Outage: outageToWire(approved.Outage),
		Areas:  areasToWire(approved.Areas),
	}), nil
}

func (h *Handler) AcknowledgeOutage(ctx context.Context,
	req *connect.Request[facilitiesv1.AcknowledgeOutageRequest]) (
	*connect.Response[facilitiesv1.AcknowledgeOutageResponse], error) {

	msg := req.Msg
	area, err := h.svc.AcknowledgeOutage(ctx,
		application.AcknowledgeOutageInput{
			OutageID: msg.GetOutageId(), AreaID: msg.GetAreaId(),
			Objection: msg.GetObjection(), Version: msg.GetVersion(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.AcknowledgeOutageResponse{
		Area: areaToWire(area)}), nil
}

func (h *Handler) StartOutage(ctx context.Context,
	req *connect.Request[facilitiesv1.StartOutageRequest]) (
	*connect.Response[facilitiesv1.StartOutageResponse], error) {

	msg := req.Msg
	outage, err := h.svc.StartOutage(ctx, application.StartOutageInput{
		OutageID: msg.GetOutageId(), Version: msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.StartOutageResponse{
		Outage: outageToWire(outage)}), nil
}

func (h *Handler) RestoreOutage(ctx context.Context,
	req *connect.Request[facilitiesv1.RestoreOutageRequest]) (
	*connect.Response[facilitiesv1.RestoreOutageResponse], error) {

	msg := req.Msg
	outage, err := h.svc.RestoreOutage(ctx, application.RestoreOutageInput{
		OutageID: msg.GetOutageId(), Version: msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.RestoreOutageResponse{
		Outage: outageToWire(outage)}), nil
}

func (h *Handler) CancelOutage(ctx context.Context,
	req *connect.Request[facilitiesv1.CancelOutageRequest]) (
	*connect.Response[facilitiesv1.CancelOutageResponse], error) {

	msg := req.Msg
	outage, err := h.svc.CancelOutage(ctx, application.CancelOutageInput{
		OutageID: msg.GetOutageId(), Reason: msg.GetReason(),
		Version: msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.CancelOutageResponse{
		Outage: outageToWire(outage)}), nil
}

func (h *Handler) GetOutage(ctx context.Context,
	req *connect.Request[facilitiesv1.GetOutageRequest]) (
	*connect.Response[facilitiesv1.GetOutageResponse], error) {

	found, err := h.svc.GetOutage(ctx, req.Msg.GetOutageId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.GetOutageResponse{
		Outage: outageToWire(found.Outage),
		Areas:  areasToWire(found.Areas),
	}), nil
}

func (h *Handler) ListOutages(ctx context.Context,
	req *connect.Request[facilitiesv1.ListOutagesRequest]) (
	*connect.Response[facilitiesv1.ListOutagesResponse], error) {

	msg := req.Msg
	found, err := h.svc.ListOutages(ctx, application.OutageFilterInput{
		FacilityID: msg.GetFacilityId(),
		System:     string(systemFromWire[msg.GetSystem()]),
		LiveOnly:   msg.GetLiveOnly(),
		From:       textOf(msg.GetFrom()), To: textOf(msg.GetTo()),
		PageSize: msg.GetPageSize(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.ListOutagesResponse{
		Outages: outagesToWire(found)}), nil
}

// Alarms (SRS-FAC-005, SRS-FAC-006).

func (h *Handler) IngestAlarm(ctx context.Context,
	req *connect.Request[facilitiesv1.IngestAlarmRequest]) (
	*connect.Response[facilitiesv1.IngestAlarmResponse], error) {

	msg := req.Msg
	got, err := h.svc.IngestAlarm(ctx, application.IngestAlarmInput{
		GatewayID: msg.GetGatewayId(), PointRef: msg.GetPointRef(),
		ExternalID: msg.GetExternalId(), AssetID: msg.GetAssetId(),
		FacilityID: msg.GetFacilityId(),
		System:     string(systemFromWire[msg.GetSystem()]),
		Severity:   string(severityFromWire[msg.GetSeverity()]),
		Message:    msg.GetMessage(),
		Source:     string(sourceFromWire[msg.GetSource()]),
		RaisedAt:   textOf(msg.GetRaisedAt()),
	})
	if err != nil {
		return nil, err
	}
	out := &facilitiesv1.IngestAlarmResponse{
		Alarm:      alarmToWire(got.Alarm),
		RaisedWork: got.RaisedWork, Duplicate: got.Duplicate,
	}
	if got.RaisedWork {
		out.WorkOrder = workToWire(got.WorkOrder)
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) ClearAlarm(ctx context.Context,
	req *connect.Request[facilitiesv1.ClearAlarmRequest]) (
	*connect.Response[facilitiesv1.ClearAlarmResponse], error) {

	msg := req.Msg
	alarm, err := h.svc.ClearAlarm(ctx, application.ClearAlarmInput{
		AlarmID: msg.GetAlarmId(), Version: msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.ClearAlarmResponse{
		Alarm: alarmToWire(alarm)}), nil
}

func (h *Handler) AcknowledgeAlarm(ctx context.Context,
	req *connect.Request[facilitiesv1.AcknowledgeAlarmRequest]) (
	*connect.Response[facilitiesv1.AcknowledgeAlarmResponse], error) {

	msg := req.Msg
	alarm, err := h.svc.AcknowledgeAlarm(ctx,
		application.AcknowledgeAlarmInput{
			AlarmID: msg.GetAlarmId(), Version: msg.GetVersion(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.AcknowledgeAlarmResponse{
		Alarm: alarmToWire(alarm)}), nil
}

func (h *Handler) LinkAlarmWork(ctx context.Context,
	req *connect.Request[facilitiesv1.LinkAlarmWorkRequest]) (
	*connect.Response[facilitiesv1.LinkAlarmWorkResponse], error) {

	msg := req.Msg
	alarm, err := h.svc.LinkAlarmWork(ctx, application.LinkAlarmWorkInput{
		AlarmID: msg.GetAlarmId(), WorkOrderID: msg.GetWorkOrderId(),
		Version: msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.LinkAlarmWorkResponse{
		Alarm: alarmToWire(alarm)}), nil
}

func (h *Handler) SetAlarmRule(ctx context.Context,
	req *connect.Request[facilitiesv1.SetAlarmRuleRequest]) (
	*connect.Response[facilitiesv1.SetAlarmRuleResponse], error) {

	msg := req.Msg
	rule, err := h.svc.SetAlarmRule(ctx, application.SetAlarmRuleInput{
		FacilityID:  msg.GetFacilityId(),
		System:      string(systemFromWire[msg.GetSystem()]),
		MinSeverity: string(severityFromWire[msg.GetMinSeverity()]),
		Priority:    string(priorityFromWire[msg.GetPriority()]),
		ClassCode:   msg.GetClassCode(), OwnerTeam: msg.GetOwnerTeam(),
		Active: msg.GetActive(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.SetAlarmRuleResponse{
		Rule: ruleToWire(rule)}), nil
}

func (h *Handler) ListAlarms(ctx context.Context,
	req *connect.Request[facilitiesv1.ListAlarmsRequest]) (
	*connect.Response[facilitiesv1.ListAlarmsResponse], error) {

	msg := req.Msg
	found, err := h.svc.ListAlarms(ctx, application.AlarmFilterInput{
		FacilityID:     msg.GetFacilityId(),
		System:         string(systemFromWire[msg.GetSystem()]),
		State:          string(alarmStateFromWire[msg.GetState()]),
		UnansweredOnly: msg.GetUnansweredOnly(),
		From:           textOf(msg.GetFrom()), To: textOf(msg.GetTo()),
		PageSize: msg.GetPageSize(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.ListAlarmsResponse{
		Alarms: alarmsToWire(found)}), nil
}

// Fire and life safety (SRS-FAC-008).

func (h *Handler) RaiseDeficiency(ctx context.Context,
	req *connect.Request[facilitiesv1.RaiseDeficiencyRequest]) (
	*connect.Response[facilitiesv1.RaiseDeficiencyResponse], error) {

	msg := req.Msg
	got, err := h.svc.RaiseDeficiency(ctx, application.RaiseDeficiencyInput{
		TaskID: msg.GetTaskId(), AssetID: msg.GetAssetId(),
		FacilityID:   msg.GetFacilityId(),
		LocationID:   msg.GetLocationId(),
		LocationNote: msg.GetLocationNote(),
		System:       string(systemFromWire[msg.GetSystem()]),
		Severity:     string(severityFromWire[msg.GetSeverity()]),
		Finding:      msg.GetFinding(), Standard: msg.GetStandard(),
		DueAt:       textOf(msg.GetDueAt()),
		WorkOrderID: msg.GetWorkOrderId(),
		ClassCode:   msg.GetClassCode(),
		Priority:    string(priorityFromWire[msg.GetPriority()]),
	})
	if err != nil {
		return nil, err
	}
	out := &facilitiesv1.RaiseDeficiencyResponse{
		Deficiency: deficiencyToWire(got.Deficiency),
		RaisedWork: got.RaisedWork,
	}
	if got.RaisedWork {
		out.WorkOrder = workToWire(got.WorkOrder)
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) MitigateDeficiency(ctx context.Context,
	req *connect.Request[facilitiesv1.MitigateDeficiencyRequest]) (
	*connect.Response[facilitiesv1.MitigateDeficiencyResponse], error) {

	msg := req.Msg
	deficiency, err := h.svc.MitigateDeficiency(ctx,
		application.MitigateDeficiencyInput{
			DeficiencyID: msg.GetDeficiencyId(), Note: msg.GetNote(),
			Version: msg.GetVersion(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.MitigateDeficiencyResponse{
		Deficiency: deficiencyToWire(deficiency)}), nil
}

func (h *Handler) CloseDeficiency(ctx context.Context,
	req *connect.Request[facilitiesv1.CloseDeficiencyRequest]) (
	*connect.Response[facilitiesv1.CloseDeficiencyResponse], error) {

	msg := req.Msg
	deficiency, err := h.svc.CloseDeficiency(ctx,
		application.CloseDeficiencyInput{
			DeficiencyID: msg.GetDeficiencyId(),
			EvidenceRef:  msg.GetEvidenceRef(),
			Version:      msg.GetVersion(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.CloseDeficiencyResponse{
		Deficiency: deficiencyToWire(deficiency)}), nil
}

func (h *Handler) ListDeficiencies(ctx context.Context,
	req *connect.Request[facilitiesv1.ListDeficienciesRequest]) (
	*connect.Response[facilitiesv1.ListDeficienciesResponse], error) {

	msg := req.Msg
	found, err := h.svc.ListDeficiencies(ctx,
		application.DeficiencyFilterInput{
			FacilityID: msg.GetFacilityId(), TaskID: msg.GetTaskId(),
			Severity: string(severityFromWire[msg.GetSeverity()]),
			OpenOnly: msg.GetOpenOnly(), PageSize: msg.GetPageSize(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.ListDeficienciesResponse{
		Deficiencies: deficienciesToWire(found)}), nil
}

func (h *Handler) ListOpenCritical(ctx context.Context,
	req *connect.Request[facilitiesv1.ListOpenCriticalRequest]) (
	*connect.Response[facilitiesv1.ListOpenCriticalResponse], error) {

	found, err := h.svc.OpenCriticalDeficiencies(ctx,
		req.Msg.GetFacilityId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.ListOpenCriticalResponse{
		Deficiencies: deficienciesToWire(found)}), nil
}

func (h *Handler) ListBlocking(ctx context.Context,
	req *connect.Request[facilitiesv1.ListBlockingRequest]) (
	*connect.Response[facilitiesv1.ListBlockingResponse], error) {

	found, err := h.svc.BlockingDeficiencies(ctx, req.Msg.GetTaskId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.ListBlockingResponse{
		Deficiencies: deficienciesToWire(found)}), nil
}

func (h *Handler) GetSafetyReport(ctx context.Context,
	req *connect.Request[facilitiesv1.GetSafetyReportRequest]) (
	*connect.Response[facilitiesv1.GetSafetyReportResponse], error) {

	msg := req.Msg
	report, err := h.svc.SafetyReport(ctx, msg.GetFacilityId(),
		textOf(msg.GetFrom()), textOf(msg.GetTo()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.GetSafetyReportResponse{
		Report: safetyReportToWire(report)}), nil
}

// Metering and KPIs (SRS-FAC-009).

func (h *Handler) AddMeter(ctx context.Context,
	req *connect.Request[facilitiesv1.AddMeterRequest]) (
	*connect.Response[facilitiesv1.AddMeterResponse], error) {

	msg := req.Msg
	meter, err := h.svc.AddMeter(ctx, application.AddMeterInput{
		Code: msg.GetCode(), Name: msg.GetName(),
		Utility: string(utilityFromWire[msg.GetUtility()]),
		Unit:    msg.GetUnit(), FacilityID: msg.GetFacilityId(),
		LocationID: msg.GetLocationId(), AssetID: msg.GetAssetId(),
		Source:      string(sourceFromWire[msg.GetSource()]),
		SourceRef:   msg.GetSourceRef(),
		Cumulative:  msg.GetCumulative(),
		RegisterMax: msg.GetRegisterMax(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.AddMeterResponse{
		Meter: meterToWire(meter)}), nil
}

func (h *Handler) RecordMeterReading(ctx context.Context,
	req *connect.Request[facilitiesv1.RecordMeterReadingRequest]) (
	*connect.Response[facilitiesv1.RecordMeterReadingResponse], error) {

	msg := req.Msg
	reading, err := h.svc.RecordMeterReading(ctx,
		application.RecordMeterReadingInput{
			MeterID: msg.GetMeterId(), Value: msg.GetValue(),
			ReadAt:     textOf(msg.GetReadAt()),
			Source:     string(sourceFromWire[msg.GetSource()]),
			SourceRef:  msg.GetSourceRef(),
			RolledOver: msg.GetRolledOver(), Note: msg.GetNote(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.RecordMeterReadingResponse{
		Reading: readingToWire(reading)}), nil
}

func (h *Handler) ListMeters(ctx context.Context,
	req *connect.Request[facilitiesv1.ListMetersRequest]) (
	*connect.Response[facilitiesv1.ListMetersResponse], error) {

	msg := req.Msg
	found, err := h.svc.ListMeters(ctx, msg.GetFacilityId(),
		string(utilityFromWire[msg.GetUtility()]), msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.ListMetersResponse{
		Meters: metersToWire(found)}), nil
}

func (h *Handler) GetConsumption(ctx context.Context,
	req *connect.Request[facilitiesv1.GetConsumptionRequest]) (
	*connect.Response[facilitiesv1.GetConsumptionResponse], error) {

	msg := req.Msg
	got, available, err := h.svc.Consumption(ctx,
		application.ConsumptionInput{
			MeterID: msg.GetMeterId(),
			From:    textOf(msg.GetFrom()), To: textOf(msg.GetTo()),
		})
	if err != nil {
		return nil, err
	}
	out := &facilitiesv1.GetConsumptionResponse{Available: available}
	if available {
		out.Consumption = consumptionToWire(got)
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) GetDowntime(ctx context.Context,
	req *connect.Request[facilitiesv1.GetDowntimeRequest]) (
	*connect.Response[facilitiesv1.GetDowntimeResponse], error) {

	msg := req.Msg
	found, err := h.svc.Downtime(ctx, application.DowntimeInput{
		FacilityID: msg.GetFacilityId(),
		From:       textOf(msg.GetFrom()), To: textOf(msg.GetTo()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.GetDowntimeResponse{
		Downtime: downtimeToWire(found)}), nil
}

func (h *Handler) GetPerformance(ctx context.Context,
	req *connect.Request[facilitiesv1.GetPerformanceRequest]) (
	*connect.Response[facilitiesv1.GetPerformanceResponse], error) {

	got, err := h.svc.Performance(ctx, req.Msg.GetFacilityId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.GetPerformanceResponse{
		Performance: performanceToWire(got)}), nil
}

// Contractor visits (SRS-FAC-011).

func (h *Handler) SignInVendor(ctx context.Context,
	req *connect.Request[facilitiesv1.SignInVendorRequest]) (
	*connect.Response[facilitiesv1.SignInVendorResponse], error) {

	msg := req.Msg
	visit, err := h.svc.SignInVendor(ctx, application.SignInVendorInput{
		VendorName: msg.GetVendorName(), VendorRef: msg.GetVendorRef(),
		ContactName: msg.GetContactName(),
		Technicians: msg.GetTechnicians(),
		FacilityID:  msg.GetFacilityId(),
		WorkOrderID: msg.GetWorkOrderId(), AssetID: msg.GetAssetId(),
		TaskID:       msg.GetTaskId(),
		InductionRef: msg.GetInductionRef(),
		Purpose:      msg.GetPurpose(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.SignInVendorResponse{
		Visit: visitToWire(visit)}), nil
}

func (h *Handler) SignOutVendor(ctx context.Context,
	req *connect.Request[facilitiesv1.SignOutVendorRequest]) (
	*connect.Response[facilitiesv1.SignOutVendorResponse], error) {

	msg := req.Msg
	visit, err := h.svc.SignOutVendor(ctx, application.SignOutVendorInput{
		VisitID:          msg.GetVisitId(),
		ServiceReportRef: msg.GetServiceReportRef(),
		ReportSummary:    msg.GetReportSummary(),
		PartsUsed:        msg.GetPartsUsed(),
		FollowUp:         msg.GetFollowUp(),
		Version:          msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.SignOutVendorResponse{
		Visit: visitToWire(visit)}), nil
}

func (h *Handler) ListVendorVisits(ctx context.Context,
	req *connect.Request[facilitiesv1.ListVendorVisitsRequest]) (
	*connect.Response[facilitiesv1.ListVendorVisitsResponse], error) {

	msg := req.Msg
	found, err := h.svc.ListVendorVisits(ctx, application.VisitFilterInput{
		FacilityID:  msg.GetFacilityId(),
		WorkOrderID: msg.GetWorkOrderId(), AssetID: msg.GetAssetId(),
		OnSiteOnly: msg.GetOnSiteOnly(), PageSize: msg.GetPageSize(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&facilitiesv1.ListVendorVisitsResponse{
		Visits: visitsToWire(found)}), nil
}
