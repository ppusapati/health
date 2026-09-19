-- Identity and access queries (ADR-008).

-- name: GetFederationByIssuer :one
-- Issuer-based tenant resolution. The unique index on issuer is what makes
-- this unambiguous: one issuer identifies exactly one customer directory.
SELECT federation_id, tenant_id, issuer, domains, role_mappings, default_roles,
       enabled, created_at, updated_at
FROM identity_access.federation
WHERE issuer = @issuer;

-- name: InsertFederation :exec
INSERT INTO identity_access.federation (
    federation_id, tenant_id, issuer, domains, role_mappings, default_roles,
    enabled, created_at, updated_at
) VALUES (
    @federation_id, @tenant_id, @issuer, @domains, @role_mappings, @default_roles,
    @enabled, @created_at, @updated_at
);

-- name: SetFederationEnabled :execrows
UPDATE identity_access.federation
SET enabled = @enabled, updated_at = @updated_at
WHERE tenant_id = @tenant_id AND federation_id = @federation_id;

-- name: GetAccountBySubject :one
SELECT account_id, tenant_id, subject_id, identity_provider, display_name,
       status, roles, permitted_facilities, not_valid_before,
       created_at, updated_at, version
FROM identity_access.account
WHERE tenant_id = @tenant_id AND subject_id = @subject_id;

-- name: UpsertAccount :one
-- The shape of this statement is the whole revocation guarantee.
--
-- On conflict it refreshes what the provider asserts — roles, facilities,
-- display name — and deliberately does NOT touch not_valid_before or status. A
-- re-login must not clear a suspension an administrator applied, and it must
-- not move a revocation watermark backwards; both would let a user recover
-- access by simply signing in again.
INSERT INTO identity_access.account (
    account_id, tenant_id, subject_id, identity_provider, display_name,
    status, roles, permitted_facilities, not_valid_before,
    created_at, updated_at, version
) VALUES (
    @account_id, @tenant_id, @subject_id, @identity_provider, @display_name,
    @status, @roles, @permitted_facilities, @not_valid_before,
    @created_at, @updated_at, 1
)
ON CONFLICT (tenant_id, subject_id) DO UPDATE
SET roles = EXCLUDED.roles,
    permitted_facilities = EXCLUDED.permitted_facilities,
    display_name = EXCLUDED.display_name,
    identity_provider = EXCLUDED.identity_provider,
    updated_at = EXCLUDED.updated_at,
    version = identity_access.account.version + 1
RETURNING account_id, tenant_id, subject_id, identity_provider, display_name,
          status, roles, permitted_facilities, not_valid_before,
          created_at, updated_at, version;

-- name: GetRevocationWatermark :one
SELECT not_valid_before FROM identity_access.account
WHERE tenant_id = @tenant_id AND subject_id = @subject_id;

-- name: RevokeAccountSessions :execrows
-- Monotonic: GREATEST means a replayed or late-arriving revocation cannot move
-- the watermark backwards and resurrect sessions a later one already killed.
UPDATE identity_access.account
SET not_valid_before = GREATEST(not_valid_before, @at::timestamptz),
    updated_at = @at, version = version + 1
WHERE tenant_id = @tenant_id AND subject_id = @subject_id;

-- name: SetAccountStatus :execrows
-- Status and revocation move together: every lifecycle change ends live
-- sessions, including reinstatement — whatever the user held while suspended
-- should not survive it, because the reason may have been a stolen token.
UPDATE identity_access.account
SET status = @status,
    not_valid_before = GREATEST(not_valid_before, @at::timestamptz),
    updated_at = @at, version = version + 1
WHERE tenant_id = @tenant_id AND subject_id = @subject_id
  AND status = @expected_status;

-- name: SetAccountRoles :execrows
-- The mover step. Revokes, because a session carries the permissions it was
-- minted with and a department change must not wait for the next login.
UPDATE identity_access.account
SET roles = @roles, permitted_facilities = @permitted_facilities,
    not_valid_before = GREATEST(not_valid_before, @at::timestamptz),
    updated_at = @at, version = version + 1
WHERE tenant_id = @tenant_id AND subject_id = @subject_id
  AND status <> 'deactivated';

-- name: InsertStepUpProof :exec
INSERT INTO identity_access.step_up_proof (
    proof_id, tenant_id, subject_id, action, reference, method, obtained_at
) VALUES (@proof_id, @tenant_id, @subject_id, @action, @reference, @method, @obtained_at);

-- name: GetLatestStepUpProof :one
SELECT proof_id, tenant_id, subject_id, action, reference, method, obtained_at
FROM identity_access.step_up_proof
WHERE tenant_id = @tenant_id AND subject_id = @subject_id AND action = @action
ORDER BY obtained_at DESC, proof_id DESC
LIMIT 1;

-- name: InsertSignInRisk :exec
INSERT INTO identity_access.signin_risk (
    assessment_id, tenant_id, subject_id, score, signals, alerted, blocked, occurred_at
) VALUES (
    @assessment_id, @tenant_id, @subject_id, @score, @signals, @alerted, @blocked, @occurred_at
);

-- name: CountRecentSignIns :one
-- Feeds the "dormant account" and "new device" signals at the next sign-in.
SELECT count(*) FROM identity_access.signin_risk
WHERE tenant_id = @tenant_id AND subject_id = @subject_id AND occurred_at >= @since;

-- name: ListAccountsByRoles :many
-- Who holds one of these roles here. Read by the quality context's competency
-- and policy-acknowledgement gap reports, which ask "who should have this and
-- does not" — a question that needs the establishment, not one account.
SELECT subject_id, roles FROM identity_access.account
WHERE tenant_id = @tenant_id
  AND status = 'active'
  AND roles && @roles::text[]
ORDER BY subject_id
LIMIT @row_limit;
