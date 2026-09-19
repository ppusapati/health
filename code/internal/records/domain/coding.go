package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// CodeRole is what a code is doing on a coded record (SRS-MRD-003).
type CodeRole string

const (
	// CodePrincipalDiagnosis is the condition chiefly responsible for the
	// admission. Exactly one, which is what makes a coded episode groupable.
	CodePrincipalDiagnosis CodeRole = "principal_diagnosis"
	// CodeSecondaryDiagnosis is a comorbidity or complication.
	CodeSecondaryDiagnosis CodeRole = "secondary_diagnosis"
	// CodePrincipalProcedure is the main procedure performed.
	CodePrincipalProcedure CodeRole = "principal_procedure"
	CodeSecondaryProcedure CodeRole = "secondary_procedure"
	// CodeExternalCause is how an injury happened.
	CodeExternalCause CodeRole = "external_cause"
	// CodeMorphology qualifies a neoplasm diagnosis.
	CodeMorphology CodeRole = "morphology"
)

var knownCodeRole = map[CodeRole]bool{
	CodePrincipalDiagnosis: true, CodeSecondaryDiagnosis: true,
	CodePrincipalProcedure: true, CodeSecondaryProcedure: true,
	CodeExternalCause: true, CodeMorphology: true,
}

// Diagnosis reports the roles that are diagnoses rather than procedures.
func (r CodeRole) Diagnosis() bool {
	return r == CodePrincipalDiagnosis || r == CodeSecondaryDiagnosis ||
		r == CodeExternalCause || r == CodeMorphology
}

// PresentOnAdmission says whether a coded diagnosis was there on arrival
// (SRS-MRD-003).
//
// Its own field and three states rather than a boolean, because it decides
// whether a complication is the hospital's, and "nobody recorded" is a
// different fact from "no". A default of either direction would be a
// systematic bias in every complication rate computed from coded data.
type PresentOnAdmission string

const (
	POAYes           PresentOnAdmission = "yes"
	POANo            PresentOnAdmission = "no"
	POAUndetermined  PresentOnAdmission = "undetermined"
	POANotApplicable PresentOnAdmission = "not_applicable"
)

var knownPOA = map[PresentOnAdmission]bool{
	POAYes: true, POANo: true, POAUndetermined: true, POANotApplicable: true,
}

// AssignedCode is one code on a coded episode (SRS-MRD-003).
//
// There is no narrative field. A code carries its system, its value, its role
// and the identifier of the clinical document it was read from; what that
// document says stays in the clinical context, where a clinician wrote it and
// where nobody in health information management can change it.
type AssignedCode struct {
	System  string
	Version string
	Code    string
	// Display is the terminology's own label for the code, not a coder's
	// words about the patient. A coder who wants to say something says it in
	// a query, which goes back to the clinician.
	Display string

	Role     CodeRole
	Sequence int
	POA      PresentOnAdmission

	// SourceDocumentID is the clinical document the code was read from.
	// SRS-MRD-003's acceptance is that coder changes retain provenance, and
	// this is the half of provenance that says where a code came from; the
	// revision history below is the half that says who changed it.
	SourceDocumentID string
}

// CodingState is where a coded episode stands.
type CodingState string

const (
	CodingInProgress CodingState = "in_progress"
	// CodingQueried is waiting on a clinician's answer.
	CodingQueried CodingState = "queried"
	// CodingCoded is the coder's finished work, not yet checked.
	CodingCoded CodingState = "coded"
	// CodingFinal has been through the second read and is what leaves the
	// hospital.
	CodingFinal CodingState = "final"
)

