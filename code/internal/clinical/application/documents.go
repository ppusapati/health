package application

import (
	"context"
	"strconv"
	"strings"

	"github.com/ppusapati/health/code/internal/clinical/domain"
	"github.com/ppusapati/health/code/internal/clinical/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Clinical documents, signatures, templates and smart phrases
// (SRS-CLN-002, 008, 009, 015, 016, 019).

// WriteNoteInput starts or revises a clinical note.
type WriteNoteInput struct {
	// DocumentID revises an existing draft. Empty starts a new one.
	DocumentID      string
	PatientID       string
	EncounterID     string
	Kind            domain.DocumentKind
	TemplateID      string
	TemplateVersion string
	Title           string
	Sections        []domain.Section
	Confidentiality domain.Confidentiality
	// Dictated marks content that arrived from speech recognition
	// (SRS-CLN-016).
	Dictated bool
	// ExpectedVersion guards a revision against a concurrent edit.
	ExpectedVersion int64
	// Context is the chart the caller believes they are working in
	// (SRS-CLN-017).
	Context domain.PatientContext
}

// WriteNote starts or revises a draft note (SRS-CLN-002, SRS-CLN-008).
//
// Smart phrases are expanded here, before storage, so what is signed is what a
// reader sees (SRS-CLN-015). A note that rendered differently to its author and
// its reader would be a note nobody can rely on.
func (s *Service) WriteNote(ctx context.Context, in WriteNoteInput) (
	*domain.Document, error) {

	session, scope, err := s.authorize(ctx, PermClinicalWrite, "document",
		in.DocumentID, true)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()

	var out *domain.Document
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		phrases, err := s.phrasesFor(ctx, scope, session.SubjectID)
		if err != nil {
			return err
		}
		sections, expansions := expandSections(in.Sections, phrases)

		if in.DocumentID != "" {
			document, err := s.documents.Get(ctx, scope, in.DocumentID)
			if err != nil {
				return err
			}
			if err := checkContext(in.Context, document.PatientID,
				document.EncounterID, "editing this note", now); err != nil {
				return err
			}

			before := document.Version
			if err := document.Revise(in.Title, sections, now); err != nil {
				return clinicalError(err)
			}
			if err := s.documents.UpdateDraft(ctx, scope, document, before); err != nil {
				return err
			}
			out = document
			return s.appendAudit(ctx, session, audit.Record{
				TenantID: session.TenantID, Action: PermClinicalWrite,
				ResourceType: "document", ResourceID: document.ID(),
				Outcome: audit.OutcomeSuccess, Reason: "draft revised",
			}, now)
		}

		if err := checkContext(in.Context, in.PatientID, in.EncounterID,
			"writing this note", now); err != nil {
			return err
		}
		if err := s.requireWritableEncounter(ctx, scope, in.EncounterID,
			in.PatientID); err != nil {
			return err
		}
		if err := s.requireTemplate(ctx, scope, in.TemplateID, in.TemplateVersion); err != nil {
			return err
		}

		confidentiality := in.Confidentiality
		if confidentiality == "" {
			confidentiality = domain.ConfidentialityNormal
		}

		document, err := domain.NewDocument(s.ids.NewID(), scope.TenantID(),
			domain.NewDocumentInput{
				PatientID: in.PatientID, EncounterID: in.EncounterID, Kind: in.Kind,
				TemplateID: in.TemplateID, TemplateVersion: in.TemplateVersion,
				Title: in.Title, Sections: sections,
				Confidentiality: confidentiality, Dictated: in.Dictated,
			}, session.SubjectID, now)
		if err != nil {
			return clinicalError(err)
		}
		if err := s.documents.Insert(ctx, scope, document); err != nil {
			return err
		}

		out = document
		reason := "draft created"
		if len(expansions) > 0 {
			reason += " with expanded phrases"
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalWrite,
			ResourceType: "document", ResourceID: document.ID(),
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return out, nil
}

// requireTemplate refuses a note composed against a template that does not
// exist or has been retired.
//
// A retired template can still be read on an old note but must not be chosen
// for a new one: it asks questions the hospital has decided are the wrong ones.
func (s *Service) requireTemplate(ctx context.Context, scope authctx.TenantScope,
	templateID, version string) error {

	if templateID == "" {
		return nil
	}
	if version == "" {
		// An unversioned reference makes the note ambiguous the first time
		// somebody edits the template's wording.
		return rpcerr.Invalid("CLN_TEMPLATE_VERSION_REQUIRED",
			"a note composed against a template must name the exact version")
	}

	template, err := s.templates.Get(ctx, scope, templateID, version)
	if err != nil {
		return err
	}
	if template.Retired {
		return rpcerr.FailedPrecondition("CLN_TEMPLATE_RETIRED",
			"that template version has been retired; choose the current one")
	}
	return nil
}

// phrasesFor loads a clinician's shortcuts, theirs overriding the shared ones.
func (s *Service) phrasesFor(ctx context.Context, scope authctx.TenantScope,
	subjectID string) ([]domain.SmartPhrase, error) {

	if s.phrases == nil {
		return nil, nil
	}
	return s.phrases.ForAuthor(ctx, scope, subjectID)
}

// expandSections rewrites shortcuts into their text (SRS-CLN-015).
func expandSections(sections []domain.Section, phrases []domain.SmartPhrase) (
	[]domain.Section, []string) {

	if len(phrases) == 0 {
		return sections, nil
	}

	out := make([]domain.Section, 0, len(sections))
	used := make([]string, 0)
	for _, section := range sections {
		expanded, ids := domain.ExpandSmartPhrases(section.Text, phrases)
		section.Text = expanded
		used = append(used, ids...)
		out = append(out, section)
	}
	return out, used
}

// SignNoteInput finalises a document.
type SignNoteInput struct {
	DocumentID string
	Meaning    domain.SignatureMeaning
	Context    domain.PatientContext
}

// SignNote finalises a clinical document (SRS-CLN-009).
//
// After this the content is immutable, and the signature pins a hash of exactly
// what was asserted. A separate permission from writing, because signing is an
// assertion of clinical responsibility rather than an act of data entry.
func (s *Service) SignNote(ctx context.Context, in SignNoteInput) (
	*domain.Document, error) {

	session, scope, err := s.authorize(ctx, PermClinicalSign, "document",
		in.DocumentID, true)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()
	meaning := in.Meaning
	if meaning == "" {
		meaning = domain.MeaningAuthor
	}

	var out *domain.Document
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		document, err := s.documents.Get(ctx, scope, in.DocumentID)
		if err != nil {
			return err
		}
		if err := checkContext(in.Context, document.PatientID, document.EncounterID,
			"signing this note", now); err != nil {
			return err
		}

		before := document.Version
		wasSigned := document.Signed()

		signature, err := document.Sign(s.ids.NewID(), session.SubjectID, meaning, now)
		if err != nil {
			return clinicalError(err)
		}
		if err := s.documents.AddSignature(ctx, scope, signature); err != nil {
			return err
		}

		if document.Signed() != wasSigned {
			if err := s.documents.SetStatus(ctx, scope, document, before); err != nil {
				return err
			}
			if err := s.appendEvent(ctx, session, EventDocumentSigned, "document",
				document.ID(), map[string]any{
					"document_id":  document.ID(),
					"patient_id":   document.PatientID,
					"encounter_id": document.EncounterID,
					"kind":         string(document.Kind),
					// The hash, never the content: an event stream is read
					// under fewer controls than the chart.
					"content_hash": signature.ContentHash,
					"signed_by":    session.SubjectID,
					"meaning":      string(signature.Meaning),
					// So a consumer can tell restricted content apart without
					// being able to read it.
					"confidentiality": string(document.Confidentiality),
				}, now); err != nil {
				return err
			}
		}

		out = document
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalSign,
			ResourceType: "document", ResourceID: document.ID(),
			Outcome: audit.OutcomeSuccess, Reason: "signed as " + string(meaning),
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return out, nil
}

// AmendNoteInput replaces or extends a signed document.
type AmendNoteInput struct {
	DocumentID string
	Title      string
	Sections   []domain.Section
	// Reason is required for an amendment and absent for an addendum: an
	// addendum does not contradict anything, it adds what was not yet known.
	Reason string
	// Addendum extends rather than replaces.
	Addendum bool
	Context  domain.PatientContext
}

// AmendNote produces a new document replacing or extending a signed one
// (SRS-CLN-008).
func (s *Service) AmendNote(ctx context.Context, in AmendNoteInput) (
	*domain.Document, error) {

	session, scope, err := s.authorize(ctx, PermClinicalWrite, "document",
		in.DocumentID, true)
	if err != nil {
		return nil, err
	}

	now := s.clock.Now()

	var out *domain.Document
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		original, err := s.documents.Get(ctx, scope, in.DocumentID)
		if err != nil {
			return err
		}
		if err := checkContext(in.Context, original.PatientID, original.EncounterID,
			"amending this note", now); err != nil {
			return err
		}

		phrases, err := s.phrasesFor(ctx, scope, session.SubjectID)
		if err != nil {
			return err
		}
		sections, _ := expandSections(in.Sections, phrases)

		var next *domain.Document
		if in.Addendum {
			next, err = original.AddAddendum(s.ids.NewID(), in.Title, sections,
				session.SubjectID, now)
		} else {
			next, err = original.Amend(s.ids.NewID(), in.Title, sections,
				in.Reason, session.SubjectID, now)
		}
		if err != nil {
			return clinicalError(err)
		}
		if err := s.documents.Insert(ctx, scope, next); err != nil {
			return err
		}

		out = next
		kind := "amended"
		if in.Addendum {
			kind = "addendum added to"
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalWrite,
			ResourceType: "document", ResourceID: next.ID(),
			Outcome: audit.OutcomeSuccess,
			Reason:  kind + " " + original.ID(),
		}, now)
	})
	if err != nil {
		return nil, mapConflict(err)
	}
	return out, nil
}

