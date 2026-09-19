package domain_test

import (
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/theatre/domain"
)

var at = time.Date(2026, 9, 17, 8, 0, 0, 0, time.UTC)

func request(t *testing.T, mutate func(*domain.NewCaseInput)) (domain.Case, []string) {
	t.Helper()

	in := domain.NewCaseInput{
		EncounterID: "enc-1", PatientID: "pat-1", FacilityID: "fac-1",
		ProcedureCode: "M65.3", ProcedureDisplay: "Trigger finger release",
		DiagnosisCode: "M65.3", DiagnosisDisplay: "Trigger finger",
		Laterality: domain.LateralityRight, Site: "right ring finger",
		Urgency: domain.UrgencyElective, ExpectedDuration: 30 * time.Minute,
		SurgeonID: "surgeon-1", SideRequired: true,
	}
	if mutate != nil {
		mutate(&in)
	}
	c, outstanding, err := domain.NewCase("case-1", "tenant-1", in, "surgeon-1", at)
	if err != nil {
		t.Fatalf("NewCase: %v", err)
	}
	return c, outstanding
}

// SRS-OT-002: "request enters schedulable state only after required fields".
// A request missing them is recorded rather than refused — a surgeon who
// cannot put a patient on a list at all is a surgeon keeping a paper list.
func TestAnIncompleteRequestIsRecordedAndNotSchedulable(t *testing.T) {
	c, outstanding := request(t, func(in *domain.NewCaseInput) {
		in.SurgeonID = ""
		in.ExpectedDuration = 0
	})

	if c.Status != domain.CaseRequested {
		t.Fatalf("status = %q, want requested", c.Status)
	}
	if len(outstanding) != 2 {
		t.Fatalf("outstanding = %v, want the surgeon and the duration", outstanding)
	}

	complete, _ := request(t, nil)
	if complete.Status != domain.CaseSchedulable {
		t.Fatalf("status = %q on a complete request", complete.Status)
	}
}

// Wrong-site surgery is the never-event the whole checklist exists to prevent,
// and it starts with the request. A procedure that has sides and has not said
// which is not schedulable.
func TestAProcedureWithSidesNamesTheSide(t *testing.T) {
	c, outstanding := request(t, func(in *domain.NewCaseInput) {
		in.Laterality = domain.LateralityUnspecified
	})

	found := false
	for _, item := range outstanding {
		if item == "laterality" {
			found = true
		}
	}
	if !found {
		t.Fatalf("outstanding = %v, want laterality", outstanding)
	}
	if c.Status == domain.CaseSchedulable {
		t.Fatal("a case with no side was schedulable")
	}

	// A procedure without sides needs none.
	noSides, outstanding := request(t, func(in *domain.NewCaseInput) {
		in.SideRequired = false
		in.Laterality = domain.LateralityUnspecified
	})
	if len(outstanding) != 0 {
		t.Fatalf("outstanding = %v on a procedure with no sides", outstanding)
	}
	if noSides.Laterality != domain.LateralityNotApplicable {
		t.Fatalf("laterality = %q", noSides.Laterality)
	}
}

// SRS-OT-003. The reason is required in both directions: moving a case up is
// the decision somebody asks about afterwards, and moving one down is the
// decision the patient asks about.
func TestChangingPriorityNeedsAReasonInBothDirections(t *testing.T) {
	c, _ := request(t, nil)

	if err := c.Reprioritise(domain.UrgencyUrgent, "", at); err == nil {
		t.Fatal("an unexplained upgrade was accepted")
	}
	if err := c.Reprioritise(domain.UrgencyUrgent, "rapidly worsening", at); err != nil {
		t.Fatalf("Reprioritise up: %v", err)
	}
	if err := c.Reprioritise(domain.UrgencyElective, "", at); err == nil {
		t.Fatal("an unexplained downgrade was accepted")
	}
	if !errors.Is(c.Reprioritise(domain.UrgencyUrgent, "again", at),
		domain.ErrInvalidCase) {
		t.Fatal("a case was reprioritised to the urgency it already had")
	}
}

// SRS-OT-004: every clash at once, and a hard one is never overridable. A
// scheduler told one clash at a time rebooks once per clash while a list is
// being built, and overriding "another case is in this room" does not make a
// second theatre appear.
func TestASlotReportsEveryClashAndHardOnesCannotBeOverridden(t *testing.T) {
	c, _ := request(t, func(in *domain.NewCaseInput) {
		in.Requirements = []string{"image intensifier"}
	})

	room := domain.Room{
		ID: "room-1", Code: "OT1", Active: true,
		Equipment: []string{"laminar flow"},
	}
	booked := domain.Case{
		ID: "case-2", Status: domain.CaseScheduled, RoomID: "room-1",
		ScheduledStart: at, ScheduledEnd: at.Add(time.Hour),
	}

	conflicts := c.CheckSlot(domain.ScheduleRequest{
		RoomID: "room-1", Start: at.Add(30 * time.Minute),
		End: at.Add(90 * time.Minute),
	}, domain.SchedulingContext{Room: room, Booked: []domain.Case{booked}},
		at.Add(-time.Hour))

	if len(conflicts) != 2 {
		t.Fatalf("%d conflicts, want the missing equipment and the clash: %v",
			len(conflicts), conflicts)
	}

	var hard, soft int
	for _, conflict := range conflicts {
		if conflict.Overridable {
			soft++
		} else {
			hard++
		}
	}
	if hard != 1 || soft != 1 {
		t.Fatalf("conflicts = %v; the room clash is hard and the equipment is soft",
			conflicts)
	}

	if err := c.Schedule(domain.ScheduleRequest{RoomID: "room-1"},
		conflicts, true, at); err == nil {
		t.Fatal("a hard conflict was overridden")
	}
}

