package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Moment is one of the five occasions hand hygiene is expected (SRS-IPC-006).
//
// The WHO five moments, named rather than numbered, because "moment 3" means
// nothing to the person being observed and everything to the report.
type Moment string

const (
	MomentBeforePatient     Moment = "before_patient_contact"
	MomentBeforeAseptic     Moment = "before_aseptic_procedure"
	MomentAfterBodyFluid    Moment = "after_body_fluid_exposure"
	MomentAfterPatient      Moment = "after_patient_contact"
	MomentAfterSurroundings Moment = "after_patient_surroundings"
)

var knownMoment = map[Moment]bool{
	MomentBeforePatient: true, MomentBeforeAseptic: true,
	MomentAfterBodyFluid: true, MomentAfterPatient: true,
	MomentAfterSurroundings: true,
}

// Discipline is the professional group observed (SRS-IPC-006).
//
// A category and never a person. That is the requirement's "without exposing
// unnecessary identity", and it is also what keeps the data honest: a hand
// hygiene audit that names individuals becomes a disciplinary instrument, and
// the moment it does, observed compliance goes to ninety-nine per cent and
// stops meaning anything.
type Discipline string

const (
	DisciplineDoctor  Discipline = "doctor"
	DisciplineNurse   Discipline = "nurse"
	DisciplineAllied  Discipline = "allied_health"
	DisciplineSupport Discipline = "support_staff"
	DisciplineStudent Discipline = "student"
	DisciplineVisitor Discipline = "visitor"
)

var knownDiscipline = map[Discipline]bool{
	DisciplineDoctor: true, DisciplineNurse: true, DisciplineAllied: true,
	DisciplineSupport: true, DisciplineStudent: true, DisciplineVisitor: true,
}

// Action is what the observer saw (SRS-IPC-006).
type Action string

const (
	ActionRub    Action = "alcohol_rub"
	ActionWash   Action = "soap_and_water"
	ActionMissed Action = "missed"
	// ActionGlovesOnly is wearing gloves instead of cleaning hands, which is
	// its own failure and the commonest one. Folded into "missed" it would be
	// invisible, and the training that fixes it is different.
	ActionGlovesOnly Action = "gloves_only"
)

var knownAction = map[Action]bool{
	ActionRub: true, ActionWash: true, ActionMissed: true,
	ActionGlovesOnly: true,
}

// Compliant reports the actions that count as hand hygiene performed.
func (a Action) Compliant() bool {
	return a == ActionRub || a == ActionWash
}

// HygieneSession is one period of observation (SRS-IPC-006).
type HygieneSession struct {
	ID       string
	TenantID string

	FacilityID string
	LocationID string
	// ObserverID is recorded: an audit's quality depends on who did it, and
	// two observers who disagree by thirty points is a finding about the
	// observers. The observed are never named; the observer always is.
	ObserverID string

	StartedAt time.Time
	EndedAt   time.Time
	Notes     string

	CreatedAt time.Time
	Version   int64
}

// HygieneObservation is one opportunity and what happened (SRS-IPC-006).
//
// There is deliberately no person identifier on this record. Not a nullable
// one, not an optional one: the column does not exist, so a future screen
// cannot start populating it and a future report cannot start grouping by it.
type HygieneObservation struct {
	ID        string
	TenantID  string
	SessionID string

	Discipline Discipline
	Moment     Moment
	Action     Action
	// GlovesWorn is recorded beside the action because gloves correctly worn
	// and gloves worn instead of hand hygiene look identical in a total.
	GlovesWorn bool

	ObservedAt time.Time
}

// NewSession opens an observation period (SRS-IPC-006).
func NewSession(id, tenantID, facilityID, locationID, observerID string,
	startedAt time.Time, notes string, now time.Time) (
	HygieneSession, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return HygieneSession{}, fmt.Errorf("%w: a session needs an id",
			ErrInvalidInfection)
	case strings.TrimSpace(locationID) == "":
		return HygieneSession{}, fmt.Errorf("%w: a session names its location",
			ErrInvalidInfection)
	case strings.TrimSpace(observerID) == "":
		return HygieneSession{}, fmt.Errorf("%w: a session names its observer",
			ErrInvalidInfection)
	}

	started := startedAt
	if started.IsZero() {
		started = now
	}
	return HygieneSession{
		ID: id, TenantID: tenantID, FacilityID: facilityID,
		LocationID: locationID, ObserverID: observerID,
		StartedAt: started.UTC(), Notes: strings.TrimSpace(notes),
		CreatedAt: now.UTC(), Version: 1,
	}, nil
}

