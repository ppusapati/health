// Package rules is the Wave-0 deterministic rules evaluator.
//
// SCOPE: this is the proof of concept ADR-007 asks for — a decision-table
// reference implementation demonstrating determinism, versioning, simulation,
// explainability and replay. It does not claim the Wave-7 requirement families
// SRS-RUL-DEF or SRS-RUL-RUN.
//
// The design constraint that matters is determinism. A rule evaluation that
// can produce different answers for the same input and version makes every
// past decision unexplainable, so:
//
//   - rules are evaluated in a total order (priority, then ID), never in map
//     order;
//   - the first matching rule wins, and the match is recorded;
//   - a published table is immutable — a change is a new version;
//   - comparisons are typed, and a type mismatch is a miss rather than a
//     coerced guess.
package rules

import (
	"encoding/json"
	"errors"
	"fmt"
	"sort"
	"strings"
)

// Operator is a comparison in a rule condition.
type Operator string

const (
	OpEqual           Operator = "eq"
	OpNotEqual        Operator = "ne"
	OpLessThan        Operator = "lt"
	OpLessThanOrEqual Operator = "lte"
	OpGreaterThan     Operator = "gt"
	OpGreaterOrEqual  Operator = "gte"
	OpIn              Operator = "in"
	OpExists          Operator = "exists"
)

var knownOperators = map[Operator]bool{
	OpEqual: true, OpNotEqual: true, OpLessThan: true, OpLessThanOrEqual: true,
	OpGreaterThan: true, OpGreaterOrEqual: true, OpIn: true, OpExists: true,
}

// Condition is one typed comparison against an input field.
type Condition struct {
	Field    string   `json:"field"`
	Operator Operator `json:"operator"`
	Value    any      `json:"value,omitempty"`
}

// Rule is one row of a decision table. Every condition must hold (AND); use
// separate rules for alternatives (OR).
type Rule struct {
	ID string `json:"id"`
	// Priority orders evaluation. Lower runs first; ties break on ID so the
	// order is total and stable regardless of authoring sequence.
	Priority int            `json:"priority"`
	When     []Condition    `json:"when"`
	Then     map[string]any `json:"then"`
}

// Table is a versioned decision table.
type Table struct {
	Name    string         `json:"name"`
	Version int            `json:"version"`
	Rules   []Rule         `json:"rules"`
	Default map[string]any `json:"default,omitempty"`
}

// ConditionResult records why one condition did or did not hold. This is the
// explainability surface: an operator can see the actual value that was
// compared, not just the verdict.
type ConditionResult struct {
	Field    string   `json:"field"`
	Operator Operator `json:"operator"`
	Expected any      `json:"expected,omitempty"`
	Actual   any      `json:"actual,omitempty"`
	Matched  bool     `json:"matched"`
}

// RuleTrace records the evaluation of one rule.
type RuleTrace struct {
	RuleID     string            `json:"rule_id"`
	Matched    bool              `json:"matched"`
	Conditions []ConditionResult `json:"conditions"`
}

// Decision is the result of evaluating a table.
type Decision struct {
	RuleSetName    string `json:"rule_set_name"`
	RuleSetVersion int    `json:"rule_set_version"`
	// MatchedRule is empty when the default outcome was used.
	MatchedRule string         `json:"matched_rule"`
	Outcome     map[string]any `json:"outcome"`
	// Trace covers every rule considered, in evaluation order, stopping at the
	// match. Rules after the match are not evaluated and do not appear.
	Trace []RuleTrace `json:"trace"`
}

// ErrInvalidTable reports a table that cannot be evaluated deterministically.
var ErrInvalidTable = errors.New("rules: invalid table")

// Validate rejects tables that would evaluate ambiguously or not at all.
//
// It runs before publication rather than at evaluation time: a rule set that
// reaches production and then fails to evaluate has already done the damage.
func (t Table) Validate() error {
	if strings.TrimSpace(t.Name) == "" {
		return fmt.Errorf("%w: name is required", ErrInvalidTable)
	}
	if t.Version <= 0 {
		return fmt.Errorf("%w: version must be positive", ErrInvalidTable)
	}
	if len(t.Rules) == 0 {
		return fmt.Errorf("%w: at least one rule is required", ErrInvalidTable)
	}

	seenIDs := make(map[string]bool, len(t.Rules))
	seenPriority := make(map[int]string, len(t.Rules))

	for _, rule := range t.Rules {
		if strings.TrimSpace(rule.ID) == "" {
			return fmt.Errorf("%w: every rule needs an ID", ErrInvalidTable)
		}
		if seenIDs[rule.ID] {
			return fmt.Errorf("%w: duplicate rule ID %q", ErrInvalidTable, rule.ID)
		}
		seenIDs[rule.ID] = true

		// Two rules at the same priority would be ordered by ID, which is
		// deterministic but almost certainly not what the author meant.
		// Refusing it keeps precedence explicit.
		if other, clash := seenPriority[rule.Priority]; clash {
			return fmt.Errorf("%w: rules %q and %q share priority %d",
				ErrInvalidTable, other, rule.ID, rule.Priority)
		}
		seenPriority[rule.Priority] = rule.ID

		if len(rule.When) == 0 {
			return fmt.Errorf("%w: rule %q has no conditions", ErrInvalidTable, rule.ID)
		}
		if len(rule.Then) == 0 {
			return fmt.Errorf("%w: rule %q has no outcome", ErrInvalidTable, rule.ID)
		}

		for _, condition := range rule.When {
			if strings.TrimSpace(condition.Field) == "" {
				return fmt.Errorf("%w: rule %q has a condition with no field", ErrInvalidTable, rule.ID)
			}
			if !knownOperators[condition.Operator] {
				return fmt.Errorf("%w: rule %q uses unknown operator %q",
					ErrInvalidTable, rule.ID, condition.Operator)
			}
			if condition.Operator == OpIn {
				if _, ok := condition.Value.([]any); !ok {
					return fmt.Errorf("%w: rule %q uses %q with a non-list value",
						ErrInvalidTable, rule.ID, OpIn)
				}
			}
		}
	}
	return nil
}

