// Package transport serves healthcare.medication.v1.MedicationService.
package transport

import (
	"context"

	"connectrpc.com/connect"
	medicationv1 "github.com/ppusapati/health/code/gen/go/healthcare/medication/v1"
	"github.com/ppusapati/health/code/internal/medication/application"
	"github.com/ppusapati/health/code/internal/medication/domain"
	platformtransport "github.com/ppusapati/health/code/internal/platform/transport"
)

// Handler serves healthcare.medication.v1.MedicationService.
type Handler struct {
	svc *application.Service
	// terminology writes the medication map. Separate from the service because
	// reading the map and publishing it are different jobs, and a deployment
	// whose terminology comes from a licensed drug database has nothing to
	// write.
	terminology application.TerminologyWriter
}

// NewHandler constructs the handler.
func NewHandler(svc *application.Service,
	terminology application.TerminologyWriter) *Handler {

	return &Handler{svc: svc, terminology: terminology}
}

func fail(ctx context.Context, err error) error {
	return platformtransport.ToConnect(err,
		platformtransport.CorrelationIDFromContext(ctx))
}

// Prescribe implements SRS-MED-001 … SRS-MED-004, SRS-MED-010 and SRS-MED-012.
//
// A prescription blocked by unanswered safety findings comes back as a
// FAILED_PRECONDITION carrying every finding, its rule and its rule version, so
// a client shows all of them at once. A prescriber who answers the first and
// then discovers a second stops reading the third.
func (h *Handler) Prescribe(
	ctx context.Context,
	req *connect.Request[medicationv1.PrescribeRequest],
) (*connect.Response[medicationv1.PrescribeResponse], error) {
	msg := req.Msg

	overrides := make([]application.OverrideInput, 0, len(msg.GetOverrides()))
	for _, o := range msg.GetOverrides() {
		overrides = append(overrides, application.OverrideInput{
			RuleID: o.GetRuleId(), Subject: codingFromProto(o.GetSubject()),
			Reason: o.GetReason(),
		})
	}

	stop := msg.GetStop()
	result, err := h.svc.Prescribe(ctx, application.PrescribeInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		Ingredient: codingFromProto(msg.GetIngredient()),
		Product:    codingFromProto(msg.GetProduct()),
		Route:      msg.GetRoute(),
		Segments:   segmentsFromProto(msg.GetSegments()),
		StartsAt:   fromTimestamp(msg.GetStartsAt()),
		Stop: domain.StopCondition{
			Kind:  stopKindFromProto[stop.GetKind()],
			At:    fromTimestamp(stop.GetAt()),
			Doses: int(stop.GetDoses()), Text: stop.GetText(),
		},
		Indication:     msg.GetIndication(),
		IndicationCode: codingFromProto(msg.GetIndicationCode()),
		Instructions:   msg.GetInstructions(),
		PRN:            prnFromProto(msg.GetPrn()),
		EnteredByID:    msg.GetEnteredById(),
		Overrides:      overrides,
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&medicationv1.PrescribeResponse{
		Prescription: prescriptionToProto(result.Prescription),
	}), nil
}

// GetPrescription reads one prescription.
func (h *Handler) GetPrescription(
	ctx context.Context,
	req *connect.Request[medicationv1.GetPrescriptionRequest],
) (*connect.Response[medicationv1.GetPrescriptionResponse], error) {
	p, err := h.svc.Get(ctx, req.Msg.GetPrescriptionId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&medicationv1.GetPrescriptionResponse{
		Prescription: prescriptionToProto(p),
	}), nil
}

// ListPrescriptions reads a visit's drug chart.
func (h *Handler) ListPrescriptions(
	ctx context.Context,
	req *connect.Request[medicationv1.ListPrescriptionsRequest],
) (*connect.Response[medicationv1.ListPrescriptionsResponse], error) {
	msg := req.Msg
	list, err := h.svc.Chart(ctx, msg.GetEncounterId(), msg.GetLiveOnly(),
		msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&medicationv1.ListPrescriptionsResponse{
		Prescriptions: prescriptionsToProto(list),
	}), nil
}

// HoldTherapy suspends a medication (SRS-MED-013).
func (h *Handler) HoldTherapy(
	ctx context.Context,
	req *connect.Request[medicationv1.HoldTherapyRequest],
) (*connect.Response[medicationv1.HoldTherapyResponse], error) {
	p, err := h.svc.Hold(ctx, changeFromProto(req.Msg.GetChange()))
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&medicationv1.HoldTherapyResponse{
		Prescription: prescriptionToProto(p),
	}), nil
}

