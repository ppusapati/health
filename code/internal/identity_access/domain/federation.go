package domain

import (
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"
)

// SSO federation (SRS-IAM-009) and workload identity (SRS-IAM-007).
//
// SRS-IAM-009's verification clause is "federated user maps to tenant role
// without duplicate local credentials", and the second half is the design
// constraint. The tempting implementation mirrors each federated user into a
// local account with a local password "for emergencies", and that local
// password then outlives the federation, is not covered by the customer's own
// offboarding, and is how a leaver keeps access after their employer disabled
// them.
//
// So a federated account holds no secret at all. The external subject is the
// identity; this side stores only the mapping from the identity provider's
// claims to tenant roles.

// Federation maps one external identity provider to one tenant.
type Federation struct {
	ID       string
	TenantID string
	// Issuer is the OIDC issuer or SAML entity id. It is the trust anchor: a
	// token is only considered if its issuer matches exactly.
	Issuer string
	// Domains are the email domains this federation claims. Used to route a
	// user to their provider at sign-in, never to authorise — a claimed domain
	// is a routing hint, and treating it as proof would let any federation
	// claim any domain.
	Domains []string
	// RoleMappings translate a provider group or claim value into roles here.
	RoleMappings []RoleMapping
	// DefaultRoles are granted to a federated user matching no mapping. Empty
	// is the safe value and the default: an unmapped user gets an account with
	// no permissions rather than a guess.
	DefaultRoles []Role
	Enabled      bool
	CreatedAt    time.Time
	UpdatedAt    time.Time
}

// RoleMapping turns a claim value into roles.
type RoleMapping struct {
	// Claim is the token claim to read, typically "groups" or "roles".
	Claim string
	// Value is the exact value to match. Exact, not a prefix or pattern: a
	// pattern in an authorisation rule is a pattern somebody will write too
	// loosely, and "clinician*" matching "clinician-shadow-account" is not a
	// mistake anyone catches in review.
	Value string
	Roles []Role
	// PermittedFacilities bounds where the mapped roles apply.
	PermittedFacilities []string
}

// Errors returned by federation.
var (
	// ErrInvalidFederation reports a federation that must not be stored.
	ErrInvalidFederation = errors.New("identity: invalid federation")
	// ErrIssuerMismatch reports a token from an issuer this tenant does not
	// trust.
	ErrIssuerMismatch = errors.New("identity: token issuer is not federated for this tenant")
	// ErrFederationDisabled reports a federation that has been switched off.
	ErrFederationDisabled = errors.New("identity: federation is disabled")
)

// NewFederation validates and constructs a federation.
func NewFederation(id, tenantID, issuer string, domains []string,
	mappings []RoleMapping, defaultRoles []Role, now time.Time) (Federation, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Federation{}, fmt.Errorf("%w: id is required", ErrInvalidFederation)
	case strings.TrimSpace(tenantID) == "":
		return Federation{}, fmt.Errorf("%w: tenant is required", ErrInvalidFederation)
	case strings.TrimSpace(issuer) == "":
		return Federation{}, fmt.Errorf("%w: issuer is required; it is the trust anchor", ErrInvalidFederation)
	case !strings.HasPrefix(issuer, "https://"):
		// An issuer reachable over plaintext is an issuer an attacker on the
		// path can impersonate, and the whole federation rests on it.
		return Federation{}, fmt.Errorf("%w: issuer must be https", ErrInvalidFederation)
	}

	for _, m := range mappings {
		switch {
		case strings.TrimSpace(m.Claim) == "":
			return Federation{}, fmt.Errorf("%w: a role mapping needs a claim", ErrInvalidFederation)
		case strings.TrimSpace(m.Value) == "":
			return Federation{}, fmt.Errorf("%w: a role mapping needs a value", ErrInvalidFederation)
		case len(m.Roles) == 0:
			return Federation{}, fmt.Errorf("%w: mapping %s=%s grants no roles",
				ErrInvalidFederation, m.Claim, m.Value)
		}
		for _, r := range m.Roles {
			if !KnownRole(r) {
				return Federation{}, fmt.Errorf("%w: unknown role %q in mapping %s=%s",
					ErrInvalidFederation, r, m.Claim, m.Value)
			}
		}
	}
	for _, r := range defaultRoles {
		if !KnownRole(r) {
			return Federation{}, fmt.Errorf("%w: unknown default role %q", ErrInvalidFederation, r)
		}
	}

	return Federation{
		ID: id, TenantID: tenantID, Issuer: issuer,
		Domains:      append([]string(nil), domains...),
		RoleMappings: append([]RoleMapping(nil), mappings...),
		DefaultRoles: append([]Role(nil), defaultRoles...),
		Enabled:      true,
		CreatedAt:    now.UTC(), UpdatedAt: now.UTC(),
	}, nil
}

