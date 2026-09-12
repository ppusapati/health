package domain_test

import (
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/empi/domain"
)

func policyAllowing(unidentified bool) domain.DemographicPolicy {
	p := domain.DefaultPolicy("IN")
	p.AllowUnidentified = unidentified
	return p
}

// The defect this fixes: AllowUnidentified used to short-circuit Check, so a
// hospital that enabled emergency registration silently dropped the demographic
// minimum for every routine registration too — the opposite of what enabling it
// says, and invisible until the index filled with unmatched records.
func TestAllowingEmergencyRegistrationDoesNotRelaxRoutineRegistration(t *testing.T) {
	nameless := domain.Demographics{Sex: domain.SexFemale}

	if err := policyAllowing(true).Check(nameless); err == nil {
		t.Fatal("a facility that permits emergency registration accepted a routine " +
			"registration with no family name")
	}
	// Still refused for the same reason when the flag is off, so the test is
	// not merely asserting that Check refuses everything.
	if err := policyAllowing(false).Check(nameless); err == nil {
		t.Fatal("Check accepted demographics missing a required field")
	}
	// And a complete registration is accepted either way.
	complete := domain.Demographics{
		Name: domain.HumanName{Family: "Iyer"}, Sex: domain.SexFemale,
	}
	if err := policyAllowing(true).Check(complete); err != nil {
		t.Fatalf("a complete registration was refused: %v", err)
	}
}

// A hospital that has configured nothing must still be able to admit an
// unconscious patient: refusing delays care or pushes it off-record.
func TestEmergencyRegistrationIsPermittedByDefault(t *testing.T) {
	if !domain.DefaultPolicy("IN").PermitsUnidentified() {
		t.Fatal("the default policy refuses emergency registration, so an " +
			"unconfigured hospital cannot admit an unconscious patient")
	}
}

func designation() domain.TemporaryDesignation {
	return domain.TemporaryDesignation{
		Label: "TRAUMA ALPHA", ApparentSex: domain.SexMale, ApparentAge: 40,
		Circumstance: "road traffic collision, brought in by ambulance 14",
	}
}

// The record exists immediately, because care has already started and every
// observation has to attach to something.
func TestAnUnidentifiedPatientCanBeRegistered(t *testing.T) {
	patient, err := domain.NewUnidentifiedPatient("p-1", "t-1", "f-1",
		designation(), policyAllowing(true), moment(2026, time.September, 12))
	if err != nil {
		t.Fatalf("NewUnidentifiedPatient: %v", err)
	}
	if !patient.IsUnidentified() {
		t.Fatal("a patient registered with a designation does not read as unidentified")
	}
	if patient.Status != domain.StatusCandidate {
		t.Fatalf("status = %q, want candidate", patient.Status)
	}
}

// The label must not reach the name index. A record called "TRAUMA ALPHA" that
// fuzzy-matches the next trauma patient is how two people share a chart.
func TestTheTemporaryLabelNeverBecomesAName(t *testing.T) {
	patient, err := domain.NewUnidentifiedPatient("p-1", "t-1", "f-1",
		designation(), policyAllowing(true), moment(2026, time.September, 12))
	if err != nil {
		t.Fatalf("NewUnidentifiedPatient: %v", err)
	}

	name := patient.Demographics.Name
	if strings.Contains(strings.ToUpper(name.Family), "TRAUMA") ||
		strings.Contains(strings.ToUpper(strings.Join(name.Given, " ")), "TRAUMA") {
		t.Fatalf("the temporary label leaked into the name index: %+v", name)
	}
}

// An estimated age is the weakest signal the matcher can be given and must be
// marked as one.
func TestAnApparentAgeBecomesAnEstimatedBirthDate(t *testing.T) {
	patient, err := domain.NewUnidentifiedPatient("p-1", "t-1", "f-1",
		designation(), policyAllowing(true), moment(2026, time.September, 12))
	if err != nil {
		t.Fatalf("NewUnidentifiedPatient: %v", err)
	}
	if got := patient.Demographics.BirthDate.Precision; got != domain.PrecisionEstimated {
		t.Fatalf("birth date precision = %q, want estimated — an age guessed at "+
			"the bedside must never be weighed as a stated date", got)
	}
}

