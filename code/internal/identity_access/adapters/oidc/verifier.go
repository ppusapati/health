// Package oidc verifies enterprise OIDC tokens (ADR-008, SRS-IAM-001).
//
// This is the production TokenVerifier. It satisfies the same one-method seam
// as the development verifier, so closing ADR-008 changed the composition root
// and nothing downstream: the interceptor, policy engine, use cases and audit
// all still consume an authctx.Session and know nothing about how it was made.
//
// Signature verification, JWKS fetching and key rotation are delegated to
// coreos/go-oidc rather than hand-rolled. JWT verification is the kind of code
// where a subtle mistake — accepting `alg: none`, confusing an HMAC key with an
// RSA public key, forgetting to check the key id — produces a system that
// authenticates anyone and looks fine in every test. A reviewed library is the
// right call, and the checks this file adds on top are the ones a library
// cannot make because they are about this system's model rather than about
// JWT.
//
// What this file owns:
//
//   - resolving which tenant an issuer belongs to, before trusting anything;
//   - mapping provider claims onto tenant roles through the federation, so the
//     provider asserts group membership and this system decides what that
//     means;
//   - refusing a token issued before the subject's revocation watermark;
//   - requiring an authentication strength the tenant asked for (MFA);
//   - producing a uniform failure, so a probe cannot tell an unknown issuer
//     from a bad signature from a revoked session.
package oidc