// A surgeon in two theatres at once is the conflict a room-only check misses.
func TestASurgeonCannotBeInTwoTheatresAtOnce(t *testing.T) {
	c, _ := request(t, nil)
	room := domain.Room{ID: "room-2", Code: "OT2", Active: true}

	elsewhere := domain.Case{
		ID: "case-3", Status: domain.CaseScheduled, SurgeonID: "surgeon-1",
		RoomID: "room-9", ScheduledStart: at, ScheduledEnd: at.Add(2 * time.Hour),
	}

	conflicts := c.CheckSlot(domain.ScheduleRequest{
		RoomID: "room-2", Start: at.Add(time.Hour), End: at.Add(90 * time.Minute),
	}, domain.SchedulingContext{
		Room: room, SurgeonBusy: []domain.Case{elsewhere},
	}, at.Add(-time.Hour))

	if len(conflicts) != 1 || conflicts[0].Kind != "surgeon" {
		t.Fatalf("conflicts = %v, want the surgeon clash", conflicts)
	}
	if conflicts[0].Overridable {
		t.Fatal("the surgeon clash was overridable")
	}
}

// A case ending exactly when the next begins is how a list is built, and
// treating it as a clash would make every list unschedulable.
func TestBackToBackCasesDoNotClash(t *testing.T) {
	c, _ := request(t, nil)
	room := domain.Room{ID: "room-1", Code: "OT1", Active: true}
	booked := domain.Case{
		ID: "case-2", Status: domain.CaseScheduled, RoomID: "room-1",
		ScheduledStart: at, ScheduledEnd: at.Add(time.Hour),
	}

	conflicts := c.CheckSlot(domain.ScheduleRequest{
		RoomID: "room-1", Start: at.Add(time.Hour), End: at.Add(90 * time.Minute),
	}, domain.SchedulingContext{Room: room, Booked: []domain.Case{booked}},
		at.Add(-time.Hour))
	if len(conflicts) != 0 {
		t.Fatalf("conflicts = %v for a case starting as the previous one ends",
			conflicts)
	}
}

// A room under planned downtime is closed, and that is not a soft constraint.
func TestAClosedRoomCannotBeBooked(t *testing.T) {
	c, _ := request(t, nil)
	room := domain.Room{ID: "room-1", Code: "OT1", Active: true}
	downtime := domain.Block{
		RoomID: "room-1", Kind: domain.BlockDowntime,
		StartsAt: at, EndsAt: at.Add(8 * time.Hour), Note: "deep clean",
	}

	conflicts := c.CheckSlot(domain.ScheduleRequest{
		RoomID: "room-1", Start: at.Add(time.Hour), End: at.Add(2 * time.Hour),
	}, domain.SchedulingContext{Room: room, Blocks: []domain.Block{downtime}},
		at.Add(-time.Hour))

	if len(conflicts) != 1 || conflicts[0].Overridable {
		t.Fatalf("conflicts = %v, want one hard closure", conflicts)
	}
	if !strings.Contains(conflicts[0].Detail, "deep clean") {
		t.Fatalf("detail = %q, want it to say why the room is closed",
			conflicts[0].Detail)
	}
}

// SRS-OT-005. A free-text cause produces a report nobody can act on: the
// hospital that cancels for want of a bed and the one whose patients do not
// attend need different fixes.
func TestACancellationIsClassified(t *testing.T) {
	c, _ := request(t, nil)

	if err := c.Cancel(domain.OutcomeNone, "no bed", "", at); err == nil {
		t.Fatal("a cancellation with no coded cause was accepted")
	}
	if err := c.Cancel(domain.OutcomeResource, "", "", at); err == nil {
		t.Fatal("a cancellation with no specific reason was accepted")
	}
	if err := c.Cancel(domain.OutcomeResource, "no critical care bed", "", at); err != nil {
		t.Fatalf("Cancel: %v", err)
	}
	if c.Status != domain.CaseCancelled || c.Outcome != domain.OutcomeResource {
		t.Fatalf("case = %q / %q", c.Status, c.Outcome)
	}
}

// A postponed case goes back to waiting rather than staying booked in a room
// it is not using.
func TestAPostponedCaseReleasesItsSlot(t *testing.T) {
	c, _ := request(t, nil)
	room := domain.Room{ID: "room-1", Code: "OT1", Active: true}
	if err := c.Schedule(domain.ScheduleRequest{
		RoomID: "room-1", Start: at.Add(time.Hour), End: at.Add(2 * time.Hour),
	}, c.CheckSlot(domain.ScheduleRequest{
		RoomID: "room-1", Start: at.Add(time.Hour), End: at.Add(2 * time.Hour),
	}, domain.SchedulingContext{Room: room}, at), false, at); err != nil {
		t.Fatalf("Schedule: %v", err)
	}

	if err := c.Postpone(domain.OutcomePatient, "did not attend", "", at); err != nil {
		t.Fatalf("Postpone: %v", err)
	}
	if c.RoomID != "" || !c.ScheduledStart.IsZero() {
		t.Fatalf("the postponed case still holds room %q at %v",
			c.RoomID, c.ScheduledStart)
	}

	// And it is back on the waiting list.
	waiting := domain.WaitingList([]domain.Case{c})
	if len(waiting) != 1 {
		t.Fatal("a postponed case left the waiting list")
	}
}

