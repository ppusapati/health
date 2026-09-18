// Package domain holds the anaesthesia and recovery rules (SRS-ANE-001 … 011).
//
// No infrastructure: the rules here are the ones an anaesthetist would
// recognise as theirs, and they are testable without a database (FIT-01).
package domain

import (
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"
)

// ErrInvalidRecord refuses an anaesthetic record that could not be true.
var ErrInvalidRecord = errors.New("anaesthesia: invalid")

// ASA is the American Society of Anesthesiologists physical status
// (SRS-ANE-001).
//
// Its own type rather than an integer, because the emergency modifier is part
// of the grade and a system that stored 3 and a boolean would produce reports
// where "ASA 3" and "ASA 3E" were the same patient.
type ASA string

const (
	ASAUnspecified ASA = ""
	ASA1           ASA = "1"
	ASA2           ASA = "2"
	ASA3           ASA = "3"
	ASA4           ASA = "4"
	ASA5           ASA = "5"
	ASA6           ASA = "6"
	// The E suffix marks an emergency, which changes the risk the grade
	// describes.
	ASA1E ASA = "1E"
	ASA2E ASA = "2E"
	ASA3E ASA = "3E"
	ASA4E ASA = "4E"
	ASA5E ASA = "5E"
)

var knownASA = map[ASA]bool{
	ASA1: true, ASA2: true, ASA3: true, ASA4: true, ASA5: true, ASA6: true,
	ASA1E: true, ASA2E: true, ASA3E: true, ASA4E: true, ASA5E: true,
}

// Emergency reports whether the grade carries the emergency modifier.
func (a ASA) Emergency() bool { return strings.HasSuffix(string(a), "E") }

// AirwayGrade is a laryngoscopy view or a predicted difficulty score.
type AirwayGrade string

// AirwayAssessment is the predicted airway (SRS-ANE-001).
type AirwayAssessment struct {
	// Mallampati is the bedside prediction. Free text against the
	// deployment's own scale, because units differ on whether they record I–IV
	// or 1–4.
	Mallampati string
	// MouthOpeningMM and ThyromentalMM are the measurements a difficult airway
	// prediction is built from.
	MouthOpeningMM int
	ThyromentalMM  int
	// NeckMovement, Dentition and Notes are described rather than scored.
	NeckMovement string
	Dentition    string
	Notes        string
	// PredictedDifficult is the anaesthetist's judgement, which is not the
	// same as the sum of the measurements and is what the theatre reads.
	PredictedDifficult bool
}

// ConsentStatus is where anaesthetic consent has got to (SRS-ANE-001).
type ConsentStatus string

const (
	ConsentUnspecified ConsentStatus = ""
	ConsentObtained    ConsentStatus = "obtained"
	// ConsentPending is the ordinary state of a pre-assessment done in clinic
	// a fortnight before the operation.
	ConsentPending ConsentStatus = "pending"
	ConsentRefused ConsentStatus = "refused"
	// ConsentNotRequired covers an unconscious emergency, where treatment
	// proceeds in the patient's best interests.
	ConsentNotRequired ConsentStatus = "not_required"
)

var knownConsent = map[ConsentStatus]bool{
	ConsentObtained: true, ConsentPending: true,
	ConsentRefused: true, ConsentNotRequired: true,
}

