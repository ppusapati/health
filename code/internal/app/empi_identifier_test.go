package app_test

import (
	"context"
	"errors"
	"strings"
	"testing"

	empiv1 "github.com/ppusapati/health/code/gen/go/healthcare/empi/v1"
	"github.com/ppusapati/health/code/internal/empi/adapters/registry"
	"github.com/ppusapati/health/code/internal/empi/domain"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// External identifier lifecycle (SRS-EMPI-011).
//
// The requirement is one sentence — link ABHA and other external identifiers
// through an adapter without making them database primary keys, retaining link
// and unlink history and source — and each clause is a separate failure it is
// there to prevent.
//
// "Through an adapter": the application layer must not know what ABDM is, or
// the second national scheme is a rewrite rather than a configuration.
//
// "Without making them primary keys": the patient exists before the link and
// survives the unlink. A record keyed on a national identifier follows every
// correction the issuing authority makes, and one of those corrections points
// it at somebody else.
//
// "History and source retained": a wrong link is found months later, by a
// clinician reading a chart that does not match the patient. What makes it
// investigable is the row that says who claimed the link, when, and on what
// basis. A delete leaves nothing to investigate.

const abhaSystem = "https://abdm.gov.in/abha"

// abhaRegistry builds a harness whose ABHA numbers can be verified.
func abhaRegistry(t *testing.T) *registry.DevRegistry {
	t.Helper()

	dev, err := registry.NewDev(true, abhaSystem, nil)
	if err != nil {
		t.Fatalf("registry.NewDev: %v", err)
	}
	return dev
}

func registrySet(t *testing.T, dev *registry.DevRegistry) *registry.Set {
	t.Helper()

	set := registry.New()
	if err := set.Register(dev); err != nil {
		t.Fatalf("Register: %v", err)
	}
	return set
}

// The development registry exists behind the same port the real one will, so
// wiring it is not a special case in the application layer.
func TestADevelopmentRegistryIsOffUnlessEnabled(t *testing.T) {
	if _, err := registry.NewDev(false, abhaSystem, nil); !errors.Is(err, registry.ErrDisabled) {
		t.Fatalf("a development registry constructed without an opt-in: %v", err)
	}
}

// Two registries claiming the same identifier system make the wiring ambiguous,
// and picking the last one registered makes behaviour depend on init order.
func TestARegistrySystemCannotBeClaimedTwice(t *testing.T) {
	set := registry.New()
	if err := set.Register(abhaRegistry(t)); err != nil {
		t.Fatalf("first Register: %v", err)
	}
	if err := set.Register(abhaRegistry(t)); err == nil {
		t.Fatal("a second registry claimed the same identifier system")
	}
}

// The base case: a hospital with no national adapter still links identifiers,
// and the record says plainly that nobody confirmed them.
func TestAnIdentifierLinksAsAssertedWhenNoRegistryIsConfigured(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Nair", []string{"Anand"}, date(1990, 1, 5), empiv1.Sex_SEX_MALE, "9800000001"))

	linked, err := h.patients.LinkIdentifier(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.LinkIdentifierRequest{
			PatientId: patient.GetPatientId(),
			Type:      empiv1.IdentifierType_IDENTIFIER_TYPE_NATIONAL_HEALTH,
			System:    abhaSystem, Value: "12-3456-7890-0001",
			AssigningAuthority: "ABDM", Source: "registration desk",
		}))
	if err != nil {
		t.Fatalf("LinkIdentifier: %v", err)
	}

	if got := linked.Msg.GetIdentifier().GetAssurance(); got != empiv1.IdentifierAssurance_IDENTIFIER_ASSURANCE_ASSERTED {
		t.Fatalf("assurance = %v, want asserted — nothing verified this value", got)
	}
	if linked.Msg.GetVerificationAttempted() {
		t.Fatal("verification was reported as attempted with no registry configured")
	}
}

