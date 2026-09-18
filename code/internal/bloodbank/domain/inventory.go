// Package domain holds the blood bank and transfusion rules
// (SRS-BLD-001 … 017).
//
// No infrastructure: the rules here are the ones a blood bank scientist would
// recognise as theirs, and they are testable without a database (FIT-01).
package domain

import (
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"
)

// ErrInvalidUnit refuses a blood bank record that could not be true.
var ErrInvalidUnit = errors.New("bloodbank: invalid")

// ABO is the blood group.
//
// Its own type with an explicit unknown, because "not yet grouped" and "group
// O" are different states and a system that defaulted one to the other would
// issue the wrong blood. Every comparison here treats ABOUnknown as
// incompatible with everything.
type ABO string

const (
	ABOUnknown ABO = ""
	ABOA       ABO = "A"
	ABOB       ABO = "B"
	ABOAB      ABO = "AB"
	ABOO       ABO = "O"
)

var knownABO = map[ABO]bool{ABOA: true, ABOB: true, ABOAB: true, ABOO: true}

// RhD is the Rh(D) antigen status.
type RhD string

const (
	RhUnknown  RhD = ""
	RhPositive RhD = "positive"
	RhNegative RhD = "negative"
)

var knownRh = map[RhD]bool{RhPositive: true, RhNegative: true}

// Group is a complete ABO and Rh(D) type.
type Group struct {
	ABO ABO
	Rh  RhD
}

// Known reports a group that has actually been determined.
func (g Group) Known() bool { return knownABO[g.ABO] && knownRh[g.Rh] }

// String renders the group the way a label does.
func (g Group) String() string {
	if !g.Known() {
		return "unknown"
	}
	if g.Rh == RhPositive {
		return string(g.ABO) + "+"
	}
	return string(g.ABO) + "-"
}

// aboCompatible maps a recipient's ABO group to the donor ABO groups whose red
// cells they may receive.
//
// Red cells only. Plasma runs the other way — an AB recipient may receive any
// red cells and only AB plasma — which is why ComponentClass exists and why
// this table is never consulted without it.
var aboCompatible = map[ABO]map[ABO]bool{
	ABOO:  {ABOO: true},
	ABOA:  {ABOO: true, ABOA: true},
	ABOB:  {ABOO: true, ABOB: true},
	ABOAB: {ABOO: true, ABOA: true, ABOB: true, ABOAB: true},
}

// plasmaCompatible maps a recipient's ABO group to the donor ABO groups whose
// plasma they may receive. The inverse of the red cell table, because plasma
// carries the antibodies rather than the antigens.
var plasmaCompatible = map[ABO]map[ABO]bool{
	ABOAB: {ABOAB: true},
	ABOA:  {ABOA: true, ABOAB: true},
	ABOB:  {ABOB: true, ABOAB: true},
	ABOO:  {ABOO: true, ABOA: true, ABOB: true, ABOAB: true},
}

// ComponentClass is what the unit is, which decides which compatibility table
// applies.
type ComponentClass string

const (
	ClassRedCells   ComponentClass = "red_cells"
	ClassPlasma     ComponentClass = "plasma"
	ClassPlatelets  ComponentClass = "platelets"
	ClassCryo       ComponentClass = "cryoprecipitate"
	ClassWholeBlood ComponentClass = "whole_blood"
)

var knownClasses = map[ComponentClass]bool{
	ClassRedCells: true, ClassPlasma: true, ClassPlatelets: true,
	ClassCryo: true, ClassWholeBlood: true,
}

// carriesRedCells reports a component whose ABO compatibility follows the red
// cell table. Whole blood carries both, and is held to the stricter rule: it
// must match on the red cell table and on the plasma table both.
func (c ComponentClass) carriesRedCells() bool {
	return c == ClassRedCells || c == ClassWholeBlood
}

func (c ComponentClass) carriesPlasma() bool {
	return c == ClassPlasma || c == ClassCryo || c == ClassWholeBlood ||
		// Platelets are suspended in plasma. Units differ on how strictly they
		// apply it, but the safe direction is to apply it: a platelet
		// transfusion across an incompatible plasma group is a reaction that
		// was preventable.
		c == ClassPlatelets
}

// CompatibleGroups reports whether a donor group may be given to a recipient
// group for this component class (SRS-BLD-007).
//
// Unknown on either side is incompatible. Every other function here depends on
// that: "we have not grouped this patient" must never read as a match.
func CompatibleGroups(class ComponentClass, donor, recipient Group) bool {
	if !donor.Known() || !recipient.Known() {
		return false
	}

	if class.carriesRedCells() && !aboCompatible[recipient.ABO][donor.ABO] {
		return false
	}
	if class.carriesPlasma() && !plasmaCompatible[recipient.ABO][donor.ABO] {
		return false
	}

	// Rh(D) applies to the components that carry red cells. An Rh-negative
	// recipient given Rh-positive red cells may be sensitised, which matters
	// most for a woman of childbearing age and matters to everybody who might
	// be transfused again.
	if class.carriesRedCells() && recipient.Rh == RhNegative &&
		donor.Rh == RhPositive {
		return false
	}
	return true
}

