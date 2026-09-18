package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// The anaesthetic record itself, PACU handover and scoring (SRS-ANE-008),
// acute pain (SRS-ANE-009), the summary (SRS-ANE-010) and downtime import
// (SRS-ANE-011).

// RecordStatus is where an anaesthetic record has got to.
type RecordStatus string

const (
	RecordOpen RecordStatus = "open"
	// RecordInRecovery is after handover to PACU and before discharge from it.
	RecordInRecovery RecordStatus = "in_recovery"
	RecordClosed     RecordStatus = "closed"
)

// Record is one case's anaesthetic (SRS-ANE-003).
//
// It hangs off the theatre case rather than replacing it. The patient, the
// procedure and the operative note belong to the case; what is here is the
// anaesthetist's record of what they did.
type Record struct {
	ID       string
	TenantID string

	CaseID      string
	EncounterID string
	PatientID   string

	Technique Technique
	Status    RecordStatus

	StartedAt time.Time
	StartedBy string
	// EndedAt is when the anaesthetic ended, which is not when the operation
	// ended: emergence takes time and it is the anaesthetist's.
	EndedAt time.Time

	// Origin marks a record typed up from paper afterwards (SRS-ANE-011).
	Origin EntrySource
	// ImportNote explains a downtime import: when the paper record was made,
	// who transcribed it and against what. A reconstructed record that did not
	// say so would read as a contemporaneous one.
	ImportNote string
	ImportedAt time.Time
	ImportedBy string
}

// NewRecordInput opens an anaesthetic record.
type NewRecordInput struct {
	CaseID      string
	EncounterID string
	PatientID   string
	Technique   Technique
	StartedAt   time.Time
	// Origin and ImportNote mark a downtime import.
	Origin     EntrySource
	ImportNote string
}

// NewRecord opens an anaesthetic record (SRS-ANE-003, SRS-ANE-011).
func NewRecord(id, tenantID string, in NewRecordInput, by string, now time.Time) (
	Record, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.CaseID) == "":
		return Record{}, fmt.Errorf("%w: an anaesthetic record belongs to a case",
			ErrInvalidRecord)
	case strings.TrimSpace(in.PatientID) == "":
		return Record{}, fmt.Errorf("%w: a record names a patient", ErrInvalidRecord)
	case !knownTechniques[in.Technique]:
		return Record{}, fmt.Errorf("%w: unknown anaesthetic technique %q",
			ErrInvalidRecord, in.Technique)
	case strings.TrimSpace(by) == "":
		return Record{}, fmt.Errorf("%w: a record names the anaesthetist",
			ErrInvalidRecord)
	}

	origin := in.Origin
	if origin == "" {
		origin = SourceManual
	}
	if origin != SourceManual && origin != SourceImported {
		return Record{}, fmt.Errorf(
			"%w: a record is made here or imported from paper", ErrInvalidRecord)
	}
	if origin == SourceImported && strings.TrimSpace(in.ImportNote) == "" {
		// A reconstructed record that did not say so would read as a
		// contemporaneous one, which is exactly what SRS-ANE-011's "clearly
		// marked and audit-linked" prevents.
		return Record{}, fmt.Errorf(
			"%w: an imported record says where it came from and when", ErrInvalidRecord)
	}

	started := in.StartedAt
	if started.IsZero() {
		started = now
	}

	record := Record{
		ID: id, TenantID: tenantID, CaseID: strings.TrimSpace(in.CaseID),
		EncounterID: strings.TrimSpace(in.EncounterID),
		PatientID:   strings.TrimSpace(in.PatientID),
		Technique:   in.Technique, Status: RecordOpen,
		StartedAt: started.UTC(), StartedBy: strings.TrimSpace(by),
		Origin: origin, ImportNote: strings.TrimSpace(in.ImportNote),
	}
	if origin == SourceImported {
		record.ImportedAt, record.ImportedBy = now.UTC(), strings.TrimSpace(by)
	}
	return record, nil
}

