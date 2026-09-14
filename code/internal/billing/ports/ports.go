// Package ports declares what the billing application layer needs.
//
// Declared by the consumer rather than by the adapters that implement them,
// which keeps the dependency arrow pointing inward (Blueprint §4.1).
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/billing/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
)

// ErrVersionConflict reports that another writer advanced the record first.
var ErrVersionConflict = errors.New("billing: record changed concurrently")

// ErrAlreadyRecorded reports a charge or payment this account has already seen.
//
// Not an error the caller should surface as a failure. A redelivered clinical
// event and a retried payment submission are both normal, and the right
// response is to return what is already there (SRS-BIL-003, SRS-BIL-008).
var ErrAlreadyRecorded = errors.New("billing: already recorded")

// MasterRepository persists the charge master, the tariffs and the packages
// (SRS-BIL-001, SRS-BIL-002, SRS-BIL-004).
//
// Every method takes authctx.TenantScope, which has no constructor outside the
// auth package, so reaching a row without a verified tenant does not compile
// (FIT-03).
type MasterRepository interface {
	// PublishService ends the current version and starts a new one in one act,
	// so there is never a moment with two versions in force or none.
	PublishService(ctx context.Context, scope authctx.TenantScope,
		item domain.ServiceItem) error
	// ServiceVersions returns every version of a code, so the caller resolves
	// the one in force at the moment of care rather than the one in force now.
	ServiceVersions(ctx context.Context, scope authctx.TenantScope, code string) (
		[]domain.ServiceItem, error)
	Services(ctx context.Context, scope authctx.TenantScope, limit int32) (
		[]domain.ServiceItem, error)

	UpsertTariff(ctx context.Context, scope authctx.TenantScope,
		lineID string, line domain.TariffLine) error
	// TariffsFor returns everything that could price a service, including the
	// contracts whose service axis is empty — a query keyed only on the code
	// would miss the standard list price.
	TariffsFor(ctx context.Context, scope authctx.TenantScope, serviceCode string) (
		[]domain.TariffLine, error)
	Tariffs(ctx context.Context, scope authctx.TenantScope, limit int32) (
		[]domain.TariffLine, error)

	PublishPackage(ctx context.Context, scope authctx.TenantScope,
		p domain.Package) error
	PackageAt(ctx context.Context, scope authctx.TenantScope, code string,
		at time.Time) (domain.Package, error)
	Packages(ctx context.Context, scope authctx.TenantScope, limit int32) (
		[]domain.Package, error)
}

// AccountRepository persists financial accounts (SRS-BIL-013).
type AccountRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope, a *domain.Account) error
	Get(ctx context.Context, scope authctx.TenantScope, accountID string) (
		*domain.Account, error)
	ForEncounter(ctx context.Context, scope authctx.TenantScope, encounterID string) (
		*domain.Account, error)
	UpdateCoverage(ctx context.Context, scope authctx.TenantScope, a *domain.Account,
		expectedVersion int64) error
	Close(ctx context.Context, scope authctx.TenantScope, a *domain.Account,
		expectedVersion int64) error
}

// ChargeRepository persists charges and package consumption (SRS-BIL-003,
// SRS-BIL-004).
type ChargeRepository interface {
	// Insert stores a charge, returning ErrAlreadyRecorded where the source
	// reference has already produced one. Enforced by a unique index rather than
	// a check, because two deliveries of one event can be in flight at the same
	// moment.
	Insert(ctx context.Context, scope authctx.TenantScope, c *domain.Charge) error
	Get(ctx context.Context, scope authctx.TenantScope, chargeID string) (
		*domain.Charge, error)
	BySource(ctx context.Context, scope authctx.TenantScope,
		source domain.SourceReference) (*domain.Charge, error)
	ForAccount(ctx context.Context, scope authctx.TenantScope, accountID string,
		billableOnly bool, limit int32) ([]*domain.Charge, error)
	ByStatus(ctx context.Context, scope authctx.TenantScope, accountID string,
		status domain.ChargeStatus) ([]*domain.Charge, error)
	// Unbilled is the revenue-integrity worklist (SRS-BIL-011).
	Unbilled(ctx context.Context, scope authctx.TenantScope, facilityID string,
		limit int32) ([]*domain.Charge, error)
	UpdateStatus(ctx context.Context, scope authctx.TenantScope, c *domain.Charge,
		expectedVersion int64, expectedStatus domain.ChargeStatus) error
	UpdateCoverage(ctx context.Context, scope authctx.TenantScope, c *domain.Charge,
		expectedVersion int64) error

	RecordConsumption(ctx context.Context, scope authctx.TenantScope,
		entry domain.Consumption) error
	Consumption(ctx context.Context, scope authctx.TenantScope, accountID string) (
		[]domain.Consumption, error)
}

