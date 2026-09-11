package application_test

import (
	"context"
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/ppusapati/health/code/internal/platform/authctx"
	"github.com/ppusapati/health/code/internal/security/application"
	"github.com/ppusapati/health/code/internal/security/domain"
	"github.com/ppusapati/health/code/internal/security/ports"
)

func days(n int32) *int32 { return &n }

func (h harness) retentionPorts(t *testing.T) application.RetentionPorts {
	t.Helper()
	return application.RetentionPorts{Retention: h.repo, Holds: h.repo}
}

func (h harness) steward() context.Context {
	return authctx.WithSession(context.Background(), authctx.Session{
		SubjectID: "data-steward", TenantID: h.tenant,
		Permissions:   []string{"security.retention.manage"},
		CorrelationID: uuid.NewString(),
	})
}

func seedClass(t *testing.T, h harness, name string, retainDays *int32) {
	t.Helper()
	ctx := h.steward()
	session, _ := authctx.FromContext(ctx)
	class := domain.RetentionClass{
		ID: uuid.NewString(), TenantID: h.tenant, Name: name,
		DataClass: "clinical", RetainDays: retainDays,
		CreatedAt: now, UpdatedAt: now,
	}
	if err := h.repo.InsertClass(ctx, session.TenantScope(), class); err != nil {
		t.Fatalf("InsertClass: %v", err)
	}
}

func placeHold(t *testing.T, h harness, resourceType, resourceID string) {
	t.Helper()
	ctx := h.steward()
	session, _ := authctx.FromContext(ctx)
	placed, err := h.repo.Place(ctx, session.TenantScope(), domain.LegalHold{
		ID: uuid.NewString(), TenantID: h.tenant,
		ResourceType: resourceType, ResourceID: resourceID,
		Reason: "litigation hold, matter 2026-11", PlacedBy: "legal-counsel", PlacedAt: now,
	})
	if err != nil {
		t.Fatalf("Place: %v", err)
	}
	if !placed {
		t.Fatal("the hold was not placed")
	}
}

// SRS-DAT-009's verification clause, exactly: the deletion job skips
// legal-held records. The held record's retention period has long expired, so
// only the hold keeps it.
func TestSweepSkipsLegalHeldRecords(t *testing.T) {
	h := newHarness(t)
	seedClass(t, h, "clinical-7y", days(30))

	held := application.Candidate{ResourceType: "encounter", ResourceID: "enc-held", CreatedAt: now.Add(-365 * 24 * time.Hour)}
	free := application.Candidate{ResourceType: "encounter", ResourceID: "enc-free", CreatedAt: now.Add(-365 * 24 * time.Hour)}
	young := application.Candidate{ResourceType: "encounter", ResourceID: "enc-young", CreatedAt: now.Add(-24 * time.Hour)}

	placeHold(t, h, "encounter", "enc-held")

	h.clock.t = now
	report, err := h.svc.EvaluateRetention(h.steward(), h.retentionPorts(t), "clinical-7y",
		[]application.Candidate{held, free, young})
	if err != nil {
		t.Fatalf("EvaluateRetention: %v", err)
	}

	if report.Considered != 3 {
		t.Fatalf("considered %d, want 3", report.Considered)
	}
	if report.Held != 1 {
		t.Fatalf("held %d, want 1", report.Held)
	}
	if report.Deletable != 1 {
		t.Fatalf("deletable %d, want 1 (only the unheld expired record)", report.Deletable)
	}
	if report.Retained != 1 {
		t.Fatalf("retained %d, want 1 (the record still inside its period)", report.Retained)
	}

	for _, c := range report.Deletions() {
		if c.ResourceID == "enc-held" {
			t.Fatal("a legal-held record was cleared for deletion")
		}
	}

	// The reason is recorded, not just the verdict: a reviewer asking why a
	// record survived needs "UNDER_LEGAL_HOLD" rather than "not deleted".
	var reason string
	for _, o := range report.Outcomes {
		if o.Candidate.ResourceID == "enc-held" {
			reason = o.Reason
		}
	}
	if reason != domain.ReasonLegalHeld {
		t.Fatalf("held record's reason was %q, want %q", reason, domain.ReasonLegalHeld)
	}
}

// Releasing a hold lets the record become deletable, which is the other half of
// the control working: a hold that could never be lifted would be a retention
// policy, not a hold.
func TestReleasingAHoldMakesARecordDeletable(t *testing.T) {
	h := newHarness(t)
	seedClass(t, h, "clinical-7y", days(30))
	placeHold(t, h, "encounter", "enc-1")

	candidate := application.Candidate{
		ResourceType: "encounter", ResourceID: "enc-1",
		CreatedAt: now.Add(-365 * 24 * time.Hour),
	}
	ctx := h.steward()

	report, err := h.svc.EvaluateRetention(ctx, h.retentionPorts(t), "clinical-7y",
		[]application.Candidate{candidate})
	if err != nil {
		t.Fatalf("EvaluateRetention: %v", err)
	}
	if report.Deletable != 0 {
		t.Fatal("a held record was deletable")
	}

	session, _ := authctx.FromContext(ctx)
	released, err := h.repo.Release(ctx, session.TenantScope(), "encounter", "enc-1", "legal-counsel", now)
	if err != nil {
		t.Fatalf("Release: %v", err)
	}
	if !released {
		t.Fatal("the hold was not released")
	}

	report, err = h.svc.EvaluateRetention(ctx, h.retentionPorts(t), "clinical-7y",
		[]application.Candidate{candidate})
	if err != nil {
		t.Fatalf("EvaluateRetention: %v", err)
	}
	if report.Deletable != 1 {
		t.Fatalf("after release, deletable = %d, want 1", report.Deletable)
	}
}

