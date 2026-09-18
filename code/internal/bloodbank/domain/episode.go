package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// EpisodeStatus is where a transfusion has got to (SRS-BLD-011).
type EpisodeStatus string

const (
	EpisodeRunning     EpisodeStatus = "running"
	EpisodeInterrupted EpisodeStatus = "interrupted"
	EpisodeCompleted   EpisodeStatus = "completed"
	// EpisodeStopped is a transfusion abandoned part-way — for a reaction, or
	// because the patient's condition changed. Distinct from completed,
	// because the volume given and the unit's fate differ.
	EpisodeStopped EpisodeStatus = "stopped"
)

// Episode is one transfusion at the bedside (SRS-BLD-011).
type Episode struct {
	ID       string
	TenantID string

	ComponentID string
	IssueID     string
	PatientID   string
	EncounterID string

	Status EpisodeStatus

	StartedAt time.Time
	StartedBy string
	EndedAt   time.Time

	// VolumeGivenML is what the patient actually received, which is not the
	// unit's volume when a transfusion was stopped part-way.
	VolumeGivenML int
	// StopReason is coded on an abandoned transfusion, because a haemovigilance
	// report counts them.
	StopReason string

	Observations []Observation
}

// Observation is a set of patient observations during a transfusion
// (SRS-BLD-011).
//
// Its own type rather than reusing the nursing chart, because the timing rules
// are the transfusion's: a set before the start, one at fifteen minutes, then
// periodically, and one at the end. The requirement's clause is that the
// episode is "longitudinally visible", which means the observations belong to
// it rather than being scattered through the chart by time.
type Observation struct {
	ID        string
	TenantID  string
	EpisodeID string

	// Timing names where in the transfusion the set was taken — "baseline",
	// "15_minutes", "hourly", "completion". Coded, because the audit that
	// matters is whether the fifteen-minute set exists.
	Timing string
	// Values are the measured ones. Temperature and pulse are what a reaction
	// shows in first, but the set is open so a deployment can add to it.
	Values map[string]float64
	Note   string

	ObservedAt time.Time
	ObservedBy string
}

// StartTransfusionInput begins a transfusion.
type StartTransfusionInput struct {
	ComponentID string
	IssueID     string
	PatientID   string
	EncounterID string
	Baseline    map[string]float64
}

// StartTransfusion begins a transfusion at the bedside (SRS-BLD-010,
// SRS-BLD-011).
//
// The bedside refusals are passed in rather than recomputed here, so that the
// one place which decides identity is VerifyBedside. Any refusal blocks the
// start: the requirement's clause is "mismatch blocks digital completion", and
// a system that recorded the start anyway would have a transfusion running
// against a check that failed.
func StartTransfusion(id, tenantID string, in StartTransfusionInput,
	refusals []BedsideRefusal, by string, now time.Time) (Episode, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Episode{}, fmt.Errorf("%w: a transfusion needs an id", ErrInvalidUnit)
	case strings.TrimSpace(in.ComponentID) == "" ||
		strings.TrimSpace(in.PatientID) == "":
		return Episode{}, fmt.Errorf("%w: a transfusion names a unit and a patient",
			ErrInvalidUnit)
	case strings.TrimSpace(by) == "":
		return Episode{}, fmt.Errorf("%w: a transfusion names who started it",
			ErrInvalidUnit)
	case len(refusals) > 0:
		explanations := make([]string, 0, len(refusals))
		for _, refusal := range refusals {
			explanations = append(explanations, refusal.Explain())
		}
		return Episode{}, fmt.Errorf("%w: %s", ErrInvalidUnit,
			strings.Join(explanations, " "))
	}

	episode := Episode{
		ID: id, TenantID: tenantID,
		ComponentID: strings.TrimSpace(in.ComponentID),
		IssueID:     strings.TrimSpace(in.IssueID),
		PatientID:   strings.TrimSpace(in.PatientID),
		EncounterID: strings.TrimSpace(in.EncounterID),
		Status:      EpisodeRunning,
		StartedAt:   now.UTC(), StartedBy: strings.TrimSpace(by),
	}
	if len(in.Baseline) > 0 {
		episode.Observations = append(episode.Observations, Observation{
			TenantID: tenantID, EpisodeID: id,
			Timing: TimingBaseline, Values: copyValues(in.Baseline),
			ObservedAt: now.UTC(), ObservedBy: strings.TrimSpace(by),
		})
	}
	return episode, nil
}

// The timings a transfusion protocol asks for.
const (
	TimingBaseline   = "baseline"
	TimingFifteen    = "15_minutes"
	TimingPeriodic   = "periodic"
	TimingCompletion = "completion"
)

