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
