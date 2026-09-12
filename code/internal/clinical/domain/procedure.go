package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Procedures and care plans (SRS-CLN-006, SRS-CLN-007).

// Laterality is which side a procedure was performed on.
//
// Its own field rather than free text, because wrong-side surgery is a
// never-event and the only defence a record can offer is that the side was
// stated unambiguously, in a place a checklist can read.
type Laterality string

const (
	LateralityNotApplicable Laterality = "not_applicable"
	LateralityLeft          Laterality = "left"
	LateralityRight         Laterality = "right"
	LateralityBilateral     Laterality = "bilateral"
	// LateralityUnspecified is the honest answer when nobody recorded it, and
	// it is not the same as not-applicable. A system that defaulted an
	// unrecorded side to "not applicable" would make an omission look like a
	// decision.
	LateralityUnspecified Laterality = "unspecified"
)

var knownLateralities = map[Laterality]bool{
	LateralityNotApplicable: true, LateralityLeft: true, LateralityRight: true,
	LateralityBilateral: true, LateralityUnspecified: true,
}

// ProcedureStatus is how far a procedure got.
type ProcedureStatus string

const (
	ProcedurePlanned    ProcedureStatus = "planned"
	ProcedureInProgress ProcedureStatus = "in_progress"
	ProcedureCompleted  ProcedureStatus = "completed"
	// ProcedureStopped was begun and abandoned. Distinct from not-done, which
	// never started: a laparotomy abandoned on opening is a very different
	// fact from one that was cancelled.
	ProcedureStopped        ProcedureStatus = "stopped"
	ProcedureNotDone        ProcedureStatus = "not_done"
	ProcedureEnteredInError ProcedureStatus = "entered_in_error"
)

var knownProcedureStatuses = map[ProcedureStatus]bool{
	ProcedurePlanned: true, ProcedureInProgress: true, ProcedureCompleted: true,
	ProcedureStopped: true, ProcedureNotDone: true, ProcedureEnteredInError: true,
}

// Performer is one person's part in a procedure.
type Performer struct {
	SubjectID string
	// Role is what they did — "surgeon", "assistant", "anaesthetist".
	Role string
}

// Procedure is one thing done to a patient (SRS-CLN-006).
type Procedure struct {
	ID          string
	TenantID    string
	PatientID   string
	EncounterID string
	Code        Coding
	Status      ProcedureStatus
	// Indication is why it was done. Coded where possible, because a procedure
	// with no stated indication is one nobody can audit.
	Indication Coding
	Performers []Performer
	// BodySite and Laterality say where. Separate fields so a wrong-side check
	// can read the side without parsing a sentence.
	BodySite   Coding
	Laterality Laterality
	// Outcome is how it went, in the operator's words.
	Outcome string
	// Complications are coded so they can be counted. A complication in free
	// text is a complication that never reaches a quality report.
	Complications []Coding
	// OrderIDs link back to the orders that requested this, and DeviceIDs to
	// the implants used. References rather than copies: the requirement is
	// explicit that a procedure references implants and specimens "without
	// duplicating master data", and a copied implant record is the one that
	// stays wrong after a recall.
	OrderIDs    []string
	DeviceIDs   []string
	SpecimenIDs []string

	PerformedStart time.Time
	PerformedEnd   time.Time
	Note           string

	RecordedBy string
	RecordedAt time.Time
	UpdatedAt  time.Time
	Version    int64
}

