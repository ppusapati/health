// Package domain holds the ambulance and fleet rules (SRS-AMB-001 … 008).
//
// Nothing here reaches a database, a clock or a transport (FIT-01). Every
// refusal is a value a caller can act on rather than a panic.
//
// Three properties run through the package and are worth stating once.
//
// A vehicle that is not ready is not dispatched. SRS-AMB-002 and SRS-AMB-006
// both say it, from different ends: an unavailable vehicle or crew cannot be
// assigned without an override, and a missing critical readiness item blocks
// the ready state or requires one. The override is one thing here rather than
// two flags: a named person, a reason, and an escalation, because an
// ambulance sent out without oxygen is a decision somebody has to be able to
// point at afterwards.
//
// A trip's timeline is append-only and monotonic. SRS-AMB-003's acceptance is
// that it is complete and auditable, and a timeline somebody can rewrite is
// one nobody can audit. Milestones are recorded in order, a milestone already
// recorded is not recorded again, and a correction is an amendment that keeps
// what it corrected.
//
// And the location feed is a record of where patients were collected from.
// SRS-AMB-005 asks for it to be permissioned and retention-configurable, and
// the reason is that a map of an ambulance's day is a list of the addresses
// somebody was ill at. A ping carries no patient identifier — the link is
// through the trip — it is readable only under its own permission, and every
// ping carries the moment it stops being kept.
package domain

import (
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"
)

// ErrInvalidAmbulance reports a refused ambulance action.
var ErrInvalidAmbulance = errors.New("ambulance: invalid")

// VehicleKind is what an ambulance can do (SRS-AMB-002).
type VehicleKind string

const (
	// VehicleALS is advanced life support: a paramedic crew, a monitor, a
	// defibrillator and drugs.
	VehicleALS VehicleKind = "als"
	// VehicleBLS is basic life support.
	VehicleBLS VehicleKind = "bls"
	// VehicleTransport carries a stable patient between sites and is not a
	// response vehicle.
	VehicleTransport VehicleKind = "transport"
	// VehicleNeonatal is an incubator transport.
	VehicleNeonatal VehicleKind = "neonatal"
)

var knownVehicleKind = map[VehicleKind]bool{
	VehicleALS: true, VehicleBLS: true,
	VehicleTransport: true, VehicleNeonatal: true,
}

// Responds reports the kinds that answer an emergency call. A patient
// transport van sent to a cardiac arrest is a van with no defibrillator in
// it.
func (k VehicleKind) Responds() bool {
	return k == VehicleALS || k == VehicleBLS || k == VehicleNeonatal
}

// VehicleState is where a vehicle stands (SRS-AMB-002).
type VehicleState string

const (
	// VehicleOutOfService is off the run: maintenance, repair, or not
	// staffed.
	VehicleOutOfService VehicleState = "out_of_service"
	// VehicleAvailable is checked, crewed and at base.
	VehicleAvailable VehicleState = "available"
	// VehicleOnTrip is out on a job.
	VehicleOnTrip VehicleState = "on_trip"
	// VehicleRetired is sold or scrapped. Kept, because the trips it ran
	// are still trips.
	VehicleRetired VehicleState = "retired"
)

// Assignable reports a vehicle a dispatcher may send without an override
// (SRS-AMB-002).
func (s VehicleState) Assignable() bool { return s == VehicleAvailable }

