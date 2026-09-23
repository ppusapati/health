package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Storage (SRS-MORT-002).
//
// A body is in one place at a time and the place is traceable. That second
// word is what the movement history is for: "where was it on Tuesday" is a
// question asked by a family who came and were told the wrong thing, and by a
// coroner who wants to know who had access.

// SpaceKind is what sort of storage a location is (SRS-MORT-002).
type SpaceKind string

const (
	// SpaceRefrigerated is ordinary cold storage.
	SpaceRefrigerated SpaceKind = "refrigerated"
	// SpaceFreezer is for a body that will be held a long time, which an
	// unidentified one usually is.
	SpaceFreezer SpaceKind = "freezer"
	// SpaceViewing is a room a family is taken into. Occupied like any
	// other space, because a body in the viewing room is a body not in its
	// drawer, and a mortuary that forgets that loses it.
	SpaceViewing SpaceKind = "viewing"
	// SpacePostmortem is the table.
	SpacePostmortem SpaceKind = "postmortem"
)

var knownSpaceKind = map[SpaceKind]bool{
	SpaceRefrigerated: true, SpaceFreezer: true,
	SpaceViewing: true, SpacePostmortem: true,
}

// Location is one storage space (SRS-MORT-002).
type Location struct {
	ID       string
	TenantID string

	// Code is what is painted on the door: "F2-14".
	Code       string
	Kind       SpaceKind
	FacilityID string
	// Zone groups the spaces a mortuary manages together — a room, a bank
	// of drawers, a building.
	Zone string

	// OutOfService takes a space off the board without deleting it: a
	// broken refrigeration unit is still a space, and the bodies that were
	// in it last month were in it.
	OutOfService       bool
	OutOfServiceReason string

	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// NewLocationInput registers a storage space.
type NewLocationInput struct {
	Code       string
	Kind       SpaceKind
	FacilityID string
	Zone       string
}

// NewLocation registers a storage space (SRS-MORT-002).
func NewLocation(id, tenantID string, in NewLocationInput, by string,
	now time.Time) (Location, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Location{}, fmt.Errorf("%w: a location needs an id",
			ErrInvalidMortuary)
	case strings.TrimSpace(in.Code) == "":
		return Location{}, fmt.Errorf("%w: a location needs its code",
			ErrInvalidMortuary)
	case !knownSpaceKind[in.Kind]:
		return Location{}, fmt.Errorf("%w: unknown space kind %q",
			ErrInvalidMortuary, in.Kind)
	case strings.TrimSpace(by) == "":
		return Location{}, fmt.Errorf("%w: a location names who added it",
			ErrInvalidMortuary)
	}

	return Location{
		ID: id, TenantID: tenantID,
		Code: strings.ToUpper(strings.TrimSpace(in.Code)),
		Kind: in.Kind, FacilityID: strings.TrimSpace(in.FacilityID),
		Zone:      strings.TrimSpace(in.Zone),
		CreatedAt: now.UTC(), CreatedBy: by, Version: 1,
	}, nil
}

// TakeOutOfService stops a space being used without erasing what was in it.
func (l *Location) TakeOutOfService(reason string) error {
	if strings.TrimSpace(reason) == "" {
		return fmt.Errorf("%w: say why the space is out of service",
			ErrInvalidMortuary)
	}
	l.OutOfService = true
	l.OutOfServiceReason = strings.TrimSpace(reason)
	return nil
}

// ReturnToService puts a space back on the board.
func (l *Location) ReturnToService() {
	l.OutOfService = false
	l.OutOfServiceReason = ""
}

// PlacementState is whether a body is still in a space (SRS-MORT-002).
type PlacementState string

const (
	// PlacementCurrent is where the body is now.
	PlacementCurrent PlacementState = "current"
	// PlacementEnded is where it was. Kept, because the movement history
	// is the traceability SRS-MORT-002 asks for.
	PlacementEnded PlacementState = "ended"
)

// Placement is one body in one space for one period (SRS-MORT-002).
type Placement struct {
	ID       string
	TenantID string

	CaseID     string
	LocationID string
	// StorageTag is the tag physically attached to the body, which is what
	// the person opening the drawer actually reads. Unique while in use,
	// because two bodies with the same tag is a mortuary that cannot tell
	// them apart at the point where it matters.
	StorageTag string

	State PlacementState

	// IdentityCheckedBy and IdentityCheckedNote record the positive
	// identity check made at the moment of placing. SRS-MORT-002 asks for
	// it here rather than only at release: a body put in the wrong drawer
	// is found by the next person who opens it, and by then nobody
	// remembers.
	IdentityCheckedBy   string
	IdentityCheckedNote string

	PlacedAt time.Time
	PlacedBy string
	EndedAt  time.Time
	EndedBy  string
	// EndedReason says why the body moved: to the table, to the viewing
	// room, to a different bank because this one failed.
	EndedReason string
}

