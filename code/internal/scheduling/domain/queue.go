package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Check-in, the queue and waiting times (SRS-SCH-007 … SRS-SCH-011).
//
// The queue is the part of scheduling patients actually experience. Everything
// before it is arrangement; this is the hour they spend in a room wondering
// whether they have been forgotten.
//
// Two rules shape the design. Clinical priority is a clinical judgement, made
// by a clinician, with a reason — never a side effect of arithmetic. And an
// estimate is an estimate: a waiting time presented as a promise becomes a
// complaint, and one that quietly reorders the queue becomes a safety incident.

// ArrivalMode is how the patient got here (SRS-SCH-007).
//
// Recorded because it changes what happens next: somebody brought in by
// ambulance is not joining the back of the queue, and a remote patient is not
// in the waiting room at all.
type ArrivalMode string

const (
	ArrivalWalkIn     ArrivalMode = "walk_in"
	ArrivalScheduled  ArrivalMode = "scheduled"
	ArrivalAmbulance  ArrivalMode = "ambulance"
	ArrivalReferral   ArrivalMode = "referral"
	ArrivalTelehealth ArrivalMode = "telehealth"
)

var knownArrivalModes = map[ArrivalMode]bool{
	ArrivalWalkIn: true, ArrivalScheduled: true, ArrivalAmbulance: true,
	ArrivalReferral: true, ArrivalTelehealth: true,
}

// Priority is where a patient sits in the queue (SRS-SCH-010, SRS-SCH-011).
//
// Deliberately coarse. A five-band scale is what triage systems use and what
// staff can hold in their heads; a numeric score invites arithmetic, and
// arithmetic on clinical urgency is how somebody ends up behind a spreadsheet.
type Priority string

const (
	// PriorityImmediate cannot wait. Resuscitation.
	PriorityImmediate  Priority = "immediate"
	PriorityVeryUrgent Priority = "very_urgent"
	PriorityUrgent     Priority = "urgent"
	// PriorityStandard is the default and most of the list.
	PriorityStandard  Priority = "standard"
	PriorityNonUrgent Priority = "non_urgent"
)

var priorityRank = map[Priority]int{
	PriorityImmediate: 0, PriorityVeryUrgent: 1, PriorityUrgent: 2,
	PriorityStandard: 3, PriorityNonUrgent: 4,
}

// Rank orders priorities, lower being more urgent.
func (p Priority) Rank() int {
	rank, known := priorityRank[p]
	if !known {
		// An unknown priority sorts last rather than first. A typo must not
		// promote somebody to the front of a queue.
		return len(priorityRank)
	}
	return rank
}

// Known reports a priority this system recognises.
func (p Priority) Known() bool {
	_, ok := priorityRank[p]
	return ok
}

// CheckIn is the moment a patient arrives (SRS-SCH-007).
type CheckIn struct {
	// Token is what the patient is called by — printed on a slip, shown on a
	// board. Not the appointment id: that is a UUID nobody can read out, and a
	// waiting room needs something a person can hear across a noisy space.
	Token       string
	ArrivalMode ArrivalMode
	At          time.Time
	By          string
	Priority    Priority
	// PriorityReason is required whenever the priority is not the default.
	// SRS-SCH-011 requires a reason for reprioritisation; the same applies at
	// the door, because a walk-in put straight to the front without one is
	// indistinguishable from queue-jumping.
	PriorityReason string
}

// MaxTokenLength bounds a queue token. Short enough to read out and print.
const MaxTokenLength = 16

// Validate rejects a check-in that could not be used.
func (c CheckIn) Validate() error {
	switch {
	case strings.TrimSpace(c.Token) == "":
		return fmt.Errorf("%w: a check-in needs a token the patient can be called by",
			ErrInvalidAppointment)
	case len(c.Token) > MaxTokenLength:
		return fmt.Errorf("%w: a token longer than %d characters cannot be printed or read out",
			ErrInvalidAppointment, MaxTokenLength)
	case !knownArrivalModes[c.ArrivalMode]:
		return fmt.Errorf("%w: unknown arrival mode %q", ErrInvalidAppointment, c.ArrivalMode)
	case strings.TrimSpace(c.By) == "":
		return fmt.Errorf("%w: a check-in must record who did it", ErrInvalidAppointment)
	case !c.Priority.Known():
		return fmt.Errorf("%w: unknown priority %q", ErrInvalidAppointment, c.Priority)
	case c.Priority != PriorityStandard && strings.TrimSpace(c.PriorityReason) == "":
		// A patient put ahead of the queue without a stated reason is
		// indistinguishable from queue-jumping, and the people waiting can see
		// the board.
		return fmt.Errorf("%w: a priority other than standard needs a reason",
			ErrInvalidAppointment)
	}
	return nil
}

