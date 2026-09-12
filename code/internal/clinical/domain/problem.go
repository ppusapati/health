package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// The problem list and allergies (SRS-CLN-003, SRS-CLN-004).

// Coding is a coded concept from a terminology.
//
// The same shape as the encounter context's, and deliberately duplicated rather
// than imported: a shared type between two bounded contexts is a shared
// dependency that makes them one context the first time either needs to change
// it. The cost is a mapping at the seam; the alternative is a monolith with two
// package names.
type Coding struct {
	System  string
	Version string
	Code    string
	Display string
}

// Validate rejects a coding that could not be acted on.
func (c Coding) Validate() error {
	switch {
	case strings.TrimSpace(c.System) == "":
		return fmt.Errorf("%w: a code needs the terminology it came from", ErrInvalidDocument)
	case strings.TrimSpace(c.Code) == "":
		return fmt.Errorf("%w: a coding needs a code", ErrInvalidDocument)
	case strings.TrimSpace(c.Display) == "":
		return fmt.Errorf("%w: a coding needs a display term", ErrInvalidDocument)
	}
	return nil
}

// Empty reports a coding nobody filled in.
func (c Coding) Empty() bool {
	return strings.TrimSpace(c.System) == "" && strings.TrimSpace(c.Code) == ""
}

// ProblemStatus is where a condition stands on the problem list
// (SRS-CLN-003).
type ProblemStatus string

const (
	ProblemActive ProblemStatus = "active"
	// ProblemRemission is neither active nor resolved, and the distinction is
	// clinical: a cancer in remission is not a cancer that has gone.
	ProblemRemission ProblemStatus = "remission"
	// ProblemResolved has ended. Kept on the list as historical, because the
	// criterion is explicit that "resolved problem remains historical" — a
	// problem list that forgot a resolved myocardial infarction would hide the
	// single most important fact about the patient in front of you.
	ProblemResolved ProblemStatus = "resolved"
	// ProblemInactive is dormant rather than resolved.
	ProblemInactive ProblemStatus = "inactive"
	// ProblemEnteredInError was never true of this patient.
	ProblemEnteredInError ProblemStatus = "entered_in_error"
)

var knownProblemStatuses = map[ProblemStatus]bool{
	ProblemActive: true, ProblemRemission: true, ProblemResolved: true,
	ProblemInactive: true, ProblemEnteredInError: true,
}

// Problem is one entry on the patient's problem list.
type Problem struct {
	ID        string
	TenantID  string
	PatientID string
	// EncounterID is where it was first recorded. A problem outlives the
	// encounter that found it — that is what makes it a problem list rather
	// than a diagnosis list — so this is provenance, not ownership.
	EncounterID string
	Code        Coding
	// Note is the clinician's qualification: "left side", "since 2019".
	Note   string
	Status ProblemStatus
	// OnsetAt is when the condition began, where known.
	OnsetAt time.Time
	// ResolvedAt is when it ended. Set only for resolved.
	ResolvedAt time.Time
	// Confidentiality applies to the problem too: a diagnosis of HIV on an
	// unrestricted problem list is visible on every screen in the hospital.
	Confidentiality Confidentiality

	RecordedBy string
	RecordedAt time.Time
	UpdatedBy  string
	UpdatedAt  time.Time
	Version    int64
}

// MaxNoteLength bounds a qualifier.
const MaxNoteLength = 300

// NewProblem validates and constructs a problem-list entry.
func NewProblem(id, tenantID, patientID, encounterID string, code Coding, note string,
	status ProblemStatus, onsetAt time.Time, confidentiality Confidentiality,
	recordedBy string, now time.Time) (Problem, error) {

	note = strings.TrimSpace(note)

	switch {
	case strings.TrimSpace(id) == "":
		return Problem{}, fmt.Errorf("%w: problem id is required", ErrInvalidDocument)
	case strings.TrimSpace(patientID) == "":
		return Problem{}, fmt.Errorf("%w: a problem needs a patient", ErrInvalidDocument)
	case !knownProblemStatuses[status]:
		return Problem{}, fmt.Errorf("%w: unknown problem status %q", ErrInvalidDocument, status)
	case strings.TrimSpace(recordedBy) == "":
		return Problem{}, fmt.Errorf("%w: a problem must record its author", ErrInvalidDocument)
	case len(note) > MaxNoteLength:
		return Problem{}, fmt.Errorf("%w: the note is longer than %d characters",
			ErrInvalidDocument, MaxNoteLength)
	case !confidentiality.Known():
		return Problem{}, fmt.Errorf("%w: unknown confidentiality class %q",
			ErrInvalidDocument, confidentiality)
	}
	if err := code.Validate(); err != nil {
		return Problem{}, err
	}
	if !onsetAt.IsZero() && onsetAt.After(now) {
		return Problem{}, fmt.Errorf("%w: a condition cannot have begun in the future",
			ErrInvalidDocument)
	}

	return Problem{
		ID: id, TenantID: tenantID, PatientID: patientID, EncounterID: encounterID,
		Code: code, Note: note, Status: status, OnsetAt: onsetAt.UTC(),
		Confidentiality: confidentiality,
		RecordedBy:      recordedBy, RecordedAt: now.UTC(),
		UpdatedBy: recordedBy, UpdatedAt: now.UTC(), Version: 1,
	}, nil
}

