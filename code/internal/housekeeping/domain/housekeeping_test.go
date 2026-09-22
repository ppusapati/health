package domain_test

import (
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/housekeeping/domain"
)

// The housekeeping and environmental services rules.
//
// Every refusal below is a rule somebody could otherwise remove, so each is
// tested by weakening it: the assertion is that the domain says no, and the
// comment says what happens in a ward when it says yes.

var at = time.Date(2026, 9, 21, 6, 0, 0, 0, time.UTC)

func refused(t *testing.T, err error, contains string) {
	t.Helper()
	if err == nil {
		t.Fatalf("want a refusal mentioning %q, got none", contains)
	}
	if !strings.Contains(err.Error(), contains) {
		t.Fatalf("want a refusal mentioning %q, got %v", contains, err)
	}
}

// ------------------------------------------------- locations (SRS-HKP-001)

func bedInput() domain.NewLocationInput {
	return domain.NewLocationInput{
		Code: "w3-bed-7", Name: "Ward 3 bed 7", Revision: 1,
		FacilityID: "f1", Zone: "ward-3", BedID: "bed-7",
		RiskClass:         domain.RiskHigh,
		RoutineEveryHours: 24, RoutineSLAMinutes: 120,
		TerminalSLAMinutes: 45,
		Checklist: []domain.ChecklistItem{
			{Code: "surfaces", Label: "High-touch surfaces", Required: true},
			{Code: "floor", Label: "Floor", Required: true},
			{Code: "curtains", Label: "Curtain change"},
		},
		ScanCode:      "W3B7",
		EffectiveFrom: at.Add(-24 * time.Hour),
	}
}

func theatreInput() domain.NewLocationInput {
	in := bedInput()
	in.Code, in.Name, in.Zone, in.BedID = "th-2", "Theatre 2", "theatres", ""
	in.RiskClass = domain.RiskVeryHigh
	in.RoutineEveryHours, in.RoutineSLAMinutes = 6, 30
	in.ScanCode = "TH2"
	return in
}

func officeInput() domain.NewLocationInput {
	in := bedInput()
	in.Code, in.Name, in.Zone, in.BedID = "adm-1", "Admin office", "admin", ""
	in.RiskClass = domain.RiskLow
	in.RoutineEveryHours, in.RoutineSLAMinutes = 168, 480
	in.ScanCode = "ADM1"
	return in
}

// approved builds a location whose standard is in force at `at`.
func approved(t *testing.T, id string,
	in domain.NewLocationInput) domain.CleanableLocation {

	t.Helper()
	location, err := domain.NewLocation(id, "t1", in, "hk-author",
		at.Add(-48*time.Hour))
	if err != nil {
		t.Fatalf("NewLocation: %v", err)
	}
	if err := location.Approve("hk-manager", in.EffectiveFrom,
		at.Add(-36*time.Hour)); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	return location
}

func TestALocationStatesWhatACleanHereHasToInclude(t *testing.T) {
	// SRS-HKP-002's acceptance is that a task carries a checklist, and a
	// task can only carry one if the standard behind it names one. A clean
	// with no checklist is a clean nobody can judge afterwards.
	in := bedInput()
	in.Checklist = nil
	_, err := domain.NewLocation("loc-1", "t1", in, "hk-author", at)
	refused(t, err, "what a clean here has to include")

	// The same item twice is two answers to one question, and a completion
	// check that counts both as answered.
	in = bedInput()
	in.Checklist = append(in.Checklist,
		domain.ChecklistItem{Code: "Floor", Required: true})
	_, err = domain.NewLocation("loc-1", "t1", in, "hk-author", at)
	refused(t, err, "appears twice")

	// An item with no code cannot be answered, because an answer names the
	// item it answers.
	in = bedInput()
	in.Checklist = []domain.ChecklistItem{{Label: "Floor", Required: true}}
	_, err = domain.NewLocation("loc-1", "t1", in, "hk-author", at)
	refused(t, err, "checklist item needs a code")

	// A risk class decides how often a theatre is cleaned and whether an
	// overdue clean is escalated. A hospital that could type one would have
	// four wards on values nobody can explain.
	in = bedInput()
	in.RiskClass = "quite_dirty"
	_, err = domain.NewLocation("loc-1", "t1", in, "hk-author", at)
	refused(t, err, "unknown risk class")

	// A negative SLA is a task due before it was raised.
	in = bedInput()
	in.RoutineSLAMinutes = -30
	_, err = domain.NewLocation("loc-1", "t1", in, "hk-author", at)
	refused(t, err, "cannot be negative")

	// Revisions are what makes a standard auditable; there is no revision
	// zero to point at.
	in = bedInput()
	in.Revision = 0
	_, err = domain.NewLocation("loc-1", "t1", in, "hk-author", at)
	refused(t, err, "revision starts at one")

	in = bedInput()
	in.Code = "  "
	_, err = domain.NewLocation("loc-1", "t1", in, "hk-author", at)
	refused(t, err, "needs a code")

	_, err = domain.NewLocation("", "t1", bedInput(), "hk-author", at)
	refused(t, err, "needs an id")
}

