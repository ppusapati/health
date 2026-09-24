package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/nursing/domain"
)

func authorization(from time.Time, hours int) domain.RestraintAuthorization {
	return domain.RestraintAuthorization{
		AuthorizedBy: "doctor-1", AuthorizedAt: from,
		ExpiresAt:  from.Add(time.Duration(hours) * time.Hour),
		Indication: "pulling at the endotracheal tube; risk of self-extubation",
	}
}

func restraint(t *testing.T) *domain.Restraint {
	t.Helper()
	r, err := domain.NewRestraint("restraint-1", "tenant-1",
		domain.NewRestraintInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			Kind: domain.RestraintPhysical, Description: "bilateral soft wrist limiters",
			Authorization: authorization(at(9, 0), 4),
			StartedAt:     at(9, 5), MonitorEvery: 15 * time.Minute,
		}, "nurse-1", at(9, 10))
	if err != nil {
		t.Fatalf("NewRestraint: %v", err)
	}
	return r
}

// SRS-NUR-013: an expired authorization raises an alert. It does not free the
// patient.
func TestAnExpiredAuthorizationAlertsWithoutEndingTheRestraint(t *testing.T) {
	r := restraint(t)

	if r.AuthorizationExpired(at(12, 0)) {
		t.Fatal("a four-hour authorization is expired after three hours")
	}
	if !r.AuthorizationExpired(at(14, 0)) {
		t.Fatal("an authorization that ran out at 13:00 is not reported expired")
	}
	// The patient is still restrained. A system that "removed" the restraint
	// at expiry would show a patient free while they were tied to a bed.
	if !r.Active() {
		t.Fatal("the restraint ended itself when its authorization lapsed")
	}
}

// A restraint authorization with no expiry is the failure the requirement
// exists to prevent.
func TestARestraintAuthorizationMustExpire(t *testing.T) {
	a := authorization(at(9, 0), 4)
	a.ExpiresAt = time.Time{}

	_, err := domain.NewRestraint("restraint-1", "tenant-1",
		domain.NewRestraintInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			Kind: domain.RestraintPhysical, Description: "soft wrist limiters",
			Authorization: a, StartedAt: at(9, 5), MonitorEvery: 15 * time.Minute,
		}, "nurse-1", at(9, 10))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("an open-ended restraint authorization was accepted: %v", err)
	}
}

// The ceiling stops an authorization written once on admission running for the
// whole stay.
func TestARestraintAuthorizationCannotRunPastTheCeiling(t *testing.T) {
	_, err := domain.NewRestraint("restraint-1", "tenant-1",
		domain.NewRestraintInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			Kind: domain.RestraintPhysical, Description: "soft wrist limiters",
			Authorization: authorization(at(9, 0), 48),
			StartedAt:     at(9, 5), MonitorEvery: 15 * time.Minute,
		}, "nurse-1", at(9, 10))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a forty-eight-hour restraint authorization was accepted: %v", err)
	}
}

// "Agitated" is not an indication, and a blank field is how a restraint
// becomes routine.
func TestARestraintNeedsAnIndicationAndANamedAuthoriser(t *testing.T) {
	noIndication := authorization(at(9, 0), 4)
	noIndication.Indication = ""
	noAuthoriser := authorization(at(9, 0), 4)
	noAuthoriser.AuthorizedBy = ""

	for name, a := range map[string]domain.RestraintAuthorization{
		"no indication": noIndication, "no authoriser": noAuthoriser,
	} {
		_, err := domain.NewRestraint("restraint-1", "tenant-1",
			domain.NewRestraintInput{
				PatientID: "patient-1", EncounterID: "encounter-1",
				Kind: domain.RestraintPhysical, Description: "soft wrist limiters",
				Authorization: a, StartedAt: at(9, 5),
				MonitorEvery: 15 * time.Minute,
			}, "nurse-1", at(9, 10))
		if !errors.Is(err, domain.ErrInvalidNursingRecord) {
			t.Fatalf("a restraint with %s was accepted: %v", name, err)
		}
	}
}

