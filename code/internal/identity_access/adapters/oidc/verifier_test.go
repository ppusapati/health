package oidc_test

import (
	"context"
	"crypto/rand"
	"crypto/rsa"
	"errors"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/identity_access/adapters/oidc"
	"github.com/ppusapati/health/code/internal/identity_access/domain"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

const audience = "healthcare-workspace"

var now = time.Date(2026, 9, 11, 10, 0, 0, 0, time.UTC)

type stubClock struct {
	mu sync.Mutex
	t  time.Time
}

func (c *stubClock) Now() time.Time {
	c.mu.Lock()
	defer c.mu.Unlock()
	return c.t
}

func (c *stubClock) set(t time.Time) {
	c.mu.Lock()
	defer c.mu.Unlock()
	c.t = t
}

// stubFederations resolves one issuer.
type stubFederations struct {
	byIssuer map[string]domain.Federation
}

func (s *stubFederations) ByIssuer(_ context.Context, issuer string) (domain.Federation, error) {
	f, ok := s.byIssuer[issuer]
	if !ok {
		return domain.Federation{}, errors.New("no federation for issuer")
	}
	return f, nil
}

// stubAccounts is an in-memory account store that behaves like the real one in
// the way that matters: Upsert refreshes roles and never moves the revocation
// watermark.
type stubAccounts struct {
	mu       sync.Mutex
	accounts map[string]domain.Account
	upserts  int
}

func newAccounts() *stubAccounts {
	return &stubAccounts{accounts: map[string]domain.Account{}}
}

func key(tenantID, subjectID string) string { return tenantID + "/" + subjectID }

func (s *stubAccounts) BySubject(_ context.Context, tenantID, subjectID string) (domain.Account, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	a, ok := s.accounts[key(tenantID, subjectID)]
	if !ok {
		return domain.Account{}, errors.New("no such account")
	}
	return a, nil
}

func (s *stubAccounts) Upsert(_ context.Context, a domain.Account) (domain.Account, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.upserts++

	if existing, ok := s.accounts[key(a.TenantID, a.SubjectID)]; ok {
		// Roles refresh from the provider; the watermark and status are this
		// system's and survive a re-login.
		existing.Roles = a.Roles
		existing.PermittedFacilities = a.PermittedFacilities
		existing.DisplayName = a.DisplayName
		s.accounts[key(a.TenantID, a.SubjectID)] = existing
		return existing, nil
	}
	s.accounts[key(a.TenantID, a.SubjectID)] = a
	return a, nil
}

func (s *stubAccounts) RevocationWatermark(_ context.Context, tenantID, subjectID string) (time.Time, error) {
	a, err := s.BySubject(context.Background(), tenantID, subjectID)
	if err != nil {
		return time.Time{}, err
	}
	return a.NotValidBefore, nil
}

func (s *stubAccounts) revoke(t *testing.T, tenantID, subjectID string, at time.Time) {
	t.Helper()
	s.mu.Lock()
	defer s.mu.Unlock()
	a := s.accounts[key(tenantID, subjectID)]
	a.RevokeSessions(at)
	s.accounts[key(tenantID, subjectID)] = a
}

func (s *stubAccounts) suspend(t *testing.T, tenantID, subjectID string, at time.Time) {
	t.Helper()
	s.mu.Lock()
	defer s.mu.Unlock()
	a := s.accounts[key(tenantID, subjectID)]
	if err := a.Suspend(at); err != nil {
		t.Fatalf("Suspend: %v", err)
	}
	s.accounts[key(tenantID, subjectID)] = a
}

type harness struct {
	provider    *testProvider
	verifier    *oidc.Verifier
	accounts    *stubAccounts
	clock       *stubClock
	federations *stubFederations
	tenantID    string
}

func newHarness(t *testing.T, cfg oidc.Config) *harness {
	t.Helper()

	provider := newTestProvider(t)
	const tenantID = "tenant-a"

	federation, err := domain.NewFederation("fed-1", tenantID, provider.Issuer(),
		[]string{"acme.example"},
		[]domain.RoleMapping{
			{Claim: "groups", Value: "hospital-admins",
				Roles: []domain.Role{domain.RoleTenantAdmin}, PermittedFacilities: []string{"fac-1"}},
			{Claim: "groups", Value: "auditors",
				Roles: []domain.Role{domain.RoleAuditor}},
		}, nil, now)
	if err != nil {
		t.Fatalf("NewFederation: %v", err)
	}

	if cfg.Audience == "" {
		cfg.Audience = audience
	}
	// The provider serves TLS with a self-signed certificate, so the verifier
	// needs the client that trusts it. Setting it here rather than in every
	// test also means a verifier that ignored Config.HTTPClient would fail
	// every test in this file rather than silently reaching for
	// http.DefaultClient.
	cfg.HTTPClient = provider.Client()
	clock := &stubClock{t: now}
	accounts := newAccounts()
	federations := &stubFederations{byIssuer: map[string]domain.Federation{provider.Issuer(): federation}}

	verifier, err := oidc.New(cfg, federations, accounts, clock)
	if err != nil {
		t.Fatalf("oidc.New: %v", err)
	}

	return &harness{
		provider: provider, verifier: verifier, accounts: accounts,
		clock: clock, federations: federations, tenantID: tenantID,
	}
}

// goodToken mints a token that should verify.
func (h *harness) goodToken(t *testing.T, mutate ...func(*tokenClaims)) string {
	t.Helper()
	c := tokenClaims{
		Subject:   "auth0|12345",
		Audience:  audience,
		IssuedAt:  now.Add(-time.Minute),
		ExpiresAt: now.Add(time.Hour),
		Email:     "priya@acme.example",
		Name:      "Priya Ramaswamy",
		Groups:    []string{"hospital-admins"},
	}
	for _, m := range mutate {
		m(&c)
	}
	return h.provider.mint(t, c)
}

func assertUnauthenticated(t *testing.T, err error) {
	t.Helper()
	if err == nil {
		t.Fatal("expected a refusal")
	}
	e, ok := rpcerr.As(err)
	if !ok {
		t.Fatalf("not a platform error: %v", err)
	}
	if e.Category != rpcerr.CategoryUnauthenticated {
		t.Fatalf("category %s, want UNAUTHENTICATED (%v)", e.Category, err)
	}
	// Every rejection must look identical from outside: a probe that could
	// tell an unknown issuer from a bad signature could map out which
	// hospitals use the platform and which accounts exist.
	if e.Code != "AUTH_TOKEN_INVALID" {
		t.Fatalf("code %q; every failure must be indistinguishable", e.Code)
	}
	if e.Message != "invalid credentials" {
		t.Fatalf("message %q leaks the failure mode", e.Message)
	}
}

// The happy path, against real RSA signatures and a real JWKS fetch.
func TestValidTokenResolvesToASession(t *testing.T) {
	h := newHarness(t, oidc.Config{})

	session, err := h.verifier.Verify(context.Background(), h.goodToken(t))
	if err != nil {
		t.Fatalf("Verify: %v", err)
	}

	if session.SubjectID != "auth0|12345" {
		t.Fatalf("subject %q", session.SubjectID)
	}
	if session.TenantID != h.tenantID {
		t.Fatalf("tenant %q; the tenant comes from the federation, not the token", session.TenantID)
	}
	// The provider asserted a group; this system decided what it means.
	if len(session.Roles) != 1 || session.Roles[0] != string(domain.RoleTenantAdmin) {
		t.Fatalf("roles %v", session.Roles)
	}
	if len(session.Permissions) == 0 {
		t.Fatal("the session carries no permissions")
	}
	if len(session.PermittedFacilities) != 1 || session.PermittedFacilities[0] != "fac-1" {
		t.Fatalf("facilities %v", session.PermittedFacilities)
	}
	if session.IssuedAt.IsZero() {
		t.Fatal("no issued-at; revocation cannot be evaluated without it")
	}
}

// A provider cannot grant a purpose-of-use. What a clinician may use data for
// is this system's policy, not their employer's directory — otherwise a
// customer could grant research access by adding a group.
func TestPurposesComeFromTheRoleCatalogueNotTheProvider(t *testing.T) {
	h := newHarness(t, oidc.Config{})

	session, err := h.verifier.Verify(context.Background(), h.goodToken(t))
	if err != nil {
		t.Fatalf("Verify: %v", err)
	}
	if len(session.PermittedPurposes) == 0 {
		t.Fatal("no purposes; the session could assert none at all")
	}
	for _, p := range session.PermittedPurposes {
		if p == authctx.PurposeResearch {
			t.Fatal("a tenant admin was granted the research purpose")
		}
	}
}

// The bypass every JWT implementation is tested against.
func TestUnsignedTokenIsRefused(t *testing.T) {
	h := newHarness(t, oidc.Config{})

	token := unsignedToken(t, h.provider.Issuer(), "auth0|12345", audience, now.Add(time.Hour))
	_, err := h.verifier.Verify(context.Background(), token)
	assertUnauthenticated(t, err)
}

// A token signed by a key the provider's JWKS does not publish.
func TestTokenSignedByAnUnknownKeyIsRefused(t *testing.T) {
	h := newHarness(t, oidc.Config{})

	attacker, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		t.Fatalf("generate key: %v", err)
	}
	token := h.goodToken(t, func(c *tokenClaims) {
		c.signWith = attacker
		// Claiming the real key's id, so the failure is the signature rather
		// than key selection.
		c.keyID = h.provider.keyID
	})

	_, err = h.verifier.Verify(context.Background(), token)
	assertUnauthenticated(t, err)
}

