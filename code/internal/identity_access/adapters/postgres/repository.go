// Package postgres is the identity & access context's persistence adapter.
//
// It is the only package permitted to issue SQL against the identity_access
// schema (FIT-02).
//
// Two methods here are deliberately untenanted — ByIssuer and the account
// lookups the verifier uses — because they run *before* a tenant is known.
// That is the authentication boundary: resolving which tenant a token belongs
// to is the thing authentication does, so it cannot itself require a verified
// tenant scope. Everything after it is scoped normally.
package postgres

import (
	"context"
	"encoding/json"
	"errors"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/ppusapati/health/code/internal/identity_access/domain"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/platform/sqlcgen"
)

// Repository implements the identity & access ports.
type Repository struct {
	tx *pgtx.Manager
}

// New constructs a Repository.
func New(tx *pgtx.Manager) *Repository { return &Repository{tx: tx} }

func (r *Repository) queries(ctx context.Context) *sqlcgen.Queries {
	return sqlcgen.New(r.tx.Querier(ctx))
}

func timestamptz(t time.Time) pgtype.Timestamptz {
	if t.IsZero() {
		// -infinity rather than NULL: the column is NOT NULL because a
		// nullable watermark invites a reader to treat NULL as "no
		// restriction" in one place and "unknown" in another.
		return pgtype.Timestamptz{InfinityModifier: pgtype.NegativeInfinity, Valid: true}
	}
	return pgtype.Timestamptz{Time: t.UTC(), Valid: true}
}

func instant(v pgtype.Timestamptz) time.Time {
	if !v.Valid || v.InfinityModifier == pgtype.NegativeInfinity {
		return time.Time{}
	}
	return v.Time
}

// ErrNotFound reports a row that does not exist.
var ErrNotFound = errors.New("identity: not found")

// ByIssuer resolves a federation from a token's issuer.
//
// Untenanted on purpose: this is the call that *determines* the tenant, so
// requiring a tenant scope would be circular. The unique index on issuer is
// what makes the answer unambiguous.
func (r *Repository) ByIssuer(ctx context.Context, issuer string) (domain.Federation, error) {
	row, err := r.queries(ctx).GetFederationByIssuer(ctx, issuer)
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Federation{}, ErrNotFound
	}
	if err != nil {
		return domain.Federation{}, err
	}

	var mappings []domain.RoleMapping
	if len(row.RoleMappings) > 0 {
		if err := json.Unmarshal(row.RoleMappings, &mappings); err != nil {
			// A federation whose mappings cannot be read must not fall back to
			// "no mappings": that would silently sign every user in with no
			// permissions, which looks like a permissions bug rather than a
			// data one and gets debugged in the wrong place.
			return domain.Federation{}, rpcerr.Internal("IAM_FEDERATION_MAPPINGS_CORRUPT",
				"federation role mappings could not be read").WithCause(err)
		}
	}

	return domain.Federation{
		ID: row.FederationID.String(), TenantID: row.TenantID.String(),
		Issuer: row.Issuer, Domains: row.Domains,
		RoleMappings: mappings,
		DefaultRoles: toRoles(row.DefaultRoles),
		Enabled:      row.Enabled,
		CreatedAt:    row.CreatedAt.Time, UpdatedAt: row.UpdatedAt.Time,
	}, nil
}

// InsertFederation records a tenant's identity provider.
func (r *Repository) InsertFederation(ctx context.Context, f domain.Federation) error {
	federationID, err := uuid.Parse(f.ID)
	if err != nil {
		return rpcerr.Internal("IAM_FEDERATION_ID_INVALID", "federation_id must be a UUID").WithCause(err)
	}
	tenantID, err := uuid.Parse(f.TenantID)
	if err != nil {
		return rpcerr.Internal("IAM_TENANT_INVALID", "tenant_id must be a UUID").WithCause(err)
	}

	mappings, err := json.Marshal(f.RoleMappings)
	if err != nil {
		return rpcerr.Internal("IAM_FEDERATION_ENCODE_FAILED", "could not encode role mappings").WithCause(err)
	}

	err = r.queries(ctx).InsertFederation(ctx, sqlcgen.InsertFederationParams{
		FederationID: federationID, TenantID: tenantID, Issuer: f.Issuer,
		Domains: f.Domains, RoleMappings: mappings,
		DefaultRoles: fromRoles(f.DefaultRoles), Enabled: f.Enabled,
		CreatedAt: timestamptz(f.CreatedAt), UpdatedAt: timestamptz(f.UpdatedAt),
	})
	if isUniqueViolation(err) {
		// Two tenants claiming one issuer would make "which tenant is this
		// token for?" ambiguous at the only point where it cannot be.
		return rpcerr.AlreadyExists("IAM_ISSUER_ALREADY_FEDERATED",
			"that issuer is already federated to a tenant")
	}
	return err
}

