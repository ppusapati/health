package domain

import (
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/platform/rpcerr"
)

// The bed and room master (SRS-PLT-006, and the location levels of
// SRS-PLT-002's hierarchy).
//
// Three contexts shipped before this existed — critical care, infection
// control and housekeeping all hold a bed_id as free text — so each of them
// has its own idea of what a bed is and none of them can say what a bed
// costs, who may occupy it, or whether it is fit to use. This is the one
// record they can all resolve against.
//
// The shape is a class catalogue, rooms that reference a class, and beds
// inside rooms:
//
//	BedClass  — what a bed of this kind is, and what it is charged as
//	Room      — the physical space, its gender policy and isolation capability
//	Bed       — the physical bed, and separately whether it can be used
//
// Class sits on the room rather than the bed because a class is a tariff and
// two beds in one room at two tariffs is a billing dispute waiting to be had.
// A bed's charge is its room's, derived on read, so the two cannot disagree.

// BedClass is a tenant's own category of accommodation, and the charge that
// goes with it (SRS-PLT-006's charge mapping).
//
// A catalogue rather than an enumeration: "deluxe", "twin sharing" and
// "general ward" are commercial decisions a hospital makes, not something this
// system can list in advance. What it can insist on is that each one names the
// charge it maps to, because a class that maps to nothing is a bed nobody can
// bill for.
type BedClass struct {
	ID       string
	TenantID string

	// Code is the key. It appears in billing, in tariff imports and on
	// printed estimates, so it is stable and the display name is not
	// (SRS-PLT-007).
	Code        string
	DisplayName string

	// ChargeCode is what billing raises the accommodation charge against.
	// Required: this field is the requirement's "charge mapping", and an
	// empty one silently produces a free stay.
	ChargeCode string

	Status    MasterStatus
	CreatedAt time.Time
	UpdatedAt time.Time
	Version   int64
}

// MasterStatus is the lifecycle shared by the masters here. Retirement is
// terminal and deletion does not exist, because SRS-PLT-015 forbids removing a
// master something already references.
type MasterStatus string

const (
	MasterActive  MasterStatus = "active"
	MasterRetired MasterStatus = "retired"
)

// GenderPolicy is who a room may be occupied by (SRS-PLT-006).
//
// A capability of the room, not a description of who is in it. A male patient
// in a female bay is an admission somebody should not have been able to make;
// it is not a room that has changed sex.
type GenderPolicy string

const (
	GenderAny    GenderPolicy = "any"
	GenderMale   GenderPolicy = "male_only"
	GenderFemale GenderPolicy = "female_only"
)

var validGenderPolicies = map[GenderPolicy]bool{
	GenderAny: true, GenderMale: true, GenderFemale: true,
}

// IsolationCapability is what a room can safely contain (SRS-PLT-006).
//
// Ordered, and deliberately so: a room that can hold an airborne case can hold
// a droplet one. Infection control asks "where can I put this patient", and a
// list with no order cannot answer it.
type IsolationCapability string

const (
	IsolationNone     IsolationCapability = "none"
	IsolationContact  IsolationCapability = "contact"
	IsolationDroplet  IsolationCapability = "droplet"
	IsolationAirborne IsolationCapability = "airborne"
)

var isolationRank = map[IsolationCapability]int{
	IsolationNone: 0, IsolationContact: 1, IsolationDroplet: 2, IsolationAirborne: 3,
}

// Contains reports whether a room of this capability can hold a case needing
// the given precautions.
func (c IsolationCapability) Contains(needed IsolationCapability) bool {
	return isolationRank[c] >= isolationRank[needed]
}

// Room is a physical space that holds beds (SRS-PLT-002, SRS-PLT-006).
type Room struct {
	ID       string
	TenantID string

	FacilityID string
	// UnitID is the ward or department the room belongs to, which is the
	// org-unit level above it in the hierarchy.
	UnitID string

	Code        string
	DisplayName string

	// ClassCode is the accommodation class every bed in this room is charged
	// at. Held by code rather than by id so a tariff import can name it.
	ClassCode string

	GenderPolicy GenderPolicy
	Isolation    IsolationCapability

	Status    MasterStatus
	CreatedAt time.Time
	UpdatedAt time.Time
	Version   int64
}

// BedAvailability is whether a bed can be used right now (SRS-PLT-006).
//
// This is the requirement's verification clause: bed status is controlled
// independently of physical existence. A bed that is blocked still exists and
// still belongs to its room; a bed that is retired is gone from the estate and
// has no availability at all. Conflating the two gives you a hospital that
// loses a bed permanently because somebody took it out of service to fix a
// castor.
type BedAvailability string

