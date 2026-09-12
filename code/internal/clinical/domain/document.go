// Package domain holds the clinical record's rules: what is written about a
// patient, who signed it, and who may read it back.
//
// The bounded context is "clinical" (Master Engineering Registry). It owns
// notes, problems, allergies, observations, procedures and care plans; it does
// not own the visit they happened in, which is SRS-ENC, nor the orders that
// produced them, which is SRS-ORD. The seam is an encounter id.
//
// The rule that shapes everything here is SRS-CLN-008's: signed content cannot
// be edited in place. A clinical record is read by people making decisions and
// by people investigating decisions, and both need to see what was believed at
// the time rather than what somebody later wished had been written. So a signed
// document is immutable, and every later thought is an addendum or an
// amendment that says so.
package domain

import (
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"strings"
	"time"
)

// ErrInvalidDocument reports a document that must not be stored.
var ErrInvalidDocument = errors.New("clinical: invalid document")

// DocumentStatus is where a clinical document sits in its life
// (SRS-CLN-008).
type DocumentStatus string

const (
	// StatusDraft is being written. Editable in place, and deliberately not
	// visible to the whole hospital: a half-written note read as fact is worse
	// than no note.
	StatusDraft DocumentStatus = "draft"
	// StatusSigned is final and immutable. Everything after this is a new
	// document that points back.
	StatusSigned DocumentStatus = "signed"
	// StatusAmended replaces a signed document's content, with a reason. The
	// original stays readable.
	StatusAmended DocumentStatus = "amended"
	// StatusAddendum adds to a signed document without contradicting it — the
	// result that came back after the patient went home.
	StatusAddendum DocumentStatus = "addendum"
	// StatusEnteredInError is a document that should never have existed,
	// usually written against the wrong patient. Retained rather than deleted:
	// somebody may have read and acted on it, and a record that vanishes
	// cannot explain a decision that was made from it.
	StatusEnteredInError DocumentStatus = "entered_in_error"
)

var knownDocumentStatuses = map[DocumentStatus]bool{
	StatusDraft: true, StatusSigned: true, StatusAmended: true,
	StatusAddendum: true, StatusEnteredInError: true,
}

// Final reports a status whose content is immutable.
func (s DocumentStatus) Final() bool {
	return s == StatusSigned || s == StatusAmended || s == StatusAddendum
}

// DocumentKind is what sort of clinical document this is.
//
// Enumerated because the kind drives retention, disclosure and what a discharge
// summary is assembled from — all decisions somebody has to be able to make
// without reading the text.
type DocumentKind string

const (
	DocumentProgressNote     DocumentKind = "progress_note"
	DocumentConsultationNote DocumentKind = "consultation_note"
	DocumentDischargeSummary DocumentKind = "discharge_summary"
	DocumentOperationNote    DocumentKind = "operation_note"
	DocumentNursingNote      DocumentKind = "nursing_note"
	DocumentReferralLetter   DocumentKind = "referral_letter"
	DocumentProcedureReport  DocumentKind = "procedure_report"
)

var knownDocumentKinds = map[DocumentKind]bool{
	DocumentProgressNote: true, DocumentConsultationNote: true,
	DocumentDischargeSummary: true, DocumentOperationNote: true,
	DocumentNursingNote: true, DocumentReferralLetter: true,
	DocumentProcedureReport: true,
}

// SignatureMeaning is what signing asserts (SRS-CLN-009).
//
// Not decorative. "I wrote this" and "I supervised whoever wrote this" are
// different claims with different consequences, and a system that recorded only
// that a signature exists cannot tell a reviewer which one was made. A trainee's
// note countersigned by a consultant is the commonest case and the one that
// matters in a complaint.
type SignatureMeaning string

