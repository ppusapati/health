package domain_test

import (
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/orders/domain"
)

var kolkata = mustLoad("Asia/Kolkata")

func mustLoad(name string) *time.Location {
	loc, err := time.LoadLocation(name)
	if err != nil {
		panic(err)
	}
	return loc
}

func at(hour, minute int) time.Time {
	return time.Date(2026, 3, 12, hour, minute, 0, 0, time.UTC)
}

func potassium() domain.Coding {
	return domain.Coding{
		System: "http://loinc.org", Version: "2.76",
		Code: "2823-3", Display: "Potassium [Moles/volume] in Serum or Plasma",
	}
}

func baseInput(t domain.Type) domain.NewOrderInput {
	return domain.NewOrderInput{
		Type: t, PatientID: "patient-1", EncounterID: "encounter-1",
		FacilityID: "facility-1", RequesterID: "doctor-1",
		Code: potassium(), Priority: domain.PriorityRoutine,
	}
}

func newOrder(t *testing.T, in domain.NewOrderInput) *domain.Order {
	t.Helper()
	order, err := domain.NewOrder("order-1", "tenant-1", "ORD-0001", in, at(9, 0))
	if err != nil {
		t.Fatalf("NewOrder: %v", err)
	}
	return order
}

// SRS-ORD-001: one framework, and the target service is derived rather than
// supplied — a caller that could name its own target could route a
// blood-product order to the kitchen.
func TestAnOrderRoutesToTheServiceItsTypeImplies(t *testing.T) {
	for orderType, want := range map[domain.Type]string{
		domain.TypeLaboratory:   "laboratory",
		domain.TypeImaging:      "imaging",
		domain.TypeMedication:   "pharmacy",
		domain.TypeBloodProduct: "blood_bank",
		domain.TypeDiet:         "dietetics",
	} {
		order := newOrder(t, baseInput(orderType))
		if order.TargetService != want {
			t.Fatalf("a %s order routes to %q, want %q",
				orderType, order.TargetService, want)
		}
	}
}

// SRS-ORD-001: order_id, type, requester, patient, encounter, priority, status
// and target service.
func TestAnOrderCarriesEverythingTheRequirementNames(t *testing.T) {
	order := newOrder(t, baseInput(domain.TypeLaboratory))

	if order.ID == "" || order.Number == "" || order.Type == "" ||
		order.RequesterID == "" || order.PatientID == "" ||
		order.EncounterID == "" || order.Priority == "" ||
		order.Status == "" || order.TargetService == "" {
		t.Fatalf("an order is missing part of its identity: %+v", order)
	}
	// Composed as a draft: an order set is assembled before any of it is
	// placed, and a basket downstream could see is a basket somebody acts on.
	if order.Status != domain.StatusDraft {
		t.Fatalf("a new order is %s, want draft", order.Status)
	}
}

// An order with no encounter cannot be billed, cannot be found on the chart and
// cannot be stopped when the patient goes home.
func TestAnOrderNeedsAPatientAnEncounterAndARequester(t *testing.T) {
	for name, mutate := range map[string]func(*domain.NewOrderInput){
		"no patient":   func(in *domain.NewOrderInput) { in.PatientID = "" },
		"no encounter": func(in *domain.NewOrderInput) { in.EncounterID = "" },
		"no requester": func(in *domain.NewOrderInput) { in.RequesterID = "" },
		"no facility":  func(in *domain.NewOrderInput) { in.FacilityID = "" },
	} {
		in := baseInput(domain.TypeLaboratory)
		mutate(&in)
		if _, err := domain.NewOrder("order-1", "tenant-1", "ORD-0001", in,
			at(9, 0)); !errors.Is(err, domain.ErrInvalidOrder) {
			t.Fatalf("an order with %s was accepted: %v", name, err)
		}
	}
}

// The person who is answerable and the person who typed it are not always the
// same — a verbal order taken by a nurse.
func TestAnOrderKeepsWhoAskedAndWhoTypedItApart(t *testing.T) {
	in := baseInput(domain.TypeLaboratory)
	in.EnteredByID = "nurse-1"
	order := newOrder(t, in)

	if order.RequesterID != "doctor-1" || order.EnteredByID != "nurse-1" {
		t.Fatalf("requester %q entered-by %q",
			order.RequesterID, order.EnteredByID)
	}

	// Where they are the same, the one field answers both.
	plain := newOrder(t, baseInput(domain.TypeLaboratory))
	if plain.EnteredByID != "doctor-1" {
		t.Fatalf("entered-by is %q", plain.EnteredByID)
	}
}

