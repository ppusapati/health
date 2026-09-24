package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// MaintenanceKind separates work a hospital chose to do from work it is
// required to do (SRS-FAC-003).
type MaintenanceKind string

const (
	// MaintenancePreventive is the hospital's own schedule: the quarterly
	// filter change, the annual chiller service.
	MaintenancePreventive MaintenanceKind = "preventive"
	// MaintenanceStatutory is an inspection somebody outside the hospital
	// requires — lifts, pressure vessels, fire systems, electrical
	// installation. Its own kind because a missed one is not a
	// housekeeping failure, it is an operating licence problem, and
	// because it closes with a certificate rather than a note.
	MaintenanceStatutory MaintenanceKind = "statutory"
)

var knownMaintenanceKind = map[MaintenanceKind]bool{
	MaintenancePreventive: true, MaintenanceStatutory: true,
}

// Trigger is what makes a schedule due (SRS-FAC-003, SRS-FAC-007).
type Trigger string

const (
	// TriggerCalendar is every N days.
	TriggerCalendar Trigger = "calendar"
	// TriggerRuntime is every N running hours, for plant whose wear
	// follows use rather than the calendar: generators, chillers, AHU
	// fans. SRS-FAC-007 exists for this.
	TriggerRuntime Trigger = "runtime"
	// TriggerEither is whichever comes first, which is what a generator
	// actually needs: serviced every six months, or every 250 hours, and
	// the year it ran the hospital through a monsoon it is the hours.
	TriggerEither Trigger = "either"
)

var knownTrigger = map[Trigger]bool{
	TriggerCalendar: true, TriggerRuntime: true, TriggerEither: true,
}

// UsesCalendar reports whether days matter to this trigger.
func (t Trigger) UsesCalendar() bool {
	return t == TriggerCalendar || t == TriggerEither
}

// UsesRuntime reports whether running hours matter to this trigger.
func (t Trigger) UsesRuntime() bool {
	return t == TriggerRuntime || t == TriggerEither
}

