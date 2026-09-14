package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/orders/domain"
)

func placedOrder(t *testing.T) *domain.Order {
	t.Helper()
	order := newOrder(t, baseInput(domain.TypeLaboratory))
	if err := order.Submit(domain.DefaultPolicy(), "doctor-1", at(9, 1)); err != nil {
		t.Fatalf("Submit: %v", err)
	}
	return order
}

func ack(orderID, service, delivery string,
	status domain.Status) domain.Acknowledgement {

	return domain.Acknowledgement{
		OrderID: orderID, Service: service, DeliveryID: delivery,
		Status: status, PerformerID: "analyser-3", OccurredAt: at(9, 30),
	}
}

// SRS-ORD-006: the performing service advances the order.
func TestTheOwningServiceAdvancesTheOrder(t *testing.T) {
	order := placedOrder(t)

	changed, err := order.ApplyAcknowledgement(
		ack(order.ID, "laboratory", "delivery-1", domain.StatusAccepted),
		at(9, 30))
	if err != nil {
		t.Fatalf("ApplyAcknowledgement: %v", err)
	}
	if !changed {
		t.Fatal("the acknowledgement changed nothing")
	}
	if order.Status != domain.StatusAccepted {
		t.Fatalf("status is %s, want accepted", order.Status)
	}
	// The performer is recorded, and an analyser is a legitimate answer.
	last := order.History[len(order.History)-1]
	if last.By != "analyser-3" {
		t.Fatalf("the acknowledgement was attributed to %q", last.By)
	}
}

// SRS-ORD-006: the same acknowledgement applied twice changes nothing and
// emits nothing.
func TestAReplayedAcknowledgementChangesNothing(t *testing.T) {
	order := placedOrder(t)

	if _, err := order.ApplyAcknowledgement(
		ack(order.ID, "laboratory", "delivery-1", domain.StatusAccepted),
		at(9, 30)); err != nil {
		t.Fatalf("ApplyAcknowledgement: %v", err)
	}
	before := len(order.History)

	changed, err := order.ApplyAcknowledgement(
		ack(order.ID, "laboratory", "delivery-1", domain.StatusAccepted),
		at(9, 31))
	if err != nil {
		t.Fatalf("a replayed acknowledgement failed: %v", err)
	}
	// The caller uses this to decide whether to emit an event: an at-least-once
	// bus redelivers, and a second event would double-count.
	if changed {
		t.Fatal("a replayed acknowledgement reported a change")
	}
	if len(order.History) != before {
		t.Fatal("a replayed acknowledgement added a history entry")
	}
}

// The kitchen acknowledging a blood-product order is either a routing bug or an
// attempt to move somebody else's work.
func TestAServiceCannotAcknowledgeSomebodyElsesOrder(t *testing.T) {
	order := placedOrder(t)

	_, err := order.ApplyAcknowledgement(
		ack(order.ID, "dietetics", "delivery-1", domain.StatusAccepted),
		at(9, 30))
	if !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("the kitchen accepted a laboratory order: %v", err)
	}
	if order.Status != domain.StatusRequested {
		t.Fatalf("the refused acknowledgement moved the order to %s", order.Status)
	}
}

func TestAnAcknowledgementForADifferentOrderIsRefused(t *testing.T) {
	order := placedOrder(t)
	_, err := order.ApplyAcknowledgement(
		ack("order-99", "laboratory", "delivery-1", domain.StatusAccepted),
		at(9, 30))
	if !errors.Is(err, domain.ErrInvalidOrder) {
		t.Fatalf("an acknowledgement for another order was applied: %v", err)
	}
}

// Without a delivery identifier the replay of a delivery is indistinguishable
// from a new one, and SRS-ORD-006's idempotency has nothing to key on.
func TestAnAcknowledgementNeedsADeliveryIdentifier(t *testing.T) {
	order := placedOrder(t)
	a := ack(order.ID, "laboratory", "", domain.StatusAccepted)
	if _, err := order.ApplyAcknowledgement(a, at(9, 30)); !errors.Is(
		err, domain.ErrInvalidOrder) {
		t.Fatalf("an acknowledgement with no delivery id was applied: %v", err)
	}
}

// A performing service reports what it did. Marking an order entered-in-error
// is a statement about the requester's record, and the requester makes it.
func TestAServiceCannotMarkAnOrderEnteredInError(t *testing.T) {
	order := placedOrder(t)
	a := ack(order.ID, "laboratory", "delivery-1", domain.StatusEnteredInError)
	if _, err := order.ApplyAcknowledgement(a, at(9, 30)); !errors.Is(
		err, domain.ErrInvalidOrder) {
		t.Fatalf("a service retracted an order: %v", err)
	}
}

