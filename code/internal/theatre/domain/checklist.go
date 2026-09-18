package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// The pre-operative checklist (SRS-OT-006) and the surgical safety checklist
// (SRS-OT-007).
//
// Two different things, deliberately kept apart. The pre-operative checklist
// is a readiness gate run over hours by whoever is preparing the patient; the
// safety checklist is the WHO sign-in, time-out and sign-out, performed out
// loud by the team in the room at three specific moments. Folding them into
// one list is how a time-out becomes a form somebody ticks in advance.

// BlockerSeverity says whether an unmet item stops the case.
type BlockerSeverity string

const (
	// BlockerMandatory stops the case unless explicitly waived.
	BlockerMandatory BlockerSeverity = "mandatory"
	// BlockerAdvisory is recorded and does not stop anything.
	BlockerAdvisory BlockerSeverity = "advisory"
)

// PreopItem is one element of the pre-operative checklist, as configured.
type PreopItem struct {
	Code     string
	Label    string
	Severity BlockerSeverity
	// WaivableBy is the role that may waive this item. Empty means nobody may:
	// consent and site marking are not waivable by anyone, and a system where
	// every gate has an override has no gates.
	WaivableBy string
}

// DefaultPreopItems is the checklist a deployment gets before configuring one.
//
// The seven SRS-OT-006 names. Consent and site marking are unwaivable, which
// is the whole point of them: wrong-site surgery and operating without consent
// are never-events, and a hospital that wants to waive them is describing a
// different problem.
func DefaultPreopItems() []PreopItem {
	return []PreopItem{
		{Code: "identity", Label: "Patient identity confirmed",
			Severity: BlockerMandatory},
		{Code: "site_marked", Label: "Site and side marked",
			Severity: BlockerMandatory},
		{Code: "consent", Label: "Consent signed and valid",
			Severity: BlockerMandatory},
		{Code: "investigations", Label: "Required investigations available",
			Severity: BlockerMandatory, WaivableBy: "surgeon"},
		{Code: "blood", Label: "Blood available where required",
			Severity: BlockerMandatory, WaivableBy: "surgeon"},
		{Code: "implants", Label: "Implants available",
			Severity: BlockerMandatory, WaivableBy: "surgeon"},
		{Code: "fasting", Label: "Fasting confirmed",
			Severity: BlockerMandatory, WaivableBy: "anaesthetist"},
		{Code: "risks", Label: "Special risks recorded",
			Severity: BlockerAdvisory},
	}
}

// PreopState is what happened to one item.
type PreopState string

const (
	PreopMet    PreopState = "met"
	PreopUnmet  PreopState = "unmet"
	PreopWaived PreopState = "waived"
	// PreopNotApplicable is an item this case does not need — no implants for
	// an appendicectomy. Distinct from met, because "we did not need blood" and
	// "the blood is here" are different facts.
	PreopNotApplicable PreopState = "not_applicable"
)

// PreopEntry is one recorded answer.
type PreopEntry struct {
	Code  string
	State PreopState
	Note  string
	// WaivedBy and WaivedRole name who waived an item, where one was waived.
	WaivedBy   string
	WaivedRole string
	RecordedBy string
	RecordedAt time.Time
}

// PreopChecklist is one case's readiness record (SRS-OT-006).
type PreopChecklist struct {
	ID       string
	TenantID string
	CaseID   string
	Entries  []PreopEntry
	// Version is the configuration this was answered against, so a checklist
	// answered last month is readable under the rules it was answered under.
	ConfigVersion string
	UpdatedAt     time.Time
}

// Blocker is an item that stops the case (SRS-OT-006).
type Blocker struct {
	Code  string
	Label string
	// Waivable says whether anybody may waive it, and by whom.
	WaivableBy string
}

// Record answers one item.
func (p *PreopChecklist) Record(items []PreopItem, entry PreopEntry) error {
	defined := map[string]PreopItem{}
	for _, item := range items {
		defined[item.Code] = item
	}

	item, known := defined[entry.Code]
	if !known {
		return fmt.Errorf("%w: %q is not on this checklist", ErrInvalidCase, entry.Code)
	}
	if strings.TrimSpace(entry.RecordedBy) == "" {
		return fmt.Errorf("%w: a checklist answer names who gave it", ErrInvalidCase)
	}

	if entry.State == PreopWaived {
		if item.WaivableBy == "" {
			return fmt.Errorf(
				"%w: %q cannot be waived by anybody", ErrInvalidCase, item.Label)
		}
		if !strings.EqualFold(entry.WaivedRole, item.WaivableBy) {
			return fmt.Errorf("%w: only a %s may waive %q",
				ErrInvalidCase, item.WaivableBy, item.Label)
		}
		if strings.TrimSpace(entry.Note) == "" {
			// A waiver with no reason is a blocker somebody clicked past.
			return fmt.Errorf("%w: waiving %q needs a reason",
				ErrInvalidCase, item.Label)
		}
		if strings.TrimSpace(entry.WaivedBy) == "" {
			entry.WaivedBy = entry.RecordedBy
		}
	}

	for i, existing := range p.Entries {
		if existing.Code == entry.Code {
			p.Entries[i] = entry
			p.UpdatedAt = entry.RecordedAt.UTC()
			return nil
		}
	}
	p.Entries = append(p.Entries, entry)
	p.UpdatedAt = entry.RecordedAt.UTC()
	return nil
}