// "Do it now" and "do it if" cannot both hold.
func TestAnOrderCannotBeBothImmediateAndConditional(t *testing.T) {
	in := baseInput(domain.TypeLaboratory)
	in.Priority = domain.PriorityStat
	in.ConditionalInstruction = "if the patient becomes febrile"

	if _, err := domain.NewOrder("order-1", "tenant-1", "ORD-0001", in,
		at(9, 0)); !errors.Is(err, domain.ErrInvalidOrder) {
		t.Fatalf("a stat conditional order was accepted: %v", err)
	}
}

// SRS-ORD-005: the state machine.
func TestAnOrderFollowsItsLifecycle(t *testing.T) {
	order := newOrder(t, baseInput(domain.TypeLaboratory))

	if err := order.Submit(domain.DefaultPolicy(), "doctor-1", at(9, 1)); err != nil {
		t.Fatalf("Submit: %v", err)
	}
	if order.Status != domain.StatusRequested {
		t.Fatalf("status is %s, want requested", order.Status)
	}
	for _, step := range []struct {
		name string
		fn   func(string, time.Time) error
		want domain.Status
	}{
		{"accept", order.Accept, domain.StatusAccepted},
		{"schedule", order.Schedule, domain.StatusScheduled},
		{"start", order.Start, domain.StatusInProgress},
		{"complete", order.Complete, domain.StatusCompleted},
	} {
		if err := step.fn("laboratory", at(10, 0)); err != nil {
			t.Fatalf("%s: %v", step.name, err)
		}
		if order.Status != step.want {
			t.Fatalf("after %s status is %s, want %s",
				step.name, order.Status, step.want)
		}
	}
	if len(order.History) != 5 {
		t.Fatalf("history holds %d changes, want 5", len(order.History))
	}
}

func TestAnImpossibleStateChangeIsRefused(t *testing.T) {
	order := newOrder(t, baseInput(domain.TypeLaboratory))
	if err := order.Submit(domain.DefaultPolicy(), "doctor-1", at(9, 1)); err != nil {
		t.Fatalf("Submit: %v", err)
	}
	// Requested straight to completed skips the service ever having it.
	if err := order.Complete("laboratory", at(10, 0)); !errors.Is(
		err, domain.ErrNotAllowed) {
		t.Fatalf("an order jumped from requested to completed: %v", err)
	}
}

// A redelivered acknowledgement must not fail (SRS-ORD-006).
func TestRepeatingAStatusChangeIsHarmless(t *testing.T) {
	order := newOrder(t, baseInput(domain.TypeLaboratory))
	if err := order.Submit(domain.DefaultPolicy(), "doctor-1", at(9, 1)); err != nil {
		t.Fatalf("Submit: %v", err)
	}
	if err := order.Accept("laboratory", at(9, 5)); err != nil {
		t.Fatalf("Accept: %v", err)
	}
	before := len(order.History)
	if err := order.Accept("laboratory", at(9, 6)); err != nil {
		t.Fatalf("a repeated acceptance failed: %v", err)
	}
	if len(order.History) != before {
		t.Fatal("a repeated acceptance added a history entry")
	}
}

// SRS-ORD-004: cancellation before execution is free.
func TestAnUnstartedOrderIsCancelledDirectly(t *testing.T) {
	order := newOrder(t, baseInput(domain.TypeLaboratory))
	if err := order.Submit(domain.DefaultPolicy(), "doctor-1", at(9, 1)); err != nil {
		t.Fatalf("Submit: %v", err)
	}
	if err := order.Cancel("no longer needed", "doctor-1", at(9, 30)); err != nil {
		t.Fatalf("Cancel: %v", err)
	}
	if order.Status != domain.StatusCancelled {
		t.Fatalf("status is %s, want cancelled", order.Status)
	}
}

func TestCancellingNeedsAReason(t *testing.T) {
	order := newOrder(t, baseInput(domain.TypeLaboratory))
	if err := order.Submit(domain.DefaultPolicy(), "doctor-1", at(9, 1)); err != nil {
		t.Fatalf("Submit: %v", err)
	}
	if err := order.Cancel("", "doctor-1", at(9, 30)); !errors.Is(
		err, domain.ErrInvalidOrder) {
		t.Fatalf("an order was cancelled with no reason: %v", err)
	}
}

