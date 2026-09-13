package domain

import (
	"sort"
	"strings"
	"time"
)

// Wound assessment, education, assignment and acuity
// (SRS-NUR-012, SRS-NUR-015, SRS-NUR-016, SRS-NUR-017).
//
// SRS-NUR-016 carries the most carefully worded acceptance criterion in the
// family: the dashboard "never silently alters staffing decisions". An acuity
// figure is an input to a judgement made by a person who is accountable for
// it. A system that moved nurses between wards on the strength of a computed
// score would be making that judgement while leaving the accountability with
// somebody who did not make it — and the score is built from proxies that are
// wrong in exactly the cases that matter most.

// WoundAssessment is one assessment of a wound or pressure area
// (SRS-NUR-012).
type WoundAssessment struct {
	ID          string
	TenantID    string
	PatientID   string
	EncounterID string

	// WoundID groups the assessments of one wound over time, which is what
	// makes a healing trajectory readable.
	WoundID string
	// Location is the body site, and BodyMapCode the coded position on the
	// body map. Both, because "sacrum" is what a nurse writes and the coded
	// position is what a diagram renders.
	Location    string
	BodyMapCode Coding
	Laterality  Laterality

	Kind WoundKind
	// Stage applies to pressure injuries and is a graded scale, so it is
	// stored as given rather than derived from the description.
	Stage string

	LengthMM, WidthMM, DepthMM float64
	// Appearance, Exudate and SurroundingSkin are the structured observations
	// a wound chart needs to show change.
	Appearance      string
	Exudate         string
	SurroundingSkin string
	PainScore       *int32

	// Images are attached only where consent covers them (SRS-NUR-012).
	Images []WoundImage

	AssessedAt time.Time
	RecordedAt time.Time
	AssessedBy string
	Version    int64
}

// WoundKind is what sort of wound it is.
type WoundKind string

const (
	WoundPressureInjury WoundKind = "pressure_injury"
	WoundSurgical       WoundKind = "surgical"
	WoundTrauma         WoundKind = "trauma"
	WoundBurn           WoundKind = "burn"
	WoundUlcer          WoundKind = "ulcer"
	WoundOther          WoundKind = "other"
)

var knownWoundKinds = map[WoundKind]bool{
	WoundPressureInjury: true, WoundSurgical: true, WoundTrauma: true,
	WoundBurn: true, WoundUlcer: true, WoundOther: true,
}

// WoundImage is a photograph of a wound (SRS-NUR-012).
//
// A photograph of a wound is a photograph of a patient. It carries its own
// consent reference and its own confidentiality, and the version number is
// there because a series of images is the evidence of healing and a replaced
// image destroys it.
type WoundImage struct {
	ImageID string
	// ConsentID points at the clinical consent that covers photography. Not a
	// boolean: the requirement says "where consented", and a boolean cannot be
	// checked against a consent that was later withdrawn.
	ConsentID string
	// StorageKey addresses the bytes. The bytes themselves never come through
	// this context.
	StorageKey  string
	ContentType string
	CapturedAt  time.Time
	CapturedBy  string
	// Sequence orders the series. Immutable once set: an image is added, never
	// replaced.
	Sequence int32
}

// NewWoundAssessmentInput is what recording a wound assessment needs.
type NewWoundAssessmentInput struct {
	PatientID       string
	EncounterID     string
	WoundID         string
	Location        string
	BodyMapCode     Coding
	Laterality      Laterality
	Kind            WoundKind
	Stage           string
	LengthMM        float64
	WidthMM         float64
	DepthMM         float64
	Appearance      string
	Exudate         string
	SurroundingSkin string
	PainScore       *int32
	AssessedAt      time.Time
}

