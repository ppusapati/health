package application_test

import (
	"context"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/platform/pgtest"
	"github.com/ppusapati/health/code/internal/platform/pgtx"
	"github.com/ppusapati/health/code/internal/platform/rpcerr"
	secpostgres "github.com/ppusapati/health/code/internal/security/adapters/postgres"
	"github.com/ppusapati/health/code/internal/security/application"
	"github.com/ppusapati/health/code/internal/security/domain"
)

// The application layer is tested against a real database rather than fakes.
// Its two load-bearing behaviours — refusing a stacked activation and refusing
// to close an episode that still owes entries — are enforced by database
// constraints, and a fake would happily let both through.

var now = time.Date(2026, 9, 11, 9, 0, 0, 0, time.UTC)

type stubClock struct{ t time.Time }

func (c *stubClock) Now() time.Time { return c.t }

type uuidGen struct{}

func (uuidGen) NewID() string { return uuid.NewString() }

type harness struct {
	svc    *application.Service
	repo   *secpostgres.Repository
	clock  *stubClock
	tenant string
	pool   *pgxpool.Pool
}

func newHarness(t *testing.T) harness {
	t.Helper()
	pool := pgtest.New(t)
	tx := pgtx.NewManager(pool)
	repo := secpostgres.New(tx)
	clock := &stubClock{t: now}

	return harness{
		svc:    application.NewService(tx, repo, repo, repo, uuidGen{}, clock),
		repo:   repo,
		clock:  clock,
		tenant: uuid.NewString(),
		pool:   pool,
	}
}

// clinician is a session that already holds the clinical permissions, so an
// emergency grant over them is a widening of reach rather than of privilege.
func (h harness) clinician(perms ...string) context.Context {
	all := append([]string{
		application.PermEmergencyActivate,
		application.PermDowntimeDeclare,
		application.PermDowntimeRecord,
		application.PermDowntimeReconcile,
		"clinical.read", "clinical.write",
	}, perms...)
	return authctx.WithSession(context.Background(), authctx.Session{
		SubjectID:           "dr-singh",
		TenantID:            h.tenant,
		ActiveFacilityID:    "fac-1",
		PermittedFacilities: []string{"fac-1"},
		Permissions:         all,
		CorrelationID:       uuid.NewString(),
		RequestID:           uuid.NewString(),
	})
}

func (h harness) reviewer() context.Context {
	return authctx.WithSession(context.Background(), authctx.Session{
		SubjectID:           "chief-medical-officer",
		TenantID:            h.tenant,
		ActiveFacilityID:    "fac-1",
		PermittedFacilities: []string{"fac-1"},
		Permissions:         []string{application.PermEmergencyReview},
		CorrelationID:       uuid.NewString(),
		RequestID:           uuid.NewString(),
	})
}

func activate(t *testing.T, h harness, ctx context.Context) domain.EmergencyGrant {
	t.Helper()
	g, err := h.svc.ActivateEmergencyAccess(ctx, application.ActivateEmergencyAccessInput{
		IncidentRef:   "INC-2026-0412",
		Justification: "unconscious patient admitted from another facility",
		Permissions:   []string{"clinical.read"},
		TTL:           time.Hour,
	})
	if err != nil {
		t.Fatalf("ActivateEmergencyAccess: %v", err)
	}
	return g
}

// categoryOf asserts the platform error category rather than a Connect code:
// the application layer never imports connect, and checking the category here
// keeps that separation honest (SRS-API-004).
func categoryOf(t *testing.T, err error) rpcerr.Category {
	t.Helper()
	if err == nil {
		t.Fatal("expected an error")
	}
	e, ok := rpcerr.As(err)
	if !ok {
		t.Fatalf("not a platform error: %v", err)
	}
	return e.Category
}

// Activation writes the grant and its security event in one transaction, so a
// grant cannot exist without the record of it existing.
func TestActivationRecordsACriticalSecurityEvent(t *testing.T) {
	h := newHarness(t)
	ctx := h.clinician()
	g := activate(t, h, ctx)

	if g.Status != domain.EmergencyActive {
		t.Fatalf("want active, got %s", g.Status)
	}

	var class, severity string
	err := h.pool.QueryRow(context.Background(),
		`SELECT event_class, severity FROM security_platform.security_event
		 WHERE tenant_id = $1 AND resource_id = $2`, h.tenant, g.ID).Scan(&class, &severity)
	if err != nil {
		t.Fatalf("no security event was written for the activation: %v", err)
	}
	if class != domain.ClassBreakGlass {
		t.Fatalf("want class %s, got %s", domain.ClassBreakGlass, class)
	}
	// Critical, so it reaches a human the same day rather than a weekly report.
	if severity != string(domain.SeverityCritical) {
		t.Fatalf("want critical severity, got %s", severity)
	}
}

