// Package domain holds the facilities engineering rules (SRS-FAC-001 … 011).
//
// Four properties are worth stating before the code, because each is the
// reason a piece of it is shaped the way it is.
//
// Work a hospital has decided is dangerous cannot be closed without the
// paperwork that made it safe. The work class carries whether it needs a
// permit to work and a lockout-tagout reference, the order carries both
// answers copied from the class, and a composite foreign key holds the two
// together. An electrician who isolated a panel and signed nothing is the
// same as one who isolated nothing, and the person who finds out is the next
// person to open it.
//
// An alarm and the work it caused are linked and separate. A gateway raising
// a chiller alarm does not close when somebody fixes the chiller, and a work
// order does not clear because the alarm stopped sounding. Two lifecycles in
// one row is a maintenance history that says whatever the last event said.
//
// A critical fire-safety deficiency stays visible until somebody closes it.
// Not until the inspection is filed, not until the month ends: an inspection
// that could be signed off with a blocked fire door open is an inspection
// that will be.
//
// And every measurement keeps where it came from. A consumption figure with
// no meter behind it is a number somebody typed, and the command centre
// cannot tell the two apart.
package domain

import (
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"
)

// ErrInvalidFacilities is the sentinel every refusal here wraps.
var ErrInvalidFacilities = errors.New("facilities: invalid")

// System is the engineering system an asset belongs to (SRS-FAC-001).
//
// An enum rather than free text, because the system decides who is called at
// three in the morning and what the escalation matrix resolves to. "HVAC" and
// "hvac" and "air handling" typed into a text column are three systems as far
// as any report is concerned.
type System string

const (
	SystemElectrical System = "electrical"
	SystemHVAC       System = "hvac"
	SystemPlumbing   System = "plumbing"
	// SystemFire is detection, suppression and the passive measures — the
	// doors, the dampers, the compartmentation.
	SystemFire System = "fire"
	// SystemMedicalGas is the one system on this list whose failure
	// reaches a patient in minutes rather than hours.
	SystemMedicalGas System = "medical_gas"
	SystemLifts      System = "lifts"
	// SystemWater covers RO, softeners and the dialysis loop.
	SystemWater System = "water"
	// SystemEffluent covers STP and ETP: a hospital that cannot treat its
	// effluent stops being allowed to operate.
	SystemEffluent System = "effluent"
	SystemPower    System = "power"
	SystemOther    System = "other"
)

var knownSystem = map[System]bool{
	SystemElectrical: true, SystemHVAC: true, SystemPlumbing: true,
	SystemFire: true, SystemMedicalGas: true, SystemLifts: true,
	SystemWater: true, SystemEffluent: true, SystemPower: true,
	SystemOther: true,
}

// LifeSafety reports the systems whose failure is a life-safety matter in
// itself (SRS-FAC-006, SRS-FAC-008).
//
// Used to decide escalation, not to decide who does the work. A blocked fire
// door and an empty oxygen manifold are both things somebody is woken for.
func (s System) LifeSafety() bool {
	return s == SystemFire || s == SystemMedicalGas
}

// Criticality is what happens to the hospital when this asset stops
// (SRS-FAC-001).
//
// About consequence rather than about cost. A four-thousand-rupee changeover
// valve on a theatre's oxygen line is critical and a hundred-thousand-rupee
// chiller serving an office is not.
type Criticality string

const (
	// CriticalityLife is an asset whose failure threatens somebody within
	// the hour: the oxygen manifold, the theatre's air handling, the
	// generator that carries the ICU.
	CriticalityLife Criticality = "life"
	// CriticalityHigh stops a service: a lift a ward depends on, a chiller
	// that serves an operating suite.
	CriticalityHigh   Criticality = "high"
	CriticalityNormal Criticality = "normal"
	CriticalityLow    Criticality = "low"
)

var knownCriticality = map[Criticality]bool{
	CriticalityLife: true, CriticalityHigh: true,
	CriticalityNormal: true, CriticalityLow: true,
}

// rank orders criticality. Lower is more urgent.
func (c Criticality) rank() int {
	switch c {
	case CriticalityLife:
		return 0
	case CriticalityHigh:
		return 1
	case CriticalityNormal:
		return 2
	default:
		return 3
	}
}

// AssetStatus is where an asset stands (SRS-FAC-001).
type AssetStatus string

