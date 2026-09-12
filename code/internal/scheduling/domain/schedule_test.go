package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/scheduling/domain"
)

func day(y int, m time.Month, d int) time.Time {
	return time.Date(y, m, d, 0, 0, 0, 0, time.UTC)
}

func resource(t *testing.T) domain.Resource {
	t.Helper()

	r, err := domain.NewResource("r-1", "t-1", "f-1", "u-1", domain.ResourcePractitioner,
		"doctor-1", "Dr Rao", "Asia/Kolkata", day(2026, time.March, 1))
	if err != nil {
		t.Fatalf("NewResource: %v", err)
	}
	return r
}

// 09:00 to 13:00 on Tuesdays, fifteen minutes, one at a time.
func tuesdayClinic(t *testing.T) domain.Schedule {
	t.Helper()

	s, err := domain.NewSchedule("s-1", "t-1", "r-1", "f-1", domain.VisitFollowUp,
		domain.ModeInPerson, time.Tuesday, 9*60, 13*60, 15, 1,
		day(2026, time.March, 1), time.Time{}, day(2026, time.March, 1))
	if err != nil {
		t.Fatalf("NewSchedule: %v", err)
	}
	return s
}

// A room is nobody; letting it carry a subject would make "my appointments"
// return a corridor.
func TestOnlyAPractitionerResourceHasASubject(t *testing.T) {
	if _, err := domain.NewResource("r-2", "t-1", "f-1", "", domain.ResourceRoom,
		"doctor-1", "Theatre 3", "Asia/Kolkata", day(2026, time.March, 1)); err == nil {
		t.Fatal("a room was given a subject identity")
	}
	if _, err := domain.NewResource("r-3", "t-1", "f-1", "", domain.ResourcePractitioner,
		"", "Dr Rao", "Asia/Kolkata", day(2026, time.March, 1)); err == nil {
		t.Fatal("a practitioner resource was created with no identity to tie the diary to")
	}
}

// A roster stored with an unloadable zone fails months later, on the day
// somebody tries to book into it.
func TestAResourceTimeZoneIsCheckedAtConstruction(t *testing.T) {
	if _, err := domain.NewResource("r-4", "t-1", "f-1", "", domain.ResourceRoom,
		"", "Theatre 3", "Mars/Olympus", day(2026, time.March, 1)); err == nil {
		t.Fatal("a resource was created with a time zone that cannot be loaded")
	}
}

// An empty or inverted session silently produces no slots, and a clinic that
// generates nothing looks exactly like one nobody has booked.
func TestAScheduleRefusesAnUnusableSession(t *testing.T) {
	cases := map[string]struct{ start, end, slot, capacity int }{
		"ends before it starts": {13 * 60, 9 * 60, 15, 1},
		"empty window":          {9 * 60, 9 * 60, 15, 1},
		"crosses midnight":      {23 * 60, 25 * 60, 15, 1},
		"shorter than one slot": {9 * 60, 9*60 + 10, 15, 1},
		"slot too short":        {9 * 60, 13 * 60, 1, 1},
		"capacity of nobody":    {9 * 60, 13 * 60, 15, 0},
		"capacity of a stadium": {9 * 60, 13 * 60, 15, 5000},
	}
	for name, c := range cases {
		if _, err := domain.NewSchedule("s-x", "t-1", "r-1", "f-1", domain.VisitNew,
			domain.ModeInPerson, time.Tuesday, c.start, c.end, c.slot, c.capacity,
			day(2026, time.March, 1), time.Time{}, day(2026, time.March, 1)); err == nil {
			t.Errorf("%s: was accepted as a schedule", name)
		}
	}
}

// SRS-SCH-001 requires effective dates. A rule with no start applies
// retroactively to every date anybody searches.
func TestAScheduleNeedsAnEffectiveDate(t *testing.T) {
	if _, err := domain.NewSchedule("s-x", "t-1", "r-1", "f-1", domain.VisitNew,
		domain.ModeInPerson, time.Tuesday, 9*60, 13*60, 15, 1,
		time.Time{}, time.Time{}, day(2026, time.March, 1)); err == nil {
		t.Fatal("a schedule with no effective date was accepted")
	}
}