// Blockers returns the mandatory items still unmet and unwaived (SRS-OT-006).
//
// An item nobody has answered counts as unmet. A checklist that treated
// silence as consent would pass every case nobody had looked at, which is the
// opposite of what it exists for.
func (p PreopChecklist) Blockers(items []PreopItem) []Blocker {
	answered := map[string]PreopEntry{}
	for _, entry := range p.Entries {
		answered[entry.Code] = entry
	}

	var out []Blocker
	for _, item := range items {
		if item.Severity != BlockerMandatory {
			continue
		}
		switch answered[item.Code].State {
		case PreopMet, PreopWaived, PreopNotApplicable:
			continue
		}
		out = append(out, Blocker{
			Code: item.Code, Label: item.Label, WaivableBy: item.WaivableBy,
		})
	}
	sort.SliceStable(out, func(i, j int) bool { return out[i].Code < out[j].Code })
	return out
}

// The surgical safety checklist (SRS-OT-007).

// SafetyPhase is one of the three moments.
type SafetyPhase string

const (
	// PhaseSignIn is before induction, with the patient awake.
	PhaseSignIn SafetyPhase = "sign_in"
	// PhaseTimeOut is before incision, with the whole team stopped.
	PhaseTimeOut SafetyPhase = "time_out"
	// PhaseSignOut is before the patient leaves the room.
	PhaseSignOut SafetyPhase = "sign_out"
)

var knownPhases = map[SafetyPhase]bool{
	PhaseSignIn: true, PhaseTimeOut: true, PhaseSignOut: true,
}

// SafetyItem is one question in a phase.
type SafetyItem struct {
	Code  string
	Label string
	Phase SafetyPhase
}

// DefaultSafetyItems is the WHO checklist, abbreviated to what a system can
// hold. A deployment configures its own; this is what it gets meanwhile.
func DefaultSafetyItems() []SafetyItem {
	return []SafetyItem{
		{Code: "identity_confirmed", Label: "Patient confirms identity, site, procedure and consent", Phase: PhaseSignIn},
		{Code: "site_marked", Label: "Site marked", Phase: PhaseSignIn},
		{Code: "anaesthesia_check", Label: "Anaesthesia machine and medication check complete", Phase: PhaseSignIn},
		{Code: "pulse_oximeter", Label: "Pulse oximeter on and working", Phase: PhaseSignIn},
		{Code: "allergy", Label: "Known allergy confirmed", Phase: PhaseSignIn},
		{Code: "airway_risk", Label: "Difficult airway or aspiration risk assessed", Phase: PhaseSignIn},
		{Code: "blood_loss_risk", Label: "Risk of significant blood loss assessed", Phase: PhaseSignIn},

		{Code: "team_introduced", Label: "All team members introduced by name and role", Phase: PhaseTimeOut},
		{Code: "patient_procedure_site", Label: "Surgeon, anaesthetist and nurse confirm patient, site and procedure", Phase: PhaseTimeOut},
		{Code: "critical_steps", Label: "Critical or unexpected steps anticipated", Phase: PhaseTimeOut},
		{Code: "antibiotic", Label: "Antibiotic prophylaxis given in the last 60 minutes", Phase: PhaseTimeOut},
		{Code: "imaging", Label: "Essential imaging displayed", Phase: PhaseTimeOut},

		{Code: "procedure_recorded", Label: "Nurse confirms the procedure recorded", Phase: PhaseSignOut},
		{Code: "counts_correct", Label: "Instrument, swab and sharp counts correct", Phase: PhaseSignOut},
		{Code: "specimen_labelled", Label: "Specimens labelled with patient name", Phase: PhaseSignOut},
		{Code: "equipment_problems", Label: "Equipment problems identified", Phase: PhaseSignOut},
		{Code: "recovery_concerns", Label: "Key concerns for recovery reviewed", Phase: PhaseSignOut},
	}
}

