// Package ports declares what the blood bank application layer needs.
//
// Declared by the consumer rather than by the adapters that implement them,
// which keeps the dependency arrow pointing inward (Blueprint §4.1).
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/bloodbank/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
)

// ErrVersionConflict reports that another writer got there first.
var ErrVersionConflict = errors.New("bloodbank: changed concurrently")

// DonorRepository persists donors, screenings, collections and testing.
//
// Every method takes authctx.TenantScope, which has no constructor outside the
// auth package, so reaching a row without a verified tenant does not compile
// (FIT-03).
type DonorRepository interface {
	InsertDonor(ctx context.Context, scope authctx.TenantScope, d domain.Donor) error
	Donor(ctx context.Context, scope authctx.TenantScope, donorID string) (
		domain.Donor, error)
	DonorByNumber(ctx context.Context, scope authctx.TenantScope, number string) (
		domain.Donor, error)
	UpdateDeferral(ctx context.Context, scope authctx.TenantScope, d domain.Donor,
		expectedVersion int64) error
	// Deferred is the list a screening desk reads before accepting anybody.
	Deferred(ctx context.Context, scope authctx.TenantScope, asOf time.Time,
		limit int32) ([]domain.Donor, error)

	InsertScreening(ctx context.Context, scope authctx.TenantScope,
		s domain.Screening) error
	Screening(ctx context.Context, scope authctx.TenantScope, screeningID string) (
		domain.Screening, error)
	Screenings(ctx context.Context, scope authctx.TenantScope, donorID string,
		limit int32) ([]domain.Screening, error)

	InsertCollection(ctx context.Context, scope authctx.TenantScope,
		c domain.Collection) error
	Collection(ctx context.Context, scope authctx.TenantScope, collectionID string) (
		domain.Collection, error)

	InsertTestResult(ctx context.Context, scope authctx.TenantScope,
		r domain.TestResult) error
	TestResults(ctx context.Context, scope authctx.TenantScope,
		collectionID string) ([]domain.TestResult, error)
}

// InventoryRepository persists components and stock thresholds.
type InventoryRepository interface {
	InsertComponent(ctx context.Context, scope authctx.TenantScope,
		c domain.Component) error
	Component(ctx context.Context, scope authctx.TenantScope, componentID string) (
		domain.Component, error)
	// ComponentByNumber is the read a bedside scan makes: the label carries
	// the unit number, not the row id.
	ComponentByNumber(ctx context.Context, scope authctx.TenantScope,
		unitNumber string) (domain.Component, error)
	UpdateStatus(ctx context.Context, scope authctx.TenantScope,
		c domain.Component, expectedVersion int64) error
	// ComponentsForCollection is how a release applies to every component made
	// from one donation, and how a look-back finds the siblings.
	ComponentsForCollection(ctx context.Context, scope authctx.TenantScope,
		collectionID string) ([]domain.Component, error)
	// Siblings is the look-back direction: from one component to every other
	// made from the same donation.
	Siblings(ctx context.Context, scope authctx.TenantScope, componentID string) (
		[]domain.Component, error)

	// Allocatable narrows by component class and status and hands back
	// candidates, soonest to expire first. Compatibility is the domain's to
	// decide, never SQL's.
	Allocatable(ctx context.Context, scope authctx.TenantScope,
		class domain.ComponentClass, asOf time.Time, limit int32) (
		[]domain.Component, error)
	// Inventory is everything on the shelf, including what is not allocatable:
	// a bank short because everything is reserved has a different problem from
	// one short because nothing has been tested.
	Inventory(ctx context.Context, scope authctx.TenantScope, limit int32) (
		[]domain.Component, error)
	CountDiscarded(ctx context.Context, scope authctx.TenantScope,
		from, to time.Time) (int, error)

	SaveThreshold(ctx context.Context, scope authctx.TenantScope,
		facilityID string, t domain.StockThreshold, by string,
		at time.Time) error
	Thresholds(ctx context.Context, scope authctx.TenantScope, facilityID string) (
		[]domain.StockThreshold, error)
}

