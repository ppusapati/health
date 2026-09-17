package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// The resuscitation timeline and the clocks derived from it
// (SRS-ER-005, SRS-ER-006, SRS-ER-008, SRS-ER-009).

// EventKind is what happened.
//
// A closed set, unlike the arrival location, because these are what the
// door-to-X clocks and the pathway milestones are computed from — and a clock
// derived from a free-text string is a clock that stops working the first time
// somebody types "Dr seen" instead of "doctor seen".
type EventKind string

const (
	EventArrival EventKind = "arrival"
	EventTriage  EventKind = "triage"
	// EventClinicianSeen is the end of door-to-doctor. Recorded when a
	// clinician takes the patient, not when one is assigned: an assignment is
	// a rota entry and the patient cannot tell the difference.
	EventClinicianSeen EventKind = "clinician_seen"
	// EventPathwayActivated starts a time-critical pathway (SRS-ER-005).
	EventPathwayActivated EventKind = "pathway_activated"
	// EventMilestone is a pathway step — "CT scanner", "thrombolysis given".
	EventMilestone EventKind = "milestone"

	// The resuscitation record (SRS-ER-008).
	EventAirway         EventKind = "airway"
	EventCPR            EventKind = "cpr"
	EventDefibrillation EventKind = "defibrillation"
	EventFluid          EventKind = "fluid"
	EventDrug           EventKind = "drug"
	EventProcedure      EventKind = "procedure"
	EventObservation    EventKind = "observation"

	EventDisposition EventKind = "disposition"
	// EventUnknown is a stored kind this build cannot read. Kept and shown
	// rather than dropped: an event nobody can classify still happened, and a
	// timeline with a silent hole is worse than one with a question mark.
	EventUnknown EventKind = "unknown"
)

var knownEventKinds = map[EventKind]bool{
	EventArrival: true, EventTriage: true, EventClinicianSeen: true,
	EventPathwayActivated: true, EventMilestone: true,
	EventAirway: true, EventCPR: true, EventDefibrillation: true,
	EventFluid: true, EventDrug: true, EventProcedure: true,
	EventObservation: true, EventDisposition: true, EventUnknown: true,
}

// KnownEventKind reports whether a stored value is one this build handles.
func KnownEventKind(raw string) bool { return knownEventKinds[EventKind(raw)] }

// LateEntryAfter is how long after the fact an entry counts as written up
// rather than recorded.
//
// Five minutes. Short, because in a resuscitation the difference between
// "recorded as it happened" and "remembered afterwards" is the difference
// between a timeline and a reconstruction, and the reviewer needs to know
// which they are reading. A nurse scribing live is inside it; a doctor writing
// up at the end of the arrest is not.
const LateEntryAfter = 5 * time.Minute

// Event is one thing that happened, on the timeline (SRS-ER-008).
type Event struct {
	ID       string
	TenantID string
	VisitID  string

	Kind EventKind
	// Detail is what was done — "300J synchronised", "adrenaline 1mg IV". Free
	// text on purpose: a resuscitation record that only accepted coded entries
	// would be a resuscitation record with things missing from it.
	Detail string

	// OccurredAt is when it happened to the patient. What the timeline sorts
	// on, and what a reviewer reads.
	OccurredAt time.Time
	// RecordedAt is when somebody typed it. Separate, always, because the gap
	// between them is the only thing that distinguishes a contemporaneous
	// record from a reconstruction.
	RecordedAt time.Time
	// Sequence breaks ties among events at the same instant. A defibrillation
	// and the rhythm check before it are frequently recorded at the same
	// minute, and their order is the clinically interesting part.
	Sequence int

	ActorID string
	// Late is derived at construction and stored, so a reader does not have to
	// recompute a rule that may have changed since.
	Late bool

	// PathwayID links a milestone to its activation.
	PathwayID string
	// ProtocolID names the standing order a pre-order administration was given
	// under (SRS-ER-009).
	ProtocolID string
	// NeedsReconciliation marks a drug given before the order existed. The
	// obligation SRS-ER-009 trades for letting treatment go first.
	NeedsReconciliation bool
	// ReconciledOrderID is the order written afterwards, which discharges it.
	ReconciledOrderID string
}

// NewEventInput is one timeline entry.
type NewEventInput struct {
	VisitID    string
	Kind       EventKind
	Detail     string
	OccurredAt time.Time
	Sequence   int
	PathwayID  string
	// ProtocolID and PreOrder together describe a drug given under a standing
	// order before the order was written.
	ProtocolID string
	PreOrder   bool
}