// A facility that has said it does not register unidentified patients is not
// overruled quietly.
func TestAFacilityCanRefuseUnidentifiedRegistration(t *testing.T) {
	if _, err := domain.NewUnidentifiedPatient("p-1", "t-1", "f-1",
		designation(), policyAllowing(false), moment(2026, time.September, 12)); err == nil {
		t.Fatal("an unidentified patient was registered at a facility that forbids it")
	}
}

// Without a label staff invent one, on paper, inconsistently.
func TestAnUnidentifiedPatientNeedsALabel(t *testing.T) {
	d := designation()
	d.Label = ""
	if _, err := domain.NewUnidentifiedPatient("p-1", "t-1", "f-1", d,
		policyAllowing(true), moment(2026, time.September, 12)); err == nil {
		t.Fatal("an unidentified patient was registered with nothing to call them")
	}
}

// Identifying later is a demographic update, not a new record: everything
// written during the emergency still points at the same identifier, which is
// what "without losing encounter chronology" means in practice.
func TestIdentifyingKeepsTheSameRecord(t *testing.T) {
	now := moment(2026, time.September, 12)
	patient, err := domain.NewUnidentifiedPatient("p-1", "t-1", "f-1",
		designation(), policyAllowing(true), now)
	if err != nil {
		t.Fatalf("NewUnidentifiedPatient: %v", err)
	}
	original := patient.ID()

	real := domain.Demographics{
		Name: domain.HumanName{Family: "Kulkarni", Given: []string{"Rohit"}},
		Sex:  domain.SexMale,
	}
	if err := patient.Identify(real, policyAllowing(true), now.Add(time.Hour)); err != nil {
		t.Fatalf("Identify: %v", err)
	}

	if patient.ID() != original {
		t.Fatalf("identifying changed the patient id from %q to %q; every record "+
			"written during the emergency now points at nothing", original, patient.ID())
	}
	if patient.Demographics.Name.Family != "Kulkarni" {
		t.Fatalf("family name = %q, want the real name", patient.Demographics.Name.Family)
	}
	if patient.IsUnidentified() {
		t.Fatal("the patient still reads as unidentified after being identified")
	}
	// The designation is kept: an hour of records was filed under it.
	if patient.Designation == nil || patient.Designation.Label != "TRAUMA ALPHA" {
		t.Fatalf("the designation was cleared, so records filed under %q can no "+
			"longer be tied to this patient", "TRAUMA ALPHA")
	}
}

// Emergency registration relaxes the minimum set because nothing was known.
// Naming the patient is the moment that stops being true.
func TestIdentifyingAppliesTheFullPolicy(t *testing.T) {
	now := moment(2026, time.September, 12)
	patient, err := domain.NewUnidentifiedPatient("p-1", "t-1", "f-1",
		designation(), policyAllowing(true), now)
	if err != nil {
		t.Fatalf("NewUnidentifiedPatient: %v", err)
	}

	incomplete := domain.Demographics{Sex: domain.SexMale}
	if err := patient.Identify(incomplete, policyAllowing(true), now); err == nil {
		t.Fatal("a patient was identified into a record below the demographic minimum")
	}
}