// Urgency first, then how long they have waited. A case upgraded this morning
// goes ahead of one that has waited six weeks, and a list sorted on waiting
// time alone needs somebody to override it every day.
func TestTheWaitingListSortsOnUrgencyThenWait(t *testing.T) {
	old := domain.Case{
		ID: "old", Status: domain.CaseSchedulable, Urgency: domain.UrgencyElective,
		RequestedAt: at.Add(-6 * 7 * 24 * time.Hour),
	}
	urgent := domain.Case{
		ID: "urgent", Status: domain.CaseSchedulable, Urgency: domain.UrgencyUrgent,
		RequestedAt: at,
	}
	recent := domain.Case{
		ID: "recent", Status: domain.CaseSchedulable, Urgency: domain.UrgencyElective,
		RequestedAt: at.Add(-24 * time.Hour),
	}

	list := domain.WaitingList([]domain.Case{recent, old, urgent})
	if len(list) != 3 {
		t.Fatalf("%d waiting, want 3", len(list))
	}
	if list[0].ID != "urgent" || list[1].ID != "old" || list[2].ID != "recent" {
		t.Fatalf("order = %s, %s, %s", list[0].ID, list[1].ID, list[2].ID)
	}
}

// SRS-OT-006. An item nobody has answered counts as unmet: a checklist that
// treated silence as consent would pass every case nobody had looked at.
func TestAnUnansweredChecklistItemIsABlocker(t *testing.T) {
	items := domain.DefaultPreopItems()
	checklist := domain.PreopChecklist{ID: "pc-1", CaseID: "case-1"}

	blockers := checklist.Blockers(items)
	if len(blockers) != 7 {
		t.Fatalf("%d blockers on an empty checklist, want every mandatory item: %v",
			len(blockers), blockers)
	}
}

// Consent and site marking are not waivable by anybody, which is the whole
// point of them: a system where every gate has an override has no gates.
func TestConsentAndSiteMarkingCannotBeWaived(t *testing.T) {
	items := domain.DefaultPreopItems()
	checklist := domain.PreopChecklist{ID: "pc-1", CaseID: "case-1"}

	for _, code := range []string{"consent", "site_marked"} {
		err := checklist.Record(items, domain.PreopEntry{
			Code: code, State: domain.PreopWaived, WaivedRole: "surgeon",
			Note: "running late", RecordedBy: "nurse-1", RecordedAt: at,
		})
		if err == nil {
			t.Fatalf("%q was waived", code)
		}
	}
}

// A waiver names the role entitled to make it, and says why. A waiver with no
// reason is a blocker somebody clicked past.
func TestAWaiverNeedsTheRightRoleAndAReason(t *testing.T) {
	items := domain.DefaultPreopItems()
	checklist := domain.PreopChecklist{ID: "pc-1", CaseID: "case-1"}

	if err := checklist.Record(items, domain.PreopEntry{
		Code: "fasting", State: domain.PreopWaived, WaivedRole: "surgeon",
		Note: "emergency", RecordedBy: "surgeon-1", RecordedAt: at,
	}); err == nil {
		t.Fatal("a surgeon waived the anaesthetist's item")
	}

	if err := checklist.Record(items, domain.PreopEntry{
		Code: "fasting", State: domain.PreopWaived, WaivedRole: "anaesthetist",
		RecordedBy: "anaes-1", RecordedAt: at,
	}); err == nil {
		t.Fatal("an unexplained waiver was accepted")
	}

	if err := checklist.Record(items, domain.PreopEntry{
		Code: "fasting", State: domain.PreopWaived, WaivedRole: "anaesthetist",
		Note:       "emergency laparotomy, rapid sequence induction planned",
		RecordedBy: "anaes-1", RecordedAt: at,
	}); err != nil {
		t.Fatalf("Record: %v", err)
	}

	for _, blocker := range checklist.Blockers(items) {
		if blocker.Code == "fasting" {
			t.Fatal("a waived item is still a blocker")
		}
	}
}

// SRS-OT-007. A time-out is the team stopping together; one person reading a
// list to themselves is the failure the "team confirmation" clause prevents.
func TestASafetyCheckIsPerformedByTheTeam(t *testing.T) {
	items := domain.DefaultSafetyItems()
	answers := answersFor(items, domain.PhaseTimeOut, true)

	if _, err := domain.PerformSafety("sc-1", "tenant-1", "case-1",
		domain.PhaseTimeOut, items, []string{"nurse-1"}, answers, "nurse-1",
		at); err == nil {
		t.Fatal("a time-out was performed by one person")
	}

	record, err := domain.PerformSafety("sc-1", "tenant-1", "case-1",
		domain.PhaseTimeOut, items,
		[]string{"surgeon-1", "anaes-1", "nurse-1"}, answers, "nurse-1", at)
	if err != nil {
		t.Fatalf("PerformSafety: %v", err)
	}
	if len(record.Participants) != 3 {
		t.Fatalf("%d participants recorded", len(record.Participants))
	}
	if len(record.Exceptions()) != 0 {
		t.Fatalf("exceptions = %v on an all-confirmed check", record.Exceptions())
	}
}