// SRS-NUR-013: renewal is appended, because how many times a restraint has
// been renewed is the number a review board asks for.
func TestRenewingARestraintKeepsTheEarlierAuthorizations(t *testing.T) {
	r := restraint(t)
	if err := r.Renew(authorization(at(13, 0), 4), at(13, 0)); err != nil {
		t.Fatalf("Renew: %v", err)
	}
	if len(r.Renewals) != 1 {
		t.Fatalf("renewals is %d, want 1", len(r.Renewals))
	}
	if !r.Authorization.ExpiresAt.Equal(at(13, 0)) {
		t.Fatal("the original authorization was overwritten by the renewal")
	}
	if r.AuthorizationExpired(at(14, 0)) {
		t.Fatal("the renewal did not extend the authorization")
	}
}

func TestARenewalMustExtendTheAuthorization(t *testing.T) {
	r := restraint(t)
	if err := r.Renew(authorization(at(10, 0), 2), at(10, 0)); !errors.Is(
		err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a renewal that shortens the authorization was accepted: %v", err)
	}
}

// A check that records observations but never asks whether the restraint is
// still needed is a check that keeps patients restrained.
func TestARestraintCheckMustSayWhyTheRestraintIsStillNeeded(t *testing.T) {
	r := restraint(t)
	err := r.Check(domain.RestraintCheck{
		ID: "check-1", ObservedAt: at(9, 20), ObservedBy: "nurse-1",
		Findings: "circulation intact, skin unmarked",
	}, at(9, 21))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a check with no continuation reason was accepted: %v", err)
	}
}

func TestARestrainedPatientNotCheckedInTimeIsOverdue(t *testing.T) {
	r := restraint(t)
	if r.MonitoringOverdue(at(9, 15)) {
		t.Fatal("a restraint started at 09:05 is overdue at 09:15")
	}
	if !r.MonitoringOverdue(at(9, 30)) {
		t.Fatal("a fifteen-minute check is not overdue twenty-five minutes in")
	}

	if err := r.Check(domain.RestraintCheck{
		ID: "check-1", ObservedAt: at(9, 30), ObservedBy: "nurse-1",
		Findings:        "circulation intact, skin unmarked",
		ContinuedReason: "still attempting to reach the tube",
	}, at(9, 31)); err != nil {
		t.Fatalf("Check: %v", err)
	}
	if r.MonitoringOverdue(at(9, 40)) {
		t.Fatal("a check ten minutes ago leaves monitoring overdue")
	}
}

func TestADiscontinuedRestraintTakesNoMoreChecks(t *testing.T) {
	r := restraint(t)
	if err := r.Discontinue(at(11, 0), "settled; tube secured", "nurse-1",
		at(11, 5)); err != nil {
		t.Fatalf("Discontinue: %v", err)
	}
	if r.Active() {
		t.Fatal("a discontinued restraint is still active")
	}
	if r.AuthorizationExpired(at(20, 0)) {
		t.Fatal("a discontinued restraint alerts on an expired authorization")
	}
	if err := r.Check(domain.RestraintCheck{
		ID: "check-1", ObservedAt: at(11, 30), ObservedBy: "nurse-1",
		Findings: "n/a", ContinuedReason: "n/a",
	}, at(11, 31)); !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("a discontinued restraint accepted a check: %v", err)
	}
	if r.Duration(at(20, 0)) != 1*time.Hour+55*time.Minute {
		t.Fatalf("duration is %s, want 1h55m", r.Duration(at(20, 0)))
	}
}

// No transfusion tests. SRS-NUR-014's transfusion record moved to the blood
// bank, which is the only context that can link a transfusion to the unit, the
// donation and the look-back (migration 0047). The rules that were here are
// there now: the two-person bedside check, the unit number, the baseline taken
// before the unit is hung, and a reported reaction stopping the transfusion.
