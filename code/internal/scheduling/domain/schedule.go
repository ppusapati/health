package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Availability (SRS-SCH-001, SRS-SCH-002, SRS-SCH-003).
//
// A schedule is a rule, not a list of slots. "Dr Rao, Tuesdays and Thursdays,
// 09:00 to 13:00, fifteen minutes, one patient at a time, from March" is one
// row; the slots it implies are generated when somebody asks.
//
// Storing the rule rather than the slots is what makes the acceptance criterion
// — "slot search reflects active roster and exceptions" — hold by construction.
// Materialised slots go stale the moment a clinician's roster changes, and the
// stale ones are indistinguishable from the good ones: a patient books a
// Tuesday that no longer exists, and nobody finds out until they arrive.
//
// Slot rows do exist, but only where capacity is consumed. See Slot.

// VisitType is what kind of appointment a slot is for.
//
// Part of the schedule rather than the booking because the durations differ: a
// new-patient assessment is forty minutes and a follow-up is ten, and a diary
// that let either be booked into either would either waste half the clinic or
// overrun it.
type VisitType string

const (
	VisitNew         VisitType = "new"
	VisitFollowUp    VisitType = "follow_up"
	VisitProcedure   VisitType = "procedure"
	VisitTeleconsult VisitType = "teleconsult"
	VisitWalkIn      VisitType = "walk_in"
)

var knownVisitTypes = map[VisitType]bool{
	VisitNew: true, VisitFollowUp: true, VisitProcedure: true,
	VisitTeleconsult: true, VisitWalkIn: true,
}

// VisitMode is where the appointment happens (SRS-SCH-015).
type VisitMode string

const (
	ModeInPerson    VisitMode = "in_person"
	ModeTeleconsult VisitMode = "teleconsult"
)

var knownVisitModes = map[VisitMode]bool{ModeInPerson: true, ModeTeleconsult: true}

// Limits on a schedule. Each is a shape that is wrong rather than merely large.
const (
	// MinSlotMinutes. A five-minute clinic slot is a data-entry error; the
	// shortest real one is a vaccination queue, which is a walk-in flow.
	MinSlotMinutes = 5
	// MaxSlotMinutes. Longer than a working day is a block, not a slot.
	MaxSlotMinutes = 8 * 60
	// MaxSlotCapacity bounds group clinics. A slot for two hundred is a
	// campaign, and campaigns do not book by name.
	MaxSlotCapacity = 50
)

// Schedule is one recurring availability rule.
type Schedule struct {
	ID         string
	TenantID   string
	ResourceID string
	FacilityID string
	VisitType  VisitType
	VisitMode  VisitMode
	// Weekday the rule applies to. A separate row per weekday rather than a
	// set, so "Thursdays move to the afternoon in April" is one row changing
	// rather than a rule that has to be split first.
	Weekday time.Weekday
	// StartMinute and EndMinute are minutes from local midnight. Minutes rather
	// than a time.Time because a rule has no date, and a zero date carrying a
	// time reads as 1 January year 1 in every log that prints it.
	StartMinute int
	EndMinute   int
	SlotMinutes int
	// Capacity is how many patients one slot holds. More than one is a group
	// clinic or a double-booked follow-up list, both of which are real.
	Capacity int
	// EffectiveFrom and EffectiveUntil are local dates; Until is exclusive and
	// zero means open-ended. A roster that changes in April is two rows, and
	// the search for a date in March must find the old one.
	EffectiveFrom  time.Time
	EffectiveUntil time.Time
	CreatedAt      time.Time
	UpdatedAt      time.Time
}

