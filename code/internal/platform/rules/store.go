package rules

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Governance, effective dating and the decision log (ADR-007).
//
// The evaluator above is a pure function, which is what makes it testable and
// what makes determinism provable. This file is everything around it that a
// rules capability actually needs to be trusted in production:
//
//   - a rule set is drafted, reviewed and published by two different people;
//   - a published version is immutable and effective-dated, so the rules that
//     applied last quarter can still be produced;
//   - every evaluation is logged against the exact version that produced it,
//     which is the only thing that makes replay meaningful.
//
// Without these the evaluator is a library. With them it is a governed
// capability, and that distinction is the whole of ADR-007's criteria.

// Clock supplies time, injected so tests need not sleep.
type Clock interface{ Now() time.Time }

// IDGenerator mints rule-set and decision identifiers.
type IDGenerator interface{ NewID() string }

// Store persists rule sets and decisions.
type Store struct {
	tx    *pgtx.Manager
	clock Clock
	ids   IDGenerator
}

// NewStore constructs a Store.
func NewStore(tx *pgtx.Manager, clock Clock, ids IDGenerator) *Store {
	return &Store{tx: tx, clock: clock, ids: ids}
}

func (s *Store) queries(ctx context.Context) *sqlcgen.Queries {
	return sqlcgen.New(s.tx.Querier(ctx))
}

// Governance errors.
var (
	// ErrSelfPublication reports a rule set published by its own author. A
	// rule set decides who gets what care and at what price; one person must
	// not be able to both write and enact that.
	ErrSelfPublication = errors.New("rules: a rule set cannot be published by its author")
	// ErrNotPublishable reports a rule set that is not a draft, or does not
	// exist.
	ErrNotPublishable = errors.New("rules: rule set is not an unpublished draft")
	// ErrNoEffectiveVersion reports that no published version is in force.
	ErrNoEffectiveVersion = errors.New("rules: no rule set is in force")
)

// PlatformDefault is the tenant argument for a rule set that applies to every
// tenant that has not overridden it.
const PlatformDefault = ""

// Draft stores a new rule-set version for review.
//
// The table is validated here rather than only at publication. A draft that
// cannot evaluate is worth rejecting while its author is still looking at it;
// discovering it at publication means the reviewer's approval was given to
// something that never worked.
func (s *Store) Draft(ctx context.Context, tenantID string, table Table, author string) (string, error) {
	if err := table.Validate(); err != nil {
		return "", err
	}
	if author == "" {
		return "", fmt.Errorf("%w: an author is required", ErrInvalidTable)
	}

	tenant, err := optionalTenant(tenantID)
	if err != nil {
		return "", err
	}

	definition, err := json.Marshal(table)
	if err != nil {
		return "", rpcerr.Internal("RUL_ENCODE_FAILED", "could not encode rule set").WithCause(err)
	}

	id := s.ids.NewID()
	ruleSetUUID, err := uuid.Parse(id)
	if err != nil {
		return "", rpcerr.Internal("RUL_ID_INVALID", "rule_set_id must be a UUID").WithCause(err)
	}

	now := s.clock.Now()
	err = s.queries(ctx).InsertRuleSet(ctx, sqlcgen.InsertRuleSetParams{
		RuleSetID: ruleSetUUID,
		TenantID:  tenant,
		Name:      table.Name,
		Version:   int32(table.Version),
		Status:    "draft",
		// A draft is not in force. effective_from is overwritten at
		// publication, which is the moment somebody decides when it applies.
		EffectiveFrom: timestamptz(now),
		Definition:    definition,
		CreatedAt:     timestamptz(now),
		CreatedBy:     author,
	})
	if err != nil {
		return "", err
	}
	return id, nil
}

