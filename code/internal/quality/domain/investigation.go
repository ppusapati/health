package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// FactorCategory groups what contributed to an incident (SRS-QMS-003).
//
// Categorised rather than free text, because the whole value of root cause
// analysis across many incidents is being able to say "eleven of our last
// twenty had a staffing factor". Free text cannot be counted.
type FactorCategory string

const (
	FactorPatient        FactorCategory = "patient"
	FactorTask           FactorCategory = "task"
	FactorIndividual     FactorCategory = "individual"
	FactorTeam           FactorCategory = "team"
	FactorEnvironment    FactorCategory = "environment"
	FactorEquipment      FactorCategory = "equipment"
	FactorOrganisational FactorCategory = "organisational"
)

var knownFactorCategory = map[FactorCategory]bool{
	FactorPatient: true, FactorTask: true, FactorIndividual: true,
	FactorTeam: true, FactorEnvironment: true, FactorEquipment: true,
	FactorOrganisational: true,
}

// ContributingFactor is one thing that helped the incident happen.
type ContributingFactor struct {
	Category FactorCategory
	Detail   string
	// Root marks a factor the analysis concluded was a cause rather than a
	// circumstance. Separate, because an analysis that calls everything a root
	// cause has not analysed anything.
	Root bool
}

// RCAState is where an analysis stands.
type RCAState string

const (
	RCAOpen     RCAState = "open"
	RCAComplete RCAState = "complete"
)

// RCA is a root cause analysis of one incident (SRS-QMS-003).
type RCA struct {
	ID         string
	TenantID   string
	IncidentID string

	// Method is the technique used — five whys, fishbone, the London
	// Protocol. Named rather than assumed, because the method decides what the
	// analysis can find, and a reader has to know which was used.
	Method string
	// AccountableOwner is the person answerable for the analysis and for what
	// follows from it. The requirement's acceptance is that the analysis
	// cannot close without one, and the reason is the failure mode: an
	// analysis owned by "the committee" is owned by nobody.
	AccountableOwner string

	Factors []ContributingFactor
	// Findings is the narrative conclusion.
	Findings string
	// NoActionReason explains an analysis that produced no corrective action.
	// Required when none was raised, because "we investigated and changed
	// nothing" is a defensible conclusion and an undefended one is how root
	// cause analysis becomes paperwork.
	NoActionReason string

	State      RCAState
	OpenedAt   time.Time
	OpenedBy   string
	ClosedAt   time.Time
	ClosedBy   string
	Version    int64
	Restricted bool
}

// StartRCA opens an analysis (SRS-QMS-003).
func StartRCA(id, tenantID, incidentID, method string, restricted bool,
	by string, now time.Time) (RCA, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return RCA{}, fmt.Errorf("%w: an analysis needs an id", ErrInvalidQuality)
	case strings.TrimSpace(incidentID) == "":
		return RCA{}, fmt.Errorf("%w: an analysis names its incident",
			ErrInvalidQuality)
	case strings.TrimSpace(method) == "":
		return RCA{}, fmt.Errorf("%w: an analysis names its method",
			ErrInvalidQuality)
	}
	return RCA{
		ID: id, TenantID: tenantID, IncidentID: incidentID,
		Method: strings.TrimSpace(method), State: RCAOpen,
		Restricted: restricted,
		OpenedAt:   now.UTC(), OpenedBy: by, Version: 1,
	}, nil
}

// AddFactor records something that contributed (SRS-QMS-003).
func (r *RCA) AddFactor(f ContributingFactor) error {
	switch {
	case r.State != RCAOpen:
		return fmt.Errorf("%w: this analysis is %s", ErrInvalidQuality, r.State)
	case !knownFactorCategory[f.Category]:
		return fmt.Errorf("%w: unknown contributing factor category %q",
			ErrInvalidQuality, f.Category)
	case strings.TrimSpace(f.Detail) == "":
		return fmt.Errorf("%w: a contributing factor needs a description",
			ErrInvalidQuality)
	}
	f.Detail = strings.TrimSpace(f.Detail)
	r.Factors = append(r.Factors, f)
	return nil
}