// NewWoundAssessment records a wound assessment.
func NewWoundAssessment(id, tenantID string, in NewWoundAssessmentInput,
	assessedBy string, now time.Time) (*WoundAssessment, error) {

	if strings.TrimSpace(in.PatientID) == "" {
		return nil, invalidf("a wound assessment needs a patient")
	}
	if strings.TrimSpace(in.EncounterID) == "" {
		return nil, invalidf("a wound assessment needs an encounter")
	}
	if strings.TrimSpace(in.WoundID) == "" {
		// Without it, ten assessments of one sacral pressure injury and one
		// assessment each of ten wounds look the same.
		return nil, invalidf("a wound assessment needs to say which wound it is of")
	}
	if strings.TrimSpace(in.Location) == "" {
		return nil, invalidf("a wound assessment needs the body site")
	}
	if !knownWoundKinds[in.Kind] {
		return nil, invalidf("unknown wound kind %q", in.Kind)
	}
	if strings.TrimSpace(assessedBy) == "" {
		return nil, invalidf("a wound assessment must record who carried it out")
	}
	if in.Kind == WoundPressureInjury && strings.TrimSpace(in.Stage) == "" {
		// The stage is what drives the care plan and the incident reporting; a
		// pressure injury charted without one is a pressure injury nobody
		// reports.
		return nil, invalidf("a pressure injury needs its stage")
	}
	if strings.TrimSpace(in.Appearance) == "" {
		return nil, invalidf("a wound assessment needs the wound's appearance")
	}
	if in.PainScore != nil && (*in.PainScore < 0 || *in.PainScore > 10) {
		return nil, invalidf("a pain score must be between 0 and 10")
	}
	if in.AssessedAt.IsZero() {
		return nil, invalidf("a wound assessment needs the time it was carried out")
	}
	assessed := in.AssessedAt.UTC()
	if assessed.After(now.UTC()) {
		return nil, invalidf("a wound assessment cannot have been carried out in the future")
	}
	laterality := in.Laterality
	if laterality == "" {
		laterality = LateralityNotApplicable
	}
	if !knownLateralities[laterality] {
		return nil, invalidf("unknown laterality %q", in.Laterality)
	}

	return &WoundAssessment{
		ID: id, TenantID: tenantID,
		PatientID: in.PatientID, EncounterID: in.EncounterID,
		WoundID:  strings.TrimSpace(in.WoundID),
		Location: strings.TrimSpace(in.Location), BodyMapCode: in.BodyMapCode,
		Laterality: laterality, Kind: in.Kind, Stage: strings.TrimSpace(in.Stage),
		LengthMM: in.LengthMM, WidthMM: in.WidthMM, DepthMM: in.DepthMM,
		Appearance:      strings.TrimSpace(in.Appearance),
		Exudate:         strings.TrimSpace(in.Exudate),
		SurroundingSkin: strings.TrimSpace(in.SurroundingSkin),
		PainScore:       in.PainScore,
		AssessedAt:      assessed, RecordedAt: now.UTC(),
		AssessedBy: assessedBy, Version: 1,
	}, nil
}

// AreaMM2 is the wound's surface area, which is what a healing trend is drawn
// from.
func (w *WoundAssessment) AreaMM2() float64 { return w.LengthMM * w.WidthMM }

// AttachImage adds a photograph, which requires a consent that covers it
// (SRS-NUR-012).
//
// The consent is checked by the caller against the clinical context's consent
// record and passed in as a decision. This context refuses an image with no
// consent reference, so there is no path by which an unconsented photograph is
// stored — including for a caller that simply forgot to look.
func (w *WoundAssessment) AttachImage(img WoundImage, consentCovers bool,
	now time.Time) error {

	if strings.TrimSpace(img.ImageID) == "" {
		return invalidf("an image needs an identifier")
	}
	if strings.TrimSpace(img.StorageKey) == "" {
		return invalidf("an image needs somewhere to read its bytes from")
	}
	if strings.TrimSpace(img.ConsentID) == "" {
		return notAllowedf(
			"photographing a wound needs a consent covering clinical photography")
	}
	if !consentCovers {
		return notAllowedf(
			"consent %s does not cover clinical photography, or has been withdrawn",
			img.ConsentID)
	}
	if strings.TrimSpace(img.CapturedBy) == "" {
		return invalidf("an image must record who took it")
	}
	if img.CapturedAt.IsZero() {
		return invalidf("an image needs the time it was taken")
	}
	if img.CapturedAt.UTC().After(now.UTC()) {
		return invalidf("an image cannot have been taken in the future")
	}
	for _, existing := range w.Images {
		if existing.ImageID == img.ImageID {
			return notAllowedf("this image is already attached")
		}
	}
	img.CapturedAt = img.CapturedAt.UTC()
	img.Sequence = int32(len(w.Images)) + 1
	w.Images = append(w.Images, img)
	w.Version++
	return nil
}