// RecoveryScale is the score a unit discharges from recovery on
// (SRS-ANE-008).
//
// Configured rather than hard-coded: Aldrete, modified Aldrete and PADSS are
// all in use, and a unit that has agreed one should not wait for this
// enumeration. The threshold travels with the scale, so a score recorded under
// one is never read against another's bar.
type RecoveryScale struct {
	Name    string
	Version string
	// Components are the things scored, each with a maximum.
	Components []ScoreComponent
	// DischargeAt is the total a patient may leave recovery on.
	DischargeAt int
}

// ScoreComponent is one element of a recovery score.
type ScoreComponent struct {
	Code  string
	Label string
	Max   int
}

// Validate refuses a scale nothing could be scored against.
func (s RecoveryScale) Validate() error {
	switch {
	case strings.TrimSpace(s.Name) == "":
		return fmt.Errorf("%w: a recovery scale has a name", ErrInvalidRecord)
	case strings.TrimSpace(s.Version) == "":
		return fmt.Errorf("%w: a recovery scale has a version", ErrInvalidRecord)
	case len(s.Components) == 0:
		return fmt.Errorf("%w: a recovery scale has components", ErrInvalidRecord)
	}

	total := 0
	seen := map[string]bool{}
	for _, component := range s.Components {
		if strings.TrimSpace(component.Code) == "" {
			return fmt.Errorf("%w: a component has a code", ErrInvalidRecord)
		}
		if seen[component.Code] {
			return fmt.Errorf("%w: component %q appears twice",
				ErrInvalidRecord, component.Code)
		}
		seen[component.Code] = true
		if component.Max <= 0 {
			return fmt.Errorf("%w: component %q has no maximum",
				ErrInvalidRecord, component.Code)
		}
		total += component.Max
	}

	switch {
	case s.DischargeAt <= 0:
		return fmt.Errorf(
			"%w: a scale with no discharge threshold is a score nobody can act on",
			ErrInvalidRecord)
	case s.DischargeAt > total:
		// A threshold above the maximum is unreachable, which would trap every
		// patient in recovery until somebody overrode it.
		return fmt.Errorf("%w: the threshold %d is above the maximum score %d",
			ErrInvalidRecord, s.DischargeAt, total)
	}
	return nil
}

// Aldrete is the modified Aldrete score, which most units use.
func Aldrete() RecoveryScale {
	return RecoveryScale{
		Name: "Modified Aldrete", Version: "1", DischargeAt: 9,
		Components: []ScoreComponent{
			{Code: "activity", Label: "Activity", Max: 2},
			{Code: "respiration", Label: "Respiration", Max: 2},
			{Code: "circulation", Label: "Circulation", Max: 2},
			{Code: "consciousness", Label: "Consciousness", Max: 2},
			{Code: "saturation", Label: "Oxygen saturation", Max: 2},
		},
	}
}

// RecoveryAssessment is one scored assessment in PACU (SRS-ANE-008).
type RecoveryAssessment struct {
	ID       string
	TenantID string
	RecordID string

	ScaleName    string
	ScaleVersion string
	// Scores are the component values as recorded, so the total can be read
	// back rather than taken on trust.
	Scores map[string]int
	Total  int
	// DischargeThreshold travels with the assessment, so a score recorded
	// under one scale is never read against another's bar.
	DischargeThreshold int
	// Missing names components with no score. A partial assessment is not a
	// low one: scoring an unscored component as zero would trap a patient, and
	// scoring it as full would discharge one.
	Missing []string

	AssessedAt time.Time
	AssessedBy string
}

// Complete reports an assessment every component was scored for.
func (r RecoveryAssessment) Complete() bool { return len(r.Missing) == 0 }

// MeetsThreshold reports whether the patient may leave on this score.
func (r RecoveryAssessment) MeetsThreshold() bool {
	return r.Complete() && r.Total >= r.DischargeThreshold
}