func TestACleaningStandardIsApprovedBySomebodyOtherThanItsAuthor(
	t *testing.T) {

	location, err := domain.NewLocation("loc-1", "t1", bedInput(),
		"hk-author", at.Add(-48*time.Hour))
	if err != nil {
		t.Fatalf("NewLocation: %v", err)
	}

	// Until somebody approves it, nothing is cleaned to it.
	if location.Live(at) {
		t.Fatal("an unapproved standard is in force")
	}

	// One person writing and approving a cleaning standard is one person
	// deciding how often a theatre is cleaned and what counts as cleaning
	// it.
	err = location.Approve("hk-author", at.Add(-24*time.Hour), at)
	refused(t, err, "author of a cleaning standard cannot approve it")

	err = location.Approve("", at.Add(-24*time.Hour), at)
	refused(t, err, "approval names who made it")

	// A standard in force from no particular moment is a standard that
	// silently rejudges the cleans already done against the old one.
	err = location.Approve("hk-manager", time.Time{}, at)
	refused(t, err, "when it takes effect")

	if err := location.Approve("hk-manager", at.Add(-24*time.Hour),
		at); err != nil {
		t.Fatalf("Approve: %v", err)
	}
	if !location.Live(at) {
		t.Fatal("an approved standard is not in force")
	}
	// And not before it takes effect.
	if location.Live(at.Add(-36 * time.Hour)) {
		t.Fatal("a standard is in force before its effective date")
	}

	err = location.Approve("hk-other", at.Add(-time.Hour), at)
	refused(t, err, "already approved")
}

func TestTheStandardInForceIsTheLatestApprovedRevision(t *testing.T) {
	first := approved(t, "loc-1", bedInput())

	second := bedInput()
	second.Revision = 2
	second.RoutineEveryHours = 12
	second.EffectiveFrom = at.Add(-2 * time.Hour)
	latest := approved(t, "loc-2", second)

	// Two live standards for one room is a room cleaned to whichever one
	// the reader happened to open.
	got, ok := domain.LocationInForce(
		[]domain.CleanableLocation{first, latest}, "w3-bed-7", at)
	if !ok || got.Revision != 2 {
		t.Fatalf("want revision 2 in force, got %v %v", got.Revision, ok)
	}

	// Before the new one took effect, the old one is what a clean was
	// judged against.
	got, ok = domain.LocationInForce(
		[]domain.CleanableLocation{first, latest}, "w3-bed-7",
		at.Add(-6*time.Hour))
	if !ok || got.Revision != 1 {
		t.Fatalf("want revision 1 in force, got %v %v", got.Revision, ok)
	}

	if _, ok := domain.LocationInForce(
		[]domain.CleanableLocation{first}, "no-such-room", at); ok {
		t.Fatal("a room nobody configured has a standard in force")
	}
}

