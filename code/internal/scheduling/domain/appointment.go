package domain

import (
	"errors"
	"fmt"
	"strings"
	"time"
)

// The appointment and its lifecycle (SRS-SCH-004, SRS-SCH-005, SRS-SCH-008).
//
// SRS-SCH-008 names nine states and requires invalid transitions to be rejected
// "unless authorized correction". That last clause is the interesting one: a
// state machine with no escape hatch gets worked around, and the workaround is
// always worse than the hole. A clerk who marked the wrong patient as a no-show
// will otherwise cancel the real appointment and book a new one, which destroys
// the chronology the record existed to keep. So corrections are permitted,
// named as corrections, and carry a reason.

// ErrInvalidAppointment reports an appointment that must not be stored.
var ErrInvalidAppointment = errors.New("scheduling: invalid appointment")

// Status is where an appointment sits in its life (SRS-SCH-008).
type Status string

const (
	StatusScheduled        Status = "scheduled"
	StatusArrived          Status = "arrived"
	StatusTriaged          Status = "triaged"
	StatusWaitingClinician Status = "waiting_clinician"
	StatusInConsultation   Status = "in_consultation"
	StatusPostConsultation Status = "post_consultation"
	StatusCompleted        Status = "completed"
	StatusNoShow           Status = "no_show"
	StatusCancelled        Status = "cancelled"
)

var knownStatuses = map[Status]bool{
	StatusScheduled: true, StatusArrived: true, StatusTriaged: true,
	StatusWaitingClinician: true, StatusInConsultation: true,
	StatusPostConsultation: true, StatusCompleted: true,
	StatusNoShow: true, StatusCancelled: true,
}

// transitions is the permitted graph.
//
// Deliberately not a total order. Triage is skipped in an outpatient clinic and
// mandatory in an emergency department; a patient can leave before being seen;
// a consultation can be re-entered because the clinician stepped out for a
// result. Each edge below is a thing that happens, and the ones absent are the
// ones that do not.
var transitions = map[Status][]Status{
	StatusScheduled: {StatusArrived, StatusNoShow, StatusCancelled},
	// Triage is optional: an outpatient clinic goes straight to waiting.
	StatusArrived: {StatusTriaged, StatusWaitingClinician, StatusCancelled},
	StatusTriaged: {StatusWaitingClinician, StatusCancelled},
	// Cancelled from waiting: patients leave before being seen, and recording
	// that as a no-show would be wrong — they came.
	StatusWaitingClinician: {StatusInConsultation, StatusCancelled},
	// Back to waiting: the clinician stepped out for a result and the patient
	// returns to the queue rather than losing their place.
	StatusInConsultation:   {StatusPostConsultation, StatusWaitingClinician, StatusCompleted},
	StatusPostConsultation: {StatusCompleted, StatusInConsultation},
	// Terminal. Reached only by correction, which is a different act.
	StatusCompleted: nil,
	StatusNoShow:    nil,
	StatusCancelled: nil,
}

// Terminal reports a status from which there is no ordinary transition.
func (s Status) Terminal() bool {
	next, known := transitions[s]
	return known && len(next) == 0
}

// CanTransitionTo reports whether an ordinary transition is permitted.
func (s Status) CanTransitionTo(next Status) bool {
	for _, allowed := range transitions[s] {
		if allowed == next {
			return true
		}
	}
	return false
}

// ErrInvalidTransition reports a status change the machine refuses.
type ErrInvalidTransition struct {
	From, To Status
}

func (e ErrInvalidTransition) Error() string {
	return fmt.Sprintf("scheduling: an appointment cannot go from %s to %s", e.From, e.To)
}

// StatusChange is one entry in an appointment's history.
//
// SRS-SCH-005 requires the original appointment to retain its status history,
// and the reason is a question somebody asks months later: a patient disputing
// a missed-appointment fee needs the record to show when they were marked a
// no-show and by whom.
type StatusChange struct {
	From Status
	To   Status
	At   time.Time
	By   string
	// Reason is required for anything that costs the patient something —
	// cancellation, no-show — and for every correction.
	Reason string
	// Corrected marks a transition the machine would otherwise refuse, made
	// under the authorised-correction clause of SRS-SCH-008.
	Corrected bool
}

// Appointment is one booking.
type Appointment struct {
	// id is unexported for the same reason the patient's is: it is the key
	// every downstream record points at, and a field anybody can assign is a
	// field somebody eventually reassigns.
	id         string
	TenantID   string
	FacilityID string
	ResourceID string
	OrgUnitID  string
	PatientID  string
	VisitType  VisitType
	VisitMode  VisitMode

	StartsAt time.Time
	EndsAt   time.Time
	// SlotID is the capacity row this booking consumes. Kept on the
	// appointment so a cancellation can give the unit back without having to
	// re-derive which slot the roster would put it in today.
	SlotID string

	Status  Status
	History []StatusChange

	// BookedBy is the subject who made the booking — a clerk, or the patient
	// through a portal.
	BookedBy string
	// Reason is why the patient is coming, as stated at booking. Short and
	// non-clinical: a diagnosis belongs in the encounter, not the diary, which
	// far more people can see.
	Reason string

	// RescheduledFromID chains an appointment to the one it replaced, so the
	// chronology survives a reschedule (SRS-SCH-005).
	RescheduledFromID string
	// SeriesID groups a recurring therapy series (SRS-SCH-013).
	SeriesID string
	// Occurrence is this appointment's position in its series, from 1.
	Occurrence int
	// RescheduleCount is how many times this booking has been moved. Carried
	// forward across the chain, because a policy capping reschedules is about
	// the patient rather than about any one row.
	RescheduleCount int
	// JoinURL is where a teleconsult happens (SRS-SCH-015). Empty for an
	// in-person appointment: one carrying a link invites a patient to stay home.
	JoinURL string

	// The queue (SRS-SCH-007 … SRS-SCH-011). All zero until the patient
	// arrives: a booking is not a queue entry, and a diary full of tokens for
	// people who have not turned up is a board nobody can read.

	// Token is what the patient is called by. Not the appointment id: that is a
	// UUID nobody can read out across a noisy waiting room.
	Token       string
	ArrivalMode ArrivalMode
	CheckedInAt *time.Time
	Priority    Priority
	// PriorityReason is shown to queue users, not buried in an audit table:
	// the people waiting can see that somebody went ahead of them, and a board
	// that shows the move without the reason produces the argument the reason
	// exists to prevent (SRS-SCH-011).
	PriorityReason string

	CreatedAt time.Time
	UpdatedAt time.Time
	Version   int64
}

