package app_test

import (
	"context"
	"strings"
	"testing"

	empiv1 "github.com/ppusapati/health/code/gen/go/healthcare/empi/v1"
	"github.com/ppusapati/health/code/internal/empi/domain"
)

// Reconciliation and correction (SRS-EMPI-012, SRS-EMPI-017).
//
// Both requirements exist to prevent the same failure from two directions: a
// demographic value being replaced by one nobody checked, with nothing left
// recording what it used to say.
//
// For SRS-EMPI-012 the replacement comes from a machine. A registry returns a
// different birth date, the obvious implementation writes it, and by the time a
// clinician notices the chart does not match the patient, the trusted value is
// gone. For SRS-EMPI-017 it comes from a person: a correction applied by
// overwriting erases the value a result was filed against last month.
//
// The shared answer is that the change is held beside the current value until
// somebody with the authority to make it decides, and that the decision is kept
// whichever way it goes.

func proposalFor(t *testing.T, h *empiHarness, patientID string) *empiv1.DemographicProposal {
	t.Helper()

	listed, err := h.patients.ListDemographicProposals(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.ListDemographicProposalsRequest{
			PatientId: patientID,
		}))
	if err != nil {
		t.Fatalf("ListDemographicProposals: %v", err)
	}
	for _, p := range listed.Msg.GetProposals() {
		if p.GetStatus() == empiv1.ProposalStatus_PROPOSAL_STATUS_OPEN {
			return p
		}
	}
	t.Fatalf("no open proposal for patient %s: %+v", patientID, listed.Msg.GetProposals())
	return nil
}

func fieldOf(p *empiv1.DemographicProposal, field empiv1.DemographicField) *empiv1.ProposedFieldChange {
	for _, f := range p.GetFields() {
		if f.GetField() == field {
			return f
		}
	}
	return nil
}

// The core of SRS-EMPI-012: a feed that disagrees does not win.
func TestAnExternalSourceCannotOverwriteTheRecord(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"))

	submitted, err := h.patients.SubmitExternalDemographics(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.SubmitExternalDemographicsRequest{
			PatientId: patient.GetPatientId(),
			Demographics: demographics("Iyer", []string{"Meera"},
				date(1984, 12, 3), empiv1.Sex_SEX_FEMALE, "9876543210"),
			Source: "national registry",
		}))
	if err != nil {
		t.Fatalf("SubmitExternalDemographics: %v", err)
	}
	if !submitted.Msg.GetConflicted() {
		t.Fatal("a differing birth date was not reported as a conflict")
	}

	// The record is untouched. This is the whole requirement.
	current, err := h.patients.GetPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.GetPatientRequest{
			PatientId: patient.GetPatientId(),
		}))
	if err != nil {
		t.Fatalf("GetPatient: %v", err)
	}
	birth := current.Msg.GetPatient().GetDemographics().GetBirthDate().GetDate().AsTime()
	if birth.Day() != 12 || birth.Month() != 3 {
		t.Fatalf("the feed overwrote the birth date: %v", birth)
	}

	// And the conflicting value is held where a reviewer can see both sides.
	proposal := submitted.Msg.GetProposal()
	change := fieldOf(proposal, empiv1.DemographicField_DEMOGRAPHIC_FIELD_BIRTH_DATE)
	if change == nil {
		t.Fatalf("the proposal does not carry the disputed field: %+v", proposal.GetFields())
	}
	if change.GetCurrentValue() != "1984-03-12" || change.GetProposedValue() != "1984-12-03" {
		t.Fatalf("the proposal does not hold both sides: on file %q, proposed %q",
			change.GetCurrentValue(), change.GetProposedValue())
	}
}

// A source that agrees is not a queue item. If agreement produced work, the
// worklist would fill with nothing and a reviewer would stop reading it.
func TestASourceThatAgreesRaisesNothing(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"))

	submitted, err := h.patients.SubmitExternalDemographics(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.SubmitExternalDemographicsRequest{
			PatientId: patient.GetPatientId(),
			Demographics: demographics("Iyer", []string{"Meera"},
				date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "+91 98765 43210"),
			Source: "national registry",
		}))
	if err != nil {
		t.Fatalf("SubmitExternalDemographics: %v", err)
	}
	if submitted.Msg.GetConflicted() {
		t.Fatalf("agreement was reported as a conflict: %+v", submitted.Msg.GetProposal())
	}
}

