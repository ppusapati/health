package escalation

import (
	"errors"
	"fmt"
	"strings"
	"time"
)

// ErrInvalidMatrix is a configuration that could not be walked.
var ErrInvalidMatrix = errors.New("invalid escalation matrix")

// ErrInvalidNotice is a notice that could not be raised or advanced.
var ErrInvalidNotice = errors.New("invalid escalation notice")

// State is where a notice is.
//
// The three the requirement names, and no fourth. "Sent" is deliberately not a
// state: a notice that has been delivered and not acknowledged is still
// pending, and calling it something else is how a chain stops advancing while
// looking healthy.
type State string

const (
	// StatePending has been raised and not yet acknowledged. It escalates.
	StatePending State = "pending"
	// StateAcknowledged means a human said they have it. The chain stops.
	StateAcknowledged State = "acknowledged"
	// StateClosed means the notice stopped mattering without anybody
	// acknowledging it — the patient was discharged, the result was
	// superseded, the alarm cleared. Distinct from acknowledged because "we
	// told somebody and they took it" and "it stopped being relevant" are
	// different facts, and only the first is evidence of anything.
	StateClosed State = "closed"
	// StateExhausted has run out of rungs while still unacknowledged. Terminal
	// as far as this mechanism goes, and the loudest thing it can say: the
	// hospital's own escalation chain has been walked to the top and nobody
	// answered.
	StateExhausted State = "exhausted"
)

// Open reports whether a notice still needs somebody.
func (s State) Open() bool { return s == StatePending }

// Terminal reports whether a state can still change.
func (s State) Terminal() bool {
	return s == StateAcknowledged || s == StateClosed || s == StateExhausted
}

var knownStates = map[State]bool{
	StatePending: true, StateAcknowledged: true,
	StateClosed: true, StateExhausted: true,
}

// Policy is the timing of a chain.
//
// The same shape as clinical's EscalationPolicy, which it does not import:
// that one is a Wave-1 clinical rule about critical results, and this is a
// platform mechanism seven Wave-2 families share. Coupling them would make a
// medical-gas alarm's timing a clinical decision.
type Policy struct {
	// After is how long a notice may sit at a rung before the next one.
	After time.Duration
	// Then is the interval between subsequent rungs. Zero repeats After.
	Then time.Duration
	// MaxLevel bounds the chain independently of the matrix, so a tenant can
	// stop short of the top rung without editing the matrix. Zero means the
	// matrix's own top.
	MaxLevel int
}

// DefaultPolicy escalates after fifteen minutes, then every fifteen.
//
// Fifteen because that is roughly how long a laboratory spends trying to reach
// somebody by phone before it becomes their problem, and because a policy
// measured in hours has already failed for a potassium of 7. The figure
// matches Wave-1 clinical's default deliberately: a hospital that has tuned one
// and not the other should find them agreeing, not diverging.
func DefaultPolicy() Policy {
	return Policy{After: 15 * time.Minute, Then: 15 * time.Minute}
}

// Validate rejects a policy that could not be applied.
func (p Policy) Validate() error {
	switch {
	case p.After <= 0:
		return fmt.Errorf("%w: an escalation policy needs a delay", ErrInvalidMatrix)
	case p.Then < 0:
		return fmt.Errorf("%w: an escalation interval cannot be negative", ErrInvalidMatrix)
	case p.MaxLevel < 0:
		return fmt.Errorf("%w: a maximum level cannot be negative", ErrInvalidMatrix)
	}
	return nil
}

// interval is how long level sits before the next escalation.
func (p Policy) interval(level int) time.Duration {
	if level == 0 || p.Then <= 0 {
		return p.After
	}
	return p.Then
}

