package domain

import (
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/ppusapati/health/code/internal/platform/effective"
)

// Organizational units (SRS-PLT-005).
//
// Departments, specialties, cost centres, service units and care locations are
// one type rather than five. They differ in what they mean to a human and not
// at all in what the system does with them: each is a named, effective-dated
// node in a hierarchy that transactions attach to. Five near-identical types
// would mean five copies of the same effective-date logic, and the fifth copy
// is where somebody forgets the check.

// UnitType distinguishes the kinds of organisational unit.
type UnitType string

const (
	UnitDepartment   UnitType = "department"
	UnitSpecialty    UnitType = "specialty"
	UnitCostCenter   UnitType = "cost_center"
	UnitServiceUnit  UnitType = "service_unit"
	UnitCareLocation UnitType = "care_location"
)

var validUnitTypes = map[UnitType]bool{
	UnitDepartment: true, UnitSpecialty: true, UnitCostCenter: true,
	UnitServiceUnit: true, UnitCareLocation: true,
}

// OrgUnit is one node of a tenant's organisational structure.
type OrgUnit struct {
	ID           string
	TenantID     string
	FacilityID   string
	Type         UnitType
	Code         string
	DisplayName  string
	ParentUnitID string

	EffectiveFrom  time.Time
	EffectiveUntil time.Time

	// AcceptsActivityWhenInactive lets a closed unit still receive
	// transactions. A ward being decommissioned still gets late documentation
	// for patients it treated, and refusing that would push the note somewhere
	// arbitrary. It is an explicit permission rather than a default because
	// the usual answer is no.
	AcceptsActivityWhenInactive bool

	CreatedAt time.Time
	UpdatedAt time.Time
	Version   int64
}

// ErrInvalidOrgUnit reports a unit that must not be stored.
var ErrInvalidOrgUnit = errors.New("organization: invalid organizational unit")

// ErrUnitNotAcceptingActivity reports a transaction aimed at a unit that is
// not open for it (SRS-PLT-005).
var ErrUnitNotAcceptingActivity = errors.New("organization: unit is not accepting new activity")

// NewOrgUnit validates and constructs a unit.
func NewOrgUnit(id, tenantID, facilityID string, unitType UnitType, code, displayName,
	parentUnitID string, from, until time.Time, acceptsWhenInactive bool, now time.Time) (OrgUnit, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return OrgUnit{}, fmt.Errorf("%w: id is required", ErrInvalidOrgUnit)
	case strings.TrimSpace(tenantID) == "":
		return OrgUnit{}, fmt.Errorf("%w: tenant is required", ErrInvalidOrgUnit)
	case !validUnitTypes[unitType]:
		return OrgUnit{}, fmt.Errorf("%w: unknown unit type %q", ErrInvalidOrgUnit, unitType)
	case strings.TrimSpace(code) == "":
		return OrgUnit{}, fmt.Errorf("%w: code is required", ErrInvalidOrgUnit)
	case strings.TrimSpace(displayName) == "":
		return OrgUnit{}, fmt.Errorf("%w: display name is required", ErrInvalidOrgUnit)
	case id == parentUnitID:
		// One-level self-parenting is the only cycle detectable without
		// reading the rest of the tree; deeper cycles are the repository's
		// problem, and it has the rows to detect them.
		return OrgUnit{}, fmt.Errorf("%w: a unit cannot be its own parent", ErrInvalidOrgUnit)
	}

	window := effective.Window{From: from, Until: until}
	if err := window.Validate(); err != nil {
		return OrgUnit{}, fmt.Errorf("%w: %v", ErrInvalidOrgUnit, err)
	}

	return OrgUnit{
		ID: id, TenantID: tenantID, FacilityID: facilityID,
		Type: unitType, Code: code, DisplayName: displayName,
		ParentUnitID:                parentUnitID,
		EffectiveFrom:               from.UTC(),
		EffectiveUntil:              until,
		AcceptsActivityWhenInactive: acceptsWhenInactive,
		CreatedAt:                   now.UTC(),
		UpdatedAt:                   now.UTC(),
		Version:                     1,
	}, nil
}

// EffectiveWindow satisfies effective.Versioned.
func (u OrgUnit) EffectiveWindow() effective.Window {
	return effective.Window{From: u.EffectiveFrom, Until: u.EffectiveUntil}
}

// VersionNumber satisfies effective.Versioned.
func (u OrgUnit) VersionNumber() int64 { return u.Version }

// ActiveAt reports whether the unit is inside its effective window.
func (u OrgUnit) ActiveAt(at time.Time) bool { return u.EffectiveWindow().Contains(at) }

// AuthorizeActivity decides whether a transaction may attach to this unit.
//
// SRS-PLT-005's verification clause: "inactive units cannot accept new
// transactional activity unless explicitly allowed". The event time is the
// parameter, not the current time — backdated documentation is routine in a
// hospital, and judging it against today would reject a note about a ward that
// closed last week.
func (u OrgUnit) AuthorizeActivity(eventTime time.Time) error {
	if u.ActiveAt(eventTime) {
		return nil
	}
	if u.AcceptsActivityWhenInactive {
		return nil
	}
	return fmt.Errorf("%w: %s %s was not active at %s",
		ErrUnitNotAcceptingActivity, u.Type, u.Code, eventTime.UTC().Format(time.RFC3339))
}

// Close ends a unit's effective window.
//
// Closing in the past is refused. A unit closed retroactively would
// invalidate transactions that were legitimately accepted while it was open,
// and the fix for those is a correction with its own audit trail, not a
// silent change to the window they were checked against.
func (u *OrgUnit) Close(until time.Time, now time.Time) error {
	switch {
	case until.IsZero():
		return fmt.Errorf("%w: a closing date is required", ErrInvalidOrgUnit)
	case !until.After(u.EffectiveFrom):
		return fmt.Errorf("%w: closing date is not after the effective-from date", ErrInvalidOrgUnit)
	case until.UTC().Before(now.UTC()):
		return fmt.Errorf("%w: a unit cannot be closed retroactively; transactions "+
			"already accepted against it would become invalid", ErrInvalidOrgUnit)
	}
	u.EffectiveUntil = until.UTC()
	u.UpdatedAt = now.UTC()
	return nil
}