// A roster that changes in April is two rows, and a search for a date in March
// must find the old one.
func TestAScheduleAppliesOnlyWithinItsEffectiveWindow(t *testing.T) {
	s, err := domain.NewSchedule("s-1", "t-1", "r-1", "f-1", domain.VisitNew,
		domain.ModeInPerson, time.Tuesday, 9*60, 13*60, 15, 1,
		day(2026, time.March, 1), day(2026, time.April, 1), day(2026, time.February, 1))
	if err != nil {
		t.Fatalf("NewSchedule: %v", err)
	}

	if s.AppliesOn(day(2026, time.February, 24)) {
		t.Fatal("a schedule applied before its effective date")
	}
	if !s.AppliesOn(day(2026, time.March, 3)) {
		t.Fatal("a schedule did not apply on a Tuesday inside its window")
	}
	// Until is exclusive: a roster ending on 1 April is unavailable on 1 April.
	if s.AppliesOn(day(2026, time.April, 7)) {
		t.Fatal("a schedule applied after it ended")
	}
	if s.AppliesOn(day(2026, time.March, 4)) {
		t.Fatal("a Tuesday schedule applied on a Wednesday")
	}
}

// The generator is the whole of SRS-SCH-003's "reflects active roster".
func TestSlotsAreGeneratedFromTheRoster(t *testing.T) {
	slots, err := domain.GenerateSlots(resource(t),
		[]domain.Schedule{tuesdayClinic(t)}, nil, nil,
		day(2026, time.March, 3), day(2026, time.March, 4))
	if err != nil {
		t.Fatalf("GenerateSlots: %v", err)
	}

	// 09:00 to 13:00 in fifteen-minute slots is sixteen.
	if len(slots) != 16 {
		t.Fatalf("generated %d slots for a four-hour clinic at fifteen minutes, want 16", len(slots))
	}

	// In the resource's own zone, not UTC. A diary is read in local time, and a
	// UTC-only model shows the clinic starting at 03:30.
	kolkata, err := time.LoadLocation("Asia/Kolkata")
	if err != nil {
		t.Fatalf("LoadLocation: %v", err)
	}
	first := slots[0].StartsAt.In(kolkata)
	if first.Hour() != 9 || first.Minute() != 0 {
		t.Fatalf("the first slot is at %02d:%02d local, want 09:00", first.Hour(), first.Minute())
	}
	if !slots[0].EndsAt.Equal(slots[0].StartsAt.Add(15 * time.Minute)) {
		t.Fatal("a fifteen-minute schedule produced a slot of a different length")
	}
}

// A partial slot at the end of a session would overrun the clinic.
func TestASessionDoesNotEndWithAPartialSlot(t *testing.T) {
	s, err := domain.NewSchedule("s-1", "t-1", "r-1", "f-1", domain.VisitNew,
		domain.ModeInPerson, time.Tuesday, 9*60, 9*60+50, 20, 1,
		day(2026, time.March, 1), time.Time{}, day(2026, time.March, 1))
	if err != nil {
		t.Fatalf("NewSchedule: %v", err)
	}

	slots, err := domain.GenerateSlots(resource(t), []domain.Schedule{s}, nil, nil,
		day(2026, time.March, 3), day(2026, time.March, 4))
	if err != nil {
		t.Fatalf("GenerateSlots: %v", err)
	}
	// Fifty minutes at twenty gives two whole slots and ten minutes left over.
	if len(slots) != 2 {
		t.Fatalf("generated %d slots, want 2 whole ones with the remainder dropped", len(slots))
	}
}

// The other half of SRS-SCH-003's criterion: "and exceptions".
func TestAnExceptionRemovesCapacity(t *testing.T) {
	kolkata, _ := time.LoadLocation("Asia/Kolkata")
	morningOff, err := domain.NewException("e-1", "t-1", "r-1", domain.ExceptionLeave,
		time.Date(2026, time.March, 3, 9, 0, 0, 0, kolkata),
		time.Date(2026, time.March, 3, 11, 0, 0, 0, kolkata),
		"annual leave", false, "admin-1", day(2026, time.February, 1))
	if err != nil {
		t.Fatalf("NewException: %v", err)
	}

	slots, err := domain.GenerateSlots(resource(t), []domain.Schedule{tuesdayClinic(t)},
		[]domain.Exception{morningOff}, nil,
		day(2026, time.March, 3), day(2026, time.March, 4))
	if err != nil {
		t.Fatalf("GenerateSlots: %v", err)
	}

	available := domain.Available(slots, false)
	// Two hours of a four-hour clinic at fifteen minutes: eight remain.
	if len(available) != 8 {
		t.Fatalf("%d slots survived two hours of leave, want 8", len(available))
	}
	for _, s := range available {
		if s.StartsAt.In(kolkata).Hour() < 11 {
			t.Fatalf("a slot at %v is inside the leave period", s.StartsAt.In(kolkata))
		}
	}
}