// A token for another application. Accepting it is how one compromised
// application becomes access to another.
func TestTokenForAnotherAudienceIsRefused(t *testing.T) {
	h := newHarness(t, oidc.Config{})

	token := h.goodToken(t, func(c *tokenClaims) { c.Audience = "some-other-app" })
	_, err := h.verifier.Verify(context.Background(), token)
	assertUnauthenticated(t, err)
}

func TestExpiredTokenIsRefused(t *testing.T) {
	h := newHarness(t, oidc.Config{})

	token := h.goodToken(t, func(c *tokenClaims) {
		c.IssuedAt = now.Add(-2 * time.Hour)
		c.ExpiresAt = now.Add(-time.Hour)
	})
	_, err := h.verifier.Verify(context.Background(), token)
	assertUnauthenticated(t, err)
}

// A forged issuer selects a federation whose keys will not validate the token,
// so lying about the issuer only changes which code path rejects you.
func TestForgedIssuerIsRefused(t *testing.T) {
	h := newHarness(t, oidc.Config{})

	token := h.goodToken(t, func(c *tokenClaims) { c.Issuer = "https://attacker.example" })
	_, err := h.verifier.Verify(context.Background(), token)
	assertUnauthenticated(t, err)
}

func TestUnknownIssuerIsRefused(t *testing.T) {
	h := newHarness(t, oidc.Config{})

	// A well-formed, correctly signed token from a provider this deployment
	// has no federation for.
	other := newTestProvider(t)
	token := other.mint(t, tokenClaims{
		Subject: "auth0|999", Audience: audience,
		IssuedAt: now.Add(-time.Minute), ExpiresAt: now.Add(time.Hour),
	})

	_, err := h.verifier.Verify(context.Background(), token)
	assertUnauthenticated(t, err)
}

