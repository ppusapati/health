package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Daily goals and rounds (SRS-ICU-008), and goals-of-care documentation
// (SRS-ICU-015).

// GoalStatus is where a daily goal has got to.
type GoalStatus string

const (
	GoalOpen GoalStatus = "open"
	GoalMet  GoalStatus = "met"
	// GoalNotMet is a goal the day did not achieve. Distinct from cancelled,
	// because a goal that was not met is the one the next round starts from
	// and a cancelled one is no longer wanted.
	GoalNotMet    GoalStatus = "not_met"
	GoalCancelled GoalStatus = "cancelled"
)

// Goal is one thing the unit means to achieve today (SRS-ICU-008).
//
// Owner and status, because the requirement says so and because a goal with
// neither is a sentence in a note: "wean sedation" on a board nobody owns is
// how a patient is still sedated on Thursday.
type Goal struct {
	ID        string
	TenantID  string
	EpisodeID string
	RoundID   string

	// Domain groups goals the way a round is run — respiratory, sedation,
	// nutrition, family. The deployment's own list.
	Domain string
	Text   string
	// OwnerRole is the discipline answerable — "physiotherapy", "nursing".
	// A role rather than a person, because the person changes at handover and
	// the responsibility does not.
	OwnerRole string
	OwnerID   string

	Status GoalStatus
	// TargetAt is when it should be achieved by. Optional: most daily goals
	// are for today.
	TargetAt   time.Time
	ResolvedAt time.Time
	ResolvedBy string
	Outcome    string

	CreatedBy string
	CreatedAt time.Time
}

// NewGoalInput is one daily goal.
type NewGoalInput struct {
	EpisodeID string
	RoundID   string
	Domain    string
	Text      string
	OwnerRole string
	OwnerID   string
	TargetAt  time.Time
}

// NewGoal sets a daily goal (SRS-ICU-008).
func NewGoal(id, tenantID string, in NewGoalInput, by string, now time.Time) (Goal, error) {
	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.EpisodeID) == "":
		return Goal{}, fmt.Errorf("%w: a goal belongs to an episode", ErrInvalidEpisode)
	case strings.TrimSpace(in.Text) == "":
		return Goal{}, fmt.Errorf("%w: a goal says what is to be achieved",
			ErrInvalidEpisode)
	case strings.TrimSpace(in.OwnerRole) == "" && strings.TrimSpace(in.OwnerID) == "":
		// The requirement's own clause. A goal nobody owns is the one the
		// round reads out every morning and nobody does.
		return Goal{}, fmt.Errorf("%w: a goal names who is to achieve it",
			ErrInvalidEpisode)
	case strings.TrimSpace(by) == "":
		return Goal{}, fmt.Errorf("%w: a goal names who set it", ErrInvalidEpisode)
	}

	return Goal{
		ID: id, TenantID: tenantID, EpisodeID: strings.TrimSpace(in.EpisodeID),
		RoundID: strings.TrimSpace(in.RoundID), Domain: strings.TrimSpace(in.Domain),
		Text:      strings.TrimSpace(in.Text),
		OwnerRole: strings.TrimSpace(in.OwnerRole), OwnerID: strings.TrimSpace(in.OwnerID),
		Status: GoalOpen, TargetAt: in.TargetAt.UTC(),
		CreatedBy: strings.TrimSpace(by), CreatedAt: now.UTC(),
	}, nil
}

// Resolve closes a goal.
func (g *Goal) Resolve(status GoalStatus, outcome, by string, at time.Time) error {
	switch status {
	case GoalMet, GoalNotMet, GoalCancelled:
	default:
		return fmt.Errorf("%w: %q does not close a goal", ErrInvalidEpisode, status)
	}
	if g.Status != GoalOpen {
		return fmt.Errorf("%w: this goal is already %s", ErrInvalidEpisode, g.Status)
	}
	if strings.TrimSpace(by) == "" {
		return fmt.Errorf("%w: closing a goal names who closed it", ErrInvalidEpisode)
	}
	if status != GoalMet && strings.TrimSpace(outcome) == "" {
		// A goal met needs no explanation. One that was not met, or was
		// abandoned, is the entry the next round has to act on.
		return fmt.Errorf("%w: say why the goal was not met", ErrInvalidEpisode)
	}
	g.Status, g.Outcome = status, strings.TrimSpace(outcome)
	g.ResolvedBy, g.ResolvedAt = strings.TrimSpace(by), at.UTC()
	return nil
}

