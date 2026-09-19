package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// SampleKind is what was tested (SRS-IPC-009).
//
// Named rather than free text because each kind has its own limit and its own
// unit: 100 colony-forming units means something different in a litre of
// dialysis water and on a settle plate, and a hospital whose sample kinds were
// typed by hand could not apply a limit to them at all.
type SampleKind string

const (
	SampleWater          SampleKind = "water"
	SampleDialysisWater  SampleKind = "dialysis_water"
	SampleIce            SampleKind = "ice"
	SampleAirSettle      SampleKind = "air_settle_plate"
	SampleAirParticle    SampleKind = "air_particle_count"
	SampleSurfaceSwab    SampleKind = "surface_swab"
	SampleEndoscopeRinse SampleKind = "endoscope_rinse"
	// SamplePressure is a ventilation pressure differential — an isolation
	// room that is meant to be negative and is not.
	SamplePressure SampleKind = "ventilation_pressure"
)

var knownSampleKind = map[SampleKind]bool{
	SampleWater: true, SampleDialysisWater: true, SampleIce: true,
	SampleAirSettle: true, SampleAirParticle: true, SampleSurfaceSwab: true,
	SampleEndoscopeRinse: true, SamplePressure: true,
}

// Outcome is how a result stands against its limit (SRS-IPC-009).
//
// Derived from the limit, never typed. The same reasoning as onset
// classification: a failed water sample entered as a pass does not move
// between reports, it stops existing, and the ward carries on drinking it.
type Outcome string

const (
	OutcomePass Outcome = "pass"
	// OutcomeAction is above the action level but below failure: the level at
	// which a hospital does something before it has a problem.
	OutcomeAction Outcome = "action_level"
	OutcomeFail   Outcome = "fail"
	// OutcomeUnassessable is a result with no live limit to judge it by.
	// Named rather than passed: a sample nobody can judge is not a sample
	// that passed.
	OutcomeUnassessable Outcome = "unassessable"
)

// Failing reports the outcomes that require a corrective action.
func (o Outcome) Failing() bool { return o == OutcomeAction || o == OutcomeFail }

// EnvironmentalLimit is a versioned threshold (SRS-IPC-009, SRS-IPC-010).
//
// Versioned and approved like the alert and stewardship rules. A limit
// loosened after a bad quarter would otherwise turn every past failure into a
// pass retrospectively, and the water would look as though it had improved.
type EnvironmentalLimit struct {
	ID       string
	TenantID string

	Code     string
	Name     string
	Revision int

	SampleKind SampleKind
	// Unit is the unit the values are counted in — cfu/ml, cfu/plate,
	// particles/m3, tenths of a pascal. Values are integers in this unit, so
	// two reports of the same sample cannot differ by a rounding.
	Unit string
	// ActionLevel is the value at or above which something is done.
	ActionLevel int64
	// FailLevel is the value at or above which the sample has failed.
	FailLevel int64
	// DetectionFails makes any detection a failure regardless of the count —
	// legionella in an augmented-care water supply is the case this exists
	// for.
	DetectionFails bool
	// BelowIsFailure inverts the comparison, for the measures where low is
	// bad: an isolation room's negative pressure, an air-change rate.
	BelowIsFailure bool

	Approved   bool
	ApprovedBy string
	ApprovedAt time.Time

	EffectiveFrom time.Time
	SupersededAt  time.Time
	CreatedAt     time.Time
	CreatedBy     string
}

// Live reports a limit in force at a moment.
func (l EnvironmentalLimit) Live(at time.Time) bool {
	if !l.Approved {
		return false
	}
	if l.EffectiveFrom.IsZero() || l.EffectiveFrom.After(at) {
		return false
	}
	return l.SupersededAt.IsZero() || l.SupersededAt.After(at)
}

// NewLimitInput configures an environmental limit.
type NewLimitInput struct {
	Code           string
	Name           string
	Revision       int
	SampleKind     SampleKind
	Unit           string
	ActionLevel    int64
	FailLevel      int64
	DetectionFails bool
	BelowIsFailure bool
	EffectiveFrom  time.Time
}

