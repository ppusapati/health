package domain_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/security/domain"
)

var base = time.Date(2026, 9, 11, 8, 0, 0, 0, time.UTC)

func heldPerms() []string {
	return []string{"clinical.read", "clinical.write"}
}

func newGrant(t *testing.T) domain.EmergencyGrant {
	t.Helper()
	g, err := domain.NewEmergencyGrant(
		"grant-1", "tenant-a", "dr-singh", "fac-1", "INC-2026-0412",
		"unconscious patient admitted from another facility", "corr-1",
		[]string{"clinical.read"}, heldPerms(), time.Hour, false, base)
	if err != nil {
		t.Fatalf("NewEmergencyGrant: %v", err)
	}
	return g
}

func TestEmergencyGrantRequiresJustificationAndIncident(t *testing.T) {
	cases := map[string]struct{ incident, justification string }{
		"no incident reference": {"", "unconscious patient in resus"},
		"no justification":      {"INC-1", ""},
		"terse justification":   {"INC-1", "urgent"},
	}
	for name, tc := range cases {
		t.Run(name, func(t *testing.T) {
			_, err := domain.NewEmergencyGrant("g", "t", "s", "f", tc.incident, tc.justification,
				"c", []string{"clinical.read"}, heldPerms(), time.Hour, false, base)
			if !errors.Is(err, domain.ErrInvalidEmergencyGrant) {
				t.Fatalf("want ErrInvalidEmergencyGrant, got %v", err)
			}
		})
	}
}

// The central control: break glass reaches further, it does not climb higher.
func TestEmergencyGrantCannotEscalatePrivilege(t *testing.T) {
	_, err := domain.NewEmergencyGrant("g", "t", "dr-singh", "f", "INC-1",
		"unconscious patient needs their medication history", "c",
		[]string{"clinical.read", "tenant.delete"}, heldPerms(), time.Hour, false, base)
	if !errors.Is(err, domain.ErrEscalation) {
		t.Fatalf("want ErrEscalation for a permission the subject never held, got %v", err)
	}
}

func TestEmergencyGrantRefusesToStack(t *testing.T) {
	_, err := domain.NewEmergencyGrant("g2", "t", "dr-singh", "f", "INC-2",
		"second emergency while the first is open", "c",
		[]string{"clinical.read"}, heldPerms(), time.Hour, true, base)
	if !errors.Is(err, domain.ErrGrantAlreadyActive) {
		t.Fatalf("want ErrGrantAlreadyActive, got %v", err)
	}
}

func TestEmergencyGrantTTLIsBounded(t *testing.T) {
	_, err := domain.NewEmergencyGrant("g", "t", "s", "f", "INC-1",
		"a very long emergency indeed", "c",
		[]string{"clinical.read"}, heldPerms(), domain.MaxEmergencyGrantTTL+time.Minute, false, base)
	if !errors.Is(err, domain.ErrInvalidEmergencyGrant) {
		t.Fatalf("want refusal of an over-long ttl, got %v", err)
	}
}

// A grant the sweeper has not yet marked expired must still be unusable.
// Otherwise the bound is only as tight as the background job's schedule.
func TestExpiredGrantIsUnusableBeforeTheSweeperRuns(t *testing.T) {
	g := newGrant(t)
	if err := g.Authorize("clinical.read", base.Add(30*time.Minute)); err != nil {
		t.Fatalf("within window: %v", err)
	}
	if g.Status != domain.EmergencyActive {
		t.Fatalf("precondition: status should still be active, got %s", g.Status)
	}
	if err := g.Authorize("clinical.read", base.Add(2*time.Hour)); !errors.Is(err, domain.ErrGrantNotActive) {
		t.Fatalf("want ErrGrantNotActive past expiry, got %v", err)
	}
}

func TestAuthorizeRefusesPermissionOutsideTheGrant(t *testing.T) {
	g := newGrant(t)
	if err := g.Authorize("clinical.write", base.Add(time.Minute)); !errors.Is(err, domain.ErrGrantNotActive) {
		t.Fatalf("want refusal of a permission outside the grant, got %v", err)
	}
}

func TestRecordedAccessIsTheReviewSubject(t *testing.T) {
	g := newGrant(t)
	at := base.Add(time.Minute)
	for _, ref := range []string{"patient/p1", "patient/p1", "patient/p2"} {
		if err := g.RecordAccess(ref, at); err != nil {
			t.Fatalf("RecordAccess(%s): %v", ref, err)
		}
	}
	if got := len(g.AccessedResources); got != 2 {
		t.Fatalf("want 2 distinct resources, got %d: %v", got, g.AccessedResources)
	}
	if err := g.RecordAccess("patient/p3", base.Add(2*time.Hour)); !errors.Is(err, domain.ErrGrantNotActive) {
		t.Fatalf("want refusal of access after expiry, got %v", err)
	}
}

func TestReviewClosesTheLoop(t *testing.T) {
	g := newGrant(t)
	if err := g.Review("chief-medical-officer", "reviewed the access log", false, base); err == nil {
		t.Fatal("want refusal of a review while the grant is still active")
	}
	if err := g.Close(base.Add(20 * time.Minute)); err != nil {
		t.Fatalf("Close: %v", err)
	}
	if err := g.Review("dr-singh", "nothing to see here", false, base.Add(time.Hour)); !errors.Is(err, domain.ErrSelfReview) {
		t.Fatalf("want ErrSelfReview, got %v", err)
	}
	if err := g.Review("chief-medical-officer", "access matched the incident", false, base.Add(time.Hour)); err != nil {
		t.Fatalf("Review: %v", err)
	}
	if g.Status != domain.EmergencyReviewed {
		t.Fatalf("want reviewed, got %s", g.Status)
	}
}

func TestAbuseIsADistinctOutcome(t *testing.T) {
	g := newGrant(t)
	_ = g.Close(base.Add(time.Minute))
	if err := g.Review("cmo", "opened a colleague's record, unrelated to the incident", true, base.Add(time.Hour)); err != nil {
		t.Fatalf("Review: %v", err)
	}
	if g.Status != domain.EmergencyReviewedAbused {
		t.Fatalf("want reviewed_abused, got %s", g.Status)
	}
}

func TestReviewBecomesOverdue(t *testing.T) {
	g := newGrant(t)
	g.Expire(base.Add(2 * time.Hour))
	if g.Status != domain.EmergencyExpired {
		t.Fatalf("want expired, got %s", g.Status)
	}
	if g.ReviewOverdue(base.Add(3 * time.Hour)) {
		t.Fatal("review is not overdue an hour after expiry")
	}
	if !g.ReviewOverdue(base.Add(domain.EmergencyReviewWindow + 24*time.Hour)) {
		t.Fatal("review should be overdue past the window")
	}
}

func TestExpireIsIdempotent(t *testing.T) {
	g := newGrant(t)
	g.Expire(base.Add(2 * time.Hour))
	first := g.ClosedAt
	g.Expire(base.Add(3 * time.Hour))
	if !g.ClosedAt.Equal(first) {
		t.Fatalf("second sweep moved ClosedAt from %s to %s", first, g.ClosedAt)
	}
}
