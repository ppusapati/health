package domain

import (
	"errors"
	"fmt"
	"strings"
	"time"
)

// Joiner/mover/leaver and session revocation (SRS-IAM-006).
//
// The verification clause is the hard part: "disabled user cannot use existing
// session after revocation propagation target". Disabling an account is easy;
// what matters is the window between the disable and the moment the user's
// already-issued token stops working. A bearer token is valid until it
// expires, and nothing about revoking an account changes what is already in
// the user's browser.
//
// So revocation needs a positive signal the request path consults, and that
// signal has to be cheap enough to consult on every request. This is the
// design: a per-subject revocation instant, and a rule that any credential
// issued before it is dead. One comparison, no per-token bookkeeping, and it
// revokes every session a user has at once — which is what an administrator
// clicking "disable" actually means, not "revoke the session they are using".
//
// "Mover" is the case people forget. Someone changing department keeps their
// account and loses access to their old ward's records, so a role change must
// revoke too: their existing session carries the permissions it was minted
// with, and leaving it alone means the move takes effect at their next login,
// which might be next month.

// AccountStatus is the lifecycle of a user account.
type AccountStatus string

const (
	// AccountInvited exists but has never been used. It cannot authenticate.
	AccountInvited AccountStatus = "invited"
	AccountActive  AccountStatus = "active"
	// AccountSuspended is a reversible stop: leave, investigation, a forgotten
	// device. The account and its history remain.
	AccountSuspended AccountStatus = "suspended"
	// AccountDeactivated is the leaver end state. Deliberately not deletion:
	// clinical records reference the clinician who wrote them, and a deleted
	// account would orphan an audit trail that has to survive for years.
	AccountDeactivated AccountStatus = "deactivated"
)

// Account is a user's membership of a tenant.
type Account struct {
	ID       string
	TenantID string
	// SubjectID is the identity provider's subject. For a federated user it is
	// the external subject, so there is no second credential to keep in step
	// (SRS-IAM-009).
	SubjectID string
	// IdentityProvider names where the subject came from: "oidc:acme",
	// "local". Recorded so a federation being removed can be traced to the
	// accounts it affects.
	IdentityProvider string
	DisplayName      string
	Status           AccountStatus
	Roles            []Role
	// PermittedFacilities bounds which facilities the account may act in. The
	// session's active facility is checked against this, so a header cannot
	// widen it.
	PermittedFacilities []string

	// NotValidBefore is the revocation watermark. Any credential issued before
	// this instant is refused, whatever its own expiry says. Moving it forward
	// revokes every live session at once.
	NotValidBefore time.Time

	CreatedAt time.Time
	UpdatedAt time.Time
	Version   int64
}

// Errors returned by the account aggregate.
var (
	// ErrInvalidAccount reports an account that must not be stored.
	ErrInvalidAccount = errors.New("identity: invalid account")
	// ErrAccountNotUsable reports authentication against an account that may
	// not authenticate.
	ErrAccountNotUsable = errors.New("identity: account cannot authenticate")
	// ErrSessionRevoked reports a credential issued before the account's
	// revocation watermark.
	ErrSessionRevoked = errors.New("identity: session was revoked")
	// ErrIllegalTransition reports a lifecycle move that is not allowed.
	ErrIllegalTransition = errors.New("identity: illegal account transition")
)

// NewAccount creates an invited account.
//
// It always starts invited, never active: an account created directly in the
// active state is an account nobody accepted, and a bulk user import that
// produced live credentials would be a way to manufacture access.
func NewAccount(id, tenantID, subjectID, identityProvider, displayName string,
	roles []Role, permittedFacilities []string, now time.Time) (Account, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Account{}, fmt.Errorf("%w: id is required", ErrInvalidAccount)
	case strings.TrimSpace(tenantID) == "":
		return Account{}, fmt.Errorf("%w: tenant is required", ErrInvalidAccount)
	case strings.TrimSpace(subjectID) == "":
		return Account{}, fmt.Errorf("%w: subject is required", ErrInvalidAccount)
	case strings.TrimSpace(identityProvider) == "":
		// Without this, a federation being withdrawn cannot be traced to the
		// accounts that depended on it.
		return Account{}, fmt.Errorf("%w: identity provider is required", ErrInvalidAccount)
	case strings.TrimSpace(displayName) == "":
		return Account{}, fmt.Errorf("%w: display name is required", ErrInvalidAccount)
	}

	for _, r := range roles {
		if !KnownRole(r) {
			return Account{}, fmt.Errorf("%w: unknown role %q", ErrInvalidAccount, r)
		}
	}

	return Account{
		ID: id, TenantID: tenantID, SubjectID: subjectID,
		IdentityProvider: identityProvider, DisplayName: displayName,
		Status: AccountInvited, Roles: append([]Role(nil), roles...),
		PermittedFacilities: append([]string(nil), permittedFacilities...),
		// A brand-new account revokes nothing that came before it, but the
		// watermark starts at creation rather than zero so a credential
		// somehow predating the account is refused too.
		NotValidBefore: now.UTC(),
		CreatedAt:      now.UTC(), UpdatedAt: now.UTC(), Version: 1,
	}, nil
}