// A nightly feed that keeps disagreeing is one conflict, not thirty. Thirty
// identical items is a queue a reviewer has stopped reading.
func TestARepeatedDisagreementRefreshesOneProposal(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"))

	submit := func() *empiv1.SubmitExternalDemographicsResponse {
		resp, err := h.patients.SubmitExternalDemographics(context.Background(),
			withFacility(h.himToken(), h.facility, &empiv1.SubmitExternalDemographicsRequest{
				PatientId: patient.GetPatientId(),
				Demographics: demographics("Iyer", []string{"Meera"},
					date(1984, 12, 3), empiv1.Sex_SEX_FEMALE, "9876543210"),
				Source: "national registry",
			}))
		if err != nil {
			t.Fatalf("SubmitExternalDemographics: %v", err)
		}
		return resp.Msg
	}

	first := submit()
	second := submit()
	third := submit()

	if !second.GetRefreshed() || !third.GetRefreshed() {
		t.Fatal("a repeated identical submission was not reported as a refresh")
	}
	if second.GetProposal().GetProposalId() != first.GetProposal().GetProposalId() {
		t.Fatal("a repeated identical submission created a second proposal")
	}

	listed, err := h.patients.ListDemographicProposals(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.ListDemographicProposalsRequest{}))
	if err != nil {
		t.Fatalf("ListDemographicProposals: %v", err)
	}
	open := 0
	for _, p := range listed.Msg.GetProposals() {
		if p.GetPatientId() == patient.GetPatientId() {
			open++
		}
	}
	if open != 1 {
		t.Fatalf("three identical submissions produced %d queue items", open)
	}
}

// The reason proposals are per field: a registry that agrees on the name and
// disagrees on the birth date offers one correction and one conflict.
func TestAReviewerTakesOneFieldAndRefusesAnother(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"))

	if _, err := h.patients.SubmitExternalDemographics(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.SubmitExternalDemographicsRequest{
			PatientId: patient.GetPatientId(),
			Demographics: demographics("Iyyer", []string{"Meera"},
				date(1984, 12, 3), empiv1.Sex_SEX_FEMALE, "9876543210"),
			Source: "national registry",
		})); err != nil {
		t.Fatalf("SubmitExternalDemographics: %v", err)
	}

	proposal := proposalFor(t, h, patient.GetPatientId())

	resolved, err := h.patients.ResolveDemographicProposal(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.ResolveDemographicProposalRequest{
			ProposalId: proposal.GetProposalId(),
			Accept: []empiv1.DemographicField{
				empiv1.DemographicField_DEMOGRAPHIC_FIELD_FAMILY_NAME,
			},
			Note: "spelling confirmed against the registry; birth date disagrees with the chart",
		}))
	if err != nil {
		t.Fatalf("ResolveDemographicProposal: %v", err)
	}

	applied := resolved.Msg.GetPatient()
	if got := applied.GetDemographics().GetName().GetFamily(); got != "Iyyer" {
		t.Fatalf("family name = %q, want the accepted correction", got)
	}
	birth := applied.GetDemographics().GetBirthDate().GetDate().AsTime()
	if birth.Day() != 12 || birth.Month() != 3 {
		t.Fatalf("the refused birth date was applied anyway: %v", birth)
	}

	// The decision is on the record, per field.
	name := fieldOf(resolved.Msg.GetProposal(), empiv1.DemographicField_DEMOGRAPHIC_FIELD_FAMILY_NAME)
	dob := fieldOf(resolved.Msg.GetProposal(), empiv1.DemographicField_DEMOGRAPHIC_FIELD_BIRTH_DATE)
	if name == nil || !name.GetAccepted() {
		t.Fatalf("the accepted field is not recorded as accepted: %+v", name)
	}
	if dob == nil || dob.GetAccepted() {
		t.Fatalf("the refused field is not recorded as refused: %+v", dob)
	}
}