// BySubject reads an account.
func (r *Repository) BySubject(ctx context.Context, tenantID, subjectID string) (domain.Account, error) {
	tenant, err := uuid.Parse(tenantID)
	if err != nil {
		return domain.Account{}, ErrNotFound
	}
	row, err := r.queries(ctx).GetAccountBySubject(ctx, sqlcgen.GetAccountBySubjectParams{
		TenantID: tenant, SubjectID: subjectID,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return domain.Account{}, ErrNotFound
	}
	if err != nil {
		return domain.Account{}, err
	}
	return accountFromRow(row), nil
}

// Upsert records an account resolved from a federated sign-in.
//
// The statement refreshes what the provider asserts and leaves status and the
// revocation watermark alone, so a re-login cannot clear a suspension or move
// a watermark backwards. That property lives in the SQL rather than here
// because a caller could otherwise pass a stale account and undo a revocation
// by accident.
func (r *Repository) Upsert(ctx context.Context, a domain.Account) (domain.Account, error) {
	tenant, err := uuid.Parse(a.TenantID)
	if err != nil {
		return domain.Account{}, rpcerr.Internal("IAM_TENANT_INVALID", "tenant_id must be a UUID").WithCause(err)
	}
	accountID, err := uuid.Parse(a.ID)
	if err != nil {
		// A federated account's id is derived from the federation and the
		// external subject, which is not a UUID. Mint a stable one from that
		// string so repeated sign-ins resolve to the same row.
		accountID = uuid.NewSHA1(uuid.NameSpaceURL, []byte(a.ID))
	}

	row, err := r.queries(ctx).UpsertAccount(ctx, sqlcgen.UpsertAccountParams{
		AccountID: accountID, TenantID: tenant, SubjectID: a.SubjectID,
		IdentityProvider: a.IdentityProvider, DisplayName: a.DisplayName,
		Status: string(a.Status), Roles: fromRoles(a.Roles),
		PermittedFacilities: a.PermittedFacilities,
		NotValidBefore:      timestamptz(a.NotValidBefore),
		CreatedAt:           timestamptz(a.CreatedAt), UpdatedAt: timestamptz(a.UpdatedAt),
	})
	if err != nil {
		return domain.Account{}, err
	}
	return accountFromRow(sqlcgen.IdentityAccessAccount(row)), nil
}

// RevocationWatermark returns the instant before which a subject's credentials
// are void.
func (r *Repository) RevocationWatermark(ctx context.Context, tenantID, subjectID string) (time.Time, error) {
	tenant, err := uuid.Parse(tenantID)
	if err != nil {
		return time.Time{}, ErrNotFound
	}
	v, err := r.queries(ctx).GetRevocationWatermark(ctx, sqlcgen.GetRevocationWatermarkParams{
		TenantID: tenant, SubjectID: subjectID,
	})
	if errors.Is(err, pgx.ErrNoRows) {
		return time.Time{}, ErrNotFound
	}
	if err != nil {
		return time.Time{}, err
	}
	return instant(v), nil
}

// RevokeSessions ends every live session for a subject.
func (r *Repository) RevokeSessions(ctx context.Context, tenantID, subjectID string, at time.Time) error {
	tenant, err := uuid.Parse(tenantID)
	if err != nil {
		return ErrNotFound
	}
	rows, err := r.queries(ctx).RevokeAccountSessions(ctx, sqlcgen.RevokeAccountSessionsParams{
		At: timestamptz(at), TenantID: tenant, SubjectID: subjectID,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return ErrNotFound
	}
	return nil
}

// SetStatus moves an account through its lifecycle, revoking as it goes.
//
// expected is the status the caller believes the account is in; the statement
// refuses if it has moved, so two administrators acting at once cannot produce
// a transition neither intended.
func (r *Repository) SetStatus(ctx context.Context, tenantID, subjectID string,
	expected, next domain.AccountStatus, at time.Time) error {

	tenant, err := uuid.Parse(tenantID)
	if err != nil {
		return ErrNotFound
	}
	rows, err := r.queries(ctx).SetAccountStatus(ctx, sqlcgen.SetAccountStatusParams{
		Status: string(next), At: timestamptz(at),
		TenantID: tenant, SubjectID: subjectID, ExpectedStatus: string(expected),
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return rpcerr.FailedPrecondition("IAM_ACCOUNT_STATUS_CHANGED",
			"the account is not in the expected state")
	}
	return nil
}

// SetRoles is the mover step: new roles, and every live session revoked.
func (r *Repository) SetRoles(ctx context.Context, tenantID, subjectID string,
	roles []domain.Role, facilities []string, at time.Time) error {

	tenant, err := uuid.Parse(tenantID)
	if err != nil {
		return ErrNotFound
	}
	rows, err := r.queries(ctx).SetAccountRoles(ctx, sqlcgen.SetAccountRolesParams{
		Roles: fromRoles(roles), PermittedFacilities: facilities,
		At: timestamptz(at), TenantID: tenant, SubjectID: subjectID,
	})
	if err != nil {
		return err
	}
	if rows == 0 {
		return rpcerr.FailedPrecondition("IAM_ACCOUNT_NOT_MODIFIABLE",
			"the account does not exist or is deactivated")
	}
	return nil
}

func accountFromRow(row sqlcgen.IdentityAccessAccount) domain.Account {
	return domain.Account{
		ID: row.AccountID.String(), TenantID: row.TenantID.String(),
		SubjectID: row.SubjectID, IdentityProvider: row.IdentityProvider,
		DisplayName: row.DisplayName, Status: domain.AccountStatus(row.Status),
		Roles: toRoles(row.Roles), PermittedFacilities: row.PermittedFacilities,
		NotValidBefore: instant(row.NotValidBefore),
		CreatedAt:      row.CreatedAt.Time, UpdatedAt: row.UpdatedAt.Time,
		Version: row.Version,
	}
}

func toRoles(names []string) []domain.Role {
	out := make([]domain.Role, 0, len(names))
	for _, n := range names {
		out = append(out, domain.Role(n))
	}
	return out
}

func fromRoles(roles []domain.Role) []string {
	out := make([]string, 0, len(roles))
	for _, r := range roles {
		out = append(out, string(r))
	}
	return out
}

// AccountsByRoles implements ports.Directory.
//
// Active accounts only, and one role per person: the reports that read this
// are per role, and a person holding two of them appears under the first that
// matches rather than twice with different answers.
func (r *Repository) AccountsByRoles(ctx context.Context,
	scope authctx.TenantScope, roles []string, limit int32) (
	map[string]string, error) {

	if scope.IsZero() {
		return nil, rpcerr.Internal("IAM_NO_TENANT_SCOPE",
			"a directory read needs a verified tenant scope")
	}
	parsed, err := uuid.Parse(scope.TenantID())
	if err != nil {
		return nil, rpcerr.Internal("IAM_TENANT_ID_INVALID",
			"tenant_id must be a UUID").WithCause(err)
	}
	if len(roles) == 0 {
		return map[string]string{}, nil
	}

	rows, err := r.queries(ctx).ListAccountsByRoles(ctx,
		sqlcgen.ListAccountsByRolesParams{
			TenantID: parsed, Roles: roles, RowLimit: limit,
		})
	if err != nil {
		return nil, err
	}

	wanted := make(map[string]bool, len(roles))
	for _, role := range roles {
		wanted[role] = true
	}

	out := make(map[string]string, len(rows))
	for _, row := range rows {
		for _, held := range row.Roles {
			if wanted[held] {
				out[row.SubjectID] = held
				break
			}
		}
	}
	return out, nil
}