// SRS-ORD-004: cancellation after execution is rejected, and the refusal says
// what to do instead.
func TestCancellingAnExecutingOrderIsRefusedAndNamesTheAlternative(t *testing.T) {
	order := newOrder(t, baseInput(domain.TypeLaboratory))
	if err := order.Submit(domain.DefaultPolicy(), "doctor-1", at(9, 1)); err != nil {
		t.Fatalf("Submit: %v", err)
	}
	if err := order.Accept("laboratory", at(9, 5)); err != nil {
		t.Fatalf("Accept: %v", err)
	}
	// The specimen has been drawn.
	if err := order.Start("laboratory", at(9, 20)); err != nil {
		t.Fatalf("Start: %v", err)
	}

	err := order.Cancel("no longer needed", "doctor-1", at(9, 30))
	var refusal domain.ErrCancellationAfterExecution
	if !errors.As(err, &refusal) {
		t.Fatalf("an executing order was cancelled: %v", err)
	}
	// The clinician is told what to do instead rather than discovering it by
	// trying.
	if !strings.Contains(refusal.CorrectiveAction, "specimen") {
		t.Fatalf("the refusal does not name the corrective action: %q",
			refusal.CorrectiveAction)
	}
	if order.Status != domain.StatusInProgress {
		t.Fatalf("the refused cancellation moved the order to %s", order.Status)
	}
}

// The corrective action differs by type, because stopping a transfusion and
// stopping a physiotherapy course are not the same act.
func TestTheCorrectiveActionDependsOnWhatIsBeingStopped(t *testing.T) {
	actions := map[domain.Type]string{
		domain.TypeBloodProduct: "blood bank",
		domain.TypeMedication:   "discontinue",
		domain.TypeImaging:      "imaging department",
	}
	for orderType, want := range actions {
		in := baseInput(orderType)
		in.Indication = "clinically indicated"
		in.Detail = "as charted"
		in.Timing = domain.Timing{StartAt: at(9, 0)}
		order := newOrder(t, in)
		if err := order.Submit(domain.DefaultPolicy(), "doctor-1", at(9, 1)); err != nil {
			t.Fatalf("Submit %s: %v", orderType, err)
		}
		if err := order.Accept("service", at(9, 5)); err != nil {
			// Accept checks nothing about the service name; routing is checked
			// on acknowledgement.
			t.Fatalf("Accept: %v", err)
		}
		if err := order.Start("service", at(9, 10)); err != nil {
			t.Fatalf("Start: %v", err)
		}

		err := order.Cancel("changed my mind", "doctor-1", at(9, 20))
		var refusal domain.ErrCancellationAfterExecution
		if !errors.As(err, &refusal) {
			t.Fatalf("%s: an executing order was cancelled", orderType)
		}
		if !strings.Contains(refusal.CorrectiveAction, want) {
			t.Fatalf("%s corrective action is %q, want it to mention %q",
				orderType, refusal.CorrectiveAction, want)
		}
	}
}

// SRS-ORD-004's corrective workflow: the request does not change the state,
// because a request is not an outcome.
func TestACancellationRequestDoesNotPretendTheOrderIsCancelled(t *testing.T) {
	order := newOrder(t, baseInput(domain.TypeLaboratory))
	if err := order.Submit(domain.DefaultPolicy(), "doctor-1", at(9, 1)); err != nil {
		t.Fatalf("Submit: %v", err)
	}
	if err := order.Accept("laboratory", at(9, 5)); err != nil {
		t.Fatalf("Accept: %v", err)
	}
	if err := order.Start("laboratory", at(9, 20)); err != nil {
		t.Fatalf("Start: %v", err)
	}

	if err := order.RequestCancellation("patient discharged", "doctor-1",
		at(9, 30)); err != nil {
		t.Fatalf("RequestCancellation: %v", err)
	}
	// Showing it as cancelled while the laboratory is still running the test
	// would tell the ward the wrong thing.
	if order.Status != domain.StatusInProgress {
		t.Fatalf("the request moved the order to %s", order.Status)
	}
	if !order.CancellationPending() {
		t.Fatal("the pending cancellation is not visible")
	}

	// Asked once.
	if err := order.RequestCancellation("again", "doctor-1",
		at(9, 40)); !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("a cancellation was requested twice: %v", err)
	}

	// The laboratory answers it, and the order then moves.
	changed, err := order.ApplyAcknowledgement(domain.Acknowledgement{
		OrderID: order.ID, Service: "laboratory", DeliveryID: "delivery-1",
		Status: domain.StatusCompleted, PerformerID: "analyser-3",
		OccurredAt: at(10, 0),
	}, at(10, 0))
	if err != nil || !changed {
		t.Fatalf("the laboratory could not answer the request: %v", err)
	}
	if order.CancellationPending() {
		t.Fatal("the cancellation is still pending after the service answered")
	}
}

