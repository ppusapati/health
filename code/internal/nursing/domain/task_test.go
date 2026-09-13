package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/nursing/domain"
)

func task(t *testing.T, priority domain.TaskPriority, due time.Time,
	every time.Duration) *domain.NursingTask {

	t.Helper()
	task, err := domain.NewTask("task-1", "tenant-1", domain.NewTaskInput{
		PatientID: "patient-1", EncounterID: "encounter-1",
		Description: "Four-hourly neurological observations",
		Priority:    priority, DueAt: due,
		SourceKind: domain.SourceCarePlan, SourceID: "intervention-1",
		RecurEvery: every,
	}, "nurse-1", at(8, 0))
	if err != nil {
		t.Fatalf("NewTask: %v", err)
	}
	return task
}

// SRS-NUR-011: completion evidence, not merely a tick.
func TestCompletingATaskNeedsEvidenceOfWhatWasDone(t *testing.T) {
	work := task(t, domain.PriorityRoutine, at(12, 0), 0)

	if _, err := work.Complete("", "nurse-1", at(12, 5), "task-2"); !errors.Is(
		err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a task was ticked with no evidence: %v", err)
	}
	if _, err := work.Complete("GCS 15, pupils equal and reactive", "nurse-1",
		at(12, 5), "task-2"); err != nil {
		t.Fatalf("Complete: %v", err)
	}
	if work.Evidence == "" || work.CompletedBy != "nurse-1" {
		t.Fatalf("the completion was not recorded: %+v", work)
	}
}

// SRS-NUR-011: recurrence. The next occurrence is due an interval after this
// one was due, not after it was completed.
func TestRecurringWorkDoesNotDriftLaterEachRound(t *testing.T) {
	work := task(t, domain.PriorityRoutine, at(12, 0), 4*time.Hour)

	// Completed an hour late.
	next, err := work.Complete("GCS 15", "nurse-1", at(13, 0), "task-2")
	if err != nil {
		t.Fatalf("Complete: %v", err)
	}
	if next == nil {
		t.Fatal("a recurring task produced no next occurrence")
	}
	if !next.DueAt.Equal(at(16, 0)) {
		t.Fatalf("the next occurrence is due at %s; four-hourly observations "+
			"would drift to once a shift", next.DueAt)
	}
}

func TestAOneOffTaskProducesNoNextOccurrence(t *testing.T) {
	work := task(t, domain.PriorityRoutine, at(12, 0), 0)
	next, err := work.Complete("done", "nurse-1", at(12, 5), "task-2")
	if err != nil {
		t.Fatalf("Complete: %v", err)
	}
	if next != nil {
		t.Fatal("a one-off task produced a next occurrence")
	}
}

// A recurrence with no end is a task that keeps appearing after the patient
// has gone home.
func TestARecurrenceStopsAtItsEnd(t *testing.T) {
	work, err := domain.NewTask("task-1", "tenant-1", domain.NewTaskInput{
		PatientID: "patient-1", EncounterID: "encounter-1",
		Description: "Four-hourly observations", Priority: domain.PriorityRoutine,
		DueAt: at(12, 0), RecurEvery: 4 * time.Hour, RecurUntil: at(14, 0),
	}, "nurse-1", at(8, 0))
	if err != nil {
		t.Fatalf("NewTask: %v", err)
	}
	next, err := work.Complete("GCS 15", "nurse-1", at(12, 5), "task-2")
	if err != nil {
		t.Fatalf("Complete: %v", err)
	}
	if next != nil {
		t.Fatalf("the recurrence continued past its end, next due %s", next.DueAt)
	}
}

