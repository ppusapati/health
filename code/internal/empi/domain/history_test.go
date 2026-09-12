package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/empi/domain"
	"github.com/ppusapati/health/code/internal/platform/effective"
)

// Effective-dated demographics (SRS-EMPI-007) and related persons
// (SRS-EMPI-009).

func window(from, until time.Time) effective.Window {
	return effective.Window{From: from, Until: until}
}

var (
	march = time.Date(2026, 3, 1, 0, 0, 0, 0, time.UTC)
	july  = time.Date(2026, 7, 1, 0, 0, 0, 0, time.UTC)
	later = time.Date(2026, 9, 1, 0, 0, 0, 0, time.UTC)
)

func name(family string, given ...string) domain.HumanName {
	return domain.HumanName{Family: family, Given: given}
}

// The failure this exists to prevent: a patient marries, the desk overwrites
// the surname, and six months later a result addressed to the old name finds
// nobody — so a clerk files it under a new record, and now there are two.
func TestAPriorNameStaysSearchable(t *testing.T) {
	maiden, err := domain.NewPatientName("n1", "patient-1", domain.NameLegal,
		name("Iyer", "Meera"), window(march, july), "clerk-1", "registration", march)
	if err != nil {
		t.Fatalf("NewPatientName: %v", err)
	}
	married, err := domain.NewPatientName("n2", "patient-1", domain.NameLegal,
		name("Rao", "Meera"), window(july, time.Time{}), "clerk-1", "registration", july)
	if err != nil {
		t.Fatalf("NewPatientName: %v", err)
	}

	history := domain.NameHistory{maiden, married}

	searchable := history.Searchable()
	if len(searchable) != 2 {
		t.Fatalf("searchable names = %v, want both", searchable)
	}

	// And each window answers for its own interval.
	inMarch, ok := history.InForceAt(domain.NameLegal, march.AddDate(0, 1, 0))
	if !ok || inMarch.Name.Family != "Iyer" {
		t.Fatalf("April resolved to %q", inMarch.Name.Family)
	}
	inAugust, ok := history.InForceAt(domain.NameLegal, later)
	if !ok || inAugust.Name.Family != "Rao" {
		t.Fatalf("September resolved to %q", inAugust.Name.Family)
	}
}

// A preferred name is an additional way to address somebody, not a replacement
// for the one on the paperwork.
func TestAPreferredNameDoesNotDisplaceTheLegalOne(t *testing.T) {
	legal, err := domain.NewPatientName("n1", "patient-1", domain.NameLegal,
		name("Iyer", "Meenakshi"), window(march, time.Time{}), "clerk-1", "document", march)
	if err != nil {
		t.Fatalf("NewPatientName: %v", err)
	}
	preferred, err := domain.NewPatientName("n2", "patient-1", domain.NamePreferred,
		name("Iyer", "Meera"), window(march, time.Time{}), "clerk-1", "patient", march)
	if err != nil {
		t.Fatalf("NewPatientName: %v", err)
	}

	history := domain.NameHistory{legal, preferred}

	got, ok := history.InForceAt(domain.NameLegal, later)
	if !ok || got.Name.Given[0] != "Meenakshi" {
		t.Fatalf("the legal name resolved to %v", got.Name.Given)
	}
	if got, ok := history.InForceAt(domain.NamePreferred, later); !ok || got.Name.Given[0] != "Meera" {
		t.Fatalf("the preferred name resolved to %v", got.Name.Given)
	}
}

func TestARecordedNameNeedsAnActorAndContent(t *testing.T) {
	cases := map[string]struct {
		kind       domain.NameKind
		value      domain.HumanName
		recordedBy string
	}{
		"empty name": {domain.NameLegal, domain.HumanName{}, "clerk-1"},
		"no actor":   {domain.NameLegal, name("Iyer"), ""},
		"bad kind":   {domain.NameKind("nickname"), name("Iyer"), "clerk-1"},
	}

	for label, c := range cases {
		t.Run(label, func(t *testing.T) {
			_, err := domain.NewPatientName("n1", "patient-1", c.kind, c.value,
				window(march, time.Time{}), c.recordedBy, "registration", march)
			if !errors.Is(err, domain.ErrInvalidPatient) {
				t.Fatalf("NewPatientName = %v, want a refusal", err)
			}
		})
	}
}

// Communication preferences (SRS-EMPI-007, consumed by SRS-EMPI-013).

// Deny by default. Sending because the patient never said no is how an
// optional communication reaches somebody who did not want it.
func TestAnUnrecordedPreferenceDoesNotPermit(t *testing.T) {
	var set domain.PreferenceSet

	if set.Permits(domain.ChannelSMS, domain.PurposeAppointmentReminder, later) {
		t.Fatal("an absent preference permitted a message")
	}
	// And a UI can tell "declined" from "never asked", which are different
	// things to show a receptionist.
	if set.Recorded(domain.ChannelSMS, domain.PurposeAppointmentReminder, later) {
		t.Fatal("an absent preference reports as recorded")
	}
}