// Assessment is a pre-anaesthesia assessment (SRS-ANE-001).
//
// Versioned rather than edited. A patient assessed in clinic and reassessed on
// the morning of surgery has two assessments, and the one the theatre acts on
// is the later — but the earlier is what the clinic decided, and overwriting
// it would lose the change that matters.
type Assessment struct {
	ID       string
	TenantID string

	// CaseID links to the theatre case. The requirement's clause is
	// "assessment is linked to planned procedure", and an assessment floating
	// free of one is an opinion about a patient rather than about an
	// operation.
	CaseID      string
	EncounterID string
	PatientID   string

	Version    int
	Supersedes string

	History        string
	Airway         AirwayAssessment
	ASAGrade       ASA
	Investigations []string
	// Risks are the specific ones discussed, as a list rather than prose,
	// because they are what the consent conversation is checked against.
	Risks []string
	// Plan is the anaesthetic technique intended. The detail lives in the
	// Plan type below; this is the one-line summary the theatre list shows.
	Plan string

	Consent ConsentStatus
	// ConsentNote explains a refusal or a not-required, and is what a review
	// reads.
	ConsentNote string

	// FitToProceed is the assessment's conclusion. Separate from the ASA
	// grade, because an ASA 4 patient can be fit for the operation they need
	// and an ASA 2 patient can be unfit today.
	FitToProceed bool
	// Conditions are what must happen before the operation — "needs echo",
	// "optimise potassium". Non-empty with FitToProceed true means fit
	// subject to these, which is the commonest real answer.
	Conditions []string

	AssessedBy string
	AssessedAt time.Time
	// Superseded marks an assessment replaced by a later one.
	SupersededBy string
	SupersededAt time.Time
}

// NewAssessmentInput is a pre-anaesthesia assessment.
type NewAssessmentInput struct {
	CaseID         string
	EncounterID    string
	PatientID      string
	History        string
	Airway         AirwayAssessment
	ASAGrade       ASA
	Investigations []string
	Risks          []string
	Plan           string
	Consent        ConsentStatus
	ConsentNote    string
	FitToProceed   bool
	Conditions     []string
}

// NewAssessment records a pre-anaesthesia assessment (SRS-ANE-001).
func NewAssessment(id, tenantID string, in NewAssessmentInput, by string,
	now time.Time) (Assessment, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Assessment{}, fmt.Errorf("%w: an assessment needs an id", ErrInvalidRecord)
	case strings.TrimSpace(in.CaseID) == "":
		// An assessment floating free of an operation is an opinion about a
		// patient rather than about a procedure.
		return Assessment{}, fmt.Errorf(
			"%w: an assessment is linked to the planned procedure", ErrInvalidRecord)
	case strings.TrimSpace(in.PatientID) == "":
		return Assessment{}, fmt.Errorf("%w: an assessment names a patient",
			ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return Assessment{}, fmt.Errorf("%w: an assessment names who made it",
			ErrInvalidRecord)
	case in.ASAGrade == ASAUnspecified:
		// The grade is the one number everybody downstream reads first.
		return Assessment{}, fmt.Errorf("%w: an assessment records an ASA grade",
			ErrInvalidRecord)
	case !knownASA[in.ASAGrade]:
		return Assessment{}, fmt.Errorf("%w: %q is not an ASA grade",
			ErrInvalidRecord, in.ASAGrade)
	}

	consent := in.Consent
	if consent == ConsentUnspecified {
		consent = ConsentPending
	}
	if !knownConsent[consent] {
		return Assessment{}, fmt.Errorf("%w: unknown consent status %q",
			ErrInvalidRecord, consent)
	}
	if (consent == ConsentRefused || consent == ConsentNotRequired) &&
		strings.TrimSpace(in.ConsentNote) == "" {
		// Both are states a review asks about, and neither explains itself.
		return Assessment{}, fmt.Errorf(
			"%w: say why consent was %s", ErrInvalidRecord, consent)
	}
	if !in.FitToProceed && len(trimmedAll(in.Conditions)) == 0 {
		// "Not fit" with nothing to do about it is a conclusion the theatre
		// cannot act on: either the operation is cancelled, which is the
		// theatre's call, or something has to change first.
		return Assessment{}, fmt.Errorf(
			"%w: say what has to happen before this patient is fit", ErrInvalidRecord)
	}

	return Assessment{
		ID: id, TenantID: tenantID,
		CaseID:         strings.TrimSpace(in.CaseID),
		EncounterID:    strings.TrimSpace(in.EncounterID),
		PatientID:      strings.TrimSpace(in.PatientID),
		Version:        1,
		History:        strings.TrimSpace(in.History),
		Airway:         in.Airway,
		ASAGrade:       in.ASAGrade,
		Investigations: trimmedAll(in.Investigations),
		Risks:          trimmedAll(in.Risks),
		Plan:           strings.TrimSpace(in.Plan),
		Consent:        consent,
		ConsentNote:    strings.TrimSpace(in.ConsentNote),
		FitToProceed:   in.FitToProceed,
		Conditions:     trimmedAll(in.Conditions),
		AssessedBy:     strings.TrimSpace(by),
		AssessedAt:     now.UTC(),
	}, nil
}