// SRS-NUR-011: overdue critical tasks escalate. Only critical ones: a stream
// nobody reads loses the critical one first.
func TestOnlyOverdueCriticalTasksEscalate(t *testing.T) {
	routine := task(t, domain.PriorityRoutine, at(12, 0), 0)
	critical := task(t, domain.PriorityCritical, at(12, 0), 0)

	if !routine.Overdue(at(13, 0)) {
		t.Fatal("a task an hour past its due time is not overdue")
	}
	if routine.NeedsEscalation(at(13, 0)) {
		t.Fatal("an overdue routine task escalates")
	}
	if !critical.NeedsEscalation(at(13, 0)) {
		t.Fatal("an overdue critical task does not escalate")
	}

	if err := critical.Escalate("nurse-in-charge", at(13, 0)); err != nil {
		t.Fatalf("Escalate: %v", err)
	}
	// Escalated once, not repeatedly.
	if critical.NeedsEscalation(at(14, 0)) {
		t.Fatal("an already-escalated task escalates again")
	}
	if critical.EscalatedTo != "nurse-in-charge" {
		t.Fatalf("escalated to %q", critical.EscalatedTo)
	}
}

// A task nobody did and a task somebody decided against are different facts.
func TestADeliberateOmissionIsNotTheSameAsAnUndoneTask(t *testing.T) {
	work := task(t, domain.PriorityRoutine, at(12, 0), 0)
	if err := work.NotDone("patient at theatre", "nurse-1", at(12, 30)); err != nil {
		t.Fatalf("NotDone: %v", err)
	}
	if work.Status != domain.TaskNotDone {
		t.Fatalf("status is %q", work.Status)
	}
	if work.Overdue(at(20, 0)) {
		t.Fatal("a task explicitly not done still shows as overdue")
	}
	if err := work.NotDone("again", "nurse-1", at(13, 0)); !errors.Is(
		err, domain.ErrNotAllowed) {
		t.Fatalf("a closed task was closed again: %v", err)
	}
}

func TestANotDoneTaskNeedsAReason(t *testing.T) {
	work := task(t, domain.PriorityRoutine, at(12, 0), 0)
	if err := work.NotDone("", "nurse-1", at(12, 30)); !errors.Is(
		err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a task was skipped with no reason: %v", err)
	}
}

// A task with no due time never appears overdue, never escalates and never
// prompts anybody.
func TestATaskNeedsADueTime(t *testing.T) {
	_, err := domain.NewTask("task-1", "tenant-1", domain.NewTaskInput{
		PatientID: "patient-1", EncounterID: "encounter-1",
		Description: "Observations", Priority: domain.PriorityRoutine,
	}, "nurse-1", at(8, 0))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a task with no due time was accepted: %v", err)
	}
}

// The worklist is ordered the way a nurse works.
func TestTheWorklistPutsTheMostUrgentAndMostOverdueFirst(t *testing.T) {
	routineEarly := task(t, domain.PriorityRoutine, at(9, 0), 0)
	routineLate := task(t, domain.PriorityRoutine, at(15, 0), 0)
	urgent := task(t, domain.PriorityUrgent, at(14, 0), 0)
	critical := task(t, domain.PriorityCritical, at(16, 0), 0)

	tasks := []*domain.NursingTask{routineLate, urgent, routineEarly, critical}
	domain.SortWorklist(tasks)

	if tasks[0] != critical {
		t.Fatal("the critical task is not first, even though it is due last")
	}
	if tasks[1] != urgent {
		t.Fatal("the urgent task is not second")
	}
	if tasks[2] != routineEarly {
		t.Fatal("within a priority, the task due first is not first")
	}
}

func plan(t *testing.T) *domain.CarePlan {
	t.Helper()
	plan, err := domain.NewCarePlan("plan-1", "tenant-1",
		domain.NewCarePlanInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			Title: "Post-operative nursing plan",
			Problems: []domain.PlanProblem{{
				ID: "problem-1", Description: "Risk of pressure injury",
				Goals: []domain.PlanGoal{{
					ID: "goal-1", Description: "Skin remains intact",
					TargetDate: at(20, 0),
				}},
				Interventions: []domain.Intervention{{
					ID: "intervention-1", Description: "Reposition the patient",
					Every: 2 * time.Hour, Priority: domain.PriorityRoutine,
					Owner: "nurse-1",
				}},
			}},
		}, "nurse-1", at(8, 0))
	if err != nil {
		t.Fatalf("NewCarePlan: %v", err)
	}
	return plan
}

