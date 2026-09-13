package domain

import (
	"sort"
	"strings"
	"time"
)

// The nursing care plan, the worklist and the handover
// (SRS-NUR-002, SRS-NUR-010, SRS-NUR-011).
//
// SRS-NUR-002's acceptance criterion is that care-plan tasks appear in the
// nursing worklist, which is the requirement that stops a care plan being a
// document nobody reads. A plan that does not generate work is a plan that is
// written on admission, filed, and discovered untouched at discharge. So the
// plan's interventions carry a frequency, the frequency generates tasks, and
// the tasks are the same tasks the worklist shows.

// TaskPriority is how urgent a piece of nursing work is.
type TaskPriority string

const (
	PriorityRoutine TaskPriority = "routine"
	PriorityUrgent  TaskPriority = "urgent"
	// PriorityCritical is the tier SRS-NUR-011 escalates. Reserved for work
	// where being late is itself harm — a time-critical antibiotic, a
	// neurological observation set.
	PriorityCritical TaskPriority = "critical"
)

var knownPriorities = map[TaskPriority]bool{
	PriorityRoutine: true, PriorityUrgent: true, PriorityCritical: true,
}

// rank orders priorities for the worklist.
func (p TaskPriority) rank() int {
	switch p {
	case PriorityCritical:
		return 0
	case PriorityUrgent:
		return 1
	default:
		return 2
	}
}

// TaskStatus is where a task stands.
type TaskStatus string

const (
	TaskPending TaskStatus = "pending"
	TaskDone    TaskStatus = "done"
	// TaskNotDone is work that was deliberately not carried out. Distinct from
	// pending, because a task nobody did and a task somebody decided against
	// are different facts and only one of them is a gap in care.
	TaskNotDone   TaskStatus = "not_done"
	TaskCancelled TaskStatus = "cancelled"
)