const (
	// MeaningAuthor is the person who wrote it.
	MeaningAuthor SignatureMeaning = "author"
	// MeaningVerifier checked the content and agrees with it.
	MeaningVerifier SignatureMeaning = "verifier"
	// MeaningCosigner supervises the author. Distinct from verifier because a
	// supervising consultant is asserting responsibility rather than agreement
	// with every word.
	MeaningCosigner SignatureMeaning = "cosigner"
	// MeaningWitness attests to something being done in their presence, such
	// as a consent discussion.
	MeaningWitness SignatureMeaning = "witness"
	// MeaningTranscriber typed what somebody else dictated and is not
	// asserting the clinical content at all (SRS-CLN-016).
	MeaningTranscriber SignatureMeaning = "transcriber"
)

var knownSignatureMeanings = map[SignatureMeaning]bool{
	MeaningAuthor: true, MeaningVerifier: true, MeaningCosigner: true,
	MeaningWitness: true, MeaningTranscriber: true,
}

// Signature is one person's assertion about one version of a document.
type Signature struct {
	ID         string
	DocumentID string
	// SubjectID is the authenticated identity. Never a typed name: a signature
	// a clerk can attribute to anybody is not a signature.
	SubjectID string
	Meaning   SignatureMeaning
	SignedAt  time.Time
	// ContentHash pins what was signed. Without it a signature says "this
	// person signed something called note 47", and the content of note 47 is
	// exactly what a dispute is about (SRS-CLN-009).
	ContentHash string
	// TemplateVersion is the template in force when the content was composed,
	// carried onto the signature so a reviewer can reconstruct the form the
	// clinician was actually filling in.
	TemplateVersion string
}

// Template is a versioned note structure (SRS-CLN-002).
//
// Versioned because a template is an instruction to the clinician about what to
// record, and a note written against v1 answered different questions from one
// written against v4. The acceptance criterion is that a saved note "references
// exact template version": without it, a chart review that assumed today's
// template would report omissions that were never asked for.
type Template struct {
	ID   string
	Name string
	// Version is the exact revision. Never mutated in place: editing a
	// published template would silently rewrite what every historical note
	// claims to have answered.
	Version string
	Kind    DocumentKind
	// Specialty narrows the template to a service, empty meaning general.
	Specialty string
	// Sections are the headings the note is composed of.
	Sections []string
	// Retired templates can still be read on old notes but cannot be chosen
	// for a new one.
	Retired bool
}

// Validate rejects a template that could not be used.
func (t Template) Validate() error {
	switch {
	case strings.TrimSpace(t.ID) == "":
		return fmt.Errorf("%w: template id is required", ErrInvalidDocument)
	case strings.TrimSpace(t.Name) == "":
		return fmt.Errorf("%w: a template needs a name", ErrInvalidDocument)
	case strings.TrimSpace(t.Version) == "":
		// An unversioned template makes every note that references it
		// ambiguous the first time somebody edits the wording.
		return fmt.Errorf("%w: a template needs a version", ErrInvalidDocument)
	case !knownDocumentKinds[t.Kind]:
		return fmt.Errorf("%w: unknown document kind %q", ErrInvalidDocument, t.Kind)
	case len(t.Sections) == 0:
		return fmt.Errorf("%w: a template needs at least one section", ErrInvalidDocument)
	}
	return nil
}

// Section is one part of a composed note.
type Section struct {
	Heading string
	// Text is the expanded content. Smart phrases are expanded before storage
	// (SRS-CLN-015), so what is signed is what a reader sees.
	Text string
}

// MaxDocumentLength bounds a single document. Generous — an operation note is
// long — and present because an unbounded text column is how one paste of a
// PDF's raw bytes takes out a clinical screen.
const MaxDocumentLength = 200_000