// SRS-EMPI-010's whole point. A photograph is evidence a human uses, never
// evidence the system accepts.
func TestAPhotographAloneCannotConfirmIdentity(t *testing.T) {
	held := domain.IdentifierSet{{
		ID: "i-1", Type: domain.IdentifierNationalHealth, Status: domain.IdentifierActive,
		Assurance: domain.AssuranceVerified,
	}}

	err := domain.CheckIdentityEvidence(domain.IdentityEvidence{PhotoMatched: true}, held)
	if err == nil {
		t.Fatal("identity was confirmed on a photograph alone")
	}
	var refusal domain.ErrPhotoIsNotProof
	if !errors.As(err, &refusal) {
		t.Fatalf("error = %v, want ErrPhotoIsNotProof", err)
	}
	if !strings.Contains(refusal.Error(), "photograph") {
		t.Fatalf("the refusal does not say what was offered: %q", refusal.Error())
	}
}

// A person vouching is also not proof. The prohibition is about the class of
// evidence, not about photographs specifically.
func TestSomebodyVouchingAloneCannotConfirmIdentity(t *testing.T) {
	held := domain.IdentifierSet{{
		ID: "i-1", Status: domain.IdentifierActive, Assurance: domain.AssuranceVerified,
	}}
	if err := domain.CheckIdentityEvidence(
		domain.IdentityEvidence{VouchedForBy: "r-1"}, held); err == nil {
		t.Fatal("identity was confirmed on somebody's word alone")
	}
}

// An asserted identifier carries no more assurance than the photograph does.
// Admitting it would let the prohibition be satisfied by typing.
func TestAnAssertedIdentifierIsNotPositiveIdentification(t *testing.T) {
	held := domain.IdentifierSet{{
		ID: "i-1", Status: domain.IdentifierActive, Assurance: domain.AssuranceAsserted,
	}}
	if err := domain.CheckIdentityEvidence(
		domain.IdentityEvidence{IdentifierIDs: []string{"i-1"}, PhotoMatched: true},
		held); err == nil {
		t.Fatal("an unverified number confirmed identity")
	}
}

// The positive case, so the rule is not merely "refuse everything".
func TestASightedVerifiedIdentifierConfirmsIdentity(t *testing.T) {
	held := domain.IdentifierSet{{
		ID: "i-1", Status: domain.IdentifierActive, Assurance: domain.AssuranceVerified,
	}}
	if err := domain.CheckIdentityEvidence(
		domain.IdentityEvidence{IdentifierIDs: []string{"i-1"}, PhotoMatched: true},
		held); err != nil {
		t.Fatalf("a sighted verified identifier did not confirm identity: %v", err)
	}
}

// A verified identifier on file that nobody claims to have checked is not
// evidence that it was checked.
func TestAnUncheckedIdentifierOnFileIsNotEvidence(t *testing.T) {
	held := domain.IdentifierSet{{
		ID: "i-1", Status: domain.IdentifierActive, Assurance: domain.AssuranceVerified,
	}}
	if err := domain.CheckIdentityEvidence(domain.IdentityEvidence{}, held); err == nil {
		t.Fatal("identity was confirmed because a verified identifier happened to " +
			"be on the record, with nobody asserting it was sighted")
	}
}

// A revoked identifier belongs to somebody else.
func TestARevokedIdentifierIsNotIdentityEvidence(t *testing.T) {
	held := domain.IdentifierSet{{
		ID: "i-1", Status: domain.IdentifierRevoked, Assurance: domain.AssuranceVerified,
	}}
	if err := domain.CheckIdentityEvidence(
		domain.IdentityEvidence{IdentifierIDs: []string{"i-1"}}, held); err == nil {
		t.Fatal("a revoked identifier confirmed identity")
	}
}

func consent() domain.PhotoConsent {
	return domain.PhotoConsent{
		GivenBy: "patient", Purpose: "identification at the bedside",
		GivenAt: moment(2026, time.September, 12), RecordedBy: "clerk-1",
	}
}

// A photograph with no recorded consent is in the same position as one taken
// without asking.
func TestAPhotographNeedsRecordedConsent(t *testing.T) {
	if _, err := domain.NewPhoto("ph-1", "p-1", "key", "image/jpeg", 1024, "abc",
		domain.PhotoConsent{}, "clerk-1", moment(2026, time.September, 12)); err == nil {
		t.Fatal("a photograph was stored with no consent recorded")
	}
}

