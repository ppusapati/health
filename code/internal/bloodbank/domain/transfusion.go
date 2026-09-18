package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// RequestUrgency is how soon the blood is needed (SRS-BLD-006).
type RequestUrgency string

const (
	UrgencyRoutine RequestUrgency = "routine"
	UrgencyUrgent  RequestUrgency = "urgent"
	// UrgencyEmergency is the one that reaches SRS-BLD-016's uncrossmatched
	// release. Named here rather than as a separate flag, because a request
	// that is an emergency and a release that skips the crossmatch are the
	// same clinical situation seen from two desks.
	UrgencyEmergency RequestUrgency = "emergency"
)

var knownUrgencies = map[RequestUrgency]bool{
	UrgencyRoutine: true, UrgencyUrgent: true, UrgencyEmergency: true,
}

// RequestStatus is where a request has got to.
type RequestStatus string

const (
	RequestOpen      RequestStatus = "open"
	RequestFulfilled RequestStatus = "fulfilled"
	RequestCancelled RequestStatus = "cancelled"
)

// Request is a clinician's request for blood (SRS-BLD-006).
type Request struct {
	ID       string
	TenantID string

	PatientID   string
	EncounterID string
	FacilityID  string

	Class ComponentClass
	// Quantity is how many units. A request for "some blood" is one the blood
	// bank cannot plan around.
	Quantity int
	// Indication is why. Required, because SRS-BLD-015's utilisation report is
	// read to find transfusions that should not have happened, and a report
	// with no indications cannot.
	Indication string
	Urgency    RequestUrgency
	// Requirements are the special attributes: irradiated, CMV-negative. A
	// unit that does not carry them is not a match for this patient however
	// well the groups agree.
	Requirements []string
	// RequiredBy is when the blood is needed, which is what orders the blood
	// bank's worklist.
	RequiredBy time.Time

	Status      RequestStatus
	RequestedBy string
	RequestedAt time.Time
	Version     int64
}

// NewRequestInput is a request for blood.
type NewRequestInput struct {
	PatientID    string
	EncounterID  string
	FacilityID   string
	Class        ComponentClass
	Quantity     int
	Indication   string
	Urgency      RequestUrgency
	Requirements []string
	RequiredBy   time.Time
}

// NewRequest raises a request for blood (SRS-BLD-006).
func NewRequest(id, tenantID string, in NewRequestInput, by string,
	now time.Time) (Request, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Request{}, fmt.Errorf("%w: a request needs an id", ErrInvalidUnit)
	case strings.TrimSpace(in.PatientID) == "":
		return Request{}, fmt.Errorf("%w: a request names a patient", ErrInvalidUnit)
	case !knownClasses[in.Class]:
		return Request{}, fmt.Errorf("%w: unknown component type %q",
			ErrInvalidUnit, in.Class)
	case in.Quantity <= 0:
		return Request{}, fmt.Errorf("%w: a request says how many units",
			ErrInvalidUnit)
	case strings.TrimSpace(in.Indication) == "":
		// The one field a utilisation review cannot be done without.
		return Request{}, fmt.Errorf("%w: a request records the indication",
			ErrInvalidUnit)
	case strings.TrimSpace(by) == "":
		return Request{}, fmt.Errorf("%w: a request names who made it", ErrInvalidUnit)
	}

	urgency := in.Urgency
	if urgency == "" {
		// Routine, not emergency: a client that forgot the field must not have
		// its request jump the queue, and an emergency is never an omission.
		urgency = UrgencyRoutine
	}
	if !knownUrgencies[urgency] {
		return Request{}, fmt.Errorf("%w: unknown urgency %q", ErrInvalidUnit, urgency)
	}

	return Request{
		ID: id, TenantID: tenantID,
		PatientID:   strings.TrimSpace(in.PatientID),
		EncounterID: strings.TrimSpace(in.EncounterID),
		FacilityID:  strings.TrimSpace(in.FacilityID),
		Class:       in.Class, Quantity: in.Quantity,
		Indication: strings.TrimSpace(in.Indication), Urgency: urgency,
		Requirements: normalised(in.Requirements),
		RequiredBy:   in.RequiredBy.UTC(),
		Status:       RequestOpen,
		RequestedBy:  strings.TrimSpace(by), RequestedAt: now.UTC(),
		Version: 1,
	}, nil
}

