package domain_test

import (
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/nursing/domain"
)

func admissionTemplate() domain.AssessmentTemplate {
	return domain.AssessmentTemplate{
		TemplateID: "adult-medical", TenantID: "tenant-1", Version: "3",
		Name:      "Adult medical admission",
		AppliesTo: domain.Applicability{MinAgeYears: 16, ServiceCode: "medicine"},
		Sections: []domain.TemplateSection{
			{Heading: "Mobility", Required: true, Prompts: []string{"Transfers"}},
			{Heading: "Skin", Required: true, Prompts: []string{"Intact?"}},
			{Heading: "Social", Prompts: []string{"Lives with"}},
		},
	}
}

func answers(pairs ...string) []domain.Answer {
	out := make([]domain.Answer, 0, len(pairs)/2)
	for i := 0; i+1 < len(pairs); i += 2 {
		out = append(out, domain.Answer{Heading: pairs[i], Value: pairs[i+1]})
	}
	return out
}

// SRS-NUR-001: the template version is stored, not resolved at read time.
func TestAnAssessmentRecordsTheTemplateVersionItWasAnsweredAgainst(t *testing.T) {
	assessment, err := domain.NewAssessment("assess-1", "tenant-1",
		domain.NewAssessmentInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			Kind: domain.AssessmentAdmission, Template: admissionTemplate(),
			Answers:    answers("Mobility", "Independent", "Skin", "Intact"),
			AssessedAt: at(9, 0),
		}, "nurse-1", at(9, 20))
	if err != nil {
		t.Fatalf("NewAssessment: %v", err)
	}
	if assessment.TemplateVersion != "3" {
		t.Fatalf("template version is %q, want 3", assessment.TemplateVersion)
	}
	if assessment.AssessedBy != "nurse-1" {
		t.Fatalf("author is %q", assessment.AssessedBy)
	}
	// SRS-NUR-001 asks for author, time and version. The bedside time, not the
	// typing time.
	if !assessment.AssessedAt.Equal(at(9, 0)) {
		t.Fatalf("assessed at %s, want 09:00", assessment.AssessedAt)
	}
	if !assessment.RecordedAt.Equal(at(9, 20)) {
		t.Fatalf("recorded at %s, want 09:20", assessment.RecordedAt)
	}
}

// A nurse told about one missing section, who answers it and is then told
// about another, stops reading the message.
func TestAnIncompleteAssessmentNamesEveryMissingSection(t *testing.T) {
	_, err := domain.NewAssessment("assess-1", "tenant-1",
		domain.NewAssessmentInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			Kind: domain.AssessmentAdmission, Template: admissionTemplate(),
			Answers:    answers("Social", "Lives alone"),
			AssessedAt: at(9, 0),
		}, "nurse-1", at(9, 20))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("an incomplete assessment was accepted: %v", err)
	}
	if !strings.Contains(err.Error(), "Mobility") ||
		!strings.Contains(err.Error(), "Skin") {
		t.Fatalf("the refusal does not list both missing sections: %v", err)
	}
}

// An optional section left blank is not a gap.
func TestAnOptionalSectionMayBeLeftBlank(t *testing.T) {
	if _, err := domain.NewAssessment("assess-1", "tenant-1",
		domain.NewAssessmentInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			Kind: domain.AssessmentAdmission, Template: admissionTemplate(),
			Answers:    answers("Mobility", "Independent", "Skin", "Intact"),
			AssessedAt: at(9, 0),
		}, "nurse-1", at(9, 20)); err != nil {
		t.Fatalf("a complete assessment was refused: %v", err)
	}
}

