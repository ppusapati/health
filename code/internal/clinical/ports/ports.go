// Package ports declares what the clinical application layer needs.
//
// Declared by the consumer rather than by the adapters that implement them,
// which keeps the dependency arrow pointing inward (Blueprint §4.1).
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/clinical/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
)

// ErrVersionConflict reports that another writer advanced the record first.
var ErrVersionConflict = errors.New("clinical: record changed concurrently")

// DocumentRepository persists clinical notes and their signatures
// (SRS-CLN-002, SRS-CLN-008, SRS-CLN-009).
//
// Every method takes authctx.TenantScope, which has no constructor outside the
// auth package, so reaching a row without a verified tenant does not compile
// (FIT-03).
type DocumentRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope, d *domain.Document) error
	Get(ctx context.Context, scope authctx.TenantScope, documentID string) (
		*domain.Document, error)
	// UpdateDraft edits a draft in place. Guarded on the document still being a
	// draft as well as on its version, so SRS-CLN-008's rule holds at the table
	// even for a caller that skipped the domain check.
	UpdateDraft(ctx context.Context, scope authctx.TenantScope, d *domain.Document,
		expectedVersion int64) error
	SetStatus(ctx context.Context, scope authctx.TenantScope, d *domain.Document,
		expectedVersion int64) error
	ForPatient(ctx context.Context, scope authctx.TenantScope, q DocumentQuery) (
		[]*domain.Document, error)
	// HasSignedDocument answers the encounter context's closure gate
	// (SRS-ENC-008).
	HasSignedDocument(ctx context.Context, scope authctx.TenantScope,
		encounterID string) (bool, error)

	AddSignature(ctx context.Context, scope authctx.TenantScope,
		s domain.Signature) error
	Signatures(ctx context.Context, scope authctx.TenantScope, documentID string) (
		[]domain.Signature, error)
}

// DocumentQuery narrows a document listing.
type DocumentQuery struct {
	PatientID   string
	EncounterID string
	Kind        domain.DocumentKind
	// IncludeDrafts shows unfinished work. Off by default: a half-written note
	// read as fact is worse than no note.
	IncludeDrafts bool
	Limit         int32
}

// TemplateRepository persists versioned note structures (SRS-CLN-002).
type TemplateRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope, t domain.Template,
		createdBy string, now time.Time) error
	Get(ctx context.Context, scope authctx.TenantScope, templateID, version string) (
		domain.Template, error)
	List(ctx context.Context, scope authctx.TenantScope, kind domain.DocumentKind,
		includeRetired bool, limit int32) ([]domain.Template, error)
	Retire(ctx context.Context, scope authctx.TenantScope, templateID, version string) error
}

// RecordRepository persists the coded clinical record: problems, allergies,
// observations, procedures and care plans
// (SRS-CLN-003 … SRS-CLN-007, SRS-CLN-011, SRS-CLN-012).
//
// One interface rather than five, because these are read together on every
// clinical screen and a caller assembling a chart would otherwise hold five
// references that always travel as one.
type RecordRepository interface {
	InsertProblem(ctx context.Context, scope authctx.TenantScope, p domain.Problem) error
	GetProblem(ctx context.Context, scope authctx.TenantScope, problemID string) (
		domain.Problem, error)
	UpdateProblem(ctx context.Context, scope authctx.TenantScope, p domain.Problem,
		expectedVersion int64) error
	Problems(ctx context.Context, scope authctx.TenantScope, patientID string,
		activeOnly bool, limit int32) (domain.ProblemList, error)

	InsertAllergy(ctx context.Context, scope authctx.TenantScope, a domain.Allergy) error
	GetAllergy(ctx context.Context, scope authctx.TenantScope, allergyID string) (
		domain.Allergy, error)
	UpdateAllergy(ctx context.Context, scope authctx.TenantScope, a domain.Allergy,
		expectedVersion int64) error
	Allergies(ctx context.Context, scope authctx.TenantScope, patientID string,
		activeOnly bool, limit int32) (domain.AllergyList, error)

	InsertObservation(ctx context.Context, scope authctx.TenantScope,
		o domain.Observation) error
	GetObservation(ctx context.Context, scope authctx.TenantScope, observationID string) (
		domain.Observation, error)
	Observations(ctx context.Context, scope authctx.TenantScope, q ObservationQuery) (
		domain.ObservationList, error)
	// UnacknowledgedCritical is the worklist that must reach a clinician now
	// (SRS-CLN-012).
	UnacknowledgedCritical(ctx context.Context, scope authctx.TenantScope,
		limit int32) (domain.ObservationList, error)
	InsertAcknowledgement(ctx context.Context, scope authctx.TenantScope,
		a domain.CriticalAcknowledgement) error
	Acknowledgement(ctx context.Context, scope authctx.TenantScope,
		observationID string) (domain.CriticalAcknowledgement, bool, error)

	InsertProcedure(ctx context.Context, scope authctx.TenantScope,
		p domain.Procedure) error
	GetProcedure(ctx context.Context, scope authctx.TenantScope, procedureID string) (
		domain.Procedure, error)
	Procedures(ctx context.Context, scope authctx.TenantScope, patientID,
		encounterID string, limit int32) ([]domain.Procedure, error)

	InsertCarePlan(ctx context.Context, scope authctx.TenantScope,
		p domain.CarePlan) error
	GetCarePlan(ctx context.Context, scope authctx.TenantScope, carePlanID string) (
		domain.CarePlan, error)
	UpdateCarePlan(ctx context.Context, scope authctx.TenantScope, p domain.CarePlan,
		expectedVersion int64) error
	CarePlans(ctx context.Context, scope authctx.TenantScope, patientID string,
		activeOnly bool, limit int32) ([]domain.CarePlan, error)
}

