// Package ports declares what the medical records use cases need from the
// outside.
//
// Interfaces owned by this context rather than by whoever implements them, so
// the dependency arrow points inward (FIT-01).
//
// Two absences are deliberate and load-bearing. There is no port here that
// writes a clinical document: SRS-MRD-003's "coder changes … do not rewrite
// clinical text" and SRS-MRD-008's "resolved without altering signed history"
// are both properties of this interface list, and ChartDocuments reads.
// And there is no legal-hold table in this context: SRS-MRD-005 uses the
// platform's own mechanism through LegalHolds, because a hold placed in one
// place and a purge that reads another is a hold that does nothing.
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/records/domain"
)

// ErrVersionConflict is a lost update: somebody else changed the record
// between the read and the write.
var ErrVersionConflict = errors.New("records: version conflict")

// ChecklistRepository persists chart completion checklists (SRS-MRD-001).
//
// Every method takes authctx.TenantScope, which has no constructor outside
// the auth package, so reaching a row without a verified tenant does not
// compile (FIT-03).
type ChecklistRepository interface {
	// InsertChecklist stores a checklist and its items together. One act,
	// because a checklist whose items landed after it did would find every
	// chart complete in between.
	InsertChecklist(ctx context.Context, scope authctx.TenantScope,
		c domain.ChartChecklist) error
	Checklist(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.ChartChecklist, error)
	ApproveChecklist(ctx context.Context, scope authctx.TenantScope,
		c domain.ChartChecklist) error
	SupersedeEarlierChecklists(ctx context.Context,
		scope authctx.TenantScope, code string, revision int,
		at time.Time) error
	// Checklists returns the configured checklists. A non-zero liveAt
	// narrows to the ones in force at that moment.
	Checklists(ctx context.Context, scope authctx.TenantScope,
		encounterClass string, liveAt time.Time) (
		[]domain.ChartChecklist, error)
}

// DeficiencyFilter narrows a deficiency worklist.
type DeficiencyFilter struct {
	OwnerID     string
	EncounterID string
	FacilityID  string
	State       string
	OpenOnly    bool
	From, To    time.Time
	Limit       int32
	Offset      int32
}

// DeficiencyRepository persists chart deficiencies (SRS-MRD-002).
type DeficiencyRepository interface {
	InsertDeficiency(ctx context.Context, scope authctx.TenantScope,
		d domain.Deficiency) error
	Deficiency(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Deficiency, error)
	UpdateDeficiency(ctx context.Context, scope authctx.TenantScope,
		d domain.Deficiency, expectedVersion int64) error
	Deficiencies(ctx context.Context, scope authctx.TenantScope,
		f DeficiencyFilter) ([]domain.Deficiency, error)
	// EscalationCandidates is the sweep's read: open, overdue and not
	// escalated already.
	EscalationCandidates(ctx context.Context, scope authctx.TenantScope,
		before time.Time, limit int32) ([]domain.Deficiency, error)
}

// CodingRepository persists coded episodes (SRS-MRD-003).
//
// Append-only by construction: there is no method here that edits a revision
// or a code. AppendRevision adds one, and the only update is the state
// transition a second read or a query makes.
type CodingRepository interface {
	InsertEpisode(ctx context.Context, scope authctx.TenantScope,
		e domain.CodedEpisode) error
	// Episode loads an episode with every revision and every code.
	Episode(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.CodedEpisode, error)
	EpisodeForEncounter(ctx context.Context, scope authctx.TenantScope,
		encounterID string) (domain.CodedEpisode, bool, error)
	AppendRevision(ctx context.Context, scope authctx.TenantScope,
		episode domain.CodedEpisode, revision domain.CodingRevision,
		expectedVersion int64) error
	// SetRevisionState records a second read or a query on the current
	// revision.
	SetRevisionState(ctx context.Context, scope authctx.TenantScope,
		episodeID string, revision domain.CodingRevision) error
}

// ReleaseFilter narrows a release list.
type ReleaseFilter struct {
	PatientID string
	State     string
	OpenOnly  bool
	From, To  time.Time
	Limit     int32
	Offset    int32
}

// DisclosureFilter narrows the accounting of disclosures.
type DisclosureFilter struct {
	PatientID string
	ActorID   string
	From, To  time.Time
	Limit     int32
	Offset    int32
}