// SampleStatus is whether the patient's grouping sample is usable
// (SRS-BLD-007).
type PatientSample struct {
	ID       string
	TenantID string

	PatientID string
	// SampleNumber is the identifier on the tube, which the crossmatch record
	// names. Two samples from the same patient are two chances to have bled
	// the wrong person.
	SampleNumber string
	Group        Group
	// AntibodyScreenPositive marks a patient with irregular antibodies, whose
	// units need more than an ABO and Rh match.
	AntibodyScreenPositive bool
	AntibodyNote           string

	// SecondCheck records the second, independently drawn sample most
	// protocols require before a first transfusion. Not enforced here — units
	// differ — but recorded, so a deployment that requires it can ask.
	SecondCheck bool

	CollectedAt time.Time
	CollectedBy string
	// ExpiresAt bounds the sample's validity. A sample older than the
	// deployment's window cannot support a crossmatch: the patient may have
	// been transfused since and formed new antibodies.
	ExpiresAt time.Time
	TestedAt  time.Time
	TestedBy  string
}

// Valid reports a sample that may still support a crossmatch.
func (s PatientSample) Valid(now time.Time) bool {
	return s.Group.Known() && !s.ExpiresAt.IsZero() && now.Before(s.ExpiresAt)
}

// NewSampleInput is a patient grouping sample.
type NewSampleInput struct {
	PatientID              string
	SampleNumber           string
	Group                  Group
	AntibodyScreenPositive bool
	AntibodyNote           string
	SecondCheck            bool
	CollectedAt            time.Time
	CollectedBy            string
	ValidFor               time.Duration
}

// DefaultSampleValidity is how long a grouping sample supports a crossmatch
// when a deployment has not said.
//
// Three days is the common protocol for a patient who has been transfused or
// pregnant in the last three months, which in a hospital is most of them.
const DefaultSampleValidity = 72 * time.Hour

// RecordSample records a patient's group and antibody screen (SRS-BLD-007).
func RecordSample(id, tenantID string, in NewSampleInput, by string,
	now time.Time) (PatientSample, error) {

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(in.PatientID) == "":
		return PatientSample{}, fmt.Errorf("%w: a sample belongs to a patient",
			ErrInvalidUnit)
	case strings.TrimSpace(in.SampleNumber) == "":
		// The identifier on the tube. Without it, a sample cannot be matched
		// back to the draw, and "we bled the wrong patient" is unanswerable.
		return PatientSample{}, fmt.Errorf("%w: a sample needs a sample number",
			ErrInvalidUnit)
	case !in.Group.Known():
		return PatientSample{}, fmt.Errorf(
			"%w: a grouping sample records the ABO and Rh group", ErrInvalidUnit)
	case strings.TrimSpace(by) == "":
		return PatientSample{}, fmt.Errorf("%w: a sample names who tested it",
			ErrInvalidUnit)
	}

	validity := in.ValidFor
	if validity <= 0 {
		validity = DefaultSampleValidity
	}
	collected := in.CollectedAt
	if collected.IsZero() {
		collected = now
	}

	return PatientSample{
		ID: id, TenantID: tenantID,
		PatientID:              strings.TrimSpace(in.PatientID),
		SampleNumber:           strings.TrimSpace(in.SampleNumber),
		Group:                  in.Group,
		AntibodyScreenPositive: in.AntibodyScreenPositive,
		AntibodyNote:           strings.TrimSpace(in.AntibodyNote),
		SecondCheck:            in.SecondCheck,
		CollectedAt:            collected.UTC(),
		CollectedBy:            strings.TrimSpace(in.CollectedBy),
		ExpiresAt:              collected.Add(validity).UTC(),
		TestedAt:               now.UTC(),
		TestedBy:               strings.TrimSpace(by),
	}, nil
}

// MatchRefusal is why a unit may not be reserved for a patient
// (SRS-BLD-007, SRS-BLD-008).
type MatchRefusal string

