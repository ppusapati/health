package domain

import (
	"errors"
	"fmt"
	"strings"
	"time"
)

// Facility calendars and holidays (SRS-PLT-016).
//
// Kept independent of provider rosters on purpose. A hospital is closed on a
// public holiday whether or not anybody was rostered, and a consultant's leave
// does not close the hospital. Systems that conflate the two end up with
// cancelling a roster accidentally opening the building, which is discovered
// when somebody arrives for an appointment.

// CalendarEntryType distinguishes why a facility's hours differ.
type CalendarEntryType string

const (
	EntryHoliday        CalendarEntryType = "holiday"
	EntryClosure        CalendarEntryType = "closure"
	EntryReducedHours   CalendarEntryType = "reduced_hours"
	EntrySpecialOpening CalendarEntryType = "special_opening"
)

var validEntryTypes = map[CalendarEntryType]bool{
	EntryHoliday: true, EntryClosure: true,
	EntryReducedHours: true, EntrySpecialOpening: true,
}

// CalendarEntry is one period in a facility's calendar.
type CalendarEntry struct {
	ID         string
	TenantID   string
	FacilityID string
	Type       CalendarEntryType
	// StartsOn and EndsOn are local dates, inclusive at both ends. Dates, not
	// instants: "closed on 2 October" is a statement about the facility's own
	// calendar, and converting it to UTC would move the boundary for any site
	// east of Greenwich.
	StartsOn time.Time
	EndsOn   time.Time
	Label    string
	// OverridePermitted says whether an authorised user may book into this
	// period anyway. An emergency department runs through every holiday; an
	// outpatient clinic does not.
	OverridePermitted bool
	CreatedAt         time.Time
	UpdatedAt         time.Time
}

// ErrInvalidCalendarEntry reports an entry that must not be stored.
var ErrInvalidCalendarEntry = errors.New("organization: invalid calendar entry")

// ErrFacilityClosed reports activity aimed at a facility that is not open.
var ErrFacilityClosed = errors.New("organization: facility is closed on that date")

// NewCalendarEntry validates and constructs an entry.
func NewCalendarEntry(id, tenantID, facilityID string, entryType CalendarEntryType,
	startsOn, endsOn time.Time, label string, overridePermitted bool, now time.Time) (CalendarEntry, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return CalendarEntry{}, fmt.Errorf("%w: id is required", ErrInvalidCalendarEntry)
	case strings.TrimSpace(tenantID) == "" || strings.TrimSpace(facilityID) == "":
		return CalendarEntry{}, fmt.Errorf("%w: tenant and facility are required", ErrInvalidCalendarEntry)
	case !validEntryTypes[entryType]:
		return CalendarEntry{}, fmt.Errorf("%w: unknown entry type %q", ErrInvalidCalendarEntry, entryType)
	case startsOn.IsZero() || endsOn.IsZero():
		return CalendarEntry{}, fmt.Errorf("%w: start and end dates are required", ErrInvalidCalendarEntry)
	case endsOn.Before(startsOn):
		return CalendarEntry{}, fmt.Errorf("%w: end date is before start date", ErrInvalidCalendarEntry)
	case strings.TrimSpace(label) == "":
		// The label is what a clerk sees when told they cannot book. "Closed"
		// is not an answer; "Diwali" is.
		return CalendarEntry{}, fmt.Errorf("%w: a label is required", ErrInvalidCalendarEntry)
	}

	return CalendarEntry{
		ID: id, TenantID: tenantID, FacilityID: facilityID, Type: entryType,
		StartsOn: truncateToDate(startsOn), EndsOn: truncateToDate(endsOn),
		Label: label, OverridePermitted: overridePermitted,
		CreatedAt: now.UTC(), UpdatedAt: now.UTC(),
	}, nil
}

func truncateToDate(t time.Time) time.Time {
	return time.Date(t.Year(), t.Month(), t.Day(), 0, 0, 0, 0, time.UTC)
}

// Covers reports whether the entry applies to a date.
func (e CalendarEntry) Covers(date time.Time) bool {
	d := truncateToDate(date)
	return !d.Before(e.StartsOn) && !d.After(e.EndsOn)
}

// Closes reports whether this entry stops normal activity.
//
// A special opening does the opposite — it is how a facility runs a clinic on
// a day it would otherwise be shut — so it must not be treated as a closure
// merely because it is an entry in the calendar.
func (e CalendarEntry) Closes() bool {
	return e.Type == EntryHoliday || e.Type == EntryClosure
}

// SchedulingDecision is the outcome of a calendar check.
type SchedulingDecision struct {
	Permitted bool
	// Reason is a stable code.
	Reason string
	// Label names the entry, so the user is told why rather than just no.
	Label string
	// OverrideAvailable reports whether an authorised user could proceed.
	OverrideAvailable bool
}

// Stable calendar reason codes.
const (
	ReasonFacilityOpen         = "FACILITY_OPEN"
	ReasonFacilityClosed       = "FACILITY_CLOSED"
	ReasonClosedOverridden     = "FACILITY_CLOSED_OVERRIDDEN"
	ReasonOverrideNotPermitted = "FACILITY_CLOSURE_NOT_OVERRIDABLE"
)

// AuthorizeScheduling decides whether something may be booked on a date.
//
// SRS-PLT-016's verification clause: "scheduling respects facility closure
// unless override authorized". Two separate conditions have to hold for an
// override — the entry must permit one, and the caller must be authorised —
// and they are separate parameters so neither can be inferred from the other.
//
// A special opening beats a closure on the same date. That is the case it
// exists for: a facility declares itself shut for a holiday period and then
// opens for one clinic within it.
func AuthorizeScheduling(entries []CalendarEntry, date time.Time,
	callerMayOverride bool) SchedulingDecision {

	var closure *CalendarEntry
	for i := range entries {
		e := entries[i]
		if !e.Covers(date) {
			continue
		}
		if e.Type == EntrySpecialOpening {
			return SchedulingDecision{Permitted: true, Reason: ReasonFacilityOpen, Label: e.Label}
		}
		if e.Closes() && closure == nil {
			closure = &entries[i]
		}
	}

	if closure == nil {
		return SchedulingDecision{Permitted: true, Reason: ReasonFacilityOpen}
	}
	if !closure.OverridePermitted {
		return SchedulingDecision{
			Permitted: false, Reason: ReasonOverrideNotPermitted,
			Label: closure.Label, OverrideAvailable: false,
		}
	}
	if !callerMayOverride {
		return SchedulingDecision{
			Permitted: false, Reason: ReasonFacilityClosed,
			Label: closure.Label, OverrideAvailable: true,
		}
	}
	return SchedulingDecision{
		Permitted: true, Reason: ReasonClosedOverridden,
		Label: closure.Label, OverrideAvailable: true,
	}
}