// Vehicle is one ambulance (SRS-AMB-002).
type Vehicle struct {
	ID       string
	TenantID string

	// Registration is the number plate. Unique within a tenant: two
	// vehicles answering to one plate is a trip belonging to neither.
	Registration string
	CallSign     string
	Kind         VehicleKind
	FacilityID   string
	// BaseID is where it stands when it is not out.
	BaseID string

	// Capabilities are what it carries that a request can ask for:
	// "ventilator", "incubator", "bariatric". Free text on purpose — a
	// fixed list would be a list some hospital's vehicle does not fit.
	Capabilities []string

	State VehicleState
	// ReadyUntil is when the current readiness check expires. A vehicle
	// whose check has lapsed is not ready, without anybody having to change
	// its state: a stored "ready" that nothing expires is a vehicle that
	// was checked once in March.
	ReadyUntil time.Time
	// OutOfServiceReason is why it is off the run.
	OutOfServiceReason string

	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// NewVehicleInput registers an ambulance.
type NewVehicleInput struct {
	Registration string
	CallSign     string
	Kind         VehicleKind
	FacilityID   string
	BaseID       string
	Capabilities []string
}

// NewVehicle registers an ambulance (SRS-AMB-002).
//
// It starts out of service. A vehicle that appeared on the board as available
// the moment somebody typed its plate is a vehicle a dispatcher can send
// before anybody has looked inside it.
func NewVehicle(id, tenantID string, in NewVehicleInput, by string,
	now time.Time) (Vehicle, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Vehicle{}, fmt.Errorf("%w: a vehicle needs an id",
			ErrInvalidAmbulance)
	case strings.TrimSpace(in.Registration) == "":
		return Vehicle{}, fmt.Errorf("%w: a vehicle needs its registration",
			ErrInvalidAmbulance)
	case !knownVehicleKind[in.Kind]:
		return Vehicle{}, fmt.Errorf("%w: unknown vehicle kind %q",
			ErrInvalidAmbulance, in.Kind)
	case strings.TrimSpace(by) == "":
		return Vehicle{}, fmt.Errorf("%w: a vehicle names who registered it",
			ErrInvalidAmbulance)
	}

	return Vehicle{
		ID: id, TenantID: tenantID,
		Registration: strings.TrimSpace(in.Registration),
		CallSign:     strings.TrimSpace(in.CallSign),
		Kind:         in.Kind, FacilityID: in.FacilityID,
		BaseID:             strings.TrimSpace(in.BaseID),
		Capabilities:       normalise(in.Capabilities),
		State:              VehicleOutOfService,
		OutOfServiceReason: "newly registered; not yet checked",
		CreatedAt:          now.UTC(), CreatedBy: by, Version: 1,
	}, nil
}

// Ready reports a vehicle whose readiness check is still in date
// (SRS-AMB-006).
//
// Derived from the expiry rather than stored as a flag, so a check that
// lapsed overnight makes the vehicle unready without anybody remembering to
// say so.
func (v Vehicle) Ready(at time.Time) bool {
	return !v.ReadyUntil.IsZero() && at.Before(v.ReadyUntil)
}

// GoAvailable puts a vehicle on the run (SRS-AMB-002, SRS-AMB-006).
//
// Only on the back of a passed readiness check. The check is passed in rather
// than trusted: a vehicle marked available by somebody who did not look in it
// is the whole of what SRS-AMB-006 exists to prevent.
func (v *Vehicle) GoAvailable(check ReadinessCheck, now time.Time) error {
	switch {
	case v.State == VehicleRetired:
		return fmt.Errorf("%w: this vehicle is retired",
			ErrInvalidAmbulance)
	case v.State == VehicleOnTrip:
		return fmt.Errorf("%w: this vehicle is out on a trip",
			ErrInvalidAmbulance)
	case check.VehicleID != v.ID:
		return fmt.Errorf("%w: that readiness check is for vehicle %s",
			ErrInvalidAmbulance, check.VehicleID)
	case !check.Passed():
		return fmt.Errorf(
			"%w: the readiness check is %s; a vehicle goes on the run on a "+
				"passed check", ErrInvalidAmbulance, check.State)
	case !check.ValidUntil.After(now):
		return fmt.Errorf("%w: that readiness check has expired",
			ErrInvalidAmbulance)
	}

	v.State = VehicleAvailable
	v.ReadyUntil = check.ValidUntil
	v.OutOfServiceReason = ""
	return nil
}

