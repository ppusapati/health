package domain

import (
	"fmt"
	"math"
	"sort"
	"strings"
	"time"
	"unicode"
)

// Duplicate detection (SRS-EMPI-003, SRS-EMPI-004).
//
// The requirement is a confidence score over "name, phone, DOB/age, sex,
// address, government/health identifiers and prior identifiers", with
// thresholds routing to auto-clear, warning or manual review, and — the
// sentence that shapes everything here — "no unsafe auto-merge".
//
// That last clause is a design constraint, not a caution. This scorer has no
// outcome that means "merge". Its strongest verdict is that two records are
// probably the same person and a human should look, because the cost of the
// two errors is wildly asymmetric: a missed duplicate means a clinician sees
// half a history, which is bad and visible; a wrong merge fuses two people's
// allergies and medications into one chart, which is catastrophic and
// invisible until it hurts somebody. Automation is allowed to reduce human
// work on the safe side of that asymmetry and nowhere else.
//
// A second rule, easy to miss: strong identifiers can *lower* confidence.
// Two records with different national health identifiers are two people, and a
// scorer that only ever added points would happily rank them as a match on the
// strength of a shared name and town.

// MatchOutcome is what a score means operationally.
type MatchOutcome string

const (
	// OutcomeDistinct is below the review threshold: register without warning.
	OutcomeDistinct MatchOutcome = "distinct"
	// OutcomeReview is a possible duplicate. Registration continues, with the
	// candidate shown — this is the "warning" band.
	OutcomeReview MatchOutcome = "review"
	// OutcomeProbable is a likely duplicate and routes to manual review. It
	// does NOT authorise a merge.
	OutcomeProbable MatchOutcome = "probable"
	// OutcomeConflict is a strong negative: an identifier says these are
	// different people whatever the demographics suggest.
	OutcomeConflict MatchOutcome = "conflict"
)

// MatchWeights is the configurable contribution of each signal.
//
// Configurable because the right weights depend on the population: in a
// catchment where a handful of surnames cover most of the register, a name
// match means far less than a phone match, and a tenant that cannot tune this
// will either drown in false positives or miss real duplicates.
type MatchWeights struct {
	FamilyName       float64
	GivenName        float64
	BirthDate        float64
	Sex              float64
	Phone            float64
	Address          float64
	StrongIdentifier float64
	PriorIdentifier  float64
}

// DefaultWeights is the starting point a tenant tunes from.
//
// Shaped by discriminating power rather than by intuition. A shared phone
// number is worth more than a shared surname because far fewer people share
// one; sex is worth almost nothing on its own because it splits the population
// roughly in half; a matching government or health identifier dominates
// because it is issued to one person.
func DefaultWeights() MatchWeights {
	return MatchWeights{
		FamilyName:       2.0,
		GivenName:        2.0,
		BirthDate:        3.0,
		Sex:              0.5,
		Phone:            3.0,
		Address:          1.5,
		StrongIdentifier: 8.0,
		PriorIdentifier:  4.0,
	}
}

// MatchThresholds route a score to an outcome.
type MatchThresholds struct {
	// Review is the lower bound of the warning band.
	Review float64
	// Probable is the lower bound of manual review.
	Probable float64
}

// DefaultThresholds are deliberately cautious at the top end.
func DefaultThresholds() MatchThresholds {
	return MatchThresholds{Review: 0.45, Probable: 0.75}
}

// Validate rejects thresholds that would misroute.
func (t MatchThresholds) Validate() error {
	switch {
	case t.Review < 0 || t.Review > 1 || t.Probable < 0 || t.Probable > 1:
		return fmt.Errorf("%w: thresholds must be between 0 and 1", ErrInvalidPatient)
	case t.Probable < t.Review:
		// Inverted thresholds would make the probable band unreachable and
		// silently downgrade every real duplicate to a warning.
		return fmt.Errorf("%w: the probable threshold must not be below the review threshold",
			ErrInvalidPatient)
	}
	return nil
}

// FieldScore is one signal's contribution, kept for explainability.
//
// SRS-EMPI-003 requires potential duplicates to be "shown with confidence".
// A number with no breakdown is not reviewable: the clerk deciding whether two
// records are one person needs to see that the phone matched and the birth
// date did not.
type FieldScore struct {
	Field Field
	// Similarity is 0..1 for this signal, or -1 when the signal actively says
	// these are different people.
	Similarity float64
	Weight     float64
	// Note is a short, non-PHI explanation such as "year only" or
	// "different national health identifier".
	Note string
}

// MatchResult is a scored comparison of two records.
type MatchResult struct {
	// Score is 0..1. Clamped: a conflict can drive the weighted sum negative,
	// and a negative confidence is not a thing a UI can render.
	Score   float64
	Outcome MatchOutcome
	Fields  []FieldScore
}