// Schedule is a recurring maintenance or inspection obligation
// (SRS-FAC-003, SRS-FAC-007).
type Schedule struct {
	ID       string
	TenantID string

	AssetID    string
	FacilityID string
	Title      string
	Kind       MaintenanceKind
	Trigger    Trigger

	// IntervalDays drives a calendar trigger.
	IntervalDays int
	// IntervalRuntimeHours drives a runtime trigger.
	IntervalRuntimeHours int

	// Authority is who requires a statutory inspection. Required for one,
	// because "statutory" with nobody named is a schedule that will be
	// deferred like any other.
	Authority string

	// RequiresEvidence means a task does not close on somebody's word.
	// Always true for statutory work; optional for preventive, where a
	// hospital may want photographs of the filter it replaced.
	RequiresEvidence bool

	// WorkClassCode is the safety class tasks inherit, so a schedule for
	// HV switchgear generates permit work rather than ordinary work.
	WorkClassCode string

	// GraceDays is how late a task may be before it counts as overdue
	// rather than due. Zero means due is due.
	GraceDays int

	Active    bool
	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// Validate rejects a schedule nothing could be generated from.
func (s Schedule) Validate() error {
	switch {
	case strings.TrimSpace(s.Title) == "":
		return fmt.Errorf("%w: a schedule needs a title",
			ErrInvalidFacilities)
	case !knownMaintenanceKind[s.Kind]:
		return fmt.Errorf("%w: unknown maintenance kind %q",
			ErrInvalidFacilities, s.Kind)
	case !knownTrigger[s.Trigger]:
		return fmt.Errorf("%w: unknown trigger %q",
			ErrInvalidFacilities, s.Trigger)
	case s.Trigger.UsesCalendar() && s.IntervalDays <= 0:
		return fmt.Errorf("%w: a calendar schedule needs an interval in days",
			ErrInvalidFacilities)
	case s.Trigger.UsesRuntime() && s.IntervalRuntimeHours <= 0:
		return fmt.Errorf("%w: a runtime schedule needs an interval in hours",
			ErrInvalidFacilities)
	case s.Trigger.UsesRuntime() && strings.TrimSpace(s.AssetID) == "":
		// Running hours belong to a machine. A runtime schedule against
		// a building is a schedule that can never come due.
		return fmt.Errorf("%w: a runtime schedule needs an asset",
			ErrInvalidFacilities)
	case s.Kind == MaintenanceStatutory &&
		strings.TrimSpace(s.Authority) == "":
		return fmt.Errorf("%w: a statutory inspection names who requires it",
			ErrInvalidFacilities)
	case s.Kind == MaintenanceStatutory && !s.RequiresEvidence:
		// A statutory inspection whose evidence is optional is one that
		// will be marked done on the day the inspector did not come.
		return fmt.Errorf("%w: a statutory inspection is evidenced",
			ErrInvalidFacilities)
	case s.GraceDays < 0:
		return fmt.Errorf("%w: grace cannot be negative",
			ErrInvalidFacilities)
	}
	return nil
}

// TaskState is where one occurrence of a schedule stands (SRS-FAC-003).
type TaskState string

const (
	TaskPlanned TaskState = "planned"
	TaskDone    TaskState = "done"
	// TaskMissed is an occurrence the window closed on. Kept rather than
	// deleted, because the reportable fact SRS-FAC-003 asks for is the
	// inspection that did not happen.
	TaskMissed TaskState = "missed"
	// TaskWaived was deliberately not done, with a reason and a name
	// against it — the lift that was out of service all quarter.
	TaskWaived TaskState = "waived"
)

var knownTaskState = map[TaskState]bool{
	TaskPlanned: true, TaskDone: true, TaskMissed: true, TaskWaived: true,
}

// Task is one occurrence of a schedule (SRS-FAC-003, SRS-FAC-007).
type Task struct {
	ID       string
	TenantID string

	ScheduleID string
	AssetID    string
	FacilityID string
	Title      string

	// ScheduleKind and ScheduleRequiresEvidence are copied from the
	// schedule for the same reason a work order copies its class flags: a
	// CHECK constraint sees one row, so "a completed statutory inspection
	// carries a certificate" is only a database rule if the task itself
	// knows it is statutory. A composite foreign key back to the schedule
	// holds the copy honest.
	ScheduleKind             MaintenanceKind
	ScheduleRequiresEvidence bool

	DueAt time.Time
	// DueRuntimeHours is the counter reading this task is due at, for a
	// runtime schedule. Zero when the trigger is the calendar.
	DueRuntimeHours int
	// TriggeredBy records which of the two actually brought it due, which
	// is the evidence SRS-FAC-007 asks for that a runtime trigger works.
	TriggeredBy Trigger

	State TaskState

	DoneAt   time.Time
	DoneBy   string
	Findings string
	// EvidenceRef points at the document store: a photograph, a service
	// report, a signed checklist.
	EvidenceRef string
	// CertificateRef and CertificateExpiresAt are the statutory pair. An
	// inspection certificate with no expiry is one nobody renews.
	CertificateRef       string
	CertificateExpiresAt time.Time

	WaivedReason string
	// WorkOrderID links a task to the work raised to do it, where the
	// hospital works that way. Optional: a filter change does not need a
	// ticket, and a chiller overhaul does.
	WorkOrderID string

	CreatedAt time.Time
	Version   int64
}

// Overdue reports whether a planned task has run past its grace.
func (t Task) Overdue(graceDays int, now time.Time) bool {
	if t.State != TaskPlanned || t.DueAt.IsZero() {
		return false
	}
	return now.After(t.DueAt.AddDate(0, 0, graceDays))
}

// PlanTask creates the next occurrence of a schedule (SRS-FAC-003).
func PlanTask(id string, s Schedule, dueAt time.Time, dueRuntimeHours int,
	by Trigger, now time.Time) (Task, error) {

	if err := s.Validate(); err != nil {
		return Task{}, err
	}
	switch {
	case strings.TrimSpace(id) == "":
		return Task{}, fmt.Errorf("%w: a task needs an id",
			ErrInvalidFacilities)
	case !s.Active:
		return Task{}, fmt.Errorf("%w: schedule %q is not active",
			ErrInvalidFacilities, s.Title)
	case dueAt.IsZero() && dueRuntimeHours <= 0:
		// A task due neither on a date nor at a reading is a task that
		// never appears on any list.
		return Task{}, fmt.Errorf("%w: a task needs a due date or a due reading",
			ErrInvalidFacilities)
	case !knownTrigger[by]:
		return Task{}, fmt.Errorf("%w: unknown trigger %q",
			ErrInvalidFacilities, by)
	}

	return Task{
		ID: id, TenantID: s.TenantID,
		ScheduleID: s.ID, AssetID: s.AssetID, FacilityID: s.FacilityID,
		Title:                    s.Title,
		ScheduleKind:             s.Kind,
		ScheduleRequiresEvidence: s.RequiresEvidence,
		DueAt:                    utcOrZero(dueAt),
		DueRuntimeHours:          dueRuntimeHours,
		TriggeredBy:              by,
		State:                    TaskPlanned,
		CreatedAt:                now.UTC(), Version: 1,
	}, nil
}

// CompleteInput records a maintenance task as done.
type CompleteInput struct {
	Findings             string
	EvidenceRef          string
	CertificateRef       string
	CertificateExpiresAt time.Time
	WorkOrderID          string
}

// Complete records a task as done (SRS-FAC-003).
//
// The two evidence rules here are the reportable half of the requirement. The
// database repeats both as CHECK constraints, which is why the task carries
// its schedule's kind and evidence flag rather than looking them up.
func (t *Task) Complete(in CompleteInput, by string, now time.Time) error {
	switch {
	case t.State != TaskPlanned:
		return fmt.Errorf("%w: this task is already %s",
			ErrInvalidFacilities, t.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: name who did the work",
			ErrInvalidFacilities)
	case strings.TrimSpace(in.Findings) == "":
		// "Done" is not a finding. The value of a maintenance history
		// is what the engineer saw, not that somebody was there.
		return fmt.Errorf("%w: record what was found",
			ErrInvalidFacilities)
	case t.ScheduleRequiresEvidence &&
		strings.TrimSpace(in.EvidenceRef) == "":
		return fmt.Errorf("%w: this task closes with evidence",
			ErrInvalidFacilities)
	case t.ScheduleKind == MaintenanceStatutory &&
		strings.TrimSpace(in.CertificateRef) == "":
		return fmt.Errorf("%w: a statutory inspection closes with a certificate",
			ErrInvalidFacilities)
	case t.ScheduleKind == MaintenanceStatutory &&
		in.CertificateExpiresAt.IsZero():
		// A certificate with no expiry is one nobody renews, and the
		// first anybody hears of it is the inspector.
		return fmt.Errorf("%w: say when the certificate expires",
			ErrInvalidFacilities)
	case !in.CertificateExpiresAt.IsZero() &&
		!in.CertificateExpiresAt.After(now):
		return fmt.Errorf("%w: that certificate has already expired",
			ErrInvalidFacilities)
	}

	t.State = TaskDone
	t.DoneAt = now.UTC()
	t.DoneBy = strings.TrimSpace(by)
	t.Findings = strings.TrimSpace(in.Findings)
	t.EvidenceRef = strings.TrimSpace(in.EvidenceRef)
	t.CertificateRef = strings.TrimSpace(in.CertificateRef)
	t.CertificateExpiresAt = utcOrZero(in.CertificateExpiresAt)
	t.WorkOrderID = strings.TrimSpace(in.WorkOrderID)
	return nil
}

// Waive records a task deliberately not done (SRS-FAC-003).
func (t *Task) Waive(reason, by string, now time.Time) error {
	switch {
	case t.State != TaskPlanned:
		return fmt.Errorf("%w: this task is already %s",
			ErrInvalidFacilities, t.State)
	case t.ScheduleKind == MaintenanceStatutory:
		// A hospital cannot waive its own lift inspection. If the
		// inspection genuinely cannot happen, the schedule is what
		// changes, with somebody's name on that decision.
		return fmt.Errorf("%w: a statutory inspection is not waived",
			ErrInvalidFacilities)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say why the task was not done",
			ErrInvalidFacilities)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: name who waived the task",
			ErrInvalidFacilities)
	}
	t.State = TaskWaived
	t.WaivedReason = strings.TrimSpace(reason)
	t.DoneBy = strings.TrimSpace(by)
	t.DoneAt = now.UTC()
	return nil
}

