// Package domain holds the housekeeping and environmental services rules
// (SRS-HKP-001 … 008).
//
// Nothing here reaches a database, a clock or a transport (FIT-01). Every
// refusal is a value a caller can act on rather than a panic.
//
// Two properties run through the package and are worth stating once.
//
// A bed with an open terminal clean is not available, and the only ways out
// are the clean finishing or somebody overriding it by name and reason.
// SRS-HKP-003's acceptance says exactly that, and it is the rule that stops a
// patient being put into the bed the last one died in. Every other rule here
// is about a task getting done; this one is about what happens if it does
// not.
//
// And a location scan is evidence, never authority. SRS-HKP-007 is explicit
// that a scan does not replace user authentication, so there is no path here
// that completes a task from a scan: a scan is recorded against a task by an
// authenticated person, and a scan of the wrong room is recorded as a
// mismatch rather than quietly accepted.
package domain

import (
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"
)

// ErrInvalidHousekeeping reports a refused housekeeping action.
var ErrInvalidHousekeeping = errors.New("housekeeping: invalid")

// RiskClass is how much a place matters when it is not clean
// (SRS-HKP-001).
//
// The classification drives the cleaning frequency and the escalation, which
// is why it is an enum rather than a number: a hospital that could type "7"
// would have four wards on seven and nobody able to say what seven meant.
type RiskClass string

const (
	// RiskVeryHigh is theatres, critical care, isolation rooms and the
	// sterile services clean room. An overdue clean here is escalated.
	RiskVeryHigh RiskClass = "very_high"
	// RiskHigh is inpatient wards, treatment rooms and the emergency
	// department.
	RiskHigh RiskClass = "high"
	// RiskModerate is outpatient areas, corridors and waiting rooms.
	RiskModerate RiskClass = "moderate"
	// RiskLow is offices and non-clinical storage.
	RiskLow RiskClass = "low"
)

var knownRiskClass = map[RiskClass]bool{
	RiskVeryHigh: true, RiskHigh: true,
	RiskModerate: true, RiskLow: true,
}

// Critical reports the classes where an overdue clean is escalated rather
// than queued (SRS-HKP-005).
func (r RiskClass) Critical() bool { return r == RiskVeryHigh }

// ChecklistItem is one thing a clean has to include (SRS-HKP-002).
type ChecklistItem struct {
	Code  string
	Label string
	// Required marks an item a clean cannot be completed without an answer
	// for. An optional item is one the hospital wants counted rather than
	// insisted on.
	Required bool
}

// CleanableLocation is a place with a cleaning standard (SRS-HKP-001).
//
// Versioned by (code, revision) and effective-dated, because SRS-HKP-001's
// acceptance is that schedules derive from the active configuration. A
// configuration edited in place would change what a clean completed last
// month was judged against, and the audit question is always what the
// standard said at the time.
type CleanableLocation struct {
	ID       string
	TenantID string

	Code     string
	Name     string
	Revision int

	FacilityID string
	// Zone groups locations for the people who work them — a ward, a
	// theatre suite, a floor.
	Zone string
	// BedID is set for a location that is a bed. It is what a terminal clean
	// holds, and it is why this context can answer whether a bed is clear.
	BedID string

	RiskClass RiskClass
	// RoutineEveryHours is how often a routine clean falls due. Zero means
	// no routine schedule — a store room cleaned when somebody asks — and
	// is reported as such rather than as a location that is never due.
	RoutineEveryHours int
	// RoutineSLAMinutes is how long a routine task has once raised.
	RoutineSLAMinutes int
	// TerminalSLAMinutes is how long a terminal clean has. Shorter, because
	// a bed is out of service until it is done.
	TerminalSLAMinutes int

	// Checklist is what a clean here has to include. Pinned onto each task
	// when it is raised, so a standard changed afterwards does not change
	// what a completed task was judged against.
	Checklist []ChecklistItem

	// ScanCode is the code on the label at the door. A task's scan is
	// checked against this.
	ScanCode string

	Approved   bool
	ApprovedBy string
	ApprovedAt time.Time

	EffectiveFrom time.Time
	SupersededAt  time.Time
	CreatedAt     time.Time
	CreatedBy     string
	Version       int64
}