// Resolve marks a problem as ended (SRS-CLN-003).
//
// It stays on the list. A resolved problem is history, not an absence.
func (p *Problem) Resolve(at time.Time, by string, now time.Time) error {
	if p.Status == ProblemEnteredInError {
		return fmt.Errorf("%w: a retracted problem cannot be resolved", ErrInvalidDocument)
	}
	if at.IsZero() {
		at = now
	}
	if !p.OnsetAt.IsZero() && at.Before(p.OnsetAt) {
		return fmt.Errorf("%w: a problem cannot resolve before it began", ErrInvalidDocument)
	}

	p.Status = ProblemResolved
	p.ResolvedAt = at.UTC()
	p.UpdatedBy = by
	p.UpdatedAt = now.UTC()
	return nil
}

// SetStatus moves a problem between active, remission and inactive.
func (p *Problem) SetStatus(status ProblemStatus, by string, now time.Time) error {
	if !knownProblemStatuses[status] {
		return fmt.Errorf("%w: unknown problem status %q", ErrInvalidDocument, status)
	}
	if status == ProblemResolved {
		return fmt.Errorf("%w: resolving a problem records when it ended; use Resolve",
			ErrInvalidDocument)
	}

	p.Status = status
	if status != ProblemResolved {
		p.ResolvedAt = time.Time{}
	}
	p.UpdatedBy = by
	p.UpdatedAt = now.UTC()
	return nil
}

// ProblemList is a patient's problems.
type ProblemList []Problem

// Active returns the problems that still need managing, newest onset first.
func (l ProblemList) Active() ProblemList {
	out := make(ProblemList, 0, len(l))
	for _, p := range l {
		if p.Status == ProblemActive || p.Status == ProblemRemission {
			out = append(out, p)
		}
	}
	sort.SliceStable(out, func(i, j int) bool {
		return out[i].RecordedAt.After(out[j].RecordedAt)
	})
	return out
}

// AllergyCriticality is how dangerous a reaction is expected to be
// (SRS-CLN-004).
type AllergyCriticality string

const (
	// CriticalityLow is an intolerance: unpleasant, not dangerous.
	CriticalityLow AllergyCriticality = "low"
	// CriticalityHigh could kill. Anaphylaxis.
	CriticalityHigh AllergyCriticality = "high"
	// CriticalityUnableToAssess is the honest answer when nobody knows, and it
	// is not the same as low. A system that defaulted an unassessed allergy to
	// low would tell a prescriber there is no danger when what it means is
	// that nobody has looked.
	CriticalityUnableToAssess AllergyCriticality = "unable_to_assess"
)

var knownCriticalities = map[AllergyCriticality]bool{
	CriticalityLow: true, CriticalityHigh: true, CriticalityUnableToAssess: true,
}

// AllergyVerification is how sure anybody is that the allergy is real.
type AllergyVerification string

const (
	// VerificationUnconfirmed is what the patient said. Most allergy records
	// are this, and recording it as confirmed would be a lie that a prescriber
	// acts on.
	VerificationUnconfirmed AllergyVerification = "unconfirmed"
	VerificationConfirmed   AllergyVerification = "confirmed"
	// VerificationRefuted was investigated and is not true. Kept rather than
	// deleted: the next clinician needs to know the question was asked and
	// settled, or they will ask the patient again and get the same wrong
	// answer.
	VerificationRefuted        AllergyVerification = "refuted"
	VerificationEnteredInError AllergyVerification = "entered_in_error"
)

var knownVerifications = map[AllergyVerification]bool{
	VerificationUnconfirmed: true, VerificationConfirmed: true,
	VerificationRefuted: true, VerificationEnteredInError: true,
}

// AllergyKind separates a true allergy from an intolerance.
//
// Clinically different, and confusing them is how a patient with mild nausea on
// codeine ends up unable to receive any opiate.
type AllergyKind string

const (
	AllergyTrue        AllergyKind = "allergy"
	AllergyIntolerance AllergyKind = "intolerance"
)

var knownAllergyKinds = map[AllergyKind]bool{AllergyTrue: true, AllergyIntolerance: true}

// Reaction is one manifestation of an allergy.
type Reaction struct {
	// Manifestation is what happened — "anaphylaxis", "rash".
	Manifestation Coding
	// Severity is how bad it was, which is not the same as criticality: a mild
	// past reaction to a drug can still carry a high criticality.
	Severity string
	// Note is a clinician's qualification.
	Note string
}

