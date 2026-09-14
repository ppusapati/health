package transport

import (
	"context"

	"connectrpc.com/connect"
	clinicalv1 "github.com/ppusapati/health/code/gen/go/healthcare/clinical/v1"
	"github.com/ppusapati/health/code/internal/clinical/application"
	"github.com/ppusapati/health/code/internal/clinical/ports"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
)

// Handler serves healthcare.clinical.v1.ClinicalService.
type Handler struct {
	svc *application.Service
}

// NewHandler constructs the handler.
func NewHandler(svc *application.Service) *Handler { return &Handler{svc: svc} }

func fail(ctx context.Context, err error) error {
	return platformtransport.ToConnect(err, platformtransport.CorrelationIDFromContext(ctx))
}

// WriteNote implements SRS-CLN-002 and SRS-CLN-015.
func (h *Handler) WriteNote(
	ctx context.Context,
	req *connect.Request[clinicalv1.WriteNoteRequest],
) (*connect.Response[clinicalv1.WriteNoteResponse], error) {
	msg := req.Msg

	document, err := h.svc.WriteNote(ctx, application.WriteNoteInput{
		DocumentID: msg.GetDocumentId(), PatientID: msg.GetPatientId(),
		EncounterID: msg.GetEncounterId(), Kind: documentKindFromProto[msg.GetKind()],
		TemplateID: msg.GetTemplateId(), TemplateVersion: msg.GetTemplateVersion(),
		Title: msg.GetTitle(), Sections: sectionsFromProto(msg.GetSections()),
		Confidentiality: confidentialityFromProto[msg.GetConfidentiality()],
		Dictated:        msg.GetDictated(),
		Context:         contextFromProto(msg.GetContext()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.WriteNoteResponse{
		Document: documentToProto(document),
	}), nil
}

// SignNote implements SRS-CLN-009.
func (h *Handler) SignNote(
	ctx context.Context,
	req *connect.Request[clinicalv1.SignNoteRequest],
) (*connect.Response[clinicalv1.SignNoteResponse], error) {
	document, err := h.svc.SignNote(ctx, application.SignNoteInput{
		DocumentID: req.Msg.GetDocumentId(),
		Meaning:    signatureMeaningFromProto[req.Msg.GetMeaning()],
		Context:    contextFromProto(req.Msg.GetContext()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.SignNoteResponse{
		Document: documentToProto(document),
	}), nil
}

// AmendNote implements SRS-CLN-008.
func (h *Handler) AmendNote(
	ctx context.Context,
	req *connect.Request[clinicalv1.AmendNoteRequest],
) (*connect.Response[clinicalv1.AmendNoteResponse], error) {
	msg := req.Msg

	document, err := h.svc.AmendNote(ctx, application.AmendNoteInput{
		DocumentID: msg.GetDocumentId(), Title: msg.GetTitle(),
		Sections: sectionsFromProto(msg.GetSections()), Reason: msg.GetReason(),
		Addendum: msg.GetAddendum(), Context: contextFromProto(msg.GetContext()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.AmendNoteResponse{
		Document: documentToProto(document),
	}), nil
}

// RetractNote implements SRS-CLN-008.
func (h *Handler) RetractNote(
	ctx context.Context,
	req *connect.Request[clinicalv1.RetractNoteRequest],
) (*connect.Response[clinicalv1.RetractNoteResponse], error) {
	if err := h.svc.RetractNote(ctx, application.RetractNoteInput{
		DocumentID: req.Msg.GetDocumentId(), Reason: req.Msg.GetReason(),
	}); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.RetractNoteResponse{}), nil
}

// GetNote reads one document with its signatures.
func (h *Handler) GetNote(
	ctx context.Context,
	req *connect.Request[clinicalv1.GetNoteRequest],
) (*connect.Response[clinicalv1.GetNoteResponse], error) {
	document, err := h.svc.GetNote(ctx, req.Msg.GetDocumentId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.GetNoteResponse{
		Document: documentToProto(document),
	}), nil
}

// ListNotes returns a patient's documents.
func (h *Handler) ListNotes(
	ctx context.Context,
	req *connect.Request[clinicalv1.ListNotesRequest],
) (*connect.Response[clinicalv1.ListNotesResponse], error) {
	msg := req.Msg

	documents, err := h.svc.ListNotes(ctx, application.ListNotesInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		Kind:          documentKindFromProto[msg.GetKind()],
		IncludeDrafts: msg.GetIncludeDrafts(), PageSize: msg.GetPageSize(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.ListNotesResponse{
		Documents: documentsToProto(documents),
	}), nil
}

// DefineTemplate implements SRS-CLN-002.
func (h *Handler) DefineTemplate(
	ctx context.Context,
	req *connect.Request[clinicalv1.DefineTemplateRequest],
) (*connect.Response[clinicalv1.DefineTemplateResponse], error) {
	if err := h.svc.DefineTemplate(ctx, templateFromProto(req.Msg.GetTemplate())); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.DefineTemplateResponse{}), nil
}

// ListTemplates returns the templates a clinician may choose from.
func (h *Handler) ListTemplates(
	ctx context.Context,
	req *connect.Request[clinicalv1.ListTemplatesRequest],
) (*connect.Response[clinicalv1.ListTemplatesResponse], error) {
	templates, err := h.svc.ListTemplates(ctx,
		documentKindFromProto[req.Msg.GetKind()], req.Msg.GetIncludeRetired(),
		req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.ListTemplatesResponse{
		Templates: templatesToProto(templates),
	}), nil
}

// RetireTemplate stops a template being chosen for new notes.
func (h *Handler) RetireTemplate(
	ctx context.Context,
	req *connect.Request[clinicalv1.RetireTemplateRequest],
) (*connect.Response[clinicalv1.RetireTemplateResponse], error) {
	if err := h.svc.RetireTemplate(ctx, req.Msg.GetTemplateId(),
		req.Msg.GetVersion()); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.RetireTemplateResponse{}), nil
}

// DefineSmartPhrase implements SRS-CLN-015.
func (h *Handler) DefineSmartPhrase(
	ctx context.Context,
	req *connect.Request[clinicalv1.DefineSmartPhraseRequest],
) (*connect.Response[clinicalv1.DefineSmartPhraseResponse], error) {
	phrase, err := h.svc.DefineSmartPhrase(ctx, req.Msg.GetShortcut(),
		req.Msg.GetExpansion(), req.Msg.GetShared())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.DefineSmartPhraseResponse{
		Phrase: phraseToProto(phrase),
	}), nil
}

// ListSmartPhrases returns a clinician's shortcuts and the shared ones.
func (h *Handler) ListSmartPhrases(
	ctx context.Context,
	_ *connect.Request[clinicalv1.ListSmartPhrasesRequest],
) (*connect.Response[clinicalv1.ListSmartPhrasesResponse], error) {
	phrases, err := h.svc.ListSmartPhrases(ctx)
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.ListSmartPhrasesResponse{
		Phrases: phrasesToProto(phrases),
	}), nil
}

// RecordProblem implements SRS-CLN-003.
func (h *Handler) RecordProblem(
	ctx context.Context,
	req *connect.Request[clinicalv1.RecordProblemRequest],
) (*connect.Response[clinicalv1.RecordProblemResponse], error) {
	msg := req.Msg

	problem, err := h.svc.RecordProblem(ctx, application.RecordProblemInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		Code: codingFromProto(msg.GetCode()), Note: msg.GetNote(),
		Status:          problemStatusFromProto[msg.GetStatus()],
		OnsetAt:         fromTimestamp(msg.GetOnsetAt()),
		Confidentiality: confidentialityFromProto[msg.GetConfidentiality()],
		Context:         contextFromProto(msg.GetContext()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.RecordProblemResponse{
		Problem: problemToProto(problem),
	}), nil
}

// UpdateProblem implements SRS-CLN-003.
func (h *Handler) UpdateProblem(
	ctx context.Context,
	req *connect.Request[clinicalv1.UpdateProblemRequest],
) (*connect.Response[clinicalv1.UpdateProblemResponse], error) {
	problem, err := h.svc.UpdateProblem(ctx, application.UpdateProblemInput{
		ProblemID:  req.Msg.GetProblemId(),
		Status:     problemStatusFromProto[req.Msg.GetStatus()],
		ResolvedAt: fromTimestamp(req.Msg.GetResolvedAt()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.UpdateProblemResponse{
		Problem: problemToProto(problem),
	}), nil
}

// ListProblems returns the problem list, resolved entries included.
func (h *Handler) ListProblems(
	ctx context.Context,
	req *connect.Request[clinicalv1.ListProblemsRequest],
) (*connect.Response[clinicalv1.ListProblemsResponse], error) {
	problems, err := h.svc.ListProblems(ctx, req.Msg.GetPatientId(),
		req.Msg.GetActiveOnly(), req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.ListProblemsResponse{
		Problems: problemsToProto(problems),
	}), nil
}

// RecordAllergy implements SRS-CLN-004.
func (h *Handler) RecordAllergy(
	ctx context.Context,
	req *connect.Request[clinicalv1.RecordAllergyRequest],
) (*connect.Response[clinicalv1.RecordAllergyResponse], error) {
	msg := req.Msg

	allergy, err := h.svc.RecordAllergy(ctx, application.RecordAllergyInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		Substance:    codingFromProto(msg.GetSubstance()),
		Kind:         allergyKindFromProto[msg.GetKind()],
		Criticality:  criticalityFromProto[msg.GetCriticality()],
		Verification: verificationFromProto[msg.GetVerification()],
		Reactions:    reactionsFromProto(msg.GetReactions()),
		OnsetAt:      fromTimestamp(msg.GetOnsetAt()), Note: msg.GetNote(),
		Context: contextFromProto(msg.GetContext()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.RecordAllergyResponse{
		Allergy: allergyToProto(allergy),
	}), nil
}

// VerifyAllergy implements SRS-CLN-004.
func (h *Handler) VerifyAllergy(
	ctx context.Context,
	req *connect.Request[clinicalv1.VerifyAllergyRequest],
) (*connect.Response[clinicalv1.VerifyAllergyResponse], error) {
	allergy, err := h.svc.VerifyAllergy(ctx, req.Msg.GetAllergyId(),
		verificationFromProto[req.Msg.GetVerification()])
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.VerifyAllergyResponse{
		Allergy: allergyToProto(allergy),
	}), nil
}

// ListAllergies returns a patient's allergies, most dangerous first.
func (h *Handler) ListAllergies(
	ctx context.Context,
	req *connect.Request[clinicalv1.ListAllergiesRequest],
) (*connect.Response[clinicalv1.ListAllergiesResponse], error) {
	allergies, err := h.svc.ListAllergies(ctx, req.Msg.GetPatientId(),
		req.Msg.GetActiveOnly(), req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.ListAllergiesResponse{
		Allergies: allergiesToProto(allergies.Active()),
	}), nil
}

// RecordObservation implements SRS-CLN-005, SRS-CLN-010 and SRS-CLN-011.
func (h *Handler) RecordObservation(
	ctx context.Context,
	req *connect.Request[clinicalv1.RecordObservationRequest],
) (*connect.Response[clinicalv1.RecordObservationResponse], error) {
	msg := req.Msg

	in := application.RecordObservationInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		Code:      codingFromProto(msg.GetCode()),
		Value:     domainQuantity(msg.GetValue()),
		TextValue: msg.GetTextValue(), CodedValue: codingFromProto(msg.GetCodedValue()),
		ReferenceText:        msg.GetReferenceText(),
		Interpretation:       interpretationFromProto[msg.GetInterpretation()],
		InterpretationSource: msg.GetInterpretationSource(),
		Status:               observationStatusFromProto[msg.GetStatus()],
		EffectiveAt:          fromTimestamp(msg.GetEffectiveAt()),
		IssuedAt:             fromTimestamp(msg.GetIssuedAt()),
		PerformerID:          msg.GetPerformerId(), DeviceID: msg.GetDeviceId(),
		SourceSystem: msg.GetSourceSystem(),
		Provenance:   provenanceInputFromProto(msg.GetProvenance()),
		Note:         msg.GetNote(),
		Context:      contextFromProto(msg.GetContext()),
	}
	// The reference range is optional, and a zero low is a real bound — a
	// bicarbonate range starts at nothing useful but a base excess does not. So
	// the caller says explicitly whether it supplied one.
	if msg.GetHasReferenceRange() {
		low, high := msg.GetReferenceLow(), msg.GetReferenceHigh()
		in.ReferenceLow, in.ReferenceHigh = &low, &high
	}

	observation, err := h.svc.RecordObservation(ctx, in)
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.RecordObservationResponse{
		Observation: observationToProto(observation),
	}), nil
}

// ListObservations returns a patient's results, or one code's trend.
func (h *Handler) ListObservations(
	ctx context.Context,
	req *connect.Request[clinicalv1.ListObservationsRequest],
) (*connect.Response[clinicalv1.ListObservationsResponse], error) {
	msg := req.Msg

	observations, err := h.svc.ListObservations(ctx, ports.ObservationQuery{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		Code: msg.GetCode(), Limit: msg.GetPageSize(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.ListObservationsResponse{
		Observations: observationsToProto(observations),
	}), nil
}

// ListCriticalResults implements SRS-CLN-012.
func (h *Handler) ListCriticalResults(
	ctx context.Context,
	req *connect.Request[clinicalv1.ListCriticalResultsRequest],
) (*connect.Response[clinicalv1.ListCriticalResultsResponse], error) {
	results, err := h.svc.ListCriticalResults(ctx, req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}

	out := make([]*clinicalv1.CriticalResult, 0, len(results))
	for _, r := range results {
		out = append(out, &clinicalv1.CriticalResult{
			Observation:    observationToProto(r.Observation),
			DueEscalations: int32(r.DueEscalations),
		})
	}
	return connect.NewResponse(&clinicalv1.ListCriticalResultsResponse{
		Results: out,
	}), nil
}

// AcknowledgeCriticalResult implements SRS-CLN-012.
func (h *Handler) AcknowledgeCriticalResult(
	ctx context.Context,
	req *connect.Request[clinicalv1.AcknowledgeCriticalResultRequest],
) (*connect.Response[clinicalv1.AcknowledgeCriticalResultResponse], error) {
	acknowledgement, err := h.svc.AcknowledgeCriticalResult(ctx,
		application.AcknowledgeResultInput{
			ObservationID: req.Msg.GetObservationId(), Action: req.Msg.GetAction(),
		})
	if err != nil {
		return nil, fail(ctx, err)
	}

	out := &clinicalv1.CriticalAcknowledgement{
		AcknowledgementId: acknowledgement.ID,
		ObservationId:     acknowledgement.ObservationID,
		PatientId:         acknowledgement.PatientID,
		AcknowledgedBy:    acknowledgement.AcknowledgedBy,
		AcknowledgedAt:    timestamp(acknowledgement.AcknowledgedAt),
		Action:            acknowledgement.Action,
		NotifiedAt:        timestamp(acknowledgement.NotifiedAt),
	}
	if delay, known := acknowledgement.Delay(); known {
		out.DelaySeconds = int64(delay.Seconds())
	}
	return connect.NewResponse(&clinicalv1.AcknowledgeCriticalResultResponse{
		Acknowledgement: out,
	}), nil
}

// RecordProcedure implements SRS-CLN-006.
func (h *Handler) RecordProcedure(
	ctx context.Context,
	req *connect.Request[clinicalv1.RecordProcedureRequest],
) (*connect.Response[clinicalv1.RecordProcedureResponse], error) {
	msg := req.Msg

	procedure, err := h.svc.RecordProcedure(ctx, application.RecordProcedureInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		Code:          codingFromProto(msg.GetCode()),
		Status:        procedureStatusFromProto[msg.GetStatus()],
		Indication:    codingFromProto(msg.GetIndication()),
		Performers:    performersFromProto(msg.GetPerformers()),
		BodySite:      codingFromProto(msg.GetBodySite()),
		Laterality:    lateralityFromProto[msg.GetLaterality()],
		Outcome:       msg.GetOutcome(),
		Complications: codingsFromProto(msg.GetComplications()),
		OrderIDs:      msg.GetOrderIds(), DeviceIDs: msg.GetDeviceIds(),
		SpecimenIDs:    msg.GetSpecimenIds(),
		PerformedStart: fromTimestamp(msg.GetPerformedStart()),
		PerformedEnd:   fromTimestamp(msg.GetPerformedEnd()),
		Note:           msg.GetNote(), RequireConsent: msg.GetRequireConsent(),
		Context: contextFromProto(msg.GetContext()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.RecordProcedureResponse{
		Procedure: procedureToProto(procedure),
	}), nil
}

// ListProcedures returns a patient's procedures.
func (h *Handler) ListProcedures(
	ctx context.Context,
	req *connect.Request[clinicalv1.ListProceduresRequest],
) (*connect.Response[clinicalv1.ListProceduresResponse], error) {
	procedures, err := h.svc.ListProcedures(ctx, req.Msg.GetPatientId(),
		req.Msg.GetEncounterId(), req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.ListProceduresResponse{
		Procedures: proceduresToProto(procedures),
	}), nil
}

// CreateCarePlan implements SRS-CLN-007.
func (h *Handler) CreateCarePlan(
	ctx context.Context,
	req *connect.Request[clinicalv1.CreateCarePlanRequest],
) (*connect.Response[clinicalv1.CreateCarePlanResponse], error) {
	msg := req.Msg

	plan, err := h.svc.CreateCarePlan(ctx, application.CreateCarePlanInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		Title: msg.GetTitle(), ProblemIDs: msg.GetProblemIds(),
		Goals:      goalsFromProto(msg.GetGoals()),
		Activities: activitiesFromProto(msg.GetActivities()),
		OwnerID:    msg.GetOwnerId(),
		StartsAt:   fromTimestamp(msg.GetStartsAt()),
		EndsAt:     fromTimestamp(msg.GetEndsAt()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.CreateCarePlanResponse{
		CarePlan: carePlanToProto(plan),
	}), nil
}

// UpdateCarePlan revises a plan of care.
func (h *Handler) UpdateCarePlan(
	ctx context.Context,
	req *connect.Request[clinicalv1.UpdateCarePlanRequest],
) (*connect.Response[clinicalv1.UpdateCarePlanResponse], error) {
	msg := req.Msg

	plan, err := h.svc.UpdateCarePlan(ctx, application.UpdateCarePlanInput{
		CarePlanID: msg.GetCarePlanId(),
		Status:     carePlanStatusFromProto[msg.GetStatus()],
		Goals:      goalsFromProto(msg.GetGoals()),
		Activities: activitiesFromProto(msg.GetActivities()),
		ProblemIDs: msg.GetProblemIds(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.UpdateCarePlanResponse{
		CarePlan: carePlanToProto(plan),
	}), nil
}

// ListCarePlans returns a patient's plans.
func (h *Handler) ListCarePlans(
	ctx context.Context,
	req *connect.Request[clinicalv1.ListCarePlansRequest],
) (*connect.Response[clinicalv1.ListCarePlansResponse], error) {
	plans, err := h.svc.ListCarePlans(ctx, req.Msg.GetPatientId(),
		req.Msg.GetActiveOnly(), req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.ListCarePlansResponse{
		CarePlans: carePlansToProto(plans),
	}), nil
}

// GetBanner implements SRS-CLN-001.
func (h *Handler) GetBanner(
	ctx context.Context,
	req *connect.Request[clinicalv1.GetBannerRequest],
) (*connect.Response[clinicalv1.GetBannerResponse], error) {
	banner, err := h.svc.GetBanner(ctx, req.Msg.GetPatientId(),
		req.Msg.GetEncounterContext())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.GetBannerResponse{
		Banner: bannerToProto(banner),
	}), nil
}

// RecordConsent implements SRS-CLN-013.
func (h *Handler) RecordConsent(
	ctx context.Context,
	req *connect.Request[clinicalv1.RecordConsentRequest],
) (*connect.Response[clinicalv1.RecordConsentResponse], error) {
	msg := req.Msg

	consent, err := h.svc.RecordConsent(ctx, application.RecordConsentInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		Kind:          consentKindFromProto[msg.GetKind()],
		ProcedureCode: codingFromProto(msg.GetProcedureCode()),
		Status:        consentStatusFromProto[msg.GetStatus()],
		GivenBy:       consentGiverFromProto[msg.GetGivenBy()],
		GivenByName:   msg.GetGivenByName(), DocumentID: msg.GetDocumentId(),
		WitnessID:  msg.GetWitnessId(),
		ValidFrom:  fromTimestamp(msg.GetValidFrom()),
		ValidUntil: fromTimestamp(msg.GetValidUntil()),
		Note:       msg.GetNote(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.RecordConsentResponse{
		Consent: consentToProto(consent),
	}), nil
}

// WithdrawConsent implements SRS-CLN-013.
func (h *Handler) WithdrawConsent(
	ctx context.Context,
	req *connect.Request[clinicalv1.WithdrawConsentRequest],
) (*connect.Response[clinicalv1.WithdrawConsentResponse], error) {
	if err := h.svc.WithdrawConsent(ctx, req.Msg.GetConsentId()); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.WithdrawConsentResponse{}), nil
}

// ListConsents returns a patient's clinical consents.
func (h *Handler) ListConsents(
	ctx context.Context,
	req *connect.Request[clinicalv1.ListConsentsRequest],
) (*connect.Response[clinicalv1.ListConsentsResponse], error) {
	consents, err := h.svc.ListConsents(ctx, req.Msg.GetPatientId(),
		consentKindFromProto[req.Msg.GetKind()], req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.ListConsentsResponse{
		Consents: consentsToProto(consents),
	}), nil
}

// AttachFile implements SRS-CLN-014.
func (h *Handler) AttachFile(
	ctx context.Context,
	req *connect.Request[clinicalv1.AttachFileRequest],
) (*connect.Response[clinicalv1.AttachFileResponse], error) {
	msg := req.Msg

	attachment, err := h.svc.AttachFile(ctx, application.AttachFileInput{
		ParentType: msg.GetParentType(), ParentID: msg.GetParentId(),
		PatientID: msg.GetPatientId(), Kind: attachmentKindFromProto[msg.GetKind()],
		ContentType: msg.GetContentType(), Content: msg.GetContent(),
		// Read and passed on so the service can refuse them by name. A client
		// still sending a storage key believes this record will point at bytes
		// it placed itself, and quietly substituting the server's own key
		// would leave it believing that.
		StorageKey:      msg.GetStorageKey(), //nolint:staticcheck // deprecated on purpose; refused below
		SizeBytes:       msg.GetSizeBytes(),  //nolint:staticcheck // deprecated on purpose; refused below
		Digest:          msg.GetDigest(),     //nolint:staticcheck // deprecated on purpose; refused below
		Description:     msg.GetDescription(),
		Confidentiality: confidentialityFromProto[msg.GetConfidentiality()],
		CapturedAt:      fromTimestamp(msg.GetCapturedAt()),
		SourceSystem:    msg.GetSourceSystem(),
		Provenance:      provenanceInputFromProto(msg.GetProvenance()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.AttachFileResponse{
		Attachment: attachmentToProto(attachment),
	}), nil
}

// ListAttachments returns what is attached to one record.
func (h *Handler) ListAttachments(
	ctx context.Context,
	req *connect.Request[clinicalv1.ListAttachmentsRequest],
) (*connect.Response[clinicalv1.ListAttachmentsResponse], error) {
	attachments, err := h.svc.ListAttachments(ctx, req.Msg.GetParentType(),
		req.Msg.GetParentId(), req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.ListAttachmentsResponse{
		Attachments: attachmentsToProto(attachments),
	}), nil
}

// GetProvenance implements SRS-CLN-010.
func (h *Handler) GetProvenance(
	ctx context.Context,
	req *connect.Request[clinicalv1.GetProvenanceRequest],
) (*connect.Response[clinicalv1.GetProvenanceResponse], error) {
	provenance, err := h.svc.GetProvenance(ctx, req.Msg.GetRecordType(),
		req.Msg.GetRecordId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.GetProvenanceResponse{
		Provenance: provenancesToProto(provenance),
	}), nil
}

// StoreCalculation implements SRS-CLN-020.
func (h *Handler) StoreCalculation(
	ctx context.Context,
	req *connect.Request[clinicalv1.StoreCalculationRequest],
) (*connect.Response[clinicalv1.StoreCalculationResponse], error) {
	msg := req.Msg

	result, err := h.svc.StoreCalculation(ctx, application.StoreCalculationInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		CalculatorID: msg.GetCalculatorId(), Version: msg.GetFormulaVersion(),
		Name: msg.GetName(), Inputs: calculatorInputsFromProto(msg.GetInputs()),
		Value: msg.GetValue(), Unit: msg.GetUnit(),
		Interpretation: msg.GetInterpretation(), SupersedesID: msg.GetSupersedesId(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.StoreCalculationResponse{
		Result: calculationToProto(result),
	}), nil
}

// ListCalculations returns a patient's stored scores.
func (h *Handler) ListCalculations(
	ctx context.Context,
	req *connect.Request[clinicalv1.ListCalculationsRequest],
) (*connect.Response[clinicalv1.ListCalculationsResponse], error) {
	results, err := h.svc.ListCalculations(ctx, req.Msg.GetPatientId(),
		req.Msg.GetCalculatorId(), req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.ListCalculationsResponse{
		Results: calculationsToProto(results),
	}), nil
}

// RaiseAlert implements SRS-CLN-021.
func (h *Handler) RaiseAlert(
	ctx context.Context,
	req *connect.Request[clinicalv1.RaiseAlertRequest],
) (*connect.Response[clinicalv1.RaiseAlertResponse], error) {
	msg := req.Msg

	alert, err := h.svc.RaiseAlert(ctx, application.RaiseAlertInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		RuleID: msg.GetRuleId(), RuleVersion: msg.GetRuleVersion(),
		Level: alertLevelFromProto[msg.GetLevel()], Message: msg.GetMessage(),
		ContextType: msg.GetContextType(), ContextID: msg.GetContextId(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.RaiseAlertResponse{
		Alert: alertToProto(alert),
	}), nil
}

// RespondToAlert implements SRS-CLN-021.
func (h *Handler) RespondToAlert(
	ctx context.Context,
	req *connect.Request[clinicalv1.RespondToAlertRequest],
) (*connect.Response[clinicalv1.RespondToAlertResponse], error) {
	alert, err := h.svc.RespondToAlert(ctx, application.RespondToAlertInput{
		AlertID:        req.Msg.GetAlertId(),
		Outcome:        alertOutcomeFromProto[req.Msg.GetOutcome()],
		OverrideCode:   req.Msg.GetOverrideCode(),
		OverrideReason: req.Msg.GetOverrideReason(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.RespondToAlertResponse{
		Alert: alertToProto(alert),
	}), nil
}

// ListAlerts returns fired alerts, which is also the override report.
func (h *Handler) ListAlerts(
	ctx context.Context,
	req *connect.Request[clinicalv1.ListAlertsRequest],
) (*connect.Response[clinicalv1.ListAlertsResponse], error) {
	msg := req.Msg

	alerts, err := h.svc.ListAlerts(ctx, ports.AlertQuery{
		PatientID: msg.GetPatientId(),
		Outcome:   alertOutcomeFromProto[msg.GetOutcome()],
		RuleID:    msg.GetRuleId(), Limit: msg.GetPageSize(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.ListAlertsResponse{
		Alerts: alertsToProto(alerts),
	}), nil
}

// RequestConsult implements SRS-CLN-022.
func (h *Handler) RequestConsult(
	ctx context.Context,
	req *connect.Request[clinicalv1.RequestConsultRequest],
) (*connect.Response[clinicalv1.RequestConsultResponse], error) {
	msg := req.Msg

	consult, err := h.svc.RequestConsult(ctx, application.RequestConsultInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		Specialty: msg.GetSpecialty(),
		Urgency:   consultUrgencyFromProto[msg.GetUrgency()],
		Reason:    msg.GetReason(), Question: msg.GetQuestion(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.RequestConsultResponse{
		Consult: consultToProto(consult),
	}), nil
}

// RespondToConsult implements SRS-CLN-022.
func (h *Handler) RespondToConsult(
	ctx context.Context,
	req *connect.Request[clinicalv1.RespondToConsultRequest],
) (*connect.Response[clinicalv1.RespondToConsultResponse], error) {
	msg := req.Msg

	consult, err := h.svc.RespondToConsult(ctx, application.RespondToConsultInput{
		ConsultID: msg.GetConsultId(), Accept: msg.GetAccept(),
		Response:           msg.GetResponse(),
		ResponseDocumentID: msg.GetResponseDocumentId(),
		DeclineReason:      msg.GetDeclineReason(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.RespondToConsultResponse{
		Consult: consultToProto(consult),
	}), nil
}

// ListConsults returns the receiving service's worklist.
func (h *Handler) ListConsults(
	ctx context.Context,
	req *connect.Request[clinicalv1.ListConsultsRequest],
) (*connect.Response[clinicalv1.ListConsultsResponse], error) {
	msg := req.Msg

	consults, err := h.svc.ListConsults(ctx, ports.ConsultQuery{
		PatientID: msg.GetPatientId(), Specialty: msg.GetSpecialty(),
		OpenOnly: msg.GetOpenOnly(), Limit: msg.GetPageSize(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.ListConsultsResponse{
		Consults: consultsToProto(consults),
	}), nil
}

// EnrolInRegistry implements SRS-CLN-023.
func (h *Handler) EnrolInRegistry(
	ctx context.Context,
	req *connect.Request[clinicalv1.EnrolInRegistryRequest],
) (*connect.Response[clinicalv1.EnrolInRegistryResponse], error) {
	msg := req.Msg

	membership, err := h.svc.EnrolInRegistry(ctx, application.EnrolInRegistryInput{
		PatientID: msg.GetPatientId(), RegistryID: msg.GetRegistryId(),
		ProblemID: msg.GetProblemId(), DiagnosisID: msg.GetDiagnosisId(),
		EnrolledAt: fromTimestamp(msg.GetEnrolledAt()),
		Consented:  msg.GetConsented(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.EnrolInRegistryResponse{
		Membership: membershipToProto(membership),
	}), nil
}

// ExitRegistry records a patient leaving a registry.
func (h *Handler) ExitRegistry(
	ctx context.Context,
	req *connect.Request[clinicalv1.ExitRegistryRequest],
) (*connect.Response[clinicalv1.ExitRegistryResponse], error) {
	if err := h.svc.ExitRegistry(ctx, req.Msg.GetMembershipId(),
		fromTimestamp(req.Msg.GetExitedAt()), req.Msg.GetReason()); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.ExitRegistryResponse{}), nil
}

// ListRegistryMemberships returns a patient's registry memberships.
func (h *Handler) ListRegistryMemberships(
	ctx context.Context,
	req *connect.Request[clinicalv1.ListRegistryMembershipsRequest],
) (*connect.Response[clinicalv1.ListRegistryMembershipsResponse], error) {
	memberships, err := h.svc.ListRegistryMemberships(ctx, req.Msg.GetPatientId(),
		req.Msg.GetRegistryId(), req.Msg.GetCurrentOnly(), req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&clinicalv1.ListRegistryMembershipsResponse{
		Memberships: membershipsToProto(memberships),
	}), nil
}
