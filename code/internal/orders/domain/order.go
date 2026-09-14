// Package domain is the order context's model (SRS-ORD-001 … SRS-ORD-012).
//
// One order framework across nine order types, which is SRS-ORD-001's real
// content. Everything downstream — a laboratory, a radiology department, a
// pharmacy, a kitchen — receives an order, and if each type were its own
// aggregate then every cross-cutting rule (the state machine, the duplicate
// check, the audit trail, the event contract) would be written nine times and
// would drift eight ways. The differences between a blood test and a diet order
// are rules about one thing, not nine things.
package domain

import (
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"
)

// ErrInvalidOrder reports an order that must not be stored.
//
// A sentinel rather than a transport error: the domain does not know it is
// behind an RPC, and FIT-01 holds it to that.
var ErrInvalidOrder = errors.New("orders: invalid order")

// ErrNotAllowed reports a change the order's own state forbids.
var ErrNotAllowed = errors.New("orders: not allowed in this state")

func invalidf(format string, args ...any) error {
	return fmt.Errorf("%w: %s", ErrInvalidOrder, fmt.Sprintf(format, args...))
}

func notAllowedf(format string, args ...any) error {
	return fmt.Errorf("%w: %s", ErrNotAllowed, fmt.Sprintf(format, args...))
}

// Coding is a code and the terminology it came from.
//
// Duplicated from the clinical, encounter and nursing contexts rather than
// shared, for the reason those give: a value type common to four bounded
// contexts is a dependency that makes them one context the first time any of
// them needs to change it.
type Coding struct {
	System  string
	Version string
	Code    string
	Display string
}

// Validate rejects a coding that could not be acted on.
func (c Coding) Validate() error {
	switch {
	case strings.TrimSpace(c.System) == "":
		return invalidf("a code needs the terminology it came from")
	case strings.TrimSpace(c.Code) == "":
		return invalidf("a coding needs a code")
	case strings.TrimSpace(c.Display) == "":
		return invalidf("a coding needs a display term")
	}
	return nil
}

// Empty reports a coding nobody filled in.
func (c Coding) Empty() bool {
	return strings.TrimSpace(c.System) == "" && strings.TrimSpace(c.Code) == ""
}

// Type is what kind of order this is (SRS-ORD-001).
type Type string

const (
	TypeLaboratory   Type = "laboratory"
	TypeImaging      Type = "imaging"
	TypeMedication   Type = "medication"
	TypeProcedure    Type = "procedure"
	TypeDiet         Type = "diet"
	TypeNursing      Type = "nursing"
	TypeBloodProduct Type = "blood_product"
	TypeReferral     Type = "referral"
	TypeAlliedHealth Type = "allied_health"
)

var knownTypes = map[Type]bool{
	TypeLaboratory: true, TypeImaging: true, TypeMedication: true,
	TypeProcedure: true, TypeDiet: true, TypeNursing: true,
	TypeBloodProduct: true, TypeReferral: true, TypeAlliedHealth: true,
}

// TargetService is the bounded context that executes an order.
//
// Derived from the type rather than supplied, because a caller that could name
// its own target could route a blood-product order to the kitchen. SRS-ORD-006
// says the order is routed to its owning context; this is the routing table,
// and it is the domain's rather than the transport's so a second client cannot
// disagree with it.
func (t Type) TargetService() string {
	switch t {
	case TypeLaboratory:
		return "laboratory"
	case TypeImaging:
		return "imaging"
	case TypeMedication:
		return "pharmacy"
	case TypeBloodProduct:
		return "blood_bank"
	case TypeDiet:
		return "dietetics"
	case TypeNursing:
		return "nursing"
	case TypeProcedure:
		return "procedures"
	case TypeReferral:
		return "referrals"
	case TypeAlliedHealth:
		return "allied_health"
	}
	return ""
}

// Status is where an order stands (SRS-ORD-005).
type Status string

