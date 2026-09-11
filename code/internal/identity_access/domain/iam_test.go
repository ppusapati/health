package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/identity_access/domain"
)

// --- Step-up authentication (SRS-IAM-012) ---

func proof(subject, action, method string, obtainedAt time.Time) *domain.StepUpProof {
	return &domain.StepUpProof{
		Reference: "stepup-ref-1", SubjectID: subject, Action: action,
		Method: method, ObtainedAt: obtainedAt,
	}
}

// SRS-IAM-012's verification clause: a high-risk action fails without a
// step-up proof.
func TestHighRiskActionFailsWithoutStepUp(t *testing.T) {
	err := domain.AuthorizeStepUp("security.export.request", "user-1", nil, lcNow)
	if !errors.Is(err, domain.ErrStepUpRequired) {
		t.Fatalf("want ErrStepUpRequired, got %v", err)
	}

	// And an ordinary action does not need one, or every screen would prompt.
	if err := domain.AuthorizeStepUp("organization.facility.read", "user-1", nil, lcNow); err != nil {
		t.Fatalf("a normal action demanded a step-up: %v", err)
	}
}

func TestValidProofAuthorizes(t *testing.T) {
	p := proof("user-1", "security.export.request", "webauthn", lcNow)
	if err := domain.AuthorizeStepUp("security.export.request", "user-1", p,
		lcNow.Add(time.Minute)); err != nil {
		t.Fatalf("a valid proof was refused: %v", err)
	}
}

// The pattern this control exists to prevent: stepping up for something
// innocuous and treating the session as elevated for everything afterwards.
func TestAProofForOneActionDoesNotAuthorizeAnother(t *testing.T) {
	p := proof("user-1", "security.export.request", "webauthn", lcNow)
	err := domain.AuthorizeStepUp("organization.tenant.delete", "user-1", p, lcNow.Add(time.Second))
	if !errors.Is(err, domain.ErrStepUpInvalid) {
		t.Fatalf("a proof for another action authorised a deletion: %v", err)
	}
}

func TestAnotherSubjectsProofIsRefused(t *testing.T) {
	p := proof("user-2", "security.export.request", "webauthn", lcNow)
	err := domain.AuthorizeStepUp("security.export.request", "user-1", p, lcNow.Add(time.Second))
	if !errors.Is(err, domain.ErrStepUpInvalid) {
		t.Fatalf("a borrowed proof was accepted: %v", err)
	}
}

// A proof must not be obtainable early and parked for later in the session.
func TestProofsExpire(t *testing.T) {
	p := proof("user-1", "security.export.request", "webauthn", lcNow)
	if err := domain.AuthorizeStepUp("security.export.request", "user-1", p,
		lcNow.Add(domain.ElevatedProofTTL+time.Second)); !errors.Is(err, domain.ErrStepUpInvalid) {
		t.Fatalf("an expired proof was accepted: %v", err)
	}
}

// There is no legitimate flow in which somebody authenticates, does other
// work, and then deletes a tenant, so the destructive window is shorter.
func TestDestructiveActionsHaveAShorterWindow(t *testing.T) {
	if domain.RiskOf("organization.tenant.delete") != domain.RiskDestructive {
		t.Fatal("tenant deletion is not classified destructive")
	}
	if domain.ProofTTL("organization.tenant.delete") >= domain.ProofTTL("security.export.request") {
		t.Fatal("the destructive window is not shorter than the elevated one")
	}

	p := proof("user-1", "organization.tenant.delete", "webauthn", lcNow)
	// Inside the elevated window but past the destructive one.
	at := lcNow.Add(domain.DestructiveProofTTL + time.Second)
	if at.Sub(lcNow) >= domain.ElevatedProofTTL {
		t.Fatal("the test instant is not inside the elevated window; it proves nothing")
	}
	if err := domain.AuthorizeStepUp("organization.tenant.delete", "user-1", p, at); !errors.Is(err, domain.ErrStepUpInvalid) {
		t.Fatalf("a destructive action accepted a proof past its window: %v", err)
	}
}

