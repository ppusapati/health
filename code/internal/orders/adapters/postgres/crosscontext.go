package postgres

import (
	"context"
	"time"

	encounterports "github.com/ppusapati/health/code/internal/encounter/ports"
	"github.com/ppusapati/health/code/internal/orders/domain"
	"github.com/ppusapati/health/code/internal/orders/ports"
	orgdomain "github.com/ppusapati/health/code/internal/organization/domain"
	orgports "github.com/ppusapati/health/code/internal/organization/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/outbox"
)

// Seams onto the contexts the order framework depends on, and the one it
// dispatches through.
//
// Adapters rather than shared tables. Whether a visit is open is the encounter
// context's fact and an order number is the platform's; a copy of either here
// would be a second answer that drifts.

// Encounters adapts the encounter context (SRS-ORD-002).
type Encounters struct {
	encounters encounterports.EncounterRepository
	facilities orgports.FacilityRepository
}

// NewEncounters constructs the adapter.
func NewEncounters(encounters encounterports.EncounterRepository,
	facilities orgports.FacilityRepository) Encounters {

	return Encounters{encounters: encounters, facilities: facilities}
}

var _ ports.Encounters = Encounters{}

// Check reports whether an encounter accepts orders and whose it is.
//
// The facility's time zone comes back with it, because SRS-ORD-008's expansion
// needs it: a four-times-daily schedule computed in UTC is an hour out twice a
// year, which is how a dose lands at 01:00.
func (e Encounters) Check(ctx context.Context, scope authctx.TenantScope,
	encounterID string) (ports.EncounterState, error) {

	encounter, err := e.encounters.Get(ctx, scope, encounterID)
	if err != nil {
		// Not-found propagates: an order cannot be placed into an encounter
		// this tenant does not hold, and the refusal must not confirm it exists
		// elsewhere.
		return ports.EncounterState{}, err
	}

	state := ports.EncounterState{
		PatientID: encounter.PatientID, FacilityID: encounter.FacilityID,
		Open: encounter.AcceptsClinicalContent(),
	}
	if e.facilities == nil {
		return state, nil
	}
	facility, err := e.facilities.GetByID(ctx, scope, encounter.FacilityID)
	if err != nil {
		// A facility that cannot be read leaves the caller to fall back to UTC,
		// which is visibly wrong rather than quietly so: the alternative is
		// refusing every order because a lookup failed.
		return state, nil
	}
	state.TimeZone = facility.TimeZone
	return state, nil
}

// Numbers issues order numbers from the platform's sequence (SRS-PLT-014).
type Numbers struct {
	issuer orgports.NumberIssuer
}

// NewNumbers constructs the adapter.
func NewNumbers(issuer orgports.NumberIssuer) Numbers {
	return Numbers{issuer: issuer}
}

var _ ports.Numbers = Numbers{}

// Issue allocates the next order number.
func (n Numbers) Issue(ctx context.Context, scope authctx.TenantScope,
	facilityID string, now time.Time) (string, error) {

	// Per tenant rather than per facility: a laboratory serving three sites
	// reads order numbers off requisitions from all three, and per-facility
	// counters would produce collisions on the bench.
	return n.issuer.IssueNumber(ctx, scope, orgdomain.ScopeOrder, "", "", now)
}

// OutboxDispatcher routes orders to their performing service (SRS-ORD-006).
//
// The outbox rather than a direct call, because the requirement is explicit
// that routing happens "via event/RPC without database coupling" — a laboratory
// that read the orders table would be a laboratory that breaks when the schema
// changes, and the two would then have to be released together.
type OutboxDispatcher struct {
	events ports.EventAppender
	ids    ports.IDGenerator
	clock  ports.Clock
}

// NewDispatcher constructs the outbox dispatcher.
func NewDispatcher(events ports.EventAppender, ids ports.IDGenerator,
	clock ports.Clock) OutboxDispatcher {

	return OutboxDispatcher{events: events, ids: ids, clock: clock}
}

var _ ports.Dispatcher = OutboxDispatcher{}

// Dispatch writes the order to the outbox for its performing service.
//
// One event per order rather than a broadcast: the event type names the service
// so a consumer subscribes to its own work, and a laboratory does not receive
// every diet order in the hospital.
func (d OutboxDispatcher) Dispatch(ctx context.Context,
	scope authctx.TenantScope, dispatch domain.Dispatch) error {

	session, err := authctx.FromContext(ctx)
	if err != nil {
		return err
	}

	occurrences := make([]string, 0, len(dispatch.Occurrences))
	for _, o := range dispatch.Occurrences {
		occurrences = append(occurrences, o.UTC().Format(time.RFC3339))
	}

	payload := map[string]any{
		"order_id": dispatch.OrderID, "number": dispatch.Number,
		"order_type": string(dispatch.Type), "service": dispatch.Service,
		"patient_id": dispatch.PatientID, "encounter_id": dispatch.EncounterID,
		"facility_id": dispatch.FacilityID, "requester_id": dispatch.RequesterID,
		"code_system": dispatch.Code.System, "code": dispatch.Code.Code,
		"code_display": dispatch.Code.Display,
		"detail":       dispatch.Detail, "indication": dispatch.Indication,
		"priority": string(dispatch.Priority),
		// SRS-ORD-008: explicit times, not a rule the receiver must interpret.
		"occurrences": occurrences, "prn": dispatch.PRN,
		"conditional_instruction": dispatch.ConditionalInstruction,
		// SRS-ORD-004's corrective workflow reaches the service that has to act
		// on it.
		"cancellation_requested": dispatch.CancellationRequested,
		"cancellation_reason":    dispatch.CancellationReason,
	}
	encoded, err := encodeDispatch(payload)
	if err != nil {
		return err
	}

	return d.events.Append(ctx, outbox.Event{
		EventID: d.ids.NewID(),
		// The service is in the type, so a consumer subscribes to its own work.
		EventType:     "order.dispatched." + dispatch.Service,
		SchemaVersion: 1,
		OccurredAt:    d.clock.Now().UTC(),
		TenantID:      session.TenantID,
		Source:        "orders",
		AggregateType: "order",
		AggregateID:   dispatch.OrderID,
		CorrelationID: session.CorrelationID,
		CausationID:   session.RequestID,
		Actor:         session.SubjectID,
		Payload:       encoded,
	})
}

func encodeDispatch(payload map[string]any) ([]byte, error) {
	return toJSON(payload)
}