// CrossmatchRepository persists requests, samples, reservations and issues.
type CrossmatchRepository interface {
	InsertRequest(ctx context.Context, scope authctx.TenantScope,
		r domain.Request) error
	Request(ctx context.Context, scope authctx.TenantScope, requestID string) (
		domain.Request, error)
	UpdateRequestStatus(ctx context.Context, scope authctx.TenantScope,
		requestID string, status domain.RequestStatus, expectedVersion int64) error
	PatientRequests(ctx context.Context, scope authctx.TenantScope,
		patientID string, limit int32) ([]domain.Request, error)
	// OpenRequests is the blood bank's worklist, most urgent and soonest
	// needed first.
	OpenRequests(ctx context.Context, scope authctx.TenantScope,
		facilityID string, limit int32) ([]domain.Request, error)

	InsertSample(ctx context.Context, scope authctx.TenantScope,
		s domain.PatientSample) error
	Sample(ctx context.Context, scope authctx.TenantScope, sampleID string) (
		domain.PatientSample, error)
	// CurrentSample is the patient's latest unexpired sample, which is what a
	// crossmatch runs against. False where there is none, which is an
	// ordinary state and the reason a match is refused.
	CurrentSample(ctx context.Context, scope authctx.TenantScope,
		patientID string, asOf time.Time) (domain.PatientSample, bool, error)

	InsertReservation(ctx context.Context, scope authctx.TenantScope,
		r domain.Reservation) error
	Reservation(ctx context.Context, scope authctx.TenantScope,
		reservationID string) (domain.Reservation, error)
	// CloseReservation is false where somebody closed it first, so two callers
	// releasing the same hold do not produce two release reasons.
	CloseReservation(ctx context.Context, scope authctx.TenantScope,
		reservationID string, status domain.ReservationStatus, reason string) (
		bool, error)
	ReservationsForComponent(ctx context.Context, scope authctx.TenantScope,
		componentID string) ([]domain.Reservation, error)
	PatientReservations(ctx context.Context, scope authctx.TenantScope,
		patientID string, limit int32) ([]domain.Reservation, error)
	// Lapsed are reservations past their window, for the sweep that returns
	// held blood to the shelf.
	Lapsed(ctx context.Context, scope authctx.TenantScope, asOf time.Time,
		limit int32) ([]domain.Reservation, error)
	CountReservations(ctx context.Context, scope authctx.TenantScope,
		from, to time.Time) (int, error)

	InsertIssue(ctx context.Context, scope authctx.TenantScope,
		i domain.Issue) error
	Issue(ctx context.Context, scope authctx.TenantScope, issueID string) (
		domain.Issue, error)
	// LatestIssue is what a bedside check verifies against.
	LatestIssue(ctx context.Context, scope authctx.TenantScope,
		componentID string) (domain.Issue, bool, error)
	IssuesForComponent(ctx context.Context, scope authctx.TenantScope,
		componentID string) ([]domain.Issue, error)
	IssuesInPeriod(ctx context.Context, scope authctx.TenantScope,
		from, to time.Time, limit int32) ([]domain.Issue, error)
	// Reconcile completes an emergency release's retrospective crossmatch.
	// False where it was already reconciled.
	Reconcile(ctx context.Context, scope authctx.TenantScope, issueID, note,
		by string, at time.Time) (bool, error)
	Unreconciled(ctx context.Context, scope authctx.TenantScope, limit int32) (
		[]domain.Issue, error)
}