// Assess scores a patient in recovery (SRS-ANE-008).
func Assess(id, tenantID, recordID string, scale RecoveryScale, scores map[string]int,
	by string, at time.Time) (RecoveryAssessment, error) {

	if err := scale.Validate(); err != nil {
		return RecoveryAssessment{}, err
	}
	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(recordID) == "":
		return RecoveryAssessment{}, fmt.Errorf("%w: an assessment belongs to a record",
			ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return RecoveryAssessment{}, fmt.Errorf("%w: an assessment names who made it",
			ErrInvalidRecord)
	}

	out := RecoveryAssessment{
		ID: id, TenantID: tenantID, RecordID: strings.TrimSpace(recordID),
		ScaleName: scale.Name, ScaleVersion: scale.Version,
		Scores: map[string]int{}, DischargeThreshold: scale.DischargeAt,
		AssessedAt: at.UTC(), AssessedBy: strings.TrimSpace(by),
	}

	for _, component := range scale.Components {
		value, ok := scores[component.Code]
		if !ok {
			out.Missing = append(out.Missing, component.Code)
			continue
		}
		if value < 0 || value > component.Max {
			return RecoveryAssessment{}, fmt.Errorf(
				"%w: %s scores 0 to %d, not %d",
				ErrInvalidRecord, component.Label, component.Max, value)
		}
		out.Scores[component.Code] = value
		out.Total += value
	}
	sort.Strings(out.Missing)
	return out, nil
}

// Handover is the anaesthetist's handover to recovery (SRS-ANE-008).
type Handover struct {
	ID       string
	TenantID string
	RecordID string

	// FromClinician and ToClinician are both named, because a handover is
	// between two people and a record naming one is a note.
	FromClinician string
	ToClinician   string

	// Summary is what happened, Concerns what to watch for, and Instructions
	// what to do. Three fields rather than one, because a recovery nurse reads
	// them at different moments.
	Summary      string
	Concerns     []string
	Instructions []string
	// Analgesia and Antiemetics given in theatre, so recovery knows what is
	// already on board before giving more.
	AnalgesiaGiven  []string
	AntiemeticGiven []string

	HandedOverAt time.Time
}

// NewHandoverInput is a PACU handover.
type NewHandoverInput struct {
	RecordID        string
	ToClinician     string
	Summary         string
	Concerns        []string
	Instructions    []string
	AnalgesiaGiven  []string
	AntiemeticGiven []string
}

// HandOver records the handover to recovery (SRS-ANE-008).
func HandOver(id, tenantID string, in NewHandoverInput, from string, now time.Time) (
	Handover, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.RecordID) == "":
		return Handover{}, fmt.Errorf("%w: a handover belongs to a record",
			ErrInvalidRecord)
	case strings.TrimSpace(from) == "":
		return Handover{}, fmt.Errorf("%w: a handover names who gave it",
			ErrInvalidRecord)
	case strings.TrimSpace(in.ToClinician) == "":
		// A handover is between two people. One that names only the giver is a
		// note left on a trolley.
		return Handover{}, fmt.Errorf("%w: a handover names who received it",
			ErrInvalidRecord)
	case strings.TrimSpace(in.Summary) == "":
		return Handover{}, fmt.Errorf("%w: a handover says what happened",
			ErrInvalidRecord)
	}

	return Handover{
		ID: id, TenantID: tenantID, RecordID: strings.TrimSpace(in.RecordID),
		FromClinician:   strings.TrimSpace(from),
		ToClinician:     strings.TrimSpace(in.ToClinician),
		Summary:         strings.TrimSpace(in.Summary),
		Concerns:        trimmedAll(in.Concerns),
		Instructions:    trimmedAll(in.Instructions),
		AnalgesiaGiven:  trimmedAll(in.AnalgesiaGiven),
		AntiemeticGiven: trimmedAll(in.AntiemeticGiven),
		HandedOverAt:    now.UTC(),
	}, nil
}

// DischargeRefusal is a reason a patient may not leave recovery.
type DischargeRefusal string

const (
	RefusalNotHandedOver   DischargeRefusal = "not_handed_over"
	RefusalNotAssessed     DischargeRefusal = "not_assessed"
	RefusalIncompleteScore DischargeRefusal = "incomplete_score"
	RefusalBelowThreshold  DischargeRefusal = "below_threshold"
)

