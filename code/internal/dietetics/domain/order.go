package domain

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Route is how nutrition reaches the patient (SRS-DIET-002).
type Route string

const (
	RouteOral Route = "oral"
	// RouteEnteral is tube feeding. The regimen is an order in the orders
	// context; what is here is the fact that the patient is fed this way.
	RouteEnteral Route = "enteral"
	// RouteParenteral is intravenous. The bag is a prescription in the
	// medication context, for the same reason.
	RouteParenteral Route = "parenteral"
	// RouteNPO is nil by mouth. A route rather than a flag on one, because
	// an order that says "normal diet, and also nil by mouth" is an order two
	// people read two ways.
	RouteNPO Route = "npo"
)

var knownRoute = map[Route]bool{
	RouteOral: true, RouteEnteral: true,
	RouteParenteral: true, RouteNPO: true,
}

// Oral reports a route that produces a tray in the kitchen.
func (r Route) Oral() bool { return r == RouteOral }

// Texture is what the patient can physically manage (SRS-DIET-002).
//
// Configured codes rather than an enum, because the national descriptor
// frameworks differ and a hospital using one should not be forced through
// another's vocabulary. What the domain requires is that an oral order names
// one: a dysphagic patient sent a normal tray is an aspiration.
type Texture struct {
	Code string
	// Label is what appears on the tray card.
	Label string
	// FluidCode is the thickened-fluid level where the deployment separates
	// them, which most do.
	FluidCode string
}

// OrderState is where a diet order stands (SRS-DIET-002).
type OrderState string

const (
	// OrderPending is placed and not yet safe to cook to: a conflict against
	// the patient's allergies is open.
	OrderPending OrderState = "pending"
	OrderActive  OrderState = "active"
	// OrderSuperseded is an order a later one replaced.
	OrderSuperseded OrderState = "superseded"
	OrderCancelled  OrderState = "cancelled"
)

// DietOrder is what the patient is to be given (SRS-DIET-002).
//
// Effective-dated and superseded rather than edited, because SRS-DIET-002's
// acceptance is that the kitchen sees the current effective order only. An
// order edited in place would change what the kitchen cooked to yesterday,
// and the question after a wrong tray is always what the order said at the
// time.
type DietOrder struct {
	ID       string
	TenantID string

	PatientID   string
	EncounterID string
	FacilityID  string
	// WardID and BedID are where the tray goes. Carried on the order because
	// the census is built per ward and a patient who moved is a tray
	// delivered to an empty bed.
	WardID string
	BedID  string

	Route   Route
	Texture Texture
	// Restrictions are therapeutic: renal, low sodium, diabetic. Codes from
	// the deployment's own list.
	Restrictions []string
	// Supplements are prescribed oral nutritional supplements by code, which
	// the kitchen adds to the tray.
	Supplements []string
	Instruction string

	EffectiveFrom time.Time
	// EffectiveTo is when the order stops. Zero runs until something
	// supersedes it, which is the ordinary case for a diet.
	EffectiveTo time.Time

	State OrderState
	// Conflicts are unresolved allergy conflicts. An order with any is
	// pending and the kitchen never sees it.
	Conflicts []Conflict

	CancelledReason string
	CancelledBy     string
	CancelledAt     time.Time

	PlacedAt time.Time
	PlacedBy string
	Version  int64
}

// NewOrderInput places a diet order.
type NewOrderInput struct {
	PatientID     string
	EncounterID   string
	FacilityID    string
	WardID        string
	BedID         string
	Route         Route
	Texture       Texture
	Restrictions  []string
	Supplements   []string
	Instruction   string
	EffectiveFrom time.Time
	EffectiveTo   time.Time
}

