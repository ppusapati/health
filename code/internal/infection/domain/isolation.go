package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Precaution is what staff must do around a patient (SRS-IPC-003).
//
// Named as the action rather than as the reason, deliberately. What a nurse
// walking into a bay needs is "gown and gloves", not "Clostridioides
// difficile" — and the difference is the whole of SRS-IPC-003's acceptance
// that a board shows the precaution rather than the diagnosis.
type Precaution string

const (
	PrecautionStandard Precaution = "standard"
	PrecautionContact  Precaution = "contact"
	PrecautionDroplet  Precaution = "droplet"
	PrecautionAirborne Precaution = "airborne"
	// PrecautionProtective protects the patient from everybody else rather
	// than the other way round. The one whose signage means the opposite of
	// the others, which is why it is a state and not a flag.
	PrecautionProtective Precaution = "protective"
)

var knownPrecaution = map[Precaution]bool{
	PrecautionStandard: true, PrecautionContact: true,
	PrecautionDroplet: true, PrecautionAirborne: true,
	PrecautionProtective: true,
}

// RequiresSideRoom reports the precautions a shared bay cannot deliver.
func (p Precaution) RequiresSideRoom() bool {
	return p == PrecautionAirborne || p == PrecautionProtective
}

// PPE is what each precaution asks for.
//
// Derived from the precaution rather than typed per patient, so two wards
// cannot disagree about what "contact precautions" means.
func (p Precaution) PPE() []string {
	switch p {
	case PrecautionContact:
		return []string{"gloves", "gown"}
	case PrecautionDroplet:
		return []string{"gloves", "gown", "surgical_mask", "eye_protection"}
	case PrecautionAirborne:
		return []string{"gloves", "gown", "respirator", "eye_protection"}
	case PrecautionProtective:
		return []string{"gloves", "gown", "surgical_mask"}
	default:
		return []string{"hand_hygiene"}
	}
}

// Isolation is one patient under precautions (SRS-IPC-003).
type Isolation struct {
	ID       string
	TenantID string

	PatientID   string
	EncounterID string
	FacilityID  string
	LocationID  string
	BedID       string

	Precaution Precaution
	// Reason is the clinical justification — the organism, the syndrome. Held
	// here and deliberately not rendered onto a board.
	Reason string
	// CaseID links the isolation to the surveillance case where there is one.
	CaseID string

	StartedAt time.Time
	StartedBy string
	// ReviewDue is when somebody must decide whether it still applies.
	// Isolation that nobody reviews is isolation that outlives its reason, and
	// a patient left in a side room for a fortnight after they stopped being
	// infectious is a harm of its own.
	ReviewDue time.Time

	EndedAt time.Time
	EndedBy string
	// EndReason is required: lifting precautions is a clinical decision and an
	// unexplained one cannot be questioned.
	EndReason string

	Version int64
}

// Active reports precautions still in force at a moment.
func (i Isolation) Active(at time.Time) bool {
	if i.StartedAt.After(at) {
		return false
	}
	return i.EndedAt.IsZero() || i.EndedAt.After(at)
}

// NewIsolationInput places a patient under precautions.
type NewIsolationInput struct {
	PatientID   string
	EncounterID string
	FacilityID  string
	LocationID  string
	BedID       string
	Precaution  Precaution
	Reason      string
	CaseID      string
	StartedAt   time.Time
}

