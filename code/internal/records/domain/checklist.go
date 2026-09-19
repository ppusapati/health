// Package domain holds the medical records and health information management
// rules (SRS-MRD-001 … 010).
//
// Nothing here reaches a database, a clock or a transport (FIT-01). Every
// refusal is a value a caller can act on rather than a panic.
//
// One property runs through the whole package and is worth stating once: this
// context never writes clinical content. It knows which documents exist, who
// signed them and when; it records what is missing, what was coded, what was
// released and what may be destroyed. The clinical text belongs to the
// clinical context and stays there. SRS-MRD-003 and SRS-MRD-008 both say so
// in their acceptance criteria, and the way to mean it is to hold no field
// that could carry a narrative and no port that could write one.
package domain

import (
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"
)

// ErrInvalidRecord reports a refused records-management action.
var ErrInvalidRecord = errors.New("records: invalid")

// DocumentRequirement is what a chart must contain (SRS-MRD-001).
type DocumentRequirement string

const (
	// RequirementSigned needs the document to exist and be signed.
	RequirementSigned DocumentRequirement = "signed"
	// RequirementPresent needs it to exist, signed or not — a filed
	// investigation report has no signature to wait for.
	RequirementPresent DocumentRequirement = "present"
	// RequirementConditional applies only when the caller says the condition
	// held: an operation note is required of an encounter that had an
	// operation and of no other.
	RequirementConditional DocumentRequirement = "conditional"
)

var knownRequirement = map[DocumentRequirement]bool{
	RequirementSigned: true, RequirementPresent: true,
	RequirementConditional: true,
}

// ChecklistItem is one line of a chart completion checklist (SRS-MRD-001).
type ChecklistItem struct {
	// Kind is the document kind, in the clinical context's vocabulary. A
	// string rather than an enum here, because the checklist is configured by
	// a hospital and the list of note kinds is that context's to own.
	Kind string
	// Label is what a deficiency worklist shows. "discharge_summary" is a
	// code; "Discharge summary" is what a consultant reads at seven in the
	// morning.
	Label       string
	Requirement DocumentRequirement
	// DueWithin is how long after the encounter ends the document is
	// expected. Zero means immediately, which is what an operation note is.
	DueWithin time.Duration
	// ConditionCode names the fact that makes a conditional item apply — the
	// caller answers it from the encounter. Required for a conditional item
	// and meaningless on the others.
	ConditionCode string
}

// ChartChecklist is what a class of encounter must contain (SRS-MRD-001).
//
// Versioned by (code, revision) and approved, like every other rule in this
// system that decides what a hospital is held to. A checklist edited in place
// would make every past deficiency report unexplainable: a chart that was
// complete in March and incomplete in June, with nothing to say which
// checklist judged it.
type ChartChecklist struct {
	ID       string
	TenantID string

	Code     string
	Name     string
	Revision int

	// EncounterClass and Specialty are what this checklist applies to. An
	// empty specialty matches every specialty of that class, which is how a
	// hospital writes one inpatient baseline and then overrides it for
	// obstetrics.
	EncounterClass string
	Specialty      string

	Items []ChecklistItem

	Approved   bool
	ApprovedBy string
	ApprovedAt time.Time

	EffectiveFrom time.Time
	SupersededAt  time.Time
	CreatedAt     time.Time
	CreatedBy     string
}

// Live reports a checklist in force at a moment.
func (c ChartChecklist) Live(at time.Time) bool {
	if !c.Approved {
		return false
	}
	if c.EffectiveFrom.IsZero() || c.EffectiveFrom.After(at) {
		return false
	}
	return c.SupersededAt.IsZero() || c.SupersededAt.After(at)
}

// Covers reports whether a checklist applies to an encounter.
func (c ChartChecklist) Covers(encounterClass, specialty string) bool {
	if !strings.EqualFold(c.EncounterClass, encounterClass) {
		return false
	}
	return c.Specialty == "" || strings.EqualFold(c.Specialty, specialty)
}

// NewChecklistInput configures a chart completion checklist.
type NewChecklistInput struct {
	Code           string
	Name           string
	Revision       int
	EncounterClass string
	Specialty      string
	Items          []ChecklistItem
	EffectiveFrom  time.Time
}