func copyValues(in map[string]float64) map[string]float64 {
	out := make(map[string]float64, len(in))
	for key, value := range in {
		out[key] = value
	}
	return out
}

// Observe records a set of observations during a transfusion (SRS-BLD-011).
func (e *Episode) Observe(id, timing string, values map[string]float64,
	note, by string, now time.Time) (Observation, error) {

	switch {
	case e.Status == EpisodeCompleted || e.Status == EpisodeStopped:
		return Observation{}, fmt.Errorf("%w: this transfusion has ended",
			ErrInvalidUnit)
	case strings.TrimSpace(id) == "":
		return Observation{}, fmt.Errorf("%w: an observation needs an id",
			ErrInvalidUnit)
	case strings.TrimSpace(timing) == "":
		return Observation{}, fmt.Errorf(
			"%w: an observation says where in the transfusion it was taken",
			ErrInvalidUnit)
	case strings.TrimSpace(by) == "":
		return Observation{}, fmt.Errorf("%w: an observation names who took it",
			ErrInvalidUnit)
	case len(values) == 0:
		return Observation{}, fmt.Errorf("%w: an observation records something",
			ErrInvalidUnit)
	}

	observation := Observation{
		ID: id, TenantID: e.TenantID, EpisodeID: e.ID,
		Timing: strings.TrimSpace(timing), Values: copyValues(values),
		Note:       strings.TrimSpace(note),
		ObservedAt: now.UTC(), ObservedBy: strings.TrimSpace(by),
	}
	e.Observations = append(e.Observations, observation)
	return observation, nil
}

// Interrupt pauses a running transfusion (SRS-BLD-011).
func (e *Episode) Interrupt(reason string, now time.Time) error {
	if e.Status != EpisodeRunning {
		return fmt.Errorf("%w: this transfusion is %s", ErrInvalidUnit, e.Status)
	}
	if strings.TrimSpace(reason) == "" {
		return fmt.Errorf("%w: an interruption records why", ErrInvalidUnit)
	}
	e.Status, e.StopReason = EpisodeInterrupted, strings.TrimSpace(reason)
	return nil
}

// Resume restarts an interrupted transfusion.
func (e *Episode) Resume() error {
	if e.Status != EpisodeInterrupted {
		return fmt.Errorf("%w: this transfusion is %s", ErrInvalidUnit, e.Status)
	}
	e.Status, e.StopReason = EpisodeRunning, ""
	return nil
}

// Complete ends a transfusion that ran to its end (SRS-BLD-011).
func (e *Episode) Complete(volumeML int, at time.Time) error {
	switch {
	case e.Status == EpisodeCompleted || e.Status == EpisodeStopped:
		return fmt.Errorf("%w: this transfusion has already ended", ErrInvalidUnit)
	case at.Before(e.StartedAt):
		return fmt.Errorf("%w: a transfusion ends after it starts", ErrInvalidUnit)
	}
	e.Status, e.VolumeGivenML, e.EndedAt = EpisodeCompleted, volumeML, at.UTC()
	return nil
}

// Stop abandons a transfusion part-way (SRS-BLD-011, SRS-BLD-012).
func (e *Episode) Stop(reason string, volumeML int, at time.Time) error {
	switch {
	case e.Status == EpisodeCompleted || e.Status == EpisodeStopped:
		return fmt.Errorf("%w: this transfusion has already ended", ErrInvalidUnit)
	case strings.TrimSpace(reason) == "":
		// Coded, because a haemovigilance report counts abandoned
		// transfusions and needs to distinguish a reaction from a cannula that
		// tissued.
		return fmt.Errorf("%w: stopping a transfusion records why", ErrInvalidUnit)
	case at.Before(e.StartedAt):
		return fmt.Errorf("%w: a transfusion ends after it starts", ErrInvalidUnit)
	}
	e.Status, e.StopReason = EpisodeStopped, strings.TrimSpace(reason)
	e.VolumeGivenML, e.EndedAt = volumeML, at.UTC()
	return nil
}

// MissingObservations names the protocol sets a transfusion has not had.
//
// A projection rather than a refusal: a nurse who has not yet taken the
// fifteen-minute set is a nurse who is fifteen minutes in, and blocking on it
// would be wrong. What the ward needs is to be told.
func (e Episode) MissingObservations(required []string) []string {
	taken := map[string]bool{}
	for _, observation := range e.Observations {
		taken[observation.Timing] = true
	}
	var out []string
	for _, timing := range required {
		if !taken[timing] {
			out = append(out, timing)
		}
	}
	sort.Strings(out)
	return out
}