// allowedTransitions is the lifecycle. Deactivation is terminal: a returning
// leaver gets a new account, because reusing the old one would silently
// restore whatever access it had when it was closed.
var allowedTransitions = map[AccountStatus][]AccountStatus{
	AccountInvited:     {AccountActive, AccountDeactivated},
	AccountActive:      {AccountSuspended, AccountDeactivated},
	AccountSuspended:   {AccountActive, AccountDeactivated},
	AccountDeactivated: {},
}

// Activate completes the joiner step.
func (a *Account) Activate(now time.Time) error { return a.transition(AccountActive, now) }

// Suspend stops access reversibly and revokes every live session.
func (a *Account) Suspend(now time.Time) error { return a.transition(AccountSuspended, now) }

// Deactivate is the leaver step. Terminal, and revokes every live session.
func (a *Account) Deactivate(now time.Time) error { return a.transition(AccountDeactivated, now) }

func (a *Account) transition(to AccountStatus, now time.Time) error {
	for _, allowed := range allowedTransitions[a.Status] {
		if allowed == to {
			a.Status = to
			a.UpdatedAt = now.UTC()
			a.Version++
			// Any status change revokes. Activating from suspended revokes too:
			// whatever the user held while suspended should not survive the
			// reinstatement, because the reason for the suspension may have
			// been a stolen token.
			a.RevokeSessions(now)
			return nil
		}
	}
	return fmt.Errorf("%w: %s to %s", ErrIllegalTransition, a.Status, to)
}

// ChangeRoles is the mover step.
//
// It revokes, which is the point. A session carries the permissions it was
// minted with, so leaving it alone means a department move takes effect at the
// user's next login — possibly next month, with their old ward's records open
// in a tab.
func (a *Account) ChangeRoles(roles []Role, permittedFacilities []string, now time.Time) error {
	if a.Status == AccountDeactivated {
		return fmt.Errorf("%w: cannot change the roles of a deactivated account", ErrIllegalTransition)
	}
	for _, r := range roles {
		if !KnownRole(r) {
			return fmt.Errorf("%w: unknown role %q", ErrInvalidAccount, r)
		}
	}
	a.Roles = append([]Role(nil), roles...)
	a.PermittedFacilities = append([]string(nil), permittedFacilities...)
	a.UpdatedAt = now.UTC()
	a.Version++
	a.RevokeSessions(now)
	return nil
}

// RevokeSessions moves the watermark, killing every credential issued before
// now.
//
// Idempotent and monotonic: the watermark never moves backwards, so a
// late-arriving or replayed revocation cannot resurrect sessions a later one
// already killed.
func (a *Account) RevokeSessions(now time.Time) {
	if candidate := now.UTC(); candidate.After(a.NotValidBefore) {
		a.NotValidBefore = candidate
	}
}

// CanAuthenticate reports whether a credential may be minted for this account.
func (a Account) CanAuthenticate() error {
	if a.Status != AccountActive {
		return fmt.Errorf("%w: account is %s", ErrAccountNotUsable, a.Status)
	}
	return nil
}

// AuthorizeSession decides whether an already-issued credential is still good.
//
// issuedAt is the credential's own issue time, which every token format
// carries. The comparison is one instant against one instant — cheap enough to
// run on every request, which is what makes revocation actually propagate
// rather than wait for a token to expire on its own.
func (a Account) AuthorizeSession(issuedAt time.Time, now time.Time) error {
	if err := a.CanAuthenticate(); err != nil {
		return err
	}
	// Before-or-equal, not strictly before. A credential minted in the same
	// instant as the revocation is ambiguous, and the safe reading of an
	// ambiguous revocation is that it applies.
	if !issuedAt.UTC().After(a.NotValidBefore) {
		return fmt.Errorf("%w: issued at %s, not valid before %s",
			ErrSessionRevoked, issuedAt.UTC().Format(time.RFC3339Nano),
			a.NotValidBefore.Format(time.RFC3339Nano))
	}
	return nil
}

// Permissions flattens the account's roles.
func (a Account) Permissions() []string { return PermissionsFor(a.Roles) }
