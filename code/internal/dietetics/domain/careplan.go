package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Direction is which way a goal wants its measure to move (SRS-DIET-004).
//
// Carried because "target 60" means gain for an underweight patient and lose
// for another, and a trend that assumed one would report the other as
// deteriorating.
type Direction string

const (
	DirectionIncrease Direction = "increase"
	DirectionDecrease Direction = "decrease"
	// DirectionMaintain is a goal met by staying where it is, which is the
	// right goal for most inpatients and the one a system that only knows
	// increase and decrease cannot express.
	DirectionMaintain Direction = "maintain"
)

var knownDirection = map[Direction]bool{
	DirectionIncrease: true, DirectionDecrease: true,
	DirectionMaintain: true,
}

// NutritionGoal is one thing a care plan is trying to achieve
// (SRS-DIET-004).
type NutritionGoal struct {
	// Code identifies the measure — weight, energy intake, protein intake.
	// The deployment's own list rather than an enum, because what a hospital
	// tracks is its dietetics service's decision.
	Code  string
	Label string
	// Target and Unit are the number to reach, in base units and integers:
	// grams, kcal, millilitres, millimetres.
	Target    int
	Unit      string
	Direction Direction
	// Tolerance is how close counts as met, in the same unit. Zero means
	// exactly, which is almost never what anybody means about a body weight.
	Tolerance int
	TargetBy  time.Time
}

// PlanState is where a care plan stands (SRS-DIET-004).
type PlanState string

const (
	PlanActive PlanState = "active"
	PlanClosed PlanState = "closed"
)

// CarePlan is the dietitian's plan and what it is aiming at (SRS-DIET-004).
type CarePlan struct {
	ID       string
	TenantID string

	PatientID   string
	EncounterID string
	// AssessmentID is the assessment this plan was written from. Pinned,
	// because a plan whose reasoning cannot be produced is one nobody can
	// review.
	AssessmentID string

	Goals []NutritionGoal
	Plan  string
	// ReviewDue is when somebody must look again. A plan with no review date
	// is a plan that runs until discharge whatever happens to the patient.
	ReviewDue time.Time

	State       PlanState
	ClosedAt    time.Time
	ClosedBy    string
	ClosureNote string

	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// NewCarePlanInput opens a nutrition care plan.
type NewCarePlanInput struct {
	PatientID    string
	EncounterID  string
	AssessmentID string
	Goals        []NutritionGoal
	Plan         string
	ReviewDue    time.Time
}

// NewCarePlan opens a nutrition care plan (SRS-DIET-004).
func NewCarePlan(id, tenantID string, in NewCarePlanInput, by string,
	now time.Time) (CarePlan, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return CarePlan{}, fmt.Errorf("%w: a care plan needs an id",
			ErrInvalidDietetics)
	case strings.TrimSpace(in.PatientID) == "":
		return CarePlan{}, fmt.Errorf("%w: a care plan names its patient",
			ErrInvalidDietetics)
	case strings.TrimSpace(in.AssessmentID) == "":
		// A plan whose assessment cannot be produced is one nobody can
		// review, and reviewing it is the whole of the follow-up.
		return CarePlan{}, fmt.Errorf(
			"%w: a care plan names the assessment it was written from",
			ErrInvalidDietetics)
	case len(in.Goals) == 0:
		return CarePlan{}, fmt.Errorf(
			"%w: a care plan states what it is trying to achieve",
			ErrInvalidDietetics)
	}

	goals := make([]NutritionGoal, 0, len(in.Goals))
	seen := map[string]bool{}
	for _, goal := range in.Goals {
		code := strings.TrimSpace(goal.Code)
		switch {
		case code == "":
			return CarePlan{}, fmt.Errorf("%w: a goal needs a code",
				ErrInvalidDietetics)
		case seen[strings.ToLower(code)]:
			// The same measure twice is two targets, and progress against it
			// is whichever the reader picked.
			return CarePlan{}, fmt.Errorf("%w: goal %q appears twice",
				ErrInvalidDietetics, code)
		case !knownDirection[goal.Direction]:
			// "Target 60" is gain for one patient and loss for another.
			return CarePlan{}, fmt.Errorf(
				"%w: goal %q says which way it wants the measure to move",
				ErrInvalidDietetics, code)
		case strings.TrimSpace(goal.Unit) == "":
			return CarePlan{}, fmt.Errorf("%w: goal %q needs a unit",
				ErrInvalidDietetics, code)
		case goal.Tolerance < 0:
			return CarePlan{}, fmt.Errorf(
				"%w: goal %q has a negative tolerance",
				ErrInvalidDietetics, code)
		}
		seen[strings.ToLower(code)] = true
		goal.Code = code
		goal.Label = strings.TrimSpace(goal.Label)
		goal.Unit = strings.TrimSpace(goal.Unit)
		goal.TargetBy = utcOrZero(goal.TargetBy)
		goals = append(goals, goal)
	}

	return CarePlan{
		ID: id, TenantID: tenantID,
		PatientID: in.PatientID, EncounterID: in.EncounterID,
		AssessmentID: in.AssessmentID, Goals: goals,
		Plan: strings.TrimSpace(in.Plan), ReviewDue: utcOrZero(in.ReviewDue),
		State:     PlanActive,
		CreatedAt: now.UTC(), CreatedBy: by, Version: 1,
	}, nil
}

