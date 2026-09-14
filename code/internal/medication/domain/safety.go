package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Clinical decision support (SRS-MED-002, SRS-MED-003, SRS-MED-004).
//
// Three requirements, one shape, and the shape is the point. Each of the three
// says the clinician must be shown the *rule and its version*, and that is not
// a nicety: a hospital that cannot say which version of its interaction table
// was in force last March cannot answer the only question an investigation
// asks. So a finding with no rule version does not exist here — it is refused
// before it can be attached to a prescription, rather than stored with an empty
// column that a report would later render as a blank.
//
// The other shared property is that findings are evidence rather than verdicts.
// SRS-MED-003 says the clinician "may override only when policy permits" and
// SRS-MED-004 says "final prescribing authority remains clinician". Both are
// rules about who decides, and the way to hold them is to let the *tenant's*
// policy decide which severities may be overridden and to let dose support
// never block at all.

// FindingKind is which rule produced a finding.
type FindingKind string

const (
	// FindingAllergy is SRS-MED-002: the patient's recorded allergy or
	// intolerance matches this medication.
	FindingAllergy FindingKind = "allergy"
	// FindingInteraction is SRS-MED-003: this medication interacts with
	// something the patient is already on.
	FindingInteraction FindingKind = "interaction"
	// FindingDuplicateTherapy is SRS-MED-003's other half: the patient is
	// already on a medication doing the same job.
	FindingDuplicateTherapy FindingKind = "duplicate_therapy"
	// FindingDoseSupport is SRS-MED-004: renal, hepatic or paediatric dose
	// advice. Advisory by construction — see Blocking.
	FindingDoseSupport FindingKind = "dose_support"
)

var knownFindingKinds = map[FindingKind]bool{
	FindingAllergy: true, FindingInteraction: true,
	FindingDuplicateTherapy: true, FindingDoseSupport: true,
}

// Severity is how dangerous a finding is (SRS-MED-002's "severity-classified").
type Severity string

const (
	// SeverityContraindicated is never overridable, whatever policy says. A
	// tenant that could configure its way past a documented anaphylaxis to the
	// drug being prescribed has configured its way past the only control that
	// matters.
	SeverityContraindicated Severity = "contraindicated"
	SeveritySevere          Severity = "severe"
	SeverityModerate        Severity = "moderate"
	SeverityMild            Severity = "mild"
	// SeverityInformational is worth seeing and never worth stopping for.
	SeverityInformational Severity = "informational"
)

var severityRank = map[Severity]int{
	SeverityContraindicated: 0, SeveritySevere: 1, SeverityModerate: 2,
	SeverityMild: 3, SeverityInformational: 4,
}

// Known reports a severity this context understands.
func (s Severity) Known() bool { _, ok := severityRank[s]; return ok }

// AtLeast reports whether one severity is as serious as another.
func (s Severity) AtLeast(other Severity) bool {
	return severityRank[s] <= severityRank[other]
}

// SafetyFinding is one thing the rules noticed (SRS-MED-002/003/004).
type SafetyFinding struct {
	Kind     FindingKind
	Severity Severity
	// RuleID and RuleVersion are what the requirement calls "rule/version".
	// Both mandatory: a finding that cannot say which rule produced it is one
	// nobody can reproduce, defend or retire.
	RuleID      string
	RuleVersion string
	// Summary is the sentence a prescriber reads.
	Summary string
	// Subjects are the medications or allergens the finding is about — the
	// interacting drug, the allergen matched. SRS-MED-003's acceptance is that
	// "clinician sees interacting medications", and a warning that says a
	// conflict exists without naming it is one nobody can act on.
	Subjects []Coding
	// Inputs are the values the rule was evaluated against, for SRS-MED-004's
	// "inputs and rule/version are shown": a dose recommendation computed from
	// a creatinine clearance of 22 is a different claim from one computed from
	// 62, and the clinician who has to keep final authority needs to see which.
	Inputs map[string]string
	// Override is the clinician's answer, where one was given.
	Override *Override
}

// Validate rejects a finding that could not be shown or defended.
func (f SafetyFinding) Validate() error {
	switch {
	case !knownFindingKinds[f.Kind]:
		return invalidf("unknown safety finding kind %q", f.Kind)
	case !f.Severity.Known():
		return invalidf("unknown severity %q", f.Severity)
	case strings.TrimSpace(f.RuleID) == "":
		return invalidf("a safety finding must name the rule that produced it")
	case strings.TrimSpace(f.RuleVersion) == "":
		// The version, not just the rule. Rules are edited, and a finding that
		// names only the rule cannot say which edition of it fired.
		return invalidf("a safety finding must name the rule version")
	case strings.TrimSpace(f.Summary) == "":
		return invalidf("a safety finding must say what it found")
	}
	return nil
}

// Blocking reports a finding that stops a prescription until it is answered.
//
// Dose support never blocks, whatever its severity: SRS-MED-004 is explicit
// that it is advisory and that final prescribing authority remains with the
// clinician. Everything else blocks until overridden.
func (f SafetyFinding) Blocking() bool {
	if f.Kind == FindingDoseSupport {
		return false
	}
	if f.Severity == SeverityInformational {
		return false
	}
	return f.Override == nil
}