// MatchCandidate is the other side of a comparison.
//
// Identifiers travel with it because SRS-EMPI-004 scores on "government/health
// identifiers and prior identifiers", and a prior identifier is one that has
// been superseded — the MRN a patient quoted from an old card.
type MatchCandidate struct {
	PatientID    string
	Demographics Demographics
	Identifiers  IdentifierSet
}

// Score compares a proposed registration against a candidate record.
//
// Only signals both sides carry are weighed. Scoring a missing field as a
// mismatch would push every sparse emergency registration towards "distinct",
// which is the wrong direction: an unconscious patient with only a surname is
// exactly the case where a duplicate is most likely and most dangerous.
func Score(proposed Demographics, proposedIdentifiers IdentifierSet,
	candidate MatchCandidate, w MatchWeights, t MatchThresholds) MatchResult {

	var fields []FieldScore
	var weighted, total float64

	add := func(field Field, similarity, weight float64, note string) {
		if weight <= 0 {
			return
		}
		fields = append(fields, FieldScore{Field: field, Similarity: similarity, Weight: weight, Note: note})
		weighted += similarity * weight
		total += weight
	}

	// Names. Compared with Jaro-Winkler rather than for equality: "Krishnan"
	// and "Krishnnan" are one transposition apart and are the same person far
	// more often than not.
	if a, b := fold(proposed.Name.Family), fold(candidate.Demographics.Name.Family); a != "" && b != "" {
		add(FieldFamilyName, jaroWinkler(a, b), w.FamilyName, "")
	}
	if a, b := foldGiven(proposed.Name.Given), foldGiven(candidate.Demographics.Name.Given); a != "" && b != "" {
		add(FieldGivenName, jaroWinkler(a, b), w.GivenName, "")
	}

	// The swapped-name case. Registration systems that ask for "name" and
	// split on the space produce it constantly, and in populations where the
	// family name is written first it is the norm rather than the accident.
	if swapped := swappedNameSimilarity(proposed.Name, candidate.Demographics.Name); swapped > 0 {
		add(FieldGivenName, swapped, w.GivenName/2, "names appear transposed")
	}

	if similarity, note, ok := compareBirthDates(proposed.BirthDate, candidate.Demographics.BirthDate); ok {
		add(FieldBirthDate, similarity, w.BirthDate, note)
	}

	if proposed.Sex != SexUnknown && candidate.Demographics.Sex != SexUnknown {
		similarity := 0.0
		if proposed.Sex == candidate.Demographics.Sex {
			similarity = 1
		}
		add(FieldSex, similarity, w.Sex, "")
	}

	if similarity, ok := compareContacts(proposed.Phones, candidate.Demographics.Phones); ok {
		add(FieldPhone, similarity, w.Phone, "")
	}
	if similarity, ok := compareAddresses(proposed.Addresses, candidate.Demographics.Addresses); ok {
		add(FieldAddress, similarity, w.Address, "")
	}

	strong, prior := compareIdentifiers(proposedIdentifiers, candidate.Identifiers)
	for _, s := range strong {
		add(FieldFamilyName, s.Similarity, w.StrongIdentifier, s.Note)
		fields[len(fields)-1].Field = Field("strong_identifier")
	}
	for _, s := range prior {
		add(FieldFamilyName, s.Similarity, w.PriorIdentifier, s.Note)
		fields[len(fields)-1].Field = Field("prior_identifier")
	}

	result := MatchResult{Fields: fields}
	if total == 0 {
		// Nothing comparable. Not a match and not a conflict — there is simply
		// no evidence, and reporting 0 with outcome "distinct" would overstate
		// what was checked.
		result.Outcome = OutcomeDistinct
		return result
	}

	result.Score = math.Max(0, math.Min(1, weighted/total))

	// Strong identifiers are decisive; demographics are evidential. That
	// asymmetry cannot be expressed as a weight, however large, because a
	// weighted average always lets enough disagreeing fields out-vote one
	// agreeing field — so both directions are overrides rather than terms.
	var strongAgrees, strongDisagrees bool
	for _, f := range fields {
		if f.Field != Field("strong_identifier") {
			continue
		}
		if f.Similarity < 0 {
			strongDisagrees = true
		} else if f.Similarity > 0 {
			strongAgrees = true
		}
	}

	// Disagreement wins over agreement: holding one matching identifier and
	// one contradicting one is a data-quality incident, and the safe reading
	// of "these might be different people" is that they are.
	if strongDisagrees {
		result.Outcome = OutcomeConflict
		return result
	}

	if strongAgrees {
		// A shared national or government identifier is issued to one person.
		// Demographics that disagree are normal for the same person over time
		// — a married surname, a new phone, a birth date estimated on the
		// first visit and documented on the second — so they reduce certainty
		// without displacing the identifier.
		//
		// Floored rather than set to 1: this still routes to a human, and
		// showing perfect confidence for a record whose every other field
		// disagrees would misrepresent what was checked.
		result.Score = math.Max(result.Score, t.Probable)
		result.Fields = append(result.Fields, FieldScore{
			Field: Field("strong_identifier"), Similarity: 1, Weight: w.StrongIdentifier,
			Note: "a matching strong identifier sets the floor for this score",
		})
		fields = result.Fields
	}

	switch {
	case result.Score >= t.Probable:
		result.Outcome = OutcomeProbable
	case result.Score >= t.Review:
		result.Outcome = OutcomeReview
	default:
		result.Outcome = OutcomeDistinct
	}
	return result
}

