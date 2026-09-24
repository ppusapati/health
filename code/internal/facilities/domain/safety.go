package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// DeficiencyState is where a fire or life-safety finding stands
// (SRS-FAC-008).
type DeficiencyState string

const (
	DeficiencyOpen DeficiencyState = "open"
	// DeficiencyMitigated has an interim measure in place — a fire watch
	// on a failed detection zone, a propped door taken off its hold-open.
	// Explicitly not closure, and the reason this state exists at all: a
	// mitigation recorded as a closure is how a hospital ends up with a
	// fire watch nobody remembers to stand down and a deficiency nobody
	// remembers to fix.
	DeficiencyMitigated DeficiencyState = "mitigated"
	DeficiencyClosed    DeficiencyState = "closed"
)

var knownDeficiencyState = map[DeficiencyState]bool{
	DeficiencyOpen: true, DeficiencyMitigated: true, DeficiencyClosed: true,
}

// Open reports whether a deficiency still needs to be fixed.
//
// Mitigated counts as open. That is the whole of SRS-FAC-008's acceptance:
// open critical deficiencies remain visible until closure, and a mitigation
// is not a closure however comfortable it makes everybody feel.
func (s DeficiencyState) Open() bool { return s != DeficiencyClosed }

// Deficiency is a fire or life-safety finding (SRS-FAC-008).
type Deficiency struct {
	ID       string
	TenantID string

	// TaskID is the inspection that found it, where an inspection did.
	// Findings also arrive from a walk-round or an incident, so it is
	// optional.
	TaskID     string
	AssetID    string
	FacilityID string
	LocationID string
	// LocationNote is where the door actually is. A fire deficiency is
	// about a place far more often than about a machine, and "blocked
	// exit" against an org unit is not findable.
	LocationNote string

	System   System
	Severity Severity
	// Finding is what is wrong in the inspector's words.
	Finding string
	// Standard is the clause it breaches, where the inspection works that
	// way. It is what turns "the door does not shut" into something a
	// hospital can be held to.
	Standard string

	State    DeficiencyState
	RaisedAt time.Time
	RaisedBy string
	// DueAt is when it has to be fixed by. Required for a critical
	// finding: one with no date is one that is never late.
	DueAt time.Time

	// WorkOrderID is the work raised to fix it. Required for a critical
	// finding, because a critical deficiency that is only a note is one
	// nobody is assigned to.
	WorkOrderID string

	MitigationNote string
	MitigatedAt    time.Time
	MitigatedBy    string

	ClosedAt time.Time
	ClosedBy string
	// ClosureEvidenceRef is the photograph, the retest certificate, the
	// signed re-inspection. A critical deficiency does not close on
	// somebody's word, and the database says so too.
	ClosureEvidenceRef string

	CreatedAt time.Time
	Version   int64
}

// RaiseDeficiencyInput records a life-safety finding.
type RaiseDeficiencyInput struct {
	TaskID       string
	AssetID      string
	FacilityID   string
	LocationID   string
	LocationNote string
	System       System
	Severity     Severity
	Finding      string
	Standard     string
	DueAt        time.Time
	WorkOrderID  string
}

// RaiseDeficiency records a fire or life-safety finding (SRS-FAC-008).
func RaiseDeficiency(id, tenantID string, in RaiseDeficiencyInput, by string,
	now time.Time) (Deficiency, error) {

	critical := in.Severity == SeverityCritical

	switch {
	case strings.TrimSpace(id) == "":
		return Deficiency{}, fmt.Errorf("%w: a deficiency needs an id",
			ErrInvalidFacilities)
	case strings.TrimSpace(in.Finding) == "":
		return Deficiency{}, fmt.Errorf("%w: say what is deficient",
			ErrInvalidFacilities)
	case !knownSystem[in.System]:
		return Deficiency{}, fmt.Errorf("%w: unknown system %q",
			ErrInvalidFacilities, in.System)
	case !knownSeverity[in.Severity]:
		return Deficiency{}, fmt.Errorf("%w: unknown severity %q",
			ErrInvalidFacilities, in.Severity)
	case in.Severity == SeverityInfo:
		// An informational life-safety deficiency is a contradiction.
		// Something is either a breach or an observation, and the
		// second one is a note on the inspection.
		return Deficiency{}, fmt.Errorf(
			"%w: a life-safety deficiency is at least minor",
			ErrInvalidFacilities)
	case strings.TrimSpace(in.LocationID) == "" &&
		strings.TrimSpace(in.LocationNote) == "" &&
		strings.TrimSpace(in.AssetID) == "":
		return Deficiency{}, fmt.Errorf("%w: say where the deficiency is",
			ErrInvalidFacilities)
	case strings.TrimSpace(by) == "":
		return Deficiency{}, fmt.Errorf("%w: name who raised the deficiency",
			ErrInvalidFacilities)
	case critical && in.DueAt.IsZero():
		return Deficiency{}, fmt.Errorf(
			"%w: a critical deficiency needs a date to be fixed by",
			ErrInvalidFacilities)
	case critical && strings.TrimSpace(in.WorkOrderID) == "":
		return Deficiency{}, fmt.Errorf(
			"%w: a critical deficiency needs work raised against it",
			ErrInvalidFacilities)
	case !in.DueAt.IsZero() && in.DueAt.Before(now):
		return Deficiency{}, fmt.Errorf("%w: that due date has passed",
			ErrInvalidFacilities)
	}

	return Deficiency{
		ID: id, TenantID: tenantID,
		TaskID:       strings.TrimSpace(in.TaskID),
		AssetID:      strings.TrimSpace(in.AssetID),
		FacilityID:   strings.TrimSpace(in.FacilityID),
		LocationID:   strings.TrimSpace(in.LocationID),
		LocationNote: strings.TrimSpace(in.LocationNote),
		System:       in.System, Severity: in.Severity,
		Finding:  strings.TrimSpace(in.Finding),
		Standard: strings.TrimSpace(in.Standard),
		State:    DeficiencyOpen,
		RaisedAt: now.UTC(), RaisedBy: by,
		DueAt:       utcOrZero(in.DueAt),
		WorkOrderID: strings.TrimSpace(in.WorkOrderID),
		CreatedAt:   now.UTC(), Version: 1,
	}, nil
}

