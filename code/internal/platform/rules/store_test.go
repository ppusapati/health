package rules_test

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rules"
)

// Governance, effective dating and replay (ADR-007), against a real database.
//
// The evaluator's determinism is proven by the pure tests next door. What
// cannot be proven without PostgreSQL is the part that makes it trustworthy:
// that a rule set cannot be enacted by its own author, that a published
// version is immutable, and that a decision from March can still be reproduced.

type storeClock struct{ now time.Time }

func (c *storeClock) Now() time.Time { return c.now }

type uuidGen struct{}

func (uuidGen) NewID() string { return uuid.NewString() }

type storeFixture struct {
	store  *rules.Store
	pool   *pgxpool.Pool
	clock  *storeClock
	tenant string
	other  string
}

func newStoreFixture(t *testing.T) storeFixture {
	t.Helper()
	pool := pgtest.New(t)
	clock := &storeClock{now: time.Date(2026, 3, 1, 9, 0, 0, 0, time.UTC)}
	return storeFixture{
		store:  rules.NewStore(pgtx.NewManager(pool), clock, uuidGen{}),
		pool:   pool,
		clock:  clock,
		tenant: uuid.NewString(),
		other:  uuid.NewString(),
	}
}

// triageTable is a small, realistic decision table: the copay a visit attracts.
func triageTable(version int, standardCopay float64) rules.Table {
	return rules.Table{
		Name: "visit_copay", Version: version,
		Rules: []rules.Rule{
			{
				ID: "emergency_waived", Priority: 10,
				When: []rules.Condition{{Field: "acuity", Operator: rules.OpEqual, Value: "emergency"}},
				Then: map[string]any{"copay": 0.0, "reason": "emergency"},
			},
			{
				ID: "standard", Priority: 20,
				When: []rules.Condition{{Field: "acuity", Operator: rules.OpExists}},
				Then: map[string]any{"copay": standardCopay, "reason": "standard"},
			},
		},
		Default: map[string]any{"copay": standardCopay, "reason": "default"},
	}
}

func (f storeFixture) draftAndPublish(t *testing.T, tenant string, table rules.Table, from time.Time) string {
	t.Helper()
	ctx := context.Background()

	id, err := f.store.Draft(ctx, tenant, table, "author@hospital")
	if err != nil {
		t.Fatalf("Draft: %v", err)
	}
	if err := f.store.Publish(ctx, id, "reviewer@hospital", from); err != nil {
		t.Fatalf("Publish: %v", err)
	}
	return id
}

// Four eyes. A rule set decides who gets what care and at what price; the
// person who wrote it must not be the person who enacts it.
func TestAnAuthorCannotPublishTheirOwnRuleSet(t *testing.T) {
	f := newStoreFixture(t)
	ctx := context.Background()

	id, err := f.store.Draft(ctx, f.tenant, triageTable(1, 25), "author@hospital")
	if err != nil {
		t.Fatalf("Draft: %v", err)
	}

	err = f.store.Publish(ctx, id, "author@hospital", f.clock.now)
	if !errors.Is(err, rules.ErrSelfPublication) {
		t.Fatalf("Publish = %v, want ErrSelfPublication", err)
	}

	// And it really is still a draft: nothing is in force.
	if _, err := f.store.Effective(ctx, f.tenant, "visit_copay", f.clock.now); !errors.Is(err, rules.ErrNoEffectiveVersion) {
		t.Fatalf("a self-published rule set took effect: %v", err)
	}
}

func TestPublishingTwiceIsRefused(t *testing.T) {
	f := newStoreFixture(t)
	ctx := context.Background()

	id := f.draftAndPublish(t, f.tenant, triageTable(1, 25), f.clock.now)

	err := f.store.Publish(ctx, id, "another@hospital", f.clock.now)
	if !errors.Is(err, rules.ErrNotPublishable) {
		t.Fatalf("Publish = %v, want ErrNotPublishable", err)
	}
}