// Subject is what a notice is about.
//
// Kind and ID together are the idempotency key. Raising the same notice twice
// -- which happens whenever a retry, a replay or a restart re-runs the code
// that raised it -- must produce one notice, not two escalation chains racing
// each other to the same consultant.
type Subject struct {
	// Kind matches the matrix's kind.
	Kind string
	// ID is the thing in the owning context: an observation id, a work-order
	// id, a case id.
	ID string
	// PatientID is set when a notice is about a patient, so a recipient can be
	// shown who it concerns without reaching into the owning context. Empty
	// for a medical-gas alarm, which is about a building.
	PatientID string
	// FacilityID selects the matrix.
	FacilityID string
}

// Validate rejects a subject nothing could be raised about.
func (s Subject) Validate() error {
	switch {
	case strings.TrimSpace(s.Kind) == "":
		return fmt.Errorf("%w: a notice needs a kind", ErrInvalidNotice)
	case strings.TrimSpace(s.ID) == "":
		return fmt.Errorf("%w: a notice needs a subject id", ErrInvalidNotice)
	}
	return nil
}

// Key is the idempotency key for a subject.
func (s Subject) Key() string { return s.Kind + ":" + s.ID }

// Delivery is one attempt to tell somebody.
//
// Recorded whether or not it worked. A chain that only recorded its successes
// could not answer the question an incident review actually asks, which is why
// the third rung was reached.
type Delivery struct {
	Level     int
	Recipient Recipient
	At        time.Time
	// Channel is how it was delivered -- "task", "sms". The in-platform task
	// inbox is the only one Wave 2 has; outbound channels arrive with
	// SRS-PAT-ENG.
	Channel string
	// Err is why it did not go, empty when it did. A failed delivery does not
	// stop the chain: the next rung is the remedy for a recipient who cannot
	// be reached, and stopping would leave the notice with nobody.
	Err string
}

// Delivered reports whether the attempt succeeded.
func (d Delivery) Delivered() bool { return strings.TrimSpace(d.Err) == "" }

// Notice is a clinical notification that persists until it is answered.
type Notice struct {
	ID       string
	TenantID string
	Subject  Subject
	// Summary is what the recipient reads. Composed by the raising context,
	// because only it knows what the notice means.
	Summary string
	State   State
	// Level is the rung most recently told.
	Level int
	// RaisedAt starts the first interval.
	RaisedAt time.Time
	// LastEscalatedAt starts each subsequent one. Equal to RaisedAt until the
	// first escalation.
	LastEscalatedAt time.Time
	// AcknowledgedBy and AcknowledgedAt record who took it.
	AcknowledgedBy string
	AcknowledgedAt time.Time
	// ClosedReason explains a close. Required, because a notice closed without
	// one is indistinguishable from one that was quietly dropped.
	ClosedReason string
	Deliveries   []Delivery
	UpdatedAt    time.Time
}

// Raise creates a notice at level zero.
//
// It is not delivered here. Raising happens inside the transaction that made
// the thing worth escalating -- a critical result, a failed crossmatch -- and
// delivery happens after that transaction commits, for the same reason the
// outbox exists: a notice delivered for a transaction that then rolled back is
// a consultant woken for something that did not happen.
func Raise(id, tenantID string, subject Subject, summary string, now time.Time) (Notice, error) {
	if strings.TrimSpace(id) == "" {
		return Notice{}, fmt.Errorf("%w: a notice needs an id", ErrInvalidNotice)
	}
	if err := subject.Validate(); err != nil {
		return Notice{}, err
	}
	if strings.TrimSpace(summary) == "" {
		// A notice whose summary is empty arrives on a consultant's phone as a
		// row with a timestamp and nothing to act on.
		return Notice{}, fmt.Errorf("%w: a notice needs a summary", ErrInvalidNotice)
	}

	return Notice{
		ID: id, TenantID: tenantID, Subject: subject,
		Summary: strings.TrimSpace(summary),
		State:   StatePending, Level: 0,
		RaisedAt: now.UTC(), LastEscalatedAt: now.UTC(), UpdatedAt: now.UTC(),
	}, nil
}

