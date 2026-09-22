package application

import (
	"context"
	"time"

	"github.com/ppusapati/health/code/internal/housekeeping/domain"
	"github.com/ppusapati/health/code/internal/housekeeping/ports"
)

// Reporting (SRS-HKP-008).
//
// Every figure is derived from the tasks' and holds' own timestamps.
// SRS-HKP-008's acceptance is that the reports reconcile to task timestamps,
// and a stored metric and the rows behind it disagree the first time somebody
// corrects a task — with the stored one being the number on the board.

// ReportInput bounds a report.
type ReportInput struct {
	FacilityID string
	Zone       string
	From       time.Time
	To         time.Time
}

// CleaningReport is the SLA and audit-compliance report (SRS-HKP-008).
type CleaningReport struct {
	Summary domain.CleaningSummary
	// Truncated reports the window holding more tasks than one report may
	// read. A summary over a truncated set is a summary of some of the
	// hospital, and a reader who was not told would take it for all of it.
	Truncated bool
}

// CleaningReport counts a window of cleaning tasks (SRS-HKP-008).
func (s *Service) CleaningReport(ctx context.Context, in ReportInput) (
	CleaningReport, error) {

	_, scope, err := s.authorize(ctx, PermReportRead)
	if err != nil {
		return CleaningReport{}, err
	}
	now := s.clock.Now()

	tasks, err := s.tasks.Tasks(ctx, scope, ports.TaskFilter{
		FacilityID: in.FacilityID, Zone: in.Zone,
		From: in.From, To: in.To, Limit: reportPageSize,
	})
	if err != nil {
		return CleaningReport{}, err
	}
	return CleaningReport{
		Summary:   domain.SummariseCleaning(tasks, now),
		Truncated: len(tasks) >= reportPageSize,
	}, nil
}

// TurnaroundReport is the bed turnaround report (SRS-HKP-003, SRS-HKP-008).
type TurnaroundReport struct {
	Summary   domain.TurnaroundSummary
	Truncated bool
}

// TurnaroundReport counts a window of bed holds (SRS-HKP-008).
//
// Overrides are counted apart from releases and never averaged into the
// turnaround, which is the domain's rule rather than this one's. A bed that
// went back into service uncleaned in four minutes is not a fast turnaround,
// and a report that treated it as one would reward exactly the thing the hold
// exists to discourage.
func (s *Service) TurnaroundReport(ctx context.Context, in ReportInput) (
	TurnaroundReport, error) {

	_, scope, err := s.authorize(ctx, PermReportRead)
	if err != nil {
		return TurnaroundReport{}, err
	}
	holds, err := s.holds.Holds(ctx, scope, ports.HoldFilter{
		FacilityID: in.FacilityID, Zone: in.Zone,
		From: in.From, To: in.To, Limit: reportPageSize,
	})
	if err != nil {
		return TurnaroundReport{}, err
	}
	return TurnaroundReport{
		Summary:   domain.SummariseTurnaround(holds),
		Truncated: len(holds) >= reportPageSize,
	}, nil
}

// reportPageSize bounds one report. A window holding more rows than this is
// reported as truncated rather than silently summarised from part of itself.
const reportPageSize = 5000
