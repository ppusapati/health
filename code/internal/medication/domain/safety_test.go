package domain_test

import (
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/medication/domain"
)

func penicillinClass() domain.Coding {
	return domain.Coding{System: "atc", Code: "J01C", Display: "Penicillins"}
}

func coAmoxiclavProfile() domain.MedicationProfile {
	return domain.MedicationProfile{
		Ingredients: []domain.Coding{
			{System: "rxnorm", Code: "19711", Display: "Amoxicillin/clavulanate"},
		},
		Classes:           []domain.Coding{penicillinClass()},
		TherapeuticMoiety: domain.Coding{System: "atc", Code: "J01CR02", Display: "Co-amoxiclav"},
	}
}

func allergyRule() domain.AllergyRule {
	return domain.AllergyRule{ID: "allergy.class", Version: "2026.03"}
}

// SRS-MED-002: the check matches through the terminology mapping, which is the
// only way a penicillin allergy catches a co-amoxiclav prescription.
func TestAPenicillinAllergyCatchesACoAmoxiclavPrescription(t *testing.T) {
	allergies := []domain.AllergyRecord{{
		Substance:   penicillinClass(),
		Criticality: domain.SeveritySevere,
		Confirmed:   true,
	}}

	findings := domain.ScreenAllergies(allergies, coAmoxiclavProfile(), allergyRule())
	if len(findings) != 1 {
		t.Fatalf("got %d findings, want the penicillin match", len(findings))
	}
	if findings[0].Kind != domain.FindingAllergy {
		t.Fatalf("kind = %q", findings[0].Kind)
	}
	if !strings.Contains(findings[0].Summary, "Penicillins") {
		t.Fatalf("summary does not name the allergen: %q", findings[0].Summary)
	}
}

// SRS-MED-002: every finding carries the rule and its version.
func TestEverySafetyFindingNamesTheRuleAndItsVersion(t *testing.T) {
	allergies := []domain.AllergyRecord{{
		Substance: penicillinClass(), Criticality: domain.SeveritySevere, Confirmed: true,
	}}
	findings := domain.ScreenAllergies(allergies, coAmoxiclavProfile(), allergyRule())
	if len(findings) == 0 {
		t.Fatal("no findings")
	}
	for _, f := range findings {
		if f.RuleID == "" || f.RuleVersion == "" {
			t.Fatalf("finding %q has rule %q version %q", f.Summary, f.RuleID, f.RuleVersion)
		}
		if err := f.Validate(); err != nil {
			t.Fatalf("Validate: %v", err)
		}
	}
}

func TestAFindingWithoutARuleVersionIsRefused(t *testing.T) {
	f := domain.SafetyFinding{
		Kind: domain.FindingAllergy, Severity: domain.SeveritySevere,
		RuleID: "allergy.class", Summary: "matched",
	}
	if err := f.Validate(); !errors.Is(err, domain.ErrInvalidPrescription) {
		t.Fatalf("a finding with no rule version was accepted: %v", err)
	}
}

// An unconfirmed allergy still warns, and warns less loudly.
func TestAnUnconfirmedAllergyWarnsOneStepLower(t *testing.T) {
	confirmed := domain.ScreenAllergies([]domain.AllergyRecord{{
		Substance: penicillinClass(), Criticality: domain.SeveritySevere, Confirmed: true,
	}}, coAmoxiclavProfile(), allergyRule())
	reported := domain.ScreenAllergies([]domain.AllergyRecord{{
		Substance: penicillinClass(), Criticality: domain.SeveritySevere, Confirmed: false,
	}}, coAmoxiclavProfile(), allergyRule())

	if len(confirmed) != 1 || len(reported) != 1 {
		t.Fatalf("confirmed %d, reported %d", len(confirmed), len(reported))
	}
	if confirmed[0].Severity != domain.SeveritySevere {
		t.Fatalf("confirmed severity = %q", confirmed[0].Severity)
	}
	if reported[0].Severity != domain.SeverityModerate {
		t.Fatalf("reported severity = %q, want one step lower", reported[0].Severity)
	}
	if !strings.Contains(reported[0].Summary, "not confirmed") {
		t.Fatalf("the summary does not say it is unconfirmed: %q", reported[0].Summary)
	}
}