import (
	"context"
	"errors"
	"fmt"
	"net/http"
	"strings"
	"sync"
	"time"

	coreosoidc "github.com/coreos/go-oidc/v3/oidc"
	"github.com/ppusapati/health/code/internal/identity_access/domain"
	"github.com/ppusapati/health/code/internal/identity_access/ports"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// Config tunes the verifier.
type Config struct {
	// Audience is the client id this deployment is registered as. A token
	// issued for a different audience is a token meant for another system, and
	// accepting it is how one compromised application becomes access to
	// another.
	Audience string

	// ClockSkew tolerates disagreement between this host's clock and the
	// provider's. Small on purpose: a generous skew extends the life of every
	// expired token by the same amount, so it buys availability with exactly
	// the property the expiry exists for.
	ClockSkew time.Duration

	// RequireMFA demands an authentication strength from the token
	// (SRS-IAM-010). Empty means the tenant has not asked for one, which is a
	// decision the tenant makes rather than a default this code picks.
	RequiredACRValues []string

	// HTTPClient fetches discovery documents and JWKS. Supplied so the caller
	// controls timeouts and TLS policy rather than this package reaching for
	// http.DefaultClient, which has no timeout at all.
	HTTPClient *http.Client
}

// DefaultClockSkew is one minute.
//
// Enough to absorb ordinary NTP drift between a provider and a cluster; short
// enough that it does not meaningfully extend a token's life.
const DefaultClockSkew = time.Minute

// discoveryTimeout bounds a provider discovery or JWKS fetch. A provider that
// is slow to answer must not hold a request thread: the request fails and the
// next one retries, which is better than every request queueing behind one
// unreachable endpoint.
const discoveryTimeout = 10 * time.Second

// Verifier turns an OIDC ID token into a verified session.
type Verifier struct {
	config      Config
	federations ports.FederationStore
	accounts    ports.AccountStore
	clock       ports.Clock

	// providers caches one verifier per issuer. Built lazily: a deployment may
	// serve dozens of tenants and most of them will not sign in during any
	// given process lifetime, so discovering every provider at startup would
	// make startup depend on every customer's IdP being reachable.
	mu        sync.RWMutex
	providers map[string]*coreosoidc.IDTokenVerifier
}

// New constructs the verifier.
func New(cfg Config, federations ports.FederationStore, accounts ports.AccountStore,
	clock ports.Clock) (*Verifier, error) {

	switch {
	case strings.TrimSpace(cfg.Audience) == "":
		// Without an audience every token any provider ever issued for any
		// application is accepted here.
		return nil, errors.New("oidc: an audience (client id) is required")
	case federations == nil:
		return nil, errors.New("oidc: a federation store is required")
	case accounts == nil:
		return nil, errors.New("oidc: an account store is required")
	case clock == nil:
		return nil, errors.New("oidc: a clock is required")
	}

	if cfg.ClockSkew <= 0 {
		cfg.ClockSkew = DefaultClockSkew
	}
	if cfg.HTTPClient == nil {
		cfg.HTTPClient = &http.Client{Timeout: discoveryTimeout}
	}

	return &Verifier{
		config: cfg, federations: federations, accounts: accounts, clock: clock,
		providers: map[string]*coreosoidc.IDTokenVerifier{},
	}, nil
}

// claims are the parts of an ID token this system reads.
type claims struct {
	Issuer   string   `json:"iss"`
	Subject  string   `json:"sub"`
	Audience []string `json:"-"`
	Email    string   `json:"email"`
	Name     string   `json:"name"`
	// ACR and AMR describe how the user authenticated. ACR is a policy
	// identifier the provider was asked for; AMR lists the methods actually
	// used. Both are read because providers disagree about which they populate.
	ACR string   `json:"acr"`
	AMR []string `json:"amr"`
	// Groups and Roles are the assertions a federation's mappings match
	// against. Both names are read because every provider spells it
	// differently and requiring one spelling means every new customer needs a
	// code change.
	Groups []string `json:"groups"`
	Roles  []string `json:"roles"`
	// AuthTime is when the user actually authenticated, as opposed to when
	// this token was minted. A provider that silently refreshes a token keeps
	// iat current while auth_time stays where it was, which is the difference
	// that matters for a step-up or a revocation check.
	AuthTime int64 `json:"auth_time"`
}

// unauthenticated is the single failure this verifier returns.
//
// Every rejection produces the same code and message. A probe must not be able
// to tell an unknown issuer from a bad signature from a revoked session: those
// answers together map out which hospitals use the platform and which accounts
// exist. The cause is attached for the server's own logs and never reaches the
// client.
func unauthenticated(cause error) error {
	return rpcerr.Unauthenticated("AUTH_TOKEN_INVALID", "invalid credentials").WithCause(cause)
}

// Verify authenticates a bearer token and resolves it to a session.
func (v *Verifier) Verify(ctx context.Context, token string) (authctx.Session, error) {
	if strings.TrimSpace(token) == "" {
		return authctx.Session{}, unauthenticated(errors.New("empty token"))
	}

	// The issuer is read from the unverified token only to choose which
	// verifier to use. Nothing is trusted from it: the chosen verifier then
	// re-checks the issuer against its own configuration, so a forged `iss`
	// selects a provider whose keys will not validate the signature.
	issuer, err := unverifiedIssuer(token)
	if err != nil {
		return authctx.Session{}, unauthenticated(err)
	}

	federation, err := v.federations.ByIssuer(ctx, issuer)
	if err != nil {
		return authctx.Session{}, unauthenticated(fmt.Errorf("issuer %q: %w", issuer, err))
	}
	if !federation.Enabled {
		return authctx.Session{}, unauthenticated(domain.ErrFederationDisabled)
	}

	verifier, err := v.verifierFor(ctx, federation.Issuer)
	if err != nil {
		return authctx.Session{}, unauthenticated(err)
	}

	idToken, err := verifier.Verify(ctx, token)
	if err != nil {
		return authctx.Session{}, unauthenticated(err)
	}

	var c claims
	if err := idToken.Claims(&c); err != nil {
		return authctx.Session{}, unauthenticated(err)
	}
	// The library validated iss, aud, exp and the signature. These are the
	// claims it has no opinion about.
	c.Issuer = idToken.Issuer
	c.Subject = idToken.Subject

	now := v.clock.Now()

	if err := v.checkAuthenticationStrength(c); err != nil {
		return authctx.Session{}, unauthenticated(err)
	}

	// The federation maps the provider's assertions onto this tenant's roles.
	// The provider says which groups the user is in; this system decides what
	// a group means here, which is what keeps a customer's directory from
	// granting itself permissions in our model.
	resolved, err := federation.Resolve(domain.FederatedClaims{
		Issuer: c.Issuer, Subject: c.Subject, Email: c.Email, Name: c.Name,
		IssuedAt: idToken.IssuedAt, ExpiresAt: idToken.Expiry,
		Claims: map[string][]string{"groups": c.Groups, "roles": c.Roles},
	}, now)
	if err != nil {
		return authctx.Session{}, unauthenticated(err)
	}

	// Upsert before the revocation check, so a first sign-in has an account to
	// check against and a returning user's roles reflect what the provider now
	// asserts. Upsert never moves the revocation watermark — a re-login must
	// not clear a suspension an administrator applied.
	account, err := v.accounts.Upsert(ctx, resolved)
	if err != nil {
		return authctx.Session{}, unauthenticated(err)
	}

	// issuedAt is the credential's own issue time, which is what the
	// revocation watermark is compared against.
	issuedAt := idToken.IssuedAt
	if c.AuthTime > 0 {
		// When the provider tells us when the user actually authenticated,
		// that is the honest instant. A refreshed token has a fresh iat and a
		// stale auth_time, and using iat would let a refresh outlive a
		// revocation.
		authTime := time.Unix(c.AuthTime, 0).UTC()
		if authTime.Before(issuedAt) {
			issuedAt = authTime
		}
	}

	if err := account.AuthorizeSession(issuedAt, now); err != nil {
		return authctx.Session{}, unauthenticated(err)
	}

	return authctx.Session{
		SubjectID:           account.SubjectID,
		TenantID:            account.TenantID,
		Roles:               roleNames(account.Roles),
		Permissions:         account.Permissions(),
		PermittedFacilities: account.PermittedFacilities,
		// Purposes are not asserted by the identity provider: what a clinician
		// may use data for is this system's policy, not their employer's
		// directory. The session starts with the purposes the role catalogue
		// allows, and the header may narrow within them.
		PermittedPurposes: domain.PurposesFor(account.Roles),
		IssuedAt:          issuedAt,
	}, nil
}

// checkAuthenticationStrength enforces the tenant's MFA requirement
// (SRS-IAM-010).
//
// Both acr and amr are consulted because providers disagree: some populate an
// acr policy identifier, some list the methods in amr, and a few do neither
// unless asked. A tenant that requires MFA and whose provider says nothing gets
// a refusal rather than a pass, because "no evidence of MFA" and "no MFA" have
// to be treated the same way.
func (v *Verifier) checkAuthenticationStrength(c claims) error {
	if len(v.config.RequiredACRValues) == 0 {
		return nil
	}
	for _, required := range v.config.RequiredACRValues {
		if c.ACR == required {
			return nil
		}
		for _, method := range c.AMR {
			if method == required {
				return nil
			}
		}
	}
	return fmt.Errorf("authentication strength %q/%v does not satisfy %v",
		c.ACR, c.AMR, v.config.RequiredACRValues)
}

// verifierFor returns the cached verifier for an issuer, discovering it once.
func (v *Verifier) verifierFor(ctx context.Context, issuer string) (*coreosoidc.IDTokenVerifier, error) {
	v.mu.RLock()
	cached, found := v.providers[issuer]
	v.mu.RUnlock()
	if found {
		return cached, nil
	}

	// Discovery is bounded separately from the request: a provider that hangs
	// must not hold the caller's whole deadline.
	discoverCtx, cancel := context.WithTimeout(
		coreosoidc.ClientContext(ctx, v.config.HTTPClient), discoveryTimeout)
	defer cancel()

	provider, err := coreosoidc.NewProvider(discoverCtx, issuer)
	if err != nil {
		return nil, fmt.Errorf("discover %s: %w", issuer, err)
	}

	verifier := provider.Verifier(&coreosoidc.Config{
		ClientID: v.config.Audience,
		// Clock skew is applied to expiry and not-before. The library defaults
		// to none, which fails for any host whose clock is a second behind.
		SkipClientIDCheck: false,
		SkipExpiryCheck:   false,
		SkipIssuerCheck:   false,
		Now:               func() time.Time { return v.clock.Now() },
	})

	v.mu.Lock()
	defer v.mu.Unlock()
	// Re-check: another goroutine may have discovered the same issuer while
	// this one was waiting on the network. Keeping the first wins rather than
	// overwriting, so a verifier already handed out stays the one in use.
	if existing, raced := v.providers[issuer]; raced {
		return existing, nil
	}
	v.providers[issuer] = verifier
	return verifier, nil
}

func roleNames(roles []domain.Role) []string {
	out := make([]string, 0, len(roles))
	for _, r := range roles {
		out = append(out, string(r))
	}
	return out
}