const (
	RefusalUnitNotAllocatable MatchRefusal = "unit_not_allocatable"
	RefusalUnitExpired        MatchRefusal = "unit_expired"
	RefusalNoSample           MatchRefusal = "no_valid_sample"
	RefusalGroupIncompatible  MatchRefusal = "group_incompatible"
	RefusalWrongComponent     MatchRefusal = "wrong_component_type"
	RefusalMissingAttribute   MatchRefusal = "missing_special_requirement"
	RefusalCrossmatchReactive MatchRefusal = "crossmatch_reactive"
)

// Explain renders a refusal for somebody who has to act on it.
func (r MatchRefusal) Explain() string {
	switch r {
	case RefusalUnitNotAllocatable:
		return "This unit is not available for allocation."
	case RefusalUnitExpired:
		return "This unit has expired."
	case RefusalNoSample:
		return "This patient has no valid grouping sample."
	case RefusalGroupIncompatible:
		return "This unit's group is not compatible with the patient's."
	case RefusalWrongComponent:
		return "This unit is not the component that was requested."
	case RefusalMissingAttribute:
		return "This unit does not carry a special requirement the request names."
	case RefusalCrossmatchReactive:
		return "The crossmatch was reactive."
	default:
		return string(r)
	}
}

// MatchDecision is whether a unit may be reserved for a patient.
type MatchDecision struct {
	// Refusals are every reason, not the first. A scientist told one at a time
	// pulls a second unit from the fridge to be told the next.
	Refusals []MatchRefusal
	// Explanations are the same, in words.
	Explanations []string
}

// Allowed reports a match with nothing against it.
func (d MatchDecision) Allowed() bool { return len(d.Refusals) == 0 }

func (d *MatchDecision) refuse(reason MatchRefusal) {
	d.Refusals = append(d.Refusals, reason)
	d.Explanations = append(d.Explanations, reason.Explain())
}

// EvaluateMatch decides whether a unit may be reserved for a request
// (SRS-BLD-007, SRS-BLD-008).
//
// Every check, every time, and all the refusals together. The serological
// crossmatch itself is a bench result recorded separately; what this holds is
// the set of conditions that make a crossmatch worth running at all.
func EvaluateMatch(unit Component, request Request, sample PatientSample,
	now time.Time) MatchDecision {

	out := MatchDecision{}

	if !unit.Status.Allocatable() {
		out.refuse(RefusalUnitNotAllocatable)
	}
	if unit.Expired(now) {
		out.refuse(RefusalUnitExpired)
	}
	if unit.Class != request.Class {
		out.refuse(RefusalWrongComponent)
	}
	if !sample.Valid(now) || sample.PatientID != request.PatientID {
		// No valid sample means no known recipient group, so the compatibility
		// check below would be comparing against nothing. Both are reported:
		// "incompatible" alone would send somebody looking for other blood
		// when what is needed is another tube.
		out.refuse(RefusalNoSample)
	}
	if !CompatibleGroups(request.Class, unit.Group, sample.Group) {
		out.refuse(RefusalGroupIncompatible)
	}
	for _, requirement := range request.Requirements {
		if !unit.Has(requirement) {
			out.refuse(RefusalMissingAttribute)
			break
		}
	}
	return out
}

// ReservationStatus is where a reservation has got to (SRS-BLD-008).
type ReservationStatus string

const (
	ReservationHeld     ReservationStatus = "held"
	ReservationIssued   ReservationStatus = "issued"
	ReservationReleased ReservationStatus = "released"
	ReservationExpired  ReservationStatus = "expired"
)

// DefaultReservationWindow is how long a crossmatched unit is held.
//
// Reservations expire because blood held for a patient who did not need it is
// blood the next patient could not have. Two days is the usual surgical
// reservation.
const DefaultReservationWindow = 48 * time.Hour

// Reservation holds a unit for a patient (SRS-BLD-008).
type Reservation struct {
	ID       string
	TenantID string

	ComponentID string
	RequestID   string
	PatientID   string
	SampleID    string

	// Crossmatched marks a serological crossmatch actually performed, as
	// distinct from an electronic issue. SRS-BLD-016's emergency release is
	// the case where this is false and the unit goes anyway.
	Crossmatched   bool
	CrossmatchNote string

	Status    ReservationStatus
	ExpiresAt time.Time

	ReservedAt time.Time
	ReservedBy string
	// ReleasedReason says why a reservation ended without an issue, which is
	// what tells a utilisation report the difference between blood that was
	// never needed and blood that was given.
	ReleasedReason string
}

