package domain_test

import (
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/empi/domain"
)

// Duplicate detection (SRS-EMPI-003, SRS-EMPI-004).
//
// The asymmetry that shapes every test here: a missed duplicate means a
// clinician sees half a history, which is bad and visible. A wrong merge fuses
// two people's allergies and medications into one chart, which is catastrophic
// and invisible until it hurts somebody. So the scorer is allowed to be
// confident about "these are different" and never about "merge these".

func birth(y int, m time.Month, d int, p domain.DatePrecision) domain.BirthDate {
	return domain.BirthDate{Date: time.Date(y, m, d, 0, 0, 0, 0, time.UTC), Precision: p}
}

func demo(family string, given []string, b domain.BirthDate, sex domain.Sex, phone string) domain.Demographics {
	d := domain.Demographics{
		Name: domain.HumanName{Family: family, Given: given}, BirthDate: b, Sex: sex,
	}
	if phone != "" {
		d.Phones = []domain.ContactPoint{{System: domain.ContactPhone, Value: phone}}
	}
	normalised, err := d.Normalise()
	if err != nil {
		panic(err)
	}
	return normalised
}

func score(t *testing.T, a domain.Demographics, aIDs domain.IdentifierSet,
	b domain.Demographics, bIDs domain.IdentifierSet) domain.MatchResult {

	t.Helper()
	return domain.Score(a, aIDs, domain.MatchCandidate{
		PatientID: "candidate", Demographics: b, Identifiers: bIDs,
	}, domain.DefaultWeights(), domain.DefaultThresholds())
}

func TestAnIdenticalRecordScoresAsProbable(t *testing.T) {
	d := demo("Iyer", []string{"Meera"}, birth(1984, time.March, 12, domain.PrecisionDay),
		domain.SexFemale, "9876543210")

	result := score(t, d, nil, d, nil)
	if result.Outcome != domain.OutcomeProbable {
		t.Fatalf("Outcome = %q (score %.2f), want probable", result.Outcome, result.Score)
	}
	// And still not a merge instruction. There is no outcome that authorises
	// one, which is the point.
	for _, outcome := range []domain.MatchOutcome{result.Outcome} {
		if string(outcome) == "merge" {
			t.Fatal("the scorer produced a merge verdict")
		}
	}
}

func TestTwoUnrelatedPeopleScoreAsDistinct(t *testing.T) {
	a := demo("Iyer", []string{"Meera"}, birth(1984, time.March, 12, domain.PrecisionDay),
		domain.SexFemale, "9876543210")
	b := demo("Banerjee", []string{"Arjun"}, birth(1959, time.November, 2, domain.PrecisionDay),
		domain.SexMale, "9000000001")

	result := score(t, a, nil, b, nil)
	if result.Outcome != domain.OutcomeDistinct {
		t.Fatalf("Outcome = %q (score %.2f), want distinct", result.Outcome, result.Score)
	}
}

// The safety rule that matters most: two records with different national
// health identifiers are two people whatever the demographics say. A scorer
// that only ever added points would rank identical twins with the same
// initials as a near-certain match.
func TestADifferingStrongIdentifierOverridesEveryOtherSignal(t *testing.T) {
	d := demo("Iyer", []string{"Meera"}, birth(1984, time.March, 12, domain.PrecisionDay),
		domain.SexFemale, "9876543210")

	mine := domain.IdentifierSet{{
		Type: domain.IdentifierNationalHealth, System: "abdm", Value: "11-1111-1111-1111",
		Status: domain.IdentifierActive,
	}}
	theirs := domain.IdentifierSet{{
		Type: domain.IdentifierNationalHealth, System: "abdm", Value: "22-2222-2222-2222",
		Status: domain.IdentifierActive,
	}}

	result := score(t, d, mine, d, theirs)
	if result.Outcome != domain.OutcomeConflict {
		t.Fatalf("Outcome = %q (score %.2f), want conflict — identical demographics with different ABHA numbers",
			result.Outcome, result.Score)
	}
}

func TestAMatchingStrongIdentifierDominates(t *testing.T) {
	// Demographics disagree on almost everything: a married name, a different
	// phone, an approximate birth date.
	a := demo("Rao", []string{"Meera"}, birth(1984, time.March, 12, domain.PrecisionDay),
		domain.SexFemale, "9876543210")
	b := demo("Iyer", []string{"Meera"}, birth(1984, time.January, 1, domain.PrecisionEstimated),
		domain.SexFemale, "9000000002")

	shared := "11-1111-1111-1111"
	result := score(t,
		a, domain.IdentifierSet{{Type: domain.IdentifierNationalHealth, System: "abdm", Value: shared, Status: domain.IdentifierActive}},
		b, domain.IdentifierSet{{Type: domain.IdentifierNationalHealth, System: "abdm", Value: shared, Status: domain.IdentifierActive}})

	if result.Outcome != domain.OutcomeProbable {
		t.Fatalf("Outcome = %q (score %.2f), want probable on a shared ABHA", result.Outcome, result.Score)
	}
}

