// Package domain holds the mortuary rules (SRS-MORT-001 … 008).
//
// Three properties are worth stating before the code, because each is the
// reason a piece of it is shaped the way it is.
//
// A case is either linked to a death this hospital recorded or it is plainly
// marked as a body received from outside, and there is no third state. "Which
// death is this?" is the question a family, a registrar and a coroner all ask
// first, and a case that answers it with an encounter identifier somebody
// typed is a case that can point at the wrong person. The link is to an
// encounter the encounter context has, or there is no link and the case says
// where the body came from instead.
//
// A body is in one place at a time, and the place is a rule the database
// keeps. Two cases in one refrigerated space is one body somebody will not
// find, and a mortuary that discovers this discovers it at the worst possible
// moment — with a family standing in the corridor. The occupancy is a partial
// unique index rather than a flag the application maintains.
//
// And a medico-legal case is not released on anybody's say-so. The
// authorisation is a reference to the authority that gave it, carried on the
// release and held against the case's own medico-legal flag by a composite
// foreign key, so a release that names no authority cannot be written for a
// case that needs one. A body released without the coroner's clearance is
// evidence that has left the building.
package domain

import (
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"
)

// ErrInvalidMortuary is the sentinel every refusal here wraps.
var ErrInvalidMortuary = errors.New("mortuary: invalid")

// Source is where the body came from (SRS-MORT-001).
//
// An enum rather than a nullable encounter identifier, because "no encounter"
// and "an encounter nobody has checked" look identical in a nullable column
// and only one of them is a case somebody can act on.
type Source string

const (
	// SourceInHospital is a death this hospital recorded. The case names
	// the encounter, and the encounter context is what says it exists.
	SourceInHospital Source = "in_hospital"
	// SourceBroughtIn is a body received from outside: an ambulance, the
	// police, another hospital, or somebody carrying it through the door.
	SourceBroughtIn Source = "brought_in"
)

var knownSource = map[Source]bool{
	SourceInHospital: true, SourceBroughtIn: true,
}

// Identity is how sure the mortuary is who this is (SRS-MORT-002,
// SRS-MORT-007).
//
// Three states rather than a boolean. "Presumed" is the one that matters: a
// body identified by the clothing and a wallet is not the same as one
// identified by a relative who looked at the face, and a release checked
// against the first is a release to the wrong family.
type Identity string

const (
	// IdentityUnidentified is a body nobody has named.
	IdentityUnidentified Identity = "unidentified"
	// IdentityPresumed is a body named from effects, a document or a
	// circumstance rather than by somebody who knew them.
	IdentityPresumed Identity = "presumed"
	// IdentityConfirmed is a body named by a person who identified it, and
	// the case records who.
	IdentityConfirmed Identity = "confirmed"
)

var knownIdentity = map[Identity]bool{
	IdentityUnidentified: true, IdentityPresumed: true,
	IdentityConfirmed: true,
}

// Positive reports an identity a release may be checked against
// (SRS-MORT-006).
//
// Only a confirmed one. A presumed identity is a hypothesis, and handing a
// body to a family on a hypothesis is how the wrong funeral happens.
func (i Identity) Positive() bool { return i == IdentityConfirmed }

// CaseState is where a mortuary case stands (SRS-MORT-002, SRS-MORT-006).
type CaseState string

const (
	// CaseReceived is a body in the building and not yet in a space.
	CaseReceived CaseState = "received"
	// CaseStored is a body in a named storage location.
	CaseStored CaseState = "stored"
	// CaseReleased is a body that has left, to a named recipient.
	CaseReleased CaseState = "released"
)

var knownCaseState = map[CaseState]bool{
	CaseReceived: true, CaseStored: true, CaseReleased: true,
}