func TestARoutineCleanFallsDueFromTheConfigurationInForce(t *testing.T) {
	bed := approved(t, "loc-1", bedInput())
	theatre := approved(t, "loc-2", theatreInput())

	onRequest := officeInput()
	onRequest.Code = "store-1"
	onRequest.RoutineEveryHours = 0
	store := approved(t, "loc-3", onRequest)

	unapproved, err := domain.NewLocation("loc-4", "t1", officeInput(),
		"hk-author", at.Add(-48*time.Hour))
	if err != nil {
		t.Fatalf("NewLocation: %v", err)
	}

	last := map[string]time.Time{
		"w3-bed-7": at.Add(-30 * time.Hour),
		"store-1":  at.Add(-1000 * time.Hour),
	}
	due := domain.DueRoutineCleans([]domain.CleanableLocation{
		bed, theatre, store, unapproved}, last, at)

	if len(due) != 2 {
		t.Fatalf("want two locations due, got %d: %+v", len(due), due)
	}
	// The never-cleaned theatre comes first. A worklist sorted by room
	// number sends somebody past the theatre to do an office.
	if due[0].Location.Code != "th-2" || !due[0].Never {
		t.Fatalf("want the never-cleaned theatre first, got %+v", due[0])
	}
	if due[1].Location.Code != "w3-bed-7" {
		t.Fatalf("want the overdue bed second, got %+v", due[1])
	}
	// A store room cleaned when somebody asks is not overdue for ever, and
	// a standard nobody approved schedules nothing.
	for _, item := range due {
		if item.Location.Code == "store-1" ||
			item.Location.Code == "adm-1" {
			t.Fatalf("unscheduled or unapproved location is due: %+v", item)
		}
	}

	// The schedule derives from the configuration: shorten the frequency
	// and the same history is due now, with nothing regenerated.
	quicker := bedInput()
	quicker.Revision, quicker.RoutineEveryHours = 2, 1
	quicker.EffectiveFrom = at.Add(-2 * time.Hour)
	faster := approved(t, "loc-5", quicker)
	due = domain.DueRoutineCleans([]domain.CleanableLocation{faster},
		map[string]time.Time{"w3-bed-7": at.Add(-90 * time.Minute)}, at)
	if len(due) != 1 {
		t.Fatalf("want the bed due under the new frequency, got %+v", due)
	}
}

// ------------------------------------------------------ tasks (SRS-HKP-002)

func openTask(t *testing.T, location domain.CleanableLocation,
	kind domain.TaskKind) domain.CleaningTask {

	t.Helper()
	in := domain.NewTaskInput{Kind: kind, AssigneeID: "cleaner-1"}
	if kind == domain.TaskSpill {
		in.Detail = "blood, bay 3"
		in.IncidentRef = "inc-9"
	}
	task, err := domain.RaiseTask("task-1", "t1", location, in, "hk-lead", at)
	if err != nil {
		t.Fatalf("RaiseTask: %v", err)
	}
	return task
}

