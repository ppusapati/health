package domain

import (
	"sort"
	"strings"
	"time"
)

// Cashier shifts and revenue integrity (SRS-BIL-015, SRS-BIL-011).
//
// Two requirements that look administrative and are not. A shift that does not
// reconcile is the only place a hospital finds out cash is going missing, and
// an unbilled completed service is the commonest form of revenue leak there is
// — usually not theft but a procedure nobody coded.

// ShiftStatus is where a cashier's session stands.
type ShiftStatus string

const (
	ShiftOpen ShiftStatus = "open"
	// ShiftReconciled is counted and balanced, or counted and explained.
	ShiftReconciled ShiftStatus = "reconciled"
	// ShiftPendingApproval is counted, out by more than the threshold, and
	// waiting on a supervisor.
	ShiftPendingApproval ShiftStatus = "pending_approval"
)

var knownShiftStatuses = map[ShiftStatus]bool{
	ShiftOpen: true, ShiftReconciled: true, ShiftPendingApproval: true,
}

// Shift is one cashier's session at one drawer (SRS-BIL-015).
type Shift struct {
	ID       string
	TenantID string

	FacilityID string
	// CounterID is the physical desk. Two cashiers at one counter on one shift
	// is how a variance becomes unattributable, which is why the open is
	// exclusive per counter at the table.
	CounterID string
	CashierID string

	OpeningFloat Money
	OpenedAt     time.Time

	// CountedCash is what the cashier physically counted at close. Distinct
	// from what the system expected, because the whole exercise is the
	// difference between the two.
	CountedCash Money
	// ExpectedCash is the opening float plus the cash movements recorded during
	// the shift. Computed from the ledger rather than typed, so a cashier
	// cannot make the count agree by adjusting the expectation.
	ExpectedCash Money
	Variance     Money

	Status ShiftStatus
	// VarianceReason is required wherever the count did not agree. Required at
	// any non-zero variance rather than only beyond the threshold: a shift
	// short by ten rupees every day is a pattern, and one that is never
	// explained is a pattern nobody sees.
	VarianceReason string
	ApprovedBy     string
	ApprovedAt     time.Time

	ClosedAt time.Time
	Version  int64
}

// VarianceThreshold is what a cashier may explain without a supervisor
// (SRS-BIL-015).
type VarianceThreshold struct {
	// MaxMinor is the absolute variance a reason alone settles. Beyond it, a
	// supervisor approves.
	MaxMinor int64
}

// DefaultVarianceThreshold allows a hundred minor units — a rupee, a dollar —
// to be explained by the cashier.
//
// Small on purpose. The point of a threshold is to keep a supervisor from being
// called for rounding while making sure anything that could be a real loss
// reaches one, and a generous threshold is a threshold that hides exactly the
// amounts worth finding.
func DefaultVarianceThreshold() VarianceThreshold {
	return VarianceThreshold{MaxMinor: 100}
}

// OpenShift starts a cashier's session (SRS-BIL-015).
func OpenShift(id, tenantID, facilityID, counterID, cashierID string,
	openingFloat Money, now time.Time) (*Shift, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return nil, invalidf("a shift needs an identifier")
	case strings.TrimSpace(facilityID) == "":
		return nil, invalidf("a shift needs a facility")
	case strings.TrimSpace(counterID) == "":
		return nil, invalidf("a shift needs a counter")
	case strings.TrimSpace(cashierID) == "":
		return nil, invalidf("a shift needs a cashier")
	case openingFloat.Minor < 0:
		return nil, invalidf("an opening float cannot be negative")
	}
	if err := openingFloat.Validate(); err != nil {
		return nil, err
	}

	return &Shift{
		ID: id, TenantID: tenantID,
		FacilityID:   strings.TrimSpace(facilityID),
		CounterID:    strings.TrimSpace(counterID),
		CashierID:    strings.TrimSpace(cashierID),
		OpeningFloat: openingFloat, OpenedAt: now.UTC(),
		Status: ShiftOpen, Version: 1,
	}, nil
}