// NewChecklist configures a chart completion checklist (SRS-MRD-001).
func NewChecklist(id, tenantID string, in NewChecklistInput, by string,
	now time.Time) (ChartChecklist, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return ChartChecklist{}, fmt.Errorf("%w: a checklist needs an id",
			ErrInvalidRecord)
	case strings.TrimSpace(in.Code) == "":
		return ChartChecklist{}, fmt.Errorf("%w: a checklist needs a code",
			ErrInvalidRecord)
	case in.Revision <= 0:
		return ChartChecklist{}, fmt.Errorf(
			"%w: a checklist revision starts at 1", ErrInvalidRecord)
	case strings.TrimSpace(in.EncounterClass) == "":
		return ChartChecklist{}, fmt.Errorf(
			"%w: a checklist names the encounter class it applies to",
			ErrInvalidRecord)
	case len(in.Items) == 0:
		// A checklist with no items finds every chart complete, which reads
		// exactly like a hospital with no deficiencies.
		return ChartChecklist{}, fmt.Errorf(
			"%w: a checklist with no items finds every chart complete",
			ErrInvalidRecord)
	}

	seen := map[string]bool{}
	items := make([]ChecklistItem, 0, len(in.Items))
	for _, item := range in.Items {
		kind := strings.TrimSpace(item.Kind)
		switch {
		case kind == "":
			return ChartChecklist{}, fmt.Errorf(
				"%w: a checklist item names a document kind", ErrInvalidRecord)
		case !knownRequirement[item.Requirement]:
			return ChartChecklist{}, fmt.Errorf(
				"%w: unknown requirement %q for %s",
				ErrInvalidRecord, item.Requirement, kind)
		case seen[strings.ToLower(kind)]:
			// The same kind twice is two deficiencies for one gap, and a
			// worklist that double-counts is a worklist nobody believes.
			return ChartChecklist{}, fmt.Errorf(
				"%w: %s appears twice on this checklist",
				ErrInvalidRecord, kind)
		case item.Requirement == RequirementConditional &&
			strings.TrimSpace(item.ConditionCode) == "":
			return ChartChecklist{}, fmt.Errorf(
				"%w: a conditional item names the condition that makes it apply",
				ErrInvalidRecord)
		case item.DueWithin < 0:
			return ChartChecklist{}, fmt.Errorf(
				"%w: %s cannot be due before the encounter ends",
				ErrInvalidRecord, kind)
		}
		seen[strings.ToLower(kind)] = true
		item.Kind = kind
		item.Label = strings.TrimSpace(item.Label)
		if item.Label == "" {
			item.Label = kind
		}
		items = append(items, item)
	}

	return ChartChecklist{
		ID: id, TenantID: tenantID,
		Code: strings.TrimSpace(in.Code), Name: strings.TrimSpace(in.Name),
		Revision:       in.Revision,
		EncounterClass: strings.TrimSpace(in.EncounterClass),
		Specialty:      strings.TrimSpace(in.Specialty),
		Items:          items,
		EffectiveFrom:  utcOrZero(in.EffectiveFrom),
		CreatedAt:      now.UTC(), CreatedBy: by,
	}, nil
}

// Approve puts a checklist in force (SRS-MRD-001).
//
// Refused for its author. A checklist decides which consultants get a
// deficiency letter, and one person writing and approving it is one person
// deciding what the hospital's completion rate is.
func (c *ChartChecklist) Approve(by string, effectiveFrom, now time.Time) error {
	switch {
	case c.Approved:
		return fmt.Errorf("%w: this checklist is already approved",
			ErrInvalidRecord)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an approval names who gave it", ErrInvalidRecord)
	case by == c.CreatedBy:
		return fmt.Errorf("%w: the author of a checklist cannot approve it",
			ErrInvalidRecord)
	case effectiveFrom.IsZero():
		return fmt.Errorf("%w: an approved checklist names when it takes effect",
			ErrInvalidRecord)
	}
	c.Approved, c.ApprovedBy, c.ApprovedAt = true, by, now.UTC()
	c.EffectiveFrom = effectiveFrom.UTC()
	return nil
}

// ChecklistFor picks the checklist that applies to an encounter
// (SRS-MRD-001).
//
// The most specific match in force at the moment, so a hospital's obstetric
// override beats its inpatient baseline. Nothing is defaulted: an encounter
// class nobody has written a checklist for produces no deficiencies and says
// so, rather than being judged against somebody else's list.
func ChecklistFor(checklists []ChartChecklist, encounterClass,
	specialty string, at time.Time) (ChartChecklist, bool) {

	var best ChartChecklist
	found := false
	for _, checklist := range checklists {
		if !checklist.Live(at) || !checklist.Covers(encounterClass, specialty) {
			continue
		}
		switch {
		case !found:
		// A specialty-specific list beats a class-wide one.
		case checklist.Specialty != "" && best.Specialty == "":
		case checklist.Specialty == "" && best.Specialty != "":
			continue
		case checklist.EffectiveFrom.After(best.EffectiveFrom):
		case checklist.EffectiveFrom.Equal(best.EffectiveFrom) &&
			checklist.Revision > best.Revision:
		default:
			continue
		}
		best, found = checklist, true
	}
	return best, found
}

