// Package ports declares what the biomedical use cases need from the outside.
//
// Interfaces owned by this context rather than by whoever implements them, so
// the dependency arrow points inward (FIT-01).
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/biomedical/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
)

// ErrVersionConflict is a lost update: somebody else changed the record
// between the read and the write.
var ErrVersionConflict = errors.New("biomedical: version conflict")

// AssetRepository persists the equipment register.
//
// Every method takes authctx.TenantScope, which has no constructor outside the
// auth package, so reaching a row without a verified tenant does not compile
// (FIT-03).
type AssetRepository interface {
	InsertAsset(ctx context.Context, scope authctx.TenantScope,
		a domain.Asset) error
	Asset(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Asset, error)
	// AssetByTag resolves the number on the sticker, which is what a service
	// request names. False rather than an error for an unknown one.
	AssetByTag(ctx context.Context, scope authctx.TenantScope, tag string) (
		domain.Asset, bool, error)
	UpdateAsset(ctx context.Context, scope authctx.TenantScope,
		a domain.Asset, expectedVersion int64) error
	Assets(ctx context.Context, scope authctx.TenantScope,
		category, status string, excludeRetired bool, limit int32) (
		[]domain.Asset, error)
	// AtLocation is what SRS-BIO-009's capability read runs over: the assets
	// standing in one room.
	AtLocation(ctx context.Context, scope authctx.TenantScope,
		locationID string, limit int32) ([]domain.Asset, error)
	// ByMake narrows a safety notice's candidates before the domain matches
	// them, so a recall does not pull the whole register into memory.
	ByMake(ctx context.Context, scope authctx.TenantScope, make, udi string,
		limit int32) ([]domain.Asset, error)
}

// ContractRepository persists warranties, AMCs and CMCs.
type ContractRepository interface {
	InsertContract(ctx context.Context, scope authctx.TenantScope,
		c domain.ServiceContract) error
	Contract(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.ServiceContract, error)
	ContractsForAsset(ctx context.Context, scope authctx.TenantScope,
		assetID string) ([]domain.ServiceContract, error)
	// ExpiringBefore is the renewal sweep (SRS-BIO-002).
	ExpiringBefore(ctx context.Context, scope authctx.TenantScope,
		horizon time.Time, limit int32) ([]domain.ServiceContract, error)
}

// PlanRepository persists preventive maintenance schedules.
type PlanRepository interface {
	InsertPlan(ctx context.Context, scope authctx.TenantScope,
		p domain.PMPlan) error
	Plan(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.PMPlan, error)
	UpdatePlan(ctx context.Context, scope authctx.TenantScope, p domain.PMPlan,
		expectedVersion int64) error
	Plans(ctx context.Context, scope authctx.TenantScope, assetID string,
		activeOnly bool, limit int32) ([]domain.PMPlan, error)
}

// TicketRepository persists breakdown and service requests.
type TicketRepository interface {
	InsertTicket(ctx context.Context, scope authctx.TenantScope,
		t domain.Ticket) error
	Ticket(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Ticket, error)
	UpdateTicket(ctx context.Context, scope authctx.TenantScope,
		t domain.Ticket, expectedVersion int64) error
	Tickets(ctx context.Context, scope authctx.TenantScope,
		assetID, state string, openOnly bool, limit int32) (
		[]domain.Ticket, error)
	// ForAssetBetween is what the reliability figures are computed over.
	ForAssetBetween(ctx context.Context, scope authctx.TenantScope,
		assetID string, from, to time.Time, limit int32) (
		[]domain.Ticket, error)
	// ClosedPlannedWork is what PM compliance is counted from.
	ClosedPlannedWork(ctx context.Context, scope authctx.TenantScope,
		assetID string, from, to time.Time) ([]domain.Ticket, error)
}

// NoticeRepository persists safety notices and their per-asset tasks.
type NoticeRepository interface {
	InsertNotice(ctx context.Context, scope authctx.TenantScope,
		n domain.SafetyNotice) error
	Notice(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.SafetyNotice, error)
	CloseNotice(ctx context.Context, scope authctx.TenantScope,
		n domain.SafetyNotice, expectedVersion int64) error
	Notices(ctx context.Context, scope authctx.TenantScope, openOnly bool,
		limit int32) ([]domain.SafetyNotice, error)

	InsertTasks(ctx context.Context, scope authctx.TenantScope,
		tasks []domain.NoticeTask) error
	Task(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.NoticeTask, error)
	UpdateTask(ctx context.Context, scope authctx.TenantScope,
		t domain.NoticeTask) error
	Tasks(ctx context.Context, scope authctx.TenantScope, noticeID string) (
		[]domain.NoticeTask, error)
	// TasksForAsset answers "is this machine held under anything", which a
	// capability read and a ticket both ask.
	TasksForAsset(ctx context.Context, scope authctx.TenantScope,
		assetID string) ([]domain.NoticeTask, error)
}

// TelemetryRepository persists device readings (SRS-BIO-010).
//
// Append and read. There is deliberately no update and no delete here, and no
// method on this interface reaches a maintenance record: a reading can inform
// a plan and can never alter what an engineer wrote.
type TelemetryRepository interface {
	AppendReading(ctx context.Context, scope authctx.TenantScope,
		r domain.Reading) error
	AppendReadings(ctx context.Context, scope authctx.TenantScope,
		readings []domain.Reading) error
	Readings(ctx context.Context, scope authctx.TenantScope,
		assetID, metric string, from, to time.Time, limit int32) (
		[]domain.Reading, error)
	// LatestByMetric is the newest reading per asset, by observation.
	LatestByMetric(ctx context.Context, scope authctx.TenantScope,
		metric string) ([]domain.Reading, error)
}

// DisposalRepository persists assets leaving the hospital (SRS-BIO-011).
type DisposalRepository interface {
	InsertDisposal(ctx context.Context, scope authctx.TenantScope,
		d domain.Disposal) error
	Disposal(ctx context.Context, scope authctx.TenantScope, assetID string) (
		domain.Disposal, error)
	Disposals(ctx context.Context, scope authctx.TenantScope,
		from, to time.Time, limit int32) ([]domain.Disposal, error)
}

// Notice is something somebody has to be told about now.
type Notice struct {
	Kind       string
	Subject    string
	FacilityID string
	Summary    string
}

// Escalator raises a durable, acknowledged notice.
//
// Used for the two things here that cannot wait for somebody to open a screen:
// a recall, which has to reach the wards holding the equipment, and a
// life-support asset going down.
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

// UnitOfWork runs a use case in one transaction.
type UnitOfWork interface {
	WithinTx(ctx context.Context, fn func(context.Context) error) error
}

// IDGenerator mints identifiers.
type IDGenerator interface{ NewID() string }

// Clock reads the time.
type Clock interface{ Now() time.Time }
