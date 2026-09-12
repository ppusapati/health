package domain_test

import (
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/clinical/domain"
)

// The clinical document lifecycle (SRS-CLN-002, 008, 009, 015, 016, 019).

func at(y int, m time.Month, d, h int) time.Time {
	return time.Date(y, m, d, h, 0, 0, 0, time.UTC)
}

func sections(text string) []domain.Section {
	return []domain.Section{{Heading: "Impression", Text: text}}
}

func newDraft(t *testing.T, now time.Time) *domain.Document {
	t.Helper()

	d, err := domain.NewDocument("doc-1", "t-1", domain.NewDocumentInput{
		PatientID: "p-1", EncounterID: "e-1", Kind: domain.DocumentProgressNote,
		TemplateID: "tpl-1", TemplateVersion: "3",
		Title:           "Ward round",
		Sections:        sections("Improving. Continue current treatment."),
		Confidentiality: domain.ConfidentialityNormal,
	}, "doctor-1", now)
	if err != nil {
		t.Fatalf("NewDocument: %v", err)
	}
	return d
}

// SRS-CLN-002: "saved note references exact template version".
func TestANoteRecordsTheTemplateVersionItWasComposedAgainst(t *testing.T) {
	now := at(2026, time.March, 3, 9)
	d := newDraft(t, now)

	if d.TemplateVersion != "3" {
		t.Fatalf("template version = %q, want 3", d.TemplateVersion)
	}

	signature, err := d.Sign("sig-1", "doctor-1", domain.MeaningAuthor, now)
	if err != nil {
		t.Fatalf("Sign: %v", err)
	}
	// Carried onto the signature too, so a reviewer can reconstruct the form
	// the clinician was actually filling in.
	if signature.TemplateVersion != "3" {
		t.Fatalf("the signature does not pin the template version: %+v", signature)
	}
}

// An unversioned template makes every note that references it ambiguous the
// first time somebody edits the wording.
func TestATemplateNeedsAVersionAndASection(t *testing.T) {
	cases := map[string]domain.Template{
		"no version": {
			ID: "tpl-1", Name: "Ward round", Kind: domain.DocumentProgressNote,
			Sections: []string{"Impression"},
		},
		"no sections": {
			ID: "tpl-1", Name: "Ward round", Version: "1",
			Kind: domain.DocumentProgressNote,
		},
		"unknown kind": {
			ID: "tpl-1", Name: "Ward round", Version: "1", Kind: "haiku",
			Sections: []string{"Impression"},
		},
	}
	for name, tpl := range cases {
		t.Run(name, func(t *testing.T) {
			if err := tpl.Validate(); err == nil {
				t.Fatalf("a template with %s was accepted", name)
			}
		})
	}
}

// SRS-CLN-008: "signed content cannot be edited in-place".
func TestASignedNoteCannotBeEdited(t *testing.T) {
	now := at(2026, time.March, 3, 9)
	d := newDraft(t, now)

	// A draft is editable — that is what a draft is for.
	if err := d.Revise("Ward round", sections("Improving, for discharge."), now); err != nil {
		t.Fatalf("revising a draft was refused: %v", err)
	}

	if _, err := d.Sign("sig-1", "doctor-1", domain.MeaningAuthor, now); err != nil {
		t.Fatalf("Sign: %v", err)
	}

	err := d.Revise("Ward round", sections("Actually deteriorating."), now)
	if err == nil {
		t.Fatal("a signed note was edited in place")
	}
	if !strings.Contains(err.Error(), "addendum") {
		t.Fatalf("the refusal does not point at the amendment route: %v", err)
	}
}

