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

// CancelAppointment implements SRS-SCH-005.
func (h *Handler) CancelAppointment(
	ctx context.Context,
	req *connect.Request[schedulingv1.CancelAppointmentRequest],
) (*connect.Response[schedulingv1.CancelAppointmentResponse], error) {
	result, err := h.svc.CancelAppointment(ctx, application.CancelAppointmentInput{
		AppointmentID: req.Msg.GetAppointmentId(),
		Reason:        req.Msg.GetReason(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&schedulingv1.CancelAppointmentResponse{
		Appointment: appointmentToProto(result.Appointment),
		Outcome:     outcomeToProto(result.Outcome),
	}), nil
}

// RescheduleAppointment implements SRS-SCH-005.
func (h *Handler) RescheduleAppointment(
	ctx context.Context,
	req *connect.Request[schedulingv1.RescheduleAppointmentRequest],
) (*connect.Response[schedulingv1.RescheduleAppointmentResponse], error) {
	msg := req.Msg

	result, err := h.svc.RescheduleAppointment(ctx, application.RescheduleAppointmentInput{
		AppointmentID: msg.GetAppointmentId(),
		ResourceID:    msg.GetResourceId(),
		StartsAt:      fromTimestamp(msg.GetStartsAt()),
		VisitType:     visitTypeFromProto[msg.GetVisitType()],
		Reason:        msg.GetReason(),
		Override:      msg.GetOverride(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&schedulingv1.RescheduleAppointmentResponse{
		Appointment:           appointmentToProto(result.Appointment),
		PreviousAppointmentId: result.PreviousID,
		Outcome:               outcomeToProto(result.Outcome),
	}), nil
}

// SetSchedulingPolicy implements SRS-SCH-005 and SRS-SCH-015.
func (h *Handler) SetSchedulingPolicy(
	ctx context.Context,
	req *connect.Request[schedulingv1.SetSchedulingPolicyRequest],
) (*connect.Response[schedulingv1.SetSchedulingPolicyResponse], error) {
	cancellation, teleconsult := policyFromProto(req.Msg.GetPolicy())

	if err := h.svc.SetSchedulingPolicy(ctx, application.SetSchedulingPolicyInput{
		FacilityID:   req.Msg.GetFacilityId(),
		Cancellation: cancellation,
		Teleconsult:  teleconsult,
	}); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&schedulingv1.SetSchedulingPolicyResponse{}), nil
}

// BookSeries implements SRS-SCH-013.
func (h *Handler) BookSeries(
	ctx context.Context,
	req *connect.Request[schedulingv1.BookSeriesRequest],
) (*connect.Response[schedulingv1.BookSeriesResponse], error) {
	msg := req.Msg

	result, err := h.svc.BookSeries(ctx, application.BookSeriesInput{
		PatientID:    msg.GetPatientId(),
		ResourceID:   msg.GetResourceId(),
		StartsAt:     fromTimestamp(msg.GetStartsAt()),
		VisitType:    visitTypeFromProto[msg.GetVisitType()],
		IntervalDays: int(msg.GetIntervalDays()),
		Occurrences:  int(msg.GetOccurrences()),
		Reason:       msg.GetReason(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&schedulingv1.BookSeriesResponse{
		SeriesId:     result.Series.ID,
		Appointments: appointmentsToProto(result.Booked),
		Unavailable:  timestamps(result.Unavailable),
	}), nil
}

// CancelSeries implements SRS-SCH-013.
func (h *Handler) CancelSeries(
	ctx context.Context,
	req *connect.Request[schedulingv1.CancelSeriesRequest],
) (*connect.Response[schedulingv1.CancelSeriesResponse], error) {
	msg := req.Msg

	result, err := h.svc.CancelSeries(ctx, application.CancelSeriesInput{
		SeriesID:          msg.GetSeriesId(),
		FromAppointmentID: msg.GetFromAppointmentId(),
		Scope:             seriesScopeFromProto[msg.GetScope()],
		Reason:            msg.GetReason(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&schedulingv1.CancelSeriesResponse{
		CancelledAppointmentIds: result.Cancelled,
	}), nil
}

// JoinWaitlist implements SRS-SCH-006.
func (h *Handler) JoinWaitlist(
	ctx context.Context,
	req *connect.Request[schedulingv1.JoinWaitlistRequest],
) (*connect.Response[schedulingv1.JoinWaitlistResponse], error) {
	msg := req.Msg

	entry, err := h.svc.JoinWaitlist(ctx, application.JoinWaitlistInput{
		PatientID:     msg.GetPatientId(),
		ResourceID:    msg.GetResourceId(),
		FacilityID:    msg.GetFacilityId(),
		OrgUnitID:     msg.GetOrgUnitId(),
		VisitType:     visitTypeFromProto[msg.GetVisitType()],
		NotBefore:     fromTimestamp(msg.GetNotBefore()),
		NotAfter:      fromTimestamp(msg.GetNotAfter()),
		AppointmentID: msg.GetAppointmentId(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&schedulingv1.JoinWaitlistResponse{
		Entry: waitlistToProto(entry),
	}), nil
}

// OfferWaitlistSlot implements SRS-SCH-006.
func (h *Handler) OfferWaitlistSlot(
	ctx context.Context,
	req *connect.Request[schedulingv1.OfferWaitlistSlotRequest],
) (*connect.Response[schedulingv1.OfferWaitlistSlotResponse], error) {
	msg := req.Msg

	entry, err := h.svc.OfferWaitlistSlot(ctx, application.OfferWaitlistSlotInput{
		WaitlistID: msg.GetWaitlistId(),
		ResourceID: msg.GetResourceId(),
		StartsAt:   fromTimestamp(msg.GetStartsAt()),
		VisitType:  visitTypeFromProto[msg.GetVisitType()],
		ValidFor:   time.Duration(msg.GetValidForMinutes()) * time.Minute,
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&schedulingv1.OfferWaitlistSlotResponse{
		Entry: waitlistToProto(entry),
	}), nil
}

// AcceptWaitlistOffer implements SRS-SCH-006.
func (h *Handler) AcceptWaitlistOffer(
	ctx context.Context,
	req *connect.Request[schedulingv1.AcceptWaitlistOfferRequest],
) (*connect.Response[schedulingv1.AcceptWaitlistOfferResponse], error) {
	result, err := h.svc.AcceptWaitlistOffer(ctx, req.Msg.GetWaitlistId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&schedulingv1.AcceptWaitlistOfferResponse{
		Entry:                 waitlistToProto(result.Entry),
		Appointment:           appointmentToProto(result.Appointment),
		ReplacedAppointmentId: result.ReplacedID,
	}), nil
}

// DeclineWaitlistOffer returns a patient to the list.
func (h *Handler) DeclineWaitlistOffer(
	ctx context.Context,
	req *connect.Request[schedulingv1.DeclineWaitlistOfferRequest],
) (*connect.Response[schedulingv1.DeclineWaitlistOfferResponse], error) {
	entry, err := h.svc.DeclineWaitlistOffer(ctx, req.Msg.GetWaitlistId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&schedulingv1.DeclineWaitlistOfferResponse{
		Entry: waitlistToProto(entry),
	}), nil
}

// ListWaitlist serves the list a scheduler works when a slot frees up.
func (h *Handler) ListWaitlist(
	ctx context.Context,
	req *connect.Request[schedulingv1.ListWaitlistRequest],
) (*connect.Response[schedulingv1.ListWaitlistResponse], error) {
	entries, err := h.svc.ListWaitlist(ctx, req.Msg.GetResourceId(), req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&schedulingv1.ListWaitlistResponse{
		Entries: waitlistsToProto(entries),
	}), nil
}

// ExpireWaitlistOffers returns unanswered offers to the waiting list.
func (h *Handler) ExpireWaitlistOffers(
	ctx context.Context,
	req *connect.Request[schedulingv1.ExpireWaitlistOffersRequest],
) (*connect.Response[schedulingv1.ExpireWaitlistOffersResponse], error) {
	expired, err := h.svc.ExpireWaitlistOffers(ctx)
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&schedulingv1.ExpireWaitlistOffersResponse{
		Expired: expired,
	}), nil
}