// A proof from the future is a clock problem or a forged timestamp; either way
// it cannot be aged, so it cannot be trusted.
func TestAProofFromTheFutureIsRefused(t *testing.T) {
	p := proof("user-1", "security.export.request", "webauthn", lcNow.Add(time.Hour))
	if err := domain.AuthorizeStepUp("security.export.request", "user-1", p, lcNow); !errors.Is(err, domain.ErrStepUpInvalid) {
		t.Fatalf("a future-dated proof was accepted: %v", err)
	}
}

func TestIncompleteProofsAreRefused(t *testing.T) {
	cases := map[string]func(*domain.StepUpProof){
		"no reference": func(p *domain.StepUpProof) { p.Reference = "" },
		// Without the method an incident review cannot tell how strong the
		// control actually was.
		"no method":      func(p *domain.StepUpProof) { p.Method = "" },
		"no obtained-at": func(p *domain.StepUpProof) { p.ObtainedAt = time.Time{} },
	}
	for name, mutate := range cases {
		t.Run(name, func(t *testing.T) {
			p := proof("user-1", "security.export.request", "webauthn", lcNow)
			mutate(p)
			if err := domain.AuthorizeStepUp("security.export.request", "user-1", p,
				lcNow.Add(time.Second)); !errors.Is(err, domain.ErrStepUpInvalid) {
				t.Fatalf("want ErrStepUpInvalid, got %v", err)
			}
		})
	}
}

// The register is explicit rather than derived from a naming convention,
// because a convention silently stops covering an action somebody named
// differently and nobody notices until it is used.
func TestHighRiskRegisterCoversTheObviousActions(t *testing.T) {
	for _, action := range []string{
		"security.export.request", "security.export.download",
		"organization.tenant.delete", "identity.account.deactivate",
		"security.legal_hold.release",
	} {
		if !domain.RequiresStepUp(action) {
			t.Errorf("%s does not require step-up", action)
		}
	}
	// The exported copy is a copy: a caller mutating it must not change what
	// the system requires.
	register := domain.HighRiskActions()
	delete(register, "organization.tenant.delete")
	if !domain.RequiresStepUp("organization.tenant.delete") {
		t.Fatal("the high-risk register is shared mutable state")
	}
}

// --- Risk scoring (SRS-IAM-015) ---

// SRS-IAM-015's verification clause: a configured high-risk event creates an
// alert without blocking emergency workflows unless policy says so. This is
// the case the whole design exists for — a consultant at 03:00 on an
// unfamiliar device is simultaneously the textbook high-risk signal and the
// textbook emergency.
func TestEmergencyLoginAlertsButIsNotBlocked(t *testing.T) {
	signals := []domain.RiskSignal{
		domain.SignalNewDevice, domain.SignalNewLocation,
		domain.SignalUnusualHour, domain.SignalPrivilegedRole,
	}
	// A tenant that has configured blocking aggressively.
	policy := domain.BlockPolicy{BlockAtScore: 30, NeverBlockEmergency: true}

	emergency := domain.AssessRisk(signals, policy, true)
	if emergency.Block {
		t.Fatal("an emergency login was blocked; a clinician is now locked out mid-emergency")
	}
	if !emergency.Alert {
		t.Fatal("the emergency login raised no alert, so the security team never sees it")
	}

	// The same attempt outside an emergency is blocked, which is what the
	// tenant configured.
	ordinary := domain.AssessRisk(signals, policy, false)
	if !ordinary.Block {
		t.Fatal("the configured block policy did nothing")
	}
}

// The default a tenant gets before configuring anything: alert on everything,
// block nothing.
func TestDefaultPolicyNeverBlocks(t *testing.T) {
	signals := []domain.RiskSignal{
		domain.SignalCredentialInBreach, domain.SignalImpossibleTravel,
	}
	a := domain.AssessRisk(signals, domain.DefaultBlockPolicy(), false)
	if a.Block {
		t.Fatal("the default policy blocked a login")
	}
	if !a.Critical {
		t.Fatal("a breached credential plus impossible travel was not critical")
	}
}

