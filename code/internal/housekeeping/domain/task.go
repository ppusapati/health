package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// TaskKind is why a clean is happening (SRS-HKP-002, SRS-HKP-006).
type TaskKind string

const (
	// TaskRoutine is the scheduled clean the configuration says is due.
	TaskRoutine TaskKind = "routine"
	// TaskTerminal is the clean between one patient and the next. A bed is
	// out of service until it is done.
	TaskTerminal TaskKind = "terminal"
	// TaskSpill is blood, body fluid or a chemical. Restricted, because the
	// circumstances of a spill are often about a patient.
	TaskSpill TaskKind = "spill"
	// TaskDeep is a periodic deep clean, usually scheduled out of hours.
	TaskDeep TaskKind = "deep"
)

var knownTaskKind = map[TaskKind]bool{
	TaskRoutine: true, TaskTerminal: true,
	TaskSpill: true, TaskDeep: true,
}

// Restricted reports the kinds whose detail is not for a general worklist
// (SRS-HKP-006).
func (k TaskKind) Restricted() bool { return k == TaskSpill }

// TaskState is where a cleaning task stands (SRS-HKP-004).
type TaskState string

const (
	TaskOpen       TaskState = "open"
	TaskInProgress TaskState = "in_progress"
	// TaskCompleted is the work done and the checklist answered. Not the
	// end: a task in a place the hospital verifies is not finished until a
	// supervisor says so.
	TaskCompleted TaskState = "completed"
	TaskVerified  TaskState = "verified"
	// TaskCancelled is a task that should not have been raised — a bed
	// cleaned by the ward, a duplicate.
	TaskCancelled TaskState = "cancelled"
)

// Done reports a task nobody still has to do.
func (s TaskState) Done() bool {
	return s == TaskCompleted || s == TaskVerified || s == TaskCancelled
}

// ChecklistAnswer is one item's outcome (SRS-HKP-004).
type ChecklistAnswer struct {
	Code string
	Done bool
	// Exception is why an item was not done. Required when Done is false:
	// an unticked box with no note is indistinguishable from one nobody
	// looked at.
	Exception string
}

// CleaningTask is one piece of cleaning work (SRS-HKP-002, SRS-HKP-004).
type CleaningTask struct {
	ID       string
	TenantID string

	Kind         TaskKind
	LocationCode string
	LocationName string
	FacilityID   string
	Zone         string
	// BedID is set for a terminal clean on a bed, and is what the hold is
	// against.
	BedID string

	RiskClass RiskClass
	// LocationRevision pins the configuration this task was raised under.
	// A standard changed afterwards must not change what a completed task
	// was judged against.
	LocationRevision int
	// Checklist is the standard's items, copied at raise time for the same
	// reason.
	Checklist []ChecklistItem
	// ScanCode is the code expected at the door.
	ScanCode string

	// Restricted holds a spill's detail out of the general worklist. Set
	// from the kind rather than chosen, because an operator who could
	// un-restrict a biohazard task would.
	Restricted bool
	// IncidentRef links a spill to the incident it belongs to, in the
	// quality context. SRS-HKP-006's acceptance is that the link is
	// retained.
	IncidentRef string
	Detail      string

	AssigneeID string
	DueBy      time.Time

	State TaskState
	// Answers are the checklist outcomes. Empty until the task is
	// completed.
	Answers []ChecklistAnswer
	// Scans are the location scans somebody took while doing the work.
	// Evidence, never authority (SRS-HKP-007).
	Scans []LocationScan

	StartedAt time.Time
	StartedBy string
	// CompletedBy is who did the work.
	CompletedAt time.Time
	CompletedBy string
	// VerifiedBy is the supervisor, and it is never CompletedBy.
	VerifiedAt   time.Time
	VerifiedBy   string
	VerifyNote   string
	CancelReason string

	EscalatedAt time.Time

	RaisedAt time.Time
	RaisedBy string
	Version  int64
}

// NewTaskInput raises a cleaning task.
type NewTaskInput struct {
	Kind        TaskKind
	IncidentRef string
	Detail      string
	AssigneeID  string
}