// DueAt is when this notice next escalates.
//
// Zero and false once it is terminal, which is what stops a driver from
// picking up an acknowledged notice forever.
func (n Notice) DueAt(policy Policy) (time.Time, bool) {
	if !n.State.Open() || policy.After <= 0 {
		return time.Time{}, false
	}
	return n.LastEscalatedAt.Add(policy.interval(n.Level)), true
}

// Due reports whether this notice should escalate by an instant.
func (n Notice) Due(policy Policy, at time.Time) bool {
	due, ok := n.DueAt(policy)
	return ok && !at.Before(due)
}

// Acknowledge records that a human has it, and stops the chain.
//
// Anyone may acknowledge, not only the recipient the chain reached. A registrar
// who sees a colleague's alert and deals with it has dealt with it, and a
// mechanism that refused their acknowledgement would keep escalating something
// already in hand -- which is how people learn to ignore escalations.
func (n *Notice) Acknowledge(by string, at time.Time) error {
	if strings.TrimSpace(by) == "" {
		return fmt.Errorf("%w: an acknowledgement names who made it", ErrInvalidNotice)
	}
	switch n.State {
	case StateAcknowledged:
		// Idempotent rather than an error: two people pressing the button at
		// once is not a mistake, and the first one is the record.
		return nil
	case StateClosed:
		return fmt.Errorf("%w: this notice was closed, not acknowledged", ErrInvalidNotice)
	}

	n.State = StateAcknowledged
	n.AcknowledgedBy = strings.TrimSpace(by)
	n.AcknowledgedAt = at.UTC()
	n.UpdatedAt = at.UTC()
	return nil
}

// Close stops a notice that stopped mattering.
func (n *Notice) Close(reason string, at time.Time) error {
	if strings.TrimSpace(reason) == "" {
		return fmt.Errorf("%w: closing a notice needs a reason", ErrInvalidNotice)
	}
	if n.State == StateAcknowledged {
		// Closing an acknowledged notice would erase the acknowledgement,
		// which is the only evidence that anybody took it.
		return fmt.Errorf("%w: this notice was already acknowledged", ErrInvalidNotice)
	}

	n.State = StateClosed
	n.ClosedReason = strings.TrimSpace(reason)
	n.UpdatedAt = at.UTC()
	return nil
}

// Escalate advances to the next rung and records what was told.
//
// The caller supplies the deliveries because delivery is I/O and this is not.
// Passing them in also makes the failure case explicit: a rung where every
// delivery failed still advances, because the remedy for a recipient who
// cannot be reached is the next rung rather than a retry against a phone that
// is switched off.
func (n *Notice) Escalate(matrix Matrix, policy Policy, at time.Time) ([]Recipient, int, error) {
	if !n.State.Open() {
		return nil, 0, fmt.Errorf("%w: a %s notice does not escalate", ErrInvalidNotice, n.State)
	}

	next := n.Level + 1
	ceiling := policy.MaxLevel
	if ceiling == 0 {
		ceiling = matrix.Top()
	}
	if next > ceiling {
		n.State = StateExhausted
		n.UpdatedAt = at.UTC()
		return nil, 0, nil
	}

	recipients, level, ok := matrix.At(next)
	if !ok {
		n.State = StateExhausted
		n.UpdatedAt = at.UTC()
		return nil, 0, nil
	}

	// The level actually reached, which a gap in the matrix makes different
	// from the one asked for.
	n.Level = level
	n.LastEscalatedAt = at.UTC()
	n.UpdatedAt = at.UTC()
	return recipients, level, nil
}

// Record appends a delivery attempt.
func (n *Notice) Record(delivery Delivery) {
	n.Deliveries = append(n.Deliveries, delivery)
}

// Reached reports whether anybody was successfully told, at any level.
//
// The question an incident review asks first, and the one a chain of failed
// deliveries answers no to while looking busy.
func (n Notice) Reached() bool {
	for _, delivery := range n.Deliveries {
		if delivery.Delivered() {
			return true
		}
	}
	return false
}

// KnownState reports whether a stored state string is one this build handles.
func KnownState(raw string) bool { return knownStates[State(raw)] }