// The central control, through the whole stack: emergency access widens reach,
// never privilege.
func TestActivationRefusesToEscalate(t *testing.T) {
	h := newHarness(t)
	_, err := h.svc.ActivateEmergencyAccess(h.clinician(), application.ActivateEmergencyAccessInput{
		IncidentRef:   "INC-1",
		Justification: "unconscious patient needs their medication history",
		// Not held by the session.
		Permissions: []string{"clinical.read", "organization.tenant.delete"},
		TTL:         time.Hour,
	})
	if got := categoryOf(t, err); got != rpcerr.CategoryPermissionDenied {
		t.Fatalf("want PermissionDenied for an escalation, got %v", got)
	}
}

func TestActivationRefusesWithoutThePermission(t *testing.T) {
	h := newHarness(t)
	ctx := authctx.WithSession(context.Background(), authctx.Session{
		SubjectID: "dr-singh", TenantID: h.tenant,
		Permissions:   []string{"clinical.read"},
		CorrelationID: uuid.NewString(),
	})
	_, err := h.svc.ActivateEmergencyAccess(ctx, application.ActivateEmergencyAccessInput{
		IncidentRef: "INC-1", Justification: "no break-glass permission",
		Permissions: []string{"clinical.read"}, TTL: time.Hour,
	})
	if got := categoryOf(t, err); got != rpcerr.CategoryPermissionDenied {
		t.Fatalf("want PermissionDenied, got %v", got)
	}
}

func TestActivationRefusesAnOverLongWindow(t *testing.T) {
	h := newHarness(t)
	_, err := h.svc.ActivateEmergencyAccess(h.clinician(), application.ActivateEmergencyAccessInput{
		IncidentRef: "INC-1", Justification: "a very long emergency indeed",
		Permissions: []string{"clinical.read"},
		TTL:         domain.MaxEmergencyGrantTTL + time.Minute,
	})
	if got := categoryOf(t, err); got != rpcerr.CategoryInvalidArgument {
		t.Fatalf("want InvalidArgument, got %v", got)
	}
}

// Stacking is what would defeat the TTL bound, and the refusal comes from the
// database's unique index rather than from a read this layer performs.
func TestSecondActivationIsRefusedWhileOneIsOpen(t *testing.T) {
	h := newHarness(t)
	ctx := h.clinician()
	activate(t, h, ctx)

	_, err := h.svc.ActivateEmergencyAccess(ctx, application.ActivateEmergencyAccessInput{
		IncidentRef: "INC-2", Justification: "a second emergency, same clinician",
		Permissions: []string{"clinical.read"}, TTL: time.Hour,
	})
	if got := categoryOf(t, err); got != rpcerr.CategoryFailedPrecondition {
		t.Fatalf("want FailedPrecondition for a stacked activation, got %v", got)
	}
}

func TestExerciseRecordsWhatWasOpened(t *testing.T) {
	h := newHarness(t)
	ctx := h.clinician()
	g := activate(t, h, ctx)

	h.clock.t = now.Add(10 * time.Minute)
	if err := h.svc.ExerciseEmergencyAccess(ctx, g.ID, "clinical.read", "patient/p1"); err != nil {
		t.Fatalf("ExerciseEmergencyAccess: %v", err)
	}

	// A permission outside the grant is refused even though the session holds
	// it: the grant, not the role, bounds what break glass may do.
	err := h.svc.ExerciseEmergencyAccess(ctx, g.ID, "clinical.write", "patient/p1")
	if got := categoryOf(t, err); got != rpcerr.CategoryPermissionDenied {
		t.Fatalf("want PermissionDenied outside the grant, got %v", got)
	}

	// Past the window, nothing more may be done under it.
	h.clock.t = now.Add(2 * time.Hour)
	err = h.svc.ExerciseEmergencyAccess(ctx, g.ID, "clinical.read", "patient/p2")
	if got := categoryOf(t, err); got != rpcerr.CategoryPermissionDenied {
		t.Fatalf("want PermissionDenied past expiry, got %v", got)
	}
}

