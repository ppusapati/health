package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Time-critical pathways (SRS-ER-005) and the ED status board (SRS-ER-012).

// PathwayKind is the time-critical protocol a clinician activated.
//
// Named rather than free text because each one has a published target that the
// department is measured against — door-to-needle for stroke, door-to-balloon
// for STEMI, the first-hour bundle for sepsis — and a pathway whose name
// varied by typist could not be measured at all.
type PathwayKind string

const (
	PathwayResuscitation PathwayKind = "resuscitation"
	PathwayTrauma        PathwayKind = "trauma"
	PathwayStroke        PathwayKind = "stroke"
	PathwaySTEMI         PathwayKind = "stemi"
	PathwaySepsis        PathwayKind = "sepsis"
	// PathwayOther is a locally defined protocol. Allowed, because a
	// department that has agreed a paediatric sepsis pathway should not have
	// to wait for this enumeration, and named in Label so the record still
	// says which one.
	PathwayOther   PathwayKind = "other"
	PathwayUnknown PathwayKind = "unknown"
)

var knownPathwayKinds = map[PathwayKind]bool{
	PathwayResuscitation: true, PathwayTrauma: true, PathwayStroke: true,
	PathwaySTEMI: true, PathwaySepsis: true, PathwayOther: true,
	PathwayUnknown: true,
}

// KnownPathwayKind reports whether a stored value is one this build handles.
func KnownPathwayKind(raw string) bool { return knownPathwayKinds[PathwayKind(raw)] }

// Pathway is one activation (SRS-ER-005).
type Pathway struct {
	ID       string
	TenantID string
	VisitID  string

	Kind PathwayKind
	// Label names a locally defined pathway, and is what the board shows for
	// PathwayOther.
	Label string

	// ActivatedAt starts every milestone target. "Activation time, team
	// notification and milestones are recorded" is the criterion, and this is
	// the instant the other two are measured from.
	ActivatedAt time.Time
	ActivatedBy string

	// NotifiedTeam is who was called. Recorded, because the commonest failure
	// in a time-critical pathway is not that nobody activated it — it is that
	// the team nobody called did not come.
	NotifiedTeam string
	// EscalationNoticeID links the activation to the durable notice that
	// carries the call (SRS-OPSNFR-003). Empty where the department activates
	// by shouting across the resus room, which is a real and common
	// arrangement rather than a defect.
	EscalationNoticeID string

	// Targets are the milestones this pathway is measured on.
	Targets []MilestoneTarget

	StoodDownAt time.Time
	// StoodDownReason explains an activation that turned out not to be needed.
	// Kept, and required, because a department's false-activation rate is a
	// quality measure in its own right and one nobody can compute from
	// deleted rows.
	StoodDownReason string
}

// MilestoneTarget is a step and the time it is measured against.
type MilestoneTarget struct {
	// Code identifies the step — "ct_scan", "thrombolysis", "antibiotics".
	Code string
	// Label is what the board shows.
	Label string
	// Within is the target measured from activation. Zero where the step is
	// recorded but not timed.
	Within time.Duration
}

