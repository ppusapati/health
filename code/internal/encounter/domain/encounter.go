// Package domain holds the encounter rules: what a visit is, when it starts and
// ends, who was on the care team and what was concluded.
//
// The bounded context is "encounter" (Master Engineering Registry). It owns the
// container a clinical episode happens inside; it does not own the clinical
// content. A note, an observation, a problem and an allergy belong to SRS-CLN,
// and the seam between them is a reference to an encounter id rather than a
// shared table.
//
// The distinction that matters most here is the one SRS-ENC-003 makes: an
// appointment and an encounter are different things. An appointment is a plan.
// An encounter is what happened. A patient can be seen without an appointment,
// an appointment can be kept without a consultation ever starting, and a
// consultation can run long past the slot it was booked into. Systems that
// conflate the two cannot answer "when was this patient actually seen", which
// is the question every audit and every billing dispute turns on.
package domain

import (
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"
)

// ErrInvalidEncounter reports an encounter that must not be stored.
var ErrInvalidEncounter = errors.New("encounter: invalid encounter")

// Class is the kind of visit (SRS-ENC-002).
//
// One model with a class rather than seven models. The requirement is explicit
// that "class-specific rules derive from common encounter model", and the
// reason is that everything downstream — orders, results, notes, billing —
// attaches to an encounter and would otherwise have to know about seven of
// them. The differences between an outpatient visit and an admission are real,
// but they are rules about one thing, not seven things.
type Class string

const (
	ClassOutpatient Class = "outpatient"
	// ClassEmergency is the one whose rules bend: it may be started for a
	// patient nobody has identified yet, and it may be finalised over an
	// incomplete record under the override SRS-ENC-008 allows.
	ClassEmergency Class = "emergency"
	// ClassInpatient spans days and beds. Its start and end are an admission
	// and a discharge, not a consultation.
	ClassInpatient Class = "inpatient"
	ClassDayCare   Class = "day_care"
	// ClassTelemedicine happens remotely. Recorded distinctly because a remote
	// consultation has different consent, identification and prescribing rules
	// in most jurisdictions, and a report that could not separate them could
	// not answer a regulator.
	ClassTelemedicine Class = "telemedicine"
	ClassHomeCare     Class = "home_care"
	// ClassDiagnosticOnly is a visit for a test with no consultation — a walk-in
	// for an X-ray. It exists because the alternative is a result with no
	// encounter to hang from, and results without context are how the wrong
	// patient's film gets reported.
	ClassDiagnosticOnly Class = "diagnostic_only"
)

var knownClasses = map[Class]bool{
	ClassOutpatient: true, ClassEmergency: true, ClassInpatient: true,
	ClassDayCare: true, ClassTelemedicine: true, ClassHomeCare: true,
	ClassDiagnosticOnly: true,
}

// Known reports a class this system recognises.
func (c Class) Known() bool { return knownClasses[c] }

// RequiresAttendingProvider reports classes that cannot proceed without a named
// responsible clinician.
//
// A diagnostic-only visit legitimately has none: nobody is consulting, and
// inventing an attending clinician for a walk-in X-ray would put a name against
// a decision that person never made.
func (c Class) RequiresAttendingProvider() bool {
	return c != ClassDiagnosticOnly
}

// Status is where an encounter sits in its life (SRS-ENC-006).
type Status string

const (
	// StatusPlanned is created but not begun. An encounter can exist before it
	// starts: a scheduled admission is planned days ahead.
	StatusPlanned    Status = "planned"
	StatusInProgress Status = "in_progress"
	// StatusOnLeave is an inpatient temporarily absent — home for a weekend,
	// away for a scan at another site. Distinct from discharged because the bed
	// is still theirs.
	StatusOnLeave Status = "on_leave"
	// StatusFinished is clinically complete but not yet closed: documentation
	// may still be outstanding.
	StatusFinished Status = "finished"
	// StatusClosed is finished and documented, with a visit summary generated.
	// Later changes are amendments (SRS-ENC-009).
	StatusClosed Status = "closed"
	// StatusCancelled is an encounter that never happened.
	StatusCancelled Status = "cancelled"
	// StatusEnteredInError is an encounter that should never have existed —
	// opened against the wrong patient, most often. Distinct from cancelled
	// because they mean opposite things to a report: a cancelled visit is a
	// visit that did not take place, and an entered-in-error one is a record
	// that was never true. Counting them together would tell a quality team
	// that patients are cancelling when in fact clerks are misclicking
	// (SRS-ENC-006).
	StatusEnteredInError Status = "entered_in_error"
)