// orderedRules returns the rules in total evaluation order.
func (t Table) orderedRules() []Rule {
	ordered := make([]Rule, len(t.Rules))
	copy(ordered, t.Rules)
	sort.SliceStable(ordered, func(i, j int) bool {
		if ordered[i].Priority != ordered[j].Priority {
			return ordered[i].Priority < ordered[j].Priority
		}
		return ordered[i].ID < ordered[j].ID
	})
	return ordered
}

// Evaluate applies the table to one input and returns the decision with its
// full trace. It has no side effects, which is what lets simulation and replay
// use exactly the same code path as production.
func (t Table) Evaluate(input map[string]any) (Decision, error) {
	if err := t.Validate(); err != nil {
		return Decision{}, err
	}

	decision := Decision{
		RuleSetName:    t.Name,
		RuleSetVersion: t.Version,
	}

	for _, rule := range t.orderedRules() {
		trace := RuleTrace{RuleID: rule.ID, Matched: true}

		for _, condition := range rule.When {
			actual, present := input[condition.Field]
			matched := evaluateCondition(condition, actual, present)

			trace.Conditions = append(trace.Conditions, ConditionResult{
				Field:    condition.Field,
				Operator: condition.Operator,
				Expected: condition.Value,
				Actual:   actual,
				Matched:  matched,
			})
			if !matched {
				trace.Matched = false
			}
		}

		decision.Trace = append(decision.Trace, trace)

		if trace.Matched {
			decision.MatchedRule = rule.ID
			decision.Outcome = cloneOutcome(rule.Then)
			return decision, nil
		}
	}

	// No rule matched. A default is optional; without one the caller gets an
	// empty outcome and an empty MatchedRule, which is explicit rather than a
	// silent zero.
	decision.Outcome = cloneOutcome(t.Default)
	return decision, nil
}

// evaluateCondition applies one typed comparison.
func evaluateCondition(c Condition, actual any, present bool) bool {
	if c.Operator == OpExists {
		want, ok := c.Value.(bool)
		if !ok {
			want = true
		}
		return present == want
	}

	if !present {
		// A missing field matches nothing except an explicit absence check.
		// Treating it as zero would silently classify incomplete input.
		return false
	}

	switch c.Operator {
	case OpEqual:
		return valuesEqual(actual, c.Value)
	case OpNotEqual:
		return !valuesEqual(actual, c.Value)
	case OpIn:
		list, ok := c.Value.([]any)
		if !ok {
			return false
		}
		for _, candidate := range list {
			if valuesEqual(actual, candidate) {
				return true
			}
		}
		return false
	case OpLessThan, OpLessThanOrEqual, OpGreaterThan, OpGreaterOrEqual:
		left, okLeft := toFloat(actual)
		right, okRight := toFloat(c.Value)
		if !okLeft || !okRight {
			// Ordering two non-numbers has no defensible answer, so it is a
			// miss rather than a guess.
			return false
		}
		switch c.Operator {
		case OpLessThan:
			return left < right
		case OpLessThanOrEqual:
			return left <= right
		case OpGreaterThan:
			return left > right
		default:
			return left >= right
		}
	default:
		return false
	}
}

// valuesEqual compares two values, treating all numeric kinds as comparable so
// that a table authored in JSON (float64) matches input built in Go (int).
func valuesEqual(a, b any) bool {
	if af, aok := toFloat(a); aok {
		if bf, bok := toFloat(b); bok {
			return af == bf
		}
		return false
	}
	switch av := a.(type) {
	case string:
		bv, ok := b.(string)
		return ok && av == bv
	case bool:
		bv, ok := b.(bool)
		return ok && av == bv
	case nil:
		return b == nil
	default:
		return false
	}
}

// toFloat normalises the numeric kinds that reach a rule from JSON or Go.
func toFloat(v any) (float64, bool) {
	switch n := v.(type) {
	case float64:
		return n, true
	case float32:
		return float64(n), true
	case int:
		return float64(n), true
	case int32:
		return float64(n), true
	case int64:
		return float64(n), true
	case json.Number:
		f, err := n.Float64()
		return f, err == nil
	default:
		return 0, false
	}
}

// cloneOutcome copies the outcome so a caller cannot mutate the table.
func cloneOutcome(src map[string]any) map[string]any {
	if src == nil {
		return map[string]any{}
	}
	out := make(map[string]any, len(src))
	for k, v := range src {
		out[k] = v
	}
	return out
}