// Applying a name through a proposal must keep the prior name searchable, the
// same as a clerk's edit does (SRS-EMPI-007). A path that wrote columns
// directly would silently skip the history.
func TestAnAcceptedNameChangeOpensAHistoryWindow(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"))

	if _, err := h.patients.SubmitExternalDemographics(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.SubmitExternalDemographicsRequest{
			PatientId: patient.GetPatientId(),
			Demographics: demographics("Rao", []string{"Meera"},
				date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"),
			Source: "national registry",
		})); err != nil {
		t.Fatalf("SubmitExternalDemographics: %v", err)
	}

	proposal := proposalFor(t, h, patient.GetPatientId())
	if _, err := h.patients.ResolveDemographicProposal(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.ResolveDemographicProposalRequest{
			ProposalId: proposal.GetProposalId(),
			Accept: []empiv1.DemographicField{
				empiv1.DemographicField_DEMOGRAPHIC_FIELD_FAMILY_NAME,
			},
			Note: "registry confirms the married name",
		})); err != nil {
		t.Fatalf("ResolveDemographicProposal: %v", err)
	}

	history := h.history(t, patient.GetPatientId())
	var closedMaidenName bool
	for _, n := range history.GetNames() {
		if n.GetName().GetFamily() == "Iyer" && n.GetWindow().GetUntil() != nil {
			closedMaidenName = true
		}
	}
	if !closedMaidenName {
		t.Fatalf("a name applied through a proposal did not close the previous "+
			"window, so the prior name is no longer searchable: %+v", history.GetNames())
	}
}

// A rejection is a decision and is kept. That a value was offered and refused
// is the answer when the same feed sends it again.
func TestARejectionIsKeptWithItsReason(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"))

	if _, err := h.patients.SubmitExternalDemographics(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.SubmitExternalDemographicsRequest{
			PatientId: patient.GetPatientId(),
			Demographics: demographics("Iyer", []string{"Meera"},
				date(1990, 1, 1), empiv1.Sex_SEX_FEMALE, "9876543210"),
			Source: "payer file",
		})); err != nil {
		t.Fatalf("SubmitExternalDemographics: %v", err)
	}

	proposal := proposalFor(t, h, patient.GetPatientId())
	const why = "the payer file is for a different member; birth date confirmed against the passport"

	resolved, err := h.patients.ResolveDemographicProposal(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.ResolveDemographicProposalRequest{
			ProposalId: proposal.GetProposalId(), Note: why,
		}))
	if err != nil {
		t.Fatalf("ResolveDemographicProposal: %v", err)
	}
	if resolved.Msg.GetProposal().GetStatus() != empiv1.ProposalStatus_PROPOSAL_STATUS_REJECTED {
		t.Fatalf("status = %v, want rejected", resolved.Msg.GetProposal().GetStatus())
	}

	// Still listed against the patient, with the reason, so the next arrival of
	// the same value is a pattern rather than a surprise.
	listed, err := h.patients.ListDemographicProposals(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.ListDemographicProposalsRequest{
			PatientId: patient.GetPatientId(),
		}))
	if err != nil {
		t.Fatalf("ListDemographicProposals: %v", err)
	}
	for _, p := range listed.Msg.GetProposals() {
		if p.GetProposalId() != proposal.GetProposalId() {
			continue
		}
		if !strings.Contains(p.GetResolutionNote(), "different member") {
			t.Fatalf("the rejection lost its reason: %q", p.GetResolutionNote())
		}
		if p.GetResolvedBy() == "" {
			t.Fatal("the rejection does not say who made it")
		}
		return
	}
	t.Fatal("a rejected proposal disappeared from the patient's history")
}