// GoOutOfService takes a vehicle off the run (SRS-AMB-002).
func (v *Vehicle) GoOutOfService(reason string) error {
	switch {
	case v.State == VehicleRetired:
		return fmt.Errorf("%w: this vehicle is retired",
			ErrInvalidAmbulance)
	case strings.TrimSpace(reason) == "":
		// A vehicle off the run for no recorded reason is one nobody can
		// chase back on.
		return fmt.Errorf("%w: say why the vehicle is off the run",
			ErrInvalidAmbulance)
	}
	v.State = VehicleOutOfService
	v.OutOfServiceReason = strings.TrimSpace(reason)
	v.ReadyUntil = time.Time{}
	return nil
}

// Retire takes a vehicle off the fleet for good (SRS-AMB-002).
func (v *Vehicle) Retire(reason string) error {
	switch {
	case v.State == VehicleRetired:
		return fmt.Errorf("%w: this vehicle is already retired",
			ErrInvalidAmbulance)
	case v.State == VehicleOnTrip:
		return fmt.Errorf("%w: this vehicle is out on a trip",
			ErrInvalidAmbulance)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say why the vehicle is being retired",
			ErrInvalidAmbulance)
	}
	v.State = VehicleRetired
	v.OutOfServiceReason = strings.TrimSpace(reason)
	v.ReadyUntil = time.Time{}
	return nil
}

// CrewRole is what somebody on the vehicle is qualified to do
// (SRS-AMB-002).
type CrewRole string

const (
	CrewDriver    CrewRole = "driver"
	CrewEMT       CrewRole = "emt"
	CrewParamedic CrewRole = "paramedic"
	CrewNurse     CrewRole = "nurse"
	CrewDoctor    CrewRole = "doctor"
)

var knownCrewRole = map[CrewRole]bool{
	CrewDriver: true, CrewEMT: true, CrewParamedic: true,
	CrewNurse: true, CrewDoctor: true,
}

// Clinical reports the roles that may give a prehospital intervention
// (SRS-AMB-004).
//
// A driver is not one of them. That is not about competence — plenty of
// drivers are trained — it is that the person recorded as having given a drug
// has to be somebody the service says may give it.
func (r CrewRole) Clinical() bool {
	return r == CrewEMT || r == CrewParamedic || r == CrewNurse ||
		r == CrewDoctor
}

// CrewMember is one person rostered to a vehicle (SRS-AMB-002).
type CrewMember struct {
	SubjectID string
	Name      string
	Role      CrewRole
	// RegistrationNumber is their professional registration where the role
	// has one. Carried so a prehospital record names a registrant rather
	// than a login.
	RegistrationNumber string
}

// ShiftState is where a crew shift stands (SRS-AMB-002).
type ShiftState string

const (
	ShiftPlanned ShiftState = "planned"
	ShiftOnDuty  ShiftState = "on_duty"
	ShiftEnded   ShiftState = "ended"
)