// Round is one multidisciplinary ward round (SRS-ICU-008).
type Round struct {
	ID        string
	TenantID  string
	EpisodeID string

	// Attendance is who was on the round, by role. Recorded because a
	// multidisciplinary round with no pharmacist is not a multidisciplinary
	// round, and a unit measuring its rounds needs to see that.
	Attendance []string
	Summary    string

	PerformedAt time.Time
	PerformedBy string
}

// NewRound records a ward round.
func NewRound(id, tenantID, episodeID string, attendance []string, summary, by string,
	at time.Time) (Round, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(episodeID) == "":
		return Round{}, fmt.Errorf("%w: a round belongs to an episode", ErrInvalidEpisode)
	case strings.TrimSpace(by) == "":
		return Round{}, fmt.Errorf("%w: a round names who led it", ErrInvalidEpisode)
	}

	roles := make([]string, 0, len(attendance))
	for _, role := range attendance {
		if trimmed := strings.TrimSpace(role); trimmed != "" {
			roles = append(roles, trimmed)
		}
	}
	sort.Strings(roles)

	return Round{
		ID: id, TenantID: tenantID, EpisodeID: strings.TrimSpace(episodeID),
		Attendance: roles, Summary: strings.TrimSpace(summary),
		PerformedAt: at.UTC(), PerformedBy: strings.TrimSpace(by),
	}, nil
}

// OpenGoals returns the goals still to be achieved, so the next round starts
// from what the last one left (SRS-ICU-008's "remain visible on rounds view").
func OpenGoals(goals []Goal) []Goal {
	out := make([]Goal, 0, len(goals))
	for _, goal := range goals {
		if goal.Status == GoalOpen {
			out = append(out, goal)
		}
	}
	sort.SliceStable(out, func(i, j int) bool {
		if out[i].Domain != out[j].Domain {
			return out[i].Domain < out[j].Domain
		}
		return out[i].CreatedAt.Before(out[j].CreatedAt)
	})
	return out
}

// Goals of care and escalation limitation (SRS-ICU-015).

// CareIntent is how far treatment goes.
type CareIntent string

const (
	// IntentFullEscalation is everything, which is where every patient starts.
	IntentFullEscalation CareIntent = "full_escalation"
	// IntentLimited is a ceiling: ward-level care, no intubation, no
	// vasopressors — whatever the limitations say.
	IntentLimited CareIntent = "limited"
	IntentComfort CareIntent = "comfort"
)

var knownIntents = map[CareIntent]bool{
	IntentFullEscalation: true, IntentLimited: true, IntentComfort: true,
}

// GoalsOfCare is a documented ceiling of treatment (SRS-ICU-015).
//
// Superseded rather than edited. A ceiling of treatment is the document a
// coroner reads, and one whose history was overwritten cannot answer the
// question that is actually asked: what was agreed, by whom, and when did it
// change.
type GoalsOfCare struct {
	ID        string
	TenantID  string
	EpisodeID string

	Intent CareIntent
	// Limitations are the specific ceilings agreed — "no intubation", "no
	// CPR", "ward-based care only".
	Limitations []string
	// CPRStatus is recorded separately because it is the one question every
	// arriving team asks first, and burying it in a list is how it is missed.
	CPRStatus string

	// DiscussedWith records the conversation. A ceiling recorded without one
	// is a decision made about somebody rather than with them.
	DiscussedWith string
	Rationale     string

	// AuthorisedBy is the senior clinician who owns the decision. The
	// requirement's "restricted authorization" is a permission on the way in;
	// this is the name that stays in the record.
	AuthorisedBy   string
	AuthorisedRole string

	RecordedAt time.Time
	RecordedBy string
	// SupersededBy names the version that replaced this one, and
	// SupersededAt when. A superseded ceiling is not the current one and is
	// still the record.
	SupersededBy string
	SupersededAt time.Time
	// ReviewBy is when the decision is to be revisited. A ceiling with no
	// review date outlives the conversation that produced it.
	ReviewBy time.Time
}

