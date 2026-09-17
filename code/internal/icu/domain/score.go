package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Severity scores (SRS-ICU-009).
//
// The requirement's verification clause is "score can be reproduced from
// recorded inputs", and it rules out the usual implementation: a number
// computed at the bedside and stored on its own. A stored score is a claim
// nobody can check a year later, when the formula has been revised and the
// chart has been corrected, and a SOFA of 11 in a mortality review that nobody
// can reconstruct is evidence of nothing.
//
// So a score stores its formula, its version, and every input it used — with
// each input naming the observation it came from. Recomputing from the stored
// inputs must give the stored result, and a test asserts it.

// ScoreInput is one value a score was calculated from.
type ScoreInput struct {
	// Code is what was measured.
	Code string
	// ObservationID names the exact chart entry. Not just the value: the same
	// number recorded twice is two observations, and a review asks which one.
	ObservationID string
	Value         float64
	Unit          string
	ObservedAt    time.Time
	// Points is what this input contributed. Stored so the arithmetic can be
	// read without re-running the formula.
	Points int
}

// Score is one calculated severity score.
type Score struct {
	ID        string
	TenantID  string
	EpisodeID string

	// Name and FormulaVersion identify the calculation. Both, because scores
	// are revised: a SOFA computed under one definition and compared against
	// one computed under another is a trend that is an artefact of the
	// revision.
	Name           string
	FormulaVersion string

	Total  int
	Inputs []ScoreInput
	// Missing names the components no validated input was available for. A
	// score with a missing component is reported as incomplete rather than as
	// a lower score: SRS-ICU-009's "only from explicit validated inputs" cuts
	// both ways, and treating an absent platelet count as normal is how a
	// coagulopathy scores zero.
	Missing []string

	CalculatedAt time.Time
	CalculatedBy string
}

// Complete reports a score every component had an input for.
func (s Score) Complete() bool { return len(s.Missing) == 0 }

// Component is one part of a scoring formula.
type Component struct {
	// Name is the component — "respiration", "coagulation". What appears in
	// Missing when no input is available.
	Name string
	// Code is the observation code it reads.
	Code string
	// Points maps a value to a score. Evaluated in order, first match wins, so
	// a table is written from worst to best exactly as it is published.
	Points []Band
}

// Band is one row of a component's scoring table.
type Band struct {
	// AtMost and AtLeast bound the band. A zero AtMost means unbounded above,
	// a zero AtLeast unbounded below — expressed through Has* flags so a
	// genuine zero boundary is not mistaken for an absent one.
	AtMost     float64
	HasAtMost  bool
	AtLeast    float64
	HasAtLeast bool
	Points     int
}

// Matches reports whether a value falls in the band.
func (b Band) Matches(value float64) bool {
	if b.HasAtMost && value > b.AtMost {
		return false
	}
	if b.HasAtLeast && value < b.AtLeast {
		return false
	}
	return true
}

// Formula is a named, versioned scoring definition.
//
// Data rather than code, so a deployment revising its definition does not
// require a release, and so a score calculated under an old version can be
// recomputed under it.
type Formula struct {
	Name       string
	Version    string
	Components []Component
}

// Validate refuses a formula that could not score anything.
func (f Formula) Validate() error {
	switch {
	case strings.TrimSpace(f.Name) == "":
		return fmt.Errorf("%w: a formula has a name", ErrInvalidEpisode)
	case strings.TrimSpace(f.Version) == "":
		// A formula with no version cannot be told from its revision, which
		// defeats the point of storing one.
		return fmt.Errorf("%w: a formula has a version", ErrInvalidEpisode)
	case len(f.Components) == 0:
		return fmt.Errorf("%w: a formula has components", ErrInvalidEpisode)
	}
	seen := map[string]bool{}
	for _, c := range f.Components {
		if strings.TrimSpace(c.Name) == "" || strings.TrimSpace(c.Code) == "" {
			return fmt.Errorf("%w: a component names itself and what it reads",
				ErrInvalidEpisode)
		}
		if seen[c.Name] {
			return fmt.Errorf("%w: component %q appears twice", ErrInvalidEpisode, c.Name)
		}
		seen[c.Name] = true
		if len(c.Points) == 0 {
			return fmt.Errorf("%w: component %q has no scoring table",
				ErrInvalidEpisode, c.Name)
		}
	}
	return nil
}

// Calculate scores an episode from its chart (SRS-ICU-009).
//
// Only chartable values are read — a rejected artefact and an unconfirmed
// device reading are both invisible here, which is the requirement.
func (f Formula) Calculate(id, tenantID, episodeID string, chart ObservationList,
	by string, now time.Time) (Score, error) {

	if err := f.Validate(); err != nil {
		return Score{}, err
	}
	if strings.TrimSpace(id) == "" || strings.TrimSpace(episodeID) == "" {
		return Score{}, fmt.Errorf("%w: a score belongs to an episode", ErrInvalidEpisode)
	}

	validated := chart.Chartable()
	score := Score{
		ID: id, TenantID: tenantID, EpisodeID: episodeID,
		Name: f.Name, FormulaVersion: f.Version,
		CalculatedAt: now.UTC(), CalculatedBy: strings.TrimSpace(by),
	}

	for _, component := range f.Components {
		observation, ok := validated.Latest(component.Code)
		if !ok {
			score.Missing = append(score.Missing, component.Name)
			continue
		}
		points, scored := component.score(observation.Value)
		if !scored {
			// A value outside every band is not a zero. The table did not
			// cover it, and scoring it as best-case would be inventing a
			// result the formula does not define.
			score.Missing = append(score.Missing, component.Name)
			continue
		}
		score.Total += points
		score.Inputs = append(score.Inputs, ScoreInput{
			Code: component.Code, ObservationID: observation.ID,
			Value: observation.Value, Unit: observation.Unit,
			ObservedAt: observation.ObservedAt, Points: points,
		})
	}

	sort.Strings(score.Missing)
	return score, nil
}

func (c Component) score(value float64) (int, bool) {
	for _, band := range c.Points {
		if band.Matches(value) {
			return band.Points, true
		}
	}
	return 0, false
}

// Reproduce recomputes a stored score from its stored inputs.
//
// This is the requirement, made executable. A score whose inputs no longer add
// up to its total is one somebody edited, and the disagreement is worth more
// than either number.
func (f Formula) Reproduce(score Score) (int, error) {
	if f.Name != score.Name || f.Version != score.FormulaVersion {
		return 0, fmt.Errorf(
			"%w: score was calculated under %s %s, not %s %s",
			ErrInvalidEpisode, score.Name, score.FormulaVersion, f.Name, f.Version)
	}

	byCode := make(map[string]ScoreInput, len(score.Inputs))
	for _, input := range score.Inputs {
		byCode[input.Code] = input
	}

	total := 0
	for _, component := range f.Components {
		input, ok := byCode[component.Code]
		if !ok {
			continue
		}
		points, scored := component.score(input.Value)
		if !scored {
			return 0, fmt.Errorf("%w: %s no longer scores %v under %s",
				ErrInvalidEpisode, component.Name, input.Value, f.Version)
		}
		total += points
	}
	return total, nil
}
