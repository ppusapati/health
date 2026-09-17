// Package ports declares what the critical-care application layer needs.
//
// Declared by the consumer rather than by the adapters that implement them,
// which keeps the dependency arrow pointing inward (Blueprint §4.1).
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/icu/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
)

// ErrVersionConflict reports that another writer advanced the episode first.
var ErrVersionConflict = errors.New("icu: episode changed concurrently")

// EpisodeRepository persists the unit's own records.
//
// Every method takes authctx.TenantScope, which has no constructor outside the
// auth package, so reaching a row without a verified tenant does not compile
// (FIT-03).
type EpisodeRepository interface {
	InsertEpisode(ctx context.Context, scope authctx.TenantScope, e domain.Episode) error
	GetEpisode(ctx context.Context, scope authctx.TenantScope, episodeID string) (
		domain.Episode, error)
	UpdateEpisode(ctx context.Context, scope authctx.TenantScope, e domain.Episode,
		expectedVersion int64) error
	// OpenEpisodes is the unit as it stands, which is what the dashboard is.
	OpenEpisodes(ctx context.Context, scope authctx.TenantScope, unitID string,
		limit int32) ([]domain.Episode, error)
	// EpisodesInPeriod is every episode overlapping a window, for occupancy
	// and length of stay (SRS-ICU-017).
	EpisodesInPeriod(ctx context.Context, scope authctx.TenantScope, unitID string,
		from, to time.Time) ([]domain.Episode, error)
}

// FlowsheetRepository persists the high-frequency chart (SRS-ICU-002/003/007).
type FlowsheetRepository interface {
	InsertObservation(ctx context.Context, scope authctx.TenantScope,
		o domain.Observation) error
	GetObservation(ctx context.Context, scope authctx.TenantScope, observationID string) (
		domain.Observation, error)
	// Decide confirms or rejects a pending device reading. Returns false where
	// the reading was already decided, which is a race rather than an error.
	Decide(ctx context.Context, scope authctx.TenantScope, o domain.Observation) (
		bool, error)
	Observations(ctx context.Context, scope authctx.TenantScope, episodeID string,
		since time.Time, limit int32) (domain.ObservationList, error)
	// Pending is the nurse's validation worklist.
	Pending(ctx context.Context, scope authctx.TenantScope, episodeID string,
		limit int32) (domain.ObservationList, error)

	InsertBalanceEntry(ctx context.Context, scope authctx.TenantScope,
		e domain.BalanceEntry) error
	// Supersede marks an entry corrected. Returns false where it was already
	// superseded, so two corrections of the same entry do not both count.
	Supersede(ctx context.Context, scope authctx.TenantScope, entryID,
		supersededBy string) (bool, error)
	BalanceEntries(ctx context.Context, scope authctx.TenantScope, episodeID string,
		from, to time.Time) ([]domain.BalanceEntry, error)
}

// SupportRepository persists organ support and the things in the patient
// (SRS-ICU-004/005/006/011).
type SupportRepository interface {
	InsertSupport(ctx context.Context, scope authctx.TenantScope, s domain.Support) error
	StopSupport(ctx context.Context, scope authctx.TenantScope, supportID, by,
		note string, at time.Time) (bool, error)
	Support(ctx context.Context, scope authctx.TenantScope, episodeID string) (
		[]domain.Support, error)

	InsertVentSetting(ctx context.Context, scope authctx.TenantScope,
		s domain.VentSetting) error
	VentSettings(ctx context.Context, scope authctx.TenantScope, episodeID string) (
		domain.VentTimeline, error)

	InsertInfusion(ctx context.Context, scope authctx.TenantScope, i domain.Infusion) error
	GetInfusion(ctx context.Context, scope authctx.TenantScope, infusionID string) (
		domain.Infusion, error)
	InsertTitration(ctx context.Context, scope authctx.TenantScope, infusionID string,
		t domain.Titration) error
	StopInfusion(ctx context.Context, scope authctx.TenantScope, infusionID, by string,
		at time.Time) (bool, error)
	Infusions(ctx context.Context, scope authctx.TenantScope, episodeID string) (
		[]domain.Infusion, error)

	InsertDevice(ctx context.Context, scope authctx.TenantScope,
		d domain.InvasiveDevice) error
	RemoveDevice(ctx context.Context, scope authctx.TenantScope, deviceID, by,
		reason string, at time.Time) (bool, error)
	ReviewDevice(ctx context.Context, scope authctx.TenantScope, deviceID, by string,
		at time.Time) (bool, error)
	Devices(ctx context.Context, scope authctx.TenantScope, episodeID string) (
		[]domain.InvasiveDevice, error)
	// DevicesInPeriod is unit-wide, for device days (SRS-ICU-017).
	DevicesInPeriod(ctx context.Context, scope authctx.TenantScope, unitID string,
		from, to time.Time) ([]domain.InvasiveDevice, error)
}

