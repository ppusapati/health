// Package ports declares what the quality use cases need from the outside.
//
// Interfaces owned by this context rather than by whoever implements them, so
// the dependency arrow points inward (FIT-01).
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/quality/domain"
)

// ErrVersionConflict is a lost update: somebody else changed the record
// between the read and the write.
var ErrVersionConflict = errors.New("quality: version conflict")

// IncidentFilter narrows an incident list.
type IncidentFilter struct {
	Category     string
	State        string
	OpenOnly     bool
	SentinelOnly bool
	From, To     time.Time
	Limit        int32
}

// IncidentRepository persists reported events and near misses.
//
// Every method takes authctx.TenantScope, which has no constructor outside the
// auth package, so reaching a row without a verified tenant does not compile
// (FIT-03).
type IncidentRepository interface {
	InsertIncident(ctx context.Context, scope authctx.TenantScope,
		i domain.Incident) error
	Incident(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Incident, error)
	UpdateIncident(ctx context.Context, scope authctx.TenantScope,
		i domain.Incident, expectedVersion int64) error
	Incidents(ctx context.Context, scope authctx.TenantScope,
		f IncidentFilter) ([]domain.Incident, error)
	// ForPatient answers "what has happened to this person here", which a
	// complaint and a mortality review both ask.
	ForPatient(ctx context.Context, scope authctx.TenantScope,
		patientID string, limit int32) ([]domain.Incident, error)
}

// InvestigationRepository persists root cause analyses and their factors.
type InvestigationRepository interface {
	InsertRCA(ctx context.Context, scope authctx.TenantScope,
		r domain.RCA) error
	RCA(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.RCA, error)
	// RCAForIncident is how a reviewer reaches the analysis from the incident.
	// False rather than an error where there is none.
	RCAForIncident(ctx context.Context, scope authctx.TenantScope,
		incidentID string) (domain.RCA, bool, error)
	UpdateRCA(ctx context.Context, scope authctx.TenantScope, r domain.RCA,
		expectedVersion int64) error
	AddFactor(ctx context.Context, scope authctx.TenantScope, rcaID string,
		factorID string, f domain.ContributingFactor) error
	Factors(ctx context.Context, scope authctx.TenantScope, rcaID string) (
		[]domain.ContributingFactor, error)
}

// CAPAFilter narrows an action list.
type CAPAFilter struct {
	SourceKind string
	SourceID   string
	OwnerID    string
	LiveOnly   bool
	Limit      int32
}

// ActionRepository persists corrective and preventive actions.
type ActionRepository interface {
	InsertCAPA(ctx context.Context, scope authctx.TenantScope,
		c domain.CAPA) error
	CAPA(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.CAPA, error)
	UpdateCAPA(ctx context.Context, scope authctx.TenantScope, c domain.CAPA,
		expectedVersion int64) error
	CAPAs(ctx context.Context, scope authctx.TenantScope, f CAPAFilter) (
		[]domain.CAPA, error)
	// CountForSource is what an analysis closing checks: did anything come out
	// of this.
	CountForSource(ctx context.Context, scope authctx.TenantScope,
		sourceKind, sourceID string) (int, error)
	AppendCheck(ctx context.Context, scope authctx.TenantScope, capaID,
		checkID string, check domain.EffectivenessCheck) error
}

// DocumentFilter narrows a document list.
type DocumentFilter struct {
	Kind             string
	Department       string
	ExcludeWithdrawn bool
	Limit            int32
}