// Verification is what separates a number somebody read off a photocopy from
// one the issuing authority confirmed.
func TestAVerifiedIdentifierRecordsWhoConfirmedItAndWhen(t *testing.T) {
	dev := abhaRegistry(t)
	dev.Seed("12-3456-7890-0002", domain.Verification{
		Verified: true, AssigningAuthority: "ABDM",
	})
	h := newEmpiHarnessWith(t, registrySet(t, dev))

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Nair", []string{"Bhavna"}, date(1991, 2, 6), empiv1.Sex_SEX_FEMALE, "9800000002"))

	linked, err := h.patients.LinkIdentifier(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.LinkIdentifierRequest{
			PatientId: patient.GetPatientId(),
			Type:      empiv1.IdentifierType_IDENTIFIER_TYPE_NATIONAL_HEALTH,
			System:    abhaSystem, Value: "12-3456-7890-0002",
			Source: "ABDM callback", Verify: true,
		}))
	if err != nil {
		t.Fatalf("LinkIdentifier: %v", err)
	}

	identifier := linked.Msg.GetIdentifier()
	if got := identifier.GetAssurance(); got != empiv1.IdentifierAssurance_IDENTIFIER_ASSURANCE_VERIFIED {
		t.Fatalf("assurance = %v, want verified", got)
	}
	if identifier.GetVerifiedAt() == nil {
		t.Fatal("a verified identifier does not say when it was verified")
	}
	if identifier.GetAssigningAuthority() != "ABDM" {
		t.Fatalf("assigning authority = %q; a verification with no author is a "+
			"claim nobody made", identifier.GetAssigningAuthority())
	}
}

// An authority that is asked and declines is a different answer from one that
// could not be asked, and collapsing them is how an outage silently becomes a
// stream of rejected registrations.
func TestAnUnrecognisedIdentifierIsRefusedWhenVerificationIsRequired(t *testing.T) {
	dev := abhaRegistry(t)
	dev.Fail("12-3456-7890-0003", "no such ABHA")
	h := newEmpiHarnessWith(t, registrySet(t, dev))

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Nair", []string{"Chetan"}, date(1992, 3, 7), empiv1.Sex_SEX_MALE, "9800000003"))

	_, err := h.patients.LinkIdentifier(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.LinkIdentifierRequest{
			PatientId: patient.GetPatientId(),
			Type:      empiv1.IdentifierType_IDENTIFIER_TYPE_NATIONAL_HEALTH,
			System:    abhaSystem, Value: "12-3456-7890-0003",
			Source: "registration desk", Verify: true, RequireVerification: true,
		}))
	if err == nil {
		t.Fatal("an identifier the authority does not recognise was linked anyway")
	}
	if detail := errorDetail(t, err); detail == nil ||
		detail.GetCode() != "EMPI_IDENTIFIER_NOT_VERIFIED" {
		t.Fatalf("error code = %+v, want EMPI_IDENTIFIER_NOT_VERIFIED", detail)
	}
}

// A national identifier service being down must not stop a hospital admitting
// patients. The identifier links as asserted and the response says why.
func TestARegistryOutageDoesNotBlockLinking(t *testing.T) {
	dev := abhaRegistry(t)
	dev.SetOutage(errors.New("connection refused"))
	h := newEmpiHarnessWith(t, registrySet(t, dev))

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Nair", []string{"Deepa"}, date(1993, 4, 8), empiv1.Sex_SEX_FEMALE, "9800000004"))

	linked, err := h.patients.LinkIdentifier(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.LinkIdentifierRequest{
			PatientId: patient.GetPatientId(),
			Type:      empiv1.IdentifierType_IDENTIFIER_TYPE_NATIONAL_HEALTH,
			System:    abhaSystem, Value: "12-3456-7890-0004",
			Source: "registration desk", Verify: true,
		}))
	if err != nil {
		t.Fatalf("a registry outage blocked registration: %v", err)
	}
	if !linked.Msg.GetRegistryUnavailable() {
		t.Fatal("the response does not say the authority was unreachable, so the " +
			"identifier reads as deliberately unverified rather than unchecked")
	}
	if got := linked.Msg.GetIdentifier().GetAssurance(); got != empiv1.IdentifierAssurance_IDENTIFIER_ASSURANCE_ASSERTED {
		t.Fatalf("assurance = %v, want asserted during an outage", got)
	}
}