// PlaceDietOrder records what the patient is to be given (SRS-DIET-002).
//
// conflicts are the allergy conflicts the caller found against the patient's
// documented allergies, which belong to the clinical context and are read
// rather than copied. An order placed with conflicts is pending, not active:
// SRS-DIET-003's acceptance is that a conflict requires authorised
// resolution, and an order the kitchen can already see is one nobody needs to
// resolve.
func PlaceDietOrder(id, tenantID string, in NewOrderInput,
	conflicts []Conflict, by string, now time.Time) (DietOrder, error) {

	switch {
	case strings.TrimSpace(id) == "":
		return DietOrder{}, fmt.Errorf("%w: an order needs an id",
			ErrInvalidDietetics)
	case strings.TrimSpace(in.PatientID) == "":
		return DietOrder{}, fmt.Errorf("%w: an order names its patient",
			ErrInvalidDietetics)
	case !knownRoute[in.Route]:
		return DietOrder{}, fmt.Errorf("%w: unknown route %q",
			ErrInvalidDietetics, in.Route)
	case in.EffectiveFrom.IsZero():
		// SRS-DIET-002 names the effective time, and SRS-DIET-009 turns on
		// it: an order with no effective time cannot be the one in force.
		return DietOrder{}, fmt.Errorf("%w: an order needs an effective time",
			ErrInvalidDietetics)
	case !in.EffectiveTo.IsZero() &&
		!in.EffectiveTo.After(in.EffectiveFrom):
		return DietOrder{}, fmt.Errorf("%w: that order ends before it starts",
			ErrInvalidDietetics)
	}

	if in.Route.Oral() && strings.TrimSpace(in.Texture.Code) == "" {
		// A dysphagic patient sent a normal tray is an aspiration, and the
		// way to stop it is to refuse an oral order that does not say what
		// the patient can manage.
		return DietOrder{}, fmt.Errorf(
			"%w: an oral order names the texture the patient can manage",
			ErrInvalidDietetics)
	}
	if in.Route == RouteNPO && (len(in.Restrictions) > 0 ||
		len(in.Supplements) > 0) {
		// Nil by mouth with a renal restriction and two supplements attached
		// is an order two people read two ways, and one of them sends a tray.
		return DietOrder{}, fmt.Errorf(
			"%w: nil by mouth carries no restrictions or supplements",
			ErrInvalidDietetics)
	}

	state := OrderActive
	if len(conflicts) > 0 {
		state = OrderPending
	}

	return DietOrder{
		ID: id, TenantID: tenantID,
		PatientID: in.PatientID, EncounterID: in.EncounterID,
		FacilityID: in.FacilityID, WardID: in.WardID, BedID: in.BedID,
		Route: in.Route,
		Texture: Texture{
			Code:      strings.TrimSpace(in.Texture.Code),
			Label:     strings.TrimSpace(in.Texture.Label),
			FluidCode: strings.TrimSpace(in.Texture.FluidCode),
		},
		Restrictions:  normalise(in.Restrictions),
		Supplements:   normalise(in.Supplements),
		Instruction:   strings.TrimSpace(in.Instruction),
		EffectiveFrom: in.EffectiveFrom.UTC(),
		EffectiveTo:   utcOrZero(in.EffectiveTo),
		State:         state, Conflicts: conflicts,
		PlacedAt: now.UTC(), PlacedBy: by, Version: 1,
	}, nil
}

// InForce reports an order the kitchen may cook to at a moment
// (SRS-DIET-002, SRS-DIET-009).
//
// Pending and cancelled orders are never in force. Pending because a conflict
// is unresolved; cancelled because SRS-DIET-009's acceptance is precisely
// that a cancelled diet is not dispatched after its effective time.
func (o DietOrder) InForce(at time.Time) bool {
	if o.State != OrderActive {
		return false
	}
	if at.Before(o.EffectiveFrom) {
		return false
	}
	return o.EffectiveTo.IsZero() || at.Before(o.EffectiveTo)
}

// Cancel stops an order (SRS-DIET-002, SRS-DIET-009).
func (o *DietOrder) Cancel(reason, by string, now time.Time) error {
	switch {
	case o.State == OrderCancelled:
		return fmt.Errorf("%w: this order is already cancelled",
			ErrInvalidDietetics)
	case strings.TrimSpace(reason) == "":
		return fmt.Errorf("%w: say why the diet is being stopped",
			ErrInvalidDietetics)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a cancellation names who made it",
			ErrInvalidDietetics)
	}

	o.State = OrderCancelled
	o.CancelledReason, o.CancelledBy = strings.TrimSpace(reason), by
	o.CancelledAt = now.UTC()
	// The order stops now rather than at some future time it was going to
	// run to. A cancellation that leaves the order in force until midnight is
	// a cancellation that sends supper.
	if o.EffectiveTo.IsZero() || o.EffectiveTo.After(now) {
		o.EffectiveTo = now.UTC()
	}
	return nil
}

// OrderInForce picks the one order the kitchen may cook to (SRS-DIET-002).
//
// The latest effective order that is in force at the moment asked about. One,
// never a list: a kitchen shown two current orders for one patient plates
// whichever is on top.
func OrderInForce(orders []DietOrder, at time.Time) (DietOrder, bool) {
	var best DietOrder
	found := false
	for _, order := range orders {
		if !order.InForce(at) {
			continue
		}
		if !found || order.EffectiveFrom.After(best.EffectiveFrom) ||
			(order.EffectiveFrom.Equal(best.EffectiveFrom) &&
				order.PlacedAt.After(best.PlacedAt)) {
			best, found = order, true
		}
	}
	return best, found
}

// Supersede marks an order replaced by a later one (SRS-DIET-002).
func (o *DietOrder) Supersede(at time.Time) {
	if o.State != OrderActive && o.State != OrderPending {
		return
	}
	o.State = OrderSuperseded
	if o.EffectiveTo.IsZero() || o.EffectiveTo.After(at) {
		o.EffectiveTo = at.UTC()
	}
}

