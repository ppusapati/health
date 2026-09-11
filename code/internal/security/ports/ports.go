// Package ports declares the interfaces the security application layer needs.
package ports

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/security/domain"
)

// SecurityEventStore persists the tamper-evident chain.
type SecurityEventStore interface {
	// Append links an event to the tenant's chain. The sequence and previous
	// hash are resolved inside the same transaction as the insert, so two
	// concurrent appends cannot both claim the same position.
	Append(ctx context.Context, scope authctx.TenantScope, e domain.SecurityEvent) (domain.SecurityEvent, error)
	// List returns the whole chain in order, for verification.
	List(ctx context.Context, scope authctx.TenantScope) ([]domain.SecurityEvent, error)
}

// ExportStore persists bulk-export requests and their downloads.
type ExportStore interface {
	Insert(ctx context.Context, scope authctx.TenantScope, e domain.ExportRequest) error
	Get(ctx context.Context, scope authctx.TenantScope, exportID string) (domain.ExportRequest, error)
	Approve(ctx context.Context, scope authctx.TenantScope, exportID, approvedBy string, at time.Time) error
	Reject(ctx context.Context, scope authctx.TenantScope, exportID, approvedBy string, at time.Time) error
	Complete(ctx context.Context, scope authctx.TenantScope, e domain.ExportRequest) error
	RecordDownload(ctx context.Context, scope authctx.TenantScope, downloadID, exportID, by, correlationID string, at time.Time) error
}

// LegalHoldStore persists holds and answers whether a resource is held.
type LegalHoldStore interface {
	Place(ctx context.Context, scope authctx.TenantScope, h domain.LegalHold) (bool, error)
	Release(ctx context.Context, scope authctx.TenantScope, resourceType, resourceID, releasedBy string, at time.Time) (bool, error)
	IsHeld(ctx context.Context, scope authctx.TenantScope, resourceType, resourceID string) (bool, error)
	HeldResourceIDs(ctx context.Context, scope authctx.TenantScope, resourceType string) ([]string, error)
}

// RetentionStore persists retention classes.
type RetentionStore interface {
	Insert(ctx context.Context, scope authctx.TenantScope, c domain.RetentionClass) error
	Get(ctx context.Context, scope authctx.TenantScope, name string) (domain.RetentionClass, error)
}

// PrivacyStore persists notices, purposes and the subject's grants.
type PrivacyStore interface {
	InsertPurpose(ctx context.Context, scope authctx.TenantScope, p domain.ProcessingPurpose) error
	GetPurpose(ctx context.Context, scope authctx.TenantScope, code string) (domain.ProcessingPurpose, error)
	RecordGrant(ctx context.Context, scope authctx.TenantScope, g domain.PurposeGrant) error
	CurrentGrant(ctx context.Context, scope authctx.TenantScope, subjectRef, purposeCode string) (domain.PurposeGrant, error)
}

// SubjectRequestStore persists data-subject requests.
type SubjectRequestStore interface {
	Insert(ctx context.Context, scope authctx.TenantScope, r domain.SubjectRequest) error
	Get(ctx context.Context, scope authctx.TenantScope, requestID string) (domain.SubjectRequest, error)
	Decide(ctx context.Context, scope authctx.TenantScope, r domain.SubjectRequest) error
}

// StepUpVerifier confirms that a caller completed a second authentication
// factor for a high-risk action (SRS-IAM-012).
type StepUpVerifier interface {
	// Verify returns the reference to record against the action, or an error.
	// The reference is what makes the step-up auditable after the fact.
	Verify(ctx context.Context, subjectID, proof string) (reference string, err error)
}

// UnitOfWork runs a function inside one database transaction.
type UnitOfWork interface {
	WithinTx(ctx context.Context, fn func(context.Context) error) error
}

// IDGenerator mints opaque identifiers.
type IDGenerator interface{ NewID() string }

// Clock supplies the current time.
type Clock interface{ Now() time.Time }
