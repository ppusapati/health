// Package domain holds the quality management rules (SRS-QMS-001 … 015).
//
// Nothing here reaches a database, a clock or a transport (FIT-01). Every
// refusal is a value a caller can act on rather than a panic.
package domain

import (
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"
)

// ErrInvalidQuality reports a refused quality record.
var ErrInvalidQuality = errors.New("quality: invalid")

// Reach is how far an event got (SRS-QMS-001).
//
// The distinction the whole incident system turns on. A near miss is a free
// lesson — something went wrong and was caught — and a hospital that records
// them as harm events learns nothing from either. Recorded as three states
// rather than a "near miss" flag beside a harm level, because those two fields
// can contradict each other and this cannot.
type Reach string

const (
	// ReachNearMiss never got to the patient. Caught by a check, a person, or
	// luck.
	ReachNearMiss Reach = "near_miss"
	// ReachNoHarm got to the patient and did nothing to them.
	ReachNoHarm Reach = "no_harm"
	// ReachHarm got to the patient and hurt them.
	ReachHarm Reach = "harm"
	// ReachNotPatient did not involve a patient at all: a staff injury, a
	// property loss, an environmental event.
	ReachNotPatient Reach = "not_patient"
)

var knownReach = map[Reach]bool{
	ReachNearMiss: true, ReachNoHarm: true,
	ReachHarm: true, ReachNotPatient: true,
}

// ReachedThePatient reports whether anything was done to somebody.
func (r Reach) ReachedThePatient() bool {
	return r == ReachNoHarm || r == ReachHarm
}

// Harm is how badly somebody was hurt (SRS-QMS-001).
type Harm string

const (
	HarmNone     Harm = "none"
	HarmMild     Harm = "mild"
	HarmModerate Harm = "moderate"
	HarmSevere   Harm = "severe"
	HarmDeath    Harm = "death"
)

var knownHarm = map[Harm]bool{
	HarmNone: true, HarmMild: true, HarmModerate: true,
	HarmSevere: true, HarmDeath: true,
}

// Rank orders harm so a report can sort by it and a rule can compare.
func (h Harm) Rank() int {
	switch h {
	case HarmMild:
		return 1
	case HarmModerate:
		return 2
	case HarmSevere:
		return 3
	case HarmDeath:
		return 4
	default:
		return 0
	}
}

// Consequence is how bad the outcome was or could have been (SRS-QMS-002).
type Consequence string

const (
	ConsequenceNegligible   Consequence = "negligible"
	ConsequenceMinor        Consequence = "minor"
	ConsequenceModerate     Consequence = "moderate"
	ConsequenceMajor        Consequence = "major"
	ConsequenceCatastrophic Consequence = "catastrophic"
)

var consequenceScore = map[Consequence]int{
	ConsequenceNegligible: 1, ConsequenceMinor: 2, ConsequenceModerate: 3,
	ConsequenceMajor: 4, ConsequenceCatastrophic: 5,
}

// Likelihood is how often this is expected to happen again (SRS-QMS-002).
type Likelihood string

const (
	LikelihoodRare          Likelihood = "rare"
	LikelihoodUnlikely      Likelihood = "unlikely"
	LikelihoodPossible      Likelihood = "possible"
	LikelihoodLikely        Likelihood = "likely"
	LikelihoodAlmostCertain Likelihood = "almost_certain"
)

var likelihoodScore = map[Likelihood]int{
	LikelihoodRare: 1, LikelihoodUnlikely: 2, LikelihoodPossible: 3,
	LikelihoodLikely: 4, LikelihoodAlmostCertain: 5,
}

// RiskBand is where a score falls (SRS-QMS-002).
type RiskBand string

const (
	RiskLow      RiskBand = "low"
	RiskModerate RiskBand = "moderate"
	RiskHigh     RiskBand = "high"
	RiskExtreme  RiskBand = "extreme"
)

// Escalates reports the bands a hospital is expected to act on now.
func (b RiskBand) Escalates() bool {
	return b == RiskHigh || b == RiskExtreme
}

// Risk is a scored incident (SRS-QMS-002).
//
// Computed from consequence and likelihood, never typed in. A score a reporter
// can set is a score a reporter can set low, and the one incident that most
// needs escalating is the one somebody would rather not escalate.
type Risk struct {
	Consequence Consequence
	Likelihood  Likelihood
	// Score is consequence × likelihood, 1 … 25.
	Score int
	Band  RiskBand
}