// Half-open on both sides: a slot starting exactly when leave ends is
// available. Without this a clinic loses a slot a day to arithmetic.
func TestAnExceptionDoesNotEatTheBoundarySlot(t *testing.T) {
	kolkata, _ := time.LoadLocation("Asia/Kolkata")
	block, err := domain.NewException("e-1", "t-1", "r-1", domain.ExceptionMeeting,
		time.Date(2026, time.March, 3, 9, 0, 0, 0, kolkata),
		time.Date(2026, time.March, 3, 9, 30, 0, 0, kolkata),
		"departmental meeting", false, "admin-1", day(2026, time.February, 1))
	if err != nil {
		t.Fatalf("NewException: %v", err)
	}

	slots, err := domain.GenerateSlots(resource(t), []domain.Schedule{tuesdayClinic(t)},
		[]domain.Exception{block}, nil, day(2026, time.March, 3), day(2026, time.March, 4))
	if err != nil {
		t.Fatalf("GenerateSlots: %v", err)
	}

	available := domain.Available(slots, false)
	if len(available) != 14 {
		t.Fatalf("%d slots survived a thirty-minute block, want 14", len(available))
	}
	if got := available[0].StartsAt.In(kolkata); got.Hour() != 9 || got.Minute() != 30 {
		t.Fatalf("the first available slot is %02d:%02d, want 09:30 — the slot "+
			"starting exactly when the block ends", got.Hour(), got.Minute())
	}
}

// SRS-SCH-002: blocked capacity cannot be booked unless override permission.
func TestABlockedSlotIsVisibleOnlyToSomebodyWhoCanOverrideIt(t *testing.T) {
	kolkata, _ := time.LoadLocation("Asia/Kolkata")
	provisional, err := domain.NewException("e-1", "t-1", "r-1", domain.ExceptionTheatre,
		time.Date(2026, time.March, 3, 9, 0, 0, 0, kolkata),
		time.Date(2026, time.March, 3, 10, 0, 0, 0, kolkata),
		"provisional theatre list", true, "admin-1", day(2026, time.February, 1))
	if err != nil {
		t.Fatalf("NewException: %v", err)
	}

	slots, err := domain.GenerateSlots(resource(t), []domain.Schedule{tuesdayClinic(t)},
		[]domain.Exception{provisional}, nil, day(2026, time.March, 3), day(2026, time.March, 4))
	if err != nil {
		t.Fatalf("GenerateSlots: %v", err)
	}

	if got := len(domain.Available(slots, false)); got != 12 {
		t.Fatalf("a clerk sees %d slots, want 12 with the blocked hour hidden", got)
	}

	withOverride := domain.Available(slots, true)
	if len(withOverride) != 16 {
		t.Fatalf("a scheduler with override sees %d slots, want all 16", len(withOverride))
	}
	// And they can see it is blocked and why, or they cannot judge whether to
	// override it.
	if !withOverride[0].Blocked || withOverride[0].BlockedReason != "provisional theatre list" {
		t.Fatalf("the blocked slot does not say why: %+v", withOverride[0])
	}
}

// Annual leave is not a suggestion, and a later overridable block must not
// soften it by iteration order.
func TestANonOverridableExceptionWins(t *testing.T) {
	kolkata, _ := time.LoadLocation("Asia/Kolkata")
	from := time.Date(2026, time.March, 3, 9, 0, 0, 0, kolkata)
	until := time.Date(2026, time.March, 3, 10, 0, 0, 0, kolkata)

	leave, _ := domain.NewException("e-1", "t-1", "r-1", domain.ExceptionLeave,
		from, until, "annual leave", false, "admin-1", day(2026, time.February, 1))
	provisional, _ := domain.NewException("e-2", "t-1", "r-1", domain.ExceptionTheatre,
		from, until, "provisional list", true, "admin-1", day(2026, time.February, 1))

	slots, err := domain.GenerateSlots(resource(t), []domain.Schedule{tuesdayClinic(t)},
		[]domain.Exception{leave, provisional}, nil,
		day(2026, time.March, 3), day(2026, time.March, 4))
	if err != nil {
		t.Fatalf("GenerateSlots: %v", err)
	}

	// Even with override, the hour under annual leave stays unbookable.
	for _, s := range domain.Available(slots, true) {
		if s.StartsAt.In(kolkata).Hour() < 10 {
			t.Fatalf("a slot at %v survived annual leave because an overridable "+
				"block was also present", s.StartsAt.In(kolkata))
		}
	}
}