// Publish puts a drafted version in force from effectiveFrom.
//
// Refuses when the publisher is the author. The check lives in the SQL
// predicate; a zero-row result is how that refusal arrives here, which is why
// the two failure modes are distinguished by a follow-up read rather than
// assumed.
func (s *Store) Publish(ctx context.Context, ruleSetID, publisher string, effectiveFrom time.Time) error {
	if publisher == "" {
		return fmt.Errorf("%w: a publisher is required", ErrInvalidTable)
	}

	ruleSetUUID, err := uuid.Parse(ruleSetID)
	if err != nil {
		return fmt.Errorf("%w: %s", ErrNotPublishable, ruleSetID)
	}

	return s.tx.WithinTx(ctx, func(ctx context.Context) error {
		rows, err := s.queries(ctx).PublishRuleSet(ctx, sqlcgen.PublishRuleSetParams{
			EffectiveFrom: timestamptz(effectiveFrom),
			PublishedAt:   timestamptz(s.clock.Now()),
			PublishedBy:   publisher,
			RuleSetID:     ruleSetUUID,
		})
		if err != nil {
			return err
		}
		if rows == 1 {
			return nil
		}

		// Zero rows means one of: no such rule set, already published, or the
		// publisher is the author. They are different conversations with the
		// operator, so the error says which.
		row, readErr := s.queries(ctx).GetRuleSetByID(ctx, ruleSetUUID)
		if errors.Is(readErr, pgx.ErrNoRows) {
			return fmt.Errorf("%w: %s", ErrNotPublishable, ruleSetID)
		}
		if readErr != nil {
			return readErr
		}
		if row.CreatedBy == publisher {
			return fmt.Errorf("%w: %s drafted it", ErrSelfPublication, publisher)
		}
		return fmt.Errorf("%w: %s is %s", ErrNotPublishable, ruleSetID, row.Status)
	})
}

// Effective returns the version in force for a tenant at an instant.
//
// A tenant's own published version wins over the platform default. Falling back
// rather than requiring every tenant to publish their own is what makes a
// platform-wide rule change possible at all.
func (s *Store) Effective(ctx context.Context, tenantID, name string, at time.Time) (Table, error) {
	if tenantID != PlatformDefault {
		table, err := s.effectiveFor(ctx, tenantID, name, at)
		if err == nil {
			return table, nil
		}
		if !errors.Is(err, ErrNoEffectiveVersion) {
			return Table{}, err
		}
	}
	return s.effectiveFor(ctx, PlatformDefault, name, at)
}