// Score derives the risk band (SRS-QMS-002).
func Score(consequence Consequence, likelihood Likelihood) (Risk, error) {
	c, known := consequenceScore[consequence]
	if !known {
		return Risk{}, fmt.Errorf("%w: unknown consequence %q",
			ErrInvalidQuality, consequence)
	}
	l, known := likelihoodScore[likelihood]
	if !known {
		return Risk{}, fmt.Errorf("%w: unknown likelihood %q",
			ErrInvalidQuality, likelihood)
	}

	score := c * l
	band := RiskLow
	switch {
	case score >= 16:
		band = RiskExtreme
	case score >= 10:
		band = RiskHigh
	case score >= 4:
		band = RiskModerate
	}
	return Risk{
		Consequence: consequence, Likelihood: likelihood,
		Score: score, Band: band,
	}, nil
}

// IncidentState is where a report stands.
type IncidentState string

const (
	IncidentReported     IncidentState = "reported"
	IncidentUnderReview  IncidentState = "under_review"
	IncidentInvestigated IncidentState = "investigated"
	IncidentClosed       IncidentState = "closed"
	// IncidentRejected is a report the reviewer found was not an incident.
	// Kept rather than deleted: a report somebody dismissed is evidence about
	// the reviewer as much as about the event.
	IncidentRejected IncidentState = "rejected"
)

var knownIncidentState = map[IncidentState]bool{
	IncidentReported: true, IncidentUnderReview: true,
	IncidentInvestigated: true, IncidentClosed: true, IncidentRejected: true,
}

// Open reports an incident still being worked.
func (s IncidentState) Open() bool {
	return s != IncidentClosed && s != IncidentRejected
}

// Incident is one reported event or near miss (SRS-QMS-001).
type Incident struct {
	ID       string
	TenantID string

	// Reference is the number people quote in a meeting. Unique per tenant.
	Reference string
	Category  string
	// Subcategory narrows it — "medication: wrong dose" rather than
	// "medication".
	Subcategory string

	Reach Reach
	Harm  Harm
	Risk  Risk

	// What it happened to. All optional and all independent: an incident can
	// involve a patient, a machine, both or neither.
	PatientID   string
	EncounterID string
	AssetID     string
	LocationID  string
	FacilityID  string
	Department  string

	// Narrative is what happened, in the reporter's words. Restricted along
	// with the rest of the record where the incident is.
	Narrative string
	// ImmediateAction is what was done about it there and then. Required once
	// anything reached a patient: an event that reached somebody and produced
	// no action at the time is either an incomplete report or a failure to
	// respond, and both need to be visible.
	ImmediateAction string

	// Sentinel marks the events a hospital's executive is told about
	// individually (SRS-QMS-005). Always restricted, and always true for a
	// death: a death recorded as a routine incident is how a sentinel event
	// goes unreviewed.
	Sentinel bool
	// Restricted limits the record to the people authorised for it
	// (SRS-QMS-001, SRS-QMS-012). Separate from the incident's existence: a
	// ward may need to know an incident happened in it without reading the
	// peer-review analysis of it.
	Restricted bool

	State IncidentState
	// Anonymous hides the reporter from everybody but the audit trail. A
	// reporting system in which staff are identified is a reporting system
	// staff stop using, and the trail still knows.
	Anonymous bool

	OccurredAt time.Time
	ReportedAt time.Time
	ReportedBy string

	ReviewedBy string
	ReviewedAt time.Time
	ClosedBy   string
	ClosedAt   time.Time
	// ClosureReason is required at closure and at rejection, because both are
	// decisions somebody has to be able to question later.
	ClosureReason string

	Version int64
}

// NewIncidentInput reports an event or a near miss.
type NewIncidentInput struct {
	Reference       string
	Category        string
	Subcategory     string
	Reach           Reach
	Harm            Harm
	Consequence     Consequence
	Likelihood      Likelihood
	PatientID       string
	EncounterID     string
	AssetID         string
	LocationID      string
	FacilityID      string
	Department      string
	Narrative       string
	ImmediateAction string
	Sentinel        bool
	Anonymous       bool
	OccurredAt      time.Time
}