// A revoked identifier was attached in error. Matching on it reproduces the
// original mistake, which is how one bad link becomes a merge.
func TestARevokedIdentifierIsNotEvidence(t *testing.T) {
	a := demo("Iyer", []string{"Meera"}, birth(1984, time.March, 12, domain.PrecisionDay),
		domain.SexFemale, "")
	b := demo("Banerjee", []string{"Arjun"}, birth(1959, time.November, 2, domain.PrecisionDay),
		domain.SexMale, "")

	shared := "11-1111-1111-1111"
	result := score(t,
		a, domain.IdentifierSet{{Type: domain.IdentifierNationalHealth, System: "abdm", Value: shared, Status: domain.IdentifierActive}},
		b, domain.IdentifierSet{{Type: domain.IdentifierNationalHealth, System: "abdm", Value: shared, Status: domain.IdentifierRevoked}})

	if result.Outcome == domain.OutcomeProbable {
		t.Fatalf("a revoked identifier produced a probable match (score %.2f)", result.Score)
	}
}

// The patient quoted the MRN from an old card. That is exactly what prior
// identifier scoring exists for.
func TestASupersededMRNIsPositiveEvidence(t *testing.T) {
	d := demo("Iyer", []string{"Meera"}, birth(1984, time.March, 12, domain.PrecisionDay),
		domain.SexFemale, "")

	// Demographics that do not already max out the score, so the identifier's
	// contribution is visible rather than hidden under a ceiling.
	other := demo("Iyer", []string{"Meera"}, birth(1971, time.July, 4, domain.PrecisionDay),
		domain.SexFemale, "")

	quoted := domain.IdentifierSet{{
		Type: domain.IdentifierMRN, System: "facility-1", Value: "MRN-0001",
		Status: domain.IdentifierActive,
	}}
	held := domain.IdentifierSet{{
		Type: domain.IdentifierMRN, System: "facility-1", Value: "MRN-0001",
		Status: domain.IdentifierSuperseded,
	}}

	withPrior := score(t, d, quoted, other, held)
	withoutPrior := score(t, d, nil, other, nil)
	if withPrior.Score <= withoutPrior.Score {
		t.Fatalf("a matching prior MRN did not raise confidence: %.2f vs %.2f",
			withPrior.Score, withoutPrior.Score)
	}
}

// Registration systems that ask for one "name" field and split on the space
// produce transpositions constantly, and in populations that write the family
// name first it is the norm rather than the accident.
func TestATransposedNameIsRecognised(t *testing.T) {
	a := demo("Iyer", []string{"Meera"}, birth(1984, time.March, 12, domain.PrecisionDay),
		domain.SexFemale, "")
	b := demo("Meera", []string{"Iyer"}, birth(1984, time.March, 12, domain.PrecisionDay),
		domain.SexFemale, "")

	result := score(t, a, nil, b, nil)
	if result.Outcome == domain.OutcomeDistinct {
		t.Fatalf("a transposed name scored as distinct (%.2f)", result.Score)
	}

	var noted bool
	for _, f := range result.Fields {
		if f.Note == "names appear transposed" {
			noted = true
		}
	}
	if !noted {
		t.Fatal("the transposition was not explained in the field breakdown")
	}
}

// An estimated date comes from "about forty". Treating it as a day-precision
// match would give a guess the weight of a document.
func TestAnEstimatedBirthDateIsWeakEvidence(t *testing.T) {
	exact := demo("Iyer", []string{"Meera"}, birth(1984, time.March, 12, domain.PrecisionDay),
		domain.SexFemale, "")
	estimated := demo("Iyer", []string{"Meera"}, birth(1984, time.January, 1, domain.PrecisionEstimated),
		domain.SexFemale, "")

	result := score(t, exact, nil, estimated, nil)

	for _, f := range result.Fields {
		if f.Field == domain.FieldBirthDate {
			if f.Similarity > 0.5 {
				t.Fatalf("an estimated birth date scored %.2f, which is document-strength", f.Similarity)
			}
			if f.Note != "estimated age" {
				t.Fatalf("the weakness was not explained: note = %q", f.Note)
			}
			return
		}
	}
	t.Fatal("the birth date was not compared at all")
}

// 03/12 against 12/03 is the commonest birth-date error there is. Scoring it
// as a flat mismatch discards the single strongest hint that two records are
// one person.
func TestATransposedBirthDateIsNoticed(t *testing.T) {
	a := demo("Iyer", []string{"Meera"}, birth(1984, time.March, 12, domain.PrecisionDay),
		domain.SexFemale, "")
	b := demo("Iyer", []string{"Meera"}, birth(1984, time.December, 3, domain.PrecisionDay),
		domain.SexFemale, "")

	result := score(t, a, nil, b, nil)
	for _, f := range result.Fields {
		if f.Field == domain.FieldBirthDate && f.Note == "day and month appear transposed" {
			return
		}
	}
	t.Fatalf("the transposition was not noticed: %+v", result.Fields)
}