// EducationRecord is one episode of patient or family teaching
// (SRS-NUR-015).
type EducationRecord struct {
	ID          string
	TenantID    string
	PatientID   string
	EncounterID string

	Topic Coding
	// Learner is who was taught. Not always the patient: teaching a carer to
	// manage a stoma is the episode that determines whether the patient copes
	// at home, and recording it against the patient loses who actually knows
	// how.
	Learner     Learner
	LearnerName string
	// Method is how: demonstration, written material, interpreter-assisted
	// discussion. Stored because "explained" covers both a leaflet handed over
	// and a taught return-demonstration.
	Method string
	// Understanding is the outcome, and the reason the record exists. Teaching
	// delivered is not teaching received.
	Understanding Understanding
	// Barriers names what got in the way: language, pain, cognition.
	Barriers string

	TaughtAt time.Time
	TaughtBy string
	Version  int64
}

// Learner is who was taught.
type Learner string

const (
	LearnerPatient Learner = "patient"
	LearnerFamily  Learner = "family"
	LearnerCarer   Learner = "carer"
)

// Understanding is how well the teaching landed.
type Understanding string

const (
	// UnderstandingDemonstrated is the strongest: the learner did it back.
	UnderstandingDemonstrated Understanding = "demonstrated"
	UnderstandingVerbalised   Understanding = "verbalised"
	// UnderstandingNeedsReinforcement is not a failure; it is the finding that
	// schedules the next session, and suppressing it is how a patient goes
	// home unable to manage.
	UnderstandingNeedsReinforcement Understanding = "needs_reinforcement"
	UnderstandingUnableToAssess     Understanding = "unable_to_assess"
)

var knownUnderstanding = map[Understanding]bool{
	UnderstandingDemonstrated: true, UnderstandingVerbalised: true,
	UnderstandingNeedsReinforcement: true, UnderstandingUnableToAssess: true,
}

var knownLearners = map[Learner]bool{
	LearnerPatient: true, LearnerFamily: true, LearnerCarer: true,
}

// NewEducationRecord records a teaching episode.
func NewEducationRecord(id, tenantID, patientID, encounterID string,
	topic Coding, learner Learner, learnerName, method string,
	understanding Understanding, barriers string, taughtAt time.Time,
	taughtBy string, now time.Time) (*EducationRecord, error) {

	if strings.TrimSpace(patientID) == "" {
		return nil, invalidf("an education record needs a patient")
	}
	if strings.TrimSpace(encounterID) == "" {
		return nil, invalidf("an education record needs an encounter")
	}
	if err := topic.Validate(); err != nil {
		return nil, err
	}
	if !knownLearners[learner] {
		return nil, invalidf("unknown learner %q", learner)
	}
	if learner != LearnerPatient && strings.TrimSpace(learnerName) == "" {
		return nil, invalidf("teaching somebody other than the patient must name them")
	}
	if strings.TrimSpace(method) == "" {
		return nil, invalidf("an education record needs the method used")
	}
	if !knownUnderstanding[understanding] {
		return nil, invalidf("unknown understanding status %q", understanding)
	}
	if strings.TrimSpace(taughtBy) == "" {
		return nil, invalidf("an education record must record who taught")
	}
	if taughtAt.IsZero() {
		return nil, invalidf("an education record needs the time of teaching")
	}
	taught := taughtAt.UTC()
	if taught.After(now.UTC()) {
		return nil, invalidf("teaching cannot have happened in the future")
	}

	return &EducationRecord{
		ID: id, TenantID: tenantID,
		PatientID: patientID, EncounterID: encounterID,
		Topic: topic, Learner: learner,
		LearnerName:   strings.TrimSpace(learnerName),
		Method:        strings.TrimSpace(method),
		Understanding: understanding, Barriers: strings.TrimSpace(barriers),
		TaughtAt: taught, TaughtBy: taughtBy, Version: 1,
	}, nil
}

// DischargeReadiness is the nursing view of whether a patient can go home
// (SRS-NUR-015).
type DischargeReadiness struct {
	// Criteria are the things that must be true, each with its own state, so
	// "not ready" names what is outstanding rather than being a verdict.
	Criteria   []ReadinessCriterion
	AssessedAt time.Time
	AssessedBy string
}

// ReadinessCriterion is one discharge requirement.
type ReadinessCriterion struct {
	Key   string
	Label string
	Met   bool
	// Note explains an unmet criterion.
	Note string
}