// StartIsolation places a patient under precautions (SRS-IPC-003).
//
// reviewAfter is how long precautions run before somebody must reconsider
// them. Zero leaves no review date, which is a deployment that has not decided
// and is reported as a gap rather than treated as "review never needed".
func StartIsolation(id, tenantID string, in NewIsolationInput,
	reviewAfter time.Duration, by string, now time.Time) (Isolation, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Isolation{}, fmt.Errorf("%w: an isolation needs an id",
			ErrInvalidInfection)
	case strings.TrimSpace(in.PatientID) == "":
		return Isolation{}, fmt.Errorf("%w: an isolation names its patient",
			ErrInvalidInfection)
	case !knownPrecaution[in.Precaution]:
		return Isolation{}, fmt.Errorf("%w: unknown precaution %q",
			ErrInvalidInfection, in.Precaution)
	case strings.TrimSpace(in.Reason) == "":
		// Precautions with no recorded reason are precautions nobody can
		// review, and they run until the patient leaves.
		return Isolation{}, fmt.Errorf("%w: say why this patient is isolated",
			ErrInvalidInfection)
	}

	started := in.StartedAt
	if started.IsZero() {
		started = now
	}

	isolation := Isolation{
		ID: id, TenantID: tenantID,
		PatientID: in.PatientID, EncounterID: in.EncounterID,
		FacilityID: in.FacilityID, LocationID: in.LocationID,
		BedID: in.BedID, Precaution: in.Precaution,
		Reason: strings.TrimSpace(in.Reason), CaseID: in.CaseID,
		StartedAt: started.UTC(), StartedBy: by, Version: 1,
	}
	if reviewAfter > 0 {
		isolation.ReviewDue = started.Add(reviewAfter).UTC()
	}
	return isolation, nil
}

// EndIsolation lifts precautions (SRS-IPC-003).
func (i *Isolation) EndIsolation(reason, by string, now time.Time) error {
	switch {
	case !i.EndedAt.IsZero():
		return fmt.Errorf("%w: these precautions are already lifted",
			ErrInvalidInfection)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say why these precautions are lifted",
			ErrInvalidInfection)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a lift names who made it", ErrInvalidInfection)
	}
	i.EndedAt, i.EndedBy = now.UTC(), by
	i.EndReason = strings.TrimSpace(reason)
	return nil
}

// Extend pushes the review date out after somebody has reconsidered
// (SRS-IPC-003).
func (i *Isolation) Extend(reviewAfter time.Duration, now time.Time) error {
	switch {
	case !i.EndedAt.IsZero():
		return fmt.Errorf("%w: these precautions are lifted",
			ErrInvalidInfection)
	case reviewAfter <= 0:
		return fmt.Errorf("%w: an extension needs a period",
			ErrInvalidInfection)
	}
	i.ReviewDue = now.Add(reviewAfter).UTC()
	return nil
}

// BoardEntry is what a bed board may show (SRS-IPC-003, SRS-OPSSEC-006).
//
// A separate value rather than a rendering rule callers are trusted to follow.
// A board is a screen on a wall that visitors and contractors walk past, and
// the reason a patient is isolated is a diagnosis. What the board gets is the
// precaution, the PPE and whether a side room is needed — everything a member
// of staff needs to act correctly, and nothing that identifies a condition.
type BoardEntry struct {
	BedID      string
	LocationID string
	// PatientID is carried because a board is read by staff who are caring
	// for the patient. What is never carried is why.
	PatientID string

	Precaution       Precaution
	PPE              []string
	RequiresSideRoom bool
	Since            time.Time
	// ReviewOverdue marks precautions nobody has reconsidered in time.
	ReviewOverdue bool
}

// Board renders the bed board for a location (SRS-IPC-003).
func Board(isolations []Isolation, locationID string,
	at time.Time) []BoardEntry {

	var out []BoardEntry
	for _, isolation := range isolations {
		if locationID != "" && isolation.LocationID != locationID {
			continue
		}
		if !isolation.Active(at) {
			continue
		}
		out = append(out, BoardEntry{
			BedID: isolation.BedID, LocationID: isolation.LocationID,
			PatientID:        isolation.PatientID,
			Precaution:       isolation.Precaution,
			PPE:              isolation.Precaution.PPE(),
			RequiresSideRoom: isolation.Precaution.RequiresSideRoom(),
			Since:            isolation.StartedAt,
			ReviewOverdue: !isolation.ReviewDue.IsZero() &&
				at.After(isolation.ReviewDue),
		})
	}

	sort.Slice(out, func(a, b int) bool {
		// The precautions a shared bay cannot deliver first, then by bed, so
		// a nurse scanning the board sees the room moves at the top.
		if out[a].RequiresSideRoom != out[b].RequiresSideRoom {
			return out[a].RequiresSideRoom
		}
		return out[a].BedID < out[b].BedID
	})
	return out
}

