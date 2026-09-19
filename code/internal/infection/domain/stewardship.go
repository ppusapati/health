package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// TriggerKind is why a stewardship review was raised (SRS-IPC-008).
//
// Each kind is a question somebody has to answer about a prescription that is
// already running. None of them is an instruction, and none of them changes
// the prescription: the requirement's acceptance is explicit that a review
// appears in the worklist "without autonomous medication change", so this
// context produces advice and records what the prescriber then did.
type TriggerKind string

const (
	// TriggerRestrictedAgent is a reserved antimicrobial in use.
	TriggerRestrictedAgent TriggerKind = "restricted_agent"
	// TriggerDuration is therapy that has run past a review point.
	TriggerDuration TriggerKind = "duration"
	// TriggerMismatch is an organism reported resistant to what the patient
	// is actually on.
	TriggerMismatch TriggerKind = "bug_drug_mismatch"
	// TriggerDeEscalation is broad-spectrum cover still running after the
	// culture came back.
	TriggerDeEscalation TriggerKind = "de_escalation"
	// TriggerIVToOral is intravenous therapy where the oral route is
	// available.
	TriggerIVToOral TriggerKind = "iv_to_oral"
	// TriggerRedundantCover is two agents from one group covering the same
	// thing.
	TriggerRedundantCover TriggerKind = "redundant_cover"
)

var knownTriggerKind = map[TriggerKind]bool{
	TriggerRestrictedAgent: true, TriggerDuration: true,
	TriggerMismatch: true, TriggerDeEscalation: true,
	TriggerIVToOral: true, TriggerRedundantCover: true,
}

// StewardshipRule is a configured review trigger (SRS-IPC-008).
//
// Versioned by (code, revision) for the same reason the alert rules are: a
// review raised last quarter under a three-day duration threshold has to stay
// explicable after the threshold moves to five, and a rule edited in place
// would make every past review unexplainable.
type StewardshipRule struct {
	ID       string
	TenantID string

	Code     string
	Name     string
	Revision int

	Kind TriggerKind
	// Agents are the antimicrobials the rule watches. For a redundant-cover
	// rule they are the group: two of them running together is the trigger.
	Agents []string
	// AllAgents says the rule watches every antimicrobial. Explicit rather
	// than inferred from an empty agent list: a rule that silently widened to
	// everything because somebody deleted its last agent would flood the
	// worklist, and a flooded worklist is an unread one.
	AllAgents bool
	// DayThreshold is the day of therapy at which a duration, de-escalation
	// or route rule starts asking. Day 1 is the first day.
	DayThreshold int

	// Prompt is the question put to the reviewer. A trigger that says only
	// "review" gets a review that says only "continue".
	Prompt string

	Approved   bool
	ApprovedBy string
	ApprovedAt time.Time

	EffectiveFrom time.Time
	SupersededAt  time.Time
	CreatedAt     time.Time
	CreatedBy     string
}

// Live reports a rule in force at a moment.
func (r StewardshipRule) Live(at time.Time) bool {
	if !r.Approved {
		return false
	}
	if r.EffectiveFrom.IsZero() || r.EffectiveFrom.After(at) {
		return false
	}
	return r.SupersededAt.IsZero() || r.SupersededAt.After(at)
}

// WatchesAgent reports whether a rule covers an antimicrobial.
func (r StewardshipRule) WatchesAgent(agent string) bool {
	if r.AllAgents {
		return true
	}
	for _, name := range r.Agents {
		if strings.EqualFold(name, agent) {
			return true
		}
	}
	return false
}

// NewStewardshipRuleInput configures a review trigger.
type NewStewardshipRuleInput struct {
	Code          string
	Name          string
	Revision      int
	Kind          TriggerKind
	Agents        []string
	AllAgents     bool
	DayThreshold  int
	Prompt        string
	EffectiveFrom time.Time
}