// "Missing item requires explicit exception": silence is not confirmation, and
// leaving a question blank does not complete the checklist.
func TestASafetyCheckCannotBeCompletedBySilence(t *testing.T) {
	items := domain.DefaultSafetyItems()
	answers := answersFor(items, domain.PhaseSignOut, true)

	// Drop one.
	partial := answers[1:]
	_, err := domain.PerformSafety("sc-2", "tenant-1", "case-1",
		domain.PhaseSignOut, items, []string{"nurse-1", "surgeon-1"},
		partial, "nurse-1", at)
	if err == nil {
		t.Fatal("a sign-out was completed with a question unanswered")
	}
	if !strings.Contains(err.Error(), "not answered") {
		t.Fatalf("error = %v, want it to name the unanswered items", err)
	}

	// An unconfirmed item with an exception is fine; one without is not.
	unconfirmed := answersFor(items, domain.PhaseSignOut, true)
	unconfirmed[0].Confirmed = false
	if _, err := domain.PerformSafety("sc-3", "tenant-1", "case-1",
		domain.PhaseSignOut, items, []string{"nurse-1", "surgeon-1"},
		unconfirmed, "nurse-1", at); err == nil {
		t.Fatal("an unconfirmed item was accepted with no exception")
	}

	unconfirmed[0].Exception = "counts disputed; imaging requested"
	record, err := domain.PerformSafety("sc-3", "tenant-1", "case-1",
		domain.PhaseSignOut, items, []string{"nurse-1", "surgeon-1"},
		unconfirmed, "nurse-1", at)
	if err != nil {
		t.Fatalf("PerformSafety: %v", err)
	}
	if len(record.Exceptions()) != 1 {
		t.Fatalf("exceptions = %v, want the one unconfirmed item", record.Exceptions())
	}
}

func answersFor(items []domain.SafetyItem, phase domain.SafetyPhase,
	confirmed bool) []domain.SafetyAnswer {

	var out []domain.SafetyAnswer
	for _, item := range items {
		if item.Phase == phase {
			out = append(out, domain.SafetyAnswer{Code: item.Code, Confirmed: confirmed})
		}
	}
	return out
}

// SRS-OT-008 and SRS-OT-015. Nothing stores a duration: every interval is
// derived, and one whose milestones have not both happened is absent rather
// than zero.
func TestIntervalsAreDerivedAndAbsentWhenTheyCannotBeKnown(t *testing.T) {
	milestones := domain.Milestones{
		must(t, domain.MilestoneTheatreIn, at),
		must(t, domain.MilestoneAnaesthesiaStart, at.Add(5*time.Minute)),
		must(t, domain.MilestoneIncision, at.Add(25*time.Minute)),
	}

	intervals := milestones.Intervals(at.Add(-10 * time.Minute))
	if intervals.AnaesthesiaToIncision == nil ||
		*intervals.AnaesthesiaToIncision != 20*time.Minute {
		t.Fatalf("anaesthesia to incision = %v, want 20m",
			intervals.AnaesthesiaToIncision)
	}
	// The patient is still in theatre, so there is no occupancy yet. A zero
	// here would make the list look efficient while the case was running.
	if intervals.TheatreOccupancy != nil {
		t.Fatalf("occupancy = %v on a case still in theatre",
			*intervals.TheatreOccupancy)
	}
	if intervals.IncisionToClosure != nil {
		t.Fatal("operating time was reported before closure")
	}
	if intervals.StartDelay == nil || *intervals.StartDelay != 10*time.Minute {
		t.Fatalf("start delay = %v, want 10m late", intervals.StartDelay)
	}
}

// A closure timed before an incision is almost always a typing error.
// Reported rather than refused: refusing leaves the real time unrecorded, and
// ignoring it puts a negative operating time into the unit's reporting.
func TestMilestonesOutOfSequenceAreReported(t *testing.T) {
	milestones := domain.Milestones{
		must(t, domain.MilestoneIncision, at.Add(30*time.Minute)),
		must(t, domain.MilestoneClosure, at.Add(10*time.Minute)),
	}
	problems := milestones.OutOfSequence()
	if len(problems) != 1 {
		t.Fatalf("problems = %v, want the closure before the incision", problems)
	}
}

// A milestone recorded twice still happened once, and the first time is the
// one the interval is measured from.
func TestTheEarliestRecordOfAMilestoneWins(t *testing.T) {
	milestones := domain.Milestones{
		must(t, domain.MilestoneTheatreIn, at.Add(10*time.Minute)),
		must(t, domain.MilestoneTheatreIn, at),
	}
	when, ok := milestones.At(domain.MilestoneTheatreIn)
	if !ok || !when.Equal(at) {
		t.Fatalf("theatre in = %v, want the earlier record", when)
	}
}

func must(t *testing.T, milestone domain.Milestone, when time.Time) domain.MilestoneRecord {
	t.Helper()
	record, err := domain.RecordMilestone("m-"+string(milestone), "tenant-1", "case-1",
		milestone, when, "nurse-1", "", at)
	if err != nil {
		t.Fatalf("RecordMilestone(%s): %v", milestone, err)
	}
	return record
}

