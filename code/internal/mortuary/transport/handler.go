package transport

import (
	"context"
	"time"

	"connectrpc.com/connect"

	mortuaryv1 "github.com/ppusapati/health/code/gen/go/healthcare/mortuary/v1"
	"github.com/ppusapati/health/code/gen/go/healthcare/mortuary/v1/mortuaryv1connect"
	"github.com/ppusapati/health/code/internal/mortuary/application"
)

// Handler is the mortuary ConnectRPC surface.
//
// Thin on purpose: it translates, calls one use case and translates back.
// Every refusal comes from the application or the domain, so the same rule
// holds whichever client asks — a second client cannot be written that
// forgets a medico-legal case needs its authority's clearance.
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

var _ mortuaryv1connect.MortuaryServiceHandler = (*Handler)(nil)

// Cases (SRS-MORT-001, SRS-MORT-003).

func (h *Handler) OpenCase(ctx context.Context,
	req *connect.Request[mortuaryv1.OpenCaseRequest]) (
	*connect.Response[mortuaryv1.OpenCaseResponse], error) {

	msg := req.Msg
	opened, err := h.svc.OpenCase(ctx, application.OpenCaseInput{
		Reference:          msg.GetReference(),
		Source:             string(sourceFromWire[msg.GetSource()]),
		EncounterID:        msg.GetEncounterId(),
		PatientID:          msg.GetPatientId(),
		ExternalSource:     msg.GetExternalSource(),
		Identity:           string(identityFromWire[msg.GetIdentity()]),
		IdentificationNote: msg.GetIdentificationNote(),
		DisplayName:        msg.GetDisplayName(),
		MedicoLegal:        msg.GetMedicoLegal(),
		MLCReference:       msg.GetMlcReference(),
		Restricted:         msg.GetRestricted(),
		DiedAt:             timeOf(msg.GetDiedAt()),
		FacilityID:         msg.GetFacilityId(),
		ReceivedFrom:       msg.GetReceivedFrom(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&mortuaryv1.OpenCaseResponse{
		MortuaryCase: caseToWire(opened),
	}), nil
}

func (h *Handler) Identify(ctx context.Context,
	req *connect.Request[mortuaryv1.IdentifyRequest]) (
	*connect.Response[mortuaryv1.IdentifyResponse], error) {

	msg := req.Msg
	found, err := h.svc.Identify(ctx, application.IdentifyInput{
		CaseID:   msg.GetCaseId(),
		Identity: string(identityFromWire[msg.GetIdentity()]),
		Name:     msg.GetName(), Note: msg.GetNote(),
		Version: msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&mortuaryv1.IdentifyResponse{
		MortuaryCase: caseToWire(found),
	}), nil
}

func (h *Handler) RecordCause(ctx context.Context,
	req *connect.Request[mortuaryv1.RecordCauseRequest]) (
	*connect.Response[mortuaryv1.RecordCauseResponse], error) {

	msg := req.Msg
	found, err := h.svc.RecordCause(ctx, application.RecordCauseInput{
		CaseID: msg.GetCaseId(), Summary: msg.GetSummary(),
		Version: msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&mortuaryv1.RecordCauseResponse{
		MortuaryCase: caseToWire(found),
	}), nil
}

func (h *Handler) RecordDeathCertificate(ctx context.Context,
	req *connect.Request[mortuaryv1.RecordDeathCertificateRequest]) (
	*connect.Response[mortuaryv1.RecordDeathCertificateResponse], error) {

	msg := req.Msg
	found, err := h.svc.RecordCertificate(ctx,
		application.RecordCertificateInput{
			CaseID: msg.GetCaseId(), Reference: msg.GetReference(),
			Version: msg.GetVersion(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(
		&mortuaryv1.RecordDeathCertificateResponse{
			MortuaryCase: caseToWire(found),
		}), nil
}

func (h *Handler) MarkMedicoLegal(ctx context.Context,
	req *connect.Request[mortuaryv1.MarkMedicoLegalRequest]) (
	*connect.Response[mortuaryv1.MarkMedicoLegalResponse], error) {

	msg := req.Msg
	found, err := h.svc.MarkMedicoLegal(ctx,
		application.MarkMedicoLegalInput{
			CaseID: msg.GetCaseId(), Reference: msg.GetReference(),
			Version: msg.GetVersion(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&mortuaryv1.MarkMedicoLegalResponse{
		MortuaryCase: caseToWire(found),
	}), nil
}

func (h *Handler) GetCase(ctx context.Context,
	req *connect.Request[mortuaryv1.GetCaseRequest]) (
	*connect.Response[mortuaryv1.GetCaseResponse], error) {

	found, err := h.svc.Case(ctx, req.Msg.GetCaseId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&mortuaryv1.GetCaseResponse{
		MortuaryCase: caseToWire(found),
	}), nil
}

func (h *Handler) GetCaseByReference(ctx context.Context,
	req *connect.Request[mortuaryv1.GetCaseByReferenceRequest]) (
	*connect.Response[mortuaryv1.GetCaseByReferenceResponse], error) {

	found, err := h.svc.CaseByReference(ctx, req.Msg.GetReference())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&mortuaryv1.GetCaseByReferenceResponse{
		MortuaryCase: caseToWire(found),
	}), nil
}

func (h *Handler) ListCases(ctx context.Context,
	req *connect.Request[mortuaryv1.ListCasesRequest]) (
	*connect.Response[mortuaryv1.ListCasesResponse], error) {

	msg := req.Msg
	found, err := h.svc.ListCases(ctx, application.ListCasesInput{
		States:          textsFromWire(msg.GetStates(), caseStateFromWire),
		Identities:      textsFromWire(msg.GetIdentities(), identityFromWire),
		FacilityID:      msg.GetFacilityId(),
		MedicoLegalOnly: msg.GetMedicoLegalOnly(),
		From:            timeOf(msg.GetFrom()), To: timeOf(msg.GetTo()),
		PageSize: msg.GetPageSize(), Offset: msg.GetOffset(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&mortuaryv1.ListCasesResponse{
		Cases: casesToWire(found),
	}), nil
}

// Storage (SRS-MORT-002).

func (h *Handler) AddLocation(ctx context.Context,
	req *connect.Request[mortuaryv1.AddLocationRequest]) (
	*connect.Response[mortuaryv1.AddLocationResponse], error) {

	msg := req.Msg
	location, err := h.svc.AddLocation(ctx, application.AddLocationInput{
		Code:       msg.GetCode(),
		Kind:       string(spaceKindFromWire[msg.GetKind()]),
		FacilityID: msg.GetFacilityId(), Zone: msg.GetZone(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&mortuaryv1.AddLocationResponse{
		Location: locationToWire(location),
	}), nil
}

func (h *Handler) SetLocationService(ctx context.Context,
	req *connect.Request[mortuaryv1.SetLocationServiceRequest]) (
	*connect.Response[mortuaryv1.SetLocationServiceResponse], error) {

	msg := req.Msg
	location, err := h.svc.SetLocationService(ctx,
		application.SetLocationServiceInput{
			LocationID:   msg.GetLocationId(),
			OutOfService: msg.GetOutOfService(),
			Reason:       msg.GetReason(), Version: msg.GetVersion(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&mortuaryv1.SetLocationServiceResponse{
		Location: locationToWire(location),
	}), nil
}

func (h *Handler) ListLocations(ctx context.Context,
	req *connect.Request[mortuaryv1.ListLocationsRequest]) (
	*connect.Response[mortuaryv1.ListLocationsResponse], error) {

	msg := req.Msg
	found, err := h.svc.ListLocations(ctx, application.ListLocationsInput{
		FacilityID:    msg.GetFacilityId(),
		Kinds:         textsFromWire(msg.GetKinds(), spaceKindFromWire),
		InServiceOnly: msg.GetInServiceOnly(),
		PageSize:      msg.GetPageSize(), Offset: msg.GetOffset(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*mortuaryv1.Location, 0, len(found))
	for _, location := range found {
		out = append(out, locationToWire(location))
	}
	return connect.NewResponse(&mortuaryv1.ListLocationsResponse{
		Locations: out,
	}), nil
}

func (h *Handler) PlaceBody(ctx context.Context,
	req *connect.Request[mortuaryv1.PlaceBodyRequest]) (
	*connect.Response[mortuaryv1.PlaceBodyResponse], error) {

	msg := req.Msg
	placed, err := h.svc.Place(ctx, application.PlaceInput{
		CaseID: msg.GetCaseId(), LocationID: msg.GetLocationId(),
		StorageTag:  msg.GetStorageTag(),
		CheckedNote: msg.GetCheckedNote(),
		MoveReason:  msg.GetMoveReason(), Version: msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&mortuaryv1.PlaceBodyResponse{
		Placement: placementToWire(placed),
	}), nil
}

func (h *Handler) GetPlacementHistory(ctx context.Context,
	req *connect.Request[mortuaryv1.GetPlacementHistoryRequest]) (
	*connect.Response[mortuaryv1.GetPlacementHistoryResponse], error) {

	found, err := h.svc.PlacementHistory(ctx, req.Msg.GetCaseId())
	if err != nil {
		return nil, err
	}
	out := make([]*mortuaryv1.Placement, 0, len(found))
	for _, placement := range found {
		out = append(out, placementToWire(placement))
	}
	return connect.NewResponse(&mortuaryv1.GetPlacementHistoryResponse{
		Placements: out,
	}), nil
}

// Belongings and the chain of custody (SRS-MORT-004).

func (h *Handler) ListItem(ctx context.Context,
	req *connect.Request[mortuaryv1.ListItemRequest]) (
	*connect.Response[mortuaryv1.ListItemResponse], error) {

	msg := req.Msg
	item, err := h.svc.ListItem(ctx, application.ListItemInput{
		CaseID:      msg.GetCaseId(),
		Kind:        string(itemKindFromWire[msg.GetKind()]),
		Description: msg.GetDescription(),
		Quantity:    int(msg.GetQuantity()),
		SealNumber:  msg.GetSealNumber(),
		WitnessedBy: msg.GetWitnessedBy(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&mortuaryv1.ListItemResponse{
		Item: itemToWire(item),
	}), nil
}

func (h *Handler) RetainItem(ctx context.Context,
	req *connect.Request[mortuaryv1.RetainItemRequest]) (
	*connect.Response[mortuaryv1.RetainItemResponse], error) {

	msg := req.Msg
	item, err := h.svc.RetainItem(ctx, application.RetainItemInput{
		ItemID: msg.GetItemId(), Authority: msg.GetAuthority(),
		Reference: msg.GetReference(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&mortuaryv1.RetainItemResponse{
		Item: itemToWire(item),
	}), nil
}

func (h *Handler) HandOverBelongings(ctx context.Context,
	req *connect.Request[mortuaryv1.HandOverBelongingsRequest]) (
	*connect.Response[mortuaryv1.HandOverBelongingsResponse], error) {

	msg := req.Msg
	handover, err := h.svc.HandOver(ctx, application.HandOverInput{
		CaseID: msg.GetCaseId(), ItemIDs: msg.GetItemIds(),
		RecipientName:     msg.GetRecipientName(),
		RecipientRelation: msg.GetRecipientRelation(),
		RecipientIDType:   msg.GetRecipientIdType(),
		RecipientIDRef:    msg.GetRecipientIdRef(),
		SignatureRef:      msg.GetSignatureRef(),
		WitnessedBy:       msg.GetWitnessedBy(), Note: msg.GetNote(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&mortuaryv1.HandOverBelongingsResponse{
		Handover: handoverToWire(handover),
	}), nil
}

func (h *Handler) GetBelongings(ctx context.Context,
	req *connect.Request[mortuaryv1.GetBelongingsRequest]) (
	*connect.Response[mortuaryv1.GetBelongingsResponse], error) {

	caseID := req.Msg.GetCaseId()
	items, err := h.svc.Belongings(ctx, caseID)
	if err != nil {
		return nil, err
	}
	handovers, err := h.svc.Handovers(ctx, caseID)
	if err != nil {
		return nil, err
	}
	outItems := make([]*mortuaryv1.Item, 0, len(items))
	for _, item := range items {
		outItems = append(outItems, itemToWire(item))
	}
	outHandovers := make([]*mortuaryv1.Handover, 0, len(handovers))
	for _, handover := range handovers {
		outHandovers = append(outHandovers, handoverToWire(handover))
	}
	return connect.NewResponse(&mortuaryv1.GetBelongingsResponse{
		Items: outItems, Handovers: outHandovers,
	}), nil
}

func (h *Handler) GetChainOfCustody(ctx context.Context,
	req *connect.Request[mortuaryv1.GetChainOfCustodyRequest]) (
	*connect.Response[mortuaryv1.GetChainOfCustodyResponse], error) {

	entries, err := h.svc.Chain(ctx, req.Msg.GetCaseId())
	if err != nil {
		return nil, err
	}
	out := make([]*mortuaryv1.CustodyEntry, 0, len(entries))
	for _, entry := range entries {
		out = append(out, custodyToWire(entry))
	}
	return connect.NewResponse(&mortuaryv1.GetChainOfCustodyResponse{
		Entries: out,
	}), nil
}

// Postmortem (SRS-MORT-005).

func (h *Handler) RequestPostmortem(ctx context.Context,
	req *connect.Request[mortuaryv1.RequestPostmortemRequest]) (
	*connect.Response[mortuaryv1.RequestPostmortemResponse], error) {

	msg := req.Msg
	request, err := h.svc.RequestPostmortem(ctx,
		application.RequestPostmortemInput{
			CaseID: msg.GetCaseId(),
			Kind:   string(postmortemKindFromWire[msg.GetKind()]),
			Reason: msg.GetReason(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&mortuaryv1.RequestPostmortemResponse{
		Postmortem: postmortemToWire(request),
	}), nil
}

func (h *Handler) AdvancePostmortem(ctx context.Context,
	req *connect.Request[mortuaryv1.AdvancePostmortemRequest]) (
	*connect.Response[mortuaryv1.AdvancePostmortemResponse], error) {

	msg := req.Msg
	request, err := h.svc.AdvancePostmortem(ctx,
		application.AdvancePostmortemInput{
			PostmortemID:       msg.GetPostmortemId(),
			To:                 string(postmortemStateFromWire[msg.GetTo()]),
			Authority:          msg.GetAuthority(),
			AuthorityReference: msg.GetAuthorityReference(),
			Pathologist:        msg.GetPathologist(),
			ReportRef:          msg.GetReportRef(),
			Reason:             msg.GetReason(),
			Version:            msg.GetVersion(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&mortuaryv1.AdvancePostmortemResponse{
		Postmortem: postmortemToWire(request),
	}), nil
}

func (h *Handler) GetPostmortems(ctx context.Context,
	req *connect.Request[mortuaryv1.GetPostmortemsRequest]) (
	*connect.Response[mortuaryv1.GetPostmortemsResponse], error) {

	found, err := h.svc.Postmortems(ctx, req.Msg.GetCaseId())
	if err != nil {
		return nil, err
	}
	out := make([]*mortuaryv1.Postmortem, 0, len(found))
	for _, request := range found {
		out = append(out, postmortemToWire(request))
	}
	return connect.NewResponse(&mortuaryv1.GetPostmortemsResponse{
		Postmortems: out,
	}), nil
}

// Release (SRS-MORT-006, SRS-MORT-007).

func (h *Handler) RecordAuthorisation(ctx context.Context,
	req *connect.Request[mortuaryv1.RecordAuthorisationRequest]) (
	*connect.Response[mortuaryv1.RecordAuthorisationResponse], error) {

	msg := req.Msg
	auth, err := h.svc.RecordAuthorisation(ctx,
		application.RecordAuthorisationInput{
			CaseID: msg.GetCaseId(), Authority: msg.GetAuthority(),
			Reference: msg.GetReference(), Note: msg.GetNote(),
		})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&mortuaryv1.RecordAuthorisationResponse{
		Authorisation: authorisationToWire(auth),
	}), nil
}

func (h *Handler) GetReleaseChecks(ctx context.Context,
	req *connect.Request[mortuaryv1.GetReleaseChecksRequest]) (
	*connect.Response[mortuaryv1.GetReleaseChecksResponse], error) {

	checks, err := h.svc.ReleaseChecks(ctx, req.Msg.GetCaseId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&mortuaryv1.GetReleaseChecksResponse{
		Checks: checksToWire(checks),
	}), nil
}

func (h *Handler) ReleaseBody(ctx context.Context,
	req *connect.Request[mortuaryv1.ReleaseBodyRequest]) (
	*connect.Response[mortuaryv1.ReleaseBodyResponse], error) {

	msg := req.Msg
	release, err := h.svc.Release(ctx, application.ReleaseInput{
		CaseID:              msg.GetCaseId(),
		RecipientName:       msg.GetRecipientName(),
		RecipientRelation:   msg.GetRecipientRelation(),
		RecipientIDType:     msg.GetRecipientIdType(),
		RecipientIDRef:      msg.GetRecipientIdRef(),
		VerificationNote:    msg.GetVerificationNote(),
		SignatureRef:        msg.GetSignatureRef(),
		DeathCertificateRef: msg.GetDeathCertificateRef(),
		Destination:         msg.GetDestination(),
		WitnessedBy:         msg.GetWitnessedBy(), Note: msg.GetNote(),
		Version: msg.GetVersion(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&mortuaryv1.ReleaseBodyResponse{
		Release: releaseToWire(release),
	}), nil
}

func (h *Handler) GetRelease(ctx context.Context,
	req *connect.Request[mortuaryv1.GetReleaseRequest]) (
	*connect.Response[mortuaryv1.GetReleaseResponse], error) {

	release, err := h.svc.ReleaseRecord(ctx, req.Msg.GetCaseId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&mortuaryv1.GetReleaseResponse{
		Release: releaseToWire(release),
	}), nil
}

func (h *Handler) ListReleases(ctx context.Context,
	req *connect.Request[mortuaryv1.ListReleasesRequest]) (
	*connect.Response[mortuaryv1.ListReleasesResponse], error) {

	msg := req.Msg
	found, err := h.svc.ListReleases(ctx, application.ListReleasesInput{
		From: timeOf(msg.GetFrom()), To: timeOf(msg.GetTo()),
		PageSize: msg.GetPageSize(), Offset: msg.GetOffset(),
	})
	if err != nil {
		return nil, err
	}
	out := make([]*mortuaryv1.Release, 0, len(found))
	for _, release := range found {
		out = append(out, releaseToWire(release))
	}
	return connect.NewResponse(&mortuaryv1.ListReleasesResponse{
		Releases: out,
	}), nil
}

// The board (SRS-MORT-008).

func (h *Handler) GetBoard(ctx context.Context,
	req *connect.Request[mortuaryv1.GetBoardRequest]) (
	*connect.Response[mortuaryv1.GetBoardResponse], error) {

	report, err := h.svc.Board(ctx, req.Msg.GetFacilityId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&mortuaryv1.GetBoardResponse{
		Rows:      boardToWire(report.Rows),
		Occupancy: occupancyToWire(report.Occupancy),
		Truncated: report.Truncated,
	}), nil
}

func (h *Handler) SweepLongStay(ctx context.Context,
	req *connect.Request[mortuaryv1.SweepLongStayRequest]) (
	*connect.Response[mortuaryv1.SweepLongStayResponse], error) {

	raised, err := h.svc.SweepLongStay(ctx, req.Msg.GetFacilityId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&mortuaryv1.SweepLongStayResponse{
		Raised: int32(raised),
	}), nil
}