// NewEnvironmentalLimit configures a limit (SRS-IPC-009).
func NewEnvironmentalLimit(id, tenantID string, in NewLimitInput, by string,
	now time.Time) (EnvironmentalLimit, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return EnvironmentalLimit{}, fmt.Errorf("%w: a limit needs an id",
			ErrInvalidInfection)
	case strings.TrimSpace(in.Code) == "":
		return EnvironmentalLimit{}, fmt.Errorf("%w: a limit needs a code",
			ErrInvalidInfection)
	case in.Revision <= 0:
		return EnvironmentalLimit{}, fmt.Errorf(
			"%w: a limit revision starts at 1", ErrInvalidInfection)
	case !knownSampleKind[in.SampleKind]:
		return EnvironmentalLimit{}, fmt.Errorf("%w: unknown sample kind %q",
			ErrInvalidInfection, in.SampleKind)
	case strings.TrimSpace(in.Unit) == "":
		// A number without its unit is a number nobody can compare.
		return EnvironmentalLimit{}, fmt.Errorf("%w: a limit names its unit",
			ErrInvalidInfection)
	}

	// The ordering has to make sense in the direction the limit runs, or a
	// result would be a failure and an action level at once.
	if in.BelowIsFailure {
		if in.FailLevel > in.ActionLevel {
			return EnvironmentalLimit{}, fmt.Errorf(
				"%w: where low is bad the fail level sits below the action level",
				ErrInvalidInfection)
		}
	} else if in.FailLevel < in.ActionLevel {
		return EnvironmentalLimit{}, fmt.Errorf(
			"%w: the fail level sits above the action level",
			ErrInvalidInfection)
	}

	return EnvironmentalLimit{
		ID: id, TenantID: tenantID,
		Code: strings.TrimSpace(in.Code), Name: strings.TrimSpace(in.Name),
		Revision: in.Revision, SampleKind: in.SampleKind,
		Unit:        strings.TrimSpace(in.Unit),
		ActionLevel: in.ActionLevel, FailLevel: in.FailLevel,
		DetectionFails: in.DetectionFails,
		BelowIsFailure: in.BelowIsFailure,
		EffectiveFrom:  utcOrZero(in.EffectiveFrom),
		CreatedAt:      now.UTC(), CreatedBy: by,
	}, nil
}

// Approve signs a limit off (SRS-IPC-009).
func (l *EnvironmentalLimit) Approve(by string, effectiveFrom, now time.Time) error {
	switch {
	case l.Approved:
		return fmt.Errorf("%w: this limit is already approved",
			ErrInvalidInfection)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an approval names who gave it",
			ErrInvalidInfection)
	case by == l.CreatedBy:
		return fmt.Errorf("%w: the author of a limit cannot approve it",
			ErrInvalidInfection)
	case effectiveFrom.IsZero():
		return fmt.Errorf("%w: an approved limit names when it takes effect",
			ErrInvalidInfection)
	}
	l.Approved, l.ApprovedBy, l.ApprovedAt = true, by, now.UTC()
	l.EffectiveFrom = effectiveFrom.UTC()
	return nil
}

// Assess judges a value against a limit (SRS-IPC-009).
func (l EnvironmentalLimit) Assess(value int64, detected bool) Outcome {
	if l.DetectionFails && detected {
		return OutcomeFail
	}
	if l.BelowIsFailure {
		switch {
		case value <= l.FailLevel:
			return OutcomeFail
		case value <= l.ActionLevel:
			return OutcomeAction
		}
		return OutcomePass
	}
	switch {
	case value >= l.FailLevel:
		return OutcomeFail
	case value >= l.ActionLevel:
		return OutcomeAction
	}
	return OutcomePass
}

// LimitFor picks the live limit for a sample kind (SRS-IPC-009).
//
// The latest revision in force at the moment of the result, not the latest
// revision there is: a sample taken in March is judged by March's limit.
func LimitFor(limits []EnvironmentalLimit, kind SampleKind,
	at time.Time) (EnvironmentalLimit, bool) {

	var best EnvironmentalLimit
	found := false
	for _, limit := range limits {
		if limit.SampleKind != kind || !limit.Live(at) {
			continue
		}
		if !found || limit.EffectiveFrom.After(best.EffectiveFrom) ||
			(limit.EffectiveFrom.Equal(best.EffectiveFrom) &&
				limit.Revision > best.Revision) {
			best, found = limit, true
		}
	}
	return best, found
}

// SampleState is where an environmental sample stands (SRS-IPC-009).
type SampleState string

const (
	SampleCollected SampleState = "collected"
	SampleResulted  SampleState = "resulted"
	SampleClosed    SampleState = "closed"
)