// SRS-OT-014. A theatre that records "late start" as a sentence produces a
// report nobody can act on, and the fixes for a late surgeon and a missing set
// of instruments are different departments' work.
func TestADelayIsClassified(t *testing.T) {
	if _, err := domain.RecordDelay("d-1", "tenant-1", "case-1", "", "cssd", 20,
		"", "nurse-1", at); err == nil {
		t.Fatal("an unclassified delay was accepted")
	}
	if _, err := domain.RecordDelay("d-1", "tenant-1", "case-1", domain.DelayOther,
		"", 20, "", "nurse-1", at); err == nil {
		t.Fatal("a delay coded \"other\" with no explanation was accepted")
	}
	delay, err := domain.RecordDelay("d-1", "tenant-1", "case-1",
		domain.DelayInstruments, "cssd", 25, "set not returned from sterilisation",
		"nurse-1", at)
	if err != nil {
		t.Fatalf("RecordDelay: %v", err)
	}
	if delay.Dependency != "cssd" {
		t.Fatalf("dependency = %q; a theatre's delay report is read by the "+
			"departments it names", delay.Dependency)
	}
}

// SRS-OT-013. The board's stage comes from the milestones, so it cannot
// disagree with the room the moment somebody forgets to update it.
func TestTheBoardDerivesItsStageFromMilestones(t *testing.T) {
	room := domain.Room{ID: "room-1", Code: "OT1", Active: true}
	running := domain.Case{
		ID: "case-1", Status: domain.CaseInTheatre, RoomID: "room-1",
		ProcedureDisplay: "Hemicolectomy", SurgeonID: "surgeon-1",
		ScheduledStart: at, ScheduledEnd: at.Add(2 * time.Hour),
	}
	next := domain.Case{
		ID: "case-2", Status: domain.CaseScheduled, RoomID: "room-1",
		ProcedureDisplay: "Hernia repair",
		ScheduledStart:   at.Add(3 * time.Hour), ScheduledEnd: at.Add(4 * time.Hour),
	}

	rows := domain.BuildBoard([]domain.BoardInput{{
		Room: room, Cases: []domain.Case{running, next},
		Milestones: map[string]domain.Milestones{
			"case-1": {must(t, domain.MilestoneTheatreIn, at),
				must(t, domain.MilestoneIncision, at.Add(20*time.Minute))},
		},
		Blockers: map[string][]domain.Blocker{
			"case-2": {{Code: "consent", Label: "Consent signed and valid"}},
		},
		Delays: map[string]int{"case-1": 15},
	}}, at.Add(3*time.Hour))

	if len(rows) != 1 {
		t.Fatalf("%d rows, want 1", len(rows))
	}
	row := rows[0]
	if row.Stage != domain.StageInUse {
		t.Fatalf("stage = %q, want in use", row.Stage)
	}
	if row.CurrentMilestone != domain.MilestoneIncision {
		t.Fatalf("milestone = %q, want incision", row.CurrentMilestone)
	}
	if !row.OverRunning {
		t.Fatal("a case an hour past its booked end is not marked over-running")
	}
	if row.DelayMinutes != 15 {
		t.Fatalf("delay = %d minutes", row.DelayMinutes)
	}
	// The one thing a theatre manager most wants to see and most often cannot.
	if row.NextCaseID != "case-2" || row.NextReady {
		t.Fatalf("next = %q ready=%v", row.NextCaseID, row.NextReady)
	}
	if len(row.NextBlockers) != 1 {
		t.Fatalf("next blockers = %v, want the consent", row.NextBlockers)
	}
}

// A room whose last case has left and whose next has not arrived is in
// turnover, which is the interval a theatre manager watches.
func TestAnEmptyRoomBetweenCasesIsInTurnover(t *testing.T) {
	room := domain.Room{ID: "room-1", Code: "OT1", Active: true}
	finished := domain.Case{
		ID: "case-1", Status: domain.CaseCompleted, RoomID: "room-1",
		ScheduledStart: at, ScheduledEnd: at.Add(time.Hour),
	}
	// A completed case is closed, so it is not on the board; the turnover is
	// measured from a case still open that has left the room.
	finished.Status = domain.CaseInTheatre

	rows := domain.BuildBoard([]domain.BoardInput{{
		Room: room, Cases: []domain.Case{finished},
		Milestones: map[string]domain.Milestones{
			"case-1": {
				must(t, domain.MilestoneTheatreIn, at),
				must(t, domain.MilestoneTheatreOut, at.Add(time.Hour)),
			},
		},
	}}, at.Add(80*time.Minute))

	if rows[0].Stage != domain.StageTurnover {
		t.Fatalf("stage = %q, want turnover", rows[0].Stage)
	}
	if rows[0].TurnoverSoFar != 20*time.Minute {
		t.Fatalf("turnover so far = %v, want 20m", rows[0].TurnoverSoFar)
	}
}