// "They agreed to a photo" is not consent to anything in particular.
func TestConsentMustStateItsPurpose(t *testing.T) {
	c := consent()
	c.Purpose = ""
	if _, err := domain.NewPhoto("ph-1", "p-1", "key", "image/jpeg", 1024, "abc",
		c, "clerk-1", moment(2026, time.September, 12)); err == nil {
		t.Fatal("consent was recorded with no stated purpose")
	}
}

// An allowlist, not a blocklist: a blocklist accepts SVG, which is a script
// container, and HTML renamed to .jpg.
func TestOnlyPhotographFormatsAreStored(t *testing.T) {
	for _, contentType := range []string{"image/svg+xml", "text/html", "application/pdf", ""} {
		if _, err := domain.NewPhoto("ph-1", "p-1", "key", contentType, 1024, "abc",
			consent(), "clerk-1", moment(2026, time.September, 12)); err == nil {
			t.Fatalf("%q was accepted as a photograph format", contentType)
		}
	}
	if _, err := domain.NewPhoto("ph-1", "p-1", "key", "image/jpeg", 1024, "abc",
		consent(), "clerk-1", moment(2026, time.September, 12)); err != nil {
		t.Fatalf("a JPEG was refused: %v", err)
	}
}

// This endpoint accepts bytes from a ward tablet; unbounded is a way to fill a
// disk from the registration desk.
func TestAPhotographIsSizeBounded(t *testing.T) {
	if _, err := domain.NewPhoto("ph-1", "p-1", "key", "image/jpeg",
		domain.MaxPhotoBytes+1, "abc", consent(), "clerk-1",
		moment(2026, time.September, 12)); err == nil {
		t.Fatal("an oversized photograph was accepted")
	}
}

// Withdrawal keeps the record and loses the bytes. A withdrawal that deleted
// the row leaves nobody able to answer whether a photograph ever existed.
func TestWithdrawingConsentKeepsTheRecord(t *testing.T) {
	photo, err := domain.NewPhoto("ph-1", "p-1", "key", "image/jpeg", 1024, "abc",
		consent(), "clerk-1", moment(2026, time.September, 12))
	if err != nil {
		t.Fatalf("NewPhoto: %v", err)
	}

	if err := photo.Withdraw("the patient asked for it to be removed",
		moment(2026, time.September, 13)); err != nil {
		t.Fatalf("Withdraw: %v", err)
	}
	if photo.Viewable() {
		t.Fatal("a withdrawn photograph is still viewable")
	}
	if photo.WithdrawnAt == nil || photo.WithdrawnReason == "" {
		t.Fatal("the withdrawal did not record when or why")
	}
	if photo.ID == "" || photo.Consent.GivenBy == "" {
		t.Fatal("withdrawal erased the record of the consent that was given")
	}
}

func fieldPolicy() domain.FieldAccessPolicy {
	return domain.DefaultFieldAccessPolicy("IN")
}

// "Where configured" is the operative phrase: a facility decides which fields
// are sensitive, and the address is the worked example — most restricted in a
// refuge, read back aloud in an outpatient department.
func TestFieldRestrictionsAreConfigurable(t *testing.T) {
	refuge := domain.FieldAccessPolicy{
		Jurisdiction: "IN",
		Restricted: map[domain.Field]string{
			domain.FieldAddress:    "empi.patient.read_address",
			domain.FieldFamilyName: "empi.patient.read_restricted",
		},
	}
	if err := refuge.Validate(); err != nil {
		t.Fatalf("Validate: %v", err)
	}

	holdsNothing := func(string) bool { return false }
	hidden := refuge.Hidden(holdsNothing)
	if len(hidden) != 2 {
		t.Fatalf("hidden = %+v, want both configured fields", hidden)
	}

	// The default policy does not restrict the family name, so this is the
	// configuration taking effect rather than a constant.
	for _, f := range fieldPolicy().Hidden(holdsNothing) {
		if f == domain.FieldFamilyName {
			t.Fatal("the default policy restricts the family name, so the " +
				"configured case proves nothing")
		}
	}
}

