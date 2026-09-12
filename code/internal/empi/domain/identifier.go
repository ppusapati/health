package domain

import (
	"fmt"
	"strings"
	"time"
)

// Identifier lifecycle (SRS-EMPI-002, SRS-EMPI-011).
//
// Every identifier a human sees or quotes is a row with its own lifecycle, and
// none of them is the patient's key. The MRN is the clearest case: it is
// printed on a wristband, read over the phone, superseded by a merge and
// occasionally corrected because a clerk transposed two digits. A clinical
// record keyed on it would follow every one of those changes, and one of them
// would take it to the wrong patient.
//
// The same holds for a national health identifier such as ABHA: SRS-EMPI-011
// requires it to be linkable and unlinkable "without making them database
// primary keys", and linking is only reversible if the link is a row.

// IdentifierType is the kind of identifier.
type IdentifierType string

const (
	// IdentifierMRN is the medical record number issued by a facility.
	IdentifierMRN IdentifierType = "mrn"
	// IdentifierNationalHealth is a national or regional health identifier —
	// ABHA in India, NHS number in England.
	IdentifierNationalHealth IdentifierType = "national_health"
	// IdentifierGovernment is a government identity document.
	IdentifierGovernment IdentifierType = "government"
	// IdentifierInsurance is a payer membership number.
	IdentifierInsurance IdentifierType = "insurance"
	// IdentifierExternal is anything issued by another system this one
	// integrates with.
	IdentifierExternal IdentifierType = "external"
)

var knownIdentifierTypes = map[IdentifierType]bool{
	IdentifierMRN: true, IdentifierNationalHealth: true, IdentifierGovernment: true,
	IdentifierInsurance: true, IdentifierExternal: true,
}

// IdentifierStatus is where an identifier sits in its life.
type IdentifierStatus string

const (
	// IdentifierActive is currently the right value to quote.
	IdentifierActive IdentifierStatus = "active"
	// IdentifierSuperseded was correct and has been replaced — by a merge, or
	// by a correction. It is kept because it is on documents already printed,
	// and a search for it must still find the patient.
	IdentifierSuperseded IdentifierStatus = "superseded"
	// IdentifierRevoked was wrong: entered against this patient in error, or
	// unlinked by the authority that issued it. A search for it must NOT
	// resolve to this patient, which is the difference from superseded.
	IdentifierRevoked IdentifierStatus = "revoked"
)

// Identifier is one way the outside world names this patient.
type Identifier struct {
	ID        string
	PatientID string
	Type      IdentifierType
	// System namespaces the value. Two facilities both issuing "MRN 1001" are
	// two different patients, and without a system they collide.
	System string
	Value  string
	// AssigningAuthority is who issued it, for display and for provenance.
	AssigningAuthority string
	Status             IdentifierStatus
	// Source records where this system learned the value: a registration desk,
	// an ABDM adapter, a merge. SRS-EMPI-011 requires link history and source
	// to be retained.
	Source string
	// Primary marks the identifier a banner shows. Exactly one active MRN per
	// patient is primary; a merge moves it.
	Primary bool
	// Assurance is how the value came to be believed — stated by a person, or
	// confirmed by the authority that issues it. See assurance.go.
	Assurance IdentifierAssurance
	// VerifiedAt is when the issuing authority last confirmed the value. Nil
	// while the identifier is merely asserted.
	VerifiedAt *time.Time

	LinkedAt time.Time
	// UnlinkedAt is set when the identifier leaves active use, whichever way it
	// left. Present on both superseded and revoked, because the question "what
	// did this patient's wristband say in March" needs an interval.
	UnlinkedAt *time.Time
	// SupersededByID points at the identifier that replaced this one, when one
	// did. Nil for a revocation, which replaces nothing.
	SupersededByID string
	// Reason explains a supersede or revoke in a reviewable sentence.
	Reason string
}

// MaxIdentifierValueLength bounds a stored identifier. Long enough for any
// real scheme, short enough that a pasted document cannot become one.
const MaxIdentifierValueLength = 128

