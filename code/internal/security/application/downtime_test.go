package application_test

import (
	"context"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	"github.com/ppusapati/health/code/internal/security/application"
	"github.com/ppusapati/health/code/internal/security/domain"
)

func declare(t *testing.T, h harness, ctx context.Context) domain.DowntimeEpisode {
	t.Helper()
	e, err := h.svc.DeclareDowntime(ctx, application.DeclareDowntimeInput{
		FacilityID: "fac-1",
		Reason:     "network switch failure on ward 3",
	})
	if err != nil {
		t.Fatalf("DeclareDowntime: %v", err)
	}
	return e
}

func record(t *testing.T, h harness, ctx context.Context, episodeID string, performedAt time.Time) string {
	t.Helper()
	id := uuid.NewString()
	err := h.svc.RecordDowntimeAction(ctx, application.RecordDowntimeActionInput{
		EpisodeID:    episodeID,
		ActionID:     id,
		PerformedBy:  "nurse-patel",
		PerformedAt:  performedAt,
		ActionType:   "medication.administration",
		SubjectRef:   "patient/p1",
		Summary:      "paracetamol 1g PO",
		PaperFormRef: "MAR-2026-0911-017",
	})
	if err != nil {
		t.Fatalf("RecordDowntimeAction: %v", err)
	}
	return id
}

// The whole SRS-SEC-014 downtime scenario through the application layer: the
// ward goes down, care continues on paper, and the episode cannot be signed
// off until every form is in the chart.
func TestDowntimeScenarioEndToEnd(t *testing.T) {
	h := newHarness(t)
	ctx := h.clinician()
	e := declare(t, h, ctx)

	h.clock.t = now.Add(30 * time.Minute)
	ids := []string{
		record(t, h, ctx, e.ID, now.Add(10*time.Minute)),
		record(t, h, ctx, e.ID, now.Add(20*time.Minute)),
	}

	h.clock.t = now.Add(2 * time.Hour)
	if err := h.svc.RestoreDowntime(ctx, e.ID); err != nil {
		t.Fatalf("RestoreDowntime: %v", err)
	}

	// Restoring the system does not finish the episode.
	_, err := h.svc.CloseDowntime(ctx, e.ID)
	if got := categoryOf(t, err); got != rpcerr.CategoryFailedPrecondition {
		t.Fatalf("want FAILED_PRECONDITION while paper is outstanding, got %v", got)
	}

	h.clock.t = now.Add(3 * time.Hour)
	for i, id := range ids {
		err := h.svc.ReconcileDowntimeAction(ctx, application.ReconcileDowntimeActionInput{
			EpisodeID: e.ID, ActionID: id,
			ResourceRef: "administration/" + ids[i],
		})
		if err != nil {
			t.Fatalf("ReconcileDowntimeAction: %v", err)
		}
	}

	closed, err := h.svc.CloseDowntime(ctx, e.ID)
	if err != nil {
		t.Fatalf("CloseDowntime: %v", err)
	}
	if closed.Status != domain.DowntimeReconciled {
		t.Fatalf("want reconciled, got %s", closed.Status)
	}

	got, err := h.svc.GetDowntimeEpisode(ctx, e.ID)
	if err != nil {
		t.Fatalf("GetDowntimeEpisode: %v", err)
	}
	if len(got.Outstanding()) != 0 {
		t.Fatalf("still outstanding after close: %v", got.Outstanding())
	}
	// The clinical time survived the round trip through the service.
	if !got.Actions[0].PerformedAt.Equal(now.Add(10 * time.Minute)) {
		t.Fatalf("performed-at moved: %s", got.Actions[0].PerformedAt)
	}
}

// A clerk entering forms afterwards is the normal case. Recording the clerk as
// the clinician would put the wrong name against a medication administration.
func TestTheClerkIsNotRecordedAsTheClinician(t *testing.T) {
	h := newHarness(t)
	ctx := h.clinician()
	e := declare(t, h, ctx)

	h.clock.t = now.Add(2 * time.Hour)
	err := h.svc.RecordDowntimeAction(ctx, application.RecordDowntimeActionInput{
		EpisodeID:    e.ID,
		ActionID:     uuid.NewString(),
		PerformedBy:  "nurse-patel", // not the session subject, dr-singh
		PerformedAt:  now.Add(30 * time.Minute),
		ActionType:   "medication.administration",
		SubjectRef:   "patient/p1",
		Summary:      "paracetamol 1g PO",
		PaperFormRef: "MAR-2026-0911-017",
	})
	if err != nil {
		t.Fatalf("RecordDowntimeAction: %v", err)
	}

	got, err := h.svc.GetDowntimeEpisode(ctx, e.ID)
	if err != nil {
		t.Fatalf("GetDowntimeEpisode: %v", err)
	}
	if got.Actions[0].PerformedBy != "nurse-patel" {
		t.Fatalf("the session subject overwrote the clinician: %s", got.Actions[0].PerformedBy)
	}
}

// Backdating through the downtime queue would let someone write into the record
// outside the normal controls and blame the outage.
func TestActionCannotPredateTheOutage(t *testing.T) {
	h := newHarness(t)
	ctx := h.clinician()
	e := declare(t, h, ctx)

	h.clock.t = now.Add(time.Hour)
	err := h.svc.RecordDowntimeAction(ctx, application.RecordDowntimeActionInput{
		EpisodeID: e.ID, ActionID: uuid.NewString(),
		PerformedBy: "nurse-patel", PerformedAt: now.Add(-time.Hour),
		ActionType: "medication.administration", SubjectRef: "patient/p1",
		Summary: "backdated", PaperFormRef: "MAR-1",
	})
	if got := categoryOf(t, err); got != rpcerr.CategoryInvalidArgument {
		t.Fatalf("want INVALID_ARGUMENT for a backdated action, got %v", got)
	}
}

