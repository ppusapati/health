package postgres

import (
	"context"
	"encoding/json"
	"errors"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/clinical/domain"
	"github.com/ppusapati/health/code/internal/clinical/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
	"time"
)

// Clinical documents, signatures and templates
// (SRS-CLN-002, SRS-CLN-008, SRS-CLN-009).

// DocumentRepo implements the document repository port.
type DocumentRepo struct{ *Repository }

var _ ports.DocumentRepository = DocumentRepo{}

// Insert stores a document and the signatures it was constructed with.
func (r DocumentRepo) Insert(ctx context.Context, scope authctx.TenantScope,
	d *domain.Document) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	documentID, err := uuid.Parse(d.ID())
	if err != nil {
		return rpcerr.Internal("CLN_DOCUMENT_ID_INVALID",
			"document_id must be a UUID").WithCause(err)
	}
	patientID, err := uuid.Parse(d.PatientID)
	if err != nil {
		return rpcerr.Invalid("CLN_PATIENT_ID_INVALID", "patient_id must be a UUID")
	}
	encounterID, err := uuid.Parse(d.EncounterID)
	if err != nil {
		return rpcerr.Invalid("CLN_ENCOUNTER_ID_INVALID", "encounter_id must be a UUID")
	}
	templateID, err := optionalUUID(d.TemplateID)
	if err != nil {
		return err
	}
	amends, err := optionalUUID(d.AmendsID)
	if err != nil {
		return err
	}
	addsTo, err := optionalUUID(d.AddsToID)
	if err != nil {
		return err
	}

	// Sections as ordered JSON rather than a child table: a note is read and
	// written whole, never by section, and the order is part of what was
	// signed.
	sections, err := json.Marshal(d.Sections)
	if err != nil {
		return rpcerr.Internal("CLN_SECTIONS_ENCODE_FAILED",
			"could not encode the note").WithCause(err)
	}

	q := r.queries(ctx)
	if err := q.InsertDocument(ctx, sqlcgen.InsertDocumentParams{
		DocumentID: documentID, TenantID: tenantID, PatientID: patientID,
		EncounterID: encounterID, Kind: string(d.Kind), TemplateID: templateID,
		TemplateVersion: d.TemplateVersion, Title: d.Title, Sections: sections,
		Status: string(d.Status), Confidentiality: string(d.Confidentiality),
		AmendsID: amends, AddsToID: addsTo, ChangeReason: d.ChangeReason,
		RetractionReason: d.RetractionReason, Dictated: d.Dictated,
		AuthoredBy: d.AuthoredBy,
		CreatedAt:  timestamptz(d.CreatedAt), UpdatedAt: timestamptz(d.UpdatedAt),
	}); err != nil {
		return err
	}

	for _, s := range d.Signatures {
		if err := r.addSignature(ctx, q, tenantID, s); err != nil {
			return err
		}
	}
	return nil
}

