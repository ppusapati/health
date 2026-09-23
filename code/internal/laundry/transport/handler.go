package transport

import (
	"context"
	"time"

	"connectrpc.com/connect"

	laundryv1 "github.com/ppusapati/health/code/gen/go/healthcare/laundry/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/laundry/v1/laundryv1connect"
	"github.com/ppusapati/health/code/internal/laundry/application"
	"github.com/ppusapati/health/code/internal/laundry/domain"
)

// Handler is the laundry ConnectRPC surface.
//
// Thin on purpose: it translates, calls one use case and translates back.
// Every refusal comes from the application or the domain, so the same rule
// holds whichever client asks — a second client cannot be written that
// forgets to check the wash passed.
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

var _ laundryv1connect.LaundryServiceHandler = (*Handler)(nil)

// Linen item master and unit par levels (SRS-LND-001).

func (h *Handler) ConfigureLinenItem(ctx context.Context,
	req *connect.Request[laundryv1.ConfigureLinenItemRequest]) (
	*connect.Response[laundryv1.ConfigureLinenItemResponse], error) {

	msg := req.Msg
	item, err := h.svc.ConfigureItem(ctx, domain.NewItemInput{
		Code: msg.GetCode(), Name: msg.GetName(),
		Category:             categoryFromWire[msg.GetCategory()],
		UnitWeightG:          int(msg.GetUnitWeightG()),
		ReplacementCostMinor: int(msg.GetReplacementCostMinor()),
		Tracked:              msg.GetTracked(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.ConfigureLinenItemResponse{
		Item: itemToWire(item),
	}), nil
}

func (h *Handler) RetireLinenItem(ctx context.Context,
	req *connect.Request[laundryv1.RetireLinenItemRequest]) (
	*connect.Response[laundryv1.RetireLinenItemResponse], error) {

	item, err := h.svc.RetireItem(ctx, req.Msg.GetItemId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.RetireLinenItemResponse{
		Item: itemToWire(item),
	}), nil
}

func (h *Handler) ListLinenItems(ctx context.Context,
	req *connect.Request[laundryv1.ListLinenItemsRequest]) (
	*connect.Response[laundryv1.ListLinenItemsResponse], error) {

	msg := req.Msg
	items, err := h.svc.ListItems(ctx, application.ListItemsInput{
		Category:    string(categoryFromWire[msg.GetCategory()]),
		TrackedOnly: msg.GetTrackedOnly(), ActiveOnly: msg.GetActiveOnly(),
		PageSize: msg.GetPageSize(), Offset: msg.GetOffset(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.ListLinenItemsResponse{
		Items: itemsToWire(items),
	}), nil
}

func (h *Handler) SetParLevel(ctx context.Context,
	req *connect.Request[laundryv1.SetParLevelRequest]) (
	*connect.Response[laundryv1.SetParLevelResponse], error) {

	msg := req.Msg
	par, err := h.svc.SetPar(ctx, application.SetParInput{
		UnitID: msg.GetUnitId(), UnitName: msg.GetUnitName(),
		FacilityID: msg.GetFacilityId(),
		Lines:      parLinesFromWire(msg.GetLines()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.SetParLevelResponse{
		Par: parToWire(par),
	}), nil
}

func (h *Handler) ApproveParLevel(ctx context.Context,
	req *connect.Request[laundryv1.ApproveParLevelRequest]) (
	*connect.Response[laundryv1.ApproveParLevelResponse], error) {

	par, err := h.svc.ApprovePar(ctx, req.Msg.GetParId(),
		timeOf(req.Msg.GetEffectiveFrom()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.ApproveParLevelResponse{
		Par: parToWire(par),
	}), nil
}

func (h *Handler) GetParInForce(ctx context.Context,
	req *connect.Request[laundryv1.GetParInForceRequest]) (
	*connect.Response[laundryv1.GetParInForceResponse], error) {

	par, err := h.svc.ParInForce(ctx, req.Msg.GetUnitId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.GetParInForceResponse{
		Par: parToWire(par),
	}), nil
}

func (h *Handler) ListParLevels(ctx context.Context,
	req *connect.Request[laundryv1.ListParLevelsRequest]) (
	*connect.Response[laundryv1.ListParLevelsResponse], error) {

	msg := req.Msg
	pars, err := h.svc.ListPars(ctx, application.ListParsInput{
		FacilityID: msg.GetFacilityId(), UnitID: msg.GetUnitId(),
		LiveOnly: msg.GetLiveOnly(),
		PageSize: msg.GetPageSize(), Offset: msg.GetOffset(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.ListParLevelsResponse{
		Pars: parsToWire(pars),
	}), nil
}

// Soiled collection (SRS-LND-002, SRS-LND-005).

func (h *Handler) RecordCollection(ctx context.Context,
	req *connect.Request[laundryv1.RecordCollectionRequest]) (
	*connect.Response[laundryv1.RecordCollectionResponse], error) {

	msg := req.Msg
	collection, err := h.svc.RecordCollection(ctx,
		application.RecordCollectionInput{
			NewCollectionInput: domain.NewCollectionInput{
				UnitID: msg.GetUnitId(), UnitName: msg.GetUnitName(),
				FacilityID: msg.GetFacilityId(),
				SoilClass:  soilClassFromWire[msg.GetSoilClass()],
				BagCount:   int(msg.GetBagCount()),
				WeightG:    int(msg.GetWeightG()),
				Lines:      collectionLinesFromWire(msg.GetLines()),
			},
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.RecordCollectionResponse{
		Collection: collectionToWire(collection),
	}), nil
}

func (h *Handler) RecountCollection(ctx context.Context,
	req *connect.Request[laundryv1.RecountCollectionRequest]) (
	*connect.Response[laundryv1.RecountCollectionResponse], error) {

	collection, err := h.svc.RecountCollection(ctx,
		req.Msg.GetCollectionId(),
		collectionLinesFromWire(req.Msg.GetLines()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.RecountCollectionResponse{
		Collection: collectionToWire(collection),
	}), nil
}

func (h *Handler) CancelCollection(ctx context.Context,
	req *connect.Request[laundryv1.CancelCollectionRequest]) (
	*connect.Response[laundryv1.CancelCollectionResponse], error) {

	collection, err := h.svc.CancelCollection(ctx,
		req.Msg.GetCollectionId(), req.Msg.GetReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.CancelCollectionResponse{
		Collection: collectionToWire(collection),
	}), nil
}

func (h *Handler) ListCollections(ctx context.Context,
	req *connect.Request[laundryv1.ListCollectionsRequest]) (
	*connect.Response[laundryv1.ListCollectionsResponse], error) {

	msg := req.Msg
	collections, err := h.svc.ListCollections(ctx,
		application.ListCollectionsInput{
			FacilityID: msg.GetFacilityId(), UnitID: msg.GetUnitId(),
			SoilClass: string(soilClassFromWire[msg.GetSoilClass()]),
			States:    collectionStatesFromWire(msg.GetStates()),
			BatchID:   msg.GetBatchId(), PendingOnly: msg.GetPendingOnly(),
			From: timeOf(msg.GetFrom()), To: timeOf(msg.GetTo()),
			PageSize: msg.GetPageSize(), Offset: msg.GetOffset(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.ListCollectionsResponse{
		Collections: collectionsToWire(collections),
	}), nil
}

func (h *Handler) CheckCollectionWeight(ctx context.Context,
	req *connect.Request[laundryv1.CheckCollectionWeightRequest]) (
	*connect.Response[laundryv1.CheckCollectionWeightResponse], error) {

	check, err := h.svc.CheckCollectionWeight(ctx,
		req.Msg.GetCollectionId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.CheckCollectionWeightResponse{
		DeclaredPieces: int32(check.DeclaredPieces),
		ExpectedG:      int32(check.ExpectedG),
		ActualG:        int32(check.ActualG),
		VarianceG:      int32(check.VarianceG),
		Unanswerable:   check.Unanswerable,
	}), nil
}

// Wash batches (SRS-LND-003, SRS-LND-005).

func (h *Handler) OpenWashBatch(ctx context.Context,
	req *connect.Request[laundryv1.OpenWashBatchRequest]) (
	*connect.Response[laundryv1.OpenWashBatchResponse], error) {

	msg := req.Msg
	batch, err := h.svc.OpenBatch(ctx, domain.NewBatchInput{
		Reference: msg.GetReference(), FacilityID: msg.GetFacilityId(),
		MachineID:       msg.GetMachineId(),
		Cycle:           cycleFromWire[msg.GetCycle()],
		RewashOfBatchID: msg.GetRewashOfBatchId(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.OpenWashBatchResponse{
		Batch: batchToWire(batch),
	}), nil
}

func (h *Handler) LoadWashBatch(ctx context.Context,
	req *connect.Request[laundryv1.LoadWashBatchRequest]) (
	*connect.Response[laundryv1.LoadWashBatchResponse], error) {

	batch, err := h.svc.LoadBatch(ctx, req.Msg.GetBatchId(),
		req.Msg.GetCollectionId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.LoadWashBatchResponse{
		Batch: batchToWire(batch),
	}), nil
}

func (h *Handler) StartWashBatch(ctx context.Context,
	req *connect.Request[laundryv1.StartWashBatchRequest]) (
	*connect.Response[laundryv1.StartWashBatchResponse], error) {

	batch, err := h.svc.StartBatch(ctx, req.Msg.GetBatchId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.StartWashBatchResponse{
		Batch: batchToWire(batch),
	}), nil
}

func (h *Handler) CompleteWashBatch(ctx context.Context,
	req *connect.Request[laundryv1.CompleteWashBatchRequest]) (
	*connect.Response[laundryv1.CompleteWashBatchResponse], error) {

	msg := req.Msg
	batch, err := h.svc.CompleteBatch(ctx, msg.GetBatchId(),
		domain.CompleteInput{
			Passed: msg.GetPassed(), Outcome: msg.GetOutcome(),
			PeakTemperatureC: int(msg.GetPeakTemperatureC()),
			HoldMinutes:      int(msg.GetHoldMinutes()),
			Exceptions:       exceptionsFromWire(msg.GetExceptions()),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.CompleteWashBatchResponse{
		Batch: batchToWire(batch),
	}), nil
}

func (h *Handler) RewashBatch(ctx context.Context,
	req *connect.Request[laundryv1.RewashBatchRequest]) (
	*connect.Response[laundryv1.RewashBatchResponse], error) {

	batch, err := h.svc.RewashBatch(ctx, req.Msg.GetFailedBatchId(),
		req.Msg.GetIntoBatchId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.RewashBatchResponse{
		Batch: batchToWire(batch),
	}), nil
}

func (h *Handler) GetWashBatch(ctx context.Context,
	req *connect.Request[laundryv1.GetWashBatchRequest]) (
	*connect.Response[laundryv1.GetWashBatchResponse], error) {

	batch, err := h.svc.GetBatch(ctx, req.Msg.GetBatchId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.GetWashBatchResponse{
		Batch: batchToWire(batch),
	}), nil
}

func (h *Handler) ListWashBatches(ctx context.Context,
	req *connect.Request[laundryv1.ListWashBatchesRequest]) (
	*connect.Response[laundryv1.ListWashBatchesResponse], error) {

	msg := req.Msg
	batches, err := h.svc.ListBatches(ctx, application.ListBatchesInput{
		FacilityID: msg.GetFacilityId(), MachineID: msg.GetMachineId(),
		Cycle:  string(cycleFromWire[msg.GetCycle()]),
		States: batchStatesFromWire(msg.GetStates()),
		From:   timeOf(msg.GetFrom()), To: timeOf(msg.GetTo()),
		PageSize: msg.GetPageSize(), Offset: msg.GetOffset(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.ListWashBatchesResponse{
		Batches: batchesToWire(batches),
	}), nil
}

func (h *Handler) ListAffectedUnits(ctx context.Context,
	req *connect.Request[laundryv1.ListAffectedUnitsRequest]) (
	*connect.Response[laundryv1.ListAffectedUnitsResponse], error) {

	units, err := h.svc.AffectedUnits(ctx, req.Msg.GetBatchId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.ListAffectedUnitsResponse{
		UnitIds: units,
	}), nil
}

// Clean linen issue and unit stock (SRS-LND-004).

func (h *Handler) IssueLinen(ctx context.Context,
	req *connect.Request[laundryv1.IssueLinenRequest]) (
	*connect.Response[laundryv1.IssueLinenResponse], error) {

	msg := req.Msg
	issue, err := h.svc.IssueLinen(ctx, application.IssueLinenInput{
		BatchID: msg.GetBatchId(), UnitID: msg.GetUnitId(),
		UnitName: msg.GetUnitName(), FacilityID: msg.GetFacilityId(),
		Lines: issueLinesFromWire(msg.GetLines()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.IssueLinenResponse{
		Issue: issueToWire(issue),
	}), nil
}

func (h *Handler) ReceiveLinen(ctx context.Context,
	req *connect.Request[laundryv1.ReceiveLinenRequest]) (
	*connect.Response[laundryv1.ReceiveLinenResponse], error) {

	issue, err := h.svc.ReceiveIssue(ctx, req.Msg.GetIssueId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.ReceiveLinenResponse{
		Issue: issueToWire(issue),
	}), nil
}

func (h *Handler) ListLinenIssues(ctx context.Context,
	req *connect.Request[laundryv1.ListLinenIssuesRequest]) (
	*connect.Response[laundryv1.ListLinenIssuesResponse], error) {

	msg := req.Msg
	issues, err := h.svc.ListIssues(ctx, application.ListIssuesInput{
		FacilityID: msg.GetFacilityId(), UnitID: msg.GetUnitId(),
		BatchID:         msg.GetBatchId(),
		OutstandingOnly: msg.GetOutstandingOnly(),
		From:            timeOf(msg.GetFrom()), To: timeOf(msg.GetTo()),
		PageSize: msg.GetPageSize(), Offset: msg.GetOffset(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.ListLinenIssuesResponse{
		Issues: issuesToWire(issues),
	}), nil
}

func (h *Handler) GetUnitStock(ctx context.Context,
	req *connect.Request[laundryv1.GetUnitStockRequest]) (
	*connect.Response[laundryv1.GetUnitStockResponse], error) {

	stock, err := h.svc.UnitStock(ctx, req.Msg.GetUnitId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.GetUnitStockResponse{
		OnHand:              countsToWire(stock.Balance.OnHand),
		Issued:              countsToWire(stock.Balance.Issued),
		Returned:            countsToWire(stock.Balance.Returned),
		WrittenOff:          countsToWire(stock.Balance.WrittenOff),
		UnreconciledReturns: int32(stock.Balance.UnreconciledReturns),
		Shortfalls:          shortfallsToWire(stock.Shortfalls),
		ParInForce:          parToWire(stock.ParInForce),
		NoPar:               stock.NoPar, Truncated: stock.Truncated,
	}), nil
}

// Condemned, damaged and missing linen (SRS-LND-006).

func (h *Handler) ReportLinenLoss(ctx context.Context,
	req *connect.Request[laundryv1.ReportLinenLossRequest]) (
	*connect.Response[laundryv1.ReportLinenLossResponse], error) {

	msg := req.Msg
	record, err := h.svc.ReportLoss(ctx, application.ReportLossInput{
		UnitID: msg.GetUnitId(), FacilityID: msg.GetFacilityId(),
		ItemCode: msg.GetItemCode(), Quantity: int(msg.GetQuantity()),
		Kind: lossKindFromWire[msg.GetKind()], Reason: msg.GetReason(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.ReportLinenLossResponse{
		Loss: lossToWire(record),
	}), nil
}

func (h *Handler) ApproveLinenLoss(ctx context.Context,
	req *connect.Request[laundryv1.ApproveLinenLossRequest]) (
	*connect.Response[laundryv1.ApproveLinenLossResponse], error) {

	record, err := h.svc.DecideLoss(ctx, req.Msg.GetLossId(),
		req.Msg.GetApprove(), req.Msg.GetNote())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.ApproveLinenLossResponse{
		Loss: lossToWire(record),
	}), nil
}

func (h *Handler) RecoverLinenLoss(ctx context.Context,
	req *connect.Request[laundryv1.RecoverLinenLossRequest]) (
	*connect.Response[laundryv1.RecoverLinenLossResponse], error) {

	record, err := h.svc.RecoverLoss(ctx, req.Msg.GetLossId(),
		req.Msg.GetNote())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.RecoverLinenLossResponse{
		Loss: lossToWire(record),
	}), nil
}

func (h *Handler) ListLinenLosses(ctx context.Context,
	req *connect.Request[laundryv1.ListLinenLossesRequest]) (
	*connect.Response[laundryv1.ListLinenLossesResponse], error) {

	msg := req.Msg
	records, err := h.svc.ListLosses(ctx, application.ListLossesInput{
		FacilityID: msg.GetFacilityId(), UnitID: msg.GetUnitId(),
		ItemCode: msg.GetItemCode(),
		Kind:     string(lossKindFromWire[msg.GetKind()]),
		States:   lossStatesFromWire(msg.GetStates()),
		From:     timeOf(msg.GetFrom()), To: timeOf(msg.GetTo()),
		PageSize: msg.GetPageSize(), Offset: msg.GetOffset(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.ListLinenLossesResponse{
		Losses: lossesToWire(records),
	}), nil
}

func (h *Handler) ListPendingLossApprovals(ctx context.Context,
	req *connect.Request[laundryv1.ListPendingLossApprovalsRequest]) (
	*connect.Response[laundryv1.ListPendingLossApprovalsResponse], error) {

	records, err := h.svc.PendingApprovals(ctx, req.Msg.GetFacilityId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(
		&laundryv1.ListPendingLossApprovalsResponse{
			Losses: lossesToWire(records),
		}), nil
}

// Tagged linen and uniforms (SRS-LND-007).

func (h *Handler) RegisterTag(ctx context.Context,
	req *connect.Request[laundryv1.RegisterTagRequest]) (
	*connect.Response[laundryv1.RegisterTagResponse], error) {

	msg := req.Msg
	tracked, err := h.svc.RegisterTag(ctx, application.RegisterTagInput{
		NewTrackedInput: domain.NewTrackedInput{
			TagID: msg.GetTagId(), TagKind: tagKindFromWire[msg.GetTagKind()],
			ItemCode: msg.GetItemCode(), AssignedTo: msg.GetAssignedTo(),
			FacilityID: msg.GetFacilityId(),
		},
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.RegisterTagResponse{
		Item: trackedToWire(tracked),
	}), nil
}

func (h *Handler) RecordTagScan(ctx context.Context,
	req *connect.Request[laundryv1.RecordTagScanRequest]) (
	*connect.Response[laundryv1.RecordTagScanResponse], error) {

	msg := req.Msg
	tracked, err := h.svc.RecordScan(ctx, application.RecordScanInput{
		TagID: msg.GetTagId(), Location: msg.GetLocation(),
		HolderID: msg.GetHolderId(), Note: msg.GetNote(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.RecordTagScanResponse{
		Item: trackedToWire(tracked),
	}), nil
}

func (h *Handler) RetireTag(ctx context.Context,
	req *connect.Request[laundryv1.RetireTagRequest]) (
	*connect.Response[laundryv1.RetireTagResponse], error) {

	tracked, err := h.svc.RetireTag(ctx, req.Msg.GetTrackedId(),
		req.Msg.GetReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.RetireTagResponse{
		Item: trackedToWire(tracked),
	}), nil
}

func (h *Handler) GetTagCustody(ctx context.Context,
	req *connect.Request[laundryv1.GetTagCustodyRequest]) (
	*connect.Response[laundryv1.GetTagCustodyResponse], error) {

	custody, err := h.svc.TrackedCustody(ctx, req.Msg.GetTagId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.GetTagCustodyResponse{
		Item:    trackedToWire(custody.Item),
		Custody: custodyToWire(custody.Custody),
	}), nil
}

func (h *Handler) ListTrackedItems(ctx context.Context,
	req *connect.Request[laundryv1.ListTrackedItemsRequest]) (
	*connect.Response[laundryv1.ListTrackedItemsResponse], error) {

	msg := req.Msg
	items, err := h.svc.ListTracked(ctx, application.ListTrackedInput{
		FacilityID: msg.GetFacilityId(), ItemCode: msg.GetItemCode(),
		AssignedTo:    msg.GetAssignedTo(),
		InServiceOnly: msg.GetInServiceOnly(),
		PageSize:      msg.GetPageSize(), Offset: msg.GetOffset(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&laundryv1.ListTrackedItemsResponse{
		Items: trackedItemsToWire(items),
	}), nil
}

func (h *Handler) ListStaleTrackedItems(ctx context.Context,
	req *connect.Request[laundryv1.ListStaleTrackedItemsRequest]) (
	*connect.Response[laundryv1.ListStaleTrackedItemsResponse], error) {

	stale, err := h.svc.StaleTracked(ctx, req.Msg.GetFacilityId())
	if err != nil {
		return nil, err
	}
	out := make([]*laundryv1.StaleTrackedItem, 0, len(stale))
	for _, entry := range stale {
		out = append(out, &laundryv1.StaleTrackedItem{
			Item:      trackedToWire(entry.Item),
			Custody:   custodyToWire(entry.Custody),
			QuietDays: int32(entry.QuietDays),
			NeverSeen: entry.NeverSeen,
		})
	}
	return connect.NewResponse(
		&laundryv1.ListStaleTrackedItemsResponse{Items: out}), nil
}

// Reporting (SRS-LND-003, SRS-LND-006).

func (h *Handler) GetWashReport(ctx context.Context,
	req *connect.Request[laundryv1.GetWashReportRequest]) (
	*connect.Response[laundryv1.GetWashReportResponse], error) {

	msg := req.Msg
	report, err := h.svc.WashReport(ctx, application.ReportInput{
		FacilityID: msg.GetFacilityId(),
		From:       timeOf(msg.GetFrom()), To: timeOf(msg.GetTo()),
	})
	if err != nil {
		return nil, err
	}
	summary := report.Summary
	return connect.NewResponse(&laundryv1.GetWashReportResponse{
		Summary: &laundryv1.WashSummary{
			Run: int32(summary.Run), Passed: int32(summary.Passed),
			Failed:         int32(summary.Failed),
			Rewashed:       int32(summary.Rewashed),
			InFlight:       int32(summary.InFlight),
			Infected:       int32(summary.Infected),
			WeightKg:       int32(summary.WeightKg),
			WithExceptions: int32(summary.WithExceptions),
			Unanswerable:   summary.Unanswerable,
		},
		Truncated: report.Truncated,
	}), nil
}

func (h *Handler) GetLinenLossReport(ctx context.Context,
	req *connect.Request[laundryv1.GetLinenLossReportRequest]) (
	*connect.Response[laundryv1.GetLinenLossReportResponse], error) {

	msg := req.Msg
	report, err := h.svc.LossReport(ctx, application.ReportInput{
		FacilityID: msg.GetFacilityId(),
		From:       timeOf(msg.GetFrom()), To: timeOf(msg.GetTo()),
	})
	if err != nil {
		return nil, err
	}
	summary := report.Summary
	return connect.NewResponse(&laundryv1.GetLinenLossReportResponse{
		Summary: &laundryv1.LinenLossSummary{
			Reported:         int32(summary.Reported),
			Pieces:           int32(summary.Pieces),
			ValueMinor:       int32(summary.ValueMinor),
			Condemned:        int32(summary.Condemned),
			Damaged:          int32(summary.Damaged),
			Missing:          int32(summary.Missing),
			Recovered:        int32(summary.Recovered),
			AwaitingApproval: int32(summary.AwaitingApproval),
			Rejected:         int32(summary.Rejected),
		},
		Truncated: report.Truncated,
	}), nil
}
