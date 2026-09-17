// Package domain holds the critical-care rules (SRS-ICU-001 … 018).
//
// No infrastructure: the rules here are the ones a consultant would recognise
// as the unit's, and they are testable without a database (FIT-01).
package domain

import (
	"errors"
	"fmt"
	"strings"
	"time"
)

// ErrInvalidEpisode refuses a critical-care record that could not be true.
var ErrInvalidEpisode = errors.New("icu: invalid")

// AdmissionSource is where the patient came from (SRS-ICU-001).
//
// Recorded rather than derived, because the provenance of an ICU admission is
// a quality measure in its own right: an unplanned admission from a ward is a
// deterioration somebody may have missed, and one from theatre is a planned
// post-operative bed. A system that called both "admission" would report a
// unit that never deteriorates anybody.
type AdmissionSource string

const (
	AdmissionUnspecified AdmissionSource = ""
	AdmissionEmergency   AdmissionSource = "emergency"
	AdmissionWard        AdmissionSource = "ward"
	AdmissionTheatre     AdmissionSource = "theatre"
	AdmissionOtherICU    AdmissionSource = "other_icu"
	// AdmissionExternal is a transfer in from another hospital.
	AdmissionExternal AdmissionSource = "external"
	AdmissionDirect   AdmissionSource = "direct"
)

var knownAdmissionSources = map[AdmissionSource]bool{
	AdmissionEmergency: true, AdmissionWard: true, AdmissionTheatre: true,
	AdmissionOtherICU: true, AdmissionExternal: true, AdmissionDirect: true,
}

// EpisodeStatus is where the episode is.
type EpisodeStatus string

const (
	EpisodeOpen EpisodeStatus = "open"
	// EpisodeReadyForTransfer is a decision, not a state the unit drifts into:
	// somebody has said this patient no longer needs critical care, and the
	// bed pressure that follows is answerable to them (SRS-ICU-016).
	EpisodeReadyForTransfer EpisodeStatus = "ready_for_transfer"
	EpisodeClosed           EpisodeStatus = "closed"
)

// Open reports whether the episode still accepts content.
func (s EpisodeStatus) Open() bool {
	return s == EpisodeOpen || s == EpisodeReadyForTransfer
}

// Outcome is how the episode ended.
type Outcome string

const (
	OutcomeUnspecified Outcome = ""
	OutcomeWard        Outcome = "ward"
	OutcomeOtherICU    Outcome = "other_icu"
	OutcomeTheatre     Outcome = "theatre"
	OutcomeExternal    Outcome = "external_transfer"
	OutcomeDischarge   Outcome = "discharge"
	OutcomeDeath       Outcome = "death"
)

var knownOutcomes = map[Outcome]bool{
	OutcomeWard: true, OutcomeOtherICU: true, OutcomeTheatre: true,
	OutcomeExternal: true, OutcomeDischarge: true, OutcomeDeath: true,
}

// Episode is one stay in critical care (SRS-ICU-001).
//
// It hangs off a Wave-1 encounter rather than replacing one. The patient, the
// allergies and the inpatient admission belong to the encounter; what is here
// is the critical-care detail, and a unit holding its own copy of the patient
// is a unit whose chart disagrees with the ward's.
type Episode struct {
	ID       string
	TenantID string

	EncounterID string
	PatientID   string
	FacilityID  string
	// UnitID is the critical-care unit — general ICU, cardiac, neuro. A
	// hospital's units are its own, so this is an identifier rather than an
	// enumeration.
	UnitID string
	// BedID is where the patient physically is. Occupancy is counted from it
	// (SRS-ICU-017), so it is required: a critical-care episode with no bed is
	// a bed the unit cannot account for.
	BedID string

	Source AdmissionSource
	// TransferredFrom names the episode this one continues, where a patient
	// moved between units. The provenance clause of SRS-ICU-001: a
	// twelve-hour stay that is the second half of a five-day one is not a
	// twelve-hour stay.
	TransferredFrom string

	// ResponsibleTeam is the ICU team, and ResponsibleClinician the named
	// intensivist. Both, because a team is who to call and a person is who
	// decided.
	ResponsibleTeam      string
	ResponsibleClinician string

	Status     EpisodeStatus
	AdmittedAt time.Time
	// ReadyAt is when the patient was declared fit to leave. The gap between
	// it and DischargedAt is the unit's discharge delay, which is the number
	// that explains a full unit better than its admissions do.
	ReadyAt      time.Time
	DischargedAt time.Time
	Outcome      Outcome
	OutcomeNote  string

	CreatedBy string
	CreatedAt time.Time
	UpdatedAt time.Time
	Version   int64
}

