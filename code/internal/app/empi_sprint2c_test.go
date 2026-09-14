package app_test

import (
	"context"
	"strings"
	"testing"

	empiv1 "github.com/ppusapati/health/code/gen/go/healthcare/empi/v1"
	"github.com/ppusapati/health/code/internal/empi/adapters/photostore"
	"github.com/ppusapati/health/code/internal/platform/blobstore"
)

// Photographs, configured field access and emergency registration
// (SRS-EMPI-010, SRS-EMPI-014, SRS-EMPI-015).

// a one-pixel PNG. Real bytes rather than a fake string, so the content-type
// allowlist and the digest check are exercised against something a camera could
// actually have produced.
var onePixelPNG = []byte{
	0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
	0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
	0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
	0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
	0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
	0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
}

func photoHarness(t *testing.T) *empiHarness {
	t.Helper()

	// The real routing, not a stand-in: a filesystem backend behind the same
	// vault production uses, so the class allowlist, the tenant prefix and the
	// digest check on read are all exercised on the way through.
	backend, err := blobstore.NewFilesystem(blobstore.FilesystemOptions{
		Name: "local", Root: t.TempDir(),
	})
	if err != nil {
		t.Fatalf("blobstore.NewFilesystem: %v", err)
	}
	vault, err := blobstore.NewVault(blobstore.Config{}, backend)
	if err != nil {
		t.Fatalf("blobstore.NewVault: %v", err)
	}
	return newEmpiHarnessWithStore(t, photostore.New(vault))
}

func consentMsg() *empiv1.PhotoConsent {
	return &empiv1.PhotoConsent{
		GivenBy: "patient", Purpose: "identification at the bedside",
	}
}

// SRS-EMPI-015. The record exists immediately, because care has already started
// and every observation has to attach to something.
func TestAnUnconsciousPatientCanBeRegisteredAndLabelled(t *testing.T) {
	h := newEmpiHarness(t)

	registered, err := h.patients.RegisterUnidentified(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterUnidentifiedRequest{
			Designation: &empiv1.TemporaryDesignation{
				Label: "TRAUMA ALPHA", ApparentSex: empiv1.Sex_SEX_MALE, ApparentAge: 40,
				Circumstance: "road traffic collision, brought in by ambulance 14",
			},
		}))
	if err != nil {
		t.Fatalf("RegisterUnidentified: %v", err)
	}

	patient := registered.Msg.GetPatient()
	if patient.GetDesignation().GetLabel() != "TRAUMA ALPHA" {
		t.Fatalf("designation = %+v, want the label staff will use", patient.GetDesignation())
	}
	// An MRN immediately: a specimen taken now cannot be labelled with a number
	// issued in an hour.
	var mrn string
	for _, i := range patient.GetIdentifiers() {
		if i.GetType() == empiv1.IdentifierType_IDENTIFIER_TYPE_MRN {
			mrn = i.GetValue()
		}
	}
	if mrn == "" {
		t.Fatalf("no MRN was issued for an emergency admission: %+v", patient.GetIdentifiers())
	}
}

// A record whose family name is "TRAUMA ALPHA" fuzzy-matches the next trauma
// patient, and two people end up sharing a chart.
func TestATemporaryLabelIsNotSearchableAsAName(t *testing.T) {
	h := newEmpiHarness(t)

	if _, err := h.patients.RegisterUnidentified(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterUnidentifiedRequest{
			Designation: &empiv1.TemporaryDesignation{
				Label: "TRAUMA ALPHA", ApparentSex: empiv1.Sex_SEX_MALE,
			},
		})); err != nil {
		t.Fatalf("RegisterUnidentified: %v", err)
	}

	found, err := h.patients.SearchPatients(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.SearchPatientsRequest{
			Name: "TRAUMA",
		}))
	if err != nil {
		t.Fatalf("SearchPatients: %v", err)
	}
	if len(found.Msg.GetMatches()) != 0 {
		t.Fatalf("a trauma label is in the name index and will match the next "+
			"unidentified patient: %+v", found.Msg.GetMatches())
	}
}