// SafetyAnswer is one recorded answer.
type SafetyAnswer struct {
	Code string
	// Confirmed is the team's answer out loud.
	Confirmed bool
	// Exception is why an item was not confirmed. Required when it was not:
	// SRS-OT-007's "missing item requires explicit exception", which is what
	// stops a checklist being completed by leaving things blank.
	Exception string
}

// SafetyRecord is one phase, performed (SRS-OT-007).
type SafetyRecord struct {
	ID       string
	TenantID string
	CaseID   string

	Phase SafetyPhase
	// Participants are the people in the room who took part, by identifier.
	// The requirement asks for them, and the reason is that a time-out with
	// one participant was not a time-out.
	Participants []string
	Answers      []SafetyAnswer

	PerformedAt time.Time
	PerformedBy string
}

// PerformSafety records one phase of the safety checklist (SRS-OT-007).
func PerformSafety(id, tenantID, caseID string, phase SafetyPhase,
	items []SafetyItem, participants []string, answers []SafetyAnswer,
	by string, at time.Time) (SafetyRecord, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(caseID) == "":
		return SafetyRecord{}, fmt.Errorf("%w: a safety check belongs to a case",
			ErrInvalidCase)
	case !knownPhases[phase]:
		return SafetyRecord{}, fmt.Errorf("%w: unknown checklist phase %q",
			ErrInvalidCase, phase)
	case strings.TrimSpace(by) == "":
		return SafetyRecord{}, fmt.Errorf("%w: a safety check names who led it",
			ErrInvalidCase)
	}

	people := trimmedAll(participants)
	if len(people) < 2 {
		// A time-out is the team stopping together. One person reading a list
		// to themselves is the failure mode the requirement's "team
		// confirmation" clause exists to prevent.
		return SafetyRecord{}, fmt.Errorf(
			"%w: a safety check is performed by the team; name who took part",
			ErrInvalidCase)
	}

	defined := map[string]SafetyItem{}
	for _, item := range items {
		if item.Phase == phase {
			defined[item.Code] = item
		}
	}
	if len(defined) == 0 {
		return SafetyRecord{}, fmt.Errorf("%w: no checklist items for %s",
			ErrInvalidCase, phase)
	}

	given := map[string]SafetyAnswer{}
	for _, answer := range answers {
		code := strings.TrimSpace(answer.Code)
		if _, known := defined[code]; !known {
			return SafetyRecord{}, fmt.Errorf("%w: %q is not in the %s checklist",
				ErrInvalidCase, code, phase)
		}
		if !answer.Confirmed && strings.TrimSpace(answer.Exception) == "" {
			return SafetyRecord{}, fmt.Errorf(
				"%w: %q was not confirmed and no exception was recorded",
				ErrInvalidCase, defined[code].Label)
		}
		given[code] = SafetyAnswer{
			Code: code, Confirmed: answer.Confirmed,
			Exception: strings.TrimSpace(answer.Exception),
		}
	}

	// Every item in the phase must have an answer. Silence is not confirmation.
	recorded := make([]SafetyAnswer, 0, len(defined))
	var unanswered []string
	for code, item := range defined {
		answer, ok := given[code]
		if !ok {
			unanswered = append(unanswered, item.Label)
			continue
		}
		recorded = append(recorded, answer)
	}
	if len(unanswered) > 0 {
		sort.Strings(unanswered)
		return SafetyRecord{}, fmt.Errorf(
			"%w: these were not answered: %s", ErrInvalidCase,
			strings.Join(unanswered, "; "))
	}
	sort.SliceStable(recorded, func(i, j int) bool {
		return recorded[i].Code < recorded[j].Code
	})

	return SafetyRecord{
		ID: id, TenantID: tenantID, CaseID: strings.TrimSpace(caseID),
		Phase: phase, Participants: people, Answers: recorded,
		PerformedAt: at.UTC(), PerformedBy: strings.TrimSpace(by),
	}, nil
}

// Exceptions returns the items this phase did not confirm.
func (r SafetyRecord) Exceptions() []SafetyAnswer {
	var out []SafetyAnswer
	for _, answer := range r.Answers {
		if !answer.Confirmed {
			out = append(out, answer)
		}
	}
	return out
}

// PhasesPerformed reports which phases a case has completed.
func PhasesPerformed(records []SafetyRecord) map[SafetyPhase]bool {
	out := map[SafetyPhase]bool{}
	for _, record := range records {
		out[record.Phase] = true
	}
	return out
}