func TestATaskIsRaisedAgainstAnApprovedStandardAndCopiesIt(t *testing.T) {
	location := approved(t, "loc-1", bedInput())

	task := openTask(t, location, domain.TaskTerminal)
	// The checklist, risk class and SLA are copied. A task that pointed at
	// a configuration instead would change underneath the person doing it.
	if task.LocationRevision != 1 || len(task.Checklist) != 3 ||
		task.RiskClass != domain.RiskHigh || task.ScanCode != "W3B7" {
		t.Fatalf("task did not copy its standard: %+v", task)
	}
	// A terminal clean gets the terminal SLA, because the bed is out of
	// service until it is done.
	if want := at.Add(45 * time.Minute); !task.DueBy.Equal(want) {
		t.Fatalf("want terminal SLA %v, got %v", want, task.DueBy)
	}
	routine := openTask(t, location, domain.TaskRoutine)
	if want := at.Add(120 * time.Minute); !routine.DueBy.Equal(want) {
		t.Fatalf("want routine SLA %v, got %v", want, routine.DueBy)
	}

	// Editing the standard afterwards does not change what a raised task is
	// judged against.
	location.Checklist[0].Code = "rewritten"
	if task.Checklist[0].Code != "surfaces" {
		t.Fatal("editing the standard changed a raised task's checklist")
	}

	// A task raised against a standard nobody approved is a task answering
	// a checklist nobody agreed to.
	draft, err := domain.NewLocation("loc-9", "t1", bedInput(), "hk-author",
		at.Add(-48*time.Hour))
	if err != nil {
		t.Fatalf("NewLocation: %v", err)
	}
	_, err = domain.RaiseTask("task-2", "t1", draft,
		domain.NewTaskInput{Kind: domain.TaskRoutine}, "hk-lead", at)
	refused(t, err, "no approved cleaning standard is in force")

	// A biohazard task with no detail sends somebody with the wrong
	// equipment, and its detail is restricted because the circumstances of
	// a spill are often about a patient.
	_, err = domain.RaiseTask("task-3", "t1", location,
		domain.NewTaskInput{Kind: domain.TaskSpill}, "hk-lead", at)
	refused(t, err, "says what was spilled")

	spill := openTask(t, location, domain.TaskSpill)
	if !spill.Restricted || spill.IncidentRef != "inc-9" {
		t.Fatalf("a spill task is not restricted or lost its incident: %+v",
			spill)
	}
	if routine.Restricted {
		t.Fatal("a routine clean is restricted")
	}

	// A terminal clean holds a bed. Raised against a corridor it would hold
	// nothing and look like it held something.
	corridor := approved(t, "loc-3", theatreInput())
	_, err = domain.RaiseTask("task-4", "t1", corridor,
		domain.NewTaskInput{Kind: domain.TaskTerminal}, "hk-lead", at)
	refused(t, err, "terminal clean is raised against a bed")

	_, err = domain.RaiseTask("task-5", "t1", location,
		domain.NewTaskInput{Kind: "mop"}, "hk-lead", at)
	refused(t, err, "unknown cleaning task kind")

	_, err = domain.RaiseTask("task-6", "t1", location,
		domain.NewTaskInput{Kind: domain.TaskRoutine}, "", at)
	refused(t, err, "names who raised it")

	_, err = domain.RaiseTask("", "t1", location,
		domain.NewTaskInput{Kind: domain.TaskRoutine}, "hk-lead", at)
	refused(t, err, "a task needs an id")
}

func TestATaskMovesOneStepAtATimeAndNamesWhoDidEachOne(t *testing.T) {
	location := approved(t, "loc-1", bedInput())
	task := openTask(t, location, domain.TaskRoutine)

	refused(t, task.Assign(""), "assignment names somebody")
	refused(t, task.Start("", at), "start names who began it")

	// A clean cannot be completed by somebody who never started it: the
	// timestamps are what the turnaround report is derived from.
	refused(t, task.Complete(nil, "cleaner-1", at), "has not been started")

	if err := task.Start("cleaner-1", at.Add(5*time.Minute)); err != nil {
		t.Fatalf("Start: %v", err)
	}
	refused(t, task.Start("cleaner-1", at), "this task is in_progress")

	refused(t, task.Cancel("", "hk-lead", at), "say why")
	if err := task.Cancel("ward cleaned it", "hk-lead", at); err != nil {
		t.Fatalf("Cancel: %v", err)
	}

	// A cancelled task is not work anybody can carry on doing.
	refused(t, task.Cancel("again", "hk-lead", at), "already cancelled")
	refused(t, task.Assign("cleaner-2"), "this task is cancelled")
	refused(t, task.RecordScan("W3B7", "cleaner-1", at),
		"this task is cancelled")
}

