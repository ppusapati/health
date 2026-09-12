package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Finalisation gating and the visit summary (SRS-ENC-008, SRS-ENC-009).
//
// SRS-ENC-008 is the interesting one: refuse to finalise an encounter whose
// mandatory documentation is incomplete, "with emergency override where policy
// allows", listing the blocking items and auditing the override reason.
//
// The design turns on one judgement. A hard block with no way through does not
// produce complete records; it produces encounters left open for months, which
// is worse, because an open encounter looks like a patient still under care.
// So the gate blocks by default, names exactly what is missing, and can be
// overridden by somebody who says why — and the override is the thing quality
// teams report on.

// DocumentationItem is one thing a facility requires before an encounter can be
// closed.
type DocumentationItem string

const (
	// DocFinalDiagnosis requires at least one diagnosis marked final. The
	// commonest requirement, and the one a discharge summary is useless
	// without.
	DocFinalDiagnosis DocumentationItem = "final_diagnosis"
	// DocSignedNote requires a signed clinical note (SRS-CLN-008/009).
	DocSignedNote DocumentationItem = "signed_note"
	// DocAttendingProvider requires a named responsible clinician.
	DocAttendingProvider DocumentationItem = "attending_provider"
	// DocEndTime requires the clinical end time, which billing and length-of-
	// stay reporting both depend on.
	DocEndTime DocumentationItem = "end_time"
	// DocDischargeDisposition requires where an inpatient went — home, another
	// hospital, mortuary. A discharge with no destination is a patient the
	// record loses track of.
	DocDischargeDisposition DocumentationItem = "discharge_disposition"
)

var knownDocumentationItems = map[DocumentationItem]bool{
	DocFinalDiagnosis: true, DocSignedNote: true, DocAttendingProvider: true,
	DocEndTime: true, DocDischargeDisposition: true,
}

// Description is what a clinician is told is missing.
//
// Written as the action they need to take rather than the rule they broke. A
// message saying "final_diagnosis missing" sends somebody to the manual;
// "record a final diagnosis" sends them to the right screen.
func (d DocumentationItem) Description() string {
	switch d {
	case DocFinalDiagnosis:
		return "record a final diagnosis"
	case DocSignedNote:
		return "sign a clinical note"
	case DocAttendingProvider:
		return "name the attending provider"
	case DocEndTime:
		return "record when the encounter ended"
	case DocDischargeDisposition:
		return "record the discharge disposition"
	default:
		return string(d)
	}
}

// ClosurePolicy is what a facility requires before an encounter is closed
// (SRS-ENC-008).
type ClosurePolicy struct {
	// Required lists the items that must be present, per encounter class. A
	// class absent from the map requires nothing, which is a real
	// configuration: a diagnostic-only visit has no consultation to document.
	Required map[Class][]DocumentationItem
	// AllowOverride permits finalising over an incomplete record with a stated
	// reason. Per class, because the judgement differs: an emergency department
	// that cannot close a resuscitation until the notes are perfect will simply
	// leave it open, and an open encounter reads as a patient still under care.
	AllowOverride map[Class]bool
}

// DefaultClosurePolicy is what a tenant that has configured nothing gets.
//
// Deliberately modest. A default that demanded everything would be switched off
// on the first busy Friday; one that demanded nothing would let a hospital run
// for a year before discovering that half its discharge summaries have no
// diagnosis. Override is allowed only for emergency encounters, because that is
// the setting where the requirement's own "where policy allows" clause is
// aimed.
func DefaultClosurePolicy() ClosurePolicy {
	common := []DocumentationItem{DocFinalDiagnosis, DocEndTime, DocAttendingProvider}
	return ClosurePolicy{
		Required: map[Class][]DocumentationItem{
			ClassOutpatient:   common,
			ClassEmergency:    common,
			ClassDayCare:      common,
			ClassTelemedicine: common,
			ClassHomeCare:     common,
			ClassInpatient: append(append([]DocumentationItem{}, common...),
				DocSignedNote, DocDischargeDisposition),
			// A walk-in for an X-ray has no consultation to document. The
			// result belongs to the diagnostic service and arrives on its own
			// schedule.
			ClassDiagnosticOnly: nil,
		},
		AllowOverride: map[Class]bool{ClassEmergency: true},
	}
}