// ReleaseRepository persists record releases and the accounting of
// disclosures (SRS-MRD-004, SRS-MRD-010).
type ReleaseRepository interface {
	InsertRelease(ctx context.Context, scope authctx.TenantScope,
		r domain.ReleaseRequest) error
	Release(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.ReleaseRequest, error)
	// UpdateRelease writes the request and, where one has been assembled,
	// the package's items. Together, because a release recorded as sent with
	// no manifest cannot answer "what did we release".
	UpdateRelease(ctx context.Context, scope authctx.TenantScope,
		r domain.ReleaseRequest, expectedVersion int64) error
	Releases(ctx context.Context, scope authctx.TenantScope,
		f ReleaseFilter) ([]domain.ReleaseRequest, error)

	InsertDisclosure(ctx context.Context, scope authctx.TenantScope,
		d domain.Disclosure) error
	// Disclosures answers "who has seen my record", which a patient is
	// entitled to ask.
	Disclosures(ctx context.Context, scope authctx.TenantScope,
		f DisclosureFilter) ([]domain.Disclosure, error)
}

// DispositionFilter narrows a list of disposition batches.
type DispositionFilter struct {
	State        string
	Jurisdiction string
	Limit        int32
	Offset       int32
}

// RetentionRepository persists retention rules and disposition batches
// (SRS-MRD-009).
type RetentionRepository interface {
	InsertRule(ctx context.Context, scope authctx.TenantScope,
		r domain.RetentionRule) error
	Rule(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.RetentionRule, error)
	ApproveRule(ctx context.Context, scope authctx.TenantScope,
		r domain.RetentionRule) error
	SupersedeEarlierRules(ctx context.Context, scope authctx.TenantScope,
		code string, revision int, at time.Time) error
	Rules(ctx context.Context, scope authctx.TenantScope,
		jurisdiction, recordClass string, liveAt time.Time) (
		[]domain.RetentionRule, error)

	InsertList(ctx context.Context, scope authctx.TenantScope,
		l domain.DispositionList) error
	List(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.DispositionList, error)
	UpdateList(ctx context.Context, scope authctx.TenantScope,
		l domain.DispositionList, expectedVersion int64) error
	Lists(ctx context.Context, scope authctx.TenantScope,
		f DispositionFilter) ([]domain.DispositionList, error)
}

// PhysicalFilter narrows a physical record list.
type PhysicalFilter struct {
	PatientID   string
	State       string
	OutOnly     bool
	OverdueOnly bool
	Limit       int32
	Offset      int32
}

// PhysicalRepository persists paper record locations (SRS-MRD-006).
type PhysicalRepository interface {
	InsertPhysicalRecord(ctx context.Context, scope authctx.TenantScope,
		p domain.PhysicalRecord) error
	PhysicalRecord(ctx context.Context, scope authctx.TenantScope,
		id string) (domain.PhysicalRecord, error)
	UpdatePhysicalRecord(ctx context.Context, scope authctx.TenantScope,
		p domain.PhysicalRecord, expectedVersion int64) error
	PhysicalRecords(ctx context.Context, scope authctx.TenantScope,
		f PhysicalFilter, at time.Time) ([]domain.PhysicalRecord, error)
}

// CertificateFilter narrows a certificate list.
type CertificateFilter struct {
	PatientID string
	Kind      domain.CertificateKind
	State     string
	Limit     int32
	Offset    int32
}

// CertificateRepository persists statutory forms and the certificates issued
// against them (SRS-MRD-007).
//
// AppendVersion adds a corrected version; there is no method that edits one.
// The first version went to a family and to a registrar.
type CertificateRepository interface {
	InsertForm(ctx context.Context, scope authctx.TenantScope,
		f domain.CertificateForm) error
	Form(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.CertificateForm, error)
	ApproveForm(ctx context.Context, scope authctx.TenantScope,
		f domain.CertificateForm) error
	SupersedeEarlierForms(ctx context.Context, scope authctx.TenantScope,
		code string, revision int, at time.Time) error
	Forms(ctx context.Context, scope authctx.TenantScope,
		kind domain.CertificateKind, jurisdiction string,
		liveAt time.Time) ([]domain.CertificateForm, error)

	InsertCertificate(ctx context.Context, scope authctx.TenantScope,
		c domain.StatutoryCertificate) error
	Certificate(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.StatutoryCertificate, error)
	AppendVersion(ctx context.Context, scope authctx.TenantScope,
		c domain.StatutoryCertificate, version domain.CertificateVersion,
		expectedVersion int64) error
	UpdateCertificate(ctx context.Context, scope authctx.TenantScope,
		c domain.StatutoryCertificate, expectedVersion int64) error
	Certificates(ctx context.Context, scope authctx.TenantScope,
		f CertificateFilter) ([]domain.StatutoryCertificate, error)
}