// Active reports a reservation still holding the unit.
func (r Reservation) Active(now time.Time) bool {
	return r.Status == ReservationHeld && now.Before(r.ExpiresAt)
}

// NewReservationInput holds a unit for a patient.
type NewReservationInput struct {
	ComponentID    string
	RequestID      string
	PatientID      string
	SampleID       string
	Crossmatched   bool
	CrossmatchNote string
	HoldFor        time.Duration
}

// Reserve holds a unit for a patient (SRS-BLD-008).
//
// The decision is passed in rather than recomputed, so that the one place
// which decides compatibility is EvaluateMatch and a caller cannot reserve by
// skipping it.
func Reserve(id, tenantID string, in NewReservationInput,
	decision MatchDecision, by string, now time.Time) (Reservation, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Reservation{}, fmt.Errorf("%w: a reservation needs an id",
			ErrInvalidUnit)
	case strings.TrimSpace(in.ComponentID) == "" ||
		strings.TrimSpace(in.PatientID) == "":
		return Reservation{}, fmt.Errorf("%w: a reservation names a unit and a patient",
			ErrInvalidUnit)
	case strings.TrimSpace(by) == "":
		return Reservation{}, fmt.Errorf("%w: a reservation names who made it",
			ErrInvalidUnit)
	case !decision.Allowed():
		return Reservation{}, fmt.Errorf("%w: %s", ErrInvalidUnit,
			strings.Join(decision.Explanations, " "))
	}

	window := in.HoldFor
	if window <= 0 {
		window = DefaultReservationWindow
	}

	return Reservation{
		ID: id, TenantID: tenantID,
		ComponentID:    strings.TrimSpace(in.ComponentID),
		RequestID:      strings.TrimSpace(in.RequestID),
		PatientID:      strings.TrimSpace(in.PatientID),
		SampleID:       strings.TrimSpace(in.SampleID),
		Crossmatched:   in.Crossmatched,
		CrossmatchNote: strings.TrimSpace(in.CrossmatchNote),
		Status:         ReservationHeld,
		ExpiresAt:      now.Add(window).UTC(),
		ReservedAt:     now.UTC(), ReservedBy: strings.TrimSpace(by),
	}, nil
}

// Issue is a unit leaving the blood bank (SRS-BLD-009).
type Issue struct {
	ID       string
	TenantID string

	ComponentID   string
	ReservationID string
	PatientID     string
	RequestID     string

	// Destination is where the unit went — a ward, a theatre, a fridge on a
	// ward. Required, because a unit that left with no destination is one
	// nobody can go and fetch back.
	Destination string

	// Emergency marks an uncrossmatched release (SRS-BLD-016).
	Emergency           bool
	EmergencyAuthoriser string
	EmergencyReason     string
	// Reconciled marks an emergency release whose retrospective crossmatch has
	// been completed. The requirement's clause is "explicitly flagged and
	// later reconciled", and an unreconciled release is the thing a
	// haemovigilance report exists to surface.
	Reconciled    bool
	ReconciledAt  time.Time
	ReconciledBy  string
	ReconcileNote string

	IssuedAt time.Time
	IssuedBy string
	// IssuedTo is the person who collected it, which is the other half of the
	// chain of custody.
	IssuedTo string
}

// IssueCheck is the final identity verification before a unit leaves
// (SRS-BLD-009).
//
// Passed in rather than assumed: the requirement's clause is "issue component
// only after final identity/compatibility checks", and a system where the
// check is implicit is a system where it did not happen.
type IssueCheck struct {
	// UnitNumber and PatientID as read from the unit and the request at the
	// counter. Compared against the record rather than trusted.
	UnitNumber string
	PatientID  string
	CheckedBy  string
}

// NewIssueInput is a unit leaving the blood bank.
type NewIssueInput struct {
	ComponentID   string
	ReservationID string
	RequestID     string
	Destination   string
	IssuedTo      string
	Check         IssueCheck

	// Emergency and its authorisation, for SRS-BLD-016.
	Emergency           bool
	EmergencyAuthoriser string
	EmergencyReason     string
}