// A retired template may still be read; nothing new is answered against it.
func TestARetiredTemplateCannotBeAnsweredAgainst(t *testing.T) {
	template := admissionTemplate()
	template.RetiredAt = at(8, 0)

	_, err := domain.NewAssessment("assess-1", "tenant-1",
		domain.NewAssessmentInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			Kind: domain.AssessmentAdmission, Template: template,
			Answers:    answers("Mobility", "Independent", "Skin", "Intact"),
			AssessedAt: at(9, 0),
		}, "nurse-1", at(9, 20))
	if !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("a retired template was used: %v", err)
	}
}

// SRS-NUR-001: age and service-specific templates.
func TestATemplateAppliesToAnAgeBandAndAService(t *testing.T) {
	template := admissionTemplate()

	if !template.AppliesTo.Covers(47, "medicine") {
		t.Fatal("an adult medical patient is not covered by the adult medical template")
	}
	if template.AppliesTo.Covers(7, "medicine") {
		t.Fatal("a seven-year-old is covered by the adult template")
	}
	if template.AppliesTo.Covers(47, "obstetrics") {
		t.Fatal("an obstetric patient is covered by the medical template")
	}

	general := domain.Applicability{}
	if !general.Covers(7, "obstetrics") {
		t.Fatal("a template with no applicability does not cover everybody")
	}
}

func TestATemplateNeedsAVersionAndASectionToAnswer(t *testing.T) {
	noVersion := admissionTemplate()
	noVersion.Version = ""
	if err := noVersion.Validate(); !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("an unversioned template was accepted: %v", err)
	}

	noSections := admissionTemplate()
	noSections.Sections = nil
	if err := noSections.Validate(); !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a template with no sections was accepted: %v", err)
	}
}

func braden() domain.RiskScale {
	return domain.RiskScale{
		ScaleID: "braden", TenantID: "tenant-1", Version: "1988",
		Name: "Braden scale", Domain: domain.RiskPressureInjury,
		Inputs: []domain.RiskInput{
			{Key: "sensory", Label: "Sensory perception", Min: 1, Max: 4},
			{Key: "moisture", Label: "Moisture", Min: 1, Max: 4},
			{Key: "activity", Label: "Activity", Min: 1, Max: 4},
			{Key: "mobility", Label: "Mobility", Min: 1, Max: 4},
			{Key: "nutrition", Label: "Nutrition", Min: 1, Max: 4},
			{Key: "friction", Label: "Friction and shear", Min: 1, Max: 3},
		},
		Bands: []domain.RiskBand{
			{From: 6, To: 12, Label: "high", Escalate: true},
			{From: 13, To: 14, Label: "moderate", Escalate: true},
			{From: 15, To: 18, Label: "mild"},
			{From: 19, To: 23, Label: "low"},
		},
		ReassessAfter: 24 * time.Hour,
	}
}

func bradenInputs() map[string]int32 {
	return map[string]int32{
		"sensory": 2, "moisture": 2, "activity": 2,
		"mobility": 2, "nutrition": 3, "friction": 2,
	}
}

// SRS-NUR-005: the score's version and inputs are stored.
func TestARiskScoreStoresItsScaleVersionAndEveryInput(t *testing.T) {
	score, err := domain.Score("risk-1", "tenant-1", "patient-1", "encounter-1",
		braden(), bradenInputs(), at(9, 0), "nurse-1", at(9, 10))
	if err != nil {
		t.Fatalf("Score: %v", err)
	}
	if score.ScaleVersion != "1988" {
		t.Fatalf("scale version is %q", score.ScaleVersion)
	}
	if score.Total != 13 {
		t.Fatalf("total is %d, want 13", score.Total)
	}
	if score.Band != "moderate" || !score.Escalate {
		t.Fatalf("band is %q escalate=%v, want moderate/true", score.Band, score.Escalate)
	}
	// A total on its own cannot be checked or explained.
	if len(score.Inputs) != 6 || score.Inputs["nutrition"] != 3 {
		t.Fatalf("the inputs were not stored: %v", score.Inputs)
	}
}