// SRS-CLN-009: "signature metadata and content hash/version retained".
//
// A signature that did not pin the content says "this person signed something
// called note 47", and the content of note 47 is exactly what a dispute is
// about.
func TestASignaturePinsWhatWasSigned(t *testing.T) {
	now := at(2026, time.March, 3, 9)
	d := newDraft(t, now)

	signature, err := d.Sign("sig-1", "doctor-1", domain.MeaningAuthor, now)
	if err != nil {
		t.Fatalf("Sign: %v", err)
	}
	if signature.ContentHash == "" {
		t.Fatal("the signature pins nothing")
	}
	if signature.SubjectID != "doctor-1" || signature.SignedAt.IsZero() {
		t.Fatalf("signature = %+v, want an identity and a time", signature)
	}
	if !d.Intact() {
		t.Fatal("a freshly signed document does not match its own signature")
	}

	// The hash is over the content, so a changed section breaks it. This can
	// only happen through a bug or a direct database edit — which is exactly
	// what the check is for.
	tampered := domain.RestoreDocument(d.ID(), *d)
	tampered.Sections = sections("Completely different.")
	if tampered.Intact() {
		t.Fatal("a document whose content was changed under its signature still " +
			"reports itself intact")
	}
}

// Reordering sections says something different from what was signed.
func TestTheContentHashCoversOrderAndHeadings(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	build := func(s []domain.Section) *domain.Document {
		d, err := domain.NewDocument("doc-1", "t-1", domain.NewDocumentInput{
			PatientID: "p-1", EncounterID: "e-1", Kind: domain.DocumentProgressNote,
			Sections: s, Confidentiality: domain.ConfidentialityNormal,
		}, "doctor-1", now)
		if err != nil {
			t.Fatalf("NewDocument: %v", err)
		}
		return d
	}

	forwards := build([]domain.Section{
		{Heading: "History", Text: "Chest pain"},
		{Heading: "Plan", Text: "Admit"},
	})
	backwards := build([]domain.Section{
		{Heading: "Plan", Text: "Admit"},
		{Heading: "History", Text: "Chest pain"},
	})
	if forwards.ContentHash() == backwards.ContentHash() {
		t.Fatal("reordering the sections leaves the content hash unchanged")
	}

	renamed := build([]domain.Section{
		{Heading: "History", Text: "Chest pain"},
		{Heading: "Impression", Text: "Admit"},
	})
	if forwards.ContentHash() == renamed.ContentHash() {
		t.Fatal("renaming a heading leaves the content hash unchanged")
	}
}

// SRS-CLN-009: "signature meaning". A trainee's note countersigned by a
// consultant is the commonest case and the one that matters in a complaint.
func TestASignatureRecordsWhatItAsserts(t *testing.T) {
	now := at(2026, time.March, 3, 9)
	d := newDraft(t, now)

	if _, err := d.Sign("sig-1", "trainee-1", domain.MeaningAuthor, now); err != nil {
		t.Fatalf("Sign (author): %v", err)
	}
	if _, err := d.Sign("sig-2", "consultant-1", domain.MeaningCosigner,
		now.Add(time.Hour)); err != nil {
		t.Fatalf("Sign (cosigner): %v", err)
	}

	if len(d.Signatures) != 2 {
		t.Fatalf("%d signatures, want the author's and the cosigner's", len(d.Signatures))
	}
	cosign, found := d.SignedBy("consultant-1")
	if !found || cosign.Meaning != domain.MeaningCosigner {
		t.Fatalf("the consultant's signature does not record what it asserts: %+v", cosign)
	}
}

// SRS-CLN-016: "clinician must review/sign resulting note".
//
// A transcriber typed what somebody said. They are not asserting the clinical
// content, so their signature must not finalise the note.
func TestATranscribersSignatureDoesNotFinaliseANote(t *testing.T) {
	now := at(2026, time.March, 3, 9)
	d := newDraft(t, now)
	d.Dictated = true

	if _, err := d.Sign("sig-1", "typist-1", domain.MeaningTranscriber, now); err != nil {
		t.Fatalf("Sign: %v", err)
	}
	if d.Signed() {
		t.Fatal("a transcriber's signature finalised a dictated note the clinician " +
			"has not reviewed")
	}

	// The clinician still has to sign it.
	if _, err := d.Sign("sig-2", "doctor-1", domain.MeaningAuthor, now); err != nil {
		t.Fatalf("Sign (clinician): %v", err)
	}
	if !d.Signed() {
		t.Fatal("the clinician's signature did not finalise the note")
	}
}

