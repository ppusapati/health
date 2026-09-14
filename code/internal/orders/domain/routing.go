package domain

import (
	"strings"
	"time"
)

// Routing an order to the service that performs it (SRS-ORD-006, SRS-ORD-011).
//
// The requirement's two halves are load-bearing in opposite directions. "Route
// to owning bounded context via event/RPC without database coupling" says the
// laboratory must not read the orders table: a downstream context that queried
// this schema would be a context that breaks when the schema changes, and the
// two would then have to be released together. "Downstream system acknowledges
// idempotently" says the same acknowledgement may arrive twice — because an
// at-least-once bus is the only kind anybody can build — and the second must
// not move the order or produce a second event.

// Acknowledgement is a performing service reporting what it did with an order
// (SRS-ORD-006).
type Acknowledgement struct {
	OrderID string
	// Service is who is acknowledging. Checked against the order's target, so
	// the kitchen cannot accept a blood-product order.
	Service string
	// DeliveryID is the bus's identifier for this delivery. The deduplication
	// key: the same delivery replayed carries the same identifier, and two
	// genuinely separate acknowledgements carry two.
	DeliveryID string
	Status     Status
	Reason     string
	// PerformerID is the person or system inside the service. A laboratory
	// analyser is a legitimate answer.
	PerformerID string
	OccurredAt  time.Time
}

// Validate rejects an acknowledgement that could not be applied.
func (a Acknowledgement) Validate() error {
	switch {
	case strings.TrimSpace(a.OrderID) == "":
		return invalidf("an acknowledgement needs an order")
	case strings.TrimSpace(a.Service) == "":
		return invalidf("an acknowledgement must say which service sent it")
	case strings.TrimSpace(a.DeliveryID) == "":
		// Without it the replay of a delivery is indistinguishable from a new
		// one, and SRS-ORD-006's idempotency has nothing to key on.
		return invalidf("an acknowledgement needs a delivery identifier")
	case strings.TrimSpace(a.PerformerID) == "":
		return invalidf("an acknowledgement must say who acted")
	}
	switch a.Status {
	case StatusAccepted, StatusScheduled, StatusInProgress, StatusCompleted,
		StatusCancelled:
	default:
		// A performing service reports what it did. It does not get to mark an
		// order entered-in-error — that is a statement about the requester's
		// record, and the requester makes it.
		return invalidf(
			"a performing service cannot report an order as %q", a.Status)
	}
	return nil
}

// ApplyAcknowledgement advances an order on a downstream report
// (SRS-ORD-006).
//
// Returns whether anything changed, so the caller knows whether to emit an
// event. A replayed delivery changes nothing and emits nothing, which is the
// idempotency the requirement asks for; the caller still has to reject the
// replay by delivery identifier before reaching here, because an
// acknowledgement can legitimately repeat a status the order has already
// reached by another route.
func (o *Order) ApplyAcknowledgement(ack Acknowledgement, now time.Time) (
	bool, error) {

	if err := ack.Validate(); err != nil {
		return false, err
	}
	if ack.OrderID != o.ID {
		return false, invalidf("this acknowledgement is for a different order")
	}
	if !strings.EqualFold(ack.Service, o.TargetService) {
		// The kitchen acknowledging a blood-product order is either a routing
		// bug or an attempt to move somebody else's work, and both are refused.
		return false, notAllowedf(
			"%s is not the service performing this order", ack.Service)
	}
	if o.Status == ack.Status {
		return false, nil
	}
	if !CanTransition(o.Status, ack.Status) {
		return false, notAllowedf("an order cannot go from %s to %s",
			o.Status, ack.Status)
	}
	if ack.Status == StatusCancelled && strings.TrimSpace(ack.Reason) == "" {
		return false, invalidf("cancelling an order needs a reason")
	}

	at := ack.OccurredAt
	if at.IsZero() {
		at = now
	}
	if err := o.transition(ack.Status, ack.PerformerID, ack.Reason, at); err != nil {
		return false, err
	}
	return true, nil
}

// Dispatch is the message a performing service receives (SRS-ORD-006).
//
// A projection rather than the order: the laboratory needs to know what to do,
// for whom, when and how urgently, and does not need the requester's favourite
// identifier or the duplicate override that let the order through. Narrow by
// construction, so a downstream context cannot quietly grow a dependency on a
// field this one may want to change.
type Dispatch struct {
	OrderID     string
	Number      string
	Type        Type
	Service     string
	PatientID   string
	EncounterID string
	FacilityID  string
	RequesterID string
	Code        Coding
	Detail      string
	Indication  string
	Priority    Priority
	// Occurrences is the normalised timing SRS-ORD-008 requires: explicit
	// times, not a rule the receiver has to interpret. A laboratory that parsed
	// "6 hourly" for itself would disagree with the pharmacy about when the
	// patient is due.
	Occurrences []time.Time
	PRN         bool
	// ConditionalInstruction travels as text because the condition refers to
	// clinical facts this context does not hold. Named separately from Detail
	// so a receiver cannot mistake a condition for an instruction.
	ConditionalInstruction string
	// CancellationRequested carries SRS-ORD-004's corrective workflow to the
	// service that has to act on it.
	CancellationRequested bool
	CancellationReason    string
	PlacedAt              time.Time
}

// DispatchFor builds the message for an order's performing service.
//
// The occurrence window is bounded by the caller, because a standing order has
// no last occurrence and a dispatch carrying an infinite list is a dispatch
// nobody can send.
func (o *Order) DispatchFor(from, to time.Time, in *time.Location) Dispatch {
	return Dispatch{
		OrderID: o.ID, Number: o.Number, Type: o.Type,
		Service: o.TargetService, PatientID: o.PatientID,
		EncounterID: o.EncounterID, FacilityID: o.FacilityID,
		RequesterID: o.RequesterID,
		Code:        o.Code, Detail: o.Detail, Indication: o.Indication,
		Priority:               o.Priority,
		Occurrences:            o.Timing.Occurrences(from, to, in),
		PRN:                    o.Timing.PRN,
		ConditionalInstruction: o.ConditionalInstruction,
		CancellationRequested:  o.CancellationPending(),
		CancellationReason:     o.CancellationReason,
		PlacedAt:               o.CreatedAt,
	}
}