// The chronology guarantee: the internal identifier never changes, so
// everything written during the resuscitation still points here.
func TestIdentifyingAnEmergencyPatientKeepsTheSameRecord(t *testing.T) {
	h := newEmpiHarness(t)

	registered, err := h.patients.RegisterUnidentified(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterUnidentifiedRequest{
			Designation: &empiv1.TemporaryDesignation{
				Label: "TRAUMA BRAVO", ApparentSex: empiv1.Sex_SEX_MALE, ApparentAge: 35,
			},
		}))
	if err != nil {
		t.Fatalf("RegisterUnidentified: %v", err)
	}
	patient := registered.Msg.GetPatient()

	identified, err := h.patients.IdentifyPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.IdentifyPatientRequest{
			PatientId: patient.GetPatientId(),
			Demographics: demographics("Kulkarni", []string{"Rohit"},
				date(1991, 5, 4), empiv1.Sex_SEX_MALE, "9820000001"),
			ExpectedVersion: patient.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("IdentifyPatient: %v", err)
	}

	if got := identified.Msg.GetPatient().GetPatientId(); got != patient.GetPatientId() {
		t.Fatalf("identifying produced a new record %q rather than naming %q; "+
			"every observation from the resuscitation now points at nothing",
			got, patient.GetPatientId())
	}
	if identified.Msg.GetPatient().GetIdentifiedAt() == nil {
		t.Fatal("the moment of identification was not recorded, so the emergency " +
			"chart cannot be tied to the identified one")
	}
	// The designation is kept: an hour of records was filed under it.
	if identified.Msg.GetPatient().GetDesignation().GetLabel() != "TRAUMA BRAVO" {
		t.Fatal("the designation was cleared, so records filed under it can no " +
			"longer be tied to this patient")
	}

	// And the emergency MRN still resolves.
	var mrn string
	for _, i := range patient.GetIdentifiers() {
		if i.GetType() == empiv1.IdentifierType_IDENTIFIER_TYPE_MRN {
			mrn = i.GetValue()
		}
	}
	found, err := h.patients.SearchPatients(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.SearchPatientsRequest{
			IdentifierValue: mrn,
			IdentifierType:  empiv1.IdentifierType_IDENTIFIER_TYPE_MRN,
		}))
	if err != nil {
		t.Fatalf("SearchPatients: %v", err)
	}
	if len(found.Msg.GetMatches()) != 1 ||
		found.Msg.GetMatches()[0].GetPatient().GetPatientId() != patient.GetPatientId() {
		t.Fatalf("the MRN issued during the emergency no longer reaches the patient: %+v",
			found.Msg.GetMatches())
	}
}

// A patient brought in unconscious very often already has a record here, and
// identification is the first moment there is enough to find it.
func TestIdentifyingRunsTheDuplicateCheckEmergencyRegistrationSkipped(t *testing.T) {
	h := newEmpiHarness(t)

	existing := h.mustRegister(t, h.clerkToken(),
		demographics("Kulkarni", []string{"Rohit"}, date(1991, 5, 4),
			empiv1.Sex_SEX_MALE, "9820000002"))

	registered, err := h.patients.RegisterUnidentified(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterUnidentifiedRequest{
			Designation: &empiv1.TemporaryDesignation{
				Label: "TRAUMA CHARLIE", ApparentSex: empiv1.Sex_SEX_MALE,
			},
		}))
	if err != nil {
		t.Fatalf("RegisterUnidentified: %v", err)
	}
	patient := registered.Msg.GetPatient()

	same := demographics("Kulkarni", []string{"Rohit"}, date(1991, 5, 4),
		empiv1.Sex_SEX_MALE, "9820000002")

	blocked, err := h.patients.IdentifyPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.IdentifyPatientRequest{
			PatientId: patient.GetPatientId(), Demographics: same,
			ExpectedVersion: patient.GetVersion(),
		}))
	if err != nil {
		t.Fatalf("IdentifyPatient: %v", err)
	}
	if blocked.Msg.GetPatient() != nil {
		t.Fatal("identification created a second record for somebody already registered")
	}

	var sawExisting bool
	for _, d := range blocked.Msg.GetPotentialDuplicates() {
		if d.GetPatient().GetPatientId() == existing.GetPatientId() {
			sawExisting = true
		}
	}
	if !sawExisting {
		t.Fatalf("the existing record was not offered for review: %+v",
			blocked.Msg.GetPotentialDuplicates())
	}

	// Acknowledged — a twin, say — and it proceeds.
	identified, err := h.patients.IdentifyPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.IdentifyPatientRequest{
			PatientId: patient.GetPatientId(), Demographics: same,
			ExpectedVersion:                 patient.GetVersion(),
			AcknowledgedDuplicatePatientIds: []string{existing.GetPatientId()},
		}))
	if err != nil {
		t.Fatalf("IdentifyPatient after acknowledgement: %v", err)
	}
	if identified.Msg.GetPatient() == nil {
		t.Fatal("an acknowledged duplicate still blocked identification")
	}
}