// Outstanding lists what is not yet met.
//
// All of them, like the encounter closure gate's missing documentation and for
// the same reason: a nurse told about one blocker, who clears it and is then
// told about another, stops planning discharges in advance.
func (d DischargeReadiness) Outstanding() []ReadinessCriterion {
	var out []ReadinessCriterion
	for _, c := range d.Criteria {
		if !c.Met {
			out = append(out, c)
		}
	}
	sort.SliceStable(out, func(i, j int) bool { return out[i].Key < out[j].Key })
	return out
}

// Ready reports whether every criterion is met.
func (d DischargeReadiness) Ready() bool { return len(d.Outstanding()) == 0 }

// NurseAssignment is one nurse's responsibility for one patient
// (SRS-NUR-017).
//
// Effective-dated, for the reason the encounter context's care team is: the
// question an incident review asks is "who was looking after this patient at
// 03:40", and a list with no dates answers today's question and silently gives
// the wrong answer to every question about the past.
type NurseAssignment struct {
	ID       string
	TenantID string
	UnitID   string
	BedID    string
	// PatientID may be empty for a bed-based assignment where no patient is in
	// it yet.
	PatientID string
	NurseID   string
	// Relationship is what kind of responsibility: primary nurse, associate,
	// covering. Authorization asks about the relationship, not merely the
	// presence of a row.
	Relationship CareRelationship

	EffectiveFrom time.Time
	EffectiveTo   time.Time
	AssignedBy    string
	// EndedReason distinguishes a shift ending from a reassignment mid-shift,
	// which is the difference between routine and an event worth looking at.
	EndedReason string
	Version     int64
}

// CareRelationship is the kind of nursing responsibility.
type CareRelationship string

const (
	RelationshipPrimary   CareRelationship = "primary"
	RelationshipAssociate CareRelationship = "associate"
	RelationshipCovering  CareRelationship = "covering"
	RelationshipInCharge  CareRelationship = "in_charge"
)

var knownRelationships = map[CareRelationship]bool{
	RelationshipPrimary: true, RelationshipAssociate: true,
	RelationshipCovering: true, RelationshipInCharge: true,
}

// NewAssignment assigns a nurse.
func NewAssignment(id, tenantID, unitID, bedID, patientID, nurseID string,
	relationship CareRelationship, from time.Time, assignedBy string) (
	*NurseAssignment, error) {

	if strings.TrimSpace(unitID) == "" {
		return nil, invalidf("an assignment needs a unit")
	}
	if strings.TrimSpace(nurseID) == "" {
		return nil, invalidf("an assignment needs a nurse")
	}
	if !knownRelationships[relationship] {
		return nil, invalidf("unknown care relationship %q", relationship)
	}
	if strings.TrimSpace(assignedBy) == "" {
		return nil, invalidf("an assignment must record who made it")
	}
	if from.IsZero() {
		return nil, invalidf("an assignment needs a start time")
	}
	if strings.TrimSpace(patientID) == "" && strings.TrimSpace(bedID) == "" {
		// An assignment to neither a patient nor a bed is an assignment to
		// nothing, and would answer "who is looking after this patient" with a
		// row that means the nurse is on the ward.
		return nil, invalidf("an assignment needs a patient or a bed")
	}

	return &NurseAssignment{
		ID: id, TenantID: tenantID,
		UnitID: strings.TrimSpace(unitID), BedID: strings.TrimSpace(bedID),
		PatientID: strings.TrimSpace(patientID), NurseID: nurseID,
		Relationship:  relationship,
		EffectiveFrom: from.UTC(), AssignedBy: assignedBy, Version: 1,
	}, nil
}

// End closes an assignment (SRS-NUR-017).
//
// Closed rather than deleted, so the answer to "who held this patient last
// Tuesday night" survives the shift ending.
func (a *NurseAssignment) End(at time.Time, reason string) error {
	if !a.EffectiveTo.IsZero() {
		return notAllowedf("this assignment has already ended")
	}
	if at.IsZero() {
		return invalidf("ending an assignment needs a time")
	}
	if !at.UTC().After(a.EffectiveFrom) {
		return invalidf("an assignment cannot end before it began")
	}
	a.EffectiveTo = at.UTC()
	a.EndedReason = strings.TrimSpace(reason)
	a.Version++
	return nil
}

// Covers reports whether this assignment was in force at a given moment.
func (a *NurseAssignment) Covers(at time.Time) bool {
	at = at.UTC()
	if at.Before(a.EffectiveFrom) {
		return false
	}
	return a.EffectiveTo.IsZero() || at.Before(a.EffectiveTo)
}

