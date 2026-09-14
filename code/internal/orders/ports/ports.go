// Package ports declares what the order application layer needs.
//
// Declared by the consumer rather than by the adapters that implement them,
// which keeps the dependency arrow pointing inward (Blueprint §4.1).
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/orders/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
)

// ErrVersionConflict reports that another writer advanced the record first.
var ErrVersionConflict = errors.New("orders: record changed concurrently")

// ErrAlreadyAcknowledged reports a delivery this order has already seen
// (SRS-ORD-006).
//
// Not an error the caller should surface as a failure: a redelivery is the
// normal behaviour of an at-least-once bus, and the right response is to
// acknowledge and do nothing.
var ErrAlreadyAcknowledged = errors.New("orders: this delivery has already been applied")

// OrderRepository persists orders and their history (SRS-ORD-001).
//
// Every method takes authctx.TenantScope, which has no constructor outside the
// auth package, so reaching a row without a verified tenant does not compile
// (FIT-03).
type OrderRepository interface {
	// Insert stores an order as it stands — status, version and any duplicate
	// override included. Placing is one act, and a draft that reached the table
	// and was then updated would be visible to a concurrent reader in a state
	// the clinician never intended.
	Insert(ctx context.Context, scope authctx.TenantScope, o *domain.Order) error
	// InsertStatusChange records one history entry without touching the order,
	// for the transition an Insert already carried.
	InsertStatusChange(ctx context.Context, scope authctx.TenantScope,
		orderID string, change domain.StatusChange) error
	Get(ctx context.Context, scope authctx.TenantScope, orderID string) (
		*domain.Order, error)
	// UpdateStatus records a transition and its history entry together, so an
	// order cannot reach a state with no record of how it got there.
	UpdateStatus(ctx context.Context, scope authctx.TenantScope, o *domain.Order,
		change domain.StatusChange, expectedVersion int64) error
	// UpdateDraft edits an unplaced order. Guarded on it still being a draft as
	// well as on its version, so SRS-ORD-005's lifecycle holds at the table.
	UpdateDraft(ctx context.Context, scope authctx.TenantScope, o *domain.Order,
		expectedVersion int64) error
	RequestCancellation(ctx context.Context, scope authctx.TenantScope,
		o *domain.Order, expectedVersion int64) error
	RecordDuplicateOverride(ctx context.Context, scope authctx.TenantScope,
		o *domain.Order, expectedVersion int64) error

	ForPatient(ctx context.Context, scope authctx.TenantScope, q OrderQuery) (
		[]*domain.Order, error)
	// LiveOfType is what the duplicate check reads (SRS-ORD-009).
	LiveOfType(ctx context.Context, scope authctx.TenantScope, patientID string,
		orderType domain.Type, since time.Time, limit int32) (
		[]*domain.Order, error)
	ForService(ctx context.Context, scope authctx.TenantScope,
		service, facilityID string, limit int32) ([]*domain.Order, error)
}

// OrderQuery narrows a patient's order list.
type OrderQuery struct {
	PatientID   string
	EncounterID string
	Type        domain.Type
	// LiveOnly hides finished orders. Off by default: a chart shows what was
	// ordered, not only what is outstanding.
	LiveOnly bool
	Limit    int32
}

// AcknowledgementRepository records what performing services report
// (SRS-ORD-006).
type AcknowledgementRepository interface {
	// Claim records a delivery and reports whether it is new. It returns
	// ErrAlreadyAcknowledged for a redelivery, which is the idempotency the
	// requirement asks for and is enforced by a primary key rather than by a
	// check, because two deliveries can be in flight at the same moment.
	//
	// Claimed before the order is moved, so a redelivery that arrives after the
	// order has advanced is a clean no-op rather than an impossible-transition
	// error the consumer would retry forever.
	Claim(ctx context.Context, scope authctx.TenantScope,
		ack domain.Acknowledgement, now time.Time) error
	// MarkApplied records that a claimed delivery actually moved the order.
	MarkApplied(ctx context.Context, scope authctx.TenantScope,
		ack domain.Acknowledgement) error
	List(ctx context.Context, scope authctx.TenantScope, orderID string) (
		[]domain.Acknowledgement, error)
}