// Naming the patient is the moment "nothing is known" stops being true.
func TestIdentifyingAppliesTheFullDemographicPolicy(t *testing.T) {
	h := newEmpiHarness(t)

	registered, err := h.patients.RegisterUnidentified(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterUnidentifiedRequest{
			Designation: &empiv1.TemporaryDesignation{
				Label: "TRAUMA DELTA", ApparentSex: empiv1.Sex_SEX_FEMALE,
			},
		}))
	if err != nil {
		t.Fatalf("RegisterUnidentified: %v", err)
	}

	// No family name: below the minimum set the facility requires.
	_, err = h.patients.IdentifyPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.IdentifyPatientRequest{
			PatientId: registered.Msg.GetPatient().GetPatientId(),
			Demographics: demographics("", []string{"Rohit"}, date(1991, 5, 4),
				empiv1.Sex_SEX_MALE, ""),
			ExpectedVersion: registered.Msg.GetPatient().GetVersion(),
		}))
	if err == nil {
		t.Fatal("a patient was identified into a record below the demographic minimum")
	}
}

// The worklist a ward clerk works.
func TestUnidentifiedPatientsAppearOnAWorklistAndLeaveIt(t *testing.T) {
	h := newEmpiHarness(t)

	registered, err := h.patients.RegisterUnidentified(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.RegisterUnidentifiedRequest{
			Designation: &empiv1.TemporaryDesignation{
				Label: "TRAUMA ECHO", ApparentSex: empiv1.Sex_SEX_FEMALE,
			},
		}))
	if err != nil {
		t.Fatalf("RegisterUnidentified: %v", err)
	}
	patient := registered.Msg.GetPatient()

	onList := func() bool {
		t.Helper()
		listed, err := h.patients.ListUnidentified(context.Background(),
			withFacility(h.clerkToken(), h.facility, &empiv1.ListUnidentifiedRequest{}))
		if err != nil {
			t.Fatalf("ListUnidentified: %v", err)
		}
		for _, p := range listed.Msg.GetPatients() {
			if p.GetPatientId() == patient.GetPatientId() {
				return true
			}
		}
		return false
	}

	if !onList() {
		t.Fatal("an unidentified patient is not on the worklist, so nobody will chase them")
	}

	if _, err := h.patients.IdentifyPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.IdentifyPatientRequest{
			PatientId: patient.GetPatientId(),
			Demographics: demographics("Menon", []string{"Asha"}, date(1988, 2, 2),
				empiv1.Sex_SEX_FEMALE, "9820000003"),
			ExpectedVersion: patient.GetVersion(),
		})); err != nil {
		t.Fatalf("IdentifyPatient: %v", err)
	}

	if onList() {
		t.Fatal("an identified patient is still on the unidentified worklist")
	}
}

// SRS-EMPI-010's whole point, over the wire.
func TestIdentityCannotBeConfirmedOnAPhotographAlone(t *testing.T) {
	h := photoHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))

	if _, err := h.patients.CapturePhoto(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.CapturePhotoRequest{
			PatientId: patient.GetPatientId(), ContentType: "image/png",
			Content: onePixelPNG, Consent: consentMsg(),
		})); err != nil {
		t.Fatalf("CapturePhoto: %v", err)
	}

	current, err := h.patients.GetPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.GetPatientRequest{
			PatientId: patient.GetPatientId(),
		}))
	if err != nil {
		t.Fatalf("GetPatient: %v", err)
	}

	_, err = h.patients.ConfirmIdentity(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.ConfirmIdentityRequest{
			PatientId:       patient.GetPatientId(),
			ExpectedVersion: current.Msg.GetPatient().GetVersion(),
			Evidence:        &empiv1.IdentityEvidence{PhotoMatched: true},
		}))
	if err == nil {
		t.Fatal("identity was confirmed on a photograph alone")
	}
	if detail := errorDetail(t, err); detail == nil ||
		detail.GetCode() != "EMPI_IDENTITY_NOT_POSITIVELY_ESTABLISHED" {
		t.Fatalf("error code = %+v, want EMPI_IDENTITY_NOT_POSITIVELY_ESTABLISHED", detail)
	}
}

