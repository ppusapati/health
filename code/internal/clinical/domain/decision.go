package domain

import (
	"fmt"
	"strings"
	"time"
)

// Clinical calculators and decision support (SRS-CLN-020, SRS-CLN-021).
//
// Both requirements are the same insight stated twice: a computed clinical
// number or a fired alert is a claim somebody will act on, and a claim nobody
// can reconstruct is a claim nobody can defend. So a calculation stores its
// inputs, its formula version and its output, and an alert stores the rule and
// version that fired it. The acceptance criteria are explicit that
// recalculation with a new formula "never overwrites historical result" and
// that an override "is stored and reportable".

// CalculatorResult is one run of a clinical calculator (SRS-CLN-020).
//
// Stored, never recomputed on read. A score rendered on demand changes meaning
// the day the formula is corrected, so a note saying "CHA2DS2-VASc 3" would
// silently become 4 and nobody would know which number the anticoagulation
// decision was made from.
type CalculatorResult struct {
	ID          string
	TenantID    string
	PatientID   string
	EncounterID string
	// CalculatorID and Version name the exact formula.
	CalculatorID string
	// Version is mandatory: an unversioned calculator makes every stored score
	// ambiguous the first time somebody corrects a coefficient.
	Version string
	Name    string
	// Inputs are the values the formula was given, captured at the moment of
	// the run. A score whose inputs were not kept cannot be checked, and the
	// one time anybody checks is when it looks wrong.
	Inputs []CalculatorInput
	// Value and Unit are the output.
	Value float64
	Unit  string
	// Interpretation is what the score means — "high risk", "moderate".
	Interpretation string
	// SupersededByID chains to a rerun with a newer formula. The original
	// stays: recalculation never overwrites history.
	SupersededByID string

	CalculatedBy string
	CalculatedAt time.Time
}

// CalculatorInput is one value a formula was given.
type CalculatorInput struct {
	Name  string
	Value string
	Unit  string
	// SourceID names the observation or record the value came from, where it
	// came from one. A score built from values somebody typed is a different
	// thing from one built from measurements, and only this distinguishes them.
	SourceID string
}

// NewCalculatorResult validates and constructs a stored calculation.
func NewCalculatorResult(id, tenantID string, in NewCalculatorResultInput,
	calculatedBy string, now time.Time) (CalculatorResult, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return CalculatorResult{}, fmt.Errorf("%w: calculation id is required",
			ErrInvalidDocument)
	case strings.TrimSpace(in.PatientID) == "":
		return CalculatorResult{}, fmt.Errorf("%w: a calculation needs a patient",
			ErrInvalidDocument)
	case strings.TrimSpace(in.CalculatorID) == "":
		return CalculatorResult{}, fmt.Errorf("%w: a calculation needs a calculator",
			ErrInvalidDocument)
	case strings.TrimSpace(in.Version) == "":
		// An unversioned calculator makes every stored score ambiguous the
		// first time somebody corrects a coefficient.
		return CalculatorResult{}, fmt.Errorf(
			"%w: a calculation must record the formula version it used",
			ErrInvalidDocument)
	case len(in.Inputs) == 0:
		// A score whose inputs were not kept cannot be checked, and the one
		// time anybody checks is when it looks wrong.
		return CalculatorResult{}, fmt.Errorf(
			"%w: a calculation must store the values it was given", ErrInvalidDocument)
	case strings.TrimSpace(calculatedBy) == "":
		return CalculatorResult{}, fmt.Errorf("%w: a calculation must record who ran it",
			ErrInvalidDocument)
	}

	for _, input := range in.Inputs {
		if strings.TrimSpace(input.Name) == "" {
			return CalculatorResult{}, fmt.Errorf("%w: every calculator input needs a name",
				ErrInvalidDocument)
		}
	}

	return CalculatorResult{
		ID: id, TenantID: tenantID, PatientID: in.PatientID,
		EncounterID: in.EncounterID, CalculatorID: in.CalculatorID,
		Version: in.Version, Name: in.Name, Inputs: in.Inputs,
		Value: in.Value, Unit: in.Unit, Interpretation: in.Interpretation,
		CalculatedBy: calculatedBy, CalculatedAt: now.UTC(),
	}, nil
}

// NewCalculatorResultInput is what storing a calculation needs.
type NewCalculatorResultInput struct {
	PatientID      string
	EncounterID    string
	CalculatorID   string
	Version        string
	Name           string
	Inputs         []CalculatorInput
	Value          float64
	Unit           string
	Interpretation string
}

// Live reports a calculation that has not been superseded by a rerun.
func (r CalculatorResult) Live() bool { return r.SupersededByID == "" }

// AlertSeverityLevel is how urgent a decision-support alert is
// (SRS-CLN-021).
type AlertSeverityLevel string

const (
	// AlertLevelHard stops the action until somebody overrides it. Reserved
	// for the few rules where proceeding is almost never right — a drug the
	// patient has anaphylaxis to.
	AlertLevelHard AlertSeverityLevel = "hard"
	// AlertLevelSoft warns and lets the clinician proceed. Most rules are
	// this, because a system where everything is a hard stop is a system where
	// clinicians learn to dismiss hard stops.
	AlertLevelSoft AlertSeverityLevel = "soft"
	AlertLevelInfo AlertSeverityLevel = "info"
)

var knownAlertLevels = map[AlertSeverityLevel]bool{
	AlertLevelHard: true, AlertLevelSoft: true, AlertLevelInfo: true,
}

