// Package ports declares what the encounter application layer needs.
//
// Declared by the consumer rather than by the adapters that implement them,
// which keeps the dependency arrow pointing inward (Blueprint §4.1).
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/encounter/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
)

// ErrVersionConflict reports that another writer advanced the record first.
var ErrVersionConflict = errors.New("encounter: record changed concurrently")

// EncounterRepository persists encounters and their status history.
//
// Every method takes authctx.TenantScope, which has no constructor outside the
// auth package, so reaching a row without a verified tenant does not compile
// (FIT-03).
type EncounterRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope, e *domain.Encounter) error
	Get(ctx context.Context, scope authctx.TenantScope, encounterID string) (
		*domain.Encounter, error)
	// SetState writes the status and the clinical times together under
	// optimistic concurrency, and appends the history entry. One method rather
	// than two because status and times always change together: an encounter
	// becomes in-progress exactly when it starts, and two calls would be two
	// chances to commit half of it.
	SetState(ctx context.Context, scope authctx.TenantScope, e *domain.Encounter,
		change domain.StatusChange, expectedVersion int64) error
	ForPatient(ctx context.Context, scope authctx.TenantScope, q PatientQuery) (
		[]*domain.Encounter, error)
	// Open returns the encounters still under way at a facility — the ward
	// round.
	Open(ctx context.Context, scope authctx.TenantScope, facilityID string,
		class domain.Class, limit int32) ([]*domain.Encounter, error)
	History(ctx context.Context, scope authctx.TenantScope, encounterID string) (
		[]domain.StatusChange, error)
}

// PatientQuery narrows a patient's encounter list.
type PatientQuery struct {
	PatientID string
	EpisodeID string
	Class     domain.Class
	// IncludeRetracted shows entered-in-error encounters. Off by default: a
	// record that was never true should not appear in a clinical chronology
	// unless somebody is investigating precisely that.
	IncludeRetracted bool
	Limit            int32
}

// EpisodeRepository persists courses of care (SRS-ENC-004).
type EpisodeRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope, e *domain.Episode) error
	Get(ctx context.Context, scope authctx.TenantScope, episodeID string) (
		*domain.Episode, error)
	ForPatient(ctx context.Context, scope authctx.TenantScope, patientID string,
		openOnly bool, limit int32) ([]*domain.Episode, error)
	SetStatus(ctx context.Context, scope authctx.TenantScope, e *domain.Episode,
		expectedVersion int64) error
}

// CareTeamRepository persists encounter care teams (SRS-ENC-005).
type CareTeamRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope, m domain.CareTeamMember) error
	ForEncounter(ctx context.Context, scope authctx.TenantScope, encounterID string) (
		domain.CareTeam, error)
	End(ctx context.Context, scope authctx.TenantScope, careTeamID string,
		at time.Time) error
	// Includes answers the authorization question directly, as of a time, so a
	// permission check does not have to load a whole team to ask about one
	// person.
	Includes(ctx context.Context, scope authctx.TenantScope, encounterID, subjectID string,
		at time.Time) (bool, error)
}

// DiagnosisRepository persists encounter diagnoses (SRS-ENC-007).
type DiagnosisRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope, d domain.Diagnosis) error
	// Supersede chains an earlier entry to the one replacing it. Guarded on the
	// earlier one still being live, so two clinicians revising the same
	// diagnosis produce one chain rather than a fork nobody can read.
	Supersede(ctx context.Context, scope authctx.TenantScope, diagnosisID,
		supersededByID string) error
	Retract(ctx context.Context, scope authctx.TenantScope, diagnosisID, reason string) error
	ForEncounter(ctx context.Context, scope authctx.TenantScope, encounterID string) (
		domain.DiagnosisList, error)
	LiveForPatient(ctx context.Context, scope authctx.TenantScope, patientID string,
		limit int32) (domain.DiagnosisList, error)
}

// ClosurePolicyRepository reads and writes the finalisation rules
// (SRS-ENC-008).
type ClosurePolicyRepository interface {
	// Resolve returns the policy in force, facility-specific rows taking
	// precedence over tenant-wide ones, falling back to the domain default when
	// a tenant has configured nothing.
	Resolve(ctx context.Context, scope authctx.TenantScope, facilityID string) (
		domain.ClosurePolicy, error)
	Set(ctx context.Context, scope authctx.TenantScope, facilityID string,
		p domain.ClosurePolicy, now time.Time) error
	RecordOverride(ctx context.Context, scope authctx.TenantScope,
		o domain.ClosureOverride) error
	Overrides(ctx context.Context, scope authctx.TenantScope, encounterID string,
		limit int32) ([]domain.ClosureOverride, error)
}

// SummaryRepository persists visit summaries (SRS-ENC-009).
type SummaryRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope, s domain.VisitSummary) error
	ForEncounter(ctx context.Context, scope authctx.TenantScope, encounterID string) (
		[]domain.VisitSummary, error)
}

// ClinicalContent reports what an encounter has, for the closure gate.
//
// A port onto the clinical context rather than a join, because notes are
// SRS-CLN's and this context asking "is there a signed note" keeps the seam
// narrow. Handing the encounter context the note itself would put clinical
// content in a container with weaker access rules than the content has.
//
// Nil is a valid deployment: a tenant running no clinical documentation yet
// answers "no signed note", and the closure policy's requirement for one then
// correctly blocks rather than silently passing.
type ClinicalContent interface {
	// DocumentationFor reports which of the configured mandatory items an
	// encounter actually has.
	DocumentationFor(ctx context.Context, scope authctx.TenantScope,
		encounterID string) (domain.DocumentationState, error)
	// TimelineFor returns the clinical entries for a patient's timeline
	// (SRS-ENC-011). Unfiltered: the confidentiality filter is applied by this
	// context, on the way out, so one rule governs every contributing source.
	TimelineFor(ctx context.Context, scope authctx.TenantScope, patientID string,
		from, until time.Time, limit int32) ([]domain.Entry, error)
}

// PatientDirectory answers what the encounter context needs about a patient.
//
// Narrow on purpose: whether the patient exists in this tenant, and whether
// their record accepts new clinical activity. Demographics belong to SRS-EMPI
// and a copy here would be a second answer that drifts.
type PatientDirectory interface {
	// Exists reports a patient in this tenant. A not-found error rather than
	// false where the patient is not there, so an encounter cannot be opened
	// against an identifier from another tenant.
	Exists(ctx context.Context, scope authctx.TenantScope, patientID string) (bool, error)
}

// AppointmentDirectory links an encounter back to the visit that was planned.
//
// Optional. SRS-ENC-003 requires the two to be separately auditable, so an
// encounter is never blocked by the absence of an appointment; this exists so
// the link, where there is one, can be checked rather than trusted from the
// request.
type AppointmentDirectory interface {
	// BelongsToPatient reports whether an appointment is this patient's, so an
	// encounter cannot be filed against somebody else's booking.
	BelongsToPatient(ctx context.Context, scope authctx.TenantScope,
		appointmentID, patientID string) (bool, error)
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