// RetractNoteInput marks a document that should never have existed.
type RetractNoteInput struct {
	DocumentID string
	Reason     string
}

// RetractNote marks a document entered in error (SRS-CLN-008).
//
// Retained rather than deleted: somebody may have read and acted on it, and a
// record that vanishes cannot explain a decision that was made from it.
func (s *Service) RetractNote(ctx context.Context, in RetractNoteInput) error {
	session, scope, err := s.authorize(ctx, PermClinicalWrite, "document",
		in.DocumentID, true)
	if err != nil {
		return err
	}

	now := s.clock.Now()

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		document, err := s.documents.Get(ctx, scope, in.DocumentID)
		if err != nil {
			return err
		}
		before := document.Version
		if err := document.Retract(in.Reason, now); err != nil {
			return clinicalError(err)
		}
		if err := s.documents.SetStatus(ctx, scope, document, before); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalWrite,
			ResourceType: "document", ResourceID: document.ID(),
			Outcome: audit.OutcomeSuccess, Reason: "retracted: " + in.Reason,
		}, now)
	})
}

// GetNote reads one document with its signatures.
func (s *Service) GetNote(ctx context.Context, documentID string) (
	*domain.Document, error) {

	session, scope, err := s.authorize(ctx, PermClinicalRead, "document",
		documentID, false)
	if err != nil {
		return nil, err
	}

	var out *domain.Document
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		document, err := s.documents.Get(ctx, scope, documentID)
		if err != nil {
			return err
		}
		if !visible(session, document.Confidentiality) {
			// Not-found rather than permission-denied: confirming that a
			// restricted note exists is itself a disclosure, and the whole
			// point of the class is that its existence is not public
			// (SRS-CLN-019).
			return rpcerr.NotFound("CLN_NOT_FOUND", "no such clinical record")
		}

		out = document
		reason := "note read"
		if document.Confidentiality.Restricted() {
			// SRS-CLN-019: a restricted read is explicitly audited.
			reason = "restricted note read"
			if session.BreakGlass {
				reason += " (break-glass)"
			}
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalRead,
			ResourceType: "document", ResourceID: documentID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, s.clock.Now())
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// ListNotesInput narrows a document listing.
type ListNotesInput struct {
	PatientID     string
	EncounterID   string
	Kind          domain.DocumentKind
	IncludeDrafts bool
	PageSize      int32
}

// ListNotes returns a patient's documents, newest first.
//
// Restricted notes the reader may not see are dropped rather than masked here,
// because a document list is a list of things to open and an entry that cannot
// be opened is a dead end. The timeline is where their existence is shown
// (SRS-ENC-011).
func (s *Service) ListNotes(ctx context.Context, in ListNotesInput) (
	[]*domain.Document, error) {

	session, scope, err := s.authorize(ctx, PermClinicalRead, "document",
		in.PatientID, false)
	if err != nil {
		return nil, err
	}
	if in.PatientID == "" {
		return nil, rpcerr.Invalid("CLN_LIST_UNFILTERED", "a note listing needs a patient")
	}

	var out []*domain.Document
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		documents, err := s.documents.ForPatient(ctx, scope, ports.DocumentQuery{
			PatientID: in.PatientID, EncounterID: in.EncounterID, Kind: in.Kind,
			IncludeDrafts: in.IncludeDrafts, Limit: clampPageSize(in.PageSize),
		})
		if err != nil {
			return err
		}

		withheld := 0
		visibleDocs := make([]*domain.Document, 0, len(documents))
		for _, d := range documents {
			if !visible(session, d.Confidentiality) {
				withheld++
				continue
			}
			visibleDocs = append(visibleDocs, d)
		}
		out = visibleDocs

		reason := "note listing"
		if withheld > 0 {
			reason = "note listing with " + strconv.Itoa(withheld) + " restricted entries withheld"
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalRead,
			ResourceType: "document", ResourceID: in.PatientID,
			Outcome: audit.OutcomeSuccess, Reason: reason,
		}, s.clock.Now())
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// DefineTemplate publishes a versioned note structure (SRS-CLN-002).
func (s *Service) DefineTemplate(ctx context.Context, t domain.Template) error {
	session, scope, err := s.authorize(ctx, PermClinicalConfigure, "template",
		t.ID, true)
	if err != nil {
		return err
	}
	if err := t.Validate(); err != nil {
		return clinicalError(err)
	}
	if t.ID == "" {
		t.ID = s.ids.NewID()
	}

	now := s.clock.Now()

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.templates.Insert(ctx, scope, t, session.SubjectID, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalConfigure,
			ResourceType: "template", ResourceID: t.ID,
			Outcome: audit.OutcomeSuccess, Reason: "published version " + t.Version,
		}, now)
	})
}

