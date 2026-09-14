package domain

import (
	"fmt"
	"sort"
	"strings"
)

// Drug-drug interaction and duplicate therapy (SRS-MED-003), and dose support
// (SRS-MED-004).
//
// Both are rule sets a tenant configures, and both are versioned, because both
// requirements make the version part of what the clinician is shown. The rules
// are data rather than code for the same reason the duplicate-order rules are:
// a hospital's pharmacy committee edits them, and a release is not how a
// hospital changes its mind about amiodarone.

// InteractionRule is one configured drug-drug interaction (SRS-MED-003).
type InteractionRule struct {
	ID string
	// Version is what the clinician is shown alongside the warning, and what a
	// later review reads to know which edition fired. A rule edited in place
	// without a new version is a rule whose history is gone.
	Version string
	// Left and Right are the two sides. Either may name an ingredient or a
	// class: the clinically important interactions are mostly class-level.
	Left  Coding
	Right Coding
	// Severity is how bad the combination is.
	Severity Severity
	// Advice is what to do about it — "monitor INR", "separate by two hours".
	// A warning that names a problem and no action is one clinicians learn to
	// dismiss.
	Advice string
	// Management is the shorter phrase a list can show.
	Management string
}

// Validate rejects an interaction rule that could not be applied or shown.
func (r InteractionRule) Validate() error {
	switch {
	case strings.TrimSpace(r.ID) == "":
		return invalidf("an interaction rule needs an identifier")
	case strings.TrimSpace(r.Version) == "":
		return invalidf("an interaction rule needs a version")
	case !r.Severity.Known():
		return invalidf("unknown severity %q", r.Severity)
	case strings.TrimSpace(r.Advice) == "":
		return invalidf("an interaction rule must say what to do about it")
	}
	if err := r.Left.Validate(); err != nil {
		return err
	}
	return r.Right.Validate()
}

// Matches reports whether a rule fires between two medication profiles.
func (r InteractionRule) Matches(a, b MedicationProfile) bool {
	return (profileHas(a, r.Left) && profileHas(b, r.Right)) ||
		(profileHas(a, r.Right) && profileHas(b, r.Left))
}

func profileHas(p MedicationProfile, c Coding) bool {
	if c.Empty() {
		return false
	}
	key := c.Key()
	for _, candidate := range p.Ingredients {
		if candidate.Key() == key {
			return true
		}
	}
	for _, candidate := range p.Classes {
		if candidate.Key() == key {
			return true
		}
	}
	return false
}

// CurrentMedication is one thing the patient is already on, as the screen needs
// it.
type CurrentMedication struct {
	PrescriptionID string
	Medication     Coding
	Profile        MedicationProfile
}

// ScreenInteractions checks a prescription against what the patient is already
// on (SRS-MED-003).
//
// Every finding names the medication on the other side, because the
// requirement's acceptance is that the clinician "sees interacting
// medications": a warning that a conflict exists without saying with what
// leaves them to find it themselves, and on a patient taking fourteen drugs
// they will not.
func ScreenInteractions(prescribed MedicationProfile, current []CurrentMedication,
	rules []InteractionRule) []SafetyFinding {

	var out []SafetyFinding
	for _, rule := range rules {
		for _, existing := range current {
			if !rule.Matches(prescribed, existing.Profile) {
				continue
			}
			out = append(out, SafetyFinding{
				Kind: FindingInteraction, Severity: rule.Severity,
				RuleID: rule.ID, RuleVersion: rule.Version,
				Summary: fmt.Sprintf("interacts with %s: %s",
					existing.Medication.Display, rule.Advice),
				Subjects: []Coding{existing.Medication},
				Inputs: map[string]string{
					"existing_prescription": existing.PrescriptionID,
					"management":            rule.Management,
				},
			})
		}
	}
	sort.SliceStable(out, func(i, j int) bool {
		return severityRank[out[i].Severity] < severityRank[out[j].Severity]
	})
	return out
}

// DuplicateTherapyRule is the identity of the duplicate-therapy check.
type DuplicateTherapyRule struct {
	ID       string
	Version  string
	Severity Severity
}

// DefaultDuplicateTherapyRule warns at moderate.
//
// Moderate rather than severe because deliberate duplication is routine — two
// analgesics with different mechanisms, a regular and an as-needed form of the
// same drug — and a severe warning on something done hourly is a warning that
// trains people to click through.
func DefaultDuplicateTherapyRule() DuplicateTherapyRule {
	return DuplicateTherapyRule{
		ID: "duplicate-therapy.moiety", Version: "builtin-1",
		Severity: SeverityModerate,
	}
}

// ScreenDuplicateTherapy finds medications already doing this one's job
// (SRS-MED-003).
//
// Matched on therapeutic moiety rather than on the product code, because two
// brands of the same drug are the duplication that actually harms: prescribed
// separately under different names, they are given together and the patient
// gets twice the dose.
func ScreenDuplicateTherapy(prescribed MedicationProfile, current []CurrentMedication,
	rule DuplicateTherapyRule) []SafetyFinding {

	if prescribed.TherapeuticMoiety.Empty() {
		// Nothing to match on. Silent rather than guessing: a duplicate check
		// that fell back to the display name would fire on every brand pair
		// that shares a word.
		return nil
	}
	if strings.TrimSpace(rule.ID) == "" {
		rule = DefaultDuplicateTherapyRule()
	}

	key := prescribed.TherapeuticMoiety.Key()
	var out []SafetyFinding
	for _, existing := range current {
		if existing.Profile.TherapeuticMoiety.Empty() ||
			existing.Profile.TherapeuticMoiety.Key() != key {
			continue
		}
		out = append(out, SafetyFinding{
			Kind: FindingDuplicateTherapy, Severity: rule.Severity,
			RuleID: rule.ID, RuleVersion: rule.Version,
			Summary: fmt.Sprintf("the patient is already prescribed %s, which does the same job",
				existing.Medication.Display),
			Subjects: []Coding{existing.Medication},
			Inputs: map[string]string{
				"existing_prescription": existing.PrescriptionID,
				"moiety":                prescribed.TherapeuticMoiety.Display,
			},
		})
	}
	return out
}

