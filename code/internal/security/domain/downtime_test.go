package domain_test

import (
	"errors"
	"fmt"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/security/domain"
)

func newEpisode(t *testing.T) domain.DowntimeEpisode {
	t.Helper()
	e, err := domain.NewDowntimeEpisode("dt-1", "tenant-a", "fac-1", "ward-sister",
		"network switch failure on ward 3", "corr-1", false, base)
	if err != nil {
		t.Fatalf("NewDowntimeEpisode: %v", err)
	}
	return e
}

func action(id string, at time.Time) domain.DowntimeAction {
	return domain.DowntimeAction{
		ID: id, PerformedBy: "nurse-patel", PerformedAt: at,
		ActionType: "medication.administration", SubjectRef: "patient/p1",
		Summary: "paracetamol 1g PO", PaperFormRef: "MAR-2026-0911-017",
	}
}

// The scenario SRS-SEC-014 names: the ward goes down, care continues on paper,
// and the record is whole again afterwards — with the clinical times intact.
func TestDowntimeEpisodeReconcilesEveryPaperAction(t *testing.T) {
	e := newEpisode(t)

	during := base.Add(30 * time.Minute)
	for i := range 3 {
		a := action(fmt.Sprintf("act-%d", i), during.Add(time.Duration(i)*time.Minute))
		if err := e.RecordAction(a, during.Add(time.Hour)); err != nil {
			t.Fatalf("RecordAction: %v", err)
		}
	}

	restored := base.Add(2 * time.Hour)
	if err := e.Restore(restored); err != nil {
		t.Fatalf("Restore: %v", err)
	}
	// Restoring the system does not finish the episode; the record is still
	// three entries short.
	if err := e.Close("ward-sister", restored); !errors.Is(err, domain.ErrUnreconciled) {
		t.Fatalf("want ErrUnreconciled while actions are outstanding, got %v", err)
	}

	for i := range 3 {
		id := fmt.Sprintf("act-%d", i)
		if err := e.Reconcile(id, "nurse-patel", "administration/"+id, restored.Add(time.Duration(i)*time.Minute)); err != nil {
			t.Fatalf("Reconcile(%s): %v", id, err)
		}
	}
	if out := e.Outstanding(); len(out) != 0 {
		t.Fatalf("want nothing outstanding, got %d", len(out))
	}
	if err := e.Close("ward-sister", restored.Add(10*time.Minute)); err != nil {
		t.Fatalf("Close: %v", err)
	}
	if e.Status != domain.DowntimeReconciled {
		t.Fatalf("want reconciled, got %s", e.Status)
	}

	// The clinical truth survived reconciliation: the dose is recorded at the
	// time it was given, not at the time it was typed in.
	if got, want := e.Actions[0].PerformedAt.UTC(), during; !got.Equal(want) {
		t.Fatalf("performed-at moved: got %s, want %s", got, want)
	}
	if e.Actions[0].ReconciledAt.Before(restored) {
		t.Fatal("reconciliation time should be when it was entered, after restore")
	}
	if e.Actions[0].PerformedBy == e.Actions[0].ReconciledBy && e.Actions[0].PerformedAt.Equal(e.Actions[0].ReconciledAt) {
		t.Fatal("performing and reconciling collapsed into one event")
	}
}

func TestDowntimeActionRequiresItsPaperTrail(t *testing.T) {
	e := newEpisode(t)
	now := base.Add(time.Hour)
	during := base.Add(10 * time.Minute)

	cases := map[string]func(*domain.DowntimeAction){
		"no performer":     func(a *domain.DowntimeAction) { a.PerformedBy = "" },
		"no clinical time": func(a *domain.DowntimeAction) { a.PerformedAt = time.Time{} },
		"no paper form":    func(a *domain.DowntimeAction) { a.PaperFormRef = "" },
		"no subject":       func(a *domain.DowntimeAction) { a.SubjectRef = "" },
	}
	for name, mutate := range cases {
		t.Run(name, func(t *testing.T) {
			a := action("act-x", during)
			mutate(&a)
			if err := e.RecordAction(a, now); !errors.Is(err, domain.ErrInvalidDowntime) {
				t.Fatalf("want ErrInvalidDowntime, got %v", err)
			}
		})
	}
}