// CheckIn records arrival and moves the appointment into the queue
// (SRS-SCH-007).
func (a *Appointment) CheckIn(c CheckIn, now time.Time) error {
	if err := c.Validate(); err != nil {
		return err
	}
	if a.Status != StatusScheduled {
		// Checking in twice, or checking in something already cancelled, is a
		// clerk clicking the wrong row.
		return ErrInvalidTransition{From: a.Status, To: StatusArrived}
	}

	if err := a.Transition(StatusArrived, c.By, "arrived: "+string(c.ArrivalMode),
		false, now); err != nil {
		return err
	}

	at := c.At
	if at.IsZero() {
		at = now
	}
	a.Token = c.Token
	a.ArrivalMode = c.ArrivalMode
	a.CheckedInAt = &at
	a.Priority = c.Priority
	a.PriorityReason = c.PriorityReason
	return nil
}

// Reprioritise changes a patient's place in the queue (SRS-SCH-011).
//
// The reason is mandatory and is shown to queue users, not buried in an audit
// table. The requirement says "audited and visible to queue users", and the
// second half is the one that matters at the desk: the people waiting can see
// that somebody went ahead of them, and a board that shows the move without the
// reason produces the argument the reason exists to prevent.
func (a *Appointment) Reprioritise(to Priority, by, reason string, now time.Time) error {
	switch {
	case !to.Known():
		return fmt.Errorf("%w: unknown priority %q", ErrInvalidAppointment, to)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a reprioritisation must record who made it",
			ErrInvalidAppointment)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: reprioritising needs a medical reason", ErrInvalidAppointment)
	case a.CheckedInAt == nil:
		// Nobody is in the queue until they have arrived. Reprioritising a
		// future booking is rearranging a diary, which is a reschedule.
		return fmt.Errorf("%w: this patient has not checked in", ErrInvalidAppointment)
	case a.Status.Terminal():
		return fmt.Errorf("%w: appointment %s is %s", ErrInvalidAppointment, a.id, a.Status)
	}

	a.Priority = to
	a.PriorityReason = reason
	a.UpdatedAt = now.UTC()
	return nil
}

// Waiting reports whether a patient is in the queue and has not been seen.
func (a *Appointment) Waiting() bool {
	switch a.Status {
	case StatusArrived, StatusTriaged, StatusWaitingClinician:
		return true
	default:
		return false
	}
}

// QueuePosition is one patient's place in a queue.
type QueuePosition struct {
	Appointment *Appointment
	// Position from 1, in the order patients will actually be called.
	Position int
	// EstimatedWait is how long this patient is likely to wait. An estimate,
	// and labelled as one everywhere it appears (SRS-SCH-009).
	EstimatedWait time.Duration
}

// QueueEstimate is the arithmetic behind a waiting time (SRS-SCH-009).
//
// Kept alongside the estimate so a UI can say *why* — "about forty minutes,
// based on four patients ahead and ten minutes each" is something a person can
// judge; "about forty minutes" is something they can only believe or disbelieve.
type QueueEstimate struct {
	// Ahead is how many patients are in front of this one.
	Ahead int
	// ServiceMinutes is the observed average this session, falling back to the
	// rostered slot length when too little has happened to observe anything.
	ServiceMinutes float64
	// Observed reports that the service rate came from consultations actually
	// completed today, rather than from the roster. A UI should be more
	// tentative about the second.
	Observed bool
	// ActiveClinicians divides the queue. Two clinicians running a list halve
	// the wait, and an estimate that ignored them would be wrong by a factor of
	// two on exactly the busiest days.
	ActiveClinicians int
}

// DefaultServiceMinutes is the fallback when nothing has been observed.
//
// Fifteen minutes is the commonest outpatient slot. Deliberately a constant
// rather than zero: an estimate of "no wait" for a queue of nine people is
// worse than a rough one.
const DefaultServiceMinutes = 15.0

// Wait computes the estimated wait for a patient with n people ahead.
func (e QueueEstimate) Wait() time.Duration {
	clinicians := e.ActiveClinicians
	if clinicians < 1 {
		clinicians = 1
	}
	service := e.ServiceMinutes
	if service <= 0 {
		service = DefaultServiceMinutes
	}
	minutes := float64(e.Ahead) * service / float64(clinicians)
	return time.Duration(minutes * float64(time.Minute))
}

