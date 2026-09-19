package transport

import (
	"context"
	"time"

	"connectrpc.com/connect"

	recordsv1 "github.com/ppusapati/health/code/gen/go/healthcare/records/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/records/v1/recordsv1connect"
	"github.com/ppusapati/health/code/internal/records/application"
	"github.com/ppusapati/health/code/internal/records/ports"
)

// Handler is the medical records ConnectRPC surface.
//
// Thin on purpose: it translates, calls one use case and translates back.
// Every refusal comes from the application or the domain, so the same rule
// holds whichever client asks.
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

// Chart completion (SRS-MRD-001).

func (h *Handler) DraftChecklist(ctx context.Context,
	req *connect.Request[recordsv1.DraftChecklistRequest]) (
	*connect.Response[recordsv1.DraftChecklistResponse], error) {

	msg := req.Msg
	checklist, err := h.svc.DraftChecklist(ctx, application.NewChecklistInput{
		Code: msg.GetCode(), Name: msg.GetName(),
		Revision:       int(msg.GetRevision()),
		EncounterClass: msg.GetEncounterClass(),
		Specialty:      msg.GetSpecialty(),
		Items:          checklistItemsFromWire(msg.GetItems()),
		EffectiveFrom:  timeOf(msg.GetEffectiveFrom()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.DraftChecklistResponse{
		Checklist: checklistToWire(checklist),
	}), nil
}

func (h *Handler) ApproveChecklist(ctx context.Context,
	req *connect.Request[recordsv1.ApproveChecklistRequest]) (
	*connect.Response[recordsv1.ApproveChecklistResponse], error) {

	checklist, err := h.svc.ApproveChecklist(ctx,
		req.Msg.GetChecklistId(), timeOf(req.Msg.GetEffectiveFrom()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.ApproveChecklistResponse{
		Checklist: checklistToWire(checklist),
	}), nil
}

func (h *Handler) ListChecklists(ctx context.Context,
	req *connect.Request[recordsv1.ListChecklistsRequest]) (
	*connect.Response[recordsv1.ListChecklistsResponse], error) {

	list, err := h.svc.Checklists(ctx, req.Msg.GetEncounterClass(),
		req.Msg.GetLiveOnly())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.ListChecklistsResponse{
		Checklists: checklistsToWire(list),
	}), nil
}

func (h *Handler) GetChartGaps(ctx context.Context,
	req *connect.Request[recordsv1.GetChartGapsRequest]) (
	*connect.Response[recordsv1.GetChartGapsResponse], error) {

	status, err := h.svc.ChartGaps(ctx, req.Msg.GetEncounterId())
	if err != nil {
		return nil, err
	}
	gaps := make([]*recordsv1.Gap, 0, len(status.Gaps))
	for _, gap := range status.Gaps {
		gaps = append(gaps, &recordsv1.Gap{
			Kind: gap.Kind, Label: gap.Label, Missing: gap.Missing,
			DocumentId: gap.DocumentID, OwnerId: gap.OwnerID,
			DueBy: stamp(gap.DueBy),
		})
	}
	return connect.NewResponse(&recordsv1.GetChartGapsResponse{
		Status: &recordsv1.ChartStatus{
			EncounterId: status.EncounterID, PatientId: status.PatientID,
			ChecklistCode:     status.ChecklistCode,
			ChecklistRevision: int32(status.ChecklistRevision),
			Gaps:              gaps, Documents: int32(status.Documents),
		},
	}), nil
}

// Deficiencies (SRS-MRD-002, SRS-MRD-008).

func (h *Handler) RaiseDeficiencies(ctx context.Context,
	req *connect.Request[recordsv1.RaiseDeficienciesRequest]) (
	*connect.Response[recordsv1.RaiseDeficienciesResponse], error) {

	raised, err := h.svc.RaiseDeficiencies(ctx, req.Msg.GetEncounterId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.RaiseDeficienciesResponse{
		Raised: deficienciesToWire(raised),
	}), nil
}

func (h *Handler) RaiseCodingQuery(ctx context.Context,
	req *connect.Request[recordsv1.RaiseCodingQueryRequest]) (
	*connect.Response[recordsv1.RaiseCodingQueryResponse], error) {

	msg := req.Msg
	deficiency, err := h.svc.RaiseCodingQuery(ctx, msg.GetEncounterId(),
		msg.GetDocumentId(), msg.GetOwnerId(), msg.GetDetail(),
		timeOf(msg.GetDueBy()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.RaiseCodingQueryResponse{
		Deficiency: deficiencyToWire(deficiency),
	}), nil
}

func (h *Handler) ResolveDeficiency(ctx context.Context,
	req *connect.Request[recordsv1.ResolveDeficiencyRequest]) (
	*connect.Response[recordsv1.ResolveDeficiencyResponse], error) {

	deficiency, err := h.svc.ResolveDeficiency(ctx,
		req.Msg.GetDeficiencyId(), req.Msg.GetDocumentId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.ResolveDeficiencyResponse{
		Deficiency: deficiencyToWire(deficiency),
	}), nil
}

func (h *Handler) WaiveDeficiency(ctx context.Context,
	req *connect.Request[recordsv1.WaiveDeficiencyRequest]) (
	*connect.Response[recordsv1.WaiveDeficiencyResponse], error) {

	deficiency, err := h.svc.WaiveDeficiency(ctx,
		req.Msg.GetDeficiencyId(), req.Msg.GetReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.WaiveDeficiencyResponse{
		Deficiency: deficiencyToWire(deficiency),
	}), nil
}

func (h *Handler) ReassignDeficiency(ctx context.Context,
	req *connect.Request[recordsv1.ReassignDeficiencyRequest]) (
	*connect.Response[recordsv1.ReassignDeficiencyResponse], error) {

	deficiency, err := h.svc.ReassignDeficiency(ctx,
		req.Msg.GetDeficiencyId(), req.Msg.GetOwnerId(),
		req.Msg.GetReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.ReassignDeficiencyResponse{
		Deficiency: deficiencyToWire(deficiency),
	}), nil
}

func (h *Handler) ListDeficiencies(ctx context.Context,
	req *connect.Request[recordsv1.ListDeficienciesRequest]) (
	*connect.Response[recordsv1.ListDeficienciesResponse], error) {

	msg := req.Msg
	list, err := h.svc.Deficiencies(ctx, ports.DeficiencyFilter{
		OwnerID: msg.GetOwnerId(), EncounterID: msg.GetEncounterId(),
		FacilityID: msg.GetFacilityId(),
		State:      string(deficiencyStateFromWire[msg.GetState()]),
		OpenOnly:   msg.GetOpenOnly(),
		From:       timeOf(msg.GetFrom()), To: timeOf(msg.GetTo()),
		Limit: msg.GetPageSize(), Offset: msg.GetPageOffset(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.ListDeficienciesResponse{
		Deficiencies: deficienciesToWire(list),
	}), nil
}

func (h *Handler) GetAgingReport(ctx context.Context,
	req *connect.Request[recordsv1.GetAgingReportRequest]) (
	*connect.Response[recordsv1.GetAgingReportResponse], error) {

	buckets, err := h.svc.AgingReport(ctx, ports.DeficiencyFilter{
		OwnerID: req.Msg.GetOwnerId(), FacilityID: req.Msg.GetFacilityId(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*recordsv1.AgeBucket, 0, len(buckets))
	for _, bucket := range buckets {
		out = append(out, &recordsv1.AgeBucket{
			FromDays: int32(bucket.From), ToDays: int32(bucket.To),
			Label: bucket.Label, Count: int32(bucket.Count),
			Overdue: int32(bucket.Overdue),
		})
	}
	return connect.NewResponse(&recordsv1.GetAgingReportResponse{
		Buckets: out,
	}), nil
}

func (h *Handler) GetCompletionSummary(ctx context.Context,
	req *connect.Request[recordsv1.GetCompletionSummaryRequest]) (
	*connect.Response[recordsv1.GetCompletionSummaryResponse], error) {

	summary, err := h.svc.CompletionSummary(ctx, req.Msg.GetEncounterIds())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.GetCompletionSummaryResponse{
		Summary: &recordsv1.CompletionSummary{
			Encounters:       int32(summary.Encounters),
			Complete:         int32(summary.Complete),
			Incompletable:    int32(summary.Incompletable),
			Open:             int32(summary.Open),
			Overdue:          int32(summary.Overdue),
			Resolved:         int32(summary.Resolved),
			Waived:           int32(summary.Waived),
			CompletePermille: int32(summary.CompletePermille),
			Unanswerable:     summary.Unanswerable,
		},
	}), nil
}

func (h *Handler) EscalateOverdueDeficiencies(ctx context.Context,
	req *connect.Request[recordsv1.EscalateOverdueDeficienciesRequest]) (
	*connect.Response[recordsv1.EscalateOverdueDeficienciesResponse], error) {

	raised, err := h.svc.EscalateOverdueDeficiencies(ctx)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(
		&recordsv1.EscalateOverdueDeficienciesResponse{
			Raised: int32(raised),
		}), nil
}

// Clinical coding (SRS-MRD-003).

func (h *Handler) AssignCodes(ctx context.Context,
	req *connect.Request[recordsv1.AssignCodesRequest]) (
	*connect.Response[recordsv1.AssignCodesResponse], error) {

	episode, err := h.svc.AssignCodes(ctx, application.AssignCodesInput{
		EncounterID: req.Msg.GetEncounterId(),
		Codes:       codesFromWire(req.Msg.GetCodes()),
		Reason:      req.Msg.GetReason(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.AssignCodesResponse{
		Episode: episodeToWire(episode),
	}), nil
}

func (h *Handler) FinaliseCoding(ctx context.Context,
	req *connect.Request[recordsv1.FinaliseCodingRequest]) (
	*connect.Response[recordsv1.FinaliseCodingResponse], error) {

	episode, err := h.svc.FinaliseCoding(ctx, req.Msg.GetEpisodeId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.FinaliseCodingResponse{
		Episode: episodeToWire(episode),
	}), nil
}

func (h *Handler) QueryCoding(ctx context.Context,
	req *connect.Request[recordsv1.QueryCodingRequest]) (
	*connect.Response[recordsv1.QueryCodingResponse], error) {

	episode, err := h.svc.QueryCoding(ctx, req.Msg.GetEpisodeId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.QueryCodingResponse{
		Episode: episodeToWire(episode),
	}), nil
}

func (h *Handler) GetCodedEpisode(ctx context.Context,
	req *connect.Request[recordsv1.GetCodedEpisodeRequest]) (
	*connect.Response[recordsv1.GetCodedEpisodeResponse], error) {

	episode, err := h.svc.CodedEpisode(ctx, req.Msg.GetEpisodeId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.GetCodedEpisodeResponse{
		Episode: episodeToWire(episode),
	}), nil
}

func (h *Handler) GetCodingDiff(ctx context.Context,
	req *connect.Request[recordsv1.GetCodingDiffRequest]) (
	*connect.Response[recordsv1.GetCodingDiffResponse], error) {

	changes, err := h.svc.CodingDiff(ctx, req.Msg.GetEpisodeId(),
		int(req.Msg.GetBeforeRevision()), int(req.Msg.GetAfterRevision()))
	if err != nil {
		return nil, err
	}
	out := make([]*recordsv1.CodingChange, 0, len(changes))
	for _, change := range changes {
		out = append(out, &recordsv1.CodingChange{
			System: change.System, Code: change.Code,
			Was: codeRoleToWire[change.Was], Now: codeRoleToWire[change.Now],
		})
	}
	return connect.NewResponse(&recordsv1.GetCodingDiffResponse{
		Changes: out,
	}), nil
}

// Record release and the accounting of disclosures (SRS-MRD-004,
// SRS-MRD-010).

func (h *Handler) RequestRelease(ctx context.Context,
	req *connect.Request[recordsv1.RequestReleaseRequest]) (
	*connect.Response[recordsv1.RequestReleaseResponse], error) {

	msg := req.Msg
	release, err := h.svc.RequestRelease(ctx, application.NewReleaseInput{
		Reference: msg.GetReference(), PatientID: msg.GetPatientId(),
		Purpose:       msg.GetPurpose(),
		Authorisation: authorisationFromWire(msg.GetAuthorisation()),
		Recipient:     recipientFrom(msg.GetRecipient()),
		Scope:         scopeFromWire(msg.GetScope()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.RequestReleaseResponse{
		Release: releaseToWire(release),
	}), nil
}

func (h *Handler) ApproveRelease(ctx context.Context,
	req *connect.Request[recordsv1.ApproveReleaseRequest]) (
	*connect.Response[recordsv1.ApproveReleaseResponse], error) {

	release, err := h.svc.ApproveRelease(ctx, req.Msg.GetReleaseId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.ApproveReleaseResponse{
		Release: releaseToWire(release),
	}), nil
}

func (h *Handler) RefuseRelease(ctx context.Context,
	req *connect.Request[recordsv1.RefuseReleaseRequest]) (
	*connect.Response[recordsv1.RefuseReleaseResponse], error) {

	release, err := h.svc.RefuseRelease(ctx, req.Msg.GetReleaseId(),
		req.Msg.GetReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.RefuseReleaseResponse{
		Release: releaseToWire(release),
	}), nil
}

func (h *Handler) AssembleRelease(ctx context.Context,
	req *connect.Request[recordsv1.AssembleReleaseRequest]) (
	*connect.Response[recordsv1.AssembleReleaseResponse], error) {

	release, err := h.svc.AssembleRelease(ctx, req.Msg.GetReleaseId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.AssembleReleaseResponse{
		Release: releaseToWire(release),
	}), nil
}

func (h *Handler) SendRelease(ctx context.Context,
	req *connect.Request[recordsv1.SendReleaseRequest]) (
	*connect.Response[recordsv1.SendReleaseResponse], error) {

	release, disclosure, err := h.svc.SendRelease(ctx,
		req.Msg.GetReleaseId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.SendReleaseResponse{
		Release: releaseToWire(release), Disclosure: disclosureToWire(
			disclosure),
	}), nil
}

func (h *Handler) ListReleases(ctx context.Context,
	req *connect.Request[recordsv1.ListReleasesRequest]) (
	*connect.Response[recordsv1.ListReleasesResponse], error) {

	msg := req.Msg
	list, err := h.svc.Releases(ctx, ports.ReleaseFilter{
		PatientID: msg.GetPatientId(),
		State:     string(releaseStateFromWire[msg.GetState()]),
		OpenOnly:  msg.GetOpenOnly(),
		From:      timeOf(msg.GetFrom()), To: timeOf(msg.GetTo()),
		Limit: msg.GetPageSize(), Offset: msg.GetPageOffset(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.ListReleasesResponse{
		Releases: releasesToWire(list),
	}), nil
}

func (h *Handler) RecordDisclosure(ctx context.Context,
	req *connect.Request[recordsv1.RecordDisclosureRequest]) (
	*connect.Response[recordsv1.RecordDisclosureResponse], error) {

	msg := req.Msg
	disclosure, err := h.svc.RecordDisclosure(ctx, msg.GetPatientId(),
		disclosureKindFromWire[msg.GetKind()], msg.GetPurpose(),
		msg.GetScopeSummary(), recipientFrom(msg.GetRecipient()),
		int(msg.GetItems()), int(msg.GetPages()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.RecordDisclosureResponse{
		Disclosure: disclosureToWire(disclosure),
	}), nil
}

func (h *Handler) ListDisclosures(ctx context.Context,
	req *connect.Request[recordsv1.ListDisclosuresRequest]) (
	*connect.Response[recordsv1.ListDisclosuresResponse], error) {

	msg := req.Msg
	list, err := h.svc.Disclosures(ctx, ports.DisclosureFilter{
		PatientID: msg.GetPatientId(), ActorID: msg.GetActorId(),
		From: timeOf(msg.GetFrom()), To: timeOf(msg.GetTo()),
		Limit: msg.GetPageSize(), Offset: msg.GetPageOffset(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*recordsv1.Disclosure, 0, len(list))
	for _, disclosure := range list {
		out = append(out, disclosureToWire(disclosure))
	}
	return connect.NewResponse(&recordsv1.ListDisclosuresResponse{
		Disclosures: out,
	}), nil
}

// Retention, legal holds and disposition (SRS-MRD-005, SRS-MRD-009).

func (h *Handler) DraftRetentionRule(ctx context.Context,
	req *connect.Request[recordsv1.DraftRetentionRuleRequest]) (
	*connect.Response[recordsv1.DraftRetentionRuleResponse], error) {

	msg := req.Msg
	rule, err := h.svc.DraftRetentionRule(ctx,
		application.NewRetentionRuleInput{
			Code: msg.GetCode(), Name: msg.GetName(),
			Revision:      int(msg.GetRevision()),
			RecordClass:   msg.GetRecordClass(),
			Jurisdiction:  msg.GetJurisdiction(),
			Anchor:        anchorFromWire[msg.GetAnchor()],
			RetainYears:   int(msg.GetRetainYears()),
			Disposition:   dispositionKindFromWire[msg.GetDisposition()],
			Authority:     msg.GetAuthority(),
			EffectiveFrom: timeOf(msg.GetEffectiveFrom()),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.DraftRetentionRuleResponse{
		Rule: retentionRuleToWire(rule),
	}), nil
}

func (h *Handler) ApproveRetentionRule(ctx context.Context,
	req *connect.Request[recordsv1.ApproveRetentionRuleRequest]) (
	*connect.Response[recordsv1.ApproveRetentionRuleResponse], error) {

	rule, err := h.svc.ApproveRetentionRule(ctx, req.Msg.GetRuleId(),
		timeOf(req.Msg.GetEffectiveFrom()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.ApproveRetentionRuleResponse{
		Rule: retentionRuleToWire(rule),
	}), nil
}

func (h *Handler) ListRetentionRules(ctx context.Context,
	req *connect.Request[recordsv1.ListRetentionRulesRequest]) (
	*connect.Response[recordsv1.ListRetentionRulesResponse], error) {

	rules, err := h.svc.RetentionRules(ctx, req.Msg.GetJurisdiction(),
		req.Msg.GetRecordClass(), req.Msg.GetLiveOnly())
	if err != nil {
		return nil, err
	}
	out := make([]*recordsv1.RetentionRule, 0, len(rules))
	for _, rule := range rules {
		out = append(out, retentionRuleToWire(rule))
	}
	return connect.NewResponse(&recordsv1.ListRetentionRulesResponse{
		Rules: out,
	}), nil
}

func (h *Handler) PlaceHold(ctx context.Context,
	req *connect.Request[recordsv1.PlaceHoldRequest]) (
	*connect.Response[recordsv1.PlaceHoldResponse], error) {

	if err := h.svc.PlaceHold(ctx, req.Msg.GetRecordClass(),
		req.Msg.GetRecordId(), req.Msg.GetReason()); err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.PlaceHoldResponse{}), nil
}

func (h *Handler) ReleaseHold(ctx context.Context,
	req *connect.Request[recordsv1.ReleaseHoldRequest]) (
	*connect.Response[recordsv1.ReleaseHoldResponse], error) {

	if err := h.svc.ReleaseHold(ctx, req.Msg.GetRecordClass(),
		req.Msg.GetRecordId()); err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.ReleaseHoldResponse{}), nil
}

func (h *Handler) SweepForDisposition(ctx context.Context,
	req *connect.Request[recordsv1.SweepForDispositionRequest]) (
	*connect.Response[recordsv1.SweepForDispositionResponse], error) {

	sweep, err := h.svc.SweepForDisposition(ctx,
		req.Msg.GetJurisdiction())
	if err != nil {
		return nil, err
	}
	eligible := make([]*recordsv1.DispositionCandidate, 0,
		len(sweep.Eligible))
	for _, candidate := range sweep.Eligible {
		eligible = append(eligible, candidateToWire(candidate))
	}
	ineligible := make([]*recordsv1.Ineligible, 0, len(sweep.Ineligible))
	for _, passed := range sweep.Ineligible {
		ineligible = append(ineligible, &recordsv1.Ineligible{
			RecordId: passed.RecordID, Reason: passed.Reason,
		})
	}
	return connect.NewResponse(&recordsv1.SweepForDispositionResponse{
		Jurisdiction: sweep.Jurisdiction, Eligible: eligible,
		Ineligible: ineligible, Swept: int32(sweep.Swept),
	}), nil
}

func (h *Handler) PrepareDisposition(ctx context.Context,
	req *connect.Request[recordsv1.PrepareDispositionRequest]) (
	*connect.Response[recordsv1.PrepareDispositionResponse], error) {

	msg := req.Msg
	list, err := h.svc.PrepareDisposition(ctx, msg.GetReference(),
		msg.GetJurisdiction(),
		dispositionKindFromWire[msg.GetDisposition()], msg.GetRecordIds())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.PrepareDispositionResponse{
		List: dispositionListToWire(list),
	}), nil
}

func (h *Handler) ApproveDisposition(ctx context.Context,
	req *connect.Request[recordsv1.ApproveDispositionRequest]) (
	*connect.Response[recordsv1.ApproveDispositionResponse], error) {

	list, err := h.svc.ApproveDisposition(ctx, req.Msg.GetListId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.ApproveDispositionResponse{
		List: dispositionListToWire(list),
	}), nil
}

func (h *Handler) ExecuteDisposition(ctx context.Context,
	req *connect.Request[recordsv1.ExecuteDispositionRequest]) (
	*connect.Response[recordsv1.ExecuteDispositionResponse], error) {

	list, err := h.svc.ExecuteDisposition(ctx, req.Msg.GetListId(),
		req.Msg.GetCertificate())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.ExecuteDispositionResponse{
		List: dispositionListToWire(list),
	}), nil
}

func (h *Handler) CancelDisposition(ctx context.Context,
	req *connect.Request[recordsv1.CancelDispositionRequest]) (
	*connect.Response[recordsv1.CancelDispositionResponse], error) {

	list, err := h.svc.CancelDisposition(ctx, req.Msg.GetListId(),
		req.Msg.GetReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.CancelDispositionResponse{
		List: dispositionListToWire(list),
	}), nil
}

func (h *Handler) ListDispositionLists(ctx context.Context,
	req *connect.Request[recordsv1.ListDispositionListsRequest]) (
	*connect.Response[recordsv1.ListDispositionListsResponse], error) {

	msg := req.Msg
	lists, err := h.svc.DispositionLists(ctx, ports.DispositionFilter{
		State:        string(dispositionStateFromWire[msg.GetState()]),
		Jurisdiction: msg.GetJurisdiction(),
		Limit:        msg.GetPageSize(), Offset: msg.GetPageOffset(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*recordsv1.DispositionList, 0, len(lists))
	for _, list := range lists {
		out = append(out, dispositionListToWire(list))
	}
	return connect.NewResponse(&recordsv1.ListDispositionListsResponse{
		Lists: out,
	}), nil
}

// Physical record tracking (SRS-MRD-006).

func (h *Handler) RegisterPhysicalRecord(ctx context.Context,
	req *connect.Request[recordsv1.RegisterPhysicalRecordRequest]) (
	*connect.Response[recordsv1.RegisterPhysicalRecordResponse], error) {

	msg := req.Msg
	record, err := h.svc.RegisterPhysicalRecord(ctx,
		application.NewPhysicalRecordInput{
			Reference: msg.GetReference(), PatientID: msg.GetPatientId(),
			Volume: int(msg.GetVolume()), RecordClass: msg.GetRecordClass(),
			Jurisdiction: msg.GetJurisdiction(),
			Description:  msg.GetDescription(),
			HomeLocation: msg.GetHomeLocation(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.RegisterPhysicalRecordResponse{
		Record: physicalToWire(record),
	}), nil
}

func (h *Handler) CheckOutRecord(ctx context.Context,
	req *connect.Request[recordsv1.CheckOutRecordRequest]) (
	*connect.Response[recordsv1.CheckOutRecordResponse], error) {

	msg := req.Msg
	record, err := h.svc.CheckOutRecord(ctx, msg.GetRecordId(),
		msg.GetCustodian(), msg.GetLocation(), msg.GetPurpose(),
		timeOf(msg.GetDueBack()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.CheckOutRecordResponse{
		Record: physicalToWire(record),
	}), nil
}

func (h *Handler) CheckInRecord(ctx context.Context,
	req *connect.Request[recordsv1.CheckInRecordRequest]) (
	*connect.Response[recordsv1.CheckInRecordResponse], error) {

	record, err := h.svc.CheckInRecord(ctx, req.Msg.GetRecordId(),
		req.Msg.GetLocation())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.CheckInRecordResponse{
		Record: physicalToWire(record),
	}), nil
}

func (h *Handler) MarkRecordMissing(ctx context.Context,
	req *connect.Request[recordsv1.MarkRecordMissingRequest]) (
	*connect.Response[recordsv1.MarkRecordMissingResponse], error) {

	record, err := h.svc.MarkRecordMissing(ctx, req.Msg.GetRecordId(),
		req.Msg.GetReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.MarkRecordMissingResponse{
		Record: physicalToWire(record),
	}), nil
}

func (h *Handler) ArchiveRecord(ctx context.Context,
	req *connect.Request[recordsv1.ArchiveRecordRequest]) (
	*connect.Response[recordsv1.ArchiveRecordResponse], error) {

	record, err := h.svc.ArchiveRecord(ctx, req.Msg.GetRecordId(),
		req.Msg.GetLocation())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.ArchiveRecordResponse{
		Record: physicalToWire(record),
	}), nil
}

func (h *Handler) ListPhysicalRecords(ctx context.Context,
	req *connect.Request[recordsv1.ListPhysicalRecordsRequest]) (
	*connect.Response[recordsv1.ListPhysicalRecordsResponse], error) {

	msg := req.Msg
	records, err := h.svc.PhysicalRecords(ctx, ports.PhysicalFilter{
		PatientID: msg.GetPatientId(),
		State:     string(physicalStateFromWire[msg.GetState()]),
		OutOnly:   msg.GetOutOnly(), OverdueOnly: msg.GetOverdueOnly(),
		Limit: msg.GetPageSize(), Offset: msg.GetPageOffset(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*recordsv1.PhysicalRecord, 0, len(records))
	for _, record := range records {
		out = append(out, physicalToWire(record))
	}
	return connect.NewResponse(&recordsv1.ListPhysicalRecordsResponse{
		Records: out,
	}), nil
}

// Statutory certificates (SRS-MRD-007).

func (h *Handler) DraftCertificateForm(ctx context.Context,
	req *connect.Request[recordsv1.DraftCertificateFormRequest]) (
	*connect.Response[recordsv1.DraftCertificateFormResponse], error) {

	msg := req.Msg
	form, err := h.svc.DraftCertificateForm(ctx,
		application.NewCertificateFormInput{
			Code: msg.GetCode(), Name: msg.GetName(),
			Revision:      int(msg.GetRevision()),
			Kind:          certificateKindFromWire[msg.GetKind()],
			Jurisdiction:  msg.GetJurisdiction(),
			Fields:        certificateFieldsFromWire(msg.GetFields()),
			IssuerRole:    msg.GetIssuerRole(),
			EffectiveFrom: timeOf(msg.GetEffectiveFrom()),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.DraftCertificateFormResponse{
		Form: certificateFormToWire(form),
	}), nil
}

func (h *Handler) ApproveCertificateForm(ctx context.Context,
	req *connect.Request[recordsv1.ApproveCertificateFormRequest]) (
	*connect.Response[recordsv1.ApproveCertificateFormResponse], error) {

	form, err := h.svc.ApproveCertificateForm(ctx, req.Msg.GetFormId(),
		timeOf(req.Msg.GetEffectiveFrom()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.ApproveCertificateFormResponse{
		Form: certificateFormToWire(form),
	}), nil
}

func (h *Handler) ListCertificateForms(ctx context.Context,
	req *connect.Request[recordsv1.ListCertificateFormsRequest]) (
	*connect.Response[recordsv1.ListCertificateFormsResponse], error) {

	forms, err := h.svc.CertificateForms(ctx,
		certificateKindFromWire[req.Msg.GetKind()],
		req.Msg.GetJurisdiction(), req.Msg.GetLiveOnly())
	if err != nil {
		return nil, err
	}
	out := make([]*recordsv1.CertificateForm, 0, len(forms))
	for _, form := range forms {
		out = append(out, certificateFormToWire(form))
	}
	return connect.NewResponse(&recordsv1.ListCertificateFormsResponse{
		Forms: out,
	}), nil
}

func (h *Handler) IssueCertificate(ctx context.Context,
	req *connect.Request[recordsv1.IssueCertificateRequest]) (
	*connect.Response[recordsv1.IssueCertificateResponse], error) {

	msg := req.Msg
	certificate, err := h.svc.IssueCertificate(ctx,
		application.IssueCertificateInput{
			Kind:         certificateKindFromWire[msg.GetKind()],
			Jurisdiction: msg.GetJurisdiction(),
			PatientID:    msg.GetPatientId(),
			EncounterID:  msg.GetEncounterId(),
			Values:       msg.GetValues(),
			SourceRefs:   msg.GetSourceRefs(),
			IssuerRole:   msg.GetIssuerRole(),
			IssuerName:   msg.GetIssuerName(),
			SerialNumber: msg.GetSerialNumber(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.IssueCertificateResponse{
		Certificate: certificateToWire(certificate),
	}), nil
}

func (h *Handler) CorrectCertificate(ctx context.Context,
	req *connect.Request[recordsv1.CorrectCertificateRequest]) (
	*connect.Response[recordsv1.CorrectCertificateResponse], error) {

	msg := req.Msg
	certificate, err := h.svc.CorrectCertificate(ctx,
		msg.GetCertificateId(), msg.GetValues(), msg.GetSourceRefs(),
		msg.GetIssuerRole(), msg.GetIssuerName(), msg.GetReason(),
		msg.GetSerialNumber())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.CorrectCertificateResponse{
		Certificate: certificateToWire(certificate),
	}), nil
}

func (h *Handler) VoidCertificate(ctx context.Context,
	req *connect.Request[recordsv1.VoidCertificateRequest]) (
	*connect.Response[recordsv1.VoidCertificateResponse], error) {

	certificate, err := h.svc.VoidCertificate(ctx,
		req.Msg.GetCertificateId(), req.Msg.GetReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&recordsv1.VoidCertificateResponse{
		Certificate: certificateToWire(certificate),
	}), nil
}

func (h *Handler) ListCertificates(ctx context.Context,
	req *connect.Request[recordsv1.ListCertificatesRequest]) (
	*connect.Response[recordsv1.ListCertificatesResponse], error) {

	msg := req.Msg
	certificates, err := h.svc.Certificates(ctx, ports.CertificateFilter{
		PatientID: msg.GetPatientId(),
		Kind:      certificateKindFromWire[msg.GetKind()],
		State:     string(certificateStateFromWire[msg.GetState()]),
		Limit:     msg.GetPageSize(), Offset: msg.GetPageOffset(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*recordsv1.StatutoryCertificate, 0, len(certificates))
	for _, certificate := range certificates {
		out = append(out, certificateToWire(certificate))
	}
	return connect.NewResponse(&recordsv1.ListCertificatesResponse{
		Certificates: out,
	}), nil
}

// The handler implements the generated service interface. A compile-time
// assertion rather than a test, because a contract that has drifted from its
// implementation should not build.
var _ recordsv1connect.RecordsServiceHandler = (*Handler)(nil)