// compareIdentifiers separates conclusive identifiers from historical ones.
//
// Returns similarity -1 for a strong identifier that disagrees, which is the
// negative-evidence path. Only identifiers from the same system are compared:
// an ABHA number and an insurance membership number differing says nothing.
func compareIdentifiers(proposed, candidate IdentifierSet) (strong, prior []FieldScore) {
	for _, p := range proposed {
		for _, c := range candidate {
			if p.Type != c.Type || !strings.EqualFold(p.System, c.System) {
				continue
			}
			// A revoked identifier is evidence of nothing: it was attached in
			// error, and matching on it would reproduce the original mistake.
			if !c.ResolvesToPatient() {
				continue
			}

			same := strings.EqualFold(strings.TrimSpace(p.Value), strings.TrimSpace(c.Value))
			isStrong := p.Type == IdentifierNationalHealth || p.Type == IdentifierGovernment

			switch {
			case isStrong && same:
				strong = append(strong, FieldScore{Similarity: 1, Note: string(p.Type) + " matches"})
			case isStrong && !same:
				strong = append(strong, FieldScore{Similarity: -1, Note: "different " + string(p.Type)})
			case same && c.Status == IdentifierSuperseded:
				// A superseded MRN matching is strong positive evidence: the
				// patient quoted an old card, which is what prior-identifier
				// scoring is for.
				prior = append(prior, FieldScore{Similarity: 1, Note: "prior " + string(p.Type) + " matches"})
			case same:
				prior = append(prior, FieldScore{Similarity: 1, Note: string(p.Type) + " matches"})
			}
		}
	}
	return strong, prior
}

// compareBirthDates weighs by the weaker of the two precisions.
//
// An estimated date is derived from "about forty", and treating it as a
// day-precision match would let a guess carry the weight of a document.
func compareBirthDates(a, b BirthDate) (similarity float64, note string, comparable bool) {
	if a.IsZero() || b.IsZero() {
		return 0, "", false
	}

	precision := weakerPrecision(a.Precision, b.Precision)
	switch precision {
	case PrecisionDay:
		if a.Date.Equal(b.Date) {
			return 1, "", true
		}
		// A transposition — 03/12 against 12/03 — is the single commonest
		// birth-date error, and it is worth noticing rather than scoring zero.
		if transposedDate(a.Date, b.Date) {
			return 0.7, "day and month appear transposed", true
		}
		return 0, "", true

	case PrecisionMonth:
		if a.Date.Year() == b.Date.Year() && a.Date.Month() == b.Date.Month() {
			return 1, "month precision", true
		}
		return 0, "month precision", true

	case PrecisionYear:
		if a.Date.Year() == b.Date.Year() {
			return 1, "year only", true
		}
		return 0, "year only", true

	default: // estimated on at least one side
		// Within two years is as much as an estimate can honestly support, and
		// it is capped well below a real match.
		gap := math.Abs(float64(a.Date.Year() - b.Date.Year()))
		if gap <= 2 {
			return 0.4, "estimated age", true
		}
		return 0, "estimated age", true
	}
}

var precisionRank = map[DatePrecision]int{
	PrecisionDay: 3, PrecisionMonth: 2, PrecisionYear: 1, PrecisionEstimated: 0,
}

func weakerPrecision(a, b DatePrecision) DatePrecision {
	if precisionRank[a] <= precisionRank[b] {
		return a
	}
	return b
}

func transposedDate(a, b time.Time) bool {
	return a.Year() == b.Year() &&
		int(a.Month()) == b.Day() && a.Day() == int(b.Month()) &&
		a.Day() != int(a.Month())
}