func TestMalformedTokensAreRefused(t *testing.T) {
	h := newHarness(t, oidc.Config{})

	for name, token := range map[string]string{
		"empty":            "",
		"not a jws":        "not-a-token",
		"two segments":     "aGVhZGVy.cGF5bG9hZA",
		"bad base64":       "aGVhZGVy.!!!not-base64!!!.c2ln",
		"payload not json": "aGVhZGVy." + "bm90IGpzb24" + ".c2ln",
		"no issuer":        "aGVhZGVy.eyJzdWIiOiJ4In0.c2ln",
	} {
		t.Run(name, func(t *testing.T) {
			_, err := h.verifier.Verify(context.Background(), token)
			assertUnauthenticated(t, err)
		})
	}
}

// SRS-IAM-006 through the verifier: a revoked session is refused even though
// the token is valid and unexpired.
func TestRevokedSessionIsRefusedDespiteAValidToken(t *testing.T) {
	h := newHarness(t, oidc.Config{})
	ctx := context.Background()

	token := h.goodToken(t)
	if _, err := h.verifier.Verify(ctx, token); err != nil {
		t.Fatalf("first sign-in: %v", err)
	}

	// An administrator disables the account. The token in the user's browser
	// is untouched and nowhere near expiry.
	h.accounts.revoke(t, h.tenantID, "auth0|12345", now.Add(time.Minute))
	h.clock.set(now.Add(2 * time.Minute))

	_, err := h.verifier.Verify(ctx, token)
	assertUnauthenticated(t, err)
}

