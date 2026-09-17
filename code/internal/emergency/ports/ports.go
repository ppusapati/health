// Package ports declares what the emergency application layer needs.
//
// Declared by the consumer rather than by the adapters that implement them,
// which keeps the dependency arrow pointing inward (Blueprint §4.1).
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/emergency/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
)

// ErrVersionConflict reports that another writer advanced the visit first.
var ErrVersionConflict = errors.New("emergency: visit changed concurrently")

// VisitRepository persists the department's own records.
//
// Every method takes authctx.TenantScope, which has no constructor outside the
// auth package, so reaching a row without a verified tenant does not compile
// (FIT-03).
type VisitRepository interface {
	InsertVisit(ctx context.Context, scope authctx.TenantScope, v domain.Visit) error
	GetVisit(ctx context.Context, scope authctx.TenantScope, visitID string) (
		domain.Visit, error)
	UpdateVisit(ctx context.Context, scope authctx.TenantScope, v domain.Visit,
		expectedVersion int64) error
	// OpenVisits is the department as it stands. Ordering is the application's
	// job: the queue needs the triage and the override too.
	OpenVisits(ctx context.Context, scope authctx.TenantScope, facilityID string,
		limit int32) ([]domain.Visit, error)

	InsertTriage(ctx context.Context, scope authctx.TenantScope, t domain.Triage) error
	// LatestTriage is the acuity the queue sorts on. A patient may be
	// re-triaged, and a deteriorating patient in the waiting room is exactly
	// who re-triage exists for.
	LatestTriage(ctx context.Context, scope authctx.TenantScope, visitID string) (
		domain.Triage, bool, error)
	ListTriage(ctx context.Context, scope authctx.TenantScope, visitID string) (
		[]domain.Triage, error)

	InsertOverride(ctx context.Context, scope authctx.TenantScope, visitID string,
		o domain.PriorityOverride) error
	LatestOverride(ctx context.Context, scope authctx.TenantScope, visitID string) (
		domain.PriorityOverride, bool, error)

	InsertPathway(ctx context.Context, scope authctx.TenantScope, p domain.Pathway) error
	ListPathways(ctx context.Context, scope authctx.TenantScope, visitID string) (
		[]domain.Pathway, error)
	ActivePathways(ctx context.Context, scope authctx.TenantScope, facilityID string) (
		map[string][]domain.PathwayKind, error)
	StandDownPathway(ctx context.Context, scope authctx.TenantScope, pathwayID,
		reason string, at time.Time) error

	InsertEvent(ctx context.Context, scope authctx.TenantScope, e domain.Event) error
	Timeline(ctx context.Context, scope authctx.TenantScope, visitID string) (
		domain.Timeline, error)
	// ReconcileEvent discharges a pre-order administration. Returns false when
	// the debt was already settled, which is a race rather than an error.
	ReconcileEvent(ctx context.Context, scope authctx.TenantScope, eventID,
		orderID string) (bool, error)
	// Unreconciled is the department's debt, facility-wide: a drug given under
	// protocol and never written up is nobody's chart to find.
	Unreconciled(ctx context.Context, scope authctx.TenantScope, facilityID string,
		limit int32) (domain.Timeline, error)
}

// Encounters reports whether the Wave-1 encounter an emergency visit hangs off
// still accepts content, and which patient it belongs to.
//
// A port rather than a direct call: emergency must not reach into the
// encounter context's tables, and a department that kept its own copy of the
// patient is one whose allergies disagree with the ward's.
type Encounters interface {
	// Writable reports whether content may still be recorded, and the patient
	// the encounter is for.
	Writable(ctx context.Context, scope authctx.TenantScope, encounterID string) (
		patientID string, writable bool, err error)
}

// Escalations raises a durable notice for a time-critical activation
// (SRS-ER-005, SRS-OPSNFR-003).
//
// Nil is a valid deployment: a department that activates by shouting across
// the resus room has a working escalation mechanism that this software is not
// part of, and refusing the activation because no chain is configured would be
// refusing to record a trauma call.
type Escalations interface {
	RaisePathway(ctx context.Context, scope authctx.TenantScope, n PathwayNotice) (
		noticeID string, err error)
}

// PathwayNotice is a time-critical activation, as the escalation mechanism
// needs it.
//
// Carries no clinical detail beyond the pathway's name. The escalation inbox is
// read by a mechanism that knows nothing about clinical confidentiality, and
// "STEMI pathway activated in Resus 1" is enough to make the right person move.
type PathwayNotice struct {
	PathwayID  string
	VisitID    string
	PatientID  string
	FacilityID string
	Kind       string
	Label      string
	Location   string
	At         time.Time
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
