package domain

import (
	"sort"
	"time"
)

// The longitudinal timeline (SRS-ENC-011).
//
// The acceptance criterion is the whole requirement: "unauthorized restricted
// notes are omitted/masked". A timeline is the screen where every context's
// output meets, which makes it the screen where a confidentiality mistake
// reaches the most people. So filtering happens here, on the way out, rather
// than being left to each contributing context to remember.

// EntryKind is what a timeline entry is.
//
// Enumerated because the timeline's filters are defined in terms of it
// (SRS-CLN-018), and a free-text kind would make "show me only the labs" a
// string match that silently misses a category somebody spelled differently.
type EntryKind string

const (
	EntryEncounter   EntryKind = "encounter"
	EntryDiagnosis   EntryKind = "diagnosis"
	EntryNote        EntryKind = "note"
	EntryObservation EntryKind = "observation"
	EntryMedication  EntryKind = "medication"
	EntryProcedure   EntryKind = "procedure"
	EntryOrder       EntryKind = "order"
	EntryDocument    EntryKind = "document"
	EntryImaging     EntryKind = "imaging"
	EntryAllergy     EntryKind = "allergy"
)

// Confidentiality is how tightly an entry is held.
//
// Three levels rather than a per-entry access list. An access list on every
// clinical record is a system nobody can reason about: the question "who can
// see this patient's chart" stops having an answer, and the people who most
// need to know — the patient, and whoever is answering their complaint — are
// the least able to work it out.
type Confidentiality string

const (
	// ConfidentialityNormal is ordinary clinical content, visible to anybody
	// with clinical read access to this patient.
	ConfidentialityNormal Confidentiality = "normal"
	// ConfidentialityRestricted needs a narrower role and purpose
	// (SRS-CLN-019). Mental health, sexual health, safeguarding.
	ConfidentialityRestricted Confidentiality = "restricted"
	// ConfidentialityVeryRestricted is the break-glass tier: visible only to
	// the authoring team unless an emergency is declared and recorded.
	ConfidentialityVeryRestricted Confidentiality = "very_restricted"
)

var confidentialityRank = map[Confidentiality]int{
	ConfidentialityNormal: 0, ConfidentialityRestricted: 1,
	ConfidentialityVeryRestricted: 2,
}

// Known reports a confidentiality class this system recognises.
func (c Confidentiality) Known() bool {
	_, ok := confidentialityRank[c]
	return ok
}

// AtLeastAsTightAs reports whether c is at least as restrictive as other.
//
// An unknown class ranks as the tightest rather than the loosest. A
// classification this version does not understand is one it cannot safely
// show: over-restricting is an inconvenience somebody reports, and
// under-restricting is a disclosure nobody notices.
func (c Confidentiality) AtLeastAsTightAs(other Confidentiality) bool {
	return c.rank() >= other.rank()
}

func (c Confidentiality) rank() int {
	rank, known := confidentialityRank[c]
	if !known {
		return len(confidentialityRank)
	}
	return rank
}

// Entry is one thing that happened, as the timeline shows it.
//
// Deliberately a projection rather than the records themselves. The timeline
// shows what happened and when, and links to the record; carrying the record's
// content here would mean every clinical payload passes through a screen whose
// filters are about visibility rather than content.
type Entry struct {
	ID   string
	Kind EntryKind
	// At is when the thing happened clinically, not when it was typed.
	At time.Time
	// EncounterID is the visit it belongs to, where it belongs to one.
	EncounterID string
	// Title is a short label — "Chest X-ray", "Discharge summary". Never a
	// result value or a diagnosis: a title is rendered in list views that a
	// masked entry still appears in.
	Title           string
	Confidentiality Confidentiality
	// AuthorID is who created it, used to decide whether the reader is on the
	// authoring team.
	AuthorID string
	// CareTeamIDs are the people whose access to a restricted entry does not
	// depend on purpose — the team that wrote it.
	CareTeamIDs []string
	// Masked reports an entry the reader may know exists but may not read.
	Masked bool
}

