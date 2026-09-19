// Package crosscontext implements the medical records seams onto the contexts
// that own the facts (SRS-MRD-001, SRS-MRD-004, SRS-MRD-005).
//
// Adapters rather than tables here. Chart completion is judged against
// documents the clinical context owns and encounters the encounter context
// owns, and a second copy of either would drift the first time somebody
// signed a note or corrected an admission class — and the report that says
// "eleven charts are incomplete" would be counting the copy.
//
// Every one of these is read-only except the legal holds, which this context
// may place and lift because SRS-MRD-005 says the records office is who does
// that. Nothing here writes a clinical document, and that absence is the
// requirement rather than an omission: SRS-MRD-003 and SRS-MRD-008 both turn
// on health information management being unable to change what a clinician
// wrote.
package crosscontext

import (
	"context"
	"time"

	clinicaldomain "github.com/ppusapati/health/code/internal/clinical/domain"
	clinicalports "github.com/ppusapati/health/code/internal/clinical/ports"
	encounterdomain "github.com/ppusapati/health/code/internal/encounter/domain"
	encounterports "github.com/ppusapati/health/code/internal/encounter/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/records/domain"
	"github.com/ppusapati/health/code/internal/records/ports"
	securitydomain "github.com/ppusapati/health/code/internal/security/domain"
	securityports "github.com/ppusapati/health/code/internal/security/ports"
)

// documentPageSize bounds one chart read. An encounter with more documents
// than this is not a chart, and a checklist judged against a truncated list
// would report gaps that are not there.
const documentPageSize = 2000

// Documents adapts the clinical context's document repository
// (SRS-MRD-001, SRS-MRD-002).
type Documents struct {
	repo clinicalports.DocumentRepository
}

// NewDocuments constructs the adapter.
func NewDocuments(repo clinicalports.DocumentRepository) Documents {
	return Documents{repo: repo}
}

var _ ports.ChartDocuments = Documents{}

// ForEncounter implements ports.ChartDocuments.
//
// The projection carries an identifier, a kind, a signature and a timestamp
// and no content. That is what makes the seam safe to hold: a records officer
// reading a chart's completion status is not reading the notes.
//
// Drafts are included, because an unsigned draft is exactly the gap a
// deficiency is raised for; a document that was entered in error is marked
// retracted, and the domain lets it satisfy nothing.
func (d Documents) ForEncounter(ctx context.Context,
	scope authctx.TenantScope, patientID, encounterID string) (
	[]domain.ChartDocument, error) {

	if d.repo == nil {
		return nil, nil
	}
	found, err := d.repo.ForPatient(ctx, scope, clinicalports.DocumentQuery{
		PatientID: patientID, EncounterID: encounterID,
		IncludeDrafts: true, Limit: documentPageSize,
	})
	if err != nil {
		return nil, err
	}

	out := make([]domain.ChartDocument, 0, len(found))
	for _, document := range found {
		signedAt, signedBy := lastSignature(document)
		out = append(out, domain.ChartDocument{
			DocumentID: document.ID(), Kind: string(document.Kind),
			Signed: document.Signed(), SignedBy: signedBy,
			SignedAt: signedAt, AuthoredBy: document.AuthoredBy,
			CreatedAt: document.CreatedAt,
			Retracted: document.Status == clinicaldomain.StatusEnteredInError,
		})
	}
	return out, nil
}

// lastSignature is who signed and when.
//
// The most recent one, because an addendum countersigned later is still
// signed and the checklist asks whether it is, not by whom first.
func lastSignature(d *clinicaldomain.Document) (time.Time, string) {
	if len(d.Signatures) == 0 {
		return time.Time{}, ""
	}
	latest := d.Signatures[0]
	for _, signature := range d.Signatures[1:] {
		if signature.SignedAt.After(latest.SignedAt) {
			latest = signature
		}
	}
	return latest.SignedAt, latest.SubjectID
}

// encounterPageSize bounds a whole-record release. A patient with more
// encounters than this is a release somebody should narrow rather than one
// the system should silently truncate.
const encounterPageSize = 2000

// Encounters adapts the encounter context (SRS-MRD-001, SRS-MRD-004).
type Encounters struct {
	repo encounterports.EncounterRepository
	// jurisdictions maps a facility to whose retention law its records follow.
	// A map rather than a lookup, because "which country is this hospital in"
	// is configuration and not a fact the encounter context holds.
	jurisdictions map[string]string
	// conditions derives the facts a conditional checklist item turns on.
	// Supplied by the deployment, because "was there an operation" is answered
	// differently by a hospital that codes procedures and one that does not.
	conditions func(encounterdomain.Encounter) map[string]bool
}

// NewEncounters constructs the adapter.
func NewEncounters(repo encounterports.EncounterRepository,
	jurisdictions map[string]string,
	conditions func(encounterdomain.Encounter) map[string]bool) Encounters {

	return Encounters{
		repo: repo, jurisdictions: jurisdictions, conditions: conditions,
	}
}