// PatientFactors are the values dose-support rules are evaluated against
// (SRS-MED-004).
//
// Carried as a struct rather than looked up here because every one of them is
// another context's fact: the weight is an observation, the age is the EMPI's,
// the creatinine clearance is a laboratory result somebody computed. What this
// context does is apply the rule and say what it applied it to.
type PatientFactors struct {
	AgeYears float64
	// WeightKg is zero when nobody has weighed the patient, which is itself
	// worth saying: a paediatric dose computed from an assumed weight is the
	// error the requirement exists to catch.
	WeightKg float64
	// CreatinineClearance in mL/min, zero when unknown.
	CreatinineClearance float64
	// HepaticImpairment marks recorded liver impairment.
	HepaticImpairment bool
	// Known lists which factors were actually available, so a rule can decline
	// rather than assume.
	Known map[string]bool
}

// DoseRuleScope is which population a dose rule applies to.
type DoseRuleScope string

const (
	ScopeRenal      DoseRuleScope = "renal"
	ScopeHepatic    DoseRuleScope = "hepatic"
	ScopePaediatric DoseRuleScope = "paediatric"
)

var knownDoseScopes = map[DoseRuleScope]bool{
	ScopeRenal: true, ScopeHepatic: true, ScopePaediatric: true,
}

// DoseRule is one configured dose-support rule (SRS-MED-004).
//
// Advisory by construction: there is no severity that makes it block, because
// the requirement says final prescribing authority remains with the clinician.
// A renal dose rule that refused the prescription would be a rule that
// overrides a nephrologist who knows why.
type DoseRule struct {
	ID      string
	Version string
	Scope   DoseRuleScope
	// Medication is the ingredient or class this rule is about.
	Medication Coding
	// Applies bounds the population. For renal, an upper creatinine clearance;
	// for paediatric, an upper age; for hepatic, the impairment flag.
	MaxCreatinineClearance float64
	MaxAgeYears            float64
	// Advice is what to do — "reduce to 50% and extend the interval to 24
	// hourly".
	Advice string
	// Validated records that the tenant's pharmacy has reviewed this rule.
	// SRS-MED-004 says dose support applies "when configured and validated",
	// and an unvalidated rule is advice nobody has checked — so it does not run
	// at all rather than running with a caveat.
	Validated bool
}

// Validate rejects a dose rule that could not be applied or shown.
func (r DoseRule) Validate() error {
	switch {
	case strings.TrimSpace(r.ID) == "":
		return invalidf("a dose rule needs an identifier")
	case strings.TrimSpace(r.Version) == "":
		return invalidf("a dose rule needs a version")
	case !knownDoseScopes[r.Scope]:
		return invalidf("unknown dose rule scope %q", r.Scope)
	case strings.TrimSpace(r.Advice) == "":
		return invalidf("a dose rule must say what to do")
	}
	return r.Medication.Validate()
}

// ScreenDoseSupport applies the configured dose rules (SRS-MED-004).
//
// A rule whose inputs are missing does not fire. That is the opposite of the
// obvious behaviour and it is deliberate: a renal rule that treated an absent
// creatinine clearance as zero would warn on every patient who has not had
// bloods taken, and a paediatric rule that treated an absent weight as zero
// would recommend a dose of nothing. A rule that cannot see what it needs
// should say nothing rather than say something wrong.
func ScreenDoseSupport(prescribed MedicationProfile, factors PatientFactors,
	rules []DoseRule) []SafetyFinding {

	var out []SafetyFinding
	for _, rule := range rules {
		if !rule.Validated {
			continue
		}
		if !profileHas(prescribed, rule.Medication) {
			continue
		}

		inputs := map[string]string{"scope": string(rule.Scope)}
		fires := false

		switch rule.Scope {
		case ScopeRenal:
			if !factors.knows("creatinine_clearance") || factors.CreatinineClearance <= 0 {
				continue
			}
			inputs["creatinine_clearance_ml_min"] =
				fmt.Sprintf("%g", factors.CreatinineClearance)
			fires = rule.MaxCreatinineClearance > 0 &&
				factors.CreatinineClearance < rule.MaxCreatinineClearance
		case ScopePaediatric:
			if !factors.knows("age_years") {
				continue
			}
			inputs["age_years"] = fmt.Sprintf("%g", factors.AgeYears)
			if factors.knows("weight_kg") && factors.WeightKg > 0 {
				inputs["weight_kg"] = fmt.Sprintf("%g", factors.WeightKg)
			}
			fires = rule.MaxAgeYears > 0 && factors.AgeYears < rule.MaxAgeYears
		case ScopeHepatic:
			if !factors.knows("hepatic_impairment") {
				continue
			}
			inputs["hepatic_impairment"] = fmt.Sprintf("%t", factors.HepaticImpairment)
			fires = factors.HepaticImpairment
		}

		if !fires {
			continue
		}
		out = append(out, SafetyFinding{
			Kind: FindingDoseSupport, Severity: SeverityInformational,
			RuleID: rule.ID, RuleVersion: rule.Version,
			Summary:  rule.Advice,
			Subjects: []Coding{rule.Medication},
			Inputs:   inputs,
		})
	}
	return out
}

func (f PatientFactors) knows(name string) bool {
	if f.Known == nil {
		return false
	}
	return f.Known[name]
}
