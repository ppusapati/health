package postgres

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/ppusapati/health/code/internal/orders/domain"
	"github.com/ppusapati/health/code/internal/orders/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// OrderRepo persists orders and their history (SRS-ORD-001, SRS-ORD-005).
type OrderRepo struct{ *Repository }

var _ ports.OrderRepository = OrderRepo{}

// NewOrders constructs the order adapter.
func NewOrders(r *Repository) OrderRepo { return OrderRepo{r} }

// Insert stores a new order.
func (r OrderRepo) Insert(ctx context.Context, scope authctx.TenantScope,
	o *domain.Order) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	params, err := insertParams(tenantID, o)
	if err != nil {
		return err
	}
	return r.queries(ctx).InsertOrder(ctx, params)
}

func insertParams(tenantID uuid.UUID, o *domain.Order) (
	sqlcgen.InsertOrderParams, error) {

	orderID, err := mustUUID(o.ID)
	if err != nil {
		return sqlcgen.InsertOrderParams{}, err
	}
	patientID, err := mustUUID(o.PatientID)
	if err != nil {
		return sqlcgen.InsertOrderParams{}, err
	}
	encounterID, err := mustUUID(o.EncounterID)
	if err != nil {
		return sqlcgen.InsertOrderParams{}, err
	}
	facilityID, err := mustUUID(o.FacilityID)
	if err != nil {
		return sqlcgen.InsertOrderParams{}, err
	}
	setID, err := optionalUUID(o.OrderSetID)
	if err != nil {
		return sqlcgen.InsertOrderParams{}, err
	}
	favouriteID, err := optionalUUID(o.FavouriteID)
	if err != nil {
		return sqlcgen.InsertOrderParams{}, err
	}

	params := sqlcgen.InsertOrderParams{
		OrderID: orderID, TenantID: tenantID, Number: o.Number,
		OrderType: string(o.Type), PatientID: patientID,
		EncounterID: encounterID, FacilityID: facilityID,
		RequesterID: o.RequesterID, EnteredByID: o.EnteredByID,
		// Derived at placement and stored, so a routing-table change does not
		// re-route orders already in flight (SRS-ORD-006).
		TargetService: o.TargetService,
		CodeSystem:    o.Code.System, CodeVersion: o.Code.Version,
		Code: o.Code.Code, CodeDisplay: o.Code.Display, Detail: o.Detail,
		Indication:               o.Indication,
		IndicationSystem:         o.IndicationCode.System,
		IndicationCode:           o.IndicationCode.Code,
		IndicationDisplay:        o.IndicationCode.Display,
		Priority:                 string(o.Priority),
		TimingStartAt:            timestamptz(o.Timing.StartAt),
		TimingEndAt:              timestamptz(o.Timing.EndAt),
		TimingFrequencySeconds:   int64(o.Timing.Frequency / time.Second),
		TimingCount:              o.Timing.Count,
		TimingTimesOfDay:         orEmptyInt32(o.Timing.TimesOfDay),
		TimingDaysOfWeek:         weekdaysToInts(o.Timing.DaysOfWeek),
		TimingPrn:                o.Timing.PRN,
		TimingDurationSeconds:    int64(o.Timing.Duration / time.Second),
		ConditionalInstruction:   o.ConditionalInstruction,
		Status:                   string(o.Status),
		OrderSetID:               setID,
		OrderSetVersion:          o.OrderSetVersion,
		FavouriteID:              favouriteID,
		CreatedAt:                timestamptz(o.CreatedAt),
		UpdatedAt:                timestamptz(o.UpdatedAt),
		Version:                  o.Version,
		CancellationRequestedAt:  timestamptz(o.CancellationRequestedAt),
		CancellationRequestedBy:  o.CancellationRequestedBy,
		CancellationReason:       o.CancellationReason,
		DuplicateOverrideAgainst: []uuid.UUID{},
	}
	if o.DuplicateOverride != nil {
		against := make([]uuid.UUID, 0, len(o.DuplicateOverride.AgainstOrderIDs))
		for _, id := range o.DuplicateOverride.AgainstOrderIDs {
			parsed, err := mustUUID(id)
			if err != nil {
				return sqlcgen.InsertOrderParams{}, err
			}
			against = append(against, parsed)
		}
		params.DuplicateOverrideReason = o.DuplicateOverride.Reason
		params.DuplicateOverrideBy = o.DuplicateOverride.By
		params.DuplicateOverrideAt = timestamptz(o.DuplicateOverride.At)
		params.DuplicateOverrideAgainst = against
	}
	return params, nil
}

