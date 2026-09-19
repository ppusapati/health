// Package ports declares what the perioperative application layer needs.
//
// Declared by the consumer rather than by the adapters that implement them,
// which keeps the dependency arrow pointing inward (Blueprint §4.1).
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/theatre/domain"
)

// ErrVersionConflict reports that another writer advanced the case first.
var ErrVersionConflict = errors.New("theatre: case changed concurrently")

// ScheduleRepository persists rooms, blocks and cases.
//
// Every method takes authctx.TenantScope, which has no constructor outside the
// auth package, so reaching a row without a verified tenant does not compile
// (FIT-03).
type ScheduleRepository interface {
	SaveRoom(ctx context.Context, scope authctx.TenantScope, r domain.Room) error
	Room(ctx context.Context, scope authctx.TenantScope, roomID string) (
		domain.Room, error)
	Rooms(ctx context.Context, scope authctx.TenantScope, facilityID string) (
		[]domain.Room, error)

	InsertBlock(ctx context.Context, scope authctx.TenantScope, b domain.Block) error
	Blocks(ctx context.Context, scope authctx.TenantScope, facilityID string,
		from, to time.Time) ([]domain.Block, error)

	InsertCase(ctx context.Context, scope authctx.TenantScope, c domain.Case) error
	Case(ctx context.Context, scope authctx.TenantScope, caseID string) (
		domain.Case, error)
	UpdateCase(ctx context.Context, scope authctx.TenantScope, c domain.Case,
		expectedVersion int64) error

	// RoomCases is one room's list over a window, which the slot check and the
	// board both read.
	RoomCases(ctx context.Context, scope authctx.TenantScope, roomID string,
		from, to time.Time) ([]domain.Case, error)
	// SurgeonCases is a surgeon's own diary, for the "operating elsewhere"
	// check a room-only search misses.
	SurgeonCases(ctx context.Context, scope authctx.TenantScope, surgeonID string,
		from, to time.Time) ([]domain.Case, error)
	CasesInPeriod(ctx context.Context, scope authctx.TenantScope, facilityID string,
		from, to time.Time) ([]domain.Case, error)
	Waiting(ctx context.Context, scope authctx.TenantScope, facilityID string,
		limit int32) ([]domain.Case, error)
}

// CaseRepository persists what happens to a case.
type CaseRepository interface {
	SavePreopEntry(ctx context.Context, scope authctx.TenantScope, caseID string,
		e domain.PreopEntry) error
	PreopChecklist(ctx context.Context, scope authctx.TenantScope, caseID string) (
		domain.PreopChecklist, error)

	InsertSafetyCheck(ctx context.Context, scope authctx.TenantScope,
		r domain.SafetyRecord) error
	SafetyChecks(ctx context.Context, scope authctx.TenantScope, caseID string) (
		[]domain.SafetyRecord, error)

	InsertMilestone(ctx context.Context, scope authctx.TenantScope,
		m domain.MilestoneRecord) error
	Milestones(ctx context.Context, scope authctx.TenantScope, caseID string) (
		domain.Milestones, error)
	// MilestonesFor reads many cases at once, so the board and the utilisation
	// report do not make one round trip per case.
	MilestonesFor(ctx context.Context, scope authctx.TenantScope, caseIDs []string) (
		map[string]domain.Milestones, error)

	InsertDelay(ctx context.Context, scope authctx.TenantScope, d domain.Delay) error
	DelaysFor(ctx context.Context, scope authctx.TenantScope, caseIDs []string) (
		map[string][]domain.Delay, error)

	InsertNote(ctx context.Context, scope authctx.TenantScope,
		n domain.OperativeNote) error
	SignNote(ctx context.Context, scope authctx.TenantScope, noteID, by string,
		at time.Time) (bool, error)
	SupersedeNote(ctx context.Context, scope authctx.TenantScope, noteID string) (
		bool, error)
	Notes(ctx context.Context, scope authctx.TenantScope, caseID string) (
		[]domain.OperativeNote, error)

	InsertUsage(ctx context.Context, scope authctx.TenantScope, u domain.Usage) error
	Usage(ctx context.Context, scope authctx.TenantScope, caseID string) (
		[]domain.Usage, error)
	// ImplantRecipients is the direction a recall runs: from an item to the
	// patients who received it.
	ImplantRecipients(ctx context.Context, scope authctx.TenantScope,
		itemCode, lotNumber string) ([]Recipient, error)

	InsertSpecimen(ctx context.Context, scope authctx.TenantScope,
		s domain.Specimen) error
	// Accession links a specimen to an order. False where somebody linked it
	// first, so two orders cannot both claim one pot.
	Accession(ctx context.Context, scope authctx.TenantScope, specimenID,
		orderID string) (bool, error)
	Specimens(ctx context.Context, scope authctx.TenantScope, caseID string) (
		[]domain.Specimen, error)
	UnaccessionedSpecimens(ctx context.Context, scope authctx.TenantScope,
		facilityID string, limit int32) ([]domain.Specimen, error)

	InsertTrayUse(ctx context.Context, scope authctx.TenantScope,
		t domain.TrayUse) error
	TrayUses(ctx context.Context, scope authctx.TenantScope, caseID string) (
		[]domain.TrayUse, error)
	// CycleRecipients is the direction an infection investigation runs: from a
	// sterilisation cycle to the patients whose cases used it.
	CycleRecipients(ctx context.Context, scope authctx.TenantScope, cycleID string) (
		[]Recipient, error)

	SaveCard(ctx context.Context, scope authctx.TenantScope,
		c domain.PreferenceCard) error
	Card(ctx context.Context, scope authctx.TenantScope, surgeonID,
		procedureCode string) (domain.PreferenceCard, bool, error)
}

