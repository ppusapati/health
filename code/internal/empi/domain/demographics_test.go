package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/empi/domain"
)

// Normalisation is where duplicates are prevented or created. The same person
// registered twice, once as "+91 98765 43210" and once as "09876543210", is
// two records unless normalisation makes those one value — and no amount of
// clever matching downstream recovers what was lost at the door.

func TestPhoneNumbersNormaliseToDigits(t *testing.T) {
	d := domain.Demographics{
		Name: domain.HumanName{Family: "Iyer"}, Sex: domain.SexFemale,
		Phones: []domain.ContactPoint{
			{Value: "+91 98765 43210"},
			{Value: "(080) 2345-6789"},
		},
	}

	out, err := d.Normalise()
	if err != nil {
		t.Fatalf("Normalise: %v", err)
	}
	if got := out.Phones[0].Value; got != "919876543210" {
		t.Fatalf("phone = %q, want digits only", got)
	}
	if got := out.Phones[1].Value; got != "08023456789" {
		t.Fatalf("phone = %q, want digits only", got)
	}
	if out.Phones[0].System != domain.ContactPhone {
		t.Fatal("the contact system was not set")
	}
}

// The same number entered twice is one way to reach the patient. Two rows
// would double its weight in the matcher, which is how a coincidence becomes a
// confident match.
func TestDuplicateContactPointsCollapse(t *testing.T) {
	d := domain.Demographics{
		Name: domain.HumanName{Family: "Iyer"}, Sex: domain.SexFemale,
		Phones: []domain.ContactPoint{
			{Value: "9876543210"},
			{Value: "98765 43210"},
			{Value: "9876543210"},
		},
	}

	out, err := d.Normalise()
	if err != nil {
		t.Fatalf("Normalise: %v", err)
	}
	if len(out.Phones) != 1 {
		t.Fatalf("got %d phones, want 1: %+v", len(out.Phones), out.Phones)
	}
}

func TestEmailsLowercaseAndMustLookLikeAddresses(t *testing.T) {
	good, err := domain.Demographics{
		Name: domain.HumanName{Family: "Iyer"}, Sex: domain.SexFemale,
		Emails: []domain.ContactPoint{{Value: "  Meera.Iyer@Example.COM "}},
	}.Normalise()
	if err != nil {
		t.Fatalf("Normalise: %v", err)
	}
	if got := good.Emails[0].Value; got != "meera.iyer@example.com" {
		t.Fatalf("email = %q", got)
	}

	_, err = domain.Demographics{
		Name: domain.HumanName{Family: "Iyer"}, Sex: domain.SexFemale,
		Emails: []domain.ContactPoint{{Value: "not-an-address"}},
	}.Normalise()
	if !errors.Is(err, domain.ErrInvalidPatient) {
		t.Fatalf("a malformed email was accepted: %v", err)
	}
}

// Case survives normalisation because a name is displayed back to the person
// it belongs to, and upper-casing for storage produces a wristband that
// shouts. Matching folds case itself.
func TestNameCaseIsPreservedAndWhitespaceCollapses(t *testing.T) {
	out, err := domain.Demographics{
		Name: domain.HumanName{Family: "  van   der  Berg ", Given: []string{" Anne ", "  ", "Marie"}},
		Sex:  domain.SexFemale,
	}.Normalise()
	if err != nil {
		t.Fatalf("Normalise: %v", err)
	}
	if out.Name.Family != "van der Berg" {
		t.Fatalf("family = %q", out.Name.Family)
	}
	// The blank given name is dropped rather than stored as empty.
	if len(out.Name.Given) != 2 || out.Name.Given[0] != "Anne" || out.Name.Given[1] != "Marie" {
		t.Fatalf("given = %#v", out.Name.Given)
	}
}