// Document is one clinical note (SRS-CLN-002, SRS-CLN-008).
type Document struct {
	// id is unexported: it is what signatures, addenda and amendments point
	// at, and a field anybody can assign is a field somebody eventually
	// reassigns.
	id          string
	TenantID    string
	PatientID   string
	EncounterID string
	Kind        DocumentKind
	// TemplateID and TemplateVersion record the exact form this note was
	// composed against (SRS-CLN-002).
	TemplateID      string
	TemplateVersion string
	Title           string
	Sections        []Section

	Status DocumentStatus
	// Confidentiality decides who may read it (SRS-CLN-019).
	Confidentiality Confidentiality

	// AmendsID and AddsToID chain to the document this one revises or extends.
	// Exactly one is set, and only on an amendment or an addendum.
	AmendsID string
	AddsToID string
	// ChangeReason is why an amendment exists. An amendment with no reason is
	// indistinguishable from a rewrite.
	ChangeReason string
	// RetractionReason marks a document entered in error.
	RetractionReason string

	// Dictated marks content that arrived from speech recognition
	// (SRS-CLN-016). Carried because a clinician reviewing their own dictation
	// needs to know they are reviewing a machine's transcript, and because a
	// draft nobody reviewed must never be signed.
	Dictated bool

	Signatures []Signature

	AuthoredBy string
	CreatedAt  time.Time
	UpdatedAt  time.Time
	Version    int64
}

// ID returns the immutable identifier.
func (d *Document) ID() string { return d.id }

// RestoreDocument rebuilds a document from storage.
func RestoreDocument(id string, d Document) *Document {
	d.id = id
	return &d
}

// NewDocument starts a draft (SRS-CLN-002).
func NewDocument(id, tenantID string, in NewDocumentInput, authoredBy string,
	now time.Time) (*Document, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return nil, fmt.Errorf("%w: document id is required", ErrInvalidDocument)
	case strings.TrimSpace(in.PatientID) == "":
		return nil, fmt.Errorf("%w: a document needs a patient", ErrInvalidDocument)
	case strings.TrimSpace(in.EncounterID) == "":
		// A note with no encounter is a note nobody can place in time or
		// context, and the chart it belongs to cannot show it in order.
		return nil, fmt.Errorf("%w: a document needs an encounter", ErrInvalidDocument)
	case !knownDocumentKinds[in.Kind]:
		return nil, fmt.Errorf("%w: unknown document kind %q", ErrInvalidDocument, in.Kind)
	case strings.TrimSpace(authoredBy) == "":
		return nil, fmt.Errorf("%w: a document must record its author", ErrInvalidDocument)
	case !in.Confidentiality.Known():
		return nil, fmt.Errorf("%w: unknown confidentiality class %q",
			ErrInvalidDocument, in.Confidentiality)
	}
	if err := validateSections(in.Sections); err != nil {
		return nil, err
	}

	return &Document{
		id: id, TenantID: tenantID, PatientID: in.PatientID,
		EncounterID: in.EncounterID, Kind: in.Kind,
		TemplateID: in.TemplateID, TemplateVersion: in.TemplateVersion,
		Title: strings.TrimSpace(in.Title), Sections: in.Sections,
		Status: StatusDraft, Confidentiality: in.Confidentiality,
		Dictated:   in.Dictated,
		AuthoredBy: authoredBy,
		CreatedAt:  now.UTC(), UpdatedAt: now.UTC(), Version: 1,
	}, nil
}

// NewDocumentInput is what starting a document needs.
type NewDocumentInput struct {
	PatientID       string
	EncounterID     string
	Kind            DocumentKind
	TemplateID      string
	TemplateVersion string
	Title           string
	Sections        []Section
	Confidentiality Confidentiality
	Dictated        bool
}

func validateSections(sections []Section) error {
	total := 0
	for _, s := range sections {
		if strings.TrimSpace(s.Heading) == "" {
			return fmt.Errorf("%w: every section needs a heading", ErrInvalidDocument)
		}
		total += len(s.Text)
	}
	if total > MaxDocumentLength {
		return fmt.Errorf("%w: the document is longer than %d characters",
			ErrInvalidDocument, MaxDocumentLength)
	}
	return nil
}

