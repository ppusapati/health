// Package domain holds the dietetics and kitchen operations rules
// (SRS-DIET-001 … 009).
//
// Nothing here reaches a database, a clock or a transport (FIT-01). Every
// refusal is a value a caller can act on rather than a panic.
//
// Two properties run through the whole package and are worth stating once.
//
// This context never writes a medication or an order. Parenteral nutrition is
// a prescription and enteral feed regimens are orders; both belong to the
// contexts that already carry the safety controls for them, and SRS-DIET-007
// says so in as many words. What lives here is the plan and the reference to
// the order that carries it out, and there is no field that could hold a dose
// and no port that could write one.
//
// And the order in force is re-read at dispatch, never trusted from the
// census. A patient made nil by mouth at six for a theatre list at nine was
// on a normal diet when the breakfast census was taken at five, and a kitchen
// that dispatches what the census said is a kitchen that sends that patient
// breakfast. Every other rule here is bookkeeping; this one is the reason the
// bookkeeping exists.
package domain

import (
	"errors"
	"fmt"
	"strings"
	"time"
)

// ErrInvalidDietetics reports a refused dietetics action.
var ErrInvalidDietetics = errors.New("dietetics: invalid")

// Anthropometry is what was measured (SRS-DIET-001).
//
// Integers in base units rather than floats: a weight recorded as 72.3 and
// read back as 72.30000000000001 is a weight that fails an equality check in
// a report nobody expected to be about floating point. Height is millimetres,
// weight is grams, circumference is millimetres.
type Anthropometry struct {
	HeightMM int
	WeightG  int
	// MidUpperArmMM is what is measurable when a patient cannot be weighed,
	// which in critical care is most of them.
	MidUpperArmMM int
	// Estimated marks a measurement somebody judged rather than took — a
	// weight from the family, a height from ulna length. Carried because a
	// requirement computed from an estimate is an estimate, and a chart that
	// cannot tell the two apart hides that.
	Estimated  bool
	MeasuredAt time.Time
}

// Measured reports anthropometry with enough in it to compute anything.
func (a Anthropometry) Measured() bool {
	return a.HeightMM > 0 && a.WeightG > 0
}

// BMITenths is body mass index in tenths, derived (SRS-DIET-001).
//
// Derived rather than stored. A stored BMI sitting beside a height and a
// weight that no longer agree with it is a third number nobody can explain,
// and the one a dietitian reads is whichever the screen happens to show.
//
// Zero when there is nothing to compute from, which a caller must distinguish
// from a BMI of zero — there is no such patient.
func (a Anthropometry) BMITenths() int {
	if !a.Measured() {
		return 0
	}
	// kg/m² in tenths: (g / 1000) / (mm / 1000)² × 10, rearranged to stay in
	// integers and keep the rounding in one place.
	metresSquaredMM := a.HeightMM * a.HeightMM
	return (a.WeightG * 10000) / metresSquaredMM
}

// Requirement is what the patient needs in a day (SRS-DIET-001).
type Requirement struct {
	EnergyKcal int
	ProteinG   int
	FluidML    int
	// Basis is how the numbers were arrived at — a predictive equation, an
	// indirect calorimetry study, kcal per kilogram. Recorded because a
	// requirement nobody can reproduce is a number, and the next dietitian
	// has to decide whether to believe it.
	Basis string
}

// AssessmentState is where an assessment stands (SRS-DIET-001).
type AssessmentState string

const (
	AssessmentDraft  AssessmentState = "draft"
	AssessmentSigned AssessmentState = "signed"
)