// NewEvent records one thing that happened.
func NewEvent(id, tenantID string, in NewEventInput, actorID string, now time.Time) (
	Event, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.VisitID) == "":
		return Event{}, fmt.Errorf("%w: an event belongs to a visit", ErrInvalidVisit)
	case strings.TrimSpace(actorID) == "":
		// "Events preserve sequence and actor" is the criterion. An anonymous
		// entry in a resuscitation record is one nobody can be asked about.
		return Event{}, fmt.Errorf("%w: an event names who recorded it", ErrInvalidVisit)
	case !knownEventKinds[in.Kind] || in.Kind == EventUnknown:
		return Event{}, fmt.Errorf("%w: unknown event kind %q", ErrInvalidVisit, in.Kind)
	case strings.TrimSpace(in.Detail) == "":
		return Event{}, fmt.Errorf("%w: an event says what was done", ErrInvalidVisit)
	}

	occurred := in.OccurredAt
	if occurred.IsZero() {
		occurred = now
	}
	if occurred.After(now.Add(time.Minute)) {
		return Event{}, fmt.Errorf("%w: an event cannot have happened in the future",
			ErrInvalidVisit)
	}

	// A drug given before the order exists is allowed only under a named
	// protocol (SRS-ER-009: "only under configured protocol"). Without one it
	// is an unordered administration, which is the thing the requirement is
	// carving an exception out of rather than the exception itself.
	if in.PreOrder && strings.TrimSpace(in.ProtocolID) == "" {
		return Event{}, fmt.Errorf(
			"%w: giving a medication before the order needs the protocol it was given "+
				"under", ErrInvalidVisit)
	}

	return Event{
		ID: id, TenantID: tenantID, VisitID: strings.TrimSpace(in.VisitID),
		Kind: in.Kind, Detail: strings.TrimSpace(in.Detail),
		OccurredAt: occurred.UTC(), RecordedAt: now.UTC(),
		Sequence: in.Sequence, ActorID: actorID,
		Late:                now.Sub(occurred) > LateEntryAfter,
		PathwayID:           strings.TrimSpace(in.PathwayID),
		ProtocolID:          strings.TrimSpace(in.ProtocolID),
		NeedsReconciliation: in.PreOrder,
	}, nil
}

// Reconcile discharges a pre-order administration against the order written
// afterwards (SRS-ER-009).
func (e *Event) Reconcile(orderID string) error {
	if !e.NeedsReconciliation {
		return fmt.Errorf("%w: this event was not given ahead of an order",
			ErrInvalidVisit)
	}
	if strings.TrimSpace(orderID) == "" {
		return fmt.Errorf("%w: reconciling names the order", ErrInvalidVisit)
	}
	if e.ReconciledOrderID != "" {
		return fmt.Errorf("%w: this administration is already reconciled", ErrInvalidVisit)
	}
	e.ReconciledOrderID = strings.TrimSpace(orderID)
	return nil
}

// Outstanding reports an administration still owed an order.
func (e Event) Outstanding() bool {
	return e.NeedsReconciliation && strings.TrimSpace(e.ReconciledOrderID) == ""
}

// Timeline is a visit's events.
type Timeline []Event

// Ordered sorts a timeline as a reviewer reads it (SRS-ER-008).
//
// By when things happened, not by when they were typed. A resuscitation
// written up afterwards arrives out of order and must still read in order —
// that is the whole reason OccurredAt and RecordedAt are separate fields.
func (t Timeline) Ordered() Timeline {
	out := append(Timeline(nil), t...)
	sort.SliceStable(out, func(i, j int) bool {
		if !out[i].OccurredAt.Equal(out[j].OccurredAt) {
			return out[i].OccurredAt.Before(out[j].OccurredAt)
		}
		return out[i].Sequence < out[j].Sequence
	})
	return out
}

// First finds the earliest event of a kind.
func (t Timeline) First(kind EventKind) (Event, bool) {
	var found Event
	ok := false
	for _, event := range t {
		if event.Kind != kind {
			continue
		}
		if !ok || event.OccurredAt.Before(found.OccurredAt) {
			found, ok = event, true
		}
	}
	return found, ok
}

// Unreconciled lists the administrations still owed an order (SRS-ER-009).
//
// The department's debt, and the reason a protocol administration is a
// tolerable shortcut rather than a hole: "no silent stock/clinical gap" is the
// criterion, and this is what makes it not silent.
func (t Timeline) Unreconciled() Timeline {
	var out Timeline
	for _, event := range t {
		if event.Outstanding() {
			out = append(out, event)
		}
	}
	return out
}

// Intervals are the clocks SRS-ER-006 asks for.
//
// Every field is a pointer, and nil means "has not happened yet" rather than
// zero. A door-to-doctor of nought because nobody has seen the patient is the
// number that makes a dashboard look best while the department is at its
// worst.
type Intervals struct {
	DoorToTriage    *time.Duration
	DoorToClinician *time.Duration
	// DoorToDisposition is the department's own length of stay, which is not
	// the same as the patient's: the patient is still there until a bed is
	// found.
	DoorToDisposition *time.Duration
}

// Clocks derives the intervals from the timeline (SRS-ER-006).
//
// Derived, never stored. "Operational dashboard derives times from immutable
// events" is the criterion, and the reason behind it is that a stored interval
// is a number somebody can be asked to improve without anything happening to a
// patient.
func (t Timeline) Clocks() Intervals {
	arrival, ok := t.First(EventArrival)
	if !ok {
		return Intervals{}
	}

	var out Intervals
	if triage, found := t.First(EventTriage); found {
		d := triage.OccurredAt.Sub(arrival.OccurredAt)
		out.DoorToTriage = &d
	}
	if seen, found := t.First(EventClinicianSeen); found {
		d := seen.OccurredAt.Sub(arrival.OccurredAt)
		out.DoorToClinician = &d
	}
	if disposed, found := t.First(EventDisposition); found {
		d := disposed.OccurredAt.Sub(arrival.OccurredAt)
		out.DoorToDisposition = &d
	}
	return out
}

// LateEntries lists the events written up after the fact.
func (t Timeline) LateEntries() Timeline {
	var out Timeline
	for _, event := range t {
		if event.Late {
			out = append(out, event)
		}
	}
	return out
}