// Refusing everything is the decision that needs explaining most: the same
// value will arrive again, and the next reviewer needs to know this one was
// considered rather than missed.
func TestRejectingEverythingNeedsANoteOverTheWire(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"))

	if _, err := h.patients.SubmitExternalDemographics(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.SubmitExternalDemographicsRequest{
			PatientId: patient.GetPatientId(),
			Demographics: demographics("Iyer", []string{"Meera"},
				date(1990, 1, 1), empiv1.Sex_SEX_FEMALE, "9876543210"),
			Source: "payer file",
		})); err != nil {
		t.Fatalf("SubmitExternalDemographics: %v", err)
	}

	proposal := proposalFor(t, h, patient.GetPatientId())
	if _, err := h.patients.ResolveDemographicProposal(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.ResolveDemographicProposalRequest{
			ProposalId: proposal.GetProposalId(),
		})); err == nil {
		t.Fatal("a proposal was rejected in full with no reason recorded")
	}
}

// The failure mode the stale check exists for: a reviewer decides on a
// comparison, the record moves underneath, and accepting would overwrite a
// value nobody compared against — the silent overwrite SRS-EMPI-012 exists to
// prevent, arriving through the mechanism meant to prevent it.
func TestAProposalCannotBeAppliedAfterTheRecordMoved(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"))

	if _, err := h.patients.SubmitExternalDemographics(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.SubmitExternalDemographicsRequest{
			PatientId: patient.GetPatientId(),
			Demographics: demographics("Rao", []string{"Meera"},
				date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"),
			Source: "national registry",
		})); err != nil {
		t.Fatalf("SubmitExternalDemographics: %v", err)
	}
	proposal := proposalFor(t, h, patient.GetPatientId())

	// Meanwhile a clerk corrects something else entirely.
	current, err := h.patients.GetPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.GetPatientRequest{
			PatientId: patient.GetPatientId(),
		}))
	if err != nil {
		t.Fatalf("GetPatient: %v", err)
	}
	if _, err := h.patients.UpdateDemographics(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.UpdateDemographicsRequest{
			PatientId: patient.GetPatientId(),
			Demographics: demographics("Iyer", []string{"Meera"},
				date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9811111111"),
			ExpectedVersion: current.Msg.GetPatient().GetVersion(),
		})); err != nil {
		t.Fatalf("UpdateDemographics: %v", err)
	}

	_, err = h.patients.ResolveDemographicProposal(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.ResolveDemographicProposalRequest{
			ProposalId: proposal.GetProposalId(),
			Accept: []empiv1.DemographicField{
				empiv1.DemographicField_DEMOGRAPHIC_FIELD_FAMILY_NAME,
			},
			Note: "accepting a comparison that no longer holds",
		}))
	if err == nil {
		t.Fatal("a proposal was applied against a record that had moved since it was reviewed")
	}
	// It is superseded rather than left open, so nobody is shown the stale
	// comparison again.
	listed, err := h.patients.ListDemographicProposals(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.ListDemographicProposalsRequest{
			PatientId: patient.GetPatientId(),
		}))
	if err != nil {
		t.Fatalf("ListDemographicProposals: %v", err)
	}
	for _, p := range listed.Msg.GetProposals() {
		if p.GetProposalId() == proposal.GetProposalId() &&
			p.GetStatus() == empiv1.ProposalStatus_PROPOSAL_STATUS_OPEN {
			t.Fatal("a stale proposal is still shown as open work")
		}
	}
}

