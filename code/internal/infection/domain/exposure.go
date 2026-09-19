package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// ExposureKind is how a member of staff was exposed (SRS-IPC-007).
type ExposureKind string

const (
	ExposureNeedlestick ExposureKind = "needlestick"
	ExposureSharps      ExposureKind = "sharps"
	ExposureSplash      ExposureKind = "mucocutaneous_splash"
	ExposureBite        ExposureKind = "bite"
	ExposureAirborne    ExposureKind = "airborne_contact"
)

var knownExposureKind = map[ExposureKind]bool{
	ExposureNeedlestick: true, ExposureSharps: true,
	ExposureSplash: true, ExposureBite: true, ExposureAirborne: true,
}

// Percutaneous reports the exposures that carry blood-borne virus risk and
// therefore a post-exposure prophylaxis clock.
func (k ExposureKind) Percutaneous() bool {
	return k == ExposureNeedlestick || k == ExposureSharps ||
		k == ExposureBite || k == ExposureSplash
}

// TaskState is where one time-sensitive step stands (SRS-IPC-007).
type TaskState string

const (
	TaskDue      TaskState = "due"
	TaskDone     TaskState = "done"
	TaskDeclined TaskState = "declined"
	// TaskNotApplicable is a step the assessment ruled out — a source known
	// negative, a staff member already immune.
	TaskNotApplicable TaskState = "not_applicable"
)

var knownTaskState = map[TaskState]bool{
	TaskDue: true, TaskDone: true, TaskDeclined: true,
	TaskNotApplicable: true,
}

// ExposureTask is one time-sensitive step after an exposure (SRS-IPC-007).
//
// Each carries its own clock, because they are not the same urgency: risk
// assessment is minutes, prophylaxis is hours, and baseline serology is days.
// A single "follow up within 72 hours" would let the one that matters slip.
type ExposureTask struct {
	ID         string
	TenantID   string
	ExposureID string

	Code string
	// DueBy is when it stops being useful, not when somebody would like it
	// done. Post-exposure prophylaxis started after 72 hours is prophylaxis
	// that does not work.
	DueBy time.Time

	State TaskState
	// Outcome is required for anything but "due": a declined prophylaxis and
	// a prophylaxis nobody offered look identical without it.
	Outcome     string
	CompletedAt time.Time
	CompletedBy string
}

// The steps a percutaneous exposure sets running.
const (
	TaskRiskAssessment = "risk_assessment"
	TaskSourceTesting  = "source_testing"
	TaskProphylaxis    = "post_exposure_prophylaxis"
	TaskBaselineBloods = "baseline_serology"
	TaskFollowUp       = "follow_up_serology"
)

// Exposure is one occupational exposure incident (SRS-IPC-007).
//
// Restricted, always. This is health information about a member of staff, held
// by their employer, and the source patient's serology is in it. A hospital
// whose exposure records are readable by the ward is a hospital whose staff
// stop reporting exposures — and an unreported needlestick is an untreated
// one.
type Exposure struct {
	ID       string
	TenantID string

	Reference string
	// StaffID is the exposed person. Never rendered onto a board or into an
	// event.
	StaffID    string
	Discipline Discipline
	FacilityID string
	LocationID string

	Kind ExposureKind
	// Device and Circumstance are what a prevention programme reads: the
	// same cannula on the same ward three times is a finding.
	Device       string
	Circumstance string
	DeepInjury   bool

	// SourcePatientID is the patient whose blood or fluid was involved, where
	// there was one. The most sensitive field in this context: it links a
	// named member of staff to a named patient's serology.
	SourcePatientID string
	SourceKnown     bool
	// SourceConsented records that the source patient agreed to testing.
	// Testing a patient's blood for the benefit of a member of staff without
	// consent is a decision with its own law, and a system that did not record
	// the consent would make it invisible.
	SourceConsented bool

	OccurredAt time.Time
	ReportedAt time.Time
	ReportedBy string

	ClosedAt time.Time
	ClosedBy string
	Outcome  string
	Version  int64
}

// NewExposureInput records an exposure.
type NewExposureInput struct {
	Reference       string
	StaffID         string
	Discipline      Discipline
	FacilityID      string
	LocationID      string
	Kind            ExposureKind
	Device          string
	Circumstance    string
	DeepInjury      bool
	SourcePatientID string
	SourceKnown     bool
	SourceConsented bool
	OccurredAt      time.Time
}