// Backdating through the downtime queue would let someone write into the
// record outside the normal controls and blame the outage.
func TestDowntimeActionCannotPredateTheOutage(t *testing.T) {
	e := newEpisode(t)
	a := action("act-early", base.Add(-time.Hour))
	if err := e.RecordAction(a, base.Add(time.Hour)); !errors.Is(err, domain.ErrInvalidDowntime) {
		t.Fatalf("want refusal of an action before the episode, got %v", err)
	}
}

func TestDowntimeActionCannotBeInTheFuture(t *testing.T) {
	e := newEpisode(t)
	a := action("act-future", base.Add(4*time.Hour))
	if err := e.RecordAction(a, base.Add(time.Hour)); !errors.Is(err, domain.ErrInvalidDowntime) {
		t.Fatalf("want refusal of a future action, got %v", err)
	}
}

// A ward terminal that loses the response retries. Duplicating a medication
// administration because of that would be a clinical incident.
func TestRecordActionIsIdempotent(t *testing.T) {
	e := newEpisode(t)
	a := action("act-1", base.Add(10*time.Minute))
	for range 3 {
		if err := e.RecordAction(a, base.Add(time.Hour)); err != nil {
			t.Fatalf("RecordAction: %v", err)
		}
	}
	if len(e.Actions) != 1 {
		t.Fatalf("want 1 action, got %d", len(e.Actions))
	}
}

func TestReconcileIsIdempotentForTheSameTargetOnly(t *testing.T) {
	e := newEpisode(t)
	if err := e.RecordAction(action("act-1", base.Add(10*time.Minute)), base.Add(time.Hour)); err != nil {
		t.Fatalf("RecordAction: %v", err)
	}
	_ = e.Restore(base.Add(2 * time.Hour))
	at := base.Add(3 * time.Hour)

	if err := e.Reconcile("act-1", "nurse-patel", "administration/a1", at); err != nil {
		t.Fatalf("Reconcile: %v", err)
	}
	if err := e.Reconcile("act-1", "nurse-patel", "administration/a1", at); err != nil {
		t.Fatalf("repeat with the same target should be a no-op: %v", err)
	}
	if err := e.Reconcile("act-1", "nurse-patel", "administration/a2", at); !errors.Is(err, domain.ErrInvalidDowntime) {
		t.Fatalf("want refusal of a second target for one paper action, got %v", err)
	}
}

func TestActionsMayStillArriveWhileRecovering(t *testing.T) {
	e := newEpisode(t)
	_ = e.Restore(base.Add(2 * time.Hour))
	// The ward finds a form it had not yet entered. It still belongs to the
	// episode.
	if err := e.RecordAction(action("act-late", base.Add(90*time.Minute)), base.Add(3*time.Hour)); err != nil {
		t.Fatalf("RecordAction while recovering: %v", err)
	}
	if len(e.Outstanding()) != 1 {
		t.Fatal("the late form should be outstanding")
	}
}

func TestEpisodeRequiresAReason(t *testing.T) {
	if _, err := domain.NewDowntimeEpisode("dt", "t", "f", "u", "oops", "c", false, base); !errors.Is(err, domain.ErrInvalidDowntime) {
		t.Fatalf("want ErrInvalidDowntime for a terse reason, got %v", err)
	}
}

func TestReconcileRejectsUnknownAction(t *testing.T) {
	e := newEpisode(t)
	_ = e.Restore(base.Add(time.Hour))
	if err := e.Reconcile("nope", "nurse", "r", base.Add(2*time.Hour)); !errors.Is(err, domain.ErrInvalidDowntime) {
		t.Fatalf("want ErrInvalidDowntime, got %v", err)
	}
}