// AlertRule is a configured multidrug-resistant organism rule (SRS-IPC-004).
//
// Versioned, because the requirement's acceptance is that an alert uses the
// current approved rule — and an alert that fired last year under different
// criteria has to stay explicable. A rule edited in place would make every
// past alert unexplainable.
type AlertRule struct {
	ID       string
	TenantID string

	Code string
	Name string
	// Revision increments with every change. (code, revision) is the identity.
	Revision int

	// Organisms are the organism codes that trigger it.
	Organisms []string
	// LookbackDays is how far back a previous positive still counts. A patient
	// colonised eighteen months ago is a different risk from one colonised
	// last week, and a rule with no horizon alerts on everybody for ever until
	// staff stop reading the alerts.
	LookbackDays int
	// Precaution is what the rule asks for when it fires.
	Precaution Precaution
	Advice     string

	Approved   bool
	ApprovedBy string
	ApprovedAt time.Time

	EffectiveFrom time.Time
	SupersededAt  time.Time
	CreatedAt     time.Time
	CreatedBy     string
}

// Live reports a rule in force at a moment.
func (r AlertRule) Live(at time.Time) bool {
	if !r.Approved {
		return false
	}
	if r.EffectiveFrom.IsZero() || r.EffectiveFrom.After(at) {
		return false
	}
	return r.SupersededAt.IsZero() || r.SupersededAt.After(at)
}

// Covers reports whether a rule names an organism code.
func (r AlertRule) Covers(organismCode string) bool {
	for _, code := range r.Organisms {
		if strings.EqualFold(code, organismCode) {
			return true
		}
	}
	return false
}

// NewRuleInput configures an alert rule.
type NewRuleInput struct {
	Code          string
	Name          string
	Revision      int
	Organisms     []string
	LookbackDays  int
	Precaution    Precaution
	Advice        string
	EffectiveFrom time.Time
}

// NewAlertRule configures an alert rule (SRS-IPC-004).
func NewAlertRule(id, tenantID string, in NewRuleInput, by string,
	now time.Time) (AlertRule, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return AlertRule{}, fmt.Errorf("%w: a rule needs an id",
			ErrInvalidInfection)
	case strings.TrimSpace(in.Code) == "":
		return AlertRule{}, fmt.Errorf("%w: a rule needs a code",
			ErrInvalidInfection)
	case in.Revision <= 0:
		return AlertRule{}, fmt.Errorf("%w: a rule revision starts at 1",
			ErrInvalidInfection)
	case len(in.Organisms) == 0:
		return AlertRule{}, fmt.Errorf("%w: a rule names the organisms it covers",
			ErrInvalidInfection)
	case !knownPrecaution[in.Precaution]:
		return AlertRule{}, fmt.Errorf("%w: unknown precaution %q",
			ErrInvalidInfection, in.Precaution)
	case in.LookbackDays <= 0:
		// A rule with no horizon alerts on everybody for ever, and staff stop
		// reading the alerts.
		return AlertRule{}, fmt.Errorf(
			"%w: a rule needs a lookback period", ErrInvalidInfection)
	}

	return AlertRule{
		ID: id, TenantID: tenantID,
		Code: strings.TrimSpace(in.Code), Name: strings.TrimSpace(in.Name),
		Revision: in.Revision, Organisms: normalise(in.Organisms),
		LookbackDays: in.LookbackDays, Precaution: in.Precaution,
		Advice:        strings.TrimSpace(in.Advice),
		EffectiveFrom: utcOrZero(in.EffectiveFrom),
		CreatedAt:     now.UTC(), CreatedBy: by,
	}, nil
}