// An intolerance is never a contraindication: it is a side effect, and giving
// it anyway is sometimes right.
func TestAnIntoleranceIsNeverAContraindication(t *testing.T) {
	findings := domain.ScreenAllergies([]domain.AllergyRecord{{
		Substance: penicillinClass(), Criticality: domain.SeverityContraindicated,
		Confirmed: true, Intolerance: true,
	}}, coAmoxiclavProfile(), allergyRule())

	if len(findings) != 1 {
		t.Fatalf("got %d findings", len(findings))
	}
	if findings[0].Severity == domain.SeverityContraindicated {
		t.Fatal("an intolerance was raised as a contraindication")
	}
}

// SRS-MED-003: a contraindication is never overridable, whatever the tenant
// configured.
func TestAContraindicationIsNeverOverridable(t *testing.T) {
	screen := domain.ScreenResult{Findings: []domain.SafetyFinding{{
		Kind: domain.FindingAllergy, Severity: domain.SeverityContraindicated,
		RuleID: "allergy.class", RuleVersion: "1", Summary: "anaphylaxis",
		Subjects: []domain.Coding{penicillinClass()},
	}}}

	policy := domain.OverridePolicy{MaxOverridable: domain.SeverityMild}
	err := screen.Answer("allergy.class", penicillinClass(), domain.Override{
		By: "dr-rao", Reason: "no alternative", At: time.Now(),
	}, policy)
	if !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("a contraindication was overridden: %v", err)
	}

	// And it still blocks.
	if len(screen.Blocking()) != 1 {
		t.Fatal("the contraindication stopped blocking")
	}
}

// The refusal is the contraindication itself, not the severity ceiling. A
// policy row written before Validate existed, or one edited straight in the
// database, still cannot unlock one — which is what makes this a property of
// the domain rather than of the configuration screen.
func TestAContraindicationStandsEvenAgainstAPolicyThatPermitsIt(t *testing.T) {
	screen := domain.ScreenResult{Findings: []domain.SafetyFinding{{
		Kind: domain.FindingAllergy, Severity: domain.SeverityContraindicated,
		RuleID: "allergy.class", RuleVersion: "1", Summary: "anaphylaxis",
		Subjects: []domain.Coding{penicillinClass()},
	}}}

	// Not reachable through Validate, which is the point: this is the stored
	// row nobody validated.
	permissive := domain.OverridePolicy{MaxOverridable: domain.SeverityContraindicated}

	err := screen.Answer("allergy.class", penicillinClass(), domain.Override{
		By: "dr-rao", Reason: "no alternative", At: time.Now(),
	}, permissive)
	if !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("a policy permitting contraindications overrode one: %v", err)
	}
	if len(screen.Blocking()) != 1 {
		t.Fatal("the contraindication stopped blocking")
	}
}

func TestAPolicyMayNotMakeContraindicationsOverridable(t *testing.T) {
	p := domain.OverridePolicy{MaxOverridable: domain.SeverityContraindicated}
	if err := p.Validate(); !errors.Is(err, domain.ErrInvalidPrescription) {
		t.Fatalf("a policy that unlocks contraindications was accepted: %v", err)
	}
}

// SRS-MED-003: the tenant's policy decides where the line falls.
func TestTheTenantsPolicyDecidesWhatMayBeOverridden(t *testing.T) {
	finding := domain.SafetyFinding{
		Kind: domain.FindingInteraction, Severity: domain.SeveritySevere,
		RuleID: "ddi.warfarin-amiodarone", RuleVersion: "2026.02",
		Summary: "raises INR", Subjects: []domain.Coding{amoxicillin()},
	}

	permissive := domain.ScreenResult{Findings: []domain.SafetyFinding{finding}}
	if err := permissive.Answer("ddi.warfarin-amiodarone", amoxicillin(), domain.Override{
		By: "dr-rao", Reason: "monitoring INR daily",
	}, domain.DefaultOverridePolicy()); err != nil {
		t.Fatalf("the default policy refused a severe override: %v", err)
	}

	strict := domain.ScreenResult{Findings: []domain.SafetyFinding{finding}}
	if err := strict.Answer("ddi.warfarin-amiodarone", amoxicillin(), domain.Override{
		By: "dr-rao", Reason: "monitoring INR daily",
	}, domain.OverridePolicy{MaxOverridable: domain.SeverityModerate}); !errors.Is(
		err, domain.ErrNotAllowed) {
		t.Fatalf("a strict policy allowed a severe override: %v", err)
	}
}

