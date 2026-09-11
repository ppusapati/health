package rules_test

import (
	"encoding/json"
	"errors"
	"testing"

	"github.com/ppusapati/health/code/internal/platform/rules"
)

// tariffTable is a small, realistic decision table: which onboarding pack a
// tenant gets, by jurisdiction and facility count.
func tariffTable() rules.Table {
	return rules.Table{
		Name:    "tenant_onboarding_pack",
		Version: 1,
		Rules: []rules.Rule{
			{
				ID:       "in_enterprise",
				Priority: 10,
				When: []rules.Condition{
					{Field: "jurisdiction", Operator: rules.OpEqual, Value: "IN"},
					{Field: "facility_count", Operator: rules.OpGreaterOrEqual, Value: 10},
				},
				Then: map[string]any{"pack": "enterprise_in", "review_required": true},
			},
			{
				ID:       "in_standard",
				Priority: 20,
				When: []rules.Condition{
					{Field: "jurisdiction", Operator: rules.OpEqual, Value: "IN"},
				},
				Then: map[string]any{"pack": "standard_in", "review_required": false},
			},
			{
				ID:       "eu_any",
				Priority: 30,
				When: []rules.Condition{
					{Field: "jurisdiction", Operator: rules.OpIn, Value: []any{"DE", "FR", "NL"}},
				},
				Then: map[string]any{"pack": "standard_eu", "review_required": true},
			},
		},
		Default: map[string]any{"pack": "unsupported", "review_required": true},
	}
}

func TestFirstMatchByPriorityWins(t *testing.T) {
	table := tariffTable()

	// Both in_enterprise and in_standard match; priority decides.
	decision, err := table.Evaluate(map[string]any{"jurisdiction": "IN", "facility_count": 12})
	if err != nil {
		t.Fatalf("Evaluate: %v", err)
	}
	if decision.MatchedRule != "in_enterprise" {
		t.Fatalf("MatchedRule = %q, want in_enterprise", decision.MatchedRule)
	}
	if decision.Outcome["pack"] != "enterprise_in" {
		t.Fatalf("Outcome = %v", decision.Outcome)
	}
}

// Authoring order must not affect the answer; only priority may.
func TestEvaluationIsIndependentOfAuthoringOrder(t *testing.T) {
	forward := tariffTable()

	reversed := tariffTable()
	reversed.Rules = []rules.Rule{forward.Rules[2], forward.Rules[1], forward.Rules[0]}

	input := map[string]any{"jurisdiction": "IN", "facility_count": 12}

	a, err := forward.Evaluate(input)
	if err != nil {
		t.Fatalf("forward: %v", err)
	}
	b, err := reversed.Evaluate(input)
	if err != nil {
		t.Fatalf("reversed: %v", err)
	}
	if a.MatchedRule != b.MatchedRule {
		t.Fatalf("order changed the answer: %q vs %q", a.MatchedRule, b.MatchedRule)
	}
}

// Repeated evaluation must be byte-identical. Map iteration order is the usual
// source of drift, so this runs enough times to catch it.
func TestEvaluationIsRepeatable(t *testing.T) {
	table := tariffTable()
	input := map[string]any{"jurisdiction": "DE", "facility_count": 3}

	first, err := table.Evaluate(input)
	if err != nil {
		t.Fatalf("Evaluate: %v", err)
	}
	baseline, _ := json.Marshal(first)

	for i := 0; i < 200; i++ {
		next, err := table.Evaluate(input)
		if err != nil {
			t.Fatalf("Evaluate iteration %d: %v", i, err)
		}
		current, _ := json.Marshal(next)
		if string(current) != string(baseline) {
			t.Fatalf("iteration %d diverged:\n %s\n %s", i, baseline, current)
		}
	}
}

func TestDefaultOutcomeWhenNothingMatches(t *testing.T) {
	decision, err := tariffTable().Evaluate(map[string]any{"jurisdiction": "US"})
	if err != nil {
		t.Fatalf("Evaluate: %v", err)
	}
	if decision.MatchedRule != "" {
		t.Fatalf("MatchedRule = %q, want empty", decision.MatchedRule)
	}
	if decision.Outcome["pack"] != "unsupported" {
		t.Fatalf("Outcome = %v", decision.Outcome)
	}
}

// A missing field must not be treated as a zero value: silently classifying
// incomplete input is how a rules engine produces confidently wrong answers.
func TestMissingFieldDoesNotMatchComparison(t *testing.T) {
	table := tariffTable()

	decision, err := table.Evaluate(map[string]any{"jurisdiction": "IN"})
	if err != nil {
		t.Fatalf("Evaluate: %v", err)
	}
	// facility_count is absent, so in_enterprise cannot match.
	if decision.MatchedRule != "in_standard" {
		t.Fatalf("MatchedRule = %q, want in_standard", decision.MatchedRule)
	}
}

func TestExistsOperator(t *testing.T) {
	table := rules.Table{
		Name: "presence", Version: 1,
		Rules: []rules.Rule{{
			ID: "has_abha", Priority: 1,
			When: []rules.Condition{{Field: "abha_id", Operator: rules.OpExists, Value: true}},
			Then: map[string]any{"linked": true},
		}},
		Default: map[string]any{"linked": false},
	}

	present, _ := table.Evaluate(map[string]any{"abha_id": "12-3456"})
	if present.MatchedRule != "has_abha" {
		t.Fatalf("present: MatchedRule = %q", present.MatchedRule)
	}

	absent, _ := table.Evaluate(map[string]any{})
	if absent.MatchedRule != "" {
		t.Fatalf("absent: MatchedRule = %q, want no match", absent.MatchedRule)
	}
}