const (
	// StatusDraft is composed and not submitted. Not in SRS-ORD-005's list,
	// because the requirement describes the lifecycle of a *placed* order — but
	// an order set with fifteen components is assembled before any of it is
	// placed, and a half-built basket that downstream could see would be a
	// half-built basket somebody acts on.
	StatusDraft Status = "draft"
	// StatusRequested has been placed and not yet accepted by the service that
	// will perform it.
	StatusRequested Status = "requested"
	// StatusAccepted means the performing service has taken it on.
	StatusAccepted Status = "accepted"
	// StatusScheduled has a slot or a collection round.
	StatusScheduled Status = "scheduled"
	// StatusInProgress is being performed. The boundary that matters for
	// SRS-ORD-004: past this point cancellation is no longer free.
	StatusInProgress Status = "in_progress"
	StatusCompleted  Status = "completed"
	StatusCancelled  Status = "cancelled"
	// StatusEnteredInError is an order that was never true — placed on the
	// wrong patient. Distinct from cancelled, because a cancelled order was a
	// real clinical intention that was withdrawn, and counting the two together
	// would tell a quality team that clinicians change their minds when in fact
	// they are misclicking.
	StatusEnteredInError Status = "entered_in_error"
)

// transitions is SRS-ORD-005's state machine.
//
// Entered-in-error is reachable from everywhere including completed, because
// the mistake is usually noticed afterwards and the only alternative is leaving
// a false record standing.
var transitions = map[Status][]Status{
	StatusDraft:     {StatusRequested, StatusCancelled, StatusEnteredInError},
	StatusRequested: {StatusAccepted, StatusCancelled, StatusEnteredInError},
	StatusAccepted: {
		StatusScheduled, StatusInProgress, StatusCancelled, StatusEnteredInError,
	},
	StatusScheduled: {
		StatusInProgress, StatusCancelled, StatusEnteredInError,
	},
	// No path from in-progress to cancelled: a half-done order is stopped by
	// the performing service, which completes it with whatever it produced, or
	// it is corrected. See RequestCancellation.
	StatusInProgress:     {StatusCompleted, StatusEnteredInError},
	StatusCompleted:      {StatusEnteredInError},
	StatusCancelled:      {StatusEnteredInError},
	StatusEnteredInError: nil,
}

// CanTransition reports whether a status change is allowed.
func CanTransition(from, to Status) bool {
	for _, allowed := range transitions[from] {
		if allowed == to {
			return true
		}
	}
	return false
}

// Terminal reports a status from which nothing further happens.
func (s Status) Terminal() bool {
	return s == StatusCompleted || s == StatusCancelled ||
		s == StatusEnteredInError
}

// Executing reports an order the performing service has started work on.
//
// The boundary SRS-ORD-004 turns on: before it, cancelling costs nothing; after
// it, something has happened in the physical world — a specimen drawn, a unit
// of blood issued, a scan performed — and the order cannot simply be withdrawn.
func (s Status) Executing() bool {
	return s == StatusInProgress || s == StatusCompleted
}

// Priority is how urgent an order is (SRS-ORD-008).
type Priority string

const (
	PriorityRoutine Priority = "routine"
	PriorityUrgent  Priority = "urgent"
	// PriorityStat is "now". Reserved, because an escalation tier everybody
	// uses is not an escalation tier.
	PriorityStat Priority = "stat"
	// PriorityTiming is timing-critical: a dose or a sample that must be taken
	// at a particular moment rather than as fast as possible. Distinct from
	// stat, because "as soon as you can" and "at 14:00 exactly" are different
	// instructions and a laboratory that treats the second as the first
	// produces a useless trough level.
	PriorityTiming Priority = "timing_critical"
)

var knownPriorities = map[Priority]bool{
	PriorityRoutine: true, PriorityUrgent: true,
	PriorityStat: true, PriorityTiming: true,
}

