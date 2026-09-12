package domain

import (
	"fmt"
	"strings"
	"time"
)

// Emergency registration of an unidentified patient (SRS-EMPI-015).
//
// An unconscious patient arrives by ambulance. Care starts in minutes and
// generates records — observations, imaging, a transfusion — every one of which
// has to attach to something. The alternative to registering them is not "wait
// until we know who they are"; it is notes on paper that never reach the chart,
// or a record created under a guessed name that becomes a duplicate the moment
// the real one is found.
//
// So the record is created immediately, with a designation instead of a name,
// and reconciled later. Two properties make the reconciliation safe:
//
// The internal identifier never changes (SRS-EMPI-002). Everything written
// during the resuscitation points at it, so identifying the patient an hour
// later is a demographic update, not a data migration — and the requirement's
// "without losing encounter chronology" falls out of that rather than needing
// machinery of its own.
//
// The record is visibly temporary. A designation that could be mistaken for a
// name is how "Unknown Male" becomes a patient with forty encounters spanning
// four people.

// TemporaryDesignation is the placeholder an unidentified patient is known by.
//
// Deliberately not a HumanName. A name field holding "UNKNOWN MALE" sorts into
// the name index, matches other unknowns on a fuzzy comparison, and prints on a
// wristband looking exactly like a name. Keeping it a separate type means every
// place that displays a patient has to decide what to do with it.
type TemporaryDesignation struct {
	// Label is what staff say out loud and what prints on the band — for
	// example "TRAUMA ALPHA" or "UNKNOWN 0417". Site convention, not this
	// system's invention.
	Label string
	// ApparentSex is what a clinician records at the bedside, which is an
	// observation rather than a claim about identity. Frequently wrong and
	// still worth recording: a lab needs a reference range before anybody
	// knows who this is.
	ApparentSex Sex
	// ApparentAge in years, estimated. Zero means nobody estimated one.
	ApparentAge int
	// Circumstance is the free-text peg staff actually use to find the record
	// again — "road traffic collision, brought in by ambulance 14". Short, and
	// deliberately not structured: an enumeration of ways people arrive
	// unconscious would be wrong within a week.
	Circumstance string
}

// MaxCircumstanceLength bounds the free-text peg. Long enough for a sentence,
// short enough that a handover note cannot be pasted into it.
const MaxCircumstanceLength = 200

// MaxApparentAge guards against an estimate that is obviously a typo.
const MaxApparentAge = 130

// Validate rejects a designation that could not be used.
func (d TemporaryDesignation) Validate() error {
	label := strings.TrimSpace(d.Label)
	switch {
	case label == "":
		// Without a label there is nothing to call the patient, and staff
		// invent one — on paper, inconsistently.
		return fmt.Errorf("%w: an unidentified patient needs a label staff can use", ErrInvalidPatient)
	case len(label) > maxFieldLength:
		return fmt.Errorf("%w: the label is too long to print", ErrInvalidPatient)
	case d.ApparentSex != "" && !knownSexes[d.ApparentSex]:
		return fmt.Errorf("%w: unknown apparent sex %q", ErrInvalidPatient, d.ApparentSex)
	case d.ApparentAge < 0 || d.ApparentAge > MaxApparentAge:
		return fmt.Errorf("%w: an apparent age of %d is not an estimate", ErrInvalidPatient, d.ApparentAge)
	case len(d.Circumstance) > MaxCircumstanceLength:
		return fmt.Errorf("%w: the circumstance note is longer than %d characters",
			ErrInvalidPatient, MaxCircumstanceLength)
	}
	return nil
}

// Demographics renders what little is known, for matching and for display.
//
// The label does NOT become the family name. It goes nowhere near the name
// index: a record called "TRAUMA ALPHA" that fuzzy-matches the next trauma
// patient is how two people end up sharing a chart, which is the exact outcome
// the matcher exists to prevent.
//
// The apparent age becomes an estimated birth date, because that is what the
// matcher can use and what the precision model already marks as weak.
func (d TemporaryDesignation) Demographics(now time.Time) Demographics {
	out := Demographics{Sex: d.ApparentSex}
	if out.Sex == "" {
		out.Sex = SexUnknown
	}
	if d.ApparentAge > 0 {
		out.BirthDate = BirthDate{
			Date:      time.Date(now.Year()-d.ApparentAge, 1, 1, 0, 0, 0, 0, time.UTC),
			Precision: PrecisionEstimated,
		}
	}
	return out
}

// NewUnidentifiedPatient creates the record an emergency admission writes
// against.
//
// Status is candidate, like any unconfirmed identity. The difference from an
// ordinary candidate is the designation: this record is known to be a
// placeholder, and identifying it later is expected rather than exceptional.
func NewUnidentifiedPatient(id, tenantID, facilityID string, d TemporaryDesignation,
	p DemographicPolicy, now time.Time) (*Patient, error) {

	if !p.PermitsUnidentified() {
		// The facility has said it does not register unidentified patients.
		// Refusing here rather than silently creating one keeps the policy
		// meaningful; the clerk is told which policy refused them.
		return nil, fmt.Errorf("%w: %s does not permit unidentified registration",
			ErrInvalidPatient, p.Jurisdiction)
	}
	if err := d.Validate(); err != nil {
		return nil, err
	}

	// The policy is passed through with its required set emptied rather than
	// bypassed: NewPatient still applies every other rule it knows, and only
	// the minimum set — the one thing an unconscious patient cannot supply —
	// is relaxed.
	relaxed := p
	relaxed.Required = nil

	patient, err := NewPatient(id, tenantID, facilityID, d.Demographics(now), relaxed, now)
	if err != nil {
		return nil, err
	}
	patient.Designation = &d
	return patient, nil
}

// Identify replaces a temporary designation with real demographics
// (SRS-EMPI-015).
//
// The patient id does not change, so everything written during the emergency
// still points here — which is what "without losing encounter chronology"
// means in practice. The designation is kept rather than cleared: an hour of
// records was filed under it, and somebody reading them later needs to know
// what the ward was calling this person at the time.
func (p *Patient) Identify(d Demographics, policy DemographicPolicy, now time.Time) error {
	if p.Designation == nil {
		return fmt.Errorf("%w: patient %s was not registered as unidentified", ErrInvalidPatient, p.id)
	}
	if p.Status == StatusMerged {
		return fmt.Errorf("%w: patient %s was merged; identify the survivor", ErrInvalidPatient, p.id)
	}

	// The full policy applies now. Emergency registration relaxes the minimum
	// set because nothing was known; naming the patient is the moment that
	// stops being true, and a record that stays below the minimum after
	// identification is one nobody will be able to match later.
	if err := policy.Check(d); err != nil {
		return err
	}
	if err := p.UpdateDemographics(d, policy, now); err != nil {
		return err
	}

	p.IdentifiedAt = &now
	// Still a candidate: knowing a name is not the same as having checked an
	// identifier, and SRS-EMPI-010 turns on that distinction. ConfirmIdentity
	// is a separate act with its own evidence.
	return nil
}

// IsUnidentified reports a patient whose identity is still unknown.
func (p *Patient) IsUnidentified() bool {
	return p.Designation != nil && p.IdentifiedAt == nil
}