// A policy naming a permission this system has never granted must restrict the
// field, not open it.
func TestAnUnknownPermissionRestrictsRatherThanReveals(t *testing.T) {
	p := domain.FieldAccessPolicy{
		Jurisdiction: "IN",
		Restricted:   map[domain.Field]string{domain.FieldPhone: "empi.patient.read_nonexistent"},
	}
	holds := func(permission string) bool { return permission == domain.PermissionReadRestricted }

	hidden := p.Hidden(holds)
	if len(hidden) != 1 || hidden[0] != domain.FieldPhone {
		t.Fatalf("hidden = %+v; a field behind an unknown permission was revealed", hidden)
	}
}

// A field restricted behind no permission is restricted from everybody forever
// with nothing saying so.
func TestAFieldCannotBeRestrictedBehindNoPermission(t *testing.T) {
	p := domain.FieldAccessPolicy{
		Jurisdiction: "IN",
		Restricted:   map[domain.Field]string{domain.FieldPhone: ""},
	}
	if err := p.Validate(); err == nil {
		t.Fatal("a field was restricted behind no permission at all")
	}
}

// SRS-EMPI-014 requires the read to be audited, and what makes that audit worth
// keeping is which restricted fields were actually disclosed.
func TestRevealedFieldsAreReportedForTheAudit(t *testing.T) {
	holdsAll := func(string) bool { return true }
	revealed := fieldPolicy().Revealed(holdsAll)
	if len(revealed) == 0 {
		t.Fatal("a caller holding every permission revealed no restricted fields")
	}
	if len(fieldPolicy().Hidden(holdsAll)) != 0 {
		t.Fatal("a caller holding every permission still had fields hidden")
	}
}

// Masking narrows rather than blanks: a blank field reads as "not recorded",
// and a clerk who believes a number is missing asks the patient for it again.
func TestMaskingNarrowsRatherThanBlanks(t *testing.T) {
	d := domain.Demographics{
		Name:      domain.HumanName{Family: "Iyer", Given: []string{"Meera"}},
		BirthDate: domain.BirthDate{Date: moment(1984, time.March, 12), Precision: domain.PrecisionDay},
		Phones:    []domain.ContactPoint{{System: domain.ContactPhone, Value: "9876543210"}},
		Emails:    []domain.ContactPoint{{System: domain.ContactEmail, Value: "meera@example.com"}},
		Addresses: []domain.Address{{Lines: []string{"12 Nehru Road"}, City: "Bengaluru"}},
	}

	masked := d.MaskFields([]domain.Field{
		domain.FieldBirthDate, domain.FieldPhone, domain.FieldEmail, domain.FieldAddress,
	})

	if masked.BirthDate.Precision != domain.PrecisionYear {
		t.Fatalf("birth date precision = %q, want the year alone", masked.BirthDate.Precision)
	}
	if !strings.HasSuffix(masked.Phones[0].Value, "3210") {
		t.Fatalf("phone = %q, want the last four digits kept so a clerk can "+
			"confirm a number the patient reads out", masked.Phones[0].Value)
	}
	if !strings.HasSuffix(masked.Emails[0].Value, "@example.com") {
		t.Fatalf("email = %q, want the domain kept", masked.Emails[0].Value)
	}
	if masked.Addresses[0].City != "Bengaluru" || len(masked.Addresses[0].Lines) != 0 {
		t.Fatalf("address = %+v, want the settlement without the street", masked.Addresses[0])
	}
	// The name is untouched by default: masking it makes a comparison screen
	// useless, which pushes a clerk to open the full record instead.
	if masked.Name.Family != "Iyer" {
		t.Fatalf("family name = %q, want it left alone", masked.Name.Family)
	}
}