// Explain says what to do about a refusal.
func (r DischargeRefusal) Explain() string {
	switch r {
	case RefusalNotHandedOver:
		return "The anaesthetist has not handed over."
	case RefusalNotAssessed:
		return "No recovery score has been recorded."
	case RefusalIncompleteScore:
		return "The recovery score is incomplete; score every component."
	case RefusalBelowThreshold:
		return "The recovery score is below the discharge threshold."
	default:
		return string(r)
	}
}

// DischargeDecision is the outcome of trying to send a patient out of recovery.
type DischargeDecision struct {
	// Refusals is every reason at once, so a recovery nurse is not told them
	// one at a time while a trolley waits.
	Refusals []DischargeRefusal
	// Score is the assessment the decision was made on.
	Score *RecoveryAssessment
}

// Allowed reports whether the patient may leave without an override.
func (d DischargeDecision) Allowed() bool { return len(d.Refusals) == 0 }

// EvaluateDischarge decides whether a patient may leave recovery
// (SRS-ANE-008).
//
// "PACU discharge requires threshold or documented override" is the
// requirement. This answers the threshold half and returns every reason it is
// not met; the override is the caller's, and carries a reason.
func EvaluateDischarge(handedOver bool, assessments []RecoveryAssessment) DischargeDecision {
	out := DischargeDecision{}

	if !handedOver {
		out.Refusals = append(out.Refusals, RefusalNotHandedOver)
	}

	var latest *RecoveryAssessment
	for i := range assessments {
		if latest == nil || assessments[i].AssessedAt.After(latest.AssessedAt) {
			latest = &assessments[i]
		}
	}
	if latest == nil {
		out.Refusals = append(out.Refusals, RefusalNotAssessed)
		return out
	}

	out.Score = latest
	switch {
	case !latest.Complete():
		// A partial score is not a low one. Scoring an unscored component as
		// zero would trap a patient; as full, it would discharge one.
		out.Refusals = append(out.Refusals, RefusalIncompleteScore)
	case latest.Total < latest.DischargeThreshold:
		out.Refusals = append(out.Refusals, RefusalBelowThreshold)
	}
	return out
}

// Discharge sends a patient out of recovery (SRS-ANE-008).
//
// An override is allowed and recorded. A patient who is awake, comfortable and
// going to critical care does not need an Aldrete of 9, and a unit that could
// not send them would keep a recovery bay occupied to satisfy a score.
type Discharge struct {
	ID       string
	TenantID string
	RecordID string

	// Destination is where the patient went — ward, critical care, home.
	Destination string
	// Overridden marks a discharge below the threshold, and OverrideReason
	// says why. Required: the override is the whole of what a review reads.
	Overridden     bool
	OverrideReason string
	// ScoreID names the assessment the decision was made on, so the record can
	// be read back rather than taken on trust.
	ScoreID string

	DischargedAt time.Time
	DischargedBy string
}

// NewDischarge records a discharge from recovery (SRS-ANE-008).
func NewDischarge(id, tenantID, recordID, destination string,
	decision DischargeDecision, overrideReason, by string, now time.Time) (
	Discharge, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(recordID) == "":
		return Discharge{}, fmt.Errorf("%w: a discharge belongs to a record",
			ErrInvalidRecord)
	case strings.TrimSpace(destination) == "":
		return Discharge{}, fmt.Errorf("%w: a discharge names where the patient went",
			ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return Discharge{}, fmt.Errorf("%w: a discharge names who authorised it",
			ErrInvalidRecord)
	}

	out := Discharge{
		ID: id, TenantID: tenantID, RecordID: strings.TrimSpace(recordID),
		Destination:  strings.TrimSpace(destination),
		DischargedAt: now.UTC(), DischargedBy: strings.TrimSpace(by),
	}
	if decision.Score != nil {
		out.ScoreID = decision.Score.ID
	}

	if decision.Allowed() {
		return out, nil
	}

	// Not handed over is not overridable: the override exists for a patient
	// who is clinically ready and scores below a bar, not for one nobody has
	// handed over.
	for _, refusal := range decision.Refusals {
		if refusal == RefusalNotHandedOver {
			return Discharge{}, fmt.Errorf("%w: %s", ErrInvalidRecord,
				refusal.Explain())
		}
	}
	if strings.TrimSpace(overrideReason) == "" {
		reasons := make([]string, 0, len(decision.Refusals))
		for _, refusal := range decision.Refusals {
			reasons = append(reasons, refusal.Explain())
		}
		return Discharge{}, fmt.Errorf("%w: %s Record why this patient may leave.",
			ErrInvalidRecord, strings.Join(reasons, " "))
	}

	out.Overridden, out.OverrideReason = true, strings.TrimSpace(overrideReason)
	return out, nil
}

