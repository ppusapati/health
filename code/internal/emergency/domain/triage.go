package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Triage and the queue (SRS-ER-002, SRS-ER-003).

// AcuityScale is the approved scale a department triages on.
//
// A scale rather than an enumeration, because SRS-ER-002 says "configurable
// triage acuity using approved scale" and hospitals do not agree: ESI and CTAS
// both run 1 to 5, Manchester runs five colours, and a paediatric department
// may run a different one from the adult side of the same building.
//
// The dangerous thing a fixed enum would do is make levels comparable across
// scales. An ESI 2 and an MTS "orange" are not the same patient, and a queue
// that sorted them together would be sorting on a number that means different
// things in different rows.
type AcuityScale struct {
	// Name identifies the scale — "ESI", "CTAS", "MTS".
	Name string
	// Version, because scales are revised and a five-year-old triage was made
	// under the rules of its day.
	Version string
	// Levels are ordered most urgent first. Level 1 in the list is the
	// resuscitation category whatever the scale calls it.
	Levels []AcuityLevel
}

// AcuityLevel is one step of a scale.
type AcuityLevel struct {
	// Code is what the scale calls it — "1", "orange".
	Code string
	// Label is what the screen shows — "Immediate", "Very urgent".
	Label string
	// Rank orders the scale. Lower is more urgent, and rank 1 is the top.
	Rank int
	// TargetWait is how long this level may wait before being seen. Zero for
	// the resuscitation category, which is not a waiting category.
	TargetWait time.Duration
}

// Validate rejects a scale that could not be triaged on.
func (s AcuityScale) Validate() error {
	if strings.TrimSpace(s.Name) == "" {
		return fmt.Errorf("%w: an acuity scale needs a name; a triage that cannot say "+
			"which scale it used is one nobody can read back", ErrInvalidVisit)
	}
	if len(s.Levels) < 2 {
		return fmt.Errorf("%w: an acuity scale needs at least two levels", ErrInvalidVisit)
	}

	seenRank := map[int]bool{}
	seenCode := map[string]bool{}
	hasTop := false
	for _, level := range s.Levels {
		if strings.TrimSpace(level.Code) == "" {
			return fmt.Errorf("%w: every acuity level needs a code", ErrInvalidVisit)
		}
		if level.Rank < 1 {
			return fmt.Errorf("%w: acuity ranks start at 1, most urgent first",
				ErrInvalidVisit)
		}
		if seenRank[level.Rank] {
			// Two levels at one rank make the queue order depend on storage
			// order, which is to say on nothing.
			return fmt.Errorf("%w: two acuity levels at rank %d", ErrInvalidVisit, level.Rank)
		}
		if seenCode[level.Code] {
			return fmt.Errorf("%w: two acuity levels with code %q", ErrInvalidVisit, level.Code)
		}
		seenRank[level.Rank], seenCode[level.Code] = true, true
		if level.Rank == 1 {
			hasTop = true
		}
	}
	if !hasTop {
		return fmt.Errorf("%w: an acuity scale needs a rank 1 — the category that "+
			"does not wait", ErrInvalidVisit)
	}
	return nil
}

// Level finds a level by its code.
func (s AcuityScale) Level(code string) (AcuityLevel, bool) {
	for _, level := range s.Levels {
		if level.Code == code {
			return level, true
		}
	}
	return AcuityLevel{}, false
}

// ESI is the Emergency Severity Index, the scale a deployment gets if it
// configures none.
//
// A default rather than a refusal, unlike the escalation matrix: a department
// with no configured scale still has patients arriving, and triaging them on a
// widely used five-level scale is better than not triaging them. The scale is
// named on every assessment, so a later migration to CTAS can tell which
// records were made under which.
func ESI() AcuityScale {
	return AcuityScale{
		Name: "ESI", Version: "4",
		Levels: []AcuityLevel{
			{Code: "1", Label: "Resuscitation", Rank: 1},
			{Code: "2", Label: "Emergent", Rank: 2, TargetWait: 10 * time.Minute},
			{Code: "3", Label: "Urgent", Rank: 3, TargetWait: 30 * time.Minute},
			{Code: "4", Label: "Less urgent", Rank: 4, TargetWait: 60 * time.Minute},
			{Code: "5", Label: "Non-urgent", Rank: 5, TargetWait: 120 * time.Minute},
		},
	}
}

// RedFlag is a finding that overrides the rest of the assessment.
type RedFlag string