// Validate rejects a policy that could not be applied.
func (p ClosurePolicy) Validate() error {
	for class, items := range p.Required {
		if !class.Known() {
			return fmt.Errorf("%w: unknown encounter class %q in closure policy",
				ErrInvalidEncounter, class)
		}
		for _, item := range items {
			if !knownDocumentationItems[item] {
				return fmt.Errorf("%w: unknown documentation item %q",
					ErrInvalidEncounter, item)
			}
		}
	}
	for class := range p.AllowOverride {
		if !class.Known() {
			return fmt.Errorf("%w: unknown encounter class %q in closure policy",
				ErrInvalidEncounter, class)
		}
	}
	return nil
}

// PermitsOverride reports whether an incomplete encounter of this class may be
// closed with a stated reason.
func (p ClosurePolicy) PermitsOverride(class Class) bool { return p.AllowOverride[class] }

// DocumentationState is what the encounter actually has, gathered by the caller
// from the contexts that own each fact.
//
// A struct of booleans rather than the records themselves: the clinical context
// owns notes, and the encounter context asking it "is there a signed note"
// keeps the seam narrow. Handing this context the note would put clinical
// content in a container that has weaker access rules than the content does.
type DocumentationState struct {
	HasFinalDiagnosis       bool
	HasSignedNote           bool
	HasAttendingProvider    bool
	HasEndTime              bool
	HasDischargeDisposition bool
}

// has reports one item.
func (s DocumentationState) has(item DocumentationItem) bool {
	switch item {
	case DocFinalDiagnosis:
		return s.HasFinalDiagnosis
	case DocSignedNote:
		return s.HasSignedNote
	case DocAttendingProvider:
		return s.HasAttendingProvider
	case DocEndTime:
		return s.HasEndTime
	case DocDischargeDisposition:
		return s.HasDischargeDisposition
	default:
		// An item this version does not know cannot be reported present. The
		// safe answer for an unrecognised requirement is that it is unmet:
		// blocking a closure is recoverable, and silently waving one through
		// is not.
		return false
	}
}

// ErrIncompleteDocumentation reports a closure refused because something is
// missing, and names every missing thing.
//
// Every one, not the first: a clinician told about one item, who fixes it and
// is then told about another, is a clinician who stops trusting the message.
type ErrIncompleteDocumentation struct {
	Missing []DocumentationItem
	// Overridable reports whether policy would allow this to be forced with a
	// stated reason, so a UI can offer the right action rather than a dead end.
	Overridable bool
}

func (e ErrIncompleteDocumentation) Error() string {
	actions := make([]string, 0, len(e.Missing))
	for _, item := range e.Missing {
		actions = append(actions, item.Description())
	}
	return "encounter: this encounter cannot be closed until you " +
		strings.Join(actions, ", ")
}

// CheckClosure reports whether an encounter may be finalised (SRS-ENC-008).
func (p ClosurePolicy) CheckClosure(class Class, state DocumentationState) error {
	var missing []DocumentationItem
	for _, item := range p.Required[class] {
		if !state.has(item) {
			missing = append(missing, item)
		}
	}
	if len(missing) == 0 {
		return nil
	}
	sort.Slice(missing, func(i, j int) bool { return missing[i] < missing[j] })
	return ErrIncompleteDocumentation{Missing: missing, Overridable: p.PermitsOverride(class)}
}

// ClosureOverride records a finalisation forced over an incomplete record.
//
// Stored, not just audited. The audit trail answers "who did this"; this
// answers "how often does this happen and for what", which is the question a
// quality committee asks and the reason SRS-ENC-008 exists.
type ClosureOverride struct {
	ID          string
	TenantID    string
	EncounterID string
	// Missing is what was outstanding at the moment of the override, captured
	// then rather than recomputed later: the items are usually completed
	// afterwards, and a report that recomputed would show every override as
	// having overridden nothing.
	Missing      []DocumentationItem
	Reason       string
	OverriddenBy string
	OverriddenAt time.Time
}

// MinOverrideReasonLength stops "ok" from counting as a reason.
//
// A crude rule, and a deliberate one: the alternative is a free-text field that
// fills up with single characters, which is indistinguishable from no control
// at all.
const MinOverrideReasonLength = 10

