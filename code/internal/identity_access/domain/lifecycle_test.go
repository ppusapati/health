package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/identity_access/domain"
)

var lcNow = time.Date(2026, 9, 11, 10, 0, 0, 0, time.UTC)

func account(t *testing.T) domain.Account {
	t.Helper()
	a, err := domain.NewAccount("acc-1", "tenant-a", "sub-1", "oidc:acme", "Dr Singh",
		[]domain.Role{domain.RoleFacilityViewer}, []string{"fac-1"}, lcNow)
	if err != nil {
		t.Fatalf("NewAccount: %v", err)
	}
	return a
}

func activeAccount(t *testing.T) domain.Account {
	t.Helper()
	a := account(t)
	if err := a.Activate(lcNow); err != nil {
		t.Fatalf("Activate: %v", err)
	}
	return a
}

// An account created directly active is an account nobody accepted, and a bulk
// user import producing live credentials would be a way to manufacture access.
func TestAccountsStartInvited(t *testing.T) {
	a := account(t)
	if a.Status != domain.AccountInvited {
		t.Fatalf("a new account is %s", a.Status)
	}
	if err := a.CanAuthenticate(); !errors.Is(err, domain.ErrAccountNotUsable) {
		t.Fatalf("an invited account could authenticate: %v", err)
	}
}

// SRS-IAM-006's verification clause: a disabled user cannot use an existing
// session. The credential was issued while the account was good and is
// nowhere near its own expiry.
func TestDisabledUserCannotUseAnExistingSession(t *testing.T) {
	a := activeAccount(t)

	issuedAt := lcNow.Add(time.Minute)
	if err := a.AuthorizeSession(issuedAt, lcNow.Add(2*time.Minute)); err != nil {
		t.Fatalf("a valid session was refused: %v", err)
	}

	// The administrator clicks disable.
	if err := a.Deactivate(lcNow.Add(5 * time.Minute)); err != nil {
		t.Fatalf("Deactivate: %v", err)
	}

	// The same credential, still well inside its own lifetime.
	err := a.AuthorizeSession(issuedAt, lcNow.Add(6*time.Minute))
	if !errors.Is(err, domain.ErrAccountNotUsable) {
		t.Fatalf("want ErrAccountNotUsable, got %v", err)
	}
}

// Suspension is the reversible case and must revoke just as hard.
func TestSuspensionRevokesLiveSessions(t *testing.T) {
	a := activeAccount(t)
	issuedAt := lcNow.Add(time.Minute)

	if err := a.Suspend(lcNow.Add(5 * time.Minute)); err != nil {
		t.Fatalf("Suspend: %v", err)
	}
	if err := a.AuthorizeSession(issuedAt, lcNow.Add(6*time.Minute)); err == nil {
		t.Fatal("a suspended account's existing session still worked")
	}

	// Reinstating does not resurrect the old credential: the reason for the
	// suspension may have been a stolen token.
	if err := a.Activate(lcNow.Add(10 * time.Minute)); err != nil {
		t.Fatalf("Activate: %v", err)
	}
	if err := a.AuthorizeSession(issuedAt, lcNow.Add(11*time.Minute)); !errors.Is(err, domain.ErrSessionRevoked) {
		t.Fatalf("reinstatement resurrected a pre-suspension session: %v", err)
	}

	// A credential minted after reinstatement works.
	if err := a.AuthorizeSession(lcNow.Add(10*time.Minute+time.Second), lcNow.Add(11*time.Minute)); err != nil {
		t.Fatalf("a freshly issued session was refused: %v", err)
	}
}

// The mover case people forget: a department change must revoke, or the move
// takes effect at the user's next login, possibly next month, with their old
// ward's records open in a tab.
func TestRoleChangeRevokesLiveSessions(t *testing.T) {
	a := activeAccount(t)
	issuedAt := lcNow.Add(time.Minute)

	if err := a.ChangeRoles([]domain.Role{domain.RoleAuditor}, []string{"fac-2"},
		lcNow.Add(5*time.Minute)); err != nil {
		t.Fatalf("ChangeRoles: %v", err)
	}

	if err := a.AuthorizeSession(issuedAt, lcNow.Add(6*time.Minute)); !errors.Is(err, domain.ErrSessionRevoked) {
		t.Fatalf("a session minted before the move still worked: %v", err)
	}
	// The account itself is fine; only the old credential is dead.
	if err := a.CanAuthenticate(); err != nil {
		t.Fatalf("the move disabled the account: %v", err)
	}
	if err := a.AuthorizeSession(lcNow.Add(5*time.Minute+time.Second), lcNow.Add(6*time.Minute)); err != nil {
		t.Fatalf("a session minted after the move was refused: %v", err)
	}
}

