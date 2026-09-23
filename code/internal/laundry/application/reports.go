package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/laundry/domain"
	"github.com/ppusapati/health/code/internal/laundry/ports"
)

// Reporting (SRS-LND-003, SRS-LND-004, SRS-LND-006).
//
// Every figure is derived from the rows themselves and none is stored,
// because a stored metric and the rows behind it disagree the first time
// somebody corrects one — and the stored one is the number on the board.

// ReportInput bounds a report.
type ReportInput struct {
	FacilityID string
	From       time.Time
	To         time.Time
}

// WashReport is how a window of washes went (SRS-LND-003).
type WashReport struct {
	Summary domain.BatchSummary
	// Truncated reports the window holding more washes than one report may
	// read. A summary over a truncated set is a summary of some of the
	// laundry, and a reader who was not told would take it for all of it.
	Truncated bool
}

// WashReport counts a window of washes (SRS-LND-003).
func (s *Service) WashReport(ctx context.Context, in ReportInput) (
	WashReport, error) {

	_, scope, err := s.authorize(ctx, PermReportRead)
	if err != nil {
		return WashReport{}, err
	}
	batches, err := s.batches.Batches(ctx, scope, ports.BatchFilter{
		FacilityID: in.FacilityID, From: in.From, To: in.To,
		Limit: reportPageSize,
	})
	if err != nil {
		return WashReport{}, err
	}
	return WashReport{
		Summary:   domain.SummariseBatches(batches),
		Truncated: len(batches) >= reportPageSize,
	}, nil
}

// LossReport is what a window of linen cost (SRS-LND-006).
type LossReport struct {
	Summary   domain.LossSummary
	Truncated bool
}

// LossReport counts a window of write-offs (SRS-LND-006).
//
// Only what somebody approved moves the totals, which is the domain's rule:
// a reported loss nobody has decided on is not yet a loss, and counting it as
// one would let the report be moved by anybody who can type a number.
func (s *Service) LossReport(ctx context.Context, in ReportInput) (
	LossReport, error) {

	_, scope, err := s.authorize(ctx, PermReportRead)
	if err != nil {
		return LossReport{}, err
	}
	records, err := s.losses.Losses(ctx, scope, ports.LossFilter{
		FacilityID: in.FacilityID, From: in.From, To: in.To,
		Limit: reportPageSize,
	})
	if err != nil {
		return LossReport{}, err
	}
	return LossReport{
		Summary:   domain.SummariseLosses(records),
		Truncated: len(records) >= reportPageSize,
	}, nil
}

// UnitStock is what a unit holds and what it is short of
// (SRS-LND-001, SRS-LND-004).
type UnitStock struct {
	Balance domain.UnitBalance
	// Shortfalls is empty when the unit is at or above par on everything,
	// rather than a list of zeroes: a top-up sheet listing every item the
	// ward already has is one nobody reads to the end.
	Shortfalls []domain.Shortfall
	// ParInForce is the revision the shortfall was measured against, so a
	// reader can see which par produced the number.
	ParInForce domain.ParLevel
	// NoPar reports a unit nobody has set a par for. Reported rather than
	// an empty shortfall list, which reads as a ward that has everything it
	// needs.
	NoPar bool
	// Truncated reports a unit with more movements than one read may cover.
	Truncated bool
}

// UnitStock derives what a unit holds and what it is short of
// (SRS-LND-004).
//
// Issued minus returned minus written off, computed from the movements. A
// stored balance and the delivery notes behind it disagree the first time
// somebody corrects one, and the stored one is what the ward is judged on.
func (s *Service) UnitStock(ctx context.Context, unitID string) (UnitStock,
	error) {

	_, scope, err := s.authorize(ctx, PermRead)
	if err != nil {
		return UnitStock{}, err
	}
	now := s.clock.Now()

	issues, err := s.issues.Issues(ctx, scope, ports.IssueFilter{
		UnitID: unitID, Limit: reportPageSize,
	})
	if err != nil {
		return UnitStock{}, err
	}
	collections, err := s.collections.Collections(ctx, scope,
		ports.CollectionFilter{UnitID: unitID, Limit: reportPageSize})
	if err != nil {
		return UnitStock{}, err
	}
	losses, err := s.losses.Losses(ctx, scope, ports.LossFilter{
		UnitID: unitID, Limit: reportPageSize,
	})
	if err != nil {
		return UnitStock{}, err
	}

	out := UnitStock{
		Balance: domain.DeriveBalance(unitID, issues, collections, losses),
		Truncated: len(issues) >= reportPageSize ||
			len(collections) >= reportPageSize ||
			len(losses) >= reportPageSize,
	}

	revisions, err := s.pars.RevisionsOf(ctx, scope, unitID)
	if err != nil {
		return UnitStock{}, err
	}
	par, ok := domain.ParInForce(revisions, unitID, now)
	if !ok {
		out.NoPar = true
		return out, nil
	}
	out.ParInForce = par
	out.Shortfalls = domain.Shortfalls(par, out.Balance.OnHand)
	return out, nil
}