// NewEpisodeInput is what admitting to critical care needs.
type NewEpisodeInput struct {
	EncounterID     string
	PatientID       string
	FacilityID      string
	UnitID          string
	BedID           string
	Source          AdmissionSource
	TransferredFrom string

	ResponsibleTeam      string
	ResponsibleClinician string

	AdmittedAt time.Time
}

// NewEpisode admits a patient to critical care (SRS-ICU-001).
func NewEpisode(id, tenantID string, in NewEpisodeInput, createdBy string,
	now time.Time) (Episode, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Episode{}, fmt.Errorf("%w: an episode needs an id", ErrInvalidEpisode)
	case strings.TrimSpace(in.EncounterID) == "":
		return Episode{}, fmt.Errorf(
			"%w: a critical-care episode is the detail of an encounter", ErrInvalidEpisode)
	case strings.TrimSpace(in.PatientID) == "":
		return Episode{}, fmt.Errorf("%w: an episode names a patient", ErrInvalidEpisode)
	case strings.TrimSpace(in.UnitID) == "":
		return Episode{}, fmt.Errorf("%w: an episode names a unit", ErrInvalidEpisode)
	case strings.TrimSpace(in.BedID) == "":
		// Occupancy and device days are counted from the bed. An episode with
		// none is one the unit's own numbers cannot see.
		return Episode{}, fmt.Errorf("%w: an episode names a bed", ErrInvalidEpisode)
	case strings.TrimSpace(createdBy) == "":
		return Episode{}, fmt.Errorf("%w: an admission names who made it", ErrInvalidEpisode)
	}

	source := in.Source
	if source == AdmissionUnspecified {
		return Episode{}, fmt.Errorf(
			"%w: record where the patient came from; an unplanned ward "+
				"admission and a planned post-operative bed are different events",
			ErrInvalidEpisode)
	}
	if !knownAdmissionSources[source] {
		return Episode{}, fmt.Errorf("%w: unknown admission source %q",
			ErrInvalidEpisode, source)
	}
	// A transfer names what it continues. Without it the second episode looks
	// like a short stay and the first like a patient who improved.
	if source == AdmissionOtherICU && strings.TrimSpace(in.TransferredFrom) == "" {
		return Episode{}, fmt.Errorf(
			"%w: a transfer between units names the episode it continues",
			ErrInvalidEpisode)
	}

	admitted := in.AdmittedAt
	if admitted.IsZero() {
		admitted = now
	}

	return Episode{
		ID: id, TenantID: tenantID,
		EncounterID: strings.TrimSpace(in.EncounterID),
		PatientID:   strings.TrimSpace(in.PatientID),
		FacilityID:  strings.TrimSpace(in.FacilityID),
		UnitID:      strings.TrimSpace(in.UnitID),
		BedID:       strings.TrimSpace(in.BedID),
		Source:      source, TransferredFrom: strings.TrimSpace(in.TransferredFrom),
		ResponsibleTeam:      strings.TrimSpace(in.ResponsibleTeam),
		ResponsibleClinician: strings.TrimSpace(in.ResponsibleClinician),
		Status:               EpisodeOpen,
		AdmittedAt:           admitted.UTC(),
		CreatedBy:            createdBy,
		CreatedAt:            now.UTC(),
		UpdatedAt:            now.UTC(),
		// A freshly admitted episode is at version 1, the same as the row the
		// adapter writes. A zero here would make the first update look stale.
		Version: 1,
	}, nil
}

// Move records a bed change within the unit.
func (e *Episode) Move(bedID string, at time.Time) error {
	if !e.Status.Open() {
		return fmt.Errorf("%w: this episode is closed", ErrInvalidEpisode)
	}
	if strings.TrimSpace(bedID) == "" {
		return fmt.Errorf("%w: a move names a bed", ErrInvalidEpisode)
	}
	e.BedID, e.UpdatedAt = strings.TrimSpace(bedID), at.UTC()
	return nil
}

// HandoverRequirement is one thing that must be settled before the patient
// leaves (SRS-ICU-016).
type HandoverRequirement string

const (
	// HandoverMedications is the drug chart the receiving ward inherits,
	// including what is still running.
	HandoverMedications HandoverRequirement = "medications"
	// HandoverDevices is every line, tube and drain still in the patient. The
	// commonest thing lost at transfer, and the one that becomes an infection
	// three days later on a ward that did not know it was there.
	HandoverDevices HandoverRequirement = "devices"
	// HandoverTasks is what is outstanding — a result to chase, a review due.
	HandoverTasks HandoverRequirement = "tasks"
	// HandoverSummary is the written handover itself.
	HandoverSummary HandoverRequirement = "summary"
)

// HandoverEvidence is what the episode can show at the moment of transfer.
type HandoverEvidence struct {
	MedicationsReconciled bool
	DevicesListed         bool
	TasksHandedOver       bool
	SummaryWritten        bool
}