// TimelineAccess is what the reader is allowed.
//
// Passed in rather than derived here, because the policy engine owns
// permissions and purpose. This type is the answer it produced, and the
// timeline's job is to apply it consistently.
type TimelineAccess struct {
	SubjectID string
	// MaxConfidentiality is the tightest class this reader may read in full.
	MaxConfidentiality Confidentiality
	// OnCareTeam reports that the reader is looking after this patient, which
	// is what lets a restricted entry through without a declared emergency.
	OnCareTeam bool
	// BreakGlass is a declared emergency. It widens access and is separately
	// audited; it does not make the entry ordinary.
	BreakGlass bool
	// MaskRatherThanOmit shows that something exists without showing what.
	//
	// Which is right depends on the entry. For a restricted note, masking is
	// better: a clinician who can see that a note exists knows to ask, while an
	// omitted note produces a chart that silently lies about being complete.
	// For the very-restricted tier, omission is the point — the existence of a
	// safeguarding note can itself be the disclosure.
	MaskRatherThanOmit bool
}

// CanRead reports whether the reader may see an entry's content.
func (a TimelineAccess) CanRead(e Entry) bool {
	if !e.Confidentiality.AtLeastAsTightAs(ConfidentialityRestricted) {
		return true
	}
	if a.MaxConfidentiality.AtLeastAsTightAs(e.Confidentiality) {
		return true
	}
	// The team that wrote a restricted entry can always read it back. A note
	// its own author cannot reopen is a note nobody will write.
	if a.OnCareTeam && e.Confidentiality == ConfidentialityRestricted {
		return true
	}
	if authoredBy(e, a.SubjectID) {
		return true
	}
	// Break-glass reaches restricted content and stops there. The
	// very-restricted tier is the one a hospital has decided needs a
	// conversation rather than a button.
	return a.BreakGlass && e.Confidentiality == ConfidentialityRestricted
}

func authoredBy(e Entry, subjectID string) bool {
	if e.AuthorID == subjectID {
		return true
	}
	for _, member := range e.CareTeamIDs {
		if member == subjectID {
			return true
		}
	}
	return false
}

// FilterTimeline applies a reader's access to a timeline (SRS-ENC-011).
//
// Returns the entries the reader may see, with anything they may not either
// masked or dropped. The masked entries keep their kind and time and lose their
// title, so a chart shows that something is there without saying what.
func FilterTimeline(entries []Entry, access TimelineAccess) []Entry {
	out := make([]Entry, 0, len(entries))
	for _, e := range entries {
		if access.CanRead(e) {
			out = append(out, e)
			continue
		}
		if !access.MaskRatherThanOmit ||
			e.Confidentiality.AtLeastAsTightAs(ConfidentialityVeryRestricted) {
			// Omitted. For the very-restricted tier this is deliberate: the
			// existence of a safeguarding note can itself be the disclosure.
			continue
		}
		out = append(out, Entry{
			ID: e.ID, Kind: e.Kind, At: e.At, EncounterID: e.EncounterID,
			Title:           "restricted",
			Confidentiality: e.Confidentiality, Masked: true,
		})
	}
	return out
}

// SortTimeline orders entries newest first, which is how a chart is read.
func SortTimeline(entries []Entry) {
	sort.SliceStable(entries, func(i, j int) bool {
		if !entries[i].At.Equal(entries[j].At) {
			return entries[i].At.After(entries[j].At)
		}
		return entries[i].ID < entries[j].ID
	})
}

// FilterKinds narrows a timeline to the requested kinds (SRS-CLN-018).
//
// A view, never a change: the acceptance criterion is that "filters never
// change underlying record", and returning a new slice rather than editing in
// place is what makes that true by construction.
func FilterKinds(entries []Entry, kinds []EntryKind) []Entry {
	if len(kinds) == 0 {
		return entries
	}
	wanted := make(map[EntryKind]bool, len(kinds))
	for _, k := range kinds {
		wanted[k] = true
	}

	out := make([]Entry, 0, len(entries))
	for _, e := range entries {
		if wanted[e.Kind] {
			out = append(out, e)
		}
	}
	return out
}

// Restricted reports the entries a reader was not allowed to read in full,
// which is what SRS-CLN-019 requires to be explicitly audited.
func Restricted(entries []Entry) []Entry {
	out := make([]Entry, 0)
	for _, e := range entries {
		if e.Masked {
			out = append(out, e)
		}
	}
	return out
}
