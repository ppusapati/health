package domain

import (
	"fmt"
	"sort"
	"time"
)

// Slot generation and capacity (SRS-SCH-003, SRS-SCH-004).
//
// Slots are generated from the roster on every search rather than materialised
// in advance, because a materialised diary goes stale the instant a roster
// changes and the stale entries are indistinguishable from the good ones. The
// acceptance criterion — "slot search reflects active roster and exceptions" —
// then holds by construction instead of by a refresh job nobody notices has
// stopped.
//
// A slot row is written only where capacity is actually consumed, and it exists
// for exactly one reason: to be the row a booking locks. SRS-SCH-004 requires
// booking to be atomic and to not exceed capacity under concurrency, and the
// only thing that reliably delivers that is a single statement taking a row
// lock — the same reasoning as the numbering sequence behind SRS-EMPI-016. A
// check-then-insert is a race that two concurrent bookings both win.

// Slot is one bookable period on a resource's diary.
type Slot struct {
	ResourceID string
	FacilityID string
	OrgUnitID  string
	VisitType  VisitType
	VisitMode  VisitMode
	StartsAt   time.Time
	EndsAt     time.Time
	Capacity   int
	// Booked is how much of the capacity is taken. Zero for a slot that has
	// never been booked, which is most of them and is why slot rows are not
	// written in advance.
	Booked int
	// Blocked reports a slot inside an exception. Returned rather than dropped
	// when the caller holds the override permission, because a scheduler
	// booking into a provisional theatre block needs to see that it is blocked
	// and why (SRS-SCH-002).
	Blocked       bool
	BlockedReason string
	BlockedKind   ExceptionKind
	// BlockOverridable says whether the exception that blocked this slot
	// permits booking into it at all. Carried onto the slot rather than left
	// with the exception because Available would otherwise have to ask "was
	// this blocked, and by what" — and a version that asked only the first
	// question let an override bypass annual leave.
	BlockOverridable bool
}

// Remaining is the capacity still available.
func (s Slot) Remaining() int {
	if s.Booked >= s.Capacity {
		return 0
	}
	return s.Capacity - s.Booked
}

// Bookable reports whether this slot can take another patient without an
// override.
func (s Slot) Bookable() bool { return s.Remaining() > 0 && !s.Blocked }

// BookableWithOverride reports whether somebody holding the override permission
// may book into this slot. False for a non-overridable block whoever asks.
func (s Slot) BookableWithOverride() bool {
	if s.Remaining() == 0 {
		return false
	}
	return !s.Blocked || s.BlockOverridable
}

// MaxSearchDays bounds a slot search.
//
// Ninety days because a diary open further out than a quarter is a waiting
// list, not a schedule, and generating a year of slots per search is how the
// search endpoint becomes the slow one.
const MaxSearchDays = 90

// GenerateSlots expands schedules into slots over a local date range.
//
// from and until are local dates; until is exclusive. Everything is computed in
// the resource's own zone and returned as instants, because a diary is written
// in local time and stored as a moment: "09:00 Tuesday" moves by an hour twice
// a year, and a UTC-only model books half the clinic into the wrong hour on the
// two days that matter most.
//
// closures are whole local dates the facility is shut (SRS-PLT-016). They are
// applied here rather than by the caller so that a search, a booking check and
// a waitlist offer cannot disagree about whether the hospital is open.
func GenerateSlots(resource Resource, schedules []Schedule, exceptions []Exception,
	closures map[string]bool, from, until time.Time) ([]Slot, error) {

	location, err := time.LoadLocation(resource.TimeZone)
	if err != nil {
		return nil, fmt.Errorf("%w: resource %s has an unloadable time zone %q",
			ErrInvalidResource, resource.ID, resource.TimeZone)
	}

	from, until = dateOnly(from), dateOnly(until)
	if !until.After(from) {
		return nil, fmt.Errorf("%w: the search range ends before it starts", ErrInvalidSchedule)
	}
	if until.Sub(from) > MaxSearchDays*24*time.Hour {
		return nil, fmt.Errorf("%w: a search may cover at most %d days",
			ErrInvalidSchedule, MaxSearchDays)
	}

	var out []Slot
	for day := from; day.Before(until); day = day.AddDate(0, 0, 1) {
		if closures[day.Format("2006-01-02")] {
			// The facility is shut. A roster that still generated slots here
			// would let a patient book a bank holiday, and the first anybody
			// would know is the patient at a locked door.
			continue
		}

		for _, schedule := range schedules {
			if !schedule.AppliesOn(day) {
				continue
			}
			out = append(out, expandDay(resource, schedule, exceptions, day, location)...)
		}
	}

	sort.Slice(out, func(i, j int) bool {
		if !out[i].StartsAt.Equal(out[j].StartsAt) {
			return out[i].StartsAt.Before(out[j].StartsAt)
		}
		return out[i].VisitType < out[j].VisitType
	})
	return out, nil
}