// CompleteRCA closes an analysis (SRS-QMS-003).
//
// actions is how many corrective actions were raised from it. Passed in rather
// than counted here, because the analysis does not own them — and the check it
// enables is the one that matters: an analysis that found a root cause, raised
// nothing and said nothing about why is how root cause analysis becomes a form
// somebody fills in.
func (r *RCA) CompleteRCA(owner, findings string, actions int, by string,
	now time.Time) error {

	switch {
	case r.State != RCAOpen:
		return fmt.Errorf("%w: this analysis is %s", ErrInvalidQuality, r.State)
	case strings.TrimSpace(owner) == "":
		return fmt.Errorf("%w: an analysis closes with an accountable owner",
			ErrInvalidQuality)
	case len(r.Factors) == 0:
		return fmt.Errorf("%w: this analysis records no contributing factors",
			ErrInvalidQuality)
	case strings.TrimSpace(findings) == "":
		return fmt.Errorf("%w: an analysis closes with its findings",
			ErrInvalidQuality)
	}

	if actions == 0 && strings.TrimSpace(r.NoActionReason) == "" {
		return fmt.Errorf(
			"%w: this analysis raised no corrective action and does not say why",
			ErrInvalidQuality)
	}

	r.AccountableOwner = strings.TrimSpace(owner)
	r.Findings = strings.TrimSpace(findings)
	r.State = RCAComplete
	r.ClosedAt, r.ClosedBy = now.UTC(), by
	return nil
}

// RootCauses returns the factors the analysis concluded were causes.
func (r RCA) RootCauses() []ContributingFactor {
	var out []ContributingFactor
	for _, factor := range r.Factors {
		if factor.Root {
			out = append(out, factor)
		}
	}
	return out
}

// ActionKind separates fixing this one from stopping the next one
// (SRS-QMS-004).
//
// The distinction the letters CAPA stand for and the one hospitals collapse.
// A corrective action repairs the instance; a preventive action changes the
// system so it does not recur. An analysis whose actions are all corrective
// has fixed a patient and left the cause in place.
type ActionKind string

const (
	ActionCorrective ActionKind = "corrective"
	ActionPreventive ActionKind = "preventive"
)

var knownActionKind = map[ActionKind]bool{
	ActionCorrective: true, ActionPreventive: true,
}

// CAPAState is where an action stands (Master SRS Phase 2 §23).
type CAPAState string

const (
	CAPADraft            CAPAState = "draft"
	CAPAApproved         CAPAState = "approved"
	CAPAOpen             CAPAState = "open"
	CAPAInProgress       CAPAState = "action_in_progress"
	CAPAEffectivenessDue CAPAState = "effectiveness_review"
	CAPAClosed           CAPAState = "closed"
	CAPACancelled        CAPAState = "cancelled"
)

var knownCAPAState = map[CAPAState]bool{
	CAPADraft: true, CAPAApproved: true, CAPAOpen: true,
	CAPAInProgress: true, CAPAEffectivenessDue: true,
	CAPAClosed: true, CAPACancelled: true,
}

// Live reports an action still expected to be done.
func (s CAPAState) Live() bool {
	return s != CAPAClosed && s != CAPACancelled
}

// SourceKind is what raised an action.
type SourceKind string

const (
	SourceIncident   SourceKind = "incident"
	SourceRCA        SourceKind = "rca"
	SourceAudit      SourceKind = "audit_finding"
	SourceComplaint  SourceKind = "complaint"
	SourceCommittee  SourceKind = "committee"
	SourceInspection SourceKind = "inspection"
)

var knownSourceKind = map[SourceKind]bool{
	SourceIncident: true, SourceRCA: true, SourceAudit: true,
	SourceComplaint: true, SourceCommittee: true, SourceInspection: true,
}

// EffectivenessCheck is the step that says whether the action worked
// (SRS-QMS-004).
//
// Its own structure rather than a boolean on the action, because the answer
// "we checked and it did not work" has to be recordable and has to not close
// the action. A CAPA closed on a check that failed is the same defect coming
// back with a closed ticket in front of it.
type EffectivenessCheck struct {
	CheckedAt time.Time
	CheckedBy string
	Effective bool
	// Evidence is what was looked at. Required, because "yes it worked" is an
	// opinion and a re-audit result is a fact.
	Evidence string
}

// CAPA is one corrective or preventive action (SRS-QMS-004).
type CAPA struct {
	ID       string
	TenantID string

	Reference string
	Kind      ActionKind

	// What raised it. A CAPA that names no source cannot be traced back to the
	// finding it answers, which is exactly what SRS-QMS-007's acceptance asks
	// for.
	SourceKind SourceKind
	SourceID   string

	Action  string
	OwnerID string
	DueOn   time.Time
	// EffectivenessDueOn is when somebody goes back and checks. Separate from
	// the action's own due date, because the check is meaningless before the
	// change has had time to be used.
	EffectivenessDueOn time.Time

	State CAPAState

	ApprovedBy string
	ApprovedAt time.Time

	// Checks holds every effectiveness review, including the ones that failed.
	// A list rather than the latest, because "we fixed it, checked, it had not
	// worked, fixed it again and it had" is the history that tells a hospital
	// something.
	Checks []EffectivenessCheck

	ClosedBy string
	ClosedAt time.Time
	// ClosureNote and CancelledReason are both required at their step.
	ClosureNote     string
	CancelledReason string

	Restricted bool
	RaisedAt   time.Time
	RaisedBy   string
	Version    int64
}

