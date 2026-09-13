package domain

import (
	"sort"
	"strings"
	"time"
)

// Downtime and recovery reconciliation (SRS-NUR-018).
//
// The acceptance criterion — "recovery reconciliation prevents duplicate
// administration records" — describes a failure that is easy to produce and
// hard to detect. During downtime a ward charts on paper. When the system comes
// back, somebody types the paper chart in. If two nurses split the pile, or one
// nurse's first submission appeared to fail and she tried again, the same dose
// is entered twice. Nobody notices, because both entries are plausible, and the
// MAR then shows a patient given twice what they were given.
//
// A client-generated identifier does not solve it: the two transcriptions are
// genuinely separate submissions made by different people from the same piece
// of paper, and they carry different identifiers by construction.
//
// What identifies the event is the dose: this order, this scheduled time. That
// is on the paper chart, both transcribers read it, and it is therefore the
// key. The guard lives at the table as a unique index, not only here, because
// the two transcriptions can be in flight at the same moment and a check-then-
// insert would let both through.
//
// A PRN dose has no scheduled time. There the guard is an idempotency key the
// edge device generates once and replays — weaker, because two nurses at two
// terminals produce two keys, but a PRN dose genuinely given twice is a
// clinical judgement that may be correct and refusing it outright would be
// wrong. The reconciliation report surfaces near-duplicates instead.

// DowntimeEpisode is one period during which a unit worked on paper.
type DowntimeEpisode struct {
	ID       string
	TenantID string
	UnitID   string
	// Reason distinguishes planned maintenance from an outage, which changes
	// what a reviewer expects to find.
	Reason string

	StartedAt time.Time
	StartedBy string
	EndedAt   time.Time
	EndedBy   string
	// ReconciledAt marks the episode as fully entered. Separate from EndedAt,
	// because the system coming back and the paper being typed in are hours
	// apart and the gap is where the record is incomplete.
	ReconciledAt time.Time
	ReconciledBy string

	Version int64
}

// NewDowntimeEpisode opens a downtime period.
func NewDowntimeEpisode(id, tenantID, unitID, reason string, startedAt time.Time,
	startedBy string, now time.Time) (*DowntimeEpisode, error) {

	if strings.TrimSpace(unitID) == "" {
		return nil, invalidf("a downtime episode needs a unit")
	}
	if strings.TrimSpace(reason) == "" {
		return nil, invalidf("a downtime episode needs a reason")
	}
	if strings.TrimSpace(startedBy) == "" {
		return nil, invalidf("a downtime episode must record who declared it")
	}
	if startedAt.IsZero() {
		return nil, invalidf("a downtime episode needs the time it began")
	}
	started := startedAt.UTC()
	if started.After(now.UTC()) {
		return nil, invalidf("a downtime episode cannot have begun in the future")
	}
	return &DowntimeEpisode{
		ID: id, TenantID: tenantID, UnitID: strings.TrimSpace(unitID),
		Reason:    strings.TrimSpace(reason),
		StartedAt: started, StartedBy: startedBy, Version: 1,
	}, nil
}

// End closes the downtime period.
func (d *DowntimeEpisode) End(at time.Time, by string, now time.Time) error {
	if !d.EndedAt.IsZero() {
		return notAllowedf("this downtime episode has already ended")
	}
	if at.IsZero() {
		return invalidf("ending a downtime episode needs a time")
	}
	ended := at.UTC()
	if !ended.After(d.StartedAt) {
		return invalidf("a downtime episode cannot end before it began")
	}
	if ended.After(now.UTC()) {
		return invalidf("a downtime episode cannot have ended in the future")
	}
	if strings.TrimSpace(by) == "" {
		return invalidf("ending a downtime episode must record who declared it over")
	}
	d.EndedAt = ended
	d.EndedBy = by
	d.Version++
	return nil
}