// EnvironmentalSample is one water, air or surface test (SRS-IPC-009).
//
// LocationID is required, not optional. The requirement's acceptance is that
// results link to a location, and a positive legionella result that names only
// "the hospital" tells the estates team nothing they can act on.
type EnvironmentalSample struct {
	ID       string
	TenantID string

	Reference  string
	Kind       SampleKind
	FacilityID string
	LocationID string
	// SamplePoint is the tap, the duct, the bench — the thing that gets
	// flushed or cleaned. A ward has forty of them and they do not fail
	// together.
	SamplePoint string

	// PlanID is the sampling plan this came from, where it was scheduled.
	// Empty for an ad-hoc sample taken because somebody was worried.
	PlanID string
	// OutbreakID links a sample taken as part of an investigation.
	OutbreakID string

	CollectedAt time.Time
	CollectedBy string
	Method      string

	State SampleState

	LabReference string
	// Value is in the limit's unit, as an integer.
	Value      int64
	Unit       string
	Organism   string
	Detected   bool
	ResultedAt time.Time
	ResultedBy string

	// Outcome is derived from the limit, never supplied.
	Outcome Outcome
	// LimitCode and LimitRevision pin the version the result was judged by,
	// so a past pass stays explicable after the limit changes.
	LimitCode     string
	LimitRevision int

	// RepeatOfID is the sample this one was taken to re-check.
	RepeatOfID string

	ClosedAt time.Time
	ClosedBy string
	Version  int64
}

// NewSampleInput records a collection.
type NewSampleInput struct {
	Reference   string
	Kind        SampleKind
	FacilityID  string
	LocationID  string
	SamplePoint string
	PlanID      string
	OutbreakID  string
	RepeatOfID  string
	CollectedAt time.Time
	Method      string
}

// CollectSample records an environmental sample (SRS-IPC-009).
func CollectSample(id, tenantID string, in NewSampleInput, by string,
	now time.Time) (EnvironmentalSample, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return EnvironmentalSample{}, fmt.Errorf("%w: a sample needs an id",
			ErrInvalidInfection)
	case !knownSampleKind[in.Kind]:
		return EnvironmentalSample{}, fmt.Errorf("%w: unknown sample kind %q",
			ErrInvalidInfection, in.Kind)
	case strings.TrimSpace(in.LocationID) == "":
		return EnvironmentalSample{}, fmt.Errorf(
			"%w: a sample names the location it came from",
			ErrInvalidInfection)
	case strings.TrimSpace(in.SamplePoint) == "":
		// A ward's forty taps do not fail together, and a result that names
		// only the ward cannot be acted on.
		return EnvironmentalSample{}, fmt.Errorf(
			"%w: a sample names the point it was taken from",
			ErrInvalidInfection)
	case in.CollectedAt.IsZero():
		return EnvironmentalSample{}, fmt.Errorf(
			"%w: a sample needs its collection time", ErrInvalidInfection)
	case in.CollectedAt.After(now):
		return EnvironmentalSample{}, fmt.Errorf(
			"%w: that sample was collected in the future", ErrInvalidInfection)
	}

	return EnvironmentalSample{
		ID: id, TenantID: tenantID,
		Reference: strings.TrimSpace(in.Reference), Kind: in.Kind,
		FacilityID: in.FacilityID, LocationID: in.LocationID,
		SamplePoint: strings.TrimSpace(in.SamplePoint),
		PlanID:      in.PlanID, OutbreakID: in.OutbreakID,
		RepeatOfID:  in.RepeatOfID,
		CollectedAt: in.CollectedAt.UTC(), CollectedBy: by,
		Method: strings.TrimSpace(in.Method),
		State:  SampleCollected, Version: 1,
	}, nil
}

// ResultInput is what the laboratory reported.
type ResultInput struct {
	LabReference string
	Value        int64
	Unit         string
	Organism     string
	Detected     bool
	ResultedAt   time.Time
}