func TestAnOverrideNeedsAClinicianAndAReason(t *testing.T) {
	base := domain.SafetyFinding{
		Kind: domain.FindingInteraction, Severity: domain.SeverityModerate,
		RuleID: "ddi.x", RuleVersion: "1", Summary: "interacts",
	}
	for name, o := range map[string]domain.Override{
		"no clinician": {Reason: "because"},
		"no reason":    {By: "dr-rao"},
	} {
		t.Run(name, func(t *testing.T) {
			screen := domain.ScreenResult{Findings: []domain.SafetyFinding{base}}
			if err := screen.Answer("ddi.x", domain.Coding{}, o,
				domain.DefaultOverridePolicy()); !errors.Is(err, domain.ErrInvalidPrescription) {
				t.Fatalf("%s accepted: %v", name, err)
			}
		})
	}
}

// An override answers the finding it was given for, matched by rule and
// subject rather than by position.
func TestAnOverrideAnswersTheFindingItWasGivenFor(t *testing.T) {
	other := domain.Coding{System: "rxnorm", Code: "11289", Display: "Warfarin"}
	screen := domain.ScreenResult{Findings: []domain.SafetyFinding{
		{Kind: domain.FindingInteraction, Severity: domain.SeverityModerate,
			RuleID: "ddi.a", RuleVersion: "1", Summary: "a",
			Subjects: []domain.Coding{amoxicillin()}},
		{Kind: domain.FindingInteraction, Severity: domain.SeverityModerate,
			RuleID: "ddi.b", RuleVersion: "1", Summary: "b",
			Subjects: []domain.Coding{other}},
	}}

	if err := screen.Answer("ddi.a", amoxicillin(), domain.Override{
		By: "dr-rao", Reason: "accepted risk",
	}, domain.DefaultOverridePolicy()); err != nil {
		t.Fatalf("Answer: %v", err)
	}

	blocking := screen.Blocking()
	if len(blocking) != 1 || blocking[0].RuleID != "ddi.b" {
		t.Fatalf("blocking = %+v, want only ddi.b", blocking)
	}
}

// SRS-MED-003: the clinician sees which medication interacts.
func TestAnInteractionWarningNamesTheOtherMedication(t *testing.T) {
	warfarin := domain.Coding{System: "rxnorm", Code: "11289", Display: "Warfarin"}
	rules := []domain.InteractionRule{{
		ID: "ddi.warfarin-macrolide", Version: "2026.02",
		Left:     domain.Coding{System: "atc", Code: "B01AA03", Display: "Warfarin"},
		Right:    domain.Coding{System: "atc", Code: "J01FA", Display: "Macrolides"},
		Severity: domain.SeveritySevere,
		Advice:   "monitor INR closely",
	}}

	prescribed := domain.MedicationProfile{
		Ingredients: []domain.Coding{{System: "rxnorm", Code: "21212", Display: "Clarithromycin"}},
		Classes:     []domain.Coding{{System: "atc", Code: "J01FA", Display: "Macrolides"}},
	}
	current := []domain.CurrentMedication{{
		PrescriptionID: "rx-existing", Medication: warfarin,
		Profile: domain.MedicationProfile{
			Classes: []domain.Coding{{System: "atc", Code: "B01AA03", Display: "Warfarin"}},
		},
	}}

	findings := domain.ScreenInteractions(prescribed, current, rules)
	if len(findings) != 1 {
		t.Fatalf("got %d findings", len(findings))
	}
	if !strings.Contains(findings[0].Summary, "Warfarin") {
		t.Fatalf("the warning does not name the interacting drug: %q", findings[0].Summary)
	}
	if !strings.Contains(findings[0].Summary, "monitor INR") {
		t.Fatalf("the warning does not say what to do: %q", findings[0].Summary)
	}
	if findings[0].Inputs["existing_prescription"] != "rx-existing" {
		t.Fatalf("the finding does not point at the existing prescription")
	}
}

func TestAnInteractionRuleNeedsAVersionAndAdvice(t *testing.T) {
	base := domain.InteractionRule{
		ID: "ddi.x", Version: "1",
		Left:     domain.Coding{System: "atc", Code: "A", Display: "A"},
		Right:    domain.Coding{System: "atc", Code: "B", Display: "B"},
		Severity: domain.SeverityModerate, Advice: "avoid",
	}
	if err := base.Validate(); err != nil {
		t.Fatalf("a complete rule was refused: %v", err)
	}
	for name, break_ := range map[string]func(*domain.InteractionRule){
		"no version": func(r *domain.InteractionRule) { r.Version = "" },
		"no advice":  func(r *domain.InteractionRule) { r.Advice = "" },
	} {
		t.Run(name, func(t *testing.T) {
			r := base
			break_(&r)
			if err := r.Validate(); !errors.Is(err, domain.ErrInvalidPrescription) {
				t.Fatalf("%s accepted: %v", name, err)
			}
		})
	}
}