// PainOrder is an acute pain instruction (SRS-ANE-009).
//
// It names the prescription rather than being one. The drug chart is SRS-MED's
// and a second place to prescribe from is how a patient gets two doses; what
// this holds is the plan around it — what to watch, when to review, who to
// call.
type PainOrder struct {
	ID       string
	TenantID string
	RecordID string

	PatientID   string
	EncounterID string

	// Modality is what is running — PCA, epidural, regional block, oral.
	Modality string
	// PrescriptionIDs link to the drug chart. The eMAR administers from those,
	// never from here.
	PrescriptionIDs []string

	// TargetScore is the pain score the plan aims for, on the unit's scale.
	TargetScore string
	// Monitoring is what nursing must observe and how often — "respiratory
	// rate hourly", "block height four-hourly".
	Monitoring []string
	// Escalation is who to call and when. The most important field: a pain
	// plan with no escalation is one a ward nurse cannot act on at 3am.
	Escalation string
	// ReviewBy is when the acute pain team will see the patient.
	ReviewBy time.Time

	OrderedBy string
	OrderedAt time.Time
	StoppedAt time.Time
	StoppedBy string
}

// NewPainOrderInput is an acute pain plan.
type NewPainOrderInput struct {
	RecordID        string
	PatientID       string
	EncounterID     string
	Modality        string
	PrescriptionIDs []string
	TargetScore     string
	Monitoring      []string
	Escalation      string
	ReviewBy        time.Time
}

// NewPainOrder records an acute pain plan (SRS-ANE-009).
func NewPainOrder(id, tenantID string, in NewPainOrderInput, by string,
	now time.Time) (PainOrder, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.RecordID) == "":
		return PainOrder{}, fmt.Errorf("%w: a pain plan belongs to a record",
			ErrInvalidRecord)
	case strings.TrimSpace(in.PatientID) == "":
		return PainOrder{}, fmt.Errorf("%w: a pain plan names a patient",
			ErrInvalidRecord)
	case strings.TrimSpace(in.Modality) == "":
		return PainOrder{}, fmt.Errorf("%w: a pain plan names what is running",
			ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return PainOrder{}, fmt.Errorf("%w: a pain plan names who made it",
			ErrInvalidRecord)
	case len(trimmedAll(in.Monitoring)) == 0:
		// A plan with nothing to observe is one nursing cannot follow.
		return PainOrder{}, fmt.Errorf("%w: say what nursing must observe",
			ErrInvalidRecord)
	case strings.TrimSpace(in.Escalation) == "":
		// The field a ward nurse needs at three in the morning.
		return PainOrder{}, fmt.Errorf("%w: say who to call and when",
			ErrInvalidRecord)
	}

	return PainOrder{
		ID: id, TenantID: tenantID, RecordID: strings.TrimSpace(in.RecordID),
		PatientID:       strings.TrimSpace(in.PatientID),
		EncounterID:     strings.TrimSpace(in.EncounterID),
		Modality:        strings.TrimSpace(in.Modality),
		PrescriptionIDs: trimmedAll(in.PrescriptionIDs),
		TargetScore:     strings.TrimSpace(in.TargetScore),
		Monitoring:      trimmedAll(in.Monitoring),
		Escalation:      strings.TrimSpace(in.Escalation),
		ReviewBy:        in.ReviewBy.UTC(),
		OrderedBy:       strings.TrimSpace(by), OrderedAt: now.UTC(),
	}, nil
}

// Running reports whether the plan is still in force.
func (p PainOrder) Running() bool { return p.StoppedAt.IsZero() }

// ReviewOverdue reports a plan past its review time.
func (p PainOrder) ReviewOverdue(now time.Time) bool {
	return p.Running() && !p.ReviewBy.IsZero() && now.After(p.ReviewBy)
}