// ReportIncident records an event or a near miss (SRS-QMS-001, SRS-QMS-002).
func ReportIncident(id, tenantID string, in NewIncidentInput, by string,
	now time.Time) (Incident, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Incident{}, fmt.Errorf("%w: an incident needs an id",
			ErrInvalidQuality)
	case strings.TrimSpace(in.Category) == "":
		// Uncategorised incidents cannot be counted, and an incident system
		// that cannot count is a filing cabinet.
		return Incident{}, fmt.Errorf("%w: an incident needs a category",
			ErrInvalidQuality)
	case !knownReach[in.Reach]:
		return Incident{}, fmt.Errorf("%w: unknown reach %q",
			ErrInvalidQuality, in.Reach)
	case !knownHarm[in.Harm]:
		return Incident{}, fmt.Errorf("%w: unknown harm level %q",
			ErrInvalidQuality, in.Harm)
	case strings.TrimSpace(in.Narrative) == "":
		return Incident{}, fmt.Errorf("%w: an incident needs a description",
			ErrInvalidQuality)
	case in.OccurredAt.IsZero():
		return Incident{}, fmt.Errorf("%w: an incident needs a time",
			ErrInvalidQuality)
	case in.OccurredAt.After(now):
		return Incident{}, fmt.Errorf("%w: this incident is in the future",
			ErrInvalidQuality)
	}

	// The two contradictions the three-state reach exists to catch.
	if !in.Reach.ReachedThePatient() && in.Harm != HarmNone {
		return Incident{}, fmt.Errorf(
			"%w: %s harm is recorded against an event that never reached a patient",
			ErrInvalidQuality, in.Harm)
	}
	if in.Reach == ReachHarm && in.Harm == HarmNone {
		return Incident{}, fmt.Errorf(
			"%w: an event recorded as harm records no harm level",
			ErrInvalidQuality)
	}
	if in.Reach.ReachedThePatient() &&
		strings.TrimSpace(in.ImmediateAction) == "" {
		// Something happened to somebody and nothing was done at the time.
		// Either the report is incomplete or the response failed, and a blank
		// field hides which.
		return Incident{}, fmt.Errorf(
			"%w: say what was done for the patient at the time",
			ErrInvalidQuality)
	}

	risk, err := Score(in.Consequence, in.Likelihood)
	if err != nil {
		return Incident{}, err
	}

	incident := Incident{
		ID: id, TenantID: tenantID,
		Reference:   strings.TrimSpace(in.Reference),
		Category:    strings.TrimSpace(in.Category),
		Subcategory: strings.TrimSpace(in.Subcategory),
		Reach:       in.Reach, Harm: in.Harm, Risk: risk,
		PatientID: in.PatientID, EncounterID: in.EncounterID,
		AssetID: in.AssetID, LocationID: in.LocationID,
		FacilityID: in.FacilityID, Department: strings.TrimSpace(in.Department),
		Narrative:       strings.TrimSpace(in.Narrative),
		ImmediateAction: strings.TrimSpace(in.ImmediateAction),
		Sentinel:        in.Sentinel,
		State:           IncidentReported,
		Anonymous:       in.Anonymous,
		OccurredAt:      in.OccurredAt.UTC(),
		ReportedAt:      now.UTC(), ReportedBy: by,
		Version: 1,
	}

	// A death is a sentinel event whatever the reporter ticked. Left to the
	// reporter, the one incident that most needs an executive review is the
	// one nobody wants to escalate.
	if in.Harm == HarmDeath {
		incident.Sentinel = true
	}
	// A sentinel event is restricted, always. Its review is peer-review
	// material (SRS-QMS-012) and the people in it are identifiable.
	if incident.Sentinel {
		incident.Restricted = true
	}
	return incident, nil
}

// Rescore re-runs the risk assessment (SRS-QMS-002).
//
// Allowed while the incident is open, because a reviewer who knows more than
// the reporter did is the point of the review. Refused once closed: a score
// changed after the fact is a report that no longer matches what was decided
// from it.
func (i *Incident) Rescore(consequence Consequence, likelihood Likelihood,
	by string, now time.Time) error {

	if !i.State.Open() {
		return fmt.Errorf("%w: this incident is %s", ErrInvalidQuality, i.State)
	}
	risk, err := Score(consequence, likelihood)
	if err != nil {
		return err
	}
	i.Risk = risk
	i.ReviewedBy, i.ReviewedAt = by, now.UTC()
	if i.State == IncidentReported {
		i.State = IncidentUnderReview
	}
	return nil
}

// Restrict limits the record to authorised readers (SRS-QMS-001).
func (i *Incident) Restrict(reason string) error {
	if strings.TrimSpace(reason) == "" {
		return fmt.Errorf("%w: say why this record is restricted",
			ErrInvalidQuality)
	}
	i.Restricted = true
	return nil
}

// Unrestrict returns a record to ordinary access.
//
// Refused for a sentinel event, whose review is peer-review material by
// definition. A restriction that can be lifted by whoever finds it
// inconvenient is not a restriction.
func (i *Incident) Unrestrict() error {
	if i.Sentinel {
		return fmt.Errorf(
			"%w: a sentinel event's review stays restricted", ErrInvalidQuality)
	}
	i.Restricted = false
	return nil
}