// A signal can be decisive on its own regardless of score. A credential known
// to be in a breach corpus is not a statement about the user's habits; it is
// knowledge that the password is public.
func TestASignalCanBlockOnItsOwn(t *testing.T) {
	policy := domain.BlockPolicy{
		BlockSignals:        []domain.RiskSignal{domain.SignalCredentialInBreach},
		NeverBlockEmergency: true,
	}
	a := domain.AssessRisk([]domain.RiskSignal{domain.SignalCredentialInBreach}, policy, false)
	if !a.Block {
		t.Fatal("a breached credential was not blocked despite the policy")
	}
	if a.Reason != domain.ReasonRiskBlocked {
		t.Fatalf("reason %q", a.Reason)
	}
}

// The same signal reported twice is one observation, not twice the risk.
func TestDuplicateSignalsDoNotCompound(t *testing.T) {
	once := domain.AssessRisk([]domain.RiskSignal{domain.SignalNewDevice},
		domain.DefaultBlockPolicy(), false)
	twice := domain.AssessRisk([]domain.RiskSignal{domain.SignalNewDevice, domain.SignalNewDevice},
		domain.DefaultBlockPolicy(), false)
	if once.Score != twice.Score {
		t.Fatalf("a repeated signal scored %d vs %d", twice.Score, once.Score)
	}
}

// The score is capped so a pile-up of weak signals cannot outrank a decisive
// one by arithmetic alone.
func TestScoreIsCapped(t *testing.T) {
	every := []domain.RiskSignal{
		domain.SignalNewDevice, domain.SignalNewLocation, domain.SignalImpossibleTravel,
		domain.SignalUnusualHour, domain.SignalManyFailedAttempts, domain.SignalDormantAccount,
		domain.SignalCredentialInBreach, domain.SignalConcurrentSessions,
		domain.SignalPrivilegedRole, domain.SignalDisabledMFA,
	}
	a := domain.AssessRisk(every, domain.DefaultBlockPolicy(), false)
	if a.Score != domain.MaxRiskScore {
		t.Fatalf("score %d, want the cap %d", a.Score, domain.MaxRiskScore)
	}
}

// In a hospital most of the day is an unusual hour for somebody. Weighting it
// highly would make night shift permanently suspicious.
func TestUnusualHourAloneIsNotAnAlert(t *testing.T) {
	a := domain.AssessRisk([]domain.RiskSignal{domain.SignalUnusualHour},
		domain.DefaultBlockPolicy(), false)
	if a.Alert {
		t.Fatal("a night-shift login alerted on the hour alone")
	}
	if a.Reason != domain.ReasonRiskAccepted {
		t.Fatalf("reason %q", a.Reason)
	}
}

func TestAlertIsRaisedOnlyWhenNeeded(t *testing.T) {
	quiet := domain.AssessRisk([]domain.RiskSignal{domain.SignalUnusualHour},
		domain.DefaultBlockPolicy(), false)
	if _, raised := domain.NewAlert(quiet, "tenant-a", "user-1", lcNow); raised {
		t.Fatal("a low-risk login raised an alert")
	}

	loud := domain.AssessRisk([]domain.RiskSignal{
		domain.SignalImpossibleTravel, domain.SignalNewDevice,
	}, domain.DefaultBlockPolicy(), false)
	alert, raised := domain.NewAlert(loud, "tenant-a", "user-1", lcNow)
	if !raised {
		t.Fatal("a high-risk login raised no alert")
	}
	if alert.Score != loud.Score || alert.SubjectID != "user-1" {
		t.Fatalf("the alert does not describe the assessment: %+v", alert)
	}
	if alert.Summary == "" {
		t.Fatal("the alert has no human summary")
	}
}

// --- Federation (SRS-IAM-009) ---

func federation(t *testing.T) domain.Federation {
	t.Helper()
	f, err := domain.NewFederation("fed-1", "tenant-a", "https://login.acme.example",
		[]string{"acme.example"},
		[]domain.RoleMapping{
			{Claim: "groups", Value: "hospital-admins",
				Roles: []domain.Role{domain.RoleTenantAdmin}, PermittedFacilities: []string{"fac-1"}},
			{Claim: "groups", Value: "clinicians",
				Roles: []domain.Role{domain.RoleFacilityViewer}, PermittedFacilities: []string{"fac-1", "fac-2"}},
		},
		nil, lcNow)
	if err != nil {
		t.Fatalf("NewFederation: %v", err)
	}
	return f
}

