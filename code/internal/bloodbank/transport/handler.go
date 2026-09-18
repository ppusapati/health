package transport

import (
	"context"
	"time"

	"connectrpc.com/connect"

	bloodbankv1 "github.com/ppusapati/health/code/gen/go/healthcare/bloodbank/v1"
	"github.com/ppusapati/health/code/internal/bloodbank/application"
	"github.com/ppusapati/health/code/internal/bloodbank/domain"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Handler is the blood bank ConnectRPC surface.
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
// The clock is injected because several responses derive a state at the moment
// of rendering rather than storing it: whether a unit is issuable, and whether
// a donor's temporary deferral has lapsed. A donor still deferred because
// nobody ran a job is a donor turned away for no reason.
func NewHandler(svc *application.Service, now func() time.Time) *Handler {
	if now == nil {
		now = time.Now
	}
	return &Handler{svc: svc, now: now}
}

func (h *Handler) RegisterDonor(ctx context.Context,
	req *connect.Request[bloodbankv1.RegisterDonorRequest]) (
	*connect.Response[bloodbankv1.RegisterDonorResponse], error) {

	msg := req.Msg
	donor, err := h.svc.RegisterDonor(ctx, domain.NewDonorInput{
		DonorNumber: msg.GetDonorNumber(), PatientID: msg.GetPatientId(),
		Name: msg.GetDisplayName(), ContactPhone: msg.GetContactPhone(),
		Group: groupFromProto(msg.GetGroup()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.RegisterDonorResponse{
		Donor: donorToProto(donor, h.now()),
	}), nil
}

func (h *Handler) GetDonor(ctx context.Context,
	req *connect.Request[bloodbankv1.GetDonorRequest]) (
	*connect.Response[bloodbankv1.GetDonorResponse], error) {

	donor, err := h.svc.Donor(ctx, req.Msg.GetDonorId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.GetDonorResponse{
		Donor: donorToProto(donor, h.now()),
	}), nil
}

func (h *Handler) DeferDonor(ctx context.Context,
	req *connect.Request[bloodbankv1.DeferDonorRequest]) (
	*connect.Response[bloodbankv1.DeferDonorResponse], error) {

	msg := req.Msg
	donor, err := h.svc.DeferDonor(ctx, msg.GetDonorId(),
		deferralFromWire[msg.GetKind()], msg.GetCode(), msg.GetNote(),
		timeOf(msg.GetUntil()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.DeferDonorResponse{
		Donor: donorToProto(donor, h.now()),
	}), nil
}

func (h *Handler) ReinstateDonor(ctx context.Context,
	req *connect.Request[bloodbankv1.ReinstateDonorRequest]) (
	*connect.Response[bloodbankv1.ReinstateDonorResponse], error) {

	donor, err := h.svc.ReinstateDonor(ctx,
		req.Msg.GetDonorId(), req.Msg.GetReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.ReinstateDonorResponse{
		Donor: donorToProto(donor, h.now()),
	}), nil
}

func (h *Handler) ListDeferredDonors(ctx context.Context,
	req *connect.Request[bloodbankv1.ListDeferredDonorsRequest]) (
	*connect.Response[bloodbankv1.ListDeferredDonorsResponse], error) {

	donors, err := h.svc.DeferredDonors(ctx, req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	now := h.now()
	out := make([]*bloodbankv1.Donor, 0, len(donors))
	for _, donor := range donors {
		out = append(out, donorToProto(donor, now))
	}
	return connect.NewResponse(&bloodbankv1.ListDeferredDonorsResponse{
		Donors: out,
	}), nil
}

func (h *Handler) ScreenDonor(ctx context.Context,
	req *connect.Request[bloodbankv1.ScreenDonorRequest]) (
	*connect.Response[bloodbankv1.ScreenDonorResponse], error) {

	msg := req.Msg
	screening, err := h.svc.ScreenDonor(ctx, domain.NewScreeningInput{
		DonorID: msg.GetDonorId(),
		Answers: msg.GetAnswers(), Measurements: msg.GetMeasurements(),
		Consented: msg.GetConsented(), ConsentNote: msg.GetConsentNote(),
		Accepted:     msg.GetAccepted(),
		Deferral:     deferralFromWire[msg.GetDeferral()],
		DeferralCode: msg.GetDeferralCode(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.ScreenDonorResponse{
		Screening: screeningToProto(screening),
	}), nil
}

func (h *Handler) Collect(ctx context.Context,
	req *connect.Request[bloodbankv1.CollectRequest]) (
	*connect.Response[bloodbankv1.CollectResponse], error) {

	msg := req.Msg
	collection, err := h.svc.Collect(ctx, domain.NewCollectionInput{
		DonorID: msg.GetDonorId(), ScreeningID: msg.GetScreeningId(),
		DonationNumber: msg.GetDonationNumber(), Kind: msg.GetKind(),
		VolumeML:     int(msg.GetVolumeMl()),
		Group:        groupFromProto(msg.GetGroup()),
		AdverseEvent: msg.GetAdverseEvent(), AdverseNote: msg.GetAdverseNote(),
	}, msg.GetDonorId(), msg.GetScreeningId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.CollectResponse{
		Collection: collectionToProto(collection),
	}), nil
}

func (h *Handler) RecordTest(ctx context.Context,
	req *connect.Request[bloodbankv1.RecordTestRequest]) (
	*connect.Response[bloodbankv1.RecordTestResponse], error) {

	msg := req.Msg
	result, err := h.svc.RecordTest(ctx, msg.GetCollectionId(), msg.GetCode(),
		msg.GetDisplay(), msg.GetValue(), msg.GetMethod(), msg.GetReactive())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.RecordTestResponse{
		Result: testResultToProto(result),
	}), nil
}

func (h *Handler) GetReleaseDecision(ctx context.Context,
	req *connect.Request[bloodbankv1.GetReleaseDecisionRequest]) (
	*connect.Response[bloodbankv1.GetReleaseDecisionResponse], error) {

	decision, err := h.svc.ReleaseDecision(ctx, req.Msg.GetCollectionId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.GetReleaseDecisionResponse{
		Decision: &bloodbankv1.ReleaseDecision{
			Releasable: decision.Releasable,
			Missing:    decision.Missing, Reactive: decision.Reactive,
		},
	}), nil
}

func (h *Handler) ReleaseComponents(ctx context.Context,
	req *connect.Request[bloodbankv1.ReleaseComponentsRequest]) (
	*connect.Response[bloodbankv1.ReleaseComponentsResponse], error) {

	components, err := h.svc.ReleaseComponents(ctx, req.Msg.GetCollectionId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.ReleaseComponentsResponse{
		Components: componentsToProto(components, h.now()),
	}), nil
}

func (h *Handler) AddComponent(ctx context.Context,
	req *connect.Request[bloodbankv1.AddComponentRequest]) (
	*connect.Response[bloodbankv1.AddComponentResponse], error) {

	msg := req.Msg
	component, err := h.svc.AddComponent(ctx, domain.NewComponentInput{
		UnitNumber: msg.GetUnitNumber(), CollectionID: msg.GetCollectionId(),
		DonorID: msg.GetDonorId(), Source: msg.GetSource(),
		Class:      componentClass(msg.GetComponentClass()),
		Group:      groupFromProto(msg.GetGroup()),
		VolumeML:   int(msg.GetVolumeMl()),
		Attributes: msg.GetAttributes(), Location: msg.GetLocation(),
		CollectedAt: timeOf(msg.GetCollectedAt()),
		ExpiresAt:   timeOf(msg.GetExpiresAt()),
		Released:    msg.GetReleased(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.AddComponentResponse{
		Component: componentToProto(component, h.now()),
	}), nil
}

func (h *Handler) GetComponent(ctx context.Context,
	req *connect.Request[bloodbankv1.GetComponentRequest]) (
	*connect.Response[bloodbankv1.GetComponentResponse], error) {

	var component domain.Component
	var err error
	switch {
	case req.Msg.GetComponentId() != "":
		component, err = h.svc.Component(ctx, req.Msg.GetComponentId())
	case req.Msg.GetUnitNumber() != "":
		// What a bedside scan has: the number on the label.
		component, err = h.svc.ComponentByNumber(ctx, req.Msg.GetUnitNumber())
	default:
		return nil, rpcerr.Invalid("BLD_INVALID",
			"name the unit by its id or by the number on its label")
	}
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.GetComponentResponse{
		Component: componentToProto(component, h.now()),
	}), nil
}

func (h *Handler) DiscardComponent(ctx context.Context,
	req *connect.Request[bloodbankv1.DiscardComponentRequest]) (
	*connect.Response[bloodbankv1.DiscardComponentResponse], error) {

	component, err := h.svc.DiscardComponent(ctx, req.Msg.GetComponentId(),
		discardFromWire[req.Msg.GetReason()])
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.DiscardComponentResponse{
		Component: componentToProto(component, h.now()),
	}), nil
}

func (h *Handler) PlaceRequest(ctx context.Context,
	req *connect.Request[bloodbankv1.PlaceRequestRequest]) (
	*connect.Response[bloodbankv1.PlaceRequestResponse], error) {

	msg := req.Msg
	placed, err := h.svc.PlaceRequest(ctx, domain.NewRequestInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		FacilityID: msg.GetFacilityId(),
		Class:      componentClass(msg.GetComponentClass()),
		Quantity:   int(msg.GetQuantity()), Indication: msg.GetIndication(),
		Urgency:      urgency(msg.GetUrgency()),
		Requirements: msg.GetRequirements(),
		RequiredBy:   timeOf(msg.GetRequiredBy()),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.PlaceRequestResponse{
		Request: requestToProto(placed),
	}), nil
}

func (h *Handler) GetWorklist(ctx context.Context,
	req *connect.Request[bloodbankv1.GetWorklistRequest]) (
	*connect.Response[bloodbankv1.GetWorklistResponse], error) {

	requests, err := h.svc.Worklist(ctx,
		req.Msg.GetFacilityId(), req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.GetWorklistResponse{
		Requests: requestsToProto(requests),
	}), nil
}

func (h *Handler) ListPatientRequests(ctx context.Context,
	req *connect.Request[bloodbankv1.ListPatientRequestsRequest]) (
	*connect.Response[bloodbankv1.ListPatientRequestsResponse], error) {

	requests, err := h.svc.PatientRequests(ctx,
		req.Msg.GetPatientId(), req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.ListPatientRequestsResponse{
		Requests: requestsToProto(requests),
	}), nil
}

func (h *Handler) GroupPatient(ctx context.Context,
	req *connect.Request[bloodbankv1.GroupPatientRequest]) (
	*connect.Response[bloodbankv1.GroupPatientResponse], error) {

	msg := req.Msg
	sample, err := h.svc.GroupPatient(ctx, domain.NewSampleInput{
		PatientID: msg.GetPatientId(), SampleNumber: msg.GetSampleNumber(),
		Group:                  groupFromProto(msg.GetGroup()),
		AntibodyScreenPositive: msg.GetAntibodyScreenPositive(),
		AntibodyNote:           msg.GetAntibodyNote(),
		SecondCheck:            msg.GetSecondCheck(),
		CollectedAt:            timeOf(msg.GetCollectedAt()),
		CollectedBy:            msg.GetCollectedBy(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.GroupPatientResponse{
		Sample: sampleToProto(sample),
	}), nil
}

func (h *Handler) FindCompatible(ctx context.Context,
	req *connect.Request[bloodbankv1.FindCompatibleRequest]) (
	*connect.Response[bloodbankv1.FindCompatibleResponse], error) {

	candidates, err := h.svc.FindCompatible(ctx,
		req.Msg.GetRequestId(), req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	now := h.now()
	out := make([]*bloodbankv1.Candidate, 0, len(candidates))
	for _, candidate := range candidates {
		out = append(out, &bloodbankv1.Candidate{
			Component: componentToProto(candidate.Component, now),
			// Every candidate carries its verdict, so a near-miss is visible
			// rather than silently absent.
			Decision: matchDecisionToProto(candidate.Decision),
		})
	}
	return connect.NewResponse(&bloodbankv1.FindCompatibleResponse{
		Candidates: out,
	}), nil
}

func (h *Handler) Reserve(ctx context.Context,
	req *connect.Request[bloodbankv1.ReserveRequest]) (
	*connect.Response[bloodbankv1.ReserveResponse], error) {

	msg := req.Msg
	reservation, err := h.svc.Reserve(ctx, msg.GetRequestId(),
		msg.GetComponentId(), msg.GetCrossmatched(), msg.GetNote())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.ReserveResponse{
		Reservation: reservationToProto(reservation),
	}), nil
}

func (h *Handler) ReleaseReservation(ctx context.Context,
	req *connect.Request[bloodbankv1.ReleaseReservationRequest]) (
	*connect.Response[bloodbankv1.ReleaseReservationResponse], error) {

	if err := h.svc.ReleaseReservation(ctx,
		req.Msg.GetReservationId(), req.Msg.GetReason()); err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.ReleaseReservationResponse{}), nil
}

func (h *Handler) SweepLapsedReservations(ctx context.Context,
	req *connect.Request[bloodbankv1.SweepLapsedReservationsRequest]) (
	*connect.Response[bloodbankv1.SweepLapsedReservationsResponse], error) {

	swept, err := h.svc.SweepLapsedReservations(ctx, req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.SweepLapsedReservationsResponse{
		Swept: int32(swept),
	}), nil
}

func (h *Handler) IssueUnit(ctx context.Context,
	req *connect.Request[bloodbankv1.IssueUnitRequest]) (
	*connect.Response[bloodbankv1.IssueUnitResponse], error) {

	msg := req.Msg
	issue, err := h.svc.IssueUnit(ctx, application.IssueInput{
		ComponentID:   msg.GetComponentId(),
		ReservationID: msg.GetReservationId(),
		Destination:   msg.GetDestination(), IssuedTo: msg.GetIssuedTo(),
		CheckUnitNumber:     msg.GetCheckUnitNumber(),
		CheckPatientID:      msg.GetCheckPatientId(),
		Emergency:           msg.GetEmergency(),
		EmergencyAuthoriser: msg.GetEmergencyAuthoriser(),
		EmergencyReason:     msg.GetEmergencyReason(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.IssueUnitResponse{
		Issue: issueToProto(issue),
	}), nil
}

func (h *Handler) ReconcileRelease(ctx context.Context,
	req *connect.Request[bloodbankv1.ReconcileReleaseRequest]) (
	*connect.Response[bloodbankv1.ReconcileReleaseResponse], error) {

	if err := h.svc.ReconcileRelease(ctx,
		req.Msg.GetIssueId(), req.Msg.GetNote()); err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.ReconcileReleaseResponse{}), nil
}

func (h *Handler) ListOutstandingReleases(ctx context.Context,
	req *connect.Request[bloodbankv1.ListOutstandingReleasesRequest]) (
	*connect.Response[bloodbankv1.ListOutstandingReleasesResponse], error) {

	issues, err := h.svc.OutstandingReleases(ctx, req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.ListOutstandingReleasesResponse{
		Issues: issuesToProto(issues),
	}), nil
}

func bedsideInput(in *bloodbankv1.BedsideCheck) application.BedsideInput {
	if in == nil {
		return application.BedsideInput{}
	}
	return application.BedsideInput{
		UnitNumber: in.GetUnitNumber(), PatientID: in.GetPatientId(),
		PatientGroup: groupFromProto(in.GetPatientGroup()),
		UnitGroup:    groupFromProto(in.GetUnitGroup()),
		CheckedWith:  in.GetCheckedWith(),
		EncounterID:  in.GetEncounterId(),
		Baseline:     in.GetBaseline(),
	}
}

func (h *Handler) VerifyBedside(ctx context.Context,
	req *connect.Request[bloodbankv1.VerifyBedsideRequest]) (
	*connect.Response[bloodbankv1.VerifyBedsideResponse], error) {

	refusals, err := h.svc.VerifyBedside(ctx, bedsideInput(req.Msg.GetCheck()))
	if err != nil {
		return nil, err
	}

	wire := make([]bloodbankv1.BedsideRefusal, 0, len(refusals))
	explanations := make([]string, 0, len(refusals))
	for _, refusal := range refusals {
		wire = append(wire, bedsideRefusalToWire[refusal])
		explanations = append(explanations, refusal.Explain())
	}
	return connect.NewResponse(&bloodbankv1.VerifyBedsideResponse{
		Passed: len(refusals) == 0, Refusals: wire, Explanations: explanations,
	}), nil
}

func (h *Handler) StartTransfusion(ctx context.Context,
	req *connect.Request[bloodbankv1.StartTransfusionRequest]) (
	*connect.Response[bloodbankv1.StartTransfusionResponse], error) {

	episode, err := h.svc.StartTransfusion(ctx, bedsideInput(req.Msg.GetCheck()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.StartTransfusionResponse{
		Episode: episodeToProto(episode),
	}), nil
}

func (h *Handler) Observe(ctx context.Context,
	req *connect.Request[bloodbankv1.ObserveRequest]) (
	*connect.Response[bloodbankv1.ObserveResponse], error) {

	msg := req.Msg
	observation, err := h.svc.Observe(ctx, msg.GetEpisodeId(), msg.GetTiming(),
		msg.GetValues(), msg.GetNote())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.ObserveResponse{
		Observation: observationToProto(observation),
	}), nil
}

func (h *Handler) EndTransfusion(ctx context.Context,
	req *connect.Request[bloodbankv1.EndTransfusionRequest]) (
	*connect.Response[bloodbankv1.EndTransfusionResponse], error) {

	msg := req.Msg
	episode, err := h.svc.EndTransfusion(ctx, msg.GetEpisodeId(),
		int(msg.GetVolumeGivenMl()), msg.GetStopReason())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.EndTransfusionResponse{
		Episode: episodeToProto(episode),
	}), nil
}

func (h *Handler) GetEpisode(ctx context.Context,
	req *connect.Request[bloodbankv1.GetEpisodeRequest]) (
	*connect.Response[bloodbankv1.GetEpisodeResponse], error) {

	episode, missing, err := h.svc.Episode(ctx, req.Msg.GetEpisodeId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.GetEpisodeResponse{
		Episode: episodeToProto(episode),
		// Named rather than blocking: a nurse who has not taken the
		// fifteen-minute set is a nurse who is fifteen minutes in.
		MissingObservations: missing,
	}), nil
}

func (h *Handler) ListPatientTransfusions(ctx context.Context,
	req *connect.Request[bloodbankv1.ListPatientTransfusionsRequest]) (
	*connect.Response[bloodbankv1.ListPatientTransfusionsResponse], error) {

	episodes, err := h.svc.PatientTransfusions(ctx,
		req.Msg.GetPatientId(), req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.ListPatientTransfusionsResponse{
		Episodes: episodesToProto(episodes),
	}), nil
}

func (h *Handler) ReportReaction(ctx context.Context,
	req *connect.Request[bloodbankv1.ReportReactionRequest]) (
	*connect.Response[bloodbankv1.ReportReactionResponse], error) {

	msg := req.Msg
	reaction, err := h.svc.ReportReaction(ctx, domain.NewReactionInput{
		EpisodeID: msg.GetEpisodeId(), ComponentID: msg.GetComponentId(),
		PatientID: msg.GetPatientId(),
		Severity:  severityFromWire[msg.GetSeverity()],
		Features:  msg.GetFeatures(), Note: msg.GetNote(),
	})
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.ReportReactionResponse{
		Reaction: reactionToProto(reaction),
	}), nil
}

func (h *Handler) ConcludeInvestigation(ctx context.Context,
	req *connect.Request[bloodbankv1.ConcludeInvestigationRequest]) (
	*connect.Response[bloodbankv1.ConcludeInvestigationResponse], error) {

	msg := req.Msg
	reaction, err := h.svc.ConcludeInvestigation(ctx, msg.GetReactionId(),
		msg.GetClassification(), msg.GetConclusion(), msg.GetUnitReturned())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.ConcludeInvestigationResponse{
		Reaction: reactionToProto(reaction),
	}), nil
}

func (h *Handler) ListOpenInvestigations(ctx context.Context,
	req *connect.Request[bloodbankv1.ListOpenInvestigationsRequest]) (
	*connect.Response[bloodbankv1.ListOpenInvestigationsResponse], error) {

	reactions, err := h.svc.OpenInvestigations(ctx, req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.ListOpenInvestigationsResponse{
		Reactions: reactionsToProto(reactions),
	}), nil
}

func (h *Handler) TraceUnit(ctx context.Context,
	req *connect.Request[bloodbankv1.TraceUnitRequest]) (
	*connect.Response[bloodbankv1.TraceUnitResponse], error) {

	chain, err := h.svc.TraceUnit(ctx, req.Msg.GetComponentId())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.TraceUnitResponse{
		Chain: chainToProto(chain),
	}), nil
}

func (h *Handler) LookBack(ctx context.Context,
	req *connect.Request[bloodbankv1.LookBackRequest]) (
	*connect.Response[bloodbankv1.LookBackResponse], error) {

	recipients, err := h.svc.LookBack(ctx,
		req.Msg.GetDonorId(), req.Msg.GetPageSize())
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.LookBackResponse{
		Recipients: recipientsToProto(recipients),
	}), nil
}

func (h *Handler) SetThreshold(ctx context.Context,
	req *connect.Request[bloodbankv1.SetThresholdRequest]) (
	*connect.Response[bloodbankv1.SetThresholdResponse], error) {

	threshold := req.Msg.GetThreshold()
	if threshold == nil {
		return nil, rpcerr.Invalid("BLD_INVALID", "a threshold names what it is for")
	}
	if err := h.svc.SetThreshold(ctx, req.Msg.GetFacilityId(),
		domain.StockThreshold{
			Class:   componentClass(threshold.GetComponentClass()),
			Group:   groupFromProto(threshold.GetGroup()),
			Minimum: int(threshold.GetMinimum()),
		}); err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.SetThresholdResponse{}), nil
}

func (h *Handler) GetStock(ctx context.Context,
	req *connect.Request[bloodbankv1.GetStockRequest]) (
	*connect.Response[bloodbankv1.GetStockResponse], error) {

	levels, alerts, err := h.svc.Stock(ctx, req.Msg.GetFacilityId())
	if err != nil {
		return nil, err
	}
	wireLevels, wireAlerts := stockToProto(levels, alerts)
	return connect.NewResponse(&bloodbankv1.GetStockResponse{
		Levels: wireLevels, Alerts: wireAlerts,
	}), nil
}

func (h *Handler) GetUtilisation(ctx context.Context,
	req *connect.Request[bloodbankv1.GetUtilisationRequest]) (
	*connect.Response[bloodbankv1.GetUtilisationResponse], error) {

	report, err := h.svc.Utilisation(ctx,
		timeOf(req.Msg.GetPeriodStart()), timeOf(req.Msg.GetPeriodEnd()))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&bloodbankv1.GetUtilisationResponse{
		Utilisation: utilisationToProto(report),
	}), nil
}
