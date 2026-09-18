package transport

import (
	"context"
	"time"

	"connectrpc.com/connect"

	sterilev1 "github.com/ppusapati/health/code/gen/go/healthcare/sterile/v1"
	"github.com/ppusapati/health/code/internal/sterile/application"
	"github.com/ppusapati/health/code/internal/sterile/domain"
)

// Handler is the sterile services ConnectRPC surface.
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
// The clock is injected because a pack's issuability is derived at the moment
// of rendering rather than stored: a pack that expired an hour ago is expired
// whether or not a job has run.
func NewHandler(svc *application.Service, now func() time.Time) *Handler {
	if now == nil {
		now = time.Now
	}
	return &Handler{svc: svc, now: now}
}

func (h *Handler) RegisterInstrument(ctx context.Context,
	req *connect.Request[sterilev1.RegisterInstrumentRequest]) (
	*connect.Response[sterilev1.RegisterInstrumentResponse], error) {

	msg := req.Msg
	instrument, err := h.svc.RegisterInstrument(ctx, domain.NewInstrumentInput{
		Code: msg.GetCode(), Display: msg.GetDisplay(),
		SerialNumber: msg.GetSerialNumber(), Location: msg.GetLocation(),
		AcquiredOn: timeOf(msg.GetAcquiredOn()), Notes: msg.GetNotes(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.RegisterInstrumentResponse{
		Instrument: instrumentToProto(instrument),
	}), nil
}

func (h *Handler) MoveInstrument(ctx context.Context,
	req *connect.Request[sterilev1.MoveInstrumentRequest]) (
	*connect.Response[sterilev1.MoveInstrumentResponse], error) {

	msg := req.Msg
	instrument, err := h.svc.MoveInstrument(ctx, msg.GetInstrumentId(),
		instrumentStatusFromWire[msg.GetStatus()], msg.GetNote())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.MoveInstrumentResponse{
		Instrument: instrumentToProto(instrument),
	}), nil
}

func (h *Handler) ListInstruments(ctx context.Context,
	req *connect.Request[sterilev1.ListInstrumentsRequest]) (
	*connect.Response[sterilev1.ListInstrumentsResponse], error) {

	msg := req.Msg
	var (
		instruments []domain.Instrument
		err         error
	)
	if msg.GetOutOfServiceOnly() {
		instruments, err = h.svc.InstrumentsOutOfService(ctx, msg.GetPageSize())
	} else {
		instruments, err = h.svc.Instruments(ctx, msg.GetCode(), msg.GetPageSize())
	}
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.ListInstrumentsResponse{
		Instruments: instrumentsToProto(instruments),
	}), nil
}

func (h *Handler) GetInstrumentHistory(ctx context.Context,
	req *connect.Request[sterilev1.GetInstrumentHistoryRequest]) (
	*connect.Response[sterilev1.GetInstrumentHistoryResponse], error) {

	msg := req.Msg
	events, err := h.svc.InstrumentHistory(ctx, msg.GetInstrumentId(),
		msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.GetInstrumentHistoryResponse{
		Events: instrumentEventsToProto(events),
	}), nil
}

func (h *Handler) ListInstrumentMoves(ctx context.Context,
	req *connect.Request[sterilev1.ListInstrumentMovesRequest]) (
	*connect.Response[sterilev1.ListInstrumentMovesResponse], error) {

	msg := req.Msg
	events, err := h.svc.MovesByStatus(ctx,
		instrumentStatusFromWire[msg.GetStatus()],
		timeOf(msg.GetPeriodStart()), timeOf(msg.GetPeriodEnd()),
		msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.ListInstrumentMovesResponse{
		Events: instrumentEventsToProto(events),
	}), nil
}

func (h *Handler) DefineSet(ctx context.Context,
	req *connect.Request[sterilev1.DefineSetRequest]) (
	*connect.Response[sterilev1.DefineSetResponse], error) {

	msg := req.Msg
	set, err := h.svc.DefineSet(ctx, domain.NewTraySetInput{
		Code: msg.GetCode(), Display: msg.GetDisplay(), Kind: msg.GetKind(),
		Items:     packingItemsFromProto(msg.GetItems()),
		ShelfLife: time.Duration(msg.GetShelfLifeSeconds()) * time.Second,
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.DefineSetResponse{
		Set: setToProto(set),
	}), nil
}

// GetSet resolves either a version by id or the version in force by code.
func (h *Handler) GetSet(ctx context.Context,
	req *connect.Request[sterilev1.GetSetRequest]) (
	*connect.Response[sterilev1.GetSetResponse], error) {

	msg := req.Msg
	var (
		set domain.TraySet
		err error
	)
	if id := msg.GetSetId(); id != "" {
		set, err = h.svc.Set(ctx, id)
	} else {
		set, err = h.svc.CurrentSet(ctx, msg.GetCode())
	}
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.GetSetResponse{
		Set: setToProto(set),
	}), nil
}

