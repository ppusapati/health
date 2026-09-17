// Package domain holds the Emergency Department's rules (SRS-ER-001 … 018).
//
// An emergency department is the one place in a hospital where the record has
// to keep up with a resuscitation. Everything here is shaped by that: the
// order of events matters more than anywhere else, a patient may have no name
// for the first twenty minutes, and the difference between "recorded at the
// time" and "written up afterwards" is the difference between a defensible
// record and a reconstructed one.
//
// Three rules run through the whole package.
//
// **Care never waits for the record.** SRS-ER-004 requires an unidentified
// patient to be treated before anybody knows who they are, and SRS-ER-009
// requires a drug to be given before the order exists where protocol allows
// it. Both are refusals to let paperwork gate treatment — and both are paid
// for by a reconciliation obligation that the system will not let anybody
// forget.
//
// **Times are derived, never typed.** SRS-ER-006 asks for door-to-triage and
// door-to-doctor, verified by "operational dashboard derives times from
// immutable events". A stored interval is a number somebody can be asked to
// improve; a derived one is a consequence of what happened.
//
// **Late is visible.** SRS-ER-008 requires events to preserve sequence and
// actor with late entry marked. A resuscitation is written up in arrears more
// often than not, and a timeline that hid which entries were reconstructed
// would be worse than one that admitted it.
package domain

import (
	"errors"
	"fmt"
	"strings"
	"time"
)

// ErrInvalidVisit is a refusal to create or advance an emergency visit.
var ErrInvalidVisit = errors.New("emergency: invalid visit")

// ArrivalMode is how the patient reached the department (SRS-ER-001).
//
// Recorded because it changes what happens next: an ambulance arrival has a
// pre-alert and a handover, a referral has a letter and an expectation, and a
// walk-in has neither.
type ArrivalMode string

const (
	ArrivalWalkIn    ArrivalMode = "walk_in"
	ArrivalAmbulance ArrivalMode = "ambulance"
	ArrivalReferral  ArrivalMode = "referral"
	// ArrivalTransfer is from another facility, which carries an obligation
	// the others do not: somebody is expecting a reply.
	ArrivalTransfer ArrivalMode = "transfer"
	// ArrivalUnspecified is a stored mode this build cannot read. Never
	// treated as walk-in: a transfer misread as a walk-in is a referring
	// hospital nobody writes back to.
	ArrivalUnspecified ArrivalMode = "unspecified"
)

var knownArrivalModes = map[ArrivalMode]bool{
	ArrivalWalkIn: true, ArrivalAmbulance: true, ArrivalReferral: true,
	ArrivalTransfer: true, ArrivalUnspecified: true,
}

// KnownArrivalMode reports whether a stored value is one this build handles.
func KnownArrivalMode(raw string) bool { return knownArrivalModes[ArrivalMode(raw)] }

// VisitStatus is where a patient is in the department.
type VisitStatus string

const (
	// StatusArrived has been booked in and not yet triaged. The clock that
	// matters most — door-to-triage — is running.
	StatusArrived VisitStatus = "arrived"
	StatusTriaged VisitStatus = "triaged"
	// StatusInTreatment means a clinician has taken the patient.
	StatusInTreatment VisitStatus = "in_treatment"
	// StatusObservation is an ED observation bed (SRS-ER-014): still the
	// department's patient, not an inpatient admission.
	StatusObservation VisitStatus = "observation"
	StatusDisposed    VisitStatus = "disposed"
)

var knownVisitStatuses = map[VisitStatus]bool{
	StatusArrived: true, StatusTriaged: true, StatusInTreatment: true,
	StatusObservation: true, StatusDisposed: true,
}

// KnownVisitStatus reports whether a stored value is one this build handles.
func KnownVisitStatus(raw string) bool { return knownVisitStatuses[VisitStatus(raw)] }

// Open reports a visit the department is still responsible for.
func (s VisitStatus) Open() bool { return s != StatusDisposed }

// Disposition is where the patient goes (SRS-ER-013).
type Disposition string

const (
	DispositionDischarge   Disposition = "discharge"
	DispositionObservation Disposition = "observation"
	DispositionAdmission   Disposition = "admission"
	DispositionTheatre     Disposition = "theatre"
	DispositionICU         Disposition = "icu"
	DispositionTransfer    Disposition = "transfer"
	// DispositionLeftAgainstAdvice is a decision the patient made. Distinct
	// from absconded because one was witnessed and counselled and the other
	// was not, and the difference is the whole of the medico-legal record.
	DispositionLeftAgainstAdvice Disposition = "left_against_advice"
	// DispositionAbsconded means the department lost the patient. It is a
	// disposition because the alternative is a visit that stays open forever
	// and a patient nobody is looking for.
	DispositionAbsconded Disposition = "absconded"
	DispositionDeath     Disposition = "death"
	DispositionReferral  Disposition = "referral"
	DispositionUnknown   Disposition = "unknown"
)