// NewStewardshipRule configures a review trigger (SRS-IPC-008).
func NewStewardshipRule(id, tenantID string, in NewStewardshipRuleInput,
	by string, now time.Time) (StewardshipRule, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return StewardshipRule{}, fmt.Errorf("%w: a rule needs an id",
			ErrInvalidInfection)
	case strings.TrimSpace(in.Code) == "":
		return StewardshipRule{}, fmt.Errorf("%w: a rule needs a code",
			ErrInvalidInfection)
	case in.Revision <= 0:
		return StewardshipRule{}, fmt.Errorf("%w: a rule revision starts at 1",
			ErrInvalidInfection)
	case !knownTriggerKind[in.Kind]:
		return StewardshipRule{}, fmt.Errorf("%w: unknown trigger kind %q",
			ErrInvalidInfection, in.Kind)
	case len(in.Agents) == 0 && !in.AllAgents:
		return StewardshipRule{}, fmt.Errorf(
			"%w: a rule names its agents or says it watches all of them",
			ErrInvalidInfection)
	case strings.TrimSpace(in.Prompt) == "":
		return StewardshipRule{}, fmt.Errorf(
			"%w: a trigger states the question it asks", ErrInvalidInfection)
	}

	// A group of one cannot be redundant with itself, and a rule that looked
	// like it was watching for double cover while watching one drug would
	// quietly never fire.
	if in.Kind == TriggerRedundantCover && len(normalise(in.Agents)) < 2 {
		return StewardshipRule{}, fmt.Errorf(
			"%w: a redundant-cover rule names at least two agents",
			ErrInvalidInfection)
	}
	switch in.Kind {
	case TriggerDuration, TriggerDeEscalation, TriggerIVToOral:
		if in.DayThreshold <= 0 {
			return StewardshipRule{}, fmt.Errorf(
				"%w: a %s rule names the day it starts asking",
				ErrInvalidInfection, in.Kind)
		}
	}

	return StewardshipRule{
		ID: id, TenantID: tenantID,
		Code: strings.TrimSpace(in.Code), Name: strings.TrimSpace(in.Name),
		Revision: in.Revision, Kind: in.Kind,
		Agents: normalise(in.Agents), AllAgents: in.AllAgents,
		DayThreshold:  in.DayThreshold,
		Prompt:        strings.TrimSpace(in.Prompt),
		EffectiveFrom: utcOrZero(in.EffectiveFrom),
		CreatedAt:     now.UTC(), CreatedBy: by,
	}, nil
}

// Approve signs a stewardship rule off (SRS-IPC-008).
//
// Refused for its author, like every other rule that decides what the whole
// hospital is asked about.
func (r *StewardshipRule) Approve(by string, effectiveFrom, now time.Time) error {
	switch {
	case r.Approved:
		return fmt.Errorf("%w: this rule is already approved",
			ErrInvalidInfection)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an approval names who gave it",
			ErrInvalidInfection)
	case by == r.CreatedBy:
		return fmt.Errorf("%w: the author of a rule cannot approve it",
			ErrInvalidInfection)
	case effectiveFrom.IsZero():
		return fmt.Errorf("%w: an approved rule names when it takes effect",
			ErrInvalidInfection)
	}
	r.Approved, r.ApprovedBy, r.ApprovedAt = true, by, now.UTC()
	r.EffectiveFrom = effectiveFrom.UTC()
	return nil
}

// AgentInUse is one antimicrobial a patient is actually on (SRS-IPC-008).
type AgentInUse struct {
	// OrderID is the prescription this came from. Carried so a reviewer can
	// open the order — never so this context can write to it.
	OrderID string
	Agent   string
	Route   string
	// DayOfTherapy counts from the first day, so day 1 is the first day and
	// not the day after.
	DayOfTherapy int
	Restricted   bool
	StartedAt    time.Time
}

// Intravenous reports a route the switch rules care about.
func (a AgentInUse) Intravenous() bool {
	route := strings.ToLower(strings.TrimSpace(a.Route))
	return route == "iv" || route == "intravenous"
}

// CultureResult is what the laboratory reported (SRS-IPC-008).
type CultureResult struct {
	ResultID    string
	Organism    string
	Susceptible []string
	Resistant   []string
	ResultedAt  time.Time
}

// ResistantTo reports an organism reported resistant to an agent.
func (c CultureResult) ResistantTo(agent string) bool {
	for _, name := range c.Resistant {
		if strings.EqualFold(name, agent) {
			return true
		}
	}
	return false
}