// NutritionAssessment is one dietitian's assessment of a patient
// (SRS-DIET-001).
type NutritionAssessment struct {
	ID       string
	TenantID string

	PatientID   string
	EncounterID string
	FacilityID  string

	Anthropometry Anthropometry
	// IntakeSummary is what the patient is actually managing, in the
	// dietitian's words. The one narrative field here, and it belongs to this
	// context because nobody else records it.
	IntakeSummary string
	// Diagnosis is the nutrition diagnosis — malnutrition, refeeding risk,
	// dysphagia. Coded by the deployment's own list rather than modelled,
	// because the standards differ and a hospital that uses one should not be
	// forced through another.
	DiagnosisCode string
	Diagnosis     string
	// AllergyRefs are the identifiers of the allergies this assessment was
	// made against, pinned. The allergy list belongs to the clinical context
	// and is read; what is kept here is which entries the dietitian saw, so a
	// later question about an assessment is answered against what was known
	// at the time.
	AllergyRefs []string
	Requirement Requirement

	// RiskScore and RiskTool are a screening result where the hospital uses
	// one — MUST, NRS-2002. The tool is named because a score of 3 means
	// different things in different tools.
	RiskTool  string
	RiskScore int

	State    AssessmentState
	SignedBy string
	SignedAt time.Time

	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// NewAssessmentInput records an assessment.
type NewAssessmentInput struct {
	PatientID     string
	EncounterID   string
	FacilityID    string
	Anthropometry Anthropometry
	IntakeSummary string
	DiagnosisCode string
	Diagnosis     string
	AllergyRefs   []string
	Requirement   Requirement
	RiskTool      string
	RiskScore     int
}

// NewAssessment starts a nutrition assessment (SRS-DIET-001).
func NewAssessment(id, tenantID string, in NewAssessmentInput, by string,
	now time.Time) (NutritionAssessment, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return NutritionAssessment{}, fmt.Errorf(
			"%w: an assessment needs an id", ErrInvalidDietetics)
	case strings.TrimSpace(in.PatientID) == "":
		return NutritionAssessment{}, fmt.Errorf(
			"%w: an assessment names its patient", ErrInvalidDietetics)
	case strings.TrimSpace(in.EncounterID) == "":
		// SRS-DIET-001's acceptance. An assessment floating free of an
		// encounter cannot be found by the team looking after the patient.
		return NutritionAssessment{}, fmt.Errorf(
			"%w: an assessment is linked to an encounter",
			ErrInvalidDietetics)
	case in.Anthropometry.HeightMM < 0 || in.Anthropometry.WeightG < 0 ||
		in.Anthropometry.MidUpperArmMM < 0:
		return NutritionAssessment{}, fmt.Errorf(
			"%w: a measurement cannot be negative", ErrInvalidDietetics)
	case in.Requirement.EnergyKcal < 0 || in.Requirement.ProteinG < 0 ||
		in.Requirement.FluidML < 0:
		return NutritionAssessment{}, fmt.Errorf(
			"%w: a requirement cannot be negative", ErrInvalidDietetics)
	case in.RiskScore != 0 && strings.TrimSpace(in.RiskTool) == "":
		// A score of 3 means malnourished in one tool and at risk in
		// another. A score with no tool is a number.
		return NutritionAssessment{}, fmt.Errorf(
			"%w: a risk score names the tool it came from",
			ErrInvalidDietetics)
	}

	if in.Requirement.EnergyKcal > 0 &&
		strings.TrimSpace(in.Requirement.Basis) == "" {
		// A requirement nobody can reproduce is a number, and the next
		// dietitian has to decide whether to believe it.
		return NutritionAssessment{}, fmt.Errorf(
			"%w: say how the requirement was calculated", ErrInvalidDietetics)
	}

	return NutritionAssessment{
		ID: id, TenantID: tenantID,
		PatientID: in.PatientID, EncounterID: in.EncounterID,
		FacilityID:    in.FacilityID,
		Anthropometry: normaliseAnthropometry(in.Anthropometry, now),
		IntakeSummary: strings.TrimSpace(in.IntakeSummary),
		DiagnosisCode: strings.TrimSpace(in.DiagnosisCode),
		Diagnosis:     strings.TrimSpace(in.Diagnosis),
		AllergyRefs:   normalise(in.AllergyRefs),
		Requirement: Requirement{
			EnergyKcal: in.Requirement.EnergyKcal,
			ProteinG:   in.Requirement.ProteinG,
			FluidML:    in.Requirement.FluidML,
			Basis:      strings.TrimSpace(in.Requirement.Basis),
		},
		RiskTool: strings.TrimSpace(in.RiskTool), RiskScore: in.RiskScore,
		State:     AssessmentDraft,
		CreatedAt: now.UTC(), CreatedBy: by, Version: 1,
	}, nil
}

func normaliseAnthropometry(a Anthropometry, now time.Time) Anthropometry {
	if a.MeasuredAt.IsZero() && a.Measured() {
		a.MeasuredAt = now.UTC()
	} else {
		a.MeasuredAt = utcOrZero(a.MeasuredAt)
	}
	return a
}

// Sign makes an assessment the record (SRS-DIET-001).
//
// A draft is editable and a signed assessment is not — there is no method
// here that changes one. A dietitian who has changed their mind writes
// another, which is how the two decisions stay distinguishable to whoever
// reads them next.
func (a *NutritionAssessment) Sign(by string, now time.Time) error {
	switch {
	case a.State == AssessmentSigned:
		return fmt.Errorf("%w: this assessment is already signed",
			ErrInvalidDietetics)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a signature names who made it",
			ErrInvalidDietetics)
	case !a.Anthropometry.Measured() && a.Anthropometry.MidUpperArmMM == 0:
		// Signed with nothing measured at all is an assessment of nobody.
		// Mid-upper arm alone is accepted, because in critical care it is
		// often the only thing there is.
		return fmt.Errorf(
			"%w: an assessment records at least one measurement",
			ErrInvalidDietetics)
	}

	a.State = AssessmentSigned
	a.SignedBy, a.SignedAt = by, now.UTC()
	return nil
}

func utcOrZero(t time.Time) time.Time {
	if t.IsZero() {
		return time.Time{}
	}
	return t.UTC()
}

// normalise trims, drops blanks and removes duplicates, preserving order.
func normalise(values []string) []string {
	seen := map[string]bool{}
	out := make([]string, 0, len(values))
	for _, value := range values {
		value = strings.TrimSpace(value)
		if value == "" || seen[value] {
			continue
		}
		seen[value] = true
		out = append(out, value)
	}
	return out
}
