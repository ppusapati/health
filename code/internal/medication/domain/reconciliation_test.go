package domain_test

import (
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/medication/domain"
)

func homeMeds() []domain.ReconciliationItem {
	return []domain.ReconciliationItem{
		{Medication: domain.Coding{System: "rxnorm", Code: "11289", Display: "Warfarin"},
			DoseText: "3 mg daily", Route: "oral", Source: domain.SourceGPRecord},
		{Medication: domain.Coding{System: "rxnorm", Code: "6809", Display: "Metformin"},
			DoseText: "500 mg twice daily", Route: "oral", Source: domain.SourcePatient},
		{Medication: domain.Coding{System: "rxnorm", Code: "36567", Display: "Simvastatin"},
			DoseText: "40 mg at night", Route: "oral", Source: domain.SourceMedicationBag},
	}
}

func newReconciliation(t *testing.T) *domain.Reconciliation {
	t.Helper()
	r, err := domain.NewReconciliation("rec1", "t1", "p1", "e1",
		domain.ReconcileAdmission, homeMeds(), "dr-rao", at(2026, time.March, 2, 3, 0))
	if err != nil {
		t.Fatalf("NewReconciliation: %v", err)
	}
	return r
}

// SRS-MED-005: nothing is complete while a medication has no disposition.
func TestAReconciliationIsNotCompleteWhileAnythingIsUndecided(t *testing.T) {
	r := newReconciliation(t)

	if err := r.Decide(1, domain.DispositionContinue, "", "rx-warfarin", "dr-rao",
		at(2026, time.March, 2, 4, 0)); err != nil {
		t.Fatalf("Decide: %v", err)
	}

	err := r.Complete("dr-rao", at(2026, time.March, 2, 5, 0))
	if !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("an incomplete reconciliation was completed: %v", err)
	}
	if !r.CompletedAt.IsZero() {
		t.Fatal("the reconciliation was marked complete anyway")
	}
}

