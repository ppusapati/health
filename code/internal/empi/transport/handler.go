package transport

import (
	"context"

	"connectrpc.com/connect"
	empiv1 "github.com/ppusapati/health/code/gen/go/healthcare/empi/v1"
	"github.com/ppusapati/health/code/internal/empi/application"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
)

// Handler serves healthcare.empi.v1.PatientService.
type Handler struct {
	svc *application.Service
}

// NewHandler constructs the handler.
func NewHandler(svc *application.Service) *Handler { return &Handler{svc: svc} }

// RegisterPatient implements SRS-EMPI-001.
func (h *Handler) RegisterPatient(
	ctx context.Context,
	req *connect.Request[empiv1.RegisterPatientRequest],
) (*connect.Response[empiv1.RegisterPatientResponse], error) {
	msg := req.Msg

	result, err := h.svc.RegisterPatient(ctx, application.RegisterPatientInput{
		Demographics:           demographicsFromProto(msg.GetDemographics()),
		Identifiers:            identifiersFromProto(msg.GetIdentifiers()),
		AcknowledgedDuplicates: msg.GetAcknowledgedDuplicatePatientIds(),
	})
	if err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}

	// Duplicates found: a successful response carrying what the caller must
	// review, and no patient. An error would discard the body, leaving the
	// client told to review candidates it cannot see.
	if result.Patient == nil {
		return connect.NewResponse(&empiv1.RegisterPatientResponse{
			PotentialDuplicates: matchesToProto(result.Duplicates),
		}), nil
	}

	return connect.NewResponse(&empiv1.RegisterPatientResponse{
		Patient: patientToProto(result.Patient, result.Identifiers),
	}), nil
}

// SearchPatients implements SRS-EMPI-003.
func (h *Handler) SearchPatients(
	ctx context.Context,
	req *connect.Request[empiv1.SearchPatientsRequest],
) (*connect.Response[empiv1.SearchPatientsResponse], error) {
	msg := req.Msg

	result, err := h.svc.SearchPatients(ctx, application.SearchPatientsInput{
		Name:             msg.GetName(),
		BirthDate:        partialDateFromProto(msg.GetBirthDate()),
		Phone:            msg.GetPhone(),
		IdentifierValue:  msg.GetIdentifierValue(),
		IdentifierType:   identifierTypeFromProto[msg.GetIdentifierType()],
		IdentifierSystem: msg.GetIdentifierSystem(),
		PageSize:         msg.GetPageSize(),
		PageToken:        msg.GetPageToken(),
	})
	if err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}

	return connect.NewResponse(&empiv1.SearchPatientsResponse{
		Matches:       matchesToProto(result.Matches),
		NextPageToken: result.NextPageToken,
	}), nil
}

// GetPatient reads one patient.
func (h *Handler) GetPatient(
	ctx context.Context,
	req *connect.Request[empiv1.GetPatientRequest],
) (*connect.Response[empiv1.GetPatientResponse], error) {
	result, err := h.svc.GetPatient(ctx, req.Msg.GetPatientId(), req.Msg.GetResolveMerged())
	if err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}
	return connect.NewResponse(&empiv1.GetPatientResponse{
		Patient:               patientToProto(result.Patient, result.Identifiers),
		ResolvedFromPatientId: result.ResolvedFrom,
		Masked:                result.Masked,
	}), nil
}

// UpdateDemographics applies a correction.
func (h *Handler) UpdateDemographics(
	ctx context.Context,
	req *connect.Request[empiv1.UpdateDemographicsRequest],
) (*connect.Response[empiv1.UpdateDemographicsResponse], error) {
	msg := req.Msg

	patient, err := h.svc.UpdateDemographics(ctx, application.UpdateDemographicsInput{
		PatientID:       msg.GetPatientId(),
		Demographics:    demographicsFromProto(msg.GetDemographics()),
		ExpectedVersion: msg.GetExpectedVersion(),
	})
	if err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}
	// Identifiers are not re-read: a demographic correction does not touch
	// them, and a second query per write would cost every registration desk a
	// round trip to return data the client already holds.
	return connect.NewResponse(&empiv1.UpdateDemographicsResponse{
		Patient: patientToProto(patient, nil),
	}), nil
}