// NewClosureOverride validates and constructs the record of a forced closure.
func NewClosureOverride(id, tenantID, encounterID string, missing []DocumentationItem,
	reason, by string, now time.Time) (ClosureOverride, error) {

	reason = strings.TrimSpace(reason)

	switch {
	case strings.TrimSpace(id) == "":
		return ClosureOverride{}, fmt.Errorf("%w: override id is required", ErrInvalidEncounter)
	case strings.TrimSpace(by) == "":
		return ClosureOverride{}, fmt.Errorf("%w: an override must record who made it",
			ErrInvalidEncounter)
	case len(reason) < MinOverrideReasonLength:
		return ClosureOverride{}, fmt.Errorf(
			"%w: closing an incomplete encounter needs a reason of at least %d characters",
			ErrInvalidEncounter, MinOverrideReasonLength)
	case len(missing) == 0:
		// Nothing was blocking, so there is nothing to override. Recording one
		// anyway would put a false entry in the report that exists to count
		// real ones.
		return ClosureOverride{}, fmt.Errorf(
			"%w: nothing was blocking this closure", ErrInvalidEncounter)
	}

	return ClosureOverride{
		ID: id, TenantID: tenantID, EncounterID: encounterID,
		Missing: missing, Reason: reason, OverriddenBy: by, OverriddenAt: now.UTC(),
	}, nil
}

// VisitSummary is what closing an encounter produces (SRS-ENC-009).
//
// Generated from signed data at the moment of closure and stored, rather than
// rendered on demand. The difference matters: a summary rendered on demand
// shows today's chart, so a patient handed a printout in March and a clinician
// looking at the same "summary" in June see different documents with the same
// name. SRS-ENC-009 requires that a closed encounter's chronology cannot be
// silently rewritten, and a stored artefact is what makes "silently" impossible
// — a later change is an amendment, visible as one.
type VisitSummary struct {
	ID          string
	TenantID    string
	EncounterID string
	PatientID   string
	// Version starts at 1 and increments with each amendment. The original is
	// never replaced.
	Version int
	// SupersedesID chains to the version this one amends.
	SupersedesID string
	// AmendmentReason is why a new version exists. Empty on version 1.
	AmendmentReason string

	Class     Class
	StartedAt time.Time
	EndedAt   time.Time
	Diagnoses []Coding
	CareTeam  []string
	// Narrative is the summary text, assembled by the caller from signed
	// content. Held rather than referenced so the document survives a later
	// edit of its sources.
	Narrative string

	GeneratedBy string
	GeneratedAt time.Time
}

// NewVisitSummary validates and constructs the first version of a summary.
func NewVisitSummary(id, tenantID string, e *Encounter, diagnoses []Coding,
	careTeam []string, narrative, by string, now time.Time) (VisitSummary, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return VisitSummary{}, fmt.Errorf("%w: summary id is required", ErrInvalidEncounter)
	case e == nil:
		return VisitSummary{}, fmt.Errorf("%w: a summary needs an encounter",
			ErrInvalidEncounter)
	case strings.TrimSpace(by) == "":
		return VisitSummary{}, fmt.Errorf("%w: a summary must record who generated it",
			ErrInvalidEncounter)
	}

	return VisitSummary{
		ID: id, TenantID: tenantID, EncounterID: e.ID(), PatientID: e.PatientID,
		Version: 1, Class: e.Class,
		StartedAt: e.StartedAt, EndedAt: e.EndedAt,
		Diagnoses: diagnoses, CareTeam: careTeam,
		Narrative:   strings.TrimSpace(narrative),
		GeneratedBy: by, GeneratedAt: now.UTC(),
	}, nil
}

// Amend produces the next version of a summary (SRS-ENC-009).
//
// A new document rather than an edit. The previous version stays readable and
// says what was believed at the time, which is the whole point: somebody acted
// on it.
func (s VisitSummary) Amend(id, narrative, reason, by string, now time.Time) (
	VisitSummary, error) {

	reason = strings.TrimSpace(reason)
	if strings.TrimSpace(id) == "" {
		return VisitSummary{}, fmt.Errorf("%w: summary id is required", ErrInvalidEncounter)
	}
	if reason == "" {
		// An amendment with no reason is indistinguishable from a rewrite, and
		// a rewrite is what SRS-ENC-009 forbids.
		return VisitSummary{}, fmt.Errorf("%w: an amendment needs a reason",
			ErrInvalidEncounter)
	}
	if strings.TrimSpace(by) == "" {
		return VisitSummary{}, fmt.Errorf("%w: an amendment must record its author",
			ErrInvalidEncounter)
	}

	next := s
	next.ID = id
	next.Version = s.Version + 1
	next.SupersedesID = s.ID
	next.AmendmentReason = reason
	next.Narrative = strings.TrimSpace(narrative)
	next.GeneratedBy = by
	next.GeneratedAt = now.UTC()
	return next, nil
}