// Miss records a task whose window closed (SRS-FAC-003).
func (t *Task) Miss(now time.Time) error {
	if t.State != TaskPlanned {
		return fmt.Errorf("%w: this task is already %s",
			ErrInvalidFacilities, t.State)
	}
	t.State = TaskMissed
	t.DoneAt = now.UTC()
	return nil
}

// RuntimeReading is one reading of an asset's hour counter (SRS-FAC-007).
//
// Append-only. Readings are the evidence behind every runtime-triggered
// service, and a history that can be edited is a history that agrees with
// whatever the last service claimed.
type RuntimeReading struct {
	ID       string
	TenantID string
	AssetID  string

	// Hours is the counter as read, not hours since the last reading.
	// Cumulative because that is what the machine displays, and a
	// difference computed here cannot disagree with the panel.
	Hours  int
	ReadAt time.Time

	// Source says where the number came from, which is SRS-FAC-009's rule
	// applied to SRS-FAC-007's data: a figure typed by a technician and
	// one polled from a BMS are not interchangeable.
	Source     Source
	SourceRef  string
	RecordedBy string

	// CounterReplaced declares that the counter itself was changed, which
	// is the one legitimate reason a cumulative reading goes backwards.
	CounterReplaced bool
	Note            string

	CreatedAt time.Time
}