// UnitStatus is where a unit is in its life (SRS-BLD-004, SRS-BLD-005).
type UnitStatus string

const (
	// UnitQuarantined is the state every unit starts in. Testing has not
	// completed, so the unit exists and cannot be given to anybody.
	UnitQuarantined UnitStatus = "quarantined"
	UnitAvailable   UnitStatus = "available"
	UnitReserved    UnitStatus = "reserved"
	UnitIssued      UnitStatus = "issued"
	UnitTransfused  UnitStatus = "transfused"
	UnitDiscarded   UnitStatus = "discarded"
	// UnitUnsuitable is a unit returned outside its temperature or time
	// window. Distinct from discarded, because it is still on the shelf until
	// somebody disposes of it and must never be allocated in the meantime.
	UnitUnsuitable UnitStatus = "unsuitable"
)

// Allocatable reports a status from which a unit may be reserved.
//
// The list is short and closed on purpose: SRS-BLD-004 and SRS-BLD-005 both
// name what must not be allocatable, and a rule written as "not discarded and
// not expired and not…" acquires a hole every time a status is added.
func (s UnitStatus) Allocatable() bool { return s == UnitAvailable }

// Component is one transfusable unit (SRS-BLD-003, SRS-BLD-005).
type Component struct {
	ID       string
	TenantID string

	// UnitNumber is the identifier on the label — the one a bedside check
	// reads aloud. Unique within the deployment's configured scope
	// (SRS-BLD-001).
	UnitNumber string
	// CollectionID is the parent. Every component traces to the collection it
	// was made from, which is half of vein-to-vein traceability: the other
	// half is the transfusion record (SRS-BLD-014).
	CollectionID string
	// DonorID is present for a unit collected here and empty for one received
	// from an external supplier, which is an ordinary state rather than a gap.
	DonorID string
	// Source names the external supplier for a received unit.
	Source string

	Class  ComponentClass
	Group  Group
	Status UnitStatus

	VolumeML int
	// Attributes are the special ones a request can require: irradiated,
	// leucodepleted, CMV-negative, washed. Matched rather than interpreted, so
	// a deployment can add one without a code change.
	Attributes []string

	Location string
	// CollectedAt and ExpiresAt bound the unit's life. A component with no
	// expiry is refused: every blood component has one, and a missing expiry
	// reads as "never expires" to every query that filters on it.
	CollectedAt time.Time
	ExpiresAt   time.Time

	CreatedAt time.Time
	CreatedBy string
	Version   int64
}

// Expired reports a unit past its expiry at the given moment.
func (c Component) Expired(now time.Time) bool {
	return !c.ExpiresAt.IsZero() && !now.Before(c.ExpiresAt)
}

// Issuable reports a unit that may be reserved or issued now.
//
// Status and expiry together, because they fail independently: a unit can be
// available and expired, and a query that checked only one would offer it.
func (c Component) Issuable(now time.Time) bool {
	return c.Status.Allocatable() && !c.Expired(now)
}

// Has reports whether the unit carries a special attribute.
func (c Component) Has(attribute string) bool {
	for _, held := range c.Attributes {
		if strings.EqualFold(held, attribute) {
			return true
		}
	}
	return false
}

// NewComponentInput is one component entering inventory.
type NewComponentInput struct {
	UnitNumber   string
	CollectionID string
	DonorID      string
	Source       string
	Class        ComponentClass
	Group        Group
	VolumeML     int
	Attributes   []string
	Location     string
	CollectedAt  time.Time
	ExpiresAt    time.Time
	// Released marks a unit whose mandatory testing is already complete —
	// which is the ordinary case for a unit bought in from a regional centre,
	// and never the case for one collected here.
	Released bool
}