// NewObservation records one opportunity (SRS-IPC-006).
func NewObservation(id, tenantID, sessionID string, discipline Discipline,
	moment Moment, action Action, glovesWorn bool, at time.Time) (
	HygieneObservation, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return HygieneObservation{}, fmt.Errorf("%w: an observation needs an id",
			ErrInvalidInfection)
	case strings.TrimSpace(sessionID) == "":
		return HygieneObservation{}, fmt.Errorf(
			"%w: an observation names its session", ErrInvalidInfection)
	case !knownDiscipline[discipline]:
		return HygieneObservation{}, fmt.Errorf("%w: unknown discipline %q",
			ErrInvalidInfection, discipline)
	case !knownMoment[moment]:
		return HygieneObservation{}, fmt.Errorf("%w: unknown moment %q",
			ErrInvalidInfection, moment)
	case !knownAction[action]:
		return HygieneObservation{}, fmt.Errorf("%w: unknown action %q",
			ErrInvalidInfection, action)
	case action == ActionGlovesOnly && !glovesWorn:
		return HygieneObservation{}, fmt.Errorf(
			"%w: gloves-only records no gloves worn", ErrInvalidInfection)
	}

	return HygieneObservation{
		ID: id, TenantID: tenantID, SessionID: sessionID,
		Discipline: discipline, Moment: moment, Action: action,
		GlovesWorn: glovesWorn, ObservedAt: at.UTC(),
	}, nil
}

// Compliance is one group's hand hygiene rate (SRS-IPC-006).
type Compliance struct {
	// Group is the discipline, the moment or the location, depending on how
	// the report was asked for.
	Group         string
	Opportunities int
	Performed     int
	// Permille is performed over opportunities, parts per thousand.
	Permille int
	// GlovesInsteadOf counts the commonest failure separately, because the
	// training that fixes it is different from the training that fixes a
	// plain miss.
	GlovesInsteadOf int
	// Suppressed marks a group with too few observations to report. A ward
	// with three observations and one miss reads as 67% compliance, which is
	// not a measurement — and where the group is small enough, naming it is
	// close to naming a person.
	Suppressed bool
}

// ComplianceInput is what a compliance report is computed from.
type ComplianceInput struct {
	Observations []HygieneObservation
	// By is "discipline", "moment" or "" for a single total.
	By string
	// MinimumOpportunities is the threshold below which a group is
	// suppressed. Zero reports everything, which is a deployment that has not
	// decided.
	MinimumOpportunities int
}

// Compliances derives hand hygiene compliance (SRS-IPC-006).
//
// Aggregated and never per person, because there is no person to aggregate
// by. Small groups are suppressed rather than published: a category with four
// observations on a night shift is one individual with extra steps.
func Compliances(in ComplianceInput) []Compliance {
	index := map[string]*Compliance{}

	for _, observation := range in.Observations {
		key := "all"
		switch in.By {
		case "discipline":
			key = string(observation.Discipline)
		case "moment":
			key = string(observation.Moment)
		}

		group, seen := index[key]
		if !seen {
			group = &Compliance{Group: key}
			index[key] = group
		}
		group.Opportunities++
		if observation.Action.Compliant() {
			group.Performed++
		}
		if observation.Action == ActionGlovesOnly {
			group.GlovesInsteadOf++
		}
	}

	out := make([]Compliance, 0, len(index))
	for _, group := range index {
		if in.MinimumOpportunities > 0 &&
			group.Opportunities < in.MinimumOpportunities {
			// Suppressed, and the counts go with it: publishing "four
			// opportunities, one performed" against a night-shift category
			// names a person by arithmetic.
			out = append(out, Compliance{
				Group: group.Group, Suppressed: true,
			})
			continue
		}
		group.Permille = permille(int64(group.Performed),
			int64(group.Opportunities))
		out = append(out, *group)
	}

	sort.Slice(out, func(a, b int) bool {
		// Worst first among the reportable groups, suppressed ones last.
		if out[a].Suppressed != out[b].Suppressed {
			return !out[a].Suppressed
		}
		if out[a].Permille != out[b].Permille {
			return out[a].Permille < out[b].Permille
		}
		return out[a].Group < out[b].Group
	})
	return out
}