var knownDispositions = map[Disposition]bool{
	DispositionDischarge: true, DispositionObservation: true,
	DispositionAdmission: true, DispositionTheatre: true, DispositionICU: true,
	DispositionTransfer: true, DispositionLeftAgainstAdvice: true,
	DispositionAbsconded: true, DispositionDeath: true,
	DispositionReferral: true, DispositionUnknown: true,
}

// KnownDisposition reports whether a stored value is one this build handles.
func KnownDisposition(raw string) bool { return knownDispositions[Disposition(raw)] }

// HandsOver reports a disposition that puts the patient into somebody else's
// care, and therefore needs a receiving service to accept them.
//
// Discharge and the two leaving-without-treatment outcomes do not: nobody is
// receiving the patient, and requiring a handover would leave the visit open
// against a service that was never going to answer.
func (d Disposition) HandsOver() bool {
	switch d {
	case DispositionAdmission, DispositionTheatre, DispositionICU,
		DispositionTransfer, DispositionReferral:
		return true
	default:
		return false
	}
}

// Visit is one patient's time in the emergency department.
type Visit struct {
	ID       string
	TenantID string
	// EncounterID is the Wave-1 encounter this visit is the emergency detail
	// of. Emergency does not keep its own patient or its own episode: a
	// department with a second patient record is a department whose allergies
	// disagree with the ward's.
	EncounterID string
	PatientID   string
	FacilityID  string

	ArrivalMode ArrivalMode
	// ChiefComplaint is what the patient or the crew said, in their words.
	// Not coded: the first sentence is evidence, and coding it at the door
	// loses the difference between "crushing chest pain" and "indigestion".
	ChiefComplaint string
	// ArrivedAt starts every clock in SRS-ER-006.
	ArrivedAt time.Time

	// Unidentified is a patient brought in with no name (SRS-ER-004). The
	// visit proceeds; the identity is reconciled later.
	Unidentified bool
	// TemporaryName is what the department calls them meanwhile — "Unknown
	// Male 47". Kept after reconciliation, because the resuscitation record
	// refers to it and a chart that silently renamed its own history would be
	// unreadable at review.
	TemporaryName string

	// MedicoLegal flags a case with statutory reporting and restricted
	// documentation (SRS-ER-011).
	MedicoLegal bool
	// MedicoLegalRef is the police or coroner reference, when there is one.
	MedicoLegalRef string

	Status VisitStatus
	// Location is the cubicle, bay or resus room. Free text because every
	// department names its own space and an enumeration would be edited by
	// each of them in turn.
	Location string

	Disposition Disposition
	// DisposedAt closes the visit's clocks.
	DisposedAt time.Time
	// DispositionNote explains the outcome. Required for the outcomes where
	// the reason is the record: leaving against advice, absconding, death.
	DispositionNote string
	// ReceivingService is who accepted the patient, for a disposition that
	// hands over.
	ReceivingService string

	// ObservationStartedAt and ObservationEndsAt bound an ED observation stay
	// (SRS-ER-014). Separate from an inpatient admission on purpose: an
	// observation bed that was recorded as an admission inflates the
	// department's admission rate and empties its observation reporting.
	ObservationStartedAt time.Time
	ObservationEndsAt    time.Time

	CreatedBy string
	CreatedAt time.Time
	UpdatedAt time.Time
	Version   int64
}

// NewVisitInput is what booking a patient in needs.
type NewVisitInput struct {
	EncounterID    string
	PatientID      string
	FacilityID     string
	ArrivalMode    ArrivalMode
	ChiefComplaint string
	ArrivedAt      time.Time
	Unidentified   bool
	TemporaryName  string
	MedicoLegal    bool
	MedicoLegalRef string
	Location       string
}