// Scoring a missing field as a mismatch pushes every sparse emergency
// registration towards "distinct" — which is the case where a duplicate is
// both most likely and most dangerous.
func TestMissingFieldsAreNotScoredAsMismatches(t *testing.T) {
	sparse := demo("Iyer", nil, domain.BirthDate{}, domain.SexUnknown, "")
	full := demo("Iyer", []string{"Meera"}, birth(1984, time.March, 12, domain.PrecisionDay),
		domain.SexFemale, "9876543210")

	result := score(t, sparse, nil, full, nil)

	for _, f := range result.Fields {
		switch f.Field {
		case domain.FieldBirthDate, domain.FieldSex, domain.FieldPhone, domain.FieldGivenName:
			t.Fatalf("%s was scored although one side did not supply it", f.Field)
		}
	}
	// The surname matched and nothing contradicted it, so this is at worst a
	// warning — never a confident "different people".
	if result.Score < 0.9 {
		t.Fatalf("score = %.2f; the one comparable field matched exactly", result.Score)
	}
}

// Nothing comparable is not the same as nothing in common.
func TestNoComparableFieldsProducesNoEvidence(t *testing.T) {
	a := demo("", nil, domain.BirthDate{}, domain.SexUnknown, "")
	b := demo("Iyer", []string{"Meera"}, birth(1984, time.March, 12, domain.PrecisionDay),
		domain.SexFemale, "9876543210")

	result := score(t, a, nil, b, nil)
	if len(result.Fields) != 0 {
		t.Fatalf("fields were scored with nothing to compare: %+v", result.Fields)
	}
	if result.Score != 0 || result.Outcome != domain.OutcomeDistinct {
		t.Fatalf("score %.2f outcome %q", result.Score, result.Outcome)
	}
}

// SRS-EMPI-003 requires duplicates to be "shown with confidence". A bare
// number is not reviewable: the clerk needs to see which fields agreed.
func TestTheBreakdownExplainsTheScore(t *testing.T) {
	d := demo("Iyer", []string{"Meera"}, birth(1984, time.March, 12, domain.PrecisionDay),
		domain.SexFemale, "9876543210")

	result := score(t, d, nil, d, nil)
	seen := map[domain.Field]bool{}
	for _, f := range result.Fields {
		seen[f.Field] = true
		if f.Weight <= 0 {
			t.Fatalf("%s was reported with no weight", f.Field)
		}
	}
	for _, want := range []domain.Field{
		domain.FieldFamilyName, domain.FieldGivenName,
		domain.FieldBirthDate, domain.FieldSex, domain.FieldPhone,
	} {
		if !seen[want] {
			t.Fatalf("%s is missing from the breakdown", want)
		}
	}
}

// Weights are configurable because the right ones depend on the population: in
// a catchment where a handful of surnames cover most of the register, a name
// match means far less than a phone match.
func TestWeightsChangeTheOutcome(t *testing.T) {
	a := demo("Iyer", []string{"Meera"}, birth(1984, time.March, 12, domain.PrecisionDay),
		domain.SexFemale, "9876543210")
	b := demo("Iyer", []string{"Meera"}, birth(1971, time.July, 4, domain.PrecisionDay),
		domain.SexFemale, "9000000009")

	nameHeavy := domain.MatchWeights{FamilyName: 10, GivenName: 10, BirthDate: 1, Sex: 0.5, Phone: 1}
	dateHeavy := domain.MatchWeights{FamilyName: 1, GivenName: 1, BirthDate: 10, Sex: 0.5, Phone: 10}

	withNames := domain.Score(a, nil, domain.MatchCandidate{Demographics: b},
		nameHeavy, domain.DefaultThresholds())
	withDates := domain.Score(a, nil, domain.MatchCandidate{Demographics: b},
		dateHeavy, domain.DefaultThresholds())

	if withNames.Score <= withDates.Score {
		t.Fatalf("weights had no effect: name-heavy %.2f, date-heavy %.2f",
			withNames.Score, withDates.Score)
	}
}

func TestInvertedThresholdsAreRefused(t *testing.T) {
	if err := (domain.MatchThresholds{Review: 0.8, Probable: 0.4}).Validate(); err == nil {
		t.Fatal("inverted thresholds were accepted; the probable band would be unreachable")
	}
	if err := (domain.MatchThresholds{Review: -1, Probable: 2}).Validate(); err == nil {
		t.Fatal("out-of-range thresholds were accepted")
	}
	if err := domain.DefaultThresholds().Validate(); err != nil {
		t.Fatalf("the defaults do not validate: %v", err)
	}
}

// A score outside 0..1 cannot be rendered as a confidence, and a conflict can
// drive the weighted sum negative.
func TestTheScoreStaysWithinBounds(t *testing.T) {
	a := demo("Iyer", []string{"Meera"}, birth(1984, time.March, 12, domain.PrecisionDay),
		domain.SexFemale, "9876543210")

	result := score(t,
		a, domain.IdentifierSet{{Type: domain.IdentifierGovernment, System: "pan", Value: "AAAAA1111A", Status: domain.IdentifierActive}},
		a, domain.IdentifierSet{{Type: domain.IdentifierGovernment, System: "pan", Value: "BBBBB2222B", Status: domain.IdentifierActive}})

	if result.Score < 0 || result.Score > 1 {
		t.Fatalf("score = %.2f, outside 0..1", result.Score)
	}
}