// Override is a clinician's decision to prescribe anyway (SRS-MED-003).
type Override struct {
	By     string
	At     time.Time
	Reason string
}

// SafetyRefusal is a prescription refused because findings stand unanswered.
//
// Structured, and carrying every finding at once, for the reason the order
// context's field errors give: a prescriber told about one warning, who answers
// it and is then told about another, stops reading them.
type SafetyRefusal struct {
	Findings []SafetyFinding
}

func (r SafetyRefusal) Error() string {
	summaries := make([]string, 0, len(r.Findings))
	for _, f := range r.Findings {
		summaries = append(summaries, f.Summary)
	}
	return "unanswered safety findings: " + strings.Join(summaries, "; ")
}

// Is lets errors.Is find the sentinel through a structured refusal.
func (r SafetyRefusal) Is(target error) bool { return target == ErrNotAllowed }

// ScreenResult is everything the rules said about one prescription.
type ScreenResult struct {
	Findings []SafetyFinding
	// ScreenedAt is when the rules ran. Stored because a screen is evidence
	// about a moment: the patient's allergy list and medication list both
	// change, and a screen with no time cannot be placed against either.
	ScreenedAt time.Time
}

// Blocking returns the findings still standing in the way.
func (r ScreenResult) Blocking() []SafetyFinding {
	var out []SafetyFinding
	for _, f := range r.Findings {
		if f.Blocking() {
			out = append(out, f)
		}
	}
	return out
}

// Worst reports the most serious severity found, and whether anything was.
func (r ScreenResult) Worst() (Severity, bool) {
	worst := Severity("")
	for _, f := range r.Findings {
		if worst == "" || f.Severity.AtLeast(worst) {
			worst = f.Severity
		}
	}
	return worst, worst != ""
}

// Answer records an override against a finding (SRS-MED-003).
//
// Matched by rule and subject rather than by index, because the screen is
// re-run between the warning being shown and the override coming back — the
// patient's medication list moves — and an override applied by position would
// answer whichever finding happened to be in that slot the second time.
func (r *ScreenResult) Answer(ruleID string, subject Coding, o Override,
	policy OverridePolicy) error {

	if strings.TrimSpace(o.By) == "" {
		return invalidf("an override needs the clinician making it")
	}
	if strings.TrimSpace(o.Reason) == "" {
		// An override with no reason is a click, and a click is not a clinical
		// decision anybody can review afterwards.
		return invalidf("an override needs a reason")
	}

	matched := false
	for i := range r.Findings {
		f := &r.Findings[i]
		if !strings.EqualFold(f.RuleID, ruleID) {
			continue
		}
		if !subject.Empty() && !hasSubject(f.Subjects, subject) {
			continue
		}
		if !policy.Overridable(f) {
			return notAllowedf(
				"a %s %s finding may not be overridden under this tenant's policy",
				f.Severity, f.Kind)
		}
		copied := o
		copied.At = o.At.UTC()
		f.Override = &copied
		matched = true
	}
	if !matched {
		return invalidf("no finding from rule %q to override", ruleID)
	}
	return nil
}

func hasSubject(subjects []Coding, want Coding) bool {
	for _, s := range subjects {
		if s.Key() == want.Key() {
			return true
		}
	}
	return false
}

// OverridePolicy is the tenant's answer to "who may prescribe anyway"
// (SRS-MED-003).
type OverridePolicy struct {
	// MaxOverridable is the most serious severity a clinician may override.
	// Findings more serious than this stand.
	MaxOverridable Severity
}

// DefaultOverridePolicy allows severe and below.
//
// Severe rather than moderate, because a policy that blocks every severe
// interaction blocks combinations that are given deliberately every day —
// warfarin with amiodarone, for one — and a control clinicians must route around
// daily is a control they route around silently. Contraindicated never yields.
func DefaultOverridePolicy() OverridePolicy {
	return OverridePolicy{MaxOverridable: SeveritySevere}
}

// Overridable reports whether policy lets a clinician answer this finding.
func (p OverridePolicy) Overridable(f *SafetyFinding) bool {
	if f.Kind == FindingDoseSupport {
		return true
	}
	if f.Severity == SeverityContraindicated {
		// Never, whatever the tenant configured. A prescription for a drug the
		// patient is documented as having had anaphylaxis to is not a decision
		// a configuration screen should be able to unlock.
		return false
	}
	ceiling := p.MaxOverridable
	if !ceiling.Known() {
		ceiling = SeveritySevere
	}
	// Overridable when the finding is no more serious than the ceiling. Rank
	// counts upward from contraindicated, so "no more serious" is a >=.
	return severityRank[f.Severity] >= severityRank[ceiling]
}

// Validate rejects an override policy that could not be applied.
func (p OverridePolicy) Validate() error {
	if !p.MaxOverridable.Known() {
		return invalidf("unknown override ceiling %q", p.MaxOverridable)
	}
	if p.MaxOverridable == SeverityContraindicated {
		return invalidf("a contraindication may never be made overridable")
	}
	return nil
}