// A birth date carrying a time of day is an artefact of whatever parsed it,
// and two records for one person would differ by milliseconds nobody entered.
func TestBirthDatesTruncateToTheDay(t *testing.T) {
	out, err := domain.Demographics{
		Name: domain.HumanName{Family: "Iyer"}, Sex: domain.SexFemale,
		BirthDate: domain.BirthDate{
			Date:      time.Date(1984, 3, 12, 14, 37, 22, 500, time.UTC),
			Precision: domain.PrecisionDay,
		},
	}.Normalise()
	if err != nil {
		t.Fatalf("Normalise: %v", err)
	}
	if !out.BirthDate.Date.Equal(time.Date(1984, 3, 12, 0, 0, 0, 0, time.UTC)) {
		t.Fatalf("birth date = %v", out.BirthDate.Date)
	}
}

// A date with no precision is a false precision waiting to happen: the matcher
// would weigh a guess as a document.
func TestABirthDateWithoutPrecisionIsRefused(t *testing.T) {
	_, err := domain.Demographics{
		Name: domain.HumanName{Family: "Iyer"}, Sex: domain.SexFemale,
		BirthDate: domain.BirthDate{Date: time.Date(1984, 3, 12, 0, 0, 0, 0, time.UTC)},
	}.Normalise()
	if !errors.Is(err, domain.ErrInvalidPatient) {
		t.Fatalf("Normalise = %v, want a refusal", err)
	}
}

func TestAnUnsetSexNormalisesToUnknownRatherThanEmpty(t *testing.T) {
	out, err := domain.Demographics{Name: domain.HumanName{Family: "Iyer"}}.Normalise()
	if err != nil {
		t.Fatalf("Normalise: %v", err)
	}
	// "Unknown" is a recorded answer; the empty string is an unanswered
	// question. The policy check distinguishes them, so normalisation has to
	// produce the former.
	if out.Sex != domain.SexUnknown {
		t.Fatalf("Sex = %q, want unknown", out.Sex)
	}
}

func TestAnUnknownSexValueIsRefused(t *testing.T) {
	_, err := domain.Demographics{
		Name: domain.HumanName{Family: "Iyer"}, Sex: domain.Sex("F"),
	}.Normalise()
	if !errors.Is(err, domain.ErrInvalidPatient) {
		t.Fatalf("Normalise = %v, want a refusal", err)
	}
}

// A patient with four hundred phone numbers is a bad import, not a
// well-connected person, and the matcher would compare every one of them.
func TestCollectionSizesAreBounded(t *testing.T) {
	phones := make([]domain.ContactPoint, domain.MaxContactPoints+1)
	for i := range phones {
		phones[i] = domain.ContactPoint{Value: "90000000" + string(rune('0'+i%10)) + "0"}
	}

	_, err := domain.Demographics{
		Name: domain.HumanName{Family: "Iyer"}, Sex: domain.SexFemale, Phones: phones,
	}.Normalise()
	if !errors.Is(err, domain.ErrInvalidPatient) {
		t.Fatalf("Normalise = %v, want a refusal", err)
	}
}

// Normalise returns a copy. Mutating the caller's input would let a bug
// surface three layers away as "the value changed under me".
func TestNormaliseDoesNotMutateItsInput(t *testing.T) {
	in := domain.Demographics{
		Name:   domain.HumanName{Family: "  Iyer  ", Given: []string{" Meera "}},
		Sex:    domain.SexFemale,
		Phones: []domain.ContactPoint{{Value: "+91 98765 43210"}},
	}

	if _, err := in.Normalise(); err != nil {
		t.Fatalf("Normalise: %v", err)
	}
	if in.Name.Family != "  Iyer  " || in.Phones[0].Value != "+91 98765 43210" {
		t.Fatalf("Normalise mutated its input: %+v", in)
	}
}

func TestNameDisplayOrdersTheParts(t *testing.T) {
	n := domain.HumanName{Prefix: "Dr", Given: []string{"Meera", "Lakshmi"}, Family: "Iyer", Suffix: "MD"}
	if got := n.Display(); got != "Dr Meera Lakshmi Iyer MD" {
		t.Fatalf("Display() = %q", got)
	}
}