// Revise edits a draft in place.
//
// Only a draft. SRS-CLN-008's criterion is that signed content cannot be edited
// in place, and the whole design rests on that being impossible rather than
// discouraged.
func (d *Document) Revise(title string, sections []Section, now time.Time) error {
	if d.Status != StatusDraft {
		return fmt.Errorf(
			"%w: a %s document is amended or extended by an addendum, never edited",
			ErrInvalidDocument, d.Status)
	}
	if err := validateSections(sections); err != nil {
		return err
	}

	d.Title = strings.TrimSpace(title)
	d.Sections = sections
	d.UpdatedAt = now.UTC()
	return nil
}

// ContentHash is the digest a signature pins (SRS-CLN-009).
//
// Over the headings as well as the text, and over their order: a note whose
// sections were reordered says something different from the one that was
// signed. The template version is folded in for the same reason — the same
// words under a different form answer different questions.
func (d *Document) ContentHash() string {
	h := sha256.New()
	fmt.Fprintf(h, "%s\x00%s\x00%s\x00", d.Kind, d.TemplateID, d.TemplateVersion)
	fmt.Fprintf(h, "%s\x00", d.Title)
	for _, s := range d.Sections {
		fmt.Fprintf(h, "%s\x1f%s\x1e", s.Heading, s.Text)
	}
	return hex.EncodeToString(h.Sum(nil))
}

// Sign finalises a document (SRS-CLN-009).
//
// After this the content is immutable. The signature records who, when, what
// they were asserting, and a hash of exactly what they asserted it about.
func (d *Document) Sign(signatureID, subjectID string, meaning SignatureMeaning,
	now time.Time) (Signature, error) {

	switch {
	case strings.TrimSpace(signatureID) == "":
		return Signature{}, fmt.Errorf("%w: signature id is required", ErrInvalidDocument)
	case strings.TrimSpace(subjectID) == "":
		// A signature a clerk can attribute to anybody is not a signature.
		return Signature{}, fmt.Errorf("%w: a signature needs an authenticated identity",
			ErrInvalidDocument)
	case !knownSignatureMeanings[meaning]:
		return Signature{}, fmt.Errorf("%w: unknown signature meaning %q",
			ErrInvalidDocument, meaning)
	case d.Status == StatusEnteredInError:
		return Signature{}, fmt.Errorf("%w: a retracted document cannot be signed",
			ErrInvalidDocument)
	case len(d.Sections) == 0:
		return Signature{}, fmt.Errorf("%w: an empty document cannot be signed",
			ErrInvalidDocument)
	}

	// A transcriber's signature does not finalise anything: they typed what
	// somebody said, and the clinician still has to review and sign
	// (SRS-CLN-016).
	signature := Signature{
		ID: signatureID, DocumentID: d.id, SubjectID: subjectID,
		Meaning: meaning, SignedAt: now.UTC(),
		ContentHash: d.ContentHash(), TemplateVersion: d.TemplateVersion,
	}
	d.Signatures = append(d.Signatures, signature)

	if meaning != MeaningTranscriber && d.Status == StatusDraft {
		d.Status = StatusSigned
	}
	d.UpdatedAt = now.UTC()
	return signature, nil
}

// Signed reports a document that has been finalised by somebody asserting
// clinical content.
func (d *Document) Signed() bool { return d.Status.Final() }

// SignedBy reports whether a particular person signed, and with what meaning.
func (d *Document) SignedBy(subjectID string) (Signature, bool) {
	for i := len(d.Signatures) - 1; i >= 0; i-- {
		if d.Signatures[i].SubjectID == subjectID {
			return d.Signatures[i], true
		}
	}
	return Signature{}, false
}

// Intact reports whether the content still matches what was signed.
//
// Cheap to check and worth checking: a signature is only evidence if the thing
// it pinned has not moved, and the one moment somebody needs that evidence is
// the one moment nobody can afford to assume.
func (d *Document) Intact() bool {
	if len(d.Signatures) == 0 {
		return true
	}
	current := d.ContentHash()
	for i := len(d.Signatures) - 1; i >= 0; i-- {
		if d.Signatures[i].Meaning == MeaningTranscriber {
			continue
		}
		return d.Signatures[i].ContentHash == current
	}
	return true
}