// Order is one request for something to be done (SRS-ORD-001).
type Order struct {
	ID       string
	TenantID string
	// Number is the human-readable identifier a ward reads down a phone.
	Number string

	Type        Type
	PatientID   string
	EncounterID string
	FacilityID  string
	// RequesterID is who is asking. SRS-ORD-010 wants the audit to link to the
	// originating user; this is the clinical answer to "whose order is this",
	// which is not always the same person as the one who typed it.
	RequesterID string
	// EnteredByID is who typed it, where that differs — a verbal order taken by
	// a nurse. Both, because the audit answers "who keyed this" and the record
	// answers "who is answerable for it".
	EnteredByID string
	// TargetService is derived from the type at construction and stored, so a
	// routing table change does not re-route orders already in flight.
	TargetService string

	// What is being asked for.
	Code   Coding
	Detail string
	// Indication is why (SRS-ORD-007). Required for the types a tenant
	// configures as requiring one.
	Indication string
	// IndicationCode carries it as a code where the tenant has one.
	IndicationCode Coding

	Priority Priority
	Timing   Timing
	// ConditionalInstruction is "if the potassium is under 3.5" — the
	// structured condition that makes an order conditional rather than a
	// sentence in the notes (SRS-ORD-008).
	ConditionalInstruction string

	Status  Status
	History []StatusChange

	// OrderSetID and OrderSetVersion are SRS-ORD-003's provenance. Stored on
	// the order rather than looked up, because an order set edited afterwards
	// would otherwise restate what was ordered.
	OrderSetID      string
	OrderSetVersion string
	// FavouriteID records that this came from a personal favourite
	// (SRS-ORD-012). Recorded for the same reason and to answer "does the
	// consultant's favourite still match the institutional set".
	FavouriteID string

	// CancellationRequestedAt and CancellationReason hold SRS-ORD-004's
	// corrective workflow: a cancellation of an executing order is a request
	// the performing service answers, not a state change the requester makes.
	CancellationRequestedAt time.Time
	CancellationRequestedBy string
	CancellationReason      string

	// DuplicateOverride records that the requester was warned about an existing
	// order and went ahead (SRS-ORD-009).
	DuplicateOverride *DuplicateOverride

	CreatedAt time.Time
	UpdatedAt time.Time
	Version   int64
}

// StatusChange is one step in an order's life (SRS-ORD-005, SRS-ORD-010).
type StatusChange struct {
	ID   string
	From Status
	To   Status
	// By is who changed it. A downstream service is a subject like any other,
	// so an acceptance by the laboratory system names the laboratory system.
	By         string
	Reason     string
	OccurredAt time.Time
}

// DuplicateOverride is a clinician proceeding past a duplicate warning.
type DuplicateOverride struct {
	// AgainstOrderIDs are the live orders the requester was shown. Stored
	// rather than recomputed, because the existing orders usually complete
	// afterwards and a recomputing report would show every override as having
	// overridden nothing.
	AgainstOrderIDs []string
	Reason          string
	By              string
	At              time.Time
}

// Timing is when an order should happen (SRS-ORD-008).
//
// Structured rather than a sentence, because the acceptance criterion is that
// "downstream receives normalized timing" — a laboratory that has to parse
// "6 hourly starting tomorrow morning" will parse it differently from the
// pharmacy, and the two will disagree about when the patient is due.
type Timing struct {
	// StartAt is when the order takes effect. Zero means now.
	StartAt time.Time
	// EndAt bounds a repeating order. Zero means open-ended, which is valid for
	// a standing order and is why Occurrences exists to bound a query.
	EndAt time.Time
	// Frequency is how often, as a period. Zero means once.
	Frequency time.Duration
	// Count bounds a repeating order by number rather than by time: "three
	// doses" rather than "for two days".
	Count int32
	// DaysOfWeek narrows a repeat to particular days, as time.Weekday values.
	// Empty means every day.
	DaysOfWeek []time.Weekday
	// TimesOfDay pins the repeats to clock times, as minutes after midnight in
	// the facility's zone. A four-times-daily drug is given at 06:00, 12:00,
	// 18:00 and 22:00 on a ward round, not every six hours from whenever it was
	// prescribed — and the difference matters for a drug that must not be given
	// overnight.
	TimesOfDay []int32
	// PRN marks an as-needed order, which has no schedule.
	PRN bool
	// Duration is how long each occurrence runs, for an order that is not
	// instantaneous — a physiotherapy session, an infusion.
	Duration time.Duration
}