const (
	BedAvailable    BedAvailability = "available"
	BedOccupied     BedAvailability = "occupied"
	BedCleaning     BedAvailability = "cleaning"
	BedBlocked      BedAvailability = "blocked"
	BedOutOfService BedAvailability = "out_of_service"
)

var validAvailability = map[BedAvailability]bool{
	BedAvailable: true, BedOccupied: true, BedCleaning: true,
	BedBlocked: true, BedOutOfService: true,
}

// needsReason are the states somebody has to justify. Occupancy and cleaning
// are recorded by the systems that cause them; blocking and taking a bed out
// of service are decisions, and a decision with no reason cannot be reviewed.
var needsReason = map[BedAvailability]bool{
	BedBlocked: true, BedOutOfService: true,
}

// Bed is one physical bed (SRS-PLT-006).
type Bed struct {
	ID       string
	TenantID string

	RoomID string
	// FacilityID is denormalised from the room so that a bed can be listed
	// and scoped by facility without joining, and so the database can hold
	// the rule that a bed and its room are in the same facility.
	FacilityID string

	Code        string
	DisplayName string

	// Status is physical existence: planned, in the estate, or gone.
	Status MasterStatus
	// Availability is whether it can be used, which moves many times a day
	// and has nothing to do with whether the bed exists.
	Availability BedAvailability
	// UnavailableReason is why, for the states that are somebody's decision.
	UnavailableReason string

	CreatedAt time.Time
	UpdatedAt time.Time
	Version   int64
}

// NewBedClassInput describes a class.
type NewBedClassInput struct {
	Code        string
	DisplayName string
	ChargeCode  string
}

// NewBedClass creates an accommodation class (SRS-PLT-006).
func NewBedClass(id, tenantID string, in NewBedClassInput, now time.Time) (
	BedClass, error) {

	code := strings.ToUpper(strings.TrimSpace(in.Code))
	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(tenantID) == "":
		return BedClass{}, invalidMaster("a class needs an id and a tenant")
	case !facilityCodePattern.MatchString(code):
		return BedClass{}, invalidMaster(
			"a class code is upper-case letters, digits, hyphen or underscore")
	case strings.TrimSpace(in.DisplayName) == "":
		return BedClass{}, invalidMaster("a class needs a display name")
	case strings.TrimSpace(in.ChargeCode) == "":
		// The requirement's charge mapping. Without it the class describes an
		// accommodation nobody can raise a charge for, which is the defect
		// this field exists to prevent rather than a configuration somebody
		// might reasonably want.
		return BedClass{}, invalidMaster(
			"a class names the charge it is billed as")
	}

	return BedClass{
		ID: id, TenantID: tenantID,
		Code: code, DisplayName: strings.TrimSpace(in.DisplayName),
		ChargeCode: strings.TrimSpace(in.ChargeCode),
		Status:     MasterActive,
		CreatedAt:  now.UTC(), UpdatedAt: now.UTC(), Version: 1,
	}, nil
}

// NewRoomInput describes a room.
type NewRoomInput struct {
	FacilityID   string
	UnitID       string
	Code         string
	DisplayName  string
	ClassCode    string
	GenderPolicy GenderPolicy
	Isolation    IsolationCapability
}

// NewRoom creates a room (SRS-PLT-002, SRS-PLT-006).
func NewRoom(id, tenantID string, in NewRoomInput, now time.Time) (Room, error) {
	code := strings.ToUpper(strings.TrimSpace(in.Code))
	policy := in.GenderPolicy
	if policy == "" {
		policy = GenderAny
	}
	isolation := in.Isolation
	if isolation == "" {
		isolation = IsolationNone
	}

	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(tenantID) == "":
		return Room{}, invalidMaster("a room needs an id and a tenant")
	case strings.TrimSpace(in.FacilityID) == "":
		return Room{}, invalidMaster("a room belongs to a facility")
	case strings.TrimSpace(in.UnitID) == "":
		// The ward. Without it a room floats between the hierarchy's facility
		// level and its beds, and no ward can list the beds it is responsible
		// for.
		return Room{}, invalidMaster("a room belongs to a ward or department")
	case !facilityCodePattern.MatchString(code):
		return Room{}, invalidMaster(
			"a room code is upper-case letters, digits, hyphen or underscore")
	case strings.TrimSpace(in.ClassCode) == "":
		return Room{}, invalidMaster("a room names its accommodation class")
	case !validGenderPolicies[policy]:
		return Room{}, invalidMaster("unknown gender policy " + string(policy))
	case isolationRank[isolation] == 0 && isolation != IsolationNone:
		return Room{}, invalidMaster(
			"unknown isolation capability " + string(isolation))
	}

	name := strings.TrimSpace(in.DisplayName)
	if name == "" {
		name = code
	}
	return Room{
		ID: id, TenantID: tenantID,
		FacilityID: strings.TrimSpace(in.FacilityID),
		UnitID:     strings.TrimSpace(in.UnitID),
		Code:       code, DisplayName: name,
		ClassCode:    strings.ToUpper(strings.TrimSpace(in.ClassCode)),
		GenderPolicy: policy, Isolation: isolation,
		Status:    MasterActive,
		CreatedAt: now.UTC(), UpdatedAt: now.UTC(), Version: 1,
	}, nil
}