// ConfirmIdentity moves a candidate to active.
func (h *Handler) ConfirmIdentity(
	ctx context.Context,
	req *connect.Request[empiv1.ConfirmIdentityRequest],
) (*connect.Response[empiv1.ConfirmIdentityResponse], error) {
	patient, err := h.svc.ConfirmIdentity(ctx, req.Msg.GetPatientId(), req.Msg.GetExpectedVersion())
	if err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}
	return connect.NewResponse(&empiv1.ConfirmIdentityResponse{
		Patient: patientToProto(patient, nil),
	}), nil
}

// MergePatients implements SRS-EMPI-005.
func (h *Handler) MergePatients(
	ctx context.Context,
	req *connect.Request[empiv1.MergePatientsRequest],
) (*connect.Response[empiv1.MergePatientsResponse], error) {
	msg := req.Msg

	result, err := h.svc.MergePatients(ctx, application.MergePatientsInput{
		SurvivorID:  msg.GetSurvivorPatientId(),
		MergedID:    msg.GetMergedPatientId(),
		Reason:      msg.GetReason(),
		CandidateID: msg.GetCandidateId(),
	})
	if err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}
	return connect.NewResponse(&empiv1.MergePatientsResponse{
		Survivor:        patientToProto(result.Survivor, result.Identifiers),
		MergedPatientId: result.MergedID,
		MergeId:         result.MergeID,
	}), nil
}

// UnmergePatients implements SRS-EMPI-006.
func (h *Handler) UnmergePatients(
	ctx context.Context,
	req *connect.Request[empiv1.UnmergePatientsRequest],
) (*connect.Response[empiv1.UnmergePatientsResponse], error) {
	result, err := h.svc.UnmergePatients(ctx, application.UnmergePatientsInput{
		MergeID: req.Msg.GetMergeId(),
		Reason:  req.Msg.GetReason(),
	})
	if err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}
	return connect.NewResponse(&empiv1.UnmergePatientsResponse{
		Survivor: patientToProto(result.Survivor, nil),
		Restored: patientToProto(result.Restored, nil),
	}), nil
}

// ListDuplicateCandidates implements SRS-EMPI-004's review worklist.
func (h *Handler) ListDuplicateCandidates(
	ctx context.Context,
	req *connect.Request[empiv1.ListDuplicateCandidatesRequest],
) (*connect.Response[empiv1.ListDuplicateCandidatesResponse], error) {
	candidates, err := h.svc.ListDuplicateCandidates(ctx, req.Msg.GetPageSize())
	if err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}
	return connect.NewResponse(&empiv1.ListDuplicateCandidatesResponse{
		Candidates: candidatesToProto(candidates),
	}), nil
}

// DismissDuplicateCandidate records that a pair is two different people.
func (h *Handler) DismissDuplicateCandidate(
	ctx context.Context,
	req *connect.Request[empiv1.DismissDuplicateCandidateRequest],
) (*connect.Response[empiv1.DismissDuplicateCandidateResponse], error) {
	if err := h.svc.DismissDuplicateCandidate(ctx,
		req.Msg.GetCandidateId(), req.Msg.GetReason()); err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}
	return connect.NewResponse(&empiv1.DismissDuplicateCandidateResponse{}), nil
}

// RecordName implements SRS-EMPI-007.
func (h *Handler) RecordName(
	ctx context.Context,
	req *connect.Request[empiv1.RecordNameRequest],
) (*connect.Response[empiv1.RecordNameResponse], error) {
	msg := req.Msg

	in := application.RecordNameInput{
		PatientID: msg.GetPatientId(),
		Kind:      nameKindFromProto[msg.GetKind()],
		Name:      humanNameFromProto(msg.GetName()),
		Source:    msg.GetSource(),
	}
	if msg.GetEffectiveFrom() != nil {
		in.EffectiveFrom = msg.GetEffectiveFrom().AsTime().UTC()
	}

	if err := h.svc.RecordName(ctx, in); err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}
	return connect.NewResponse(&empiv1.RecordNameResponse{}), nil
}

