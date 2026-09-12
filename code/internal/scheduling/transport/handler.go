package transport

import (
	"context"
	"time"

	"connectrpc.com/connect"
	schedulingv1 "github.com/ppusapati/health/code/gen/go/healthcare/scheduling/v1"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
	"github.com/ppusapati/health/code/internal/scheduling/application"
)

// Handler serves healthcare.scheduling.v1.AppointmentService.
type Handler struct {
	svc *application.Service
}

// NewHandler constructs the handler.
func NewHandler(svc *application.Service) *Handler { return &Handler{svc: svc} }

func fail(ctx context.Context, err error) error {
	return platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
}

// DefineResource implements SRS-SCH-001.
func (h *Handler) DefineResource(
	ctx context.Context,
	req *connect.Request[schedulingv1.DefineResourceRequest],
) (*connect.Response[schedulingv1.DefineResourceResponse], error) {
	msg := req.Msg

	resource, err := h.svc.DefineResource(ctx, application.DefineResourceInput{
		FacilityID:  msg.GetFacilityId(),
		OrgUnitID:   msg.GetOrgUnitId(),
		Type:        resourceTypeFromProto[msg.GetType()],
		SubjectID:   msg.GetSubjectId(),
		DisplayName: msg.GetDisplayName(),
		TimeZone:    msg.GetTimeZone(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&schedulingv1.DefineResourceResponse{
		Resource: resourceToProto(resource),
	}), nil
}

// SetResourceStatus implements SRS-SCH-014.
func (h *Handler) SetResourceStatus(
	ctx context.Context,
	req *connect.Request[schedulingv1.SetResourceStatusRequest],
) (*connect.Response[schedulingv1.SetResourceStatusResponse], error) {
	if err := h.svc.SetResourceStatus(ctx, req.Msg.GetResourceId(),
		resourceStatusFromProto[req.Msg.GetStatus()]); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&schedulingv1.SetResourceStatusResponse{}), nil
}

// DefineSchedule implements SRS-SCH-001.
func (h *Handler) DefineSchedule(
	ctx context.Context,
	req *connect.Request[schedulingv1.DefineScheduleRequest],
) (*connect.Response[schedulingv1.DefineScheduleResponse], error) {
	msg := req.Msg

	schedule, err := h.svc.DefineSchedule(ctx, application.DefineScheduleInput{
		ResourceID:  msg.GetResourceId(),
		VisitType:   visitTypeFromProto[msg.GetVisitType()],
		VisitMode:   visitModeFromProto[msg.GetVisitMode()],
		Weekday:     time.Weekday(msg.GetWeekday()),
		StartMinute: int(msg.GetStartMinute()),
		EndMinute:   int(msg.GetEndMinute()),
		SlotMinutes: int(msg.GetSlotMinutes()),
		Capacity:    int(msg.GetCapacity()),
		From:        fromTimestamp(msg.GetEffectiveFrom()),
		Until:       fromTimestamp(msg.GetEffectiveUntil()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&schedulingv1.DefineScheduleResponse{
		Schedule: scheduleToProto(schedule),
	}), nil
}

// BlockPeriod implements SRS-SCH-002.
func (h *Handler) BlockPeriod(
	ctx context.Context,
	req *connect.Request[schedulingv1.BlockPeriodRequest],
) (*connect.Response[schedulingv1.BlockPeriodResponse], error) {
	msg := req.Msg

	exception, err := h.svc.BlockPeriod(ctx, application.BlockPeriodInput{
		ResourceID:  msg.GetResourceId(),
		Kind:        exceptionKindFromProto[msg.GetKind()],
		StartsAt:    fromTimestamp(msg.GetStartsAt()),
		EndsAt:      fromTimestamp(msg.GetEndsAt()),
		Reason:      msg.GetReason(),
		Overridable: msg.GetOverridable(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&schedulingv1.BlockPeriodResponse{
		Exception: exceptionToProto(exception),
	}), nil
}

// UnblockPeriod removes an exception.
func (h *Handler) UnblockPeriod(
	ctx context.Context,
	req *connect.Request[schedulingv1.UnblockPeriodRequest],
) (*connect.Response[schedulingv1.UnblockPeriodResponse], error) {
	if err := h.svc.UnblockPeriod(ctx, req.Msg.GetExceptionId()); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&schedulingv1.UnblockPeriodResponse{}), nil
}

// SearchSlots implements SRS-SCH-003.
func (h *Handler) SearchSlots(
	ctx context.Context,
	req *connect.Request[schedulingv1.SearchSlotsRequest],
) (*connect.Response[schedulingv1.SearchSlotsResponse], error) {
	msg := req.Msg

	result, err := h.svc.SearchSlots(ctx, application.SearchSlotsInput{
		FacilityID: msg.GetFacilityId(),
		OrgUnitID:  msg.GetOrgUnitId(),
		ResourceID: msg.GetResourceId(),
		VisitType:  visitTypeFromProto[msg.GetVisitType()],
		VisitMode:  visitModeFromProto[msg.GetVisitMode()],
		From:       fromTimestamp(msg.GetFrom()),
		Until:      fromTimestamp(msg.GetUntil()),
		PageSize:   msg.GetPageSize(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&schedulingv1.SearchSlotsResponse{
		Slots: slotsToProto(result.Slots), Truncated: result.Truncated,
	}), nil
}

// BookAppointment implements SRS-SCH-004.
func (h *Handler) BookAppointment(
	ctx context.Context,
	req *connect.Request[schedulingv1.BookAppointmentRequest],
) (*connect.Response[schedulingv1.BookAppointmentResponse], error) {
	msg := req.Msg

	appointment, err := h.svc.BookAppointment(ctx, application.BookAppointmentInput{
		PatientID:  msg.GetPatientId(),
		ResourceID: msg.GetResourceId(),
		StartsAt:   fromTimestamp(msg.GetStartsAt()),
		VisitType:  visitTypeFromProto[msg.GetVisitType()],
		Reason:     msg.GetReason(),
		Override:   msg.GetOverride(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&schedulingv1.BookAppointmentResponse{
		Appointment: appointmentToProto(appointment),
	}), nil
}

// GetAppointment reads one booking with its status history.
func (h *Handler) GetAppointment(
	ctx context.Context,
	req *connect.Request[schedulingv1.GetAppointmentRequest],
) (*connect.Response[schedulingv1.GetAppointmentResponse], error) {
	appointment, err := h.svc.GetAppointment(ctx, req.Msg.GetAppointmentId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&schedulingv1.GetAppointmentResponse{
		Appointment: appointmentToProto(appointment),
	}), nil
}

// ListAppointments serves a patient's upcoming list and the clinic list.
func (h *Handler) ListAppointments(
	ctx context.Context,
	req *connect.Request[schedulingv1.ListAppointmentsRequest],
) (*connect.Response[schedulingv1.ListAppointmentsResponse], error) {
	msg := req.Msg

	appointments, err := h.svc.ListAppointments(ctx, application.ListAppointmentsInput{
		PatientID:  msg.GetPatientId(),
		FacilityID: msg.GetFacilityId(),
		ResourceID: msg.GetResourceId(),
		From:       fromTimestamp(msg.GetFrom()),
		Until:      fromTimestamp(msg.GetUntil()),
		PageSize:   msg.GetPageSize(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&schedulingv1.ListAppointmentsResponse{
		Appointments: appointmentsToProto(appointments),
	}), nil
}