// ObservationQuery narrows a result listing.
type ObservationQuery struct {
	PatientID   string
	EncounterID string
	// Code narrows to one measurement, which is what a trend asks for.
	Code  string
	Limit int32
}

// GovernanceRepository persists provenance, attachments and clinical consents
// (SRS-CLN-010, SRS-CLN-013, SRS-CLN-014).
type GovernanceRepository interface {
	InsertProvenance(ctx context.Context, scope authctx.TenantScope,
		p domain.Provenance) error
	Provenance(ctx context.Context, scope authctx.TenantScope,
		recordType, recordID string) ([]domain.Provenance, error)

	InsertAttachment(ctx context.Context, scope authctx.TenantScope,
		a domain.Attachment) error
	GetAttachment(ctx context.Context, scope authctx.TenantScope, attachmentID string) (
		domain.Attachment, error)
	Attachments(ctx context.Context, scope authctx.TenantScope,
		parentType, parentID string, limit int32) ([]domain.Attachment, error)

	InsertConsent(ctx context.Context, scope authctx.TenantScope,
		c domain.ClinicalConsent) error
	SetConsentStatus(ctx context.Context, scope authctx.TenantScope,
		consentID string, status domain.ConsentStatus, now time.Time) error
	Consents(ctx context.Context, scope authctx.TenantScope, patientID string,
		kind domain.ClinicalConsentKind, limit int32) (domain.ConsentSet, error)
}

// DecisionRepository persists calculators, decision-support alerts, consults
// and registry memberships
// (SRS-CLN-020 … SRS-CLN-023).
type DecisionRepository interface {
	InsertCalculatorResult(ctx context.Context, scope authctx.TenantScope,
		r domain.CalculatorResult) error
	// SupersedeCalculatorResult chains a rerun to the result it replaces. The
	// original stays: recalculation never overwrites history (SRS-CLN-020).
	SupersedeCalculatorResult(ctx context.Context, scope authctx.TenantScope,
		resultID, supersededByID string) error
	CalculatorResults(ctx context.Context, scope authctx.TenantScope, patientID,
		calculatorID string, limit int32) ([]domain.CalculatorResult, error)

	InsertAlert(ctx context.Context, scope authctx.TenantScope, a domain.CDSAlert) error
	GetAlert(ctx context.Context, scope authctx.TenantScope, alertID string) (
		domain.CDSAlert, error)
	RespondToAlert(ctx context.Context, scope authctx.TenantScope,
		a domain.CDSAlert) error
	Alerts(ctx context.Context, scope authctx.TenantScope, q AlertQuery) (
		[]domain.CDSAlert, error)

	InsertConsult(ctx context.Context, scope authctx.TenantScope, c domain.Consult) error
	GetConsult(ctx context.Context, scope authctx.TenantScope, consultID string) (
		domain.Consult, error)
	UpdateConsult(ctx context.Context, scope authctx.TenantScope, c domain.Consult,
		expectedVersion int64) error
	Consults(ctx context.Context, scope authctx.TenantScope, q ConsultQuery) (
		[]domain.Consult, error)

	InsertMembership(ctx context.Context, scope authctx.TenantScope,
		m domain.RegistryMembership) error
	ExitMembership(ctx context.Context, scope authctx.TenantScope, membershipID string,
		at time.Time, reason string) error
	Memberships(ctx context.Context, scope authctx.TenantScope, patientID,
		registryID string, currentOnly bool, limit int32) (
		[]domain.RegistryMembership, error)
}