// ReactionSeverity grades a suspected transfusion reaction (SRS-BLD-012).
type ReactionSeverity string

const (
	ReactionMild     ReactionSeverity = "mild"
	ReactionModerate ReactionSeverity = "moderate"
	ReactionSevere   ReactionSeverity = "severe"
	// ReactionFatal exists because a haemovigilance scheme counts it
	// separately and a system with no code for it records a death as severe.
	ReactionFatal ReactionSeverity = "fatal"
)

var knownSeverities = map[ReactionSeverity]bool{
	ReactionMild: true, ReactionModerate: true,
	ReactionSevere: true, ReactionFatal: true,
}

// InvestigationState is where a reaction investigation has got to.
type InvestigationState string

const (
	InvestigationOpen      InvestigationState = "open"
	InvestigationConcluded InvestigationState = "concluded"
)

// Reaction is a suspected transfusion reaction (SRS-BLD-012).
//
// It links the patient, the component and the investigation, which is the
// requirement's own clause: a reaction recorded against a patient alone cannot
// find the other components made from the same donation, and finding them is
// the point.
type Reaction struct {
	ID       string
	TenantID string

	EpisodeID   string
	ComponentID string
	PatientID   string

	Severity ReactionSeverity
	// Features are what was seen — fever, rigors, hypotension, rash. Listed
	// rather than classified, because the classification is the
	// investigation's conclusion and this is the report that starts it.
	Features []string
	Note     string

	ReportedAt time.Time
	ReportedBy string

	State InvestigationState
	// Classification is the investigation's verdict, set at conclusion.
	Classification string
	Conclusion     string
	ConcludedAt    time.Time
	ConcludedBy    string
	// UnitReturned marks the implicated unit sent back for investigation,
	// which is what stops it being reissued.
	UnitReturned bool
}

// NewReactionInput reports a suspected reaction.
type NewReactionInput struct {
	EpisodeID   string
	ComponentID string
	PatientID   string
	Severity    ReactionSeverity
	Features    []string
	Note        string
}

// ReportReaction records a suspected transfusion reaction (SRS-BLD-012).
func ReportReaction(id, tenantID string, in NewReactionInput, by string,
	now time.Time) (Reaction, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Reaction{}, fmt.Errorf("%w: a reaction needs an id", ErrInvalidUnit)
	case strings.TrimSpace(in.PatientID) == "":
		return Reaction{}, fmt.Errorf("%w: a reaction names a patient", ErrInvalidUnit)
	case strings.TrimSpace(in.ComponentID) == "":
		// Without the component, the investigation cannot reach the other
		// components made from the same donation, and finding them is the
		// point of reporting.
		return Reaction{}, fmt.Errorf(
			"%w: a reaction names the component that was being given",
			ErrInvalidUnit)
	case !knownSeverities[in.Severity]:
		return Reaction{}, fmt.Errorf("%w: unknown severity %q",
			ErrInvalidUnit, in.Severity)
	case len(normalised(in.Features)) == 0:
		return Reaction{}, fmt.Errorf("%w: a reaction records what was seen",
			ErrInvalidUnit)
	case strings.TrimSpace(by) == "":
		return Reaction{}, fmt.Errorf("%w: a reaction names who reported it",
			ErrInvalidUnit)
	}

	return Reaction{
		ID: id, TenantID: tenantID,
		EpisodeID:   strings.TrimSpace(in.EpisodeID),
		ComponentID: strings.TrimSpace(in.ComponentID),
		PatientID:   strings.TrimSpace(in.PatientID),
		Severity:    in.Severity,
		Features:    normalised(in.Features),
		Note:        strings.TrimSpace(in.Note),
		ReportedAt:  now.UTC(), ReportedBy: strings.TrimSpace(by),
		State: InvestigationOpen,
	}, nil
}

// Conclude closes a reaction investigation (SRS-BLD-012).
func (r *Reaction) Conclude(classification, conclusion, by string,
	now time.Time) error {

	switch {
	case r.State == InvestigationConcluded:
		return fmt.Errorf("%w: this investigation is already concluded",
			ErrInvalidUnit)
	case strings.TrimSpace(classification) == "":
		return fmt.Errorf(
			"%w: an investigation concludes with a classification", ErrInvalidUnit)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a conclusion names who made it", ErrInvalidUnit)
	}
	r.State = InvestigationConcluded
	r.Classification = strings.TrimSpace(classification)
	r.Conclusion = strings.TrimSpace(conclusion)
	r.ConcludedAt, r.ConcludedBy = now.UTC(), strings.TrimSpace(by)
	return nil
}
