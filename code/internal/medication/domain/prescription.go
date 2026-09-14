// Package domain is the medication context's model (SRS-MED-001 … SRS-MED-014).
//
// A prescription is not a second kind of order. The order context already owns
// what every request to a service has in common — identity, a number, routing,
// a lifecycle, an audit trail and an event contract — and SRS-ORD-001 names
// medication as one of its nine types. What this context owns is everything a
// prescription has that a chest X-ray does not: dose segments that taper, an
// allergy and interaction screen with the rule version that produced it, a
// pharmacist's verification, a substitution that must not overwrite what was
// prescribed, a formulary position, and a therapy that can be held and
// restarted without the supply request changing at all.
//
// That last distinction is the one worth stating plainly, because it is why
// there are two statuses in play and they are not a duplication. The *order*
// status answers "where has this request got to with the pharmacy". The
// *therapy* status answers "is the patient on this drug right now". A drug held
// for a procedure is a therapy that has stopped and a supply request that has
// not; a course dispensed in full on Monday is a supply request that is
// finished and a therapy that runs until Friday. A single status would have to
// lie about one of the two, and the one it lies about is the one the ward acts
// on.
package domain

import (
	"errors"
	"fmt"
	"sort"
	"strconv"
	"strings"
	"time"
)

// ErrInvalidPrescription reports a prescription that must not be stored.
//
// A sentinel rather than a transport error: the domain does not know it is
// behind an RPC, and FIT-01 holds it to that.
var ErrInvalidPrescription = errors.New("medication: invalid prescription")

// ErrNotAllowed reports a change the prescription's own state forbids.
var ErrNotAllowed = errors.New("medication: not allowed in this state")

func invalidf(format string, args ...any) error {
	return fmt.Errorf("%w: %s", ErrInvalidPrescription, fmt.Sprintf(format, args...))
}

func notAllowedf(format string, args ...any) error {
	return fmt.Errorf("%w: %s", ErrNotAllowed, fmt.Sprintf(format, args...))
}

// Coding is a code and the terminology it came from.
//
// Duplicated from the clinical, encounter, nursing and order contexts rather
// than shared, for the reason those give: a value type common to five bounded
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

// Key identifies a coding for comparison, ignoring the display term.
func (c Coding) Key() string {
	return strings.ToLower(strings.TrimSpace(c.System)) + "|" +
		strings.ToLower(strings.TrimSpace(c.Code))
}

// Quantity is a measured value with its unit.
//
// Inseparable, for the reason the clinical context gives: the number alone has
// eventually been rendered under the wrong label by every system that stored it
// that way. A dose is the sharpest case of it — "5" is a safe dose of one drug
// and ten times a lethal dose of another.
type Quantity struct {
	Value float64
	Unit  string
}

// Zero reports a quantity nobody filled in.
func (q Quantity) Zero() bool {
	return q.Value == 0 && strings.TrimSpace(q.Unit) == ""
}

// Validate rejects a dose that could not be given.
func (q Quantity) Validate() error {
	switch {
	case strings.TrimSpace(q.Unit) == "":
		return invalidf("a dose needs a unit")
	case q.Value <= 0:
		// Zero is not a dose, and a negative one is a data-entry slip that has
		// no meaning a nurse could act on.
		return invalidf("a dose must be greater than zero")
	}
	return nil
}

// String renders a dose for a human.
func (q Quantity) String() string {
	return fmt.Sprintf("%s %s", trimFloat(q.Value), strings.TrimSpace(q.Unit))
}

func trimFloat(v float64) string {
	s := strconv.FormatFloat(v, 'f', -1, 64)
	return s
}

// TherapyStatus is whether the patient is on this drug (SRS-MED-013).
//
// Deliberately not the order status. See the package comment: a drug held for a
// procedure is a therapy that has stopped and a supply request that has not.
type TherapyStatus string

const (
	// TherapyDraft is composed and not yet prescribed. Nothing downstream can
	// see it.
	TherapyDraft TherapyStatus = "draft"
	// TherapyActive is a live therapy. It produces doses.
	TherapyActive TherapyStatus = "active"
	// TherapyHeld is suspended and expected to resume — nil by mouth before
	// theatre, an anticoagulant paused around a procedure. Distinct from
	// discontinued because the intention is different and the ward acts on the
	// difference: a held drug is one somebody must remember to restart.
	TherapyHeld TherapyStatus = "held"
	// TherapyDiscontinued is stopped and not expected to resume.
	TherapyDiscontinued TherapyStatus = "discontinued"
	// TherapyCompleted is a course that ran to its end.
	TherapyCompleted TherapyStatus = "completed"
)

var knownTherapyStatuses = map[TherapyStatus]bool{
	TherapyDraft: true, TherapyActive: true, TherapyHeld: true,
	TherapyDiscontinued: true, TherapyCompleted: true,
}

// Final reports a status no further doses can follow.
func (s TherapyStatus) Final() bool {
	return s == TherapyDiscontinued || s == TherapyCompleted
}

