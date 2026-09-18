// Package application holds the materials, procurement and inventory use
// cases (SRS-MAT-001 … 016).
package application

import (
	"context"
	"encoding/json"
	"errors"
	"strconv"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/materials/domain"
	"github.com/ppusapati/health/code/internal/materials/ports"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Permissions.
//
// Split along the jobs, with four standing alone because they are the steps a
// hospital's finance and safety controls actually turn on: approving a
// requisition, accepting stock out of quarantine, approving a count's
// adjustment, and blocking a lot. Each makes something possible that was not,
// and each is the one a fraud or a recall is traced back to.
const (
	// PermRead reads the masters, the shelf, the orders and the counts.
	PermRead = "mat.record.read"
	// PermConfigure maintains the item, supplier and stock-level masters and
	// the approval rules (SRS-MAT-001, SRS-MAT-002, SRS-MAT-012).
	PermConfigure = "mat.master.configure"
	// PermRaise raises a requisition (SRS-MAT-001).
	PermRaise = "mat.requisition.raise"
	// PermApprove decides a requisition (SRS-MAT-002). Its own permission,
	// and the route decides which role is required at which step — holding
	// this is necessary and not sufficient.
	PermApprove = "mat.requisition.approve"
	// PermPurchase runs quotations and places orders (SRS-MAT-003,
	// SRS-MAT-004).
	PermPurchase = "mat.purchase.write"
	// PermReceive records a delivery (SRS-MAT-005).
	PermReceive = "mat.receipt.write"
	// PermInspect accepts or rejects quarantined stock (SRS-MAT-006). Its own
	// permission, because it is the step that makes uninspected stock usable.
	PermInspect = "mat.inspection.decide"
	// PermIssue issues, returns and consumes stock (SRS-MAT-008).
	PermIssue = "mat.stock.issue"
	// PermTransfer moves stock between stores (SRS-MAT-010).
	PermTransfer = "mat.transfer.write"
	// PermCount records a stocktake (SRS-MAT-011).
	PermCount = "mat.count.record"
	// PermApproveCount authorises the adjustment a count would post
	// (SRS-MAT-011). Its own permission, because a storekeeper who could
	// count their own store and sign off the difference can make any
	// shortfall disappear.
	PermApproveCount = "mat.count.approve"
	// PermBlock blocks a lot and runs its recall (SRS-MAT-013). Its own
	// permission, because blocking tells every ward to stop using what they
	// have, and the recall list names the patients it reached.
	PermBlock = "mat.lot.block"
	// PermMatch runs the three-way match (SRS-MAT-014).
	PermMatch = "mat.invoice.match"
	// PermAnalyse reads the inventory KPIs (SRS-MAT-015).
	PermAnalyse = "mat.analysis.read"
)

// Events.
//
// Identifiers, codes and quantities. No patient identifiers beyond the ones a
// recall must carry, and no prices: an event stream is read by more systems
// and under fewer controls than the record it describes (SRS-API-009).
const (
	EventRequisitionRaised   = "materials_requisition.raised"
	EventRequisitionApproved = "materials_requisition.approved"
	EventRequisitionRejected = "materials_requisition.rejected"
	EventOrderIssued         = "materials_order.issued"
	EventOrderAmended        = "materials_order.amended"
	EventGoodsReceived       = "materials_goods.received"
	EventStockAccepted       = "materials_stock.accepted"
	EventStockRejected       = "materials_stock.rejected"
	EventStockIssued         = "materials_stock.issued"
	EventTransferDispatched  = "materials_transfer.dispatched"
	EventTransferReceived    = "materials_transfer.received"
	EventCountApproved       = "materials_count.approved"
	EventLotBlocked          = "materials_lot.blocked"
	EventLotReleased         = "materials_lot.released"
	// EventConsignmentConsumed is separate from a plain issue so a finance
	// system can subscribe to what the hospital now owes without filtering
	// every glove that left a store.
	EventConsignmentConsumed = "materials_consignment.consumed"
	EventMatchFailed         = "materials_invoice.mismatched"
)

// EscalationKind is the notice a blocked lot raises.
//
// Durable and acknowledged rather than a log line: a recall has to reach the
// wards holding the stock, and one that only appeared on a screen nobody
// opened is a recall that did not happen.
const EscalationKind = "materials_recall"

// Config is what a deployment has decided about its stores.
type Config struct {
	// ExpiryHorizon is how far ahead an expiry alert looks (SRS-MAT-012).
	// Zero raises no expiry alerts at all, which is a deployment that has not
	// decided — visible in the status document rather than guessed at here.
	ExpiryHorizon time.Duration
	// DefaultToleranceOverPercent and DefaultToleranceShortPercent apply to an
	// order that sets none (SRS-MAT-005). Both default to zero, which means
	// an exact delivery: a hospital that wants slack says so, and the
	// direction that refuses is the one that keeps unordered stock off the
	// ledger.
	DefaultToleranceOverPercent  int
	DefaultToleranceShortPercent int
	// RequirePatientForConsignment holds a consignment consumption until it
	// names the patient it went into. Most hospitals want this for implants,
	// because the supplier invoices against the case; a store issuing
	// consignment consumables in bulk does not.
	RequirePatientForConsignment bool
}

// Service is the materials use-case façade.
type Service struct {
	uow         ports.UnitOfWork
	master      ports.MasterRepository
	ledger      ports.LedgerRepository
	procurement ports.ProcurementRepository
	control     ports.ControlRepository
	charges     ports.Charges
	patients    ports.Patients
	events      ports.EventAppender
	audits      ports.AuditAppender
	escalations ports.Escalator
	ids         ports.IDGenerator
	clock       ports.Clock
	config      Config
}

// Deps are the collaborators the service needs.
type Deps struct {
	UnitOfWork  ports.UnitOfWork
	Master      ports.MasterRepository
	Ledger      ports.LedgerRepository
	Procurement ports.ProcurementRepository
	Control     ports.ControlRepository
	// Charges raises the patient-facing charge a consumption produces. Nil
	// records the movement and raises nothing, which is a deployment that
	// tracks stock and bills on paper — visible in the status document rather
	// than hidden here.
	Charges ports.Charges
	// Patients reports whether a patient is real. Nil skips the check.
	Patients ports.Patients
	Events   ports.EventAppender
	Audits   ports.AuditAppender
	// Escalations raises the notice a blocked lot produces. Nil leaves the
	// block recorded and unescalated.
	Escalations ports.Escalator
	IDs         ports.IDGenerator
	Clock       ports.Clock
	Config      Config
}

// NewService wires the use cases to their ports.
func NewService(d Deps) *Service {
	return &Service{
		uow: d.UnitOfWork, master: d.Master, ledger: d.Ledger,
		procurement: d.Procurement, control: d.Control,
		charges: d.Charges, patients: d.Patients,
		events: d.Events, audits: d.Audits, escalations: d.Escalations,
		ids: d.IDs, clock: d.Clock, config: d.Config,
	}
}

// Limits on what one request may ask for.
const (
	DefaultPageSize = 200
	MaxPageSize     = 1000
	// ledgerPageSize bounds a replay. A KPI over an item with a million
	// movements is a report somebody should narrow, not a query that pulls
	// the whole ledger into memory.
	ledgerPageSize = 5000
)

func clampPageSize(requested int32) int32 {
	switch {
	case requested <= 0:
		return DefaultPageSize
	case requested > MaxPageSize:
		return MaxPageSize
	default:
		return requested
	}
}

func (s *Service) authorize(ctx context.Context, permission string) (
	authctx.Session, authctx.TenantScope, error) {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return authctx.Session{}, authctx.TenantScope{}, rpcerr.Unauthenticated(
			"MAT_NO_SESSION", "this call needs an authenticated caller")
	}
	if !session.HasPermission(permission) {
		return authctx.Session{}, authctx.TenantScope{}, rpcerr.PermissionDenied(
			"MAT_FORBIDDEN", "this caller may not "+permission)
	}
	return session, session.TenantScope(), nil
}