// Approve signs a rule off (SRS-IPC-004).
//
// Refused for the person who wrote it. A rule decides what every ward is told
// about every patient, and one person writing and approving it is one person
// deciding the hospital's alerting.
func (r *AlertRule) Approve(by string, effectiveFrom time.Time,
	now time.Time) error {

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

func normalise(in []string) []string {
	seen := map[string]bool{}
	out := make([]string, 0, len(in))
	for _, value := range in {
		value = strings.TrimSpace(value)
		if value == "" || seen[strings.ToLower(value)] {
			continue
		}
		seen[strings.ToLower(value)] = true
		out = append(out, value)
	}
	sort.Strings(out)
	return out
}

// Alert is one rule firing for one patient at one encounter (SRS-IPC-004).
type Alert struct {
	ID       string
	TenantID string

	PatientID   string
	EncounterID string
	FacilityID  string

	// RuleID, RuleCode and RuleRevision together say exactly which rule fired.
	// The revision is the point: an alert from eighteen months ago has to stay
	// explicable after the rule has been changed twice.
	RuleID       string
	RuleCode     string
	RuleRevision int

	// Organism and LastPositiveAt are the evidence the rule fired on.
	Organism       string
	OrganismCode   string
	LastPositiveAt time.Time

	Precaution Precaution
	Advice     string

	RaisedAt time.Time

	AcknowledgedAt time.Time
	AcknowledgedBy string
	// Overridden records somebody deciding the alert does not apply. Audited,
	// which is the requirement's acceptance, and it never stops the alert
	// being raised again at the next encounter: an override is a judgement
	// about this admission, not a permanent exemption.
	Overridden   bool
	OverrideWhy  string
	OverriddenBy string
}

// RaiseAlert fires a rule for a patient (SRS-IPC-004).
//
// The rule must be live: an alert from an unapproved draft or a superseded
// revision is an alert the hospital never agreed to send.
func RaiseAlert(id, tenantID string, rule AlertRule, patientID, encounterID,
	facilityID, organism, organismCode string, lastPositiveAt time.Time,
	now time.Time) (Alert, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Alert{}, fmt.Errorf("%w: an alert needs an id",
			ErrInvalidInfection)
	case !rule.Live(now):
		return Alert{}, fmt.Errorf(
			"%w: rule %s revision %d is not approved and in force",
			ErrInvalidInfection, rule.Code, rule.Revision)
	case strings.TrimSpace(patientID) == "":
		return Alert{}, fmt.Errorf("%w: an alert names its patient",
			ErrInvalidInfection)
	case !rule.Covers(organismCode):
		return Alert{}, fmt.Errorf("%w: rule %s does not cover %q",
			ErrInvalidInfection, rule.Code, organismCode)
	}

	if !lastPositiveAt.IsZero() {
		horizon := now.AddDate(0, 0, -rule.LookbackDays)
		if lastPositiveAt.Before(horizon) {
			return Alert{}, fmt.Errorf(
				"%w: the last positive is outside rule %s's %d-day lookback",
				ErrInvalidInfection, rule.Code, rule.LookbackDays)
		}
	}

	return Alert{
		ID: id, TenantID: tenantID,
		PatientID: patientID, EncounterID: encounterID,
		FacilityID: facilityID,
		RuleID:     rule.ID, RuleCode: rule.Code,
		RuleRevision: rule.Revision,
		Organism:     organism, OrganismCode: organismCode,
		LastPositiveAt: utcOrZero(lastPositiveAt),
		Precaution:     rule.Precaution, Advice: rule.Advice,
		RaisedAt: now.UTC(),
	}, nil
}

// Acknowledge records somebody having seen the alert.
func (a *Alert) Acknowledge(by string, now time.Time) error {
	if strings.TrimSpace(by) == "" {
		return fmt.Errorf("%w: an acknowledgement names who gave it",
			ErrInvalidInfection)
	}
	if !a.AcknowledgedAt.IsZero() {
		return nil
	}
	a.AcknowledgedAt, a.AcknowledgedBy = now.UTC(), by
	return nil
}

// Override records somebody deciding the alert does not apply here
// (SRS-IPC-004).
func (a *Alert) Override(reason, by string, now time.Time) error {
	switch {
	case a.Overridden:
		return fmt.Errorf("%w: this alert is already overridden",
			ErrInvalidInfection)
	case strings.TrimSpace(reason) == "":
		// The reason is the whole of the audit. An override with none is a
		// dismissed alert nobody can review.
		return fmt.Errorf("%w: say why this alert does not apply",
			ErrInvalidInfection)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: an override names who made it",
			ErrInvalidInfection)
	}
	a.Overridden = true
	a.OverrideWhy = strings.TrimSpace(reason)
	a.OverriddenBy = by
	if a.AcknowledgedAt.IsZero() {
		a.AcknowledgedAt, a.AcknowledgedBy = now.UTC(), by
	}
	return nil
}