// SRS-OT-015: "metrics reconcile to recorded timestamps". Nothing is stored
// and adjusted, so the numbers cannot disagree with the cases they came from.
func TestUtilisationIsDerivedFromTheTimestamps(t *testing.T) {
	first := domain.Case{
		ID: "case-1", Status: domain.CaseCompleted, RoomID: "room-1",
		ScheduledStart: at, ScheduledEnd: at.Add(time.Hour),
	}
	second := domain.Case{
		ID: "case-2", Status: domain.CaseCompleted, RoomID: "room-1",
		ScheduledStart: at.Add(90 * time.Minute), ScheduledEnd: at.Add(150 * time.Minute),
	}
	cancelled := domain.Case{
		ID: "case-3", Status: domain.CaseCancelled, RoomID: "room-1",
		ScheduledStart: at.Add(3 * time.Hour), ScheduledEnd: at.Add(4 * time.Hour),
		Outcome: domain.OutcomeResource, OutcomeReason: "no bed",
	}

	utilisation := domain.ComputeUtilisation("room-1", at.Add(-time.Hour),
		at.Add(8*time.Hour),
		[]domain.Case{first, second, cancelled},
		map[string]domain.Milestones{
			"case-1": {
				must(t, domain.MilestoneTheatreIn, at.Add(5*time.Minute)),
				must(t, domain.MilestoneTheatreOut, at.Add(55*time.Minute)),
			},
			"case-2": {
				// Half an hour late.
				must(t, domain.MilestoneTheatreIn, at.Add(2*time.Hour)),
				must(t, domain.MilestoneTheatreOut, at.Add(150*time.Minute)),
			},
		},
		map[string][]domain.Delay{
			"case-2": {{Reason: domain.DelayInstruments, Minutes: 30}},
		},
		[]domain.Block{{
			RoomID: "room-1", Kind: domain.BlockList,
			StartsAt: at, EndsAt: at.Add(4 * time.Hour),
		}},
		0)

	if utilisation.Cases != 3 || utilisation.Completed != 2 ||
		utilisation.Cancelled != 1 {
		t.Fatalf("counts = %+v", utilisation)
	}
	if utilisation.CancellationsByCause[domain.OutcomeResource] != 1 {
		t.Fatalf("cancellations by cause = %v", utilisation.CancellationsByCause)
	}
	if utilisation.OperatingMinutes != 80 {
		t.Fatalf("operating minutes = %d, want 50 + 30", utilisation.OperatingMinutes)
	}
	if utilisation.BlockMinutes != 240 {
		t.Fatalf("block minutes = %d, want the four-hour list",
			utilisation.BlockMinutes)
	}
	// The first case started five minutes late, which is within the grace; the
	// second started thirty, which is not.
	if utilisation.OnTimeStarts != 1 {
		t.Fatalf("on-time starts = %d, want 1", utilisation.OnTimeStarts)
	}
	if utilisation.FirstCases != 1 || utilisation.OnTimeFirstCases != 1 {
		t.Fatalf("first cases = %d, on time = %d",
			utilisation.FirstCases, utilisation.OnTimeFirstCases)
	}
	// The gap between the first leaving and the second arriving.
	if utilisation.TurnoverCount != 1 || utilisation.TurnoverMinutes != 65 {
		t.Fatalf("turnover = %d over %d cases",
			utilisation.TurnoverMinutes, utilisation.TurnoverCount)
	}
	if utilisation.DelaysByReason[domain.DelayInstruments] != 30 {
		t.Fatalf("delays by reason = %v", utilisation.DelaysByReason)
	}
}

// SRS-OT-009. A signed operative note is amended into a new version, never
// edited: the document read in a claim cannot have had its history
// overwritten.
func TestASignedNoteIsAmendedIntoANewVersion(t *testing.T) {
	note, err := domain.NewOperativeNote("note-1", "tenant-1", domain.NewNoteInput{
		CaseID: "case-1", ProcedurePerformed: "Right hemicolectomy",
		Findings: "Tumour at the hepatic flexure", EstimatedBloodLossML: 250,
	}, "surgeon-1", at)
	if err != nil {
		t.Fatalf("NewOperativeNote: %v", err)
	}

	if _, err := note.Amend("note-2", domain.NewNoteInput{
		ProcedurePerformed: "Right hemicolectomy",
	}, "typo", "surgeon-1", at); err == nil {
		t.Fatal("an unsigned note was amended rather than edited")
	}

	if err := note.Sign("surgeon-1", at.Add(time.Hour)); err != nil {
		t.Fatalf("Sign: %v", err)
	}

	if _, err := note.Amend("note-2", domain.NewNoteInput{
		ProcedurePerformed: "Right hemicolectomy",
	}, "", "surgeon-1", at.Add(2*time.Hour)); err == nil {
		t.Fatal("an unexplained amendment was accepted")
	}

	amended, err := note.Amend("note-2", domain.NewNoteInput{
		ProcedurePerformed:   "Extended right hemicolectomy",
		Findings:             "Tumour at the hepatic flexure with nodal involvement",
		EstimatedBloodLossML: 250,
	}, "extent of resection recorded incorrectly", "surgeon-1", at.Add(2*time.Hour))
	if err != nil {
		t.Fatalf("Amend: %v", err)
	}
	if amended.Version != 2 || amended.Supersedes != note.ID {
		t.Fatalf("amended = v%d superseding %q", amended.Version, amended.Supersedes)
	}
	// The original is untouched in the caller's hands.
	if note.ProcedurePerformed != "Right hemicolectomy" {
		t.Fatal("amending changed the original note")
	}
}

