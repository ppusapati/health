// Package ports declares what the mortuary use cases need from the outside.
//
// Interfaces owned by this context rather than by whoever implements them, so
// the dependency arrow points inward (FIT-01).
//
// Three absences are deliberate and load-bearing.
//
// There is no method that edits or deletes a custody entry. A chain of
// custody somebody can rewrite is not one, and the whole value of the record
// is that nobody can reach into it afterwards.
//
// There is no method that clears a case's medico-legal mark. A case that was
// medico-legal and is no longer is one where somebody decided the coroner has
// lost interest, and that is the coroner's decision. What ends the hold is an
// authorisation naming the authority, which is a different act with a
// different record.
//
// And there is no method that releases a body without running the checks.
// ReleaseBody takes everything the checks need and there is no second door:
// "the case cannot bypass required authorization" is a property of there
// being nowhere else to go.
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/mortuary/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
)

// ErrVersionConflict is a lost update: somebody else changed the record
// between the read and the write.
var ErrVersionConflict = errors.New("mortuary: version conflict")

// CaseFilter narrows a case list.
type CaseFilter struct {
	States     []domain.CaseState
	Identities []domain.Identity
	FacilityID string
	// MedicoLegalOnly narrows to the cases an authority has an interest
	// in, which is the list a coroner's officer asks for.
	MedicoLegalOnly bool
	From            time.Time
	To              time.Time
	Limit           int32
	Offset          int32
}

// CaseRepository persists mortuary cases (SRS-MORT-001).
//
// Every method takes authctx.TenantScope, which has no constructor outside
// the auth package, so reaching a row without a verified tenant does not
// compile (FIT-03).
type CaseRepository interface {
	InsertCase(ctx context.Context, scope authctx.TenantScope,
		c domain.Case) error
	Case(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Case, error)
	// CaseByReference is how the desk finds a case from the number on the
	// paperwork a family is holding.
	CaseByReference(ctx context.Context, scope authctx.TenantScope,
		reference string) (domain.Case, error)
	UpdateCase(ctx context.Context, scope authctx.TenantScope,
		c domain.Case, expectedVersion int64) error
	Cases(ctx context.Context, scope authctx.TenantScope, f CaseFilter) (
		[]domain.Case, error)
}

// LocationFilter narrows a storage list.
type LocationFilter struct {
	FacilityID string
	Kinds      []domain.SpaceKind
	// InServiceOnly hides the broken units, which is what a board looking
	// for somewhere to put a body wants.
	InServiceOnly bool
	Limit         int32
	Offset        int32
}

// StorageRepository persists spaces and placements (SRS-MORT-002).
//
// EndPlacement is its own method and takes no version, because the row it
// closes is identified by being the current one: two writers closing the same
// placement is one of them getting no rows back rather than a lost update.
type StorageRepository interface {
	InsertLocation(ctx context.Context, scope authctx.TenantScope,
		l domain.Location) error
	Location(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Location, error)
	UpdateLocation(ctx context.Context, scope authctx.TenantScope,
		l domain.Location, expectedVersion int64) error
	Locations(ctx context.Context, scope authctx.TenantScope,
		f LocationFilter) ([]domain.Location, error)

	InsertPlacement(ctx context.Context, scope authctx.TenantScope,
		p domain.Placement) error
	// CurrentPlacement is where a body is now, and absent when it is
	// nowhere.
	CurrentPlacement(ctx context.Context, scope authctx.TenantScope,
		caseID string) (domain.Placement, error)
	EndPlacement(ctx context.Context, scope authctx.TenantScope,
		p domain.Placement) error
	Placements(ctx context.Context, scope authctx.TenantScope,
		caseIDs []string) ([]domain.Placement, error)
	// OccupiedLocations is what the occupancy count reads. Identifiers
	// only: a board does not need to know who is in which drawer to count
	// the free ones.
	OccupiedLocations(ctx context.Context, scope authctx.TenantScope) (
		map[string]bool, error)
}