// DocumentRepository persists controlled documents and their versions.
type DocumentRepository interface {
	InsertDocument(ctx context.Context, scope authctx.TenantScope,
		d domain.ControlledDocument) error
	Document(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.ControlledDocument, error)
	UpdateDocument(ctx context.Context, scope authctx.TenantScope,
		d domain.ControlledDocument, expectedVersion int64) error
	Documents(ctx context.Context, scope authctx.TenantScope,
		f DocumentFilter) ([]domain.ControlledDocument, error)

	InsertVersion(ctx context.Context, scope authctx.TenantScope,
		v domain.DocumentVersion) error
	Version(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.DocumentVersion, error)
	UpdateVersion(ctx context.Context, scope authctx.TenantScope,
		v domain.DocumentVersion, expectedVersion int64) error
	Versions(ctx context.Context, scope authctx.TenantScope,
		documentID string) ([]domain.DocumentVersion, error)

	// Acknowledge is idempotent: a second confirmation from the same person is
	// not an error, because the button will be pressed twice.
	Acknowledge(ctx context.Context, scope authctx.TenantScope,
		a domain.Acknowledgement) error
	Acknowledgements(ctx context.Context, scope authctx.TenantScope,
		versionID string) ([]domain.Acknowledgement, error)
}

// CompetencyRepository persists competencies, what roles need and who holds
// what.
type CompetencyRepository interface {
	InsertCompetency(ctx context.Context, scope authctx.TenantScope,
		c domain.Competency) error
	Competencies(ctx context.Context, scope authctx.TenantScope,
		activeOnly bool) ([]domain.Competency, error)
	RequireForRole(ctx context.Context, scope authctx.TenantScope,
		role, competencyID string) error
	RoleRequirements(ctx context.Context, scope authctx.TenantScope) (
		map[string][]string, error)

	InsertAward(ctx context.Context, scope authctx.TenantScope,
		a domain.Award) error
	RevokeAward(ctx context.Context, scope authctx.TenantScope, awardID,
		reason string, at time.Time) error
	Awards(ctx context.Context, scope authctx.TenantScope, personID string,
		limit int32) ([]domain.Award, error)
}

// AuditRepository persists internal audits and their findings.
type AuditRepository interface {
	InsertAudit(ctx context.Context, scope authctx.TenantScope,
		a domain.Audit) error
	Audit(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Audit, error)
	UpdateAudit(ctx context.Context, scope authctx.TenantScope, a domain.Audit,
		expectedVersion int64) error
	Audits(ctx context.Context, scope authctx.TenantScope, state string,
		limit int32) ([]domain.Audit, error)

	InsertFinding(ctx context.Context, scope authctx.TenantScope,
		f domain.Finding) error
	Finding(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Finding, error)
	UpdateFinding(ctx context.Context, scope authctx.TenantScope,
		f domain.Finding) error
	Findings(ctx context.Context, scope authctx.TenantScope, auditID string,
		openOnly bool) ([]domain.Finding, error)
}

// CommitteeRepository persists committees and their minutes.
type CommitteeRepository interface {
	InsertCommittee(ctx context.Context, scope authctx.TenantScope,
		c domain.Committee) error
	Committee(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Committee, error)
	UpdateCommittee(ctx context.Context, scope authctx.TenantScope,
		c domain.Committee, expectedVersion int64) error
	Committees(ctx context.Context, scope authctx.TenantScope,
		activeOnly bool) ([]domain.Committee, error)

	InsertMeeting(ctx context.Context, scope authctx.TenantScope,
		m domain.Meeting) error
	Meeting(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Meeting, error)
	UpdateMeeting(ctx context.Context, scope authctx.TenantScope,
		m domain.Meeting, expectedVersion int64) error
	Meetings(ctx context.Context, scope authctx.TenantScope, committeeID string,
		limit int32) ([]domain.Meeting, error)
}

// AccreditationRepository persists standards, clauses, evidence and reviews.
type AccreditationRepository interface {
	InsertStandard(ctx context.Context, scope authctx.TenantScope,
		s domain.Standard) error
	Standard(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Standard, error)
	Standards(ctx context.Context, scope authctx.TenantScope,
		activeOnly bool) ([]domain.Standard, error)

	InsertClauses(ctx context.Context, scope authctx.TenantScope,
		clauses []domain.Clause) error
	Clauses(ctx context.Context, scope authctx.TenantScope,
		standardID string) ([]domain.Clause, error)

	InsertEvidence(ctx context.Context, scope authctx.TenantScope,
		e domain.Evidence) error
	WithdrawEvidence(ctx context.Context, scope authctx.TenantScope,
		evidenceID, by, reason string, at time.Time) error
	// EvidenceForStandard is keyed by clause id, which is how the readiness
	// view reads it.
	EvidenceForStandard(ctx context.Context, scope authctx.TenantScope,
		standardID string, liveOnly bool) (map[string][]domain.Evidence, error)

	InsertClauseReview(ctx context.Context, scope authctx.TenantScope,
		r domain.ClauseReview) error
	// LatestReviews is one review per clause, the most recent. A clause
	// reviewed three times is judged by the last of them.
	LatestReviews(ctx context.Context, scope authctx.TenantScope,
		standardID string) (map[string]domain.ClauseReview, error)
}