// SRS-NUR-002: care-plan tasks appear in the worklist. A plan that generates
// no work is a plan nobody reads.
func TestACarePlansInterventionsGenerateTheWorklist(t *testing.T) {
	work := plan(t).PlannedWork(at(8, 0), at(16, 0))
	if len(work) != 4 {
		t.Fatalf("two-hourly repositioning over eight hours produced %d tasks, want 4",
			len(work))
	}
	if work[0].SourceKind != domain.SourceCarePlan ||
		work[0].SourceID != "intervention-1" {
		t.Fatalf("the task does not trace back to the intervention: %+v", work[0])
	}
	if work[0].AssignedTo != "nurse-1" {
		t.Fatalf("the intervention's owner did not reach the task")
	}
}

// A resolved problem stops generating work; a cancelled plan stops entirely.
func TestAResolvedProblemAndAClosedPlanGenerateNoWork(t *testing.T) {
	resolved := plan(t)
	resolved.Problems[0].Resolved = true
	if len(resolved.PlannedWork(at(8, 0), at(16, 0))) != 0 {
		t.Fatal("a resolved problem still generates work")
	}

	closed := plan(t)
	closed.Status = domain.PlanCompleted
	if len(closed.PlannedWork(at(8, 0), at(16, 0))) != 0 {
		t.Fatal("a completed care plan still generates work")
	}
}

// An intervention with no frequency is continuous or as-needed and schedules
// nothing.
func TestAContinuousInterventionSchedulesNothing(t *testing.T) {
	p := plan(t)
	p.Problems[0].Interventions[0].Every = 0
	if len(p.PlannedWork(at(8, 0), at(16, 0))) != 0 {
		t.Fatal("a continuous intervention generated scheduled tasks")
	}
}

// A problem with no goal cannot be evaluated, and a plan that cannot be
// evaluated is the document the requirement is trying to prevent.
func TestACarePlanProblemNeedsAGoal(t *testing.T) {
	_, err := domain.NewCarePlan("plan-1", "tenant-1",
		domain.NewCarePlanInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			Title: "Post-operative nursing plan",
			Problems: []domain.PlanProblem{{
				ID: "problem-1", Description: "Risk of pressure injury",
			}},
		}, "nurse-1", at(8, 0))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a goalless care-plan problem was accepted: %v", err)
	}
}

// SRS-NUR-002: evaluation. A plan with no evaluation is a plan nobody has
// checked against the patient.
func TestReviewingACarePlanRecordsTheEvaluation(t *testing.T) {
	p := plan(t)
	if err := p.Review("skin intact at all pressure areas; continue",
		"nurse-2", at(20, 0)); err != nil {
		t.Fatalf("Review: %v", err)
	}
	if p.Evaluation == "" || p.ReviewedBy != "nurse-2" {
		t.Fatalf("the review was not recorded: %+v", p)
	}
	if err := p.Review("", "nurse-2", at(21, 0)); !errors.Is(
		err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("an empty evaluation was accepted: %v", err)
	}
}

func handover(t *testing.T) *domain.Handover {
	t.Helper()
	h, err := domain.NewHandover("handover-1", "tenant-1",
		domain.NewHandoverInput{
			PatientID: "patient-1", EncounterID: "encounter-1", UnitID: "unit-1",
			FromShift:  domain.Shift{Code: "day", StartsAt: at(8, 0), EndsAt: at(20, 0)},
			ToShift:    domain.Shift{Code: "night", StartsAt: at(20, 0)},
			Situation:  "Day two post laparotomy, pain controlled on oral analgesia",
			Background: "Admitted with perforated appendix",
			Assessment: "Observations stable, passing flatus",
			Recommendation: "Continue four-hourly observations; " +
				"mobilise with physiotherapy in the morning",
			CriticalRisks: []string{"Pressure injury risk: Braden 13"},
			Devices: []domain.HandoverDevice{{
				DeviceID: "device-1", Kind: domain.DeviceCentralLine,
				Site: "right internal jugular", DeviceDays: 3,
			}},
			PendingTasks: []domain.HandoverTask{{
				TaskID: "task-1", Description: "Repeat potassium",
				Priority: domain.PriorityUrgent, DueAt: at(22, 0),
			}},
		}, "nurse-1", at(19, 45))
	if err != nil {
		t.Fatalf("NewHandover: %v", err)
	}
	return h
}