// Live reports a configuration in force at a moment (SRS-HKP-001).
func (l CleanableLocation) Live(at time.Time) bool {
	if !l.Approved || l.EffectiveFrom.IsZero() {
		return false
	}
	if at.Before(l.EffectiveFrom) {
		return false
	}
	return l.SupersededAt.IsZero() || at.Before(l.SupersededAt)
}

// NewLocationInput configures a cleanable location.
type NewLocationInput struct {
	Code               string
	Name               string
	Revision           int
	FacilityID         string
	Zone               string
	BedID              string
	RiskClass          RiskClass
	RoutineEveryHours  int
	RoutineSLAMinutes  int
	TerminalSLAMinutes int
	Checklist          []ChecklistItem
	ScanCode           string
	EffectiveFrom      time.Time
}

// NewLocation configures a place and its cleaning standard (SRS-HKP-001).
func NewLocation(id, tenantID string, in NewLocationInput, by string,
	now time.Time) (CleanableLocation, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return CleanableLocation{}, fmt.Errorf("%w: a location needs an id",
			ErrInvalidHousekeeping)
	case strings.TrimSpace(in.Code) == "":
		return CleanableLocation{}, fmt.Errorf("%w: a location needs a code",
			ErrInvalidHousekeeping)
	case in.Revision <= 0:
		return CleanableLocation{}, fmt.Errorf(
			"%w: a location revision starts at one", ErrInvalidHousekeeping)
	case !knownRiskClass[in.RiskClass]:
		// A hospital that could type a risk class would have four wards on
		// values nobody can explain.
		return CleanableLocation{}, fmt.Errorf("%w: unknown risk class %q",
			ErrInvalidHousekeeping, in.RiskClass)
	case in.RoutineEveryHours < 0 || in.RoutineSLAMinutes < 0 ||
		in.TerminalSLAMinutes < 0:
		return CleanableLocation{}, fmt.Errorf(
			"%w: a frequency or SLA cannot be negative",
			ErrInvalidHousekeeping)
	case len(in.Checklist) == 0:
		// A clean with no checklist is a clean nobody can judge, and
		// SRS-HKP-002's acceptance is that a task has one.
		return CleanableLocation{}, fmt.Errorf(
			"%w: a location states what a clean here has to include",
			ErrInvalidHousekeeping)
	}

	checklist := make([]ChecklistItem, 0, len(in.Checklist))
	seen := map[string]bool{}
	for _, item := range in.Checklist {
		code := strings.TrimSpace(item.Code)
		switch {
		case code == "":
			return CleanableLocation{}, fmt.Errorf(
				"%w: a checklist item needs a code", ErrInvalidHousekeeping)
		case seen[strings.ToLower(code)]:
			// The same item twice is two answers to one question, and a
			// completion check that counts both.
			return CleanableLocation{}, fmt.Errorf(
				"%w: checklist item %q appears twice",
				ErrInvalidHousekeeping, code)
		}
		seen[strings.ToLower(code)] = true
		checklist = append(checklist, ChecklistItem{
			Code: code, Label: strings.TrimSpace(item.Label),
			Required: item.Required,
		})
	}

	return CleanableLocation{
		ID: id, TenantID: tenantID,
		Code: strings.TrimSpace(in.Code), Name: strings.TrimSpace(in.Name),
		Revision: in.Revision, FacilityID: in.FacilityID,
		Zone: strings.TrimSpace(in.Zone), BedID: strings.TrimSpace(in.BedID),
		RiskClass:          in.RiskClass,
		RoutineEveryHours:  in.RoutineEveryHours,
		RoutineSLAMinutes:  in.RoutineSLAMinutes,
		TerminalSLAMinutes: in.TerminalSLAMinutes,
		Checklist:          checklist,
		ScanCode:           strings.TrimSpace(in.ScanCode),
		EffectiveFrom:      utcOrZero(in.EffectiveFrom),
		CreatedAt:          now.UTC(), CreatedBy: by, Version: 1,
	}, nil
}