// The watermark never moves backwards, so a replayed or late-arriving
// revocation cannot resurrect sessions a later one already killed.
func TestRevocationIsMonotonic(t *testing.T) {
	a := activeAccount(t)

	a.RevokeSessions(lcNow.Add(10 * time.Minute))
	watermark := a.NotValidBefore

	a.RevokeSessions(lcNow.Add(2 * time.Minute)) // an older revocation arrives late
	if !a.NotValidBefore.Equal(watermark) {
		t.Fatalf("the watermark moved backwards from %s to %s", watermark, a.NotValidBefore)
	}

	if err := a.AuthorizeSession(lcNow.Add(5*time.Minute), lcNow.Add(11*time.Minute)); err == nil {
		t.Fatal("a session killed by the later revocation was resurrected")
	}
}

// A credential minted in the same instant as the revocation is ambiguous, and
// the safe reading of an ambiguous revocation is that it applies.
func TestACredentialIssuedAtTheRevocationInstantIsRefused(t *testing.T) {
	a := activeAccount(t)
	instant := lcNow.Add(5 * time.Minute)

	a.RevokeSessions(instant)
	if err := a.AuthorizeSession(instant, instant.Add(time.Second)); !errors.Is(err, domain.ErrSessionRevoked) {
		t.Fatalf("a credential issued at the revocation instant was accepted: %v", err)
	}
}

// Deactivation is terminal. A returning leaver gets a new account, because
// reusing the old one would silently restore whatever access it had when it
// was closed.
func TestDeactivationIsTerminal(t *testing.T) {
	a := activeAccount(t)
	if err := a.Deactivate(lcNow.Add(time.Minute)); err != nil {
		t.Fatalf("Deactivate: %v", err)
	}
	for name, attempt := range map[string]func() error{
		"reactivate": func() error { return a.Activate(lcNow.Add(2 * time.Minute)) },
		"suspend":    func() error { return a.Suspend(lcNow.Add(2 * time.Minute)) },
		"change roles": func() error {
			return a.ChangeRoles([]domain.Role{domain.RoleAuditor}, nil, lcNow.Add(2*time.Minute))
		},
	} {
		t.Run(name, func(t *testing.T) {
			if err := attempt(); !errors.Is(err, domain.ErrIllegalTransition) {
				t.Fatalf("want ErrIllegalTransition, got %v", err)
			}
		})
	}
}

func TestAccountValidation(t *testing.T) {
	cases := map[string]func() error{
		"no subject": func() error {
			_, err := domain.NewAccount("a", "t", "", "oidc:acme", "Name", nil, nil, lcNow)
			return err
		},
		// Without this a federation being withdrawn cannot be traced to the
		// accounts that depended on it.
		"no identity provider": func() error {
			_, err := domain.NewAccount("a", "t", "s", "", "Name", nil, nil, lcNow)
			return err
		},
		"unknown role": func() error {
			_, err := domain.NewAccount("a", "t", "s", "oidc:acme", "Name",
				[]domain.Role{domain.Role("superuser")}, nil, lcNow)
			return err
		},
	}
	for name, build := range cases {
		t.Run(name, func(t *testing.T) {
			if err := build(); !errors.Is(err, domain.ErrInvalidAccount) {
				t.Fatalf("want ErrInvalidAccount, got %v", err)
			}
		})
	}
}

// The account's roles are its own; a caller mutating the slice it was given
// must not change what the account grants.
func TestRolesAreCopiedNotShared(t *testing.T) {
	roles := []domain.Role{domain.RoleFacilityViewer}
	a, err := domain.NewAccount("a", "t", "s", "oidc:acme", "Name", roles, []string{"fac-1"}, lcNow)
	if err != nil {
		t.Fatalf("NewAccount: %v", err)
	}
	roles[0] = domain.RolePlatformOperator
	if a.Roles[0] != domain.RoleFacilityViewer {
		t.Fatal("mutating the caller's slice changed the account's roles")
	}
}