// AlertQuery narrows an alert listing.
type AlertQuery struct {
	PatientID string
	// Outcome narrows to pending, overridden and so on, which is what the
	// override report asks for (SRS-CLN-021).
	Outcome domain.CDSOutcome
	RuleID  string
	Limit   int32
}

// ConsultQuery narrows a consult listing.
type ConsultQuery struct {
	PatientID string
	Specialty string
	// OpenOnly returns the receiving service's worklist.
	OpenOnly bool
	Limit    int32
}

// SmartPhraseRepository persists note shortcuts (SRS-CLN-015).
type SmartPhraseRepository interface {
	Upsert(ctx context.Context, scope authctx.TenantScope, p domain.SmartPhrase,
		now time.Time) error
	// ForAuthor returns a clinician's own phrases and the tenant's shared ones,
	// theirs first so a personal override of a shared shortcut wins.
	ForAuthor(ctx context.Context, scope authctx.TenantScope, ownerID string) (
		[]domain.SmartPhrase, error)
}

// TimelineRepository supplies the clinical half of the longitudinal timeline
// (SRS-ENC-011).
//
// Unfiltered: the encounter context applies the confidentiality filter once, on
// the way out, so one rule governs every contributing source.
type TimelineRepository interface {
	Entries(ctx context.Context, scope authctx.TenantScope, patientID string,
		from, until time.Time, limit int32) ([]TimelineEntry, error)
}

// TimelineEntry is one clinical thing that happened, as the timeline shows it.
type TimelineEntry struct {
	ID              string
	Kind            string
	At              time.Time
	EncounterID     string
	Title           string
	Confidentiality domain.Confidentiality
	AuthorID        string
}

// EncounterDirectory answers what the clinical context needs about the visit a
// record belongs to.
//
// A port onto SRS-ENC rather than a join: whether an encounter is still open is
// that context's fact, and a clinical copy of it would be a second answer that
// drifts. Narrow on purpose — this context asks whether it may write, not what
// the visit was about.
type EncounterDirectory interface {
	// AcceptsClinicalContent reports whether new records may be written against
	// an encounter, and which patient it belongs to. The patient comes back so
	// a caller can check the record it is about to write lands on the same one
	// (SRS-CLN-017).
	AcceptsClinicalContent(ctx context.Context, scope authctx.TenantScope,
		encounterID string) (patientID string, accepts bool, err error)
}

// PatientSummary is what the banner needs from the patient index
// (SRS-CLN-001).
//
// Narrow on purpose: a name, an age, a sex and the identifiers a clinician
// reads out at the bedside. Demographics belong to SRS-EMPI, and a wider port
// would put them in a context far more people can see.
type PatientSummary interface {
	Summary(ctx context.Context, scope authctx.TenantScope, patientID string) (
		BannerFacts, error)
}

// BannerFacts is the identity half of the patient banner.
type BannerFacts struct {
	DisplayName string
	// AgeDisplay is rendered by the patient index rather than computed here: an
	// age in days matters for a neonate and an age in years for everybody else,
	// and a screen showing "0" for a two-week-old is a dosing error waiting to
	// happen.
	AgeDisplay  string
	Sex         string
	Identifiers []domain.BannerIdentifier
	Deceased    bool
}

// AttachmentStore holds attachment bytes.
//
// A port because where a scanned referral lives is a deployment decision —
// encryption at rest, retention, residency — and none of it belongs in the
// clinical record. The record keeps the key, the size and the digest; the
// store keeps the bytes (SRS-DAT-007).
//
// The store chooses the key. A key the caller supplied is a path the caller
// supplied, and an attachment pointing at another tenant's object or at
// nothing at all still reads as a complete record.
type AttachmentStore interface {
	// Put stores bytes under a key the store chooses and returns it.
	Put(ctx context.Context, scope authctx.TenantScope, contentType string,
		content []byte) (string, error)
	// Get returns the bytes, verified against the recorded digest.
	Get(ctx context.Context, scope authctx.TenantScope, key string) ([]byte, error)
	// Delete removes the bytes. Idempotent, so a cleanup after a rejected
	// upload can be retried.
	Delete(ctx context.Context, scope authctx.TenantScope, key string) error
}

// UnitOfWork runs work in one transaction.
type UnitOfWork interface {
	WithinTx(ctx context.Context, fn func(ctx context.Context) error) error
}

// EventAppender writes to the transactional outbox.
type EventAppender interface {
	Append(ctx context.Context, e outbox.Event) error
}

// AuditAppender writes the append-only audit trail.
type AuditAppender interface {
	Append(ctx context.Context, r audit.Record) error
}

// IDGenerator mints identifiers.
type IDGenerator interface{ NewID() string }

// Clock reads the current time.
type Clock interface{ Now() time.Time }
