package domain

import (
	"sort"
	"strings"
	"time"
)

// Admission assessment and risk scoring (SRS-NUR-001, SRS-NUR-005).
//
// Both requirements ask for the same thing in different words: store the
// version of the instrument as well as the answer. A Braden score of 14 means
// nothing without knowing it was a Braden; a paediatric assessment answered
// against an adult template is a different set of questions with the same
// heading. Neither can be reconstructed afterwards from the answers alone, so
// neither is inferred.

// AssessmentTemplate is a versioned set of questions (SRS-NUR-001).
type AssessmentTemplate struct {
	TemplateID string
	TenantID   string
	Version    string
	Name       string
	// AppliesTo narrows the template to an age band and a service, which is
	// what "age/service-specific" means. A template with no applicability is
	// the general one.
	AppliesTo Applicability
	Sections  []TemplateSection
	// RetiredAt stops a template being chosen for new assessments. It does not
	// invalidate the assessments already answered against it: they recorded
	// what was asked at the time, which is the point of versioning.
	RetiredAt time.Time
}

// Applicability is who a template is for.
type Applicability struct {
	// MinAgeYears and MaxAgeYears bound the band. A zero MaxAgeYears means no
	// upper bound.
	MinAgeYears int32
	MaxAgeYears int32
	// ServiceCode narrows to a specialty. Empty means any.
	ServiceCode string
}

// Covers reports whether this template applies to a patient of this age on
// this service.
func (a Applicability) Covers(ageYears int32, serviceCode string) bool {
	if ageYears < a.MinAgeYears {
		return false
	}
	if a.MaxAgeYears > 0 && ageYears > a.MaxAgeYears {
		return false
	}
	if a.ServiceCode != "" && !strings.EqualFold(a.ServiceCode, serviceCode) {
		return false
	}
	return true
}

// TemplateSection is one heading and the questions under it.
type TemplateSection struct {
	Heading  string
	Required bool
	Prompts  []string
}

// Validate rejects a template that could not be answered.
func (t AssessmentTemplate) Validate() error {
	switch {
	case strings.TrimSpace(t.TemplateID) == "":
		return invalidf("a template needs an identifier")
	case strings.TrimSpace(t.Version) == "":
		return invalidf("a template needs a version")
	case strings.TrimSpace(t.Name) == "":
		return invalidf("a template needs a name")
	case len(t.Sections) == 0:
		return invalidf("a template needs at least one section")
	}
	if t.AppliesTo.MaxAgeYears > 0 && t.AppliesTo.MaxAgeYears < t.AppliesTo.MinAgeYears {
		return invalidf("a template's age band must not end before it begins")
	}
	for _, s := range t.Sections {
		if strings.TrimSpace(s.Heading) == "" {
			return invalidf("every template section needs a heading")
		}
	}
	return nil
}

// Retired reports whether a template may still be chosen.
func (t AssessmentTemplate) Retired() bool { return !t.RetiredAt.IsZero() }

// Assessment is one completed nursing assessment (SRS-NUR-001).
type Assessment struct {
	ID          string
	TenantID    string
	PatientID   string
	EncounterID string
	Kind        AssessmentKind
	// TemplateID and TemplateVersion are the requirement's "template version
	// retained". The version is stored, not resolved at read time: a template
	// edited afterwards would otherwise silently restate what was asked.
	TemplateID      string
	TemplateVersion string

	Answers []Answer

	// AssessedAt is when the assessment was carried out at the bedside;
	// RecordedAt is when it reached the record. Separate for the reason
	// SRS-NUR-003 gives for observations.
	AssessedAt time.Time
	RecordedAt time.Time
	AssessedBy string
	Version    int64
}

// AssessmentKind separates the admission assessment from the reassessments
// that follow it.
type AssessmentKind string

const (
	// AssessmentAdmission is SRS-NUR-001's initial assessment.
	AssessmentAdmission AssessmentKind = "admission"
	// AssessmentShift is the routine reassessment.
	AssessmentShift AssessmentKind = "shift"
	// AssessmentFocused is a reassessment of one problem.
	AssessmentFocused AssessmentKind = "focused"
	// AssessmentDischarge feeds SRS-NUR-015's readiness.
	AssessmentDischarge AssessmentKind = "discharge"
)

var knownAssessmentKinds = map[AssessmentKind]bool{
	AssessmentAdmission: true, AssessmentShift: true,
	AssessmentFocused: true, AssessmentDischarge: true,
}

// Answer is one response.
type Answer struct {
	Heading string
	Prompt  string
	Value   string
	// Coded carries the answer where it is coded rather than free text.
	Coded Coding
}

// NewAssessmentInput is what recording an assessment needs.
type NewAssessmentInput struct {
	PatientID   string
	EncounterID string
	Kind        AssessmentKind
	Template    AssessmentTemplate
	Answers     []Answer
	AssessedAt  time.Time
}