// A draft that cannot evaluate is rejected while its author is looking at it,
// not after a reviewer has approved something that never worked.
func TestAnInvalidTableIsRefusedAtDraft(t *testing.T) {
	f := newStoreFixture(t)

	broken := triageTable(1, 25)
	broken.Rules[1].Priority = broken.Rules[0].Priority // ambiguous precedence

	if _, err := f.store.Draft(context.Background(), f.tenant, broken, "author@hospital"); !errors.Is(err, rules.ErrInvalidTable) {
		t.Fatalf("Draft = %v, want ErrInvalidTable", err)
	}
}

// Effective dating: the version in force depends on when you ask.
func TestTheVersionInForceDependsOnTheInstant(t *testing.T) {
	f := newStoreFixture(t)
	ctx := context.Background()

	march := time.Date(2026, 3, 1, 0, 0, 0, 0, time.UTC)
	july := time.Date(2026, 7, 1, 0, 0, 0, 0, time.UTC)

	f.draftAndPublish(t, f.tenant, triageTable(1, 25), march)
	f.draftAndPublish(t, f.tenant, triageTable(2, 40), july)

	inMarch, err := f.store.Effective(ctx, f.tenant, "visit_copay", march.Add(24*time.Hour))
	if err != nil {
		t.Fatalf("Effective(March): %v", err)
	}
	if inMarch.Version != 1 {
		t.Fatalf("March resolved to v%d, want 1", inMarch.Version)
	}

	inAugust, err := f.store.Effective(ctx, f.tenant, "visit_copay",
		time.Date(2026, 8, 1, 0, 0, 0, 0, time.UTC))
	if err != nil {
		t.Fatalf("Effective(August): %v", err)
	}
	if inAugust.Version != 2 {
		t.Fatalf("August resolved to v%d, want 2", inAugust.Version)
	}

	// Before anything was published, nothing is in force — not "the earliest
	// version", which would silently apply rules that did not exist yet.
	if _, err := f.store.Effective(ctx, f.tenant, "visit_copay",
		time.Date(2026, 1, 1, 0, 0, 0, 0, time.UTC)); !errors.Is(err, rules.ErrNoEffectiveVersion) {
		t.Fatalf("a pre-dated evaluation resolved a version: %v", err)
	}
}

// A tenant's own published version beats the platform default, and a tenant
// without one still gets the default. Requiring every tenant to publish their
// own copy would make a platform-wide change impossible.
func TestATenantVersionOverridesThePlatformDefault(t *testing.T) {
	f := newStoreFixture(t)
	ctx := context.Background()

	f.draftAndPublish(t, rules.PlatformDefault, triageTable(1, 25), f.clock.now)
	f.draftAndPublish(t, f.tenant, triageTable(1, 75), f.clock.now)

	overridden, err := f.store.Effective(ctx, f.tenant, "visit_copay", f.clock.now)
	if err != nil {
		t.Fatalf("Effective(tenant): %v", err)
	}
	if got := overridden.Rules[1].Then["copay"]; got != 75.0 {
		t.Fatalf("the tenant got copay %v, want its own 75", got)
	}

	inherited, err := f.store.Effective(ctx, f.other, "visit_copay", f.clock.now)
	if err != nil {
		t.Fatalf("Effective(other tenant): %v", err)
	}
	if got := inherited.Rules[1].Then["copay"]; got != 25.0 {
		t.Fatalf("a tenant with no override got copay %v, want the default 25", got)
	}
}

// Every evaluation is recorded against the version that produced it, with the
// trace. "Rule R matched" is an assertion; the trace is the evidence.
func TestEvaluationIsLoggedAndReplayable(t *testing.T) {
	f := newStoreFixture(t)
	ctx := context.Background()

	f.draftAndPublish(t, f.tenant, triageTable(1, 25), f.clock.now)

	decisionID, decision, err := f.store.Evaluate(ctx, f.tenant, "visit_copay",
		map[string]any{"acuity": "routine"}, "corr-1", f.clock.now)
	if err != nil {
		t.Fatalf("Evaluate: %v", err)
	}
	if decision.MatchedRule != "standard" {
		t.Fatalf("matched %q, want standard", decision.MatchedRule)
	}
	if decision.Outcome["copay"] != 25.0 {
		t.Fatalf("copay = %v, want 25", decision.Outcome["copay"])
	}

	diffs, err := f.store.ReplayDecision(ctx, f.tenant, decisionID)
	if err != nil {
		t.Fatalf("ReplayDecision: %v", err)
	}
	if len(diffs) != 0 {
		t.Fatalf("replaying an unchanged decision reported differences: %+v", diffs)
	}
}