// TherapySignal is the picture the rules are evaluated against (SRS-IPC-008).
//
// Assembled by a caller from orders, administrations and laboratory results.
// This context reads it; it has no path back to any of them.
type TherapySignal struct {
	PatientID   string
	EncounterID string
	LocationID  string
	Therapy     []AgentInUse
	// Culture is the organism report, where one has come back.
	Culture *CultureResult
	// OralRouteAvailable is the ward's answer to "is this patient eating and
	// absorbing", which no laboratory result can supply.
	OralRouteAvailable bool
}

// Trigger is one rule firing against one signal (SRS-IPC-008).
type Trigger struct {
	RuleID       string
	RuleCode     string
	RuleRevision int
	Kind         TriggerKind
	// Agent is the antimicrobial that fired it, so two reviews on one patient
	// stay distinguishable.
	Agent   string
	OrderID string
	// Why states the fact that fired the rule, in words a prescriber reads.
	Why string
}

// TriggeredRules evaluates the live rules against a signal (SRS-IPC-008).
//
// Pure: the same rules and the same signal give the same triggers, which is
// what makes a stewardship worklist defensible at a committee.
func TriggeredRules(rules []StewardshipRule, signal TherapySignal,
	at time.Time) []Trigger {

	var out []Trigger
	for _, rule := range rules {
		if !rule.Live(at) {
			continue
		}
		out = append(out, rule.fire(signal)...)
	}
	sort.Slice(out, func(a, b int) bool {
		if out[a].Agent != out[b].Agent {
			return out[a].Agent < out[b].Agent
		}
		return out[a].RuleCode < out[b].RuleCode
	})
	return out
}

func (r StewardshipRule) fire(signal TherapySignal) []Trigger {
	raise := func(agent, orderID, why string) Trigger {
		return Trigger{
			RuleID: r.ID, RuleCode: r.Code, RuleRevision: r.Revision,
			Kind: r.Kind, Agent: agent, OrderID: orderID, Why: why,
		}
	}

	if r.Kind == TriggerRedundantCover {
		var hits []AgentInUse
		for _, agent := range signal.Therapy {
			if r.WatchesAgent(agent.Agent) {
				hits = append(hits, agent)
			}
		}
		if len(hits) < 2 {
			return nil
		}
		names := make([]string, 0, len(hits))
		for _, hit := range hits {
			names = append(names, hit.Agent)
		}
		return []Trigger{raise(hits[0].Agent, hits[0].OrderID,
			fmt.Sprintf("%s are running together", strings.Join(names, " and ")))}
	}

	var out []Trigger
	for _, agent := range signal.Therapy {
		if !r.WatchesAgent(agent.Agent) {
			continue
		}
		switch r.Kind {
		case TriggerRestrictedAgent:
			if agent.Restricted {
				out = append(out, raise(agent.Agent, agent.OrderID,
					fmt.Sprintf("%s is a restricted agent", agent.Agent)))
			}
		case TriggerDuration:
			if agent.DayOfTherapy >= r.DayThreshold {
				out = append(out, raise(agent.Agent, agent.OrderID,
					fmt.Sprintf("%s is on day %d",
						agent.Agent, agent.DayOfTherapy)))
			}
		case TriggerMismatch:
			if signal.Culture != nil && signal.Culture.ResistantTo(agent.Agent) {
				out = append(out, raise(agent.Agent, agent.OrderID,
					fmt.Sprintf("%s is reported resistant to %s",
						signal.Culture.Organism, agent.Agent)))
			}
		case TriggerDeEscalation:
			// Only once the laboratory has given the prescriber something to
			// narrow to. Asking before the culture is back asks a question
			// nobody can answer, and unanswerable prompts are how a worklist
			// gets ignored.
			if signal.Culture != nil && len(signal.Culture.Susceptible) > 0 &&
				agent.DayOfTherapy >= r.DayThreshold {
				out = append(out, raise(agent.Agent, agent.OrderID,
					fmt.Sprintf("%s is susceptible to %s",
						signal.Culture.Organism,
						strings.Join(signal.Culture.Susceptible, ", "))))
			}
		case TriggerIVToOral:
			if agent.Intravenous() && signal.OralRouteAvailable &&
				agent.DayOfTherapy >= r.DayThreshold {
				out = append(out, raise(agent.Agent, agent.OrderID,
					fmt.Sprintf("%s is intravenous on day %d and the patient is taking oral",
						agent.Agent, agent.DayOfTherapy)))
			}
		}
	}
	return out
}