// A missing factor scored as zero is a patient reported at lower risk than
// they were assessed at.
func TestAMissingRiskFactorIsRefusedRatherThanScoredZero(t *testing.T) {
	inputs := bradenInputs()
	delete(inputs, "nutrition")

	_, err := domain.Score("risk-1", "tenant-1", "patient-1", "encounter-1",
		braden(), inputs, at(9, 0), "nurse-1", at(9, 10))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a score with a missing factor was accepted: %v", err)
	}
}

// A mis-keyed 40 in a 1–4 field shows up as a patient at implausible risk.
func TestARiskFactorOutsideItsRangeIsRefused(t *testing.T) {
	inputs := bradenInputs()
	inputs["mobility"] = 40

	_, err := domain.Score("risk-1", "tenant-1", "patient-1", "encounter-1",
		braden(), inputs, at(9, 0), "nurse-1", at(9, 10))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("an out-of-range factor was accepted: %v", err)
	}
}

// SRS-NUR-005: due reassessment appears as work.
func TestARiskScoreExpiresAndBecomesDue(t *testing.T) {
	score, err := domain.Score("risk-1", "tenant-1", "patient-1", "encounter-1",
		braden(), bradenInputs(), at(9, 0), "nurse-1", at(9, 10))
	if err != nil {
		t.Fatalf("Score: %v", err)
	}
	if score.Overdue(at(9, 0).Add(12 * time.Hour)) {
		t.Fatal("a twelve-hour-old score is already overdue")
	}
	if !score.Overdue(at(9, 0).Add(25 * time.Hour)) {
		t.Fatal("a twenty-five-hour-old score is not due for reassessment")
	}
	// A superseded score is not somebody's outstanding work.
	score.SupersededByID = "risk-2"
	if score.Overdue(at(9, 0).Add(25 * time.Hour)) {
		t.Fatal("a superseded score still shows as due")
	}
}

// A scale with no version cannot be recomputed or compared.
func TestARiskScaleNeedsAVersion(t *testing.T) {
	scale := braden()
	scale.Version = ""
	if err := scale.Validate(); !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("an unversioned scale was accepted: %v", err)
	}
}

// A total no band covers means the scale is misconfigured, and reporting
// "no risk" would be the dangerous reading.
func TestATotalOutsideEveryBandIsRefusedRatherThanReportedAsNoRisk(t *testing.T) {
	scale := braden()
	scale.Bands = []domain.RiskBand{{From: 6, To: 12, Label: "high", Escalate: true}}

	_, err := domain.Score("risk-1", "tenant-1", "patient-1", "encounter-1",
		scale, bradenInputs(), at(9, 0), "nurse-1", at(9, 10))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a total outside every band was scored: %v", err)
	}
}

// A rescore under a new scale version never overwrites: the nurse acted on the
// old number.
func TestARescoreIsANewRecordRatherThanAnUpdate(t *testing.T) {
	first, err := domain.Score("risk-1", "tenant-1", "patient-1", "encounter-1",
		braden(), bradenInputs(), at(9, 0), "nurse-1", at(9, 10))
	if err != nil {
		t.Fatalf("Score: %v", err)
	}

	retuned := braden()
	retuned.Version = "2020"
	retuned.Bands = []domain.RiskBand{
		{From: 6, To: 14, Label: "high", Escalate: true},
		{From: 15, To: 23, Label: "low"},
	}
	second, err := domain.Score("risk-2", "tenant-1", "patient-1", "encounter-1",
		retuned, bradenInputs(), at(21, 0), "nurse-2", at(21, 5))
	if err != nil {
		t.Fatalf("Score: %v", err)
	}
	first.SupersededByID = second.ID

	if first.Band != "moderate" || first.ScaleVersion != "1988" {
		t.Fatalf("the retune rewrote the original score: %+v", first)
	}
	if second.Band != "high" || second.ScaleVersion != "2020" {
		t.Fatalf("the rescore did not use the new version: %+v", second)
	}
}