// A request before the service has started is the wrong tool: cancel directly.
func TestACancellationRequestBeforeExecutionIsRefused(t *testing.T) {
	order := newOrder(t, baseInput(domain.TypeLaboratory))
	if err := order.Submit(domain.DefaultPolicy(), "doctor-1", at(9, 1)); err != nil {
		t.Fatalf("Submit: %v", err)
	}
	if err := order.RequestCancellation("no longer needed", "doctor-1",
		at(9, 30)); !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("a cancellation was requested on an unstarted order: %v", err)
	}
}

// A cancelled order and one placed on the wrong patient are different facts.
func TestCancelledAndEnteredInErrorStayDistinct(t *testing.T) {
	cancelled := newOrder(t, baseInput(domain.TypeLaboratory))
	if err := cancelled.Submit(domain.DefaultPolicy(), "doctor-1", at(9, 1)); err != nil {
		t.Fatalf("Submit: %v", err)
	}
	if err := cancelled.Cancel("no longer needed", "doctor-1", at(9, 30)); err != nil {
		t.Fatalf("Cancel: %v", err)
	}

	retracted := newOrder(t, baseInput(domain.TypeLaboratory))
	if err := retracted.Submit(domain.DefaultPolicy(), "doctor-1", at(9, 1)); err != nil {
		t.Fatalf("Submit: %v", err)
	}
	if err := retracted.Retract("placed on the wrong patient", "doctor-1",
		at(9, 30)); err != nil {
		t.Fatalf("Retract: %v", err)
	}

	if cancelled.Status == retracted.Status {
		t.Fatal("a withdrawn order and a mistaken one have the same status")
	}
}

// Entered-in-error is reachable even from completed: the mistake is usually
// noticed afterwards, and the alternative is a false record standing.
func TestACompletedOrderCanStillBeRetracted(t *testing.T) {
	order := newOrder(t, baseInput(domain.TypeLaboratory))
	if err := order.Submit(domain.DefaultPolicy(), "doctor-1", at(9, 1)); err != nil {
		t.Fatalf("Submit: %v", err)
	}
	for _, step := range []func(string, time.Time) error{
		order.Accept, order.Start, order.Complete,
	} {
		if err := step("laboratory", at(10, 0)); err != nil {
			t.Fatalf("step: %v", err)
		}
	}
	if err := order.Retract("placed on the wrong patient", "him-1",
		at(11, 0)); err != nil {
		t.Fatalf("a completed order could not be retracted: %v", err)
	}
	if err := order.Retract("again", "him-1", at(11, 5)); err != nil {
		// Idempotent, like every other repeated transition.
		t.Fatalf("a repeated retraction failed: %v", err)
	}
}

func TestRetractingNeedsAReason(t *testing.T) {
	order := newOrder(t, baseInput(domain.TypeLaboratory))
	if err := order.Retract("", "him-1", at(11, 0)); !errors.Is(
		err, domain.ErrInvalidOrder) {
		t.Fatalf("an order was retracted with no reason: %v", err)
	}
}

// An order is placed once.
func TestAnOrderIsSubmittedOnce(t *testing.T) {
	order := newOrder(t, baseInput(domain.TypeLaboratory))
	if err := order.Submit(domain.DefaultPolicy(), "doctor-1", at(9, 1)); err != nil {
		t.Fatalf("Submit: %v", err)
	}
	if err := order.Submit(domain.DefaultPolicy(), "doctor-1", at(9, 2)); !errors.Is(
		err, domain.ErrNotAllowed) {
		t.Fatalf("an order was submitted twice: %v", err)
	}
}