// InsertStatusChange records one history entry without touching the order.
func (r OrderRepo) InsertStatusChange(ctx context.Context,
	scope authctx.TenantScope, orderID string, change domain.StatusChange) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	id, err := mustUUID(orderID)
	if err != nil {
		return err
	}
	changeID, err := mustUUID(change.ID)
	if err != nil {
		return err
	}

	return r.queries(ctx).InsertOrderStatusChange(ctx,
		sqlcgen.InsertOrderStatusChangeParams{
			ChangeID: changeID, TenantID: tenantID, OrderID: id,
			FromStatus: string(change.From), ToStatus: string(change.To),
			ChangedBy: change.By, Reason: change.Reason,
			OccurredAt: timestamptz(change.OccurredAt),
		})
}

func weekdaysToInts(in []time.Weekday) []int32 {
	out := make([]int32, 0, len(in))
	for _, d := range in {
		out = append(out, int32(d))
	}
	return out
}

func weekdaysFromInts(in []int32) []time.Weekday {
	if len(in) == 0 {
		return nil
	}
	out := make([]time.Weekday, 0, len(in))
	for _, d := range in {
		out = append(out, time.Weekday(d))
	}
	return out
}

// Get reads one order with its history.
func (r OrderRepo) Get(ctx context.Context, scope authctx.TenantScope,
	orderID string) (*domain.Order, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(orderID)
	if err != nil {
		return nil, err
	}

	row, err := r.queries(ctx).GetOrder(ctx, sqlcgen.GetOrderParams{
		TenantID: tenantID, OrderID: id,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, notFound()
	}
	if err != nil {
		return nil, err
	}
	order := orderFromRow(row)

	changes, err := r.queries(ctx).ListOrderStatusChanges(ctx,
		sqlcgen.ListOrderStatusChangesParams{TenantID: tenantID, OrderID: id})
	if err != nil {
		return nil, err
	}
	for _, c := range changes {
		order.History = append(order.History, domain.StatusChange{
			ID:   c.ChangeID.String(),
			From: domain.Status(c.FromStatus), To: domain.Status(c.ToStatus),
			By: c.ChangedBy, Reason: c.Reason,
			OccurredAt: timeOrZero(c.OccurredAt),
		})
	}
	return order, nil
}

// UpdateStatus records a transition and its history entry together.
//
// One transaction, so an order cannot reach a state with no record of how it
// got there — which is what SRS-ORD-010's audit is read from.
func (r OrderRepo) UpdateStatus(ctx context.Context, scope authctx.TenantScope,
	o *domain.Order, change domain.StatusChange, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	orderID, err := mustUUID(o.ID)
	if err != nil {
		return err
	}
	changeID, err := mustUUID(change.ID)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).UpdateOrderStatus(ctx,
		sqlcgen.UpdateOrderStatusParams{
			TenantID: tenantID, OrderID: orderID,
			Status: string(o.Status), UpdatedAt: timestamptz(o.UpdatedAt),
			ExpectedVersion: expectedVersion,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return conflict()
	}

	return r.queries(ctx).InsertOrderStatusChange(ctx,
		sqlcgen.InsertOrderStatusChangeParams{
			ChangeID: changeID, TenantID: tenantID, OrderID: orderID,
			FromStatus: string(change.From), ToStatus: string(change.To),
			ChangedBy: change.By, Reason: change.Reason,
			OccurredAt: timestamptz(change.OccurredAt),
		})
}

// UpdateDraft edits an unplaced order.
func (r OrderRepo) UpdateDraft(ctx context.Context, scope authctx.TenantScope,
	o *domain.Order, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	orderID, err := mustUUID(o.ID)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).UpdateOrderDraft(ctx,
		sqlcgen.UpdateOrderDraftParams{
			TenantID: tenantID, OrderID: orderID,
			CodeSystem: o.Code.System, CodeVersion: o.Code.Version,
			Code: o.Code.Code, CodeDisplay: o.Code.Display, Detail: o.Detail,
			Indication:             o.Indication,
			IndicationSystem:       o.IndicationCode.System,
			IndicationCode:         o.IndicationCode.Code,
			IndicationDisplay:      o.IndicationCode.Display,
			Priority:               string(o.Priority),
			TimingStartAt:          timestamptz(o.Timing.StartAt),
			TimingEndAt:            timestamptz(o.Timing.EndAt),
			TimingFrequencySeconds: int64(o.Timing.Frequency / time.Second),
			TimingCount:            o.Timing.Count,
			TimingTimesOfDay:       orEmptyInt32(o.Timing.TimesOfDay),
			TimingDaysOfWeek:       weekdaysToInts(o.Timing.DaysOfWeek),
			TimingPrn:              o.Timing.PRN,
			TimingDurationSeconds:  int64(o.Timing.Duration / time.Second),
			ConditionalInstruction: o.ConditionalInstruction,
			UpdatedAt:              timestamptz(o.UpdatedAt),
			ExpectedVersion:        expectedVersion,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return conflict()
	}
	return nil
}

// RequestCancellation records SRS-ORD-004's corrective workflow.
//
// The order's status is deliberately untouched: a request is not an outcome,
// and showing the order as cancelled while the laboratory is still running the
// test would tell the ward the wrong thing.
func (r OrderRepo) RequestCancellation(ctx context.Context,
	scope authctx.TenantScope, o *domain.Order, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	orderID, err := mustUUID(o.ID)
	if err != nil {
		return err
	}

	rows, err := r.queries(ctx).RequestOrderCancellation(ctx,
		sqlcgen.RequestOrderCancellationParams{
			TenantID: tenantID, OrderID: orderID,
			CancellationRequestedAt: timestamptz(o.CancellationRequestedAt),
			CancellationRequestedBy: o.CancellationRequestedBy,
			CancellationReason:      o.CancellationReason,
			UpdatedAt:               timestamptz(o.UpdatedAt),
			ExpectedVersion:         expectedVersion,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return conflict()
	}
	return nil
}

// RecordDuplicateOverride stores what the requester was shown and overrode.
func (r OrderRepo) RecordDuplicateOverride(ctx context.Context,
	scope authctx.TenantScope, o *domain.Order, expectedVersion int64) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	orderID, err := mustUUID(o.ID)
	if err != nil {
		return err
	}
	if o.DuplicateOverride == nil {
		return nil
	}

	against := make([]uuid.UUID, 0, len(o.DuplicateOverride.AgainstOrderIDs))
	for _, id := range o.DuplicateOverride.AgainstOrderIDs {
		parsed, err := mustUUID(id)
		if err != nil {
			return err
		}
		against = append(against, parsed)
	}

	rows, err := r.queries(ctx).RecordDuplicateOverride(ctx,
		sqlcgen.RecordDuplicateOverrideParams{
			TenantID: tenantID, OrderID: orderID,
			DuplicateOverrideReason: o.DuplicateOverride.Reason,
			DuplicateOverrideBy:     o.DuplicateOverride.By,
			DuplicateOverrideAt:     timestamptz(o.DuplicateOverride.At),
			// Captured at the time rather than recomputed: the existing orders
			// usually complete afterwards (SRS-ORD-009).
			DuplicateOverrideAgainst: orEmptyUUID(against),
			UpdatedAt:                timestamptz(o.UpdatedAt),
			ExpectedVersion:          expectedVersion,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return conflict()
	}
	return nil
}

// ForPatient reads a patient's orders.
func (r OrderRepo) ForPatient(ctx context.Context, scope authctx.TenantScope,
	q ports.OrderQuery) ([]*domain.Order, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	patientID, err := lookupUUID(q.PatientID)
	if err != nil {
		return nil, err
	}
	encounter, err := optionalUUID(q.EncounterID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListOrdersForPatient(ctx,
		sqlcgen.ListOrdersForPatientParams{
			TenantID: tenantID, PatientID: patientID,
			EncounterFilter: encounter, TypeFilter: string(q.Type),
			LiveOnly: q.LiveOnly, PageLimit: q.Limit,
		})
	if err != nil {
		return nil, err
	}
	return ordersFromRows(rows), nil
}

// LiveOfType is what the duplicate check reads (SRS-ORD-009).
func (r OrderRepo) LiveOfType(ctx context.Context, scope authctx.TenantScope,
	patientID string, orderType domain.Type, since time.Time, limit int32) (
	[]*domain.Order, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(patientID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListLiveOrdersOfType(ctx,
		sqlcgen.ListLiveOrdersOfTypeParams{
			TenantID: tenantID, PatientID: id,
			OrderType: string(orderType), Since: timestamptz(since),
			PageLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return ordersFromRows(rows), nil
}

// ForService reads a performing service's worklist.
func (r OrderRepo) ForService(ctx context.Context, scope authctx.TenantScope,
	service, facilityID string, limit int32) ([]*domain.Order, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListOrdersForService(ctx,
		sqlcgen.ListOrdersForServiceParams{
			TenantID: tenantID, TargetService: service,
			FacilityFilter: facilityID, PageLimit: limit,
		})
	if err != nil {
		return nil, err
	}
	return ordersFromRows(rows), nil
}

func ordersFromRows(rows []sqlcgen.OrdersClinicalOrder) []*domain.Order {
	out := make([]*domain.Order, 0, len(rows))
	for _, row := range rows {
		out = append(out, orderFromRow(row))
	}
	return out
}

func orderFromRow(row sqlcgen.OrdersClinicalOrder) *domain.Order {
	o := &domain.Order{
		ID: row.OrderID.String(), TenantID: row.TenantID.String(),
		Number: row.Number, Type: domain.Type(row.OrderType),
		PatientID:   row.PatientID.String(),
		EncounterID: row.EncounterID.String(),
		FacilityID:  row.FacilityID.String(),
		RequesterID: row.RequesterID, EnteredByID: row.EnteredByID,
		TargetService: row.TargetService,
		Code: domain.Coding{
			System: row.CodeSystem, Version: row.CodeVersion,
			Code: row.Code, Display: row.CodeDisplay,
		},
		Detail: row.Detail, Indication: row.Indication,
		IndicationCode: domain.Coding{
			System: row.IndicationSystem, Code: row.IndicationCode,
			Display: row.IndicationDisplay,
		},
		Priority: domain.Priority(row.Priority),
		Timing: domain.Timing{
			StartAt:    timeOrZero(row.TimingStartAt),
			EndAt:      timeOrZero(row.TimingEndAt),
			Frequency:  time.Duration(row.TimingFrequencySeconds) * time.Second,
			Count:      row.TimingCount,
			TimesOfDay: row.TimingTimesOfDay,
			DaysOfWeek: weekdaysFromInts(row.TimingDaysOfWeek),
			PRN:        row.TimingPrn,
			Duration:   time.Duration(row.TimingDurationSeconds) * time.Second,
		},
		ConditionalInstruction:  row.ConditionalInstruction,
		Status:                  domain.Status(row.Status),
		OrderSetID:              uuidOrEmpty(row.OrderSetID),
		OrderSetVersion:         row.OrderSetVersion,
		FavouriteID:             uuidOrEmpty(row.FavouriteID),
		CancellationRequestedAt: timeOrZero(row.CancellationRequestedAt),
		CancellationRequestedBy: row.CancellationRequestedBy,
		CancellationReason:      row.CancellationReason,
		CreatedAt:               timeOrZero(row.CreatedAt),
		UpdatedAt:               timeOrZero(row.UpdatedAt),
		Version:                 row.Version,
	}
	if row.DuplicateOverrideReason != "" {
		against := make([]string, 0, len(row.DuplicateOverrideAgainst))
		for _, id := range row.DuplicateOverrideAgainst {
			against = append(against, id.String())
		}
		o.DuplicateOverride = &domain.DuplicateOverride{
			AgainstOrderIDs: against,
			Reason:          row.DuplicateOverrideReason,
			By:              row.DuplicateOverrideBy,
			At:              timeOrZero(row.DuplicateOverrideAt),
		}
	}
	return o
}

// AckRepo records what performing services report (SRS-ORD-006).
type AckRepo struct{ *Repository }

var _ ports.AcknowledgementRepository = AckRepo{}

// NewAcknowledgements constructs the acknowledgement adapter.
func NewAcknowledgements(r *Repository) AckRepo { return AckRepo{r} }

// Claim records a delivery and reports whether it is new.
//
// The idempotency is the primary key's, not this method's: two deliveries of
// one acknowledgement can be in flight at the same moment, and a
// check-then-insert would let both through — moving the order twice and
// emitting two events (SRS-ORD-006).
func (r AckRepo) Claim(ctx context.Context, scope authctx.TenantScope,
	ack domain.Acknowledgement, now time.Time) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	orderID, err := mustUUID(ack.OrderID)
	if err != nil {
		return err
	}

	occurred := ack.OccurredAt
	if occurred.IsZero() {
		occurred = now
	}

	rows, err := r.queries(ctx).InsertAcknowledgement(ctx,
		sqlcgen.InsertAcknowledgementParams{
			TenantID: tenantID, OrderID: orderID,
			Service: ack.Service, DeliveryID: ack.DeliveryID,
			ToStatus: string(ack.Status), Reason: ack.Reason,
			PerformerID: ack.PerformerID,
			OccurredAt:  timestamptz(occurred),
			ReceivedAt:  timestamptz(now),
			// Set by MarkApplied once the transition lands, so "how often does
			// the bus redeliver" stays answerable.
			Applied: false,
		})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ports.ErrAlreadyAcknowledged
	}
	return nil
}

// MarkApplied records that a claimed delivery actually moved the order.
func (r AckRepo) MarkApplied(ctx context.Context, scope authctx.TenantScope,
	ack domain.Acknowledgement) error {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return err
	}
	orderID, err := mustUUID(ack.OrderID)
	if err != nil {
		return err
	}
	return r.queries(ctx).MarkAcknowledgementApplied(ctx,
		sqlcgen.MarkAcknowledgementAppliedParams{
			TenantID: tenantID, OrderID: orderID,
			Service: ack.Service, DeliveryID: ack.DeliveryID,
		})
}

// List reads an order's acknowledgements.
func (r AckRepo) List(ctx context.Context, scope authctx.TenantScope,
	orderID string) ([]domain.Acknowledgement, error) {

	tenantID, err := scopeTenantID(scope)
	if err != nil {
		return nil, err
	}
	id, err := lookupUUID(orderID)
	if err != nil {
		return nil, err
	}

	rows, err := r.queries(ctx).ListAcknowledgements(ctx,
		sqlcgen.ListAcknowledgementsParams{TenantID: tenantID, OrderID: id})
	if err != nil {
		return nil, err
	}

	out := make([]domain.Acknowledgement, 0, len(rows))
	for _, row := range rows {
		out = append(out, domain.Acknowledgement{
			OrderID: row.OrderID.String(), Service: row.Service,
			DeliveryID: row.DeliveryID, Status: domain.Status(row.ToStatus),
			Reason: row.Reason, PerformerID: row.PerformerID,
			OccurredAt: timeOrZero(row.OccurredAt),
		})
	}
	return out, nil
}
