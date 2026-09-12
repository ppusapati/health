package transport

import (
	"context"

	"connectrpc.com/connect"
	encounterv1 "github.com/ppusapati/health/code/gen/go/healthcare/encounter/v1"
	"github.com/ppusapati/health/code/internal/encounter/application"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
)

// Handler serves healthcare.encounter.v1.EncounterService.
type Handler struct {
	svc *application.Service
}

// NewHandler constructs the handler.
func NewHandler(svc *application.Service) *Handler { return &Handler{svc: svc} }

func fail(ctx context.Context, err error) error {
	return platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
}

// OpenEncounter implements SRS-ENC-001, SRS-ENC-002 and SRS-ENC-003.
func (h *Handler) OpenEncounter(
	ctx context.Context,
	req *connect.Request[encounterv1.OpenEncounterRequest],
) (*connect.Response[encounterv1.OpenEncounterResponse], error) {
	msg := req.Msg

	encounter, err := h.svc.OpenEncounter(ctx, application.OpenEncounterInput{
		PatientID: msg.GetPatientId(), FacilityID: msg.GetFacilityId(),
		OrgUnitID: msg.GetOrgUnitId(), Class: classFromProto[msg.GetClass()],
		VisitType:           msg.GetVisitType(),
		AttendingProviderID: msg.GetAttendingProviderId(),
		AppointmentID:       msg.GetAppointmentId(), EpisodeID: msg.GetEpisodeId(),
		ReferralID: msg.GetReferralId(), Reason: msg.GetReason(),
		StartImmediately: msg.GetStartImmediately(),
		StartedAt:        fromTimestamp(msg.GetStartedAt()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&encounterv1.OpenEncounterResponse{
		Encounter: encounterToProto(encounter),
	}), nil
}

// StartEncounter implements SRS-ENC-003.
func (h *Handler) StartEncounter(
	ctx context.Context,
	req *connect.Request[encounterv1.StartEncounterRequest],
) (*connect.Response[encounterv1.StartEncounterResponse], error) {
	encounter, err := h.svc.StartEncounter(ctx, application.StartEncounterInput{
		EncounterID: req.Msg.GetEncounterId(),
		StartedAt:   fromTimestamp(req.Msg.GetStartedAt()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&encounterv1.StartEncounterResponse{
		Encounter: encounterToProto(encounter),
	}), nil
}

// EndEncounter implements SRS-ENC-003.
func (h *Handler) EndEncounter(
	ctx context.Context,
	req *connect.Request[encounterv1.EndEncounterRequest],
) (*connect.Response[encounterv1.EndEncounterResponse], error) {
	encounter, err := h.svc.EndEncounter(ctx, application.EndEncounterInput{
		EncounterID: req.Msg.GetEncounterId(),
		EndedAt:     fromTimestamp(req.Msg.GetEndedAt()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&encounterv1.EndEncounterResponse{
		Encounter: encounterToProto(encounter),
	}), nil
}

// CancelEncounter implements SRS-ENC-006.
func (h *Handler) CancelEncounter(
	ctx context.Context,
	req *connect.Request[encounterv1.CancelEncounterRequest],
) (*connect.Response[encounterv1.CancelEncounterResponse], error) {
	encounter, err := h.svc.CancelEncounter(ctx, application.CancelEncounterInput{
		EncounterID: req.Msg.GetEncounterId(), Reason: req.Msg.GetReason(),
		EnteredInError: req.Msg.GetEnteredInError(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&encounterv1.CancelEncounterResponse{
		Encounter: encounterToProto(encounter),
	}), nil
}

// ReopenEncounter implements SRS-ENC-006.
func (h *Handler) ReopenEncounter(
	ctx context.Context,
	req *connect.Request[encounterv1.ReopenEncounterRequest],
) (*connect.Response[encounterv1.ReopenEncounterResponse], error) {
	encounter, err := h.svc.ReopenEncounter(ctx, application.ReopenEncounterInput{
		EncounterID: req.Msg.GetEncounterId(), Reason: req.Msg.GetReason(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&encounterv1.ReopenEncounterResponse{
		Encounter: encounterToProto(encounter),
	}), nil
}

// SetEncounterLeave implements SRS-ENC-006.
func (h *Handler) SetEncounterLeave(
	ctx context.Context,
	req *connect.Request[encounterv1.SetEncounterLeaveRequest],
) (*connect.Response[encounterv1.SetEncounterLeaveResponse], error) {
	encounter, err := h.svc.SetEncounterLeave(ctx, application.SetEncounterLeaveInput{
		EncounterID: req.Msg.GetEncounterId(), Reason: req.Msg.GetReason(),
		Returning: req.Msg.GetReturning(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&encounterv1.SetEncounterLeaveResponse{
		Encounter: encounterToProto(encounter),
	}), nil
}

// GetEncounter reads one encounter with its status history.
func (h *Handler) GetEncounter(
	ctx context.Context,
	req *connect.Request[encounterv1.GetEncounterRequest],
) (*connect.Response[encounterv1.GetEncounterResponse], error) {
	encounter, err := h.svc.GetEncounter(ctx, req.Msg.GetEncounterId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&encounterv1.GetEncounterResponse{
		Encounter: encounterToProto(encounter),
	}), nil
}

// ListEncounters serves a patient's chronology and a facility's ward round.
func (h *Handler) ListEncounters(
	ctx context.Context,
	req *connect.Request[encounterv1.ListEncountersRequest],
) (*connect.Response[encounterv1.ListEncountersResponse], error) {
	msg := req.Msg

	encounters, err := h.svc.ListEncounters(ctx, application.ListEncountersInput{
		PatientID: msg.GetPatientId(), FacilityID: msg.GetFacilityId(),
		EpisodeID: msg.GetEpisodeId(), Class: classFromProto[msg.GetClass()],
		IncludeRetracted: msg.GetIncludeRetracted(), PageSize: msg.GetPageSize(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&encounterv1.ListEncountersResponse{
		Encounters: encountersToProto(encounters),
	}), nil
}

// OpenEpisode implements SRS-ENC-004.
func (h *Handler) OpenEpisode(
	ctx context.Context,
	req *connect.Request[encounterv1.OpenEpisodeRequest],
) (*connect.Response[encounterv1.OpenEpisodeResponse], error) {
	msg := req.Msg

	episode, err := h.svc.OpenEpisode(ctx, application.OpenEpisodeInput{
		PatientID: msg.GetPatientId(), FacilityID: msg.GetFacilityId(),
		Type: episodeTypeFromProto[msg.GetType()], Label: msg.GetLabel(),
		CareManagerID: msg.GetCareManagerId(),
		StartedAt:     fromTimestamp(msg.GetStartedAt()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&encounterv1.OpenEpisodeResponse{
		Episode: episodeToProto(episode),
	}), nil
}

// SetEpisodeStatus implements SRS-ENC-004.
func (h *Handler) SetEpisodeStatus(
	ctx context.Context,
	req *connect.Request[encounterv1.SetEpisodeStatusRequest],
) (*connect.Response[encounterv1.SetEpisodeStatusResponse], error) {
	episode, err := h.svc.SetEpisodeStatus(ctx, application.SetEpisodeStatusInput{
		EpisodeID: req.Msg.GetEpisodeId(),
		Status:    episodeStatusFromProto[req.Msg.GetStatus()],
		EndedAt:   fromTimestamp(req.Msg.GetEndedAt()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&encounterv1.SetEpisodeStatusResponse{
		Episode: episodeToProto(episode),
	}), nil
}

// ListEpisodes returns a patient's courses of care.
func (h *Handler) ListEpisodes(
	ctx context.Context,
	req *connect.Request[encounterv1.ListEpisodesRequest],
) (*connect.Response[encounterv1.ListEpisodesResponse], error) {
	episodes, err := h.svc.ListEpisodes(ctx, req.Msg.GetPatientId(),
		req.Msg.GetOpenOnly(), req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&encounterv1.ListEpisodesResponse{
		Episodes: episodesToProto(episodes),
	}), nil
}

// AssignCareTeamMember implements SRS-ENC-005.
func (h *Handler) AssignCareTeamMember(
	ctx context.Context,
	req *connect.Request[encounterv1.AssignCareTeamMemberRequest],
) (*connect.Response[encounterv1.AssignCareTeamMemberResponse], error) {
	msg := req.Msg

	member, err := h.svc.AssignCareTeamMember(ctx, application.AssignCareTeamInput{
		EncounterID: msg.GetEncounterId(), SubjectID: msg.GetSubjectId(),
		Role:  careTeamRoleFromProto[msg.GetRole()],
		From:  fromTimestamp(msg.GetEffectiveFrom()),
		Until: fromTimestamp(msg.GetEffectiveUntil()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&encounterv1.AssignCareTeamMemberResponse{
		Member: careTeamMemberToProto(member),
	}), nil
}

// EndCareTeamAssignment closes an involvement (SRS-ENC-005).
func (h *Handler) EndCareTeamAssignment(
	ctx context.Context,
	req *connect.Request[encounterv1.EndCareTeamAssignmentRequest],
) (*connect.Response[encounterv1.EndCareTeamAssignmentResponse], error) {
	if err := h.svc.EndCareTeamAssignment(ctx, req.Msg.GetCareTeamId(),
		fromTimestamp(req.Msg.GetEffectiveUntil())); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&encounterv1.EndCareTeamAssignmentResponse{}), nil
}

// GetCareTeam returns an encounter's assignments.
func (h *Handler) GetCareTeam(
	ctx context.Context,
	req *connect.Request[encounterv1.GetCareTeamRequest],
) (*connect.Response[encounterv1.GetCareTeamResponse], error) {
	team, err := h.svc.GetCareTeam(ctx, req.Msg.GetEncounterId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&encounterv1.GetCareTeamResponse{
		Members: careTeamToProto(team),
	}), nil
}

// RecordDiagnosis implements SRS-ENC-007.
func (h *Handler) RecordDiagnosis(
	ctx context.Context,
	req *connect.Request[encounterv1.RecordDiagnosisRequest],
) (*connect.Response[encounterv1.RecordDiagnosisResponse], error) {
	msg := req.Msg

	diagnosis, err := h.svc.RecordDiagnosis(ctx, application.RecordDiagnosisInput{
		EncounterID: msg.GetEncounterId(), Code: codingFromProto(msg.GetCode()),
		Certainty: certaintyFromProto[msg.GetCertainty()],
		Rank:      rankFromProto[msg.GetRank()], Note: msg.GetNote(),
		OnsetAt: fromTimestamp(msg.GetOnsetAt()), SupersedesID: msg.GetSupersedesId(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&encounterv1.RecordDiagnosisResponse{
		Diagnosis: diagnosisToProto(diagnosis),
	}), nil
}

// RetractDiagnosis implements SRS-ENC-007.
func (h *Handler) RetractDiagnosis(
	ctx context.Context,
	req *connect.Request[encounterv1.RetractDiagnosisRequest],
) (*connect.Response[encounterv1.RetractDiagnosisResponse], error) {
	if err := h.svc.RetractDiagnosis(ctx, application.RetractDiagnosisInput{
		DiagnosisID: req.Msg.GetDiagnosisId(), Reason: req.Msg.GetReason(),
	}); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&encounterv1.RetractDiagnosisResponse{}), nil
}

// ListDiagnoses returns an encounter's trail or a patient's live conditions.
func (h *Handler) ListDiagnoses(
	ctx context.Context,
	req *connect.Request[encounterv1.ListDiagnosesRequest],
) (*connect.Response[encounterv1.ListDiagnosesResponse], error) {
	diagnoses, err := h.svc.ListDiagnoses(ctx, application.ListDiagnosesInput{
		EncounterID: req.Msg.GetEncounterId(), PatientID: req.Msg.GetPatientId(),
		PageSize: req.Msg.GetPageSize(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&encounterv1.ListDiagnosesResponse{
		Diagnoses: diagnosesToProto(diagnoses),
	}), nil
}

// CloseEncounter implements SRS-ENC-008 and SRS-ENC-009.
func (h *Handler) CloseEncounter(
	ctx context.Context,
	req *connect.Request[encounterv1.CloseEncounterRequest],
) (*connect.Response[encounterv1.CloseEncounterResponse], error) {
	result, err := h.svc.CloseEncounter(ctx, application.CloseEncounterInput{
		EncounterID: req.Msg.GetEncounterId(), Narrative: req.Msg.GetNarrative(),
		OverrideReason: req.Msg.GetOverrideReason(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}

	missing := make([]string, 0, len(result.Missing))
	for _, item := range result.Missing {
		missing = append(missing, string(item))
	}
	return connect.NewResponse(&encounterv1.CloseEncounterResponse{
		Encounter:  encounterToProto(result.Encounter),
		Summary:    summaryToProto(result.Summary),
		Overridden: result.Overridden, MissingItems: missing,
	}), nil
}

// AmendSummary implements SRS-ENC-009.
func (h *Handler) AmendSummary(
	ctx context.Context,
	req *connect.Request[encounterv1.AmendSummaryRequest],
) (*connect.Response[encounterv1.AmendSummaryResponse], error) {
	summary, err := h.svc.AmendSummary(ctx, application.AmendSummaryInput{
		EncounterID: req.Msg.GetEncounterId(), Narrative: req.Msg.GetNarrative(),
		Reason: req.Msg.GetReason(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&encounterv1.AmendSummaryResponse{
		Summary: summaryToProto(summary),
	}), nil
}

// GetSummaries returns every version of an encounter's summary.
func (h *Handler) GetSummaries(
	ctx context.Context,
	req *connect.Request[encounterv1.GetSummariesRequest],
) (*connect.Response[encounterv1.GetSummariesResponse], error) {
	summaries, err := h.svc.GetSummaries(ctx, req.Msg.GetEncounterId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&encounterv1.GetSummariesResponse{
		Summaries: summariesToProto(summaries),
	}), nil
}

// SetClosurePolicy implements SRS-ENC-008.
func (h *Handler) SetClosurePolicy(
	ctx context.Context,
	req *connect.Request[encounterv1.SetClosurePolicyRequest],
) (*connect.Response[encounterv1.SetClosurePolicyResponse], error) {
	if err := h.svc.SetClosurePolicy(ctx, req.Msg.GetFacilityId(),
		closurePolicyFromProto(req.Msg.GetClasses())); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&encounterv1.SetClosurePolicyResponse{}), nil
}

// GetClosurePolicy returns the finalisation rules in force.
func (h *Handler) GetClosurePolicy(
	ctx context.Context,
	req *connect.Request[encounterv1.GetClosurePolicyRequest],
) (*connect.Response[encounterv1.GetClosurePolicyResponse], error) {
	policy, err := h.svc.GetClosurePolicy(ctx, req.Msg.GetFacilityId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&encounterv1.GetClosurePolicyResponse{
		Classes: closurePolicyToProto(policy),
	}), nil
}

// ListClosureOverrides implements the SRS-ENC-008 override report.
func (h *Handler) ListClosureOverrides(
	ctx context.Context,
	req *connect.Request[encounterv1.ListClosureOverridesRequest],
) (*connect.Response[encounterv1.ListClosureOverridesResponse], error) {
	overrides, err := h.svc.ListClosureOverrides(ctx, req.Msg.GetEncounterId(),
		req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&encounterv1.ListClosureOverridesResponse{
		Overrides: overridesToProto(overrides),
	}), nil
}

// GetTimeline implements SRS-ENC-011.
func (h *Handler) GetTimeline(
	ctx context.Context,
	req *connect.Request[encounterv1.GetTimelineRequest],
) (*connect.Response[encounterv1.GetTimelineResponse], error) {
	msg := req.Msg

	entries, err := h.svc.GetTimeline(ctx, application.GetTimelineInput{
		PatientID: msg.GetPatientId(),
		From:      fromTimestamp(msg.GetFrom()), Until: fromTimestamp(msg.GetUntil()),
		Kinds: entryKindsFromProto(msg.GetKinds()), PageSize: msg.GetPageSize(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&encounterv1.GetTimelineResponse{
		Entries: timelineToProto(entries),
	}), nil
}
