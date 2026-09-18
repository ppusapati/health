// Package ports declares what the materials use cases need from the outside.
//
// Interfaces owned by this context rather than by whoever implements them, so
// the dependency arrow points inward (FIT-01). The persistence adapter, the
// charge seam into SRS-BIL and the notice mechanism all satisfy contracts
// written here.
package ports

import (
	"context"
	"errors"
	"time"

	"github.com/ppusapati/health/code/internal/materials/domain"
	"github.com/ppusapati/health/code/internal/platform/audit"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
)

// ErrVersionConflict is a lost update: somebody else changed the record
// between the read and the write.
var ErrVersionConflict = errors.New("materials: version conflict")

// MasterRepository persists the item, supplier and lot masters.
//
// Every method takes authctx.TenantScope, which has no constructor outside the
// auth package, so reaching a row without a verified tenant does not compile
// (FIT-03).
type MasterRepository interface {
	InsertItem(ctx context.Context, scope authctx.TenantScope,
		i domain.Item) error
	Item(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Item, error)
	// ItemByCode resolves the catalogue code a requisition or a receipt
	// names. False rather than an error for an unknown one, so the caller
	// says so in its own words.
	ItemByCode(ctx context.Context, scope authctx.TenantScope, code string) (
		domain.Item, bool, error)
	UpdateItem(ctx context.Context, scope authctx.TenantScope, i domain.Item,
		expectedVersion int64) error
	Items(ctx context.Context, scope authctx.TenantScope, category string,
		activeOnly bool, limit int32) ([]domain.Item, error)

	InsertSupplier(ctx context.Context, scope authctx.TenantScope,
		s domain.Supplier) error
	Supplier(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Supplier, error)
	UpdateSupplier(ctx context.Context, scope authctx.TenantScope,
		s domain.Supplier, expectedVersion int64) error
	Suppliers(ctx context.Context, scope authctx.TenantScope, approvedOnly bool,
		limit int32) ([]domain.Supplier, error)

	InsertLot(ctx context.Context, scope authctx.TenantScope,
		l domain.Lot) error
	Lot(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Lot, error)
	// LotByCode finds an existing batch, so a second delivery of the same lot
	// joins it rather than creating a duplicate a recall would then miss.
	LotByCode(ctx context.Context, scope authctx.TenantScope,
		itemID, code string) (domain.Lot, bool, error)
	UpdateLotBlock(ctx context.Context, scope authctx.TenantScope,
		l domain.Lot, expectedVersion int64) error
	LotsForItem(ctx context.Context, scope authctx.TenantScope, itemID string,
		limit int32) ([]domain.Lot, error)
	// LotsAtLocation is what a pick recommendation reads alongside the
	// balances: the lots actually held there, with their expiry and block.
	LotsAtLocation(ctx context.Context, scope authctx.TenantScope,
		itemID, locationID string, limit int32) ([]domain.Lot, error)
	BlockedLots(ctx context.Context, scope authctx.TenantScope, limit int32) (
		[]domain.Lot, error)

	UpsertStockLevel(ctx context.Context, scope authctx.TenantScope,
		level domain.StockLevel, by string, at time.Time) error
	StockLevels(ctx context.Context, scope authctx.TenantScope,
		locationID string, limit int32) ([]domain.StockLevel, error)
}

// LedgerRepository persists the stock ledger (SRS-MAT-007).
//
// Append-only by construction: there is no update and no delete here, and
// there is no on-hand column to write. Balances are read from a view over the
// movements, which is what makes "on-hand is derivable from immutable
// movements" true rather than intended.
type LedgerRepository interface {
	AppendMovement(ctx context.Context, scope authctx.TenantScope,
		m domain.Movement) error
	// AppendMovements writes several in one call. A transfer, a receipt of
	// six lines and a count's adjustments are each one event, and splitting
	// them across calls would let half of one land.
	AppendMovements(ctx context.Context, scope authctx.TenantScope,
		movements []domain.Movement) error

	MovementsForItem(ctx context.Context, scope authctx.TenantScope,
		itemID string, from, to time.Time, limit int32) (
		[]domain.Movement, error)
	MovementsForLot(ctx context.Context, scope authctx.TenantScope,
		lotID string, limit int32) ([]domain.Movement, error)
	MovementsByReference(ctx context.Context, scope authctx.TenantScope,
		reference string, limit int32) ([]domain.Movement, error)

	BalancesAtLocation(ctx context.Context, scope authctx.TenantScope,
		locationID, itemID string, limit int32) ([]domain.Balance, error)
	BalancesForItem(ctx context.Context, scope authctx.TenantScope,
		itemID string, limit int32) ([]domain.Balance, error)
	BalancesForLot(ctx context.Context, scope authctx.TenantScope,
		lotID string) ([]domain.Balance, error)
	// Available is the same arithmetic in SQL, for the hot path: a pick
	// screen asking "can this store supply forty" should not pull every
	// movement across the wire.
	Available(ctx context.Context, scope authctx.TenantScope,
		itemID, locationID string, asOf time.Time) (int, error)
}