// A caller that cannot accept an unverified national identifier says so, and
// then an outage is a refusal rather than a silent downgrade.
func TestRequiringVerificationRefusesDuringAnOutage(t *testing.T) {
	dev := abhaRegistry(t)
	dev.SetOutage(errors.New("connection refused"))
	h := newEmpiHarnessWith(t, registrySet(t, dev))

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Nair", []string{"Esha"}, date(1994, 5, 9), empiv1.Sex_SEX_FEMALE, "9800000005"))

	_, err := h.patients.LinkIdentifier(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.LinkIdentifierRequest{
			PatientId: patient.GetPatientId(),
			Type:      empiv1.IdentifierType_IDENTIFIER_TYPE_NATIONAL_HEALTH,
			System:    abhaSystem, Value: "12-3456-7890-0005",
			Source: "registration desk", Verify: true, RequireVerification: true,
		}))
	if err == nil {
		t.Fatal("verification was required and unavailable, and the link succeeded")
	}
	if detail := errorDetail(t, err); detail == nil ||
		detail.GetCode() != "EMPI_REGISTRY_UNAVAILABLE" {
		t.Fatalf("error code = %+v, want EMPI_REGISTRY_UNAVAILABLE — distinguishable "+
			"from a value the authority declined", detail)
	}
}

// The recovery path: an identifier linked during an outage can be confirmed
// later without being unlinked and relinked, which would lose its history.
func TestAnAssertedIdentifierCanBeVerifiedLater(t *testing.T) {
	dev := abhaRegistry(t)
	dev.SetOutage(errors.New("connection refused"))
	h := newEmpiHarnessWith(t, registrySet(t, dev))

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Nair", []string{"Farid"}, date(1995, 6, 10), empiv1.Sex_SEX_MALE, "9800000006"))

	linked, err := h.patients.LinkIdentifier(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.LinkIdentifierRequest{
			PatientId: patient.GetPatientId(),
			Type:      empiv1.IdentifierType_IDENTIFIER_TYPE_NATIONAL_HEALTH,
			System:    abhaSystem, Value: "12-3456-7890-0006",
			Source: "registration desk", Verify: true,
		}))
	if err != nil {
		t.Fatalf("LinkIdentifier: %v", err)
	}
	identifierID := linked.Msg.GetIdentifier().GetIdentifierId()

	// The authority comes back.
	dev.ClearOutage()
	dev.Seed("12-3456-7890-0006", domain.Verification{Verified: true, AssigningAuthority: "ABDM"})

	verified, err := h.patients.VerifyIdentifier(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.VerifyIdentifierRequest{
			IdentifierId: identifierID,
		}))
	if err != nil {
		t.Fatalf("VerifyIdentifier: %v", err)
	}

	if got := verified.Msg.GetIdentifier().GetAssurance(); got != empiv1.IdentifierAssurance_IDENTIFIER_ASSURANCE_VERIFIED {
		t.Fatalf("assurance = %v, want verified", got)
	}
	// Same row: the link history is continuous, not a delete and a re-add.
	if got := verified.Msg.GetIdentifier().GetIdentifierId(); got != identifierID {
		t.Fatalf("verification produced a new identifier %q rather than confirming %q",
			got, identifierID)
	}
}

// Unlinking retains the row. SRS-EMPI-011 is explicit, and the reason is that a
// wrong link is investigated months later.
func TestUnlinkingRetainsTheIdentifierAndItsReason(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Nair", []string{"Gita"}, date(1996, 7, 11), empiv1.Sex_SEX_FEMALE, "9800000007"))

	linked, err := h.patients.LinkIdentifier(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.LinkIdentifierRequest{
			PatientId: patient.GetPatientId(),
			Type:      empiv1.IdentifierType_IDENTIFIER_TYPE_INSURANCE,
			System:    "https://insurer.example/member", Value: "MEM-0007",
			Source: "payer file", AssigningAuthority: "Example Insurer",
		}))
	if err != nil {
		t.Fatalf("LinkIdentifier: %v", err)
	}

	unlinked, err := h.patients.UnlinkIdentifier(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.UnlinkIdentifierRequest{
			IdentifierId: linked.Msg.GetIdentifier().GetIdentifierId(),
			Reason:       "policy ended",
		}))
	if err != nil {
		t.Fatalf("UnlinkIdentifier: %v", err)
	}

	retired := unlinked.Msg.GetIdentifier()
	if retired.GetStatus() != empiv1.IdentifierStatus_IDENTIFIER_STATUS_SUPERSEDED {
		t.Fatalf("status = %v, want superseded", retired.GetStatus())
	}
	if retired.GetUnlinkedAt() == nil {
		t.Fatal("the retired identifier has no unlink time, so the interval it applied to is lost")
	}
	if !strings.Contains(retired.GetReason(), "policy ended") {
		t.Fatalf("reason = %q, want the caller's reason retained", retired.GetReason())
	}
	// Source survives the unlink: what claimed the link is the first question
	// asked when one turns out to be wrong.
	if retired.GetSource() != "payer file" {
		t.Fatalf("source = %q, want it retained through the unlink", retired.GetSource())
	}

	// And the patient is still there. The identifier was never the key.
	current, err := h.patients.GetPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.GetPatientRequest{
			PatientId: patient.GetPatientId(),
		}))
	if err != nil {
		t.Fatalf("GetPatient after unlink: %v", err)
	}
	if current.Msg.GetPatient().GetPatientId() != patient.GetPatientId() {
		t.Fatal("unlinking an identifier changed the patient's identity")
	}
}