func TestACleanIsNotCompleteUntilEveryRequiredItemIsAnswered(t *testing.T) {
	location := approved(t, "loc-1", bedInput())
	task := openTask(t, location, domain.TaskRoutine)
	if err := task.Start("cleaner-1", at); err != nil {
		t.Fatalf("Start: %v", err)
	}

	// An unticked box with no note is indistinguishable from one nobody
	// looked at, and the difference is the whole of an audit.
	err := task.Complete([]domain.ChecklistAnswer{
		{Code: "surfaces", Done: true},
		{Code: "floor", Done: false},
	}, "cleaner-1", at.Add(20*time.Minute))
	refused(t, err, "say why")

	// A required item nobody answered is a clean nobody can sign off.
	err = task.Complete([]domain.ChecklistAnswer{
		{Code: "surfaces", Done: true},
	}, "cleaner-1", at.Add(20*time.Minute))
	refused(t, err, "has not been answered")

	err = task.Complete([]domain.ChecklistAnswer{
		{Code: "", Done: true},
	}, "cleaner-1", at.Add(20*time.Minute))
	refused(t, err, "names its checklist item")

	err = task.Complete([]domain.ChecklistAnswer{
		{Code: "surfaces", Done: true}, {Code: "floor", Done: true},
	}, "", at.Add(20*time.Minute))
	refused(t, err, "names who did the work")

	// The optional item may be left out; the required ones may not, and a
	// not-done answer carries its exception.
	if err := task.Complete([]domain.ChecklistAnswer{
		{Code: "floor", Done: true},
		{Code: "surfaces", Done: false, Exception: "bed occupied"},
	}, "cleaner-1", at.Add(20*time.Minute)); err != nil {
		t.Fatalf("Complete: %v", err)
	}
	if len(task.Answers) != 2 || task.Answers[0].Code != "surfaces" {
		t.Fatalf("answers are not in checklist order: %+v", task.Answers)
	}
	refused(t, task.Complete(nil, "cleaner-1", at), "has not been started")
}

func TestACleanIsVerifiedBySomebodyOtherThanWhoeverDidIt(t *testing.T) {
	location := approved(t, "loc-1", bedInput())
	task := openTask(t, location, domain.TaskRoutine)

	// Nothing to verify until the work is done.
	refused(t, task.Verify("", "hk-super", at), "has not been completed")

	if err := task.Start("cleaner-1", at); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if err := task.Complete([]domain.ChecklistAnswer{
		{Code: "surfaces", Done: true}, {Code: "floor", Done: true},
	}, "cleaner-1", at.Add(20*time.Minute)); err != nil {
		t.Fatalf("Complete: %v", err)
	}

	// A clean signed off by the cleaner is the same claim made twice, and
	// supervisor verification is the requirement's own word for what this
	// is.
	refused(t, task.Verify("looks fine", "cleaner-1", at),
		"verified by somebody other than whoever did it")
	refused(t, task.Verify("looks fine", "", at), "names who made it")

	if err := task.Verify("spot-checked", "hk-super",
		at.Add(40*time.Minute)); err != nil {
		t.Fatalf("Verify: %v", err)
	}
	refused(t, task.Verify("again", "hk-super", at), "this task is verified")
}

func TestAScanIsEvidenceAndNeverAuthority(t *testing.T) {
	location := approved(t, "loc-1", bedInput())
	task := openTask(t, location, domain.TaskRoutine)

	// SRS-HKP-007 in one line: a scan does not replace user
	// authentication, so a scan with nobody behind it is not a scan.
	refused(t, task.RecordScan("W3B7", "", at), "names the person who made it")
	refused(t, task.RecordScan("", "cleaner-1", at), "needs the code")

	// A scan of the wrong door is recorded as a mismatch rather than
	// quietly accepted: either somebody is in the wrong room or the label
	// on this one is wrong, and both are findings.
	if err := task.RecordScan("TH2", "cleaner-1", at); err != nil {
		t.Fatalf("RecordScan: %v", err)
	}
	if task.Scans[0].Matched || task.ScanVerified() {
		t.Fatal("a scan of the wrong door counted as the right one")
	}
	if task.Scans[0].ScannedBy != "cleaner-1" {
		t.Fatalf("a scan is not attributed to the person: %+v", task.Scans[0])
	}
	// Recording it did not move the task: no path here completes work
	// because a scan happened.
	if task.State != domain.TaskOpen {
		t.Fatalf("a scan moved the task to %s", task.State)
	}

	if err := task.RecordScan("w3b7", "cleaner-1", at); err != nil {
		t.Fatalf("RecordScan: %v", err)
	}
	if !task.ScanVerified() {
		t.Fatal("the right door scanned does not count")
	}
}