func trimmedAll(in []string) []string {
	out := make([]string, 0, len(in))
	for _, value := range in {
		if trimmed := strings.TrimSpace(value); trimmed != "" {
			out = append(out, trimmed)
		}
	}
	return out
}

// Reassess produces a later version (SRS-ANE-001).
//
// The earlier assessment is not changed. A patient assessed in clinic and
// reassessed on the morning of surgery has two records, and the difference
// between them is frequently the point — a chest infection that appeared in
// the fortnight between.
func (a Assessment) Reassess(id string, in NewAssessmentInput, by string,
	now time.Time) (Assessment, error) {

	if a.SupersededBy != "" {
		return Assessment{}, fmt.Errorf(
			"%w: this assessment has already been superseded", ErrInvalidRecord)
	}
	in.CaseID, in.EncounterID, in.PatientID = a.CaseID, a.EncounterID, a.PatientID

	next, err := NewAssessment(id, a.TenantID, in, by, now)
	if err != nil {
		return Assessment{}, err
	}
	next.Version, next.Supersedes = a.Version+1, a.ID
	return next, nil
}

// Current reports whether this is the assessment in force.
func (a Assessment) Current() bool { return a.SupersededBy == "" }

// CurrentAssessment returns the assessment in force, if any.
func CurrentAssessment(all []Assessment) (Assessment, bool) {
	var best Assessment
	found := false
	for _, assessment := range all {
		if !assessment.Current() {
			continue
		}
		if !found || assessment.Version > best.Version {
			best, found = assessment, true
		}
	}
	return best, found
}

// Technique is how the anaesthetic is given (SRS-ANE-002).
type Technique string

const (
	TechniqueGeneral  Technique = "general"
	TechniqueRegional Technique = "regional"
	TechniqueSpinal   Technique = "spinal"
	TechniqueEpidural Technique = "epidural"
	TechniqueSedation Technique = "sedation"
	TechniqueLocal    Technique = "local"
	TechniqueCombined Technique = "combined"
)

var knownTechniques = map[Technique]bool{
	TechniqueGeneral: true, TechniqueRegional: true, TechniqueSpinal: true,
	TechniqueEpidural: true, TechniqueSedation: true, TechniqueLocal: true,
	TechniqueCombined: true,
}

// Plan is the anaesthetic plan (SRS-ANE-002).
//
// Visible to the theatre's readiness checklist, which is the requirement's own
// clause: a plan the theatre cannot see is a plan the theatre cannot prepare
// for, and the equipment it names is the equipment somebody has to fetch.
type Plan struct {
	ID       string
	TenantID string
	CaseID   string

	Technique Technique
	// Agents are the drugs intended. Named rather than coded here, because a
	// plan is written before the drug chart exists.
	Agents []string
	// Airway is the intended airway — "ETT size 8", "LMA 4", "facemask".
	Airway string
	// Monitoring is what will be attached, beyond the minimum standard. The
	// list a theatre reads to know whether it needs an arterial line set.
	Monitoring []string
	// SpecialEquipment is what has to be fetched: a videolaryngoscope, a
	// warming device, a cell saver.
	SpecialEquipment []string
	// PostOperative is where the patient is planned to go — PACU, critical
	// care, ward. Recorded at planning because a critical-care bed has to be
	// booked before the operation, not after it.
	PostOperative string
	Notes         string

	PlannedBy string
	PlannedAt time.Time
}