// FederatedClaims is what a verified token carries.
type FederatedClaims struct {
	Issuer    string
	Subject   string
	Email     string
	Name      string
	IssuedAt  time.Time
	ExpiresAt time.Time
	// Claims are the provider's group or role assertions, by claim name.
	Claims map[string][]string
}

// Resolve maps verified claims to an account's roles.
//
// It returns no credential and creates no password. The external subject is
// the identity; a federated account carrying a local secret would outlive the
// federation, escape the customer's own offboarding, and become the way a
// leaver keeps access (SRS-IAM-009).
func (f Federation) Resolve(claims FederatedClaims, now time.Time) (Account, error) {
	if !f.Enabled {
		return Account{}, ErrFederationDisabled
	}
	if claims.Issuer != f.Issuer {
		// Exact match. A prefix or suffix comparison here is the classic way
		// an issuer check is bypassed by a lookalike domain.
		return Account{}, fmt.Errorf("%w: %q", ErrIssuerMismatch, claims.Issuer)
	}
	if strings.TrimSpace(claims.Subject) == "" {
		return Account{}, fmt.Errorf("%w: the token carries no subject", ErrInvalidFederation)
	}
	if !claims.ExpiresAt.IsZero() && !now.UTC().Before(claims.ExpiresAt.UTC()) {
		return Account{}, fmt.Errorf("%w: the token expired at %s",
			ErrInvalidFederation, claims.ExpiresAt.UTC().Format(time.RFC3339))
	}

	roleSet := map[Role]bool{}
	facilitySet := map[string]bool{}
	for _, m := range f.RoleMappings {
		for _, asserted := range claims.Claims[m.Claim] {
			if asserted != m.Value {
				continue
			}
			for _, r := range m.Roles {
				roleSet[r] = true
			}
			for _, fac := range m.PermittedFacilities {
				facilitySet[fac] = true
			}
		}
	}

	roles := make([]Role, 0, len(roleSet))
	for r := range roleSet {
		roles = append(roles, r)
	}
	if len(roles) == 0 {
		// No mapping matched. The default is deliberately allowed to be empty,
		// producing an account that can sign in and do nothing — which is
		// visible to the user and to support, unlike a silent denial, and far
		// better than guessing at a role.
		roles = append(roles, f.DefaultRoles...)
	}
	sort.Slice(roles, func(i, j int) bool { return roles[i] < roles[j] })

	facilities := make([]string, 0, len(facilitySet))
	for fac := range facilitySet {
		facilities = append(facilities, fac)
	}
	sort.Strings(facilities)

	displayName := claims.Name
	if displayName == "" {
		displayName = claims.Email
	}
	if displayName == "" {
		displayName = claims.Subject
	}

	account, err := NewAccount(
		// The account id is derived from the federation and the external
		// subject, so repeated sign-ins resolve to the same account rather
		// than creating one per login.
		f.ID+":"+claims.Subject,
		f.TenantID, claims.Subject, "oidc:"+f.Issuer, displayName,
		roles, facilities, now)
	if err != nil {
		return Account{}, err
	}
	// A federated user is active on first sign-in: the customer's own identity
	// provider already decided they are an employee, and requiring a second
	// local acceptance step is the duplicate-identity problem in another form.
	account.Status = AccountActive

	// The revocation watermark starts at the credential that created the
	// account, not at the moment of resolution.
	//
	// NewAccount defaults it to `now`, which is right for a locally invited
	// account — a credential predating the account is suspicious. For a
	// federated account it is wrong and self-defeating: the account is created
	// *by* this sign-in, so the token necessarily predates it by however long
	// the request took, and every first sign-in would be refused by the very
	// credential that produced it.
	//
	// A store's Upsert keeps the stored watermark for an account that already
	// exists, so this only ever applies on creation.
	if !claims.IssuedAt.IsZero() {
		account.NotValidBefore = claims.IssuedAt.UTC().Add(-time.Nanosecond)
	} else {
		// No issued-at to anchor to. Zero rather than `now`: an account whose
		// watermark nobody set should revoke nothing, and the store will move
		// it forward the first time somebody actually revokes.
		account.NotValidBefore = time.Time{}
	}
	return account, nil
}