// RestartTherapy resumes a held medication (SRS-MED-013).
func (h *Handler) RestartTherapy(
	ctx context.Context,
	req *connect.Request[medicationv1.RestartTherapyRequest],
) (*connect.Response[medicationv1.RestartTherapyResponse], error) {
	p, err := h.svc.Restart(ctx, changeFromProto(req.Msg.GetChange()))
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&medicationv1.RestartTherapyResponse{
		Prescription: prescriptionToProto(p),
	}), nil
}

// DiscontinueTherapy stops a medication for good (SRS-MED-013).
func (h *Handler) DiscontinueTherapy(
	ctx context.Context,
	req *connect.Request[medicationv1.DiscontinueTherapyRequest],
) (*connect.Response[medicationv1.DiscontinueTherapyResponse], error) {
	p, err := h.svc.Discontinue(ctx, changeFromProto(req.Msg.GetChange()))
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&medicationv1.DiscontinueTherapyResponse{
		Prescription: prescriptionToProto(p),
	}), nil
}

func changeFromProto(c *medicationv1.ChangeTherapyRequest) application.ChangeInput {
	return application.ChangeInput{
		PrescriptionID: c.GetPrescriptionId(), Reason: c.GetReason(),
		EffectiveAt: fromTimestamp(c.GetEffectiveAt()),
	}
}

// VerifyPrescription records the pharmacist's check (SRS-MED-006).
func (h *Handler) VerifyPrescription(
	ctx context.Context,
	req *connect.Request[medicationv1.VerifyPrescriptionRequest],
) (*connect.Response[medicationv1.VerifyPrescriptionResponse], error) {
	p, err := h.svc.Verify(ctx, req.Msg.GetPrescriptionId(), req.Msg.GetNote())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&medicationv1.VerifyPrescriptionResponse{
		Prescription: prescriptionToProto(p),
	}), nil
}

// VerificationQueue is the pharmacy worklist (SRS-MED-006).
func (h *Handler) VerificationQueue(
	ctx context.Context,
	req *connect.Request[medicationv1.VerificationQueueRequest],
) (*connect.Response[medicationv1.VerificationQueueResponse], error) {
	list, err := h.svc.VerificationQueue(ctx, req.Msg.GetFacilityId(),
		req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&medicationv1.VerificationQueueResponse{
		Prescriptions: prescriptionsToProto(list),
	}), nil
}

// DueDoses expands a visit's eligible prescriptions (SRS-MED-007).
func (h *Handler) DueDoses(
	ctx context.Context,
	req *connect.Request[medicationv1.DueDosesRequest],
) (*connect.Response[medicationv1.DueDosesResponse], error) {
	msg := req.Msg
	doses, err := h.svc.DueDoses(ctx, msg.GetEncounterId(),
		fromTimestamp(msg.GetFrom()), fromTimestamp(msg.GetTo()))
	if err != nil {
		return nil, fail(ctx, err)
	}

	out := make([]*medicationv1.DueDose, 0, len(doses))
	for _, dose := range doses {
		out = append(out, &medicationv1.DueDose{
			PrescriptionId: dose.PrescriptionID,
			ScheduledAt:    timestamp(dose.ScheduledAt),
			Segment:        segmentToProto(dose.Segment),
		})
	}
	return connect.NewResponse(&medicationv1.DueDosesResponse{Doses: out}), nil
}