// NewAssessment records a completed assessment against a template.
func NewAssessment(id, tenantID string, in NewAssessmentInput,
	assessedBy string, now time.Time) (*Assessment, error) {

	if strings.TrimSpace(in.PatientID) == "" {
		return nil, invalidf("an assessment needs a patient")
	}
	if strings.TrimSpace(in.EncounterID) == "" {
		return nil, invalidf("an assessment needs an encounter")
	}
	if !knownAssessmentKinds[in.Kind] {
		return nil, invalidf("unknown assessment kind %q", in.Kind)
	}
	if strings.TrimSpace(assessedBy) == "" {
		return nil, invalidf("an assessment must record who carried it out")
	}
	if err := in.Template.Validate(); err != nil {
		return nil, err
	}
	if in.Template.Retired() {
		// A retired template can still be read — the assessments answered
		// against it are still valid — but nothing new is answered against a
		// set of questions the tenant has withdrawn.
		return nil, notAllowedf("template %s version %s has been retired",
			in.Template.TemplateID, in.Template.Version)
	}
	if in.AssessedAt.IsZero() {
		return nil, invalidf("an assessment needs the time it was carried out")
	}
	assessed := in.AssessedAt.UTC()
	if assessed.After(now.UTC()) {
		return nil, invalidf("an assessment cannot have been carried out in the future")
	}

	// Every required section must have been answered. Checked against the
	// template that was chosen, so adding a required section later does not
	// retrospectively invalidate what has already been filed.
	answered := map[string]bool{}
	for _, a := range in.Answers {
		if strings.TrimSpace(a.Value) != "" || !a.Coded.Empty() {
			answered[strings.ToLower(strings.TrimSpace(a.Heading))] = true
		}
	}
	var missing []string
	for _, s := range in.Template.Sections {
		if s.Required && !answered[strings.ToLower(strings.TrimSpace(s.Heading))] {
			missing = append(missing, s.Heading)
		}
	}
	if len(missing) > 0 {
		// All of them, not the first: a nurse told about one, who answers it
		// and is then told about another, stops reading the message.
		sort.Strings(missing)
		return nil, invalidf("these sections must be answered: %s",
			strings.Join(missing, ", "))
	}

	return &Assessment{
		ID: id, TenantID: tenantID,
		PatientID: in.PatientID, EncounterID: in.EncounterID,
		Kind:            in.Kind,
		TemplateID:      in.Template.TemplateID,
		TemplateVersion: in.Template.Version,
		Answers:         append([]Answer(nil), in.Answers...),
		AssessedAt:      assessed, RecordedAt: now.UTC(),
		AssessedBy: assessedBy, Version: 1,
	}, nil
}

// RiskScale is a named, versioned scoring instrument (SRS-NUR-005).
type RiskScale struct {
	ScaleID  string
	TenantID string
	Version  string
	Name     string
	// Domain is what it scores: falls, pressure injury, pain.
	Domain RiskDomain
	// Inputs are the factors the scale takes, in order. Stored so the
	// assessment can be shown as it was answered rather than as today's
	// version of the scale would show it.
	Inputs []RiskInput
	// Bands map a total onto a risk category. Ordered low threshold first.
	Bands []RiskBand
	// ReassessAfter is how long a score stays current. A Braden from four days
	// ago is not an assessment of today's patient.
	ReassessAfter time.Duration
	RetiredAt     time.Time
}

// RiskDomain is what a scale measures.
type RiskDomain string

const (
	RiskFalls          RiskDomain = "falls"
	RiskPressureInjury RiskDomain = "pressure_injury"
	RiskPain           RiskDomain = "pain"
	RiskNutrition      RiskDomain = "nutrition"
	RiskDeterioration  RiskDomain = "deterioration"
)

// RiskInput is one factor a scale takes.
type RiskInput struct {
	Key   string
	Label string
	// Min and Max bound what the factor may score, so a mis-keyed 40 in a
	// 1–4 field is caught where it happens rather than showing up as a
	// patient at implausible risk.
	Min, Max int32
}

// RiskBand maps a total onto a category.
type RiskBand struct {
	// From is inclusive, To inclusive. Bands are checked in order.
	From, To int32
	Label    string
	// Escalate marks the band that requires action rather than observation.
	Escalate bool
}