// Mitigate records an interim measure (SRS-FAC-008).
func (d *Deficiency) Mitigate(note, by string, now time.Time) error {
	switch {
	case d.State == DeficiencyClosed:
		return fmt.Errorf("%w: this deficiency is closed",
			ErrInvalidFacilities)
	case strings.TrimSpace(note) == "":
		// "Mitigated" with nothing said is a deficiency that has been
		// downgraded rather than managed.
		return fmt.Errorf("%w: say what the interim measure is",
			ErrInvalidFacilities)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: name who put the measure in place",
			ErrInvalidFacilities)
	}
	d.State = DeficiencyMitigated
	d.MitigationNote = strings.TrimSpace(note)
	d.MitigatedAt = now.UTC()
	d.MitigatedBy = strings.TrimSpace(by)
	return nil
}

// CloseDeficiency records a finding actually fixed (SRS-FAC-008).
func (d *Deficiency) CloseDeficiency(evidenceRef, by string,
	now time.Time) error {

	switch {
	case d.State == DeficiencyClosed:
		return fmt.Errorf("%w: this deficiency is already closed",
			ErrInvalidFacilities)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: name who closed the deficiency",
			ErrInvalidFacilities)
	case d.Severity == SeverityCritical &&
		strings.TrimSpace(evidenceRef) == "":
		return fmt.Errorf(
			"%w: a critical deficiency closes with evidence, not a note",
			ErrInvalidFacilities)
	case d.Severity == SeverityCritical &&
		strings.TrimSpace(by) == strings.TrimSpace(d.RaisedBy):
		// The inspector who found it does not also certify it fixed.
		return fmt.Errorf(
			"%w: a critical deficiency is closed by somebody other than %s",
			ErrInvalidFacilities, d.RaisedBy)
	}

	d.State = DeficiencyClosed
	d.ClosedAt = now.UTC()
	d.ClosedBy = strings.TrimSpace(by)
	d.ClosureEvidenceRef = strings.TrimSpace(evidenceRef)
	return nil
}

// OpenCritical lists critical deficiencies that are not closed (SRS-FAC-008).
//
// This is the acceptance in one function, and the two things it does not do
// matter more than what it does: it does not take a time window, and it does
// not drop mitigated findings. A list that aged things out, or that treated a
// fire watch as a fix, would let a hospital stop seeing the blocked stairwell
// it never got round to unblocking.
func OpenCritical(deficiencies []Deficiency) []Deficiency {
	out := make([]Deficiency, 0, len(deficiencies))
	for _, d := range deficiencies {
		if d.Severity == SeverityCritical && d.State.Open() {
			out = append(out, d)
		}
	}
	sort.SliceStable(out, func(i, j int) bool {
		// Unmitigated before mitigated: a critical deficiency with
		// nothing in place is the one to look at first.
		if (out[i].State == DeficiencyOpen) !=
			(out[j].State == DeficiencyOpen) {
			return out[i].State == DeficiencyOpen
		}
		if !out[i].DueAt.Equal(out[j].DueAt) {
			return out[i].DueAt.Before(out[j].DueAt)
		}
		return out[i].RaisedAt.Before(out[j].RaisedAt)
	})
	return out
}

// Blocking lists the deficiencies that stop an inspection being signed off
// (SRS-FAC-008).
//
// An inspection is not complete while it has found something critical that
// nobody has dealt with. Without this, a fire inspection closes with its own
// findings outstanding and the report reads as a pass.
func Blocking(taskID string, deficiencies []Deficiency) []Deficiency {
	out := make([]Deficiency, 0, len(deficiencies))
	for _, d := range deficiencies {
		if d.TaskID != taskID || d.Severity != SeverityCritical {
			continue
		}
		if d.State == DeficiencyOpen {
			// A mitigated finding does not block the paperwork —
			// there is a fire watch standing there — but it stays
			// on the open list until it is fixed.
			out = append(out, d)
		}
	}
	return out
}

// SafetyReport is the life-safety picture (SRS-FAC-008).
type SafetyReport struct {
	OpenCritical   int
	Mitigated      int
	Overdue        int
	ClosedInWindow int
	// OldestOpenDays is how long the oldest unclosed critical finding has
	// been outstanding. One number that a board can be shown and cannot
	// misread.
	OldestOpenDays int
	Findings       []Deficiency
}

// SummariseSafety builds the life-safety report (SRS-FAC-008).
func SummariseSafety(deficiencies []Deficiency, from, to time.Time,
	now time.Time) SafetyReport {

	out := SafetyReport{Findings: OpenCritical(deficiencies)}
	for _, d := range deficiencies {
		switch {
		case d.State == DeficiencyClosed:
			if !d.ClosedAt.Before(from) && !d.ClosedAt.After(to) {
				out.ClosedInWindow++
			}
			continue
		case d.State == DeficiencyMitigated:
			out.Mitigated++
		}
		if d.Severity == SeverityCritical {
			out.OpenCritical++
			if days := int(now.Sub(d.RaisedAt).Hours() / 24); days >
				out.OldestOpenDays {
				out.OldestOpenDays = days
			}
		}
		if !d.DueAt.IsZero() && now.After(d.DueAt) {
			out.Overdue++
		}
	}
	return out
}