// CatalogueRepository persists order sets, favourites and configuration
// (SRS-ORD-003, SRS-ORD-009, SRS-ORD-012).
type CatalogueRepository interface {
	InsertSet(ctx context.Context, scope authctx.TenantScope,
		s domain.OrderSet) error
	GetSet(ctx context.Context, scope authctx.TenantScope, setID, version string) (
		domain.OrderSet, error)
	ListSets(ctx context.Context, scope authctx.TenantScope, specialty string,
		includeRetired bool, limit int32) ([]domain.OrderSet, error)
	RetireSet(ctx context.Context, scope authctx.TenantScope,
		setID, version string) error

	UpsertFavourite(ctx context.Context, scope authctx.TenantScope,
		f domain.Favourite) error
	GetFavourite(ctx context.Context, scope authctx.TenantScope,
		favouriteID string) (domain.Favourite, error)
	// ListFavourites is scoped to an owner: a favourite is never shared.
	ListFavourites(ctx context.Context, scope authctx.TenantScope, ownerID string,
		orderType domain.Type, limit int32) ([]domain.Favourite, error)
	DeleteFavourite(ctx context.Context, scope authctx.TenantScope,
		favouriteID, ownerID string) error

	SetPolicy(ctx context.Context, scope authctx.TenantScope, orderType domain.Type,
		indicationRequired, structuredTimingRequired bool,
		privilege, updatedBy string, now time.Time) error
	// Policy returns the tenant's configuration merged over the domain default,
	// so a tenant that has configured nothing gets the safe starting point
	// rather than no rules at all.
	Policy(ctx context.Context, scope authctx.TenantScope) (domain.Policy, error)

	SetDuplicateRule(ctx context.Context, scope authctx.TenantScope,
		rule domain.DuplicateRule, updatedBy string, now time.Time) error
	DuplicateRules(ctx context.Context, scope authctx.TenantScope) (
		map[domain.Type]domain.DuplicateRule, error)
}

// Numbers issues order numbers (SRS-PLT-014).
//
// The platform's sequence rather than one of this context's own: the guarantee
// it already provides — atomic, collision-free, and gapless because a
// rolled-back transaction returns its number — is exactly what an order number
// needs.
type Numbers interface {
	Issue(ctx context.Context, scope authctx.TenantScope, scope_ string,
		now time.Time) (string, error)
}

// Encounters is the seam onto the encounter context (SRS-ORD-002).
//
// An order is validated against "patient/encounter state", which is the
// encounter context's fact. A projection rather than the encounter: this
// context needs to know whether the visit is open and whose it is.
type Encounters interface {
	Check(ctx context.Context, scope authctx.TenantScope, encounterID string) (
		EncounterState, error)
}

// EncounterState is what the order context needs about an encounter.
type EncounterState struct {
	PatientID  string
	FacilityID string
	Open       bool
	// TimeZone is the facility's zone, which SRS-ORD-008's expansion needs: a
	// schedule computed in UTC puts a four-times-daily drug an hour out twice a
	// year.
	TimeZone string
}

// Dispatcher sends an order to the service that performs it (SRS-ORD-006).
//
// Declared as a port rather than as a direct call, because the requirement is
// explicit that routing happens "via event/RPC without database coupling". The
// production implementation writes to the outbox; a deployment whose laboratory
// speaks HL7 supplies a different one, and neither reads this schema.
type Dispatcher interface {
	Dispatch(ctx context.Context, scope authctx.TenantScope,
		d domain.Dispatch) error
}

// UnitOfWork runs a use case inside one database transaction.
type UnitOfWork interface {
	WithinTx(ctx context.Context, fn func(ctx context.Context) error) error
}

// EventAppender writes to the transactional outbox.
type EventAppender interface {
	Append(ctx context.Context, e outbox.Event) error
}

// AuditAppender records reads, writes and denials.
type AuditAppender interface {
	Append(ctx context.Context, r audit.Record) error
}

// IDGenerator issues identifiers.
type IDGenerator interface{ NewID() string }

// Clock reads the current time.
type Clock interface{ Now() time.Time }