func (s *Store) effectiveFor(ctx context.Context, tenantID, name string, at time.Time) (Table, error) {
	tenant, err := optionalTenant(tenantID)
	if err != nil {
		return Table{}, err
	}

	row, err := s.queries(ctx).GetEffectiveRuleSet(ctx, sqlcgen.GetEffectiveRuleSetParams{
		Name: name, TenantID: tenant, At: timestamptz(at),
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return Table{}, fmt.Errorf("%w: %s at %s", ErrNoEffectiveVersion, name, at.UTC().Format(time.RFC3339))
	}
	if err != nil {
		return Table{}, err
	}

	var table Table
	if err := json.Unmarshal(row.Definition, &table); err != nil {
		return Table{}, rpcerr.Internal("RUL_DECODE_FAILED", "could not decode rule set").WithCause(err)
	}
	return table, nil
}

// Evaluate resolves the rule set in force, evaluates it, and records the
// decision.
//
// The record is written in the caller's transaction when there is one, so a
// decision cannot survive a use case that rolled back — a logged decision for
// an action that never happened is worse than no log at all.
func (s *Store) Evaluate(ctx context.Context, tenantID, name string,
	input map[string]any, correlationID string, at time.Time) (string, Decision, error) {

	table, err := s.Effective(ctx, tenantID, name, at)
	if err != nil {
		return "", Decision{}, err
	}

	decision, err := table.Evaluate(input)
	if err != nil {
		return "", Decision{}, err
	}

	id, err := s.log(ctx, tenantID, decision, input, correlationID, at)
	if err != nil {
		return "", Decision{}, err
	}
	return id, decision, nil
}

func (s *Store) log(ctx context.Context, tenantID string, decision Decision,
	input map[string]any, correlationID string, at time.Time) (string, error) {

	tenantUUID, err := uuid.Parse(tenantID)
	if err != nil {
		return "", rpcerr.Internal("RUL_TENANT_INVALID", "tenant_id must be a UUID").WithCause(err)
	}

	id := s.ids.NewID()
	decisionUUID, err := uuid.Parse(id)
	if err != nil {
		return "", rpcerr.Internal("RUL_ID_INVALID", "decision_id must be a UUID").WithCause(err)
	}

	encodedInput, err := json.Marshal(input)
	if err != nil {
		return "", rpcerr.Internal("RUL_ENCODE_FAILED", "could not encode decision input").WithCause(err)
	}
	encodedOutcome, err := json.Marshal(decision.Outcome)
	if err != nil {
		return "", rpcerr.Internal("RUL_ENCODE_FAILED", "could not encode decision outcome").WithCause(err)
	}
	// The trace is stored, not just the outcome. "Rule R matched" is an
	// assertion; the trace is the evidence, and an investigator months later
	// has only what was written down.
	encodedTrace, err := json.Marshal(decision.Trace)
	if err != nil {
		return "", rpcerr.Internal("RUL_ENCODE_FAILED", "could not encode decision trace").WithCause(err)
	}

	err = s.queries(ctx).InsertDecisionLog(ctx, sqlcgen.InsertDecisionLogParams{
		DecisionID:     decisionUUID,
		TenantID:       tenantUUID,
		RuleSetName:    decision.RuleSetName,
		RuleSetVersion: int32(decision.RuleSetVersion),
		MatchedRule:    decision.MatchedRule,
		Input:          encodedInput,
		Outcome:        encodedOutcome,
		Explanation:    encodedTrace,
		CorrelationID:  correlationID,
		OccurredAt:     timestamptz(at),
	})
	if err != nil {
		return "", err
	}
	return id, nil
}

// ReplayDecision re-evaluates a recorded decision against the exact rule-set
// version that produced it.
//
// This is the audit answer to "why was this claim rejected in March". It
// deliberately loads the version by number rather than the version in force
// today: replaying against current rules would prove nothing about what
// happened then.
func (s *Store) ReplayDecision(ctx context.Context, tenantID, decisionID string) ([]ReplayDiff, error) {
	tenantUUID, err := uuid.Parse(tenantID)
	if err != nil {
		return nil, rpcerr.NotFound("RUL_DECISION_NOT_FOUND", "decision not found")
	}
	decisionUUID, err := uuid.Parse(decisionID)
	if err != nil {
		return nil, rpcerr.NotFound("RUL_DECISION_NOT_FOUND", "decision not found")
	}

	row, err := s.queries(ctx).GetDecisionLog(ctx, sqlcgen.GetDecisionLogParams{
		TenantID: tenantUUID, DecisionID: decisionUUID,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, rpcerr.NotFound("RUL_DECISION_NOT_FOUND", "decision not found")
	}
	if err != nil {
		return nil, err
	}

	table, err := s.versionFor(ctx, tenantID, row.RuleSetName, int(row.RuleSetVersion))
	if err != nil {
		return nil, err
	}

	var input map[string]any
	if err := json.Unmarshal(row.Input, &input); err != nil {
		return nil, rpcerr.Internal("RUL_DECODE_FAILED", "could not decode decision input").WithCause(err)
	}
	var outcome map[string]any
	if err := json.Unmarshal(row.Outcome, &outcome); err != nil {
		return nil, rpcerr.Internal("RUL_DECODE_FAILED", "could not decode decision outcome").WithCause(err)
	}

	return Replay(table, Decision{
		RuleSetName:    row.RuleSetName,
		RuleSetVersion: int(row.RuleSetVersion),
		MatchedRule:    row.MatchedRule,
		Outcome:        outcome,
	}, input)
}

// versionFor loads one specific version, tenant override first.
func (s *Store) versionFor(ctx context.Context, tenantID, name string, version int) (Table, error) {
	for _, scope := range []string{tenantID, PlatformDefault} {
		if scope == PlatformDefault && tenantID == PlatformDefault {
			// Already tried.
			break
		}
		tenant, err := optionalTenant(scope)
		if err != nil {
			return Table{}, err
		}
		row, err := s.queries(ctx).GetRuleSetVersion(ctx, sqlcgen.GetRuleSetVersionParams{
			Name: name, Version: int32(version), TenantID: tenant,
		})
		if errors.Is(err, pgx.ErrNoRows) {
			continue
		}
		if err != nil {
			return Table{}, err
		}
		var table Table
		if err := json.Unmarshal(row.Definition, &table); err != nil {
			return Table{}, rpcerr.Internal("RUL_DECODE_FAILED", "could not decode rule set").WithCause(err)
		}
		return table, nil
	}
	return Table{}, fmt.Errorf("%w: %s v%d", ErrNoEffectiveVersion, name, version)
}

// optionalTenant maps the platform-default sentinel to SQL NULL.
func optionalTenant(tenantID string) (pgtype.UUID, error) {
	if tenantID == PlatformDefault {
		return pgtype.UUID{}, nil
	}
	parsed, err := uuid.Parse(tenantID)
	if err != nil {
		return pgtype.UUID{}, rpcerr.Internal("RUL_TENANT_INVALID", "tenant_id must be a UUID").WithCause(err)
	}
	return pgtype.UUID{Bytes: parsed, Valid: true}, nil
}

func timestamptz(t time.Time) pgtype.Timestamptz {
	return pgtype.Timestamptz{Time: t.UTC(), Valid: true}
}