// NursingTask is one piece of nursing work (SRS-NUR-011).
type NursingTask struct {
	ID          string
	TenantID    string
	PatientID   string
	EncounterID string

	// Description is what to do, phrased as the action.
	Description string
	Priority    TaskPriority
	DueAt       time.Time

	// SourceKind and SourceID say where the task came from: a care-plan
	// activity, a due risk reassessment, a medication order. Kept so the
	// worklist can be traced back and so completing the task can close the
	// thing that raised it.
	SourceKind TaskSource
	SourceID   string

	// Recurrence generates the next task when this one is completed
	// (SRS-NUR-011's "recurrence"). Zero means a one-off.
	RecurEvery time.Duration
	// RecurUntil bounds the series. A recurrence with no end is a task that
	// keeps appearing after the patient has gone home.
	RecurUntil time.Time

	Status TaskStatus
	// Evidence is SRS-NUR-011's "completion evidence": what was observed or
	// done, not merely that a box was ticked. Required on completion, because a
	// tick with no evidence is indistinguishable from a tick to clear the list.
	Evidence    string
	CompletedAt time.Time
	CompletedBy string
	// NotDoneReason explains a deliberate omission.
	NotDoneReason string

	// AssignedTo is the nurse who holds it. Optional: unit tasks sit on the
	// ward list until somebody takes them.
	AssignedTo string

	// EscalatedAt records that an overdue critical task was raised. Stored so
	// the same task is not escalated repeatedly, and so a report can count how
	// often escalation fires.
	EscalatedAt time.Time
	EscalatedTo string

	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// TaskSource is what generated a task.
type TaskSource string

const (
	SourceCarePlan       TaskSource = "care_plan"
	SourceRiskReassess   TaskSource = "risk_reassessment"
	SourceMedication     TaskSource = "medication"
	SourceDeviceCare     TaskSource = "device_care"
	SourceManualTask     TaskSource = "manual"
	SourceRestraintCheck TaskSource = "restraint_check"
)

// NewTaskInput is what creating a task needs.
type NewTaskInput struct {
	PatientID   string
	EncounterID string
	Description string
	Priority    TaskPriority
	DueAt       time.Time
	SourceKind  TaskSource
	SourceID    string
	RecurEvery  time.Duration
	RecurUntil  time.Time
	AssignedTo  string
}

// NewTask creates a piece of nursing work.
func NewTask(id, tenantID string, in NewTaskInput, createdBy string,
	now time.Time) (*NursingTask, error) {

	if strings.TrimSpace(in.PatientID) == "" {
		return nil, invalidf("a task needs a patient")
	}
	if strings.TrimSpace(in.EncounterID) == "" {
		return nil, invalidf("a task needs an encounter")
	}
	if strings.TrimSpace(in.Description) == "" {
		return nil, invalidf("a task needs to say what to do")
	}
	if !knownPriorities[in.Priority] {
		return nil, invalidf("unknown task priority %q", in.Priority)
	}
	if strings.TrimSpace(createdBy) == "" {
		return nil, invalidf("a task must record who created it")
	}
	if in.DueAt.IsZero() {
		// A task with no due time never appears overdue, which means it never
		// escalates and never prompts anybody.
		return nil, invalidf("a task needs a due time")
	}
	if in.RecurEvery < 0 {
		return nil, invalidf("a recurrence interval cannot be negative")
	}
	if in.RecurEvery > 0 && !in.RecurUntil.IsZero() &&
		!in.RecurUntil.After(in.DueAt) {
		return nil, invalidf("a recurrence must end after the first occurrence")
	}

	return &NursingTask{
		ID: id, TenantID: tenantID,
		PatientID: in.PatientID, EncounterID: in.EncounterID,
		Description: strings.TrimSpace(in.Description),
		Priority:    in.Priority, DueAt: in.DueAt.UTC(),
		SourceKind: in.SourceKind, SourceID: in.SourceID,
		RecurEvery: in.RecurEvery,
		RecurUntil: normaliseTime(in.RecurUntil),
		Status:     TaskPending,
		AssignedTo: strings.TrimSpace(in.AssignedTo),
		CreatedAt:  now.UTC(), CreatedBy: createdBy, Version: 1,
	}, nil
}

func normaliseTime(t time.Time) time.Time {
	if t.IsZero() {
		return time.Time{}
	}
	return t.UTC()
}

// Complete marks a task done and returns the next occurrence where the task
// recurs (SRS-NUR-011).
func (t *NursingTask) Complete(evidence, by string, now time.Time,
	nextID string) (*NursingTask, error) {

	if t.Status != TaskPending {
		return nil, notAllowedf("this task is already %s", t.Status)
	}
	if strings.TrimSpace(evidence) == "" {
		return nil, invalidf("completing a task needs evidence of what was done")
	}
	if strings.TrimSpace(by) == "" {
		return nil, invalidf("completing a task must record who did it")
	}
	t.Status = TaskDone
	t.Evidence = strings.TrimSpace(evidence)
	t.CompletedAt = now.UTC()
	t.CompletedBy = by
	t.Version++

	if t.RecurEvery <= 0 {
		return nil, nil
	}
	// The next occurrence is due an interval after this one was *due*, not
	// after it was completed. Otherwise four-hourly observations charted an
	// hour late drift later every round until they are happening once a shift.
	next := t.DueAt.Add(t.RecurEvery)
	if !t.RecurUntil.IsZero() && !next.Before(t.RecurUntil) {
		return nil, nil
	}
	return &NursingTask{
		ID: nextID, TenantID: t.TenantID,
		PatientID: t.PatientID, EncounterID: t.EncounterID,
		Description: t.Description, Priority: t.Priority, DueAt: next,
		SourceKind: t.SourceKind, SourceID: t.SourceID,
		RecurEvery: t.RecurEvery, RecurUntil: t.RecurUntil,
		Status: TaskPending, AssignedTo: t.AssignedTo,
		CreatedAt: now.UTC(), CreatedBy: t.CreatedBy, Version: 1,
	}, nil
}

// NotDone records a deliberate omission.
func (t *NursingTask) NotDone(reason, by string, now time.Time) error {
	if t.Status != TaskPending {
		return notAllowedf("this task is already %s", t.Status)
	}
	if strings.TrimSpace(reason) == "" {
		return invalidf("not doing a task needs a reason")
	}
	if strings.TrimSpace(by) == "" {
		return invalidf("not doing a task must record who decided")
	}
	t.Status = TaskNotDone
	t.NotDoneReason = strings.TrimSpace(reason)
	t.CompletedAt = now.UTC()
	t.CompletedBy = by
	t.Version++
	return nil
}

// Overdue reports a task past its due time and still pending.
func (t *NursingTask) Overdue(now time.Time) bool {
	return t.Status == TaskPending && now.UTC().After(t.DueAt)
}

// NeedsEscalation reports an overdue critical task that has not yet been
// raised (SRS-NUR-011).
//
// Critical only. Escalating every overdue routine task would produce a
// notification stream nobody reads, and the first thing that gets lost in an
// unread stream is the critical one.
func (t *NursingTask) NeedsEscalation(now time.Time) bool {
	return t.Priority == PriorityCritical && t.Overdue(now) && t.EscalatedAt.IsZero()
}

// Escalate records that an overdue critical task was raised.
func (t *NursingTask) Escalate(to string, now time.Time) error {
	if !t.NeedsEscalation(now) {
		return notAllowedf("this task does not need escalating")
	}
	if strings.TrimSpace(to) == "" {
		return invalidf("an escalation needs somebody to escalate to")
	}
	t.EscalatedAt = now.UTC()
	t.EscalatedTo = to
	t.Version++
	return nil
}

// SortWorklist orders tasks the way a nurse works: most urgent first, then by
// how overdue.
func SortWorklist(tasks []*NursingTask) {
	sort.SliceStable(tasks, func(i, j int) bool {
		if tasks[i].Priority != tasks[j].Priority {
			return tasks[i].Priority.rank() < tasks[j].Priority.rank()
		}
		return tasks[i].DueAt.Before(tasks[j].DueAt)
	})
}

// CarePlan is a nursing plan of care (SRS-NUR-002).
type CarePlan struct {
	ID          string
	TenantID    string
	PatientID   string
	EncounterID string
	Title       string
	// Problems are the nursing problems the plan addresses.
	Problems []PlanProblem
	Status   PlanStatus

	CreatedAt time.Time
	CreatedBy string
	// ReviewedAt and ReviewedBy are SRS-NUR-002's "evaluation". A plan with no
	// evaluation is a plan nobody has checked against the patient.
	ReviewedAt time.Time
	ReviewedBy string
	Evaluation string

	Version int64
}

// PlanStatus is where a care plan stands.
type PlanStatus string

const (
	PlanActive    PlanStatus = "active"
	PlanCompleted PlanStatus = "completed"
	PlanCancelled PlanStatus = "cancelled"
)

// PlanProblem is one nursing problem with its goals and interventions.
type PlanProblem struct {
	ID          string
	Description string
	Coded       Coding
	Goals       []PlanGoal
	// Interventions are what the nurse will do. Each carries a frequency,
	// which is what turns the plan into work (SRS-NUR-002).
	Interventions []Intervention
	Resolved      bool
}

// PlanGoal is a measurable target.
type PlanGoal struct {
	ID          string
	Description string
	TargetDate  time.Time
	Met         bool
	// Evaluation is how the goal was judged. Required when a goal is marked
	// met, because "met" with no evidence is a plan closing itself.
	Evaluation string
}

// Intervention is a planned nursing action (SRS-NUR-002).
type Intervention struct {
	ID          string
	Description string
	// Every is how often. A frequency of zero means the intervention is
	// continuous or as-needed and generates no scheduled task.
	Every    time.Duration
	Priority TaskPriority
	Owner    string
}

// NewCarePlanInput is what creating a plan needs.
type NewCarePlanInput struct {
	PatientID   string
	EncounterID string
	Title       string
	Problems    []PlanProblem
}

// NewCarePlan creates a nursing care plan.
func NewCarePlan(id, tenantID string, in NewCarePlanInput, createdBy string,
	now time.Time) (*CarePlan, error) {

	if strings.TrimSpace(in.PatientID) == "" {
		return nil, invalidf("a care plan needs a patient")
	}
	if strings.TrimSpace(in.EncounterID) == "" {
		return nil, invalidf("a care plan needs an encounter")
	}
	if strings.TrimSpace(in.Title) == "" {
		return nil, invalidf("a care plan needs a title")
	}
	if strings.TrimSpace(createdBy) == "" {
		return nil, invalidf("a care plan must record who wrote it")
	}
	if len(in.Problems) == 0 {
		return nil, invalidf("a care plan needs at least one problem")
	}
	for _, p := range in.Problems {
		if strings.TrimSpace(p.Description) == "" {
			return nil, invalidf("every care-plan problem needs a description")
		}
		if len(p.Goals) == 0 {
			// A problem with no goal cannot be evaluated, and a plan that
			// cannot be evaluated is the document SRS-NUR-002 is trying to
			// prevent.
			return nil, invalidf("care-plan problem %q needs at least one goal",
				p.Description)
		}
		for _, g := range p.Goals {
			if strings.TrimSpace(g.Description) == "" {
				return nil, invalidf("every care-plan goal needs a description")
			}
		}
		for _, iv := range p.Interventions {
			if strings.TrimSpace(iv.Description) == "" {
				return nil, invalidf("every intervention needs a description")
			}
			if iv.Every < 0 {
				return nil, invalidf("an intervention frequency cannot be negative")
			}
			if iv.Every > 0 && !knownPriorities[iv.Priority] {
				return nil, invalidf(
					"a scheduled intervention needs a priority for the work it generates")
			}
		}
	}

	return &CarePlan{
		ID: id, TenantID: tenantID,
		PatientID: in.PatientID, EncounterID: in.EncounterID,
		Title:     strings.TrimSpace(in.Title),
		Problems:  append([]PlanProblem(nil), in.Problems...),
		Status:    PlanActive,
		CreatedAt: now.UTC(), CreatedBy: createdBy, Version: 1,
	}, nil
}

// PlannedWork is the tasks a care plan's interventions generate over a window
// (SRS-NUR-002).
//
// Generated from the plan rather than copied into it, so editing an
// intervention changes the work from that point rather than leaving orphaned
// tasks behind.
func (c *CarePlan) PlannedWork(from, to time.Time) []NewTaskInput {
	if c.Status != PlanActive {
		return nil
	}
	var out []NewTaskInput
	for _, p := range c.Problems {
		if p.Resolved {
			continue
		}
		for _, iv := range p.Interventions {
			if iv.Every <= 0 {
				continue
			}
			for at := from.UTC(); at.Before(to.UTC()); at = at.Add(iv.Every) {
				out = append(out, NewTaskInput{
					PatientID: c.PatientID, EncounterID: c.EncounterID,
					Description: iv.Description, Priority: iv.Priority,
					DueAt:      at,
					SourceKind: SourceCarePlan, SourceID: iv.ID,
					RecurEvery: iv.Every, RecurUntil: to.UTC(),
					AssignedTo: iv.Owner,
				})
			}
		}
	}
	return out
}

// Review records an evaluation of the plan (SRS-NUR-002).
func (c *CarePlan) Review(evaluation, by string, now time.Time) error {
	if c.Status != PlanActive {
		return notAllowedf("this care plan is %s", c.Status)
	}
	if strings.TrimSpace(evaluation) == "" {
		return invalidf("reviewing a care plan needs an evaluation")
	}
	if strings.TrimSpace(by) == "" {
		return invalidf("reviewing a care plan must record who reviewed it")
	}
	c.Evaluation = strings.TrimSpace(evaluation)
	c.ReviewedAt = now.UTC()
	c.ReviewedBy = by
	c.Version++
	return nil
}