func TestAnOverdueCleanInACriticalAreaEscalatesOnceAndOfficesDoNot(
	t *testing.T) {

	theatre := openTask(t, approved(t, "loc-1", theatreInput()),
		domain.TaskRoutine)
	office := openTask(t, approved(t, "loc-2", officeInput()),
		domain.TaskRoutine)
	office.ID = "task-office"

	later := at.Add(12 * time.Hour)
	if !theatre.Overdue(later) || !office.Overdue(later) {
		t.Fatal("both tasks should be past their SLA")
	}

	// A channel that repeated every overdue office clean is one people
	// filter, and the theatre goes with it.
	candidates := domain.EscalationCandidates(
		[]domain.CleaningTask{office, theatre}, later)
	if len(candidates) != 1 || candidates[0].LocationCode != "th-2" {
		t.Fatalf("want only the theatre escalated, got %+v", candidates)
	}

	// Once each.
	theatre.MarkEscalated(later)
	first := theatre.EscalatedAt
	theatre.MarkEscalated(later.Add(time.Hour))
	if !theatre.EscalatedAt.Equal(first) {
		t.Fatal("escalating twice moved the timestamp")
	}
	if got := domain.EscalationCandidates(
		[]domain.CleaningTask{theatre}, later); len(got) != 0 {
		t.Fatalf("an escalated task came up again: %+v", got)
	}

	// And a task somebody has done is not overdue, whatever the clock says.
	if err := theatre.Start("cleaner-1", later); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if err := theatre.Complete([]domain.ChecklistAnswer{
		{Code: "surfaces", Done: true}, {Code: "floor", Done: true},
	}, "cleaner-1", later.Add(10*time.Minute)); err != nil {
		t.Fatalf("Complete: %v", err)
	}
	if theatre.Overdue(later.Add(time.Hour)) {
		t.Fatal("a completed task is still overdue")
	}
}

// --------------------------------------------------- bed holds (SRS-HKP-003)

func TestABedIsHeldForATerminalCleanAndNothingElse(t *testing.T) {
	location := approved(t, "loc-1", bedInput())
	terminal := openTask(t, location, domain.TaskTerminal)

	// Holding a bed for a routine clean would take every bed on the ward
	// out of service every morning.
	routine := openTask(t, location, domain.TaskRoutine)
	_, err := domain.PlaceBedHold("hold-1", "t1", routine, "enc-1",
		"ward-clerk", at)
	refused(t, err, "held for a terminal clean")

	// A hold with no bed holds nothing and looks like it held something.
	bedless := terminal
	bedless.BedID = ""
	_, err = domain.PlaceBedHold("hold-1", "t1", bedless, "enc-1",
		"ward-clerk", at)
	refused(t, err, "names its bed")

	_, err = domain.PlaceBedHold("hold-1", "t1", terminal, "enc-1", "", at)
	refused(t, err, "names who placed it")

	_, err = domain.PlaceBedHold("", "t1", terminal, "enc-1", "ward-clerk", at)
	refused(t, err, "needs an id")

	hold, err := domain.PlaceBedHold("hold-1", "t1", terminal, "enc-1",
		"ward-clerk", at)
	if err != nil {
		t.Fatalf("PlaceBedHold: %v", err)
	}
	if hold.TaskID != terminal.ID || hold.BedID != "bed-7" ||
		hold.EncounterID != "enc-1" || hold.State != domain.HoldOpen {
		t.Fatalf("hold did not record what it holds: %+v", hold)
	}

	// The bed is not available, and this is the rule that stops a patient
	// being put into the bed the last one died in.
	if domain.BedClear([]domain.BedHold{hold}, "bed-7") {
		t.Fatal("a bed with an open terminal clean is clear")
	}
	// A bed this context knows nothing about is not reported dirty; a
	// system that called every bed in the hospital dirty would be ignored
	// within a day.
	if !domain.BedClear([]domain.BedHold{hold}, "bed-9") {
		t.Fatal("a bed nobody held is not clear")
	}
	if held := domain.HeldBeds([]domain.BedHold{hold}); len(held) != 1 {
		t.Fatalf("want one held bed, got %+v", held)
	}
}

