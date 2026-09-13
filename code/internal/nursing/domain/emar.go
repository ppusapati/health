package domain

import (
	"strings"
	"time"
)

// The medication administration record (SRS-NUR-007 … SRS-NUR-009, SRS-NUR-018).
//
// This is the file where a mistake harms a patient, and its rules are
// correspondingly unforgiving.
//
// SRS-NUR-007 says only active *verified* orders create administration tasks.
// Verification is the pharmacist's check, and the gap between a doctor
// prescribing and a pharmacist verifying is where dose and interaction errors
// are caught. A task list built from unverified orders invites a nurse to give
// the dose the pharmacist was about to question.
//
// SRS-NUR-008 says a barcode mismatch prevents completion unless an explicit
// emergency override applies. So the mismatch is a refusal, not a warning: a
// warning that can be clicked through is how wrong-patient administrations
// happen with a barcode system installed.
//
// SRS-NUR-009 says the MAR retains scheduled versus actual. Both, always. A
// record showing only what was given cannot answer "was it late", and lateness
// is the question an insulin or an antibiotic review turns on.
//
// SRS-NUR-018 says recovery reconciliation must not produce duplicate
// administration records. See ScheduledDoseKey.

// MedicationOrder is what the nursing context needs to know about an order.
//
// A projection of the medication context (SRS-MED, Wave 1 Sprint 5) rather
// than a copy of it: nursing needs to know what to give, when, and whether it
// has been verified, and does not need the prescribing rationale or the
// interaction checks that produced it.
type MedicationOrder struct {
	OrderID     string
	PatientID   string
	EncounterID string
	// Medication is the product as the order names it.
	Medication Coding
	// Dose, Route and Frequency are what the nurse acts on.
	Dose      Quantity
	Route     string
	Frequency string
	// Status and Verified are SRS-NUR-007's gate.
	Status OrderStatus
	// Verified is the pharmacist's check. A separate field rather than a
	// status value, because an order can be active and unverified and the
	// distinction is exactly what the requirement is about.
	Verified   bool
	VerifiedBy string
	VerifiedAt time.Time
	// PRN marks an as-needed medication, which has no schedule and is why
	// duplicate protection needs a second mechanism.
	PRN bool

	StartsAt time.Time
	EndsAt   time.Time
}

// OrderStatus is where an order stands.
type OrderStatus string

const (
	OrderDraft     OrderStatus = "draft"
	OrderActive    OrderStatus = "active"
	OrderHeld      OrderStatus = "held"
	OrderCompleted OrderStatus = "completed"
	OrderCancelled OrderStatus = "cancelled"
)

// Administrable reports whether this order may produce an administration task
// at this moment (SRS-NUR-007).
func (o MedicationOrder) Administrable(at time.Time) bool {
	if o.Status != OrderActive || !o.Verified {
		return false
	}
	at = at.UTC()
	if !o.StartsAt.IsZero() && at.Before(o.StartsAt.UTC()) {
		return false
	}
	if !o.EndsAt.IsZero() && !at.Before(o.EndsAt.UTC()) {
		return false
	}
	return true
}

// AdministrationOutcome is what happened to a scheduled dose (SRS-NUR-009).
type AdministrationOutcome string

const (
	Administered AdministrationOutcome = "administered"
	// NotAdministered is a dose that was not given and will not be — the order
	// was stopped, the drug was unavailable.
	NotAdministered AdministrationOutcome = "not_administered"
	// Held is a clinical decision to withhold this dose: the blood pressure
	// was too low for the antihypertensive. Distinct from not-administered
	// because holding is an act of judgement that somebody is answerable for.
	Held AdministrationOutcome = "held"
	// Refused is the patient's decision, which is not the nurse's to record as
	// a hold.
	Refused AdministrationOutcome = "refused"
	// Delayed was given, but outside the window. Recorded as its own outcome
	// rather than as an administered dose with a late timestamp, because the
	// nurse asserting it was late is different evidence from a report deriving
	// it.
	Delayed AdministrationOutcome = "delayed"
)

var knownOutcomes = map[AdministrationOutcome]bool{
	Administered: true, NotAdministered: true, Held: true,
	Refused: true, Delayed: true,
}

// requiresReason lists the outcomes that cannot stand without an explanation.
// Everything except a plain administration: a dose not given is a clinical
// event, and "why" is the only part of it that is useful later.
func (o AdministrationOutcome) requiresReason() bool {
	return o != Administered
}