// CDSAlert is one firing of a decision-support rule (SRS-CLN-021).
type CDSAlert struct {
	ID          string
	TenantID    string
	PatientID   string
	EncounterID string
	// RuleID and RuleVersion name what fired. The requirement asks for alerts
	// to "identify triggering rule/version", and the reason is that rules are
	// tuned constantly: an override report that could not say which version
	// fired cannot tell a tuning change from a behaviour change.
	RuleID      string
	RuleVersion string
	// Level decides whether the action is stopped or merely warned about.
	Level AlertSeverityLevel
	// Message is what the clinician saw. Stored rather than re-rendered: the
	// wording is tuned too, and an override against a message nobody can
	// reproduce is an override nobody can interpret.
	Message string
	// Context names what the alert was about — the order, the prescription.
	ContextType string
	ContextID   string

	// Outcome records what the clinician did.
	Outcome CDSOutcome
	// OverrideReason is why they proceeded anyway. Mandatory for a hard alert.
	OverrideReason string
	// OverrideCode is a chosen reason from the configured list, which is what
	// makes overrides reportable rather than a pile of free text.
	OverrideCode string

	FiredAt     time.Time
	RespondedBy string
	RespondedAt time.Time
}

// CDSOutcome is what happened to an alert.
type CDSOutcome string

const (
	// CDSPending has fired and not yet been answered.
	CDSPending CDSOutcome = "pending"
	// CDSAccepted means the clinician changed what they were doing. The
	// outcome that justifies the whole system, and the one a tuning review
	// counts.
	CDSAccepted CDSOutcome = "accepted"
	// CDSOverridden means they proceeded anyway, with a reason.
	CDSOverridden CDSOutcome = "overridden"
	// CDSNotApplicable means the clinician judged the rule did not apply.
	CDSNotApplicable CDSOutcome = "not_applicable"
)

var knownCDSOutcomes = map[CDSOutcome]bool{
	CDSPending: true, CDSAccepted: true, CDSOverridden: true, CDSNotApplicable: true,
}

// NewCDSAlert validates and constructs a fired alert.
func NewCDSAlert(id, tenantID string, in NewCDSAlertInput, now time.Time) (
	CDSAlert, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return CDSAlert{}, fmt.Errorf("%w: alert id is required", ErrInvalidDocument)
	case strings.TrimSpace(in.PatientID) == "":
		return CDSAlert{}, fmt.Errorf("%w: an alert needs a patient", ErrInvalidDocument)
	case strings.TrimSpace(in.RuleID) == "":
		return CDSAlert{}, fmt.Errorf("%w: an alert needs the rule that fired it",
			ErrInvalidDocument)
	case strings.TrimSpace(in.RuleVersion) == "":
		// An override report that could not say which version fired cannot
		// tell a tuning change from a behaviour change.
		return CDSAlert{}, fmt.Errorf("%w: an alert must name the rule version",
			ErrInvalidDocument)
	case !knownAlertLevels[in.Level]:
		return CDSAlert{}, fmt.Errorf("%w: unknown alert level %q", ErrInvalidDocument, in.Level)
	case strings.TrimSpace(in.Message) == "":
		return CDSAlert{}, fmt.Errorf("%w: an alert needs the message the clinician saw",
			ErrInvalidDocument)
	}

	return CDSAlert{
		ID: id, TenantID: tenantID, PatientID: in.PatientID,
		EncounterID: in.EncounterID, RuleID: in.RuleID, RuleVersion: in.RuleVersion,
		Level: in.Level, Message: in.Message,
		ContextType: in.ContextType, ContextID: in.ContextID,
		Outcome: CDSPending, FiredAt: now.UTC(),
	}, nil
}

// NewCDSAlertInput is what recording a fired alert needs.
type NewCDSAlertInput struct {
	PatientID   string
	EncounterID string
	RuleID      string
	RuleVersion string
	Level       AlertSeverityLevel
	Message     string
	ContextType string
	ContextID   string
}

// MinOverrideReasonLength stops "ok" from counting as a reason for proceeding
// against a hard clinical alert.
const MinOverrideReasonLength = 10

// Respond records what the clinician did about an alert (SRS-CLN-021).
func (a *CDSAlert) Respond(outcome CDSOutcome, code, reason, by string,
	now time.Time) error {

	reason = strings.TrimSpace(reason)

	switch {
	case !knownCDSOutcomes[outcome]:
		return fmt.Errorf("%w: unknown alert outcome %q", ErrInvalidDocument, outcome)
	case outcome == CDSPending:
		return fmt.Errorf("%w: pending is not a response", ErrInvalidDocument)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a response must record who made it", ErrInvalidDocument)
	case a.Outcome != CDSPending:
		// Answering twice would let a second click rewrite the first
		// clinician's stated reason.
		return fmt.Errorf("%w: this alert has already been answered", ErrInvalidDocument)
	}

	if outcome == CDSOverridden {
		if a.Level == AlertLevelHard && len(reason) < MinOverrideReasonLength {
			return fmt.Errorf(
				"%w: overriding a hard alert needs a reason of at least %d characters",
				ErrInvalidDocument, MinOverrideReasonLength)
		}
		if strings.TrimSpace(code) == "" && reason == "" {
			// Either a chosen code or stated words. Without one of them the
			// override is unreportable, which is exactly what the requirement
			// forbids.
			return fmt.Errorf("%w: an override needs a reason", ErrInvalidDocument)
		}
	}

	a.Outcome = outcome
	a.OverrideCode = strings.TrimSpace(code)
	a.OverrideReason = reason
	a.RespondedBy = by
	a.RespondedAt = now.UTC()
	return nil
}

// Blocking reports an alert that stops the action until it is answered.
func (a CDSAlert) Blocking() bool {
	return a.Level == AlertLevelHard && a.Outcome == CDSPending
}