// Validate rejects timing that cannot be turned into a schedule.
func (t Timing) Validate() error {
	if t.Frequency < 0 {
		return invalidf("a frequency cannot be negative")
	}
	if t.Count < 0 {
		return invalidf("an occurrence count cannot be negative")
	}
	if !t.EndAt.IsZero() && !t.StartAt.IsZero() && !t.EndAt.After(t.StartAt) {
		return invalidf("timing cannot end before it begins")
	}
	if t.PRN && (t.Frequency > 0 || len(t.TimesOfDay) > 0) {
		// An as-needed order with a schedule is two different instructions, and
		// the ward will follow whichever one it reads first.
		return invalidf("an as-needed order cannot also have a schedule")
	}
	for _, m := range t.TimesOfDay {
		if m < 0 || m >= 24*60 {
			return invalidf("a time of day must be within a day")
		}
	}
	for _, d := range t.DaysOfWeek {
		if d < time.Sunday || d > time.Saturday {
			return invalidf("a day of week must be a real day")
		}
	}
	if t.Duration < 0 {
		return invalidf("a duration cannot be negative")
	}
	return nil
}

// Repeating reports an order that happens more than once.
func (t Timing) Repeating() bool {
	return !t.PRN && (t.Frequency > 0 || len(t.TimesOfDay) > 0)
}

// MaxOccurrences bounds what Occurrences will generate.
//
// A standing order with no end and no count would otherwise produce an
// unbounded list the first time somebody asked a wide window.
const MaxOccurrences = 500

// Occurrences expands the timing into the moments an order is due, within a
// window (SRS-ORD-008).
//
// This is the normalisation the requirement asks for: downstream receives a
// list of times rather than a rule it has to interpret. Computed rather than
// stored, because a window is a query and storing every occurrence of a
// standing order would be storing an infinite series.
//
// in is the facility's location, so "06:00" means 06:00 on the ward rather than
// 06:00 UTC. A schedule computed in UTC puts a four-times-daily drug an hour
// out twice a year, which is how a dose lands at 01:00.
func (t Timing) Occurrences(from, to time.Time, in *time.Location) []time.Time {
	if t.PRN || in == nil {
		return nil
	}

	start := t.StartAt
	if start.IsZero() {
		start = from
	}
	end := to
	if !t.EndAt.IsZero() && t.EndAt.Before(end) {
		end = t.EndAt
	}
	if !end.After(start) && !t.Repeating() {
		// A one-off outside the window.
		if start.Before(from) || !start.Before(to) {
			return nil
		}
		return []time.Time{start.UTC()}
	}

	if !t.Repeating() {
		if start.Before(from) || !start.Before(to) {
			return nil
		}
		return []time.Time{start.UTC()}
	}

	var out []time.Time
	appendIfInWindow := func(at time.Time) bool {
		if len(out) >= MaxOccurrences {
			return false
		}
		if at.Before(start) || !at.Before(end) {
			return true
		}
		if at.Before(from) || !at.Before(to) {
			return true
		}
		out = append(out, at.UTC())
		return !(t.Count > 0 && int32(len(out)) >= t.Count)
	}

	if len(t.TimesOfDay) > 0 {
		times := append([]int32(nil), t.TimesOfDay...)
		sort.Slice(times, func(i, j int) bool { return times[i] < times[j] })

		day := start.In(in)
		day = time.Date(day.Year(), day.Month(), day.Day(), 0, 0, 0, 0, in)
		for !day.After(end.In(in)) {
			if t.onDay(day.Weekday()) {
				for _, minutes := range times {
					at := day.Add(time.Duration(minutes) * time.Minute)
					if !appendIfInWindow(at) {
						return out
					}
				}
			}
			day = day.AddDate(0, 0, 1)
		}
		return out
	}

	for at := start; at.Before(end); at = at.Add(t.Frequency) {
		if !t.onDay(at.In(in).Weekday()) {
			continue
		}
		if !appendIfInWindow(at) {
			return out
		}
	}
	return out
}