// NewBedInput describes a bed.
type NewBedInput struct {
	RoomID      string
	FacilityID  string
	Code        string
	DisplayName string
}

// NewBed creates a bed (SRS-PLT-006).
//
// It starts available. A bed that has just been built is not in use, and
// starting it out of service would make every new bed need a second call
// before the ward could use it.
func NewBed(id, tenantID string, in NewBedInput, now time.Time) (Bed, error) {
	code := strings.ToUpper(strings.TrimSpace(in.Code))
	switch {
	case strings.TrimSpace(id) == "" || strings.TrimSpace(tenantID) == "":
		return Bed{}, invalidMaster("a bed needs an id and a tenant")
	case strings.TrimSpace(in.RoomID) == "":
		return Bed{}, invalidMaster("a bed belongs to a room")
	case strings.TrimSpace(in.FacilityID) == "":
		return Bed{}, invalidMaster("a bed belongs to a facility")
	case !facilityCodePattern.MatchString(code):
		return Bed{}, invalidMaster(
			"a bed code is upper-case letters, digits, hyphen or underscore")
	}

	name := strings.TrimSpace(in.DisplayName)
	if name == "" {
		name = code
	}
	return Bed{
		ID: id, TenantID: tenantID,
		RoomID:     strings.TrimSpace(in.RoomID),
		FacilityID: strings.TrimSpace(in.FacilityID),
		Code:       code, DisplayName: name,
		Status: MasterActive, Availability: BedAvailable,
		CreatedAt: now.UTC(), UpdatedAt: now.UTC(), Version: 1,
	}, nil
}

// SetAvailability moves a bed between usable and not (SRS-PLT-006).
//
// This is the half of the requirement that changes hourly, and it is separate
// from Retire below on purpose: the verification clause is that bed status is
// independently controlled from physical existence.
func (b *Bed) SetAvailability(to BedAvailability, reason string,
	now time.Time) error {

	reason = strings.TrimSpace(reason)
	switch {
	case b.Status == MasterRetired:
		// A retired bed has no availability. Reporting it as "available"
		// would put it back in the count the ward admits against.
		return invalidMaster("this bed has been retired from the estate")
	case !validAvailability[to]:
		return invalidMaster("unknown bed status " + string(to))
	case needsReason[to] && reason == "":
		return invalidMaster("taking a bed out of use records why")
	}

	b.Availability = to
	if needsReason[to] {
		b.UnavailableReason = reason
	} else {
		b.UnavailableReason = ""
	}
	b.UpdatedAt = now.UTC()
	b.Version++
	return nil
}

// Retire removes a bed from the estate (SRS-PLT-006, SRS-PLT-015).
//
// Refused while somebody is in it. A retired bed is one the hospital no longer
// has, and it cannot no longer have a bed that currently holds a patient.
func (b *Bed) Retire(now time.Time) error {
	switch {
	case b.Status == MasterRetired:
		return invalidMaster("this bed is already retired")
	case b.Availability == BedOccupied:
		return invalidMaster("a bed with a patient in it cannot be retired")
	}
	b.Status = MasterRetired
	b.Availability = BedOutOfService
	b.UnavailableReason = "retired from the estate"
	b.UpdatedAt = now.UTC()
	b.Version++
	return nil
}

// Usable reports whether a bed can take a patient now.
//
// Both halves have to be true, which is the point of keeping them apart: a bed
// can exist and not be usable, and no bed can be usable without existing.
func (b Bed) Usable() bool {
	return b.Status == MasterActive && b.Availability == BedAvailable
}

func invalidMaster(message string) error {
	return rpcerr.Invalid("ORG_INVALID_BED_MASTER", message)
}
