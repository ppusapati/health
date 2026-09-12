// Package domain holds the enterprise master patient index (SRS-EMPI).
//
// The central rule, and the reason this is a bounded context of its own rather
// than a table: the internal patient identifier is opaque, immutable and
// separate from every identifier a human ever sees (SRS-EMPI-002). An MRN is
// reassigned, corrected, superseded by a merge and printed on a wristband; a
// national health identifier is linked and unlinked. None of them may become
// the key that a clinical record points at, because every one of them can
// change, and a clinical record that follows a changing key follows it to the
// wrong patient.
//
// So: `Patient.ID` is minted once and never set again, and every human-facing
// identifier — MRN included — is an Identifier row with its own lifecycle.
//
// The second rule comes from the Wave-1 specification §7: the patient is not
// one giant aggregate. What lives here is identity — who this person is and
// what they are called. Encounters, orders and documents reference the patient
// id and are owned by their own contexts.
package domain

import (
	"errors"
	"fmt"
	"strings"
	"time"
)

// Status is the patient identity lifecycle (Wave-1 spec §6):
//
//	CANDIDATE -> ACTIVE -> MERGED / INACTIVE
type Status string

const (
	// StatusCandidate is a record created before identity was confirmed — an
	// unconscious admission, a pre-registration from a portal. It is a real
	// patient that can receive care; what it lacks is a confirmed identity.
	StatusCandidate Status = "candidate"
	// StatusActive is a confirmed identity.
	StatusActive Status = "active"
	// StatusMerged means this record lost a merge. It is never deleted: every
	// clinical record written against it still points here, and resolution to
	// the survivor is what makes those records readable.
	StatusMerged Status = "merged"
	// StatusInactive is a record withdrawn from routine use without being
	// merged — a duplicate that turned out to be a data-entry artefact with no
	// clinical content, or a record closed by a correction workflow.
	StatusInactive Status = "inactive"
)

// ErrInvalidPatient reports a patient that must not be stored.
var ErrInvalidPatient = errors.New("empi: invalid patient")

// ErrInvalidTransition reports a lifecycle move the state machine forbids.
var ErrInvalidTransition = errors.New("empi: invalid patient status transition")

// transitions is the closed state machine. Absence is a refusal, so a status
// added later without a rule for it cannot be reached.
var transitions = map[Status][]Status{
	StatusCandidate: {StatusActive, StatusMerged, StatusInactive},
	StatusActive:    {StatusMerged, StatusInactive},
	// A merged record can be restored by an unmerge (SRS-EMPI-006) and by
	// nothing else. It never goes straight back to active: the unmerge decides
	// which status it returns to, based on the merge journal.
	StatusMerged: {StatusActive, StatusCandidate},
	// Inactive is reversible: a record withdrawn in error is reinstated rather
	// than re-created, which would mint a second identity for one person.
	StatusInactive: {StatusActive, StatusCandidate},
}

// Patient is the identity aggregate.
type Patient struct {
	// ID is opaque, internal and immutable. Nothing outside this package can
	// set it after construction, and no workflow — merge included — changes it
	// (SRS-EMPI-002).
	id string

	TenantID string
	// RegisteredFacilityID is where the patient first presented. It scopes the
	// MRN sequence; it does not scope access, because a patient registered at
	// one site is treated at another.
	RegisteredFacilityID string

	Status       Status
	Demographics Demographics

	// MergedIntoPatientID is set only on a losing record, and is what resolves
	// a reference written before the merge.
	MergedIntoPatientID string

	// Deceased carries date and source when recorded (SRS-EMPI-008).
	Deceased *DeceasedRecord

	CreatedAt time.Time
	UpdatedAt time.Time
	// Version is the optimistic-concurrency token. Two clerks correcting the
	// same record at the same registration desk is routine.
	Version int64
}

// ID returns the immutable internal identifier.
//
// A getter rather than an exported field, so that a merge, a correction or a
// careless struct literal cannot reassign it. This is SRS-EMPI-002 expressed
// as a property of the type instead of a rule in a document.
func (p *Patient) ID() string { return p.id }