// CustodyRepository persists belongings and the chain (SRS-MORT-004).
type CustodyRepository interface {
	InsertItem(ctx context.Context, scope authctx.TenantScope,
		i domain.Item) error
	Item(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Item, error)
	// UpdateItemState moves an item between held, handed over and
	// retained, and takes the state it expects to find: an item handed
	// over twice is a family signing for what they already have.
	UpdateItemState(ctx context.Context, scope authctx.TenantScope,
		i domain.Item, expectedState domain.ItemState) error
	Items(ctx context.Context, scope authctx.TenantScope,
		caseIDs []string) ([]domain.Item, error)

	InsertHandover(ctx context.Context, scope authctx.TenantScope,
		h domain.Handover) error
	Handovers(ctx context.Context, scope authctx.TenantScope,
		caseID string) ([]domain.Handover, error)

	// AppendCustody inserts one line. There is no method that changes one
	// (FIT-08).
	AppendCustody(ctx context.Context, scope authctx.TenantScope,
		e domain.CustodyEntry) error
	Custody(ctx context.Context, scope authctx.TenantScope,
		caseID string) ([]domain.CustodyEntry, error)
}

// PostmortemRepository persists examination requests (SRS-MORT-005).
type PostmortemRepository interface {
	InsertPostmortem(ctx context.Context, scope authctx.TenantScope,
		p domain.Postmortem) error
	Postmortem(ctx context.Context, scope authctx.TenantScope,
		id string) (domain.Postmortem, error)
	UpdatePostmortem(ctx context.Context, scope authctx.TenantScope,
		p domain.Postmortem, expectedVersion int64) error
	Postmortems(ctx context.Context, scope authctx.TenantScope,
		caseIDs []string) ([]domain.Postmortem, error)
}

// ReleaseFilter narrows a release list.
type ReleaseFilter struct {
	From   time.Time
	To     time.Time
	Limit  int32
	Offset int32
}

// ReleaseRepository persists authorisations and releases (SRS-MORT-006,
// SRS-MORT-007).
type ReleaseRepository interface {
	InsertAuthorisation(ctx context.Context, scope authctx.TenantScope,
		id, caseID string, a domain.Authorisation) error
	// LatestAuthorisation is the clearance a release is checked against.
	// Absent rather than an error when there is none: no clearance is an
	// answer, and it is the answer the checks act on.
	LatestAuthorisation(ctx context.Context, scope authctx.TenantScope,
		caseID string) (domain.Authorisation, error)
	Authorisations(ctx context.Context, scope authctx.TenantScope,
		caseIDs []string) (map[string]domain.Authorisation, error)

	InsertRelease(ctx context.Context, scope authctx.TenantScope,
		r domain.Release) error
	Release(ctx context.Context, scope authctx.TenantScope,
		caseID string) (domain.Release, error)
	Releases(ctx context.Context, scope authctx.TenantScope,
		f ReleaseFilter) ([]domain.Release, error)
}

// Encounters is the read this context needs from the encounter context
// (SRS-MORT-001).
//
// A case opened against a death this hospital recorded names the encounter,
// and this is what says the encounter is real. Read-only: the mortuary
// cannot create or close one.
type Encounters interface {
	// Exists reports whether the encounter is one this tenant has. An
	// error other than absence is returned rather than swallowed: a
	// directory that is down must not read as a directory that says no.
	Exists(ctx context.Context, scope authctx.TenantScope,
		encounterID string) (bool, error)
}

// Patients is the read this context needs from the patient index
// (SRS-MORT-001).
type Patients interface {
	Exists(ctx context.Context, scope authctx.TenantScope,
		patientID string) (bool, error)
}

// Notice is something somebody has to be told about now.
type Notice struct {
	Kind       string
	Subject    string
	FacilityID string
	Summary    string
}

// Escalator raises a durable, acknowledged notice (SRS-MORT-007,
// SRS-MORT-008).
//
// Used where a rule is broken in a way a report would not catch in time: a
// body held past the deployment's limit, and an unidentified case nobody has
// worked on.
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

// UnitOfWork runs a use case in one transaction. The outbox requires an open
// transaction (ADR-0004).
type UnitOfWork interface {
	WithinTx(ctx context.Context, fn func(context.Context) error) error
}

// IDGenerator mints identifiers.
type IDGenerator interface{ NewID() string }

// Clock reads the time.
type Clock interface{ Now() time.Time }
