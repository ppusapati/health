package postgres_test

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/ppusapati/health/code/internal/identity_access/adapters/postgres"
	"github.com/ppusapati/health/code/internal/identity_access/domain"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
)

var at = time.Date(2026, 9, 11, 10, 0, 0, 0, time.UTC)

type fixture struct {
	repo   *postgres.Repository
	pool   *pgxpool.Pool
	tenant string
}

func newFixture(t *testing.T) fixture {
	t.Helper()
	pool := pgtest.New(t)
	return fixture{
		repo:   postgres.New(pgtx.NewManager(pool)),
		pool:   pool,
		tenant: uuid.NewString(),
	}
}

func (f fixture) federation(t *testing.T, issuer string) domain.Federation {
	t.Helper()
	fed, err := domain.NewFederation(uuid.NewString(), f.tenant, issuer,
		[]string{"acme.example"},
		[]domain.RoleMapping{{
			Claim: "groups", Value: "hospital-admins",
			Roles: []domain.Role{domain.RoleTenantAdmin}, PermittedFacilities: []string{"fac-1"},
		}}, nil, at)
	if err != nil {
		t.Fatalf("NewFederation: %v", err)
	}
	if err := f.repo.InsertFederation(context.Background(), fed); err != nil {
		t.Fatalf("InsertFederation: %v", err)
	}
	return fed
}

func (f fixture) account(t *testing.T, subject string) domain.Account {
	t.Helper()
	a, err := domain.NewAccount(uuid.NewString(), f.tenant, subject,
		"oidc:https://login.acme.example", "Dr Singh",
		[]domain.Role{domain.RoleTenantAdmin}, []string{"fac-1"}, at)
	if err != nil {
		t.Fatalf("NewAccount: %v", err)
	}
	a.Status = domain.AccountActive
	a.NotValidBefore = time.Time{}

	stored, err := f.repo.Upsert(context.Background(), a)
	if err != nil {
		t.Fatalf("Upsert: %v", err)
	}
	return stored
}

func TestFederationRoundTrip(t *testing.T) {
	f := newFixture(t)
	const issuer = "https://login.acme.example"
	f.federation(t, issuer)

	got, err := f.repo.ByIssuer(context.Background(), issuer)
	if err != nil {
		t.Fatalf("ByIssuer: %v", err)
	}
	if got.TenantID != f.tenant {
		t.Fatalf("tenant %q, want %q", got.TenantID, f.tenant)
	}
	if len(got.RoleMappings) != 1 || got.RoleMappings[0].Value != "hospital-admins" {
		t.Fatalf("role mappings lost: %+v", got.RoleMappings)
	}
	if len(got.RoleMappings[0].PermittedFacilities) != 1 {
		t.Fatalf("facilities lost: %+v", got.RoleMappings[0])
	}
	if !got.Enabled {
		t.Fatal("federation came back disabled")
	}
}

// Two tenants claiming one issuer would make "which tenant is this token for?"
// ambiguous at the only point where it cannot be.
func TestAnIssuerBelongsToExactlyOneTenant(t *testing.T) {
	f := newFixture(t)
	const issuer = "https://login.acme.example"
	f.federation(t, issuer)

	other, err := domain.NewFederation(uuid.NewString(), uuid.NewString(), issuer,
		nil, []domain.RoleMapping{{Claim: "groups", Value: "x",
			Roles: []domain.Role{domain.RoleAuditor}}}, nil, at)
	if err != nil {
		t.Fatalf("NewFederation: %v", err)
	}
	if err := f.repo.InsertFederation(context.Background(), other); err == nil {
		t.Fatal("a second tenant federated the same issuer")
	}
}

func TestUnknownIssuerIsNotFound(t *testing.T) {
	f := newFixture(t)
	if _, err := f.repo.ByIssuer(context.Background(), "https://nobody.example"); !errors.Is(err, postgres.ErrNotFound) {
		t.Fatalf("want ErrNotFound, got %v", err)
	}
}

// The whole revocation guarantee: a re-login refreshes what the provider
// asserts and cannot clear a suspension or move a watermark backwards.
func TestUpsertRefreshesRolesWithoutClearingRevocation(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	const subject = "auth0|12345"
	f.account(t, subject)

	// An administrator revokes and suspends.
	if err := f.repo.RevokeSessions(ctx, f.tenant, subject, at.Add(time.Hour)); err != nil {
		t.Fatalf("RevokeSessions: %v", err)
	}
	if err := f.repo.SetStatus(ctx, f.tenant, subject,
		domain.AccountActive, domain.AccountSuspended, at.Add(time.Hour)); err != nil {
		t.Fatalf("SetStatus: %v", err)
	}

	// The user signs in again. The provider now says they are an auditor.
	resigned, err := domain.NewAccount(uuid.NewString(), f.tenant, subject,
		"oidc:https://login.acme.example", "Dr Singh",
		[]domain.Role{domain.RoleAuditor}, []string{"fac-2"}, at.Add(2*time.Hour))
	if err != nil {
		t.Fatalf("NewAccount: %v", err)
	}
	resigned.Status = domain.AccountActive
	resigned.NotValidBefore = time.Time{}

	stored, err := f.repo.Upsert(ctx, resigned)
	if err != nil {
		t.Fatalf("Upsert: %v", err)
	}

	// Roles refreshed...
	if len(stored.Roles) != 1 || stored.Roles[0] != domain.RoleAuditor {
		t.Fatalf("roles did not refresh: %v", stored.Roles)
	}
	// ...and the suspension survived the re-login.
	if stored.Status != domain.AccountSuspended {
		t.Fatalf("a re-login cleared the suspension: status is %s", stored.Status)
	}
	// ...and the watermark did not move backwards.
	if !stored.NotValidBefore.Equal(at.Add(time.Hour)) {
		t.Fatalf("the revocation watermark moved to %s", stored.NotValidBefore)
	}
}