// IssueComponent releases a unit from the blood bank (SRS-BLD-009,
// SRS-BLD-016).
//
// Two paths, one function, because they must not diverge. The ordinary path
// needs an active reservation. The emergency path does not — that is what
// makes it an emergency — but it needs a named senior authoriser and a reason,
// and it is flagged so the reconciliation SRS-BLD-016 asks for has something
// to find.
func IssueComponent(id, tenantID string, in NewIssueInput, unit Component,
	reservation *Reservation, by string, now time.Time) (Issue, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Issue{}, fmt.Errorf("%w: an issue needs an id", ErrInvalidUnit)
	case strings.TrimSpace(in.Destination) == "":
		return Issue{}, fmt.Errorf("%w: an issue records where the unit went",
			ErrInvalidUnit)
	case strings.TrimSpace(by) == "":
		return Issue{}, fmt.Errorf("%w: an issue names who released it",
			ErrInvalidUnit)
	case strings.TrimSpace(in.Check.CheckedBy) == "":
		return Issue{}, fmt.Errorf(
			"%w: an issue records who made the final identity check",
			ErrInvalidUnit)
	}

	// The final check, against the record rather than against itself.
	if in.Check.UnitNumber != unit.UnitNumber {
		return Issue{}, fmt.Errorf(
			"%w: the unit number checked at issue (%s) is not this unit (%s)",
			ErrInvalidUnit, in.Check.UnitNumber, unit.UnitNumber)
	}
	if unit.Expired(now) {
		return Issue{}, fmt.Errorf("%w: this unit expired on %s",
			ErrInvalidUnit, unit.ExpiresAt.Format(time.RFC3339))
	}

	out := Issue{
		ID: id, TenantID: tenantID,
		ComponentID: unit.ID,
		RequestID:   strings.TrimSpace(in.RequestID),
		Destination: strings.TrimSpace(in.Destination),
		IssuedAt:    now.UTC(), IssuedBy: strings.TrimSpace(by),
		IssuedTo: strings.TrimSpace(in.IssuedTo),
	}

	if in.Emergency {
		switch {
		case strings.TrimSpace(in.EmergencyAuthoriser) == "":
			return Issue{}, fmt.Errorf(
				"%w: an emergency release names the senior clinician who authorised it",
				ErrInvalidUnit)
		case strings.TrimSpace(in.EmergencyReason) == "":
			return Issue{}, fmt.Errorf("%w: an emergency release records why",
				ErrInvalidUnit)
		case unit.Status != UnitAvailable && unit.Status != UnitReserved:
			// Even an emergency does not reach a quarantined or discarded
			// unit. Untested blood is not safer than no blood, and this is the
			// one place where the pressure to say yes is highest.
			return Issue{}, fmt.Errorf(
				"%w: an emergency release still does not reach a %s unit",
				ErrInvalidUnit, unit.Status)
		}
		out.Emergency = true
		out.EmergencyAuthoriser = strings.TrimSpace(in.EmergencyAuthoriser)
		out.EmergencyReason = strings.TrimSpace(in.EmergencyReason)
		out.PatientID = strings.TrimSpace(in.Check.PatientID)
		return out, nil
	}

	switch {
	case reservation == nil:
		return Issue{}, fmt.Errorf(
			"%w: a unit is issued against a reservation, or as an authorised "+
				"emergency release", ErrInvalidUnit)
	case !reservation.Active(now):
		return Issue{}, fmt.Errorf("%w: that reservation is %s",
			ErrInvalidUnit, reservation.Status)
	case reservation.ComponentID != unit.ID:
		return Issue{}, fmt.Errorf("%w: that reservation is for a different unit",
			ErrInvalidUnit)
	case in.Check.PatientID != reservation.PatientID:
		return Issue{}, fmt.Errorf(
			"%w: the patient checked at issue is not the patient this unit is "+
				"reserved for", ErrInvalidUnit)
	}

	out.ReservationID = reservation.ID
	out.PatientID = reservation.PatientID
	return out, nil
}