// SRS-MED-003: duplicate therapy is matched on what the drug does, not on its
// name.
func TestDuplicateTherapyMatchesOnTheMoietyNotTheBrand(t *testing.T) {
	moiety := domain.Coding{System: "atc", Code: "N02BE01", Display: "Paracetamol"}
	prescribed := domain.MedicationProfile{
		Ingredients:       []domain.Coding{{System: "rxnorm", Code: "1", Display: "Calpol"}},
		TherapeuticMoiety: moiety,
	}
	current := []domain.CurrentMedication{{
		PrescriptionID: "rx-existing",
		Medication:     domain.Coding{System: "rxnorm", Code: "2", Display: "Crocin"},
		Profile:        domain.MedicationProfile{TherapeuticMoiety: moiety},
	}}

	findings := domain.ScreenDuplicateTherapy(prescribed, current,
		domain.DefaultDuplicateTherapyRule())
	if len(findings) != 1 {
		t.Fatalf("two brands of the same drug did not register as a duplicate")
	}
	if !strings.Contains(findings[0].Summary, "Crocin") {
		t.Fatalf("the warning does not name the existing drug: %q", findings[0].Summary)
	}
}

func TestAMedicationWithNoMoietyIsNotGuessedAt(t *testing.T) {
	prescribed := domain.MedicationProfile{
		Ingredients: []domain.Coding{{System: "rxnorm", Code: "1", Display: "Calpol"}},
	}
	current := []domain.CurrentMedication{{
		PrescriptionID: "rx-existing",
		Medication:     domain.Coding{System: "rxnorm", Code: "2", Display: "Calpol Six Plus"},
		Profile:        domain.MedicationProfile{},
	}}

	if findings := domain.ScreenDuplicateTherapy(prescribed, current,
		domain.DefaultDuplicateTherapyRule()); len(findings) != 0 {
		t.Fatalf("a duplicate was guessed from the display name: %+v", findings)
	}
}

func renalRule() domain.DoseRule {
	return domain.DoseRule{
		ID: "dose.renal.amoxicillin", Version: "2026.01", Scope: domain.ScopeRenal,
		Medication:             amoxicillin(),
		MaxCreatinineClearance: 30,
		Advice:                 "reduce to 500 mg twice daily below CrCl 30",
		Validated:              true,
	}
}

// SRS-MED-004: dose support is advisory and never blocks.
func TestDoseSupportAdvisesAndNeverBlocks(t *testing.T) {
	profile := domain.MedicationProfile{Ingredients: []domain.Coding{amoxicillin()}}
	factors := domain.PatientFactors{
		CreatinineClearance: 22,
		Known:               map[string]bool{"creatinine_clearance": true},
	}

	findings := domain.ScreenDoseSupport(profile, factors, []domain.DoseRule{renalRule()})
	if len(findings) != 1 {
		t.Fatalf("got %d findings", len(findings))
	}
	if findings[0].Blocking() {
		t.Fatal("dose support blocked a prescription")
	}
	screen := domain.ScreenResult{Findings: findings}
	if len(screen.Blocking()) != 0 {
		t.Fatal("a dose-support finding appeared in the blocking set")
	}
}

// SRS-MED-004: the inputs the rule was evaluated against are shown.
func TestDoseSupportShowsWhatItWasComputedFrom(t *testing.T) {
	profile := domain.MedicationProfile{Ingredients: []domain.Coding{amoxicillin()}}
	factors := domain.PatientFactors{
		CreatinineClearance: 22,
		Known:               map[string]bool{"creatinine_clearance": true},
	}

	findings := domain.ScreenDoseSupport(profile, factors, []domain.DoseRule{renalRule()})
	if len(findings) != 1 {
		t.Fatalf("got %d findings", len(findings))
	}
	if got := findings[0].Inputs["creatinine_clearance_ml_min"]; got != "22" {
		t.Fatalf("inputs do not carry the clearance the rule used: %v", findings[0].Inputs)
	}
	if findings[0].RuleVersion != "2026.01" {
		t.Fatalf("rule version = %q", findings[0].RuleVersion)
	}
}