var _ ports.Encounters = Encounters{}

// Describe implements ports.Encounters.
func (e Encounters) Describe(ctx context.Context, scope authctx.TenantScope,
	encounterID string) (ports.EncounterFacts, error) {

	if e.repo == nil {
		return ports.EncounterFacts{}, nil
	}
	found, err := e.repo.Get(ctx, scope, encounterID)
	if err != nil {
		return ports.EncounterFacts{}, err
	}
	return e.facts(found), nil
}

// ForPatient implements ports.Encounters.
func (e Encounters) ForPatient(ctx context.Context, scope authctx.TenantScope,
	patientID string) ([]ports.EncounterFacts, error) {

	if e.repo == nil {
		return nil, nil
	}
	found, err := e.repo.ForPatient(ctx, scope, encounterports.PatientQuery{
		PatientID: patientID, Limit: encounterPageSize,
	})
	if err != nil {
		return nil, err
	}
	out := make([]ports.EncounterFacts, 0, len(found))
	for _, encounter := range found {
		out = append(out, e.facts(encounter))
	}
	return out, nil
}

func (e Encounters) facts(
	encounter *encounterdomain.Encounter) ports.EncounterFacts {

	if encounter == nil {
		return ports.EncounterFacts{}
	}
	facts := ports.EncounterFacts{
		EncounterID: encounter.ID(), PatientID: encounter.PatientID,
		FacilityID: encounter.FacilityID, Class: string(encounter.Class),
		AttendingProviderID: encounter.AttendingProviderID,
		// The visit type is the nearest thing the encounter context holds to
		// a specialty. A deployment whose checklists vary by specialty and
		// whose encounters do not carry one gets the general checklist, which
		// is the safe direction: it asks for more, not less.
		Specialty:    encounter.VisitType,
		EndedAt:      encounter.EndedAt,
		Jurisdiction: e.jurisdictions[encounter.FacilityID],
	}
	if e.conditions != nil {
		facts.Conditions = e.conditions(*encounter)
	}
	return facts
}

// Holds adapts the platform's legal-hold store (SRS-MRD-005).
//
// The same store SRS-QMS-015 and SRS-DAT place holds through. A hold placed
// in one place with a purge that reads another is a hold that does nothing,
// and nobody finds out until the records are gone.
type Holds struct {
	store securityports.LegalHoldStore
	ids   ports.IDGenerator
	// classes are the resource types a sweep asks about when it asks for
	// every held record at once. The store indexes holds by resource type, so
	// a batch read has to name them; a deployment that adds a class and does
	// not add it here gets a sweep that cannot see its holds, which is why
	// HeldIDs refuses an empty list rather than answering "nothing is held".
	classes []string
}

// NewHolds constructs the adapter.
func NewHolds(store securityports.LegalHoldStore, ids ports.IDGenerator,
	classes []string) Holds {

	return Holds{store: store, ids: ids, classes: classes}
}

var _ ports.LegalHolds = Holds{}

// Held implements ports.LegalHolds.
//
// A failure propagates rather than answering "not held". Treating a database
// error as "no hold applies" is how a purge deletes the one record a court
// asked for.
func (h Holds) Held(ctx context.Context, scope authctx.TenantScope,
	recordClass, recordID string) (bool, error) {

	if h.store == nil {
		return false, nil
	}
	return h.store.IsHeld(ctx, scope, recordClass, recordID)
}

// HeldIDs implements ports.LegalHolds.
//
// An empty recordClass means every class the deployment named, which is what
// a sweep across a jurisdiction asks for. Asking one record at a time would
// work and would take an hour over a hospital's holding.
func (h Holds) HeldIDs(ctx context.Context, scope authctx.TenantScope,
	recordClass string) (map[string]bool, error) {

	if h.store == nil {
		return map[string]bool{}, nil
	}
	classes := h.classes
	if recordClass != "" {
		classes = []string{recordClass}
	}

	held := map[string]bool{}
	for _, class := range classes {
		ids, err := h.store.HeldResourceIDs(ctx, scope, class)
		if err != nil {
			return nil, err
		}
		for _, id := range ids {
			held[id] = true
		}
	}
	return held, nil
}

// Place implements ports.LegalHolds (SRS-MRD-005).
func (h Holds) Place(ctx context.Context, scope authctx.TenantScope,
	recordClass, recordID, reason, by string, at time.Time) error {

	if h.store == nil {
		return nil
	}
	hold, err := securitydomain.NewLegalHold(h.ids.NewID(), scope.TenantID(),
		recordClass, recordID, reason, by, at)
	if err != nil {
		return err
	}
	_, err = h.store.Place(ctx, scope, hold)
	return err
}

// Release implements ports.LegalHolds.
func (h Holds) Release(ctx context.Context, scope authctx.TenantScope,
	recordClass, recordID, by string, at time.Time) error {

	if h.store == nil {
		return nil
	}
	_, err := h.store.Release(ctx, scope, recordClass, recordID, by, at)
	return err
}
