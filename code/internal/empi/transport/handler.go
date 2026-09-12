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