// An unverified number carries no more assurance than the photograph does;
// admitting it would let the prohibition be satisfied by typing.
func TestAnAssertedIdentifierDoesNotConfirmIdentityOverTheWire(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))

	// No registry configured, so this links as asserted.
	linked, err := h.patients.LinkIdentifier(context.Background(),
		withFacility(h.himToken(), h.facility, &empiv1.LinkIdentifierRequest{
			PatientId: patient.GetPatientId(),
			Type:      empiv1.IdentifierType_IDENTIFIER_TYPE_NATIONAL_HEALTH,
			System:    abhaSystem, Value: "12-3456-7890-0300",
			Source: "registration desk",
		}))
	if err != nil {
		t.Fatalf("LinkIdentifier: %v", err)
	}

	current, err := h.patients.GetPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.GetPatientRequest{
			PatientId: patient.GetPatientId(),
		}))
	if err != nil {
		t.Fatalf("GetPatient: %v", err)
	}

	if _, err := h.patients.ConfirmIdentity(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.ConfirmIdentityRequest{
			PatientId:       patient.GetPatientId(),
			ExpectedVersion: current.Msg.GetPatient().GetVersion(),
			Evidence: &empiv1.IdentityEvidence{
				IdentifierIds: []string{linked.Msg.GetIdentifier().GetIdentifierId()},
			},
		})); err == nil {
		t.Fatal("an unverified national identifier confirmed identity")
	}
}

// A photograph is stored with the consent it was taken under, and comes back
// byte-identical.
func TestAPhotographIsStoredWithItsConsentAndReadBack(t *testing.T) {
	h := photoHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))

	captured, err := h.patients.CapturePhoto(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.CapturePhotoRequest{
			PatientId: patient.GetPatientId(), ContentType: "image/png",
			Content: onePixelPNG, Consent: consentMsg(),
		}))
	if err != nil {
		t.Fatalf("CapturePhoto: %v", err)
	}
	if got := captured.Msg.GetPhoto().GetConsent().GetPurpose(); got != "identification at the bedside" {
		t.Fatalf("consent purpose = %q, want the stated purpose retained", got)
	}
	if captured.Msg.GetPhoto().GetConsent().GetRecordedBy() == "" {
		t.Fatal("the consent does not name who recorded it")
	}

	read, err := h.patients.GetPhoto(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &empiv1.GetPhotoRequest{
			PatientId: patient.GetPatientId(),
		}))
	if err != nil {
		t.Fatalf("GetPhoto: %v", err)
	}
	if string(read.Msg.GetContent()) != string(onePixelPNG) {
		t.Fatal("the photograph read back is not the one that was stored")
	}
}

// "They agreed to a photo" is not consent to anything in particular.
func TestAPhotographNeedsConsentWithAPurpose(t *testing.T) {
	h := photoHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))

	for _, c := range []*empiv1.PhotoConsent{
		nil,
		{GivenBy: "patient"},
		{Purpose: "identification at the bedside"},
	} {
		if _, err := h.patients.CapturePhoto(context.Background(),
			withFacility(h.clerkToken(), h.facility, &empiv1.CapturePhotoRequest{
				PatientId: patient.GetPatientId(), ContentType: "image/png",
				Content: onePixelPNG, Consent: c,
			})); err == nil {
			t.Fatalf("a photograph was stored on consent %+v", c)
		}
	}
}

// An allowlist, not a blocklist: a blocklist accepts SVG, which is a script
// container, and HTML renamed to .jpg.
func TestOnlyPhotographFormatsAreAccepted(t *testing.T) {
	h := photoHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))

	if _, err := h.patients.CapturePhoto(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.CapturePhotoRequest{
			PatientId: patient.GetPatientId(), ContentType: "image/svg+xml",
			Content: []byte(`<svg onload="alert(1)"/>`), Consent: consentMsg(),
		})); err == nil {
		t.Fatal("an SVG was accepted as a patient photograph")
	}
}