// Amend produces a new document replacing a signed one (SRS-CLN-008).
//
// A new document rather than an edit, and the original stays readable, because
// somebody made a decision from it.
func (d *Document) Amend(id string, title string, sections []Section, reason,
	authoredBy string, now time.Time) (*Document, error) {

	reason = strings.TrimSpace(reason)
	switch {
	case !d.Status.Final():
		return nil, fmt.Errorf("%w: only a signed document is amended; this one is %s",
			ErrInvalidDocument, d.Status)
	case reason == "":
		return nil, fmt.Errorf("%w: an amendment needs a reason", ErrInvalidDocument)
	}

	next, err := NewDocument(id, d.TenantID, NewDocumentInput{
		PatientID: d.PatientID, EncounterID: d.EncounterID, Kind: d.Kind,
		TemplateID: d.TemplateID, TemplateVersion: d.TemplateVersion,
		Title: title, Sections: sections, Confidentiality: d.Confidentiality,
	}, authoredBy, now)
	if err != nil {
		return nil, err
	}
	next.Status = StatusAmended
	next.AmendsID = d.id
	next.ChangeReason = reason
	return next, nil
}

// AddAddendum produces a document extending a signed one (SRS-CLN-008).
//
// Distinct from an amendment: an addendum does not contradict what was signed,
// it adds what was not yet known — the result that came back after the patient
// went home. Collapsing the two would make every late result read as a
// correction.
func (d *Document) AddAddendum(id string, title string, sections []Section,
	authoredBy string, now time.Time) (*Document, error) {

	if !d.Status.Final() {
		return nil, fmt.Errorf("%w: only a signed document takes an addendum; this one is %s",
			ErrInvalidDocument, d.Status)
	}

	next, err := NewDocument(id, d.TenantID, NewDocumentInput{
		PatientID: d.PatientID, EncounterID: d.EncounterID, Kind: d.Kind,
		TemplateID: d.TemplateID, TemplateVersion: d.TemplateVersion,
		Title: title, Sections: sections, Confidentiality: d.Confidentiality,
	}, authoredBy, now)
	if err != nil {
		return nil, err
	}
	next.Status = StatusAddendum
	next.AddsToID = d.id
	return next, nil
}

// Retract marks a document that should never have existed.
//
// Retained rather than deleted: somebody may have read and acted on it, and a
// record that vanishes cannot explain a decision that was made from it.
func (d *Document) Retract(reason string, now time.Time) error {
	reason = strings.TrimSpace(reason)
	if reason == "" {
		return fmt.Errorf("%w: retracting a document needs a reason", ErrInvalidDocument)
	}
	if d.Status == StatusEnteredInError {
		return nil
	}
	d.Status = StatusEnteredInError
	d.RetractionReason = reason
	d.UpdatedAt = now.UTC()
	return nil
}

// SmartPhrase is a stored expansion a clinician types a shortcut for
// (SRS-CLN-015).
type SmartPhrase struct {
	ID      string
	OwnerID string
	// Shortcut is what the clinician types, without the leading marker.
	Shortcut string
	// Expansion is what it becomes. Stored expanded into the note, never kept
	// as a reference: the requirement is explicit that the final signed note
	// stores the expanded text, and a note holding a shortcut would say
	// something different after somebody edited the phrase.
	Expansion string
}

// ExpandSmartPhrases rewrites shortcuts into their text (SRS-CLN-015).
//
// The expansion is applied before signing and stored, so what is signed is what
// a reader sees. "No hidden clinical text" in the requirement is the point: a
// note that renders differently to its author and its reader is a note nobody
// can rely on.
func ExpandSmartPhrases(text string, phrases []SmartPhrase) (string, []string) {
	const marker = "."

	used := make([]string, 0)
	out := text
	for _, p := range phrases {
		token := marker + p.Shortcut
		if !strings.Contains(out, token) {
			continue
		}
		out = strings.ReplaceAll(out, token, p.Expansion)
		used = append(used, p.ID)
	}
	return out, used
}
