// Package slo computes service level objectives from request outcomes.
//
// SRS-NFR-001 targets 99.95% monthly availability "excluding contractually
// defined maintenance", verified by "SLO dashboard computes monthly
// availability from agreed indicator". Two phrases there are the whole
// problem, and getting either wrong produces a number that is precise and
// meaningless.
//
// "From the agreed indicator" rules out uptime as measured by a pinger. A
// health check answering 200 while every clinical request fails is a system
// that is down, and its availability by ping is 100%. The indicator here is
// the proportion of *real requests* that succeeded, which is what a user
// experiences.
//
// "Excluding contractually defined maintenance" has to mean a declared window
// with a start and an end, agreed beforehand. Excluding an outage after the
// fact by calling it maintenance is how an SLO stops meaning anything, so a
// window here cannot be opened retroactively.
package slo

import (
	"errors"
	"fmt"
	"sort"
	"time"
)

// Outcome classifies one request for SLO purposes.
type Outcome string

const (
	// OutcomeGood is a request the service handled as intended, including one
	// it correctly refused: a 403 to a caller without permission is the system
	// working.
	OutcomeGood Outcome = "good"
	// OutcomeBad is a request the service failed to serve — an internal error,
	// a timeout, a dependency it could not reach.
	OutcomeBad Outcome = "bad"
	// OutcomeExcluded is outside the indicator entirely: a client that hung up,
	// a request refused by rate limiting after a caller exceeded its own quota.
	// Counting these as bad would let one misbehaving integration consume the
	// error budget for a whole hospital.
	OutcomeExcluded Outcome = "excluded"
)

// Classify maps a request result onto the indicator.
//
// The mapping is the agreed indicator, so it lives in one place and is
// testable. The judgement calls it encodes:
//
//   - A refusal the service intended — unauthenticated, forbidden, not found,
//     invalid argument, failed precondition — is good. The service answered
//     correctly; counting it against availability would mean a security probe
//     could spend the error budget.
//   - A cancelled request is excluded: nobody was waiting, so nobody
//     experienced an outage.
//   - Rate limiting is excluded for the same reason it exists — it is the
//     system protecting itself, and the caller being limited is the caller
//     that caused it.
//   - Everything else, including a deadline the service failed to meet, is
//     bad.
func Classify(statusCode string) Outcome {
	switch statusCode {
	case "ok", "unauthenticated", "permission_denied", "not_found",
		"invalid_argument", "failed_precondition", "already_exists", "aborted":
		return OutcomeGood
	case "canceled", "resource_exhausted":
		return OutcomeExcluded
	default:
		// internal, unavailable, deadline_exceeded, data_loss, unknown.
		return OutcomeBad
	}
}

// MaintenanceWindow is a period excluded from the calculation.
type MaintenanceWindow struct {
	// ID references the change record the window was agreed under, so the
	// exclusion can be audited against something.
	ID    string
	Start time.Time
	End   time.Time
	// DeclaredAt is when the window was agreed. It must precede Start: a
	// window declared after the fact is an outage being relabelled.
	DeclaredAt time.Time
	Reason     string
}

// ErrInvalidWindow reports a maintenance window that must not be honoured.
var ErrInvalidWindow = errors.New("slo: invalid maintenance window")

// NewMaintenanceWindow validates a declared window.
func NewMaintenanceWindow(id string, declaredAt, start, end time.Time, reason string) (MaintenanceWindow, error) {
	switch {
	case id == "":
		return MaintenanceWindow{}, fmt.Errorf("%w: a change reference is required", ErrInvalidWindow)
	case !end.After(start):
		return MaintenanceWindow{}, fmt.Errorf("%w: end is not after start", ErrInvalidWindow)
	case reason == "":
		return MaintenanceWindow{}, fmt.Errorf("%w: a reason is required", ErrInvalidWindow)
	case !declaredAt.Before(start):
		// The rule that keeps the SLO honest. Excluding an outage after the
		// fact by calling it maintenance is how an availability target stops
		// meaning anything.
		return MaintenanceWindow{}, fmt.Errorf(
			"%w: declared at %s, which is not before the window start %s — a window "+
				"declared after the fact is an outage being relabelled",
			ErrInvalidWindow, declaredAt.UTC().Format(time.RFC3339), start.UTC().Format(time.RFC3339))
	}
	return MaintenanceWindow{
		ID: id, Start: start.UTC(), End: end.UTC(),
		DeclaredAt: declaredAt.UTC(), Reason: reason,
	}, nil
}