// A signature a clerk can attribute to anybody is not a signature, and an
// empty document is not a note.
func TestASignatureNeedsAnIdentityAndSomethingToSign(t *testing.T) {
	now := at(2026, time.March, 3, 9)
	d := newDraft(t, now)

	if _, err := d.Sign("sig-1", "", domain.MeaningAuthor, now); err == nil {
		t.Fatal("a document was signed by nobody")
	}
	if _, err := d.Sign("sig-1", "doctor-1", "scribbled", now); err == nil {
		t.Fatal("a signature was accepted with an unrecognised meaning")
	}

	empty, err := domain.NewDocument("doc-2", "t-1", domain.NewDocumentInput{
		PatientID: "p-1", EncounterID: "e-1", Kind: domain.DocumentProgressNote,
		Confidentiality: domain.ConfidentialityNormal,
	}, "doctor-1", now)
	if err != nil {
		t.Fatalf("NewDocument: %v", err)
	}
	if _, err := empty.Sign("sig-2", "doctor-1", domain.MeaningAuthor, now); err == nil {
		t.Fatal("an empty document was signed")
	}
}

// SRS-CLN-008: an amendment replaces, an addendum extends. Collapsing the two
// would make every late result read as a correction.
func TestAnAmendmentAndAnAddendumAreDifferentThings(t *testing.T) {
	now := at(2026, time.March, 3, 9)
	d := newDraft(t, now)
	if _, err := d.Sign("sig-1", "doctor-1", domain.MeaningAuthor, now); err != nil {
		t.Fatalf("Sign: %v", err)
	}

	// An amendment with no reason is indistinguishable from a rewrite.
	if _, err := d.Amend("doc-2", "Ward round", sections("Corrected."), "",
		"doctor-1", now); err == nil {
		t.Fatal("a note was amended with no stated reason")
	}

	amended, err := d.Amend("doc-2", "Ward round", sections("Corrected: troponin normal."),
		"the initial result was transcribed from the wrong patient", "doctor-1",
		now.Add(time.Hour))
	if err != nil {
		t.Fatalf("Amend: %v", err)
	}
	if amended.Status != domain.StatusAmended || amended.AmendsID != d.ID() {
		t.Fatalf("amendment = %+v, want an amendment chained to the original", amended)
	}

	// An addendum needs no reason: it does not contradict anything, it adds
	// what was not yet known.
	addendum, err := d.AddAddendum("doc-3", "Ward round",
		sections("Blood culture positive, reported overnight."), "doctor-1",
		now.Add(12*time.Hour))
	if err != nil {
		t.Fatalf("AddAddendum: %v", err)
	}
	if addendum.Status != domain.StatusAddendum || addendum.AddsToID != d.ID() {
		t.Fatalf("addendum = %+v, want an addendum chained to the original", addendum)
	}

	// The original is untouched. Somebody made a decision from it.
	if d.Sections[0].Text != "Improving. Continue current treatment." {
		t.Fatal("amending the note changed the version somebody already read")
	}
}

// Only a signed document is amended: a draft is simply edited.
func TestADraftIsEditedRatherThanAmended(t *testing.T) {
	now := at(2026, time.March, 3, 9)
	d := newDraft(t, now)

	if _, err := d.Amend("doc-2", "Ward round", sections("Changed."), "typo",
		"doctor-1", now); err == nil {
		t.Fatal("a draft was amended rather than edited")
	}
}

// A document retracted in error is retained: somebody may have read and acted
// on it, and a record that vanishes cannot explain a decision made from it.
func TestARetractedDocumentIsKept(t *testing.T) {
	now := at(2026, time.March, 3, 9)
	d := newDraft(t, now)
	if _, err := d.Sign("sig-1", "doctor-1", domain.MeaningAuthor, now); err != nil {
		t.Fatalf("Sign: %v", err)
	}

	if err := d.Retract("", now); err == nil {
		t.Fatal("a document was retracted with no reason")
	}
	if err := d.Retract("written against the wrong patient", now); err != nil {
		t.Fatalf("Retract: %v", err)
	}
	if d.Status != domain.StatusEnteredInError {
		t.Fatalf("status = %q, want entered_in_error", d.Status)
	}
	if len(d.Sections) == 0 {
		t.Fatal("retracting the document erased its content")
	}
	if _, err := d.Sign("sig-2", "doctor-1", domain.MeaningAuthor, now); err == nil {
		t.Fatal("a retracted document was signed")
	}
}