// CareRepository persists scores, bundles, assessments, rounds and the ceiling
// of treatment (SRS-ICU-008/009/010/014/015).
type CareRepository interface {
	InsertScore(ctx context.Context, scope authctx.TenantScope, s domain.Score) error
	Scores(ctx context.Context, scope authctx.TenantScope, episodeID string,
		limit int32) ([]domain.Score, error)

	InsertBundle(ctx context.Context, scope authctx.TenantScope,
		p domain.BundlePerformance) error
	Bundles(ctx context.Context, scope authctx.TenantScope, episodeID string,
		limit int32) ([]domain.BundlePerformance, error)

	InsertAssessment(ctx context.Context, scope authctx.TenantScope,
		a domain.Assessment) error
	Assessments(ctx context.Context, scope authctx.TenantScope, episodeID string,
		limit int32) ([]domain.Assessment, error)

	InsertRound(ctx context.Context, scope authctx.TenantScope, r domain.Round) error
	Rounds(ctx context.Context, scope authctx.TenantScope, episodeID string,
		limit int32) ([]domain.Round, error)

	InsertGoal(ctx context.Context, scope authctx.TenantScope, g domain.Goal) error
	ResolveGoal(ctx context.Context, scope authctx.TenantScope, g domain.Goal) (bool, error)
	Goals(ctx context.Context, scope authctx.TenantScope, episodeID string) (
		[]domain.Goal, error)

	// InsertGoalsOfCare supersedes any ceiling in force and records the new
	// one. One call, because a unit that briefly had two current ceilings is
	// one where a resuscitation decision was ambiguous.
	InsertGoalsOfCare(ctx context.Context, scope authctx.TenantScope,
		g domain.GoalsOfCare) error
	GoalsOfCare(ctx context.Context, scope authctx.TenantScope, episodeID string) (
		[]domain.GoalsOfCare, error)
}

// Encounters reports whether the Wave-1 encounter a critical-care episode
// hangs off still accepts content, and which patient it belongs to.
type Encounters interface {
	Writable(ctx context.Context, scope authctx.TenantScope, encounterID string) (
		patientID string, writable bool, err error)
}

// Escalations raises a durable notice for a condition somebody must answer
// (SRS-ICU-013, SRS-OPSNFR-003).
//
// Nil is a valid deployment: a six-bed unit where the nurse in charge can see
// every bed has a working escalation mechanism this software is not part of.
type Escalations interface {
	RaiseAdvisory(ctx context.Context, scope authctx.TenantScope, n AdvisoryNotice) (
		noticeID string, err error)
}

// AdvisoryNotice is an operational condition, as the escalation mechanism
// needs it.
//
// Carries no clinical detail. SRS-ICU-013 is explicit that this software's
// alarms are advisory and operational, and an escalation inbox is read by a
// mechanism that knows nothing about clinical confidentiality (SRS-API-009).
type AdvisoryNotice struct {
	EpisodeID  string
	PatientID  string
	FacilityID string
	UnitID     string
	BedID      string
	Kind       string
	Summary    string
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
