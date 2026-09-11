package postgres_test

import (
	"context"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/security/domain"
)

func episode(t *testing.T, tenant, facility string) domain.DowntimeEpisode {
	t.Helper()
	e, err := domain.NewDowntimeEpisode(uuid.NewString(), tenant, facility,
		"ward-sister", "network switch failure on ward 3", uuid.NewString(), false, at)
	if err != nil {
		t.Fatalf("NewDowntimeEpisode: %v", err)
	}
	return e
}

func paperAction(performedAt time.Time) domain.DowntimeAction {
	return domain.DowntimeAction{
		ID: uuid.NewString(), PerformedBy: "nurse-patel", PerformedAt: performedAt,
		ActionType: "medication.administration", SubjectRef: "patient/p1",
		Summary: "paracetamol 1g PO", PaperFormRef: "MAR-2026-0911-017",
	}
}

// The scenario SRS-SEC-014 asks to be demonstrated, through the database: the
// ward loses the system, care continues on paper, and the record is whole
// again afterwards with the clinical times intact.
func TestDowntimeEpisodeSurvivesAndReconciles(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	e := episode(t, f.tenant, "fac-1")

	if err := f.repo.InsertEpisode(ctx, f.scope, e); err != nil {
		t.Fatalf("InsertEpisode: %v", err)
	}

	during := at.Add(30 * time.Minute)
	actions := []domain.DowntimeAction{
		paperAction(during),
		paperAction(during.Add(time.Minute)),
		paperAction(during.Add(2 * time.Minute)),
	}
	for _, a := range actions {
		if err := f.repo.RecordAction(ctx, f.scope, e.ID, a); err != nil {
			t.Fatalf("RecordAction: %v", err)
		}
	}

	restored := at.Add(2 * time.Hour)
	if err := f.repo.Restore(ctx, f.scope, e.ID, restored); err != nil {
		t.Fatalf("Restore: %v", err)
	}

	// Restoring the system does not finish the episode; three entries are
	// still owed to the chart, and the statement refuses to close it.
	if err := f.repo.CloseEpisode(ctx, f.scope, e.ID, "ward-sister", restored); err == nil {
		t.Fatal("the episode closed while actions were unreconciled")
	}
	outstanding, err := f.repo.UnreconciledCount(ctx, f.scope, e.ID)
	if err != nil {
		t.Fatalf("UnreconciledCount: %v", err)
	}
	if outstanding != 3 {
		t.Fatalf("want 3 outstanding, got %d", outstanding)
	}

	for i, a := range actions {
		ref := "administration/" + a.ID
		if err := f.repo.ReconcileAction(ctx, f.scope, e.ID, a.ID, "nurse-patel", ref,
			restored.Add(time.Duration(i)*time.Minute)); err != nil {
			t.Fatalf("ReconcileAction: %v", err)
		}
	}
	if err := f.repo.CloseEpisode(ctx, f.scope, e.ID, "ward-sister", restored.Add(10*time.Minute)); err != nil {
		t.Fatalf("CloseEpisode: %v", err)
	}

	got, err := f.repo.GetEpisode(ctx, f.scope, e.ID)
	if err != nil {
		t.Fatalf("GetEpisode: %v", err)
	}
	if got.Status != domain.DowntimeReconciled {
		t.Fatalf("want reconciled, got %s", got.Status)
	}
	if len(got.Actions) != 3 {
		t.Fatalf("want 3 actions, got %d", len(got.Actions))
	}
	// The clinical truth survived: the dose is recorded at the time it was
	// given, by the person who gave it, not at the time the clerk typed it.
	if !got.Actions[0].PerformedAt.Equal(during) {
		t.Fatalf("performed-at moved: %s vs %s", got.Actions[0].PerformedAt, during)
	}
	if got.Actions[0].ReconciledAt.Before(restored) {
		t.Fatal("reconciliation time predates the restore")
	}
	if got.Actions[0].PerformedAt.Equal(got.Actions[0].ReconciledAt) {
		t.Fatal("care and transcription collapsed into one instant")
	}
}