// Verification is the barcode check (SRS-NUR-008).
type Verification struct {
	// PatientScanned is the identifier read from the wristband. Compared
	// against the order's patient rather than against whatever the screen is
	// showing, because the screen is what the check exists to doubt.
	PatientScanned string
	// MedicationScanned is the identifier read from the product.
	MedicationScanned string
	// Performed distinguishes "the barcode workflow ran and matched" from "the
	// barcode workflow did not run", which a pair of empty strings cannot.
	Performed bool
	ScannedAt time.Time
}

// VerificationResult is what the check concluded.
type VerificationResult struct {
	PatientMatched    bool
	MedicationMatched bool
}

// OK reports a clean check.
func (v VerificationResult) OK() bool { return v.PatientMatched && v.MedicationMatched }

// Check compares the scans against what was expected.
//
// Expected identifiers are supplied rather than read from the administration,
// so the comparison is against the order's own patient and product.
func (v Verification) Check(expectedPatient, expectedMedication string) VerificationResult {
	return VerificationResult{
		PatientMatched: v.Performed &&
			strings.EqualFold(strings.TrimSpace(v.PatientScanned),
				strings.TrimSpace(expectedPatient)),
		MedicationMatched: v.Performed &&
			strings.EqualFold(strings.TrimSpace(v.MedicationScanned),
				strings.TrimSpace(expectedMedication)),
	}
}

// MinOverrideReasonLength keeps "ok" out of the override report.
const MinOverrideReasonLength = 10

// Override is an administration completed despite a failed or absent check
// (SRS-NUR-008).
//
// Stored on the administration rather than only audited, for the reason
// SRS-ENC-008's override is: the audit trail answers "who did this", and the
// stored record answers "how often, on which ward, for which drugs" — which is
// the question that gets a broken scanner replaced.
type Override struct {
	Reason string
	By     string
	At     time.Time
	// Failed records what did not match, captured at the time rather than
	// recomputed. The wristband gets reprinted; the report must still show
	// what the nurse was looking at.
	PatientMismatch    bool
	MedicationMismatch bool
	NotScanned         bool
}

// Administration is one dose's record (SRS-NUR-009).
type Administration struct {
	ID          string
	TenantID    string
	PatientID   string
	EncounterID string
	OrderID     string

	Medication Coding
	// ScheduledDose and ScheduledAt are what the order asked for.
	ScheduledDose Quantity
	ScheduledAt   time.Time
	// GivenDose, GivenAt, Route and Site are what actually happened. Kept
	// separately from the scheduled values rather than overwriting them, which
	// is the whole of SRS-NUR-009's acceptance criterion.
	GivenDose Quantity
	GivenAt   time.Time
	Route     string
	Site      string

	Outcome AdministrationOutcome
	Reason  string

	Verification Verification
	Override     *Override

	// IdempotencyKey deduplicates a PRN dose re-keyed during downtime
	// reconciliation, where there is no scheduled time to key on
	// (SRS-NUR-018).
	IdempotencyKey string
	// RecordedOffline marks a dose given while the ward was on paper. Visible
	// on the MAR, because a record reconstructed from a paper chart hours later
	// is weaker evidence than one charted at the bedside and a reviewer should
	// be able to see which they are reading.
	RecordedOffline bool

	AdministeredBy string
	// WitnessedBy is the second nurse a controlled drug needs. Not enforced
	// here — which drugs need a witness is a medication-context policy — but
	// recorded where the policy applies.
	WitnessedBy string
	RecordedAt  time.Time
	Version     int64
}

// ScheduledDoseKey is the duplicate-administration guard (SRS-NUR-018).
//
// The reconciliation problem is that a paper MAR re-keyed after downtime can
// be re-keyed twice — by two nurses, or by one nurse whose first attempt
// appeared to fail. A client-generated identifier does not help, because the
// two transcriptions are genuinely different submissions of the same event.
//
// What identifies the event is the dose itself: this order, this scheduled
// time. That tuple is unique per administration and is carried on the paper
// chart, so both transcriptions produce the same key and the second is
// rejected at the table.
//
// A PRN dose has no scheduled time and no such key, which is why
// IdempotencyKey exists as well — a weaker guard, but a PRN dose given twice
// is a clinical judgement that may be correct, and refusing it outright would
// be wrong.
func (a *Administration) ScheduledDoseKey() (string, bool) {
	if a.ScheduledAt.IsZero() {
		return "", false
	}
	return a.OrderID + "|" + a.ScheduledAt.UTC().Format(time.RFC3339), true
}