// A replayed or late-arriving revocation must not resurrect sessions a later
// one already killed.
func TestRevocationIsMonotonicInTheDatabase(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	const subject = "auth0|12345"
	f.account(t, subject)

	if err := f.repo.RevokeSessions(ctx, f.tenant, subject, at.Add(10*time.Hour)); err != nil {
		t.Fatalf("RevokeSessions: %v", err)
	}
	// An older revocation arrives late.
	if err := f.repo.RevokeSessions(ctx, f.tenant, subject, at.Add(time.Hour)); err != nil {
		t.Fatalf("RevokeSessions: %v", err)
	}

	watermark, err := f.repo.RevocationWatermark(ctx, f.tenant, subject)
	if err != nil {
		t.Fatalf("RevocationWatermark: %v", err)
	}
	if !watermark.Equal(at.Add(10 * time.Hour)) {
		t.Fatalf("the watermark moved backwards to %s", watermark)
	}
}

// Two administrators acting at once must not produce a transition neither
// intended.
func TestStatusChangeIsGuardedByTheExpectedState(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	const subject = "auth0|12345"
	f.account(t, subject)

	if err := f.repo.SetStatus(ctx, f.tenant, subject,
		domain.AccountActive, domain.AccountSuspended, at.Add(time.Hour)); err != nil {
		t.Fatalf("SetStatus: %v", err)
	}
	// A second administrator, still believing the account is active.
	if err := f.repo.SetStatus(ctx, f.tenant, subject,
		domain.AccountActive, domain.AccountDeactivated, at.Add(2*time.Hour)); err == nil {
		t.Fatal("a status change against a stale expectation succeeded")
	}
}

// The mover step: new roles and every live session revoked in one statement,
// so the move cannot take effect at the user's next login instead.
func TestRoleChangeRevokesInTheSameStatement(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	const subject = "auth0|12345"
	f.account(t, subject)

	before, err := f.repo.RevocationWatermark(ctx, f.tenant, subject)
	if err != nil {
		t.Fatalf("RevocationWatermark: %v", err)
	}

	if err := f.repo.SetRoles(ctx, f.tenant, subject,
		[]domain.Role{domain.RoleAuditor}, []string{"fac-2"}, at.Add(time.Hour)); err != nil {
		t.Fatalf("SetRoles: %v", err)
	}

	after, err := f.repo.RevocationWatermark(ctx, f.tenant, subject)
	if err != nil {
		t.Fatalf("RevocationWatermark: %v", err)
	}
	if !after.After(before) {
		t.Fatalf("a role change did not revoke: watermark %s → %s", before, after)
	}

	stored, err := f.repo.BySubject(ctx, f.tenant, subject)
	if err != nil {
		t.Fatalf("BySubject: %v", err)
	}
	if len(stored.Roles) != 1 || stored.Roles[0] != domain.RoleAuditor {
		t.Fatalf("roles %v", stored.Roles)
	}
}

// A deactivated account is terminal, so a role change cannot quietly reanimate
// whatever access it had when it was closed.
func TestADeactivatedAccountCannotHaveItsRolesChanged(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	const subject = "auth0|12345"
	f.account(t, subject)

	if err := f.repo.SetStatus(ctx, f.tenant, subject,
		domain.AccountActive, domain.AccountDeactivated, at.Add(time.Hour)); err != nil {
		t.Fatalf("SetStatus: %v", err)
	}
	if err := f.repo.SetRoles(ctx, f.tenant, subject,
		[]domain.Role{domain.RoleTenantAdmin}, nil, at.Add(2*time.Hour)); err == nil {
		t.Fatal("a deactivated account had its roles changed")
	}
}

// Accounts are keyed by tenant and subject, so the same external subject in
// two tenants is two accounts — which is what a clinician working for two
// hospital groups actually is.
func TestAccountsAreTenantScoped(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	const subject = "auth0|12345"
	f.account(t, subject)

	otherTenant := uuid.NewString()
	if _, err := f.repo.BySubject(ctx, otherTenant, subject); !errors.Is(err, postgres.ErrNotFound) {
		t.Fatalf("another tenant read this account: %v", err)
	}
	if err := f.repo.RevokeSessions(ctx, otherTenant, subject, at); !errors.Is(err, postgres.ErrNotFound) {
		t.Fatalf("another tenant revoked this account: %v", err)
	}

	// And this tenant's account is untouched.
	stored, err := f.repo.BySubject(ctx, f.tenant, subject)
	if err != nil {
		t.Fatalf("BySubject: %v", err)
	}
	if !stored.NotValidBefore.IsZero() {
		t.Fatalf("the watermark moved to %s", stored.NotValidBefore)
	}
}

// Repeated sign-ins must resolve to one row rather than creating an account
// per login.
func TestRepeatedUpsertsProduceOneAccount(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	const subject = "auth0|12345"

	for range 3 {
		f.account(t, subject)
	}

	var rows int
	err := f.pool.QueryRow(ctx,
		`SELECT count(*) FROM identity_access.account WHERE tenant_id = $1 AND subject_id = $2`,
		f.tenant, subject).Scan(&rows)
	if err != nil {
		t.Fatalf("count: %v", err)
	}
	if rows != 1 {
		t.Fatalf("%d accounts for one subject", rows)
	}
}
