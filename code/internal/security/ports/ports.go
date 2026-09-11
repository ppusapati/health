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
//
// Methods are named for their aggregate rather than as bare Insert/Get: one
// Repository type implements several of these ports, and two ports both
// declaring Get would force an artificial split of the adapter.
type RetentionStore interface {
	InsertClass(ctx context.Context, scope authctx.TenantScope, c domain.RetentionClass) error
	GetClass(ctx context.Context, scope authctx.TenantScope, name string) (domain.RetentionClass, error)
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

// EmergencyGrantStore persists break-glass activations (SRS-SEC-014).
type EmergencyGrantStore interface {
	// InsertGrant returns domain.ErrGrantAlreadyActive when the subject
	// already has an open grant. The check belongs to the database's partial
	// unique index, not to a prior read, or two concurrent activations both
	// succeed and the TTL bound means nothing.
	InsertGrant(ctx context.Context, scope authctx.TenantScope, g domain.EmergencyGrant) error
	GetGrant(ctx context.Context, scope authctx.TenantScope, grantID string) (domain.EmergencyGrant, error)
	ActiveGrantFor(ctx context.Context, scope authctx.TenantScope, subjectID string) (domain.EmergencyGrant, bool, error)
	RecordAccess(ctx context.Context, scope authctx.TenantScope, grantID, resourceRef string, now time.Time) error
	CloseGrant(ctx context.Context, scope authctx.TenantScope, grantID string, at time.Time) error
	ReviewGrant(ctx context.Context, scope authctx.TenantScope, g domain.EmergencyGrant, now time.Time) error
	GrantsAwaitingReview(ctx context.Context, scope authctx.TenantScope, limit int32) ([]domain.EmergencyGrant, error)
}

// DowntimeStore persists outages and the paper actions owed to the record.
type DowntimeStore interface {
	InsertEpisode(ctx context.Context, scope authctx.TenantScope, e domain.DowntimeEpisode) error
	// GetEpisode returns the episode with its actions. The domain's questions
	// are all about the set, so returning one without the other invites a
	// caller to answer them with incomplete information.
	GetEpisode(ctx context.Context, scope authctx.TenantScope, episodeID string) (domain.DowntimeEpisode, error)
	RecordAction(ctx context.Context, scope authctx.TenantScope, episodeID string, a domain.DowntimeAction) error
	Restore(ctx context.Context, scope authctx.TenantScope, episodeID string, at time.Time) error
	ReconcileAction(ctx context.Context, scope authctx.TenantScope, episodeID, actionID, reconciledBy, resourceRef string, at time.Time) error
	CloseEpisode(ctx context.Context, scope authctx.TenantScope, episodeID, closedBy string, at time.Time) error
	UnreconciledCount(ctx context.Context, scope authctx.TenantScope, episodeID string) (int64, error)
}

// GrantSweeper expires activations whose window has closed.
//
// Separate from EmergencyGrantStore, and deliberately takes no tenant scope: it
// runs for the whole deployment, and a per-tenant sweep would leave a quiet
// tenant's grants open indefinitely. Keeping it off the scoped port is what
// stops a request handler reaching an untenanted write.
type GrantSweeper interface {
	ExpireGrants(ctx context.Context, now time.Time) (int64, error)
}