// RaiseTask raises a piece of cleaning work against the standard in force
// (SRS-HKP-002, SRS-HKP-006).
//
// The checklist, the risk class and the SLA are taken from the location's
// configuration and copied onto the task. SRS-HKP-002's acceptance is that a
// task has a location, an SLA, an assignee and a checklist, and a task that
// pointed at a configuration instead would change underneath the person
// doing it.
func RaiseTask(id, tenantID string, location CleanableLocation,
	in NewTaskInput, by string, now time.Time) (CleaningTask, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return CleaningTask{}, fmt.Errorf("%w: a task needs an id",
			ErrInvalidHousekeeping)
	case !knownTaskKind[in.Kind]:
		return CleaningTask{}, fmt.Errorf("%w: unknown cleaning task kind %q",
			ErrInvalidHousekeeping, in.Kind)
	case !location.Live(now):
		// A task raised against a standard nobody approved is a task
		// answering a checklist nobody agreed to.
		return CleaningTask{}, fmt.Errorf(
			"%w: no approved cleaning standard is in force for %q",
			ErrInvalidHousekeeping, location.Code)
	case strings.TrimSpace(by) == "":
		return CleaningTask{}, fmt.Errorf("%w: a task names who raised it",
			ErrInvalidHousekeeping)
	}

	if in.Kind == TaskSpill && strings.TrimSpace(in.Detail) == "" {
		// A biohazard task with no detail sends somebody with the wrong
		// equipment.
		return CleaningTask{}, fmt.Errorf(
			"%w: a spill task says what was spilled",
			ErrInvalidHousekeeping)
	}
	if in.Kind == TaskTerminal && location.BedID == "" {
		// A terminal clean is the clean between one patient and the next,
		// and what it holds is a bed. Raising one against a corridor would
		// hold nothing and look like it held something.
		return CleaningTask{}, fmt.Errorf(
			"%w: a terminal clean is raised against a bed",
			ErrInvalidHousekeeping)
	}

	sla := location.RoutineSLAMinutes
	if in.Kind == TaskTerminal {
		sla = location.TerminalSLAMinutes
	}
	var dueBy time.Time
	if sla > 0 {
		dueBy = now.Add(time.Duration(sla) * time.Minute).UTC()
	}

	checklist := make([]ChecklistItem, len(location.Checklist))
	copy(checklist, location.Checklist)

	return CleaningTask{
		ID: id, TenantID: tenantID, Kind: in.Kind,
		LocationCode: location.Code, LocationName: location.Name,
		FacilityID: location.FacilityID, Zone: location.Zone,
		BedID: location.BedID, RiskClass: location.RiskClass,
		LocationRevision: location.Revision, Checklist: checklist,
		ScanCode:    location.ScanCode,
		Restricted:  in.Kind.Restricted(),
		IncidentRef: strings.TrimSpace(in.IncidentRef),
		Detail:      strings.TrimSpace(in.Detail),
		AssigneeID:  strings.TrimSpace(in.AssigneeID),
		DueBy:       dueBy, State: TaskOpen,
		RaisedAt: now.UTC(), RaisedBy: by, Version: 1,
	}, nil
}

// Assign gives a task to somebody (SRS-HKP-002).
func (t *CleaningTask) Assign(assigneeID string) error {
	switch {
	case t.State.Done():
		return fmt.Errorf("%w: this task is %s",
			ErrInvalidHousekeeping, t.State)
	case strings.TrimSpace(assigneeID) == "":
		return fmt.Errorf("%w: an assignment names somebody",
			ErrInvalidHousekeeping)
	}
	t.AssigneeID = strings.TrimSpace(assigneeID)
	return nil
}

// Start records somebody beginning the work (SRS-HKP-004).
func (t *CleaningTask) Start(by string, now time.Time) error {
	switch {
	case t.State != TaskOpen:
		return fmt.Errorf("%w: this task is %s",
			ErrInvalidHousekeeping, t.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a start names who began it",
			ErrInvalidHousekeeping)
	}
	t.State = TaskInProgress
	t.StartedAt, t.StartedBy = now.UTC(), by
	return nil
}

// Complete records the work done and the checklist answered (SRS-HKP-004).
//
// Every required item needs an answer, and an item answered "not done" needs
// its exception: an unticked box with no note is indistinguishable from one
// nobody looked at, and the difference is the whole of an audit.
func (t *CleaningTask) Complete(answers []ChecklistAnswer, by string,
	now time.Time) error {

	switch {
	case t.State != TaskInProgress:
		return fmt.Errorf("%w: this task is %s and has not been started",
			ErrInvalidHousekeeping, t.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a completion names who did the work",
			ErrInvalidHousekeeping)
	}

	given := map[string]ChecklistAnswer{}
	for _, answer := range answers {
		code := strings.TrimSpace(answer.Code)
		if code == "" {
			return fmt.Errorf("%w: an answer names its checklist item",
				ErrInvalidHousekeeping)
		}
		if !answer.Done && strings.TrimSpace(answer.Exception) == "" {
			return fmt.Errorf(
				"%w: say why %q was not done", ErrInvalidHousekeeping, code)
		}
		answer.Code = code
		answer.Exception = strings.TrimSpace(answer.Exception)
		given[strings.ToLower(code)] = answer
	}

	ordered := make([]ChecklistAnswer, 0, len(t.Checklist))
	for _, item := range t.Checklist {
		answer, answered := given[strings.ToLower(item.Code)]
		if !answered {
			if item.Required {
				return fmt.Errorf("%w: %q has not been answered",
					ErrInvalidHousekeeping, item.Code)
			}
			continue
		}
		ordered = append(ordered, answer)
	}

	t.State = TaskCompleted
	t.Answers = ordered
	t.CompletedAt, t.CompletedBy = now.UTC(), by
	return nil
}

