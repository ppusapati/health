// Package ports declares what the patient index's application layer needs.
//
// Declared by the consumer rather than by the adapters that implement them,
// which is what keeps the dependency arrow pointing inward (Blueprint §4.1).
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/empi/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
)

// ErrVersionConflict reports that another writer advanced the record first.
//
// Declared here rather than in the adapter so the application can recognise it
// without importing a persistence package — which would point the dependency
// arrow outward and fail FIT-01.
var ErrVersionConflict = errors.New("empi: patient changed concurrently")

// PatientRepository persists patient identities.
//
// Every method takes authctx.TenantScope, which has no constructor outside the
// auth package. Reaching a patient row without a verified tenant is therefore
// not something review has to catch — it does not compile (FIT-03).
type PatientRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope, p *domain.Patient) error
	GetByID(ctx context.Context, scope authctx.TenantScope, patientID string) (*domain.Patient, error)
	// UpdateDemographics applies a correction under optimistic concurrency and
	// returns ErrVersionConflict when another writer got there first.
	UpdateDemographics(ctx context.Context, scope authctx.TenantScope, p *domain.Patient) error
	SetStatus(ctx context.Context, scope authctx.TenantScope, p *domain.Patient) error

	// Candidates returns records sharing a blocking signal with the proposal.
	//
	// Blocking is allowed to miss. A duplicate whose surname, birth date and
	// phone all differ is not findable by any index, and the merge workflow
	// exists for what search does not catch. Scoring every patient in the
	// tenant instead would be O(tenant) per registration.
	Candidates(ctx context.Context, scope authctx.TenantScope, b BlockingKeys, limit int32) ([]*domain.Patient, error)

	// ByName is the registration desk's plain search, keyset-paginated.
	ByName(ctx context.Context, scope authctx.TenantScope, prefix string,
		after Cursor, limit int32) ([]*domain.Patient, error)

	// ByIdentifier resolves a value a patient quoted. Finds superseded
	// identifiers and never revoked ones.
	ByIdentifier(ctx context.Context, scope authctx.TenantScope,
		t domain.IdentifierType, system, value string, limit int32) ([]*domain.Patient, error)
}

// BlockingKeys are the indexable signals a candidate must share.
//
// Any of them matching is enough; all being empty means no candidates, which
// is the correct answer for a registration with nothing to block on rather
// than an invitation to scan the tenant.
type BlockingKeys struct {
	BirthDate    *time.Time
	FamilyPrefix string
	Phone        string
	// ExcludePatientID drops one record from the results, for the case of
	// re-scoring an existing patient against the rest.
	ExcludePatientID string
}

// IsEmpty reports that nothing can be blocked on.
func (b BlockingKeys) IsEmpty() bool {
	return b.BirthDate == nil && b.FamilyPrefix == "" && b.Phone == ""
}

// Cursor is a keyset position, never a page number (Domain/Data §6).
type Cursor struct {
	FamilyName string
	PatientID  string
}

// IdentifierRepository persists the identifiers a patient is known by.
type IdentifierRepository interface {
	// Link inserts an identifier. It returns domain.ErrIdentifierConflict when
	// the value is already actively held, and the refusal comes from a unique
	// index rather than from a prior read: a check-then-insert is a race that
	// two concurrent registrations both win (SRS-EMPI-016).
	Link(ctx context.Context, scope authctx.TenantScope, i domain.Identifier) error
	ForPatient(ctx context.Context, scope authctx.TenantScope, patientID string) (domain.IdentifierSet, error)
	// ForPatients batch-loads, so a page of candidates is one query rather than
	// one per row.
	ForPatients(ctx context.Context, scope authctx.TenantScope, patientIDs []string) (map[string]domain.IdentifierSet, error)
}

// ConfigRepository reads the tenant's registration and matching configuration.
type ConfigRepository interface {
	// DemographicPolicy resolves the minimum set, facility-specific first and
	// jurisdiction-wide second, falling back to domain.DefaultPolicy when the
	// tenant has configured nothing.
	DemographicPolicy(ctx context.Context, scope authctx.TenantScope,
		jurisdiction, facilityID string) (domain.DemographicPolicy, error)
	// MatchConfig returns the tenant's weights and thresholds, falling back to
	// the domain defaults.
	MatchConfig(ctx context.Context, scope authctx.TenantScope) (domain.MatchWeights, domain.MatchThresholds, error)
}

// NumberIssuer allocates the MRN (SRS-EMPI-001, SRS-PLT-014).
//
// Reusing the platform's numbering capability rather than minting MRNs here:
// its statement takes a row lock, which is what makes SRS-EMPI-016 ("prevent
// duplicate MRN assignment under concurrent registration") hold. A second
// implementation would be a second chance to get that wrong.
type NumberIssuer interface {
	IssueMRN(ctx context.Context, scope authctx.TenantScope, facilityID string, now time.Time) (string, error)
}

// TenantProfile supplies the tenant attributes registration depends on.
type TenantProfile interface {
	// Jurisdiction selects the demographic policy. It lives on the tenant
	// rather than in the request so a caller cannot choose a laxer policy by
	// naming a different jurisdiction.
	//
	// Takes the scope rather than a tenant id for the same reason every other
	// port here does: with a scope, reading another tenant's configuration is
	// not something review has to catch (FIT-03).
	Jurisdiction(ctx context.Context, scope authctx.TenantScope) (string, error)
}