// The refusal names what is outstanding rather than saying "something".
func TestTheRefusalNamesTheMedicationsNobodyHasDecidedAbout(t *testing.T) {
	r := newReconciliation(t)
	_ = r.Decide(1, domain.DispositionContinue, "", "rx-warfarin", "dr-rao",
		at(2026, time.March, 2, 4, 0))

	var incomplete domain.IncompleteReconciliation
	if err := r.Complete("dr-rao", at(2026, time.March, 2, 5, 0)); !errors.As(
		err, &incomplete) {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(incomplete.Outstanding) != 2 {
		t.Fatalf("%d outstanding, want 2", len(incomplete.Outstanding))
	}
	message := incomplete.Error()
	for _, want := range []string{"Metformin", "Simvastatin"} {
		if !strings.Contains(message, want) {
			t.Errorf("the refusal does not name %s: %q", want, message)
		}
	}
}

// SRS-MED-005: "unknown" is a disposition somebody chose, and it completes.
func TestUnknownIsADecisionAndCompletesTheReconciliation(t *testing.T) {
	r := newReconciliation(t)
	_ = r.Decide(1, domain.DispositionContinue, "", "rx-warfarin", "dr-rao",
		at(2026, time.March, 2, 4, 0))
	_ = r.Decide(2, domain.DispositionStop, "starting insulin", "", "dr-rao",
		at(2026, time.March, 2, 4, 0))
	if err := r.Decide(3, domain.DispositionUnknown, "patient cannot remember the dose",
		"", "dr-rao", at(2026, time.March, 2, 4, 0)); err != nil {
		t.Fatalf("Decide unknown: %v", err)
	}

	if err := r.Complete("dr-rao", at(2026, time.March, 2, 5, 0)); err != nil {
		t.Fatalf("Complete: %v", err)
	}
	if r.CompletedAt.IsZero() || r.CompletedBy != "dr-rao" {
		t.Fatal("completion was not recorded")
	}
}

func TestPendingIsNotADecision(t *testing.T) {
	r := newReconciliation(t)
	if err := r.Decide(1, domain.DispositionPending, "", "", "dr-rao",
		at(2026, time.March, 2, 4, 0)); !errors.Is(err, domain.ErrInvalidPrescription) {
		t.Fatalf("pending was accepted as a decision: %v", err)
	}
}

// Stopping and changing are the two that surprise the next reader.
func TestStoppingOrChangingAMedicationNeedsARationale(t *testing.T) {
	for name, d := range map[string]domain.Disposition{
		"stop":   domain.DispositionStop,
		"change": domain.DispositionChange,
	} {
		t.Run(name, func(t *testing.T) {
			r := newReconciliation(t)
			if err := r.Decide(1, d, "  ", "", "dr-rao",
				at(2026, time.March, 2, 4, 0)); !errors.Is(
				err, domain.ErrInvalidPrescription) {
				t.Fatalf("a %s with no rationale was accepted: %v", name, err)
			}
		})
	}
}

func TestContinuingDoesNotNeedARationale(t *testing.T) {
	r := newReconciliation(t)
	if err := r.Decide(1, domain.DispositionContinue, "", "rx-warfarin", "dr-rao",
		at(2026, time.March, 2, 4, 0)); err != nil {
		t.Fatalf("continuing needed a rationale: %v", err)
	}
}

// SRS-MED-005: a continued medication links to the prescription carrying it on.
func TestAContinuedMedicationPointsAtThePrescriptionCarryingItOn(t *testing.T) {
	r := newReconciliation(t)
	_ = r.Decide(1, domain.DispositionContinue, "", "rx-warfarin", "dr-rao",
		at(2026, time.March, 2, 4, 0))

	if r.Items[0].ResultingPrescriptionID != "rx-warfarin" {
		t.Fatalf("the item does not link to the prescription: %+v", r.Items[0])
	}
	if r.Items[0].DecidedBy != "dr-rao" || r.Items[0].DecidedAt.IsZero() {
		t.Fatal("who decided and when is not recorded")
	}
}

// Where the list came from is how much it can be trusted.
func TestAHomeMedicationMustSayWhereItCameFrom(t *testing.T) {
	items := homeMeds()
	items[1].Source = ""
	_, err := domain.NewReconciliation("rec1", "t1", "p1", "e1",
		domain.ReconcileAdmission, items, "dr-rao", at(2026, time.March, 2, 3, 0))
	if !errors.Is(err, domain.ErrInvalidPrescription) {
		t.Fatalf("a sourceless home medication was accepted: %v", err)
	}
}

// SRS-MED-005: reconciliation happens at all three points.
func TestReconciliationHappensAtAdmissionTransferAndDischarge(t *testing.T) {
	for _, event := range []domain.ReconciliationEvent{
		domain.ReconcileAdmission, domain.ReconcileTransfer, domain.ReconcileDischarge,
	} {
		if _, err := domain.NewReconciliation("rec1", "t1", "p1", "e1", event,
			homeMeds(), "dr-rao", at(2026, time.March, 2, 3, 0)); err != nil {
			t.Fatalf("%s reconciliation refused: %v", event, err)
		}
	}
	if _, err := domain.NewReconciliation("rec1", "t1", "p1", "e1",
		"ward-round", homeMeds(), "dr-rao",
		at(2026, time.March, 2, 3, 0)); !errors.Is(err, domain.ErrInvalidPrescription) {
		t.Fatalf("an invented reconciliation point was accepted: %v", err)
	}
}

func TestACompletedReconciliationTakesNoFurtherDecisions(t *testing.T) {
	r := newReconciliation(t)
	for i := 1; i <= 3; i++ {
		_ = r.Decide(i, domain.DispositionUnknown, "", "", "dr-rao",
			at(2026, time.March, 2, 4, 0))
	}
	if err := r.Complete("dr-rao", at(2026, time.March, 2, 5, 0)); err != nil {
		t.Fatalf("Complete: %v", err)
	}
	if err := r.Decide(1, domain.DispositionStop, "changed my mind", "", "dr-rao",
		at(2026, time.March, 2, 6, 0)); !errors.Is(err, domain.ErrNotAllowed) {
		t.Fatalf("a completed reconciliation took a further decision: %v", err)
	}
}