func (h *Handler) ListSetVersions(ctx context.Context,
	req *connect.Request[sterilev1.ListSetVersionsRequest]) (
	*connect.Response[sterilev1.ListSetVersionsResponse], error) {

	versions, err := h.svc.SetVersions(ctx, req.Msg.GetCode())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.ListSetVersionsResponse{
		Versions: setsToProto(versions),
	}), nil
}

func (h *Handler) ListSets(ctx context.Context,
	req *connect.Request[sterilev1.ListSetsRequest]) (
	*connect.Response[sterilev1.ListSetsResponse], error) {

	sets, err := h.svc.Sets(ctx, req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.ListSetsResponse{
		Sets: setsToProto(sets),
	}), nil
}

func (h *Handler) Receive(ctx context.Context,
	req *connect.Request[sterilev1.ReceiveRequest]) (
	*connect.Response[sterilev1.ReceiveResponse], error) {

	msg := req.Msg
	receipt, err := h.svc.Receive(ctx, application.ReceiveInput{
		SetCode: msg.GetSetCode(), SourceUnit: msg.GetSourceUnit(),
		SourceCaseID: msg.GetSourceCaseId(),
		Counted:      countsFromProto(msg.GetCounted()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.ReceiveResponse{
		Run: runToProto(receipt.Run, h.now()), Short: receipt.Short,
	}), nil
}

// Advance records one stage.
//
// The request carries no authoriser for a skip: the application takes the
// caller, so a technician cannot record a manager's approval without the
// manager being at the keyboard.
func (h *Handler) Advance(ctx context.Context,
	req *connect.Request[sterilev1.AdvanceRequest]) (
	*connect.Response[sterilev1.AdvanceResponse], error) {

	msg := req.Msg
	record, err := h.svc.Advance(ctx, application.AdvanceInput{
		RunID: msg.GetRunId(), Stage: stageFromWire[msg.GetStage()],
		Equipment: msg.GetEquipment(), Notes: msg.GetNotes(),
		Skipped: msg.GetSkipped(), SkipReason: msg.GetSkipReason(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.AdvanceResponse{
		Record: stageRecordToProto(record),
	}), nil
}

func (h *Handler) Assemble(ctx context.Context,
	req *connect.Request[sterilev1.AssembleRequest]) (
	*connect.Response[sterilev1.AssembleResponse], error) {

	msg := req.Msg
	assembly, err := h.svc.Assemble(ctx, application.AssembleInput{
		RunID: msg.GetRunId(), Packed: countsFromProto(msg.GetPacked()),
		Replaced: msg.GetReplaced(), Notes: msg.GetNotes(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.AssembleResponse{
		Record: stageRecordToProto(assembly.Record), Missing: assembly.Missing,
	}), nil
}

func (h *Handler) Package(ctx context.Context,
	req *connect.Request[sterilev1.PackageRequest]) (
	*connect.Response[sterilev1.PackageResponse], error) {

	msg := req.Msg
	record, err := h.svc.Package(ctx, application.PackageInput{
		RunID: msg.GetRunId(), Method: msg.GetMethod(),
		IndicatorType: msg.GetIndicatorType(), Notes: msg.GetNotes(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.PackageResponse{
		Record: stageRecordToProto(record),
	}), nil
}

func (h *Handler) StartCycle(ctx context.Context,
	req *connect.Request[sterilev1.StartCycleRequest]) (
	*connect.Response[sterilev1.StartCycleResponse], error) {

	msg := req.Msg
	cycle, err := h.svc.StartCycle(ctx, domain.NewCycleInput{
		Machine: msg.GetMachine(), LoadNumber: msg.GetLoadNumber(),
		Program:    msg.GetProgram(),
		Parameters: parametersFromProto(msg.GetParameters()),
		Source:     cycleSourceFromWire[msg.GetSource()],
		StartedAt:  timeOf(msg.GetStartedAt()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.StartCycleResponse{
		Cycle: cycleToProto(cycle),
	}), nil
}

func (h *Handler) LoadCycle(ctx context.Context,
	req *connect.Request[sterilev1.LoadCycleRequest]) (
	*connect.Response[sterilev1.LoadCycleResponse], error) {

	msg := req.Msg
	runs, err := h.svc.Load(ctx, application.LoadInput{
		CycleID: msg.GetCycleId(), RunIDs: msg.GetRunIds(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.LoadCycleResponse{
		Runs: runsToProto(runs, h.now()),
	}), nil
}

func (h *Handler) FinishCycle(ctx context.Context,
	req *connect.Request[sterilev1.FinishCycleRequest]) (
	*connect.Response[sterilev1.FinishCycleResponse], error) {

	msg := req.Msg
	cycle, err := h.svc.FinishCycle(ctx, msg.GetCycleId(),
		cycleResultFromWire[msg.GetResult()],
		parametersFromProto(msg.GetParameters()), timeOf(msg.GetEndedAt()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.FinishCycleResponse{
		Cycle: cycleToProto(cycle),
	}), nil
}

func (h *Handler) RecordIndicator(ctx context.Context,
	req *connect.Request[sterilev1.RecordIndicatorRequest]) (
	*connect.Response[sterilev1.RecordIndicatorResponse], error) {

	msg := req.Msg
	result, err := h.svc.RecordIndicator(ctx, msg.GetCycleId(),
		indicatorFromWire[msg.GetKind()], msg.GetLot(), msg.GetPassed(),
		msg.GetNotes())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.RecordIndicatorResponse{
		Result: indicatorToProto(result),
	}), nil
}

func (h *Handler) GetReleaseDecision(ctx context.Context,
	req *connect.Request[sterilev1.GetReleaseDecisionRequest]) (
	*connect.Response[sterilev1.GetReleaseDecisionResponse], error) {

	decision, err := h.svc.ReleaseDecision(ctx, req.Msg.GetCycleId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.GetReleaseDecisionResponse{
		Decision: decisionToProto(decision),
	}), nil
}

func (h *Handler) ReleaseLoad(ctx context.Context,
	req *connect.Request[sterilev1.ReleaseLoadRequest]) (
	*connect.Response[sterilev1.ReleaseLoadResponse], error) {

	msg := req.Msg
	cycle, runs, err := h.svc.ReleaseLoad(ctx, msg.GetCycleId(), msg.GetNote())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.ReleaseLoadResponse{
		Cycle: cycleToProto(cycle), Runs: runsToProto(runs, h.now()),
	}), nil
}

// GetCycle resolves either the id or the number on the printout.
func (h *Handler) GetCycle(ctx context.Context,
	req *connect.Request[sterilev1.GetCycleRequest]) (
	*connect.Response[sterilev1.GetCycleResponse], error) {

	msg := req.Msg
	var (
		cycle domain.Cycle
		err   error
	)
	if id := msg.GetCycleId(); id != "" {
		cycle, err = h.svc.Cycle(ctx, id)
	} else {
		cycle, err = h.svc.CycleByLoad(ctx, msg.GetMachine(), msg.GetLoadNumber())
	}
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.GetCycleResponse{
		Cycle: cycleToProto(cycle),
	}), nil
}

func (h *Handler) ListCyclesAwaitingRelease(ctx context.Context,
	req *connect.Request[sterilev1.ListCyclesAwaitingReleaseRequest]) (
	*connect.Response[sterilev1.ListCyclesAwaitingReleaseResponse], error) {

	cycles, err := h.svc.AwaitingRelease(ctx, req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.ListCyclesAwaitingReleaseResponse{
		Cycles: cyclesToProto(cycles),
	}), nil
}

func (h *Handler) ListLoadsClearedByLot(ctx context.Context,
	req *connect.Request[sterilev1.ListLoadsClearedByLotRequest]) (
	*connect.Response[sterilev1.ListLoadsClearedByLotResponse], error) {

	msg := req.Msg
	cycles, err := h.svc.LoadsClearedByLot(ctx, msg.GetLot(), msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.ListLoadsClearedByLotResponse{
		Cycles: cyclesToProto(cycles),
	}), nil
}

func (h *Handler) GetRun(ctx context.Context,
	req *connect.Request[sterilev1.GetRunRequest]) (
	*connect.Response[sterilev1.GetRunResponse], error) {

	run, err := h.svc.Run(ctx, req.Msg.GetRunId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.GetRunResponse{
		Run: runToProto(run, h.now()),
	}), nil
}

func (h *Handler) GetBoard(ctx context.Context,
	req *connect.Request[sterilev1.GetBoardRequest]) (
	*connect.Response[sterilev1.GetBoardResponse], error) {

	runs, err := h.svc.Board(ctx, req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.GetBoardResponse{
		Runs: runsToProto(runs, h.now()),
	}), nil
}

func (h *Handler) GetShelf(ctx context.Context,
	req *connect.Request[sterilev1.GetShelfRequest]) (
	*connect.Response[sterilev1.GetShelfResponse], error) {

	msg := req.Msg
	runs, err := h.svc.Shelf(ctx, msg.GetSetCode(), msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.GetShelfResponse{
		Runs: runsToProto(runs, h.now()),
	}), nil
}

func (h *Handler) ListExpiredPacks(ctx context.Context,
	req *connect.Request[sterilev1.ListExpiredPacksRequest]) (
	*connect.Response[sterilev1.ListExpiredPacksResponse], error) {

	runs, err := h.svc.ExpiredPacks(ctx, req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.ListExpiredPacksResponse{
		Runs: runsToProto(runs, h.now()),
	}), nil
}

func (h *Handler) ListExceptions(ctx context.Context,
	req *connect.Request[sterilev1.ListExceptionsRequest]) (
	*connect.Response[sterilev1.ListExceptionsResponse], error) {

	msg := req.Msg
	records, err := h.svc.Exceptions(ctx, timeOf(msg.GetPeriodStart()),
		timeOf(msg.GetPeriodEnd()), msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.ListExceptionsResponse{
		Records: stageRecordsToProto(records),
	}), nil
}

func (h *Handler) GetLabel(ctx context.Context,
	req *connect.Request[sterilev1.GetLabelRequest]) (
	*connect.Response[sterilev1.GetLabelResponse], error) {

	label, err := h.svc.Label(ctx, req.Msg.GetRunId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.GetLabelResponse{
		Label: labelToProto(label),
	}), nil
}

func (h *Handler) IssuePack(ctx context.Context,
	req *connect.Request[sterilev1.IssuePackRequest]) (
	*connect.Response[sterilev1.IssuePackResponse], error) {

	msg := req.Msg
	issue, err := h.svc.IssuePack(ctx, domain.NewIssueInput{
		RunID: msg.GetRunId(), Destination: msg.GetDestination(),
		IssuedTo: msg.GetIssuedTo(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.IssuePackResponse{
		Issue: issueToProto(issue),
	}), nil
}

func (h *Handler) MarkUsed(ctx context.Context,
	req *connect.Request[sterilev1.MarkUsedRequest]) (
	*connect.Response[sterilev1.MarkUsedResponse], error) {

	msg := req.Msg
	issue, err := h.svc.MarkUsed(ctx, msg.GetIssueId(), msg.GetCaseId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.MarkUsedResponse{
		Issue: issueToProto(issue),
	}), nil
}

func (h *Handler) ReturnPack(ctx context.Context,
	req *connect.Request[sterilev1.ReturnPackRequest]) (
	*connect.Response[sterilev1.ReturnPackResponse], error) {

	msg := req.Msg
	result, err := h.svc.ReturnPack(ctx, msg.GetIssueId(),
		countsFromProto(msg.GetCounted()), msg.GetNote())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.ReturnPackResponse{
		Issue: issueToProto(result.Issue), Short: result.Short,
	}), nil
}

func (h *Handler) ListOutstanding(ctx context.Context,
	req *connect.Request[sterilev1.ListOutstandingRequest]) (
	*connect.Response[sterilev1.ListOutstandingResponse], error) {

	msg := req.Msg
	issues, err := h.svc.Outstanding(ctx, msg.GetDestination(), msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.ListOutstandingResponse{
		Issues: issuesToProto(issues),
	}), nil
}

func (h *Handler) TraceCase(ctx context.Context,
	req *connect.Request[sterilev1.TraceCaseRequest]) (
	*connect.Response[sterilev1.TraceCaseResponse], error) {

	trace, err := h.svc.TraceCase(ctx, req.Msg.GetCaseId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.TraceCaseResponse{
		Trace: traceToProto(trace),
	}), nil
}

func (h *Handler) GetRecallScope(ctx context.Context,
	req *connect.Request[sterilev1.GetRecallScopeRequest]) (
	*connect.Response[sterilev1.GetRecallScopeResponse], error) {

	scope, err := h.svc.RecallScope(ctx, req.Msg.GetCycleId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.GetRecallScopeResponse{
		Scope: scopeToProto(scope),
	}), nil
}

func (h *Handler) RaiseRecall(ctx context.Context,
	req *connect.Request[sterilev1.RaiseRecallRequest]) (
	*connect.Response[sterilev1.RaiseRecallResponse], error) {

	msg := req.Msg
	recall, scope, err := h.svc.RaiseRecall(ctx, msg.GetCycleId(), msg.GetReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.RaiseRecallResponse{
		Recall: recallToProto(recall), Scope: scopeToProto(scope),
	}), nil
}

func (h *Handler) CloseRecall(ctx context.Context,
	req *connect.Request[sterilev1.CloseRecallRequest]) (
	*connect.Response[sterilev1.CloseRecallResponse], error) {

	msg := req.Msg
	if err := h.svc.CloseRecall(ctx, msg.GetRecallId(), msg.GetNote()); err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.CloseRecallResponse{}), nil
}

func (h *Handler) ListOpenRecalls(ctx context.Context,
	req *connect.Request[sterilev1.ListOpenRecallsRequest]) (
	*connect.Response[sterilev1.ListOpenRecallsResponse], error) {

	recalls, err := h.svc.OpenRecalls(ctx, req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&sterilev1.ListOpenRecallsResponse{
		Recalls: recallsToProto(recalls),
	}), nil
}