// Reconcile completes an emergency release's retrospective crossmatch
// (SRS-BLD-016).
func (i *Issue) Reconcile(note, by string, now time.Time) error {
	switch {
	case !i.Emergency:
		return fmt.Errorf("%w: only an emergency release is reconciled",
			ErrInvalidUnit)
	case i.Reconciled:
		return fmt.Errorf("%w: this release has already been reconciled",
			ErrInvalidUnit)
	case strings.TrimSpace(note) == "":
		return fmt.Errorf("%w: reconciliation records the retrospective result",
			ErrInvalidUnit)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: reconciliation names who did it", ErrInvalidUnit)
	}
	i.Reconciled, i.ReconcileNote = true, strings.TrimSpace(note)
	i.ReconciledAt, i.ReconciledBy = now.UTC(), strings.TrimSpace(by)
	return nil
}

// BedsideCheck is the positive identification at the patient's side
// (SRS-BLD-010).
//
// Two people and three identifiers, compared against the record. The
// requirement's clause is that a mismatch "blocks digital completion and
// generates critical exception", so a mismatch here is not a warning: the
// transfusion cannot be started, and somebody is told.
type BedsideCheck struct {
	// UnitNumber and PatientID as read aloud at the bedside from the unit and
	// the patient's wristband.
	UnitNumber string
	PatientID  string
	// PatientGroup and UnitGroup as read from the labels, which is a different
	// check from the one the database can do: it catches a label that does not
	// match the record.
	PatientGroup Group
	UnitGroup    Group

	// Two checkers, because one person checking alone is the commonest root
	// cause in every published wrong-blood incident.
	CheckedBy   string
	CheckedWith string
}

// BedsideRefusal is why a bedside check failed (SRS-BLD-010).
type BedsideRefusal string

const (
	BedsideWrongUnit     BedsideRefusal = "unit_is_not_the_one_issued"
	BedsideWrongPatient  BedsideRefusal = "patient_is_not_the_recipient"
	BedsideGroupMismatch BedsideRefusal = "label_group_does_not_match_the_record"
	BedsideSoloCheck     BedsideRefusal = "only_one_person_checked"
	BedsideUnitExpired   BedsideRefusal = "unit_expired"
	BedsideNotIssued     BedsideRefusal = "unit_was_not_issued_for_this_patient"
)

// Explain renders a bedside refusal.
func (r BedsideRefusal) Explain() string {
	switch r {
	case BedsideWrongUnit:
		return "The unit at the bedside is not the unit that was issued."
	case BedsideWrongPatient:
		return "The patient at the bedside is not the patient this unit was issued for."
	case BedsideGroupMismatch:
		return "The group on the label does not match the group on the record."
	case BedsideSoloCheck:
		return "A bedside check needs two people."
	case BedsideUnitExpired:
		return "This unit has expired."
	case BedsideNotIssued:
		return "This unit has not been issued for this patient."
	default:
		return string(r)
	}
}

// VerifyBedside runs the pre-transfusion identity check (SRS-BLD-010).
//
// Returns every failure. A nurse told "wrong patient" who then discovers the
// unit is also expired has been through the check twice, at a bedside, with a
// patient waiting.
func VerifyBedside(check BedsideCheck, unit Component, issue Issue,
	now time.Time) []BedsideRefusal {

	var out []BedsideRefusal

	if strings.TrimSpace(check.CheckedBy) == "" ||
		strings.TrimSpace(check.CheckedWith) == "" ||
		strings.EqualFold(check.CheckedBy, check.CheckedWith) {
		out = append(out, BedsideSoloCheck)
	}
	if check.UnitNumber != unit.UnitNumber {
		out = append(out, BedsideWrongUnit)
	}
	if issue.ComponentID != unit.ID {
		out = append(out, BedsideNotIssued)
	}
	if issue.PatientID == "" || check.PatientID != issue.PatientID {
		out = append(out, BedsideWrongPatient)
	}
	// The labels against the record. This is the check that catches a unit
	// relabelled by hand or a patient whose group was corrected after issue.
	if check.UnitGroup != unit.Group {
		out = append(out, BedsideGroupMismatch)
	}
	if unit.Expired(now) {
		out = append(out, BedsideUnitExpired)
	}

	sort.Slice(out, func(i, j int) bool { return out[i] < out[j] })
	return out
}
