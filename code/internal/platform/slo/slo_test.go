package slo_test

import (
	"errors"
	"testing"
	"time"

	"github.com/ppusapati/health/code/internal/platform/slo"
)

var monthStart = time.Date(2026, 9, 1, 0, 0, 0, 0, time.UTC)
var monthEnd = time.Date(2026, 10, 1, 0, 0, 0, 0, time.UTC)

func samples(n int, outcome slo.Outcome, at time.Time) []slo.Sample {
	out := make([]slo.Sample, n)
	for i := range out {
		out[i] = slo.Sample{At: at.Add(time.Duration(i) * time.Second), Outcome: outcome}
	}
	return out
}

// SRS-NFR-001's verification clause: the dashboard computes monthly
// availability from the agreed indicator.
// SRS-NFR-006's verification clause: an operator can identify a failing
// dependency or workflow from what the system exposes. Availability is
// computed from real served requests rather than from a probe, so a service
// that answers a health check while failing its callers is not reported up.
func TestMonthlyAvailabilityFromRealRequests(t *testing.T) {
	good := samples(9995, slo.OutcomeGood, monthStart)
	bad := samples(5, slo.OutcomeBad, monthStart.Add(time.Hour))

	report := slo.Compute(append(good, bad...), nil, monthStart, monthEnd, slo.DefaultAvailabilityTarget)

	if report.Good != 9995 || report.Bad != 5 {
		t.Fatalf("counts: good=%d bad=%d", report.Good, report.Bad)
	}
	if report.Availability != 0.9995 {
		t.Fatalf("availability %.6f, want 0.9995", report.Availability)
	}
	if !report.Met {
		t.Fatal("exactly meeting the target was reported as a miss")
	}
}

// A refusal the service intended is the system working. Counting it against
// availability would let a security probe spend the error budget.
func TestIntendedRefusalsAreNotOutages(t *testing.T) {
	for _, status := range []string{
		"ok", "permission_denied", "not_found", "unauthenticated",
		"invalid_argument", "failed_precondition",
	} {
		if got := slo.Classify(status); got != slo.OutcomeGood {
			t.Errorf("Classify(%s) = %s, want good", status, got)
		}
	}
	for _, status := range []string{"internal", "unavailable", "deadline_exceeded", "unknown"} {
		if got := slo.Classify(status); got != slo.OutcomeBad {
			t.Errorf("Classify(%s) = %s, want bad", status, got)
		}
	}
	// Nobody was waiting for a cancelled request, and a rate-limited caller is
	// the caller that caused it — neither is an outage anyone experienced.
	for _, status := range []string{"canceled", "resource_exhausted"} {
		if got := slo.Classify(status); got != slo.OutcomeExcluded {
			t.Errorf("Classify(%s) = %s, want excluded", status, got)
		}
	}
}

func TestExcludedSamplesDoNotMoveTheNumberButAreReported(t *testing.T) {
	mixed := append(samples(100, slo.OutcomeGood, monthStart),
		samples(50, slo.OutcomeExcluded, monthStart.Add(time.Hour))...)

	report := slo.Compute(mixed, nil, monthStart, monthEnd, slo.DefaultAvailabilityTarget)

	if report.Availability != 1 {
		t.Fatalf("excluded samples moved availability to %.4f", report.Availability)
	}
	// Reported anyway: a sudden rise in cancelled requests is itself a signal,
	// and hiding it is how an exclusion becomes a blind spot.
	if report.Excluded != 50 {
		t.Fatalf("excluded count %d, want 50", report.Excluded)
	}
}

// The rule that keeps the SLO honest.
func TestMaintenanceCannotBeDeclaredAfterTheFact(t *testing.T) {
	outage := monthStart.Add(10 * 24 * time.Hour)

	_, err := slo.NewMaintenanceWindow("CHG-1",
		outage.Add(time.Hour), // declared after it started
		outage, outage.Add(2*time.Hour), "database upgrade")
	if !errors.Is(err, slo.ErrInvalidWindow) {
		t.Fatalf("a retroactive window was accepted: %v", err)
	}

	// Declared beforehand, it is honoured.
	window, err := slo.NewMaintenanceWindow("CHG-1",
		outage.Add(-48*time.Hour), outage, outage.Add(2*time.Hour), "database upgrade")
	if err != nil {
		t.Fatalf("NewMaintenanceWindow: %v", err)
	}
	if !window.Covers(outage.Add(time.Hour)) {
		t.Fatal("the window does not cover its own middle")
	}
}

func TestDeclaredMaintenanceIsExcluded(t *testing.T) {
	outage := monthStart.Add(10 * 24 * time.Hour)
	window, err := slo.NewMaintenanceWindow("CHG-1",
		outage.Add(-48*time.Hour), outage, outage.Add(2*time.Hour), "database upgrade")
	if err != nil {
		t.Fatalf("NewMaintenanceWindow: %v", err)
	}

	all := append(samples(1000, slo.OutcomeGood, monthStart),
		// Everything failed during the window, as it would during an upgrade.
		samples(500, slo.OutcomeBad, outage)...)

	report := slo.Compute(all, []slo.MaintenanceWindow{window}, monthStart, monthEnd,
		slo.DefaultAvailabilityTarget)

	if report.InMaintenance != 500 {
		t.Fatalf("in-maintenance count %d, want 500", report.InMaintenance)
	}
	if report.Bad != 0 {
		t.Fatalf("maintenance failures counted against the SLO: bad=%d", report.Bad)
	}
	if !report.Met {
		t.Fatal("a month with only maintenance downtime missed the target")
	}
}