// NewAdministrationInput is what recording a dose needs.
type NewAdministrationInput struct {
	Order          MedicationOrder
	ScheduledAt    time.Time
	GivenDose      Quantity
	GivenAt        time.Time
	Route          string
	Site           string
	Outcome        AdministrationOutcome
	Reason         string
	Verification   Verification
	OverrideReason string
	WitnessedBy    string
	IdempotencyKey string
	Offline        bool
}

// AdministrationPolicy is what a facility requires before a dose is completed.
type AdministrationPolicy struct {
	// BarcodeRequired turns on SRS-NUR-008's check. Off where the ward has no
	// scanners: the requirement says "where barcode workflow enabled", and a
	// mandatory check on a ward without hardware would stop medication rounds.
	BarcodeRequired bool
	// OverrideAllowed is the "explicit emergency override policy". A facility
	// that turns this off has decided a mismatch is never given through, which
	// is a defensible position and the system must be able to hold it.
	OverrideAllowed bool
	// LateAfter is how far past the scheduled time a dose counts as delayed.
	LateAfter time.Duration
}

// DefaultAdministrationPolicy is the safe default: scan, and allow a
// documented override.
//
// Barcode on by default rather than off, because a safety control that has to
// be switched on is a safety control that is off in the wards that most need
// it. A facility without scanners turns it off deliberately and that decision
// is visible.
func DefaultAdministrationPolicy() AdministrationPolicy {
	return AdministrationPolicy{
		BarcodeRequired: true, OverrideAllowed: true,
		LateAfter: time.Hour,
	}
}

// ErrVerificationFailed reports a barcode mismatch that stopped an
// administration (SRS-NUR-008).
type ErrVerificationFailed struct {
	PatientMismatch    bool
	MedicationMismatch bool
	NotScanned         bool
	// Overridable says whether policy would accept a documented override, so
	// the caller can tell a nurse whether there is a way forward rather than
	// making them discover it by trying.
	Overridable bool
}

func (e ErrVerificationFailed) Error() string {
	var parts []string
	if e.NotScanned {
		parts = append(parts, "the patient and the medication were not scanned")
	}
	if e.PatientMismatch {
		parts = append(parts, "the wristband does not match this order's patient")
	}
	if e.MedicationMismatch {
		parts = append(parts, "the product scanned is not the one ordered")
	}
	return "nursing: administration stopped: " + strings.Join(parts, "; ")
}

// Is lets callers match with errors.Is.
func (e ErrVerificationFailed) Is(target error) bool {
	_, ok := target.(ErrVerificationFailed)
	return ok
}