// TransfusionRepository persists episodes, observations and reactions.
type TransfusionRepository interface {
	InsertEpisode(ctx context.Context, scope authctx.TenantScope,
		e domain.Episode, check domain.BedsideCheck) error
	Episode(ctx context.Context, scope authctx.TenantScope, episodeID string) (
		domain.Episode, error)
	UpdateEpisode(ctx context.Context, scope authctx.TenantScope,
		e domain.Episode) error
	EpisodesForComponent(ctx context.Context, scope authctx.TenantScope,
		componentID string) ([]domain.Episode, error)
	// PatientEpisodes is the transfusion history across admissions, which is
	// what SRS-BLD-011's "longitudinally visible" means.
	PatientEpisodes(ctx context.Context, scope authctx.TenantScope,
		patientID string, limit int32) ([]domain.Episode, error)
	EpisodesInPeriod(ctx context.Context, scope authctx.TenantScope,
		from, to time.Time, limit int32) ([]domain.Episode, error)

	InsertObservation(ctx context.Context, scope authctx.TenantScope,
		o domain.Observation) error
	Observations(ctx context.Context, scope authctx.TenantScope,
		episodeID string) ([]domain.Observation, error)

	InsertReaction(ctx context.Context, scope authctx.TenantScope,
		r domain.Reaction) error
	Reaction(ctx context.Context, scope authctx.TenantScope, reactionID string) (
		domain.Reaction, error)
	// ConcludeReaction is false where the investigation was already closed.
	ConcludeReaction(ctx context.Context, scope authctx.TenantScope,
		r domain.Reaction) (bool, error)
	ReactionsForComponent(ctx context.Context, scope authctx.TenantScope,
		componentID string) ([]domain.Reaction, error)
	OpenReactions(ctx context.Context, scope authctx.TenantScope, limit int32) (
		[]domain.Reaction, error)
	ReactionsInPeriod(ctx context.Context, scope authctx.TenantScope,
		from, to time.Time, limit int32) ([]domain.Reaction, error)

	// DonorRecipients runs the look-back from a donor to every patient who
	// received their blood. Deliberately thin, because that list is read
	// outside the care team.
	DonorRecipients(ctx context.Context, scope authctx.TenantScope,
		donorID string, limit int32) ([]Recipient, error)
}

// Recipient is a patient reached by a look-back.
//
// Identifiers and times, no clinical detail: a look-back list goes to a
// haemovigilance officer and sometimes to a regulator.
type Recipient struct {
	PatientID   string
	EpisodeID   string
	ComponentID string
	UnitNumber  string
	At          time.Time
}

// Patients reports what the patient index knows about somebody being
// transfused.
//
// A port, because the patient belongs to SRS-EMPI and a blood bank holding its
// own copy of who a patient is would crossmatch against the wrong person.
type Patients interface {
	// Exists reports a patient the index knows. False rather than an error for
	// an unknown one, so a caller can say so rather than leaking whether an
	// identifier is real in another tenant.
	Exists(ctx context.Context, scope authctx.TenantScope, patientID string) (
		bool, error)
}

// EventAppender publishes domain events through the outbox.
type EventAppender interface {
	Append(ctx context.Context, e outbox.Event) error
}

// AuditAppender writes the append-only audit trail.
type AuditAppender interface {
	Append(ctx context.Context, r audit.Record) error
}

// Notice is something somebody has to be told about now.
type Notice struct {
	// Kind matches the escalation matrix's kind, so a hospital configures who
	// is paged without this context knowing.
	Kind string
	// Subject is the thing in this context: a unit number.
	Subject string
	// PatientID and FacilityID let a recipient see who and where it concerns
	// without reaching into the blood bank.
	PatientID  string
	FacilityID string
	Summary    string
}

// Escalator raises a durable, acknowledged notice.
//
// Used for the one thing in this context that cannot wait for somebody to
// refresh a screen: a bedside identity mismatch, which SRS-BLD-010 calls a
// critical exception.
//
// It does not take recipients. Who is paged is the tenant's configured
// escalation matrix, resolved at delivery: a caller that named recipients
// would be a second place to configure the chain, and the two would disagree
// the first time somebody changed a rota.
type Escalator interface {
	Raise(ctx context.Context, scope authctx.TenantScope, n Notice,
		at time.Time) (string, error)
}

// UnitOfWork runs a use case in one transaction.
type UnitOfWork interface {
	WithinTx(ctx context.Context, fn func(context.Context) error) error
}

// IDGenerator mints identifiers.
type IDGenerator interface{ NewID() string }

// Clock reads the time.
type Clock interface{ Now() time.Time }