// RecordRuntime records a counter reading (SRS-FAC-007).
//
// previousHours is the last reading taken, or zero if this is the first. A
// reading below it is refused unless the caller says the counter was
// replaced: a generator whose hours dropped from 4,000 to 12 either has a new
// hour meter or has a reading somebody mistyped, and silently accepting it
// makes every runtime-triggered service after it fire at the wrong time.
func RecordRuntime(id, tenantID, assetID string, hours int, at time.Time,
	source Source, sourceRef string, counterReplaced bool, note, by string,
	previousHours int, now time.Time) (RuntimeReading, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return RuntimeReading{}, fmt.Errorf("%w: a reading needs an id",
			ErrInvalidFacilities)
	case strings.TrimSpace(assetID) == "":
		return RuntimeReading{}, fmt.Errorf("%w: a reading names its asset",
			ErrInvalidFacilities)
	case hours < 0:
		return RuntimeReading{}, fmt.Errorf("%w: hours cannot be negative",
			ErrInvalidFacilities)
	case at.IsZero():
		return RuntimeReading{}, fmt.Errorf("%w: a reading says when it was taken",
			ErrInvalidFacilities)
	case at.After(now.Add(time.Hour)):
		return RuntimeReading{}, fmt.Errorf("%w: that reading is in the future",
			ErrInvalidFacilities)
	case !knownSource[source]:
		return RuntimeReading{}, fmt.Errorf("%w: unknown source %q",
			ErrInvalidFacilities, source)
	case source != SourceManual && strings.TrimSpace(sourceRef) == "":
		// An automated reading with no reference cannot be traced back
		// to the gateway or meter that produced it, which is exactly
		// what makes an automated reading worth more than a typed one.
		return RuntimeReading{}, fmt.Errorf("%w: a %s reading names its source",
			ErrInvalidFacilities, source)
	case strings.TrimSpace(by) == "":
		return RuntimeReading{}, fmt.Errorf("%w: a reading names who recorded it",
			ErrInvalidFacilities)
	case hours < previousHours && !counterReplaced:
		return RuntimeReading{}, fmt.Errorf(
			"%w: %d hours is below the last reading of %d",
			ErrInvalidFacilities, hours, previousHours)
	case counterReplaced && strings.TrimSpace(note) == "":
		return RuntimeReading{}, fmt.Errorf(
			"%w: say what happened to the counter",
			ErrInvalidFacilities)
	}

	return RuntimeReading{
		ID: id, TenantID: tenantID, AssetID: strings.TrimSpace(assetID),
		Hours: hours, ReadAt: at.UTC(),
		Source: source, SourceRef: strings.TrimSpace(sourceRef),
		RecordedBy:      strings.TrimSpace(by),
		CounterReplaced: counterReplaced,
		Note:            strings.TrimSpace(note),
		CreatedAt:       now.UTC(),
	}, nil
}