// ChartDocuments reads which clinical documents exist on an encounter
// (SRS-MRD-001, SRS-MRD-002).
//
// Read-only by construction, and that is the requirement rather than a
// convenience. This interface has one method and it returns a projection with
// no content on it: SRS-MRD-003 and SRS-MRD-008 both turn on health
// information management being unable to change what a clinician wrote, and
// the way to mean that is to hold nothing that writes.
type ChartDocuments interface {
	// ForEncounter lists what exists on one encounter. The patient is named
	// as well, because the clinical context indexes documents by patient and
	// a seam that hid that would be one this context could not satisfy
	// without a second index of its own.
	ForEncounter(ctx context.Context, scope authctx.TenantScope,
		patientID, encounterID string) ([]domain.ChartDocument, error)
}

// EncounterFacts are what a checklist is judged against (SRS-MRD-001).
//
// The encounter context's facts, read through a port rather than copied: a
// second answer to "was this an inpatient admission" would drift the first
// time somebody corrected one.
type EncounterFacts struct {
	EncounterID string
	PatientID   string
	FacilityID  string
	Class       string
	Specialty   string
	// AttendingProviderID is who the encounter made responsible. It is who a
	// missing document is owed by: a chart with no discharge summary has
	// nobody who wrote it and somebody who should have, and a deficiency
	// raised against nobody goes into a worklist nobody reads.
	AttendingProviderID string
	// EndedAt is when the encounter closed, which is what the due dates are
	// measured from. Zero for an open encounter, and a checklist item then
	// has no deadline rather than a deadline in 1970.
	EndedAt time.Time
	// Conditions answer the conditional checklist items — whether there was
	// an operation, whether the patient died. The encounter's facts, because
	// they are not this context's to decide.
	Conditions map[string]bool
	// Jurisdiction is whose retention law this encounter's records follow,
	// read from the facility.
	Jurisdiction string
}

// Encounters is the seam onto the encounter context (SRS-MRD-001,
// SRS-MRD-004).
type Encounters interface {
	Describe(ctx context.Context, scope authctx.TenantScope,
		encounterID string) (EncounterFacts, error)
	// ForPatient lists a patient's encounters, which is what a whole-record
	// release has to be assembled from. Read-only like the rest of this
	// seam: knowing that an admission happened is not the same as being able
	// to change it.
	ForPatient(ctx context.Context, scope authctx.TenantScope,
		patientID string) ([]EncounterFacts, error)
}

// LegalHolds answers whether a record may be destroyed (SRS-MRD-005).
//
// A port over the platform's own hold mechanism rather than a second one
// here. SRS-QMS-015 places holds through the same one, and a hold placed in
// one place with a purge that reads another is a hold that does nothing —
// which nobody finds out until the records are gone.
type LegalHolds interface {
	Held(ctx context.Context, scope authctx.TenantScope,
		recordClass, recordID string) (bool, error)
	// HeldIDs is the batch form, for a disposition sweep over thousands of
	// records. Asking one at a time would work and would take an hour.
	HeldIDs(ctx context.Context, scope authctx.TenantScope,
		recordClass string) (map[string]bool, error)
	Place(ctx context.Context, scope authctx.TenantScope,
		recordClass, recordID, reason, by string, at time.Time) error
	Release(ctx context.Context, scope authctx.TenantScope,
		recordClass, recordID, by string, at time.Time) error
}

// RecordInventory lists what the hospital is holding, for a retention sweep
// (SRS-MRD-009).
//
// A port because the answer is not one context's. The paper volumes are this
// context's own and the adapter supplies them; the electronic records are
// every other context's, and a deployment that wants them swept supplies an
// adapter that knows where they are. A deployment with no inventory adapter
// sweeps its paper records and nothing else, which the status document names
// rather than this code pretending otherwise.
type RecordInventory interface {
	Retained(ctx context.Context, scope authctx.TenantScope,
		jurisdiction string, limit int32) ([]domain.RetainedRecord, error)
}

// Notice is something somebody has to be told about now.
type Notice struct {
	Kind       string
	Subject    string
	FacilityID string
	Summary    string
}

// Escalator raises a durable, acknowledged notice.
//
// Used for the one thing here that cannot wait for somebody to open a screen:
// a chart deficiency that has run past its date and its grace period, which
// goes to somebody above the clinician who owes it.
type Escalator interface {
	Raise(ctx context.Context, scope authctx.TenantScope, n Notice,
		at time.Time) (string, error)
}

// EventAppender publishes domain events through the outbox.
type EventAppender interface {
	Append(ctx context.Context, e outbox.Event) error
}

// AuditAppender writes the append-only audit trail.
type AuditAppender interface {
	Append(ctx context.Context, r audit.Record) error
}

// UnitOfWork runs a use case in one transaction.
type UnitOfWork interface {
	WithinTx(ctx context.Context, fn func(context.Context) error) error
}

// IDGenerator mints identifiers.
type IDGenerator interface{ NewID() string }

// Clock reads the time.
type Clock interface{ Now() time.Time }