// Reconcile marks the paper record as fully entered.
func (d *DowntimeEpisode) Reconcile(by string, now time.Time) error {
	if d.EndedAt.IsZero() {
		return notAllowedf("this downtime episode has not ended yet")
	}
	if !d.ReconciledAt.IsZero() {
		return notAllowedf("this downtime episode has already been reconciled")
	}
	if strings.TrimSpace(by) == "" {
		return invalidf("reconciling a downtime episode must record who did it")
	}
	d.ReconciledAt = now.UTC()
	d.ReconciledBy = by
	d.Version++
	return nil
}

// Open reports a downtime episode still running.
func (d *DowntimeEpisode) Open() bool { return d.EndedAt.IsZero() }

// ErrDuplicateAdministration reports a dose already recorded (SRS-NUR-018).
//
// Carries the existing record's identifier, so a transcriber is told "this
// dose is already in, here it is" rather than "error" — the difference between
// somebody checking and somebody trying again with a changed time.
type ErrDuplicateAdministration struct {
	ExistingID  string
	OrderID     string
	ScheduledAt time.Time
}

func (e ErrDuplicateAdministration) Error() string {
	return "nursing: this dose has already been recorded as " + e.ExistingID
}

// Is lets callers match with errors.Is.
func (e ErrDuplicateAdministration) Is(target error) bool {
	_, ok := target.(ErrDuplicateAdministration)
	return ok
}

// ReconciliationReport is what a recovery produced (SRS-NUR-018).
type ReconciliationReport struct {
	EpisodeID string
	UnitID    string
	// Entered counts the records successfully filed.
	Entered int
	// Duplicates counts submissions the scheduled-dose key rejected. Counted
	// and reported rather than silently swallowed: a high duplicate count
	// means two people typed the same pile, which is worth knowing.
	Duplicates []ErrDuplicateAdministration
	// Suspected are PRN doses close enough together to be one dose typed
	// twice. Reported, never rejected — two doses of PRN morphine an hour
	// apart can be entirely correct.
	Suspected []SuspectedDuplicate
	RunAt     time.Time
}

// SuspectedDuplicate is a pair of unscheduled doses that may be one event.
type SuspectedDuplicate struct {
	FirstID  string
	SecondID string
	OrderID  string
	Apart    time.Duration
}

// PRNDuplicateWindow is how close two unscheduled doses of the same order
// must be to be worth a second look.
//
// Fifteen minutes. Long enough to catch the same paper entry typed twice by
// two nurses, short enough that a genuine second dose for breakthrough pain —
// which is rarely under half an hour — does not fill the report with noise.
const PRNDuplicateWindow = 15 * time.Minute

// FindSuspectedDuplicates flags unscheduled doses close enough together to be
// one event typed twice (SRS-NUR-018).
//
// Reporting only. The scheduled-dose key rejects; this one raises an eyebrow,
// because a PRN dose repeated is sometimes exactly right.
func FindSuspectedDuplicates(administrations []*Administration) []SuspectedDuplicate {
	byOrder := map[string][]*Administration{}
	for _, a := range administrations {
		if a == nil || !a.ScheduledAt.IsZero() {
			// A scheduled dose is covered by the key; it never reaches here.
			continue
		}
		if a.Outcome != Administered && a.Outcome != Delayed {
			continue
		}
		byOrder[a.OrderID] = append(byOrder[a.OrderID], a)
	}

	var out []SuspectedDuplicate
	orders := make([]string, 0, len(byOrder))
	for id := range byOrder {
		orders = append(orders, id)
	}
	sort.Strings(orders)

	for _, id := range orders {
		doses := byOrder[id]
		sort.SliceStable(doses, func(i, j int) bool {
			return doses[i].GivenAt.Before(doses[j].GivenAt)
		})
		for i := 1; i < len(doses); i++ {
			apart := doses[i].GivenAt.Sub(doses[i-1].GivenAt)
			if apart <= PRNDuplicateWindow {
				out = append(out, SuspectedDuplicate{
					FirstID: doses[i-1].ID, SecondID: doses[i].ID,
					OrderID: id, Apart: apart,
				})
			}
		}
	}
	return out
}