// DefaultTargets is the published set for a pathway kind.
//
// Defaults, overridable per deployment: the figures below are the ones the
// major guidelines use, and a department running to a different local standard
// configures its own rather than being measured against somebody else's.
func DefaultTargets(kind PathwayKind) []MilestoneTarget {
	switch kind {
	case PathwayStroke:
		return []MilestoneTarget{
			{Code: "ct_scan", Label: "CT scanner", Within: 25 * time.Minute},
			{Code: "thrombolysis", Label: "Thrombolysis decision", Within: 60 * time.Minute},
		}
	case PathwaySTEMI:
		return []MilestoneTarget{
			{Code: "ecg", Label: "12-lead ECG", Within: 10 * time.Minute},
			{Code: "reperfusion", Label: "Reperfusion", Within: 90 * time.Minute},
		}
	case PathwaySepsis:
		return []MilestoneTarget{
			{Code: "lactate", Label: "Lactate", Within: 60 * time.Minute},
			{Code: "cultures", Label: "Blood cultures", Within: 60 * time.Minute},
			{Code: "antibiotics", Label: "Antibiotics", Within: 60 * time.Minute},
			{Code: "fluids", Label: "Fluid resuscitation", Within: 60 * time.Minute},
		}
	case PathwayTrauma:
		return []MilestoneTarget{
			{Code: "primary_survey", Label: "Primary survey", Within: 5 * time.Minute},
			{Code: "imaging", Label: "Trauma imaging", Within: 30 * time.Minute},
		}
	case PathwayResuscitation:
		// No published clock. A resuscitation is measured on what was done,
		// not on how fast the paperwork moved, and inventing a target here
		// would put a number on the wrong thing.
		return nil
	default:
		return nil
	}
}

// NewPathwayInput is one activation.
type NewPathwayInput struct {
	VisitID      string
	Kind         PathwayKind
	Label        string
	NotifiedTeam string
	Targets      []MilestoneTarget
}

// ActivatePathway records a time-critical activation (SRS-ER-005).
func ActivatePathway(id, tenantID string, in NewPathwayInput, activatedBy string,
	now time.Time) (Pathway, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.VisitID) == "":
		return Pathway{}, fmt.Errorf("%w: a pathway belongs to a visit", ErrInvalidVisit)
	case strings.TrimSpace(activatedBy) == "":
		return Pathway{}, fmt.Errorf("%w: an activation names who made it", ErrInvalidVisit)
	case !knownPathwayKinds[in.Kind] || in.Kind == PathwayUnknown:
		return Pathway{}, fmt.Errorf("%w: unknown pathway %q", ErrInvalidVisit, in.Kind)
	case in.Kind == PathwayOther && strings.TrimSpace(in.Label) == "":
		return Pathway{}, fmt.Errorf(
			"%w: a locally defined pathway needs a name, or the record cannot say "+
				"which one was run", ErrInvalidVisit)
	}

	targets := in.Targets
	if len(targets) == 0 {
		targets = DefaultTargets(in.Kind)
	}

	return Pathway{
		ID: id, TenantID: tenantID, VisitID: strings.TrimSpace(in.VisitID),
		Kind: in.Kind, Label: strings.TrimSpace(in.Label),
		ActivatedAt: now.UTC(), ActivatedBy: activatedBy,
		NotifiedTeam: strings.TrimSpace(in.NotifiedTeam),
		Targets:      targets,
	}, nil
}

// StandDown closes an activation that turned out not to be needed.
func (p *Pathway) StandDown(reason string, at time.Time) error {
	if strings.TrimSpace(reason) == "" {
		// A department's false-activation rate is a quality measure, and one
		// nobody can read from a stand-down with no reason.
		return fmt.Errorf("%w: standing a pathway down needs a reason", ErrInvalidVisit)
	}
	if !p.StoodDownAt.IsZero() {
		return nil
	}
	p.StoodDownAt = at.UTC()
	p.StoodDownReason = strings.TrimSpace(reason)
	return nil
}

// Active reports a pathway still running.
func (p Pathway) Active() bool { return p.StoodDownAt.IsZero() }

// MilestoneState is one target and what happened to it.
type MilestoneState struct {
	Target MilestoneTarget
	// ReachedAt is when the milestone event was recorded, if it was.
	ReachedAt time.Time
	Reached   bool
	// Elapsed is how long it took, or how long it has been so far.
	Elapsed time.Duration
	// Breached is a target passed without the milestone. True for an
	// unreached target whose time has run out, which is the state that
	// matters: a breach that only appears after the event is a breach nobody
	// could have prevented.
	Breached bool
}