// The answers differ per purpose. Treating "reachable by SMS" as one setting is
// how a hospital texts somebody their results because they agreed to reminders.
func TestPreferencesAreHeldPerPurposeNotPerChannel(t *testing.T) {
	reminders, err := domain.NewCommunicationPreference("p1", "patient-1",
		domain.ChannelSMS, domain.PurposeAppointmentReminder, true,
		window(march, time.Time{}), "clerk-1", march)
	if err != nil {
		t.Fatalf("NewCommunicationPreference: %v", err)
	}
	results, err := domain.NewCommunicationPreference("p2", "patient-1",
		domain.ChannelSMS, domain.PurposeResults, false,
		window(march, time.Time{}), "clerk-1", march)
	if err != nil {
		t.Fatalf("NewCommunicationPreference: %v", err)
	}

	set := domain.PreferenceSet{reminders, results}

	if !set.Permits(domain.ChannelSMS, domain.PurposeAppointmentReminder, later) {
		t.Fatal("an agreed reminder was refused")
	}
	if set.Permits(domain.ChannelSMS, domain.PurposeResults, later) {
		t.Fatal("results were sent by SMS on the strength of a reminder preference")
	}
	// A refusal is recorded, which is not the same as an absent row.
	if !set.Recorded(domain.ChannelSMS, domain.PurposeResults, later) {
		t.Fatal("a recorded refusal reports as never asked")
	}
}

// A preference that expired is not a preference.
func TestAnExpiredPreferenceDoesNotPermit(t *testing.T) {
	expired, err := domain.NewCommunicationPreference("p1", "patient-1",
		domain.ChannelEmail, domain.PurposeHealthPromotion, true,
		window(march, july), "clerk-1", march)
	if err != nil {
		t.Fatalf("NewCommunicationPreference: %v", err)
	}

	set := domain.PreferenceSet{expired}
	if !set.Permits(domain.ChannelEmail, domain.PurposeHealthPromotion, march.AddDate(0, 1, 0)) {
		t.Fatal("a live preference was refused")
	}
	if set.Permits(domain.ChannelEmail, domain.PurposeHealthPromotion, later) {
		t.Fatal("an expired preference still permits")
	}
}

// Related persons (SRS-EMPI-009).

func guardian(t *testing.T, authorities []domain.Authority, w effective.Window) domain.RelatedPerson {
	t.Helper()
	r, err := domain.NewRelatedPerson("r1", "patient-1", domain.RelationshipGuardian,
		authorities, w, "clerk-1", march)
	if err != nil {
		t.Fatalf("NewRelatedPerson: %v", err)
	}
	if err := r.Identify("patient-2", domain.HumanName{}, nil); err != nil {
		t.Fatalf("Identify: %v", err)
	}
	return r
}

// "I am her son" is a sentence anybody can say at a reception desk. A system
// that grants access on the strength of it has a form, not access control.
func TestAnUnverifiedRelationshipCarriesNoAuthority(t *testing.T) {
	r := guardian(t, []domain.Authority{domain.AuthorityViewClinical}, window(march, time.Time{}))

	if got := r.AuthorityAt(later); len(got) != 0 {
		t.Fatalf("an unverified relationship granted %v", got)
	}
	if r.Permits(domain.AuthorityViewClinical, later) {
		t.Fatal("an unverified relationship permitted a clinical read")
	}

	if err := r.Verify("him-1", "birth certificate seen", march); err != nil {
		t.Fatalf("Verify: %v", err)
	}
	if !r.Permits(domain.AuthorityViewClinical, later) {
		t.Fatal("a verified relationship was refused")
	}
}

// Verification must say what was checked. "Birth certificate" and "she said so"
// are both verifications and only one of them holds up.
func TestVerificationMustSayWhatWasChecked(t *testing.T) {
	r := guardian(t, nil, window(march, time.Time{}))

	if err := r.Verify("him-1", "  ", march); !errors.Is(err, domain.ErrInvalidPatient) {
		t.Fatalf("Verify with no note = %v, want a refusal", err)
	}
	if err := r.Verify("", "birth certificate", march); !errors.Is(err, domain.ErrInvalidPatient) {
		t.Fatalf("Verify with no actor = %v, want a refusal", err)
	}
}

// The commonest caregiver relationship in a hospital ends on a date everybody
// can predict: a child turns eighteen.
func TestAnExpiredRelationshipCarriesNoAuthority(t *testing.T) {
	r := guardian(t, []domain.Authority{domain.AuthorityBookAppointments}, window(march, july))
	if err := r.Verify("him-1", "birth certificate seen", march); err != nil {
		t.Fatalf("Verify: %v", err)
	}

	if !r.Permits(domain.AuthorityBookAppointments, march.AddDate(0, 1, 0)) {
		t.Fatal("a live relationship was refused")
	}
	if r.Permits(domain.AuthorityBookAppointments, later) {
		t.Fatal("an expired relationship still permits booking")
	}
}