const (
	AssetInService AssetStatus = "in_service"
	// AssetDegraded is running and not right: one of two compressors
	// down, a generator that starts on the second attempt. Its own state
	// rather than a flag, because "working" and "working for now" lead to
	// different decisions.
	AssetDegraded AssetStatus = "degraded"
	AssetDown     AssetStatus = "down"
	// AssetDecommissioned is gone. Kept, because the work orders raised
	// against it are still work orders.
	AssetDecommissioned AssetStatus = "decommissioned"
)

var knownAssetStatus = map[AssetStatus]bool{
	AssetInService: true, AssetDegraded: true, AssetDown: true,
	AssetDecommissioned: true,
}

// Working reports a status an asset can be relied on in.
func (s AssetStatus) Working() bool { return s == AssetInService }

// Asset is one piece of facilities plant (SRS-FAC-001).
type Asset struct {
	ID       string
	TenantID string

	// Tag is what is stencilled on the machine: "DG-02", "AHU-OT-1".
	Tag         string
	Name        string
	System      System
	Criticality Criticality

	// ParentID is the asset this one is part of — a compressor inside a
	// chiller plant, a manifold inside the medical gas system. The
	// hierarchy SRS-FAC-001 asks for is this column and nothing else: a
	// second tree in a second table would disagree with it.
	ParentID string

	FacilityID string
	// LocationID is the org unit or room the asset serves or sits in.
	// Required: an asset nobody can find is one nobody maintains, and
	// "every asset has location" is the acceptance in four words.
	LocationID string
	// LocationNote is where it actually is when the org unit is not
	// precise enough: "plant room, roof, north side".
	LocationNote string

	Status AssetStatus
	// StatusReason says why it is not in service. A machine marked down
	// for no recorded reason is one nobody can chase.
	StatusReason string
	StatusAt     time.Time

	Manufacturer string
	Model        string
	SerialNumber string
	// CommissionedAt is when it went into service, which is what a
	// lifetime figure is measured from.
	CommissionedAt time.Time

	// RuntimeHours is the counter SRS-FAC-007 asks for, where the asset
	// has one. Derived from the readings rather than typed, so it cannot
	// disagree with them.
	RuntimeHours int
	// RuntimeAt is when the counter was last read.
	RuntimeAt time.Time

	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// NewAssetInput registers a facilities asset.
type NewAssetInput struct {
	Tag            string
	Name           string
	System         System
	Criticality    Criticality
	ParentID       string
	FacilityID     string
	LocationID     string
	LocationNote   string
	Manufacturer   string
	Model          string
	SerialNumber   string
	CommissionedAt time.Time
}

// NewAsset registers a facilities asset (SRS-FAC-001).
//
// It starts in service, which is the one default here that is not the safe
// direction and is the right one anyway: an asset registered as down would
// have every report showing plant that is running as plant that is not, and
// the first thing anybody does with a new machine is use it.
func NewAsset(id, tenantID string, in NewAssetInput, by string,
	now time.Time) (Asset, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Asset{}, fmt.Errorf("%w: an asset needs an id",
			ErrInvalidFacilities)
	case strings.TrimSpace(in.Tag) == "":
		// The tag is what somebody reads off the machine at two in the
		// morning. An asset without one is found by description.
		return Asset{}, fmt.Errorf("%w: an asset needs its tag",
			ErrInvalidFacilities)
	case strings.TrimSpace(in.Name) == "":
		return Asset{}, fmt.Errorf("%w: an asset needs a name",
			ErrInvalidFacilities)
	case !knownSystem[in.System]:
		return Asset{}, fmt.Errorf("%w: unknown system %q",
			ErrInvalidFacilities, in.System)
	case !knownCriticality[in.Criticality]:
		return Asset{}, fmt.Errorf("%w: unknown criticality %q",
			ErrInvalidFacilities, in.Criticality)
	case strings.TrimSpace(in.LocationID) == "" &&
		strings.TrimSpace(in.LocationNote) == "":
		// "Every asset has location" is the acceptance. An asset nobody
		// can find is one nobody maintains.
		return Asset{}, fmt.Errorf("%w: an asset says where it is",
			ErrInvalidFacilities)
	case strings.TrimSpace(by) == "":
		return Asset{}, fmt.Errorf("%w: an asset names who registered it",
			ErrInvalidFacilities)
	case strings.TrimSpace(in.ParentID) == id:
		// An asset inside itself is a hierarchy read that never
		// terminates.
		return Asset{}, fmt.Errorf("%w: an asset is not its own parent",
			ErrInvalidFacilities)
	}

	return Asset{
		ID: id, TenantID: tenantID,
		Tag:    strings.ToUpper(strings.TrimSpace(in.Tag)),
		Name:   strings.TrimSpace(in.Name),
		System: in.System, Criticality: in.Criticality,
		ParentID:     strings.TrimSpace(in.ParentID),
		FacilityID:   strings.TrimSpace(in.FacilityID),
		LocationID:   strings.TrimSpace(in.LocationID),
		LocationNote: strings.TrimSpace(in.LocationNote),
		Status:       AssetInService, StatusAt: now.UTC(),
		Manufacturer:   strings.TrimSpace(in.Manufacturer),
		Model:          strings.TrimSpace(in.Model),
		SerialNumber:   strings.TrimSpace(in.SerialNumber),
		CommissionedAt: utcOrZero(in.CommissionedAt),
		CreatedAt:      now.UTC(), CreatedBy: by, Version: 1,
	}, nil
}