// SRS-IAM-009's verification clause: a federated user maps to a tenant role
// without duplicate local credentials. The account that comes back holds no
// secret at all — there is nowhere to put one.
func TestFederatedUserMapsToRolesWithNoLocalCredential(t *testing.T) {
	f := federation(t)
	account, err := f.Resolve(domain.FederatedClaims{
		Issuer: "https://login.acme.example", Subject: "auth0|12345",
		Email: "priya@acme.example", Name: "Priya Ramaswamy",
		ExpiresAt: lcNow.Add(time.Hour),
		Claims:    map[string][]string{"groups": {"clinicians"}},
	}, lcNow)
	if err != nil {
		t.Fatalf("Resolve: %v", err)
	}

	if account.Status != domain.AccountActive {
		t.Fatalf("a federated user arrived as %s; a second local acceptance step "+
			"is the duplicate-identity problem in another form", account.Status)
	}
	if account.SubjectID != "auth0|12345" {
		t.Fatalf("the external subject was not kept as the identity: %q", account.SubjectID)
	}
	if len(account.Roles) != 1 || account.Roles[0] != domain.RoleFacilityViewer {
		t.Fatalf("roles %v, want the mapped role", account.Roles)
	}
	if len(account.PermittedFacilities) != 2 {
		t.Fatalf("facilities %v", account.PermittedFacilities)
	}
	if account.IdentityProvider != "oidc:https://login.acme.example" {
		t.Fatalf("identity provider %q; a withdrawn federation could not be traced",
			account.IdentityProvider)
	}
}

// Repeated sign-ins must resolve to the same account rather than creating one
// per login.
func TestRepeatedSignInsResolveToOneAccount(t *testing.T) {
	f := federation(t)
	claims := domain.FederatedClaims{
		Issuer: "https://login.acme.example", Subject: "auth0|12345",
		ExpiresAt: lcNow.Add(time.Hour),
		Claims:    map[string][]string{"groups": {"clinicians"}},
	}
	first, err := f.Resolve(claims, lcNow)
	if err != nil {
		t.Fatalf("Resolve: %v", err)
	}

	// A later sign-in presents a fresh token, as a real one would.
	later := claims
	later.ExpiresAt = lcNow.Add(3 * time.Hour)
	second, err := f.Resolve(later, lcNow.Add(2*time.Hour))
	if err != nil {
		t.Fatalf("Resolve: %v", err)
	}
	if first.ID != second.ID {
		t.Fatalf("two sign-ins produced accounts %q and %q", first.ID, second.ID)
	}
}

// An exact issuer comparison. A prefix or suffix check here is the classic way
// an issuer is bypassed by a lookalike domain.
func TestIssuerMustMatchExactly(t *testing.T) {
	f := federation(t)
	for _, issuer := range []string{
		"https://login.acme.example.attacker.test",
		"https://login.acme.example/",
		"https://LOGIN.acme.example",
		"",
	} {
		_, err := f.Resolve(domain.FederatedClaims{
			Issuer: issuer, Subject: "auth0|12345", ExpiresAt: lcNow.Add(time.Hour),
		}, lcNow)
		if !errors.Is(err, domain.ErrIssuerMismatch) {
			t.Errorf("issuer %q was accepted: %v", issuer, err)
		}
	}
}

// An unmapped user gets an account that can sign in and do nothing — visible
// to the user and to support, unlike a silent denial, and far better than a
// guessed role.
func TestAnUnmappedUserGetsNoPermissions(t *testing.T) {
	f := federation(t)
	account, err := f.Resolve(domain.FederatedClaims{
		Issuer: "https://login.acme.example", Subject: "auth0|99999",
		ExpiresAt: lcNow.Add(time.Hour),
		Claims:    map[string][]string{"groups": {"contractors"}},
	}, lcNow)
	if err != nil {
		t.Fatalf("Resolve: %v", err)
	}
	if len(account.Roles) != 0 {
		t.Fatalf("an unmapped user was granted %v", account.Roles)
	}
	if len(account.Permissions()) != 0 {
		t.Fatalf("an unmapped user holds permissions: %v", account.Permissions())
	}
}