// NewVisit books a patient into the department (SRS-ER-001).
func NewVisit(id, tenantID string, in NewVisitInput, createdBy string, now time.Time) (
	Visit, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Visit{}, fmt.Errorf("%w: a visit needs an id", ErrInvalidVisit)
	case strings.TrimSpace(in.EncounterID) == "":
		return Visit{}, fmt.Errorf(
			"%w: an emergency visit is the detail of an encounter", ErrInvalidVisit)
	case strings.TrimSpace(in.ChiefComplaint) == "":
		// The one thing everybody downstream reads first. A visit with no
		// complaint is a row a triage nurse has to ask about from scratch.
		return Visit{}, fmt.Errorf(
			"%w: record what the patient or the crew said brought them in",
			ErrInvalidVisit)
	}

	mode := in.ArrivalMode
	if mode == "" {
		mode = ArrivalWalkIn
	}
	if !knownArrivalModes[mode] || mode == ArrivalUnspecified {
		return Visit{}, fmt.Errorf("%w: unknown arrival mode %q", ErrInvalidVisit, mode)
	}

	// An unidentified patient is treated, not turned away. What is required is
	// something to call them, so the resuscitation record and the wristband
	// agree.
	if in.Unidentified && strings.TrimSpace(in.TemporaryName) == "" {
		return Visit{}, fmt.Errorf(
			"%w: an unidentified patient needs a temporary name the team can use",
			ErrInvalidVisit)
	}
	if !in.Unidentified && strings.TrimSpace(in.PatientID) == "" {
		return Visit{}, fmt.Errorf(
			"%w: an identified visit names its patient", ErrInvalidVisit)
	}

	arrived := in.ArrivedAt
	if arrived.IsZero() {
		arrived = now
	}
	if arrived.After(now.Add(time.Minute)) {
		// A minute for clock skew. Beyond that it is a typo, and it would make
		// every door-to-X interval negative for as long as it stood.
		return Visit{}, fmt.Errorf("%w: a patient cannot have arrived in the future",
			ErrInvalidVisit)
	}

	return Visit{
		ID: id, TenantID: tenantID,
		EncounterID: strings.TrimSpace(in.EncounterID),
		PatientID:   strings.TrimSpace(in.PatientID),
		FacilityID:  in.FacilityID,
		ArrivalMode: mode,
		// Trimmed, never coded: the first sentence is evidence.
		ChiefComplaint: strings.TrimSpace(in.ChiefComplaint),
		ArrivedAt:      arrived.UTC(),
		Unidentified:   in.Unidentified,
		TemporaryName:  strings.TrimSpace(in.TemporaryName),
		MedicoLegal:    in.MedicoLegal,
		MedicoLegalRef: strings.TrimSpace(in.MedicoLegalRef),
		Status:         StatusArrived,
		Location:       strings.TrimSpace(in.Location),
		CreatedBy:      createdBy,
		CreatedAt:      now.UTC(),
		UpdatedAt:      now.UTC(),
		Version:        1,
	}, nil
}

// Identify attaches a real patient to an unidentified visit (SRS-ER-004).
//
// The temporary name is kept. "Merge retains chronology" is the requirement's
// criterion, and a record that renamed its own history would satisfy it on
// paper while making the resuscitation timeline refer to somebody who, as far
// as the chart is concerned, was never there.
func (v *Visit) Identify(patientID string, at time.Time) error {
	if strings.TrimSpace(patientID) == "" {
		return fmt.Errorf("%w: identifying a visit names the patient", ErrInvalidVisit)
	}
	if !v.Unidentified {
		return fmt.Errorf("%w: this visit is already identified", ErrInvalidVisit)
	}

	v.PatientID = strings.TrimSpace(patientID)
	v.Unidentified = false
	v.UpdatedAt = at.UTC()
	return nil
}

// StartObservation puts the patient in an ED observation bed (SRS-ER-014).
func (v *Visit) StartObservation(until time.Time, at time.Time) error {
	if !v.Status.Open() {
		return fmt.Errorf("%w: this visit is closed", ErrInvalidVisit)
	}
	if until.IsZero() || !until.After(at) {
		// An observation with no end is an admission nobody called an
		// admission, and the timer is the whole of SRS-ER-014's
		// "observation status and duration are reportable".
		return fmt.Errorf("%w: an observation stay needs a review time", ErrInvalidVisit)
	}

	v.Status = StatusObservation
	v.ObservationStartedAt = at.UTC()
	v.ObservationEndsAt = until.UTC()
	v.UpdatedAt = at.UTC()
	return nil
}

// ObservationOverdue reports a patient whose review time has passed.
//
// The board's job, not an alarm: an overdue observation is a decision somebody
// owes, and the point of showing it is that four hours in a corridor bed is
// how an observation stay becomes an admission nobody decided on.
func (v Visit) ObservationOverdue(now time.Time) bool {
	return v.Status == StatusObservation &&
		!v.ObservationEndsAt.IsZero() && now.After(v.ObservationEndsAt)
}