// BuildQueue orders a clinic's waiting patients and estimates their waits.
//
// The order is priority first, then arrival. Arrival rather than appointment
// time on purpose: somebody who turned up on time for a 09:00 slot has been
// waiting since 09:00, and a queue ordered by booking time would keep putting
// late arrivals in front of them.
//
// The estimate never changes the order. SRS-SCH-009 is explicit — the estimate
// "updates without changing clinical priority" — and a queue that reordered
// itself to make its own predictions come true would be optimising the wrong
// thing.
func BuildQueue(appointments []*Appointment, estimate QueueEstimate) []QueuePosition {
	waiting := make([]*Appointment, 0, len(appointments))
	for _, a := range appointments {
		if a.Waiting() {
			waiting = append(waiting, a)
		}
	}

	sort.SliceStable(waiting, func(i, j int) bool {
		left, right := waiting[i], waiting[j]
		if left.Priority.Rank() != right.Priority.Rank() {
			return left.Priority.Rank() < right.Priority.Rank()
		}
		// Both checked in, by definition of Waiting.
		return left.CheckedInAt.Before(*right.CheckedInAt)
	})

	out := make([]QueuePosition, 0, len(waiting))
	for i, a := range waiting {
		ahead := estimate
		ahead.Ahead = i
		out = append(out, QueuePosition{
			Appointment: a, Position: i + 1, EstimatedWait: ahead.Wait(),
		})
	}
	return out
}

// ObserveServiceRate measures how long consultations are actually taking.
//
// From the status history rather than from the roster: a clinic running twenty
// minutes behind is running twenty minutes behind whatever the diary says, and
// an estimate built on the roster would tell every patient the clinic is on
// time right up until they are called an hour late.
//
// Returns Observed false when too few consultations have finished to mean
// anything. Three is the threshold: one is an anecdote and two is a coincidence.
func ObserveServiceRate(appointments []*Appointment) QueueEstimate {
	const minimumObservations = 3

	var total time.Duration
	var observations int

	for _, a := range appointments {
		var startedAt time.Time
		for _, change := range a.History {
			switch change.To {
			case StatusInConsultation:
				if startedAt.IsZero() {
					startedAt = change.At
				}
			case StatusPostConsultation, StatusCompleted:
				if !startedAt.IsZero() && change.At.After(startedAt) {
					total += change.At.Sub(startedAt)
					observations++
					startedAt = time.Time{}
				}
			}
		}
	}

	if observations < minimumObservations {
		return QueueEstimate{
			ServiceMinutes: DefaultServiceMinutes, Observed: false, ActiveClinicians: 1,
		}
	}
	return QueueEstimate{
		ServiceMinutes:   total.Minutes() / float64(observations),
		Observed:         true,
		ActiveClinicians: 1,
	}
}

// NewWalkIn creates an appointment for somebody who arrived without one
// (SRS-SCH-010).
//
// A walk-in holds no rostered slot: by definition nobody set time aside. It
// still becomes an ordinary appointment, because the acceptance criterion is
// that a walk-in is "linked to same encounter creation flow" — a parallel
// lightweight record would be a second thing every downstream context has to
// know about, and the first one to forget would drop walk-ins from a report.
func NewWalkIn(id, tenantID, facilityID, resourceID, orgUnitID, patientID string,
	c CheckIn, reason string, now time.Time) (*Appointment, error) {

	if err := c.Validate(); err != nil {
		return nil, err
	}
	if strings.TrimSpace(patientID) == "" {
		return nil, fmt.Errorf("%w: a walk-in needs a patient", ErrInvalidAppointment)
	}
	if strings.TrimSpace(reason) == "" {
		// SRS-SCH-010 asks for a reason. Without one nobody triaging the queue
		// knows why this person is here, which is the first thing they need.
		return nil, fmt.Errorf("%w: a walk-in needs a stated reason", ErrInvalidAppointment)
	}
	if len(reason) > MaxReasonLength {
		return nil, fmt.Errorf("%w: the stated reason is longer than %d characters",
			ErrInvalidAppointment, MaxReasonLength)
	}

	at := c.At
	if at.IsZero() {
		at = now
	}

	a := &Appointment{
		id: id, TenantID: tenantID, FacilityID: facilityID,
		ResourceID: resourceID, OrgUnitID: orgUnitID, PatientID: patientID,
		VisitType: VisitWalkIn, VisitMode: ModeInPerson,
		// The appointment is "now": a walk-in is not booked for a time, they
		// are here. Giving it a zero start would put it at the epoch in every
		// clinic list.
		StartsAt: at.UTC(), EndsAt: at.Add(DefaultServiceMinutes * time.Minute).UTC(),
		Status:   StatusArrived,
		BookedBy: c.By, Reason: strings.TrimSpace(reason),
		Token: c.Token, ArrivalMode: c.ArrivalMode, CheckedInAt: &at,
		Priority: c.Priority, PriorityReason: c.PriorityReason,
		History: []StatusChange{{
			To: StatusArrived, At: at.UTC(), By: c.By,
			Reason: "walk-in: " + string(c.ArrivalMode),
		}},
		CreatedAt: now.UTC(), UpdatedAt: now.UTC(), Version: 1,
	}
	return a, nil
}