// A colleague must not ride someone else's declaration: the review would
// attribute the access to the wrong person.
func TestAGrantBelongsToTheSubjectWhoActivatedIt(t *testing.T) {
	h := newHarness(t)
	g := activate(t, h, h.clinician())

	colleague := authctx.WithSession(context.Background(), authctx.Session{
		SubjectID: "dr-okafor", TenantID: h.tenant,
		Permissions:   []string{application.PermEmergencyActivate, "clinical.read"},
		CorrelationID: uuid.NewString(),
	})
	err := h.svc.ExerciseEmergencyAccess(colleague, g.ID, "clinical.read", "patient/p1")
	if got := categoryOf(t, err); got != rpcerr.CategoryNotFound {
		t.Fatalf("want NotFound for another subject's grant, got %v", got)
	}
}

func TestReviewClosesTheLoopAndRecordsAbuse(t *testing.T) {
	h := newHarness(t)
	ctx := h.clinician()
	g := activate(t, h, ctx)

	h.clock.t = now.Add(10 * time.Minute)
	if err := h.svc.ExerciseEmergencyAccess(ctx, g.ID, "clinical.read", "patient/p1"); err != nil {
		t.Fatalf("ExerciseEmergencyAccess: %v", err)
	}
	if err := h.svc.CloseEmergencyAccess(ctx, g.ID); err != nil {
		t.Fatalf("CloseEmergencyAccess: %v", err)
	}

	// The activator cannot sign off their own access.
	h.clock.t = now.Add(time.Hour)
	_, err := h.svc.ReviewEmergencyAccess(ctx, application.ReviewEmergencyAccessInput{
		GrantID: g.ID, Note: "nothing to see here",
	})
	if got := categoryOf(t, err); got != rpcerr.CategoryPermissionDenied {
		t.Fatalf("want PermissionDenied for self-review, got %v", got)
	}

	reviewed, err := h.svc.ReviewEmergencyAccess(h.reviewer(), application.ReviewEmergencyAccessInput{
		GrantID: g.ID,
		Note:    "opened a colleague's record, unrelated to the incident",
		Abused:  true,
	})
	if err != nil {
		t.Fatalf("ReviewEmergencyAccess: %v", err)
	}
	if reviewed.Status != domain.EmergencyReviewedAbused {
		t.Fatalf("want reviewed_abused, got %s", reviewed.Status)
	}

	// Abuse is a high-severity event, not merely a status somebody set.
	var severity, outcome string
	err = h.pool.QueryRow(context.Background(),
		`SELECT severity, outcome FROM security_platform.security_event
		 WHERE tenant_id = $1 AND resource_id = $2 AND sequence = 2`, h.tenant, g.ID).
		Scan(&severity, &outcome)
	if err != nil {
		t.Fatalf("no review event: %v", err)
	}
	if severity != string(domain.SeverityHigh) || outcome != string(domain.OutcomeFailure) {
		t.Fatalf("abuse recorded as severity=%s outcome=%s", severity, outcome)
	}
}

// A reviewer working promptly after expiry should not be told to come back
// later because a background sweeper has not run.
func TestReviewWorksOnAGrantTheSweeperHasNotSeen(t *testing.T) {
	h := newHarness(t)
	g := activate(t, h, h.clinician())

	h.clock.t = now.Add(2 * time.Hour) // past the window, sweeper not run
	reviewed, err := h.svc.ReviewEmergencyAccess(h.reviewer(), application.ReviewEmergencyAccessInput{
		GrantID: g.ID, Note: "access matched the incident",
	})
	if err != nil {
		t.Fatalf("ReviewEmergencyAccess: %v", err)
	}
	if reviewed.Status != domain.EmergencyReviewed {
		t.Fatalf("want reviewed, got %s", reviewed.Status)
	}
}

func TestGrantsAwaitingReviewNeedsThePermission(t *testing.T) {
	h := newHarness(t)
	if _, err := h.svc.GrantsAwaitingReview(h.clinician(), 10); categoryOf(t, err) != rpcerr.CategoryPermissionDenied {
		t.Fatal("a clinician listed the review queue")
	}
	if _, err := h.svc.GrantsAwaitingReview(h.reviewer(), 10); err != nil {
		t.Fatalf("reviewer: %v", err)
	}
}

func TestUnauthenticatedCallsAreRefused(t *testing.T) {
	h := newHarness(t)
	_, err := h.svc.ActivateEmergencyAccess(context.Background(), application.ActivateEmergencyAccessInput{
		IncidentRef: "INC-1", Justification: "no session at all",
		Permissions: []string{"clinical.read"}, TTL: time.Hour,
	})
	if got := categoryOf(t, err); got != rpcerr.CategoryUnauthenticated {
		t.Fatalf("want Unauthenticated, got %v", got)
	}
}