func (t Timing) onDay(day time.Weekday) bool {
	if len(t.DaysOfWeek) == 0 {
		return true
	}
	for _, d := range t.DaysOfWeek {
		if d == day {
			return true
		}
	}
	return false
}

// NewOrderInput is what placing an order needs.
type NewOrderInput struct {
	Type        Type
	PatientID   string
	EncounterID string
	FacilityID  string
	RequesterID string
	EnteredByID string

	Code                   Coding
	Detail                 string
	Indication             string
	IndicationCode         Coding
	Priority               Priority
	Timing                 Timing
	ConditionalInstruction string

	OrderSetID      string
	OrderSetVersion string
	FavouriteID     string
}

// NewOrder composes an order in draft (SRS-ORD-001, SRS-ORD-002).
//
// Draft rather than requested: an order set is assembled before any of it is
// placed, and a basket downstream could see would be a basket somebody acts on.
// Submit is the separate step that applies the policy.
func NewOrder(id, tenantID, number string, in NewOrderInput, now time.Time) (
	*Order, error) {

	if !knownTypes[in.Type] {
		return nil, invalidf("unknown order type %q", in.Type)
	}
	if strings.TrimSpace(in.PatientID) == "" {
		return nil, invalidf("an order needs a patient")
	}
	if strings.TrimSpace(in.EncounterID) == "" {
		// Every order belongs to a visit. An order with no encounter cannot be
		// billed, cannot be found on the chart, and cannot be stopped when the
		// patient goes home.
		return nil, invalidf("an order needs an encounter")
	}
	if strings.TrimSpace(in.FacilityID) == "" {
		return nil, invalidf("an order needs a facility")
	}
	if strings.TrimSpace(in.RequesterID) == "" {
		return nil, invalidf("an order needs a requester")
	}
	if err := in.Code.Validate(); err != nil {
		return nil, err
	}
	priority := in.Priority
	if priority == "" {
		priority = PriorityRoutine
	}
	if !knownPriorities[priority] {
		return nil, invalidf("unknown priority %q", in.Priority)
	}
	if err := in.Timing.Validate(); err != nil {
		return nil, err
	}
	// A conditional instruction with no condition is a blank field somebody
	// will read as "no condition"; one with a condition and a stat priority is
	// a contradiction, because "do it now" and "do it if" cannot both hold.
	if strings.TrimSpace(in.ConditionalInstruction) != "" &&
		priority == PriorityStat {
		return nil, invalidf(
			"an order cannot be both immediate and conditional")
	}

	enteredBy := strings.TrimSpace(in.EnteredByID)
	if enteredBy == "" {
		enteredBy = in.RequesterID
	}

	return &Order{
		ID: id, TenantID: tenantID, Number: number,
		Type: in.Type, PatientID: in.PatientID, EncounterID: in.EncounterID,
		FacilityID: in.FacilityID, RequesterID: in.RequesterID,
		EnteredByID: enteredBy,
		// Derived, never supplied: a caller that could name its own target
		// could route a blood-product order to the kitchen.
		TargetService: in.Type.TargetService(),
		Code:          in.Code, Detail: strings.TrimSpace(in.Detail),
		Indication:     strings.TrimSpace(in.Indication),
		IndicationCode: in.IndicationCode,
		Priority:       priority, Timing: in.Timing,
		ConditionalInstruction: strings.TrimSpace(in.ConditionalInstruction),
		Status:                 StatusDraft,
		OrderSetID:             in.OrderSetID,
		OrderSetVersion:        in.OrderSetVersion,
		FavouriteID:            in.FavouriteID,
		CreatedAt:              now.UTC(), UpdatedAt: now.UTC(), Version: 1,
	}, nil
}