// Due is a schedule that has come round (SRS-FAC-003, SRS-FAC-007).
type Due struct {
	Schedule Schedule
	// By says which trigger brought it due. The whole point of
	// SRS-FAC-007: a service that fired on hours rather than the calendar
	// can prove it did.
	By Trigger
	// DueAt is the calendar date, zero for a pure runtime trigger.
	DueAt time.Time
	// DueRuntimeHours is the counter reading, zero for a pure calendar
	// trigger.
	DueRuntimeHours int
	Overdue         bool
}

// NextDue works out whether a schedule has come round (SRS-FAC-003,
// SRS-FAC-007).
//
// lastDoneAt and lastDoneHours are where the clock and the counter stood when
// the schedule was last satisfied; currentHours is the latest reading. For a
// schedule that uses both, whichever arrives first wins, which is how plant
// manufacturers actually write their service intervals.
func NextDue(s Schedule, lastDoneAt time.Time, lastDoneHours, currentHours int,
	now time.Time) (Due, bool) {

	if !s.Active {
		return Due{}, false
	}
	if err := s.Validate(); err != nil {
		return Due{}, false
	}

	out := Due{Schedule: s}
	calendarDue, runtimeDue := false, false

	if s.Trigger.UsesCalendar() {
		from := lastDoneAt
		if from.IsZero() {
			from = s.CreatedAt
		}
		out.DueAt = from.AddDate(0, 0, s.IntervalDays).UTC()
		calendarDue = !now.Before(out.DueAt)
	}
	if s.Trigger.UsesRuntime() {
		out.DueRuntimeHours = lastDoneHours + s.IntervalRuntimeHours
		runtimeDue = currentHours >= out.DueRuntimeHours
	}

	switch {
	case runtimeDue && calendarDue:
		// Both. Name the one that got there first, because "serviced
		// because it had run 250 hours" and "serviced because it was
		// April" lead to different conclusions about the machine.
		out.By = TriggerRuntime
		if !out.DueAt.IsZero() && out.DueAt.Before(now) &&
			currentHours == out.DueRuntimeHours {
			out.By = TriggerCalendar
		}
	case runtimeDue:
		out.By = TriggerRuntime
	case calendarDue:
		out.By = TriggerCalendar
	default:
		return Due{}, false
	}

	if !out.DueAt.IsZero() {
		out.Overdue = now.After(out.DueAt.AddDate(0, 0, s.GraceDays))
	}
	return out, true
}

// MaintenanceReport is the due/overdue view SRS-FAC-003 asks for.
type MaintenanceReport struct {
	Planned int
	Overdue int
	Done    int
	Missed  int
	Waived  int
	// StatutoryOverdue is counted separately because it is a different
	// kind of problem: the rest is housekeeping, this is a licence.
	StatutoryOverdue int
	// EvidenceMissing counts completed tasks with no evidence against
	// them. Should always be zero — the domain and the database both
	// refuse it — so a non-zero reading means rows arrived some other way.
	EvidenceMissing int
	// OverdueTasks lists the worst, statutory first then oldest.
	OverdueTasks []Task
}

// SummariseMaintenance builds the due/overdue report (SRS-FAC-003).
func SummariseMaintenance(tasks []Task, graceDays int,
	now time.Time) MaintenanceReport {

	var out MaintenanceReport
	for _, task := range tasks {
		switch task.State {
		case TaskPlanned:
			out.Planned++
			if task.Overdue(graceDays, now) {
				out.Overdue++
				if task.ScheduleKind == MaintenanceStatutory {
					out.StatutoryOverdue++
				}
				out.OverdueTasks = append(out.OverdueTasks, task)
			}
		case TaskDone:
			out.Done++
			if task.ScheduleRequiresEvidence &&
				strings.TrimSpace(task.EvidenceRef) == "" {
				out.EvidenceMissing++
			}
		case TaskMissed:
			out.Missed++
		case TaskWaived:
			out.Waived++
		}
	}

	sort.SliceStable(out.OverdueTasks, func(i, j int) bool {
		a, b := out.OverdueTasks[i], out.OverdueTasks[j]
		if (a.ScheduleKind == MaintenanceStatutory) !=
			(b.ScheduleKind == MaintenanceStatutory) {
			return a.ScheduleKind == MaintenanceStatutory
		}
		return a.DueAt.Before(b.DueAt)
	})
	return out
}