// Summary is the anaesthetic summary (SRS-ANE-010).
//
// Derived rather than written. The requirement's clause is "generate
// anaesthesia summary from signed source data", and a summary somebody typed
// separately is a second account that disagrees with the record by the time
// anybody reads it.
type Summary struct {
	RecordID  string
	CaseID    string
	PatientID string

	Technique Technique
	ASAGrade  ASA
	StartedAt time.Time
	EndedAt   time.Time

	Airway DifficultAirway
	// KeyDrugs are the entries a summary reader looks for: reversal agents,
	// vasopressors, antibiotics. Chosen by the caller, because which drugs
	// matter is a deployment's decision.
	KeyDrugs []DrugEntry
	Fluids   FluidBalance
	// Events are the intraoperative entries somebody flagged. Not every value:
	// a summary of a four-hour case cannot be a thousand readings.
	Events []string

	Recovery *RecoveryAssessment
	Disposal string
	// Overridden marks a recovery discharge below the threshold, which is the
	// one thing a summary reader must not have to dig for.
	DischargeOverridden bool
	OverrideReason      string

	// Incomplete names what the summary could not be built from. A summary
	// that quietly omitted the recovery score would read as a patient who was
	// never scored.
	Incomplete []string
}

// BuildSummary derives the anaesthetic summary (SRS-ANE-010).
func BuildSummary(record Record, assessment *Assessment, airway []AirwayEvent,
	keyDrugs []DrugEntry, fluids []FluidEntry, events []string,
	assessments []RecoveryAssessment, discharge *Discharge) Summary {

	out := Summary{
		RecordID: record.ID, CaseID: record.CaseID, PatientID: record.PatientID,
		Technique: record.Technique,
		StartedAt: record.StartedAt, EndedAt: record.EndedAt,
		Airway:   SummariseAirway(airway),
		KeyDrugs: keyDrugs,
		Fluids:   Balance(fluids),
		Events:   events,
	}

	if assessment != nil {
		out.ASAGrade = assessment.ASAGrade
	} else {
		out.Incomplete = append(out.Incomplete, "pre-anaesthesia assessment")
	}

	var latest *RecoveryAssessment
	for i := range assessments {
		if latest == nil || assessments[i].AssessedAt.After(latest.AssessedAt) {
			latest = &assessments[i]
		}
	}
	if latest != nil {
		out.Recovery = latest
	} else {
		out.Incomplete = append(out.Incomplete, "recovery score")
	}

	if discharge != nil {
		out.Disposal = discharge.Destination
		out.DischargeOverridden = discharge.Overridden
		out.OverrideReason = discharge.OverrideReason
	} else {
		out.Incomplete = append(out.Incomplete, "recovery discharge")
	}

	if record.EndedAt.IsZero() {
		out.Incomplete = append(out.Incomplete, "end of anaesthesia")
	}

	sort.Strings(out.Incomplete)
	return out
}

// Duration is how long the anaesthetic lasted, and whether it has ended.
func (r Record) Duration() (time.Duration, bool) {
	if r.EndedAt.IsZero() {
		return 0, false
	}
	return r.EndedAt.Sub(r.StartedAt), true
}

// End closes the anaesthetic.
func (r *Record) End(at time.Time) error {
	if !r.EndedAt.IsZero() {
		return fmt.Errorf("%w: this anaesthetic has already ended", ErrInvalidRecord)
	}
	if at.Before(r.StartedAt) {
		return fmt.Errorf("%w: the anaesthetic ended before it started",
			ErrInvalidRecord)
	}
	r.EndedAt, r.Status = at.UTC(), RecordInRecovery
	return nil
}

// Close closes the record once the patient has left recovery.
func (r *Record) Close(at time.Time) error {
	if r.Status == RecordClosed {
		return fmt.Errorf("%w: this record is already closed", ErrInvalidRecord)
	}
	if r.EndedAt.IsZero() {
		return fmt.Errorf("%w: the anaesthetic has not ended", ErrInvalidRecord)
	}
	r.Status = RecordClosed
	return nil
}
