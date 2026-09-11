package rules_test

import (
	"errors"
	"testing"

	"github.com/ppusapati/health/code/internal/platform/rules"
)

func TestSimulateReportsAssertionOutcomes(t *testing.T) {
	report, err := rules.Simulate(tariffTable(), []rules.SimulationCase{
		{Name: "large indian group", Input: map[string]any{"jurisdiction": "IN", "facility_count": 25},
			ExpectedRule: "in_enterprise", Assert: true},
		{Name: "small indian clinic", Input: map[string]any{"jurisdiction": "IN", "facility_count": 1},
			ExpectedRule: "in_standard", Assert: true},
		{Name: "german clinic", Input: map[string]any{"jurisdiction": "DE"},
			ExpectedRule: "eu_any", Assert: true},
		{Name: "unsupported", Input: map[string]any{"jurisdiction": "US"},
			ExpectedRule: "", Assert: true},
	})
	if err != nil {
		t.Fatalf("Simulate: %v", err)
	}
	if report.Asserted != 4 || report.Failed != 0 {
		t.Fatalf("asserted=%d failed=%d", report.Asserted, report.Failed)
	}
	if len(report.UncoveredRules) != 0 {
		t.Fatalf("uncovered rules: %v", report.UncoveredRules)
	}
}

// A wrong expectation must be reported, not swallowed — otherwise simulation
// is theatre.
func TestSimulateFlagsWrongExpectation(t *testing.T) {
	report, err := rules.Simulate(tariffTable(), []rules.SimulationCase{
		{Name: "mislabelled", Input: map[string]any{"jurisdiction": "IN", "facility_count": 25},
			ExpectedRule: "in_standard", Assert: true},
	})
	if err != nil {
		t.Fatalf("Simulate: %v", err)
	}
	if report.Failed != 1 || report.Results[0].Passed {
		t.Fatalf("wrong expectation passed: %+v", report.Results[0])
	}
}

// An uncovered rule is one nobody has confirmed still works; surfacing it is
// the point of running a simulation before publishing.
func TestSimulateReportsUncoveredRules(t *testing.T) {
	report, err := rules.Simulate(tariffTable(), []rules.SimulationCase{
		{Name: "only indian", Input: map[string]any{"jurisdiction": "IN", "facility_count": 1}},
	})
	if err != nil {
		t.Fatalf("Simulate: %v", err)
	}
	if len(report.UncoveredRules) != 2 {
		t.Fatalf("uncovered = %v, want in_enterprise and eu_any", report.UncoveredRules)
	}
}

func TestSimulateRejectsInvalidTable(t *testing.T) {
	table := tariffTable()
	table.Rules = nil

	if _, err := rules.Simulate(table, nil); !errors.Is(err, rules.ErrInvalidTable) {
		t.Fatalf("invalid table simulated: %v", err)
	}
}

// Simulation must not leave anything behind — it runs against production
// tables, so a side effect would be a live change.
func TestSimulateDoesNotMutateTable(t *testing.T) {
	table := tariffTable()
	before := table.Rules[0].Then["pack"]

	if _, err := rules.Simulate(table, []rules.SimulationCase{
		{Name: "x", Input: map[string]any{"jurisdiction": "IN", "facility_count": 99}},
	}); err != nil {
		t.Fatalf("Simulate: %v", err)
	}

	if table.Rules[0].Then["pack"] != before {
		t.Fatal("simulation mutated the table")
	}
}

func TestReplayConfirmsAnUnchangedDecision(t *testing.T) {
	table := tariffTable()
	input := map[string]any{"jurisdiction": "IN", "facility_count": 25}

	recorded, err := table.Evaluate(input)
	if err != nil {
		t.Fatalf("Evaluate: %v", err)
	}

	diffs, err := rules.Replay(table, recorded, input)
	if err != nil {
		t.Fatalf("Replay: %v", err)
	}
	if len(diffs) != 0 {
		t.Fatalf("replay diverged: %+v", diffs)
	}
}

// The investigator's case: a rule was edited in place instead of versioned.
// Replay must surface exactly what changed.
func TestReplayDetectsATamperedRule(t *testing.T) {
	original := tariffTable()
	input := map[string]any{"jurisdiction": "IN", "facility_count": 25}

	recorded, err := original.Evaluate(input)
	if err != nil {
		t.Fatalf("Evaluate: %v", err)
	}

	tampered := tariffTable()
	tampered.Rules[0].Then["pack"] = "quietly_changed"

	diffs, err := rules.Replay(tampered, recorded, input)
	if err != nil {
		t.Fatalf("Replay: %v", err)
	}
	if len(diffs) != 1 || diffs[0].Field != "outcome.pack" {
		t.Fatalf("diffs = %+v", diffs)
	}
	if diffs[0].Recorded != "enterprise_in" || diffs[0].Replayed != "quietly_changed" {
		t.Fatalf("diff did not name the change: %+v", diffs[0])
	}
}

// Replaying against a different version is a category error, not a diff: the
// caller has to fetch the version that actually produced the decision.
func TestReplayRefusesAVersionMismatch(t *testing.T) {
	recorded, err := tariffTable().Evaluate(map[string]any{"jurisdiction": "IN"})
	if err != nil {
		t.Fatalf("Evaluate: %v", err)
	}

	v2 := tariffTable()
	v2.Version = 2

	if _, err := rules.Replay(v2, recorded, map[string]any{"jurisdiction": "IN"}); !errors.Is(err, rules.ErrReplayMismatch) {
		t.Fatalf("version mismatch accepted: %v", err)
	}
}

func TestReplayDetectsADifferentMatchedRule(t *testing.T) {
	original := tariffTable()
	input := map[string]any{"jurisdiction": "IN", "facility_count": 25}

	recorded, _ := original.Evaluate(input)

	// Raising the threshold means the same input now falls through to the
	// standard pack.
	changed := tariffTable()
	changed.Rules[0].When[1].Value = 100

	diffs, err := rules.Replay(changed, recorded, input)
	if err != nil {
		t.Fatalf("Replay: %v", err)
	}

	var sawRuleChange bool
	for _, d := range diffs {
		if d.Field == "matched_rule" {
			sawRuleChange = true
			if d.Recorded != "in_enterprise" || d.Replayed != "in_standard" {
				t.Fatalf("unexpected diff: %+v", d)
			}
		}
	}
	if !sawRuleChange {
		t.Fatalf("replay missed the rule change: %+v", diffs)
	}
}