// Verify records a supervisor checking the work (SRS-HKP-004).
//
// Never the person who did it. A clean signed off by the cleaner is the same
// claim made twice, and supervisor verification is the requirement's own
// word for what this is.
func (t *CleaningTask) Verify(note, by string, now time.Time) error {
	switch {
	case t.State != TaskCompleted:
		return fmt.Errorf("%w: this task is %s and has not been completed",
			ErrInvalidHousekeeping, t.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a verification names who made it",
			ErrInvalidHousekeeping)
	case by == t.CompletedBy:
		return fmt.Errorf(
			"%w: a clean is verified by somebody other than whoever did it",
			ErrInvalidHousekeeping)
	}
	t.State = TaskVerified
	t.VerifiedAt, t.VerifiedBy = now.UTC(), by
	t.VerifyNote = strings.TrimSpace(note)
	return nil
}

// Cancel abandons a task that should not have been raised (SRS-HKP-002).
func (t *CleaningTask) Cancel(reason, by string, now time.Time) error {
	switch {
	case t.State.Done():
		return fmt.Errorf("%w: this task is already %s",
			ErrInvalidHousekeeping, t.State)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say why the task is being cancelled",
			ErrInvalidHousekeeping)
	}
	t.State = TaskCancelled
	t.CancelReason = strings.TrimSpace(reason)
	t.CompletedAt, t.CompletedBy = now.UTC(), by
	return nil
}

// Overdue reports a task past its SLA (SRS-HKP-005).
func (t CleaningTask) Overdue(at time.Time) bool {
	return !t.State.Done() && !t.DueBy.IsZero() && at.After(t.DueBy)
}

// LocationScan is a code read at the door (SRS-HKP-007).
//
// Evidence that somebody was in the room, recorded against the authenticated
// person who scanned it. It is never authority: nothing in this package
// completes a task because a scan happened, and a scan that does not match
// the location is recorded as a mismatch rather than quietly accepted.
type LocationScan struct {
	// ScannedCode is what came off the label, exactly as read.
	ScannedCode string
	// Matched reports the code agreeing with the location's own. A mismatch
	// is the finding: somebody scanned the wrong door, or the label on this
	// one is wrong.
	Matched bool
	// ScannedBy is the authenticated caller. A scan attributed to a badge
	// rather than a session is a scan anybody holding the badge can make.
	ScannedBy string
	ScannedAt time.Time
}

// RecordScan attaches a location scan to a task (SRS-HKP-007).
func (t *CleaningTask) RecordScan(code, by string, now time.Time) error {
	switch {
	case t.State.Done():
		return fmt.Errorf("%w: this task is %s",
			ErrInvalidHousekeeping, t.State)
	case strings.TrimSpace(code) == "":
		return fmt.Errorf("%w: a scan needs the code that was read",
			ErrInvalidHousekeeping)
	case strings.TrimSpace(by) == "":
		// SRS-HKP-007's acceptance in one line: a scan does not replace
		// user authentication, so a scan with nobody behind it is not a
		// scan.
		return fmt.Errorf("%w: a scan names the person who made it",
			ErrInvalidHousekeeping)
	}

	code = strings.TrimSpace(code)
	t.Scans = append(t.Scans, LocationScan{
		ScannedCode: code,
		Matched:     t.ScanCode != "" && strings.EqualFold(code, t.ScanCode),
		ScannedBy:   by, ScannedAt: now.UTC(),
	})
	return nil
}

// ScanVerified reports a task somebody scanned the right door for.
func (t CleaningTask) ScanVerified() bool {
	for _, scan := range t.Scans {
		if scan.Matched {
			return true
		}
	}
	return false
}

// MarkEscalated records the notice having gone (SRS-HKP-005).
func (t *CleaningTask) MarkEscalated(now time.Time) {
	if t.EscalatedAt.IsZero() {
		t.EscalatedAt = now.UTC()
	}
}

// EscalationCandidates lists the overdue critical-area cleans that have not
// been escalated (SRS-HKP-005).
//
// Critical areas only, and once each. A channel that repeated every overdue
// office clean is one people filter, and the theatre goes with it.
func EscalationCandidates(tasks []CleaningTask, at time.Time) []CleaningTask {
	var out []CleaningTask
	for _, task := range tasks {
		if !task.RiskClass.Critical() || !task.Overdue(at) {
			continue
		}
		if !task.EscalatedAt.IsZero() {
			continue
		}
		out = append(out, task)
	}
	sort.Slice(out, func(a, b int) bool {
		return out[a].DueBy.Before(out[b].DueBy)
	})
	return out
}