var knownStatuses = map[Status]bool{
	StatusPlanned: true, StatusInProgress: true, StatusOnLeave: true,
	StatusFinished: true, StatusClosed: true, StatusCancelled: true,
	StatusEnteredInError: true,
}

// transitions is the permitted graph.
//
// Entered-in-error is reachable from everywhere including closed, because the
// mistake it describes — this encounter is against the wrong patient — is
// usually noticed after the fact, and the only alternative is leaving a false
// record standing.
var transitions = map[Status][]Status{
	StatusPlanned:    {StatusInProgress, StatusCancelled, StatusEnteredInError},
	StatusInProgress: {StatusOnLeave, StatusFinished, StatusCancelled, StatusEnteredInError},
	// Back to in-progress: the patient returned from leave.
	StatusOnLeave: {StatusInProgress, StatusFinished, StatusEnteredInError},
	// Back to in-progress: the patient deteriorated before they left, or the
	// clinician had more to do. Cheaper than a second encounter, and truer.
	StatusFinished:       {StatusClosed, StatusInProgress, StatusEnteredInError},
	StatusClosed:         {StatusEnteredInError},
	StatusCancelled:      {StatusEnteredInError},
	StatusEnteredInError: nil,
}

// Terminal reports a status from which there is no transition at all.
func (s Status) Terminal() bool {
	next, known := transitions[s]
	return known && len(next) == 0
}

// CanTransitionTo reports whether a status change is permitted.
func (s Status) CanTransitionTo(next Status) bool {
	for _, allowed := range transitions[s] {
		if allowed == next {
			return true
		}
	}
	return false
}

// Open reports an encounter that clinical content may still be written to.
func (s Status) Open() bool {
	return s == StatusPlanned || s == StatusInProgress || s == StatusOnLeave ||
		s == StatusFinished
}

// ErrInvalidTransition reports a status change the machine refuses.
type ErrInvalidTransition struct{ From, To Status }

func (e ErrInvalidTransition) Error() string {
	return fmt.Sprintf("encounter: an encounter cannot go from %s to %s", e.From, e.To)
}

// StatusChange is one entry in an encounter's history.
type StatusChange struct {
	From, To Status
	At       time.Time
	By       string
	// Reason is required for cancellation, entered-in-error and any change made
	// after closure. Those are the ones somebody asks about later.
	Reason string
}

// MaxReasonLength bounds free text held on the encounter itself.
//
// The encounter carries a reason for the visit, not the history. A referral
// letter pasted into this field would be clinical content living outside the
// clinical record's access rules.
const MaxReasonLength = 500

// Encounter is one episode of contact between a patient and the service.
type Encounter struct {
	// id is unexported: it is the key every clinical record points at, and a
	// field anybody can assign is a field somebody eventually reassigns.
	id         string
	TenantID   string
	FacilityID string
	// OrgUnitID is the ward, clinic or department. Nullable: a home-care visit
	// belongs to no unit.
	OrgUnitID string
	PatientID string
	Class     Class
	// VisitType mirrors scheduling's (new, follow-up, procedure…). Carried so
	// a clinical report does not have to join back to an appointment that may
	// not exist.
	VisitType string
	// AttendingProviderID is the clinician responsible for this encounter. One,
	// not many: the care team holds everybody else (SRS-ENC-005), and a record
	// where responsibility is diffuse is one where nobody holds it.
	AttendingProviderID string
	// AppointmentID links the plan to what happened, when there was a plan.
	// Empty for a walk-in, and empty is not an error: SRS-ENC-003 requires the
	// two to be separately auditable.
	AppointmentID string
	// EpisodeID groups this encounter into a course of treatment
	// (SRS-ENC-004).
	EpisodeID string
	// ReferralID names the external request this visit answers (SRS-ENC-010).
	ReferralID string
	// Reason is why the patient came, in the words recorded at the door.
	Reason string

	Status Status
	// StartedAt and EndedAt are clinical times, independent of the appointment
	// (SRS-ENC-003). Zero until the encounter begins and ends.
	StartedAt time.Time
	EndedAt   time.Time
	// ClosedAt is when the record was closed and the summary generated.
	ClosedAt time.Time

	History []StatusChange

	CreatedBy string
	CreatedAt time.Time
	UpdatedAt time.Time
	Version   int64
}

// ID returns the immutable identifier.
func (e *Encounter) ID() string { return e.id }

// RestoreEncounter rebuilds an encounter from storage.
func RestoreEncounter(id string, e Encounter) *Encounter {
	e.id = id
	return &e
}

