package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Encounter diagnoses and the rules for finalising a visit
// (SRS-ENC-007, SRS-ENC-008).

// DiagnosisCertainty is how sure the clinician is (SRS-ENC-007).
//
// Certainty and rank are kept as two fields rather than one enumeration,
// because "provisional" and "primary" answer different questions — how sure,
// and how central. A single list would force a clinician to choose between
// saying they are unsure and saying this is what the visit was about.
type DiagnosisCertainty string

const (
	// CertaintyProvisional is a working diagnosis. Most of what is recorded
	// during an admission is provisional, and a system that made everything
	// final would produce a discharge summary full of conditions nobody
	// confirmed.
	CertaintyProvisional  DiagnosisCertainty = "provisional"
	CertaintyDifferential DiagnosisCertainty = "differential"
	CertaintyFinal        DiagnosisCertainty = "final"
	// CertaintyRuledOut records that something was considered and excluded.
	// Worth keeping: the next clinician needs to know the question was asked.
	CertaintyRuledOut DiagnosisCertainty = "ruled_out"
)

var knownCertainties = map[DiagnosisCertainty]bool{
	CertaintyProvisional: true, CertaintyDifferential: true,
	CertaintyFinal: true, CertaintyRuledOut: true,
}

// DiagnosisRank is how central a diagnosis is to this encounter.
type DiagnosisRank string

const (
	// RankPrimary is the reason the patient is here. At most one per encounter,
	// because the whole point of the rank is to answer "what was this visit
	// about" with one answer.
	RankPrimary   DiagnosisRank = "primary"
	RankSecondary DiagnosisRank = "secondary"
	// RankComplication arose during the encounter rather than causing it.
	// Distinguished because a complication is a quality signal and a secondary
	// diagnosis is not, and counting them together hides harm.
	RankComplication DiagnosisRank = "complication"
	// RankComorbidity was already present and affects management.
	RankComorbidity DiagnosisRank = "comorbidity"
)

var knownRanks = map[DiagnosisRank]bool{
	RankPrimary: true, RankSecondary: true,
	RankComplication: true, RankComorbidity: true,
}

// Coding is a coded concept from a terminology.
//
// System and code together, never code alone: "C50" means breast cancer in
// ICD-10 and something else in a local scheme, and a code with no system is a
// number nobody can safely act on. Display is carried alongside because a
// terminology server is not always reachable and a screen showing a bare code
// is a screen clinicians stop reading.
type Coding struct {
	// System is the terminology's identifier — "icd-10", "snomed-ct".
	System string
	// Version pins the release. ICD-10 codes have been reassigned between
	// revisions, so a code with no version is ambiguous once a decade.
	Version string
	Code    string
	Display string
}

// Validate rejects a coding that could not be acted on.
func (c Coding) Validate() error {
	switch {
	case strings.TrimSpace(c.System) == "":
		return fmt.Errorf("%w: a code needs the terminology it came from",
			ErrInvalidEncounter)
	case strings.TrimSpace(c.Code) == "":
		return fmt.Errorf("%w: a coding needs a code", ErrInvalidEncounter)
	case strings.TrimSpace(c.Display) == "":
		// A bare code on a screen is a screen clinicians stop reading.
		return fmt.Errorf("%w: a coding needs a display term", ErrInvalidEncounter)
	}
	return nil
}

// Empty reports a coding nobody filled in.
func (c Coding) Empty() bool {
	return strings.TrimSpace(c.System) == "" && strings.TrimSpace(c.Code) == ""
}

// Diagnosis is one condition recorded against one encounter (SRS-ENC-007).
//
// Append-only. The acceptance criterion is that "diagnosis history and
// author/time retained", so a change of mind is a new row that supersedes the
// old one rather than an edit: a differential that became a final diagnosis is
// a clinical reasoning trail, and overwriting it destroys the only evidence
// that the reasoning happened.
type Diagnosis struct {
	ID          string
	TenantID    string
	EncounterID string
	PatientID   string
	Code        Coding
	Certainty   DiagnosisCertainty
	Rank        DiagnosisRank
	// Note is the clinician's qualification of the code — "left side", "since
	// 2019". Short: the reasoning belongs in the note, which has its own
	// access rules.
	Note string
	// OnsetAt is when the condition began, where known. Distinct from
	// RecordedAt, which is when somebody typed it: a diagnosis of an illness
	// that started last month is not a diagnosis made last month.
	OnsetAt time.Time

	// SupersededByID chains to the entry that replaced this one, so the trail
	// reads forwards.
	SupersededByID string
	// RetractedReason marks an entry recorded in error. Distinct from
	// superseded: superseded means the thinking moved on, retracted means this
	// was never true of this patient.
	RetractedReason string

	RecordedBy string
	RecordedAt time.Time
}