// DispositionRequirements is what a disposition needs before it may be set.
//
// Configured per deployment, because what a department requires before sending
// somebody home is a clinical governance decision rather than a property of
// software (SRS-ER-013: "disposition validates required documentation").
type DispositionRequirements struct {
	// NeedsTriage refuses a disposition on a patient nobody assessed. On by
	// default in DefaultDispositionRequirements: a patient discharged without
	// a triage record is one the department cannot show it ever looked at.
	NeedsTriage bool
	// NeedsSignedSummary refuses until the discharge summary is signed
	// (SRS-ER-015).
	NeedsSignedSummary bool
	// NeedsReceivingService refuses a handover nobody accepted.
	NeedsReceivingService bool
	// NeedsNote refuses without an explanation.
	NeedsNote bool
}

// DefaultDispositionRequirements is what applies where a tenant configures
// nothing.
//
// Deliberately not empty. A gate that defaults to permitting everything is a
// gate that exists only for the deployments that already thought about it.
func DefaultDispositionRequirements(d Disposition) DispositionRequirements {
	req := DispositionRequirements{NeedsTriage: true}
	if d.HandsOver() {
		req.NeedsReceivingService = true
	}
	switch d {
	case DispositionDischarge, DispositionReferral:
		req.NeedsSignedSummary = true
	case DispositionLeftAgainstAdvice, DispositionAbsconded, DispositionDeath:
		// The three outcomes where the reason is the record.
		req.NeedsNote = true
	}
	return req
}

// DispositionEvidence is what the visit can show at the moment of disposition.
type DispositionEvidence struct {
	Triaged bool
	// SummarySigned is SRS-ER-015's "only signed/validated source data
	// populate final summary", read as a fact about the summary rather than
	// as a promise about it.
	SummarySigned bool
}

// DispositionRefusal is one reason a disposition may not be set.
type DispositionRefusal string

const (
	RefusalNotTriaged         DispositionRefusal = "not_triaged"
	RefusalSummaryUnsigned    DispositionRefusal = "summary_unsigned"
	RefusalNoReceivingService DispositionRefusal = "no_receiving_service"
	RefusalNoNote             DispositionRefusal = "no_note"
	RefusalAlreadyDisposed    DispositionRefusal = "already_disposed"
	RefusalUnknownOutcome     DispositionRefusal = "unknown_outcome"
)

// Explain says what to do about a refusal.
func (r DispositionRefusal) Explain() string {
	switch r {
	case RefusalNotTriaged:
		return "This patient has no triage record. Triage before deciding where they go."
	case RefusalSummaryUnsigned:
		return "The discharge summary is not signed. Sign it before discharging."
	case RefusalNoReceivingService:
		return "Name the service accepting the patient."
	case RefusalNoNote:
		return "This outcome needs an explanation in the record."
	case RefusalAlreadyDisposed:
		return "This visit already has a disposition."
	case RefusalUnknownOutcome:
		return "Choose where the patient is going."
	default:
		return string(r)
	}
}

// Dispose sets where the patient went, or says why it cannot (SRS-ER-013).
//
// Returns every refusal rather than the first. A clinician told one missing
// thing at a time is a clinician making three attempts at the same screen
// while a patient waits in a corridor.
func (v *Visit) Dispose(d Disposition, note, receivingService string,
	req DispositionRequirements, evidence DispositionEvidence, at time.Time) (
	[]DispositionRefusal, error) {

	var refusals []DispositionRefusal

	if v.Status == StatusDisposed {
		refusals = append(refusals, RefusalAlreadyDisposed)
	}
	if !knownDispositions[d] || d == DispositionUnknown {
		refusals = append(refusals, RefusalUnknownOutcome)
	}
	if req.NeedsTriage && !evidence.Triaged {
		refusals = append(refusals, RefusalNotTriaged)
	}
	if req.NeedsSignedSummary && !evidence.SummarySigned {
		refusals = append(refusals, RefusalSummaryUnsigned)
	}
	if req.NeedsReceivingService && strings.TrimSpace(receivingService) == "" {
		refusals = append(refusals, RefusalNoReceivingService)
	}
	if req.NeedsNote && strings.TrimSpace(note) == "" {
		refusals = append(refusals, RefusalNoNote)
	}

	if len(refusals) > 0 {
		return refusals, nil
	}

	v.Disposition = d
	v.Status = StatusDisposed
	v.DisposedAt = at.UTC()
	v.DispositionNote = strings.TrimSpace(note)
	v.ReceivingService = strings.TrimSpace(receivingService)
	v.UpdatedAt = at.UTC()
	return nil, nil
}

// LengthOfStay is how long the department had the patient, and whether that is
// settled.
//
// False while the visit is open: a running clock is not a length of stay, and
// reporting one as though it were understates every patient still waiting.
func (v Visit) LengthOfStay() (time.Duration, bool) {
	if v.Status != StatusDisposed || v.DisposedAt.IsZero() {
		return 0, false
	}
	return v.DisposedAt.Sub(v.ArrivedAt), true
}