// StartReconciliation opens a reconciliation pass (SRS-MED-005).
func (h *Handler) StartReconciliation(
	ctx context.Context,
	req *connect.Request[medicationv1.StartReconciliationRequest],
) (*connect.Response[medicationv1.StartReconciliationResponse], error) {
	msg := req.Msg
	r, err := h.svc.StartReconciliation(ctx, application.StartReconciliationInput{
		PatientID: msg.GetPatientId(), EncounterID: msg.GetEncounterId(),
		Event:           reconciliationEventFromProto[msg.GetEvent()],
		HomeMedications: reconciliationItemsFromProto(msg.GetHomeMedications()),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&medicationv1.StartReconciliationResponse{
		Reconciliation: reconciliationToProto(r),
	}), nil
}

// DecideReconciliation records one disposition (SRS-MED-005).
func (h *Handler) DecideReconciliation(
	ctx context.Context,
	req *connect.Request[medicationv1.DecideReconciliationRequest],
) (*connect.Response[medicationv1.DecideReconciliationResponse], error) {
	msg := req.Msg
	r, err := h.svc.Decide(ctx, application.DecideInput{
		ReconciliationID:        msg.GetReconciliationId(),
		Sequence:                int(msg.GetSequence()),
		Disposition:             dispositionFromProto[msg.GetDisposition()],
		Rationale:               msg.GetRationale(),
		ResultingPrescriptionID: msg.GetResultingPrescriptionId(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&medicationv1.DecideReconciliationResponse{
		Reconciliation: reconciliationToProto(r),
	}), nil
}

// CompleteReconciliation closes a pass (SRS-MED-005).
//
// Refused while anything is undecided, and the refusal names what: a clinician
// told "something is missing" goes hunting through the list.
func (h *Handler) CompleteReconciliation(
	ctx context.Context,
	req *connect.Request[medicationv1.CompleteReconciliationRequest],
) (*connect.Response[medicationv1.CompleteReconciliationResponse], error) {
	r, err := h.svc.CompleteReconciliation(ctx, req.Msg.GetReconciliationId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&medicationv1.CompleteReconciliationResponse{
		Reconciliation: reconciliationToProto(r),
	}), nil
}

// ListReconciliations reads a visit's passes.
func (h *Handler) ListReconciliations(
	ctx context.Context,
	req *connect.Request[medicationv1.ListReconciliationsRequest],
) (*connect.Response[medicationv1.ListReconciliationsResponse], error) {
	list, err := h.svc.Reconciliations(ctx, req.Msg.GetEncounterId(),
		req.Msg.GetPageSize())
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*medicationv1.Reconciliation, 0, len(list))
	for _, r := range list {
		out = append(out, reconciliationToProto(r))
	}
	return connect.NewResponse(&medicationv1.ListReconciliationsResponse{
		Reconciliations: out,
	}), nil
}

// ProposeSubstitution records a swap the pharmacy suggests (SRS-MED-011).
func (h *Handler) ProposeSubstitution(
	ctx context.Context,
	req *connect.Request[medicationv1.ProposeSubstitutionRequest],
) (*connect.Response[medicationv1.ProposeSubstitutionResponse], error) {
	msg := req.Msg
	sub, err := h.svc.ProposeSubstitution(ctx, application.ProposeSubstitutionInput{
		PrescriptionID: msg.GetPrescriptionId(),
		Dispensed:      codingFromProto(msg.GetDispensed()),
		Kind:           substitutionKindFromProto[msg.GetKind()],
		Reason:         msg.GetReason(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&medicationv1.ProposeSubstitutionResponse{
		Substitution: substitutionToProto(sub),
	}), nil
}

// AuthorizeSubstitution records who agreed to a swap (SRS-MED-011).
func (h *Handler) AuthorizeSubstitution(
	ctx context.Context,
	req *connect.Request[medicationv1.AuthorizeSubstitutionRequest],
) (*connect.Response[medicationv1.AuthorizeSubstitutionResponse], error) {
	sub, err := h.svc.AuthorizeSubstitution(ctx,
		req.Msg.GetAdvance().GetSubstitutionId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&medicationv1.AuthorizeSubstitutionResponse{
		Substitution: substitutionToProto(sub),
	}), nil
}

// RejectSubstitution records a refused proposal (SRS-MED-011).
func (h *Handler) RejectSubstitution(
	ctx context.Context,
	req *connect.Request[medicationv1.RejectSubstitutionRequest],
) (*connect.Response[medicationv1.RejectSubstitutionResponse], error) {
	advance := req.Msg.GetAdvance()
	sub, err := h.svc.RejectSubstitution(ctx, advance.GetSubstitutionId(),
		advance.GetReason())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&medicationv1.RejectSubstitutionResponse{
		Substitution: substitutionToProto(sub),
	}), nil
}

// DispenseSubstitution records the product that went to the ward
// (SRS-MED-011).
func (h *Handler) DispenseSubstitution(
	ctx context.Context,
	req *connect.Request[medicationv1.DispenseSubstitutionRequest],
) (*connect.Response[medicationv1.DispenseSubstitutionResponse], error) {
	sub, err := h.svc.DispenseSubstitution(ctx,
		req.Msg.GetAdvance().GetSubstitutionId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&medicationv1.DispenseSubstitutionResponse{
		Substitution: substitutionToProto(sub),
	}), nil
}

// ListSubstitutions reads the swaps recorded against a prescription.
func (h *Handler) ListSubstitutions(
	ctx context.Context,
	req *connect.Request[medicationv1.ListSubstitutionsRequest],
) (*connect.Response[medicationv1.ListSubstitutionsResponse], error) {
	list, err := h.svc.Substitutions(ctx, req.Msg.GetPrescriptionId())
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*medicationv1.Substitution, 0, len(list))
	for _, sub := range list {
		out = append(out, substitutionToProto(sub))
	}
	return connect.NewResponse(&medicationv1.ListSubstitutionsResponse{
		Substitutions: out,
	}), nil
}

// SetFormularyEntry records a medication's position in one scope
// (SRS-MED-012).
func (h *Handler) SetFormularyEntry(
	ctx context.Context,
	req *connect.Request[medicationv1.SetFormularyEntryRequest],
) (*connect.Response[medicationv1.SetFormularyEntryResponse], error) {
	entry := req.Msg.GetEntry()
	err := h.svc.SetFormularyEntry(ctx, domain.FormularyEntry{
		Medication:   codingFromProto(entry.GetMedication()),
		Scope:        domain.FormularyScopeKind(entry.GetScope()),
		ScopeID:      entry.GetScopeId(),
		Status:       formularyStatusFromProto[entry.GetStatus()],
		Restriction:  entry.GetRestriction(),
		ApprovalPath: entry.GetApprovalPath(),
	})
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&medicationv1.SetFormularyEntryResponse{}), nil
}

// SetInteractionRule publishes an interaction rule version (SRS-MED-003).
func (h *Handler) SetInteractionRule(
	ctx context.Context,
	req *connect.Request[medicationv1.SetInteractionRuleRequest],
) (*connect.Response[medicationv1.SetInteractionRuleResponse], error) {
	rule := req.Msg.GetRule()
	err := h.svc.SetInteractionRule(ctx, domain.InteractionRule{
		ID: rule.GetRuleId(), Version: rule.GetVersion(),
		Left: codingFromProto(rule.GetLeft()), Right: codingFromProto(rule.GetRight()),
		Severity: severityFromProto[rule.GetSeverity()],
		Advice:   rule.GetAdvice(), Management: rule.GetManagement(),
	}, rule.GetActive())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&medicationv1.SetInteractionRuleResponse{}), nil
}