// A ward terminal that loses its response retries. Duplicating a medication
// administration because of that would be a clinical incident.
func TestRecordActionIsIdempotentInTheDatabase(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	e := episode(t, f.tenant, "fac-1")
	if err := f.repo.InsertEpisode(ctx, f.scope, e); err != nil {
		t.Fatalf("InsertEpisode: %v", err)
	}

	a := paperAction(at.Add(10 * time.Minute))
	for range 3 {
		if err := f.repo.RecordAction(ctx, f.scope, e.ID, a); err != nil {
			t.Fatalf("RecordAction: %v", err)
		}
	}
	got, err := f.repo.GetEpisode(ctx, f.scope, e.ID)
	if err != nil {
		t.Fatalf("GetEpisode: %v", err)
	}
	if len(got.Actions) != 1 {
		t.Fatalf("want 1 action after three submissions, got %d", len(got.Actions))
	}
}

// Two paper actions must not be reconciled to the same record entry: one of
// them would silently vanish from the chart.
func TestOnePaperActionBecomesOneRecordEntry(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	e := episode(t, f.tenant, "fac-1")
	if err := f.repo.InsertEpisode(ctx, f.scope, e); err != nil {
		t.Fatalf("InsertEpisode: %v", err)
	}

	first := paperAction(at.Add(10 * time.Minute))
	second := paperAction(at.Add(20 * time.Minute))
	for _, a := range []domain.DowntimeAction{first, second} {
		if err := f.repo.RecordAction(ctx, f.scope, e.ID, a); err != nil {
			t.Fatalf("RecordAction: %v", err)
		}
	}
	if err := f.repo.Restore(ctx, f.scope, e.ID, at.Add(time.Hour)); err != nil {
		t.Fatalf("Restore: %v", err)
	}

	reconciledAt := at.Add(2 * time.Hour)
	if err := f.repo.ReconcileAction(ctx, f.scope, e.ID, first.ID, "clerk", "administration/a1", reconciledAt); err != nil {
		t.Fatalf("ReconcileAction: %v", err)
	}
	// Same target, different paper action.
	if err := f.repo.ReconcileAction(ctx, f.scope, e.ID, second.ID, "clerk", "administration/a1", reconciledAt); err == nil {
		t.Fatal("two paper actions were reconciled to the same record entry")
	}
	// A second attempt on an already-reconciled action is refused too.
	if err := f.repo.ReconcileAction(ctx, f.scope, e.ID, first.ID, "clerk", "administration/a2", reconciledAt); err == nil {
		t.Fatal("an already-reconciled action was reconciled again")
	}
}

// One open episode per facility. Two concurrent declarations would split the
// reconciliation queue and a ward would work from the wrong one.
func TestOneOpenEpisodePerFacility(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()

	if err := f.repo.InsertEpisode(ctx, f.scope, episode(t, f.tenant, "fac-1")); err != nil {
		t.Fatalf("InsertEpisode: %v", err)
	}
	if err := f.repo.InsertEpisode(ctx, f.scope, episode(t, f.tenant, "fac-1")); err == nil {
		t.Fatal("a second open episode was accepted for the same facility")
	}
	// A different ward is a different outage.
	if err := f.repo.InsertEpisode(ctx, f.scope, episode(t, f.tenant, "fac-2")); err != nil {
		t.Fatalf("a second facility's episode was refused: %v", err)
	}
}

func TestDowntimeIsTenantScoped(t *testing.T) {
	f := newFixture(t)
	ctx := context.Background()
	e := episode(t, f.tenant, "fac-1")
	if err := f.repo.InsertEpisode(ctx, f.scope, e); err != nil {
		t.Fatalf("InsertEpisode: %v", err)
	}
	a := paperAction(at.Add(10 * time.Minute))
	if err := f.repo.RecordAction(ctx, f.scope, e.ID, a); err != nil {
		t.Fatalf("RecordAction: %v", err)
	}

	other := authctx.NewSession(authctx.Session{
		SubjectID: "intruder", TenantID: uuid.NewString(),
	}).TenantScope()

	if _, err := f.repo.GetEpisode(ctx, other, e.ID); err == nil {
		t.Fatal("tenant B read tenant A's downtime episode")
	}
	if err := f.repo.Restore(ctx, other, e.ID, at.Add(time.Hour)); err == nil {
		t.Fatal("tenant B restored tenant A's episode")
	}
	if err := f.repo.ReconcileAction(ctx, other, e.ID, a.ID, "intruder", "administration/x", at.Add(time.Hour)); err == nil {
		t.Fatal("tenant B reconciled tenant A's paper action")
	}

	got, err := f.repo.GetEpisode(ctx, f.scope, e.ID)
	if err != nil {
		t.Fatalf("GetEpisode: %v", err)
	}
	if got.Status != domain.DowntimeOpen || got.Actions[0].Reconciled() {
		t.Fatalf("tenant A's episode was modified: %+v", got)
	}
}