// Allergy is a recorded allergy or intolerance (SRS-CLN-004).
type Allergy struct {
	ID          string
	TenantID    string
	PatientID   string
	EncounterID string
	// Substance is what the patient reacts to. Coded because the whole point is
	// that medication decision support can check a prescription against it, and
	// free text cannot be checked.
	Substance    Coding
	Kind         AllergyKind
	Criticality  AllergyCriticality
	Verification AllergyVerification
	Reactions    []Reaction
	// OnsetAt is when it was first noticed, where known.
	OnsetAt time.Time
	// Note is free text for the parts a code cannot carry.
	Note string

	RecordedBy string
	RecordedAt time.Time
	UpdatedBy  string
	UpdatedAt  time.Time
	Version    int64
}

// NewAllergy validates and constructs an allergy record.
func NewAllergy(id, tenantID, patientID, encounterID string, substance Coding,
	kind AllergyKind, criticality AllergyCriticality, verification AllergyVerification,
	reactions []Reaction, onsetAt time.Time, note, recordedBy string,
	now time.Time) (Allergy, error) {

	note = strings.TrimSpace(note)

	switch {
	case strings.TrimSpace(id) == "":
		return Allergy{}, fmt.Errorf("%w: allergy id is required", ErrInvalidDocument)
	case strings.TrimSpace(patientID) == "":
		return Allergy{}, fmt.Errorf("%w: an allergy needs a patient", ErrInvalidDocument)
	case !knownAllergyKinds[kind]:
		return Allergy{}, fmt.Errorf("%w: unknown allergy kind %q", ErrInvalidDocument, kind)
	case !knownCriticalities[criticality]:
		return Allergy{}, fmt.Errorf("%w: unknown criticality %q", ErrInvalidDocument, criticality)
	case !knownVerifications[verification]:
		return Allergy{}, fmt.Errorf("%w: unknown verification status %q",
			ErrInvalidDocument, verification)
	case strings.TrimSpace(recordedBy) == "":
		return Allergy{}, fmt.Errorf("%w: an allergy must record its author",
			ErrInvalidDocument)
	case len(note) > MaxNoteLength:
		return Allergy{}, fmt.Errorf("%w: the note is longer than %d characters",
			ErrInvalidDocument, MaxNoteLength)
	}
	// Coded, because the acceptance criterion is that the allergy reaches
	// medication decision support, and free text cannot be checked against a
	// prescription.
	if err := substance.Validate(); err != nil {
		return Allergy{}, fmt.Errorf("%w: the substance must be coded so a prescription "+
			"can be checked against it", err)
	}

	return Allergy{
		ID: id, TenantID: tenantID, PatientID: patientID, EncounterID: encounterID,
		Substance: substance, Kind: kind, Criticality: criticality,
		Verification: verification, Reactions: reactions, OnsetAt: onsetAt.UTC(),
		Note: note, RecordedBy: recordedBy, RecordedAt: now.UTC(),
		UpdatedBy: recordedBy, UpdatedAt: now.UTC(), Version: 1,
	}, nil
}

// Active reports an allergy a prescriber must be warned about.
//
// Unconfirmed counts. A patient who says they are allergic to penicillin is a
// patient who should not be given penicillin without somebody deciding
// otherwise, and a system that only warned on confirmed allergies would be
// silent for most of the ones it knows about.
func (a Allergy) Active() bool {
	return a.Verification == VerificationUnconfirmed ||
		a.Verification == VerificationConfirmed
}

// SetVerification records that somebody investigated.
func (a *Allergy) SetVerification(verification AllergyVerification, by string,
	now time.Time) error {

	if !knownVerifications[verification] {
		return fmt.Errorf("%w: unknown verification status %q", ErrInvalidDocument, verification)
	}
	a.Verification = verification
	a.UpdatedBy = by
	a.UpdatedAt = now.UTC()
	return nil
}

// AllergyList is a patient's allergies.
type AllergyList []Allergy

// Active returns the ones a prescriber must be warned about, most dangerous
// first.
func (l AllergyList) Active() AllergyList {
	out := make(AllergyList, 0, len(l))
	for _, a := range l {
		if a.Active() {
			out = append(out, a)
		}
	}
	sort.SliceStable(out, func(i, j int) bool {
		left, right := criticalityRank(out[i].Criticality), criticalityRank(out[j].Criticality)
		if left != right {
			return left < right
		}
		return out[i].RecordedAt.After(out[j].RecordedAt)
	})
	return out
}

// criticalityRank orders allergies most dangerous first.
//
// Unable-to-assess ranks between high and low rather than last: nobody has
// looked, and burying it under the intolerances is how it stops being looked at.
func criticalityRank(c AllergyCriticality) int {
	switch c {
	case CriticalityHigh:
		return 0
	case CriticalityUnableToAssess:
		return 1
	case CriticalityLow:
		return 2
	default:
		return 3
	}
}

// HasHighCriticality reports an allergy that could kill, which is what a
// patient banner leads with (SRS-CLN-001).
func (l AllergyList) HasHighCriticality() bool {
	for _, a := range l.Active() {
		if a.Criticality == CriticalityHigh {
			return true
		}
	}
	return false
}