// ChartDocument is what this context knows about a clinical note
// (SRS-MRD-001, SRS-MRD-002).
//
// A projection, and a deliberately thin one. There is no field here for the
// note's content, its sections or its findings: health information management
// needs to know that a discharge summary exists and who signed it, and has no
// business holding what it says.
type ChartDocument struct {
	DocumentID string
	Kind       string
	// Signed and SignedAt answer the requirement; AuthoredBy answers who the
	// deficiency belongs to when nobody has signed yet.
	Signed     bool
	SignedBy   string
	SignedAt   time.Time
	AuthoredBy string
	CreatedAt  time.Time
	// Retracted marks a note entered in error. A retracted discharge summary
	// does not satisfy a checklist item, which is the case a naive "does a
	// document of this kind exist" check gets wrong.
	Retracted bool
}

// Gap is one unmet checklist item (SRS-MRD-001).
type Gap struct {
	Kind  string
	Label string
	// Missing distinguishes "nobody wrote one" from "somebody wrote one and
	// has not signed it". The two go to different people and are chased
	// differently.
	Missing bool
	// DocumentID is the unsigned document where there is one.
	DocumentID string
	// OwnerID is who the deficiency belongs to: the author of the unsigned
	// note, or empty where nothing exists and the caller has to decide.
	OwnerID string
	DueBy   time.Time
}

// ChartGaps derives what a chart is missing (SRS-MRD-001).
//
// Derived from the checklist and the documents rather than typed by a records
// officer, for the reason every derivation in this system exists: a
// completion rate somebody can type is a completion rate somebody can type
// high, and an incomplete chart that nobody listed is an incomplete chart
// that never reaches the deficiency worklist.
//
// conditions are the facts a conditional item tests — the caller reads them
// from the encounter, because whether there was an operation is the
// encounter's fact and not this context's.
func ChartGaps(checklist ChartChecklist, documents []ChartDocument,
	conditions map[string]bool, encounterEnd time.Time) []Gap {

	byKind := map[string][]ChartDocument{}
	for _, document := range documents {
		if document.Retracted {
			// A note entered in error satisfies nothing.
			continue
		}
		key := strings.ToLower(strings.TrimSpace(document.Kind))
		byKind[key] = append(byKind[key], document)
	}

	var gaps []Gap
	for _, item := range checklist.Items {
		if item.Requirement == RequirementConditional &&
			!conditions[item.ConditionCode] {
			continue
		}

		dueBy := time.Time{}
		if !encounterEnd.IsZero() {
			dueBy = encounterEnd.Add(item.DueWithin).UTC()
		}
		present := byKind[strings.ToLower(item.Kind)]

		if len(present) == 0 {
			gaps = append(gaps, Gap{
				Kind: item.Kind, Label: item.Label, Missing: true,
				DueBy: dueBy,
			})
			continue
		}
		if item.Requirement == RequirementPresent ||
			item.Requirement == RequirementConditional {
			continue
		}

		// Signed is required. Any one signed document satisfies it; the
		// oldest unsigned one owns the deficiency, because that is the one
		// somebody started and abandoned.
		signed := false
		var unsigned []ChartDocument
		for _, document := range present {
			if document.Signed {
				signed = true
				break
			}
			unsigned = append(unsigned, document)
		}
		if signed {
			continue
		}
		sort.Slice(unsigned, func(a, b int) bool {
			return unsigned[a].CreatedAt.Before(unsigned[b].CreatedAt)
		})
		gaps = append(gaps, Gap{
			Kind: item.Kind, Label: item.Label,
			DocumentID: unsigned[0].DocumentID,
			OwnerID:    unsigned[0].AuthoredBy, DueBy: dueBy,
		})
	}

	sort.Slice(gaps, func(a, b int) bool {
		if gaps[a].DueBy.Equal(gaps[b].DueBy) {
			return gaps[a].Kind < gaps[b].Kind
		}
		// The oldest deadline first, and an item with no deadline last: a
		// worklist sorted the other way puts the things nobody is waiting for
		// at the top.
		if gaps[a].DueBy.IsZero() {
			return false
		}
		if gaps[b].DueBy.IsZero() {
			return true
		}
		return gaps[a].DueBy.Before(gaps[b].DueBy)
	})
	return gaps
}

func utcOrZero(t time.Time) time.Time {
	if t.IsZero() {
		return time.Time{}
	}
	return t.UTC()
}