// Case is one body in the mortuary's care (SRS-MORT-001).
type Case struct {
	ID       string
	TenantID string

	// Reference is what everybody says out loud: the number on the tag, on
	// the register and on the paperwork the family carries away.
	Reference string

	Source Source
	// EncounterID is set for an in-hospital death and empty for a body
	// brought in. Which of the two it is, is the Source rather than
	// whether this is empty: a case that lost its encounter identifier in
	// a migration would otherwise silently become a brought-in body.
	EncounterID string
	// PatientID is set when the person is known to this hospital, which an
	// unidentified body is not.
	PatientID string
	// ExternalSource says who brought the body in. Required for a
	// brought-in case: a body that arrived from nowhere is one nobody can
	// ask about.
	ExternalSource string

	Identity Identity
	// IdentifiedBy and IdentifiedAt record who made a confirmed
	// identification and when. A confirmation with nobody behind it is one
	// nobody can be asked about afterwards.
	IdentifiedBy   string
	IdentifiedAt   time.Time
	IdentifiedNote string

	// DisplayName is the name the mortuary uses. Empty for an unidentified
	// body, where the reference is the only name there is.
	DisplayName string

	// MedicoLegal marks a case an authority has an interest in: a death in
	// custody, an accident, an unnatural or unexplained death. It decides
	// whether a release needs an authority's clearance, and it cannot be
	// cleared once set — see ClearMedicoLegal's absence.
	MedicoLegal bool
	// MLCReference is the police or coroner's own number for the case,
	// where they have given one.
	MLCReference string

	// Restricted marks a case whose detail is not on the ordinary board: a
	// public figure, a death the family has asked be kept quiet, a case
	// under investigation.
	Restricted bool

	// CauseSummary is the sensitive text SRS-MORT-003 puts behind its own
	// permission. Never on the occupancy board and never in an event.
	CauseSummary string

	State CaseState
	// LocationID and StorageTag are where the body is now, copied from the
	// placement so a board read does not need a second query. Cleared on
	// release.
	LocationID string
	StorageTag string

	// DeathCertificateRef is the certificate or registration number once
	// it exists. On the case rather than only on the release, because "is
	// this body ready to go" is a question the pending-release board has
	// to answer before anybody starts typing a release.
	DeathCertificateRef   string
	CertificateRecordedBy string
	CertificateRecordedAt time.Time

	DiedAt     time.Time
	ReceivedAt time.Time
	ReceivedBy string

	FacilityID string

	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// NewCaseInput opens a mortuary case (SRS-MORT-001).
type NewCaseInput struct {
	Reference      string
	Source         Source
	EncounterID    string
	PatientID      string
	ExternalSource string
	Identity       Identity
	// IdentificationNote is how the identity was established at receipt:
	// the wristband against the notes, a relative who came with the body,
	// the police's own identification. Required where the case arrives
	// already confirmed — a body received as identified was identified by
	// somebody, against something, and the receiving attendant is the one
	// who can say what.
	IdentificationNote string
	DisplayName        string
	MedicoLegal        bool
	MLCReference       string
	Restricted         bool
	DiedAt             time.Time
	FacilityID         string
}

// OpenCase records a body arriving in the mortuary's care (SRS-MORT-001).
//
// The case is linked or it is plainly external, and the constructor will not
// produce anything in between: an in-hospital death names its encounter, and
// a brought-in body says who brought it.
func OpenCase(id, tenantID string, in NewCaseInput, by string,
	now time.Time) (Case, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Case{}, fmt.Errorf("%w: a case needs an id",
			ErrInvalidMortuary)
	case strings.TrimSpace(in.Reference) == "":
		// The number on the tag and on the paperwork. A case nobody can
		// say out loud is one nobody can ask after at the desk.
		return Case{}, fmt.Errorf("%w: a case needs its reference",
			ErrInvalidMortuary)
	case !knownSource[in.Source]:
		return Case{}, fmt.Errorf("%w: unknown source %q",
			ErrInvalidMortuary, in.Source)
	case !knownIdentity[in.Identity]:
		return Case{}, fmt.Errorf("%w: unknown identity state %q",
			ErrInvalidMortuary, in.Identity)
	case strings.TrimSpace(by) == "":
		return Case{}, fmt.Errorf("%w: a case names who opened it",
			ErrInvalidMortuary)
	}

	switch in.Source {
	case SourceInHospital:
		if strings.TrimSpace(in.EncounterID) == "" {
			// "Which death is this?" is the first question a registrar
			// asks, and an in-hospital case that cannot answer it is one
			// where somebody will answer it from memory.
			return Case{}, fmt.Errorf(
				"%w: a death this hospital recorded names its encounter",
				ErrInvalidMortuary)
		}
	case SourceBroughtIn:
		if strings.TrimSpace(in.ExternalSource) == "" {
			return Case{}, fmt.Errorf(
				"%w: a body brought in says where it came from",
				ErrInvalidMortuary)
		}
		if strings.TrimSpace(in.EncounterID) != "" {
			// A brought-in body with an encounter is one of two mistakes:
			// the source is wrong, or the encounter belongs to somebody
			// else. Both are worth stopping at the door.
			return Case{}, fmt.Errorf(
				"%w: a body brought in from outside has no encounter here",
				ErrInvalidMortuary)
		}
	}

	if in.Identity == IdentityConfirmed &&
		strings.TrimSpace(in.IdentificationNote) == "" {
		// The database holds the same rule. A case that opens as
		// confirmed with nothing behind it is one where "confirmed" was
		// the default on a form.
		return Case{}, fmt.Errorf(
			"%w: a case received as identified says how it was confirmed",
			ErrInvalidMortuary)
	}

	if in.Identity == IdentityUnidentified &&
		strings.TrimSpace(in.DisplayName) != "" {
		// A name on an unidentified body is the name somebody guessed,
		// and it will be read as the name somebody established.
		return Case{}, fmt.Errorf(
			"%w: an unidentified case carries no name", ErrInvalidMortuary)
	}

	return Case{
		ID: id, TenantID: tenantID,
		Reference:      strings.TrimSpace(in.Reference),
		Source:         in.Source,
		EncounterID:    strings.TrimSpace(in.EncounterID),
		PatientID:      strings.TrimSpace(in.PatientID),
		ExternalSource: strings.TrimSpace(in.ExternalSource),
		Identity:       in.Identity,
		IdentifiedBy:   identifierAtReceipt(in.Identity, by),
		IdentifiedAt:   identifiedAtReceipt(in.Identity, now),
		IdentifiedNote: strings.TrimSpace(in.IdentificationNote),
		DisplayName:    strings.TrimSpace(in.DisplayName),
		MedicoLegal:    in.MedicoLegal,
		MLCReference:   strings.TrimSpace(in.MLCReference),
		Restricted:     in.Restricted,
		State:          CaseReceived,
		DiedAt:         utcOrZero(in.DiedAt),
		ReceivedAt:     now.UTC(), ReceivedBy: by,
		FacilityID: strings.TrimSpace(in.FacilityID),
		CreatedAt:  now.UTC(), CreatedBy: by, Version: 1,
	}, nil
}