// Triage is one triage assessment (SRS-ER-002).
type Triage struct {
	ID       string
	TenantID string
	VisitID  string

	// ScaleName and ScaleVersion travel with the assessment, so a level is
	// never read under a scale it was not assigned under.
	ScaleName    string
	ScaleVersion string
	AcuityCode   string
	AcuityRank   int

	// The inputs the requirement names. Kept as recorded rather than as a
	// score: "acuity, inputs, author and time are retained" is the criterion,
	// and a number with its inputs discarded cannot be reviewed.
	RespiratoryRate  *int
	HeartRate        *int
	SystolicBP       *int
	OxygenSaturation *int
	Temperature      *float64
	// PainScore is 0-10 where recorded.
	PainScore *int
	// Consciousness on AVPU or GCS, as the department records it.
	Consciousness string
	RedFlags      []RedFlag

	// Missing names the mandatory fields this assessment did not have
	// (SRS-ER-002: "missing mandatory triage fields are flagged"). Recorded
	// rather than refused: a triage nurse with a crashing patient does not
	// stop to fill in a temperature, and a system that refused the assessment
	// would get a fabricated temperature instead of an honest gap.
	Missing []string

	Note       string
	AssessedBy string
	AssessedAt time.Time
}

// MandatoryTriageFields is what a department expects at triage.
//
// Configurable per deployment for the same reason the disposition gate is:
// what must be measured before a patient is streamed is a clinical governance
// decision.
type MandatoryTriageFields struct {
	RespiratoryRate  bool
	HeartRate        bool
	SystolicBP       bool
	OxygenSaturation bool
	Temperature      bool
	PainScore        bool
	Consciousness    bool
}

// DefaultMandatoryTriageFields is the observation set most scales assume.
func DefaultMandatoryTriageFields() MandatoryTriageFields {
	return MandatoryTriageFields{
		RespiratoryRate: true, HeartRate: true, SystolicBP: true,
		OxygenSaturation: true, Consciousness: true,
	}
}

// NewTriageInput is one assessment as the nurse recorded it.
type NewTriageInput struct {
	VisitID          string
	Scale            AcuityScale
	AcuityCode       string
	RespiratoryRate  *int
	HeartRate        *int
	SystolicBP       *int
	OxygenSaturation *int
	Temperature      *float64
	PainScore        *int
	Consciousness    string
	RedFlags         []RedFlag
	Note             string
	Mandatory        MandatoryTriageFields
}

// NewTriage records an assessment (SRS-ER-002).
//
// Refuses only two things: an assessment with no visit, and an acuity the
// scale does not define. Everything else missing is flagged rather than
// refused — see Triage.Missing.
func NewTriage(id, tenantID string, in NewTriageInput, assessedBy string,
	now time.Time) (Triage, error) {

	if strings.TrimSpace(id) == "" || strings.TrimSpace(in.VisitID) == "" {
		return Triage{}, fmt.Errorf("%w: a triage belongs to a visit", ErrInvalidVisit)
	}
	if strings.TrimSpace(assessedBy) == "" {
		// "Author and time are retained" is half the requirement, and an
		// anonymous triage is one nobody can ask about.
		return Triage{}, fmt.Errorf("%w: a triage names who made it", ErrInvalidVisit)
	}

	scale := in.Scale
	if len(scale.Levels) == 0 {
		scale = ESI()
	}
	if err := scale.Validate(); err != nil {
		return Triage{}, err
	}
	level, ok := scale.Level(in.AcuityCode)
	if !ok {
		return Triage{}, fmt.Errorf("%w: %q is not a level of the %s scale",
			ErrInvalidVisit, in.AcuityCode, scale.Name)
	}

	t := Triage{
		ID: id, TenantID: tenantID, VisitID: strings.TrimSpace(in.VisitID),
		ScaleName: scale.Name, ScaleVersion: scale.Version,
		AcuityCode: level.Code, AcuityRank: level.Rank,
		RespiratoryRate: in.RespiratoryRate, HeartRate: in.HeartRate,
		SystolicBP: in.SystolicBP, OxygenSaturation: in.OxygenSaturation,
		Temperature: in.Temperature, PainScore: in.PainScore,
		Consciousness: strings.TrimSpace(in.Consciousness),
		RedFlags:      in.RedFlags,
		Note:          strings.TrimSpace(in.Note),
		AssessedBy:    assessedBy, AssessedAt: now.UTC(),
	}
	t.Missing = missingFields(in, in.Mandatory)
	return t, nil
}