// GetPatientHistory reads the effective-dated record.
func (h *Handler) GetPatientHistory(
	ctx context.Context,
	req *connect.Request[empiv1.GetPatientHistoryRequest],
) (*connect.Response[empiv1.GetPatientHistoryResponse], error) {
	history, err := h.svc.GetHistory(ctx, req.Msg.GetPatientId())
	if err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}
	return connect.NewResponse(&empiv1.GetPatientHistoryResponse{
		Names:       namesToProto(history.Names),
		Preferences: preferencesToProto(history.Preferences),
		Related:     relatedToProto(history.Related),
	}), nil
}

// RecordCommunicationPreference stores what the patient agreed to.
func (h *Handler) RecordCommunicationPreference(
	ctx context.Context,
	req *connect.Request[empiv1.RecordCommunicationPreferenceRequest],
) (*connect.Response[empiv1.RecordCommunicationPreferenceResponse], error) {
	msg := req.Msg

	in := application.RecordPreferenceInput{
		PatientID: msg.GetPatientId(),
		Channel:   channelFromProto[msg.GetChannel()],
		Purpose:   communicationPurposeFromProto[msg.GetPurpose()],
		Allowed:   msg.GetAllowed(),
	}
	if msg.GetEffectiveFrom() != nil {
		in.EffectiveFrom = msg.GetEffectiveFrom().AsTime().UTC()
	}

	if err := h.svc.RecordCommunicationPreference(ctx, in); err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}
	return connect.NewResponse(&empiv1.RecordCommunicationPreferenceResponse{}), nil
}

// RecordDeceased implements SRS-EMPI-008.
func (h *Handler) RecordDeceased(
	ctx context.Context,
	req *connect.Request[empiv1.RecordDeceasedRequest],
) (*connect.Response[empiv1.RecordDeceasedResponse], error) {
	patient, err := h.svc.RecordDeceased(ctx, application.RecordDeceasedInput{
		PatientID: req.Msg.GetPatientId(),
		Date:      partialDateFromProto(req.Msg.GetDate()),
		Source:    req.Msg.GetSource(),
	})
	if err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}
	return connect.NewResponse(&empiv1.RecordDeceasedResponse{
		Patient: patientToProto(patient, nil),
	}), nil
}

// ReverseDeceased withdraws a death recorded against the wrong patient.
func (h *Handler) ReverseDeceased(
	ctx context.Context,
	req *connect.Request[empiv1.ReverseDeceasedRequest],
) (*connect.Response[empiv1.ReverseDeceasedResponse], error) {
	patient, err := h.svc.ReverseDeceased(ctx, req.Msg.GetPatientId(), req.Msg.GetReason())
	if err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}
	return connect.NewResponse(&empiv1.ReverseDeceasedResponse{
		Patient: patientToProto(patient, nil),
	}), nil
}

// AddRelatedPerson implements SRS-EMPI-009.
func (h *Handler) AddRelatedPerson(
	ctx context.Context,
	req *connect.Request[empiv1.AddRelatedPersonRequest],
) (*connect.Response[empiv1.AddRelatedPersonResponse], error) {
	msg := req.Msg

	in := application.AddRelatedPersonInput{
		PatientID:        msg.GetPatientId(),
		RelatedPatientID: msg.GetRelatedPatientId(),
		Name:             humanNameFromProto(msg.GetName()),
		Contact:          contactsFromProto(msg.GetContact()),
		Relationship:     relationshipFromProto[msg.GetRelationship()],
		Authorities:      authoritiesFromProto(msg.GetAuthorities()),
	}
	if msg.GetEffectiveFrom() != nil {
		in.EffectiveFrom = msg.GetEffectiveFrom().AsTime().UTC()
	}
	if msg.GetEffectiveUntil() != nil {
		in.EffectiveUntil = msg.GetEffectiveUntil().AsTime().UTC()
	}

	related, err := h.svc.AddRelatedPerson(ctx, in)
	if err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}
	return connect.NewResponse(&empiv1.AddRelatedPersonResponse{
		Related: relatedPersonToProto(related),
	}), nil
}

// VerifyRelatedPerson records that somebody checked the claim.
func (h *Handler) VerifyRelatedPerson(
	ctx context.Context,
	req *connect.Request[empiv1.VerifyRelatedPersonRequest],
) (*connect.Response[empiv1.VerifyRelatedPersonResponse], error) {
	if err := h.svc.VerifyRelatedPerson(ctx,
		req.Msg.GetRelationshipId(), req.Msg.GetNote()); err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}
	return connect.NewResponse(&empiv1.VerifyRelatedPersonResponse{}), nil
}