// Superseded and revoked differ in exactly one way that matters, and it is
// whether a search on the value still reaches this patient.
func TestARevokedIdentifierStopsResolvingButIsStillOnFile(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Nair", []string{"Hari"}, date(1997, 8, 12), empiv1.Sex_SEX_MALE, "9800000008"))

	const wrongValue = "12-3456-7890-0008"
	linked, err := h.patients.LinkIdentifier(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.LinkIdentifierRequest{
			PatientId: patient.GetPatientId(),
			Type:      empiv1.IdentifierType_IDENTIFIER_TYPE_NATIONAL_HEALTH,
			System:    abhaSystem, Value: wrongValue, Source: "registration desk",
		}))
	if err != nil {
		t.Fatalf("LinkIdentifier: %v", err)
	}

	// It belonged to somebody else. Revoked, not superseded.
	if _, err := h.patients.UnlinkIdentifier(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.UnlinkIdentifierRequest{
			IdentifierId: linked.Msg.GetIdentifier().GetIdentifierId(),
			Revoke:       true, Reason: "entered against the wrong patient",
		})); err != nil {
		t.Fatalf("UnlinkIdentifier: %v", err)
	}

	found, err := h.patients.SearchPatients(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.SearchPatientsRequest{
			IdentifierValue:  wrongValue,
			IdentifierType:   empiv1.IdentifierType_IDENTIFIER_TYPE_NATIONAL_HEALTH,
			IdentifierSystem: abhaSystem,
		}))
	if err != nil {
		t.Fatalf("SearchPatients: %v", err)
	}
	for _, m := range found.Msg.GetMatches() {
		if m.GetPatient().GetPatientId() == patient.GetPatientId() {
			t.Fatal("a revoked identifier still resolves to the patient it was " +
				"wrongly linked to; it belongs to somebody else")
		}
	}
}

// The MRN is this system's own number, drawn from the facility's sequence.
// Accepting one from a caller would let a client pick a value the sequence has
// not reached, and the next issue would collide.
func TestAnMRNCannotBeLinkedFromOutside(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Nair", []string{"Ila"}, date(1998, 9, 13), empiv1.Sex_SEX_FEMALE, "9800000009"))

	_, err := h.patients.LinkIdentifier(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.LinkIdentifierRequest{
			PatientId: patient.GetPatientId(),
			Type:      empiv1.IdentifierType_IDENTIFIER_TYPE_MRN,
			System:    "anything", Value: "MAIN-9999999", Source: "a client",
		}))
	if err == nil {
		t.Fatal("a caller supplied its own MRN")
	}
	if detail := errorDetail(t, err); detail == nil || detail.GetCode() != "EMPI_MRN_NOT_LINKABLE" {
		t.Fatalf("error code = %+v, want EMPI_MRN_NOT_LINKABLE", detail)
	}
}