// NewAdministration records what happened to a dose.
//
// The verification check runs before anything is built, so a refused
// administration leaves no partial record behind.
func NewAdministration(id, tenantID string, in NewAdministrationInput,
	policy AdministrationPolicy, administeredBy string, now time.Time) (
	*Administration, error) {

	if strings.TrimSpace(in.Order.OrderID) == "" {
		return nil, invalidf("an administration needs an order")
	}
	if strings.TrimSpace(in.Order.PatientID) == "" {
		return nil, invalidf("an administration needs a patient")
	}
	if strings.TrimSpace(administeredBy) == "" {
		return nil, invalidf("an administration must record who gave the dose")
	}
	if !knownOutcomes[in.Outcome] {
		return nil, invalidf("unknown administration outcome %q", in.Outcome)
	}
	if in.Outcome.requiresReason() && strings.TrimSpace(in.Reason) == "" {
		return nil, invalidf("recording a dose as %q needs a reason", in.Outcome)
	}
	// SRS-NUR-007: the gate is on the order, and it is checked here as well as
	// when the worklist is built, because a stale worklist is exactly the case
	// a nurse would be acting on.
	if !in.Order.Administrable(now) {
		return nil, notAllowedf(
			"order %s is not an active, pharmacist-verified order", in.Order.OrderID)
	}

	given := in.GivenAt.UTC()
	if in.Outcome == Administered || in.Outcome == Delayed {
		if in.GivenAt.IsZero() {
			return nil, invalidf("a dose that was given needs the time it was given")
		}
		if given.After(now.UTC()) {
			return nil, invalidf("a dose cannot have been given in the future")
		}
		if in.GivenDose.Value <= 0 {
			return nil, invalidf("a dose that was given needs the amount given")
		}
		if strings.TrimSpace(in.GivenDose.Unit) == "" {
			return nil, invalidf("a dose needs its unit")
		}
		if strings.TrimSpace(in.Route) == "" {
			// An oral dose given intravenously is a class of error this field
			// exists to make visible; leaving it blank hides it.
			return nil, invalidf("a dose that was given needs the route it was given by")
		}
	}

	var override *Override
	// SRS-NUR-008. The check runs only where the workflow is enabled, and only
	// for a dose that was actually given: refusing to let a nurse record that a
	// patient refused their tablet because the scanner is broken would be
	// absurd, and would push the record off the system.
	if policy.BarcodeRequired && (in.Outcome == Administered || in.Outcome == Delayed) {
		result := in.Verification.Check(in.Order.PatientID, in.Order.Medication.Code)
		if !result.OK() {
			failure := ErrVerificationFailed{
				PatientMismatch:    in.Verification.Performed && !result.PatientMatched,
				MedicationMismatch: in.Verification.Performed && !result.MedicationMatched,
				NotScanned:         !in.Verification.Performed,
				Overridable:        policy.OverrideAllowed,
			}
			reason := strings.TrimSpace(in.OverrideReason)
			if reason == "" {
				return nil, failure
			}
			if !policy.OverrideAllowed {
				return nil, notAllowedf(
					"this facility does not allow a failed verification to be overridden")
			}
			if len(reason) < MinOverrideReasonLength {
				return nil, invalidf(
					"overriding a failed verification needs a reason of at least %d characters",
					MinOverrideReasonLength)
			}
			override = &Override{
				Reason: reason, By: administeredBy, At: now.UTC(),
				PatientMismatch:    failure.PatientMismatch,
				MedicationMismatch: failure.MedicationMismatch,
				NotScanned:         failure.NotScanned,
			}
		}
	}

	admin := &Administration{
		ID: id, TenantID: tenantID,
		PatientID: in.Order.PatientID, EncounterID: in.Order.EncounterID,
		OrderID:         in.Order.OrderID,
		Medication:      in.Order.Medication,
		ScheduledDose:   in.Order.Dose,
		GivenDose:       in.GivenDose,
		Route:           strings.TrimSpace(in.Route),
		Site:            strings.TrimSpace(in.Site),
		Outcome:         in.Outcome,
		Reason:          strings.TrimSpace(in.Reason),
		Verification:    in.Verification,
		Override:        override,
		IdempotencyKey:  strings.TrimSpace(in.IdempotencyKey),
		RecordedOffline: in.Offline,
		AdministeredBy:  administeredBy,
		WitnessedBy:     strings.TrimSpace(in.WitnessedBy),
		RecordedAt:      now.UTC(),
		Version:         1,
	}
	if !in.ScheduledAt.IsZero() {
		admin.ScheduledAt = in.ScheduledAt.UTC()
	}
	if !in.GivenAt.IsZero() {
		admin.GivenAt = given
	}
	return admin, nil
}

// Late reports whether the dose was given outside its window.
//
// Derived rather than stored, because it is a function of the policy and the
// policy can change — but the nurse's own assertion that a dose was late is
// the Delayed outcome, which is stored. The two answer different questions:
// this one is for a report, that one is testimony.
func (a *Administration) Late(policy AdministrationPolicy) bool {
	if a.ScheduledAt.IsZero() || a.GivenAt.IsZero() {
		return false
	}
	if policy.LateAfter <= 0 {
		return false
	}
	return a.GivenAt.Sub(a.ScheduledAt) > policy.LateAfter
}

// Variance is how far the dose given differed from the dose ordered.
func (a *Administration) Variance() (float64, bool) {
	if a.ScheduledDose.Value == 0 || a.GivenDose.Value == 0 {
		return 0, false
	}
	if !strings.EqualFold(a.ScheduledDose.Unit, a.GivenDose.Unit) {
		// Two different units is not a variance, it is a question. Reporting a
		// number here would be a number computed across scales.
		return 0, false
	}
	return a.GivenDose.Value - a.ScheduledDose.Value, true
}

// DueDose is one entry on the medication round (SRS-NUR-007).
type DueDose struct {
	Order       MedicationOrder
	ScheduledAt time.Time
	// Given points at the administration that closed this dose, where one
	// exists. A round that does not show what has already been given invites
	// the dose being given twice.
	Given *Administration
}

// Outstanding reports a dose still waiting.
func (d DueDose) Outstanding() bool { return d.Given == nil }

// Overdue reports a dose past its window and still not given.
func (d DueDose) Overdue(policy AdministrationPolicy, now time.Time) bool {
	if !d.Outstanding() || d.ScheduledAt.IsZero() || policy.LateAfter <= 0 {
		return false
	}
	return now.UTC().Sub(d.ScheduledAt.UTC()) > policy.LateAfter
}