// EndRelatedPerson closes a relationship.
func (h *Handler) EndRelatedPerson(
	ctx context.Context,
	req *connect.Request[empiv1.EndRelatedPersonRequest],
) (*connect.Response[empiv1.EndRelatedPersonResponse], error) {
	if err := h.svc.EndRelatedPerson(ctx, req.Msg.GetRelationshipId()); err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}
	return connect.NewResponse(&empiv1.EndRelatedPersonResponse{}), nil
}

// GetCaregiverAuthority answers what one person may do for another, right now.
func (h *Handler) GetCaregiverAuthority(
	ctx context.Context,
	req *connect.Request[empiv1.GetCaregiverAuthorityRequest],
) (*connect.Response[empiv1.GetCaregiverAuthorityResponse], error) {
	authorities, err := h.svc.CaregiverAuthority(ctx,
		req.Msg.GetHolderPatientId(), req.Msg.GetSubjectPatientId())
	if err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}
	return connect.NewResponse(&empiv1.GetCaregiverAuthorityResponse{
		Authorities: authoritiesToProto(authorities),
	}), nil
}

// LinkIdentifier implements SRS-EMPI-011.
func (h *Handler) LinkIdentifier(
	ctx context.Context,
	req *connect.Request[empiv1.LinkIdentifierRequest],
) (*connect.Response[empiv1.LinkIdentifierResponse], error) {
	msg := req.Msg

	result, err := h.svc.LinkIdentifier(ctx, application.LinkIdentifierInput{
		PatientID:           msg.GetPatientId(),
		Type:                identifierTypeFromProto[msg.GetType()],
		System:              msg.GetSystem(),
		Value:               msg.GetValue(),
		AssigningAuthority:  msg.GetAssigningAuthority(),
		Source:              msg.GetSource(),
		Verify:              msg.GetVerify(),
		RequireVerification: msg.GetRequireVerification(),
	})
	if err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}

	out := &empiv1.LinkIdentifierResponse{
		Identifier:               identifierToProto(result.Identifier),
		VerificationAttempted:    result.VerificationAttempted,
		RegistryUnavailable:      result.RegistryUnavailable,
		VerificationReason:       result.VerificationReason,
		HasAuthorityDemographics: result.HasAuthorityDemographics,
	}
	if result.HasAuthorityDemographics {
		out.AuthorityDemographics = demographicsToProto(result.AuthorityDemographics)
	}
	return connect.NewResponse(out), nil
}

// UnlinkIdentifier implements SRS-EMPI-011.
func (h *Handler) UnlinkIdentifier(
	ctx context.Context,
	req *connect.Request[empiv1.UnlinkIdentifierRequest],
) (*connect.Response[empiv1.UnlinkIdentifierResponse], error) {
	msg := req.Msg

	retired, err := h.svc.UnlinkIdentifier(ctx, application.UnlinkIdentifierInput{
		IdentifierID: msg.GetIdentifierId(),
		Revoke:       msg.GetRevoke(),
		Reason:       msg.GetReason(),
	})
	if err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}
	return connect.NewResponse(&empiv1.UnlinkIdentifierResponse{
		Identifier: identifierToProto(retired),
	}), nil
}

// VerifyIdentifier implements SRS-EMPI-011.
func (h *Handler) VerifyIdentifier(
	ctx context.Context,
	req *connect.Request[empiv1.VerifyIdentifierRequest],
) (*connect.Response[empiv1.VerifyIdentifierResponse], error) {
	result, err := h.svc.VerifyIdentifier(ctx, application.VerifyIdentifierInput{
		IdentifierID: req.Msg.GetIdentifierId(),
	})
	if err != nil {
		return nil, platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
	}

	out := &empiv1.VerifyIdentifierResponse{
		Identifier:               identifierToProto(result.Identifier),
		HasAuthorityDemographics: result.HasAuthorityDemographics,
	}
	if result.HasAuthorityDemographics {
		out.AuthorityDemographics = demographicsToProto(result.AuthorityDemographics)
	}
	return connect.NewResponse(out), nil
}