// ListTemplates returns the templates a clinician may choose from.
func (s *Service) ListTemplates(ctx context.Context, kind domain.DocumentKind,
	includeRetired bool, pageSize int32) ([]domain.Template, error) {

	_, scope, err := s.authorize(ctx, PermClinicalRead, "template", "", false)
	if err != nil {
		return nil, err
	}

	var out []domain.Template
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		out, err = s.templates.List(ctx, scope, kind, includeRetired,
			clampPageSize(pageSize))
		return err
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// RetireTemplate stops a template being chosen for new notes.
func (s *Service) RetireTemplate(ctx context.Context, templateID, version string) error {
	session, scope, err := s.authorize(ctx, PermClinicalConfigure, "template",
		templateID, true)
	if err != nil {
		return err
	}

	now := s.clock.Now()

	return s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.templates.Retire(ctx, scope, templateID, version); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: PermClinicalConfigure,
			ResourceType: "template", ResourceID: templateID,
			Outcome: audit.OutcomeSuccess, Reason: "retired version " + version,
		}, now)
	})
}

// DefineSmartPhrase stores a shortcut (SRS-CLN-015).
//
// Owned by the clinician who created it unless they are configuring a shared
// one, which needs the configuration permission: a shared phrase changes what
// everybody's notes say.
func (s *Service) DefineSmartPhrase(ctx context.Context, shortcut, expansion string,
	shared bool) (domain.SmartPhrase, error) {

	permission := PermClinicalWrite
	if shared {
		permission = PermClinicalConfigure
	}

	session, scope, err := s.authorize(ctx, permission, "smart_phrase", shortcut, true)
	if err != nil {
		return domain.SmartPhrase{}, err
	}

	shortcut = strings.TrimSpace(shortcut)
	expansion = strings.TrimSpace(expansion)
	switch {
	case shortcut == "":
		return domain.SmartPhrase{}, rpcerr.Invalid("CLN_PHRASE_NO_SHORTCUT",
			"a smart phrase needs a shortcut")
	case expansion == "":
		return domain.SmartPhrase{}, rpcerr.Invalid("CLN_PHRASE_NO_EXPANSION",
			"a smart phrase needs the text it expands to")
	case strings.HasPrefix(shortcut, "."):
		// The marker is added when matching. A shortcut stored with one would
		// only ever match "..normalcvs".
		return domain.SmartPhrase{}, rpcerr.Invalid("CLN_PHRASE_LEADING_MARKER",
			"store the shortcut without its leading dot")
	}

	owner := session.SubjectID
	if shared {
		owner = ""
	}
	phrase := domain.SmartPhrase{
		ID: s.ids.NewID(), OwnerID: owner, Shortcut: shortcut, Expansion: expansion,
	}

	now := s.clock.Now()
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		if err := s.phrases.Upsert(ctx, scope, phrase, now); err != nil {
			return err
		}
		return s.appendAudit(ctx, session, audit.Record{
			TenantID: session.TenantID, Action: permission,
			ResourceType: "smart_phrase", ResourceID: shortcut,
			Outcome: audit.OutcomeSuccess, Reason: "phrase defined",
		}, now)
	})
	if err != nil {
		return domain.SmartPhrase{}, err
	}
	return phrase, nil
}

// ListSmartPhrases returns a clinician's shortcuts and the shared ones.
func (s *Service) ListSmartPhrases(ctx context.Context) ([]domain.SmartPhrase, error) {
	session, scope, err := s.authorize(ctx, PermClinicalRead, "smart_phrase", "", false)
	if err != nil {
		return nil, err
	}

	var out []domain.SmartPhrase
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		out, err = s.phrases.ForAuthor(ctx, scope, session.SubjectID)
		return err
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// HasSignedDocument answers the encounter context's closure gate
// (SRS-ENC-008).
//
// Exposed on the service rather than only on the repository because the
// encounter context reaches it through a port, and a port onto a repository
// would let that context write here.
func (s *Service) HasSignedDocument(ctx context.Context, encounterID string) (
	bool, error) {

	_, scope, err := s.authorize(ctx, PermClinicalRead, "document", encounterID, false)
	if err != nil {
		return false, err
	}

	var out bool
	err = s.uow.WithinTx(ctx, func(ctx context.Context) error {
		var err error
		out, err = s.documents.HasSignedDocument(ctx, scope, encounterID)
		return err
	})
	if err != nil {
		return false, err
	}
	return out, nil
}
