package transport

import (
	"context"
	"time"

	"connectrpc.com/connect"
	theatrev1 "github.com/ppusapati/health/code/gen/go/healthcare/theatre/v1"
	"github.com/ppusapati/health/code/internal/theatre/application"
	"github.com/ppusapati/health/code/internal/theatre/domain"
)

// Handler is the perioperative ConnectRPC surface.
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
// The clock is injected because several responses derive a state — an item
// used past its expiry, a room in turnover — at the moment of rendering rather
// than storing it.
func NewHandler(svc *application.Service, now func() time.Time) *Handler {
	if now == nil {
		now = time.Now
	}
	return &Handler{svc: svc, now: now}
}

func (h *Handler) SaveRoom(ctx context.Context,
	req *connect.Request[theatrev1.SaveRoomRequest]) (
	*connect.Response[theatrev1.SaveRoomResponse], error) {

	msg := req.Msg
	room, err := h.svc.SaveRoom(ctx, application.SaveRoomInput{
		RoomID: msg.GetRoomId(), FacilityID: msg.GetFacilityId(),
		Code: msg.GetCode(), Name: msg.GetName(),
		Specialties: msg.GetSpecialties(), Equipment: msg.GetEquipment(),
		Active: msg.GetActive(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.SaveRoomResponse{
		Room: roomToProto(room),
	}), nil
}

func (h *Handler) ListRooms(ctx context.Context,
	req *connect.Request[theatrev1.ListRoomsRequest]) (
	*connect.Response[theatrev1.ListRoomsResponse], error) {

	rooms, err := h.svc.Rooms(ctx, req.Msg.GetFacilityId())
	if err != nil {
		return nil, err
	}
	out := &theatrev1.ListRoomsResponse{}
	for _, room := range rooms {
		out.Rooms = append(out.Rooms, roomToProto(room))
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) SaveBlock(ctx context.Context,
	req *connect.Request[theatrev1.SaveBlockRequest]) (
	*connect.Response[theatrev1.SaveBlockResponse], error) {

	msg := req.Msg
	block, err := h.svc.SaveBlock(ctx, application.BlockInput{
		RoomID: msg.GetRoomId(), Kind: blockKind(msg.GetKind()),
		OwnerID: msg.GetOwnerId(), Specialty: msg.GetSpecialty(),
		StartsAt: timeOf(msg.GetStartsAt()), EndsAt: timeOf(msg.GetEndsAt()),
		Note: msg.GetNote(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.SaveBlockResponse{
		Block: blockToProto(block),
	}), nil
}

func (h *Handler) RequestSurgery(ctx context.Context,
	req *connect.Request[theatrev1.RequestSurgeryRequest]) (
	*connect.Response[theatrev1.RequestSurgeryResponse], error) {

	msg := req.Msg
	result, err := h.svc.Request(ctx, application.RequestInput{
		EncounterID: msg.GetEncounterId(), PatientID: msg.GetPatientId(),
		FacilityID:       msg.GetFacilityId(),
		ProcedureCode:    msg.GetProcedureCode(),
		ProcedureDisplay: msg.GetProcedureDisplay(),
		DiagnosisCode:    msg.GetDiagnosisCode(),
		DiagnosisDisplay: msg.GetDiagnosisDisplay(),
		Laterality:       laterality(msg.GetLaterality()),
		Site:             msg.GetSite(),
		Urgency:          urgency(msg.GetUrgency()),
		ExpectedDuration: time.Duration(msg.GetExpectedDurationSeconds()) * time.Second,
		SurgeonID:        msg.GetSurgeonId(),
		Team:             msg.GetTeam(),
		Requirements:     msg.GetRequirements(),
		AnaesthesiaType:  msg.GetAnaesthesiaType(),
		SpecialNotes:     msg.GetSpecialNotes(),
		SeedFromCard:     msg.GetSeedFromCard(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.RequestSurgeryResponse{
		SurgicalCase: caseToProto(result.Case), Outstanding: result.Outstanding,
	}), nil
}

func (h *Handler) CompleteRequest(ctx context.Context,
	req *connect.Request[theatrev1.CompleteRequestRequest]) (
	*connect.Response[theatrev1.CompleteRequestResponse], error) {

	msg := req.Msg
	result, err := h.svc.CompleteRequest(ctx, msg.GetCaseId(),
		application.RequestInput{
			DiagnosisCode:    msg.GetDiagnosisCode(),
			DiagnosisDisplay: msg.GetDiagnosisDisplay(),
			Laterality:       laterality(msg.GetLaterality()),
			Site:             msg.GetSite(),
			ExpectedDuration: time.Duration(msg.GetExpectedDurationSeconds()) * time.Second,
			SurgeonID:        msg.GetSurgeonId(),
			Team:             msg.GetTeam(),
			Requirements:     msg.GetRequirements(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.CompleteRequestResponse{
		SurgicalCase: caseToProto(result.Case), Outstanding: result.Outstanding,
	}), nil
}

func (h *Handler) GetSurgicalCase(ctx context.Context,
	req *connect.Request[theatrev1.GetSurgicalCaseRequest]) (
	*connect.Response[theatrev1.GetSurgicalCaseResponse], error) {

	caseID := req.Msg.GetCaseId()
	now := h.now()

	c, err := h.svc.Case(ctx, caseID)
	if err != nil {
		return nil, err
	}
	blockers, err := h.svc.Blockers(ctx, caseID)
	if err != nil {
		return nil, err
	}
	timeline, err := h.svc.Timeline(ctx, caseID)
	if err != nil {
		return nil, err
	}
	notes, err := h.svc.Notes(ctx, caseID)
	if err != nil {
		return nil, err
	}
	usage, err := h.svc.Usage(ctx, caseID)
	if err != nil {
		return nil, err
	}
	specimens, err := h.svc.Specimens(ctx, caseID)
	if err != nil {
		return nil, err
	}
	trays, err := h.svc.TrayUses(ctx, caseID)
	if err != nil {
		return nil, err
	}

	out := &theatrev1.GetSurgicalCaseResponse{
		SurgicalCase: caseToProto(c),
		Blockers:     blockersToProto(blockers),
		Intervals:    intervalsToProto(timeline.Intervals),
	}
	for _, record := range timeline.Milestones {
		out.Milestones = append(out.Milestones, milestoneToProto(record))
	}
	for _, note := range notes {
		out.Notes = append(out.Notes, noteToProto(note))
	}
	for _, item := range usage {
		out.Usage = append(out.Usage, usageToProto(item, now))
	}
	for _, specimen := range specimens {
		out.Specimens = append(out.Specimens, specimenToProto(specimen))
	}
	for _, tray := range trays {
		out.Trays = append(out.Trays, trayToProto(tray))
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) Reprioritise(ctx context.Context,
	req *connect.Request[theatrev1.ReprioritiseRequest]) (
	*connect.Response[theatrev1.ReprioritiseResponse], error) {

	c, err := h.svc.Reprioritise(ctx, req.Msg.GetCaseId(),
		urgency(req.Msg.GetUrgency()), req.Msg.GetReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.ReprioritiseResponse{
		SurgicalCase: caseToProto(c),
	}), nil
}

func (h *Handler) CheckSlot(ctx context.Context,
	req *connect.Request[theatrev1.CheckSlotRequest]) (
	*connect.Response[theatrev1.CheckSlotResponse], error) {

	conflicts, err := h.svc.CheckSlot(ctx, application.ScheduleInput{
		CaseID: req.Msg.GetCaseId(), RoomID: req.Msg.GetRoomId(),
		Start: timeOf(req.Msg.GetStart()), End: timeOf(req.Msg.GetEnd()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.CheckSlotResponse{
		Conflicts: conflictsToProto(conflicts),
	}), nil
}

func (h *Handler) ScheduleCase(ctx context.Context,
	req *connect.Request[theatrev1.ScheduleCaseRequest]) (
	*connect.Response[theatrev1.ScheduleCaseResponse], error) {

	msg := req.Msg
	result, err := h.svc.Schedule(ctx, application.ScheduleInput{
		CaseID: msg.GetCaseId(), RoomID: msg.GetRoomId(),
		Start: timeOf(msg.GetStart()), End: timeOf(msg.GetEnd()),
		Override: msg.GetOverride(), OverrideReason: msg.GetOverrideReason(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.ScheduleCaseResponse{
		SurgicalCase: caseToProto(result.Case),
		Conflicts:    conflictsToProto(result.Conflicts),
		Booked:       result.Booked,
	}), nil
}

func (h *Handler) CloseCase(ctx context.Context,
	req *connect.Request[theatrev1.CloseCaseRequest]) (
	*connect.Response[theatrev1.CloseCaseResponse], error) {

	msg := req.Msg
	c, err := h.svc.Close(ctx, application.CloseInput{
		CaseID: msg.GetCaseId(), Postpone: msg.GetPostpone(),
		Outcome: cause(msg.GetCause()), Reason: msg.GetReason(),
		Note: msg.GetNote(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.CloseCaseResponse{
		SurgicalCase: caseToProto(c),
	}), nil
}

func (h *Handler) ListWaiting(ctx context.Context,
	req *connect.Request[theatrev1.ListWaitingRequest]) (
	*connect.Response[theatrev1.ListWaitingResponse], error) {

	cases, err := h.svc.Waiting(ctx, req.Msg.GetFacilityId(), req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	out := &theatrev1.ListWaitingResponse{}
	for _, c := range cases {
		out.Cases = append(out.Cases, caseToProto(c))
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) RecordPreop(ctx context.Context,
	req *connect.Request[theatrev1.RecordPreopRequest]) (
	*connect.Response[theatrev1.RecordPreopResponse], error) {

	msg := req.Msg
	blockers, err := h.svc.RecordPreop(ctx, application.PreopInput{
		CaseID: msg.GetCaseId(), Code: msg.GetCode(),
		State: preopState(msg.GetState()), Note: msg.GetNote(),
		WaivedRole: msg.GetWaivedRole(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.RecordPreopResponse{
		Blockers: blockersToProto(blockers),
	}), nil
}

func (h *Handler) ListBlockers(ctx context.Context,
	req *connect.Request[theatrev1.ListBlockersRequest]) (
	*connect.Response[theatrev1.ListBlockersResponse], error) {

	blockers, err := h.svc.Blockers(ctx, req.Msg.GetCaseId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.ListBlockersResponse{
		Blockers: blockersToProto(blockers),
	}), nil
}

func (h *Handler) PerformSafetyCheck(ctx context.Context,
	req *connect.Request[theatrev1.PerformSafetyCheckRequest]) (
	*connect.Response[theatrev1.PerformSafetyCheckResponse], error) {

	answers := make([]domain.SafetyAnswer, 0, len(req.Msg.GetAnswers()))
	for _, answer := range req.Msg.GetAnswers() {
		answers = append(answers, domain.SafetyAnswer{
			Code: answer.GetCode(), Confirmed: answer.GetConfirmed(),
			Exception: answer.GetException(),
		})
	}

	record, err := h.svc.PerformSafety(ctx, application.SafetyInput{
		CaseID: req.Msg.GetCaseId(), Phase: phase(req.Msg.GetPhase()),
		Participants: req.Msg.GetParticipants(), Answers: answers,
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.PerformSafetyCheckResponse{
		Check: safetyToProto(record),
	}), nil
}

func (h *Handler) RecordMilestone(ctx context.Context,
	req *connect.Request[theatrev1.RecordMilestoneRequest]) (
	*connect.Response[theatrev1.RecordMilestoneResponse], error) {

	record, err := h.svc.RecordMilestone(ctx, application.MilestoneInput{
		CaseID: req.Msg.GetCaseId(), Milestone: milestone(req.Msg.GetMilestone()),
		OccurredAt: timeOf(req.Msg.GetOccurredAt()), Note: req.Msg.GetNote(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.RecordMilestoneResponse{
		Milestone: milestoneToProto(record),
	}), nil
}

func (h *Handler) GetTimeline(ctx context.Context,
	req *connect.Request[theatrev1.GetTimelineRequest]) (
	*connect.Response[theatrev1.GetTimelineResponse], error) {

	timeline, err := h.svc.Timeline(ctx, req.Msg.GetCaseId())
	if err != nil {
		return nil, err
	}
	out := &theatrev1.GetTimelineResponse{
		Intervals:     intervalsToProto(timeline.Intervals),
		OutOfSequence: timeline.OutOfSequence,
	}
	for _, record := range timeline.Milestones {
		out.Milestones = append(out.Milestones, milestoneToProto(record))
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) RecordDelay(ctx context.Context,
	req *connect.Request[theatrev1.RecordDelayRequest]) (
	*connect.Response[theatrev1.RecordDelayResponse], error) {

	msg := req.Msg
	delay, err := h.svc.RecordDelay(ctx, application.DelayInput{
		CaseID: msg.GetCaseId(), Reason: delayReason(msg.GetReason()),
		Dependency: msg.GetDependency(), Minutes: int(msg.GetMinutes()),
		Note: msg.GetNote(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.RecordDelayResponse{
		Delay: delayToProto(delay),
	}), nil
}

func (h *Handler) WriteOperativeNote(ctx context.Context,
	req *connect.Request[theatrev1.WriteOperativeNoteRequest]) (
	*connect.Response[theatrev1.WriteOperativeNoteResponse], error) {

	msg := req.Msg
	note, err := h.svc.WriteNote(ctx, application.NoteInput{
		CaseID: msg.GetCaseId(), ProcedurePerformed: msg.GetProcedurePerformed(),
		Findings: msg.GetFindings(), SpecimenIDs: msg.GetSpecimenIds(),
		ImplantIDs: msg.GetImplantIds(), Complications: msg.GetComplications(),
		EstimatedBloodLossML: int(msg.GetEstimatedBloodLossMl()),
		PostOperativeOrders:  msg.GetPostOperativeOrders(),
		Narrative:            msg.GetNarrative(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.WriteOperativeNoteResponse{
		Note: noteToProto(note),
	}), nil
}

func (h *Handler) SignOperativeNote(ctx context.Context,
	req *connect.Request[theatrev1.SignOperativeNoteRequest]) (
	*connect.Response[theatrev1.SignOperativeNoteResponse], error) {

	if err := h.svc.SignNote(ctx, req.Msg.GetCaseId(), req.Msg.GetNoteId()); err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.SignOperativeNoteResponse{}), nil
}

func (h *Handler) AmendOperativeNote(ctx context.Context,
	req *connect.Request[theatrev1.AmendOperativeNoteRequest]) (
	*connect.Response[theatrev1.AmendOperativeNoteResponse], error) {

	msg := req.Msg
	note, err := h.svc.AmendNote(ctx, msg.GetCaseId(), msg.GetNoteId(),
		msg.GetReason(), application.NoteInput{
			ProcedurePerformed:   msg.GetProcedurePerformed(),
			Findings:             msg.GetFindings(),
			SpecimenIDs:          msg.GetSpecimenIds(),
			ImplantIDs:           msg.GetImplantIds(),
			Complications:        msg.GetComplications(),
			EstimatedBloodLossML: int(msg.GetEstimatedBloodLossMl()),
			PostOperativeOrders:  msg.GetPostOperativeOrders(),
			Narrative:            msg.GetNarrative(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.AmendOperativeNoteResponse{
		Note: noteToProto(note),
	}), nil
}

func (h *Handler) RecordUsage(ctx context.Context,
	req *connect.Request[theatrev1.RecordUsageRequest]) (
	*connect.Response[theatrev1.RecordUsageResponse], error) {

	msg := req.Msg
	usage, err := h.svc.RecordUsage(ctx, application.UsageInput{
		CaseID: msg.GetCaseId(), Kind: usageKind(msg.GetKind()),
		ItemCode: msg.GetItemCode(), ItemName: msg.GetItemName(),
		LotNumber: msg.GetLotNumber(), SerialNumber: msg.GetSerialNumber(),
		Quantity: int(msg.GetQuantity()), ExpiryDate: timeOf(msg.GetExpiryDate()),
		Scanned: msg.GetScanned(), ScanData: msg.GetScanData(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.RecordUsageResponse{
		Usage: usageToProto(usage, h.now()),
	}), nil
}

func (h *Handler) RecallImplant(ctx context.Context,
	req *connect.Request[theatrev1.RecallImplantRequest]) (
	*connect.Response[theatrev1.RecallImplantResponse], error) {

	recipients, err := h.svc.Recall(ctx, req.Msg.GetItemCode(),
		req.Msg.GetLotNumber())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.RecallImplantResponse{
		Recipients: recipientsToProto(recipients),
	}), nil
}

func (h *Handler) TakeSpecimen(ctx context.Context,
	req *connect.Request[theatrev1.TakeSpecimenRequest]) (
	*connect.Response[theatrev1.TakeSpecimenResponse], error) {

	msg := req.Msg
	specimen, err := h.svc.TakeSpecimen(ctx, application.SpecimenInput{
		CaseID: msg.GetCaseId(), Label: msg.GetLabel(), Site: msg.GetSite(),
		Container: msg.GetContainer(), Fixative: msg.GetFixative(),
		TakenAt: timeOf(msg.GetTakenAt()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.TakeSpecimenResponse{
		Specimen: specimenToProto(specimen),
	}), nil
}

func (h *Handler) AccessionSpecimen(ctx context.Context,
	req *connect.Request[theatrev1.AccessionSpecimenRequest]) (
	*connect.Response[theatrev1.AccessionSpecimenResponse], error) {

	if err := h.svc.Accession(ctx, req.Msg.GetSpecimenId(),
		req.Msg.GetOrderId()); err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.AccessionSpecimenResponse{}), nil
}

func (h *Handler) ListOutstandingSpecimens(ctx context.Context,
	req *connect.Request[theatrev1.ListOutstandingSpecimensRequest]) (
	*connect.Response[theatrev1.ListOutstandingSpecimensResponse], error) {

	specimens, err := h.svc.OutstandingSpecimens(ctx, req.Msg.GetFacilityId(),
		req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	out := &theatrev1.ListOutstandingSpecimensResponse{}
	for _, specimen := range specimens {
		out.Specimens = append(out.Specimens, specimenToProto(specimen))
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) OpenTray(ctx context.Context,
	req *connect.Request[theatrev1.OpenTrayRequest]) (
	*connect.Response[theatrev1.OpenTrayResponse], error) {

	msg := req.Msg
	use, err := h.svc.OpenTray(ctx, application.TrayInput{
		CaseID: msg.GetCaseId(), TrayID: msg.GetTrayId(),
		TrayName: msg.GetTrayName(), CycleID: msg.GetCycleId(),
		IndicatorPassed: msg.GetIndicatorPassed(),
		IndicatorNote:   msg.GetIndicatorNote(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.OpenTrayResponse{
		TrayUse: trayToProto(use),
	}), nil
}

func (h *Handler) TraceCycle(ctx context.Context,
	req *connect.Request[theatrev1.TraceCycleRequest]) (
	*connect.Response[theatrev1.TraceCycleResponse], error) {

	recipients, err := h.svc.TraceCycle(ctx, req.Msg.GetCycleId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.TraceCycleResponse{
		Recipients: recipientsToProto(recipients),
	}), nil
}

func (h *Handler) SavePreferenceCard(ctx context.Context,
	req *connect.Request[theatrev1.SavePreferenceCardRequest]) (
	*connect.Response[theatrev1.SavePreferenceCardResponse], error) {

	consumables := make([]domain.CardItem, 0, len(req.Msg.GetConsumables()))
	for _, item := range req.Msg.GetConsumables() {
		consumables = append(consumables, domain.CardItem{
			ItemCode: item.GetItemCode(), ItemName: item.GetItemName(),
			Quantity: int(item.GetQuantity()),
		})
	}

	card, err := h.svc.SaveCard(ctx, application.CardInput{
		SurgeonID:     req.Msg.GetSurgeonId(),
		ProcedureCode: req.Msg.GetProcedureCode(), Name: req.Msg.GetName(),
		Equipment: req.Msg.GetEquipment(), Consumables: consumables,
		Trays: req.Msg.GetTrays(), Notes: req.Msg.GetNotes(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.SavePreferenceCardResponse{
		Card: cardToProto(card),
	}), nil
}

func (h *Handler) GetPreferenceCard(ctx context.Context,
	req *connect.Request[theatrev1.GetPreferenceCardRequest]) (
	*connect.Response[theatrev1.GetPreferenceCardResponse], error) {

	card, found, err := h.svc.Card(ctx, req.Msg.GetSurgeonId(),
		req.Msg.GetProcedureCode())
	if err != nil {
		return nil, err
	}
	out := &theatrev1.GetPreferenceCardResponse{Found: found}
	if found {
		out.Card = cardToProto(card)
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) GetBoard(ctx context.Context,
	req *connect.Request[theatrev1.GetBoardRequest]) (
	*connect.Response[theatrev1.GetBoardResponse], error) {

	rows, err := h.svc.Board(ctx, req.Msg.GetFacilityId(), h.now())
	if err != nil {
		return nil, err
	}
	out := &theatrev1.GetBoardResponse{}
	for _, row := range rows {
		out.Rows = append(out.Rows, boardRowToProto(row))
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) GetUtilisation(ctx context.Context,
	req *connect.Request[theatrev1.GetUtilisationRequest]) (
	*connect.Response[theatrev1.GetUtilisationResponse], error) {

	utilisation, err := h.svc.Utilisation(ctx, req.Msg.GetRoomId(),
		timeOf(req.Msg.GetFrom()), timeOf(req.Msg.GetTo()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&theatrev1.GetUtilisationResponse{
		Utilisation: utilisationToProto(utilisation),
	}), nil
}