// A roster that still generated slots on a bank holiday would let a patient
// book a locked door.
func TestAFacilityClosureRemovesTheWholeDay(t *testing.T) {
	closures := map[string]bool{"2026-03-03": true}

	slots, err := domain.GenerateSlots(resource(t), []domain.Schedule{tuesdayClinic(t)},
		nil, closures, day(2026, time.March, 3), day(2026, time.March, 4))
	if err != nil {
		t.Fatalf("GenerateSlots: %v", err)
	}
	if len(slots) != 0 {
		t.Fatalf("generated %d slots on a day the facility is closed", len(slots))
	}
}

// A full slot is not bookable capacity, whatever the roster says.
func TestAFullSlotIsNotOffered(t *testing.T) {
	slots, err := domain.GenerateSlots(resource(t), []domain.Schedule{tuesdayClinic(t)},
		nil, nil, day(2026, time.March, 3), day(2026, time.March, 4))
	if err != nil {
		t.Fatalf("GenerateSlots: %v", err)
	}

	booked := map[domain.SlotKey]int{slots[0].Key(): 1}
	withBookings := domain.ApplyBookings(slots, booked)

	if withBookings[0].Remaining() != 0 || withBookings[0].Bookable() {
		t.Fatalf("a slot at capacity reports itself bookable: %+v", withBookings[0])
	}
	if got := len(domain.Available(withBookings, false)); got != 15 {
		t.Fatalf("%d slots offered with one full, want 15", got)
	}
}

// Generating a year per search is how the search endpoint becomes the slow one.
func TestASearchRangeIsBounded(t *testing.T) {
	if _, err := domain.GenerateSlots(resource(t), []domain.Schedule{tuesdayClinic(t)},
		nil, nil, day(2026, time.March, 1), day(2027, time.March, 1)); err == nil {
		t.Fatal("a year-long slot search was generated")
	}
	if _, err := domain.GenerateSlots(resource(t), []domain.Schedule{tuesdayClinic(t)},
		nil, nil, day(2026, time.March, 4), day(2026, time.March, 3)); err == nil {
		t.Fatal("an inverted search range was accepted")
	}
}

// An exception with no reason gets overridden by default, because the colleague
// deciding has nothing to read.
func TestAnExceptionNeedsAReasonAndAnAuthor(t *testing.T) {
	from := day(2026, time.March, 3)
	until := from.Add(time.Hour)

	if _, err := domain.NewException("e-1", "t-1", "r-1", domain.ExceptionLeave,
		from, until, "", false, "admin-1", from); err == nil {
		t.Fatal("an exception was created with no reason")
	}
	if _, err := domain.NewException("e-1", "t-1", "r-1", domain.ExceptionLeave,
		from, until, "annual leave", false, "", from); err == nil {
		t.Fatal("an exception was created with no author")
	}
}

// A year of leave in one row is a contract change, and it blocks a diary
// nobody can see into.
func TestAnExceptionIsBounded(t *testing.T) {
	from := day(2026, time.March, 3)
	if _, err := domain.NewException("e-1", "t-1", "r-1", domain.ExceptionLeave,
		from, from.AddDate(1, 0, 0), "sabbatical", false, "admin-1", from); err == nil {
		t.Fatal("a year-long exception was accepted")
	}
}

// SRS-SCH-014 asks for "a domain-specific unavailability error": a client that
// cannot tell "this clinician has left" from "the server is busy" retries the
// first forever.
func TestAnUnavailableResourceReportsWhy(t *testing.T) {
	r := resource(t)
	r.Status = domain.ResourceInactive

	if r.Bookable() {
		t.Fatal("an inactive resource reports itself bookable")
	}

	var notBookable domain.ErrNotBookable
	err := error(domain.ErrNotBookable{Kind: "resource", ID: r.ID, Why: "no longer in service"})
	if !errors.As(err, &notBookable) {
		t.Fatal("the unavailability error is not distinguishable by type")
	}
	if notBookable.ID != r.ID {
		t.Fatalf("the error does not name what is unavailable: %+v", notBookable)
	}
}