// therapyTransitions is the therapy lifecycle (SRS-MED-013).
//
// A held therapy may be discontinued without being restarted first: the
// commonest reason a drug is held is that somebody is deciding whether to stop
// it, and forcing a restart in order to stop would put a dose on the ward's
// worklist that nobody intends to give.
var therapyTransitions = map[TherapyStatus][]TherapyStatus{
	TherapyDraft:  {TherapyActive, TherapyDiscontinued},
	TherapyActive: {TherapyHeld, TherapyDiscontinued, TherapyCompleted},
	TherapyHeld:   {TherapyActive, TherapyDiscontinued, TherapyCompleted},

	TherapyDiscontinued: nil,
	TherapyCompleted:    nil,
}

// CanBecome reports whether one therapy status may follow another.
func (s TherapyStatus) CanBecome(next TherapyStatus) bool {
	for _, allowed := range therapyTransitions[s] {
		if allowed == next {
			return true
		}
	}
	return false
}

// StopConditionKind is how a course ends (SRS-MED-001).
type StopConditionKind string

const (
	// StopAtTime ends the course at a known moment.
	StopAtTime StopConditionKind = "at_time"
	// StopAfterDoses ends it after a count — "five days of antibiotics" is
	// really "ten doses", and expressing it as a date gets it wrong whenever a
	// dose is missed.
	StopAfterDoses StopConditionKind = "after_doses"
	// StopOnCondition is a clinical condition in words: "until afebrile for 48
	// hours". Free text on purpose, because the alternative is an enumeration
	// that never covers the case in front of the clinician — but it is a
	// *named* stop condition rather than a sentence buried in the instructions,
	// so a pharmacist reviewing long-stay prescriptions can find every course
	// whose end nobody can compute.
	StopOnCondition StopConditionKind = "on_condition"
	// StopNone is a continuing medication with no planned end — a
	// antihypertensive. Explicit rather than absent, because "nobody said" and
	// "this is meant to continue" are different facts and only one of them is a
	// prescribing error.
	StopNone StopConditionKind = "none"
)

var knownStopKinds = map[StopConditionKind]bool{
	StopAtTime: true, StopAfterDoses: true, StopOnCondition: true, StopNone: true,
}

// StopCondition is when and why a course ends (SRS-MED-001).
type StopCondition struct {
	Kind StopConditionKind
	// At is set for StopAtTime.
	At time.Time
	// Doses is set for StopAfterDoses.
	Doses int
	// Text is set for StopOnCondition.
	Text string
}

// Validate rejects a stop condition that could not be acted on.
func (s StopCondition) Validate() error {
	if !knownStopKinds[s.Kind] {
		return invalidf("unknown stop condition %q", s.Kind)
	}
	switch s.Kind {
	case StopAtTime:
		if s.At.IsZero() {
			return invalidf("a course that stops at a time needs the time")
		}
	case StopAfterDoses:
		if s.Doses <= 0 {
			return invalidf("a course that stops after a count needs the count")
		}
	case StopOnCondition:
		if strings.TrimSpace(s.Text) == "" {
			return invalidf("a course that stops on a condition needs the condition")
		}
	}
	return nil
}

// String renders a stop condition for a human (SRS-MED-001).
func (s StopCondition) String() string {
	switch s.Kind {
	case StopAtTime:
		return "until " + s.At.UTC().Format("2006-01-02 15:04") + " UTC"
	case StopAfterDoses:
		return fmt.Sprintf("for %d doses", s.Doses)
	case StopOnCondition:
		return "until " + strings.TrimSpace(s.Text)
	}
	return "continuing"
}

// DoseSegment is one stretch of a schedule at one dose (SRS-MED-009).
//
// A simple prescription is one segment. A taper is several, and the requirement
// is explicit that the segments are *explicit*: "reduce by 5mg weekly" is a
// sentence a nurse has to compute from, and every party computing separately is
// how a steroid taper ends up with two different doses on the same day.
type DoseSegment struct {
	// Sequence orders the segments. Contiguous from 1, so a gap is a segment
	// somebody meant to write and did not.
	Sequence int
	Dose     Quantity
	// FreeTextDose carries a dose that could not be structured — "apply
	// sparingly", "titrate to effect". Allowed, but SRS-MED-010 lets a tenant
	// configure classes where it is not, and then submit is blocked.
	FreeTextDose string
	// Timing is when the dose is given.
	Timing Timing
	// StartsAt is when this segment begins. The first segment's start is the
	// prescription's start.
	StartsAt time.Time
	// EndsAt is when it hands over to the next. Zero on the last segment, where
	// the stop condition takes over.
	EndsAt time.Time
	// Note explains this step of a taper to whoever gives it.
	Note string
}

// Structured reports a segment whose dose a machine can act on (SRS-MED-010).
func (s DoseSegment) Structured() bool { return !s.Dose.Zero() }

// Describe renders a segment for a human (SRS-MED-001, SRS-MED-009).
func (s DoseSegment) Describe() string {
	dose := strings.TrimSpace(s.FreeTextDose)
	if s.Structured() {
		dose = s.Dose.String()
	}
	timing := s.Timing.Describe()
	if timing == "" {
		return dose
	}
	return dose + " " + timing
}