// Advance moves an incident through review.
func (i *Incident) Advance(to IncidentState, reason, by string,
	now time.Time) error {

	switch {
	case !knownIncidentState[to]:
		return fmt.Errorf("%w: unknown incident state %q", ErrInvalidQuality, to)
	case !i.State.Open():
		return fmt.Errorf("%w: this incident is already %s",
			ErrInvalidQuality, i.State)
	case to == IncidentReported:
		return fmt.Errorf("%w: an incident cannot be un-reported",
			ErrInvalidQuality)
	case (to == IncidentClosed || to == IncidentRejected) &&
		strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say why this incident is %s",
			ErrInvalidQuality, to)
	}

	i.State = to
	switch to {
	case IncidentUnderReview, IncidentInvestigated:
		i.ReviewedBy, i.ReviewedAt = by, now.UTC()
	case IncidentClosed, IncidentRejected:
		i.ClosedBy, i.ClosedAt = by, now.UTC()
		i.ClosureReason = strings.TrimSpace(reason)
	}
	return nil
}

// Redacted is what a reader who may know an incident happened, but not what it
// said, is given (SRS-QMS-001, SRS-QMS-012).
//
// A separate value rather than a flag the caller is trusted to honour: a
// rendering that has to remember to blank three fields is a rendering that
// will forget one. The ward keeps what it needs — that something happened
// here, of this kind, at this time — and loses the narrative, the patient and
// the people.
func (i Incident) Redacted() Incident {
	if !i.Restricted {
		return i
	}
	return Incident{
		ID: i.ID, TenantID: i.TenantID, Reference: i.Reference,
		Category: i.Category, Reach: i.Reach,
		// The band, not the score: "high" tells a manager to expect an
		// investigation, and the components would let them reconstruct the
		// consequence, which for a restricted case is most of the story.
		Risk:       Risk{Band: i.Risk.Band},
		FacilityID: i.FacilityID, Department: i.Department,
		LocationID: i.LocationID,
		Sentinel:   i.Sentinel, Restricted: true,
		State: i.State, Anonymous: i.Anonymous,
		OccurredAt: i.OccurredAt, ReportedAt: i.ReportedAt,
		Version: i.Version,
	}
}

// Reporter is who reported it, as a reader may see it.
//
// Anonymous reporting is a deliberate hole in the record for everybody except
// the audit trail, which always knows: a hospital cannot investigate a
// malicious report it cannot attribute, and staff stop reporting at all if
// every report carries their name to their manager.
func (i Incident) Reporter() string {
	if i.Anonymous {
		return ""
	}
	return i.ReportedBy
}

// Trend is one line of the incident pattern (SRS-QMS-002).
type Trend struct {
	Category string
	Count    int
	// NearMisses is counted separately rather than folded in. A category whose
	// count is rising because people have started reporting near misses is a
	// category that is getting safer, and a single total says the opposite.
	NearMisses int
	Harmful    int
	// WorstHarm is the worst single outcome in the group, so a category with
	// one death and forty scratches does not read as forty-one scratches.
	WorstHarm Harm
	Extreme   int
}

// Trends summarises incidents by category (SRS-QMS-002).
func Trends(incidents []Incident) []Trend {
	index := map[string]*Trend{}
	for _, incident := range incidents {
		trend, seen := index[incident.Category]
		if !seen {
			trend = &Trend{Category: incident.Category, WorstHarm: HarmNone}
			index[incident.Category] = trend
		}
		trend.Count++
		if incident.Reach == ReachNearMiss {
			trend.NearMisses++
		}
		if incident.Harm.Rank() > 0 {
			trend.Harmful++
		}
		if incident.Harm.Rank() > trend.WorstHarm.Rank() {
			trend.WorstHarm = incident.Harm
		}
		if incident.Risk.Band == RiskExtreme {
			trend.Extreme++
		}
	}

	out := make([]Trend, 0, len(index))
	for _, trend := range index {
		out = append(out, *trend)
	}
	sort.Slice(out, func(a, b int) bool {
		if out[a].WorstHarm.Rank() != out[b].WorstHarm.Rank() {
			return out[a].WorstHarm.Rank() > out[b].WorstHarm.Rank()
		}
		if out[a].Harmful != out[b].Harmful {
			return out[a].Harmful > out[b].Harmful
		}
		return out[a].Category < out[b].Category
	})
	return out
}