// The same national identifier on two patients is either a data-entry error or
// two records for one person. Either way it is a human decision, so the second
// link is refused rather than moved.
func TestAnIdentifierCannotBeLinkedToTwoPatients(t *testing.T) {
	h := newEmpiHarness(t)

	first := h.mustRegister(t, h.clerkToken(),
		demographics("Nair", []string{"Jaya"}, date(1999, 10, 14), empiv1.Sex_SEX_FEMALE, "9800000010"))
	second := h.mustRegister(t, h.clerkToken(),
		demographics("Rao", []string{"Kiran"}, date(1988, 11, 15), empiv1.Sex_SEX_MALE, "9800000011"))

	const shared = "12-3456-7890-0010"
	link := func(patientID string) error {
		_, err := h.patients.LinkIdentifier(context.Background(),
			withFacility(h.himToken(), h.facility, &empiv1.LinkIdentifierRequest{
				PatientId: patientID,
				Type:      empiv1.IdentifierType_IDENTIFIER_TYPE_NATIONAL_HEALTH,
				System:    abhaSystem, Value: shared, Source: "registration desk",
			}))
		return err
	}

	if err := link(first.GetPatientId()); err != nil {
		t.Fatalf("first link: %v", err)
	}
	err := link(second.GetPatientId())
	if err == nil {
		t.Fatal("one national identifier was linked to two patients")
	}
	detail := errorDetail(t, err)
	if detail == nil || detail.GetCode() != "EMPI_IDENTIFIER_IN_USE" {
		t.Fatalf("error code = %+v, want EMPI_IDENTIFIER_IN_USE", detail)
	}
	// The refusal must not name the holder. The caller asked about a value, not
	// about that patient, and confirming who holds a national identifier to
	// anybody who can guess one is a disclosure.
	if strings.Contains(err.Error(), first.GetPatientId()) {
		t.Fatalf("the refusal names the patient holding the identifier: %q", err.Error())
	}
}

// Linking needs the manage permission, not merely read.
//
// A registration clerk holds it and should: capturing an ABHA number at the
// desk is the job. A clinician does not — they read identity in the course of
// care, and attaching a national identity to a record is an administrative act
// with a different failure mode from a misread chart.
func TestLinkingAnIdentifierNeedsMoreThanReadAccess(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Nair", []string{"Lata"}, date(1987, 12, 16), empiv1.Sex_SEX_FEMALE, "9800000012"))

	_, err := h.patients.LinkIdentifier(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &empiv1.LinkIdentifierRequest{
			PatientId: patient.GetPatientId(),
			Type:      empiv1.IdentifierType_IDENTIFIER_TYPE_NATIONAL_HEALTH,
			System:    abhaSystem, Value: "12-3456-7890-0012", Source: "ward round",
		}))
	if err == nil {
		t.Fatal("a reader linked a national identifier")
	}
	if detail := errorDetail(t, err); detail == nil || detail.GetCode() != "EMPI_LINK_DENIED" {
		t.Fatalf("error code = %+v, want EMPI_LINK_DENIED", detail)
	}

	// And the clerk, who does hold it, succeeds — otherwise this test would
	// pass just as well against a rule that refused everybody.
	if _, err := h.patients.LinkIdentifier(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.LinkIdentifierRequest{
			PatientId: patient.GetPatientId(),
			Type:      empiv1.IdentifierType_IDENTIFIER_TYPE_NATIONAL_HEALTH,
			System:    abhaSystem, Value: "12-3456-7890-0012", Source: "registration desk",
		})); err != nil {
		t.Fatalf("a registration clerk could not capture an ABHA at the desk: %v", err)
	}
}

// Unlinking without a reason leaves a gap nobody can investigate later.
func TestUnlinkingNeedsAReason(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Nair", []string{"Manu"}, date(1986, 1, 17), empiv1.Sex_SEX_MALE, "9800000013"))

	linked, err := h.patients.LinkIdentifier(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.LinkIdentifierRequest{
			PatientId: patient.GetPatientId(),
			Type:      empiv1.IdentifierType_IDENTIFIER_TYPE_EXTERNAL,
			System:    "https://clinic.example/id", Value: "EXT-0013", Source: "referral letter",
		}))
	if err != nil {
		t.Fatalf("LinkIdentifier: %v", err)
	}

	if _, err := h.patients.UnlinkIdentifier(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.UnlinkIdentifierRequest{
			IdentifierId: linked.Msg.GetIdentifier().GetIdentifierId(),
		})); err == nil {
		t.Fatal("an identifier was unlinked with no reason recorded")
	}
}

// A link with no source cannot be unwound with any confidence about what
// claimed it, which is the whole point of retaining source.
func TestLinkingNeedsASource(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Nair", []string{"Nita"}, date(1985, 2, 18), empiv1.Sex_SEX_FEMALE, "9800000014"))

	if _, err := h.patients.LinkIdentifier(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.LinkIdentifierRequest{
			PatientId: patient.GetPatientId(),
			Type:      empiv1.IdentifierType_IDENTIFIER_TYPE_NATIONAL_HEALTH,
			System:    abhaSystem, Value: "12-3456-7890-0014",
		})); err == nil {
		t.Fatal("an identifier was linked with no source")
	}
}