func (s DoseSegment) validate() error {
	if s.Sequence < 1 {
		return invalidf("a dose segment needs a sequence")
	}
	if !s.Structured() && strings.TrimSpace(s.FreeTextDose) == "" {
		return invalidf("segment %d has no dose", s.Sequence)
	}
	if s.Structured() {
		if err := s.Dose.Validate(); err != nil {
			return err
		}
	}
	if err := s.Timing.Validate(); err != nil {
		return err
	}
	if !s.EndsAt.IsZero() && !s.StartsAt.IsZero() &&
		!s.EndsAt.After(s.StartsAt) {
		return invalidf("segment %d ends before it begins", s.Sequence)
	}
	return nil
}

// Timing is when a dose is given (SRS-MED-001, SRS-MED-009).
//
// Narrower than the order context's timing on purpose: the segment carries the
// window, so this carries only the shape of the recurrence. The prescriber's own
// phrase travels alongside for rendering, and is never what a schedule is
// computed from — "four times daily" is read one way by a pharmacy system and
// another by a ward, and the two then disagree about when the patient is due.
type Timing struct {
	// FrequencyText is the phrase as the prescriber wrote it, for display.
	FrequencyText string
	// Interval is how often, as a period. Zero with no TimesOfDay means once.
	Interval time.Duration
	// TimesOfDay pins doses to clock times, as minutes after midnight in the
	// facility's zone. A four-times-daily drug is given on the ward round at
	// 06:00, 12:00, 18:00 and 22:00, not every six hours from whenever it was
	// prescribed — and the difference decides whether a dose lands at 01:00.
	TimesOfDay []int32
	// DaysOfWeek narrows a repeat. Empty means every day. Methotrexate weekly
	// is the case that makes this load-bearing: given daily it is lethal.
	DaysOfWeek []time.Weekday
	// PRN marks an as-needed medication, which has no schedule at all.
	PRN bool
	// Duration is how long one dose takes to give, for an infusion.
	Duration time.Duration
}