// SRS-EMPI-017: raising a request needs only read access, because the person
// asking is often the patient or somebody acting for them. Requiring the
// authority to make the change in order to ask for it would collapse the
// request and the approval into one act.
func TestACorrectionCanBeRequestedWithoutTheAuthorityToApplyIt(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"))

	// A clinician can read but not change demographics.
	requested, err := h.patients.RequestCorrection(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &empiv1.RequestCorrectionRequest{
			PatientId: patient.GetPatientId(),
			Demographics: demographics("Iyyer", []string{"Meera"},
				date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"),
			Reason: "spelling on the patient's passport",
		}))
	if err != nil {
		t.Fatalf("RequestCorrection: %v", err)
	}
	if requested.Msg.GetProposal().GetOrigin() !=
		empiv1.ProposalOrigin_PROPOSAL_ORIGIN_CORRECTION_REQUEST {
		t.Fatalf("origin = %v, want a correction request",
			requested.Msg.GetProposal().GetOrigin())
	}

	// But cannot decide it.
	_, err = h.patients.ResolveDemographicProposal(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &empiv1.ResolveDemographicProposalRequest{
			ProposalId: requested.Msg.GetProposal().GetProposalId(),
			Accept: []empiv1.DemographicField{
				empiv1.DemographicField_DEMOGRAPHIC_FIELD_FAMILY_NAME,
			},
		}))
	if err == nil {
		t.Fatal("the requester approved their own request with no authority to change demographics")
	}
	if detail := errorDetail(t, err); detail == nil || detail.GetCode() != "EMPI_RESOLVE_DENIED" {
		t.Fatalf("error code = %+v, want EMPI_RESOLVE_DENIED", detail)
	}

	// A clerk, who can, applies it — and the record changes.
	applied, err := h.patients.ResolveDemographicProposal(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.ResolveDemographicProposalRequest{
			ProposalId: requested.Msg.GetProposal().GetProposalId(),
			Accept: []empiv1.DemographicField{
				empiv1.DemographicField_DEMOGRAPHIC_FIELD_FAMILY_NAME,
			},
			Note: "passport sighted",
		}))
	if err != nil {
		t.Fatalf("ResolveDemographicProposal: %v", err)
	}
	if got := applied.Msg.GetPatient().GetDemographics().GetName().GetFamily(); got != "Iyyer" {
		t.Fatalf("family name = %q, want the approved correction", got)
	}
}

// "The spelling on my passport" and "I would prefer a different name" are
// different requests with the same proposed value.
func TestACorrectionRequestNeedsAReasonOverTheWire(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"))

	if _, err := h.patients.RequestCorrection(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &empiv1.RequestCorrectionRequest{
			PatientId: patient.GetPatientId(),
			Demographics: demographics("Iyyer", []string{"Meera"},
				date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"),
		})); err == nil {
		t.Fatal("a correction request was accepted with no reason")
	}
}

// Withdrawing and rejecting say different things about who decided the record
// is correct, so they are different acts by different people.
func TestOnlyTheRequesterMayWithdraw(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"))

	requested, err := h.patients.RequestCorrection(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &empiv1.RequestCorrectionRequest{
			PatientId: patient.GetPatientId(),
			Demographics: demographics("Iyyer", []string{"Meera"},
				date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"),
			Reason: "spelling on the patient's passport",
		}))
	if err != nil {
		t.Fatalf("RequestCorrection: %v", err)
	}
	proposalID := requested.Msg.GetProposal().GetProposalId()

	if _, err := h.patients.WithdrawDemographicProposal(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.WithdrawDemographicProposalRequest{
			ProposalId: proposalID, Note: "not mine to withdraw",
		})); err == nil {
		t.Fatal("somebody other than the requester withdrew a correction request")
	}

	withdrawn, err := h.patients.WithdrawDemographicProposal(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &empiv1.WithdrawDemographicProposalRequest{
			ProposalId: proposalID, Note: "the patient corrected themselves",
		}))
	if err != nil {
		t.Fatalf("WithdrawDemographicProposal: %v", err)
	}
	if withdrawn.Msg.GetProposal().GetStatus() != empiv1.ProposalStatus_PROPOSAL_STATUS_WITHDRAWN {
		t.Fatalf("status = %v, want withdrawn", withdrawn.Msg.GetProposal().GetStatus())
	}
}