// ReviewState is where a stewardship review stands (SRS-IPC-008).
type ReviewState string

const (
	ReviewOpen ReviewState = "open"
	// ReviewAdvised is a review the pharmacist or microbiologist has answered.
	// The prescription is unchanged at this point, always.
	ReviewAdvised ReviewState = "advised"
	// ReviewClosed is advice a prescriber has responded to.
	ReviewClosed ReviewState = "closed"
	// ReviewWithdrawn is a review overtaken by events — the patient was
	// discharged, the drug was stopped before anybody looked.
	ReviewWithdrawn ReviewState = "withdrawn"
)

// Recommendation is what the reviewer advises (SRS-IPC-008).
type Recommendation string

const (
	RecommendContinue    Recommendation = "continue"
	RecommendStop        Recommendation = "stop"
	RecommendNarrow      Recommendation = "narrow_spectrum"
	RecommendSwitchOral  Recommendation = "switch_to_oral"
	RecommendChangeDose  Recommendation = "change_dose"
	RecommendSendCulture Recommendation = "send_cultures"
	RecommendReferID     Recommendation = "refer_to_infection_specialist"
)

var knownRecommendation = map[Recommendation]bool{
	RecommendContinue: true, RecommendStop: true, RecommendNarrow: true,
	RecommendSwitchOral: true, RecommendChangeDose: true,
	RecommendSendCulture: true, RecommendReferID: true,
}

// Response is what the prescriber did about the advice (SRS-IPC-008).
type Response string

const (
	ResponseAccepted Response = "accepted"
	ResponseDeclined Response = "declined"
	// ResponseModified is advice taken in part. Distinguished from accepted
	// because a stewardship programme reporting 90% acceptance where half of
	// it was "we did something else" is reporting a number that is not true.
	ResponseModified Response = "modified"
)

var knownResponse = map[Response]bool{
	ResponseAccepted: true, ResponseDeclined: true, ResponseModified: true,
}

// StewardshipReview is one worklist entry (SRS-IPC-008).
//
// There is deliberately no field on this record that a medication order reads.
// The review carries advice and the prescriber's answer to it; changing the
// prescription happens in the medication context, by a prescriber, through
// their own authority. That is the requirement's acceptance criterion made
// structural rather than promised: this type has nothing to write with.
type StewardshipReview struct {
	ID       string
	TenantID string

	PatientID   string
	EncounterID string
	LocationID  string

	// RuleCode and RuleRevision pin the version that fired, so a review stays
	// explicable after the rule moves on.
	RuleID       string
	RuleCode     string
	RuleRevision int
	Kind         TriggerKind
	Agent        string
	// OrderID is a reference for the reviewer to open. Nothing here writes
	// to it.
	OrderID string
	Why     string

	State    ReviewState
	RaisedAt time.Time
	// DueBy is when the answer stops being useful. A de-escalation review
	// answered on day nine of a seven-day course is not stewardship.
	DueBy time.Time

	Recommendation Recommendation
	Advice         string
	ReviewedBy     string
	ReviewedAt     time.Time

	Response       Response
	ResponseReason string
	RespondedBy    string
	RespondedAt    time.Time

	WithdrawnReason string
	Version         int64
}