// IndicatorRepository persists the indicator dictionary and its values.
type IndicatorRepository interface {
	InsertDefinition(ctx context.Context, scope authctx.TenantScope,
		d domain.KPIDefinition) error
	// Supersede marks every earlier revision of a code as replaced, so the
	// dictionary shows one current entry per indicator while the history stays
	// readable.
	Supersede(ctx context.Context, scope authctx.TenantScope, code string,
		revision int, at time.Time) error
	Definition(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.KPIDefinition, error)
	CurrentDefinition(ctx context.Context, scope authctx.TenantScope,
		code string) (domain.KPIDefinition, bool, error)
	Definitions(ctx context.Context, scope authctx.TenantScope) (
		[]domain.KPIDefinition, error)

	InsertValue(ctx context.Context, scope authctx.TenantScope,
		v domain.KPIValue) error
	Values(ctx context.Context, scope authctx.TenantScope, code string,
		from, to time.Time) ([]domain.KPIValue, error)
}

// ComplaintRepository persists grievances.
type ComplaintRepository interface {
	InsertComplaint(ctx context.Context, scope authctx.TenantScope,
		c domain.Complaint) error
	Complaint(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Complaint, error)
	UpdateComplaint(ctx context.Context, scope authctx.TenantScope,
		c domain.Complaint, expectedVersion int64) error
	Complaints(ctx context.Context, scope authctx.TenantScope, category string,
		openOnly bool, limit int32) ([]domain.Complaint, error)
}

// PeerReviewRepository persists mortality and morbidity reviews.
type PeerReviewRepository interface {
	InsertReview(ctx context.Context, scope authctx.TenantScope,
		r domain.MortalityReview) error
	Review(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.MortalityReview, error)
	UpdateReview(ctx context.Context, scope authctx.TenantScope,
		r domain.MortalityReview, expectedVersion int64) error
	Reviews(ctx context.Context, scope authctx.TenantScope, openOnly bool,
		from, to time.Time, limit int32) ([]domain.MortalityReview, error)
}

// LegalHolds answers whether a record may be destroyed (SRS-QMS-015).
//
// A port over the platform's own hold mechanism rather than a second one here.
// A hold placed in one place and a purge that reads another is a hold that does
// nothing, and nobody finds out until the records are gone.
type LegalHolds interface {
	Held(ctx context.Context, scope authctx.TenantScope,
		recordClass, recordID string) (bool, error)
	Place(ctx context.Context, scope authctx.TenantScope,
		recordClass, recordID, reason, by string, at time.Time) error
	Release(ctx context.Context, scope authctx.TenantScope,
		recordClass, recordID, by string, at time.Time) error
}

// Staff answers who holds which role, for the competency and acknowledgement
// gap reports (SRS-QMS-006, SRS-QMS-013).
//
// A port rather than a table here: who works at this hospital belongs to
// identity and access, and a second copy would drift the first time somebody
// changed job.
type Staff interface {
	// RolesByPerson maps a person to the role they hold. One role per person
	// in this view, because the gap reports are per role and a person with two
	// roles appears twice.
	RolesByPerson(ctx context.Context, scope authctx.TenantScope,
		roles []string) (map[string]string, error)
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
// Used for the three things here that cannot wait for somebody to open a
// screen: a sentinel event, a high-risk incident, and a corrective action that
// has run past its date.
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