// NewIdentifier validates and constructs an identifier link.
func NewIdentifier(id, patientID string, t IdentifierType, system, value,
	authority, source string, now time.Time) (Identifier, error) {

	value = strings.TrimSpace(value)
	system = strings.TrimSpace(system)

	switch {
	case strings.TrimSpace(id) == "":
		return Identifier{}, fmt.Errorf("%w: identifier id is required", ErrInvalidPatient)
	case strings.TrimSpace(patientID) == "":
		return Identifier{}, fmt.Errorf("%w: identifier needs a patient", ErrInvalidPatient)
	case !knownIdentifierTypes[t]:
		return Identifier{}, fmt.Errorf("%w: unknown identifier type %q", ErrInvalidPatient, t)
	case system == "":
		// Without a namespace, two facilities' MRN 1001 are the same value.
		return Identifier{}, fmt.Errorf("%w: identifier needs a system", ErrInvalidPatient)
	case value == "":
		return Identifier{}, fmt.Errorf("%w: identifier needs a value", ErrInvalidPatient)
	case len(value) > MaxIdentifierValueLength:
		return Identifier{}, fmt.Errorf("%w: identifier value exceeds %d characters",
			ErrInvalidPatient, MaxIdentifierValueLength)
	case strings.TrimSpace(source) == "":
		// SRS-EMPI-011: link history and source are retained. A link with no
		// source cannot be unwound with any confidence about what claimed it.
		return Identifier{}, fmt.Errorf("%w: identifier needs a source", ErrInvalidPatient)
	}

	return Identifier{
		ID: id, PatientID: patientID, Type: t,
		System: system, Value: value,
		AssigningAuthority: normaliseText(authority),
		Status:             IdentifierActive,
		// Asserted until an authority says otherwise. Defaulting the other way
		// would make an unreachable registry silently upgrade every identifier
		// typed during the outage.
		Assurance: AssuranceAsserted,
		Source:    normaliseText(source),
		LinkedAt:  now.UTC(),
	}, nil
}

// Supersede retires an identifier in favour of another.
//
// The old value stays searchable. A discharge summary printed last week quotes
// it, and a clerk typing it in has to reach this patient.
func (i *Identifier) Supersede(byIdentifierID, reason string, now time.Time) error {
	if i.Status != IdentifierActive {
		return fmt.Errorf("%w: identifier %s is already %s", ErrInvalidPatient, i.ID, i.Status)
	}
	if strings.TrimSpace(reason) == "" {
		return fmt.Errorf("%w: superseding an identifier needs a reason", ErrInvalidPatient)
	}
	at := now.UTC()
	i.Status = IdentifierSuperseded
	i.SupersededByID = byIdentifierID
	i.Reason = normaliseText(reason)
	i.UnlinkedAt = &at
	i.Primary = false
	return nil
}

// Revoke removes an identifier that should never have pointed here.
//
// Unlike Supersede, a revoked value must stop resolving to this patient: it
// belongs to somebody else, or to nobody. Keeping the row is what lets an
// investigator see that it was once claimed, and by what source.
func (i *Identifier) Revoke(reason string, now time.Time) error {
	if i.Status == IdentifierRevoked {
		return nil
	}
	if strings.TrimSpace(reason) == "" {
		return fmt.Errorf("%w: revoking an identifier needs a reason", ErrInvalidPatient)
	}
	at := now.UTC()
	i.Status = IdentifierRevoked
	i.Reason = normaliseText(reason)
	i.UnlinkedAt = &at
	i.Primary = false
	return nil
}

// ResolvesToPatient reports whether a search on this value should return the
// patient it is attached to.
//
// Superseded yes, revoked no. That single distinction is the whole reason the
// two statuses exist rather than one "inactive".
func (i Identifier) ResolvesToPatient() bool {
	return i.Status == IdentifierActive || i.Status == IdentifierSuperseded
}

// IdentifierSet is a patient's identifiers, with the rules that hold across
// them rather than within one.
type IdentifierSet []Identifier

// PrimaryMRN returns the MRN a banner should show.
func (s IdentifierSet) PrimaryMRN() (Identifier, bool) {
	for _, i := range s {
		if i.Type == IdentifierMRN && i.Status == IdentifierActive && i.Primary {
			return i, true
		}
	}
	// Fall back to any active MRN. A patient whose primary flag was lost in a
	// merge still has an MRN, and showing no MRN on a wristband is worse than
	// showing one that is merely not flagged.
	for _, i := range s {
		if i.Type == IdentifierMRN && i.Status == IdentifierActive {
			return i, true
		}
	}
	return Identifier{}, false
}

// Active returns the identifiers currently in use.
func (s IdentifierSet) Active() IdentifierSet {
	out := make(IdentifierSet, 0, len(s))
	for _, i := range s {
		if i.Status == IdentifierActive {
			out = append(out, i)
		}
	}
	return out
}

// ErrIdentifierConflict reports an identifier already linked elsewhere.
//
// A distinct error because the remedy is a human decision, not a retry: the
// same national health identifier on two patients means either a data-entry
// error or two records for one person, and the second is a merge.
type ErrIdentifierConflict struct {
	Type            IdentifierType
	System          string
	Value           string
	HeldByPatientID string
}

func (e ErrIdentifierConflict) Error() string {
	return fmt.Sprintf("empi: %s %s|%s is already linked to patient %s",
		e.Type, e.System, e.Value, e.HeldByPatientID)
}