func TestAHeldBedComesBackWhenTheCleanIsDoneOrSomebodyOverridesIt(
	t *testing.T) {

	location := approved(t, "loc-1", bedInput())
	task := openTask(t, location, domain.TaskTerminal)
	hold, err := domain.PlaceBedHold("hold-1", "t1", task, "enc-1",
		"ward-clerk", at)
	if err != nil {
		t.Fatalf("PlaceBedHold: %v", err)
	}

	// A hold released against a task that is not done is a bed reported
	// clean because somebody pressed the wrong button.
	refused(t, hold.Release(task, false, "ward-clerk", at),
		"the terminal clean is open")

	// And released against somebody else's task it is a bed reported clean
	// because a different room was.
	other := openTask(t, location, domain.TaskTerminal)
	other.ID = "task-other"
	other.State = domain.TaskCompleted
	refused(t, hold.Release(other, false, "ward-clerk", at),
		"this hold is on task task-1")

	if err := task.Start("cleaner-1", at.Add(5*time.Minute)); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if err := task.Complete([]domain.ChecklistAnswer{
		{Code: "surfaces", Done: true}, {Code: "floor", Done: true},
	}, "cleaner-1", at.Add(35*time.Minute)); err != nil {
		t.Fatalf("Complete: %v", err)
	}

	// Where a hospital verifies its terminal cleans, the bed comes back
	// when the supervisor says so and not when the cleaner does.
	refused(t, hold.Release(task, true, "ward-clerk", at),
		"has not been verified")

	if err := hold.Release(task, false, "ward-clerk",
		at.Add(40*time.Minute)); err != nil {
		t.Fatalf("Release: %v", err)
	}
	if hold.State != domain.HoldReleased {
		t.Fatalf("want a released hold, got %s", hold.State)
	}
	refused(t, hold.Release(task, false, "ward-clerk", at), "already released")
	refused(t, hold.Override("needed", "matron", at), "already released")
	if !domain.BedClear([]domain.BedHold{hold}, "bed-7") {
		t.Fatal("a released bed is still held")
	}

	// The other way out is a named override with a reason. It is a bed
	// going back into service uncleaned, which is sometimes the right call
	// in a full hospital and is always a decision somebody has to be able
	// to point at afterwards.
	second, err := domain.PlaceBedHold("hold-2", "t1", task, "enc-2",
		"ward-clerk", at)
	if err != nil {
		t.Fatalf("PlaceBedHold: %v", err)
	}
	refused(t, second.Override("", "matron", at), "say why")
	refused(t, second.Override("no beds left", "", at), "names who made it")
	if err := second.Override("no beds left", "matron",
		at.Add(time.Hour)); err != nil {
		t.Fatalf("Override: %v", err)
	}
	// Its own state, so a hospital cannot count it as a clean.
	if second.State != domain.HoldOverridden ||
		second.OverrideReason != "no beds left" {
		t.Fatalf("an override did not record itself: %+v", second)
	}
}

// ----------------------------------------------------- reports (SRS-HKP-008)

