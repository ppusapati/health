package transport

import (
	"context"

	"connectrpc.com/connect"

	emergencyv1 "github.com/ppusapati/health/code/gen/go/healthcare/emergency/v1"
	"github.com/ppusapati/health/code/internal/emergency/application"
	"github.com/ppusapati/health/code/internal/emergency/domain"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
)

// Handler adapts the emergency service to ConnectRPC.
type Handler struct {
	svc *application.Service
}

// NewHandler constructs a Handler.
func NewHandler(svc *application.Service) *Handler { return &Handler{svc: svc} }

func fail(ctx context.Context, err error) error {
	return platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
}

func intOrNil(v *int32) *int {
	if v == nil {
		return nil
	}
	out := int(*v)
	return &out
}

// Arrive books a patient into the department (SRS-ER-001).
func (h *Handler) Arrive(
	ctx context.Context,
	req *connect.Request[emergencyv1.ArriveRequest],
) (*connect.Response[emergencyv1.ArriveResponse], error) {
	msg := req.Msg

	visit, err := h.svc.Arrive(ctx, application.ArriveInput{
		EncounterID: msg.GetEncounterId(), PatientID: msg.GetPatientId(),
		FacilityID:     msg.GetFacilityId(),
		ArrivalMode:    arrivalFromProto[msg.GetArrivalMode()],
		ChiefComplaint: msg.GetChiefComplaint(),
		ArrivedAt:      fromTimestamp(msg.GetArrivedAt()),
		Unidentified:   msg.GetUnidentified(),
		TemporaryName:  msg.GetTemporaryName(),
		MedicoLegal:    msg.GetMedicoLegal(),
		MedicoLegalRef: msg.GetMedicoLegalRef(),
		Location:       msg.GetLocation(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&emergencyv1.ArriveResponse{
		Visit: visitToProto(visit, false),
	}), nil
}

// GetEmergencyVisit returns one visit's whole emergency record.
func (h *Handler) GetEmergencyVisit(
	ctx context.Context,
	req *connect.Request[emergencyv1.GetEmergencyVisitRequest],
) (*connect.Response[emergencyv1.GetEmergencyVisitResponse], error) {
	record, err := h.svc.Record(ctx, req.Msg.GetVisitId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(recordToProto(record)), nil
}

// IdentifyPatient reconciles an unidentified emergency patient (SRS-ER-004).
func (h *Handler) IdentifyPatient(
	ctx context.Context,
	req *connect.Request[emergencyv1.IdentifyPatientRequest],
) (*connect.Response[emergencyv1.IdentifyPatientResponse], error) {
	visit, err := h.svc.Identify(ctx, application.IdentifyInput{
		VisitID: req.Msg.GetVisitId(), PatientID: req.Msg.GetPatientId(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&emergencyv1.IdentifyPatientResponse{
		Visit: visitToProto(visit, false),
	}), nil
}

// AssignTriage records a triage assessment (SRS-ER-002).
func (h *Handler) AssignTriage(
	ctx context.Context,
	req *connect.Request[emergencyv1.AssignTriageRequest],
) (*connect.Response[emergencyv1.AssignTriageResponse], error) {
	msg := req.Msg

	triage, err := h.svc.Triage(ctx, application.TriageInput{
		VisitID: msg.GetVisitId(), AcuityCode: msg.GetAcuityCode(),
		RespiratoryRate:  intOrNil(msg.RespiratoryRate),
		HeartRate:        intOrNil(msg.HeartRate),
		SystolicBP:       intOrNil(msg.SystolicBp),
		OxygenSaturation: intOrNil(msg.OxygenSaturation),
		Temperature:      msg.Temperature,
		PainScore:        intOrNil(msg.PainScore),
		Consciousness:    msg.GetConsciousness(),
		RedFlags:         msg.GetRedFlags(),
		Note:             msg.GetNote(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&emergencyv1.AssignTriageResponse{
		Triage: triageToProto(triage),
	}), nil
}

// OverridePriority moves a patient in the queue (SRS-ER-003).
func (h *Handler) OverridePriority(
	ctx context.Context,
	req *connect.Request[emergencyv1.OverridePriorityRequest],
) (*connect.Response[emergencyv1.OverridePriorityResponse], error) {
	if err := h.svc.Override(ctx, application.OverrideInput{
		VisitID: req.Msg.GetVisitId(), AcuityRank: int(req.Msg.GetAcuityRank()),
		Reason: req.Msg.GetReason(),
	}); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&emergencyv1.OverridePriorityResponse{}), nil
}

// GetBoard returns the ED status board (SRS-ER-012).
func (h *Handler) GetBoard(
	ctx context.Context,
	req *connect.Request[emergencyv1.GetBoardRequest],
) (*connect.Response[emergencyv1.GetBoardResponse], error) {
	board, err := h.svc.Board(ctx, application.BoardInput{
		FacilityID: req.Msg.GetFacilityId(), PageSize: req.Msg.GetPageSize(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}

	out := &emergencyv1.GetBoardResponse{
		Rows:       make([]*emergencyv1.BoardRow, 0, len(board.Rows)),
		Restricted: int32(board.Restricted),
	}
	for _, row := range board.Rows {
		out.Rows = append(out.Rows, boardRowToProto(row))
	}
	return connect.NewResponse(out), nil
}

// ActivatePathway starts a time-critical pathway and calls the team
// (SRS-ER-005).
func (h *Handler) ActivatePathway(
	ctx context.Context,
	req *connect.Request[emergencyv1.ActivatePathwayRequest],
) (*connect.Response[emergencyv1.ActivatePathwayResponse], error) {
	pathway, err := h.svc.Activate(ctx, application.ActivateInput{
		VisitID: req.Msg.GetVisitId(),
		Kind:    pathwayFromProto[req.Msg.GetKind()],
		Label:   req.Msg.GetLabel(), NotifiedTeam: req.Msg.GetNotifiedTeam(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&emergencyv1.ActivatePathwayResponse{
		Pathway: pathwayToProtoMsg(pathway),
	}), nil
}

// StandDownPathway closes an activation that was not needed (SRS-ER-005).
func (h *Handler) StandDownPathway(
	ctx context.Context,
	req *connect.Request[emergencyv1.StandDownPathwayRequest],
) (*connect.Response[emergencyv1.StandDownPathwayResponse], error) {
	if err := h.svc.StandDown(ctx, application.StandDownInput{
		PathwayID: req.Msg.GetPathwayId(), Reason: req.Msg.GetReason(),
	}); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&emergencyv1.StandDownPathwayResponse{}), nil
}

// RecordEmergencyEvent appends to the resuscitation timeline (SRS-ER-008).
func (h *Handler) RecordEmergencyEvent(
	ctx context.Context,
	req *connect.Request[emergencyv1.RecordEmergencyEventRequest],
) (*connect.Response[emergencyv1.RecordEmergencyEventResponse], error) {
	msg := req.Msg

	kind, ok := eventKindFromProto[msg.GetKind()]
	if !ok {
		kind = domain.EventUnknown
	}

	event, err := h.svc.RecordEvent(ctx, application.RecordEventInput{
		VisitID: msg.GetVisitId(), Kind: kind, Detail: msg.GetDetail(),
		OccurredAt: fromTimestamp(msg.GetOccurredAt()),
		Sequence:   int(msg.GetSequence()),
		PathwayID:  msg.GetPathwayId(),
		ProtocolID: msg.GetProtocolId(), PreOrder: msg.GetPreOrder(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&emergencyv1.RecordEmergencyEventResponse{
		Event: eventToProto(event),
	}), nil
}

// GetTimeline returns a visit's events and the clocks derived from them
// (SRS-ER-006, SRS-ER-008).
func (h *Handler) GetTimeline(
	ctx context.Context,
	req *connect.Request[emergencyv1.GetTimelineRequest],
) (*connect.Response[emergencyv1.GetTimelineResponse], error) {
	timeline, intervals, err := h.svc.Timeline(ctx, req.Msg.GetVisitId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&emergencyv1.GetTimelineResponse{
		Events: eventsToProto(timeline), Intervals: intervalsToProto(intervals),
	}), nil
}

// ReconcileAdministration writes the order a protocol administration owed
// (SRS-ER-009).
func (h *Handler) ReconcileAdministration(
	ctx context.Context,
	req *connect.Request[emergencyv1.ReconcileAdministrationRequest],
) (*connect.Response[emergencyv1.ReconcileAdministrationResponse], error) {
	if err := h.svc.Reconcile(ctx, application.ReconcileInput{
		EventID: req.Msg.GetEventId(), OrderID: req.Msg.GetOrderId(),
	}); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&emergencyv1.ReconcileAdministrationResponse{}), nil
}

// ListUnreconciled is the department's reconciliation debt (SRS-ER-009).
func (h *Handler) ListUnreconciled(
	ctx context.Context,
	req *connect.Request[emergencyv1.ListUnreconciledRequest],
) (*connect.Response[emergencyv1.ListUnreconciledResponse], error) {
	events, err := h.svc.Outstanding(ctx, req.Msg.GetFacilityId(),
		req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&emergencyv1.ListUnreconciledResponse{
		Events: eventsToProto(events),
	}), nil
}

// StartObservation puts a patient in an ED observation bed (SRS-ER-014).
func (h *Handler) StartObservation(
	ctx context.Context,
	req *connect.Request[emergencyv1.StartObservationRequest],
) (*connect.Response[emergencyv1.StartObservationResponse], error) {
	visit, err := h.svc.Observe(ctx, application.ObserveInput{
		VisitID:  req.Msg.GetVisitId(),
		ReviewAt: fromTimestamp(req.Msg.GetReviewAt()),
		Location: req.Msg.GetLocation(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&emergencyv1.StartObservationResponse{
		Visit: visitToProto(visit, false),
	}), nil
}

// Dispose decides where the patient went (SRS-ER-013).
func (h *Handler) Dispose(
	ctx context.Context,
	req *connect.Request[emergencyv1.DisposeRequest],
) (*connect.Response[emergencyv1.DisposeResponse], error) {
	visit, err := h.svc.Dispose(ctx, application.DisposeInput{
		VisitID:          req.Msg.GetVisitId(),
		Disposition:      dispositionFromProto[req.Msg.GetDisposition()],
		Note:             req.Msg.GetNote(),
		ReceivingService: req.Msg.GetReceivingService(),
		SummarySigned:    req.Msg.GetSummarySigned(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&emergencyv1.DisposeResponse{
		Visit: visitToProto(visit, false),
	}), nil
}