// Shift is a crew on a vehicle for a period (SRS-AMB-002).
type Shift struct {
	ID       string
	TenantID string

	VehicleID  string
	FacilityID string
	Crew       []CrewMember

	State ShiftState

	StartsAt time.Time
	EndsAt   time.Time
	// StartedAt and EndedAt are when it actually began and finished, which
	// is not the same as when it was rostered to.
	StartedAt time.Time
	EndedAt   time.Time

	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// NewShiftInput rosters a crew.
type NewShiftInput struct {
	VehicleID  string
	FacilityID string
	Crew       []CrewMember
	StartsAt   time.Time
	EndsAt     time.Time
}

// NewShift rosters a crew onto a vehicle (SRS-AMB-002).
func NewShift(id, tenantID string, in NewShiftInput, by string,
	now time.Time) (Shift, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Shift{}, fmt.Errorf("%w: a shift needs an id",
			ErrInvalidAmbulance)
	case strings.TrimSpace(in.VehicleID) == "":
		return Shift{}, fmt.Errorf("%w: a shift names its vehicle",
			ErrInvalidAmbulance)
	case in.StartsAt.IsZero() || in.EndsAt.IsZero():
		return Shift{}, fmt.Errorf("%w: a shift says when it runs",
			ErrInvalidAmbulance)
	case !in.EndsAt.After(in.StartsAt):
		return Shift{}, fmt.Errorf("%w: a shift ends after it starts",
			ErrInvalidAmbulance)
	case len(in.Crew) == 0:
		// A vehicle with nobody on it is a vehicle a dispatcher can send.
		return Shift{}, fmt.Errorf("%w: a shift names its crew",
			ErrInvalidAmbulance)
	}

	crew := make([]CrewMember, 0, len(in.Crew))
	seen := map[string]bool{}
	for _, member := range in.Crew {
		subject := strings.TrimSpace(member.SubjectID)
		switch {
		case subject == "":
			return Shift{}, fmt.Errorf("%w: a crew member needs an id",
				ErrInvalidAmbulance)
		case !knownCrewRole[member.Role]:
			return Shift{}, fmt.Errorf("%w: unknown crew role %q",
				ErrInvalidAmbulance, member.Role)
		case seen[subject]:
			// One person twice is a crew of two that is really a crew of
			// one, and a vehicle that looks staffed.
			return Shift{}, fmt.Errorf("%w: %s appears on the crew twice",
				ErrInvalidAmbulance, subject)
		}
		seen[subject] = true
		crew = append(crew, CrewMember{
			SubjectID: subject, Name: strings.TrimSpace(member.Name),
			Role: member.Role,
			RegistrationNumber: strings.TrimSpace(
				member.RegistrationNumber),
		})
	}

	return Shift{
		ID: id, TenantID: tenantID,
		VehicleID:  strings.TrimSpace(in.VehicleID),
		FacilityID: in.FacilityID, Crew: crew,
		State:    ShiftPlanned,
		StartsAt: in.StartsAt.UTC(), EndsAt: in.EndsAt.UTC(),
		CreatedAt: now.UTC(), CreatedBy: by, Version: 1,
	}, nil
}

// Start brings a shift on duty (SRS-AMB-002).
func (s *Shift) Start(now time.Time) error {
	if s.State != ShiftPlanned {
		return fmt.Errorf("%w: this shift is %s",
			ErrInvalidAmbulance, s.State)
	}
	s.State = ShiftOnDuty
	s.StartedAt = now.UTC()
	return nil
}

// End takes a shift off duty (SRS-AMB-002).
func (s *Shift) End(now time.Time) error {
	if s.State != ShiftOnDuty {
		return fmt.Errorf("%w: this shift is %s",
			ErrInvalidAmbulance, s.State)
	}
	s.State = ShiftEnded
	s.EndedAt = now.UTC()
	return nil
}

// OnDuty reports a shift covering a moment (SRS-AMB-002).
func (s Shift) OnDuty(at time.Time) bool {
	return s.State == ShiftOnDuty && !at.Before(s.StartsAt) &&
		at.Before(s.EndsAt)
}

// Clinician finds a crew member qualified to give an intervention
// (SRS-AMB-004).
func (s Shift) Clinician(subjectID string) (CrewMember, bool) {
	for _, member := range s.Crew {
		if member.SubjectID == subjectID && member.Role.Clinical() {
			return member, true
		}
	}
	return CrewMember{}, false
}

// ShiftForVehicle picks the shift on duty for a vehicle (SRS-AMB-002).
//
// One, never a list: two crews on one ambulance is a vehicle whose
// prehospital record names whichever the reader opened.
func ShiftForVehicle(shifts []Shift, vehicleID string, at time.Time) (Shift,
	bool) {

	var best Shift
	found := false
	for _, shift := range shifts {
		if shift.VehicleID != vehicleID || !shift.OnDuty(at) {
			continue
		}
		if !found || shift.StartsAt.After(best.StartsAt) {
			best, found = shift, true
		}
	}
	return best, found
}

func normalise(in []string) []string {
	out := make([]string, 0, len(in))
	seen := map[string]bool{}
	for _, value := range in {
		trimmed := strings.TrimSpace(value)
		if trimmed == "" || seen[strings.ToLower(trimmed)] {
			continue
		}
		seen[strings.ToLower(trimmed)] = true
		out = append(out, trimmed)
	}
	sort.Strings(out)
	return out
}

func utcOrZero(t time.Time) time.Time {
	if t.IsZero() {
		return time.Time{}
	}
	return t.UTC()
}