// NewSchedule validates and constructs an availability rule.
func NewSchedule(id, tenantID, resourceID, facilityID string, visitType VisitType,
	mode VisitMode, weekday time.Weekday, startMinute, endMinute, slotMinutes,
	capacity int, from, until time.Time, now time.Time) (Schedule, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Schedule{}, fmt.Errorf("%w: schedule id is required", ErrInvalidSchedule)
	case strings.TrimSpace(resourceID) == "":
		return Schedule{}, fmt.Errorf("%w: a schedule needs a resource", ErrInvalidSchedule)
	case !knownVisitTypes[visitType]:
		return Schedule{}, fmt.Errorf("%w: unknown visit type %q", ErrInvalidSchedule, visitType)
	case !knownVisitModes[mode]:
		return Schedule{}, fmt.Errorf("%w: unknown visit mode %q", ErrInvalidSchedule, mode)
	case weekday < time.Sunday || weekday > time.Saturday:
		return Schedule{}, fmt.Errorf("%w: %d is not a weekday", ErrInvalidSchedule, weekday)
	case startMinute < 0 || startMinute >= minutesPerDay:
		return Schedule{}, fmt.Errorf("%w: the start time is outside the day", ErrInvalidSchedule)
	case endMinute <= startMinute:
		// An empty or inverted window silently produces no slots, and a clinic
		// that generates nothing looks exactly like one nobody has booked.
		return Schedule{}, fmt.Errorf("%w: the session ends before it starts", ErrInvalidSchedule)
	case endMinute > minutesPerDay:
		// A session crossing midnight is a night shift, which is two rules.
		// Allowing it here would make every slot generator handle a wraparound.
		return Schedule{}, fmt.Errorf("%w: a session must end on the day it starts",
			ErrInvalidSchedule)
	case slotMinutes < MinSlotMinutes || slotMinutes > MaxSlotMinutes:
		return Schedule{}, fmt.Errorf("%w: a slot of %d minutes is not a clinic slot",
			ErrInvalidSchedule, slotMinutes)
	case capacity < 1 || capacity > MaxSlotCapacity:
		return Schedule{}, fmt.Errorf("%w: a slot capacity of %d is not a clinic",
			ErrInvalidSchedule, capacity)
	case endMinute-startMinute < slotMinutes:
		return Schedule{}, fmt.Errorf("%w: the session is shorter than one slot",
			ErrInvalidSchedule)
	case from.IsZero():
		// SRS-SCH-001 requires effective dates. A rule with no start applies
		// retroactively to every date anybody searches.
		return Schedule{}, fmt.Errorf("%w: a schedule needs an effective date", ErrInvalidSchedule)
	case !until.IsZero() && !until.After(from):
		return Schedule{}, fmt.Errorf("%w: the schedule ends before it begins", ErrInvalidSchedule)
	}

	return Schedule{
		ID: id, TenantID: tenantID, ResourceID: resourceID, FacilityID: facilityID,
		VisitType: visitType, VisitMode: mode, Weekday: weekday,
		StartMinute: startMinute, EndMinute: endMinute,
		SlotMinutes: slotMinutes, Capacity: capacity,
		EffectiveFrom: dateOnly(from), EffectiveUntil: dateOnly(until),
		CreatedAt: now.UTC(), UpdatedAt: now.UTC(),
	}, nil
}

const minutesPerDay = 24 * 60

// AppliesOn reports whether the rule is in force on a local date.
func (s Schedule) AppliesOn(day time.Time) bool {
	day = dateOnly(day)
	if day.Weekday() != s.Weekday {
		return false
	}
	if day.Before(s.EffectiveFrom) {
		return false
	}
	// Until is exclusive: a roster ending on the 30th is available on the 29th.
	if !s.EffectiveUntil.IsZero() && !day.Before(s.EffectiveUntil) {
		return false
	}
	return true
}

// dateOnly strips the time of day, keeping the calendar date in UTC.
//
// Effective dates are dates, not instants: "from 1 April" is a statement about
// a calendar, and attaching a time to it moves the boundary for any site not on
// UTC.
func dateOnly(t time.Time) time.Time {
	if t.IsZero() {
		return time.Time{}
	}
	return time.Date(t.Year(), t.Month(), t.Day(), 0, 0, 0, 0, time.UTC)
}

