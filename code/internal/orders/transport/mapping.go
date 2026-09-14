// Package transport serves healthcare.orders.v1.OrderService.
package transport

import (
	"time"

	ordersv1 "github.com/ppusapati/health/code/gen/go/healthcare/orders/v1"
	"github.com/ppusapati/health/code/internal/orders/domain"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Enumeration maps. Written out rather than derived, because a generated
// mapping would silently gain a value the domain has not thought about — and
// here the unthought-about value is an order type that would route nowhere.

var typeToProto = map[domain.Type]ordersv1.OrderType{
	domain.TypeLaboratory:   ordersv1.OrderType_ORDER_TYPE_LABORATORY,
	domain.TypeImaging:      ordersv1.OrderType_ORDER_TYPE_IMAGING,
	domain.TypeMedication:   ordersv1.OrderType_ORDER_TYPE_MEDICATION,
	domain.TypeProcedure:    ordersv1.OrderType_ORDER_TYPE_PROCEDURE,
	domain.TypeDiet:         ordersv1.OrderType_ORDER_TYPE_DIET,
	domain.TypeNursing:      ordersv1.OrderType_ORDER_TYPE_NURSING,
	domain.TypeBloodProduct: ordersv1.OrderType_ORDER_TYPE_BLOOD_PRODUCT,
	domain.TypeReferral:     ordersv1.OrderType_ORDER_TYPE_REFERRAL,
	domain.TypeAlliedHealth: ordersv1.OrderType_ORDER_TYPE_ALLIED_HEALTH,
}

var typeFromProto = map[ordersv1.OrderType]domain.Type{
	ordersv1.OrderType_ORDER_TYPE_LABORATORY:    domain.TypeLaboratory,
	ordersv1.OrderType_ORDER_TYPE_IMAGING:       domain.TypeImaging,
	ordersv1.OrderType_ORDER_TYPE_MEDICATION:    domain.TypeMedication,
	ordersv1.OrderType_ORDER_TYPE_PROCEDURE:     domain.TypeProcedure,
	ordersv1.OrderType_ORDER_TYPE_DIET:          domain.TypeDiet,
	ordersv1.OrderType_ORDER_TYPE_NURSING:       domain.TypeNursing,
	ordersv1.OrderType_ORDER_TYPE_BLOOD_PRODUCT: domain.TypeBloodProduct,
	ordersv1.OrderType_ORDER_TYPE_REFERRAL:      domain.TypeReferral,
	ordersv1.OrderType_ORDER_TYPE_ALLIED_HEALTH: domain.TypeAlliedHealth,
}

var statusToProto = map[domain.Status]ordersv1.OrderStatus{
	domain.StatusDraft:          ordersv1.OrderStatus_ORDER_STATUS_DRAFT,
	domain.StatusRequested:      ordersv1.OrderStatus_ORDER_STATUS_REQUESTED,
	domain.StatusAccepted:       ordersv1.OrderStatus_ORDER_STATUS_ACCEPTED,
	domain.StatusScheduled:      ordersv1.OrderStatus_ORDER_STATUS_SCHEDULED,
	domain.StatusInProgress:     ordersv1.OrderStatus_ORDER_STATUS_IN_PROGRESS,
	domain.StatusCompleted:      ordersv1.OrderStatus_ORDER_STATUS_COMPLETED,
	domain.StatusCancelled:      ordersv1.OrderStatus_ORDER_STATUS_CANCELLED,
	domain.StatusEnteredInError: ordersv1.OrderStatus_ORDER_STATUS_ENTERED_IN_ERROR,
}

var statusFromProto = map[ordersv1.OrderStatus]domain.Status{
	ordersv1.OrderStatus_ORDER_STATUS_DRAFT:            domain.StatusDraft,
	ordersv1.OrderStatus_ORDER_STATUS_REQUESTED:        domain.StatusRequested,
	ordersv1.OrderStatus_ORDER_STATUS_ACCEPTED:         domain.StatusAccepted,
	ordersv1.OrderStatus_ORDER_STATUS_SCHEDULED:        domain.StatusScheduled,
	ordersv1.OrderStatus_ORDER_STATUS_IN_PROGRESS:      domain.StatusInProgress,
	ordersv1.OrderStatus_ORDER_STATUS_COMPLETED:        domain.StatusCompleted,
	ordersv1.OrderStatus_ORDER_STATUS_CANCELLED:        domain.StatusCancelled,
	ordersv1.OrderStatus_ORDER_STATUS_ENTERED_IN_ERROR: domain.StatusEnteredInError,
}

var priorityToProto = map[domain.Priority]ordersv1.Priority{
	domain.PriorityRoutine: ordersv1.Priority_PRIORITY_ROUTINE,
	domain.PriorityUrgent:  ordersv1.Priority_PRIORITY_URGENT,
	domain.PriorityStat:    ordersv1.Priority_PRIORITY_STAT,
	domain.PriorityTiming:  ordersv1.Priority_PRIORITY_TIMING_CRITICAL,
}

var priorityFromProto = map[ordersv1.Priority]domain.Priority{
	ordersv1.Priority_PRIORITY_ROUTINE:         domain.PriorityRoutine,
	ordersv1.Priority_PRIORITY_URGENT:          domain.PriorityUrgent,
	ordersv1.Priority_PRIORITY_STAT:            domain.PriorityStat,
	ordersv1.Priority_PRIORITY_TIMING_CRITICAL: domain.PriorityTiming,
}

func ts(t time.Time) *timestamppb.Timestamp {
	if t.IsZero() {
		return nil
	}
	return timestamppb.New(t.UTC())
}

func goTime(t *timestamppb.Timestamp) time.Time {
	if t == nil {
		return time.Time{}
	}
	return t.AsTime().UTC()
}

func codingToProto(c domain.Coding) *ordersv1.Coding {
	if c.Empty() {
		return nil
	}
	return &ordersv1.Coding{
		System: c.System, Version: c.Version, Code: c.Code, Display: c.Display,
	}
}

func codingFromProto(c *ordersv1.Coding) domain.Coding {
	if c == nil {
		return domain.Coding{}
	}
	return domain.Coding{
		System: c.GetSystem(), Version: c.GetVersion(),
		Code: c.GetCode(), Display: c.GetDisplay(),
	}
}

func timingToProto(t domain.Timing) *ordersv1.Timing {
	return &ordersv1.Timing{
		StartAt: ts(t.StartAt), EndAt: ts(t.EndAt),
		FrequencySeconds: int64(t.Frequency / time.Second),
		Count:            t.Count,
		DaysOfWeek:       weekdaysToInts(t.DaysOfWeek),
		TimesOfDay:       t.TimesOfDay,
		Prn:              t.PRN,
		DurationSeconds:  int64(t.Duration / time.Second),
	}
}

func timingFromProto(t *ordersv1.Timing) domain.Timing {
	if t == nil {
		return domain.Timing{}
	}
	return domain.Timing{
		StartAt: goTime(t.GetStartAt()), EndAt: goTime(t.GetEndAt()),
		Frequency:  time.Duration(t.GetFrequencySeconds()) * time.Second,
		Count:      t.GetCount(),
		DaysOfWeek: weekdaysFromInts(t.GetDaysOfWeek()),
		TimesOfDay: t.GetTimesOfDay(),
		PRN:        t.GetPrn(),
		Duration:   time.Duration(t.GetDurationSeconds()) * time.Second,
	}
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

func orderToProto(o *domain.Order) *ordersv1.Order {
	if o == nil {
		return nil
	}
	history := make([]*ordersv1.StatusChange, 0, len(o.History))
	for _, c := range o.History {
		history = append(history, &ordersv1.StatusChange{
			ChangeId: c.ID, From: statusToProto[c.From], To: statusToProto[c.To],
			By: c.By, Reason: c.Reason, OccurredAt: ts(c.OccurredAt),
		})
	}

	out := &ordersv1.Order{
		OrderId: o.ID, Number: o.Number, Type: typeToProto[o.Type],
		PatientId: o.PatientID, EncounterId: o.EncounterID,
		FacilityId: o.FacilityID, RequesterId: o.RequesterID,
		EnteredById: o.EnteredByID,
		// Derived from the type, so a routing-table change does not re-route
		// orders already in flight (SRS-ORD-006).
		TargetService: o.TargetService,
		Code:          codingToProto(o.Code), Detail: o.Detail,
		Indication: o.Indication, IndicationCode: codingToProto(o.IndicationCode),
		Priority: priorityToProto[o.Priority], Timing: timingToProto(o.Timing),
		ConditionalInstruction: o.ConditionalInstruction,
		Status:                 statusToProto[o.Status], History: history,
		OrderSetId: o.OrderSetID, OrderSetVersion: o.OrderSetVersion,
		FavouriteId: o.FavouriteID,
		// SRS-ORD-004: a request, not a status. A client that read the status
		// alone would tell a ward that a transfusion had stopped when it had
		// not.
		CancellationRequestedAt: ts(o.CancellationRequestedAt),
		CancellationRequestedBy: o.CancellationRequestedBy,
		CancellationReason:      o.CancellationReason,
		CreatedAt:               ts(o.CreatedAt), UpdatedAt: ts(o.UpdatedAt),
		Version: o.Version,
	}
	if o.DuplicateOverride != nil {
		out.DuplicateOverride = &ordersv1.DuplicateOverride{
			AgainstOrderIds: o.DuplicateOverride.AgainstOrderIDs,
			Reason:          o.DuplicateOverride.Reason,
			By:              o.DuplicateOverride.By,
			At:              ts(o.DuplicateOverride.At),
		}
	}
	return out
}

func ordersToProto(in []*domain.Order) []*ordersv1.Order {
	out := make([]*ordersv1.Order, 0, len(in))
	for _, o := range in {
		out = append(out, orderToProto(o))
	}
	return out
}

// warningToProto renders a duplicate warning (SRS-ORD-009).
//
// The existing orders travel in full: "a duplicate exists" without saying which
// one is a warning nobody can act on.
func warningToProto(w *domain.DuplicateWarning) *ordersv1.DuplicateWarning {
	if w == nil {
		return nil
	}
	return &ordersv1.DuplicateWarning{
		Existing: ordersToProto(w.Existing), Overridable: w.Overridable,
		WindowSeconds: int64(w.Rule.Within / time.Second),
	}
}

func componentsToProto(in []domain.Component) []*ordersv1.Component {
	out := make([]*ordersv1.Component, 0, len(in))
	for _, c := range in {
		out = append(out, &ordersv1.Component{
			ComponentId: c.ID, Type: typeToProto[c.Type],
			Code: codingToProto(c.Code), Detail: c.Detail,
			Indication: c.Indication, Priority: priorityToProto[c.Priority],
			Timing:            timingToProto(c.Timing),
			SelectedByDefault: c.SelectedByDefault, Mandatory: c.Mandatory,
		})
	}
	return out
}

func componentsFromProto(in []*ordersv1.Component) []domain.Component {
	out := make([]domain.Component, 0, len(in))
	for _, c := range in {
		out = append(out, domain.Component{
			ID: c.GetComponentId(), Type: typeFromProto[c.GetType()],
			Code: codingFromProto(c.GetCode()), Detail: c.GetDetail(),
			Indication:        c.GetIndication(),
			Priority:          priorityFromProto[c.GetPriority()],
			Timing:            timingFromProto(c.GetTiming()),
			SelectedByDefault: c.GetSelectedByDefault(),
			Mandatory:         c.GetMandatory(),
		})
	}
	return out
}

func setToProto(s domain.OrderSet) *ordersv1.OrderSet {
	return &ordersv1.OrderSet{
		SetId: s.ID, Version: s.Version, Name: s.Name, Specialty: s.Specialty,
		Components: componentsToProto(s.Components), Retired: s.Retired(),
		CreatedBy: s.CreatedBy, CreatedAt: ts(s.CreatedAt),
	}
}

func setFromProto(s *ordersv1.OrderSet) domain.OrderSet {
	if s == nil {
		return domain.OrderSet{}
	}
	return domain.OrderSet{
		ID: s.GetSetId(), Version: s.GetVersion(), Name: s.GetName(),
		Specialty:  s.GetSpecialty(),
		Components: componentsFromProto(s.GetComponents()),
	}
}

func selectionsFromProto(in []*ordersv1.Selection) []domain.Selection {
	out := make([]domain.Selection, 0, len(in))
	for _, s := range in {
		sel := domain.Selection{
			ComponentID: s.GetComponentId(), Detail: s.GetDetail(),
			Indication: s.GetIndication(),
			Priority:   priorityFromProto[s.GetPriority()],
		}
		if s.GetTiming() != nil {
			timing := timingFromProto(s.GetTiming())
			sel.Timing = &timing
		}
		out = append(out, sel)
	}
	return out
}

// favouriteToProto renders a favourite.
//
// No owner on the wire: a favourite is always the caller's own, and a field
// that could name somebody else would invite a client to ask for a colleague's
// practice (SRS-ORD-012).
func favouriteToProto(f domain.Favourite) *ordersv1.Favourite {
	return &ordersv1.Favourite{
		FavouriteId: f.ID, Name: f.Name, Type: typeToProto[f.Type],
		Code: codingToProto(f.Code), Detail: f.Detail,
		Indication: f.Indication, Priority: priorityToProto[f.Priority],
		Timing:    timingToProto(f.Timing),
		CreatedAt: ts(f.CreatedAt), UpdatedAt: ts(f.UpdatedAt),
	}
}

func favouriteFromProto(f *ordersv1.Favourite) domain.Favourite {
	if f == nil {
		return domain.Favourite{}
	}
	return domain.Favourite{
		ID: f.GetFavouriteId(), Name: f.GetName(),
		Type: typeFromProto[f.GetType()], Code: codingFromProto(f.GetCode()),
		Detail: f.GetDetail(), Indication: f.GetIndication(),
		Priority: priorityFromProto[f.GetPriority()],
		Timing:   timingFromProto(f.GetTiming()),
	}
}