func TestExpiredAndDisabledFederationsAreRefused(t *testing.T) {
	f := federation(t)

	_, err := f.Resolve(domain.FederatedClaims{
		Issuer: "https://login.acme.example", Subject: "auth0|12345",
		ExpiresAt: lcNow.Add(-time.Minute),
	}, lcNow)
	if !errors.Is(err, domain.ErrInvalidFederation) {
		t.Errorf("an expired token was accepted: %v", err)
	}

	f.Enabled = false
	if _, err := f.Resolve(domain.FederatedClaims{
		Issuer: "https://login.acme.example", Subject: "auth0|12345",
		ExpiresAt: lcNow.Add(time.Hour),
	}, lcNow); !errors.Is(err, domain.ErrFederationDisabled) {
		t.Errorf("a disabled federation resolved: %v", err)
	}
}

func TestFederationValidation(t *testing.T) {
	cases := map[string]func() error{
		// An issuer reachable over plaintext is one an attacker on the path
		// can impersonate, and the whole federation rests on it.
		"plaintext issuer": func() error {
			_, err := domain.NewFederation("f", "t", "http://login.acme.example", nil, nil, nil, lcNow)
			return err
		},
		"mapping with no roles": func() error {
			_, err := domain.NewFederation("f", "t", "https://login.acme.example", nil,
				[]domain.RoleMapping{{Claim: "groups", Value: "x"}}, nil, lcNow)
			return err
		},
		"unknown role in mapping": func() error {
			_, err := domain.NewFederation("f", "t", "https://login.acme.example", nil,
				[]domain.RoleMapping{{Claim: "groups", Value: "x",
					Roles: []domain.Role{domain.Role("superuser")}}}, nil, lcNow)
			return err
		},
	}
	for name, build := range cases {
		t.Run(name, func(t *testing.T) {
			if err := build(); !errors.Is(err, domain.ErrInvalidFederation) {
				t.Fatalf("want ErrInvalidFederation, got %v", err)
			}
		})
	}
}

// --- Workload identity (SRS-IAM-007) ---

const fingerprint = "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"

// SRS-IAM-007's verification clause: no static shared service passwords. The
// type has no field for one, so a service cannot be given a password by a
// change that merely looked convenient.
func TestWorkloadIdentityCarriesNoSecret(t *testing.T) {
	w, err := domain.NewWorkloadIdentity("spiffe://healthcare/ns/clinical/sa/scheduler",
		fingerprint, []string{"scheduling.read"}, lcNow, lcNow.Add(time.Hour))
	if err != nil {
		t.Fatalf("NewWorkloadIdentity: %v", err)
	}
	if err := w.Valid(lcNow.Add(time.Minute)); err != nil {
		t.Fatalf("a live workload credential was refused: %v", err)
	}
}

// A workload credential with no expiry is a static secret wearing a
// certificate's clothes, which is the thing the requirement rules out.
func TestWorkloadCredentialsMustExpireAndBeShortLived(t *testing.T) {
	if _, err := domain.NewWorkloadIdentity("spiffe://healthcare/ns/a/sa/b",
		fingerprint, nil, lcNow, time.Time{}); !errors.Is(err, domain.ErrInvalidWorkload) {
		t.Fatal("a credential with no expiry was accepted")
	}

	long, err := domain.NewWorkloadIdentity("spiffe://healthcare/ns/a/sa/b",
		fingerprint, nil, lcNow, lcNow.Add(domain.MaxWorkloadCredentialLifetime+time.Hour))
	if err != nil {
		t.Fatalf("NewWorkloadIdentity: %v", err)
	}
	if err := long.Valid(lcNow.Add(time.Minute)); !errors.Is(err, domain.ErrInvalidWorkload) {
		t.Fatalf("an over-long workload credential was accepted: %v", err)
	}
}

