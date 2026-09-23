package transport

import (
	"context"
	"time"

	"connectrpc.com/connect"

	ambulancev1 "github.com/ppusapati/health/code/gen/go/healthcare/ambulance/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/ambulance/v1/ambulancev1connect"
	"github.com/ppusapati/health/code/internal/ambulance/application"
)

// Handler is the ambulance ConnectRPC surface.
//
// Thin on purpose: it translates, calls one use case and translates back.
// Every refusal comes from the application or the domain, so the same rule
// holds whichever client asks — a second client cannot be written that
// forgets a van does not answer a cardiac arrest.
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

var _ ambulancev1connect.AmbulanceServiceHandler = (*Handler)(nil)

// Fleet and crew (SRS-AMB-002).

func (h *Handler) RegisterVehicle(ctx context.Context,
	req *connect.Request[ambulancev1.RegisterVehicleRequest]) (
	*connect.Response[ambulancev1.RegisterVehicleResponse], error) {

	msg := req.Msg
	vehicle, err := h.svc.RegisterVehicle(ctx,
		application.RegisterVehicleInput{
			Registration: msg.GetRegistration(),
			CallSign:     msg.GetCallSign(),
			Kind:         string(vehicleKindFromWire[msg.GetKind()]),
			FacilityID:   msg.GetFacilityId(), BaseID: msg.GetBaseId(),
			Capabilities: msg.GetCapabilities(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.RegisterVehicleResponse{
		Vehicle: vehicleToWire(vehicle),
	}), nil
}

func (h *Handler) SetVehicleState(ctx context.Context,
	req *connect.Request[ambulancev1.SetVehicleStateRequest]) (
	*connect.Response[ambulancev1.SetVehicleStateResponse], error) {

	msg := req.Msg
	vehicle, err := h.svc.SetVehicleState(ctx,
		application.SetVehicleStateInput{
			VehicleID: msg.GetVehicleId(),
			State:     string(vehicleStateFromWire[msg.GetState()]),
			CheckID:   msg.GetCheckId(), Reason: msg.GetReason(),
			Version: msg.GetVersion(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.SetVehicleStateResponse{
		Vehicle: vehicleToWire(vehicle),
	}), nil
}

func (h *Handler) GetVehicle(ctx context.Context,
	req *connect.Request[ambulancev1.GetVehicleRequest]) (
	*connect.Response[ambulancev1.GetVehicleResponse], error) {

	vehicle, err := h.svc.Vehicle(ctx, req.Msg.GetVehicleId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.GetVehicleResponse{
		Vehicle: vehicleToWire(vehicle),
	}), nil
}

func (h *Handler) ListVehicles(ctx context.Context,
	req *connect.Request[ambulancev1.ListVehiclesRequest]) (
	*connect.Response[ambulancev1.ListVehiclesResponse], error) {

	msg := req.Msg
	vehicles, err := h.svc.ListVehicles(ctx, application.ListVehiclesInput{
		States:     textsFromWire(msg.GetStates(), vehicleStateFromWire),
		Kinds:      textsFromWire(msg.GetKinds(), vehicleKindFromWire),
		FacilityID: msg.GetFacilityId(),
		PageSize:   msg.GetPageSize(), Offset: msg.GetOffset(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*ambulancev1.Vehicle, 0, len(vehicles))
	for _, vehicle := range vehicles {
		out = append(out, vehicleToWire(vehicle))
	}
	return connect.NewResponse(&ambulancev1.ListVehiclesResponse{
		Vehicles: out,
	}), nil
}

func (h *Handler) RosterShift(ctx context.Context,
	req *connect.Request[ambulancev1.RosterShiftRequest]) (
	*connect.Response[ambulancev1.RosterShiftResponse], error) {

	msg := req.Msg
	shift, err := h.svc.RosterShift(ctx, application.RosterShiftInput{
		VehicleID: msg.GetVehicleId(), FacilityID: msg.GetFacilityId(),
		Crew:     crewFromWire(msg.GetCrew()),
		StartsAt: timeOf(msg.GetStartsAt()), EndsAt: timeOf(msg.GetEndsAt()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.RosterShiftResponse{
		Shift: shiftToWire(shift),
	}), nil
}

func (h *Handler) SetShiftState(ctx context.Context,
	req *connect.Request[ambulancev1.SetShiftStateRequest]) (
	*connect.Response[ambulancev1.SetShiftStateResponse], error) {

	msg := req.Msg
	shift, err := h.svc.SetShiftState(ctx, application.SetShiftStateInput{
		ShiftID: msg.GetShiftId(),
		State:   string(shiftStateFromWire[msg.GetState()]),
		Version: msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.SetShiftStateResponse{
		Shift: shiftToWire(shift),
	}), nil
}

func (h *Handler) GetShift(ctx context.Context,
	req *connect.Request[ambulancev1.GetShiftRequest]) (
	*connect.Response[ambulancev1.GetShiftResponse], error) {

	shift, err := h.svc.Shift(ctx, req.Msg.GetShiftId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.GetShiftResponse{
		Shift: shiftToWire(shift),
	}), nil
}

func (h *Handler) ListShifts(ctx context.Context,
	req *connect.Request[ambulancev1.ListShiftsRequest]) (
	*connect.Response[ambulancev1.ListShiftsResponse], error) {

	msg := req.Msg
	shifts, err := h.svc.ListShifts(ctx, application.ListShiftsInput{
		VehicleID: msg.GetVehicleId(), FacilityID: msg.GetFacilityId(),
		States: textsFromWire(msg.GetStates(), shiftStateFromWire),
		From:   timeOf(msg.GetFrom()), To: timeOf(msg.GetTo()),
		PageSize: msg.GetPageSize(), Offset: msg.GetOffset(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*ambulancev1.Shift, 0, len(shifts))
	for _, shift := range shifts {
		out = append(out, shiftToWire(shift))
	}
	return connect.NewResponse(&ambulancev1.ListShiftsResponse{
		Shifts: out,
	}), nil
}

// Readiness (SRS-AMB-006).

func (h *Handler) RecordReadinessCheck(ctx context.Context,
	req *connect.Request[ambulancev1.RecordReadinessCheckRequest]) (
	*connect.Response[ambulancev1.RecordReadinessCheckResponse], error) {

	msg := req.Msg
	items := make([]application.ChecklistItemInput, 0, len(msg.GetItems()))
	for _, item := range msg.GetItems() {
		items = append(items, application.ChecklistItemInput{
			Code: item.GetCode(), Label: item.GetLabel(),
			Critical: item.GetCritical(),
		})
	}
	outcomes := make([]application.ItemOutcomeInput, 0,
		len(msg.GetOutcomes()))
	for _, outcome := range msg.GetOutcomes() {
		outcomes = append(outcomes, application.ItemOutcomeInput{
			Code: outcome.GetCode(), Present: outcome.GetPresent(),
			Note: outcome.GetNote(),
		})
	}

	check, err := h.svc.RecordCheck(ctx, application.RecordCheckInput{
		VehicleID: msg.GetVehicleId(), ShiftID: msg.GetShiftId(),
		FacilityID: msg.GetFacilityId(), Items: items,
		Outcomes: outcomes, OxygenBar: int(msg.GetOxygenBar()),
		OxygenMinimumBar: int(msg.GetOxygenMinimumBar()),
		ValidFor:         time.Duration(msg.GetValidForSeconds()) * time.Second,
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.RecordReadinessCheckResponse{
		Check: checkToWire(check),
	}), nil
}

func (h *Handler) OverrideReadinessCheck(ctx context.Context,
	req *connect.Request[ambulancev1.OverrideReadinessCheckRequest]) (
	*connect.Response[ambulancev1.OverrideReadinessCheckResponse], error) {

	msg := req.Msg
	check, err := h.svc.OverrideCheck(ctx, application.OverrideCheckInput{
		CheckID: msg.GetCheckId(), Reason: msg.GetReason(),
		Version: msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.OverrideReadinessCheckResponse{
		Check: checkToWire(check),
	}), nil
}

func (h *Handler) GetReadinessCheck(ctx context.Context,
	req *connect.Request[ambulancev1.GetReadinessCheckRequest]) (
	*connect.Response[ambulancev1.GetReadinessCheckResponse], error) {

	check, err := h.svc.Check(ctx, req.Msg.GetCheckId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.GetReadinessCheckResponse{
		Check: checkToWire(check),
	}), nil
}

func (h *Handler) ListReadinessChecks(ctx context.Context,
	req *connect.Request[ambulancev1.ListReadinessChecksRequest]) (
	*connect.Response[ambulancev1.ListReadinessChecksResponse], error) {

	msg := req.Msg
	checks, err := h.svc.ListChecks(ctx, application.ListChecksInput{
		VehicleID: msg.GetVehicleId(), FacilityID: msg.GetFacilityId(),
		States: textsFromWire(msg.GetStates(), checkStateFromWire),
		From:   timeOf(msg.GetFrom()), To: timeOf(msg.GetTo()),
		PageSize: msg.GetPageSize(), Offset: msg.GetOffset(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*ambulancev1.ReadinessCheck, 0, len(checks))
	for _, check := range checks {
		out = append(out, checkToWire(check))
	}
	return connect.NewResponse(&ambulancev1.ListReadinessChecksResponse{
		Checks: out,
	}), nil
}

func (h *Handler) GetReadinessSummary(ctx context.Context,
	req *connect.Request[ambulancev1.GetReadinessSummaryRequest]) (
	*connect.Response[ambulancev1.GetReadinessSummaryResponse], error) {

	msg := req.Msg
	summary, err := h.svc.ReadinessSummary(ctx,
		application.ListChecksInput{
			VehicleID:  msg.GetVehicleId(),
			FacilityID: msg.GetFacilityId(),
			From:       timeOf(msg.GetFrom()), To: timeOf(msg.GetTo()),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.GetReadinessSummaryResponse{
		Summary: readinessSummaryToWire(summary),
	}), nil
}

// Requests and the dispatch queue (SRS-AMB-001).

func (h *Handler) RaiseRequest(ctx context.Context,
	req *connect.Request[ambulancev1.RaiseRequestRequest]) (
	*connect.Response[ambulancev1.RaiseRequestResponse], error) {

	msg := req.Msg
	request, err := h.svc.RaiseRequest(ctx, application.RaiseRequestInput{
		Kind:                  string(requestKindFromWire[msg.GetKind()]),
		Priority:              string(priorityFromWire[msg.GetPriority()]),
		PatientID:             msg.GetPatientId(),
		EncounterID:           msg.GetEncounterId(),
		OriginName:            msg.GetOriginName(),
		OriginAddress:         msg.GetOriginAddress(),
		OriginFacilityID:      msg.GetOriginFacilityId(),
		DestinationName:       msg.GetDestinationName(),
		DestinationAddress:    msg.GetDestinationAddress(),
		DestinationFacilityID: msg.GetDestinationFacilityId(),
		ClinicalNeed:          msg.GetClinicalNeed(),
		RequiredCapabilities:  msg.GetRequiredCapabilities(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.RaiseRequestResponse{
		Request: requestToWire(request),
	}), nil
}

func (h *Handler) CancelRequest(ctx context.Context,
	req *connect.Request[ambulancev1.CancelRequestRequest]) (
	*connect.Response[ambulancev1.CancelRequestResponse], error) {

	msg := req.Msg
	request, err := h.svc.CancelRequest(ctx, application.CancelRequestInput{
		RequestID: msg.GetRequestId(), Reason: msg.GetReason(),
		Version: msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.CancelRequestResponse{
		Request: requestToWire(request),
	}), nil
}

func (h *Handler) GetRequest(ctx context.Context,
	req *connect.Request[ambulancev1.GetRequestRequest]) (
	*connect.Response[ambulancev1.GetRequestResponse], error) {

	request, err := h.svc.Request(ctx, req.Msg.GetRequestId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.GetRequestResponse{
		Request: requestToWire(request),
	}), nil
}

func (h *Handler) ListRequests(ctx context.Context,
	req *connect.Request[ambulancev1.ListRequestsRequest]) (
	*connect.Response[ambulancev1.ListRequestsResponse], error) {

	msg := req.Msg
	requests, err := h.svc.ListRequests(ctx, application.ListRequestsInput{
		States:     textsFromWire(msg.GetStates(), requestStateFromWire),
		Priorities: textsFromWire(msg.GetPriorities(), priorityFromWire),
		Kinds:      textsFromWire(msg.GetKinds(), requestKindFromWire),
		FacilityID: msg.GetFacilityId(), PatientID: msg.GetPatientId(),
		From: timeOf(msg.GetFrom()), To: timeOf(msg.GetTo()),
		PageSize: msg.GetPageSize(), Offset: msg.GetOffset(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.ListRequestsResponse{
		Requests: requestsToWire(requests),
	}), nil
}

func (h *Handler) GetDispatchQueue(ctx context.Context,
	req *connect.Request[ambulancev1.GetDispatchQueueRequest]) (
	*connect.Response[ambulancev1.GetDispatchQueueResponse], error) {

	requests, err := h.svc.DispatchQueue(ctx, req.Msg.GetFacilityId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.GetDispatchQueueResponse{
		Requests: requestsToWire(requests),
	}), nil
}

// Trips and timelines (SRS-AMB-003).

func (h *Handler) Dispatch(ctx context.Context,
	req *connect.Request[ambulancev1.DispatchRequest]) (
	*connect.Response[ambulancev1.DispatchResponse], error) {

	msg := req.Msg
	trip, err := h.svc.Dispatch(ctx, application.DispatchInput{
		RequestID: msg.GetRequestId(), VehicleID: msg.GetVehicleId(),
		ShiftID:        msg.GetShiftId(),
		OverrideReason: msg.GetOverrideReason(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.DispatchResponse{
		Trip: tripToWire(trip),
	}), nil
}

func (h *Handler) RecordTripMilestone(ctx context.Context,
	req *connect.Request[ambulancev1.RecordTripMilestoneRequest]) (
	*connect.Response[ambulancev1.RecordTripMilestoneResponse], error) {

	msg := req.Msg
	trip, err := h.svc.RecordMilestone(ctx,
		application.RecordMilestoneInput{
			TripID:    msg.GetTripId(),
			Milestone: string(milestoneFromWire[msg.GetMilestone()]),
			At:        timeOf(msg.GetOccurredAt()), Note: msg.GetNote(),
			Version: msg.GetVersion(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.RecordTripMilestoneResponse{
		Trip: tripToWire(trip),
	}), nil
}

func (h *Handler) AmendTripMilestone(ctx context.Context,
	req *connect.Request[ambulancev1.AmendTripMilestoneRequest]) (
	*connect.Response[ambulancev1.AmendTripMilestoneResponse], error) {

	msg := req.Msg
	trip, err := h.svc.AmendMilestone(ctx, application.AmendMilestoneInput{
		TripID:    msg.GetTripId(),
		Milestone: string(milestoneFromWire[msg.GetMilestone()]),
		At:        timeOf(msg.GetOccurredAt()), Reason: msg.GetReason(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.AmendTripMilestoneResponse{
		Trip: tripToWire(trip),
	}), nil
}

func (h *Handler) AbortTrip(ctx context.Context,
	req *connect.Request[ambulancev1.AbortTripRequest]) (
	*connect.Response[ambulancev1.AbortTripResponse], error) {

	msg := req.Msg
	trip, err := h.svc.AbortTrip(ctx, application.AbortTripInput{
		TripID: msg.GetTripId(), Reason: msg.GetReason(),
		Version: msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.AbortTripResponse{
		Trip: tripToWire(trip),
	}), nil
}

func (h *Handler) GetTrip(ctx context.Context,
	req *connect.Request[ambulancev1.GetTripRequest]) (
	*connect.Response[ambulancev1.GetTripResponse], error) {

	trip, err := h.svc.Trip(ctx, req.Msg.GetTripId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.GetTripResponse{
		Trip: tripToWire(trip),
	}), nil
}

func (h *Handler) ListTrips(ctx context.Context,
	req *connect.Request[ambulancev1.ListTripsRequest]) (
	*connect.Response[ambulancev1.ListTripsResponse], error) {

	msg := req.Msg
	trips, err := h.svc.ListTrips(ctx, listTripsInput(msg))
	if err != nil {
		return nil, err
	}
	out := make([]*ambulancev1.Trip, 0, len(trips))
	for _, trip := range trips {
		out = append(out, tripToWire(trip))
	}
	return connect.NewResponse(&ambulancev1.ListTripsResponse{
		Trips: out,
	}), nil
}

func (h *Handler) GetTimelineGaps(ctx context.Context,
	req *connect.Request[ambulancev1.GetTimelineGapsRequest]) (
	*connect.Response[ambulancev1.GetTimelineGapsResponse], error) {

	gaps, err := h.svc.TimelineGaps(ctx, req.Msg.GetTripId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.GetTimelineGapsResponse{
		Gaps: milestonesToWire(gaps),
	}), nil
}

// The crew's account of a journey (SRS-AMB-004, SRS-AMB-007).

func (h *Handler) OpenPrehospitalRecord(ctx context.Context,
	req *connect.Request[ambulancev1.OpenPrehospitalRecordRequest]) (
	*connect.Response[ambulancev1.OpenPrehospitalRecordResponse], error) {

	msg := req.Msg
	record, err := h.svc.OpenRecord(ctx, application.OpenRecordInput{
		TripID: msg.GetTripId(), PatientID: msg.GetPatientId(),
		FacilityID:          msg.GetFacilityId(),
		PresentingComplaint: msg.GetPresentingComplaint(),
		DocumentRefs:        msg.GetDocumentRefs(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.OpenPrehospitalRecordResponse{
		Record: recordToWire(record),
	}), nil
}

func (h *Handler) RecordPrehospitalEntry(ctx context.Context,
	req *connect.Request[ambulancev1.RecordPrehospitalEntryRequest]) (
	*connect.Response[ambulancev1.RecordPrehospitalEntryResponse], error) {

	msg := req.Msg
	record, err := h.svc.RecordEntry(ctx, application.RecordEntryInput{
		RecordID: msg.GetRecordId(),
		Kind:     string(entryKindFromWire[msg.GetKind()]),
		Code:     msg.GetCode(), Label: msg.GetLabel(),
		Value: msg.GetValue(), Unit: msg.GetUnit(),
		DoseAmount: int(msg.GetDoseAmount()),
		DoseUnit:   msg.GetDoseUnit(), Route: msg.GetRoute(),
		Narrative:  msg.GetNarrative(),
		RecordedAt: timeOf(msg.GetRecordedAt()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.RecordPrehospitalEntryResponse{
		Record: recordToWire(record),
	}), nil
}

func (h *Handler) AttachTransferDocument(ctx context.Context,
	req *connect.Request[ambulancev1.AttachTransferDocumentRequest]) (
	*connect.Response[ambulancev1.AttachTransferDocumentResponse], error) {

	msg := req.Msg
	record, err := h.svc.AttachDocument(ctx,
		application.AttachDocumentInput{
			RecordID:    msg.GetRecordId(),
			DocumentRef: msg.GetDocumentRef(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.AttachTransferDocumentResponse{
		Record: recordToWire(record),
	}), nil
}

func (h *Handler) GiveHandover(ctx context.Context,
	req *connect.Request[ambulancev1.GiveHandoverRequest]) (
	*connect.Response[ambulancev1.GiveHandoverResponse], error) {

	msg := req.Msg
	record, err := h.svc.GiveHandover(ctx, application.GiveHandoverInput{
		RecordID: msg.GetRecordId(), Summary: msg.GetSummary(),
		Impression: msg.GetImpression(), Version: msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.GiveHandoverResponse{
		Record: recordToWire(record),
	}), nil
}

func (h *Handler) AcceptHandover(ctx context.Context,
	req *connect.Request[ambulancev1.AcceptHandoverRequest]) (
	*connect.Response[ambulancev1.AcceptHandoverResponse], error) {

	msg := req.Msg
	record, err := h.svc.AcceptHandover(ctx,
		application.AcceptHandoverInput{
			RecordID:    msg.GetRecordId(),
			EncounterID: msg.GetEncounterId(), Note: msg.GetNote(),
			Version: msg.GetVersion(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.AcceptHandoverResponse{
		Record: recordToWire(record),
	}), nil
}

func (h *Handler) GetPrehospitalRecord(ctx context.Context,
	req *connect.Request[ambulancev1.GetPrehospitalRecordRequest]) (
	*connect.Response[ambulancev1.GetPrehospitalRecordResponse], error) {

	record, err := h.svc.Record(ctx, req.Msg.GetRecordId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.GetPrehospitalRecordResponse{
		Record: recordToWire(record),
	}), nil
}

func (h *Handler) ListPrehospitalRecords(ctx context.Context,
	req *connect.Request[ambulancev1.ListPrehospitalRecordsRequest]) (
	*connect.Response[ambulancev1.ListPrehospitalRecordsResponse], error) {

	msg := req.Msg
	records, err := h.svc.ListRecords(ctx, application.ListRecordsInput{
		States:     textsFromWire(msg.GetStates(), handoverStateFromWire),
		FacilityID: msg.GetFacilityId(), PatientID: msg.GetPatientId(),
		From: timeOf(msg.GetFrom()), To: timeOf(msg.GetTo()),
		PageSize: msg.GetPageSize(), Offset: msg.GetOffset(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*ambulancev1.PrehospitalRecord, 0, len(records))
	for _, record := range records {
		out = append(out, recordToWire(record))
	}
	return connect.NewResponse(&ambulancev1.ListPrehospitalRecordsResponse{
		Records: out,
	}), nil
}

func (h *Handler) SweepWaitingHandovers(ctx context.Context,
	req *connect.Request[ambulancev1.SweepWaitingHandoversRequest]) (
	*connect.Response[ambulancev1.SweepWaitingHandoversResponse], error) {

	raised, err := h.svc.SweepWaitingHandovers(ctx,
		req.Msg.GetFacilityId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.SweepWaitingHandoversResponse{
		Raised: int32(raised),
	}), nil
}

// The location feed (SRS-AMB-005).

func (h *Handler) RecordPing(ctx context.Context,
	req *connect.Request[ambulancev1.RecordPingRequest]) (
	*connect.Response[ambulancev1.RecordPingResponse], error) {

	msg := req.Msg
	ping, err := h.svc.RecordPing(ctx, application.RecordPingInput{
		VehicleID: msg.GetVehicleId(), TripID: msg.GetTripId(),
		LatitudeMicro:  int(msg.GetLatitudeMicro()),
		LongitudeMicro: int(msg.GetLongitudeMicro()),
		SpeedKph:       int(msg.GetSpeedKph()),
		HeadingDegrees: int(msg.GetHeadingDegrees()),
		AccuracyMetres: int(msg.GetAccuracyMetres()),
		Source:         msg.GetSource(),
		At:             timeOf(msg.GetOccurredAt()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.RecordPingResponse{
		Ping: pingToWire(ping),
	}), nil
}

func (h *Handler) RecordETA(ctx context.Context,
	req *connect.Request[ambulancev1.RecordETARequest]) (
	*connect.Response[ambulancev1.RecordETAResponse], error) {

	msg := req.Msg
	eta, err := h.svc.RecordETA(ctx, application.RecordETAInput{
		VehicleID: msg.GetVehicleId(), TripID: msg.GetTripId(),
		Seconds:        int(msg.GetSeconds()),
		DistanceMetres: int(msg.GetDistanceMetres()),
		Source:         msg.GetSource(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.RecordETAResponse{
		Eta: etaToWire(eta),
	}), nil
}

func (h *Handler) GetVehiclePosition(ctx context.Context,
	req *connect.Request[ambulancev1.GetVehiclePositionRequest]) (
	*connect.Response[ambulancev1.GetVehiclePositionResponse], error) {

	msg := req.Msg
	out, err := h.svc.Position(ctx, msg.GetVehicleId(), msg.GetTripId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.GetVehiclePositionResponse{
		Position: positionToWire(out.Position), Eta: etaToWire(out.ETA),
	}), nil
}

func (h *Handler) ListPings(ctx context.Context,
	req *connect.Request[ambulancev1.ListPingsRequest]) (
	*connect.Response[ambulancev1.ListPingsResponse], error) {

	msg := req.Msg
	pings, err := h.svc.ListPings(ctx, application.ListPingsInput{
		VehicleID: msg.GetVehicleId(), TripID: msg.GetTripId(),
		From: timeOf(msg.GetFrom()), To: timeOf(msg.GetTo()),
		PageSize: msg.GetPageSize(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*ambulancev1.Ping, 0, len(pings))
	for _, ping := range pings {
		out = append(out, pingToWire(ping))
	}
	return connect.NewResponse(&ambulancev1.ListPingsResponse{
		Pings: out,
	}), nil
}

func (h *Handler) PurgeExpiredPings(ctx context.Context,
	req *connect.Request[ambulancev1.PurgeExpiredPingsRequest]) (
	*connect.Response[ambulancev1.PurgeExpiredPingsResponse], error) {

	removed, err := h.svc.PurgeExpiredPings(ctx)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.PurgeExpiredPingsResponse{
		Removed: removed,
	}), nil
}

// Reporting (SRS-AMB-008).

func (h *Handler) GetTripMetrics(ctx context.Context,
	req *connect.Request[ambulancev1.GetTripMetricsRequest]) (
	*connect.Response[ambulancev1.GetTripMetricsResponse], error) {

	tripID := req.Msg.GetTripId()
	metrics, err := h.svc.TripMetrics(ctx, tripID)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.GetTripMetricsResponse{
		Metrics: metricsToWire(tripID, metrics),
	}), nil
}

func (h *Handler) GetServiceSummary(ctx context.Context,
	req *connect.Request[ambulancev1.GetServiceSummaryRequest]) (
	*connect.Response[ambulancev1.GetServiceSummaryResponse], error) {

	msg := req.Msg
	report, err := h.svc.ServiceSummary(ctx, application.ListTripsInput{
		States:    textsFromWire(msg.GetStates(), tripStateFromWire),
		VehicleID: msg.GetVehicleId(), FacilityID: msg.GetFacilityId(),
		From: timeOf(msg.GetFrom()), To: timeOf(msg.GetTo()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&ambulancev1.GetServiceSummaryResponse{
		Summary:   summaryToWire(report.Summary),
		Truncated: report.Truncated,
	}), nil
}

func listTripsInput(
	msg *ambulancev1.ListTripsRequest) application.ListTripsInput {

	return application.ListTripsInput{
		States:    textsFromWire(msg.GetStates(), tripStateFromWire),
		VehicleID: msg.GetVehicleId(), FacilityID: msg.GetFacilityId(),
		From: timeOf(msg.GetFrom()), To: timeOf(msg.GetTo()),
		PageSize: msg.GetPageSize(), Offset: msg.GetOffset(),
	}
}
