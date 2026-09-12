package domain

import (
	"fmt"
	"strings"
	"time"
)

// The patient banner and the patient-context lock
// (SRS-CLN-001, SRS-CLN-017).
//
// These two requirements are one safety problem seen from two sides. The banner
// exists so a clinician can tell at a glance which patient is on the screen; the
// context lock exists so that when they have four charts open, the action they
// take lands on the one they think it does. Wrong-patient errors are among the
// commonest serious incidents in electronic records, and both of these are the
// cheap defences against them.

// Banner is what every clinical screen shows about the patient in front of the
// clinician (SRS-CLN-001).
//
// Assembled here rather than by each screen, because a banner that differs
// between screens is worse than none: a clinician who has learnt to read the
// top-left corner will read it on the screen where it means something else.
type Banner struct {
	PatientID string
	// Identifiers are the positive ones — MRN, national identifier. Plural,
	// because a clinician confirming identity at the bedside reads out whichever
	// one the patient is holding.
	Identifiers []BannerIdentifier
	DisplayName string
	// AgeDisplay is rendered rather than a date: an age in days matters for a
	// neonate and an age in years for everybody else, and a screen showing
	// "0" for a two-week-old is a dosing error waiting to happen.
	AgeDisplay string
	Sex        string
	// Alerts are the things that change what a clinician does in the next
	// minute. Deliberately few: a banner with fifteen alerts is a banner
	// nobody reads.
	Alerts []Alert
	// EncounterContext says which visit the screen is in — "Ward 4, inpatient,
	// day 3". Without it a clinician with a patient's chart open cannot tell
	// whether they are looking at today's admission or last year's clinic.
	EncounterContext string
	// Deceased is shown because prescribing for a deceased patient is a
	// distinct class of error, and because it is the one fact that should stop
	// a clinician mid-action.
	Deceased bool
}

// BannerIdentifier is one identifier a clinician can read out.
type BannerIdentifier struct {
	System string
	Value  string
	Label  string
}

// AlertSeverity is how loudly a banner alert shouts.
type AlertSeverity string

const (
	// AlertCritical could kill in the next few minutes. Anaphylaxis-grade
	// allergy, and little else.
	AlertCritical AlertSeverity = "critical"
	AlertWarning  AlertSeverity = "warning"
	AlertInfo     AlertSeverity = "info"
)

// Alert is one thing a clinician must know before acting.
type Alert struct {
	Severity AlertSeverity
	// Kind groups alerts so a UI can render them consistently — "allergy",
	// "infection_control", "safeguarding".
	Kind string
	// Text is what is shown. Kept short deliberately: a banner is read in a
	// second, and an alert that needs a paragraph belongs in the chart.
	Text string
	// RecordID links to the thing it came from, so a clinician can open it.
	RecordID string
}

// MaxBannerAlerts bounds how many alerts a banner carries.
//
// Five, because a banner with fifteen alerts is a banner nobody reads, and the
// alert that mattered is the one that scrolled. Anything beyond this is
// summarised as a count and the clinician opens the list.
const MaxBannerAlerts = 5

// BuildBanner assembles the banner from what the clinical record holds
// (SRS-CLN-001).
//
// Alerts are ordered most severe first and truncated, so the one that would
// kill the patient is never the one that fell off the end.
func BuildBanner(patientID, displayName, ageDisplay, sex string,
	identifiers []BannerIdentifier, alerts []Alert, encounterContext string,
	deceased bool) Banner {

	ordered := make([]Alert, 0, len(alerts))
	for _, severity := range []AlertSeverity{AlertCritical, AlertWarning, AlertInfo} {
		for _, a := range alerts {
			if a.Severity == severity {
				ordered = append(ordered, a)
			}
		}
	}
	if len(ordered) > MaxBannerAlerts {
		ordered = ordered[:MaxBannerAlerts]
	}

	return Banner{
		PatientID: patientID, Identifiers: identifiers, DisplayName: displayName,
		AgeDisplay: ageDisplay, Sex: sex, Alerts: ordered,
		EncounterContext: encounterContext, Deceased: deceased,
	}
}

// AlertsFromAllergies turns the allergy list into banner alerts.
//
// Only the ones that change what happens in the next minute. An intolerance
// that causes nausea is real and belongs in the chart; on the banner it would
// crowd out the anaphylaxis.
func AlertsFromAllergies(allergies AllergyList) []Alert {
	out := make([]Alert, 0)
	for _, a := range allergies.Active() {
		severity := AlertWarning
		switch a.Criticality {
		case CriticalityHigh:
			severity = AlertCritical
		case CriticalityLow:
			// Intolerances stay off the banner. They are in the chart, and the
			// banner has five lines.
			continue
		}
		out = append(out, Alert{
			Severity: severity, Kind: "allergy",
			Text: a.Substance.Display, RecordID: a.ID,
		})
	}
	return out
}

// ErrPatientContextMismatch reports an action aimed at a different patient from
// the one the caller believes they are working on (SRS-CLN-017).
type ErrPatientContextMismatch struct {
	// Expected is the patient the caller asserted.
	Expected string
	// Actual is the patient the record actually belongs to.
	Actual string
	// Action is what was being attempted, so the message names it.
	Action string
}

func (e ErrPatientContextMismatch) Error() string {
	return fmt.Sprintf(
		"clinical: %s was aimed at a different patient from the one on screen; "+
			"check which chart you are in", e.Action)
}

// PatientContext is the chart a caller believes they are working in
// (SRS-CLN-017).
//
// Carried explicitly on every action that changes a patient's record, and
// checked against the record the action lands on. The acceptance criterion is
// that a "medication/order action clearly identifies target patient and
// encounter", and the failure it guards against is mundane and common: four
// charts open, the wrong tab in front, a prescription for the patient in the
// next bed.
type PatientContext struct {
	// PatientID is who the caller thinks they are working on. Empty means the
	// caller asserted nothing, which is permitted for reads and refused for
	// clinical writes.
	PatientID string
	// EncounterID narrows it to one visit.
	EncounterID string
	// OpenedAt is when the chart was opened, used to expire a stale context: a
	// screen left open overnight is a screen somebody else may be sitting at.
	OpenedAt time.Time
}

// MaxContextAge is how long an asserted patient context stays good.
//
// Eight hours: a shift. Longer, and a screen left open overnight becomes a
// screen the next clinician inherits with somebody else's patient in it.
const MaxContextAge = 8 * time.Hour

// Check verifies an action against the chart the caller believes they are in
// (SRS-CLN-017).
//
// Returns nil when the caller asserted no context: this is a lock a client opts
// into, not one the server can impose on an API that also serves batch imports
// and integration engines. What it must never do is silently pass a mismatch.
func (c PatientContext) Check(patientID, encounterID, action string,
	now time.Time) error {

	if strings.TrimSpace(c.PatientID) == "" {
		return nil
	}
	if c.PatientID != patientID {
		return ErrPatientContextMismatch{
			Expected: c.PatientID, Actual: patientID, Action: action,
		}
	}
	if c.EncounterID != "" && encounterID != "" && c.EncounterID != encounterID {
		return ErrPatientContextMismatch{
			Expected: c.PatientID, Actual: patientID,
			Action: action + " in a different encounter",
		}
	}
	if !c.OpenedAt.IsZero() && now.Sub(c.OpenedAt) > MaxContextAge {
		return fmt.Errorf(
			"%w: this chart was opened more than %v ago; reopen it before %s",
			ErrInvalidDocument, MaxContextAge, action)
	}
	return nil
}