// Get reads one document with its signatures.
func (r DocumentRepo) Get(ctx context.Context, scope authctx.TenantScope,
	documentID string) (*domain.Document, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(documentID)
	if err != nil {
		return nil, notFound()
	}

	row, err := r.queries(ctx).GetDocument(ctx, sqlcgen.GetDocumentParams{
		TenantID: tenantID, DocumentID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, notFound()
	}
	if err != nil {
		return nil, err
	}

	d, err := documentFromRow(sqlcgen.ClinicalDocument(row))
	if err != nil {
		return nil, err
	}
	signatures, err := r.Signatures(ctx, scope, documentID)
	if err != nil {
		return nil, err
	}
	d.Signatures = signatures
	return d, nil
}

// UpdateDraft edits a draft in place.
func (r DocumentRepo) UpdateDraft(ctx context.Context, scope authctx.TenantScope,
	d *domain.Document, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	documentID, err := uuid.Parse(d.ID())
	if err != nil {
		return notFound()
	}
	sections, err := json.Marshal(d.Sections)
	if err != nil {
		return rpcerr.Internal("CLN_SECTIONS_ENCODE_FAILED",
			"could not encode the note").WithCause(err)
	}

	rows, err := r.queries(ctx).UpdateDocumentDraft(ctx, sqlcgen.UpdateDocumentDraftParams{
		TenantID: tenantID, DocumentID: documentID, Title: d.Title,
		Sections: sections, UpdatedAt: timestamptz(d.UpdatedAt),
		ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		// Either somebody else edited it, or it is no longer a draft. The
		// second is SRS-CLN-008 holding at the table: a signed document cannot
		// be edited in place even by a caller that skipped the domain check.
		return ports.ErrVersionConflict
	}
	d.Version = expectedVersion + 1
	return nil
}

// SetStatus moves a document through its lifecycle.
func (r DocumentRepo) SetStatus(ctx context.Context, scope authctx.TenantScope,
	d *domain.Document, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	documentID, err := uuid.Parse(d.ID())
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).SetDocumentStatus(ctx, sqlcgen.SetDocumentStatusParams{
		TenantID: tenantID, DocumentID: documentID, Status: string(d.Status),
		RetractionReason: d.RetractionReason, UpdatedAt: timestamptz(d.UpdatedAt),
		ExpectedVersion: expectedVersion,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrVersionConflict
	}
	d.Version = expectedVersion + 1
	return nil
}

// ForPatient returns a patient's documents, newest first.
func (r DocumentRepo) ForPatient(ctx context.Context, scope authctx.TenantScope,
	q ports.DocumentQuery) ([]*domain.Document, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	patientID, err := uuid.Parse(q.PatientID)
	if err != nil {
		return nil, notFound()
	}
	encounterID, err := optionalUUID(q.EncounterID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListDocumentsForPatient(ctx,
		sqlcgen.ListDocumentsForPatientParams{
			TenantID: tenantID, PatientID: patientID, EncounterID: encounterID,
			KindFilter: string(q.Kind), IncludeDrafts: q.IncludeDrafts,
			PageLimit: q.Limit,
		})
	if err != nil {
		return nil, err
	}

	out := make([]*domain.Document, 0, len(rows))
	for _, row := range rows {
		d, err := documentFromRow(sqlcgen.ClinicalDocument(row))
		if err != nil {
			return nil, err
		}
		out = append(out, d)
	}
	return out, nil
}

// HasSignedDocument answers the encounter context's closure gate.
func (r DocumentRepo) HasSignedDocument(ctx context.Context, scope authctx.TenantScope,
	encounterID string) (bool, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return false, err
	}
	id, err := uuid.Parse(encounterID)
	if err != nil {
		return false, notFound()
	}

	count, err := r.queries(ctx).CountSignedDocuments(ctx,
		sqlcgen.CountSignedDocumentsParams{TenantID: tenantID, EncounterID: id})
	if err != nil {
		return false, err
	}
	return count > 0, nil
}

// AddSignature stores one assertion about one version of a document.
func (r DocumentRepo) AddSignature(ctx context.Context, scope authctx.TenantScope,
	s domain.Signature) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	return r.addSignature(ctx, r.queries(ctx), tenantID, s)
}

func (r DocumentRepo) addSignature(ctx context.Context, q *sqlcgen.Queries,
	tenantID uuid.UUID, s domain.Signature) error {

	signatureID, err := uuid.Parse(s.ID)
	if err != nil {
		return rpcerr.Internal("CLN_SIGNATURE_ID_INVALID",
			"signature_id must be a UUID").WithCause(err)
	}
	documentID, err := uuid.Parse(s.DocumentID)
	if err != nil {
		return notFound()
	}

	return q.InsertSignature(ctx, sqlcgen.InsertSignatureParams{
		SignatureID: signatureID, TenantID: tenantID, DocumentID: documentID,
		SubjectID: s.SubjectID, Meaning: string(s.Meaning),
		SignedAt: timestamptz(s.SignedAt), ContentHash: s.ContentHash,
		TemplateVersion: s.TemplateVersion,
	})
}

// Signatures returns a document's signatures, earliest first.
func (r DocumentRepo) Signatures(ctx context.Context, scope authctx.TenantScope,
	documentID string) ([]domain.Signature, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(documentID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListSignatures(ctx, sqlcgen.ListSignaturesParams{
		TenantID: tenantID, DocumentID: id,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Signature, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Signature{
			ID: row.SignatureID.String(), DocumentID: row.DocumentID.String(),
			SubjectID: row.SubjectID, Meaning: domain.SignatureMeaning(row.Meaning),
			SignedAt: timeOrZero(row.SignedAt), ContentHash: row.ContentHash,
			TemplateVersion: row.TemplateVersion,
		})
	}
	return out, nil
}

func documentFromRow(row sqlcgen.ClinicalDocument) (*domain.Document, error) {
	var sections []domain.Section
	if len(row.Sections) > 0 {
		if err := json.Unmarshal(row.Sections, &sections); err != nil {
			return nil, rpcerr.Internal("CLN_SECTIONS_DECODE_FAILED",
				"could not decode a stored note").WithCause(err)
		}
	}

	return domain.RestoreDocument(row.DocumentID.String(), domain.Document{
		TenantID: row.TenantID.String(), PatientID: row.PatientID.String(),
		EncounterID: row.EncounterID.String(), Kind: domain.DocumentKind(row.Kind),
		TemplateID: uuidOrEmpty(row.TemplateID), TemplateVersion: row.TemplateVersion,
		Title: row.Title, Sections: sections,
		Status:          domain.DocumentStatus(row.Status),
		Confidentiality: domain.Confidentiality(row.Confidentiality),
		AmendsID:        uuidOrEmpty(row.AmendsID), AddsToID: uuidOrEmpty(row.AddsToID),
		ChangeReason: row.ChangeReason, RetractionReason: row.RetractionReason,
		Dictated: row.Dictated, AuthoredBy: row.AuthoredBy,
		CreatedAt: timeOrZero(row.CreatedAt), UpdatedAt: timeOrZero(row.UpdatedAt),
		Version: row.Version,
	}), nil
}

// TemplateRepo implements the template repository port (SRS-CLN-002).
type TemplateRepo struct{ *Repository }

var _ ports.TemplateRepository = TemplateRepo{}

// Insert stores a versioned note structure.
func (r TemplateRepo) Insert(ctx context.Context, scope authctx.TenantScope,
	t domain.Template, createdBy string, now time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	templateID, err := uuid.Parse(t.ID)
	if err != nil {
		return rpcerr.Internal("CLN_TEMPLATE_ID_INVALID",
			"template_id must be a UUID").WithCause(err)
	}

	return r.queries(ctx).InsertTemplate(ctx, sqlcgen.InsertTemplateParams{
		TemplateID: templateID, TenantID: tenantID, Version: t.Version,
		Name: t.Name, Kind: string(t.Kind), Specialty: t.Specialty,
		Sections: orEmpty(t.Sections), CreatedBy: createdBy,
		CreatedAt: timestamptz(now),
	})
}

// Get reads one version of one template.
func (r TemplateRepo) Get(ctx context.Context, scope authctx.TenantScope,
	templateID, version string) (domain.Template, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return domain.Template{}, err
	}
	id, err := uuid.Parse(templateID)
	if err != nil {
		return domain.Template{}, notFound()
	}

	row, err := r.queries(ctx).GetTemplate(ctx, sqlcgen.GetTemplateParams{
		TenantID: tenantID, TemplateID: id, Version: version,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Template{}, notFound()
	}
	if err != nil {
		return domain.Template{}, err
	}
	return templateFromRow(sqlcgen.ClinicalTemplate(row)), nil
}

// List returns the templates a clinician may choose from.
func (r TemplateRepo) List(ctx context.Context, scope authctx.TenantScope,
	kind domain.DocumentKind, includeRetired bool, limit int32) (
	[]domain.Template, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListTemplates(ctx, sqlcgen.ListTemplatesParams{
		TenantID: tenantID, IncludeRetired: includeRetired,
		KindFilter: string(kind), PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Template, 0, len(rows))
	for _, row := range rows {
		out = append(out, templateFromRow(sqlcgen.ClinicalTemplate(row)))
	}
	return out, nil
}

// Retire stops a template being chosen for a new note. Old notes still read.
func (r TemplateRepo) Retire(ctx context.Context, scope authctx.TenantScope,
	templateID, version string) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := uuid.Parse(templateID)
	if err != nil {
		return notFound()
	}

	rows, err := r.queries(ctx).RetireTemplate(ctx, sqlcgen.RetireTemplateParams{
		TenantID: tenantID, TemplateID: id, Version: version,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return notFound()
	}
	return nil
}

func templateFromRow(row sqlcgen.ClinicalTemplate) domain.Template {
	return domain.Template{
		ID: row.TemplateID.String(), Name: row.Name, Version: row.Version,
		Kind: domain.DocumentKind(row.Kind), Specialty: row.Specialty,
		Sections: row.Sections, Retired: row.Retired,
	}
}

// SmartPhraseRepo implements the smart-phrase port (SRS-CLN-015).
type SmartPhraseRepo struct{ *Repository }

var _ ports.SmartPhraseRepository = SmartPhraseRepo{}

// Upsert stores or replaces one shortcut.
func (r SmartPhraseRepo) Upsert(ctx context.Context, scope authctx.TenantScope,
	p domain.SmartPhrase, now time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	phraseID, err := uuid.Parse(p.ID)
	if err != nil {
		return rpcerr.Internal("CLN_PHRASE_ID_INVALID",
			"phrase_id must be a UUID").WithCause(err)
	}

	return r.queries(ctx).UpsertSmartPhrase(ctx, sqlcgen.UpsertSmartPhraseParams{
		PhraseID: phraseID, TenantID: tenantID, OwnerID: p.OwnerID,
		Shortcut: p.Shortcut, Expansion: p.Expansion,
		CreatedAt: timestamptz(now), UpdatedAt: timestamptz(now),
	})
}

// ForAuthor returns a clinician's own phrases and the tenant's shared ones.
func (r SmartPhraseRepo) ForAuthor(ctx context.Context, scope authctx.TenantScope,
	ownerID string) ([]domain.SmartPhrase, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListSmartPhrases(ctx, sqlcgen.ListSmartPhrasesParams{
		TenantID: tenantID, OwnerID: ownerID,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.SmartPhrase, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.SmartPhrase{
			ID: row.PhraseID.String(), OwnerID: row.OwnerID,
			Shortcut: row.Shortcut, Expansion: row.Expansion,
		})
	}
	return out, nil
}

// TimelineRepo supplies the clinical half of the longitudinal timeline.
type TimelineRepo struct{ *Repository }

var _ ports.TimelineRepository = TimelineRepo{}

// Entries returns a patient's clinical timeline entries, newest first.
func (r TimelineRepo) Entries(ctx context.Context, scope authctx.TenantScope,
	patientID string, from, until time.Time, limit int32) (
	[]ports.TimelineEntry, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	patient, err := uuid.Parse(patientID)
	if err != nil {
		return nil, notFound()
	}

	rows, err := r.queries(ctx).ListTimelineEntries(ctx, sqlcgen.ListTimelineEntriesParams{
		TenantID: tenantID, PatientID: patient,
		FromAt: timestamptz(from), UntilAt: timestamptz(until), PageLimit: limit,
	})
	if err != nil {
		return nil, err
	}

	out := make([]ports.TimelineEntry, 0, len(rows))
	for _, row := range rows {
		out = append(out, ports.TimelineEntry{
			ID: row.EntryID.String(), Kind: row.Kind, At: timeOrZero(row.At),
			EncounterID: row.EncounterID.String(), Title: row.Title,
			Confidentiality: domain.Confidentiality(row.Confidentiality),
			AuthorID:        row.AuthoredBy,
		})
	}
	return out, nil
}