// SRS-OT-010. A recall is traced patient by patient, so an implant with
// neither serial nor lot is one nobody can find when the manufacturer writes.
func TestAnImplantRecordsSomethingTraceable(t *testing.T) {
	if _, err := domain.RecordUsage("u-1", "tenant-1", domain.NewUsageInput{
		CaseID: "case-1", Kind: domain.UsageImplant, ItemCode: "HIP-001",
		Quantity: 1,
	}, "nurse-1", at); err == nil {
		t.Fatal("an implant with no serial and no lot was accepted")
	}

	if _, err := domain.RecordUsage("u-1", "tenant-1", domain.NewUsageInput{
		CaseID: "case-1", Kind: domain.UsageImplant, ItemCode: "HIP-001",
		SerialNumber: "SN-1", Quantity: 2,
	}, "nurse-1", at); err == nil {
		t.Fatal("two implants were recorded against one serial number")
	}

	usage, err := domain.RecordUsage("u-1", "tenant-1", domain.NewUsageInput{
		CaseID: "case-1", Kind: domain.UsageImplant, ItemCode: "HIP-001",
		ItemName: "Acetabular cup", SerialNumber: "SN-1", Quantity: 1,
		ExpiryDate: at.Add(-24 * time.Hour), Scanned: true, ScanData: "0100...",
	}, "nurse-1", at)
	if err != nil {
		t.Fatalf("RecordUsage: %v", err)
	}
	// An expired item used in an emergency is a governance event that has to
	// be recorded, so it is reported rather than refused.
	if !usage.Expired(at) {
		t.Fatal("an item used past its expiry date is not marked expired")
	}
	if !usage.Scanned {
		t.Fatal("the scan flag was lost; the charge is traceable to it")
	}
}

// SRS-OT-011. The site is half of every histology report, and the half that
// cannot be reconstructed afterwards.
func TestASpecimenNamesItsSiteAndStartsUnaccessioned(t *testing.T) {
	if _, err := domain.TakeSpecimen("sp-1", "tenant-1", domain.NewSpecimenInput{
		CaseID: "case-1", PatientID: "pat-1", Label: "Pot 1",
	}, "nurse-1", at); err == nil {
		t.Fatal("a specimen with no site was accepted")
	}

	specimen, err := domain.TakeSpecimen("sp-1", "tenant-1", domain.NewSpecimenInput{
		CaseID: "case-1", PatientID: "pat-1", Label: "Pot 1",
		Site: "hepatic flexure", Laterality: domain.LateralityRight,
		Container: "formalin pot", Fixative: "10% formalin",
	}, "nurse-1", at)
	if err != nil {
		t.Fatalf("TakeSpecimen: %v", err)
	}

	outstanding := domain.UnaccessionedSpecimens([]domain.Specimen{specimen})
	if len(outstanding) != 1 {
		t.Fatal("a specimen with no order is not on the outstanding list")
	}

	if err := specimen.Accession("order-1"); err != nil {
		t.Fatalf("Accession: %v", err)
	}
	if err := specimen.Accession("order-2"); err == nil {
		t.Fatal("a specimen was accessioned twice")
	}
	if len(domain.UnaccessionedSpecimens([]domain.Specimen{specimen})) != 0 {
		t.Fatal("an accessioned specimen is still outstanding")
	}
}

// SRS-OT-012. An infection is investigated backwards from the patient, and a
// tray opened without its cycle recorded is the link that is missing for the
// case that matters.
func TestATrayRecordsTheCycleItCameFrom(t *testing.T) {
	if _, err := domain.OpenTray("t-1", "tenant-1", "case-1", "tray-9",
		"Major general set", "", true, "", "nurse-1", at); err == nil {
		t.Fatal("a tray was opened with no sterilisation cycle recorded")
	}

	if _, err := domain.OpenTray("t-1", "tenant-1", "case-1", "tray-9",
		"Major general set", "cycle-44", false, "", "nurse-1", at); err == nil {
		t.Fatal("a failed indicator was recorded with no note")
	}

	use, err := domain.OpenTray("t-1", "tenant-1", "case-1", "tray-9",
		"Major general set", "cycle-44", false,
		"pack returned to CSSD unopened; second set used", "nurse-1", at)
	if err != nil {
		t.Fatalf("OpenTray: %v", err)
	}
	if use.CycleID != "cycle-44" {
		t.Fatalf("cycle = %q", use.CycleID)
	}
}

// SRS-OT-016. A card seeds requirements and never constrains actual use: a
// system that refused an instrument because it was not on the card would have
// theatre staff editing cards mid-case.
func TestAPreferenceCardSeedsWithoutConstraining(t *testing.T) {
	c, _ := request(t, func(in *domain.NewCaseInput) {
		in.Requirements = []string{"tourniquet"}
	})

	card := domain.PreferenceCard{
		SurgeonID: "surgeon-1", ProcedureCode: "M65.3",
		Equipment: []string{"image intensifier", "tourniquet"},
	}
	card.Seed(&c)

	if len(c.Requirements) != 2 {
		t.Fatalf("requirements = %v, want the card added without duplicating",
			c.Requirements)
	}
	// Nothing about the card stops a different instrument being recorded: the
	// usage record has no reference to it at all.
	usage, err := domain.RecordUsage("u-1", "tenant-1", domain.NewUsageInput{
		CaseID: c.ID, ItemCode: "SUT-9", ItemName: "Suture not on the card",
		Quantity: 1,
	}, "nurse-1", at)
	if err != nil {
		t.Fatalf("RecordUsage: %v", err)
	}
	if usage.ItemCode != "SUT-9" {
		t.Fatal("the card constrained what could be used")
	}
}