// MaxDiagnosisNoteLength bounds the qualifier.
const MaxDiagnosisNoteLength = 300

// NewDiagnosis validates and constructs a diagnosis entry.
func NewDiagnosis(id, tenantID, encounterID, patientID string, code Coding,
	certainty DiagnosisCertainty, rank DiagnosisRank, note string,
	onsetAt time.Time, recordedBy string, now time.Time) (Diagnosis, error) {

	note = strings.TrimSpace(note)

	switch {
	case strings.TrimSpace(id) == "":
		return Diagnosis{}, fmt.Errorf("%w: diagnosis id is required", ErrInvalidEncounter)
	case strings.TrimSpace(encounterID) == "":
		return Diagnosis{}, fmt.Errorf("%w: a diagnosis needs an encounter",
			ErrInvalidEncounter)
	case strings.TrimSpace(patientID) == "":
		return Diagnosis{}, fmt.Errorf("%w: a diagnosis needs a patient", ErrInvalidEncounter)
	case !knownCertainties[certainty]:
		return Diagnosis{}, fmt.Errorf("%w: unknown diagnosis certainty %q",
			ErrInvalidEncounter, certainty)
	case !knownRanks[rank]:
		return Diagnosis{}, fmt.Errorf("%w: unknown diagnosis rank %q",
			ErrInvalidEncounter, rank)
	case strings.TrimSpace(recordedBy) == "":
		return Diagnosis{}, fmt.Errorf("%w: a diagnosis must record its author",
			ErrInvalidEncounter)
	case len(note) > MaxDiagnosisNoteLength:
		return Diagnosis{}, fmt.Errorf("%w: the note is longer than %d characters",
			ErrInvalidEncounter, MaxDiagnosisNoteLength)
	}
	if err := code.Validate(); err != nil {
		return Diagnosis{}, err
	}
	if !onsetAt.IsZero() && onsetAt.After(now) {
		return Diagnosis{}, fmt.Errorf("%w: a condition cannot have begun in the future",
			ErrInvalidEncounter)
	}

	return Diagnosis{
		ID: id, TenantID: tenantID, EncounterID: encounterID, PatientID: patientID,
		Code: code, Certainty: certainty, Rank: rank, Note: note,
		OnsetAt: onsetAt.UTC(), RecordedBy: recordedBy, RecordedAt: now.UTC(),
	}, nil
}

// Live reports a diagnosis that still stands.
func (d Diagnosis) Live() bool {
	return d.SupersededByID == "" && d.RetractedReason == ""
}

// DiagnosisList is an encounter's recorded diagnoses, in recording order.
type DiagnosisList []Diagnosis

// Live returns the entries that still stand, newest first.
func (l DiagnosisList) Live() DiagnosisList {
	out := make(DiagnosisList, 0, len(l))
	for _, d := range l {
		if d.Live() {
			out = append(out, d)
		}
	}
	sort.SliceStable(out, func(i, j int) bool {
		return out[i].RecordedAt.After(out[j].RecordedAt)
	})
	return out
}

// Primary returns the live primary diagnosis, if one has been recorded.
//
// At most one stands at a time: the rank answers "what was this visit about",
// and two answers is no answer. Recording a second supersedes the first rather
// than being refused, because a clinician correcting the primary diagnosis is
// doing the right thing and should not have to retract it first.
func (l DiagnosisList) Primary() (Diagnosis, bool) {
	for _, d := range l.Live() {
		if d.Rank == RankPrimary {
			return d, true
		}
	}
	return Diagnosis{}, false
}

// HasFinal reports whether any diagnosis has been finalised, which is what
// closing an encounter usually waits for.
func (l DiagnosisList) HasFinal() bool {
	for _, d := range l.Live() {
		if d.Certainty == CertaintyFinal {
			return true
		}
	}
	return false
}