// The point of replaying against the recorded version rather than the current
// one: a decision made in March must still explain itself after July's rules
// took over.
func TestReplayUsesTheVersionThatMadeTheDecisionNotTheCurrentOne(t *testing.T) {
	f := newStoreFixture(t)
	ctx := context.Background()

	march := time.Date(2026, 3, 1, 0, 0, 0, 0, time.UTC)
	july := time.Date(2026, 7, 1, 0, 0, 0, 0, time.UTC)

	f.draftAndPublish(t, f.tenant, triageTable(1, 25), march)

	decisionID, decision, err := f.store.Evaluate(ctx, f.tenant, "visit_copay",
		map[string]any{"acuity": "routine"}, "corr-1", march.Add(24*time.Hour))
	if err != nil {
		t.Fatalf("Evaluate: %v", err)
	}
	if decision.RuleSetVersion != 1 {
		t.Fatalf("evaluated against v%d", decision.RuleSetVersion)
	}

	// The price goes up in July.
	f.draftAndPublish(t, f.tenant, triageTable(2, 40), july)
	f.clock.now = time.Date(2026, 9, 1, 0, 0, 0, 0, time.UTC)

	current, err := f.store.Effective(ctx, f.tenant, "visit_copay", f.clock.now)
	if err != nil {
		t.Fatalf("Effective: %v", err)
	}
	if current.Version != 2 {
		t.Fatalf("current version is %d, want 2", current.Version)
	}

	// March's decision still replays clean against March's rules.
	diffs, err := f.store.ReplayDecision(ctx, f.tenant, decisionID)
	if err != nil {
		t.Fatalf("ReplayDecision: %v", err)
	}
	if len(diffs) != 0 {
		t.Fatalf("a historical decision no longer reproduces: %+v", diffs)
	}
}

// A published version is never edited, so a rule set that was tampered with in
// place is what replay is meant to detect. The pure Replay tests cover the
// comparison; this covers it end to end through the log.
func TestReplayDetectsARuleSetEditedInPlace(t *testing.T) {
	f := newStoreFixture(t)
	ctx := context.Background()

	f.draftAndPublish(t, f.tenant, triageTable(1, 25), f.clock.now)

	decisionID, _, err := f.store.Evaluate(ctx, f.tenant, "visit_copay",
		map[string]any{"acuity": "routine"}, "corr-1", f.clock.now)
	if err != nil {
		t.Fatalf("Evaluate: %v", err)
	}

	// Somebody rewrites v1's body in the database — the thing the immutability
	// rule forbids and that no application path allows.
	tampered := triageTable(1, 999)
	encoded, err := jsonMarshal(tampered)
	if err != nil {
		t.Fatalf("marshal: %v", err)
	}
	if _, err := f.exec(ctx, `UPDATE platform_rules.rule_set SET definition = $1
	                          WHERE name = 'visit_copay' AND version = 1`, encoded); err != nil {
		t.Fatalf("tamper: %v", err)
	}

	diffs, err := f.store.ReplayDecision(ctx, f.tenant, decisionID)
	if err != nil {
		t.Fatalf("ReplayDecision: %v", err)
	}
	if len(diffs) == 0 {
		t.Fatal("replay did not notice that the rule set had been rewritten")
	}
}

// One tenant must not be able to replay another's decision.
func TestReplayIsTenantScoped(t *testing.T) {
	f := newStoreFixture(t)
	ctx := context.Background()

	f.draftAndPublish(t, f.tenant, triageTable(1, 25), f.clock.now)
	decisionID, _, err := f.store.Evaluate(ctx, f.tenant, "visit_copay",
		map[string]any{"acuity": "routine"}, "corr-1", f.clock.now)
	if err != nil {
		t.Fatalf("Evaluate: %v", err)
	}

	if _, err := f.store.ReplayDecision(ctx, f.other, decisionID); err == nil {
		t.Fatal("another tenant replayed this decision")
	}
}