// SRS-CLN-015: "user-visible expansion and no hidden clinical text".
//
// A note that renders differently to its author and its reader is a note
// nobody can rely on.
func TestSmartPhrasesAreExpandedBeforeTheNoteIsStored(t *testing.T) {
	phrases := []domain.SmartPhrase{
		{ID: "sp-1", Shortcut: "normalcvs",
			Expansion: "Heart sounds I and II, no murmur. Pulse regular."},
		{ID: "sp-2", Shortcut: "normalresp",
			Expansion: "Chest clear, air entry equal."},
	}

	expanded, used := domain.ExpandSmartPhrases(
		"On examination: .normalcvs .normalresp No oedema.", phrases)

	if strings.Contains(expanded, ".normalcvs") {
		t.Fatalf("a shortcut survived into the stored note: %q", expanded)
	}
	if !strings.Contains(expanded, "no murmur") ||
		!strings.Contains(expanded, "air entry equal") {
		t.Fatalf("the expansion is missing: %q", expanded)
	}
	if len(used) != 2 {
		t.Fatalf("%d phrases reported as used, want 2", len(used))
	}

	// Text with no shortcuts comes back untouched, and nothing is reported.
	plain, none := domain.ExpandSmartPhrases("No abnormality detected.", phrases)
	if plain != "No abnormality detected." || len(none) != 0 {
		t.Fatalf("plain text was rewritten: %q, used %v", plain, none)
	}
}

// SRS-CLN-019: a restricted note is classified on the record itself, so the
// filter that applies it has something to read.
func TestADocumentCarriesItsConfidentialityClass(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	restricted, err := domain.NewDocument("doc-1", "t-1", domain.NewDocumentInput{
		PatientID: "p-1", EncounterID: "e-1", Kind: domain.DocumentConsultationNote,
		Sections:        sections("Mental health review."),
		Confidentiality: domain.ConfidentialityRestricted,
	}, "psych-1", now)
	if err != nil {
		t.Fatalf("NewDocument: %v", err)
	}
	if !restricted.Confidentiality.Restricted() {
		t.Fatal("a restricted note does not report itself as restricted")
	}

	if _, err := domain.NewDocument("doc-2", "t-1", domain.NewDocumentInput{
		PatientID: "p-1", EncounterID: "e-1", Kind: domain.DocumentProgressNote,
		Sections: sections("Routine."), Confidentiality: "invented_later",
	}, "doctor-1", now); err == nil {
		t.Fatal("a document was stored with an unrecognised confidentiality class")
	}
}

// Over-restricting is an inconvenience somebody reports; under-restricting is
// a disclosure nobody notices.
func TestAnUnknownConfidentialityClassCountsAsRestricted(t *testing.T) {
	if !domain.Confidentiality("invented_by_a_later_version").Restricted() {
		t.Fatal("an unrecognised confidentiality class was treated as ordinary content")
	}
}

// A note with no encounter cannot be placed in time or context.
func TestADocumentNeedsAPatientAndAnEncounter(t *testing.T) {
	now := at(2026, time.March, 3, 9)

	cases := map[string]domain.NewDocumentInput{
		"no patient": {
			EncounterID: "e-1", Kind: domain.DocumentProgressNote,
			Confidentiality: domain.ConfidentialityNormal,
		},
		"no encounter": {
			PatientID: "p-1", Kind: domain.DocumentProgressNote,
			Confidentiality: domain.ConfidentialityNormal,
		},
		"unknown kind": {
			PatientID: "p-1", EncounterID: "e-1", Kind: "haiku",
			Confidentiality: domain.ConfidentialityNormal,
		},
	}
	for name, in := range cases {
		t.Run(name, func(t *testing.T) {
			if _, err := domain.NewDocument("doc-1", "t-1", in, "doctor-1", now); err == nil {
				t.Fatalf("a document with %s was accepted", name)
			}
		})
	}
}