// AcuityInputs are the named factors a workload figure is built from
// (SRS-NUR-016).
//
// Named and stored rather than computed from whatever is to hand, because the
// requirement says the dashboard "uses defined acuity inputs" — a figure whose
// inputs vary with what happened to be queryable is a figure nobody can
// challenge, and an unchallengeable number is how a staffing dispute becomes
// unresolvable.
type AcuityInputs struct {
	// DependencyScore is the patient's assessed care dependency, on the
	// tenant's own scale.
	DependencyScore int32
	// OpenTasks and OverdueTasks are outstanding nursing work.
	OpenTasks    int32
	OverdueTasks int32
	// Devices in place, each of which carries its own care burden.
	Devices int32
	// HighRisk counts risk assessments in an escalating band.
	HighRisk int32
	// Isolation adds the time cost of donning and doffing, which is
	// substantial and invisible in every other measure.
	Isolation bool
}

// PatientAcuity is one patient's computed workload figure (SRS-NUR-016).
type PatientAcuity struct {
	PatientID string
	Inputs    AcuityInputs
	Score     int32
	// Weights used, carried with the figure so two wards' numbers can be
	// compared only when they were computed the same way.
	Weights AcuityWeights
	AsOf    time.Time
}

// AcuityWeights are the tenant's chosen multipliers.
type AcuityWeights struct {
	Dependency  int32
	OpenTask    int32
	OverdueTask int32
	Device      int32
	HighRisk    int32
	Isolation   int32
}

// DefaultAcuityWeights is a starting point, not a clinical standard.
//
// Every hospital that has tried to compute nursing workload has ended up with
// different weights, because the work depends on the ward's layout, its skill
// mix and its case mix. These are defaults a tenant is expected to retune, and
// the weights travel with the score so a retune does not silently rewrite
// history.
func DefaultAcuityWeights() AcuityWeights {
	return AcuityWeights{
		Dependency: 3, OpenTask: 1, OverdueTask: 2,
		Device: 2, HighRisk: 4, Isolation: 5,
	}
}

// Acuity computes one patient's workload figure.
func Acuity(patientID string, in AcuityInputs, w AcuityWeights,
	asOf time.Time) PatientAcuity {

	score := in.DependencyScore*w.Dependency +
		in.OpenTasks*w.OpenTask +
		in.OverdueTasks*w.OverdueTask +
		in.Devices*w.Device +
		in.HighRisk*w.HighRisk
	if in.Isolation {
		score += w.Isolation
	}
	return PatientAcuity{
		PatientID: patientID, Inputs: in, Score: score,
		Weights: w, AsOf: asOf.UTC(),
	}
}

// UnitAcuity is a ward's workload picture (SRS-NUR-016).
//
// A report, and nothing more. It carries no staffing recommendation and
// triggers no assignment: SRS-NUR-016's acceptance criterion is that the
// dashboard "never silently alters staffing decisions", and the way to hold
// that is for the dashboard to have no mechanism by which it could.
type UnitAcuity struct {
	UnitID   string
	AsOf     time.Time
	Patients []PatientAcuity
	// NursesOnDuty is counted from live assignments, not from a roster: a
	// roster says who was meant to be there.
	NursesOnDuty int32
	Total        int32
}

// PerNurse is the total divided across the nurses actually on the unit.
//
// Returns false rather than zero when there is nobody on duty. A ward with no
// nurses assigned is not a ward with zero workload per nurse, and rendering it
// as such would put the emptiest ward at the bottom of the list.
func (u UnitAcuity) PerNurse() (float64, bool) {
	if u.NursesOnDuty <= 0 {
		return 0, false
	}
	return float64(u.Total) / float64(u.NursesOnDuty), true
}

// SummariseUnit builds a unit's acuity picture from its patients.
func SummariseUnit(unitID string, patients []PatientAcuity, nursesOnDuty int32,
	asOf time.Time) UnitAcuity {

	out := UnitAcuity{
		UnitID: unitID, AsOf: asOf.UTC(),
		Patients:     append([]PatientAcuity(nil), patients...),
		NursesOnDuty: nursesOnDuty,
	}
	for _, p := range patients {
		out.Total += p.Score
	}
	// Busiest first: the list exists to direct attention.
	sort.SliceStable(out.Patients, func(i, j int) bool {
		return out.Patients[i].Score > out.Patients[j].Score
	})
	return out
}