// Validate rejects timing that cannot be turned into a schedule.
func (t Timing) Validate() error {
	if t.Interval < 0 {
		return invalidf("an interval cannot be negative")
	}
	if t.PRN && (t.Interval > 0 || len(t.TimesOfDay) > 0) {
		// An as-needed medication with a schedule is two instructions, and the
		// ward follows whichever one it reads first.
		return invalidf("an as-needed medication cannot also have a schedule")
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

// Repeating reports timing that produces more than one dose.
func (t Timing) Repeating() bool {
	return !t.PRN && (t.Interval > 0 || len(t.TimesOfDay) > 0)
}

// MaxOccurrences bounds what Occurrences will generate.
//
// A continuing medication with no end would otherwise produce an unbounded list
// the first time anybody asked a wide window.
const MaxOccurrences = 500

// Occurrences expands timing into the moments a dose is due (SRS-MED-001).
//
// anchor is when the segment this timing belongs to begins; from and to bound
// the question being asked. The two are separate because a schedule is a
// property of the prescription and a window is a property of the query: a round
// asking "what is due this shift" must get the same times as a pharmacy asking
// "what is due this week".
//
// in is the facility's location, so "06:00" means 06:00 on the ward. A schedule
// computed in UTC is an hour out twice a year, which is how a dose lands in the
// middle of the night.
func (t Timing) Occurrences(anchor, from, to time.Time, in *time.Location) []time.Time {
	if t.PRN || in == nil || !to.After(from) {
		return nil
	}
	anchor = anchor.UTC()

	if !t.Repeating() {
		// A single dose, at the moment the segment starts.
		if anchor.Before(from) || !anchor.Before(to) {
			return nil
		}
		return []time.Time{anchor}
	}

	var out []time.Time
	add := func(at time.Time) bool {
		if len(out) >= MaxOccurrences {
			return false
		}
		at = at.UTC()
		if at.Before(anchor) || at.Before(from) || !at.Before(to) {
			return true
		}
		out = append(out, at)
		return true
	}

	if len(t.TimesOfDay) > 0 {
		times := append([]int32(nil), t.TimesOfDay...)
		sort.Slice(times, func(i, j int) bool { return times[i] < times[j] })

		// Start a day early so a clock time earlier in the day than the
		// window's own start is not missed at the boundary.
		day := from.In(in).AddDate(0, 0, -1)
		day = time.Date(day.Year(), day.Month(), day.Day(), 0, 0, 0, 0, in)
		last := to.In(in)
		for !day.After(last) {
			if t.onDay(day.Weekday()) {
				for _, minutes := range times {
					if !add(day.Add(time.Duration(minutes) * time.Minute)) {
						return out
					}
				}
			}
			day = day.AddDate(0, 0, 1)
		}
		return out
	}

	// A fixed interval runs from when the drug was prescribed: six-hourly means
	// six hours from the first dose, not from midnight.
	for at := anchor; at.Before(to); at = at.Add(t.Interval) {
		if !t.onDay(at.In(in).Weekday()) {
			continue
		}
		if !add(at) {
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

// Describe renders timing for a human (SRS-MED-001).
//
// The prescriber's phrase wins where there is one, because that is what they
// meant; the computed form is the fallback so a prescription entered purely
// structurally still reads as a sentence rather than a row of fields.
func (t Timing) Describe() string {
	if text := strings.TrimSpace(t.FrequencyText); text != "" {
		return text
	}
	if t.PRN {
		return "as needed"
	}
	if len(t.TimesOfDay) > 0 {
		times := append([]int32(nil), t.TimesOfDay...)
		sort.Slice(times, func(i, j int) bool { return times[i] < times[j] })
		parts := make([]string, 0, len(times))
		for _, m := range times {
			parts = append(parts, fmt.Sprintf("%02d:%02d", m/60, m%60))
		}
		return "at " + strings.Join(parts, ", ")
	}
	if t.Interval > 0 {
		return "every " + t.Interval.String()
	}
	return "once"
}

// PRNConstraint is what bounds an as-needed medication (SRS-MED-008).
//
// The requirement's acceptance is "eMAR enforces minimum interval/max dose
// policy where structured", and the qualifier is the point: a PRN written as
// "one or two as required" cannot be enforced by anything, so the constraint is
// a separate structured field rather than something parsed out of the
// instructions. What is structured is enforced; what is not is shown.
type PRNConstraint struct {
	// Indication is why the nurse would give it — "for pain", "for nausea".
	// Mandatory on a PRN: an as-needed drug with no stated trigger is one a
	// nurse decides about with nothing to decide against.
	Indication string
	// MinInterval is the shortest gap between doses. Zero means unconstrained.
	MinInterval time.Duration
	// MaxDoses is the most that may be given in the period. Zero means
	// unconstrained.
	MaxDoses int
	// MaxDoseTotal is a ceiling on the summed amount — four grams of
	// paracetamol, whatever the number of tablets that took.
	MaxDoseTotal Quantity
	// Period is what MaxDoses and MaxDoseTotal are measured over. Defaults to
	// 24 hours when a maximum is set without one.
	Period time.Duration
}

// DefaultPRNPeriod is the window a maximum is measured over when none is given.
const DefaultPRNPeriod = 24 * time.Hour

// Validate rejects a PRN constraint that could not be enforced.
func (c PRNConstraint) Validate() error {
	if strings.TrimSpace(c.Indication) == "" {
		return invalidf("an as-needed medication needs an indication")
	}
	if c.MinInterval < 0 || c.Period < 0 {
		return invalidf("a PRN interval cannot be negative")
	}
	if c.MaxDoses < 0 {
		return invalidf("a maximum dose count cannot be negative")
	}
	if !c.MaxDoseTotal.Zero() {
		if err := c.MaxDoseTotal.Validate(); err != nil {
			return err
		}
	}
	return nil
}

// period is the window a maximum applies over.
func (c PRNConstraint) period() time.Duration {
	if c.Period > 0 {
		return c.Period
	}
	return DefaultPRNPeriod
}

// PRNRefusal is why a PRN dose may not be given now (SRS-MED-008).
//
// Structured rather than a sentence, because the nurse's next question is
// always "then when?" and a message that cannot answer it sends them to find
// the prescription themselves.
type PRNRefusal struct {
	Reason string
	// NextAllowedAt is when the dose becomes due, where that is computable.
	NextAllowedAt time.Time
	// Given is how many doses have already been given in the period.
	Given int
	// Limit is what the constraint allows.
	Limit int
}

func (r PRNRefusal) Error() string { return r.Reason }

// Is lets errors.Is find the sentinel through a structured refusal.
func (r PRNRefusal) Is(target error) bool { return target == ErrNotAllowed }

// CheckPRN reports whether an as-needed dose may be given now (SRS-MED-008).
//
// given is the times of the doses already administered, in any order. Passed in
// rather than held here because the administration record belongs to the
// nursing context: this is the rule, and the eMAR is what applies it.
func (c PRNConstraint) CheckPRN(given []time.Time, dose Quantity, at time.Time) error {
	at = at.UTC()

	var latest time.Time
	inPeriod := 0
	total := 0.0
	windowStart := at.Add(-c.period())
	for _, t := range given {
		t = t.UTC()
		if t.After(at) {
			continue
		}
		if t.After(latest) {
			latest = t
		}
		if t.After(windowStart) {
			inPeriod++
		}
	}

	if c.MinInterval > 0 && !latest.IsZero() {
		next := latest.Add(c.MinInterval)
		if at.Before(next) {
			return PRNRefusal{
				Reason: fmt.Sprintf("the last dose was at %s and the minimum interval is %s",
					latest.Format(time.RFC3339), c.MinInterval),
				NextAllowedAt: next,
			}
		}
	}

	if c.MaxDoses > 0 && inPeriod >= c.MaxDoses {
		return PRNRefusal{
			Reason: fmt.Sprintf("%d doses already given in %s and the maximum is %d",
				inPeriod, c.period(), c.MaxDoses),
			Given: inPeriod, Limit: c.MaxDoses,
		}
	}

	if !c.MaxDoseTotal.Zero() && !dose.Zero() &&
		strings.EqualFold(dose.Unit, c.MaxDoseTotal.Unit) {
		// Only comparable in the same unit. A ceiling in milligrams against a
		// dose in tablets is a sum nobody should compute silently, so it is
		// left to the pharmacist rather than guessed at with a conversion this
		// context does not have.
		total = float64(inPeriod)*dose.Value + dose.Value
		if total > c.MaxDoseTotal.Value {
			return PRNRefusal{
				Reason: fmt.Sprintf("this dose would take the %s total to %s, above the maximum %s",
					c.period(), Quantity{Value: total, Unit: dose.Unit}, c.MaxDoseTotal),
				Given: inPeriod,
			}
		}
	}

	return nil
}

// TherapyChange is one entry in the therapy's ledger (SRS-MED-013, SRS-MED-014).
//
// Append-only, and the reason is SRS-MED-014's "consumers can reconstruct the
// medication timeline without mutating the source ledger": a hold that
// overwrote the previous state would leave nothing to reconstruct from, and the
// question a drug chart is asked afterwards is almost always "what was the
// patient on, on the day this happened".
type TherapyChange struct {
	From TherapyStatus
	To   TherapyStatus
	// EffectiveAt is when the change takes effect clinically, which is not
	// always when it was typed. A drug stopped on the ward round at 09:00 and
	// recorded at 11:00 stopped at 09:00, and the dose at 10:00 should not have
	// been given.
	EffectiveAt time.Time
	RecordedAt  time.Time
	By          string
	Reason      string
}

// Prescription is one medication a patient is on (SRS-MED-001).
type Prescription struct {
	ID       string
	TenantID string

	// OrderID and OrderNumber point at the CPOE order this prescription is the
	// clinical detail of. Placing a prescription places an order, so a drug is
	// on the same worklist, in the same audit trail and under the same
	// duplicate rules as everything else that was asked of a service.
	OrderID     string
	OrderNumber string

	PatientID   string
	EncounterID string
	FacilityID  string
	// PrescriberID is who is answerable. EnteredByID is who typed it — not
	// always the same person, and the question an investigation asks is always
	// the first one.
	PrescriberID string
	EnteredByID  string

	// Ingredient is the substance. Product is the dispensable form, which is
	// optional: prescribing by ingredient is safer where a hospital stocks
	// several brands, and SRS-MED-011's substitution is only meaningful when
	// the two are kept apart.
	Ingredient Coding
	Product    Coding
	Route      string

	// Segments are the dose steps, in sequence (SRS-MED-009).
	Segments []DoseSegment
	// StartsAt is when the therapy begins. The first segment inherits it.
	StartsAt time.Time
	Stop     StopCondition

	// Indication is why. Mandatory for medication: SRS-ORD-007 makes it
	// configurable per order type and every tenant that has thought about it
	// switches it on for drugs.
	Indication     string
	IndicationCode Coding
	// Instructions are the additional words a nurse acts on — "with food",
	// "hold if systolic below 100". Additional to the structure, never instead
	// of it: SRS-MED-010 exists because a dose that lives only here cannot be
	// checked, scheduled or totalled.
	Instructions string

	PRN PRNConstraint

	Status  TherapyStatus
	Changes []TherapyChange

	// Screen is what the safety rules said at prescribing time, with the rule
	// versions that said it (SRS-MED-002, SRS-MED-003, SRS-MED-004). Stored
	// rather than recomputed: the rule set is edited, and a report that
	// recomputed would show a clinician overriding a warning that did not exist
	// when they prescribed.
	Screen ScreenResult
	// Formulary is where this medication stood when it was prescribed
	// (SRS-MED-012), for the same reason.
	Formulary FormularyDecision

	// Verification is the pharmacist's check (SRS-MED-006).
	Verification Verification

	CreatedAt time.Time
	UpdatedAt time.Time
	Version   int64
}

// NewPrescriptionInput is what composing a prescription needs.
type NewPrescriptionInput struct {
	PatientID    string
	EncounterID  string
	FacilityID   string
	PrescriberID string
	EnteredByID  string

	Ingredient Coding
	Product    Coding
	Route      string

	Segments []DoseSegment
	StartsAt time.Time
	Stop     StopCondition

	Indication     string
	IndicationCode Coding
	Instructions   string

	PRN PRNConstraint
}

// NewPrescription composes a prescription in draft (SRS-MED-001).
//
// Draft rather than active, because the safety screen runs between composing
// and prescribing: a prescription that existed in an actionable state before
// anything had checked it against the allergy list is one a ward could act on
// in the gap.
func NewPrescription(id, tenantID string, in NewPrescriptionInput, now time.Time) (
	*Prescription, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return nil, invalidf("a prescription needs an identifier")
	case strings.TrimSpace(in.PatientID) == "":
		return nil, invalidf("a prescription needs a patient")
	case strings.TrimSpace(in.EncounterID) == "":
		// Every prescription belongs to a visit. One with no encounter cannot
		// be found on the chart and cannot be stopped when the patient leaves.
		return nil, invalidf("a prescription needs an encounter")
	case strings.TrimSpace(in.PrescriberID) == "":
		return nil, invalidf("a prescription needs a prescriber")
	case strings.TrimSpace(in.Route) == "":
		// The commonest fatal medication error in the literature is the right
		// drug by the wrong route.
		return nil, invalidf("a prescription needs a route")
	case len(in.Segments) == 0:
		return nil, invalidf("a prescription needs at least one dose")
	}

	if err := in.Ingredient.Validate(); err != nil {
		return nil, err
	}
	if !in.Product.Empty() {
		if err := in.Product.Validate(); err != nil {
			return nil, err
		}
	}
	if !in.IndicationCode.Empty() {
		if err := in.IndicationCode.Validate(); err != nil {
			return nil, err
		}
	}
	if err := in.Stop.Validate(); err != nil {
		return nil, err
	}

	segments, err := normaliseSegments(in.Segments, in.StartsAt)
	if err != nil {
		return nil, err
	}

	prn := segments[0].Timing.PRN
	for _, s := range segments[1:] {
		if s.Timing.PRN != prn {
			// Half a taper as-needed and half scheduled is two prescriptions
			// written as one, and the ward would follow whichever segment it
			// read.
			return nil, invalidf("a prescription is either as-needed or scheduled, not both")
		}
	}
	if prn {
		if len(segments) > 1 {
			return nil, invalidf("an as-needed medication has no dose segments to step through")
		}
		if err := in.PRN.Validate(); err != nil {
			return nil, err
		}
	}

	entered := strings.TrimSpace(in.EnteredByID)
	if entered == "" {
		entered = strings.TrimSpace(in.PrescriberID)
	}

	starts := in.StartsAt
	if starts.IsZero() {
		starts = now
	}

	return &Prescription{
		ID: id, TenantID: tenantID,
		PatientID:   strings.TrimSpace(in.PatientID),
		EncounterID: strings.TrimSpace(in.EncounterID),
		FacilityID:  strings.TrimSpace(in.FacilityID),

		PrescriberID: strings.TrimSpace(in.PrescriberID),
		EnteredByID:  entered,

		Ingredient: in.Ingredient,
		Product:    in.Product,
		Route:      strings.TrimSpace(in.Route),

		Segments: segments,
		StartsAt: starts.UTC(),
		Stop:     in.Stop,

		Indication:     strings.TrimSpace(in.Indication),
		IndicationCode: in.IndicationCode,
		Instructions:   strings.TrimSpace(in.Instructions),

		PRN: in.PRN,

		Status:    TherapyDraft,
		CreatedAt: now.UTC(),
		UpdatedAt: now.UTC(),
		Version:   1,
	}, nil
}

// normaliseSegments orders the segments, checks them and chains their windows.
func normaliseSegments(in []DoseSegment, startsAt time.Time) ([]DoseSegment, error) {
	out := append([]DoseSegment(nil), in...)
	sort.SliceStable(out, func(i, j int) bool { return out[i].Sequence < out[j].Sequence })

	for i := range out {
		if out[i].Sequence != i+1 {
			// Contiguous from one, because a gap is a step of a taper somebody
			// meant to write and did not, and a taper with a missing step is
			// the one that gets given at the wrong dose.
			return nil, invalidf("dose segments must be numbered from 1 without gaps")
		}
		if err := out[i].validate(); err != nil {
			return nil, err
		}
	}

	if out[0].StartsAt.IsZero() {
		out[0].StartsAt = startsAt
	}
	for i := 1; i < len(out); i++ {
		if out[i].StartsAt.IsZero() {
			if out[i-1].EndsAt.IsZero() {
				return nil, invalidf(
					"segment %d must say when it begins, because segment %d has no end",
					out[i].Sequence, out[i-1].Sequence)
			}
			out[i].StartsAt = out[i-1].EndsAt
		}
		if out[i-1].EndsAt.IsZero() {
			out[i-1].EndsAt = out[i].StartsAt
		}
		if out[i].StartsAt.Before(out[i-1].EndsAt) {
			// Overlapping steps mean two doses of the same drug are current at
			// once, which is exactly the error a taper is most likely to make.
			return nil, invalidf("segment %d begins before segment %d ends",
				out[i].Sequence, out[i-1].Sequence)
		}
	}
	for i := range out {
		out[i].StartsAt = out[i].StartsAt.UTC()
		if !out[i].EndsAt.IsZero() {
			out[i].EndsAt = out[i].EndsAt.UTC()
		}
	}
	return out, nil
}

// Structured reports a prescription every segment of which a machine can act on
// (SRS-MED-010).
func (p *Prescription) Structured() bool {
	for _, s := range p.Segments {
		if !s.Structured() {
			return false
		}
	}
	return true
}

// Prescribe makes a draft live (SRS-MED-001).
//
// Separate from composing because the safety screen runs in between: the
// application layer attaches the screen result and the formulary decision, and
// then this refuses to go live while a blocking finding stands unanswered.
func (p *Prescription) Prescribe(now time.Time) error {
	if p.Status != TherapyDraft {
		return notAllowedf("this prescription is already %s", p.Status)
	}
	if blocking := p.Screen.Blocking(); len(blocking) > 0 {
		return SafetyRefusal{Findings: blocking}
	}
	// The therapy becomes live when it starts, not when it was typed. A drug
	// the patient has been on since admission is transcribed with a start time
	// in the past, and stamping the ledger with the keystroke would say the
	// therapy began at the moment somebody got round to recording it — which
	// makes StatusAt answer "draft" for every day the patient was actually
	// taking it, and makes a hold backdated to the ward round look like a
	// change dated before the prescription itself.
	effectiveAt := now
	if !p.StartsAt.IsZero() && p.StartsAt.Before(effectiveAt) {
		effectiveAt = p.StartsAt
	}
	return p.transition(TherapyActive, effectiveAt, now, p.PrescriberID, "prescribed")
}

// Hold suspends a therapy from a moment (SRS-MED-013).
//
// effectiveAt is separate from now because a drug stopped on the ward round at
// 09:00 and typed at 11:00 stopped at 09:00. Doses before that moment stay on
// the record exactly as they were — SRS-MED-013's "historical MAR remains
// unchanged" — and doses after it disappear from the schedule.
func (p *Prescription) Hold(by, reason string, effectiveAt, now time.Time) error {
	if strings.TrimSpace(reason) == "" {
		// A drug that stopped for no recorded reason is one nobody can decide
		// whether to restart, and the person who knows has gone off shift.
		return invalidf("holding a medication needs a reason")
	}
	return p.transition(TherapyHeld, effectiveAt, now, by, reason)
}

// Restart resumes a held therapy (SRS-MED-013).
func (p *Prescription) Restart(by, reason string, effectiveAt, now time.Time) error {
	if p.Status != TherapyHeld {
		return notAllowedf("only a held medication can be restarted; this one is %s", p.Status)
	}
	if strings.TrimSpace(reason) == "" {
		return invalidf("restarting a medication needs a reason")
	}
	return p.transition(TherapyActive, effectiveAt, now, by, reason)
}

// Discontinue stops a therapy for good (SRS-MED-013, SRS-MED-007).
func (p *Prescription) Discontinue(by, reason string, effectiveAt, now time.Time) error {
	if strings.TrimSpace(reason) == "" {
		return invalidf("discontinuing a medication needs a reason")
	}
	return p.transition(TherapyDiscontinued, effectiveAt, now, by, reason)
}

// Complete records a course that ran to its end (SRS-MED-013).
func (p *Prescription) Complete(by string, effectiveAt, now time.Time) error {
	return p.transition(TherapyCompleted, effectiveAt, now, by, "course completed")
}

func (p *Prescription) transition(to TherapyStatus, effectiveAt, now time.Time,
	by, reason string) error {

	if !knownTherapyStatuses[to] {
		return invalidf("unknown therapy status %q", to)
	}
	if p.Status == to {
		// Idempotent. A retried request must not append a second ledger entry,
		// because the timeline is what consumers reconstruct from.
		return nil
	}
	if !p.Status.CanBecome(to) {
		return notAllowedf("a %s medication cannot become %s", p.Status, to)
	}
	if strings.TrimSpace(by) == "" {
		return invalidf("a change of therapy needs the person making it")
	}
	if effectiveAt.IsZero() {
		effectiveAt = now
	}
	if last := p.lastChange(); last != nil && effectiveAt.Before(last.EffectiveAt) {
		// A change backdated behind the previous one would reorder the
		// timeline, and a chart that reorders is one nobody can read as
		// evidence.
		return invalidf("this change is dated before the previous one")
	}

	p.Changes = append(p.Changes, TherapyChange{
		From: p.Status, To: to,
		EffectiveAt: effectiveAt.UTC(), RecordedAt: now.UTC(),
		By: strings.TrimSpace(by), Reason: strings.TrimSpace(reason),
	})
	p.Status = to
	p.UpdatedAt = now.UTC()
	p.Version++
	return nil
}

func (p *Prescription) lastChange() *TherapyChange {
	if len(p.Changes) == 0 {
		return nil
	}
	return &p.Changes[len(p.Changes)-1]
}

// EffectiveStop is the moment after which no further dose may be given
// (SRS-MED-007).
//
// Zero when the therapy is live. This is the requirement's "effective stop
// time": the moment the clinician named, not the moment the keystroke landed.
func (p *Prescription) EffectiveStop() time.Time {
	if !p.Status.Final() && p.Status != TherapyHeld {
		return time.Time{}
	}
	if last := p.lastChange(); last != nil {
		return last.EffectiveAt
	}
	return time.Time{}
}

// StatusAt answers what the therapy status was at a moment (SRS-MED-014).
//
// Reconstructed from the ledger rather than stored per day, which is what lets
// a consumer rebuild the timeline without this context keeping a second copy of
// it.
func (p *Prescription) StatusAt(at time.Time) TherapyStatus {
	at = at.UTC()
	status := TherapyDraft
	if len(p.Changes) == 0 {
		return p.Status
	}
	for _, c := range p.Changes {
		if c.EffectiveAt.After(at) {
			break
		}
		status = c.To
	}
	return status
}

// Administrable reports whether a dose may be given at a moment
// (SRS-MED-006, SRS-MED-007).
//
// Verification is part of the answer rather than a separate question, because
// SRS-MED-007 says administrations come only from *eligible* orders and
// SRS-MED-006 says verification gates administration where policy requires it.
// A caller that asked only about status would be asking half the question.
func (p *Prescription) Administrable(at time.Time, verificationRequired bool) bool {
	at = at.UTC()
	if p.StatusAt(at) != TherapyActive {
		return false
	}
	if verificationRequired && !p.Verification.Done() {
		return false
	}
	if at.Before(p.StartsAt) {
		return false
	}
	if p.Stop.Kind == StopAtTime && !p.Stop.At.IsZero() && !at.Before(p.Stop.At.UTC()) {
		return false
	}
	return true
}

// DueDose is one scheduled moment, with the segment it comes from.
type DueDose struct {
	PrescriptionID string
	ScheduledAt    time.Time
	Segment        DoseSegment
}

// Schedule expands the prescription into the doses due in a window
// (SRS-MED-007, SRS-MED-009).
//
// Every segment is walked within its own window, so a taper produces the right
// dose on the right day rather than the current one applied backwards. Doses
// after the effective stop time are not produced at all — which is
// SRS-MED-007's "discontinued order prevents future administrations after
// effective stop time", held here rather than by the eMAR remembering to ask.
func (p *Prescription) Schedule(from, to time.Time, in *time.Location) []DueDose {
	if p.Status == TherapyDraft || in == nil {
		return nil
	}
	from, to = from.UTC(), to.UTC()
	if from.Before(p.StartsAt) {
		from = p.StartsAt
	}
	if stop := p.EffectiveStop(); !stop.IsZero() && stop.Before(to) {
		to = stop
	}
	if p.Stop.Kind == StopAtTime && !p.Stop.At.IsZero() && p.Stop.At.UTC().Before(to) {
		to = p.Stop.At.UTC()
	}
	if !to.After(from) {
		return nil
	}

	var out []DueDose
	for _, seg := range p.Segments {
		segFrom, segTo := from, to
		if seg.StartsAt.After(segFrom) {
			segFrom = seg.StartsAt
		}
		if !seg.EndsAt.IsZero() && seg.EndsAt.Before(segTo) {
			segTo = seg.EndsAt
		}
		if !segTo.After(segFrom) {
			continue
		}
		for _, at := range seg.Timing.Occurrences(seg.StartsAt, segFrom, segTo, in) {
			out = append(out, DueDose{
				PrescriptionID: p.ID, ScheduledAt: at, Segment: seg,
			})
			if len(out) >= MaxOccurrences {
				return out
			}
		}
	}
	sort.SliceStable(out, func(i, j int) bool {
		return out[i].ScheduledAt.Before(out[j].ScheduledAt)
	})

	if p.Stop.Kind == StopAfterDoses && p.Stop.Doses > 0 && len(out) > p.Stop.Doses {
		out = out[:p.Stop.Doses]
	}
	return out
}

// Describe renders the prescription as a sentence (SRS-MED-001).
//
// The requirement's acceptance is "machine-readable and human-readable", and
// the second half is not decoration: the human-readable form is what appears on
// a drug chart, and a system that leaves each client to compose its own sentence
// from the fields will eventually have two clients rendering the same
// prescription differently. Composed here, from the structure, so the sentence
// and the data cannot disagree.
func (p *Prescription) Describe() string {
	name := strings.TrimSpace(p.Product.Display)
	if name == "" {
		name = strings.TrimSpace(p.Ingredient.Display)
	}

	parts := []string{name}
	for i, seg := range p.Segments {
		text := seg.Describe()
		if len(p.Segments) > 1 {
			text = fmt.Sprintf("step %d: %s", i+1, text)
		}
		parts = append(parts, text)
	}
	parts = append(parts, strings.TrimSpace(p.Route))

	if p.PRNScheduled() {
		parts = append(parts, "as needed "+strings.TrimSpace(p.PRN.Indication))
		if p.PRN.MinInterval > 0 {
			parts = append(parts, "no more often than every "+p.PRN.MinInterval.String())
		}
		if p.PRN.MaxDoses > 0 {
			parts = append(parts, fmt.Sprintf("maximum %d in %s",
				p.PRN.MaxDoses, p.PRN.period()))
		}
	}

	if stop := p.Stop.String(); stop != "" {
		parts = append(parts, stop)
	}
	if p.Indication != "" {
		parts = append(parts, "for "+p.Indication)
	}
	if p.Instructions != "" {
		parts = append(parts, p.Instructions)
	}
	return strings.Join(parts, ", ")
}

// PRNScheduled reports an as-needed prescription.
func (p *Prescription) PRNScheduled() bool {
	return len(p.Segments) > 0 && p.Segments[0].Timing.PRN
}
