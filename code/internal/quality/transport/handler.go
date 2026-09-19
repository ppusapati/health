package transport

import (
	"context"
	"time"

	"connectrpc.com/connect"

	qualityv1 "github.com/ppusapati/health/code/gen/go/healthcare/quality/v1"
	"github.com/ppusapati/health/code/internal/quality/application"
	"github.com/ppusapati/health/code/internal/quality/domain"
	"github.com/ppusapati/health/code/internal/quality/ports"
)

// Handler is the quality ConnectRPC surface.
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

func (h *Handler) ReportIncident(ctx context.Context,
	req *connect.Request[qualityv1.ReportIncidentRequest]) (
	*connect.Response[qualityv1.ReportIncidentResponse], error) {

	msg := req.Msg
	incident, err := h.svc.ReportIncident(ctx, domain.NewIncidentInput{
		Reference: msg.GetReference(), Category: msg.GetCategory(),
		Subcategory: msg.GetSubcategory(),
		Reach:       reachFromWire[msg.GetReach()],
		Harm:        harmFromWire[msg.GetHarm()],
		Consequence: consequenceFromWire[msg.GetConsequence()],
		Likelihood:  likelihoodFromWire[msg.GetLikelihood()],
		PatientID:   msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		AssetID: msg.GetAssetId(), LocationID: msg.GetLocationId(),
		FacilityID: msg.GetFacilityId(), Department: msg.GetDepartment(),
		Narrative:       msg.GetNarrative(),
		ImmediateAction: msg.GetImmediateAction(),
		Sentinel:        msg.GetSentinel(), Anonymous: msg.GetAnonymous(),
		OccurredAt: timeOf(msg.GetOccurredAt()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.ReportIncidentResponse{
		Incident: incidentToProto(incident),
	}), nil
}

func (h *Handler) GetIncident(ctx context.Context,
	req *connect.Request[qualityv1.GetIncidentRequest]) (
	*connect.Response[qualityv1.GetIncidentResponse], error) {

	incident, err := h.svc.Incident(ctx, req.Msg.GetIncidentId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.GetIncidentResponse{
		Incident: incidentToProto(incident),
	}), nil
}

func (h *Handler) ListIncidents(ctx context.Context,
	req *connect.Request[qualityv1.ListIncidentsRequest]) (
	*connect.Response[qualityv1.ListIncidentsResponse], error) {

	msg := req.Msg
	incidents, err := h.svc.Incidents(ctx, ports.IncidentFilter{
		Category: msg.GetCategory(),
		State:    string(incidentStateFromWire[msg.GetState()]),
		OpenOnly: msg.GetOpenOnly(), SentinelOnly: msg.GetSentinelOnly(),
		From: timeOf(msg.GetFrom()), To: timeOf(msg.GetTo()),
		Limit: msg.GetPageSize(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*qualityv1.Incident, 0, len(incidents))
	for _, incident := range incidents {
		out = append(out, incidentToProto(incident))
	}
	return connect.NewResponse(&qualityv1.ListIncidentsResponse{
		Incidents: out,
	}), nil
}

func (h *Handler) RescoreIncident(ctx context.Context,
	req *connect.Request[qualityv1.RescoreIncidentRequest]) (
	*connect.Response[qualityv1.RescoreIncidentResponse], error) {

	msg := req.Msg
	incident, err := h.svc.Rescore(ctx, application.RescoreInput{
		IncidentID:      msg.GetIncidentId(),
		Consequence:     consequenceFromWire[msg.GetConsequence()],
		Likelihood:      likelihoodFromWire[msg.GetLikelihood()],
		ExpectedVersion: msg.GetExpectedVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.RescoreIncidentResponse{
		Incident: incidentToProto(incident),
	}), nil
}

func (h *Handler) AdvanceIncident(ctx context.Context,
	req *connect.Request[qualityv1.AdvanceIncidentRequest]) (
	*connect.Response[qualityv1.AdvanceIncidentResponse], error) {

	msg := req.Msg
	incident, concerns, err := h.svc.AdvanceIncident(ctx,
		application.AdvanceIncidentInput{
			IncidentID:      msg.GetIncidentId(),
			To:              incidentStateFromWire[msg.GetState()],
			Reason:          msg.GetReason(),
			ExpectedVersion: msg.GetExpectedVersion(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.AdvanceIncidentResponse{
		Incident: incidentToProto(incident), Concerns: concerns,
	}), nil
}

func (h *Handler) SetIncidentRestriction(ctx context.Context,
	req *connect.Request[qualityv1.SetIncidentRestrictionRequest]) (
	*connect.Response[qualityv1.SetIncidentRestrictionResponse], error) {

	msg := req.Msg
	incident, err := h.svc.SetRestriction(ctx, application.SetRestrictionInput{
		IncidentID: msg.GetIncidentId(), Restricted: msg.GetRestricted(),
		Reason: msg.GetReason(), ExpectedVersion: msg.GetExpectedVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.SetIncidentRestrictionResponse{
		Incident: incidentToProto(incident),
	}), nil
}

func (h *Handler) GetTrends(ctx context.Context,
	req *connect.Request[qualityv1.GetTrendsRequest]) (
	*connect.Response[qualityv1.GetTrendsResponse], error) {

	trends, err := h.svc.Trends(ctx, timeOf(req.Msg.GetFrom()),
		timeOf(req.Msg.GetTo()))
	if err != nil {
		return nil, err
	}
	out := make([]*qualityv1.Trend, 0, len(trends))
	for _, trend := range trends {
		out = append(out, &qualityv1.Trend{
			Category: trend.Category, Count: int32(trend.Count),
			NearMisses: int32(trend.NearMisses),
			Harmful:    int32(trend.Harmful),
			WorstHarm:  harmToWire[trend.WorstHarm],
			Extreme:    int32(trend.Extreme),
		})
	}
	return connect.NewResponse(&qualityv1.GetTrendsResponse{Trends: out}), nil
}

func (h *Handler) StartRca(ctx context.Context,
	req *connect.Request[qualityv1.StartRcaRequest]) (
	*connect.Response[qualityv1.StartRcaResponse], error) {

	rca, err := h.svc.StartRCA(ctx, application.StartRCAInput{
		IncidentID: req.Msg.GetIncidentId(), Method: req.Msg.GetMethod(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.StartRcaResponse{
		Rca: rcaToProto(rca),
	}), nil
}

func (h *Handler) AddFactor(ctx context.Context,
	req *connect.Request[qualityv1.AddFactorRequest]) (
	*connect.Response[qualityv1.AddFactorResponse], error) {

	factor := req.Msg.GetFactor()
	rca, err := h.svc.AddFactor(ctx, req.Msg.GetRcaId(),
		domain.ContributingFactor{
			Category: factorFromWire[factor.GetCategory()],
			Detail:   factor.GetDetail(), Root: factor.GetRoot(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.AddFactorResponse{
		Rca: rcaToProto(rca),
	}), nil
}

func (h *Handler) CompleteRca(ctx context.Context,
	req *connect.Request[qualityv1.CompleteRcaRequest]) (
	*connect.Response[qualityv1.CompleteRcaResponse], error) {

	msg := req.Msg
	rca, err := h.svc.CompleteRCA(ctx, application.CompleteRCAInput{
		RCAID: msg.GetRcaId(), AccountableOwner: msg.GetAccountableOwner(),
		Findings: msg.GetFindings(), NoActionReason: msg.GetNoActionReason(),
		ExpectedVersion: msg.GetExpectedVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.CompleteRcaResponse{
		Rca: rcaToProto(rca),
	}), nil
}

func (h *Handler) GetRca(ctx context.Context,
	req *connect.Request[qualityv1.GetRcaRequest]) (
	*connect.Response[qualityv1.GetRcaResponse], error) {

	rca, err := h.svc.RCA(ctx, req.Msg.GetRcaId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.GetRcaResponse{
		Rca: rcaToProto(rca),
	}), nil
}

func (h *Handler) RaiseAction(ctx context.Context,
	req *connect.Request[qualityv1.RaiseActionRequest]) (
	*connect.Response[qualityv1.RaiseActionResponse], error) {

	msg := req.Msg
	action, err := h.svc.RaiseCAPA(ctx, domain.NewCAPAInput{
		Reference: msg.GetReference(), Kind: actionKindFromWire[msg.GetKind()],
		SourceKind: sourceFromWire[msg.GetSourceKind()],
		SourceID:   msg.GetSourceId(),
		Action:     msg.GetAction(), OwnerID: msg.GetOwnerId(),
		DueOn:              timeOf(msg.GetDueOn()),
		EffectivenessDueOn: timeOf(msg.GetEffectivenessDueOn()),
		Restricted:         msg.GetRestricted(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.RaiseActionResponse{
		Action: actionToProto(action),
	}), nil
}

func (h *Handler) ApproveAction(ctx context.Context,
	req *connect.Request[qualityv1.ApproveActionRequest]) (
	*connect.Response[qualityv1.ApproveActionResponse], error) {

	action, err := h.svc.ApproveCAPA(ctx, req.Msg.GetCapaId(),
		req.Msg.GetExpectedVersion())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.ApproveActionResponse{
		Action: actionToProto(action),
	}), nil
}

func (h *Handler) AdvanceAction(ctx context.Context,
	req *connect.Request[qualityv1.AdvanceActionRequest]) (
	*connect.Response[qualityv1.AdvanceActionResponse], error) {

	msg := req.Msg
	action, err := h.svc.AdvanceCAPA(ctx, msg.GetCapaId(),
		actionStateFromWire[msg.GetState()], msg.GetReason(),
		msg.GetExpectedVersion())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.AdvanceActionResponse{
		Action: actionToProto(action),
	}), nil
}

func (h *Handler) RecordEffectiveness(ctx context.Context,
	req *connect.Request[qualityv1.RecordEffectivenessRequest]) (
	*connect.Response[qualityv1.RecordEffectivenessResponse], error) {

	msg := req.Msg
	action, err := h.svc.RecordCheck(ctx, msg.GetCapaId(),
		domain.EffectivenessCheck{
			Effective: msg.GetEffective(), Evidence: msg.GetEvidence(),
		}, msg.GetExpectedVersion())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.RecordEffectivenessResponse{
		Action: actionToProto(action),
	}), nil
}

func (h *Handler) CloseAction(ctx context.Context,
	req *connect.Request[qualityv1.CloseActionRequest]) (
	*connect.Response[qualityv1.CloseActionResponse], error) {

	msg := req.Msg
	action, err := h.svc.CloseCAPA(ctx, msg.GetCapaId(), msg.GetNote(),
		msg.GetExpectedVersion())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.CloseActionResponse{
		Action: actionToProto(action),
	}), nil
}

func (h *Handler) GetAction(ctx context.Context,
	req *connect.Request[qualityv1.GetActionRequest]) (
	*connect.Response[qualityv1.GetActionResponse], error) {

	action, err := h.svc.CAPA(ctx, req.Msg.GetCapaId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.GetActionResponse{
		Action: actionToProto(action),
	}), nil
}

func (h *Handler) ListActions(ctx context.Context,
	req *connect.Request[qualityv1.ListActionsRequest]) (
	*connect.Response[qualityv1.ListActionsResponse], error) {

	msg := req.Msg
	actions, err := h.svc.CAPAs(ctx, ports.CAPAFilter{
		SourceKind: string(sourceFromWire[msg.GetSourceKind()]),
		SourceID:   msg.GetSourceId(), OwnerID: msg.GetOwnerId(),
		LiveOnly: msg.GetLiveOnly(), Limit: msg.GetPageSize(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*qualityv1.CorrectiveAction, 0, len(actions))
	for _, action := range actions {
		out = append(out, actionToProto(action))
	}
	return connect.NewResponse(&qualityv1.ListActionsResponse{
		Actions: out,
	}), nil
}

func (h *Handler) ListOverdueActions(ctx context.Context,
	_ *connect.Request[qualityv1.ListOverdueActionsRequest]) (
	*connect.Response[qualityv1.ListOverdueActionsResponse], error) {

	overdue, err := h.svc.OverdueActions(ctx)
	if err != nil {
		return nil, err
	}
	out := make([]*qualityv1.OverdueAction, 0, len(overdue))
	for _, line := range overdue {
		out = append(out, &qualityv1.OverdueAction{
			Action:            actionToProto(line.CAPA),
			ActionOverdueDays: int32(line.ActionOverdueDays),
			CheckOverdueDays:  int32(line.CheckOverdueDays),
		})
	}
	return connect.NewResponse(&qualityv1.ListOverdueActionsResponse{
		Overdue: out,
	}), nil
}

func (h *Handler) EscalateOverdueActions(ctx context.Context,
	_ *connect.Request[qualityv1.EscalateOverdueActionsRequest]) (
	*connect.Response[qualityv1.EscalateOverdueActionsResponse], error) {

	raised, err := h.svc.EscalateOverdue(ctx)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.EscalateOverdueActionsResponse{
		Raised: int32(raised),
	}), nil
}

func (h *Handler) RegisterDocument(ctx context.Context,
	req *connect.Request[qualityv1.RegisterDocumentRequest]) (
	*connect.Response[qualityv1.RegisterDocumentResponse], error) {

	msg := req.Msg
	document, err := h.svc.RegisterDocument(ctx, domain.NewDocumentInput{
		Code: msg.GetCode(), Title: msg.GetTitle(),
		Kind: documentKindFromWire[msg.GetKind()], OwnerID: msg.GetOwnerId(),
		ReviewMonths: int(msg.GetReviewMonths()),
		Department:   msg.GetDepartment(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.RegisterDocumentResponse{
		Document: documentToProto(document),
	}), nil
}

func (h *Handler) DraftVersion(ctx context.Context,
	req *connect.Request[qualityv1.DraftVersionRequest]) (
	*connect.Response[qualityv1.DraftVersionResponse], error) {

	msg := req.Msg
	version, err := h.svc.DraftVersion(ctx, domain.NewVersionInput{
		DocumentID: msg.GetDocumentId(), Label: msg.GetLabel(),
		ContentRef:              msg.GetContentRef(),
		ChangeSummary:           msg.GetChangeSummary(),
		RequiresAcknowledgement: msg.GetRequiresAcknowledgement(),
		RequiresRetraining:      msg.GetRequiresRetraining(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.DraftVersionResponse{
		Version: versionToProto(version),
	}), nil
}

func (h *Handler) ApproveVersion(ctx context.Context,
	req *connect.Request[qualityv1.ApproveVersionRequest]) (
	*connect.Response[qualityv1.ApproveVersionResponse], error) {

	msg := req.Msg
	version, err := h.svc.ApproveVersion(ctx, application.ApproveVersionInput{
		VersionID:       msg.GetVersionId(),
		EffectiveFrom:   timeOf(msg.GetEffectiveFrom()),
		ExpectedVersion: msg.GetExpectedVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.ApproveVersionResponse{
		Version: versionToProto(version),
	}), nil
}

func (h *Handler) GetCurrentVersion(ctx context.Context,
	req *connect.Request[qualityv1.GetCurrentVersionRequest]) (
	*connect.Response[qualityv1.GetCurrentVersionResponse], error) {

	version, found, err := h.svc.CurrentVersion(ctx, req.Msg.GetDocumentId())
	if err != nil {
		return nil, err
	}
	out := &qualityv1.GetCurrentVersionResponse{Found: found}
	if found {
		out.Version = versionToProto(version)
	}
	return connect.NewResponse(out), nil
}

func (h *Handler) ListVersions(ctx context.Context,
	req *connect.Request[qualityv1.ListVersionsRequest]) (
	*connect.Response[qualityv1.ListVersionsResponse], error) {

	versions, err := h.svc.Versions(ctx, req.Msg.GetDocumentId())
	if err != nil {
		return nil, err
	}
	out := make([]*qualityv1.DocumentVersion, 0, len(versions))
	for _, version := range versions {
		out = append(out, versionToProto(version))
	}
	return connect.NewResponse(&qualityv1.ListVersionsResponse{
		Versions: out,
	}), nil
}

func (h *Handler) ListDocuments(ctx context.Context,
	req *connect.Request[qualityv1.ListDocumentsRequest]) (
	*connect.Response[qualityv1.ListDocumentsResponse], error) {

	msg := req.Msg
	documents, err := h.svc.Documents(ctx, ports.DocumentFilter{
		Kind:             string(documentKindFromWire[msg.GetKind()]),
		Department:       msg.GetDepartment(),
		ExcludeWithdrawn: msg.GetExcludeWithdrawn(),
		Limit:            msg.GetPageSize(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*qualityv1.ControlledDocument, 0, len(documents))
	for _, document := range documents {
		out = append(out, documentToProto(document))
	}
	return connect.NewResponse(&qualityv1.ListDocumentsResponse{
		Documents: out,
	}), nil
}

func (h *Handler) AcknowledgeDocument(ctx context.Context,
	req *connect.Request[qualityv1.AcknowledgeDocumentRequest]) (
	*connect.Response[qualityv1.AcknowledgeDocumentResponse], error) {

	ack, err := h.svc.Acknowledge(ctx, req.Msg.GetDocumentId(),
		req.Msg.GetRole())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.AcknowledgeDocumentResponse{
		AcknowledgementId: ack.ID, VersionId: ack.VersionID,
		AcknowledgedAt: stamp(ack.AcknowledgedAt),
	}), nil
}

func (h *Handler) ListOutstandingAcknowledgements(ctx context.Context,
	req *connect.Request[qualityv1.ListOutstandingAcknowledgementsRequest]) (
	*connect.Response[qualityv1.ListOutstandingAcknowledgementsResponse], error) {

	gaps, err := h.svc.OutstandingAcknowledgements(ctx,
		req.Msg.GetDocumentId())
	if err != nil {
		return nil, err
	}
	out := make([]*qualityv1.AcknowledgementGap, 0, len(gaps))
	for _, gap := range gaps {
		out = append(out, &qualityv1.AcknowledgementGap{
			DocumentId: gap.DocumentID, VersionId: gap.VersionID,
			Code: gap.Code, PersonId: gap.PersonID, Role: gap.Role,
		})
	}
	sortGaps(out)
	return connect.NewResponse(
		&qualityv1.ListOutstandingAcknowledgementsResponse{Gaps: out}), nil
}

func (h *Handler) ListReviewsDue(ctx context.Context,
	_ *connect.Request[qualityv1.ListReviewsDueRequest]) (
	*connect.Response[qualityv1.ListReviewsDueResponse], error) {

	due, err := h.svc.ReviewsDue(ctx)
	if err != nil {
		return nil, err
	}
	out := make([]*qualityv1.ReviewDue, 0, len(due))
	for _, line := range due {
		out = append(out, &qualityv1.ReviewDue{
			DocumentId: line.DocumentID, Code: line.Code,
			Title: line.Title, OwnerId: line.OwnerID,
			LastEffective:      stamp(line.LastEffective),
			DueOn:              stamp(line.DueOn),
			DaysOverdue:        int32(line.DaysOverdue),
			NoEffectiveVersion: line.NoEffectiveVersion,
			NoReviewInterval:   line.NoReviewInterval,
		})
	}
	return connect.NewResponse(&qualityv1.ListReviewsDueResponse{
		Due: out,
	}), nil
}

func (h *Handler) DefineCompetency(ctx context.Context,
	req *connect.Request[qualityv1.DefineCompetencyRequest]) (
	*connect.Response[qualityv1.DefineCompetencyResponse], error) {

	msg := req.Msg
	competency, err := h.svc.DefineCompetency(ctx, msg.GetCode(),
		msg.GetName(), msg.GetDocumentId(), int(msg.GetValidMonths()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.DefineCompetencyResponse{
		Competency: &qualityv1.Competency{
			CompetencyId: competency.ID, Code: competency.Code,
			Name: competency.Name, DocumentId: competency.DocumentID,
			ValidMonths: int32(competency.ValidMonths),
			Active:      competency.Active,
		},
	}), nil
}

func (h *Handler) RequireCompetency(ctx context.Context,
	req *connect.Request[qualityv1.RequireCompetencyRequest]) (
	*connect.Response[qualityv1.RequireCompetencyResponse], error) {

	if err := h.svc.RequireCompetency(ctx, req.Msg.GetRole(),
		req.Msg.GetCompetencyId()); err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.RequireCompetencyResponse{}), nil
}

func (h *Handler) AwardCompetency(ctx context.Context,
	req *connect.Request[qualityv1.AwardCompetencyRequest]) (
	*connect.Response[qualityv1.AwardCompetencyResponse], error) {

	msg := req.Msg
	award, err := h.svc.AwardCompetency(ctx, application.AwardInput{
		CompetencyID: msg.GetCompetencyId(), PersonID: msg.GetPersonId(),
		VersionID: msg.GetVersionId(), Evidence: msg.GetEvidence(),
		AwardedAt: timeOf(msg.GetAwardedAt()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.AwardCompetencyResponse{
		AwardId: award.ID, ExpiresAt: stamp(award.ExpiresAt),
	}), nil
}

func (h *Handler) ListCompetencyGaps(ctx context.Context,
	_ *connect.Request[qualityv1.ListCompetencyGapsRequest]) (
	*connect.Response[qualityv1.ListCompetencyGapsResponse], error) {

	gaps, err := h.svc.CompetencyGaps(ctx)
	if err != nil {
		return nil, err
	}
	out := make([]*qualityv1.CompetencyGap, 0, len(gaps))
	for _, gap := range gaps {
		out = append(out, &qualityv1.CompetencyGap{
			PersonId: gap.PersonID, Role: gap.Role,
			CompetencyId: gap.CompetencyID, Code: gap.Code,
			Reason: gap.Reason,
		})
	}
	return connect.NewResponse(&qualityv1.ListCompetencyGapsResponse{
		Gaps: out,
	}), nil
}

func (h *Handler) PlanAudit(ctx context.Context,
	req *connect.Request[qualityv1.PlanAuditRequest]) (
	*connect.Response[qualityv1.PlanAuditResponse], error) {

	msg := req.Msg
	plan, err := h.svc.PlanAudit(ctx, domain.NewAuditInput{
		Reference: msg.GetReference(), Title: msg.GetTitle(),
		Scope: msg.GetScope(), StandardID: msg.GetStandardId(),
		AuditorID:         msg.GetAuditorId(),
		AuditeeDepartment: msg.GetAuditeeDepartment(),
		PlannedFrom:       timeOf(msg.GetPlannedFrom()),
		PlannedTo:         timeOf(msg.GetPlannedTo()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.PlanAuditResponse{
		Audit: auditToProto(plan),
	}), nil
}

func (h *Handler) RecordFinding(ctx context.Context,
	req *connect.Request[qualityv1.RecordFindingRequest]) (
	*connect.Response[qualityv1.RecordFindingResponse], error) {

	msg := req.Msg
	finding, err := h.svc.RecordFinding(ctx, domain.NewFindingInput{
		AuditID: msg.GetAuditId(), ClauseID: msg.GetClauseId(),
		Severity: severityFromWire[msg.GetSeverity()],
		Detail:   msg.GetDetail(), Evidence: msg.GetEvidence(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.RecordFindingResponse{
		Finding: findingToProto(finding),
	}), nil
}

func (h *Handler) LinkFindingAction(ctx context.Context,
	req *connect.Request[qualityv1.LinkFindingActionRequest]) (
	*connect.Response[qualityv1.LinkFindingActionResponse], error) {

	finding, err := h.svc.LinkFindingAction(ctx, req.Msg.GetFindingId(),
		req.Msg.GetCapaId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.LinkFindingActionResponse{
		Finding: findingToProto(finding),
	}), nil
}

func (h *Handler) CloseFinding(ctx context.Context,
	req *connect.Request[qualityv1.CloseFindingRequest]) (
	*connect.Response[qualityv1.CloseFindingResponse], error) {

	finding, err := h.svc.CloseFinding(ctx, req.Msg.GetFindingId(),
		req.Msg.GetNote())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.CloseFindingResponse{
		Finding: findingToProto(finding),
	}), nil
}

func (h *Handler) ReportAudit(ctx context.Context,
	req *connect.Request[qualityv1.ReportAuditRequest]) (
	*connect.Response[qualityv1.ReportAuditResponse], error) {

	msg := req.Msg
	plan, err := h.svc.ReportAudit(ctx, msg.GetAuditId(), msg.GetSummary(),
		msg.GetExpectedVersion())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.ReportAuditResponse{
		Audit: auditToProto(plan),
	}), nil
}

func (h *Handler) CloseAudit(ctx context.Context,
	req *connect.Request[qualityv1.CloseAuditRequest]) (
	*connect.Response[qualityv1.CloseAuditResponse], error) {

	plan, err := h.svc.CloseAudit(ctx, req.Msg.GetAuditId(),
		req.Msg.GetExpectedVersion())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.CloseAuditResponse{
		Audit: auditToProto(plan),
	}), nil
}

func (h *Handler) GetAudit(ctx context.Context,
	req *connect.Request[qualityv1.GetAuditRequest]) (
	*connect.Response[qualityv1.GetAuditResponse], error) {

	plan, err := h.svc.Audit(ctx, req.Msg.GetAuditId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.GetAuditResponse{
		Audit: auditToProto(plan),
	}), nil
}

func (h *Handler) ListAudits(ctx context.Context,
	req *connect.Request[qualityv1.ListAuditsRequest]) (
	*connect.Response[qualityv1.ListAuditsResponse], error) {

	plans, err := h.svc.Audits(ctx,
		string(auditStateFromWire[req.Msg.GetState()]),
		req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	out := make([]*qualityv1.Audit, 0, len(plans))
	for _, plan := range plans {
		out = append(out, auditToProto(plan))
	}
	return connect.NewResponse(&qualityv1.ListAuditsResponse{Audits: out}), nil
}

func (h *Handler) ListFindings(ctx context.Context,
	req *connect.Request[qualityv1.ListFindingsRequest]) (
	*connect.Response[qualityv1.ListFindingsResponse], error) {

	findings, err := h.svc.Findings(ctx, req.Msg.GetAuditId(),
		req.Msg.GetOpenOnly())
	if err != nil {
		return nil, err
	}
	out := make([]*qualityv1.Finding, 0, len(findings))
	for _, finding := range findings {
		out = append(out, findingToProto(finding))
	}
	return connect.NewResponse(&qualityv1.ListFindingsResponse{
		Findings: out,
	}), nil
}

func (h *Handler) FormCommittee(ctx context.Context,
	req *connect.Request[qualityv1.FormCommitteeRequest]) (
	*connect.Response[qualityv1.FormCommitteeResponse], error) {

	msg := req.Msg
	committee, err := h.svc.FormCommittee(ctx, application.FormCommitteeInput{
		Code: msg.GetCode(), Name: msg.GetName(), Terms: msg.GetTerms(),
		QuorumSize: int(msg.GetQuorumSize()), Restricted: msg.GetRestricted(),
		Members: msg.GetMembers(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.FormCommitteeResponse{
		Committee: committeeToProto(committee),
	}), nil
}

func (h *Handler) ScheduleMeeting(ctx context.Context,
	req *connect.Request[qualityv1.ScheduleMeetingRequest]) (
	*connect.Response[qualityv1.ScheduleMeetingResponse], error) {

	msg := req.Msg
	meeting, err := h.svc.ScheduleMeeting(ctx, msg.GetCommitteeId(),
		timeOf(msg.GetScheduledAt()), msg.GetAgenda())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.ScheduleMeetingResponse{
		Meeting: meetingToProto(meeting),
	}), nil
}

func (h *Handler) RecordMinutes(ctx context.Context,
	req *connect.Request[qualityv1.RecordMinutesRequest]) (
	*connect.Response[qualityv1.RecordMinutesResponse], error) {

	msg := req.Msg
	meeting, err := h.svc.RecordMinutes(ctx, application.RecordMinutesInput{
		MeetingID: msg.GetMeetingId(), HeldAt: timeOf(msg.GetHeldAt()),
		Attendees: msg.GetAttendees(), Apologies: msg.GetApologies(),
		Minutes:         msg.GetMinutes(),
		Decisions:       decisionsFromProto(msg.GetDecisions()),
		Approve:         msg.GetApprove(),
		ExpectedVersion: msg.GetExpectedVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.RecordMinutesResponse{
		Meeting: meetingToProto(meeting),
	}), nil
}

func (h *Handler) GetMeeting(ctx context.Context,
	req *connect.Request[qualityv1.GetMeetingRequest]) (
	*connect.Response[qualityv1.GetMeetingResponse], error) {

	meeting, err := h.svc.Meeting(ctx, req.Msg.GetMeetingId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.GetMeetingResponse{
		Meeting: meetingToProto(meeting),
	}), nil
}

func (h *Handler) ListCommittees(ctx context.Context,
	req *connect.Request[qualityv1.ListCommitteesRequest]) (
	*connect.Response[qualityv1.ListCommitteesResponse], error) {

	committees, err := h.svc.Committees(ctx, req.Msg.GetActiveOnly())
	if err != nil {
		return nil, err
	}
	out := make([]*qualityv1.Committee, 0, len(committees))
	for _, committee := range committees {
		out = append(out, committeeToProto(committee))
	}
	return connect.NewResponse(&qualityv1.ListCommitteesResponse{
		Committees: out,
	}), nil
}

func (h *Handler) LoadStandard(ctx context.Context,
	req *connect.Request[qualityv1.LoadStandardRequest]) (
	*connect.Response[qualityv1.LoadStandardResponse], error) {

	msg := req.Msg
	clauses := make([]application.ClauseInput, 0, len(msg.GetClauses()))
	for _, clause := range msg.GetClauses() {
		clauses = append(clauses, application.ClauseInput{
			Reference: clause.GetReference(), Chapter: clause.GetChapter(),
			Text: clause.GetText(), Critical: clause.GetCritical(),
		})
	}

	standard, loaded, err := h.svc.LoadStandard(ctx,
		application.LoadStandardInput{
			Code: msg.GetCode(), Name: msg.GetName(),
			Edition: msg.GetEdition(), Clauses: clauses,
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.LoadStandardResponse{
		Standard: &qualityv1.Standard{
			StandardId: standard.ID, Code: standard.Code,
			Name: standard.Name, Edition: standard.Edition,
			Active: standard.Active,
		},
		ClausesLoaded: int32(loaded),
	}), nil
}

func (h *Handler) FileEvidence(ctx context.Context,
	req *connect.Request[qualityv1.FileEvidenceRequest]) (
	*connect.Response[qualityv1.FileEvidenceResponse], error) {

	msg := req.Msg
	evidence, err := h.svc.FileEvidence(ctx, application.EvidenceInput{
		ClauseID: msg.GetClauseId(),
		Kind:     evidenceKindFromWire[msg.GetKind()],
		RefID:    msg.GetRefId(), ExternalRef: msg.GetExternalRef(),
		Description: msg.GetDescription(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.FileEvidenceResponse{
		Evidence: evidenceToProto(evidence),
	}), nil
}

func (h *Handler) WithdrawEvidence(ctx context.Context,
	req *connect.Request[qualityv1.WithdrawEvidenceRequest]) (
	*connect.Response[qualityv1.WithdrawEvidenceResponse], error) {

	if err := h.svc.WithdrawEvidence(ctx, req.Msg.GetEvidenceId(),
		req.Msg.GetReason()); err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.WithdrawEvidenceResponse{}), nil
}

func (h *Handler) ReviewClause(ctx context.Context,
	req *connect.Request[qualityv1.ReviewClauseRequest]) (
	*connect.Response[qualityv1.ReviewClauseResponse], error) {

	msg := req.Msg
	review, err := h.svc.ReviewClause(ctx, application.ReviewClauseInput{
		StandardID: msg.GetStandardId(), ClauseID: msg.GetClauseId(),
		Verdict: verdictFromWire[msg.GetVerdict()], Note: msg.GetNote(),
		CAPAID: msg.GetCapaId(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.ReviewClauseResponse{
		ReviewId: review.ID, Verdict: verdictToWire[review.Verdict],
		ReviewedAt: stamp(review.ReviewedAt),
	}), nil
}

func (h *Handler) GetReadiness(ctx context.Context,
	req *connect.Request[qualityv1.GetReadinessRequest]) (
	*connect.Response[qualityv1.GetReadinessResponse], error) {

	readiness, err := h.svc.Readiness(ctx, req.Msg.GetStandardId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(readinessToProto(readiness)), nil
}

func (h *Handler) ListStandards(ctx context.Context,
	req *connect.Request[qualityv1.ListStandardsRequest]) (
	*connect.Response[qualityv1.ListStandardsResponse], error) {

	standards, err := h.svc.Standards(ctx, req.Msg.GetActiveOnly())
	if err != nil {
		return nil, err
	}
	out := make([]*qualityv1.Standard, 0, len(standards))
	for _, standard := range standards {
		out = append(out, &qualityv1.Standard{
			StandardId: standard.ID, Code: standard.Code,
			Name: standard.Name, Edition: standard.Edition,
			Active: standard.Active,
		})
	}
	return connect.NewResponse(&qualityv1.ListStandardsResponse{
		Standards: out,
	}), nil
}

func (h *Handler) ListClauses(ctx context.Context,
	req *connect.Request[qualityv1.ListClausesRequest]) (
	*connect.Response[qualityv1.ListClausesResponse], error) {

	clauses, err := h.svc.Clauses(ctx, req.Msg.GetStandardId())
	if err != nil {
		return nil, err
	}
	out := make([]*qualityv1.Clause, 0, len(clauses))
	for _, clause := range clauses {
		out = append(out, &qualityv1.Clause{
			ClauseId: clause.ID, StandardId: clause.StandardID,
			Reference: clause.Reference, Chapter: clause.Chapter,
			Text: clause.Text, Critical: clause.Critical,
		})
	}
	return connect.NewResponse(&qualityv1.ListClausesResponse{
		Clauses: out,
	}), nil
}

func (h *Handler) DefineIndicator(ctx context.Context,
	req *connect.Request[qualityv1.DefineIndicatorRequest]) (
	*connect.Response[qualityv1.DefineIndicatorResponse], error) {

	msg := req.Msg
	definition, err := h.svc.DefineIndicator(ctx, domain.NewKPIInput{
		Code: msg.GetCode(), Name: msg.GetName(),
		Numerator: msg.GetNumerator(), Denominator: msg.GetDenominator(),
		Unit: msg.GetUnit(), TargetPermille: int(msg.GetTargetPermille()),
		Direction:     directionFromWire[msg.GetDirection()],
		Frequency:     frequencyFromWire[msg.GetFrequency()],
		OwnerID:       msg.GetOwnerId(),
		EffectiveFrom: timeOf(msg.GetEffectiveFrom()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.DefineIndicatorResponse{
		Definition: definitionToProto(definition),
	}), nil
}

func (h *Handler) RecordIndicatorValue(ctx context.Context,
	req *connect.Request[qualityv1.RecordIndicatorValueRequest]) (
	*connect.Response[qualityv1.RecordIndicatorValueResponse], error) {

	msg := req.Msg
	value, err := h.svc.RecordIndicator(ctx, application.RecordIndicatorInput{
		Code:       msg.GetCode(),
		PeriodFrom: timeOf(msg.GetPeriodFrom()),
		PeriodTo:   timeOf(msg.GetPeriodTo()),
		Numerator:  msg.GetNumerator(), Denominator: msg.GetDenominator(),
		SourceNote: msg.GetSourceNote(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.RecordIndicatorValueResponse{
		Value: valueToProto(value),
	}), nil
}

func (h *Handler) GetDashboard(ctx context.Context,
	req *connect.Request[qualityv1.GetDashboardRequest]) (
	*connect.Response[qualityv1.GetDashboardResponse], error) {

	lines, err := h.svc.Dashboard(ctx, timeOf(req.Msg.GetFrom()),
		timeOf(req.Msg.GetTo()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.GetDashboardResponse{
		Lines: dashboardToProto(lines),
	}), nil
}

func (h *Handler) ListIndicatorValues(ctx context.Context,
	req *connect.Request[qualityv1.ListIndicatorValuesRequest]) (
	*connect.Response[qualityv1.ListIndicatorValuesResponse], error) {

	values, err := h.svc.IndicatorValues(ctx, req.Msg.GetCode(),
		timeOf(req.Msg.GetFrom()), timeOf(req.Msg.GetTo()))
	if err != nil {
		return nil, err
	}
	out := make([]*qualityv1.IndicatorValue, 0, len(values))
	for _, value := range values {
		out = append(out, valueToProto(value))
	}
	return connect.NewResponse(&qualityv1.ListIndicatorValuesResponse{
		Values: out,
	}), nil
}

func (h *Handler) ReceiveComplaint(ctx context.Context,
	req *connect.Request[qualityv1.ReceiveComplaintRequest]) (
	*connect.Response[qualityv1.ReceiveComplaintResponse], error) {

	msg := req.Msg
	complaint, err := h.svc.ReceiveComplaint(ctx, domain.NewComplaintInput{
		Reference:      msg.GetReference(),
		Kind:           complainantFromWire[msg.GetKind()],
		ComplainantRef: msg.GetComplainantRef(),
		PatientID:      msg.GetPatientId(),
		EncounterID:    msg.GetEncounterId(),
		Category:       msg.GetCategory(), Department: msg.GetDepartment(),
		FacilityID: msg.GetFacilityId(), Channel: msg.GetChannel(),
		Detail: msg.GetDetail(), ReceivedAt: timeOf(msg.GetReceivedAt()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.ReceiveComplaintResponse{
		Complaint: complaintToProto(complaint),
	}), nil
}

func (h *Handler) AcknowledgeComplaint(ctx context.Context,
	req *connect.Request[qualityv1.AcknowledgeComplaintRequest]) (
	*connect.Response[qualityv1.AcknowledgeComplaintResponse], error) {

	complaint, err := h.svc.AcknowledgeComplaint(ctx,
		req.Msg.GetComplaintId(), req.Msg.GetExpectedVersion())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.AcknowledgeComplaintResponse{
		Complaint: complaintToProto(complaint),
	}), nil
}

func (h *Handler) ResolveComplaint(ctx context.Context,
	req *connect.Request[qualityv1.ResolveComplaintRequest]) (
	*connect.Response[qualityv1.ResolveComplaintResponse], error) {

	msg := req.Msg
	complaint, err := h.svc.ResolveComplaint(ctx,
		application.ResolveComplaintInput{
			ComplaintID:     msg.GetComplaintId(),
			Outcome:         outcomeFromWire[msg.GetOutcome()],
			Resolution:      msg.GetResolution(),
			ExpectedVersion: msg.GetExpectedVersion(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.ResolveComplaintResponse{
		Complaint: complaintToProto(complaint),
	}), nil
}

func (h *Handler) CloseComplaint(ctx context.Context,
	req *connect.Request[qualityv1.CloseComplaintRequest]) (
	*connect.Response[qualityv1.CloseComplaintResponse], error) {

	msg := req.Msg
	complaint, err := h.svc.CloseComplaint(ctx, msg.GetComplaintId(),
		msg.GetReason(), msg.GetExpectedVersion())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.CloseComplaintResponse{
		Complaint: complaintToProto(complaint),
	}), nil
}

func (h *Handler) GetComplaint(ctx context.Context,
	req *connect.Request[qualityv1.GetComplaintRequest]) (
	*connect.Response[qualityv1.GetComplaintResponse], error) {

	complaint, err := h.svc.Complaint(ctx, req.Msg.GetComplaintId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.GetComplaintResponse{
		Complaint: complaintToProto(complaint),
	}), nil
}

func (h *Handler) ListComplaints(ctx context.Context,
	req *connect.Request[qualityv1.ListComplaintsRequest]) (
	*connect.Response[qualityv1.ListComplaintsResponse], error) {

	msg := req.Msg
	complaints, err := h.svc.Complaints(ctx, msg.GetCategory(),
		msg.GetOpenOnly(), msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	out := make([]*qualityv1.Complaint, 0, len(complaints))
	for _, complaint := range complaints {
		out = append(out, complaintToProto(complaint))
	}
	return connect.NewResponse(&qualityv1.ListComplaintsResponse{
		Complaints: out,
	}), nil
}

func (h *Handler) ListComplaintBreaches(ctx context.Context,
	_ *connect.Request[qualityv1.ListComplaintBreachesRequest]) (
	*connect.Response[qualityv1.ListComplaintBreachesResponse], error) {

	breaches, err := h.svc.ComplaintBreaches(ctx)
	if err != nil {
		return nil, err
	}
	out := make([]*qualityv1.ComplaintBreach, 0, len(breaches))
	for _, breach := range breaches {
		out = append(out, &qualityv1.ComplaintBreach{
			Complaint:               complaintToProto(breach.Complaint),
			AcknowledgementBreached: breach.Acknowledgement,
			ResolutionBreached:      breach.Resolution,
		})
	}
	return connect.NewResponse(&qualityv1.ListComplaintBreachesResponse{
		Breaches: out,
	}), nil
}

func (h *Handler) EscalateComplaintBreaches(ctx context.Context,
	_ *connect.Request[qualityv1.EscalateComplaintBreachesRequest]) (
	*connect.Response[qualityv1.EscalateComplaintBreachesResponse], error) {

	raised, err := h.svc.EscalateComplaintBreaches(ctx)
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.EscalateComplaintBreachesResponse{
		Raised: int32(raised),
	}), nil
}

func (h *Handler) StartMortalityReview(ctx context.Context,
	req *connect.Request[qualityv1.StartMortalityReviewRequest]) (
	*connect.Response[qualityv1.StartMortalityReviewResponse], error) {

	msg := req.Msg
	review, err := h.svc.StartMortalityReview(ctx,
		application.StartMortalityReviewInput{
			PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
			CommitteeID: msg.GetCommitteeId(),
			DiedAt:      timeOf(msg.GetDiedAt()),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.StartMortalityReviewResponse{
		Review: mortalityToProto(review),
	}), nil
}

func (h *Handler) CompleteMortalityReview(ctx context.Context,
	req *connect.Request[qualityv1.CompleteMortalityReviewRequest]) (
	*connect.Response[qualityv1.CompleteMortalityReviewResponse], error) {

	msg := req.Msg
	review, err := h.svc.CompleteMortalityReview(ctx,
		application.CompleteMortalityReviewInput{
			ReviewID: msg.GetReviewId(), MeetingID: msg.GetMeetingId(),
			Classification:  deathFromWire[msg.GetClassification()],
			Findings:        msg.GetFindings(),
			LearningPoints:  msg.GetLearningPoints(),
			ActionIDs:       msg.GetActionIds(),
			ExpectedVersion: msg.GetExpectedVersion(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.CompleteMortalityReviewResponse{
		Review: mortalityToProto(review),
	}), nil
}

func (h *Handler) GetMortalityReview(ctx context.Context,
	req *connect.Request[qualityv1.GetMortalityReviewRequest]) (
	*connect.Response[qualityv1.GetMortalityReviewResponse], error) {

	review, err := h.svc.MortalityReview(ctx, req.Msg.GetReviewId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.GetMortalityReviewResponse{
		Review: mortalityToProto(review),
	}), nil
}

func (h *Handler) ListMortalityReviews(ctx context.Context,
	req *connect.Request[qualityv1.ListMortalityReviewsRequest]) (
	*connect.Response[qualityv1.ListMortalityReviewsResponse], error) {

	msg := req.Msg
	reviews, err := h.svc.MortalityReviews(ctx, msg.GetOpenOnly(),
		timeOf(msg.GetFrom()), timeOf(msg.GetTo()), msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	out := make([]*qualityv1.MortalityReview, 0, len(reviews))
	for _, review := range reviews {
		out = append(out, mortalityToProto(review))
	}
	return connect.NewResponse(&qualityv1.ListMortalityReviewsResponse{
		Reviews: out,
	}), nil
}

func (h *Handler) PlaceHold(ctx context.Context,
	req *connect.Request[qualityv1.PlaceHoldRequest]) (
	*connect.Response[qualityv1.PlaceHoldResponse], error) {

	msg := req.Msg
	if err := h.svc.PlaceHold(ctx, application.PlaceHoldInput{
		RecordClass: msg.GetRecordClass(), RecordID: msg.GetRecordId(),
		Reason: msg.GetReason(),
	}); err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.PlaceHoldResponse{}), nil
}

func (h *Handler) ReleaseHold(ctx context.Context,
	req *connect.Request[qualityv1.ReleaseHoldRequest]) (
	*connect.Response[qualityv1.ReleaseHoldResponse], error) {

	msg := req.Msg
	if err := h.svc.ReleaseHold(ctx, msg.GetRecordClass(),
		msg.GetRecordId(), msg.GetReason()); err != nil {
		return nil, err
	}
	return connect.NewResponse(&qualityv1.ReleaseHoldResponse{}), nil
}