// The route a conflict is most likely to arrive by: an identifier is linked and
// the issuing authority disagrees about whose it is.
func TestVerifyingAnIdentifierRaisesADemographicConflict(t *testing.T) {
	dev := abhaRegistry(t)
	dev.Seed("12-3456-7890-0100", domain.Verification{
		Verified: true, AssigningAuthority: "ABDM",
		HasDemographics: true,
		Demographics: domain.Demographics{
			Name:      domain.HumanName{Family: "Iyer", Given: []string{"Meera"}},
			BirthDate: domain.BirthDate{Date: date(1984, 12, 3), Precision: domain.PrecisionDay},
			Sex:       domain.SexFemale,
		},
	})
	h := newEmpiHarnessWith(t, registrySet(t, dev))

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"))

	linked, err := h.patients.LinkIdentifier(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.LinkIdentifierRequest{
			PatientId: patient.GetPatientId(),
			Type:      empiv1.IdentifierType_IDENTIFIER_TYPE_NATIONAL_HEALTH,
			System:    abhaSystem, Value: "12-3456-7890-0100",
			Source: "registration desk", Verify: true,
		}))
	if err != nil {
		t.Fatalf("LinkIdentifier: %v", err)
	}

	if linked.Msg.GetConflictProposalId() == "" {
		t.Fatal("the authority's differing birth date raised no reconciliation proposal")
	}

	// The identifier is linked and verified; the demographics are not touched.
	if got := linked.Msg.GetIdentifier().GetAssurance(); got != empiv1.IdentifierAssurance_IDENTIFIER_ASSURANCE_VERIFIED {
		t.Fatalf("assurance = %v, want verified", got)
	}
	current, err := h.patients.GetPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.GetPatientRequest{
			PatientId: patient.GetPatientId(),
		}))
	if err != nil {
		t.Fatalf("GetPatient: %v", err)
	}
	birth := current.Msg.GetPatient().GetDemographics().GetBirthDate().GetDate().AsTime()
	if birth.Day() != 12 || birth.Month() != 3 {
		t.Fatalf("verifying an identifier overwrote the birth date: %v", birth)
	}
}

// Submitting a feed must not be a way to change demographics without the
// permission to change them.
func TestSubmittingAFeedNeedsMoreThanReadAccess(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"))

	_, err := h.patients.SubmitExternalDemographics(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &empiv1.SubmitExternalDemographicsRequest{
			PatientId: patient.GetPatientId(),
			Demographics: demographics("Rao", []string{"Meera"},
				date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"),
			Source: "national registry",
		}))
	if err == nil {
		t.Fatal("a reader submitted an external feed")
	}
	if detail := errorDetail(t, err); detail == nil || detail.GetCode() != "EMPI_SUBMIT_DENIED" {
		t.Fatalf("error code = %+v, want EMPI_SUBMIT_DENIED", detail)
	}
}

// A proposal cannot be reached across a tenant boundary, and the refusal must
// not confirm that the proposal exists.
func TestAProposalCannotBeResolvedFromAnotherTenant(t *testing.T) {
	h := newEmpiHarness(t)
	neighbour := h.provisionNeighbour(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"))

	if _, err := h.patients.SubmitExternalDemographics(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.SubmitExternalDemographicsRequest{
			PatientId: patient.GetPatientId(),
			Demographics: demographics("Rao", []string{"Meera"},
				date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, "9876543210"),
			Source: "national registry",
		})); err != nil {
		t.Fatalf("SubmitExternalDemographics: %v", err)
	}
	proposal := proposalFor(t, h, patient.GetPatientId())

	_, err := h.patients.ResolveDemographicProposal(context.Background(),
		withFacility(neighbour.tenantID+":clerk-2:registration_clerk:"+neighbour.facility,
			neighbour.facility, &empiv1.ResolveDemographicProposalRequest{
				ProposalId: proposal.GetProposalId(),
				Accept: []empiv1.DemographicField{
					empiv1.DemographicField_DEMOGRAPHIC_FIELD_FAMILY_NAME,
				},
				Note: "not mine to decide",
			}))
	if err == nil {
		t.Fatal("a neighbouring tenant resolved this tenant's proposal")
	}
	if detail := errorDetail(t, err); detail == nil ||
		!strings.Contains(detail.GetCode(), "NOT_FOUND") {
		t.Fatalf("error code = %+v, want a not-found; anything else confirms the "+
			"proposal exists in another tenant", detail)
	}
}