// Identify records somebody naming the body (SRS-MORT-002, SRS-MORT-006).
//
// Who identified it is kept, because a release is checked against a
// confirmed identity and "confirmed by whom" is the question asked when the
// wrong family is standing in the corridor.
func (c *Case) Identify(identity Identity, name, note, by string,
	now time.Time) error {

	switch {
	case c.State == CaseReleased:
		return fmt.Errorf("%w: this case has been released",
			ErrInvalidMortuary)
	case !knownIdentity[identity]:
		return fmt.Errorf("%w: unknown identity state %q",
			ErrInvalidMortuary, identity)
	case identity == IdentityUnidentified:
		// Naming a body and then un-naming it is not an identification.
		// Correcting a wrong name is a correction of the name, and the
		// identity stays where the evidence puts it.
		return fmt.Errorf(
			"%w: an identification does not make a body unidentified",
			ErrInvalidMortuary)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an identification names who made it",
			ErrInvalidMortuary)
	case strings.TrimSpace(name) == "":
		return fmt.Errorf("%w: an identification says who this is",
			ErrInvalidMortuary)
	case identity == IdentityConfirmed &&
		strings.TrimSpace(note) == "":
		// How it was confirmed — a relative who knew them, a dental
		// record, a document with a photograph — is what makes the
		// confirmation reviewable. Without it, "confirmed" is a word
		// somebody typed.
		return fmt.Errorf("%w: a confirmed identification says how",
			ErrInvalidMortuary)
	}

	c.Identity = identity
	c.DisplayName = strings.TrimSpace(name)
	c.IdentifiedBy, c.IdentifiedAt = by, now.UTC()
	c.IdentifiedNote = strings.TrimSpace(note)
	return nil
}

// RecordCause records what the person died of (SRS-MORT-003).
//
// Its own act rather than a field on the receipt, because the cause is not
// known when the body arrives: it comes later from the certifying doctor or
// from the examination. A field at receipt would be filled in with a guess or
// left empty for ever, and both read the same afterwards.
func (c *Case) RecordCause(summary, by string) error {
	switch {
	case c.State == CaseReleased:
		return fmt.Errorf("%w: this case has been released",
			ErrInvalidMortuary)
	case strings.TrimSpace(summary) == "":
		return fmt.Errorf("%w: a cause says what it was",
			ErrInvalidMortuary)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: this names who recorded it",
			ErrInvalidMortuary)
	}
	c.CauseSummary = strings.TrimSpace(summary)
	return nil
}