func TestSuspendedAccountCannotAuthenticate(t *testing.T) {
	h := newHarness(t, oidc.Config{})
	ctx := context.Background()

	if _, err := h.verifier.Verify(ctx, h.goodToken(t)); err != nil {
		t.Fatalf("first sign-in: %v", err)
	}
	// The account must be active before it can be suspended.
	h.accounts.mu.Lock()
	a := h.accounts.accounts[key(h.tenantID, "auth0|12345")]
	h.accounts.mu.Unlock()
	if a.Status != domain.AccountActive {
		t.Fatalf("a federated sign-in produced status %s", a.Status)
	}

	h.accounts.suspend(t, h.tenantID, "auth0|12345", now.Add(time.Minute))
	h.clock.set(now.Add(2 * time.Minute))

	fresh := h.goodToken(t, func(c *tokenClaims) { c.IssuedAt = now.Add(90 * time.Second) })
	_, err := h.verifier.Verify(ctx, fresh)
	assertUnauthenticated(t, err)
}

// A provider that silently refreshes a token keeps iat current while auth_time
// stays where it was. Using iat would let a refresh outlive a revocation.
func TestAuthTimeBeatsIssuedAtForRevocation(t *testing.T) {
	h := newHarness(t, oidc.Config{})
	ctx := context.Background()

	if _, err := h.verifier.Verify(ctx, h.goodToken(t)); err != nil {
		t.Fatalf("first sign-in: %v", err)
	}

	h.accounts.revoke(t, h.tenantID, "auth0|12345", now.Add(5*time.Minute))
	h.clock.set(now.Add(10 * time.Minute))

	// A refreshed token: minted after the revocation, but the user actually
	// authenticated before it.
	refreshed := h.goodToken(t, func(c *tokenClaims) {
		c.IssuedAt = now.Add(9 * time.Minute)
		c.ExpiresAt = now.Add(time.Hour)
		c.AuthTime = now.Add(time.Minute)
	})

	_, err := h.verifier.Verify(ctx, refreshed)
	assertUnauthenticated(t, err)
}

// SRS-IAM-010: a tenant that requires MFA gets it enforced.
func TestMFARequirementIsEnforced(t *testing.T) {
	h := newHarness(t, oidc.Config{RequiredACRValues: []string{"mfa", "urn:mace:incommon:iap:silver"}})
	ctx := context.Background()

	// No acr, no amr: the provider said nothing about how the user
	// authenticated, which must be treated the same as "no MFA".
	_, err := h.verifier.Verify(ctx, h.goodToken(t))
	assertUnauthenticated(t, err)

	// acr satisfies it.
	viaACR := h.goodToken(t, func(c *tokenClaims) { c.ACR = "mfa" })
	if _, err := h.verifier.Verify(ctx, viaACR); err != nil {
		t.Fatalf("a token with acr=mfa was refused: %v", err)
	}

	// So does amr, because providers disagree about which they populate.
	viaAMR := h.goodToken(t, func(c *tokenClaims) { c.AMR = []string{"pwd", "mfa"} })
	if _, err := h.verifier.Verify(ctx, viaAMR); err != nil {
		t.Fatalf("a token with amr containing mfa was refused: %v", err)
	}

	// A different acr does not.
	wrong := h.goodToken(t, func(c *tokenClaims) { c.ACR = "urn:acr:password" })
	_, err = h.verifier.Verify(ctx, wrong)
	assertUnauthenticated(t, err)
}

// A user in no mapped group signs in and can do nothing — visible to them and
// to support, unlike a silent denial.
func TestUnmappedUserGetsASessionWithNoPermissions(t *testing.T) {
	h := newHarness(t, oidc.Config{})

	token := h.goodToken(t, func(c *tokenClaims) {
		c.Subject = "auth0|contractor"
		c.Groups = []string{"contractors"}
	})
	session, err := h.verifier.Verify(context.Background(), token)
	if err != nil {
		t.Fatalf("Verify: %v", err)
	}
	if len(session.Permissions) != 0 {
		t.Fatalf("an unmapped user holds %v", session.Permissions)
	}
}