func TestTheCleaningSummaryIsDerivedFromTheTasksThemselves(t *testing.T) {
	location := approved(t, "loc-1", bedInput())

	done := openTask(t, location, domain.TaskRoutine)
	if err := done.Start("cleaner-1", at); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if err := done.RecordScan("W3B7", "cleaner-1", at); err != nil {
		t.Fatalf("RecordScan: %v", err)
	}
	if err := done.Complete([]domain.ChecklistAnswer{
		{Code: "surfaces", Done: true}, {Code: "floor", Done: true},
	}, "cleaner-1", at.Add(30*time.Minute)); err != nil {
		t.Fatalf("Complete: %v", err)
	}

	late := openTask(t, location, domain.TaskRoutine)
	if err := late.Start("cleaner-2", at); err != nil {
		t.Fatalf("Start: %v", err)
	}
	if err := late.Complete([]domain.ChecklistAnswer{
		{Code: "surfaces", Done: true}, {Code: "floor", Done: true},
	}, "cleaner-2", at.Add(190*time.Minute)); err != nil {
		t.Fatalf("Complete: %v", err)
	}
	if err := late.Verify("checked", "hk-super",
		at.Add(200*time.Minute)); err != nil {
		t.Fatalf("Verify: %v", err)
	}

	cancelled := openTask(t, location, domain.TaskRoutine)
	if err := cancelled.Cancel("duplicate", "hk-lead", at); err != nil {
		t.Fatalf("Cancel: %v", err)
	}

	outstanding := openTask(t, location, domain.TaskRoutine)

	summary := domain.SummariseCleaning([]domain.CleaningTask{
		done, late, cancelled, outstanding}, at.Add(4*time.Hour))

	if summary.Raised != 4 || summary.Completed != 2 ||
		summary.Cancelled != 1 || summary.Outstanding != 1 {
		t.Fatalf("counts are wrong: %+v", summary)
	}
	// The outstanding one is past its two-hour SLA at the moment asked
	// about, and a ward can still act on that — which is why it is counted
	// apart from the one that was finished late.
	if summary.OverdueNow != 1 || summary.CompletedLate != 1 ||
		summary.WithinSLA != 1 {
		t.Fatalf("SLA counts are wrong: %+v", summary)
	}
	if summary.MeanTurnaroundMinutes != 110 ||
		summary.LongestTurnaroundMinutes != 190 {
		t.Fatalf("turnaround is wrong: %+v", summary)
	}
	// Verification and scan evidence are counted against the completed
	// tasks: a task nobody has finished is not an audit failure yet.
	if summary.Verified != 1 || summary.ScanVerified != 1 {
		t.Fatalf("evidence counts are wrong: %+v", summary)
	}
	if summary.Unanswerable {
		t.Fatal("a set with completed tasks in it is unanswerable")
	}

	// A set with nothing completed says so rather than reporting a mean of
	// zero, which reads as a hospital that cleans every room instantly.
	empty := domain.SummariseCleaning(
		[]domain.CleaningTask{outstanding}, at.Add(4*time.Hour))
	if !empty.Unanswerable || empty.MeanTurnaroundMinutes != 0 {
		t.Fatalf("want an unanswerable summary, got %+v", empty)
	}
}

func TestAnOverriddenHoldIsNeverAveragedIntoTheTurnaround(t *testing.T) {
	released := domain.BedHold{
		BedID: "bed-1", State: domain.HoldReleased,
		PlacedAt: at, ReleasedAt: at.Add(60 * time.Minute),
	}
	slower := domain.BedHold{
		BedID: "bed-2", State: domain.HoldReleased,
		PlacedAt: at, ReleasedAt: at.Add(120 * time.Minute),
	}
	// Four minutes, and not a fast turnaround: the bed went back into
	// service uncleaned. A report that averaged it in would reward exactly
	// the thing the hold exists to discourage.
	overridden := domain.BedHold{
		BedID: "bed-3", State: domain.HoldOverridden,
		PlacedAt: at, OverriddenAt: at.Add(4 * time.Minute),
	}
	open := domain.BedHold{
		BedID: "bed-4", State: domain.HoldOpen, PlacedAt: at,
	}

	summary := domain.SummariseTurnaround([]domain.BedHold{
		released, slower, overridden, open})

	if summary.Held != 4 || summary.Released != 2 ||
		summary.Overridden != 1 || summary.StillHeld != 1 {
		t.Fatalf("counts are wrong: %+v", summary)
	}
	if summary.MeanMinutes != 90 || summary.LongestMinutes != 120 {
		t.Fatalf("an override changed the turnaround: %+v", summary)
	}

	nothing := domain.SummariseTurnaround([]domain.BedHold{overridden, open})
	if !nothing.Unanswerable || nothing.MeanMinutes != 0 {
		t.Fatalf("want an unanswerable turnaround, got %+v", nothing)
	}
}