// RecordDeathCertificate attaches the certificate or registration reference
// (SRS-MORT-006).
//
// Recorded as its own act rather than typed into the release, so a mortuary
// can see which bodies are waiting on paperwork and chase it, rather than
// finding out when a family is at the desk.
func (c *Case) RecordDeathCertificate(reference, by string,
	now time.Time) error {

	switch {
	case c.State == CaseReleased:
		return fmt.Errorf("%w: this case has been released",
			ErrInvalidMortuary)
	case strings.TrimSpace(reference) == "":
		return fmt.Errorf("%w: a certificate needs its reference",
			ErrInvalidMortuary)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: this names who recorded it",
			ErrInvalidMortuary)
	}
	c.DeathCertificateRef = strings.TrimSpace(reference)
	c.CertificateRecordedBy, c.CertificateRecordedAt = by, now.UTC()
	return nil
}

// MarkMedicoLegal brings a case under an authority's interest
// (SRS-MORT-005, SRS-MORT-007).
//
// There is no method that clears it. A case that was medico-legal and is no
// longer is one where somebody decided the coroner has lost interest, and
// that is the coroner's decision rather than the mortuary's. The clearance
// to release comes as an authorisation naming the authority, which is a
// different thing from the flag going away.
func (c *Case) MarkMedicoLegal(reference, by string) error {
	switch {
	case c.State == CaseReleased:
		return fmt.Errorf("%w: this case has been released",
			ErrInvalidMortuary)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: this names who marked it",
			ErrInvalidMortuary)
	}
	c.MedicoLegal = true
	if reference := strings.TrimSpace(reference); reference != "" {
		c.MLCReference = reference
	}
	return nil
}

// Board is what an occupancy screen may show (SRS-MORT-003, SRS-MORT-008).
//
// A projection rather than the case, because the dashboard is read in a
// corridor and on a shared screen. It carries a reference, a place, a state
// and how long — and no cause, no medico-legal reference, no name where the
// case is restricted.
type Board struct {
	CaseID     string
	Reference  string
	LocationID string
	StorageTag string
	State      CaseState
	// DisplayName is blank for a restricted case. The reference is what
	// the board shows instead, and somebody who needs the name reads the
	// case under its own permission.
	DisplayName string
	// MedicoLegal is carried as a flag and not as a reference: a mortuary
	// attendant needs to know a case needs clearance before they move it,
	// and does not need the police number to know that.
	MedicoLegal bool
	Identity    Identity
	ReceivedAt  time.Time
	// HeldHours is how long the body has been here, which is the number a
	// mortuary actually manages by.
	HeldHours int
	// PendingRelease reports a case cleared to go that has not gone.
	PendingRelease bool
}

// Summarise projects cases onto the occupancy board (SRS-MORT-008).
//
// The redaction is here rather than in the caller, so a second screen cannot
// be written that forgets it.
func Summarise(cases []Case, pending map[string]bool,
	at time.Time) []Board {

	out := make([]Board, 0, len(cases))
	for _, c := range cases {
		if c.State == CaseReleased {
			continue
		}
		name := c.DisplayName
		if c.Restricted {
			name = ""
		}
		held := 0
		if !c.ReceivedAt.IsZero() && at.After(c.ReceivedAt) {
			held = int(at.Sub(c.ReceivedAt).Hours())
		}
		out = append(out, Board{
			CaseID: c.ID, Reference: c.Reference,
			LocationID: c.LocationID, StorageTag: c.StorageTag,
			State: c.State, DisplayName: name,
			MedicoLegal: c.MedicoLegal, Identity: c.Identity,
			ReceivedAt: c.ReceivedAt, HeldHours: held,
			PendingRelease: pending[c.ID],
		})
	}
	// Longest held first. A mortuary's problem is the body that has been
	// there three weeks, and a list in arrival order puts it at the bottom
	// where it stays.
	sort.SliceStable(out, func(i, j int) bool {
		return out[i].ReceivedAt.Before(out[j].ReceivedAt)
	})
	return out
}

// identifierAtReceipt names the receiving attendant as the identifier where
// the body arrives already confirmed. A confirmation with nobody behind it is
// one nobody can be asked about afterwards.
func identifierAtReceipt(identity Identity, by string) string {
	if identity == IdentityConfirmed {
		return by
	}
	return ""
}

func identifiedAtReceipt(identity Identity, now time.Time) time.Time {
	if identity == IdentityConfirmed {
		return now.UTC()
	}
	return time.Time{}
}

func utcOrZero(t time.Time) time.Time {
	if t.IsZero() {
		return time.Time{}
	}
	return t.UTC()
}

func normalise(in []string) []string {
	if len(in) == 0 {
		return nil
	}
	seen := map[string]bool{}
	out := make([]string, 0, len(in))
	for _, value := range in {
		value = strings.TrimSpace(value)
		if value == "" || seen[strings.ToLower(value)] {
			continue
		}
		seen[strings.ToLower(value)] = true
		out = append(out, value)
	}
	return out
}