// Validate rejects a scale that could not be scored.
func (s RiskScale) Validate() error {
	switch {
	case strings.TrimSpace(s.ScaleID) == "":
		return invalidf("a risk scale needs an identifier")
	case strings.TrimSpace(s.Version) == "":
		// SRS-NUR-005 and SRS-CLN-020 both turn on this: a score with no
		// instrument version cannot be recomputed or compared.
		return invalidf("a risk scale needs a version")
	case strings.TrimSpace(s.Name) == "":
		return invalidf("a risk scale needs a name")
	case len(s.Inputs) == 0:
		return invalidf("a risk scale needs at least one input")
	case len(s.Bands) == 0:
		return invalidf("a risk scale needs at least one band")
	case s.ReassessAfter <= 0:
		return invalidf("a risk scale must say how long a score stays current")
	}
	seen := map[string]bool{}
	for _, in := range s.Inputs {
		key := strings.TrimSpace(in.Key)
		if key == "" {
			return invalidf("every risk input needs a key")
		}
		if seen[key] {
			return invalidf("risk input %q appears twice", key)
		}
		seen[key] = true
		if in.Max < in.Min {
			return invalidf("risk input %q has a range that ends before it begins", key)
		}
	}
	return nil
}

// Retired reports whether a scale may still be used for a new score.
func (s RiskScale) Retired() bool { return !s.RetiredAt.IsZero() }

// Band returns the category a total falls into.
func (s RiskScale) Band(total int32) (RiskBand, bool) {
	for _, b := range s.Bands {
		if total >= b.From && total <= b.To {
			return b, true
		}
	}
	return RiskBand{}, false
}

// RiskAssessment is one scored assessment (SRS-NUR-005).
//
// The inputs are stored alongside the total, which is the requirement's "score
// version and inputs stored". A total on its own cannot be checked, cannot be
// explained to the patient, and cannot be recomputed when somebody asks
// whether the scale was applied correctly.
type RiskAssessment struct {
	ID          string
	TenantID    string
	PatientID   string
	EncounterID string

	ScaleID      string
	ScaleVersion string
	Domain       RiskDomain
	// Inputs as answered, keyed by the scale's input keys.
	Inputs map[string]int32
	Total  int32
	Band   string
	// Escalate is the band's flag captured at the time. Stored rather than
	// recomputed, because the bands can be retuned and a retuned scale must not
	// rewrite what the nurse was told.
	Escalate bool

	AssessedAt time.Time
	RecordedAt time.Time
	AssessedBy string
	// DueAt is when the score stops being current (SRS-NUR-005's "due
	// reassessment appears as task").
	DueAt time.Time

	// SupersededByID is set when a rescore replaces this one. A recalculation
	// under a new scale version never overwrites: the nurse acted on the old
	// number.
	SupersededByID string
	Version        int64
}

// Score computes and records a risk assessment.
func Score(id, tenantID, patientID, encounterID string, scale RiskScale,
	inputs map[string]int32, assessedAt time.Time, assessedBy string,
	now time.Time) (*RiskAssessment, error) {

	if strings.TrimSpace(patientID) == "" {
		return nil, invalidf("a risk score needs a patient")
	}
	if strings.TrimSpace(encounterID) == "" {
		return nil, invalidf("a risk score needs an encounter")
	}
	if strings.TrimSpace(assessedBy) == "" {
		return nil, invalidf("a risk score must record who assessed")
	}
	if err := scale.Validate(); err != nil {
		return nil, err
	}
	if scale.Retired() {
		return nil, notAllowedf("risk scale %s version %s has been retired",
			scale.ScaleID, scale.Version)
	}
	if assessedAt.IsZero() {
		return nil, invalidf("a risk score needs the time it was assessed")
	}
	assessed := assessedAt.UTC()
	if assessed.After(now.UTC()) {
		return nil, invalidf("a risk score cannot have been assessed in the future")
	}

	stored := make(map[string]int32, len(scale.Inputs))
	var total int32
	for _, in := range scale.Inputs {
		value, ok := inputs[in.Key]
		if !ok {
			// A missing factor scored as zero is a patient reported at lower
			// risk than they were assessed at. Refused instead.
			return nil, invalidf("risk input %q was not answered", in.Key)
		}
		if value < in.Min || value > in.Max {
			return nil, invalidf("risk input %q must be between %d and %d",
				in.Key, in.Min, in.Max)
		}
		stored[in.Key] = value
		total += value
	}

	band, ok := scale.Band(total)
	if !ok {
		// A total no band covers means the scale is misconfigured, and
		// reporting "no risk" would be the dangerous reading.
		return nil, invalidf("a total of %d falls outside every band of scale %s",
			total, scale.ScaleID)
	}

	return &RiskAssessment{
		ID: id, TenantID: tenantID,
		PatientID: patientID, EncounterID: encounterID,
		ScaleID: scale.ScaleID, ScaleVersion: scale.Version,
		Domain: scale.Domain, Inputs: stored, Total: total,
		Band: band.Label, Escalate: band.Escalate,
		AssessedAt: assessed, RecordedAt: now.UTC(), AssessedBy: assessedBy,
		DueAt:   assessed.Add(scale.ReassessAfter),
		Version: 1,
	}, nil
}

// Overdue reports whether a reassessment is due (SRS-NUR-005).
func (r *RiskAssessment) Overdue(now time.Time) bool {
	return r.SupersededByID == "" && !now.UTC().Before(r.DueAt)
}