// materialsError maps a domain refusal to the transport contract.
func materialsError(err error) error {
	if errors.Is(err, domain.ErrInvalidMaterials) {
		return rpcerr.Invalid("MAT_INVALID", err.Error())
	}
	if errors.Is(err, ports.ErrVersionConflict) {
		return rpcerr.FailedPrecondition("MAT_VERSION_CONFLICT",
			"somebody else changed this record; re-read it and try again")
	}
	return err
}

func (s *Service) appendAudit(ctx context.Context, session authctx.Session,
	r audit.Record, now time.Time) error {

	if s.audits == nil {
		return nil
	}
	r.AuditID = s.ids.NewID()
	r.ActorID = session.SubjectID
	r.CorrelationID = session.CorrelationID
	r.RequestID = session.RequestID
	r.PurposeOfUse = string(session.Purpose)
	r.BreakGlass = session.BreakGlass
	r.OccurredAt = now.UTC()
	if r.TenantID == "" {
		r.TenantID = session.TenantID
	}
	return s.audits.Append(ctx, r)
}

const (
	eventSchemaVersion = 1
	eventSource        = "materials"
)

func (s *Service) appendEvent(ctx context.Context, session authctx.Session,
	eventType, aggregateType, aggregateID string, payload map[string]any,
	now time.Time) error {

	if s.events == nil {
		return nil
	}
	encoded, err := json.Marshal(payload)
	if err != nil {
		return rpcerr.Internal("MAT_EVENT_ENCODE_FAILED",
			"could not encode event").WithCause(err)
	}
	return s.events.Append(ctx, outbox.Event{
		EventID:       s.ids.NewID(),
		EventType:     eventType,
		SchemaVersion: eventSchemaVersion,
		OccurredAt:    now.UTC(),
		TenantID:      session.TenantID,
		Source:        eventSource,
		AggregateType: aggregateType,
		AggregateID:   aggregateID,
		CorrelationID: session.CorrelationID,
		CausationID:   session.RequestID,
		Actor:         session.SubjectID,
		Payload:       encoded,
	})
}

// knownPatient refuses a consumption charged to somebody nobody can resolve.
func (s *Service) knownPatient(ctx context.Context, scope authctx.TenantScope,
	patientID string) error {

	if s.patients == nil || patientID == "" {
		return nil
	}
	exists, err := s.patients.Exists(ctx, scope, patientID)
	if err != nil {
		return err
	}
	if !exists {
		return rpcerr.NotFound("MAT_NOT_FOUND", "no such patient")
	}
	return nil
}

// lotsByID indexes lots for the domain's availability and pick arithmetic.
func lotsByID(lots []domain.Lot) map[string]domain.Lot {
	out := make(map[string]domain.Lot, len(lots))
	for _, lot := range lots {
		out[lot.ID] = lot
	}
	return out
}

func itoa(n int) string { return strconv.Itoa(n) }

func join(values []string) string { return strings.Join(values, ", ") }