// ID returns the immutable identifier.
func (a *Appointment) ID() string { return a.id }

// RestoreAppointment rebuilds an appointment from storage.
//
// The only way to set the id outside this package, and it takes it separately
// so a caller cannot set it by assigning a struct field.
func RestoreAppointment(id string, a Appointment) *Appointment {
	a.id = id
	return &a
}

// MaxReasonLength bounds the stated reason. Long enough for a sentence, short
// enough that a referral letter cannot be pasted into the diary.
const MaxReasonLength = 300

// NewAppointment validates and constructs a booking.
func NewAppointment(id, tenantID, patientID string, slot Slot, bookedBy, reason string,
	now time.Time) (*Appointment, error) {

	reason = strings.TrimSpace(reason)

	switch {
	case strings.TrimSpace(id) == "":
		return nil, fmt.Errorf("%w: appointment id is required", ErrInvalidAppointment)
	case strings.TrimSpace(tenantID) == "":
		return nil, fmt.Errorf("%w: an appointment needs a tenant", ErrInvalidAppointment)
	case strings.TrimSpace(patientID) == "":
		return nil, fmt.Errorf("%w: an appointment needs a patient", ErrInvalidAppointment)
	case strings.TrimSpace(bookedBy) == "":
		return nil, fmt.Errorf("%w: an appointment must record who booked it",
			ErrInvalidAppointment)
	case slot.StartsAt.IsZero() || !slot.EndsAt.After(slot.StartsAt):
		return nil, fmt.Errorf("%w: the slot has no usable period", ErrInvalidAppointment)
	case len(reason) > MaxReasonLength:
		return nil, fmt.Errorf("%w: the stated reason is longer than %d characters",
			ErrInvalidAppointment, MaxReasonLength)
	}

	return &Appointment{
		id: id, TenantID: tenantID, FacilityID: slot.FacilityID,
		ResourceID: slot.ResourceID, OrgUnitID: slot.OrgUnitID,
		PatientID: patientID, VisitType: slot.VisitType, VisitMode: slot.VisitMode,
		StartsAt: slot.StartsAt.UTC(), EndsAt: slot.EndsAt.UTC(),
		Status:   StatusScheduled,
		BookedBy: bookedBy, Reason: reason,
		History: []StatusChange{{
			To: StatusScheduled, At: now.UTC(), By: bookedBy, Reason: "booked",
		}},
		CreatedAt: now.UTC(), UpdatedAt: now.UTC(), Version: 1,
	}, nil
}

// Transition moves the appointment to a new status.
//
// correction permits an edge the machine would otherwise refuse, under the
// "unless authorized correction" clause of SRS-SCH-008. It is never implicit:
// a caller that meant an ordinary transition and got a correction would be
// silently writing history it did not intend.
func (a *Appointment) Transition(to Status, by, reason string, correction bool,
	now time.Time) error {

	if !knownStatuses[to] {
		return fmt.Errorf("%w: unknown status %q", ErrInvalidAppointment, to)
	}
	if strings.TrimSpace(by) == "" {
		return fmt.Errorf("%w: a status change must record who made it", ErrInvalidAppointment)
	}
	if to == a.Status {
		// Idempotent rather than an error: a double-tapped check-in button
		// should not produce a failure a clerk has to interpret.
		return nil
	}

	if !a.Status.CanTransitionTo(to) {
		if !correction {
			return ErrInvalidTransition{From: a.Status, To: to}
		}
		if strings.TrimSpace(reason) == "" {
			// A correction with no reason is indistinguishable from the mistake
			// it is correcting.
			return fmt.Errorf("%w: a corrected status change needs a reason",
				ErrInvalidAppointment)
		}
	}

	if requiresReason(to) && strings.TrimSpace(reason) == "" {
		// Cancellation and no-show can cost the patient money and follow them
		// into a clinic's attendance record.
		return fmt.Errorf("%w: moving to %s needs a reason", ErrInvalidAppointment, to)
	}

	a.History = append(a.History, StatusChange{
		From: a.Status, To: to, At: now.UTC(), By: by,
		Reason: strings.TrimSpace(reason), Corrected: correction && !a.Status.CanTransitionTo(to),
	})
	a.Status = to
	a.UpdatedAt = now.UTC()
	return nil
}

func requiresReason(s Status) bool {
	return s == StatusCancelled || s == StatusNoShow
}

// Active reports an appointment that still occupies its slot.
//
// Cancelled and no-show do not: a cancelled appointment releases capacity, and
// a no-show does not because the slot was consumed — the patient simply did not
// come. Getting that backwards either double-books the clinic or leaves a
// morning of phantom bookings nobody can fill.
func (a *Appointment) Active() bool {
	return a.Status != StatusCancelled
}

// Occupies reports whether the appointment still consumes slot capacity.
func (a *Appointment) Occupies() bool { return a.Status != StatusCancelled }