// Withdrawal loses the bytes and keeps the record, so somebody can still answer
// whether a photograph ever existed.
func TestWithdrawingConsentRemovesTheImageAndKeepsTheRecord(t *testing.T) {
	h := photoHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))

	captured, err := h.patients.CapturePhoto(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.CapturePhotoRequest{
			PatientId: patient.GetPatientId(), ContentType: "image/png",
			Content: onePixelPNG, Consent: consentMsg(),
		}))
	if err != nil {
		t.Fatalf("CapturePhoto: %v", err)
	}

	withdrawn, err := h.patients.WithdrawPhotoConsent(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.WithdrawPhotoConsentRequest{
			PhotoId: captured.Msg.GetPhoto().GetPhotoId(),
			Reason:  "the patient asked for it to be removed",
		}))
	if err != nil {
		t.Fatalf("WithdrawPhotoConsent: %v", err)
	}
	if withdrawn.Msg.GetPhoto().GetWithdrawnAt() == nil {
		t.Fatal("the withdrawal was not recorded")
	}
	if !strings.Contains(withdrawn.Msg.GetPhoto().GetWithdrawnReason(), "asked for it") {
		t.Fatalf("the withdrawal lost its reason: %q", withdrawn.Msg.GetPhoto().GetWithdrawnReason())
	}
	// The consent that was given is still on the record.
	if withdrawn.Msg.GetPhoto().GetConsent().GetPurpose() == "" {
		t.Fatal("withdrawal erased the record of the consent that was given")
	}

	// And the image is gone.
	read, err := h.patients.GetPhoto(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &empiv1.GetPhotoRequest{
			PatientId: patient.GetPatientId(),
		}))
	if err != nil {
		t.Fatalf("GetPhoto after withdrawal: %v", err)
	}
	if len(read.Msg.GetContent()) != 0 {
		t.Fatal("a withdrawn photograph is still served")
	}
}

// A deployment that stores no photographs says so rather than recording a row
// that points at nothing.
func TestCapturingAPhotographNeedsAConfiguredStore(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))

	_, err := h.patients.CapturePhoto(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.CapturePhotoRequest{
			PatientId: patient.GetPatientId(), ContentType: "image/png",
			Content: onePixelPNG, Consent: consentMsg(),
		}))
	if err == nil {
		t.Fatal("a photograph was captured with no store configured")
	}
	if detail := errorDetail(t, err); detail == nil ||
		detail.GetCode() != "EMPI_PHOTO_STORE_NOT_CONFIGURED" {
		t.Fatalf("error code = %+v, want EMPI_PHOTO_STORE_NOT_CONFIGURED", detail)
	}
}

// SRS-EMPI-014's operative phrase is "where configured". The default masks a
// birth date; a tenant that restricts the family name gets that too.
func TestFieldRestrictionsFollowTenantConfiguration(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12),
			empiv1.Sex_SEX_FEMALE, "9876543210"))

	// Before configuration: a clerk sees the family name in full.
	before, err := h.patients.GetPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.GetPatientRequest{
			PatientId: patient.GetPatientId(),
		}))
	if err != nil {
		t.Fatalf("GetPatient: %v", err)
	}
	if got := before.Msg.GetPatient().GetDemographics().GetName().GetFamily(); got != "Iyer" {
		t.Fatalf("family name = %q before configuration, want it unmasked", got)
	}

	// The tenant restricts it.
	if _, err := h.patients.ConfigureFieldAccess(context.Background(),
		as(tenantAdminToken(h.tenantID), &empiv1.ConfigureFieldAccessRequest{
			Field:              empiv1.DemographicField_DEMOGRAPHIC_FIELD_FAMILY_NAME,
			RequiredPermission: "empi.patient.read_restricted",
		})); err != nil {
		t.Fatalf("ConfigureFieldAccess: %v", err)
	}

	after, err := h.patients.GetPatient(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.GetPatientRequest{
			PatientId: patient.GetPatientId(),
		}))
	if err != nil {
		t.Fatalf("GetPatient after configuration: %v", err)
	}
	if got := after.Msg.GetPatient().GetDemographics().GetName().GetFamily(); got == "Iyer" {
		t.Fatal("configuring a field restriction had no effect, so SRS-EMPI-014 " +
			"is a constant rather than a policy")
	}
	if !after.Msg.GetMasked() {
		t.Fatal("the response does not say the record was masked, so blanks read " +
			"as missing data")
	}

	// A clinician, who holds read_restricted, still sees it.
	clinician, err := h.patients.GetPatient(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &empiv1.GetPatientRequest{
			PatientId: patient.GetPatientId(),
		}))
	if err != nil {
		t.Fatalf("GetPatient as clinician: %v", err)
	}
	if got := clinician.Msg.GetPatient().GetDemographics().GetName().GetFamily(); got != "Iyer" {
		t.Fatalf("family name = %q for a caller holding the permission, want it "+
			"revealed — otherwise the restriction hides it from everybody", got)
	}
}