// Covers reports whether an instant falls inside the window.
func (w MaintenanceWindow) Covers(at time.Time) bool {
	t := at.UTC()
	return !t.Before(w.Start) && t.Before(w.End)
}

// Sample is one request's contribution to the indicator.
type Sample struct {
	At      time.Time
	Outcome Outcome
	// Latency is used for the latency objective (SRS-NFR-002); zero for
	// samples that only feed availability.
	Latency time.Duration
}

// Report is a period's SLO computation.
type Report struct {
	From, To time.Time
	// Good and Bad are the counts the indicator is computed from.
	Good, Bad int
	// Excluded counts samples outside the indicator, reported so a reviewer can
	// see that the exclusion is not hiding a problem: a sudden rise in
	// cancelled requests is itself a signal.
	Excluded int
	// InMaintenance counts samples dropped by a declared window.
	InMaintenance int

	// Availability is good / (good + bad), or 1 when there were no eligible
	// requests.
	Availability float64
	// Target is the objective this period was measured against.
	Target float64
	Met    bool

	// ErrorBudgetRemaining is the fraction of the period's allowed failures
	// still unspent. Negative means the budget is overspent, which is the
	// number that decides whether a risky change ships this month.
	ErrorBudgetRemaining float64

	// LatencyP95 across the samples that carried one.
	LatencyP95 time.Duration
}

// DefaultAvailabilityTarget is SRS-NFR-001's premium profile.
const DefaultAvailabilityTarget = 0.9995

// Compute produces the report for a period.
//
// Samples outside [from, to) are ignored rather than silently included, so a
// caller passing a wider query than it meant gets the period it asked for.
func Compute(samples []Sample, windows []MaintenanceWindow, from, to time.Time, target float64) Report {
	report := Report{From: from.UTC(), To: to.UTC(), Target: target}

	var latencies []time.Duration

	for _, s := range samples {
		at := s.At.UTC()
		if at.Before(report.From) || !at.Before(report.To) {
			continue
		}

		inMaintenance := false
		for _, w := range windows {
			if w.Covers(at) {
				inMaintenance = true
				break
			}
		}
		if inMaintenance {
			report.InMaintenance++
			continue
		}

		switch s.Outcome {
		case OutcomeGood:
			report.Good++
		case OutcomeBad:
			report.Bad++
		case OutcomeExcluded:
			report.Excluded++
			continue
		}
		if s.Latency > 0 {
			latencies = append(latencies, s.Latency)
		}
	}

	eligible := report.Good + report.Bad
	if eligible == 0 {
		// No traffic is not an outage. Reporting 0% availability for a quiet
		// hour would make the monthly number depend on when people used the
		// system rather than on whether it worked.
		report.Availability = 1
	} else {
		report.Availability = float64(report.Good) / float64(eligible)
	}

	report.Met = report.Availability >= target
	if allowedFailureRate := 1 - target; allowedFailureRate > 0 {
		actualFailureRate := 1 - report.Availability
		report.ErrorBudgetRemaining = (allowedFailureRate - actualFailureRate) / allowedFailureRate
	}
	report.LatencyP95 = percentile(latencies, 0.95)
	return report
}

// percentile returns the nearest-rank percentile of a latency set.
//
// Nearest-rank rather than interpolated: an interpolated p95 reports a latency
// no request actually experienced, and when somebody asks which request was
// that slow there is no answer.
func percentile(values []time.Duration, p float64) time.Duration {
	if len(values) == 0 {
		return 0
	}
	sorted := make([]time.Duration, len(values))
	copy(sorted, values)
	sort.Slice(sorted, func(i, j int) bool { return sorted[i] < sorted[j] })

	rank := int(float64(len(sorted))*p + 0.999999)
	if rank < 1 {
		rank = 1
	}
	if rank > len(sorted) {
		rank = len(sorted)
	}
	return sorted[rank-1]
}

// MonthlyBudget is how much downtime a target permits in a 30-day month.
//
// Useful because "99.95%" means nothing to most people and "21 minutes a
// month" means a great deal.
func MonthlyBudget(target float64) time.Duration {
	const month = 30 * 24 * time.Hour
	return time.Duration((1 - target) * float64(month))
}