// NewProcedure validates and constructs a procedure record.
func NewProcedure(id, tenantID string, in NewProcedureInput, recordedBy string,
	now time.Time) (Procedure, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Procedure{}, fmt.Errorf("%w: procedure id is required", ErrInvalidDocument)
	case strings.TrimSpace(in.PatientID) == "":
		return Procedure{}, fmt.Errorf("%w: a procedure needs a patient", ErrInvalidDocument)
	case strings.TrimSpace(in.EncounterID) == "":
		return Procedure{}, fmt.Errorf("%w: a procedure needs an encounter",
			ErrInvalidDocument)
	case !knownProcedureStatuses[in.Status]:
		return Procedure{}, fmt.Errorf("%w: unknown procedure status %q",
			ErrInvalidDocument, in.Status)
	case !knownLateralities[in.Laterality]:
		return Procedure{}, fmt.Errorf("%w: unknown laterality %q",
			ErrInvalidDocument, in.Laterality)
	case strings.TrimSpace(recordedBy) == "":
		return Procedure{}, fmt.Errorf("%w: a procedure must record its author",
			ErrInvalidDocument)
	}
	if err := in.Code.Validate(); err != nil {
		return Procedure{}, err
	}

	// A completed procedure names who did it. "The operation happened" with
	// nobody attached is a record that cannot answer the first question anybody
	// asks about it.
	if in.Status == ProcedureCompleted && len(in.Performers) == 0 {
		return Procedure{}, fmt.Errorf("%w: a completed procedure must name who performed it",
			ErrInvalidDocument)
	}
	for _, p := range in.Performers {
		if strings.TrimSpace(p.SubjectID) == "" || strings.TrimSpace(p.Role) == "" {
			return Procedure{}, fmt.Errorf("%w: every performer needs a person and a role",
				ErrInvalidDocument)
		}
	}

	if !in.PerformedEnd.IsZero() && !in.PerformedStart.IsZero() &&
		in.PerformedEnd.Before(in.PerformedStart) {
		return Procedure{}, fmt.Errorf("%w: a procedure cannot end before it started",
			ErrInvalidDocument)
	}

	return Procedure{
		ID: id, TenantID: tenantID, PatientID: in.PatientID,
		EncounterID: in.EncounterID, Code: in.Code, Status: in.Status,
		Indication: in.Indication, Performers: in.Performers,
		BodySite: in.BodySite, Laterality: in.Laterality,
		Outcome: strings.TrimSpace(in.Outcome), Complications: in.Complications,
		OrderIDs: in.OrderIDs, DeviceIDs: in.DeviceIDs, SpecimenIDs: in.SpecimenIDs,
		PerformedStart: in.PerformedStart.UTC(), PerformedEnd: in.PerformedEnd.UTC(),
		Note:       strings.TrimSpace(in.Note),
		RecordedBy: recordedBy, RecordedAt: now.UTC(), UpdatedAt: now.UTC(), Version: 1,
	}, nil
}

// NewProcedureInput is what recording a procedure needs.
type NewProcedureInput struct {
	PatientID      string
	EncounterID    string
	Code           Coding
	Status         ProcedureStatus
	Indication     Coding
	Performers     []Performer
	BodySite       Coding
	Laterality     Laterality
	Outcome        string
	Complications  []Coding
	OrderIDs       []string
	DeviceIDs      []string
	SpecimenIDs    []string
	PerformedStart time.Time
	PerformedEnd   time.Time
	Note           string
}

// Complicated reports a procedure that did not go to plan, which is what a
// quality report counts.
func (p Procedure) Complicated() bool {
	return len(p.Complications) > 0 || p.Status == ProcedureStopped
}

// CarePlanStatus is where a plan stands (SRS-CLN-007).
type CarePlanStatus string

const (
	CarePlanDraft     CarePlanStatus = "draft"
	CarePlanActive    CarePlanStatus = "active"
	CarePlanOnHold    CarePlanStatus = "on_hold"
	CarePlanCompleted CarePlanStatus = "completed"
	CarePlanRevoked   CarePlanStatus = "revoked"
)

var knownCarePlanStatuses = map[CarePlanStatus]bool{
	CarePlanDraft: true, CarePlanActive: true, CarePlanOnHold: true,
	CarePlanCompleted: true, CarePlanRevoked: true,
}

// GoalStatus is how a goal is going.
type GoalStatus string

const (
	GoalProposed    GoalStatus = "proposed"
	GoalActive      GoalStatus = "active"
	GoalAchieved    GoalStatus = "achieved"
	GoalNotAchieved GoalStatus = "not_achieved"
	GoalCancelled   GoalStatus = "cancelled"
)

var knownGoalStatuses = map[GoalStatus]bool{
	GoalProposed: true, GoalActive: true, GoalAchieved: true,
	GoalNotAchieved: true, GoalCancelled: true,
}

// Goal is what the plan is trying to achieve.
type Goal struct {
	ID string
	// Description is the goal in the words the patient and team agreed.
	Description string
	Status      GoalStatus
	// TargetDate is when it should be met by.
	TargetDate time.Time
	// AchievedAt is when it was.
	AchievedAt time.Time
}

// ActivityStatus is how an intervention is going.
type ActivityStatus string

const (
	ActivityNotStarted ActivityStatus = "not_started"
	ActivityScheduled  ActivityStatus = "scheduled"
	ActivityInProgress ActivityStatus = "in_progress"
	ActivityCompleted  ActivityStatus = "completed"
	ActivityCancelled  ActivityStatus = "cancelled"
)

var knownActivityStatuses = map[ActivityStatus]bool{
	ActivityNotStarted: true, ActivityScheduled: true, ActivityInProgress: true,
	ActivityCompleted: true, ActivityCancelled: true,
}

// Activity is one intervention in a plan.
type Activity struct {
	ID          string
	Description string
	// OwnerID is who is doing it. A plan whose activities have no owner is a
	// list of things everybody assumes somebody else is doing.
	OwnerID string
	Status  ActivityStatus
	// ScheduledFor is when it is due.
	ScheduledFor time.Time
	// TaskID links to the nursing or clinical task that carries it out, so the
	// worklist and the plan do not drift (SRS-NUR-002).
	TaskID string
}