// WorkloadIdentity is a service-to-service caller (SRS-IAM-007).
//
// Deliberately has no secret field. The verification clause is "no static
// shared service passwords required", so a workload authenticates with a
// credential it proves possession of — an mTLS client certificate, a signed
// workload token — and this type records only what was verified about it.
type WorkloadIdentity struct {
	// SPIFFEID or an equivalent workload name:
	// "spiffe://healthcare/ns/clinical/sa/scheduler".
	SPIFFEID string
	// CertificateFingerprint is the SHA-256 of the presented client
	// certificate, recorded for audit. It is evidence of what happened, not
	// the thing checked: the check is the TLS handshake, which happened before
	// this type was constructed.
	CertificateFingerprint string
	Permissions            []string
	IssuedAt               time.Time
	ExpiresAt              time.Time
}

// ErrInvalidWorkload reports a workload identity that must not be trusted.
var ErrInvalidWorkload = errors.New("identity: invalid workload identity")

// NewWorkloadIdentity validates a verified workload credential.
//
// It takes no secret and offers no way to supply one. That is the requirement
// expressed in the type system: there is no field for a shared password, so a
// service cannot be given one by a future change that merely looked
// convenient.
func NewWorkloadIdentity(spiffeID, fingerprint string, permissions []string,
	issuedAt, expiresAt time.Time) (WorkloadIdentity, error) {

	switch {
	case !strings.HasPrefix(spiffeID, "spiffe://"):
		return WorkloadIdentity{}, fmt.Errorf("%w: %q is not a SPIFFE id", ErrInvalidWorkload, spiffeID)
	case len(fingerprint) != 64:
		return WorkloadIdentity{}, fmt.Errorf("%w: fingerprint must be a 64-character SHA-256 hex digest",
			ErrInvalidWorkload)
	case expiresAt.IsZero():
		// A workload credential with no expiry is a static secret wearing a
		// certificate's clothes, which is the thing SRS-IAM-007 rules out.
		return WorkloadIdentity{}, fmt.Errorf("%w: a workload credential must expire", ErrInvalidWorkload)
	case !expiresAt.After(issuedAt):
		return WorkloadIdentity{}, fmt.Errorf("%w: expiry is not after issue", ErrInvalidWorkload)
	}

	return WorkloadIdentity{
		SPIFFEID: spiffeID, CertificateFingerprint: fingerprint,
		Permissions: append([]string(nil), permissions...),
		IssuedAt:    issuedAt.UTC(), ExpiresAt: expiresAt.UTC(),
	}, nil
}

// MaxWorkloadCredentialLifetime bounds how long a workload credential may run.
//
// A day, because a workload credential is issued by automation and renewed by
// automation; a longer one is a convenience for humans, and the humans it is
// convenient for are the ones who would otherwise have used a static password.
const MaxWorkloadCredentialLifetime = 24 * time.Hour

// Valid reports whether a workload credential may be used now.
func (w WorkloadIdentity) Valid(now time.Time) error {
	switch {
	case now.UTC().Before(w.IssuedAt):
		return fmt.Errorf("%w: credential is not yet valid", ErrInvalidWorkload)
	case !now.UTC().Before(w.ExpiresAt):
		return fmt.Errorf("%w: credential expired at %s",
			ErrInvalidWorkload, w.ExpiresAt.Format(time.RFC3339))
	case w.ExpiresAt.Sub(w.IssuedAt) > MaxWorkloadCredentialLifetime:
		return fmt.Errorf("%w: lifetime %v exceeds the %v maximum",
			ErrInvalidWorkload, w.ExpiresAt.Sub(w.IssuedAt), MaxWorkloadCredentialLifetime)
	}
	return nil
}