// ExpectedCashFor computes what a drawer should hold (SRS-BIL-015).
//
// The opening float plus every cash movement recorded against the shift.
// Computed from the ledger rather than typed in, so a cashier cannot make the
// count agree by adjusting what was expected.
func ExpectedCashFor(openingFloat Money, entries []LedgerEntry) (Money, error) {
	total := openingFloat
	for _, entry := range entries {
		if !entry.Method.Cash() {
			continue
		}
		// Ledger amounts are signed against the patient's balance: money in is
		// negative. In the drawer it is the other way round.
		next, err := total.Add(entry.Amount.Negate())
		if err != nil {
			return Money{}, err
		}
		total = next
	}
	return total, nil
}

// Close counts the drawer and reports what happens next (SRS-BIL-015).
//
// A zero variance reconciles. A variance within the threshold reconciles with a
// reason. Anything beyond it goes to a supervisor, which is the acceptance
// criterion: "variance requires reason and approval per threshold".
func (s *Shift) Close(counted, expected Money, reason string,
	threshold VarianceThreshold, now time.Time) error {

	if s.Status != ShiftOpen {
		return notAllowedf("this shift is already %s", s.Status)
	}
	if err := counted.Validate(); err != nil {
		return err
	}
	if counted.Minor < 0 {
		return invalidf("a counted amount cannot be negative")
	}

	variance, err := counted.Sub(expected)
	if err != nil {
		return err
	}

	if variance.Minor != 0 && strings.TrimSpace(reason) == "" {
		// Any variance, not only a large one. A drawer short by ten rupees
		// every day is a pattern, and one nobody has to explain is a pattern
		// nobody sees.
		return invalidf("a variance of %s needs a reason", variance)
	}

	s.CountedCash = counted
	s.ExpectedCash = expected
	s.Variance = variance
	s.VarianceReason = strings.TrimSpace(reason)
	s.ClosedAt = now.UTC()
	s.Version++

	if abs(variance.Minor) > threshold.MaxMinor {
		s.Status = ShiftPendingApproval
		return nil
	}
	s.Status = ShiftReconciled
	return nil
}

// Approve settles a shift a supervisor has reviewed (SRS-BIL-015).
func (s *Shift) Approve(by string, now time.Time) error {
	if s.Status != ShiftPendingApproval {
		return notAllowedf("only a shift pending approval can be approved; this one is %s",
			s.Status)
	}
	if strings.TrimSpace(by) == "" {
		return invalidf("an approval needs the supervisor giving it")
	}
	if strings.EqualFold(strings.TrimSpace(by), s.CashierID) {
		// A cashier approving their own variance is the control absent with a
		// record saying it happened.
		return notAllowedf("a cashier cannot approve their own variance")
	}

	s.Status = ShiftReconciled
	s.ApprovedBy = strings.TrimSpace(by)
	s.ApprovedAt = now.UTC()
	s.Version++
	return nil
}

func abs(v int64) int64 {
	if v < 0 {
		return -v
	}
	return v
}

// ExceptionKind is why something is on the revenue-integrity worklist
// (SRS-BIL-011).
type ExceptionKind string

const (
	// ExceptionUnbilled is a completed service with no charge against it. The
	// commonest revenue leak in any hospital, and almost never theft — a
	// procedure nobody coded.
	ExceptionUnbilled ExceptionKind = "unbilled_service"
	// ExceptionUninvoiced is a charge that has sat on the ledger without
	// reaching a bill.
	ExceptionUninvoiced ExceptionKind = "uninvoiced_charge"
	// ExceptionHeld is a charge parked pending a query, which is fine for a day
	// and is a leak after a month.
	ExceptionHeld ExceptionKind = "held_charge"
	// ExceptionNoTariff is a service delivered that no contract prices. The one
	// that needs finance rather than the ward: somebody has to decide what it
	// costs.
	ExceptionNoTariff ExceptionKind = "no_tariff"
	// ExceptionUnpricedPackage is a package consumption with no package.
	ExceptionUnpricedPackage ExceptionKind = "unpriced_package"
)