// A rule that cannot see what it needs says nothing rather than something
// wrong.
func TestADoseRuleWithoutItsInputsDoesNotFire(t *testing.T) {
	profile := domain.MedicationProfile{Ingredients: []domain.Coding{amoxicillin()}}

	if findings := domain.ScreenDoseSupport(profile, domain.PatientFactors{},
		[]domain.DoseRule{renalRule()}); len(findings) != 0 {
		t.Fatalf("a renal rule fired with no creatinine clearance: %+v", findings)
	}
}

// SRS-MED-004: "when configured and validated".
func TestAnUnvalidatedDoseRuleDoesNotRun(t *testing.T) {
	rule := renalRule()
	rule.Validated = false
	profile := domain.MedicationProfile{Ingredients: []domain.Coding{amoxicillin()}}
	factors := domain.PatientFactors{
		CreatinineClearance: 22,
		Known:               map[string]bool{"creatinine_clearance": true},
	}

	if findings := domain.ScreenDoseSupport(profile, factors,
		[]domain.DoseRule{rule}); len(findings) != 0 {
		t.Fatalf("an unvalidated rule produced advice: %+v", findings)
	}
}

// A prescription does not go live while a blocking finding stands.
func TestAPrescriptionWithAnUnansweredWarningCannotGoLive(t *testing.T) {
	in := simpleInput()
	p, err := domain.NewPrescription("rx1", "t1", in, at(2026, time.March, 2, 3, 0))
	if err != nil {
		t.Fatalf("NewPrescription: %v", err)
	}
	p.Screen = domain.ScreenResult{Findings: []domain.SafetyFinding{{
		Kind: domain.FindingAllergy, Severity: domain.SeveritySevere,
		RuleID: "allergy.class", RuleVersion: "1", Summary: "penicillin allergy",
		Subjects: []domain.Coding{penicillinClass()},
	}}}

	err = p.Prescribe(at(2026, time.March, 2, 3, 0))
	if !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("a prescription went live over an unanswered warning: %v", err)
	}
	var refusal domain.SafetyRefusal
	if !errors.As(err, &refusal) || len(refusal.Findings) != 1 {
		t.Fatalf("the refusal does not carry the findings: %v", err)
	}
}

// The refusal lists every finding at once.
func TestASafetyRefusalNamesEveryFindingAtOnce(t *testing.T) {
	in := simpleInput()
	p, _ := domain.NewPrescription("rx1", "t1", in, at(2026, time.March, 2, 3, 0))
	p.Screen = domain.ScreenResult{Findings: []domain.SafetyFinding{
		{Kind: domain.FindingAllergy, Severity: domain.SeveritySevere,
			RuleID: "allergy.class", RuleVersion: "1", Summary: "penicillin allergy"},
		{Kind: domain.FindingInteraction, Severity: domain.SeverityModerate,
			RuleID: "ddi.x", RuleVersion: "1", Summary: "interacts with warfarin"},
	}}

	var refusal domain.SafetyRefusal
	if err := p.Prescribe(at(2026, time.March, 2, 3, 0)); !errors.As(err, &refusal) {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(refusal.Findings) != 2 {
		t.Fatalf("the refusal carries %d of 2 findings", len(refusal.Findings))
	}
}

// Once overridden, the prescription proceeds and the override stays on it.
func TestAnOverriddenWarningLetsThePrescriptionProceedAndStaysOnTheRecord(t *testing.T) {
	in := simpleInput()
	p, _ := domain.NewPrescription("rx1", "t1", in, at(2026, time.March, 2, 3, 0))
	p.Screen = domain.ScreenResult{Findings: []domain.SafetyFinding{{
		Kind: domain.FindingAllergy, Severity: domain.SeveritySevere,
		RuleID: "allergy.class", RuleVersion: "1", Summary: "penicillin allergy",
		Subjects: []domain.Coding{penicillinClass()},
	}}}

	if err := p.Screen.Answer("allergy.class", penicillinClass(), domain.Override{
		By: "dr-rao", Reason: "mild rash only, benefit outweighs",
		At: at(2026, time.March, 2, 3, 0),
	}, domain.DefaultOverridePolicy()); err != nil {
		t.Fatalf("Answer: %v", err)
	}
	if err := p.Prescribe(at(2026, time.March, 2, 3, 0)); err != nil {
		t.Fatalf("Prescribe after override: %v", err)
	}
	if p.Screen.Findings[0].Override == nil ||
		p.Screen.Findings[0].Override.Reason == "" {
		t.Fatal("the override is not on the record")
	}
}