// InvoiceRepository persists financial documents (SRS-BIL-005, SRS-BIL-006,
// SRS-BIL-010).
//
// Note what is missing: nothing edits an issued document's lines or totals.
// That absence is the mechanism behind SRS-BIL-010 rather than a convention
// somebody has to remember.
type InvoiceRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope, i *domain.Invoice) error
	Get(ctx context.Context, scope authctx.TenantScope, invoiceID string) (
		*domain.Invoice, error)
	ForAccount(ctx context.Context, scope authctx.TenantScope, accountID string,
		limit int32) ([]*domain.Invoice, error)
	Drafts(ctx context.Context, scope authctx.TenantScope, accountID string) (
		[]*domain.Invoice, error)
	Issue(ctx context.Context, scope authctx.TenantScope, i *domain.Invoice,
		expectedVersion int64) error
	Supersede(ctx context.Context, scope authctx.TenantScope, i *domain.Invoice,
		expectedVersion int64) error
}

// LedgerRepository persists account movements (SRS-BIL-008, SRS-BIL-009,
// SRS-BIL-012).
//
// Append and read, and nothing else. A correction is another entry.
type LedgerRepository interface {
	// Append stores an entry, returning ErrAlreadyRecorded where the
	// idempotency key has already been used on this account.
	Append(ctx context.Context, scope authctx.TenantScope, e domain.LedgerEntry) error
	Entries(ctx context.Context, scope authctx.TenantScope, accountID string) (
		[]domain.LedgerEntry, error)
	ByIdempotencyKey(ctx context.Context, scope authctx.TenantScope,
		accountID, key string) (domain.LedgerEntry, error)
	ForShift(ctx context.Context, scope authctx.TenantScope, shiftID string) (
		[]domain.LedgerEntry, error)
}

// ShiftRepository persists cashier sessions (SRS-BIL-015).
type ShiftRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope, s *domain.Shift) error
	Get(ctx context.Context, scope authctx.TenantScope, shiftID string) (
		*domain.Shift, error)
	Open(ctx context.Context, scope authctx.TenantScope, facilityID, counterID string) (
		*domain.Shift, error)
	Close(ctx context.Context, scope authctx.TenantScope, s *domain.Shift,
		expectedVersion int64) error
	Approve(ctx context.Context, scope authctx.TenantScope, s *domain.Shift,
		expectedVersion int64) error
	List(ctx context.Context, scope authctx.TenantScope, facilityID string,
		limit int32) ([]*domain.Shift, error)
}

// PolicyRepository persists the tenant's billing configuration.
type PolicyRepository interface {
	SetPolicy(ctx context.Context, scope authctx.TenantScope, p Policy,
		updatedBy string, now time.Time) error
	// Policy returns the tenant's configuration merged over the domain default,
	// so a tenant that has configured nothing gets the safe starting point
	// rather than no rules at all.
	Policy(ctx context.Context, scope authctx.TenantScope) (Policy, error)
}

// Policy is everything a tenant has decided about billing.
type Policy struct {
	// DiscountLimits are what each role may give without approval
	// (SRS-BIL-007), keyed by role name.
	DiscountLimits map[string]domain.DiscountLimit
	Close          domain.ClosePolicy
	Variance       domain.VarianceThreshold
	// Currency is what this tenant bills in. One per tenant, because a hospital
	// with two is a hospital whose totals do not add up without a rate nobody
	// recorded.
	Currency string
}

// DefaultPolicy is what a tenant that has configured nothing gets.
//
// No discount limits at all, which means no discount can be given without an
// approval: the safe direction for a control about giving money away, and the
// opposite of the safe direction for, say, pharmacist verification.
func DefaultPolicy() Policy {
	return Policy{
		DiscountLimits: map[string]domain.DiscountLimit{},
		Close:          domain.DefaultClosePolicy(),
		Variance:       domain.DefaultVarianceThreshold(),
		Currency:       "INR",
	}
}

// Numbers issues invoice and receipt numbers (SRS-PLT-014).
//
// The platform's sequence rather than one of this context's own: atomic,
// collision-free and gapless are exactly what a finance department's first
// question about a numbering scheme asks for, and SRS-BIL-008 requires the
// receipt number to be atomic by name.
type Numbers interface {
	Issue(ctx context.Context, scope authctx.TenantScope, sequenceScope string,
		now time.Time) (string, error)
}

// Encounters is the seam onto the encounter context (SRS-BIL-003).
type Encounters interface {
	Check(ctx context.Context, scope authctx.TenantScope, encounterID string) (
		EncounterState, error)
}

// EncounterState is what the billing context needs about a visit.
type EncounterState struct {
	PatientID  string
	FacilityID string
	Open       bool
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