// RevenueException is one item on the worklist (SRS-BIL-011).
//
// Carries the link back to the source record, which is the acceptance
// criterion: a worklist that says "an unbilled service exists" without saying
// which one is a worklist nobody can work.
type RevenueException struct {
	Kind        ExceptionKind
	AccountID   string
	PatientID   string
	EncounterID string
	// ChargeID is set where the exception is about a charge.
	ChargeID string
	// Source points at the clinical record — the order, the administration —
	// so a coder can open it rather than search for it.
	Source SourceReference
	Detail string
	Amount Money
	// Age is how long it has been outstanding, which is what sorts the
	// worklist: a charge held since yesterday is a query, and one held since
	// last month is a loss.
	Age time.Duration
}

// SortExceptions puts the oldest and largest first (SRS-BIL-011).
//
// Age before amount, because a small charge that has been outstanding for two
// months is more likely to be genuinely lost than a large one raised this
// morning.
func SortExceptions(exceptions []RevenueException) {
	sort.SliceStable(exceptions, func(i, j int) bool {
		if exceptions[i].Age != exceptions[j].Age {
			return exceptions[i].Age > exceptions[j].Age
		}
		return exceptions[i].Amount.Minor > exceptions[j].Amount.Minor
	})
}

// BillableEvent is a completed clinical service the biller expects to see
// (SRS-BIL-011).
type BillableEvent struct {
	Source      SourceReference
	ServiceCode string
	PatientID   string
	EncounterID string
	AccountID   string
	OccurredAt  time.Time
}

// FindUnbilled reports completed services with no charge against them
// (SRS-BIL-011).
//
// Matched on the source reference, which is the same key the charge's
// idempotency uses — so a service is unbilled exactly when no charge claims it,
// with no second notion of identity to disagree.
func FindUnbilled(events []BillableEvent, charges []*Charge, now time.Time) []RevenueException {
	claimed := map[string]bool{}
	for _, charge := range charges {
		if charge.Status == ChargeVoided || charge.Source.Empty() {
			continue
		}
		claimed[charge.Source.Key()] = true
	}

	var out []RevenueException
	for _, event := range events {
		if event.Source.Empty() || claimed[event.Source.Key()] {
			continue
		}
		out = append(out, RevenueException{
			Kind:      ExceptionUnbilled,
			AccountID: event.AccountID, PatientID: event.PatientID,
			EncounterID: event.EncounterID, Source: event.Source,
			Detail: event.ServiceCode + " was delivered and never charged",
			Age:    now.UTC().Sub(event.OccurredAt.UTC()),
		})
	}
	SortExceptions(out)
	return out
}

// FindChargeExceptions reports charges that have not reached a bill
// (SRS-BIL-011).
func FindChargeExceptions(charges []*Charge, now time.Time) []RevenueException {
	var out []RevenueException
	for _, charge := range charges {
		var kind ExceptionKind
		switch charge.Status {
		case ChargePosted:
			kind = ExceptionUninvoiced
		case ChargeHeld:
			kind = ExceptionHeld
		default:
			continue
		}
		out = append(out, RevenueException{
			Kind:      kind,
			AccountID: charge.AccountID, PatientID: charge.PatientID,
			EncounterID: charge.EncounterID, ChargeID: charge.ID,
			Source: charge.Source,
			Detail: charge.Description + ": " + statusDetail(charge),
			Amount: charge.Total(),
			Age:    now.UTC().Sub(charge.PostedAt.UTC()),
		})
	}
	SortExceptions(out)
	return out
}

func statusDetail(c *Charge) string {
	if c.Status == ChargeHeld {
		if c.Reason != "" {
			return "held — " + c.Reason
		}
		return "held"
	}
	return "posted and not yet invoiced"
}