// A class with no retention period means "keep indefinitely", and that must
// never be read as "keep for zero days".
func TestIndefiniteRetentionDeletesNothing(t *testing.T) {
	h := newHarness(t)
	seedClass(t, h, "legal-indefinite", nil)

	report, err := h.svc.EvaluateRetention(h.steward(), h.retentionPorts(t), "legal-indefinite",
		[]application.Candidate{{
			ResourceType: "encounter", ResourceID: "enc-1",
			CreatedAt: now.Add(-10 * 365 * 24 * time.Hour),
		}})
	if err != nil {
		t.Fatalf("EvaluateRetention: %v", err)
	}
	if report.Deletable != 0 {
		t.Fatal("a record under indefinite retention was cleared for deletion")
	}
	if report.Outcomes[0].Reason != domain.ReasonIndefinite {
		t.Fatalf("reason %q, want %q", report.Outcomes[0].Reason, domain.ReasonIndefinite)
	}
}

// failingHolds makes the hold lookup fail, which is the failure this design
// exists to survive: proceeding with an empty exclusion set would delete held
// records while reporting success.
type failingHolds struct{ ports.LegalHoldStore }

func (failingHolds) HeldResourceIDs(context.Context, authctx.TenantScope, string) ([]string, error) {
	return nil, errors.New("legal hold store unavailable")
}

func TestSweepAbortsWhenHoldsCannotBeRead(t *testing.T) {
	h := newHarness(t)
	seedClass(t, h, "clinical-7y", days(30))

	_, err := h.svc.EvaluateRetention(h.steward(), application.RetentionPorts{
		Retention: h.repo,
		Holds:     failingHolds{h.repo},
	}, "clinical-7y", []application.Candidate{{
		ResourceType: "encounter", ResourceID: "enc-1",
		CreatedAt: now.Add(-365 * 24 * time.Hour),
	}})

	if err == nil {
		t.Fatal("the sweep completed without knowing which records were held")
	}
	if !strings.Contains(err.Error(), "legal holds") {
		t.Fatalf("the error does not name the cause: %v", err)
	}
}

// The sweep is an auditable act, so it leaves a security event even when it
// decides nothing may be deleted.
func TestSweepRecordsASecurityEvent(t *testing.T) {
	h := newHarness(t)
	seedClass(t, h, "clinical-7y", days(30))

	if _, err := h.svc.EvaluateRetention(h.steward(), h.retentionPorts(t), "clinical-7y", nil); err != nil {
		t.Fatalf("EvaluateRetention: %v", err)
	}

	var class string
	err := h.pool.QueryRow(context.Background(),
		`SELECT event_class FROM security_platform.security_event
		 WHERE tenant_id = $1 AND resource_id = $2`, h.tenant, "clinical-7y").Scan(&class)
	if err != nil {
		t.Fatalf("no security event for the sweep: %v", err)
	}
	if class != domain.ClassRetentionChange {
		t.Fatalf("event class %q, want %q", class, domain.ClassRetentionChange)
	}
}

// Holds are tenant-scoped like everything else: one tenant's hold must not
// keep another tenant's record alive, and must not be invisible to its own.
func TestHoldsAreTenantScoped(t *testing.T) {
	h := newHarness(t)
	seedClass(t, h, "clinical-7y", days(30))
	placeHold(t, h, "encounter", "enc-1")

	// A different tenant with the same class name and the same resource id.
	otherTenant := uuid.NewString()
	otherCtx := authctx.WithSession(context.Background(), authctx.Session{
		SubjectID: "steward", TenantID: otherTenant,
		Permissions: []string{"security.retention.manage"}, CorrelationID: uuid.NewString(),
	})
	otherSession, _ := authctx.FromContext(otherCtx)
	if err := h.repo.InsertClass(otherCtx, otherSession.TenantScope(), domain.RetentionClass{
		ID: uuid.NewString(), TenantID: otherTenant, Name: "clinical-7y",
		DataClass: "clinical", RetainDays: days(30), CreatedAt: now, UpdatedAt: now,
	}); err != nil {
		t.Fatalf("InsertClass: %v", err)
	}

	report, err := h.svc.EvaluateRetention(otherCtx, h.retentionPorts(t), "clinical-7y",
		[]application.Candidate{{
			ResourceType: "encounter", ResourceID: "enc-1",
			CreatedAt: now.Add(-365 * 24 * time.Hour),
		}})
	if err != nil {
		t.Fatalf("EvaluateRetention: %v", err)
	}
	// The other tenant's hold is not this tenant's business.
	if report.Held != 0 {
		t.Fatal("another tenant's legal hold blocked this tenant's deletion")
	}
	if report.Deletable != 1 {
		t.Fatalf("deletable %d, want 1", report.Deletable)
	}
}