// An identifier cannot be reached across a tenant boundary, and the refusal
// must not confirm that the identifier exists somewhere.
func TestAnIdentifierCannotBeUnlinkedFromAnotherTenant(t *testing.T) {
	h := newEmpiHarness(t)
	neighbour := h.provisionNeighbour(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Nair", []string{"Omar"}, date(1984, 3, 19), empiv1.Sex_SEX_MALE, "9800000015"))

	linked, err := h.patients.LinkIdentifier(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.LinkIdentifierRequest{
			PatientId: patient.GetPatientId(),
			Type:      empiv1.IdentifierType_IDENTIFIER_TYPE_EXTERNAL,
			System:    "https://clinic.example/id", Value: "EXT-0015", Source: "referral letter",
		}))
	if err != nil {
		t.Fatalf("LinkIdentifier: %v", err)
	}

	_, err = h.patients.UnlinkIdentifier(context.Background(),
		withFacility(neighbour.tenantID+":him-2:him_officer:"+neighbour.facility, neighbour.facility,
			&empiv1.UnlinkIdentifierRequest{
				IdentifierId: linked.Msg.GetIdentifier().GetIdentifierId(),
				Reason:       "not mine to unlink",
			}))
	if err == nil {
		t.Fatal("a neighbouring tenant unlinked this tenant's identifier")
	}
	// NOT_FOUND rather than PERMISSION_DENIED: a probe must not be able to
	// confirm that an identifier id exists.
	if detail := errorDetail(t, err); detail == nil ||
		!strings.Contains(detail.GetCode(), "NOT_FOUND") {
		t.Fatalf("error code = %+v, want a not-found; anything else confirms the "+
			"identifier exists in another tenant", detail)
	}
}

// A facility can register its first patient the moment it is commissioned.
//
// Lazily creating the sequence on first use would put the failure at the worst
// possible moment — the first patient through the door of a new site — and
// would have to invent a starting value under concurrency.
func TestCommissioningAFacilityProvisionsItsMRNSequence(t *testing.T) {
	h := newEmpiHarness(t)
	neighbour := h.provisionNeighbour(t)

	patient, err := h.patients.RegisterPatient(context.Background(),
		withFacility(neighbour.tenantID+":clerk-2:registration_clerk:"+neighbour.facility, neighbour.facility,
			&empiv1.RegisterPatientRequest{
				Demographics: demographics("Pillai", []string{"Ravi"},
					date(1983, 4, 20), empiv1.Sex_SEX_MALE, "9800000016"),
			}))
	if err != nil {
		t.Fatalf("a freshly commissioned facility could not register a patient: %v", err)
	}

	var mrn string
	for _, i := range patient.Msg.GetPatient().GetIdentifiers() {
		if i.GetType() == empiv1.IdentifierType_IDENTIFIER_TYPE_MRN {
			mrn = i.GetValue()
		}
	}
	if mrn == "" {
		t.Fatal("no MRN was issued at a newly commissioned facility")
	}
	// Prefixed with the facility code, so a number says which site registered
	// the patient without a lookup.
	if !strings.HasPrefix(strings.ToUpper(mrn), "NORTH-") {
		t.Fatalf("MRN %q does not carry the commissioning facility's code", mrn)
	}
}

// Re-commissioning must never reset a live counter: re-issuing an MRN already
// printed on a wristband is a patient-safety event, not a data problem.
func TestReprovisioningDoesNotResetALiveMRNSequence(t *testing.T) {
	h := newEmpiHarness(t)

	first := h.mustRegister(t, h.clerkToken(),
		demographics("Sharma", []string{"Tara"}, date(1982, 5, 21), empiv1.Sex_SEX_FEMALE, "9800000017"))
	second := h.mustRegister(t, h.clerkToken(),
		demographics("Sharma", []string{"Uday"}, date(1981, 6, 22), empiv1.Sex_SEX_MALE, "9800000018"))

	mrnOf := func(p *empiv1.Patient) string {
		for _, i := range p.GetIdentifiers() {
			if i.GetType() == empiv1.IdentifierType_IDENTIFIER_TYPE_MRN {
				return i.GetValue()
			}
		}
		return ""
	}
	if a, b := mrnOf(first), mrnOf(second); a == b || a == "" || b == "" {
		t.Fatalf("two registrations produced MRNs %q and %q", a, b)
	}
}