// Configuring who may see a patient's details is a tenant-administration act,
// not something a registration desk does.
func TestConfiguringFieldAccessIsRestricted(t *testing.T) {
	h := newEmpiHarness(t)

	_, err := h.patients.ConfigureFieldAccess(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.ConfigureFieldAccessRequest{
			Field:              empiv1.DemographicField_DEMOGRAPHIC_FIELD_ADDRESS,
			RequiredPermission: "empi.patient.read_restricted",
		}))
	if err == nil {
		t.Fatal("a registration clerk changed who may see patient addresses")
	}
	if detail := errorDetail(t, err); detail == nil || detail.GetCode() != "EMPI_CONFIGURE_DENIED" {
		t.Fatalf("error code = %+v, want EMPI_CONFIGURE_DENIED", detail)
	}
}

// A field restricted behind no permission is restricted from everybody forever
// with nothing saying so.
func TestAFieldCannotBeConfiguredBehindNoPermission(t *testing.T) {
	h := newEmpiHarness(t)

	if _, err := h.patients.ConfigureFieldAccess(context.Background(),
		as(tenantAdminToken(h.tenantID), &empiv1.ConfigureFieldAccessRequest{
			Field: empiv1.DemographicField_DEMOGRAPHIC_FIELD_ADDRESS,
		})); err == nil {
		t.Fatal("a field was restricted behind no permission at all")
	}
}

// SRS-EMPI-014 requires the read to be audited, and what makes the audit worth
// keeping is which restricted fields were actually disclosed.
func TestARestrictedReadRecordsWhichFieldsWereRevealed(t *testing.T) {
	h := newEmpiHarness(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12),
			empiv1.Sex_SEX_FEMALE, "9876543210"))

	if _, err := h.patients.GetPatient(context.Background(),
		withFacility(h.clinicianToken(), h.facility, &empiv1.GetPatientRequest{
			PatientId: patient.GetPatientId(),
		})); err != nil {
		t.Fatalf("GetPatient: %v", err)
	}

	var auditContext string
	if err := h.pool.QueryRow(context.Background(),
		`SELECT context::text FROM platform_data.audit_record
		 WHERE resource_id = $1 AND actor_id = 'doctor-1'
		 ORDER BY occurred_at DESC LIMIT 1`,
		patient.GetPatientId()).Scan(&auditContext); err != nil {
		t.Fatalf("read audit: %v", err)
	}

	if !strings.Contains(auditContext, "revealed_fields") {
		t.Fatalf("the audit entry does not say which restricted fields were "+
			"disclosed: %s", auditContext)
	}
	if !strings.Contains(auditContext, "birth_date") {
		t.Fatalf("a caller who saw the full birth date has no record of it: %s", auditContext)
	}
	// The values themselves must not be there: an audit trail holding
	// demographics is a second, less protected copy of them.
	if strings.Contains(auditContext, "Iyer") || strings.Contains(auditContext, "9876543210") {
		t.Fatalf("the audit entry carries demographic values: %s", auditContext)
	}
}

// A photograph cannot be reached across a tenant boundary.
func TestAPhotographCannotBeReadFromAnotherTenant(t *testing.T) {
	h := photoHarness(t)
	neighbour := h.provisionNeighbour(t)

	patient := h.mustRegister(t, h.clerkToken(),
		demographics("Iyer", []string{"Meera"}, date(1984, 3, 12), empiv1.Sex_SEX_FEMALE, ""))

	if _, err := h.patients.CapturePhoto(context.Background(),
		withFacility(h.clerkToken(), h.facility, &empiv1.CapturePhotoRequest{
			PatientId: patient.GetPatientId(), ContentType: "image/png",
			Content: onePixelPNG, Consent: consentMsg(),
		})); err != nil {
		t.Fatalf("CapturePhoto: %v", err)
	}

	read, err := h.patients.GetPhoto(context.Background(),
		withFacility(neighbour.tenantID+":doctor-2:clinician:"+neighbour.facility,
			neighbour.facility, &empiv1.GetPhotoRequest{
				PatientId: patient.GetPatientId(),
			}))
	// Either a not-found or an empty answer is acceptable; a photograph is not.
	if err == nil && len(read.Msg.GetContent()) != 0 {
		t.Fatal("a neighbouring tenant read this tenant's patient photograph")
	}
}