// Recipient is a patient reached by a traceability query.
//
// Deliberately thin: identifiers and what links them, no clinical detail. A
// recall list and an infection investigation are both read by people outside
// the care team.
type Recipient struct {
	PatientID   string
	EncounterID string
	CaseID      string
	// Reference is the serial, lot or tray that links them.
	Reference string
	At        time.Time
}

// Encounters reports whether the Wave-1 encounter a case hangs off still
// accepts content, and which patient it belongs to.
type Encounters interface {
	Writable(ctx context.Context, scope authctx.TenantScope, encounterID string) (
		patientID string, writable bool, err error)
}

// Procedures answers what the deployment's terminology knows about a procedure
// code.
//
// A port, because whether a procedure has sides is a fact about the code
// system rather than about theatre, and a theatre that kept its own list would
// have one that disagreed with the coding department's.
type Procedures interface {
	// SideRequired reports whether a procedure has laterality. A code the
	// terminology does not know returns false and no error: an unknown code is
	// the coding department's problem, and refusing to book the patient is not
	// the fix.
	SideRequired(ctx context.Context, scope authctx.TenantScope, code string) (
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

// UnitOfWork runs a use case in one transaction.
type UnitOfWork interface {
	WithinTx(ctx context.Context, fn func(context.Context) error) error
}

// IDGenerator mints identifiers.
type IDGenerator interface{ NewID() string }

// Clock reads the time.
type Clock interface{ Now() time.Time }

// Equipment reports what the machines standing in a room can actually do
// (SRS-BIO-009).
//
// Owned here and implemented by an adapter over the equipment register, so
// the theatre asks the question without owning the answer. Optional: a
// deployment without an equipment register leaves it nil and the scheduler
// trusts the room's fitted list, which is what it did before the register
// existed.
type Equipment interface {
	// StatusFor reads one room, named by every identifier it is known by —
	// its id and its code. Both, because the engineer who registers a
	// ventilator types the code on the door and the scheduler holds the id,
	// and a link that bound only to one of those would be wired and never
	// carry anything.
	//
	// A room the register knows nothing about returns a zero status and no
	// error: a theatre with no machines on the register is not an error, it
	// is a theatre nobody has surveyed yet.
	StatusFor(ctx context.Context, scope authctx.TenantScope,
		locations []string) (domain.EquipmentStatus, error)
}