// Submit places a draft order (SRS-ORD-002, SRS-ORD-005).
//
// The policy is applied here rather than at construction, so a draft can be
// assembled incrementally and the rules are checked once, at the moment the
// order becomes real. A favourite or an order set goes through exactly this
// path, which is how SRS-ORD-012's "personal preferences cannot bypass
// mandatory rules" is held: there is no other way in.
func (o *Order) Submit(policy Policy, by string, now time.Time) error {
	if o.Status != StatusDraft {
		return notAllowedf("this order has already been placed")
	}
	if err := policy.Check(o); err != nil {
		return err
	}
	return o.transition(StatusRequested, by, "", now)
}

// Accept records the performing service taking the order on (SRS-ORD-005).
func (o *Order) Accept(by string, now time.Time) error {
	return o.transition(StatusAccepted, by, "", now)
}

// Schedule records a slot or a collection round.
func (o *Order) Schedule(by string, now time.Time) error {
	return o.transition(StatusScheduled, by, "", now)
}

// Start records the performing service beginning work.
func (o *Order) Start(by string, now time.Time) error {
	return o.transition(StatusInProgress, by, "", now)
}

// Complete records the order as performed.
func (o *Order) Complete(by string, now time.Time) error {
	return o.transition(StatusCompleted, by, "", now)
}

// Cancel withdraws an order that has not been executed (SRS-ORD-004).
//
// Refused once the performing service has started: something has happened in
// the physical world, and an order that disappears leaves a drawn specimen or
// an issued unit of blood attributable to nobody. See RequestCancellation.
func (o *Order) Cancel(reason, by string, now time.Time) error {
	if strings.TrimSpace(reason) == "" {
		return invalidf("cancelling an order needs a reason")
	}
	if o.Status.Executing() {
		return ErrCancellationAfterExecution{
			OrderID: o.ID, Status: o.Status,
			// Named so the caller can tell a clinician what to do instead of
			// making them discover it by trying.
			CorrectiveAction: o.correctiveAction(),
		}
	}
	return o.transition(StatusCancelled, by, reason, now)
}

// correctiveAction says what happens instead of a cancellation.
//
// SRS-ORD-004's "converted to appropriate downstream corrective workflow": the
// answer differs by type, because stopping a half-finished blood transfusion
// and stopping a half-finished physiotherapy course are not the same act.
func (o *Order) correctiveAction() string {
	switch o.Type {
	case TypeLaboratory:
		return "the specimen has been collected; ask the laboratory to cancel " +
			"the test, or let it resume and disregard the result"
	case TypeImaging:
		return "the examination has started; ask the imaging department to " +
			"abandon it"
	case TypeMedication:
		return "the medication is being administered; discontinue the order " +
			"so no further doses are scheduled"
	case TypeBloodProduct:
		return "the unit has been issued; stop the transfusion at the bedside " +
			"and return the unit to the blood bank"
	case TypeProcedure:
		return "the procedure has started; the performing team records what " +
			"was done"
	}
	return "the performing service has started; ask them to stop, and the " +
		"order will complete with whatever was done"
}

// ErrCancellationAfterExecution reports a cancellation the order's state
// forbids (SRS-ORD-004).
type ErrCancellationAfterExecution struct {
	OrderID          string
	Status           Status
	CorrectiveAction string
}

func (e ErrCancellationAfterExecution) Error() string {
	return "orders: this order is already " + string(e.Status) +
		" and cannot be cancelled: " + e.CorrectiveAction
}