// ProcurementRepository persists requisitions, approvals, quotations and
// orders.
type ProcurementRepository interface {
	InsertRequisition(ctx context.Context, scope authctx.TenantScope,
		r domain.Requisition) error
	Requisition(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Requisition, error)
	UpdateRequisitionState(ctx context.Context, scope authctx.TenantScope,
		r domain.Requisition, expectedVersion int64) error
	Requisitions(ctx context.Context, scope authctx.TenantScope, state string,
		limit int32) ([]domain.Requisition, error)

	// AppendApproval writes one step of the chain (SRS-MAT-002). Append-only:
	// there is no update, because an approval that can be edited afterwards
	// is indistinguishable from one that was never given.
	AppendApproval(ctx context.Context, scope authctx.TenantScope,
		requisitionID string, step domain.ApprovalStep) error
	Approvals(ctx context.Context, scope authctx.TenantScope,
		requisitionID string) ([]domain.ApprovalStep, error)

	InsertApprovalRule(ctx context.Context, scope authctx.TenantScope,
		rule domain.ApprovalRule, by string, at time.Time) error
	ApprovalRules(ctx context.Context, scope authctx.TenantScope) (
		[]domain.ApprovalRule, error)
	DeleteApprovalRule(ctx context.Context, scope authctx.TenantScope,
		id string) error

	InsertRFQ(ctx context.Context, scope authctx.TenantScope,
		r domain.RFQ) error
	RFQ(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.RFQ, error)
	RFQs(ctx context.Context, scope authctx.TenantScope, limit int32) (
		[]domain.RFQ, error)

	InsertBid(ctx context.Context, scope authctx.TenantScope,
		b domain.Bid) error
	BidsForRFQ(ctx context.Context, scope authctx.TenantScope, rfqID string) (
		[]domain.Bid, error)

	InsertPurchaseOrder(ctx context.Context, scope authctx.TenantScope,
		o domain.PurchaseOrder) error
	PurchaseOrder(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.PurchaseOrder, error)
	UpdatePurchaseOrderState(ctx context.Context, scope authctx.TenantScope,
		o domain.PurchaseOrder, expectedVersion int64) error
	// Revisions is every version of one order (SRS-MAT-004).
	Revisions(ctx context.Context, scope authctx.TenantScope,
		chainID string) ([]domain.PurchaseOrder, error)
	PurchaseOrders(ctx context.Context, scope authctx.TenantScope,
		supplierID, state string, limit int32) ([]domain.PurchaseOrder, error)
	OrdersIssuedBetween(ctx context.Context, scope authctx.TenantScope,
		supplierID string, from, to time.Time) ([]domain.PurchaseOrder, error)

	InsertReceipt(ctx context.Context, scope authctx.TenantScope,
		r domain.Receipt) error
	Receipt(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Receipt, error)
	ReceiptsForOrder(ctx context.Context, scope authctx.TenantScope,
		orderID string) ([]domain.Receipt, error)
	ReceiptsForSupplier(ctx context.Context, scope authctx.TenantScope,
		supplierID string, from, to time.Time, limit int32) (
		[]domain.Receipt, error)

	InsertInvoice(ctx context.Context, scope authctx.TenantScope,
		i domain.Invoice) error
	Invoice(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Invoice, error)
	InvoicesForOrder(ctx context.Context, scope authctx.TenantScope,
		orderID string) ([]domain.Invoice, error)
}

// ControlRepository persists transfers, counts and liabilities.
type ControlRepository interface {
	InsertTransfer(ctx context.Context, scope authctx.TenantScope,
		t domain.Transfer) error
	Transfer(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Transfer, error)
	UpdateTransfer(ctx context.Context, scope authctx.TenantScope,
		t domain.Transfer, expectedVersion int64) error
	TransfersInTransit(ctx context.Context, scope authctx.TenantScope,
		toLocation string, limit int32) ([]domain.Transfer, error)

	InsertCount(ctx context.Context, scope authctx.TenantScope,
		c domain.Count) error
	Count(ctx context.Context, scope authctx.TenantScope, id string) (
		domain.Count, error)
	UpdateCount(ctx context.Context, scope authctx.TenantScope, c domain.Count,
		expectedVersion int64) error
	Counts(ctx context.Context, scope authctx.TenantScope, state string,
		limit int32) ([]domain.Count, error)

	// AppendLiability records what consuming a supplier's stock owes them
	// (SRS-MAT-016). Append-only: a liability that can be edited is one that
	// can be edited away.
	AppendLiability(ctx context.Context, scope authctx.TenantScope,
		e domain.LiabilityEvent) error
	Liabilities(ctx context.Context, scope authctx.TenantScope,
		supplierID string, from, to time.Time, limit int32) (
		[]domain.LiabilityEvent, error)
}

// Charges raises the patient-facing charge a consumption produces
// (SRS-MAT-008, SRS-MAT-016).
//
// A port, because what a patient is charged belongs to SRS-BIL and a hospital
// has one place that decides it. Materials says what was used and on whom;
// billing decides what that costs.
type Charges interface {
	// Raise records a chargeable consumption. Returns the charge's identifier
	// so the movement can name it, which is the traceability half of
	// SRS-MAT-008's "movement and charge linkage are traceable".
	Raise(ctx context.Context, scope authctx.TenantScope, c Charge,
		at time.Time) (string, error)
}

// Charge is what materials tells billing.
type Charge struct {
	PatientID   string
	EncounterID string
	ItemID      string
	ItemCode    string
	Quantity    int
	CostCentre  string
	// MovementID is what the charge is traceable back to.
	MovementID string
}

// Patients reports whether a patient is real, so a consumption cannot be
// charged to somebody nobody can resolve.
type Patients interface {
	Exists(ctx context.Context, scope authctx.TenantScope, patientID string) (
		bool, error)
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
// Used for the one thing here that cannot wait for somebody to open a screen:
// a recall, which has to reach the wards holding the stock and the clinicians
// who used it.
//
// It does not take recipients. Who is paged is the tenant's configured
// escalation matrix, resolved at delivery.
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
