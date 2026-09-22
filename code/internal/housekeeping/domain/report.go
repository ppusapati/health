package domain

import (
	"sort"
	"time"
)

// CleaningSummary reports how a set of cleaning tasks went (SRS-HKP-008).
//
// Every figure is derived from the tasks' own timestamps, which is
// SRS-HKP-008's acceptance: a stored metric and the tasks behind it disagree
// the first time somebody corrects a task, and the stored one is the one on
// the board.
type CleaningSummary struct {
	Raised    int
	Completed int
	Cancelled int
	// Outstanding is the tasks still to do at the moment asked about.
	Outstanding int
	// OverdueNow is outstanding tasks already past their SLA. A ward can
	// still act on these, which is why they are counted apart from the ones
	// that were completed late.
	OverdueNow int
	// CompletedLate is tasks that were done, after their SLA.
	CompletedLate int
	// WithinSLA is tasks completed before their SLA. Reported beside the
	// late ones rather than as a percentage, because the percentage is what
	// a reader computes and the counts are what they check.
	WithinSLA int

	// MeanTurnaroundMinutes is the mean from raised to completed, over the
	// completed tasks only. Integers: a turnaround of 43.7 minutes is a
	// figure whose decimal is noise from how many tasks there were.
	MeanTurnaroundMinutes int
	// LongestTurnaroundMinutes is the worst one, which is the number a
	// ward manager actually asks about.
	LongestTurnaroundMinutes int

	// Verified counts the completed tasks a supervisor signed off, and
	// ScanVerified the ones somebody scanned the right door for. Both
	// reported against Completed rather than Raised: a task nobody has
	// finished is not an audit failure yet.
	Verified     int
	ScanVerified int

	// Unanswerable is a set with nothing completed in it. Reported rather
	// than a mean of zero, which reads as a hospital that cleans every room
	// instantly.
	Unanswerable bool
}

// SummariseCleaning counts a set of tasks (SRS-HKP-008).
func SummariseCleaning(tasks []CleaningTask, at time.Time) CleaningSummary {
	out := CleaningSummary{}
	var total time.Duration

	for _, task := range tasks {
		out.Raised++
		switch task.State {
		case TaskCancelled:
			out.Cancelled++
			continue
		case TaskCompleted, TaskVerified:
			out.Completed++
			if task.State == TaskVerified {
				out.Verified++
			}
			if task.ScanVerified() {
				out.ScanVerified++
			}
			turnaround := task.CompletedAt.Sub(task.RaisedAt)
			if turnaround > 0 {
				total += turnaround
				minutes := int(turnaround / time.Minute)
				if minutes > out.LongestTurnaroundMinutes {
					out.LongestTurnaroundMinutes = minutes
				}
			}
			if !task.DueBy.IsZero() && task.CompletedAt.After(task.DueBy) {
				out.CompletedLate++
			} else {
				out.WithinSLA++
			}
		default:
			out.Outstanding++
			if task.Overdue(at) {
				out.OverdueNow++
			}
		}
	}

	if out.Completed == 0 {
		out.Unanswerable = true
		return out
	}
	out.MeanTurnaroundMinutes = int(total/time.Minute) / out.Completed
	return out
}

// TurnaroundSummary reports how long beds spent out of service
// (SRS-HKP-008).
//
// Overrides are counted apart from releases and never averaged into the
// turnaround. A bed that went back into service uncleaned in four minutes is
// not a fast turnaround, and a report that treated it as one would reward
// exactly the thing the hold exists to discourage.
type TurnaroundSummary struct {
	Held     int
	Released int
	// StillHeld is beds out of service at the moment asked about.
	StillHeld int
	// Overridden is beds that went back into service without the clean
	// finishing.
	Overridden int

	MeanMinutes    int
	LongestMinutes int

	// Unanswerable is a period in which no bed was released. Reported
	// rather than a mean of zero.
	Unanswerable bool
}

// SummariseTurnaround counts bed holds (SRS-HKP-003, SRS-HKP-008).
func SummariseTurnaround(holds []BedHold) TurnaroundSummary {
	out := TurnaroundSummary{}
	var total time.Duration
	var minutes []int

	for _, hold := range holds {
		out.Held++
		switch hold.State {
		case HoldOpen:
			out.StillHeld++
		case HoldOverridden:
			out.Overridden++
		case HoldReleased:
			out.Released++
			spent := hold.ReleasedAt.Sub(hold.PlacedAt)
			if spent <= 0 {
				continue
			}
			total += spent
			minutes = append(minutes, int(spent/time.Minute))
		}
	}

	if out.Released == 0 {
		out.Unanswerable = true
		return out
	}
	sort.Ints(minutes)
	out.MeanMinutes = int(total/time.Minute) / out.Released
	out.LongestMinutes = minutes[len(minutes)-1]
	return out
}