// Conflict is a diet item against a documented allergy (SRS-DIET-003).
//
// The allergy is named by reference rather than copied. The clinical context
// owns what the patient is allergic to, and a second copy here would go stale
// the first time somebody corrected one — which is the correction that
// matters most.
type Conflict struct {
	// AllergyRef identifies the entry in the clinical record.
	AllergyRef string
	// Substance is the allergen's display, for the dietitian reading the
	// conflict. Carried for legibility and never relied on: the reference is
	// what a later question is answered against.
	Substance string
	// Item is the diet item, restriction or supplement that clashes.
	Item string
	// Severity is the clinical context's own grading. A conflict against an
	// anaphylaxis is not the same decision as one against an intolerance,
	// and the person resolving it needs to know which.
	Severity string

	ResolvedBy     string
	ResolvedAt     time.Time
	ResolutionNote string
}

// Resolved reports a conflict somebody has answered.
func (c Conflict) Resolved() bool { return !c.ResolvedAt.IsZero() }

// ResolveConflict authorises a diet item against a documented allergy
// (SRS-DIET-003).
//
// Requires a note as well as a name. "Resolved by Dr Rao" is not an answer to
// why a patient with a documented peanut allergy is being given a peanut
// supplement; what it is, is a name to put on it afterwards.
func (o *DietOrder) ResolveConflict(allergyRef, item, note, by string,
	now time.Time) error {

	switch {
	case strings.TrimSpace(note) == "":
		return fmt.Errorf(
			"%w: say why this item is safe for this patient",
			ErrInvalidDietetics)
	case strings.TrimSpace(by) == "":
		return fmt.Errorf("%w: a resolution names who authorised it",
			ErrInvalidDietetics)
	case o.State == OrderCancelled:
		return fmt.Errorf("%w: this order is cancelled",
			ErrInvalidDietetics)
	}

	found := false
	for i := range o.Conflicts {
		conflict := &o.Conflicts[i]
		if conflict.AllergyRef != allergyRef ||
			(item != "" && !strings.EqualFold(conflict.Item, item)) {
			continue
		}
		if conflict.Resolved() {
			continue
		}
		conflict.ResolvedBy, conflict.ResolvedAt = by, now.UTC()
		conflict.ResolutionNote = strings.TrimSpace(note)
		found = true
	}
	if !found {
		return fmt.Errorf("%w: no open conflict on %q for this order",
			ErrInvalidDietetics, allergyRef)
	}

	if o.State == OrderPending && len(o.OpenConflicts()) == 0 {
		o.State = OrderActive
	}
	return nil
}

// OpenConflicts lists the conflicts nobody has answered (SRS-DIET-003).
func (o DietOrder) OpenConflicts() []Conflict {
	var open []Conflict
	for _, conflict := range o.Conflicts {
		if !conflict.Resolved() {
			open = append(open, conflict)
		}
	}
	return open
}

// Allergen is one documented allergy, read from the clinical record
// (SRS-DIET-003).
type Allergen struct {
	Ref       string
	Substance string
	// Codes are the substance's identifiers in whatever terminologies the
	// clinical record carries. Matching is on these first, because matching
	// on a display string is how "peanut oil" gets past a peanut allergy.
	Codes    []string
	Severity string
}

// DietItem is something the kitchen would put on the tray (SRS-DIET-003).
type DietItem struct {
	// Code is the item's own identifier — a recipe, a supplement, a
	// restriction's implied component.
	Code string
	Name string
	// AllergenCodes are the allergens the item contains, from the same
	// terminologies the clinical record uses.
	AllergenCodes []string
}

// CheckConflicts finds diet items that clash with documented allergies
// (SRS-DIET-003).
//
// Matched on codes rather than on names. "Peanut oil" and "groundnut" are the
// same allergen and neither string contains the other, and a check that
// compared displays would pass both straight through to a patient who is
// anaphylactic to them.
//
// A name match is reported too, as a conflict rather than silently: a
// deployment whose item list is not coded yet gets a noisy check somebody has
// to resolve, which is the safe direction. What it must never do is find
// nothing because nothing was coded.
func CheckConflicts(items []DietItem, allergens []Allergen) []Conflict {
	var conflicts []Conflict
	for _, item := range items {
		for _, allergen := range allergens {
			if !clashes(item, allergen) {
				continue
			}
			conflicts = append(conflicts, Conflict{
				AllergyRef: allergen.Ref, Substance: allergen.Substance,
				Item: item.Name, Severity: allergen.Severity,
			})
		}
	}
	sort.SliceStable(conflicts, func(a, b int) bool {
		return conflicts[a].Item < conflicts[b].Item
	})
	return conflicts
}

func clashes(item DietItem, allergen Allergen) bool {
	for _, itemCode := range item.AllergenCodes {
		for _, allergenCode := range allergen.Codes {
			if itemCode != "" && strings.EqualFold(itemCode, allergenCode) {
				return true
			}
		}
	}
	if allergen.Substance == "" || item.Name == "" {
		return false
	}
	return strings.Contains(strings.ToLower(item.Name),
		strings.ToLower(allergen.Substance))
}