// NewCAPAInput raises a corrective or preventive action.
type NewCAPAInput struct {
	Reference          string
	Kind               ActionKind
	SourceKind         SourceKind
	SourceID           string
	Action             string
	OwnerID            string
	DueOn              time.Time
	EffectivenessDueOn time.Time
	Restricted         bool
}

// RaiseCAPA creates an action (SRS-QMS-004).
func RaiseCAPA(id, tenantID string, in NewCAPAInput, by string,
	now time.Time) (CAPA, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return CAPA{}, fmt.Errorf("%w: an action needs an id", ErrInvalidQuality)
	case !knownActionKind[in.Kind]:
		return CAPA{}, fmt.Errorf("%w: unknown action kind %q",
			ErrInvalidQuality, in.Kind)
	case !knownSourceKind[in.SourceKind]:
		return CAPA{}, fmt.Errorf("%w: unknown action source %q",
			ErrInvalidQuality, in.SourceKind)
	case strings.TrimSpace(in.SourceID) == "":
		return CAPA{}, fmt.Errorf("%w: an action names what raised it",
			ErrInvalidQuality)
	case strings.TrimSpace(in.Action) == "":
		return CAPA{}, fmt.Errorf("%w: an action says what will be done",
			ErrInvalidQuality)
	case strings.TrimSpace(in.OwnerID) == "":
		// An action owned by a department is owned by nobody in it.
		return CAPA{}, fmt.Errorf("%w: an action names one owner",
			ErrInvalidQuality)
	case in.DueOn.IsZero():
		return CAPA{}, fmt.Errorf("%w: an action needs a due date",
			ErrInvalidQuality)
	case !in.EffectivenessDueOn.IsZero() &&
		in.EffectivenessDueOn.Before(in.DueOn):
		// Checking whether a change worked before it was made is a check that
		// will pass and mean nothing.
		return CAPA{}, fmt.Errorf(
			"%w: the effectiveness check falls before the action is due",
			ErrInvalidQuality)
	}

	return CAPA{
		ID: id, TenantID: tenantID,
		Reference: strings.TrimSpace(in.Reference), Kind: in.Kind,
		SourceKind: in.SourceKind, SourceID: in.SourceID,
		Action: strings.TrimSpace(in.Action), OwnerID: in.OwnerID,
		DueOn:              in.DueOn.UTC(),
		EffectivenessDueOn: utcOrZero(in.EffectivenessDueOn),
		State:              CAPADraft,
		Restricted:         in.Restricted,
		RaisedAt:           now.UTC(), RaisedBy: by, Version: 1,
	}, nil
}

func utcOrZero(t time.Time) time.Time {
	if t.IsZero() {
		return time.Time{}
	}
	return t.UTC()
}

// ApproveCAPA authorises an action to start (SRS-QMS-004).
//
// Refused for the person who raised it. An action somebody raised, approved,
// did and closed is one person's account of their own work, and the approval
// step exists precisely so that there are two.
func (c *CAPA) ApproveCAPA(by string, now time.Time) error {
	switch {
	case c.State != CAPADraft:
		return fmt.Errorf("%w: this action is %s", ErrInvalidQuality, c.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an approval names who gave it", ErrInvalidQuality)
	case by == c.RaisedBy:
		return fmt.Errorf("%w: the person who raised this action cannot approve it",
			ErrInvalidQuality)
	}
	c.State = CAPAApproved
	c.ApprovedBy, c.ApprovedAt = by, now.UTC()
	return nil
}

// AdvanceCAPA moves an action along.
func (c *CAPA) AdvanceCAPA(to CAPAState, reason string, now time.Time) error {
	switch {
	case !knownCAPAState[to]:
		return fmt.Errorf("%w: unknown action state %q", ErrInvalidQuality, to)
	case !c.State.Live():
		return fmt.Errorf("%w: this action is already %s",
			ErrInvalidQuality, c.State)
	case to == CAPADraft || to == CAPAApproved:
		return fmt.Errorf("%w: an action does not go back to %s",
			ErrInvalidQuality, to)
	case to == CAPAClosed:
		return fmt.Errorf(
			"%w: closing an action goes through its effectiveness check",
			ErrInvalidQuality)
	case c.State == CAPADraft:
		return fmt.Errorf("%w: this action has not been approved",
			ErrInvalidQuality)
	case to == CAPACancelled && strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say why this action is cancelled",
			ErrInvalidQuality)
	}

	c.State = to
	if to == CAPACancelled {
		c.CancelledReason = strings.TrimSpace(reason)
		c.ClosedAt = now.UTC()
	}
	return nil
}