// SetStatus moves an asset between service states (SRS-FAC-001).
func (a *Asset) SetStatus(status AssetStatus, reason string,
	now time.Time) error {

	switch {
	case a.Status == AssetDecommissioned:
		return fmt.Errorf("%w: this asset is decommissioned",
			ErrInvalidFacilities)
	case !knownAssetStatus[status]:
		return fmt.Errorf("%w: unknown asset status %q",
			ErrInvalidFacilities, status)
	case status != AssetInService && strings.TrimSpace(reason) == "":
		// A machine marked down for no recorded reason is one nobody can
		// chase, and the report of what is down reads as a list of
		// mysteries.
		return fmt.Errorf("%w: say why the asset is %s",
			ErrInvalidFacilities, status)
	}

	a.Status = status
	a.StatusReason = strings.TrimSpace(reason)
	a.StatusAt = now.UTC()
	return nil
}

// Descendants lists an asset and everything under it (SRS-FAC-001).
//
// Breadth-first from the parent map, and it will not loop: a cycle somebody
// created by re-parenting two assets into each other stops at the first
// repeat rather than hanging the caller.
func Descendants(assets []Asset, rootID string) []Asset {
	children := map[string][]Asset{}
	for _, asset := range assets {
		children[asset.ParentID] = append(children[asset.ParentID], asset)
	}

	var out []Asset
	seen := map[string]bool{}
	queue := []string{rootID}
	for _, asset := range assets {
		if asset.ID == rootID {
			out = append(out, asset)
			seen[rootID] = true
		}
	}
	for len(queue) > 0 {
		parent := queue[0]
		queue = queue[1:]
		for _, child := range children[parent] {
			if seen[child.ID] {
				continue
			}
			seen[child.ID] = true
			out = append(out, child)
			queue = append(queue, child.ID)
		}
	}
	return out
}

// CriticalDown lists the assets that are not working, most critical first
// (SRS-FAC-001, SRS-FAC-009).
//
// The list a facilities manager reads before anything else, and the order is
// the whole value of it: a list in tag order puts the oxygen manifold below
// the car park barrier.
func CriticalDown(assets []Asset) []Asset {
	out := make([]Asset, 0, len(assets))
	for _, asset := range assets {
		if asset.Status == AssetDown || asset.Status == AssetDegraded {
			out = append(out, asset)
		}
	}
	sort.SliceStable(out, func(i, j int) bool {
		if out[i].Criticality != out[j].Criticality {
			return out[i].Criticality.rank() < out[j].Criticality.rank()
		}
		// Then by how long it has been like that. A chiller down since
		// Tuesday matters more than one down since lunchtime.
		return out[i].StatusAt.Before(out[j].StatusAt)
	})
	return out
}

func utcOrZero(t time.Time) time.Time {
	if t.IsZero() {
		return time.Time{}
	}
	return t.UTC()
}

func normalise(in []string) []string {
	if len(in) == 0 {
		return nil
	}
	seen := map[string]bool{}
	out := make([]string, 0, len(in))
	for _, value := range in {
		value = strings.TrimSpace(value)
		if value == "" || seen[strings.ToLower(value)] {
			continue
		}
		seen[strings.ToLower(value)] = true
		out = append(out, value)
	}
	return out
}