// NewGoalsOfCareInput documents a ceiling of treatment.
type NewGoalsOfCareInput struct {
	EpisodeID      string
	Intent         CareIntent
	Limitations    []string
	CPRStatus      string
	DiscussedWith  string
	Rationale      string
	AuthorisedBy   string
	AuthorisedRole string
	ReviewBy       time.Time
}

// RecordGoalsOfCare documents a ceiling of treatment (SRS-ICU-015).
func RecordGoalsOfCare(id, tenantID string, in NewGoalsOfCareInput, by string,
	now time.Time) (GoalsOfCare, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.EpisodeID) == "":
		return GoalsOfCare{}, fmt.Errorf("%w: a ceiling of treatment belongs to an episode",
			ErrInvalidEpisode)
	case !knownIntents[in.Intent]:
		return GoalsOfCare{}, fmt.Errorf("%w: unknown treatment intent %q",
			ErrInvalidEpisode, in.Intent)
	case strings.TrimSpace(in.AuthorisedBy) == "":
		// The decision belongs to a named senior clinician. A ceiling
		// attributed to a system is one nobody can be asked about.
		return GoalsOfCare{}, fmt.Errorf("%w: a ceiling of treatment names who authorised it",
			ErrInvalidEpisode)
	case strings.TrimSpace(by) == "":
		return GoalsOfCare{}, fmt.Errorf("%w: a ceiling of treatment names who recorded it",
			ErrInvalidEpisode)
	}
	if in.Intent != IntentFullEscalation && strings.TrimSpace(in.Rationale) == "" {
		// Limiting treatment without a recorded reason is the entry a review
		// asks about and the record cannot answer.
		return GoalsOfCare{}, fmt.Errorf("%w: limiting treatment needs a rationale",
			ErrInvalidEpisode)
	}
	if in.Intent == IntentLimited && len(trimmedAll(in.Limitations)) == 0 &&
		strings.TrimSpace(in.CPRStatus) == "" {
		return GoalsOfCare{}, fmt.Errorf(
			"%w: say what the limitation is; \"limited\" on its own is not a ceiling anybody can act on",
			ErrInvalidEpisode)
	}

	return GoalsOfCare{
		ID: id, TenantID: tenantID, EpisodeID: strings.TrimSpace(in.EpisodeID),
		Intent: in.Intent, Limitations: trimmedAll(in.Limitations),
		CPRStatus:      strings.TrimSpace(in.CPRStatus),
		DiscussedWith:  strings.TrimSpace(in.DiscussedWith),
		Rationale:      strings.TrimSpace(in.Rationale),
		AuthorisedBy:   strings.TrimSpace(in.AuthorisedBy),
		AuthorisedRole: strings.TrimSpace(in.AuthorisedRole),
		RecordedAt:     now.UTC(), RecordedBy: strings.TrimSpace(by),
		ReviewBy: in.ReviewBy.UTC(),
	}, nil
}

func trimmedAll(in []string) []string {
	out := make([]string, 0, len(in))
	for _, value := range in {
		if trimmed := strings.TrimSpace(value); trimmed != "" {
			out = append(out, trimmed)
		}
	}
	return out
}

// Current reports whether this is the ceiling in force.
func (g GoalsOfCare) Current() bool { return g.SupersededBy == "" }

// ReviewOverdue reports a ceiling past its review date.
func (g GoalsOfCare) ReviewOverdue(now time.Time) bool {
	return g.Current() && !g.ReviewBy.IsZero() && now.After(g.ReviewBy)
}

// CurrentGoalsOfCare returns the ceiling in force, if any.
func CurrentGoalsOfCare(all []GoalsOfCare) (GoalsOfCare, bool) {
	var best GoalsOfCare
	found := false
	for _, g := range all {
		if !g.Current() {
			continue
		}
		if !found || g.RecordedAt.After(best.RecordedAt) {
			best, found = g, true
		}
	}
	return best, found
}