// Place puts a body in a space (SRS-MORT-002).
//
// The location is passed in rather than named, so the space being out of
// service is a rule this can enforce rather than one the caller remembers.
func Place(id, tenantID string, c *Case, location Location, tag,
	checkedNote, by string, now time.Time) (Placement, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Placement{}, fmt.Errorf("%w: a placement needs an id",
			ErrInvalidMortuary)
	case c.State == CaseReleased:
		return Placement{}, fmt.Errorf("%w: this case has been released",
			ErrInvalidMortuary)
	case location.OutOfService:
		return Placement{}, fmt.Errorf(
			"%w: space %s is out of service: %s", ErrInvalidMortuary,
			location.Code, location.OutOfServiceReason)
	case strings.TrimSpace(tag) == "":
		// The tag is what the person opening the drawer reads. A body
		// without one is identified by which drawer it is in, and drawers
		// get reorganised.
		return Placement{}, fmt.Errorf("%w: a placement needs its tag",
			ErrInvalidMortuary)
	case strings.TrimSpace(by) == "":
		return Placement{}, fmt.Errorf("%w: a placement names who made it",
			ErrInvalidMortuary)
	case strings.TrimSpace(checkedNote) == "":
		// What was checked against what: the tag against the register,
		// the wristband against the notes, the face against a relative.
		// "Identity checked" with nothing behind it is a tick.
		return Placement{}, fmt.Errorf(
			"%w: a placement says what identity check was made",
			ErrInvalidMortuary)
	}

	c.State = CaseStored
	c.LocationID = location.ID
	c.StorageTag = strings.ToUpper(strings.TrimSpace(tag))

	return Placement{
		ID: id, TenantID: tenantID,
		CaseID: c.ID, LocationID: location.ID,
		StorageTag:          strings.ToUpper(strings.TrimSpace(tag)),
		State:               PlacementCurrent,
		IdentityCheckedBy:   by,
		IdentityCheckedNote: strings.TrimSpace(checkedNote),
		PlacedAt:            now.UTC(), PlacedBy: by,
	}, nil
}

// End closes a placement, which is what frees the space (SRS-MORT-002).
func (p *Placement) End(reason, by string, now time.Time) error {
	switch {
	case p.State != PlacementCurrent:
		return fmt.Errorf("%w: this placement has already ended",
			ErrInvalidMortuary)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: ending a placement names who did it",
			ErrInvalidMortuary)
	case strings.TrimSpace(reason) == "":
		// A body that moved for no recorded reason is one nobody can
		// follow. "Where was it on Tuesday" needs the why as well as the
		// where.
		return fmt.Errorf("%w: say why the body was moved",
			ErrInvalidMortuary)
	}
	p.State = PlacementEnded
	p.EndedAt, p.EndedBy = now.UTC(), by
	p.EndedReason = strings.TrimSpace(reason)
	return nil
}

// Occupancy is how full a mortuary is (SRS-MORT-008).
type Occupancy struct {
	Total int
	// InService excludes the spaces that are broken, which is the number a
	// mortuary actually has.
	InService int
	Occupied  int
	Free      int
	// ByKind counts free spaces by kind, because a free viewing room does
	// not help somebody looking for a drawer.
	FreeByKind map[SpaceKind]int
	// OutOfService is reported rather than hidden: a mortuary running at
	// nine tenths because a third of its units are broken has a different
	// problem from one that is simply full.
	OutOfService int
}

// CountOccupancy reports the free space (SRS-MORT-008).
func CountOccupancy(locations []Location,
	current map[string]bool) Occupancy {

	out := Occupancy{FreeByKind: map[SpaceKind]int{}}
	for _, location := range locations {
		out.Total++
		if location.OutOfService {
			out.OutOfService++
			continue
		}
		out.InService++
		if current[location.ID] {
			out.Occupied++
			continue
		}
		out.Free++
		out.FreeByKind[location.Kind]++
	}
	return out
}

// History orders a case's placements oldest first (SRS-MORT-002).
func History(placements []Placement, caseID string) []Placement {
	out := make([]Placement, 0, len(placements))
	for _, placement := range placements {
		if placement.CaseID == caseID {
			out = append(out, placement)
		}
	}
	sort.SliceStable(out, func(i, j int) bool {
		return out[i].PlacedAt.Before(out[j].PlacedAt)
	})
	return out
}
