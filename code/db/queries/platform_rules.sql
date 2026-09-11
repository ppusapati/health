-- Rules evaluation harness queries (P0-07).

-- name: InsertRuleSet :exec
INSERT INTO platform_rules.rule_set (
    rule_set_id, tenant_id, name, version, status, effective_from, effective_to,
    definition, created_at, created_by
) VALUES (
    @rule_set_id, @tenant_id, @name, @version, @status, @effective_from, @effective_to,
    @definition, @created_at, @created_by
);

-- name: PublishRuleSet :execrows
-- Only a draft may be published, and publication stamps who did it. A
-- published set is never edited: a change is a new version.
--
-- created_by <> published_by enforces four eyes in the statement, the same way
-- the master-data approval does. A rule set decides who gets what care and at
-- what price; one person must not be able to both write and enact that.
-- Expressed here rather than in Go so a future caller cannot reach the table
-- without the check.
UPDATE platform_rules.rule_set
SET status = 'published',
    effective_from = @effective_from,
    published_at = @published_at,
    published_by = @published_by
WHERE rule_set_id = @rule_set_id
  AND status = 'draft'
  AND created_by <> @published_by;

-- name: GetRuleSetVersion :one
SELECT rule_set_id, tenant_id, name, version, status, effective_from, effective_to,
       definition, created_at, created_by, published_at, published_by
FROM platform_rules.rule_set
WHERE name = @name AND version = @version
  AND tenant_id IS NOT DISTINCT FROM sqlc.narg(tenant_id)::uuid;

-- name: GetEffectiveRuleSet :one
-- The version in force at a given instant. Effective dating is what lets a
-- decision made last quarter be explained with last quarter's rules.
SELECT rule_set_id, tenant_id, name, version, status, effective_from, effective_to,
       definition, created_at, created_by, published_at, published_by
FROM platform_rules.rule_set
WHERE name = @name
  AND status = 'published'
  AND tenant_id IS NOT DISTINCT FROM sqlc.narg(tenant_id)::uuid
  AND effective_from <= @at
  AND (effective_to IS NULL OR effective_to > @at)
ORDER BY effective_from DESC, version DESC
LIMIT 1;

-- name: InsertDecisionLog :exec
INSERT INTO platform_rules.decision_log (
    decision_id, tenant_id, rule_set_name, rule_set_version, matched_rule,
    input, outcome, explanation, correlation_id, occurred_at
) VALUES (
    @decision_id, @tenant_id, @rule_set_name, @rule_set_version, @matched_rule,
    @input, @outcome, @explanation, @correlation_id, @occurred_at
);

-- name: GetDecisionLog :one
SELECT decision_id, tenant_id, rule_set_name, rule_set_version, matched_rule,
       input, outcome, explanation, correlation_id, occurred_at
FROM platform_rules.decision_log
WHERE tenant_id = @tenant_id AND decision_id = @decision_id;

-- name: GetRuleSetByID :one
-- Used only to explain a refused publication: the predicate on PublishRuleSet
-- returns zero rows for three different reasons, and an operator needs to know
-- which one they hit.
SELECT rule_set_id, tenant_id, name, version, status, effective_from, effective_to,
       definition, created_at, created_by, published_at, published_by
FROM platform_rules.rule_set
WHERE rule_set_id = @rule_set_id;