// SRS-NUR-010: the acknowledgement and the shift are recorded, and the
// handover is a stored snapshot rather than a live screen.
func TestAHandoverIsAcknowledgedBeforeResponsibilityMoves(t *testing.T) {
	h := handover(t)
	if h.Acknowledged() {
		t.Fatal("a handover is acknowledged before anybody accepted it")
	}
	if err := h.Acknowledge("nurse-3", "who is covering the central line dressing?",
		at(20, 5)); err != nil {
		t.Fatalf("Acknowledge: %v", err)
	}
	if !h.Acknowledged() || h.AcknowledgedBy != "nurse-3" {
		t.Fatalf("the acknowledgement was not recorded: %+v", h)
	}
	if h.Questions == "" {
		t.Fatal("the incoming nurse's question was not recorded")
	}
	if h.FromShift.Code != "day" || h.ToShift.Code != "night" {
		t.Fatal("the shifts were not recorded")
	}
}

// One person marking their own work received would let a shift end with the
// record showing a transfer that never happened.
func TestANurseCannotAcknowledgeTheirOwnHandover(t *testing.T) {
	h := handover(t)
	if err := h.Acknowledge("nurse-1", "", at(20, 5)); !errors.Is(
		err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a nurse acknowledged their own handover: %v", err)
	}
}

func TestAHandoverIsAcknowledgedOnce(t *testing.T) {
	h := handover(t)
	if err := h.Acknowledge("nurse-3", "", at(20, 5)); err != nil {
		t.Fatalf("Acknowledge: %v", err)
	}
	if err := h.Acknowledge("nurse-4", "", at(20, 10)); !errors.Is(
		err, domain.ErrNotAllowed) {
		t.Fatalf("a handover was acknowledged twice: %v", err)
	}
}

// A handover nobody accepted means a patient nobody has taken responsibility
// for, which is the situation the record exists to surface.
func TestAnUnacknowledgedHandoverIsVisibleAsSuch(t *testing.T) {
	h := handover(t)
	if h.Unacknowledged(at(20, 0), time.Hour) {
		t.Fatal("a handover given fifteen minutes ago is reported unaccepted")
	}
	if !h.Unacknowledged(at(21, 30), time.Hour) {
		t.Fatal("a handover unaccepted after nearly two hours is not surfaced")
	}
}

// A handover that describes without recommending hands over information but
// not the work.
func TestAHandoverNeedsWhatTheIncomingShiftShouldDo(t *testing.T) {
	_, err := domain.NewHandover("handover-1", "tenant-1",
		domain.NewHandoverInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			FromShift: domain.Shift{Code: "day"}, ToShift: domain.Shift{Code: "night"},
			Situation: "Day two post laparotomy",
		}, "nurse-1", at(19, 45))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a handover with no recommendation was accepted: %v", err)
	}
}

// A handover that does not say which shift handed to which cannot establish
// who held the patient at any given hour.
func TestAHandoverNamesTheShiftsItIsBetween(t *testing.T) {
	_, err := domain.NewHandover("handover-1", "tenant-1",
		domain.NewHandoverInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			Situation:      "Day two post laparotomy",
			Recommendation: "Continue observations",
		}, "nurse-1", at(19, 45))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a handover with no shifts was accepted: %v", err)
	}
}

// A handover is a snapshot: what it said stays what it said.
func TestAHandoverIsASnapshotNotALiveView(t *testing.T) {
	h := handover(t)
	if len(h.PendingTasks) != 1 || h.PendingTasks[0].TaskID != "task-1" {
		t.Fatalf("the pending tasks were not captured: %+v", h.PendingTasks)
	}
	if h.Devices[0].DeviceDays != 3 {
		t.Fatalf("the device-day count at handover is %d, want 3",
			h.Devices[0].DeviceDays)
	}
}