// RecordCheck records an effectiveness review (SRS-QMS-004).
//
// A failed check is recorded and sends the action back to work rather than
// being discarded. The failure is the finding: a corrective action that did
// not work is information about the analysis that produced it.
func (c *CAPA) RecordCheck(check EffectivenessCheck, now time.Time) error {
	switch {
	case !c.State.Live():
		return fmt.Errorf("%w: this action is %s", ErrInvalidQuality, c.State)
	case c.State == CAPADraft || c.State == CAPAApproved:
		return fmt.Errorf(
			"%w: an effectiveness check comes after the action, not before it",
			ErrInvalidQuality)
	case strings.TrimSpace(check.CheckedBy) == "":
		return fmt.Errorf("%w: a check names who made it", ErrInvalidQuality)
	case strings.TrimSpace(check.Evidence) == "":
		// "It worked" is an opinion; a re-audit result is a fact.
		return fmt.Errorf("%w: a check records what was looked at",
			ErrInvalidQuality)
	}

	check.Evidence = strings.TrimSpace(check.Evidence)
	if check.CheckedAt.IsZero() {
		check.CheckedAt = now.UTC()
	} else {
		check.CheckedAt = check.CheckedAt.UTC()
	}
	c.Checks = append(c.Checks, check)

	if check.Effective {
		c.State = CAPAEffectivenessDue
	} else {
		// Back to work. The loop does not close on a change that did not
		// change anything.
		c.State = CAPAInProgress
	}
	return nil
}

// Effective reports whether the most recent check passed.
func (c CAPA) Effective() bool {
	if len(c.Checks) == 0 {
		return false
	}
	return c.Checks[len(c.Checks)-1].Effective
}

// CloseCAPA signs an action off (SRS-QMS-004).
//
// Two refusals, and both are the ones a hospital's own audit finds: closing
// without an effectiveness check that passed, and closing as the owner who did
// the work.
func (c *CAPA) CloseCAPA(by, note string, now time.Time) error {
	switch {
	case !c.State.Live():
		return fmt.Errorf("%w: this action is already %s",
			ErrInvalidQuality, c.State)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a closure names who approved it",
			ErrInvalidQuality)
	case len(c.Checks) == 0:
		return fmt.Errorf(
			"%w: this action has not been checked for effectiveness",
			ErrInvalidQuality)
	case !c.Effective():
		return fmt.Errorf(
			"%w: the last effectiveness check found this action did not work",
			ErrInvalidQuality)
	case by == c.OwnerID:
		return fmt.Errorf(
			"%w: the owner of an action cannot approve its closure",
			ErrInvalidQuality)
	}

	c.State = CAPAClosed
	c.ClosedBy, c.ClosedAt = by, now.UTC()
	c.ClosureNote = strings.TrimSpace(note)
	return nil
}

// Overdue reports an action past a date it should have met (SRS-QMS-004).
//
// Derived, never stored. A stored overdue flag is wrong twice: it is stale
// until a job runs, and it stays set after the action is done.
type Overdue struct {
	CAPA CAPA
	// ActionOverdueDays and CheckOverdueDays are positive once each date has
	// passed. Reported separately, because an action that was done on time and
	// never checked is a different failure from one that was never done.
	ActionOverdueDays int
	CheckOverdueDays  int
}

// OverdueActions lists what has run past its dates (SRS-QMS-004).
func OverdueActions(actions []CAPA, now time.Time) []Overdue {
	var out []Overdue
	for _, action := range actions {
		if !action.State.Live() {
			continue
		}
		line := Overdue{CAPA: action}

		// The action's own date stops mattering once the work is done and
		// under review.
		working := action.State == CAPAOpen || action.State == CAPAInProgress ||
			action.State == CAPAApproved
		if working && !action.DueOn.IsZero() && now.After(action.DueOn) {
			line.ActionOverdueDays = daysBetween(action.DueOn, now)
		}
		if !action.EffectivenessDueOn.IsZero() &&
			now.After(action.EffectivenessDueOn) && !action.Effective() {
			line.CheckOverdueDays = daysBetween(action.EffectivenessDueOn, now)
		}
		if line.ActionOverdueDays > 0 || line.CheckOverdueDays > 0 {
			out = append(out, line)
		}
	}

	sort.Slice(out, func(a, b int) bool {
		worst := func(o Overdue) int {
			if o.ActionOverdueDays > o.CheckOverdueDays {
				return o.ActionOverdueDays
			}
			return o.CheckOverdueDays
		}
		if worst(out[a]) != worst(out[b]) {
			return worst(out[a]) > worst(out[b])
		}
		return out[a].CAPA.Reference < out[b].CAPA.Reference
	})
	return out
}

func daysBetween(from, to time.Time) int {
	return int(to.Sub(from).Hours() / 24)
}