// Outstanding returns every requirement the evidence does not meet.
//
// Every one at once, for the reason the emergency department's disposition
// gate returns all of its refusals: a nurse told one missing thing at a time
// makes four attempts at the same screen while a bed is needed.
func (h HandoverEvidence) Outstanding() []HandoverRequirement {
	var out []HandoverRequirement
	if !h.MedicationsReconciled {
		out = append(out, HandoverMedications)
	}
	if !h.DevicesListed {
		out = append(out, HandoverDevices)
	}
	if !h.TasksHandedOver {
		out = append(out, HandoverTasks)
	}
	if !h.SummaryWritten {
		out = append(out, HandoverSummary)
	}
	return out
}

// Explain says what to do about an outstanding requirement.
func (r HandoverRequirement) Explain() string {
	switch r {
	case HandoverMedications:
		return "Reconcile the drug chart, including infusions still running."
	case HandoverDevices:
		return "List every line, tube and drain still in the patient."
	case HandoverTasks:
		return "Hand over what is outstanding: results to chase, reviews due."
	case HandoverSummary:
		return "Write the transfer summary."
	default:
		return string(r)
	}
}

// DeclareReady says the patient no longer needs critical care (SRS-ICU-016).
//
// A state of its own rather than a flag on the discharge, because the interval
// it opens is the measurement: a unit whose patients wait eleven hours for a
// ward bed is a different problem from one that is genuinely full.
func (e *Episode) DeclareReady(at time.Time) error {
	switch {
	case e.Status == EpisodeClosed:
		return fmt.Errorf("%w: this episode is closed", ErrInvalidEpisode)
	case e.Status == EpisodeReadyForTransfer:
		// Idempotent: the first declaration is the one the clock runs from,
		// and a second click must not restart it.
		return nil
	}
	e.Status, e.ReadyAt, e.UpdatedAt = EpisodeReadyForTransfer, at.UTC(), at.UTC()
	return nil
}

// Discharge closes the episode (SRS-ICU-016, SRS-ICU-017).
//
// Returns the handover requirements still outstanding rather than an error:
// the caller shows them all, and a transfer that is genuinely urgent is a
// decision somebody makes with the list in front of them.
func (e *Episode) Discharge(outcome Outcome, note string, evidence HandoverEvidence,
	at time.Time) ([]HandoverRequirement, error) {

	if e.Status == EpisodeClosed {
		return nil, fmt.Errorf("%w: this episode is already closed", ErrInvalidEpisode)
	}
	if !knownOutcomes[outcome] {
		return nil, fmt.Errorf("%w: unknown outcome %q", ErrInvalidEpisode, outcome)
	}
	if at.Before(e.AdmittedAt) {
		return nil, fmt.Errorf("%w: discharge precedes admission", ErrInvalidEpisode)
	}

	// Death is not gated on paperwork. A unit that could not record a death
	// until four checklists were complete would record it late, and the time
	// of death is the one timestamp nobody may reconstruct.
	if outcome != OutcomeDeath {
		if outstanding := evidence.Outstanding(); len(outstanding) > 0 {
			return outstanding, nil
		}
	}

	e.Status = EpisodeClosed
	e.Outcome = outcome
	e.OutcomeNote = strings.TrimSpace(note)
	e.DischargedAt = at.UTC()
	e.UpdatedAt = at.UTC()
	return nil, nil
}

// LengthOfStay reports how long the episode lasted (SRS-ICU-017).
//
// False while the episode is open, for the reason the emergency visit's is:
// a running stay has no length, and returning the elapsed time would put a
// number in a report that changes every time it is run.
func (e Episode) LengthOfStay() (time.Duration, bool) {
	if e.Status != EpisodeClosed || e.DischargedAt.IsZero() {
		return 0, false
	}
	return e.DischargedAt.Sub(e.AdmittedAt), true
}

// DischargeDelay is how long the patient waited after being declared ready.
func (e Episode) DischargeDelay() (time.Duration, bool) {
	if e.ReadyAt.IsZero() || e.DischargedAt.IsZero() {
		return 0, false
	}
	return e.DischargedAt.Sub(e.ReadyAt), true
}

// OccupiedOn reports whether the episode held a bed on a given day.
//
// Half-open on purpose: a patient admitted and discharged the same day
// occupied a bed that day, and one discharged at 08:00 did not occupy it for
// the rest of it. Bed-day counting that got this wrong would report an
// occupancy above 100%, which is how a unit ends up arguing about its own
// numbers instead of its beds.
func (e Episode) OccupiedOn(day time.Time) bool {
	start := day.UTC().Truncate(24 * time.Hour)
	end := start.Add(24 * time.Hour)
	if e.AdmittedAt.After(end) || e.AdmittedAt.Equal(end) {
		return false
	}
	if e.DischargedAt.IsZero() {
		return true
	}
	return e.DischargedAt.After(start)
}