// Close finishes a care plan (SRS-DIET-004).
func (p *CarePlan) Close(note, by string, now time.Time) error {
	switch {
	case p.State == PlanClosed:
		return fmt.Errorf("%w: this plan is already closed",
			ErrInvalidDietetics)
	case strings.TrimSpace(note) == "":
		return fmt.Errorf("%w: say how the plan ended", ErrInvalidDietetics)
	}
	p.State = PlanClosed
	p.ClosedAt, p.ClosedBy = now.UTC(), by
	p.ClosureNote = strings.TrimSpace(note)
	return nil
}

// Progress is one measurement against a goal (SRS-DIET-004).
//
// Append-only: a measurement is a fact about a moment, and a trend built from
// measurements somebody corrected in place is a trend that shows whatever the
// last editor believed.
type Progress struct {
	ID       string
	TenantID string
	PlanID   string

	GoalCode   string
	Value      int
	Unit       string
	Note       string
	RecordedAt time.Time
	RecordedBy string
}

// RecordProgress measures a goal (SRS-DIET-004).
func (p CarePlan) RecordProgress(id, goalCode string, value int, note,
	by string, at, now time.Time) (Progress, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Progress{}, fmt.Errorf("%w: a measurement needs an id",
			ErrInvalidDietetics)
	case p.State != PlanActive:
		return Progress{}, fmt.Errorf("%w: this plan is closed",
			ErrInvalidDietetics)
	case strings.TrimSpace(by) == "":
		return Progress{}, fmt.Errorf("%w: a measurement names who took it",
			ErrInvalidDietetics)
	}

	for _, goal := range p.Goals {
		if !strings.EqualFold(goal.Code, goalCode) {
			continue
		}
		when := at
		if when.IsZero() {
			when = now
		}
		return Progress{
			ID: id, TenantID: p.TenantID, PlanID: p.ID,
			GoalCode: goal.Code, Value: value, Unit: goal.Unit,
			Note:       strings.TrimSpace(note),
			RecordedAt: when.UTC(), RecordedBy: by,
		}, nil
	}
	// A measurement against a goal the plan does not have is one nobody will
	// ever see: it appears in no trend and answers no review.
	return Progress{}, fmt.Errorf("%w: this plan has no goal %q",
		ErrInvalidDietetics, goalCode)
}

// TrendPoint is one measurement on a goal's trend (SRS-DIET-004).
type TrendPoint struct {
	Value int
	At    time.Time
}

// Trend is a goal and its measurements over time (SRS-DIET-004).
type Trend struct {
	Goal   NutritionGoal
	Points []TrendPoint
	// Met reports the latest measurement inside the goal's tolerance.
	Met bool
	// Improving compares the latest measurement with the first in the
	// goal's own direction. Reported beside Met rather than instead of it:
	// a patient moving the right way and still far from target is a
	// different conversation from one who has arrived.
	Improving bool
	// Unanswerable is a goal with nothing measured against it. Reported
	// rather than shown as a flat line at zero, which reads as a patient
	// whose weight is nothing.
	Unanswerable bool
}

// TrendFor builds a goal's trend (SRS-DIET-004).
func TrendFor(plan CarePlan, progress []Progress, goalCode string) (
	Trend, bool) {

	var goal NutritionGoal
	found := false
	for _, candidate := range plan.Goals {
		if strings.EqualFold(candidate.Code, goalCode) {
			goal, found = candidate, true
			break
		}
	}
	if !found {
		return Trend{}, false
	}

	out := Trend{Goal: goal}
	for _, entry := range progress {
		if entry.PlanID != plan.ID ||
			!strings.EqualFold(entry.GoalCode, goal.Code) {
			continue
		}
		out.Points = append(out.Points, TrendPoint{
			Value: entry.Value, At: entry.RecordedAt,
		})
	}
	if len(out.Points) == 0 {
		out.Unanswerable = true
		return out, true
	}
	sort.Slice(out.Points, func(a, b int) bool {
		return out.Points[a].At.Before(out.Points[b].At)
	})

	first := out.Points[0].Value
	latest := out.Points[len(out.Points)-1].Value
	gap := latest - goal.Target
	if gap < 0 {
		gap = -gap
	}
	out.Met = gap <= goal.Tolerance

	switch goal.Direction {
	case DirectionIncrease:
		out.Improving = latest > first
	case DirectionDecrease:
		out.Improving = latest < first
	case DirectionMaintain:
		// Holding steady is the achievement, so improving means the gap to
		// target did not grow.
		startGap := first - goal.Target
		if startGap < 0 {
			startGap = -startGap
		}
		out.Improving = gap <= startGap
	}
	return out, true
}
