package domain

import (
	"sort"
	"strings"
	"time"
)

// Medication reconciliation (SRS-MED-005).
//
// The requirement asks for reconciliation "at admission, transfer and
// discharge", and its acceptance is that "each home medication has
// continue/stop/change/unknown disposition". The second half is the whole
// control. Reconciliation errors are not usually wrong decisions — they are
// medications nobody decided about, which continue by inertia through an
// admission and are still being taken a year later, or stop on admission and
// are never restarted. So a reconciliation cannot be completed while any
// medication has no disposition, and "unknown" is a disposition somebody chose
// rather than the absence of one.

// ReconciliationEvent is the point of care at which reconciliation happens.
type ReconciliationEvent string

const (
	ReconcileAdmission ReconciliationEvent = "admission"
	ReconcileTransfer  ReconciliationEvent = "transfer"
	ReconcileDischarge ReconciliationEvent = "discharge"
)

var knownReconciliationEvents = map[ReconciliationEvent]bool{
	ReconcileAdmission: true, ReconcileTransfer: true, ReconcileDischarge: true,
}

// Disposition is what was decided about one medication (SRS-MED-005).
type Disposition string

const (
	// DispositionPending is the absence of a decision. Never a valid completed
	// state — it exists so the list can be assembled before it is worked
	// through, and Complete refuses while any item is still here.
	DispositionPending  Disposition = "pending"
	DispositionContinue Disposition = "continue"
	DispositionStop     Disposition = "stop"
	// DispositionChange is continue-at-a-different-dose, which is a third
	// answer rather than a stop followed by a start: the patient has been on
	// this drug throughout, and a chart showing a gap would be wrong.
	DispositionChange Disposition = "change"
	// DispositionUnknown is an honest answer — the patient cannot remember the
	// dose and the GP surgery is shut. Recorded so that the gap is visible to
	// whoever reconciles next, rather than resolved by a guess.
	DispositionUnknown Disposition = "unknown"
)

var knownDispositions = map[Disposition]bool{
	DispositionPending: true, DispositionContinue: true, DispositionStop: true,
	DispositionChange: true, DispositionUnknown: true,
}

// Decided reports a disposition somebody actually chose.
func (d Disposition) Decided() bool {
	return knownDispositions[d] && d != DispositionPending
}

// HomeMedicationSource is where the list came from.
//
// Recorded because it is how much the list can be trusted: a printout from the
// GP system and a relative's recollection are both worth having and are not
// worth the same.
type HomeMedicationSource string

const (
	SourcePatient       HomeMedicationSource = "patient"
	SourceCarer         HomeMedicationSource = "carer"
	SourceGPRecord      HomeMedicationSource = "gp_record"
	SourcePharmacy      HomeMedicationSource = "pharmacy"
	SourcePreviousStay  HomeMedicationSource = "previous_stay"
	SourceMedicationBag HomeMedicationSource = "medication_bag"
)

var knownSources = map[HomeMedicationSource]bool{
	SourcePatient: true, SourceCarer: true, SourceGPRecord: true,
	SourcePharmacy: true, SourcePreviousStay: true, SourceMedicationBag: true,
}

// ReconciliationItem is one medication and what was decided about it.
type ReconciliationItem struct {
	// Sequence orders the list stably, so two people looking at the same
	// reconciliation see it in the same order.
	Sequence int
	// Medication is what the patient says they take.
	Medication Coding
	// DoseText is the dose as reported. Free text on purpose: this is what a
	// patient said in a corridor, and structuring it would claim a precision
	// nobody has. It becomes structured when a prescription is written from it.
	DoseText string
	Route    string
	Source   HomeMedicationSource

	Disposition Disposition
	// Rationale is why. Mandatory for stop and change, because those are the
	// two that surprise the next clinician to read the chart.
	Rationale string
	// ResultingPrescriptionID links a continued or changed medication to the
	// prescription that carries it forward, which is what makes the
	// reconciliation auditable rather than a form somebody filled in.
	ResultingPrescriptionID string

	DecidedBy string
	DecidedAt time.Time
}

// Reconciliation is one pass over a patient's medications (SRS-MED-005).
type Reconciliation struct {
	ID          string
	TenantID    string
	PatientID   string
	EncounterID string
	Event       ReconciliationEvent
	Items       []ReconciliationItem

	StartedBy string
	StartedAt time.Time
	// CompletedAt is set only once every item has a disposition.
	CompletedBy string
	CompletedAt time.Time

	UpdatedAt time.Time
	Version   int64
}