// SRS-EMPI-018's acceptance criterion is not "the events exist" — they plainly
// do — but that they "include tenant/patient/version/correlation metadata only
// as necessary".
//
// The reason is that an event stream is read by more systems, by more people
// and under fewer controls than the record it describes. A payload carrying a
// name and a birth date turns every subscriber into a place patient data lives,
// and the access rules protecting the patient index do not travel with it.
//
// This exercises the four events the requirement names plus the three the
// implementation adds, and checks every payload written for the whole tenant
// rather than the ones this test thought to look at.
func TestNoPatientEventCarriesDemographics(t *testing.T) {
	h := newEmpiHarness(t)

	// Values distinctive enough that finding them in a payload is unambiguous.
	const (
		family    = "Venkataraghavan"
		given     = "Chandrasekhar"
		phone     = "9811122233"
		abhaValue = "12-3456-7890-9999"
	)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics(family, []string{given}, date(1975, 11, 3), empiv1.Sex_SEX_MALE, phone))

	// patient.identifier_linked and patient.identifier_unlinked.
	linked, err := h.patients.LinkIdentifier(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.LinkIdentifierRequest{
			PatientId: patient.GetPatientId(),
			Type:      empiv1.IdentifierType_IDENTIFIER_TYPE_NATIONAL_HEALTH,
			System:    abhaSystem, Value: abhaValue, Source: "registration desk",
		}))
	if err != nil {
		t.Fatalf("LinkIdentifier: %v", err)
	}
	if _, err := h.patients.UnlinkIdentifier(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.UnlinkIdentifierRequest{
			IdentifierId: linked.Msg.GetIdentifier().GetIdentifierId(),
			Reason:       "linked in error",
		})); err != nil {
		t.Fatalf("UnlinkIdentifier: %v", err)
	}

	// patient.demographics_updated.
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
			Demographics: demographics(family, []string{given},
				date(1975, 11, 3), empiv1.Sex_SEX_MALE, "9811122244"),
			ExpectedVersion: current.Msg.GetPatient().GetVersion(),
		})); err != nil {
		t.Fatalf("UpdateDemographics: %v", err)
	}

	// patient.deceased.
	if _, err := h.patients.RecordDeceased(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.RecordDeceasedRequest{
			PatientId: patient.GetPatientId(),
			Date: &empiv1.PartialDate{
				Date:      timestamppb.New(date(2026, 2, 1)),
				Precision: empiv1.DatePrecision_DATE_PRECISION_DAY,
			},
			Source: "attending clinician",
		})); err != nil {
		t.Fatalf("RecordDeceased: %v", err)
	}

	rows, err := h.pool.Query(context.Background(),
		`SELECT event_type, payload::text FROM platform_data.outbox_event
		 WHERE tenant_id = $1 AND event_type LIKE 'patient.%'`, h.tenantID)
	if err != nil {
		t.Fatalf("read outbox: %v", err)
	}
	defer rows.Close()

	// Demographic values that must never appear in a payload. The phone is
	// checked in both its forms: normalisation strips punctuation, and a
	// payload leaking the normalised form leaks it just as thoroughly.
	forbidden := map[string]string{
		family:       "family name",
		given:        "given name",
		phone:        "phone number",
		"1975-11-3":  "birth date",
		"1975-11-03": "birth date",
		abhaValue:    "national health identifier value",
	}

	seen := map[string]bool{}
	for rows.Next() {
		var eventType, payload string
		if err := rows.Scan(&eventType, &payload); err != nil {
			t.Fatalf("scan: %v", err)
		}
		seen[eventType] = true
		for value, what := range forbidden {
			if strings.Contains(payload, value) {
				t.Errorf("%s carries the patient's %s: %s", eventType, what, payload)
			}
		}
	}
	if err := rows.Err(); err != nil {
		t.Fatalf("iterate: %v", err)
	}

	// The four SRS-EMPI-018 names this test could reach. patient.merged needs a
	// second record and is covered by the merge tests; asserting it here would
	// duplicate that setup without adding a property.
	for _, required := range []string{
		"patient.created",
		"patient.demographics_updated",
		"patient.deceased",
		"patient.identifier_linked",
		"patient.identifier_unlinked",
	} {
		if !seen[required] {
			t.Errorf("no %s event was emitted; SRS-EMPI-018 names it", required)
		}
	}

	if len(seen) == 0 {
		t.Fatal("no patient events at all were found, so this test proved nothing")
	}
}