// RaiseReview puts a trigger on the worklist (SRS-IPC-008).
func RaiseReview(id, tenantID string, trigger Trigger, signal TherapySignal,
	dueBy time.Time, now time.Time) (StewardshipReview, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return StewardshipReview{}, fmt.Errorf("%w: a review needs an id",
			ErrInvalidInfection)
	case strings.TrimSpace(signal.PatientID) == "":
		return StewardshipReview{}, fmt.Errorf("%w: a review names its patient",
			ErrInvalidInfection)
	case strings.TrimSpace(trigger.RuleCode) == "":
		return StewardshipReview{}, fmt.Errorf(
			"%w: a review names the rule that raised it", ErrInvalidInfection)
	case trigger.RuleRevision <= 0:
		return StewardshipReview{}, fmt.Errorf(
			"%w: a review names the rule revision that raised it",
			ErrInvalidInfection)
	}

	return StewardshipReview{
		ID: id, TenantID: tenantID,
		PatientID: signal.PatientID, EncounterID: signal.EncounterID,
		LocationID: signal.LocationID,
		RuleID:     trigger.RuleID, RuleCode: trigger.RuleCode,
		RuleRevision: trigger.RuleRevision, Kind: trigger.Kind,
		Agent: trigger.Agent, OrderID: trigger.OrderID, Why: trigger.Why,
		State: ReviewOpen, RaisedAt: now.UTC(), DueBy: utcOrZero(dueBy),
		Version: 1,
	}, nil
}

// AlreadyOpen reports a trigger that is already on the worklist for this
// encounter (SRS-IPC-008).
//
// Re-evaluating the same patient every hour must not raise the same review
// every hour. Keyed on the rule code rather than the revision: a rule revised
// mid-admission raises a fresh question, and that one is worth asking again.
func AlreadyOpen(reviews []StewardshipReview, trigger Trigger,
	encounterID string) bool {

	for _, review := range reviews {
		if review.EncounterID != encounterID {
			continue
		}
		if review.State != ReviewOpen && review.State != ReviewAdvised {
			continue
		}
		if review.RuleCode == trigger.RuleCode &&
			review.RuleRevision == trigger.RuleRevision &&
			strings.EqualFold(review.Agent, trigger.Agent) {
			return true
		}
	}
	return false
}

// Advise records the reviewer's recommendation (SRS-IPC-008).
//
// This is the whole of what the stewardship team can do to a prescription:
// say what they think should happen to it.
func (r *StewardshipReview) Advise(recommendation Recommendation,
	advice, by string, now time.Time) error {

	switch {
	case r.State != ReviewOpen:
		return fmt.Errorf("%w: this review is already %s",
			ErrInvalidInfection, r.State)
	case !knownRecommendation[recommendation]:
		return fmt.Errorf("%w: unknown recommendation %q",
			ErrInvalidInfection, recommendation)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: advice names who gave it", ErrInvalidInfection)
	case strings.TrimSpace(advice) == "":
		// "Narrow spectrum" without saying to what is a recommendation the
		// prescriber cannot act on.
		return fmt.Errorf("%w: say what the recommendation is",
			ErrInvalidInfection)
	}

	r.State = ReviewAdvised
	r.Recommendation, r.Advice = recommendation, strings.TrimSpace(advice)
	r.ReviewedBy, r.ReviewedAt = by, now.UTC()
	return nil
}

// RecordResponse records what the prescriber did (SRS-IPC-008).
//
// Refused for the reviewer. The whole point of the requirement is that the
// stewardship team advises and somebody with prescribing authority decides;
// letting the reviewer close their own advice as accepted would turn the
// acceptance rate — the one number a stewardship programme is judged on —
// into a number the programme writes itself.
func (r *StewardshipReview) RecordResponse(response Response,
	reason, by string, now time.Time) error {

	switch {
	case r.State != ReviewAdvised:
		return fmt.Errorf("%w: this review has not been advised on yet",
			ErrInvalidInfection)
	case !knownResponse[response]:
		return fmt.Errorf("%w: unknown response %q",
			ErrInvalidInfection, response)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a response names who made it",
			ErrInvalidInfection)
	case by == r.ReviewedBy:
		return fmt.Errorf(
			"%w: the reviewer cannot record the prescriber's response",
			ErrInvalidInfection)
	}

	// Declining advice is a clinical decision and a legitimate one; it is not
	// a silent one. Modified advice needs to say what was done instead, or
	// nobody reading the record later can tell what the patient got.
	if (response == ResponseDeclined || response == ResponseModified) &&
		strings.TrimSpace(reason) == "" {
		return fmt.Errorf("%w: say why the advice was %s",
			ErrInvalidInfection, response)
	}

	r.State = ReviewClosed
	r.Response, r.ResponseReason = response, strings.TrimSpace(reason)
	r.RespondedBy, r.RespondedAt = by, now.UTC()
	return nil
}