// ListInteractionRules reads the active rules.
func (h *Handler) ListInteractionRules(
	ctx context.Context,
	req *connect.Request[medicationv1.ListInteractionRulesRequest],
) (*connect.Response[medicationv1.ListInteractionRulesResponse], error) {
	rules, err := h.svc.InteractionRules(ctx)
	if err != nil {
		return nil, fail(ctx, err)
	}
	out := make([]*medicationv1.InteractionRule, 0, len(rules))
	for _, rule := range rules {
		out = append(out, interactionRuleToProto(rule))
	}
	return connect.NewResponse(&medicationv1.ListInteractionRulesResponse{
		Rules: out,
	}), nil
}

// SetDoseRule publishes a dose-support rule version (SRS-MED-004).
func (h *Handler) SetDoseRule(
	ctx context.Context,
	req *connect.Request[medicationv1.SetDoseRuleRequest],
) (*connect.Response[medicationv1.SetDoseRuleResponse], error) {
	rule := req.Msg.GetRule()
	err := h.svc.SetDoseRule(ctx, domain.DoseRule{
		ID: rule.GetRuleId(), Version: rule.GetVersion(),
		Scope:                  doseScopeFromProto[rule.GetScope()],
		Medication:             codingFromProto(rule.GetMedication()),
		MaxCreatinineClearance: rule.GetMaxCreatinineClearance(),
		MaxAgeYears:            rule.GetMaxAgeYears(),
		Advice:                 rule.GetAdvice(),
		Validated:              rule.GetValidated(),
	}, rule.GetActive())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&medicationv1.SetDoseRuleResponse{}), nil
}

// SetTerminologyMapping records one medication's terminology (SRS-MED-002).
func (h *Handler) SetTerminologyMapping(
	ctx context.Context,
	req *connect.Request[medicationv1.SetTerminologyMappingRequest],
) (*connect.Response[medicationv1.SetTerminologyMappingResponse], error) {
	mapping := req.Msg.GetMapping()
	err := h.svc.SetTerminologyMapping(ctx, h.terminology,
		codingFromProto(mapping.GetMedication()),
		codingsFromProto(mapping.GetIngredients()),
		codingsFromProto(mapping.GetClasses()),
		codingFromProto(mapping.GetTherapeuticMoiety()),
		mapping.GetMapVersion())
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&medicationv1.SetTerminologyMappingResponse{}), nil
}

// SetMedicationPolicy records the tenant's configuration.
func (h *Handler) SetMedicationPolicy(
	ctx context.Context,
	req *connect.Request[medicationv1.SetMedicationPolicyRequest],
) (*connect.Response[medicationv1.SetMedicationPolicyResponse], error) {
	if err := h.svc.SetPolicy(ctx, policyFromProto(req.Msg.GetPolicy())); err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&medicationv1.SetMedicationPolicyResponse{}), nil
}

// GetMedicationPolicy reads the tenant's configuration.
func (h *Handler) GetMedicationPolicy(
	ctx context.Context,
	req *connect.Request[medicationv1.GetMedicationPolicyRequest],
) (*connect.Response[medicationv1.GetMedicationPolicyResponse], error) {
	p, err := h.svc.Policy(ctx)
	if err != nil {
		return nil, fail(ctx, err)
	}
	return connect.NewResponse(&medicationv1.GetMedicationPolicyResponse{
		Policy: policyToProto(p),
	}), nil
}