// NewPatient constructs a patient against the demographic policy in force.
//
// The policy is passed in rather than consulted here because what counts as a
// minimum demographic set is a jurisdiction and facility decision
// (SRS-EMPI-001): a government hospital in one state requires an identifier
// that a private clinic in another must not even ask for.
func NewPatient(id, tenantID, facilityID string, d Demographics,
	policy DemographicPolicy, now time.Time) (*Patient, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return nil, fmt.Errorf("%w: id is required", ErrInvalidPatient)
	case strings.TrimSpace(tenantID) == "":
		return nil, fmt.Errorf("%w: tenant is required", ErrInvalidPatient)
	case strings.TrimSpace(facilityID) == "":
		// The registering facility decides the MRN series, so a patient with
		// no facility has no defensible MRN.
		return nil, fmt.Errorf("%w: registering facility is required", ErrInvalidPatient)
	}

	normalised, err := d.Normalise()
	if err != nil {
		return nil, err
	}
	if err := policy.Check(normalised); err != nil {
		return nil, err
	}

	return &Patient{
		id:                   id,
		TenantID:             tenantID,
		RegisteredFacilityID: facilityID,
		// Candidate, not active. Identity is confirmed by a person who has
		// seen a document or the patient, and defaulting to active would make
		// "confirmed" the state nobody ever has to reach.
		Status:       StatusCandidate,
		Demographics: normalised,
		CreatedAt:    now.UTC(),
		UpdatedAt:    now.UTC(),
		Version:      1,
	}, nil
}

// Restore rebuilds a patient from storage.
//
// The repository needs to set the immutable id, and nothing else should be
// able to. Keeping this in the domain package — rather than exporting a
// settable field — means the only way to produce a Patient with a chosen id is
// to be reading one back.
func Restore(id string, p Patient) *Patient {
	p.id = id
	return &p
}

// TransitionTo moves the lifecycle forward.
func (p *Patient) TransitionTo(next Status, now time.Time) error {
	if p.Status == next {
		return nil
	}
	for _, allowed := range transitions[p.Status] {
		if allowed == next {
			p.Status = next
			p.touch(now)
			return nil
		}
	}
	return fmt.Errorf("%w: %s -> %s", ErrInvalidTransition, p.Status, next)
}

// Confirm marks an identity as verified against a positive identifier.
//
// Named for what a registration clerk does rather than as a status setter,
// because SRS-EMPI-010 will forbid confirming on a photograph alone and this
// is where that rule will land.
func (p *Patient) Confirm(now time.Time) error {
	return p.TransitionTo(StatusActive, now)
}

// IsResolvable reports whether this record should still be read directly.
// A merged record resolves to its survivor instead.
func (p *Patient) IsResolvable() bool { return p.Status != StatusMerged }

// AcceptsRoutineScheduling reports whether routine appointments may be booked.
//
// SRS-EMPI-008's verification is "new routine appointment warns/blocks per
// policy". The patient aggregate answers the factual half — this person is
// recorded as deceased — and scheduling owns the policy half. Putting the
// policy here would make the identity context depend on a scheduling decision
// it cannot see.
func (p *Patient) AcceptsRoutineScheduling() bool {
	return p.Deceased == nil && p.Status != StatusMerged
}

// UpdateDemographics applies a correction under the policy in force.
//
// It does not accept a new id, a new tenant or a new status: a demographic
// correction is exactly that, and widening it here is how a "correction"
// endpoint becomes a way to move a patient between tenants.
func (p *Patient) UpdateDemographics(d Demographics, policy DemographicPolicy, now time.Time) error {
	if p.Status == StatusMerged {
		// Editing the losing side of a merge writes to a record nobody reads.
		// The survivor is the record to correct.
		return fmt.Errorf("%w: %s is merged into %s", ErrInvalidPatient, p.id, p.MergedIntoPatientID)
	}

	normalised, err := d.Normalise()
	if err != nil {
		return err
	}
	if err := policy.Check(normalised); err != nil {
		return err
	}

	p.Demographics = normalised
	p.touch(now)
	return nil
}

func (p *Patient) touch(now time.Time) {
	p.UpdatedAt = now.UTC()
	p.Version++
}