// Progress reports where a pathway has got to (SRS-ER-005, SRS-ER-006).
//
// Computed from the timeline for the same reason the door clocks are: a stored
// "reached" flag is a field somebody can set, and a derived one is a
// consequence of an event that names its actor and its time.
func (p Pathway) Progress(timeline Timeline, now time.Time) []MilestoneState {
	reached := map[string]time.Time{}
	for _, event := range timeline {
		if event.Kind != EventMilestone || event.PathwayID != p.ID {
			continue
		}
		// The detail carries the milestone code. Earliest wins: a step done
		// twice was still first done once.
		code := strings.TrimSpace(event.Detail)
		if at, seen := reached[code]; !seen || event.OccurredAt.Before(at) {
			reached[code] = event.OccurredAt
		}
	}

	// The clock stops when the pathway is stood down, so a stand-down does not
	// keep accruing breaches against a team that was told to go home.
	until := now
	if !p.Active() {
		until = p.StoodDownAt
	}

	out := make([]MilestoneState, 0, len(p.Targets))
	for _, target := range p.Targets {
		state := MilestoneState{Target: target}
		if at, ok := reached[target.Code]; ok {
			state.Reached, state.ReachedAt = true, at
			state.Elapsed = at.Sub(p.ActivatedAt)
			state.Breached = target.Within > 0 && state.Elapsed > target.Within
		} else {
			state.Elapsed = until.Sub(p.ActivatedAt)
			state.Breached = target.Within > 0 && state.Elapsed > target.Within
		}
		out = append(out, state)
	}
	sort.SliceStable(out, func(i, j int) bool {
		return out[i].Target.Within < out[j].Target.Within
	})
	return out
}

// BoardRow is one line of the ED status board (SRS-ER-012).
//
// Assembled rather than queried, so the redaction below happens in one place.
type BoardRow struct {
	QueueEntry
	// Pathways names the active pathways, for the flash on the board.
	Pathways []PathwayKind
	// Waiting is how long the patient has been in the department.
	Waiting time.Duration
	// Breaching is set where the acuity's target wait has passed.
	Breaching bool
	// ObservationOverdue is set where an observation review time has passed.
	ObservationOverdue bool
	// Restricted marks a row whose detail this viewer may not see
	// (SRS-ER-011, SRS-ER-012: "without exposing restricted data beyond
	// role").
	Restricted bool
}

// BoardView is what one viewer sees.
type BoardView struct {
	Rows []BoardRow
	// Restricted counts the rows shown in redacted form, so the board can say
	// "and 2 restricted" rather than silently showing a shorter department
	// than exists. A board that hid the row entirely would let somebody walk
	// past a cubicle they did not know was occupied.
	Restricted int
}

// BuildBoard assembles the status board for one viewer (SRS-ER-012).
//
// maySeeRestricted is the caller's decision, made against the session; this
// applies it. A medico-legal case still appears — the department has to know
// the bed is occupied — with its complaint and identity withheld.
func BuildBoard(entries []QueueEntry, visits map[string]Visit,
	active map[string][]PathwayKind, scale AcuityScale,
	maySeeRestricted bool, now time.Time) BoardView {

	ordered := OrderQueue(entries)
	view := BoardView{Rows: make([]BoardRow, 0, len(ordered))}

	for _, entry := range ordered {
		visit := visits[entry.VisitID]
		row := BoardRow{
			QueueEntry:         entry,
			Pathways:           active[entry.VisitID],
			Waiting:            now.Sub(entry.ArrivedAt),
			Breaching:          entry.Breaching(scale, now),
			ObservationOverdue: visit.ObservationOverdue(now),
		}

		if visit.MedicoLegal && !maySeeRestricted {
			row.Restricted = true
			// The bed, the acuity and the clock stay. The identity, the
			// complaint and the barrier go: those are the restricted
			// documentation SRS-ER-011 is about, and the rest is what stops
			// the department losing track of a patient.
			row.Display = "Restricted"
			row.DispositionBarrier = ""
			view.Restricted++
		}
		view.Rows = append(view.Rows, row)
	}
	return view
}