// compareContacts scores the best match across the two sets.
//
// Best rather than average: one shared mobile number is strong evidence, and
// averaging it against three numbers that do not match would dilute the one
// signal that meant something.
func compareContacts(a, b []ContactPoint) (float64, bool) {
	if len(a) == 0 || len(b) == 0 {
		return 0, false
	}
	for _, x := range a {
		for _, y := range b {
			if x.Value == y.Value {
				return 1, true
			}
			// Last ten digits: the same number written with and without a
			// country code is one number.
			if len(x.Value) >= 10 && len(y.Value) >= 10 &&
				x.Value[len(x.Value)-10:] == y.Value[len(y.Value)-10:] {
				return 1, true
			}
		}
	}
	return 0, true
}

func compareAddresses(a, b []Address) (float64, bool) {
	if len(a) == 0 || len(b) == 0 {
		return 0, false
	}
	best := 0.0
	for _, x := range a {
		for _, y := range b {
			best = math.Max(best, addressSimilarity(x, y))
		}
	}
	return best, true
}

func addressSimilarity(a, b Address) float64 {
	// The postal code carries most of the discriminating power and survives
	// transcription better than a street line does.
	score, weight := 0.0, 0.0
	if a.PostalCode != "" && b.PostalCode != "" {
		weight += 2
		if strings.EqualFold(a.PostalCode, b.PostalCode) {
			score += 2
		}
	}
	if a.City != "" && b.City != "" {
		weight++
		score += jaroWinkler(fold(a.City), fold(b.City))
	}
	if len(a.Lines) > 0 && len(b.Lines) > 0 {
		weight++
		score += jaroWinkler(fold(strings.Join(a.Lines, " ")), fold(strings.Join(b.Lines, " ")))
	}
	if weight == 0 {
		return 0
	}
	return score / weight
}

// swappedNameSimilarity detects a family/given transposition.
func swappedNameSimilarity(a, b HumanName) float64 {
	aFamily, aGiven := fold(a.Family), foldGiven(a.Given)
	bFamily, bGiven := fold(b.Family), foldGiven(b.Given)
	if aFamily == "" || aGiven == "" || bFamily == "" || bGiven == "" {
		return 0
	}

	straight := (jaroWinkler(aFamily, bFamily) + jaroWinkler(aGiven, bGiven)) / 2
	crossed := (jaroWinkler(aFamily, bGiven) + jaroWinkler(aGiven, bFamily)) / 2

	// Only report the swap when it is clearly the better reading. Reporting it
	// whenever it scores at all would add a second name signal to every
	// comparison and inflate scores across the board.
	if crossed > straight+0.2 {
		return crossed
	}
	return 0
}

func fold(s string) string {
	var b strings.Builder
	for _, r := range strings.ToLower(strings.TrimSpace(s)) {
		// Punctuation and spacing vary with whoever typed it: "D'Souza",
		// "DSouza" and "D Souza" are one name.
		if unicode.IsLetter(r) || unicode.IsDigit(r) {
			b.WriteRune(r)
		}
	}
	return b.String()
}

func foldGiven(given []string) string {
	parts := make([]string, 0, len(given))
	for _, g := range given {
		if f := fold(g); f != "" {
			parts = append(parts, f)
		}
	}
	sort.Strings(parts)
	return strings.Join(parts, "")
}

// jaroWinkler returns string similarity in 0..1.
//
// Chosen over edit distance because it favours agreement at the start of a
// string, which is where names are least often mistyped and most often
// truncated. It is the standard measure for record linkage for that reason.
func jaroWinkler(a, b string) float64 {
	if a == b {
		return 1
	}
	if a == "" || b == "" {
		return 0
	}

	ra, rb := []rune(a), []rune(b)
	matchWindow := max(len(ra), len(rb))/2 - 1
	if matchWindow < 0 {
		matchWindow = 0
	}

	matchedA := make([]bool, len(ra))
	matchedB := make([]bool, len(rb))
	matches := 0

	for i := range ra {
		start := max(0, i-matchWindow)
		end := min(len(rb), i+matchWindow+1)
		for j := start; j < end; j++ {
			if matchedB[j] || ra[i] != rb[j] {
				continue
			}
			matchedA[i], matchedB[j] = true, true
			matches++
			break
		}
	}
	if matches == 0 {
		return 0
	}

	transpositions, k := 0, 0
	for i := range ra {
		if !matchedA[i] {
			continue
		}
		for !matchedB[k] {
			k++
		}
		if ra[i] != rb[k] {
			transpositions++
		}
		k++
	}

	m := float64(matches)
	jaro := (m/float64(len(ra)) + m/float64(len(rb)) + (m-float64(transpositions)/2)/m) / 3

	// Winkler's prefix bonus, capped at four characters as in the original.
	prefix := 0
	for prefix < min(4, min(len(ra), len(rb))) && ra[prefix] == rb[prefix] {
		prefix++
	}
	return jaro + float64(prefix)*0.1*(1-jaro)
}