func missingFields(in NewTriageInput, mandatory MandatoryTriageFields) []string {
	var missing []string
	if mandatory.RespiratoryRate && in.RespiratoryRate == nil {
		missing = append(missing, "respiratory_rate")
	}
	if mandatory.HeartRate && in.HeartRate == nil {
		missing = append(missing, "heart_rate")
	}
	if mandatory.SystolicBP && in.SystolicBP == nil {
		missing = append(missing, "systolic_bp")
	}
	if mandatory.OxygenSaturation && in.OxygenSaturation == nil {
		missing = append(missing, "oxygen_saturation")
	}
	if mandatory.Temperature && in.Temperature == nil {
		missing = append(missing, "temperature")
	}
	if mandatory.PainScore && in.PainScore == nil {
		missing = append(missing, "pain_score")
	}
	if mandatory.Consciousness && strings.TrimSpace(in.Consciousness) == "" {
		missing = append(missing, "consciousness")
	}
	return missing
}

// Complete reports a triage with every mandatory field recorded.
func (t Triage) Complete() bool { return len(t.Missing) == 0 }

// QueueEntry is one patient on the board, as the queue orders them.
type QueueEntry struct {
	VisitID string
	// Display is what the board shows: the patient's name, or the temporary
	// one for somebody nobody has identified yet.
	Display string
	// AcuityRank from the triage, or zero for a patient nobody has assessed.
	AcuityRank int
	ScaleName  string
	ArrivedAt  time.Time
	Triaged    bool
	Status     VisitStatus
	Location   string
	// Override is a clinician's decision to move this patient, with the reason
	// (SRS-ER-003).
	Override *PriorityOverride
	// PendingOrders is what the board shows as outstanding (SRS-ER-012).
	PendingOrders int
	// DispositionBarrier is the one thing stopping this patient leaving —
	// "awaiting bed", "awaiting scan". The board's most useful column, because
	// the department's flow problem is almost never the doctors.
	DispositionBarrier string
}

// PriorityOverride is a clinician moving a patient up or down the queue.
//
// Both directions carry a reason. Moving somebody down is the one that gets
// argued about afterwards, and a system that only demanded a reason for
// upgrades would leave the harder decision unexplained.
type PriorityOverride struct {
	// Rank is the acuity rank to treat this patient as.
	Rank   int
	Reason string
	By     string
	At     time.Time
}

// Validate rejects an override that could not be defended.
func (o PriorityOverride) Validate() error {
	switch {
	case o.Rank < 1:
		return fmt.Errorf("%w: an override names the acuity to treat the patient as",
			ErrInvalidVisit)
	case strings.TrimSpace(o.Reason) == "":
		return fmt.Errorf(
			"%w: an override needs a reason, whichever direction it moves the patient",
			ErrInvalidVisit)
	case strings.TrimSpace(o.By) == "":
		return fmt.Errorf("%w: an override names who made it", ErrInvalidVisit)
	}
	return nil
}

// EffectiveRank is the acuity the queue sorts this entry on.
//
// An untriaged patient sorts as if they were at the most urgent level. That
// looks aggressive and is the only safe reading: the department does not know
// what is wrong with them, and the alternative — sorting them last, or by
// arrival among the triaged — is how somebody waits four hours in a waiting
// room with a myocardial infarction nobody assessed. The clock that fixes this
// is door-to-triage, not the queue.
func (e QueueEntry) EffectiveRank() int {
	if e.Override != nil {
		return e.Override.Rank
	}
	if !e.Triaged || e.AcuityRank < 1 {
		return 1
	}
	return e.AcuityRank
}

// OrderQueue sorts the board (SRS-ER-003).
//
// Acuity first, then arrival. "Prioritize queue by acuity and clinical
// override rather than arrival order alone" is the requirement, and arrival
// order still decides among equals — otherwise the quiet patients at the back
// of a busy level-3 queue never reach the front.
func OrderQueue(entries []QueueEntry) []QueueEntry {
	out := append([]QueueEntry(nil), entries...)
	sort.SliceStable(out, func(i, j int) bool {
		ri, rj := out[i].EffectiveRank(), out[j].EffectiveRank()
		if ri != rj {
			return ri < rj
		}
		return out[i].ArrivedAt.Before(out[j].ArrivedAt)
	})
	return out
}

// Breaching reports a patient who has waited past their acuity's target.
//
// Zero target means the resuscitation category, which is never "waiting": a
// patient at rank 1 is either being treated or the department has a problem
// that a breach flag does not describe.
func (e QueueEntry) Breaching(scale AcuityScale, now time.Time) bool {
	if e.Status != StatusArrived && e.Status != StatusTriaged {
		return false
	}
	level, ok := scale.Level(e.leveLCode(scale))
	if !ok || level.TargetWait <= 0 {
		return false
	}
	return now.Sub(e.ArrivedAt) > level.TargetWait
}

// leveLCode finds the scale code for this entry's effective rank.
func (e QueueEntry) leveLCode(scale AcuityScale) string {
	rank := e.EffectiveRank()
	for _, level := range scale.Levels {
		if level.Rank == rank {
			return level.Code
		}
	}
	return ""
}
