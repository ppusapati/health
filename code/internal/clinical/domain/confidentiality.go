package domain

// Confidentiality is how tightly a clinical record is held (SRS-CLN-019).
//
// Three levels rather than a per-record access list. An access list on every
// clinical record is a system nobody can reason about: the question "who can see
// this patient's chart" stops having an answer, and the people who most need to
// know — the patient, and whoever is answering their complaint — are the least
// able to work it out.
//
// Deliberately the same vocabulary as the encounter context's timeline, because
// the filter that applies it lives there: a clinical record classified here and
// filtered by a different scale would be two rules that drift.
type Confidentiality string

const (
	// ConfidentialityNormal is ordinary clinical content, visible to anybody
	// with clinical read access to this patient.
	ConfidentialityNormal Confidentiality = "normal"
	// ConfidentialityRestricted needs a narrower role and purpose. Mental
	// health, sexual health, safeguarding.
	ConfidentialityRestricted Confidentiality = "restricted"
	// ConfidentialityVeryRestricted is visible only to the authoring team
	// unless an emergency is declared and recorded.
	ConfidentialityVeryRestricted Confidentiality = "very_restricted"
)

var knownConfidentiality = map[Confidentiality]bool{
	ConfidentialityNormal: true, ConfidentialityRestricted: true,
	ConfidentialityVeryRestricted: true,
}

// Known reports a class this system recognises.
func (c Confidentiality) Known() bool { return knownConfidentiality[c] }

// Restricted reports content that needs more than ordinary clinical access.
func (c Confidentiality) Restricted() bool {
	return c == ConfidentialityRestricted || c == ConfidentialityVeryRestricted ||
		// An unrecognised class is treated as restricted rather than normal:
		// over-restricting is an inconvenience somebody reports, and
		// under-restricting is a disclosure nobody notices.
		!c.Known()
}