// NewReconciliation starts a pass (SRS-MED-005).
func NewReconciliation(id, tenantID, patientID, encounterID string,
	event ReconciliationEvent, items []ReconciliationItem,
	startedBy string, now time.Time) (*Reconciliation, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return nil, invalidf("a reconciliation needs an identifier")
	case strings.TrimSpace(patientID) == "":
		return nil, invalidf("a reconciliation needs a patient")
	case strings.TrimSpace(encounterID) == "":
		return nil, invalidf("a reconciliation needs an encounter")
	case !knownReconciliationEvents[event]:
		return nil, invalidf("unknown reconciliation event %q", event)
	case strings.TrimSpace(startedBy) == "":
		return nil, invalidf("a reconciliation needs the clinician doing it")
	}

	normalised := make([]ReconciliationItem, 0, len(items))
	for i, item := range items {
		if err := item.Medication.Validate(); err != nil {
			return nil, err
		}
		if !knownSources[item.Source] {
			// Where the list came from is how much it can be trusted, so it is
			// required rather than defaulted: a default would make every list
			// look equally reliable.
			return nil, invalidf("home medication %d must say where it came from", i+1)
		}
		if item.Disposition == "" {
			item.Disposition = DispositionPending
		}
		if !knownDispositions[item.Disposition] {
			return nil, invalidf("unknown disposition %q", item.Disposition)
		}
		item.Sequence = i + 1
		normalised = append(normalised, item)
	}

	return &Reconciliation{
		ID: id, TenantID: tenantID,
		PatientID: strings.TrimSpace(patientID), EncounterID: strings.TrimSpace(encounterID),
		Event: event, Items: normalised,
		StartedBy: strings.TrimSpace(startedBy), StartedAt: now.UTC(),
		UpdatedAt: now.UTC(), Version: 1,
	}, nil
}

// Decide records a disposition for one medication (SRS-MED-005).
func (r *Reconciliation) Decide(sequence int, d Disposition, rationale,
	resultingPrescriptionID, by string, now time.Time) error {

	if !r.CompletedAt.IsZero() {
		return notAllowedf("this reconciliation is already complete")
	}
	if !d.Decided() {
		return invalidf("%q is not a decision", d)
	}
	if strings.TrimSpace(by) == "" {
		return invalidf("a disposition needs the clinician deciding it")
	}
	if (d == DispositionStop || d == DispositionChange) &&
		strings.TrimSpace(rationale) == "" {
		// Stopping and changing are the two that surprise whoever reads the
		// chart next, and "why was my tablet stopped" is a question somebody
		// asks at every discharge.
		return invalidf("a %s disposition needs a rationale", d)
	}

	for i := range r.Items {
		if r.Items[i].Sequence != sequence {
			continue
		}
		r.Items[i].Disposition = d
		r.Items[i].Rationale = strings.TrimSpace(rationale)
		r.Items[i].ResultingPrescriptionID = strings.TrimSpace(resultingPrescriptionID)
		r.Items[i].DecidedBy = strings.TrimSpace(by)
		r.Items[i].DecidedAt = now.UTC()
		r.UpdatedAt = now.UTC()
		r.Version++
		return nil
	}
	return invalidf("no home medication numbered %d", sequence)
}

// Outstanding lists the medications still without a disposition.
//
// Returned rather than counted, because the answer a ward needs is which ones,
// and a count sends somebody back through the list to find them.
func (r *Reconciliation) Outstanding() []ReconciliationItem {
	var out []ReconciliationItem
	for _, item := range r.Items {
		if !item.Disposition.Decided() {
			out = append(out, item)
		}
	}
	sort.SliceStable(out, func(i, j int) bool { return out[i].Sequence < out[j].Sequence })
	return out
}

// Complete closes the pass (SRS-MED-005).
//
// Refused while anything is undecided, which is the acceptance criterion held
// at the domain rather than by a screen remembering to check. The refusal names
// what is outstanding, for the reason every other list-shaped refusal in this
// system does: a clinician told "something is missing" goes hunting.
func (r *Reconciliation) Complete(by string, now time.Time) error {
	if !r.CompletedAt.IsZero() {
		return nil
	}
	if strings.TrimSpace(by) == "" {
		return invalidf("completing a reconciliation needs the clinician doing it")
	}
	if outstanding := r.Outstanding(); len(outstanding) > 0 {
		return IncompleteReconciliation{Outstanding: outstanding}
	}

	r.CompletedBy = strings.TrimSpace(by)
	r.CompletedAt = now.UTC()
	r.UpdatedAt = now.UTC()
	r.Version++
	return nil
}

// IncompleteReconciliation names the medications nobody has decided about.
type IncompleteReconciliation struct {
	Outstanding []ReconciliationItem
}

func (e IncompleteReconciliation) Error() string {
	names := make([]string, 0, len(e.Outstanding))
	for _, item := range e.Outstanding {
		names = append(names, item.Medication.Display)
	}
	return "no disposition recorded for: " + strings.Join(names, ", ")
}

// Is lets errors.Is find the sentinel through a structured refusal.
func (e IncompleteReconciliation) Is(target error) bool { return target == ErrNotAllowed }