// SRS-OT-017. An emergency case goes in without corrupting what was there: the
// elective it displaces is postponed explicitly, with a coded cause, and stays
// in the record.
func TestAnEmergencyInsertionPostponesRatherThanErases(t *testing.T) {
	elective, _ := request(t, nil)
	room := domain.Room{ID: "room-1", Code: "OT1", Active: true}
	slot := domain.ScheduleRequest{
		RoomID: "room-1", Start: at.Add(time.Hour), End: at.Add(2 * time.Hour),
	}
	if err := elective.Schedule(slot,
		elective.CheckSlot(slot, domain.SchedulingContext{Room: room}, at),
		false, at); err != nil {
		t.Fatalf("Schedule: %v", err)
	}

	emergency, _ := request(t, func(in *domain.NewCaseInput) {
		in.Urgency = domain.UrgencyEmergency
		in.ProcedureDisplay = "Laparotomy"
	})
	// A different case from the elective, which the shared helper would
	// otherwise give the same id — and a case never clashes with itself.
	emergency.ID = "case-emergency"

	// The emergency clashes, and the clash is hard.
	conflicts := emergency.CheckSlot(slot, domain.SchedulingContext{
		Room: room, Booked: []domain.Case{elective},
	}, at)
	if len(conflicts) == 0 {
		t.Fatal("the emergency did not clash with the elective in the room")
	}
	if err := emergency.Schedule(slot, conflicts, true, at); err == nil {
		t.Fatal("the emergency was booked over the elective")
	}

	// The elective is postponed explicitly, which frees the slot and records
	// why, and the original booking stays in its history.
	if err := elective.Postpone(domain.OutcomeResource,
		"displaced by an emergency laparotomy", "", at); err != nil {
		t.Fatalf("Postpone: %v", err)
	}
	if elective.Outcome != domain.OutcomeResource {
		t.Fatalf("outcome = %q", elective.Outcome)
	}

	free := emergency.CheckSlot(slot, domain.SchedulingContext{
		Room: room, Booked: []domain.Case{elective},
	}, at)
	if len(free) != 0 {
		t.Fatalf("conflicts = %v after the elective was postponed", free)
	}
	if err := emergency.Schedule(slot, free, false, at); err != nil {
		t.Fatalf("Schedule the emergency: %v", err)
	}
}

// SRS-BIO-009. A room's fitted list says what it is meant to have; the
// equipment register says what is working. The requirement's acceptance is
// that the second one is what a scheduler sees.
func TestARoomWithABrokenIntensifierIsNotOfferedForIntensifierWork(t *testing.T) {
	room := domain.Room{
		ID: "room-1", TenantID: "t", FacilityID: "f", Code: "OT1",
		Equipment: []string{"image_intensifier"}, Active: true,
	}

	// No register wired: the fitted list is all there is, and the room suits.
	// That is a narrower answer rather than a wrong one, and it is what a
	// deployment without an equipment register has always had.
	if missing, ok := room.Suits("", []string{"image_intensifier"}, nil); !ok {
		t.Fatalf("with no register the room refused the case: %v", missing)
	}

	// Two intensifiers, one away for service. The room still suits: counted
	// rather than flagged, because the hospital can still do the work.
	if missing, ok := room.Suits("", []string{"image_intensifier"},
		&domain.EquipmentStatus{
			Working: map[string]int{"image_intensifier": 1},
		}); !ok {
		t.Fatalf("a room with one working intensifier refused the case: %v",
			missing)
	}

	// Both away. Now the room genuinely cannot do it, and offering the slot
	// would be offering something the hospital cannot deliver.
	missing, ok := room.Suits("", []string{"image_intensifier"},
		&domain.EquipmentStatus{
			Working: map[string]int{"image_intensifier": 0},
			Down: map[string]string{
				"image_intensifier": "BME-II-1: awaiting parts",
			},
		})
	if ok {
		t.Fatal("a room whose only intensifier is broken was offered for it")
	}
	if len(missing) != 1 {
		t.Fatalf("missing = %v, want one reason", missing)
	}
	// Named, because "this room has no image intensifier" about a room with
	// one bolted to the floor reads as a bug and gets ignored.
	if !strings.Contains(missing[0], "awaiting parts") ||
		!strings.Contains(missing[0], "BME-II-1") {
		t.Fatalf("missing = %q, want it to name the machine and the reason",
			missing[0])
	}
}

// The room's fitted list and the equipment register are maintained by
// different departments, and one of them will capitalise differently.
func TestCapabilityMatchingDoesNotTurnOnCapitalisation(t *testing.T) {
	room := domain.Room{
		ID: "room-1", TenantID: "t", FacilityID: "f", Code: "OT1",
		Equipment: []string{"Image_Intensifier"}, Active: true,
	}

	if missing, ok := room.Suits("", []string{"image_intensifier"},
		&domain.EquipmentStatus{
			Working: map[string]int{"IMAGE_INTENSIFIER": 1},
		}); !ok {
		t.Fatalf("a working machine was missed on capitalisation: %v", missing)
	}
}
