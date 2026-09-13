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

func redCells() domain.Coding {
	return domain.Coding{
		System: "http://snomed.info/sct", Version: "2024-03",
		Code: "256395009", Display: "Packed red blood cells",
	}
}

func baselineObs() domain.TransfusionObservation {
	return domain.TransfusionObservation{
		ID: "obs-0", ObservedAt: at(9, 45), ObservedBy: "nurse-1",
		TemperatureC: 36.8, Pulse: 82, SystolicBP: 118, RespiratoryRate: 16,
	}
}

func transfusion(t *testing.T) *domain.Transfusion {
	t.Helper()
	tx, err := domain.NewTransfusion("transfusion-1", "tenant-1",
		domain.NewTransfusionInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			UnitNumber: "G123456789012", Product: redCells(),
			ABOGroup: "O", RhD: "positive", VolumeML: 280,
			StartedAt: at(10, 0), CheckedBy: "nurse-2",
			Baseline: baselineObs(),
		}, "nurse-1", at(10, 2))
	if err != nil {
		t.Fatalf("NewTransfusion: %v", err)
	}
	return tx
}

// SRS-NUR-014: monitoring is linked to the blood-product episode, and the
// baseline is what makes a rise readable.
func TestATransfusionNeedsABaselineBeforeItStarts(t *testing.T) {
	_, err := domain.NewTransfusion("transfusion-1", "tenant-1",
		domain.NewTransfusionInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			UnitNumber: "G123456789012", Product: redCells(),
			StartedAt: at(10, 0), CheckedBy: "nurse-2",
		}, "nurse-1", at(10, 2))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a transfusion with no baseline was accepted: %v", err)
	}
}

func TestATemperatureRiseIsReportedAgainstTheBaseline(t *testing.T) {
	tx := transfusion(t)
	if err := tx.Observe(domain.TransfusionObservation{
		ID: "obs-1", ObservedAt: at(10, 15), ObservedBy: "nurse-1",
		TemperatureC: 38.1, Pulse: 104, SystolicBP: 104, RespiratoryRate: 22,
	}, at(10, 16)); err != nil {
		t.Fatalf("Observe: %v", err)
	}

	rise, ok := tx.TemperatureRise()
	if !ok {
		t.Fatal("no temperature rise was reported")
	}
	if rise < 1.29 || rise > 1.31 {
		t.Fatalf("rise is %v, want about 1.3", rise)
	}
}

// One person checking their own work is not a two-person check.
func TestATransfusionNeedsASecondPersonsBedsideCheck(t *testing.T) {
	_, err := domain.NewTransfusion("transfusion-1", "tenant-1",
		domain.NewTransfusionInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			UnitNumber: "G123456789012", Product: redCells(),
			StartedAt: at(10, 0), CheckedBy: "nurse-1",
			Baseline: baselineObs(),
		}, "nurse-1", at(10, 2))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a nurse checked their own transfusion: %v", err)
	}
}

// The unit number is what links this record to the blood bank and forward to a
// look-back investigation.
func TestATransfusionNeedsTheUnitNumberOfThePack(t *testing.T) {
	_, err := domain.NewTransfusion("transfusion-1", "tenant-1",
		domain.NewTransfusionInput{
			PatientID: "patient-1", EncounterID: "encounter-1",
			Product: redCells(), StartedAt: at(10, 0), CheckedBy: "nurse-2",
			Baseline: baselineObs(),
		}, "nurse-1", at(10, 2))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a transfusion with no unit number was accepted: %v", err)
	}
}

// SRS-NUR-014: the reaction action is initiated from the bedside, and
// stopping and reporting are one act.
func TestReportingAReactionStopsTheTransfusion(t *testing.T) {
	tx := transfusion(t)
	if err := tx.ReportReaction(domain.TransfusionReaction{
		ReportedBy: "nurse-1",
		Features:   "rigors, temperature 38.9, loin pain",
		ActionTaken: "transfusion stopped, line kept open with saline, " +
			"medical staff called",
		UnitReturned: true,
	}, at(10, 25)); err != nil {
		t.Fatalf("ReportReaction: %v", err)
	}

	if tx.Status != domain.TransfusionStopped {
		t.Fatalf("status is %q, want stopped", tx.Status)
	}
	if tx.Reaction == nil || !tx.Reaction.UnitReturned {
		t.Fatal("the reaction or the pack return was not recorded")
	}
	// A stopped transfusion takes no more observations against it.
	if err := tx.Observe(domain.TransfusionObservation{
		ID: "obs-2", ObservedAt: at(10, 30), ObservedBy: "nurse-1",
		TemperatureC: 38.4,
	}, at(10, 31)); !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("a stopped transfusion accepted an observation: %v", err)
	}
}

// A reaction report with no action taken is a report of an unhandled
// reaction.
func TestAReactionNeedsTheActionTaken(t *testing.T) {
	tx := transfusion(t)
	err := tx.ReportReaction(domain.TransfusionReaction{
		ReportedBy: "nurse-1", Features: "rigors",
	}, at(10, 25))
	if !errors.Is(err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("a reaction with no action was accepted: %v", err)
	}
}

func TestACompletedTransfusionIsDistinctFromAStoppedOne(t *testing.T) {
	tx := transfusion(t)
	if err := tx.Complete(at(12, 30), at(12, 31)); err != nil {
		t.Fatalf("Complete: %v", err)
	}
	if tx.Status != domain.TransfusionCompleted {
		t.Fatalf("status is %q, want completed", tx.Status)
	}
	if err := tx.Complete(at(12, 40), at(12, 41)); !errors.Is(
		err, domain.ErrNotAllowed) {
		t.Fatalf("a completed transfusion was completed again: %v", err)
	}
}