// A table authored as JSON yields float64; Go callers pass int. Both must
// compare equal or the same table behaves differently by caller.
func TestNumericKindsCompareEqually(t *testing.T) {
	table := tariffTable()

	fromGo, _ := table.Evaluate(map[string]any{"jurisdiction": "IN", "facility_count": 10})
	fromJSON, _ := table.Evaluate(map[string]any{"jurisdiction": "IN", "facility_count": float64(10)})

	if fromGo.MatchedRule != fromJSON.MatchedRule {
		t.Fatalf("int gave %q but float64 gave %q", fromGo.MatchedRule, fromJSON.MatchedRule)
	}
}

// Ordering a string against a number has no defensible answer, so it must miss
// rather than coerce.
func TestTypeMismatchIsAMissNotAGuess(t *testing.T) {
	table := rules.Table{
		Name: "numeric", Version: 1,
		Rules: []rules.Rule{{
			ID: "big", Priority: 1,
			When: []rules.Condition{{Field: "count", Operator: rules.OpGreaterThan, Value: 5}},
			Then: map[string]any{"size": "big"},
		}},
		Default: map[string]any{"size": "unknown"},
	}

	decision, _ := table.Evaluate(map[string]any{"count": "many"})
	if decision.MatchedRule != "" {
		t.Fatalf("string compared against a number matched %q", decision.MatchedRule)
	}
}

func TestTraceExplainsEveryConsideredRule(t *testing.T) {
	decision, err := tariffTable().Evaluate(map[string]any{"jurisdiction": "IN", "facility_count": 2})
	if err != nil {
		t.Fatalf("Evaluate: %v", err)
	}

	// in_enterprise is considered and rejected; in_standard matches; eu_any is
	// never reached.
	if len(decision.Trace) != 2 {
		t.Fatalf("trace covered %d rules, want 2", len(decision.Trace))
	}
	if decision.Trace[0].RuleID != "in_enterprise" || decision.Trace[0].Matched {
		t.Fatalf("first trace = %+v", decision.Trace[0])
	}

	// The failing condition must show the actual value, so a reviewer can see
	// why it missed without re-running anything.
	var found bool
	for _, c := range decision.Trace[0].Conditions {
		if c.Field == "facility_count" {
			found = true
			if c.Matched {
				t.Fatal("facility_count condition should not have matched")
			}
			if actual, ok := c.Actual.(int); !ok || actual != 2 {
				t.Fatalf("trace lost the actual value: %+v", c)
			}
		}
	}
	if !found {
		t.Fatal("trace omitted the facility_count condition")
	}
}

func TestOutcomeIsCopiedNotShared(t *testing.T) {
	table := tariffTable()

	decision, _ := table.Evaluate(map[string]any{"jurisdiction": "IN", "facility_count": 1})
	decision.Outcome["pack"] = "tampered"

	again, _ := table.Evaluate(map[string]any{"jurisdiction": "IN", "facility_count": 1})
	if again.Outcome["pack"] != "standard_in" {
		t.Fatalf("mutating a decision corrupted the table: %v", again.Outcome)
	}
}

func TestValidateRejectsAmbiguousAndBrokenTables(t *testing.T) {
	base := tariffTable()

	cases := map[string]func(*rules.Table){
		"no name":                 func(tb *rules.Table) { tb.Name = "" },
		"zero version":            func(tb *rules.Table) { tb.Version = 0 },
		"no rules":                func(tb *rules.Table) { tb.Rules = nil },
		"duplicate rule id":       func(tb *rules.Table) { tb.Rules[1].ID = tb.Rules[0].ID },
		"duplicate priority":      func(tb *rules.Table) { tb.Rules[1].Priority = tb.Rules[0].Priority },
		"rule with no conditions": func(tb *rules.Table) { tb.Rules[0].When = nil },
		"rule with no outcome":    func(tb *rules.Table) { tb.Rules[0].Then = nil },
		"unknown operator": func(tb *rules.Table) {
			tb.Rules[0].When[0].Operator = rules.Operator("approximately")
		},
		"in with non-list": func(tb *rules.Table) {
			tb.Rules[2].When[0].Value = "DE"
		},
		"condition with no field": func(tb *rules.Table) { tb.Rules[0].When[0].Field = "" },
	}

	for name, mutate := range cases {
		t.Run(name, func(t *testing.T) {
			table := tariffTable()
			mutate(&table)
			if err := table.Validate(); !errors.Is(err, rules.ErrInvalidTable) {
				t.Fatalf("invalid table accepted (%v)", err)
			}
		})
	}

	if err := base.Validate(); err != nil {
		t.Fatalf("valid table rejected: %v", err)
	}
}

// An invalid table must fail at Evaluate too, not just at publication: a table
// loaded from storage has not necessarily been through Validate.
func TestEvaluateRejectsInvalidTable(t *testing.T) {
	table := tariffTable()
	table.Rules[1].Priority = table.Rules[0].Priority

	if _, err := table.Evaluate(map[string]any{"jurisdiction": "IN"}); err == nil {
		t.Fatal("ambiguous table evaluated")
	}
}