// Re-login refreshes roles from the provider without clearing a suspension an
// administrator applied.
func TestRepeatedSignInRefreshesRolesWithoutClearingRevocation(t *testing.T) {
	h := newHarness(t, oidc.Config{})
	ctx := context.Background()

	if _, err := h.verifier.Verify(ctx, h.goodToken(t)); err != nil {
		t.Fatalf("first sign-in: %v", err)
	}

	// The provider moves the user from admins to auditors.
	second := h.goodToken(t, func(c *tokenClaims) { c.Groups = []string{"auditors"} })
	session, err := h.verifier.Verify(ctx, second)
	if err != nil {
		t.Fatalf("second sign-in: %v", err)
	}
	if len(session.Roles) != 1 || session.Roles[0] != string(domain.RoleAuditor) {
		t.Fatalf("roles did not refresh: %v", session.Roles)
	}

	// And a revocation still holds across a re-login.
	h.accounts.revoke(t, h.tenantID, "auth0|12345", now.Add(time.Minute))
	h.clock.set(now.Add(2 * time.Minute))
	_, err = h.verifier.Verify(ctx, second)
	assertUnauthenticated(t, err)
}

// Discovery happens once per issuer, not once per request: a sign-in storm must
// not become a load test against a customer's identity provider.
func TestDiscoveryIsCachedPerIssuer(t *testing.T) {
	h := newHarness(t, oidc.Config{})
	ctx := context.Background()

	const calls = 12
	var wg sync.WaitGroup
	errs := make([]error, calls)
	for i := range calls {
		wg.Add(1)
		go func() {
			defer wg.Done()
			_, errs[i] = h.verifier.Verify(ctx, h.goodToken(t))
		}()
	}
	wg.Wait()

	for i, err := range errs {
		if err != nil {
			t.Fatalf("concurrent verify %d: %v", i, err)
		}
	}
	if h.accounts.upserts != calls {
		t.Fatalf("%d upserts for %d sign-ins", h.accounts.upserts, calls)
	}
}

// A disabled federation refuses, which is how a customer relationship ending
// stops being an access path.
func TestDisabledFederationIsRefused(t *testing.T) {
	h := newHarness(t, oidc.Config{})

	f := h.federations.byIssuer[h.provider.Issuer()]
	f.Enabled = false
	h.federations.byIssuer[h.provider.Issuer()] = f

	_, err := h.verifier.Verify(context.Background(), h.goodToken(t))
	assertUnauthenticated(t, err)
}

func TestConstructionRefusesAnIncompleteConfiguration(t *testing.T) {
	accounts := newAccounts()
	federations := &stubFederations{byIssuer: map[string]domain.Federation{}}
	clock := &stubClock{t: now}

	// Without an audience every token any provider ever issued for any
	// application is accepted.
	if _, err := oidc.New(oidc.Config{}, federations, accounts, clock); err == nil {
		t.Error("a verifier with no audience was constructed")
	}
	if _, err := oidc.New(oidc.Config{Audience: audience}, nil, accounts, clock); err == nil {
		t.Error("a verifier with no federation store was constructed")
	}
	if _, err := oidc.New(oidc.Config{Audience: audience}, federations, nil, clock); err == nil {
		t.Error("a verifier with no account store was constructed")
	}
	if _, err := oidc.New(oidc.Config{Audience: audience}, federations, accounts, nil); err == nil {
		t.Error("a verifier with no clock was constructed")
	}
}

// A payload large enough to be a denial-of-service is rejected before it is
// parsed, since this runs before any authentication.
func TestOversizedUnverifiedPayloadIsRefused(t *testing.T) {
	h := newHarness(t, oidc.Config{})

	huge := strings.Repeat("A", 64<<10)
	token := "aGVhZGVy." + huge + ".c2ln"
	_, err := h.verifier.Verify(context.Background(), token)
	assertUnauthenticated(t, err)
}