// Approve puts a location's standard in force (SRS-HKP-001).
//
// Refused for the author. A cleaning standard decides how often a theatre is
// cleaned and what counts as cleaning it, and one person writing and
// approving it is one person deciding that.
func (l *CleanableLocation) Approve(by string, effectiveFrom,
	now time.Time) error {

	switch {
	case l.Approved:
		return fmt.Errorf("%w: this configuration is already approved",
			ErrInvalidHousekeeping)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an approval names who made it",
			ErrInvalidHousekeeping)
	case by == l.CreatedBy:
		return fmt.Errorf(
			"%w: the author of a cleaning standard cannot approve it",
			ErrInvalidHousekeeping)
	case effectiveFrom.IsZero():
		return fmt.Errorf(
			"%w: an approved configuration says when it takes effect",
			ErrInvalidHousekeeping)
	}

	l.Approved = true
	l.ApprovedBy, l.ApprovedAt = by, now.UTC()
	l.EffectiveFrom = effectiveFrom.UTC()
	return nil
}

// LocationInForce picks the configuration a location is cleaned to
// (SRS-HKP-001).
//
// The latest effective revision in force. One, never a list: two live
// standards for one room is a room cleaned to whichever the reader opened.
func LocationInForce(locations []CleanableLocation, code string,
	at time.Time) (CleanableLocation, bool) {

	var best CleanableLocation
	found := false
	for _, location := range locations {
		if !strings.EqualFold(location.Code, code) || !location.Live(at) {
			continue
		}
		if !found || location.EffectiveFrom.After(best.EffectiveFrom) ||
			(location.EffectiveFrom.Equal(best.EffectiveFrom) &&
				location.Revision > best.Revision) {
			best, found = location, true
		}
	}
	return best, found
}

// DueRoutine is a location whose routine clean has fallen due
// (SRS-HKP-001).
type DueRoutine struct {
	Location CleanableLocation
	// LastCleanedAt is zero for a location nobody has ever cleaned, which
	// appears immediately rather than never: a room with no history is the
	// one most likely to have been missed.
	LastCleanedAt time.Time
	DueSince      time.Time
	Never         bool
}

// DueRoutineCleans lists the locations a routine clean is due for
// (SRS-HKP-001).
//
// Derived from the configuration in force rather than from a stored
// schedule, which is SRS-HKP-001's acceptance. A frequency changed this
// morning changes what is due this afternoon, and nothing has to be
// regenerated for that to happen.
func DueRoutineCleans(locations []CleanableLocation,
	lastCleaned map[string]time.Time, at time.Time) []DueRoutine {

	var due []DueRoutine
	for _, location := range locations {
		if !location.Live(at) || location.RoutineEveryHours <= 0 {
			// A location with no routine schedule is cleaned when somebody
			// asks. Reported nowhere rather than reported as overdue for
			// ever.
			continue
		}
		last := lastCleaned[location.Code]
		if last.IsZero() {
			due = append(due, DueRoutine{
				Location: location, Never: true,
				DueSince: location.EffectiveFrom,
			})
			continue
		}
		next := last.Add(time.Duration(location.RoutineEveryHours) *
			time.Hour)
		if !at.Before(next) {
			due = append(due, DueRoutine{
				Location: location, LastCleanedAt: last, DueSince: next,
			})
		}
	}

	sort.Slice(due, func(a, b int) bool {
		// Never-cleaned first, then oldest due. A worklist sorted by room
		// number sends somebody past the theatre to do an office.
		if due[a].Never != due[b].Never {
			return due[a].Never
		}
		if !due[a].DueSince.Equal(due[b].DueSince) {
			return due[a].DueSince.Before(due[b].DueSince)
		}
		return due[a].Location.Code < due[b].Location.Code
	})
	return due
}

func utcOrZero(t time.Time) time.Time {
	if t.IsZero() {
		return time.Time{}
	}
	return t.UTC()
}
