package domain_test

import (
	"errors"
	"testing"

	"github.com/ppusapati/health/code/internal/empi/domain"
)

// SRS-EMPI-002 and SRS-EMPI-011. Every identifier a human sees is a row with
// its own lifecycle, and none of them is the patient's key.

func newIdentifier(t *testing.T, value string) domain.Identifier {
	t.Helper()
	i, err := domain.NewIdentifier("id-1", "patient-1", domain.IdentifierMRN,
		"facility-1", value, "Apollo Main", "registration", at)
	if err != nil {
		t.Fatalf("NewIdentifier: %v", err)
	}
	return i
}

// Without a namespace, two facilities both issuing "MRN 1001" are one value —
// and the index would resolve a search to whichever patient it found first.
func TestAnIdentifierNeedsASystem(t *testing.T) {
	_, err := domain.NewIdentifier("id-1", "patient-1", domain.IdentifierMRN,
		"", "1001", "Apollo", "registration", at)
	if !errors.Is(err, domain.ErrInvalidPatient) {
		t.Fatalf("NewIdentifier with no system = %v, want a refusal", err)
	}
}

// SRS-EMPI-011 requires link history and source to be retained. A link with no
// source cannot be unwound with any confidence about what claimed it.
func TestAnIdentifierNeedsASource(t *testing.T) {
	_, err := domain.NewIdentifier("id-1", "patient-1", domain.IdentifierNationalHealth,
		"abdm", "11-1111-1111-1111", "ABDM", "", at)
	if !errors.Is(err, domain.ErrInvalidPatient) {
		t.Fatalf("NewIdentifier with no source = %v, want a refusal", err)
	}
}

func TestAnUnknownIdentifierTypeIsRefused(t *testing.T) {
	_, err := domain.NewIdentifier("id-1", "patient-1", domain.IdentifierType("passport"),
		"gov", "X1234", "Authority", "registration", at)
	if !errors.Is(err, domain.ErrInvalidPatient) {
		t.Fatalf("NewIdentifier = %v, want a refusal", err)
	}
}

// The single distinction that justifies two statuses rather than one
// "inactive": a superseded MRN is on a discharge summary printed last week and
// a clerk typing it in must reach this patient. A revoked one belongs to
// somebody else and must not.
func TestSupersededResolvesAndRevokedDoesNot(t *testing.T) {
	superseded := newIdentifier(t, "MRN-0001")
	if err := superseded.Supersede("id-2", "merged into MRN-0002", at); err != nil {
		t.Fatalf("Supersede: %v", err)
	}
	if !superseded.ResolvesToPatient() {
		t.Fatal("a superseded identifier stopped resolving; documents already printed quote it")
	}

	revoked := newIdentifier(t, "MRN-0003")
	if err := revoked.Revoke("entered against the wrong patient", at); err != nil {
		t.Fatalf("Revoke: %v", err)
	}
	if revoked.ResolvesToPatient() {
		t.Fatal("a revoked identifier still resolves to this patient")
	}
}

// Both paths record when the identifier left active use, because "what did
// this patient's wristband say in March" needs an interval rather than a flag.
func TestLeavingActiveUseRecordsAnInterval(t *testing.T) {
	for name, retire := range map[string]func(*domain.Identifier) error{
		"supersede": func(i *domain.Identifier) error { return i.Supersede("id-2", "merge", at) },
		"revoke":    func(i *domain.Identifier) error { return i.Revoke("wrong patient", at) },
	} {
		t.Run(name, func(t *testing.T) {
			i := newIdentifier(t, "MRN-0001")
			i.Primary = true

			if err := retire(&i); err != nil {
				t.Fatalf("%s: %v", name, err)
			}
			if i.UnlinkedAt == nil {
				t.Fatal("no unlink time was recorded")
			}
			if i.Primary {
				t.Fatal("a retired identifier is still flagged primary; a banner would show it")
			}
			if i.Reason == "" {
				t.Fatal("no reason was recorded")
			}
		})
	}
}