// CarePlan is a plan of care for a patient (SRS-CLN-007).
type CarePlan struct {
	ID          string
	TenantID    string
	PatientID   string
	EncounterID string
	Title       string
	Status      CarePlanStatus
	// ProblemIDs are the problems this plan addresses. References rather than
	// copies: a plan holding its own copy of a diagnosis is the copy that stays
	// wrong after the diagnosis changes.
	ProblemIDs []string
	Goals      []Goal
	Activities []Activity
	// OwnerID is the clinician accountable for the plan.
	OwnerID string

	StartsAt time.Time
	EndsAt   time.Time

	CreatedBy string
	CreatedAt time.Time
	UpdatedAt time.Time
	Version   int64
}

// NewCarePlan validates and constructs a plan.
func NewCarePlan(id, tenantID, patientID, encounterID, title string,
	problemIDs []string, goals []Goal, activities []Activity, ownerID string,
	startsAt, endsAt time.Time, createdBy string, now time.Time) (CarePlan, error) {

	title = strings.TrimSpace(title)

	switch {
	case strings.TrimSpace(id) == "":
		return CarePlan{}, fmt.Errorf("%w: care-plan id is required", ErrInvalidDocument)
	case strings.TrimSpace(patientID) == "":
		return CarePlan{}, fmt.Errorf("%w: a care plan needs a patient", ErrInvalidDocument)
	case title == "":
		return CarePlan{}, fmt.Errorf("%w: a care plan needs a title", ErrInvalidDocument)
	case strings.TrimSpace(createdBy) == "":
		return CarePlan{}, fmt.Errorf("%w: a care plan must record its author",
			ErrInvalidDocument)
	case strings.TrimSpace(ownerID) == "":
		// A plan nobody owns is a list of things everybody assumes somebody
		// else is doing.
		return CarePlan{}, fmt.Errorf("%w: a care plan needs an accountable owner",
			ErrInvalidDocument)
	}

	for _, g := range goals {
		if strings.TrimSpace(g.Description) == "" {
			return CarePlan{}, fmt.Errorf("%w: every goal needs a description",
				ErrInvalidDocument)
		}
		if !knownGoalStatuses[g.Status] {
			return CarePlan{}, fmt.Errorf("%w: unknown goal status %q",
				ErrInvalidDocument, g.Status)
		}
	}
	for _, a := range activities {
		if strings.TrimSpace(a.Description) == "" {
			return CarePlan{}, fmt.Errorf("%w: every activity needs a description",
				ErrInvalidDocument)
		}
		if !knownActivityStatuses[a.Status] {
			return CarePlan{}, fmt.Errorf("%w: unknown activity status %q",
				ErrInvalidDocument, a.Status)
		}
	}

	if !endsAt.IsZero() && !startsAt.IsZero() && endsAt.Before(startsAt) {
		return CarePlan{}, fmt.Errorf("%w: a care plan cannot end before it starts",
			ErrInvalidDocument)
	}

	return CarePlan{
		ID: id, TenantID: tenantID, PatientID: patientID, EncounterID: encounterID,
		Title: title, Status: CarePlanDraft, ProblemIDs: problemIDs,
		Goals: goals, Activities: activities, OwnerID: ownerID,
		StartsAt: startsAt.UTC(), EndsAt: endsAt.UTC(),
		CreatedBy: createdBy, CreatedAt: now.UTC(), UpdatedAt: now.UTC(), Version: 1,
	}, nil
}

// SetStatus moves a plan through its life.
func (p *CarePlan) SetStatus(status CarePlanStatus, now time.Time) error {
	if !knownCarePlanStatuses[status] {
		return fmt.Errorf("%w: unknown care-plan status %q", ErrInvalidDocument, status)
	}
	p.Status = status
	p.UpdatedAt = now.UTC()
	return nil
}

// OutstandingActivities returns the interventions still to be done, earliest
// first — which is the order a worklist shows them (SRS-NUR-002).
func (p CarePlan) OutstandingActivities() []Activity {
	out := make([]Activity, 0, len(p.Activities))
	for _, a := range p.Activities {
		switch a.Status {
		case ActivityNotStarted, ActivityScheduled, ActivityInProgress:
			out = append(out, a)
		}
	}
	sort.SliceStable(out, func(i, j int) bool {
		if out[i].ScheduledFor.IsZero() != out[j].ScheduledFor.IsZero() {
			// Undated activities sort last: a task with no due time is not
			// urgent, and putting it at the top of a worklist buries the ones
			// that are.
			return !out[i].ScheduledFor.IsZero()
		}
		return out[i].ScheduledFor.Before(out[j].ScheduledFor)
	})
	return out
}