// Is lets callers match with errors.Is.
func (e ErrCancellationAfterExecution) Is(target error) bool {
	_, ok := target.(ErrCancellationAfterExecution)
	return ok
}

// RequestCancellation asks the performing service to stop (SRS-ORD-004).
//
// The corrective workflow the requirement names. The order does not change
// state: a request is not an outcome, and showing it as cancelled while a
// laboratory is still running the test would tell the ward the wrong thing.
// What the service does about it — abandon, complete with what it has, report a
// partial — is the service's decision, recorded when it happens.
func (o *Order) RequestCancellation(reason, by string, now time.Time) error {
	if !o.Status.Executing() {
		return notAllowedf(
			"this order has not started; cancel it directly instead")
	}
	if o.Status == StatusCompleted {
		return notAllowedf(
			"this order is already complete; correct the result instead")
	}
	if strings.TrimSpace(reason) == "" {
		return invalidf("a cancellation request needs a reason")
	}
	if strings.TrimSpace(by) == "" {
		return invalidf("a cancellation request must record who asked")
	}
	if !o.CancellationRequestedAt.IsZero() {
		return notAllowedf("a cancellation has already been requested")
	}
	o.CancellationRequestedAt = now.UTC()
	o.CancellationRequestedBy = by
	o.CancellationReason = strings.TrimSpace(reason)
	o.UpdatedAt = now.UTC()
	o.Version++
	return nil
}

// CancellationPending reports an order whose requester has asked for it to
// stop and whose performing service has not yet answered.
func (o *Order) CancellationPending() bool {
	return !o.CancellationRequestedAt.IsZero() && !o.Status.Terminal()
}

// Retract marks an order that was never true (SRS-ORD-005).
//
// Reachable from anywhere, because an order placed on the wrong patient is
// usually noticed after it has been acted on, and the alternative is leaving a
// false record standing. Not a delete: whatever was done against it is still
// real and still has to be traceable.
func (o *Order) Retract(reason, by string, now time.Time) error {
	if strings.TrimSpace(reason) == "" {
		return invalidf("retracting an order needs a reason")
	}
	return o.transition(StatusEnteredInError, by, reason, now)
}

func (o *Order) transition(to Status, by, reason string, now time.Time) error {
	if strings.TrimSpace(by) == "" {
		return invalidf("a status change must record who made it")
	}
	if o.Status == to {
		// Idempotent: a redelivered downstream acknowledgement must not fail
		// (SRS-ORD-006).
		return nil
	}
	if !CanTransition(o.Status, to) {
		return notAllowedf("an order cannot go from %s to %s", o.Status, to)
	}
	o.History = append(o.History, StatusChange{
		From: o.Status, To: to, By: by,
		Reason: strings.TrimSpace(reason), OccurredAt: now.UTC(),
	})
	o.Status = to
	o.UpdatedAt = now.UTC()
	o.Version++
	return nil
}

// RecordDuplicateOverride notes that the requester proceeded past a warning
// (SRS-ORD-009).
func (o *Order) RecordDuplicateOverride(against []string, reason, by string,
	now time.Time) error {

	if len(against) == 0 {
		return invalidf("a duplicate override needs the orders it overrode")
	}
	if strings.TrimSpace(reason) == "" {
		return invalidf("proceeding past a duplicate warning needs a reason")
	}
	if strings.TrimSpace(by) == "" {
		return invalidf("a duplicate override must record who decided")
	}
	o.DuplicateOverride = &DuplicateOverride{
		AgainstOrderIDs: append([]string(nil), against...),
		Reason:          strings.TrimSpace(reason),
		By:              by, At: now.UTC(),
	}
	o.UpdatedAt = now.UTC()
	o.Version++
	return nil
}

// Live reports an order that is still expected to happen.
//
// The set the duplicate check looks at: a completed order is not a duplicate of
// a new one, because the patient may well need the test again.
func (o *Order) Live() bool { return !o.Status.Terminal() }