func TestAServiceCancellingNeedsAReason(t *testing.T) {
	order := placedOrder(t)
	a := ack(order.ID, "laboratory", "delivery-1", domain.StatusCancelled)
	if _, err := order.ApplyAcknowledgement(a, at(9, 30)); !errors.Is(
		err, domain.ErrInvalidOrder) {
		t.Fatalf("a service cancelled an order with no reason: %v", err)
	}

	a.Reason = "specimen haemolysed; please recollect"
	if _, err := order.ApplyAcknowledgement(a, at(9, 30)); err != nil {
		t.Fatalf("a service could not cancel with a reason: %v", err)
	}
}

// SRS-ORD-006: the dispatch is a projection, not the order — a downstream
// context must not grow a dependency on a field this one may change.
func TestTheDispatchCarriesWhatTheServiceNeedsAndNothingElse(t *testing.T) {
	in := baseInput(domain.TypeMedication)
	in.Indication = "post-operative pain"
	in.Detail = "1 g orally"
	in.Timing = domain.Timing{
		StartAt: at(0, 0), TimesOfDay: []int32{6 * 60, 18 * 60},
		EndAt: at(0, 0).Add(24 * time.Hour),
	}
	order := newOrder(t, in)
	if err := order.RecordDuplicateOverride([]string{"order-0"},
		"different indication", "doctor-1", at(9, 0)); err != nil {
		t.Fatalf("RecordDuplicateOverride: %v", err)
	}
	if err := order.Submit(domain.DefaultPolicy(), "doctor-1", at(9, 1)); err != nil {
		t.Fatalf("Submit: %v", err)
	}

	dispatch := order.DispatchFor(at(0, 0), at(0, 0).Add(24*time.Hour), kolkata)

	if dispatch.Service != "pharmacy" {
		t.Fatalf("the dispatch routes to %q", dispatch.Service)
	}
	// SRS-ORD-008: explicit times, not a rule the receiver has to interpret.
	if len(dispatch.Occurrences) != 2 {
		t.Fatalf("the dispatch carries %d occurrences, want 2",
			len(dispatch.Occurrences))
	}
	for _, o := range dispatch.Occurrences {
		hour := o.In(kolkata).Hour()
		if hour != 6 && hour != 18 {
			t.Fatalf("an occurrence falls at %d on the ward", hour)
		}
	}
	if dispatch.Indication != "post-operative pain" {
		t.Fatalf("the indication did not travel: %q", dispatch.Indication)
	}
}

// SRS-ORD-004: the corrective workflow reaches the service that has to act on
// it.
func TestAPendingCancellationTravelsToThePerformingService(t *testing.T) {
	order := placedOrder(t)
	// The laboratory accepts, then starts: a service takes an order on before
	// it begins work on it (SRS-ORD-005).
	for i, status := range []domain.Status{
		domain.StatusAccepted, domain.StatusInProgress,
	} {
		if _, err := order.ApplyAcknowledgement(
			ack(order.ID, "laboratory", "delivery-"+string(rune('1'+i)), status),
			at(9, 30)); err != nil {
			t.Fatalf("ApplyAcknowledgement(%s): %v", status, err)
		}
	}
	if err := order.RequestCancellation("patient discharged", "doctor-1",
		at(9, 40)); err != nil {
		t.Fatalf("RequestCancellation: %v", err)
	}

	dispatch := order.DispatchFor(at(0, 0), at(0, 0).Add(24*time.Hour), kolkata)
	if !dispatch.CancellationRequested {
		t.Fatal("the pending cancellation did not reach the service")
	}
	if dispatch.CancellationReason != "patient discharged" {
		t.Fatalf("the reason did not travel: %q", dispatch.CancellationReason)
	}
}

// An as-needed order carries no schedule to the service.
func TestAnAsNeededDispatchCarriesNoOccurrences(t *testing.T) {
	in := baseInput(domain.TypeMedication)
	in.Indication = "breakthrough pain"
	in.Detail = "10 mg orally"
	in.Timing = domain.Timing{PRN: true, StartAt: at(9, 0)}
	order := newOrder(t, in)
	if err := order.Submit(domain.DefaultPolicy(), "doctor-1", at(9, 1)); err != nil {
		t.Fatalf("Submit: %v", err)
	}

	dispatch := order.DispatchFor(at(0, 0), at(0, 0).Add(24*time.Hour), kolkata)
	if len(dispatch.Occurrences) != 0 {
		t.Fatalf("an as-needed order dispatched %d scheduled times",
			len(dispatch.Occurrences))
	}
	if !dispatch.PRN {
		t.Fatal("the dispatch does not say the order is as-needed")
	}
}