// A ward terminal that loses its response retries with the same action id.
func TestRecordingIsIdempotentAcrossRetries(t *testing.T) {
	h := newHarness(t)
	ctx := h.clinician()
	e := declare(t, h, ctx)
	h.clock.t = now.Add(time.Hour)

	in := application.RecordDowntimeActionInput{
		EpisodeID: e.ID, ActionID: uuid.NewString(),
		PerformedBy: "nurse-patel", PerformedAt: now.Add(10 * time.Minute),
		ActionType: "medication.administration", SubjectRef: "patient/p1",
		Summary: "paracetamol 1g PO", PaperFormRef: "MAR-1",
	}
	for range 3 {
		if err := h.svc.RecordDowntimeAction(ctx, in); err != nil {
			t.Fatalf("RecordDowntimeAction: %v", err)
		}
	}
	got, err := h.svc.GetDowntimeEpisode(ctx, e.ID)
	if err != nil {
		t.Fatalf("GetDowntimeEpisode: %v", err)
	}
	if len(got.Actions) != 1 {
		t.Fatalf("want 1 action after three retries, got %d", len(got.Actions))
	}
}

// The declaration is about one ward, so the credential has to reach that ward.
// Otherwise a user could open a reconciliation queue at a facility they have
// never worked in.
func TestDeclarationRequiresFacilityScope(t *testing.T) {
	h := newHarness(t)
	ctx := authctx.WithSession(context.Background(), authctx.Session{
		SubjectID: "dr-singh", TenantID: h.tenant,
		ActiveFacilityID:    "fac-1",
		PermittedFacilities: []string{"fac-1"},
		Permissions:         []string{application.PermDowntimeDeclare},
		CorrelationID:       uuid.NewString(),
	})
	_, err := h.svc.DeclareDowntime(ctx, application.DeclareDowntimeInput{
		FacilityID: "fac-9", // outside the credential
		Reason:     "an outage at a ward I do not work in",
	})
	if got := categoryOf(t, err); got != rpcerr.CategoryPermissionDenied {
		t.Fatalf("want PERMISSION_DENIED, got %v", got)
	}
}

// Reading another tenant's episode is NOT_FOUND, never PERMISSION_DENIED: the
// second would confirm the identifier exists.
func TestCrossTenantReadIsNotFound(t *testing.T) {
	h := newHarness(t)
	e := declare(t, h, h.clinician())

	intruder := authctx.WithSession(context.Background(), authctx.Session{
		SubjectID: "intruder", TenantID: uuid.NewString(),
		ActiveFacilityID:    "fac-1",
		PermittedFacilities: []string{"fac-1"},
		Permissions: []string{
			application.PermDowntimeRecord, application.PermDowntimeReconcile,
		},
		CorrelationID: uuid.NewString(),
	})
	_, err := h.svc.GetDowntimeEpisode(intruder, e.ID)
	if got := categoryOf(t, err); got != rpcerr.CategoryNotFound {
		t.Fatalf("want NOT_FOUND for a cross-tenant read, got %v", got)
	}
	err = h.svc.ReconcileDowntimeAction(intruder, application.ReconcileDowntimeActionInput{
		EpisodeID: e.ID, ActionID: uuid.NewString(), ResourceRef: "administration/x",
	})
	if got := categoryOf(t, err); got != rpcerr.CategoryNotFound {
		t.Fatalf("want NOT_FOUND for a cross-tenant reconcile, got %v", got)
	}
}

// A planned window and an unplanned outage produce different severities: paging
// on every maintenance window trains people to ignore the page.
func TestPlannedDowntimeIsNotAnAlert(t *testing.T) {
	h := newHarness(t)
	// Two wards, so the planned and unplanned episodes do not collide on the
	// one-open-episode-per-facility index. Each needs its own session: the
	// policy gate compares against the *active* facility, the one the caller
	// selected for this request, not against everything the credential could
	// reach. Holding fac-2 in PermittedFacilities is what lets the interceptor
	// switch to it; it is not by itself permission to act there.
	atWard := func(facility string) context.Context {
		return authctx.WithSession(context.Background(), authctx.Session{
			SubjectID: "dr-singh", TenantID: h.tenant,
			ActiveFacilityID:    facility,
			PermittedFacilities: []string{"fac-1", "fac-2"},
			Permissions:         []string{application.PermDowntimeDeclare},
			CorrelationID:       uuid.NewString(),
		})
	}

	unplanned := declare(t, h, atWard("fac-1"))
	planned, err := h.svc.DeclareDowntime(atWard("fac-2"), application.DeclareDowntimeInput{
		FacilityID: "fac-2", Planned: true,
		Reason: "scheduled storage maintenance window",
	})
	if err != nil {
		t.Fatalf("DeclareDowntime(planned): %v", err)
	}

	severity := func(resourceID string) string {
		t.Helper()
		var s string
		err := h.pool.QueryRow(context.Background(),
			`SELECT severity FROM security_platform.security_event
			 WHERE tenant_id = $1 AND resource_id = $2`, h.tenant, resourceID).Scan(&s)
		if err != nil {
			t.Fatalf("no security event for %s: %v", resourceID, err)
		}
		return s
	}
	if got := severity(unplanned.ID); got != string(domain.SeverityHigh) {
		t.Errorf("unplanned outage recorded as %s", got)
	}
	if got := severity(planned.ID); got != string(domain.SeverityInfo) {
		t.Errorf("planned window recorded as %s", got)
	}
}