// NewEncounter validates and constructs an encounter (SRS-ENC-001).
func NewEncounter(id, tenantID string, in NewEncounterInput, createdBy string,
	now time.Time) (*Encounter, error) {

	reason := strings.TrimSpace(in.Reason)

	switch {
	case strings.TrimSpace(id) == "":
		return nil, fmt.Errorf("%w: encounter id is required", ErrInvalidEncounter)
	case strings.TrimSpace(tenantID) == "":
		return nil, fmt.Errorf("%w: an encounter needs a tenant", ErrInvalidEncounter)
	case strings.TrimSpace(in.PatientID) == "":
		return nil, fmt.Errorf("%w: an encounter needs a patient", ErrInvalidEncounter)
	case strings.TrimSpace(in.FacilityID) == "":
		return nil, fmt.Errorf("%w: an encounter needs a facility", ErrInvalidEncounter)
	case !in.Class.Known():
		return nil, fmt.Errorf("%w: unknown encounter class %q", ErrInvalidEncounter, in.Class)
	case in.Class.RequiresAttendingProvider() &&
		strings.TrimSpace(in.AttendingProviderID) == "":
		// Somebody must be answerable for a consultation. A visit with no named
		// clinician is one where, six months later, nobody can say who decided.
		return nil, fmt.Errorf("%w: a %s encounter needs an attending provider",
			ErrInvalidEncounter, in.Class)
	case strings.TrimSpace(createdBy) == "":
		return nil, fmt.Errorf("%w: an encounter must record who opened it",
			ErrInvalidEncounter)
	case len(reason) > MaxReasonLength:
		return nil, fmt.Errorf("%w: the stated reason is longer than %d characters",
			ErrInvalidEncounter, MaxReasonLength)
	}

	return &Encounter{
		id: id, TenantID: tenantID, FacilityID: in.FacilityID,
		OrgUnitID: in.OrgUnitID, PatientID: in.PatientID, Class: in.Class,
		VisitType: in.VisitType, AttendingProviderID: in.AttendingProviderID,
		AppointmentID: in.AppointmentID, EpisodeID: in.EpisodeID,
		ReferralID: in.ReferralID, Reason: reason,
		Status: StatusPlanned,
		History: []StatusChange{{
			To: StatusPlanned, At: now.UTC(), By: createdBy, Reason: "opened",
		}},
		CreatedBy: createdBy, CreatedAt: now.UTC(), UpdatedAt: now.UTC(), Version: 1,
	}, nil
}

// NewEncounterInput is what opening an encounter needs.
type NewEncounterInput struct {
	PatientID           string
	FacilityID          string
	OrgUnitID           string
	Class               Class
	VisitType           string
	AttendingProviderID string
	AppointmentID       string
	EpisodeID           string
	ReferralID          string
	Reason              string
}

// Start begins the clinical encounter (SRS-ENC-003).
//
// The time is the clinical one and is recorded separately from the appointment,
// which may be hours earlier or may not exist. `at` is passed rather than taken
// from the clock so a late entry can record when the patient was actually seen
// rather than when somebody got to a keyboard.
func (e *Encounter) Start(at time.Time, by string, now time.Time) error {
	if err := e.transition(StatusInProgress, by, "", now); err != nil {
		return err
	}
	if at.IsZero() {
		at = now
	}
	if at.After(now) {
		// An encounter that started in the future is a typo, and it would sort
		// to the end of every chronological view for as long as it stood.
		return fmt.Errorf("%w: an encounter cannot start in the future", ErrInvalidEncounter)
	}
	e.StartedAt = at.UTC()
	return nil
}

// End finishes the clinical encounter, leaving documentation outstanding.
func (e *Encounter) End(at time.Time, by string, now time.Time) error {
	if e.StartedAt.IsZero() {
		return fmt.Errorf("%w: an encounter that never started cannot end",
			ErrInvalidEncounter)
	}
	if at.IsZero() {
		at = now
	}
	if at.Before(e.StartedAt) {
		return fmt.Errorf("%w: an encounter cannot end before it started",
			ErrInvalidEncounter)
	}
	if err := e.transition(StatusFinished, by, "", now); err != nil {
		return err
	}
	e.EndedAt = at.UTC()
	return nil
}

// Cancel records an encounter that did not happen.
func (e *Encounter) Cancel(by, reason string, now time.Time) error {
	if strings.TrimSpace(reason) == "" {
		return fmt.Errorf("%w: cancelling an encounter needs a reason", ErrInvalidEncounter)
	}
	return e.transition(StatusCancelled, by, reason, now)
}

