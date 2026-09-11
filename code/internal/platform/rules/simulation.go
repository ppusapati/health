package rules

import (
	"errors"
	"fmt"
)

// SimulationCase is one input to try against a table.
type SimulationCase struct {
	Name  string         `json:"name"`
	Input map[string]any `json:"input"`
	// ExpectedRule, when set, asserts which rule should match. Empty means the
	// default outcome is expected.
	ExpectedRule string `json:"expected_rule,omitempty"`
	// Assert marks the case as an expectation rather than an exploration.
	Assert bool `json:"assert,omitempty"`
}

// SimulationResult pairs a case with what actually happened.
type SimulationResult struct {
	Case     SimulationCase `json:"case"`
	Decision Decision       `json:"decision"`
	// Passed is meaningful only when the case set Assert.
	Passed bool `json:"passed"`
}

// SimulationReport summarises a dry run.
type SimulationReport struct {
	RuleSetName    string             `json:"rule_set_name"`
	RuleSetVersion int                `json:"rule_set_version"`
	Results        []SimulationResult `json:"results"`
	Asserted       int                `json:"asserted"`
	Failed         int                `json:"failed"`
	// Coverage lists rule IDs that no case exercised. An uncovered rule is a
	// rule nobody has confirmed still works.
	UncoveredRules []string `json:"uncovered_rules"`
}

// Simulate runs a table against a set of cases without persisting anything.
//
// ADR-007 requires simulation before a rule set is published. Because Evaluate
// has no side effects, simulation exercises the identical code path production
// will use — a simulator that approximates the runtime is worse than none.
func Simulate(table Table, cases []SimulationCase) (SimulationReport, error) {
	if err := table.Validate(); err != nil {
		return SimulationReport{}, err
	}

	report := SimulationReport{
		RuleSetName:    table.Name,
		RuleSetVersion: table.Version,
	}

	covered := make(map[string]bool, len(table.Rules))

	for _, c := range cases {
		decision, err := table.Evaluate(c.Input)
		if err != nil {
			return SimulationReport{}, fmt.Errorf("case %q: %w", c.Name, err)
		}
		if decision.MatchedRule != "" {
			covered[decision.MatchedRule] = true
		}

		result := SimulationResult{Case: c, Decision: decision}
		if c.Assert {
			report.Asserted++
			result.Passed = decision.MatchedRule == c.ExpectedRule
			if !result.Passed {
				report.Failed++
			}
		}
		report.Results = append(report.Results, result)
	}

	for _, rule := range table.orderedRules() {
		if !covered[rule.ID] {
			report.UncoveredRules = append(report.UncoveredRules, rule.ID)
		}
	}
	return report, nil
}

// ErrReplayMismatch reports that re-evaluating a recorded decision produced a
// different answer.
var ErrReplayMismatch = errors.New("rules: replay produced a different decision")

// ReplayDiff describes how a replayed decision differs from the recorded one.
type ReplayDiff struct {
	Field    string `json:"field"`
	Recorded any    `json:"recorded"`
	Replayed any    `json:"replayed"`
}

// Replay re-evaluates a recorded decision against the table version that
// produced it and reports any divergence.
//
// This is the audit tool: given a decision made months ago, an investigator can
// prove the same inputs still yield the same outcome — or discover that
// something non-deterministic crept in.
func Replay(table Table, recorded Decision, input map[string]any) ([]ReplayDiff, error) {
	if table.Name != recorded.RuleSetName || table.Version != recorded.RuleSetVersion {
		return nil, fmt.Errorf("%w: recorded %s v%d but replayed against %s v%d",
			ErrReplayMismatch, recorded.RuleSetName, recorded.RuleSetVersion,
			table.Name, table.Version)
	}

	replayed, err := table.Evaluate(input)
	if err != nil {
		return nil, err
	}

	var diffs []ReplayDiff
	if replayed.MatchedRule != recorded.MatchedRule {
		diffs = append(diffs, ReplayDiff{
			Field:    "matched_rule",
			Recorded: recorded.MatchedRule,
			Replayed: replayed.MatchedRule,
		})
	}

	for key, recordedValue := range recorded.Outcome {
		replayedValue, present := replayed.Outcome[key]
		if !present || !valuesEqual(recordedValue, replayedValue) {
			diffs = append(diffs, ReplayDiff{
				Field:    "outcome." + key,
				Recorded: recordedValue,
				Replayed: replayedValue,
			})
		}
	}
	for key, replayedValue := range replayed.Outcome {
		if _, present := recorded.Outcome[key]; !present {
			diffs = append(diffs, ReplayDiff{
				Field:    "outcome." + key,
				Recorded: nil,
				Replayed: replayedValue,
			})
		}
	}

	return diffs, nil
}