// RecordResult files a laboratory result and derives its outcome
// (SRS-IPC-009).
//
// The outcome is computed here from the limit in force when the result was
// reported. Nobody types it, and a sample with no live limit is recorded as
// unassessable rather than quietly passing.
func (s *EnvironmentalSample) RecordResult(in ResultInput,
	limits []EnvironmentalLimit, by string, now time.Time) error {

	switch {
	case s.State != SampleCollected:
		return fmt.Errorf("%w: this sample is already %s",
			ErrInvalidInfection, s.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a result names who filed it",
			ErrInvalidInfection)
	case in.ResultedAt.IsZero():
		return fmt.Errorf("%w: a result needs its time", ErrInvalidInfection)
	case in.ResultedAt.Before(s.CollectedAt):
		return fmt.Errorf("%w: that result predates its sample",
			ErrInvalidInfection)
	}

	s.LabReference = strings.TrimSpace(in.LabReference)
	s.Value, s.Unit = in.Value, strings.TrimSpace(in.Unit)
	s.Organism, s.Detected = strings.TrimSpace(in.Organism), in.Detected
	s.ResultedAt, s.ResultedBy = in.ResultedAt.UTC(), by
	s.State = SampleResulted

	limit, ok := LimitFor(limits, s.Kind, s.ResultedAt)
	if !ok {
		s.Outcome = OutcomeUnassessable
		return nil
	}
	if s.Unit != "" && !strings.EqualFold(s.Unit, limit.Unit) {
		// Comparing cfu/ml against a cfu/100ml limit is how a tenfold failure
		// becomes a pass.
		return fmt.Errorf("%w: result is in %s and the limit is in %s",
			ErrInvalidInfection, s.Unit, limit.Unit)
	}
	s.Outcome = limit.Assess(in.Value, in.Detected)
	s.LimitCode, s.LimitRevision = limit.Code, limit.Revision
	if s.Unit == "" {
		s.Unit = limit.Unit
	}
	return nil
}

// ActionState is where a corrective action stands (SRS-IPC-009).
type ActionState string

const (
	ActionOpen     ActionState = "open"
	ActionDone     ActionState = "done"
	ActionVerified ActionState = "verified"
)

// CorrectiveAction is what was done about a failing result (SRS-IPC-009).
//
// Verified by a repeat sample that passed, not by somebody saying the tap was
// flushed. A corrective action closed on its own word is how a hospital ends
// up with three years of "flushed and cleared" against the same outlet.
type CorrectiveAction struct {
	ID       string
	TenantID string

	SampleID   string
	LocationID string

	Action string
	Owner  string
	DueBy  time.Time

	State          ActionState
	DoneAt         time.Time
	DoneBy         string
	DoneNote       string
	RepeatSampleID string
	VerifiedAt     time.Time
	VerifiedBy     string
	Version        int64
}

// RaiseCorrectiveAction opens an action against a failing sample
// (SRS-IPC-009).
func RaiseCorrectiveAction(id, tenantID string, sample EnvironmentalSample,
	action, owner string, dueBy time.Time, now time.Time) (CorrectiveAction, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return CorrectiveAction{}, fmt.Errorf("%w: an action needs an id",
			ErrInvalidInfection)
	case sample.State == SampleCollected:
		return CorrectiveAction{}, fmt.Errorf(
			"%w: this sample has no result yet", ErrInvalidInfection)
	case !sample.Outcome.Failing() && sample.Outcome != OutcomeUnassessable:
		// An action against a passing sample is noise on the estates
		// worklist, and noise is what stops the real ones being read.
		return CorrectiveAction{}, fmt.Errorf(
			"%w: that sample did not fail", ErrInvalidInfection)
	case strings.TrimSpace(action) == "":
		return CorrectiveAction{}, fmt.Errorf("%w: say what will be done",
			ErrInvalidInfection)
	case strings.TrimSpace(owner) == "":
		// An action nobody owns is an action nobody does.
		return CorrectiveAction{}, fmt.Errorf("%w: an action names its owner",
			ErrInvalidInfection)
	case dueBy.IsZero():
		return CorrectiveAction{}, fmt.Errorf("%w: an action names when it is due",
			ErrInvalidInfection)
	}

	return CorrectiveAction{
		ID: id, TenantID: tenantID,
		SampleID: sample.ID, LocationID: sample.LocationID,
		Action: strings.TrimSpace(action), Owner: owner,
		DueBy: dueBy.UTC(), State: ActionOpen, Version: 1,
	}, nil
}

// MarkDone records the work having been carried out (SRS-IPC-009).
func (a *CorrectiveAction) MarkDone(note, by string, now time.Time) error {
	switch {
	case a.State != ActionOpen:
		return fmt.Errorf("%w: this action is already %s",
			ErrInvalidInfection, a.State)
	case strings.TrimSpace(note) == "":
		return fmt.Errorf("%w: say what was done", ErrInvalidInfection)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: completed work names who did it",
			ErrInvalidInfection)
	}
	a.State, a.DoneNote = ActionDone, strings.TrimSpace(note)
	a.DoneAt, a.DoneBy = now.UTC(), by
	return nil
}