// EventAppender writes a domain event to the transactional outbox, inside the
// caller's transaction (SRS-API-008).
type EventAppender interface {
	Append(ctx context.Context, e outbox.Event) error
}

// AuditAppender writes an audit record. Also transactional: an applied change
// without its audit entry is a compliance defect, and a patient read without
// one is worse (SRS-SEC-004).
type AuditAppender interface {
	Append(ctx context.Context, r audit.Record) error
}

// UnitOfWork runs a function inside one database transaction.
type UnitOfWork interface {
	WithinTx(ctx context.Context, fn func(context.Context) error) error
}

// IDGenerator mints opaque identifiers.
type IDGenerator interface{ NewID() string }

// Clock supplies the current time.
type Clock interface{ Now() time.Time }

// MergeRepository persists the merge journal and the duplicate review queue
// (SRS-EMPI-004/005/006).
type MergeRepository interface {
	// RecordMerge writes the journal entry. It is what makes a merge
	// reversible, so it commits in the same transaction as the merge itself.
	RecordMerge(ctx context.Context, scope authctx.TenantScope, r domain.MergeRecord) error
	// MergeByID reads one journal entry.
	MergeByID(ctx context.Context, scope authctx.TenantScope, mergeID string) (domain.MergeRecord, error)
	// StandingMerge returns the merge currently holding a record down, if any.
	StandingMerge(ctx context.Context, scope authctx.TenantScope, mergedPatientID string) (domain.MergeRecord, error)
	// LaterMergesInto counts merges into a survivor after an instant, which is
	// what makes reversing an earlier merge unsafe.
	LaterMergesInto(ctx context.Context, scope authctx.TenantScope,
		survivorID string, after time.Time) (int, error)
	MarkUndone(ctx context.Context, scope authctx.TenantScope, r domain.MergeRecord) error

	// MoveIdentifier re-points one identifier at another patient, carrying the
	// status the caller decided.
	MoveIdentifier(ctx context.Context, scope authctx.TenantScope,
		identifierID, toPatientID string, status domain.IdentifierStatus,
		primary bool, reason string, at time.Time) error

	// SetMergedInto writes the losing record's new status and pointer under
	// optimistic concurrency.
	SetMergedInto(ctx context.Context, scope authctx.TenantScope, p *domain.Patient) error
	// SetDeceased writes or clears a deceased record.
	SetDeceased(ctx context.Context, scope authctx.TenantScope, p *domain.Patient) error

	// QueueCandidate records a pair for review. Idempotent on the pair, and it
	// never reopens a decision already taken.
	QueueCandidate(ctx context.Context, scope authctx.TenantScope, c domain.DuplicateCandidate) error
	Candidate(ctx context.Context, scope authctx.TenantScope, candidateID string) (domain.DuplicateCandidate, error)
	OpenCandidates(ctx context.Context, scope authctx.TenantScope, limit int32) ([]domain.DuplicateCandidate, error)
	CloseCandidate(ctx context.Context, scope authctx.TenantScope, c domain.DuplicateCandidate) error
}

// HistoryRepository persists effective-dated demographics, communication
// preferences and related persons (SRS-EMPI-007, SRS-EMPI-009).
type HistoryRepository interface {
	// RecordName opens a new name window and closes the previous one of the
	// same kind. Both happen in the caller's transaction: a close without its
	// open leaves a patient with no current name, an open without its close
	// leaves two.
	RecordName(ctx context.Context, scope authctx.TenantScope, n domain.PatientName) error
	Names(ctx context.Context, scope authctx.TenantScope, patientID string) (domain.NameHistory, error)
	// MatchingFormerNames reports, per patient, the closed name that matched a
	// name search — the reason a patient reached through a maiden name is in
	// the results at all. Keyed by patient ID; a patient absent from the map
	// matched on their current name.
	MatchingFormerNames(ctx context.Context, scope authctx.TenantScope,
		patientIDs []string, prefix string) (map[string]domain.PatientName, error)

	RecordPreference(ctx context.Context, scope authctx.TenantScope, p domain.CommunicationPreference) error
	Preferences(ctx context.Context, scope authctx.TenantScope, patientID string) (domain.PreferenceSet, error)

	RecordRelatedPerson(ctx context.Context, scope authctx.TenantScope, p domain.RelatedPerson) error
	VerifyRelatedPerson(ctx context.Context, scope authctx.TenantScope,
		relationshipID, by, note string, at time.Time) error
	EndRelatedPerson(ctx context.Context, scope authctx.TenantScope, relationshipID string, at time.Time) error
	RelatedPersons(ctx context.Context, scope authctx.TenantScope, patientID string) (domain.RelatedPersonSet, error)
	// AuthorityHeldBy is the reverse direction: what one person may do for
	// another, which is the question an authorization check asks.
	AuthorityHeldBy(ctx context.Context, scope authctx.TenantScope,
		holderPatientID, subjectPatientID string) (domain.RelatedPersonSet, error)
}