// Exception is a period removed from a resource's availability (SRS-SCH-002).
type Exception struct {
	ID         string
	TenantID   string
	ResourceID string
	Kind       ExceptionKind
	// StartsAt and EndsAt are instants, half-open [start, end). Instants rather
	// than local times because "on leave from Friday evening" is a real
	// interval and a date-only model rounds it to a whole day in one direction
	// or the other.
	StartsAt time.Time
	EndsAt   time.Time
	Reason   string
	// Overridable permits booking into the blocked period by somebody with the
	// override permission. Annual leave is not overridable; a provisional
	// theatre block often is.
	Overridable bool
	CreatedBy   string
	CreatedAt   time.Time
}

// ExceptionKind is why capacity was removed.
type ExceptionKind string

const (
	ExceptionLeave     ExceptionKind = "leave"
	ExceptionBlock     ExceptionKind = "block"
	ExceptionMeeting   ExceptionKind = "meeting"
	ExceptionTheatre   ExceptionKind = "theatre"
	ExceptionProcedure ExceptionKind = "procedure"
)

var knownExceptionKinds = map[ExceptionKind]bool{
	ExceptionLeave: true, ExceptionBlock: true, ExceptionMeeting: true,
	ExceptionTheatre: true, ExceptionProcedure: true,
}

// MaxExceptionDays bounds one exception. A year of leave in a single row is a
// contract change, not an exception, and blocks a diary nobody can see into.
const MaxExceptionDays = 180

// NewException validates and constructs a blocked period.
func NewException(id, tenantID, resourceID string, kind ExceptionKind,
	startsAt, endsAt time.Time, reason string, overridable bool,
	createdBy string, now time.Time) (Exception, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Exception{}, fmt.Errorf("%w: exception id is required", ErrInvalidSchedule)
	case strings.TrimSpace(resourceID) == "":
		return Exception{}, fmt.Errorf("%w: an exception needs a resource", ErrInvalidSchedule)
	case !knownExceptionKinds[kind]:
		return Exception{}, fmt.Errorf("%w: unknown exception kind %q", ErrInvalidSchedule, kind)
	case startsAt.IsZero() || endsAt.IsZero():
		return Exception{}, fmt.Errorf("%w: an exception needs a start and an end",
			ErrInvalidSchedule)
	case !endsAt.After(startsAt):
		return Exception{}, fmt.Errorf("%w: the exception ends before it starts", ErrInvalidSchedule)
	case endsAt.Sub(startsAt) > MaxExceptionDays*24*time.Hour:
		return Exception{}, fmt.Errorf("%w: an exception longer than %d days is a roster change",
			ErrInvalidSchedule, MaxExceptionDays)
	case strings.TrimSpace(reason) == "":
		// The reason is what a colleague reads when deciding whether to ask for
		// an override. "Blocked" with no reason gets overridden by default.
		return Exception{}, fmt.Errorf("%w: an exception needs a reason", ErrInvalidSchedule)
	case strings.TrimSpace(createdBy) == "":
		return Exception{}, fmt.Errorf("%w: an exception must record who made it",
			ErrInvalidSchedule)
	}

	return Exception{
		ID: id, TenantID: tenantID, ResourceID: resourceID, Kind: kind,
		StartsAt: startsAt.UTC(), EndsAt: endsAt.UTC(),
		Reason: strings.TrimSpace(reason), Overridable: overridable,
		CreatedBy: createdBy, CreatedAt: now.UTC(),
	}, nil
}

// Covers reports whether the exception removes a period.
//
// Half-open on both sides, so a slot that starts exactly when leave ends is
// available and one that ends exactly when leave begins is too. Without that,
// a 09:00–09:15 slot and leave from 09:15 would collide on the boundary and a
// clinic would lose a slot a day to arithmetic.
func (e Exception) Covers(from, until time.Time) bool {
	return from.Before(e.EndsAt) && until.After(e.StartsAt)
}

// SortExceptions orders exceptions by start, so a generated day reads in order.
func SortExceptions(in []Exception) {
	sort.Slice(in, func(i, j int) bool { return in[i].StartsAt.Before(in[j].StartsAt) })
}