// expandDay walks one session, slot by slot.
func expandDay(resource Resource, schedule Schedule, exceptions []Exception,
	day time.Time, location *time.Location) []Slot {

	// Midnight local on that calendar date, then minutes added. Constructed
	// this way rather than by adding a duration to a UTC instant so a daylight
	// saving transition moves the whole session with the clock, which is what
	// the people reading the diary expect.
	midnight := time.Date(day.Year(), day.Month(), day.Day(), 0, 0, 0, 0, location)

	var out []Slot
	for minute := schedule.StartMinute; minute+schedule.SlotMinutes <= schedule.EndMinute; minute += schedule.SlotMinutes {
		startsAt := midnight.Add(time.Duration(minute) * time.Minute)
		endsAt := startsAt.Add(time.Duration(schedule.SlotMinutes) * time.Minute)

		slot := Slot{
			ResourceID: resource.ID, FacilityID: resource.FacilityID,
			OrgUnitID: resource.OrgUnitID,
			VisitType: schedule.VisitType, VisitMode: schedule.VisitMode,
			StartsAt: startsAt.UTC(), EndsAt: endsAt.UTC(),
			Capacity: schedule.Capacity,
		}

		for _, exception := range exceptions {
			if exception.ResourceID != resource.ID {
				continue
			}
			if !exception.Covers(slot.StartsAt, slot.EndsAt) {
				continue
			}
			slot.Blocked = true
			slot.BlockedKind = exception.Kind
			slot.BlockedReason = exception.Reason
			slot.BlockOverridable = exception.Overridable
			if !exception.Overridable {
				// A non-overridable exception wins outright. Annual leave is
				// not a suggestion, and letting a later overridable block
				// soften it would be decided by iteration order.
				break
			}
		}

		out = append(out, slot)
	}
	return out
}

// ApplyBookings fills in consumed capacity from the slot rows that exist.
//
// Keyed on the slot's start and visit type: those are what a slot row is
// identified by, and a booking that did not line up with a generated slot is a
// booking against a roster that has since changed. Such a slot is not returned
// as available — the capacity is genuinely spoken for, whatever the roster now
// says.
func ApplyBookings(slots []Slot, booked map[SlotKey]int) []Slot {
	out := make([]Slot, 0, len(slots))
	for _, slot := range slots {
		slot.Booked = booked[slot.Key()]
		out = append(out, slot)
	}
	return out
}

// SlotKey identifies a slot row.
//
// The resource, the instant and the visit type. Not the schedule id: a roster
// edited after a booking would otherwise orphan the capacity it consumed, and
// the appointment would still exist while the slot it sat in reported itself
// empty.
type SlotKey struct {
	ResourceID string
	StartsAt   time.Time
	VisitType  VisitType
}

// Key returns the slot's identity.
func (s Slot) Key() SlotKey {
	return SlotKey{ResourceID: s.ResourceID, StartsAt: s.StartsAt, VisitType: s.VisitType}
}

// Available filters to the slots a caller may actually book.
//
// canOverride keeps *overridable* blocked slots in the result, marked, so a
// scheduler with the permission sees what they are booking into and why it was
// blocked (SRS-SCH-002). Everybody else sees only free capacity, which is the
// SRS-SCH-003 criterion: "only bookable capacity is returned".
//
// An exception that is not overridable stays hidden from everybody. Annual
// leave is not a permission question: the clinician is not there, and a
// permission that could conjure them up would be a permission to book a patient
// in to see nobody.
func Available(slots []Slot, canOverride bool) []Slot {
	out := make([]Slot, 0, len(slots))
	for _, slot := range slots {
		if slot.Remaining() == 0 {
			continue
		}
		if slot.Blocked && !(canOverride && slot.BlockOverridable) {
			continue
		}
		out = append(out, slot)
	}
	return out
}