func TestRetiringAnIdentifierRequiresAReason(t *testing.T) {
	i := newIdentifier(t, "MRN-0001")
	if err := i.Supersede("id-2", "   ", at); !errors.Is(err, domain.ErrInvalidPatient) {
		t.Fatalf("Supersede with no reason = %v, want a refusal", err)
	}
	if err := i.Revoke("", at); !errors.Is(err, domain.ErrInvalidPatient) {
		t.Fatalf("Revoke with no reason = %v, want a refusal", err)
	}
}

func TestSupersedingTwiceIsRefused(t *testing.T) {
	i := newIdentifier(t, "MRN-0001")
	if err := i.Supersede("id-2", "merge", at); err != nil {
		t.Fatalf("Supersede: %v", err)
	}
	if err := i.Supersede("id-3", "again", at); !errors.Is(err, domain.ErrInvalidPatient) {
		t.Fatalf("a second supersede was accepted: %v", err)
	}
}

// Revoking twice is idempotent rather than an error: a retry after a lost
// response must not fail, and the second call changes nothing.
func TestRevokingTwiceIsIdempotent(t *testing.T) {
	i := newIdentifier(t, "MRN-0001")
	if err := i.Revoke("wrong patient", at); err != nil {
		t.Fatalf("Revoke: %v", err)
	}
	first := i.Reason
	if err := i.Revoke("a different reason", at); err != nil {
		t.Fatalf("second Revoke: %v", err)
	}
	if i.Reason != first {
		t.Fatalf("the second revoke rewrote the reason to %q", i.Reason)
	}
}

// Showing no MRN on a wristband is worse than showing one that is merely not
// flagged, which is why the fallback exists.
func TestPrimaryMRNFallsBackToAnyActiveOne(t *testing.T) {
	set := domain.IdentifierSet{
		{Type: domain.IdentifierMRN, Status: domain.IdentifierSuperseded, Value: "OLD", Primary: false},
		{Type: domain.IdentifierMRN, Status: domain.IdentifierActive, Value: "NEW", Primary: false},
		{Type: domain.IdentifierNationalHealth, Status: domain.IdentifierActive, Value: "ABHA"},
	}

	mrn, ok := set.PrimaryMRN()
	if !ok {
		t.Fatal("no MRN was found although one is active")
	}
	if mrn.Value != "NEW" {
		t.Fatalf("PrimaryMRN = %q, want the active one", mrn.Value)
	}

	flagged := domain.IdentifierSet{
		{Type: domain.IdentifierMRN, Status: domain.IdentifierActive, Value: "A", Primary: false},
		{Type: domain.IdentifierMRN, Status: domain.IdentifierActive, Value: "B", Primary: true},
	}
	if mrn, _ := flagged.PrimaryMRN(); mrn.Value != "B" {
		t.Fatalf("the flagged primary was not preferred: %q", mrn.Value)
	}
}

func TestPrimaryMRNIsAbsentWhenNoneIsActive(t *testing.T) {
	set := domain.IdentifierSet{
		{Type: domain.IdentifierMRN, Status: domain.IdentifierRevoked, Value: "BAD"},
	}
	if _, ok := set.PrimaryMRN(); ok {
		t.Fatal("a revoked MRN was offered as the primary")
	}
}

// A pasted document must not become an identifier value.
func TestAnOverlongIdentifierValueIsRefused(t *testing.T) {
	long := make([]byte, domain.MaxIdentifierValueLength+1)
	for i := range long {
		long[i] = 'X'
	}
	_, err := domain.NewIdentifier("id-1", "patient-1", domain.IdentifierExternal,
		"legacy", string(long), "Legacy", "import", at)
	if !errors.Is(err, domain.ErrInvalidPatient) {
		t.Fatalf("NewIdentifier = %v, want a refusal", err)
	}
}