// MarkEnteredInError records an encounter that should never have existed.
//
// Not a delete. The clinical content written against it — notes, results,
// administrations — is still real and still has to be traceable; what changes
// is that the encounter no longer asserts this patient was seen. Deleting it
// would orphan every record that points at it, and orphaned clinical records
// are how a result ends up attributed to nobody.
func (e *Encounter) MarkEnteredInError(by, reason string, now time.Time) error {
	if strings.TrimSpace(reason) == "" {
		return fmt.Errorf("%w: marking an encounter entered-in-error needs a reason",
			ErrInvalidEncounter)
	}
	return e.transition(StatusEnteredInError, by, reason, now)
}

// Close finalises the encounter (SRS-ENC-009).
//
// Guarded by the caller, which must first establish that mandatory
// documentation is complete or that an override was authorised (SRS-ENC-008).
// The domain enforces the chronology: after this, the record is amended rather
// than edited.
func (e *Encounter) Close(by string, now time.Time) error {
	if e.EndedAt.IsZero() {
		return fmt.Errorf("%w: an encounter that has not ended cannot be closed",
			ErrInvalidEncounter)
	}
	if err := e.transition(StatusClosed, by, "", now); err != nil {
		return err
	}
	e.ClosedAt = now.UTC()
	return nil
}

// Reopen returns a finished encounter to in-progress.
//
// Permitted from finished and not from closed: before closure nothing has been
// summarised and no chronology has been asserted, so continuing is simply
// continuing. After closure a visit summary exists and has probably been sent
// somewhere, and rewriting behind it is what SRS-ENC-009 forbids.
func (e *Encounter) Reopen(by, reason string, now time.Time) error {
	if e.Status == StatusClosed {
		return fmt.Errorf(
			"%w: a closed encounter is amended, not reopened; its summary has already been issued",
			ErrInvalidEncounter)
	}
	if strings.TrimSpace(reason) == "" {
		return fmt.Errorf("%w: reopening an encounter needs a reason", ErrInvalidEncounter)
	}
	return e.transition(StatusInProgress, by, reason, now)
}

// GoOnLeave records an inpatient temporarily away.
func (e *Encounter) GoOnLeave(by, reason string, now time.Time) error {
	if e.Class != ClassInpatient {
		// Leave is a bed concept. An outpatient who walks out has not gone on
		// leave; they have left.
		return fmt.Errorf("%w: only an inpatient encounter can go on leave",
			ErrInvalidEncounter)
	}
	return e.transition(StatusOnLeave, by, reason, now)
}

// transition applies a status change and appends to the history.
func (e *Encounter) transition(to Status, by, reason string, now time.Time) error {
	if !knownStatuses[to] {
		return fmt.Errorf("%w: unknown status %q", ErrInvalidEncounter, to)
	}
	if strings.TrimSpace(by) == "" {
		return fmt.Errorf("%w: a status change must record who made it", ErrInvalidEncounter)
	}
	if to == e.Status {
		// Idempotent: a double-tapped button on a ward terminal should not
		// produce a failure somebody has to interpret.
		return nil
	}
	if !e.Status.CanTransitionTo(to) {
		return ErrInvalidTransition{From: e.Status, To: to}
	}

	e.History = append(e.History, StatusChange{
		From: e.Status, To: to, At: now.UTC(), By: by,
		Reason: strings.TrimSpace(reason),
	})
	e.Status = to
	e.UpdatedAt = now.UTC()
	return nil
}

// AcceptsClinicalContent reports whether new clinical records may be written
// against this encounter.
//
// Closed is excluded: after closure the route is an amendment, which carries
// its own trail. Cancelled and entered-in-error are excluded because they
// assert the visit did not happen or was never true, and writing a note into
// one produces a record that contradicts its own container.
func (e *Encounter) AcceptsClinicalContent() bool { return e.Status.Open() }

// Duration is how long the encounter ran, and whether it is known.
func (e *Encounter) Duration() (time.Duration, bool) {
	if e.StartedAt.IsZero() || e.EndedAt.IsZero() {
		return 0, false
	}
	return e.EndedAt.Sub(e.StartedAt), true
}

// SortEncounters orders encounters newest first, which is how every clinical
// view shows them: the question is almost always "what happened recently".
func SortEncounters(in []*Encounter) {
	sort.SliceStable(in, func(i, j int) bool {
		left, right := in[i].effectiveTime(), in[j].effectiveTime()
		if !left.Equal(right) {
			return left.After(right)
		}
		return in[i].ID() < in[j].ID()
	})
}

// effectiveTime is when an encounter happened, falling back through the times
// that exist. A planned encounter has no start, and sorting it to the epoch
// would bury next week's admission at the bottom of the list.
func (e *Encounter) effectiveTime() time.Time {
	if !e.StartedAt.IsZero() {
		return e.StartedAt
	}
	return e.CreatedAt
}