// Verify closes an action against a repeat sample that passed (SRS-IPC-009).
//
// The repeat has to be of the same point, taken after the work, and to have
// passed. Every one of those is a way a hospital can otherwise close an
// action without having fixed anything: a repeat from the tap next door, a
// repeat taken before the chlorination, a repeat that failed again.
func (a *CorrectiveAction) Verify(repeat EnvironmentalSample, by string,
	now time.Time) error {

	switch {
	case a.State != ActionDone:
		return fmt.Errorf("%w: this action has not been done yet",
			ErrInvalidInfection)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a verification names who made it",
			ErrInvalidInfection)
	case repeat.State != SampleResulted && repeat.State != SampleClosed:
		return fmt.Errorf("%w: the repeat sample has no result yet",
			ErrInvalidInfection)
	case repeat.RepeatOfID != a.SampleID:
		return fmt.Errorf("%w: that sample is not a repeat of this one",
			ErrInvalidInfection)
	case !repeat.CollectedAt.After(a.DoneAt):
		return fmt.Errorf("%w: the repeat was taken before the work was done",
			ErrInvalidInfection)
	case repeat.Outcome != OutcomePass:
		return fmt.Errorf("%w: the repeat sample did not pass",
			ErrInvalidInfection)
	}

	a.State = ActionVerified
	a.RepeatSampleID = repeat.ID
	a.VerifiedAt, a.VerifiedBy = now.UTC(), by
	return nil
}

// CloseSample signs a sample off (SRS-IPC-009).
//
// A failing sample closes only through a corrective action, which is the
// requirement's acceptance criterion: results link to location and corrective
// action. Without this a hospital could file a legionella-positive result and
// close it.
func (s *EnvironmentalSample) CloseSample(actions []CorrectiveAction,
	by string, now time.Time) error {

	switch {
	case s.State != SampleResulted:
		return fmt.Errorf("%w: this sample is %s",
			ErrInvalidInfection, s.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a closure names who made it",
			ErrInvalidInfection)
	}

	if s.Outcome.Failing() || s.Outcome == OutcomeUnassessable {
		linked := 0
		for _, action := range actions {
			if action.SampleID != s.ID {
				continue
			}
			linked++
			if action.State != ActionVerified {
				return fmt.Errorf(
					"%w: the corrective action is still %s",
					ErrInvalidInfection, action.State)
			}
		}
		if linked == 0 {
			return fmt.Errorf(
				"%w: a %s result closes through a corrective action",
				ErrInvalidInfection, s.Outcome)
		}
	}

	s.State = SampleClosed
	s.ClosedAt, s.ClosedBy = now.UTC(), by
	return nil
}

// SamplingPlan is a configured schedule for a point (SRS-IPC-009).
//
// "Where used" in the requirement is the whole point: a hospital without a
// dialysis unit does not sample dialysis water, and a plan is how it says so
// rather than having the schedule assume.
type SamplingPlan struct {
	ID       string
	TenantID string

	Code        string
	Kind        SampleKind
	FacilityID  string
	LocationID  string
	SamplePoint string
	// EveryDays is the interval. A plan with no interval is a plan nobody
	// can be late for.
	EveryDays int

	Active    bool
	StartedAt time.Time
	StoppedAt time.Time
}

// NewSamplingPlan configures a schedule (SRS-IPC-009).
func NewSamplingPlan(id, tenantID, code string, kind SampleKind,
	facilityID, locationID, point string, everyDays int,
	startedAt time.Time) (SamplingPlan, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return SamplingPlan{}, fmt.Errorf("%w: a plan needs an id",
			ErrInvalidInfection)
	case !knownSampleKind[kind]:
		return SamplingPlan{}, fmt.Errorf("%w: unknown sample kind %q",
			ErrInvalidInfection, kind)
	case strings.TrimSpace(locationID) == "" || strings.TrimSpace(point) == "":
		return SamplingPlan{}, fmt.Errorf(
			"%w: a plan names the location and point it covers",
			ErrInvalidInfection)
	case everyDays <= 0:
		return SamplingPlan{}, fmt.Errorf("%w: a plan needs its interval",
			ErrInvalidInfection)
	case startedAt.IsZero():
		return SamplingPlan{}, fmt.Errorf("%w: a plan needs a start date",
			ErrInvalidInfection)
	}

	return SamplingPlan{
		ID: id, TenantID: tenantID, Code: strings.TrimSpace(code),
		Kind: kind, FacilityID: facilityID, LocationID: locationID,
		SamplePoint: strings.TrimSpace(point), EveryDays: everyDays,
		Active: true, StartedAt: startedAt.UTC(),
	}, nil
}

