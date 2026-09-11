// Package ports declares the interfaces the organization application layer
// needs. They are defined here — by the consumer — rather than by the adapters
// that implement them, which is what keeps the dependency arrow pointing
// inward (Blueprint §4.1, SRS-API-007).
package ports

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/organization/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
)

// TenantRepository persists tenants. A tenant row is the tenancy anchor itself,
// so these methods take the tenant ID directly rather than a TenantScope.
type TenantRepository interface {
	Insert(ctx context.Context, t *domain.Tenant) error
	GetByID(ctx context.Context, tenantID string) (*domain.Tenant, error)
}

// FacilityFilter narrows a facility listing.
type FacilityFilter struct {
	// Status empty means "any status except retired".
	Status domain.FacilityStatus
	// PageSize is clamped by the repository to a supported maximum.
	PageSize int32
	// PageToken is an opaque cursor, never a page number (Domain/Data §6).
	PageToken string
}

// FacilityRepository persists facilities.
//
// Every method takes authctx.TenantScope, which cannot be constructed outside
// the auth package. That makes it impossible to reach tenant-owned rows without
// a verified tenant — FIT-03 enforced by the type system rather than by review.
type FacilityRepository interface {
	Insert(ctx context.Context, scope authctx.TenantScope, f *domain.Facility) error
	GetByID(ctx context.Context, scope authctx.TenantScope, facilityID string) (*domain.Facility, error)
	List(ctx context.Context, scope authctx.TenantScope, filter FacilityFilter) (items []*domain.Facility, nextPageToken string, err error)
	ExistsByCode(ctx context.Context, scope authctx.TenantScope, code string) (bool, error)
}

// EventAppender writes a domain event to the transactional outbox. It must run
// inside the caller's transaction (SRS-API-008).
type EventAppender interface {
	Append(ctx context.Context, e outbox.Event) error
}

// AuditAppender writes an audit record. Also transactional: an applied change
// without its audit entry is a compliance defect.
type AuditAppender interface {
	Append(ctx context.Context, r audit.Record) error
}

// UnitOfWork runs a function inside one database transaction.
type UnitOfWork interface {
	WithinTx(ctx context.Context, fn func(context.Context) error) error
}

// IDGenerator mints opaque identifiers. Injected so tests are deterministic and
// so the ID strategy stays a single decision (Domain/Data §3.1).
type IDGenerator interface {
	NewID() string
}

// Clock supplies the current time. Injected for the same reason.
type Clock interface {
	Now() time.Time
}

// OrgUnitRepository persists organisational units (SRS-PLT-005).
type OrgUnitRepository interface {
	InsertOrgUnit(ctx context.Context, scope authctx.TenantScope, u domain.OrgUnit) error
	GetOrgUnit(ctx context.Context, scope authctx.TenantScope, unitID string) (domain.OrgUnit, error)
	ListOrgUnits(ctx context.Context, scope authctx.TenantScope, unitType domain.UnitType,
		afterCode string, pageSize int32) ([]domain.OrgUnit, error)
}

// MasterDataChangeRepository persists proposed changes (SRS-PLT-008).
type MasterDataChangeRepository interface {
	// InsertChange returns FAILED_PRECONDITION when a change is already
	// pending for the entity. The check belongs to a partial unique index, not
	// to a prior read, so two concurrent proposals cannot both be accepted.
	InsertChange(ctx context.Context, scope authctx.TenantScope, c domain.MasterDataChange) error
	GetChange(ctx context.Context, scope authctx.TenantScope, changeID string) (domain.MasterDataChange, error)
	// DecideChange refuses a decision by the proposer in the statement itself,
	// so four eyes holds even against a caller that bypassed the domain.
	DecideChange(ctx context.Context, scope authctx.TenantScope, c domain.MasterDataChange) error
}

// EntitlementRepository persists module entitlements (SRS-PLT-011).
type EntitlementRepository interface {
	InsertEntitlement(ctx context.Context, scope authctx.TenantScope, e domain.Entitlement) error
	// EntitlementsForModule returns rows in both scopes — tenant-wide and the
	// caller's facility — so the domain applies specificity rather than the
	// query guessing at it.
	EntitlementsForModule(ctx context.Context, scope authctx.TenantScope,
		module, facilityID string) ([]domain.Entitlement, error)
}

// NumberIssuer allocates document numbers (SRS-PLT-014).
type NumberIssuer interface {
	EnsureSequence(ctx context.Context, scope authctx.TenantScope, s domain.NumberSequence) error
	// IssueNumber is atomic and collision-free under concurrency; the property
	// belongs to the statement, which takes a row lock, not to any caller-side
	// coordination.
	IssueNumber(ctx context.Context, scope authctx.TenantScope, numberScope domain.NumberScope,
		facilityID, periodKey string, now time.Time) (string, error)
}

// CalendarRepository persists facility calendars (SRS-PLT-016).
type CalendarRepository interface {
	InsertCalendarEntry(ctx context.Context, scope authctx.TenantScope, e domain.CalendarEntry) error
	CalendarEntriesOn(ctx context.Context, scope authctx.TenantScope,
		facilityID string, date time.Time) ([]domain.CalendarEntry, error)
}

// LabelRepository persists multilingual display labels (SRS-PLT-017).
type LabelRepository interface {
	PutLabel(ctx context.Context, scope authctx.TenantScope, l domain.DisplayLabel) error
	LabelsFor(ctx context.Context, scope authctx.TenantScope, codeSystem, code string) ([]domain.DisplayLabel, error)
}