func TestWorkloadIdentityValidation(t *testing.T) {
	cases := map[string]func() error{
		"not a spiffe id": func() error {
			_, err := domain.NewWorkloadIdentity("scheduler", fingerprint, nil, lcNow, lcNow.Add(time.Hour))
			return err
		},
		"short fingerprint": func() error {
			_, err := domain.NewWorkloadIdentity("spiffe://healthcare/ns/a/sa/b", "abc123",
				nil, lcNow, lcNow.Add(time.Hour))
			return err
		},
		"expiry before issue": func() error {
			_, err := domain.NewWorkloadIdentity("spiffe://healthcare/ns/a/sa/b", fingerprint,
				nil, lcNow, lcNow.Add(-time.Hour))
			return err
		},
	}
	for name, build := range cases {
		t.Run(name, func(t *testing.T) {
			if err := build(); !errors.Is(err, domain.ErrInvalidWorkload) {
				t.Fatalf("want ErrInvalidWorkload, got %v", err)
			}
		})
	}
}

func TestExpiredWorkloadCredentialIsRefused(t *testing.T) {
	w, err := domain.NewWorkloadIdentity("spiffe://healthcare/ns/a/sa/b", fingerprint,
		nil, lcNow, lcNow.Add(time.Hour))
	if err != nil {
		t.Fatalf("NewWorkloadIdentity: %v", err)
	}
	if err := w.Valid(lcNow.Add(2 * time.Hour)); !errors.Is(err, domain.ErrInvalidWorkload) {
		t.Fatalf("an expired credential was accepted: %v", err)
	}
	if err := w.Valid(lcNow.Add(-time.Minute)); !errors.Is(err, domain.ErrInvalidWorkload) {
		t.Fatalf("a not-yet-valid credential was accepted: %v", err)
	}
}

// A federated account is created *by* the sign-in that resolves it, so the
// token necessarily predates the account. A watermark set to the moment of
// resolution would refuse every first sign-in with the very credential that
// produced it — which is what happened before this was pinned.
func TestFirstFederatedSignInIsNotRefusedByItsOwnToken(t *testing.T) {
	f := federation(t)
	issuedAt := lcNow.Add(-time.Minute)

	account, err := f.Resolve(domain.FederatedClaims{
		Issuer: "https://login.acme.example", Subject: "auth0|12345",
		IssuedAt: issuedAt, ExpiresAt: lcNow.Add(time.Hour),
		Claims: map[string][]string{"groups": {"clinicians"}},
	}, lcNow)
	if err != nil {
		t.Fatalf("Resolve: %v", err)
	}

	if err := account.AuthorizeSession(issuedAt, lcNow); err != nil {
		t.Fatalf("the credential that created the account was refused by it: %v", err)
	}
}

// And a revocation applied afterwards still holds, so the fix above did not
// disable the mechanism it works within.
func TestRevocationStillHoldsOnAFederatedAccount(t *testing.T) {
	f := federation(t)
	issuedAt := lcNow.Add(-time.Minute)

	account, err := f.Resolve(domain.FederatedClaims{
		Issuer: "https://login.acme.example", Subject: "auth0|12345",
		IssuedAt: issuedAt, ExpiresAt: lcNow.Add(time.Hour),
		Claims: map[string][]string{"groups": {"clinicians"}},
	}, lcNow)
	if err != nil {
		t.Fatalf("Resolve: %v", err)
	}

	account.RevokeSessions(lcNow)
	if err := account.AuthorizeSession(issuedAt, lcNow.Add(time.Minute)); !errors.Is(err, domain.ErrSessionRevoked) {
		t.Fatalf("want ErrSessionRevoked after revoking, got %v", err)
	}
}

// A federated sign-in with no issued-at has nothing to anchor a watermark to.
// Zero rather than `now`: an account whose watermark nobody set should revoke
// nothing, and a store moves it forward the first time somebody actually does.
func TestAFederatedAccountWithNoIssuedAtRevokesNothing(t *testing.T) {
	f := federation(t)

	account, err := f.Resolve(domain.FederatedClaims{
		Issuer: "https://login.acme.example", Subject: "auth0|12345",
		ExpiresAt: lcNow.Add(time.Hour),
		Claims:    map[string][]string{"groups": {"clinicians"}},
	}, lcNow)
	if err != nil {
		t.Fatalf("Resolve: %v", err)
	}
	if !account.NotValidBefore.IsZero() {
		t.Fatalf("watermark is %s, want zero", account.NotValidBefore)
	}
	if err := account.AuthorizeSession(lcNow.Add(-time.Hour), lcNow); err != nil {
		t.Fatalf("an unanchored account refused a session: %v", err)
	}
}