// ReportExposure records an occupational exposure (SRS-IPC-007).
func ReportExposure(id, tenantID string, in NewExposureInput, by string,
	now time.Time) (Exposure, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Exposure{}, fmt.Errorf("%w: an exposure needs an id",
			ErrInvalidInfection)
	case strings.TrimSpace(in.StaffID) == "":
		return Exposure{}, fmt.Errorf("%w: an exposure names who was exposed",
			ErrInvalidInfection)
	case !knownExposureKind[in.Kind]:
		return Exposure{}, fmt.Errorf("%w: unknown exposure kind %q",
			ErrInvalidInfection, in.Kind)
	case in.OccurredAt.IsZero():
		return Exposure{}, fmt.Errorf("%w: an exposure needs its time",
			ErrInvalidInfection)
	case in.OccurredAt.After(now):
		return Exposure{}, fmt.Errorf("%w: that exposure is in the future",
			ErrInvalidInfection)
	case strings.TrimSpace(in.Circumstance) == "":
		// What a prevention programme reads. Without it the hospital knows it
		// had eleven needlesticks and nothing about why.
		return Exposure{}, fmt.Errorf("%w: say how the exposure happened",
			ErrInvalidInfection)
	}

	// A source patient named without consent recorded is the case the law
	// cares about, and the one a system must not let pass silently.
	if in.SourcePatientID != "" && !in.SourceConsented {
		return Exposure{}, fmt.Errorf(
			"%w: testing a source patient needs their recorded consent",
			ErrInvalidInfection)
	}

	return Exposure{
		ID: id, TenantID: tenantID,
		Reference: strings.TrimSpace(in.Reference), StaffID: in.StaffID,
		Discipline: in.Discipline, FacilityID: in.FacilityID,
		LocationID: in.LocationID, Kind: in.Kind,
		Device:          strings.TrimSpace(in.Device),
		Circumstance:    strings.TrimSpace(in.Circumstance),
		DeepInjury:      in.DeepInjury,
		SourcePatientID: in.SourcePatientID,
		SourceKnown:     in.SourceKnown,
		SourceConsented: in.SourceConsented,
		OccurredAt:      in.OccurredAt.UTC(),
		ReportedAt:      now.UTC(), ReportedBy: by,
		Version: 1,
	}, nil
}

// ExposureTasks derives the steps an exposure sets running (SRS-IPC-007).
//
// Derived from the exposure rather than chosen by whoever took the report. The
// prophylaxis window is the reason: it is counted from the exposure and not
// from the report, and a member of staff who waited a day before telling
// anybody has a day less, not a fresh clock.
func ExposureTasks(exposure Exposure, newID func() string) []ExposureTask {
	if !exposure.Kind.Percutaneous() {
		// Still assessed, but no blood-borne virus clock.
		return []ExposureTask{{
			ID: newID(), TenantID: exposure.TenantID,
			ExposureID: exposure.ID, Code: TaskRiskAssessment,
			DueBy: exposure.OccurredAt.Add(2 * time.Hour), State: TaskDue,
		}}
	}

	tasks := []ExposureTask{
		{Code: TaskRiskAssessment, DueBy: exposure.OccurredAt.Add(2 * time.Hour)},
		// Prophylaxis first hours are what decide whether it works at all.
		{Code: TaskProphylaxis, DueBy: exposure.OccurredAt.Add(72 * time.Hour)},
		{Code: TaskBaselineBloods, DueBy: exposure.OccurredAt.Add(7 * 24 * time.Hour)},
		{Code: TaskFollowUp, DueBy: exposure.OccurredAt.AddDate(0, 3, 0)},
	}
	if exposure.SourceKnown {
		tasks = append(tasks, ExposureTask{
			Code:  TaskSourceTesting,
			DueBy: exposure.OccurredAt.Add(24 * time.Hour),
		})
	}

	out := make([]ExposureTask, 0, len(tasks))
	for _, task := range tasks {
		task.ID = newID()
		task.TenantID = exposure.TenantID
		task.ExposureID = exposure.ID
		task.State = TaskDue
		out = append(out, task)
	}
	sort.Slice(out, func(a, b int) bool {
		return out[a].DueBy.Before(out[b].DueBy)
	})
	return out
}

// Complete records a step being done, declined or ruled out (SRS-IPC-007).
func (t *ExposureTask) Complete(to TaskState, outcome, by string,
	now time.Time) error {

	switch {
	case !knownTaskState[to] || to == TaskDue:
		return fmt.Errorf("%w: unknown task outcome %q",
			ErrInvalidInfection, to)
	case t.State != TaskDue:
		return fmt.Errorf("%w: this step is already %s",
			ErrInvalidInfection, t.State)
	case strings.TrimSpace(outcome) == "":
		// A declined prophylaxis and a prophylaxis nobody offered look
		// identical without this.
		return fmt.Errorf("%w: record what happened at this step",
			ErrInvalidInfection)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a step names who completed it",
			ErrInvalidInfection)
	}

	t.State = to
	t.Outcome = strings.TrimSpace(outcome)
	t.CompletedAt, t.CompletedBy = now.UTC(), by
	return nil
}

// Overdue reports a step past the point it stops being useful.
func (t ExposureTask) Overdue(at time.Time) bool {
	return t.State == TaskDue && !t.DueBy.IsZero() && at.After(t.DueBy)
}

// CloseExposure signs an exposure off (SRS-IPC-007).
//
// Refused while a step is still due and not yet past its window: an exposure
// closed with prophylaxis outstanding is a member of staff nobody followed up.
// A step that has passed its window is a different matter — closing over it is
// allowed, and the outcome has to say so, because refusing would leave every
// late case open for ever and hide the ones that are still live.
func (e *Exposure) CloseExposure(tasks []ExposureTask, outcome, by string,
	now time.Time) error {

	switch {
	case !e.ClosedAt.IsZero():
		return fmt.Errorf("%w: this exposure is already closed",
			ErrInvalidInfection)
	case strings.TrimSpace(outcome) == "":
		return fmt.Errorf("%w: an exposure closes with its outcome",
			ErrInvalidInfection)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a closure names who made it",
			ErrInvalidInfection)
	}

	live := 0
	for _, task := range tasks {
		if task.ExposureID != e.ID {
			continue
		}
		if task.State == TaskDue && !task.Overdue(now) {
			live++
		}
	}
	if live > 0 {
		return fmt.Errorf("%w: %d step(s) are still within their window",
			ErrInvalidInfection, live)
	}

	e.ClosedAt, e.ClosedBy = now.UTC(), by
	e.Outcome = strings.TrimSpace(outcome)
	return nil
}