// NewComponent brings a component into inventory (SRS-BLD-003, SRS-BLD-005).
//
// It starts quarantined unless the caller says testing is already complete.
// That default is the whole of SRS-BLD-004's acceptance clause: a unit whose
// testing has not been recorded must not be allocatable, and a system where
// the safe state is the one you have to remember to ask for will issue an
// untested unit eventually.
func NewComponent(id, tenantID string, in NewComponentInput, by string,
	now time.Time) (Component, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return Component{}, fmt.Errorf("%w: a component needs an id", ErrInvalidUnit)
	case strings.TrimSpace(in.UnitNumber) == "":
		// The identifier on the label, which the bedside check reads.
		return Component{}, fmt.Errorf("%w: a component needs a unit number",
			ErrInvalidUnit)
	case strings.TrimSpace(in.CollectionID) == "":
		// Every component traces to a collection (SRS-BLD-003). A component
		// with no parent cannot be traced back to a donor, which is the half
		// of vein-to-vein traceability that runs backwards.
		return Component{}, fmt.Errorf(
			"%w: a component traces to the collection it was made from",
			ErrInvalidUnit)
	case !knownClasses[in.Class]:
		return Component{}, fmt.Errorf("%w: unknown component type %q",
			ErrInvalidUnit, in.Class)
	case !in.Group.Known():
		// An ungrouped unit cannot be matched to anybody, and storing it as
		// group unknown would make every compatibility check say no — which is
		// correct but silent. Refusing says why.
		return Component{}, fmt.Errorf("%w: a component records its ABO and Rh group",
			ErrInvalidUnit)
	case in.ExpiresAt.IsZero():
		// A missing expiry reads as "never expires" to every query that
		// filters on it, which is the one direction that lets an out-of-date
		// unit reach a patient.
		return Component{}, fmt.Errorf("%w: a component records its expiry",
			ErrInvalidUnit)
	case strings.TrimSpace(by) == "":
		return Component{}, fmt.Errorf("%w: a component names who entered it",
			ErrInvalidUnit)
	case strings.TrimSpace(in.DonorID) == "" && strings.TrimSpace(in.Source) == "":
		// One or the other: collected from a donor here, or received from
		// somebody who did. Neither is an unprovenanced unit.
		return Component{}, fmt.Errorf(
			"%w: a component names its donor or the supplier it came from",
			ErrInvalidUnit)
	}

	if !in.CollectedAt.IsZero() && !in.ExpiresAt.After(in.CollectedAt) {
		return Component{}, fmt.Errorf("%w: a component expires after it is collected",
			ErrInvalidUnit)
	}

	status := UnitQuarantined
	if in.Released {
		status = UnitAvailable
	}

	return Component{
		ID: id, TenantID: tenantID,
		UnitNumber:   strings.TrimSpace(in.UnitNumber),
		CollectionID: strings.TrimSpace(in.CollectionID),
		DonorID:      strings.TrimSpace(in.DonorID),
		Source:       strings.TrimSpace(in.Source),
		Class:        in.Class, Group: in.Group, Status: status,
		VolumeML:    in.VolumeML,
		Attributes:  normalised(in.Attributes),
		Location:    strings.TrimSpace(in.Location),
		CollectedAt: in.CollectedAt.UTC(), ExpiresAt: in.ExpiresAt.UTC(),
		CreatedAt: now.UTC(), CreatedBy: strings.TrimSpace(by),
		Version: 1,
	}, nil
}

// normalised trims, lower-cases and sorts a list of attributes so that two
// spellings of the same requirement match.
func normalised(in []string) []string {
	out := make([]string, 0, len(in))
	seen := map[string]bool{}
	for _, value := range in {
		trimmed := strings.ToLower(strings.TrimSpace(value))
		if trimmed == "" || seen[trimmed] {
			continue
		}
		seen[trimmed] = true
		out = append(out, trimmed)
	}
	sort.Strings(out)
	return out
}

// Release moves a unit out of quarantine once testing is complete
// (SRS-BLD-004).
func (c *Component) Release(now time.Time) error {
	if c.Status != UnitQuarantined {
		return fmt.Errorf("%w: only a quarantined unit is released, not one %s",
			ErrInvalidUnit, c.Status)
	}
	if c.Expired(now) {
		return fmt.Errorf("%w: this unit expired on %s",
			ErrInvalidUnit, c.ExpiresAt.Format(time.RFC3339))
	}
	c.Status = UnitAvailable
	return nil
}

// Quarantine takes a unit back out of the allocatable pool.
//
// For a test result that arrives late, a look-back on a donor, or a recall.
// Refused once the unit has been transfused: the blood is in the patient, and
// a status that said otherwise would make the look-back report wrong.
func (c *Component) Quarantine() error {
	switch c.Status {
	case UnitTransfused:
		return fmt.Errorf("%w: this unit has been transfused", ErrInvalidUnit)
	case UnitDiscarded:
		return fmt.Errorf("%w: this unit has been discarded", ErrInvalidUnit)
	}
	c.Status = UnitQuarantined
	return nil
}

// DiscardReason is why a unit left the inventory (SRS-BLD-013).
//
// Coded, because the utilisation report SRS-BLD-015 asks for has to
// distinguish blood that was wasted from blood that was used: a hospital that
// discards for want of a fridge and one that discards after a positive test
// need different fixes.
type DiscardReason string

const (
	DiscardExpired     DiscardReason = "expired"
	DiscardTestFailed  DiscardReason = "test_failed"
	DiscardBreach      DiscardReason = "temperature_breach"
	DiscardTimeOut     DiscardReason = "out_of_time"
	DiscardDamaged     DiscardReason = "damaged"
	DiscardRecalled    DiscardReason = "recalled"
	DiscardReactionInv DiscardReason = "reaction_investigation"
)

var knownDiscardReasons = map[DiscardReason]bool{
	DiscardExpired: true, DiscardTestFailed: true, DiscardBreach: true,
	DiscardTimeOut: true, DiscardDamaged: true, DiscardRecalled: true,
	DiscardReactionInv: true,
}

// Discard takes a unit out of inventory for good (SRS-BLD-013).
func (c *Component) Discard(reason DiscardReason) error {
	if c.Status == UnitTransfused {
		return fmt.Errorf("%w: this unit has been transfused", ErrInvalidUnit)
	}
	if !knownDiscardReasons[reason] {
		return fmt.Errorf("%w: unknown discard reason %q", ErrInvalidUnit, reason)
	}
	c.Status = UnitDiscarded
	return nil
}