// NewPlanInput is an anaesthetic plan.
type NewPlanInput struct {
	CaseID           string
	Technique        Technique
	Agents           []string
	Airway           string
	Monitoring       []string
	SpecialEquipment []string
	PostOperative    string
	Notes            string
}

// NewPlan records the anaesthetic plan (SRS-ANE-002).
func NewPlan(id, tenantID string, in NewPlanInput, by string, now time.Time) (
	Plan, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.CaseID) == "":
		return Plan{}, fmt.Errorf("%w: a plan belongs to a case", ErrInvalidRecord)
	case !knownTechniques[in.Technique]:
		return Plan{}, fmt.Errorf("%w: unknown anaesthetic technique %q",
			ErrInvalidRecord, in.Technique)
	case strings.TrimSpace(by) == "":
		return Plan{}, fmt.Errorf("%w: a plan names who made it", ErrInvalidRecord)
	}

	return Plan{
		ID: id, TenantID: tenantID, CaseID: strings.TrimSpace(in.CaseID),
		Technique: in.Technique, Agents: trimmedAll(in.Agents),
		Airway: strings.TrimSpace(in.Airway), Monitoring: trimmedAll(in.Monitoring),
		SpecialEquipment: trimmedAll(in.SpecialEquipment),
		PostOperative:    strings.TrimSpace(in.PostOperative),
		Notes:            strings.TrimSpace(in.Notes),
		PlannedBy:        strings.TrimSpace(by), PlannedAt: now.UTC(),
	}, nil
}

// Readiness is what the theatre's pre-operative checklist needs from
// anaesthesia (SRS-ANE-002).
//
// A projection rather than the whole record: the checklist asks whether the
// patient has been assessed, whether they are fit, what has to be ready and
// what the theatre should expect. It does not need the history.
type Readiness struct {
	Assessed bool
	// Fit is the assessment's conclusion, and Conditions what it depends on.
	Fit        bool
	Conditions []string
	ASAGrade   ASA
	// DifficultAirway is the one prediction the theatre most needs in advance,
	// because the equipment for it lives somewhere else.
	DifficultAirway  bool
	ConsentStatus    ConsentStatus
	Planned          bool
	Technique        Technique
	SpecialEquipment []string
	PostOperative    string
	// Outstanding names what is missing, so the checklist can show it rather
	// than a bare "not ready".
	Outstanding []string
}

// AssessReadiness projects what the theatre checklist needs (SRS-ANE-002).
func AssessReadiness(assessments []Assessment, plan *Plan) Readiness {
	out := Readiness{}

	assessment, ok := CurrentAssessment(assessments)
	if !ok {
		out.Outstanding = append(out.Outstanding, "pre-anaesthesia assessment")
	} else {
		out.Assessed = true
		out.Fit = assessment.FitToProceed
		out.Conditions = assessment.Conditions
		out.ASAGrade = assessment.ASAGrade
		out.DifficultAirway = assessment.Airway.PredictedDifficult
		out.ConsentStatus = assessment.Consent
		if !assessment.FitToProceed {
			out.Outstanding = append(out.Outstanding,
				"patient not yet fit: "+strings.Join(assessment.Conditions, "; "))
		}
		switch assessment.Consent {
		case ConsentPending:
			out.Outstanding = append(out.Outstanding, "anaesthetic consent")
		case ConsentRefused:
			out.Outstanding = append(out.Outstanding, "anaesthetic consent refused")
		}
	}

	if plan == nil {
		out.Outstanding = append(out.Outstanding, "anaesthetic plan")
	} else {
		out.Planned = true
		out.Technique = plan.Technique
		out.SpecialEquipment = plan.SpecialEquipment
		out.PostOperative = plan.PostOperative
	}

	sort.Strings(out.Outstanding)
	return out
}