// The parent who brings a child to an appointment needs to book it and be told
// the time. They do not by that fact need the child's psychiatric notes.
func TestAuthorityIsScopedRatherThanAllOrNothing(t *testing.T) {
	r := guardian(t, []domain.Authority{
		domain.AuthorityViewDemographics, domain.AuthorityBookAppointments,
	}, window(march, time.Time{}))
	if err := r.Verify("him-1", "birth certificate seen", march); err != nil {
		t.Fatalf("Verify: %v", err)
	}

	if !r.Permits(domain.AuthorityBookAppointments, later) {
		t.Fatal("booking was refused")
	}
	if r.Permits(domain.AuthorityViewClinical, later) {
		t.Fatal("a booking grant carried the clinical record with it")
	}
	if r.Permits(domain.AuthorityConsent, later) {
		t.Fatal("a booking grant carried consent authority with it")
	}
}

// An emergency contact is somebody to telephone. A relationship mis-typed as
// one must be recorded correctly rather than quietly widened.
func TestAnEmergencyContactCannotHoldAuthority(t *testing.T) {
	_, err := domain.NewRelatedPerson("r1", "patient-1", domain.RelationshipEmergencyContact,
		[]domain.Authority{domain.AuthorityViewClinical}, window(march, time.Time{}), "clerk-1", march)
	if !errors.Is(err, domain.ErrInvalidPatient) {
		t.Fatalf("NewRelatedPerson = %v, want a refusal", err)
	}

	// With no authority it is fine, because that is what an emergency contact
	// is.
	if _, err := domain.NewRelatedPerson("r1", "patient-1", domain.RelationshipEmergencyContact,
		nil, window(march, time.Time{}), "clerk-1", march); err != nil {
		t.Fatalf("an emergency contact with no authority was refused: %v", err)
	}
}

// A person can be both a parent and a nominated caregiver. The narrower must
// not silently cancel the wider.
func TestAuthorityUnionsAcrossRelationships(t *testing.T) {
	asParent, err := domain.NewRelatedPerson("r1", "patient-1", domain.RelationshipParent,
		[]domain.Authority{domain.AuthorityBookAppointments}, window(march, time.Time{}), "clerk-1", march)
	if err != nil {
		t.Fatalf("NewRelatedPerson: %v", err)
	}
	if err := asParent.Identify("patient-2", domain.HumanName{}, nil); err != nil {
		t.Fatalf("Identify: %v", err)
	}
	if err := asParent.Verify("him-1", "birth certificate", march); err != nil {
		t.Fatalf("Verify: %v", err)
	}

	asCaregiver, err := domain.NewRelatedPerson("r2", "patient-1", domain.RelationshipCaregiver,
		[]domain.Authority{domain.AuthorityViewClinical}, window(march, time.Time{}), "clerk-1", march)
	if err != nil {
		t.Fatalf("NewRelatedPerson: %v", err)
	}
	if err := asCaregiver.Identify("patient-2", domain.HumanName{}, nil); err != nil {
		t.Fatalf("Identify: %v", err)
	}
	if err := asCaregiver.Verify("him-1", "care plan", march); err != nil {
		t.Fatalf("Verify: %v", err)
	}

	set := domain.RelatedPersonSet{asParent, asCaregiver}
	granted := set.AuthorityFor("patient-2", later)
	if len(granted) != 2 {
		t.Fatalf("the union granted %v, want both authorities", granted)
	}

	// And nobody else gets anything.
	if other := set.AuthorityFor("patient-9", later); len(other) != 0 {
		t.Fatalf("an unrelated person was granted %v", other)
	}
}

// A care-home key worker will never have a record of their own, and refusing
// to store them pushes staff to write the name in a free-text note.
func TestARelatedPersonNeedsEitherALinkedPatientOrAName(t *testing.T) {
	r, err := domain.NewRelatedPerson("r1", "patient-1", domain.RelationshipCaregiver,
		nil, window(march, time.Time{}), "clerk-1", march)
	if err != nil {
		t.Fatalf("NewRelatedPerson: %v", err)
	}

	if err := r.Identify("", domain.HumanName{}, nil); !errors.Is(err, domain.ErrInvalidPatient) {
		t.Fatalf("Identify with nothing = %v, want a refusal", err)
	}
	if err := r.Identify("", name("Kumar", "Anil"),
		[]domain.ContactPoint{{System: domain.ContactPhone, Value: "+91 98765 43210"}}); err != nil {
		t.Fatalf("Identify by name: %v", err)
	}
	// Contact details normalise the same way a patient's do, so the same
	// number is one value whichever form it arrived in.
	if r.Contact[0].Value != "919876543210" {
		t.Fatalf("contact = %q, not normalised", r.Contact[0].Value)
	}
}

func TestAnUnknownAuthorityIsRefused(t *testing.T) {
	_, err := domain.NewRelatedPerson("r1", "patient-1", domain.RelationshipGuardian,
		[]domain.Authority{"everything"}, window(march, time.Time{}), "clerk-1", march)
	if !errors.Is(err, domain.ErrInvalidPatient) {
		t.Fatalf("NewRelatedPerson = %v, want a refusal", err)
	}
}