// DuePoint is one sampling point that is due or overdue (SRS-IPC-009).
type DuePoint struct {
	PlanID      string
	Kind        SampleKind
	LocationID  string
	SamplePoint string
	LastTakenAt time.Time
	DueAt       time.Time
	OverdueDays int
	// NeverSampled is a point with a plan and no sample at all. Reported
	// separately because it is the worst case and the one a "days overdue"
	// column shows as a blank.
	NeverSampled bool
}

// DueSampling lists the points that are due (SRS-IPC-009).
//
// Computed from the last sample actually taken, so a point nobody has sampled
// since the plan started appears immediately rather than after one interval.
func DueSampling(plans []SamplingPlan, samples []EnvironmentalSample,
	at time.Time) []DuePoint {

	last := map[string]time.Time{}
	for _, sample := range samples {
		key := sampleKey(sample.LocationID, sample.SamplePoint, sample.Kind)
		if taken, ok := last[key]; !ok || sample.CollectedAt.After(taken) {
			last[key] = sample.CollectedAt
		}
	}

	var out []DuePoint
	for _, plan := range plans {
		if !plan.Active {
			continue
		}
		if !plan.StoppedAt.IsZero() && !plan.StoppedAt.After(at) {
			continue
		}
		if plan.StartedAt.After(at) {
			continue
		}

		key := sampleKey(plan.LocationID, plan.SamplePoint, plan.Kind)
		taken, sampled := last[key]
		due := plan.StartedAt
		if sampled {
			due = taken.AddDate(0, 0, plan.EveryDays)
		}
		if due.After(at) {
			continue
		}

		point := DuePoint{
			PlanID: plan.ID, Kind: plan.Kind,
			LocationID: plan.LocationID, SamplePoint: plan.SamplePoint,
			DueAt: due, NeverSampled: !sampled,
		}
		if sampled {
			point.LastTakenAt = taken
		}
		point.OverdueDays = int(at.Sub(due).Hours() / 24)
		out = append(out, point)
	}

	sort.Slice(out, func(a, b int) bool {
		if out[a].OverdueDays != out[b].OverdueDays {
			return out[a].OverdueDays > out[b].OverdueDays
		}
		return out[a].SamplePoint < out[b].SamplePoint
	})
	return out
}

func sampleKey(locationID, point string, kind SampleKind) string {
	return strings.ToLower(locationID) + "|" +
		strings.ToLower(strings.TrimSpace(point)) + "|" + string(kind)
}

// EnvironmentSummary counts a period's environmental testing (SRS-IPC-010).
type EnvironmentSummary struct {
	Samples      int
	Passed       int
	ActionLevel  int
	Failed       int
	Unassessable int

	ActionsOpen     int
	ActionsDone     int
	ActionsVerified int

	// PassPermille is passes in parts per thousand of the samples that could
	// be judged at all.
	PassPermille int
	Unanswerable bool
}

// SummariseEnvironment counts results and their actions (SRS-IPC-010).
//
// Unassessable samples are excluded from the denominator rather than counted
// as passes: a hospital that stopped approving limits would otherwise show a
// perfect pass rate.
func SummariseEnvironment(samples []EnvironmentalSample,
	actions []CorrectiveAction) EnvironmentSummary {

	summary := EnvironmentSummary{}
	for _, sample := range samples {
		if sample.State == SampleCollected {
			continue
		}
		summary.Samples++
		switch sample.Outcome {
		case OutcomePass:
			summary.Passed++
		case OutcomeAction:
			summary.ActionLevel++
		case OutcomeFail:
			summary.Failed++
		case OutcomeUnassessable:
			summary.Unassessable++
		}
	}
	for _, action := range actions {
		switch action.State {
		case ActionOpen:
			summary.ActionsOpen++
		case ActionDone:
			summary.ActionsDone++
		case ActionVerified:
			summary.ActionsVerified++
		}
	}

	judged := summary.Passed + summary.ActionLevel + summary.Failed
	if judged == 0 {
		summary.Unanswerable = true
		return summary
	}
	summary.PassPermille = permille(int64(summary.Passed), int64(judged))
	return summary
}