// A failure outside the window still counts, even if a window exists that
// month — otherwise declaring one window would excuse the whole month.
func TestFailuresOutsideTheWindowStillCount(t *testing.T) {
	outage := monthStart.Add(10 * 24 * time.Hour)
	window, err := slo.NewMaintenanceWindow("CHG-1",
		outage.Add(-48*time.Hour), outage, outage.Add(2*time.Hour), "upgrade")
	if err != nil {
		t.Fatalf("NewMaintenanceWindow: %v", err)
	}

	all := append(samples(100, slo.OutcomeGood, monthStart),
		samples(100, slo.OutcomeBad, monthStart.Add(20*24*time.Hour))...)

	report := slo.Compute(all, []slo.MaintenanceWindow{window}, monthStart, monthEnd,
		slo.DefaultAvailabilityTarget)
	if report.Bad != 100 {
		t.Fatalf("bad=%d; a declared window excused a failure outside it", report.Bad)
	}
	if report.Met {
		t.Fatal("a 50% month met a 99.95% target")
	}
}

// The number that decides whether a risky change ships this month.
func TestErrorBudget(t *testing.T) {
	// A perfect month has its whole budget.
	perfect := slo.Compute(samples(10000, slo.OutcomeGood, monthStart), nil,
		monthStart, monthEnd, slo.DefaultAvailabilityTarget)
	if perfect.ErrorBudgetRemaining < 0.999 {
		t.Fatalf("a perfect month has %.4f budget left", perfect.ErrorBudgetRemaining)
	}

	// Exactly at target: budget exhausted, not overspent.
	exact := slo.Compute(append(samples(9995, slo.OutcomeGood, monthStart),
		samples(5, slo.OutcomeBad, monthStart)...), nil,
		monthStart, monthEnd, slo.DefaultAvailabilityTarget)
	if exact.ErrorBudgetRemaining > 0.0001 || exact.ErrorBudgetRemaining < -0.0001 {
		t.Fatalf("at target the budget should be ~0, got %.4f", exact.ErrorBudgetRemaining)
	}

	// Over target: negative, which is the signal to stop shipping risk.
	over := slo.Compute(append(samples(9000, slo.OutcomeGood, monthStart),
		samples(1000, slo.OutcomeBad, monthStart)...), nil,
		monthStart, monthEnd, slo.DefaultAvailabilityTarget)
	if over.ErrorBudgetRemaining >= 0 {
		t.Fatalf("an overspent month reported %.4f budget remaining", over.ErrorBudgetRemaining)
	}
}

// No traffic is not an outage. Reporting 0% for a quiet hour would make the
// monthly number depend on when people used the system.
func TestAQuietPeriodIsNotAnOutage(t *testing.T) {
	report := slo.Compute(nil, nil, monthStart, monthEnd, slo.DefaultAvailabilityTarget)
	if report.Availability != 1 || !report.Met {
		t.Fatalf("an empty period reported %.4f", report.Availability)
	}
}

func TestSamplesOutsideThePeriodAreIgnored(t *testing.T) {
	// A caller passing a wider query than it meant gets the period it asked
	// for rather than a silently different one.
	all := append(samples(100, slo.OutcomeGood, monthStart),
		samples(100, slo.OutcomeBad, monthStart.Add(-48*time.Hour))...)

	report := slo.Compute(all, nil, monthStart, monthEnd, slo.DefaultAvailabilityTarget)
	if report.Bad != 0 {
		t.Fatalf("a sample from before the period was counted: bad=%d", report.Bad)
	}
}

// SRS-NFR-002: p95 under 400ms. Nearest-rank, so the reported figure is a
// latency some request actually experienced.
func TestLatencyP95(t *testing.T) {
	var withLatency []slo.Sample
	for i := range 100 {
		withLatency = append(withLatency, slo.Sample{
			At:      monthStart.Add(time.Duration(i) * time.Second),
			Outcome: slo.OutcomeGood,
			Latency: time.Duration(i+1) * time.Millisecond,
		})
	}

	report := slo.Compute(withLatency, nil, monthStart, monthEnd, slo.DefaultAvailabilityTarget)
	if report.LatencyP95 != 95*time.Millisecond {
		t.Fatalf("p95 = %v, want 95ms", report.LatencyP95)
	}
	// A value from the set, not an interpolation nobody experienced.
	if report.LatencyP95%time.Millisecond != 0 {
		t.Fatalf("p95 %v is not one of the observed latencies", report.LatencyP95)
	}
}

func TestMonthlyBudgetIsLegible(t *testing.T) {
	// "99.95%" means nothing to most people; "21 minutes" means a great deal.
	budget := slo.MonthlyBudget(slo.DefaultAvailabilityTarget)
	if budget < 21*time.Minute || budget > 22*time.Minute {
		t.Fatalf("a 99.95%% month allows %v, expected about 21m36s", budget)
	}
}

func TestMaintenanceWindowValidation(t *testing.T) {
	at := monthStart.Add(24 * time.Hour)
	cases := map[string]func() error{
		"no change reference": func() error {
			_, err := slo.NewMaintenanceWindow("", at.Add(-time.Hour), at, at.Add(time.Hour), "upgrade")
			return err
		},
		"end before start": func() error {
			_, err := slo.NewMaintenanceWindow("CHG-1", at.Add(-time.Hour), at, at.Add(-time.Hour), "upgrade")
			return err
		},
		"no reason": func() error {
			_, err := slo.NewMaintenanceWindow("CHG-1", at.Add(-time.Hour), at, at.Add(time.Hour), "")
			return err
		},
	}
	for name, build := range cases {
		t.Run(name, func(t *testing.T) {
			if err := build(); !errors.Is(err, slo.ErrInvalidWindow) {
				t.Fatalf("want ErrInvalidWindow, got %v", err)
			}
		})
	}
}