// CodingRevision is one version of a coded episode (SRS-MRD-003).
//
// Append-only. A code changed after the episode was finalised — by an audit,
// by a query answered late — is a new revision that keeps the old one, not an
// edit. A hospital that cannot show what it billed under last quarter's codes
// cannot answer an audit of last quarter's billing.
type CodingRevision struct {
	Revision int
	Codes    []AssignedCode
	// Reason is why this revision exists. Required from revision 2 onwards:
	// the first is the coding, and every one after it is a change somebody
	// has to be able to question.
	Reason  string
	CodedBy string
	CodedAt time.Time
	State   CodingState
	// ReviewedBy is the second read where there was one.
	ReviewedBy string
	ReviewedAt time.Time
}

// CodedEpisode is one encounter's coding (SRS-MRD-003).
type CodedEpisode struct {
	ID       string
	TenantID string

	PatientID   string
	EncounterID string
	FacilityID  string

	// Revisions are append-only and ordered. The last is current.
	Revisions []CodingRevision

	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// Current is the revision in force.
func (e CodedEpisode) Current() (CodingRevision, bool) {
	if len(e.Revisions) == 0 {
		return CodingRevision{}, false
	}
	return e.Revisions[len(e.Revisions)-1], true
}

// State is where the episode stands.
func (e CodedEpisode) State() CodingState {
	current, ok := e.Current()
	if !ok {
		return CodingInProgress
	}
	return current.State
}

// StartCoding opens an episode for coding (SRS-MRD-003).
func StartCoding(id, tenantID, patientID, encounterID, facilityID,
	by string, now time.Time) (CodedEpisode, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return CodedEpisode{}, fmt.Errorf("%w: a coded episode needs an id",
			ErrInvalidRecord)
	case strings.TrimSpace(encounterID) == "":
		return CodedEpisode{}, fmt.Errorf(
			"%w: a coded episode names its encounter", ErrInvalidRecord)
	case strings.TrimSpace(patientID) == "":
		return CodedEpisode{}, fmt.Errorf(
			"%w: a coded episode names its patient", ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return CodedEpisode{}, fmt.Errorf("%w: an episode names its coder",
			ErrInvalidRecord)
	}
	return CodedEpisode{
		ID: id, TenantID: tenantID, PatientID: patientID,
		EncounterID: encounterID, FacilityID: facilityID,
		CreatedAt: now.UTC(), CreatedBy: by, Version: 1,
	}, nil
}

// AssignCodes records a coder's work as a new revision (SRS-MRD-003).
//
// Append-only by construction: the previous revision is kept whole and this
// adds one. A code that moved from principal to secondary between revisions
// is visible as a change somebody made, which is what "coder changes retain
// provenance" means.
func (e *CodedEpisode) AssignCodes(codes []AssignedCode, reason, by string,
	now time.Time) error {

	switch {
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: coding names its coder", ErrInvalidRecord)
	case e.State() == CodingFinal && strings.TrimSpace(reason) == "":
		// Re-coding a finalised episode changes what was reported and, where
		// the hospital codes for payment, what was billed.
		return fmt.Errorf(
			"%w: say why a finalised episode is being re-coded",
			ErrInvalidRecord)
	}

	checked, err := validateCodes(codes)
	if err != nil {
		return err
	}
	if len(e.Revisions) > 0 && strings.TrimSpace(reason) == "" {
		return fmt.Errorf("%w: say why the coding is changing",
			ErrInvalidRecord)
	}

	e.Revisions = append(e.Revisions, CodingRevision{
		Revision: len(e.Revisions) + 1, Codes: checked,
		Reason:  strings.TrimSpace(reason),
		CodedBy: by, CodedAt: now.UTC(), State: CodingCoded,
	})
	return nil
}

func validateCodes(codes []AssignedCode) ([]AssignedCode, error) {
	if len(codes) == 0 {
		return nil, fmt.Errorf("%w: an episode is coded with at least one code",
			ErrInvalidRecord)
	}

	principalDiagnoses, principalProcedures := 0, 0
	seen := map[string]bool{}
	out := make([]AssignedCode, 0, len(codes))

	for _, code := range codes {
		value := strings.TrimSpace(code.Code)
		system := strings.TrimSpace(code.System)
		switch {
		case value == "":
			return nil, fmt.Errorf("%w: a code needs a value",
				ErrInvalidRecord)
		case system == "":
			// A code with no system is a string. ICD-10 J18.9 and ICD-11
			// CA40.0 are both "pneumonia" and neither is the other.
			return nil, fmt.Errorf("%w: code %q names no terminology",
				ErrInvalidRecord, value)
		case strings.TrimSpace(code.Version) == "":
			// Terminologies are revised annually and codes move between
			// revisions. A coded episode that cannot say which edition it
			// was coded under cannot be re-grouped later.
			return nil, fmt.Errorf("%w: code %s %q names no edition",
				ErrInvalidRecord, system, value)
		case !knownCodeRole[code.Role]:
			return nil, fmt.Errorf("%w: unknown code role %q for %q",
				ErrInvalidRecord, code.Role, value)
		}

		key := strings.ToLower(system + "|" + value + "|" + string(code.Role))
		if seen[key] {
			return nil, fmt.Errorf("%w: %s %q appears twice as %s",
				ErrInvalidRecord, system, value, code.Role)
		}
		seen[key] = true

		switch code.Role {
		case CodePrincipalDiagnosis:
			principalDiagnoses++
		case CodePrincipalProcedure:
			principalProcedures++
		}

		poa := code.POA
		if code.Role.Diagnosis() {
			if !knownPOA[poa] {
				// Defaulting this either way would bias every
				// hospital-acquired complication rate computed from coded
				// data, in whichever direction the default fell.
				return nil, fmt.Errorf(
					"%w: diagnosis %q does not say whether it was present on "+
						"admission", ErrInvalidRecord, value)
			}
		} else if poa != "" && poa != POANotApplicable {
			return nil, fmt.Errorf(
				"%w: present-on-admission has no meaning for procedure %q",
				ErrInvalidRecord, value)
		} else {
			poa = POANotApplicable
		}

		out = append(out, AssignedCode{
			System: system, Version: strings.TrimSpace(code.Version),
			Code: value, Display: strings.TrimSpace(code.Display),
			Role: code.Role, Sequence: code.Sequence, POA: poa,
			SourceDocumentID: strings.TrimSpace(code.SourceDocumentID),
		})
	}

	switch {
	case principalDiagnoses == 0:
		return nil, fmt.Errorf(
			"%w: an episode names one principal diagnosis", ErrInvalidRecord)
	case principalDiagnoses > 1:
		// Two principal diagnoses is two answers to "why was this patient
		// admitted", and every grouper that reads it picks one arbitrarily.
		return nil, fmt.Errorf(
			"%w: %d principal diagnoses; an episode has one",
			ErrInvalidRecord, principalDiagnoses)
	case principalProcedures > 1:
		return nil, fmt.Errorf(
			"%w: %d principal procedures; an episode has at most one",
			ErrInvalidRecord, principalProcedures)
	}

	SortCodes(out)
	return out, nil
}

// SortCodes puts a revision's codes in the order a grouper reads them:
// principal diagnosis first, then the secondaries in their sequence, then
// the procedures.
//
// Exported because the persistence adapter has to restore this order after a
// round trip, and two definitions of "the order the codes are in" would
// diverge the first time somebody changed one. A coded episode whose
// principal diagnosis is not first is one a grouper reads differently from
// the way the coder meant it.
func SortCodes(codes []AssignedCode) {
	sort.SliceStable(codes, func(a, b int) bool {
		if codes[a].Role != codes[b].Role {
			return roleRank(codes[a].Role) < roleRank(codes[b].Role)
		}
		return codes[a].Sequence < codes[b].Sequence
	})
}

func roleRank(r CodeRole) int {
	switch r {
	case CodePrincipalDiagnosis:
		return 0
	case CodeSecondaryDiagnosis:
		return 1
	case CodeMorphology:
		return 2
	case CodeExternalCause:
		return 3
	case CodePrincipalProcedure:
		return 4
	default:
		return 5
	}
}

// Finalise records the second read that lets coding leave the hospital
// (SRS-MRD-003).
//
// Refused for the coder who did the work. Coded data is what a hospital is
// funded on and benchmarked by, and a second read by the same person is the
// same read.
func (e *CodedEpisode) Finalise(by string, now time.Time) error {
	current, ok := e.Current()
	switch {
	case !ok:
		return fmt.Errorf("%w: this episode has not been coded yet",
			ErrInvalidRecord)
	case current.State == CodingFinal:
		return fmt.Errorf("%w: this episode is already final", ErrInvalidRecord)
	case current.State == CodingQueried:
		return fmt.Errorf(
			"%w: a coding query is outstanding on this episode",
			ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a second read names who made it",
			ErrInvalidRecord)
	case by == current.CodedBy:
		return fmt.Errorf(
			"%w: the coder who assigned these codes cannot be the second read",
			ErrInvalidRecord)
	}

	current.State = CodingFinal
	current.ReviewedBy, current.ReviewedAt = by, now.UTC()
	e.Revisions[len(e.Revisions)-1] = current
	return nil
}

// Query marks an episode as waiting on a clinician (SRS-MRD-003).
//
// The question itself is a deficiency of kind DeficiencyCoding, owned by the
// clinician who can answer it. Held there rather than here so it appears on
// the same worklist as every other thing a clinician owes, and ages and
// escalates the same way.
func (e *CodedEpisode) Query(by string, now time.Time) error {
	current, ok := e.Current()
	switch {
	case !ok:
		return fmt.Errorf("%w: this episode has not been coded yet",
			ErrInvalidRecord)
	case current.State == CodingFinal:
		return fmt.Errorf(
			"%w: a finalised episode is re-coded rather than queried",
			ErrInvalidRecord)
	case current.State == CodingQueried:
		return fmt.Errorf("%w: a query is already outstanding",
			ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a query names who raised it", ErrInvalidRecord)
	}
	current.State = CodingQueried
	e.Revisions[len(e.Revisions)-1] = current
	_ = now
	return nil
}

// CodingChange is one difference between two revisions (SRS-MRD-003).
type CodingChange struct {
	System string
	Code   string
	// Was and Now are the roles. An empty Was is a code added; an empty Now
	// is one removed.
	Was CodeRole
	Now CodeRole
}

// Diff reports what changed between two revisions (SRS-MRD-003).
//
// The readable half of "coder changes retain provenance": the revisions hold
// the history and this says what moved. An audit asking why a case grouped
// differently this quarter gets an answer in codes rather than in two lists
// to compare by eye.
func Diff(before, after CodingRevision) []CodingChange {
	was := map[string]CodeRole{}
	for _, code := range before.Codes {
		was[key(code)] = code.Role
	}
	now := map[string]CodeRole{}
	for _, code := range after.Codes {
		now[key(code)] = code.Role
	}

	var out []CodingChange
	for id, role := range now {
		previous, existed := was[id]
		if existed && previous == role {
			continue
		}
		system, code := split(id)
		out = append(out, CodingChange{
			System: system, Code: code, Was: previous, Now: role,
		})
	}
	for id, role := range was {
		if _, still := now[id]; still {
			continue
		}
		system, code := split(id)
		out = append(out, CodingChange{System: system, Code: code, Was: role})
	}

	sort.Slice(out, func(a, b int) bool {
		if out[a].System != out[b].System {
			return out[a].System < out[b].System
		}
		return out[a].Code < out[b].Code
	})
	return out
}

func key(c AssignedCode) string { return c.System + "\x00" + c.Code }

func split(id string) (string, string) {
	parts := strings.SplitN(id, "\x00", 2)
	if len(parts) != 2 {
		return id, ""
	}
	return parts[0], parts[1]
}