// Withdraw takes a review off the worklist (SRS-IPC-008).
func (r *StewardshipReview) Withdraw(reason, by string, now time.Time) error {
	switch {
	case r.State == ReviewClosed || r.State == ReviewWithdrawn:
		return fmt.Errorf("%w: this review is already %s",
			ErrInvalidInfection, r.State)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say why the review was withdrawn",
			ErrInvalidInfection)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a withdrawal names who made it",
			ErrInvalidInfection)
	}
	r.State, r.WithdrawnReason = ReviewWithdrawn, strings.TrimSpace(reason)
	r.RespondedBy, r.RespondedAt = by, now.UTC()
	return nil
}

// Overdue reports a review nobody has answered in time.
func (r StewardshipReview) Overdue(at time.Time) bool {
	return r.State == ReviewOpen && !r.DueBy.IsZero() && at.After(r.DueBy)
}

// StewardshipSummary is the indicator set (SRS-IPC-008, SRS-IPC-010).
type StewardshipSummary struct {
	Raised    int
	Awaiting  int
	Advised   int
	Accepted  int
	Modified  int
	Declined  int
	Withdrawn int
	Overdue   int

	ByKind map[TriggerKind]int

	// AcceptancePermille is accepted responses in parts per thousand of the
	// advice that got a response. Permille, not a float, so the same numbers
	// add up the same way everywhere.
	AcceptancePermille int
	// Unanswerable marks advice nobody has responded to yet. A programme with
	// no responses has no acceptance rate — reporting it as zero would read
	// as universal refusal.
	Unanswerable bool
}

// SummariseStewardship counts a worklist (SRS-IPC-008, SRS-IPC-010).
//
// Modified counts as neither accepted nor refused: rolling it into acceptance
// is the easiest way to make a stewardship programme look more influential
// than it is.
func SummariseStewardship(reviews []StewardshipReview,
	at time.Time) StewardshipSummary {

	summary := StewardshipSummary{ByKind: map[TriggerKind]int{}}
	for _, review := range reviews {
		summary.Raised++
		summary.ByKind[review.Kind]++
		switch review.State {
		case ReviewOpen:
			summary.Awaiting++
			if review.Overdue(at) {
				summary.Overdue++
			}
		case ReviewAdvised:
			summary.Advised++
		case ReviewWithdrawn:
			summary.Withdrawn++
		case ReviewClosed:
			summary.Advised++
			switch review.Response {
			case ResponseAccepted:
				summary.Accepted++
			case ResponseModified:
				summary.Modified++
			case ResponseDeclined:
				summary.Declined++
			}
		}
	}

	responded := summary.Accepted + summary.Modified + summary.Declined
	if responded == 0 {
		summary.Unanswerable = true
		return summary
	}
	summary.AcceptancePermille = permille(int64(summary.Accepted), int64(responded))
	return summary
}

// TherapyRate is days of therapy against patient days (SRS-IPC-010).
//
// Tenths per 1000 patient days, in integers, for the same reason the infection
// rates are: two reports of the same period must not differ in the last digit
// because one of them rounded a float.
type TherapyRate struct {
	TherapyDays int
	PatientDays int
	// PerThousandTenths is days of therapy per 1000 patient days, in tenths.
	PerThousandTenths int
	Unanswerable      bool
}

// ComputeTherapyRate divides days of therapy by patient days (SRS-IPC-010).
func ComputeTherapyRate(therapyDays, patientDays int) (TherapyRate, error) {
	switch {
	case therapyDays < 0 || patientDays < 0:
		return TherapyRate{}, fmt.Errorf("%w: a day count cannot be negative",
			ErrInvalidInfection)
	case patientDays == 0:
		// No denominator, no rate. Not zero: a ward with no patients did not
		// achieve perfect antimicrobial restraint.
		return TherapyRate{TherapyDays: therapyDays, Unanswerable: true}, nil
	}
	return TherapyRate{
		TherapyDays: therapyDays, PatientDays: patientDays,
		PerThousandTenths: therapyDays * 10000 / patientDays,
	}, nil
}