// AllergyRecord is what this context needs about a recorded allergy.
//
// A projection of the clinical context's allergy list, not a copy of it: what
// matters here is the substance, how bad the reaction was and whether anybody
// has confirmed it. The reaction narrative stays in the chart.
type AllergyRecord struct {
	// Substance is what the patient reacts to. May be an ingredient or a class
	// — "penicillins" is the commonest recorded allergy and is a class.
	Substance Coding
	// Class is the broader group, where the clinical record captured one.
	Class Coding
	// Criticality is how dangerous a further exposure is expected to be.
	Criticality Severity
	// Confirmed distinguishes a documented reaction from something the patient
	// mentioned at the desk. Both warn; only one of them warns loudly.
	Confirmed bool
	// Intolerance marks a side effect rather than an immune reaction — nausea
	// from an opiate. Still worth showing, never worth blocking on.
	Intolerance bool
}

// MedicationProfile is the terminology mapping a screen needs (SRS-MED-002).
//
// The requirement says the evaluation happens "against medication terminology
// mapping", and the reason is that a prescription for co-amoxiclav must match a
// recorded allergy to penicillin. Matching on the prescribed code alone would
// miss it, which is the failure mode that kills people. The mapping is a seam
// rather than a table here: a deployment with a licensed drug database supplies
// a real one.
type MedicationProfile struct {
	// Ingredients are the active substances, which is what an allergy is to.
	Ingredients []Coding
	// Classes are the groups it belongs to — "penicillins", "NSAIDs".
	Classes []Coding
	// TherapeuticMoiety groups medications doing the same job, for
	// SRS-MED-003's duplicate therapy check.
	TherapeuticMoiety Coding
}

// AllergyRule is the identity of the allergy check, for the rule/version the
// requirement demands.
type AllergyRule struct {
	ID      string
	Version string
}

// ScreenAllergies matches a prescription against the patient's allergy list
// (SRS-MED-002).
//
// Matching is on ingredient and class, both directions, because the recorded
// allergy and the prescribed drug are named at different levels of the
// terminology more often than not: the chart says "penicillin" and the
// prescription says "co-amoxiclav".
func ScreenAllergies(allergies []AllergyRecord, prescribed MedicationProfile,
	rule AllergyRule) []SafetyFinding {

	ruleID, ruleVersion := rule.ID, rule.Version
	if strings.TrimSpace(ruleID) == "" {
		ruleID = "allergy.ingredient-and-class-match"
	}
	if strings.TrimSpace(ruleVersion) == "" {
		ruleVersion = "builtin-1"
	}

	prescribedKeys := map[string]Coding{}
	for _, c := range append(append([]Coding{}, prescribed.Ingredients...), prescribed.Classes...) {
		if !c.Empty() {
			prescribedKeys[c.Key()] = c
		}
	}

	var out []SafetyFinding
	for _, a := range allergies {
		var matched Coding
		var level string
		for _, candidate := range []struct {
			coding Coding
			level  string
		}{{a.Substance, "substance"}, {a.Class, "class"}} {
			if candidate.coding.Empty() {
				continue
			}
			if hit, ok := prescribedKeys[candidate.coding.Key()]; ok {
				matched, level = hit, candidate.level
				break
			}
		}
		if matched.Empty() {
			continue
		}

		severity := allergySeverity(a)
		summary := fmt.Sprintf("recorded %s to %s matches the prescribed %s",
			allergyNoun(a), displayOf(a.Substance, a.Class), matched.Display)
		if !a.Confirmed {
			summary += " (reported, not confirmed)"
		}

		out = append(out, SafetyFinding{
			Kind: FindingAllergy, Severity: severity,
			RuleID: ruleID, RuleVersion: ruleVersion,
			Summary:  summary,
			Subjects: []Coding{matched},
			Inputs: map[string]string{
				"match_level": level,
				"confirmed":   fmt.Sprintf("%t", a.Confirmed),
				"criticality": string(a.Criticality),
			},
		})
	}

	sort.SliceStable(out, func(i, j int) bool {
		return severityRank[out[i].Severity] < severityRank[out[j].Severity]
	})
	return out
}

func allergyNoun(a AllergyRecord) string {
	if a.Intolerance {
		return "intolerance"
	}
	return "allergy"
}

func displayOf(first, second Coding) string {
	if !first.Empty() {
		return first.Display
	}
	return second.Display
}

// allergySeverity decides how loudly an allergy match warns.
//
// An unconfirmed report is softened by one step rather than ignored: most
// allergy records in any hospital are what the patient said at the desk, and a
// system that treated them all as contraindications would be overridden into
// irrelevance by the end of the first week. An intolerance is never
// contraindicated — it is a side effect, and giving it anyway is sometimes the
// right call.
func allergySeverity(a AllergyRecord) Severity {
	base := a.Criticality
	if !base.Known() {
		base = SeveritySevere
	}
	if a.Intolerance && base == SeverityContraindicated {
		base = SeveritySevere
	}
	if !a.Confirmed {
		switch base {
		case SeverityContraindicated:
			base = SeveritySevere
		case SeveritySevere:
			base = SeverityModerate
		}
	}
	return base
}
