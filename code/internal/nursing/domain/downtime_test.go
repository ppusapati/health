package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/nursing/domain"
)

func episode(t *testing.T) *domain.DowntimeEpisode {
	t.Helper()
	e, err := domain.NewDowntimeEpisode("downtime-1", "tenant-1", "unit-1",
		"network outage", at(2, 0), "nurse-in-charge", at(2, 5))
	if err != nil {
		t.Fatalf("NewDowntimeEpisode: %v", err)
	}
	return e
}

// SRS-NUR-018: the system coming back and the paper being typed in are hours
// apart, and the gap is where the record is incomplete.
func TestEndingDowntimeIsNotTheSameAsReconcilingIt(t *testing.T) {
	e := episode(t)
	if !e.Open() {
		t.Fatal("a new downtime episode is not open")
	}
	// Reconciling before the episode ends would claim the paper is fully
	// entered while the ward is still writing on it.
	if err := e.Reconcile("nurse-1", at(4, 0)); !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("an open episode was reconciled: %v", err)
	}

	if err := e.End(at(5, 0), "nurse-in-charge", at(5, 5)); err != nil {
		t.Fatalf("End: %v", err)
	}
	if e.Open() {
		t.Fatal("an ended episode is still open")
	}
	if !e.ReconciledAt.IsZero() {
		t.Fatal("ending the episode marked it reconciled")
	}

	if err := e.Reconcile("nurse-1", at(9, 0)); err != nil {
		t.Fatalf("Reconcile: %v", err)
	}
	if err := e.Reconcile("nurse-2", at(10, 0)); !errors.Is(
		err, domain.ErrNotAllowed) {
		t.Fatalf("an episode was reconciled twice: %v", err)
	}
}

func TestADowntimeEpisodeNeedsAUnitAndAReason(t *testing.T) {
	if _, err := domain.NewDowntimeEpisode("downtime-1", "tenant-1", "",
		"network outage", at(2, 0), "nurse-in-charge", at(2, 5)); !errors.Is(
		err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("an episode with no unit was accepted: %v", err)
	}
	if _, err := domain.NewDowntimeEpisode("downtime-1", "tenant-1", "unit-1",
		"", at(2, 0), "nurse-in-charge", at(2, 5)); !errors.Is(
		err, domain.ErrInvalidNursingRecord) {
		t.Fatalf("an episode with no reason was accepted: %v", err)
	}
}

func prnDose(t *testing.T, id string, given time.Time) *domain.Administration {
	t.Helper()
	order := verifiedOrder()
	order.PRN = true

	admin, err := domain.NewAdministration(id, "tenant-1",
		domain.NewAdministrationInput{
			Order:     order,
			GivenDose: domain.Quantity{Value: 1000, Unit: "mg"},
			GivenAt:   given, Route: "oral",
			Outcome: domain.Administered, Verification: goodScan(),
			Offline: true,
		}, domain.DefaultAdministrationPolicy(), "nurse-1", given.Add(time.Minute))
	if err != nil {
		t.Fatalf("NewAdministration: %v", err)
	}
	return admin
}

// SRS-NUR-018: a PRN dose repeated may be entirely correct, so the report
// raises an eyebrow rather than refusing.
func TestTwoPRNDosesCloseTogetherAreFlaggedNotRefused(t *testing.T) {
	first := prnDose(t, "admin-1", at(10, 0))
	// The same paper entry, typed again by a second nurse eight minutes off.
	second := prnDose(t, "admin-2", at(10, 8))

	suspected := domain.FindSuspectedDuplicates(
		[]*domain.Administration{first, second})
	if len(suspected) != 1 {
		t.Fatalf("the pair was not flagged: %+v", suspected)
	}
	if suspected[0].FirstID != "admin-1" || suspected[0].SecondID != "admin-2" {
		t.Fatalf("the flagged pair is wrong: %+v", suspected[0])
	}
	if suspected[0].Apart != 8*time.Minute {
		t.Fatalf("apart is %s, want 8m", suspected[0].Apart)
	}
}

// A genuine second dose for breakthrough pain is rarely under half an hour.
func TestAGenuineSecondPRNDoseIsNotFlagged(t *testing.T) {
	first := prnDose(t, "admin-1", at(10, 0))
	second := prnDose(t, "admin-2", at(14, 0))

	if len(domain.FindSuspectedDuplicates(
		[]*domain.Administration{first, second})) != 0 {
		t.Fatal("two doses four hours apart were flagged as one typed twice")
	}
}

// A scheduled dose is covered by the key and never reaches the eyebrow report.
func TestScheduledDosesAreNotInTheSuspectedDuplicateReport(t *testing.T) {
	first, err := giveDose(t, verifiedOrder(), goodScan(), "")
	if err != nil {
		t.Fatalf("NewAdministration: %v", err)
	}
	second, err := domain.NewAdministration("admin-2", "tenant-1",
		domain.NewAdministrationInput{
			Order: verifiedOrder(), ScheduledAt: at(9, 0),
			GivenDose: domain.Quantity{Value: 1000, Unit: "mg"},
			GivenAt:   at(9, 8), Route: "oral",
			Outcome: domain.Administered, Verification: goodScan(),
		}, domain.DefaultAdministrationPolicy(), "nurse-2", at(9, 10))
	if err != nil {
		t.Fatalf("NewAdministration: %v", err)
	}

	if len(domain.FindSuspectedDuplicates(
		[]*domain.Administration{first, second})) != 0 {
		t.Fatal("scheduled doses appeared in the suspected-duplicate report, " +
			"where the unique key already rejects them")
	}
}

// A refused or held dose is not an administration and cannot be a duplicate
// administration.
func TestARefusedDoseIsNotASuspectedDuplicate(t *testing.T) {
	given := prnDose(t, "admin-1", at(10, 0))

	order := verifiedOrder()
	order.PRN = true
	refused, err := domain.NewAdministration("admin-2", "tenant-1",
		domain.NewAdministrationInput{
			Order: order, Outcome: domain.Refused,
			Reason: "patient declined",
		}, domain.DefaultAdministrationPolicy(), "nurse-1", at(10, 5))
	if err != nil {
		t.Fatalf("NewAdministration: %v", err)
	}

	if len(domain.FindSuspectedDuplicates(
		[]*domain.Administration{given, refused})) != 0 {
		t.Fatal("a refusal was flagged as a duplicate administration")
	}
}

// The duplicate refusal names the record that already exists, so a transcriber
// checks rather than retries with a changed time.
func TestTheDuplicateRefusalNamesTheRecordThatAlreadyExists(t *testing.T) {
	err := error(domain.ErrDuplicateAdministration{
		ExistingID: "admin-1", OrderID: "order-1", ScheduledAt: at(9, 0),
	})
	var duplicate domain.ErrDuplicateAdministration
	if !errors.As(err, &duplicate) {
		t.Fatalf("the duplicate error does not match: %v", err)
	}
	if duplicate.ExistingID != "admin-1" {
		t.Fatalf("the refusal names %q", duplicate.ExistingID)
	}
}
